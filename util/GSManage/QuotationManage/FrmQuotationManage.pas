unit FrmQuotationManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, SBPro, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  AdvOfficeTabSet, Vcl.ExtCtrls, Vcl.StdCtrls, AeroButtons, Vcl.ComCtrls,
  AdvGroupBox, AdvOfficeButtons, JvExControls, JvLabel, CurvyControls,
  Vcl.ImgList, UnitHimsenWearingSpareMarineRecord, UnitHimsenWearingSpareStationaryRecord,
  UnitHimsenWearingSparePropulsionRecord,
  AdvSmoothSplashScreen, UnitQuotationManageCommandLineClass, GpCommandLineParser,
  CommonData;

type
  THimsenWearSpareQF = class(TForm)
    MainMenu1: TMainMenu;
    ImportWearingSpareFromXls1: TMenuItem;
    Close1: TMenuItem;
    ImportWearingSpareMFromXls2: TMenuItem;
    N1: TMenuItem;
    OpenDialog1: TOpenDialog;
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel9: TJvLabel;
    Panel1: TPanel;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    AeroButton1: TAeroButton;
    Splitter1: TSplitter;
    TaskTab: TAdvOfficeTabSet;
    WearingPartGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    HullNo: TNxTextColumn;
    ShipName: TNxTextColumn;
    ImoNo: TNxTextColumn;
    MSDesc: TNxTextColumn;
    PartDesc: TNxTextColumn;
    PlateNo: TNxTextColumn;
    DrawingNo: TNxTextColumn;
    MaterialNo: TNxTextColumn;
    PartNo: TNxTextColumn;
    StatusBarPro1: TStatusBarPro;
    EngTypeCB: TComboBox;
    TCModelCB: TComboBox;
    RunHourCB: TComboBox;
    JvLabel1: TJvLabel;
    SectionNo: TNxTextColumn;
    UsedAmount: TNxTextColumn;
    CalcFormula: TNxTextColumn;
    SpareAmount: TNxTextColumn;
    PartUnit: TNxTextColumn;
    Amount: TNxTextColumn;
    TCModel: TNxTextColumn;
    DB1: TMenuItem;
    DeleteEngine1: TMenuItem;
    SplashScreen1: TAdvSmoothSplashScreen;
    JvLabel3: TJvLabel;
    RatedRPMEdit: TEdit;
    TierRG: TAdvOfficeRadioGroup;
    UsageRG: TAdvOfficeRadioGroup;
    EngineModelEdit: TEdit;
    CylCountEdit: TEdit;
    JvLabel4: TJvLabel;
    MainBearingMakerCB: TComboBox;
    RetrofitCheck: TCheckBox;
    PORIssue: TNxCheckBoxColumn;
    GovernorCB: TComboBox;
    JvLabel8: TJvLabel;
    HullNoEdit: TEdit;
    PORCheck: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImportWearingSpareMFromXls2Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure RunHourCBDropDown(Sender: TObject);
    procedure DeleteEngine1Click(Sender: TObject);
    procedure EngTypeCBDropDown(Sender: TObject);
    procedure EngTypeCBSelect(Sender: TObject);
    procedure TCModelCBDropDown(Sender: TObject);
    procedure MainBearingMakerCBDropDown(Sender: TObject);
  private
    FCommandLine: TQuotationManageParameter;

    function CommandLineParse(var AErrMsg: string): boolean;
    function GetEngTypeFromModel(AEngineModel: string; AAdapt: string=''): string;

    procedure GetHimsenWearingSpare2Grid;
    procedure GetHimsenWearingSpareM2Grid;
    procedure GetHimsenWearingSpareS2Grid;

    procedure GetHimsenWearingSpareMParam2Rec(var AHimsenWearingSpareParamRec: THimsenWearingSpareMRec);
    procedure GetHimsenWearingSpareSParam2Rec(var AHimsenWearingSpareParamRec: THimsenWearingSpareSRec);
    procedure GetHimsenWearingSpareFromVariant2Grid(ADoc: Variant);
    function GetCalcSparePartAmount(ADoc: Variant): string;

    procedure ExecuteSearch(Key: Char);
    procedure MakeHimsenWearPartQuotation();
    procedure FillInEngineTypeCombo;
    procedure FillInUsageRG(AUsage: string);
    procedure FillInTierRG(ATier: string);

    procedure ClearOption4DeleteDB;
  public
    FRunHourList: TStringList;
  end;

