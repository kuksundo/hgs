unit ServerContainer_Unit;

interface

uses System.SysUtils, System.Classes, Winapi.Windows,
  Datasnap.DSTCPServerTransport,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSAuth, System.Generics.Collections, IdTCPConnection, Main_Unit,
  IndyPeerImpl, DbxSocketChannelNative, DbxCompressionFilter,
  Datasnap.DSHTTPCommon, Datasnap.DSHTTP;

type
  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSTCPServerTransport1: TDSTCPServerTransport;
    Get_Photorum_Session_Class: TDSServerClass;
    Get_Monitoring_Session_Class: TDSServerClass;
    Get_LDS_Session_Class: TDSServerClass;
    Get_TRC_Session_Class: TDSServerClass;
    Get_HiTEMS_Session_Class: TDSServerClass;
    procedure DSTCPServerTransport1Connect(Event: TDSTCPConnectEventObject);
    procedure DSTCPServerTransport1Disconnect(
      Event: TDSTCPDisconnectEventObject);
    procedure Get_Photorum_Session_ClassGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure Get_Monitoring_Session_ClassGetClass(
      DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
    procedure Get_LDS_Session_ClassGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure Get_TRC_Session_ClassGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure Get_HiTEMS_Session_ClassGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure Get_Monitoring_Session_ClassCreateInstance(
      DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
    procedure Get_Monitoring_Session_ClassDestroyInstance(
      DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
    procedure Get_Photorum_Session_ClassCreateInstance(
      DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
    procedure Get_Photorum_Session_ClassDestroyInstance(
      DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
    procedure Get_LDS_Session_ClassCreateInstance(
      DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
    procedure Get_LDS_Session_ClassDestroyInstance(
      DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
    procedure Get_TRC_Session_ClassCreateInstance(
      DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
    procedure Get_TRC_Session_ClassDestroyInstance(
      DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
    procedure Get_HiTEMS_Session_ClassCreateInstance(
      DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
    procedure Get_HiTEMS_Session_ClassDestroyInstance(
      DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
  private
    { Private declarations }
    FConnections : TObjectDictionary<TIdTCPConnection,TDSTCPChannel>;
    procedure Update_TCPMonitor_Info;
    procedure Add_ConnectionToList(Conn:TIdTCPConnection;Channel:TDSTCPChannel);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DisConnectConnection(aConnection:TIdTCPConnection);
  end;

  function DSServer: TDSServer;

//var
//ServerContainer1: TServerContainer1;

var
  FModule: TComponent;
  ServerContainer1: TServerContainer1;
  FDSServer: TDSServer;
  disstr : String;

  pConn:TIdTCPConnection;
  ConnInfoStr:String;
  ConnInfoStr1:String;

implementation

uses
  ServerMethods_HiTEMS_Unit,
  ServerMethods_TRC_Unit,
  ServerMethods_LDS_Unit,
  ServerMethods_Monitoring_Unit,
  ServerMethods_Photorum_Unit;

{$R *.dfm}



function DSServer: TDSServer;
begin
  Result := FDSServer;
end;

procedure TServerContainer1.Add_ConnectionToList(Conn: TIdTCPConnection;
  Channel: TDSTCPChannel);
begin
  pConn := Conn;
  if (Conn <> nil) and (Channel <> nil) and (Channel.ChannelInfo <> nil) and
     (Channel.ChannelInfo.ClientInfo.IpAddress <> EmptyStr) then
  begin
    with Channel.ChannelInfo.ClientInfo do
    begin
      ConnInfoStr  := Format('%s:%s',[IPAddress,ClientPort]);
      ConnInfoStr1 := Format('AppName: %s, Protocol: %s, IP: %s, Port: %s',
                              [AppName,Protocol,IpAddress,ClientPort]);


    end;
  end else
    ConnInfoStr := 'Channel information is incorrect';
end;

constructor TServerContainer1.Create(AOwner: TComponent);
begin
  inherited;
  FDSServer := DSServer1;
  FConnections := TObjectDictionary<TIdTCPConnection,TDSTCPChannel>.Create;
end;

destructor TServerContainer1.Destroy;
begin
  inherited;
  FDSServer := nil;
end;

procedure TServerContainer1.DisConnectConnection(aConnection: TIdTCPConnection);
var
  lChannel : TDSTCPChannel;
begin
  if (aConnection <> nil) then
  begin
    FConnections.TryGetValue(aConnection,lChannel);

    TThread.Synchronize(nil,
                        procedure
                        var
                          i:Integer;
                          sip,sport:String;
                        begin
                          sip := lChannel.ChannelInfo.ClientInfo.IpAddress;
                          sport := lChannel.ChannelInfo.ClientInfo.ClientPort;
                          disstr := Format('%s:%s',[sip,sport]);
//                          i := Main_Frm.connectionList.Items.IndexOf(disstr);

                          if i <> -1 then
                          begin
//                            Main_Frm.connectionList.Items[i] :=
//                              Format('%s:%s Passive disconnect',[sip,sport]);
                          end;
                        end
                       );

    System.TMonitor.Enter(FConnections);
    FConnections.Remove(aConnection);
    System.TMonitor.Exit(FConnections);
    lChannel.Close;
  end;
end;

procedure TServerContainer1.DSTCPServerTransport1Connect(
  Event: TDSTCPConnectEventObject);
begin
  System.TMonitor.Enter(FConnections);
  try
    FConnections.Add(TIdTCPConnection(Event.Connection), Event.Channel);
  finally
    System.TMonitor.Exit(FConnections);
  end;
  Add_ConnectionToList(TIdTCPConnection(Event.Connection),Event.Channel);
  TThread.Synchronize(nil,Update_TCPMonitor_Info);
end;

procedure TServerContainer1.DSTCPServerTransport1Disconnect(
  Event: TDSTCPDisconnectEventObject);
var
  sip,sport:string;
  conn:TIdTCPConnection;
  i:integer;
begin
   conn:=TIdTCPConnection(Event.Connection);

  if Assigned(conn) then
  begin
    sip:=conn.Socket.Binding.PeerIP;
    sport:=IntToStr(conn.Socket.Binding.PeerPort);
    System.TMonitor.Enter(FConnections);
     if FConnections.ContainsKey(conn) then
     FConnections.Remove(conn);
    System.TMonitor.Exit(FConnections);
//    i:= Main_Frm.connectionList.Items.IndexOf(Format('%s:%s',[sip,sport]));
//    if i<>-1 then
//    begin
//      Main_Frm.connectionList.Items[i]:=Format('%s:%s Passive disconnect',[sip,sport]);
//    end;
  end;
//  Main_Frm.edtSessionCount.Text:=IntToStr(FConnections.Count);
end;



procedure TServerContainer1.Get_HiTEMS_Session_ClassCreateInstance(
  DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
begin
  DSCreateInstanceEventObject.ServerClassInstance := TServerMethods_HiTEMS.Create(nil);
end;

procedure TServerContainer1.Get_HiTEMS_Session_ClassDestroyInstance(
  DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
begin
  DSDestroyInstanceEventObject.ServerClassInstance.Free;
end;

procedure TServerContainer1.Get_HiTEMS_Session_ClassGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := TServerMethods_HiTEMS;
end;

procedure TServerContainer1.Get_LDS_Session_ClassCreateInstance(
  DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
begin
  DSCreateInstanceEventObject.ServerClassInstance := TServerMethods_LDS.Create(nil);
end;

procedure TServerContainer1.Get_LDS_Session_ClassDestroyInstance(
  DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
begin
  DSDestroyInstanceEventObject.ServerClassInstance.Free;
end;

procedure TServerContainer1.Get_LDS_Session_ClassGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := TServerMethods_LDS;

end;

procedure TServerContainer1.Get_Monitoring_Session_ClassCreateInstance(
  DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
begin
  DSCreateInstanceEventObject.ServerClassInstance := TServerMethods_Monitoring.Create(nil);
end;

procedure TServerContainer1.Get_Monitoring_Session_ClassDestroyInstance(
  DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
begin
  DSDestroyInstanceEventObject.ServerClassInstance.Free;
end;

procedure TServerContainer1.Get_Monitoring_Session_ClassGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := TServerMethods_Monitoring;
end;

procedure TServerContainer1.Get_Photorum_Session_ClassCreateInstance(
  DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
begin
  DSCreateInstanceEventObject.ServerClassInstance := TServerMethods_Photorum.Create(nil);
end;

procedure TServerContainer1.Get_Photorum_Session_ClassDestroyInstance(
  DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
begin
  DSDestroyInstanceEventObject.ServerClassInstance.Free;
end;

procedure TServerContainer1.Get_Photorum_Session_ClassGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := TServerMethods_Photorum;
end;

procedure TServerContainer1.Get_TRC_Session_ClassCreateInstance(
  DSCreateInstanceEventObject: TDSCreateInstanceEventObject);
begin
  DSCreateInstanceEventObject.ServerClassInstance := TServerMethods_TRC.Create(nil);
end;

procedure TServerContainer1.Get_TRC_Session_ClassDestroyInstance(
  DSDestroyInstanceEventObject: TDSDestroyInstanceEventObject);
begin
  DSDestroyInstanceEventObject.ServerClassInstance.Free;
end;

procedure TServerContainer1.Get_TRC_Session_ClassGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := TServerMethods_TRC;
end;

procedure TServerContainer1.Update_TCPMonitor_Info;
begin
//  Main_Frm.connectionList.Items.AddObject(ConnInfoStr,pConn);

// 필요시 수정
//  FrmMain.ListBox1.Items.Add(ConnInfoStr1);
//  FrmMain.edtSessionCount.Text:=IntToStr(FConnections.Count);


end;

initialization
  FModule := TServerContainer1.Create(nil);
finalization
  FModule.Free;
end.

