unit COMCrossTypes;

{$mode objfpc}{$H+}

interface

uses {$IFDEF WINDOWS}
     Windows,
     {$ELSE}
     termio, baseunix, unix,
     {$ENDIF}
     Classes, SysUtils, syncobjs,
     LoggerItf,
     COMPortParamTypes;

type

  TNPCCustomCOMPort = class;

  TNPCServerCOMPortThread = class(TThreadLogged)
  private
   FPort     : TNPCCustomCOMPort;
   FCSection : TCriticalSection;
  protected
   procedure Execute; override;
  public
   constructor Create(aPort : TNPCCustomCOMPort; aCSection : TCriticalSection); virtual;
  end;

  TNPCMonitorCOMPortThread = class(TNPCServerCOMPortThread)
  private
   FLEEnable  : Boolean;
   FCTSEnable : Boolean;
   FDCDEnable : Boolean;
   FDSREnable : Boolean;
   FRNGEnable : Boolean;
   FRTSEnable : Boolean;
   FDTREnable : Boolean;
   procedure InitThread;
   procedure ReadBitsState;
  protected
   procedure Execute; override;
  public
   constructor Create(aPort : TNPCCustomCOMPort; aCSection : TCriticalSection); override;
  end;

  ENPCCOMPortError = class(Exception)
  private
    FErrorCode: Integer;
  public
   constructor CreateBasedOnError(AErrorCode : Integer);
   property ErrCode  : Integer read FErrorCode;
  end;

  TNPCCustomCOMPort = class(TComponentLogged)
  private
   FHandle             : THandle;

   FIsServerSide       : Boolean;
   FCSection           : TCriticalSection;
   FPackRuptureTime    : Cardinal;
   FTimeoutMultiplier  : Cardinal;
   FTimeoutConst       : Cardinal;

   FServerThread       : TNPCServerCOMPortThread;
   FServerReadTimeout  : Cardinal;

   FIsMonitorStatusBit : Boolean;
   FMonitorThread      : TNPCMonitorCOMPortThread;
   FMonitorInterval    : Cardinal;

   FIsRaiseException   : Boolean;

   FLEEnable           : Boolean;
   FCTSEnable          : Boolean;
   FDCDEnable          : Boolean;
   FDSREnable          : Boolean;
   FRNGEnable          : Boolean;
   FRTSEnable          : Boolean;
   FDTREnable          : Boolean;

   FOnLEChange         : TNotifyEvent;
   FOnCTSChange        : TNotifyEvent;
   FOnDCDChange        : TNotifyEvent;
   FOnDSRChange        : TNotifyEvent;
   FOnDTRChange        : TNotifyEvent;
   FOnRNGChange        : TNotifyEvent;
   FOnRTSChange        : TNotifyEvent;
   FOnServerReadData   : TNotifyEvent;

   FSoftFlowControl    : Boolean;
   FHardFlowControl    : Boolean;

   FLastError          : Integer;
   FLastErrorDesc      : String;
   FPortNumber         : Word;
   FPortPrefix         : TComPortPrefixPath;
   FPortPrefixOther    : String;
   FPortPath           : String;

   FRecvBuffSize       : Integer;

   FPortDCB            : TDCB;
  {$IFDEF UNIX}
   FOldPortParams      : Termios;
   FPortParams         : Termios;
  {$ENDIF}

   function  GetActive: Boolean;

   function  GetBaudRate: TComPortBaudRate;
   function  GetByteSize: TComPortDataBits;

   procedure GetBitStatus(var AField : Boolean; ABitFlag : Cardinal);
   procedure SetBitStatus(var AField : Boolean; ABitFlag : Cardinal);
   procedure SetMonitorStatusBits;

   function  GetLEEnable: Boolean;
   function  GetCTSEnable: Boolean;
   function  GetDCDEnable: Boolean;
   function  GetDSREnable: Boolean;
   function  GetDTREnable: Boolean;
   function  GetRNGEnable: Boolean;
   function  GetRTSEnable: Boolean;

   function  GetParity: TComPortParity;
   function  GetStopBits: TComPortStopBits;

   procedure MakePortPath;

   procedure SetActive(AValue: Boolean);

   procedure SetBaudRate(AValue: TComPortBaudRate);
   procedure SetByteSize(AValue: TComPortDataBits);

   procedure SetLEEnable(AValue: Boolean);
   procedure SetCTSEnable(AValue: Boolean);
   procedure SetDCDEnable(AValue: Boolean);
   procedure SetDSREnable(AValue: Boolean);
   procedure SetDTREnable(AValue: Boolean);
   procedure SetRNGEnable(AValue: Boolean);
   procedure SetRTSEnable(AValue: Boolean);

   procedure SetHardFlowControl(AValue: Boolean);
   procedure SetIsMonitorStatusBit(AValue: Boolean);

   procedure SetSoftFlowControl(AValue: Boolean);

   procedure SetParity(AValue: TComPortParity);
   procedure SetPortNumber(AValue: Word);
   procedure SetPortPrefix(AValue: TComPortPrefixPath);
   procedure SetRecvBuffSize(AValue: Integer);
   procedure SetStopBits(AValue: TComPortStopBits);

   procedure SetLastError(ALastError : Integer; PlaceOfOrigin : string = '');
  protected
   {$IFDEF WINDOWS}
   FEvMsk        : DWORD;
   {$ENDIF}

   property PortDCB : TDCB read FPortDCB;
   property Handle  : THandle read FHandle;
   // управление параметрами порта
   procedure InitDCB; virtual;
   procedure SetPortParams; virtual;
   procedure SetOldPortParams; virtual;
   // запуск останов режима мониторинга приходов данных
   procedure StartServerSide; virtual;
   procedure StopServerSide; virtual;
   // мониторинг и управление статусными битами
   procedure StartMonitorStatusBit; virtual;
   procedure StopMonitorStatusBit; virtual;

   procedure Lock;
   procedure Unlock;

   {$IFDEF UNIX}
   function  DCBToTermIOs : Termios;
   procedure InitTermIOs(var ATermIOs : Termios);
   property  OldPortParams : Termios read FOldPortParams;
   property  PortParams    : Termios read FPortParams;
  {$ENDIF}
  public
   constructor Create(AOwner : TComponent); override;
   Destructor  Destroy; override;

   // открыть порт
   procedure Open;
   // закрыть порт
   procedure Close;
   // прочитать состояние сигнальных линий
   procedure GetMonitorStatusBits;

   // функция возвращает количество не прочитанных данных во входящем буфере порта
   function GetNumberDataCame :Integer;
   // Блокирующее чтение из порта
   function ReadData(var Buff; Count : Integer): Integer;

   {$IFDEF UNIX}
   {
    В режиме обработки неканонического ввода, не производится построчная сборка ввода и обработка ввода
    (очистка, удаление слов, и т.д.) не производится.
    Два параметра управляют поведением этого режима: c_cc[VTIME] устанавливает символьный таймер,
                                                     c_cc[VMIN] устанавливает минимальное количество символов
                                                     которые необходимо принять для удовлетворения операции чтения.
    Если VMIN > 0 и VTIME = 0, то VMIN устанавливает количество символов которые необходимо принять для
                               удовлетворения операции чтения. Так как TIME установлено в нуль,
                               то таймер не используется.
    Если VMIN = 0 и VTIME > 0, то VTIME служит как значение таймаута. Операция чтения будет удовлетворена
                               если будет прочитан одиночный символ, или TIME будет превышен (t = TIME *0.1 s).
                               Если TIME превышено, то не будет возвращено ни одного символа.
    Если VMIN > 0 и VTIME > 0, то VTIME служит как межсимвольный таймер. Операция чтения будет удовлетворена
                               если будет принято MIN символов, или время между передачей двух символов достигло
                               TIME. Таймер рестартует каждый раз при приеме нового символа и активируется
                               после приема первого символа.
    Если VMIN = 0 и VTIME = 0, то чтение будет удовлетворено немедленно. При этом операция чтения вернет число
                               фактически доступных символов или число запрошенных символов.
                               Вы можете выдать fcntl(fd, F_SETFL, FNDELAY); перед чтением для получения таких же
                               результатов.
   }
   // Параметризированное чтение из порта
   function ParameterizedReadingFromPort(var Buff; Count : Integer; aVMIN : Byte; aVTIME : Byte): Integer;
   {$ENDIF}

   // Блокирующая запись в порт
   function WriteData(var Buff; Count : Integer): Integer;

   // Ожидание прихода данных
   function WaitForData(var ATimeOut : QWord): TWaitResult;

   // очистка буфера записи
   function FlushWriteBuff : Integer;

   // очистка буфера чтения
   function FlushReadBuff : Integer;

   // очистка всех буферов
   function FlushAllBuff : Integer;

   // активизация/деактивизаци порта
   property Active           : Boolean read GetActive write SetActive;

   // последняя возникшая ошибка
   property LastError        : Integer read FLastError;
   // описание последней возникшей ошибки
   property LastErrorDesc    : String  read FLastErrorDesc;

   // полный путь к порту в системе
   property PortPath         : String read FPortPath;

   // управление статусными сигналами порта
   property LEEnable         : Boolean read GetLEEnable write SetLEEnable;
   property DTREnable        : Boolean read GetDTREnable write SetDTREnable;
   property DSREnable        : Boolean read GetDSREnable write SetDSREnable;
   property RTSEnable        : Boolean read GetRTSEnable write SetRTSEnable;
   property CTSEnable        : Boolean read GetCTSEnable write SetCTSEnable;
   property DCDEnable        : Boolean read GetDCDEnable write SetDCDEnable;
   property RNGEnable        : Boolean read GetRNGEnable write SetRNGEnable;

  published
   // возбуждать или нет исключения при возникновении ошибок
   property IsRaiseException : Boolean read FIsRaiseException write FIsRaiseException default False;
   // включение/отключение работы в режиме серверного порта
   Property IsServerSide     : Boolean read FIsServerSide write FIsServerSide default False;
   // включение/отключение мониторинга состояния статусных сигналов
   property IsMonitorStatusBit : Boolean read FIsMonitorStatusBit write SetIsMonitorStatusBit default False;

   // номер порта
   property PortNumber         : Word read FPortNumber write SetPortNumber;
   // префикс имени порта в системе
   property PortPrefix         : TComPortPrefixPath read FPortPrefix write SetPortPrefix;
   // нестандартный префикс имени порта
   property PortPrefixOther    : String read FPortPrefixOther write FPortPrefixOther;

   // скорость обмена
   property BaudRate           : TComPortBaudRate read GetBaudRate write SetBaudRate default br9600;
   // размер байта данных
   property ByteSize           : TComPortDataBits read GetByteSize write SetByteSize default db8BITS;
   // паритет
   property Parity             : TComPortParity read GetParity write SetParity default ptEVEN;
   // количество стоповых бит
   property StopBits           : TComPortStopBits read GetStopBits write SetStopBits default sb1BITS;

   // включение/отключение програмного управления потоком данных
   property SoftFlowControl    : Boolean read FSoftFlowControl write SetSoftFlowControl default False;
   // включение/отключение аппаратного управления потоком данных
   property HardFlowControl    : Boolean read FHardFlowControl write SetHardFlowControl default False;

   // размер буфера приема
   property RecvBuffSize       : Integer read FRecvBuffSize write SetRecvBuffSize default cCOMSizeRecvBuffer;

   // таймаут на приход данных в порт в режиме сервера
   property ServerReadTimeout  : Cardinal read FServerReadTimeout write FServerReadTimeout default 5000;
   property MonitorInterval    : Cardinal read FMonitorInterval write FMonitorInterval default 1000;
   property PackRuptureTime    : Cardinal read FPackRuptureTime write FPackRuptureTime default 50;
   property TimeoutMultiplier  : Cardinal read FTimeoutMultiplier write FTimeoutMultiplier default 10;
   property TimeoutConst       : Cardinal read FTimeoutConst write FTimeoutConst default 10;

   // События на изменение статусных сигналов. Возбуждаются только при мониторинге этих сигналов
   property OnLEChange         : TNotifyEvent read FOnLEChange write FOnLEChange;
   property OnDTRChange        : TNotifyEvent read FOnDTRChange write FOnDTRChange;
   property OnDSRChange        : TNotifyEvent read FOnDSRChange write FOnDSRChange;
   property OnRTSChange        : TNotifyEvent read FOnRTSChange write FOnRTSChange;
   property OnCTSChange        : TNotifyEvent read FOnCTSChange write FOnCTSChange;
   property OnDCDChange        : TNotifyEvent read FOnDCDChange write FOnDCDChange;
   property OnRNGChange        : TNotifyEvent read FOnRNGChange write FOnRNGChange;

   {
     Cобытие возбуждается только в режиме сервера и сигнализирует о приходе данных в порт.
     В качестве входящего объекта передается объект порта
   }
   property OnServerReadData   : TNotifyEvent read FOnServerReadData write FOnServerReadData;
  end;

