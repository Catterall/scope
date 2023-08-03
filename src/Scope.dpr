program Scope;

uses
  Vcl.Forms,
  main in 'main.pas' {frmName},
  ScopeDB in 'units\ScopeDB.pas',
  ScopeConsts in 'units\ScopeConsts.pas',
  Bug in 'units\Bug.pas',
  ScopeDBObjects in 'units\ScopeDBObjects.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmName, frmName);
  Application.Run;
end.
