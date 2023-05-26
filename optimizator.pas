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
    procedure setBVNItemID(nu:Integer; nID:integer);
    procedure resort;
    function getBVNItemPartnumber(numofrecc:integer):String;
    function getBVNItemComment(numofreccc:integer):String;
    procedure setBVNItemComment(nfrec:integer; scomment:string);
    function getBVNItemLong(numofre:integer):Integer;
    function getBVNItemQuantity(numofr:integer):Integer;
    procedure savetofile(filenames:TFileName);
    function getBVNCount:Integer;
    function getBVNItemID(numo:integer):Integer;
    procedure optimize(zagotovki:TDictionary<integer,integer>; cut:integer; modf:boolean; spravka:TStrings);
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
    i, currentnum:integer;
    templist:TStringList;
    Item:TBVNItem;
    //priznak:integer;
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
  // priznak:=0;
  itemcount:=0;
  currentnum:=0;
  templist:=TStringList.Create;  //������ ��������� ����������
  try
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
       // inc(priznak);
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
procedure TBVN.optimize(zagotovki: TDictionary<integer,integer>; cut:integer; modf:boolean; spravka:TStrings);
var zz,xx,tt:TList<TPair<integer,integer>>;
    el:TPair<integer,integer>;
    ex:TPair<integer,String>;
    Comparison, Comparison1:TComparison<TPair<integer,integer>>;
    temp:String;
    outt,raskroi:TList<TPair<Integer, String>>;
    i,k,j,ostatok,iterations,ostatok2,minkey,minostatok,zagminostatok:integer;
    firstmin,lastmin,firstitem,lastitem,keyzag,m,n:integer;
    uspeh:boolean;
