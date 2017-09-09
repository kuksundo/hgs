{.GXFormatter.config=twm}
{: Implements a wrapper object around the Win32 API CreateProcess and
   related functions.
   @author twm
}
unit u_dzExecutor;

{$I jedi.inc}

interface

uses
  Windows,
  SysUtils,
  Classes,
  u_dzTranslator,
  u_dzFileStreams;

type
  {: ancestor to all exceptions raised in this unit }
  EExecutor = class(Exception);
  {: raised, when calling GetExitCode while Status is esInvalid }
  ENoProcess = class(EExecutor);
  {: raised, when calling GetStdOut or GetStdErr while Status is esRunning }
  EProcessRunning = class(EExecutor);
  {: raised, when trying to destroy the object while a process with I/O redirection
     is still running. }
  ERedirectedProcess = class(EProcessRunning);
  {: raised when calling TExecutor methods which do not work when the process
     has already terminated. }
  EProcessTerminated = class(EExecutor);
  {: raised when either StdOut or StdErr is accessed when RedirectStdXxx is not
     true }
  ENotRedirected = class(EExecutor);

type
  {: Status of the TExecutor object
     esInvalid = Process has not yet been started
     esRunning = Process is running
     esTerminated = Process has terminated }
  TExecutorStatus = (esInvalid, esRunning, esTerminated);
  TExecutorStatusSet = set of TExecutorStatus;

