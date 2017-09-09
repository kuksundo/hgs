unit MainUnit;
{
2011.3.28
- ChildForm 생성시 Border Icon이 안 나오는 문제 해결
  : WM_SIZE 메세지 함수 삭제해서 해결함.
2011.3.21
- 검게 변하는 문제가 다시 발생함.
  : CustomDrawItem event에 NextInspector1.Invalidate 추가함. 아래 문제는 해결안됨.
2011.3.15
- NxInspetctor 의 내용이 다른 윈도우에 가렸을때 검게 변하는 문제 해결함
  : NxScrollContol.WMEraseBkGnd 함수에 invalidate 추가함. (2011.1.28 조치 삭제함)
2011.2.11
- 외부 프로그램을 MDI Child로 생성하는 함수 추가
- Window cascade, horizontal, vertical 추가

2011.1.28
- NextInspector에서 내용이 까많게 나오는 문제 해결
  : OnMouseMove, OnMouseDown, OnMouseUp Event에 NextInspector1.Invalidate 추가함.
}
interface

uses
  DragDrop, DropSource, DragDropFormats, DropTarget, DragDropText,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, NxCollection, NxToolBox, ExtCtrls, ImgList, AdvSplitter,
  AdvNavBar, HiMECSInterface, HiMECSFormCollect, HiMECSConst, AdvToolBar,TypInfo,
  EngineBaseClass, NxScrollControl, NxInspector, NxPropertyItems,
  NxPropertyItemClasses, JvDialogs, StdCtrls, StdActns, ActnList, HiMECSExeCollect,
  MenuBaseClass, UnitConfig, HiMECSConfigCollect, ComCtrls, JvExComCtrls,
  JvComCtrls, JvCheckTreeView, EngineParameterClass, AdvTabSet, AdvOfficeTabSet,
  AdvOfficeTabSetStylers, AdvToolBarStylers, AdvMenus, SBPro, DragDropRecord,
  CopyData, TimerPool;

