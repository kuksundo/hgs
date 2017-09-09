unit main_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Vcl.ImgList, Vcl.Menus, AdvMenus,
  AdvMenuStylers, AdvOfficeTabSet, AdvOfficeTabSetStylers, AdvToolBar,
  AdvToolBarStylers, AdvOfficeStatusBar, Vcl.StdCtrls, OtlParallel, OtlTask, OtlTaskControl,
  Vcl.ExtCtrls, JvExControls, JvGradient;

type
  Tmain_Frm = class(TForm)
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    AdvDockPanel2: TAdvDockPanel;
    AdvToolBar2: TAdvToolBar;
    AdvToolBarButton1: TAdvToolBarButton;
    AdvToolBarButton2: TAdvToolBarButton;
    AdvToolBarButton4: TAdvToolBarButton;
    AdvOfficeMDITabSet1: TAdvOfficeMDITabSet;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvMenuStyler1: TAdvMenuStyler;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    PopupMenu1: TPopupMenu;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    AdvPopupMenu1: TAdvPopupMenu;
    AdvMainMenu1: TAdvMainMenu;
    Tasks1: TMenuItem;
    AddChild: TMenuItem;
    Window1: TMenuItem;
    Cascade1: TMenuItem;
    N1: TMenuItem;
    toolbarx48: TImageList;
    IdHTTP1: TIdHTTP;
    ImageList1: TImageList;
    AdvToolBarButton5: TAdvToolBarButton;
    WelcomePage1: TMenuItem;
    firstTimer: TTimer;
    JvGradient1: TJvGradient;
    procedure AdvToolBarButton1Click(Sender: TObject);
    procedure AdvToolBarButton2Click(Sender: TObject);
    procedure AdvToolBarButton4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure AdvToolBarButton5Click(Sender: TObject);
    procedure WelcomePage1Click(Sender: TObject);
    procedure firstTimerTimer(Sender: TObject);
  private
    { Private declarations }
    FChildCount: Integer;
    FFirst : Boolean;
  public
    { Public declarations }
    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
    procedure ISCreateForm(aClass: TFormClass; aName ,aCaption : String);
    procedure Set_User_Info(aParam:String);
  end;

var
  main_Frm: Tmain_Frm;

implementation
uses
  CommonUtil_Unit,
  lcalDataSheet_Unit,
  progress_Unit,
  newTestHistory_Unit,
  HitemsCode_Unit,
  mountedHistory_Unit,
  home_Unit,
  newMounted_Unit,
  HiTEMS_ETH_COMMON,
  HiTEMS_ETH_CONST,
  DataModule_Unit;

{$R *.dfm}

{ Tmain_Frm }

procedure Tmain_Frm.AdvToolBarButton1Click(Sender: TObject);
begin
//  if Assigned(home_Frm) then
//    home_Frm.Show
//  else
//    ISCreateForm(Thome_Frm,'home_Frm','[Welcome Page]');
end;

procedure Tmain_Frm.AdvToolBarButton2Click(Sender: TObject);
begin
  if Assigned(mountedHistory_Frm) then
    mountedHistory_Frm.Show
  else
    ISCreateForm(TmountedHistory_Frm,'mountedHistory_Frm','[힘센엔진-파트탑재이력]');

end;

procedure Tmain_Frm.AdvToolBarButton4Click(Sender: TObject);
begin
  if Assigned(newMounted_Frm) then
    newMounted_Frm.Show
  else
    ISCreateForm(TnewMounted_Frm,'newMounted_Frm','[파트 탑재관리]');

  Self.Invalidate;
end;

procedure Tmain_Frm.AdvToolBarButton5Click(Sender: TObject);
begin
  if Assigned(newTestHistory_Frm) then
    newTestHistory_Frm.Show
  else
    ISCreateForm(TnewTestHistory_Frm,'newTestHistory_Frm','[힘센엔진 시험이력관리]');
end;

procedure Tmain_Frm.ChildFormClose(Sender: TObject; var Action: TCloseAction);
begin
  AdvToolBar1.RemoveMDIChildMenu(TForm(Sender));
  Action   := caFree;
end;

procedure Tmain_Frm.firstTimerTimer(Sender: TObject);
begin
//firstTimer.Enabled := False;
//AdvToolBarButton1Click(Sender);
end;

procedure Tmain_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    FFirst := False;



  end;
end;

procedure Tmain_Frm.FormCreate(Sender: TObject);
var
  li: Integer;
  le: Integer;
  lParam : String;
begin
  FFirst := True;
  FChildCount := 0;
  lParam := ParamStr(1);
  Set_User_Info(lParam);
  firstTimer.Enabled := True; //Open the home-page
end;
                     
procedure Tmain_Frm.ISCreateForm(aClass: TFormClass; aName, aCaption: String);
var
  aForm : TForm;
  i : Integer;
begin
  aForm := nil;
  try
    LockMDIChild(True);
    for i:=(Main_Frm.MDIChildCount - 1) DownTo 0 Do
    begin
      if SameText(Main_Frm.MDIChildren[I].Name,aName) then
      begin
        aForm := Main_Frm.MDIChildren[I];
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
      AdvOfficeMDITabSet1.AddTab(aForm);
    end;

    if aForm.WindowState = wsMinimized then
      aForm.WindowState := wsNormal;

    aForm.Show;
  finally
    LockMDIChild(False);
  end;
end;

procedure Tmain_Frm.N5Click(Sender: TObject);
var
  lCaption : String;
begin
  lCaption := '힘센시험이력관리시스템-[시험코드관리]';

  if Assigned(HitemsCode_Frm) then
    HitemsCode_Frm.Show
  else
    ISCreateForm(THitemsCode_Frm,'HitemsCode_Frm',lCaption);

end;

procedure Tmain_Frm.Set_User_Info(aParam: String);
var
  LStr: string;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HITEMS.HITEMS_USER ' +
            'where UserID = '''+aParam+''' ');
    Open;

    if not(RecordCount = 0) then
    begin
      with FUserInfo do
      begin
        UserID   := FieldByName('USERID').AsString;
        UserName := FieldByName('NAME_KOR').AsString;
        LStr := FieldByName('DEPT_CD').AsString;
        DeptNo   := Copy(LStr, 1,3);
        TEAMNO   := LStr;
      end;
    end
    else
    begin
      AdvToolbar1.Enabled := False;
      AdvToolbar2.Enabled := False;
      raise Exception.Create('등록된 사용자가 아닙니다.');
    end;
  end;
end;

procedure Tmain_Frm.WelcomePage1Click(Sender: TObject);
begin
  if Assigned(home_Frm) then
    home_Frm.Show
  else
    ISCreateForm(Thome_Frm,'home_Frm','[Welcome Page]');
end;

end.
