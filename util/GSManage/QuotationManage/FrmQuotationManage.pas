unit FrmQuotationManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, SBPro, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  AdvOfficeTabSet, Vcl.ExtCtrls, Vcl.StdCtrls, AeroButtons, Vcl.ComCtrls,
  AdvGroupBox, AdvOfficeButtons, JvExControls, JvLabel, CurvyControls,
  Vcl.ImgList, UnitHimsenWearingSpareMarineRecord, UnitHimsenWearingSpareStationaryRecord;

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
    CylCountEdit: TEdit;
    TCModelCB: TComboBox;
    RunHourCB: TComboBox;
    JvLabel1: TJvLabel;
    HullNoEdit: TEdit;
    Label1: TLabel;
    SectionNo: TNxTextColumn;
    UsedAmount: TNxTextColumn;
    CalcFormula: TNxTextColumn;
    SpareAmount: TNxTextColumn;
    PartUnit: TNxTextColumn;
    Amount: TNxTextColumn;
    TCModel: TNxTextColumn;
    ImportWearingSpareSFromXls2: TMenuItem;
    procedure ImportWearingSpareMFromXls2Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure ImportWearingSpareSFromXls2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RunHourCBDropDown(Sender: TObject);
  private
    procedure GetHimsenWearingSpare2Grid;
    procedure GetHimsenWearingSpareM2Grid;
    procedure GetHimsenWearingSpareS2Grid;

    procedure GetHimsenWearingSpareMParam2Rec(var AHimsenWearingSpareParamRec: THimsenWearingSpareMRec);
    procedure GetHimsenWearingSpareSParam2Rec(var AHimsenWearingSpareParamRec: THimsenWearingSpareSRec);
    procedure GetHimsenWearingSpareFromVariant2Grid(ADoc: Variant);
    function GetCalcSparePartAmount(ADoc: Variant): string;

    procedure ExecuteSearch(Key: Char);
    procedure MakeHimsenWearPartQuotation();
  public
    FRunHourList: TStringList;
  end;

const
  HIMSEN_WEAR_PART_QUOTATION_FILE = 'Spare_part_list.xlsx';

var
  HimsenWearSpareQF: THimsenWearSpareQF;

implementation

uses UnitMakeHimsenWaringSpareDB, UnitExcelUtil;

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

procedure THimsenWearSpareQF.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure THimsenWearSpareQF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    btn_SearchClick(nil);
end;

procedure THimsenWearSpareQF.FormCreate(Sender: TObject);
begin
  InitHimsenWearingSpareMClient(Application.ExeName);
  InitHimsenWearingSpareSClient(Application.ExeName);
  FRunHourList := TStringList.Create;
end;

procedure THimsenWearSpareQF.FormDestroy(Sender: TObject);
begin
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

  if Pos('M', EngTypeCB.Text) <> 0 then
  begin
    if LRunHour = '4000' then
      LCalcNo := StrToIntDef(ADoc.HRS4000ApplyNo,0)
    else
    if LRunHour = '8000' then
      LCalcNo := StrToIntDef(ADoc.HRS8000ApplyNo,0)
    else
    if LRunHour = '12000' then
      LCalcNo := StrToIntDef(ADoc.HRS12000ApplyNo,0)
    else
    if LRunHour = '16000' then
      LCalcNo := StrToIntDef(ADoc.HRS16000ApplyNo,0)
    else
    if LRunHour = '20000' then
      LCalcNo := StrToIntDef(ADoc.HRS20000ApplyNo,0)
    else
    if LRunHour = '24000' then
      LCalcNo := StrToIntDef(ADoc.HRS24000ApplyNo,0)
    else
    if LRunHour = '28000' then
      LCalcNo := StrToIntDef(ADoc.HRS28000ApplyNo,0)
    else
    if LRunHour = '32000' then
      LCalcNo := StrToIntDef(ADoc.HRS32000ApplyNo,0)
    else
    if LRunHour = '36000' then
      LCalcNo := StrToIntDef(ADoc.HRS36000ApplyNo,0)
    else
    if LRunHour = '40000' then
      LCalcNo := StrToIntDef(ADoc.HRS40000ApplyNo,0)
    else
    if LRunHour = '44000' then
      LCalcNo := StrToIntDef(ADoc.HRS44000ApplyNo,0)
    else
    if LRunHour = '48000' then
      LCalcNo := StrToIntDef(ADoc.HRS48000ApplyNo,0);
  end
  else
  if Pos('S', EngTypeCB.Text) <> 0 then
  begin
    if LRunHour = '3000' then
      LCalcNo := StrToIntDef(ADoc.HRS3000ApplyNo,0)
    else
    if LRunHour = '6000' then
      LCalcNo := StrToIntDef(ADoc.HRS6000ApplyNo,0)
    else
    if LRunHour = '9000' then
      LCalcNo := StrToIntDef(ADoc.HRS9000ApplyNo,0)
    else
    if LRunHour = '12000' then
      LCalcNo := StrToIntDef(ADoc.HRS12000ApplyNo,0)
    else
    if LRunHour = '15000' then
      LCalcNo := StrToIntDef(ADoc.HRS15000ApplyNo,0)
    else
    if LRunHour = '18000' then
      LCalcNo := StrToIntDef(ADoc.HRS18000ApplyNo,0)
    else
    if LRunHour = '21000' then
      LCalcNo := StrToIntDef(ADoc.HRS21000ApplyNo,0)
    else
    if LRunHour = '24000' then
      LCalcNo := StrToIntDef(ADoc.HRS24000ApplyNo,0)
    else
    if LRunHour = '27000' then
      LCalcNo := StrToIntDef(ADoc.HRS27000ApplyNo,0)
    else
    if LRunHour = '30000' then
      LCalcNo := StrToIntDef(ADoc.HRS30000ApplyNo,0)
    else
    if LRunHour = '33000' then
      LCalcNo := StrToIntDef(ADoc.HRS33000ApplyNo,0)
    else
    if LRunHour = '36000' then
      LCalcNo := StrToIntDef(ADoc.HRS36000ApplyNo,0)
    else
    if LRunHour = '39000' then
      LCalcNo := StrToIntDef(ADoc.HRS39000ApplyNo,0)
    else
    if LRunHour = '42000' then
      LCalcNo := StrToIntDef(ADoc.HRS42000ApplyNo,0)
    else
    if LRunHour = '45000' then
      LCalcNo := StrToIntDef(ADoc.HRS45000ApplyNo,0)
    else
    if LRunHour = '48000' then
      LCalcNo := StrToIntDef(ADoc.HRS48000ApplyNo,0);
  end;

  LUsedAmount := StrToIntDef(ADoc.UsedAmount,0);
  LSpareAmount := StrToIntDef(ADoc.SpareAmount,0);
  LFormula := ADoc.CalcFormula;

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

