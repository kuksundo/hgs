unit UnitWatchBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.AppEvnts, DropTarget, DragDropText,
  AdvOfficeStatusBar, AdvOfficeStatusBarStylers, CalcExpress, DragDrop,
  DropSource, JvDialogs, Vcl.ImgList, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  iXYPlot, iComponent, iVCLComponent, iCustomComponent, iPlotComponent, iPlot,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, JvExComCtrls, JvComCtrls, JvStatusBar,
  AdvOfficePager, UnitFrameIPCMonitorAll, TimerPool, DeCAL, HiMECSConst,
  EngineParameterClass, WatchConst2, DragDropRecord, sql3_defs, Data.DB,
  UnitEngParamConfig;

const
  DefaultPassPhrase = 'DefaultPassPhrase';
  DefaultConfigFileName = 'DefaultAlarm.config';
  DefaultEncryption = False;

type
  THiMECSWatchBaseForm = class(TForm)
    IPCMonitorAll1: TFrameIPCMonitorAll;
    PageControl1: TAdvOfficePager;
    ItemsTabSheet: TAdvOfficePage;
    JvStatusBar1: TJvStatusBar;
    Label4: TLabel;
    EnableAlphaCB: TCheckBox;
    JvTrackBar1: TJvTrackBar;
    StayOnTopCB: TCheckBox;
    AllowUserlevelCB: TComboBox;
    SaveListCB: TCheckBox;
    NextGrid1: TNextGrid;
    NxImageColumn2: TNxImageColumn;
    ItemName: TNxTextColumn;
    Value: TNxButtonColumn;
    FUnit: TNxTextColumn;
    NxImageColumn3: TNxImageColumn;
    NxImageColumn4: TNxImageColumn;
    NxCheckBoxColumn2: TNxCheckBoxColumn;
    ImageList1: TImageList;
    JvSaveDialog1: TJvSaveDialog;
    JvOpenDialog1: TJvOpenDialog;
    EngParamSource2: TDropTextSource;
    CalcExpress1: TCalcExpress;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    DropTextTarget1: TDropTextTarget;
    ApplicationEvents1: TApplicationEvents;
    NxIncrementColumn1: TNxIncrementColumn;
    WatchListPopup: TPopupMenu;
    Items1: TMenuItem;
    AddtoCalculated1: TMenuItem;
    N5: TMenuItem;
    LoadWatchListFromFile1: TMenuItem;
    SaveWatchLittoNewName1: TMenuItem;
    N3: TMenuItem;
    DeleteItem1: TMenuItem;
    N10: TMenuItem;
    Properties1: TMenuItem;
    procedure NextGrid1DblClick(Sender: TObject);
    procedure NextGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NextGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NextGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure NextGrid1SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure DropTextTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DeleteItem1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure AddtoCalculated1Click(Sender: TObject);
    procedure EnableAlphaCBClick(Sender: TObject);
    procedure JvTrackBar1Change(Sender: TObject);
    procedure StayOnTopCBClick(Sender: TObject);
    procedure SaveWatchLittoNewName1Click(Sender: TObject);
    procedure LoadWatchListFromFile1Click(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;
    FCalculatedItemTimerHandle: integer; //Calculated Item display용 Timer Handle
    FEngineParameterTarget: TEngineParameterDataFormat;
    FEngParamSource: TEngineParameterDataFormat;
    FEngineParameterItemRecord: TEngineParameterItemRecord; //Save폼에 값 전달시 사용
    FMousePoint: TPoint;
    FFilePath,                       //파일을 저장할 경로
    FWatchListFileName: string;

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure OnDisplayCalculatedItemValue(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure DeleteEngineParamterFromGrid(AIndex: integer); virtual;
    procedure FreeStrListFromGrid(AIndex: integer = -1);
    function ReAssignFormulaValueList(AFormula: string; AIndex: integer = -1): TStringList;
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer); virtual;
    procedure WatchValue2Screen_Digital(Name: string; AValue: string;
                                AEPIndex: integer); virtual;
    procedure GetEngineParameterFromSavedFile(AFileName: string; AEncrypt: Boolean);
    procedure AppendEngineParameterFromFile(AFileName: string; AEncrypt: Boolean);
    function CheckExistTagName(AParameterSource: TParameterSource;
                                                  ATagName: string): integer;
    procedure SaveWatchFile(AFileName: string; APath: string = '');
    procedure SetConfigEngParamItemData(AIndex: Integer);

    //Popup Menu Methods
    procedure SetupProperties;
    procedure DeleteParamItems;
    procedure AddToCalculated;
    //Popup Menu Methods
  public
    FCompoundItemList: DArray; //Calculated Item List

    procedure InitVar;
    procedure CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
  end;

var
  HiMECSWatchBaseForm: THiMECSWatchBaseForm;

implementation

uses UnitCopyWatchList, CopyData;

{$R *.dfm}

procedure THiMECSWatchBaseForm.AddToCalculated;
var
  i,j: integer;
  Lstr, LStr2: string;
  LStrList, LtmpList: TStringList;
  LEP_DragDrop: TEngineParameterItemRecord;
  LMemoryStream: TMemoryStream;
  LCopyWatchListF: TCopyWatchListF;
begin
  LCopyWatchListF := TCopyWatchListF.Create(nil);
  try
    with LCopyWatchListF do
    begin
      //LMemoryStream := TMemoryStream.Create;
      //try
        //NextGrid1.SaveToStream(LMemoryStream);
        //LMemoryStream.Position := 0;
        //SelectGrid.LoadFromStream(LMemoryStream);
      //finally
        //FreeAndNil(LMemoryStream);
      //end;

      NextGrid1.SaveToTextFile(TEMPFILENAME);
      SelectGrid.LoadFromTextFile(TEMPFILENAME);

      Sel4XYGraphPanel.Visible := False;
      FormulaPanel.Visible := True;

      SelectGrid.Columns.Item[0].Visible := False;
      SelectGrid.Columns.Item[1].Visible := False;
      SelectGrid.Columns.Item[4].Visible := False;
      SelectGrid.Columns.Item[5].Visible := False;
      SelectGrid.Columns.Item[6].Visible := False;
      SelectGrid.Columns.Item[7].Visible := False;

      SelectGrid.Options := SelectGrid.Options - [goMultiSelect];

      for i := 0 to SelectGrid.RowCount - 1 do
        SelectGrid.Cell[3,i].AsString :=
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName;

      if ShowModal = mrOK then
      begin
        LStrList := ReAssignFormulaValueList(ExprEdt.Text);

        j := NextGrid1.AddRow();
        NextGrid1.Cell[0, j].AsInteger := -1;
        NextGrid1.Cell[1, j].AsInteger := -1;
        NextGrid1.Cell[5, j].AsInteger := -1;
        NextGrid1.Cell[6, j].AsInteger := -1;
        NextGrid1.Row[j].Data := LStrList;
        FCompoundItemList.add([j]);
        LEP_DragDrop.FSharedName := CalcExpress1.Formula;//.GetVarFromFormula;
        LEP_DragDrop.FTagName := 'V_' + formatDateTime('yyyymmddhhnnss',now);//'Calculated_'+IntToStr(j);

        if ItemNameEdit.Text = '' then
          LEP_DragDrop.FDescription := ExprEdt.Text
        else
          LEP_DragDrop.FDescription := ItemNameEdit.Text;

        NextGrid1.CellByName['ItemName',j].AsString := LEP_DragDrop.FDescription;

        i := IPCMonitorAll1.MoveEngineParameterItemRecord(LEP_DragDrop);

        if i = -1 then
          i := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1;

        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FormulaValueList :=
          LStrList.Text;
        if FCalculatedItemTimerHandle = -1 then
          FCalculatedItemTimerHandle := FPJHTimerPool.Add(OnDisplayCalculatedItemValue,1000);
        //break;
      end;
    end;//with

  finally
    FreeAndNil(LCopyWatchListF);
  end;
end;

procedure THiMECSWatchBaseForm.AddtoCalculated1Click(Sender: TObject);
begin
  AddToCalculated;
end;

procedure THiMECSWatchBaseForm.AppendEngineParameterFromFile(AFileName: string;
  AEncrypt: Boolean);
var
  LEngineParam: TEngineParameter;
  AEPItemRecord: TEngineParameterItem;
  i: integer;
begin
  LEngineParam := TEngineParameter.Create(nil);
  try
    LEngineParam.LoadFromJSONFile(AFileName,
                ExtractFileName(AFileName), AEncrypt);

    IPCMonitorAll1.FEngineParameter.ExeName := LEngineParam.ExeName;
    IPCMonitorAll1.FEngineParameter.FilePath := LEngineParam.FilePath;

    IPCMonitorAll1.FEngineParameter.FormWidth := LEngineParam.FormWidth;
    IPCMonitorAll1.FEngineParameter.FormHeight := LEngineParam.FormHeight;
    IPCMonitorAll1.FEngineParameter.FormTop := LEngineParam.FormTop;
    IPCMonitorAll1.FEngineParameter.FormLeft := LEngineParam.FormLeft;

    IPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList := LEngineParam.AllowUserLevelWatchList;

    for i := 0 to LEngineParam.EngineParameterCollect.Count - 1 do
    begin
      AEPItemRecord := LEngineParam.EngineParameterCollect.Items[i];
      if CheckExistTagName(AEPItemRecord.ParameterSource,AEPItemRecord.TagName) = -1 then
      begin //동일한 태그가 존재하지 않으면 추가
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.AddEngineParameterItem(AEPItemRecord);
      end;
    end;
  finally
    LEngineParam.Free;
  end;
end;

function THiMECSWatchBaseForm.CheckExistTagName(
  AParameterSource: TParameterSource; ATagName: string): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource =
                                                AParameterSource) and
        (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName =
                                                ATagName) then
    begin
      Result := i;
      exit;
    end;
  end;
