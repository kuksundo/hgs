unit UnitSetMatrix;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, AdvSmoothPanel, AdvEdit, AdvSmoothExpanderPanel, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, Vcl.Buttons,
  IPCThrdClient_Generic, UnitIPCClientAll, IPC_HIC_Const, HiMECSConst,
  IPCThrdMonitor_Generic, IPC_ModbusComm_Const, EngineParameterClass, ModbusComConst_HIC,
  NxEdit, Vcl.ToolWin, Vcl.ImgList, AdvOfficeButtons,
  NxCollection, iComponent, iVCLComponent, iCustomComponent, iSwitchLed,
  Vcl.Mask, AdvDropDown, AdvColorPickerDropDown, AsgCombo, ColorCombo;

type
  TSetMatrixForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    Panel4: TPanel;
    Panel5: TPanel;
    MatrixInfoPanel: TAdvSmoothExpanderPanel;
    XLabel: TLabel;
    YLabel: TLabel;
    ZLabel: TLabel;
    XDescEdit: TAdvEdit;
    YDescEdit: TAdvEdit;
    ZDescEdit: TAdvEdit;
    XCurValueEdit: TAdvEdit;
    YCurValueEdit: TAdvEdit;
    ZCurValueEdit: TAdvEdit;
    YAxisPanel: TPanel;
    YGrid: TAdvStringGrid;
    Panel6: TPanel;
    MatrixGrid: TAdvStringGrid;
    XGrid: TAdvStringGrid;
    ZAxisPanel: TPanel;
    ZGrid: TAdvStringGrid;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ValuePanel: TPanel;
    Label7: TLabel;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    ToolButton20: TToolButton;
    btnRedo: TToolButton;
    btnUndo: TToolButton;
    ToolButton1: TToolButton;
    btnSave: TToolButton;
    btnOpen: TToolButton;
    ToolButton2: TToolButton;
    OpenDialog1: TOpenDialog;
    DataEditCB: TNxCheckBox;
    iSwitchLed1: TiSwitchLed;
    iSwitchLed2: TiSwitchLed;
    MatrixGridUndoRedo: TAdvGridUndoRedo;
    YGridUndoRedo: TAdvGridUndoRedo;
    ZGridUndoRedo: TAdvGridUndoRedo;
    XGridUndoRedo: TAdvGridUndoRedo;
    ToolButton3: TToolButton;
    WriteConfirmCB: TNxCheckBox;
    ToolButton4: TToolButton;
    btnConfig: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure ZGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure YGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure MatrixGridEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure XGridEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure YGridEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure ZGridEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure XGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DataEditCBChange(Sender: TObject);
    procedure MatrixGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure iSwitchLed1Change(Sender: TObject);
    procedure iSwitchLed2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOpenClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ToolButton8Click(Sender: TObject);
    procedure WriteConfirmCBChange(Sender: TObject);
    procedure MatrixGridGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    FFromColor, FToColor: TColor;
    FResolution: integer;

    procedure UpdateTrace_Matrix(var Msg: TEventData_HIC); message WM_EVENT_MATRIX_COMM;
    procedure Matrix_OnSignal(Data: TEventData_HIC); virtual;

    procedure MoveArray2Matrix1(AData: TEventData_HIC; AEngineParameter: TEngineParameter);
    procedure MoveArray2Matrix2(AData: TEventData_HIC; AEngineParameter: TEngineParameter);
    procedure MoveArray2Matrix3(AData: TEventData_HIC; AEngineParameter: TEngineParameter);
    procedure MoveArray2Matrix1f(AData: TEventData_HIC; AEngineParameter: TEngineParameter);
    procedure MoveArray2Matrix2f(AData: TEventData_HIC; AEngineParameter: TEngineParameter);
    procedure MoveArray2Matrix3f(AData: TEventData_HIC; AEngineParameter: TEngineParameter);

    procedure MoveMatrixValue2Array1(var AData: TConfigData_ModbusComm);
    procedure MoveMatrixValue2Array2(var AData: TConfigData_ModbusComm);
    procedure MoveMatrixValue2Array3(var AData: TConfigData_ModbusComm);
    procedure MoveMatrixValue2Array1f(var AData: TConfigData_ModbusComm);
    procedure MoveMatrixValue2Array2f(var AData: TConfigData_ModbusComm);
    procedure MoveMatrixValue2Array3f(var AData: TConfigData_ModbusComm);

    procedure Matrix1ToGrid(AEngineParameter: TEngineParameter);
    procedure Matrix2ToGrid(AEngineParameter: TEngineParameter);
    procedure Matrix3ToGrid(AEngineParameter: TEngineParameter; ZIndex: integer = 0);
    procedure Matrix1fToGrid(AEngineParameter: TEngineParameter);
    procedure Matrix2fToGrid(AEngineParameter: TEngineParameter);
    procedure Matrix3fToGrid(AEngineParameter: TEngineParameter; ZIndex: integer = 0);
    procedure SeqNoToFixedGrid;
    function GetNumOfDataNSetAxisDesc: integer;

    procedure MatrixGridToMatrixx(ACol,ARow: integer);
    procedure MatrixGridToMatrixxf(ACol,ARow: integer);
    procedure MatrixGridToMatrix3(ACol,ARow: integer; ZIndex: integer = 0);
    procedure MatrixGridToMatrix3f(ACol,ARow: integer; ZIndex: integer = 0);
    procedure XGridToMatrixx(ACol,ARow: integer);
    procedure XGridToMatrixxf(ACol,ARow: integer);
    procedure XGridToMatrix3(ACol,ARow: integer; ZIndex: integer = 0);
    procedure XGridToMatrix3f(ACol,ARow: integer; ZIndex: integer = 0);
    procedure YGridToMatrixx(ACol,ARow: integer);
    procedure YGridToMatrixxf(ACol,ARow: integer);
    procedure YGridToMatrix3(ACol,ARow: integer; ZIndex: integer = 0);
    procedure YGridToMatrix3f(ACol,ARow: integer; ZIndex: integer = 0);
    procedure ZGridToMatrixx(ACol,ARow: integer);
    procedure ZGridToMatrixxf(ACol,ARow: integer);
    procedure ZGridToMatrix3(ACol,ARow: integer; ZIndex: integer = 0);
    procedure ZGridToMatrix3f(ACol,ARow: integer; ZIndex: integer = 0);

    procedure MatrixGridToMatrix(ACol,ARow: integer);
    procedure XGridToMatrix(ACol,ARow: integer);
    procedure YGridToMatrix(ACol,ARow: integer);
    procedure ZGridToMatrix(ACol,ARow: integer);

    function GetMatrixItem(AEngineParameter: TEngineParameter): TMatrixItem;
  public
    FIPCClient_HIC: TIPCClient<TConfigData_ModbusComm>;
    FIPCMonitor: TIPCMonitor<TEventData_HIC>;
    FEngineParameter,
    FOfflineEngineParameter: TEngineParameter;
    FMatrixCommData: TEventData_HIC;
    FParamItemIndex: integer;
    FZAxisSelIndex: integer; //ZAxis 선택된 Row Index(세로방향)
    FMatrixModified: Boolean;//Matrix Data 변경 되었으면 True
    FUseOnlineData: Boolean;//True=제어기로부터 데이터를 수신하여 FEngineParameter 갱신함
                            //False=파일에서 읽은 데이터를 그대로 유지함
    FDataEditable: Boolean; //True = Data 편집 가능
    FMainFormHandle: integer;

    //Undo Redo시에 복수개의 grid의 순서를 저장함(undo_redo가 grid별로 별도로 존재하기 때문임)
    FGridEditSeqUnDoList: TStringList;
    FGridEditSeqReDoList: TStringList;
    FUndoIndex: integer; //Undo는 실행 후 인덱스 - 1, Redo는 인덱스 + 1 후 실행
    FUseConfirmWrite: Boolean;//True = Write Confirm send 함.

    procedure InitVar;
    procedure DestroyVar;

    procedure CreateIPCMonitor(ASharedName: string);
    procedure Assign2EngineParameter(APM: TEngineParameter);
    procedure ReqReadConfigData;
    procedure SetDisplay;
    procedure AnalogValue2Screen;
    procedure WriteMatrix;
    procedure ConfirmWrite;
    procedure MoveArray2Matrix;
    procedure MoveParameter2Grid;
    procedure SetDataEditable(AEditable: boolean);
    procedure GridUndo;
    procedure GridRedo;
  end;

