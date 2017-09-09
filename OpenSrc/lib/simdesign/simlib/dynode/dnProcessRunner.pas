unit dnProcessRunner;
// ported from C++ by Nils Haeck and uses classes

interface

uses
  Windows, SysUtils, Classes, Dialogs;

const
  BUFSIZE = 4 * 1024; // 4K buffer IO

var
  chBuf: array[0..BUFSIZE - 1] of ansichar;

// overlapped completion routine
procedure CompletionRoutine(ErrorCode, BytesTransferred: DWORD; Overlapped: POverlapped); stdcall;

type

  // direct process
  TdnDirectProcess = class(TObject)
  protected
    g_hInputFile: THandle;
    g_hOutputFile: THandle;

    piProcInfo: PROCESS_INFORMATION;
    siStartInfo: STARTUPINFO;
    saAttr: SECURITY_ATTRIBUTES;
    piOverlap: OVERLAPPED;

    FCommandFile: TFileName;
    FReplyFile: TFileName;
    FInputStream, FOutputStream: TStringStream;
    FCreateNoWindow: boolean;
    procedure ErrorExit(Arg: string);
    procedure CreateChildProcess(Application: string); virtual;
    procedure ReadDirectFile;
    procedure WriteDirectFile;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Run(Application: string): integer; virtual;
    property CommandFile: TFileName read FCommandFile write FCommandFile;
    property ReplyFile: TFileName read FReplyFile write FReplyFile;
    property CreateNoWindow: boolean read FCreateNoWindow write FCreateNoWindow;
    property InputStream: TStringStream read FInputStream;
    property OutputStream: TStringStream read FOutputStream;
  end;

  // piped process
  TdnPipedProcess = class(TdnDirectProcess)
  protected
    g_hChildStd_IN_Rd: THandle;
    g_hChildStd_IN_Wr: THandle;
    g_hChildStd_OUT_Rd: THandle;
    g_hChildStd_OUT_Wr: THandle;

    procedure ReadFromPipe;
    procedure WriteToPipe;
    procedure CreateChildProcess(Application: string); override;
  public
    function Run(Application: string): integer; override;
  end;

  // worker thread
  TWorkerThread = class(TThread)
  public
    dwRead, dwWritten: DWORD;
    procedure Execute; override;
    procedure Update; virtual; abstract;
  end;

implementation

var
  FBuffer: PChar;

procedure CompletionRoutine(ErrorCode, BytesTransferred: DWORD; Overlapped: POverlapped); stdcall;
begin
  if ErrorCode = 0 then
  begin
    (FBuffer + BytesTransferred)^ := #0; // append null terminator
    ShowMessage(PChar(FBuffer));         // display the data
  end;
  FreeMem(FBuffer);                      // must free the buffer
  CloseHandle(Overlapped^.hEvent);       // and don't forget to close the
end;

{ TdnDirectProcess }

constructor TdnDirectProcess.Create;
begin
  inherited Create;
  FInputStream := TStringStream.Create('');
  FOutputStream := TStringStream.Create('');
end;

procedure TdnDirectProcess.CreateChildProcess(Application: string);
var
   bSuccess: BOOL;
   CreationFlags: cardinal;
begin
// Set up members of the PROCESS_INFORMATION structure.

  FillChar(piProcInfo, SizeOf(PROCESS_INFORMATION), 0);

// Set up members of the STARTUPINFO structure.
// This structure specifies the STDIN and STDOUT handles for redirection.

   FillChar(siStartInfo, sizeof(STARTUPINFO), 0 );
   siStartInfo.cb         := sizeof(STARTUPINFO);
   siStartInfo.hStdError  := g_hOutputFile;
   siStartInfo.hStdOutput := g_hOutputFile;
   siStartInfo.hStdInput  := g_hInputFile;
   siStartInfo.dwFlags := STARTF_USESTDHANDLES;

   // creation flags
   CreationFlags := NORMAL_PRIORITY_CLASS;
   if FCreateNoWindow then
     CreationFlags := CreationFlags or CREATE_NO_WINDOW;

  // Create the child process.
  bSuccess := CreateProcess(nil,
      PAnsiChar(Application),     // command line
      nil,                        // process security attributes
      nil,                        // primary thread security attributes
      TRUE,                       // handles are inherited
      CreationFlags,              // creation flags
      nil,                        // use parent's environment
      nil,                        // use parent's directory
      siStartInfo,                // STARTUPINFO pointer
      piProcInfo);                // receives PROCESS_INFORMATION

  // If an error occurs, exit the application.
  if (not bSuccess) then
    ErrorExit('CreateProcess')

  else
  begin
    // Close handles to the child process and its primary thread.
    // Some applications might keep these handles to monitor the status
    // of the child process, for example.

    //CloseHandle(piProcInfo.hProcess);
    //CloseHandle(piProcInfo.hThread);
  end;
