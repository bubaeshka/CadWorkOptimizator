unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Collections,
  optimizator;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  BVN:TBvn;

implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    if not assigned(BVN) then
    try
      BVN:=TBVN.Create(OpenDialog1.FileName);
    except
      //идет работа под отладчиком и стоит флажок Stop on Delfi exceptions, поэтому увидеть можно запустив exe-шник
      on E: EInOutError do ShowMessage(E.Message); 
    end;
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  BVN.Free;
end;

end.
