unit UnitOPCServer;

interface

uses Windows, Messages, SysUtils, Dialogs, OPCCOMN, OPCDA, OPCerror, OPCCallback,
  ComObj, ActiveX, ComCtrls, Classes, UnitTagCollect, synCommons;

type
  TpjhOPCServer = class(TObject)
  private
    m_pIOPCServer  : IOPCServer;   // Interface IOPCServer

    m_pIOPCItemMgt : IOPCItemMgt;  // Interface IOPCItemMgt
    m_pIOPCSyncIO  : IOPCSyncIO;   // Interface IOPCSyncIO
    m_hSGroup      : OPCHANDLE;    // Server Handle Group
    m_hSItems      : array of OPCHANDLE;   // Server Handles Items
    m_pOPCDataCallback : IOPCDataCallback; // Callback Object
    m_pIConnectionPoint: IConnectionPoint; // Connection Point for Callback
    m_Cookie : Longint;  // Cookie for Advise/Unadvise

    FServerName : string; // Name of OPC Server
    FGroupName  : string; // Name of OPC Group
    FItemIDs : array of PChar;  //Array of ItemIDs
    FItemNumb : Longint;   //Number of OPC Items
    FServerConnected : Boolean; // OPC Server is connected = TRUE
    FGroupAdded : Boolean;      // OPC Group is added = TRUE
  public
    FTagList: TTagCollect;
    FTagList4AddItem: TTagCollect4OPCAddItem;

    constructor Create();
    destructor Destroy;

    procedure InitItemId;
    procedure AddGroup(GroupName : string);
    procedure AddItems(AItemIDs : array of PChar; AItemNumb : Longint);
    procedure AdviseCallback;
    procedure Connect(ServerName : string);
    procedure Disconnect;
    function ReadSync : Boolean;
    procedure RemGroup;
    procedure RemoveItems;
    procedure UnadviseCallback;

    procedure OPCConnect;

    function GetTagList: TTagCollect;
  end;

implementation

{ TpjhOPCServer }

procedure TpjhOPCServer.AddGroup(GroupName: string);
var
  HRes : HRESULT;
  PercentDeadBand: Single;
  Active : BOOL;
  UpdateRate, RevisedUpdateRate: DWORD;
begin
  Active      := TRUE;  // Group must be active to get DataChange Callbacks
  UpdateRate  := 500;   // 500 ms

  if not FServerConnected then
  begin
     ShowMessage('No Server Connected. Connect to Server before adding Group');
     Exit;
  end;
  // Add Group
  HRes := m_pIOPCServer.AddGroup(
                           PWideChar(WideString(GroupName)),   // Group Name from Edit Box
                           Active,               // Active State
                           UpdateRate,           // Requested Update Rate
                           0,                    // Client Handle Group
                           nil,                  // Time Bias
                           @PercentDeadBand,     // Percent Deadband
                           0,                    // Local ID
                           m_hSGroup,            // Server Handle Group
                           RevisedUpdateRate,    // Revised Update Rate
                           IOPCItemMgt,          // Requested Interface
                           IUnknown(m_pIOPCItemMgt));  // Interface Pointer

  if Failed(HRes) then begin
    ShowMessage('Unable to Add a Group Object to the OPC Server Object');
    Exit;
  end;
  // OPC Group added
  FGroupAdded := TRUE;
  // Get the IOPCSyncIO Interface
  m_pIOPCSyncIO := m_pIOPCItemMgt as IOPCSyncIO;
end;

procedure TpjhOPCServer.AddItems(AItemIDs: array of PChar; AItemNumb: Integer);
var
  i : Integer;
  HRes     : HRESULT;
  LItemDef  : array of OPCITEMDEF;
  Results  : POPCITEMRESULTARRAY;
  Errors   : PResultList;
begin
  if not FServerConnected or not FGroupAdded then
     Exit;
  // Allocate Array of OPCITEMDEF
  SetLength(LItemDef, AItemNumb);

  for i := 0 to AItemNumb - 1 do
  begin
    with LItemDef[i] do
    begin
      szAccessPath := '';
      szItemID := AItemIDs[i];  // ItemID
      bActive := True;       // Active -> TRUE to get DataChange Callbacks
      hClient := i+1;          // Item Client Handle to identify the items at the DataChange Callback
      dwBlobSize := 0;
      pBlob := nil;
      vtRequestedDataType := VT_BSTR;  // VT_BSTR  -> Requested Data Type = String (BSTR)
                                       // VT_EMPTY -> Requested Data Type = Canonical Data Type
    end;
  end;
  // Add OPC Items
  HRes := m_pIOPCItemMgt.AddItems(
                            AItemNumb,   // Number of Items to add
                            @LItemDef[0], // OPCITEMDEF array
                            Results,  // OPCITEMRESULT array
                            Errors);  // Error array
  if Failed(HRes) then
  begin
    ShowMessage('Unable to Add Items to the OPC Group');
    Exit;
  end
  else
  begin
    // Get Item Server Handles
    SetLength(m_hSItems, AItemNumb);

    for i := 0 to AItemNumb-1 do
    begin
      //  Check item results
      if Failed(Errors[i]) then
      begin
        ShowMessage('"' + FTagList.Item[i].TagName +  '" Item FAILED at AddItems');
        m_hSItems[i] := 0;
      end
      else
      begin
        m_hSItems[i] := Results[i].hServer;
      end;
    end;
    // Advise Callback for OPC Items
    AdviseCallback;
    // Free returned memory
    CoTaskMemFree(Results);
    CoTaskMemFree(Errors);
  end;

  // Free memory of OPCITEMDEF Array
  LItemDef := Nil;
