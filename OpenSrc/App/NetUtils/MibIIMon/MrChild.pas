unit MrChild;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  ImgList, ToolWin, ActnList, ComCtrls, ExtCtrls, CBEx, LVEx, MgmtAPI;

type
  TActiveLevel = (alNone = -1, alSystemInfo, alTableDesc, alNicTable,
    alArpTable, alIpAddrTable, alRouteTable, alConnTable, alStatDesc,
    alIfStat, alIpStat, alIcmpStat, alTcpStat, alUdpStat);

  TChildForm = class(TForm)
    StatusBar: TStatusBar;
    TreeView: TTreeView;
    Splitter: TSplitter;
    ListView: TListViewEx;
    CoolBar: TCoolBarEx;
    cboAgent: TComboBox;
    ActionList: TActionList;
    actConnect: TAction;
    actDisconnect: TAction;
    ImageList: TImageList;
    actUp: TAction;
    actRefresh: TAction;
    ToolBar: TToolBar;
    btnUp: TToolButton;
    btnSeparator1: TToolButton;
    btnConnect: TToolButton;
    btnDisconnect: TToolButton;
    btnSeparator2: TToolButton;
    btnRefresh: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure cboAgentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actUpExecute(Sender: TObject);
    procedure actConnectExecute(Sender: TObject);
    procedure actDisconnectExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
  private
    { Private declarations }
    FDone: Boolean;
    FRecreateColumns: Boolean;
    FConnected: Boolean;
    FActiveLevel: TActiveLevel;
    FSession: PSnmpMgrSession;
    procedure UpdateAgentList;
    procedure GetSystemInfo;
    procedure GetNicTable;
    procedure GetArpTable;
    procedure GetIpAddressTable;
    procedure GetRouteTable;
    procedure GetConnectionsTable;
    procedure GetIfStats;
    procedure GetIpStats;
    procedure GetTcpStats;
    procedure GetIcmpStats;
    procedure GetUdpStats;
    procedure GetBaseDescs;
  public
    { Public declarations }
    property ActiveLevel: TActiveLevel read FActiveLevel;
  end;

var
  ChildForm: TChildForm;

implementation

uses MrMain, MrConst, NetConst, NetUtils, Snmp, IPHlpApi;

{$R *.dfm}

const
  TVItemCaptions: array[0..11] of string = (
    STable,
    SNic,
    SArp,
    SIpAddress,
    SRoute,
    SConnections,
    SStatistics,
    SInterface,
    SIp,
    SIcmp,
    STcp,
    SUdp);

type
  PMacAddr = ^TMacAddr;
  TMacAddr = array[0..7] of Byte;

  PIfTable = ^TIfTable;
  TIfTable = record
    Next: PIfTable;
    Name: array[0..255] of AnsiChar;
    MacAddr: TMacAddr;
    MacAddrLen: TAsnUnsigned32;
    Speed: TAsnGauge32;
    Number: TAsnInteger32;
  end;

  PArpTable = ^TArpTable;
  TArpTable = record
    Next: PArpTable;
    IpAddr: TAsnUnsigned32;
    MacAddr: TMacAddr;
    MacAddrLen: TAsnUnsigned32;
    Interf: TAsnInteger32;
  end;

  PIpAddrTable = ^TIpAddrTable;
  TIpAddrTable = record
    Next: PIpAddrTable;
    IpAddr: TAsnUnsigned32;
    NetMask: TAsnUnsigned32;
    Interf: TAsnInteger32;
  end;

  PRouteTable = ^TRouteTable;
  TRouteTable = record
    Next: PRouteTable;
    Destination: TAsnUnsigned32;
    NetMask: TAsnUnsigned32;
    Gateway: TAsnUnsigned32;
    Interf: TAsnInteger32;
    Metric: TAsnInteger32;
  end;

  PTcpUdpTable = ^TTcpUdpTable;
  TTcpUdpTable = record
    Next: PTcpUdpTable;
    State: TAsnInteger32;
    LocalAddr: TAsnUnsigned32;
    LocalPort: TAsnInteger32;
    RemoteAddr: TAsnUnsigned32;
    RemotePort: TAsnInteger32;
  end;

  PIds = ^TIds;
  TIds = array[0..SNMP_MAX_OID_LEN - 1] of UINT;

procedure CheckSnmpResult(ResultCode: SNMPAPI);
begin
  if ResultCode = SNMPAPI(SNMPAPI_ERROR) then
    raise Exception.CreateFmt(SSnmpMgrRequestErr, [GetLastError]);
end;

procedure TChildForm.FormCreate(Sender: TObject);
var
  List: TStrings;
  I: Integer;
begin
  with MainForm, Registry do
    if OpenKey(ApplicationKey + AGENT_HL_KEY, False) then
    try
      List := TStringList.Create;
      try
        GetValueNames(List);
        for I := 0 to List.Count - 1 do
          cboAgent.Items.Add(ReadString(List[I]));
      finally
        List.Free;
      end;
    finally
      CloseKey;
    end;
  FDone := True;
  FRecreateColumns := True;
  FConnected := False;
  FActiveLevel := alNone;
  StatusBar.Panels[0].Width := TreeView.Width;
  ListView.SortImmediately := False;
end;

procedure TChildForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TChildForm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  with MainForm, Registry do
    if OpenKey(ApplicationKey + AGENT_HL_KEY, True) then
    try
      with cboAgent do
        for I := 0 to Items.Count - 1 do
          WriteString('Item' + IntToStr(I), Items[I]);
    finally
      CloseKey;
    end;
  if Assigned(FSession) then
    SnmpMgrClose(FSession);
