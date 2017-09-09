{
 * Project file for the Child application of the DelphiDabbler Environment
 * Variables Unit demo program #2, FireMonkey 2 version.
 *
 * $Rev: 1734 $
 * $Date: 2014-01-26 22:09:42 +0000 (Sun, 26 Jan 2014) $
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

program Child;

uses
  FMX.Forms,
  FmChild in 'FmChild.pas' {ChildForm},
  PJEnvVars in '..\..\..\PJEnvVars.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TChildForm, ChildForm);
  Application.Run;
end.

