unit printPreview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, main, Vcl.ExtCtrls, printers;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Button2: TButton;
    Label1: TLabel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    PrevMetafile:TMetafile;
    MetaCanvas:TMetaFileCanvas;
    kScale:real;
    ww,wh,hr,vr,ho,vo:integer;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;


implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.Button2Click(Sender: TObject);
var tx,ty,dx,dy,nx,ny,otsx,i:integer;
    rr:TRect;
begin
  MetaCanvas:=TMetaFileCanvas.Create(PrevMetafile,0);
  with MetaCanvas do begin
    Brush.Color:=clWhite;
    FillRect(Rect(0,0,ww,wh));
    Brush.Color:=clBlack;
    Font.Size:=100;
    MoveTo(ho,vo);
    otsx:=round(hr/100);
    tx:=ho;
    ty:=vo;
    nx:=ho;
    ny:=vo;
    for i:=1 to 4 do begin
      dx:=round((hr/4))*i;
      dy:=round((vr/4))*i;
      Pen.Color:=clRed;
      Brush.Style:=bsClear;
      Rectangle(tx,ty,dx,dy);
      Pen.Color:=clBlack;
      Font.Color:=clRed;
      TextOut(dx-700,dy-250,IntToStr(dx)+' '+IntToStr(dy));
      Font.Color:=clBlack;
      rr:=Rect(nx,ny,dx,dy);
      inflateRect(rr,-otsx,-otsx);
      Rectangle(rr);
      TextOut(rr.Width-700,rr.Height-250,IntToStr(rr.Width)+' '+IntToStr(rr.Height)+' '+IntTostr(-otsx));
      nx:=dx;
      ny:=dy;
    end;
    //tx:=Random(ww); ty:=Random(wh);
    LineTo(ww,wh);
    Label1.Caption:=IntToStr(ww)+' '+IntToStr(wh);
  end;
  MetaCanvas.Free;

  Image1.Canvas.StretchDraw(Rect(0,0,Image1.Width,Image1.Height),PrevMetaFile);
  //Image1.Picture.Metafile:=PrevMetaFile;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  try
    Printer.BeginDoc;
    Printer.Canvas.StretchDraw(Rect(0,0,ww,wh),PrevMetaFile);
    Printer.EndDoc;
  except
    on E: EPrinter do ShowMessage('Ошибка печати: '+E.Message);
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  PrevMetafile:=TMetaFile.Create;
  ww:=GetDeviceCaps(Printer.Handle,PHYSICALWIDTH);
  wh:=GetDeviceCaps(Printer.Handle,PHYSICALHEIGHT);
  hr:=GetDeviceCaps(Printer.Handle,HORZRES);
  vr:=GetDeviceCaps(Printer.Handle,VERTRES);
  ho:=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX);
  vo:=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY);
  PrevMetafile.Width:=ww;
  PrevMetafile.Height:=wh;
  kScale:=GetDeviceCaps(Printer.Handle,LOGPIXELSX)/Screen.PixelsPerInch;
  Label1.Caption:=FloatToStr(kScale);
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  PrevMetafile.Free;
end;

end.