end;

procedure THiMECSWatchBaseForm.CreateIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  i, LResult: integer;
begin
  LResult := IPCMonitorAll1.CreateIPCMonitor(AEP_DragDrop);

  if LResult = -1 then
  begin
    i := NextGrid1.AddRow();

    if AEP_DragDrop.FDescription = '' then
      NextGrid1.CellsByName['ItemName', i] := AEP_DragDrop.FTagName
    else
      NextGrid1.CellsByName['ItemName', i] := AEP_DragDrop.FDescription;
    NextGrid1.CellsByName['FUnit', i] := AEP_DragDrop.FUnit;

    if AEP_DragDrop.FParameterSource = psManualInput then
      NextGrid1.CellsByName['Value', i] := AEP_DragDrop.FValue;

    NextGrid1.ClearSelection;
    NextGrid1.ScrollToRow(i);
    NextGrid1.Cell[0, i].AsInteger := -1;
    NextGrid1.Cell[1, i].AsInteger := -1;
    NextGrid1.Cell[5, i].AsInteger := -1;

   //Administrator이상의 권한자 만이 Config form에서 level 조정 가능함
    if IPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator then
    begin
      AllowUserlevelCB.Enabled := True;
    end;

    if AllowUserlevelCB.Text = '' then
      AllowUserlevelCB.Text := UserLevel2String(IPCMonitorAll1.FCurrentUserLevel);
  end;
