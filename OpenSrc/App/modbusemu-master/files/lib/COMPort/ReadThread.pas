unit ReadThread;

interface

uses {$IFDEF WINDOWS} Windows, Messages, {$ENDIF} Classes, SyncObjs, COMPortParamTypes;

type
   TNPCOMReadDataEventProc = procedure (Sender : TObject; const Buff : Pointer; const BuffSize : Cardinal) of object;

{$IFDEF WINDOWS}

   TNPCReadThread = class(TThread)
   private
    FCriticalSection  : TCriticalSection;        // критическая секция для доступа к данным потока
    FHandle           : THandle;                 // хэндл файла для записи данных
    FBuffer           : Pointer;                 // буфер для чтения данных
    FIniBufferSize    : Cardinal;                // размер инициализации буфера
    FStartEventHandle : THandle;                 // хэндл события старта потока
    FStopEventHandle  : THandle;                 // хэндл события остоновки потока
    FTimeOutWaiting   : Cardinal;                // таймаут цикла потока
    FLastError        : Cardinal;                // последняя ошибка
    FReciveDataEvent  : THandle;                 // хендл события для оповещения о приходе данных
    FOnLogEvent       : TEventlogMsgProc;        // внешняя процедура для записи в лог
    FOnReadError      : TNotifyEvent;            // внешний обработчик ошибок
    FOnReadEnded      : TNPCOMReadDataEventProc; // обработчик пришедших данных
    FWNDHandle        : HWND;
    FIsUseMessageQueue: Boolean;
    function  GetLastReadError: Cardinal;
    procedure SetHandle(const Value: THandle);
    procedure SetStartEventHandle(const Value: THandle);
    procedure SetStopEventHandle(const Value: THandle);
    procedure SetTimeOutWaiting(const Value: Cardinal);
    function  GetBufferSize: Cardinal;
    procedure SetBufferSize(const Value: Cardinal);
   protected
    procedure Execute; override;
    procedure LogProc(Message: String; EventType: DWord = 1; Category: Integer = 0; ID: Integer = 0); virtual;
    procedure OnErrorProc(Error : Cardinal); virtual;
    procedure OnReadEndedProc(Buff : Pointer; BuffSize : Cardinal);virtual;
    procedure WNDHandlerProc(var Message: TMessage); virtual;
   public
    constructor Create(CreateSuspended: Boolean); reintroduce;
    destructor  Destroy; override;
    procedure SetWaiteEvent;
    property Terminated;
    property IsUseMessageQueue     : Boolean read FIsUseMessageQueue write FIsUseMessageQueue default True; // использовать или нет очередь сообщений приложения для передачи данных
    property ReciveDataEventHandle : THandle read FReciveDataEvent;
    property LastReadError         : Cardinal read GetLastReadError;
    property Handle                : THandle read FHandle write SetHandle;
    property StartEventHandle      : THandle read FStartEventHandle write SetStartEventHandle;
    property StopEventHandle       : THandle read FStopEventHandle write SetStopEventHandle;
    property IniBufferSize         : Cardinal read GetBufferSize write SetBufferSize default 8192;
    property TimeOutWaiting        : Cardinal read FTimeOutWaiting write SetTimeOutWaiting default 1000;
    property OnLogEvent            : TEventlogMsgProc read FOnLogEvent write FOnLogEvent;
    property OnReadError           : TNotifyEvent read FOnReadError write FOnReadError;
    property OnReadEnded           : TNPCOMReadDataEventProc read FOnReadEnded write FOnReadEnded;
   end;

{$ENDIF}

implementation

uses SysUtils;

{$IFDEF WINDOWS}

{ TNPCCOMReadThread }

constructor TNPCReadThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FLastError               := 0;
  FIsUseMessageQueue       := True;
  FCriticalSection         := TCriticalSection.Create;
  FHandle                  := INVALID_HANDLE_VALUE;
  FStartEventHandle        := INVALID_HANDLE_VALUE;
  FStopEventHandle         := INVALID_HANDLE_VALUE;
  FTimeOutWaiting          := 1000;
  FReciveDataEvent         := CreateEvent(nil,False,False,nil);
  if FReciveDataEvent=0 then FReciveDataEvent:=INVALID_HANDLE_VALUE;
  FIniBufferSize           := 8192;
  FBuffer                  := AllocMem(FIniBufferSize);
  ZeroMemory(FBuffer,FIniBufferSize);
  FWNDHandle := AllocateHWnd(WNDHandlerProc);
  if FWNDHandle=0 then FWNDHandle:=INVALID_HANDLE_VALUE;
end;

destructor TNPCReadThread.Destroy;
begin
  inherited;
  FCriticalSection.Free;
  CloseHandle(FReciveDataEvent);
  if FWNDHandle<>INVALID_HANDLE_VALUE then DeallocateHWnd(FWNDHandle);
end;

procedure TNPCReadThread.Execute;
var Res       : Cardinal;
    Over      : OVERLAPPED;
    LastError : Cardinal;
    ReadRes   : Boolean;
    NumReaden : Cardinal;
    EventHandle : THandle;

 procedure DoGetData;
 begin
  //ждем окончания операции
  ReadRes:=GetOverlappedResult(FHandle,Over,NumReaden,True);
  if ReadRes then
   begin
    OnReadEndedProc(FBuffer,NumReaden);
   end
  else
   begin
    LastError:=GetLastError;
    OnErrorProc(LastError);
    CancelIo(FHandle);
   end;
  ResetEvent(Over.hEvent);
 end;

