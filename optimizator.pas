unit optimizator;

interface

uses System.SysUtils, System.Generics.Collections, System.Classes, Vcl.Dialogs,
  BVNItem, Generics.Defaults;

type
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
    procedure getBVNItemTextContent(numofrec:integer; tccc:TStrings);
    function getBVNItemPartnumber(numofrecc:integer):String;
    function getBVNItemComment(numofreccc:integer):String;
    function getBVNItemLong(numofre:integer):Integer;
    function getBVNItemQuantity(numofr:integer):Integer;
    function getBVNCount:Integer;
    function getBVNItemID(numo:integer):Integer;
    procedure optimize(zagotovki:TDictionary<integer,integer>);
  end;

implementation



//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
///                                                                                                ///
///            Класс TBVN                                                                          ///
///                                                                                                ///
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

//в конструкторе парситься файл данных
constructor TBvn.Create(filename: TFileName; IMaxFileRecords:integer);
var f:TextFile;
    s:String;
    i, priznak, currentnum:integer;
    templist:TStringList;
    Item:TBVNItem;
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
  try
    templist:=TStringList.Create;  //создаём временный стринглист
    Items:=TObjectList<TBVNItem>.Create(True);
    //цикл чтения строк файла
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
            //если строка идёт без номера - аварийно вываливаемся
            raise EConvertError.Create('Неверное содержание BVN-файла или он повреждён. Код 2');
          end;
          //если номер текущей программы "свежий", то...
          if itemcount<>currentnum then begin
            //если текущий номер 0, то это первая строка первой программы, её не добавляем
            if currentnum<>0 then begin
              Item:=TBVNItem.Create(templist);
              Items.Add(Item);
              templist.Clear;
            end;
            //переключатель
            currentnum:=itemcount;
            //похоже без эксперимента не получится...
            //ShowMessage(inttostr(itemcount));
          end;
          templist.Add(s); //добавляем строку в темплист
          //дополнительная проверка, чтобы добавить последний объект, как от неё избавится?
          if EOF(f) then begin
            Item:=TBVNItem.Create(templist);
            Items.Add(Item);
            //ShowMessage(inttostr(itemcount));
          end;
        end else raise EConvertError.Create('Неверное содержание BVN-файла. Код 1');
      end;

        //конец алгоритма парсинга
        if i>IMaxFileRecords then raise   ////защита от зацикливания
          EConvertError.Create('Файл данных содержит свыше '+IntTostr(IMaxFileRecords)+' строк. Файл большой или проверьте ini');
    end;
  finally
    templist.Free;        //убиваем временный стринглист
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
  Items.Free;
  inherited;
end;
//конец деструктора

//оптимизатор
procedure TBVN.optimize(zagotovki: TDictionary<integer,integer>);
var item:TDictionary<integer,integer>;
    zz,xx:TList<TPair<integer,integer>>;
    el:TPair<integer,integer>;
    Comparison:TComparison<TPair<integer,integer>>; 
begin
  item:=TDictionary<integer,integer>.Create;
  //очень подозрительная хрень
  Comparison:=
    function(const Left, Rigth: TPair<integer,integer>): integer
    begin 
      Result:=Left.Value-Rigth.Value; 
    end;
  //конец подозрительной хрени
  xx:=TList<TPair<integer,integer>>.Create(TComparer<TPair<integer,integer>>.Construct(Comparison));
  //временно используем TDictionary, поэтому копируем в нашу сомнительную структуру
  zz:=TList<TPair<integer,integer>>.Create(TComparer<TPair<integer,integer>>.Construct(Comparison));
  for var Enum in zagotovki do zz.Add(Enum);  
  //поехали дальше

  //
  try
    for var Enum in Items do begin
      if Enum.getQuantity>1 then
        raise EnotImplemented.Create('Количество изделий больше 1 пока не поддерживается');
      el.Key:=Enum.getID;
      el.Value:=Enum.getLong;
      xx.Add(el);
    end;

    
    showmessage(inttostr(xx[0].Key));
  finally
    zz.Free;
    xx.Free;
    item.Free;
  end;
end;

//конец оптимизатора


//геттеры и сеттеры
function TBVN.getFirstLine: string;
begin
  Result:=firstLine;
end;

procedure TBVN.getBVInfo(sll: TStrings);
begin
  if assigned(BVInfo) then sll.Assign(BVInfo);
end;

procedure TBVN.getBVNItemTextContent(numofrec: Integer; tccc: TStrings);
begin
  if assigned(Items) and assigned(Items[numofrec]) then Items[numofrec].getTextContent(tccc);
end;

function TBVN.getBVNItemPartnumber(numofrecc: Integer): string;
begin
  Result:=Items[numofrecc].getPartNumber;
end;

function TBVN.getBVNItemComment(numofreccc: Integer): string;
begin
  Result:=Items[numofreccc].getComment;
end;

function TBVN.getBVNItemLong(numofre: Integer): Integer;
begin
  Result:=Items[numofre].getLong;
end;

function TBVN.getBVNItemQuantity(numofr: Integer): Integer;
begin
  Result:=Items[numofr].getQuantity;
end;

function TBVN.getBVNCount: Integer;
begin
  Result:=Items.Count;
end;

function TBVN.getBVNItemID(numo: Integer): Integer;
begin
  Result:=Items[numo].getID;
end;

end.