implementation

uses COMPortResStr;

{ TNPCMonitorCOMPortThread }

constructor TNPCMonitorCOMPortThread.Create(aPort: TNPCCustomCOMPort; aCSection: TCriticalSection);
begin
  FLEEnable  := False;
  FCTSEnable := False;
  FDCDEnable := False;
  FDSREnable := False;
  FRNGEnable := False;
  FRTSEnable := False;
  FDTREnable := False;
  inherited Create(aPort, aCSection);
end;

procedure TNPCMonitorCOMPortThread.InitThread;
begin
  FPort.GetMonitorStatusBits;
  FLEEnable  := FPort.LEEnable;
  FCTSEnable := FPort.CTSEnable;
  FDCDEnable := FPort.DCDEnable;
  FDSREnable := FPort.DSREnable;
  FRNGEnable := FPort.RTSEnable;
  FRTSEnable := FPort.RTSEnable;
  FDTREnable := FPort.DTREnable;
end;

procedure TNPCMonitorCOMPortThread.ReadBitsState;
begin
  try
   FPort.GetMonitorStatusBits;
   if FPort.LastError <> 0 then
    begin
     SendLogMessage(llError,rsPortName,Format(rsReadBitsState1,[FPort.LastError,FPort.LastErrorDesc]));
     Exit;
    end;
  except
   on E : Exception do
    begin
     SendLogMessage(llError,rsPortName,Format(rsReadBitsState2,[E.Message]));
    end;
  end;

  if (FLEEnable <> FPort.LEEnable)then
   begin
    FLEEnable := FPort.LEEnable;
    if Assigned(FPort.OnLEChange) then
    try
     FPort.OnLEChange(FPort);
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsPortName,Format(rsReadBitsState3,[E.Message]));
      end;
    end;
   end;

  if (FCTSEnable <> FPort.CTSEnable)then
   begin
    FCTSEnable := FPort.CTSEnable;
    if Assigned(FPort.OnCTSChange) then
    try
     FPort.OnCTSChange(FPort);
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsPortName,Format(rsReadBitsState4,[E.Message]));
      end;
    end;
   end;

  if (FDCDEnable <> FPort.DCDEnable)then
   begin
    FDCDEnable := FPort.DCDEnable;
    if Assigned(FPort.OnDCDChange) then
    try
     FPort.OnDCDChange(FPort);
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsPortName,Format(rsReadBitsState5,[E.Message]));
      end;
    end;
   end;

  if (FDSREnable <> FPort.DSREnable)then
   begin
    FDSREnable := FPort.DSREnable;
    if Assigned(FPort.OnDSRChange) then
    try
     FPort.OnDSRChange(FPort);
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsPortName,Format(rsReadBitsState6,[E.Message]));
      end;
    end;
   end;

  if (FRNGEnable <> FPort.RNGEnable)then
   begin
    FRNGEnable := FPort.RNGEnable;
    if Assigned(FPort.OnRNGChange) then
    try
     FPort.OnRNGChange(FPort);
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsPortName,Format(rsReadBitsState7,[E.Message]));
      end;
    end;
   end;

  if (FRTSEnable <> FPort.RTSEnable)then
   begin
    FRTSEnable := FPort.RTSEnable;
    if Assigned(FPort.OnRTSChange) then
    try
     FPort.OnRTSChange(FPort);
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsPortName,Format(rsReadBitsState8,[E.Message]));
      end;
    end;
   end;

  if (FDTREnable <> FPort.DTREnable)then
   begin
    FDTREnable := FPort.DTREnable;
    if Assigned(FPort.OnDTRChange) then
    try
     FPort.OnDTRChange(FPort);
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsPortName,Format(rsReadBitsState9,[E.Message]));
      end;
    end;
   end;
end;

