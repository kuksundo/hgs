{-----------------------------------------------------------------------------
 Unit Name: frmBackupProgressU
 Author: Tristan Marlow
 Purpose: Backup and Shutdown Display Backup Progress.

 ----------------------------------------------------------------------------
 License
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU Library General Public License as
 published by the Free Software Foundation; either version 2 of
 the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Library General Public License for more details.
 ----------------------------------------------------------------------------

 History: 04/05/2007 - First Release.
          05/05/2007 - FIX: Vista TProgressBar not completing issue

-----------------------------------------------------------------------------}
unit frmBackupProgressU;

interface

uses
  ComObj,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, JvLabel, ComCtrls, JvProgressBar,
  Menus, JvExControls, JvFormPlacement, JvExComCtrls,
  ActnList, System.Actions;

const
  CLSID_TaskbarList: TGUID = (
    D1: $56FDF344; D2: $FD6D; D3: $11D0; D4: ($95, $8A, $00, $60, $97, $C9, $A0, $90));
  IID_TaskbarList: TGUID = (
    D1: $56FDF342; D2: $FD6D; D3: $11D0; D4: ($95, $8A, $00, $60, $97, $C9, $A0, $90));
  IID_TaskbarList2: TGUID = (
    D1: $602D4995; D2: $B13A; D3: $429B; D4: ($A6, $6E, $19, $35, $E4, $4F, $43, $17));
  IID_TaskbarList3: TGUID = (
    D1: $EA1AFB91; D2: $9E28; D3: $4B86; D4: ($90, $E9, $9E, $9F, $8A, $5E, $EF, $AF));

const
  THBF_ENABLED = $0000;
  THBF_DISABLED = $0001;
  THBF_DISMISSONCLICK = $0002;
  THBF_NOBACKGROUND = $0004;
  THBF_HIDDEN = $0008;

const
  THB_BITMAP  = $0001;
  THB_ICON    = $0002;
  THB_TOOLTIP = $0004;
  THB_FLAGS   = $0008;

const
  THBN_CLICKED = $1800;

const
  TBPF_NOPROGRESS = $00;
  TBPF_INDETERMINATE = $01;
  TBPF_NORMAL = $02;
  TBPF_ERROR  = $04;
  TBPF_PAUSED = $08;

const
  TBATF_USEMDITHUMBNAIL: DWORD   = $00000001;
  TBATF_USEMDILIVEPREVIEW: DWORD = $00000002;

const
  WM_DWMSENDICONICTHUMBNAIL = $0323;
  WM_DWMSENDICONICLIVEPREVIEWBITMAP = $0326;

type
  TTipString = array[0..259] of widechar;
  PTipString = ^TTipString;

  tagTHUMBBUTTON = packed record
    dwMask:  DWORD;
    iId:     UINT;
    iBitmap: UINT;
    hIcon:   HICON;
    szTip:   TTipString;
    dwFlags: DWORD;
  end;
  THUMBBUTTON     = tagTHUMBBUTTON;
  THUMBBUTTONLIST = ^THUMBBUTTON;