end;

procedure TChildForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
var
  SaveCursor: TCursor;
begin
  if not FDone then
    Exit;
  FDone := False;
  StatusBar.Panels[1].Text := SUpdating;
  Application.ProcessMessages;
  SaveCursor := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    FActiveLevel := TActiveLevel(Node.AbsoluteIndex);
    FRecreateColumns := (Sender <> actRefresh) or (ListView.Columns.Count = 0);
    with ListView do
    begin
      Items.BeginUpdate;
      try
        Items.Clear;
        if FRecreateColumns then
        begin
          Columns.BeginUpdate;
          try
            Columns.Clear;
          finally
            Columns.EndUpdate;
          end;
        end;
        case FActiveLevel of
          alSystemInfo:
            GetSystemInfo;
          alTableDesc, alStatDesc:
            GetBaseDescs;
          alNicTable:
            GetNicTable;
          alArpTable:
            GetArpTable;
          alIpAddrTable:
            GetIpAddressTable;
          alRouteTable:
            GetRouteTable;
          alConnTable:
            GetConnectionsTable;
          alIfStat:
            GetIfStats;
          alIpStat:
            GetIpStats;
          alIcmpStat:
            GetIcmpStats;
          alTcpStat:
            GetTcpStats;
          alUdpStat:
            GetUdpStats;
        end;
        if SortColumn <> - 1 then
          CustomSort(nil, SortColumn - 1);
        if Items.Count > 0 then
          ItemFocused := Items[0];
      finally
        Items.EndUpdate;
      end;
    end;
  finally
    FDone := True;
    StatusBar.Panels[1].Text := SReady;
    Screen.Cursor := SaveCursor;
  end;
end;

procedure TChildForm.TreeViewChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  AllowChange := FDone;
end;

procedure TChildForm.ListViewDblClick(Sender: TObject);
var
  CurItem: TTreeNode;
begin
  if Assigned(ListView.Selected) then
  begin
    if TreeView.Selected.HasChildren then
      CurItem := TreeView.Selected.GetFirstChild
    else
      CurItem := TreeView.Selected;
    while Assigned(CurItem) do
    begin
      if (CurItem.Text = ListView.Selected.Caption) and
        (CurItem.ImageIndex = ListView.Selected.ImageIndex) then
      begin
        TreeView.Selected := CurItem;
        Break;
      end;
      if TreeView.Selected.HasChildren then
        CurItem := CurItem.GetNextChild(CurItem)
      else
        CurItem := CurItem.GetNext;
    end;
  end;
end;

procedure TChildForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ListViewDblClick(Sender);
end;

procedure TChildForm.ListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if Data = -1 then
  begin
    if FActiveLevel in [alArpTable..alRouteTable] then
      Compare := AnsiCompareText(AlignIpAddress(Item1.Caption),
                                 AlignIpAddress(Item2.Caption))
    else
      Compare := AnsiCompareText(Item1.Caption,
                                 Item2.Caption);
  end
  else if ((FActiveLevel in [alSystemInfo..alArpTable, alStatDesc]) and (Data = 0)) or
    ((FActiveLevel = alConnTable) and (Data = 2)) then
    Compare := AnsiCompareText(Item1.SubItems[Data],
                               Item2.SubItems[Data])
  else if ((FActiveLevel = alIpAddrTable) and (Data = 0)) or
    ((FActiveLevel = alRouteTable) and (Data in [0, 1])) then
    Compare := AnsiCompareText(AlignIpAddress(Item1.SubItems[Data]),
                               AlignIpAddress(Item2.SubItems[Data]))
  else if (FActiveLevel = alConnTable) and (Data <> 2) then
    Compare := AnsiCompareText(AlignAddress(Item1.SubItems[Data]),
                               AlignAddress(Item2.SubItems[Data]))
  else
    Compare := AnsiCompareText(AlignString(Item1.SubItems[Data]),
                               AlignString(Item2.SubItems[Data]));
  if ListView.SortOrder = soDown then
    Compare := -Compare;                             
end;

procedure TChildForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
const
  Indexes: array[Boolean] of Integer = (12, 13);
  States: array[Boolean] of string = (SDisconnected, SConnected);
begin
  with StatusBar do
  begin
    ImageList.Draw(Canvas, Rect.Left + 2, Rect.Top +
      (Rect.Bottom - Rect.Top - ImageList.Height) div 2, Indexes[FConnected]);
    Canvas.TextOut(Rect.Left + ImageList.Width + 5, Rect.Top +
      (Rect.Bottom - Rect.Top - Canvas.TextHeight('0')) div 2, States[FConnected]);
  end;
end;

procedure TChildForm.cboAgentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    actConnect.Execute;          
end;

procedure TChildForm.actUpExecute(Sender: TObject);
begin
  with TreeView do
    Selected := Selected.Parent;
end;

procedure TChildForm.actConnectExecute(Sender: TObject);

  procedure CheckSession(Session: PSnmpMgrSession);
  var
    VarBindList: TSnmpVarBindList;
    ErrorStatus, ErrorIndex: TAsnInteger32;
  begin
    with VarBindList do
    begin
      list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
      len := 1;
      with list^ do
      begin
        SnmpMgrStrToOid('1', @name);
        value.asnType := ASN_NULL;
      end;
    end;
    try
      CheckSnmpResult(SnmpMgrRequest(Session, SNMP_PDU_GETNEXT,
                                     @VarBindList, @ErrorStatus, @ErrorIndex));
    finally
      SnmpUtilVarBindListFree(@VarBindList);
    end;
  end;