type
  {: Class wrapper around the Win32 functions for starting child processes.
     It allows to start a process, redirect stdIn/Out/Err, wait for it to finish,
     get the exit code and terminate it.
     Usage:<code>
       Executor := TExecutor.Create;
       Executor.WorkingDir := 's:\';
       Executor.Commandline := 'cvs -n -q update';
       Executor.Execute;
       Executor.Wait;
       MessageDlg(Format('StdOut: %s'#13#10+
                         'StdErr: %s', [Executor.StdOut, Executor.StdErr]),
                  mtInformation, [mbOK], 0);
       Executor.Free;
     </code>
  }
  TExecutor = class
  private
    FLastError: Integer;
  protected
    {: stores the ExeName property }
    FExeName: string;
    {: stores the Commandline property }
    FCommandline: string;
    {: stores the Environment property }
    FEnvironment: TStringList;
    {: stores the WorkingDir property }
    FWorkingDir: string;
    {: stores the RedirectStdOut property }
    FRedirectStdOut: Boolean;
    {: stores the RedirectStdErr property }
    FRedirectStdErr: Boolean;
    {: stores the StdIn property }
    FStdIn: AnsiString;
    {: stores the ExitCode property }
    FExitCode: DWORD;
    {: stores the Visible property }
    FVisible: Boolean;
    {: temporary file stream to be used as standard input for the process }
    FInputFile: TdzTempFile;
    {: temporary file stream to be used as standard output for the process }
    FOutputFile: TdzTempFile;
    {: temporary file stream to be used as standard error for the process }
    FErrorFile: TdzTempFile;
    {: Process information for CreateProcess }
    FProcessInfo: TProcessInformation;
    {: stores the Status property }
    FStatus: TExecutorStatus;
    {: gets the process handle, raises an ENoProcess exception if status is esInvalid
       @returns the process handle value }
    function GetProcessHandle: THandle;
    {: gets the thread handle, raises an ENoProcess exception if status is esInvalid
       @returns the process main thread handle }
    function GetThreadHandle: THandle;
    {: gets the process exit code, raises an ENoProcess exception if status is esInvalid
       @returns the process exit code }
    function GetExitCode: DWORD;
    ///<summary> reads the given stream into a string </summary>
    function ReadTextFile(_st: TStream): string;
    {: gets the process standard error, raises an ENoProcess exception if status is
       esInvalid and an EProcessRunning exception if status is esRunning
       @returns the process standard error }
    function GetStdErrStr: string;
    {: gets the process standard output, raises an ENoProcess exception if status is
       esInvalid and an EProcessRunning exception if status is esRunning
       @returns the process standard output }
    function GetStdOutStr: string;
    {: gets the StdOut stream }
    function GetStdOutStream: TStream;
    {: gets the Status property which is esInvalid when no process has been started,
       esRunning while the process is still running and esTerminated when the
       process has terminated. }
    function GetStatus: TExecutorStatus;
    {: checks whether the current status is in the set passed and raises one of
       ENoProcess, EProcessRunning, EProcessTerminated if not.
       This method is called by various other methods to assert that their
       functions are allowed in the current Status.
       @param ValidStatusSet is a set of valid Status values for the check. }
    procedure AssertStatus(_ValidStatusSet: TExecutorStatusSet; const _Method: string = '');
    {: Get method for property GetRedirectStdIn
       @returns true if StdIn is not an empty string }
    function GetRedirectStdIn: Boolean;
  public
    {: Creates a TExecutor object }
    constructor Create;
    {: Destroys a TExecutor object. If the Ststus is esRunning and the process
       uses I/O redirection, this raises an ERedirectedProcess exception }
    destructor Destroy; override;
    ///<summary>
    /// Does everything necessary to start the given executable with the
    /// given parameters without waiting for it to finish. </summary>
    class procedure Execute(const _Executable, _Parameters: string); overload;
    {: Waits for the process to terminate. Raises ENoProcess if Status is
       esInvalid. If Status is esTerminated this funtion returns immediately.
       @param Timeout is a DWORD giving the time to wait in milliseconds
       @returns the result of the call to WaitForSingleObject }
    function Wait(_Timeout: DWORD = INFINITE): DWORD;
    {: Kills a running process, avoid using this since it may not free all
       resources.
       @returns true on success, false otherwise }
    function Kill: Boolean;
    {: Searches for the executable given in the ExeName property using the
       system search path. If found the ExeName is set to the fully qualified
       name of the executable.
       @returns true if found, false otherwise }
    function FindExecutable(_ExeName: string = ''): Boolean;
    {: Executes the program given either by ExeName or as the first parameter
       in Commandline.
       @param RaiseException determines whether to raise an exception if CreateProcess
                             fails or simply return false. If false Execute will still
                             call GetLastError to retrieve the error code and it will
                             be available in the LastError property
       @returns the result of the call to CreateProcess }
    function doExecute(_RaiseException: Boolean = True): Boolean;
    function Execute(_RaiseException: Boolean = True): Boolean; overload; deprecated; // use doExecute instead
    property LastError: Integer read FLastError;
    {: This is a quick hack to allow freeing the object without waiting for the program
       to terminate }
    procedure ResetStatus;
    procedure GetStdOut(_sl: TStrings);
    procedure GetStdErr(_sl: TStrings);
    {: Fully qualified name of the executable to start. FindExecutable can be
       used if only the filename is known. Alternatively this can be left
       empty in which case the first parameter in CommanLine is used as
       executable name. }
    property Exename: string read FExeName write FExeName;
    {: Commandline to pass to the process. If ExeName is empty the first
       parameter is used as executable name. }
    property Commandline: string read FCommandline write FCommandline;
    property Environment: TStringList read FEnvironment;
    {: determines whether the process is started visible or not. If set
       to true, starting a commandline program form a GUI app will open
       a console window. }
    property Visible: Boolean read FVisible write FVisible;
    {: True if StdIn is redirected }
    property RedirectStdIn: Boolean read GetRedirectStdIn;
    {: Set to true to redirect the process' standard output. This will result
       in having all text the process writes to its standard output handle
       copied to the StdOut property. }
    property RedirectStdOut: Boolean read FRedirectStdOut write FRedirectStdOut;
    {: Set to true to redirect the process' standard output. This will result
       in having all text the process writes to its standard output handle
       copied to the StdOut property. }
    property RedirectStdErr: Boolean read FRedirectStdErr write FRedirectStdErr;
    {: Set this to the standard input you want to supply to the process. }
    property StdIn: AnsiString read FStdIn write FStdIn;
    {: After the process has terminated this contains the standard output. When
       accessed before the process has terminated this will raise either a ENoProcess
       or EProcessRunning exception }
    property StdOut: string read GetStdOutStr;
    property StdOutStream: TStream read GetStdOutStream;
    {: After the process has terminated this contains the standard error. When
       accessed before the process has terminated this will raise either a ENoProcess
       or EProcessRunning exception }
    property StdErr: string read GetStdErrStr;
    {: Contains the exit code of the process. If accessed while Status is esInvalid
       raises an ENoProcess exception. While the process is still running ExitCode
       is STILL_ACTIVE. }
    property ExitCode: DWORD read GetExitCode;
    {: Contains the handle of the process, raises an ENoProcess exception while
       status is esInvalid. }
    property ProcessHandle: THandle read GetProcessHandle;
    {: Contains the handle of the process' main thread,raises an ENoProcess exception while
       status is esInvalid. }
    property ThreadHandle: THandle read GetThreadHandle;
    {: Contains the status of a TExecutor which is esInvalid when no process
       has been started, esRunning while the process is still running and
       esTerminated when the process has terminated. }
    property Status: TExecutorStatus read GetStatus;
    {: Contains the working directory the process should be started in. If
       left empty the process will start in the current directory. }
    property WorkingDir: string read FWorkingDir write FWorkingDir;
  end;

