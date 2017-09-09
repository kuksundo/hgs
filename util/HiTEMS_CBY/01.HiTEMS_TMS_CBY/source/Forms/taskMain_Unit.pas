{********************************************************************}
{ HiTEMS TASK MANAGEMENT                                             }
{ for Delphi DELPHI XE2                                              }
{                                                                    }
{ written by MEC DEV.                                                }
{            copyright ?2013                                         }
{            Email : sh2bom@gmail.com                                }
{********************************************************************}

unit taskMain_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, AdvMenus, AdvToolBar, AdvToolBarStylers, StdCtrls,
  AdvOfficeTabSet, AdvOfficeTabSetStylers, AdvMenuStylers, AdvOfficeStatusBar,
  Vcl.ExtCtrls, AdvNavBar, NxCollection, Vcl.ImgList, AdvGlowButton,DateUtils,
  CurvyControls, Vcl.ComCtrls, JvExControls, JvGradient, AdvPageControl,
  AdvSmoothButton, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, NxEdit,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, DB,
  Generics.Collections;

type
  TtaskMain_Frm = class(TForm)
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    AdvMainMenu1: TAdvMainMenu;
    Tasks1: TMenuItem;
    Window1: TMenuItem;
    AddChild: TMenuItem;
    Cascade1: TMenuItem;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvMenuStyler1: TAdvMenuStyler;
    N1: TMenuItem;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    AdvNavBar1: TAdvNavBar;
    AdvNavBarPanel1: TAdvNavBarPanel;
    CurvyPanel1: TCurvyPanel;
    CurvyPanel2: TCurvyPanel;
    AdvGlowButton2: TAdvGlowButton;
    AdvGlowButton3: TAdvGlowButton;
    AdvNavBarPanel2: TAdvNavBarPanel;
    CurvyPanel3: TCurvyPanel;
    Label1: TLabel;
    CurvyPanel4: TCurvyPanel;
    AdvGlowButton4: TAdvGlowButton;
    N3: TMenuItem;
    AdvGlowButton6: TAdvGlowButton;
    NxSplitter1: TNxSplitter;
    fuction1: TMenuItem;
    SMS1: TMenuItem;
    Application1: TMenuItem;
    Photorum1: TMenuItem;
    AdvGlowButton7: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton5: TAdvGlowButton;
    Configuration1: TMenuItem;
    N2: TMenuItem;
    LDS1: TMenuItem;
    Forms1: TMenuItem;
    LDS2: TMenuItem;
    btn_overTime: TAdvGlowButton;
    AdvNavBarPanel3: TAdvNavBarPanel;
    CurvyPanel5: TCurvyPanel;
    Label3: TLabel;
    CurvyPanel6: TCurvyPanel;
    btn_testStatus: TAdvGlowButton;
    Label2: TLabel;
    btn_testResult: TAdvGlowButton;
    AdvGlowButton8: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure AddChildClick(Sender: TObject);
    procedure mDrvBtnClick(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure AdvGlowButton3Click(Sender: TObject);
    procedure AdvGlowButton9Click(Sender: TObject);
    procedure AdvGlowButton10Click(Sender: TObject);
    procedure mProcBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure SMS1Click(Sender: TObject);
    procedure Photorum1Click(Sender: TObject);
    procedure AdvGlowButton7Click(Sender: TObject);
    procedure AdvGlowButton4Click(Sender: TObject);
    procedure AdvGlowButton6Click(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton5Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure LDS2Click(Sender: TObject);
    procedure btn_overTimeClick(Sender: TObject);
    procedure btn_testStatusClick(Sender: TObject);
    procedure btn_testResultClick(Sender: TObject);
    procedure AdvGlowButton8Click(Sender: TObject);
  private
    { Private declarations }
    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
    procedure ISCreateForm(aClass: TFormClass; aName ,aCaption : String);

    procedure Check_Pending_Approve;
    procedure CheckExG2antDll;//ganttChart dll

  public
  end;

var
  taskMain_Frm: TtaskMain_Frm;

implementation
uses
  testResult_Unit,
  testStatus_Unit,
  overTime_Unit,
  setEngineDialog_Unit,
  commonCode_Unit,
  localSheet_Unit,
  workOrder_Unit,
  taskStatistics_Unit,
  dailyReportView_Unit,
  dailyManPower_Unit,
  taskView_Unit,
  photorum_Unit,
  sendSMS_Unit,
  taskHome_Unit,
  workLog_Unit,
  bussLog_Unit,
  taskManagement_Unit,
  HITEMS_TMS_CONST,
  HITEMS_TMS_COMMON,
  CommonUtil_Unit,
  DataModule_Unit,
  weeklyProcessPlan_Unit;

{$R *.dfm}

procedure TtaskMain_Frm.AddChildClick(Sender: TObject);
begin
  Close;
end;

procedure TtaskMain_Frm.AdvGlowButton10Click(Sender: TObject);
begin
//  ISCreateForm(TdailyReport_Frm,'dailyReport_Frm','[일일업무 관리]');
end;

procedure TtaskMain_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  ISCreateForm(TweeklyProcessPlanF,'weeklyProcessPlanF','[주간 공정 회의]');
end;

procedure TtaskMain_Frm.mDrvBtnClick(Sender: TObject);
begin
//  ISCreateForm(TdrvRecord_Frm,'drvRecord_Frm','[엔진운전기록조회]');
  ShowMessage('준비중 입니다.');
end;

procedure TtaskMain_Frm.mProcBtnClick(Sender: TObject);
begin
//  ISCreateForm(TdailyWorkLog_Frm,'dailyWorkLog_Frm','[일일공정현황조회]');
  ShowMessage('준비중 입니다.');
end;

procedure TtaskMain_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  ISCreateForm(TtaskManagement_Frm,'taskManagement_Frm','[업무관리]');
end;

procedure TtaskMain_Frm.AdvGlowButton3Click(Sender: TObject);
var
  lstr,
  luserId : String;
begin
  with DM1.OraQuery1 do
  begin
    lUserId := DM1.FUserInfo.CurrentUsers;
    if not(DM1.FUserInfo.CurrentUsers[1] in ['A'..'Z']) then
    begin
      ISCreateForm(TworkLog_Frm,'workLog_Frm','[일일공정진행현황]');
    end
    else
    begin
      ISCreateForm(TbussLog_Frm,'bussLog_Frm','[일일업무관리]');

    end;
  end;
end;

procedure TtaskMain_Frm.AdvGlowButton4Click(Sender: TObject);
begin
  ISCreateForm(TdailyManPower_Frm,'dailyManPower_Frm','[일일가동율 현황 기록/열람]');
end;

procedure TtaskMain_Frm.AdvGlowButton5Click(Sender: TObject);
begin
  ISCreateForm(TworkOrder_Frm,'workOrder_Frm','[일일작업관리]');
end;

procedure TtaskMain_Frm.AdvGlowButton6Click(Sender: TObject);
begin
  ISCreateForm(TdailyReportView_Frm,'dailyReportView_Frm','[지난업무내용 조회]');
end;

procedure TtaskMain_Frm.AdvGlowButton7Click(Sender: TObject);
begin
  ISCreateForm(TtaskView_Frm,'taskView_Frm','[주요업무현황 열람]');
end;

procedure TtaskMain_Frm.AdvGlowButton8Click(Sender: TObject);
begin
  ISCreateForm(TtaskStatistics_Frm,'taskStatistics_Frm','[업무실적통계 조회]');
end;

procedure TtaskMain_Frm.AdvGlowButton9Click(Sender: TObject);
begin
//  ISCreateForm(TtmsApprove_Frm,'tmsApprove_Frm','[업무승인 관리]');
//  ISCreateForm(TtaskManagement_Frm,'taskManagement_Frm','[시험일정 관리]');
end;

procedure TtaskMain_Frm.btn_overTimeClick(Sender: TObject);
begin
  ISCreateForm(ToverTime_Frm,'overTime_Frm','[연장근로현황 열람]');
end;

procedure TtaskMain_Frm.btn_testResultClick(Sender: TObject);
begin
  ISCreateForm(TtestResult_Frm,'testResult_Frm','[시헙결과 열람]');
end;

procedure TtaskMain_Frm.btn_testStatusClick(Sender: TObject);
begin
  ISCreateForm(TtestStatus_Frm,'testStatus_Frm','[시험현황 열람]');
end;

procedure TtaskMain_Frm.CheckExG2antDll;
const
  cFileName = 'C:\temp\ExG2antt.dll';
var
  lms : TMemoryStream;
begin
  if not FileExists(cFileName) then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM APP_VERSION ' +
              'WHERE FILENAME = :param1 ');
      ParamByName('param1').AsString := 'ExG2antt.dll';
      Open;

      if RecordCount <> 0 then
      begin
        lms := TMemoryStream.Create;
        try
          TBlobField(FieldByName('FILES')).SaveToStream(lms);
          if lms.Size > 0 then
          begin
            if not DirectoryExists('C:\Temp') then
              CreateDir('C:\Temp');

            lms.SaveToFile(cFileName);


            if FileExists(cFileName) then
            begin
              WinExec('Regsvr32.exe '+cFileName, SW_HIDE);
            end;
          end;
        finally
          FreeAndNil(lms);
        end;
      end;
    end;
  end;
end;

procedure TtaskMain_Frm.Check_Pending_Approve;
begin
//  with DM1.OraQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('select * from HITEMS_TMS_APPROVE_V ');
//    SQL.Add('where APPROVECODE = 0 ');
//    SQL.Add('and MANAGER = '''+CurrentUsers+''' '+
//            'order by APPTYPE, INDATE ');
//    Open;
//
//    if not(RecordCount = 0) then
//    begin
//      AdvGlowButton5.Caption := AdvGlowButton5.Caption +'('+IntToStr(RecordCount)+')';
//
////      AdvGlowButton3.ShortCutHint := IntToStr(RecordCount);
////      AdvGlowButton3.ShortCutHintPos := shpRight;
////      AdvGlowButton3.ShowShortCutHint;
//    end;
//  end;
end;

procedure TtaskMain_Frm.ChildFormClose(Sender: TObject; var Action: TCloseAction);
begin
  AdvToolBar1.RemoveMDIChildMenu(TForm(Sender));
  Action   := caFree;
end;

procedure TtaskMain_Frm.FormCreate(Sender: TObject);
var
  lUser : String;
  lPriv : Integer;
begin
  AdvNavBar1.ActiveTabIndex := 0;
  lUser := ParamStr(1);
  Set_User_Info(lUser);
  lPriv := Check_User_position(lUser);

  CheckExG2antDll;
end;

procedure TtaskMain_Frm.FormShow(Sender: TObject);
begin
  ISCreateForm(TtaskHome_Frm,'taskHome_Frm','[업무관리시스템홈]');
end;

procedure TtaskMain_Frm.ISCreateForm(aClass: TFormClass; aName,
  aCaption: String);
var
  aForm : TForm;
  i : Integer;
begin
  aForm := nil;
  try
    LockMDIChild(True);
    for i:=(taskMain_Frm.MDIChildCount - 1) DownTo 0 Do
    begin
      if SameText(taskMain_Frm.MDIChildren[I].Name,aName) then
      begin
        aForm := taskMain_Frm.MDIChildren[I];
        Break;
      end;
    end;

    if aForm = nil Then
    begin
      aForm := aClass.Create(Application);
      with aForm do
      begin
        Caption := aCaption;
        OnClose := ChildFormClose;

      end;
      AdvToolBar1.AddMDIChildMenu(aForm);
//      AdvOfficeMDITabSet1.AddTab(aForm);
    end;

    if aForm.WindowState = wsMinimized then
      aForm.WindowState := wsNormal;

    aForm.Show;
  finally
    LockMDIChild(False);
  end;
end;

procedure TtaskMain_Frm.LDS2Click(Sender: TObject);
var
  LEngineType : String;
  LProjNo : String;
  i : Integer;
begin
  LEngineType := Create_EngineDialog_Frm;
  if LEngineType <> '' then
  begin
    i := Pos('-',LEngineType)-1;
    LProjNo := Copy(LEngineType,0,i);

    Create_localSheet_Frm('', 'A',LProjNo);

  end;
end;

procedure TtaskMain_Frm.N2Click(Sender: TObject);
var
  i : Integer;
begin
  Create_commonCode_Frm;
end;

procedure TtaskMain_Frm.N3Click(Sender: TObject);
begin
  ISCreateForm(TtaskHome_Frm,'taskHome_Frm','[업무관리시스템홈]');
end;

procedure TtaskMain_Frm.Photorum1Click(Sender: TObject);
begin
  ISCreateForm(Tphotorum_Frm,'photorum_Frm','[포토클라우드]');
end;

procedure TtaskMain_Frm.SMS1Click(Sender: TObject);
begin
  Create_sendSMS_Frm('');
end;

end.
