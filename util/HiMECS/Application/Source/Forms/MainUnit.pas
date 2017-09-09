unit MainUnit;
{
2013.5.28
- 복수개의 EngineParameter 사용 가능
  : .himecs 파일에 여러 엔진 option file 저장 가능
  : engine parameter 창에서 해당 엔진 double-click 하면 engine info 정보 갱신 됨
2013.5.21
- HiMECS.manifest 파일 적용, release 모드일 경우에만(볼랜드포럼에서 참조)
  : 관리자 권한으로 실행 됨(F9로 실행 안됨)
  : Debug 모드에서는 사용자 권한으로 실행(F9 실행 됨)
2011.3.28
- ChildForm 생성시 Border Icon이 안 나오는 문제 해결
  : WM_SIZE 메세지 함수 삭제해서 해결함.
2011.3.21
- 검게 변하는 문제가 다시 발생함.
  : CustomDrawItem event에 EngineInfoInspector.Invalidate 추가함. 아래 문제는 해결안됨.
2011.3.15
- NxInspetctor 의 내용이 다른 윈도우에 가렸을때 검게 변하는 문제 해결함
  : NxScrollContol.WMEraseBkGnd 함수에 invalidate 추가함. (2011.1.28 조치 삭제함)
2011.2.11
- 외부 프로그램을 MDI Child로 생성하는 함수 추가
- Window cascade, horizontal, vertical 추가

2011.1.28
- NextInspector에서 내용이 까많게 나오는 문제 해결
  : OnMouseMove, OnMouseDown, OnMouseUp Event에 EngineInfoInspector.Invalidate 추가함.
}
interface

uses
  DragDrop, DropSource, DragDropFormats, DropTarget, DragDropText,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, NxCollection, NxToolBox, ExtCtrls, ImgList, AdvSplitter,
  AdvNavBar, HiMECSInterface, HiMECSFormCollect, HiMECSConst, AdvToolBar,TypInfo,
  AdvSmoothTileList,AdvGDIP,
  AdvSmoothTileListImageVisualizer, AdvSmoothTileListHTMLVisualizer,
  EngineBaseClass, NxScrollControl, NxInspector, NxPropertyItems,
  NxPropertyItemClasses, JvDialogs, StdCtrls, StdActns, ActnList, HiMECSExeCollect,
  MenuBaseClass, UnitConfig, ComCtrls, JvExComCtrls,
  JvComCtrls, JvCheckTreeView, EngineParameterClass, AdvTabSet, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, AdvToolBarStylers, AdvMenus, DragDropRecord,
  CopyData, TimerPool, UnitEngParamConfig, GDIPPictureContainer,
  AdvSmoothSplashScreen, Types, jpeg, HiMECSUserClass, WUpdate,
  AdvOfficeStatusBar, ProjectBaseClass, ProjectFileClass,
  Cromis.Comm.IPC, UnitFrameTileList, HiMECSConfigCollect, HiMECSMonitorListClass,
  MonitornewApp_Unit, CommnewApp_Unit, AutoRunClass, UnitTileConfig,
  IPCThrd_HiMECS_MDI, Vcl.AppEvnts, UnitKillProcessList, KillProcessListClass,
  UnitParameterManager, JvComponentBase, JvAppHotKey, System.Actions, HiMECSManualClass,
  UnitRegistration, UnitRegistrationClass, AdvSmartMessageBox, AdvOfficePager;

type
  TWMTraceData = record
    Msg: Cardinal;
    X: Smallint;
    Y: Smallint;
    Flag: TClientFlag;
    Result: Longint;
  end;

  TLabelRec = record
    XLabel: TLabel;
    YLabel: TLabel;
  end;

  TCreateChildFromBPL = procedure of object;

  TMainForm = class(TForm, IConfigChanged)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Settings1: TMenuItem;
    Software1: TMenuItem;
    Connect1: TMenuItem;
    DisConnect1: TMenuItem;
    N1: TMenuItem;
    Configuration1: TMenuItem;
    Project1: TMenuItem;
    N3: TMenuItem;
    Download2: TMenuItem;
    CheckVersion1: TMenuItem;
    Openproject1: TMenuItem;
    CloseProject1: TMenuItem;
    SmallImageList: TImageList;
    LargeImageList: TImageList;
    AdvNavBar1: TAdvNavBar;
    EngineInfoPanel: TAdvNavBarPanel;
    EngineParamPanel: TAdvNavBarPanel;
    ProjectInfoPanel: TAdvNavBarPanel;
    EngMaintenancePanel: TAdvNavBarPanel;
    MonitoringPanel: TAdvNavBarPanel;
    AdvSplitter1: TAdvSplitter;
    JvOpenDialog1: TJvOpenDialog;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileOpen1: TAction;
    FileClose1: TWindowClose;
    FileSave1: TAction;
    FileSaveAs1: TAction;
    FileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowArrangeAll1: TWindowArrange;
    HelpAbout1: TAction;
    ActionMDICascade: TAction;
    ActionMDITileHorizontal: TAction;
    ActionMDITileVertical: TAction;
    ActionMDIArrange: TAction;
    ActionMDIMinimize: TAction;
    acLaunchNotepad: TAction;
    MainMenuImageList: TImageList;
    Window1: TMenuItem;
    Cascade1: TMenuItem;
    Horizontal1: TMenuItem;
    Vertical1: TMenuItem;
    EngineInfoPopupMenu: TPopupMenu;
    SaveEngineInfo1: TMenuItem;
    CallapseAll1: TMenuItem;
    ExpandAll1: TMenuItem;
    N2: TMenuItem;
    LoadAllInfo1: TMenuItem;
    Options1: TMenuItem;
    LoadEngineInfo1: TMenuItem;
    JvSaveDialog1: TJvSaveDialog;
    imTreeView: TImageList;
    ParamPopUp: TPopupMenu;
    MenuItem3: TMenuItem;
    SortbySystem1: TMenuItem;
    SortbySensor1: TMenuItem;
    CreateCategory1: TMenuItem;
    CopyItem1: TMenuItem;
    LoadParameterfromfile1: TMenuItem;
    N4: TMenuItem;
    MainPopupMenu: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem4: TMenuItem;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvPopupMenu1: TAdvPopupMenu;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    ImageListThrobber: TImageList;
    Timer1: TTimer;
    N5: TMenuItem;
    Clearallparameter1: TMenuItem;
    CreateSubCategory1: TMenuItem;
    N6: TMenuItem;
    DeleteItem1: TMenuItem;
    SavetoFile1: TMenuItem;
    JvCheckTreeView1: TJvCheckTreeView;
    AddtoNewWatch1: TMenuItem;
    N7: TMenuItem;
    Property1: TMenuItem;
    CallapseAll2: TMenuItem;
    ExpandAll2: TMenuItem;
    N8: TMenuItem;
    AddtoNewWatch21: TMenuItem;
    AddtoAlarmList1: TMenuItem;
    AdvSmoothSplashScreen1: TAdvSmoothSplashScreen;
    GDIPPictureContainer1: TGDIPPictureContainer;
    AddtoSaveList1: TMenuItem;
    WebUpdate1: TWebUpdate;
    StatusBarPro1: TAdvOfficeStatusBar;
    DropTextTarget1: TDropTextTarget;
    EngParamSource: TDropTextSource;
    ProjectInfoInspector: TNextInspector;
    NxTextItem6: TNxTextItem;
    ProjInfoPopupMenu: TPopupMenu;
    MenuItem2: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    LoadProjectInfo1: TMenuItem;
    SaveProjectInfo1: TMenuItem;
    N9: TMenuItem;
    SaveAsProject1: TMenuItem;
    CreateProject1: TMenuItem;
    EngineInfoInspector: TNextInspector;
    SelectEngineCombo: TNxComboBoxItem;
    NxTextItem1: TNxTextItem;
    NxTextItem2: TNxTextItem;
    NxTextItem3: TNxTextItem;
    NxTextItem4: TNxTextItem;
    ComponentsNxItem: TNxTextItem;
    AddDummy1: TMenuItem;
    Panel1: TPanel;
    Edit2: TEdit;
    MonTileListFrame: TFrame1;
    CommunicationPanel: TAdvNavBarPanel;
    CommTileListFrame: TFrame1;
    TileConfigPopup: TPopupMenu;
    LoadFromFile1: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    ExecuteAll1: TMenuItem;
    ExecuteSelectedTile1: TMenuItem;
    TileConfig2: TMenuItem;
    N10: TMenuItem;
    ListConfig1: TMenuItem;
    N11: TMenuItem;
    ShowAllMonitor1: TMenuItem;
    HideAllMonitor1: TMenuItem;
    NxTextItem5: TNxTextItem;
    CopyParameterToMonitor1: TMenuItem;
    JvApplicationHotKey1: TJvApplicationHotKey;
    ManualPanel: TAdvNavBarPanel;
    ManualCheckTV: TJvCheckTreeView;
    Panel2: TPanel;
    ManualSearchEdit: TEdit;
    AdvSmartMessageBox1: TAdvSmartMessageBox;
    AdvOfficePager1: TAdvOfficePager;
    EngineManagePage: TAdvOfficePage;
    AdvOfficeMDITabSet1: TAdvOfficeMDITabSet;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EngineInfoInspectorMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure EngineInfoInspectorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AdvNavBar1SplitterMove(Sender: TObject; OldSplitterPosition,
      NewSplitterPosition: Integer);
    procedure Cascade1Click(Sender: TObject);
    procedure Horizontal1Click(Sender: TObject);
    procedure Vertical1Click(Sender: TObject);
    procedure ExpandAll1Click(Sender: TObject);
    procedure LoadAllInfo1Click(Sender: TObject);

    procedure Options1Click(Sender: TObject);
    procedure LoadEngineInfo1Click(Sender: TObject);
    procedure SaveEngineInfo1Click(Sender: TObject);
    procedure SortbySystem1Click(Sender: TObject);
    procedure SortbySensor1Click(Sender: TObject);
    procedure JvCheckTreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure JvCheckTreeView1DblClick(Sender: TObject);
    procedure LoadParameterfromfile1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure DropTextTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure CreateCategory1Click(Sender: TObject);
    procedure Clearallparameter1Click(Sender: TObject);
    procedure CreateSubCategory1Click(Sender: TObject);
    procedure DropTextTarget1DragOver(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure DeleteItem1Click(Sender: TObject);
    procedure SavetoFile1Click(Sender: TObject);
    procedure AddtoNewWatch1Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Property1Click(Sender: TObject);
    procedure EngineInfoInspectorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EngineInfoInspectorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EngineInfoInspectorAfterEdit(Sender: TObject; Item: TNxPropertyItem);
    procedure CallapseAll2Click(Sender: TObject);
    procedure ExpandAll2Click(Sender: TObject);
    procedure CallapseAll1Click(Sender: TObject);
    procedure CopyItem1Click(Sender: TObject);
    procedure AddtoNewWatch21Click(Sender: TObject);
    procedure AddtoAlarmList1Click(Sender: TObject);
    procedure AddtoSaveList1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure LoadProjectInfo1Click(Sender: TObject);
    procedure SaveProjectInfo1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure SaveAsProject1Click(Sender: TObject);
    procedure JvCheckTreeView1CustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure SelectEngineComboCloseUp(Sender: TNxPropertyItem);
    procedure JvCheckTreeView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddDummy1Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);

    procedure MonTileListFrametileListTileDblClick(Sender: TObject;
      ATile: TAdvSmoothTile; State: TTileState);
    procedure CommTileListFrametileListTileDblClick(Sender: TObject;
      ATile: TAdvSmoothTile; State: TTileState);
    procedure CommTileListFrametileListMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MonTileListFrametileListMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TileConfig2Click(Sender: TObject);
    procedure LoadFromFile1Click(Sender: TObject);
    procedure ExecuteSelectedTile1Click(Sender: TObject);
    procedure StatusBarPro1Click(Sender: TObject);
    procedure AdvOfficeMDITabSet1TabClick(Sender: TObject; TabIndex: Integer);
    procedure ListConfig1Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure ShowAllMonitor1Click(Sender: TObject);
    procedure HideAllMonitor1Click(Sender: TObject);
    procedure WebUpdate1FileProgress(Sender: TObject; FileName: string; Pos,
      Size: Integer);
    procedure CopyParameterToMonitor1Click(Sender: TObject);
    procedure JvCheckTreeView1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ManualCheckTVMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ManualCheckTVKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ManualCheckTVKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ManualCheckTVDblClick(Sender: TObject);
    procedure ManualSearchEditChange(Sender: TObject);
  private
    FOldPanelProc: TWndMethod;
    FNewClient,
    FOldClient: Pointer;

    FRegInfo: TRegistrationInfo;
    FFirst: Boolean; //타이머 동작 완료하면 True
    FPackageModules : array of HModule;
    FWatchHandles : TpjhArrayHandle;//Parameter 창 PopupMenu에서 Ass to Multi-Watch 창을 띄운 경우의 Handle을 저장 함
    //FAutoRunHandles: TpjhArrayHandle;
    //FMonitorHandles: TpjhArrayHandle;
    FPackageList_Exes: TStringList;
    FCreateChildFromBPL : array of TCreateChildFromBPL;
    FPJHTimerPool: TPJHTimerPool;

    FApplicationPath: string;

    FMouseClickParaTV_X,
    FMouseClickParaTV_Y: Integer;
    FMouseClickManualTV_X,
    FMouseClickManualTV_Y: Integer;

    FHiMECSUser: THiMECSUser;
    FHiMECSForms: THiMECSForms; //xml로 부터 MDI Child form(bpl) list를 저장함
    FHiMECSExes: THiMECSExes; //xml로 부터 Exe List를 저장함
    //FEngineInfoCollect: TICEngine; //Engine Basic Info
    //FEngineInfoList: TStringList;
    FProjectInfoCollect: TVesselInfo; //Project Info(공사번호 등...)
    FProjectFile: TProjectFile;//project file
    FMenuBase: TMenuBase;
    //FHiMECSOptions: THiMECSOptions;
    //FHiMECSConfig: THiMECSConfig;
    //FEngineParameter: TEngineParameter;
    //FEngineParameterList: TStringList;
    FSearchParamList: TStringList;
    FCurrentParaFileName, //Sort할때 현재 사용중인 파일이름이 필요함
    FCurrentManualInfoFileName,
    FUserFileName: string;//Login에 필요한 User File name

    //Engine Parameter에서 Properties 메뉴를 선택하거나
    //Engine Info에서 Engine Select 할때 변경 됨
    FCOI: integer;//FCurrentOptionIndex: 사용중인 FHiMECSOptions.HiMECSOptionsCollect Index
    //FCEI: integer;//FCurrentEngineInfoIndex: 사용중인 FEngineInfoList Index
    FCurrentUserLevel: THiMECSUserLevel;
    FCurrentUserIndex: integer;  //User List에서 현재 User의 Index 저장
    FMDIChildCount: Integer;
    FWindowList: array of Integer;

    FEngineParameterItemRecord: TEngineParameterItemRecord; //Watch폼에 값 전달시 사용

    FMultiWatchHandle,
    FAlarmListHandle: THandle;

    FTick: integer;
    FProcInfo: TProcessInformation;
    FDragFormatTarget: TGenericDataFormat;

    FEngParamSource: TEngineParameterDataFormat;
    //FEP_DragDrop: TEngineParameter_DragDrop; //drag drop 으로 받은 record
    FParameterDragMode: Boolean;//Treeview에서 마우스 클릭시 True,False 됨.
    FParamCopyMode: integer;//Ord(TParamDragCopyMode)가 저장 됨
    FArrayEngineParameterItemRecord : array of TEngineParameterItemRecord;

    //---------------------------------------------
    // For TreeView Drag & Drop
    FCurrentNode: TTreeNode;
    CurrentPos: Char;
    GhostNode: TTreeNode;

    //Key Map
    FKeyBdShiftState: TShiftState;
    FTempState: integer;
    FControlPressed: Boolean;
    FControlPressedManualTV: Boolean;
    FParamSearchMode: Boolean;//Parameter Treeview searchmode

    //FIPCServer: TIPCServer;
    FCurrentSortMethod: TParamSortMethod;
    FCurrentManualSortMethod: TManualSortMethod;
    FSelectedTile: TAdvSmoothTileList;
    //FMonitorList: TStringList;
    //FApplicationList: TStringList;

    FStatusText: string;
    FKillProcessList: TKillProcessList;
    FPM: TParameterManager;

    //FIsProjectClosed: Boolean; //True = Project Close 상태

    procedure PanelMsgProc(var Msg: TMessage);
    procedure MDIClientProc(var Msg: TMessage);
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure MoveNode(ATreeView: TTreeView; ATargetNode, ASourceNode: TTreeNode);
//---------------------------------------------
    procedure CreateProc;
    procedure DestroyProc(AFreePrjFile: Boolean=true);
    procedure DoTile(TileMode: TTileMode);
    procedure CreateExtMDIChild(const AWindowTitle: string);
    function ReparentWindowForWindow(const WindowTitle: string): THandle;
    procedure ReparentWindow(AHandle: HWND);
    procedure CloseExtMDIChild;

    procedure PackageLoad_MDIChild;
    procedure LoadEngineInfo(AFileName:string; AIsEncrypt: Boolean; AIsAdd2Combo: Boolean = True; AIs2Inspector: Boolean = False);
    procedure SetEngineInfo2Inspector(AIndex: integer; AIsAdd2Combo: Boolean=false);
    procedure SaveEngineInfo(AFileName:string; AIsEncrypt: Boolean);
    procedure LoadProjectInfo(AFileName:string; AIsEncrypt: Boolean);
    procedure SaveProjectInfo(AFileName:string; AIsEncrypt: Boolean);

    procedure CreateChildFormAll;
    function CreateOrShowChildFormFromBpl(Aform: string; var AIndex: integer):Boolean;
    function CreateOrShowMDIChild(AForm: TFormClass): TForm;
    function CreateDummyMDIChild(AClientHandle: integer = -1): TForm;
    function CreateMIDChild(AForm: TFormClass; const Args: string): TForm;
    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
    procedure NxButtonItemButtonClick(Sender: TNxPropertyItem);

    procedure LoadMenuFromFile(AFileName: string; AIsUseLevel: Boolean);
    procedure SetHiMECSMainMenu(AMenuBase: TMenuBase);
    function InsertMenuItem(AMenu: TMenuItem; AInsertIndex: Integer; ANested: string;
      AOnClick: TNotifyEvent = nil; Action: TContainedAction = nil;
      AShortCut: TShortCut = 0): TMenuItem;
    procedure SetControlEvent(AControl: TControl; AInsertIndex: integer; AEvent: string);
    procedure SetMenuImageIndex(AMenuItem: TMenuItem; AInsertIndex: integer);

    procedure AddDefaultData2File(AFileName: string);
    procedure LoadConfigCollect2Form(AForm: TConfigF);
    procedure LoadConfigForm2Collect(AForm: TConfigF);
    procedure LoadConfigCollectFromFile(AIndex: integer);

    procedure LoadParameterList2TV(ASortMethod: TParamSortMethod);
    procedure LoadParameter2TreeView(AFileName:string;
      ASortMethod: TParamSortMethod; ARootNode: TTreeNode = nil; AIndex: integer = -1);
    procedure LoadParameter2SystemTV(ARoot: TTreeNode; AParam: TEngineParameter);
    procedure LoadParameter2SensorTV(ARoot: TTreeNode; AParam: TEngineParameter);
    procedure SaveParamTV2File(AFileName:string; AIsEncrypt: Boolean);
    procedure LoadSearchTreeFromEngParam(ASearchText: string; ASortMethod: TParamSortMethod);

    procedure LoadManualInfo2TV(ASortMethod: TManualSortMethod = msmMSNo);
    procedure LoadManualInfo2TreeView(AFileName:string;
      ASortMethod: TManualSortMethod; ARootNode: TTreeNode = nil; AIndex: integer = -1);
    procedure LoadManualInfo2MsNoTV(ARoot: TTreeNode; AManualInfo: THiMECSManualInfo);
    procedure LoadManualInfo2PlateNoTV(ARoot: TTreeNode; AManualInfo: THiMECSManualInfo);
    procedure LoadSearchTreeFromManualInfo(ASearchText: string; ASortMethod: TManualSortMethod=msmMSNo);

    procedure ParameterItem2ParamList(ANode: TTreeNode; AForm: TForm);

    procedure PackageLoad_Exe; //사용하지 않음 나중에 재확인 할것
    function AddExeToList(APackageName:string): Boolean;