procedure TNPCMonitorCOMPortThread.Execute;
var TempEvent : TEvent;
begin
  InitThread;
  TempEvent := TEvent.Create(nil,True,False,'');
  try
   while not Terminated do
    begin
     if TempEvent.WaitFor(FPort.MonitorInterval) = wrTimeout then
      begin
       if Terminated then Break;
       FCSection.Enter;
       try
        ReadBitsState;
       finally
        FCSection.Leave;
       end;
      end
     else Sleep(FPort.MonitorInterval);
     if Terminated then Break;
    end;
  finally
   FreeAndNil(TempEvent);
  end;
end;

{ TNPCServerCOMPortThread }

constructor TNPCServerCOMPortThread.Create(aPort: TNPCCustomCOMPort; aCSection: TCriticalSection);
begin
  FCSection := aCSection;
  FPort     := aPort;
  inherited Create(True,65536);
end;

procedure TNPCServerCOMPortThread.Execute;
var Res : TWaitResult;
    TempTimeOut : QWord;
begin
  while not Terminated do
   begin
    try
     try
      TempTimeOut := FPort.ServerReadTimeout;
      Res := wrError;
      Res := FPort.WaitForData(TempTimeOut);
     except
      on E : Exception do
       begin
        SendLogMessage(llError,rsPortName,Format(rsReadBitsState10,[E.Message]));
        Sleep(FPort.ServerReadTimeout);
        Continue;
       end;
     end;
     case Res of
      wrError    : begin // ошибка
                    SendLogMessage(llError,rsPortName,Format(rsReadBitsState11,[FPort.LastError,FPort.LastErrorDesc]));
                    if Terminated then Break;
                    Sleep(FPort.ServerReadTimeout);
                    if Terminated then Break;
                   end;
      wrSignaled : begin // пришли данные
                    if not Assigned(FPort.OnServerReadData) then
                     begin
                      Sleep(FPort.ServerReadTimeout);
                      Continue;
                     end;
                    if Terminated then Break;
                    FCSection.Enter;
                    try
                     FPort.OnServerReadData(FPort);
                     if Terminated then Break;
                    finally
                     FCSection.Leave;
                    end;
                   end;
      wrTimeout  : begin
                   end;
     end;
    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsPortName,Format(rsReadBitsState12,[E.Message]));
       if Terminated then Break;
       Sleep(FPort.ServerReadTimeout);
      end;
    end;
   end;
end;

{ ENPCCOMPortError }

constructor ENPCCOMPortError.CreateBasedOnError(AErrorCode: Integer);
begin
  FErrorCode := AErrorCode;
  Message    := GetCOMPortErrorMessage(AErrorCode);
end;

{ TNPCCustomCOMPort }

constructor TNPCCustomCOMPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := INVALID_HANDLE_VALUE;

  FCSection          := TCriticalSection.Create;
  FServerThread      := nil;
  FServerReadTimeout := 5000;

  FMonitorInterval := 1000;
  FMonitorThread   := nil;

  FPackRuptureTime   := 50;
  FTimeoutMultiplier := 10;
  FTimeoutConst      := 10;

  {$IFDEF UNIX}
  FillByte(FOldPortParams,sizeof(Termios),0);
  FillByte(FPortParams,sizeof(Termios),0);
  {$ENDIF}
  FillByte(FPortDCB,sizeof(TDCB),0);

  FLEEnable  := False;
  FDTREnable := False;
  FDSREnable := False;
  FRTSEnable := False;
  FCTSEnable := False;
  FDCDEnable := False;
  FRNGEnable := False;

  FSoftFlowControl := False;
  FHardFlowControl := False;

  FIsRaiseException   := False;
  FIsServerSide       := False;
  FIsMonitorStatusBit := False;

  FLastError         := 0;
  FLastErrorDesc     := '';

  FRecvBuffSize      := cCOMSizeRecvBuffer;
  FPortNumber        := 1;
  {$IFDEF UNIX}
  FPortPrefix := pptLinux;
  {$ELSE}
  FPortPrefix := pptWindows;
  {$ENDIF}
  FPortPrefixOther := '';
  MakePortPath;
end;

destructor TNPCCustomCOMPort.Destroy;
begin
  Close;
  FreeAndNil(FCSection);
  inherited Destroy;
end;

procedure TNPCCustomCOMPort.SetIsMonitorStatusBit(AValue: Boolean);
begin
  if FIsMonitorStatusBit=AValue then Exit;
  FIsMonitorStatusBit:=AValue;
end;

procedure TNPCCustomCOMPort.Open;
{$IFDEF WINDOWS}
var TempTimeouts : TCOMMTIMEOUTS;
{$ENDIF}
begin
  if Active then
   begin
    SetLastError(ErrPortAlreadyOpen,'TNPCCustomCOMPort.Open(1)');
    Exit;
   end;
  SetLastError(0);
{$IFDEF UNIX}
{  O_APPEND   - Запись производится в конец файла.
   O_CREAT    - Если файл не существует, он будет создан. Этот флаг требует наличия третьего
                аргумента функции open (mode), который определяет значения битов прав доступа
                к создаваемому файлу.
   O_EXCL     - Приводит к появлению ошибки, если файл уже существует и задан флаг O_CREAT.
                При такой комбинации флагов атомарно выполняется проверка существования файла
                и его создание, если файл не существует.
   O_TRUNC    - Если файл существует и успешно открывается на запись либо на чтение и запись,
                то его размер усекается до нуля.
   O_NOCTTY   - Если аргумент pathname ссылается на файл терминального устройства, то это устройство
                не назначается управляющим терминалом вызывающего процесса.
   O_NONBLOCK - Если аргумент pathname ссылается на именованный канал (FIFO), специальный блочный файл
                или специальный символьный файл, этот флаг задает неблокирующий режим открытия файла
                и последующих операций ввода вывода.
   O_NODELAY  - приводит к тому, что функция read возвращает значение 0 в случае отсутствия данных
                в именованном или неименованном канале или в файле устройства, но тогда возникает
                конфликт со значением 0, которое возвращается по достижении конца файла.
   O_DSYNC    - Каждый вызов функции write ожидает завершения физической операции ввода вывода,
                но не ожидает, пока будут обновлены атрибуты файла, если они не влияют на возможность
                чтения только что записанных данных.
   O_RSYNC    - Каждый вызов функции read приостанавливается до тех пор, пока не будут закончены
                ожидающие завершения операции записи в ту же самую часть файла.
   O_SYNC     - Каждый вызов функции write ожидает завершения физической операции ввода вывода,
                включая операцию обновления атрибутов файла.
}
  FHandle := THandle(FpOpen(FPortPath, O_RDWR or O_NOCTTY or O_NDELAY or O_SYNC));

  if FHandle = INVALID_HANDLE_VALUE then
   begin
    SetLastError(fpgeterrno);
    Exit;
   end;

  // сброс O_NDELAY
  FpFcntl(FHandle, F_SETFL, 0);

  // блокировка порта для эксклюзивного использования
  if FpIOCtl(FHandle,TIOCEXCL,nil) = -1 then
   begin
    Close;
    SetLastError(fpgeterrno);
    Exit;
   end;

  // устанавливаем параметры порта
  SetPortParams;

  if LastError <> 0 then
   begin
    Close;
    Exit;
   end;

  GetMonitorStatusBits;

  if LastError <> 0 then
   begin
    Close;
    Exit;
   end;

  if FIsMonitorStatusBit then StartMonitorStatusBit;

  SendLogMessage(llInfo,rsPortName,Format(rsOpen1,[PortPath]));

  if not FIsServerSide then Exit;

  // Запускаем наблюдение за приходом запросов(данных)
  StartServerSide;

  if LastError <> 0 then
   begin
    Close;
    Exit;
   end;
{$ELSE}
  FHandle := CreateFile(LPCSTR(FPortPath),
                        GENERIC_READ or GENERIC_WRITE,
                        0,
                        nil,
                        OPEN_EXISTING,
                        FILE_FLAG_OVERLAPPED, // для асихронного ввода-вывода
                        0);

  if FHandle = INVALID_HANDLE_VALUE then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.Open(2)');
    Exit;
   end;

  if not SetCommState(FHandle,FPortDCB) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.Open(3)');
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
    Exit;
   end;

  TempTimeouts.ReadIntervalTimeout := 0;
  FillByte(TempTimeouts,SizeOf(TCOMMTIMEOUTS),0);
  TempTimeouts.ReadIntervalTimeout        := FPackRuptureTime;
  TempTimeouts.ReadTotalTimeoutMultiplier := FTimeoutMultiplier;
  TempTimeouts.ReadTotalTimeoutConstant   := FTimeoutConst;

  if not SetCommTimeouts(FHandle,TempTimeouts) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.Open(4)');
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
    Exit;
   end;

  if not SetupComm(FHandle,FRecvBuffSize,FRecvBuffSize) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.Open(4)');
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
    Exit;
   end;

  FEvMsk := 0;

  if not GetCommMask(FHandle,FEvMsk) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.Open(5)');
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
    Exit;
   end;

  FEvMsk := FEvMsk or EV_RXCHAR or EV_TXEMPTY;

  if not SetCommMask(FHandle,FEvMsk) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.Open(6)');
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
    Exit;
   end;

  FlushAllBuff;

  SendLogMessage(llInfo,rsPortName,Format(rsOpen1,[PortPath]));

  if not FIsServerSide then Exit;

  // Запускаем наблюдение за приходом запросов(данных)
  StartServerSide;

  if LastError <> 0 then
   begin
    Close;
    Exit;
   end;

