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
    raise EInOutError.Create('������ �������� ����� ������');
  end;
  while not EOF(F) do begin
  //� �����, ��� ��� �������������� ����� ���������� ����� EConverError
    //raise EConvertError.Create('���� ��������');
    readln(f,s);
  end;
  try 
    closefile(f);
  except
    raise EInOutError.Create('������ �������� ����� ������');
  end;
  
end;

end.
