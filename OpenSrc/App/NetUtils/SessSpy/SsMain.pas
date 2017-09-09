{*******************************************************}
{                                                       }
{                Session Spy Version 1.3                }
{                                                       }
{          Copyright (c) 1999-2016 Vadim Crits          }
{                                                       }
{*******************************************************}

unit SsMain;

{$R-}
{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ActnList, Menus, ImgList, ExtCtrls, LVEx, NetBase;

type
  TMainForm = class(TBaseForm)
    lvSessions: TListViewEx;
    ActionList: TActionList;
    actCloseSession: TAction;
    actCloseOpenFile: TAction;
    actDisconnectAllSessions: TAction;
    actDisconnectAllOpenFiles: TAction;
    ListPopup: TPopupMenu;
    miCloseSession: TMenuItem;
    miDisconnectAllSessions: TMenuItem;
    lvOpenFiles: TListViewEx;
    miCloseOpenFile: TMenuItem;
    miDisconnectAllOpenFiles: TMenuItem;
    Timer: TTimer;
    actOpen: TAction;
    actExit: TAction;
    TrayPopup: TPopupMenu;
    piOpen: TMenuItem;
    N1: TMenuItem;
    piExit: TMenuItem;
    ImageList: TImageList;
    Splitter: TSplitter;
    StatusBar: TStatusBar;
    grbSettings: TGroupBox;
    chkStartup: TCheckBox;
    lblLogFile: TLabel;
    edtLogFile: TEdit;
    btnBrowse: TButton;
    btnApply: TButton;
    actApply: TAction;
    actAbout: TAction;
    piAbout: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure actCloseSessionExecute(Sender: TObject);
    procedure actDisconnectAllSessionsExecute(Sender: TObject);
    procedure actCloseOpenFileExecute(Sender: TObject);
    procedure actDisconnectAllOpenFilesExecute(Sender: TObject);
    procedure actApplyExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure lvOpenFilesDeletion(Sender: TObject; Item: TListItem);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure btnBrowseClick(Sender: TObject);
    procedure chkStartupClick(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FStartupModified: Boolean;
    FLogHandle: THandle;
    procedure GetSessions;
    procedure CloseSession(const ComputerName: string);
    procedure GetOpenFiles;
    procedure CloseOpenFile(FileId: DWORD);
    procedure CreateLogHandle(const FileName: string);
    procedure AppendItemToLog(Item: TListItem);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses SsConst, SsPopup, LMNet, NetUtils, NetConst, NetAbout, Math;

{$R *.dfm}

procedure TMainForm.GetSessions;

  function SecsToDateTime(dwSecs: DWORD): TDateTime;
  var
    TimeStamp: TTimeStamp;
  begin
    TimeStamp.Time := dwSecs * MSecsPerSec;
    TimeStamp.Date := DateDelta;
    Result := TimeStampToDateTime(TimeStamp);
  end;

const
  UserFlags: array[Boolean] of string = (SNo, SYes);
type
  PSessionInfoTable = ^TSessionInfoTable;
  TSessionInfoTable = array[0..0] of TSessionInfo2;
var
  dwResult, dwEntriesRead, dwTotalEntries, dwResumeHandle: DWORD;
  SessionInfoTable: PSessionInfoTable;
  I, J: Integer;
begin
  dwResumeHandle := 0;
  repeat
    dwResult := NetSessionEnum(nil, nil, nil, 2, Pointer(SessionInfoTable),
      MAX_PREFERRED_LENGTH, @dwEntriesRead, @dwTotalEntries, @dwResumeHandle);
    if dwResult in [NERR_Success, ERROR_MORE_DATA] then
    try
      with lvSessions do
      begin
        for I := 0 to dwEntriesRead - 1 do
        begin
          for J := 0 to Items.Count - 1 do
          begin
            if SessionInfoTable^[I].sesi2_cname = Items[J].Caption then
            begin
              Items[J].SubItems[1] := IntToStr(SessionInfoTable^[I].sesi2_num_opens);
              Items[J].SubItems[2] := FormatDateTime(
                {$IF CompilerVersion > 22}FormatSettings.{$IFEND}LongTimeFormat,
                SecsToDateTime(SessionInfoTable^[I].sesi2_time));
              Items[J].SubItems[3] := FormatDateTime(
                {$IF CompilerVersion > 22}FormatSettings.{$IFEND}LongTimeFormat,
                SecsToDateTime(SessionInfoTable^[I].sesi2_idle_time));
              Break;
            end;
            Application.ProcessMessages;  
          end;
          if J > Items.Count - 1 then
            with Items.Add do
            begin
              ImageIndex := 0;
              Caption := SessionInfoTable^[I].sesi2_cname;
              SubItems.Add(SessionInfoTable^[I].sesi2_username);
              SubItems.Add(IntToStr(SessionInfoTable^[I].sesi2_num_opens));
              SubItems.Add(FormatDateTime(
                {$IF CompilerVersion > 22}FormatSettings.{$IFEND}LongTimeFormat,
                SecsToDateTime(SessionInfoTable^[I].sesi2_time)));
              SubItems.Add(FormatDateTime(
                {$IF CompilerVersion > 22}FormatSettings.{$IFEND}LongTimeFormat,
                SecsToDateTime(SessionInfoTable^[I].sesi2_idle_time)));
              SubItems.Add(UserFlags[Boolean(SessionInfoTable^[I].sesi2_user_flags)]);
              SubItems.Add(SessionInfoTable^[I].sesi2_cltype_name);
              if FLogHandle <> INVALID_HANDLE_VALUE then
                AppendItemToLog(Items[Index]);
              if not Assigned(ItemFocused) then
                Items[0].Focused := True;
              if SessionInfoTable^[I].sesi2_time <= (Timer.Interval div MSecsPerSec) then
                ShowPopup(Self, Caption, ssConnected);
              ModifyIcon(Format(SSessSpyTip, [Application.Title,
                lvSessions.Items.Count, lvOpenFiles.Items.Count]));
            end;
          Application.ProcessMessages;  
        end;
        for I := Items.Count - 1 downto 0 do
        begin
          for J := 0 to dwEntriesRead - 1 do
          begin
            if Items[I].Caption = SessionInfoTable^[J].sesi2_cname then
              Break;
            Application.ProcessMessages;  
          end;
          if J > Integer(dwEntriesRead - 1) then
          begin
            ShowPopup(Self, Items[I].Caption, ssDisconnected);
            Items[I].Delete;
            ModifyIcon(Format(SSessSpyTip, [Application.Title,
              lvSessions.Items.Count, lvOpenFiles.Items.Count]));
          end;
          Application.ProcessMessages;
        end;
      end;
    finally
      if Assigned(SessionInfoTable) then
        NetApiBufferFree(SessionInfoTable);
    end
    else
      Break;
  until dwResult = NERR_Success;
end;

procedure TMainForm.CloseSession(const ComputerName: string);
begin
  NetSessionDel(nil, PWideChar(WideString('\\' + ComputerName)), nil);
end;

procedure TMainForm.GetOpenFiles;
const
  PermFlags: array[PERM_FILE_READ..PERM_FILE_CREATE] of string = (
    SRead, SWrite, '?', SCreate);
type
  PFileInfoTable = ^TFileInfoTable;
  TFileInfoTable = array[0..0] of TFileInfo3;
var
  dwResult, dwEntriesRead, dwTotalEntries, dwResumeHandle: DWORD;
  FileInfoTable: PFileInfoTable;
  I, J: Integer;
begin
  dwResumeHandle := 0;
  repeat
    dwResult := NetFileEnum(nil, nil, nil, 3, Pointer(FileInfoTable),
      MAX_PREFERRED_LENGTH, @dwEntriesRead, @dwTotalEntries, @dwResumeHandle);
    if dwResult in [NERR_Success, ERROR_MORE_DATA] then
    try
      with lvOpenFiles do
      begin
        for I := 0 to dwEntriesRead - 1 do
        begin
          for J := 0 to Items.Count - 1 do
          begin
            if FileInfoTable^[I].fi3_id = PDWORD(Items[J].Data)^ then
              Break;
            Application.ProcessMessages;
          end;
          if J > Items.Count - 1 then
            with Items.Add do
            begin
              ImageIndex := 1;
              Caption := FileInfoTable^[I].fi3_pathname;
              SubItems.Add(FileInfoTable^[I].fi3_username);
              SubItems.Add(IntToStr(FileInfoTable^[I].fi3_num_locks));
              if FileInfoTable^[I].fi3_permissions in [PERM_FILE_READ..PERM_FILE_CREATE] then
                SubItems.Add(PermFlags[FileInfoTable^[I].fi3_permissions])
              else
                SubItems.Add(PermFlags[2]);
              Data := AllocMem(SizeOf(DWORD));
              PDWORD(Data)^ := FileInfoTable^[I].fi3_id;
              if FLogHandle <> INVALID_HANDLE_VALUE then
                AppendItemToLog(Items[Index]);
              if not Assigned(ItemFocused) then
                Items[0].Focused := True;
              ModifyIcon(Format(SSessSpyTip, [Application.Title,
                lvSessions.Items.Count, lvOpenFiles.Items.Count]));
            end;
          Application.ProcessMessages;  
        end;
        for I := Items.Count - 1 downto 0 do
        begin
          for J := 0 to dwEntriesRead - 1 do
          begin
            if PDWORD(Items[I].Data)^ = FileInfoTable^[J].fi3_id then
              Break;
            Application.ProcessMessages;  
          end;
          if J > Integer(dwEntriesRead - 1) then
          begin
            Items[I].Delete;
            ModifyIcon(Format(SSessSpyTip, [Application.Title,
              lvSessions.Items.Count, lvOpenFiles.Items.Count]));
          end;
          Application.ProcessMessages;
        end;
      end;
    finally
      if Assigned(FileInfoTable) then
        NetApiBufferFree(FileInfoTable);
    end
    else
      Break;
  until dwResult = NERR_Success;
end;

procedure TMainForm.CloseOpenFile(FileId: DWORD);
begin
  NetFileClose(nil, FileId);
end;

procedure TMainForm.CreateLogHandle(const FileName: string);
begin
  FLogHandle := CreateFile(PChar(FileName),
                           GENERIC_READ or GENERIC_WRITE,
                           FILE_SHARE_READ or FILE_SHARE_WRITE,
                           nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if FLogHandle <> INVALID_HANDLE_VALUE then
    SetFilePointer(FLogHandle, 0, nil, FILE_END);
end;

procedure TMainForm.AppendItemToLog(Item: TListItem);
var
  LogStr: string;
  lpNumberOfBytesWritten: DWORD;
begin
  if Item.ListView = lvSessions then
    LogStr := Format('[%s %s]: %s:  %-15s %s: %-15s %s: %s'#13#10, [
      FormatDateTime({$IF CompilerVersion > 22}FormatSettings.{$IFEND}ShortDateFormat, Now),
      FormatDateTime({$IF CompilerVersion > 22}FormatSettings.{$IFEND}LongTimeFormat, Now),
      lvSessions.Columns[0].Caption, Item.Caption,
      lvSessions.Columns[1].Caption, Item.SubItems[0],
      lvSessions.Columns[5].Caption, Item.SubItems[4]])
  else
    LogStr := Format('[%s %s]: %s: %-255s %s: %-15s %s: %s'#13#10, [
      FormatDateTime({$IF CompilerVersion > 22}FormatSettings.{$IFEND}ShortDateFormat, Now),
      FormatDateTime({$IF CompilerVersion > 22}FormatSettings.{$IFEND}LongTimeFormat, Now),
      lvOpenFiles.Columns[0].Caption, Item.Caption,
      lvOpenFiles.Columns[1].Caption, Item.SubItems[0],
      lvOpenFiles.Columns[3].Caption, Item.SubItems[2]]);
  WriteFile(FLogHandle, PAnsiChar(AnsiString(LogStr))^, Length(LogStr), lpNumberOfBytesWritten, nil);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  with Registry do
  begin
    if OpenKey(ApplicationKey, False) then
    try
      if ValueExists(SLogFile) then
      begin
        edtLogFile.Text := ReadString(SLogFile);
        CreateLogHandle(edtLogFile.Text);
        edtLogFile.Modified := False;
      end
      else
        FLogHandle := INVALID_HANDLE_VALUE;
    finally
      CloseKey;
    end;
    if OpenKey(RUN_KEY, False) then
    try
      chkStartup.Checked := ValueExists(Application.Title);
      FStartupModified := False;
    finally
      CloseKey;
    end;
  end;
  TrayMenu := TrayPopup;
  OnTrayDblClick := actOpenExecute;
  AddIcon(Format(SSessSpyTip, [Application.Title,
    lvSessions.Items.Count, lvOpenFiles.Items.Count]));
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  Action := caNone;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if FLogHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FLogHandle);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  btnApply.Left := grbSettings.Width - btnApply.Width - 6;
  btnBrowse.Left := btnApply.Left - btnBrowse.Width - 14;
  edtLogFile.Width := grbSettings.Width - edtLogFile.Left -
    (grbSettings.Width - btnBrowse.Left);
