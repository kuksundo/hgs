program HiTEMS_DataSnap_Server;

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Main_Unit in 'Form\Main_Unit.pas' {Main_Frm},
  ServerContainer_Unit in 'ServerContainers\ServerContainer_Unit.pas' {ServerContainer1: TDataModule},
  GUID_Utils_Unit in 'Common\GUID_Utils_Unit.pas',
  DataModule_Unit in 'ServerModule\DataModule_Unit.pas' {DM1: TDataModule},
  WebModule_Unit in 'ServerModule\WebModule_Unit.pas' {WM1: TWebModule},
  ServerMethods_Photorum_Unit in 'ServerMethods\ServerMethods_Photorum_Unit.pas',
  ServerMethods_Monitoring_Unit in 'ServerMethods\ServerMethods_Monitoring_Unit.pas',
  ServerMethods_LDS_Unit in 'ServerMethods\ServerMethods_LDS_Unit.pas',
  ServerMethods_TRC_Unit in 'ServerMethods\ServerMethods_TRC_Unit.pas',
  ServerMethods_HiTEMS_Unit in 'ServerMethods\ServerMethods_HiTEMS_Unit.pas',
  CommonUtil_Unit in '..\..\00.CommonUtils\CommonUtil_Unit.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;

//  Application.MainFormOnTaskbar := True;
  Application.Initialize;
  Application.CreateForm(TMain_Frm, Main_Frm);
  Application.CreateForm(TDM1, DM1);
  Application.Run;
end.

