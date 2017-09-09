program DPMS;

uses
  Vcl.Forms,
  DPMS_Unit in 'DPMS_Unit.pas' {HiTEMS_Frm},
  Vcl.Themes,
  Vcl.Styles,
  CommonUtil_Unit in '..\CommonUtil\CommonUtil_Unit.pas',
  DataModule_Unit in '..\CommonUtil\DataModule_Unit.pas' {DM1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  //  Application.CreateForm(THiTEMS_Frm, HiTEMS_Frm);
  Application.Run;

  Open_HiTEMS;

end.
