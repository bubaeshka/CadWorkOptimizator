unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Collections, System.IniFiles,
  optimizator, Vcl.Grids, Vcl.ValEdit;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Edit1: TEdit;
    Button2: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
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
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
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


procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    BVN.Free;
    try
      BVN:=TBVN.Create(OpenDialog1.FileName, MaxFileRecords);
      Form1.Caption:='Оптимизатор CadworkOptimizer '+OpenDialog1.FileName;
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

procedure TForm1.Button2Click(Sender: TObject);
begin
  BVN.getBVNItemTextContent(StrtoInt(Edit1.Text),Memo3.Lines);
  Edit2.Text:=BVN.getBVNItemPartnumber(StrtoInt(Edit1.Text));
  Edit3.Text:=BVN.getBVNItemComment(StrtoInt(Edit1.Text));
  Edit4.Text:=IntToStr(BVN.getBVNItemLong(StrtoInt(Edit1.Text)));
  Edit5.Text:=IntToStr(BVN.getBVNItemQuantity(StrtoInt(Edit1.Text)));
end;

procedure TForm1.Button3Click(Sender: TObject);
var opt, spez:TDictionary<integer,integer>;
    i:integer;
begin
  opt:=TDictionary<integer,integer>.Create;
  spez:=TDictionary<integer,integer>.Create;
  {opt.Add(63000,-999);
  opt.Add(80000,-999);
  opt.Add(93000,-999);
  opt.Add(72000,1);
  opt.Add(54000,1);
  opt.Add(123000,2);}
  for i:=1 to ValueListEditor1.RowCount-1 do
    opt.Add(StrToInt(ValueListEditor1.Cells[0,i])*10,StrToInt(ValueListEditor1.Cells[1,i]));

  try
    BVN.optimize(opt, spez, 50, CheckBox1.Checked, Memo4.Lines);
  except
    on E: EnotImplemented do ShowMessage(E.Message);
    on E: EArgumentException do ShowMessage(E.Message);
  end;
  for var Enum in Spez do Memo4.Lines.AddPair(inttostr(Enum.Key div 10),inttostr(Enum.Value));

  opt.Free;
  spez.Free;
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

procedure TForm1.FormCreate(Sender: TObject);
var xx:TStrings;
begin
  //Ini:=TIniFile.Create(ExtractFileDir(Application.ExeName)+'\config.ini');
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
  BVN.Free;
end;

end.
