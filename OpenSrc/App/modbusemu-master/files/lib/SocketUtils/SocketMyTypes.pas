unit SocketMyTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, sysutils, sockets, ssockets,
  SocketSimpleTypes, syncobjs,
  {$IFDEF UNIX}
  BaseUnix,
  {$ENDIF}
  {$IFDEF WINDOWS}
  windows, winsock2, ctypes,
  {$ENDIF}
  LoggerItf;

const
  ETIMEOUT = 110;

type
  TBaseClientSocket = class;

  TSocketBaseEventProc  = procedure (Socket: TBaseClientSocket; SocketEvent: TSocketEvent) of object;
  TSocketBaseErrorProc  = procedure (Socket: TBaseClientSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer) of object;
  TSocketBaseErrorEvent = procedure (Source: TObject; ErrorEvent: TErrorEvent; var ErrorCode: Integer) of object;

  TBaseSocketEventThread = class(TThreadLogged)
  private
   FBaseSocket         : TBaseClientSocket;
   FControlReadBuff    : Boolean;
   FControlSocketError : Boolean;
   FControlWriteBuff   : Boolean;
   FErrorProc          : TSocketBaseErrorProc;
   FEventProc          : TSocketBaseEventProc;
   FReadFDSet          : pFDSet;
   FWriteFDSet         : pFDSet;
   FErrorFDSet         : pFDSet;
   FTimeVal            : ptimeval;
   function  GetTimeout : Cardinal;
   procedure SetControlReadBuff(AValue : Boolean);
   procedure SetControlSocketError(AValue : Boolean);
   procedure SetControlWriteBuff(AValue : Boolean);
   procedure SetTimeout(AValue : Cardinal);
  protected
   FLastError       : Integer;
   FLastErrorSource : TErrorEvent;
   FLastMessage     : String;
   FLastMessageType : TLogLevel;
   procedure Execute; override;
   procedure InitThread;
   procedure CloseThread;
   procedure SendEventRead;
   procedure SendEventWrite;
   procedure SendEventError;
   procedure SendMessageLog;
   procedure SendMessageLogProc(ALavel : TLogLevel; AMessage : String);
   procedure SendEventErrorProc(AErrorEvent : TErrorEvent; AError : Integer);
  public
   constructor Create(ASocket    : TBaseClientSocket;
                      AEventProc : TSocketBaseEventProc;
                      AErrorProc : TSocketBaseErrorProc); virtual;
   destructor  Destroy; override;

   property EventProc          : TSocketBaseEventProc read FEventProc;
   property ErrorProc          : TSocketBaseErrorProc read FErrorProc;
   property BaseSocket         : TBaseClientSocket read FBaseSocket write FBaseSocket;
   property TimeOut            : Cardinal read GetTimeout write SetTimeout default 1000;
   property ControlSocketError : Boolean read FControlSocketError write SetControlSocketError default True;
   property ControlReadBuff    : Boolean read FControlReadBuff write SetControlReadBuff default True;
   property ControlWriteBuff   : Boolean read FControlWriteBuff write SetControlWriteBuff default False;
  end;

  TBaseClientSocket = class(TObjectLogged)
  private
   FIsRiseException     : Boolean;
   FSocket              : TSocket;
   FBlockingSocket      : Boolean;
   FControlReadBuff     : Boolean;
   FControlSocketError  : Boolean;
   FControlWriteBuff    : Boolean;
   FSelectEnable        : Boolean;
   FAddr                : TInetSockAddr;
   FAddress             : string;
   FPort                : Word;
   FSelThread           : TBaseSocketEventThread;
   FErrorCode           : LongInt;
   FSelectTimeOut       : Cardinal;
   FLastError           : Cardinal;
   FOnConnect           : TNotifyEvent;
   FOnConnecting        : TNotifyEvent;
   FOnDisconnect        : TNotifyEvent;
   FOnResive            : TNotifyEvent;
   FOnSend              : TNotifyEvent;
   FOnError             : TSocketBaseErrorEvent;
   function  GetActive : Boolean;
   procedure SetActive(AValue : Boolean);
   procedure SetAddress(AValue : string);
   procedure SetControlReadBuff(AValue : Boolean);
   procedure SetControlSocketError(AValue : Boolean);
   procedure SetControlWriteBuff(AValue : Boolean);
   procedure SetPort(AValue : Word);
   procedure SetSelectEnable(AValue : Boolean);
   procedure SetSelectTimeOut(AValue : Cardinal);
  protected
   procedure Event(Socket: TBaseClientSocket; SocketEvent: TSocketEvent); dynamic;
   procedure Error(Socket: TBaseClientSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer); dynamic;
   procedure InitThread;
   procedure CloseThread;
   function  SetNonBlockingSocket: Integer;
   function  WaiteNonblockingConnect : Integer;
  public
   constructor Create; virtual;
   destructor  Destroy; override;

   procedure Open;
   procedure Close;

   // получить количество пришедших данных
   function GetQuantityDataCame : Integer;

   function SendBuf(var Buf; Count: Integer): Integer;
   {
    В параметрах передается буфер и его размер.
    Если в параметрах передать в качестве буфера nil или размер буфера 0 или и то и другое, то метод вернет
    размер пришедших в сокет данных.
    Если метод возвращает 0, то это означает, что сервер закрыл соединение
   }
   function ReceiveBuf(var Buf; Count: Integer): Integer;

   function WaiteReceiveData : TWaitResult;

   property LastWaitError      : Cardinal read FLastError;
   property SocketHandle       : TSocket read FSocket;
   property AddrStruct         : TInetSockAddr read FAddr;

   property Active             : Boolean read GetActive write SetActive;

   property BlockingSocket     : Boolean read FBlockingSocket write FBlockingSocket default False;

   property Address            : string read FAddress write SetAddress;
   property Port               : Word read FPort write SetPort;

   property SelectEnable       : Boolean read FSelectEnable write SetSelectEnable default True;
   property SelectTimeOut      : Cardinal read FSelectTimeOut write SetSelectTimeOut default 1000;
   property ControlSocketError : Boolean read FControlSocketError write SetControlSocketError default True;
   property ControlReadBuff    : Boolean read FControlReadBuff write SetControlReadBuff default True;
   property ControlWriteBuff   : Boolean read FControlWriteBuff write SetControlWriteBuff default False;
   property IsRaiseException   : Boolean read FIsRiseException write FIsRiseException default False;

   {
    Нельзя в обработчиках событий  OnResive, OnSend и OnError закрывать соединение.
    В такой ситуации возможен дедлок
   }
   property OnConnect          : TNotifyEvent read FOnConnect write FOnConnect;
   property OnDisconnect       : TNotifyEvent read FOnDisconnect write FOnDisconnect;
   property OnConnecting       : TNotifyEvent read FOnConnecting write FOnConnecting;
   property OnResive           : TNotifyEvent read FOnResive write FOnResive;
   property OnSend             : TNotifyEvent read FOnSend write FOnSend;
   property OnError            : TSocketBaseErrorEvent read FOnError write FOnError;
  end;

