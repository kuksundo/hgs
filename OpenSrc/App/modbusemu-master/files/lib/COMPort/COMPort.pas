unit COMPort;

interface

uses {$IFDEF WINDOWS} Windows,{$ENDIF} Classes,
     WriteThread, ReadThread, COMEventsThread, TimeTrigger,
     COMPortParamTypes, COMPortResStr;

{$IFDEF WINDOWS}

type
  TNPCCustomCOMPort = class(TComponent)
  private
   FCOMNumber                : Byte;                   // номер порта
   FActive                   : Boolean;                // флаг активности порта
   FRaiseExceptions          : Boolean;                // возбуждать или нет исключения при операциях с портом
   FOnLogEvent               : TEventlogMsgProc;       // ссылка на процедуру записи в лог
   FOnErrorEvent             : TCOMErrrorEventProc;    // обработчик ошибок порта и компонента
   FOnWriteTimeOut           : TNotifyEvent;           // обработчик таймаута записи данных
   FOnWriteTriggerCocked     : TNotifyEvent;           // тригер записи взведен
   FOnWriteTriggerDischarged : TNotifyEvent;           // тригер записи сброшен
   FOnWriteEnded             : TNotifyEvent;           // обработчик события окончания записи
   FOnReciveDataTimeOut      : TNotifyEvent;           // обработчик события таймаута получения ответа
   FOnReadTriggerCocked      : TNotifyEvent;           // тригер чтения взведен
   FOnReadTriggerDischarged  : TNotifyEvent;           // тригер чтения сброшен
   FOnReadEnded              : TNPCOMReadDataEventProc;// обработчик события получения данных
   FOnBreakEvent             : TNotifyEvent;           // обработчик события разрыва линии обнаруживаемый железом порта
   FOnCTSEvent               : TNotifyEvent;
   FOnDSREvent               : TNotifyEvent;
   FOnRLSDEvent              : TNotifyEvent;
   FOnRingEvent              : TNotifyEvent;
   FOnPErrEvent              : TNotifyEvent;
   FOnRx80FullEvent          : TNotifyEvent;
   FOnEvent1Event            : TNotifyEvent;
   FOnEvent2Event            : TNotifyEvent;
   FOnOpenEvent              : TNotifyEvent;
   FOnCloseEvent             : TNotifyEvent;
   FIsUseMessageQueue        : Boolean;               // использовать или нет очередь сообщений приложения для передачи данных
   procedure SetActive(const Value: Boolean);
   procedure SetComNumber(const Value: Byte);
   function  GetCurrentRxQueue: DWORD;
   function  GetCurrentTxQueue: DWORD;
   function  GetMaxBaud: DWORD;
   function  GetMaxRxQueue: DWORD;
   function  GetMaxTxQueue: DWORD;
   function  GetProvCapabilities: DWORD;
   function  GetProvSubType: DWORD;
   function  GetServiceMask: DWORD;
   function  GetSettableBaud: DWORD;
   function  GetSettableData: Word;
   function  GetSettableParams: DWORD;
   function  GetSettableStopParity: Word;
   function  GetReadIntervalTimeout: Cardinal;
   function  GetReadTotalTimeoutConstant: Cardinal;
   function  GetReadTotalTimeoutMultiplier: Cardinal;
   function  GetWriteTotalTimeoutConstant: Cardinal;
   function  GetWriteTotalTimeoutMultiplier: Cardinal;
   function  GetBaudRate: TComPortBaudRate;
   function  GetByteSize: TComPortDataBits;
   function  GetEofChar: Char;
   function  GetErrorChar: Char;
   function  GetEvtChar: Char;
   function  GetFlags: Cardinal;
   function  GetInBuffSize: Cardinal;
   function  GetOutBuffSize: Cardinal;
   function  GetParity: TComPortParity;
   function  GetStopBits: TComPortStopBits;
   function  GetXoffChar: Char;
   function  GetXoffLim: Word;
   function  GetXonChar: Char;
   function  GetXonLim: Word;
   function  GetReadTriggerAutoResetTrigger: Boolean;
   function  GetReadTriggerCocked: Boolean;
   function  GetReadTriggerHandleTimeOut: Boolean;
   function  GetReadTriggerID: Integer;
   function  GetReadTriggerWorkTime: Cardinal;
   function  GetWriteTriggerAutoResetTrigger: Boolean;
   function  GetWriteTriggerCocked: Boolean;
   function  GetWriteTriggerHandleTimeOut: Boolean;
   function  GetWriteTriggerID: Integer;
   function  GetWriteTriggerWorkTime: Cardinal;
   function  GetTimeOutWaitingCOMEvent: Cardinal;
   function  GetTimeOutWaitingReadEvent: Cardinal;
   function  GetTimeOutWaitingWriteEvent: Cardinal;
   procedure SetIsUseMessageQueue(const Value: Boolean);
  protected
   FCOMPortHandle            : THandle;               // хэндл СОМ порта
   FStartEventHandle         : THandle;               // хэндл события старта потока
   FStopEventHandle          : THandle;               // хэндл события остановки потока
   FWriteThread              : TNPCWriteThread;       // поток записи в порт
   FReadThread               : TNPCReadThread;        // поток чтения из порта
   FCOMEventThread           : TNPCCOMEventsThread;   // поток обработки событий порта
   FCommTimeouts             : TCommTimeouts;         // таймауты порта
   FTimeoutsPacketSet        : Boolean;               // флаг пакетной установки таймаутов через свойства
   FCommDCB                  : TDCB;                  // DCB порта - параметры
   FDCBPacketSet             : Boolean;               // флаг пакетной установки DCB через свойства
   FCommProp                 : TCommProp;             // параметры порта - размер буферов и т.д.
   FCommEvents               : TComPortEvFlags;       // флаги отслеживаемых событий
   FInBuffSize               : Cardinal;              // размер входного буфера
   FOutBuffSize              : Cardinal;              // размер выходного буфера
   FWriteTimeoutTrigger      : TNPCTimeTrigger;       // тригер ожидания окончания записи в порт
   FReciveDataTrigger        : TNPCTimeTrigger;       // тригер ожидания прихода ответа
   FCanCheckReceiveData      : Boolean;               // флаг возможности запуска тригера на ответ
   FTimeOutWaitingCOMEvent   : Cardinal;              // таймаут ожидания событий СОМ порта
   FTimeOutWaitingReadEvent  : Cardinal;              // таймаут ожидания событий чтения данных из порта в потоке чтения
   FTimeOutWaitingWriteEvent : Cardinal;              // таймаут ожидания событий записи данных в порт в потоке записи
   function  GetWriteTimeOut: Cardinal;
   procedure SetWriteTimeOut(const Value: Cardinal); virtual;
   function  GetReciveDataTimeOut: Cardinal;
   procedure SetReciveDataTimeOut(const Value: Cardinal); virtual;
   procedure SetReadIntervalTimeout(const Value: Cardinal); virtual;        // установка таймаутов порта
   procedure SetReadTotalTimeoutConstant(const Value: Cardinal); virtual;
   procedure SetReadTotalTimeoutMultiplier(const Value: Cardinal); virtual;
   procedure SetWriteTotalTimeoutConstant(const Value: Cardinal); virtual;
   procedure SetWriteTotalTimeoutMultiplier(const Value: Cardinal); virtual;
   function  GetComEvents: TComPortEvFlags; virtual;
   procedure SetGetComEvents(const Value: TComPortEvFlags); virtual;
   procedure SetBaudRate(const Value: TComPortBaudRate); virtual;
   procedure SetByteSize(const Value: TComPortDataBits); virtual;
   procedure SetEofChar(const Value: Char); virtual;
   procedure SetErrorChar(const Value: Char); virtual;
   procedure SetEvtChar(const Value: Char); virtual;
   procedure SetFlags(const Value: Cardinal); virtual;
   procedure SetInBuffSize(const Value: Cardinal); virtual;
   procedure SetOutBuffSize(const Value: Cardinal); virtual;
   procedure SetParity(const Value: TComPortParity); virtual;
   procedure SetStopBits(const Value: TComPortStopBits); virtual;
   procedure SetXoffChar(const Value: Char); virtual;
   procedure SetXoffLim(const Value: Word); virtual;
   procedure SetXonChar(const Value: Char); virtual;
   procedure SetXonLim(const Value: Word); virtual;
   procedure SetReadTriggerAutoResetTrigger(const Value: Boolean); virtual;
   procedure SetReadTriggerCocked(const Value: Boolean); virtual;
   procedure SetReadTriggerHandleTimeOut(const Value: Boolean); virtual;
   procedure SetReadTriggerID(const Value: Integer); virtual;
   procedure SetWriteTriggerAutoResetTrigger(const Value: Boolean); virtual;
   procedure SetWriteTriggerCocked(const Value: Boolean); virtual;
   procedure SetWriteTriggerHandleTimeOut(const Value: Boolean); virtual;
   procedure SetWriteTriggerID(const Value: Integer); virtual;
   procedure SetTimeOutWaitingCOMEvent(const Value: Cardinal); virtual;
   procedure SetTimeOutWaitingReadEvent(const Value: Cardinal); virtual;
   procedure SetTimeOutWaitingWriteEvent(const Value: Cardinal); virtual;
   function  CancelPortIO : Boolean; virtual;             // прерывание операций ввода/вывода для вызывающего потока
   function  OpenCOMPort : Boolean;  virtual;             // открытие порта
   function  CloseCOMPort : Boolean; virtual;             // закрытие порта
   procedure LogProc(Message: String; EventType: DWord = 1; Category: Integer = 0; ID: Integer = 0); virtual;
   procedure AplyComTimeouts; virtual;                    // установка таймаутов
   procedure AplyComDCB; virtual;                         // установка DCB
   procedure AplyComEvents; virtual;                      // установка маски отслеживаемых событий
   procedure AplyBuffSize; virtual;                       // установка размеров буферов
   procedure InitDefComDCB; virtual;                      // инициализация DCB
   procedure InitDefComTimeOuts; virtual;                 // инициализация таймаутов
   procedure InitDefComEvents; virtual;                   // инициализация маски отслеживаемых событий СОМ
   procedure SysErrorProc(Error : Cardinal;Mes : String = ''); virtual;     // обрабатываем ошибку
   procedure OnWriteErrorProc(Sender : TObject); virtual; // ошибка при записи в порт
   procedure OnReadErrorProc(Sender : TObject); virtual;  // ошибка чтения из порта
   procedure OnEventErrorProc(Sender : TObject); virtual; // ошибка при отслеживании событий порта порта
   procedure OnErrEventProc(Sender : TObject); virtual;   // событие ошибки в порту
   procedure OnComErrorProc(Sender : TObject; ErrorCategory : TComErrorCategory; ErrorCode : Cardinal); virtual;
   procedure OnWriteTriggerCockedProc(Sender : TObject); virtual;
   procedure OnWriteTriggerDischargedProc(Sender : TObject); virtual;
   procedure OnReadTriggerCockedProc(Sender : TObject); virtual;
   procedure OnReadTriggerDischargedProc(Sender : TObject); virtual;
   procedure OnWriteTimeOutProc(Sender : TObject); virtual;      // обработчик таймаута отправки данных
   procedure OnReciveDataTimeOutProc(Sender : TObject); virtual; // обработчик таймаута получения ответа данных
   procedure OnWriteEndedProc(Sender : TObject); virtual;        // окончание записи в порт
   procedure OnReadEndedProc(Sender : TObject; const Buff : Pointer; const BuffSize : Cardinal); virtual; // возврат результатат чтения из порта
   procedure OnRXCharEventProc(Sender : TObject); virtual;  // событие прихода данных
   procedure OnTXEmptyEventProc(Sender : TObject); virtual; // событие отправки данных
   procedure OnBreakEventProc(Sender : TObject); virtual;   // событие остановки линии
   procedure OnCTSEventProc(Sender : TObject); virtual;
   procedure OnDSREventProc(Sender : TObject); virtual;
   procedure OnRLSDEventProc(Sender : TObject); virtual;
   procedure OnRingEventProc(Sender : TObject); virtual;
   procedure OnPErrEventProc(Sender : TObject); virtual;
   procedure OnRx80FullEventProc(Sender : TObject); virtual;
   procedure OnEvent1EventProc(Sender : TObject); virtual;
   procedure OnEvent2EventProc(Sender : TObject); virtual;
   // параметры компонента
   property TimeOutWaitingReadEvent       : Cardinal read GetTimeOutWaitingReadEvent write SetTimeOutWaitingReadEvent default 1000;
   property TimeOutWaitingWriteEvent      : Cardinal read GetTimeOutWaitingWriteEvent write SetTimeOutWaitingWriteEvent default 1000;
   property TimeOutWaitingCOMEvent        : Cardinal read GetTimeOutWaitingCOMEvent write SetTimeOutWaitingCOMEvent default 1000;
   property RaiseExceptions               : Boolean read FRaiseExceptions write FRaiseExceptions default False;
   // параметры тригера записи
   property WriteTriggerCocked            : Boolean read GetWriteTriggerCocked write SetWriteTriggerCocked default False;
   property WriteTriggerAutoResetTrigger  : Boolean read GetWriteTriggerAutoResetTrigger write SetWriteTriggerAutoResetTrigger default False;
   property WriteTriggerHandleTimeOut     : Boolean read GetWriteTriggerHandleTimeOut write SetWriteTriggerHandleTimeOut default False;
   property WriteTriggerTriggerID         : Integer read GetWriteTriggerID write SetWriteTriggerID default 1;
   property WriteTriggerTriggerWorkTime   : Cardinal read GetWriteTriggerWorkTime;
   // параметры тригера чтения
   property ReadTriggerCocked             : Boolean read GetReadTriggerCocked write SetReadTriggerCocked default False;
   property ReadTriggerAutoResetTrigger   : Boolean read GetReadTriggerAutoResetTrigger write SetReadTriggerAutoResetTrigger default False;
   property ReadTriggerHandleTimeOut      : Boolean read GetReadTriggerHandleTimeOut write SetReadTriggerHandleTimeOut default False;
   property ReadTriggerTriggerID          : Integer read GetReadTriggerID write SetReadTriggerID default 1;
   property ReadTriggerTriggerWorkTime    : Cardinal read GetReadTriggerWorkTime;
   // параметры драйвера порта
   property ServiceMask                   : DWORD read GetServiceMask;
   property MaxTxQueue                    : DWORD read GetMaxTxQueue;
   property MaxRxQueue                    : DWORD read GetMaxRxQueue;
   property MaxBaud                       : DWORD read GetMaxBaud;
   property ProvSubType                   : DWORD read GetProvSubType;
   property ProvCapabilities              : DWORD read GetProvCapabilities;
   property SettableParams                : DWORD read GetSettableParams;
   property SettableBaud                  : DWORD read GetSettableBaud;
   property SettableData                  : Word read GetSettableData;
   property SettableStopParity            : Word read GetSettableStopParity;
   property CurrentTxQueue                : DWORD read GetCurrentTxQueue;
   property CurrentRxQueue                : DWORD read GetCurrentRxQueue;
   // DCB
   property Flags                         : Cardinal read GetFlags write SetFlags default $00000003;
   property XonLim                        : Word read GetXonLim write SetXonLim default 2048;
   property XoffLim                       : Word read GetXoffLim write SetXoffLim default 512;
   property XonChar                       : Char read GetXonChar write SetXonChar default #17;
   property XoffChar                      : Char read GetXoffChar write SetXoffChar default #19;
   property ErrorChar                     : Char read GetErrorChar write SetErrorChar default #0;
   property EofChar                       : Char read GetEofChar write SetEofChar default #0;
   property EvtChar                       : Char read GetEvtChar write SetEvtChar default #0;
   // Флаги отслеживаемых событий СОМ
   property ComEvents                     : TComPortEvFlags read GetComEvents write SetGetComEvents;
   // таймауты порта
   property ReadTotalTimeoutMultiplier    : Cardinal read GetReadTotalTimeoutMultiplier write SetReadTotalTimeoutMultiplier default 0;
   property ReadTotalTimeoutConstant      : Cardinal read GetReadTotalTimeoutConstant write SetReadTotalTimeoutConstant default 0;
   property WriteTotalTimeoutMultiplier   : Cardinal read GetWriteTotalTimeoutMultiplier write SetWriteTotalTimeoutMultiplier default 0;
   property WriteTotalTimeoutConstant     : Cardinal read GetWriteTotalTimeoutConstant write SetWriteTotalTimeoutConstant default 0;
   // события порта
   property OnCTSEvent                    : TNotifyEvent read FOnCTSEvent write FOnCTSEvent;
   property OnDSREvent                    : TNotifyEvent read FOnDSREvent write FOnDSREvent;
   property OnRLSDEvent                   : TNotifyEvent read FOnRLSDEvent write FOnRLSDEvent;
   property OnRingEvent                   : TNotifyEvent read FOnRingEvent write FOnRingEvent;
   property OnPErrEvent                   : TNotifyEvent read FOnPErrEvent write FOnPErrEvent;
   property OnRx80FullEvent               : TNotifyEvent read FOnRx80FullEvent write FOnRx80FullEvent;
   property OnEvent1Event                 : TNotifyEvent read FOnEvent1Event write FOnEvent1Event;
   property OnEvent2Event                 : TNotifyEvent read FOnEvent2Event write FOnEvent2Event;
   // события тригеров
   property OnWriteTriggerCocked          : TNotifyEvent read FOnWriteTriggerCocked write FOnWriteTriggerCocked;
   property OnWriteTriggerDischarged      : TNotifyEvent read FOnWriteTriggerDischarged write FOnWriteTriggerDischarged;
   property OnReadTriggerCocked           : TNotifyEvent read FOnReadTriggerCocked write FOnReadTriggerCocked;
   property OnReadTriggerDischarged       : TNotifyEvent read FOnReadTriggerDischarged write FOnReadTriggerDischarged;
  public
   constructor Create(Aowner : TComponent); override;
   destructor  Destroy; override;
   function  SetComTimeouts(Timeouts : TCommTimeouts): Boolean; virtual;   // установка таймаутов порта
   function  GetComPropertys : Boolean; virtual;                           // получение свойств порта и запись их в поля компоненнта
   function  SetComDCB(aDCB : TDCB ): Boolean; virtual;                    // установка новых параметров DCB
   function  GetCurentComDCB : TDCB; virtual;                              // получить текущую DCB непосредственно у драйвера порта
   function  GetPortStat : TComStat;                                       // получить статистику порта . при этом ошибки на порту сбрасываются
   function  GetPortErros : Cardinal;                                      // получение ошибок порта. при этом ошибки на порту сбрасываются
   function  FlushAllCommBuffer : Boolean; virtual;                        // очистка буферов с гарантированным окончанием операций чтения/записи
   function  FlushReadBuffer : Boolean; virtual;                           // очистка буфера чтения без завершения операции чтения
   function  FlushWriteBuffer : Boolean; virtual;                          // очистка буфера записи без завершения операции записи
   function  FlushAllBuffers : Boolean; virtual;                           // очистка всех буферов без завершения начатых операций
   function  AbortRead : Boolean; virtual;                                 // прекращение операции чтения порта
   function  AbortWrite : Boolean; virtual;                                // прекращение операции записи в порт
   function  AbortAll : Boolean; virtual;                                  // прекращение всех начатых операций
   procedure BeginSetTimeouts;                                             // начать установку параметров таймаутов порта через свойства
   procedure EndSetTimeout;                                                // окончание установки таймаутов и применение их к порту
   procedure BeginSetDCB;                                                  // начать установку параметров DCB через свойства
   procedure EndSetDCB;                                                    // окончание устновки параметров DCB и применение их к порту
   function  Write(Buff : Pointer; BuffSize : Cardinal; CanCheckReceiveData: boolean = true): Boolean; virtual; // запись данных в порт

   property IsUseMessageQueue             : Boolean read FIsUseMessageQueue write SetIsUseMessageQueue default True; // использовать или нет очередь сообщений приложения для передачи данных
   // управление портом
   property COMNumber                     : Byte read FCOMNumber write SetComNumber default 1;
   property Active                        : Boolean read FActive write SetActive default False;
   // параметры тригера записи
   property WriteTimeOut                  : Cardinal read GetWriteTimeOut write SetWriteTimeOut default 1000;
   // параметры тригера чтения
   property ReciveDataTimeOut             : Cardinal read GetReciveDataTimeOut write SetReciveDataTimeOut default 1000;
   // размеры буферов порта
   property InBuffSize                    : Cardinal read GetInBuffSize write SetInBuffSize default 8192;
   property OutBuffSize                   : Cardinal read GetOutBuffSize write SetOutBuffSize default 8192;
   // DCB порта
   property BaudRate                      : TComPortBaudRate read GetBaudRate write SetBaudRate default br9600;
   property ByteSize                      : TComPortDataBits read GetByteSize write SetByteSize default db8BITS;
   property Parity                        : TComPortParity read GetParity write SetParity default ptEVEN;
   property StopBits                      : TComPortStopBits read GetStopBits write SetStopBits default sb1BITS;
   // тамауты порта
   property ReadIntervalTimeout           : Cardinal read GetReadIntervalTimeout write SetReadIntervalTimeout default MAXDWORD;
   // события порта
   property OnOpenEvent                   : TNotifyEvent read FOnOpenEvent write FOnOpenEvent;
   property OnCloseEvent                  : TNotifyEvent read FOnCloseEvent write FOnCloseEvent;
   property OnLogEvent                    : TEventlogMsgProc read FOnLogEvent write FOnLogEvent;
   property OnErrorEvent                  : TCOMErrrorEventProc read FOnErrorEvent write FOnErrorEvent;
   property OnWriteTimeOut                : TNotifyEvent read FOnWriteTimeOut write FOnWriteTimeOut;
   property OnWriteEnded                  : TNotifyEvent read FOnWriteEnded write FOnWriteEnded;
   property OnReciveDataTimeOut           : TNotifyEvent read FOnReciveDataTimeOut write FOnReciveDataTimeOut;
   property OnReadEnded                   : TNPCOMReadDataEventProc read FOnReadEnded write FOnReadEnded;
   property OnLineBreakEvent              : TNotifyEvent read FOnBreakEvent write FOnBreakEvent;
  end;

  TNPCCOMPort = class(TNPCCustomCOMPort)
  public
   function  Open : Boolean;  virtual; // открыть порт
   function  Close: Boolean; virtual;  // закрыть порт
   // параметры тригера записи
   property WriteTriggerAutoResetTrigger;
   property WriteTriggerCocked;
   // параметры тригера чтения
   property ReadTriggerAutoResetTrigger;
   property ReadTriggerCocked;
  published
   { Параметры компонента}
   property TimeOutWaitingReadEvent;   // интервал времени ожидания события в потоке чтения
   property TimeOutWaitingWriteEvent;  // интервал времени ожидания события в потоке записи
   property TimeOutWaitingCOMEvent;    // интервал времени ожидания события в потоке отслеживания событий порта
  { Параметры порта }
   property COMNumber;                 // номер порта
   property BaudRate;                  // скорость
   property Parity;                    // паритет
   property ByteSize;                  // кол-во инф.бит
   property StopBits;                  // кол-во стоп.бит
   property InBuffSize;                // буфер приема
   property OutBuffSize;               // буфер передачи
   { Таймауты}
   property WriteTimeOut;              { тайм-аут на запись в порт. при установке в 0 не работает. при превышении тайм-аута передачи генерит OnWriteTimeOut}
   property ReciveDataTimeOut;         { тайм-аут на ответ. запускается при очистке буфера при передаче. при установке в 0 не работает.
                                         при при превышении тайм-аута передачи генерит OnReciveDataTimeOut, если не был получен ни один байт}
   property ReadIntervalTimeout;       { тайм-аут на разрыв пакета. запускается при приема пакета. при установке в 0 не работает.
                                         при при превышении тайм-аута (обнаружение разрыва) генерит OnReadEnded}
  { События }
   property OnOpenEvent;               // порт успешно открыт
   property OnCloseEvent;              // порт успешно закрыт
   property OnLogEvent;                // передача лог-сообщения
   property OnErrorEvent;              // передача идентификатора ошибки при ее возникновении
   property OnWriteEnded;              // окончание передачи буфера
   property OnReadEnded;               // принят пакет
   property OnWriteTimeOut;            // тайм-аут записи в порт
   property OnReciveDataTimeOut;       // тайм-аут ожидания приема
   property OnLineBreakEvent;          // потеря доступа к порту
  end;

  TNPCCOMPortFull = class(TNPCCOMPort)
  public
   property RaiseExceptions;
   // параметры тригера записи
   property WriteTriggerHandleTimeOut;
   property WriteTriggerTriggerID;
   property WriteTriggerTriggerWorkTime;
   // параметры тригера чтения
   property ReadTriggerHandleTimeOut;
   property ReadTriggerTriggerID;
   property ReadTriggerTriggerWorkTime;
   // параметры драйвера порта - только чтение
   property ServiceMask;
   property MaxTxQueue;
   property MaxRxQueue;
   property MaxBaud;
   property ProvSubType;
   property ProvCapabilities;
   property SettableParams;
   property SettableBaud;
   property SettableData;
   property SettableStopParity;
   property CurrentTxQueue;
   property CurrentRxQueue;
  published
   // DCB
   property Flags;
   property XonLim;
   property XoffLim;
   property XonChar;
   property XoffChar;
   property ErrorChar;
   property EofChar;
   property EvtChar;
   // Флаги отслеживаемых событий СОМ
   property ComEvents;
   // таймауты порта
   property ReadTotalTimeoutMultiplier;
   property ReadTotalTimeoutConstant;
   property WriteTotalTimeoutMultiplier;
   property WriteTotalTimeoutConstant;
   // события порта
   property OnCTSEvent;
   property OnDSREvent;
   property OnRLSDEvent;
   property OnRingEvent;
   property OnPErrEvent;
   property OnRx80FullEvent;
   property OnEvent1Event;
   property OnEvent2Event;
   // события тригеров
   property OnWriteTriggerCocked;
   property OnWriteTriggerDischarged;
   property OnReadTriggerCocked;
   property OnReadTriggerDischarged;
  end;

