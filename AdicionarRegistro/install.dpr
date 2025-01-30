program install;

{$R *.dres}

uses
  Vcl.Forms,
  uInstalar in 'uInstalar.pas' {frmInstalar};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmInstalar, frmInstalar);
  Application.Run;
end.
