unit COMEventsThread;

interface

uses {$IFDEF WINDOWS} Windows, Messages, {$ENDIF} Classes, SyncObjs, COMPortParamTypes, COMPortResStr;

{$IFDEF WINDOWS}
const
   DefCOMEventFlags = EV_RXCHAR + EV_TXEMPTY + EV_BREAK + EV_ERR;
{$ENDIF}

type
   TNPCEventFlag = (efRXCHAR=1,efRXFLAG=2,efTXEMPTY=4,efCTS=8,efDSR=$10,efRLSD=$20,
                    efBREAK=$40,efERR=$80,efRING=$100,efPERR=$200,efRX80FULL=$400,
                    efEVENT1=$800,efEVENT2=$1000);

{$IFDEF WINDOWS}

   TNPCCOMEventsThread = class(TThread)
   private
    FCriticalSection   : TCriticalSection;        // критическая секция для доступа к данным потока
    FHandle            : THandle;                 // хэндл файла для записи данных
    FEventMask         : Cardinal;                // маска контролируемых событий
    FStartEventHandle  : THandle;                 // хэндл события старта потока
    FStopEventHandle   : THandle;                 // хэндл события остоновки потока
    FTimeOutWaiting    : Cardinal;                // таймаут цикла потока
    FLastError         : Cardinal;                // последняя ошибка
    FWNDHandle         : HWND;
    FOnLogEvent        : TEventlogMsgProc;        // внешняя процедура для записи в лог
    FOnError           : TNotifyEvent;            // внешний обработчик ошибок
    FOnRXChar          : TNotifyEvent;            // внешние обработчики событий СОМ порт
    FOnTXEmpty         : TNotifyEvent;
    FOnCTS             : TNotifyEvent;
    FOnDSR             : TNotifyEvent;
    FOnRLSD            : TNotifyEvent;
    FOnBreak           : TNotifyEvent;
    FOnErr             : TNotifyEvent;
    FOnRing            : TNotifyEvent;
    FOnPErr            : TNotifyEvent;
    FOnRx80Full        : TNotifyEvent;
    FOnEvent1          : TNotifyEvent;
    FOnEvent2          : TNotifyEvent;
    FIsUseMessageQueue: Boolean;
    procedure SetHandle(const Value: THandle);
    procedure SetStartEventHandle(const Value: THandle);
    procedure SetStopEventHandle(const Value: THandle);
    procedure SetTimeOutWaiting(const Value: Cardinal);
    function  GetLastCOMError: Cardinal;
    function  GetCOMEventMask: Cardinal;
    procedure SetCOMEventMask(const Value: Cardinal);
   protected
    procedure Execute; override;
    procedure LogProc(Message: String; EventType: DWord = 1; Category: Integer = 0; ID: Integer = 0); virtual;
    procedure OnErrorProc(Error : Cardinal); virtual;
    procedure DoRXCharEvent; virtual;
    procedure DoTXEmptyEvent; virtual;
    procedure DoCtsEvent; virtual;
    procedure DoDSREvent; virtual;
    procedure DoRLSDEvent; virtual;
    procedure DoBreakEvent; virtual;
    procedure DoErrEvent; virtual;
    procedure DoRingEvent; virtual;
    procedure DoPErrEvent; virtual;
    procedure DoRX80FullEvent; virtual;
    procedure DoEvent1Event; virtual;
    procedure DoEvent2Event; virtual;
    procedure WNDHandlerProc(var Message: TMessage); virtual;
   public
    constructor Create(CreateSuspended: Boolean); reintroduce;
    destructor  Destroy; override;
    property Terminated;
    property COMHandle        : THandle read FHandle write SetHandle;
    property IsUseMessageQueue: Boolean read FIsUseMessageQueue write FIsUseMessageQueue default True; // использовать или нет очередь сообщений приложения для передачи данных
    property EventMask        : Cardinal read GetCOMEventMask write SetCOMEventMask default DefCOMEventFlags;
    property StartEventHandle : THandle read FStartEventHandle write SetStartEventHandle;
    property StopEventHandle  : THandle read FStopEventHandle write SetStopEventHandle;
    property TimeOutWaiting   : Cardinal read FTimeOutWaiting write SetTimeOutWaiting default 1000;
    property LastError        : Cardinal read GetLastCOMError;
    property OnLogEvent       : TEventlogMsgProc read FOnLogEvent write FOnLogEvent;
    property OnError          : TNotifyEvent read FOnError write FOnError;
    property OnRXCharEvent    : TNotifyEvent read FOnRXChar write FOnRXChar;
    property OnTXEmptyEvent   : TNotifyEvent read FOnTXEmpty write FOnTXEmpty;
    property OnCTSEvent       : TNotifyEvent read FOnCTS write FOnCTS;
    property OnDSREvent       : TNotifyEvent read FOnDSR write FOnDSR;
    property OnRLSDEvent      : TNotifyEvent read FOnRLSD write FOnRLSD;
    property OnBreakEvent     : TNotifyEvent read FOnBreak write FOnBreak;
    property OnErrEvent       : TNotifyEvent read FOnErr write FOnErr;
    property OnRingEvent      : TNotifyEvent read FOnRing write FOnRing;
    property OnPErrEvent      : TNotifyEvent read FOnPErr write FOnPErr;
    property OnRx80FullEvent  : TNotifyEvent read FOnRx80Full write FOnRx80Full;
    property OnEvent1Event    : TNotifyEvent read FOnEvent1 write FOnEvent1;
    property OnEvent2Event    : TNotifyEvent read FOnEvent2 write FOnEvent2;
   end;

