unit UnitParamList;

interface

uses
  DragDrop,
  DropSource,
  DragDropFormats,
  DragDropText,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NxCollection, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, NxColumns, NxColumnClasses, EngineParameterClass,
  HiMECSConst, AdvOfficeStatusBar, Vcl.StdCtrls, Vcl.Mask, JvExMask, JvToolEdit,
  UnitFrameIPCMonitorAll, IPCThrdMonitor_Generic, //IPC_ModbusComm_Const
  IPC_HIC_Const, NxEdit, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList, ModbusComConst_endurance,//ModbusComConst_HIC,
  MatrixParameterConst, DragDropRecord, DropTarget, CopyData, Vcl.Menus,
  UnitFrameWatchGrid;

type
  TFormParamList = class(TForm)
    NxToolbar1: TNxToolbar;
    DropTextSource1: TDropTextSource;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton7: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton2: TToolButton;
    ToolButton11: TToolButton;
    JvFilenameEdit1: TJvFilenameEdit;
    btnOpen: TButton;
    SaveDialog1: TSaveDialog;
    FileEncryptCB: TNxCheckBox;
    DropTextTarget1: TDropTextTarget;
    PopupMenu1: TPopupMenu;
    DeleteItems1: TMenuItem;
    FWG: TFrameWatchGrid;
    IPCMonitorAll1: TFrameIPCMonitor;
    procedure FormCreate(Sender: TObject);
    procedure NextGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnOpenClick(Sender: TObject);
    procedure ValueButtonClick(Sender: TObject);
    procedure ToolButton21Click(Sender: TObject);
    procedure FileEncryptCBChange(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure NextGrid1SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure DropTextTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure DeleteItems1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FIPCMonitor: TIPCMonitor<TEventData_HIC>;
    FDragFormatSource: TGenericDataFormat;
    FEngineParameterTarget: TEngineParameterDataFormat;
    //FEngineParameter: TEngineParameter;
    FParamCommData: TEventData_HIC;
    FSharedMN: string;
    FFileEncrypt: Boolean;
    FMatrixFormList: TStringList;

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WMMatrixFormClose(var Msg: TMessage); message WM_MATRIXFORMCLOSE;
    procedure WMScalarFormClose(var Msg: TMessage); message WM_SCALARFORMCLOSE;
    procedure UpdateTrace_Param(var Msg: TEventData_HIC); message WM_EVENT_PARAM_COMM;
    procedure Param_OnSignal(Data: TEventData_HIC); virtual;
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer);
    procedure DeleteEngineParamterFromGrid(AIndex: integer);
  public
    function Parameter2Grid(AParam: TEngineParameter): integer;overload;
    function Parameter2Grid(AParam: TEngineParameterItem): integer;overload;
    function Parameter2Grid(AParam: TEngineParameterItemRecord): integer;overload;
    function AssignMatrixItem(AMatrix: TMatrixItem):integer;
    procedure SetNodeIndex(AParamIdx, ANodeIndex: integer);
    procedure SetConfig;
    procedure SetMatrixData;
    procedure SetSalarValue;
    procedure CreateIPCMonitor(ASharedName: string);  overload;
    function CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord; AIsOnlyCreate: Boolean = False): integer; overload;
    procedure OnCloseMatrixForm(AHandle: integer);
    procedure OnCloseScalarForm(AHandle: integer);
    procedure DoOnClose;
  end;

var
  FormParamList: TFormParamList;

implementation

uses UnitSetMatrix, UnitSetScalarValue;

{$R *.dfm}

procedure Create_ParamListp;
begin
  TFormParamList.Create(Application);
end;

function TFormParamList.AssignMatrixItem(AMatrix: TMatrixItem):integer;
begin
  Result := -1;
  IPCMonitorAll1.FEngineParameter.MatrixCollect.AddMatrixItem(AMatrix);
  Result := IPCMonitorAll1.FEngineParameter.MatrixCollect.Count - 1;
end;

procedure TFormParamList.btnOpenClick(Sender: TObject);
var
  LStr: string;
