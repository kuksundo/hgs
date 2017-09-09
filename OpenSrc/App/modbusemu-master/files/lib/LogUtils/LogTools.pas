unit LogTools;

{$mode objfpc}{$H+}

interface

uses
     {$IFDEF WINDOWS}
     Windows, Messages,
     {$ENDIF}
     Classes, SyncObjs, ExtCtrls,
     FileUtils,
     LogItf, LogConst, LogTypes, LogResStrings;

type

   TCustomLogObject = class(TComponent,ILog)
    protected
      FCriticalSection : TCriticalSection; //< критическая секция
      FComputerName    : String;           //< NetBios-имя машины, на которой ведётся журнал.
      FModuleName      : String;           //< Имя исполняемого модуля, который ведёт журнал.
      FFileHeader      : String;           //< Заголовок который будет прилеплен к каждому файлу лога
      FLogFormItf      : TLogProc;         //< интерфейс внешнего объекта для отображения сообщения о событии
      FLogMaxLen       : Cardinal;         //< максимальная длинна файла лога
      function  GetActive: Boolean; virtual;
      procedure SetActive(const Value: Boolean); virtual;
      function  GetLogMaxLen: Cardinal; virtual;
      procedure SetLogMaxLen(const Value: Cardinal); virtual;
      function  GetLogPath: String; virtual;
      procedure SetLogPath(const Value: String); virtual;
      function  GetSaveInterval: Cardinal; virtual;
      procedure SetSaveInterval(const Value: Cardinal); virtual;
      procedure DetectComputerName; virtual;              //< Устанавливает значение переменной @link(FComputerName). Если имя извлечь не удалось, то переменная принимает значение @link(logComputerNameUnknown). @seealso(FComputerName)
      procedure DetectModuleName; virtual;                //< Устанавливает значение переменной @link(FModuleName). Если имя извлечь не удалось, то переменная принимает значение @link(logModuleNameUnknown). @seealso(FModuleName)
      function  SafePCharToStr (const Source: PChar; const Size: Cardinal): String; virtual;//< Создаёт строку формата Delphi из строки с завершающим нулём. @param(Source Исходная строка завершающаяся нулём) @param(Size размер в байтах) @return(Строка в формате Delphi или, если строку создать не удалось, то пустая строка.)
    public
      constructor Create(AOwner: TComponent); override;
      destructor  Destroy; override;
      property LogFormItf   : TLogProc read FLogFormItf write FLogFormItf;
      function Write (const msgType:  TMsgType;
                      const msgCode:  Cardinal;
                      const msgLine1: String = '';
                      const msgLine2: String = '';
                      const msgLine3: String = ''): Integer; virtual;
    published
     property Active       : Boolean read GetActive write SetActive default False;
     property LogPath      : String  read GetLogPath write SetLogPath;
     property LogMaxLen    : Cardinal read GetLogMaxLen write SetLogMaxLen default 1048576;
     property SaveInterval : Cardinal read GetSaveInterval write SetSaveInterval default 10000;
     property FileHeader   : String read FFileHeader write FFileHeader;
   end;

   TStreamLogObject = class(TCustomLogObject)
    private
     FCurrentFile     : TFile;            //< объект текущего файла лога
     FSaveTimer       : TTimer;           //< таймер записи лога в файл
     FLogPath         : TDirectory;       //< объект каталога для ведения лога
     FMsgWnd          : HWND;
     function  GetLogFileCount: Integer;
     function  GetLogFiles(Index: Integer): TFile;
    protected
     function  GetActive: Boolean; override;
     procedure SetActive(const Value: Boolean); override;
     function  GetLogPath: String; override;
     procedure SetLogPath(const Value: String); override;
     function  GetSaveInterval: Cardinal; override;
     procedure SetSaveInterval(const Value: Cardinal); override;
     function  GetLogMaxLen: Cardinal; override;
     procedure SetLogMaxLen(const Value: Cardinal); override;

     function  GetFileExtention: String; virtual;        //< Формирует расширение файла
     function  GetCurrentFileName : String; virtual;     //< Формируем имя файла лога
     function  GetCurrentFile: TFile; virtual;           //< Получить текущий файл
     procedure GenerateCurrentFile; virtual;
     procedure SaveTimerProc(Sender : TObject); virtual; //< Процедура таймера сохранения файла
     procedure MsgWndProc(var Message: TMessage); virtual;
     function  GetLogLine ( MsgRec : PMsgRecord): string; virtual; //< Формирование строки из параметров для потока журнала. @br Функцию можно переопределить для изменения формата строки. @seealso(Write)
     procedure OnLogErrorProc(const EventTime : TDateTime; const msgType:  TMsgType;
                              const msgLine1: String = ''; const msgLine2: String = '';
                              const msgLine3: String = '');
    public
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
     function  Write (const msgType:  TMsgType;
                      const msgCode:  Cardinal;
                      const msgLine1: String = '';
                      const msgLine2: String = '';
                      const msgLine3: String = ''): Integer; override;
     property LogFileCount : Integer read GetLogFileCount;
     property LogFiles[Index : Integer] : TFile read GetLogFiles;
   end;

   TFileLogObject = class(TCustomLogObject)
    private
     FCurrentFile     : TFileStream;      //< объект текущего файла лога
     FLogPath         : string;           //< путь к каталогу размещения лога
     FFileExtention   : string;           //< расширение файла
     procedure SetFileExtention(const Value: string);
     function  GetCurrentFileName: string;
    protected
     function  GetActive: boolean; override;
     procedure SetActive(const Value: boolean); override;
     function  GetLogPath: String; override;
     procedure SetLogPath(const Value: string); override;
     function  GetLogMaxLen: Cardinal; override;
     procedure SetLogMaxLen(const Value: cardinal); override;
     function  GetSaveInterval: Cardinal; override;
     procedure SetSaveInterval(const Value: Cardinal); override;

     function  OpenCurrentFile: boolean; virtual;        //< открывает текущий файл
     procedure ReopenCurrentFile; virtual;               //< замена текущего файла
     procedure CloseCurrentFile(ReopenAction: boolean); virtual;
     function  GetLogLine (const msgType: TMsgType;
                           const msgCode: Cardinal;
                           const msgLine1, msgLine2, msgLine3: string): string; virtual; //< Формирование строки из параметров для потока журнала.
     procedure OnLogErrorProc(const EventTime : TDateTime; const msgType:  TMsgType;
                              const msgLine1: string = ''; const msgLine2: string = '';
                              const msgLine3: string = '');
    public
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
     function    Write (const msgType:  TMsgType;
                        const msgCode:  Cardinal;
                        const msgLine1: string = '';
                        const msgLine2: string = '';
                        const msgLine3: string = ''): Integer; override;
     property FileExtention   : string  read FFileExtention write SetFileExtention;
   end;