{$ENDIF}

implementation

uses SysUtils;

{$IFDEF WINDOWS}

{ TNPCCOMEventsThread }

constructor TNPCCOMEventsThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FIsUseMessageQueue:= True;
  FLastError        := 0;
  FCriticalSection  := TCriticalSection.Create;
  FHandle           := INVALID_HANDLE_VALUE;
  FStartEventHandle := INVALID_HANDLE_VALUE;
  FStopEventHandle  := INVALID_HANDLE_VALUE;
  FTimeOutWaiting   := 1000;
  FEventMask        := DefCOMEventFlags;
  FWNDHandle := AllocateHWnd(WNDHandlerProc);
  if FWNDHandle=0 then FWNDHandle:=INVALID_HANDLE_VALUE;
end;

destructor TNPCCOMEventsThread.Destroy;
begin
  inherited;
  FCriticalSection.Free;
  if FWNDHandle<>INVALID_HANDLE_VALUE then DeallocateHWnd(FWNDHandle);
end;

procedure TNPCCOMEventsThread.DoBreakEvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_BreakEvent,0,0);
   end
  else
   begin
     if Assigned(FOnBreak) then FOnBreak(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoCtsEvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_CtsEvent,0,0);
   end
  else
   begin
     if Assigned(FOnCTS) then FOnCTS(Self);
   end;  
end;

procedure TNPCCOMEventsThread.DoDSREvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_DSREvent,0,0);
   end
  else
   begin
     if Assigned(FOnDSR) then FOnDSR(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoErrEvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_ErrEvent,0,0);
   end
  else
   begin
     if Assigned(FOnErr) then FOnErr(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoEvent1Event;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_Event1Event,0,0);
   end
  else
   begin
     if Assigned(FOnEvent1) then FOnEvent1(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoEvent2Event;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_Event2Event,0,0);
   end
  else
   begin
     if Assigned(FOnEvent2) then FOnEvent2(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoPErrEvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_PErrEvent,0,0);
   end
  else
   begin
     if Assigned(FOnPErr) then FOnPErr(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoRingEvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_RingEvent,0,0);
   end
  else
   begin
     if Assigned(FOnRing) then FOnRing(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoRLSDEvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_RLSDEvent,0,0);
   end
  else
   begin
     if Assigned(FOnRLSD) then FOnRLSD(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoRX80FullEvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_RX80FullEvent,0,0);
   end
  else
   begin
     if Assigned(FOnRx80Full) then FOnRx80Full(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoRXCharEvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_RXCharEvent,0,0);
   end
  else
   begin
     if Assigned(FOnRXChar) then FOnRXChar(Self);
   end;
end;

procedure TNPCCOMEventsThread.DoTXEmptyEvent;
begin
  if FIsUseMessageQueue then
   begin
    if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
    PostMessage(FWNDHandle,CM_ON_TXEmptyEvent,0,0);
   end
  else
   begin
     if Assigned(FOnTXEmpty) then FOnTXEmpty(Self);
   end;
end;

