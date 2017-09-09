{*******************************************************}
{                                                       }
{                 RWakeUp Version 2.3                   }
{                                                       }
{          Copyright (c) 1999-2016 Vadim Crits          }
{                                                       }
{*******************************************************}

unit RwMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ToolWin, ComCtrls, ImgList, Menus, ActnList, ExtCtrls, CBEx, LVEx,
  NetBase;

type
  TMainForm = class(TBaseForm)
    CoolBar: TCoolBarEx;
    StatusBar: TStatusBar;
    ListView: TListViewEx;
    MainMenu: TMainMenu;
    MenuBar: TToolBar;
    ToolBar: TToolBar;
    btnNew: TToolButton;
    btnOpen: TToolButton;
    btnSave: TToolButton;
    ImageList: TImageList;
    btnSeparator1: TToolButton;
    btnAddHost: TToolButton;
    btnRemoveHost: TToolButton;
    ActionList: TActionList;
    actSave: TAction;
    actSaveAs: TAction;
    actClose: TAction;
    actToolBar: TAction;
    actStatusBar: TAction;
    actAbout: TAction;
    actOpenRWakeUp: TAction;
    actExit: TAction;
    actAddHost: TAction;
    actRemoveHost: TAction;
    miFile: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    actNew: TAction;
    actOpen: TAction;
    miNew: TMenuItem;
    miOpen: TMenuItem;
    N1: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    N2: TMenuItem;
    miClose: TMenuItem;
    miAbout: TMenuItem;
    miList: TMenuItem;
    miToolBar: TMenuItem;
    miStatusBar: TMenuItem;
    actOptions: TAction;
    actCheckAll: TAction;
    miAddHost: TMenuItem;
    miRemoveHost: TMenuItem;
    N3: TMenuItem;
    miCheckAll: TMenuItem;
    Timer: TTimer;
    PopupMenu: TPopupMenu;
    miWakeup: TMenuItem;
    actStop: TAction;
    actStart: TAction;
    actOneHost: TAction;
    miOneHost: TMenuItem;
    N4: TMenuItem;
    miStart: TMenuItem;
    miStop: TMenuItem;
    N5: TMenuItem;
    miOptions: TMenuItem;
    btnOneHost: TToolButton;
    btnSeparator2: TToolButton;
    piOpen: TMenuItem;
    N7: TMenuItem;
    piExit: TMenuItem;
    btnStart: TToolButton;
    btnStop: TToolButton;
    btnOptions: TToolButton;
    btnSeparator3: TToolButton;
    btnSeparator4: TToolButton;
    N6: TMenuItem;
    piStart: TMenuItem;
    piStop: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actToolBarExecute(Sender: TObject);
    procedure actStatusBarExecute(Sender: TObject);
    procedure actAddHostExecute(Sender: TObject);
    procedure actRemoveHostExecute(Sender: TObject);
    procedure actCheckAllExecute(Sender: TObject);
    procedure actOneHostExecute(Sender: TObject);
    procedure actStartExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actOpenRWakeUpExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
  private
    { Private declarations }
    FModified: Boolean;
    FCheckedCount: Integer;
    FFileName: string;
    procedure CheckFileSave;
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);
    procedure SetFileName(const FileName: string);
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses RwNewHst, RwSend, RwOptions, RwConst, NetConst, NetUtils, NetAbout,
  Commctrl, ShellAPI, Registry, Math;

{$R *.dfm}

var
  IpBroadcast: string = '255.255.255.255';
  IpPort: Word = 9;
  WakeUpTime: TDateTime = 0.33333333333;
  WakeUpDays: TDays = [];

procedure TMainForm.CheckFileSave;
begin
  if FModified then
    case Application.MessageBox(PChar(Format(SConfirmSave, [FFileName])),
                                PChar(Application.Title),
                                MB_YESNOCANCEL or MB_ICONWARNING) of
      IDYES: actSave.Execute;
      IDNO: {Nothing};
      IDCANCEL: Abort;
    end;
end;

procedure TMainForm.LoadFromFile(const FileName: string);
var
  List: TStrings;
  I: Integer;
begin
  with TStringList.Create do
  try
    LoadFromFile(FileName);
    with ListView do
    begin
      Items.BeginUpdate;
      try
        Items.Clear;
        if Count > 0 then
        begin
          List := TStringList.Create;
          try
            for I := 0 to Count - 1 do
            begin
              List.Clear;
              ExtractStrings(['|'],[], PChar(Strings[I]), List);
              with Items.Add do
              try
                ImageIndex := 0;
                Checked := Boolean(List[0][1]);
                Caption := List[1];
                SubItems.Add(List[2]);
                SubItemImages[0] := 1;
              except
                Items.Clear;
                SetFileName(SUntitled);
                raise Exception.Create(SInvalidFileFormat);
              end;
            end;
          finally
            List.Free;
          end;
        end;
      finally
        Items.EndUpdate;
      end;
    end;
    SetFileName(FileName);
  finally
    Free;
    FModified := False;
  end;
end;