{$ENDIF}

implementation

uses SysUtils,
     COMPortFunction;

{$IFDEF WINDOWS}

{ TNPCCustomCOMPort }

constructor TNPCCustomCOMPort.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  FActive:=False;
  FIsUseMessageQueue := True;
  FCOMPortHandle:=INVALID_HANDLE_VALUE;
  FRaiseExceptions:=False;
  FStartEventHandle:=CreateEvent(nil,True,False,nil);
  FStopEventHandle:=CreateEvent(nil,True,False,nil);
  InitDefComTimeOuts;
  InitDefComDCB;
  InitDefComEvents;
  ZeroMemory(@FCommProp,sizeof(FCommProp));

  FInBuffSize:=8192;
  FOutBuffSize:=8192;
  FCanCheckReceiveData:= true;

  FTimeOutWaitingCOMEvent   := 1000;
  FTimeOutWaitingReadEvent  := 1000;
  FTimeOutWaitingWriteEvent := 1000;

  FWriteTimeoutTrigger:=TNPCTimeTrigger.Create;
  FWriteTimeoutTrigger.TriggerID:=1;
  FWriteTimeoutTrigger.TimeOutInterval:=1000;
  FWriteTimeoutTrigger.OnTriggerTimeout:=OnWriteTimeOutProc;
  FWriteTimeoutTrigger.OnCocked:=OnWriteTriggerCockedProc;
  FWriteTimeoutTrigger.OnDischarged:=OnWriteTriggerDischargedProc;

  FReciveDataTrigger:=TNPCTimeTrigger.Create;
  FReciveDataTrigger.TriggerID:=2;
  FReciveDataTrigger.TimeOutInterval:=1000;
  FReciveDataTrigger.OnTriggerTimeout:=OnReciveDataTimeOutProc;
  FReciveDataTrigger.OnCocked:=OnReadTriggerCockedProc;
  FReciveDataTrigger.OnDischarged:=OnReadTriggerDischargedProc;