end;

procedure THiMECSWatchBaseForm.DeleteEngineParamterFromGrid(AIndex: integer);
begin
  FreeStrListFromGrid(AIndex);
  //DeleteParamItems;
  NextGrid1.DeleteRow(AIndex);
  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Delete(AIndex);
end;

procedure THiMECSWatchBaseForm.DeleteItem1Click(Sender: TObject);
begin
  DeleteParamItems;
end;

procedure THiMECSWatchBaseForm.DeleteParamItems;
var
  i: integer;
  LStr: string;
begin
  if NextGrid1.SelectedCount > 0 then
  begin
    if MessageDlg('Selected ' + IntToStr(NextGrid1.SelectedCount) +' Item(s) will be deleted.' + #13#10 + 'Are you sure?',
                                  mtConfirmation, [mbYes, mbNo], 0)= mrNo then
      exit;
  end;

  if IPCMonitorAll1.AssignedIPCMonitor(psECS_Woodward) then
    IPCMonitorAll1.FCompleteReadMap_Woodward := False;

  if IPCMonitorAll1.AssignedIPCMonitor(psECS_kumo) then
    IPCMonitorAll1.FCompleteReadMap_kumo := False;

  if IPCMonitorAll1.AssignedIPCMonitor(psECS_AVAT) then
    IPCMonitorAll1.FCompleteReadMap_Avat := False;

  //Grid Item 삭제시에 Timer 함수에서 접근시 AVE 발생하기 때문
  if FCalculatedItemTimerHandle <> -1 then
    FPJHTimerPool.Enabled[FCalculatedItemTimerHandle] := False;

  for i := NextGrid1.RowCount - 1 Downto 0 do
    if NextGrid1.Row[i].Selected then
      DeleteEngineParamterFromGrid(i);

  //삭제시 Calculated Item은 NextGrid1.Data에 저장된 StringList의 내용(TagName=Grid.RowIndex)을 갱신해야 함
  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FormulaValueList <> '' then
    begin
      //Formula Fetch
      LStr := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].SharedName;
      ReAssignFormulaValueList(LStr, i);
    end;
  end;

  if FCalculatedItemTimerHandle <> -1 then
    FPJHTimerPool.Enabled[FCalculatedItemTimerHandle] := True;

  if IPCMonitorAll1.AssignedIPCMonitor(psECS_Woodward) then
    IPCMonitorAll1.FCompleteReadMap_Woodward := True;

  if IPCMonitorAll1.AssignedIPCMonitor(psECS_kumo) then
    IPCMonitorAll1.FCompleteReadMap_kumo := True;

  if IPCMonitorAll1.AssignedIPCMonitor(psECS_AVAT) then
    IPCMonitorAll1.FCompleteReadMap_Avat := True;
