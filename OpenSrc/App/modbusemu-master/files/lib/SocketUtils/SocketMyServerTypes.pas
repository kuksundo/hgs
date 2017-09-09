unit SocketMyServerTypes;

{$mode objfpc}

interface

uses
  Classes, SysUtils, syncobjs,
  Sockets,
  SocketSimpleTypes,
  LoggerItf
  {$IFDEF UNIX}
  ,BaseUnix
  {$ELSE}
  ,winsock
  {$ENDIF};

type

  TServerClientObj = class;
  TBaseServerSocket = class;

  TOnClientConnect     = procedure(Sender : TBaseServerSocket; aClient : TServerClientObj) of object;
  TOnClientDisconnect  = TOnClientConnect;
  TOnClientReceiveInfo = TOnClientConnect;
  TOnClientReceiveData = procedure(Sender : TServerClientObj; Buff : array of Byte; DataSize : Cardinal; QuantityDataCame : Cardinal) of object;
  TServerClientConnect = function(aSocket : TSocket; aClentAddr : TInetSockAddr): TServerClientObj of object;
  TServerSetErrorProc  = procedure(aError : Cardinal) of object;
  TClientSetErrorProc  = procedure(aClient : TServerClientObj; aError : Cardinal) of object;

  {
  TServerClientThread
  класс потока мониторинга состояния клиентского сокета
  }

  TServerClientThread = class(TThreadLogged)
  private
   FClientObject       : TServerClientObj;
   FCSection           : TCriticalSection;
   FSetLastError       : TClientSetErrorProc;
   FOnClientDisconnect : TNotifyEvent;
  protected
   procedure Execute; override;
  public
   constructor Create(aClientObject : TServerClientObj;
                      aCSection : TCriticalSection;
                      aSetLastError : TClientSetErrorProc;
                      aOnClientDisconnect : TNotifyEvent); virtual;
  end;

  {
  TServerClientObj
  класс реализует объект клиентского соединения
  }

  TServerClientObj = class(TObjectLogged)
  private
   FActive                  : Boolean;                // активно или нет соединение
   FOwner                   : TBaseServerSocket;      // ссылка на объект серверного сокета
   FClientThread            : TServerClientThread;    // поток отслеживания событий сокета
   FClientSocket            : TSocket;                // дескриптор сокета
   FClientAddr              : TInetSockAddr;          // адрес клиента
   FCSection                : TCriticalSection;       // критическая секция серверного сокета
   FOnClientDisconnect      : TOnClientDisconnect;    // обработчик события закрытия сокета со стороны клиента
   FOnClientClose           : TOnClientDisconnect;    // обработчик события закрытия сокета со стороны сервера
   FOnlyInformOfComingData  : Boolean;
   FOnClientReceiveData     : TOnClientReceiveData;
   FOnClientReceiveInfo     : TOnClientReceiveInfo;
   FSelectTimeOut           : Cardinal;
   FSetLastError            : TClientSetErrorProc;    // обработчик ошибок серверного сокета
   FSizeOfReceiveDataBuffer : Cardinal;               // размер буфера при автоматическом преме данных
   FSockBuffSize            : Word;                   // размер входных/выходных буферов сокета
   FLastError               : Cardinal;
   function  GetClientAddr: String;
   function  GetClientAddrNum: Cardinal;
   function  GetClientPort: Word;
   procedure SetSockBuffSize(AValue: Word);
   function  GetTimeVal : timeval;
   procedure SetLastError(AError : Cardinal);

   procedure OnClientDisconnectProc(Sender : TObject);
  public
   constructor Create(aOwner : TBaseServerSocket;
                      aSocket : TSocket;
                      aClentAddr : TInetSockAddr;
                      aCSection : TCriticalSection;
                      aOnClientDisconnect : TOnClientDisconnect;
                      aSetErrorProc : TClientSetErrorProc); virtual;

   destructor  Destroy; override;

   // запускает поток отслеживания поступления данных
   procedure Start;
   // останавливает поток отслеживания поступления данных
   procedure Stop;
   // закрывает соединение
   procedure Close;
   // получить количество пришедших данных
   function GetQuantityDataCame : Integer;
   // прочитать пришедшие данные
   function ReceiveData(var Buff; aSize : Cardinal) : Integer;
   // отправить данные клиенту
   function SendDada(var Buff; aSize : Cardinal) : Integer;
   // ожидание прихода данных от клиента
   function WaitReceiveData: TWaitResult; virtual;

   property Owner                   : TBaseServerSocket read FOwner;
   property LastError               : Cardinal read FLastError;
   // таймаут ожидания прихода данных от клиента
   property SelectTimeOut           : Cardinal read FSelectTimeOut write FSelectTimeOut;
   // максимальный размер буфера при приеме данных
   property SizeOfReceiveDataBuffer : Cardinal read FSizeOfReceiveDataBuffer write FSizeOfReceiveDataBuffer;
   // размер входных/выходных буферов сокета
   property SocketBuffSize          : Word read FSockBuffSize write SetSockBuffSize;
   // дескриптор сокета
   property ClientSocket            : TSocket read FClientSocket;
   // адрес клиента в строковом представлении
   property ClientAddr              : String read GetClientAddr;
   // адрес клиента в числовом представлении(порядок байт - хостовый)
   property ClientAddrNum           : Cardinal read GetClientAddrNum;
   // порт клиента (порядок байт - хостовый)
   property ClientPort              : Word read GetClientPort;
   // только извещать о приходе данных но не читать их из сокета
   property OnlyInformOfComingData  : Boolean read FOnlyInformOfComingData write FOnlyInformOfComingData;

   // ссылка на процедуру обработчика ошибок