type
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
    AdvNavBarPanel1: TAdvNavBarPanel;
    AdvNavBarPanel2: TAdvNavBarPanel;
    AdvNavBarPanel3: TAdvNavBarPanel;
    AdvNavBarPanel4: TAdvNavBarPanel;
    AdvNavBarPanel5: TAdvNavBarPanel;
    AdvSplitter1: TAdvSplitter;
    AdvDockPanel1: TAdvDockPanel;
    NextInspector1: TNextInspector;
    NxTextItem1: TNxTextItem;
    NxTextItem8: TNxTextItem;
    NxTextItem13: TNxTextItem;
    NxTextItem16: TNxTextItem;
    NxTextItem21: TNxTextItem;
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
    CreateItem1: TMenuItem;
    LoadParameterfromfile1: TMenuItem;
    N4: TMenuItem;
    MainPopupMenu: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem4: TMenuItem;
    AdvToolBar1: TAdvToolBar;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvPopupMenu1: TAdvPopupMenu;
    AdvOfficeMDITabSet1: TAdvOfficeMDITabSet;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    ImageListThrobber: TImageList;
    StatusBarPro1: TStatusBarPro;
    Timer1: TTimer;
    DropTextTarget1: TDropTextTarget;
    N5: TMenuItem;
    Clearallparameter1: TMenuItem;
    CreateSubCategory1: TMenuItem;
    N6: TMenuItem;
    DeleteItem1: TMenuItem;
    SavetoFile1: TMenuItem;
    JvCheckTreeView1: TJvCheckTreeView;
    EngParamSource: TDropTextSource;
    AddtoNewWatch1: TMenuItem;
    N7: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NextInspector1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure NextInspector1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NextInspector1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AdvNavBar1SplitterMove(Sender: TObject; OldSplitterPosition,
      NewSplitterPosition: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Cascade1Click(Sender: TObject);
    procedure Horizontal1Click(Sender: TObject);
    procedure Vertical1Click(Sender: TObject);
    procedure CallapseAll1Click(Sender: TObject);
    procedure ExpandAll1Click(Sender: TObject);
    procedure LoadAllInfo1Click(Sender: TObject);

    procedure Options1Click(Sender: TObject);
    procedure LoadEngineInfo1Click(Sender: TObject);
    procedure SaveEngineInfo1Click(Sender: TObject);
    procedure JvCheckTreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure JvCheckTreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure NextInspector1CustomDrawItem(Sender: TObject;
      Item: TNxPropertyItem; ValueRect: TRect);
    procedure SortbySystem1Click(Sender: TObject);
    procedure SortbySensor1Click(Sender: TObject);
    procedure JvCheckTreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure JvCheckTreeView1DblClick(Sender: TObject);
    procedure LoadParameterfromfile1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
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
  private
    FPackageModules : array of HModule;
    FWatchHandles : array of THandle;
    FPackageList_Exes: TStringList;
    FCreateChildFromBPL : array of TCreateChildFromBPL;
    FPJHTimerPool: TPJHTimerPool;

    FApplicationPath: string;

    FMouseClickParaTV_X,
    FMouseClickParaTV_Y: Integer;

    FHiMECSForms: THiMECSForms; //xml로 부터 MDI Child form(bpl) list를 저장함
    FHiMECSExes: THiMECSExes; //xml로 부터 Exe List를 저장함
    FEngineInfoCollect: TInternalCombustionEngine; //Engine Basic Info
    FMenuBase: TMenuBase;
    FHiMECSConfig: THiMECSConfig;
    FEngineParameter: TEngineParameter;
    FCurrentParaFileName //Sort할때 현재 사용중인 파일이름이 필요함
    : string;

    FMDIChildCount: Integer;
    FWindowList: array of Integer;

    FEngineParameterItemRecord: TEngineParameterItemRecord; //Watch폼에 값 전달시 사용

    FProcessId: THandle;
    FWatchHandle: THandle;

    FTick: integer;
    FProcInfo: TProcessInformation;
    FDragFormatTarget: TGenericDataFormat;

    FEngParamSource: TEngineParameterDataFormat;
    //FEP_DragDrop: TEngineParameter_DragDrop; //drag drop 으로 받은 record
    FParameterDragMode: Boolean;//Treeview에서 마우스 클릭시 True,False 됨.

    //---------------------------------------------
    // For TreeView Drag & Drop
    CurrentNode: TTreeNode;
    CurrentPos: Char;
    GhostNode: TTreeNode;

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure MoveNode(ATreeView: TTreeView; ATargetNode, ASourceNode: TTreeNode);
//---------------------------------------------
    procedure DoTile(TileMode: TTileMode);
    procedure CreateExtMDIChild(const AWindowTitle: string);
    function ReparentWindowForWindow(const WindowTitle: string): THandle;
    procedure ReparentWindow(AHandle: HWND);
    procedure CloseExtMDIChild;

    procedure PackageLoad_MDIChild;
    procedure LoadEngineInfo(AFileName:string; AIsEncrypt: Boolean);
    procedure SaveEngineInfo(AFileName:string; AIsEncrypt: Boolean);

    procedure CreateChildFormAll;
    function CreateOrShowChildFormFromBpl(Aform: string):Boolean;
    function CreateOrShowMDIChild(AForm: TFormClass): TForm;
    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
    procedure NxButtonItemButtonClick(Sender: TNxPropertyItem);

    procedure LoadMenuFromFile(AFileName: string; AIsUseLevel: Boolean);
    procedure SetHiMECSMainMenu(AMenuBase: TMenuBase);
    function InsertMenuItem(AMenu: TMenuItem; AInsertIndex: Integer; ANested: string;
      AOnClick: TNotifyEvent = nil; Action: TContainedAction = nil;
      AShortCut: TShortCut = 0): TMenuItem;
    procedure SetControlEvent(AControl: TControl; AInsertIndex: integer; AEvent: string);
    procedure SetMenuImageIndex(AMenuItem: TMenuItem; AInsertIndex: integer);

    procedure AddDefaultData2File;
    procedure LoadConfigCollect2Form(AForm: TConfigF);
    procedure LoadConfigForm2Collect(AForm: TConfigF);
    procedure LoadConfigCollectFromFile(AFileName: string; AIsEncrypt: Boolean);

    procedure LoadParameter2TreeView(AFileName:string;ASortMethod: TSortMethod);
    procedure LoadParameter2SystemTV;
    procedure LoadParameter2SensorTV;
    procedure SaveParamTV2File(AFileName:string; AIsEncrypt: Boolean);

    procedure PackageLoad_Exe; //사용하지 않음 나중에 재확인 할것
    function AddExeToList(APackageName:string): Boolean;
    procedure SendEPCopyData(ToHandle: integer; AEP:TEngineParameterItemRecord);

    procedure DisplayMessage(AMessage: string; ASaveType: TMessageSaveType;
                            AMessageType: TMessageType);
    procedure SaveMsg2File(AMessage: string; AMessaggeType: TMessageType);

    procedure DoConfigChange;

    procedure OnSendData2Watch(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure MoveEngineParameterItemRecord(AEPItemRecord:TEngineParameterItem);
  public
    procedure ApplyConfigChange;
    function GetEngineType: string;
    function AddItemsToInspector(ANxItemClass: TNxItemClass;
                ABaseIndex: integer; ACaption, AValue: string):TNxPropertyItem;
    procedure AddCategory2ParamTV(Node: TTreeNode; ASubNode: boolean);
  published
    procedure SetConfigData(Sender: TObject);
    procedure ExecApplication(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

uses JvgXMLSerializer_Encrypt, CommonUtil, UnitParamList;

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
  NextInspector1.CollapseAll;
end;

procedure TMainForm.Cascade1Click(Sender: TObject);
begin
  if (FormStyle = fsMDIForm) and (ClientHandle <> 0) then
    SendMessage(ClientHandle, WM_MDICASCADE, 0, 0);
end;

procedure TMainForm.ChildFormClose(Sender: TObject; var Action: TCloseAction);
begin
  AdvToolBar1.RemoveMDIChildMenu(TForm(Sender));
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

procedure TMainForm.DoConfigChange;
var
  cnt : integer;
  icc : IConfigChanged;
begin
  for cnt := 0 to -1 + Screen.FormCount do
  begin
    if Supports(Screen.Forms[cnt], IConfigChanged, icc) then
      icc.ApplyConfigChange;
  end;
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
begin
  TreeNode := JvCheckTreeView1.GetNodeAt(APoint.X, APoint.Y);

  if (TreeNode <> nil) then
  begin
    // Determine if we got our custom format.
    if (FDragFormatTarget.HasData) then
    begin
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
                FEngineParameter.EngineParameterCollect.Items[Li].Description);
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
begin
  i := TMenuItem(Sender).Tag;
  LStr := FMenuBase.HiMECSMenuCollect.Items[i].DLLName;
  LStr := IncludeTrailingPathDelimiter(FHiMECSConfig.ExesPath) + LStr;
  ExecNewProcess(LStr, False);

  if FHiMECSConfig.ExtAppInMDI then
  begin
    LStr := FMenuBase.HiMECSMenuCollect.Items[i].Caption;
    CreateExtMDIChild(LStr);
  end;
end;

procedure TMainForm.ExpandAll1Click(Sender: TObject);
begin
  NextInspector1.ExpandAll;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseExtMDIChild;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  LStr: String;
begin
  FHiMECSForms := THiMECSForms.Create(Self);
  FHiMECSExes := THiMECSExes.Create(Self);
  FEngineInfoCollect := TInternalCombustionEngine.Create(Self);
  FHiMECSConfig := THiMECSConfig.Create(Self);
  FMenuBase := TMenuBase.Create(Self);
  FPackageList_Exes := TStringList.Create;
  FEngineParameter := TEngineParameter.Create(Self);
  FPJHTimerPool := TPJHTimerPool.Create(nil);

  FDragFormatTarget := TGenericDataFormat.Create(DropTextTarget1);
  FDragFormatTarget.AddFormat(sDragFormatParam);

  FEngParamSource := TEngineParameterDataFormat.Create(EngParamSource);
  //FEngParamSource.AddFormat(sDragFormatParam);

  //FHiMECSFormPath := '..\bpl\';
  FApplicationPath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  SetCurrentDir(FApplicationPath);
  if not ForceDirectories('.\config\') then
    ShowMessage('Creation fail for '+FApplicationPath+'\config\ folder!');

  try
    if not FileExists('.\config\'+DefaultOptionsFileName) then
      AddDefaultData2File;

    LoadConfigCollectFromFile('.\config\'+DefaultOptionsFileName, DefaultEncryption);
  finally
    //LStr := IncludeTrailingPathDelimiter(FHiMECSConfig.ConfigPath);
    LoadMenuFromFile(FHiMECSConfig.MenuFileName, True);
    PackageLoad_MDIChild;
  end;

  MenuItem1.Checked := True;//MDI Tab show
  LoadEngineInfo(FHiMECSConfig.EngineInfoFileName, False);
  LoadParameter2TreeView('', smSystem);
  FParameterDragMode := True;
  //SetLength(FWatchHandles, 1);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  i: integer;
  LModule: HModule;
begin
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  //if FPackageModule <> 0 then
  for i := Low(FPackageModules) to High(FPackageModules) do
    if FPackageModules[i] <> 0 then
      UnloadPackage(FPackageModules[i]);

  FPackageModules := nil;
  FCreateChildFromBPL := nil;

  for i := Low(FWatchHandles) to High(FWatchHandles) do
    SendMessage(FWatchHandles[i], WM_CLOSE, 0, 0);

  FWatchHandles := nil;
  FHiMECSExes.Free;

  for i := 0 to FPackageList_Exes.Count - 1 do
  begin
    LModule := HModule(FPackageList_Exes.Objects[i]);
    UnloadPackage(LModule);
  end;

  FPackageList_Exes.Free;
  FDragFormatTarget.Free;
  FEngParamSource.Free;

  FHiMECSForms.Free;
  FHiMECSConfig.Free;
  FEngineInfoCollect.Free;
  FEngineParameter.Free;
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

function TMainForm.GetEngineType: string;
begin
  Result := IntToStr(FEngineInfoCollect.CylinderCount) + 'H';
  Result := Result + IntToStr(FEngineInfoCollect.Bore) + '/';
  Result := Result + IntToStr(FEngineInfoCollect.Stroke);
end;

procedure TMainForm.Horizontal1Click(Sender: TObject);
begin
  DoTile(tbHorizontal);
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

procedure TMainForm.JvCheckTreeView1DblClick(Sender: TObject);
var
  LNode: TTreeNode;
  LForm: TForm;
begin
  LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );

  if LNode.AbsoluteIndex = 0 then
  begin
    LForm := CreateOrShowMDIChild(TFormParamList);
    if Assigned(LForm) then
      TFormParamList(LForm).Parameter2Grid(FEngineParameter);
  end
  else
  if Assigned(LNode) then
  begin
    if TObject(LNode.Data) is TEngineParameterItem then
    begin
      LForm := CreateOrShowMDIChild(TFormParamList);
      if Assigned(LForm) then
      begin
        TFormParamList(LForm).Parameter2Grid(TEngineParameterItem(LNode.Data));
      end;
    end;
  end;

  //ShowMessage(IntToStr(LNode.AbsoluteIndex));
end;

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
end;

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

procedure TMainForm.JvCheckTreeView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LNode: TTreeNode;
  LEngineParameterItem: TEngineParameterItem;
begin
  FMouseClickParaTV_X := X;
  FMouseClickParaTV_Y := Y;

  if (DragDetectPlus(TWinControl(Sender).Handle, Point(X,Y))) then
  begin
    FParameterDragMode := True;
    FEngineParameterItemRecord.FParameterSource := psECS_kumo;
    LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );
    if Assigned(LNode) then
    begin
      if TObject(LNode.Data) is TEngineParameterItem then
      begin
        LEngineParameterItem := TEngineParameterItem(LNode.Data);
        MoveEngineParameterItemRecord(LEngineParameterItem);
        //FEP_DragDrop.FSharedName := ParameterSource2SharedMN(TEngineParameterItem(LNode.Data).ParameterSource);

        FEngineParameterItemRecord.FAddress := TEngineParameterItem(LNode.Data).Address;
        FEngineParameterItemRecord.FFCode := TEngineParameterItem(LNode.Data).FCode;
        FEngineParameterItemRecord.FDescription := TEngineParameterItem(LNode.Data).Description;
      end;
    end;

    // Transfer the structure to the drop source data object and execute the drag.
    //FEngParamSource.SetDataHere(FEP_DragDrop, sizeof(FEP_DragDrop));
    FEngParamSource.EPD := FEngineParameterItemRecord;

    EngParamSource.Execute;
  end
  else
    FParameterDragMode := False;


end;

procedure TMainForm.LoadAllInfo1Click(Sender: TObject);
begin
  if High(FPackageModules) < 0 then
    PackageLoad_MDIChild;

  CreateChildFormAll;
end;

procedure TMainForm.LoadConfigCollect2Form(AForm: TConfigF);
begin
  //FHiMECSConfig.FHiMECSConfigCollect.
  AForm.MenuFilenameEdit.Text := FHiMECSConfig.MenuFileName;
  AForm.EngInfoFilenameEdit.Text := FHiMECSConfig.EngineInfoFileName;
  AForm.ParamFilenameEdit.Text := FHiMECSConfig.ParamFileName;

  AForm.FormPathEdit.Text := FHiMECSConfig.HiMECSFormPath;
  AForm.ConfigPathEdit.Text := FHiMECSConfig.ConfigPath;
  AForm.DocPathEdit.Text := FHiMECSConfig.DocPath;
  AForm.ExePathEdit.Text := FHiMECSConfig.ExesPath;
  AForm.LogPathEdit.Text := FHiMECSConfig.LogPath;

  AForm.CBExtAppInMDI.Checked := FHiMECSConfig.ExtAppInMDI;
end;

procedure TMainForm.LoadConfigCollectFromFile(AFileName: string;
  AIsEncrypt: Boolean);
begin
  if AFileName <> '' then
  begin
    FHiMECSConfig.Clear;
    FHiMECSConfig.LoadFromFile(AFileName,DefaultPassPhrase,AIsEncrypt);
    //if not exist directory then create directory
    if not ForceDirectories(FHiMECSConfig.HiMECSFormPath) then
      ShowMessage('Creation fail for ' + FHiMECSConfig.HiMECSFormPath + ' folder!');

    if not ForceDirectories(FHiMECSConfig.ConfigPath) then
      ShowMessage('Creation fail for ' + FHiMECSConfig.ConfigPath + ' folder!');

    if not ForceDirectories(FHiMECSConfig.DocPath) then
      ShowMessage('Creation fail for ' + FHiMECSConfig.DocPath + ' folder!');

    if not ForceDirectories(FHiMECSConfig.ExesPath) then
      ShowMessage('Creation fail for ' + FHiMECSConfig.ExesPath + ' folder!');
  end
  else
    ShowMessage('Config File name is empty!');

end;

procedure TMainForm.LoadConfigForm2Collect(AForm: TConfigF);
begin
  FHiMECSConfig.MenuFileName := AForm.MenuFilenameEdit.Text;
  FHiMECSConfig.EngineInfoFileName := AForm.EngInfoFilenameEdit.Text;
  FHiMECSConfig.ParamFileName := AForm.ParamFilenameEdit.Text;

  FHiMECSConfig.HiMECSFormPath := AForm.FormPathEdit.Text;
  FHiMECSConfig.ConfigPath := AForm.ConfigPathEdit.Text;
  FHiMECSConfig.DocPath := AForm.DocPathEdit.Text;
  FHiMECSConfig.ExesPath := AForm.ExePathEdit.Text;
  FHiMECSConfig.LogPath := AForm.LogPathEdit.Text;
  FHiMECSConfig.ExtAppInMDI := AForm.CBExtAppInMDI.Checked;
end;

procedure TMainForm.LoadEngineInfo(AFileName:string; AIsEncrypt: Boolean);
var
  LStr: string;
  i,LNodeIndex,LLastIndex: integer;
  LPropertyItem: TNxPropertyItem;
begin
  if not FileExists(AFileName) then
  begin
    DisplayMessage('Engine information file: ' + AFileName + ' not found!',
                                                            mstFile,mtError);
    exit;
  end;

  SetCurrentDir(FApplicationPath);
  //LStr := FHiMECSConfig.DocPath;
  //NextInspector1.Items.Clear;
  FEngineInfoCollect.Clear;
  FEngineInfoCollect.LoadFromFile(AFileName,AFileName,AIsEncrypt);
  NextInspector1.Items[0].Clear;
  LStr := GetEngineType;
  AddItemsToInspector(TNxTextItem, 0, 'Type', LStr);
  AddItemsToInspector(TNxTextItem, 0, 'Speed', IntToStr(FEngineInfoCollect.RatedSpeed));
  AddItemsToInspector(TNxTextItem, 0, 'SFOC(g/kWh)', FloatToStr(FEngineInfoCollect.SFOC));
  AddItemsToInspector(TNxTextItem, 0, 'Frequency', FloatToStr(FEngineInfoCollect.Frequency));
  AddItemsToInspector(TNxTextItem, 0, 'Eng.kW', FloatToStr(FEngineInfoCollect.RatedPower_Engine));
  AddItemsToInspector(TNxTextItem, 0, 'Gen.kW', FloatToStr(FEngineInfoCollect.RatedPower_Generator));

  //Dimension
  LNodeIndex := -1;
  for i := 0 to NextInspector1.Items.Count - 1 do
  begin
    if (NextInspector1.items[i].Level = 0) and (NextInspector1.Items[i].NodeIndex > 0) then
    begin
      LNodeIndex := NextInspector1.Items[i].NodeIndex;
      Break;
    end;
  end;

  if LNodeIndex > -1 then
  begin
    NextInspector1.Items[LNodeIndex].Clear;
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'A', FloatToStr(FEngineInfoCollect.Dimension_A));
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'B', FloatToStr(FEngineInfoCollect.Dimension_B));
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'C', FloatToStr(FEngineInfoCollect.Dimension_C));
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'D', FloatToStr(FEngineInfoCollect.Dimension_D));
  end;

  //Dry Mass
  LLastIndex := LNodeIndex;
  LNodeIndex := -1;
  for i := 0 to NextInspector1.Items.Count - 1 do
  begin
    if (NextInspector1.items[i].Level = 0) and (NextInspector1.Items[i].NodeIndex > LLastIndex) then
    begin
      LNodeIndex := NextInspector1.Items[i].NodeIndex;
      Break;
    end;
  end;

  if LNodeIndex > -1 then
  begin
    NextInspector1.Items[LNodeIndex].Clear;
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'Engine Weight', FloatToStr(FEngineInfoCollect.EngineWeight));
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'Genset Weight', FloatToStr(FEngineInfoCollect.GensetWeight));
  end;

  //Cam Profile
  LLastIndex := LNodeIndex;
  LNodeIndex := -1;
  for i := 0 to NextInspector1.Items.Count - 1 do
  begin
    if (NextInspector1.items[i].Level = 0) and (NextInspector1.Items[i].NodeIndex > LLastIndex) then
    begin
      LNodeIndex := NextInspector1.Items[i].NodeIndex;
      Break;
    end;
  end;

  if LNodeIndex > -1 then
  begin
    NextInspector1.Items[LNodeIndex].Clear;
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'Firing Order', FEngineInfoCollect.FiringOrdder);
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'IVO', FloatToStr(FEngineInfoCollect.IVO));
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'IVC', FloatToStr(FEngineInfoCollect.IVC));
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'EVO', FloatToStr(FEngineInfoCollect.EVO));
    AddItemsToInspector(TNxTextItem, LNodeIndex, 'EVC', FloatToStr(FEngineInfoCollect.EVC));
  end;

  //Components
  LLastIndex := LNodeIndex;
  LNodeIndex := -1;
  for i := 0 to NextInspector1.Items.Count - 1 do
  begin
    if (NextInspector1.items[i].Level = 0) and (NextInspector1.Items[i].NodeIndex > LLastIndex) then
    begin
      LNodeIndex := NextInspector1.Items[i].NodeIndex;
      Break;
    end;
  end;

  if LNodeIndex > -1 then
  begin
    NextInspector1.Items[LNodeIndex].Clear;

    for i := 0 to FEngineInfoCollect.ICEngineCollect.Count - 1 do
    begin
      LPropertyItem := AddItemsToInspector(TNxButtonItem, LNodeIndex,
                        FEngineInfoCollect.ICEngineCollect.Items[i].PartName,'');
      TNxButtonItem(LPropertyItem).ButtonCaption := '...';
      TNxButtonItem(LPropertyItem).OnButtonClick := NxButtonItemButtonClick;
      LPropertyItem.Expanded := False;
      NextInspector1.Items[LPropertyItem.NodeIndex].Clear;

      AddItemsToInspector(TNxTextItem, LPropertyItem.NodeIndex, 'Maker',
                              FEngineInfoCollect.ICEngineCollect.Items[i].Maker);
      AddItemsToInspector(TNxTextItem, LPropertyItem.NodeIndex, 'Type',
                              FEngineInfoCollect.ICEngineCollect.Items[i].FFType);
      AddItemsToInspector(TNxTextItem, LPropertyItem.NodeIndex, 'Serial No',
                              FEngineInfoCollect.ICEngineCollect.Items[i].SerialNo);
    end;
  end;