const
  HIMSEN_WEAR_PART_QUOTATION_FILE = 'Spare_part_list.xlsx';

var
  HimsenWearSpareQF: THimsenWearSpareQF;

implementation

uses UnitMakeHimsenWaringSpareDB, UnitExcelUtil, UnitStringUtil,
  UnitEngineMasterData, UnitEnumHelper;

{$R *.dfm}

procedure THimsenWearSpareQF.AeroButton1Click(Sender: TObject);
begin
  MakeHimsenWearPartQuotation;
end;

procedure THimsenWearSpareQF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure THimsenWearSpareQF.btn_SearchClick(Sender: TObject);
begin
  GetHimsenWearingSpare2Grid;
end;

procedure THimsenWearSpareQF.ClearOption4DeleteDB;
begin
  TCModelCB.ItemIndex := -1;
  RunHourCB.ItemIndex := -1;
  MainBearingMakerCB.ItemIndex := -1;
  CylCountEdit.Text := '';
  RatedRPMEdit.Text := '';
  HullNoEdit.Text := '';
end;

procedure THimsenWearSpareQF.Close1Click(Sender: TObject);
begin
  Close;
end;

function THimsenWearSpareQF.CommandLineParse(var AErrMsg: string): boolean;
var
  LStr: string;
begin
  AErrMsg := '';

  try
    CommandLineParser.Options := [opIgnoreUnknownSwitches];
    Result := CommandLineParser.Parse(FCommandLine);
  except
    on E: ECLPConfigurationError do begin
      AErrMsg := '*** Configuration error ***' + #13#10 +
        Format('%s, position = %d, name = %s',
          [E.ErrorInfo.Text, E.ErrorInfo.Position, E.ErrorInfo.SwitchName]);
      Exit;
    end;
  end;

  if not Result then
  begin
    AErrMsg := Format('%s, position = %d, name = %s',
      [CommandLineParser.ErrorInfo.Text, CommandLineParser.ErrorInfo.Position,
       CommandLineParser.ErrorInfo.SwitchName]) + #13#10;
    for LStr in CommandLineParser.Usage do
      AErrMsg := AErrMSg + LStr + #13#10;
  end
  else
  begin
  end;
end;

procedure THimsenWearSpareQF.DeleteEngine1Click(Sender: TObject);
var
  LHimsenWearingSpareParamMRec: THimsenWearingSpareMRec;
  LHimsenWearingSpareParamSRec: THimsenWearingSpareSRec;
  LHimsenWearingSparePRec: THimsenWearingSparePRec;
begin
  if EngTypeCB.ItemIndex = -1 then
    ShowMessage('Select Engine Type first for delete')
  else
  begin
    if MessageDlg('Are you sure to delete the engine type(' + EngTypeCB.Text +')', mtConfirmation, [mbYes, mbNo],0) = mrNo then
      exit;

    ClearOption4DeleteDB;

    if TEngineUsage(UsageRG.ItemIndex+1) = euMarine then
    begin
      SplashScreen1.BasicProgramInfo.ProgramVersion.Text := 'Delete Data from QuotationManage_M.sqlite!';
      SplashScreen1.Show;
      try
        GetHimsenWearingSpareMParam2Rec(LHimsenWearingSpareParamMRec);
        DeleteEngineTypeMFromSearchRec(LHimsenWearingSpareParamMRec);
      finally
        SplashScreen1.Hide;
      end;
    end
    else
    if TEngineUsage(UsageRG.ItemIndex+1) = euStatinoary then
    begin
      SplashScreen1.BasicProgramInfo.ProgramVersion.Text := 'Delete Data from QuotationManage_S.sqlite!';
      SplashScreen1.Show;
      try
        GetHimsenWearingSpareSParam2Rec(LHimsenWearingSpareParamSRec);
        DeleteEngineTypeSFromSearchRec(LHimsenWearingSpareParamSRec);
      finally
        SplashScreen1.Hide;
      end;
    end
    else
    if TEngineUsage(UsageRG.ItemIndex+1) = euPropulsion then
    begin
      SplashScreen1.BasicProgramInfo.ProgramVersion.Text := 'Delete Data from QuotationManage_P.sqlite!';
      SplashScreen1.Show;
      try
        GetHimsenWearingSparePFromSearchRec(LHimsenWearingSparePRec);
        DeleteEngineTypePFromSearchRec(LHimsenWearingSparePRec);
      finally
        SplashScreen1.Hide;
      end;
    end;
  end;