procedure TNPCCOMEventsThread.Execute;
var LastError, CurrentMask: Cardinal;
    Res  : Boolean;
    Over : TOverlapped;
    EventHandle : THandle;
   procedure SetCurrentMask;
   begin
    Res := GetCommMask(FHandle,CurrentMask); // получаем текущую маску
    if not Res then
     begin
      OnErrorProc(GetLastError);
      Exit;
     end;
    FCriticalSection.Enter;
    try
     if FEventMask<>CurrentMask then // устанавливаем маску на события в соответствии с заданной пользователем
      begin
       Res := SetCommMask(FHandle,FEventMask);
       if not Res then OnErrorProc(GetLastError);
      end;
    finally
     FCriticalSection.Leave;
    end;
   end;

  procedure DoEvents;
  begin
    { Any Character received }
    if (CurrentMask and EV_RXCHAR) = EV_RXCHAR then
     begin
      DoRXCharEvent;
     end;
    //EV_TXEMPTY = 4;       { Transmitt Queue Empty }
    if (CurrentMask and EV_TXEMPTY) = EV_TXEMPTY then
     begin
      DoTXEmptyEvent;
     end;
    //EV_CTS = 8;           { CTS changed state }
    if (CurrentMask and EV_CTS) = EV_CTS then
     begin
      DoCtsEvent
     end;
    //EV_DSR = $10;         { DSR changed state }
    if (CurrentMask and EV_DSR) = EV_DSR then
     begin
      DoDSREvent;
     end;
    //EV_RLSD = $20;        { RLSD changed state }
    if (CurrentMask and EV_RLSD) = EV_RLSD then
     begin
      DoRLSDEvent;
     end;
    //EV_BREAK = $40;       { BREAK received }
    if (CurrentMask and EV_BREAK) = EV_BREAK then
     begin
      DoBreakEvent;
     end;
    //EV_ERR = $80;         { Line status error occurred }
    if (CurrentMask and EV_ERR) = EV_ERR then
     begin
      DoErrEvent;
     end;
    //EV_RING = $100;       { Ring signal detected }
    if (CurrentMask and EV_RING) = EV_RING then
     begin
      DoRingEvent;
     end;
    //EV_PERR = $200;       { Printer error occured }
    if (CurrentMask and EV_PERR) = EV_PERR then
     begin
      DoPErrEvent;
     end;
    //EV_RX80FULL = $400;   { Receive buffer is 80 percent full }
    if (CurrentMask and EV_RX80FULL) = EV_RX80FULL then
     begin
      DoRX80FullEvent;
     end;
    //EV_EVENT1 = $800;     { Provider specific event 1 }
    if (CurrentMask and EV_EVENT1) = EV_EVENT1 then
     begin
      DoEvent1Event;
     end;
    //EV_EVENT2 = $1000;    { Provider specific event 2 }
    if (CurrentMask and EV_EVENT2) = EV_EVENT2 then
     begin
      DoEvent2Event;
     end;
  end;
begin
  ZeroMemory(@Over,sizeof(Over));
  EventHandle:=CreateEvent(nil,True,False,nil);
  Over.hEvent := EventHandle;
  if FHandle<>INVALID_HANDLE_VALUE then
    begin
     FCriticalSection.Enter;
     try
      Res := SetCommMask(FHandle,FEventMask);
      if not Res then OnErrorProc(GetLastError);
     finally
      FCriticalSection.Leave;
     end;
    end;
  if FStartEventHandle<>INVALID_HANDLE_VALUE then SetEvent(FStartEventHandle);
  try
   repeat
    if FHandle=INVALID_HANDLE_VALUE then // не установлен хэндл порта
     begin
      Sleep(FTimeOutWaiting);
      if Terminated then Exit;
      Continue;
     end;
    if Terminated then Exit;
    CurrentMask:=0;
    ZeroMemory(@Over,sizeof(Over)-sizeof(EventHandle));
    Over.hEvent:=EventHandle;
    Res:=WaitCommEvent(FHandle,CurrentMask,@Over);
    if Terminated then Exit;
    if Res then
     begin
      DoEvents;
      if Terminated then Exit;
     end
    else
     begin
      LastError:=GetLastError;
      case LastError of
       ERROR_IO_PENDING : begin
                           while WaitForSingleObject(EventHandle,FTimeOutWaiting)=WAIT_TIMEOUT do
                            begin
                             if Terminated then Exit;
                            end;
                           if Terminated then Exit;
                           DoEvents;
                           if Terminated then Exit;
                          end;
      else
       OnErrorProc(LastError);
       Sleep(FTimeOutWaiting);
       ResetEvent(EventHandle);
       if Terminated then Exit;
      end;
     end;
   until Terminated;
  finally
   CloseHandle(EventHandle);
   if FStopEventHandle<>INVALID_HANDLE_VALUE then SetEvent(FStopEventHandle);
  end;
