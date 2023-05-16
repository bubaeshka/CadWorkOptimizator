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
begin
  inherited Create;
  try
    AssignFile(f,filename);
    reset(f);
    closefile(f);
  except
    raise EInOutError.Create('Ошибка открытия файла данных');
  end;
end;

end.