var
  Root, Node, Child: TTreeNode;
  I: Integer;
begin
  if not FDone then
    Exit;
  if Trim(cboAgent.Text) = '' then
  begin
    Application.MessageBox(PChar(SInfoMsg), PChar(Application.Title),
                           MB_OK or MB_ICONINFORMATION);
    Exit;
  end;
  if FConnected then
    actDisconnect.Execute;
  FSession := SnmpMgrOpen(PAnsiChar(AnsiString(cboAgent.Text)),
    PAnsiChar(AnsiString(Community)), TimeOut, Retries);
  if not Assigned(FSession) then
    raise Exception.Create(SSessionCreateErr);
  try
    CheckSession(FSession);
  except
    actDisconnect.Execute;
    raise;
  end;
  TreeView.OnChange := nil;
  Root := TreeView.Items.Add(nil, cboAgent.Text);
  Root.ImageIndex := 0;
  Root.SelectedIndex := 0;
  Node := nil;
  for I := 0 to High(TVItemCaptions) do
    with TreeView.Items do
      if I in [0, 6] then
      begin
        Node := AddChild(Root, TVItemCaptions[I]);
        if I = 0 then
        begin
          Node.ImageIndex := 1;
          Node.SelectedIndex := 1;
        end
        else
        begin
          Node.ImageIndex := 2;
          Node.SelectedIndex := 2;
        end;
      end
      else
      begin
        Child := AddChild(Node, TVItemCaptions[I]);
        Child.ImageIndex := 3;
        Child.SelectedIndex := 4;
      end;
  TreeView.OnChange := TreeViewChange;
  Root.Expanded := True;
  Root.Selected := True;
  ListView.ViewStyle := vsReport;
  ListView.TopItem.Focused := True; 
  UpdateAgentList;
  Caption := cboAgent.Text;
  FConnected := True;
  StatusBar.Invalidate;
end;

procedure TChildForm.actDisconnectExecute(Sender: TObject);
begin
  if not FDone then
    Exit;
  if Assigned(FSession) then
  begin
    SnmpMgrClose(FSession);
    FSession := nil;
    FActiveLevel := alNone;
    with ListView do
    begin
      Items.BeginUpdate;
      try
        Items.Clear;
      finally
        Items.EndUpdate;
      end;
      Columns.BeginUpdate;
      try
        Columns.Clear;
      finally
        Columns.EndUpdate;
      end;
      ViewStyle := vsList;
    end;
    with TreeView do
    begin
      OnChange := nil;
      try
        Items.BeginUpdate;
        try
          Items.Clear;
        finally
          Items.EndUpdate;
        end;
      finally
        OnChange := TreeViewChange;
      end;
    end;
    FConnected := False;
    StatusBar.Panels[1].Text := '';
    StatusBar.Invalidate;
  end;
end;

procedure TChildForm.actRefreshExecute(Sender: TObject);
begin
  TreeViewChange(Sender, TreeView.Selected);
end;

procedure TChildForm.UpdateAgentList;
var
  I: Integer;
begin
  with cboAgent do
  begin
    if Items.Count > 0 then
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

procedure TChildForm.GetSystemInfo;
const
  SysNames: array [0..6] of string = (
    SDesc,
    SObjectID,
    SUpTime,
    SContact,
    SName,
    SLocation,
    SServices);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  Values: array [0..6] of string;
  I: Integer;
  Days, Hours, Mins, Secs: Word;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SName;
        Width := 100;
      end;
      with Columns.Add do
      begin
        Caption := SValue;
        Width := 150;
      end;
    end;
  FillChar(Values, SizeOf(Values), 0);
  with VarBindList do
  begin
    list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
    len := 1;
    with list^ do
    begin
      SnmpMgrStrToOid('1', @name);
      value.asnType := ASN_NULL;
    end;
  end;
  try
    for I := 0 to High(Values) do
    begin
      CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                     @VarBindList, @ErrorStatus, @ErrorIndex));
      with VarBindList.list^.value do
        case asnType of
          ASN_OCTETSTRING:
            Values[I] := Copy(string(PAnsiChar(asnValue.str.stream)), 1, asnValue.str.length);
          ASN_TIMETICKS:
            begin
              DecodeMSecs(asnValue.ticks * 10, Days, Hours, Mins, Secs);
              Values[I] := Format(SLongUpTimeFmt, [Days, Hours, Mins, Secs]);
            end;
          ASN_INTEGER:
            Values[I] := FormatNumber(asnValue.Number);
          ASN_OBJECTIDENTIFIER:
            Values[I] := '.' + string(SnmpUtilOidToA(@asnValue.obj));
        end;
    end;
  finally
    SnmpUtilVarBindListFree(@VarBindList);
  end;
  with ListView do
  begin
    with Items.Add do
    begin
      ImageIndex := 1;
      Caption := TVItemCaptions[0];
      SubItems.Add('');
    end;
    with Items.Add do
    begin
      ImageIndex := 2;
      Caption := TVItemCaptions[6];
      SubItems.Add('');
    end;
    for I := 0 to High(SysNames) do
      with Items.Add do
      begin
        ImageIndex := 0;
        Caption := SysNames[I];
        SubItems.Add(Values[I]);
      end;
  end;
end;