end;

procedure THimsenWearSpareQF.EngTypeCBDropDown(Sender: TObject);
begin
  FillinEngineTypeCombo;
end;

procedure THimsenWearSpareQF.EngTypeCBSelect(Sender: TObject);
var
  LUsage: string;
begin
  if TTierStep(TierRG.ItemIndex+1) = tsTierI then
  begin
    LUsage := GetEngineUsageChar(UsageRG.ItemIndex + 1);
    EngineModelEdit.Text := GetEngTypeFromModel(EngTypeCB.Text, LUsage);
  end
  else
    EngineModelEdit.Text := EngTypeCB.Text;
end;

procedure THimsenWearSpareQF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    btn_SearchClick(nil);
end;

procedure THimsenWearSpareQF.FillInEngineTypeCombo;
//var
//  g_EngineTier1: TLabelledEnum<TEngineModel_TierI>;
//  g_EngineTier2: TLabelledEnum<TEngineModel_TierII>;
//  g_EngineTier3: TLabelledEnum<TEngineModel_TierIII>;
begin
//  EngTypeCB.Clear;

  case TierRG.ItemIndex of
    0: begin
//      g_EngineTier1.InitArrayRecord(R_EngineModel_TierI);
      g_EngineTier1.SetType2Combo(EngTypeCB);
    end;
    1: begin
//      g_EngineTier2.InitArrayRecord(R_EngineModel_TierII);
      g_EngineTier2.SetType2Combo(EngTypeCB);
    end;
    2: begin
//      g_EngineTier3.InitArrayRecord(R_EngineModel_TierIII);
      g_EngineTier3.SetType2Combo(EngTypeCB);
    end;
  end;
end;

procedure THimsenWearSpareQF.FillInTierRG(ATier: string);
var
  i:integer;
begin
  i := StrToIntDef(ATier, 0);
  TierRG.ItemIndex := i-1;
end;

procedure THimsenWearSpareQF.FillInUsageRG(AUsage: string);
begin
  if AUsage = 'M' then
    UsageRG.ItemIndex := 0
  else
  if AUsage = 'S' then
    UsageRG.ItemIndex := 1
  else
  if AUsage = 'P' then
    UsageRG.ItemIndex := 2
end;

procedure THimsenWearSpareQF.FormCreate(Sender: TObject);
var
  LMsg, LEngType: string;
  LIdx: integer;
begin
  InitHimsenWearingSpareMClient(Application.ExeName);
  InitHimsenWearingSpareSClient(Application.ExeName);
  InitHimsenWearingSparePClient(Application.ExeName);
  FRunHourList := TStringList.Create;
  FCommandLine := TQuotationManageParameter.Create;
  CommandLineParse(LMsg);

  if FCommandLine.EngineModel <> '' then
  begin
    FillInUsageRG(FCommandLine.Adapt);
    FillInTierRG(FCommandLine.Tier);
    FillInEngineTypeCombo;
    EngineModelEdit.Text := GetEngTypeFromModel(FCommandLine.EngineModel, FCommandLine.Adapt);
    LEngType := FCommandLine.EngineModel;
    strToken(LEngType, 'H');
    LEngType := 'H' + StringReplace(LEngType, 'V', '(V)', [rfReplaceAll]);
    LIdx := EngTypeCB.Items.IndexOf(LEngType);
    EngTypeCB.ItemIndex := LIdx;
    CylCountEdit.Text := FCommandLine.CylCount;
    LMsg := FCommandLine.TCModel;
    LIdx := TCModelCB.Items.IndexOf(LMsg);
    RunHourCBDropDown(nil);
    LMsg := FCommandLine.RunHour;
    LIdx := RunHourCB.Items.IndexOf(LMsg);

    btn_SearchClick(nil);
  end;
