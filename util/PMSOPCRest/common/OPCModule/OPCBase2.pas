unit OPCBase2;

interface

uses windows, Dialogs,
  // OPC  *****************************
  OPCCOMN, OPCDA, OPCerror, OPCCallback,
  ComObj, ActiveX, ComCtrls
  // OPC  *****************************
;

type
  TOPCBase2 = class(TObject)
  private
    function OPCServerConnect(AServerProgID: WideString): Boolean;
    function OPCGroupConnect(AGroupName: OleVariant): Boolean;
  protected
    FOPCServer: IOPCServer;   // Interface IOPCServer
    FOPCGroup: OPCHANDLE;    // Server Handle Group;
    FOPCItems: array of OPCHANDLE;   // Server Handles Items
    //FOPCItem: OPCItem; // interface

    FIOPCItemMgt : IOPCItemMgt;  // Interface IOPCItemMgt
    FIOPCSyncIO  : IOPCSyncIO;   // Interface IOPCSyncIO
    FSGroup      : OPCHANDLE;    // Server Handle Group
    FSItems      : array of OPCHANDLE;   // Server Handles Items
    FOPCDataCallback : IOPCDataCallback; // Callback Object
    FIConnectionPoint: IConnectionPoint; // Connection Point for Callback
    FCookie : Longint;  // Cookie for Advise/Unadvise

  public
{    FItemCount: integer;
    FItemSubCount: integer;
    FIsOPCServerConnected: Boolean;

    FItemServerHandles: OleVariant;
    FOPCItemIDs: OleVariant;
    FClientHandles: OleVariant;
    FItemServerErrors: OleVariant;
}
    FServerName : string; // Name of OPC Server
    FGroupName  : string; // Name of OPC Group
    FItemIDs : array of PWideChar;  //Array of ItemIDs
    FItemNumb : Longint;   //Number of OPC Items
    FServerConnected : Boolean; // OPC Server is connected = TRUE
    FGroupAdded : Boolean;      // OPC Group is added = TRUE
    FValueStart :  POPCITEMSTATEARRAY; //Read Value

    constructor create;
    destructor destroy;
    procedure OPCServerDisconnect;
    function InitializeOPC(AServerName, AGroupName: string): Boolean;
    procedure InitItemList; virtual;

    function ReadSync : Boolean;
    procedure RemGroup;
    procedure RemoveItems;
    procedure AdviseCallback;
    procedure UnadviseCallback;
  end;

implementation

{ TOPCBase2 }

constructor TOPCBase2.create;
begin
  inherited;
end;

destructor TOPCBase2.destroy;
begin
  OPCServerDisconnect;

  inherited;
end;

function TOPCBase2.InitializeOPC(AServerName, AGroupName: string): Boolean;
begin
  FServerConnected := False;

  if not OPCServerConnect(AServerName) then
  begin
    OPCServerDisconnect;
    Exit;
  end;

  if not OPCGroupConnect(AGroupName) then
  begin
    OPCServerDisconnect;
    Exit;
  end;

  FServerConnected := True;
end;

procedure TOPCBase2.InitItemList;
var
  i : Integer;
  HRes     : HRESULT;
  ItemDef  : array of OPCITEMDEF;
  Results  : POPCITEMRESULTARRAY;
  Errors   : PResultList;
begin
  if not FServerConnected or not FGroupAdded then
     Exit;
  // Allocate Array of OPCITEMDEF
  SetLength(ItemDef, FItemNumb);

  for i := 0 to FItemNumb-1 do begin
    with ItemDef[i] do
      begin
        szAccessPath := '';
        szItemID := FItemIDs[i];  // ItemID
        bActive := True;       // Active -> TRUE to get DataChange Callbacks
        hClient := i+1;          // Item Client Handle to identify the items at the DataChange Callback
        dwBlobSize := 0;
        pBlob := nil;
        vtRequestedDataType := VT_BSTR;  // VT_BSTR  -> Requested Data Type = String (BSTR)
                                         // VT_EMPTY -> Requested Data Type = Canonical Data Type
      end;
  end;
  // Add OPC Items
  HRes := FIOPCItemMgt.AddItems(
                            FItemNumb,   // Number of Items to add
                            @ItemDef[0], // OPCITEMDEF array
                            Results,  // OPCITEMRESULT array
                            Errors);  // Error array
  if Failed(HRes) then
  begin
    //Application.MessageBox('Unable to Add Items to the OPC Group', '', MB_OK);
    Exit;
  end
  else begin
    // Get Item Server Handles
    SetLength(FSItems, FItemNumb);
    for i := 0 to FItemNumb-1 do begin
        //  Check item results
        if Failed(Errors[i]) then begin
            //Application.MessageBox('One Item FAILED at AddItems', '', MB_OK);
            FSItems[i] := 0;
        end
        else begin
            FSItems[i] := Results[i].hServer;
        end;
    end;
    // Advise Callback for OPC Items
    AdviseCallback;
    // Free returned memory
    CoTaskMemFree(Results);
    CoTaskMemFree(Errors);
  end;

  // Free memory of OPCITEMDEF Array
  ItemDef := Nil;