end;

procedure TMainForm.actCloseSessionExecute(Sender: TObject);
var
  I: Integer;
begin
  with lvSessions do
    if SelCount = 1 then
      CloseSession(Selected.Caption)
    else
      for I := Items.Count - 1 downto 0 do
        if Items[I].Selected then
          CloseSession(Items[I].Caption);
end;

procedure TMainForm.actDisconnectAllSessionsExecute(Sender: TObject);
var
  I: Integer;
begin
  with lvSessions do
    for I := Items.Count - 1 downto 0 do
      CloseSession(Items[I].Caption);
end;

procedure TMainForm.actCloseOpenFileExecute(Sender: TObject);
var
  I: Integer;
begin
  with lvOpenFiles do
    if SelCount = 1 then
      CloseOpenFile(PDWORD(Selected.Data)^)
    else
      for I := Items.Count - 1 downto 0 do
        if Items[I].Selected then
          CloseOpenFile(PDWORD(Items[I].Data)^);
end;

procedure TMainForm.actDisconnectAllOpenFilesExecute(Sender: TObject);
var
  I: Integer;
begin
  with lvOpenFiles do
    for I := Items.Count - 1 downto 0 do
      CloseOpenFile(PDWORD(Items[I].Data)^);
end;

procedure TMainForm.actApplyExecute(Sender: TObject);
begin
  Timer.Enabled := False;
  try
    with Registry do
    begin
      if FStartupModified then
        if OpenKey(RUN_KEY, False) then
        try
          if chkStartup.Checked and not ValueExists(Application.Title) then
            WriteString(Application.Title, Application.ExeName)
          else if ValueExists(Application.Title) then
            DeleteValue(Application.Title);
          FStartupModified := False;
        finally
          CloseKey;
        end;
      if edtLogFile.Modified then
        if OpenKey(ApplicationKey, True) then
        try
          if edtLogFile.Text <> '' then
          begin
            if FLogHandle <> INVALID_HANDLE_VALUE then
              CloseHandle(FLogHandle);
            CreateLogHandle(edtLogFile.Text);
            if FLogHandle <> INVALID_HANDLE_VALUE then
              WriteString(SLogFile, edtLogFile.Text)
            else
              raise Exception.Create(SysErrorMessage(GetLastError));
          end
          else
          begin
            if FLogHandle <> INVALID_HANDLE_VALUE then
              CloseHandle(FLogHandle);
            DeleteValue(SLogFile);
          end;
          edtLogFile.Modified := False;
        finally
          CloseKey;
        end;
    end;
  finally
    Timer.Enabled := True;
  end;