end;

procedure THimsenWearSpareQF.FormDestroy(Sender: TObject);
begin
  FCommandLine.Free;
  FRunHourList.Free;
end;

function THimsenWearSpareQF.GetCalcSparePartAmount(ADoc: Variant): string;
var
  LRunHour, LFormula: string;
  LCylCount, LUsedAmount, LSpareAmount, LCalcNo, LResult: integer;
  LUseTC: boolean;
begin
  LRunHour := RunHourCB.Text;
  LCylCount := StrToIntDef(CylCountEdit.Text, 0);

  if TEngineUsage(UsageRG.ItemIndex+1) = euMarine then
  begin
    if RetrofitCheck.Checked then
    begin
      LCalcNo := StrToIntDef(ADoc.RetrofitApplyNo,0);
      LFormula := ADoc.RetrofitFormula;
    end
    else
    if LRunHour = '4000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS4000ApplyNo,0);
      LFormula := ADoc.HRS4000Formula;
    end
    else
    if LRunHour = '8000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS8000ApplyNo,0);
      LFormula := ADoc.HRS8000Formula;
    end
    else
    if LRunHour = '12000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS12000ApplyNo,0);
      LFormula := ADoc.HRS12000Formula;
    end
    else
    if LRunHour = '16000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS16000ApplyNo,0);
      LFormula := ADoc.HRS16000Formula;
    end
    else
    if LRunHour = '20000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS20000ApplyNo,0);
      LFormula := ADoc.HRS20000Formula;
    end
    else
    if LRunHour = '24000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS24000ApplyNo,0);
      LFormula := ADoc.HRS24000Formula;
    end
    else
    if LRunHour = '28000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS28000ApplyNo,0);
      LFormula := ADoc.HRS28000Formula;
    end
    else
    if LRunHour = '32000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS32000ApplyNo,0);
      LFormula := ADoc.HRS32000Formula;
    end
    else
    if LRunHour = '36000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS36000ApplyNo,0);
      LFormula := ADoc.HRS36000Formula;
    end
    else
    if LRunHour = '40000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS40000ApplyNo,0);
      LFormula := ADoc.HRS40000Formula;
    end
    else
    if LRunHour = '44000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS44000ApplyNo,0);
      LFormula := ADoc.HRS44000Formula;
    end
    else
    if LRunHour = '48000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS48000ApplyNo,0);
      LFormula := ADoc.HRS48000Formula;
    end
    else
    if LRunHour = '60000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS60000ApplyNo,0);
      LFormula := ADoc.HRS60000Formula;
    end
    else
    if LRunHour = '72000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS72000ApplyNo,0);
      LFormula := ADoc.HRS72000Formula;
    end
    else
    if LRunHour = '88000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS88000ApplyNo,0);
      LFormula := ADoc.HRS88000Formula;
    end
    else
    if LRunHour = '100000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS100000ApplyNo,0);
      LFormula := ADoc.HRS100000Formula;
    end
  end
  else
  if TEngineUsage(UsageRG.ItemIndex+1) = euStatinoary then
  begin
    if RetrofitCheck.Checked then
    begin
      LCalcNo := StrToIntDef(ADoc.RetrofitApplyNo,0);
      LFormula := ADoc.RetrofitFormula;
    end
    else
    if LRunHour = '3000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS3000ApplyNo,0);
      LFormula := ADoc.HRS3000Formula;
    end
    else
    if LRunHour = '6000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS6000ApplyNo,0);
      LFormula := ADoc.HRS6000Formula;
    end
    else
    if LRunHour = '9000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS9000ApplyNo,0);
      LFormula := ADoc.HRS9000Formula;
    end
    else
    if LRunHour = '12000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS12000ApplyNo,0);
      LFormula := ADoc.HRS12000Formula;
    end
    else
    if LRunHour = '15000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS15000ApplyNo,0);
      LFormula := ADoc.HRS15000Formula;
    end
    else
    if LRunHour = '18000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS18000ApplyNo,0);
      LFormula := ADoc.HRS18000Formula;
    end
    else
    if LRunHour = '21000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS21000ApplyNo,0);
      LFormula := ADoc.HRS21000Formula;
    end
    else
    if LRunHour = '24000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS24000ApplyNo,0);
      LFormula := ADoc.HRS24000Formula;
    end
    else
    if LRunHour = '27000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS27000ApplyNo,0);
      LFormula := ADoc.HRS27000Formula;
    end
    else
    if LRunHour = '30000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS30000ApplyNo,0);
      LFormula := ADoc.HRS30000Formula;
    end
    else
    if LRunHour = '33000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS33000ApplyNo,0);
      LFormula := ADoc.HRS33000Formula;
    end
    else
    if LRunHour = '36000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS36000ApplyNo,0);
      LFormula := ADoc.HRS36000Formula;
    end
    else
    if LRunHour = '39000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS39000ApplyNo,0);
      LFormula := ADoc.HRS39000Formula;
    end
    else
    if LRunHour = '42000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS42000ApplyNo,0);
      LFormula := ADoc.HRS42000Formula;
    end
    else
    if LRunHour = '45000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS45000ApplyNo,0);
      LFormula := ADoc.HRS45000Formula;
    end
    else
    if LRunHour = '48000' then
    begin
      LCalcNo := StrToIntDef(ADoc.HRS48000ApplyNo,0);
      LFormula := ADoc.HRS48000Formula;
    end
  end;

  LUsedAmount := StrToIntDef(ADoc.UsedAmount,0);
  LSpareAmount := StrToIntDef(ADoc.SpareAmount,0);

  if LFormula = '*' then
  begin
    if LCalcNo = 0 then
      LCalcNo := 1;

    LResult := (LUsedAmount * LCylCount + LSpareAmount) * LCalcNo
  end
  else
  if LFormula = '+' then
    LResult := (LUsedAmount * LCylCount + LSpareAmount) + LCalcNo;

  Result := IntToStr(LResult);