end;

procedure TpjhOPCServer.AdviseCallback;
var
  HRes : HRESULT;
  pIConnectionPointContainer: IConnectionPointContainer;
begin
  // now set up an IConnectionPointContainer data callback for the group
  try
    // Get the IConnectionPoint Container Interface of the Group
    pIConnectionPointContainer := m_pIOPCItemMgt as IConnectionPointContainer;
  except
    pIConnectionPointContainer := nil;
    exit;
  end;
  // Create Callback Object
  m_pOPCDataCallback := TOPCDataCallback.Create;
  // Get the IConnectionPoint Interface for the Callback Interface
  HRes := pIConnectionPointContainer.FindConnectionPoint(
                                          IID_IOPCDataCallback,  // IID of the Callback Interface
                                          m_pIConnectionPoint);    // Returned Connection Point
  if Failed(HRes) then
  begin
    ShowMessage('FindConnectionPoint for IOPCDataCallback FAILED');
    m_pOPCDataCallback := Nil;
  end
  else
  begin
    // Advise the connection between Server and Client for Callbacks
    HRes := m_pIConnectionPoint.Advise( m_pOPCDataCallback as IUnknown,
                                         m_Cookie);
    if Failed(HRes) then begin
      ShowMessage('Advise Connection for Callback FAILED');
      m_pOPCDataCallback := Nil;
      m_pIConnectionPoint := Nil;
    end;
  end;
end;

procedure TpjhOPCServer.Connect(ServerName: string);
begin
  {implementation code here}
  if not FServerConnected then
  begin
    // Exception handling
    try
      // Create an OPC Server Object
      m_pIOPCServer := CreateComObject(ProgIDToClassID(ServerName)) as IOPCServer;
    except
      m_pIOPCServer := nil;
    end;

    if m_pIOPCServer = nil then
    begin
      ShowMessage('Unable to connect to OPC server');
      Exit;
    end;
    // OPC Server is connected
    FServerConnected := TRUE;
  end
  else
    ShowMessage('OPC Server Already connected');
end;

constructor TpjhOPCServer.Create;
begin
  inherited;

  FTagList := TTagCollect.Create;
  FTagList4AddItem := TTagCollect4OPCAddItem.Create;
end;

destructor TpjhOPCServer.Destroy;
begin
  if Assigned(FTagList) then
    FTagList.Free;

  if Assigned(FTagList4AddItem) then
    FTagList4AddItem.Free;
end;

procedure TpjhOPCServer.Disconnect;
begin
  // Check, if Group is removed
  if m_pIOPCItemMgt <> nil then begin
    // Remove Group
    RemGroup;
  end;

  if m_pIOPCServer <> nil then begin
    // Release OPC Server Object
    m_pIOPCServer := Nil;
  end;

  // Set OPC ServerConnected Flag = FALSE
  FServerConnected := FALSE;
end;

function TpjhOPCServer.GetTagList: TTagCollect;
begin
  Result := FTagList;
end;

procedure TpjhOPCServer.InitItemId;
var
  i: integer;
  LStr: string;
begin
  if FTagList.Count > 0 then
    FItemNumb := FTagList.Count;

//  FItemNumb := 10;

  // Allocate Array of ItemIDs
  SetLength(FItemIDs, FItemNumb);
  // Name of OPC Server
//  FServerName := '\\192.168.1.112:135\OpcServer.WinCC.1';//'\\192.168.1.112:888\OpcServer.WinCC.1';
//  FServerName := 'opcda:///OPCServer.WinCC.1/{75D00BBB-DDA5-11D1-B944-9E614D000000}';
  FServerName := 'OPCServer.WinCC.1';
  // Write Name of OPC Server in Text Box
//  TxtServerName.Text := FServerName;
  // Name of OPC Group
  FGroupName := 'Group1';

  // Fill Array of ItemIDs
  for i := 0 to FItemNumb - 1 do
  begin
//    LStr := SynCommons.UTF8ToString(FTagList.Item[i].TagName);
//    FItemIDs[i] := PChar(FTagName4AddItem[i]);
    FItemIDs[i] := PChar(FTagList4AddItem.Item[i].TagName);
  end;
