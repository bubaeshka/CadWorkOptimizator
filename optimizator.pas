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
    constructor Create(filename:TFileName; IMaxFileRecords:Integer); //������� ������
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
    procedure optimize(zagotovki:TDictionary<integer,integer>; cut:integer);
  end;

implementation



//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
///                                                                                                ///
///            ����� TBVN                                                                          ///
///                                                                                                ///
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

//� ������������ ��������� ���� ������
constructor TBvn.Create(filename: TFileName; IMaxFileRecords:integer);
var f:TextFile;
    s:String;
    i, priznak, currentnum:integer;
    templist:TStringList;
    Item:TBVNItem;
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
  try
    templist:=TStringList.Create;  //������ ��������� ����������
    Items:=TObjectList<TBVNItem>.Create(True);
    //���� ������ ����� �����
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
            //���� ������ ��� ��� ������ - �������� ������������
            raise EConvertError.Create('�������� ���������� BVN-����� ��� �� ��������. ��� 2');
          end;
          //���� ����� ������� ��������� "������", ��...
          if itemcount<>currentnum then begin
            //���� ������� ����� 0, �� ��� ������ ������ ������ ���������, � �� ���������
            if currentnum<>0 then begin
              Item:=TBVNItem.Create(templist);
              Items.Add(Item);
              templist.Clear;
            end;
            //�������������
            currentnum:=itemcount;
            //������ ��� ������������ �� ���������...
            //ShowMessage(inttostr(itemcount));
          end;
          templist.Add(s); //��������� ������ � ��������
          //�������������� ��������, ����� �������� ��������� ������, ��� �� �� ���������?
          if EOF(f) then begin
            Item:=TBVNItem.Create(templist);
            Items.Add(Item);
            //ShowMessage(inttostr(itemcount));
          end;
        end else raise EConvertError.Create('�������� ���������� BVN-�����. ��� 1');
      end;

        //����� ��������� ��������
        if i>IMaxFileRecords then raise   ////������ �� ������������
          EConvertError.Create('���� ������ �������� ����� '+IntTostr(IMaxFileRecords)+' �����. ���� ������� ��� ��������� ini');
    end;
  finally
    templist.Free;        //������� ��������� ����������
  end;

  try
    closefile(f);
  except
    raise EInOutError.Create('������ �������� ����� ������');
  end;

end;
//����� ������������


//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//���������� - ����������� ������� BVN
destructor TBVN.Destroy;
begin
  BVInfo.Free;
  Items.Free;
  inherited;
end;
//����� �����������

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//�����������
procedure TBVN.optimize(zagotovki: TDictionary<integer,integer>; cut:integer);
var item:TDictionary<integer,integer>;
    zz,xx:TList<TPair<integer,integer>>;
    el:TPair<integer,integer>;
    ex:TPair<integer,String>;
    Comparison, Comparison1:TComparison<TPair<integer,integer>>;
    temp:String;
    outt:TList<TPair<Integer, String>>;
    i,k,ostatok,iterations,ostatok2:integer;
begin
  item:=TDictionary<integer,integer>.Create;
  //������� ���������� �� �������� ������
  Comparison:=
    function(const Left, Rigth: TPair<integer,integer>): integer
    begin
      Result:=Rigth.Value-Left.Value;
    end;
  //������� ���������� �� �������� ������ ���������
  Comparison1:=
    function(const Left, Rigth: TPair<integer,integer>): integer
    begin
      Result:=Rigth.Key-Left.Key;
    end;
  //����� �������
  xx:=TList<TPair<integer,integer>>.Create(TComparer<TPair<integer,integer>>.Construct(Comparison));
  zz:=TList<TPair<integer,integer>>.Create(TComparer<TPair<integer,integer>>.Construct(Comparison1));
  outt:=TList<TPair<integer, string>>.Create;
  //�������� ���������� TDictionary, ������� �������� � ���� ������������ ���������
  for var Enum in zagotovki do zz.Add(Enum);
  //������� ������
  zz.Sort; //��������� ��������� �� �������� ������
  //
  try
    for var Enum in Items do begin
      if Enum.getQuantity>1 then
        raise EnotImplemented.Create('���������� ������� ������ 1 ���� �� ��������������');
      el.Key:=Enum.getID;
      el.Value:=Enum.getLong;
      xx.Add(el);
    end;
    xx.Sort; //��������� ������� �� �������� ������
    if xx.Count<1 then raise EArgumentException.Create('������ �����������');
    if zz.Count<1 then raise EArgumentException.Create('����� �����������');
    //���� �������, ���� �� ��������� �������
    i:=0; //�������
    k:=0; //������� ���������
    while xx.Count>0 do begin
      //���� ������ ������� � ��������� ��� � ������ �� ������ ���������
      if ((xx[1].Value+cut)<zz[k].Key) and ((zz[k].Value>0) or (zz[k].Value=-999)) then begin
        //��������� ����� �������, � Key ID �������
        ex.Key:=xx[1].Key;
        //� �������� ������ � ������� ���������
        ex.Value:=' #'+IntToStr(k)+' ����:'+inttostr(xx[1].Value)+' ���:'+inttostr(cut);
        ShowMessage(ex.Value);
        ostatok:=zz[k].Key-xx[1].Value-cut;
        ShowMessage(inttostr(ostatok));
        outt.Add(ex);
        xx.Delete(1);
        ///////////////
        iterations:=0;
        ostatok2:=0;
        repeat
          iterations:=iterations+1;
          ostatok2:=ostatok2+xx[xx.Count-iterations].Value+cut;
        until ostatok2>0;
        ///////////////
      end else raise EArgumentException.Create('������� �� ������� � ����� ������� ���������');
      i:=i+1;
    end;
    showmessage(inttostr(xx[0].Key));
  finally
    outt.Free;
    zz.Free;
    xx.Free;
    item.Free;
  end;
end;

//����� ������������
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

//������� � �������
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
