unit WriteThread;

interface

uses {$IFDEF WINDOWS} Windows, Messages, {$ENDIF} Classes, SyncObjs, COMPortParamTypes;

{$IFDEF WINDOWS}

type
   TNPCWriteThread = class(TThread)
   private
    FCriticalSection     : TCriticalSection;   // критическая секция для доступа к данным потока
    FBuffer              : Pointer;            // буфер для отправки данных
    FBufferSize          : Cardinal;           // размер отправляемого буфера
    FIniBufferSize       : Cardinal;           // размер инициализации буфера
    FHandle              : THandle;            // хэндл файла для записи данных
    FStartEventHandle    : THandle;            // хэндл события старта потока
    FStopEventHandle     : THandle;            // хэндл события остоновки потока
    FBufferPreparedEv    : THandle;            // хэндл события заполнениея буфера данными - автовзвод события
    FTimeOutWaiting      : Cardinal;           // таймаут цикла потока
    FLastError           : Cardinal;           // последняя ошибка
    FNotifyOnTermination : Boolean;            // извещать или нет об окончании операции записи
    FOnLogEvent          : TEventlogMsgProc;   // внешняя процедура для записи в лог
    FOnWriteError        : TNotifyEvent;       // событие ошибки при записи
    FOnWriteEnded        : TNotifyEvent;       // событие окончания записи
    FWNDHandle           : HWND;
    FIsUseMessageQueue   : Boolean;
    procedure SetHandle(const Value: THandle);
    procedure SetStartEventHandle(const Value: THandle);
    procedure SetStopEventHandle(const Value: THandle);
    procedure SetTimeOutWaiting(const Value: Cardinal);
    function  GetBufferSize: Cardinal;
    procedure SetBufferSize(const Value: Cardinal);
    function  GetLastWriteError: Cardinal;
    procedure SetNotifyOnTermination(const Value: Boolean);
   protected
    procedure Execute; override;
    procedure LogProc(Message: String; EventType: DWord = 1; Category: Integer = 0; ID: Integer = 0); virtual;
    procedure OnErrorProc(Error : Cardinal); virtual;
    procedure OnWriteEndedProc; virtual;
    procedure WNDHandlerProc(var Message: TMessage); virtual;
   public
    constructor Create(CreateSuspended: Boolean); reintroduce;
    destructor  Destroy; override;
    function WriteBuff(Buff : Pointer; BuffSize : Cardinal):Boolean ; virtual;
    procedure SetWaiteEvent;
    property Terminated;
    property Handle                   : THandle read FHandle write SetHandle;
    property IsUseMessageQueue        : Boolean read FIsUseMessageQueue write FIsUseMessageQueue default True; // использовать или нет очередь сообщений приложения для передачи данных
    property StartEventHandle         : THandle read FStartEventHandle write SetStartEventHandle;
    property StopEventHandle          : THandle read FStopEventHandle write SetStopEventHandle;
    property TimeOutWaiting           : Cardinal read FTimeOutWaiting write SetTimeOutWaiting default 1000;
    property IniBufferSize            : Cardinal read GetBufferSize write SetBufferSize default 8192;
    property LastWriteError           : Cardinal read GetLastWriteError;
    property NotifyOnWriteTermination : Boolean read FNotifyOnTermination write SetNotifyOnTermination default False;
    property OnLogEvent               : TEventlogMsgProc read FOnLogEvent write FOnLogEvent;
    property OnWriteError             : TNotifyEvent read FOnWriteError write FOnWriteError;
    property OnWriteEnded             : TNotifyEvent read FOnWriteEnded write FOnWriteEnded;
   end;

{$ENDIF}

implementation

uses SysUtils;

{$IFDEF WINDOWS}

{ TNPCCOMWriteThread }

constructor TNPCWriteThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FIsUseMessageQueue:= True;
  FCriticalSection  := TCriticalSection.Create;
  FHandle           := INVALID_HANDLE_VALUE;
  FStartEventHandle := INVALID_HANDLE_VALUE;
  FStopEventHandle  := INVALID_HANDLE_VALUE;
  FBufferPreparedEv := CreateEvent(nil,False,False,nil);
  FIniBufferSize    := 8192;
  FBuffer           := AllocMem(FIniBufferSize);
  FBufferSize       := 0;
  FTimeOutWaiting   := 1000;
  FNotifyOnTermination := False;
  FWNDHandle := AllocateHWnd(WNDHandlerProc);
  if FWNDHandle=0 then FWNDHandle:=INVALID_HANDLE_VALUE;
end;

destructor TNPCWriteThread.Destroy;
begin
  inherited;
  CloseHandle(FBufferPreparedEv);
  FCriticalSection.Free;
  FreeMem(FBuffer);
  if FWNDHandle<>INVALID_HANDLE_VALUE then DeallocateHWnd(FWNDHandle);
end;

