//Written with Delphi XE3 Pro
//Created Oct 12, 2012 by Darian Miller
//for http://stackoverflow.com/questions/12858551/delphi-xe2-indy-10-mutlithread-ping
unit DelphiVault.Indy10.PingClient;

interface
uses
  System.SysUtils,
  System.Classes,
  Generics.Collections,
  IdIcmpClient, IdGlobal;

type
  TThreadedPing = class(TThread)
  private
    fHost:String;
  protected
    procedure Execute; override;
    procedure HandlePingResponse(const ReplyStatus:TReplyStatus);
    procedure SynchronizedResponse(const ReplyStatus:TReplyStatus); virtual; abstract;
  public
    constructor Create(const HostToPing:String);
  end;


  TPingClient = class
  private const
    defReceiveTimeout = 200;
    defPacketSize = 24; //Resolve Error 10040: See http://stackoverflow.com/questions/12723081/delphi-indy-ping-error-10040
    defProtocol = 1;
    defIPVersion = Id_IPv4;
  private type
    TSystemPingResponse = procedure(const ReplyStatus:TReplyStatus) of object;

    TCustomPingClient = class
    private
      fClientId:Word;
      fIndyClient:TIdIcmpClient;
      fCallBack:TSystemPingResponse;
    public
      constructor Create();
      destructor Destroy(); override;

      property ClientId:Word read fClientId write fClientId;
      property IndyClient:TIdIcmpClient read fIndyClient write fIndyClient;
      property CallBack:TSystemPingResponse read fCallBack write fCallBack;

      procedure DoPing();
    end;
  private class var
    _PingClientList:TDictionary<integer, TCustomPingClient>;
    _LastClientId:Word;
  private
    class procedure InternalHandleReply(Sender:TComponent; const ReplyStatus:TReplyStatus);
    class function GetAvailableClientId():Word;
  public
    class constructor ClassCreate();
    class destructor ClassDestroy();

    class procedure Ping(const HostToPing:String; const CallBack:TSystemPingResponse;
                         const ReceiveTimeout:Integer = defReceiveTimeout;
                         const PacketSize:Integer = defPacketSize;
                         const Protocol:Integer = defProtocol;
                         const IPVersion:TIdIPVersion = defIPVersion);
    class function FormatStandardResponse(const ReplyStatus:TReplyStatus):String;
  end;


implementation


class constructor TPingClient.ClassCreate();
begin
  _PingClientList := TDictionary<integer, TCustomPingClient>.Create();
end;
class destructor TPingClient.ClassDestroy();
begin
  _PingClientList.Free();
end;


constructor TPingClient.TCustomPingClient.Create();
begin
  inherited;
  fIndyClient := TIdIcmpClient.Create(nil);
end;
destructor TPingClient.TCustomPingClient.Destroy();
begin
  fIndyClient.Free();
  inherited;
end;

procedure TPingClient.TCustomPingClient.DoPing();
begin
  //Indy's core problem...

  //We will send here, but if we have recently sent some Pings, we may receive
  //a response to a previous Ping and not get a response to our particular Ping.
  IndyClient.Ping('', ClientId);
end;


class function TPingClient.GetAvailableClientId():Word;
begin
  while _LastClientId < High(Word) do
  begin
    Inc(_LastClientId);
    if not _PingClientList.ContainsKey(_LastClientId) then
    begin
      Exit(_LastClientId);
    end;
  end;

  _LastClientId := Low(Word);

  while _LastClientId < High(Word) do
  begin
    Inc(_LastClientId);
    if not _PingClientList.ContainsKey(_LastClientId) then
    begin
      Exit(_LastClientId);
    end;
  end;

  raise Exception.Create('Too many concurrent PING operations');
end;



//serialized ping calls
class procedure TPingClient.Ping(const HostToPing:String; const CallBack:TSystemPingResponse;
                                 const ReceiveTimeout:Integer = defReceiveTimeout;
                                 const PacketSize:Integer = defPacketSize;
                                 const Protocol:Integer = defProtocol;
                                 const IPVersion:TIdIPVersion = defIPVersion);
var
  Transport:TCustomPingClient;
begin
  Transport := TCustomPingClient.Create();
  Transport.IndyClient.Host := HostToPing;
  Transport.IndyClient.ReceiveTimeout := ReceiveTimeout;
  Transport.IndyClient.PacketSize := PacketSize;
  Transport.IndyClient.Protocol := Protocol;
  Transport.IndyClient.IPVersion := IPVersion;
  Transport.IndyClient.OnReply := InternalHandleReply;
  Transport.CallBack := CallBack;

  System.TMonitor.Enter(_PingClientList);
  try
    Transport.ClientId := GetAvailableClientId();
    _PingClientList.Add(Transport.ClientId, Transport);
    Transport.DoPing();
  finally
    System.TMonitor.Exit(_PingClientList);
  end;
end;


//serialized response handling
class procedure TPingClient.InternalHandleReply(Sender:TComponent; const ReplyStatus:TReplyStatus);
var
  Transport:TCustomPingClient;
  PingID:Word;
begin
  PingID := ReplyStatus.SequenceId;
  System.TMonitor.Enter(_PingClientList);
  try
    if _PingClientList.TryGetValue(PingID, Transport) then
    begin
      try
        Transport.CallBack(ReplyStatus);
        _PingClientList.Remove(PingID);
      finally
        Transport.Free();
      end;
    end;
  finally
    System.TMonitor.Exit(_PingClientList);
  end;
end;


class function TPingClient.FormatStandardResponse(const ReplyStatus:TReplyStatus):String;
begin
  if ReplyStatus.ReplyStatusType = rsEcho then
  begin
    Result := Format('%d bytes from %s: icmp_seq=%d ttl=%d time %d ms',
                     [ReplyStatus.BytesReceived,
                      ReplyStatus.FromIpAddress,
                      ReplyStatus.SequenceId,
                      ReplyStatus.TimeToLive,
                      ReplyStatus.MsRoundTripTime]);
  end
  else if Length(ReplyStatus.Msg) > 0 then
  begin
    Result := ReplyStatus.Msg;
  end
  else
  begin
    Result := 'Ping failed, error code ' + IntToStr(Ord(ReplyStatus.ReplyStatusType));
  end;
end;


constructor TThreadedPing.Create(const HostToPing:String);
begin
  inherited Create(False);
  FreeOnTerminate := True;

  fHost := HostToPing;
end;

procedure TThreadedPing.Execute;
begin
  inherited;

  TPingClient.Ping(fHost, HandlePingResponse);
  while not Terminated do
  begin
    Yield();
  end;
end;

procedure TThreadedPing.HandlePingResponse(const ReplyStatus:TReplyStatus);
begin
  Synchronize(
    procedure
    begin
      SynchronizedResponse(ReplyStatus);
    end);

  Terminate;
end;

end.
