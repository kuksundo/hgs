unit frmHiMAPDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, AeroButtons,
  Vcl.ImgList, Vcl.ComCtrls, JvExControls, JvLabel, UnitHiMAPData, mORMot,
  UnitComboBoxUtil, UnitVesselMasterRecord, UnitHiMAPRecord, SynCommons, NxEdit,
  Vcl.Buttons, NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvGlowButton, DropSource, DragDrop, DropTarget,
  AdvOfficePager, UnitGSFileRecord, AdvToolBtn, AdvGroupBox, AdvOfficeButtons;

type
  THiMAPDetailF = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    ImageList16x16: TImageList;
    Imglist16x16: TImageList;
    AeroButton1: TAeroButton;
    btn_Close: TAeroButton;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel49: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel15: TJvLabel;
    DeviceVariantCB: TComboBox;
    PowerSupplyCB: TComboBox;
    PctCB: TComboBox;
    PvtCB: TComboBox;
    PctDiffCB: TComboBox;
    GctCB: TComboBox;
    GptCB: TComboBox;
    HullNoEdit: TEdit;
    JvLabel16: TJvLabel;
    JvLabel17: TJvLabel;
    IMONoEdit: TEdit;
    JvLabel18: TJvLabel;
    VesselNameEdit: TEdit;
    JvLabel19: TJvLabel;
    SerialNoEdit: TEdit;
    JvLabel9: TJvLabel;
    InstalledPanelCB: TComboBox;
    JvLabel11: TJvLabel;
    InstallPositionEdit: TEdit;
    NxButtonEdit1: TNxButtonEdit;
    JvLabel20: TJvLabel;
    InstallDatePicker: TDateTimePicker;
    JvLabel21: TJvLabel;
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DataFormatAdapter1: TDataFormatAdapter;
    DropEmptySource1: TDropEmptySource;
    DataFormatAdapter2: TDataFormatAdapter;
    Panel2: TPanel;
    Panel4: TPanel;
    AdvGlowButton6: TAdvGlowButton;
    AdvGlowButton5: TAdvGlowButton;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    FileName: TNxTextColumn;
    FileSize: TNxTextColumn;
    FilePath: TNxTextColumn;
    DocType: TNxTextColumn;
    AdvToolButton1: TAdvToolButton;
    SymapPanel: TPanel;
    JvLabel2: TJvLabel;
    JvLabel30: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel13: TJvLabel;
    JvLabel14: TJvLabel;
    ProfibusCB: TComboBox;
    IECCB: TComboBox;
    ShuntCB: TComboBox;
    RecordingUnitCB: TComboBox;
    CanBusCB: TComboBox;
    SerialCB: TComboBox;
    AOCB: TComboBox;
    FrontDesignCB: TComboBox;
    HimapPanel: TPanel;
    JvLabel22: TJvLabel;
    JvLabel23: TJvLabel;
    JvLabel24: TJvLabel;
    JvLabel26: TJvLabel;
    JvLabel27: TJvLabel;
    CommunicationCB: TComboBox;
    FrontPanelTypeCB: TComboBox;
    H_RecordingUnitCB: TComboBox;
    ExtBoardCB: TComboBox;
    NormalFreqCB: TComboBox;
    DeviceTypeRG: TRadioGroup;
    SpecialConfigGrp: TAdvOfficeCheckGroup;
    procedure CanBusCBDropDown(Sender: TObject);
    procedure ProfibusCBDropDown(Sender: TObject);
    procedure SerialCBDropDown(Sender: TObject);
    procedure IECCBDropDown(Sender: TObject);
    procedure AOCBDropDown(Sender: TObject);
    procedure ShuntCBDropDown(Sender: TObject);
    procedure FrontDesignCBDropDown(Sender: TObject);
    procedure RecordingUnitCBDropDown(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure InstalledPanelCBDropDown(Sender: TObject);
    procedure NxButtonEdit1ButtonClick(Sender: TObject);
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure fileGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure fileGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure AdvGlowButton5Click(Sender: TObject);
    procedure AdvGlowButton6Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AdvToolButton1Click(Sender: TObject);
    procedure DeviceTypeRGClick(Sender: TObject);
  private
    FFileContent: RawByteString;
    FSQLGSFiles: TSQLGSFile;

    procedure GetHiMAPDetailFromHiMAPRecord(AHiMAPRecord: TSQLHiMAPRecord);
    procedure SetHiMAPDetail2Variant(var ADoc: Variant);
    function GetHiMAPOrderCode: string;
    function GetSymapOrderCode: string;
    procedure SetSyMAPDetailFromOrderCode(ACode: string);
    procedure SetHiMAPDetailFromOrderCode(ACode: string);
    procedure SetDetailFormFromOrderCode(ACode: string);
    procedure ShowFileSelectF(AFileName: string = ''; AFromOutLook: Boolean = False);
    procedure GetHiMAPDataFiles2FormFromID(AID: TID);

    procedure SetSpecialConfigGrp(AHiMAP_SPECIAL_CONFIGs: THiMAP_SPECIAL_CONFIGs);
    function GetSpecialConfigHVCodesFromCheckBox(): string;

    procedure SetCombo4HiMAPDetail(ADeviceType: integer);
    procedure SetCombo4Symap;
    procedure SetCombo4Himap;

    procedure LoadGSFiles2Form;
    procedure SQLGSFileRec2Grid(ARec: TSQLGSFileRec; AGrid: TNextGrid);
  public
    { Public declarations }
  end;

  function CreateHiMAPDetailForm(AImoNo, AHullNo, AShipName: string; ADeviceType, ADeviceVariant, AInstalledPnl: integer): integer;

var
  HiMAPDetailF: THiMAPDetailF;

implementation

uses WinApi.ShellApi, UnitMSBDData, UnitStringUtil, FrmFileSelect,
  DragDropFile, UnitDragUtil;

{$R *.dfm}

function CreateHiMAPDetailForm(AImoNo, AHullNo, AShipName: string; ADeviceType, ADeviceVariant, AInstalledPnl: integer): integer;
var
  LHiMapDetailF: THiMAPDetailF;
  LSQLHiMAPRecord: TSQLHiMAPRecord;
  LDoc: variant;
begin
  LHiMapDetailF := THiMAPDetailF.Create(nil);
  try
    LSQLHiMAPRecord := GetHiMAPFromIMONo_InstalledPnl_DeviceType(AImoNo, ADeviceType, ADeviceVariant, AInstalledPnl);
    LHiMapDetailF.GetHiMAPDetailFromHiMAPRecord(LSQLHiMAPRecord);
    LHiMapDetailF.FSQLGSFiles := GetGSFilesFromID(LSQLHiMAPRecord.ID);
    LHiMapDetailF.LoadGSFiles2Form;

    if not LSQLHiMAPRecord.IsUpdate then
    begin
      LHiMapDetailF.IMONoEdit.Text := AImoNo;
      LHiMapDetailF.HullNoEdit.Text := AHullNo;
      LHiMapDetailF.VesselNameEdit.Text := AShipName;
    end;

    Result := LHiMapDetailF.ShowModal;

    if Result = mrOK then
    begin
      TDocVariant.New(LDoc);
      LHiMapDetailF.SetHiMAPDetail2Variant(LDoc);
      LoadHiMAPFromVariant(LSQLHiMAPRecord, LDoc);
      AddOrUpdateHiMAP(LSQLHiMAPRecord);

      if High(LHiMapDetailF.FSQLGSFiles.Files) >= 0 then
      begin
        g_FileDB.Delete(TSQLGSFile, LHiMapDetailF.FSQLGSFiles.ID);
        LHiMapDetailF.FSQLGSFiles.TaskID := LSQLHiMAPRecord.ID;
        g_FileDB.Add(LHiMapDetailF.FSQLGSFiles, true);
      end
      else
        g_FileDB.Delete(TSQLGSFile, LHiMapDetailF.FSQLGSFiles.ID);
    end;
  finally
    LHiMapDetailF.Free;
  end;
end;

procedure THiMAPDetailF.AdvGlowButton5Click(Sender: TObject);
var
  li : integer;
begin
  with fileGrid do
  begin
    if SelectedRow > -1 then
    begin
      if not(CellByName['FileName',SelectedRow].AsString = '') then
      begin
        if Assigned(FSQLGSFiles) then
          FSQLGSFiles.DynArray('Files').Delete(SelectedRow);
        DeleteRow(SelectedRow);
      end;
    end;

    SelectedRow := -1;
  end;
end;

procedure THiMAPDetailF.AdvGlowButton6Click(Sender: TObject);
begin
  ShowFileSelectF;
end;

procedure THiMAPDetailF.AdvToolButton1Click(Sender: TObject);
begin
  SetDetailFormFromOrderCode(NxButtonEdit1.Text);
end;

procedure THiMAPDetailF.AOCBDropDown(Sender: TObject);
begin
  AOCB.Clear;
  HAO2Combo(AOCB);
  ComboBox_AutoWidth(PvtCB);
end;

procedure THiMAPDetailF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure THiMAPDetailF.CanBusCBDropDown(Sender: TObject);
begin
  CanBusCB.Clear;
  HCB2Combo(CanBusCB);
  ComboBox_AutoWidth(CanBusCB);
end;

procedure THiMAPDetailF.DeviceTypeRGClick(Sender: TObject);
begin
  SymapPanel.Visible := THiMAP_Device_Type(DeviceTypeRG.ItemIndex+1) = hdtSymap;
  HimapPanel.Visible := not SymapPanel.Visible;
  SetCombo4HiMAPDetail(DeviceTypeRG.ItemIndex+1);
end;

procedure THiMAPDetailF.DropEmptyTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  i: integer;
  LFileName: string;
  LFromOutlook: Boolean;
  LTargetStream: TStream;
begin
  LFileName := '';
  // 윈도우 탐색기에서 Drag 했을 경우
  if (DataFormatAdapter1.DataFormat <> nil) then
  begin
    LFileName := (DataFormatAdapter1.DataFormat as TFileDataFormat).Files.Text;

    if LFileName <> '' then
      FFileContent := StringFromFile(LFileName);
  end;

  // OutLook에서 첨부파일을 Drag 했을 경우
  if (TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames.Count > 0) then
  begin
    LFileName := TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat).FileNames[0];
    LTargetStream := GetStreamFromDropDataFormat(TVirtualFileStreamDataFormat(DataFormatAdapterTarget.DataFormat));
    try
      if not Assigned(LTargetStream) then
        ShowMessage('Not Assigned');

      FFileContent := StreamToRawByteString(LTargetStream);
      LFromOutlook := True;
    finally
      if Assigned(LTargetStream) then
        LTargetStream.Free;
    end;
  end;

  if LFileName <> '' then
  begin
    LFileName.Replace('"','');
    ShowFileSelectF(LFileName, LFromOutlook);
  end;