end;

procedure THiMECSWatchBaseForm.DropTextTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
begin
  // Determine if we got our custom format.
  if (FEngineParameterTarget.HasData) then
  begin
    // Extract the dropped data into our custom struct.
    //FEngineParameterTarget.GetDataHere(FEngineParameterTarget.EPD, sizeof(FEngineParameterTarget.EPD));

    case FEngineParameterTarget.EPD.FDragDataType of
      dddtSingleRecord: begin
        //CreateIPCMonitor(FEngineParameterTarget.EPD[0]);//FEngineParameterTarget.EPD);
        CreateIPCMonitor(FEngineParameterTarget.EPD.FEPItem);
      end;
      dddtMultiRecord: begin//ShowMessage(IntToStr(FEngineParameterTarget.EPD.FSourceHandle));
        SendHandleCopyData(FEngineParameterTarget.EPD.FSourceHandle, Handle, WParam_REQMULTIRECORD);
        JvStatusBar1.SimpleText := 'Send WParam_REQMULTIRECORD to ' + IntToStr(FEngineParameterTarget.EPD.FSourceHandle);
      end;
    end;
  end else
    ;//PanelDest.Caption := TDropTextTarget(Sender).Text;
end;

procedure THiMECSWatchBaseForm.EnableAlphaCBClick(Sender: TObject);
begin
  AlphaBlend := EnableAlphaCB.Checked;