procedure TMainForm.SaveToFile(const FileName: string);
var
  I: Integer;
  S: string;
begin
  with TFileStream.Create(FileName, fmCreate) do
  try
    with ListView do
      for I := 0 to Items.Count - 1 do
      begin
        S := Format('%d|%s|%s'#13#10, [Ord(Items[I].Checked),
                                       Items[I].Caption,
                                       Items[I].SubItems[0]]);
        Write(PAnsiChar(AnsiString(S))^, Length(S));
      end;
    SetFileName(FileName);
  finally
    Free;
    FModified := False;
  end;
end;

procedure TMainForm.SetFileName(const FileName: string);
begin
  if FFileName <> FileName then
  begin
    FFileName := FileName;
    Caption := Format('%s - %s', [Application.Title, ExtractFileName(FFileName)]);
  end;
end;

procedure TMainForm.WMDropFiles(var Message: TWMDropFiles);
var
  FileName: array[0..MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Message.Drop, 0, FileName, MAX_PATH) > 0 then
    begin
      CheckFileSave;
      LoadFromFile(FileName);
      Message.Result := 0;
    end;
  finally
    DragFinish(Message.Drop);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  LastFile: string;
  dwExStyle: DWORD;
begin
  TrayMenu := PopupMenu;
  OnTrayDblClick := actOpenRWakeUpExecute;
  AddIcon;
  if (ParamCount > 0) and FileExists(ParamStr(1)) then
    LoadFromFile(ParamStr(1));
  with Registry do
    if OpenKey(ApplicationKey, False) then
    try
      if ValueExists(SShowToolBar) then
        ToolBar.Visible := ReadBool(SShowToolBar);
      if ValueExists(SShowStatusBar) then
        StatusBar.Visible := ReadBool(SShowStatusBar);
      if ValueExists(SIpBroadcast) then
        IpBroadcast := ReadString(SIpBroadcast);
      if ValueExists(SIpPort) then
        IpPort := ReadInteger(SIpPort);
      if ValueExists(SWakeUpTime) then
        WakeUpTime := ReadTime(SWakeUpTime);
      if ValueExists(SWakeUpDays) then
        ReadBinaryData(SWakeUpDays, WakeUpDays, SizeOf(WakeUpDays));
      if ValueExists(SLastFile) and (FFileName = '') then
      begin
        LastFile := ReadString(SLastFile);
        if FileExists(LastFile) then
          LoadFromFile(LastFile);
      end;
    finally
      CloseKey;
    end;
  with ListView do
  begin
    dwExStyle := ListView_GetExtendedListViewStyle(Handle);
    if dwExStyle and LVS_EX_SUBITEMIMAGES = 0 then
      ListView_SetExtendedListViewStyle(Handle, dwExStyle or LVS_EX_SUBITEMIMAGES);
  end;
  DragAcceptFiles(Handle, True);
  if FFileName = '' then
    SetFileName(SUntitled);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  Action := caNone;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  with Registry do
    if OpenKey(ApplicationKey, True) then
    try
      WriteBool(SShowToolBar, ToolBar.Visible);
      WriteBool(SShowStatusBar, StatusBar.Visible);
      WriteString(SIpBroadcast, IpBroadcast);
      WriteInteger(SIpPort, IpPort);
      WriteTime(SWakeUpTime, WakeUpTime);
      WriteBinaryData(SWakeUpDays, WakeUpDays, SizeOf(WakeUpDays));
      if FFileName <> SUntitled then
        WriteString(SLastFile, FFileName);
    finally
      CloseKey;
    end;
end;

procedure TMainForm.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  I, C: Integer;
begin
  C := 0;
  with (Sender as TListView) do
    for I := 0 to Items.Count - 1 do
      if Items[I].Checked then
        Inc(C);
  if FCheckedCount <> C then
    FModified := True;
  FCheckedCount := C;
end;

procedure TMainForm.ListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  case Data of
   -1: Compare := AnsiCompareText(Item1.Caption,
                                  Item2.Caption);
    0: Compare := AnsiCompareText(Item1.SubItems[Data],
                                  Item2.SubItems[Data]);
  end;
  if ListView.SortOrder = soDown then
    Compare := -Compare;
end;

procedure TMainForm.ListViewDblClick(Sender: TObject);
begin
  if (Sender as TListView).SelCount = 1 then
    actOneHost.Execute;
end;

procedure TMainForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with (Sender as TListView) do
  begin
    if Key = VK_RETURN then
      ListViewDblClick(Sender)
    else if (Key = VK_F2) and (SelCount = 1) then
      with TNewHostDialog.Create(Self) do
      try
        Caption := SEdit;
        edtHostName.Text := Selected.Caption;
        edtMacAddress.Text := Selected.SubItems[0];
        ShowModal;
        if ModalResult = mrOk then
        begin
          if edtHostName.Text <> Selected.Caption then
          begin
            Selected.Caption := edtHostName.Text;
            FModified := True;
          end;
          if edtMacAddress.Text <> Selected.SubItems[0] then
          begin
            Selected.SubItems[0] := edtMacAddress.Text;
            FModified := True;
          end;
        end;
      finally
        Free;
      end
    else if (Key = 65) and (Shift = [ssCtrl]) then
      SelectAll;
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  StartTime: TDateTime;
  I: Integer;
