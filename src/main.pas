unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus,
  Vcl.StdStyleActnCtrls;

type
  TfrmName = class(TForm)
    ammb: TActionMainMenuBar;
    actList: TActionList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmName: TfrmName;

implementation

{$R *.dfm}

end.
