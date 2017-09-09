unit Logger;

{$mode objfpc}{$H+}

interface

{ Source created by Wisnu Widiarta - 23rd April 2005 }

uses
  Classes, ExtCtrls, SysUtils, SyncObjs,
  LoggerItf;

type

  TDLogger = class(TInterfacedObject, IDLogger, IDLoggerSettings)
  private
    FCSection   : TCriticalSection;
    FTmrLogger  : TTimer;
    FListLogger : TStrings;
    FlogLevel   : TLogLevel;
    function  getFormatDateTime:String;
    function  getDateTime:String;
    procedure saveToFile;
    procedure tmrSaveToFile(Sender: TObject);
    procedure Lock;
    procedure Unlock;
  protected
    FIsExternalList : Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure SetStrings(AStrings: TStrings);
  public
    // IDLogger
    procedure info(Source, Msg: String); stdcall;
    procedure warn(Source, Msg: String); stdcall;
    procedure error(Source, Msg: String); stdcall;
    procedure debug(Source, Msg: String); stdcall;
    // IDLoggerSettings
    procedure setLogLevel(logLevel: TLogLevel); stdcall;
    procedure setWriteIntervalInMinutes(minute: integer); stdcall;
    procedure setWriteIntervalInSeconds(second: integer); stdcall;

    class function getInstance(AStrings : TStrings): IDLogger;
  end;

  TFileDumper = class(TThread)
  private
    FCSection   : TCriticalSection;
    FFileName   : String;
    FListLogger : TStringList;
    procedure SaveToFile;
    procedure Lock;
    procedure Unlock;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; fileName: String; list: TStringList; CS : TCriticalSection);
  end;

implementation

//uses Forms, SyncObjs;

{ TDLogger }
var
  instance: IDLogger;

constructor TDLogger.Create;
begin
  FCSection := TCriticalSection.Create;

  FTmrLogger := TTimer.Create(nil);
  FTmrLogger.Enabled := False;
  FTmrLogger.OnTimer := @Self.tmrSaveToFile;
  Self.setWriteIntervalInSeconds(120);
  setLogLevel(llAll);

  FListLogger := TStringList.Create;
  FIsExternalList := False;
  FTmrLogger.Enabled := True;
end;

procedure TDLogger.debug(Source, Msg: String); stdcall;
begin
  if not(FlogLevel in [llDebug, llAll]) then Exit;
  Lock;
  try
    try
     FListLogger.Add('DEBUG | ' + getDateTime + ' | ' + Source + ' | ' + Msg);
    except
    end;
  finally
   Unlock;
  end;
end;

destructor TDLogger.Destroy;
begin
  saveToFile;

  if not FIsExternalList then FListLogger.Free;
  FTmrLogger.Enabled := False;
  FTmrLogger.Free;

  Instance := nil;

  FCSection.Free;

  inherited;
end;

procedure TDLogger.error(Source, Msg: String); stdcall;
begin
  if not (FlogLevel in [llError, llAll]) then Exit;
  Lock;
  try
    try
     FListLogger.Add('ERROR | ' + getDateTime + ' | ' + Source + ' | ' + Msg);
    except

    end;
  finally
    Unlock;
  end;
end;

function TDLogger.getDateTime: String;
begin
  Result := FormatDateTime(getFormatDateTime, Now);
end;

function TDLogger.getFormatDateTime: String;
begin
  Result := 'DD/MM/YYYY HH:MM:SS.ZZZ';
end;

class function TDLogger.getInstance(AStrings : TStrings): IDLogger;
var TempLogger : TDLogger;
begin
  if instance = nil then
   begin
    TempLogger := TDLogger.Create;
    TempLogger.SetStrings(AStrings);
    instance := TempLogger;
   end;

  Result := instance;
end;