end;

procedure THiMECSWatchBaseForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if SaveListCB.Checked then
    SaveWatchFile(FWatchListFileName);

  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  FCompoundItemList.Free;
  IPCMonitorAll1.DestroyIPCMonitorAll;
  FEngineParameterTarget.Free;
  FEngParamSource.Free;

end;

procedure THiMECSWatchBaseForm.FormCreate(Sender: TObject);
begin
  InitVar;

  NextGrid1.DoubleBuffered := False;
end;

procedure THiMECSWatchBaseForm.FreeStrListFromGrid(AIndex: integer);
var
  it: DIterator;
  i: integer;
begin
  it := FCompoundItemList.start;
  while iterateOver(it) do
  begin
    i := GetInteger(it);

    if AIndex = -1 then //모든 List Free(OnDestroy시에)
    begin
      TStringList(NextGrid1.Row[i].Data).Free;
    end
    else //DeleteItem선택시에 실행됨
    begin
      if AIndex = i then
      begin
        FCompoundItemList.removeAt(i);
        TStringList(NextGrid1.Row[i].Data).Free;
      end;
    end;
  end;
end;

procedure THiMECSWatchBaseForm.GetEngineParameterFromSavedFile(
  AFileName: string; AEncrypt: Boolean);
var
  i, j: integer;
  LStr: string;
  LStrList: TStringList;
begin
  if FileExists(AFileName) then
  begin
    if NextGrid1.RowCount > 0 then
    begin
      if MessageDlg('Do you want to apppend the watch list to the grid?',
                                mtConfirmation, [mbYes, mbNo], 0)= mrYes then
      begin
        AppendEngineParameterFromFile(AFileName,AEncrypt);
      end
      else
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
        FCompoundItemList.clear;

        IPCMonitorAll1.FEngineParameter.LoadFromJSONFile(AFileName,
                  ExtractFileName(AFileName),AEncrypt);
      end;

      NextGrid1.ClearRows;
    end
    else
    begin
      IPCMonitorAll1.FEngineParameter.LoadFromJSONFile(AFileName,
                ExtractFileName(AFileName), AEncrypt);
    end;

    //Administrator이상의 권한자 만이 Save user level 조정 가능함
    if IPCMonitorAll1.FCurrentUserLevel <= HUL_Administrator then
    begin
      AllowUserlevelCB.Enabled := True;
    end;

    AllowUserlevelCB.Text := UserLevel2String(IPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList);

    if AllowUserlevelCB.Text = '' then
      AllowUserlevelCB.Text := UserLevel2String(IPCMonitorAll1.FCurrentUserLevel);

    Width := IPCMonitorAll1.FEngineParameter.FormWidth;
    Height := IPCMonitorAll1.FEngineParameter.FormHeight;
    Top := IPCMonitorAll1.FEngineParameter.FormTop;
    Left := IPCMonitorAll1.FEngineParameter.FormLeft;
    WindowState := TWindowState(IPCMonitorAll1.FEngineParameter.FormState);

    for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      IPCMonitorAll1.MoveEngineParameterItemRecord2(FEngineParameterItemRecord,i);

      IPCMonitorAll1.CreateIPCMonitor(FEngineParameterItemRecord, true);

      j := NextGrid1.AddRow();

      NextGrid1.Cell[0, j].AsInteger := -1;
      NextGrid1.Cell[1, j].AsInteger := -1;
      NextGrid1.Cell[5, j].AsInteger := -1;
      NextGrid1.Cell[6, j].AsInteger := -1;

      if FEngineParameterItemRecord.FDescription = '' then
        NextGrid1.CellsByName['ItemName', j] := FEngineParameterItemRecord.FTagName
      else
        NextGrid1.CellsByName['ItemName', j] := FEngineParameterItemRecord.FDescription;

      NextGrid1.CellsByName['FUnit', j] := FEngineParameterItemRecord.FUnit;

      if FEngineParameterItemRecord.FParameterSource = psManualInput then
        NextGrid1.CellsByName['Value', j] := FEngineParameterItemRecord.FValue;

      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FormulaValueList <> '' then
      begin
        NextGrid1.CellByName['ItemName',j].AsString :=
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;

        LStr := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FormulaValueList;
        LStrList := TStringList.Create;
        LStrList.Text := LStr;
        NextGrid1.Row[j].Data := LStrList;
        FCompoundItemList.add([j]);

        if FCalculatedItemTimerHandle = -1 then
          FCalculatedItemTimerHandle := FPJHTimerPool.Add(OnDisplayCalculatedItemValue,1000);
      end;
    end; //for
  end;
