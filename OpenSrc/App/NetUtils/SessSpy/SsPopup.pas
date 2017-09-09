unit SsPopup;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TPopupForm = class(TForm)
    imgStatus: TImage;
    lblComputer: TLabel;
    lblTime: TLabel;
    lblEvent: TLabel;
    Timer: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
  end;

  TSessionState = (ssConnected, ssDisconnected);

procedure ShowPopup(AOwner: TComponent; const AComputer: string;
  AState: TSessionState);

var
  PopupForm: TPopupForm;

implementation

uses NetConst, ShellAPI;

{$R *.dfm}

procedure ShowPopup(AOwner: TComponent; const AComputer: string;
  AState: TSessionState);

  function GetTaskBarPos: UINT;
  var
    AppBarData: TAppBarData;
  begin
    AppBarData.Hwnd := FindWindow('Shell_TrayWnd', nil);
    AppBarData.cbSize := SizeOf(TAppBarData);
    SHAppBarMessage(ABM_GETTASKBARPOS, AppBarData);
    Result := AppBarData.uEdge;
  end;

const
  SessionState: array[TSessionState] of string = (
    SConnected, SDisconnected);
  PopupColors: array[TSessionState] of TColor = ($80DC80, $C8C8C8);
  ResNames: array[TSessionState] of string = ('CONNECT', 'DISCONNECT');
var
  TaskBarPos: UINT;
  I: Integer;
begin
  Application.NormalizeTopMosts;
  PopupForm := TPopupForm.Create(AOwner);
  with PopupForm do
  begin
    lblComputer.Caption := AComputer;
    lblComputer.Font.Style := [fsBold];
    lblTime.Caption := FormatDateTime({$IF CompilerVersion > 22}
      FormatSettings.{$IFEND}ShortTimeFormat, Now);
    lblEvent.Caption := SessionState[AState];
    Color := PopupColors[AState];
    imgStatus.Picture.Bitmap.Handle := LoadBitmap(HInstance, PChar(ResNames[AState]));
    TaskBarPos := GetTaskBarPos;
    if TaskBarPos = ABE_LEFT then
      Left := Screen.WorkAreaLeft + 2
    else
      Left := Screen.WorkAreaWidth - Width - 2;
    if TaskBarPos = ABE_TOP then
      Top := Screen.WorkAreaTop + 2
    else
      Top := Screen.WorkAreaHeight - Height - 2;
    for I := 0 to Screen.FormCount - 1 do
      if (Screen.Forms[I] <> PopupForm) and (Screen.Forms[I].ClassType = ClassType) then
        if TaskBarPos = ABE_TOP then
        begin
          if Screen.Forms[I].Top >= Top then
            Top := Screen.Forms[I].Top + Height + 2;
        end
        else if Screen.Forms[I].Top <= Top then
          Top := Screen.Forms[I].Top - Height - 2;
    ShowWindow(Handle, SW_SHOWNOACTIVATE);
  end;
end;

procedure TPopupForm.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_LBUTTONDOWN, WM_RBUTTONDOWN:
      Close;
  else
    inherited WndProc(Message);
  end;
end;

procedure TPopupForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP or WS_BORDER;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS or CS_DROPSHADOW;
    if NewStyleControls then
      ExStyle := WS_EX_TOOLWINDOW;
  end;
end;

procedure TPopupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TPopupForm.TimerTimer(Sender: TObject);
begin
  Close;
end;

end.
