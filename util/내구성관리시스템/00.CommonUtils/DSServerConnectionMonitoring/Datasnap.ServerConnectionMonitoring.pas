unit Datasnap.ServerConnectionMonitoring;

interface

uses System.Classes,
     System.SysUtils,
     System.Generics.Collections,
     Datasnap.DSServer,
     Datasnap.DSCommonServer,
     Datasnap.DSTCPServerTransport,
     Datasnap.DSHTTPCommon,
     Datasnap.DSService,
     Data.DBXPlatform;

type

  /// <summary>Set of the different connection protocol types.</summary>
  TDSProtocol = (pTCPIP, pHTTPtunnel, pHTTPrest);

  /// <summary>A connection, as monitored by the TDSServerConnectionMonitor component.</summary>
  TDSMonitoredConnection = class
  private
    FCreatedOn: TDateTime;
    FProtocol: TDSProtocol;
    FSessionId: String;
    FClientIP: String;
  protected
    // <summary>Accessor method for the SessionId property.</summary>
    function GetSessionId: String; virtual;
    // <summary>Accessor method for the ClientIP property.</summary>
    function GetClientIP: String; virtual;
  public
    constructor Create(AProtocol: TDSProtocol; ASessionId, AClientIP: String); overload; virtual;
    /// <summary>The protocol the connection uses (tcp/ip, tunneled http, or REST http)</summary>
    property Protocol: TDSProtocol read FProtocol;
    /// <summary>The ID (Session.SessionName) of the session associated with the connection.</summary>
    property SessionId: String read GetSessionId;
    /// <summary>The IP address of the client for the connection, or 'localhost' if local.</summary>
    property ClientIP: String read GetClientIP;
    /// <summary>Specifies the date and time the connection was created.</summary>
    property CreatedOn: TDateTime read FCreatedOn;
    /// <summary>Closes the connection.</summary>
    /// <remarks>A connection could be a session (for HTTP connections) or a TCP connection.
    ///          Note that this will result in this connection instance being freed.
    /// </remarks>
    procedure Close; virtual;
  end;

  /// <summary>Event item abstract class, for both OnConnect and OnDisconnect items.</summary>
  TDSConnectionMonitorEvent = class abstract
  private
    FConnection: TDSMonitoredConnection;
  public
    constructor Create(AConnection: TDSMonitoredConnection); overload; virtual;
    /// <summary>The connection, containing information such as session, client IP and protocol.</summary>
    property Connection: TDSMonitoredConnection read FConnection;
  end;

  /// <summary>Event item provided to OnConnect event of the connection monitor component.</summary>
  /// <remarks>If the protocol is pTCPIP, the instance will be a subclass of this class,
  ///          specificially: TDSTCPConnectionEvent
  /// </remarks>
  TDSConnectionEvent = class(TDSConnectionMonitorEvent)
  end;

  /// <summary>Subclass for TDSConnectionEvent item, specific for TCP connections.</summary>
  /// <remarks>With an instance of TDSConnectionEvent, if the protocol is pTCPIP you can
  ///          assume it is an instance of this class (TDSTCPConnectionEvent) and do the cast.
  /// </remarks>
  TDSTCPConnectionEvent = class(TDSConnectionEvent)
  private
    FTCPEvent: TDSTCPConnectEventObject;
  public
    constructor Create(AConnection: TDSMonitoredConnection;
                       ATCPEvent: TDSTCPConnectEventObject); overload;
    /// <summary>The TCP specific connection event, containing the connection and tcp channel.</summary>
    property TCPEvent: TDSTCPConnectEventObject read FTCPEvent;
  end;

  /// <summary>Event item provided to OnDisconnect event of the connection monitor component.</summary>
  /// <remarks>If the protocol is pTCPIP, the instance will be a subclass of this class,
  ///          specificially: TDSTCPDisconnectionEvent
  /// </remarks>
  TDSDisconnectionEvent = class(TDSConnectionMonitorEvent)
  end;

  /// <summary>Subclass for TDSDisconnectionEvent item, specific for TCP connections.</summary>
  /// <remarks>With an instance of TDSDisconnectionEvent, if the protocol is pTCPIP you can
  ///          assume it is an instance of this class (TDSTCPDisconnectionEvent) and do the cast.
  /// </remarks>
  TDSTCPDisconnectionEvent = class(TDSDisconnectionEvent)
  private
    FTCPEvent: TDSTCPDisconnectEventObject;
  public
    constructor Create(AConnection: TDSMonitoredConnection;
                       ATCPEvent: TDSTCPDisconnectEventObject); overload;
    /// <summary>The TCP specific disconnect event, containing the connection.</summary>
    property TCPEvent: TDSTCPDisconnectEventObject read FTCPEvent;
  end;

  /// <summary>A TCP connection, as monitored by the TDSServerConnectionMonitor component.</summary>
  TDSMonitoredTCPConnection = class(TDSMonitoredConnection)
  private
    FConnection: TObject;
    FChannel: TDSTCPChannel;
  protected
    /// <summary>Override of base implementation, which pulls the value from the TDSTCPChannel instance.
    /// </summary>
    function GetSessionId: String; override;
  public
    constructor Create(ASessionId, AClientIP: String;
                       AConnection: TObject; AChannel: TDSTCPChannel);

    /// <summary>Closes the TCP Connection.</summary>
    /// <remarks>Same as calling Channel.Close.
    ///          Note that this will result in this connection instance being freed.
    /// </remarks>
    procedure Close; override;
    /// <summary>The TCP connection instance.</summary>
    /// <remarks>This is taken from the TCP transport OnConnect event.</remarks>
    property Connection: TObject read FConnection;
    /// <summary>The TCP channel instance.</summary>
    /// <remarks>This is taken from the TCP transport OnConnect event.</remarks>
    property Channel: TDSTCPChannel read FChannel;
  end;

  /// <summary>Event item for HTTP trace events.</summary>
  TDSHTTPTraceEvent = class
  private
    FContext: TDSHTTPContext;
    FRequest: TDSHTTPRequest;
    FResponse: TDSHTTPResponse;
    FConnection: TDSMonitoredConnection;
  public
    constructor Create(AContext: TDSHTTPContext; ARequest: TDSHTTPRequest;
                       AResponse: TDSHTTPResponse; AConnection: TDSMonitoredConnection); virtual;
    /// <summary>The context of the original trace event.</summary>
    property Context: TDSHTTPContext read FContext;
    /// <summary>The HTTP request issued by the client.</summary>
    property Request: TDSHTTPRequest read FRequest;
    /// <summary>The HTTP response being returned by the server.</summary>
    property Response: TDSHTTPResponse read FResponse;
    /// <summary>The connection linked to this request's session.</summary>
    property Connection: TDSMonitoredConnection read FConnection;
  end;

  ///<summary>Event for connections being established.</summary>
  TDSConnectionEventProc = procedure(Event: TDSConnectionEvent) of object;

  ///<summary>Event for connections being closed.</summary>
  TDSDisconnectionEventProc = procedure(Event: TDSDisconnectionEvent) of object;

  ///<summary>Handler used to handle a specific connection. Can be used in iteration.</summary>
  TDSConnectionHandler = reference to procedure(Connection: TDSMonitoredConnection; var Stop: boolean);

  ///<summary>Event for HTTP request/response tracing.</summary>
  TDSHTTPTraceEventProc = procedure(Event: TDSHTTPTraceEvent) of object;

  /// <summary>Hooks to a TDSServer instance and monitors connections.</summary>
  TDSServerConnectionMonitor = class(TDSServerComponent)
  private
    FStarted: boolean;
    FOnConnect: TDSConnectionEventProc;
    FOnDisconnect: TDSDisconnectionEventProc;
    FInitialized: boolean;
    FOnHTTPTrace: TDSHTTPTraceEventProc;

    //list of all cached connections
    FConnections: TList<TDSMonitoredConnection>;
    //map of the tcp connections and their corresponding connection objects
    FTCPConnMap: TObjectDictionary<TObject,TDSMonitoredTCPConnection>;

    FSessionEvent: TDSSessionEvent;

    function GetStarted: boolean;

    procedure Initialize;
    procedure UnInitialize;
    procedure SetOnConnect(Event: TDSConnectionEventProc);
    procedure SetOnDisconnect(Event: TDSDisconnectionEventProc);

    procedure TCPTransportOnConnect(Event: TDSTCPConnectEventObject);
    procedure TCPTransportOnDisconnect(Event: TDSTCPDisconnectEventObject);
    procedure HTTPOnTrace(Sender: TObject; AContext: TDSHTTPContext;
                          ARequest: TDSHTTPRequest; AResponse: TDSHTTPResponse);
    procedure SessionEvent(Sender: TObject;
                           const EventType: TDSSessionEventType;
                           const Session: TDSSession);
    function GetConnectionCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// <summary>Clears the cached connections.</summary>
    procedure ReleaseCachedConnections;
    /// <summary>Starts the monitor, enabling the OnConnect and OnDisconnect events.</summary>
    procedure Start; override;
    /// <summary>Stops the monitor, disabling the OnConnect and OnDisconnect events.</summary>
    procedure Stop; override;
    /// <summary>Iterates over all connections, calling into the provided handler for each.</summary>
    /// <remarks>Do not stop a connection while iterating using this procedure.</remarks>
    procedure ForEachConnection(const ConnIterator: TDSConnectionHandler);
    /// <summary>Returns the connection for the specified session Id, or nil if not found.</summary>
    function GetConnectionForSession(const SessionId: String): TDSMonitoredConnection;
    ///<summary>True if this monitor will report on connect and disconnect events.</summary>
    property Started: boolean read GetStarted;
    /// <summary>Returns the number of current connections.</summary>
    /// <remarks>This will return the count of all connections: http tunnel, http rest and tcp/ip</remarks>
    property ConnectionCount: Integer read GetConnectionCount;
  published
    ///<summary>The TDSServer component this monitor connects to.</summary>
    property Server;
    /// <summary>Event notified of connections to the server.</summary>
    /// <remarks>For TCP connections, the SessionId may be empty string to start. If you cast the event
    ///          to an instance of TDSTCPConnectionEvent, then you can get the TCPEvent instance, and store
    ///          the channel from it. Later (after the first read or write,) this channel will hold the
    ///          valid session Id.
    /// </remarks>
    property OnConnect: TDSConnectionEventProc read FOnConnect write SetOnConnect;
    ///<summary>Event notified of disconnections from the server.</summary>
    property OnDisconnect: TDSDisconnectionEventProc read FOnDisconnect write SetOnDisconnect;
    /// <summary>Event notified of each issued http request and the server's response.</summary>
    /// <remarks>If the event's Connection is nil, no session information for the connection
    ///          could be obtained. This could be because a file delivery request
    ///         (which has no specified session) was issued.
    /// </remarks>
    property OnHTTPTrace: TDSHTTPTraceEventProc read FOnHTTPTrace write FOnHTTPTrace;
  end;