implementation

uses resolve, SocketResStrings;

{ TBaseSocketEventThread }

constructor TBaseSocketEventThread.Create(ASocket : TBaseClientSocket; AEventProc : TSocketBaseEventProc; AErrorProc : TSocketBaseErrorProc);
begin
  FBaseSocket         := ASocket;
  FEventProc          := AEventProc;
  FErrorProc          := AErrorProc;
  FControlReadBuff    := True;
  FControlWriteBuff   := False;
  FControlSocketError := True;
  FLastError          := 0;
  FLastErrorSource    := eeNone;
  FLastMessage        := '';
  FLastMessageType    := llInfo;
  FTimeVal            := GetMem(SizeOf(TTimeVal));
  FillByte(FTimeVal^,SizeOf(TTimeVal),0);
  FTimeVal^.tv_sec    := 1;

  FReadFDSet          := GetMem(SizeOf(TFDSet));
  FWriteFDSet         := GetMem(SizeOf(TFDSet));
  FErrorFDSet         := GetMem(SizeOf(TFDSet));
  {$IFDEF UNIX}
  fpFD_ZERO(FReadFDSet^);
  fpFD_ZERO(FWriteFDSet^);
  fpFD_ZERO(FErrorFDSet^);
  {$ENDIF}
  {$IFDEF WINDOWS}
  FD_ZERO(FReadFDSet^);
  FD_ZERO(FWriteFDSet^);
  FD_ZERO(FErrorFDSet^);
  {$ENDIF}

  inherited Create(True,32768);
end;

destructor TBaseSocketEventThread.Destroy;
begin
  Freemem(FTimeVal);
  Freemem(FReadFDSet);
  Freemem(FWriteFDSet);
  Freemem(FErrorFDSet);
  inherited Destroy;
end;

