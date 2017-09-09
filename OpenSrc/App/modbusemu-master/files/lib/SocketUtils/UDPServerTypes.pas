unit UDPServerTypes;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, syncobjs,
     Sockets,
     SocketSimpleTypes,
     SelectTypes, ValidAddressTypes,
     UDPMiscTypes,
     LoggerItf
     {$IFDEF UNIX}
     ,BaseUnix
     {$ELSE}
     ,winsock
     {$ENDIF};

type

  { TUDPServer }

  TUDPServer = class(TObjectLogged)
  private
   FSocket           : TSocket;
   FAddr             : sockaddr;
   FBuffSize         : Word;
   FSelectTimeOut    : Cardinal;
   FFilterClients    : Boolean;
   FIsUseSelectTread : Boolean;

   FLastError        : Cardinal;
   FLastErrorDescr   : String;

   FSelectThread     : TSelectThread;
   FValidIpList      : TListOfValidAddressesIP4;
   FCSection         : syncobjs.TCriticalSection;

   FOnClose          : TNotifyEvent;
   FOnOpen           : TNotifyEvent;
   FOnRecvPackage    : TOnRecvPackage;
   function  GetActive: Boolean;
   procedure SetActive(AValue: Boolean);
   function  GetBindAddress: String;
   procedure SetBindAddress(AValue: String);
   function  GetPort: Word;
   procedure SetIsUseSelectTread(AValue: Boolean);
   procedure SetPort(AValue: Word);
   procedure SetBuffSize(AValue: Word);
   procedure SetSelectTimeOut(AValue: Cardinal);
  protected
   property Socket   : TSocket read FSocket;
   property Addr     : sockaddr read FAddr;
   property CSection : syncobjs.TCriticalSection read FCSection;

   procedure SetLogger(const Value: IDLogger); override;
   procedure SetLastError(ALastError : Cardinal);

   procedure OnSelectErrorProc(ASource : TObject);
   procedure OnSelectSignaledProc(ASource : TObject);

   procedure Lock;
   procedure Unlock;
  public
   constructor Create; virtual;
   destructor  Destroy; override;

   // открытие серверного сокета
   procedure Open;
   // закрытие серверного сокета
   procedure Close;
   // послать пакет
   function  SendPackege(ATargetAddr : sockaddr; Buff : Pointer; BuffLen : Integer) : Boolean;
   // получить пакет
   function  ReceivePackage(const Buff : Pointer; BuffSize : Cardinal; out AAddr: sockaddr; out AAddrLen : Integer) : Boolean;
   // ожидание прихода данных
   function  WaitePackage : TWaitResult;

   // акдивизация/деактивизация серверного сокета
   property Active        : Boolean read GetActive write SetActive;
   // использовать или нет поток отслеживания прихода пакетов
   property IsUseSelectTread : Boolean read FIsUseSelectTread write SetIsUseSelectTread default True;
  published
   // порт серверного сокета
   property Port          : Word read GetPort write SetPort default 5000;
   // адрес для связывания серверного сокета
   property BindAddress   : String read GetBindAddress write SetBindAddress;
   // размер входных/выходных буферов клиентского сокета
   property BuffSize      : Word read FBuffSize write SetBuffSize default 8192;
   // таймаут ожидания прихода сообщения. Минимальный - 10 ms
   property SelectTimeOut : Cardinal read FSelectTimeOut write SetSelectTimeOut default 1000;
   // фильтровать или нет пакеты от клиентов
   property FilterClients : Boolean read FFilterClients write FFilterClients default False;
   // перечень разрешенных IP клиентов
   property ValidIpList   : TListOfValidAddressesIP4 read FValidIpList;

   // обработчик события открытия серверного сокета
   property OnOpen        : TNotifyEvent read FOnOpen write FOnOpen;
   // обработчик события закрытия серверного сокета
   property OnClose       : TNotifyEvent read FOnClose write FOnClose;
   // обработчик события прихода сообщения от клиента. Выполняется в контексте потока Select
   property OnRecvPackage : TOnRecvPackage read FOnRecvPackage write FOnRecvPackage;
  end;

implementation

uses SocketMisc, SocketResStrings;

{ TUDPServer }

constructor TUDPServer.Create;
begin
  FCSection := syncobjs.TCriticalSection.Create;
  FValidIpList := TListOfValidAddressesIP4.Create;
  FSocket := INVALID_SOCKET;
  FillByte(FAddr,sizeof(sockaddr),0);
  FAddr.sin_family := AF_INET;
  FIsUseSelectTread := True;
  SetBindAddress(INADDR_ANY_STR);
  SetPort(6000);
  SetSelectTimeOut(1000);
  SetLastError(0);
  FBuffSize := 8192;
  FSelectThread := nil;
  FFilterClients := False;
