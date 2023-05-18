unit BVNItem;

interface

uses System.SysUtils, System.Classes, Vcl.Dialogs;

type
  TBvnItem = class
  private
    TextContent:TStringList;
    long:integer;
    partnumber:String;
    comment:String;
  public
    constructor Create(inputlist:TStringList);
    destructor Destroy; override;
    procedure getTextContent(tcc:TStrings);
    function getPartNumber:String;
    function getComment:String;
  end;

implementation

//����������� ������-�������
constructor TBVNItem.Create(inputlist: TStringList);
/////////////////////////////////////////////////////////////////////////////////
///     ��������������� ��������� ������������
/////////////////////////////////////////////////////////////////////////////////

   ///�������� ������ ������
   procedure splitfirstline(sinp:String);
   begin
     delete(sinp,1,7);
     showmessage('='+sinp);
     partnumber:=copy(sinp,1,20);
     delete(sinp,1,20);
     //8 �������� ��������� ��� - �������
     //10 �������� - ��������� ������ �2, ��� - ���� ��� �� �����
     //����� ������ ���
     //��� ������� - �������, ���� �������� � ���� ������, ��� ������� � ������ ������ ��������, � ���������
     //�������� � �������� � ����� 3200, ��� ����� 29 ��������
     //��� ������� �����, ��� ��� �� ����� ����
     //��� ������� ����, ��� ������� ���������� ������������ � �����, �������� � 3202 - 31 ������
     //���� �������� - �����, �� ������� � 3201, ���� �� ������, 31 ������ � 3201
     //10 �������� ����, ����������� ������ ��, ���� ������ 8, �� �������� � 3202

     //������� ������� 42 �������, ������� ���� �� ��������
     delete(sinp,1,42);
     //�� � ������� 40 �������� �����������
     comment:=copy(sinp,0,40);
     showmessage('='+partnumber+'='+comment+'=');
   end;

/////////////////////////////////////////////////////////////////////////////////
begin
  TextContent:=TStringList.Create;
  TextContent.Assign(inputlist);
  splitfirstline(TextContent[0]);
end;
//����� ������������
/////////////////////////////////////////////////////////////////////////////////


//����������
destructor TBVNItem.Destroy;
begin
  TextContent.Free;
end;

//������� � ������� TBVNItem
procedure TBVNItem.getTextContent(tcc: TStrings);
begin
  if assigned(TextContent) then tcc.Assign(TextContent);
end;

function TBVNItem.getPartNumber: string;
begin
  Result:=partnumber;
end;

function TBVNItem.getComment: string;
begin
  Result:=comment;
end;

end.