function TBaseSocketEventThread.GetTimeout : Cardinal;
begin
  Result := FTimeVal^.tv_sec*1000+ FTimeVal^.tv_usec;
end;

procedure TBaseSocketEventThread.SetControlReadBuff(AValue : Boolean);
begin
  if FControlReadBuff = AValue then Exit;
  FControlReadBuff := AValue;
end;

procedure TBaseSocketEventThread.SetControlSocketError(AValue : Boolean);
begin
  if FControlSocketError = AValue then Exit;
  FControlSocketError := AValue;
end;

procedure TBaseSocketEventThread.SetControlWriteBuff(AValue : Boolean);
begin
  if FControlWriteBuff = AValue then Exit;
  FControlWriteBuff := AValue;
end;

procedure TBaseSocketEventThread.SetTimeout(AValue : Cardinal);
begin
  FTimeVal^.tv_sec := AValue div 1000;
  FTimeVal^.tv_usec := (AValue mod 1000) * 1000;
end;

procedure TBaseSocketEventThread.Execute;
var SelRes : Integer;
    {$IFDEF WINDOWS}
    SelRes1 : Boolean;
    {$ENDIF}
    TempTimeOut : Cardinal;
    TempReadFDSet,
    TempWriteFDSet,
    TempErrorFDSet : pFDSet;
