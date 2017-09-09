{
  V1.1.8 수정사항: 2012.3.6
  1) bpl로 부터 Component load함
     - cannot load package A It contains unit X error 해결
     - 방법: bpl에서 공통으로 쓰이는 Unit을 따로 bpl로 만듬(pjhPackageUnits.bpl)
     -       각 package의 required에 pjhPackageUnits.dcp 추가 후 build
  2) InheritsFrom 함수가 nil을 반환하는 문제 해결
     - 방법:

  V1.1.7 수정사항
  1) Delphi XE2 Version upgrade
  2) Rename CommLogic.pas to CustomLogic.pas
  3) Rename CommLogicType.pas to CustomLogicType.pas

  V 1.1.6 수정사항
  1) CommLogic.pas Unit을 CommLogic2.pas로 변경함
  2) CommLogic2에서 TCustomLogicConnector의 Ancestor를 TObject에서 TGraphicControl로 변경함
     왜) 노드가 화면에서 사라지면 화살표도 화면에서 사라지거나 Invalidate가 안되기 때문임.

  V 1.1.5 수정사항
  1) Indy Component(Non-Visual Component) 추가함
  2) Non-Visual Component 사용 가능함(pjhFormDesigner 수정함-구버젼은 pjhFormDesigner_VisualOnly.pas임)
  3) 폼 위의 Component를 마우스로 드래그 했을때 Property Inspector의 Combo에서 문자 사라지는 버그 수정(Inserted와 Modified 함수에서 중복 실행 되는 함수 막음)

  V 1.1.4 수정사항
  1) TpjhWriteComport,TpjhWriteComport 에서 FAMem 관련 속성 제거함

  V 1.1.3 수정사항
  1) LogicControl의 모양을 XiButton모양으로 수정함
  2) DesignPanel을 없애고 폼에 직접 그리게 함

  V 1.1.2 수정사항
  1) Component Pallete를 멀티 탭으로 구현함 2003.12.1

  V 1.1 수정사항
  1) DesignPanel위에서만 디자인 되던 것을 Form위에서도 가능하게 수정
}

{$DEFINE USE_PACKAGE}//pjhClasses.pas 파일에 있는 define문도 함께 수정해야 함.

unit frmMainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ActnList, StdCtrls, Buttons, ExtCtrls, iniFiles,
  Mask, Grids, FileCtrl, MPlayer, Gauges,  ColorGrd, Spin, Outline, DirOutln,
  Calendar, CheckLst, Tabs, TabNotbk, ImgList, ComCtrls, ToolWin, StdActns,
  //StartButton2, CustomLogic, FlowChartLogic, CustomLogicType,
  EasterEgg, ConsoleDebug, CopyData, pjhFormDesigner,
  //FAMemMan_pjh, FANumEdit, FAGauges, FANumLabel,
  klist, pjhClasses, TypInfo, //IndyLanCommLogic,
  pjhObjectInspector, AdvShapeButton, AdvToolBar, AdvGlowButton,
  AdvOfficeStatusBar, Vcl.ExtActns, AdvOfficeStatusBarStylers, AdvPreviewMenu,
  AdvPreviewMenuStylers, AdvMenus, AdvMenuStylers, AdvOfficeHint,
  AdvToolBarStylers, AdvOfficeTabSet, AdvOfficeTabSetStylers, HiMECSComponentCollect
  , pjhLogicPanelUnit, HiMECSFormCollect//, FlowChartLogic, pjhStartButton
{$IFDEF USE_PACKAGE}
  , PackageList
{$ELSE}
  //,IdUDPClient, IdTCPConnection, IdTCPClient,
  //IdUDPBase, IdUDPServer, IdBaseComponent, IdComponent, IdTCPServer
{$ENDIF};