end;

procedure TMainForm.LoadEngineInfo1Click(Sender: TObject);
begin
  JvOpenDialog1.InitialDir := FApplicationPath;
  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      LoadEngineInfo(JvOpenDialog1.FileName, False);
    end;
  end;
end;

procedure TMainForm.LoadMenuFromFile(AFileName: string; AIsUseLevel: Boolean);
begin
  if AFileName <> '' then
  begin
    FMenuBase.HiMECSMenuCollect.Clear;
    FMenuBase.LoadFromFile(AFileName,DefaultPassPhrase, DefaultMenuEncryption);
    SetHiMECSMainMenu(FMenuBase);
  end
  else
    ShowMessage('Menu File name is empty!');
end;

procedure TMainForm.LoadParameter2SensorTV;
var
  i: integer;
  LTreeNode, LPartTreeNode, LPartTreeNode2: TTreeNode;
begin
  //LTreeNode := JvCheckTreeView1.Items.AddChildObject(nil, FHimsenAnimation.Header, PChar(FHimsenAnimation.AniFileName));
  LTreeNode := JvCheckTreeView1.Items.AddChild(nil, 'Parameter');
  SetNodeImages(LTreeNode, True);

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Pick-Up');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].SensorType = stPickup then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'mA(4~20mA)');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].SensorType = stmA then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'RTD(pt100)');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].SensorType = stRTD then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Thermo Couple(K)');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].SensorType = stTC then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Digital Input');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].SensorType = stDI then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Digital Output');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].SensorType = stDO then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  //LTreeNode := JvCheckTreeView1.Items.AddChild(nil, 'End');
  //SetNodeImages(LTreeNode, False);

  JvCheckTreeView1.Items.EndUpdate;