begin
  //������� ���������� �� �������� ������ �������
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
  //����� ������� ����������
  xx:=TList<TPair<integer,integer>>.Create(TComparer<TPair<integer,integer>>.Construct(Comparison));  //�������
  zz:=TList<TPair<integer,integer>>.Create(TComparer<TPair<integer,integer>>.Construct(Comparison1)); //���������
  outt:=TList<TPair<integer, string>>.Create; //��������� �������� ������
  tt:=TList<TPair<integer, integer>>.Create; //��������� ������, ��� ����������� ������ ���������
  raskroi:=TList<TPair<integer, string>>.Create; //������������� �������� ������
  //�������� ���������� TDictionary, ������� �������� ������� ������� �� ��������� � ������ ���������
  //� ��������, �� ��������, ��� ��� �������� � ����������� ������� �� ����� ���������, � ���������� ������� ���-��
  for var Enum in zagotovki do zz.Add(Enum);
  //������� ������
  zz.Sort; //��������� ��������� �� �������� ������
  //���� ������������ ��������, ��� ������������� ������
  try
    //���� ����������� ������� �� ����-������ �� ������� ������
    for var Enum in Items do begin
      if Enum.getQuantity>1 then
        raise EnotImplemented.Create('���������� ������� ������ 1 ���� �� ��������������');
      el.Key:=Enum.getID;
      el.Value:=Enum.getLong;
      xx.Add(el);
    end;
    xx.Sort; //��������� ������� �� �������� ������
    //��������� �� ������� �������� ������
    if xx.Count<1 then raise EArgumentException.Create('������ �����������');
    if zz.Count<1 then raise EArgumentException.Create('����� �����������');
    //���� �������, ���� �� ��������� �������
    i:=0; //������� �������
    minostatok:=0; //������������� ��� �����������
    //���� ������� ������-������� �� ���������� ���������
    while xx.Count>0 do begin
      uspeh:=false;   //������� ����-�� ������ �������
      if zz.Count<=0 then raise EArgumentException.Create('��������� ���������, � ������� ���');
      zagminostatok:=zz[0].Key; //����������� ������� - ������ ������������ ���������
      //�������� �� ����������
      for k:=0 to zz.Count-1 do begin
        //������� ��������� ������� ������, ����� ������ ���������
        tt.Clear;
        for var Enum in xx do tt.Add(Enum); //�������� � ��������� ������ �� ��������� ��� ������� k-�� ���������
        //���� ������ ������� � ��������� ��� � ������ �� ������ ���������
        if ((tt[0].Value+cut)<zz[k].Key) and ((zz[k].Value>0) or (zz[k].Value=-999)) then begin
          //��������� ����� �������, � Key ID �������
          ex.Key:=tt[0].Key;
          //� �������� ������ � ������� ���������
          ex.Value:='#'+IntToStr(i)+' � ���:'+inttostr(zz[k].Key)+' ����:'+inttostr(tt[0].Value)+' ���:'+inttostr(cut)
          +' �����:'+IntToStr(zz[k].Key-tt[0].Value-cut)+' F ';
          //��������� ������� � ��������� 1-�, ����� ������� ������� �� ��������� �������� ������
          ostatok:=zz[k].Key-tt[0].Value-cut;
          outt.Add(ex);
          //��� ��� ������ ������� �������� ������� �� ��������� �������� ������
          firstitem:=outt.Count-1;
          tt.Delete(0);
          uspeh:=true; //��� �������, ���� ������ �����������
          ///////////////////////////////////////////////////////////////////////////////////
          //��������� ����������� ������� ���������, �� ���������� ������� � ������� �������
          //����� ������ �������, ������� �� ������ -1, ��������� ������ ����� � ������� ������������ �������
          if modf then begin
            iterations:=0;
            ostatok2:=ostatok;
            //������ ������� ������ ������ ��������� � �������
            for j := tt.Count-1 downto 0 do begin
              iterations:=iterations+1;
              ostatok2:=ostatok2-tt[tt.Count-iterations].Value-cut;
              if ostatok2<0 then break;
            end;  
            //��������� � ������� ��� ������ ��������, �������� ������, ����� ����������
            for j := 1 to iterations-2 do begin
              ex.Key:=tt[tt.Count-j].Key;
              ostatok:=ostatok-tt[tt.Count-j].Value-cut;
              ex.Value:='#'+IntToStr(i)+' � ���:'+inttostr(zz[k].Key)+' ����:'+IntToStr(tt[tt.Count-j].Value)+
              ' ���:'+inttostr(cut)+' �����:'+IntToStr(ostatok)+' M ';
              outt.Add(ex);
              tt.Delete(tt.Count-j);
              if tt.Count<=0 then break;
            end;
          end;
          //���� ����������� ���������� ���������� ��������, ���� �� �� ������������
          if tt.Count>0 then minostatok:=ostatok-tt[tt.Count-1].Value-cut;
          minkey:=0; //���� ������ ����� �������, �� ������ ����� �� ����� 0
          for j := 1 to tt.Count-1 do begin
            ostatok2:=ostatok-tt[tt.Count-j].Value-cut;
            if (ostatok2<=minostatok) and (ostatok2>0) then begin
              minostatok:=(ostatok-tt[tt.Count-j].Value-cut);
              minkey:=tt.Count-j;
            end;
            //��� ��� ������ ������������ �� �����������, ��� ��������� ������, ������ ���� �� �����
            if ostatok2<0 then break;
          end;
          //����������� ���������� �������
          if minkey<>0 then begin
            ex.Key:=tt[minkey].Key;
            ostatok:=ostatok-tt[minkey].Value-cut;
            ex.Value:='#'+IntToStr(i)+' � ���:'+inttostr(zz[k].Key)+' ����:'+IntToStr(tt[minkey].Value)+
            ' ���:'+inttostr(cut)+' �����:'+IntToStr(ostatok)+' O ';
            outt.Add(ex);
            tt.Delete(minkey);
            if tt.Count<=0 then break;
          end;
          ///////////////
        end else break; //������� max �� ������ � ��������� k, ������ ��������� ������ - ����
        lastitem:=outt.Count-1;
        //����� ���������-������� � ����������� �������, ��� ������ �� break ��� ��� �������
        if ostatok<=zagminostatok then begin
           zagminostatok:=ostatok;
           //��������� � �������� ������� ������������ ������� � �������� ������
           firstmin:=firstitem;
           lastmin:=lastitem;
           //������� ���������� ����������� ���������
           keyzag:=k;
        end;
      end;
      //����� ����� �� ����������
      //�� ����� ������ �� ����������� � ����� �� ����������
      if not uspeh then raise EArgumentException.Create('������� �� ������� � ����� ������� ���������');
      //���������� ��������, ������� � �������� ������� � ����������� ����,
      //��� ��� �� ����� ����������-������������� ���������
      for k := firstmin to lastmin do begin
        //�� �� ��������
        if k=lastmin then begin
          ex:=outt[k];
          ex.Value:=ex.Value+' �����������:'+inttostr(zagminostatok)+' %: '
          +floattostrf(((zagminostatok/zz[keyzag].Key)*100),FFfixed,3,2);
          outt[k]:=ex;
        end;
        //�� ��
        //����
          ex:=outt[k];
          ex.Value:=inttostr(i+1)+'-'+inttostr(k-firstmin+1)+' '+inttostr(zz[keyzag].Key)+' |'
          +inttostr(ex.Key)+'| '+ex.Value;
          outt[k]:=ex;
        //����
        raskroi.Add(outt[k]); //��������� � �������� �������, �����������
        //������� �� ����� ������� ���������, �� ��� � �������
        for j:=0 to xx.Count-1 do
           if xx[j].Key=outt[k].Key
              then begin
                //��� ������ ����� ������� - �������� ����
                xx.Delete(j);
                break;
              end;
      end;
      outt.Clear;
      //������� ������������� ��������� �� ������ ���������, ���� �� ���� �������������
      if zz[keyzag].Value<>-999 then begin
        el:=zz[keyzag];
        el.Value:=zz[keyzag].Value-1;
        zz[keyzag]:=el;
        if el.Value=0 then zz.Delete(keyzag);
      end;
      i:=i+1;
    end;
    //������������ �����, ��� �������
    for var Enum in raskroi do spravka.Add(Enum.Value);
    //������� ���������� ������
    for m:=0 to raskroi.Count-1 do
      for n:=0 to Items.Count-1 do if raskroi[m].Key=items[n].getID then begin
        Items[n].setComment(raskroi[m].Value);
        Items.Move(n,m);
      end;
  finally
    outt.Free;
    zz.Free;
    xx.Free;
    tt.Free;
    raskroi.Free;
  end;