procedure TNPCWriteThread.Execute;
var Res       : Cardinal;
    Over      : OVERLAPPED;
    LastError,
    NumWriten, WaiteRes : Cardinal;
    WriteRes  : Boolean;
    EventHandle : THandle;
begin
  ZeroMemory(@Over,sizeof(Over));
  EventHandle:=CreateEvent(nil,True,False,nil);
  Over.hEvent:=EventHandle;
  if FStartEventHandle<>INVALID_HANDLE_VALUE then SetEvent(FStartEventHandle);
  try
   repeat
    if Terminated then Exit;
    if FHandle=INVALID_HANDLE_VALUE then // если не открыт порт
     begin
      if Terminated then Exit;
      Sleep(FTimeOutWaiting);
      Continue;
     end;
    Res:=WaitForSingleObject(FBufferPreparedEv,FTimeOutWaiting);
    if Terminated then Exit;
    case Res of
     WAIT_OBJECT_0 : begin // в буфере появились данные
                      if Terminated then Exit;
                      ZeroMemory(@Over,sizeof(Over)-sizeof(EventHandle));
                      Over.hEvent:=EventHandle;
                      FCriticalSection.Enter;
                      try
                       WriteRes:=WriteFile(FHandle,FBuffer^,FBufferSize,NumWriten,@Over);
                      finally
                       FCriticalSection.Leave;
                      end;
                        if WriteRes then
                         begin // запись произведена без ошибок - не должно работать при асинхронной записи
                          if FNotifyOnTermination then
                           begin
                            if not GetOverlappedResult(FHandle,Over,NumWriten,False)then // есть ли необходимость???
                             begin
                              LastError:=GetLastError; // ошибка получения результата операции
                              if LastError<>ERROR_IO_PENDING then OnErrorProc(LastError);
                              if Terminated then Exit;
                             end;
                            OnWriteEndedProc;
                            ResetEvent(EventHandle);
                            if Terminated then Exit;
                           end;
                         end
                        else
                         begin
                          if Terminated then Exit;
                          LastError:=GetLastError;
                          case LastError of
                            ERROR_IO_PENDING : begin // ждем окончания операции записи
                                                if FNotifyOnTermination then // если оповещение об окончание записи производится из потока записи а не из потока событий порта
                                                 begin
                                                  if Terminated then Exit;
                                                  while True do
                                                   begin
                                                    WaiteRes := WaitForSingleObject(EventHandle,FTimeOutWaiting);
                                                    case WaiteRes of
                                                     WAIT_TIMEOUT   :begin
                                                                      if Terminated then Exit;
                                                                      LogProc('WriteThread WAIT_TIMEOUT');
                                                                     end;
                                                     WAIT_OBJECT_0  :begin
                                                                      if Terminated then Exit;
                                                                      LogProc('WriteThread WAIT_OBJECT_0');
                                                                      Break;
                                                                     end;
                                                     WAIT_FAILED    :begin
                                                                      LastError:=GetLastError;
                                                                      LogProc('WriteThread WAIT_FAILED');
                                                                      OnErrorProc(LastError);
                                                                      if Terminated then Exit;
                                                                      Break;
                                                                     end;
                                                     WAIT_ABANDONED :begin
                                                                      LastError:=GetLastError;
                                                                      LogProc('WriteThread WAIT_ABANDONED');
                                                                      OnErrorProc(LastError);
                                                                      if Terminated then Exit;
                                                                     end;
                                                    end;
                                                    if Terminated then Exit;
                                                   end;
                                                 // операция записи закончена
                                                  if not GetOverlappedResult(FHandle,Over,NumWriten,False)then // есть ли необходимость???
                                                   begin
                                                    LastError:=GetLastError; // ошибка получения результата операции
                                                    OnErrorProc(LastError);
                                                    ResetEvent(EventHandle);
                                                    if Terminated then Exit;
                                                   end;
                                                  OnWriteEndedProc;
                                                  ResetEvent(EventHandle);
                                                  if Terminated then Exit;
                                                 end;
                                               end;
                          else // ошибка записи в порт
                           OnErrorProc(LastError);
                           CancelIo(FHandle);
                           ResetEvent(EventHandle);
                           if Terminated then Exit;
                          end;
                         end;
                     end;
      WAIT_TIMEOUT  : begin // ничего не приходило вышло время ожидания
                       if Terminated then Exit;
                      end;
    else
     LastError:=GetLastError;// ошибка ожидания
     OnErrorProc(LastError);
     if Terminated then Exit;
    end;
   until Terminated;
  finally
   CloseHandle(EventHandle);
   if FStopEventHandle<>INVALID_HANDLE_VALUE then SetEvent(FStopEventHandle);
  end;
end;

function TNPCWriteThread.GetBufferSize: Cardinal;
begin
  Result:=FIniBufferSize;
end;

function TNPCWriteThread.GetLastWriteError: Cardinal;
begin
  Result:=FLastError;