end;

procedure TMainForm.LoadParameter2SystemTV;
var
  i: integer;
  LTreeNode, LPartTreeNode,
  LPartTreeNode2, LPartTreeNode3: TTreeNode;
begin
  //LTreeNode := JvCheckTreeView1.Items.AddChildObject(nil, FHimsenAnimation.Header, PChar(FHimsenAnimation.AniFileName));
  LTreeNode := JvCheckTreeView1.Items.AddChild(nil, 'Parameter');
  SetNodeImages(LTreeNode, True);

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Ready To Start');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcReadyToStart then
    begin
      //LPartTreeNode2 := JvCheckTreeView1.Items.AddChild(LPartTreeNode,
      //       FEngineParameter.EngineParameterCollect.Items[i].Description);
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Engine Shutdown');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcEngineShutdown then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Speed');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcSpeed then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'L.O. System');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcLOSystem then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'F.O. System');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcFOSystem then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Cooling Water System');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcCWSystem then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Exhaust System');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcExhSystem then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Main Bearing');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcMainBearing then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Compressed Air System');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcCAirSystem then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  LPartTreeNode := JvCheckTreeView1.Items.AddChild(LTreeNode, 'Etc.');
  SetNodeImages(LPartTreeNode, False);

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterCatetory = pcEtc then
    begin
      LPartTreeNode2 := JvCheckTreeView1.Items.AddChildObject(LPartTreeNode,
             FEngineParameter.EngineParameterCollect.Items[i].Description,
             FEngineParameter.EngineParameterCollect.Items[i]);
      SetNodeImages(LPartTreeNode2, False);
    end;
  end;

  //LTreeNode := JvCheckTreeView1.Items.AddChild(nil, 'End');
  //SetNodeImages(LTreeNode, False);

  JvCheckTreeView1.Items.EndUpdate;
