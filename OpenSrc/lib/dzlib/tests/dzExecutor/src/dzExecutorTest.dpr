program dzExecutorTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  u_dzExecutor in '..\..\..\src\u_dzExecutor.pas',
  u_dzMiscUtils in '..\..\..\src\u_dzMiscUtils.pas',
  u_dzTranslator in '..\..\..\src\u_dzTranslator.pas';

procedure Main;
var
  exec: TExecutor;
begin
  exec := TExecutor.Create;
  try
    exec.Visible := true;
    exec.WorkingDir := 'c:\';
    exec.Environment.Add('bla=blub');
    if not exec.FindExecutable('cmd.exe') then
      raise exception.Create('Could not find cmd.exe in search path.');
    exec.Commandline := '/c set';
    if not exec.Execute then
      raise Exception.Create('Error executing cmd.exe');
  finally
    FreeAndNil(exec);
  end;
end;

begin
  try
    Main;
  except
    on E: Exception do begin
      Writeln(E.ClassName, ': ', E.Message);
    end;
  end;
  WriteLn('Press enter');
  ReadLn;
end.