type
  ITaskbarList = interface
    ['{56FDF342-FD6D-11D0-958A-006097C9A090}']
    procedure HrInit; safecall;
    procedure AddTab(hwnd: cardinal); safecall;
    procedure DeleteTab(hwnd: cardinal); safecall;
    procedure ActivateTab(hwnd: cardinal); safecall;
    procedure SetActiveAlt(hwnd: cardinal); safecall;
  end;

  ITaskbarList2 = interface(ITaskbarList)
    ['{602D4995-B13A-429B-A66E-1935E44F4317}']
    procedure MarkFullscreenWindow(hwnd: cardinal; fFullscreen: Bool); safecall;
  end;

  ITaskbarList3 = interface(ITaskbarList2)
    ['{EA1AFB91-9E28-4B86-90E9-9E9F8A5EEFAF}']
    function SetProgressValue(hwnd: HWND; ullCompleted: ULONGLONG;
      ullTotal: ULONGLONG): HRESULT; stdcall;
    function SetProgressState(hwnd: HWND; tbpFlags: integer): HRESULT; stdcall;
    procedure RegisterTab(hwndTab: cardinal; hwndMDI: cardinal); safecall;
    procedure UnregisterTab(hwndTab: cardinal); safecall;
    procedure SetTabOrder(hwndTab: cardinal; hwndInsertBefore: cardinal); safecall;
    procedure SetTabActive(hwndTab: cardinal; hwndMDI: cardinal;
      tbatFlags: DWORD); safecall;
    procedure ThumbBarAddButtons(hwnd: cardinal; cButtons: UINT;
      Button: THUMBBUTTONLIST); safecall;
    procedure ThumbBarUpdateButtons(hwnd: cardinal; cButtons: UINT;
      pButton: THUMBBUTTONLIST); safecall;
    procedure ThumbBarSetImageList(hwnd: cardinal; himl: cardinal); safecall;
    procedure SetOverlayIcon(hwnd: cardinal; hIcon: HICON;
      pszDescription: LPCWSTR); safecall;
    procedure SetThumbnailTooltip(hwnd: cardinal; pszTip: LPCWSTR); safecall;
    procedure SetThumbnailClip(hwnd: cardinal; prcClip: PRect); safecall;
  end;

type
  TfrmBackupProgress = class(TForm)
    pnlMain:     TPanel;
    Panel1:      TPanel;
    pnlProgress: TPanel;
    lblBackupProgress: TLabel;
    lblProfileProgress: TLabel;
    ProgressBarProfile: TProgressBar;
    ProgressBarBackup: TProgressBar;
    pnlTotalProgress: TPanel;
    ProgressBarTotal: TJvProgressBar;
    lblProfileName: TLabel;
    Image1:      TImage;
    lblTotalProgress: TJvLabel;
    ActionListProgress: TActionList;
    ActionCancel: TAction;
    ActionHide:  TAction;
    Panel2: TPanel;
    btnCancel: TBitBtn;
    btnHide: TBitBtn;
    Panel3: TPanel;
    lblTimeElapsed: TLabel;
    lblTimeRemaining: TLabel;
    ImgHeader: TPanel;
    procedure pnlProgressMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ActionHideExecute(Sender: TObject);
    procedure ActionCancelExecute(Sender: TObject);
    procedure ActionCancelUpdate(Sender: TObject);
    procedure ActionHideUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
  private
    FOnCancel:    TNotifyEvent;
    FOnHide:      TNotifyEvent;
    FTaskBarFormHandle: THandle;
    FTaskbarList: ITaskbarList;
    FTaskbarList3: ITaskbarList3;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    procedure SetBackupProgress(AProgress: integer; AMessage: string = '');
    procedure SetProfileProgress(AProgress: integer; AMessage: string = '');
    procedure SetTotalProgress(AProgress: integer; AMessage: string = '');
    procedure SetTimeRemaining(ATimeRemaining: string = '');
    procedure SetTimeElapsed(ATimeElapsed: string = '');
    procedure SetBackupProfile(AProfileName: string = '');
    property OnCancel: TNotifyEvent Read FOnCancel Write FOnCancel;
    property OnHide: TNotifyEvent Read FOnHide Write FOnHide;
  end;

var
  frmBackupProgress: TfrmBackupProgress;

implementation



{$R *.dfm}

procedure TfrmBackupProgress.WMSysCommand(var Msg: TWMSysCommand);
begin
  if (Msg.CmdType and $FFF0) = SC_SCREENSAVE then
    Msg.Result := 0
  else
    inherited;
end;

procedure TfrmBackupProgress.pnlProgressMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
const
  SC_DRAGMOVE = $F012;
begin
  if Button = mbleft then
  begin
    ReleaseCapture;
    Self.Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmBackupProgress.ActionCancelExecute(Sender: TObject);
begin
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

procedure TfrmBackupProgress.ActionCancelUpdate(Sender: TObject);
begin
  ActionCancel.Enabled := Assigned(FOnCancel);
end;

procedure TfrmBackupProgress.ActionHideExecute(Sender: TObject);
begin
  if Assigned(FOnHide) then
  begin
    FOnHide(Self);
  end;
end;