begin
 InitThread;
 try
  TempTimeOut := GetTimeout;
  while not Terminated do
   begin
    if Assigned(FBaseSocket) then
     begin
      if Terminated then Break;
      if FControlReadBuff then TempReadFDSet := FReadFDSet
       else TempReadFDSet := nil;
      if FControlWriteBuff then TempWriteFDSet := FWriteFDSet
       else TempWriteFDSet := nil;
      if FControlSocketError then TempErrorFDSet := FErrorFDSet
       else TempErrorFDSet := nil;
      if Terminated then Break;
      SetTimeout(TempTimeOut);
      if Terminated then Break;
      SelRes := {$IFDEF UNIX}fpSelect{$ELSE}Select{$ENDIF}(FBaseSocket.SocketHandle+1,TempReadFDSet,TempWriteFDSet,TempErrorFDSet,FTimeVal);
      if Terminated then Break;
      case SelRes of
      -1 : begin // error
            if Terminated then Break;
            SendEventErrorProc(eeSelect,{$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF});
           end;
       0 : begin // timeout
            if Terminated then Break;
            if Assigned(TempReadFDSet) and Assigned(FBaseSocket) and (FBaseSocket.SocketHandle <> INVALID_SOCKET) then
             try
              if Terminated then Break;
              {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(FBaseSocket.SocketHandle,TempReadFDSet^);
             except
              on E : Exception do
               begin
                FLastMessage     := E.Message;
                FLastMessageType := llError;
                if Terminated then Break;
                SendMessageLog;
               end;
             end;
            if Terminated then Break;
            if Assigned(TempWriteFDSet)  and Assigned(FBaseSocket) and (FBaseSocket.SocketHandle <> INVALID_SOCKET) then
              try
               if Terminated then Break;
               {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(FBaseSocket.SocketHandle,TempWriteFDSet^);
              except
               on E : Exception do
                begin
                 FLastMessage     := E.Message;
                 FLastMessageType := llError;
                 if Terminated then Break;
                 SendMessageLog;
                end;
              end;
            if Terminated then Break;
            if Assigned(TempErrorFDSet) and Assigned(FBaseSocket) and (FBaseSocket.SocketHandle <> INVALID_SOCKET) then
              try
               if Terminated then Break;
               {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(FBaseSocket.SocketHandle,TempErrorFDSet^);
              except
               on E : Exception do
                begin
                 FLastMessage     := E.Message;
                 FLastMessageType := llError;
                 if Terminated then Break;
                 SendMessageLog;
                end;
              end;
           end;
      else // socket is changed
       if FControlReadBuff then
        begin
         if Terminated then Break;
         // проверяем на изменения по чтению - получению данных
         if Assigned(TempErrorFDSet) and Assigned(FBaseSocket) and (FBaseSocket.SocketHandle <> INVALID_SOCKET) then
          try
           if Terminated then Break;
           {$IFDEF UNIX}SelRes{$ELSE}SelRes1{$ENDIF} := {$IFDEF UNIX}fpFD_ISSET{$ELSE}FD_ISSET{$ENDIF}(FBaseSocket.SocketHandle,TempReadFDSet^);
          except
           on E : Exception do
            begin
             FLastMessage     := E.Message;
             FLastMessageType := llError;
             if Terminated then Break;
             SendMessageLog;
             SelRes := -1;
            end;
          end;
         case {$IFDEF UNIX}SelRes{$ELSE}SelRes1{$ENDIF} of
         {$IFDEF UNIX} -1 : begin // ошибка
                 if Terminated then Break;
                 SendEventErrorProc(eeReceive,{$IFDEF UNIX}fpgeterrno{$ELSE}Integer(GetLastError){$ENDIF});
               end;
          0 {$ELSE} False {$ENDIF} : begin // не изменился
                                      if Terminated then Break;
                                     end;
         else        // изменился - пришли данные на чтение
          if Terminated then Break;
          Synchronize(self,@SendEventRead);
         end;
        end;

       if FControlWriteBuff then
        begin
         if Terminated then Break;
         // проверяем на изменения по записи
         if Assigned(TempErrorFDSet) and Assigned(FBaseSocket) and (FBaseSocket.SocketHandle <> INVALID_SOCKET) then
          try
           if Terminated then Break;
           {$IFDEF UNIX}SelRes{$ELSE}SelRes1{$ENDIF} := {$IFDEF UNIX}fpFD_ISSET{$ELSE}FD_ISSET{$ENDIF}(FBaseSocket.SocketHandle,TempWriteFDSet^);
          except
           on E : Exception do
            begin
             FLastMessage     := E.Message;
             FLastMessageType := llError;
             if Terminated then Break;
             SendMessageLog;
             SelRes := -1;
            end;
          end;
         case {$IFDEF UNIX}SelRes{$ELSE}SelRes1{$ENDIF} of
         {$IFDEF UNIX} -1 : begin // ошибка
                if Terminated then Break;
                SendEventErrorProc(eeSend,{$IFDEF UNIX}fpgeterrno{$ELSE}Integer(GetLastError){$ENDIF});
               end;
         0 {$ELSE} False {$ENDIF}  : begin // не изменился
                                      if Terminated then Break;
                                     end;
         else        // изменился
          if Terminated then Break;
          Synchronize(self,@SendEventWrite);
         end;
        end;

       if FControlSocketError then
        begin
         if Terminated then Break;
         // ошибка на сокете
         if Assigned(TempErrorFDSet) and Assigned(FBaseSocket) and (FBaseSocket.SocketHandle <> INVALID_SOCKET) then
          try
           if Terminated then Break;
           {$IFDEF UNIX}SelRes{$ELSE}SelRes1{$ENDIF} := {$IFDEF UNIX}fpFD_ISSET{$ELSE}FD_ISSET{$ENDIF}(FBaseSocket.SocketHandle,TempErrorFDSet^);
          except
           on E : Exception do
            begin
             FLastMessage     := E.Message;
             FLastMessageType := llError;
             if Terminated then Break;
             SendMessageLog;
             SelRes := -1;
            end;
          end;
         case {$IFDEF UNIX}SelRes{$ELSE}SelRes1{$ENDIF} of
         {$IFDEF UNIX} -1 : begin // ошибка
                if Terminated then Break;
                SendEventErrorProc(eeSelect,{$IFDEF UNIX}fpgeterrno{$ELSE}Integer(GetLastError){$ENDIF});
               end;
         0 {$ELSE} False {$ENDIF}  : begin // не изменился
                                      if Terminated then Break;
                                     end;
         else        // изменился
          if Terminated then Break;
          SendEventErrorProc(eeSocket,{$IFDEF UNIX}fpgeterrno{$ELSE}Integer(GetLastError){$ENDIF});
         end;
        end;
      end; // case SelRes
     end
    else
     begin // FBaseSocket not assigned
      if Terminated then Break;
      Sleep(0);
     end;
   end;

 finally
  CloseThread;
 end;

end;

procedure TBaseSocketEventThread.SendEventRead;
begin
  if Assigned(FEventProc) then FEventProc(FBaseSocket,seRead);
end;

procedure TBaseSocketEventThread.SendEventWrite;
begin
  if Assigned(FEventProc) then FEventProc(FBaseSocket,seWrite);
end;

procedure TBaseSocketEventThread.SendEventError;
begin
 if Assigned(FEventProc) then FErrorProc(FBaseSocket,FLastErrorSource,FLastError);
 FLastError       := 0;
 FLastErrorSource := eeNone;
end;

procedure TBaseSocketEventThread.SendMessageLog;
begin
  SendLogMessage(FLastMessageType,Self.ClassName,FLastMessage);
  FLastMessageType := llInfo;
  FLastMessage     := '';
end;

procedure TBaseSocketEventThread.SendMessageLogProc(ALavel : TLogLevel; AMessage : String);
begin
  FLastMessageType := ALavel;
  FLastMessage     := AMessage;
  Synchronize(Self,@SendMessageLog);
end;

procedure TBaseSocketEventThread.SendEventErrorProc(AErrorEvent : TErrorEvent; AError : Integer);
begin
 FLastErrorSource := AErrorEvent;
 FLastError       := AError;
 Synchronize(self,@SendEventError);
end;

procedure TBaseSocketEventThread.InitThread;
begin
  if not Assigned(FBaseSocket) then Exit;
  {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(FBaseSocket.SocketHandle,FReadFDSet^);
  {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(FBaseSocket.SocketHandle,FWriteFDSet^);
  {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(FBaseSocket.SocketHandle,FErrorFDSet^);
end;

procedure TBaseSocketEventThread.CloseThread;
begin
  if not Assigned(FBaseSocket) then Exit;
  {$IFDEF UNIX}fpFD_CLR{$ELSE}FD_CLR{$ENDIF}(FBaseSocket.SocketHandle,FReadFDSet^);
  {$IFDEF UNIX}fpFD_CLR{$ELSE}FD_CLR{$ENDIF}(FBaseSocket.SocketHandle,FWriteFDSet^);
  {$IFDEF UNIX}fpFD_CLR{$ELSE}FD_CLR{$ENDIF}(FBaseSocket.SocketHandle,FErrorFDSet^);
end;

{ TBaseClientSocket }

constructor TBaseClientSocket.Create;
begin
  FSocket := INVALID_SOCKET;
  FillByte(FAddr,SizeOf(TInetSockAddr),0);
  FSelThread          := nil;
  FErrorCode          := 0;
  FSelectTimeOut      := 1000;
  FSelectEnable       := True;
  FControlReadBuff    := True;
  FControlWriteBuff   := False;
  FControlSocketError := True;
  FBlockingSocket     := False;
  FIsRiseException    := False;
end;

destructor TBaseClientSocket.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TBaseClientSocket.SetAddress(AValue : string);
begin
  if FAddress = AValue then Exit;
  FAddress := AValue;
end;

function TBaseClientSocket.GetActive : Boolean;
begin
  Result := FSocket <> INVALID_SOCKET;
end;

procedure TBaseClientSocket.SetActive(AValue : Boolean);
begin
  if AValue then
   begin
    Open;
   end
  else
   begin
    Close;
   end;
end;

procedure TBaseClientSocket.SetControlReadBuff(AValue : Boolean);
begin
  if FControlReadBuff = AValue then Exit;
  FControlReadBuff := AValue;
  if Assigned(FSelThread) then FSelThread.ControlReadBuff := AValue;
end;

procedure TBaseClientSocket.SetControlSocketError(AValue : Boolean);
begin
  if FControlSocketError = AValue then Exit;
  FControlSocketError := AValue;
  if Assigned(FSelThread) then FSelThread.ControlSocketError := AValue;
end;

procedure TBaseClientSocket.SetControlWriteBuff(AValue : Boolean);
begin
  if FControlWriteBuff = AValue then Exit;
  FControlWriteBuff := AValue;
  if Assigned(FSelThread) then FSelThread.ControlWriteBuff := AValue;
end;

procedure TBaseClientSocket.SetPort(AValue : Word);
begin
  if FPort = AValue then Exit;
  FPort := AValue;
end;

procedure TBaseClientSocket.SetSelectEnable(AValue : Boolean);
begin
  if FSelectEnable = AValue then Exit;
  FSelectEnable := AValue;
  if FSelectEnable then InitThread
   else CloseThread;
end;

procedure TBaseClientSocket.SetSelectTimeOut(AValue : Cardinal);
begin
  if FSelectTimeOut = AValue then Exit;
  FSelectTimeOut := AValue;
  if Assigned(FSelThread) then FSelThread.TimeOut := FSelectTimeOut;
end;

procedure TBaseClientSocket.Event(Socket : TBaseClientSocket; SocketEvent : TSocketEvent);
begin
  case SocketEvent of
   seConnecting : begin
                   try
                    if Assigned(FOnConnecting) then FOnConnecting(Socket)
                   except
                    on E : Exception do SendLogMessage(llError,Self.ClassName+'.Event -> FOnConnecting(Socket)',E.Message);
                   end;
                  end;
   seConnect    : begin
                   try
                    if Assigned(FOnConnect) then FOnConnect(Socket)
                   except
                    on E : Exception do SendLogMessage(llError,Self.ClassName+'.Event -> FOnConnect(Socket)',E.Message);
                   end;
                  end;
   seDisconnect : begin
                   try
                    if Assigned(FOnDisconnect) then FOnDisconnect(Socket)
                   except
                    on E : Exception do SendLogMessage(llError,Self.ClassName+'.Event -> FOnDisonnect(Socket)',E.Message);
                   end;
                  end;
   seRead       : begin
                   try
                    if Assigned(FOnResive) then FOnResive(Socket)
                   except
                    on E : Exception do SendLogMessage(llError,Self.ClassName+'.Event -> FOnResive(Socket)',E.Message);
                   end;
                  end;
   seWrite      : begin
                   try
                    if Assigned(FOnSend) then FOnSend(Socket)
                   except
                    on E : Exception do SendLogMessage(llError,Self.ClassName+'.Event -> FOnSend(Socket)',E.Message);
                   end;
                  end;
  end;
end;

procedure TBaseClientSocket.Error(Socket : TBaseClientSocket; ErrorEvent : TErrorEvent; var ErrorCode : Integer);
begin
  try
   if Assigned(FOnError) then FOnError(Socket,ErrorEvent,ErrorCode);
  except
   on E : Exception do SendLogMessage(llError,Self.ClassName+'.Error -> FOnError(Socket,ErrorEvent,ErrorCode)',E.Message);
  end;
end;

procedure TBaseClientSocket.InitThread;
begin
  if Assigned(FSelThread) then Exit;
  FSelThread := TBaseSocketEventThread.Create(Self,@Event,@Error);
  FSelThread.Logger             := Logger;
  FSelThread.TimeOut            := FSelectTimeOut;
  FSelThread.ControlReadBuff    := FControlReadBuff;
  FSelThread.ControlWriteBuff   := FControlWriteBuff;
  FSelThread.ControlSocketError := FControlSocketError;
  FSelThread.Start;
end;

procedure TBaseClientSocket.CloseThread;
begin
  if not Assigned(FSelThread) then Exit;

  FSelThread.ControlReadBuff    := False;
  FSelThread.ControlSocketError := False;
  FSelThread.ControlWriteBuff   := False;

  FSelThread.BaseSocket := nil;
  FSelThread.Terminate;
  FSelThread.WaitFor;

  FreeAndNil(FSelThread);
end;

function TBaseClientSocket.SetNonBlockingSocket : Integer;
var {$IFDEF WINDOWS} nb  : dword; {$ENDIF}
    {$IFDEF LINUX} arg : longint; {$ENDIF}
begin
  Result := -1;
  // nonblocking
  {$IFDEF LINUX}
  arg := FpFcntl( FSocket , F_GETFL );
  if arg >= 0 then
   begin
    arg := arg or O_NONBLOCK;
    Result := FpFcntl( FSocket , F_SETFL , arg );
   end;
  {$ENDIF}

  {$IFDEF WINDOWS}
  nb := 1; // 1 = nonblocking, 0 = blocking
  Result := ioctlsocket( FSocket , LongInt(FIONBIO) , @nb );
  {$ENDIF}
end;

function TBaseClientSocket.WaiteNonblockingConnect : Integer;
var TempWriteFDSet : TFDSet;
    TempTimeVal    : TTimeVal;
    TempRes, TempErr,TempErrLen : Integer;
begin
    FLastError := 0;
    {$IFDEF WINDOWS} TempWriteFDSet.fd_count := 0; {$ELSE} TempWriteFDSet[0] := 0; {$ENDIF}

    TempTimeVal.tv_sec := 5;
    TempTimeVal.tv_usec := 0;

    {$IFDEF UNIX}fpFD_ZERO{$ELSE}FD_ZERO{$ENDIF}(TempWriteFDSet);
    {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(SocketHandle,TempWriteFDSet);

    TempErr := 0;
    TempErrLen := SizeOf(TempErr);

    Result := {$IFDEF UNIX}fpSelect{$ELSE}Select{$ENDIF}(SocketHandle+1,nil,@TempWriteFDSet,nil,@TempTimeVal);
    case Result of
     -1  : begin  // ошибка вызова селекта
            FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
           end;
      0  : begin
            {$IFDEF WINDOWS}
             FLastError := WSAETIMEDOUT;//10060;
            {$ELSE}
             FLastError := ETIMEOUT;
            {$ENDIF}
            Result := -2; // таймаут
           end
    else // сигнальное состояние
      TempRes := fpgetsockopt(SocketHandle,SOL_SOCKET,SO_ERROR,@TempErr,@TempErrLen);
      if TempRes < 0 then
       begin
        FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
        Result := -1;
       end
      else
       begin
        FLastError := TempErr;
        if FLastError = 0 then Result := 0
         else Result :=-1;
       end;
    end;
end;

procedure TBaseClientSocket.Open;
var TempHostAddr     : THostAddr;
    TempAddr         : cuint32;
    TempHostRes      : THostResolver;
    TempRes,TempSize,TempOpt : Integer;
begin
  if FSocket <> INVALID_SOCKET then Exit;

  FLastError := 0;

  FSocket := fpsocket(AF_INET,SOCK_STREAM,0);
  if FSocket = TSocket(-1) then
   begin
    FSocket := INVALID_SOCKET;
    FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
    Error(Self,eeSocket,Integer(FLastError));
    if FLastError <> 0 then
     begin
      if FIsRiseException then raise ESocketError.Create(seConnectFailed,[FAddress]) else Exit;
     end
    else
     begin
      Exit;
     end;
   end;

  if not FBlockingSocket then
   begin
    TempRes := SetNonBlockingSocket;
    if TempRes = -1 then
      begin
       try
        FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
        Error(Self,eeSocket,Integer(FLastError));
        if FLastError <> 0 then
         begin
          if FIsRiseException then raise ESocketError.Create(seCreationFailed,[FAddress+'-'+SysErrorMessage(FLastError)]) else Exit;
         end
        else
         begin
          Exit;
         end;
       finally
        Close;
       end;
      end;
   end;

  TempRes := fpsetsockopt(FSocket,SOL_SOCKET,SO_REUSEADDR,@TempOpt,SizeOf(TempOpt));
  if TempRes = -1 then
   begin
    try
     FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
     Error(Self,eeSocket,Integer(FLastError));
     if FLastError <> 0 then
      begin
       if FIsRiseException then raise ESocketError.Create(seCreationFailed,[FAddress+'-'+SysErrorMessage(FLastError)]) else Exit;
      end
     else
      begin
       Exit;
      end;
    finally
     Close;
    end;
   end;

  TempHostAddr := StrToHostAddr(FAddress);
  if TempHostAddr.s_bytes[1] = 0 then
   begin
    TempHostRes := THostResolver.Create(nil);
    try
     if not TempHostRes.NameLookup(FAddress) then
      begin
       try
        FLastError := TempHostRes.LastError;
        Error(Self,eeLookup,Integer(FLastError));
        if FLastError <> 0 then
         begin
          if FIsRiseException then raise ESocketError.Create(seHostNotFound,[FAddress]) else Exit;
         end
        else
         begin
          Exit;
         end;
       finally
        Close;
       end;
      end;
     TempHostAddr := TempHostRes.HostAddress;
    finally
     TempHostRes.Free;
    end;
   end;

  FAddr.sin_family      := AF_INET;
  FAddr.sin_port        := htons(FPort);
  TempAddr              := TempHostAddr.s_addr;
  FAddr.sin_addr.s_addr := htonl(TempAddr);

  Event(Self,seConnecting);

  TempSize := sizeof(FAddr);

  TempRes := sockets.fpconnect(FSocket,@FAddr,TempSize);
  if TempRes = -1 then
   begin
    FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
    // если не блокирующий сокет - ждем коннекта
    if (not FBlockingSocket) and {$IFDEF UNIX}(FLastError = 115){$ENDIF}{$IFDEF WINDOWS}(FLastError = 10035){$ENDIF} then
     begin
      TempRes := WaiteNonblockingConnect;
      case TempRes of
       0 : begin // дождались соединения
            Event(Self,seConnect);
            Exit;
           end;
      end;
     end;

    try
     Error(Self,eeConnect,Integer(FLastError));
     if FLastError <> 0 then
      begin
       if FIsRiseException then raise ESocketError.Create(seConnectFailed,[FAddress+'-'+SysErrorMessage(FLastError)]) else Exit;
      end
     else
      begin
       Exit;
      end;
    finally
     Close;
    end;
   end;
  if FSelectEnable then InitThread;
  Event(Self,seConnect);
end;

procedure TBaseClientSocket.Close;
{$IFDEF WINDOWS} var nb :  Integer; {$ENDIF}
begin
  FLastError := 0;
  CloseThread;
  if FSocket = INVALID_SOCKET then Exit;
  if not FBlockingSocket then
  {$IFDEF LINUX}
   FpFcntl(FSocket, F_SETFL, 0);
  {$ENDIF}
  {$IFDEF WINDOWS}
   nb := 0;
   ioctlsocket(FSocket, LongInt(FIONBIO), @nb);
  {$ENDIF}

  fpshutdown(FSocket,2);

  FLastError := {$IFDEF LINUX}FpClose{$ELSE}closesocket{$ENDIF}(FSocket);
  try
   if FLastError <> 0 then if FIsRiseException then RaiseLastOSError else Exit;
  finally
   FSocket := INVALID_SOCKET;
  end;
  Event(Self,seDisconnect);
end;

function TBaseClientSocket.GetQuantityDataCame : Integer;
var ByteCount : Integer;
begin
  FLastError := 0;
  Result := {$IFDEF UNIX}FpIOCtl{$ELSE}ioctlsocket{$ENDIF}(FSocket,FIONREAD,@ByteCount); // получаем количество пришедших данных
  if Result = -1 then
   begin
    FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
    Error(Self,eeReceive,Integer(FLastError));
    Exit;
   end;
  Result := ByteCount;
end;

function TBaseClientSocket.SendBuf(var Buf; Count : Integer) : Integer;
var total,sends : Integer;
    PBuff  : Pointer;
begin
 Result := -1;
 FLastError := 0;
 if FSocket = INVALID_SOCKET then Exit;
 total := 0;
 PBuff := @Buf;
 while(total < count) do
  begin
   sends := {$IFDEF UNIX}fpsend(FSocket,PBuff,Count,MSG_NOSIGNAL){$ELSE}fpsend(FSocket,PBuff,Count,0){$ENDIF};
   if sends = -1 then
    begin
     FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
     Error(Self,eeSend,Integer(FLastError));
     Break;
    end;
   total += sends;
  end;

 if sends = -1 then Result := -1
  else Result := total;
end;

function TBaseClientSocket.ReceiveBuf(var Buf; Count : Integer) : Integer;
var TempRes : Integer;
begin
 Result := -1;
 FLastError := 0;
 if FSocket = INVALID_SOCKET then Exit;
 if not Assigned(@Buf) or (Count = 0) then
  begin
   TempRes := GetQuantityDataCame;
  end
 else
  begin
   TempRes := fprecv(FSocket,@Buf,Count,0); // читаем данные
   if TempRes = -1 then
    begin
     FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
     Error(Self,eeReceive,Integer(FLastError));
     Exit;
    end;
  end;
 Result := TempRes;
end;

function TBaseClientSocket.WaiteReceiveData : TWaitResult;
var TempReadFDSet : TFDSet;
    SelRes        : Integer;
    TempTimeVal   : TTimeVal;
begin
  Result := wrError;
  {$IFDEF WINDOWS} TempReadFDSet.fd_count := 0; {$ELSE} TempReadFDSet[0] := 0; {$ENDIF}
  if FSelectEnable then
   begin  // событие взводится в потоке
    if FIsRiseException then raise Exception.Create(rsWRData1);
   end
  else
   begin // если отслеживаение приходаданных через поток не используется
    FLastError := 0;

    TempTimeVal.tv_sec := FSelectTimeOut div 1000;
    TempTimeVal.tv_usec := (FSelectTimeOut mod 1000) * 1000;

    {$IFDEF UNIX}fpFD_ZERO{$ELSE}FD_ZERO{$ENDIF}(TempReadFDSet);
    {$IFDEF UNIX}fpFD_SET{$ELSE}FD_SET{$ENDIF}(SocketHandle,TempReadFDSet);

    SelRes := {$IFDEF UNIX}fpSelect{$ELSE}Select{$ENDIF}(SocketHandle+1,@TempReadFDSet,nil,nil,@TempTimeVal);

    case SelRes of
     -1  : begin
            FLastError := {$IFDEF UNIX}fpgeterrno{$ELSE}GetLastError{$ENDIF};
            Result     := wrError;
           end;
      0  : Result := wrTimeout;
    else
      Result := wrSignaled;
    end;
   end;
end;

end.