end;

function TNPCCOMEventsThread.GetCOMEventMask: Cardinal;
begin
  FCriticalSection.Enter;
  try
   Result:=FEventMask;
  finally
   FCriticalSection.Leave;
  end;
end;

function TNPCCOMEventsThread.GetLastCOMError: Cardinal;
begin
  FCriticalSection.Enter;
  try
   Result:=FLastError;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCCOMEventsThread.LogProc(Message: String; EventType: DWord; Category, ID: Integer);
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

procedure TNPCCOMEventsThread.OnErrorProc(Error: Cardinal);
begin
  if FIsUseMessageQueue then
   begin
     if FWNDHandle=INVALID_HANDLE_VALUE then Exit;
     PostMessage(FWNDHandle,CM_ON_ERROR,Error,0);
   end
  else
   begin
    FLastError:=Error;
     if Assigned(FOnError) then FOnError(Self);
   end;
end;

procedure TNPCCOMEventsThread.SetCOMEventMask(const Value: Cardinal);
var Res : Boolean;
begin
  if Value=FEventMask then Exit;
  FCriticalSection.Enter;
  try
   FEventMask:=Value;
   if FHandle<>INVALID_HANDLE_VALUE then
    begin
     Res := SetCommMask(FHandle,FEventMask);
     if not Res then OnErrorProc(GetLastError);
    end
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCCOMEventsThread.SetHandle(const Value: THandle);
begin
  if FHandle = Value then Exit;
  FCriticalSection.Enter;
  try
   FHandle := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCCOMEventsThread.SetStartEventHandle(const Value: THandle);
begin
  if FStartEventHandle = Value then Exit;
  FCriticalSection.Enter;
  try
   FStartEventHandle := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCCOMEventsThread.SetStopEventHandle(const Value: THandle);
begin
  if FStopEventHandle = Value then Exit;
  FCriticalSection.Enter;
  try
   FStopEventHandle := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCCOMEventsThread.SetTimeOutWaiting(const Value: Cardinal);
begin
  if FTimeOutWaiting = Value then Exit;
  FCriticalSection.Enter;
  try
   FTimeOutWaiting := Value;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TNPCCOMEventsThread.WNDHandlerProc(var Message: TMessage);
var TempMsgRec :PEventlogMsgRecord;
begin
  case Message.Msg of
   CM_ON_ERROR      : begin
                       if FLastError=Cardinal(Message.WParam) then Exit;
                       FLastError:=Message.WParam;
                        if Assigned(FOnError) then FOnError(Self);
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
   CM_ON_RXCharEvent   : begin
                           if Assigned(FOnRXChar) then FOnRXChar(Self);
                         end;
   CM_ON_TXEmptyEvent  : begin
                           if Assigned(FOnTXEmpty) then FOnTXEmpty(Self);
                         end;
   CM_ON_CtsEvent      : begin
                           if Assigned(FOnCTS) then FOnCTS(Self);
                         end;
   CM_ON_DSREvent      : begin
                           if Assigned(FOnDSR) then FOnDSR(Self);
                         end;
   CM_ON_RLSDEvent     : begin
                           if Assigned(FOnRLSD) then FOnRLSD(Self);
                         end;
   CM_ON_BreakEvent    : begin
                           if Assigned(FOnBreak) then FOnBreak(Self);
                         end;
   CM_ON_ErrEvent      : begin
                           if Assigned(FOnErr) then FOnErr(Self);
                         end;
   CM_ON_RingEvent     : begin
                           if Assigned(FOnRing) then FOnRing(Self);
                         end;
   CM_ON_PErrEvent     : begin
                           if Assigned(FOnPErr) then FOnPErr(Self);
                         end;
   CM_ON_RX80FullEvent : begin
                           if Assigned(FOnRx80Full) then FOnRx80Full(Self);
                         end;
   CM_ON_Event1Event   : begin
                           if Assigned(FOnEvent1) then FOnEvent1(Self);
                         end;
   CM_ON_Event2Event   : begin
                           if Assigned(FOnEvent2) then FOnEvent2(Self);
                         end;
  else
   DefaultHandler(Message);
  end;
end;

{$ENDIF}

end.