end;

procedure THiMAPDetailF.fileGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  LFileName: string;
begin
  if ARow = -1 then
    exit;

  if Assigned(FSQLGSFiles) then
  begin
    LFileName := 'C:\Temp\'+FSQLGSFiles.Files[ARow].fFilename;

    if FileExists(LFileName) then
      DeleteFile(LFileName);

    FileFromString(FSQLGSFiles.Files[ARow].fData,
      LFileName,True);

    ShellExecute(handle,'open', PChar(LFileName),nil,nil,SW_NORMAL);
  end;
end;

procedure THiMAPDetailF.fileGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
begin
  if (FileGrid.SelectedCount > 0) and
    (DragDetectPlus(FileGrid.Handle, Point(X,Y))) then
  begin
    TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).FileNames.Clear;
    for i := 0 to FileGrid.RowCount - 1 do
      if (FileGrid.Row[i].Selected) then
      begin
        TVirtualFileStreamDataFormat(DataFormatAdapter2.DataFormat).
          FileNames.Add(FileGrid.CellByName['FileName',i].AsString);
      end;

    DropEmptySource1.Execute;
  end;
end;

procedure THiMAPDetailF.FormDestroy(Sender: TObject);
begin
  if Assigned(FSQLGSFiles) then
    FSQLGSFiles.Free;