end;

procedure THiMECSWatchBaseForm.InitVar;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  SetCurrentDir(FFilePath);
  IPCMonitorAll1.FNextGrid := NextGrid1;
  IPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;
  IPCMonitorAll1.FWatchValue2Screen_DigitalEvent := WatchValue2Screen_Digital;
  FCompoundItemList := DArray.Create;
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FCalculatedItemTimerHandle := -1;
  FEngineParameterTarget := TEngineParameterDataFormat.Create(DropTextTarget1);
  FEngParamSource := TEngineParameterDataFormat.Create(EngParamSource2);
end;

procedure THiMECSWatchBaseForm.JvTrackBar1Change(Sender: TObject);
begin
  if EnableAlphaCB.Checked then
    AlphaBlendValue := JvTrackBar1.Position;
end;

procedure THiMECSWatchBaseForm.LoadWatchListFromFile1Click(Sender: TObject);
begin
  SetCurrentDir(FFilePath);
  JvOpenDialog1.InitialDir := WatchListPath;
  JvOpenDialog1.Filter := '*.*';

  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      FWatchListFileName := jvOpenDialog1.FileName;
      GetEngineParameterFromSavedFile(FWatchListFileName, False);
    end;
  end;

end;

procedure THiMECSWatchBaseForm.NextGrid1DblClick(Sender: TObject);
var
  LRect: TRect;
  LPoint: TPoint;
begin
  LRect := NextGrid1.GetHeaderRect;
//  LPoint.X := Mouse.CursorPos;
//  LPoint.Y := Y;

  if PtInRect(LRect, FMousePoint) then
    exit;

  SetupProperties;
end;

procedure THiMECSWatchBaseForm.NextGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_delete: begin
      DeleteParamItems;
      //DeleteEngineParamterFromGrid(NextGrid1.SelectedRow);
    end;
  end;
end;

procedure THiMECSWatchBaseForm.NextGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  LEngineParameterItem: TEngineParameterItem;
  LRect: TRect;
  LPoint: TPoint;
begin
  LRect := NextGrid1.GetHeaderRect;
  LPoint.X := X;
  LPoint.Y := Y;

  if PtInRect(LRect, LPoint) then
    exit;

  if NextGrid1.SelectedCount > 0 then
  begin
    if (DragDetectPlus(TWinControl(Sender).Handle, Point(X,Y))) then
    begin
      for i := 0 to NextGrid1.RowCount - 1 do
      begin
        if NextGrid1.Row[i].Selected then
        begin
          IPCMonitorAll1.MoveEngineParameterItemRecord2(FEngineParameterItemRecord,i);

          // Transfer the structure to the drop source data object and execute the drag.
          //FEngParamSource.SetDataHere(FEP_DragDrop, sizeof(FEP_DragDrop));
          //FEngParamSource.EPD := FEngineParameterItemRecord;

          EngParamSource2.Execute;
          exit;
        end;
      end;
    end;

  end;
end;

procedure THiMECSWatchBaseForm.NextGrid1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  FMousePoint.X := X;
  FMousePoint.Y := Y;
end;