begin
  LStr := jvFileNameEdit1.FileName;
  if FileExists(LStr) then
  begin
    IPCMonitorAll1.FEngineParameter.LoadFromJSONFile(LStr,ExtractFileName(LStr),FFileEncrypt);
    //MatrixPublished2Public는 LoadFromJSONFile 함수에서 실행하므로 comment 처리함(2013.2.21)
    //FEngineParameter.MatrixPublished2Public;
    Parameter2Grid(IPCMonitorAll1.FEngineParameter);
    CreateIPCMonitor('');
  end;
end;

function TFormParamList.CreateIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord; AIsOnlyCreate: Boolean = False): integer;
var
  i, LResult: integer;
begin
  LResult := IPCMonitorAll1.CreateIPCMonitor(AEP_DragDrop);

  if LResult = -1 then  //신규 아이템이면 Grid에 추가
  begin
    if not AIsOnlyCreate then
      Parameter2Grid(AEP_DragDrop);
  end;
end;

procedure TFormParamList.CreateIPCMonitor(ASharedName: string);
begin
  if Assigned(FIPCMonitor) then
    exit;

  if ASharedName = '' then
    ASharedName := ParameterSource2SharedMN(psHIC);

  FIPCMonitor := TIPCMonitor<TEventData_HIC>.Create(ASharedName, HIC_EVENT_NAME, True);
  FIPCMonitor.FIPCObject.OnSignal := Param_OnSignal;
  FIPCMonitor.FreeOnTerminate := True;
  FIPCMonitor.Resume;
end;

procedure TFormParamList.DeleteEngineParamterFromGrid(AIndex: integer);
begin
  FWG.NextGrid1.DeleteRow(AIndex);
  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Delete(AIndex);
end;

procedure TFormParamList.DeleteItems1Click(Sender: TObject);
var
  i: integer;
begin
  for i := FWG.NextGrid1.RowCount - 1 Downto 0 do
    if FWG.NextGrid1.Row[i].Selected then
      DeleteEngineParamterFromGrid(i);
end;

procedure TFormParamList.DoOnClose;
var
  i: integer;
begin
  IPCMonitorAll1.DestroyIPCMonitorAll;

  for i := 0 to FMatrixFormList.Count - 1 do
  begin
    TSetMatrixForm(FMatrixFormList.Objects[i]).Free;
  end;

  FMatrixFormList.Free;

  FEngineParameterTarget.Free;
  //FEngineParameter.Free;
  FDragFormatSource.Free;
//  Action := caFree;
end;

procedure TFormParamList.DropTextTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
begin
  if (FEngineParameterTarget.HasData) then
  begin

    case FEngineParameterTarget.EPD.FDragDataType of
      dddtSingleRecord: begin
        CreateIPCMonitor(FEngineParameterTarget.EPD.FEPItem);
      end;
      dddtMultiRecord: begin
        SendHandleCopyData(FEngineParameterTarget.EPD.FSourceHandle, Handle, WParam_REQMULTIRECORD);
        AdvOfficeStatusBar1.SimpleText := 'Send WParam_REQMULTIRECORD to ' + IntToStr(FEngineParameterTarget.EPD.FSourceHandle);
      end;
    end;
  end else
    ;//PanelDest.Caption := TDropTextTarget(Sender).Text;
end;

procedure TFormParamList.FileEncryptCBChange(Sender: TObject);
begin
  FFileEncrypt := FileEncryptCB.Checked;
end;

procedure TFormParamList.FormCreate(Sender: TObject);
begin
{$IFDEF HiMECS}
  FormStyle := fsMDIChild;
{$ELSE}
  FormStyle := fsNormal;
{$ENDIF}

  FDragFormatSource := TGenericDataFormat.Create(DropTextSource1);
  FDragFormatSource.AddFormat(sDragFormatParam);
  FEngineParameterTarget := TEngineParameterDataFormat.Create(DropTextTarget1);
  //FEngineParameter := TEngineParameter.Create(Self);
  FMatrixFormList := TStringList.Create;
  IPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;
end;

procedure TFormParamList.FormDestroy(Sender: TObject);
begin
  DoOnClose;
end;

procedure TFormParamList.ValueButtonClick(Sender: TObject);
begin
  SetConfig;
end;