implementation

uses
  u_dzOsUtils,
  u_dzMiscUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

// Auteur Thaddy de Koning
// adapted to unicode by twm
type
  TEnvironmentBlockReader = class(TStringList)
  public
    constructor Create;
  end;

  TEnvironmentBlockWriter = class(TStringStream)
  private
    FClosed: Boolean;
    function GetBlockPtr: PChar;
  protected
    procedure Close;
  public
    procedure Add(const AValue: string); overload;
    procedure Add(const aToken, AValue: string); overload;
    property Block: PChar read GetBlockPtr;
  end;

{ TExecutor }

constructor TExecutor.Create;
begin
  inherited;
  FStatus := esInvalid;
  FRedirectStdOut := False;
  FRedirectStdErr := False;
  FEnvironment := TEnvironmentBlockReader.Create;
  FVisible := True;
  ZeroMemory(@FProcessInfo, SizeOf(FProcessInfo));
  FWorkingDir := 'c:\';
end;

destructor TExecutor.Destroy;
begin
  inherited;
  if (Status = esRunning) and
    (RedirectStdIn or RedirectStdOut or RedirectStdErr) then
    raise ERedirectedProcess.Create(_('Can not free Executor while a process using redirection is still running.'));
  FInputFile.Free;
  FOutputFile.Free;
  FErrorFile.Free;
  FEnvironment.Free;
  //  Kernel objects, like the process and the files we created in this case,
  //  are maintained by a usage count.
  //  So, for cleaning up purposes we have to close the handles
  //  to inform the system that we don't need the objects anymore
  if FProcessInfo.hThread <> 0 then
    CloseHandle(FProcessInfo.hThread);
  if FProcessInfo.hProcess <> 0 then
    CloseHandle(FProcessInfo.hProcess);
end;

function TExecutor.FindExecutable(_ExeName: string): Boolean;
var
  SearchPath: string;
  Found: string;
begin
  if _ExeName = '' then
    _ExeName := FExeName;
  Result := _ExeName <> '';
  if Result then begin
    SearchPath := GetEnvironmentVariable('path');
    Found := FileSearch(_ExeName, SearchPath);
    Result := Found <> '';
    if Result then
      FExeName := Found;
  end;
end;

procedure TExecutor.AssertStatus(_ValidStatusSet: TExecutorStatusSet; const _Method: string);
var
  Stat: TExecutorStatus;