implementation

uses SysUtils;

{ TCustomLogObject }

constructor TCustomLogObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogMaxLen:=1048576;
  DetectComputerName;
  DetectModuleName;
  FCriticalSection := TCriticalSection.Create;
end;

destructor TCustomLogObject.Destroy;
begin
  FCriticalSection.Free;
  inherited;
end;

procedure TCustomLogObject.DetectComputerName;
var lpBuffer: array [0..MAX_COMPUTERNAME_LENGTH] of Char;
    lpnSize:  Cardinal;
begin
  lpnSize:= SizeOf(lpBuffer);
  if GetComputerName(lpBuffer, lpnSize) then FComputerName:= SafePCharToStr(lpBuffer, lpnSize)
  else FComputerName:= rsUnknownHost;
end;

procedure TCustomLogObject.DetectModuleName;
var lpBuffer: array [0..MAX_PATH] of Char;
    lpnSize:  Cardinal;
begin
  lpnSize:= GetModuleFileName(0, lpBuffer, SizeOf(lpBuffer));
  if lpnSize <> 0 then FModuleName:= ChangeFileExt(ExtractFileName(SafePCharToStr(lpBuffer, lpnSize)), '')
  else FModuleName:= rsUnknownApp;
end;

function TCustomLogObject.GetActive: Boolean;
begin
// заглушка
  Result := False;
end;

function TCustomLogObject.GetLogMaxLen: Cardinal;
begin
// заглушка
  Result:= 1048576;
end;

function TCustomLogObject.GetLogPath: String;
begin
// заглушка
end;

function TCustomLogObject.GetSaveInterval: Cardinal;
begin
// заглушка
  Result := 10000;
end;

function TCustomLogObject.SafePCharToStr(const Source: PChar; const Size: Cardinal): String;
begin
  try
   SetString(Result, Source, Size);
  except
   on E: EOutOfMemory do Result := '';
  end;