{$ENDIF}
end;

procedure TNPCCustomCOMPort.Close;
begin
  if not Active then
   begin
    Exit;
   end;
  try
   if FIsMonitorStatusBit then StopMonitorStatusBit;
   if FIsServerSide then StopServerSide;
   FlushAllBuff;
   // восстанавливаем настройки порта
   SetOldPortParams;
  finally
   {$IFDEF UNIX}
   // снятие эксклюзивного использования перед закрытием
   FpIOCtl(FHandle,TIOCNXCL,nil);
   FileClose(cint(FHandle))
   {$ELSE}
   CancelDC(FHandle);
   CloseHandle(FHandle);
   {$ENDIF};
   FHandle := INVALID_HANDLE_VALUE;
   SetLastError(0);
   SendLogMessage(llInfo,rsPortName,Format(rsClose1,[PortPath]));
  end;
end;

function TNPCCustomCOMPort.GetNumberDataCame: Integer;
var ByteCount : Integer;
    {$IFDEF WINDOWS}
     TempCOMStat : TCOMSTAT;
     TempErrors  : DWORD;
    {$ENDIF}
begin
  Result    := -1;
  ByteCount := 0;
 {$IFDEF UNIX}
  Result := FpIOCtl(FHandle,FIONREAD,@ByteCount);
  if Result = -1 then
   begin
    SetLastError(fpgeterrno);
    Exit;
   end;
 {$ELSE}
  TempErrors := 0;
  TempCOMStat.flag0 := 0;
  FillByte(TempCOMStat,SizeOf(TCOMSTAT),0);
  if not ClearCommError(FHandle,TempErrors,@TempCOMStat) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.GetNumberDataCame');
    Exit;
   end;
  ByteCount := TempCOMStat.cbInQue;
 {$ENDIF}
  Result := ByteCount;
end;

function TNPCCustomCOMPort.ReadData(var Buff; Count: Integer): Integer;
var {$IFDEF UNIX}
    Counter   : Integer;
    TempBuff  : Byte;
    {$ENDIF}
    {$IFDEF WINDOWS}
    ReadCount,
    LastErr      : DWORD;
    ReadRes      : Boolean;
    TempOver     : TOVERLAPPED;
    NumRead      : DWORD;
    TempCommStat : TCOMSTAT;
    TempLastErr  : Cardinal;
    {$ENDIF}
begin
  Result   := -1;
  if not Active then
   begin
    SetLastError(ErrPortNotOpen,'TNPCCustomCOMPort.ReadData(1)');  //-1
    Exit;
   end;

  if (not Assigned(@Buff)) or (Count = 0) then
   begin
    SetLastError(ErrPortBuff,'TNPCCustomCOMPort.ReadData(2)');  //-1
    Exit;
   end;

  Lock;
  try
   Result  := -1;
   {$IFDEF UNIX}
   TempBuff := 0;
   Counter := 0;
   while Result<>0 do
    begin;
     Result := FpRead(FHandle,TempBuff,1);
     case Result of
      -1 : begin // ошибка чтения
            FlushReadBuff;
            SetLastError(fpgeterrno);
            Exit;
           end;
      0  : begin // таймаут между символами
            Result := Counter;
            Break;
           end;
      1  : begin // прочитали байт
            Byte((@Buff+Counter)^) := TempBuff;
            Inc(Counter);
            Result := Counter;
            if Counter = Count then Break;
           end;
     end;
    end;
  {$ELSE}
   TempOver.hEvent := 0;
   NumRead := 0;
   FillByte(TempOver,SizeOf(TempOver),0);
   TempOver.hEvent := CreateEvent(nil,False,False,'');

   TempLastErr := 0;
   FillByte(TempCommStat,sizeof(TCOMSTAT),0);
   ClearCommError(FHandle,TempLastErr,@TempCommStat);

   try
    ReadCount := 0;
    ReadRes := ReadFile(FHandle,Buff,Count,ReadCount,@TempOver);
    if not ReadRes then
     begin
      LastErr := GetLastOSError;
      if LastErr = ERROR_IO_PENDING then
       begin
        if not GetOverlappedResult(FHandle,TempOver,NumRead,True) then
         begin
          LastErr := GetLastError;
          SetLastError(LastErr,'TNPCCustomCOMPort.ReadData GetOverlappedResult');
          Result := -1;
          Exit;
         end;
        Result := NumRead;
        Exit;
       end
      else
       begin
        SetLastError(LastErr,'TNPCCustomCOMPort.ReadData ReadFile');
        Exit;
       end;
     end;
    Result := ReadCount;
   finally
    CloseHandle(TempOver.hEvent);
   end;
  {$ENDIF}
  finally
   Unlock;
  end;
end;

{$IFDEF UNIX}
function TNPCCustomCOMPort.ParameterizedReadingFromPort(var Buff; Count: Integer; aVMIN : Byte; aVTIME : Byte): Integer;
var TempTerm : Termios;
begin
  Result := -1;
  TempTerm := DCBToTermIOs;
  TempTerm.c_cc[VMIN]  := aVMIN;
  TempTerm.c_cc[VTIME] := aVTIME;

  if TCSetAttr(FHandle,TCSANOW,TempTerm) = -1 then
   begin
    SetLastError(fpgeterrno);
    Exit;
   end;

  try
   Result := ReadData(Buff,Count);
   if Result = -1 then
    begin
     SetLastError(fpgeterrno);
     Exit;
    end;
  finally   // восстанавливаем значения по умолчанию
   TempTerm.c_cc[VMIN]  := 1;
   TempTerm.c_cc[VTIME] := 1;
   if TCSetAttr(FHandle,TCSANOW,TempTerm) = -1 then SetLastError(fpgeterrno);
  end;
end;
{$ENDIF}

function TNPCCustomCOMPort.WriteData(var Buff; Count: Integer): Integer;
{$IFDEF WINDOWS}
var WriteCount, LastErr,
    ByteToWrite  : DWORD;
    WriteRes     : Boolean;
    TempOver     : TOVERLAPPED;
    TempEvent    : DWORD;
{$ENDIF}
begin
  Result := -1;

  if not Active then
   begin
    SetLastError(ErrPortNotOpen,'TNPCCustomCOMPort.WriteData(1)');
    Exit;
   end;

  if (not Assigned(@Buff)) or (Count = 0) then
   begin
    SetLastError(ErrPortBuff,'TNPCCustomCOMPort.WriteData(2)');
    Exit;
   end;

  Lock;
  try
   {$IFDEF UNIX}
   Result := FpWrite(FHandle,Buff,Count);
   if Result = -1 then
    begin
     SetLastError(GetLastOSError);
     FlushWriteBuff;
    end;
   {$ELSE}
   TempOver.hEvent := 0;
   FillByte(TempOver,SizeOf(TOVERLAPPED),0);
   TempOver.hEvent := CreateEvent(nil,True,True,nil);
   if TempOver.hEvent = 0 then
    begin
     SetLastError(GetLastOSError,'TNPCCustomCOMPort.WriteData(3)');
     Exit;
    end;

   try
   ByteToWrite := Count;
   WriteCount  := 0;

   TempEvent := EV_TXEMPTY;
   SetCommMask(FHandle,TempEvent);

   WriteRes := WriteFile(FHandle,Buff,ByteToWrite,WriteCount,@TempOver);
   if not WriteRes then
    begin  // запись не закончена (асинхронный режим или ошибка)
     LastErr := GetLastOSError;
     if LastErr <> ERROR_IO_PENDING then
      begin
       SetLastError(LastErr,'TNPCCustomCOMPort.WriteData(4)');
       Exit;
      end;
     if not WaitCommEvent(FHandle,TempEvent,@TempOver) then
      begin
       LastErr := GetLastOSError;
       if LastErr <> ERROR_IO_PENDING then
        begin
         SetLastError(LastErr,'TNPCCustomCOMPort.WriteData(5)');
         Exit;
        end;
      end;
     if not GetOverlappedResult(FHandle,TempOver,WriteCount,True) then // возможна ошибка - запись не окончена - 996 - ERROR_IO_INCOMPLETE
      begin
       SetLastError(GetLastOSError,'TNPCCustomCOMPort.WriteData(6)');
       Exit;
      end;
     FlushFileBuffers(FHandle);
     Result := WriteCount;
    end
   else
    begin // запись закончена успешно сразу же
     Result := WriteCount;
    end;
   finally
    CloseHandle(TempOver.hEvent);
   end;
   {$ENDIF}
  finally
   Unlock;
  end;