begin
  Stat := GetStatus;
  if not (Stat in _ValidStatusSet) then
    case Stat of
      esInvalid: raise ENoProcess.CreateFmt(_('Process has not yet been started.'#13#10'%s'), [_Method]);
      esRunning: raise EProcessRunning.CreateFmt(_('Process is still running.'#13#10'%s'), [_Method]);
      esTerminated: raise EProcessTerminated.CreateFmt(_('Process has terminated.'#13#10'%s'), [_Method]);
    end;
end;

function TExecutor.GetStatus: TExecutorStatus;
begin
  if FStatus = esRunning then begin
    Win32Check(GetExitCodeProcess(FProcessInfo.hProcess, FExitCode));
    if FExitCode = STILL_ACTIVE then
      FStatus := esRunning
    else
      FStatus := esTerminated;
  end;
  Result := FStatus;
end;

function TExecutor.GetExitCode: DWORD;
begin
  AssertStatus([esRunning, esTerminated]);
  Result := FExitCode;
end;

function TExecutor.Wait(_Timeout: DWORD): DWORD;
begin
  AssertStatus([esRunning, esTerminated]);
  Result := WaitforSingleObject(ProcessHandle, _Timeout);
end;

function TExecutor.Kill: Boolean;
begin
  case GetStatus of
    esInvalid: raise ENoProcess.Create(_('Process has not yet been started'));
    esRunning: Result := TerminateProcess(FProcessInfo.hProcess, $FFFFFFFF);
  else
    Result := True;
  end;
end;

function TExecutor.GetProcessHandle: THandle;
begin
  AssertStatus([esRunning, esTerminated]);
  Result := FProcessInfo.hProcess;
end;

function TExecutor.GetThreadHandle: THandle;
begin
  AssertStatus([esRunning, esTerminated]);
  Result := FProcessInfo.hThread;
end;

function TExecutor.GetRedirectStdIn: Boolean;
begin
  Result := FStdIn <> '';
end;

function TExecutor.doExecute(_RaiseException: Boolean): Boolean;
var
  StartupInfo: TStartupInfo;
  SecurityAttributes: TSecurityAttributes;
  Cmdline: string;
  env: TEnvironmentBlockWriter;
  i: Integer;
  pCmdLine: PChar;
  pEnv: PChar;
  PExeName: PChar;
  CreationFlags: DWORD;
begin
  if FStatus <> esInvalid then
    raise Exception.Create(_('Process has already been started.'));

  // prepare SecurityAttributes for files, set InheritHandle to true
  ZeroMemory(@SecurityAttributes, SizeOf(SecurityAttributes));
  SecurityAttributes.nLength := SizeOf(SecurityAttributes);
  SecurityAttributes.lpSecurityDescriptor := nil;
  SecurityAttributes.bInheritHandle := True;

  // prepare StartupInfo structure
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.lpDesktop := 'winsta0\default';
  StartupInfo.hStdOutput := 0;
  StartupInfo.hStdInput := 0;
  StartupInfo.hStdError := 0;
  StartupInfo.dwFlags := 0;

  if RedirectStdIn then begin
    FInputFile := TdzTempFile.Create;
    try
      FInputFile.SecurityAttributes := @SecurityAttributes;
      FInputFile.Open;
      FInputFile.Write(FStdIn[1], Length(FStdIn));
      FInputFile.Seek(0, soFromBeginning);
      StartupInfo.dwFlags := StartupInfo.dwFlags or STARTF_USESTDHANDLES;
      StartupInfo.hStdInput := FInputFile.Handle;
    except
      FInputFile.Free;
      FInputFile := nil;
      raise;
    end;
  end;

  if RedirectStdOut then begin
    FOutputFile := TdzTempFile.Create;
    FOutputFile.SecurityAttributes := @SecurityAttributes;
    FOutputFile.Open;
    StartupInfo.dwFlags := StartupInfo.dwFlags or STARTF_USESTDHANDLES;
    StartupInfo.hStdOutput := FOutputFile.Handle;
  end;

  if RedirectStdErr then begin
    FErrorFile := TdzTempFile.Create;
    FErrorFile.SecurityAttributes := @SecurityAttributes;
    FErrorFile.Open;
    StartupInfo.dwFlags := StartupInfo.dwFlags or STARTF_USESTDHANDLES;
    StartupInfo.hStdError := FErrorFile.Handle;
  end;

  if not FVisible then begin
    StartupInfo.dwFlags := StartupInfo.dwFlags or STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := SW_HIDE;
  end else begin
    StartupInfo.dwFlags := StartupInfo.dwFlags or STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := SW_SHOWNORMAL;
  end;

  if FExeName <> '' then begin
    Cmdline := Format('"%s" %s', [FExeName, FCommandline]);
    PExeName := PChar(FExeName);
  end else begin
    PExeName := nil;
    Cmdline := FCommandline;
  end;

  env := nil;
  pCmdLine := StrNew(PChar(Cmdline));
  try
    env := TEnvironmentBlockWriter.Create('');
    for i := 0 to Environment.Count - 1 do begin
      env.Add(Environment[i]);
    end;
    pEnv := env.Block;

    CreationFlags := NORMAL_PRIORITY_CLASS;
{$IFDEF SUPPORTS_UNICODE_STRING}
    CreationFlags := CreationFlags or CREATE_UNICODE_ENVIRONMENT;
{$ENDIF SUPPORTS_UNICODE_STRING}

    Result := CreateProcess(
      PExeName, // pointer to the executable (or nil)
      pCmdLine, // pointer to command line string (or nil)
      nil, // pointer to process security attributes
      nil, // pointer to thread security attributes
      True, // handle inheritance flag
      CreationFlags, // creation flags
      pEnv, // pointer to new environment block
      PChar(FWorkingDir), // pointer to current directory name
      StartupInfo, // pointer to STARTUPINFO
      FProcessInfo); // pointer to PROCESS_INF
    if Result then begin
      FStatus := esRunning;
    end else begin
      FLastError := GetLastError;
      if _RaiseException then begin
        RaiseLastOSErrorEx(FLastError, Format(_('%%1:s (%%0:d) in CreateProcess("%s", "%s")'), [FExeName, Cmdline]));
      end;
    end;
  finally
    StrDispose(pCmdLine);
    FreeAndNil(env);
  end;
end; // TExecutor.doExecute

class procedure TExecutor.Execute(const _Executable, _Parameters: string);
var
  Exe: TExecutor;
begin
  Exe := TExecutor.Create;
  try
    Exe.Exename := _Executable;
    Exe.Commandline := _Parameters;
    Exe.doExecute(True);
  finally
    FreeAndNil(Exe);
  end;
end;

function TExecutor.Execute(_RaiseException: Boolean = True): Boolean;
begin
  Result := doExecute(_RaiseException);
end;

procedure TExecutor.ResetStatus;
begin
  FStatus := esTerminated;
end;

function TExecutor.ReadTextFile(_st: TStream): string;
var
  sl: TStringList;
begin
  _st.Seek(0, soFromBeginning);
  sl := TStringList.Create;
  try
    sl.LoadFromStream(_st);
    Result := sl.Text;
  finally
    FreeAndNil(sl);
  end;
end;

function TExecutor.GetStdErrStr: string;
begin
  AssertStatus([esTerminated]);
  if not RedirectStdOut then
    raise ENotRedirected.Create(_('StdErr was not redirected'));

  Result := ReadTextFile(FErrorFile);
end;

procedure TExecutor.GetStdErr(_sl: TStrings);
begin
  AssertStatus([esTerminated]);
  if not RedirectStdOut then
    raise ENotRedirected.Create(_('StdOut was not redirected'));

  FErrorFile.Seek(0, soFromBeginning);
  _sl.LoadFromStream(FErrorFile);
end;

function TExecutor.GetStdOutStr: string;
begin
  AssertStatus([esTerminated]);
  if not RedirectStdOut then
    raise ENotRedirected.Create(_('StdOut was not redirected'));

  Result := ReadTextFile(FOutputFile);
end;

procedure TExecutor.GetStdOut(_sl: TStrings);
begin
  AssertStatus([esTerminated]);
  if not RedirectStdOut then
    raise ENotRedirected.Create(_('StdOut was not redirected'));

  FOutputFile.Seek(0, soFromBeginning);
  _sl.LoadFromStream(FOutputFile);
end;

function TExecutor.GetStdOutStream: TStream;
begin
  AssertStatus([esTerminated]);
  if not RedirectStdOut then
    raise ENotRedirected.Create(_('StdOut was not redirected'));
  Result := FOutputFile;
end;

// Auteur Thaddy de Koning
// adapted to unicode by twm

const
  // Terminator gedefinieerd als typed const
  // (Zoadat het een memory reference heeft)
  NullChar: Char = #0;

{ TEnvironmentBlockWriter }

procedure TEnvironmentBlockWriter.Add(const AValue: string);
// Is het blok gesloten?
// Zoja, ga een positie terug
// Schrijf de string
// Schrijf terminating #0
begin
  if FClosed then begin
    Seek(-1, soFromEnd);
    FClosed := False;
  end;
  WriteString(AValue);
  Write(NullChar, 1);
end;

procedure TEnvironmentBlockWriter.Add(const aToken, AValue: string);
begin
  Add(aToken + '=' + AValue);
end;

// Block afsluiten door een extra #0 te schrijven, als gespecificeerd

procedure TEnvironmentBlockWriter.Close;
begin
  if not FClosed then begin
    Write(NullChar, 1);
    FClosed := True;
  end;
end;

// Als we het block uitlezen nemen we aan dat het gesloten is!

function TEnvironmentBlockWriter.GetBlockPtr: PChar;
begin
  Close;
  Result := PChar(DataString);
end;

{ TEnvironmentBlockReader }

constructor TEnvironmentBlockReader.Create;
var
  FBlock: PChar;
  StrPtr: PChar;
begin
  inherited;
  FBlock := GetEnvironmentStrings;
  if FBlock <> nil then
    try
      StrPtr := FBlock;
      repeat
        Add(StrPtr);
        Inc(StrPtr, Succ(StrLen(StrPtr)));
      until StrPtr^ = #0;
    finally
      FreeEnvironmentStrings(FBlock);
    end;
end;

end.

