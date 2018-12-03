unit FrmSimulateParamEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  pjhComboBox, Vcl.Samples.Spin, Vcl.ImgList, AeroButtons, UnitSimulateParamRecord,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid;

type
  TSimulateParamEditF = class(TForm)
    SystemNameCB: TComboBoxInc;
    ProdTypeCB: TComboBox;
    SubSystemNameCB: TComboBoxInc;
    SubjectEdit: TEdit;
    DescEdit: TEdit;
    Panel1: TPanel;
    JsonParamCollectMemo: TMemo;
    CSVValuesMemo: TMemo;
    SeqNoSpinEdit: TSpinEdit;
    CourseLevelCB: TComboBox;
    ActivityLevelCB: TComboBox;
    DelsySecsEdit: TEdit;
    AeroButton1: TAeroButton;
    btn_Close: TAeroButton;
    ImageList16x16: TImageList;
    DFMTextMemo: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ModelNameCB: TComboBoxInc;
    Label14: TLabel;
    ProjectNameCB: TComboBoxInc;
    EnableCheck: TCheckBox;
    ParamGrid: TNextGrid;
    NxIndex: TNxIncrementColumn;
    ItemName: TNxTextColumn;
    Value: TNxButtonColumn;
    TagName: TNxTextColumn;
    procedure FormCreate(Sender: TObject);
    procedure ProdTypeCBChange(Sender: TObject);
  private
  public
    procedure FillInFormFromVariant(ADoc: Variant);
    procedure FillInModelKind;
    procedure FillInSystemKind;
    procedure FillInSubSystemKind;
    procedure FillInParamGrid;
    function GetVariantFromForm: variant;
    function SaveParamDetail2SimPramRecFromForm(var ASimulateParamRecord: TSQLSimulateParamRecord): Boolean;
  end;

function CreateOrShowParamEditFormFromDB(ASimParamSearchRec: TSimParamSearchRec;
  AJsonParamCollect, ACSVData: string): integer;

var
  SimulateParamEditF: TSimulateParamEditF;

implementation

uses SynCommons, UnitVesselData, UnitHGSCurriculumData, UnitFGSSData;

{$R *.dfm}

{ TSimulateParamEditF }

function CreateOrShowParamEditFormFromDB(ASimParamSearchRec: TSimParamSearchRec;
  AJsonParamCollect, ACSVData: string): integer;
var
  LSimulateParamEditF: TSimulateParamEditF;
  LSQLSimulateParamRecord: TSQLSimulateParamRecord;
  LDoc: Variant;
begin
  LSimulateParamEditF := TSimulateParamEditF.Create(nil);
  try
    LSQLSimulateParamRecord := GetSimulateParamRecordFromSearchRec(ASimParamSearchRec);
    try
      LDoc := GetVariantFromSimulateParamRecord(LSQLSimulateParamRecord);

      if (AJsonParamCollect <> '') and (ACSVData <> '') then
      begin
        LDoc.JsonParamCollect := AJsonParamCollect;
        LDoc.CSVValues := ACSVData;
      end;

      LSimulateParamEditF.FillInFormFromVariant(LDoc);

      Result := LSimulateParamEditF.ShowModal;

      if Result = mrOK then
      begin
        LSimulateParamEditF.SaveParamDetail2SimPramRecFromForm(LSQLSimulateParamRecord);
      end;

    finally
      LSQLSimulateParamRecord.Free;
    end;
  finally
    LSimulateParamEditF.Free;
  end;
end;

procedure TSimulateParamEditF.FillInFormFromVariant(ADoc: Variant);
begin
  if ADoc.ProductType > -1 then
    ProdTypeCB.ItemIndex := ADoc.ProductType;

  ModelNameCB.Text := ADoc.ModelName;
  ProjectNameCB.Text := ADoc.ProjectName;
  SystemNameCB.Text := ADoc.SystemName;
  SubSystemNameCB.Text := ADoc.SubSystemName;
  SubjectEdit.Text := ADoc.Subject;
  DescEdit.Text := ADoc.Desc;

  if ADoc.CourseLevel > -1 then
    CourseLevelCB.ItemIndex := ADoc.CourseLevel;

  if ADoc.ActivityLevel > -1 then
    ActivityLevelCB.ItemIndex := ADoc.ActivityLevel;

  SeqNoSpinEdit.Value := ADoc.SeqNo;
  DelsySecsEdit.Text := ADoc.DelaySecs;
  EnableCheck.Checked := ADoc.Enable;

  JsonParamCollectMemo.Text := ADoc.JsonParamCollect;
  CSVValuesMemo.Text := ADoc.CSVValues;
  DFMTextMemo.Text := ADoc.DFMText;

  if (JsonParamCollectMemo.Text <> '') and (CSVValuesMemo.Text <> '') then
    FillInParamGrid;