end;

function THimsenWearSpareQF.GetEngTypeFromModel(AEngineModel: string; AAdapt: string): string;
var
  LPos: integer;
begin
  Result := strToken(AEngineModel, '/');
  LPos := Pos('H', Result);
  Result := Copy(Result, LPos, Length(Result)-LPos+1);
  Result := Result + AAdapt;
end;

procedure THimsenWearSpareQF.GetHimsenWearingSpare2Grid;
begin
  if TEngineUsage(UsageRG.ItemIndex+1) = euMarine then
    GetHimsenWearingSpareM2Grid
  else
  if TEngineUsage(UsageRG.ItemIndex+1) = euStatinoary then
    GetHimsenWearingSpareS2Grid
  else
  if TEngineUsage(UsageRG.ItemIndex+1) = euPropulsion then
  begin
    WearingPartGrid.ClearRows;
    ShowMessage('No Data!');
  end;
end;

procedure THimsenWearSpareQF.GetHimsenWearingSpareFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
  LPOR: Boolean;
begin
  LPOR := ADoc.PORIssue = '1';

  if PORCheck.Checked then
    if not LPOR then
      exit;

  LRow := WearingPartGrid.AddRow;

  WearingPartGrid.CellByName['PORIssue', LRow].AsBoolean := LPOR;
  WearingPartGrid.CellsByName['MSDesc', LRow] := ADoc.MSDesc;
  WearingPartGrid.CellsByName['PartNo', LRow] := ADoc.PartNo;
  WearingPartGrid.CellsByName['PartDesc', LRow] := ADoc.PartDesc;
  WearingPartGrid.CellsByName['SectionNo', LRow] := ADoc.SectionNo;
  WearingPartGrid.CellsByName['PlateNo', LRow] := ADoc.PlateNo;
  WearingPartGrid.CellsByName['DrawingNo', LRow] := ADoc.DrawingNo;
  WearingPartGrid.CellsByName['SpareAmount', LRow] := ADoc.SpareAmount;
  WearingPartGrid.CellsByName['UsedAmount', LRow] := ADoc.UsedAmount;