end;

procedure THiMAPDetailF.FrontDesignCBDropDown(Sender: TObject);
begin
  FrontDesignCB.Clear;
  HFrontDesign2Combo(FrontDesignCB);
  ComboBox_AutoWidth(FrontDesignCB);
end;

procedure THiMAPDetailF.GetHiMAPDataFiles2FormFromID(AID: TID);
begin

end;

procedure THiMAPDetailF.GetHiMAPDetailFromHiMAPRecord(AHiMAPRecord: TSQLHiMAPRecord);
begin
  if AHiMAPRecord.FillOne then
  begin
    DeviceTypeRG.ItemIndex := AHiMAPRecord.Himap_Device_Type-1;
    SetCombo4HiMAPDetail(AHiMAPRecord.Himap_Device_Type);

    AHiMAPRecord.IsUpdate := True;

    HullNoEdit.Text := AHiMAPRecord.HullNo;
    VesselNameEdit.Text := AHiMAPRecord.ShipName;
    IMONoEdit.Text := AHiMAPRecord.IMONo;

    SerialNoEdit.Text := AHiMAPRecord.SerialNo;
    InstallPositionEdit.Text := AHiMAPRecord.InstallPosition;

    DeviceVariantCB.ItemIndex := AHiMAPRecord.Device_Variant;
    PowerSupplyCB.ItemIndex := AHiMAPRecord.Power_Supply;
    PctCB.ItemIndex := AHiMAPRecord.Phase_CT;
    PvtCB.ItemIndex := AHiMAPRecord.Phase_PT;
    PctDiffCB.ItemIndex := AHiMAPRecord.Phase_CT_Diff;
    GctCB.ItemIndex := AHiMAPRecord.CT_Ground;
    GptCB.ItemIndex := AHiMAPRecord.PT_Ground;

    //for Symap
    if THiMAP_Device_Type(AHiMAPRecord.Himap_Device_Type) = hdtSymap then
    begin
      HimapPanel.Visible := False;
      CanBusCB.ItemIndex := AHiMAPRecord.CANBUS;
      ProfibusCB.ItemIndex := AHiMAPRecord.PROFIBUS;
      SerialCB.ItemIndex := AHiMAPRecord.SERIAL_INTERFACE;
      IECCB.ItemIndex := AHiMAPRecord.IEC_61850;
      AOCB.ItemIndex := AHiMAPRecord.Analog_Output;
      ShuntCB.ItemIndex := AHiMAPRecord.Shunt1;
      FrontDesignCB.ItemIndex := AHiMAPRecord.Front_Design;
      RecordingUnitCB.ItemIndex := AHiMAPRecord.Recording_Unit;
    end
    else //for himap
    if THiMAP_Device_Type(AHiMAPRecord.Himap_Device_Type) = hdtHimap then
    begin
      SymapPanel.Visible := False;
      CommunicationCB.ItemIndex := AHiMAPRecord.Communication;
      ExtBoardCB.ItemIndex := AHiMAPRecord.ExetndedBoard;
      SetSpecialConfigGrp(HVCodes2HiMAP_SPECIAL_CONFIG_Set(AHiMAPRecord.SpecialConfig));
      NormalFreqCB.ItemIndex := AHiMAPRecord.NorminalFrequency;
      FrontPanelTypeCB.ItemIndex := AHiMAPRecord.FrontpanelType;
      H_RecordingUnitCB.ItemIndex := AHiMAPRecord.Recording_Unit;
    end;

    InstalledPanelCB.ItemIndex := AHiMAPRecord.InstalledPanel;
    InstallDatePicker.Date := TimeLogToDateTime(AHiMAPRecord.InstallDate);

    NxButtonEdit1ButtonClick(nil);
  end;
