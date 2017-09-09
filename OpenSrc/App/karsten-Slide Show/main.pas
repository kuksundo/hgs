unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ToolWin, ActnMan, ActnCtrls, XPStyleActnCtrls, ActnMenus;

type
  TMainForm = class(TForm)
    ActionManager1: TActionManager;
    ActionToolBar1: TActionToolBar;
    GreenAction: TAction;
    RedAction: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    procedure FormCreate(Sender: TObject);
    procedure ColorActionExecute(Sender: TObject);
    procedure ColorActionUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses testform;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  RedAction.Tag := clRed;
  GreenAction.Tag := clGreen;
end;

procedure TMainForm.ColorActionExecute(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Form1.Shape1.Brush.Color := TColor(Action.Tag);
end;

procedure TMainForm.ColorActionUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Checked := Form1.Shape1.Brush.Color = TColor(Action.Tag);
end;

end.
