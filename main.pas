unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Collections, System.IniFiles,
  optimizator, Vcl.Grids, Vcl.ValEdit, Vcl.Buttons;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Button3: TButton;
    Memo4: TMemo;
    Button4: TButton;
    Edit6: TEdit;
    Button5: TButton;
    SaveDialog1: TSaveDialog;
    Button6: TButton;
    CheckBox1: TCheckBox;
    ValueListEditor1: TValueListEditor;
    Label1: TLabel;
    Label2: TLabel;
    Button7: TButton;
    Label3: TLabel;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    ValueListEditor2: TValueListEditor;
    CheckBox2: TCheckBox;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    spez:TDictionary<integer,integer>;
    curr:integer;
    procedure ShowItem(itn:integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  BVN:TBvn;
  Ini:TIniFile;
  MaxFileRecords:integer;


implementation

{$R *.dfm}

uses printPreview;


procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  if (curr-1)>=0 then begin
    curr:=curr-1;
    showItem(curr);

  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  if assigned(BVN) then
    if BVN.getBVNCount>(curr+1) then begin
      curr:=curr+1;
      showItem(curr);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    BVN.Free;
    try
      BVN:=TBVN.Create(OpenDialog1.FileName, MaxFileRecords);
      spez.Free;
      spez:=TDictionary<integer,integer>.Create;
      Form1.Caption:='Оптимизатор CadworkOptimizer '+OpenDialog1.FileName;
      Label3.Caption:='Количество изделий в файле: '+inttostr(BVN.getBVNCount);
      if BVN.getBVNCount>0 then ShowItem(0);

    except
      //идет работа под отладчиком и стоит флажок Stop on Delfi exceptions, поэтому увидеть можно запустив exe-шник
      on E: EInOutError do ShowMessage(E.Message); 
      on E: EConvertError do ShowMessage(E.Message);
      on E: ERangeError do ShowMessage(E.Message);
    end;
  end;
  //для проверки - удалить
  if Assigned(BVN) then begin
    Memo1.Lines.Add(BVN.getFirstLine);
    BVN.getBVInfo(Memo2.Lines);
    Memo2.Lines[1]:='борода';
    BVN.getBVInfo(Memo2.Lines);
  end;
end;

procedure TForm1.ShowItem(itn:integer);
begin
  if itn<>-1 then begin
    BVN.getBVNItemTextContent(itn,Memo3.Lines);
    Label6.Caption:=BVN.getBVNItemPartnumber(itn);
    Label12.Caption:=BVN.getBVNItemComment(itn);
    Label7.Caption:=FloatToStr(BVN.getBVNItemLong(itn)/10);
    Label10.Caption:=IntToStr(BVN.getBVNItemQuantity(itn));
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var opt, opti:TDictionary<integer,integer>;
    i,otp, nc:integer;
    zzz:boolean;
begin
  Memo4.Clear;
  if Trystrtoint(Edit2.Text,otp) then otp:=otp*10 else otp:=60;
  if not Trystrtoint(Edit3.Text,nc) then nc:=0;
  opt:=TDictionary<integer,integer>.Create;
  opti:=TDictionary<integer,integer>.Create;
  for i:=1 to ValueListEditor1.RowCount-1 do
    opt.Add(StrToInt(ValueListEditor1.Cells[0,i])*10,StrToInt(ValueListEditor1.Cells[1,i]));
  if CheckBox2.Checked then
  for i:=1 to ValueListEditor2.RowCount-1 do
    opti.Add(StrToInt(ValueListEditor2.Cells[0,i])*10,StrToInt(ValueListEditor2.Cells[1,i]));

  try
    BVN.optimize(opt, opti, spez, otp, nc, CheckBox1.Checked, CheckBox2.Checked, Memo4.Lines);
    ShowItem(0);
  except
    on E: EnotImplemented do ShowMessage(E.Message);
    on E: EArgumentException do ShowMessage(E.Message);
  end;
  Memo4.Lines.Add('-------------------------Спецификация------------------------------------------------');
  for var Enum in Spez do Memo4.Lines.AddPair(inttostr(Enum.Key div 10),inttostr(Enum.Value));

  opt.Free;
  opti.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  BVN.setBVNItemID(StrToInt(edit1.Text),StrToInt(edit6.Text))
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  BVN.setBVNItemComment(StrToInt(edit1.Text),edit6.Text);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if SaveDialog1.Execute then BVN.savetofile(SaveDialog1.FileName);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowItem(strtoint(edit1.text));
end;

procedure TForm1.FormCreate(Sender: TObject);
//var xx:TStrings;
begin
  //Ini:=TIniFile.Create(ExtractFileDir(Application.ExeName)+'\config.ini');
  Label3.Caption:='Файл не открыт';
  curr:=-1;
  MaxFileRecords:=500000;
  if FileExists(ExtractFileDir(Application.ExeName)+'\config.ini') then
    ValueListEditor1.Strings.LoadFromFile(ExtractFileDir(Application.ExeName)+'\config.ini');
 // try
  //  MaxFileRecords:=Ini.ReadInteger('File','MaxFileRecords',500000);
  //finally
  //  Ini.Free;
  //end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ValueListEditor1.Strings.SaveToFile(ExtractFileDir(Application.ExeName)+'\config.ini');
  spez.Free;
  BVN.Free;
end;

end.