end;

function TNPCCustomCOMPort.WaitForData(var ATimeOut: QWord): TWaitResult;
{$IFDEF UNIX}
var TempReadSet : TFDSet;
    TempTimeVal : TTimeVal;
    Res         : Integer;
    TempTick    : Cardinal;
{$ELSE}
var TempOver     : TOVERLAPPED;
    TempTick     : QWord;
    TempErr      : DWORD;
    TempWaiteRes : DWORD;
    ByteTras     : DWORD;
    TempEvent    : DWORD;
    TempCommStat : TCOMSTAT;
    TempLastErr  : Cardinal;
{$ENDIF}
begin
  Result := wrError;

  if not Active then
   begin
    SetLastError(ErrPortNotOpen,'TNPCCustomCOMPort.WaitForData(1)');
    Exit;
   end;

  TempTick := GetTickCount64;
  Lock;
  try
  {$IFDEF UNIX}
  // заполняем временные параметры
  TempTimeVal.tv_sec  := ATimeOut div 1000;
  TempTimeVal.tv_usec := (ATimeOut mod 1000) * 1000;
  // заполняем структуру дескрипторов
  fpFD_ZERO(TempReadSet);
  fpFD_SET(FHandle,TempReadSet);
  // ждем события
  Res := fpSelect(FHandle+1,@TempReadSet,nil,nil,@TempTimeVal);
  case Res of
   -1 : begin
         SetLastError(fpgeterrno);
        end;
    0 : begin
         Result := wrTimeout;
        end;
  else
   fpFD_CLR(FHandle,TempReadSet);
   Result := wrSignaled;
  end;
  {$ELSE}
  ByteTras := 0;

  FillByte(TempOver,sizeof(TOVERLAPPED),0);
  TempOver.hEvent := CreateEvent(nil,True,True,nil);
  TempEvent := EV_RXCHAR;
  SetCommMask(FHandle,TempEvent);

  TempLastErr := 0;
  FillByte(TempCommStat,sizeof(TCOMSTAT),0);
  ClearCommError(FHandle,TempLastErr,@TempCommStat);

  try
  if WaitCommEvent(FHandle,TempEvent,@TempOver) then
   begin
    if not GetOverlappedResult(FHandle,TempOver,ByteTras,True) then
     begin
      SetLastError(GetLastOSError,'TNPCCustomCOMPort.WaitForData(2)');
      Exit;
     end;

    ClearCommError(FHandle,TempLastErr,@TempCommStat);
    Result := wrSignaled;
   end
  else
    begin
     TempErr := GetLastOSError;
     if TempErr<>ERROR_IO_PENDING then
      begin
       SetLastError(TempErr,'TNPCCustomCOMPort.WaitForData(3)');
       Exit;
      end;

     TempWaiteRes := WaitForSingleObject(TempOver.hEvent,ATimeOut);
     case TempWaiteRes of
       WAIT_OBJECT_0 : begin
                        if not GetOverlappedResult(FHandle,TempOver,ByteTras,True) then
                         begin
                          SetLastError(GetLastOSError,'TNPCCustomCOMPort.WaitForData(4)');
                          Exit;
                         end;
                        ClearCommError(FHandle,TempLastErr,@TempCommStat);
                        Result := wrSignaled;
                       end;
       WAIT_TIMEOUT : begin
//                       SetLastError(GetLastOSError,'TNPCCustomCOMPort.WaitForData(5)');
                       Result := wrTimeout;
                      end;
       WAIT_FAILED  : begin
                       SetLastError(GetLastOSError,'TNPCCustomCOMPort.WaitForData(6)');
                      end;
      end;
    end;
  finally
   CloseHandle(TempOver.hEvent);
  end;
  {$ENDIF}

  finally
   ATimeOut := GetTickCount64 - TempTick;
   Unlock;
  end;
end;

function TNPCCustomCOMPort.FlushWriteBuff : Integer;
begin
  Result := -1;
  {$IFDEF UNIX}
  Result := TCFlush(FHandle,TCOFLUSH);
  if Result = -1 then SetLastError(fpgeterrno);
  {$ELSE}
  if not PurgeComm(FHandle,PURGE_TXCLEAR) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.FlushWriteBuff');
    Exit;
   end;
  Result := 0;
  {$ENDIF}
end;

function TNPCCustomCOMPort.FlushReadBuff : Integer;
begin
  Result := -1;
  {$IFDEF UNIX}
  Result := TCFlush(FHandle,TCIFLUSH);
  if Result = -1 then SetLastError(fpgeterrno);
  {$ELSE}
  if not PurgeComm(FHandle,PURGE_RXCLEAR) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.FlushReadBuff');
    Exit;
   end;
  Result := 0;
  {$ENDIF}
end;

function TNPCCustomCOMPort.FlushAllBuff : Integer;
begin
  Result := -1;
  {$IFDEF UNIX}
  Result := TCFlush(FHandle,TCIOFLUSH);
  if Result = -1 then SetLastError(fpgeterrno);
  {$ELSE}
  if not PurgeComm(FHandle,PURGE_RXCLEAR or PURGE_TXCLEAR) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.FlushAllBuff');
    Exit;
   end;
  Result := 0;
  {$ENDIF}
end;

procedure TNPCCustomCOMPort.SetPortParams;
{$IFDEF UNIX}
var TempTermIOs : Termios;
{$ENDIF}
begin
{$IFDEF UNIX}
 TempTermIOs := DCBToTermIOs;
 if TCSetAttr(cint(FHandle),TCSANOW,TempTermIOs) = -1 then
  begin
   SetLastError(fpgeterrno);
   Exit;
  end;
{$ELSE}
 raise Exception.Create('SetPortParams. Для Windows не реализовано.')
{$ENDIF}
end;

procedure TNPCCustomCOMPort.SetOldPortParams;
begin
{$IFDEF UNIX}
 if TCSetAttr(cint(FHandle),TCSANOW,FOldPortParams) = -1 then
  begin
   SetLastError(fpgeterrno);
   Exit;
  end;
{$ENDIF}
end;