end;

procedure TMainForm.LoadParameter2TreeView(AFileName:string;ASortMethod: TSortMethod);
begin
  JvCheckTreeView1.Items.Clear;
  JvCheckTreeView1.Items.BeginUpdate;
  SetCurrentDir(FApplicationPath);
  FEngineParameter.EngineParameterCollect.Clear;
  if AFileName = '' then
  begin
    FEngineParameter.LoadFromFile(FHiMECSConfig.ParamFileName,
                ExtractFileName(FHiMECSConfig.ParamFileName),False);
    FCurrentParaFileName := FHiMECSConfig.ParamFileName;
  end
  else
  begin
    FEngineParameter.LoadFromFile(AFileName,ExtractFileName(AFileName),False);
    FCurrentParaFileName := AFileName;
  end;

  if FEngineParameter.EngineParameterCollect.Count <= 0 then
    exit;

  case ASortMethod of
    smSystem: LoadParameter2SystemTV;
    smSensor: LoadParameter2SensorTV;
  end;//case

end;

procedure TMainForm.LoadParameterfromfile1Click(Sender: TObject);
begin
  JvOpenDialog1.InitialDir := FApplicationPath;
  JvOpenDialog1.Filter := '*.param||*.*';
  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      LoadParameter2TreeView(JvOpenDialog1.FileName, smSystem);
    end;
  end;

