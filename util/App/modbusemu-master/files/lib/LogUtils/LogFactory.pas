unit LogFactory;

{$mode objfpc}{$H+}

interface

uses LogItf;

type
   TLoggerType = (ltFile,ltStream);

   TLogSingletonFactory = class
    protected
     constructor Create;            // Заглушка
     destructor  Destroy; override; // Заглушка
    public
     class function  GetLoggerTypeStr(AType: TLoggerType): string;
     class function  ActivateLog(LogDirPath : String; LogMaxLen : Cardinal =1048576; SaveInterval : Cardinal=1000): ILog;
     class function  GetLoItf : ILog;
     class procedure SetLogHeader(Header : String);              // устанавливает заголовок для каждого файла лога
     class function  SetLoggerType(lgType : TLoggerType): ILog;  // изменяет тип логера и возвращает новый интерфейс если логер был ранее активирован
     class procedure SetLogFormItf(LogFormItf : TLogProc);
     class procedure DeActivateLog;
   end;


implementation

uses LogTools, DateUtils, SysUtils, LogResStrings;

var Log        : TCustomLogObject;
    LogHeader  : String;
    LoggerType : TLoggerType;

{ TLogSingletonFactory }

class function TLogSingletonFactory.GetLoggerTypeStr(AType: TLoggerType): string;
begin
  case AType of
   ltFile: Result:= rsLogFileType;
 ltStream: Result:= rsLogSteramType;
      else Result:= rsUnknownType;
  end;
end;

class function TLogSingletonFactory.ActivateLog(LogDirPath: String; LogMaxLen : Cardinal; SaveInterval : Cardinal): ILog;
begin
  if not Assigned(Log) then
   begin
     case LoggerType of
      ltFile   : Log:= TFileLogObject.Create(nil);
      ltStream : Log:= TStreamLogObject.Create(nil);
     end;
   end;
  Result:=Log;
  if Result <> nil then
  begin
    Log.LogPath:=LogDirPath;
    Log.SaveInterval:=SaveInterval;
    Log.LogMaxLen:=LogMaxLen;
//    Log.FileHeader:=format(rsHeader, [LogHeader, GetLoggerTypeStr(LoggerType)]);
    Log.FileHeader:=LogHeader;
    Log.Active:=True;
  end;  
end;

class procedure TLogSingletonFactory.DeActivateLog;
begin
  Log.Active:=False;
  Log:=nil;
end;

constructor TLogSingletonFactory.Create;
begin
 // заглушка
end;

destructor TLogSingletonFactory.Destroy;
begin
  // заглушка
  inherited;
end;

class procedure TLogSingletonFactory.SetLogFormItf(LogFormItf: TLogProc);
begin
  if not Assigned(Log) then Log:=TFileLogObject.Create(nil);
  Log.LogFormItf:=LogFormItf;
end;

class function TLogSingletonFactory.GetLoItf: ILog;
begin
  Result:=Log;
end;

class procedure TLogSingletonFactory.SetLogHeader(Header: String);
begin
  LogHeader:=Header;
  if Assigned(Log) then Log.FileHeader:=LogHeader;
end;

class function TLogSingletonFactory.SetLoggerType(lgType: TLoggerType): ILog;
var TempLogDirPath   : String;
    TempSaveInterval : Cardinal;
    TempLogMaxLen    : Cardinal;
begin
  Result:=nil;
  LoggerType:=lgType;
  if Log=nil then Exit;
  TempLogDirPath   := Log.LogPath;
  TempSaveInterval := Log.SaveInterval;
  TempLogMaxLen    := Log.LogMaxLen;
  DeActivateLog;
  Result:=ActivateLog(TempLogDirPath,TempLogMaxLen,TempSaveInterval);
end;

initialization
  LoggerType:=ltFile;

end.
