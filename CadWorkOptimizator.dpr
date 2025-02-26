program CadWorkOptimizator;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  optimizator in 'optimizator.pas',
  BVNItem in 'BVNItem.pas',
  printPreview in 'printPreview.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