end;

destructor TUDPServer.Destroy;
begin
  Active := False;
  FreeAndNil(FValidIpList);
  FreeAndNil(FCSection);
  inherited Destroy;
end;

procedure TUDPServer.Open;
var Res       : Integer;
    TempOpt   : Integer;
    {$IFDEF WINDOWS}
    nb : Integer;
    {$ELSE}
    TempFlags : Integer;
    {$ENDIF}
begin
  SetLastError(0);

  // открываем сокет
  FSocket := fpsocket(AF_INET,SOCK_DGRAM,0);
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

  if FIsUseSelectTread then
   begin
    FSelectThread := TSelectThread.Create(FSocket,FCSection);
    FSelectThread.Logger     := Logger;
    FSelectThread.TimeOut    := FSelectTimeOut;
    FSelectThread.OnError    := @OnSelectErrorProc;
    FSelectThread.OnSignaled := @OnSelectSignaledProc;
    FSelectThread.Start;
   end;

  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TUDPServer.Close;
var Res : Integer;
begin
  if Assigned(FSelectThread) then
   begin
    FSelectThread.Terminate;
    FSelectThread.WaitFor;
    FreeAndNil(FSelectThread);
   end;

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

  SetLastError(0);

  if Assigned(FOnClose) then FOnClose(Self);
end;

function TUDPServer.SendPackege(ATargetAddr : sockaddr; Buff: Pointer; BuffLen: Integer): Boolean;
var Res : Integer;
    TempErr : LongInt;
begin
  Result := False;

  if not Active then Exit;

  if (not Assigned(Buff)) or (BuffLen = 0) then
   begin
    SendLogMessage(llDebug,rsUDPSendPackage1,rsUDPSendPackage2);
    Exit;
   end;
  Lock;
  try
   if BuffLen <= FBuffSize then // передаваемый буфер меньше или равен буферу сокета
    begin
     Res := fpsendto(FSocket,Buff,BuffLen,0,@ATargetAddr,SizeOf(ATargetAddr));
     if Res = -1 then
      begin
       TempErr := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF};
       {$IFDEF UNIX}
       if TempErr <> ESysEAGAIN then
        begin
       {$ENDIF}
         SetLastError(TempErr);
         Exit;
       {$IFDEF UNIX}
        end;
       {$ENDIF}
      end;
    end
   else
    begin
     // необходимо разработать алгоритм отправки больших буферов
     SetLastError({$IFDEF UNIX}ESysEMSGSIZE{$ELSE}EMSGSIZE{$ENDIF});
     Exit;
    end;
   Result := True;
  finally
   Unlock;
  end;
end;

function TUDPServer.ReceivePackage(const Buff: Pointer; BuffSize: Cardinal; out AAddr: sockaddr; out AAddrLen: Integer): Boolean;
var Res : Integer;
begin
  Result := False;
  AAddr.sin_port := 0;

  if not Active then Exit;

  if IsUseSelectTread then Exit;

  AAddrLen := SizeOf(AAddr);
  FillChar(AAddr,AAddrLen,$00);
  AAddr.sin_family := AF_INET;

  Res := fprecvfrom(FSocket,Buff,BuffSize,0,@AAddr,@AAddrLen);
  if Res = -1 then
   begin
    SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
    Exit;
   end;

  Result := True;
end;

function TUDPServer.WaitePackage: TWaitResult;
var TempTimeval   : timeval;
    Res           : Integer;
    TempReadFDSet : TFDSet;
begin
    Result := wrError;
    {$IFDEF WINDOWS} TempReadFDSet.fd_count := 0; {$ELSE} TempReadFDSet[0] := 0; {$ENDIF}

    if not Active then Exit;

    if IsUseSelectTread then Exit;

    TempTimeval.tv_sec := FSelectTimeOut div 1000;
    TempTimeval.tv_usec := (FSelectTimeOut mod 1000) * 1000;
    {$IFDEF UNIX}fpFD_ZERO{$ELSE}FD_ZERO{$ENDIF}(TempReadFDSet);
    {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(FSocket,TempReadFDSet);
    Res := {$IFDEF UNIX}fpSelect{$ELSE}select{$ENDIF}(FSocket+1,@TempReadFDSet,nil,nil,@TempTimeval);
    case Res of
     -1 : begin // ошибка
           FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF};
          end;
     0  : begin // таймаут
           Result := wrTimeout;
          end;
    else        // пришли данные
     Result := wrSignaled;
    end;
end;

procedure TUDPServer.OnSelectSignaledProc(ASource: TObject);
var Res         : Integer;
    TempBuff    : Pointer;
    TempAddr    : sockaddr;
    TempAddrLen : LongInt;