end;

function THiMAPDetailF.GetHiMAPOrderCode: string;
var
  LSQLHiMAPRecord: TSQLHiMAPRecord;
  LDoc: variant;
begin
  LSQLHiMAPRecord := TSQLHiMAPRecord.Create;
  try
    TDocVariant.New(LDoc);
    SetHiMAPDetail2Variant(LDoc);
    LoadHiMAPFromVariant(LSQLHiMAPRecord, LDoc);
    Result := LSQLHiMAPRecord.GetHiMAPOrderCode;
  finally
    FreeAndNil(LSQLHiMAPRecord);
  end;
end;

function THiMAPDetailF.GetSpecialConfigHVCodesFromCheckBox: string;
var
  i: integer;
begin
  for i := 0 to SpecialConfigGrp.Items.Count - 1 do
  begin
    if SpecialConfigGrp.Checked[i] then
      Result := Result + HSpecialConfig2HVCode(THiMAP_SPECIAL_CONFIG(i+1));
  end;
end;

function THiMAPDetailF.GetSymapOrderCode: string;
var
  LSQLHiMAPRecord: TSQLHiMAPRecord;
  LDoc: variant;
begin
  LSQLHiMAPRecord := TSQLHiMAPRecord.Create;
  try
    TDocVariant.New(LDoc);
    SetHiMAPDetail2Variant(LDoc);
    LoadHiMAPFromVariant(LSQLHiMAPRecord, LDoc);
    Result := LSQLHiMAPRecord.GetSymapOrderCode;
  finally
    FreeAndNil(LSQLHiMAPRecord);
  end;
end;

procedure THiMAPDetailF.IECCBDropDown(Sender: TObject);
begin
  IECCB.Clear;
  HIEC618502Combo(IECCB);
  ComboBox_AutoWidth(IECCB);
end;

procedure THiMAPDetailF.InstalledPanelCBDropDown(Sender: TObject);
begin
  InstalledPanelCB.Clear;
  MSBDPT2Combo(InstalledPanelCB);
  ComboBox_AutoWidth(InstalledPanelCB);
end;

procedure THiMAPDetailF.LoadGSFiles2Form;
var
  LSQLGSFileRec: TSQLGSFileRec;
  LRow: integer;
