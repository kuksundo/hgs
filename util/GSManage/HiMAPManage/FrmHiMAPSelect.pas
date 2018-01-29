unit FrmHiMAPSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumns, NxColumnClasses, SynCommons,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.Buttons,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, UnitHiMAPRecord, UnitHiMAPData, UnitMSBDData;

type
  THiMAPSelectF = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    OrderCodeEdit: TEdit;
    SerialNoEdit: TEdit;
    SearchButton: TButton;
    Panel2: TPanel;
    NextGrid1: TNextGrid;
    OrderCode: TNxTextColumn;
    SerialNo: TNxTextColumn;
    Device: TNxTextColumn;
    Power: TNxTextColumn;
    CT: TNxTextColumn;
    PT: TNxTextColumn;
    GCT: TNxTextColumn;
    GPT: TNxTextColumn;
    CanBus: TNxTextColumn;
    ProfiBus: TNxTextColumn;
    SerialIntf: TNxTextColumn;
    IEC: TNxTextColumn;
    AO: TNxTextColumn;
    Shunt1: TNxTextColumn;
    FrontDesign: TNxTextColumn;
    RecUnit: TNxTextColumn;
    PopupMenu1: TPopupMenu;
    ShowHistory1: TMenuItem;
    CTDiff: TNxTextColumn;
    IMONo: TNxTextColumn;
    InstalledPanel: TNxTextColumn;
    HullNo: TNxTextColumn;
    ShipName: TNxTextColumn;
    InstallDate: TNxTextColumn;
    DeviceVCode: TNxTextColumn;
    DeleteDevice1: TMenuItem;
    Add1: TMenuItem;
    HiMAP1: TMenuItem;
    Communication: TNxTextColumn;
    ExtendedBoard: TNxTextColumn;
    SpecialConfig: TNxTextColumn;
    NormalFreq: TNxTextColumn;
    FrontPanelType: TNxTextColumn;
    DeviceType: TNxTextColumn;
    BitBtn1: TBitBtn;
    procedure NextGrid1CellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure DeleteDevice1Click(Sender: TObject);
    procedure HiMAP1Click(Sender: TObject);
  private
    FIMONo, FHullNo, FShipName: string;
  public
    procedure DoSearchHiMAPFromIMONo(AImoNo: string);
    procedure SetVisible4Symap(AVisible: Boolean);
    procedure SetVisible4Himap(AVisible: Boolean);
  end;

  function CreateHiMAPSelectForm(AImoNo, AHullNo, AShipName: string): integer;

var
  HiMAPSelectF: THiMAPSelectF;

implementation

uses UnitVesselMasterRecord, frmHiMAPDetail;

{$R *.dfm}

function CreateHiMAPSelectForm(AImoNo, AHullNo, AShipName: string): integer;
var
  LHiMAPSelectF: THiMAPSelectF;
  LSQLHiMAPRecord: TSQLHiMAPRecord;
begin
  LSQLHiMAPRecord := GetHiMAPFromIMONo(AImoNo);

  if LSQLHiMAPRecord.FillOne then //LSQLHiMAPRecord.IsUpdate then
  begin
    LHiMAPSelectF := THiMAPSelectF.Create(nil);
    try
      LHiMAPSelectF.FIMONo := AImoNo;
      LHiMAPSelectF.FHullNo := AHullNo;
      LHiMAPSelectF.FShipName := AShipName;

      LHiMAPSelectF.DoSearchHiMAPFromIMONo(AImoNo);
      Result := LHiMAPSelectF.ShowModal;

      if Result = mrOK then
      begin
        ShowMessage('mrOK!');;
      end;
    finally
      LHiMAPSelectF.Free;
    end;
  end
  else
  begin
    if CreateHiMAPDetailForm(AImoNo, AHullNo, AShipName, 0, 0, 0) = mrOK then
    begin
        ShowMessage('mroooooooooooooooOK!');;
    end;
  end;
end;

{ THiMAPSelectF }

procedure THiMAPSelectF.DeleteDevice1Click(Sender: TObject);
var
  LRow, LInstalledPnl, LDeviceType, LDeviceVariant: integer;
  LIMONo: string;