{$IFDEF UNIX}
procedure TNPCCustomCOMPort.InitTermIOs(var ATermIOs: Termios);
begin
 // помощь по флагам http://www.opennet.ru/man.shtml?topic=tcflush&category=3&russian=0
 // CFMakeRaw(var tios:TermIOS)
 ATermIOs.c_iflag := ATermIOs.c_iflag and (not (IGNBRK or  //  отключение. игнорировать режим BREAK при вводе
                                                BRKINT or  //  отключение. если включен IGNBRK то BREAK игнорируется. Если он не включен, а BRKINT включен, то BREAK вызывает сброс очередей, и, если терминал является управляющим для группы процессов переднего плана, то группе будет отослан сигнал SIGINT. Если ни IGNBRK ни BRKINT не включены, то BREAK считывается как нулевой символ, кроме случая когда установлено PARMRK, тогда он будет считан, как последовательность \377 \0 \0.
                                                PARMRK or  //  отключение. если не включен режим IGNPAR, то сопровождать символ с ошибкой четности или позиционирования префиксом \377 \0. Если не включен ни IGNPAR, ни PARMRK, то считывать символ с ошибкой четности или позиционирования как \0.
                                                ISTRIP or  //  отключение. удалять восьмой бит.
                                                INLCR or   //  отключение. преобразовывать NL в CR при вводе.
                                                IGNCR or   //  отключение. игнорировать перевод каретки при вводе.
                                                ICRNL or   //  отключение. преобразовывать перевод каретки в конец строки при вводе (пока не будет запущен IGNCR).
                                                IXON));    //  отключение. запустить управление потоком данных XON/XOFF при выводе.
 ATermIOs.c_oflag := ATermIOs.c_oflag and (not OPOST);     //  отключение. включить режим вывода, определяемый реализацией по умолчанию.
 ATermIOs.c_lflag := ATermIOs.c_lflag and (not (ECHO or    //  отключение. отображать вводимые символы.
                                                ECHONL or  //  отключение. если запущен ICANON, то символ NL отображается, даже если режим ECHO не включен.
                                                ICANON or  //  отключение. запустить канонический режим. Это означает, что линии используют специальные символы: EOF, EOL, EOL2, ERASE, KILL, LNEXT, REPRINT, STATUS и WERASE, а также строчную буферизацию.
                                                ISIG or    //  отключение. когда принимаются любые символы из INTR, QUIT, SUSP или DSUSP, то генерировать соответствующий сигнал.
                                                IEXTEN));  //  отключение. включить режим ввода, определяемый реализацией по умолчанию. Этот флаг, как и ICANON должен быть включен для обработки специальных символов EOL2, LNEXT, REPRINT, WERASE, а также для того, чтобы работал флаг IUCLC.
 ATermIOs.c_cflag := (ATermIOs.c_cflag and (not (CSIZE or  //  отключение. маска размера символов. Значениями будут: CS5, CS6, CS7 или CS8.
                                                 PARENB))) //  отключение. запустить генерацию четности при выводе и проверку четности на вводе.
                                                 or CS8;   //  включение. размер символа
 ATermIOs.c_cc[VMIN]  := 0; // минимальное количество символов
 ATermIOs.c_cc[VTIME] := 2; // задержка на приход символа
end;

function TNPCCustomCOMPort.DCBToTermIOs: Termios;
var x : Cardinal;
begin
 Result.c_cflag := 0;
 FillByte(Result, SizeOf(Termios), 0);

 FillByte(FPortParams, SizeOf(Termios), 0);
 FillByte(FOldPortParams, SizeOf(Termios), 0);

 if tcgetattr(FHandle, FOldPortParams) = -1 then
  begin
   SetLastError(fpgeterrno);
   Exit;
  end;

 if tcgetattr(FHandle, FPortParams) = -1 then
  begin
   SetLastError(fpgeterrno);
   Exit;
  end;

 InitTermIOs(FPortParams);

 // устанавливаем текущую DCB в TermIOs
  FPortParams.c_cflag := FPortParams.c_cflag or CREAD;   // включить прием.
  FPortParams.c_cflag := FPortParams.c_cflag or CLOCAL;  // игнорировать управление линиями с помощью модема.
  FPortParams.c_cflag := FPortParams.c_cflag or HUPCL;   // выключить управление модемом линиями после того, как последний процесс прекратил использование устройства (повесить трубку).

  //аппаратное управление потоком
  if (PortDCB.flags and dcbFlag_RtsControlHandshake) > 0 then FPortParams.c_cflag := FPortParams.c_cflag or CRTSCTS //(не включено в POSIX) разрешить управление потоком данных RTS/CTS (аппаратное).
   else FPortParams.c_cflag := FPortParams.c_cflag and (not CRTSCTS);

  //программное управление потоком
  if (PortDCB.flags and dcbFlag_OutX) > 0 then FPortParams.c_iflag := FPortParams.c_iflag or IXON or IXOFF or IXANY
   else FPortParams.c_iflag := FPortParams.c_iflag and (not (IXON or IXOFF or IXANY));

  //размер байта
  FPortParams.c_cflag := FPortParams.c_cflag and (not CSIZE);
  case PortDCB.bytesize of
    5:  FPortParams.c_cflag := FPortParams.c_cflag or CS5;
    6:  FPortParams.c_cflag := FPortParams.c_cflag or CS6;
    7:  FPortParams.c_cflag := FPortParams.c_cflag or CS7;
    8:  FPortParams.c_cflag := FPortParams.c_cflag or CS8;
  end;

  // паритет
  if (PortDCB.flags and dcbFlag_ParityCheck) > 0 then FPortParams.c_cflag := FPortParams.c_cflag or PARENB // запустить генерацию четности при выводе и проверку четности на вводе.
   else FPortParams.c_cflag := FPortParams.c_cflag and (not PARENB);

  case PortDCB.parity of
    1: FPortParams.c_cflag := FPortParams.c_cflag or PARODD;                    //'Odd'
    2: FPortParams.c_cflag := FPortParams.c_cflag and (not PARODD);             //'Even'
    3: FPortParams.c_cflag := FPortParams.c_cflag or CMSPAR or PARENB or PARODD;//'Mark'
    4: begin                                                          //'Space'
        FPortParams.c_cflag:= FPortParams.c_cflag or CMSPAR or PARENB;
        FPortParams.c_cflag:= FPortParams.c_cflag and (Not PARODD);
       end;
  end;

  //stop bits
  if PortDCB.StopBits > 0 then FPortParams.c_cflag := FPortParams.c_cflag or CSTOPB
   else FPortParams.c_cflag := FPortParams.c_cflag and (not CSTOPB);

  //set baudrate;
  x := PortDCB.BaudRate;

  //  из cfsetispeed(Result, x);
  FPortParams.c_cflag:=(FPortParams.c_cflag and (not CBAUD)) // (не включено в POSIX) маска скорости в бодах (4+1 бита).
                   or x;

  Result := FPortParams;
 end;
{$ENDIF}

function TNPCCustomCOMPort.GetActive: Boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

function TNPCCustomCOMPort.GetBaudRate: TComPortBaudRate;
begin
  Result := GetBaudRateIDFromNumValue(FPortDCB.BaudRate);
end;

procedure TNPCCustomCOMPort.SetBaudRate(AValue: TComPortBaudRate);
begin
  FPortDCB.BaudRate := GetBaudRateValueFromID(AValue);
end;

function TNPCCustomCOMPort.GetByteSize: TComPortDataBits;
begin
  Result := GetDataBitsIDFromValue(FPortDCB.ByteSize);
end;

procedure TNPCCustomCOMPort.SetByteSize(AValue: TComPortDataBits);
begin
  FPortDCB.ByteSize := GetDataBitsValueFromID(AValue);
end;

procedure TNPCCustomCOMPort.SetHardFlowControl(AValue: Boolean);
begin
  if FHardFlowControl=AValue then Exit;
  FHardFlowControl:=AValue;
  if FHardFlowControl then FPortDCB.Flags := FPortDCB.Flags or dcbFlag_OutxCtsFlow or dcbFlag_RtsControlHandshake
   else FPortDCB.Flags := FPortDCB.Flags and (not (dcbFlag_OutxCtsFlow or dcbFlag_RtsControlHandshake)) or dcbFlag_RtsControlEnable;
end;

procedure TNPCCustomCOMPort.SetSoftFlowControl(AValue: Boolean);
begin
  if FSoftFlowControl = AValue then Exit;
  FSoftFlowControl := AValue;
  if FSoftFlowControl then FPortDCB.Flags := FPortDCB.Flags or dcbFlag_OutX or dcbFlag_InX
   else FPortDCB.Flags := FPortDCB.Flags and (not (dcbFlag_OutX or dcbFlag_InX));
end;

function TNPCCustomCOMPort.GetParity: TComPortParity;
begin
  Result := TComPortParity(FPortDCB.Parity);
end;

procedure TNPCCustomCOMPort.SetParity(AValue: TComPortParity);
begin
  FPortDCB.Parity := Byte(AValue);
  // контроль паритета в флагах
  if FPortDCB.Parity > 0 then FPortDCB.Flags := FPortDCB.Flags or dcbFlag_ParityCheck
   else FPortDCB.Flags := FPortDCB.Flags and (not(dcbFlag_ParityCheck));
end;

function TNPCCustomCOMPort.GetStopBits: TComPortStopBits;
begin
  Result := TComPortStopBits(FPortDCB.StopBits);