begin
  try
    FileGrid.BeginUpdate;
    FileGrid.ClearRows;

    while FSQLGSFiles.FillOne do
    begin
      for LRow := Low(FSQLGSFiles.Files) to High(FSQLGSFiles.Files) do
      begin
        SQLGSFileRec2Grid(FSQLGSFiles.Files[LRow], FileGrid);
      end;
    end;
  finally
    FileGrid.EndUpdate;
  end;
end;

procedure THiMAPDetailF.NxButtonEdit1ButtonClick(Sender: TObject);
begin
  if THiMAP_Device_Type(DeviceTypeRG.ItemIndex+1) = hdtSymap then
    NxButtonEdit1.Text := GetSyMAPOrderCode
  else
  if THiMAP_Device_Type(DeviceTypeRG.ItemIndex+1) = hdtHimap then
    NxButtonEdit1.Text := GetHiMAPOrderCode
end;

procedure THiMAPDetailF.ProfibusCBDropDown(Sender: TObject);
begin
  ProfibusCB.Clear;
  HPB2Combo(ProfibusCB);
  ComboBox_AutoWidth(ProfibusCB);
end;

procedure THiMAPDetailF.RecordingUnitCBDropDown(Sender: TObject);
begin
  RecordingUnitCB.Clear;
  HRecordingUnit2Combo(RecordingUnitCB);
  ComboBox_AutoWidth(RecordingUnitCB);
end;

procedure THiMAPDetailF.SerialCBDropDown(Sender: TObject);
begin
  SerialCB.Clear;
  HSI2Combo(SerialCB);
  ComboBox_AutoWidth(SerialCB);
end;

procedure THiMAPDetailF.SetCombo4Himap;
begin
  HDV2Combo2(DeviceVariantCB);
  ComboBox_AutoWidth(DeviceVariantCB);

  HPS2Combo2(PowerSupplyCB);
  ComboBox_AutoWidth(PowerSupplyCB);

  HPCT2Combo2(PctCB);
  ComboBox_AutoWidth(PctCB);

  HPPT2Combo2(PvtCB);
  ComboBox_AutoWidth(PvtCB);

  HPCTD2Combo2(PctDiffCB);
  ComboBox_AutoWidth(PctDiffCB);

  HCTG2Combo2(GctCB);
  ComboBox_AutoWidth(GctCB);

  HPTG2Combo2(GptCB);
  ComboBox_AutoWidth(GptCB);

  HRecordingUnit2Combo2(H_RecordingUnitCB);
  ComboBox_AutoWidth(H_RecordingUnitCB);

  HCommunication2Combo2(CommunicationCB);
  ComboBox_AutoWidth(CommunicationCB);

  HExtBoard2Combo2(ExtBoardCB);
  ComboBox_AutoWidth(ExtBoardCB);

  HSpecialConfig2List(SpecialConfigGrp.Items);

  HNormalFreq2Combo2(NormalFreqCB);
  ComboBox_AutoWidth(NormalFreqCB);

  HFrontType2Combo2(FrontPanelTypeCB);
  ComboBox_AutoWidth(FrontPanelTypeCB);

  MSBDPT2Combo(InstalledPanelCB);
  ComboBox_AutoWidth(FrontPanelTypeCB);
end;

procedure THiMAPDetailF.SetCombo4HiMAPDetail(ADeviceType: integer);
begin
  if THiMAP_Device_Type(ADeviceType) = hdtSymap then
    SetCombo4Symap
  else
  if THiMAP_Device_Type(ADeviceType) = hdtHimap then
    SetCombo4Himap;
end;

procedure THiMAPDetailF.SetCombo4Symap;
begin
  HDV2Combo(DeviceVariantCB);
  ComboBox_AutoWidth(DeviceVariantCB);

  HPS2Combo(PowerSupplyCB);
  ComboBox_AutoWidth(PowerSupplyCB);

  HPCT2Combo(PctCB);
  ComboBox_AutoWidth(PctCB);

  HPPT2Combo(PvtCB);
  ComboBox_AutoWidth(PvtCB);

  HPCTD2Combo(PctDiffCB);
  ComboBox_AutoWidth(PctDiffCB);

  HCTG2Combo(GctCB);
  ComboBox_AutoWidth(GctCB);

  HPTG2Combo(GptCB);
  ComboBox_AutoWidth(GptCB);

  HCB2Combo(CanBusCB);
  ComboBox_AutoWidth(CanBusCB);

  HPB2Combo(ProfibusCB);
  ComboBox_AutoWidth(ProfibusCB);

  HSI2Combo(SerialCB);
  ComboBox_AutoWidth(SerialCB);

  HIEC618502Combo(IECCB);
  ComboBox_AutoWidth(IECCB);

  HAO2Combo(AOCB);
  ComboBox_AutoWidth(AOCB);

  HS12Combo(ShuntCB);
  ComboBox_AutoWidth(ShuntCB);

  HFrontDesign2Combo(FrontDesignCB);
  ComboBox_AutoWidth(FrontDesignCB);

  HRecordingUnit2Combo(RecordingUnitCB);
  ComboBox_AutoWidth(RecordingUnitCB);

  MSBDPT2Combo(InstalledPanelCB);
  ComboBox_AutoWidth(InstalledPanelCB);