end;

procedure TNPCWriteThread.LogProc(Message: String; EventType: DWord; Category, ID: Integer);
var TempMsgRec :PEventlogMsgRecord;
    Res : Boolean;
begin
  if FIsUseMessageQueue then
   begin
     TempMsgRec :=AllocMem(sizeof(TEventlogMsgRecord));
     TempMsgRec.Message   := PChar(Message);
     TempMsgRec.EventType := EventType;
     TempMsgRec.Category  := Category;
     TempMsgRec.ID        := ID;
     Res:=PostMessage(FWNDHandle,CM_ON_EVENT_MSG,Integer(TempMsgRec),0);
     if not Res then
      begin
       OnErrorProc(GetLastError);
       FreeMem(TempMsgRec);
      end;
   end
  else
   begin
     if Assigned(FOnLogEvent) then FOnLogEvent(Message,EventType,Category,ID);
   end;
end;

procedure TNPCWriteThread.OnErrorProc(Error: Cardinal);
begin
  if FIsUseMessageQueue then
   begin
     if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
     PostMessage(FWNDHandle,CM_ON_ERROR,Error,0);
   end
  else
   begin
    FLastError:= Error;
    if Assigned(FOnWriteError) then FOnWriteError(Self);
   end;
end;

procedure TNPCWriteThread.OnWriteEndedProc;
begin
  if not FNotifyOnTermination then Exit;
  if FIsUseMessageQueue then
   begin
     if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
     PostMessage(FWNDHandle,CM_ON_WRITE_ENDED,0,0);
   end
  else
   begin
    if Assigned(FOnWriteEnded) then FOnWriteEnded(Self);
   end;
end;

procedure TNPCWriteThread.SetBufferSize(const Value: Cardinal);
begin
  if FIniBufferSize=Value then Exit;
  FIniBufferSize := Value;
  FCriticalSection.Enter;
  try
   FreeMem(FBuffer);
   FBuffer:=AllocMem(FIniBufferSize);
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCWriteThread.SetHandle(const Value: THandle);
begin
  if FHandle = Value then Exit;
  FCriticalSection.Enter;
  try
   FHandle := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCWriteThread.SetNotifyOnTermination(const Value: Boolean);
begin
  if FNotifyOnTermination = Value then Exit;
  FCriticalSection.Enter;
  try
   FNotifyOnTermination := Value;
  finally
   FCriticalSection.Leave
  end;
end;

procedure TNPCWriteThread.SetStartEventHandle(const Value: THandle);
begin
  if FStartEventHandle = Value then Exit;
  FCriticalSection.Enter;
  try
   FStartEventHandle := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCWriteThread.SetStopEventHandle(const Value: THandle);
begin
  if FStopEventHandle = Value then Exit;
  FCriticalSection.Enter;
  try
   FStopEventHandle := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCWriteThread.SetTimeOutWaiting(const Value: Cardinal);
begin
  if FTimeOutWaiting = Value then Exit;
  FCriticalSection.Enter;
  try
   FTimeOutWaiting := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCWriteThread.SetWaiteEvent;
begin
 SetEvent(FBufferPreparedEv);
end;

procedure TNPCWriteThread.WNDHandlerProc(var Message: TMessage);
var TempMsgRec :PEventlogMsgRecord;
begin
  case Message.Msg of
   CM_ON_WRITE_ENDED : begin
                          if Assigned(FOnWriteEnded) then FOnWriteEnded(Self);
                       end;
   CM_ON_ERROR       : begin
                        //if FLastError=Cardinal(Message.WParam) then Exit;
                        FLastError:=Message.WParam;
                         if Assigned(FOnWriteError) then FOnWriteError(Self);
                       end;
   CM_ON_EVENT_MSG   : begin
                        if Message.WParam=0 then Exit;
                        TempMsgRec:=PEventlogMsgRecord(Message.WParam);
                        try
                          if Assigned(FOnLogEvent) then FOnLogEvent(StrPas(TempMsgRec.Message),TempMsgRec.EventType,TempMsgRec.Category,TempMsgRec.ID);
                        finally
                         FreeMem(TempMsgRec);
                        end;
                       end;
  else
   DefaultHandler(Message);
  end;
end;

function TNPCWriteThread.WriteBuff(Buff: Pointer; BuffSize: Cardinal): Boolean;
begin
  Result:=False;
  if (Buff=nil) or (BuffSize=0) then Exit;
  if BuffSize>FIniBufferSize then SetBufferSize(BuffSize);
  if FBuffer=nil then Exit;
  FCriticalSection.Enter;
  try
   ZeroMemory(FBuffer,FIniBufferSize);
   Move(Buff^,FBuffer^,BuffSize);
   FBufferSize:=BuffSize;
  finally
   FCriticalSection.Leave;
  end;
  SetEvent(FBufferPreparedEv);
  Result:=True;
end;

{$ENDIF}

end.