procedure THiMECSWatchBaseForm.NextGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  LEngineParameterItem: TEngineParameterItem;
  Li: integer;
begin
  if NextGrid1.SelectedCount = 1 then
  begin
    Li := NextGrid1.SelectedRow;
    LEngineParameterItem :=
              IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[Li];
    TNxButtonColumn(NextGrid1.Columns.Item[3]).ShowButton :=
                        LEngineParameterItem.ParameterType in TMatrixTypes;
  end;
end;

procedure THiMECSWatchBaseForm.OnDisplayCalculatedItemValue(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
var
  it: DIterator;
  i,j,k,r: integer;
  LNameStrings, LStrList: TStringList;
  Largs : array [0..100] of extended;
  LDouble: Double;
begin
  LNameStrings := TStringList.Create;
  try
    it := FCompoundItemList.start;

    while iterateOver(it) do
    begin
      i := GetInteger(it);

      if i > (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1) then
        exit;

      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].SharedName = '' then
        exit;

      CalcExpress1.Formula :=
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].SharedName;

      LNameStrings.Clear;
      LStrList := TStringList(NextGrid1.Row[i].Data);
      for j := 0 to TStringList(NextGrid1.Row[i].Data).Count - 1 do
      begin
        LNameStrings.Add(LStrList.Names[j]);
        k := StrToInt(LStrList.ValueFromIndex[j]);
        //k가 Collect 범위 내에 존재 하면
        if k < IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count then
          Largs[j] := StrToFloatDef(
            IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[k].Value,0.0);
      end;

      CalcExpress1.Variables := LNameStrings;//.Assign(LNameStrings);
      try
        LDouble := CalcExpress1.calc(Largs);
      except
        LDouble := 0;
      end;
      IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value :=
        Format('%.2f', [LDouble]);
      r := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
      if r = 0 then
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value :=
          Format('%d', [Round(LDouble)]);

      WatchValue2Screen_Analog('', '', i);
    end;//while

  finally
    FreeAndNil(LNameStrings);
  end;
end;

procedure THiMECSWatchBaseForm.Properties1Click(Sender: TObject);
begin
  SetupProperties;
end;

function THiMECSWatchBaseForm.ReAssignFormulaValueList(AFormula: string;
  AIndex: integer): TStringList;
var
  i,j: integer;
  LStr: string;
  LStrList: TStringList;
begin
  Result:= TStringList.Create;
  //LtmpList := TStringList.Create;;
  //CalcExpress1.Formula := ExprEdt.Text;
  //CalcExpress1.Variables.Assign(LtmpList);
  CalcExpress1.init(AFormula,True);//make variable list from the formula

  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    LStr := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName;
    //if Pos(LStr, ExprEdt.Text) > 0 then
    //begin
      //LStrList.Add(LStr + '=' + IntToStr(i));

    j := CalcExpress1.Variables.IndexOf(LStr);

    if j > -1 then
      Result.Add(LStr + '=' + IntToStr(i));
  end;
  //CalcExpress1.Variables.Count와 Result.Count가 다를 경우 처리는 어떻게? -> 2013.7.18
  //FreeAndNil(LtmpList);

  if AIndex > -1 then
  begin
    TStringList(NextGrid1.Row[AIndex].Data).Clear;
    TStringList(NextGrid1.Row[AIndex].Data).Assign(Result);
    IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AIndex].FormulaValueList :=
      Result.Text;
  end;
end;

procedure THiMECSWatchBaseForm.SaveWatchFile(AFileName: string; APath: string);
var
  LStr: string;
