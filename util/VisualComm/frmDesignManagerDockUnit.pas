{
  **)E2201: Need imported data reference에러 발생시 대처 방법:
    Synopse.inc 파일내 $Define USEPACKAGES 에서 .을 없애고 컴파일 후 원상복귀 시킬것

  V1.1.9 수정사항: 2012.5.11
  1) jvDock 기능 추가함

  V1.1.8 수정사항: 2012.3.6
  1) bpl로 부터 Component load함
     - cannot load package A It contains unit X error 해결
     - 방법: bpl에서 공통으로 쓰이는 Unit을 따로 bpl로 만듬(pjhPackageUnits.bpl)
     -       각 package의 required에 pjhPackageUnits.dcp 추가 후 build
  2) InheritsFrom(GetClass) 함수가 nil을 반환하는 문제 해결
     - 방법:
  3) Unit Name 변경
     - frmMainUnit --> frmMainBplUnit

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

//{$DEFINE USE_PACKAGE}//HiMECS.inc file로 대체함
{$I HiMECS.inc}

unit frmDesignManagerDockUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ActnList, StdCtrls, Buttons, ExtCtrls, iniFiles,
  Mask, Grids, FileCtrl, MPlayer, Gauges,  ColorGrd, Spin, Outline, DirOutln,
  Calendar, CheckLst, Tabs, TabNotbk, ImgList, ComCtrls, ToolWin, StdActns,
  //StartButton2, CustomLogic, FlowChartLogic, CustomLogicType,
  EasterEgg, ConsoleDebug, pjhFormDesigner,
  //FAMemMan_pjh, FANumEdit, FAGauges, FANumLabel,
  klist, pjhClasses, TypInfo, //IndyLanCommLogic,
  AdvShapeButton, AdvToolBar, AdvGlowButton,
  AdvOfficeStatusBar, Vcl.ExtActns, AdvOfficeStatusBarStylers, AdvPreviewMenu,
  AdvPreviewMenuStylers, AdvMenus, AdvMenuStylers, AdvOfficeHint,
  AdvToolBarStylers, AdvOfficeTabSet, AdvOfficeTabSetStylers, HiMECSComponentCollect
  , HiMECSFormCollect, frmMainInterface
 {$IFDEF USECODESITE} ,CodeSiteLogging {$ENDIF}

{$IFDEF USE_PACKAGE}
  , PackageList
{$ELSE}
  , pjhFlowChartCompnents
  , FlowChartLogic, pjhStartButton
  , pjhDelphiStandardCompList
  , pjhTBevel
  , pjhTGridPanel
  , pjhTImage
  , pjhTLedPanel
  , pjhTPanel
  , pjhTShadowButton
{$ENDIF};