var
  SetMatrixForm: TSetMatrixForm;

implementation

{$R *.dfm}

uses CommonUtil, MatrixParameterConst;

{ TSetMatrixForm }

procedure TSetMatrixForm.AnalogValue2Screen;
begin
  ValuePanel.Caption := IntToStr(FMatrixCommData.InpDataBuf[0]);
end;

procedure TSetMatrixForm.Assign2EngineParameter(APM: TEngineParameter);
begin
  FEngineParameter.Assign(APM);
  FOfflineEngineParameter.Assign(FEngineParameter);
end;

procedure TSetMatrixForm.BitBtn1Click(Sender: TObject);
begin
  WriteMatrix;
end;

procedure TSetMatrixForm.btnOpenClick(Sender: TObject);
var
  i: integer;
  LEP: TEngineParameter;
begin
  if OpenDialog1.Execute then
  begin
    try
      LEP := TEngineParameter.Create(nil);
      LEP.LoadFromJSONFile(OpenDialog1.FileName);

      i := LEP.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

      if i = -1 then
        exit;

      case LEP.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
        ptMatrix1: Matrix1ToGrid(LEP);
        ptMatrix2: Matrix2ToGrid(LEP);
        ptMatrix3: Matrix3ToGrid(LEP);
        ptMatrix1f: Matrix1fToGrid(LEP);
        ptMatrix2f: Matrix2fToGrid(LEP);
        ptMatrix3f: Matrix3fToGrid(LEP);
      end;

    finally
      LEP.Free;
    end;
  end;
end;

procedure TSetMatrixForm.btnRedoClick(Sender: TObject);
begin
  GridRedo;
end;

procedure TSetMatrixForm.btnUndoClick(Sender: TObject);
begin
  GridUndo;
end;

procedure TSetMatrixForm.ConfirmWrite;
var
  AData: TConfigData_ModbusComm;
  LStr: string;
