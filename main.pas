unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Collections, System.IniFiles,
  optimizator;

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
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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


procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    if not assigned(BVN) then
    try
      BVN:=TBVN.Create(OpenDialog1.FileName, MaxFileRecords);
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
var opt:TDictionary<integer,integer>;
begin
  opt:=TDictionary<integer,integer>.Create;
  opt.Add(9300,2);
  opt.Add(8000,1);
  try
    BVN.optimize(opt);
  except
    on E: EnotImplemented do ShowMessage(E.Message);
  end;
  opt.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Ini:=TIniFile.Create(ExtractFileDir(Application.ExeName)+'\config.ini');
  try
    MaxFileRecords:=Ini.ReadInteger('File','MaxFileRecords',500000);
  finally
    Ini.Free;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  BVN.Free;
end;

end.
