{ $Id: DebugTools.pas 1509 2007-05-21 03:04:33Z mm $ }
unit DebugTools;
{<
@abstract Various debugging tools
@author matthias muntwiler <mm@kspace.ch>
@created 2006-05-07
@cvs $Date: 2007-05-20 22:04:33 -0500 (So, 20 Mai 2007) $
}

interface
uses
  Windows, SysUtils, Classes, SyncObjs;

type
  { @abstract Stop watch for profiling
    Measures the execution time between calls to its @link(Stop) method
    using the performance counter of the system,
    and outputs the results to the Event Log of the debugger.

    Each sequence must be started with @link(Start),
    which can be followed by a maximum number of @link(Stop) calls.
    The results can then be sent to the debugger by calling
    @link(OutputSingleline) or @link(OutputMultiline).
    Afterwards, the sequence can start with @link(Start) again.

    These profiling methods are conceived for limited use
    in test versions only as they may affect performance.
    Do not use this class in release versions.
  }
  TDebugStopWatch = class
  strict private
    // performance profiling
    PerformanceFrequency: int64;
    stopidx: integer;
    stoptime: array of int64;
    stopcontext: array of string;
  public
    { Initializes the stop watch.
      @param(buflen is the number of stop times that the watch can store
        before they have to be output to the debugger.)
    }
    constructor Create(buflen: cardinal = 10);
    { Resets the stop watch buffer and records the start time.
      @returns(@true if the stop watch is ready (i.e.
        a performance counter is present), @false otherwise. }
    function  Start: boolean;
    { Records the current performance time with a context string
      in an array.
      The method can be called repeatedly for the number of times
      set with the constructor.
      @param(context should describe the action carried out during the last
        interval. If a single line output is used, this string should be as
        short as possible, e.g. 't1:'.)
      @returns(@true if the time was recorded,
        @false if the limit of stop times is exceeded. }
    function  Stop(const context: string): boolean;
    { Sends the time delays between recorded @link(StopWatch) calls
      in a multi-line format to the debugger.
      The output is sent only if @link(DebugVersion) = @true,
      otherwise the call is ignored.
      @returns @true if the output string has been sent, @false otherwise
      @seealso OutputSingleline
    }
    function  OutputMultiline(const title: string): boolean;
    { Sends the time delays between subsequent recorded @link(StopWatch) calls
      in a single-line format to the debugger.
      The title and context strings as well as the number of stop times
      should be short enough to fit on a single line.
      The output is sent only if @link(DebugVersion) = @true,
      otherwise the call is ignored.
      @returns @true if the output string has been sent, @false otherwise
      @seealso OutputMultiline
    }
    function  OutputSingleline(const title: string): boolean;
  end;

type
  { @abstract(Links to an open text file for logging purpose.)
    Only the public AddXxxx methods are thread-safe. }
  TLogFile = class
  private
    FFileName: string;
    FFileOpen: boolean;
    FLogTickCount: boolean;
    FFileSection: TCriticalSection;
    FLogLevel: integer;
    procedure SetFileName(const Value: string);
    procedure SetLogLevel(const Value: integer);
  protected
    logfile: system.text;
    procedure OpenFile;
    procedure CloseFile;
    procedure InternalAddEntry(const message: string);
  public
    { Creates and opens a new log file.
      @param(filenameroot specifies a prefix of the log file name.
        It can also contain a path,
        otherwise the file is written to the user's application data folder.
        The method adds an incremental index to the file name
        if other log files exist in the destination folder.)}
    constructor Create(const filenameroot: string);
    { Just creates the object but doesn't open a file.
      I don't know why this constructor exists.
      Maybe, it is meant for subclasses that open the file themselves.
      There are no public methods that open a file. }
    constructor CreateEmpty;
    { Adds message and the system time as a new line to the end of the log file
      if level <= @link(LogLevel).
      This method is thread-safe. }
    procedure AddEntry(const message: string; level: integer=0);
    { Calls Flush. I'm not sure whether this has any effect. }
    procedure FlushFile;
    { Closes the file, and destroys the object instance.
      The method is thread-safe,
      i.e. it does not interrupt an ongoing write access.
      But take care in which thread the object is destroyed. }
    destructor Destroy; override;
    { File name of the log file including path.
      Assigning to this property closes the previous log file,
      and opens a new one. }
    property  FileName: string read fFileName write SetFileName;
    { Defines if the system tick count is reported along with the system time.
      Default: false. }
    property  LogTickCount: boolean read fLogTickCount write fLogTickCount;
    { Defines which messages to log.
      Only messages with level<=LogLevel appear in the log.
      Default: 0.
      You can only increase the log level by assignment to this property. }
    property  LogLevel: integer read FLogLevel write SetLogLevel;
  end;

{ Returns a global @link(TLogFile) object for debugging. }
function DebugLog: TLogFile;

implementation
uses
  JclDebug, JclSysInfo;

var
  DebugVersion: boolean;

{ TDebugStopWatch }

constructor TDebugStopWatch.Create(buflen: cardinal);
begin
  inherited Create;
  if buflen < 10 then buflen := 10;
  SetLength(stoptime, buflen + 1);
  SetLength(stopcontext, buflen + 1);
  QueryPerformanceFrequency(PerformanceFrequency);
end;

function TDebugStopWatch.Start;
begin
  stopidx := 1;
  result :=
    QueryPerformanceFrequency(PerformanceFrequency) and
    QueryPerformanceCounter(stoptime[0]);
end;

function TDebugStopWatch.Stop;
begin
  if
    (stopidx <= High(stoptime)) and
    QueryPerformanceCounter(stoptime[stopidx])
  then begin
    stopcontext[stopidx] := context;
    Inc(stopidx);
    result := true;
  end else
    result := false;
end;

function TDebugStopWatch.OutputMultiline;
var
  i: integer;
  interval: double;
begin
  if DebugVersion then begin
    result := stopidx > 1;
    for i := 1 to stopidx - 1 do begin
      interval := (stoptime[i] - stoptime[i-1]) / PerformanceFrequency;
      TraceFmt('%s: %s %.6fs', [title, stopcontext[i], interval]);
    end;
  end else
    result := false;
end;

function TDebugStopWatch.OutputSingleline;
var
  i: integer;
  interval: double;
  output: string;
begin
  if DebugVersion then begin
    result := stopidx > 1;
    output := title + ': ';
    for i := 1 to stopidx - 1 do begin
      interval := (stoptime[i] - stoptime[i-1]) / PerformanceFrequency;
      if i > 1 then output := output + ', ';
      output := output + Format('%s %.6fs', [stopcontext[i], interval]);
    end;
    if result then
      TraceMsg(output);
  end else
    result := false;
end;

var
  GlobalDebugLog: TLogFile;

function DebugLog: TLogFile;
begin
  if not Assigned(GlobalDebugLog) then begin
    GlobalDebugLog := TLogFile.Create(ExtractFileName(ParamStr(0)));
    GlobalDebugLog.LogTickCount := true;
    GlobalDebugLog.AddEntry('Starting DebugLog');
  end;
  result := GlobalDebugLog;
end;

{ TLogFile }

constructor TLogFile.Create;
var
  newfilenameroot, newfilename: string;
  idx: cardinal;
begin
  inherited Create;
  ffileopen := false;
  fFileName := '';
  fLogTickCount := false;
  FLogLevel := 0;
  FFileSection := TCriticalSection.Create;
  if (Pos(PathDelim, filenameroot) = 0) or
    not DirectoryExists(ExtractFileDir(filenameroot))
  then
    newfilenameroot := IncludeTrailingPathDelimiter(GetAppdataFolder) +
      ExtractFileName(filenameroot);
  idx := 1;
  repeat
    newfilename := Format(newfilenameroot + '%u.log', [idx]);
    Inc(idx);
  until not FileExists(newfilename);
  fFilename := newfilename;
  try
    OpenFile;
  except
    on EInOutError do ffileopen := false;
  end;
end;

constructor TLogFile.CreateEmpty;
begin
  inherited Create;
  fFileOpen := false;
  fFilename := '';
  fLogTickCount := false;
  FLogLevel := 0;
  FFileSection := TCriticalSection.Create;
end;

procedure TLogFile.SetFileName(const Value: string);
begin
  CloseFile;
  fFileName := Value;
  OpenFile;
end;

procedure TLogFile.OpenFile;
begin
  FFileSection.Enter;
  try
    Assign(logfile, FFileName);
    Rewrite(logfile);
    FFileOpen := true;
  finally
    FFileSection.Leave;
  end;
end;

procedure TLogFile.FlushFile;
begin
  FFileSection.Enter;
  try
    Flush(logfile);
  finally
    FFileSection.Leave;
  end;
end;

procedure TLogFile.CloseFile;
begin
  FFileSection.Enter;
  try
    if ffileopen then Close(logfile);
    ffileopen := false;
  finally
    FFileSection.Leave;
  end;
end;

destructor TLogFile.Destroy;
begin
  CloseFile;
  FFileSection.Free;
  inherited;
end;

procedure TLogFile.SetLogLevel(const Value: integer);
begin
  FFileSection.Enter;
  try
    if Value > FLogLevel then begin
      FLogLevel := Value;
      InternalAddEntry(Format('New log level = %d', [FLogLevel]));
    end;
  finally
    FFileSection.Leave;
  end;
end;

procedure TLogFile.InternalAddEntry;
var
  entry: string;
begin
  if FFileOpen then begin
    if FLogTickCount then
      entry := Format('%s (%10.3f): %s',
        [DateTimeToStr(Now), GetTickCount / 1000, message])
    else
      entry := Format('%s: %s',
        [DateTimeToStr(Now), message]);
    WriteLn(logfile, entry);
  end;
end;

procedure TLogFile.AddEntry;
begin
  if level > LogLevel then Exit;
  FFileSection.Enter;
  try
    InternalAddEntry(message);
  finally
    FFileSection.Leave;
  end;
end;

initialization
  GlobalDebugLog := nil;
  DebugVersion := true;
finalization
  if Assigned(GlobalDebugLog) then begin
    GlobalDebugLog.AddEntry('finalization - closing log file');
    FreeAndNil(GlobalDebugLog);
  end;
end.