//   property SetErrorProc            : TClientSetErrorProc read FSetLastError write FSetLastError;

   // обработчик события закрытия сокета со стороны клиента
//   property OnClientDisconnect      : TOnClientDisconnect read FOnClientDisconnect write FOnClientDisconnect;

   // обработчик события закрытия сокета со стороны сервера(к моменту вызова сокет закрыт)
   property OnClientClose           : TOnClientDisconnect read FOnClientClose write FOnClientClose;
   // обработчик прихода данных на сокет от клиента. в обработчик передаются пришедшие данные
   property OnClientReceiveData     : TOnClientReceiveData read FOnClientReceiveData write FOnClientReceiveData;
   // только оповещение о приходе данных
   property OnClientReceiveInfo     : TOnClientReceiveInfo read FOnClientReceiveInfo write FOnClientReceiveInfo;
  end;

  {
   TServerAcceptThread
   поток выполнения операции accept серверного сокета
  }
  TServerAcceptThread = class(TThreadLogged)
  private
    FOwner             : TBaseServerSocket;
    FSetLastError      : TServerSetErrorProc;
    FSocket            : TSocket;
    FClientConnectProc : TServerClientConnect;
    FCSection          : TCriticalSection;
  protected
   procedure Execute; override;
  public
   constructor Create(aOwner : TBaseServerSocket;
                      aServerSocket : TSocket;
                      aConnectProc : TServerClientConnect;
                      aCSection : TCriticalSection;
                      aSetErrorProc : TServerSetErrorProc); virtual;
  end;

  {
    TServerKillDisconnectedClientThread
    Класс потока занимающийся удалением отключившихся клиентов
  }

  TServerKillDisconnectedClientThread = class(TThreadLogged)
  private
   FOwner               : TBaseServerSocket;
   FCSection            : TCriticalSection;
   FQueueRemovedClients : TList;
  protected
   procedure Execute; override;
  public
   constructor Create(aOwner : TBaseServerSocket); virtual;
   destructor  Destroy; override;
   procedure AddDisconnectedClient(aClientObject : TServerClientObj);
  end;

  {
  TBaseServerSocket
  класс реализующий серверный сокет
  }

  TBaseServerSocket = class(TObjectLogged)
  private
   FAcceptTheradSleepTime   : Word;
   FClientCreateStopped     : Boolean;
   FKillTheradWaitTime      : Word;
   FMaxConnNumber           : Word;
   FOnlyInformOfComingData  : Boolean;
   FSelectTimeOut           : Cardinal;
   FSizeOfReceiveDataBuffer : Cardinal;
   FSockBuffSize            : Word;
   FSocket                  : TSocket;
   FAddr                    : TInetSockAddr;
   FAcceptThread            : TServerAcceptThread;
   FKillThread              : TServerKillDisconnectedClientThread;
   FClientList              : TList;
   FClosing                 : Boolean;
   FCSection                : TCriticalSection;
   FListenQueueSize         : Cardinal;

   FLastError               : Cardinal;
   FLastErrorDescr          : String;
   FOnError                 : TNotifyEvent;
   FOnClientError           : TNotifyEvent;

   FOnClientReceiveData     : TOnClientReceiveData;
   FOnClientReceiveInfo     : TOnClientReceiveInfo;
   FOnClientConnect         : TOnClientConnect;
   FOnClientClose           : TOnClientDisconnect;
   FOnClientDisconnect      : TOnClientDisconnect;
   FOnClose                 : TNotifyEvent;
   FOnOpen                  : TNotifyEvent;

   function  ClientConnectProc(aSocket : TSocket; aClentAddr : TInetSockAddr): TServerClientObj;
   procedure ClientDisconnectProc(Sender : TBaseServerSocket; aClient : TServerClientObj);

   function  GetActive: Boolean;
   procedure SetAcceptTheradSleepTime(AValue : Word);
   procedure SetActive(AValue: Boolean);
   function  GetBindAddress: String;
   procedure SetBindAddress(AValue: String);
   function  GetClientCount: Integer;
   function  GetClients(Index : integer): TServerClientObj;
   function  GetPort: Word;
   procedure SetKillTheradWaitTime(AValue : Word);
   procedure SetMaxConnNumber(AValue : Word);
   procedure SetOnClientClose(AValue: TOnClientDisconnect);
   procedure SetOnClientDisconnect(AValue: TOnClientDisconnect);
   procedure SetOnClientReceiveData(AValue: TOnClientReceiveData);
   procedure SetOnClientReceiveInfo(AValue: TOnClientReceiveInfo);
   procedure SetOnlyInformOfComingData(AValue: Boolean);
   procedure SetPort(AValue: Word);
   procedure SetSelectTimeOut(AValue: Cardinal);
   procedure SetSizeOfReceiveDataBuffer(AValue: Cardinal);
   procedure SetSockBuffSize(AValue: Word);

  protected
   property Socket : TSocket read FSocket;
   property Addr   : TInetSockAddr read FAddr;

   procedure SetLogger(const Value: IDLogger); override;
   procedure CloseAllClientSockets;
   procedure SetLastError(ALastError : Cardinal);
   procedure SetClientLastError(aClient : TServerClientObj; aError : Cardinal);

   procedure Lock;
   procedure Unlock;
  public
   constructor Create; virtual;
   destructor  Destroy; override;

   // открытие серверного сокета
   procedure Open;
   // закрытие серверного сокета
   procedure Close;

   // удаление клиента. при удалении происходит закрытие соединения
   procedure RemoveClient(var aClient : TServerClientObj);

   // акдивизация/деактивизация серверного сокета
   property Active             : Boolean read GetActive write SetActive;

   property LastError          : Cardinal read FLastError;
   property LastErrorDescr     : String read FLastErrorDescr;

   // количество подключенных клиентов
   property ClientCount        : Integer read GetClientCount;
   // список объетов клиентских соединений
   property Clients[Index : integer] : TServerClientObj read GetClients;

  published
   // порт серверного сокета
   property Port                    : Word read GetPort write SetPort default 30000;
   // размер очереди входящих соединений
   property ListenQueueSize         : Cardinal read FListenQueueSize write FListenQueueSize default 100;
   // адрес для связывания серверного сокета
   property BindAddress             : String read GetBindAddress write SetBindAddress;

   // размер входных/выходных буферов клиентского сокета
   property SocketBuffSize          : Word read FSockBuffSize write SetSockBuffSize default 4096;
   // максимальный размер буфера при приеме данных от клиента
   property SizeOfReceiveDataBuffer : Cardinal read FSizeOfReceiveDataBuffer write SetSizeOfReceiveDataBuffer default 1500;
   // запускать мониторинг прихода данных в клиентский сокет сразу после создания или нет
   property ClientCreateStopped     : Boolean read FClientCreateStopped write FClientCreateStopped default False;
   // таймаут ожидания прихода данных от клиента
   property ClientSelectTimeOut     : Cardinal read FSelectTimeOut write SetSelectTimeOut default 1000;
   // передавать полученные данные в оповещении(OnClientReceiveData) или нет(OnClientReceiveInfo)
   property OnlyInformOfComingData  : Boolean read FOnlyInformOfComingData write SetOnlyInformOfComingData default False;
   // максимальное число одновременных соединений для данного сокета. после достижения данного количества соединений сервер начинает закрывать входящие соединения сразу после accept
   property MaxNumberSimultaneousConnections : Word read FMaxConnNumber write SetMaxConnNumber default MAX_NUM_PARALLEL_CON;

   // время "сна" потока для снижения нагрузки на процессор
   property AcceptTheradSleepTime   : Word read FAcceptTheradSleepTime write SetAcceptTheradSleepTime default 100;
   // интевал времени между опросами очереди удаляемых соединений
   property KillTheradWaitTime      : Word read FKillTheradWaitTime write SetKillTheradWaitTime default 20;

   // обработчик события открытия серверного сокета
   property OnOpen                  : TNotifyEvent read FOnOpen write FOnOpen;
   // обработчик события закрытия серверного сокета
   property OnClose                 : TNotifyEvent read FOnClose write FOnClose;
   // обработчик события подключения клиента
   property OnClientConnect         : TOnClientConnect read FOnClientConnect write FOnClientConnect;
   // обработчик события отключения клиента со стороны клиента
   property OnClientDisconnect      : TOnClientDisconnect read FOnClientDisconnect write SetOnClientDisconnect;
   // обработчик события закрытия клиента со стороны сервера
   property OnClientClose           : TOnClientDisconnect read FOnClientClose write SetOnClientClose;
   // обработчик события прихода данных от клиента(передача полученных данных)
   property OnClientReceiveData     : TOnClientReceiveData read FOnClientReceiveData write SetOnClientReceiveData;
   // только оповещение о приходе данных
   property OnClientReceiveInfo     : TOnClientReceiveInfo read FOnClientReceiveInfo write SetOnClientReceiveInfo;

   property OnError                 : TNotifyEvent read FOnError write FOnError;
   property OnClientError           : TNotifyEvent read FOnClientError write FOnClientError;
  end;

