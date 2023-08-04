program Scope;

uses
  Vcl.Forms,
  main in 'main.pas' {frmMain},
  ScopeDB in 'units\ScopeDB.pas',
  ScopeConsts in 'units\ScopeConsts.pas',
  Bug in 'units\Bug.pas',
  ScopeDBObjects in 'units\ScopeDBObjects.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Scope';
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