procedure TChildForm.GetNicTable;
const
  Identifiers: array[0..3] of UINT = (2, 6, 5, 1);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  IfTable: TIfTable;
  CurrentEntry, NewEntry: PIfTable;
  I: Integer;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SName;
        Width := 280;
      end;
      with Columns.Add do
      begin
        Caption := SMacAddress;
        Width := 120;
      end;
      with Columns.Add do
      begin
        Caption := SSpeed;
        Alignment := taRightJustify;
        Width := 130;
      end;
      with Columns.Add do
      begin
        Caption := SNumber;
        Alignment := taRightJustify;
        Width := 100;
      end;
    end;
  IfTable.Next := @IfTable;
  CurrentEntry := @IfTable;
  try
    for I := 0 to High(Identifiers) do
    begin
      with VarBindList do
      begin
        list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
        len := 1;
        with list^ do
        begin
          SnmpMgrStrToOid(PAnsiChar(SIfEntry), @name);
          PIds(name.ids)^[9] := Identifiers[I];
          value.asnType := ASN_NULL;
        end;
      end;
      try
        while True do
        begin
          CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                         @VarBindList, @ErrorStatus, @ErrorIndex));
          if Identifiers[I] <> PIds(VarBindList.list^.name.ids)^[9] then
            Break;
          case I of
            0:
              begin
                New(NewEntry);
                FillChar(NewEntry^.Name, 0, SizeOf(NewEntry^.Name));
                NewEntry^.Next := @IfTable;
                CurrentEntry^.Next := NewEntry;
                CurrentEntry := NewEntry;
                with VarBindList.list^.value.asnValue.str do
                  CopyMemory(@CurrentEntry^.Name, stream, length);
              end;
            1:
              begin
                with VarBindList.list^.value.asnValue.str do
                begin
                  CopyMemory(@CurrentEntry^.MacAddr, stream, length);
                  CurrentEntry^.MacAddrLen := length;
                end;
                CurrentEntry := CurrentEntry^.Next;
              end;
            2:
              begin
                CurrentEntry^.Speed := VarBindList.list^.value.asnValue.gauge;
                CurrentEntry := CurrentEntry^.Next;
              end;
            3:
              begin
                CurrentEntry^.Number := VarBindList.list^.value.asnValue.number;
                CurrentEntry := CurrentEntry^.Next;
              end;
          end;
        end;
        CurrentEntry := IfTable.Next;
      finally
        SnmpUtilVarBindListFree(@VarBindList);
      end;
    end;
    while CurrentEntry <> @IfTable do
    begin
      with ListView.Items.Add do
      begin
        ImageIndex := 6;
        Caption := string(CurrentEntry^.Name);
        if CurrentEntry^.MacAddrLen <> 0 then
          SubItems.Add(FormatMacAddress(CurrentEntry^.MacAddr))
        else
          SubItems.Add('');
        SubItems.Add(FormatNumber(CurrentEntry^.Speed));
        SubItems.Add(FormatNumber(CurrentEntry^.Number));
      end;
      CurrentEntry := CurrentEntry^.Next;
    end;
  finally
    CurrentEntry := IfTable.Next;
    while CurrentEntry <> @IfTable do
    begin
      NewEntry := CurrentEntry;
      CurrentEntry := CurrentEntry^.Next;
      Dispose(NewEntry);
    end;
  end;
end;

procedure TChildForm.GetArpTable;
const
  Identifiers: array[0..2] of UINT = (3, 2, 1);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  ArpTable: TArpTable;
  CurrentEntry, NewEntry: PArpTable;
  I: Integer;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SIpAddress;
        Width := 110;
      end;
      with Columns.Add do
      begin
        Caption := SMacAddress;
        Width := 120;
      end;
      with Columns.Add do
      begin
        Caption := SInterface;
        Alignment := taRightJustify;
        Width := 100;
      end;
    end;
  ArpTable.Next := @ArpTable;
  CurrentEntry := @ArpTable;
  try
    for I := 0 to High(Identifiers) do
    begin
      with VarBindList do
      begin
        list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
        len := 1;
        with list^ do
        begin
          SnmpMgrStrToOid(PAnsiChar(SArpEntry), @name);
          PIds(name.ids)^[9] := Identifiers[I];
          value.asnType := ASN_NULL;
        end;
      end;
      try
        while True do
        begin
          CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                         @VarBindList, @ErrorStatus, @ErrorIndex));
          if Identifiers[I] <> PIds(VarBindList.list^.name.ids)^[9] then
            Break;
          case I of
            0:
              begin
                New(NewEntry);
                NewEntry^.Next := @ArpTable;
                CurrentEntry^.Next := NewEntry;
                CurrentEntry := NewEntry;
                CurrentEntry^.IpAddr := PDWORD(VarBindList.list^.value.asnValue.address.stream)^;
              end;
            1:
              begin
                with VarBindList.list^.value.asnValue.str do
                begin
                  CopyMemory(@CurrentEntry^.MacAddr, stream, length);
                  CurrentEntry^.MacAddrLen := length;
                end;
                CurrentEntry := CurrentEntry^.Next;
              end;
            2:
              begin
                CurrentEntry^.Interf := VarBindList.list^.value.asnValue.number;
                CurrentEntry := CurrentEntry^.Next;
              end;
          end;
        end;
        CurrentEntry := ArpTable.Next;
      finally
        SnmpUtilVarBindListFree(@VarBindList);
      end;
    end;
    while CurrentEntry <> @ArpTable do
    begin
      with ListView.Items.Add do
      begin
        ImageIndex := 5;
        Caption := FormatIPAddress(CurrentEntry^.IpAddr);
        if CurrentEntry^.MacAddrLen <> 0 then
          SubItems.Add(FormatMacAddress(CurrentEntry^.MacAddr))
        else
          SubItems.Add('');
        SubItems.Add(FormatNumber(CurrentEntry^.Interf));
      end;
      CurrentEntry := CurrentEntry^.Next;
    end;
  finally
    CurrentEntry := ArpTable.Next;
    while CurrentEntry <> @ArpTable do
    begin
      NewEntry := CurrentEntry;
      CurrentEntry := CurrentEntry^.Next;
      Dispose(NewEntry);
    end;
  end;