//  WearingPartGrid.CellsByName['CalcFormula', LRow] := ADoc.CalcFormula;
  WearingPartGrid.CellsByName['PartUnit', LRow] := ADoc.PartUnit;

  WearingPartGrid.CellsByName['Amount', LRow] := GetCalcSparePartAmount(ADoc);
end;

procedure THimsenWearSpareQF.GetHimsenWearingSpareM2Grid;
var
  LSQLHimsenWearingSpareMaster: TSQLHimsenWearingSpareMarine;
  LHimsenWearingSpareParamRec: THimsenWearingSpareMRec;
  LDoc: Variant;
begin
  WearingPartGrid.BeginUpdate;
  try
    WearingPartGrid.ClearRows;
    GetHimsenWearingSpareMParam2Rec(LHimsenWearingSpareParamRec);
    LSQLHimsenWearingSpareMaster := GetHimsenWaringSpareMFromSearchRec(LHimsenWearingSpareParamRec);

    if LSQLHimsenWearingSpareMaster.IsUpdate then
    begin
      LSQLHimsenWearingSpareMaster.FillRewind;
//      LDoc := GetVariantFromHimsenWearingSpareM(LSQLHimsenWearingSpareMaster);
//      GetHimsenWearingSpareFromVariant2Grid(LDoc);

      while LSQLHimsenWearingSpareMaster.FillOne do
      begin
        LDoc := GetVariantFromHimsenWearingSpareM(LSQLHimsenWearingSpareMaster);
        GetHimsenWearingSpareFromVariant2Grid(LDoc);
      end;//while
    end;
  finally
    WearingPartGrid.EndUpdate;
  end;
end;

procedure THimsenWearSpareQF.GetHimsenWearingSpareMParam2Rec(
  var AHimsenWearingSpareParamRec: THimsenWearingSpareMRec);
begin
  AHimsenWearingSpareParamRec.fTierStep := TierRG.ItemIndex + 1;
  AHimsenWearingSpareParamRec.fHullNo := HullNoEdit.Text;
  AHimsenWearingSpareParamRec.fEngineType := EngineModelEdit.Text;
  AHimsenWearingSpareParamRec.fTCModel := TCModelCB.Text;
  AHimsenWearingSpareParamRec.fRunningHour := RunHourCB.Text;
  AHimsenWearingSpareParamRec.fCylCount := CylCountEdit.Text;
  AHimsenWearingSpareParamRec.fRatedRPM := RatedRPMEdit.Text;
  AHimsenWearingSpareParamRec.fMainBearingMaker := MainBearingMakerCB.Text;
  AHimsenWearingSpareParamRec.fGovernorType := GovernorCB.Text;
//  AHimsenWearingSpareParamRec.fFuelKind := MainBearingMakerCB.Text;
  AHimsenWearingSpareParamRec.fPORIssue := PORCheck.Checked;
  AHimsenWearingSpareParamRec.fRetrofit := RetrofitCheck.Checked;
end;

procedure THimsenWearSpareQF.GetHimsenWearingSpareS2Grid;
var
  LSQLHimsenWearingSpareMaster: TSQLHimsenWearingSpareStationary;
  LHimsenWearingSpareParamRec: THimsenWearingSpareSRec;
  LDoc: Variant;
begin
  WearingPartGrid.BeginUpdate;
  try
    WearingPartGrid.ClearRows;
    GetHimsenWearingSpareSParam2Rec(LHimsenWearingSpareParamRec);
    LSQLHimsenWearingSpareMaster := GetHimsenWaringSpareSFromSearchRec(LHimsenWearingSpareParamRec);

    if LSQLHimsenWearingSpareMaster.IsUpdate then
    begin
      LSQLHimsenWearingSpareMaster.FillRewind;