implementation

uses SocketMisc, SocketResStrings;

{ TServerKillDisconnectedClientThread }

constructor TServerKillDisconnectedClientThread.Create(aOwner: TBaseServerSocket);
begin
  FOwner               := aOwner;
  FCSection            := TCriticalSection.Create;
  FQueueRemovedClients := TList.Create;
  inherited Create(True,32768);
end;

destructor TServerKillDisconnectedClientThread.Destroy;
begin
  FreeAndNil(FQueueRemovedClients);
  FreeAndNil(FCSection);
  inherited Destroy;
end;

procedure TServerKillDisconnectedClientThread.Execute;
var TempEvent : TEvent;
    Res : TWaitResult;
    TempCliObj : TServerClientObj;
    TempKillTime : Word;
begin
  TempEvent := TEvent.Create(nil,True,False,'');
  TempKillTime := FOwner.KillTheradWaitTime;
  try
   while not Terminated do
    begin
     if Terminated then Break;
     Res := TempEvent.WaitFor(TempKillTime);
     if Terminated then Break;
     case Res of
      wrTimeout : begin
                   FCSection.Enter;
                   try
                    if FQueueRemovedClients.Count = 0 then Continue;
                    while FQueueRemovedClients.Count > 0 do
                     begin
                      TempCliObj := TServerClientObj(FQueueRemovedClients.Items[FQueueRemovedClients.Count-1]);
                      FQueueRemovedClients.Delete(FQueueRemovedClients.Count-1);
                      if Assigned(FOwner.OnClientDisconnect) then FOwner.OnClientDisconnect(FOwner,TempCliObj);
                      FOwner.RemoveClient(TempCliObj);
                     end;
                   finally
                    FCSection.Leave;
                   end;
                  end;
     end;
     if Terminated then Break;
    end;
  finally
   FreeAndNil(TempEvent);
  end;