procedure TfrmBackupProgress.ActionHideUpdate(Sender: TObject);
begin
  ActionHide.Enabled := Assigned(FOnHide);
end;

procedure TfrmBackupProgress.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style     := Params.Style and not WS_CAPTION;
  Params.WndParent := GetDesktopwindow;
end;

procedure TfrmBackupProgress.FormCreate(Sender: TObject);
begin
  // Windows 7
  FTaskBarFormHandle := 0;
  if CheckWin32Version(6, 1) then
  begin
    FTaskbarList := CreateComObject(CLSID_TaskbarList) as ITaskbarList;
    FTaskbarList.HrInit;
    Supports(FTaskbarList, IID_TaskbarList3, FTaskbarList3);
    if not Application.MainFormOnTaskBar then
    begin
      FTaskBarFormHandle := Application.Handle;
    end
    else
    begin
      FTaskBarFormHandle := Application.MainForm.Handle;
    end;
  end;
end;

procedure TfrmBackupProgress.FormDestroy(Sender: TObject);
begin
  if Assigned(FTaskbarList3) then
    FTaskbarList3.SetProgressState(FTaskBarFormHandle, TBPF_NOPROGRESS);

end;

procedure TfrmBackupProgress.SetBackupProgress(AProgress: integer;
  AMessage: string = '');
begin
  if AProgress <> ProgressBarBackup.Position then
  begin
    // 05/05/2007 - FIX: Vista TProgressBar not completing issue
    if (Win32MajorVersion = 6) then
    begin
      ProgressBarBackup.Position := AProgress + 2;
    end;
    ProgressBarBackup.Position := AProgress;
  end;
  if AMessage <> '' then
  begin
    if lblBackupProgress.Caption <> AMessage then
    begin
      lblBackupProgress.Caption := AMessage;
    end;
  end;
  Application.ProcessMessages;
end;

procedure TfrmBackupProgress.SetProfileProgress(AProgress: integer;
  AMessage: string = '');
begin
  if AProgress <> ProgressBarProfile.Position then
  begin
    // 05/05/2007 - FIX: Vista TProgressBar not completing issue
    if (Win32MajorVersion = 6) then
    begin
      ProgressBarProfile.Position := AProgress + 2;
    end;
    ProgressBarProfile.Position := AProgress;
  end;
  // Windows 7 Taskbar progress

  if (FTaskBarFormHandle <> 0) and (CheckWin32Version(6, 1)) then
  begin
    if Assigned(FTaskbarList3) then
      FTaskbarList3.SetProgressState(FTaskBarFormHandle, TBPF_NORMAL);
    if Assigned(FTaskbarList3) then
      FTaskbarList3.SetProgressValue(FTaskBarFormHandle, ProgressBarProfile.Position,
        ProgressBarProfile.Max);
  end;

  if AMessage <> '' then
    lblProfileProgress.Caption := AMessage + ' (' + IntToStr(AProgress) + '%)';
  Application.ProcessMessages;
end;

procedure TfrmBackupProgress.SetTotalProgress(AProgress: integer;
  AMessage: string = '');
begin
  if AProgress <> ProgressBarTotal.Position then
  begin
    // 05/05/2007 - FIX: Vista TProgressBar not completing issue
    if (Win32MajorVersion = 6) then
    begin
      ProgressBarTotal.Position := AProgress + 2;
    end;
    ProgressBarTotal.Position := AProgress;
  end;


  if AMessage <> '' then
    lblTotalProgress.Caption := AMessage;
  Application.ProcessMessages;
end;

procedure TfrmBackupProgress.SetTimeRemaining(ATimeRemaining: string = '');
begin
  if ATimeRemaining <> '' then
    lblTimeRemaining.Caption := ATimeRemaining;
end;

procedure TfrmBackupProgress.SetTimeElapsed(ATimeElapsed: string = '');
begin
  if ATimeElapsed <> '' then
    lblTimeElapsed.Caption := ATimeElapsed;
  Application.ProcessMessages;
end;

procedure TfrmBackupProgress.SetBackupProfile(AProfileName: string = '');
begin
  if AProfileName <> '' then
    lblProfileName.Caption := AProfileName;
  Application.ProcessMessages;
end;

end.