procedure TFormParamList.NextGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  DFP: RDragFormatParam;
  i: integer;
  LStr: string;
begin
  if (DragDetectPlus(TWinControl(Sender).Handle, Point(X,Y))) then
  begin
    // Transfer time as text. This is not nescessary and is only done to offer
    // maximum flexibility in case the user wishes to drag our data to some
    // other application (e.g. a word processor).
    DropTextSource1.Text := 'Parameter Drag from NextGrid';

    for i := 0 to FWG.NextGrid1.RowCount - 1 do
    begin
      if FWG.NextGrid1.Selected[i] then
      begin
        if DFP.FCollectIndex = '' then
          LStr := ''
        else
          LStr := ',';

        DFP.FCollectIndex := DFP.FCollectIndex + LStr + FWG.NextGrid1.CellByName['CollectIndex',i].AsString
      end;
    end;

    // Transfer the structure to the drop source data object and execute the drag.
    FDragFormatSource.SetDataHere(DFP, sizeof(DFP));

    DropTextSource1.Execute;
  end;
end;

procedure TFormParamList.NextGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  LEngineParameterItem: TEngineParameterItem;
  Li: integer;
begin
  if FWG.NextGrid1.SelectedCount = 1 then
  begin
    Li := FWG.NextGrid1.SelectedRow;
    LEngineParameterItem :=
              IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[Li];
    TNxButtonColumn(FWG.NextGrid1.ColumnByName['Value']).ShowButton := //Columns.Item[2]
                                  LEngineParameterItem.SensorType = stConfig;
  end;
end;

procedure TFormParamList.OnCloseMatrixForm(AHandle: integer);
var
  i,j: integer;
  LStr: string;
  LSetMatrixForm: TSetMatrixForm;
begin
  i := FMatrixFormList.IndexOf(IntToStr(AHandle));

  if i = -1 then
    exit;

  LSetMatrixForm := TSetMatrixForm(FMatrixFormList.Objects[i]);

  try
    j := IPCMonitorAll1.FEngineParameter.ComparePublicMatrix(LSetMatrixForm.FEngineParameter);

    if j <> 0 then
    begin
      LStr := 'Parameter data is modified. Do you want to accept?'+#13#10#13#10+
          'Yes: Adapt to current parameter on memory, No: discard changed.';
      if MessageDlg(LStr, mtConfirmation, [mbYes, mbNo], 0)= mrYes then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
        IPCMonitorAll1.FEngineParameter.MatrixCollect.Clear;
        IPCMonitorAll1.FEngineParameter.Assign(LSetMatrixForm.FEngineParameter);
      end;
    end;
  finally
    FreeAndNil(LSetMatrixForm);
    FMatrixFormList.Delete(i);
  end;
end;

procedure TFormParamList.OnCloseScalarForm(AHandle: integer);
var
  i: integer;
  LStr: string;
  LSetScalarValueF: TSetScalarValueF;
begin
  i := FMatrixFormList.IndexOf(IntToStr(AHandle));

  if i = -1 then
    exit;

  LSetScalarValueF := TSetScalarValueF(FMatrixFormList.Objects[i]);

  try
    if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[LSetScalarValueF.FParamItemIndex].Value <>
      LSetScalarValueF.FrameCnM.FEngineParameter.EngineParameterCollect.Items[LSetScalarValueF.FParamItemIndex].Value then
    begin
      LStr := 'Scalar Value is modified. Do you want to accept?'+#13#10#13#10+
          'Yes: Adapt to current parameter on memory, No: discard changed.';
      if MessageDlg(LStr, mtConfirmation, [mbYes, mbNo], 0)= mrYes then
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[LSetScalarValueF.FParamItemIndex].Value :=
          LSetScalarValueF.FrameCnM.FEngineParameter.EngineParameterCollect.Items[LSetScalarValueF.FParamItemIndex].Value;
    end;
  finally
    FreeAndNil(LSetScalarValueF);
    FMatrixFormList.Delete(i);
  end;
end;