end;

procedure TServerKillDisconnectedClientThread.AddDisconnectedClient(aClientObject: TServerClientObj);
begin
  FCSection.Enter;
  try
   FQueueRemovedClients.Insert(0,aClientObject);
  finally
   FCSection.Leave;
  end;
end;

{ TServerClientThread }

constructor TServerClientThread.Create(aClientObject: TServerClientObj; aCSection : TCriticalSection; aSetLastError : TClientSetErrorProc; aOnClientDisconnect : TNotifyEvent);
begin
 FClientObject       := aClientObject;
 FCSection           := aCSection;
 FSetLastError       := aSetLastError;
 FOnClientDisconnect := aOnClientDisconnect;
 inherited Create(True,32768);
end;

procedure TServerClientThread.Execute;
var Res          : TWaitResult;
    ReadRes      : Integer;
    TempDadaCame : Integer;
    TempBuff     : array of Byte;
    TempFlag     : Boolean;
    TempTick     : QWord;
    TempTimeOut  : Cardinal;
begin
  SetLength(TempBuff,FClientObject.SizeOfReceiveDataBuffer);
  TempTimeOut := FClientObject.SelectTimeOut;
  TempFlag    := False;
  while not Terminated do
  begin
   try
    TempTick := GetTickCount64;

    Res := FClientObject.WaitReceiveData;

    TempTick := GetTickCount64 - TempTick;

    if Terminated then Break;

    case Res of
     wrSignaled : begin
                   if not TempFlag then TempDadaCame := FClientObject.GetQuantityDataCame;
                   case TempDadaCame of
                    -1 : begin // ошибка
                          if TempTick = 0 then Sleep(TempTimeOut);
                         end;
                    0  : begin // клиент отключился
                          if not TempFlag then
                           begin;
                            if Assigned(FOnClientDisconnect) then FOnClientDisconnect(FClientObject);
                            TempFlag := True;
                           end;
                          if TempTick = 0 then Sleep(TempTimeOut);
                         end;
                   else // пришли данные
                     if not FClientObject.OnlyInformOfComingData then
                      begin // передаем данные в обработчик
                       if not Assigned(FClientObject.OnClientReceiveData) then
                        begin
                         if TempTick = 0 then Sleep(TempTimeOut);
                         Continue;
                        end;
                       // получаем количество пришедших данных
                       if Terminated then Break;
                       // читаем данные
                       ReadRes := FClientObject.ReceiveData(TempBuff[0],Length(TempBuff));
                       if Terminated then Break;
                       if ReadRes = -1 then Continue;
                       // передаем данные для обработки
                       try
                        FClientObject.OnClientReceiveData(FClientObject, TempBuff, Cardinal(ReadRes),Cardinal(TempDadaCame));
                       except
                        on E : Exception do SendLogMessage(llError,rsClientConnectionName,Format(rsClOnResData1,[E.Message]));
                       end;
                       if Terminated then Break;
                       // чистим буфер
                       FillByte(TempBuff[0],Length(TempBuff),0);
                      end
                     else // оповещаем о приходе данных
                      if Assigned(FClientObject.OnClientReceiveInfo) then
                       begin
                        try
                         FClientObject.OnClientReceiveInfo(FClientObject.Owner,FClientObject);
                        except
                         on E : Exception do SendLogMessage(llError,rsClientConnectionName,Format(rsClOnResData2,[E.Message]));
                        end;
                       end
                      else
                       if TempTick = 0 then Sleep(TempTimeOut);
                   end;
                  end;
    else
     Continue;
    end;

   except
    on E : Exception do
     begin
      SendLogMessage(llError,rsClientConnectionName,Format('TServerClientThread.Execute. Ошибка: %s',[E.Message]));
      Sleep(200);
     end;
   end;
  end;
  SetLength(TempBuff,0);
end;

{ TServerAcceptThread }

procedure TServerAcceptThread.Execute;
var TempCliHandle : TSocket;
    TempCliAddr : TInetSockAddr;
    TempLenAddr,TempErr : Integer;
    TempMaxConn : Word;
    TempSleepTime : Word;
begin
  TempLenAddr := SizeOf(TempCliAddr);
  TempMaxConn := FOwner.MaxNumberSimultaneousConnections;
  TempSleepTime := FOwner.AcceptTheradSleepTime;
  while not Terminated do
  begin
   try
    TempCliHandle := INVALID_SOCKET;
    TempCliAddr.sin_addr.s_addr := 0;
    FillByte(TempCliAddr,SizeOf(TempCliAddr),0);
    try
    TempCliHandle := {$IFDEF WINDOWS}accept(FSocket,@TempCliAddr,@TempLenAddr);{$ELSE}fpaccept(FSocket,@TempCliAddr,@TempLenAddr);{$ENDIF}
    except
     on E : Exception do
      begin
       TempCliHandle := INVALID_SOCKET;
       SendLogMessage(llError,'Accept',E.Message);
      end;
    end;

    case TempCliHandle of
     INVALID_SOCKET : begin
                       TempErr := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF};
                       if TempErr = EsockEWOULDBLOCK then
                        begin
                         Sleep(TempSleepTime);
                         Continue;
                        end;
                       if Assigned(FSetLastError) then FSetLastError(TempErr);
                      end;
    else
     // проверка на превышение количества одновременных соединений
     if (FOwner.ClientCount+1) >= TempMaxConn then
      begin
       {$IFDEF UNIX}FpClose(TempCliHandle){$ELSE}closesocket(TempCliHandle){$ENDIF};
       TempCliHandle := INVALID_SOCKET;
       Sleep(TempSleepTime);

       SendLogMessage(llError,rsServerSocketName,rsSrvAccept1);

       Continue;
      end;

     // создание объекта соединения
     if Assigned(FClientConnectProc) then FClientConnectProc(TempCliHandle,TempCliAddr);

    end;
    Sleep(TempSleepTime);

   except
    on E : Exception do
     begin
      SendLogMessage(llError,'AcceptThread',E.Message);
      Sleep(TempSleepTime);
     end;
   end;
  end;
