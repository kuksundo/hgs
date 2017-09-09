unit UnitRMISSynLog;

interface

uses SynLog, SynCommons, mORMot;

type
  TSynLog4RMIS = class
  protected
    procedure SetLog;
  public
    //TSynLog.Add.Log(sllInfo, ' ++ Connect. '+IntToStr(self.TotalConnected+1)+' user(s).');
    fLog: TSynLog;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TSynLog4RMIS }

constructor TSynLog4RMIS.Create;
begin
  inherited;

  Self.SetLog;            //Init logs
end;

destructor TSynLog4RMIS.Destroy;
begin
  fLog.Enter(self, '::Destroy::');

  inherited;
end;

procedure TSynLog4RMIS.SetLog;
begin
  fLog := TSynLog.Add;

  with fLog.Family do
  begin
    {$IFDEF CONSOLE}
      EchoToConsole := LOG_VERBOSE;
    {$ENDIF}
    Level := LOG_VERBOSE;
    TSynLogTestLog := TSQLLog;
    RotateFileCount := 5;
    OnArchive := EventArchiveSynLZ;
    ArchiveAfterDays := 1;
    ArchivePath := ExeVersion.ProgramFilePath+'log\archive';
    PerThreadLog := ptIdentifiedInOnFile;
    DestinationPath := ExeVersion.ProgramFilePath+'log\';
    EndOfLineCRLF := true;
    AutoFlushTimeOut := 6;
  end;
end;

end.