begin
  LRow := NextGrid1.SelectedRow;

  if LRow = -1 then
  begin
    ShowMessage('Select the device to delete with mouse!');
    exit;
  end;

  if MessageDlg('Are you sure to delete?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
  begin
    LIMONo := NextGrid1.CellByName['IMONo', LRow].AsString;
    LInstalledPnl := Ord(Desc2MSBDPT(NextGrid1.CellByName['InstalledPanel', LRow].AsString));
    LDeviceType := Ord(VCode2HDT(NextGrid1.CellByName['DeviceType', LRow].AsString));
    LDeviceVariant := Ord(VCode2HDV(NextGrid1.CellByName['DeviceVCode', LRow].AsString));

    DeleteHiMAPFromIMONo_InstalledPnl_DeviceType(LIMONo, LInstalledPnl, LDeviceType, LDeviceVariant);
    DoSearchHiMAPFromIMONo(LIMONo);
  end;
end;

procedure THiMAPSelectF.DoSearchHiMAPFromIMONo(AImoNo: string);
var
  LOrderCode, LSerialNo, LDevice: string;
  LHiMAPRecord: TSQLHiMAPRecord;
  LRow: integer;
begin
  LOrderCode := OrderCodeEdit.Text;
  LSerialNo := SerialNoEdit.Text;

  LHiMAPRecord := GetHiMAPFromIMONo(AImoNo);
  try
    NextGrid1.ClearRows;
    LHiMAPRecord.FillRewind;

    while LHiMAPRecord.FillOne do
    begin
      LRow := NextGrid1.AddRow();

      NextGrid1.CellByName['IMONo', LRow].AsString := LHiMAPRecord.IMONo;
      NextGrid1.CellByName['HullNo', LRow].AsString := LHiMAPRecord.HullNo;
      NextGrid1.CellByName['ShipName', LRow].AsString := LHiMAPRecord.ShipName;
      NextGrid1.CellByName['OrderCode', LRow].AsString := LHiMAPRecord.GetSymapOrderCode;
      NextGrid1.CellByName['SerialNo', LRow].AsString := LHiMAPRecord.SerialNo;
      NextGrid1.CellByName['DeviceVCode', LRow].AsString :=
        HDV2VCode(THiMAP_Device_Variant(LHiMAPRecord.Device_Variant));

      if LHiMAPRecord.Front_Design = Ord(hpdB) then
        LDevice := 'HiMAP-'
      else
        LDevice := 'SyMAP-';

      NextGrid1.CellByName['DeviceType', LRow].AsString :=
        HDT2VCode(THiMAP_Device_Type(LHiMAPRecord.Himap_Device_Type));
      NextGrid1.CellByName['Device', LRow].AsString :=  LDevice +
        HDV2VCode(THiMAP_Device_Variant(LHiMAPRecord.Device_Variant));
      NextGrid1.CellByName['Power', LRow].AsString :=
        HPS2Desc(THiMAP_Power_Supply(LHiMAPRecord.Power_Supply));
      NextGrid1.CellByName['CT', LRow].AsString :=
        HPCT2Desc(THiMAP_Phase_CT(LHiMAPRecord.Phase_CT));
      NextGrid1.CellByName['PT', LRow].AsString :=
        HPPT2Desc(THiMAP_Phase_PT(LHiMAPRecord.Phase_PT));
      NextGrid1.CellByName['CTDiff', LRow].AsString :=
        HPCTD2Desc(THiMAP_Phase_CT_Diff(LHiMAPRecord.Phase_CT_Diff));
      NextGrid1.CellByName['GCT', LRow].AsString :=
        HCTG2Desc(THiMAP_CT_Ground(LHiMAPRecord.CT_Ground));
      NextGrid1.CellByName['GPT', LRow].AsString :=
        HPTG2Desc(THiMAP_PT_Ground(LHiMAPRecord.PT_Ground));

      //for Symap
      if THiMAP_Device_Type(LHiMAPRecord.Himap_Device_Type) = hdtSymap then
      begin
        NextGrid1.CellByName['CanBus', LRow].AsString :=
          HCB2Desc(THiMAP_CANBUS(LHiMAPRecord.CANBUS));
        NextGrid1.CellByName['ProfiBus', LRow].AsString :=
          HPB2Desc(THiMAP_PROFIBUS(LHiMAPRecord.PROFIBUS));
        NextGrid1.CellByName['SerialIntf', LRow].AsString :=
          HSI2Desc(THiMAP_SERIAL_INTERFACE(LHiMAPRecord.SERIAL_INTERFACE));
        NextGrid1.CellByName['IEC', LRow].AsString :=
          HIEC618502Desc(THiMAP_IEC_61850(LHiMAPRecord.IEC_61850));
        NextGrid1.CellByName['AO', LRow].AsString :=
          HAO2Desc(THiMAP_Analog_Output(LHiMAPRecord.Analog_Output));
        NextGrid1.CellByName['Shunt1', LRow].AsString :=
          HS12Desc(THiMAP_Shunt1(LHiMAPRecord.Shunt1));
        NextGrid1.CellByName['FrontDesign', LRow].AsString :=
          HFrontDesign2Desc(THiMAP_Front_Design(LHiMAPRecord.Front_Design));
      end
      else //for himap
      if THiMAP_Device_Type(LHiMAPRecord.Himap_Device_Type) = hdtHimap then
      begin
        NextGrid1.CellByName['Communication', LRow].AsString :=
          HCommunication2Desc(THiMAP_COMMUNICATION(LHiMAPRecord.Communication));
        NextGrid1.CellByName['ExtendedBoard', LRow].AsString :=
          HExtBoard2Desc(THiMAP_EXTENDED_BOARD(LHiMAPRecord.ExetndedBoard));
        NextGrid1.CellByName['SpecialConfig', LRow].AsString :=
          HSpecialConfigs2Desc(LHiMAPRecord.SpecialConfig);
        NextGrid1.CellByName['NormalFreq', LRow].AsString :=
          HNormalFreq2Desc(THiMAP_NORMAL_FREQUENCY(LHiMAPRecord.NorminalFrequency));
        NextGrid1.CellByName['FrontPanelType', LRow].AsString :=
          HFrontType2Desc(THiMAP_FRONTPANEL_TYPE(LHiMAPRecord.FrontpanelType));
      end;

      NextGrid1.CellByName['RecUnit', LRow].AsString :=
        HRecordingUnit2Desc(THiMAP_Recording_Unit(LHiMAPRecord.Recording_Unit));
      NextGrid1.CellByName['InstalledPanel', LRow].AsString :=
        MSBDPT2Desc(TMSBD_Panel_Type(LHiMAPRecord.InstalledPanel));
      NextGrid1.CellByName['InstallDate', LRow].AsString :=
        DateToStr(TimeLogToDateTime(LHiMAPRecord.InstallDate));
    end;
  finally
    FreeAndNil(LHiMAPRecord);
  end;
end;

procedure THiMAPSelectF.HiMAP1Click(Sender: TObject);
begin
  if CreateHiMAPDetailForm(FIMONo, FHullNo, FShipName, 0, 0, 0) = mrOK then
  begin
    DoSearchHiMAPFromIMONo(FIMONo);
    ShowMessage('HiMAP device added!');;
  end;
end;

procedure THiMAPSelectF.NextGrid1CellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  LImoNo, LHullNo, LShipName: string;
  LRow, LDeviceType, LDeviceVariant, LInstalledPnl: integer;
begin
  LRow := NextGrid1.SelectedRow;

  if LRow = -1 then
    exit;

  LImoNo := NextGrid1.CellByName['IMONo', LRow].AsString;
  LHullNo := NextGrid1.CellByName['HullNo', LRow].AsString;
  LShipName := NextGrid1.CellByName['ShipName', LRow].AsString;
  LDeviceType := Ord(VCode2HDT(NextGrid1.CellByName['DeviceType', LRow].AsString));
  LDeviceVariant := Ord(VCode2HDV(NextGrid1.CellByName['DeviceVCode', LRow].AsString));
  LInstalledPnl := Ord(Desc2MSBDPT(NextGrid1.CellByName['InstalledPanel', LRow].AsString));

  if CreateHiMAPDetailForm(LImoNo, LHullNo, LShipName, LInstalledPnl, LDeviceType, LDeviceVariant) = mrOK then
  begin
    DoSearchHiMAPFromIMONo(LImoNo);
    ShowMessage('HiMAP Data saved succefully!');;
  end;
end;

procedure THiMAPSelectF.SetVisible4Himap(AVisible: Boolean);
begin
  NextGrid1.ColumnByName['CanBus'].Visible := AVisible;
  NextGrid1.ColumnByName['ProfiBus'].Visible := AVisible;
  NextGrid1.ColumnByName['SerialIntf'].Visible := AVisible;
  NextGrid1.ColumnByName['IEC'].Visible := AVisible;
  NextGrid1.ColumnByName['AO'].Visible := AVisible;
  NextGrid1.ColumnByName['Shunt1'].Visible := AVisible;
  NextGrid1.ColumnByName['FrontDesign'].Visible := AVisible;
end;

procedure THiMAPSelectF.SetVisible4Symap(AVisible: Boolean);
begin
  NextGrid1.ColumnByName['Communication'].Visible := AVisible;
  NextGrid1.ColumnByName['ExtendedBoard'].Visible := AVisible;
  NextGrid1.ColumnByName['SpecialConfig'].Visible := AVisible;
  NextGrid1.ColumnByName['NormalFreq'].Visible := AVisible;
  NextGrid1.ColumnByName['FrontPanelType'].Visible := AVisible;
end;

end.