end;

destructor TNPCCustomCOMPort.Destroy;
begin
  if Active then Active:=False;
  FWriteTimeoutTrigger.Free;
  FReciveDataTrigger.Free;
  CloseHandle(FStartEventHandle);
  CloseHandle(FStopEventHandle);
  inherited;
end;

function TNPCCustomCOMPort.CloseCOMPort: Boolean;
begin
 Result:=False;
 try
  // останавливаем тригеры
  FWriteTimeoutTrigger.Cocked:=False;
  FReciveDataTrigger.Cocked:=False;

  // останавливаем потоки порта
  ResetEvent(FStopEventHandle);

  if Assigned(FCOMEventThread) then
   begin
    SetCommMask(FCOMPortHandle,0);
    FCOMEventThread.Terminate;
    ResetEvent(FStopEventHandle);
    FreeAndNil(FCOMEventThread);
   end;

  AbortAll;

  if Assigned(FReadThread) then
   begin
    FReadThread.Terminate;
    FReadThread.SetWaiteEvent;
    ResetEvent(FStopEventHandle);
    FreeAndNil(FReadThread);
   end;

  if Assigned(FWriteThread) then
   begin
    FWriteThread.Terminate;
    FWriteThread.SetWaiteEvent;
    ResetEvent(FStopEventHandle);
    FreeAndNil(FWriteThread);
   end;

  CloseHandle(FCOMPortHandle);
  FCOMPortHandle:=INVALID_HANDLE_VALUE;

  Result:=True;
 except
  on E : Exception do
   begin
    LogProc(E.Message);
    raise;
   end;
 end;
 if Assigned(OnCloseEvent) then OnCloseEvent(Self);
