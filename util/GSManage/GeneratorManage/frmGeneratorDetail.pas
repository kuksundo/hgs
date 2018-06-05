unit frmGeneratorDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, AeroButtons,
  Vcl.ImgList, Vcl.ComCtrls, JvExControls, JvLabel, UnitHiMAPData, mORMot,
  UnitComboBoxUtil, UnitVesselMasterRecord, UnitHiMAPRecord, SynCommons, NxEdit,
  Vcl.Buttons, NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvGlowButton, DropSource, DragDrop, DropTarget,
  AdvOfficePager, UnitGSFileRecord, AdvToolBtn, AdvGroupBox, AdvOfficeButtons,
  AdvSmoothPanel, AdvSmoothExpanderPanel, FrameGSFileList;

type
  TGeneratorDetailF = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    ImageList16x16: TImageList;
    Imglist16x16: TImageList;
    AddButton: TAeroButton;
    btn_Close: TAeroButton;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    JvLabel15: TJvLabel;
    JvLabel19: TJvLabel;
    SerialNoEdit: TEdit;
    AdvOfficePage1: TAdvOfficePage;
    Panel5: TPanel;
    AdvOfficeCheckGroup1: TAdvOfficeCheckGroup;
    AdvOfficeCheckGroup2: TAdvOfficeCheckGroup;
    AdvOfficeCheckGroup3: TAdvOfficeCheckGroup;
    GeneralPanel: TAdvSmoothExpanderPanel;
    JvLabel25: TJvLabel;
    JvLabel28: TJvLabel;
    JvLabel29: TJvLabel;
    JvLabel32: TJvLabel;
    JvLabel33: TJvLabel;
    JvLabel34: TJvLabel;
    JvLabel35: TJvLabel;
    JvLabel36: TJvLabel;
    JvLabel37: TJvLabel;
    JvLabel38: TJvLabel;
    JvLabel39: TJvLabel;
    JvLabel40: TJvLabel;
    SpecPanel: TAdvSmoothExpanderPanel;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel41: TJvLabel;
    JvLabel42: TJvLabel;
    JvLabel43: TJvLabel;
    JvLabel44: TJvLabel;
    JvLabel45: TJvLabel;
    JvLabel46: TJvLabel;
    BearingPanel: TAdvSmoothExpanderPanel;
    JvLabel2: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel9: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel11: TJvLabel;
    GSFileListFrame: TGSFileListFrame;
    JvLabel20: TJvLabel;
    JvLabel21: TJvLabel;
    JvLabel22: TJvLabel;
    JvLabel23: TJvLabel;
    JvLabel24: TJvLabel;
    JvLabel26: TJvLabel;
    JvLabel47: TJvLabel;
    JvLabel48: TJvLabel;
    GenUseEdit: TEdit;
    EnclosureTypeEdit: TEdit;
    CoolingSystemEdit: TEdit;
    ExcitingSystemEdit: TEdit;
    StructureOfRotorEdit: TEdit;
    CouplingMethodEdit: TEdit;
    QuantyPerShipEdit: TEdit;
    ClassSocietyEdit: TEdit;
    AmbientTempEdit: TEdit;
    InsulationClassEdit: TEdit;
    TemperatureRiseEdit: TEdit;
    AppliedUnitEdit: TEdit;
    GenTypeEdit: TEdit;
    OutputCapacityEdit: TEdit;
    RatingEdit: TEdit;
    PhaseWireConnEdit: TEdit;
    VoltageEdit: TEdit;
    CurrentEdit: TEdit;
    PowerFactorEdit: TEdit;
    GDSquareJuleEdit: TEdit;
    RotorWeightEdit: TEdit;
    TotalWeightEdit: TEdit;
    TotalEfficiencyEdit: TEdit;
    VariationOfGenVoltageEdit: TEdit;
    FrequencyEdit: TEdit;
    PoleEdit: TEdit;
    SpeedEdit: TEdit;
    ExcitingVoltageEdit: TEdit;
    ExcitingCurrentEdit: TEdit;
    MountingMethodEdit: TEdit;
    DSWindingTempEdit: TEdit;
    BearingTypeEdit: TEdit;
    BearingLocationEdit: TEdit;
    BearingSizeEdit: TEdit;
    BearingOilQuantityEdit: TEdit;
    BearingLubSystemEdit: TEdit;
    BearingOilGradeEdit: TEdit;
    DSBearingTempEdit: TEdit;
    UpdateButton: TAeroButton;
    ModelNoEdit: TNxButtonEdit;
    JvLabel12: TJvLabel;
    JvLabel13: TJvLabel;
    ProjectNameEdit: TEdit;
    ProjectNoEdit: TEdit;
    JvLabel14: TJvLabel;
    SpecDescEdit: TEdit;
    procedure GeneralPanelEndExpandPanel(Sender: TObject);
    procedure SpecPanelEndExpandPanel(Sender: TObject);
  private
  public
    procedure LoadGeneratorDetailFromForm2Variant(var ADoc: Variant);
  end;

