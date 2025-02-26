unit BVNItem;

interface

uses System.SysUtils, System.Classes, Vcl.Dialogs;

type
  TBvnItem = class
  private
    TextContent:TStringList;
    ID:Integer;
    long:integer;
    partnumber:String;
    comment:String;
    quantity:Integer;
    cut:Integer;
    width:Integer;
    heigth:Integer;
    const LID = 6;
    const LPARTNUMBER = 20;
    const LCOMMENT = 40;
    const LQUANTITY = 4;
    const LCUT = 8;
    const LWIDTH = 6;
    const LHEIGTH = 6;
    const LLONG = 6;
  public
    constructor Create(inputlist:TStringList);
    destructor Destroy; override;
    procedure getTextContent(tcc:TStrings);
    function getPartNumber:String;
    function getComment:String;
    function getLong:integer;
    function getQuantity:integer;
    function getID:Integer;
    procedure setID(newID:integer);
    procedure setComment(scom:string);
  end;

implementation

//����������� ������-�������
constructor TBVNItem.Create(inputlist: TStringList);
/////////////////////////////////////////////////////////////////////////////////
///     ��������������� ��������� ������������
/////////////////////////////////////////////////////////////////////////////////

   ///�������� ������ ������
   procedure splitfirstline(sinp:String; out in_partnumber, in_comment:String);
   begin
     try
       ID:=StrToInt(copy(sinp, 1, LID));
     except
       raise EConvertError.Create('�������� ���������� BVN-�����. ��� 8');
     end;
     //6 �������� ����� ������ + ����� ������
     delete(sinp,1,7);
     //showmessage('='+sinp);
     in_partnumber:=copy(sinp,1,LPARTNUMBER);
     delete(sinp,1,LPARTNUMBER);
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
     in_comment:=copy(sinp,1,LCOMMENT);
     delete(sinp,1,LCOMMENT);
   end;
   /////////////////////////////////////////////////////////////////////////////

   //�������� ������ ������
   procedure splitsecondline(inps:String; out in_quantity, in_cut, in_width, in_heigth, in_long:integer);
   begin
     try
       if StrToInt(copy(inps, 1, LID))<>ID then raise EConvertError.Create('�������� ���������� BVN-�����. ��� 10');
     except
       raise EConvertError.Create('�������� ���������� BVN-�����. ��� 9');
     end;
     //6 �������� ����� ������, ����� ������
     delete(inps,1,7);
     //12 ��������
     delete(inps,1,12);
     //4 ������� - ��� ���������� �������
     try
       in_quantity:=StrToInt(trim(copy(inps,1,LQUANTITY)));
     except
       raise EConvertError.Create('�������� ���������� BVN-�����. ��� 3');
     end;
     delete(inps,1,LQUANTITY);
     //8 �������� cut - ������ �����?
     try
       in_cut:=StrToInt(trim(copy(inps,1,LCUT)));
     except
       raise EConvertError.Create('�������� ���������� BVN-�����. ��� 4');
     end;
     delete(inps,1,LCUT);
     //��� �������
     delete(inps,1,2);
     //6 �������� ������ �����
     try
       in_width:=StrToInt(trim(copy(inps,1,LWIDTH)));
     except
       raise EConvertError.Create('�������� ���������� BVN-�����. ��� 5');
     end;
     delete(inps,1,LWIDTH);
     //��� �������
     delete(inps,1,2);
     //6 �������� ������ �����
     try
       in_heigth:=StrToInt(trim(copy(inps,1,LHEIGTH)));
     except
       raise EConvertError.Create('�������� ���������� BVN-�����. ��� 6');
     end;
     delete(inps,1,LHEIGTH);
     //��� �������
     delete(inps,1,2);
     //6 �������� ������ �����
     try
       in_long:=StrToInt(trim(copy(inps,1,LLONG)));
     except
       raise EConvertError.Create('�������� ���������� BVN-�����. ��� 7');
     end;
     delete(inps,1,LLONG);
   end;

/////////////////////////////////////////////////////////////////////////////////
begin
  TextContent:=TStringList.Create;
  TextContent.Assign(inputlist);
  splitfirstline(TextContent[0],partnumber,comment);
  splitsecondline(TextContent[1],quantity,cut,width,heigth,long);
  //showmessage('='+inttostr(quantity)+'='+inttostr(cut)+'='+inttostr(width)+'='+inttostr(heigth)+'='+inttostr(long));
  //showmessage('='+partnumber+'='+comment+'=');
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

function TBVNItem.getLong: Integer;
begin
  Result:=long;
end;

function TBVNItem.getQuantity: Integer;
begin
  Result:=quantity;
end;

function TBVNItem.getID: Integer;
begin
  Result:=ID;
end;

procedure TBVNItem.setID(newID: Integer);
var sr:string;
    i:integer;
begin
  if assigned(TextContent) then begin
    for i:=0 to TextContent.Count-1 do begin
      sr:=TextContent[i];
      delete(sr,1,6);
      sr:=Format('%.6d',[newID])+sr;
      TextContent[i]:=sr;
    end;
    ID:=newID;
  end;
end;


procedure TBVNItem.setComment(scom: string);
var stemp:string;
begin
  if assigned (TextContent) then begin
    stemp:=copy(TextContent[0],1,69);
    delete(scom,41,length(scom));
    stemp:=stemp+format('%40-s',[scom]);
    TextContent[0]:=stemp;
    Comment:=scom;
  end;
end;


end.