begin
  TempBuff := Getmem(FBuffSize);
  TempAddr.sin_port := 0;
  try
   FillChar(TempBuff^,SizeOf(FBuffSize),$00);

   TempAddrLen := SizeOf(TempAddr);
   FillChar(TempAddr,TempAddrLen,$00);
   TempAddr.sin_family := AF_INET;

   { возможно,что предварительно надо определять количество пришедших данных - во флагах передавать MSG_PEEK or MSG_TRUNC
     и повторным вызовом читать сам пакет}

   Res := fprecvfrom(FSocket,TempBuff,FBuffSize,0,@TempAddr,@TempAddrLen);
   if Res = -1 then
    begin
     SetLastError({$IFDEF UNIX}fpgeterrno{$ELSE}GetLastOSError{$ENDIF});
     Exit;
    end;

   if FFilterClients then
    begin
     if not FValidIpList.IsAddressValid(ntohl(TempAddr.sin_addr.s_addr)) then
      begin
       SendLogMessage(llDebug,rsOnUDPSign1,rsOnUDPSign3);
       Exit;
      end;
    end;

   if not Assigned(FOnRecvPackage) then Exit;

   try
    if Assigned(FOnRecvPackage) then FOnRecvPackage(Self,TempAddr,TempBuff,Res)
     else SendLogMessage(llError,rsOnUDPSign2,rsOnUDPSign4);
   except
    on E : Exception do
     begin
      SendLogMessage(llError,rsOnUDPSign2,Format(rsOnUDPSign5,[E.Message]));
     end;
   end;

  finally
   Freemem(TempBuff);
  end;
end;

procedure TUDPServer.OnSelectErrorProc(ASource: TObject);
begin
  SetLastError(TSelectThread(ASource).LastError);
end;

function TUDPServer.GetBindAddress: String;
begin
  Result := GetIPStr(ntohl(FAddr.sin_addr.s_addr));
end;

procedure TUDPServer.SetBindAddress(AValue: String);
begin
  FAddr.sin_addr.s_addr := htonl(GetIPFromStr(AValue));
end;

function TUDPServer.GetActive: Boolean;
begin
  Result := FSocket <> INVALID_SOCKET;
end;

procedure TUDPServer.SetActive(AValue: Boolean);
begin
  if AValue = Active then Exit;

  if AValue then Open
   else Close;
end;

function TUDPServer.GetPort: Word;
begin
  Result := ntohs(FAddr.sin_port);
end;

procedure TUDPServer.SetIsUseSelectTread(AValue: Boolean);
begin
  if FIsUseSelectTread=AValue then Exit;
  FIsUseSelectTread := AValue;
  if FIsUseSelectTread then
   begin
    if Assigned(FSelectThread) then Exit;
    FSelectThread := TSelectThread.Create(FSocket,FCSection);
    FSelectThread.Logger     := Logger;
    FSelectThread.TimeOut    := FSelectTimeOut;
    FSelectThread.OnError    := @OnSelectErrorProc;
    FSelectThread.OnSignaled := @OnSelectSignaledProc;
    FSelectThread.Start;
   end
  else
   begin
    if not Assigned(FSelectThread) then Exit;
    FSelectThread.Terminate;
    FSelectThread.WaitFor;
    FreeAndNil(FSelectThread);
   end;
end;

procedure TUDPServer.SetPort(AValue: Word);
begin
  FAddr.sin_port := htons(AValue);
end;

procedure TUDPServer.SetBuffSize(AValue: Word);
begin
  if FBuffSize=AValue then Exit;
  FBuffSize := AValue;
end;

procedure TUDPServer.SetSelectTimeOut(AValue: Cardinal);
begin
  if FSelectTimeOut=AValue then Exit;
  FSelectTimeOut := AValue;
  if Assigned(FSelectThread) then FSelectThread.TimeOut := FSelectTimeOut;
end;

procedure TUDPServer.SetLogger(const Value: IDLogger);
begin
  inherited SetLogger(Value);
  if Assigned(FSelectThread) then FSelectThread.Logger := Logger;
end;

procedure TUDPServer.SetLastError(ALastError: Cardinal);
begin
  if (ALastError <> 0) then
   begin;
    Lock;
    try
     if (FLastError = ALastError) then Exit;
     FLastError      := ALastError;
     FLastErrorDescr := SocketErrorToString(ALastError);
     SendLogMessage(llError,rsServerSocketName,FLastErrorDescr);
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

procedure TUDPServer.Lock;
begin
  FCSection.Enter;
end;

procedure TUDPServer.Unlock;
begin
  FCSection.Leave;
end;

end.