end;

destructor TdnDirectProcess.Destroy;
begin
  FInputStream.Free;
  FOutputStream.Free;
  inherited;
end;

procedure TdnDirectProcess.ErrorExit(Arg: string);
// Format a readable error message, display a message box,
// and exit from the application.
var
    lpMsgBuf: pointer;
    DisplayBuf: string;
    dw: DWORD;
begin
    dw := GetLastError;
    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER or
        FORMAT_MESSAGE_FROM_SYSTEM or
        FORMAT_MESSAGE_IGNORE_INSERTS,
        nil,
        dw,
        {MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT)}0,
        @lpMsgBuf,
        0, nil );

    DisplayBuf := Format('%s failed with error %d: %s', [arg, dw, PAnsiChar(lpMsgBuf)]);
    MessageBox(0, PAnsiChar(DisplayBuf), 'Error', MB_OK);

    ExitProcess(1);
end;

procedure TdnDirectProcess.ReadDirectFile;
// Read from a file and write its contents to the pipe for the child's STDIN.
// Stop when there is no more data.

var
  dwRead: DWORD;
  chBuf: array[0..BUFSIZE - 1] of ansichar;
  bSuccess: BOOL ;
begin
  FillChar(chBuf, BUFSIZE, #0);

  while True do
  begin

    bSuccess := ReadFile(g_hInputFile, chBuf, BUFSIZE, dwRead, nil);
    if ((not bSuccess) or (dwRead = 0)) then
      break;

    if (dwRead > 0) then
      FInputStream.Write(chBuf, dwRead);

  end;
end;

procedure TdnDirectProcess.WriteDirectFile;
// Read output from the child process's pipe for STDOUT
// and write to the parent process's pipe for STDOUT.
// Stop when there is no more data.
var
  dwRead: DWORD;
  chBuf: array [0..BufSize - 1] of AnsiChar;
  bSuccess: bool;
begin
  sleep(100);

  FillChar(piOverlap, sizeof(OVERLAPPED), 0);

  FillChar(chBuf, BUFSIZE, #0);

  while True do
  begin
{    bSuccess := ReadFile(g_hChildStd_OUT_Rd, chBuf, BUFSIZE, dwRead, nil);
    if ((not bSuccess) or (dwRead = 0)) then
      break; }

    dwRead := 0;
    bSuccess := ReadFileEx(g_hOutputFile, @chBuf, BUFSIZE, @piOverlap, @CompletionRoutine);
    if (not bSuccess) then
      break;

    if dwRead > 0 then
    begin
      FOutputStream.Write(chBuf, dwRead);
    end;

{    dwRead := 0;
    bSuccess := WriteFile(hParentStdOut, chBuf, dwRead, dwWritten, nil);
    if (not bSuccess) then
      break;}
  end;
end;

function TdnDirectProcess.Run(Application: string): integer;
begin
  FInputStream.Size := 0;
  FOutputStream.Size := 0;
  // Set the bInheritHandle flag so pipe handles are inherited.

  saAttr.nLength := sizeof(SECURITY_ATTRIBUTES);
  saAttr.bInheritHandle := TRUE;
  saAttr.lpSecurityDescriptor := nil;

// Get a handle to an input file for the parent.
// This example assumes a plain text file and uses string output to verify data flow.

  g_hInputFile := CreateFile(
    PAnsiChar(string(FCommandFile)),
    GENERIC_READ,
    0,
    nil,
    OPEN_EXISTING,
    FILE_ATTRIBUTE_READONLY,
    0);

  if (g_hInputFile = INVALID_HANDLE_VALUE) then
    ErrorExit('CreateFile');

  g_hOutputFile := CreateFile(
    PAnsiChar(string(FReplyFile)),
    GENERIC_WRITE,
    0,
    nil,
    CREATE_ALWAYS,
    FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED,
    0);

  if (g_hOutputFile = INVALID_HANDLE_VALUE) then
    ErrorExit('CreateFile');

  // Create the child process.
  CreateChildProcess(Application);

// The remaining open handles are cleaned up when this process terminates.
// To avoid resource leaks in a larger application, close handles explicitly.

  Result := 0;
end;

{ TdnPipedProcess }

procedure TdnPipedProcess.CreateChildProcess(Application: string);
// Create a child process that uses the previously created pipes for STDIN and STDOUT.
var
   bSuccess: BOOL;
   CreationFlags: cardinal;
begin
// Set up members of the PROCESS_INFORMATION structure.

  FillChar(piProcInfo, SizeOf(PROCESS_INFORMATION), 0);

// Set up members of the STARTUPINFO structure.
// This structure specifies the STDIN and STDOUT handles for redirection.

   FillChar(siStartInfo, sizeof(STARTUPINFO), 0 );
   siStartInfo.cb         := sizeof(STARTUPINFO);
   siStartInfo.hStdError  := g_hChildStd_OUT_Wr;
   siStartInfo.hStdOutput := g_hChildStd_OUT_Wr;
   siStartInfo.hStdInput  := g_hChildStd_IN_Rd;
   siStartInfo.dwFlags := STARTF_USESTDHANDLES;

   // creation flags
   CreationFlags := NORMAL_PRIORITY_CLASS;
   if FCreateNoWindow then
     CreationFlags := CreationFlags or CREATE_NO_WINDOW;

  // Create the child process.
  bSuccess := CreateProcess(nil,
      PAnsiChar(Application),     // command line
      nil,                        // process security attributes
      nil,                        // primary thread security attributes
      TRUE,                       // handles are inherited
      CreationFlags,              // creation flags
      nil,                        // use parent's environment
      nil,                        // use parent's directory
      siStartInfo,                // STARTUPINFO pointer
      piProcInfo);                // receives PROCESS_INFORMATION

  // If an error occurs, exit the application.
  if (not bSuccess) then
    ErrorExit('CreateProcess')

  else
  begin
    // Close handles to the child process and its primary thread.
    // Some applications might keep these handles to monitor the status
    // of the child process, for example.

    //CloseHandle(piProcInfo.hProcess);
    //CloseHandle(piProcInfo.hThread);
  end;
end;

procedure TdnPipedProcess.ReadFromPipe;
// Read output from the child process's pipe for STDOUT
// and write to the parent process's pipe for STDOUT.
// Stop when there is no more data.
var
  dwRead: DWORD;
  dwWritten: DWORD;
  chBuf: array [0..BufSize - 1] of AnsiChar;
  bSuccess: bool;
  hParentStdOut: THANDLE;
begin
  //sleep(5000);
  sleep(100);

  hParentStdOut := GetStdHandle(STD_OUTPUT_HANDLE);

  FillChar(piOverlap, sizeof(OVERLAPPED), 0);

  FillChar(chBuf, BUFSIZE, #0);

  while True do
  begin
{    bSuccess := ReadFile(g_hChildStd_OUT_Rd, chBuf, BUFSIZE, dwRead, nil);
    if ((not bSuccess) or (dwRead = 0)) then
      break; }

    dwRead := 0;
    bSuccess := ReadFileEx(g_hChildStd_OUT_Rd, @chBuf, BUFSIZE, @piOverlap, @CompletionRoutine);
    if (not bSuccess) then
      break;

    if dwRead > 0 then
    begin
      FOutputStream.Write(chBuf, dwRead);
    end;

    dwRead := 0;
    bSuccess := WriteFile(hParentStdOut, chBuf, dwRead, dwWritten, nil);
    if (not bSuccess) then
      break;
  end;
end;

procedure TdnPipedProcess.WriteToPipe;
// Read from a file and write its contents to the pipe for the child's STDIN.
// Stop when there is no more data.

var
  dwRead, dwWritten: DWORD;
  chBuf: array[0..BUFSIZE - 1] of ansichar;
  bSuccess: BOOL ;
begin
  //sleep(100);
  FillChar(chBuf, BUFSIZE, #0);

  while True do
  begin

    bSuccess := ReadFile(g_hInputFile, chBuf, BUFSIZE, dwRead, nil);
    if ((not bSuccess) or (dwRead = 0)) then
      break;

    if (dwRead > 0) then
      FInputStream.Write(chBuf, dwRead);

    bSuccess := WriteFile(g_hChildStd_IN_Wr, chBuf, dwRead, dwWritten, nil);
    if (not bSuccess) then
      break;
  end;

// Close the pipe handle so the child process stops reading.

  if (not CloseHandle(g_hChildStd_IN_Wr)) then
    ErrorExit('StdInWr CloseHandle');
end;

function TdnPipedProcess.Run(Application: string): integer;
begin
  FInputStream.Size := 0;
  FOutputStream.Size := 0;
  // Set the bInheritHandle flag so pipe handles are inherited.

  saAttr.nLength := sizeof(SECURITY_ATTRIBUTES);
  saAttr.bInheritHandle := TRUE;
  saAttr.lpSecurityDescriptor := nil;

  // Create a pipe for the child process's STDOUT.

  if (not CreatePipe(g_hChildStd_OUT_Rd, g_hChildStd_OUT_Wr, @saAttr, 0)) then
    ErrorExit('StdoutRd CreatePipe');

  // Ensure the read handle to the pipe for STDOUT is not inherited.

  if (not SetHandleInformation(g_hChildStd_OUT_Rd, HANDLE_FLAG_INHERIT, 0)) then
    ErrorExit('Stdout SetHandleInformation');

  // Create a pipe for the child process's STDIN.

  if (not CreatePipe(g_hChildStd_IN_Rd, g_hChildStd_IN_Wr, @saAttr, 0)) then
    ErrorExit('Stdin CreatePipe');

  // Ensure the write handle to the pipe for STDIN is not inherited.

  if (not SetHandleInformation(g_hChildStd_IN_Wr, HANDLE_FLAG_INHERIT, 0)) then
    ErrorExit('Stdin SetHandleInformation');

  // Create the child process.
  CreateChildProcess(Application);

// Get a handle to an input file for the parent.
// This example assumes a plain text file and uses string output to verify data flow.

  g_hInputFile := CreateFile(
    PAnsiChar(string(FCommandFile)),
    GENERIC_READ,
    0,
    nil,
    OPEN_EXISTING,
    FILE_ATTRIBUTE_READONLY,
    0);

  if ( g_hInputFile = INVALID_HANDLE_VALUE ) then
    ErrorExit('CreateFile');

// Write to the pipe that is the standard input for a child process.
// Data is written to the pipe's buffers, so it is not necessary to wait
// until the child process is running before writing data.

  WriteToPipe();

  // Read from pipe that is the standard output for child process.

  ReadFromPipe();

// The remaining open handles are cleaned up when this process terminates.
// To avoid resource leaks in a larger application, close handles explicitly.

  Result := 0;
end;

{ TWorkerThread }

procedure TWorkerThread.Execute;
// this is the tester thread
var
  hStdin, hStdout: THANDLE;
  bSuccess: BOOL;
  chBuf: array[0..BUFSIZE - 1] of ansichar;
//
begin
  hStdout := GetStdHandle(STD_OUTPUT_HANDLE);
  hStdin := GetStdHandle(STD_INPUT_HANDLE);

  if ((hStdout = INVALID_HANDLE_VALUE) or
      (hStdin = INVALID_HANDLE_VALUE)) then
      ExitProcess(1);

  // Send something to this process's stdout using printf.
  //Form1.mmOutput.Lines.Add(' ** This is a message from the child process. ** ');
  //Application.ProcessMessages;

   // This simple algorithm uses the existence of the pipes to control execution.
   // It relies on the pipe buffers to ensure that no data is lost.
   // Larger applications would use more advanced process control.

  repeat

    synchronize(Update);
    // Read from standard input and stop on error or no data.
    ReadFile(hStdin, chBuf, BUFSIZE, dwRead, nil);

    if (dwRead > 0) then
      synchronize(Update);

    // Write to standard output and stop on error.
    bSuccess := WriteFile(hStdout, chBuf, dwRead, dwWritten, nil);

    if (not bSuccess) then
      continue;

    Sleep(10);

  until False;
end;

end.
