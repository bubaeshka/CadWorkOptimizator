unit optimizator;

interface

uses System.SysUtils, System.Generics.Collections, System.Classes, Vcl.Dialogs;

type
  TBvnItem = class
  private
    TextContent:TStringList;
  end;


  TBvn = class
  private
    firstLine:String;
    BVInfo:TStringList;
    itemcount:integer;
    Items:TObjectList<TBvnItem>;
  public
    constructor Create(filename:TFileName; IMaxFileRecords:Integer); //парсинг данных
    destructor Destroy; override;
    function getFirstLine:String;
    procedure getBVInfo(sll:TStrings);
  end;

implementation


//в конструкторе парситься файл данных
constructor TBvn.Create(filename: TFileName; IMaxFileRecords:integer);
var f:TextFile;
    s:String;
    i, priznak, currentnum:integer;
begin
  inherited Create;
  if IMaxFileRecords<1 then
    raise ERangeError.Create('Неверное значение длинны считываемого файла '+IntTostr(IMaxFileRecords)+', проверьте ini');
  try
    AssignFile(f,filename);
    reset(f);
  except
    raise EInOutError.Create('Ошибка открытия файла данных');
  end;
  i:=0;
  priznak:=0;
  itemcount:=0;
  currentnum:=0;
  while not EOF(F) do begin
  //я думаю, что при преобразовании класс исключения будет EConverError
    i:=i+1; //счётчик
    readln(f,s);
    //алгоритм парсинга
    if i=1 then firstLine:=s; //первая строка со служебной информацией
    //отделение служебной BVNINFO информации
    if pos('BVINFO',s)<>0 then begin
      if not Assigned(BVInfo) then BVInfo:=TStringList.Create;
      inc(priznak);
      BVInfo.Add(s);
    end;
    //это не первая строка и не BVNINFO, а значит код программы, начинающийся с её номера
    if (i<>1) and (pos('BVINFO',s)=0) then begin
      if pos(' ',s)>0 then begin
        //получаем в itemcount номер текущей программы, к которой относится строка
        try
          itemcount:=StrToInt(copy(s, 1, pos(' ',s)-1));
        except
          raise EConvertError.Create('Неверное содержание BVN-файла или он повреждён. Код 2');
        end;
        //если номер текущей программы "свежий", то...
        if itemcount<>currentnum then begin
          //переключатель
          currentnum:=itemcount;
          //похоже без эксперимента не получится...
          ShowMessage(inttostr(itemcount));
        end;
      end else raise EConvertError.Create('Неверное содержание BVN-файла. Код 1');
    end;

    //конец алгоритма парсинга
    if i>IMaxFileRecords then raise   ////защита от зацикливания
      EConvertError.Create('Файл данных содержит свыше '+IntTostr(IMaxFileRecords)+' строк. Файл большой или проверьте ini');
  end;
  try
    closefile(f);
  except
    raise EInOutError.Create('Ошибка закрытия файла данных');
  end;
  
end;
//конец конструктора


//Деструктор - уничтожение объекта BVN
destructor TBVN.Destroy;
begin
  BVInfo.Free;
  inherited;
end;
//конец деструктора


//геттеры и сеттеры
function TBVN.getFirstLine: string;
begin
  Result:=firstLine;
end;

procedure TBVN.getBVInfo(sll: TStrings);
begin
  if assigned(BVInfo) then sll.Assign(BVInfo);
end;


end.