end;

procedure THiMAPDetailF.SetDetailFormFromOrderCode(ACode: string);
begin
  if THiMAP_Device_Type(DeviceTypeRG.ItemIndex+1) = hdtSymap then
    SetSyMAPDetailFromOrderCode(ACode)
  else
  if THiMAP_Device_Type(DeviceTypeRG.ItemIndex+1) = hdtHimap then
    SetHiMAPDetailFromOrderCode(ACode);
end;

procedure THiMAPDetailF.SetHiMAPDetail2Variant(var ADoc: Variant);
begin
  ADoc.HullNo := HullNoEdit.Text;
  ADoc.ShipName := VesselNameEdit.Text;
  ADoc.IMONo := IMONoEdit.Text;

  ADoc.SerialNo := SerialNoEdit.Text;
  ADoc.InstallPosition := InstallPositionEdit.Text;

  //for Symap
  if THiMAP_Device_Type(DeviceTypeRG.ItemIndex+1) = hdtSymap then
  begin
    ADoc.Himap_Device_Type := HDT2VCode(THiMAP_Device_Type(DeviceTypeRG.ItemIndex+1));
    ADoc.Device_Variant := HDV2VCode(THiMAP_Device_Variant(DeviceVariantCB.ItemIndex));
    ADoc.Power_Supply := HPS2VCode(THiMAP_Power_Supply(PowerSupplyCB.ItemIndex));
    ADoc.Phase_CT := HPCT2VCode(THiMAP_Phase_CT(PctCB.ItemIndex));
    ADoc.Phase_PT := HPPT2VCode(THiMAP_Phase_PT(PvtCB.ItemIndex));
    ADoc.Phase_CT_Diff := HPCTD2VCode(THiMAP_Phase_CT_Diff(PctDiffCB.ItemIndex));
    ADoc.CT_Ground := HCTG2VCode(THiMAP_CT_Ground(GctCB.ItemIndex));
    ADoc.PT_Ground := HPTG2VCode(THiMAP_PT_Ground(GptCB.ItemIndex));

    ADoc.CANBUS := HCB2VCode(THiMAP_CANBUS(CanBusCB.ItemIndex));
    ADoc.PROFIBUS := HPB2VCode(THiMAP_PROFIBUS(ProfibusCB.ItemIndex));
    ADoc.SERIAL_INTERFACE := HSI2VCode(THiMAP_SERIAL_INTERFACE(SerialCB.ItemIndex));
    ADoc.IEC_61850 := HIEC618502VCode(THiMAP_IEC_61850(IECCB.ItemIndex));
    ADoc.Analog_Output := HAO2VCode(THiMAP_Analog_Output(AOCB.ItemIndex));
    ADoc.Shunt1 := HS12VCode(THiMAP_Shunt1(ShuntCB.ItemIndex));
    ADoc.Front_Design := HFrontDesign2VCode(THiMAP_Front_Design(FrontDesignCB.ItemIndex));
    ADoc.Recording_Unit := HRecordingUnit2VCode(THiMAP_Recording_Unit(RecordingUnitCB.ItemIndex));
  end
  else
  if THiMAP_Device_Type(DeviceTypeRG.ItemIndex+1) = hdtHimap then
  begin
    ADoc.Himap_Device_Type := HDT2HVCode(THiMAP_Device_Type(DeviceTypeRG.ItemIndex+1));
    ADoc.Device_Variant := HDV2HVCode(THiMAP_Device_Variant(DeviceVariantCB.ItemIndex));
    ADoc.Power_Supply := HPS2HVCode(THiMAP_Power_Supply(PowerSupplyCB.ItemIndex));
    ADoc.Phase_CT := HPCT2HVCode(THiMAP_Phase_CT(PctCB.ItemIndex));
    ADoc.Phase_PT := HPPT2HVCode(THiMAP_Phase_PT(PvtCB.ItemIndex));
    ADoc.Phase_CT_Diff := HPCTD2HVCode(THiMAP_Phase_CT_Diff(PctDiffCB.ItemIndex));
    ADoc.CT_Ground := HCTG2HVCode(THiMAP_CT_Ground(GctCB.ItemIndex));
    ADoc.PT_Ground := HPTG2HVCode(THiMAP_PT_Ground(GptCB.ItemIndex));

    ADoc.Communication := HCommunication2HVCode(THiMAP_COMMUNICATION(CommunicationCB.ItemIndex));
    ADoc.ExetndedBoard := HExtBoard2HVCode(THiMAP_EXTENDED_BOARD(ExtBoardCB.ItemIndex));
    ADoc.SpecialConfig := GetSpecialConfigHVCodesFromCheckBox;
    ADoc.NorminalFrequency := HNormalFreq2HVCode(THiMAP_NORMAL_FREQUENCY(NormalFreqCB.ItemIndex));
    ADoc.FrontpanelType := HFrontType2HVCode(THiMAP_FRONTPANEL_TYPE(FrontPanelTypeCB.ItemIndex));
    ADoc.Recording_Unit := HRecordingUnit2VCode(THiMAP_Recording_Unit(H_RecordingUnitCB.ItemIndex));
  end;

  ADoc.InstalledPanel := MSBDPT2VCode(TMSBD_Panel_Type(InstalledPanelCB.ItemIndex));
  ADoc.InstallDate := DateToStr(InstallDatePicker.Date);