end;

constructor TServerAcceptThread.Create(aOwner : TBaseServerSocket; aServerSocket: TSocket; aConnectProc: TServerClientConnect; aCSection : TCriticalSection; aSetErrorProc : TServerSetErrorProc);
begin
  FSocket            := aServerSocket;
  FCSection          := aCSection;
  FClientConnectProc := aConnectProc;
  FOwner             := aOwner;
  FSetLastError      := aSetErrorProc;
  inherited Create(True,32768);
end;

{ TServerClientObj }

function TServerClientObj.GetClientAddr: String;
begin
  Result := GetIPStr(ntohl(FClientAddr.sin_addr.s_addr));
end;

function TServerClientObj.GetClientAddrNum: Cardinal;
begin
  Result := ntohl(FClientAddr.sin_addr.s_addr);
end;

function TServerClientObj.GetClientPort: Word;
begin
  Result := ntohs(FClientAddr.sin_port);
end;

procedure TServerClientObj.SetSockBuffSize(AValue: Word);
var Res : Integer;
    TempBuffSize : Integer;
begin
  if FSockBuffSize=AValue then Exit;
  FSockBuffSize:=AValue;

  TempBuffSize := FSockBuffSize;

  // устанавливаем размер буфера приема
  Res := fpsetsockopt(FClientSocket,SOL_SOCKET,SO_RCVBUF,@TempBuffSize,SizeOf(TempBuffSize));
  if Res = -1 then
   begin
    try
     SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
     Exit;
    finally
     Close;
    end;
   end;
  // устанавливаем размер буфера отправки
  Res := fpsetsockopt(FClientSocket,SOL_SOCKET,SO_SNDBUF,@TempBuffSize,SizeOf(TempBuffSize));
  if Res = -1 then
   begin
    try
     SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
     Exit;
    finally
     Close;
    end;
   end;
end;

function TServerClientObj.GetTimeVal: timeval;
begin
  Result.tv_sec := FSelectTimeOut div 1000;
  Result.tv_usec := (FSelectTimeOut mod 1000) * 1000;
end;

procedure TServerClientObj.SetLastError(AError: Cardinal);
begin
  FLastError := AError;
  if Assigned(FSetLastError) then FSetLastError(Self,FLastError);
end;

procedure TServerClientObj.OnClientDisconnectProc(Sender: TObject);
begin
  FActive := False;
  if not Assigned(FOnClientDisconnect) then Exit;
  FOnClientClose := nil;
  FOnClientDisconnect(FOwner,Self);
end;

constructor TServerClientObj.Create(aOwner : TBaseServerSocket; aSocket: TSocket; aClentAddr: TInetSockAddr; aCSection : TCriticalSection; aOnClientDisconnect : TOnClientDisconnect; aSetErrorProc : TClientSetErrorProc);
{$IFDEF WINDOWS}
var nb : Integer;
{$ELSE}
var TempFlags : Cardinal;
{$ENDIF}
begin
  FActive             := True;
  FOwner              := aOwner;
  FClientSocket       := aSocket;
  FClientAddr         := aClentAddr;
  FCSection           := aCSection;
  FOnClientDisconnect := aOnClientDisconnect;
  FSetLastError       := aSetErrorProc;
  FClientThread       := nil;
  // переводим сокет в не блокирующий режим
  {$IFDEF WINDOWS}
  nb := 1; // 1 = nonblocking, 0 = blocking
  ioctlsocket(FClientSocket , LongInt(FIONBIO) , @nb );
  {$ELSE}
  TempFlags := FpFcntl(FClientSocket,F_GetFl);
  TempFlags := TempFlags or O_NONBLOCK;
  FpFcntl(FClientSocket,F_SetFl,TempFlags);
  {$ENDIF}
end;

destructor TServerClientObj.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TServerClientObj.Start;
begin
  if Assigned(FClientThread) then Exit;

  FClientThread := TServerClientThread.Create(Self,FCSection,FSetLastError,@OnClientDisconnectProc);
  FClientThread.Logger := Logger;
  FClientThread.Start;
end;

procedure TServerClientObj.Stop;
begin
  if not Assigned(FClientThread) then Exit;
  FClientThread.Terminate;
  FClientThread.WaitFor;
  FreeAndNil(FClientThread);
end;

