{ this demo unit aims to help how LVCL performs versus Delphi7 VCL.

In order to check, go to project > options, directories and test \dynode\source\delphi7
versus \dynode\source\LVCL.

LVCL is a downsized/simplified emulation of Delphi7 VCL written by Arnaud Bouchez.
It must be enhanced in order to be fully functional.
}
unit testCL;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, dnProcessRunner;

type

  //TMyThread
  TMyThread = class(TWorkerThread)
  public
    procedure Update; override;
  end;

type
  TForm1 = class(TForm)
    Button1: TButton;
    mmDebug: TMemo;
    mmApp: TMemo;
    mmInput: TMemo;
    mmOutput: TMemo;
    btnStop: TButton;
    mmCurrentDir: TMemo;
    btnPipe: TButton;
    Label1: TLabel;
    lbRun: TLabel;
    Label2: TLabel;
    btnDirect: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnPipeClick(Sender: TObject);
    procedure btnDirectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  cmdline: string;
  currentdir: string;
  App: string;
  waitResult : Cardinal;
  Result: integer;
  FPCDemoFolder: string;
  FPCBuildCmd: string;
  Res: longbool;
  startupInfo: TStartupInfo;
  processInfo: TProcessInformation;
  timeout: longword;
  killappontimeout: boolean;
  exitCode : Cardinal;
  Visibility: word;
begin

  Visibility := 0;
  // initialize windows structures
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb:=SizeOf(TStartupInfo);
    dwFlags:=(STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK);
    wShowWindow := Visibility;
  end;

  // fpc stuff
  FPCDemoFolder := 'D:\fpc\2.6.2\win32\demo\win32';
  FPCBuildCmd :=  '';
  mmDebug.Lines.Clear;

  cmdline := 'D:\fpc\2.6.2\win32\bin\i386-win32';
  CurrentDir := 'D:\fpc\2.6.2\win32\demo\win32';
  App := cmdline + '\' + 'fpc.exe';
  mmDebug.Lines.Add(app);
  mmDebug.Lines.Add(cmdline);
  mmDebug.Lines.Add(currentdir);

  TimeOut := 500;
  killappontimeout := true;


  Res := CreateProcess(PAnsiChar(app),
    PAnsiChar(cmdLine),
    nil,
    nil,
    False,
    NORMAL_PRIORITY_CLASS,
    nil,
    PAnsiChar(CurrentDir),
    startupInfo,
    processInfo);

  mmDebug.Lines.Add(intToStr(integer(Res)));


   if (Res = true) then
   begin
      try
         repeat
            waitResult:=WaitForSingleObject(ProcessInfo.hProcess, 500);
            if waitResult<>WAIT_TIMEOUT then
              Break;
            Application.ProcessMessages;
            Dec(timeOut, 500);
         until timeOut <= 0;
         if waitResult <> WAIT_OBJECT_0 then
         begin
            Result:=GetLastError;
            mmDebug.Lines.Add(inttostr(Result));
            if killAppOnTimeOut then
            begin
               TerminateProcess(ProcessInfo.hProcess, 0);
               WaitForSingleObject(ProcessInfo.hProcess, 1000);
               mmDebug.Lines.Add('app killed');
            end;
         end else
         begin
            GetExitCodeProcess(ProcessInfo.hProcess, exitCode);
            Result:=exitCode;
         end;
      finally
         CloseHandle(ProcessInfo.hProcess);
         CloseHandle(ProcessInfo.hThread);
         mmDebug.Lines.Add('handles closed');
      end;
   end else
   begin
      RaiseLastOSError;
      Result:=-1;
   end;
end;

procedure TForm1.btnDirectClick(Sender: TObject);
var
  MyProcess: TdnDirectProcess;
begin
  // child process
  MyProcess := TdnDirectProcess.Create;
  try
    //MyProcess.CreateNoWindow := True;
    MyProcess.CommandFile := 'd:\subversion\googlecode\trunk\dynode\' +
    'input.txt';
    MyProcess.ReplyFile := 'c:\tortoise\source\dynode\output.txt';

    MyProcess.Run('c:\windows\system32\cmd.exe');

    mmInput.Text := MyProcess.InputStream.DataString;
    mmOutput.Text := MyProcess.OutputStream.DataString;

    Label1.Caption := 'input=' + IntToStr(MyProcess.InputStream.Size);
    Label2.Caption := 'output=' + IntToStr(MyProcess.OutputStream.Size);
  finally
    MyProcess.Free;
  end;
end;

procedure TForm1.btnPipeClick(Sender: TObject);
var
  CurrentDir: string;
  MyProcess: TdnPipedProcess;
  MyThread: TMyThread;
begin
  // run the thread first
  MyThread := TMyThread.Create(False);

  CurrentDir := 'd:\subversion\googlecode\source\dynode';

  // child process
  MyProcess := TdnPipedProcess.Create;
  try
    //MyProcess.CreateNoWindow := True;
    MyProcess.CommandFile := 'c:\tortoise\source\dynode\input.txt';
    MyProcess.Run('c:\windows\system32\cmd.exe');

    mmInput.Text := MyProcess.InputStream.DataString;
    mmOutput.Text := MyProcess.OutputStream.DataString;

    Label1.Caption := 'input=' + IntToStr(MyProcess.InputStream.Size);
    Label2.Caption := 'output=' + IntToStr(MyProcess.OutputStream.Size);
  finally
    MyProcess.Free;
  end;

end;

procedure TMyThread.Update;
begin
  Form1.Label1.Caption := IntToStr(dwRead);
  Form1.Label2.Caption := IntToStr(dwWritten);
  Form1.lbRun.Caption := IntToStr(GetTickCount mod 1000)
end;

end.