end;

procedure TNPCCustomCOMPort.SetStopBits(AValue: TComPortStopBits);
begin
  FPortDCB.StopBits := Byte(AValue);
end;

procedure TNPCCustomCOMPort.InitDCB;
begin
   FillChar(FPortDCB, SizeOf(TDCB), 0);

   SetByteSize(cComDCBDefByteSize);
   SetParity(cComDCBDefParity);
   SetStopBits(cComDCBDefStopBits);
   SetBaudRate(cComDCBDefBaudRate);

   FPortDCB.DCBlength  := SizeOf(TDCB);
   FPortDCB.wReserved  := cComDCBDefwReserved;
   FPortDCB.XonLim     := FRecvBuffSize div 4;
   FPortDCB.XoffLim    := FRecvBuffSize div 4;
   FPortDCB.XonChar    := cComDCBDefXonChar;
   FPortDCB.XoffChar   := cComDCBDefXoffChar;
   FPortDCB.ErrorChar  := cComDCBDefErrorChar;
   FPortDCB.EofChar    := cComDCBDefEofChar;
   FPortDCB.EvtChar    := cComDCBDefEvtChar;
   FPortDCB.wReserved1 := cComDCBDefwReserved1;
   FPortDCB.Flags      := FPortDCB.Flags or
                          dcbFlag_RtsControlEnable or
                          dcbFlag_Binary;      // бинарный DCB
end;

procedure TNPCCustomCOMPort.SetRecvBuffSize(AValue: Integer);
begin
  if FRecvBuffSize=AValue then Exit;
  FRecvBuffSize := AValue;
  FPortDCB.XonLim  := FRecvBuffSize div 4;
  FPortDCB.XoffLim := FRecvBuffSize div 4;
end;

procedure TNPCCustomCOMPort.MakePortPath;
begin
  if (FPortPrefix = pptOther) and (FPortPrefixOther = '') then
   begin
    SetLastError(ErrPortPathOther,'TNPCCustomCOMPort.MakePortPath');
    Exit;
   end;
  if (FPortPrefix = pptOther) then FPortPath := Format('%s%d',[FPortPrefixOther, FPortNumber])
   else FPortPath := Format('%s%d',[ComPortPrefixPathValue[FPortPrefix], FPortNumber]);
end;

procedure TNPCCustomCOMPort.SetActive(AValue: Boolean);
begin
  if AValue then Open
   else Close;
end;

procedure TNPCCustomCOMPort.SetPortNumber(AValue: Word);
begin
  if FPortNumber = AValue then Exit;
  FPortNumber := AValue;
  MakePortPath;
end;

procedure TNPCCustomCOMPort.SetPortPrefix(AValue: TComPortPrefixPath);
begin
  if FPortPrefix = AValue then Exit;
  FPortPrefix := AValue;
  MakePortPath;
end;

procedure TNPCCustomCOMPort.SetLastError(ALastError: Integer; PlaceOfOrigin : string = '');
begin
  if (ALastError <> 0) then
   begin;
    if (FLastError = ALastError) then Exit;

    try

    FLastError     := ALastError;
    FLastErrorDesc := Format('%s(%s)',[PlaceOfOrigin,GetCOMPortErrorMessage(ALastError)])  ;
    if IsRaiseException then raise ENPCCOMPortError.CreateBasedOnError(ALastError);
    SendLogMessage(llError,rsPortName,FLastErrorDesc);

    except
     on E : Exception do
      begin
       SendLogMessage(llError,rsPortName,Format('%s - %s',['TNPCCustomCOMPort.SetLastError',e.Message]));
      end;
    end;

   end
  else
   begin
    FLastError     := ALastError;
    FLastErrorDesc := '';
   end;
end;

procedure TNPCCustomCOMPort.StartServerSide;
begin
  if Assigned(FServerThread) then StopServerSide;
  FServerThread := TNPCServerCOMPortThread.Create(Self,FCSection);
  FServerThread.Logger := Logger;
  FServerThread.Start;
end;

procedure TNPCCustomCOMPort.StopServerSide;
begin
  if not Assigned(FServerThread) then Exit;
  FServerThread.Terminate;
  FServerThread.WaitFor;
  FreeAndNil(FServerThread);
end;

procedure TNPCCustomCOMPort.StartMonitorStatusBit;
begin
  if Assigned(FMonitorThread) then StopMonitorStatusBit;
  FMonitorThread := TNPCMonitorCOMPortThread.Create(Self,FCSection);
  FMonitorThread.Logger := Logger;
  FMonitorThread.Start;
end;

procedure TNPCCustomCOMPort.StopMonitorStatusBit;
begin
  if not Assigned(FMonitorThread) then Exit;
  FMonitorThread.Terminate;
  FMonitorThread.WaitFor;
  FreeAndNil(FMonitorThread);
end;

procedure TNPCCustomCOMPort.Lock;
begin
  if (not Assigned(FServerThread)) or (not Assigned(FMonitorThread)) then Exit;
  FCSection.Enter;
end;

procedure TNPCCustomCOMPort.Unlock;
begin
  if (not Assigned(FServerThread)) or (not Assigned(FMonitorThread)) then Exit;
  FCSection.Leave;
end;

procedure TNPCCustomCOMPort.SetMonitorStatusBits;
var TempStatus : Cardinal;
    {$IFDEF UNIX}Res : Integer;{$ENDIF}
begin
 if not Active then Exit;

 TempStatus := 0;
 {$IFDEF UNIX}
 Res := FpIOCtl(FHandle,TIOCMGET,@TempStatus);
 if Res = -1 then
  begin
   SetLastError(fpgeterrno);
   Exit;
  end;

 if FLEEnable then TempStatus := TempStatus or TIOCM_LE
  else TempStatus := TempStatus and (not TIOCM_LE);

 if FDSREnable then TempStatus := TempStatus or TIOCM_DSR
  else TempStatus := TempStatus and (not TIOCM_DSR);

 if FRNGEnable then TempStatus := TempStatus or TIOCM_RNG
  else TempStatus := TempStatus and (not TIOCM_RNG);

 if FDCDEnable then TempStatus := TempStatus or TIOCM_CAR
  else TempStatus := TempStatus and (not TIOCM_CAR);

 if FCTSEnable then TempStatus := TempStatus or TIOCM_CTS
  else TempStatus := TempStatus and (not TIOCM_CTS);

 if FRTSEnable then TempStatus := TempStatus or TIOCM_RTS
  else TempStatus := TempStatus and (not TIOCM_RTS);

 if FDTREnable then TempStatus := TempStatus or TIOCM_DTR
  else TempStatus := TempStatus and (not TIOCM_DTR);

 Res := FpIOCtl(FHandle,TIOCMSET,@TempStatus);
 if Res = -1 then
  begin
   SetLastError(fpgeterrno);
   Exit;
  end;
 {$ELSE}
  if FRTSEnable then TempStatus := SETRTS
   else TempStatus := CLRRTS;
  if not EscapeCommFunction(FHandle,TempStatus)then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.SetMonitorStatusBits(1)');
    Exit;
   end;

  if FDTREnable then TempStatus := SETDTR
   else TempStatus := CLRDTR;
  if not EscapeCommFunction(FHandle,TempStatus)then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.SetMonitorStatusBits(2)');
    Exit;
   end;
 {$ENDIF}
 GetMonitorStatusBits;
end;

procedure TNPCCustomCOMPort.SetBitStatus(var AField: Boolean; ABitFlag: Cardinal);
{$IFDEF UNIX}
var TempStatus : Cardinal;
    Res : Integer;
{$ENDIF}
begin
 if not Active then Exit;
 {$IFDEF UNIX}
  TempStatus := 0;
  Res := -1;
  Res := FpIOCtl(FHandle,TIOCMGET,@TempStatus);
  if Res = -1 then
   begin
    SetLastError(fpgeterrno);
    Exit;
   end;

  if AField then TempStatus := TempStatus or ABitFlag
   else TempStatus := TempStatus and (not ABitFlag);

  Res := FpIOCtl(FHandle,TIOCMSET,@TempStatus);
  if Res = -1 then
   begin
    SetLastError(fpgeterrno);
    Exit;
   end;

  GetBitStatus(AField,ABitFlag);
 {$ELSE}
   if not EscapeCommFunction(FHandle,ABitFlag) then
    begin
     SetLastError(GetLastOSError,'TNPCCustomCOMPort.SetBitStatus');
     Exit;
    end;
 {$ENDIF}