end;

//����� ������������
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

//���������� � ����
procedure TBVN.savetofile(filenames: TFileName);
var f1:TextFile;
    xxx:TStringList;
    i:integer;
begin
  assign(f1,filenames);
  rewrite(f1);
  xxx:=TStringList.Create;
  try
    writeln(f1,getfirstline);
    getBVInfo(xxx);
    for var Enum in xxx do writeln(f1,Enum);
    if Items.Count>1 then begin
      for i:=0 to Items.Count-1 do begin
        getBVNItemTextContent(i,xxx);
        for var Enum in xxx do writeln(f1,Enum);
      end;
    end;
  finally
    closefile(f1);
    xxx.Free;
  end;
end;

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

procedure TBVN.setBVNItemID(nu: Integer; nID: Integer);
var i:integer;
begin
  for i:=0 to Items.Count-1 do if Items[i].getID=nu then begin
   Items[i].setID(nID);
   break;
  end;
end;

procedure TBVN.setBVNItemComment(nfrec: Integer; scomment: string);
begin
  Items[nfrec].setComment(scomment);
end;

procedure TBVN.resort;
begin
  Items.Sort(TComparer<TBVNItem>.Construct(
  function (const L, R:TBVNItem):integer
  begin
    Result:=L.getID-R.getID;
  end
  ));
end;

end.