const
  SPEC_PANEL_TOP = 90;
  BEARING_PANEL_TOP = 130;

function CreateGeneratorDetail(ATaskID: TID): integer;

var
  GeneratorDetailF: TGeneratorDetailF;

implementation

uses WinApi.ShellApi, UnitMSBDData, UnitStringUtil, FrmFileSelect,
  DragDropFile, UnitDragUtil, UnitVariantFormUtil, UnitGeneratorRecord;

{$R *.dfm}

function CreateGeneratorDetail(ATaskID: TID): integer;
var
  LGeneratorDetailF: TGeneratorDetailF;
  LIDList4GSFile: TIDList4GSFile;
  LIsUpdate: Boolean;
  LDoc, LDoc2: variant;
begin
  LGeneratorDetailF := TGeneratorDetailF.Create(nil);
  LIDList4GSFile := TIDList4GSFile.Create;
  try
    with LGeneratorDetailF do
    begin
      GSFileListFrame.ApplyButton.Visible := False;
      TDocVariant.New(LDoc);
      LIsUpdate := LoadGeneratorFromDB2Variant(ATaskID, LDoc);
      LoadVariant2Form(LDoc, LGeneratorDetailF);

      GSFileListFrame.FGSFiles_ := GetGSFilesFromID(ATaskID);
      LIDList4GSFile.fTaskId := ATaskID;
      GSFileListFrame.LoadFiles2Grid(LIDList4GSFile);
      UpdateButton.Visible := LIsUpdate;

      Result :=  ShowModal;

      if Result = mrOK then  //Add
      begin
        LIsUpdate := False;
      end
      else
      if Result = mrIgnore then  //Update
      begin
        LIsUpdate := True;
      end;

      if (Result = mrOK) or (Result = mrIgnore) then
      begin
        TDocVariant.New(LDoc2);
        LDoc2.TaskID := ATaskID;
        LoadGeneratorDetailFromForm2Variant(LDoc2);
        AddGeneratorFromVariant(LDoc2, LIsUpdate);
        AddOrUpdateGSFiles(GSFileListFrame.FGSFiles_);
      end;
    end;
  finally
    LIDList4GSFile.Free;
    LGeneratorDetailF.Free;
  end;
end;

procedure TGeneratorDetailF.GeneralPanelEndExpandPanel(Sender: TObject);
begin
  SpecPanel.Top := SpecPanel.Top + GeneralPanel.Height;
  BearingPanel.Top := BearingPanel.Top + GeneralPanel.Height;
end;

procedure TGeneratorDetailF.LoadGeneratorDetailFromForm2Variant(
  var ADoc: Variant);
begin
  LoadVariantFromForm(TForm(Self), ADoc);
end;

procedure TGeneratorDetailF.SpecPanelEndExpandPanel(Sender: TObject);
begin
  BearingPanel.Top := BearingPanel.Top + SpecPanel.Height;
end;

end.