end;

procedure TNPCCustomCOMPort.SetLEEnable(AValue: Boolean);
begin
  if FLEEnable=AValue then Exit;
  {$IFDEF UNIX}SetBitStatus(AValue,TIOCM_LE){$ENDIF};
  if FLEEnable=AValue then Exit;
  FLEEnable:=AValue;
  if not Assigned(FMonitorThread) then
   if Assigned(FOnLEChange) then FOnLEChange(Self);
end;

procedure TNPCCustomCOMPort.SetCTSEnable(AValue: Boolean);
begin
  if FCTSEnable=AValue then Exit;
  {$IFDEF UNIX}SetBitStatus(AValue,TIOCM_CTS);{$ENDIF}
  if FCTSEnable=AValue then Exit;
  FCTSEnable:=AValue;
  if not Assigned(FMonitorThread) then
   if Assigned(FOnCTSChange) then FOnCTSChange(Self);
end;

procedure TNPCCustomCOMPort.SetDCDEnable(AValue: Boolean);
begin
  if FDCDEnable=AValue then Exit;
  {$IFDEF UNIX}SetBitStatus(AValue,TIOCM_CAR);{$ENDIF}
  if FDCDEnable=AValue then Exit;
  FDCDEnable:=AValue;
  if not Assigned(FMonitorThread) then
   if Assigned(FOnDCDChange) then FOnDCDChange(Self);
end;

procedure TNPCCustomCOMPort.SetDSREnable(AValue: Boolean);
begin
  if FDSREnable=AValue then Exit;
  {$IFDEF UNIX}SetBitStatus(AValue,TIOCM_DSR);{$ENDIF}
  if FDSREnable=AValue then Exit;
  FDSREnable:=AValue;
  if not Assigned(FMonitorThread) then
   if Assigned(FOnDSRChange) then FOnDSRChange(Self);
end;

procedure TNPCCustomCOMPort.SetDTREnable(AValue: Boolean);
begin
  if FDTREnable=AValue then Exit;
  {$IFDEF UNIX}
   SetBitStatus(AValue,TIOCM_DTR);
  {$ELSE}
  if AValue then SetBitStatus(AValue,SETDTR)
   else SetBitStatus(AValue,CLRDTR);
  {$ENDIF}
  if FDTREnable=AValue then Exit;
  FDTREnable:=AValue;
  if not Assigned(FMonitorThread) then
   if Assigned(FOnDTRChange) then FOnDTRChange(Self);
end;

procedure TNPCCustomCOMPort.SetRNGEnable(AValue: Boolean);
begin
  if FRNGEnable=AValue then Exit;
  {$IFDEF UNIX}SetBitStatus(AValue,TIOCM_RNG);{$ENDIF}
  if FRNGEnable=AValue then Exit;
  FRNGEnable:=AValue;
  if not Assigned(FMonitorThread) then
   if Assigned(FOnRNGChange) then FOnRNGChange(Self);
end;

procedure TNPCCustomCOMPort.SetRTSEnable(AValue: Boolean);
begin
  if FRTSEnable=AValue then Exit;
  {$IFDEF UNIX}
  SetBitStatus(AValue,TIOCM_RTS);
  {$ELSE}
  if AValue then SetBitStatus(AValue,SETRTS)
   else SetBitStatus(AValue,CLRRTS);
  {$ENDIF}
  if FRTSEnable=AValue then Exit;
  FRTSEnable:=AValue;
  if not Assigned(FMonitorThread) then
   if Assigned(FOnRTSChange) then FOnRTSChange(Self);
end;

procedure TNPCCustomCOMPort.GetMonitorStatusBits;
var TempStatus : Cardinal;
    {$IFDEF UNIX}Res : Integer;{$ENDIF}
begin
 if not Active then Exit;
 TempStatus := 0;
 {$IFDEF UNIX}
 Res := FpIOCtl(FHandle,FIONREAD,@TempStatus);
 if Res = -1 then
  begin
   SetLastError(fpgeterrno);
   Exit;
  end;
 FLEEnable  := (TempStatus and TIOCM_LE)>0;
 FCTSEnable := (TempStatus and TIOCM_CTS)>0;
 FDCDEnable := (TempStatus and TIOCM_CAR)>0;
 FDSREnable := (TempStatus and TIOCM_DSR)>0;
 FDTREnable := (TempStatus and TIOCM_DTR)>0;
 FRNGEnable := (TempStatus and TIOCM_RNG)>0;
 FRTSEnable := (TempStatus and TIOCM_RTS)>0;
 {$ELSE}
 if not GetCommModemStatus(FHandle,TempStatus) then
  begin
   SetLastError(GetLastOSError,'TNPCCustomCOMPort.GetMonitorStatusBits');
   Exit;
  end;
 FLEEnable  := False;
 FCTSEnable := (TempStatus and MS_CTS_ON) <> 0;
 FDCDEnable := (TempStatus and MS_RLSD_ON) <> 0;
 FDSREnable := (TempStatus and MS_DSR_ON) <> 0;
 FDTREnable := False;
 FRNGEnable := (TempStatus and MS_RING_ON) <> 0;
 FRTSEnable := False;
 {$ENDIF}
end;

procedure TNPCCustomCOMPort.GetBitStatus(var AField: Boolean; ABitFlag: Cardinal);
var TempStatus : Cardinal;
    {$IFDEF UNIX}Res : Integer;{$ENDIF}
begin
 TempStatus := 0;
 if not Active then Exit;
 {$IFDEF UNIX}
  Res := FpIOCtl(FHandle,TIOCMGET,@TempStatus);
  if Res = -1 then
   begin
    SetLastError(fpgeterrno);
    Exit;
   end;
 {$ELSE}
  if not GetCommModemStatus(FHandle,TempStatus) then
   begin
    SetLastError(GetLastOSError,'TNPCCustomCOMPort.GetBitStatus');
    Exit;
   end;
 {$ENDIF}
 AField := (TempStatus and ABitFlag) > 0;
end;

function TNPCCustomCOMPort.GetLEEnable: Boolean;
begin
 {$IFDEF UNIX}
 Result := FLEEnable;
 GetBitStatus(FLEEnable,TIOCM_LE);
 {$ENDIF}
 Result := FLEEnable;
end;

function TNPCCustomCOMPort.GetCTSEnable: Boolean;
begin
 {$IFDEF UNIX}
 Result := FCTSEnable;
 GetBitStatus(FCTSEnable,TIOCM_CTS);
 {$ELSE}
 GetBitStatus(FCTSEnable,MS_CTS_ON);
 {$ENDIF}
 Result := FCTSEnable
end;

function TNPCCustomCOMPort.GetDCDEnable: Boolean;
begin
 {$IFDEF UNIX}
 Result := FDCDEnable;
 GetBitStatus(FDCDEnable,TIOCM_CAR);
 {$ELSE}
 GetBitStatus(FDCDEnable,MS_RLSD_ON);
 {$ENDIF}
 Result := FDCDEnable
end;

function TNPCCustomCOMPort.GetDSREnable: Boolean;
begin
 {$IFDEF UNIX}
 Result := FDSREnable;
 GetBitStatus(FDSREnable,TIOCM_DSR);
 {$ELSE}
 GetBitStatus(FDSREnable,MS_DSR_ON);
 {$ENDIF}
 Result := FDSREnable;
end;

function TNPCCustomCOMPort.GetDTREnable: Boolean;
begin
 {$IFDEF UNIX}
 Result := FDTREnable;
 GetBitStatus(FDTREnable,TIOCM_DTR);
 {$ENDIF}
 Result := FDTREnable;
end;

function TNPCCustomCOMPort.GetRNGEnable: Boolean;
begin
 {$IFDEF UNIX}
 Result := FRNGEnable;
 GetBitStatus(FRNGEnable,TIOCM_RNG);
 {$ELSE}
 GetBitStatus(FRNGEnable,MS_RING_ON);
 {$ENDIF}
 Result := FRNGEnable;
end;

function TNPCCustomCOMPort.GetRTSEnable: Boolean;
begin
 {$IFDEF UNIX}
 Result := FRTSEnable;
 GetBitStatus(FRTSEnable,TIOCM_RTS);
 {$ENDIF}
 Result := FRTSEnable;
end;

end.

