program PPP_Monitoring;



{$R *.dres}

uses
  Vcl.Forms,
  Main_Unit in 'Main_Unit\Main_Unit.pas' {Main_Frm},
  engView_Unit in 'Sub_Unit\engView_Unit.pas' {engView_Frm},
  List_Unit in 'List_Unit\List_Unit.pas' {List_Frm},
  Network_Unit in 'Main_Unit\Network_Unit.pas' {NetWork_Frm},
  DataModule_Unit in 'DataModule_Unit.pas' {DM1: TDataModule},
  Network_Sub_Unit in 'Sub_Unit\Network_Sub_Unit.pas' {Network_sub_frm},
  ControlPanel_Unit in 'Sub_Unit\ControlPanel_Unit.pas' {ControlPanel_Frm},
  NetWork_Sub2_Unit in 'Sub_Unit\NetWork_Sub2_Unit.pas' {NetWork_Sub2_Frm},
  Panel_Unit in 'Sub_Unit\Panel_Unit.pas' {Panel_Frm},
  Elect_Trance_Unit in 'Sub_Unit\Elect_Trance_Unit.pas' {Eelec_Trance_Frm},
  engView2_Unit in 'Sub_Unit\engView2_Unit.pas' {engview2_Frm},
  ListHome_Unit in 'Main_Unit\ListHome_Unit.pas' {ListHome_Frm},
  Foto_Unit in 'Sub_Unit\Foto_Unit.pas' {Foto_frm},
  CommonUtil_Unit in '00.CommonUtils\CommonUtil_Unit.pas',
  HHI_WebService in '00.CommonUtils\HHI_WebService.pas',
  UnitHHIMessage in '00.CommonUtils\UnitHHIMessage.pas',
  EngineOverView_Unit in 'Main_Unit\EngineOverView_Unit.pas' {EngineOverView_Frm},
  EngineOverView2_Unit in 'Main_Unit\EngineOverView2_Unit.pas' {EngineOverView2_Frm},
  LEDAlarmlistLampGen_Unit in 'Main_Unit\LEDAlarmlistLampGen_Unit.pas' {LEDAlarmlistLampGen_Frm},
  Calling_Function_Unit in 'Sub_Unit\Calling_Function_Unit.pas' {Calling_Function_Frm},
  Himsen_Communicator_Unit in 'Main_Unit\Himsen_Communicator_Unit.pas' {Himsen_Communicator_Frm},
  NetWork_Sub_Ip_Unit in 'Sub_Unit\NetWork_Sub_Ip_Unit.pas' {NetWork_Sub_Ip_Frm},
  PIPE_Unit in 'Main_Unit\PIPE_Unit.pas' {Pipe_Frm},
  TimerPool in 'Sub_Unit\TimerPool.pas',
  IPCThrdClient_PMS in '..\PMSOPCRest\common\IPCThrdClient_PMS.pas',
  IPCThrdConst_PMS in '..\PMSOPCRest\common\IPCThrdConst_PMS.pas',
  mwFixedRecSort in '..\PMSOPCRest\common\mwFixedRecSort.pas',
  mwStringHashList in '..\PMSOPCRest\common\mwStringHashList.pas',
  MyKernelObject in '..\PMSOPCRest\common\MyKernelObject.pas',
  UnitPMSOPCInterface in '..\PMSOPCRest\common\UnitPMSOPCInterface.pas',
  UnitClientMain in '..\PMSOPCRest\client\UnitClientMain.pas' {PMSOPCClientF},
  UnitTagCollect in '..\PMSOPCRest\common\UnitTagCollect.pas',
  Config_Unit in 'Main_Unit\Config_Unit.pas' {ConfigF},
  UnitMongoDBManager in '..\..\common\UnitMongoDBManager.pas',
  ParamSaveUnit in '..\PMSOPCRest\client\ParamSaveUnit.pas' {ParamSaveF},
  Iso8601Unit in '..\..\common\Iso8601Unit.pas',
  ElecPowerCalcClass in '..\..\common\ElecPowerCalcClass.pas',
  UnitGridView in 'UnitGridView.pas' {GridViewF},
  GridViewFrame in '..\HiMECS\Application\Utility\CommonFrame\GridViewFrame.pas' {Frame1: TFrame},
  CircularArray in '..\HiMECS\Application\Source\Common\CircularArray.pas',
  Group1OverView in 'Group1OverView.pas' {Form3},
  UnitSQLPMSOPC in 'UnitSQLPMSOPC.pas',
  UnitkwhReport in 'UnitkwhReport.pas' {kwh_reportF},
  pjhPlannerDatePicker in '..\..\..\vcl\pjhComponent\pjhPlannerDatePicker.pas',
  HoliDayCollect in '..\HiTEMS_CBY\00.CommonUtils\HoliDayCollect.pas',
  UnitBuzzerInterface in 'BuzzerServer\UnitBuzzerInterface.pas',
  UnitAlarmCollect in '..\PMSOPCRest\common\UnitAlarmCollect.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TList_Frm, List_Frm);
  Application.CreateForm(TPMSOPCClientF, PMSOPCClientF);
  Application.CreateForm(TConfigF, ConfigF);
  Application.CreateForm(TParamSaveF, ParamSaveF);
  Application.CreateForm(TGridViewF, GridViewF);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