begin
  if FMatrixCommData.ErrorCode <> 9999 then
  begin
    StatusBar1.SimplePanel := True;
    LStr := '********'''+ FMatrixCommData.ModBusAddress + ''', Write Error!' + #13#10;
    LStr := LStr + 'Error Code = (' + IntToStr(FMatrixCommData.ErrorCode) + ')';
    StatusBar1.SimpleText := LStr;
    exit;
  end;

  if FMatrixCommData.DataMode = 4 then
  begin
    StatusBar1.SimplePanel := True;
    LStr := '********'''+ FMatrixCommData.ModBusAddress + ''', Confirm Write OK!' + #13#10;
    StatusBar1.SimpleText := LStr;
    exit;
  end;


  case FMatrixCommData.ModBusFunctionCode of
    16: begin
      FillChar(AData, SizeOf(AData), #0);

      with AData do
      begin
        NumOfData := 1;
        ModBusFunctionCode := 16; //mbfWriteRegs in ModbusConsts
        ModBusAddress := '0001';
        ParameterType := 2;//ptAnalog
        ModbusMode := 1;//RTU Mode
        CommMode := 3;// Only One Write for Confirm

        DataBuf[0] := 1234;
      end;

      AData.Termination := False;
      FIPCClient_HIC.PulseMonitor(AData);
      StatusBar1.SimplePanel := True;
      StatusBar1.SimpleText := '********'''+ AData.ModBusAddress + ''', Write Confirm OK!';
    end;//16
  end;//case
end;

procedure TSetMatrixForm.CreateIPCMonitor(ASharedName: string);
begin
  if ASharedName = '' then
    ASharedName := ParameterSource2SharedMN(psHIC);

  FIPCMonitor := TIPCMonitor<TEventData_HIC>.Create(ASharedName, HIC_EVENT_NAME, True);
  FIPCMonitor.FIPCObject.OnSignal := Matrix_OnSignal;
  FIPCMonitor.FreeOnTerminate := True;
  FIPCMonitor.Resume;
end;

procedure TSetMatrixForm.DataEditCBChange(Sender: TObject);
begin
  FDataEditable := DataEditCB.Checked;

  SetDataEditable(FDataEditable);
end;

procedure TSetMatrixForm.DestroyVar;
var
  LData: TConfigData_ModbusComm;
begin
  if Assigned(FIPCMonitor) then
  begin
    FIPCMonitor.FTermination := True;
    FIPCMonitor.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor.Terminate;
    //FIPCMonitor.Free;
  end;

  if Assigned(FIPCClient_HIC) then
  begin
    LData.Termination := True;
    FIPCClient_HIC.PulseMonitor(LData);
    FreeAndNil(FIPCClient_HIC);
  end;

  FEngineParameter.EngineParameterCollect.Clear;
  FEngineParameter.MatrixCollect.Clear;
  FEngineParameter.Free;

  FOfflineEngineParameter.EngineParameterCollect.Clear;
  FOfflineEngineParameter.MatrixCollect.Clear;
  FOfflineEngineParameter.Free;

  FGridEditSeqUnDoList.Free;
  FGridEditSeqReDoList.Free;
end;

procedure TSetMatrixForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SendMessage(FMainFormHandle, WM_MATRIXFORMCLOSE, Handle, 0);
end;

procedure TSetMatrixForm.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TSetMatrixForm.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

procedure TSetMatrixForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Ctrl + z
  if (Shift = [ssCtrl]) and (Key = $5A) then
    GridUndo
  else
  if (Shift = [ssShift,ssCtrl]) and (Key = $5A) then
    GridRedo;
end;

function TSetMatrixForm.GetMatrixItem(AEngineParameter: TEngineParameter): TMatrixItem;
var
  LIdx: integer;
  LLength: integer;
begin
  LIdx := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

  if LIdx = -1 then
  begin
    Result := AEngineParameter.MatrixCollect.Add;
    LIdx := AEngineParameter.MatrixCollect.Count - 1;
    FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex := LIdx;
  end
  else
    Result := AEngineParameter.MatrixCollect.Items[LIdx];

  case FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
    ptMatrix1: begin
      Result.XAxisILength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;
      Result.ValueILength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;
    end;
    ptMatrix2: begin
      Result.XAxisILength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;
      Result.YAxisILength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize;
      Result.ValueILength := Result.XAxisILength * Result.YAxisILength;
    end;
    ptMatrix3: begin
      LLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize *
        AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;
      Result.XAxisILength := LLength;

      LLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize *
        AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;
      Result.YAxisILength := LLength;

      Result.ZAxisILength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;

      LLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize *
        AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize *
        AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;
      Result.ValueILength := LLength;
    end;
    ptMatrix1f: begin
      Result.XAxisFLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;
      Result.ValueFLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;
    end;
    ptMatrix2f: begin
      Result.XAxisFLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;
      Result.YAxisFLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize;
      Result.ValueFLength := Result.XAxisFLength * Result.YAxisFLength;
    end;
    ptMatrix3f: begin
      LLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize *
        AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;
      Result.XAxisFLength := LLength;

      LLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize *
        AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;
      Result.YAxisFLength := LLength;

      Result.ZAxisFLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;

      LLength := AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize *
        AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize *
        AEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;
      Result.ValueILength := LLength;
    end;
  else
    ;
  end;

end;

procedure TSetMatrixForm.MatrixGridEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
begin
  MatrixGridToMatrix(ACol, ARow);
  FGridEditSeqUnDoList.Add('MatrixGrid');
  FUndoIndex := FGridEditSeqUnDoList.Count - 1;
end;

procedure TSetMatrixForm.MatrixGridGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  LValue: integer;
  LColor: TColor;
begin
  LValue := StrToIntDef(MatrixGrid.Cells[ACol, ARow],0);
  //LColor := ScalarValueToColor(FFromColor, FToColor, 0, 100, 100, LValue);
  LColor := ScalarValueToColor2(FFromColor, FToColor, FResolution, LValue);
  ABrush.Color := LColor;
end;

procedure TSetMatrixForm.MatrixGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if YGrid.Row <> ARow then
    YGrid.Row := ARow;

  //if (ZGrid.RowCount > ARow) and (ZGrid.Row <> ARow) then
    //ZGrid.Row := ARow;
end;

procedure TSetMatrixForm.MatrixGridToMatrix(ACol, ARow: integer);
begin
  case FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
    ptMatrix1, ptMatrix2: MatrixGridToMatrixx(ACol, ARow);
    ptMatrix3: MatrixGridToMatrix3(ACol, ARow, FZAxisSelIndex);
    ptMatrix1f, ptMatrix2f: MatrixGridToMatrixxf(ACol, ARow);
    ptMatrix3f: MatrixGridToMatrix3f(ACol, ARow, FZAxisSelIndex);
  else
    ;
  end;
  FMatrixModified := True;
end;

procedure TSetMatrixForm.MatrixGridToMatrix3(ACol, ARow: integer; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  LMInteger: TMatrixInteger;
  z: integer;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  z := ACol+(XGrid.ColCount*ARow)+(XGrid.ColCount*YGrid.RowCount*ZIndex);
  LMInteger.Value := StrToIntDef(MatrixGrid.Cells[ACol, ARow],0);
  LM1.ValueIArray[z] := LMInteger;
end;

procedure TSetMatrixForm.MatrixGridToMatrix3f(ACol, ARow: integer; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  LMFloat: TMatrixFloat;
  z: integer;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  z := ACol+(XGrid.ColCount*ARow)+(XGrid.ColCount*YGrid.RowCount*ZIndex);
  LMFloat.Value := StrToFloatDef(MatrixGrid.Cells[ACol, ARow],0);
  LM1.ValueFArray[z] := LMFloat;
end;

procedure TSetMatrixForm.MatrixGridToMatrixx(ACol, ARow: integer);
var
  LM1: TMatrixItem;
  LMInteger: TMatrixInteger;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  LMInteger.Value := StrToIntDef(MatrixGrid.Cells[ACol, ARow],0);
  LM1.ValueIArray[ACol+(XGrid.ColCount*ARow)] := LMInteger;
  //LM1.DynArraySaveToMatrix1Value;
end;

procedure TSetMatrixForm.MatrixGridToMatrixxf(ACol, ARow: integer);
var
  LM1: TMatrixItem;
  LMFloat: TMatrixFloat;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  LMFloat.Value := StrToFloatDef(MatrixGrid.Cells[ACol, ARow],0);
  LM1.ValueFArray[ACol+(XGrid.ColCount*ARow)] := LMFloat;
end;

procedure TSetMatrixForm.InitVar;
var
  LSM: string;
begin
  FEngineParameter := TEngineParameter.Create(Self);
  FOfflineEngineParameter := TEngineParameter.Create(Self);
  LSM := ParameterSource2SharedMN(psHIC) + 'Matrix';
  FIPCClient_HIC := TIPCClient<TConfigData_ModbusComm>.Create(LSM, MODBUSCOMM_EVENT_NAME, True);
  FParamItemIndex := -1;
  FZAxisSelIndex := 0;
  FMatrixModified := False;

  FGridEditSeqUnDoList := TStringList.Create;
  FGridEditSeqReDoList := TStringList.Create;
  FUndoIndex := -1; //Undo는 실행 후 인덱스 - 1, Redo는 인덱스 + 1 후 실행
  FUseConfirmWrite := True;
  FFromColor := clWhite;
  FToColor := clYellow;
  FResolution := 100;
end;

procedure TSetMatrixForm.iSwitchLed1Change(Sender: TObject);
begin
  //iSwitchLed2.Active := not iSwitchLed1.Active;

  FUseOnlineData := iSwitchLed1.Active;

  if FUseOnlineData then
  begin
    iSwitchLed2.Active := False;
    ReqReadConfigData;
  end;
end;

procedure TSetMatrixForm.iSwitchLed2Change(Sender: TObject);
begin
  //iSwitchLed1.Active := not iSwitchLed2.Active;

  if iSwitchLed2.Active then
  begin
    iSwitchLed1.Active := False;
    FEngineParameter.Assign(FOfflineEngineParameter);
    MoveParameter2Grid;
  end;
end;

procedure TSetMatrixForm.Matrix1fToGrid(AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  i: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);

  XGrid.ColCount := LM1.XAxisFLength;
  MatrixGrid.ColCount := LM1.ValueFLength;
  MatrixGrid.RowCount := 1;

  SeqNoToFixedGrid;

  for i := 0 to XGrid.ColCount - 1 do
  begin
    XGrid.Cells[i,0] := FloatToStr(LM1.XAxisFArray[i].Value);
    MatrixGrid.Cells[i,0] := FloatToStr(LM1.ValueFArray[i].Value);
  end;//for
end;

procedure TSetMatrixForm.Matrix1ToGrid(AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  i: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);
  XGrid.ColCount := LM1.XAxisILength;
  MatrixGrid.ColCount := LM1.ValueILength;
  MatrixGrid.RowCount := 1;

  SeqNoToFixedGrid;

  for i := 0 to LM1.XAxisILength - 1 do
  begin
    XGrid.Cells[i,0] := IntToStr(LM1.XAxisIArray[i].Value);
    MatrixGrid.Cells[i,0] := IntToStr(LM1.ValueIArray[i].Value);
  end;//for
end;

procedure TSetMatrixForm.Matrix2fToGrid(AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  i,j: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);
  XGrid.ColCount := LM1.XAxisFLength;
  YGrid.RowCount := LM1.YAxisFLength;
  MatrixGrid.ColCount := LM1.XAxisFLength;
  MatrixGrid.RowCount := LM1.YAxisFLength;

  SeqNoToFixedGrid;

  for j := 0 to LM1.YAxisFLength - 1 do
  begin
    YGrid.Cells[YGrid.FixedCols,j] := FloatToStr(LM1.YAxisFArray[j].Value);

    for i := 0 to LM1.XAxisFLength - 1 do
    begin
      if j = 0 then
        XGrid.Cells[i,0] := FloatToStr(LM1.XAxisFArray[i].Value);

      MatrixGrid.Cells[i,j] := FloatToStr(LM1.ValueFArray[i+(LM1.XAxisILength*j)].Value);
    end;
  end;//for
end;

procedure TSetMatrixForm.Matrix2ToGrid(AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  i,j: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);
  XGrid.ColCount := LM1.XAxisILength;
  YGrid.RowCount := LM1.YAxisILength;
  MatrixGrid.ColCount := LM1.XAxisILength;
  MatrixGrid.RowCount := LM1.YAxisILength;

  SeqNoToFixedGrid;

  for j := 0 to LM1.YAxisILength - 1 do
  begin
    YGrid.Cells[YGrid.FixedCols,j] := IntToStr(LM1.YAxisIArray[j].Value);

    for i := 0 to LM1.XAxisILength - 1 do
    begin
      if j = 0 then
        XGrid.Cells[i,0] := IntToStr(LM1.XAxisIArray[i].Value);

      MatrixGrid.Cells[i,j] := IntToStr(LM1.ValueIArray[i+(LM1.XAxisILength*j)].Value);
    end;
  end;//for
end;

procedure TSetMatrixForm.Matrix3fToGrid(AEngineParameter: TEngineParameter; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  i,j,k,n,z: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);

  if LM1.ZAxisFLength = 0 then
  begin
    ShowMessage('ZAxisFLength is 0!');
    exit;
  end;

  XGrid.ColCount := LM1.XAxisFLength div LM1.ZAxisFLength;
  YGrid.RowCount := LM1.YAxisFLength div LM1.ZAxisFLength;
  ZGrid.RowCount := LM1.ZAxisFLength;
  MatrixGrid.ColCount := XGrid.ColCount;
  MatrixGrid.RowCount := YGrid.RowCount;

  SeqNoToFixedGrid;

  for n := 0 to LM1.ZAxisFLength - 1 do
  begin  
    ZGrid.Cells[0, n] := FloatToStr(LM1.ZAxisFArray[n].Value);
  end;

  for j := 0 to YGrid.RowCount - 1 do
  begin
    z := j + (YGrid.RowCount * ZIndex);
    YGrid.Cells[YGrid.FixedCols,j] := FloatToStr(LM1.YAxisFArray[z].Value);

    for i := 0 to XGrid.ColCount - 1 do
    begin
      if j = 0 then
      begin
        z := i + (XGrid.ColCount * ZIndex);
        XGrid.Cells[i,0] := FloatToStr(LM1.XAxisFArray[z].Value);
      end;

      k := i+(XGrid.ColCount*j)+(XGrid.ColCount*YGrid.RowCount*ZIndex);
      MatrixGrid.Cells[i,j] := FloatToStr(LM1.ValueFArray[k].Value);
    end;
  end;//for
end;

//ZIndex: ZAxis Index 에 따라 MatrixGrid 값이 달라짐
procedure TSetMatrixForm.Matrix3ToGrid(AEngineParameter: TEngineParameter; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  i,j,k,n,z: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);

  if LM1.ZAxisILength = 0 then
  begin
    ShowMessage('ZAxisILength is 0!');
    exit;
  end;

  XGrid.ColCount := LM1.XAxisILength div LM1.ZAxisILength;
  YGrid.RowCount := LM1.YAxisILength div LM1.ZAxisILength;
  ZGrid.RowCount := LM1.ZAxisILength;
  MatrixGrid.ColCount := XGrid.ColCount;
  MatrixGrid.RowCount := YGrid.RowCount;

  SeqNoToFixedGrid;

  for n := 0 to LM1.ZAxisILength - 1 do
  begin  
    ZGrid.Cells[0, n] := IntToStr(LM1.ZAxisIArray[n].Value);
  end;//for n

  for j := 0 to YGrid.RowCount - 1 do
  begin
    z := j + (YGrid.RowCount * ZIndex);
    YGrid.Cells[YGrid.FixedCols,j] := IntToStr(LM1.YAxisIArray[z].Value);

    for i := 0 to XGrid.ColCount - 1 do
    begin
      if j = 0 then
      begin
        z := i + (XGrid.ColCount * ZIndex);
        XGrid.Cells[i,0] := IntToStr(LM1.XAxisIArray[z].Value);
      end;

      k := i+(XGrid.ColCount*j)+(XGrid.ColCount*YGrid.RowCount*ZIndex);
      MatrixGrid.Cells[i,j] := IntToStr(LM1.ValueIArray[k].Value);
    end;//for i
  end;//for j
end;

procedure TSetMatrixForm.Matrix_OnSignal(Data: TEventData_HIC);
begin
  if Data.DataMode = 0 then//CM_DATA_READ
    exit
  else
  if Data.DataMode = 1 then//CM_CONFIG_READ
  begin
    if not FUseOnlineData then
      exit;
  end
  else //CM_DATA_WRITE, CM_CONFIG_WRITE, CM_CONFIG_WRITE_CONFIRM
  begin

  end;

  System.Move(Data, FMatrixCommData, Sizeof(Data));
  SendMessage(Handle, WM_EVENT_MATRIX_COMM, 0,0);
end;

procedure TSetMatrixForm.MoveArray2Matrix;
var
  i: integer;
begin
  //TMatrix Item Index를 가져옴
  //i := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

  case FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
    ptMatrix1: MoveArray2Matrix1(FMatrixCommData,FEngineParameter);
    ptMatrix2: MoveArray2Matrix2(FMatrixCommData,FEngineParameter);
    ptMatrix3: MoveArray2Matrix3(FMatrixCommData,FEngineParameter);
    ptMatrix1f: MoveArray2Matrix1f(FMatrixCommData,FEngineParameter);
    ptMatrix2f: MoveArray2Matrix2f(FMatrixCommData,FEngineParameter);
    ptMatrix3f: MoveArray2Matrix3f(FMatrixCommData,FEngineParameter);
  else
    ;
  end;

  //기존 Matrix Data가 없을 경우
  if i = -1 then
  begin
    with FEngineParameter.EngineParameterCollect.Items[FParamItemIndex] do
    begin
      //TMatrixItem Index
      MatrixItemIndex := FEngineParameter.MatrixCollect.Count - 1;
    end;//with
  end;
end;

procedure TSetMatrixForm.MoveArray2Matrix1(AData: TEventData_HIC;
  AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  LXAxis: TMatrixInteger;
  LValue: TMatrixInteger;
  i: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);

  for i := 0 to LM1.XAxisILength - 1 do
  begin
    LXAxis.Value := AData.InpDataBuf[i]; //실린더 번호
    LValue.Value := AData.InpDataBuf[i+LM1.XAxisILength];//Start Crank Angle or Duration
    LM1.XAxisIArray[i] := LXAxis;
    LM1.ValueIArray[i] := LValue;
  end;//for

  LM1.DynArraySaveToMatrix1Value;
  Matrix1ToGrid(AEngineParameter);
end;

procedure TSetMatrixForm.MoveArray2Matrix1f(AData: TEventData_HIC;
  AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  LXAxis: TMatrixFloat;
  LValue: TMatrixFloat;
  i: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);

  for i := 0 to LM1.XAxisFLength - 1 do
  begin
    LXAxis.Value := AData.InpDataBuf[i]; //실린더 번호
    LValue.Value := AData.InpDataBuf_f[i+LM1.XAxisFLength];//Start Crank Angle or Duration
    LM1.XAxisFArray[i] := LXAxis;
    LM1.ValueFArray[i] := LValue;
  end;//for

  LM1.DynArraySaveToMatrix1fValue;
  Matrix1fToGrid(AEngineParameter);
end;

procedure TSetMatrixForm.MoveArray2Matrix2(AData: TEventData_HIC;
  AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  LXAxis: TMatrixInteger;
  LValue: TMatrixInteger;
  LYAxis: TMatrixInteger;
  i,j,k: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);

  j := 0;

  for i := 0 to LM1.XAxisILength - 1 do
  begin
    LXAxis.Value := AData.InpDataBuf[j];
    LM1.XAxisIArray[i] := LXAxis;
    inc(j);
  end;

  for i := 0 to LM1.YAxisILength - 1 do
  begin
    LYAxis.Value := AData.InpDataBuf[j];
    LM1.YAxisIArray[i] := LYAxis;
    inc(j);
  end;

  k := LM1.XAxisILength * LM1.YAxisILength;

  for i := 0 to k - 1 do
  begin
    LValue.Value := AData.InpDataBuf[j];
    LM1.ValueIArray[i] := LValue;
    inc(j);
  end;//for

  LM1.DynArraySaveToMatrix2Value;
  Matrix2ToGrid(AEngineParameter);
end;

procedure TSetMatrixForm.MoveArray2Matrix2f(AData: TEventData_HIC;
  AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  LXAxis: TMatrixFloat;
  LValue: TMatrixFloat;
  LYAxis: TMatrixFloat;
  i,j,k: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);

  j := 0;

  for i := 0 to LM1.XAxisFLength - 1 do
  begin
    LXAxis.Value := AData.InpDataBuf_f[j];
    LM1.XAxisFArray[i] := LXAxis;
    inc(j);
  end;

  for i := 0 to LM1.YAxisFLength - 1 do
  begin
    LYAxis.Value := AData.InpDataBuf_f[j];
    LM1.YAxisFArray[i] := LYAxis;
    inc(j);
  end;

  k := LM1.XAxisFLength * LM1.YAxisFLength;

  for i := 0 to k - 1 do
  begin
    LValue.Value := AData.InpDataBuf_f[j];
    LM1.ValueFArray[i] := LValue;
    inc(j);
  end;//for

  LM1.DynArraySaveToMatrix2fValue;
  Matrix2fToGrid(AEngineParameter);
end;

procedure TSetMatrixForm.MoveArray2Matrix3(AData: TEventData_HIC;
  AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  LXAxis: TMatrixInteger;
  LValue: TMatrixInteger;
  LYAxis: TMatrixInteger;
  LZAxis: TMatrixInteger;
  i,j,k: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);

  j := 0;

  for i := 0 to LM1.XAxisILength - 1 do
  begin
    LXAxis.Value := AData.InpDataBuf[j];
    LM1.XAxisIArray[i] := LXAxis;
    inc(j);
  end;

  for i := 0 to LM1.YAxisILength - 1 do
  begin
    LYAxis.Value := AData.InpDataBuf[j];
    LM1.YAxisIArray[i] := LYAxis;
    inc(j);
  end;

  for i := 0 to LM1.ZAxisILength - 1 do
  begin
    LZAxis.Value := AData.InpDataBuf[j];
    LM1.ZAxisIArray[i] := LZAxis;
    inc(j);
  end;

  for i := 0 to LM1.ZAxisILength - 1 do
  begin
    LZAxis.Value := AData.InpDataBuf[j];
    LM1.ZAxisIArray[i] := LZAxis;
    inc(j);
  end;

  k := LM1.XAxisILength * LM1.YAxisILength * LM1.ZAxisILength;

  for i := 0 to k - 1 do
  begin
    LValue.Value := AData.InpDataBuf[j];
    LM1.ValueIArray[i] := LValue;
    inc(j);
  end;//for

  LM1.DynArraySaveToMatrix3Value;
  Matrix3ToGrid(AEngineParameter);
end;

procedure TSetMatrixForm.MoveArray2Matrix3f(AData: TEventData_HIC;
  AEngineParameter: TEngineParameter);
var
  LM1: TMatrixItem;
  LXAxis: TMatrixFloat;
  LValue: TMatrixFloat;
  LYAxis: TMatrixFloat;
  LZAxis: TMatrixFloat;
  i,j,k: integer;
begin
  LM1 := GetMatrixItem(AEngineParameter);

  j := 0;

  for i := 0 to LM1.XAxisFLength - 1 do
  begin
    LXAxis.Value := AData.InpDataBuf_f[j];
    LM1.XAxisFArray[i] := LXAxis;
    inc(j);
  end;

  for i := 0 to LM1.YAxisFLength - 1 do
  begin
    LYAxis.Value := AData.InpDataBuf_f[j];
    LM1.YAxisFArray[i] := LYAxis;
    inc(j);
  end;

  for i := 0 to LM1.ZAxisFLength - 1 do
  begin
    LZAxis.Value := AData.InpDataBuf_f[j];
    LM1.ZAxisFArray[i] := LZAxis;
    inc(j);
  end;

  for i := 0 to LM1.ZAxisFLength - 1 do
  begin
    LZAxis.Value := AData.InpDataBuf_f[j];
    LM1.ZAxisFArray[i] := LZAxis;
    inc(j);
  end;

  k := LM1.XAxisFLength * LM1.YAxisFLength * LM1.ZAxisFLength;

  for i := 0 to k - 1 do
  begin
    LValue.Value := AData.InpDataBuf_f[j];
    LM1.ValueFArray[i] := LValue;
    inc(j);
  end;//for

  LM1.DynArraySaveToMatrix3fValue;
  Matrix3fToGrid(AEngineParameter,FZAxisSelIndex);
end;

procedure TSetMatrixForm.MoveMatrixValue2Array1(var AData: TConfigData_ModbusComm);
var
  i,j: integer;
begin
  with AData do
  begin
    NumOfData_X := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;//XGrid.ColCount;
    NumOfData := NumOfData_X; //MatrixGrid.ColCount;
    ModBusFunctionCode := 16; //mbfWriteRegs in ModbusConsts
    ModBusAddress := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Address;
    ParameterType := 4;//ptMatrix1
    ModbusMode := 1;//RTU Mode
    CommMode := 2;// Only One Write

    j := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

    for i := 0 to NumOfData_X - 1 do
      XAxisData[i] := FEngineParameter.MatrixCollect.Items[j].XAxisIArray[i].Value;
      //XAxisData[i] := StrToIntDef(XGrid.Cells[i,0],0);

    for i := 0 to NumOfData - 1 do
      DataBuf[i] := FEngineParameter.MatrixCollect.Items[j].ValueIArray[i].Value;
      //DataBuf[i] := StrToIntDef(XGrid.Cells[i,0],0);
  end;
end;

procedure TSetMatrixForm.MoveMatrixValue2Array1f(var AData: TConfigData_ModbusComm);
var
  i,j: integer;
begin
  with AData do
  begin
    NumOfData_X := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;//XGrid.ColCount;
    NumOfData := NumOfData_X; //MatrixGrid.ColCount;
    ModBusFunctionCode := 16; //mbfWriteRegs in ModbusConsts
    ModBusAddress := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Address;
    ParameterType := 7;//ptMatrix1f
    ModbusMode := 1;//RTU Mode
    CommMode := 2;// Only One Write

    j := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

    for i := 0 to NumOfData_X - 1 do
      XAxisData_f[i] := FEngineParameter.MatrixCollect.Items[j].XAxisFArray[i].Value;
      //XAxisData[i] := StrToIntDef(XGrid.Cells[i,0],0);

    for i := 0 to NumOfData - 1 do
      DataBuf_f[i] := FEngineParameter.MatrixCollect.Items[j].ValueFArray[i].Value;
      //DataBuf_f[i] := StrToFloatDef(XGrid.Cells[i,0],0.0);
  end;
end;

procedure TSetMatrixForm.MoveMatrixValue2Array2(var AData: TConfigData_ModbusComm);
var
  i,j: integer;
begin
  with AData do
  begin
    NumOfData_X := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;//XGrid.ColCount;
    NumOfData_Y := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize;//YGrid.RowCount;
    NumOfData := NumOfData_X * NumOfData_Y;//MatrixGrid.ColCount * MatrixGrid.RowCount;
    ModBusFunctionCode := 16; //mbfWriteRegs in ModbusConsts
    ModBusAddress := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Address;
    ParameterType := 5;//ptMatrix2
    ModbusMode := 1;//RTU Mode
    CommMode := 2;// Only One Write

    j := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

    for i := 0 to NumOfData_X - 1 do
      XAxisData[i] := FEngineParameter.MatrixCollect.Items[j].XAxisIArray[i].Value;
      //XAxisData[i] := StrToIntDef(XGrid.Cells[i,0],0);

    for i := 0 to NumOfData_Y - 1 do
      YAxisData[i] := FEngineParameter.MatrixCollect.Items[j].YAxisIArray[i].Value;
      //YAxisData[i] := StrToIntDef(YGrid.Cells[1,i],0);

    for i := 0 to NumOfData - 1 do
      DataBuf[i] := FEngineParameter.MatrixCollect.Items[j].ValueIArray[i].Value;
  end;
end;

procedure TSetMatrixForm.MoveMatrixValue2Array2f(var AData: TConfigData_ModbusComm);
var
  i,j: integer;
begin
  with AData do
  begin
    NumOfData_X := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;//XGrid.ColCount;
    NumOfData_Y := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize;//YGrid.RowCount;
    NumOfData := NumOfData_X * NumOfData_Y;//MatrixGrid.ColCount * MatrixGrid.RowCount;
    ModBusFunctionCode := 16; //mbfWriteRegs in ModbusConsts
    ModBusAddress := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Address;
    ParameterType := 8;//ptMatrix2f
    ModbusMode := 1;//RTU Mode
    CommMode := 2;// Only One Write

    j := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

    for i := 0 to NumOfData_X - 1 do
      XAxisData_f[i] := FEngineParameter.MatrixCollect.Items[j].XAxisFArray[i].Value;
      //XAxisData[i] := StrToIntDef(XGrid.Cells[i,0],0);

    for i := 0 to NumOfData_Y - 1 do
      YAxisData_f[i] := FEngineParameter.MatrixCollect.Items[j].YAxisFArray[i].Value;
      //YAxisData[i] := StrToIntDef(YGrid.Cells[1,i],0);

    for i := 0 to NumOfData - 1 do
      DataBuf_f[i] := FEngineParameter.MatrixCollect.Items[j].ValueFArray[i].Value;
  end;
end;

procedure TSetMatrixForm.MoveMatrixValue2Array3(var AData: TConfigData_ModbusComm);
var
  i,j: integer;
begin
  with AData do
  begin
    NumOfData_X := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;//XGrid.ColCount;
    NumOfData_Y := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize;//YGrid.RowCount;
    NumOfData_Z := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;
    NumOfData := NumOfData_X * NumOfData_Y * NumOfData_Z;
    ModBusFunctionCode := 16; //mbfWriteRegs in ModbusConsts
    ModBusAddress := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Address;
    ParameterType := 6;//ptMatrix3
    ModbusMode := 1;//RTU Mode
    CommMode := 2;// Only One Write

    if NumOfData > High(DataBuf) then
    begin
      ShowMessage('NumOfData = ' + IntToStr(NumOfData) + ' > High(DataBuf) = ' + IntToStr(High(DataBuf)));
      exit;
    end;

    j := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

    for i := 0 to NumOfData_X - 1 do
      XAxisData[i] := FEngineParameter.MatrixCollect.Items[j].XAxisIArray[i].Value;
      //XAxisData[i] := StrToIntDef(XGrid.Cells[i,0],0);

    for i := 0 to NumOfData_Y - 1 do
      YAxisData[i] := FEngineParameter.MatrixCollect.Items[j].YAxisIArray[i].Value;
      //YAxisData[i] := StrToIntDef(YGrid.Cells[1,i],0);

    for i := 0 to NumOfData_Z - 1 do
      ZAxisData[i] := FEngineParameter.MatrixCollect.Items[j].ZAxisIArray[i].Value;
      //ZAxisData[i] := StrToIntDef(ZGrid.Cells[1,i],0);

    for i := 0 to NumOfData - 1 do
      DataBuf[i] := FEngineParameter.MatrixCollect.Items[j].ValueIArray[i].Value;
  end;
end;

procedure TSetMatrixForm.MoveMatrixValue2Array3f(var AData: TConfigData_ModbusComm);
var
  i,j: integer;
begin
  with AData do
  begin
    NumOfData_X := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize;//XGrid.ColCount;
    NumOfData_Y := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize;//YGrid.RowCount;
    NumOfData_Z := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;
    NumOfData := NumOfData_X * NumOfData_Y * NumOfData_Z;
    ModBusFunctionCode := 16; //mbfWriteRegs in ModbusConsts
    ModBusAddress := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Address;
    ParameterType := 6;//ptMatrix3
    ModbusMode := 1;//RTU Mode
    CommMode := 2;// Only One Write

    if NumOfData > High(DataBuf_f) then
    begin
      ShowMessage('NumOfData = ' + IntToStr(NumOfData) + ' > High(DataBuf_f) = ' + IntToStr(High(DataBuf_f)));
      exit;
    end;

    j := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

    for i := 0 to NumOfData_X - 1 do
      XAxisData_f[i] := FEngineParameter.MatrixCollect.Items[j].XAxisFArray[i].Value;
      //XAxisData[i] := StrToIntDef(XGrid.Cells[i,0],0);

    for i := 0 to NumOfData_Y - 1 do
      YAxisData_f[i] := FEngineParameter.MatrixCollect.Items[j].YAxisFArray[i].Value;
      //YAxisData[i] := StrToIntDef(YGrid.Cells[1,i],0);

    for i := 0 to NumOfData_Z - 1 do
      ZAxisData_f[i] := FEngineParameter.MatrixCollect.Items[j].ZAxisFArray[i].Value;
      //ZAxisData[i] := StrToIntDef(ZGrid.Cells[1,i],0);

    for i := 0 to NumOfData - 1 do
      DataBuf_f[i] := FEngineParameter.MatrixCollect.Items[j].ValueFArray[i].Value;
  end;
end;

procedure TSetMatrixForm.MoveParameter2Grid;
var
  i: integer;
begin

  //TMatrix Item Index를 가져옴
  i := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;

  case FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
    ptMatrix1: Matrix1ToGrid(FEngineParameter);
    ptMatrix2: Matrix2ToGrid(FEngineParameter);
    ptMatrix3: Matrix3ToGrid(FEngineParameter);
    ptMatrix1f: Matrix1fToGrid(FEngineParameter);
    ptMatrix2f: Matrix2fToGrid(FEngineParameter);
    ptMatrix3f: Matrix3fToGrid(FEngineParameter);
  else
    ;
  end;

  //기존 Matrix Data가 없을 경우
  if i = -1 then
    with FEngineParameter.EngineParameterCollect.Items[FParamItemIndex] do
    begin
      //TMatrixItem Index
      MatrixItemIndex := FEngineParameter.MatrixCollect.Count - 1;
    end;//with
end;

procedure TSetMatrixForm.WriteConfirmCBChange(Sender: TObject);
begin
  FUseConfirmWrite := WriteConfirmCB.Checked;
end;

procedure TSetMatrixForm.ReqReadConfigData;
var
  LConfigData: TConfigData_ModbusComm;
  LParameterType: TParameterType;
  LStr: string;
begin
  LConfigData.SlaveNo := 1;
  LConfigData.ModBusFunctionCode := StrToIntDef(FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].FCode,3);
  LConfigData.ModBusAddress := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Address;

  LConfigData.NumOfData := GetNumOfDataNSetAxisDesc;
  LConfigData.ParameterType := Ord(LParameterType);
  //0: Repeat Read, 1: Only One read, 2: Only One Write
  LConfigData.CommMode := 1;
  LConfigData.Termination := False;
  FIPCClient_HIC.PulseMonitor(LConfigData);
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := '********'''+ LConfigData.ModBusAddress + ''', Send OK!';
end;

procedure TSetMatrixForm.SeqNoToFixedGrid;
var
  i: integer;
begin
  for i := 0 to XGrid.ColCount - 1 do
    XGrid.Cells[i,1] := IntToStr(i+1);

  for i := 0 to YGrid.RowCount - 1 do
    YGrid.Cells[0,i] := IntToStr(i+1);

  for i := 0 to ZGrid.RowCount - 1 do
    ZGrid.Cells[1,i] := IntToStr(i+1);
end;
//Result: ValueDataLength
function TSetMatrixForm.GetNumOfDataNSetAxisDesc: integer;
var
  LParameterType: TParameterType;
  LStr: string;
begin
  LParameterType := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType;
  LStr := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].Description;

  case LParameterType of
    ptMatrix1,ptMatrix1f: begin
      Caption := GetTokenWithComma(LStr,';');
      XDescEdit.Text := GetTokenWithComma(LStr,';');
      Result := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize * 2;//XAxisLength(XAxis + Value)
    end;
    ptMatrix2,ptMatrix2f: begin
      Caption := GetTokenWithComma(LStr,';');
      XDescEdit.Text := GetTokenWithComma(LStr,';');
      YDescEdit.Text := GetTokenWithComma(LStr,';');
      Result := (FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize * //XAxisLength
        FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize) + //YAxisLength
        FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize +
        FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize; //(Value + XAxis + YAxis)
    end;
    ptMatrix3,ptMatrix3f: begin
      Caption := GetTokenWithComma(LStr,';');
      XDescEdit.Text := GetTokenWithComma(LStr,';');
      YDescEdit.Text := GetTokenWithComma(LStr,';');
      ZDescEdit.Text := GetTokenWithComma(LStr,';');
      Result := (FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize * //XAxisLength
        FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize * //YAxisLength;
        FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize) +//ZAxisLength
        FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].XAxisSize +
        FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].YAxisSize +
        FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ZAxisSize;//(Value + XAxis + YAxis + ZAxis)
    end;
  end;
end;

procedure TSetMatrixForm.GridRedo;
var
  Lidx: integer;
begin
  Lidx := FGridEditSeqReDoList.Count - 1;

  if Lidx = -1 then
    exit;

  if FGridEditSeqReDoList.Strings[Lidx] = 'MatrixGrid' then
  begin
    if MatrixGridUndoRedo.CanRedo then
    begin
      MatrixGridUndoRedo.Redo;
      FGridEditSeqReDoList.Delete(LIdx);
      Inc(FUndoIndex);
    end;
  end
  else
  if FGridEditSeqReDoList.Strings[Lidx] = 'XGrid' then
  begin
    if XGridUndoRedo.CanRedo then
    begin
      XGridUndoRedo.Redo;
      FGridEditSeqReDoList.Delete(LIdx);
      Inc(FUndoIndex);
    end;
  end
  else
  if FGridEditSeqReDoList.Strings[Lidx] = 'YGrid' then
  begin
    if YGridUndoRedo.CanRedo then
    begin
      YGridUndoRedo.Redo;
      FGridEditSeqReDoList.Delete(LIdx);
      Inc(FUndoIndex);
    end;
  end
  else
  if FGridEditSeqReDoList.Strings[Lidx] = 'ZGrid' then
  begin
    if ZGridUndoRedo.CanRedo then
    begin
      ZGridUndoRedo.Redo;
      FGridEditSeqReDoList.Delete(LIdx);
      Inc(FUndoIndex);
    end;
  end
end;

procedure TSetMatrixForm.GridUndo;
begin
  if FUndoIndex <> -1 then
  begin
    if FGridEditSeqUnDoList.Strings[FUndoIndex] = 'MatrixGrid' then
    begin
      if MatrixGridUndoRedo.CanUndo then
      begin
        MatrixGridUndoRedo.Undo;
        FGridEditSeqReDoList.Add('MatrixGrid');
        Dec(FUndoIndex);
      end;
    end
    else
    if FGridEditSeqUnDoList.Strings[FUndoIndex] = 'XGrid' then
    begin
      if XGridUndoRedo.CanUndo then
      begin
        XGridUndoRedo.Undo;
        FGridEditSeqReDoList.Add('XGrid');
        Dec(FUndoIndex);
      end;
    end
    else
    if FGridEditSeqUnDoList.Strings[FUndoIndex] = 'YGrid' then
    begin
      if YGridUndoRedo.CanUndo then
      begin
        YGridUndoRedo.Undo;
        FGridEditSeqReDoList.Add('YGrid');
        Dec(FUndoIndex);
      end;
    end
    else
    if FGridEditSeqUnDoList.Strings[FUndoIndex] = 'ZGrid' then
    begin
      if ZGridUndoRedo.CanUndo then
      begin
        ZGridUndoRedo.Undo;
        FGridEditSeqReDoList.Add('ZGrid');
        Dec(FUndoIndex);
      end;
    end
  end;
end;

procedure TSetMatrixForm.SetDataEditable(AEditable: boolean);
begin
  if AEditable then
  begin
    MatrixGrid.Options := MatrixGrid.Options + [goEditing];
    XGrid.Options := XGrid.Options + [goEditing];
    YGrid.Options := YGrid.Options + [goEditing];
    ZGrid.Options := ZGrid.Options + [goEditing];
  end
  else
  begin
    MatrixGrid.Options := MatrixGrid.Options - [goEditing];
    XGrid.Options := XGrid.Options - [goEditing];
    YGrid.Options := YGrid.Options - [goEditing];
    ZGrid.Options := ZGrid.Options - [goEditing];
  end;
end;

procedure TSetMatrixForm.SetDisplay;
begin
  GetNumOfDataNSetAxisDesc;

  case FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
    ptMatrix1,ptMatrix1f: begin
      YAxisPanel.Visible := False;
      ZAxisPanel.Visible := False;
      YLabel.Visible := False;
      YDescEdit.Visible := False;
      YCurValueEdit.Visible := False;
      ZLabel.Visible := False;
      ZDescEdit.Visible := False;
      ZCurValueEdit.Visible := False;
      MatrixInfoPanel.Height := XDescEdit.Top + XDescEdit.Height + 15;
      MatrixInfoPanel.ExpandedHeight := MatrixInfoPanel.Height;
      Height := Height - (MatrixGrid.Height - MatrixGrid.RowHeights[0])+15;
    end;
    ptMatrix2,ptMatrix2f: begin
      YAxisPanel.Visible := True;
      ZAxisPanel.Visible := False;
      ZLabel.Visible := False;
      ZDescEdit.Visible := False;
      ZCurValueEdit.Visible := False;
      MatrixInfoPanel.Height := XDescEdit.Top + XDescEdit.Height + YDescEdit.Height + 15;
      MatrixInfoPanel.ExpandedHeight := MatrixInfoPanel.Height;
    end;
    ptMatrix3,ptMatrix3f: begin
      YAxisPanel.Visible := True;
      ZAxisPanel.Visible := True;
      MatrixInfoPanel.Height := XDescEdit.Top + XDescEdit.Height + YDescEdit.Height + ZDescEdit.Height + 15;
      MatrixInfoPanel.ExpandedHeight := MatrixInfoPanel.Height;
    end
  else
    ;
  end;
end;

procedure TSetMatrixForm.ToolButton8Click(Sender: TObject);
begin
  WriteMatrix;
end;

procedure TSetMatrixForm.UpdateTrace_Matrix(var Msg: TEventData_HIC);
var
  i: integer;
begin
  //CM_DATA_READ, CM_CONFIG_READ, CM_DATA_WRITE, CM_CONFIG_WRITE, CM_CONFIG_WRITE_CONFIRM
  case TCommMode(FMatrixCommData.DataMode) of
    CM_DATA_READ: AnalogValue2Screen;
    CM_CONFIG_READ: MoveArray2Matrix;
    CM_DATA_WRITE,
    CM_CONFIG_WRITE,
    CM_CONFIG_WRITE_CONFIRM: if FUseConfirmWrite then ConfirmWrite;
  end;
end;

procedure TSetMatrixForm.WriteMatrix;
var
  LMatrixData: TConfigData_ModbusComm;
begin
  FillChar(LMatrixData, SizeOf(LMatrixData), #0);
  case FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
    ptMatrix1: MoveMatrixValue2Array1(LMatrixData);
    ptMatrix2: MoveMatrixValue2Array2(LMatrixData);
    ptMatrix3: MoveMatrixValue2Array3(LMatrixData);
    ptMatrix1f: MoveMatrixValue2Array1f(LMatrixData);
    ptMatrix2f: MoveMatrixValue2Array2f(LMatrixData);
    ptMatrix3f: MoveMatrixValue2Array3f(LMatrixData);
  else
    ;
  end;

  LMatrixData.Termination := False;
  FIPCClient_HIC.PulseMonitor(LMatrixData);
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := '********'''+ LMatrixData.ModBusAddress + ''', Write Request OK!';
end;

procedure TSetMatrixForm.XGridEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
begin
  XGridToMatrix(ACol,ARow);
  FGridEditSeqUnDoList.Add('XGrid');
  FUndoIndex := FGridEditSeqUnDoList.Count - 1;
end;

procedure TSetMatrixForm.XGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  XGrid.SyncGrid.Grid := MatrixGrid;
end;

procedure TSetMatrixForm.XGridToMatrix(ACol, ARow: integer);
begin
  case FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
    ptMatrix1, ptMatrix2: XGridToMatrixx(ACol, ARow);
    ptMatrix3: XGridToMatrix3(ACol, ARow, FZAxisSelIndex);
    ptMatrix1f, ptMatrix2f: XGridToMatrixxf(ACol, ARow);
    ptMatrix3f: XGridToMatrix3f(ACol, ARow, FZAxisSelIndex);
  else
    ;
  end;
  FMatrixModified := True;
end;

procedure TSetMatrixForm.XGridToMatrix3(ACol, ARow: integer; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  LMInteger: TMatrixInteger;
  z: integer;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  z := ACol+(XGrid.ColCount*ZIndex);
  LMInteger.Value := StrToIntDef(XGrid.Cells[ACol, ARow],0);
  LM1.XAxisIArray[z] := LMInteger;
end;

procedure TSetMatrixForm.XGridToMatrix3f(ACol, ARow: integer; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  LMFloat: TMatrixFloat;
  z: integer;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  z := ACol+(XGrid.ColCount*ZIndex);
  LMFloat.Value := StrToIntDef(XGrid.Cells[ACol, ARow],0);
  LM1.XAxisFArray[z] := LMFloat;
end;

procedure TSetMatrixForm.XGridToMatrixx(ACol, ARow: integer);
var
  LM1: TMatrixItem;
  LMInteger: TMatrixInteger;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  LMInteger.Value := StrToIntDef(XGrid.Cells[ACol, ARow],0);
  LM1.XAxisIArray[ACol+(LM1.XAxisILength*ARow)] := LMInteger;
end;

procedure TSetMatrixForm.XGridToMatrixxf(ACol, ARow: integer);
var
  LM1: TMatrixItem;
  LMFloat: TMatrixFloat;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  LMFloat.Value := StrToFloatDef(XGrid.Cells[ACol, ARow],0);
  LM1.XAxisFArray[ACol+(LM1.XAxisFLength*ARow)] := LMFloat;
end;

procedure TSetMatrixForm.YGridEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
begin
  YGridToMatrix(ACol,ARow);
  FGridEditSeqUnDoList.Add('YGrid');
  FUndoIndex := FGridEditSeqUnDoList.Count - 1;
end;

procedure TSetMatrixForm.YGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  YGrid.SyncGrid.Grid := MatrixGrid;
end;

procedure TSetMatrixForm.YGridToMatrix(ACol, ARow: integer);
begin
  case FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
    ptMatrix1, ptMatrix2: YGridToMatrixx(ACol, ARow);
    ptMatrix3: YGridToMatrix3(ACol, ARow, FZAxisSelIndex);
    ptMatrix1f, ptMatrix2f: YGridToMatrixxf(ACol, ARow);
    ptMatrix3f: YGridToMatrix3f(ACol, ARow, FZAxisSelIndex);
  else
    ;
  end;
  FMatrixModified := True;
end;

procedure TSetMatrixForm.YGridToMatrix3(ACol, ARow: integer; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  LMInteger: TMatrixInteger;
  z: integer;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  z := ARow+(YGrid.RowCount*ZIndex);
  LMInteger.Value := StrToIntDef(YGrid.Cells[ACol, ARow],0);
  LM1.YAxisIArray[z] := LMInteger;
end;

procedure TSetMatrixForm.YGridToMatrix3f(ACol, ARow: integer; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  LMFloat: TMatrixFloat;
  z: integer;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  z := ARow+(YGrid.RowCount*ZIndex);
  LMFloat.Value := StrToIntDef(YGrid.Cells[ACol, ARow],0);
  LM1.YAxisFArray[z] := LMFloat;
end;

procedure TSetMatrixForm.YGridToMatrixx(ACol, ARow: integer);
var
  LM1: TMatrixItem;
  LMInteger: TMatrixInteger;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  LMInteger.Value := StrToIntDef(YGrid.Cells[ACol, ARow],0);
  LM1.YAxisIArray[ARow+(LM1.YAxisILength*(ACol-YGrid.FixedCols))] := LMInteger;
end;

procedure TSetMatrixForm.YGridToMatrixxf(ACol, ARow: integer);
var
  LM1: TMatrixItem;
  LMFloat: TMatrixFloat;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  LMFloat.Value := StrToFloatDef(YGrid.Cells[ACol, ARow],0);
  LM1.YAxisFArray[ARow+(LM1.YAxisFLength*(ACol-YGrid.FixedCols))] := LMFloat;
end;

procedure TSetMatrixForm.ZGridEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
begin
  ZGridToMatrix(ACol,ARow);
  FGridEditSeqUnDoList.Add('ZGrid');
  FUndoIndex := FGridEditSeqUnDoList.Count - 1;
end;

procedure TSetMatrixForm.ZGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  FZAxisSelIndex := ARow;

  if FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType = ptMatrix3 then
    Matrix3ToGrid(FEngineParameter,FZAxisSelIndex)
  else
  if FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType = ptMatrix3f then
    Matrix3fToGrid(FEngineParameter, FZAxisSelIndex)
end;

procedure TSetMatrixForm.ZGridToMatrix(ACol, ARow: integer);
begin
  case FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].ParameterType of
    ptMatrix1, ptMatrix2: ZGridToMatrixx(ACol, ARow);
    ptMatrix3: ZGridToMatrix3(ACol, ARow, FZAxisSelIndex);
    ptMatrix1f, ptMatrix2f: ZGridToMatrixxf(ACol, ARow);
    ptMatrix3f: ZGridToMatrix3f(ACol, ARow, FZAxisSelIndex);
  else
    ;
  end;
  FMatrixModified := True;
end;

procedure TSetMatrixForm.ZGridToMatrix3(ACol, ARow: integer; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  LMInteger: TMatrixInteger;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  //z := ACol+(LM1.XAxisILength*ARow)+(LM1.XAxisILength*LM1.YAxisILength*ZIndex);
  LMInteger.Value := StrToIntDef(ZGrid.Cells[ACol, ARow],0);
  LM1.ZAxisIArray[ZIndex] := LMInteger;
end;

procedure TSetMatrixForm.ZGridToMatrix3f(ACol, ARow: integer; ZIndex: integer = 0);
var
  LM1: TMatrixItem;
  LMFloat: TMatrixFloat;
begin
  LM1 := GetMatrixItem(FEngineParameter);
  //z := ACol+(LM1.XAxisILength*ARow)+(LM1.XAxisILength*LM1.YAxisILength*ZIndex);
  LMFloat.Value := StrToIntDef(ZGrid.Cells[ACol, ARow],0);
  LM1.ZAxisFArray[ZIndex] := LMFloat;
end;

procedure TSetMatrixForm.ZGridToMatrixx(ACol, ARow: integer);
var
  LM1: TMatrixItem;
  LMInteger: TMatrixInteger;
  LIdx: integer;
begin
  LIdx := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;
  LM1 := FEngineParameter.MatrixCollect.Items[LIdx];
  LMInteger.Value := StrToIntDef(ZGrid.Cells[ACol, ARow],0);
  LM1.ZAxisIArray[ARow+(LM1.ZAxisILength*ACol)] := LMInteger;
end;

procedure TSetMatrixForm.ZGridToMatrixxf(ACol, ARow: integer);
var
  LM1: TMatrixItem;
  LMFloat: TMatrixFloat;
  LIdx: integer;
begin
  LIdx := FEngineParameter.EngineParameterCollect.Items[FParamItemIndex].MatrixItemIndex;
  LM1 := FEngineParameter.MatrixCollect.Items[LIdx];
  LMFloat.Value := StrToFloatDef(ZGrid.Cells[ACol, ARow],0);
  LM1.ZAxisFArray[ARow+(LM1.ZAxisFLength*ACol)] := LMFloat;
end;

end.