end;

procedure TCustomLogObject.SetActive(const Value: Boolean);
begin
// заглушка
end;

procedure TCustomLogObject.SetLogMaxLen(const Value: Cardinal);
begin
// заглушка
end;

procedure TCustomLogObject.SetLogPath(const Value: String);
begin
// заглушка
end;

procedure TCustomLogObject.SetSaveInterval(const Value: Cardinal);
begin
// заглушка
end;

function TCustomLogObject.Write(const msgType: TMsgType;
  const msgCode: Cardinal; const msgLine1, msgLine2,
  msgLine3: String): Integer;
begin
 // заглушка
 Result := 0;
end;

{ TStreamLogObject }

constructor TStreamLogObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogPath:=TDirectory.Create(Self);
  FLogPath.FileMask:='*.'+logExtension;
  FLogPath.Sorted:=True;
  FSaveTimer:=TTimer.Create(Self);
  FSaveTimer.Interval:=10000;
  FSaveTimer.OnTimer:=SaveTimerProc;
  FMsgWnd:=AllocateHWnd(MsgWndProc);
  if FMsgWnd=0 then FMsgWnd:=INVALID_HANDLE_VALUE;
end;

destructor TStreamLogObject.Destroy;
begin
  SetActive(False);
  FSaveTimer.Free;
  if FMsgWnd<>INVALID_HANDLE_VALUE then DeallocateHWnd(FMsgWnd);
  FLogPath.Free;
  inherited;
end;

procedure TStreamLogObject.GenerateCurrentFile;
var TempAttr : Integer;
begin
  FCurrentFile:=GetCurrentFile;
  if FCurrentFile=nil then
   begin
    OnLogErrorProc(Now,msgError,'TStreamLogObject.GetCurrentFile',rsGenCurFile1);
    Exit;
   end;
  FCurrentFile.FromDisk    := True;
  TempAttr:=0;
  TempAttr:=TempAttr or faArchive;
  FCurrentFile.FileAttr    := TempAttr;
  FCurrentFile.FileRewrite := True;
  FCurrentFile.FileOpen    := True;
  Write(msgInfo,0,FFileHeader);
end;

function TStreamLogObject.GetActive: Boolean;
begin
  Result:=FCurrentFile<>nil;
end;

function TStreamLogObject.GetCurrentFile: TFile;
var TempName : String;
begin
 TempName := GetCurrentFileName;
 try
  Result:=FLogPath.AddNewFile(TempName);
 except
  on E:Exception do
   begin
    OnLogErrorProc(Now,msgError,'TStreamLogObject.GetCurrentFile',E.Message);
    Result:=nil;
    Exit;
   end
 end;
end;

function TStreamLogObject.GetCurrentFileName: String;
begin
 Result := Format('%s_%s_%s.%s', [FComputerName, FModuleName, FormatDateTime('yyyymmdd_hhnnss', Now), logExtension]);
end;

function TStreamLogObject.GetFileExtention: String;
var TempPos : Integer;
    TempMask : String;
begin
  TempMask:=FLogPath.FileMask;
  TempPos:=Pos('.',TempMask);
  TempMask:=Copy(TempMask,TempPos+1,length(TempMask)-TempPos);
  Result:=TempMask;
end;

function TStreamLogObject.GetLogFileCount: Integer;
begin
  Result:=FLogPath.FileCount;
end;

function TStreamLogObject.GetLogFiles(Index: Integer): TFile;
begin
  Result:=FLogPath.Files[Index];
end;

function TStreamLogObject.GetLogLine(MsgRec : PMsgRecord): String;
var SystemTime: TDateTime;
begin
  Result:='';
  if MsgRec=nil then Exit;
  SystemTime := MsgRec^.msgTime;
  Result := Format('%s%s %s%s %s%s %s%s %-8s%s 0x%s%s %s%s %s%s %s%s',
            [FComputerName,                                       msgDelimiter,  // Хост
             FModuleName,                                         msgDelimiter,  // Приложение
             FormatDateTime('yyyy-mm-dd',   SystemTime),          msgDelimiter,  // Дата
             FormatDateTime('hh:nn:ss,zzz', SystemTime),          msgDelimiter,  // Время
             msgTypes[MsgRec^.msgType],                           msgDelimiter,  // Тип
             IntToHex(MsgRec^.msgCode,sizeof(MsgRec^.msgCode)*2), msgDelimiter,  // Код
             StrPas(MsgRec^.msgLine1),                            msgDelimiter,  // Строка1
             StrPas(MsgRec^.msgLine2),                            msgDelimiter,  // Строка2
             StrPas(MsgRec^.msgLine3),                            msgEOL]);      // Строка3

  //if Assigned(FLogFormItf)then FLogFormItf(SystemTime,MsgRec^.msgType,StrPas(MsgRec^.msgLine1),StrPas(MsgRec^.msgLine2),StrPas(MsgRec^.msgLine3));
