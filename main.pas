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
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