//    FItemIDs[i] := PChar(UTF8ToString(FTagList.Item[i].TagName));
//    FItemIDs[0] := PChar('ACB_G4_VAB');
//    FItemIDs[1] := PChar('ACB_G4_VBC');
//    FItemIDs[2] := PChar('ACB_G4_VCA');
//    FItemIDs[3] := PChar('ACB_G4_IA');
//    FItemIDs[4] := PChar('ACB_G4_IB');
//    FItemIDs[5] := PChar('ACB_G4_IC');
//    FItemIDs[6] := PChar('ACB_G4_PF');
//    FItemIDs[7] := PChar('ACB_G4_HZ');
//    FItemIDs[8] := PChar('ACB_G4_KW');
//    FItemIDs[9] := PChar('ACB_G4_KVAR');
end;

procedure TpjhOPCServer.OPCConnect;
var
  StartOrStop : Boolean;
begin
  // Call procedure Connect OPC Server
  Connect(FServerName);
  // Call procedure Add OPC Group
  AddGroup(FGroupName);
  // Call procedure Add OPC Items
  AddItems(FItemIDs, FItemNumb);
  // Check if Start_Automatic True
  StartOrStop := ReadSync;
end;

function TpjhOPCServer.ReadSync: Boolean;
var
  HRes : HRESULT;
  m_hSItemsStart : array of OPCHANDLE;
  ValueStart :  POPCITEMSTATEARRAY;
  Errors: PResultList;
begin
  // Allocate Array for ItemHandle
  SetLength(m_hSItemsStart,1);
  // Fill Local Array of Server Handles
  m_hSItemsStart[0] := m_hSItems[12];
  // Sync Read of Start_Automatic

  HRes := m_pIOPCSyncIO.Read(OPC_DS_Cache, // Source
                             1,            // number of Items read
                             @m_hSItemsStart[0],// Server Handles
                             ValueStart,   // Item Value
                             Errors);      //
  if Failed (HRes) then
  begin
    ShowMessage('Unable to Read value');
    ReadSync := FALSE;
    Exit;
  end
  else
  begin
    // Free returned memory
    CoTaskMemFree(Errors);
  end;
  // Check Value of Start_Automatic
  if  ValueStart[0].vDataValue Then
    ReadSync := TRUE
  else
    ReadSync := FALSE;

  // Release Array
  m_hSItemsStart := Nil;
end;

procedure TpjhOPCServer.RemGroup;
var
  HRes : HRESULT;
begin
  if not FServerConnected or not FGroupAdded then
     Exit;
  // Check, if Callback is Unadvised
  if m_pIConnectionPoint <> nil then begin
     // Unadvise Callback
     UnadviseCallback;
  end;

  m_pIOPCItemMgt := Nil; // delete outstanding references
  m_pIOPCSyncIO  := Nil; // at the group

  // Remove Group
  HRes := m_pIOPCServer.RemoveGroup( m_hSGroup, // Server Handle Group
                                     TRUE);     // bForce = TRUE -> delete Group,
                                                // there should be no outstanding references
  if Failed(HRes) then begin
    ShowMessage('Unable to add a Group Object to the OPC Server Object');
    Exit;
  end;
  // Set Group Added FALSE
  FGroupAdded := FALSE;
  // Free memory of OPC Server Handles
  m_hSItems := Nil;
  // Free memory of OPC ItemIDs Array
  FItemIDs := Nil;
end;

procedure TpjhOPCServer.RemoveItems;
var
  i : integer;
  HRes     : HRESULT;
  Errors   : PResultList;
begin

  if not FServerConnected or not FGroupAdded then
     Exit;
  // Add OPC Items
  HRes := m_pIOPCItemMgt.RemoveItems(FItemNumb, //number of Items to remove
                                     @m_hSItems[0], //
                                     Errors);  // Error Array

  if Failed(HRes) then
  begin
    ShowMessage('Unable to Remove Items from OPC Group');
    Exit;
  end
  else
  begin
    // Get Item Server Handles
    for i := 0 to FItemNumb-1 do
    begin
      //  Check item results
      if Failed(Errors[i]) then
      begin
          ShowMessage('One Item FAILED at RemoveItems');
      end;
    end;

    // Free returned memory
    CoTaskMemFree(Errors);
  end;
end;

procedure TpjhOPCServer.UnadviseCallback;
var
  HRes : HRESULT;
begin
  if m_pIConnectionPoint <> nil then
  begin
    HRes := m_pIConnectionPoint.Unadvise(m_Cookie);

    if Failed(HRes) then
    begin
     ShowMessage('Unadvise Connection for Callback FAILED');
    end
  end;

  // delete Callback Object and Connection Point Interface
  m_pOPCDataCallback := Nil;
  m_pIConnectionPoint := Nil;
end;

end.