end;

procedure TChildForm.GetIpAddressTable;
const
  Identifiers: array[0..2] of UINT = (1, 3, 2);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  IpAddrTable: TIpAddrTable;
  CurrentEntry, NewEntry: PIpAddrTable;
  I: Integer;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SIpAddress;
        Width := 110;
      end;
      with Columns.Add do
      begin
        Caption := SNetmask;
        Width := 110;
      end;
      with Columns.Add do
      begin
        Caption := SInterface;
        Alignment := taRightJustify;
        Width := 100;
      end;
    end;
  IpAddrTable.Next := @IpAddrTable;
  CurrentEntry := @IpAddrTable;
  try
    for I := 0 to High(Identifiers) do
    begin
      with VarBindList do
      begin
        list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
        len := 1;
        with list^ do
        begin
          SnmpMgrStrToOid(PAnsiChar(SIpAddrEntry), @name);
          PIds(name.ids)^[9] := Identifiers[I];
          value.asnType := ASN_NULL;
        end;
      end;
      try
        while True do
        begin
          CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                         @VarBindList, @ErrorStatus, @ErrorIndex));
          if Identifiers[I] <> PIds(VarBindList.list^.name.ids)^[9] then
            Break;
          case I of
            0:
              begin
                New(NewEntry);
                NewEntry^.Next := @IpAddrTable;
                CurrentEntry^.Next := NewEntry;
                CurrentEntry := NewEntry;
                CurrentEntry^.IpAddr := PDWORD(VarBindList.list^.value.asnValue.address.stream)^;
              end;
            1:
              begin
                CurrentEntry^.NetMask := PDWORD(VarBindList.list^.value.asnValue.address.stream)^;
                CurrentEntry := CurrentEntry^.Next;
              end;
            2:
              begin
                CurrentEntry^.Interf := VarBindList.list^.value.asnValue.number;
                CurrentEntry := CurrentEntry^.Next;
              end;
          end;
        end;
        CurrentEntry := IpAddrTable.Next;
      finally
        SnmpUtilVarBindListFree(@VarBindList);
      end;
    end;
    while CurrentEntry <> @IpAddrTable do
    begin
      with ListView.Items.Add do
      begin
        ImageIndex := 5;
        Caption := FormatIpAddress(CurrentEntry^.IpAddr);
        SubItems.Add(FormatIpAddress(CurrentEntry^.NetMask));
        SubItems.Add(FormatNumber(CurrentEntry^.Interf));
      end;
      CurrentEntry := CurrentEntry^.Next;
    end;
  finally
    CurrentEntry := IpAddrTable.Next;
    while CurrentEntry <> @IpAddrTable do
    begin
      NewEntry := CurrentEntry;
      CurrentEntry := CurrentEntry^.Next;
      Dispose(NewEntry);
    end;
  end;
end;

procedure TChildForm.GetRouteTable;
const
  Identifiers: array[0..4] of UINT = (1, 11, 7, 2, 3);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  RouteTable: TRouteTable;
  CurrentEntry, NewEntry: PRouteTable;
  I: Integer;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SNetworkDest;
        Width := 120;
      end;
      with Columns.Add do
      begin
        Caption := SNetmask;
        Width := 110;
      end;
      with Columns.Add do
      begin
        Caption := SGateway;
        Width := 110;
      end;
      with Columns.Add do
      begin
        Caption := SInterface;
        Alignment := taRightJustify;
        Width := 100;
      end;
      with Columns.Add do
      begin
        Caption := SMetric;
        Alignment := taRightJustify;
        Width := 60;
      end;
    end;
  RouteTable.Next := @RouteTable;
  CurrentEntry := @RouteTable;
  try
    for I := 0 to High(Identifiers) do
    begin
      with VarBindList do
      begin
        list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
        len := 1;
        with list^ do
        begin
          SnmpMgrStrToOid(PAnsiChar(SIpRouteEntry), @name);
          PIds(name.ids)^[9] := Identifiers[I];
          value.asnType := ASN_NULL;
        end;
      end;
      try
        while True do
        begin
          CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                         @VarBindList, @ErrorStatus, @ErrorIndex));
          if Identifiers[I] <> PIds(VarBindList.list^.name.ids)^[9] then
            Break;
          case I of
            0:
              begin
                New(NewEntry);
                NewEntry^.Next := @RouteTable;
                CurrentEntry^.Next := NewEntry;
                CurrentEntry := NewEntry;
                CurrentEntry^.Destination := PDWORD(VarBindList.list^.value.asnValue.address.stream)^;
              end;
            1:
              begin
                CurrentEntry^.NetMask := PDWORD(VarBindList.list^.value.asnValue.address.stream)^;
                CurrentEntry := CurrentEntry^.Next;
              end;
            2:
              begin
                CurrentEntry^.Gateway := PDWORD(VarBindList.list^.value.asnValue.address.stream)^;
                CurrentEntry := CurrentEntry^.Next;
              end;
            3:
              begin
                CurrentEntry^.Interf := VarBindList.list^.value.asnValue.number;
                CurrentEntry := CurrentEntry^.Next;
              end;
            4:
              begin
                CurrentEntry^.Metric := VarBindList.list^.value.asnValue.number;
                CurrentEntry := CurrentEntry^.Next;
              end;
          end;
        end;
        CurrentEntry := RouteTable.Next;
      finally
        SnmpUtilVarBindListFree(@VarBindList);
      end;
    end;
    while CurrentEntry <> @RouteTable do
    begin
      with ListView.Items.Add do
      begin
        ImageIndex := 5;
        Caption := FormatIpAddress(CurrentEntry^.Destination);
        SubItems.Add(FormatIpAddress(CurrentEntry^.NetMask));
        SubItems.Add(FormatIpAddress(CurrentEntry^.Gateway));
        SubItems.Add(FormatNumber(CurrentEntry^.Interf));
        SubItems.Add(FormatNumber(CurrentEntry^.Metric));
      end;
      CurrentEntry := CurrentEntry^.Next;
    end;
  finally
    CurrentEntry := RouteTable.Next;
    while CurrentEntry <> @RouteTable do
    begin
      NewEntry := CurrentEntry;
      CurrentEntry := CurrentEntry^.Next;
      Dispose(NewEntry);
    end;
  end;