end;

procedure TMainForm.MenuItem1Click(Sender: TObject);
begin
  MenuItem1.Checked := not MenuItem1.Checked;
  AdvOfficeMDITabSet1.Visible := MenuItem1.Checked;
end;

procedure TMainForm.MoveEngineParameterItemRecord(
  AEPItemRecord: TEngineParameterItem);
begin
  FEngineParameterItemRecord.FLevelIndex := AEPItemRecord.LevelIndex;
  FEngineParameterItemRecord.FNodeIndex := AEPItemRecord.NodeIndex;
  FEngineParameterItemRecord.FAbsoluteIndex := AEPItemRecord.AbsoluteIndex;
  FEngineParameterItemRecord.FMaxValue := AEPItemRecord.MaxValue;
  FEngineParameterItemRecord.FContact := AEPItemRecord.Contact;

  FEngineParameterItemRecord.FTagName := AEPItemRecord.Tagname;
  FEngineParameterItemRecord.FDescription := AEPItemRecord.Description;
  FEngineParameterItemRecord.FAddress := AEPItemRecord.Address;
  FEngineParameterItemRecord.FFCode := AEPItemRecord.FCode;
  FEngineParameterItemRecord.FUnit := AEPItemRecord.FFUnit;

  FEngineParameterItemRecord.FSensorType := AEPItemRecord.SensorType;
  FEngineParameterItemRecord.FParameterCatetory := AEPItemRecord.ParameterCatetory;
  FEngineParameterItemRecord.FParameterType := AEPItemRecord.ParameterType;
  FEngineParameterItemRecord.FParameterSource := AEPItemRecord.ParameterSource;
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

procedure TMainForm.NextInspector1CustomDrawItem(Sender: TObject;
  Item: TNxPropertyItem; ValueRect: TRect);
begin
  NextInspector1.Invalidate;
end;

procedure TMainForm.NextInspector1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  NextInspector1.Invalidate;
end;

procedure TMainForm.NextInspector1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  NextInspector1.Invalidate;
end;

procedure TMainForm.NextInspector1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  NextInspector1.Invalidate;
end;

procedure TMainForm.NxButtonItemButtonClick(Sender: TNxPropertyItem);
begin
  if Sender.Caption = 'Generator' then
  begin
    CreateOrShowChildFormFromBpl('GeneratorInfo');
  end
  else
    ShowMessage('No additional information!');
end;