procedure TDLogger.info(Source, Msg: String); stdcall;
begin
  if not (FlogLevel in [llInfo, llAll]) then Exit;
  Lock;
  try
   try
    FListLogger.Add('INFO  | ' + getDateTime + ' | ' + Source + ' | ' + Msg);
   except
   end;
  finally
   Unlock;
  end;
end;

procedure TDLogger.Lock;
begin
  FCSection.Enter;
end;

procedure TDLogger.saveToFile;
var
  fileName, dir:   String;
  listLogger: TStringList;
begin
  dir := Format('%s'+DirectorySeparator+'Logs',[ExtractFileDir(ParamStr(0))]);
  fileName := Format('%s'+DirectorySeparator+'%s.log', [dir, FormatDateTime('YYYY-MM-DD', Now)]);

  if not ForceDirectories(dir) then Exit;

  listLogger := TStringList.Create;
  try
   Lock;
   try
    try
     listLogger.Assign(FListLogger);
     FListLogger.Clear;
    except
     Exit;
    end;
   finally
    Unlock;
   end;

   TFileDumper.Create(False, fileName, listLogger, FCSection);
  finally
   listLogger.free;
  end;
end;

procedure TDLogger.setLogLevel(logLevel: TLogLevel); stdcall;
begin
  FlogLevel := logLevel;
end;

procedure TDLogger.SetStrings(AStrings: TStrings);
begin
  if not Assigned(AStrings) then Exit;
  Lock;
  try
   FListLogger.Free;
   FListLogger := AStrings;
   FIsExternalList := True;
  finally
   Unlock;
  end;
end;

procedure TDLogger.setWriteIntervalInMinutes(minute: integer); stdcall;
begin
  FTmrLogger.Enabled  := False;
  FTmrLogger.Interval := minute * 60 * 1000;
  FTmrLogger.Enabled  := True;
end;

procedure TDLogger.setWriteIntervalInSeconds(second: integer); stdcall;
begin
  FTmrLogger.Enabled  := False;
  FTmrLogger.Interval := second * 1000;
  FTmrLogger.Enabled  := True;
end;

procedure TDLogger.tmrSaveToFile(Sender: TObject);
begin
  saveToFile;
end;

procedure TDLogger.Unlock;
begin
  FCSection.Leave;
end;

procedure TDLogger.warn(Source, Msg: String); stdcall;
begin
  if not (FlogLevel in [llWarning, llAll]) then Exit;
  Lock;
  try
   try
    FListLogger.Add('WARN  | ' + getDateTime + ' | ' + Source + ' | ' + Msg);
   except
   end;
  finally
   Unlock;
  end;
end;

{ TFileDumper }

constructor TFileDumper.Create(CreateSuspended: Boolean; fileName: String;list: TStringList; CS : TCriticalSection);
begin
  inherited Create(Suspended);
  FreeOnTerminate := True;

  FCSection   := CS;
  FListLogger := TStringList.Create;
  FListLogger.Assign(list);
  FFileName   := fileName;
end;

procedure TFileDumper.Execute;
begin
  SaveToFile;
end;

procedure TFileDumper.Lock;
begin
  if  Assigned(FCSection) then FCSection.Enter;
end;

procedure TFileDumper.SaveToFile;
var
  fileName: String;
  logFile: TextFile;
  i: integer;
begin
  fileName := FFileName;
  Lock;
  try
    AssignFile(logFile, fileName);
    if {$IFDEF UNIX}FileExists{$ELSE}FileExistsUTF8{$ENDIF}(fileName) then Append(logFile)
     else Rewrite(logFile);

    i := 0;
    while (i < FListLogger.Count) do
     begin
      writeln(logFile, FListLogger[i]);
      Inc(i);
      if (i Mod 100 = 0) then Sleep(50);
     end;

    Flush(logFile);
  finally
    CloseFile(logFile);
    FListLogger.Free;
    Unlock;
  end;
end;

procedure TFileDumper.Unlock;
begin
  if Assigned(FCSection) then FCSection.Leave;
end;

initialization

 instance := nil;

finalization

 instance := nil;

end.
