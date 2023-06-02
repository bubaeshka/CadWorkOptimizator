unit printPreview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, main, Vcl.ExtCtrls, printers, System.Generics.Collections;

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
    ListMetaFiles:TObjectList<TMetaFile>;
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
var tx,ty,dx,dy,nx,ny,otsx,i,j,k,count:integer;
    rr:TRect;
    new:boolean;
begin
  if assigned(BVN) then if BVN.getBVNCount>0 then begin
    i:=1; j:=1; Count:=BVN.getBVNCount-1;
    otsx:=round(hr/100); tx:=ho; ty:=vo; nx:=ho; ny:=vo; dy:=vo;
    new:=true;
    for k := 0 to Count do begin
      if new then begin
        tx:=ho; ty:=vo; nx:=ho; ny:=vo; dy:=vo;
        PrevMetafile:=TMetaFile.Create;
        PrevMetafile.Width:=ww;
        PrevMetafile.Height:=wh;
        MetaCanvas:=TMetaFileCanvas.Create(PrevMetafile,0);
        with MetaCanvas do begin
          Brush.Color:=clWhite;
          FillRect(Rect(0,0,ww,wh));
          Brush.Color:=clBlack;
          Font.Size:=100;
          MoveTo(ho,vo);
        end;
        new:=false;
      end;
      if i=1 then ny:=dy;
      dy:=round((vr/8)*j);
      dx:=round((hr/3))*i;
      with MetaCanvas do begin
        Pen.Color:=clRed;
        Brush.Style:=bsClear;
        Rectangle(tx,ty,dx,dy);
        Pen.Color:=clBlack;
        Font.Color:=clRed;
        //TextOut(dx-850,dy-250,IntToStr(dx)+' '+IntToStr(dy)+' '+IntToStr(k));
        TextOut(dx-950,dy-550,BVN.getBVNItemPartnumber(k));
        Font.Color:=clBlack;
        rr:=Rect(nx,ny,dx,dy);
        inflateRect(rr,-otsx,-otsx);
        Rectangle(rr);
        TextOut(rr.Right-1400,rr.Bottom-250,copy(BVN.getBVNItemComment(k),1,20));
      end;
      nx:=dx;
      i:=i+1;
      if i>3 then begin i:=1; j:=j+1; nx:=ho; end;
      if (j>8) or ((k=Count) and ((k mod 23)<>0)) then begin
        new:=true;
        j:=1;
        MetaCanvas.Free;
        ListMetaFiles.Add(PrevMetaFile);
      end;
    end;
    Image1.Canvas.StretchDraw(Rect(0,0,Image1.Width,Image1.Height),ListMetaFiles[0]);
    Label1.Caption:=IntToStr(ww)+' '+IntToStr(wh);
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
var i:integer;
begin
  try
    Printer.BeginDoc;
    i:=0;
    if assigned(ListMetaFiles) then if ListMetaFiles.Count>0 then
      for var Enum in ListMetaFiles do begin
        if i<>0 then Printer.NewPage;
        Printer.Canvas.StretchDraw(Rect(0,0,ww,wh),Enum);
        inc(i);
    end;
  finally
    Printer.EndDoc;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  ListMetaFiles:=TObjectList<TMetaFile>.Create(true);
  ww:=GetDeviceCaps(Printer.Handle,PHYSICALWIDTH);
  wh:=GetDeviceCaps(Printer.Handle,PHYSICALHEIGHT);
  hr:=GetDeviceCaps(Printer.Handle,HORZRES);
  vr:=GetDeviceCaps(Printer.Handle,VERTRES);
  ho:=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX);
  vo:=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY);
  kScale:=GetDeviceCaps(Printer.Handle,LOGPIXELSX)/Screen.PixelsPerInch;
  Label1.Caption:=FloatToStr(kScale);
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  ListMetaFiles.Free;
end;

end.
