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
    Items:TObjectList<TBvnItem>;
  public
    constructor Create(filename:TFileName);
  end;

implementation

constructor TBvn.Create(filename: TFileName);
var f:TextFile;
    s:String;
begin
  inherited Create;
  try
    AssignFile(f,filename);
    reset(f);
  except
    raise EInOutError.Create('Ошибка открытия файла данных');
  end;
  while not EOF(F) do begin
  //я думаю, что при преобразовании класс исключения будет EConverError
    //raise EConvertError.Create('тест проверка');
    readln(f,s);
  end;
  try 
    closefile(f);
  except
    raise EInOutError.Create('Ошибка закрытия файла данных');
  end;
  
end;

end.