end;

procedure THiMAPDetailF.SetHiMAPDetailFromOrderCode(ACode: string);
var
  LStr: string;
  LHiMAP_SPECIAL_CONFIGs: THiMAP_SPECIAL_CONFIGs;
begin
  if ACode <> '' then
  begin
//    DeviceVariantCB.ItemIndex := Ord(VCode2HDV(strToken(ACode, ' ')));
    LStr := strToken(ACode, '/');
    PowerSupplyCB.ItemIndex := Ord(HVCode2HPS(LStr));
    LStr := strToken(ACode, '/');
    PctCB.ItemIndex := Ord(HVCode2HPCT(LStr));
    LStr := strToken(ACode, '/');
    PvtCB.ItemIndex := Ord(HVCode2HPPT(LStr));
    LStr := strToken(ACode, '/');
    PctDiffCB.ItemIndex := Ord(HVCode2HPCTD(LStr));
    LStr := strToken(ACode, '/');
    GctCB.ItemIndex := Ord(HVCode2HCTG(LStr));
    LStr := strToken(ACode, '/');
    GptCB.ItemIndex := Ord(HVCode2HPTG(LStr));
    LStr := strToken(ACode, '/');
    H_RecordingUnitCB.ItemIndex := Ord(HVCode2HRecordingUnit(LStr));
    LStr := strToken(ACode, '/');
    CommunicationCB.ItemIndex := Ord(HVCode2HCommunication(LStr));
    LStr := strToken(ACode, '/');
    ExtBoardCB.ItemIndex := Ord(HVCode2HExtBoard(LStr));
    LStr := strToken(ACode, '/');
    LHiMAP_SPECIAL_CONFIGs := HVCodes2HiMAP_SPECIAL_CONFIG_Set(LStr);
    SetSpecialConfigGrp(LHiMAP_SPECIAL_CONFIGs);
    LStr := strToken(ACode, '/');
    NormalFreqCB.ItemIndex := Ord(HVCode2HNormalFreq(LStr));
    LStr := strToken(ACode, '/');
    FrontPanelTypeCB.ItemIndex := Ord(HVCode2HFrontType(LStr));

    //    InstalledPanelCB.ItemIndex := AHiMAPRecord.InstalledPanel;
  end;
end;

procedure THiMAPDetailF.SetSpecialConfigGrp(
  AHiMAP_SPECIAL_CONFIGs: THiMAP_SPECIAL_CONFIGs);
begin
  SpecialConfigGrp.Checked[Ord(hsc0)-1] := hsc0 in AHiMAP_SPECIAL_CONFIGs;
  SpecialConfigGrp.Checked[Ord(hsc1)-1] := hsc1 in AHiMAP_SPECIAL_CONFIGs;
  SpecialConfigGrp.Checked[Ord(hsc2)-1] := hsc2 in AHiMAP_SPECIAL_CONFIGs;
  SpecialConfigGrp.Checked[Ord(hsc3)-1] := hsc3 in AHiMAP_SPECIAL_CONFIGs;
  SpecialConfigGrp.Checked[Ord(hsc4)-1] := hsc4 in AHiMAP_SPECIAL_CONFIGs;
end;

procedure THiMAPDetailF.SetSyMAPDetailFromOrderCode(ACode: string);
var
  LStr: string;