implementation

uses Datasnap.DSHTTP, Data.DBXClientResStrs, Datasnap.DSHTTPWebBroker;

type
  /// <summary>Hack class used to gain access to private data within TDSCustomServer instance.</summary>
  TDSCustomServerHack = class helper for TDSCustomServer
  public
    procedure GetComponentList(const List: TDBXArrayList);
  end;

{ TDSCustomServerHack }

procedure TDSCustomServerHack.GetComponentList(const List: TDBXArrayList);
var
  Index, Count: Integer;
  ServerComponent: TObject;
begin
  if (Self.FComponentList <> nil) and (List <> nil) then
  begin
    Count := Self.FComponentList.Count - 1;
    for Index := 0 to Count do
    begin
      ServerComponent := Self.FComponentList[Index];
      List.Add(ServerComponent);
    end;
  end;
end;

{ TDSTCPConnectionEvent }

constructor TDSTCPConnectionEvent.Create(AConnection: TDSMonitoredConnection;
                                         ATCPEvent: TDSTCPConnectEventObject);
begin
  inherited Create(AConnection);
  FTCPEvent := ATCPEvent;
end;

{ TDSTCPDisconnectionEvent }

constructor TDSTCPDisconnectionEvent.Create(AConnection: TDSMonitoredConnection;
                                            ATCPEvent: TDSTCPDisconnectEventObject);