end;

function TNPCCustomCOMPort.OpenCOMPort: Boolean;
var TempDCB : TDCB;
begin
  Result:=False;
  // открываем порт
  FCOMPortHandle := CreateFile(PChar(MakeCOMName(FCOMNumber)),
                              GENERIC_READ or GENERIC_WRITE,
                              0,
                              nil,
                              OPEN_EXISTING,
                              FILE_FLAG_OVERLAPPED,
                              0);

  if FCOMPortHandle=INVALID_HANDLE_VALUE then
   begin
    SysErrorProc(GetLastError);
    Exit;
   end;

  Result := GetComPropertys;
  if not Result then
   begin
    CloseHandle(FCOMPortHandle);
    FCOMPortHandle:=INVALID_HANDLE_VALUE;
    Exit;
   end;

  GetCommState(FCOMPortHandle,TempDCB);

  AplyComDCB;
  AplyComTimeouts;

  // создаем потоки чтения, записи и мониторинга событий порта
  FWriteThread := TNPCWriteThread.Create(True);
  FWriteThread.IsUseMessageQueue:= FIsUseMessageQueue;
  FWriteThread.Handle           := FCOMPortHandle;
  FWriteThread.StartEventHandle := FStartEventHandle;
  FWriteThread.StopEventHandle  := FStopEventHandle;
  FWriteThread.IniBufferSize    := FOutBuffSize;
  FWriteThread.TimeOutWaiting   := FTimeOutWaitingWriteEvent;
  FWriteThread.OnLogEvent       := LogProc;
  FWriteThread.OnWriteError     := OnWriteErrorProc;
  FWriteThread.OnWriteEnded     := OnWriteEndedProc;

  FReadThread := TNPCReadThread.Create(True);
  FReadThread.IsUseMessageQueue:= FIsUseMessageQueue;
  FReadThread.Handle           := FCOMPortHandle;
  FReadThread.StartEventHandle := FStartEventHandle;
  FReadThread.StopEventHandle  := FStopEventHandle;
  FReadThread.IniBufferSize    := FInBuffSize;
  FReadThread.TimeOutWaiting   := FTimeOutWaitingReadEvent;
  FReadThread.OnLogEvent       := LogProc;
  FReadThread.OnReadError      := OnReadErrorProc;
  FReadThread.OnReadEnded      := OnReadEndedProc;

  AplyBuffSize;

  FCOMEventThread := TNPCCOMEventsThread.Create(True);
  FCOMEventThread.IsUseMessageQueue:= FIsUseMessageQueue;
  FCOMEventThread.COMHandle        := FCOMPortHandle;
  FCOMEventThread.StartEventHandle := FStartEventHandle;
  FCOMEventThread.StopEventHandle  := FStopEventHandle;
  FCOMEventThread.TimeOutWaiting   := FTimeOutWaitingCOMEvent;
  FCOMEventThread.OnLogEvent       := LogProc;
  FCOMEventThread.OnError          := OnEventErrorProc;
  FCOMEventThread.OnRXCharEvent    := OnRXCharEventProc;
  FCOMEventThread.OnTXEmptyEvent   := OnTXEmptyEventProc;
  FCOMEventThread.OnBreakEvent     := OnBreakEventProc;
  FCOMEventThread.OnErrEvent       := OnErrEventProc;
  FCOMEventThread.OnCTSEvent       := OnCTSEventProc;
  FCOMEventThread.OnDSREvent       := OnDSREventProc;
  FCOMEventThread.OnRLSDEvent      := OnRLSDEventProc;
  FCOMEventThread.OnRingEvent      := OnRingEventProc;
  FCOMEventThread.OnPErrEvent      := OnPErrEventProc;
  FCOMEventThread.OnRx80FullEvent  := OnRx80FullEventProc;
  FCOMEventThread.OnEvent1Event    := OnEvent1EventProc;
  FCOMEventThread.OnEvent2Event    := OnEvent2EventProc;

  AplyComEvents;

  //запускаем потоки
  ResetEvent(FStartEventHandle);
  FWriteThread.Resume;
  WaitForSingleObject(FStartEventHandle,200);
  ResetEvent(FStartEventHandle);

  FReadThread.Resume;
  WaitForSingleObject(FStartEventHandle,200);
  ResetEvent(FStartEventHandle);

  FCOMEventThread.Resume;
  WaitForSingleObject(FStartEventHandle,200);
  ResetEvent(FStartEventHandle);

  Result := True;

  if Assigned(OnOpenEvent) then OnOpenEvent(Self);

