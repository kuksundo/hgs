unit LoggerWinSysEvent;

{$mode objfpc}{$H+}

interface

uses Windows, Classes, LoggerItf, syncobjs;

type

 TEventLogger = class(TObject)
  private
    FName     : String;
    FEventLog : Integer;
    FCSection : TCriticalSection;
  public
    constructor Create(Name: String);
    destructor  Destroy; override;
    procedure LogMessage(Message: String; EventType: DWord = 1; Category: Word = 0; ID: DWord = 0);
  end;

 { TWinSysEventLogger }

 TWinSysEventLogger = class(TComponent, IDLogger)//Cat)
  private
   FLogEnable     : Boolean;
   FLogLayerSet   : TLogMesTypeSet;
   FObjectName    : string;
   FEventCategory : Word;
   FEventID       : Word;
   FEventLog      : TEventLogger;
   procedure SetLogEnable(AValue: Boolean);
  public
   constructor Create(AObjectName : String); reintroduce;
   destructor  Destroy; override;
   // IDLogger
   procedure info(Source, Msg: String); stdcall;
   procedure warn(Source, Msg: String); stdcall;
   procedure error(Source, Msg: String); stdcall;
   procedure debug(Source, Msg: String); stdcall;

   class procedure LoggerRegisterEventSource(AEventSource, AEventSourcePath : String; IsRaiseExcept : Boolean = True);
   class procedure LoggerUnRegisterEventSource(AEventSource : String; IsRaiseExcept : Boolean = True);

   property LogEnable   : Boolean read FLogEnable write SetLogEnable default True;     // вести или нет лог - при установке в True активируется
   property LogLayerSet : TLogMesTypeSet read FLogLayerSet write FLogLayerSet;   // по умолчанию [lmtInfo,lmtError,lmtWarn]
  end;

procedure InitLogger;
procedure CloseLogger;
procedure SetObjectName(AName : String);

var LoggerObj : TWinSysEventLogger;


implementation

uses SysUtils,Registry;

const
  csRegEventLogSection = 'SYSTEM\CurrentControlSet\Services\EventLog\Application';

var  ObjName   : String = 'Logger';

procedure InitLogger;
begin
  if not Assigned(LoggerObj) then LoggerObj := TWinSysEventLogger.Create(ObjName);
end;

procedure CloseLogger;
begin
  if Assigned(LoggerObj) then FreeAndNil(LoggerObj);
end;

procedure SetObjectName(AName: String);
begin
  ObjName := AName;
  if Assigned(LoggerObj) then LoggerObj.FEventLog.FName := AName;
end;

{ TWinSysEventLogger }

constructor TWinSysEventLogger.Create(AObjectName: String);
begin
  inherited Create(nil);
  FObjectName  := AObjectName;
  FEventLog    := TEventLogger.Create(FObjectName);
  FLogEnable   := True;
  FLogLayerSet := [lmtInfo,lmtError,lmtWarn];
end;

destructor TWinSysEventLogger.Destroy;
begin
  FEventLog.Free;
  inherited;
end;

class procedure TWinSysEventLogger.LoggerRegisterEventSource(AEventSource, AEventSourcePath: String; IsRaiseExcept : Boolean = True);
var Reg    : TRegistry;
    RegKey : String;
begin
  // Создание ключа для EventLog
  RegKey := Format('%s\%s', [csRegEventLogSection, AEventSource]);
  try
   Reg := TRegistry.Create(KEY_WRITE);
   Reg.RootKey := HKEY_LOCAL_MACHINE;

   Reg.OpenKey(RegKey, True);
   Reg.WriteString('CategoryMessageFile', AEventSourcePath);
   Reg.WriteString('EventMessageFile', AEventSourcePath);
   Reg.WriteInteger('CategoryCount', 100);                         // Максимальное количество категорий
   Reg.WriteInteger('TypesSupported', {EVENTLOG_SUCCESS or}          // Разрешаем все типы
                                      EVENTLOG_ERROR_TYPE or
                                      EVENTLOG_WARNING_TYPE or
                                      EVENTLOG_INFORMATION_TYPE);
   Reg.Free;
  except
   if Assigned(Reg) then Reg.Free;
   if IsRaiseExcept then raise;
  end;
end;

class procedure TWinSysEventLogger.LoggerUnRegisterEventSource(AEventSource: String; IsRaiseExcept : Boolean);
var Reg: TRegistry;
begin
 try
  Reg := TRegistry.Create(KEY_ALL_ACCESS);
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.DeleteKey(Format('%s\%s', [csRegEventLogSection, AEventSource]));
  Reg.Free;
 except
  if Assigned(Reg) then Reg.Free;
  if IsRaiseExcept then raise;
 end;
end;

procedure TWinSysEventLogger.debug(Source, Msg: String); stdcall;
begin
 if not FLogEnable then Exit;
 if not (lmtDebug in FLogLayerSet) then Exit;
 FEventLog.LogMessage(Format('%s: %s',[Source,Msg]), EVENTLOG_INFORMATION_TYPE, FEventCategory, FEventID);
end;

procedure TWinSysEventLogger.error(Source, Msg: String); stdcall;
begin
 if not FLogEnable then Exit;
 if not (lmtError in FLogLayerSet) then Exit;
 FEventLog.LogMessage(Format('%s: %s',[Source,Msg]), EVENTLOG_ERROR_TYPE, FEventCategory, FEventID);
end;

procedure TWinSysEventLogger.info(Source, Msg: String); stdcall;
begin
 if not FLogEnable then Exit;
 if not (lmtInfo in FLogLayerSet) then Exit;
 FEventLog.LogMessage(Format('%s: %s',[Source,Msg]), EVENTLOG_INFORMATION_TYPE, FEventCategory, FEventID);
end;

procedure TWinSysEventLogger.warn(Source, Msg: String); stdcall;
begin
 if not FLogEnable then Exit;
 if not (lmtWarn in FLogLayerSet) then Exit;
 FEventLog.LogMessage(Format('%s: %s',[Source,Msg]), EVENTLOG_WARNING_TYPE, FEventCategory, FEventID);
end;

procedure TWinSysEventLogger.SetLogEnable(AValue: Boolean);
begin
  if FLogEnable=AValue then Exit;
  FLogEnable := AValue;
end;


{ TEventLogger }

constructor TEventLogger.Create(Name: String);
begin
  inherited Create;
  FCSection := TCriticalSection.Create;
  FName     := Name;
  FEventLog := 0;
end;

destructor TEventLogger.Destroy;
begin
  if FEventLog <> 0 then
   begin
    DeregisterEventSource(FEventLog);
    FEventLog := 0;
   end;
  FreeAndNil(FCSection);
  inherited Destroy;
end;

procedure TEventLogger.LogMessage(Message: String; EventType: DWord; Category: Word; ID: DWord);
var P: Pointer;
begin
 FCSection.Enter;
 try
  P := PChar(Utf8ToAnsi(Format('(Thread 0x%s)%s',[IntToHex(GetThreadID,8),Message])));
  if FEventLog = 0 then FEventLog := RegisterEventSource(nil, PChar(Utf8ToAnsi(FName)));
  if FEventLog = 0 then RaiseLastOSError;
  ReportEvent(FEventLog, EventType, Category, ID, nil, 1, 0, @P, nil);
 finally
  FCSection.Leave;
 end;
end;

initialization
 InitLogger;

finalization;
 CloseLogger;

end.