end;

function TStreamLogObject.GetLogMaxLen: Cardinal;
begin
  Result:=FLogMaxLen;
end;

function TStreamLogObject.GetLogPath: String;
begin
  Result:=FLogPath.DirPath;
end;

function TStreamLogObject.GetSaveInterval: Cardinal;
begin
  Result:=FSaveTimer.Interval;
end;

procedure TStreamLogObject.MsgWndProc(var Message: TMessage);
var TempMsgRec :PMsgRecord;
    Line:   String;
begin
  case Message.Msg of
    WM_LOG_MSG : begin
                  TempMsgRec:= PMsgRecord(Message.WParam);
                  if TempMsgRec=nil then Exit;
                  FCriticalSection.Enter;
                  try
                   if (FCurrentFile=nil) or (not FCurrentFile.FileOpen) then Exit;
                   try
                    Line := GetLogLine(TempMsgRec);//msgType, msgCode, msgLine1, msgLine2, msgLine3);
                    FCurrentFile.FileContent.Write(PChar(Line)^,Length(Line));
                    if FCurrentFile.FileContent.Size<FLogMaxLen then Exit;

                    Line:= Format('%s%s %s%s %s%s %s%s %s%s %s%s %s%s',
                                  [FComputerName, msgDelimiter,// Хост
                                   FModuleName, msgDelimiter,  // Приложение
                                   FormatDateTime('yyyy-mm-dd', Now),   msgDelimiter,  // Дата
                                   FormatDateTime('hh:nn:ss,zzz', Now), msgDelimiter,  // Время
                                   rsInfo, msgDelimiter,                               // Тип
                                   '0x00000000', msgDelimiter,                         // Код
                                   rsFileReopen, msgEOL]);
                    FCurrentFile.FileContent.Write(PChar(Line)^,Length(Line));

                    FCurrentFile.FileOpen:=False;
                    GenerateCurrentFile;
                   except
                    on E:Exception do
                     begin
                      OnLogErrorProc(Now,msgError,'TStreamLogObject.MsgWndProc',E.Message);
                      Exit;
                     end
                   end;
                  finally
                   FCriticalSection.Leave;
                   StrDispose(TempMsgRec^.msgLine1);
                   StrDispose(TempMsgRec^.msgLine2);
                   StrDispose(TempMsgRec^.msgLine3);
                   FreeMemory(TempMsgRec);
                  end;
                 end;
  else
   DefaultHandler(Message);
  end;
end;

procedure TStreamLogObject.OnLogErrorProc(const EventTime: TDateTime; const msgType: TMsgType;
                                    const msgLine1, msgLine2, msgLine3: String);
begin
  if Assigned(FLogFormItf)then FLogFormItf(EventTime,msgType,msgLine1,msgLine2,msgLine3);
end;

procedure TStreamLogObject.SaveTimerProc(Sender: TObject);
begin
  FCriticalSection.Enter;
  try
   try
    if FCurrentFile=nil then Exit;
    FCurrentFile.Save;
   except
    on E:Exception do
     begin
      OnLogErrorProc(Now,msgError,'TStreamLogObject.SaveTimerProc',E.Message);
      Exit;
     end
   end;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TStreamLogObject.SetActive(const Value: Boolean);