procedure TMainForm.OnSendData2Watch(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  LHandle: THandle;
begin
  FPJHTimerPool.RemoveAll;
end;

procedure TMainForm.Options1Click(Sender: TObject);
begin
  SetConfigData(Sender);
end;

procedure TMainForm.PackageLoad_Exe;
var
  i: integer;
  LStr: string;
begin
  SetCurrentDir(FApplicationPath);
  LStr := FHiMECSConfig.ExesPath;

  FHiMECSExes.ExeCollect.Clear;
  FHiMECSExes.LoadFromFile(LStr + DefaultExesFileName,DefaultExesFileName,True);

  for i := 0 to FHiMECSExes.ExeCollect.Count - 1 do
    AddExeToList(FHiMECSExes.ExeCollect.Items[i].ExeName);
end;

procedure TMainForm.PackageLoad_MDIChild;
var
  i: integer;
  LStr: string;
begin
  SetCurrentDir(FApplicationPath);
  LStr := IncludeTrailingPathDelimiter(FHiMECSConfig.ConfigPath);

  FHiMECSForms.PackageCollect.Clear;
  FHiMECSForms.LoadFromFile(LStr+DefaultFormsFileName,DefaultFormsFileName,True);
  SetLength(FPackageModules, FHiMECSForms.PackageCollect.Count);
  SetLength(FCreateChildFromBPL, FHiMECSForms.PackageCollect.Count);

  for i := 0 to FHiMECSForms.PackageCollect.Count - 1 do
  begin               //FHiMECSConfig.HiMECSFormPath는 PackageName에 포함되어 있음
    LStr := IncludeTrailingPathDelimiter(FHiMECSConfig.HiMECSFormPath);
    FPackageModules[i] := LoadPackage(LStr+FHiMECSForms.PackageCollect.Items[i].PackageName);

    if FPackageModules[i] <> 0 then
    begin
      try
        @FCreateChildFromBPL[i] := GetProcAddress(FPackageModules[i], PWideChar(FHiMECSForms.PackageCollect.Items[i].CreateFuncName));
      except
        ShowMessage('Package not found!');
      end;
    end;
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

procedure TMainForm.SaveEngineInfo(AFileName: string; AIsEncrypt: Boolean);
var
  i,j,k:integer;
begin
  FEngineInfoCollect.RatedSpeed := NextInspector1.items.ItemByName['Speed'].AsInteger; //.Items[2].AsInteger;
  FEngineInfoCollect.SFOC := NextInspector1.items.ItemByName['SFOC(g/kWh)'].AsInteger;
  FEngineInfoCollect.Frequency := NextInspector1.items.ItemByName['Frequency'].AsFloat;
  FEngineInfoCollect.RatedPower_Engine := NextInspector1.items.ItemByName['Eng.kW'].AsFloat;
  FEngineInfoCollect.RatedPower_Generator := NextInspector1.items.ItemByName['Gen.kW'].AsFloat;

  FEngineInfoCollect.Dimension_A := NextInspector1.items.ItemByName['A'].AsFloat;
  FEngineInfoCollect.Dimension_B := NextInspector1.items.ItemByName['B'].AsFloat;
  FEngineInfoCollect.Dimension_C := NextInspector1.items.ItemByName['C'].AsFloat;
  FEngineInfoCollect.Dimension_D := NextInspector1.items.ItemByName['D'].AsFloat;

  FEngineInfoCollect.EngineWeight := NextInspector1.items.ItemByName['Engine Weight'].AsFloat;
  FEngineInfoCollect.GensetWeight := NextInspector1.items.ItemByName['Genset Weight'].AsFloat;

  FEngineInfoCollect.FiringOrdder := NextInspector1.items.ItemByName['Firing Order'].AsString;
  FEngineInfoCollect.IVO := NextInspector1.items.ItemByName['IVO'].AsInteger;
  FEngineInfoCollect.IVC := NextInspector1.items.ItemByName['IVC'].AsInteger;
  FEngineInfoCollect.EVO := NextInspector1.items.ItemByName['EVO'].AsInteger;
  FEngineInfoCollect.EVC := NextInspector1.items.ItemByName['EVC'].AsInteger;

  j := 4;
  k := NextInspector1.items.ItemByName['Components'].NodeIndex + 2;

  for i := 0 to FEngineInfoCollect.ICEngineCollect.Count - 1 do
  begin
    //FEngineInfoCollect.ICEngineCollect.Items[i].PartName :=
    //                        NextInspector1.Items[i+23].AsString;
    FEngineInfoCollect.ICEngineCollect.Items[i].Maker :=
                            NextInspector1.Items[i*j+k].AsString;
    FEngineInfoCollect.ICEngineCollect.Items[i].FFType :=
                            NextInspector1.Items[i*j+k+1].AsString;
    FEngineInfoCollect.ICEngineCollect.Items[i].SerialNo :=
                            NextInspector1.Items[i*j+k+2].AsString;
  end;

  FEngineInfoCollect.SaveToFile(AFileName, AFileName, AIsEncrypt);
end;

procedure TMainForm.SaveEngineInfo1Click(Sender: TObject);
begin
  JvSaveDialog1.InitialDir := FApplicationPath;

  if JvSaveDialog1.Execute then
  begin
    SaveEngineInfo(JvSaveDialog1.FileName, False);
  end;
end;

procedure TMainForm.SaveMsg2File(AMessage: string; AMessaggeType: TMessageType);
begin
  case AMessaggeType of
    mtError: SaveData2DateFile(FHiMECSConfig.LogPath,'log',AMessage,soFromEnd);
    mtInformation: ;
    mtWarning: ;
    mtAlarm: ;
    mtShutdown: ;
  end;

end;

procedure TMainForm.SaveParamTV2File(AFileName: string; AIsEncrypt: Boolean);
var
  LEngineParameter: TEngineParameter;
  i: integer;
begin
  LEngineParameter:= TEngineParameter.Create(nil);
  try
    for i := 0 to JvCheckTreeView1.Items.Count - 1 do
    begin
      with LEngineParameter.EngineParameterCollect.Add do
      begin
        LevelIndex := JvCheckTreeView1.Items[i].Level;
        NodeIndex := JvCheckTreeView1.Items[i].Index;
        AbsoluteIndex := JvCheckTreeView1.Items[i].AbsoluteIndex;
        LEngineParameter.SaveToFile(AFileName, AFileName, AIsEncrypt);
      end;//with
    end;//for
  finally
    LEngineParameter.Free;
  end;
end;

procedure TMainForm.SavetoFile1Click(Sender: TObject);
begin
//  SaveParamTV2File(
end;

procedure TMainForm.SendEPCopyData(ToHandle: integer;
  AEP: TEngineParameterItemRecord);
var
  cd : TCopyDataStruct;
  //rec : TEngineParameterItem;
begin
  with cd do
  begin
    dwData := Handle;
    cbData := sizeof(AEP);
    lpData := @AEP;
  end;//with

  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
end;

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
      LoadConfigCollect2Form(ConfigData);

      if ShowModal = mrOK then
      begin
        SetCurrentDir(FApplicationPath);
        LoadConfigForm2Collect(ConfigData);
        LStr := IncludeTrailingPathDelimiter(FHiMECSConfig.ConfigPath);
        FHiMECSConfig.SaveToFile(LStr + DefaultOptionsFileName);
        DoConfigChange;
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

//AControl의 AEvent에 FuncName 함수 연결함.
//DLLName이 Self인 경우 TMainForm이 멤버함수에서 FuncName 검색함.
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

procedure TMainForm.SetHiMECSMainMenu(AMenuBase: TMenuBase);
var
  LMenuItem: TMenuItem;
  Li,Lj: integer;
begin
  for Li := FMenuBase.HiMECSMenuCollect.Count - 1 downto 0 do
  begin
    if (MainMenu1.Items.Count - 1) >= FMenuBase.HiMECSMenuCollect.Items[Li].MenuIndex then
      MainMenu1.Items.Delete(FMenuBase.HiMECSMenuCollect.Items[Li].MenuIndex);
  end;

  //Main Menu Insert
  for Li := 0 to FMenuBase.HiMECSMenuCollect.Count - 1 do
  begin
    if FMenuBase.HiMECSMenuCollect.Items[Li].SubMenuIndex = -1 then
    begin
      LMenuItem := TMenuItem.Create(Self);
      LMenuItem.Caption := FMenuBase.HiMECSMenuCollect.Items[Li].Caption;
      LMenuItem.Hint := FMenuBase.HiMECSMenuCollect.Items[Li].Hint;
      MainMenu1.Items.Insert(FMenuBase.HiMECSMenuCollect.Items[Li].MenuIndex,LMenuItem);
    end;
  end;

  //SubMenu Insert
  for Li := 0 to FMenuBase.HiMECSMenuCollect.Count - 1 do
  begin
    if FMenuBase.HiMECSMenuCollect.Items[Li].SubMenuIndex <> -1 then
    begin

      Lj := FMenuBase.HiMECSMenuCollect.Items[Li].MenuIndex;
      InsertMenuItem(MainMenu1.Items[Lj], Li, FMenuBase.HiMECSMenuCollect.Items[Li].NestedSubMenuIndex);
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

procedure TMainForm.SortbySensor1Click(Sender: TObject);
begin
  LoadParameter2TreeView(FCurrentParaFileName, smSensor);
end;

procedure TMainForm.SortbySystem1Click(Sender: TObject);
begin
  LoadParameter2TreeView(FCurrentParaFileName, smSystem);
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  // Update the throbber to indicate that the application is responding to
  // messages (i.e. isn't blocked).
  FTick := (FTick + 1) mod 12;
  StatusBarPro1.Panels[0].ImageIndex := FTick;
  Update;
end;

function TMainForm.CreateOrShowChildFormFromBpl(Aform: string):Boolean;
var
  i: integer;
begin
  Result := False;

  for i := 0 to MDIChildCount - 1 do
  begin
    if pos(Aform, TForm(MDIChildren[i]).ClassName) > 0 then
    begin
      MDIChildren[i].Show;

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
    AdvToolBar1.AddMDIChildMenu(Result);
    Result.OnClose := ChildFormClose;
    AdvOfficeMDITabSet1.AddTab(Result);
    Result.Show;
  end;
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

procedure TMainForm.WMCopyData(var Msg: TMessage);
begin
  //AdvToolBar1.AddMDIChildMenu(TForm(PCopyDataStruct(Msg.LParam)^.lpData));
  //AdvOfficeMDITabSet1.AddTab(TForm(PCopyDataStruct(Msg.LParam)^.lpData));
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

procedure TMainForm.AddDefaultData2File;
begin
  FHiMECSConfig.MenuFileName := DefaultMenFileName;

  FHiMECSConfig.SaveToFile(DefaultOptionsFileName);
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

function TMainForm.AddItemsToInspector(ANxItemClass: TNxItemClass;
                ABaseIndex: integer; ACaption, AValue: string):TNxPropertyItem;
//var
  //LItem: TNxItemClass;
  //LPropertyItem: TNxPropertyItem;
begin
  Result := nil;

  //LItem := TNxItemClass(NextInspector1.Items[ABaseIndex].ClassType);
  Result := NextInspector1.Items.AddChild(NextInspector1.Items[ABaseIndex], ANxItemClass);

  if Result <> nil then
  begin
    if ACaption <> '' then
      Result.Caption := ACaption;

    if AValue <> '' then
      Result.AsString := AValue;
  end;

  NextInspector1.Invalidate;
end;

procedure TMainForm.AddtoNewWatch1Click(Sender: TObject);
var
  LNode: TTreeNode;
  LHandle: THandle;
  LEngineParameterItem: TEngineParameterItem;
begin
  LNode := JvCheckTreeView1.GetNodeAt( FMouseClickParaTV_X, FMouseClickParaTV_Y );

  if Assigned(LNode) then
  begin
    if TObject(LNode.Data) is TEngineParameterItem then
    begin
      SetCurrentDir(FApplicationPath);
      FProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FHiMECSConfig.ExesPath)+HiMECSWatchName);
      LEngineParameterItem := TEngineParameterItem(LNode.Data);
      MoveEngineParameterItemRecord(LEngineParameterItem);

      LHandle := DSiGetProcessWindow(FProcessId);
      SendEPCopyData(LHandle,FEngineParameterItemRecord);

      SetLength(FWatchHandles, Length(FWatchHandles)+1);
      FWatchHandles[High(FWatchHandles)] := LHandle;
      ReparentWindow(LHandle);
      //FPJHTimerPool.AddOneShot(OnSendData2Watch,500);
    end;
  end;
end;

procedure TMainForm.AdvNavBar1SplitterMove(Sender: TObject; OldSplitterPosition,
  NewSplitterPosition: Integer);
begin
  NextInspector1.Invalidate;
end;

procedure TMainForm.ApplyConfigChange;
begin
  LoadEngineInfo(FHiMECSConfig.EngineInfoFileName, False);
end;

end.
