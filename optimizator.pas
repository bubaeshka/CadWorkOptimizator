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
    constructor Create(filename:TFileName; IMaxFileRecords:Integer); //������� ������
    destructor Destroy; override;
    function getFirstLine:String;
    procedure getBVInfo(sll:TStrings);
  end;

implementation


//� ������������ ��������� ���� ������
constructor TBvn.Create(filename: TFileName; IMaxFileRecords:integer);
var f:TextFile;
    s:String;
    i, priznak, currentnum:integer;
begin
  inherited Create;
  if IMaxFileRecords<1 then
    raise ERangeError.Create('�������� �������� ������ ������������ ����� '+IntTostr(IMaxFileRecords)+', ��������� ini');
  try
    AssignFile(f,filename);
    reset(f);
  except
    raise EInOutError.Create('������ �������� ����� ������');
  end;
  i:=0;
  priznak:=0;
  itemcount:=0;
  currentnum:=0;
  while not EOF(F) do begin
  //� �����, ��� ��� �������������� ����� ���������� ����� EConverError
    i:=i+1; //�������
    readln(f,s);
    //�������� ��������
    if i=1 then firstLine:=s; //������ ������ �� ��������� �����������
    //��������� ��������� BVNINFO ����������
    if pos('BVINFO',s)<>0 then begin
      if not Assigned(BVInfo) then BVInfo:=TStringList.Create;
      inc(priznak);
      BVInfo.Add(s);
    end;
    //��� �� ������ ������ � �� BVNINFO, � ������ ��� ���������, ������������ � � ������
    if (i<>1) and (pos('BVINFO',s)=0) then begin
      if pos(' ',s)>0 then begin
        //�������� � itemcount ����� ������� ���������, � ������� ��������� ������
        try
          itemcount:=StrToInt(copy(s, 1, pos(' ',s)-1));
        except
          raise EConvertError.Create('�������� ���������� BVN-����� ��� �� ��������. ��� 2');
        end;
        //���� ����� ������� ��������� "������", ��...
        if itemcount<>currentnum then begin
          //�������������
          currentnum:=itemcount;
          //������ ��� ������������ �� ���������...
          ShowMessage(inttostr(itemcount));
        end;
      end else raise EConvertError.Create('�������� ���������� BVN-�����. ��� 1');
    end;

    //����� ��������� ��������
    if i>IMaxFileRecords then raise   ////������ �� ������������
      EConvertError.Create('���� ������ �������� ����� '+IntTostr(IMaxFileRecords)+' �����. ���� ������� ��� ��������� ini');
  end;
  try
    closefile(f);
  except
    raise EInOutError.Create('������ �������� ����� ������');
  end;
  
end;
//����� ������������


//���������� - ����������� ������� BVN
destructor TBVN.Destroy;
begin
  BVInfo.Free;
  inherited;
end;
//����� �����������


//������� � �������
function TBVN.getFirstLine: string;
begin
  Result:=firstLine;
end;

procedure TBVN.getBVInfo(sll: TStrings);
begin
  if assigned(BVInfo) then sll.Assign(BVInfo);
end;


end.