begin
  inherited Create(AConnection);
  FTCPEvent := ATCPEvent;
end;

{ TDSConnectionMonitorEvent }

constructor TDSConnectionMonitorEvent.Create(AConnection: TDSMonitoredConnection);
begin
  FConnection := AConnection;
end;

{ TDSMonitoredConnection }

procedure TDSMonitoredConnection.Close;
begin
  //closing an HTTP connection, by closing the session.
  if SessionId <> EmptyStr then
    TDSSessionManager.Instance.CloseSession(SessionId);
end;

constructor TDSMonitoredConnection.Create(AProtocol: TDSProtocol; ASessionId, AClientIP: String);
begin
  FCreatedOn := Now;
  FProtocol := AProtocol;
  FSessionId := ASessionId;
  FClientIP := AClientIP;
end;

function TDSMonitoredConnection.GetClientIP: String;
var
  LSession: TDSSession;
begin
  //if FClientIP isn't set (wasn't in session data for OnConnect event) this tries to set it
  if (FClientIP = EmptyStr) and (SessionId <> EmptyStr) then
  begin
    LSession := TDSSessionManager.Instance.Session[SessionId];
    if Assigned(LSession) then
    begin
      FClientIP := LSession.GetData('RemoteIP');
    end;
  end;
  if FClientIp = '0:0:0:0:0:0:0:1' then
    FClientIp := '127.0.0.1';
  Result := FClientIP;