end;

function TOPCBase2.OPCGroupConnect(AGroupName: OleVariant): Boolean;
var
  HRes : HRESULT;
  PercentDeadBand: Single;
  LActive : Boolean;
  UpdateRate, RevisedUpdateRate: DWORD;
begin
  Result := False;
  LActive      := TRUE;  // Group must be active to get DataChange Callbacks
  UpdateRate  := 500;   // 500 ms

  if not FServerConnected then
  begin
    //Application.MessageBox('No Server Connected. Connect to Server before adding Group',
    //                        '',MB_OK);
    Exit;
  end;
  // Add Group
  HRes := FOPCServer.AddGroup(
                           PWideChar(WideString(FGroupName)),   // Group Name from Edit Box
                           LActive,               // Active State
                           UpdateRate,           // Requested Update Rate
                           0,                    // Client Handle Group
                           nil,                  // Time Bias
                           @PercentDeadBand,     // Percent Deadband
                           0,                    // Local ID
                           FSGroup,            // Server Handle Group
                           RevisedUpdateRate,    // Revised Update Rate
                           IOPCItemMgt,          // Requested Interface
                           IUnknown(FIOPCItemMgt));  // Interface Pointer

  if Failed(HRes) then begin
    //Application.MessageBox('Unable to Add a Group Object to the OPC Server Object', '', MB_OK);
    Exit;
  end;
  // OPC Group added
  FGroupAdded := TRUE;
  Result := TRUE;
  // Get the IOPCSyncIO Interface
  FIOPCSyncIO := FIOPCItemMgt as IOPCSyncIO;
end;

// Procedure Connect OPC Server
function TOPCBase2.OPCServerConnect(AServerProgID: WideString): Boolean;
begin
  {implementation code here}
  Result := False;

  if not FServerConnected then
  begin
    // Exception handling
    try
      // Create an OPC Server Object
      FOPCServer := CreateComObject(ProgIDToClassID(FServerName)) as IOPCServer;
    except
      FOPCServer := nil;
    end;

    if FOPCServer = nil then begin
      //Application.MessageBox('Unable to connect to OPC server', '', MB_OK);
      Exit;
    end;
    // OPC Server is connected
    FServerConnected := TRUE;
    Result := TRUE;
  end
  else
     ;//Application.MessageBox('OPC Server Already connected','',MB_OK);
end;

// Procedure Disconnect OPC Server
procedure TOPCBase2.OPCServerDisconnect;
begin
  // Check, if Group is removed
  if FIOPCItemMgt <> nil then begin
     // Remove Group
     RemGroup;
  end;

  if FOPCServer <> nil then begin
    // Release OPC Server Object
     FOPCServer := Nil;
  end;
  // Set OPC ServerConnected Flag = FALSE
  FServerConnected := FALSE;
end;

function TOPCBase2.ReadSync: Boolean;
var
  HRes : HRESULT;
  m_hSItemsStart : array of OPCHANDLE;
  Errors: PResultList;
  Li: integer;
begin

  // Allocate Array for ItemHandle
  SetLength(m_hSItemsStart,FItemNumb);//1);
  // Fill Local Array of Server Handles
  for Li := 0 to FItemNumb - 1 do
    m_hSItemsStart[Li] := FSItems[Li];//12];
{
  m_hSItemsStart[1] := FSItems[1];
  m_hSItemsStart[2] := FSItems[2];
  m_hSItemsStart[3] := FSItems[3];
  m_hSItemsStart[4] := FSItems[4];
  m_hSItemsStart[5] := FSItems[5];
  m_hSItemsStart[6] := FSItems[6];
  m_hSItemsStart[7] := FSItems[7];
  m_hSItemsStart[8] := FSItems[8];
  m_hSItemsStart[9] := FSItems[9];
  m_hSItemsStart[10] := FSItems[10];
}
  // Sync Read of Start_Automatic
  HRes := FIOPCSyncIO.Read(OPC_DS_Cache,        // Source
                             FItemNumb,         // number of Items read
                             @m_hSItemsStart[0],// Server Handles
                             FValueStart,        // Item Value
                             Errors);           //
  if Failed (HRes) then
  begin
    //Application.MessageBox('Unable to Read value', '', MB_OK);
    ReadSync := FALSE;
    Exit;
  end
  else begin
    // Free returned memory
    CoTaskMemFree(Errors);
  end;
  // Check Value of Start_Automatic
  if FValueStart[0].vDataValue Then
    ReadSync := TRUE
  else
    ReadSync := FALSE;


  // Release Array
  m_hSItemsStart := Nil;