var TempName : String;
begin
  if GetActive=Value then Exit;
  TempName := GetCurrentFileName;
  if Value then
   begin
    FCriticalSection.Enter;
    try
     try
      FCurrentFile:=nil;
      FLogPath.Refresh(False);
      GenerateCurrentFile;
     except
      on E:Exception do
       begin
        OnLogErrorProc(Now,msgError,'TStreamLogObject.SetActive(True)',E.Message);
        Exit;
       end
     end;
    finally
     FCriticalSection.Leave;
    end;
    FSaveTimer.Enabled:=True;
   end
  else
   begin
    if not GetActive then Exit;
    FSaveTimer.Enabled:=False;
    Write(msgInfo,0,rsFileClose);

    FCriticalSection.Enter;
    try
     try
      if FCurrentFile=nil then Exit;
      FCurrentFile.FileOpen:=False;
      FCurrentFile:=nil;
     except
      on E:Exception do
       begin
        OnLogErrorProc(Now,msgError,'TStreamLogObject.SetActive(False)',E.Message);
        Exit;
       end
     end;
    finally
     FCriticalSection.Leave;
    end;
   end;
end;

procedure TStreamLogObject.SetLogMaxLen(const Value: Cardinal);
begin
  FLogMaxLen := Value;
end;

procedure TStreamLogObject.SetLogPath(const Value: String);
begin
  if SameText(FLogPath.DirPath,Value) then Exit;

  if Active then
  begin
    FCurrentFile.FileOpen:=False;
    Write(msgInfo,0,rsFileReopen);
  end;

  FCriticalSection.Enter;
  try
   try
    FLogPath.DirPath:=Value;
    if not Active then Exit;
    FCurrentFile:=nil;
    FLogPath.Refresh(False);
    GenerateCurrentFile;
   except
    on E:Exception do
     begin
      OnLogErrorProc(Now,msgError,'TStreamLogObject.SetLogPath',E.Message);
      Exit;
     end
   end;
  finally
   FCriticalSection.Leave;
  end;
end;

procedure TStreamLogObject.SetSaveInterval(const Value: Cardinal);
var TempEnable : Boolean;
begin
  if Value=FSaveTimer.Interval then Exit;
  TempEnable:=FSaveTimer.Enabled;
  FSaveTimer.Enabled:=False;
  FSaveTimer.Interval:=Value;
  FSaveTimer.Enabled:=TempEnable;
end;

function TStreamLogObject.Write(const msgType: TMsgType; const msgCode: Cardinal; const msgLine1, msgLine2, msgLine3: String): Integer;
var  TempMsg : PMsgRecord;
     Res : integer;
     Res1 : Cardinal;
begin
  Result:=0;
  if FMsgWnd=INVALID_HANDLE_VALUE then Exit;
  TempMsg := GetMemory(sizeof(TMsgRecord));
  TempMsg^.msgTime:=Now;
  TempMsg^.msgType:=msgType;
  TempMsg^.msgCode:=msgCode;
  TempMsg^.msgLine1:=StrNew(PChar(msgLine1));
  TempMsg^.msgLine2:=StrNew(PChar(msgLine2));
  TempMsg^.msgLine3:=StrNew(PChar(msgLine3));
  Res:=SendMessageTimeout(FMsgWnd,WM_LOG_MSG,Integer(TempMsg),0,SMTO_NORMAL,1,Res1);
  if Res=0 then Result:=GetLastError
end;

{ TFileLogObject }

constructor TFileLogObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogPath:= '';
  FFileExtention:= '.' + logExtension;
end;

destructor TFileLogObject.Destroy;
begin
  CloseCurrentFile(false);
  inherited;
end;

procedure TFileLogObject.SetActive(const Value: boolean);
begin
  if GetActive = Value then Exit;

  if Value then ReopenCurrentFile
  else CloseCurrentFile(false);
end;

procedure TFileLogObject.SetLogPath(const Value: string);
begin
  if not SameText(FLogPath, Value) then FLogPath:= Value;
  if Active then ReopenCurrentFile;
end;

procedure TFileLogObject.SetFileExtention(const Value: string);
begin
  if not SameText(FFileExtention, Value) then FFileExtention:= Value;
  if Active then ReopenCurrentFile;
end;

procedure TFileLogObject.SetLogMaxLen(const Value: cardinal);
begin
  FLogMaxLen:= Value;
end;

function TFileLogObject.GetActive: boolean;
begin
  Result:= FCurrentFile <> nil;
end;

procedure TFileLogObject.ReopenCurrentFile;
begin
  CloseCurrentFile(true);
  if not OpenCurrentFile then OnLogErrorProc(Now, msgError, 'TFileLogObject.OpenCurrentFile', rsGenCurFile1);
end;

