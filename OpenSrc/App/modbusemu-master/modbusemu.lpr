program modbusemu;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms, main, ModbusEmuResStr, ExceptionsResStrings, DeviceAdd,
  DeviceView,formChennelAdd,
  formChennelRSLinuxAdd, formChennelRSWindowsAdd,
  formChennelTCPAdd, framChennelRSClasses, framChennelTCPClasses,
  formRahgeEdit;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