//    procedure SendEPCopyData(ToHandle: integer; AEP:TEngineParameterItemRecord);
    procedure SendAlarmCopyData(ToHandle: integer; AEP:TEngineParameterItemRecord);
    procedure SendUserLevelCopyData(ToHandle: integer; AUserLevel:THiMECSUserLevel);

    procedure DisplayMessage(AMessage: string; ASaveType: TMessageSaveType;
                            AMessageType: TMessageType);
    procedure SaveMsg2File(AMessage: string; AMessaggeType: TMessageType);

    procedure DoConfigChange;

    procedure OnSendData2Watch(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnProcessKill(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    //procedure MoveEngineParameterItemRecord(var ASourceRecord: TEngineParameterItemRecord;
    //                         AEPItemRecord:TEngineParameterItem);
    procedure MoveMatrixData2ItemRecord(var ARecord: TEngineParameterItemRecord;
                             AEPItem:TEngineParameterItem);
    procedure SendEngParam2HandleWindow(AEPItemRecord: TEngineParameterItem;
                    ADestHandle: Integer = -1);
    procedure CopyParameter2AllMonitor;

    procedure LoadWatchListAll;
    function ExecLaunchList(AProgName, AParam: string): THandle;//; AHandles: TpjhArrayHandle);
    function CheckWatchListOfSummary(AFileName: string): Boolean;
    procedure Add2MultiNode(ANode: TTreeNode; AIsForWatch: Boolean;
      AAddSibling: boolean; ADestHandle: integer = -1; AForm: TForm = nil);
    procedure Add2AlarmList(ANode: TTreeNode; AAddSibling: boolean=false);
    procedure Add2WatchSave(ANode: TTreeNode; AAddSibling: boolean=false);
    procedure Add2xxxList(ANode: TTreeNode; var AHandle: THandle;
                      AHandleArray: TpjhArrayHandle; AExeName: String;
                      AAddSibling: boolean=false);
    procedure ApplyChangedProjectItem;
    function ProcessInputParameter(var AUserID, APasswd, APrjFileName: string):Boolean;
    procedure OnExecuteRequest(const Request, Response: IIPCData);

    procedure TileConfig(ATile: TAdvSmoothTileList);
    procedure LoadTileConfig2Form(AConfigF: TTileConfigF; AType: integer);
    procedure LoadTileConfigForm2Collect(AConfigF: TTileConfigF; AType: integer);
    procedure TileConfigChange(AType: integer);
    procedure SetConfigAutoRunTile(ATile: TAdvSmoothTile);
    procedure SetConfigMonitorTile(ATile: TAdvSmoothTile);
    procedure ShowWindowFromSelectedTile;

    procedure LoadKillProcess;
    procedure ExecProcessKill;
  public
    procedure ApplyConfigChange;
    procedure SetEngineType(AType: string);
    procedure AddCategory2ParamTV(Node: TTreeNode; ASubNode: boolean);
    procedure AddItem2ParamTV(Node: TTreeNode);
    function CopyItem2EngineParamCollect(Node: TTreeNode): integer;
    procedure UpdateProgress4Splash(Percentage: integer);
    function LoginProcess(AAutoLogin: Boolean = false; AUserId: string = '';
      APasswd: string = ''): Boolean; //Login 성공시 true
    function LoadUserFileName(AFileName, AUserId, APasswd: string): Boolean;
    function CheckUserFromUserFile(AUserID, APasswd, AUserFileName: string): Boolean;
    procedure Init(AAutoStart: Boolean = False; AFirstStart: Boolean = True);
    procedure PackageLoadFromMenu;
    function SelectProject(AProjectFileName: string=''): Boolean;
    function SubProcessSelectProject(AFileName: string): Boolean;
    function SelectUserFile: Boolean;

    procedure LoadAutoRunList;
    procedure LoadAutoRunTileFromFile(AFileName: string; AIsAppend: Boolean;
      AAutoRunList: TAutoRunList);
    procedure LoadAutoRunVar2Form(ATile: TAdvSmoothTile; AVar: TAutoRunItem);
    procedure LoadAutoRunConfigForm2Var(AForm: TnewCommApp_Frm; AVar: TAutoRunItem);
    procedure LoadAutoRunVar2ConfigForm(AForm: TnewCommApp_Frm; AVar: TAutoRunItem);
    procedure LoadAutoRun(AVar: TAutoRunItem);
    procedure ExecuteAutoRunList(AAutoRunList: TAutoRunList;
      AIsAll: Boolean=true; AIsAuto: Boolean=true; AIsSelected: Boolean=true);
    procedure ExecuteSelectedTile(ATile: TAdvSmoothTileList);
    procedure ShowWindowFromSelectedCommTile(AWinMsgAction: integer;AAutoRunItem: TAutoRunItem = nil);
    procedure SetAutoRunList2Inspector(AIndex: integer);

    procedure LoadMonitorFormList;
    procedure LoadMonitorTileFromFile(AFileName: string; AIsAppend: Boolean;
      AHiMECSMonitorList: THiMECSMonitorList);
    procedure LoadMonitorVar2Form(ATile: TAdvSmoothTile; AVar: THiMECSMonitorListItem);
    procedure LoadMonitorConfigForm2Var(AForm: TnewMonApp_Frm; AVar: THiMECSMonitorListItem);
    procedure LoadMonitorVar2ConfigForm(AForm: TnewMonApp_Frm; AVar: THiMECSMonitorListItem);
    procedure LoadMonitor(AVar: THiMECSMonitorListItem);
    procedure ExecuteMonitorList(AHiMECSMonitorList: THiMECSMonitorList;
      AIsAll: Boolean=true; AIsAuto: Boolean=true; AIsSelected: Boolean=true);
    procedure ShowWindowFromSelectedMonTile(AWinMsgAction: integer; AMonItem: THiMECSMonitorListItem = nil);

    procedure SetMonWindow2Top;
    function DoExternalUpdate(AFileName: string; ACheckOnly: Boolean = False): Boolean;
  published  //SetMethod 함수는 publisthed에 선언된 함수만 가능함
    procedure SetConfigData(Sender: TObject);
    function SetConfigEngParamItemData(AEPItem:TEngineParameterItem; AIdx: integer): Boolean;
    procedure ExecApplication(Sender: TObject);
    procedure ExecBpl(Sender: TObject);
    procedure RunCommunicationManager(Sender: TObject);
    procedure LogOutProcess;
    procedure ProgramExit;
    procedure LoginClick;
    procedure SaveAsConfigData;  //.option save
    function GetCurrentOptionIndex(ANode:TTreeNode): integer;
    function GetEngineType(AIndex: integer): string;
    function ProcessSelectProject(AFirstLoad: Boolean;
      AAutoStart: Boolean = False; APrjFileName: string=''): Boolean;
    procedure OpenProject;
    procedure CloseProject(AFreePrjFile: Boolean=true);
    function DoUpdateVersion(ACheckOnly: Boolean = False): Boolean;
    procedure EditProcessKillList;
  end;

var
  MainForm: TMainForm;

implementation

uses JvgXMLSerializer_Encrypt, CommonUtil, UnitParamList, EngineConst, UnitLogin,
      UnitSelectProject, jclNTFS, UnitDummyForm, BaseConfigCollect, UnitPdfView,
      SynCommons, PdfiumCore, UnitEngineBaseClassUtil;

{$R *.dfm}

procedure SetNodeImages(Node : TTreeNode; HasChildren : boolean);
begin
  if HasChildren then begin
    Node.HasChildren    := true;
    Node.ImageIndex     := cClosedBook;
    Node.SelectedIndex  := cOpenBook;
  end else begin
    Node.ImageIndex     := cClosedPage;
    Node.SelectedIndex  := cOpenPage;
  end; {if}
end; {SetNodeImages}

procedure TMainForm.CallapseAll1Click(Sender: TObject);
begin
  EngineInfoInspector.CollapseAll;
end;

procedure TMainForm.CallapseAll2Click(Sender: TObject);
begin
  JvCheckTreeView1.FullCollapse;
end;

procedure TMainForm.Cascade1Click(Sender: TObject);
begin
  if (FormStyle = fsMDIForm) and (ClientHandle <> 0) then
    SendMessage(ClientHandle, WM_MDICASCADE, 0, 0);
end;

function TMainForm.CheckUserFromUserFile(AUserID, APasswd,
  AUserFileName: string): Boolean;
var
  i: integer;
  LUser: THiMECSUser;
begin
  Result := False;

  LUser := THiMECSUser.Create(nil);
  try
    SetCurrentDir(ExtractFilePath(Application.ExeName));

    LUser.LoadFromFile(AUserFileName,
                          ExtractFileName(AUserFileName),
                          True);

    for i := 0 to LUser.HiMECSUserCollect.Count - 1 do
    begin
      if (LUser.HiMECSUserCollect.Items[i].UserID = AUserID) and
        (LUser.HiMECSUserCollect.Items[i].Password = APasswd) then
      begin
        Result := True;
        Break;
      end
    end;//for

  finally
    LUser.Free;
  end;
end;

//AFileName의 Summary Information.Template = FProjectFile.ProjectFileName 이면 True
function TMainForm.CheckWatchListOfSummary(AFileName: string): Boolean;
var
  LFS: TJclFileSummary;
  LFSI: TJclFileSummaryInformation;
begin
  Result := False;

  LFS:= TJclFileSummary.Create(AFileName, fsaRead, fssDenyAll);
  try
    LFS.GetPropertySet(TJclFileSummaryInformation, LFSI);
    if Assigned(LFSI) then
    begin
                       //상대경로임
      if LFSI.Template = FProjectFile.ProjectFileName then
      begin
        Result := True;
      end;
    end;
  finally
    FreeAndNil(LFSI);
    LFS.Free;
  end;
end;

procedure TMainForm.ChildFormClose(Sender: TObject; var Action: TCloseAction);
begin
//  AdvToolBar1.RemoveMDIChildMenu(TForm(Sender));
  Action   := caFree;
end;

procedure TMainForm.Clearallparameter1Click(Sender: TObject);
begin
  JvCheckTreeView1.Items.Clear;
  JvCheckTreeView1.Items.AddChild(nil, 'Parameter');
end;

procedure TMainForm.CloseExtMDIChild;
var
  I: Integer;
  AHandle: HWND;
  LProcessID, LWndProcess: Cardinal;
begin
  for I := Low(FWindowList) to High(FWindowList) do
  begin
    AHandle := FWindowList[I];
    if Windows.IsWindow(AHandle) then
    begin
      //GetWindowThreadProcessId(AHandle, LProcessID);
      Windows.SendMessage(AHandle, WM_CLOSE, 0, 0);
      Windows.SendMessage(AHandle, WM_QUIT, 0, 0);
      WaitForInputIdle(LWndProcess, INFINITE);
      //CloseHandle(LWndProcess); // Leaks calc.exe somehow???
    end;
  end;

  for i := 0 to MDIChildCount - 1 do
    MDIChildren[i].Close;
end;

procedure TMainForm.CloseProject(AFreePrjFile: Boolean);
begin
{  if FIsProjectClosed then
  begin
    ShowMessage('There is no opened project.');
    exit;
  end
  else
    FIsProjectClosed := True;
}
  if AFreePrjFile then
    if Dialogs.MessageDlg('Are you sure to close project?' +#13#10,
        mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then
      exit;

  DestroyProc(AFreePrjFile);

  NxTextItem1.Clear;
  NxTextItem2.Clear;
  NxTextItem3.Clear;
  NxTextItem4.Clear;
  ComponentsNxItem.Clear;

  JvCheckTreeView1.Items.Clear;
  EngineInfoInspector.PopupMenu := nil;
  JvCheckTreeView1.PopupMenu := nil;
  MonTileListFrame.tileList.Tiles.Clear;
  CommTileListFrame.tileList.Tiles.Clear;

  SetCurrentDir(FApplicationPath);
  LoadMenuFromFile(DefaultMenuFileNameOnLogIn, True);
end;

function TMainForm.CopyItem2EngineParamCollect(Node: TTreeNode): integer;
var
  AEPItemRecord: TEngineParameterItem;
  LEngineParameterItem: TEngineParameterItem;
  LHiMECSConfig: THiMECSConfig;
begin
  Result := -1;
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
  AEPItemRecord := TEngineParameterItem(Node.Data);

  //FEngineParameter.EngineParameterCollect.AddEngineParameterItem(AEPItemRecord);
  LEngineParameterItem :=
    LHiMECSConfig.EngineParameter.EngineParameterCollect.AddEngineParameterItem(AEPItemRecord);
  Result := LEngineParameterItem.Index;
end;

procedure TMainForm.CopyParameter2AllMonitor;
var
  i,j: integer;
  LHiMECSMonitorList: THiMECSMonitorList;
  LHandle: THandle;
begin
  FParamCopyMode := Ord(dcmCopyOnlyExist);
  FEngineParameterItemRecord.FParamDragCopyMode := dcmCopyOnlyExist;
  try
    for i := Low(FWatchHandles) to High(FWatchHandles) do
    begin
      SendMessage(FWatchHandles[i], WM_MULTICOPY_BEGIN, 0, 0);
      Add2MultiNode(FCurrentNode, False, False, FWatchHandles[i]);
      SendMessage(FWatchHandles[i], WM_MULTICOPY_END, 0, 0);
    end;

    for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
    begin
      LHiMECSMonitorList := FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor;

      for j := 0 to LHiMECSMonitorList.MonitorListCollect.Count - 1 do
      begin
        LHandle := LHiMECSMonitorList.MonitorListCollect.Items[j].AppHandle;
        SendMessage(LHandle, WM_MULTICOPY_BEGIN, 0, 0);
        Add2MultiNode(FCurrentNode, False, False, LHandle);
        SendMessage(LHandle, WM_MULTICOPY_END, 0, 0);
      end;
    end;
  finally
    FParamCopyMode := Ord(dcmCopyCancel);
    FEngineParameterItemRecord.FParamDragCopyMode := dcmCopyCancel;
  end;
end;

procedure TMainForm.CopyParameterToMonitor1Click(Sender: TObject);
begin
  CopyParameter2AllMonitor;
end;

procedure TMainForm.CreateCategory1Click(Sender: TObject);
begin
  if JvCheckTreeView1.Selected <> nil then
    AddCategory2ParamTV(JvCheckTreeView1.Selected, False);
end;

procedure TMainForm.CreateChildFormAll;
var
  i: Integer;
begin
  for i := 0 to FHiMECSForms.PackageCollect.Count - 1 do
  begin
    if Assigned(FCreateChildFromBPL[i]) then
      FCreateChildFromBPL[i];
  end;
  //if Assigned(FCreateEngineInfo) then
  //  FCreateEngineInfo;
end;

function TMainForm.CreateDummyMDIChild(AClientHandle: integer): TForm;
var
  i: integer;
  bCreated: Bool;
  LTabItem: TOfficeTabCollectionItem;
begin
  bCreated := False;
  Result := nil;

  if not bCreated then
  begin
    Result := TDummyForm.Create(Self);
    TDummyForm(Result).FMainFormHandle := Self.Handle;
    //TDummyForm(Result).Caption := IntToStr(AClientHandle);
    //TDummyForm(Result).FClientFormHandle := ;
//    AdvToolBar1.AddMDIChildMenu(Result);
    Result.OnClose := ChildFormClose;
    LTabItem := AdvOfficeMDITabSet1.AddTab(Result);
    LTabItem.Tag := AClientHandle;//Result.Handle;
    //Memo1.Lines.Add(IntToStr(AClientHandle)+#13#10);
    ShowWindow(Result.Handle, SW_HIDE);
    //Result.Hide;
  end;
end;

procedure TMainForm.CreateExtMDIChild(const AWindowTitle: string);
var
  LHandle: THandle;
begin
  LHandle := ReparentWindowForWindow(AWindowTitle);
  if LHandle = 0 then
  begin
    ShowMessage('Error create mdi child form');
  end;
end;

function TMainForm.CreateMIDChild(AForm: TFormClass;
  const Args: string): TForm;
begin
  Result := AForm.Create(Application);
  SendCopyData2(Result.Handle, Args, 0);

//  AdvToolBar1.AddMDIChildMenu(Result);
  Result.OnClose := ChildFormClose;
  AdvOfficeMDITabSet1.AddTab(Result);
  Result.Show;
end;

procedure TMainForm.CommTileListFrametileListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSelectedTile := CommTileListFrame.TileList;
end;

procedure TMainForm.CommTileListFrametileListTileDblClick(Sender: TObject;
  ATile: TAdvSmoothTile; State: TTileState);
begin
  ShowWindowFromSelectedCommTile(SW_RESTORE);
end;

procedure TMainForm.CopyItem1Click(Sender: TObject);
begin
  if (JvCheckTreeView1.Selected <> nil)
                          and Assigned(JvCheckTreeView1.Selected.Data) then
    AddItem2ParamTV(JvCheckTreeView1.Selected);
end;

procedure TMainForm.DeleteItem1Click(Sender: TObject);
begin
  if Dialogs.MessageDlg(JvCheckTreeView1.Selected.Text + ' 를 지우시겠습니까? ' +#13#10,
    mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
    JvCheckTreeView1.Selected.DeleteChildren;
    JvCheckTreeView1.Selected.Delete;
  end;
end;

procedure TMainForm.DisplayMessage(AMessage: string;
  ASaveType: TMessageSaveType; AMessageType: TMessageType);
begin
  case ASaveType of
    mstNoSave:;
    mstFile: SaveMsg2File(AMessage, AMessageType);
    mstDB:;
  end;
end;

function TMainForm.ExecLaunchList(AProgName, AParam: string): THandle;
//  AHandles: TpjhArrayHandle);
var
  LProcessID: THandle;
begin
  LProcessId := ExecNewProcess2(AProgName, AParam);
  Result := DSiGetProcessWindow(LProcessId);
  CreateDummyMDIChild(LProcessId);
  SendUserLevelCopyData(Result,FCurrentUserLevel);

  //SetLength(FMonitorHandles, Length(AHandles)+1);
  //AHandles[High(FMonitorHandles)] := LHandle;
end;

procedure TMainForm.DoConfigChange;
var
  cnt : integer;
  icc : IConfigChanged;
begin
  if FKillProcessList.KillProcTimerHandle > -1 then
    FPJHTimerPool.Remove(FKillProcessList.KillProcTimerHandle);

  LoadKillProcess;

  for cnt := 0 to -1 + Screen.FormCount do
  begin
    if Supports(Screen.Forms[cnt], IConfigChanged, icc) then
      icc.ApplyConfigChange;
  end;
end;
function TMainForm.DoExternalUpdate(AFileName: string;  ACheckOnly: Boolean): Boolean;
var
  LHandle,LProcessID: THandle;
begin
  //Result: Update가 존재하여 실행했으면 True
  if not FileExists(AFileName) then
  begin
    exit;
  end;

  SetCurrentDir(ExtractFilePath(Application.ExeName));
  LProcessId := ExecNewProcess2(HiMECSAutoUpdateName, AFileName);
  LHandle := DSiGetProcessWindow(LProcessId);
end;

procedure TMainForm.DoTile(TileMode: TTileMode);
const
  TileParams: array[TTileMode] of Word = (MDITILE_HORIZONTAL, MDITILE_VERTICAL);
var
  LForm: TForm;
begin
  LForm := MainForm;
  if (LForm.FormStyle = fsMDIForm) and (LForm.ClientHandle <> 0) then
    SendMessage(LForm.ClientHandle, WM_MDITILE, TileParams[TileMode], 0);
end;

procedure TMainForm.DropTextTarget1DragOver(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  TreeNode: TTreeNode;
begin
  TreeNode := JvCheckTreeView1.GetNodeAt(APoint.X, APoint.Y);

  if (TreeNode <> nil) then
  begin
    // Select the item to provide visual feedback
    TreeNode.Selected := True;
    // Override the default drop effect if you need to:
    //Effect := DROPEFFECT_COPY;
  end else
    // Reject the drop
    Effect := DROPEFFECT_NONE;
end;

procedure TMainForm.DropTextTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  DFP: RDragFormatParam;
  TreeNode, TreeNode2: TTreeNode;
  LStr, LStr2: string;
  Li: integer;
  LHiMECSConfig: THiMECSConfig;
begin
  TreeNode := JvCheckTreeView1.GetNodeAt(APoint.X, APoint.Y);

  if (TreeNode <> nil) then
  begin
    // Determine if we got our custom format.
    if (FDragFormatTarget.HasData) then
    begin
      LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
      // Extract the dropped data into our custom struct.
      FDragFormatTarget.GetDataHere(DFP, sizeof(DFP));
      LStr2 := DFP.FCollectIndex;

      while True do
      begin
        LStr := strToken(LStr2,',');
        if LStr = '' then
          break;
        Li := StrToInt(LStr);
        TreeNode2 := JvCheckTreeView1.Items.AddChild(TreeNode,
          LHiMECSConfig.EngineParameter.EngineParameterCollect.Items[Li].Description);
                //FEngineParameter.EngineParameterCollect.Items[Li].Description);
      end;
      //ShowMessage(DFP.FCollectIndex);
      // Display the data.
    end
    else
      ShowMessage(TDropTextTarget(Sender).Text);
  end;
end;

procedure TMainForm.ExecApplication(Sender: TObject);
var
  i: integer;
  LStr: string;
  LHiMECSConfig: THiMECSConfig;
  LProcessId, LHandle: Integer;
begin
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
  i := TMenuItem(Sender).Tag;
  LStr := FMenuBase.HiMECSMenuCollect.Items[i].DLLName;
  LStr := IncludeTrailingPathDelimiter(LHiMECSConfig.ExesPath) + LStr;
  LProcessId := ExecNewProcess2(LStr, ExtractFilePath(LStr));
  LHandle := DSiGetProcessWindow(LProcessId);

  if LHiMECSConfig.ExtAppInMDI then
  begin
    CreateDummyMDIChild(LProcessId);
    LStr := FMenuBase.HiMECSMenuCollect.Items[i].Caption;
    CreateExtMDIChild(LStr);
  end;
end;

procedure TMainForm.ExecBpl(Sender: TObject);
var
  i: integer;
  LStr: string;
  LHiMECSConfig: THiMECSConfig;
begin
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
  i := TMenuItem(Sender).Tag;
  LStr := FMenuBase.HiMECSMenuCollect.Items[i].DLLName;

  if pos('BPL', Uppercase(ExtractFileExt(LStr))) <> 0 then
  begin
    LStr := IncludeTrailingPathDelimiter(LHiMECSConfig.BplsPath) + LStr;

    if FileExists(LStr) then
    begin
      //ExecNewProcess2(LStr, ExtractFilePath(LStr));
    end;
  end;

{  if FHiMECSConfig.ExtAppInMDI then
  begin
    LStr := FMenuBase.HiMECSMenuCollect.Items[i].Caption;
    CreateExtMDIChild(LStr);
  end;
  }
end;

procedure TMainForm.ExecuteAutoRunList(AAutoRunList: TAutoRunList; AIsAll,
  AIsAuto, AIsSelected: Boolean);
var
  i: integer;
  LHandle,LProcessID: THandle;
  LAutoRunItem: TAutoRunItem;
begin
  SetCurrentDir(FApplicationPath);

  for i := 0 to AAutoRunList.AutoRunCollect.Count - 1 do
  begin
    if not AIsAll then
    begin
      if AIsAuto then
      begin
        if not AAutoRunList.AutoRunCollect.Items[i].IsAutoRun then
          continue;
      end
      else
      begin
        if AIsSelected then
        begin
          LAutoRunItem := CommTileListFrame.tileList.SelectedTile.ItemOject as TAutoRunItem;
          LoadAutoRun(LAutoRunItem);
          exit;
        end
        else
        if AAutoRunList.AutoRunCollect.Items[i].IsAutoRun then
          continue;
      end;
    end;

//두개의 프로젝트 동시에 열때 실행옵션(External Execute)이 같은 경우 첫번째 runparameter만 실행 됨
//    LAutoRunItem := CommTileListFrame.tileList.Tiles.Items[i].ItemOject as TAutoRunItem;
    LAutoRunItem := AAutoRunList.AutoRunCollect.Items[i];
    LoadAutoRun(LAutoRunItem);
  end;
end;

procedure TMainForm.ExecuteMonitorList(AHiMECSMonitorList: THiMECSMonitorList;
  AIsAll, AIsAuto, AIsSelected: Boolean);
var
  i: integer;
  LHandle,LProcessID: THandle;
  LAutoRunItem: THiMECSMonitorListItem;
begin
  SetCurrentDir(FApplicationPath);

  for i := 0 to AHiMECSMonitorList.MonitorListCollect.Count - 1 do
  begin
    if not AIsAll then
    begin
      if AIsAuto then
      begin
        if not AHiMECSMonitorList.MonitorListCollect.Items[i].IsAutoLoad then
          continue;
      end
      else
      begin
        if AIsSelected then
        begin
          LAutoRunItem := MonTileListFrame.tileList.SelectedTile.ItemOject as THiMECSMonitorListItem;
          LoadMonitor(LAutoRunItem);
          exit;
        end
        else
        if AHiMECSMonitorList.MonitorListCollect.Items[i].IsAutoLoad then
          continue;
      end;
    end;

//두개의 프로젝트 동시에 열때 실행옵션(External Execute)이 같은 경우 첫번째 runparameter만 실행 됨
//    LAutoRunItem := MonTileListFrame.tileList.Tiles.Items[i].ItemOject as THiMECSMonitorListItem;
    LAutoRunItem := AHiMECSMonitorList.MonitorListCollect.Items[i];
    LoadMonitor(LAutoRunItem);
  end;
end;

procedure TMainForm.ExecuteSelectedTile(ATile: TAdvSmoothTileList);
begin
//  SetCurrentDir(FApplicationPath+'Applications');
  if ATile.Tag = 1 then
    ExecuteMonitorList(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSMonitor, False, False, True)
  else
  if ATile.Tag = 2 then
    ExecuteAutoRunList(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSAutoRun, False, False, True);
//  SetCurrentDir(FApplicationPath);
end;

procedure TMainForm.ExecuteSelectedTile1Click(Sender: TObject);
begin
  ExecuteSelectedTile(FSelectedTile);
end;

procedure TMainForm.ExpandAll1Click(Sender: TObject);
begin
  EngineInfoInspector.ExpandAll;
end;

procedure TMainForm.ExpandAll2Click(Sender: TObject);
begin
  JvCheckTreeView1.FullExpand;

end;

procedure TMainForm.DestroyProc(AFreePrjFile: Boolean);
var
  i,j: integer;
  LModule: HModule;
  LHiMECSConfig: THiMECSConfig;
begin
  SelectEngineCombo.Lines.Clear;// := '';
  SelectEngineCombo.Value := '';

  CloseExtMDIChild;

  if Assigned(FKillProcessList) then
    FreeAndNil(FKillProcessList);

  if not Assigned(FPJHTimerPool) then //이거 주석처리 하면 처음 시작시 AV 발생함
    exit;

  if Assigned(FPJHTimerPool) then
  begin
    FPJHTimerPool.RemoveAll;
    FreeAndNil(FPJHTimerPool);
  end;

  if Assigned(FPackageModules) then
  begin
    for i := Low(FPackageModules) to High(FPackageModules) do
      if FPackageModules[i] <> 0 then
        UnloadPackage(FPackageModules[i]);

    FPackageModules := nil;
  end;

  FCreateChildFromBPL := nil;

  for i := Low(FWatchHandles) to High(FWatchHandles) do
    SendMessage(FWatchHandles[i], WM_CLOSE, 0, 0);

  //for i := Low(FAutoRunHandles) to High(FAutoRunHandles) do
  //  SendMessage(FAutoRunHandles[i], WM_CLOSE, 0, 0);

  //for i := Low(FMonitorHandles) to High(FMonitorHandles) do
  //  SendMessage(FMonitorHandles[i], WM_CLOSE, 0, 0);

  for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
  begin
    if Assigned(FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor) then
    begin
      if FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig.UseMonLauncher then
        PostMessage(FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor.LauncherHandle,
          WM_CLOSE, 0, 0)
      else
        for j := 0 to FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor.MonitorListCollect.Count - 1 do
          PostMessage(FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor.MonitorListCollect.Items[j].AppHandle,
            WM_CLOSE, 0, 0);
    end;

    if Assigned(FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun) then
    begin
      if FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig.UseCommLauncher then
        PostMessage(FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun.LauncherHandle,
          WM_CLOSE, 0, 0)
      else
        for j := 0 to FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun.AutoRunCollect.Count - 1 do
          SendMessage(FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun.AutoRunCollect.Items[j].AppHandle,
            WM_CLOSE, 0, 0);
    end;

    LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig;

    if Assigned(LHiMECSConfig.EngineParameter) then
      LHiMECSConfig.EngineParameter.Free;

    if Assigned(LHiMECSConfig.ProjectInfo) then
      LHiMECSConfig.ProjectInfo.Free;

    if Assigned(LHiMECSConfig.EngineInfo) then
      LHiMECSConfig.EngineInfo.Free;

    LHiMECSConfig.Free;

    //Close 실패한 Process를 다시한번 강제 종료함
    if Assigned(FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor) then
    begin
      Sleep(50);

      if Assigned(FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor) then
      begin
        if not FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig.UseMonLauncher then
          for j := 0 to FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor.MonitorListCollect.Count - 1 do
            KillProcessId(FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor.MonitorListCollect.Items[j].AppProcessId);
      end;

      FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor.Free;
    end;

    if Assigned(FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun) then
    begin
      Sleep(50);

      if not FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig.UseCommLauncher then
        for j := 0 to FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun.AutoRunCollect.Count - 1 do
          KillProcessId(FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun.AutoRunCollect.Items[j].AppProcessId);

      FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun.Free;
    end;
  end;

  FWatchHandles := nil;
  //FAutoRunHandles := nil;
  //FMonitorHandles := nil;

  if Assigned(FHiMECSExes) then
    FreeAndNil(FHiMECSExes);

  if Assigned(FPackageList_Exes) then
  begin
    for i := 0 to FPackageList_Exes.Count - 1 do
    begin
      LModule := HModule(FPackageList_Exes.Objects[i]);
      UnloadPackage(LModule);
    end;

    FreeAndNil(FPackageList_Exes);
  end;

  if Assigned(FDragFormatTarget) then
    FreeAndNil(FDragFormatTarget);

  if Assigned(FEngParamSource) then
    FreeAndNil(FEngParamSource);

  if Assigned(FHiMECSForms) then
    FreeAndNil(FHiMECSForms);

  //if Assigned(FEngineInfoCollect) then
    //FreeAndNil(FEngineInfoCollect);

  //if Assigned(FEngineInfoList) then
  //begin
  //  for i := 0 to FEngineInfoList.Count - 1 do
  //  begin
  //    TICEngine(FEngineInfoList.Objects[i]).ICEngineCollect.Clear;
  //    TICEngine(FEngineInfoList.Objects[i]).Free;
  //  end;

  //  FreeAndNil(FEngineInfoList);
  //end;

  if Assigned(FProjectInfoCollect) then
    FreeAndNil(FProjectInfoCollect);

  //if Assigned(FEngineParameter) then
    //FreeAndNil(FEngineParameter);

  if Assigned(FSearchParamList) then
  begin
    for i := 0 to FSearchParamList.Count - 1 do
    begin
      TEngineParameter(FSearchParamList.Objects[i]).EngineParameterCollect.Clear;
      TEngineParameter(FSearchParamList.Objects[i]).Free;
    end;

    FreeAndNil(FSearchParamList);
  end;

{  if Assigned(FEngineParameterList) then
  begin
    for i := 0 to FEngineParameterList.Count - 1 do
    begin
      TEngineParameter(FEngineParameterList.Objects[i]).EngineParameterCollect.Clear;
      TEngineParameter(FEngineParameterList.Objects[i]).Free;
    end;

    FreeAndNil(FEngineParameterList);
  end;
}
  if AFreePrjFile then
    if Assigned(FProjectFile) then
      FreeAndNil(FProjectFile);

  //if Assigned(FHiMECSOptions) then
    //FreeAndNil(FHiMECSOptions);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  LAutoStart: Boolean;
begin
  if not TRegistrationF.IsRegistrationValid(FRegInfo) then
  begin
    ShowMessage('Product is not registered!');
    TerminateProcess(GetCurrentProcess, 0);
//    Halt(0);
  end;

  LAutoStart := ParamCount > 1;

{  FIPCServer := TIPCServer.Create;
  FIPCServer.OnExecuteRequest := OnExecuteRequest;
  FIPCServer.ServerName := HIMECS_CROMIS_SERVER_NAME;
  FIPCServer.Start;
}
  FPM := TParameterManager.Create;
  Init(LAutoStart,True);
  EngineInfoInspector.DoubleBuffered := False;
  FParamCopyMode := 0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FRegInfo.Free;
  FPM.Free;

  //FIPCServer.Stop;
  //FreeAndNil(FIPCServer);
  DestroyProc;
end;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  LDragRect: TRect;
  LPosition: TPoint;
begin
{  if FParameterDragMode then
  begin
    LPosition.x := x;
    LPosition.Y := y;

    GetWindowRect(JvCheckTreeView1.Handle, LDragRect);
    // Is position outside screen coordinates...
    if (not PtInRect(LDragRect, LPosition)) then
    begin
      Windows.GetClientRect(JvCheckTreeView1.Handle, LDragRect);
      // ... and inside client coordinates
      if not(PtInRect(LDragRect, LPosition)) then
      begin
        //if (not Windows.ClientToScreen(Handle, LPosition)) then
        //begin
            // Transfer the structure to the drop source data object and execute the drag.
            FEngParamSource.SetDataHere(FEP_DragDrop, sizeof(FEP_DragDrop));

            EngParamSource.Execute;
            FParameterDragMode := False;
        //end;
      end
      else
        FParameterDragMode := False;
    end
    else
      FParameterDragMode := False;
  end;
}
end;

//현재 선택된 ParameterItem의 Parameter Index 반환
//없으면 0 반환 함
function TMainForm.GetCurrentOptionIndex(
  ANode:TTreeNode): integer;
begin
  while ANode.Level > 0 do
    ANode := ANode.Parent;

  Result := ANode.Index;
end;

function TMainForm.GetEngineType(AIndex: integer): string;
var
  LHiMECSConfig: THiMECSConfig;
begin
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[AIndex].HiMECSConfig;
  Result := LHiMECSConfig.EngineInfo.GetEngineType;
end;

procedure TMainForm.HideAllMonitor1Click(Sender: TObject);
var
  i: integer;
  LAdvNavBarPanel: TAdvNavBarPanel;
  LMonItem: THiMECSMonitorListItem;
  LAutoRunItem: TAutoRunItem;
begin
  LAdvNavBarPanel := AdvNavBar1.Panels[AdvNavBar1.ActiveTabIndex];
  if LAdvNavBarPanel.Name = 'MonitoringPanel' then
  begin
    for i := 0 to MonTileListFrame.tileList.Tiles.Count - 1 do
    begin
      LMonItem := MonTileListFrame.tileList.Tiles[i].ItemOject as THiMECSMonitorListItem;
      ShowWindowFromSelectedMonTile(SW_MINIMIZE ,LMonItem);
    end;
  end
  else
  if LAdvNavBarPanel.Name = 'CommunicationPanel' then
  begin
    for i := 0 to CommTileListFrame.tileList.Tiles.Count - 1 do
    begin
      LAutoRunItem := CommTileListFrame.tileList.Tiles[i].ItemOject as TAutoRunItem;
      ShowWindowFromSelectedCommTile(SW_MINIMIZE, LAutoRunItem);
    end;
  end;
end;

procedure TMainForm.Horizontal1Click(Sender: TObject);
begin
  DoTile(tbHorizontal);
end;

procedure TMainForm.TileConfig2Click(Sender: TObject);
begin
  TileConfig(FSelectedTile);
end;

//AFirstStart: Logout 후 Login 시에 False
//           : 프로그램 처음 시작시에는 True
procedure TMainForm.Init(AAutoStart: Boolean = False; AFirstStart: Boolean = True);
var
  LPasswd, LUserId, LProjectFileName: string;
begin
  FApplicationPath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  SetCurrentDir(FApplicationPath);
  PDFiumDllDir := IncludeTrailingPathDelimiter(FApplicationPath) + 'Applications\';

  if not Assigned(FMenuBase) then
    FMenuBase := TMenuBase.Create(Self);

  if AAutoStart then
  begin
    //param으로 입력된 Id,Passwd,ProjectFileName을 LUserId,LPasswd 및 LProjectFileName에 가져옴
    ProcessInputParameter(LUserId, LPasswd, LProjectFileName);
  end;

  if not LoginProcess(AAutoStart,LUserId, LPasswd) then
  begin
    //FreeAndNil(FHiMECSConfig);
    FreeAndNil(FHiMECSUser);

    if AFirstStart then
      Halt(0)
    else
    begin
      LoadMenuFromFile(DefaultMenuFileNameOnLogOut, True);
      exit;
    end;
  end;

  ProcessSelectProject(AFirstStart, AAutoStart, LProjectFileName);
end;

function TMainForm.InsertMenuItem(AMenu: TMenuItem; AInsertIndex: Integer;
  ANested: string; AOnClick: TNotifyEvent; Action: TContainedAction;
  AShortCut: TShortCut): TMenuItem;
var
  LStr: string;
  LIndex: integer;
begin
  Result := nil;

  LStr := strToken(ANested, ',');
  LIndex := StrToInt(LStr);

  if ANested <> '' then
  begin
    Result := InsertMenuItem(AMenu.Items[LIndex], AInsertIndex, ANested);
  end
  else
  begin
    Result := TMenuItem.Create(Self);
    Result.Caption := FMenuBase.HiMECSMenuCollect.Items[AInsertIndex].Caption;
    Result.Hint := FMenuBase.HiMECSMenuCollect.Items[AInsertIndex].Hint;
    //Result.OnClick := AOnClick;
    Result.ShortCut := AShortCut;
    Result.Action := Action;
    //SetControlEvent를 위해 FMenuBase.HiMECSMenuCollect index를 저장함
    Result.Tag := AInsertIndex;

    SetControlEvent(TControl(Result), AInsertIndex,
        FMenuBase.HiMECSMenuCollect.Items[AInsertIndex].EventName);
    SetMenuImageIndex(Result, AInsertIndex);
    AMenu.Insert(LIndex, Result);
  end;
end;

procedure TMainForm.JvCheckTreeView1CustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  IRect: TRect;
  MColor, BColor: TColor;
begin
{  BColor := clWhite;
  MColor := clBlack;

  IRect := Node.DisplayRect(true);

  if Node = JvCheckTreeView1.Selected then
  begin
    BColor := clBlue;
    MColor := clWhite;
  end;

  JvCheckTreeView1.Canvas.Brush.Color := BColor;
  JvCheckTreeView1.Canvas.Font.Color := MColor;

  Sender.Canvas.TextOut(IRect.Left, IRect.Top, Node.Text);
}

{  with sender as TTreeView do
  begin
    DefaultDraw := true;

    if (cdsSelected in State) or (cdsFocused in state) or (cdsChecked in State) then
    begin
      //when the tree has focus
      Canvas.font.Color := clHighlightText;
      Canvas.Brush.Color := clHighlight;
    end else
    begin
      //all other times
      Canvas.font.Color := clBlack;
      Canvas.Brush.Color := clWhite;
      //this here will keep the selected item highlighted
      if Assigned(Node) then
        if Assigned(Selected) then
          if Node = Selected then
          begin
            Canvas.font.Color := clHighlightText;
            Canvas.Brush.Color := clHighlight;
          end;
    end;
  end;
}
end;

procedure TMainForm.JvCheckTreeView1DblClick(Sender: TObject);
var
  LNode: TTreeNode;
  LForm: TForm;
  i,j: integer;
begin
  LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );

  if FControlPressed then
  begin
    //if LNode.AbsoluteIndex = 0 then
    if Assigned(LNode) then
    begin
      LForm := CreateOrShowMDIChild(TFormParamList);
      if Assigned(LForm) then
      begin
        //TFormParamList(LForm).Parameter2Grid(TEngineParameter(FEngineParameterList.Objects[FCOI]));
        Add2MultiNode(LNode,False,False,-1,LForm);
      end;
    end
    else
    if Assigned(LNode) then
    begin
      if TObject(LNode.Data) is TEngineParameterItem then
      begin
        LForm := CreateOrShowMDIChild(TFormParamList);
        if Assigned(LForm) then
        begin
          ParameterItem2ParamList(LNode,LForm);
        end;
      end;
    end;

    FControlPressed := False;
  end
  else
    Property1Click(JvCheckTreeView1);
end;

procedure TMainForm.JvCheckTreeView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_delete: DeleteItem1Click(JvCheckTreeView1);
    vk_control: FControlPressed := True;
  end;
end;

procedure TMainForm.JvCheckTreeView1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_delete: DeleteItem1Click(JvCheckTreeView1);
    vk_control: FControlPressed := False;
  end;
end;

{
procedure TMainForm.JvCheckTreeView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  //Node: TTreeNode;
  //Expanded: Boolean;
  LTargetNode, LSourceNode: TTreeNode;
  i:integer;
begin
{  if FParameterDragMode then
    exit;

  if (Sender = JvCheckTreeView1) then
  begin
    with JvCheckTreeView1 do
    begin
      LTargetNode := GetNodeAt( X, Y ); //Get Target Node
      LSourceNode := Selected;

      if (LTargetNode = nil) or (LTargetNode = LSourceNode) then
      begin
        EndDrag(False);
        Exit;
      end;
    end;

    MoveNode(JvCheckTreeView1, LTargetNode, LSourceNode);
    LSourceNode.Free;
  end
  else if (Sender <> JvCheckTreeView1) then
  begin
    for i := 0 to MDIChildCount - 1 do
    begin
      if MDIChildren[i] is TFormParamList then
      begin
        ShowMessage(TFormParamList(MDIChildren[i]).NextGrid1.Caption);
        break;
      end;
    end;//for
  end;
}
{end;

procedure TMainForm.JvCheckTreeView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if FParameterDragMode then
    exit;
  //if (Sender = JvCheckTreeView1) then
  //begin
//    Accept := True;
  //end;
end;
}
procedure TMainForm.JvCheckTreeView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LNode: TTreeNode;
  LEngineParameterItem: TEngineParameterItem;
  LEPD: TEngineParameter_DragDrop;
begin
  FMouseClickParaTV_X := X;
  FMouseClickParaTV_Y := Y;

  LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );
  if Assigned(LNode) then
  begin
    FCurrentNode := LNode;

    if (DragDetectPlus(TWinControl(Sender).Handle, Point(X,Y))) then
    begin
      if TObject(LNode.Data) is TEngineParameterItem then
      begin
        if JvCheckTreeView1.SelectedCount = 1 then
        begin
          FParameterDragMode := True;

          LEngineParameterItem := TEngineParameterItem(LNode.Data);
          //LEngineParameterItem.AssignTo(FEngineParameterItemRecord);
          LEngineParameterItem.AssignTo(LEPD.FEPItem);
          //MoveMatrixData2ItemRecord(FEngineParameterItemRecord, LEngineParameterItem);
          MoveMatrixData2ItemRecord(LEPD.FEPItem, LEngineParameterItem);

          // Transfer the structure to the drop source data object and execute the drag.
          //SetLength(LDynArray, 1);//Length(FEngineParameterItemRecord));
          //Move(FEngineParameterItemRecord, LDynArray[Low(LDynArray)], SizeOf(FEngineParameterItemRecord));
          LEPD.FDragDataType := dddtSingleRecord;
          LEPD.FShiftState := Shift;//FKeyBdShiftState;
          FEngParamSource.EPD := LEPD;
          //FEngParamSource.DragDataType := dddtSingleRecord;
          EngParamSource.Execute;
        end
        else
        begin
          FParameterDragMode := True;
          //FEngParamSource.DragDataType := dddtMultiRecord;
          LEPD.FDragDataType := dddtMultiRecord;
          LEPD.FShiftState := Shift;//FKeyBdShiftState;
          FEngParamSource.EPD := LEPD;
          EngParamSource.Execute;
        end;
      end
      else
      begin
        //FArrayEngineParameterItemRecord에 데이터 저장
        //Add2MultiNode(LNode, False);
        //Clipbrd에 데이터 복사
        FParameterDragMode := True;
        LEPD.FSourceHandle := Handle;
        LEPD.FShiftState := Shift;//FKeyBdShiftState;
        LEPD.FDragDataType := dddtMultiRecord;
        FEngParamSource.EPD := LEPD;
//        FCurrentNode := LNode;
        //Caption := IntToStr(Handle);
        EngParamSource.Execute;
      end;
    end
    else
      FParameterDragMode := False;
  end;

  if ssCtrl in Shift then
    FControlPressed := False;
end;

procedure TMainForm.ListConfig1Click(Sender: TObject);
var
  LAdvNavBarPanel: TAdvNavBarPanel;
  LFrame: TFrame1;
begin
  LAdvNavBarPanel := AdvNavBar1.Panels[AdvNavBar1.ActiveTabIndex];
  if LAdvNavBarPanel.Name = 'MonitoringPanel' then
  begin
    LFrame := MonTileListFrame;
    SetConfigMonitorTile(LFrame.tileList.SelectedTile);
  end
  else
  if LAdvNavBarPanel.Name = 'CommunicationPanel' then
  begin
    LFrame := CommTileListFrame;
    SetConfigAutoRunTile(LFrame.tileList.SelectedTile);
  end;
end;

procedure TMainForm.LoadAllInfo1Click(Sender: TObject);
begin
  if High(FPackageModules) < 0 then
    PackageLoad_MDIChild;

  CreateChildFormAll;
end;

procedure TMainForm.LoadAutoRun(AVar: TAutoRunItem);
var
  LHandle,LProcessID: THandle;
  LRunName: string;
  LHiMECSConfig: THiMECSConfig;
  LParam: string;
begin
  LRunName := AVar.AppPath;
  if Pos('.',LRunName) > 0  then //'.'이 존재 하면
    LRunName := replaceString(LRunName, '.\', '.\Applications\');

  LParam := AVar.RunParameter;

  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;

  if LHiMECSConfig.ExtAppInMDI then
    LParam := LParam + ' /C';  //MDI Child Mode

  LProcessId := ExecNewProcess2(LRunName, LParam);
  LHandle := DSiGetProcessWindow(LProcessId);
  AVar.AppHandle := LHandle;
  AVar.AppProcessId := LProcessId;

  if LHiMECSConfig.ExtAppInMDI then
  begin
    CreateDummyMDIChild(LProcessId);
    ReparentWindow(LHandle);
  end;
end;

procedure TMainForm.LoadAutoRunConfigForm2Var(AForm: TnewCommApp_Frm;
  AVar: TAutoRunItem);
var
  LStr: string;
begin
  with AForm do
  begin
    AVar.AppTitle := appTitle.Text;
    AVar.IsAutoRun := AutoRunCB.Checked;

    if RelPathCB.Checked then
      LStr := ExtractRelativePathBaseApplication(FApplicationPath+'Applications\', appPath.Text)
    else
      LStr := appPath.Text;

    AVar.AppPath := LStr;
    AVar.AppDesc := appDesc.Text;
    AVar.RunParameter := RunParamEdit.Text;

    with GDIPPictureContainer1.Items do
    begin
      Clear;
      Add;
      Items[Count-1].Picture.Assign(Icon.Picture);
      AVar.AppImage := CommTileListFrame.ConvertImage2String(Items[Count-1].Picture);

      Items[Count-1].Picture.Assign(DisableIcon.Picture);
      AVar.AppDisableImage := CommTileListFrame.ConvertImage2String(Items[Count-1].Picture);
    end;
  end;
end;

procedure TMainForm.LoadAutoRunList;
var
  i, LHandle: integer;
  LStr,
  LParam, LProgName: string;
  LAutoRunList: TAutoRunList;
begin
  CommTileListFrame.InitVar;
  //MonTileListFrame.TileList.FAddNewApp2List := AddNewApp2List;

  for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
  begin
    LStr := FProjectFile.ProjectFileCollect.Items[i].RunListFileName;

    if LStr <> '' then
    begin
      if FileExists(LStr) then
      begin
        if Pos('..',LStr) = 0  then //'..'이 없는 경우
          LStr := replaceString(LStr, '.\', '..\');

        LAutoRunList := TAutoRunList.Create(Self);
        FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun := LAutoRunList;

        if FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig.UseCommLauncher then
        begin
          LProgName := HiMECSCommLauncher;
          LParam := '/A' + LStr;
          LHandle := ExecLaunchList(LProgName,LParam);//, FAutoRunHandles);
          LAutoRunList.LauncherHandle := LHandle;
        end
        else
        begin
          if Pos('..',LStr) > 0  then //'..'이 존재 하면
            LStr := replaceString(LStr, '..\', '.\');

          LoadAutoRunTileFromFile(LStr, True, LAutoRunList);
          ExecuteAutoRunList(LAutoRunList, False, True, False);
        end;
      end;
    end;
  end;
end;

procedure TMainForm.LoadAutoRunTileFromFile(AFileName: string;
  AIsAppend: Boolean; AAutoRunList: TAutoRunList);
var
  lTile : TAdvSmoothTile;
  i: integer;
begin
  SetCurrentDir(FApplicationPath);

  if not FileExists(AFileName) then
  begin
    ShowMessage('File not exist : '+ AFileName + ' (From .rlist)');
    exit;
  end;

  if not AIsAppend then
  begin
    AAutoRunList.AutoRunCollect.Clear;
    CommTileListFrame.tileList.Tiles.Clear;
  end;

  AAutoRunList.LoadFromJSONFile(AFileName);

  for i := 0 to AAutoRunList.AutoRunCollect.Count - 1 do
  begin
    lTile := CommTileListFrame.tileList.Tiles.Add;
    LoadAutoRunVar2Form(lTile,AAutoRunList.AutoRunCollect.Items[i]);
  end; //for
end;

procedure TMainForm.LoadAutoRunVar2ConfigForm(AForm: TnewCommApp_Frm;
  AVar: TAutoRunItem);
begin
  with AForm do
  begin
    appTitle.Text := AVar.AppTitle;
    AutoRunCB.Checked := AVar.IsAutoRun;
    appPath.Text := AVar.AppPath;
    appDesc.Text := AVar.AppDesc;
    RunParamEdit.Text := AVar.RunParameter;

    with GDIPPictureContainer1.Items do
    begin
      Clear;
      Add;
      if AVar.AppImage <> '' then
      begin
        Items[Count-1].Picture.LoadFromStream(CommTileListFrame.ConvertString2Stream(AVar.AppImage));
        Icon.Picture.Assign(Items[Count-1].Picture);
        Icon.Invalidate;
      end;

      if AVar.AppDisableImage <> '' then
      begin
        Items[Count-1].Picture.LoadFromStream(CommTileListFrame.ConvertString2Stream(AVar.AppDisableImage));
        DisableIcon.Picture.Assign(Items[Count-1].Picture);
        DisableIcon.Invalidate;
      end;
    end;
  end;
end;

procedure TMainForm.LoadAutoRunVar2Form(ATile: TAdvSmoothTile;
  AVar: TAutoRunItem);
begin
  with ATile do
  begin
    Content.Text := AVar.AppTitle;
    Content.TextPosition := tpBottomCenter;

    if AVar.IsAutoRun then
      StatusIndicator := 'Auto'
    else
      StatusIndicator := '';

    Content.Hint := AVar.AppPath;
    DisplayName := AVar.AppDesc;
    ItemOject := AVar;

    if AVar.AppImage <> '' then
      Content.Image.LoadFromStream(CommTileListFrame.ConvertString2Stream(AVar.AppDisableImage));
  end;

  TileConfigChange(2);
end;

procedure TMainForm.LoadConfigCollect2Form(AForm: TConfigF);
var
  LHiMECSConfig: THiMECSConfig;
begin
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;

  with LHiMECSConfig, AForm do
  begin
    MenuFilenameEdit.Text := MenuFileName;
    EngInfoFilenameEdit.Text := EngineInfoFileName;
    ParamFilenameEdit.Text := ParamFileName;
    ProjInfoFilenameEdit.Text := ProjectInfoFileName;
    UserFilenameEdit.Text := UserFileName;
    KillProcFilenameEdit.Text := KillProcListFileName;

    FormPathEdit.Text := HiMECSFormPath;
    ConfigPathEdit.Text := ConfigPath;
    DocPathEdit.Text := DocPath;
    ExePathEdit.Text := ExesPath;
    BplPathEdit.Text := BplsPath;
    LogPathEdit.Text := LogPath;

    CBExtAppInMDI.Checked := ExtAppInMDI;
    CBUseMonLauncher.Checked := UseMonLauncher;
    CBUseCommLauncher.Checked := UseCommLauncher;
    EngParamEncryptCB.Checked := EngParamEncrypt;
    ConfFileFormatRG.ItemIndex := EngParamFileFormat;

    SelProtocolRG.ItemIndex := UpdateProtocol;
    HostEdit.Text := FTPHost;
    PortEdit.Text := IntToStr(FTPPort);
    UserIdEdit.Text := FTPUserID;
    PasswdEdit.Text := FTPPasswd;
    DirEdit.Text := FTPDirectory;
    URLEdit.Text := ServerURL;
    UpdateCB.Checked := UpdateWhenStart;
  end;
end;

//.option file load
procedure TMainForm.LoadConfigCollectFromFile(AIndex: integer);
var
  LHiMECSConfig: THiMECSConfig;
  LFileName: string;
  LIsEncrypt: Boolean;
begin
  if not Assigned(FProjectFile.ProjectFileCollect.Items[AIndex].HiMECSConfig) then
    FProjectFile.ProjectFileCollect.Items[AIndex].HiMECSConfig := THiMECSConfig.Create(Self);

  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[AIndex].HiMECSConfig;

  LFileName := FProjectFile.ProjectFileCollect.Items[AIndex].OptionsFileName;
  LIsEncrypt := FProjectFile.ProjectFileCollect.Items[AIndex].OptionFileEncrypt;

  if LFileName <> '' then
  begin
    LHiMECSConfig.Clear;
    LHiMECSConfig.LoadFromFile(LFileName,ExtractFileName(LFileName),LIsEncrypt);
    //if not exist directory then create directory
    if LHiMECSConfig.HiMECSFormPath <> '' then
      if not ForceDirectories(LHiMECSConfig.HiMECSFormPath) then
        ShowMessage('Creation fail for ' + LHiMECSConfig.HiMECSFormPath + ' folder!');

    if LHiMECSConfig.ConfigPath <> '' then
      if not ForceDirectories(LHiMECSConfig.ConfigPath) then
        ShowMessage('Creation fail for ' + LHiMECSConfig.ConfigPath + ' folder!(from HiMECSFormPath option)');

    if LHiMECSConfig.DocPath <> '' then
      if not ForceDirectories(LHiMECSConfig.DocPath) then
        ShowMessage('Creation fail for ' + LHiMECSConfig.DocPath + ' folder!(from DocPath option)');

    if LHiMECSConfig.ExesPath <> '' then
      if not ForceDirectories(LHiMECSConfig.ExesPath) then
        ShowMessage('Creation fail for ' + LHiMECSConfig.ExesPath + ' folder!(from ExesPath option)');

    if LHiMECSConfig.BplsPath <> '' then
      if not ForceDirectories(LHiMECSConfig.BplsPath) then
        ShowMessage('Creation fail for ' + LHiMECSConfig.BplsPath + ' folder!(from BplsPath option)');

    if LHiMECSConfig.LogPath <> '' then
      if not ForceDirectories(LHiMECSConfig.LogPath) then
        ShowMessage('Creation fail for ' + LHiMECSConfig.LogPath + ' folder!(from LogPath option)');
  end
  else
    ShowMessage('Config File name is empty!');
end;

procedure TMainForm.LoadConfigForm2Collect(AForm: TConfigF);
var
  LPath: string;
  LHiMECSConfig: THiMECSConfig;
begin
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
  LPath := ExtractFilePath(Application.ExeName);

  with LHiMECSConfig, AForm do
  begin
    MenuFileName := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(MenuFilenameEdit.Text)))
                              + ExtractFileName(MenuFilenameEdit.Text);
    EngineInfoFileName := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(EngInfoFilenameEdit.Text)))
                              + ExtractFileName(EngInfoFilenameEdit.Text);
    ParamFileName := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(ParamFilenameEdit.Text)))
                              + ExtractFileName(AForm.ParamFilenameEdit.Text);
    ProjectInfoFileName := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(ProjInfoFilenameEdit.Text)))
                              + ExtractFileName(ProjInfoFilenameEdit.Text);
    UserFileName := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(UserFilenameEdit.Text)))
                              + ExtractFileName(UserFilenameEdit.Text);

    KillProcListFileName := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(KillProcFilenameEdit.Text)))
                              + ExtractFileName(KillProcFilenameEdit.Text);

    HiMECSFormPath := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(FormPathEdit.Text)))
                              + ExtractFileName(FormPathEdit.Text);
    ConfigPath := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(ConfigPathEdit.Text)))
                              + ExtractFileName(ConfigPathEdit.Text);
    DocPath := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(DocPathEdit.Text)))
                              + ExtractFileName(DocPathEdit.Text);
    ExesPath := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(ExePathEdit.Text)))
                              + ExtractFileName(AForm.ExePathEdit.Text);
    BplsPath := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(BplPathEdit.Text)))
                              + ExtractFileName(BplPathEdit.Text);
    LogPath := IncludeTrailingBackslash(ExtractRelativePath(
                              LPath, ExtractFilePath(LogPathEdit.Text)))
                              + ExtractFileName(LogPathEdit.Text);
    ExtAppInMDI := CBExtAppInMDI.Checked;
    UseMonLauncher := CBUseMonLauncher.Checked;
    UseCommLauncher := CBUseCommLauncher.Checked;
    EngParamEncrypt := EngParamEncryptCB.Checked;
    EngParamFileFormat := ConfFileFormatRG.ItemIndex;

    UpdateProtocol := SelProtocolRG.ItemIndex;
    FTPHost := HostEdit.Text;
    FTPPort := StrToIntDef(PortEdit.Text, -1);
    FTPUserID := UserIdEdit.Text;
    FTPPasswd := PasswdEdit.Text;
    FTPDirectory := DirEdit.Text;
    ServerURL := URLEdit.Text;
    UpdateWhenStart := UpdateCB.Checked;
  end;

