program Trouble_Report;

uses
  Vcl.Forms,
  Vcl.Controls,
  SysUtils,
  ComObj,
  Winapi.Windows,
  Winapi.ActiveX,
  Main_Unit in 'Forms\Main_Form\Main_Unit.pas' {Main_Frm},
  Trouble_Unit in 'Forms\Trouble_Form\Trouble_Unit.pas' {Trouble_Frm},
  TroubleCd_Unit in 'Forms\Trouble_Form\TroubleCd_Unit.pas' {TroubleCd_Frm},
  EngGeneral_Unit in 'Forms\Sub_Form\EngGeneral_Unit.pas' {EngGeneral_Frm},
  UserFind_Unit in 'Forms\Sub_Form\UserFind_Unit.pas' {UserFind_Frm},
  addRefer_Unit in 'Forms\Approval_Form\addRefer_Unit.pas' {addRefer_Frm},
  Approvaln_Unit in 'Forms\Approval_Form\Approvaln_Unit.pas' {Approvaln_Frm},
  PendingRp_Unit in 'Forms\Approval_Form\PendingRp_Unit.pas' {PendingRp_Frm},
  ReturnMsg_Unit in 'Forms\Approval_Form\ReturnMsg_Unit.pas' {ReturnMsg_Frm},
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  DownLoad_ in 'Forms\Sub_Form\DownLoad_.pas' {DownLoadF},
  STATISTICS in 'Forms\Sub_Form\STATISTICS.pas' {RP_Agg},
  rpStep_Unit in 'Forms\Sub_Form\rpStep_Unit.pas' {rpStep_Frm},
  userConditions_Unit in 'Forms\Sub_Form\userConditions_Unit.pas' {userConditions_Frm},
  TRtypeUpdate_Unit in 'Forms\Sub_Form\TRtypeUpdate_Unit.pas' {TRtypeUpdate_Frm},
  DetailS_Unit in 'Forms\Sub_Form\DetailS_Unit.pas' {DetailS_Frm},
  Trouble_Mobile_Unit in 'Forms\Trouble_Form\Trouble_Mobile_Unit.pas' {Trouble_Mobile_Frm},
  TeamChange_Unit in 'Forms\Sub_Form\TeamChange_Unit.pas' {TeamChange_Frm},
  mobileEmpIds_Unit in 'Forms\Sub_Form\mobileEmpIds_Unit.pas' {mobileEmpIds_Frm},
  HiTEMS_TRC_COMMON in 'Forms\Common\HiTEMS_TRC_COMMON.pas',
  findUser_Unit in 'Forms\HiTEMS_TRC_Form\findUser_Unit.pas' {findUser_Frm},
  trObject_Unit in 'Forms\HiTEMS_TRC_Form\trObject_Unit.pas' {trObject_Frm},
  trReport_Unit in 'Forms\HiTEMS_TRC_Form\trReport_Unit.pas' {trReport_Frm},
  HiTEMS_TRC_CONST in 'Forms\Common\HiTEMS_TRC_CONST.pas',
  himsenDesc_Unit in 'Forms\HiTEMS_TRC_Form\himsenDesc_Unit.pas' {himsenDesc_Frm},
  equipment_Unit in 'Forms\HiTEMS_TRC_Form\equipment_Unit.pas' {equipment_Frm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain_Frm, Main_Frm);
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(ThimsenDesc_Frm, himsenDesc_Frm);
  Application.CreateForm(Tequipment_Frm, equipment_Frm);
  Application.Run;

end.
