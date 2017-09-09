{
 * SysInfoDemo.dpr
 *
 * Project file for System Information Unit demo program.
 *
 * $Rev: 1244 $
 * $Date: 2013-01-19 00:40:15 +0000 (Sat, 19 Jan 2013) $
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}


program SysInfoDemo;

uses
  Forms,
  FmDemo in 'FmDemo.pas' {DemoForm},
  PJSysInfo in '..\..\PJSysInfo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.