end;

procedure TSimulateParamEditF.FillInModelKind;
begin
  case TShipProductType(ProdTypeCB.ItemIndex) of
    shptME:;
    shptGE:;
    shptCB:;
    shptTR:;
    shptGEN:;
    shptAMS:;
    shptSWBD:;
    shptMOTOR:;
    shptSCR:;
    shptBWTS:;
    shptFGSS:FGSSModelKind2List(ModelNameCB.Items);
    shptCOPT:;
    shptPROPELLER:;
    shptEGR:;
    shptVDR:;
  end;
end;

procedure TSimulateParamEditF.FillInParamGrid;
var
  LDynUtf8, LCSVDynUtf8: TRawUTF8DynArray;
  LDynArr, LCSVDynArr: TDynArray;
  LUtf8, LCSVUtf8: RawUTF8;
  i, j: integer;
  LDoc: variant;
  LDocData: TDocVariantData;
begin
  ParamGrid.BeginUpdate;
  try
    ParamGrid.ClearRows;

//    LDoc2 := _JSON(JsonParamCollectMemo.Text);
    LUtf8 := JsonParamCollectMemo.Text;//'[{"TagName":"aaaa", "Desc":"Desc1"},{"TagName":"bbbb", "Desc":"Desc2"}]';
    LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);
    LDynArr.LoadFromJSON(PUTF8Char(LUtf8));
    for i := 0 to LDynArr.Count - 1 do
    begin
      ParamGrid.AddRow();
      LDoc := _JSON(LDynUtf8[i]);
//      LDoc.TagName;
      ParamGrid.CellsByName['ItemName', i] := LDoc.Description;
      ParamGrid.CellsByName['TagName', i] := LDoc.TagName;
    end;

    LCSVUtf8 := CSVValuesMemo.Text;
//    LDocData.InitJSON(LCSVUtf8);
    LCSVDynArr.Init(TypeInfo(TRawUTF8DynArray), LCSVDynUtf8);

//    LVar := _JSON(LDocData.Value[i]);
//    LUtf8 := LVar.CSVValues;
    CSVToRawUTF8DynArray(PUTF8Char(LCSVUtf8),LCSVDynUtf8);

    for j := Low(LCSVDynUtf8) to High(LCSVDynUtf8) do
      ParamGrid.CellsByName['Value', j] := LCSVDynUtf8[j];

  finally
    ParamGrid.EndUpdate();
  end;
end;

procedure TSimulateParamEditF.FillInSubSystemKind;
begin

end;

procedure TSimulateParamEditF.FillInSystemKind;
begin

end;

procedure TSimulateParamEditF.FormCreate(Sender: TObject);
begin
  ShipProductType2List(ProdTypeCB.Items);
  AcademyCourseLevel2List(CourseLevelCB.Items);
  AcademyActivityLevel2List(ActivityLevelCB.Items);
end;

function TSimulateParamEditF.GetVariantFromForm: variant;
begin
  TDocVariant.New(Result);

  Result.ProductType := g_ShipProductType.ToEnumString(ProdTypeCB.ItemIndex);
  Result.ModelName := ModelNameCB.Text;
  Result.ProjectName := ProjectNameCB.Text;
  Result.SystemName := SystemNameCB.Text;
  Result.SubSystemName := SubSystemNameCB.Text;
  Result.Subject := SubjectEdit.Text;
  Result.Desc := DescEdit.Text;
  Result.CourseLevel := g_AcademyCourseLevelDesc.ToEnumString(CourseLevelCB.ItemIndex);
  Result.ActivityLevel := g_AcademyActivityLevelDesc.ToEnumString(ActivityLevelCB.ItemIndex);
  Result.SeqNo := SeqNoSpinEdit.Value;
  Result.DelaySecs := StrToIntDef(DelsySecsEdit.Text,0);
  Result.Enable := EnableCheck.Checked;

  Result.JsonParamCollect := JsonParamCollectMemo.Text;
  Result.CSVValues := CSVValuesMemo.Text;
  Result.DFMText := DFMTextMemo.Text;
end;

procedure TSimulateParamEditF.ProdTypeCBChange(Sender: TObject);
begin
  FillInModelKind;
end;

function TSimulateParamEditF.SaveParamDetail2SimPramRecFromForm(
  var ASimulateParamRecord: TSQLSimulateParamRecord): Boolean;
var
  LDoc: Variant;
begin
  LDoc := GetVariantFromForm;
  AddOrUpdateSimulateParamFromVariant(LDoc);
  ShowMessage('Data Save Is OK!');
end;

end.