begin
  ZeroMemory(@Over,sizeof(Over));
  EventHandle:=CreateEvent(nil,True,False,nil);
  Over.hEvent:=EventHandle;
  if FStartEventHandle<>INVALID_HANDLE_VALUE then SetEvent(FStartEventHandle);
  try
   repeat
    if Terminated then Exit;
    if FHandle=INVALID_HANDLE_VALUE then
     begin
      if Terminated then Exit;
      Sleep(FTimeOutWaiting);
      Continue;
     end;
    Res:=WaitForSingleObject(FReciveDataEvent,FTimeOutWaiting);
    if Terminated then Exit;
    case Res of
     WAIT_OBJECT_0 : begin // оповестили о приходе новых данных
                      if Terminated then Exit;
                      FCriticalSection.Enter;
                      try
                       ZeroMemory(FBuffer,FIniBufferSize);
                       ZeroMemory(@Over,sizeof(Over)-sizeof(EventHandle));
                       Over.hEvent:=EventHandle;
                       ReadRes:=ReadFile(FHandle,FBuffer^,FIniBufferSize,NumReaden,@Over);
                       LastError:=GetLastError;
                       case LastError of
                        ERROR_IO_PENDING : begin
                                            while WaitForSingleObject(Over.hEvent,FTimeOutWaiting)=WAIT_TIMEOUT do
                                             begin
                                              if Terminated then Exit;
                                             end;
                                            DoGetData;
                                            if Terminated then Exit;
                                           end;
                       else
                        OnErrorProc(LastError);
                        CancelIo(FHandle);
                        ResetEvent(EventHandle);
                        if Terminated then Exit;
                       end;
                      finally
                       FCriticalSection.Leave;
                      end;
                     end;
     WAIT_TIMEOUT  : begin // таймаут ожидания прихода данных
                      if Terminated then Exit;
                     end;
    else // ошибка ожидания приходаданных
     LastError:=GetLastError;
     OnErrorProc(LastError);
     if Terminated then Exit;
    end;
   until Terminated;
  finally
   CloseHandle(EventHandle);
   if FStopEventHandle<>INVALID_HANDLE_VALUE then SetEvent(FStopEventHandle);
  end;
end;

function TNPCReadThread.GetBufferSize: Cardinal;
begin
 Result:=FIniBufferSize;
end;

function TNPCReadThread.GetLastReadError: Cardinal;
begin
  Result:=FLastError;
end;

procedure TNPCReadThread.LogProc(Message: String; EventType: DWord; Category, ID: Integer);
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

procedure TNPCReadThread.OnErrorProc(Error: Cardinal);
begin
  if FIsUseMessageQueue then
   begin
     if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
     PostMessage(FWNDHandle,CM_ON_ERROR,Error,0);
   end
  else
   begin
    FLastError:= Error;
     if Assigned(FOnReadError) then FOnReadError(Self);
   end;
end;

procedure TNPCReadThread.OnReadEndedProc(Buff: Pointer; BuffSize: Cardinal);
var TempBuff : Pointer;
    Res : Boolean;
begin
  if BuffSize=0 then Exit;
  if FIsUseMessageQueue then
   begin
     if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
     TempBuff :=AllocMem(BuffSize);
     if TempBuff=nil then Exit;
     Move(Buff^,TempBuff^,BuffSize);
     Res:=PostMessage(FWNDHandle,CM_ON_READ_ENDED,Integer(TempBuff),BuffSize);
     if not Res then
      begin
       OnErrorProc(GetLastError);
       { освобождается только если при отправке сообщения произошла ошибка,
        иначе память освобождается в процедуре обработки сообщения
       }
       FreeMem(TempBuff);
      end;
   end
  else
   begin
     if Assigned(FOnReadEnded) then FOnReadEnded(Self,Buff,BuffSize);
   end;
end;

procedure TNPCReadThread.SetBufferSize(const Value: Cardinal);
begin
  if FIniBufferSize=Value then Exit;
  FIniBufferSize:=Value;
  FCriticalSection.Enter;
  try
   FreeMem(FBuffer);
   FBuffer:=AllocMem(FIniBufferSize);
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCReadThread.SetHandle(const Value: THandle);
begin
  if FHandle = Value then Exit;
  FCriticalSection.Enter;
  try
   FHandle := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCReadThread.SetStartEventHandle(const Value: THandle);
begin
  if FStartEventHandle = Value then Exit;
  FCriticalSection.Enter;
  try
   FStartEventHandle := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCReadThread.SetStopEventHandle(const Value: THandle);
begin
  if FStopEventHandle = Value then Exit;
  FCriticalSection.Enter;
  try
   FStopEventHandle := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCReadThread.SetTimeOutWaiting(const Value: Cardinal);
begin
  if FTimeOutWaiting = Value then Exit;
  FCriticalSection.Enter;
  try
   FTimeOutWaiting := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCReadThread.SetWaiteEvent;
begin
  if (FReciveDataEvent=0) or (FReciveDataEvent=INVALID_HANDLE_VALUE) then Exit;
  SetEvent(FReciveDataEvent);
end;

procedure TNPCReadThread.WNDHandlerProc(var Message: TMessage);
var TempMsgRec :PEventlogMsgRecord;
begin
  case Message.Msg of
   CM_ON_READ_ENDED : begin
                       try
                         if Assigned(FOnReadEnded) then FOnReadEnded(Self,Pointer(Message.WParam),Message.LParam);
                       finally
                        FreeMem(Pointer(Message.WParam));
                       end;
                      end;
   CM_ON_ERROR      : begin
                       if FLastError=Cardinal(Message.WParam) then Exit;
                       FLastError:=Message.WParam;
                       if Assigned(FOnReadError) then FOnReadError(Self);
                      end;
   CM_ON_EVENT_MSG  : begin
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

{$ENDIF}

end.