begin
  StartTime := Time - WakeUpTime;
  if (StartTime >= 0) and (StartTime <= 1 / 24 / 60) and (DayOfWeek(Now) in WakeUpDays) then
    with ListView do
      for I := 0 to Items.Count - 1 do
        if Items[I].Checked then
          SendMagicPacket(Items[I].SubItems[0], IpBroadcast, IpPort);
end;

procedure TMainForm.actNewExecute(Sender: TObject);
begin
  CheckFileSave;
  with ListView.Items do
  begin
    BeginUpdate;
    try
      Clear;
    finally
      EndUpdate;
    end;
  end;
  SetFileName(SUntitled);
  FModified := False;
end;

procedure TMainForm.actOpenExecute(Sender: TObject);
begin
  CheckFileSave;
  with TOpenDialog.Create(Self) do
  try
    Filter := Format(SFileFilter, [SDefExt, SDefExt]);
    if Execute then
      LoadFromFile(FileName);
  finally
    Free;
  end;
end;

procedure TMainForm.actSaveExecute(Sender: TObject);
begin
  if FFileName = SUntitled then
    actSaveAs.Execute
  else
    SaveToFile(FFileName);
end;

procedure TMainForm.actSaveAsExecute(Sender: TObject);
begin
  with TSaveDialog.Create(Self) do
  try
    Options := [ofEnableSizing, ofOverwritePrompt];
    DefaultExt := SDefExt;
    FileName := FFileName;
    Filter := Format(SFileFilter, [DefaultExt, DefaultExt]);
    if Execute then
      SaveToFile(FileName);
  finally
    Free;
  end;
end;

procedure TMainForm.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.actToolBarExecute(Sender: TObject);
begin
  ToolBar.Visible := not ToolBar.Visible;
end;

procedure TMainForm.actStatusBarExecute(Sender: TObject);
begin
  StatusBar.Visible := not StatusBar.Visible;
end;

procedure TMainForm.actAddHostExecute(Sender: TObject);
begin
  with TNewHostDialog.Create(Self) do
  try
    ShowModal;
    if ModalResult = mrOk then
    begin
      with ListView.Items.Add do
      begin
        Caption := edtHostName.Text;
        ImageIndex := 0;
        SubItems.Add(edtMacAddress.Text);
        SubItemImages[0] := 1;
      end;
      FModified := True;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.actRemoveHostExecute(Sender: TObject);
begin
  if Application.MessageBox(PChar(Format(SConfirmDelete, [ListView.SelCount])),
                            PChar(Application.Title),
                            MB_YESNO or MB_ICONWARNING) = IDYES then
    with ListView do
    begin
      if SelCount = 1 then
        Selected.Delete
      else
      begin
        Items.BeginUpdate;
        try
          while Assigned(Selected) do
            Selected.Delete;
        finally
          Items.EndUpdate;
        end;
      end;
      FModified := True;
    end;
end;

procedure TMainForm.actCheckAllExecute(Sender: TObject);
var
  I: Integer;
begin
  with ListView do
    for I := 0 to Items.Count - 1 do
      if not Items[I].Checked then
        Items[I].Checked := True;
end;

procedure TMainForm.actOneHostExecute(Sender: TObject);
var
  MacAddress: string;
begin
  MacAddress := '';
  if ListView.SelCount = 1 then
    MacAddress := ListView.Selected.SubItems[0];
  ShowSendDialog(Self, MacAddress, IpBroadcast, IpPort);
end;

procedure TMainForm.actStartExecute(Sender: TObject);
begin
  Timer.Enabled := True;
end;

procedure TMainForm.actStopExecute(Sender: TObject);
begin
  Timer.Enabled := False;
end;

procedure TMainForm.actOptionsExecute(Sender: TObject);
begin
  ShowOptionsDialog(Self, IpBroadcast, IpPort, WakeUpTime, WakeUpDays);
end;

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  ShowAboutDialog(Self);
end;

procedure TMainForm.actOpenRWakeUpExecute(Sender: TObject);
begin
  if Visible then
    SetForegroundWindow(Application.Handle)
  else
    Show;
  with Application do
    if IsIconic(Handle) then
    begin
      Restore;
      BringToFront;
    end;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  try
    CheckFileSave;
  except
    Exit;
  end;
  DeleteIcon;
  Application.Terminate;
end;

procedure TMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actToolBar.Checked := ToolBar.Visible;
  actStatusBar.Checked := StatusBar.Visible;
  actRemoveHost.Enabled := ListView.SelCount > 0;
  actCheckAll.Enabled := ListView.Items.Count > 0;
  actStart.Enabled := (FCheckedCount > 0) and not Timer.Enabled;
  actStop.Enabled := Timer.Enabled;
end;
    
end.