end;

function TDSMonitoredConnection.GetSessionId: String;
begin
  Result := FSessionId;
end;

{ TDSMonitoredTCPConnection }

procedure TDSMonitoredTCPConnection.Close;
begin
  //closing a TCP connection by closing the channel.
  if Assigned(Channel) then
    Channel.Close;
end;

constructor TDSMonitoredTCPConnection.Create(ASessionId, AClientIP: String;
  AConnection: TObject; AChannel: TDSTCPChannel);
begin
  inherited Create(pTCPIP, ASessionId, AClientIP);
  FConnection := AConnection;
  FChannel := AChannel;
end;

function TDSMonitoredTCPConnection.GetSessionId: String;
begin
  Result := FSessionId;
  if Assigned(FChannel) then
    Result := FChannel.SessionId;
end;

{ TDSHTTPTraceEvent }

constructor TDSHTTPTraceEvent.Create(AContext: TDSHTTPContext; ARequest: TDSHTTPRequest;
                                     AResponse: TDSHTTPResponse; AConnection: TDSMonitoredConnection);
begin
  FContext := AContext;
  FRequest := ARequest;
  FResponse := AResponse;
  FConnection := AConnection;
end;

{ TDSServerConnectionMonitor }

constructor TDSServerConnectionMonitor.Create(AOwner: TComponent);
begin
  inherited;

  FConnections := TList<TDSMonitoredConnection>.Create;
  FTCPConnMap := TObjectDictionary<TObject,TDSMonitoredTCPConnection>.Create;
  FSessionEvent := SessionEvent;
  FStarted := false;
  FInitialized := false;
  FOnConnect := nil;
  FOnDisconnect := nil;
  FOnHTTPTrace := nil;
end;

destructor TDSServerConnectionMonitor.Destroy;
begin
  //free the connection instances
  ReleaseCachedConnections;

  FreeAndNil(FTCPConnMap);
  FreeAndNil(FConnections);
  inherited;
end;

procedure TDSServerConnectionMonitor.ForEachConnection(const ConnIterator: TDSConnectionHandler);
var
  LCurrent: TDSMonitoredConnection;
  LStop: boolean;
begin
  if not Assigned(ConnIterator) then
    Exit;

  TMonitor.Enter(FConnections);
  try
    LStop := false;
    //iterate over each connection, only stopping if the iterator says so
    for LCurrent In FConnections do
    begin
      ConnIterator(LCurrent, LStop);
      if LStop then
        Break;
    end;
  finally
    TMonitor.Exit(FConnections);
  end;
end;

procedure TDSServerConnectionMonitor.SetOnConnect(Event: TDSConnectionEventProc);
begin
  UnInitialize;
  FOnConnect := Event;

  if Started then
    Initialize;
end;

procedure TDSServerConnectionMonitor.SetOnDisconnect(Event: TDSDisconnectionEventProc);
begin
  UnInitialize;
  FOnDisconnect := Event;

  if Started then
    Initialize;
end;

procedure TDSServerConnectionMonitor.Start;
begin
  if Assigned(Server) then
  begin
    ReleaseCachedConnections;
    //set started to true before calling initialize, or initialize won't be run
    FStarted := True;
    Initialize;
  end;
end;

procedure TDSServerConnectionMonitor.Stop;
begin
  UnInitialize;
end;

function TDSServerConnectionMonitor.GetConnectionCount: Integer;
begin
  TMonitor.Enter(FConnections);
  try
    Result := FConnections.Count;
  finally
    TMonitor.Exit(FConnections);
  end;
end;

function TDSServerConnectionMonitor.GetConnectionForSession(const SessionId: String): TDSMonitoredConnection;
var
  LConn: TDSMonitoredConnection;
begin
  LConn := nil;

  if SessionId = EmptyStr then
    Exit(nil);

  //iterate over each connection, looking for a connection with the specified SessionId
  ForEachConnection(
     procedure(Conn: TDSMonitoredConnection; var Stop: boolean)
     begin
       //found the session Id, so set the result connection, and cancel the 'ForEach' iteration
       if Conn.SessionId = SessionId then
       begin
         Stop := True;
         LConn := Conn;
       end;
     end);

  Result := LConn;