procedure THimsenWearSpareQF.GetHimsenWearingSpare2Grid;
begin
  if Pos('M', EngTypeCB.Text) <> 0 then
    GetHimsenWearingSpareM2Grid
  else
  if Pos('S', EngTypeCB.Text) <> 0 then
    GetHimsenWearingSpareS2Grid;
end;

procedure THimsenWearSpareQF.GetHimsenWearingSpareFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
begin
  LRow := WearingPartGrid.AddRow;

  WearingPartGrid.CellsByName['MSDesc', LRow] := ADoc.MSDesc;
  WearingPartGrid.CellsByName['PartNo', LRow] := ADoc.PartNo;
  WearingPartGrid.CellsByName['PartDesc', LRow] := ADoc.PartDesc;
  WearingPartGrid.CellsByName['SectionNo', LRow] := ADoc.SectionNo;
  WearingPartGrid.CellsByName['PlateNo', LRow] := ADoc.PlateNo;
  WearingPartGrid.CellsByName['DrawingNo', LRow] := ADoc.DrawingNo;
  WearingPartGrid.CellsByName['SpareAmount', LRow] := ADoc.SpareAmount;
  WearingPartGrid.CellsByName['UsedAmount', LRow] := ADoc.UsedAmount;
  WearingPartGrid.CellsByName['CalcFormula', LRow] := ADoc.CalcFormula;
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
      LDoc := GetVariantFromHimsenWearingSpareM(LSQLHimsenWearingSpareMaster);
      GetHimsenWearingSpareFromVariant2Grid(LDoc);

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
  AHimsenWearingSpareParamRec.fHullNo := HullNoEdit.Text;
  AHimsenWearingSpareParamRec.fEngineType := EngTypeCB.Text;
  AHimsenWearingSpareParamRec.fTCModel := TCModelCB.Text;
  AHimsenWearingSpareParamRec.fRunningHour := RunHourCB.Text;
  AHimsenWearingSpareParamRec.fCylCount := CylCountEdit.Text;
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
      LDoc := GetVariantFromHimsenWearingSpareS(LSQLHimsenWearingSpareMaster);
      GetHimsenWearingSpareFromVariant2Grid(LDoc);

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
  AHimsenWearingSpareParamRec.fHullNo := HullNoEdit.Text;
  AHimsenWearingSpareParamRec.fEngineType := EngTypeCB.Text;
  AHimsenWearingSpareParamRec.fTCModel := TCModelCB.Text;
  AHimsenWearingSpareParamRec.fRunningHour := RunHourCB.Text;
  AHimsenWearingSpareParamRec.fCylCount := CylCountEdit.Text;
end;

procedure THimsenWearSpareQF.ImportWearingSpareMFromXls2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportHimsenWearingSpareMFromXlsFile(OpenDialog1.FileName);
      GetHimsenWearingSpare2Grid;
    end;
  end;
end;

procedure THimsenWearSpareQF.ImportWearingSpareSFromXls2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      ImportHimsenWearingSpareSFromXlsFile(OpenDialog1.FileName);
      GetHimsenWearingSpare2Grid;
    end;
  end;
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

  if Pos('M', EngTypeCB.Text) <> 0 then
    GetRunHour2List4M(LStrList)
  else
  if Pos('S', EngTypeCB.Text) <> 0 then
    GetRunHour2List4S(LStrList);
end;

end.