end;

procedure TMainForm.actOpenExecute(Sender: TObject);
begin
  if Visible then
    SetForegroundWindow(Application.Handle)
  else
  begin
    Show;
  end;  
  with Application do
    if IsIconic(Handle) then
    begin
      Restore;
      BringToFront;
    end;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  DeleteIcon;
  Application.Terminate;
end;

procedure TMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actCloseSession.Enabled := lvSessions.Focused and (lvSessions.SelCount > 0);
  actCloseSession.Visible := actCloseSession.Enabled;
  actDisconnectAllSessions.Enabled := lvSessions.Focused and
    (lvSessions.Items.Count > 0) and (lvSessions.SelCount = 0);
  actDisconnectAllSessions.Visible := actDisconnectAllSessions.Enabled;
  actCloseOpenFile.Enabled := lvOpenFiles.Focused and (lvOpenFiles.SelCount > 0);
  actCloseOpenFile.Visible := actCloseOpenFile.Enabled;
  actDisconnectAllOpenFiles.Enabled := lvOpenFiles.Focused and
    (lvOpenFiles.Items.Count > 0) and (lvOpenFiles.SelCount = 0);
  actDisconnectAllOpenFiles.Visible := actDisconnectAllOpenFiles.Enabled;
  actApply.Enabled := FStartupModified or edtLogFile.Modified;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  GetSessions;
  StatusBar.Panels[0].Text := Format(SSessions, [lvSessions.Items.Count]);
  GetOpenFiles;
  StatusBar.Panels[1].Text := Format(SOpenFiles, [lvOpenFiles.Items.Count]);
end;

procedure TMainForm.lvOpenFilesDeletion(Sender: TObject; Item: TListItem);
begin
  Dispose(Item.Data);
end;

procedure TMainForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 65) and (Shift = [ssCtrl]) then
    (Sender as TListView).SelectAll;
end;

procedure TMainForm.ListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  case Data of
    -1:
      Compare := AnsiCompareText(Item1.Caption, Item2.Caption);
    0, 2, 3, 4, 5:
      Compare := AnsiCompareText(Item1.SubItems[Data],
                                 Item2.SubItems[Data]);
    1:
      Compare := AnsiCompareText(AlignString(Item1.SubItems[Data]),
                                 AlignString(Item2.SubItems[Data]));
  end;
  if TListViewEx(Sender).SortOrder = soDown then
    Compare := -Compare;
end;

procedure TMainForm.btnBrowseClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
  try
    Filter := Format(SFileFilter, [SDefExt, SDefExt]);
    if Execute then
    begin
      edtLogFile.Text := FileName;
      edtLogFile.Modified := True;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.chkStartupClick(Sender: TObject);
begin
  FStartupModified := True;
end;

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  ShowAboutDialog(Self);
end;

end.