end;

procedure TMainForm.LoadMonitorConfigForm2Var(AForm: TnewMonApp_Frm;
  AVar: THiMECSMonitorListItem);
var
  LStr: string;
begin
  with AForm do
  begin
    AVar.MonitorTitle := appTitle.Text;
    AVar.IsAutoLoad := AutoRunCB.Checked;
    if RelPathCB.Checked then
      LStr := ExtractRelativePathBaseApplication(FApplicationPath+'Applications\', appPath.Text)
    else
      LStr := appPath.Text;

    AVar.MonitorFileName := LStr;

    if ProgRelPathCB.Checked then
      LStr := ExtractRelativePathBaseApplication(FApplicationPath+'Applications\', ProgNameEdit.Text)
    else
      LStr := ProgNameEdit.Text;

    AVar.RunProgramName := LStr;
    AVar.MonitorDesc := appDesc.Text;
    with GDIPPictureContainer1.Items do
    begin
      Clear;
      Add;
      Items[Count-1].Picture.Assign(Icon.Picture);
      AVar.MonitorImage := MonTileListFrame.ConvertImage2String(Items[Count-1].Picture);
    end;
  end;
end;

procedure TMainForm.LoadEngineInfo(AFileName:string; AIsEncrypt: Boolean;
  AIsAdd2Combo: Boolean; AIs2Inspector: Boolean);
var
  LEngineInfoCollect: TICEngine;
  LHiMECSConfig: THiMECSConfig;
begin
  if not FileExists(AFileName) then
  begin
    DisplayMessage('Engine information file: ' + AFileName + ' not found!',
                                                            mstFile,mtError);
    exit;
  end;

  SetCurrentDir(FApplicationPath);

  LEngineInfoCollect := TICEngine.Create(Self);
  LEngineInfoCollect.LoadFromJsonFile(AFileName,ExtractFileName(AFileName),AIsEncrypt);
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
  LHiMECSConfig.EngineInfo := LEngineInfoCollect;

//  if AIsAdd2Combo then
//    SelectEngineCombo.Lines.Add(GetEngineType(FCOI));

  if AIs2Inspector then
    SetEngineInfo2Inspector(FCOI, AIsAdd2Combo);
end;

procedure TMainForm.LoadEngineInfo1Click(Sender: TObject);
begin
  JvOpenDialog1.InitialDir := FApplicationPath;
  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      LoadEngineInfo(JvOpenDialog1.FileName, False, False, True);
    end;
  end;
end;

procedure TMainForm.LoadFromFile1Click(Sender: TObject);
begin
  JvOpenDialog1.InitialDir := FApplicationPath;

  if JvOpenDialog1.Execute then
  begin
    if JvOpenDialog1.FileName <> '' then
    begin
      //LoadTileFromFile(JvOpenDialog1.FileName, False);
    end;
  end;
end;

procedure TMainForm.LoadKillProcess;
var
  LHiMECSConfig: THiMECSConfig;
begin
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;

  if not FileExists(LHiMECSConfig.KillProcListFileName) then
    exit;

  FKillProcessList.KillProcessListCollect.Clear;
  FKillProcessList.KillProcListFileName := LHiMECSConfig.KillProcListFileName;
  FKillProcessList.LoadFromJSONFile(LHiMECSConfig.KillProcListFileName);
  ExecProcessKill;
  FKillProcessList.KillProcTimerHandle := FPJHTimerPool.Add(OnProcessKill, 600000);
end;

procedure TMainForm.LoadManualInfo2MsNoTV(ARoot: TTreeNode;
  AManualInfo: THiMECSManualInfo);
var
  i: integer;
  LTreeNode,
  LPartTreeNode2: TTreeNode;
  LStr, LStr2: string;
  LStrlst, LSystemlst: TStringList;
  LIndex: integer;
begin
  LStrlst := TStringList.Create;
  LSystemlst := TStringList.Create;
  ManualCheckTV.Items.BeginUpdate;

  try
    for i := 0 to AManualInfo.OpManual.Count - 1 do
    begin
      LStr := 'Operation Manual';
      LStrlst.CaseSensitive := False;
      LIndex := LStrlst.IndexOf(LStr);
      if LIndex < 0 then
      begin
        LTreeNode := ManualCheckTV.Items.AddChild(ARoot, LStr);
        LStrlst.AddObject(LStr, LTreeNode);
        SetNodeImages(LTreeNode, True);
      end
      else
      begin
        LTreeNode := TTreeNode(Lstrlst.Objects[LIndex]);
      end;

      LStr := LStr + ';' + AManualInfo.OpManual.Items[i].SystemDesc_Eng;
      LSystemlst.CaseSensitive := False;
      LIndex := LSystemlst.IndexOf(LStr);
      if LIndex < 0 then
      begin
        LStr2 := strToken(LStr, ';');
        LTreeNode := ManualCheckTV.Items.AddChild(LTreeNode, LStr);
        LSystemlst.AddObject(LStr2+';'+LStr, LTreeNode);
        SetNodeImages(LTreeNode, True);
      end
      else
      begin
        LTreeNode := TTreeNode(LSystemlst.Objects[LIndex]);
      end;

      if AManualInfo.OpManual.Items[i].PartDesc_Eng = '' then
//        LStr2 := AParam.EngineParameterCollect.Items[i].Tagname
      else
        LStr2 := AManualInfo.OpManual.Items[i].PartDesc_Eng;

      LPartTreeNode2 := ManualCheckTV.Items.AddChildObject(LTreeNode,
             LStr2, AManualInfo.OpManual.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;//for
  finally
    ManualCheckTV.Items.EndUpdate;
    LSystemlst.Free;
    LStrlst.Free;
  end;
end;

procedure TMainForm.LoadManualInfo2PlateNoTV(ARoot: TTreeNode;
  AManualInfo: THiMECSManualInfo);
begin

end;

procedure TMainForm.LoadManualInfo2TreeView(AFileName: string;
  ASortMethod: TManualSortMethod; ARootNode: TTreeNode; AIndex: integer);
var
  LStr: string;
  LHiMECSManualInfo: THiMECSManualInfo;
  LEPList: TStringList;
  LHiMECSConfig: THiMECSConfig;
  LIndex: integer;
begin
  if AIndex = -1 then
    LIndex := FCOI
  else
    LIndex := AIndex;

  if ARootNode = nil then
  begin
    ManualCheckTV.Items.Clear;
    ManualCheckTV.Items.BeginUpdate;

    LStr := FProjectFile.ProjectFileCollect.Items[LIndex].ProjectItemName;
    ARootNode := ManualCheckTV.Items.AddChild(nil, LStr);
  end;

  try
    SetCurrentDir(FApplicationPath);
    LHiMECSManualInfo := THiMECSManualInfo.Create(Self);
    LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[LIndex].HiMECSConfig;

    if AFileName = '' then
    begin
      FCurrentManualInfoFileName := LHiMECSConfig.ManualInfoFileName;
    end
    else
    begin
      FCurrentManualInfoFileName := AFileName;
    end;

    if not FileExists(FCurrentManualInfoFileName) then
    begin
      ShowMessage('Manual Info File: "' + FCurrentManualInfoFileName + '" not exist(From HiMECSConfig.ManualInfoFileName)!');
      exit;
    end;

    LHiMECSManualInfo.LoadFromJSONFile(FCurrentManualInfoFileName);

    if Assigned(LHiMECSConfig.ManualInfo) then
    begin
      LHiMECSConfig.ManualInfo.Free;
      LHiMECSConfig.ManualInfo := nil;
    end;

    LHiMECSConfig.ManualInfo := LHiMECSManualInfo;
    if LHiMECSManualInfo.OpManual.Count <= 0 then
      exit;

    case ASortMethod of
      msmMSNo: LoadManualInfo2MsNoTV(ARootNode, LHiMECSManualInfo);
      msmPlateNo: LoadManualInfo2PlateNoTV(ARootNode, LHiMECSManualInfo);
    end;//case
  finally
    ManualCheckTV.Items.EndUpdate;
  end;
end;

procedure TMainForm.LoadManualInfo2TV(ASortMethod: TManualSortMethod);
var
  i,LIndex: integer;
  LStr: string;
  LRootNode: TTreeNode;
  LRootList: TStringList;
  LHiMECSConfig: THiMECSConfig;
begin
  LRootList := TStringList.Create;
  try
    for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
    begin
      LStr := FProjectFile.ProjectFileCollect.Items[i].ProjectItemName;
      LIndex := -1;
      LIndex := LRootList.IndexOf(LStr);

      if LIndex < 0 then
      begin
        LRootNode := ManualCheckTV.Items.AddChild(nil, LStr);
        LRootList.AddObject(LStr, LRootNode);
      end
      else
        LRootNode := TTreeNode(LRootList.Objects[LIndex]);

      LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig;
      LStr := LHiMECSConfig.ManualInfoFileName;
      LoadManualInfo2TreeView(LStr,ASortMethod,LRootNode, i);
      FCurrentManualSortMethod := ASortMethod;
    end;//for
  finally
    FreeAndNil(LRootList);
  end;
end;

procedure TMainForm.LoadMenuFromFile(AFileName: string; AIsUseLevel: Boolean);
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));

  if AFileName = '' then
  begin
    AFileName := DefaultMenuFileNameOnLogIn;
    ShowMessage('Menu File name is empty!(From THiMECSUserItem.MenuFileName)' + #13#10 + 'File: ' + DefaultMenuFileNameOnLogIn + ' is loaded.');
  end;

  FMenuBase.HiMECSMenuCollect.Clear;
  FMenuBase.LoadFromJSONFile(AFileName,ExtractFileName(AFileName), DefaultMenuEncryption);
  SetHiMECSMainMenu(FMenuBase);
end;

procedure TMainForm.LoadMonitor(AVar: THiMECSMonitorListItem);
var
  LHandle,LProcessID: THandle;
  LRunName: string;
  LHiMECSConfig: THiMECSConfig;
  LParam: string;
begin
  LRunName := AVar.RunProgramName;
  if Pos('.',LRunName) > 0  then //'.'이 존재 하면
    LRunName := replaceString(LRunName, '.\', '.\Applications\');

  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;

  LParam := '/p' + AVar.MonitorFileName;

  if LHiMECSConfig.ExtAppInMDI then
    LParam := LParam + ' /C';  //MDI Child Mode

  LProcessId := ExecNewProcess2(LRunName, LParam);
  LHandle := DSiGetProcessWindow(LProcessId);
  AVar.AppHandle := LHandle;
  AVar.AppProcessId := LProcessId;

  if LHiMECSConfig.ExtAppInMDI then
  begin
    CreateDummyMDIChild(LProcessId);
    ReparentWindow(LHandle);
  end;
end;

procedure TMainForm.LoadMonitorFormList;
var
  i, LHandle: integer;
  LStr,
  LParam, LProgName: string;
  LHiMECSMonitorList: THiMECSMonitorList;
begin
  MonTileListFrame.InitVar;
  //MonTileListFrame.TileList.FAddNewApp2List := AddNewApp2List;

  for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
  begin
    LStr := FProjectFile.ProjectFileCollect.Items[i].MonitorFileName;

    if LStr <> '' then
    begin
      if FileExists(LStr) then
      begin
        if Pos('..',LStr) = 0  then //'..'이 없는 경우
          LStr := replaceString(LStr, '.\', '..\');

        LHiMECSMonitorList := THiMECSMonitorList.Create(Self);
        FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor := LHiMECSMonitorList;

        if FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig.UseMonLauncher then
        begin
          LProgName := HiMECSMonitorLauncher;
          LParam := '/A' + LStr;
          LHandle := ExecLaunchList(LProgName,LParam);//, FMonitorHandles);
          LHiMECSMonitorList.LauncherHandle := LHandle;
        end
        else
        begin
          if Pos('..',LStr) > 0  then //'..'이 존재 하면
            LStr := replaceString(LStr, '..\', '.\');

          LoadMonitorTileFromFile(LStr, True, LHiMECSMonitorList);
          ExecuteMonitorList(LHiMECSMonitorList, False, True, False);
        end;
      end;
    end;
  end;
end;

procedure TMainForm.LoadParameter2SensorTV(ARoot: TTreeNode;
   AParam: TEngineParameter);
var
  i: integer;
  LTreeNode,
  LPartTreeNode2: TTreeNode;
  LStr, LStr2: string;
  LStrlst, LSensorlst: TStringList;
  LIndex: integer;
begin
  LStrlst := TStringList.Create;
  LSensorlst := TStringList.Create;
  try
    for i := 0 to AParam.EngineParameterCollect.Count - 1 do
    begin
      if UpperCase(AParam.EngineParameterCollect.Items[i].Tagname) = 'DUMMY' then
        continue;

      LStr := ParameterSource2String(AParam.EngineParameterCollect.Items[i].ParameterSource);
      LStrlst.CaseSensitive := False;
      LIndex := LStrlst.IndexOf(LStr);
      if LIndex < 0 then
      begin
        LTreeNode := JvCheckTreeView1.Items.AddChild(ARoot, LStr);
        LStrlst.AddObject(LStr, LTreeNode);
        SetNodeImages(LTreeNode, False);
      end
      else
      begin
        LTreeNode := TTreeNode(Lstrlst.Objects[LIndex]);
      end;

      LStr := LStr + ';' + SensorType2String(AParam.EngineParameterCollect.Items[i].SensorType);
      LSensorlst.CaseSensitive := False;
      LIndex := LSensorlst.IndexOf(LStr);
      if LIndex < 0 then
      begin
        LStr2 := strToken(LStr, ';');
        LTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, LStr);
        LSensorlst.AddObject(LStr2+';'+LStr, LTreeNode);
        SetNodeImages(LTreeNode, False);
      end
      else
      begin
        LTreeNode := TTreeNode(LSensorlst.Objects[LIndex]);
      end;

      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LTreeNode,
             AParam.EngineParameterCollect.Items[i].Description,
             AParam.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;//for
  finally
    LSensorlst.Free;
    LStrlst.Free;
  end;
end;

procedure TMainForm.LoadParameter2SystemTV(ARoot: TTreeNode;
   AParam: TEngineParameter);
var
  i: integer;
  LTreeNode,
  LPartTreeNode2: TTreeNode;
  LStr, LStr2: string;
  LStrlst, LSystemlst: TStringList;
  LIndex: integer;
begin
  LStrlst := TStringList.Create;
  LSystemlst := TStringList.Create;
  try
    JvCheckTreeView1.Items.BeginUpdate;

    for i := 0 to AParam.EngineParameterCollect.Count - 1 do
    begin
      if UpperCase(AParam.EngineParameterCollect.Items[i].Tagname) = 'DUMMY' then
        continue;

      LStr := ParameterSource2String(AParam.EngineParameterCollect.Items[i].ParameterSource);
      LStrlst.CaseSensitive := False;
      LIndex := LStrlst.IndexOf(LStr);
      if LIndex < 0 then
      begin
        LTreeNode := JvCheckTreeView1.Items.AddChild(ARoot, LStr);
        LStrlst.AddObject(LStr, LTreeNode);
        SetNodeImages(LTreeNode, False);
      end
      else
      begin
        LTreeNode := TTreeNode(Lstrlst.Objects[LIndex]);
      end;

      LStr := LStr + ';' + ParameterCatetory2String(AParam.EngineParameterCollect.Items[i].ParameterCatetory);
      LSystemlst.CaseSensitive := False;
      LIndex := LSystemlst.IndexOf(LStr);
      if LIndex < 0 then
      begin
        LStr2 := strToken(LStr, ';');
        LTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, LStr);
        LSystemlst.AddObject(LStr2+';'+LStr, LTreeNode);
        SetNodeImages(LTreeNode, False);
      end
      else
      begin
        LTreeNode := TTreeNode(LSystemlst.Objects[LIndex]);
      end;

      if AParam.EngineParameterCollect.Items[i].Description = '' then
        LStr2 := AParam.EngineParameterCollect.Items[i].Tagname
      else
        LStr2 := AParam.EngineParameterCollect.Items[i].Description;

      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LTreeNode,
             LStr2,
             AParam.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;//for
  finally
    JvCheckTreeView1.Items.EndUpdate;
    LSystemlst.Free;
    LStrlst.Free;
  end;
end;

procedure TMainForm.LoadParameter2TreeView(AFileName:string;
  ASortMethod: TParamSortMethod; ARootNode: TTreeNode; AIndex: integer);
var
  LStr: string;
  LEngineParameter: TEngineParameter;
  LEPList: TStringList;
  LHiMECSConfig: THiMECSConfig;
  LIndex: integer;
begin
  if AIndex = -1 then
    LIndex := FCOI
  else
    LIndex := AIndex;

  if ARootNode = nil then
  begin
    JvCheckTreeView1.Items.Clear;
    JvCheckTreeView1.Items.BeginUpdate;

    LStr := FProjectFile.ProjectFileCollect.Items[LIndex].ProjectItemName;
    ARootNode := JvCheckTreeView1.Items.AddChild(nil, LStr);
  end;

  try
    SetCurrentDir(FApplicationPath);
    //FEngineParameter.EngineParameterCollect.Clear;
    LEngineParameter := TEngineParameter.Create(Self);
    LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[LIndex].HiMECSConfig;

    if AFileName = '' then
    begin
      FCurrentParaFileName := LHiMECSConfig.ParamFileName;
    end
    else
    begin
      FCurrentParaFileName := AFileName;
    end;

    if not FileExists(FCurrentParaFileName) then
    begin
      ShowMessage('Param File(FCurrentParaFileName): "' + FCurrentParaFileName + '" not exist!(From HiMECSConfig.ParamFileName)');
      exit;
    end;

    if LHiMECSConfig.EngParamFileFormat = 0 then //XML format
      LEngineParameter.LoadFromFile(FCurrentParaFileName,
                ExtractFileName(FCurrentParaFileName),
                LHiMECSConfig.EngParamEncrypt)
    else
    if LHiMECSConfig.EngParamFileFormat = 1 then //JSON format
      LEngineParameter.LoadFromJSONFile(FCurrentParaFileName,
                ExtractFileName(FCurrentParaFileName),
                LHiMECSConfig.EngParamEncrypt);

    //FEngineParameterList.AddObject(IntToStr(FEngineParameterList.Count+1), LEngineParameter);
    //FEngineParameterList.AddObject(ARootNode.Text, LEngineParameter);
    //FHiMECSOptions.EPStrList.AddObject(ARootNode.Text, LEngineParameter);
    if Assigned(LHiMECSConfig.EngineParameter) then
    begin
      LHiMECSConfig.EngineParameter.Free;
      LHiMECSConfig.EngineParameter := nil;
    end;

    LHiMECSConfig.EngineParameter := LEngineParameter;
    if LEngineParameter.EngineParameterCollect.Count <= 0 then
      exit;

    case ASortMethod of
      smSystem: LoadParameter2SystemTV(ARootNode, LEngineParameter);
      smSensor: LoadParameter2SensorTV(ARootNode, LEngineParameter);
    end;//case
  finally
//    LEngineParameter.Free;
    JvCheckTreeView1.Items.EndUpdate;
  end;
end;

procedure TMainForm.LoadParameterfromfile1Click(Sender: TObject);
begin
  JvOpenDialog1.InitialDir := FApplicationPath+'doc';
  JvOpenDialog1.Filter := '*.param||*.*';

  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      LoadParameter2TreeView(JvOpenDialog1.FileName, smSystem);
    end;
  end;
end;

procedure TMainForm.LoadParameterList2TV(ASortMethod: TParamSortMethod);
var
  i,LIndex: integer;
  LStr: string;
  LRootNode: TTreeNode;
  LRootList: TStringList;
  LHiMECSConfig: THiMECSConfig;
begin
  LRootList := TStringList.Create;
  try
    for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
    begin
      LStr := FProjectFile.ProjectFileCollect.Items[i].ProjectItemName;

      LIndex := LRootList.IndexOf(LStr);

      if LIndex < 0 then
      begin
        LRootNode := JvCheckTreeView1.Items.AddChild(nil, LStr);
        //LRootNode.Tag := i;
        LRootList.AddObject(LStr, LRootNode);
      end
      else
        LRootNode := TTreeNode(LRootList.Objects[LIndex]);

      LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig;
      LStr := LHiMECSConfig.ParamFileName;
      LoadParameter2TreeView(LStr,ASortMethod,LRootNode, i);
      FCurrentSortMethod := ASortMethod;
    end;//for
  finally
    FreeAndNil(LRootList);
  end;
end;

procedure TMainForm.LoadProjectInfo(AFileName: string; AIsEncrypt: Boolean);
var
  LStr: string;
  i,LNodeIndex,LLastIndex: integer;
  LPropertyItem: TNxPropertyItem;
  LComboItem: TNxComboBoxItem;
begin
  if not FileExists(AFileName) then
  begin
    DisplayMessage('Project information file: ' + AFileName + ' not found!',
                                                            mstFile,mtError);
    exit;
  end;

  SetCurrentDir(FApplicationPath);

  FProjectInfoCollect.Clear;
  FProjectInfoCollect.LoadFromFile(AFileName,ExtractFileName(AFileName),AIsEncrypt);
  ProjectInfoInspector.Items[0].Clear;

  LStr := FProjectInfoCollect.ProjectNo;
  AddItemsToInspector(ProjectInfoInspector, TNxTextItem, 0,
                                          'FProjNo','Project No.', LStr);
  LStr := FProjectInfoCollect.ProjectName;
  AddItemsToInspector(ProjectInfoInspector, TNxTextItem, 0,
                                          'FProjName','Project Name', LStr);
  LStr := FProjectInfoCollect.SiteNo;
  AddItemsToInspector(ProjectInfoInspector, TNxTextItem, 0,
                                          'FSiteNo','Site No.', LStr);
  LStr := FProjectInfoCollect.SiteName;
  AddItemsToInspector(ProjectInfoInspector, TNxTextItem, 0,
                                          'FSiteName','Site Name', LStr);
  LStr := FProjectInfoCollect.EngineCount;
  AddItemsToInspector(ProjectInfoInspector, TNxTextItem, 0,
                                          'FEngineNum','Num. of Engine', LStr);
  LStr := FProjectInfoCollect.ShipOwner;
  AddItemsToInspector(ProjectInfoInspector, TNxTextItem, 0,
                                          'FShipOwner','Ship Owner', LStr);
  LStr := FProjectInfoCollect.ClassSociety;
  AddItemsToInspector(ProjectInfoInspector, TNxTextItem, 0,
                                          'FClassSociety','Class', LStr);
  //AddItemsToInspector(ProjectInfoInspector, TNxTextItem, LPropertyItem.NodeIndex, 'CylinderCount', 'Cyl. Count', IntToStr(FEngineInfoCollect.CylinderCount));
end;

procedure TMainForm.LoadProjectInfo1Click(Sender: TObject);
begin
  JvOpenDialog1.InitialDir := FApplicationPath;
  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      LoadProjectInfo(JvOpenDialog1.FileName, False);
    end;
  end;
end;

procedure TMainForm.LoadSearchTreeFromEngParam(ASearchText: string;
  ASortMethod: TParamSortMethod);
// code from https://forums.embarcadero.com/thread.jspa?messageID=84669
// modified as a method
// further modified to include case insensitive search and node selection
var
  LEngineParameter: TEngineParameter;
  ANode, NextNode: TTreeNode;
  ALevel, i, j, LParentRem: Integer;
  CurrStr, LStr: string;
  Keep, KeepParent, KeepAncestors: Boolean;
  LevelRem: Integer;
  LHiMECSConfig: THiMECSConfig;

  function GetBufStart(Buffer: string; var Level: Integer): string;
  var
    Pos: Integer;
  begin
    Pos := 1;
    Level := 0;
    while (CharInSet(Buffer[Pos], [' ', #9])) do
    begin
      Inc(Pos);
      Inc(Level);
    end;
    Result := Copy(Buffer, Pos, Length(Buffer) - Pos + 1);
  end;

begin
  JvCheckTreeView1.Items.Clear;
  //JvCheckTreeView1.Items.BeginUpdate;

  ASearchText:= Lowercase(ASearchText); // insures a case insensitive search
  FParamSearchMode:= Length(ASearchText) <> 0; // true searcxh box not empty

  if FParamSearchMode then
  begin
    try
      try
        for i := 0 to FSearchParamList.Count - 1 do
          TEngineParameter(FSearchParamList.Objects[i]).Free;

        FSearchParamList.Clear;

        for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
        begin
          LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig;
          LEngineParameter := TEngineParameter.Create(Self);
          LEngineParameter.Assign(LHiMECSConfig.EngineParameter);
          FSearchParamList.AddObject(FProjectFile.ProjectFileCollect.Items[i].ProjectItemName, LEngineParameter);
        end;

        // Search algorithm
        LevelRem:= 0; // 26 May 2011
        KeepParent:= false;

        for i := 0 to FSearchParamList.Count - 1 do
        begin
          LEngineParameter := TEngineParameter(FSearchParamList.Objects[i]);

          for j := LEngineParameter.EngineParameterCollect.Count - 1 downto 0 do // List is scanned from bottom to top
          begin
            LStr := LEngineParameter.EngineParameterCollect.Items[j].Description;
            //CurrStr := GetBufStart(PChar(List[i]), ALevel);
            CurrStr := GetBufStart(LStr, ALevel);
            CurrStr:= Lowercase(CurrStr); // insures a case insensitive search

            if ALevel >= LevelRem then // node is a leaf
            begin
              Keep:= pos(ASearchText, CurrStr) > 0; // Search string found if true

              if Keep then
              begin
                KeepParent:= true; // parent branch must be kept
                KeepAncestors:= true;
                LParentRem:= ALevel - 1;
              end
              else
                LEngineParameter.EngineParameterCollect.Delete(j);
            end; // if ALevel = LevelRem

            if ALevel = LevelRem - 1 then // node is a branch
            begin
              KeepParent:= false;
              if KeepAncestors and (ALevel = LParentRem) then
              begin
                KeepParent:= true;
                LParentRem:= LParentRem - 1;
              end;
              if not KeepParent then
                LEngineParameter.EngineParameterCollect.Delete(j)
              else if ALevel = 0 then
                KeepAncestors:= False;
            end;

            LevelRem:= ALevel;
          end;//for j

          // Ready to build the treeview. If the "search string" is empty, all the
          // content of List will be used to fill the treeview. Otherwise, a filtered
          // list containing only the matched items and their parent will populate
          // the treeview.
          //JvCheckTreeView1.Items.Clear;
          //JvCheckTreeView1.Items.BeginUpdate;

          ANode := JvCheckTreeView1.Items.AddChild(nil, FSearchParamList.Strings[i]);

          case ASortMethod of
            smSystem: LoadParameter2SystemTV(ANode, TEngineParameter(FSearchParamList.Objects[i]));
            smSensor: LoadParameter2SensorTV(ANode, TEngineParameter(FSearchParamList.Objects[i]));
          end;//case

        end;//for i

      finally
        //JvCheckTreeView1.Items.EndUpdate;
        if FParamSearchMode then
          JvCheckTreeView1.FullExpand;
      end;
    except
      Invalidate;  // force repaint on exception
      raise;
    end;
  end//if FParamSearchMode
  else
  begin
    JvCheckTreeView1.Items.Clear;

    for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
    begin
      LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig;
      ANode := JvCheckTreeView1.Items.AddChild(nil, FProjectFile.ProjectFileCollect.Items[i].ProjectItemName);

      case FCurrentSortMethod of
        smSystem: LoadParameter2SystemTV(ANode, LHiMECSConfig.EngineParameter);
        smSensor: LoadParameter2SensorTV(ANode, LHiMECSConfig.EngineParameter);
      end;//case
    end;//
    //JvCheckTreeView1.FullExpand;
  end;
end;

procedure TMainForm.LoadSearchTreeFromManualInfo(ASearchText: string;
  ASortMethod: TManualSortMethod);
var
  LHiMECSManualInfo: THiMECSManualInfo;
  ANode, NextNode: TTreeNode;
  ALevel, i, j, LParentRem: Integer;
  CurrStr, LStr: string;
  Keep, KeepParent, KeepAncestors: Boolean;
  LevelRem: Integer;
  LHiMECSConfig: THiMECSConfig;
  LSearchMode: Boolean;
  LSearchManualList: TStringList;

  function GetBufStart(Buffer: string; var Level: Integer): string;
  var
    Pos: Integer;
  begin
    Pos := 1;
    Level := 0;
    while (CharInSet(Buffer[Pos], [' ', #9])) do
    begin
      Inc(Pos);
      Inc(Level);
    end;
    Result := Copy(Buffer, Pos, Length(Buffer) - Pos + 1);
  end;

begin
  ManualCheckTV.Items.Clear;

  ASearchText:= Lowercase(ASearchText); // insures a case insensitive search
  LSearchMode:= Length(ASearchText) <> 0; // true searcxh box not empty

  if LSearchMode then
  begin
    try
      LSearchManualList := TStringList.Create;
      try
        for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
        begin
          LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig;
          LHiMECSManualInfo := THiMECSManualInfo.Create(Self);
          LHiMECSManualInfo.Assign(LHiMECSConfig.ManualInfo);
          LSearchManualList.AddObject(FProjectFile.ProjectFileCollect.Items[i].ProjectItemName, LHiMECSManualInfo);
        end;

        // Search algorithm
        LevelRem:= 0; // 26 May 2011
        KeepParent:= false;

        for i := 0 to LSearchManualList.Count - 1 do
        begin
          LHiMECSManualInfo := THiMECSManualInfo(LSearchManualList.Objects[i]);

          for j := LHiMECSManualInfo.OpManual.Count - 1 downto 0 do // List is scanned from bottom to top
          begin
            LStr := LHiMECSManualInfo.OpManual.Items[j].PartDesc_Eng;
            CurrStr := GetBufStart(LStr, ALevel);
            CurrStr:= Lowercase(CurrStr); // insures a case insensitive search

            if ALevel >= LevelRem then // node is a leaf
            begin
              Keep:= pos(ASearchText, CurrStr) > 0; // Search string found if true

              if Keep then
              begin
                KeepParent:= true; // parent branch must be kept
                KeepAncestors:= true;
                LParentRem:= ALevel - 1;
              end
              else
                LHiMECSManualInfo.OpManual.Delete(j);
            end; // if ALevel = LevelRem

            if ALevel = LevelRem - 1 then // node is a branch
            begin
              KeepParent:= false;
              if KeepAncestors and (ALevel = LParentRem) then
              begin
                KeepParent:= true;
                LParentRem:= LParentRem - 1;
              end;

              if not KeepParent then
                LHiMECSManualInfo.OpManual.Delete(j)
              else if ALevel = 0 then
                KeepAncestors:= False;
            end;

            LevelRem:= ALevel;
          end;//for j

          ANode := ManualCheckTV.Items.AddChild(nil, LSearchManualList.Strings[i]);

          case ASortMethod of
            msmMSNo: LoadManualInfo2MsNoTV(ANode, THiMECSManualInfo(LSearchManualList.Objects[i]));
            msmPlateNo: LoadManualInfo2PlateNoTV(ANode, THiMECSManualInfo(LSearchManualList.Objects[i]));
          end;//case
        end;//for i

      finally
        LSearchManualList.Free;

        if FParamSearchMode then
          ManualCheckTV.FullExpand;
      end;
    except
      Invalidate;  // force repaint on exception
      raise;
    end;
  end//if FParamSearchMode
  else
  begin
    ManualCheckTV.Items.Clear;

    for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
    begin
      LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig;
      ANode := ManualCheckTV.Items.AddChild(nil, FProjectFile.ProjectFileCollect.Items[i].ProjectItemName);

      case FCurrentSortMethod of
        smSystem: LoadParameter2SystemTV(ANode, LHiMECSConfig.EngineParameter);
        smSensor: LoadParameter2SensorTV(ANode, LHiMECSConfig.EngineParameter);
      end;//case
    end;//
  end;
end;

//AType = 1: MonitorListTile
//        2: CommListTile
procedure TMainForm.LoadTileConfig2Form(AConfigF: TTileConfigF; AType: integer);
begin
  if AType = 1 then
  begin
    AConfigF.RowNumEdit.Text := IntToStr(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSMonitor.TileRowNum);
    AConfigF.ColNumEdit.Text := IntToStr(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSMonitor.TileColNum);
  end
  else
  if AType = 2 then
  begin
    AConfigF.RowNumEdit.Text := IntToStr(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSAutoRun.TileRowNum);
    AConfigF.ColNumEdit.Text := IntToStr(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSAutoRun.TileColNum);
  end;
end;

//AType = 1: MonitorListTile
//        2: CommListTile
procedure TMainForm.LoadTileConfigForm2Collect(AConfigF: TTileConfigF; AType: integer);
begin
  if AType = 1 then
  begin
    FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSMonitor.TileRowNum := StrToIntDef(AConfigF.RowNumEdit.Text, 3);
    FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSMonitor.TileColNum := StrToIntDef(AConfigF.ColNumEdit.Text, 1);
  end
  else
  if AType = 2 then
  begin
    FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSAutoRun.TileRowNum := StrToIntDef(AConfigF.RowNumEdit.Text, 3);
    FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSAutoRun.TileColNum := StrToIntDef(AConfigF.ColNumEdit.Text, 1);
  end;
end;

procedure TMainForm.LoadMonitorTileFromFile(AFileName: string; AIsAppend: Boolean;
  AHiMECSMonitorList: THiMECSMonitorList);
var
  lTile : TAdvSmoothTile;
  i: integer;
begin
  SetCurrentDir(FApplicationPath);

  if not FileExists(AFileName) then
  begin
    ShowMessage('File not exist : '+ AFileName + ' (From .mlist)');
    exit;
  end;

  if not AIsAppend then
  begin
    AHiMECSMonitorList.MonitorListCollect.Clear;
    MonTileListFrame.tileList.Tiles.Clear;
  end;

  AHiMECSMonitorList.LoadFromJSONFile(AFileName);

  for i := 0 to AHiMECSMonitorList.MonitorListCollect.Count - 1 do
  begin
    lTile := MonTileListFrame.tileList.Tiles.Add;
    LoadMonitorVar2Form(lTile,AHiMECSMonitorList.MonitorListCollect.Items[i]);
  end; //for
end;

function TMainForm.LoadUserFileName(AFileName, AUserId, APasswd: string): Boolean;
var
  i: integer;
begin
  if not FileExists(AFileName) then
  begin
    ShowMessage('File: ' + AFileName + ' not exist! (From .himecs file''s UserFile)');
    exit;
  end;

  FHiMECSUser.LoadFromFile(AFileName,
                        ExtractFileName(AFileName),
                        True);

//  if FHiMECSUser.UpdateWhenStart then
//  begin
//    if DoExternalUpdate(FHiMECSUSer.AutoUpdateFileName, True) then
//      exit;
//  end;

  for i := 0 to FHiMECSUser.HiMECSUserCollect.Count - 1 do
  begin
    if (FHiMECSUser.HiMECSUserCollect.Items[i].UserID = AUserId) and
      (FHiMECSUser.HiMECSUserCollect.Items[i].Password = APasswd) then
    begin
      FCurrentUserIndex := i;
      FCurrentUserLevel := FHiMECSUser.HiMECSUserCollect.Items[i].UserLevel;

      StatusBarPro1.Panels[2].Text := AUserId;
      StatusBarPro1.Panels[3].Text := UserLevel2String(FHiMECSUser.HiMECSUserCollect.Items[i].UserLevel);

      Result := True;
      Break;
    end
  end;//for

end;

procedure TMainForm.LoadMonitorVar2ConfigForm(AForm: TnewMonApp_Frm;
  AVar: THiMECSMonitorListItem);
begin
  with AForm do
  begin
    appTitle.Text := AVar.MonitorTitle;
    AutoRunCB.Checked := AVar.IsAutoLoad;
    appPath.Text := AVar.MonitorFileName;
    appDesc.Text := AVar.MonitorDesc;
    ProgNameEdit.Text := AVar.RunProgramName;
    RunParamEdit.Text := AVar.RunParameter;

    with GDIPPictureContainer1.Items do
    begin
      Clear;
      Add;
      if AVar.MonitorImage <> '' then
      begin
        Items[Count-1].Picture.LoadFromStream(MonTileListFrame.ConvertString2Stream(AVar.MonitorImage));
        Icon.Picture.Assign(Items[Count-1].Picture);
        Icon.Invalidate;
      end;
    end;
  end;
end;

procedure TMainForm.LoadMonitorVar2Form(ATile: TAdvSmoothTile;
  AVar: THiMECSMonitorListItem);
begin
  with ATile do
  begin
    Content.Text := AVar.MonitorTitle;
    Content.TextPosition := tpBottomCenter;

    if AVar.IsAutoLoad then
      StatusIndicator := 'Auto'
    else
      StatusIndicator := '';

    Content.Hint := AVar.MonitorFileName;
    DisplayName := AVar.MonitorDesc;
    ItemOject := AVar;

    if AVar.MonitorImage <> '' then
      Content.Image.LoadFromStream(MonTileListFrame.ConvertString2Stream(AVar.MonitorImage));
  end;

  TileConfigChange(1);
end;

procedure TMainForm.LoadWatchListAll;
var
  LStrLst: TStringList;
  LProgName, LParam: string;
  i: integer;
begin
  //LStrLst := TStringList.Create;
  try
    LStrLst := GetFileListFromDir('.\WatchList\', '*.*', false);
    for i := 0 to LStrLst.Count - 1 do
    begin
      if not CheckWatchListOfSummary(LStrLst.Strings[i]) then
        Continue;

      LProgName := ExtractFileName(LStrLst.Strings[i]);
      if Pos('_', LProgName) > 0 then
        continue;
      //FEngineParameter.LoadFromFile(LStrLst.Strings[i]);
      //LProgName := '.\Applications\' + FEngineParameter.ExeName;
      LProgName := System.Copy(LProgName,1,1);
      if LProgName = '1' then
        LProgName := '.\Applications\' + HiMECSWatchName2
      else
      if LProgName = '2' then
        LProgName := '.\Applications\' + HiMECSWatchSaveName;

      LParam := '/p' + ExtractFilename(LStrLst.Strings[i]);
      ExecLaunchList(LProgName, LParam);//, FMonitorHandles);
    end;//for

  finally
    LStrLst.Free;
  end;
end;

procedure TMainForm.LoginClick;
begin
  Init(False);
end;

function TMainForm.LoginProcess(AAutoLogin: Boolean = false;
  AUserId: string = ''; APasswd: string = ''): Boolean;
var
  LUserID, LPasswd, LUserFileName: string;
begin
  Result := False;

  if Assigned(FHiMECSUser) then
    FHiMECSUser.HiMECSUserCollect.Clear
  else
    FHiMECSUser := THiMECSUser.Create(nil);

  if FUserFileName = '' then
    FUserFileName := '.\config\'+DefaultUserFileName;

  if AAutoLogin then
  begin
    Result := LoadUserFileName(FUserFileName, AUserId, APasswd);
    exit;
  end;

  while true do
  begin
    if TFrmLogin.Execute(LUserID, LPasswd, LUserFileName) = mrOK then
    begin
      if LUserFileName <> '' then
        FUserFileName := LUserFileName;

      Result := LoadUserFileName(FUserFileName, LUserID, LPasswd);

      if Result then
      begin
        break;
      end
      else
      begin
        ShowMessage('Incorrect UserID or Password.' + #13#10#13#10 + 'Try input again.');
        continue;
      end;
    end//if
    else
      break;
  end;//while
end;

procedure TMainForm.LogOutProcess;
var
  i: integer;
begin
  LoadMenuFromFile(DefaultMenuFileNameOnLogOut, True);
  DestroyProc;

  //for i := 0 to EngineInfoInspector.Items.Count - 1 do
  //  EngineInfoInspector.Items[i].Clear;
  NxTextItem1.Clear;
  NxTextItem2.Clear;
  NxTextItem3.Clear;
  NxTextItem4.Clear;
  ComponentsNxItem.Clear;
  StatusBarPro1.Panels[2].Text := 'Log out';
  StatusBarPro1.Panels[3].Text := '';
  JvCheckTreeView1.Items.Clear;
  EngineInfoInspector.PopupMenu := nil;
  JvCheckTreeView1.PopupMenu := nil;
  MonTileListFrame.tileList.Tiles.Clear;
  CommTileListFrame.tileList.Tiles.Clear;
  //Init(False);
end;

procedure TMainForm.ManualCheckTVDblClick(Sender: TObject);
var
  LNode: TTreeNode;
  LForm: TForm;
  LObj: variant;
  LArgs: string;
  i,j: integer;
begin
  LNode := ManualCheckTV.GetNodeAt( FMouseClickManualTV_X, FMouseClickManualTV_Y );

  if not FControlPressedManualTV then
  begin
    if Assigned(LNode) then
    begin
      LArgs := '';

      if TObject(LNode.Data) is THiMECSOpManualItem then
      begin
        TDocVariant.New(LObj);
        LObj.FileName := IncludeTrailingPathDelimiter(THiMECSOpManualItem(LNode.Data).FilePath) +
          THiMECSOpManualItem(LNode.Data).FileName;
        LObj.PageNo := THiMECSOpManualItem(LNode.Data).PageNo;
        LArgs := VariantSaveJson(LObj);
        LForm := CreateMIDChild(TPDFViewF, LArgs);
      end;

    end;

    FControlPressedManualTV := False;
  end;
//  else
//    Property1Click(ManualCheckTV);
end;

procedure TMainForm.ManualCheckTVKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
//    vk_delete: DeleteItem1Click(JvCheckTreeView1);
    vk_control: FControlPressedManualTV := True;
  end;

end;

procedure TMainForm.ManualCheckTVKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
//    vk_delete: DeleteItem1Click(JvCheckTreeView1);
    vk_control: FControlPressedManualTV := False;
  end;
end;

procedure TMainForm.ManualCheckTVMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMouseClickManualTV_X := X;
  FMouseClickManualTV_Y := Y;

//  FControlPressedManualTV := not(ssCtrl in Shift);
end;

procedure TMainForm.MDIClientProc(var Msg: TMessage);
var
  rc: TRect;
begin
  Msg.Result := CallWindowProc(FOldClient, ClientHandle, Msg.Msg, Msg.WParam, Msg.LParam);

  if (Msg.Msg = WM_SIZE) then
  begin
    if GetWindowRect(ClientHandle, rc) then
    begin
      //MDIPanel.Left := (RectWidth(rc) - MDIPanel.Width) div 2;
      //MDIPanel.Top := (RectHeight(rc) - MDIPanel.Height) div 2;
      //MDIPanel.Invalidate;
    end;
  end;
end;

procedure TMainForm.MenuItem1Click(Sender: TObject);
begin
  MenuItem1.Checked := not MenuItem1.Checked;
  AdvOfficeMDITabSet1.Visible := MenuItem1.Checked;
end;

procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
  ProjectInfoInspector.CollapseAll;
end;

procedure TMainForm.MenuItem5Click(Sender: TObject);
begin
  ProjectInfoInspector.ExpandAll;
end;

procedure TMainForm.MenuItem7Click(Sender: TObject);
begin
  MonTileListFrame.SaveTile2File(TpjhBase(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSMonitor));
end;

{
procedure TMainForm.MoveEngineParameterItemRecord(var ASourceRecord: TEngineParameterItemRecord;
  AEPItemRecord: TEngineParameterItem);
begin
  ASourceRecord.FLevelIndex := AEPItemRecord.LevelIndex;
  ASourceRecord.FNodeIndex := AEPItemRecord.NodeIndex;
  ASourceRecord.FAbsoluteIndex := AEPItemRecord.AbsoluteIndex;
  ASourceRecord.FMaxValue := AEPItemRecord.MaxValue;
  ASourceRecord.FContact := AEPItemRecord.Contact;
  ASourceRecord.FBlockNo := AEPItemRecord.BlockNo;

  ASourceRecord.FSharedName := AEPItemRecord.SharedName;
  ASourceRecord.FTagName := AEPItemRecord.Tagname;
  ASourceRecord.FDescription := AEPItemRecord.Description;
  ASourceRecord.FAddress := AEPItemRecord.Address;
  ASourceRecord.FFCode := AEPItemRecord.FCode;
  ASourceRecord.FUnit := AEPItemRecord.FFUnit;
  ASourceRecord.FMinMaxType := AEPItemRecord.MinMaxType;
  ASourceRecord.FAlarm := AEPItemRecord.Alarm;
  ASourceRecord.FRadixPosition := AEPItemRecord.RadixPosition;

  ASourceRecord.FSensorType := AEPItemRecord.SensorType;
  ASourceRecord.FParameterCatetory := AEPItemRecord.ParameterCatetory;
  ASourceRecord.FParameterType := AEPItemRecord.ParameterType;
  ASourceRecord.FParameterSource := AEPItemRecord.ParameterSource;

  ASourceRecord.FMinAlarmEnable := AEPItemRecord.MinAlarmEnable;
  ASourceRecord.FMaxAlarmEnable := AEPItemRecord.MaxAlarmEnable;
  ASourceRecord.FMinFaultEnable := AEPItemRecord.MinFaultEnable;
  ASourceRecord.FMaxFaultEnable := AEPItemRecord.MaxFaultEnable;

  ASourceRecord.FMinAlarmValue := AEPItemRecord.MinAlarmValue;
  ASourceRecord.FMaxAlarmValue := AEPItemRecord.MaxAlarmValue;
  ASourceRecord.FMinFaultValue := AEPItemRecord.MinFaultValue;
  ASourceRecord.FMaxFaultValue := AEPItemRecord.MaxFaultValue;

  ASourceRecord.FMinAlarmColor := AEPItemRecord.MinAlarmColor;
  ASourceRecord.FMaxAlarmColor := AEPItemRecord.MaxAlarmColor;
  ASourceRecord.FMinFaultColor := AEPItemRecord.MinFaultColor;
  ASourceRecord.FMaxFaultColor := AEPItemRecord.MaxFaultColor;

  ASourceRecord.FMinAlarmBlink := AEPItemRecord.MinAlarmBlink;
  ASourceRecord.FMaxAlarmBlink := AEPItemRecord.MaxAlarmBlink;
  ASourceRecord.FMinFaultBlink := AEPItemRecord.MinFaultBlink;
  ASourceRecord.FMaxFaultBlink := AEPItemRecord.MaxFaultBlink;

  ASourceRecord.FMinAlarmSoundEnable := AEPItemRecord.MinAlarmSoundEnable;
  ASourceRecord.FMaxAlarmSoundEnable := AEPItemRecord.MaxAlarmSoundEnable;
  ASourceRecord.FMinFaultSoundEnable := AEPItemRecord.MinFaultSoundEnable;
  ASourceRecord.FMaxFaultSoundEnable := AEPItemRecord.MaxFaultSoundEnable;

  ASourceRecord.FMinAlarmSoundFilename := AEPItemRecord.MinAlarmSoundFilename;
  ASourceRecord.FMaxAlarmSoundFilename := AEPItemRecord.MaxAlarmSoundFilename;
  ASourceRecord.FMinFaultSoundFilename := AEPItemRecord.MinFaultSoundFilename;
  ASourceRecord.FMaxFaultSoundFilename := AEPItemRecord.MaxFaultSoundFilename;

  ASourceRecord.FAllowUserLevelWatchList := FCurrentUserLevel;

  ASourceRecord.FIsDisplayTrend := AEPItemRecord.IsDisplayTrend;
  ASourceRecord.FIsDisplaySimple := AEPItemRecord.IsDisplaySimple;
  ASourceRecord.FTrendChannelIndex := AEPItemRecord.TrendChannelIndex;
  ASourceRecord.FPlotXValue := AEPItemRecord.PlotXValue;
  ASourceRecord.FMinValue := AEPItemRecord.MinValue;
  ASourceRecord.FMinValue_Real := AEPItemRecord.MinValue_Real;
  ASourceRecord.FYAxesMinValue := AEPItemRecord.YAxesMinValue;
  ASourceRecord.FYAxesSpanValue := AEPItemRecord.YAxesSpanValue;

  ASourceRecord.FProjectFileName := FProjectFile.ProjectFileName;
end;
}

procedure TMainForm.MonTileListFrametileListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSelectedTile := MonTileListFrame.TileList;
end;

procedure TMainForm.MonTileListFrametileListTileDblClick(Sender: TObject;
  ATile: TAdvSmoothTile; State: TTileState);
begin
  ShowWindowFromSelectedMonTile(SW_RESTORE);
end;

procedure TMainForm.MoveMatrixData2ItemRecord(
  var ARecord: TEngineParameterItemRecord; AEPItem: TEngineParameterItem);
var
  LIdx: integer;
  LHiMECSConfig: THiMECSConfig;
begin
  if AEPItem.ParameterType in TMatrixTypes then
  begin
    LIdx := AEPItem.MatrixItemIndex;
    LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
    LHiMECSConfig.EngineParameter.MatrixCollect.Items[LIdx].AssignTo(ARecord);
  end;

end;

//TreeView의 노드들 이동시킴(서브 노드 포함)
procedure TMainForm.MoveNode(ATreeView: TTreeView; ATargetNode, ASourceNode: TTreeNode);
var
  LNode: TTreeNode;
  i: integer;
begin
  With ATreeView do
  begin
    LNode := Items.AddChild(ATargetNode, ASourceNode.Text);
    for i := 0 to ASourceNode.Count - 1 do
    begin
      MoveNode(ATreeView, LNode, ASourceNode.Item[i]);
    end;
  end;
end;

procedure TMainForm.Edit2Change(Sender: TObject);
begin
  LoadSearchTreeFromEngParam(Edit2.Text, FCurrentSortMethod);
end;

procedure TMainForm.ManualSearchEditChange(Sender: TObject);
begin
  LoadSearchTreeFromManualInfo(ManualSearchEdit.Text);
end;

procedure TMainForm.EditProcessKillList;
var
  LForm: TKillProcessListF;
  LFileName: string;
  i, j: integer;
begin
  //LForm := CreateOrShowMDIChild(TKillProcessListF);
  LForm := TKillProcessListF.Create(Self);

  if Assigned(LForm) then
  begin
    try
      for i := 0 to FKillProcessList.KillProcessListCollect.Count - 1 do
      begin
        j := TKillProcessListF(LForm).ProcessLB.Items.Add(
          FKillProcessList.KillProcessListCollect.Items[i].ProcessName);
        TKillProcessListF(LForm).ProcessLB.Checked[j] :=
          FKillProcessList.KillProcessListCollect.Items[i].KillEnable;
      end;

      if LForm.ShowModal = mrOK then
      begin
        if TKillProcessListF(LForm).ProcessLB.Items.Count > 0 then
          FKillProcessList.KillProcessListCollect.Clear;

        for i := 0 to TKillProcessListF(LForm).ProcessLB.Items.Count - 1 do
        begin
          with FKillProcessList.KillProcessListCollect.Add do
          begin
            ProcessName := TKillProcessListF(LForm).ProcessLB.Items[i];
            KillEnable := TKillProcessListF(LForm).ProcessLB.Checked[i];
          end;
        end;//for

        if FKillProcessList.KillProcListFileName <> '' then
          FKillProcessList.SaveToJSONFile(FKillProcessList.KillProcListFileName);
      end;

    finally
      LForm.Free;
    end;
  end;
end;

procedure TMainForm.EngineInfoInspectorAfterEdit(Sender: TObject;
  Item: TNxPropertyItem);
var
  LStr: string;
  LHiMECSConfig: THiMECSConfig;
begin
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;

  if Item.Name = 'CylinderCount' then
    LHiMECSConfig.EngineInfo.CylinderCount := Item.AsInteger
  else
  if Item.Name = 'Bore' then
    LHiMECSConfig.EngineInfo.Bore := Item.AsInteger
  else
  if Item.Name = 'Stroke' then
    LHiMECSConfig.EngineInfo.Stroke := Item.AsInteger
  else
  if Item.Name = 'FuelType' then
    LHiMECSConfig.EngineInfo.FuelType := String2FuelType(Item.AsString)
  else
  if Item.Name = 'CylinderConfiguration' then
    LHiMECSConfig.EngineInfo.CylinderConfiguration := String2CylinderConfiguration(Item.AsString);

  LStr := GetEngineType(FCOI);
  EngineInfoInspector.items.ItemByName['EngineType'].AsString := LStr;

  EngineInfoInspector.Invalidate;
end;

procedure TMainForm.EngineInfoInspectorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EngineInfoInspector.Invalidate;
end;

procedure TMainForm.EngineInfoInspectorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EngineInfoInspector.Invalidate;
end;

procedure TMainForm.EngineInfoInspectorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  EngineInfoInspector.Invalidate;
end;

procedure TMainForm.EngineInfoInspectorMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
//  EngineInfoInspector.Invalidate;
end;

procedure TMainForm.NxButtonItemButtonClick(Sender: TNxPropertyItem);
var
  i: integer;
begin
  if Sender.Caption = 'Generator' then
  begin
    CreateOrShowChildFormFromBpl('GeneratorInfo',i);
  end
  else
    ShowMessage('No additional information!');
end;

procedure TMainForm.OnExecuteRequest(const Request, Response: IIPCData);
var
  Command: AnsiString;
begin
  Command := Request.Data.ReadUTF8String('Command');
  //ListBox1.Items.Add(Format('%s Request Recieved (Sent at: %s)', [Command, Request.ID]));

  Response.Data.WriteDateTime('TDateTime', Now);
  Response.Data.WriteInteger('Integer', 5);
  Response.Data.WriteReal('Real', 5.33);
  Response.Data.WriteUTF8String('String', 'to je testni string');
  //Caption := Format('%d requests processed', [FRequestCount]);
end;

procedure TMainForm.OnProcessKill(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  ExecProcessKill;
end;

procedure TMainForm.OnSendData2Watch(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  LHandle: THandle;
begin
  FPJHTimerPool.RemoveAll;
end;

procedure TMainForm.OpenProject;
begin
  if not Assigned(FMenuBase) then
    FMenuBase := TMenuBase.Create(Self);

  ProcessSelectProject(False);
//    FIsProjectClosed := False;
end;

procedure TMainForm.Options1Click(Sender: TObject);
begin
  SetConfigData(Sender);
end;

//Menu file에서 Bpl 파일 이름을 가져온 후 메뉴 클릭시 실행 됨
procedure TMainForm.PackageLoadFromMenu;
begin

end;

procedure TMainForm.PackageLoad_Exe;
var
  i: integer;
  LStr: string;
  LHiMECSConfig: THiMECSConfig;
begin
  SetCurrentDir(FApplicationPath);
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
  LStr := LHiMECSConfig.ExesPath;

  FHiMECSExes.ExeCollect.Clear;
  FHiMECSExes.LoadFromFile(LStr + DefaultExesFileName,DefaultExesFileName,True);

  for i := 0 to FHiMECSExes.ExeCollect.Count - 1 do
    AddExeToList(FHiMECSExes.ExeCollect.Items[i].ExeName);
end;

procedure TMainForm.PackageLoad_MDIChild;
var
  i: integer;
  LStr: string;
  LHiMECSConfig: THiMECSConfig;
begin
  SetCurrentDir(FApplicationPath);
  LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
  LStr := IncludeTrailingPathDelimiter(LHiMECSConfig.ConfigPath);

  if FileExists(LStr+DefaultFormsFileName) then
  begin
    FHiMECSForms.PackageCollect.Clear;
    FHiMECSForms.LoadFromFile(LStr+DefaultFormsFileName,DefaultFormsFileName,True);
    SetLength(FPackageModules, FHiMECSForms.PackageCollect.Count);
    SetLength(FCreateChildFromBPL, FHiMECSForms.PackageCollect.Count);

    LStr := IncludeTrailingPathDelimiter(LHiMECSConfig.HiMECSFormPath);

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
  end;

end;

procedure TMainForm.PanelMsgProc(var Msg: TMessage);
begin
  if (Msg.Msg = WM_CHILDACTIVATE) then
    //MDIPanel.SendToBack;

  FOldPanelProc(Msg);
end;

procedure TMainForm.ParameterItem2ParamList(ANode: TTreeNode; AForm: TForm);
var
  i,j: integer;
  LMatrixItem: TMatrixItem;
  LHiMECSConfig: THiMECSConfig;
begin
  TEngineParameterItem(ANode.Data).AssignTo(FEngineParameterItemRecord);
  //TFormParamList(AForm).Parameter2Grid(FEngineParameterItemRecord);
  j := TFormParamList(AForm).CreateIPCMonitor(FEngineParameterItemRecord, False);

  if j = -1 then
    j := TFormParamList(AForm).IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1;

  if TEngineParameterItem(ANode.Data).IsMatrixData then
  begin
    LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
    i := TEngineParameterItem(ANode.Data).MatrixItemIndex;
    LMatrixItem := LHiMECSConfig.EngineParameter.MatrixCollect.Items[i];
    i := TFormParamList(AForm).AssignMatrixItem(LMatrixItem);
    TFormParamList(AForm).SetNodeIndex(j,i);
  end;
end;

function TMainForm.ProcessInputParameter(var AUserID, APasswd, APrjFileName: string):Boolean;
var
  i,j: integer;
  LStr: string;
  LHiMECSUser: THiMECSUser;
begin
  for i := 1 to ParamCount do
  begin
    LStr := ParamStr(i);
    j := Pos('/UF', UpperCase(LStr)); //User File Parameter(.id)

    if j > 0 then  //UF 제거
    begin
      LStr := Copy(LStr, j+3, Length(LStr)-j-1);

      if FileExists(LStr) then
      begin
        try
          LHiMECSUser := THiMECSUser.Create(nil);
          LHiMECSUser.LoadFromJSONFile( LStr,
                                    ExtractFileName(LStr),
                                    True);

          if LHiMECSUser.HiMECSUserCollect.Count > 0 then
          begin
            AUserID := LHiMECSUser.HiMECSUserCollect.Items[0].UserID;
            APasswd := LHiMECSUser.HiMECSUserCollect.Items[0].Password;
          end;
        finally
          LHiMECSUser.HiMECSUserCollect.Clear;
          FreeAndNil(LHiMECSUser);
        end;
      end
      else
        ShowMessage('User File from param does not exists: ' + #13#10 + LStr);
    end
    else
    begin
      j := Pos('/PF', UpperCase(LStr)); //Project File Name Parameter(.himecs)
      if j > 0 then
      begin ///PF 제거
        LStr := Copy(LStr, j+3, Length(LStr)-j-1);

        if FileExists(LStr) then
        begin
          APrjFileName := LStr;
        end
        else
          ShowMessage('Project File from param does not exists: ' + #13#10 + LStr);
      end;
    end;
  end;
end;

procedure TMainForm.ExecProcessKill;
var
  i: integer;
  LProcName: string;
begin
  for i := 0 to FKillProcessList.KillProcessListCollect.Count - 1 do
  begin
    if not FKillProcessList.KillProcessListCollect.Items[i].KillEnable then
      Continue;

    LProcName := FKillProcessList.KillProcessListCollect.Items[i].ProcessName;

    if IsRunningProcess(LProcName) then
    begin
      KillProcess(LProcName);
      DisplayMessage('Process: ' + LProcName + ' kill Succeeded!', mstFile,mtInformation);
    end;
  end;
end;

function TMainForm.ProcessSelectProject(AFirstLoad: Boolean;
  AAutoStart: Boolean = False; APrjFileName: string=''): Boolean;
var
  LStr: String;
  i: integer;
begin
  Result := SelectProject(APrjFileName);

  if not Result  then
  begin
    if AFirstLoad then //처음 로그인 후 실행 됨
    begin
      SetCurrentDir(FApplicationPath);
      LoadMenuFromFile(DefaultMenuFileNameOnLogIn, True);
    end
    else  //Open Project후에 reopen 할때
    begin

    end;

    exit;
  end;

  LStr := IncludeTrailingBackslash(ExtractRelativePath(
                            ExtractFilePath(Application.ExeName),
                            ExtractFilePath(FProjectFile.ProjectFileName)))+
                            ExtractFileName(FProjectFile.ProjectFileName);
  if System.Pos('.\', LStr) = 0 then
    LStr := '.\' + LStr;

  //상대경로를 저장함
  if FProjectFile.ProjectFileName = '' then
    FProjectFile.ProjectFileName := LStr;

  SetCurrentDir(FApplicationPath);

  //AdvSmoothSplashScreen1.Show;
  AdvSmoothSplashScreen1.BeginUpdate;

  LStr := AdvSmoothSplashScreen1.BasicProgramInfo.ProgramVersion.Text;

  if Pos('Version', LStr) = 0 then
    AdvSmoothSplashScreen1.BasicProgramInfo.ProgramVersion.Text := 'Version: '+ AdvSmoothSplashScreen1.BasicProgramInfo.ProgramVersion.Text;

  AdvSmoothSplashScreen1.BasicProgramInfo.ProgramVersion.Location := ilCustom;
  AdvSmoothSplashScreen1.BasicProgramInfo.ProgramVersion.PosX := 365;
  AdvSmoothSplashScreen1.EndUpdate;
  AdvSmoothSplashScreen1.ListItemsSettings.Rect.Left := 100;
  AdvSmoothSplashScreen1.ListItemsSettings.Rect.Top := 180;
  AdvSmoothSplashScreen1.ListItemsSettings.Rect.Height := 50;

  FFirst := True;

  FDragFormatTarget := TGenericDataFormat.Create(DropTextTarget1);
  FDragFormatTarget.AddFormat(sDragFormatParam);

  FEngParamSource := TEngineParameterDataFormat.Create(EngParamSource);

  //FEngParamSource.AddFormat(sDragFormatParam);

  //FHiMECSFormPath := '..\bpl\';
  if not ForceDirectories('.\config\') then
    ShowMessage('Creation fail for '+FApplicationPath+'\config\ folder!');

  try
    for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
    begin
      if ExtractFileName(FProjectFile.ProjectFileCollect.Items[i].OptionsFileName) = '' then
        FProjectFile.ProjectFileCollect.Items[i].OptionsFileName := DefaultOptionsFileName;

      LStr := FProjectFile.ProjectFileCollect.Items[i].OptionsFileName;
      //'..' 과 '.'이 없는 경우 절대 경로 임
      if (Pos('..',LStr) = 0) and (Pos('.',LStr) = 0) then
      begin
        LStr := '.\config\' + ExtractFileName(FProjectFile.ProjectFileCollect.Items[i].OptionsFileName);
      end;

      if not FileExists(LStr) then
        AddDefaultData2File(LStr);

      //FHiMECSConfig로 Option file 로드함
      LoadConfigCollectFromFile(i);
      //FHiMECSOptions.AddFromHiMECSConfigCollect(
      //  FProjectFile.ProjectFileCollect.Items[i].OptionsFileName,
      //  FHiMECSConfig);

      //with AdvSmoothSplashScreen1.ListItems.Add do
      //begin
      //  BeginUpdate;
      //  HTMLText := '<IMG src="0"><FONT size="20" color="#A45302">Loading Options...</FONT><br>';
      //  EndUpdate;
      //end;

      UpdateProgress4Splash(10);
    end;//for
  finally
    with AdvSmoothSplashScreen1.ListItems.Add do
    begin
      BeginUpdate;
      HTMLText := '<IMG src="1"><FONT size="20" color="#A45302">Loading Menu items...</FONT><br>';
      EndUpdate;
    end;
    //LStr := IncludeTrailingPathDelimiter(FHiMECSConfig.ConfigPath);

    FCOI := 0;

    if FHiMECSUser.HiMECSUserCollect.Items[FCurrentUserIndex].MenuFileName <> '' then
      LoadMenuFromFile(FHiMECSUser.HiMECSUserCollect.Items[FCurrentUserIndex].MenuFileName, True)
    else
      LoadMenuFromFile(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.MenuFileName, True);

    UpdateProgress4Splash(20);

    with AdvSmoothSplashScreen1.ListItems.Add do
    begin
      BeginUpdate;
      HTMLText := '<IMG src="2"><FONT size="20" color="#A45302">Loading Packages...</FONT><br>';
      EndUpdate;
    end;

    PackageLoad_MDIChild;

    UpdateProgress4Splash(30);
  end;

  MenuItem1.Checked := True;//MDI Tab show

  with AdvSmoothSplashScreen1.ListItems.Add do
  begin
    BeginUpdate;
    HTMLText := '<IMG src="3"><FONT size="20" color="#A45302">Loading Engine Info...</FONT><br>';
    EndUpdate;
  end;

  //LoadEngineInfo(FHiMECSConfig.EngineInfoFileName, False);
  for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
  begin
    FCOI := i;
    try
      LoadEngineInfo(FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig.EngineInfoFileName, False);
    except

    end;
    LoadProjectInfo(FProjectFile.ProjectFileCollect.Items[i].HiMECSConfig.ProjectInfoFileName, False);
  end;

  FCOI := 0;

  if Assigned(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngineInfo) then
  begin
    SelectEngineCombo.ItemIndex := 0;
    SetEngineInfo2Inspector(0);
    EngineInfoInspector.Invalidate;
  end;

  UpdateProgress4Splash(40);

  with AdvSmoothSplashScreen1.ListItems.Add do
  begin
    BeginUpdate;
    HTMLText := '<IMG src="4"><FONT size="20" color="#A45302">Loading Engine Parameters...</FONT><br>';
    EndUpdate;
  end;

  LoadParameterList2TV(smSystem);
  LoadManualInfo2TV(msmMSNo);
  LoadKillProcess;

  UpdateProgress4Splash(100);
  FParameterDragMode := True;
  //SetLength(FWatchHandles, 1);
  FMultiWatchHandle := 0;
  EngineInfoInspector.PopupMenu := EngineInfoPopupMenu;
  JvCheckTreeView1.PopupMenu := ParamPopUp;
  AdvSmoothSplashScreen1.Hide;

  EngineInfoInspector.DoubleBuffered := False;
  AdvNavBar1.ActiveTabIndex := 0;

//  if FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.UpdateWhenStart then
//  begin
//    if DoUpdateVersion(True) then
//    begin
//      //ShowMessage('A New Version is avaliable.');
//    end;
//  end;

  {MDIPanel.Parent := nil;
  MDIPanel.ParentWindow := self.ClientHandle;
  //MDIPanel.Enabled:= False;
  MDIPanel.DoubleBuffered := true;
  FOldPanelProc := MDIPanel.WindowProc;
  MDIPanel.WindowProc := PanelMsgProc;
  FNewClient := MakeObjectInstance(MDIClientProc);
  FOldClient := Pointer(SetWindowLong(ClientHandle, GWL_WNDPROC, Integer(FNewClient)));
  }

end;

procedure TMainForm.ProgramExit;
begin
  Close;
end;

procedure TMainForm.Property1Click(Sender: TObject);
var
  LNode: TTreeNode;
  LEngineParameterItem: TEngineParameterItem;
  LIdx: integer;
begin
  LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );

  if Assigned(LNode) then
  begin
    if TObject(LNode.Data) is TEngineParameterItem then
    begin
      LEngineParameterItem := TEngineParameterItem(LNode.Data);

      if LNode.Text = 'New' then
        LEngineParameterItem.TagName := LNode.Text;

      LIdx := GetCurrentOptionIndex(LNode);

      //Property창에서 OK 버튼 누르면 True 반환 됨
      if SetConfigEngParamItemData(LEngineParameterItem, LIdx) then
        if LNode.Text = 'New' then
          LNode.Text := LEngineParameterItem.TagName;
    end
    else
    if LNode.Level = 0 then  //root node
    begin
      FCOI := LNode.Index;
      ApplyChangedProjectItem;
    end;

     // ShowMessage(IntToStr(LNode.AbsoluteIndex)+':'+IntToStr(LNode.Index)+':'+IntToStr(LNode.Level));
  end;
end;

procedure TMainForm.ReparentWindow(AHandle: HWND);
var
  I: Integer;
begin
  if AHandle<>0 then
  begin
    SetLength(FWindowList, Length(FWindowList)+1);
    I := High(FWindowList);
    FWindowList[I] := AHandle;
    Windows.SetParent(AHandle, ClientHandle);
    Inc(FMDIChildCount);
    //ActionMDICascade.Execute;
    //AdvToolBar1.AddMDIChildMenu(Result);
    //AdvOfficeMDITabSet1.AddTab(Result);
  end;
end;

function TMainForm.ReparentWindowForWindow(const WindowTitle: string): THandle;
begin
  Result := FindWindowEx(0,0,nil,PChar(WindowTitle));//FindWindow(PChar(WindowTitle), nil);
  if Result <> 0 then
    ReparentWindow(Result);
end;

procedure TMainForm.RunCommunicationManager;
var
  i: integer;
  LHiMECSConfig: THiMECSConfig;
begin
  i := -1;
  CreateOrShowChildFormFromBpl('CommunicationMonitor',i);

  if i > -1 then
  begin
    LHiMECSConfig := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig;
    TForm(MDIChildren[i]).Hint := LHiMECSConfig.ExesPath;
    TForm(MDIChildren[i]).Tag := Integer(LHiMECSConfig.ExtAppInMDI);
  end;
end;

procedure TMainForm.SaveAsConfigData;
var
  LFileName: string;
  //F : TextFile;
begin
  JvSaveDialog1.InitialDir := FApplicationPath;
  JvSaveDialog1.Filter :=  '*.option';

  if JvSaveDialog1.Execute then
  begin
    LFileName := JvSaveDialog1.FileName;

    if FileExists(LFileName) then
    begin
      if MessageDlg('File is already exist. Are you overwrite? if No press, then save is cancelled.',
                                mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        exit
      else
      begin
        //AssignFile(F, LFileName);
        //Rewrite(F);
        //CloseFile(F);
      end;
    end;

    LFileName := ChangeFileExt(LFileName, '.option');
    //FHiMECSOptions.Add2HiMECSConfigCollect(FHiMECSConfig,FCOI);
    FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.SaveToFile(LFileName, ExtractFileName(LFileName),
      FProjectFile.ProjectFileCollect.Items[FCOI].OptionFileEncrypt);
    ShowMessage(LFileName + ' is saved!');
  end;
end;

procedure TMainForm.SaveAsProject1Click(Sender: TObject);
var
  LFileName: string;
  F : TextFile;
begin
  JvSaveDialog1.InitialDir := FApplicationPath;
  JvSaveDialog1.Filter :=  '*.himecs';

  if JvSaveDialog1.Execute then
  begin
    LFileName := JvSaveDialog1.FileName;

    if FileExists(LFileName) then
    begin
      if MessageDlg('File is already exist. Are you overwrite? if No press, then save is cancelled.',
      mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        //FEngineInfoCollect.LoadFromFile(LFileName, ExtractFileName(LFileName), False)
      else
      begin
        AssignFile(F, LFileName);
        Rewrite(F);
        CloseFile(F);

        LFileName := ChangeFileExt(LFileName, '.himecs');
        FProjectFile.SaveToFile(LFileName, ExtractFileName(LFileName), True);
      end;
    end;
  end;
end;

procedure TMainForm.SaveEngineInfo(AFileName: string; AIsEncrypt: Boolean);
var
  LEngineInfo: TICEngine;
begin
  ChangeFileExt(AFileName, '.einfo');

  LEngineInfo := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngineInfo;
  EngineInfoInspector2Class(EngineInfoInspector, LEngineInfo, True);
  LEngineInfo.SaveToJsonFile(AFileName, ExtractFileName(AFileName), AIsEncrypt);
end;

procedure TMainForm.SaveEngineInfo1Click(Sender: TObject);
var
  LFileName: string;
  F : TextFile;
begin
  JvSaveDialog1.InitialDir := FApplicationPath;
  JvSaveDialog1.Filter :=  '*.einfo||*.*';

  if JvSaveDialog1.Execute then
  begin
    LFileName := JvSaveDialog1.FileName;

    if FileExists(LFileName) then
    begin
      if MessageDlg('File is already exist. Are you overwrite? if No press, then data is appended.',
      mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        //FEngineInfoCollect.LoadFromFile(LFileName, ExtractFileName(LFileName), False)
      else
      begin
        AssignFile(F, LFileName);
        Rewrite(F);
        CloseFile(F);
      end;
    end;

    SaveEngineInfo(JvSaveDialog1.FileName, False);
  end;
end;

procedure TMainForm.SaveMsg2File(AMessage: string; AMessaggeType: TMessageType);
var
  LExt: string;
begin
  AMessage := FormatDateTime('yyyy-mm-dd hh:nn:ss',now) + ' => ' + AMessage;
  LExt := 'log';

  case AMessaggeType of
    mtError: SaveData2DateFile(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.LogPath,LExt,AMessage,soFromEnd);
    mtInformation: SaveData2DateFile(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.LogPath,LExt,AMessage,soFromEnd);
    mtAlarm: ;
    mtFault: ;
    mtShutdown: ;
  end;

end;

procedure TMainForm.SaveParamTV2File(AFileName: string; AIsEncrypt: Boolean);
var
  LEngineParameter: TEngineParameter;
  LEngineParameterItem,LEngineParameterItem2: TEngineParameterItem;
  i: integer;
begin
  LEngineParameter:= TEngineParameter.Create(nil);
  try
    for i := 0 to JvCheckTreeView1.Items.Count - 1 do
    begin
      LEngineParameterItem := TEngineParameterItem(JvCheckTreeView1.Items[i].Data);
      if Assigned(LEngineParameterItem) then
      begin
        LEngineParameterItem2 := LEngineParameter.EngineParameterCollect.AddEngineParameterItem(LEngineParameterItem);
        LEngineParameterItem2.LevelIndex := JvCheckTreeView1.Items[i].Level;
        LEngineParameterItem2.NodeIndex := JvCheckTreeView1.Items[i].Index;

        {with LEngineParameter.EngineParameterCollect.Add do
        begin
          LevelIndex := JvCheckTreeView1.Items[i].Level;
          NodeIndex := JvCheckTreeView1.Items[i].Index;
          AbsoluteIndex := LEngineParameterItem.AbsoluteIndex;

          MaxValue := LEngineParameterItem.MaxValue;
          MaxValue_real := LEngineParameterItem.MaxValue_real;
          Contact := LEngineParameterItem.Contact;

          TagName := LEngineParameterItem.Tagname;
          Description := LEngineParameterItem.Description;
          Address := LEngineParameterItem.Address;
          FCode := LEngineParameterItem.FCode;
          FFUnit := LEngineParameterItem.FFUnit;
          RadixPosition := LEngineParameterItem.RadixPosition;

          SensorType := LEngineParameterItem.SensorType;
          ParameterCatetory := LEngineParameterItem.ParameterCatetory;
          ParameterType := LEngineParameterItem.ParameterType;
          ParameterSource := LEngineParameterItem.ParameterSource;

          MinAlarmEnable := LEngineParameterItem.MinAlarmEnable;
          MaxAlarmEnable := LEngineParameterItem.MaxAlarmEnable;
          MinFaultEnable := LEngineParameterItem.MinFaultEnable;
          MaxFaultEnable := LEngineParameterItem.MaxFaultEnable;

          MinAlarmValue := LEngineParameterItem.MinAlarmValue;
          MaxAlarmValue := LEngineParameterItem.MaxAlarmValue;
          MinFaultValue := LEngineParameterItem.MinFaultValue;
          MaxFaultValue := LEngineParameterItem.MaxFaultValue;

          MinAlarmColor := LEngineParameterItem.MinAlarmColor;
          MaxAlarmColor := LEngineParameterItem.MaxAlarmColor;
          MinFaultColor := LEngineParameterItem.MinFaultColor;
          MaxFaultColor := LEngineParameterItem.MaxFaultColor;

          MinAlarmBlink := LEngineParameterItem.MinAlarmBlink;
          MaxAlarmBlink := LEngineParameterItem.MaxAlarmBlink;
          MinFaultBlink := LEngineParameterItem.MinFaultBlink;
          MaxFaultBlink := LEngineParameterItem.MaxFaultBlink;

          MinAlarmSoundEnable := LEngineParameterItem.MinAlarmSoundEnable;
          MaxAlarmSoundEnable := LEngineParameterItem.MaxAlarmSoundEnable;
          MinFaultSoundEnable := LEngineParameterItem.MinFaultSoundEnable;
          MaxFaultSoundEnable := LEngineParameterItem.MaxFaultSoundEnable;

          MinAlarmSoundFilename := LEngineParameterItem.MinAlarmSoundFilename;
          MaxAlarmSoundFilename := LEngineParameterItem.MaxAlarmSoundFilename;
          MinFaultSoundFilename := LEngineParameterItem.MinFaultSoundFilename;
          MaxFaultSoundFilename := LEngineParameterItem.MaxFaultSoundFilename;
          YAxesMinValue := LEngineParameterItem.YAxesMinValue;
          YAxesSpanValue := LEngineParameterItem.YAxesSpanValue;
        end;//with}
      end;
    end;//for

    if FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngParamFileFormat = 0 then //XML format
      LEngineParameter.SaveToFile(AFileName, ExtractFileName(AFileName), AIsEncrypt)
    else
    if FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngParamFileFormat = 1 then //JSON format
      LEngineParameter.SaveToJSONFile(AFileName, ExtractFileName(AFileName), AIsEncrypt);
  finally
    LEngineParameter.Free;
  end;
end;

procedure TMainForm.SaveProjectInfo(AFileName: string; AIsEncrypt: Boolean);
var
  i,j,k:integer;
begin
  ChangeFileExt(AFileName, '.pinfo');

  FProjectInfoCollect.ProjectName := ProjectInfoInspector.items.ItemByName['FProjName'].AsString;
  FProjectInfoCollect.ProjectNo := ProjectInfoInspector.items.ItemByName['FProjNo'].AsString;
  FProjectInfoCollect.SiteName := ProjectInfoInspector.items.ItemByName['FSiteName'].AsString;
  FProjectInfoCollect.SiteNo := ProjectInfoInspector.items.ItemByName['FSiteNo'].AsString;
  FProjectInfoCollect.EngineCount := ProjectInfoInspector.items.ItemByName['FEngineNum'].AsString;
  FProjectInfoCollect.ShipOwner := ProjectInfoInspector.items.ItemByName['FShipOwner'].AsString;
  FProjectInfoCollect.ClassSociety := ProjectInfoInspector.items.ItemByName['FClassSociety'].AsString;

  FProjectInfoCollect.SaveToFile(AFileName, ExtractFileName(AFileName), AIsEncrypt);
end;

procedure TMainForm.SaveProjectInfo1Click(Sender: TObject);
var
  LFileName: string;
  F : TextFile;
begin
  JvSaveDialog1.InitialDir := FApplicationPath;
  JvSaveDialog1.Filter :=  '*.pinfo||*.*';

  if JvSaveDialog1.Execute then
  begin
    LFileName := JvSaveDialog1.FileName;

    if FileExists(LFileName) then
    begin
      if MessageDlg('File is already exist. Are you overwrite? if No press, then data is appended.',
      mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        //FEngineInfoCollect.LoadFromFile(LFileName, ExtractFileName(LFileName), False)
      else
      begin
        AssignFile(F, LFileName);
        Rewrite(F);
        CloseFile(F);
      end;
    end;

    SaveProjectInfo(JvSaveDialog1.FileName, False);
  end;
end;

procedure TMainForm.SavetoFile1Click(Sender: TObject);
var
  LFileName: string;
  F : TextFile;
begin
  JvSaveDialog1.InitialDir := FApplicationPath;
  JvSaveDialog1.Filter :=  '*.param||*.*';

  if JvSaveDialog1.Execute then
  begin
    LFileName := JvSaveDialog1.FileName;

    if FileExists(LFileName) then
    begin
      if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까? No를 누르면 기존자료에 추가됨.',
      mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        //FEngineInfoCollect.LoadFromFile(LFileName, ExtractFileName(LFileName), False)
      else
      begin
        AssignFile(F, LFileName);
        Rewrite(F);
        CloseFile(F);
      end;
    end;

    SaveParamTV2File(JvSaveDialog1.FileName, FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngParamEncrypt);
  end;
end;

procedure TMainForm.SelectEngineComboCloseUp(Sender: TNxPropertyItem);
begin
  FCOI := SelectEngineCombo.ItemIndex;
  SetEngineInfo2Inspector(SelectEngineCombo.ItemIndex);
  SetAutoRunList2Inspector(SelectEngineCombo.ItemIndex);
end;

//Project Select 해서 Project File Read 성공하면 True return
//Cancel Button 누르거나 Project File Read 실패하면 False return
//AProjectFileName <> '' : AutoLogin 되어 Param으로 부터 파일이름 입력 받는 경우 임.
function TMainForm.SelectProject(AProjectFileName: string=''): Boolean;
var
  LSelectProjectForm: TSelectProjectForm;
  LFileName: string;
  i: integer;
begin
  Result := False;
  //SetCurrentDir(FApplicationPath+'projects\');

  if AProjectFileName <> '' then
  begin
    i := Pos('projects\',AProjectFileName);

    if i = 0 then
    begin
      AProjectFileName := '.\projects\' + ExtractFileName(AProjectFileName);
    end;

    if SubProcessSelectProject(AProjectFileName) then
    begin
      Result := True;
    end
    else
      ShowMessage('Current user is not allowed to access this project file');

    exit;
  end;

  LSelectProjectForm := TSelectProjectForm.Create(Self);
  try
    with LSelectProjectForm do
    begin
      FExecFromHiMECS := True;

      ListData2LV('.\projects\*.himecs');

      CreateBtn.Enabled :=
        FHiMECSUser.HiMECSUserCollect.Items[FCurrentUserIndex].UserLevel <= HUL_Administrator;

      while true do
      begin
        if ShowModal = mrOK then
        begin
          if projectLV.SelCount > 0 then
          begin
            LFileName := projectLV.ItemFocused.Caption;
            LFileName := projectLV.ItemFocused.SubItems[0]+LFileName;

            if SubProcessSelectProject(LFileName) then
            begin
              Result := True;
              break;
            end
            else
              ShowMessage('Current user is not allowed to access this project file');
          end
          else
            ShowMessage('Select Project File Name!');
        end//if ShowModal
        else
          break;
      end;//while
    end;//with
  finally
    LSelectProjectForm.Free;
  end;

end;

function TMainForm.SelectUserFile: Boolean;
var
  LSelectProjectForm: TSelectProjectForm;
  LStr: string;
begin
  Result := False;
  SetCurrentDir(FApplicationPath);

  LSelectProjectForm := TSelectProjectForm.Create(Self);
  try
    with LSelectProjectForm do
    begin
      ListData2LV('.user');

      if ShowModal = mrOK then
      begin
        if projectLV.Items.Count > 0 then
        begin
          LStr := projectLV.ItemFocused.Caption;
          LStr := projectLV.ItemFocused.SubItems[0]+LStr;
          FProjectFile.ProjectFileName := LStr;
          Result := True;
        end;
      end;
    end;
  finally
    LSelectProjectForm.Free;
  end;
end;

procedure TMainForm.SendAlarmCopyData(ToHandle: integer;
  AEP: TEngineParameterItemRecord);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := Handle;
    cbData := sizeof(AEP);
    lpData := @AEP;
  end;//with
                                   //WParam = 1: TAlarmListRecord
  SendMessage(ToHandle, WM_COPYDATA, 1, LongInt(@cd));
end;

procedure TMainForm.SendEngParam2HandleWindow(
  AEPItemRecord: TEngineParameterItem; ADestHandle: Integer = -1);
var
  LHandle,LProcessID: THandle;
  LForm: TForm;
  LParam: string;
begin
  LForm := nil;

  if ADestHandle = -1 then
  begin
    if FMultiWatchHandle = 0 then
    begin
      if FControlPressed then
      begin
        LForm := CreateDummyMDIChild;
        LParam := '/d' + IntToStr(LForm.Handle);
      end
      else
        LParam := '';

      LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ExesPath)+HiMECSWatchName2, LParam);
      FMultiWatchHandle := DSiGetProcessWindow(LProcessId);

      if Assigned(LForm) then
        TDummyForm(LForm).FClientFormHandle := FMultiWatchHandle;

      SetLength(FWatchHandles, Length(FWatchHandles)+1);
      FWatchHandles[High(FWatchHandles)] := FMultiWatchHandle;
    end;
  end;

  AEPItemRecord.AssignTo(FEngineParameterItemRecord);
  MoveMatrixData2ItemRecord(FEngineParameterItemRecord, AEPItemRecord);

  //MoveEngineParameterItemRecord(FEngineParameterItemRecord,AEPItemRecord);
  if ADestHandle = -1 then
  begin
    FPM.SendEPCopyData(Handle, FMultiWatchHandle, FEngineParameterItemRecord);

    if FControlPressed then
      ReparentWindow(FMultiWatchHandle);
  end
  else
    FPM.SendEPCopyData(Handle, ADestHandle,FEngineParameterItemRecord)
end;

//procedure TMainForm.SendEPCopyData(ToHandle: integer;
//  AEP: TEngineParameterItemRecord);
//var
//  cd : TCopyDataStruct;
//begin
//  with cd do
//  begin
//    dwData := Handle;
//    cbData := sizeof(AEP);
////    FShift := FTempState;//FKeyBdShiftState;
//    AEP.FKbdShiftState := FKeyBdShiftState;
//    lpData := @AEP;
//  end;//with
//
////  SendMessage(ToHandle, WM_COPYDATA, FParamCopyMode, LongInt(@cd));
//  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
//end;
//
procedure TMainForm.SendUserLevelCopyData(ToHandle: integer;
  AUserLevel: THiMECSUserLevel);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := Handle;
    cbData := ord(AUserLevel);
    lpData := nil;
  end;//with
                                    //WParam = 2: User Level Send
  SendMessage(ToHandle, WM_COPYDATA, 2, LongInt(@cd));
end;

//option file 생성,저장
procedure TMainForm.SetConfigData(Sender: TObject);
var
  ConfigData: TConfigF;
  LStr: string;
begin
  ConfigData := nil;
  ConfigData := TConfigF.Create(Self);
  try
    with ConfigData do
    begin
      Self.LoadConfigCollect2Form(ConfigData);

      MenuFilenameEdit.InitialDir := FApplicationPath + 'Config';
      EngInfoFilenameEdit.InitialDir := FApplicationPath + 'Doc';
      ParamFilenameEdit.InitialDir := FApplicationPath + 'Doc';
      ProjInfoFilenameEdit.InitialDir := FApplicationPath + 'Doc';
      KillProcFilenameEdit.InitialDir := FApplicationPath + 'Config';

      if ShowModal = mrOK then
      begin
        SetCurrentDir(FApplicationPath);
        Self.LoadConfigForm2Collect(ConfigData);
        LStr := IncludeTrailingPathDelimiter(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ConfigPath);
        FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.SaveToFile(
          LStr + ExtractFileName(FProjectFile.ProjectFileCollect.Items[FCOI].OptionsFileName),
          ExtractFileName(FProjectFile.ProjectFileCollect.Items[FCOI].OptionsFileName),
          FProjectFile.ProjectFileCollect.Items[FCOI].OptionFileEncrypt);
        DoConfigChange;
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

function TMainForm.SetConfigEngParamItemData(AEPItem:TEngineParameterItem; AIdx: integer): Boolean;
var
  ConfigData: TEngParamItemConfigForm;
  LStr: string;
begin
  Result := False;
  ConfigData := nil;
  ConfigData := TEngParamItemConfigForm.Create(Self);
  try
    with ConfigData do
    begin
      if AEPItem.TagName = 'New' then
      begin
        TagNameEdit.Enabled := True;
        DescEdit.Enabled := True;
        AddressEdit.Enabled := True;
        FCEdit.Enabled := True;
      end;

      LoadConfigEngParamItem2Form(AEPItem);

      ViewMatrixButton.Visible := AEPItem.IsMatrixData;

      if ShowModal = mrOK then
      begin
        SetCurrentDir(FApplicationPath);
        LoadConfigForm2EngParamItem(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngineParameter, AEPItem);
        if Dialogs.MessageDlg('Do you save a changed parameter to the '''+
                          FCurrentParaFileName+'''?' +#13#10,
          mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
        begin
          if FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngParamFileFormat = 0 then //XML format
            FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngineParameter.SaveToFile(FCurrentParaFileName,
                  ExtractFileName(FCurrentParaFileName),False)
          else
          if FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngParamFileFormat = 1 then //JSON format
            FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngineParameter.SaveToJSONFile(FCurrentParaFileName,
                  ExtractFileName(FCurrentParaFileName),False);
        end;

        Result := True;
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TMainForm.SetConfigMonitorTile(ATile: TAdvSmoothTile);
var
  LnewApp_Frm : TnewMonApp_Frm;
  LMonitorItem: THiMECSMonitorListItem;
begin
  LnewApp_Frm := TnewMonApp_Frm.Create(nil);
  try
    LMonitorItem := ATile.ItemOject as THiMECSMonitorListItem;

    LoadMonitorVar2ConfigForm(LnewApp_Frm, LMonitorItem);

    if LnewApp_Frm.ShowModal = mrOk then
    begin
      LoadMonitorConfigForm2Var(LnewApp_Frm, LMonitorItem);
      LMonitorItem.TileIndex := ATile.Index;
      LoadMonitorVar2Form(ATile, LMonitorItem);
    end;
  finally
    FreeAndNil(LnewApp_Frm);
  end;
end;

procedure TMainForm.SetAutoRunList2Inspector(AIndex: integer);
var
  lTile : TAdvSmoothTile;
  LAutoRunList: TAutoRunList;
  i: integer;
begin
  LAutoRunList := FProjectFile.ProjectFileCollect.Items[AIndex].HiMECSAutoRun;

  if not Assigned(LAutoRunList) then
    exit;

  LAutoRunList.AutoRunCollect.Clear;

  for i := 0 to LAutoRunList.AutoRunCollect.Count - 1 do
  begin
    lTile := CommTileListFrame.tileList.Tiles.Add;
    LoadAutoRunVar2Form(lTile,LAutoRunList.AutoRunCollect.Items[i]);
  end; //for
end;

procedure TMainForm.SetConfigAutoRunTile(ATile: TAdvSmoothTile);
var
  LnewApp_Frm : TnewCommApp_Frm;
  LAutoRunItem: TAutoRunItem;
begin
  LnewApp_Frm := TnewCommApp_Frm.Create(nil);
  try
    LAutoRunItem := ATile.ItemOject as TAutoRunItem;

    LoadAutoRunVar2ConfigForm(LnewApp_Frm, LAutoRunItem);

    with LnewApp_Frm do
    begin
      if ShowModal = mrOk then
      begin
        LoadAutoRunConfigForm2Var(LnewApp_Frm, LAutoRunItem);
        LAutoRunItem.TileIndex := ATile.Index;
        LoadAutoRunVar2Form(ATile, LAutoRunItem);
      end;
    end;
  finally
    FreeAndNil(LnewApp_Frm);
  end;
end;

//AControl의 AEvent에 FuncName 함수 연결함.
//DLLName이 Self인 경우 TMainForm의 멤버함수에서 FuncName 검색함.
procedure TMainForm.SetControlEvent(AControl: TControl; AInsertIndex: integer; AEvent: string);
var
  LPropInfo: PPropInfo;
  LMethod: TMethod;
begin
  //Set OnClick Event
  if (UpperCase(FMenuBase.HiMECSMenuCollect.Items[AInsertIndex].DLLName) = 'SELF') or
    (UpperCase(ExtractFileExt(FMenuBase.HiMECSMenuCollect.Items[AInsertIndex].DLLName)) = '.EXE') then
  begin
    LPropInfo := GetPropInfo(AControl.ClassInfo, AEvent); //'OnClick'

    if Assigned(LPropInfo) then
    begin
      LMethod.Code := nil;
      LMethod.Code := MethodAddress(FMenuBase.HiMECSMenuCollect.Items[AInsertIndex].FuncName);
      if Assigned(LMethod.Code) then
      begin
        //요주의: 멤버 함수가 속해있는 Owner Class를 Method.Data에 할당해야 함
        LMethod.Data := Self;
        SetMethodProp(AControl, LPropInfo, LMethod);
      end;
    end;
  end;
end;

procedure TMainForm.SetEngineInfo2Inspector(AIndex: integer; AIsAdd2Combo: Boolean);
var
  LEngineInfo: TICEngine;
begin
  EngineInfoInspector.Items[1].Clear;
  LEngineInfo := FProjectFile.ProjectFileCollect.Items[AIndex].HiMECSConfig.EngineInfo;

  if not Assigned(LEngineInfo) then
  begin
    ShowMessage('Project->Option->EngineInfo(Index = ' + IntToStr(AIndex) + ') not assigned!');
    exit;
  end;

  EngineInfoClass2Inspector(LEngineInfo, EngineInfoInspector, AIndex, NxButtonItemButtonClick, AIsAdd2Combo);
end;

procedure TMainForm.SetEngineType(AType: string);
begin
{  Result := IntToStr(FEngineInfoCollect.CylinderCount) + 'H';
  Result := Result + IntToStr(FEngineInfoCollect.Bore) + '/';
  Result := Result + IntToStr(FEngineInfoCollect.Stroke);
  Result := Result + FuelType2DispName(FEngineInfoCollect.FuelType);
  Result := Result + DispName2CylinderConfiguration(FEngineInfoCollect.CylinderConfiguration);
}end;

procedure TMainForm.SetHiMECSMainMenu(AMenuBase: TMenuBase);
var
  LMenuItem: TMenuItem;
  Li,Lj: integer;
begin
  MainMenu1.Items.Clear;

  //Main Menu Insert
  for Li := 0 to FMenuBase.HiMECSMenuCollect.Count - 1 do
  begin
    LMenuItem := TMenuItem.Create(Self);
    LMenuItem.Caption := FMenuBase.HiMECSMenuCollect.Items[Li].Caption;
    LMenuItem.Hint := FMenuBase.HiMECSMenuCollect.Items[Li].Hint;

    if FMenuBase.HiMECSMenuCollect.Items[Li].FuncName <> ''  then
    begin
      //LMenuItem.ShortCut := nil;
      //LMenuItem.Action := nil;

      //SetControlEvent를 위해 FMenuBase.HiMECSMenuCollect index를 저장함
      LMenuItem.Tag := Li;

      SetControlEvent(TControl(LMenuItem), Li,
          FMenuBase.HiMECSMenuCollect.Items[Li].EventName);
      SetMenuImageIndex(LMenuItem, Li);
    end;

    if FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex = 0 then
      MainMenu1.Items.Insert(FMenuBase.HiMECSMenuCollect.Items[Li].NodeIndex,LMenuItem)
    else
    if FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex =
                        FMenuBase.HiMECSMenuCollect.Items[Li-1].LevelIndex then
    begin
      Lj := FMenuBase.HiMECSMenuCollect.Items[Li].ParentMenuIndex;
      MainMenu1.Items[Lj].Insert(FMenuBase.HiMECSMenuCollect.Items[Li].NodeIndex, LMenuItem);
    end
    else
    if (FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex - 1) =
                      FMenuBase.HiMECSMenuCollect.Items[Li-1].LevelIndex then
    begin
      Lj := FMenuBase.HiMECSMenuCollect.Items[Li].ParentMenuIndex;
      MainMenu1.Items[Lj].Insert(FMenuBase.HiMECSMenuCollect.Items[Li].NodeIndex,LMenuItem);
    end
    else
    if FMenuBase.HiMECSMenuCollect.Items[Li-1].LevelIndex >
                        FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex then
    begin
      Lj := FMenuBase.HiMECSMenuCollect.Items[Li].ParentMenuIndex;
      while FMenuBase.HiMECSMenuCollect.Items[Lj].LevelIndex >
            FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex do
        Lj := FMenuBase.HiMECSMenuCollect.Items[Li].ParentMenuIndex;

      MainMenu1.Items[Lj].Insert(FMenuBase.HiMECSMenuCollect.Items[Li].NodeIndex,LMenuItem)
    end;
  end;
end;

procedure TMainForm.SetMenuImageIndex(AMenuItem: TMenuItem; AInsertIndex: integer);
begin
  if Assigned(MainMenu1.Images) then
  begin
    AMenuItem.ImageIndex := FMenuBase.HiMECSMenuCollect.Items[AInsertIndex].ImageIndex;
  end;
end;

procedure TMainForm.SetMonWindow2Top;
var
  i,j: integer;
begin
  ShowWindow(Self.Handle,SW_SHOWMINNOACTIVE);//SW_SHOWNOACTIVATE);

  for i := 0 to FProjectFile.ProjectFileCollect.Count - 1 do
  begin
    if not Assigned(FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor) then
      continue;

    for j := 0 to FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor.MonitorListCollect.Count - 1 do
      BringWindowToTop(FProjectFile.ProjectFileCollect.Items[i].HiMECSMonitor.MonitorListCollect.Items[j].AppHandle);

    //for j := 0 to FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun.AutoRunCollect.Count - 1 do
      //SendMessage(FProjectFile.ProjectFileCollect.Items[i].HiMECSAutoRun.AutoRunCollect.Items[j].AppHandle,
       // WM_SHOW, 0, 0);
  end;
end;

procedure TMainForm.ShowAllMonitor1Click(Sender: TObject);
var
  i: integer;
  LAdvNavBarPanel: TAdvNavBarPanel;
  LMonItem: THiMECSMonitorListItem;
  LAutoRunItem: TAutoRunItem;
begin
  LAdvNavBarPanel := AdvNavBar1.Panels[AdvNavBar1.ActiveTabIndex];
  if LAdvNavBarPanel.Name = 'MonitoringPanel' then
  begin
    for i := 0 to MonTileListFrame.tileList.Tiles.Count - 1 do
    begin
      LMonItem := MonTileListFrame.tileList.Tiles[i].ItemOject as THiMECSMonitorListItem;
      ShowWindowFromSelectedMonTile(SW_RESTORE,LMonItem);
    end;
  end
  else
  if LAdvNavBarPanel.Name = 'CommunicationPanel' then
  begin
    for i := 0 to CommTileListFrame.tileList.Tiles.Count - 1 do
    begin
      LAutoRunItem := CommTileListFrame.tileList.Tiles[i].ItemOject as TAutoRunItem;
      ShowWindowFromSelectedCommTile(SW_RESTORE, LAutoRunItem);
    end;
  end;
end;

procedure TMainForm.ShowWindowFromSelectedCommTile(AWinMsgAction: integer;
  AAutoRunItem: TAutoRunItem);
var
  LAutoRunItem: TAutoRunItem;
  MyPopup: HWnd;
begin
  if AAutoRunItem = nil then
    LAutoRunItem := CommtileListFrame.tileList.SelectedTile.ItemOject as TAutoRunItem
  else
    LAutoRunItem := AAutoRunItem;

  if LAutoRunItem.AppHandle > 0 then
  begin
    MyPopup := GetLastActivePopup(LAutoRunItem.AppHandle);

    if AWinMsgAction = SW_RESTORE then
    begin
      BringWindowToTop(LAutoRunItem.AppHandle);
      if IsIconic(MyPopup) then
      begin
        ShowWindow(MyPopup, SW_RESTORE);  // 최소화 상태이면 원래 크기로
      end else
        BringWindowToTop(MyPopup);        // 최상위 윈도우로

      SetForegroundWindow(MyPopup);
    end
    else
    if AWinMsgAction = SW_MINIMIZE then
      ShowWindow(MyPopup, SW_MINIMIZE);
  end;
end;

procedure TMainForm.ShowWindowFromSelectedMonTile(AWinMsgAction: integer;
  AMonItem: THiMECSMonitorListItem);
var
  LMonItem: THiMECSMonitorListItem;
  MyPopup: HWnd;
begin
  if AMonItem = nil then
    LMonItem := MontileListFrame.tileList.SelectedTile.ItemOject as THiMECSMonitorListItem
  else
    LMonItem := AMonitem;

  if LMonItem.AppHandle > 0 then
  begin
    MyPopup := GetLastActivePopup(LMonItem.AppHandle);

    if AWinMsgAction = SW_RESTORE then
    begin
      BringWindowToTop(LMonItem.AppHandle);
      if IsIconic(MyPopup) then
      begin
        ShowWindow(MyPopup, SW_RESTORE);  // 최소화 상태이면 원래 크기로
      end else
        BringWindowToTop(MyPopup);        // 최상위 윈도우로

      SetForegroundWindow(MyPopup);
    end
    else
    if AWinMsgAction = SW_MINIMIZE then
      ShowWindow(MyPopup, SW_MINIMIZE);
  end;
end;

procedure TMainForm.ShowWindowFromSelectedTile;
begin

end;

procedure TMainForm.SortbySensor1Click(Sender: TObject);
begin
  LoadParameter2TreeView(FCurrentParaFileName, smSensor);
end;

procedure TMainForm.SortbySystem1Click(Sender: TObject);
begin
  LoadParameter2TreeView(FCurrentParaFileName, smSystem);
end;

procedure TMainForm.StatusBarPro1Click(Sender: TObject);
begin
  StatusBarPro1.SimplePanel := not StatusBarPro1.SimplePanel;
end;

function TMainForm.SubProcessSelectProject(AFileName: string): Boolean;
var
  LUserId, LPasswd, LUserFileName: string;
  LFS: TJclFileSummary;
  LFSI: TJclFileSummaryInformation;
begin
  Result := False;

  LUserId := FHiMECSUser.HiMECSUserCollect.Items[FCurrentUserIndex].UserID;
  LPasswd := FHiMECSUser.HiMECSUserCollect.Items[FCurrentUserIndex].Password;

//권한 문제로 이 부분에서 AV 발생하여 주석 처리 함 //2016.9.23
//  LFS:= TJclFileSummary.Create(AFileName, fsaRead, fssDenyAll);
//  try
//    LFS.GetPropertySet(TJclFileSummaryInformation, LFSI);
//    if Assigned(LFSI) then
//    begin
//      LUserFileName := LFSI.LastAuthor;
//    end;
//  finally
//    FreeAndNil(LFSI);
//    LFS.Free;
//  end;

  //.himecs file을 복사하거나 압축하면 Property Summary 정보 없어짐(NTFS)
  //User File Name 정보가 없을 경우 Project File 내 User File Name 가져옴
  if LUserFileName = '' then
  begin
    if not Assigned(FProjectFile) then
    begin
      FProjectFile := TProjectFile.Create(Self);
    end
    else
      FProjectFile.ProjectFileCollect.Clear;

    FProjectFile.LoadFromJSONFile(AFileName, ExtractFileName(AFileName), True);
    LUserFileName := FProjectFile.ProjectFileCollect.Items[FCOI].UserFileName;
  end;

  //Project File 별로 user file이 할당됨(한번 더 검사함)
  if CheckUserFromUserFile(LUserId, LPasswd, LUserFileName) then
  begin
    //if not FIsProjectClosed then
    CloseProject(False);
    CreateProc;

    FProjectFile.ProjectFileName := AFileName;
    Result := True;
  end;

//  FIsProjectClosed := not Result;
end;

procedure TMainForm.TileConfig(ATile: TAdvSmoothTileList);
var
  ConfigData: TTileConfigF;
  LStr: string;
begin
  ConfigData := nil;
  ConfigData := TTileConfigF.Create(Self);
  try
    with ConfigData do
    begin
      LoadTileConfig2Form(ConfigData, ATile.Tag);

      if ShowModal = mrOK then
      begin
        LoadTileConfigForm2Collect(ConfigData, ATile.Tag);
        LStr := IncludeTrailingPathDelimiter(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ConfigPath);
        if ATile.Tag = 1 then
        begin
          FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSMonitor.SaveToJSONFile(
            LStr + ExtractFileName(FProjectFile.ProjectFileCollect.Items[FCOI].MonitorFileName),
            ExtractFileName(FProjectFile.ProjectFileCollect.Items[FCOI].MonitorFileName),
            FProjectFile.ProjectFileCollect.Items[FCOI].MonitorFileEncrypt);
        end
        else
        if ATile.Tag = 2 then
        begin
          FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSAutoRun.SaveToJSONFile(
            LStr + ExtractFileName(FProjectFile.ProjectFileCollect.Items[FCOI].RunListFileName),
            ExtractFileName(FProjectFile.ProjectFileCollect.Items[FCOI].RunListFileName),
            FProjectFile.ProjectFileCollect.Items[FCOI].RunListFileEncrypt);
        end;

        TileConfigChange(ATile.Tag);
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TMainForm.TileConfigChange(AType: integer);
begin
  if AType = 1 then //MonTileListFrame.TileList
  begin
    MonTileListFrame.TileList.Rows := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSMonitor.TileRowNum;
    MonTileListFrame.TileList.Columns := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSMonitor.TileColNum;
  end
  else
  if AType = 2 then//CommTileListFrame.TileList
  begin
    CommTileListFrame.TileList.Rows := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSAutoRun.TileRowNum;
    CommTileListFrame.TileList.Columns := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSAutoRun.TileColNum;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  if FFirst then
  begin
    FFirst := False;
    //LoadWatchListAll;
    LoadAutoRunList;
    LoadMonitorFormList;

//    SetMonWindow2Top;
  end;

  // Update the throbber to indicate that the application is responding to
  // messages (i.e. isn't blocked).
  FTick := (FTick + 1) mod 12;
  StatusBarPro1.Panels[0].ImageIndex := FTick;
  Update;
end;

procedure TMainForm.UpdateProgress4Splash(Percentage: integer);
begin
  AdvSmoothSplashScreen1.ProgressBar.Position := Percentage
end;

//ACheckOnly가 True 일때 Update가 필요하면 True
function TMainForm.DoUpdateVersion(ACheckOnly: Boolean = False): Boolean;
begin
  Result := False;

  case FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.UpdateProtocol of
    0: begin
      WebUpdate1.UpdateType := httpUpdate;//HTTP
      WebUpdate1.URL := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ServerURL;
      end;
    1: begin
      WebUpdate1.UpdateType := httpUpdate;//HTTPS
      WebUpdate1.URL := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ServerURL;
      WebUpdate1.UserID := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.FTPUserID;
      WebUpdate1.Password := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.FTPPasswd;
      end;
    2: begin
      WebUpdate1.UpdateType := ftpUpdate;//FTP
      WebUpdate1.Host := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.FTPHost;
      WebUpdate1.UserID := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.FTPUserID;
      WebUpdate1.Password := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.FTPPasswd;
      WebUpdate1.FTPDirectory := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.FTPDirectory;
      WebUpdate1.Port := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.FTPPort
      end;
    3: begin
      WebUpdate1.UpdateType := fileUpdate;//Network File
      WebUpdate1.URL := FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ServerURL;
      end;
  end;

  Result := WebUpdate1.NewVersionAvailable;

  if not ACheckOnly then
    if MessageDlg('A New Version is avaliable.' + #13#10 + 'Are you want to update new version?',
        mtConfirmation, [mbYes, mbNo], 0)= mrYes then
      WebUpdate1.DoThreadUpdate;
end;

function TMainForm.CreateOrShowChildFormFromBpl(Aform: string; var AIndex: integer):Boolean;
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

function TMainForm.CreateOrShowMDIChild(AForm: TFormClass): TForm;
var
  i: integer;
  bCreated: Bool;
begin
  bCreated := False;
  Result := nil;

  for i := 0 to MDIChildCount - 1 do
  begin
    if MDIChildren[i] is AForm then
    begin
      MDIChildren[i].Show;
      ShowWindow(MDIChildren[i].Handle, SW_SHOW);
      Result := MDIChildren[i];
      bCreated := True;
      break;
    end;
  end;//for

  if not bCreated then
  begin
    Result := AForm.Create(Application);
//    AdvToolBar1.AddMDIChildMenu(Result);
    Result.OnClose := ChildFormClose;
    AdvOfficeMDITabSet1.AddTab(Result);
    Result.Show;
  end;
end;

procedure TMainForm.CreateProc;
begin
  if not Assigned(FHiMECSForms) then
    FHiMECSForms := THiMECSForms.Create(Self);

  if not Assigned(FHiMECSExes) then
    FHiMECSExes := THiMECSExes.Create(Self);

  //if not Assigned(FEngineInfoCollect) then
   // FEngineInfoCollect := TICEngine.Create(Self);
  //if not Assigned(FEngineInfoList) then
  //  FEngineInfoList := TStringList.Create;

  if not Assigned(FProjectInfoCollect) then
    FProjectInfoCollect := TVesselInfo.Create(Self);

  if not Assigned(FPackageList_Exes) then
    FPackageList_Exes := TStringList.Create;

  //if not Assigned(FEngineParameter) then
    //FEngineParameter := TEngineParameter.Create(Self);

  if not Assigned(FSearchParamList) then
    FSearchParamList := TStringList.Create;

  //if not Assigned(FEngineParameterList) then
  //  FEngineParameterList := TStringList.Create;

  if not Assigned(FPJHTimerPool) then
    FPJHTimerPool := TPJHTimerPool.Create(nil);

  if not Assigned(FProjectFile) then
    FProjectFile := TProjectFile.Create(Self);

  if not Assigned(FKillProcessList) then
    FKillProcessList := TKillProcessList.Create(Self);
  //if not Assigned(FHiMECSConfig) then
    //FHiMECSConfig := THiMECSConfig.Create(Self);

  //if not Assigned(FHiMECSOptions) then
  //begin
    //FHiMECSOptions := THiMECSOptions.Create(Self);
    //FHiMECSOptions.EPStrList := TStringList.Create;
  //end;
end;

procedure TMainForm.CreateSubCategory1Click(Sender: TObject);
begin
  if JvCheckTreeView1.Selected <> nil then
    AddCategory2ParamTV(JvCheckTreeView1.Selected, True);
end;

procedure TMainForm.Vertical1Click(Sender: TObject);
begin
  DoTile(tbVertical);
end;

procedure TMainForm.WebUpdate1FileProgress(Sender: TObject; FileName: string;
  Pos, Size: Integer);
begin
  StatusBarPro1.Panels[3].Progress.max := size;
  StatusBarPro1.Panels[3].Progress.position := pos;
end;

procedure TMainForm.WMCopyData(var Msg: TMessage);
var
  i: integer;
  LHandle: integer;
begin
  case Msg.WParam of
    WParam_REQMULTIRECORD: begin//Handle 수신 OK
      FKeyBdShiftState := PKbdShiftRec(PCopyDataStruct(Msg.LParam)^.lpData)^.FKbdShift;
//      Add2MultiNode(FCurrentNode, False, False, PCopyDataStruct(Msg.LParam)^.cbData);
      FParamCopyMode := PKbdShiftRec(PCopyDataStruct(Msg.LParam)^.lpData)^.ParamDragMode;
      FEngineParameterItemRecord.FParamDragCopyMode := TParamDragCopyMode(FParamCopyMode);
      LHandle := PKbdShiftRec(PCopyDataStruct(Msg.LParam)^.lpData)^.MyHandle;
      SendMessage(LHandle, WM_MULTICOPY_BEGIN, 0, 0);
      Add2MultiNode(FCurrentNode, False, False, LHandle);
      SendMessage(LHandle, WM_MULTICOPY_END, 0, 0);
      FKeyBdShiftState := [];
      FParamCopyMode := Ord(dcmCopyCancel);
      FEngineParameterItemRecord.FParamDragCopyMode := dcmCopyCancel;
    end;
    WParam_DISPLAYMSG: begin//MDI Child Caption 수신
      //ShowMessage(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg);
    end;
  end;
  //AdvToolBar1.AddMDIChildMenu(TForm(PCopyDataStruct(Msg.LParam)^.lpData));
  //AdvOfficeMDITabSet1.AddTab(TForm(PCopyDataStruct(Msg.LParam)^.lpData));
end;

procedure TMainForm.Add2AlarmList(ANode: TTreeNode; AAddSibling: boolean=false);
var
  LHandle,LProcessID: THandle;
  LEngineParameterItem: TEngineParameterItem;
  LNode: TTreeNode;
  Li: integer;
begin
  if not Assigned(ANode) then
    exit;

  if ANode.HasChildren then
  begin
    LNode := ANode.GetFirstChild;

    for Li := 0 to ANode.Count - 1 do
    begin
      Add2AlarmList(LNode, true);
      LNode := ANode.GetNextChild(LNode);
    end;

    exit;
  end;

  if TObject(ANode.Data) is TEngineParameterItem then
  begin
    if FAlarmListHandle = 0 then
    begin
      LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(
        FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ExesPath)+HiMECSWatchName2+' '+AlarmListMode);
      FAlarmListHandle := DSiGetProcessWindow(LProcessId);
    end;

    LEngineParameterItem := TEngineParameterItem(ANode.Data);
    LEngineParameterItem.AssignTo(FEngineParameterItemRecord);
    //MoveEngineParameterItemRecord(FEngineParameterItemRecord,LEngineParameterItem);
    SendAlarmCopyData(FAlarmListHandle,FEngineParameterItemRecord);

    SetLength(FWatchHandles, Length(FWatchHandles)+1);
    FWatchHandles[High(FWatchHandles)] := FAlarmListHandle;

    if FControlPressed then
    begin
      CreateDummyMDIChild(LProcessId);
      ReparentWindow(FAlarmListHandle);
    end;
  end;

  if AAddSibling then
    Add2AlarmList(ANode.GetNextSibling);
end;

//AIsForWatch = True: Watch Window에 SendCopyData로 데이터 전달
//              False: Mouse Drag로 데이터 전달
procedure TMainForm.Add2MultiNode(ANode: TTreeNode;  AIsForWatch: Boolean;
  AAddSibling: boolean; ADestHandle: integer = -1; AForm: TForm = nil);
var
  LEngineParameterItem: TEngineParameterItem;
  LNode: TTreeNode;
  Li: integer;
begin
  if not Assigned(ANode) then
    exit;

  if ANode.HasChildren then
  begin
    LNode := ANode.GetFirstChild;

    for Li := 0 to ANode.Count - 1 do
    begin
      Add2MultiNode(LNode, AIsForWatch, true, ADestHandle, AForm);
      LNode := ANode.GetNextChild(LNode);
    end;

    exit;
  end;

  if TObject(ANode.Data) is TEngineParameterItem then
  begin
    if AIsForWatch then //New Window에 전달함
      SendEngParam2HandleWindow(TEngineParameterItem(ANode.Data),ADestHandle)
    else
    begin
      if ADestHandle = -1 then//JvCheckTreeView1DblClick시 실행 됨
      begin
        ParameterItem2ParamList(ANode,AForm);
      end
      else
        SendEngParam2HandleWindow(TEngineParameterItem(ANode.Data), ADestHandle);
    end;
  end;

  //if AAddSibling then
    //Add2MultiNode(ANode.GetNextSibling, AIsForWatch, False, ADestHandle, AForm);
end;

procedure TMainForm.Add2WatchSave(ANode: TTreeNode; AAddSibling: boolean);
var
  LHandle,LProcessID: THandle;
  LEngineParameterItem: TEngineParameterItem;
  LNode: TTreeNode;
  Li: integer;
begin
  if not Assigned(ANode) then
    exit;

  if ANode.HasChildren then
  begin
    LNode := ANode.GetFirstChild;

    for Li := 0 to ANode.Count - 1 do
    begin
      Add2WatchSave(LNode, true);
      LNode := ANode.GetNextChild(LNode);
    end;

    exit;
  end;

  if TObject(ANode.Data) is TEngineParameterItem then
  begin
    if FMultiWatchHandle = 0 then
    begin
      LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ExesPath)+HiMECSWatchSaveName);
      FMultiWatchHandle := DSiGetProcessWindow(LProcessId);
      SetLength(FWatchHandles, Length(FWatchHandles)+1);
      FWatchHandles[High(FWatchHandles)] := FMultiWatchHandle;
    end;

    LEngineParameterItem := TEngineParameterItem(ANode.Data);
    LEngineParameterItem.AssignTo(FEngineParameterItemRecord);
    //MoveEngineParameterItemRecord(FEngineParameterItemRecord,LEngineParameterItem);
    FPM.SendEPCopyData(Handle, FMultiWatchHandle,FEngineParameterItemRecord);

    if FControlPressed then
    begin
      CreateDummyMDIChild(LProcessId);
      ReparentWindow(FMultiWatchHandle);
    end;
  end;

  if AAddSibling then
    Add2WatchSave(ANode.GetNextSibling);
end;

//Open array는 Setlength가 안됨. 때문에 Type 선언해서 변경함.
procedure TMainForm.Add2xxxList(ANode: TTreeNode; var AHandle: THandle;
  AHandleArray: TpjhArrayHandle; AExeName: String; AAddSibling: boolean);
var
  LHandle,LProcessID: THandle;
  LEngineParameterItem: TEngineParameterItem;
  LNode: TTreeNode;
  Li: integer;
begin
  if not Assigned(ANode) then
    exit;

  if ANode.HasChildren then
  begin
    LNode := ANode.GetFirstChild;

    for Li := 0 to ANode.Count - 1 do
    begin
      Add2xxxList(LNode,AHandle,AHandleArray,AExeName, true);
      LNode := ANode.GetNextChild(LNode);
    end;

    exit;
  end;

  if TObject(ANode.Data) is TEngineParameterItem then
  begin
    if AHandle = 0 then
    begin
      LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ExesPath)+AExeName);
      AHandle := DSiGetProcessWindow(LProcessId);
      SetLength(AHandleArray, Length(AHandleArray)+1);
      AHandleArray[High(AHandleArray)] := AHandle;
    end;

    LEngineParameterItem := TEngineParameterItem(ANode.Data);
    LEngineParameterItem.AssignTo(FEngineParameterItemRecord);
    //MoveEngineParameterItemRecord(FEngineParameterItemRecord,LEngineParameterItem);
    FPM.SendEPCopyData(Handle,AHandle,FEngineParameterItemRecord);


    if FControlPressed then
    begin
      CreateDummyMDIChild(LProcessId);
      ReparentWindow(AHandle);
    end;
  end;

  if AAddSibling then
    Add2xxxList(ANode.GetNextSibling,AHandle,AHandleArray,AExeName);
end;

//ASubNode = True면 AddChild else Add
procedure TMainForm.AddCategory2ParamTV(Node: TTreeNode; ASubNode: boolean);
var
  Node1 : TTreeNode;
begin
  if ASubNode then
    Node1 := JvCheckTreeView1.Items.AddChild(Node, 'New')
  else
    Node1 := JvCheckTreeView1.Items.Add(Node, 'New');
end;

procedure TMainForm.AddDefaultData2File(AFileName: string);
begin
  FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.MenuFileName := DefaultMenuFileNameOnLogOut;

  FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.SaveToFile(AFileName, ExtractFileName(AFileName),
    FProjectFile.ProjectFileCollect.Items[FCOI].OptionFileEncrypt);
end;

procedure TMainForm.AddDummy1Click(Sender: TObject);
begin
  CreateDummyMDIChild;
end;

function TMainForm.AddExeToList(APackageName: string): Boolean;
var
  LStr: string;
begin
  Result := False;

  if (FPackageList_Exes.IndexOf(APackageName) = -1) then
  begin
    if (pos('bpl', ExtractFileExt(APackageName)) = 0) then
      LStr := APackageName + '.bpl'
    else
      LStr := APackageName;

    try
      FPackageList_Exes.AddObject(APackageName, Pointer(LoadPackage(APackageName)));
    except
      ShowMessage('Load Fail ' + APackageName + ' File');
    end;
  end
  else
    ShowMessage('Duplcate package file : ' + APackageName);
end;

procedure TMainForm.AddItem2ParamTV(Node: TTreeNode);
var
  Node1 : TTreeNode;
  i: integer;
begin
  i := CopyItem2EngineParamCollect(Node);
  Node1 := JvCheckTreeView1.Items.AddObject(Node,
             'New', FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngineParameter.EngineParameterCollect.Items[i]);
  SetNodeImages(Node1, False);
end;

procedure TMainForm.AddtoAlarmList1Click(Sender: TObject);
var
  LNode: TTreeNode;
begin
  LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );

  if Assigned(LNode) then
  begin
    SetCurrentDir(FApplicationPath);
    Add2AlarmList(LNode);
    SetForegroundWindow(FAlarmListHandle);
  end;
end;

procedure TMainForm.AddtoNewWatch1Click(Sender: TObject);
var
  LNode: TTreeNode;
  LHandle,LProcessID: THandle;
  LEngineParameterItem: TEngineParameterItem;
begin
  LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );

  if Assigned(LNode) then
  begin
    if TObject(LNode.Data) is TEngineParameterItem then
    begin
      SetCurrentDir(FApplicationPath);
      LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ExesPath)+HiMECSWatchName);
      LEngineParameterItem := TEngineParameterItem(LNode.Data);
      LEngineParameterItem.AssignTo(FEngineParameterItemRecord);
      //MoveEngineParameterItemRecord(FEngineParameterItemRecord,LEngineParameterItem);

      LHandle := DSiGetProcessWindow(LProcessId);
      FPM.SendEPCopyData(Handle, LHandle,FEngineParameterItemRecord);

      SetLength(FWatchHandles, Length(FWatchHandles)+1);
      FWatchHandles[High(FWatchHandles)] := LHandle;

      if FControlPressed then
      begin
        CreateDummyMDIChild(LHandle);
        ReparentWindow(LHandle);
      end;
      //FPJHTimerPool.AddOneShot(OnSendData2Watch,500);
    end;
  end;
end;

procedure TMainForm.AddtoNewWatch21Click(Sender: TObject);
var
  LNode: TTreeNode;
  i: integer;
begin
//  LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );

  SetCurrentDir(FApplicationPath);

  FParamCopyMode := Ord(dcmCopyOnlyNonExist);
  FEngineParameterItemRecord.FParamDragCopyMode := dcmCopyOnlyNonExist;
  try
    for i := JvCheckTreeView1.SelectedCount - 1 downto 0 do
    begin
      LNode := JvCheckTreeView1.SelectedItems[i];

      if Assigned(LNode) then
      begin
        if i = JvCheckTreeView1.SelectedCount - 1 then
          Add2MultiNode(LNode, True, False)
        else
        begin
          if FMultiWatchHandle <> 0 then
            Add2MultiNode(LNode, True, False, FMultiWatchHandle);
        end;
      end;
    end;
  finally
    FMultiWatchHandle := 0;
    FParamCopyMode := Ord(dcmCopyCancel);
    FEngineParameterItemRecord.FParamDragCopyMode := dcmCopyCancel;
  end;
end;

procedure TMainForm.AddtoSaveList1Click(Sender: TObject);
var
  LNode: TTreeNode;
begin
  LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );

  if Assigned(LNode) then
  begin
    SetCurrentDir(FApplicationPath);
    Add2WatchSave(LNode);
    //Add2xxxList(LNode,FMultiWatchHandle,FWatchHandles,HiMECSWatchSaveName);
    FMultiWatchHandle := 0;
  end;
end;

procedure TMainForm.AdvNavBar1SplitterMove(Sender: TObject; OldSplitterPosition,
  NewSplitterPosition: Integer);
begin
  EngineInfoInspector.Invalidate;
end;

procedure TMainForm.AdvOfficeMDITabSet1TabClick(Sender: TObject;
  TabIndex: Integer);
var
  LHandle, LProcessId: integer;
begin
  LProcessId := AdvOfficeMDITabSet1.AdvOfficeTabs[TabIndex].Tag;
  LHandle := DSiGetProcessWindow(LProcessId);
  SetForegroundWindow(LHandle);
end;

procedure TMainForm.ApplyChangedProjectItem;
begin
  ApplyConfigChange;
end;

procedure TMainForm.ApplyConfigChange;
begin
  LoadEngineInfo(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.EngineInfoFileName, False);
  LoadProjectInfo(FProjectFile.ProjectFileCollect.Items[FCOI].HiMECSConfig.ProjectInfoFileName, False);
end;

end.