//      LDoc := GetVariantFromHimsenWearingSpareS(LSQLHimsenWearingSpareMaster);
//      GetHimsenWearingSpareFromVariant2Grid(LDoc);

      while LSQLHimsenWearingSpareMaster.FillOne do
      begin
        LDoc := GetVariantFromHimsenWearingSpareS(LSQLHimsenWearingSpareMaster);
        GetHimsenWearingSpareFromVariant2Grid(LDoc);
      end;//while
    end;
  finally
    WearingPartGrid.EndUpdate;
  end;
end;

procedure THimsenWearSpareQF.GetHimsenWearingSpareSParam2Rec(
  var AHimsenWearingSpareParamRec: THimsenWearingSpareSRec);
begin
  AHimsenWearingSpareParamRec.fTierStep := TierRG.ItemIndex + 1;
  AHimsenWearingSpareParamRec.fHullNo := HullNoEdit.Text;
  AHimsenWearingSpareParamRec.fEngineType := EngTypeCB.Text;
  AHimsenWearingSpareParamRec.fTCModel := TCModelCB.Text;
  AHimsenWearingSpareParamRec.fRunningHour := RunHourCB.Text;
  AHimsenWearingSpareParamRec.fCylCount := CylCountEdit.Text;
  AHimsenWearingSpareParamRec.fRatedRPM := RatedRPMEdit.Text;
  AHimsenWearingSpareParamRec.fMainBearingMaker := MainBearingMakerCB.Text;
end;

procedure THimsenWearSpareQF.ImportWearingSpareMFromXls2Click(Sender: TObject);
var
  LHimsenWearingSpareParamRec: THimsenWearingSpareMRec;
  LEngineType: string;
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
//      SplashScreen1.BeginUpdate;
//      SplashScreen1.BasicProgramInfo.ProgramVersion.Text := 'Importing Data from xls...';
//      SplashScreen1.EndUpdate;
//      SplashScreen1.Show;
      try
//        GetHimsenWearingSpareMParam2Rec(LHimsenWearingSpareParamRec);
        if TTierStep(TierRG.ItemIndex+1) = tsTierI then
          LEngineType := EngineModelEdit.Text
        else
        if TTierStep(TierRG.ItemIndex+1) = tsTierII then
          LEngineType := EngineModelEdit.Text
        else
        if TTierStep(TierRG.ItemIndex+1) = tsTierIII then
          LEngineType := EngineModelEdit.Text;

        if TEngineUsage(UsageRG.ItemIndex+1) = euMarine then
        begin
//          if TTierStep(TierRG.ItemIndex+1) = tsTierIII then
            ImportHimsenWearingSpareFromXlsFile(OpenDialog1.FileName, LEngineType, TierRG.ItemIndex+1, Ord(euMarine));
//          else
//            ImportHimsenWearingSpareMFromXlsFile(OpenDialog1.FileName, LEngineType, TierRG.ItemIndex+1);
        end
        else
        if TEngineUsage(UsageRG.ItemIndex+1) = euStatinoary then
          ImportHimsenWearingSpareSFromXlsFile(OpenDialog1.FileName, LEngineType, TierRG.ItemIndex+1);
//        else
//        if TEngineUsage(UsageRG.ItemIndex+1) = euPropulsion then

        GetHimsenWearingSpare2Grid;
      finally
//        SplashScreen1.Hide;
      end;
    end;
  end;
end;

procedure THimsenWearSpareQF.MainBearingMakerCBDropDown(Sender: TObject);
begin
  g_MainBearingMaker.SetType2Combo(MainBearingMakerCB)
end;

procedure THimsenWearSpareQF.MakeHimsenWearPartQuotation;
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LFileName, LStr, LMSDesc: string;
  LRangeStr,
  LMSRange, LPareDescRange: OleVariant;
  LGRow, LERow: integer;