end;

// Procedure Remove OPC Group
procedure TOPCBase2.RemGroup;
var
  HRes : HRESULT;
begin
  if not FServerConnected or not FGroupAdded then
     Exit;
  // Check, if Callback is Unadvised
  if FIConnectionPoint <> nil then begin
     // Unadvise Callback
     UnadviseCallback;
  end;

  FIOPCItemMgt := Nil; // delete outstanding references
  FIOPCSyncIO  := Nil; // at the group

  // Remove Group
  HRes := FOPCServer.RemoveGroup( FSGroup, // Server Handle Group
                                  TRUE);   // bForce = TRUE -> delete Group,
                                           // there should be no outstanding references
  if Failed(HRes) then begin
    //Application.MessageBox('Unable to add a Group Object to the OPC Server Object', '', MB_OK);
    Exit;
  end;
  // Set Group Added FALSE
  FGroupAdded := FALSE;
  // Free memory of OPC Server Handles
  FSItems := Nil;
  // Free memory of OPC ItemIDs Array
  FItemIDs := Nil;
end;

// Procedure Remove OPC Items
procedure TOPCBase2.RemoveItems;
var
  i : integer;
  HRes     : HRESULT;
  Errors   : PResultList;
begin

  if not FServerConnected or not FGroupAdded then
     Exit;
  // Add OPC Items
  HRes := FIOPCItemMgt.RemoveItems(FItemNumb, //number of Items to remove
                                     @FSItems[0], //
                                     Errors);  // Error Array

  if Failed(HRes) then
  begin
    //Application.MessageBox('Unable to Remove Items from OPC Group', '', MB_OK);
    Exit;
  end
  else begin
    // Get Item Server Handles
    for i := 0 to FItemNumb - 1 do begin
        //  Check item results
        if Failed(Errors[i]) then begin
            ;//Application.MessageBox('One Item FAILED at RemoveItems', '', MB_OK);
        end;
    end;
    // Free returned memory
    CoTaskMemFree(Errors);
  end;
end;

procedure TOPCBase2.AdviseCallback;
var
  HRes : HRESULT;
  pIConnectionPointContainer: IConnectionPointContainer;
begin
  // now set up an IConnectionPointContainer data callback for the group
  try
    // Get the IConnectionPoint Container Interface of the Group
    pIConnectionPointContainer := FIOPCItemMgt as IConnectionPointContainer;
  except
    pIConnectionPointContainer := nil;
    exit;
  end;
  // Create Callback Object
  FOPCDataCallback := TOPCDataCallback.Create;
  // Get the IConnectionPoint Interface for the Callback Interface
  HRes := pIConnectionPointContainer.FindConnectionPoint(
                                          IID_IOPCDataCallback,  // IID of the Callback Interface
                                          FIConnectionPoint);    // Returned Connection Point
  if Failed(HRes) then begin
    //Application.MessageBox('FindConnectionPoint for IOPCDataCallback FAILED', '', MB_OK);
    FOPCDataCallback := Nil;
  end
  else begin
    // Advise the connection between Server and Client for Callbacks
    HRes := FIConnectionPoint.Advise( FOPCDataCallback as IUnknown, FCookie);
    if Failed(HRes) then begin
      //Application.MessageBox('Advise Connection for Callback FAILED', '', MB_OK);
      FOPCDataCallback := Nil;
      FIConnectionPoint := Nil;
    end;
  end;
end;

procedure TOPCBase2.UnadviseCallback;
var
  HRes : HRESULT;
begin
  if FIConnectionPoint <> nil then begin
    HRes := FIConnectionPoint.Unadvise(FCookie);
     if Failed(HRes) then begin
         ;//Application.MessageBox('Unadvise Connection for Callback FAILED', '', MB_OK);
     end
  end;

  // delete Callback Object and Connection Point Interface
  FOPCDataCallback := Nil;
  FIConnectionPoint := Nil;
end;

end.