procedure TServerClientObj.Close;
var Res : Integer;
begin
  Stop;

  fpshutdown(FClientSocket,2);

  {$IFDEF UNIX}
  Res := FpClose(FClientSocket);
  if Res = -1 then SetLastError(fpgeterrno);
  {$ELSE}
  Res := closesocket(FClientSocket);
  if Res = -1 then SetLastError(GetLastOSError);
  {$ENDIF}
  FClientSocket := INVALID_SOCKET;
  FActive       := False;
  if Assigned(FOnClientClose) then FOnClientClose(FOwner,Self);
end;

function TServerClientObj.GetQuantityDataCame: Integer;
var ByteCount : Integer;
begin
  Result := {$IFDEF UNIX}FpIOCtl{$ELSE}ioctlsocket{$ENDIF}(FClientSocket,FIONREAD,@ByteCount); // получаем количество пришедших данных
  if Result = -1 then
   begin
    SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
    Exit;
   end;
  Result := ByteCount;
end;

function TServerClientObj.ReceiveData(var Buff; aSize: Cardinal): Integer;
begin
  Result := fprecv(FClientSocket,@Buff,aSize,0);
  if Result = -1 then SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
end;

function TServerClientObj.SendDada(var Buff; aSize: Cardinal): Integer;
begin
  Result := fpsend(FClientSocket,@Buff,aSize,0);
  if Result = -1 then SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
end;

function TServerClientObj.WaitReceiveData: TWaitResult;
var TempTimeval   : timeval;
    Res           : Integer;
    TempReadFDSet : TFDSet;
