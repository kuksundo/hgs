unit LoggerItf;

{$mode objfpc}{$H+}

interface

uses classes;

type
  TLogLevel = (llDebug = 0, llError = 1, llWarning = 2, llInfo = 3, llAll = 4);
  TLogDestEnum = (ldSyslog,ldFile,ldMemo);
  TLogMesTypeEnum = (lmtInfo,lmtDebug,lmtWarn,lmtError);
  TLogMesTypeSet = set of TLogMesTypeEnum;

const
  LogMesTypeStrings : array [TLogMesTypeEnum] of string = ('Info','Debug','Warning','Error');

  csLogDestSysName    = 'Syslog';
  csLogDestFileName   = 'File';
  csLogDestMemoName   = 'Memo';

  csDefLogEnable      = True;
  csDefLogSections    = 'Error,Info,Warning,Debug';
  csDefLogLayerSet    = [lmtError,lmtInfo,lmtWarn,lmtDebug];
  csDefLogDest        = ldSyslog;
  csLogSectionError   = 'Error';
  csLogSectionInfo    = 'Info';
  csLogSectionWarning = 'Warning';
  csLogSectionDebug   = 'Debug';

  csDefLogDestName    = csLogDestSysName;

type
  IDLoggerSimple = interface
  ['{0491ABBA-D11D-B211-9871-E0CB4E44D5C7}']
   procedure Info(AMessage : String); stdcall;    // обёртка записи информационнго события
   procedure Debug(AMessage : String); stdcall;   // обёртка записи отладочного события
   procedure Warning(AMessage : String); stdcall; // обёртка записи предупреждения
   procedure Error(AMessage : String); stdcall;   // обёртка записи сообщения об ошибке
  end;

  IDLogger = interface
  ['{3CA57EF2-CAD8-4C16-B219-B2048C4C2789}']
   procedure info(Source, Msg: String); stdcall;
   procedure warn(Source, Msg: String); stdcall;
   procedure error(Source, Msg: String); stdcall;
   procedure debug(Source, Msg: String); stdcall;
  end;

  IDLoggerCat = interface(IDLogger)
  ['{50EA3D84-D9B5-45C3-A9D7-CF7A05C1E038}']
   procedure SetEventCategoryAndID(AEventCategory : Word; AEventID : Word); stdcall;
  end;

  IDLoggerSettings = interface
  ['{577D8FB8-A04C-4619-A0C6-1F8ABAF66916}']
   procedure setLogLevel(logLevel: TLogLevel); stdcall;
   procedure setWriteIntervalInMinutes(minute: integer); stdcall;
   procedure setWriteIntervalInSeconds(second: integer); stdcall;
  end;

  IDLoggerLinuxSysLogSettings = interface
  ['{2A222EAE-D11D-B211-9871-E0CB4E44D5C7}']
   procedure setOwnerName(OwnName : String); stdcall;
   procedure setLogLayerSet(TypesSet : TLogMesTypeSet); stdcall;
   function  getLogLayerSet :TLogMesTypeSet; stdcall;
   procedure Activate; stdcall;
   procedure DeActivate;stdcall;
  end;

  TComponentLogged = class(TComponent)
  protected
   FLogger : IDLogger;
   procedure SendLogMessage(MsgType : TLogLevel; Source, Msg : string);
   procedure SetLogger(const AValue: IDLogger); virtual;
  public
   destructor  Destroy; override;
   property Logger : IDLogger read FLogger write SetLogger;
  end;

  TThreadLogged = class(TThread)
  protected
   FLogger : IDLogger;
   procedure SendLogMessage(MsgType : TLogLevel; Source, Msg : string);
   procedure SetLogger(const AValue: IDLogger); virtual;
  public
   destructor  Destroy; override;
   property Logger : IDLogger read FLogger write SetLogger;
  end;

  TObjectLogged = class
  protected
   FLogger : IDLogger;
   procedure SendLogMessage(MsgType : TLogLevel; Source, Msg : string);
   procedure SetLogger(const AValue: IDLogger); virtual;
  public
   destructor  Destroy; override;
   property Logger : IDLogger read FLogger write SetLogger;
  end;

  TPersistentLogged = class(TPersistent)
   protected
    FLogger : IDLogger;
    procedure SendLogMessage(MsgType : TLogLevel; Source, Msg : string);
    procedure SetLogger(const AValue: IDLogger); virtual;
   public
    destructor  Destroy; override;
    property Logger : IDLogger read FLogger write SetLogger;
  end;

  TInterfacedObjectLogged = class(TInterfacedObject)
  protected
   FLogger : IDLogger;
   procedure SendLogMessage(MsgType : TLogLevel; Source, Msg : string);
   procedure SetLogger(const AValue: IDLogger); virtual;
  public
   constructor Create; virtual;
   destructor  Destroy; override;
   function AddRef : longint;
   function Release : LongInt;
   property Logger : IDLogger read FLogger write SetLogger;
  end;

  TListLogged = class(TList)
  protected
   FLogger : IDLogger;
   procedure SendLogMessage(MsgType : TLogLevel; Source, Msg : string);
   procedure SetLogger(const AValue: IDLogger); virtual;
  public
   destructor  Destroy; override;
   property Logger : IDLogger read FLogger write SetLogger;
  end;

  TInterfaceListLogged = class(TInterfaceList)
  protected
   FLogger : IDLogger;
   procedure SendLogMessage(MsgType : TLogLevel; Source, Msg : string);
   procedure SetLogger(const AValue: IDLogger); virtual;
  public
   destructor  Destroy; override;
   property Logger : IDLogger read FLogger write SetLogger;
  end;