type
  TCreateChildFuncFromBPL = function: TForm;

  TfrmMain = class(TForm)
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    actNew: TAction;
    New1: TMenuItem;
    New2: TMenuItem;
    actPreview: TAction;
    actPropsView: TAction;
    View1: TMenuItem;
    Properties1: TMenuItem;
    SaveDialog1: TSaveDialog;
    actSave: TAction;
    actSaveAs: TAction;
    actOpen: TAction;
    actCloseAll: TAction;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Closeall1: TMenuItem;
    actClose: TAction;
    Close1: TMenuItem;
    ImageList1: TImageList;
    actSaveSaveAll: TAction;
    actCopy: TAction;
    actCut: TAction;
    actPaste: TAction;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Copy2: TMenuItem;
    Cut2: TMenuItem;
    Paste2: TMenuItem;
    N2: TMenuItem;
    actDelete: TAction;
    N3: TMenuItem;
    Delete1: TMenuItem;
    Delete2: TMenuItem;
    actLock: TAction;
    Lock1: TMenuItem;
    Lock2: TMenuItem;
    actUnlock: TAction;
    actUnlock1: TMenuItem;
    Unlock1: TMenuItem;
    actUnlockAll: TAction;
    UnlockAll1: TMenuItem;
    actSelectAll: TAction;
    actSelectAll1: TMenuItem;
    actAlignToGrid: TAction;
    actAlignToGrid1: TMenuItem;
    AlignToGrid1: TMenuItem;
    actBringToFront: TAction;
    actSendToBack: TAction;
    N5: TMenuItem;
    AlignToGrid2: TMenuItem;
    Sendtoback1: TMenuItem;
    Bringtofront1: TMenuItem;
    Sendtoback2: TMenuItem;
    N6: TMenuItem;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowArrange1: TWindowArrange;
    Window1: TMenuItem;
    Arrange1: TMenuItem;
    Cascade1: TMenuItem;
    MinimizeAll1: TMenuItem;
    ileHorizontally1: TMenuItem;
    ileVertically1: TMenuItem;
    actEnabled: TAction;
    actEnable1: TMenuItem;
    Enable1: TMenuItem;
    actEnableAll: TAction;
    EnableAll1: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    actChangeData: TAction;
    actZoom100: TAction;
    actPrint: TAction;
    actALLeft: TAction;
    actALRight: TAction;
    actALTop: TAction;
    actALBottom: TAction;
    actALHSpace: TAction;
    actALVSpace: TAction;
    actALHCenter: TAction;
    actALVCenter: TAction;
    actALHCenterWindow: TAction;
    actALVCenterWindow: TAction;
    Align1: TMenuItem;
    actALLeft1: TMenuItem;
    actALRight1: TMenuItem;
    actALHSpace1: TMenuItem;
    actALHCenter1: TMenuItem;
    actALHCenterWindow1: TMenuItem;
    N9: TMenuItem;
    actALTop1: TMenuItem;
    actALBottom1: TMenuItem;
    actALVSpace1: TMenuItem;
    actALVCenter1: TMenuItem;
    actALVCenterWindow1: TMenuItem;
    Align2: TMenuItem;
    actALLeft2: TMenuItem;
    actALRight2: TMenuItem;
    actALHSpace2: TMenuItem;
    actALHCenter2: TMenuItem;
    actALHCenterWindow2: TMenuItem;
    N10: TMenuItem;
    actALTop2: TMenuItem;
    actALBottom2: TMenuItem;
    actALVSpace2: TMenuItem;
    actALVCenter2: TMenuItem;
    actALVCenterWindow2: TMenuItem;
    actRepProps: TAction;
    About1: TMenuItem;
    hisProgramis1: TMenuItem;
    ELDesigner1: TELDesigner;
    ToolBar1: TMenuItem;
    WindowsBar1: TMenuItem;
    StatusBar1: TMenuItem;
    ComponentAlignment1: TMenuItem;
    Run1: TMenuItem;
    RUn2: TMenuItem;
    actRun: TAction;
    DebugWindow1: TMenuItem;
    actDebugWin: TAction;
    OpenDialog1: TOpenDialog;
    ShortCutKeyList1: TMenuItem;
    actUndelete: TAction;
    Undo1: TMenuItem;
    actExit: TAction;
    SubToolBar11: TMenuItem;
    SubToolBar21: TMenuItem;
    actBreakPoint: TAction;
    N4: TMenuItem;
    BreakPoint1: TMenuItem;
    Component1: TMenuItem;
    InstallPackages1: TMenuItem;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvOfficeHint1: TAdvOfficeHint;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    AdvPreviewMenu1: TAdvPreviewMenu;
    AdvPreviewMenuOfficeStyler1: TAdvPreviewMenuOfficeStyler;
    ImageList2: TImageList;
    ImageList3: TImageList;
    AdvPopupMenu2: TAdvPopupMenu;
    Showtoolbarontop1: TMenuItem;
    Showtoolbarbelow1: TMenuItem;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    AdvPopupMenu3: TAdvPopupMenu;
    UsersnAddremoveandchangeusersinthenetwork1: TMenuItem;
    InternetnAllowstoconfigurehowtoconnecttotheinternet1: TMenuItem;
    GallerynViewthegalleryofuserimages1: TMenuItem;
    ImageList4: TImageList;
    AdvMenuOfficeStyler2: TAdvMenuOfficeStyler;
    AdvPopupMenu4: TAdvPopupMenu;
    MenuItem3: TMenuItem;
    FontDialog1: TFontDialog;
    ImageList5: TImageList;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    AdvToolBarPager1: TAdvToolBarPager;
    AdvPage1: TAdvPage;
    AdvToolBar3: TAdvToolBar;
    AdvToolBar5: TAdvToolBar;
    AdvPage2: TAdvPage;
    AdvQuickAccessToolBar1: TAdvQuickAccessToolBar;
    AdvGlowButton12: TAdvGlowButton;
    AdvGlowButton13: TAdvGlowButton;
    AdvGlowButton19: TAdvGlowButton;
    AdvShapeButton1: TAdvShapeButton;
    AdvToolBar2: TAdvToolBar;
    AdvGlowButton74: TAdvGlowButton;
    AdvGlowButton75: TAdvGlowButton;
    AdvGlowButton76: TAdvGlowButton;
    AdvGlowButton23: TAdvGlowButton;
    AdvGlowButton77: TAdvGlowButton;
    AdvGlowButton78: TAdvGlowButton;
    AdvGlowButton79: TAdvGlowButton;
    AdvGlowButton20: TAdvGlowButton;
    AdvGlowButton21: TAdvGlowButton;
    AdvGlowButton22: TAdvGlowButton;
    AdvGlowButton44: TAdvGlowButton;
    AdvToolBar6: TAdvToolBar;
    AdvGlowButton10: TAdvGlowButton;
    AdvGlowButton24: TAdvGlowButton;
    AdvGlowButton25: TAdvGlowButton;
    AdvToolBar1: TAdvToolBar;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    AdvGlowButton3: TAdvGlowButton;
    AdvToolBar4: TAdvToolBar;
    AdvGlowButton4: TAdvGlowButton;
    AdvToolBar7: TAdvToolBar;
    AdvGlowButton5: TAdvGlowButton;
    AdvGlowButton6: TAdvGlowButton;
    AdvGlowButton7: TAdvGlowButton;
    AdvGlowButton8: TAdvGlowButton;
    AdvGlowButton9: TAdvGlowButton;
    AdvToolBar8: TAdvToolBar;
    AdvGlowButton11: TAdvGlowButton;
    AdvGlowButton14: TAdvGlowButton;
    AdvGlowButton15: TAdvGlowButton;
    AdvGlowButton16: TAdvGlowButton;
    AdvGlowButton17: TAdvGlowButton;
    AdvGlowButton18: TAdvGlowButton;
    MDITab1: TAdvOfficeMDITabSet;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    AdvPage3: TAdvPage;
    PageControl1: TPageControl;
    actWindowbar: TAction;
    actStatusBar: TAction;
    actNewSDI: TAction;
    NewSDI1: TMenuItem;
    actOpenSDI: TAction;
    OpenSDI1: TMenuItem;
    procedure WMCopyData(var m : TMessage); message WM_COPYDATA;
    procedure actNewExecute(Sender: TObject);
    procedure actPreviewExecute(Sender: TObject);
    procedure actPreviewUpdate(Sender: TObject);
    procedure actPropsViewExecute(Sender: TObject);
    procedure actPropsViewUpdate(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsUpdate(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actCloseAllUpdate(Sender: TObject);
    procedure actCloseAllExecute(Sender: TObject);
    procedure actCloseUpdate(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actSaveSaveAllUpdate(Sender: TObject);
    procedure actSaveSaveAllExecute(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure actCutUpdate(Sender: TObject);
    procedure actPasteUpdate(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actLockUpdate(Sender: TObject);
    procedure actLockExecute(Sender: TObject);
    procedure actUnlockUpdate(Sender: TObject);
    procedure actUnlockExecute(Sender: TObject);
    procedure actUnlockAllUpdate(Sender: TObject);
    procedure actUnlockAllExecute(Sender: TObject);
    procedure actSelectAllUpdate(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actAlignToGridUpdate(Sender: TObject);
    procedure actAlignToGridExecute(Sender: TObject);
    procedure actBringToFrontUpdate(Sender: TObject);
    procedure actSendToBackUpdate(Sender: TObject);
    procedure actBringToFrontExecute(Sender: TObject);
    procedure actSendToBackExecute(Sender: TObject);
    procedure actEnabledUpdate(Sender: TObject);
    procedure actEnabledExecute(Sender: TObject);
    procedure actEnableAllUpdate(Sender: TObject);
    procedure actEnableAllExecute(Sender: TObject);
    procedure actChangeDataUpdate(Sender: TObject);
    procedure actPrintUpdate(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actALLeftUpdate(Sender: TObject);
    procedure actALLeftExecute(Sender: TObject);
    procedure actRepPropsUpdate(Sender: TObject);

    procedure sbButtonClick(Sender: TObject);

    procedure ELDesigner1ChangeSelection(Sender: TObject);
    procedure ELDesigner1ControlHint(Sender: TObject; AControl: TControl;
      var AHint: String);
    procedure ELDesigner1ControlInserting(Sender: TObject;
      var AControlClass: TControlClass;
      var AComponentClass: TComponentClass);
    procedure ELDesigner1ControlInserted(Sender: TObject);
    procedure ELDesigner1ControlDeleting(Sender: TObject;
      var AControlClass: TControlClass);
    procedure ELDesigner1DblClick(Sender: TObject);
    procedure ELDesigner1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ELDesigner1KeyPress(Sender: TObject; var Key: Char);
    procedure ELDesigner1Modified(Sender: TObject);
    procedure WindowCascade1Execute(Sender: TObject);
    procedure WindowTileHorizontal1Execute(Sender: TObject);
    procedure WindowTileVertical1Execute(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure MDITab1Change(Sender: TObject);
    procedure ELDesigner1DesignFormClose(Sender: TObject;
      var Action: TCloseAction);
    procedure actRunExecute(Sender: TObject);
    procedure actRunUpdate(Sender: TObject);
    procedure ThisProgramis1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ELDesigner1ControlInsertError(Sender: TObject);
    procedure actDebugWinExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actUndeleteExecute(Sender: TObject);
    procedure actUndeleteUpdate(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure ShortCutKeyList1Click(Sender: TObject);
    procedure InstallPackages1Click(Sender: TObject);
    procedure actWindowbarExecute(Sender: TObject);
    procedure actNewSDIExecute(Sender: TObject);
    procedure actOpenSDIExecute(Sender: TObject);
  private
    procedure MakeBitmap(Component:TSpeedButton;ComponentName:string);
    procedure LoadDefaultButton(TabSheet:TTabSheet);
    procedure CreatePalettePage(PalettePage, ComponentNames:string);
    function  GetSelectComponent(var AComponent: TComponentClass):TControlClass;
    procedure MakeComponentPalette;
    procedure DeleteComponentPalette;

    procedure GetDispCompNames(List: TStrings);
    procedure GetDispPropNames(List: TStrings);

    procedure StartConsoleDebug;
    procedure StopConsoleDebug;

    procedure _LoadPackages(AFileName: string; APaletteList: TStringList);
  protected
    FSelectedComponentName: string;
    //Console Debugging용 변수, HotKey Ctrl+debug로 생성, Ctrl + end로 파괴
    FConsoleDebug: TConsoleDebug;
    FEaster_Start: TEasternEgg;//HotKey 수신용(Ctrl+debug)

    FDeletedControlParent: TControl;//Component Delete시에 Parent저장하여 Undelete시에 사용함

    FHiMECSComponents: THiMECSComponents; //component용 bpl file name list
    FPackageList: TStringList;
    FPaletteList: TStringList;

    FApplicationPath: string;
    FCreateChildFromBPL : array of TCreateChildFuncFromBPL;
    FPackageModules : array of HModule;
    FHiMECSForms: THiMECSForms; //xml로 부터 MDI Child form(bpl) list를 저장함

    procedure CreateChildFormAll;
    function CreateOrShowChildFormFromBpl(Aform: string; var AIndex: integer):Boolean;
    procedure PackageLoad_MDIChild;
  public
    { Public declarations }
    procedure Save(ADoc: TForm);
    function SaveAs(ADoc: TForm): Boolean;
    function CloseAll: Boolean;
    procedure ControlInserting(var AControlClass: TControlClass;
                                          var AComponentClass: TComponentClass);
    procedure ControlInserted;
    procedure AdjustChangeSelection;
    procedure RegisterDefaultComponent;

    property MyDesigner: TELDesigner read ELDesigner1;
  end;

var
  frmMain: TfrmMain;

implementation

uses frmDocUnit, frmSDIDocUnit, frmConst, About, UtilUnit;//frmDocUnit

{$R *.dfm}
{$R Visual_Comm_MDI.res}
{$IFNDEF USE_PACKAGE}
  {$R Indy.res}
{$ENDIF}

procedure TfrmMain.actNewExecute(Sender: TObject);
var
  LForm: TfrmDoc;
  //IbDI : IbplDocInterface;
begin
  //if Supports(Screen.Forms[cnt], IConfigChanged, icc) then
  //  icc.ApplyConfigChange;
  LForm := TfrmDoc.Create(Application);
  MDITab1.AddTab(TForm(LForm));
  MDITab1Change(TForm(LForm));
  //MDITab1.AddTab(TForm(LForm),10);
end;

procedure TfrmMain.actNewSDIExecute(Sender: TObject);
var
  LForm: TfrmSDIDoc;
begin
  LForm := TfrmSDIDoc.Create(Application);
  //MDITab1.AddTab(LForm);
  with ELDesigner1 do
  begin
    Active := False;
    DesignControl := TForm(LForm);
    Active := TfrmSDIDoc(DesignControl).IsDesignMode;
    if Active then
    begin
      frmProps.ClearObjOfCombo();
      frmProps.FillObjList2Combo();
      AdjustChangeSelection();
    end;
  end;
end;

procedure TfrmMain.ControlInserted;
begin
  //SpeedButton1.Down := True;
  TSpeedButton(PageControl1.ActivePage.Controls[0]).Down:= True;
  TSpeedButton(PageControl1.ActivePage.Controls[0]).Click;
  //아래의 기능은 Modified 함수에서 실행함
  //frmProps.FillObjList2Combo();
  //AdjustChangeSelection();
end;

procedure TfrmMain.ControlInserting(var AControlClass: TControlClass;
                                          var AComponentClass: TComponentClass);
var SelClass:TControlClass;
begin
  SelClass:= GetSelectComponent(AComponentClass);
  if SelClass <> nil then
    AControlClass := SelClass;
end;

procedure TfrmMain.actPreviewExecute(Sender: TObject);
var
  LV: Boolean;
begin
  LV := frmProps.Visible;
  frmProps.Visible := False;
  try
    //TfrmDoc(ActiveMDIChild).DataSet.Open;
    //TfrmDoc(ActiveMDIChild).Report.PreviewModal;
  finally
    frmProps.Visible := LV;
  end;
end;

procedure TfrmMain.actPreviewUpdate(Sender: TObject);
begin
  actPreview.Enabled := (ActiveMDIChild <> nil);
end;

procedure TfrmMain.actPropsViewExecute(Sender: TObject);
begin
  frmProps.Visible := not frmProps.Visible;
end;

procedure TfrmMain.actPropsViewUpdate(Sender: TObject);
begin
  actPropsView.Checked := frmProps.Visible;
end;

procedure TfrmMain.Save(ADoc: TForm);
begin
  if ADoc.FormStyle = fsMDIChild then
  begin
    //MDI Child가 없을때 저장을 하면 에러가 나는 문제 해결
    if ActiveMDIChild <> nil then
    begin
      if TfrmDoc(ADoc).FileName = '' then
        SaveAs(ADoc)
      else
        TfrmDoc(ADoc).Save;
    end;
  end
  else
  if ADoc.FormStyle = fsNormal then
  begin
    if TfrmSDIDoc(ADoc).FileName = '' then
      SaveAs(ADoc)
    else
      TfrmSDIDoc(ADoc).Save;
  end;
end;

function TfrmMain.SaveAs(ADoc: TForm): Boolean;
var
  LS: string;
  label Again;
begin
  if ADoc.FormStyle = fsMDIChild then
  begin
    //MDI Child가 없을때 저장을 하면 에러가 나는 문제 해결
    if ActiveMDIChild = nil then
      exit;

    if TfrmDoc(ADoc).FileName <> '' then
      LS := TfrmDoc(ADoc).FileName
    else
      ;//LS := TfrmDoc(ADoc).Caption;
  end
  else
  if ADoc.FormStyle = fsNormal then
  begin
    if TfrmSDIDoc(ADoc).FileName <> '' then
      LS := TfrmSDIDoc(ADoc).FileName
    else
      ;//LS := TfrmSDIDoc(ADoc).Caption;
  end;

  SaveDialog1.FileName := LS;

Again:

  Result := SaveDialog1.Execute;
  if Result then
  begin
    LS := SaveDialog1.FileName;
    if FileExists(LS) then
    begin
      case MessageDlg(LS + ' File Exists.' + #13#10 +' Do you want to overwrite ?',
                              mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
        mrYes: begin
          if ADoc.FormStyle = fsMDIChild then
            TfrmDoc(ADoc).SaveAs(LS)
          else
          if ADoc.FormStyle = fsNormal then
            TfrmSDIDoc(ADoc).SaveAs(LS)
        end;
        mrNo: Goto Again;
        mrCancel: exit;
      end;
    end
    else
    begin
      if ADoc.FormStyle = fsMDIChild then
        TfrmDoc(ADoc).SaveAs(LS)
      else
      if ADoc.FormStyle = fsNormal then
        TfrmSDIDoc(ADoc).SaveAs(LS)
    end;
  end;
end;

procedure TfrmMain.actOpenExecute(Sender: TObject);
var LForm: TForm;
begin
  if OpenDialog1.Execute then
  begin
    LForm := nil;
    LForm := TForm(TfrmDoc.CreateDocument(Application, OpenDialog1.FileName));
    //LForm := TForm(TfrmDoc.Create(Application));
    //frmDocUnit.ReadDFM(LForm, OpenDialog1.FileName);
    if LForm <> nil then
      MDITab1.AddTab(LForm);
  end;
end;

procedure TfrmMain.actOpenSDIExecute(Sender: TObject);
var LForm: TForm;
begin
  if OpenDialog1.Execute then
  begin
    LForm := nil;
    LForm := TForm(TfrmSDIDoc.CreateDocument(Application, OpenDialog1.FileName));
    //if LForm <> nil then
      //MDITab1.AddTab(LForm);
  end;
end;

procedure TfrmMain.actSaveExecute(Sender: TObject);
begin
  Save(ActiveMDIChild);
end;

procedure TfrmMain.actSaveAsUpdate(Sender: TObject);
begin
  actSaveAs.Enabled := (ActiveMDIChild <> nil);
end;

procedure TfrmMain.actSaveAsExecute(Sender: TObject);
begin
  SaveAs(ActiveMDIChild);
end;

function TfrmMain.CloseAll: Boolean;
var
  LI: Integer;
begin
  Result := True;
  for LI := MDIChildCount - 1 downto 0 do
  begin
    MDIChildren[LI].Close;
    if not FormWasClosed then
    begin
      Result := False;
      Break;
    end;
  end;
end;

procedure TfrmMain.actCloseAllUpdate(Sender: TObject);
begin
  actCloseAll.Enabled := MDIChildCount > 0;
end;

procedure TfrmMain.actCloseAllExecute(Sender: TObject);
begin
  CloseAll;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not CloseAll then
  begin
    Action := caNone;
    exit;
  end;

  StopConsoleDebug;

  if Assigned(FEaster_Start) then
    FEaster_Start.Free;

  DeleteComponentPalette;
{  for i := PageControl1.PageCount - 1 Downto 0 do
  begin
    for j := PageControl1.Pages[i].ControlCount - 1 downto 0 do
    begin
      for k := TPanel(PageControl1.Pages[i].Controls[j]).ControlCount - 1 downto 0 do
        TPanel(PageControl1.Pages[i].Controls[j]).Controls[k].Free;//SpeedButton free

      PageControl1.Pages[i].Controls[j].Free;//Panel free
    end;

    PageControl1.Pages[i].Free;//TabSheet free
  end;
}
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var i: integer;
begin
  if Assigned(FPackageModules) then
  begin
    for i := Low(FPackageModules) to High(FPackageModules) do
      if FPackageModules[i] <> 0 then
        UnloadPackage(FPackageModules[i]);

    FPackageModules := nil;
  end;

  FCreateChildFromBPL := nil;

{$IFDEF USE_PACKAGE}
  FreeAndNil(FPaletteList); //UnloadPackage보다 먼저 Free하면 에러 안남???

  for i := 0 to FPackageList.Count - 1 do
  begin
    if HMODULE(FPackageList.Objects[i]) <> 0 then
      UnloadPackage(HMODULE(FPackageList.Objects[i]));
  end;

  //FPackageList.Clear;
  FreeAndNil(FPackageList);
{$ENDIF}

  FreeAndNil(FHiMECSComponents);
end;

procedure TfrmMain.actCloseUpdate(Sender: TObject);
begin
  actClose.Enabled := (ActiveMDIChild <> nil);
end;

procedure TfrmMain.actCloseExecute(Sender: TObject);
begin
  if MDIChildCount > 0 then
    ActiveMDIChild.Close;
end;

procedure TfrmMain.actSaveSaveAllUpdate(Sender: TObject);
begin
  actSaveSaveAll.Enabled := (ActiveMDIChild <> nil) and
    ((TfrmDoc(ActiveMDIChild).Modified) or (TfrmDoc(ActiveMDIChild).FileName = ''));

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actSaveSaveAll.Enabled :=
      ((TfrmSDIDoc(frmProps.Doc).Modified) or (TfrmSDIDoc(frmProps.Doc).FileName = ''));
end;

procedure TfrmMain.actSaveSaveAllExecute(Sender: TObject);
begin
  if (ActiveMDIChild <> nil) then
  begin
    if TfrmDoc(ActiveMDIChild).FileName = '' then
      SaveAs(ActiveMDIChild)
    else
      Save(ActiveMDIChild);
  end
  else
  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
  begin
    if TfrmSDIDoc(frmProps.Doc).FileName = '' then
      SaveAs(frmProps.Doc)
    else
      Save(frmProps.Doc);
  end;
end;

procedure TfrmMain.actCopyUpdate(Sender: TObject);
begin
  if (ActiveMDIChild <> nil) then
    actCopy.Enabled :=  MyDesigner.CanCopy
  else
  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actCopy.Enabled := MyDesigner.CanCopy;
end;

procedure TfrmMain.actCutUpdate(Sender: TObject);
begin
  if (ActiveMDIChild <> nil) then
    actCut.Enabled :=  MyDesigner.CanCut
  else
  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actCut.Enabled := MyDesigner.CanCut;
end;

procedure TfrmMain.actPasteUpdate(Sender: TObject);
begin
  if (ActiveMDIChild <> nil) then
    actPaste.Enabled := MyDesigner.CanPaste
  else
  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actPaste.Enabled := MyDesigner.CanPaste;
end;

procedure TfrmMain.actCopyExecute(Sender: TObject);
begin
  MyDesigner.Copy;
end;

procedure TfrmMain.actCutExecute(Sender: TObject);
begin
  MyDesigner.Cut;
end;

procedure TfrmMain.actUndeleteExecute(Sender: TObject);
begin
  if MyDesigner.CanPaste then
  begin
    if Assigned(FDeletedControlParent) then
      MyDesigner.SelectedControls.Add(FDeletedControlParent);

    MyDesigner.Paste;
    actUnDelete.Enabled := False;
  end;
end;

procedure TfrmMain.actUndeleteUpdate(Sender: TObject);
begin
  actUnDelete.Enabled := actPaste.Enabled;
end;

procedure TfrmMain.actPasteExecute(Sender: TObject);
begin
  MyDesigner.Paste;
end;

procedure TfrmMain.actDeleteExecute(Sender: TObject);
var IsTpjhLogicPanel: Bool;
begin
  //Designer.DeleteSelectedControls;
{  IsTpjhLogicPanel := False;
  if Designer.SelectedControls.Items[0].ClassType = TpjhLogicPanel then
    if MessageDlg('Are you sure delete this component name is "' + Designer.SelectedControls.Items[0].Name + '"?', mtConfirmation,
        [mbYes, mbNo], 0) = mrYes then
      IsTpjhLogicPanel := True
    else
      exit;
}
  //if Designer.SelectedControls.Items[0].ClassType = TpjhLogicPanel then
  //begin
  //  ShowMessage('Not allow to delete this component');
  //  exit;
  //end;

  FDeletedControlParent := MyDesigner.SelectedControls.Items[0].Parent;
  MyDesigner.Cut;

  if (ActiveMDIChild <> nil) then
    actUnDelete.Enabled := MyDesigner.CanPaste
  else
  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actUnDelete.Enabled := MyDesigner.CanPaste;

  //if IsTpjhLogicPanel then
  //  TfrmDoc(ActiveMDIChild).FpjhLogicPanel := nil;
end;

procedure TfrmMain.actDeleteUpdate(Sender: TObject);
begin
  actDelete.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actDelete.Enabled := True;
end;

procedure TfrmMain.actLockUpdate(Sender: TObject);
begin
  actLock.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actLock.Enabled := (ActiveMDIChild <> nil);
end;

procedure TfrmMain.actLockExecute(Sender: TObject);
begin
  MyDesigner.SelectedControls.Lock([lmNoResize, lmNoMove, lmNoDelete]);
end;

procedure TfrmMain.actUnlockUpdate(Sender: TObject);
begin
  actUnlock.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actUnlock.Enabled := True;
end;

procedure TfrmMain.actUnlockExecute(Sender: TObject);
begin
  MyDesigner.SelectedControls.Lock([]);
end;

procedure TfrmMain.actUnlockAllUpdate(Sender: TObject);
begin
  actUnlockAll.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actUnlockAll.Enabled := True;
end;

procedure TfrmMain.actUnlockAllExecute(Sender: TObject);
begin
  MyDesigner.LockAll([]);
end;

procedure TfrmMain.actSelectAllUpdate(Sender: TObject);
begin
  actSelectAll.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actSelectAll.Enabled := True;
end;

procedure TfrmMain.actSelectAllExecute(Sender: TObject);
begin
  MyDesigner.SelectedControls.SelectAll;
end;

procedure TfrmMain.actAlignToGridUpdate(Sender: TObject);
begin
  actAlignToGrid.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actAlignToGrid.Enabled := True;
end;

procedure TfrmMain.actAlignToGridExecute(Sender: TObject);
begin
  MyDesigner.SelectedControls.AlignToGrid;
end;

procedure TfrmMain.actBringToFrontUpdate(Sender: TObject);
begin
  actBringToFront.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actBringToFront.Enabled := True;
end;

procedure TfrmMain.actSendToBackUpdate(Sender: TObject);
begin
  actSendToBack.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actSendToBack.Enabled := True;
end;

procedure TfrmMain.actBringToFrontExecute(Sender: TObject);
begin
  MyDesigner.SelectedControls.BringToFront;
end;

procedure TfrmMain.actSendToBackExecute(Sender: TObject);
begin
  MyDesigner.SelectedControls.SendToBack;
end;

procedure TfrmMain.actEnabledUpdate(Sender: TObject);
begin
  if (ActiveMDIChild <> nil) then
  begin
    actEnabled.Enabled := (MyDesigner.SelectedControls.Count = 1) and
      (MyDesigner.SelectedControls.DefaultControl <> TfrmDoc(ActiveMDIChild));
    actEnabled.Checked := actEnabled.Enabled and
      MyDesigner.SelectedControls.DefaultControl.Enabled;
  end
  else
  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
  begin
    actEnabled.Enabled := (MyDesigner.SelectedControls.Count = 1) and
      (MyDesigner.SelectedControls.DefaultControl <> TfrmSDIDoc(frmProps.Doc));
    actEnabled.Checked := actEnabled.Enabled and
      MyDesigner.SelectedControls.DefaultControl.Enabled;
  end;
end;

procedure TfrmMain.actEnabledExecute(Sender: TObject);
begin
  MyDesigner.SelectedControls.DefaultControl.Enabled :=
    not MyDesigner.SelectedControls.DefaultControl.Enabled;
  MyDesigner.Modified;
end;

procedure TfrmMain.actEnableAllUpdate(Sender: TObject);
begin
  actEnableAll.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actEnableAll.Enabled := True;
end;

procedure TfrmMain.actEnableAllExecute(Sender: TObject);
var
  LI: Integer;
begin
  if (ActiveMDIChild <> nil) then
  begin
    for LI := 0 to TfrmDoc(ActiveMDIChild).ComponentCount - 1 do
      if TfrmDoc(ActiveMDIChild).Components[LI] is TControl then
       TControl(TfrmDoc(ActiveMDIChild).Components[LI]).Enabled := True;
    //TfrmDoc(ActiveMDIChild).Designer.Modified;
  end
  else
  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
  begin
    for LI := 0 to TfrmSDIDoc(frmProps.Doc).ComponentCount - 1 do
      if TfrmSDIDoc(frmProps.Doc).Components[LI] is TControl then
       TControl(TfrmSDIDoc(frmProps.Doc).Components[LI]).Enabled := True;
    //TfrmSDIDoc(frmProps.Doc).Designer.Modified;
  end;
end;

procedure TfrmMain.actChangeDataUpdate(Sender: TObject);
begin
  actChangeData.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actChangeData.Enabled := True;
end;

procedure TfrmMain.actPrintUpdate(Sender: TObject);
begin
  actPrint.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actPrint.Enabled := True;
end;

procedure TfrmMain.actPrintExecute(Sender: TObject);
var
  LV: Boolean;
begin
  LV := frmProps.Visible;
  frmProps.Visible := False;
  try
    //TfrmDoc(ActiveMDIChild).DataSet.Open;
    //TfrmDoc(ActiveMDIChild).Report.Print;
  finally
    frmProps.Visible := LV;
  end;
end;

procedure TfrmMain.actALLeftUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    TAction(Sender).Enabled := True;
end;

procedure TfrmMain.actALLeftExecute(Sender: TObject);
var
  LHorzAlignType, LVertAlignType: TELDesignerAlignType;
begin
  LHorzAlignType := atNoChanges;
  LVertAlignType := atNoChanges;
  case TAction(Sender).Tag of
    0: LHorzAlignType := atLeftTop;
    1: LHorzAlignType := atRightBottom;
    2: LVertAlignType := atLeftTop;
    3: LVertAlignType := atRightBottom;
    4: LHorzAlignType := atSpaceEqually;
    5: LVertAlignType := atSpaceEqually;
    6: LHorzAlignType := atCenter;
    7: LVertAlignType := atCenter;
    8: LHorzAlignType := atCenterInWindow;
    9: LVertAlignType := atCenterInWindow;
  end;
  MyDesigner.SelectedControls.Align(LHorzAlignType, LVertAlignType);
end;

procedure TfrmMain.actRepPropsUpdate(Sender: TObject);
begin
  actRepProps.Enabled := (ActiveMDIChild <> nil);

  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    actRepProps.Enabled := True;
end;

procedure TfrmMain.ELDesigner1ChangeSelection(Sender: TObject);
begin
  AdjustChangeSelection;
end;

procedure TfrmMain.ELDesigner1ControlHint(Sender: TObject;
  AControl: TControl; var AHint: String);
var
  LI: Integer;
begin
{  if AControl is TQRMemo then
  begin
    AHint := AHint + #13 + 'Lines:';
    for LI := 0 to TQRMemo(AControl).Lines.Count - 1 do
      AHint := AHint + #13 + '  ' + TQRMemo(AControl).Lines[LI];
  end else if AControl is TQRExprMemo then
  begin
    AHint := AHint + #13 + 'Lines:';
    for LI := 0 to TQRExprMemo(AControl).Lines.Count - 1 do
      AHint := AHint + #13 + '  ' + TQRExprMemo(AControl).Lines[LI];
  end else if AControl is TQRLabel then
  begin
    AHint := AHint + #13 + 'Caption: ' + TQRLabel(AControl).Caption;
  end else if AControl is TQRDBText then
  begin
    AHint := AHint + #13 + 'Data field: ' + TQRDBText(AControl).DataField;
  end else if AControl is TQRExpr then
  begin
    AHint := AHint + #13 + 'Expression: ' + TQRExpr(AControl).Expression;
  end;
}
end;

procedure TfrmMain.ELDesigner1ControlInserting(Sender: TObject;
  var AControlClass: TControlClass; var AComponentClass: TComponentClass);
begin
  ControlInserting(AControlClass, AComponentClass);
end;

procedure TfrmMain.ELDesigner1ControlInserted(Sender: TObject);
begin
  ControlInserted;
end;

procedure TfrmMain.ELDesigner1ControlDeleting(Sender: TObject;
  var AControlClass: TControlClass);
var
  LI: integer;
  LObjects: TList;
begin
  //컴포넌트를 삭제한 경우 삭제한 컴포넌트가 다른 컴포넌트의 파라미터값으로
  //설정 되어 있을때, 해당 컴포넌트를 선택하면 Access Violation 발생하는 버그 해결
  LObjects := TList.Create;
  try
    if TObject(AControlClass).ClassType = TWrapperControl then
      frmProps.FDeleteControlName := TWrapperControl(AControlClass).Component.Name
    else
      frmProps.FDeleteControlName := TControl(AControlClass).Name;

    if (ActiveMDIChild <> nil) then
    begin
      for LI := 0 to TfrmDoc(ActiveMDIChild).ComponentCount - 1 do
      begin
        LObjects.Clear;
        LObjects.Add(TfrmDoc(ActiveMDIChild).Components[LI]);
        frmProps.FIsOnDelete := True;
        frmProps.PropInsp.AssignObjects(LObjects);
        frmProps.FIsOnDelete := False;
      end;

      //메인폼의 프로퍼티도 처리함
      LObjects.Clear;
      LObjects.Add(TfrmDoc(ActiveMDIChild));
    end
    else
    if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    begin
      for LI := 0 to TfrmSDIDoc(frmProps.Doc).ComponentCount - 1 do
      begin
        LObjects.Clear;
        LObjects.Add(TfrmSDIDoc(frmProps.Doc).Components[LI]);
        frmProps.FIsOnDelete := True;
        frmProps.PropInsp.AssignObjects(LObjects);
        frmProps.FIsOnDelete := False;
      end;

      //메인폼의 프로퍼티도 처리함
      LObjects.Clear;
      LObjects.Add(TfrmSDIDoc(frmProps.Doc));
    end;

    frmProps.FIsOnDelete := True;
    frmProps.PropInsp.AssignObjects(LObjects);
    frmProps.FIsOnDelete := False;
    frmProps.FDeleteControlName := '';

  finally
    LObjects.Free;
  end;
end;

procedure TfrmMain.ELDesigner1DblClick(Sender: TObject);
var
  LControl: TControl;
begin
  if ELDesigner1.SelectedControls.Count = 1 then
  begin
    LControl := ELDesigner1.SelectedControls.DefaultControl;
  end;
end;

procedure TfrmMain.ELDesigner1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LC: TControl;
begin
  if (Key = VK_DELETE) then
    ELDesigner1.Copy;
end;

procedure TfrmMain.ELDesigner1KeyPress(Sender: TObject; var Key: Char);
  function _SetString(var AStr: string): Boolean;
  begin
    Result := False;
    if Ord(Key) >= 32 then
    begin
      AStr := AStr + Key;
      Result := True;
    end
    else if Ord(Key) = VK_BACK then
    begin
      AStr := Copy(AStr, 1, Length(AStr) - 1);
      Result := True;
    end;
  end;

var
  LC: TControl;
  LS: string;

begin
  if ELDesigner1.SelectedControls.Count = 1 then
    LC := ELDesigner1.SelectedControls.DefaultControl
  else
    LC := nil;
  if LC <> nil then
  begin
    {if LC.ClassType = TQRLabel then
    begin
      LS := TQRLabel(LC).Caption;
      if _SetString(LS) then
      begin
        TQRLabel(LC).Caption := LS;
        ELDesigner1.Modified;
      end;
    end else if LC.ClassType = TQRExpr then
    begin
      if Ord(Key) = VK_RETURN then
      begin
        LS := TQRExpr(LC).Expression;
        //if dlgLinesEditor.Execute(LS, DataSet) then
        //begin
        //  TQRExpr(LC).Expression := LS;
        //  ELDesigner1.Modified;
        //end;
      end
      else
      begin
        LS := TQRExpr(LC).Expression;
        if _SetString(LS) then
        begin
          TQRExpr(LC).Expression := LS;
          ELDesigner1.Modified;
        end;
      end;
    end else if LC.ClassType = TQRDBText then
    begin
      if Ord(Key) = VK_RETURN then
      begin
        LS := TQRDBText(LC).DataField;
        //if dlgFields.Execute(DataSet, LS) then
        //begin
        //  TQRDBText(LC).DataField := LS;
        //  ELDesigner1.Modified;
        //end;
      end
      else
      begin
        LS := TQRDBText(LC).DataField;
        if _SetString(LS) then
        begin
          TQRDBText(LC).DataField := LS;
          ELDesigner1.Modified;
        end;
      end;
    end else if (LC.ClassType = TQRMemo) and (Ord(Key) = VK_RETURN) then
    begin
      //if dlgLinesEditor.Execute(TQRMemo(LC).Lines, DataSet) then
      //begin
      //  TQRMemo(LC).Refresh;
      //  ELDesigner1.Modified;
      //end;
    end else if (LC.ClassType = TQRExprMemo) and (Ord(Key) = VK_RETURN) then
    begin
      //if dlgLinesEditor.Execute(TQRExprMemo(LC).Lines, DataSet) then
      //begin
      //  TQRExprMemo(LC).Refresh;
      //  ELDesigner1.Modified;
      //end;
    end;
  }
  end;
end;

procedure TfrmMain.ELDesigner1Modified(Sender: TObject);
begin
  //if frmProps.Doc = Self then
  frmProps.PropInsp.Modified;

  if (ActiveMDIChild <> nil) then
    TfrmDoc(ActiveMDIChild).Modify
  else
  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
    TfrmSDIDoc(frmProps.Doc).Modify;

  frmProps.ClearObjOfCombo();
  frmProps.FillObjList2Combo();
  AdjustChangeSelection();
end;

procedure TfrmMain.AdjustChangeSelection;
var
  LObjects: TList;
begin
  if (frmProps.Doc is TfrmDoc) or (frmProps.Doc is TfrmSDIDoc) then
  begin
    LObjects := TList.Create;
    try
      ELDesigner1.SelectedControls.GetControls(LObjects);
      frmProps.PropInsp.AssignObjects(LObjects);

      if ELDesigner1.SelectedControls.Count <> 1 then
        frmProps.RefreshObjListOfCombo
      else
        frmProps.RefreshObjListOfCombo(ELDesigner1.SelectedControls[0]);
      //if LObjects.Count > 0 then
      //  frmProps.RefreshObjListOfCombo(TControl(LObjects.Items[0]));
    finally
      LObjects.Free;
    end;
  end;
end;

procedure TfrmMain.WindowCascade1Execute(Sender: TObject);
begin
  Cascade;
end;

procedure TfrmMain.WindowTileHorizontal1Execute(Sender: TObject);
begin
  TileMode:=tbHorizontal;
  Tile;
end;

procedure TfrmMain.WindowTileVertical1Execute(Sender: TObject);
begin
  TileMode:=tbVertical;
  Tile;
end;

procedure TfrmMain.StatusBar1Click(Sender: TObject);
begin
  AdvOfficeStatusBar1.Visible := not AdvOfficeStatusBar1.Visible;
end;

procedure TfrmMain.MDITab1Change(Sender: TObject);
begin
  if Assigned(ActiveMDIChild) then
  begin
    with ELDesigner1 do
    begin
      //if Assigned(DesignControl) and
      //    (TForm(DesignControl).Name = TForm(Sender).Name)  then

      //else
      //begin
        Active := False;
        DesignControl := TForm(Sender);
        DesignPanel := TELCustomDesignPanel(DesignControl);
        Active := TfrmDoc(DesignControl).IsDesignMode;
      //end;
      if Active then
      begin
        //frmProps.SetDesigner4PropInsp(Pointer(ELDesigner1));
        frmProps.SetDesigner4PropInsp(Pointer(Designer));
        frmProps.ClearObjOfCombo();
        frmProps.FillObjList2Combo();
        AdjustChangeSelection();
      end;
    end;//with
  end;
end;

procedure TfrmMain.ELDesigner1DesignFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TForm(MyDesigner.DesignControl).Close;

  if FormWasClosed then
  begin
    MyDesigner.SelectedControls.Clear;
    MyDesigner.Active := False;
  end;
end;

procedure TfrmMain.actRunExecute(Sender: TObject);
begin
  if Assigned(ActiveMDIChild) then
  begin
    MyDesigner.Active := not MyDesigner.Active;
    TfrmDoc(ActiveMDIChild).IsDesignMode := MyDesigner.Active;
  end
  else
  if (frmProps.Doc <> nil) and (frmProps.Doc.FormStyle = fsNormal) then
  begin
    MyDesigner.Active := not MyDesigner.Active;
    TfrmSDIDoc(frmProps.Doc).IsDesignMode := MyDesigner.Active;
  end;
end;

procedure TfrmMain.actRunUpdate(Sender: TObject);
begin
  if MyDesigner.Active then
    actRun.ImageIndex := 18
  else
    actRun.ImageIndex := 19;
end;

procedure TfrmMain.ThisProgramis1Click(Sender: TObject);
//var
//  LF: TAboutF;
begin
{  LF := nil;
  try
    LF := TAboutF.Create(nil);
    with LF do
    begin
      ShowModal;
    end;
  finally
    FreeAndNil(LF);
  end;//try
}
  CreateShowModal(TAboutF);
end;

// Make bitmap of component
procedure TfrmMain.MakeBitmap(Component: TSpeedButton; ComponentName: string);
var
  ResName: array[0..64] of Char;
  ResBitmap: TBitmap;
  i: integer;
begin
  ResBitmap := TBitmap.Create;
  try
    StrPLCopy(ResName, ComponentName, SizeOf(ResName));
    CharUpper(ResName);
    ResBitmap.Handle := LoadBitmap(hInstance, ResName);

    if ResBitmap.Handle = 0 then
    begin
{$IFDEF USE_PACKAGE}
      //Package내의 Image검색
      for i := 0 to FPackageList.Count - 1 do
      begin
        ResBitmap.Handle := LoadBitmap(hModule(FPackageList.Objects[i]), ResName);
        //Pacakage내에 Image가 있으면 검색 중단
        if ResBitmap.Handle <> 0 then
          break;
      end;

      if ResBitmap.Handle = 0 then //Pacakage를 뒤져도 비트맵이 없으면 Default Image
{$ENDIF}
        ResBitmap.Handle := LoadBitmap(hInstance, 'DEFAULT');
    end;
    Component.Glyph:= ResBitmap;
  finally
    ResBitmap.Free;
  end;//try
end;

// Load default button
procedure TfrmMain.LoadDefaultButton(TabSheet: TTabSheet);
var
  Button:TSpeedButton;

  procedure CreateButton(ButtonName:string;Index:Integer);
  begin
    Button:=TSpeedButton.Create(TabSheet);
    with Button do
    begin
      Name := UniqueName(Button);
      if Index = 0 then Down:= True;
      Flat      := True;
      GroupIndex:= 1;
      Height    := 25;//28;
      Left      := Index * 29;
      Parent    := TabSheet;
      Top       := 0;//5;
      Width     := 25;//28;
      OnClick   := sbButtonClick;
    end;//with

    MakeBitmap(Button,ButtonName);
    //FCursorButton := Button;
  end;

begin
  CreateButton('CURSOR',0);
end;

// Create component of palette page (page name is PalettePage)
procedure TfrmMain.CreateChildFormAll;
var
  i: Integer;
begin
  for i := 0 to FHiMECSForms.PackageCollect.Count - 1 do
  begin
    if Assigned(FCreateChildFromBPL[i]) then
      FCreateChildFromBPL[i];
  end;
end;

function TfrmMain.CreateOrShowChildFormFromBpl(Aform: string;
  var AIndex: integer): Boolean;
var
  i: integer;
begin
  Result := False;

  for i := 0 to MDIChildCount - 1 do
  begin
    if pos(Aform, TForm(MDIChildren[i]).ClassName) > 0 then
    begin
      MDIChildren[i].Show;
      AIndex := i;
      Result := True;
      break;
    end;
  end;//for

  if not Result then
  begin
    for i := 0 to FHiMECSForms.PackageCollect.Count - 1 do
    begin
      if Pos(Aform, FHiMECSForms.PackageCollect.Items[i].PackageName) > 0 then
      begin
        FCreateChildFromBPL[i];
        Caption := Caption + ': MDI ChildCount = ' + IntToStr(MDIChildCount);
        AIndex := MDIChildCount - 1;
        break;
      end;//if
    end;//for

  end;
end;

procedure TfrmMain.CreatePalettePage(PalettePage, ComponentNames: string);
var
  TabSheet:TTabSheet;
  PageScroller: TPageScroller;
  Panel1, Panel2, Panel3: TPanel;
  Button:TSpeedButton;
  ComponentName:string;//ComponentNames,
  Temp, Pos1, Index:Integer;
  LIsPaletteExist: Boolean;

  procedure CreateButton(ButtonName:string);
  begin
    Button:=TSpeedButton.Create(TabSheet);
    with Button do
    begin
      Name := UniqueName(Button);
      Flat      := True;
      GroupIndex:= 1;
      Height    := 25;//28;
      Hint      := ButtonName;
      Left      := Index * 29;
      Parent    := TabSheet;
      ShowHint  := True;
      Top       := 0;//5;
      Width     := 25;//28;
      OnClick   := sbButtonClick;
      //탭시트의 마지막  버튼 위치 기억함(동일 탭시트에 버튼 추가시 필요)
      TabSheet.Tag := Index + 1;
    end;//with

    MakeBitmap(Button,ButtonName);
  end;

begin
  //이미 파레트 이름이 존재하면 Create Skip
  LIsPaletteExist := False;
  for Temp := 0 to PageControl1.PageCount - 1 do
  begin
    if PalettePage = PageControl1.Pages[Temp].Caption then
    begin
      TabSheet := PageControl1.Pages[Temp];
      LIsPaletteExist := True;
      Break;
    end;
  end;

  if not LIsPaletteExist then
  begin
    TabSheet:=TTabSheet.Create(self);

    with TabSheet do
    begin
      PageControl := PageControl1;
      Caption:= PalettePage;
      Name := UniqueName(TabSheet);
      Tag := 1;
    end;

    LoadDefaultButton(TabSheet);
  end;


  if ComponentNames = '' then Exit;

  Pos1 := 0;
  Temp := 1;
  //Index:= 1;
  Index:= TabSheet.Tag;

  while True do
  begin
    Pos1:= NPos(';', ComponentNames, Temp, Length(ComponentNames));

    if Pos1 = 0 then Break;

    ComponentName:= Copy(ComponentNames, Temp, Pos1 - Temp -1);
    CreateButton(ComponentName);
    Temp:= Pos1;
    Inc(Index);
  end;//while
end;

//TComponent가 아닌 TComponentClass이어야 클래스 정보를 가져올 수 있음
//TControlClass도 마찬가지...
function TfrmMain.GetSelectComponent(var AComponent: TComponentClass): TControlClass;
var
  LControl: TComponentClass;
  LClassRef: TClass;
  LIsControl: Boolean;
begin
  LControl := nil;
  LControl := TComponentClass(GetClass(FSelectedComponentName));

  if LControl = nil then
  begin
    Result := nil;
    exit;
  end;

  //Visual 인지 Non-Visual 인지 판단함
  //Visual = Parent 중에 TControl이 있음
  LIsControl := False;
  //LClassRef := GetClass(FSelectedComponentName).ClassParent;
  LClassRef := LControl.ClassParent;

  while LClassRef <> nil do
  begin
    if LClassRef = TControl then
    begin
      LIsControl := True;
      Break;
    end;
    LClassRef := LClassRef.ClassParent;
  end;

  if LIsControl then
    Result:= TControlClass(LControl)
  else
  if LControl <> nil then
  begin
    //Non-Visual Component를 위한 루틴임
    AComponent := LControl;
    Result := TControlClass(TWrapperControl);
  end
  else
    Result := nil;

  //Result:= TControlClass(GetClass(FSelectedComponentName));
end;

procedure TfrmMain.sbButtonClick(Sender: TObject);
var i: integer;
begin
{  if TSpeedButton(Sender).GroupIndex = 2 then
  begin
    for i := 0 to TPanel(TPageScroller(PageControl1.ActivePage.Controls[1]).Controls[0]).ControlCount - 1 do
      if TPanel(TPageScroller(PageControl1.ActivePage.Controls[1]).Controls[0]).Controls[i] is TSpeedButton then
        TSpeedButton(TPanel(TPageScroller(PageControl1.ActivePage.Controls[1]).Controls[0]).Controls[i]).Down:= False;
  end
  else
    TSpeedButton(TPanel(PageControl1.ActivePage.Controls[0]).Controls[0]).Down:= False;
}
  FSelectedComponentName := (Sender as TSpeedButton).Hint;
end;

// 폼 파일에 있는 컴퍼넌트의 클래스를 등록한다.
procedure TfrmMain.RegisterDefaultComponent;
var tmpList, tmpList2: TStrings;
begin
  tmpList := TStringList.Create;
  tmpList2 := TStringList.Create;
  try
    GetDispCompNames(tmpList2);
    GetDispPropNames(tmpList);
    frmProps.FillDisplayPropName(tmpList2, tmpList);
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpList2);
  end;//try
end;

// Dynamic loading components
procedure TfrmMain.MakeComponentPalette;
var
{$IFNDEF USE_PACKAGE}
  //FPaletteList: TStringList;  pjhClasses에서 생성함(전역변수)
{$ENDIF}
  I, j:Integer;
  PalettePage, PaletteComponent:string;
  iniFile: TIniFile;
begin
{$IFNDEF USE_PACKAGE}
  //FPaletteList := TStringList.Create;pjhClasses에서 생성함(전역변수)
{$ENDIF}

  FPaletteList.Clear;

  //FPaletteList.Add('Logic=TpjhStartControl;TpjhStopControl;TpjhProcess;TpjhGotoControl;TpjhStartButton;TpjhDelay;TpjhWriteFAMem;TpjhIFTimer;TpjhSetTimer;');
  //FPaletteList.Add('Serial=TpjhIfControl;TPjhComLed;TpjhWriteComport;TpjhReadComport;TpjhWriteFile;TpjhWriteFAMem;');
  //FPaletteList.Add('FAOpen2003=TpjhFAMemMan;TFAGauge;TFANumberEdit;TFANumLabel;');
{$IFNDEF USE_PACKAGE}
  //FPaletteList.Add('Indy=TIDTcpServer;TIDUdpServer;TIDTcpClient;TIDUdpClient;TIndyWriteClientTCP;TIndyReadClientTCP;TIndyWriteFile;TIndyListenTCP;');
{$ENDIF}
  //FPaletteList.Add('LAN=TpjhLanIfControl;');

{$IFDEF USE_PACKAGE}
  Component1.Visible := True;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  _LoadPackages('.\VisualComponents.list', FPaletteList);
{$ENDIF}

  try
  {iniFile := TIniFile.Create(INI_FILE_NAME);
    IniFile.ReadSectionValues('Palette',PaletteList);
    if PaletteList.Count <= 0 then
    begin
      //LoadDefaultPalette;
      //IniFile.ReadSectionValues('Palette',PaletteList);
    end;
  }
    DeleteComponentPalette;

    for I:=0 to FPaletteList.Count - 1 do
    begin
      PalettePage:= FPaletteList.Names[I];
      PaletteComponent := FPaletteList.ValueFromIndex[I];

      if PalettePage <> '' then CreatePalettePage(PalettePage, PaletteComponent);
    end;

  finally
    //FreeAndNil(iniFile);
{$IFNDEF USE_PACKAGE}
    //FreeAndNil(FPaletteList); pjhClasses에서 해제함(전역변수)
{$ENDIF}
  end;//try
end;

procedure TfrmMain.DeleteComponentPalette;
var i,j: integer;
begin
  for i := PageControl1.PageCount - 1 Downto 0 do
  begin
    for j := PageControl1.Pages[i].ControlCount - 1 downto 0 do
      PageControl1.Pages[i].Controls[j].Free;

    PageControl1.Pages[i].Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FEaster_Start := TEasternEgg.Create([ssCtrl], EASTER_SAMPLE, self);
  FApplicationPath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  SetCurrentDir(FApplicationPath);
  //FEaster_Start.FOnEasterEgg := StartConsoleDebug;
  Caption := Caption + VERSION;

  FHiMECSComponents := THiMECSComponents.Create(Self);
  FPackageList := TStringList.Create;
  FPaletteList := TStringList.Create;

  //이 함수는 반드시 위 문장 아래에 위치해야 함. 안그러면 에러남
  //RegisterDefaultComponent;
  MakeComponentPalette;
  PackageLoad_MDIChild;
end;

procedure TfrmMain.PackageLoad_MDIChild;
var
  i: integer;
  LStr: string;
begin
{  SetCurrentDir(FApplicationPath);

  FHiMECSForms.PackageCollect.Clear;
  FHiMECSForms.LoadFromFile(DefaultFormsFileName,DefaultFormsFileName,True);
  SetLength(FPackageModules, FHiMECSForms.PackageCollect.Count);
  SetLength(FCreateChildFromBPL, FHiMECSForms.PackageCollect.Count);

  LStr := IncludeTrailingPathDelimiter('.\');

  for i := 0 to FHiMECSForms.PackageCollect.Count - 1 do
  begin               //FHiMECSConfig.HiMECSFormPath는 PackageName에 포함되어 있음
    FPackageModules[i] := LoadPackage(LStr+FHiMECSForms.PackageCollect.Items[i].PackageName);

    if FPackageModules[i] <> 0 then
    begin
      try
        @FCreateChildFromBPL[i] := GetProcAddress(FPackageModules[i], PWideChar(FHiMECSForms.PackageCollect.Items[i].CreateFuncName));
      except
        ShowMessage('Package Create function: '+ FHiMECSForms.PackageCollect.Items[i].CreateFuncName +
          ' not found!');
      end;
    end;
  end;
}
end;

procedure TfrmMain.PageControl1Change(Sender: TObject);
var i,j: integer;
begin
//  for i := 0 to PageControl1.ActivePage.ControlCount - 1 do
//    for j := 0 to TPanel(PageControl1.ActivePage.Controls[i]).ControlCount - 1 do
//      TPageScroller(TPanel(PageControl1.ActivePage.Controls[i]).Controls[j]).Position := PageControl1.Width;

end;

procedure TfrmMain.ELDesigner1ControlInsertError(Sender: TObject);
begin
  TSpeedButton(PageControl1.ActivePage.Controls[0]).Down:= True;
  TSpeedButton(PageControl1.ActivePage.Controls[0]).Click;
end;

procedure TfrmMain.StartConsoleDebug;
begin
  if not (Assigned(FConsoleDebug)) then
    FConsoleDebug := TConsoleDebug.Create;
end;

procedure TfrmMain.StopConsoleDebug;
begin
  if Assigned(FConsoleDebug) then
  begin
    FConsoleDebug.Destroy;
    FConsoleDebug := nil;
  end;
end;

procedure TfrmMain.WMCopyData(var m: TMessage);
var
  str1: string;
  msgtype: integer;
begin
  str1 := PRecToPass(PCopyDataStruct(m.LParam)^.lpData)^.StrMsg;
  msgtype := PRecToPass(PCopyDataStruct(m.LParam)^.lpData)^.iHandle;

  if Assigned(FConsoleDebug) then
    FConsoleDebug.ConsoleWriteLn(str1);
end;

procedure TfrmMain._LoadPackages(AFileName: string; APaletteList: TStringList);
var
  tmpList, tmpList2: TStrings;
  i, j: integer;
  ExecF: function: TStrings;
  pModule: HModule;
  LStr: string;
begin
  if not FileExists(AFileName) then
    exit;

  //iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'\'+INI_FILE_NAME);
  tmpList := TStringList.Create;
  tmpList2 := TStringList.Create;

  LStr := ExtractFileName(AFileName);

  FHiMECSComponents.PackageCollect.Clear;
  FHiMECSComponents.LoadFromFile(AFileName, LStr, True);

  try
    for i := 0 to FHiMECSComponents.PackageCollect.Count - 1 do
      tmpList.Add(FHiMECSComponents.PackageCollect.Items[i].PackageName);

    for i := 0 to FPackageList.Count - 1 do
    begin
      if HMODULE(FPackageList.Objects[i]) <> 0 then
        UnloadPackage(HMODULE(FPackageList.Objects[i]));
    end;

    FPackageList.Clear;

    for i := 0 to tmpList.Count - 1 do
    begin
      //.bpl 파일이 존재하지 않으면 FPackageList에서 삭제
      if not FileExists(tmpList.Strings[i]) then
      begin
        j := FPackageList.IndexOfName(tmpList.Strings[i]);
        if j >= 0 then
        begin
          UnloadPackage(HMODULE(FPackageList.Objects[j]));
          FPackageList.Delete(j);
        end;
      end;

      //이미 Load한 Package라면 Skip
      //if FPackageList.IndexOf(tmpList.Strings[i]) >= 0 then
      //  Continue;
      ExecF := nil;

      pModule := LoadPackage(tmpList.Strings[i]);

      if pModule <> 0 then
      begin
        FPackageList.AddObject(tmpList.Strings[i], Pointer(pModule));
        //tmpList2.Assign(FPackageList.Objects[i].GetPaletteList);
        @ExecF := GetProcAddress(hModule(FPackageList.Objects[i]), 'GetPaletteList');
      end;

      tmpList2.Clear;

      if Assigned(ExecF) then
      begin
        tmpList2:= ExecF;
      end;

      for j := 0 to tmpList2.Count - 1 do
        //CreatePalettePage(tmpList2.Names[j], tmpList2.Values[tmpList2.Names[j]]);
        //아래 코드를 삽입하면 FPaletteList.Free시에 바이올린 에러 발생함
        //아마도 Pacakge에서 TStrings를 리턴하면 이상한 현상이 발생한듯
        //그 후 FPaletteList변수를 클래스 변수에서 전역 변수로 변환하니 에러 안남
        APaletteList.Append(tmpList2.Strings[j]);
    end;//for
  finally
    tmpList2.Free;
    tmpList.Free;
  end;//try
end;

procedure TfrmMain.actDebugWinExecute(Sender: TObject);
begin
  if Assigned(FConsoleDebug) then
    StopConsoleDebug
  else
    StartConsoleDebug;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FEaster_Start.CheckKeydown(Key, Shift);
end;

procedure TfrmMain.GetDispCompNames(List: TStrings);
begin
  List.Add('TpjhLanIfControl');
  List.Add('TIndyWriteClientTCP');
  List.Add('TIndyReadClientTCP');
  List.Add('TIndyWriteFile');

end;

procedure TfrmMain.GetDispPropNames(List: TStrings);
begin
  List.Add('FAMemoryManager');
  List.Add('FAMemName');
  List.Add('FAMemIndex');

  List.Add('ListenControl');
  List.Add('LanControl');
  List.Add('CommBlock');
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actWindowbarExecute(Sender: TObject);
begin
  mditab1.visible:=not mditab1.visible;
end;

procedure TfrmMain.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  //actSave.Enabled := (ActiveMDIChild <> nil) and
    //(TfrmDoc(ActiveMDIChild).Modified) and (TfrmDoc(ActiveMDIChild).FileName <> '');
end;

procedure TfrmMain.ShortCutKeyList1Click(Sender: TObject);
//var
//  LF: Tkeylist;
begin
{  LF := nil;
  try
    LF := Tkeylist.Create(nil);
    with LF do
    begin
      ShowModal;
    end;
  finally
    FreeAndNil(LF);
  end;//try
}
  CreateShowModal(Tkeylist);

end;

procedure TfrmMain.InstallPackages1Click(Sender: TObject);
begin
{$IFDEF USE_PACKAGE}
  //CreateShowModal(TProjOption);
  with TProjOption.Create(Application) do
  begin
    try
      FPackageList2.Assign(FPackageList);
      if ShowModal = mrOK then
      begin
        MakeComponentPalette;
      end;
    finally
      Free;
    end;
  end;
{$ENDIF}
end;

initialization
  ForceCurrentDirectory := True;
  //RegisterClasses([TpjhIfControl,TpjhGotoControl,TpjhStartControl,TpjhStopControl,TpjhDelay,TpjhSetTimer,TpjhIFTimer]);
  //RegisterClasses([TpjhStartButton]);
  {RegisterClasses(
            [ TpjhProcess,      TpjhProcess2,
              TpjhIfControl ,   TpjhGotoControl,  TpjhStartControl,
              TpjhStopControl,  TpjhStartButton,  //TPjhComLed, TpjhWriteComport, TpjhReadComport,
              TpjhDelay, TpjhFAMemMan ,TFAGauge,//, TpjhWriteFile , TpjhWriteFAMem
              TFANumberEdit, TFANumLabel, TpjhIFTimer, TpjhSetTimer
//{$IFNDEF USE_PACKAGE}
//              ,TIDTcpServer,TIDUdpServer,TIDTcpClient,TIDUdpClient
//{$ENDIF}
//             ]);
//             }

end.