end;

procedure TNPCCustomCOMPort.SetActive(const Value: Boolean);
begin
  if FActive = Value then Exit;
  FActive := Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if FActive then
   begin
    FActive:=OpenCOMPort;
   end
  else
   begin
    CloseCOMPort;
   end;
end;

procedure TNPCCustomCOMPort.LogProc(Message: String; EventType: DWord; Category, ID: Integer);
begin
 if Assigned(OnLogEvent) then OnLogEvent(Message,EventType,Category,ID);
end;

procedure TNPCCustomCOMPort.SetComNumber(const Value: Byte);
begin
  if FCOMNumber = Value then Exit;
  FCOMNumber := Value;
  if not (csDesigning in ComponentState) and not (csLoading in ComponentState) then Exit;
  if Active then
   begin
    Active:=False;
    Active:=True;
   end;
end;

procedure TNPCCustomCOMPort.SysErrorProc(Error: Cardinal; Mes : String = '');
begin
 try
  if FRaiseExceptions then raise EOSError.Create(SysErrorMessage(Error))
   else OnComErrorProc(Self,ecSys,Error);
 except
  if FRaiseExceptions then
   begin
    LogProc(SysErrorMessage(Error),Cardinal(msgError),Integer(ecSys),Error);
    raise
   end;
 end
end;

procedure TNPCCustomCOMPort.OnWriteErrorProc(Sender: TObject);
begin
  //ошибка при записи в порт
  OnComErrorProc(Self,ecWrite,TNPCWriteThread(Sender).LastWriteError);
end;

procedure TNPCCustomCOMPort.OnWriteEndedProc(Sender: TObject);
begin
  //запись в порт окончена
  FWriteTimeoutTrigger.Cocked:=False;
  // начинаем ждать ответа
  FReciveDataTrigger.Cocked:=False;
  FReciveDataTrigger.Cocked := FCanCheckReceiveData;
  if Assigned(OnWriteEnded) then OnWriteEnded(Self);
end;

procedure TNPCCustomCOMPort.OnReadEndedProc(Sender : TObject; const Buff : Pointer; const BuffSize : Cardinal);
begin
 // дождались прихода данных
 FReciveDataTrigger.Cocked:=False;
 //получение прочитанных данных
 if Assigned(OnReadEnded) then OnReadEnded(Self,Buff,BuffSize);
end;

procedure TNPCCustomCOMPort.OnReadErrorProc(Sender: TObject);
begin
 //ошибка при получении данных из порта
 OnComErrorProc(Self,ecRead,TNPCReadThread(Sender).LastReadError);
end;

procedure TNPCCustomCOMPort.OnEventErrorProc(Sender: TObject);
begin
  //ошибка при выполнении мониторинга порта
  OnComErrorProc(Self,ecEvent,TNPCCOMEventsThread(Sender).LastError);
end;

procedure TNPCCustomCOMPort.OnBreakEventProc(Sender: TObject);
begin
 //Во время ввода данных было обнаружено прерывание.
  if Assigned(OnLineBreakEvent) then OnLineBreakEvent(Self);
end;

procedure TNPCCustomCOMPort.OnErrEventProc(Sender: TObject);
var Errors : Cardinal;
begin
  // возникла ошибка СОМ порта
  if FCOMPortHandle<>INVALID_HANDLE_VALUE then ClearCommError(FCOMPortHandle,Errors,nil);
  OnComErrorProc(Self,ecLine,Errors);
end;

procedure TNPCCustomCOMPort.OnRXCharEventProc(Sender: TObject);
begin
 // пришли данные - даем команду потоку чтения получить данные
 SetEvent(FReadThread.ReciveDataEventHandle);
 //после этого должно возникнуть событие OnReadEndedProc
end;

procedure TNPCCustomCOMPort.OnTXEmptyEventProc(Sender: TObject);
begin
 // передан последний байт из буфера устройства
 OnWriteEndedProc(Sender);
end;

procedure TNPCCustomCOMPort.OnCTSEventProc(Sender: TObject);
begin
 if Assigned(OnCTSEvent)then OnCTSEvent(Self);
end;

procedure TNPCCustomCOMPort.OnDSREventProc(Sender: TObject);
begin
 if Assigned(OnDSREvent)then OnDSREvent(Self);
end;

procedure TNPCCustomCOMPort.OnEvent1EventProc(Sender: TObject);
begin
 if Assigned(OnEvent1Event)then OnEvent1Event(Self);
end;

procedure TNPCCustomCOMPort.OnEvent2EventProc(Sender: TObject);
begin
 if Assigned(OnEvent2Event)then OnEvent2Event(Self);
end;

procedure TNPCCustomCOMPort.OnPErrEventProc(Sender: TObject);
begin
 if Assigned(OnPErrEvent)then OnPErrEvent(Self);
end;

procedure TNPCCustomCOMPort.OnRingEventProc(Sender: TObject);
begin
 if Assigned(OnRingEvent)then OnRingEvent(Self);
end;

procedure TNPCCustomCOMPort.OnRLSDEventProc(Sender: TObject);
begin
 if Assigned(OnRLSDEvent)then OnRLSDEvent(Self);
end;

procedure TNPCCustomCOMPort.OnRx80FullEventProc(Sender: TObject);
begin
 if Assigned(OnRx80FullEvent)then OnRx80FullEvent(Self);
end;

function TNPCCustomCOMPort.GetReadIntervalTimeout: Cardinal;
begin
  Result:=FCommTimeouts.ReadIntervalTimeout;
end;

function TNPCCustomCOMPort.GetReadTotalTimeoutConstant: Cardinal;
begin
  Result:=FCommTimeouts.ReadTotalTimeoutConstant;
end;

function TNPCCustomCOMPort.GetReadTotalTimeoutMultiplier: Cardinal;
begin
  Result:=FCommTimeouts.ReadTotalTimeoutMultiplier;
end;

function TNPCCustomCOMPort.GetWriteTotalTimeoutConstant: Cardinal;
begin
  Result:=FCommTimeouts.WriteTotalTimeoutConstant;
end;

function TNPCCustomCOMPort.GetWriteTotalTimeoutMultiplier: Cardinal;
begin
  Result:=FCommTimeouts.WriteTotalTimeoutMultiplier;
end;

function TNPCCustomCOMPort.SetComTimeouts(Timeouts: TCommTimeouts): Boolean;
begin
 FCommTimeouts.ReadIntervalTimeout         := Timeouts.ReadIntervalTimeout;
 FCommTimeouts.ReadTotalTimeoutMultiplier  := Timeouts.ReadTotalTimeoutMultiplier;
 FCommTimeouts.ReadTotalTimeoutConstant    := Timeouts.ReadTotalTimeoutConstant;
 FCommTimeouts.WriteTotalTimeoutMultiplier := Timeouts.WriteTotalTimeoutMultiplier;
 FCommTimeouts.WriteTotalTimeoutConstant   := Timeouts.WriteTotalTimeoutConstant;
 AplyComTimeouts;
 Result:=True;