function GetLogDestFromString(ALogDest : String): TLogDestEnum;
function GetLogLayerFromString(ALayers : String):TLogMesTypeSet;
function IsLogLayerPresent(ALayers : String; AlayerName : String) : Boolean;
function GetStringFromMesTypeSet(ATypeSet : TLogMesTypeSet) : String;

implementation

uses SysUtils;

function GetStringFromMesTypeSet(ATypeSet : TLogMesTypeSet) : String;
begin
 Result := '';
 if ATypeSet = [] then Exit;
 if lmtDebug in ATypeSet then
   if Result = '' then Result := csLogSectionDebug
    else Result := Result+','+csLogSectionDebug;
 if lmtError in ATypeSet then
   if Result = '' then Result := csLogSectionError
    else Result := Result+','+csLogSectionError;
 if lmtInfo in ATypeSet then
   if Result = '' then Result := csLogSectionInfo
    else Result := Result+','+csLogSectionInfo;
 if lmtWarn in ATypeSet then
   if Result = '' then Result := csLogSectionWarning
    else Result := Result+','+csLogSectionWarning;
end;

function GetLogLayerFromString(ALayers : String):TLogMesTypeSet;
var TempPos : PChar;
begin
 Result := csDefLogLayerSet;
 if ALayers = '' then Exit;
 Result := [];
 TempPos := nil;
 TempPos := strpos(PChar(UpperCase(ALayers)),PChar(UpperCase(csLogSectionError)));
 if Assigned(TempPos) then Result += [lmtError];
 TempPos := nil;
 TempPos := strpos(PChar(UpperCase(ALayers)),PChar(UpperCase(csLogSectionDebug)));
 if Assigned(TempPos) then Result += [lmtDebug];
 TempPos := nil;
 TempPos := strpos(PChar(UpperCase(ALayers)),PChar(UpperCase(csLogSectionInfo)));
 if Assigned(TempPos) then Result += [lmtInfo];
 TempPos := nil;
 TempPos := strpos(PChar(UpperCase(ALayers)),PChar(UpperCase(csLogSectionWarning)));
 if Assigned(TempPos) then Result += [lmtWarn];
end;

function IsLogLayerPresent(ALayers: String; AlayerName: String): Boolean;
var TempPos : PChar;
begin
 Result := False;
 TempPos := strpos(PChar(UpperCase(ALayers)),PChar(UpperCase(AlayerName)));
 Result := Assigned(TempPos);
end;

function GetLogDestFromString(ALogDest : String): TLogDestEnum;
begin
 Result := csDefLogDest;
 if SameText(ALogDest,csLogDestSysName) then Result := ldSyslog
  else
   if SameText(ALogDest,csLogDestFileName) then Result := ldFile
    else
     if SameText(ALogDest,csLogDestMemoName) then Result := ldMemo;
end;

{ TPersistentLogged }

procedure TPersistentLogged.SendLogMessage(MsgType: TLogLevel; Source, Msg: string);
begin
  if FLogger = nil then Exit;
  case MsgType of
    llInfo    : FLogger.info(Source, Msg);
    llWarning : FLogger.warn(Source, Msg);
    llError   : FLogger.error(Source, Msg);
    llDebug   : FLogger.debug(Source, Msg);
  end;
end;