function TFileLogObject.OpenCurrentFile: boolean;
var TempName : string;
begin
  Result:= false;

  TempName:= GetCurrentFileName;
  FCriticalSection.Enter;
  try
    if FCurrentFile <> nil then exit;
    try
      if not DirectoryExists(FLogPath) then
      begin
        if not ForceDirectories(FLogPath) then RaiseLastOSError;
      end;

      FCurrentFile:= TFileStream.Create(TempName, fmCreate);
      FCurrentFile.Free;
      FCurrentFile:= TFileStream.Create(TempName, fmOpenWrite or fmShareDenyWrite);
      Result:= FCurrentFile <> nil;
      if Result then Write(msgInfo,0,FFileHeader);
    except
      on E:Exception do
      begin
        OnLogErrorProc(Now, msgError, 'TFileLogObject.OpenCurrentFile',E.message);
        Exit;
      end;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TFileLogObject.CloseCurrentFile(ReopenAction: boolean);
var Line: string;
begin
  if FCurrentFile = nil then exit;
  FCriticalSection.Enter;
  try
    try
      if ReopenAction then Line:= GetLogLine(msgInfo, 0, rsFileReopen, '', '')
      else Line:= GetLogLine(msgInfo, 0, rsFileClose, '', '');
      FCurrentFile.WriteBuffer(PChar(Line)^, Length(Line));

      FCurrentFile.Free;
      FCurrentFile:= nil;
    except
      on E:Exception do
      begin
        OnLogErrorProc(Now, msgError, 'TFileLogObject.CloseCurrentFile',E.message);
        Exit;
      end;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

function TFileLogObject.GetCurrentFileName: string;
begin
  Result:= Format('%s\%s_%s_%s%s', [FLogPath, FComputerName, FModuleName, FormatDateTime('yyyymmdd_hhnnss', Now), FFileExtention]);
end;

function TFileLogObject.GetLogLine(const msgType: TMsgType;
                                   const msgCode: Cardinal;
                                   const msgLine1, msgLine2, msgLine3: string): string;
var SystemTime: TDateTime;
begin
  Result:= '';
  SystemTime:= Now;
  Result:= Format('%s%s %s%s %s%s %s%s %-8s%s 0x%s%s %s%s %s%s %s%s',
           [FComputerName, msgDelimiter,  // Хост
            FModuleName, msgDelimiter,    // Приложение
            FormatDateTime('yyyy-mm-dd', SystemTime), msgDelimiter,    // Дата
            FormatDateTime('hh:nn:ss,zzz', SystemTime), msgDelimiter,  // Время
            msgTypes[msgType], msgDelimiter,                           // Тип
            IntToHex(msgCode, sizeof(msgCode)*2), msgDelimiter,        // Код
            msgLine1, msgDelimiter,  // Строка1
            msgLine2, msgDelimiter,  // Строка2
            msgLine3, msgEOL]);      // Строка3

end;

function TFileLogObject.Write(const msgType: TMsgType;
                              const msgCode: Cardinal;
                              const msgLine1, msgLine2, msgLine3: string): Integer;
var Line: string;
begin
  Result:= 0;
  FCriticalSection.Enter;
  try
    try
      if FCurrentFile = nil then exit;

      Line:= GetLogLine(msgType, msgCode, msgLine1, msgLine2, msgLine3);
      FCurrentFile.WriteBuffer(PChar(Line)^, Length(Line));
    except
      on E:Exception do
      begin
        OnLogErrorProc(Now, msgError, 'TFileLogObject.Write',E.message);
        Result:= GetLastError;
      end;
    end;
  finally
    FCriticalSection.Leave;
  end;

  if FCurrentFile.Size >= FLogMaxLen then ReopenCurrentFile;
end;

procedure TFileLogObject.OnLogErrorProc(const EventTime: TDateTime;
  const msgType: TMsgType; const msgLine1, msgLine2, msgLine3: string);
begin
  if Assigned(FLogFormItf)then FLogFormItf(EventTime,msgType,msgLine1,msgLine2,msgLine3);
end;

function TFileLogObject.GetSaveInterval: Cardinal;
begin
 // заглушка
 Result := 10000;
end;

procedure TFileLogObject.SetSaveInterval(const Value: Cardinal);
begin
 // заглушка
end;

function TFileLogObject.GetLogMaxLen: Cardinal;
begin
  Result:=FLogMaxLen;
end;

function TFileLogObject.GetLogPath: String;
begin
  Result:=FLogPath;
end;

end.