end;

procedure TNPCCustomCOMPort.SetReadIntervalTimeout(const Value: Cardinal);
begin
  if FCommTimeouts.ReadIntervalTimeout=Value then Exit;
  FCommTimeouts.ReadIntervalTimeout:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not FTimeoutsPacketSet then AplyComTimeouts;
end;

procedure TNPCCustomCOMPort.SetReadTotalTimeoutConstant(const Value: Cardinal);
begin
  if FCommTimeouts.ReadTotalTimeoutConstant=Value then Exit;
  FCommTimeouts.ReadTotalTimeoutConstant:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not FTimeoutsPacketSet then AplyComTimeouts;
end;

procedure TNPCCustomCOMPort.SetReadTotalTimeoutMultiplier(const Value: Cardinal);
begin
  if FCommTimeouts.ReadTotalTimeoutMultiplier=Value then Exit;
  FCommTimeouts.ReadTotalTimeoutMultiplier:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not FTimeoutsPacketSet then AplyComTimeouts;
end;

procedure TNPCCustomCOMPort.SetWriteTotalTimeoutConstant(const Value: Cardinal);
begin
  if FCommTimeouts.WriteTotalTimeoutConstant=Value then Exit;
  FCommTimeouts.WriteTotalTimeoutConstant:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not FTimeoutsPacketSet then AplyComTimeouts;
end;

procedure TNPCCustomCOMPort.SetWriteTotalTimeoutMultiplier(const Value: Cardinal);
begin
  if FCommTimeouts.WriteTotalTimeoutMultiplier=Value then Exit;
  FCommTimeouts.WriteTotalTimeoutMultiplier:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not FTimeoutsPacketSet then AplyComTimeouts;
end;

function TNPCCustomCOMPort.GetComPropertys: Boolean;
begin
  Result:=False;
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  FCommProp.dwProvSpec1:=COMMPROP_INITIALIZED;
  FCommProp.wPacketLength:=sizeof(FCommProp);
  Result := GetCommProperties(FCOMPortHandle,FCommProp);
  if not Result then
   begin
    SysErrorProc(GetLastError);
    Exit;
   end;
end;

function TNPCCustomCOMPort.GetCurrentRxQueue: DWORD;
begin
  Result:=FCommProp.dwCurrentRxQueue;
end;

function TNPCCustomCOMPort.GetCurrentTxQueue: DWORD;
begin
  Result:=FCommProp.dwCurrentTxQueue;
end;

function TNPCCustomCOMPort.GetMaxBaud: DWORD;
begin
  Result:=FCommProp.dwMaxBaud;
end;

function TNPCCustomCOMPort.GetMaxRxQueue: DWORD;
begin
  Result:=FCommProp.dwMaxRxQueue;
end;

function TNPCCustomCOMPort.GetMaxTxQueue: DWORD;
begin
  Result:=FCommProp.dwMaxTxQueue;
end;

function TNPCCustomCOMPort.GetProvCapabilities: DWORD;
begin
  Result:=FCommProp.dwProvCapabilities;
end;

function TNPCCustomCOMPort.GetProvSubType: DWORD;
begin
  Result:=FCommProp.dwProvSubType;
end;

function TNPCCustomCOMPort.GetServiceMask: DWORD;
begin
  Result:=FCommProp.dwServiceMask;
end;

function TNPCCustomCOMPort.GetSettableBaud: DWORD;
begin
  Result:=FCommProp.dwSettableBaud;
end;

function TNPCCustomCOMPort.GetSettableData: Word;
begin
  Result:=FCommProp.wSettableData;
end;

function TNPCCustomCOMPort.GetSettableParams: DWORD;
begin
  Result:=FCommProp.dwSettableParams;
end;

function TNPCCustomCOMPort.GetSettableStopParity: Word;
begin
  Result:=FCommProp.wSettableStopParity;
end;

procedure TNPCCustomCOMPort.AplyComTimeouts;
var Res : Boolean;
begin
 if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
 Res := SetCommTimeouts(FCOMPortHandle,FCommTimeouts);
 if not Res then SysErrorProc(GetLastError);
end;

procedure TNPCCustomCOMPort.BeginSetTimeouts;
begin
  FTimeoutsPacketSet:=True;
end;

procedure TNPCCustomCOMPort.EndSetTimeout;
begin
  FTimeoutsPacketSet:=False;
  AplyComTimeouts;
end;

procedure TNPCCustomCOMPort.AplyComDCB;
var Res : Boolean;
begin
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Res:=SetCommState(FCOMPortHandle,FCommDCB);
  if not Res then SysErrorProc(GetLastError);
end;

procedure TNPCCustomCOMPort.BeginSetDCB;
begin
  FDCBPacketSet:=True;
end;

procedure TNPCCustomCOMPort.EndSetDCB;
begin
  FDCBPacketSet:=False;
  AplyComDCB;
end;

function TNPCCustomCOMPort.SetComDCB(aDCB : TDCB ): Boolean;
begin
  Result:=False;
  if sizeof(aDCB)<>aDCB.DCBlength then Exit;
  FCommDCB.DCBlength := aDCB.DCBlength;
  FCommDCB.BaudRate:=aDCB.BaudRate;
  FCommDCB.Flags:=aDCB.Flags;
  FCommDCB.wReserved:=aDCB.wReserved;
  FCommDCB.XonLim:=aDCB.XonLim;
  FCommDCB.XoffLim:=aDCB.XoffLim;
  FCommDCB.ByteSize:=aDCB.ByteSize;
  FCommDCB.Parity:=aDCB.Parity;
  FCommDCB.StopBits:=aDCB.StopBits;
  FCommDCB.XonChar:=aDCB.XonChar;
  FCommDCB.XoffChar:=aDCB.XoffChar;
  FCommDCB.ErrorChar:=aDCB.ErrorChar;
  FCommDCB.EofChar:=aDCB.EofChar;
  FCommDCB.EvtChar:=aDCB.EvtChar;
  FCommDCB.wReserved1:=aDCB.wReserved1;
  AplyComDCB;
  Result:=True;
end;

procedure TNPCCustomCOMPort.InitDefComDCB;
begin
  ZeroMemory(@FCommDCB,sizeof(FCommDCB));
  FCommDCB.DCBlength:=sizeof(FCommDCB);
  FCommDCB.BaudRate:=cComDCBDefBaudRate;
  FCommDCB.Flags:=cComDCBDefFlags;
  FCommDCB.XonLim:=cComDCBDefXonLim;
  FCommDCB.XoffLim:=cComDCBDefXoffLim;
  FCommDCB.ByteSize:=cComDCBDefByteSize;
  FCommDCB.Parity:=Byte(cComDCBDefParity);
  FCommDCB.StopBits:=Byte(cComDCBDefStopBits);
  FCommDCB.XonChar:=cComDCBDefXonChar;
  FCommDCB.XoffChar:=cComDCBDefXoffChar;
  FCommDCB.ErrorChar:=cComDCBDefErrorChar;
  FCommDCB.EofChar:=cComDCBDefEofChar;
  FCommDCB.EvtChar:=cComDCBDefEvtChar;
  AplyComDCB;
end;

procedure TNPCCustomCOMPort.InitDefComTimeOuts;
begin
 ZeroMemory(@FCommTimeouts,sizeof(FCommTimeouts));
 FCommTimeouts.ReadIntervalTimeout:=MAXDWORD;
 AplyComTimeouts;
end;

function TNPCCustomCOMPort.GetComEvents: TComPortEvFlags;
begin
 Result:=FCommEvents;
end;

procedure TNPCCustomCOMPort.SetGetComEvents(const Value: TComPortEvFlags);
begin
 if Value=FCommEvents then Exit;
 FCommEvents:=Value;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 AplyComEvents;
end;

procedure TNPCCustomCOMPort.AplyComEvents;
begin
  if not Assigned(FCOMEventThread) then Exit;
  FCOMEventThread.EventMask:=MakeEventFlagsMask(FCommEvents);