begin
  if ACode <> '' then
  begin
    DeviceVariantCB.ItemIndex := Ord(VCode2HDV(strToken(ACode, ' ')));
    LStr := strToken(ACode, '-');
    PowerSupplyCB.ItemIndex := Ord(VCode2HPS(Copy(LStr,1,1)));
    PctCB.ItemIndex := Ord(VCode2HPCT(Copy(LStr,2,1)));
    PvtCB.ItemIndex := Ord(VCode2HPPT(Copy(LStr,3,1)));
    PctDiffCB.ItemIndex := Ord(VCode2HPCTD(Copy(LStr,4,1)));
    LStr := strToken(ACode, '-');
    GctCB.ItemIndex := Ord(VCode2HCTG(Copy(LStr,1,1)));
    GptCB.ItemIndex := Ord(VCode2HPTG(Copy(LStr,2,1)));
    CanBusCB.ItemIndex := Ord(VCode2HCB(Copy(LStr,3,1)));
    ProfibusCB.ItemIndex := Ord(VCode2HPB(Copy(LStr,4,1)));
    LStr := strToken(ACode, '-');
    SerialCB.ItemIndex := Ord(VCode2HSI(Copy(LStr,1,1)));
    IECCB.ItemIndex := Ord(VCode2HIEC61850(Copy(LStr,2,1)));
    AOCB.ItemIndex := Ord(VCode2HAO(Copy(LStr,3,1)));
    ShuntCB.ItemIndex := Ord(VCode2HS1(Copy(LStr,4,1)));
    FrontDesignCB.ItemIndex := Ord(VCode2HFrontDesign(Copy(ACode,1,1)));
    RecordingUnitCB.ItemIndex := Ord(VCode2HRecordingUnit(Copy(ACode,2,1)));
//    InstalledPanelCB.ItemIndex := AHiMAPRecord.InstalledPanel;
  end;
end;

procedure THiMAPDetailF.ShowFileSelectF(AFileName: string;
  AFromOutLook: Boolean);
var
  li,le : integer;
  lfilename : String;
  lExt : String;
  lSize : int64;
  LFileSelectF: TFileSelectF;
  LSQLGSFileRec: TSQLGSFileRec;
  LDoc: RawByteString;
  i: integer;
begin
  LFileSelectF := TFileSelectF.Create(nil);
  try
    //Drag 했을 경우 AFileName <> ''이고
    //Task Edit 화면에서 추가 버튼을 눌렀을 경우 AFileName = ''임
    if AFileName <> '' then
      LFileSelectF.JvFilenameEdit1.FileName := AFileName;

    if LFileSelectF.ShowModal = mrOK then
    begin
      if LFileSelectF.JvFilenameEdit1.FileName = '' then
        exit;

      lfilename := ExtractFileName(LFileSelectF.JvFilenameEdit1.FileName);

      with fileGrid do
      begin
        BeginUpdate;
        try
          if AFileName <> '' then
            LDoc := FFileContent
          else
            LDoc := StringFromFile(LFileSelectF.JvFilenameEdit1.FileName);

          LSQLGSFileRec.fData := LDoc;
//          LSQLGSFileRec.fGSDocType := String2GSDocType(LFileSelectF.ComboBox1.Text);
          LSQLGSFileRec.fFilename := lfilename;

          if not Assigned(FSQLGSFiles) then
            FSQLGSFiles := TSQLGSFile.Create;

          i := FSQLGSFiles.DynArray('Files').Add(LSQLGSFileRec);
          AddRow;
          CellByName['FileName',RowCount-1].AsString := lfilename;
          CellByName['FileSize',RowCount-1].AsString := IntToStr(lsize);
          CellByName['FilePath',RowCount-1].AsString := LFileSelectF.JvFilenameEdit1.FileName;
          CellByName['DocType',RowCount-1].AsString := LFileSelectF.ComboBox1.Text;
        finally
          EndUpdate;
        end;
      end;
    end;
  finally
    LFileSelectF.Free;
  end;
end;

procedure THiMAPDetailF.ShuntCBDropDown(Sender: TObject);
begin
  ShuntCB.Clear;
  HS12Combo(ShuntCB);
  ComboBox_AutoWidth(ShuntCB);
end;

procedure THiMAPDetailF.SQLGSFileRec2Grid(ARec: TSQLGSFileRec;
  AGrid: TNextGrid);
var
  LRow: integer;
begin
  LRow := AGrid.AddRow();
  AGrid.CellByName['FileName', LRow].AsString := ARec.fFilename;
//  AGrid.CellByName['DocType', LRow].AsString := GSDocType2String(ARec.fGSDocType);
end;

end.