begin
  LFileName := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+HIMSEN_WEAR_PART_QUOTATION_FILE;

  if not FileExists(LFileName) then
  begin
    ShowMessage('File(' + LFileName + ')이 존재하지 않습니다');
    exit;
  end;

  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(LFileName);
  LWorksheet := LExcel.ActiveSheet;
  LExcel.Visible := False;
  LERow := 4;
  LMSRange := 'A'+ IntToStr(LERow) + ':I' + IntToStr(LERow);
  LPareDescRange := 'A'+ IntToStr(LERow+1)+ ':I' +  IntToStr(LERow+1);

  LFileName := HullNoEdit.Text + '(' + CylCountEdit.Text + EngTypeCB.Text + ')' +
     RunHourCB.Text + ' Major Overhaul Spares based on Maintenance Schedule';

  LRange := LWorksheet.range['B2'];
  LRange.FormulaR1C1 := LFileName;

  for LGRow := 0 to WearingPartGrid.RowCount - 1 do
  begin
    LMSDesc := WearingPartGrid.CellsByName['MSDesc', LGRow];
//    LMSDesc := strToken(LMSDesc, '(');

    if LStr <> LMSDesc then
    begin
      if LGRow <> 0 then
      begin
        LRange := LWorksheet.range[LMSRange];
        LRange.Copy;
        LRangeStr := 'A' + IntToStr(LERow) + ':I' + IntToStr(LERow);
        LRange := LWorksheet.range[LRangeStr];
        LRange.Insert;
      end;

      LRange := LWorksheet.range['B'+IntToStr(LERow)];
      LRange.FormulaR1C1 := LMSDesc;
      LStr := LMSDesc;
      Inc(LERow);
    end;

    if LGRow <> 0 then
    begin
      LRange := LWorksheet.range[LPareDescRange];
      LRange.Copy;
      LRangeStr := 'A' + IntToStr(LERow) + ':I' + IntToStr(LERow);
      LRange := LWorksheet.range[LRangeStr];
      LRange.Insert;
    end;

    LRange := LWorksheet.range['A'+IntToStr(LERow)];
    LRange.FormulaR1C1 := WearingPartGrid.CellsByName['NxIncrementColumn1', LGRow];

    LRange := LWorksheet.range['C'+IntToStr(LERow)];
    LRange.FormulaR1C1 := WearingPartGrid.CellsByName['PartDesc', LGRow];

    LRange := LWorksheet.range['D'+IntToStr(LERow)];
    LRange.FormulaR1C1 := WearingPartGrid.CellsByName['PlateNo', LGRow];

    LRange := LWorksheet.range['E'+IntToStr(LERow)];
    LRange.FormulaR1C1 := WearingPartGrid.CellsByName['DrawingNo', LGRow];

    LRange := LWorksheet.range['F'+IntToStr(LERow)];
    LRange.FormulaR1C1 := WearingPartGrid.CellsByName['MaterialNo', LGRow];

    LRange := LWorksheet.range['G'+IntToStr(LERow)];
    LRange.FormulaR1C1 := WearingPartGrid.CellsByName['Amount', LGRow];

    LRange := LWorksheet.range['H'+IntToStr(LERow)];
    LRange.FormulaR1C1 := WearingPartGrid.CellsByName['PartUnit', LGRow];

    LRange := LWorksheet.range['I'+IntToStr(LERow)];
    LRange.FormulaR1C1 := WearingPartGrid.CellsByName['PartNo', LGRow];

    Inc(LERow);
  end;

  LExcel.Visible := true;
end;

procedure THimsenWearSpareQF.RunHourCBDropDown(Sender: TObject);
var
  LStrList: TStrings;
begin
  LStrList := RunHourCB.Items;

  if TEngineUsage(UsageRG.ItemIndex+1) = euMarine then
    GetRunHour2List4M(LStrList)
  else
  if TEngineUsage(UsageRG.ItemIndex+1) = euStatinoary then
    GetRunHour2List4S(LStrList);
end;

procedure THimsenWearSpareQF.TCModelCBDropDown(Sender: TObject);
begin
//  TCModelCB.Clear;

  if TTierStep(TierRG.ItemIndex+1) = tsTierI then
    g_TCModelTier1.SetType2Combo(TCModelCB)
  else
  if TTierStep(TierRG.ItemIndex+1) = tsTierII then
    g_TCModelTier2.SetType2Combo(TCModelCB)
  else
  if TTierStep(TierRG.ItemIndex+1) = tsTierIII then
    g_TCModelTier3.SetType2Combo(TCModelCB)
end;

end.