type
  TCreateChildFuncFromBPL = function: TForm;
  TCreateDocumentFuncFromBPL = function(AOwner: TComponent; AFileName: string): TForm;
  TCreateOIFuncFromBPL = function (AOwner: TComponent): TForm;

  TfrmDesignManagerDock = class(TForm, IbplMainInterface)
    ActionList1: TActionList;
    actNew: TAction;
    actNewSDI: TAction;
    actPreview: TAction;
    actPropsView: TAction;
    actUndelete: TAction;
    actOpen: TAction;
    actOpenSDI: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actCloseAll: TAction;
    actClose: TAction;
    actSaveSaveAll: TAction;
    actCopy: TAction;
    actCut: TAction;
    actPaste: TAction;
    actDelete: TAction;
    actLock: TAction;
    actUnlock: TAction;
    actUnlockAll: TAction;
    actSelectAll: TAction;
    actAlignToGrid: TAction;
    actBringToFront: TAction;
    actSendToBack: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowArrange1: TWindowArrange;
    actEnabled: TAction;
    actEnableAll: TAction;
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
    actRepProps: TAction;
    actRun: TAction;
    actDebugWin: TAction;
    actExit: TAction;
    actBreakPoint: TAction;
    actWindowbar: TAction;
    actStatusBar: TAction;
    SaveDialog1: TSaveDialog;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Enable1: TMenuItem;
    N7: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Delete2: TMenuItem;
    N2: TMenuItem;
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
    AlignToGrid1: TMenuItem;
    Bringtofront1: TMenuItem;
    Sendtoback2: TMenuItem;
    N6: TMenuItem;
    Lock2: TMenuItem;
    Unlock1: TMenuItem;
    N4: TMenuItem;
    BreakPoint1: TMenuItem;
    ELDesigner1: TELDesigner;
    OpenDialog1: TOpenDialog;
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
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    Timer1: TTimer;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    AdvToolBarPager2: TAdvToolBarPager;
    AdvPage4: TAdvPage;
    AdvToolBar10: TAdvToolBar;
    AdvGlowButton26: TAdvGlowButton;
    AdvGlowButton27: TAdvGlowButton;
    AdvGlowButton28: TAdvGlowButton;
    AdvGlowButton29: TAdvGlowButton;
    AdvGlowButton30: TAdvGlowButton;
    AdvToolBar11: TAdvToolBar;
    AdvGlowButton31: TAdvGlowButton;
    AdvGlowButton32: TAdvGlowButton;
    AdvGlowButton33: TAdvGlowButton;
    RunButton: TAdvGlowButton;
    AdvToolBar12: TAdvToolBar;
    AdvGlowButton35: TAdvGlowButton;
    AdvGlowButton36: TAdvGlowButton;
    AdvGlowButton37: TAdvGlowButton;
    AdvToolBar13: TAdvToolBar;
    AdvGlowButton38: TAdvGlowButton;
    AdvGlowButton39: TAdvGlowButton;
    AdvGlowButton40: TAdvGlowButton;
    AdvToolBar14: TAdvToolBar;
    AdvGlowButton41: TAdvGlowButton;
    AdvPage5: TAdvPage;
    AdvToolBar15: TAdvToolBar;
    AdvGlowButton42: TAdvGlowButton;
    AdvGlowButton43: TAdvGlowButton;
    AdvGlowButton45: TAdvGlowButton;
    AdvToolBar16: TAdvToolBar;
    AdvGlowButton46: TAdvGlowButton;
    AdvGlowButton47: TAdvGlowButton;
    AdvGlowButton48: TAdvGlowButton;
    AdvGlowButton49: TAdvGlowButton;
    AdvGlowButton50: TAdvGlowButton;
    AdvToolBar17: TAdvToolBar;
    AdvGlowButton51: TAdvGlowButton;
    AdvGlowButton52: TAdvGlowButton;
    AdvGlowButton53: TAdvGlowButton;
    AdvGlowButton54: TAdvGlowButton;
    AdvGlowButton55: TAdvGlowButton;
    AdvPage6: TAdvPage;
    PageControl1: TPageControl;
    procedure FormCreate(Sender: TObject);
    procedure actALLeftExecute(Sender: TObject);
    procedure actALLeftUpdate(Sender: TObject);
    procedure actUndeleteExecute(Sender: TObject);
    procedure actUndeleteUpdate(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actCutUpdate(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actPasteUpdate(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actLockExecute(Sender: TObject);
    procedure actLockUpdate(Sender: TObject);
    procedure actUnlockExecute(Sender: TObject);
    procedure actUnlockUpdate(Sender: TObject);
    procedure actUnlockAllExecute(Sender: TObject);
    procedure actUnlockAllUpdate(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actSelectAllUpdate(Sender: TObject);
    procedure actAlignToGridExecute(Sender: TObject);
    procedure actAlignToGridUpdate(Sender: TObject);
    procedure actBringToFrontExecute(Sender: TObject);
    procedure actBringToFrontUpdate(Sender: TObject);
    procedure actSendToBackExecute(Sender: TObject);
    procedure actSendToBackUpdate(Sender: TObject);
    procedure actEnabledExecute(Sender: TObject);
    procedure actEnabledUpdate(Sender: TObject);
    procedure actEnableAllExecute(Sender: TObject);
    procedure actEnableAllUpdate(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actNewSDIExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actOpenSDIExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actCloseAllExecute(Sender: TObject);
    procedure actCloseAllUpdate(Sender: TObject);
    procedure actSaveAsUpdate(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actCloseUpdate(Sender: TObject);
    procedure actSaveSaveAllExecute(Sender: TObject);
    procedure actSaveSaveAllUpdate(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actRunUpdate(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actPreviewExecute(Sender: TObject);
    procedure actPreviewUpdate(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actPrintUpdate(Sender: TObject);
    procedure actPropsViewExecute(Sender: TObject);
    procedure actPropsViewUpdate(Sender: TObject);
    procedure actDebugWinExecute(Sender: TObject);
    procedure actWindowbarExecute(Sender: TObject);
    procedure WindowCascade1Execute(Sender: TObject);
    procedure WindowTileHorizontal1Execute(Sender: TObject);
    procedure WindowTileVertical1Execute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

    procedure sbButtonClick(Sender: TObject);

    procedure ELDesigner1ChangeSelection(Sender: TObject);
    procedure ELDesigner1ControlDeleting(Sender: TObject;
      var AControlClass: TControlClass);
    procedure ELDesigner1ControlHint(Sender: TObject; AControl: TControl;
      var AHint: string);
    procedure ELDesigner1ControlInserted(Sender: TObject);
    procedure ELDesigner1ControlInsertError(Sender: TObject);
    procedure ELDesigner1ControlInserting(Sender: TObject;
      var AControlClass: TControlClass; var AComponentClass: TComponentClass);
    procedure ELDesigner1DblClick(Sender: TObject);
    procedure ELDesigner1DesignFormClose(Sender: TObject;
      var Action: TCloseAction);
    procedure ELDesigner1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ELDesigner1KeyPress(Sender: TObject; var Key: Char);
    procedure ELDesigner1Modified(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
    FPackageComponentList: TStringList;
    FPaletteList: TStringList;
    FSDIFormList: TStringList;

    FApplicationPath: string;
    FCreateChildFromBPL : array of TCreateChildFuncFromBPL;
    FCreateDocumentFuncFromBPL : TCreateDocumentFuncFromBPL;
    FCreateOIFuncFromBPL: TCreateOIFuncFromBPL;

    FPackageForms : array of HModule;
    FHiMECSForms: THiMECSForms; //xml로 부터 MDI Child form(bpl) list를 저장함
    FPropForm: TForm; //Object Inspector Form
    FPropFormClass: TFormClass; //Object Inspector Form Class
    //Form Close시에 자신을 LoadPackage한 Form에 알려주기 위해 SendMessage할때 필요한 핸들
    FBplOwner: TWinControl;//Owner for this form
    FBplFileList: TStringList; //LoadPackage한 List(중복 Load 방지 목적)
    //InitializePackage함수가 한번만 실행되기 위함(Tab Change마다 실행되기 때문임)
    FInitializePackageDone: Boolean;
    //FDockClient: TJvDockClient;

    procedure CreateChildFormAll;
    function CreateOrShowChildFormFromBpl(Aform: string; var AIndex: integer):Boolean;
    procedure PackageLoad_MDIChild;
    procedure UnloadAddInPackage(var AOwner: TComponent; AModule: THandle);
    procedure GetBplFileList;

    //For IbplMainInterface
    function GetELDesigner: TELDesigner;
    function GetActionList: TActionList;
    function GetMainHandle: THandle;
    function GetSaveDialog: TSaveDialog;
    function GetBplOwner: TWinControl;
    procedure SetBplOwner(Value: TWinControl);
    //For IbplMainInterface

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
    procedure AssignePropertyForm;
    //procedure SetDockStyle(ADockStyle: TJvDockBasicStyle);

    //For IbplMainInterface
    procedure PrepareOIInterface(LControl: TWinControl);
    procedure DestroyOIInterface;
    procedure GetTagNames(ATagNameList, ADescriptList: TStringList);
    procedure InitializePackage;

    property ActionList: TActionList read GetActionList;
    property MainHandle: THandle read GetMainHandle;
    property Designer: TELDesigner read ELDesigner1;
    property SaveDialog: TSaveDialog read GetSaveDialog;
    property BplOwner: TWinControl read GetBplOwner write SetBplOwner;
    //For IbplMainInterface

//    property DockClient: TJvDockClient read FDockClient;
  end;

var
  frmDesignManagerDock: TfrmDesignManagerDock;

implementation

{$R *.dfm}

uses pjhOIInterface, frmDocInterface, frmConst, About, UtilUnit,
    WatchConst2, Watch2Interface;

{$R *.dfm}
{$R Visual_Comm_MDI.res}
{$IFNDEF USE_PACKAGE}
  //{$R Indy.res}
{$ENDIF}

function Create_VisualCommForms: TForm;
begin
  Result := TfrmDesignManagerDock.Create(Application);
end;

procedure TfrmDesignManagerDock.actAlignToGridExecute(Sender: TObject);
begin
  Designer.SelectedControls.AlignToGrid;
end;

procedure TfrmDesignManagerDock.actAlignToGridUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actAlignToGrid.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actAlignToGrid.Enabled := True;
end;

procedure TfrmDesignManagerDock.actALLeftExecute(Sender: TObject);
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
  Designer.SelectedControls.Align(LHorzAlignType, LVertAlignType);
end;

procedure TfrmDesignManagerDock.actALLeftUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  TAction(Sender).Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        TAction(Sender).Enabled := True;
end;

procedure TfrmDesignManagerDock.actBringToFrontExecute(Sender: TObject);
begin
  Designer.SelectedControls.BringToFront;
end;

procedure TfrmDesignManagerDock.actBringToFrontUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actBringToFront.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actBringToFront.Enabled := True;
end;

procedure TfrmDesignManagerDock.actCloseAllExecute(Sender: TObject);
begin
  CloseAll;
end;

procedure TfrmDesignManagerDock.actCloseAllUpdate(Sender: TObject);
begin
  actCloseAll.Enabled := MDIChildCount > 0;
end;

procedure TfrmDesignManagerDock.actCloseExecute(Sender: TObject);
begin
  if MDIChildCount > 0 then
    ActiveMDIChild.Close;
end;

procedure TfrmDesignManagerDock.actCloseUpdate(Sender: TObject);
begin
  actClose.Enabled := (ActiveMDIChild <> nil);
end;

procedure TfrmDesignManagerDock.actCopyExecute(Sender: TObject);
begin
  Designer.Copy;
end;

procedure TfrmDesignManagerDock.actCopyUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  if (ActiveMDIChild <> nil) then
    actCopy.Enabled :=  Designer.CanCopy
  else
  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actCopy.Enabled := Designer.CanCopy;
end;

procedure TfrmDesignManagerDock.actCutExecute(Sender: TObject);
begin
  Designer.Cut;
end;

procedure TfrmDesignManagerDock.actCutUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  if (ActiveMDIChild <> nil) then
    actCut.Enabled :=  Designer.CanCut
  else
  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actCut.Enabled := Designer.CanCut;
end;

procedure TfrmDesignManagerDock.actDebugWinExecute(Sender: TObject);
begin
  if Assigned(FConsoleDebug) then
    StopConsoleDebug
  else
    StartConsoleDebug;
end;

procedure TfrmDesignManagerDock.actDeleteExecute(Sender: TObject);
var
  IsTpjhLogicPanel: Bool;
  IbOII : IbplOIInterface;
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

  FDeletedControlParent := Designer.SelectedControls.Items[0].Parent;
  Designer.Cut;

  if (ActiveMDIChild <> nil) then
    actUnDelete.Enabled := Designer.CanPaste
  else
  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actUnDelete.Enabled := Designer.CanPaste;

  //if IsTpjhLogicPanel then
  //  TfrmDoc(ActiveMDIChild).FpjhLogicPanel := nil;
end;

procedure TfrmDesignManagerDock.actDeleteUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actDelete.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actDelete.Enabled := True;
end;

procedure TfrmDesignManagerDock.actEnableAllExecute(Sender: TObject);
var
  LI: Integer;
  IbOII : IbplOIInterface;
begin
  if (ActiveMDIChild <> nil) then
  begin
    for LI := 0 to ActiveMDIChild.ComponentCount - 1 do
      if ActiveMDIChild.Components[LI] is TControl then
        TControl(ActiveMDIChild.Components[LI]).Enabled := True;

    ActiveMDIChild.Designer.Modified;
  end
  else
  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
      begin
        for LI := 0 to TForm(IbOII.Doc).ComponentCount - 1 do
          if TForm(IbOII.Doc).Components[LI] is TControl then
           TControl(TForm(IbOII.Doc).Components[LI]).Enabled := True;
        TForm(IbOII.Doc).Designer.Modified;
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.actEnableAllUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actEnableAll.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actEnableAll.Enabled := True;
end;

procedure TfrmDesignManagerDock.actEnabledExecute(Sender: TObject);
begin
  Designer.SelectedControls.DefaultControl.Enabled :=
    not Designer.SelectedControls.DefaultControl.Enabled;
  Designer.Modified;
end;

procedure TfrmDesignManagerDock.actEnabledUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      if (ActiveMDIChild <> nil) then
      begin
        actEnabled.Enabled := (Designer.SelectedControls.Count = 1) and
          (Designer.SelectedControls.DefaultControl <> ActiveMDIChild);
        actEnabled.Checked := actEnabled.Enabled and
          Designer.SelectedControls.DefaultControl.Enabled;
      end
      else
      if (IbOII.Doc <> nil) then// and (IbOII.Doc.FormStyle = fsNormal) then
      begin
        actEnabled.Enabled := (Designer.SelectedControls.Count = 1) and
          (Designer.SelectedControls.DefaultControl <> TForm(IbOII.Doc));
        actEnabled.Checked := actEnabled.Enabled and
          Designer.SelectedControls.DefaultControl.Enabled;
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.actExitExecute(Sender: TObject);
begin
  if Designer.Active then
    RunButton.Click;

  //DestroyOIInterface;
    //actRunExecute(nil);

  if Assigned(FBplOwner) then
    SendMessage(FBplOwner.Handle, WM_DESIGNMANAGER_CLOSE, 0, 0);
  //Close;
  if Assigned(FPropForm) then
    FPropForm.Hide;
  Hide;
end;

procedure TfrmDesignManagerDock.actLockExecute(Sender: TObject);
begin
  Designer.SelectedControls.Lock([lmNoResize, lmNoMove, lmNoDelete]);
end;

procedure TfrmDesignManagerDock.actLockUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actLock.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then // and (IbOII.Doc.FormStyle = fsNormal) then
        actLock.Enabled := (ActiveMDIChild <> nil);
end;

procedure TfrmDesignManagerDock.actNewExecute(Sender: TObject);
var
  LForm: TCustomForm;
  LFormClass: TClass;
  IbDI : IbplDocInterface;
  IbOII : IbplOIInterface;
begin
  LForm := nil;
{  if Assigned(FCreateChildFromBPL[0]) then
  begin
    LForm := FCreateChildFromBPL[0];
}
    LFormClass := GetClass('TfrmDoc');

    if Assigned(LFormClass)  then
      LForm := TComponentClass(LFormClass).Create(Application) as TCustomForm;

    if Assigned(LForm) then
    begin
      if Supports(LForm, IbplDocInterface, IbDI) then
      begin
        IbDI.OIForm := FPropForm;
        IbDI.MainForm := TForm(Self);
      end;

      if FPropForm <> nil then
        if Supports(FPropForm, IbplOIInterface, IbOII) then
          IbOII.Doc := TForm(LForm);

      //MDITab1.AddTab(TForm(LForm));
      //MDITab1Change(TForm(LForm));
      //MDITab1.AddTab(TForm(LForm),10);
    end;
//  end;
end;

procedure TfrmDesignManagerDock.actNewSDIExecute(Sender: TObject);
var
  LForm: TForm;
  IbDI : IbplDocInterface;
begin
  LForm := TForm.Create(Application);

  if Assigned(LForm) then
  begin
    if Supports(LForm, IbplDocInterface, IbDI) then
    begin
      IbDI.OIForm := FPropForm;
      IbDI.MainForm := TForm(Self);

      with ELDesigner1 do
      begin
        Active := False;
        DesignControl := LForm;
        Active := IbDI.IsDesignMode;
      end;

    end;

//    if FPropForm <> nil then
//      if Supports(FPropForm, IbplOIInterface, IbOII) then
//        IbOII.Doc := TWinControl(LForm);
  end;

  LForm.Show;
  //MDITab1.AddTab(LForm);
  //MDITab1Change(LForm);

  FSDIFormList.AddObject(LForm.Name, LForm);

{  with ELDesigner1 do
  begin
    Active := False;
    DesignControl := LForm;
    Active := TForm(LForm).IsDesignMode;
  end;
}
  PrepareOIInterface(LForm);
end;

procedure TfrmDesignManagerDock.actOpenExecute(Sender: TObject);
var
  LForm: TForm;
  IbOII : IbplOIInterface;
  IbDI : IbplDocInterface;
begin
  if OpenDialog1.Execute then
  begin
    LForm := nil;
    if Assigned(FCreateDocumentFuncFromBPL) then
    begin
      LForm := FCreateDocumentFuncFromBPL(Application, OpenDialog1.FileName);

      if Assigned(LForm) then
      begin
        if Supports(LForm, IbplDocInterface, IbDI) then
        begin
          IbDI.OIForm := FPropForm;
          IbDI.MainForm := TForm(Self);
        end;
      end;

      if FPropForm <> nil then
        if Supports(FPropForm, IbplOIInterface, IbOII) then
          IbOII.Doc := LForm;
    end;

    if LForm <> nil then
    begin
      //MDITab1.AddTab(LForm);
      //MDITab1Change(TForm(LForm));
    end;
  end;
end;

procedure TfrmDesignManagerDock.actOpenSDIExecute(Sender: TObject);
var LForm: TForm;
begin
  if OpenDialog1.Execute then
  begin
    LForm := nil;
    //LForm := TForm(TForm.CreateDocument(Application, OpenDialog1.FileName));
    //if LForm <> nil then
      //MDITab1.AddTab(LForm);
  end;
end;

procedure TfrmDesignManagerDock.actPasteExecute(Sender: TObject);
begin
  Designer.Paste;
end;

procedure TfrmDesignManagerDock.actPasteUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  if (ActiveMDIChild <> nil) then
    actPaste.Enabled := Designer.CanPaste
  else
  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then // and (IbOII.Doc.FormStyle = fsNormal) then
        actPaste.Enabled := Designer.CanPaste;
end;

procedure TfrmDesignManagerDock.actPreviewExecute(Sender: TObject);
var
  LV: Boolean;
  IbOII : IbplOIInterface;
begin
  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      LV := IbOII.OIVisible;
      IbOII.OIVisible := False;
      try
        //TfrmDoc(ActiveMDIChild).DataSet.Open;
        //TfrmDoc(ActiveMDIChild).Report.PreviewModal;
      finally
        IbOII.OIVisible := LV;
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.actPreviewUpdate(Sender: TObject);
begin
  actPreview.Enabled := (ActiveMDIChild <> nil);
end;

procedure TfrmDesignManagerDock.actPrintExecute(Sender: TObject);
var
  LV: Boolean;
  IbOII : IbplOIInterface;
begin
  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      LV := IbOII.OIVisible;
      IbOII.OIVisible := False;
      try
        //TfrmDoc(ActiveMDIChild).DataSet.Open;
        //TfrmDoc(ActiveMDIChild).Report.Print;
      finally
        IbOII.OIVisible := LV;
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.actPrintUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actPrint.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actPrint.Enabled := True;
end;

procedure TfrmDesignManagerDock.actPropsViewExecute(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      IbOII.OIVisible := not IbOII.OIVisible;
end;

procedure TfrmDesignManagerDock.actPropsViewUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      actPropsView.Checked := IbOII.OIVisible;
end;

procedure TfrmDesignManagerDock.actRunExecute(Sender: TObject);
var
  IbDI : IbplDocInterface;
  IbOII : IbplOIInterface;
begin
  if Assigned(ActiveMDIChild) then
  begin
    Designer.Active := not Designer.Active;
    if Supports(ActiveMDIChild, IbplDocInterface, IbDI) then
      IbDI.IsDesignMode := Designer.Active;
  end
  else
  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
      begin
        if Supports(IbOII.Doc, IbplDocInterface, IbDI) then
        begin
          Designer.Active := not Designer.Active;
          IbDI.IsDesignMode := Designer.Active;

          if Designer.Active then
          begin
            {$IFDEF USECODESITE}
            CodeSite.EnterMethod('Designer is Active');
            try
              CodeSite.Send('Designer1', Designer);
            {$ENDIF}
              AdvOfficeStatusBar1.Panels.Items[0].Text := 'Designer is Active';
              Designer.DesignPanel.FormRefresh;
              Designer.DesignControlRefresh;
            {$IFDEF USECODESITE}
            finally
              CodeSite.ExitMethod('Designer is Active');
            end;
            {$ENDIF}
          end
          else
          begin
            AdvOfficeStatusBar1.Panels.Items[0].Text := 'Designer is InActive';
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.actRunUpdate(Sender: TObject);
begin
  if Designer.Active then
    actRun.ImageIndex := 18
  else
    actRun.ImageIndex := 19;
end;

procedure TfrmDesignManagerDock.actSaveAsExecute(Sender: TObject);
begin
  SaveAs(ActiveMDIChild);
end;

procedure TfrmDesignManagerDock.actSaveAsUpdate(Sender: TObject);
begin
  actSaveAs.Enabled := (ActiveMDIChild <> nil);
end;

procedure TfrmDesignManagerDock.actSaveExecute(Sender: TObject);
begin
  Save(ActiveMDIChild);
end;

procedure TfrmDesignManagerDock.actSaveSaveAllExecute(Sender: TObject);
var
  IbDI : IbplDocInterface;
  IbOII : IbplOIInterface;
begin
  if (ActiveMDIChild <> nil) then
  begin
    if Supports(ActiveMDIChild, IbplDocInterface, IbDI) then
    begin
      if IbDI.FileName = '' then
        SaveAs(ActiveMDIChild)
      else
        Save(ActiveMDIChild);
    end;
  end
  else
  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
      begin
        if Supports(IbOII.Doc, IbplDocInterface, IbDI) then
        begin
          if IbDI.FileName = '' then
            SaveAs(TForm(IbOII.Doc))
          else
            Save(TForm(IbOII.Doc));
        end;
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.actSaveSaveAllUpdate(Sender: TObject);
var
  IbDI : IbplDocInterface;
  IbOII : IbplOIInterface;
begin
  if (ActiveMDIChild <> nil) then
  begin
    if Supports(ActiveMDIChild, IbplDocInterface, IbDI) then
      actSaveSaveAll.Enabled := //(ActiveMDIChild <> nil) and
        (IbDI.Modified) or ((IbDI).FileName = '');
  end
  else
    actSaveSaveAll.Enabled := False;

  //if FPropForm <> nil then
  //  if Supports(FPropForm, IbplOIInterface, IbOII) then
  //    if (IbOII.Doc <> nil) and (IbOII.Doc.FormStyle = fsNormal) then
  //      actSaveSaveAll.Enabled :=
  //        ((TForm(IbOII.Doc).Modified) or (TForm(IbOII.Doc).FileName = ''));
end;

procedure TfrmDesignManagerDock.actSelectAllExecute(Sender: TObject);
begin
  Designer.SelectedControls.SelectAll;
end;

procedure TfrmDesignManagerDock.actSelectAllUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actSelectAll.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actSelectAll.Enabled := True;
end;

procedure TfrmDesignManagerDock.actSendToBackExecute(Sender: TObject);
begin
  Designer.SelectedControls.SendToBack;
end;

procedure TfrmDesignManagerDock.actSendToBackUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actSendToBack.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actSendToBack.Enabled := True;
end;

procedure TfrmDesignManagerDock.actUndeleteExecute(Sender: TObject);
begin
  if Designer.CanPaste then
  begin
    if Assigned(FDeletedControlParent) then
      Designer.SelectedControls.Add(FDeletedControlParent);

    Designer.Paste;
    actUnDelete.Enabled := False;
  end;
end;

procedure TfrmDesignManagerDock.actUndeleteUpdate(Sender: TObject);
begin
  actUnDelete.Enabled := actPaste.Enabled;
end;

procedure TfrmDesignManagerDock.actUnlockAllExecute(Sender: TObject);
begin
  Designer.LockAll([]);
end;

procedure TfrmDesignManagerDock.actUnlockAllUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actUnlockAll.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actUnlockAll.Enabled := True;

end;

procedure TfrmDesignManagerDock.actUnlockExecute(Sender: TObject);
begin
  Designer.SelectedControls.Lock([]);
end;

procedure TfrmDesignManagerDock.actUnlockUpdate(Sender: TObject);
var
  IbOII : IbplOIInterface;
begin
  actUnlock.Enabled := (ActiveMDIChild <> nil);

  if FPropForm <> nil then
    if Supports(FPropForm, IbplOIInterface, IbOII) then
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        actUnlock.Enabled := True;
end;

procedure TfrmDesignManagerDock.actWindowbarExecute(Sender: TObject);
begin
  //mditab1.visible:=not mditab1.visible;
end;

procedure TfrmDesignManagerDock.AdjustChangeSelection;
var
  LObjects: TList;
  IbOII : IbplOIInterface;
begin
  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      //if (frmProps.Doc is TfrmDoc) or (frmProps.Doc is TForm) then
      if Assigned(IbOII.Doc) then
      begin
        LObjects := TList.Create;
        try
          ELDesigner1.SelectedControls.GetControls(LObjects);
          IbOII.PropInspComp.AssignObjects(LObjects);

          if ELDesigner1.SelectedControls.Count <> 1 then
            IbOII.RefreshObjListOfCombo
          else
            IbOII.RefreshObjListOfCombo(ELDesigner1.SelectedControls[0]);
          //if LObjects.Count > 0 then
          //  frmProps.RefreshObjListOfCombo(TControl(LObjects.Items[0]));
        finally
          LObjects.Free;
        end;
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.AssignePropertyForm;
var
  IbOII : IbplOIInterface;
begin
  if Assigned(FPropFormClass) then
  begin
    if not Assigned(FPropForm) then
    begin
      //Application.CreateForm(TComponentClass(FPropFormClass), FPropForm);
      FPropForm := FPropFormClass.Create(Application);

      if Assigned(FPropForm) then
      begin
        if Supports(FPropForm, IbplOIInterface, IbOII) then
        begin
          IbOII.MainForm := TForm(Self);
          IbOII.IsNormalWork := True;
          //IbOII.OIVisible := False;
        end;
      end;
    end;
  end
  else
    ShowMessage('not Assigned(FPropFormClass)');
end;

function TfrmDesignManagerDock.CloseAll: Boolean;
begin

end;

procedure TfrmDesignManagerDock.ControlInserted;
begin
  TSpeedButton(PageControl1.ActivePage.Controls[0]).Down:= True;
  TSpeedButton(PageControl1.ActivePage.Controls[0]).Click;
end;

procedure TfrmDesignManagerDock.ControlInserting(var AControlClass: TControlClass;
  var AComponentClass: TComponentClass);
var SelClass:TControlClass;
begin
  SelClass:= GetSelectComponent(AComponentClass);
  if SelClass <> nil then
    AControlClass := SelClass;
end;

// Create component of palette page (page name is PalettePage)
procedure TfrmDesignManagerDock.CreateChildFormAll;
var
  i: Integer;
begin
  for i := 0 to FHiMECSForms.PackageCollect.Count - 1 do
  begin
    if Assigned(FCreateChildFromBPL[i]) then
      FCreateChildFromBPL[i];
  end;
end;

function TfrmDesignManagerDock.CreateOrShowChildFormFromBpl(Aform: string;
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

procedure TfrmDesignManagerDock.CreatePalettePage(PalettePage, ComponentNames: string);
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

procedure TfrmDesignManagerDock.DeleteComponentPalette;
var i,j: integer;
begin
  for i := PageControl1.PageCount - 1 Downto 0 do
  begin
    for j := PageControl1.Pages[i].ControlCount - 1 downto 0 do
      PageControl1.Pages[i].Controls[j].Free;

    PageControl1.Pages[i].Free;
  end;
end;

procedure TfrmDesignManagerDock.DestroyOIInterface;
var
  IbOII : IbplOIInterface;
begin
  ELDesigner1.Active := False;
  ELDesigner1.DesignControl := nil;
  ELDesigner1.DesignPanel := nil;

  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      IbOII.ClearObjOfCombo();
      IbOII.Doc := nil;
    end;
  end;
end;

procedure TfrmDesignManagerDock.ELDesigner1ChangeSelection(Sender: TObject);
begin
  AdjustChangeSelection;
end;

procedure TfrmDesignManagerDock.ELDesigner1ControlDeleting(Sender: TObject;
  var AControlClass: TControlClass);
var
  LI: integer;
  LObjects: TList;
  IbOII : IbplOIInterface;
begin
  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      //컴포넌트를 삭제한 경우 삭제한 컴포넌트가 다른 컴포넌트의 파라미터값으로
      //설정 되어 있을때, 해당 컴포넌트를 선택하면 Access Violation 발생하는 버그 해결
      LObjects := TList.Create;
      try
        if TObject(AControlClass).ClassType = TWrapperControl then
          IbOII.DeleteControlName := TWrapperControl(AControlClass).Component.Name
        else
          IbOII.DeleteControlName := TControl(AControlClass).Name;

        if (ActiveMDIChild <> nil) then
        begin
          for LI := 0 to ActiveMDIChild.ComponentCount - 1 do
          begin
            LObjects.Clear;
            LObjects.Add(ActiveMDIChild.Components[LI]);
            IbOII.IsOnDelete := True;
            IbOII.PropInspComp.AssignObjects(LObjects);
            IbOII.IsOnDelete := False;
          end;

          //메인폼의 프로퍼티도 처리함
          LObjects.Clear;
          LObjects.Add(ActiveMDIChild);
        end
        else
        if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        begin
          for LI := 0 to TForm(IbOII.Doc).ComponentCount - 1 do
          begin
            LObjects.Clear;
            LObjects.Add(TForm(IbOII.Doc).Components[LI]);
            IbOII.IsOnDelete := True;
            IbOII.PropInspComp.AssignObjects(LObjects);
            IbOII.IsOnDelete := False;
          end;

          //메인폼의 프로퍼티도 처리함
          LObjects.Clear;
          LObjects.Add(TForm(IbOII.Doc));
        end;

        IbOII.IsOnDelete := True;
        IbOII.PropInspComp.AssignObjects(LObjects);
        IbOII.IsOnDelete := False;
        IbOII.DeleteControlName := '';

      finally
        LObjects.Free;
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.ELDesigner1ControlHint(Sender: TObject; AControl: TControl;
  var AHint: string);
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

procedure TfrmDesignManagerDock.ELDesigner1ControlInserted(Sender: TObject);
begin
  ControlInserted;
end;

procedure TfrmDesignManagerDock.ELDesigner1ControlInsertError(Sender: TObject);
begin
  TSpeedButton(PageControl1.ActivePage.Controls[0]).Down:= True;
  TSpeedButton(PageControl1.ActivePage.Controls[0]).Click;
end;

procedure TfrmDesignManagerDock.ELDesigner1ControlInserting(Sender: TObject;
  var AControlClass: TControlClass; var AComponentClass: TComponentClass);
begin
  ControlInserting(AControlClass, AComponentClass);
  //ShowMessage('Control Inserting');
end;

procedure TfrmDesignManagerDock.ELDesigner1DblClick(Sender: TObject);
var
  LControl: TControl;
begin
  if ELDesigner1.SelectedControls.Count = 1 then
  begin
    LControl := ELDesigner1.SelectedControls.DefaultControl;
  end;
end;

procedure TfrmDesignManagerDock.ELDesigner1DesignFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TForm(Designer.DesignControl).Close;

  //if FormWasClosed then
  //begin
    Designer.SelectedControls.Clear;
    Designer.Active := False;
  //end;
end;

procedure TfrmDesignManagerDock.ELDesigner1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LC: TControl;
begin
  if (Key = VK_DELETE) then
    ELDesigner1.Copy;
end;

procedure TfrmDesignManagerDock.ELDesigner1KeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmDesignManagerDock.ELDesigner1Modified(Sender: TObject);
var
  IbDI : IbplDocInterface;
  IbOII : IbplOIInterface;
begin
  if FPropForm <> nil then
  begin
    if Supports(FPropForm, IbplOIInterface, IbOII) then
    begin
      //if frmProps.Doc = Self then
      IbOII.PropInspComp.Modified;

      if (ActiveMDIChild <> nil) then
        if Supports(ActiveMDIChild, IbplDocInterface, IbDI) then
          IbDI.Modify
      else
      if (IbOII.Doc <> nil) then //and (IbOII.Doc.FormStyle = fsNormal) then
        if Supports(IbOII.Doc, IbplDocInterface, IbDI) then
          IbDI.Modify;
      //ELDesigner1.Grid.Color := CalcComplementalColor(ELDesigner1.DesignPanel.GetPanelColor);
      IbOII.ClearObjOfCombo();
      IbOII.FillObjList2Combo();
      AdjustChangeSelection();
    end;
  end;
end;

procedure TfrmDesignManagerDock.FormClose(Sender: TObject;
  var Action: TCloseAction);
var i: integer;
begin
  //ShowMessage('Close');
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
  for i := 0 to FSDIFormList.Count - 1 do
    TForm(FSDIFormList.Objects[i]).Free;

  FreeAndNil(FSDIFormList);
  if Assigned(FPropForm) then
  begin
    FPropForm.Close;
    FreeAndNil(FPropForm);
  end;

{$IFDEF USE_PACKAGE}
  FreeAndNil(FPaletteList); //UnloadPackage보다 먼저 Free하면 에러 안남???

  for i := 0 to FPackageComponentList.Count - 1 do
  begin
    //해제하고자 하는 Package가 FBplFileList에 없는 경우에만 실행
    //(있는 경우에는 Watch2에서 해제함
    if FBplFileList.IndexOf(FPackageComponentList.Strings[i]) = -1 then
      if HMODULE(FPackageComponentList.Objects[i]) <> 0 then
      begin
        UnloadAddInPackage(TComponent(Self), HMODULE(FPackageComponentList.Objects[i]));
        //UnloadPackage(HMODULE(FPackageComponentList.Objects[i]));
        //ShowMessage(FPackageComponentList.Strings[i]);
      end;
  end;

  //FPackageComponentList.Clear;
  FreeAndNil(FPackageComponentList);
{$ENDIF}

  FreeAndNil(FBplFileList);
  FreeAndNil(FHiMECSForms);
  FreeAndNil(FHiMECSComponents);

  if Assigned(FPropFormClass) then
    FPropFormClass := nil;

  if Assigned(FPackageForms) then
  begin
    for i := Low(FPackageForms) to High(FPackageForms) do
      if FPackageForms[i] <> 0 then
        UnloadAddInPackage(TComponent(Self), FPackageForms[i]);
        //UnloadPackage(FPackageForms[i]);

    FPackageForms := nil;
  end;

  FCreateChildFromBPL := nil;
end;

procedure TfrmDesignManagerDock.FormCreate(Sender: TObject);
begin
{$IFDEF USECODESITE}
  //CodeSite.Enabled := True;
  CodeSite.Enabled := CodeSite.Installed;
  CodeSite.Clear;
//{$ELSE}
//  CodeSite.Enabled := False;
{$ENDIF}
  FEaster_Start := TEasternEgg.Create([ssCtrl], EASTER_SAMPLE, self);
  FApplicationPath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  SetCurrentDir(FApplicationPath);
  //FEaster_Start.FOnEasterEgg := StartConsoleDebug;
  Caption := Caption + VERSION;

  FHiMECSForms := THiMECSForms.Create(Self);
  FHiMECSComponents := THiMECSComponents.Create(Self);
  FPackageComponentList := TStringList.Create;
  FPaletteList := TStringList.Create;
  FSDIFormList := TStringList.Create;
  FBplFileList := TStringList.Create;
  FCreateDocumentFuncFromBPL := nil;
  FBplOwner := nil; //Form Close시에 LoadPackage한 Form에 알려주기 위함

  //이 함수는 반드시 위 문장 아래에 위치해야 함. 안그러면 에러남
  //RegisterDefaultComponent;

  {DockSite := True;
  DragKind := dkDock;

  FDockClient := TJvDockClient.Create(Self);
  with FDockClient do
  begin
    DirectDrag := True;
    ShowHint := True;
    EnableCloseButton := True;
    EachOtherDock := False;
  end }
end;

procedure TfrmDesignManagerDock.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FEaster_Start.CheckKeydown(Key, Shift);
end;

function TfrmDesignManagerDock.GetActionList: TActionList;
begin
  Result := ActionList1;
end;

procedure TfrmDesignManagerDock.GetBplFileList;
var
  IW2I : IWatch2Interface;
begin
  if BplOwner <> nil then
  begin
    if Supports(BplOwner, IWatch2Interface, IW2I) then
    begin
      IW2I.GetLoadedPackages(FBplFileList); //Watch2에서 LoadPackage한 list 가져옴
      //ShowMessage('IW2I.GetLoadedPackages(FBplFileList)');
    end;
  end;
end;

function TfrmDesignManagerDock.GetBplOwner: TWinControl;
begin
  Result := FBplOwner;
end;

procedure TfrmDesignManagerDock.GetDispCompNames(List: TStrings);
begin
  List.Add('TpjhLanIfControl');
  List.Add('TIndyWriteClientTCP');
  List.Add('TIndyReadClientTCP');
  List.Add('TIndyWriteFile');
end;

procedure TfrmDesignManagerDock.GetDispPropNames(List: TStrings);
begin
  List.Add('FAMemoryManager');
  List.Add('FAMemName');
  List.Add('FAMemIndex');

  List.Add('ListenControl');
  List.Add('LanControl');
  List.Add('CommBlock');
end;

function TfrmDesignManagerDock.GetELDesigner: TELDesigner;
begin
  Result := ELDesigner1;
end;

function TfrmDesignManagerDock.GetMainHandle: THandle;
begin
  Result := Handle;
end;

function TfrmDesignManagerDock.GetSaveDialog: TSaveDialog;
begin
  Result := SaveDialog1;
end;

//TComponent가 아닌 TComponentClass이어야 클래스 정보를 가져올 수 있음
//TControlClass도 마찬가지...
function TfrmDesignManagerDock.GetSelectComponent(
  var AComponent: TComponentClass): TControlClass;
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

procedure TfrmDesignManagerDock.GetTagNames(ATagNameList, ADescriptList: TStringList);
var
  IW2I : IWatch2Interface;
begin
  if ELDesigner1.Active then
  begin
    if BplOwner <> nil then
    begin
      if Supports(BplOwner, IWatch2Interface, IW2I) then
      begin
        IW2I.GetTagNames(ATagNameList, ADescriptList);
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.InitializePackage;
begin
  if FInitializePackageDone then
    exit;

  FInitializePackageDone := True;

  GetBplFileList; //이미 로드된 .bpl list 가져옴

  MakeComponentPalette;

  //FHiMECSForms.PackageCollect.Clear;
  //FHiMECSForms.LoadFromFile('.\'+DefaultFormsFileName,DefaultFormsFileName,True);
  //SetLength(FPackageForms, FHiMECSForms.PackageCollect.Count);
  //SetLength(FCreateChildFromBPL, FHiMECSForms.PackageCollect.Count);
  //FCreateOIFuncFromBPL := nil;

  PackageLoad_MDIChild;
end;

procedure TfrmDesignManagerDock.LoadDefaultButton(TabSheet: TTabSheet);
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

procedure TfrmDesignManagerDock.MakeBitmap(Component: TSpeedButton; ComponentName: string);
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
      for i := 0 to FPackageComponentList.Count - 1 do
      begin
        ResBitmap.Handle := LoadBitmap(hModule(FPackageComponentList.Objects[i]), ResName);
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

// Dynamic loading components
procedure TfrmDesignManagerDock.MakeComponentPalette;
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

  SetCurrentDir(ExtractFilePath(Application.ExeName));
{$IFDEF USE_PACKAGE}
  //Component1.Visible := True;
  _LoadPackages('.\VisualComponents.list', FPaletteList);
{$ELSE}
  //FPaletteList.AddStrings(pjhFlowChartCompnents.GetPaletteList);
  FPaletteList.AddStrings(pjhDelphiStandardCompList.GetPaletteList);
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

procedure TfrmDesignManagerDock.PackageLoad_MDIChild;
var
  i: integer;
  LStr: string;
  IbOI : IbplOIInterface;
begin
  SetCurrentDir(FApplicationPath);

{$IFDEF USE_PACKAGE}
  FHiMECSForms.PackageCollect.Clear;
  FHiMECSForms.LoadFromFile('.\'+DefaultFormsFileName,DefaultFormsFileName,True);
  SetLength(FPackageForms, FHiMECSForms.PackageCollect.Count);
  SetLength(FCreateChildFromBPL, FHiMECSForms.PackageCollect.Count);

  LStr := IncludeTrailingPathDelimiter('..\Forms');
  //LStr := IncludeTrailingPathDelimiter('.\Package');
  FCreateOIFuncFromBPL := nil;

  for i := 0 to FHiMECSForms.PackageCollect.Count - 1 do
  begin               //FHiMECSConfig.HiMECSFormPath는 PackageName에 포함되어 있음
    FPackageForms[i] := LoadPackage(LStr+FHiMECSForms.PackageCollect.Items[i].PackageName);

    if FPackageForms[i] <> 0 then
    begin
      try
        @FCreateChildFromBPL[i] := GetProcAddress(FPackageForms[i], PWideChar(FHiMECSForms.PackageCollect.Items[i].CreateFuncName));

        if UpperCase(FHiMECSForms.PackageCollect.Items[i].PackageName) = 'PJHDOCPACKAGE.BPL' then
          @FCreateDocumentFuncFromBPL := GetProcAddress(FPackageForms[i], 'CreateDocument_VisualCommForms')
        else
        if UpperCase(FHiMECSForms.PackageCollect.Items[i].PackageName) = 'PJHOIPACKAGE.BPL' then
          @FCreateOIFuncFromBPL := GetProcAddress(FPackageForms[i], 'Create_ObjectInspector');
      except
        ShowMessage('Package Create function: '+ FHiMECSForms.PackageCollect.Items[i].CreateFuncName +
          ' not found!');
      end;//try
    end;//if
  end;//for
{$ENDIF}

  FPropForm := nil;
  FPropFormClass := TFormClass(GetClass('TfrmProps'));

  if not Assigned(FPropFormClass) then
    ShowMessage('Fail TfrmProps GetClass');

  AssignePropertyForm;
end;

procedure TfrmDesignManagerDock.PrepareOIInterface(LControl: TWinControl);
var
  IbOII : IbplOIInterface;
begin
  if ELDesigner1.Active then
  begin
    if FPropForm <> nil then
    begin
      if Supports(FPropForm, IbplOIInterface, IbOII) then
      begin
        //showmessage('PrepareOIInterface');
        IbOII.Doc := LControl;
        IbOII.SetDesigner4PropInsp(Pointer(ELDesigner1));
        IbOII.ClearObjOfCombo();
        IbOII.FillObjList2Combo();
        AdjustChangeSelection();
      end;
    end;
  end;
end;

procedure TfrmDesignManagerDock.RegisterDefaultComponent;
var
  tmpList, tmpList2: TStrings;
  IbOII : IbplOIInterface;
begin
  tmpList := TStringList.Create;
  tmpList2 := TStringList.Create;
  try
    GetDispCompNames(tmpList2);
    GetDispPropNames(tmpList);

    if FPropForm <> nil then
      if Supports(FPropForm, IbplOIInterface, IbOII) then
        IbOII.FillDisplayPropName(tmpList2, tmpList);
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpList2);
  end;//try
end;

procedure TfrmDesignManagerDock.Save(ADoc: TForm);
var
  IbDI : IbplDocInterface;
begin
  if ADoc.FormStyle = fsMDIChild then
  begin
    //MDI Child가 없을때 저장을 하면 에러가 나는 문제 해결
    if ActiveMDIChild <> nil then
    begin
      if Supports(ActiveMDIChild, IbplDocInterface, IbDI) then
      begin
        if IbDI.FileName = '' then
          SaveAs(ADoc)
        else
          IbDI.Save;
      end;
    end;
  end;
end;

function TfrmDesignManagerDock.SaveAs(ADoc: TForm): Boolean;
var
  LS: string;
  IbDI : IbplDocInterface;
  label Again;
begin
  if ADoc.FormStyle = fsMDIChild then
  begin
    //MDI Child가 없을때 저장을 하면 에러가 나는 문제 해결
    if ActiveMDIChild = nil then
      exit;

    if Supports(ActiveMDIChild, IbplDocInterface, IbDI) then
    begin
      if IbDI.FileName <> '' then
        LS := IbDI.FileName
      else
        LS := IbDI.FormCaption;
    end;
  end
  else
  if ADoc.FormStyle = fsNormal then
  begin
    if Supports(ADoc, IbplDocInterface, IbDI) then
    begin
      if IbDI.FileName <> '' then
        LS := IbDI.FileName
      else
        LS := TForm(ADoc).Caption;
    end;
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
          begin
            if Supports(ActiveMDIChild, IbplDocInterface, IbDI) then
              IbDI.SaveAs(LS);
          end
          else
          if ADoc.FormStyle = fsNormal then
            if Supports(ADoc, IbplDocInterface, IbDI) then
              IbDI.SaveAs(LS)
        end;
        mrNo: Goto Again;
        mrCancel: exit;
      end;
    end
    else
    begin
      if ADoc.FormStyle = fsMDIChild then
        if Supports(ActiveMDIChild, IbplDocInterface, IbDI) then
          IbDI.SaveAs(LS)
      else
      if ADoc.FormStyle = fsNormal then
        if Supports(ADoc, IbplDocInterface, IbDI) then
          IbDI.SaveAs(LS)
    end;
  end;
end;

procedure TfrmDesignManagerDock.sbButtonClick(Sender: TObject);
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
  AdvOfficeStatusBar1.Panels[1].Text := FSelectedComponentName;
end;

procedure TfrmDesignManagerDock.SetBplOwner(Value: TWinControl);
begin
  FBplOwner := Value;
end;
{
procedure TfrmDesignManagerDock.SetDockStyle(ADockStyle: TJvDockBasicStyle);
begin
  //FDockClient.DockStyle := TJvDockBasicStyle(ADockStyle);
  //FDockClient.DockStyle := ADockStyle;
end;
}
procedure TfrmDesignManagerDock.StartConsoleDebug;
begin
  if not (Assigned(FConsoleDebug)) then
    FConsoleDebug := TConsoleDebug.Create;
end;

procedure TfrmDesignManagerDock.StopConsoleDebug;
begin
  if Assigned(FConsoleDebug) then
  begin
    FConsoleDebug.Destroy;
    FConsoleDebug := nil;
  end;
end;

procedure TfrmDesignManagerDock.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TfrmDesignManagerDock.UnloadAddInPackage(var AOwner: TComponent; AModule: THandle);
var
  i: integer;
  M: TMemoryBasicInformation;
begin
  for i := AOwner.ComponentCount - 1 downto 0 do
  begin
    VirtualQuery(GetClass(AOwner.Components[i].ClassName), M, SizeOf(M));

    if (AModule = 0) or (HMODULE(M.AllocationBase) = AModule) then
      //FreeAndNil(AOWner.Components[i]);
      AOWner.Components[i].Free;
  end;

  UnRegisterModuleClasses(AModule);
  UnLoadPackage(AModule);
end;

procedure TfrmDesignManagerDock.WindowCascade1Execute(Sender: TObject);
begin
  Cascade;
end;

procedure TfrmDesignManagerDock.WindowTileHorizontal1Execute(Sender: TObject);
begin
  TileMode:=tbHorizontal;
  Tile;
end;

procedure TfrmDesignManagerDock.WindowTileVertical1Execute(Sender: TObject);
begin
  TileMode:=tbVertical;
  Tile;
end;

procedure TfrmDesignManagerDock._LoadPackages(AFileName: string; APaletteList: TStringList);
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

    for i := 0 to FPackageComponentList.Count - 1 do
    begin
      if HMODULE(FPackageComponentList.Objects[i]) <> 0 then
        UnloadPackage(HMODULE(FPackageComponentList.Objects[i]));
    end;

    FPackageComponentList.Clear;

    for i := 0 to tmpList.Count - 1 do
    begin
      //.bpl 파일이 존재하지 않으면 FPackageComponentList에서 삭제
      if not FileExists(tmpList.Strings[i]) then
      begin
        j := FPackageComponentList.IndexOfName(tmpList.Strings[i]);
        if j >= 0 then
        begin
          UnloadPackage(HMODULE(FPackageComponentList.Objects[j]));
          FPackageComponentList.Delete(j);
        end;
      end;

      //이미 Load한 Package라면 Skip
      //if FPackageComponentList.IndexOf(tmpList.Strings[i]) >= 0 then
      //  Continue;
      ExecF := nil;

      pModule := LoadPackage(tmpList.Strings[i]);

      if pModule <> 0 then
      begin
        FPackageComponentList.AddObject(tmpList.Strings[i], Pointer(pModule));
        //tmpList2.Assign(FPackageComponentList.Objects[i].GetPaletteList);
        @ExecF := GetProcAddress(hModule(FPackageComponentList.Objects[i]), 'GetPaletteList');
      end;

      tmpList2.Clear;

      if Assigned(ExecF) then
      begin
        tmpList2 := ExecF();
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

initialization
  ForceCurrentDirectory := True;
  RegisterClasses([TfrmDesignManagerDock]);

finalization
  UnRegisterClasses([TfrmDesignManagerDock]);

end.
