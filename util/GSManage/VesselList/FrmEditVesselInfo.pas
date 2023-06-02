unit FrmEditVesselInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DropSource, DragDrop, DropTarget,
  Vcl.ImgList, NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvGlowButton, AdvGroupBox, AdvOfficeButtons,
  Vcl.ComCtrls, NxEdit, Vcl.StdCtrls, AdvToolBtn, JvExControls, JvLabel,
  AdvOfficePager, Vcl.ExtCtrls, AeroButtons, UnitVesselMasterRecord, SynCommons,
  CommonData, UnitVesselData;

type
  TEditVesselInfoF = class(TForm)
    Panel1: TPanel;
    AeroButton1: TAeroButton;
    btn_Close: TAeroButton;
    Panel3: TPanel;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel49: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel20: TJvLabel;
    HullNoEdit: TNxButtonEdit;
    DeliveryDatePicker: TDateTimePicker;
    AdvOfficePager12: TAdvOfficePage;
    JvLabel21: TJvLabel;
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
    ImageList16x16: TImageList;
    Imglist16x16: TImageList;
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DataFormatAdapter1: TDataFormatAdapter;
    DropEmptySource1: TDropEmptySource;
    DataFormatAdapter2: TDataFormatAdapter;
    AdvOfficePage1: TAdvOfficePage;
    AdvOfficePage2: TAdvOfficePage;
    ShipTypeDescEdit: TEdit;
    JvLabel22: TJvLabel;
    LastDockDatePicker: TDateTimePicker;
    ShipNameEdit: TEdit;
    ClassEdit: TEdit;
    ShipOwnerEdit: TEdit;
    IMONoEdit: TEdit;
    ShipTypeEdit: TEdit;
    ShipBuilderEdit: TEdit;
    JvLabel2: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel12: TJvLabel;
    TechManagerEdit: TEdit;
    BuyCompanyEdit: TEdit;
    TechManagerCountryEdit: TEdit;
    BuyCompanyCountryEdit: TEdit;
    JvLabel9: TJvLabel;
    SpecialDueDatePicker: TDateTimePicker;
    JvLabel11: TJvLabel;
    DockDueDatePicker: TDateTimePicker;
    JvLabel13: TJvLabel;
    JvLabel14: TJvLabel;
    OperatorEdit: TEdit;
    OperatorCountryEdit: TEdit;
    JvLabel16: TJvLabel;
    UpdatedDatePicker: TDateTimePicker;
    InstalledProductGrp: TAdvOfficeCheckGroup;
    VesselStatusCB: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
    procedure SetInstalledProductGrp(AShipProductTypes: TShipProductTypes);
    function GetInstalledProductFromCheckBox(): TShipProductTypes;
  public
    procedure LoadVesselInfo2FormFromVesselMaster(ASQLVesselMaster: TSQLVesselMaster);
    procedure LoadVesselInfo2VesselMasterFromForm(ASQLVesselMaster: TSQLVesselMaster);
  end;

function CreateVesselInfoEditFormFromDB(AImoNo, AHullNo, AShipName: string): integer;

var
  EditVesselInfoF: TEditVesselInfoF;

implementation

{$R *.dfm}

function CreateVesselInfoEditFormFromDB(AImoNo, AHullNo, AShipName: string): integer;
var
  LEditVesselInfoF: TEditVesselInfoF;
  LSQLVesselMaster: TSQLVesselMaster;
begin
  if AImoNo <> '' then
    LSQLVesselMaster := GetVesselMasterFromIMONo(AImoNo)
  else
  if AHullNo <> '' then
    LSQLVesselMaster := GetVesselMasterFromHullNo(AHullNo)
  else
  if AShipName <> '' then
    LSQLVesselMaster := GetVesselMasterFromShipName(AShipName);

  if LSQLVesselMaster.IsUpdate then
  begin
    LEditVesselInfoF := TEditVesselInfoF.Create(nil);
    try
//      LHiMAPSelectF.FIMONo := AImoNo;
//      LHiMAPSelectF.FHullNo := AHullNo;
//      LHiMAPSelectF.FShipName := AShipName;
//
//      LHiMAPSelectF.DoSearchHiMAPFromIMONo(AImoNo);
      LEditVesselInfoF.LoadVesselInfo2FormFromVesselMaster(LSQLVesselMaster);
      Result := LEditVesselInfoF.ShowModal;

      if Result = mrOK then
      begin
        LEditVesselInfoF.LoadVesselInfo2VesselMasterFromForm(LSQLVesselMaster);
        AddOrUpdateVesselMaster(LSQLVesselMaster);
        ShowMessage('Saved OK!');;
      end;
    finally
      LEditVesselInfoF.Free;
    end;
  end
  else
  begin
