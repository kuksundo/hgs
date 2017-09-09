program HiTEMS_ETH;

uses
  Vcl.Forms,
  main_Unit in 'Forms\Main_Form\main_Unit.pas' {main_Frm},
  home_Unit in 'Forms\Main_Form\home_Unit.pas' {home_Frm},
  HiTEMS_ETH_CONST in 'Forms\Common\HiTEMS_ETH_CONST.pas',
  saveNotification_Unit in 'Forms\Sub_Form\saveNotification_Unit.pas' {saveNotification_Frm},
  workerList_Unit in 'Forms\Sub_Form\workerList_Unit.pas' {workerList_Frm},
  DataModule_Unit in 'Forms\DataModule_Unit.pas' {DM1: TDataModule},
  addRoot_Unit in 'Forms\Sub_Form\addRoot_Unit.pas' {addRoot_Frm},
  historyList_Unit in 'Forms\Sub_Form\historyList_Unit.pas' {historyList_Frm},
  newMounted_Unit in 'Forms\Main_Form\newMounted_Unit.pas' {newMounted_Frm},
  mountedHistory_Unit in 'Forms\Main_Form\mountedHistory_Unit.pas' {mountedHistory_Frm},
  HitemsAddCode_Unit in 'Forms\Code_Form\HitemsAddCode_Unit.pas' {HitemsAddCode_Frm},
  HitemsCode_Unit in 'Forms\Code_Form\HitemsCode_Unit.pas' {HitemsCode_Frm},
  newMs_Unit in 'Forms\Code_Form\newMs_Unit.pas' {newMs_Frm},
  addDurability_Unit in 'Forms\Sub_Form\addDurability_Unit.pas' {addDurability_Frm},
  MountedGrid_Unit in 'Forms\Sub_Form\MountedGrid_Unit.pas' {mountedGrid_Frm},
  imgViewer_Unit in 'Forms\Sub_Form\imgViewer_Unit.pas' {imgViewer_Frm},
  progress_Unit in 'Forms\Sub_Form\progress_Unit.pas' {progress_Frm},
  lcalDataSheet_Unit in 'Forms\Sub_Form\lcalDataSheet_Unit.pas' {localDataSheet_Frm},
  Vcl.Themes,
  Vcl.Styles,
  HitemsAddGroup_Unit in 'Forms\Code_Form\HitemsAddGroup_Unit.pas' {HitemsAddGroup_Frm},
  newTestHistory_Unit in 'Forms\Main_Form\newTestHistory_Unit.pas' {newTestHistory_Frm},
  msCheckView_Unit in 'Forms\Sub_Form\msCheckView_Unit.pas' {msCheckView_Frm},
  testDetail_Unit in 'Forms\Sub_Form\testDetail_Unit.pas' {testDetail_Frm},
  searchHistory_Unit in 'Forms\Sub_Form\searchHistory_Unit.pas' {searchHistory_Frm},
  analysis_Unit in 'Forms\Sub_Form\analysis_Unit.pas' {analysis_Frm},
  HiTEMS_ETH_COMMON in 'Forms\Common\HiTEMS_ETH_COMMON.pas',
  CommonUtil_Unit in '..\..\00.CommonUtils\CommonUtil_Unit.pas',
  imagefunctions_Unit in '..\..\00.CommonUtils\imagefunctions_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(Tmain_Frm, main_Frm);
  Application.Run;
end.