end;

procedure TChildForm.GetConnectionsTable;
const
  TcpIdentifiers: array[0..4] of UINT = (1, 2, 3, 4, 5);
  UdpIdentifiers: array[0..1] of UINT = (1, 2);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  TcpUdpTable: TTcpUdpTable;
  CurrentEntry, NewEntry: PTcpUdpTable;
  I: Integer;
  LocalAddr, RemoteAddr: string;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SProtocol;
        Width := 70;
      end;
      with Columns.Add do
      begin
        Caption := SLocalAddress;
        Width := 150;
      end;
      with Columns.Add do
      begin
        Caption := SRemoteAddress;
        Width := 150;
      end;
      with Columns.Add do
      begin
        Caption := SState;
        Width := 100;
      end;
    end;

{ TCP connections }

  TcpUdpTable.Next := @TcpUdpTable;
  CurrentEntry := @TcpUdpTable;
  try
    for I := 0 to High(TcpIdentifiers) do
    begin
      with VarBindList do
      begin
        list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
        len := 1;
        with list^ do
        begin
          SnmpMgrStrToOid(PAnsiChar(STcpConnEntry), @name);
          PIds(name.ids)^[9] := TcpIdentifiers[I];
          value.asnType := ASN_NULL;
        end;
      end;
      try
        while True do
        begin
          CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                         @VarBindList, @ErrorStatus, @ErrorIndex));
          if TcpIdentifiers[I] <> PIds(VarBindList.list^.name.ids)^[9] then
            Break;
          case I of
            0:
              begin
                New(NewEntry);
                NewEntry^.Next := @TcpUdpTable;
                CurrentEntry^.Next := NewEntry;
                CurrentEntry := NewEntry;
                CurrentEntry^.State := VarBindList.list^.value.asnValue.number;
              end;
            1:
              begin
                CurrentEntry^.LocalAddr := PDWORD(VarBindList.list^.value.asnValue.address.stream)^;
                CurrentEntry := CurrentEntry^.Next;
              end;
            2:
              begin
                CurrentEntry^.LocalPort := VarBindList.list^.value.asnValue.number;
                CurrentEntry := CurrentEntry^.Next;
              end;
            3:
              begin
                CurrentEntry^.RemoteAddr := PDWORD(VarBindList.list^.value.asnValue.address.stream)^;
                CurrentEntry := CurrentEntry^.Next;
              end;
            4:
              begin
                CurrentEntry^.RemotePort := VarBindList.list^.value.asnValue.number;
                CurrentEntry := CurrentEntry^.Next;
              end;
          end;
        end;
        CurrentEntry := TcpUdpTable.Next;
      finally
        SnmpUtilVarBindListFree(@VarBindList);
      end;
    end;
    while CurrentEntry <> @TcpUdpTable do
    begin
      LocalAddr := Format('%s:%d', [FormatIpAddress(CurrentEntry^.LocalAddr),
                                    CurrentEntry^.LocalPort]);
      if CurrentEntry^.RemoteAddr = 0 then
        RemoteAddr := Format('%s:%d', [FormatIpAddress(CurrentEntry^.RemoteAddr), 0])
      else
        RemoteAddr := Format('%s:%d', [FormatIpAddress(CurrentEntry^.RemoteAddr),
                                       CurrentEntry^.RemotePort]);
      with ListView.Items.Add do
      begin
        ImageIndex := 5;
        Caption := STcp;
        SubItems.Add(LocalAddr);
        SubItems.Add(RemoteAddr);
        SubItems.Add(TcpStateNames[TMibTcpState(CurrentEntry^.State)]);
      end;
      CurrentEntry := CurrentEntry^.Next;
    end;
  finally
    CurrentEntry := TcpUdpTable.Next;
    while CurrentEntry <> @TcpUdpTable do
    begin
      NewEntry := CurrentEntry;
      CurrentEntry := CurrentEntry^.Next;
      Dispose(NewEntry);
    end;
  end;

