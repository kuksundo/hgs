program HiTEMS_DV;

uses
  Vcl.Forms,
  dvMain_Unit in 'Forms\dvMain_Unit.pas' {dvMain_Frm},
  msViewer_Unit in 'Forms\viewer_Form\msViewer_Unit.pas' {msViewer_Frm},
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  CommonUtil_Unit in '..\..\00.CommonUtils\CommonUtil_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TdvMain_Frm, dvMain_Frm);
  Application.Run;
end.
