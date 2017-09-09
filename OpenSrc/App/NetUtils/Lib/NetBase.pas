unit NetBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Registry, ShellAPI;

const
  WM_TRAYICON = WM_USER + 1;

type
  TBaseForm = class(TForm)
  private
    FRegistry: TRegistry;
    FFloatingPosition: Boolean;
    FApplicationKey: string;
    FNotifyIconData: TNotifyIconData;
    FTrayMenu: TPopupMenu;
    FOnTrayDblClick: TNotifyEvent;
    procedure WMSettingChange(var Message: TMessage); message WM_SETTINGCHANGE;
    procedure WMTrayIcon(var Message: TMessage); message WM_TRAYICON;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddIcon(const Tip: string = '');
    procedure ModifyIcon(const Tip: string);
    procedure DeleteIcon;
    property Registry: TRegistry read FRegistry;
    property ApplicationKey: string read FApplicationKey;
    property TrayMenu: TPopupMenu read FTrayMenu write FTrayMenu;
    property OnTrayDblClick: TNotifyEvent read FOnTrayDblClick write FOnTrayDblClick;
  end;

var
  BaseForm: TBaseForm;

implementation

uses NetConst, InitFont, StrUtils;

{$R *.dfm}

var
  RM_TaskbarCreated: DWORD;

const
  INIT_KEY = '\Software\NetUtils\';

constructor TBaseForm.Create(AOwner: TComponent);
var
  Position: TRect;
begin
  inherited Create(AOwner);
  FRegistry := TRegistry.Create;
  FFloatingPosition := not (Self.Position in
    [poScreenCenter, poDesktopCenter, poMainFormCenter, poOwnerFormCenter]);
  FApplicationKey := INIT_KEY +
    ChangeFileExt(ExtractFileName(Application.ExeName), '') + '\';
  if FFloatingPosition then
    with FRegistry do
      if OpenKey(FApplicationKey, False) then
      try
        if ValueExists(SPosition) then
        begin
          ReadBinaryData(SPosition, Position, SizeOf(Position));
          BoundsRect := Position;
        end;
        if ValueExists(SWindowState) then
          if ReadInteger(SWindowState) = Ord(wsMaximized) then
            WindowState := wsMaximized;
      finally
        CloseKey;
      end;
end;

destructor TBaseForm.Destroy;
var
  Position: TRect;
begin
  if FFloatingPosition then
    with FRegistry do
      if OpenKey(FApplicationKey, True) then
      try
        if WindowState = wsNormal then
        begin
          Position := BoundsRect;
          WriteBinaryData(SPosition, Position, SizeOf(Position));
        end;
        WriteInteger(SWindowState, Ord(WindowState));
      finally
        CloseKey;
      end;
  FRegistry.Free;
  inherited Destroy;
end;

procedure TBaseForm.WndProc(var Message: TMessage);
begin
  if Message.Msg = RM_TaskbarCreated then
    if Assigned(FTrayMenu) then
      AddIcon(FNotifyIconData.szTip);
  inherited WndProc(Message);
end;

procedure TBaseForm.WMSettingChange(var Message: TMessage);
var
  F: TFont;
{$IF CompilerVersion < 20}
  I: Integer;
{$IFEND}
begin
  inherited;
  if Message.WParam = SPI_SETNONCLIENTMETRICS then
    if ChangeDefFontData then
    begin
      F := TFont.Create;
      try
      {$IF CompilerVersion < 20}
        for I := 0 to Screen.FormCount - 1 do
          Screen.Forms[I].Font.Assign(F);
      {$ELSE}
        Application.DefaultFont.Assign(F);
      {$IFEND}
      finally
        F.Free
      end;
    end;
end;

procedure TBaseForm.WMTrayIcon(var Message: TMessage);
var
  P: TPoint;
begin
  case Message.LParam of
    WM_RBUTTONUP:
      begin
        if Assigned(Screen.ActiveForm) then
          SetForegroundWindow(Screen.ActiveForm.Handle);
        if Assigned(TrayMenu) then
        begin
          GetCursorPos(P);
          TrayMenu.Popup(P.X, P.Y);
        end;  
      end;
    WM_LBUTTONDBLCLK:
      if Assigned(FOnTrayDblClick) then
        FOnTrayDblClick(Self);
  end;
end;

procedure TBaseForm.AddIcon(const Tip: string = '');
begin
  with FNotifyIconData do
  begin
    cbSize := System.SizeOf(FNotifyIconData);
    Wnd := Handle;
    uID := UINT(Self);
    uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    hIcon := Application.Icon.Handle;
    uCallbackMessage := WM_TRAYICON;
    StrCopy(szTip, PChar(IfThen(Tip = '', Application.Title, Tip)));
  end;
  Shell_NotifyIcon(NIM_ADD, @FNotifyIconData);
end;

procedure TBaseForm.ModifyIcon(const Tip: string);
begin
  with FNotifyIconData do
  begin
    hIcon := Application.Icon.Handle;
    StrCopy(szTip, PChar(Tip));
  end;
  Shell_NotifyIcon(NIM_MODIFY, @FNotifyIconData);
end;

procedure TBaseForm.DeleteIcon;
begin
  Shell_NotifyIcon(NIM_DELETE, @FNotifyIconData);
end;

initialization
  RM_TaskbarCreated := RegisterWindowMessage('TaskbarCreated');
end.