{ UDP connections }

  TcpUdpTable.Next := @TcpUdpTable;
  CurrentEntry := @TcpUdpTable;
  try
    for I := 0 to High(UdpIdentifiers) do
    begin
      with VarBindList do
      begin
        list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
        len := 1;
        with list^ do
        begin
          SnmpMgrStrToOid(PAnsiChar(SUdpTableEntry), @name);
          PIds(name.ids)^[9] := UdpIdentifiers[I];
          value.asnType := ASN_NULL;
        end;
      end;
      try
        while True do
        begin
          CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                         @VarBindList, @ErrorStatus, @ErrorIndex));
          if UdpIdentifiers[I] <> PIds(VarBindList.list^.name.ids)^[9] then
            Break;
          case I of
            0:
              begin
                New(NewEntry);
                NewEntry^.Next := @TcpUdpTable;
                CurrentEntry^.Next := NewEntry;
                CurrentEntry := NewEntry;
                CurrentEntry^.LocalAddr := PDWORD(VarBindList.list^.value.asnValue.address.stream)^;
              end;
            1:
              begin
                CurrentEntry^.LocalPort := VarBindList.list^.value.asnValue.number;
                CurrentEntry := CurrentEntry^.Next;
              end;
          end;
        end;
        CurrentEntry := TcpUdpTable.Next;
      finally
        SnmpUtilVarBindListFree(@VarBindList);
      end;
    end;
    while CurrentEntry <> @TcpUdpTable do
    begin
      LocalAddr := Format('%s:%d', [FormatIpAddress(CurrentEntry^.LocalAddr),
                                    CurrentEntry^.LocalPort]);
      RemoteAddr := '*:*';
      with ListView.Items.Add do
      begin
        ImageIndex := 5;
        Caption := SUdp;
        SubItems.Add(LocalAddr);
        SubItems.Add(RemoteAddr);
        SubItems.Add('');
      end;
      CurrentEntry := CurrentEntry^.Next;
    end;
  finally
    CurrentEntry := TcpUdpTable.Next;
    while CurrentEntry <> @TcpUdpTable do
    begin
      NewEntry := CurrentEntry;
      CurrentEntry := CurrentEntry^.Next;
      Dispose(NewEntry);
    end;  
  end;
end;

procedure TChildForm.GetIfStats;
const
  Identifiers: array[0..10] of UINT = (10, 16, 11, 17, 12, 18, 13, 19, 14, 20, 15);
  IfDescs: array[0..5] of string = (
    SBytes,
    SUnicastPackets,
    SNonunicastPackets,
    SDiscards,
    SErrors,
    SUnknownProtocols);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  Values: array [0..10] of TAsnCounter32;
  I: Integer;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SIfDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SReceived;
        Alignment := taRightJustify;
        Width := 130;
      end;
      with Columns.Add do
      begin
        Caption := SSent;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  FillChar(Values, SizeOf(Values), 0);
  for I := 0 to High(Identifiers) do
  begin
    with VarBindList do
    begin
      list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
      len := 1;
      with list^ do
      begin
        SnmpMgrStrToOid(PAnsiChar(SIfEntry), @name);
        PIds(name.ids)^[9] := Identifiers[I];
        value.asnType := ASN_NULL;
      end;
    end;
    try
      while True do
      begin
        CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                       @VarBindList, @ErrorStatus, @ErrorIndex));
        if Identifiers[I] <> PIds(VarBindList.list^.name.ids)^[9] then
          Break;
        Values[I] := Values[I] + VarBindList.list^.value.asnValue.counter;
      end;
    finally
      SnmpUtilVarBindListFree(@VarBindList);
    end;
  end;
  for I := 0 to High(IfDescs) do
    with ListView.Items.Add do
    begin
      ImageIndex := 7;
      Caption := IfDescs[I];
      SubItems.Add(FormatNumber(Values[I]));
      if I < High(IfDescs) then
        SubItems.Add(FormatNumber(Values[I + Length(IfDescs)]))
      else
        SubItems.Add('');
    end;
end;

procedure TChildForm.GetIpStats;
const
  Identifiers: array[0..16] of UINT = (3, 4, 5, 6, 7, 8, 9, 10, 23, 11,
    12, 14, 15, 16, 17, 18, 19);
  IpDescs: array[0..16] of string = (
    SPacketsRecv,
    SRecvHeaderErrors,
    SRecvAddressErrors,
    SDatagramsForwarded,
    SUnknownProtocolsRecv,
    SRecvPacketsDiscarded,
    SRecvPacketsDelivered,
    SOutputRequests,
    SRoutingDiscards,
    SDiscardedOutputPackets,
    SOutputPacketNoRoute,
    SReassemblyRequired,
    SReassemblySuccessful,
    SReassemblyFailures,
    SDatagramsSuccFragmented,
    SDatagramsFailFragmentation,
    SFragmentsCreated);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  Values: array [0..16] of TAsnCounter32;
  I: Integer;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SIpDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SValue;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  FillChar(Values, SizeOf(Values), 0);
  for I := 0 to High(Identifiers) do
  begin
    with VarBindList do
    begin
      list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
      len := 1;
      with list^ do
      begin
        SnmpMgrStrToOid(PAnsiChar(SIpEntry), @name);
        PIds(name.ids)^[7] := Identifiers[I];
        value.asnType := ASN_NULL;
      end;
    end;
    try
      CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GET,
                                     @VarBindList, @ErrorStatus, @ErrorIndex));
      Values[I] := VarBindList.list^.value.asnValue.counter;
    finally
      SnmpUtilVarBindListFree(@VarBindList);
    end;
  end;
  for I := 0 to High(IpDescs) do
    with ListView.Items.Add do
    begin
      ImageIndex := 5;
      Caption := IpDescs[I];
      SubItems.Add(FormatNumber(Values[I]));
    end;
end;

