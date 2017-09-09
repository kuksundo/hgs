{ Unit Lossless

  This unit implements a port to lossless JPG operations.

  Use the procedure DoLosslessAction to perform a lossless action.

  Author: Nils Haeck M.Sc.
  Copyright (c) 2001 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

TODO:  Lossless operations were done by JPEGTRAN in the past, but can now
  be done by NativeJpg

}
unit Lossless;

interface

uses
  Classes, SysUtils, Dialogs, ShFileOp, Windows, ShellAPI, Forms, sdAbcVars, NativeXml;

type

  TLosslessAction = (laRotateLeft, laRotateRight, laRotate180, laFlipHor, laFlipVer);

const

  cLosslessActionVerb: array[TLosslessAction] of string =
    ('Rotating' , 'Rotating', 'Rotating', 'Flipping', 'Flipping');

type

  TsdLossless = class(TDebugObject)
  public
    procedure DoLosslessAction(Filenames: string; AAction: TLosslessAction; AWorkDir: string;
      var ATotal, ASuccess: integer);
    function CommandPromptLossless(AWorkDir, ASource, ADest: string; Action: TLosslessAction): boolean;
    procedure CopyFileNoWarning(Source, Dest: string);
    procedure MoveFileNoWarning(Source, Dest: string);
  end;

implementation

uses
  guiMain, guiFeedback, guiActions;

const

  cAcceptedExtensions = '.jpg;.jpe;.jpeg;';

  cSourceName = 'source';
  cDestName   = 'destin';

  cLosslessExe = 'jpegtran.exe';

function TsdLossless.CommandPromptLossless(AWorkDir, ASource, ADest: string; Action: TLosslessAction): boolean;
var
  Tick: integer;
  CommandLine, Switch: string;
  S: TStream;
  Finished: boolean;
const
  cWaitInterval = 10000; // 10 seconds should be enough for a rotation
begin
  Result := False;

  // Command line
  case Action of
  laRotateLeft:  Switch := '-rotate 270';
  laRotateRight: Switch := '-rotate 90';
  laRotate180:   Switch := '-rotate 180';
  laFlipHor:     Switch := '-flip horizontal';
  laFlipVer:     Switch := '-flip vertical';
  end;//case

  // Check for existance of source file
  if not FileExists(AworkDir + ASource) then
    exit;

  CommandLine := Format('-copy all %s %s %s', [Switch, ASource, ADest]);

(*  // Fill StartupInfo structure
  Fillchar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
//  StartupInfo.wShowWindow := SW_SHOWMINNOACTIVE;
  StartupInfo.wShowWindow := 0;

  SysUtils.DeleteFile(ADest);

  // Create the command prompt process
  if not CreateProcess(
    PChar({AWorkDir +} cLosslessExe),      //App name
    PChar(CommandLine),  //Command Line
    nil,                 //Process Attributes
    nil,                 //Thread Attributes
    True,               //Inherit handles
    0,                   //Creation flags
    nil,                 //Environment
    PChar(AWorkDir),                 //Current directory
    StartupInfo,         //Startup info
    ProcessInfo) then    //Process info
  begin

    //Error in execution, analyse
    MessageDlg(
      Format('Error in lossless operation, error code %d',
      [GetLastError]), mtError, [mbOK], 0);

  end else begin

    // Wait for termination
    Proc := ProcessInfo.hProcess;
    CloseHandle(ProcessInfo.hThread);
    WaitResult := WaitForSingleObject(Proc, Wait_Interval);

    if WaitResult = Wait_TimeOut then
      // Timeout
      TerminateProcess(Proc,1);

    CloseHandle(Proc);
  end; *)

  // turn our watchdog back off
  inc(FShellNotifyRef);
  try

    // Execute JPEGTRAN
    ShellExecute(Application.Handle, 'open' , PChar(cLosslessExe),
      PChar(CommandLine), PChar(AWorkDir), {SW_SHOWMINNOACTIVE}{SW_SHOWNORMAL}SW_SHOWMINIMIZED);

    // Wait for file to appear
    Tick := GetTickCount;
    repeat
      sleep(100);
    until SysUtils.FileExists(AWorkDir + ADest) or (integer(GetTickCount) > Tick + cWaitInterval);

  finally
    // turn our watchdog back on
    dec(FShellNotifyRef);
  end;

  Result := SysUtils.FileExists(AWorkDir + ADest);
  if Result then begin
    // Wait for file to be accessible
    repeat
      try
        S := TFileStream.Create(AWorkDir + ADest, fmOpenRead or fmShareExclusive);
        Finished := True;
        S.Free;
      except
        Finished := False;
        sleep(200);
      end;
    until Finished;
  end;

  SysUtils.DeleteFile(AWorkDir + ASource);