function TFormParamList.Parameter2Grid(AParam: TEngineParameterItem): integer;
begin
  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.AddEngineParameterItem(AParam);

  Result := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1;

  FWG.NextGrid1.BeginUpdate;
  try
    FWG.NextGrid1.AddRow();
    FWG.NextGrid1.CellByName['ItemName','Last'].AsString := AParam.TagName;
    FWG.NextGrid1.CellByName['ItemType','Last'].AsString :=
      ParameterType2String(AParam.ParameterType);
    FWG.NextGrid1.CellByName['FUnit','Last'].AsString := AParam.UnitName;
    FWG.NextGrid1.CellByName['Description','Last'].AsString := AParam.Description;
    FWG.NextGrid1.CellByName['SensorType','Last'].AsString :=
      SensorType2String(AParam.SensorType);
    FWG.NextGrid1.CellByName['CollectIndex','Last'].AsInteger := 0;
  finally
    FWG.NextGrid1.EndUpdate;
  end;
end;

function TFormParamList.Parameter2Grid(
  AParam: TEngineParameterItemRecord): integer;
var
  i: integer;
begin
  //i := IPCMonitorAll1.CheckExistTagName(AParam.FParameterSource,AParam.FTagName);

  //if i = -1 then
  //begin
    FWG.NextGrid1.BeginUpdate;
    try
      Result := FWG.NextGrid1.AddRow();
      FWG.NextGrid1.CellByName['ItemName',Result].AsString := AParam.FTagName;
      FWG.NextGrid1.CellByName['ItemType',Result].AsString :=
        ParameterType2String(AParam.FParameterType);
      FWG.NextGrid1.CellByName['FUnit',Result].AsString := AParam.FUnit;
      FWG.NextGrid1.CellByName['Description',Result].AsString := AParam.FDescription;
      FWG.NextGrid1.CellByName['SensorType',Result].AsString :=
        SensorType2String(AParam.FSensorType);
      FWG.NextGrid1.CellByName['CollectIndex',Result].AsInteger := 0;
    finally
      Result := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1;
      FWG.NextGrid1.EndUpdate;
    end;
  //end;
end;

procedure TFormParamList.Param_OnSignal(Data: TEventData_HIC);
begin
  if Data.DataMode = 1 then //CM_CONFIG_READ
    exit;

  System.Move(Data, FParamCommData, Sizeof(Data));
  SendMessage(Handle, WM_EVENT_PARAM_COMM, 0,0);
end;

procedure TFormParamList.SetConfig;
var
  i: integer;
begin
  i := FWG.NextGrid1.SelectedRow;

  if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].SensorType <> stConfig then
    exit;

  if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsMatrixData then
    SetMatrixData
  else
    SetSalarValue;
end;

procedure TFormParamList.SetMatrixData;
var
  LSetMatrixForm: TSetMatrixForm;
begin
  LSetMatrixForm := TSetMatrixForm.Create(Self);
  FMatrixFormList.AddObject(IntToStr(LSetMatrixForm.Handle),LSetMatrixForm);
  try
    LSetMatrixForm.FMainFormHandle := Handle;
    LSetMatrixForm.FParamItemIndex := FWG.NextGrid1.SelectedRow;
    LSetMatrixForm.Assign2EngineParameter(IPCMonitorAll1.FEngineParameter);
    LSetMatrixForm.CreateIPCMonitor(FSharedMN);
    LSetMatrixForm.MoveParameter2Grid;
    LSetMatrixForm.SetDisplay;
    LSetMatrixForm.Show;
  finally
  end;
end;

procedure TFormParamList.SetNodeIndex(AParamIdx, ANodeIndex: integer);
begin
  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParamIdx].MatrixItemIndex := ANodeIndex;
end;

procedure TFormParamList.SetSalarValue;
var
  LSetScalarValueF: TSetScalarValueF;
begin
  LSetScalarValueF := TSetScalarValueF.Create(Self);
  FMatrixFormList.AddObject(IntToStr(LSetScalarValueF.Handle),LSetScalarValueF);
  try
    LSetScalarValueF.FMainFormHandle := Handle;
    LSetScalarValueF.FParamItemIndex := FWG.NextGrid1.SelectedRow;
    LSetScalarValueF.FrameCnM.FEngineParameter.Assign(IPCMonitorAll1.FEngineParameter);
    LSetScalarValueF.FrameCnM.CreateIPCMonitor(FSharedMN, LSetScalarValueF.Matrix_OnSignal);
    LSetScalarValueF.MoveParameter2Component;
    //LSetScalarValueF.SetDisplay;
    LSetScalarValueF.Show;
  finally
  end;