begin
  if APath <> '' then
  begin
    SetCurrentDir(FFilePath);
    if not setcurrentdir(APath) then
      createdir(APath);
  end;

  SetCurrentDir(FFilePath);

  IPCMonitorAll1.FEngineParameter.FormWidth := Width;
  IPCMonitorAll1.FEngineParameter.FormHeight := Height;
  IPCMonitorAll1.FEngineParameter.FormTop := Top;
  IPCMonitorAll1.FEngineParameter.FormLeft := Left;
  IPCMonitorAll1.FEngineParameter.FormState := TpjhWindowState(WindowState);

  if AFileName = '' then //file name 앞에 프로그램명(1=HiMECS_Watch2.exe) 붙임
    LStr := APath+formatDateTime('1yyyymmddhhnnsszz',now)+
      '1' + //IntToStr(FConfigOption.EngParamFileFormat) +
      IntToStr(Ord(IPCMonitorAll1.FEngineParameter.AllowUserLevelWatchList))
  else
    LStr := APath+AFileName;

  IPCMonitorAll1.FEngineParameter.SaveToJSONFile(LStr,
            ExtractFileName(LStr),False);
end;

procedure THiMECSWatchBaseForm.SaveWatchLittoNewName1Click(Sender: TObject);
var
  LFileName: string;
begin
  SetCurrentDir(FFilePath);
  JvSaveDialog1.InitialDir := '..\WatchList';

  if JvSaveDialog1.Execute then
  begin
    LFileName := JvSaveDialog1.FileName;

    if FileExists(LFileName) then
    begin
      if MessageDlg('File is already existed. Are you overwrite? if No press, then the data is not saved!.',
      mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        exit;
    end;
  end;

  SaveWatchFile(LFileName, '');
end;

procedure THiMECSWatchBaseForm.SetConfigEngParamItemData(AIndex: Integer);
var
  ConfigData: TEngParamItemConfigForm;
  LEngineParameterItem: TEngineParameterItem;
  Li: integer;
begin
  ConfigData := nil;
  ConfigData := TEngParamItemConfigForm.Create(Self);
  LEngineParameterItem := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AIndex];

  try
    with ConfigData do
    begin
      LoadConfigEngParamItem2Form(LEngineParameterItem);
      if ShowModal = mrOK then
      begin
        Li := LoadConfigForm2EngParamItem(IPCMonitorAll1.FEngineParameter, LEngineParameterItem);
        if Li <> -1 then
        begin
          if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[Li].ParameterSource = psManualInput then
            NextGrid1.Cells[3, AIndex] := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[Li].Value;
        end;

      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure THiMECSWatchBaseForm.SetupProperties;
var
  Li: integer;
begin
  if NextGrid1.SelectedCount > 1 then
  begin
    ShowMessage('This function allows when selected only one row!');
    exit;
  end;

  if NextGrid1.SelectedCount = 1 then
  begin
    Li := NextGrid1.SelectedRow;
    if Li > IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 then
    begin
      ShowMessage('Selected Row Index is greater than Parameter Collect Index');
      exit;
    end;

    SetConfigEngParamItemData(Li);
  end;
end;

procedure THiMECSWatchBaseForm.StayOnTopCBClick(Sender: TObject);
begin
  if StayOnTopCB.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure THiMECSWatchBaseForm.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer);
var
  tmpdouble: double;
  i: integer;
begin
  tmpdouble := StrToFloatDef(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value, 0.0);

  case PageControl1.ActivePageIndex of
    0: begin //Items
        NextGrid1.CellsByName['Value', AEPIndex] := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
    end;
  end;
end;

procedure THiMECSWatchBaseForm.WatchValue2Screen_Digital(Name, AValue: string;
  AEPIndex: integer);
var
  LDouble: double;
  i: integer;
begin
  LDouble := StrToFloatDef(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value, 0.0);

  case PageControl1.ActivePageIndex of
    0: begin //Items
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value = '0' then
        NextGrid1.CellsByName['Value', AEPIndex] := 'False'
      else
        NextGrid1.CellsByName['Value', AEPIndex] := 'True';
    end;
  end;//case

end;

procedure THiMECSWatchBaseForm.WMCopyData(var Msg: TMessage);
begin
  CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^);
end;

end.