end;

procedure TNPCCustomCOMPort.InitDefComEvents;
begin
  FCommEvents:=[];
  FCommEvents:=MakeEventFlagsSet(DefCOMEventFlags);
  AplyComEvents;
end;

function TNPCCustomCOMPort.GetBaudRate: TComPortBaudRate;
begin
  Result:=br9600;
  case FCommDCB.BaudRate of
   75     : Result:=br75;
   110    : Result:=br110;
   150    : Result:=br150;
   300    : Result:=br300;
   600    : Result:=br600;
   1200   : Result:=br1200;
   1800   : Result:=br1800;
   2400   : Result:=br2400;
   4800   : Result:=br4800;
   9600   : Result:=br9600;
   14400  : Result:=br14400;
   19200  : Result:=br19200;
   28800  : Result:=br28800;
   38400  : Result:=br38400;
   57600  : Result:=br57600;
   115200 : Result:=br115200;
  end;
end;

function TNPCCustomCOMPort.GetByteSize: TComPortDataBits;
begin
  Result:=TComPortDataBits(FCommDCB.ByteSize-5);
end;

function TNPCCustomCOMPort.GetEofChar: Char;
begin
  Result:=FCommDCB.EofChar;
end;

function TNPCCustomCOMPort.GetErrorChar: Char;
begin
  Result:=FCommDCB.ErrorChar;
end;

function TNPCCustomCOMPort.GetEvtChar: Char;
begin
  Result:=FCommDCB.EvtChar;
end;

function TNPCCustomCOMPort.GetFlags: Cardinal;
begin
  Result:=FCommDCB.Flags;
end;

function TNPCCustomCOMPort.GetInBuffSize: Cardinal;
begin
  Result:=FInBuffSize;
end;

function TNPCCustomCOMPort.GetOutBuffSize: Cardinal;
begin
  Result:=FOutBuffSize;
end;

function TNPCCustomCOMPort.GetParity: TComPortParity;
begin
  Result:=TComPortParity(FCommDCB.Parity)
end;

function TNPCCustomCOMPort.GetStopBits: TComPortStopBits;
begin
  Result:=TComPortStopBits(FCommDCB.StopBits);
end;

function TNPCCustomCOMPort.GetXoffChar: Char;
begin
  Result:=FCommDCB.XoffChar;
end;

function TNPCCustomCOMPort.GetXoffLim: Word;
begin
  Result:=FCommDCB.XoffLim;
end;

function TNPCCustomCOMPort.GetXonChar: Char;
begin
  Result:=FCommDCB.XonChar;
end;

function TNPCCustomCOMPort.GetXonLim: Word;
begin
  Result:=FCommDCB.XonLim;
end;

procedure TNPCCustomCOMPort.SetBaudRate(const Value: TComPortBaudRate);
begin
  if WinBaudRate[Value]=FCommDCB.BaudRate then Exit;
  FCommDCB.BaudRate:=WinBaudRate[Value];
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetByteSize(const Value: TComPortDataBits);
begin
 if FCommDCB.ByteSize=Byte(Value)+5 then Exit;
 FCommDCB.ByteSize:=Byte(Value)+5;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetEofChar(const Value: Char);
begin
 if FCommDCB.EofChar=Value then Exit;
 FCommDCB.EofChar:=Value;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetErrorChar(const Value: Char);
begin
 if FCommDCB.ErrorChar=Value then Exit;
 FCommDCB.ErrorChar:=Value;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetEvtChar(const Value: Char);
begin
 if FCommDCB.EvtChar=Value then Exit;
 FCommDCB.EvtChar:=Value;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetFlags(const Value: Cardinal);
begin
 if FCommDCB.Flags=Integer(Value) then Exit;
 FCommDCB.Flags:=Value;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetInBuffSize(const Value: Cardinal);
begin
  if FInBuffSize=Value then Exit;
  FInBuffSize:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not Assigned(FReadThread) then Exit;
  FReadThread.IniBufferSize:=FOutBuffSize;
  AplyBuffSize;
end;

procedure TNPCCustomCOMPort.SetOutBuffSize(const Value: Cardinal);
begin
  if FOutBuffSize=Value then Exit;
  FOutBuffSize:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not Assigned(FWriteThread) then Exit;
  FWriteThread.IniBufferSize:=FOutBuffSize;
  AplyBuffSize;
end;

procedure TNPCCustomCOMPort.SetParity(const Value: TComPortParity);
begin
 if Byte(Value)=FCommDCB.Parity then Exit;
 FCommDCB.Parity:=Byte(Value);
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetStopBits(const Value: TComPortStopBits);
begin
 if FCommDCB.StopBits=Byte(Value) then Exit;
 FCommDCB.StopBits:=Byte(Value);
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetXoffChar(const Value: Char);
begin
 if FCommDCB.XoffChar=Value then Exit;
 FCommDCB.XoffChar:=Value;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetXoffLim(const Value: Word);
begin
 if FCommDCB.XoffLim=Value then Exit;
 FCommDCB.XoffLim:=Value;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetXonChar(const Value: Char);
begin
 if FCommDCB.XonChar=Value then Exit;
 FCommDCB.XonChar:=Value;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB
end;

procedure TNPCCustomCOMPort.SetXonLim(const Value: Word);
begin
 if FCommDCB.XonLim=Value then Exit;
 FCommDCB.XonLim:=Value;
 if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
 if not FDCBPacketSet then AplyComDCB;
end;

procedure TNPCCustomCOMPort.AplyBuffSize;
var Res : Boolean;
begin
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Res:= SetupComm( FCOMPortHandle, FInBuffSize, FOutBuffSize );
  if not Res then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.FlushAllBuffers: Boolean;
begin
  Result:=False;
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Result:=PurgeComm(FCOMPortHandle,PURGE_RXCLEAR or PURGE_TXABORT);
  if not Result then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.FlushReadBuffer: Boolean;
begin
  Result:=False;
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Result:=PurgeComm(FCOMPortHandle,PURGE_RXCLEAR);
  if not Result then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.FlushWriteBuffer: Boolean;
begin
  Result:=False;
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Result:=PurgeComm(FCOMPortHandle,PURGE_TXCLEAR);
  if not Result then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.AbortAll: Boolean;
begin
  Result:=False;
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Result:=PurgeComm(FCOMPortHandle,PURGE_TXABORT or PURGE_RXABORT);
  if not Result then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.AbortRead: Boolean;
begin
  Result:=False;
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Result:=PurgeComm(FCOMPortHandle,PURGE_RXABORT);
  if not Result then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.AbortWrite: Boolean;
begin
  Result:=False;
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Result:=PurgeComm(FCOMPortHandle,PURGE_TXABORT);
  if not Result then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.FlushAllCommBuffer: Boolean;
begin
  Result:=False;
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Result:=FlushFileBuffers(FCOMPortHandle);
  if not Result then SysErrorProc(GetLastError);
end;

procedure TNPCCustomCOMPort.OnComErrorProc(Sender: TObject; ErrorCategory: TComErrorCategory; ErrorCode: Cardinal);
begin
  if Assigned(OnErrorEvent) then OnErrorEvent(Sender,ErrorCategory,ErrorCode);
end;

function TNPCCustomCOMPort.Write(Buff: Pointer; BuffSize: Cardinal; CanCheckReceiveData: boolean = true): Boolean;
begin
  FCanCheckReceiveData:= CanCheckReceiveData;
  Result:=False;
  if (Buff=nil) or (BuffSize=0) then Exit;
  if not Assigned(FWriteThread) then Exit;
  Result:=FWriteThread.WriteBuff(Buff,BuffSize);
  if Result then
   begin
    FWriteTimeoutTrigger.Cocked:=True;
   end;
end;

function TNPCCustomCOMPort.GetWriteTimeOut: Cardinal;
begin
  Result:=FWriteTimeoutTrigger.TimeOutInterval;
end;

procedure TNPCCustomCOMPort.SetWriteTimeOut(const Value: Cardinal);
begin
  if FWriteTimeoutTrigger.TimeOutInterval=Value then Exit;
  FWriteTimeoutTrigger.TimeOutInterval:=Value;
end;