procedure TPersistentLogged.SetLogger(const AValue: IDLogger);
begin
  FLogger := AValue;
end;

destructor TPersistentLogged.Destroy;
begin
  FLogger := nil;
  inherited Destroy;
end;

{ TInterfaceListLogged }

procedure TInterfaceListLogged.SendLogMessage(MsgType : TLogLevel; Source, Msg : string);
begin
  if FLogger = nil then Exit;
  case MsgType of
    llInfo    : FLogger.info(Source, Msg);
    llWarning : FLogger.warn(Source, Msg);
    llError   : FLogger.error(Source, Msg);
    llDebug   : FLogger.debug(Source, Msg);
  end;
end;

procedure TInterfaceListLogged.SetLogger(const AValue : IDLogger);
begin
  FLogger := AValue;
end;

destructor TInterfaceListLogged.Destroy;
begin
  FLogger := nil;
  inherited Destroy;
end;

{ TListLogged }

procedure TListLogged.SendLogMessage(MsgType : TLogLevel; Source,Msg : string);
begin
  if FLogger = nil then Exit;
  case MsgType of
    llInfo    : FLogger.info(Source, Msg);
    llWarning : FLogger.warn(Source, Msg);
    llError   : FLogger.error(Source, Msg);
    llDebug   : FLogger.debug(Source, Msg);
  end;
end;

procedure TListLogged.SetLogger(const AValue : IDLogger);
begin
  FLogger := AValue;
end;

destructor TListLogged.Destroy;
begin
  FLogger := nil;
  inherited Destroy;
end;

{ TComponentLogged }

destructor TComponentLogged.Destroy;
begin
  FLogger := nil;
  inherited;
end;

procedure TComponentLogged.SendLogMessage(MsgType: TLogLevel; Source, Msg: string);
begin
  if FLogger = nil then Exit;
  case MsgType of
    llInfo    : FLogger.info(Source, Msg);
    llWarning : FLogger.warn(Source, Msg);
    llError   : FLogger.error(Source, Msg);
    llDebug   : FLogger.debug(Source, Msg);
  end;
end;

procedure TComponentLogged.SetLogger(const AValue: IDLogger);
begin
  FLogger := AValue;
end;

{ TThreadLogged }

destructor TThreadLogged.Destroy;
begin
  FLogger := nil;
  inherited;
end;

procedure TThreadLogged.SendLogMessage(MsgType: TLogLevel; Source, Msg: string);
begin
  if FLogger = nil then Exit;
  case MsgType of
    llInfo    : FLogger.info(Source, Msg);
    llWarning : FLogger.warn(Source, Msg);
    llError   : FLogger.error(Source, Msg);
    llDebug   : FLogger.debug(Source, Msg);
  end;
end;

procedure TThreadLogged.SetLogger(const AValue: IDLogger);
begin
  FLogger := AValue;
end;

{ TObjectLogged }

destructor TObjectLogged.Destroy;
begin
  FLogger := nil;
  inherited;
end;

procedure TObjectLogged.SendLogMessage(MsgType: TLogLevel; Source, Msg: string);
begin
  if FLogger = nil then Exit;
  case MsgType of
    llInfo    : FLogger.info(Source, Msg);
    llWarning : FLogger.warn(Source, Msg);
    llError   : FLogger.error(Source, Msg);
    llDebug   : FLogger.debug(Source, Msg);
  end;
end;

procedure TObjectLogged.SetLogger(const AValue: IDLogger);
begin
  FLogger := AValue;
end;

{ TInterfacedObjectLogged }

destructor TInterfacedObjectLogged.Destroy;
begin
  FLogger := nil;
  inherited;
end;

function TInterfacedObjectLogged.AddRef: longint;
begin
  Result := _AddRef;
end;

function TInterfacedObjectLogged.Release: LongInt;
begin
  Result := _Release;
end;

procedure TInterfacedObjectLogged.SendLogMessage(MsgType: TLogLevel; Source, Msg: string);
begin
  if FLogger = nil then Exit;
  case MsgType of
    llInfo    : FLogger.info(Source, Msg);
    llWarning : FLogger.warn(Source, Msg);
    llError   : FLogger.error(Source, Msg);
    llDebug   : FLogger.debug(Source, Msg);
  end;
end;

procedure TInterfacedObjectLogged.SetLogger(const AValue: IDLogger);
begin
  FLogger := AValue;
end;

constructor TInterfacedObjectLogged.Create;
begin
  FLogger := nil;
end;

end.