end;

procedure TsdLossless.CopyFileNoWarning(Source, Dest: string);
var
  ShFile: TShellFileOp;
begin
  // turn off our watchdog
  inc(FShellNotifyRef);

  ShFile := TShellFileOp.Create(nil);
  try
    with ShFile do begin
      NoConfirmation := True;
      Animate := False;
      AddTarget(Source);
      CopyFiles(Dest);
    end;
  finally
    ShFile.Free;
    // turn our watchdog back on
    dec(FShellNotifyRef);
  end;

end;

procedure TsdLossless.MoveFileNoWarning(Source, Dest: string);
var
  ShFile: TShellFileOp;
begin
  // turn off our watchdog
  inc(FShellNotifyRef);

  ShFile := TShellFileOp.Create(nil);
  try
    with ShFile do begin
      NoConfirmation := True;
      Animate := False;
      AddTarget(Source);
      MoveFiles(Dest);
    end;
  finally
    ShFile.Free;
    // turn our watchdog back on
    dec(FShellNotifyRef);
  end;
end;

procedure TsdLossless.DoLosslessAction(Filenames: string; AAction: TLosslessAction; AWorkDir: string;
  var ATotal, ASuccess: integer);
var
  i: integer;
  List: TStrings;
  Ext, Source, Dest, FileName: string;
  Handle: integer;
  FileDate: integer;
begin
  FileDate := 0;
  ATotal := 0;
  ASuccess := 0;

  List := TStringList.Create;
  try

    List.Text := Filenames;

    // Only accepted extensions
    for i := 0 to List.Count - 1 do
      if Pos(LowerCase(ExtractFileExt(List[i])), cAcceptedExtensions) > 0 then
        inc(ATotal);

    if ATotal > 0 then begin

      ATotal := 0;
      Feedback.Start;
      try
        Feedback.Add(Format('%s %d item(s)',
          [cLosslessActionVerb[AAction], List.Count]));
      // Loop through files
      for i := 0 to List.Count - 1 do begin

        FileName := ExtractFileName(List[i]);
        Feedback.Info := Format('%s item %d of %d (%s)',
          [cLosslessActionVerb[AAction], i+1, List.Count, FileName]);
        inc(ATotal);

        Ext := LowerCase(ExtractFileExt(List[i]));
        if Pos(Ext, cAcceptedExtensions) > 0  then begin

          Source := cSourceName + Ext;
          Dest   := cDestName   + Ext;

          // Get original file date
          Handle := FileOpen(List[i], fmOpenRead + fmShareDenyNone);
          if Handle > 0 then begin
            FileDate := FileGetDate(Handle);
            FileClose(Handle);
          end;

          try
            CopyFileNoWarning(List[i], AWorkDir + Source);

            // turn our watchdog off
            inc(FShellNotifyRef);
            try
              // Do the lossless operation
              if CommandPromptLossless(AWorkDir, Source, Dest, AAction) then begin

                // Move the file back
                MoveFileNoWarning(AWorkDir + Dest, List[i]);

                // Set original file date
                Handle := FileOpen(List[i], fmOpenWrite + fmShareDenyNone);
                if Handle > 0 then begin
                  FileSetDate(Handle, FileDate);
                  FileClose(Handle);
                end;
                inc(ASuccess);
              end;
            finally
              // turn our watchdog back on
              dec(FShellNotifyRef);
            end;
            // Update feedback
            Feedback.edStatus.Lines.Add(Format('File %s processed OK',
              [FileName]));
          except
            DoDebugOut(Self, wsFail, 'Exception in Losslessaction');
          end;
        end else begin
          Feedback.AddError(Format(
           'File <b>%s</b> is not of the correct type for lossless operations',
             [FileName]));
          Feedback.edStatus.Lines.Add(Format('File %s skipped',
             [FileName]));
          Feedback.Hold := True;
        end;
        Feedback.Progress := (i + 1) / List.Count * 100;
      end;
      if Feedback.ErrorCount > 0 then
        Feedback.Status := tsError
      else
        Feedback.Status := tsCompleted;
      finally
        Feedback.Finish;
      end;

    end else begin

      // Warn user about empty selection
      MessageDlg(
        'You did not select a valid file which can be modified'#13 +
        'losslessly. Only files with these extensions apply:'#13#13 +
        cAcceptedExtensions + #13#13 +
        'No action was taken.', mtError, [mbOK], 0);
    end;

  finally
    List.Free;
  end;

end;

end.
