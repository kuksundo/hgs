program HiTEMS;

uses
  Vcl.Forms,
  HiTEMS_Unit in 'Forms\HiTEMS_Unit.pas' {HiTEMS_Frm},
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  Vcl.Themes,
  Vcl.Styles,
  CommonUtil_Unit in '..\..\00.CommonUtils\CommonUtil_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.CreateForm(TDM1, DM1);
  //  Application.CreateForm(THiTEMS_Frm, HiTEMS_Frm);
  Application.Run;

  Open_HiTEMS;

end.