procedure TNPCCustomCOMPort.OnWriteTimeOutProc(Sender: TObject);
begin
  if Assigned(OnWriteTimeOut) then OnWriteTimeOut(Self);
end;

function TNPCCustomCOMPort.GetReciveDataTimeOut: Cardinal;
begin
  Result:=FReciveDataTrigger.TimeOutInterval;
end;

procedure TNPCCustomCOMPort.OnReciveDataTimeOutProc(Sender: TObject);
begin
  if Assigned(OnReciveDataTimeOut) then OnReciveDataTimeOut(Self);
end;

procedure TNPCCustomCOMPort.SetReciveDataTimeOut(const Value: Cardinal);
begin
  if FReciveDataTrigger.TimeOutInterval=Value then Exit;
  FReciveDataTrigger.TimeOutInterval:=Value;
end;

procedure TNPCCustomCOMPort.OnReadTriggerCockedProc(Sender: TObject);
begin
 if Assigned(OnReadTriggerCocked) then OnReadTriggerCocked(Self);
end;

procedure TNPCCustomCOMPort.OnReadTriggerDischargedProc(Sender: TObject);
begin
 if Assigned(OnReadTriggerDischarged) then OnReadTriggerDischarged(Self);
end;

procedure TNPCCustomCOMPort.OnWriteTriggerCockedProc(Sender: TObject);
begin
  if Assigned(OnWriteTriggerCocked) then OnWriteTriggerCocked(Self);
end;

procedure TNPCCustomCOMPort.OnWriteTriggerDischargedProc(Sender: TObject);
begin
  if Assigned(OnWriteTriggerDischarged) then OnWriteTriggerDischarged(Self);
end;

function TNPCCustomCOMPort.GetReadTriggerAutoResetTrigger: Boolean;
begin
  Result:=FReciveDataTrigger.AutoResetTrigger;
end;

function TNPCCustomCOMPort.GetReadTriggerCocked: Boolean;
begin
  Result:=FReciveDataTrigger.Cocked;
end;

function TNPCCustomCOMPort.GetReadTriggerHandleTimeOut: Boolean;
begin
  Result:=FReciveDataTrigger.HandleTimeOut;
end;

function TNPCCustomCOMPort.GetReadTriggerID: Integer;
begin
  Result:=FReciveDataTrigger.TriggerID;
end;

function TNPCCustomCOMPort.GetReadTriggerWorkTime: Cardinal;
begin
  Result:=FReciveDataTrigger.TriggerWorkTime;
end;

function TNPCCustomCOMPort.GetWriteTriggerAutoResetTrigger: Boolean;
begin
  Result:=FWriteTimeoutTrigger.AutoResetTrigger;
end;

function TNPCCustomCOMPort.GetWriteTriggerCocked: Boolean;
begin
  Result:=FWriteTimeoutTrigger.Cocked;
end;

function TNPCCustomCOMPort.GetWriteTriggerHandleTimeOut: Boolean;
begin
  Result:=FWriteTimeoutTrigger.HandleTimeOut;
end;

function TNPCCustomCOMPort.GetWriteTriggerID: Integer;
begin
  Result:=FWriteTimeoutTrigger.TriggerID;
end;

function TNPCCustomCOMPort.GetWriteTriggerWorkTime: Cardinal;
begin
  Result:=FWriteTimeoutTrigger.TriggerWorkTime;
end;

procedure TNPCCustomCOMPort.SetReadTriggerAutoResetTrigger(const Value: Boolean);
begin
  FReciveDataTrigger.AutoResetTrigger:=Value;
end;

procedure TNPCCustomCOMPort.SetReadTriggerCocked(const Value: Boolean);
begin
  FReciveDataTrigger.Cocked:=Value;
end;

procedure TNPCCustomCOMPort.SetReadTriggerHandleTimeOut(const Value: Boolean);
begin
  FReciveDataTrigger.HandleTimeOut:=Value;
end;

procedure TNPCCustomCOMPort.SetReadTriggerID(const Value: Integer);
begin
  FReciveDataTrigger.TriggerID:=Value;
end;

procedure TNPCCustomCOMPort.SetWriteTriggerAutoResetTrigger(const Value: Boolean);
begin
  FWriteTimeoutTrigger.AutoResetTrigger:=Value;
end;

procedure TNPCCustomCOMPort.SetWriteTriggerCocked(const Value: Boolean);
begin
  FWriteTimeoutTrigger.Cocked:=Value;
end;

procedure TNPCCustomCOMPort.SetWriteTriggerHandleTimeOut(const Value: Boolean);
begin
  FWriteTimeoutTrigger.HandleTimeOut:=Value;
end;

procedure TNPCCustomCOMPort.SetWriteTriggerID(const Value: Integer);
begin
  FWriteTimeoutTrigger.TriggerID:=Value;
end;

function TNPCCustomCOMPort.GetCurentComDCB: TDCB;
var Res : Boolean;
begin
  Res:=GetCommState(FCOMPortHandle,Result);
  if not Res then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.CancelPortIO: Boolean;
begin
  Result:=False;
  if FCOMPortHandle=INVALID_HANDLE_VALUE then Exit;
  Result:=CancelIo(FCOMPortHandle);
  if not Result then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.GetTimeOutWaitingCOMEvent: Cardinal;
begin
  Result:=FTimeOutWaitingCOMEvent;
end;

function TNPCCustomCOMPort.GetTimeOutWaitingReadEvent: Cardinal;
begin
  Result:=FTimeOutWaitingReadEvent;
end;

function TNPCCustomCOMPort.GetTimeOutWaitingWriteEvent: Cardinal;
begin
  Result:=FTimeOutWaitingWriteEvent;
end;

procedure TNPCCustomCOMPort.SetTimeOutWaitingCOMEvent( const Value: Cardinal);
begin
  if FTimeOutWaitingCOMEvent=Value then Exit;
  FTimeOutWaitingCOMEvent:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not Assigned(FCOMEventThread) then Exit;
  FCOMEventThread.TimeOutWaiting:=FTimeOutWaitingCOMEvent;
end;

procedure TNPCCustomCOMPort.SetTimeOutWaitingReadEvent( const Value: Cardinal);
begin
  if FTimeOutWaitingReadEvent=Value then Exit;
  FTimeOutWaitingReadEvent:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not Assigned(FReadThread) then Exit;
  FReadThread.TimeOutWaiting:=FTimeOutWaitingReadEvent;
end;

procedure TNPCCustomCOMPort.SetTimeOutWaitingWriteEvent( const Value: Cardinal);
begin
  if FTimeOutWaitingWriteEvent=Value then Exit;
  FTimeOutWaitingWriteEvent:=Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then Exit;
  if not Assigned(FWriteThread) then Exit;
  FWriteThread.TimeOutWaiting:=FTimeOutWaitingWriteEvent;
end;

function TNPCCustomCOMPort.GetPortErros: Cardinal;
var Res : Boolean;
    TempStat : TComStat;
begin
  if FCOMPortHandle = INVALID_HANDLE_VALUE then Exit;
  Res:=ClearCommError(FCOMPortHandle,Result,@TempStat);
  if not Res then SysErrorProc(GetLastError);
end;

function TNPCCustomCOMPort.GetPortStat: TComStat;
var Res : Boolean;
    Errors : CArdinal;
begin
  if FCOMPortHandle = INVALID_HANDLE_VALUE then Exit;
  Res:=ClearCommError(FCOMPortHandle,Errors,@Result);
  if not Res then SysErrorProc(GetLastError);
end;

procedure TNPCCustomCOMPort.SetIsUseMessageQueue(const Value: Boolean);
begin
  if FIsUseMessageQueue = Value then Exit;
  FIsUseMessageQueue := Value;
  if Assigned(FWriteThread) then FWriteThread.IsUseMessageQueue      := FIsUseMessageQueue;
  if Assigned(FReadThread) then FReadThread.IsUseMessageQueue        := FIsUseMessageQueue;
  if Assigned(FCOMEventThread) then FCOMEventThread.IsUseMessageQueue := FIsUseMessageQueue;
end;

{ TNPCCOMPort }

function TNPCCOMPort.Close: Boolean;
begin
  Active:= false;
  Result:= not Active;
end;

function TNPCCOMPort.Open: Boolean;
begin
  Active:= true;
  Result:= Active;
end;

{$ENDIF}

end.
