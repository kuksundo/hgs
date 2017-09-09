{*******************************************************}
{                                                       }
{                  SnmpEye Version 1.6                  }
{                                                       }
{          Copyright (c) 1999-2016 Vadim Crits          }
{                                                       }
{*******************************************************}

unit SeMain;

{$R-}
{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, ToolWin, Menus, ActnList, StdCtrls, ImgList, Snmp, CBEx,
  NetBase;

type
  TActionCommand = (acGet, acGetNext, acWalk);

  TMainForm = class(TBaseForm)
    StatusBar: TStatusBar;
    ActionList: TActionList;
    actSave: TAction;
    actSaveAs: TAction;
    actExit: TAction;
    actToolBar: TAction;
    actStatusBar: TAction;
    actGet: TAction;
    actGetNext: TAction;
    actAbout: TAction;
    actWalk: TAction;
    ListView: TListView;
    ImageList: TImageList;
    actRun: TAction;
    actClear: TAction;
    actOptions: TAction;
    CoolBar: TCoolBarEx;
    MenuBar: TToolBar;
    actDetails: TAction;
    actStop: TAction;
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miView: TMenuItem;
    miAction: TMenuItem;
    miHelp: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    N1: TMenuItem;
    miExit: TMenuItem;
    miToolbar: TMenuItem;
    miStatusBar: TMenuItem;
    N2: TMenuItem;
    miOptions: TMenuItem;
    miDetails: TMenuItem;
    N3: TMenuItem;
    miRun: TMenuItem;
    miStop: TMenuItem;
    miClear: TMenuItem;
    N4: TMenuItem;
    miAbout: TMenuItem;
    PopupMenu: TPopupMenu;
    piGet: TMenuItem;
    piGetNext: TMenuItem;
    piWalk: TMenuItem;
    ToolBar: TPanel;
    lblAgent: TLabel;
    cboAgent: TComboBox;
    lblCommunity: TLabel;
    cboCommunity: TComboBox;
    lblOids: TLabel;
    cboOids: TComboBox;
    ActionBar: TToolBar;
    btnRun: TToolButton;
    btnStop: TToolButton;
    btnClear: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StatusBarHint(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actToolBarExecute(Sender: TObject);
    procedure actStatusBarExecute(Sender: TObject);
    procedure actDetailsExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure ActionExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ToolBarResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FDone: Boolean;
    FAction: TActionCommand;
    FFileName: string;
    procedure ClearComboSelection;
    procedure ReadHistoryList(List: TStrings);
    procedure WriteHistoryList(List: TStrings);
    procedure UpdateCombo(Combo: TComboBox);
    procedure CreateVariableBindings(const Oids: string;
      var VarBindList: TSnmpVarBindList);
    procedure PrintVarBind(const VarBind: TSnmpVarBind);
    procedure MkFile(const FileName: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses SeDetls, SeOpts, SeConst, NetConst, NetUtils, NetAbout, MgmtAPI
  {$IF CompilerVersion > 24}, AnsiStrings{$IFEND};

{$R *.dfm}

type
  PSnmpVarBindTable = ^TSnmpVarBindTable;
  TSnmpVarBindTable = array[0..0] of TSnmpVarBind;

var
  TimeOut: Integer = 1000;
  Retries: Integer = 1;

procedure TMainForm.CreateVariableBindings(const Oids: string;
  var VarBindList: TSnmpVarBindList);
var
  I: Integer;
begin
  if ((Oids = SAllOids) and (FAction <> acWalk)) or
    ((Pos(SOidsSep, Oids) > 0) and (FAction = acWalk)) then
    raise Exception.CreateFmt(SInvalidOid, [Oids]);
  with TStringList.Create do
  try
    if Oids = SAllOids then
      Text := '1'
    else
      Text := StringReplace(Oids, SOidsSep, sLineBreak, [rfReplaceAll]);
    VarBindList.list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind) * Count);
    VarBindList.len := Count;
    try
      for I := 0 to Count - 1 do
        with PSnmpVarBindTable(VarBindList.list)^[I] do
        begin
          if not SnmpMgrStrToOid(PAnsiChar(AnsiString(Strings[I])), @name) then
            raise Exception.CreateFmt(SInvalidOid, [Strings[I]]);
          value.asnType := ASN_NULL;
        end;
     except
       SnmpUtilVarBindListFree(@VarBindList);
       raise;
     end;
  finally
    Free;
  end;
end;

procedure TMainForm.PrintVarBind(const VarBind: TSnmpVarBind);

  function FormatTimeTicks(Ticks: TAsnTimeticks): string;
  var
    Days, Hours, Mins, Secs: Word;
  begin
    DecodeMSecs(Ticks * 10, Days, Hours, Mins, Secs);
    Result := Format('%u (%s)', [Ticks,
      Format(SLongUpTimeFmt, [Days, Hours, Mins, Secs])]);
  end;

  function IsBinary(Buffer: PByte; BufLen: Integer): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to BufLen - 1 do
    begin
      if Buffer^ in [1..31] then
      begin
        Result := True;
        Break;
      end;
      Inc(Buffer);
    end;
  end;

  function FormatBinary(Buffer: PByte; BufLen: Integer): string;
  var
    I: Integer;
  begin
    Result := '';
    for I := 0 to BufLen - 1 do
    begin
      Result := Result + Format('%2.2x ', [Buffer^]);
      Inc(Buffer);
    end;
  end;
  
var
  A: array[0..3] of string;
  P: PAnsiChar;
  S: AnsiString;
begin
  A[0] := '.' + string(SnmpUtilOidToA(@VarBind.name));
  if SnmpMgrOidToStr(@VarBind.name, @P) then
  try
    SetLength(S, {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}StrLen(P));
    {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}StrCopy(PAnsiChar(S), P);
    A[1] := string(S);
  finally
    SnmpUtilMemFree(P);
  end;
  with VarBind.value do
    case asnType of
      ASN_NULL:
        A[2] := 'Null';
      ASN_INTEGER:
        begin
          A[2] := 'Integer32';
          A[3] := Format('%d', [asnValue.number]);
        end;
      ASN_COUNTER32:
        begin
          A[2] := 'Counter32';
          A[3] := Format('%u', [asnValue.counter]);
        end;
      ASN_GAUGE32:
        begin
          A[2] := 'Gauge32';
          A[3] := Format('%u', [asnValue.gauge]);
        end;
      ASN_UNSIGNED32:
        begin
          A[2] := 'Unsigned32';
          A[3] := Format('%u', [asnValue.unsigned32]);
        end;
      ASN_COUNTER64:
        begin
          A[2] := 'Counter64';
          A[3] := Format('%u', [asnValue.counter64.QuadPart]);
        end;
      ASN_TIMETICKS:
        begin
          A[2] := 'TimeTicks';
          A[3] := FormatTimeTicks(asnValue.ticks);
        end;
      ASN_IPADDRESS:
        begin
          A[2] := 'IpAddress';
          A[3] := FormatIpAddress(PDWORD(asnValue.address.stream)^);
        end;
      ASN_OCTETSTRING:
        begin
          A[2] := 'Octet String';
          with asnValue.str do
            if IsBinary(stream, length) then
              A[3] := FormatBinary(stream, length)
            else
              A[3] := Copy(string(PAnsiChar(stream)), 1, length);
        end;
      ASN_BITS, ASN_SEQUENCE, ASN_OPAQUE:
        begin
          if asnType = ASN_BITS then
            A[2] := 'Bits'
          else if asnType = ASN_SEQUENCE then
            A[2] := 'Sequence'
          else
            A[2] := 'Opaque';
          with asnValue.bits do
            A[3] := FormatBinary(stream, length);
        end;
      ASN_OBJECTIDENTIFIER:
        begin
          A[2] := 'Object Identifier';
          A[3] := '.' + string(SnmpUtilOidToA(@asnValue.obj));
        end;
      else
        A[2] := 'Unexpected Type';
    end;
  with ListView.Items.Add do
  begin
    ImageIndex := 0;
    Caption := A[0];
    SubItems.Add(A[1]);
    SubItems.Add(A[2]);
    SubItems.Add(A[3]);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FAction := acGet;
  with Registry do
  begin
    if OpenKey(ApplicationKey, False) then
    try
      if ValueExists(SShowToolBar) then
        ToolBar.Visible := ReadBool(SShowToolBar);
      if ValueExists(SShowStatusBar) then
        StatusBar.Visible := ReadBool(SShowStatusBar);
      if ValueExists(SAction) then
        FAction := TActionCommand(ReadInteger(SAction));
      if ValueExists(STimeOut) then
        TimeOut := ReadInteger(STimeOut);
      if ValueExists(SRetries) then
        Retries := ReadInteger(SRetries);
    finally
      CloseKey;
    end;
    if OpenKey(ApplicationKey + HL_AGENT_KEY, False) then
    try
      ReadHistoryList(cboAgent.Items);
      cboAgent.ItemIndex := 0;
    finally
      CloseKey;
    end;
    if OpenKey(ApplicationKey + HL_COMMUNITY_KEY, False) then
    try
      ReadHistoryList(cboCommunity.Items);
      cboCommunity.ItemIndex := 0;
    finally
      CloseKey;
    end;
    if OpenKey(ApplicationKey + HL_OID_KEY, False) then
    try
      ReadHistoryList(cboOids.Items);
      cboOids.ItemIndex := 0;
    finally
      CloseKey;
    end;
  end;
  FDone := True;
  StatusBar.SimpleText := SReady;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if actStop.Enabled then
    actStop.Execute;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  with Registry do
  begin
    if OpenKey(ApplicationKey, True) then
    try
      WriteBool(SShowToolBar, ToolBar.Visible);
      WriteBool(SShowStatusBar, StatusBar.Visible);
      WriteInteger(SAction, Ord(FAction));
      WriteInteger(STimeOut, TimeOut);
      WriteInteger(SRetries, Retries);
    finally
      CloseKey;
    end;
    if OpenKey(ApplicationKey + HL_AGENT_KEY, True) then
    try
      WriteHistoryList(cboAgent.Items);
    finally
      CloseKey;
    end;
    if OpenKey(ApplicationKey + HL_COMMUNITY_KEY, True) then
    try
      WriteHistoryList(cboCommunity.Items);
    finally
      CloseKey;
    end;
    if OpenKey(ApplicationKey + HL_OID_KEY, True) then
    try
      WriteHistoryList(cboOids.Items);
    finally
      CloseKey;
    end;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  ClearComboSelection;
end;

procedure TMainForm.ListViewDblClick(Sender: TObject);
begin
  actDetails.Execute;
end;

procedure TMainForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    actDetails.Execute;
end;

procedure TMainForm.StatusBarHint(Sender: TObject);
var
  SHint: string;
begin
  SHint := Application.Hint;
  with StatusBar do
    if SHint <> '' then
    begin
      SimplePanel := False;
      Panels[0].Text := SHint;
    end
    else
    begin
      SimplePanel := True;
      SimpleText := SReady;
    end;
end;

procedure TMainForm.ToolBarResize(Sender: TObject);
begin
  cboOids.Width := ActionBar.Left - cboOids.Left;
  ClearComboSelection;
end;

procedure TMainForm.actSaveExecute(Sender: TObject);
begin
  if (FFileName = '') then
    actSaveAs.Execute
  else
    MkFile(FFileName);
end;

procedure TMainForm.actSaveAsExecute(Sender: TObject);
begin
  with TSaveDialog.Create(Self) do
  try
    Options := [ofEnableSizing, ofOverwritePrompt];
    DefaultExt := SDefExt;
    if FFileName = '' then
      FileName := '*' + DefaultExt
    else
      FileName := FFileName;
    Filter := Format(SFileFilter, [DefaultExt, DefaultExt]);
    if Execute then
    begin
      MkFile(FileName);
      FFileName := FileName;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
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

procedure TMainForm.actDetailsExecute(Sender: TObject);
begin
  ShowDetailsDialog(Self);
end;

procedure TMainForm.actOptionsExecute(Sender: TObject);
begin
  ShowOptionsDialog(Self, Timeout, Retries);
end;

procedure TMainForm.actRunExecute(Sender: TObject);
var
  SaveCursor: TCursor;
  Session: PSnmpMgrSession;
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  RequestType: Byte;
  AllOids: Boolean;
  RootOid: TAsnObjectIdentifier;
  I: Integer;
begin
  FDone := False;
  (Sender as TAction).Update;
  with StatusBar do
  begin
    AutoHint := False;
    SimplePanel := True;
    SimpleText := SUpdating;
  end;
  Application.ProcessMessages;
  SaveCursor := Screen.Cursor;
  try
    Screen.Cursor := crAppStart;
    if (Trim(cboAgent.Text) = '') or (Trim(cboCommunity.Text) = '') or
      (Trim(cboOids.Text) = '') then
      raise Exception.Create(SEmptyParams);
    Session := SnmpMgrOpen(PAnsiChar(AnsiString(cboAgent.Text)),
      PAnsiChar(AnsiString(cboCommunity.Text)), TimeOut, Retries);
    if not Assigned(Session) then
      raise Exception.CreateFmt(SSnmpMgrOpenErr, [GetLastError]);
    try
      CreateVariableBindings(cboOids.Text, VarBindList);
      try
        UpdateCombo(cboAgent);
        UpdateCombo(cboCommunity);
        UpdateCombo(cboOids);
        case FAction of
          acGet, acGetNext:
            begin
              if FAction = acGet then
                RequestType := SNMP_PDU_GET
              else
                RequestType := SNMP_PDU_GETNEXT;
              if SnmpMgrRequest(Session, RequestType, @VarBindList,
                                @ErrorStatus, @ErrorIndex) = SNMPAPI(SNMPAPI_ERROR) then
                raise Exception.CreateFmt(SSnmpMgrRequestErr, [GetLastError])
              else if ErrorStatus <> SNMP_ERRORSTATUS_NOERROR then
                raise Exception.CreateFmt(SSnmpMgrRequestErrStatus,
                                          [ErrorStatus, ErrorIndex])
              else for I := 0 to VarBindList.len - 1 do
                PrintVarBind(PSnmpVarBindTable(VarBindList.list)^[I]);
            end;
          acWalk:
            begin
              RequestType := SNMP_PDU_GETNEXT;
              AllOids := AnsiSameText(cboOids.Text, SAllOids);
              if not AllOids then
                SnmpUtilOidCpy(@RootOid, @VarBindList.list^.name);
              while not FDone do
              begin
                if SnmpMgrRequest(Session, RequestType, @VarBindList,
                                  @ErrorStatus, @ErrorIndex) = SNMPAPI(SNMPAPI_ERROR) then
                  raise Exception.CreateFmt(SSnmpMgrRequestErr, [GetLastError]);
                if (ErrorStatus = SNMP_ERRORSTATUS_NOSUCHNAME) or (not AllOids and
                  (SnmpUtilOidNCmp(@RootOid, @VarBindList.list^.name, RootOid.idLength) <> 0)) then
                  Break
                else if ErrorStatus <> SNMP_ERRORSTATUS_NOERROR then
                  raise Exception.CreateFmt(SSnmpMgrRequestErrStatus,
                                            [ErrorStatus, ErrorIndex]);
                PrintVarBind(VarBindList.list^);
                Application.ProcessMessages;
              end;
            end;
        end;
      finally
        SnmpUtilVarBindListFree(@VarBindList);
      end;
    finally
      SnmpMgrClose(Session);
    end;
  finally
    FDone := True;
    with StatusBar do
    begin
      SimpleText := SReady;
      AutoHint := True;
    end;
    Screen.Cursor := SaveCursor;
  end;
end;

procedure TMainForm.actStopExecute(Sender: TObject);
begin
  FDone := True;
  Application.ProcessMessages;
end;

procedure TMainForm.actClearExecute(Sender: TObject);
begin
  with ListView.Items do
    if Count > 0 then
    begin
      BeginUpdate;
      try
        Clear;
      finally
        EndUpdate;
      end;
    end;
end;

procedure TMainForm.ActionExecute(Sender: TObject);
begin
  FAction := TActionCommand((Sender as TAction).Tag);
  actRun.Execute;
end;

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  ShowAboutDialog(Self);
end;

procedure TMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actRun.Enabled := FDone;
  actSave.Enabled := actRun.Enabled and (ListView.Items.Count > 0);
  actSaveAs.Enabled := actSave.Enabled;
  actToolBar.Checked := ToolBar.Visible;
  actStatusBar.Checked := StatusBar.Visible;
  actDetails.Enabled := Assigned(ListView.Selected);
  actStop.Enabled := not actRun.Enabled;
  actClear.Enabled := actSave.Enabled;
  if (Action as TAction).GroupIndex = 1 then
    (Action as TAction).Checked := (Action as TAction).Tag = Ord(FAction);
end;

procedure TMainForm.UpdateCombo(Combo: TComboBox);
var
  I: Integer;
begin
  with Combo do
  begin
    for I := 0 to Items.Count - 1 do
      if AnsiSameText(Items[I], Text) then
      begin
        Items.Move(I, 0);
        ItemIndex := 0;
        Exit;
      end;
    Items.Insert(0, Text);
    if Items.Count > 10 then
      Items.Delete(Items.Count - 1);
  end;
end;

procedure TMainForm.ClearComboSelection;
begin
  if not Showing then
    Exit;
  if not (ActiveControl = cboAgent) and (cboAgent.SelLength > 0) then
    cboAgent.SelLength := 0;
  if not (ActiveControl = cboCommunity) and (cboCommunity.SelLength > 0) then
    cboCommunity.SelLength := 0;
  if not (ActiveControl = cboOids) and (cboOids.SelLength > 0) then
    cboOids.SelLength := 0;
end;

procedure TMainForm.ReadHistoryList(List: TStrings);
var
  Names: TStrings;
  I: Integer;
begin
  Names := TStringList.Create;
  try
    Registry.GetValueNames(Names);
    if Names.Count = 0 then
      Exit;
    List.Clear;
    for I := 0 to Names.Count - 1 do
      List.Add(Registry.ReadString(Names[I]));
  finally
    Names.Free;
  end;
end;

procedure TMainForm.WriteHistoryList(List: TStrings);
var
  I: Integer;
begin
  with List do
    for I := 0 to Count - 1 do
      Registry.WriteString('Item' + IntToStr(I), Strings[I]);
end;

procedure TMainForm.MkFile(const FileName: string);
var
  F: TextFile;
  SaveCursor: TCursor;
  I: Integer;
begin
  AssignFile(F, FileName);
  Rewrite(F);
  SaveCursor := Screen.Cursor;
  try
    Screen.Cursor := crAppStart;
    with ListView do
      for I := 0 to Items.Count - 1 do
        Writeln(F, Format('%s | %s | %s | %s', [Items[I].Caption,
                                                Items[I].SubItems[0],
                                                Items[I].SubItems[1],
                                                Items[I].SubItems[2]]));
  finally
    CloseFile(F);
    Screen.Cursor := SaveCursor;
  end;
end;

end.