end;

function TDSServerConnectionMonitor.GetStarted: boolean;
begin
  //only in a started state if true, and a server has been assigned
  Result := FStarted and Assigned(Server);
end;

procedure TDSServerConnectionMonitor.Initialize;
var
  LCompList: TDBXArrayList;
  I, Count: Integer;
  LItem: TObject;
begin
  //only initialize once (or if events change) and only if the component is started already.
  if FInitialized or (not Started) then
    Exit;

  FInitialized := True;

  //add a session event. For HTTP connection, a session represents a connection
  //the session event kees track of sessions being created and closed.
  TDSSessionManager.Instance.AddSessionEvent(FSessionEvent);

  LCompList := TDBXArrayList.Create;
  Server.GetComponentList(LCompList);

  Count := LCompList.Count;

  //iterate over all the components attached to the server, and hook into specific events of specific components
  //Specifically OnConnect and OnDisconnect for TCP Transport, and Trace for HTTP services.
  try
    for I := 0 to Count - 1 do
    begin
      LItem := LCompList[I];

      //Handle TCP transport protocol component
      if LItem Is TDSTCPServerTransport then
      begin
        //set reference procedures into OnConnect and OnDisconnect events of component
        TDSTCPServerTransport(LItem).OnConnect := TCPTransportOnConnect;
        TDSTCPServerTransport(LItem).OnDisconnect := TCPTransportOnDisconnect;
      end
      //Indy HTTP service
      else if LItem Is TDSHTTPService then
        TDSHTTPService(LItem).Trace := HTTPOnTrace
      //WebBroker HTTP service
      else if LItem Is TDSHTTPWebDispatcher then
        TDSHTTPWebDispatcher(LItem).Trace := HTTPOnTrace;
    end;
  finally
    FreeAndNil(LCompList);
  end;
end;

procedure TDSServerConnectionMonitor.UnInitialize;
begin
  FStarted := False;
  FInitialized := False;
  TDSSessionManager.Instance.RemoveSessionEvent(FSessionEvent);
  ReleaseCachedConnections;
end;

procedure TDSServerConnectionMonitor.ReleaseCachedConnections;
var
  LConn: TDSMonitoredConnection;
begin
  if FTCPConnMap <> nil then
    FTCPConnMap.Clear;

  if FConnections <> nil then
  begin
    for LConn In FConnections do
      LConn.Free;
    FConnections.Clear;
  end;
end;

procedure TDSServerConnectionMonitor.TCPTransportOnConnect(Event: TDSTCPConnectEventObject);
var
  LEvent: TDSTCPConnectionEvent;
  LCientIP, LSessionId: String;
  LConn: TDSMonitoredTCPConnection;
begin
  LConn := nil;

  LCientIP := Event.Channel.ChannelInfo.ClientInfo.IpAddress;
  LSessionId := Event.Channel.SessionId; //This will probably be empty string to start

  TMonitor.Enter(FConnections);
  try
    //cache the connection, for iterating over later
    if Assigned(Event.Connection) then
    begin
      LConn := TDSMonitoredTCPConnection.Create(LSessionId, LCientIP, Event.Connection, Event.Channel);
      FTCPConnMap.Add(Event.Connection, LConn);
      FConnections.Add(LConn);
    end;
  finally
    TMonitor.Exit(FConnections);
  end;

  //don't create event item or invoke event if one hasn't been assigned
  if (not Started) or (not Assigned(OnConnect)) then
    Exit;

  LEvent := TDSTCPConnectionEvent.Create(LConn, Event);

  try
    try
      OnConnect(LEvent);
    except
    end;
  finally
    FreeAndNil(LEvent);
  end;
end;

procedure TDSServerConnectionMonitor.TCPTransportOnDisconnect(Event: TDSTCPDisconnectEventObject);
var
  LEvent: TDSTCPDisconnectionEvent;
  LClientIP, LSessionId: String;
  LConn: TDSMonitoredTCPConnection;
begin
  LConn := nil;

  LClientIP := EmptyStr;
  LSessionId := EmptyStr;

  TMonitor.Enter(FConnections);
  try
    //get the values from the stored connection, and then remove the stored connection
    if FTCPConnMap.TryGetValue(Event.Connection, LConn) then
    begin
      LClientIP := LConn.ClientIP;
      LSessionId := LConn.SessionId;
      FTCPConnMap.Remove(Event.Connection);
      FConnections.Remove(LConn);
    end;
  finally
    TMonitor.Exit(FConnections);
  end;

  //don't create event item or invoke event if one hasn't been assigned
  if (not Started) or (not Assigned(OnDisconnect)) then
    Exit;

  LEvent := TDSTCPDisconnectionEvent.Create(LConn, Event);

  try
    try
      OnDisconnect(LEvent);
    except
    end;
  finally
    FreeAndNil(LEvent);
    FreeAndNil(LConn);
  end;
