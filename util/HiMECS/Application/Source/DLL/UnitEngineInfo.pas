unit UnitEngineInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SBPro;

type
  TFrmEngineInfo = class(TForm)
    StatusBarPro1: TStatusBarPro;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure WMMDIActivate(var msg: TWMMDIACTIVATE); message WM_MDIACTIVATE;
  public
    { Public declarations }
  end;

var
  FrmEngineInfo: TFrmEngineInfo;

implementation

{$R *.dfm}

procedure Create_EngineInfop;
begin
  TFrmEngineInfo.Create(Application);
end;

procedure TFrmEngineInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//Get the previous deactivated form
procedure TFrmEngineInfo.WMMDIActivate(var msg: TWMMDIACTIVATE);
var
  deactivated: TWincontrol;
  deactivatedChild: TForm;
begin
  //find the control(form) being deactivated
  deactivated := FindControl(msg.DeactiveWnd);

  //if deactivated is a TForm.. do something...
  if Assigned(deactivated) and (deactivated is TForm) then
  begin
    deactivatedChild := TForm(deactivated);
    Caption := deactivatedChild.Caption;
  end;

end;

exports //The export name is Case Sensitive
  Create_EngineInfop;

end.
