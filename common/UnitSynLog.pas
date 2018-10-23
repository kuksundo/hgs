unit UnitSynLog;

interface

uses SynLog, mORMot, SynCommons, System.SysUtils;

procedure InitSynLog;
procedure DoLog(Amsg: string; ALogDate: Boolean = False;
  AMsgLevel: TSynLogInfo = sllEnter);

implementation

{»ç¿ë¹ý:
var
  ILog: ISynLog;

  ILog := TSQLLog.Enter;
  ILog.Log(sllInfo,LStr);
}
procedure InitSynLog;
begin
  with TSynLog.Family do begin
//    Level := LOG_VERBOSE;
//    Level := [sllException,sllExceptionOS];
    Level := [sllEnter];
//    EchoToConsole := LOG_VERBOSE; // log all events to the console
//    PerThreadLog := true;
//    PerThreadLog := ptOneFilePerThread;
//    HighResolutionTimeStamp := true;
//    AutoFlushTimeOut := 5;
//    OnArchive := EventArchiveSynLZ;
//    OnArchive := EventArchiveZip;
//    CustomFileName := '';
    NoEnvironmentVariable := True;
    ArchiveAfterDays := 1; // archive after one day
//    ArchivePath := '\\Remote\WKS2302\Archive\Logs'; // or any path
    DestinationPath := 'C:\Temp\Logs';
//    EchoCustom := aMyClass.Echo; // register third-party logger
//    NoFile := true; // ensure TSynLog won't use the default log file
    RotateFileCount := 5;    // will maintain a set of up to 5 files
    RotateFileSizeKB := 1024;//20*1024; // rotate by 20 MB logs
    RotateFileDailyAtHour := 0; //23;  rotate at 11:00 PM
//    FileExistsAction := acAppend;
  end;
end;

procedure DoLog(Amsg: string; ALogDate: Boolean = False;
  AMsgLevel: TSynLogInfo = sllEnter);
var
  ILog: ISynLog;
begin
  if ALogDate then
    AMsg := DateTimeToStr(now) + ':: ' + AMsg;

  ILog := TSynLog.Enter;
  ILog.Log(AMsgLevel, Amsg);
end;

end.