end;

procedure TDSServerConnectionMonitor.HTTPOnTrace(Sender: TObject; AContext: TDSHTTPContext;
                                                 ARequest: TDSHTTPRequest; AResponse: TDSHTTPResponse);
var
  LTraceEvent: TDSHTTPTraceEvent;
  LSessionId: String;
  LConn: TDSMonitoredConnection;
  LPragmaStrs: TStringList;
begin
  if not Assigned(FOnHTTPTrace) then
    Exit;

  LSessionId := EmptyStr;

  //try to load the SessionId from the HTTP Response (Pragma header)
  LPragmaStrs := TStringList.Create;
  try
    LPragmaStrs.CommaText := AResponse.Pragma;
    LSessionId := LPragmaStrs.Values['dssession'];
  finally
    FreeAndNil(LPragmaStrs);
  end;

  //try to load the session ID from the Request's PARAMS
  if LSessionId = EmptyStr then
  begin
    LSessionId := ARequest.Params.Values['dss'];
  end;

  //finds the current session, and then gets the connection object for that session
  if LSessionId <> EmptyStr then
  begin
    LConn := GetConnectionForSession(LSessionId);
  end
  else
    LConn := nil;

  try
    try
      LTraceEvent := TDSHTTPTraceEvent.Create(AContext, ARequest, AResponse, LConn);

      FOnHTTPTrace(LTraceEvent);
    except
    end;
  finally
    FreeAndNil(LTraceEvent);
  end;
end;

procedure TDSServerConnectionMonitor.SessionEvent(Sender: TObject;
                                                  const EventType: TDSSessionEventType;
                                                  const Session: TDSSession);
var
  LClientIP: String;
  LIsTCP: boolean;
  LProtocol: TDSProtocol;
  LConn: TDSMonitoredConnection;
  LConnEvent: TDSConnectionEvent;
  LDisEvent: TDSDisconnectionEvent;
begin
  if not Assigned(Session) then
    Exit;

  LClientIP := EmptyStr;
  LIsTCP := (Session Is TDSTCPSession) or AnsiSameText(Session.GetData('CommunicationProtocol'), 'tcp/ip');

  //do not continue if the communication protocol is tcp/ip,
  //as that has its own OnConnect and OnDisconnect
  if LIsTCP then
    Exit;

  if Session.HasData('RemoteIP') then
    LClientIP := Session.GetData('RemoteIP');

  //determine if this is a REST HTTP connection or an HTTP TUNNEL
  if (Session Is TDSTunnelSession) or AnsiSameText(Session.GetData('ProtocolSubType'), 'tunnel') then
    LProtocol := pHTTPtunnel
  else
    LProtocol := pHTTPrest;

  //handle session opening, which will fire an OnConnect event
  if EventType = SessionCreate then
  begin
    TMonitor.Enter(FConnections);
    try
      LConn := TDSMonitoredConnection.Create(LProtocol, Session.SessionName, LClientIp);
      FConnections.Add(LConn);
      if Assigned(OnConnect) then
      begin
        LConnEvent := TDSConnectionEvent.Create(LConn);
        try
          try
            OnConnect(LConnEvent);
          except
          end;
        finally
          FreeAndNil(LConnEvent);
        end;
      end;
    finally
      TMonitor.Exit(FConnections);
    end;
  end
  //handle session closing, which will fire an OnDisconnect event
  else if EventType = SessionClose then
  begin
    LConn := GetConnectionForSession(Session.SessionName);
    TMonitor.Enter(FConnections);
    try
      if LConn <> nil then
      begin
        FConnections.Remove(LConn);
        try
        TMonitor.Enter(LConn);
        if Assigned(OnDisconnect) then
        begin
          LDisEvent := TDSDisconnectionEvent.Create(LConn);
          try
            try
              OnDisconnect(LDisEvent);
            except
            end;
          finally
            FreeAndNil(LDisEvent);
          end;
        end;
        finally
          FreeAndNil(LConn);
        end;
      end;
    finally
      TMonitor.Exit(FConnections);
    end;
  end;
end;

end.