end;

procedure TFormParamList.ToolButton13Click(Sender: TObject);
begin
  FWG.NextGrid1.ClearRows;
  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
  IPCMonitorAll1.FEngineParameter.MatrixCollect.Clear;
end;

procedure TFormParamList.ToolButton21Click(Sender: TObject);
var
  LStr: string;
begin
  if SaveDialog1.Execute then
  begin
    LStr := ExtractFileName(SaveDialog1.FileName);
    IPCMonitorAll1.FEngineParameter.SaveToJSONFile(SaveDialog1.FileName, LStr, FFileEncrypt);
  end;

end;

procedure TFormParamList.UpdateTrace_Param(var Msg: TEventData_HIC);
var
  i,j: integer;
  LStr: string;
begin
  j := 0;

  for i := 0 to FWG.NextGrid1.RowCount - 1 do
  begin
    if (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].SensorType = stConfig) and
      (IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].IsMatrixData) then
      continue;

    IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FParamCommData.InpDataBuf[j]);
    FWG.NextGrid1.CellsByName['Value', i] := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value;
    Inc(j);
  end;
end;

procedure TFormParamList.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer);
begin
  FWG.NextGrid1.CellsByName['Value', AEPIndex] := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
end;

procedure TFormParamList.WMCopyData(var Msg: TMessage);
begin
  CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^);
end;

procedure TFormParamList.WMMatrixFormClose(var Msg: TMessage);
begin
  OnCloseMatrixForm(Msg.WParam);//Msg.WParam = MatrixForm Handle
end;

procedure TFormParamList.WMScalarFormClose(var Msg: TMessage);
begin
  OnCloseScalarForm(Msg.WParam);//Msg.WParam = MatrixForm Handle
end;

function TFormParamList.Parameter2Grid(AParam: TEngineParameter): integer;
var
  i: integer;
begin
  FWG.NextGrid1.Options := FWG.NextGrid1.Options - [goUseDefaultValues];
  FWG.NextGrid1.BeginUpdate;
  try
    FWG.NextGrid1.ClearRows;

    for i := 0 to AParam.EngineParameterCollect.Count - 1 do
    begin
      FWG.NextGrid1.AddRow();
      FWG.NextGrid1.CellByName['ItemName','Last'].AsString := AParam.EngineParameterCollect.Items[i].TagName;
      FWG.NextGrid1.CellByName['ItemType','Last'].AsString :=
        ParameterType2String(AParam.EngineParameterCollect.Items[i].ParameterType);
      FWG.NextGrid1.CellByName['FUnit','Last'].AsString := AParam.EngineParameterCollect.Items[i].FFUnit;
      FWG.NextGrid1.CellByName['Description','Last'].AsString := AParam.EngineParameterCollect.Items[i].Description;
      FWG.NextGrid1.CellByName['SensorType','Last'].AsString :=
        SensorType2String(AParam.EngineParameterCollect.Items[i].SensorType);
      FWG.NextGrid1.CellByName['CollectIndex','Last'].AsInteger := i;
      if (i mod 2) <> 0 then
      begin
        FWG.NextGrid1.CellByName['ItemName','Last'].Color := $00E9FFD2;
        FWG.NextGrid1.CellByName['ItemType','Last'].Color := $00E9FFD2;
        FWG.NextGrid1.CellByName['Value','Last'].Color := $00E9FFD2;
        FWG.NextGrid1.CellByName['FUnit','Last'].Color := $00E9FFD2;
        FWG.NextGrid1.CellByName['Description','Last'].Color := $00E9FFD2;
        FWG.NextGrid1.CellByName['SensorType','Last'].Color := $00E9FFD2;
        FWG.NextGrid1.CellByName['CollectIndex','Last'].Color := $00E9FFD2;
      end;
    end;
  finally
    FWG.NextGrid1.EndUpdate;
  end;

end;

exports //The export name is Case Sensitive
  Create_ParamListp;

end.