begin
  TempTimeval := GetTimeVal;
  {$IFDEF UNIX}fpFD_ZERO{$ELSE}FD_ZERO{$ENDIF}(TempReadFDSet);
  {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(FClientSocket,TempReadFDSet);
  Res := {$IFDEF UNIX}fpSelect{$ELSE}select{$ENDIF}(FClientSocket+1,@TempReadFDSet,nil,nil,@TempTimeval);
  case Res of
   -1 : begin // ошибка
         Result := wrError;
         SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
        end;
   0  : begin // таймаут
         Result := wrTimeout;
        end;
  else        // пришли данные
   Result := wrSignaled;
  end;
end;

{ TBaseServerSocket }

constructor TBaseServerSocket.Create;
begin
  FSocket := INVALID_SOCKET;
  FillByte(FAddr,sizeof(TInetSockAddr),0);
  FAddr.sin_family         := AF_INET;
  FAddr.sin_addr.s_addr    := htonl(Cardinal(INADDR_ANY));
  FAddr.sin_port           := htons(30000);
  FLastError               := 0;
  FLastErrorDescr          := '';
  FListenQueueSize         := 100;
  FAcceptThread            := nil;
  FClientList              := TList.Create;
  FClosing                 := False;
  FCSection                := TCriticalSection.Create;
  FClientCreateStopped     := False;
  FSizeOfReceiveDataBuffer := 1500;
  FSockBuffSize            := 4096;
  FSelectTimeOut           := 1000;
  FMaxConnNumber           := MAX_NUM_PARALLEL_CON;
  FAcceptTheradSleepTime   := 100;
  FKillTheradWaitTime      := 20;
end;

destructor TBaseServerSocket.Destroy;
begin
  Active := False;
  FreeAndNil(FClientList);
  FreeAndNil(FCSection);
  inherited Destroy;
end;

procedure TBaseServerSocket.Open;
var Res : Integer;
    TempOpt : Integer;
    {$IFDEF WINDOWS}nb,{$ENDIF}TempFlags : Integer;
begin
  FClosing := False;

  SetLastError(0);

  // открываем сокет
  FSocket := fpsocket(AF_INET,SOCK_STREAM,0);
  if FSocket = INVALID_SOCKET then
   begin
    SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
    Exit;
   end;
  // устанавливаем возможность использования адреса
  Res := fpsetsockopt(FSocket,SOL_SOCKET,SO_REUSEADDR,@TempOpt,SizeOf(TempOpt));
  if Res = -1 then
   begin
    try
     SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
     Exit;
    finally
     Close;
    end;
   end;

  // переводим в неблокирующий режим

  {$IFDEF WINDOWS}
  nb := 1; // 1 = nonblocking, 0 = blocking
  Res := ioctlsocket(FSocket, LongInt(FIONBIO), @nb );
  if Res = -1 then
   begin
    try
     SetLastError(GetLastOSError);
     Exit;
    finally
     Close;
    end;
   end;
  {$ELSE}
  TempFlags := FpFcntl(FSocket,F_GetFl);
  if TempFlags = -1 then
   begin
    try
     SetLastError(fpgeterrno);
     Exit;
    finally
     Close;
    end;
   end;
  TempFlags := TempFlags or O_NONBLOCK;
  Res := FpFcntl(FSocket,F_SetFl,TempFlags);
  if Res = -1 then
   begin
    try
     SetLastError(fpgeterrno);
     Exit;
    finally
     Close;
    end;
   end;
  {$ENDIF}

  // связываем с адресом. По умолчанию 0.0.0.0 - соединения принимаются с любого адреса
  Res := fpbind(FSocket, @FAddr, sizeof(FAddr));
  if Res = -1 then
   begin
    try
     SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
     Exit;
    finally
     Close;
    end;
   end;
  // устанавливаем размер очереди соединений
  Res := fplisten(FSocket,FListenQueueSize);
  if Res = -1 then
   begin
    try
     SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
     Exit;
    finally
     Close;
    end;
   end;

  // запуск отслеживания клиентских соединений
  FAcceptThread := TServerAcceptThread.Create(Self,FSocket,@ClientConnectProc,FCSection,@SetLastError);
  FAcceptThread.Logger := Logger;
  FAcceptThread.Start;

  // запуск потока удаляющего разорванные сокеты
  FKillThread := TServerKillDisconnectedClientThread.Create(Self);
  FKillThread.Logger := Logger;
  FKillThread.Start;

  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TBaseServerSocket.Close;
var Res : Integer;
begin
  FClosing := True;
  if Assigned(FAcceptThread) then
   begin;
    FAcceptThread.Terminate;
    FAcceptThread.WaitFor;
    FreeAndNil(FAcceptThread);
   end;
  if Assigned(FKillThread) then
   begin;
    FKillThread.Terminate;
    FKillThread.WaitFor;
    FreeAndNil(FKillThread);
   end;
  CloseAllClientSockets;
  try
  Res := {$IFDEF UNIX}FpClose{$ELSE}closesocket{$ENDIF}(FSocket);
  if Res = -1 then
   begin
    SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
    Exit;
   end;
  finally
   FSocket := INVALID_SOCKET;
  end;
  if Assigned(FOnClose) then FOnClose(Self);
end;

procedure TBaseServerSocket.RemoveClient(var aClient: TServerClientObj);
var i : Integer;
begin
  Lock;
  try
   i := FClientList.IndexOf(aClient);
   if i = -1 then Exit;
   FClientList.Delete(i);
  finally
   Unlock;
  end;

  FreeAndNil(aClient);

  SendLogMessage(llInfo,rsServerSocketName,Format(rsBSrvSockRemCl1,[FClientList.Count]));
end;

procedure TBaseServerSocket.CloseAllClientSockets;
var TempClient : TServerClientObj;
    i,Count : Integer;
begin
 Lock;
 try
  Count := FClientList.Count-1;
  for i := Count downto 0 do
   begin
    TempClient := TServerClientObj(FClientList.Items[i]);
    FClientList.Delete(i);
    TempClient.Free;
   end;
 finally
  Unlock;
 end;
end;

procedure TBaseServerSocket.SetLastError(ALastError: Cardinal);
begin
  if (ALastError <> 0) then
   begin;
    Lock;
    try
     if (FLastError = ALastError) then Exit;
     FLastError      := ALastError;
     FLastErrorDescr := SocketErrorToString(ALastError);
     SendLogMessage(llError,rsServerSocketName,FLastErrorDescr);

     try
      if Assigned(FOnError) then FOnError(Self);
     except
     end;

    finally
     Unlock;
    end;
   end
  else
   begin
    Lock;
    try
     FLastError      := ALastError;
     FLastErrorDescr := '';
    finally
     Unlock;
    end;
   end;
end;

procedure TBaseServerSocket.SetClientLastError(aClient: TServerClientObj; aError: Cardinal);
begin
  if (aError <> 0) then
   begin;
    Lock;
    try
     if (FLastError = aError) then Exit;
     FLastError      := aError;
     FLastErrorDescr := SocketErrorToString(aError);
     SendLogMessage(llError,rsClientConnectionName,Format(rsClLasrErrSet1,[aClient.ClientAddr,aClient.ClientPort,IntToStr(aError),FLastErrorDescr]));

     try
      if Assigned(FOnClientError) then FOnClientError(aClient);
     except
     end;

    finally
     Unlock;
    end;
   end
  else
   begin
    Lock;
    try
     FLastError      := aError;
     FLastErrorDescr := '';
    finally
     Unlock;
    end;
   end;
end;

procedure TBaseServerSocket.Lock;
begin
  if Assigned(FAcceptThread) then FCSection.Enter;
end;

procedure TBaseServerSocket.Unlock;
begin
  if Assigned(FAcceptThread) then FCSection.Leave;
end;

function TBaseServerSocket.ClientConnectProc(aSocket: TSocket; aClentAddr: TInetSockAddr): TServerClientObj;
begin
  Result := nil;

  if FClosing then Exit;

  Lock;
  try

   Result := TServerClientObj.Create(Self,aSocket,aClentAddr,FCSection,@ClientDisconnectProc,@SetClientLastError);
   Result.Logger                  := Logger;
   Result.SizeOfReceiveDataBuffer := FSizeOfReceiveDataBuffer;
   Result.SocketBuffSize          := FSockBuffSize;
   Result.SelectTimeOut           := FSelectTimeOut;
   Result.OnlyInformOfComingData  := FOnlyInformOfComingData;
   Result.OnClientClose           := FOnClientClose;
   Result.OnClientReceiveData     := FOnClientReceiveData;
   Result.OnClientReceiveInfo     := FOnClientReceiveInfo;

   FClientList.Add(Result);

   if not FClientCreateStopped then
    begin
     Result.Start;
    end;

   SendLogMessage(llInfo,rsServerSocketName,Format(rsClConnect1,[FClientList.Count]));

   if Assigned(FOnClientConnect) then FOnClientConnect(Self,Result);
  finally
   Unlock;
  end;
end;

procedure TBaseServerSocket.ClientDisconnectProc(Sender: TBaseServerSocket; aClient: TServerClientObj);
begin
  FKillThread.AddDisconnectedClient(aClient);
end;

function TBaseServerSocket.GetActive: Boolean;
begin
  Result := FSocket <> INVALID_SOCKET;
end;

procedure TBaseServerSocket.SetAcceptTheradSleepTime(AValue : Word);
begin
  if FAcceptTheradSleepTime = AValue then Exit;
  Lock;
  try
   FAcceptTheradSleepTime := AValue;
  finally
   Unlock;
  end;
end;

function TBaseServerSocket.GetBindAddress: String;
begin
  Result := GetIPStr(ntohl(FAddr.sin_addr.s_addr));
end;

procedure TBaseServerSocket.SetBindAddress(AValue: String);
begin
  FAddr.sin_addr.s_addr := htonl(GetIPFromStr(AValue));
end;

function TBaseServerSocket.GetClientCount: Integer;
begin
  Lock;
  try
   Result := FClientList.Count;
  finally
   Unlock;
  end;
end;

function TBaseServerSocket.GetClients(Index : integer): TServerClientObj;
begin
 Lock;
 try
  Result := TServerClientObj(FClientList.Items[Index]);
 finally
  Unlock;
 end;
end;

function TBaseServerSocket.GetPort: Word;
begin
 Result := ntohs(FAddr.sin_port);
end;

procedure TBaseServerSocket.SetKillTheradWaitTime(AValue : Word);
begin
  if FKillTheradWaitTime = AValue then Exit;
  Lock;
  try
   FKillTheradWaitTime := AValue;
  finally
   Unlock;
  end;
end;

procedure TBaseServerSocket.SetMaxConnNumber(AValue : Word);
begin
  if FMaxConnNumber = AValue then Exit;
  Lock;
  try
   FMaxConnNumber := AValue;
  finally
   Unlock;
  end;
end;

procedure TBaseServerSocket.SetOnClientClose(AValue: TOnClientDisconnect);
var i,Count : Integer;
begin
  if FOnClientClose=AValue then Exit;
  FOnClientClose:=AValue;
  Lock;
  try
   Count := FClientList.Count-1;
   for i := Count downto 0 do TServerClientObj(FClientList.Items[i]).OnClientClose := FOnClientClose;
  finally
   Unlock;
  end;
end;

procedure TBaseServerSocket.SetOnClientDisconnect(AValue: TOnClientDisconnect);
begin
  if FOnClientDisconnect=AValue then Exit;
  FOnClientDisconnect:=AValue;
end;

procedure TBaseServerSocket.SetOnClientReceiveData(AValue: TOnClientReceiveData);
var i,Count : Integer;
begin
  if FOnClientReceiveData=AValue then Exit;
  FOnClientReceiveData:=AValue;
  Lock;
  try
   Count := FClientList.Count-1;
   for i := Count downto 0 do TServerClientObj(FClientList.Items[i]).OnClientReceiveData := FOnClientReceiveData;
  finally
   Unlock;
  end;
end;

procedure TBaseServerSocket.SetOnClientReceiveInfo(AValue: TOnClientReceiveInfo);
var i,Count : Integer;
begin
  if FOnClientReceiveInfo=AValue then Exit;
  FOnClientReceiveInfo:=AValue;
  Lock;
  try
   Count := FClientList.Count-1;
   for i := Count downto 0 do TServerClientObj(FClientList.Items[i]).OnClientReceiveInfo := FOnClientReceiveInfo;
  finally
   Unlock;
  end;
end;

procedure TBaseServerSocket.SetOnlyInformOfComingData(AValue: Boolean);
var i,Count : Integer;
begin
  if FOnlyInformOfComingData=AValue then Exit;
  FOnlyInformOfComingData:=AValue;
  Lock;
  try
   Count := FClientList.Count-1;
   for i := Count downto 0 do TServerClientObj(FClientList.Items[i]).OnlyInformOfComingData := FOnlyInformOfComingData;
  finally
   Unlock;
  end;
end;

procedure TBaseServerSocket.SetSizeOfReceiveDataBuffer(AValue: Cardinal);
var i,Count : Integer;
begin
  if FSizeOfReceiveDataBuffer=AValue then Exit;
  FSizeOfReceiveDataBuffer:=AValue;
  Lock;
  try
   Count := FClientList.Count-1;
   for i := Count downto 0 do TServerClientObj(FClientList.Items[i]).SizeOfReceiveDataBuffer := FSizeOfReceiveDataBuffer;
  finally
   Unlock;
  end;
end;

procedure TBaseServerSocket.SetSockBuffSize(AValue: Word);
var i,Count : Integer;
begin
  if FSockBuffSize=AValue then Exit;
  FSockBuffSize:=AValue;
  Lock;
  try
   Count := FClientList.Count-1;
   for i := Count downto 0 do TServerClientObj(FClientList.Items[i]).SocketBuffSize := FSockBuffSize;
  finally
   Unlock;
  end;
end;

procedure TBaseServerSocket.SetPort(AValue: Word);
begin
 FAddr.sin_port := htons(AValue);
end;

procedure TBaseServerSocket.SetSelectTimeOut(AValue: Cardinal);
begin
  if FSelectTimeOut=AValue then Exit;
  FSelectTimeOut:=AValue;
end;

procedure TBaseServerSocket.SetActive(AValue: Boolean);
begin
  if AValue = Active then Exit;

  if AValue then Open
   else Close;
end;

procedure TBaseServerSocket.SetLogger(const Value: IDLogger);
var i,Count : Integer;
begin
  inherited SetLogger(Value);
  if Assigned(FAcceptThread) then FAcceptThread.Logger := Logger;
  Lock;
  try
   Count := FClientList.Count-1;
   for i := Count downto 0 do TServerClientObj(FClientList.Items[i]).Logger := Logger;
  finally
   Unlock;
  end;
end;

end.

