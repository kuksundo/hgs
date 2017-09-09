unit u_dzConsoleLogger;

interface

uses
  u_dzLogging;

type
  TConsoleLogger = class(TAbstractLogger, ILogger)
  protected
    procedure Log(const _s: string; _Level: TLogLevel = llDump); override;
  end;

implementation

{ TConsoleLogger }

procedure TConsoleLogger.Log(const _s: string; _Level: TLogLevel);
begin
  if IsConsole then
    WriteLn(LogLevel2Str(_Level) + ': ' + _s);
end;

end.