procedure TChildForm.GetIcmpStats;
const
  IcmpDescs: array[0..14] of string = (
    SMessages,
    SErrors,
    SDestUnreachable,
    STimeExceeded,
    SParameterProblems,
    SSourceQuenchs,
    SRedirects,
    SEchos,
    SEchoReplies,
    STimestamps,
    STimestampReplies,
    SAddressMasks,
    SAddressMaskReplies,
    SRouterSolicitations,
    SRouterAdvertisements);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  Values: array [0..25] of TAsnCounter32;
  I: Integer;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SIcmpDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SReceived;
        Alignment := taRightJustify;
        Width := 130;
      end;
      with Columns.Add do
      begin
        Caption := SSent;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  FillChar(Values, SizeOf(Values), 0);
  with VarBindList do
  begin
    list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
    len := 1;
    with list^ do
    begin
      SnmpMgrStrToOid(PAnsiChar(SIcmpEntry), @name);
      value.asnType := ASN_NULL;
    end;
  end;
  try
    for I := 0 to High(Values) do
    begin
      CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                     @VarBindList, @ErrorStatus, @ErrorIndex));
      Values[I] := VarBindList.list^.value.asnValue.counter;
    end;
  finally
    SnmpUtilVarBindListFree(@VarBindList);
  end;
  for I := 0 to High(IcmpDescs) do
    with ListView.Items.Add do
    begin
      ImageIndex := 5;
      Caption := IcmpDescs[I];
      SubItems.Add(FormatNumber(Values[I]));
      SubItems.Add(FormatNumber(Values[I + Length(IcmpDescs)]));
    end;
end;

procedure TChildForm.GetTcpStats;
const
  TcpDescs: array[0..7] of string = (
    SActiveOpens,
    SPassiveOpens,
    SFailedConnAttempts,
    SResetConns,
    SCurrentConns,
    SSegmentsRecv,
    SSegmentsSent,
    SSegmentsRetransmitted);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  Values: array [0..7] of TAsnCounter32;
  I: Integer;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := STcpDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SValue;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  FillChar(Values, SizeOf(Values), 0);
  with VarBindList do
  begin
    list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
    len := 1;
    with list^ do
    begin
      SnmpMgrStrToOid(PAnsiChar(STcpEntry), @name);
      value.asnType := ASN_NULL;
    end;
  end;
  try
    for I := 0 to High(Values) do
    begin
      CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                     @VarBindList, @ErrorStatus, @ErrorIndex));
      Values[I] := VarBindList.list^.value.asnValue.counter;
    end;
  finally
    SnmpUtilVarBindListFree(@VarBindList);
  end;
  for I := 0 to High(TcpDescs) do
    with ListView.Items.Add do
    begin
      ImageIndex := 5;
      Caption := TcpDescs[I];
      SubItems.Add(FormatNumber(Values[I]));
    end;
end;

procedure TChildForm.GetUdpStats;
const
  UdpDescs: array[0..3] of string = (
    SDatagramsRecv,
    SNoPorts,
    SRecvErrors,
    SDatagramsSent);
var
  VarBindList: TSnmpVarBindList;
  ErrorStatus, ErrorIndex: TAsnInteger32;
  Values: array [0..3] of TAsnCounter32;
  I: Integer;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SUdpDesc;
        Width := 210;
      end;
      with Columns.Add do
      begin
        Caption := SValue;
        Alignment := taRightJustify;
        Width := 130;
      end;
    end;
  FillChar(Values, SizeOf(Values), 0);
  with VarBindList do
  begin
    list := SnmpUtilMemAlloc(SizeOf(TSnmpVarBind));
    len := 1;
    with list^ do
    begin
      SnmpMgrStrToOid(PAnsiChar(SUdpEntry), @name);
      value.asnType := ASN_NULL;
    end;
  end;
  try
    for I := 0 to High(Values) do
    begin
      CheckSnmpResult(SnmpMgrRequest(FSession, SNMP_PDU_GETNEXT,
                                     @VarBindList, @ErrorStatus, @ErrorIndex));
      Values[I] := VarBindList.list^.value.asnValue.counter;
    end;
  finally
    SnmpUtilVarBindListFree(@VarBindList);
  end;
  for I := 0 to High(UdpDescs) do
    with ListView.Items.Add do
    begin
      ImageIndex := 5;
      Caption := UdpDescs[I];
      SubItems.Add(FormatNumber(Values[I]));
    end;
end;

procedure TChildForm.GetBaseDescs;
const
  TableDescs: array[0..4] of string = (
    SIfTableDesc,
    SArpTableDesc,
    SIpAddressTableDesc,
    SRouteTableDesc,
    SConnsTableDesc);
  StatDescs: array[0..4] of string = (
    SIfStatDesc,
    SIpStatDesc,
    SIcmpStatDesc,
    STcpStatDesc,
    SUdpStatDesc);
var
  CurItem: TTreeNode;
begin
  if FRecreateColumns then
    with ListView do
    begin
      with Columns.Add do
      begin
        Caption := SName;
        Width := 100;
      end;
      with Columns.Add do
      begin
        Caption := SDesc;
        Width := 210;
      end;
    end;
  CurItem := TreeView.Selected.GetFirstChild;
  while Assigned(CurItem) do
  begin
    with ListView.Items.Add do
    begin
      ImageIndex := 3;
      Caption := CurItem.Text;
      if FActiveLevel = alTableDesc then
        SubItems.Add(TableDescs[CurItem.Index])
      else
        SubItems.Add(StatDescs[CurItem.Index]);
    end;
    CurItem := CurItem.GetNextChild(CurItem);
  end;
end;

procedure TChildForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actUp.Enabled := FActiveLevel in [alTableDesc..alUdpStat];
  actRefresh.Enabled := FConnected;
end;

end.
