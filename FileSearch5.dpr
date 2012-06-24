program FileSearch5;

{%TogetherDiagram 'ModelSupport_Project3\default.txaPackage'}

uses
  Forms,
  formMain in 'formMain.pas' {Form3},
  formResult in 'formResult.pas' {frmResult},
  basUnit in 'basUnit.pas',
  formProgress in 'formProgress.pas' {frmPregress};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TfrmPregress, frmPregress);
  Application.Run;
end.
