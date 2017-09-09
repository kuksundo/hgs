unit CtMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, Menus, ImgList, CoolTrayIcon;

type
  TCoolMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    ShowWindow1: TMenuItem;
    HideWindow1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    rdoCycle: TRadioGroup;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Label7: TLabel;
    ComboBox1: TComboBox;
    Button4: TButton;
    N2: TMenuItem;
    BalloonHint1: TMenuItem;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Show1: TMenuItem;
    N3: TMenuItem;
    About1: TMenuItem;
    N4: TMenuItem;
    ImageList8: TImageList;
    ImageList1: TImageList;
    ImageList3: TImageList;
    ImageList4: TImageList;
    ImageList5: TImageList;
    ImageList6: TImageList;
    ImageList7: TImageList;
    procedure ShowWindow1Click(Sender: TObject);
    procedure HideWindow1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Show1Click(Sender: TObject);
  private
    // Some extra stuff necessary for the "Close to tray" option:
    SessionEnding: Boolean;
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;
  public
    FMainForm: TForm;
  end;

var
  CoolMainForm: TCoolMainForm;

implementation

uses Main;

{$R *.DFM}

procedure TCoolMainForm.ShowWindow1Click(Sender: TObject);
begin
  TrayIcon1.ShowMainForm;    // ALWAYS use this method to restore!!!
end;


procedure TCoolMainForm.HideWindow1Click(Sender: TObject);
begin
  Application.Minimize;      // Will hide dialogs and popup windows as well (this demo has none)
  TrayIcon1.HideMainForm;
end;


procedure TCoolMainForm.Exit1Click(Sender: TObject);
begin
  // We kill the "Close to tray" feature to be able to exit.
  if CheckBox6.Checked then
    CheckBox6.Checked := False;
  Close;
end;


procedure TCoolMainForm.Button1Click(Sender: TObject);
begin
  HideWindow1Click(Self);
end;


procedure TCoolMainForm.Button2Click(Sender: TObject);
begin
  TrayIcon1.IconVisible := not TrayIcon1.IconVisible;
end;


procedure TCoolMainForm.Button6Click(Sender: TObject);
begin
  if IsWindowVisible(Application.Handle) then
    TrayIcon1.HideTaskbarIcon
  else
    TrayIcon1.ShowTaskbarIcon;
end;


procedure TCoolMainForm.Button4Click(Sender: TObject);
begin
  TrayIcon1.ShowBalloonHint('Balloon hint',
        'Use the balloon hint to display important information.' + #13 +
        'The text can be max. 255 chars. and the title max. 64 chars.',
        bitInfo, 10);
end;


procedure TCoolMainForm.Button5Click(Sender: TObject);
begin
  TrayIcon1.HideBalloonHint;
end;


procedure TCoolMainForm.Button7Click(Sender: TObject);
begin
  TrayIcon1.SetFocus;
end;


procedure TCoolMainForm.Edit1Change(Sender: TObject);
begin
  TrayIcon1.Hint := Edit1.Text;
end;


procedure TCoolMainForm.CheckBox1Click(Sender: TObject);
begin
  TrayIcon1.ShowHint := CheckBox1.Checked;
end;


procedure TCoolMainForm.CheckBox2Click(Sender: TObject);
begin
  { Setting the popupmenu's AutoPopup to false will prevent the menu from displaying
    when you click the tray icon. You can still show the menu programmatically,
    using the Popup or PopupAtCursor methods. }
  if Assigned(PopupMenu1) then
    PopupMenu1.AutoPopup := CheckBox2.Checked;
end;


procedure TCoolMainForm.CheckBox3Click(Sender: TObject);
begin
  TrayIcon1.LeftPopup := CheckBox3.Checked;
end;


procedure TCoolMainForm.CheckBox4Click(Sender: TObject);
begin
  TrayIcon1.Enabled := CheckBox4.Checked;
end;


procedure TCoolMainForm.CheckBox5Click(Sender: TObject);
begin
  TrayIcon1.MinimizeToTray := CheckBox5.Checked;
end;


procedure TCoolMainForm.ComboBox1Change(Sender: TObject);
begin
  TrayIcon1.Behavior := TBehavior(ComboBox1.ItemIndex);
end;


procedure TCoolMainForm.WMQueryEndSession(var Message: TMessage);
{ This method is a hack. It intercepts the WM_QUERYENDSESSION message.
  This way we can decide if we want to ignore the "Close to tray" option.
  Otherwise, when selected, the option would make Windows unable to shut down. }
begin
  SessionEnding := True;
  Message.Result := 1;
end;


procedure TCoolMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ((not CheckBox6.Checked) or SessionEnding);
  if not CanClose then
  begin
    TrayIcon1.HideMainForm;
    TrayIcon1.IconVisible := True;
  end;
end;


procedure TCoolMainForm.Show1Click(Sender: TObject);
begin
  application.Restore;
  ShowWindow(Application.Handle, SW_HIDE);
  Show;
end;

end.