//    if CreateHiMAPDetailForm(AImoNo, AHullNo, AShipName, 0, 0, 0) = mrOK then
//    begin
//        ShowMessage('mroooooooooooooooOK!');;
//    end;
  end;
end;

{ TEditVesselInfoF }

procedure TEditVesselInfoF.FormCreate(Sender: TObject);
begin
  ShipProductType2List(InstalledProductGrp.Items);
  g_VesselStatus.SetType2Combo(VesselStatusCB);
end;

function TEditVesselInfoF.GetInstalledProductFromCheckBox: TShipProductTypes;
var
  i: integer;
begin
  Result := [];

  for i := 0 to InstalledProductGrp.Items.Count - 1 do
  begin
    if InstalledProductGrp.Checked[i] then
      Result := Result + [TShipProductType(i+1)];
  end;
end;

procedure TEditVesselInfoF.LoadVesselInfo2FormFromVesselMaster(
  ASQLVesselMaster: TSQLVesselMaster);
begin
  with ASQLVesselMaster do
  begin
    HullNoEdit.Text := HullNo;
    ShipNameEdit.Text := ShipName;
    IMONoEdit.Text := IMONo;
    ShipBuilderEdit.Text := ShipBuilderName;
    ClassEdit.Text := SClass1;
    ShipTypeEdit.Text := ShipType;
    ShipTypeDescEdit.Text := ShipTypeDesc;
    ShipOwnerEdit.Text := GroupOwnerName;
    TechManagerCountryEdit.Text := TechManagerCountry;
    TechManagerEdit.Text := TechManagerName;
    OperatorEdit.Text := OperatorName;
    OperatorCountryEdit.Text := OperatorCountry;
    BuyCompanyCountryEdit.Text := BuyingCompanyCountry;
    BuyCompanyEdit.Text := BuyingCompanyName;
    VesselStatusCB.ItemIndex := g_VesselStatus.ToOrdinal(VesselStatus);

    DeliveryDatePicker.Date := TimeLogToDateTime(DeliveryDate);
    LastDockDatePicker.Date := TimeLogToDateTime(LastDryDockDate);
    SpecialDueDatePicker.Date := TimeLogToDateTime(SpecialSurveyDueDate);
    DockDueDatePicker.Date := TimeLogToDateTime(DockingSurveyDueDate);
    UpdatedDatePicker.Date := TimeLogToDateTime(UpdatedDate);

    SetInstalledProductGrp(InstalledProductTypes);
  end;
end;

procedure TEditVesselInfoF.LoadVesselInfo2VesselMasterFromForm(
  ASQLVesselMaster: TSQLVesselMaster);
begin
  with ASQLVesselMaster do
  begin
    HullNo := HullNoEdit.Text;
    ShipName := ShipNameEdit.Text;
    IMONo := IMONoEdit.Text;
    ShipBuilderName := ShipBuilderEdit.Text;
    SClass1 := ClassEdit.Text;
    ShipType := ShipTypeEdit.Text;
    ShipTypeDesc := ShipTypeDescEdit.Text;
    GroupOwnerName := ShipOwnerEdit.Text;
    TechManagerCountry := TechManagerCountryEdit.Text;
    TechManagerName := TechManagerEdit.Text;
    OperatorName := OperatorEdit.Text;
    OperatorCountry := OperatorCountryEdit.Text;
    BuyingCompanyCountry := BuyCompanyCountryEdit.Text;
    BuyingCompanyName := BuyCompanyEdit.Text;
    VesselStatus := VesselStatusCB.Text;

    DeliveryDate := TimeLogFromDateTime(DeliveryDatePicker.Date);
    LastDryDockDate := TimeLogFromDateTime(LastDockDatePicker.Date);
    SpecialSurveyDueDate := TimeLogFromDateTime(SpecialDueDatePicker.Date);
    DockingSurveyDueDate := TimeLogFromDateTime(DockDueDatePicker.Date);
    UpdatedDate := TimeLogFromDateTime(now);
    InstalledProductTypes := GetInstalledProductFromCheckBox;
  end;
end;

procedure TEditVesselInfoF.SetInstalledProductGrp(
  AShipProductTypes: TShipProductTypes);
var Li: TShipProductType;
begin
  for Li := Succ(Low(TShipProductType)) to Pred(High(TShipProductType)) do
  begin
    InstalledProductGrp.Checked[Ord(Li)-1] := Li in AShipProductTypes;
  end;
end;

end.
