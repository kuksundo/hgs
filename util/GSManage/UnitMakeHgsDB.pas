unit UnitMakeHgsDB;

interface

uses Sysutils, Dialogs, Classes, UnitExcelUtil, Syncommons,
  UnitVesselMasterRecord;

procedure ImportVesselMasterFromXlsFile(AFileName: string);

implementation

procedure ImportVesselMasterFromXlsFile(AFileName: string);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2: string;
  LIdx: integer;
  LDoc: Variant;
begin
  if not FileExists(AFileName) then
  begin
    ShowMessage('File(' + AFileName + ')이 존재하지 않습니다');
    exit;
  end;


  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(AFileName);
//  LExcel.Visible := true;
  LWorksheet := LExcel.ActiveSheet;
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'A';
  LIdx := 2;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LRange.FormulaR1C1 <> '' do
  begin
    LRange := LWorksheet.range['A'+IntToStr(LIdx)];
    LDoc.HullNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['B'+IntToStr(LIdx)];
    LDoc.ShipName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    LDoc.IMONo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['D'+IntToStr(LIdx)];
    LDoc.SClass1 := LRange.FormulaR1C1;
    LRange := LWorksheet.range['E'+IntToStr(LIdx)];
    LDoc.SClass2 := LRange.FormulaR1C1;
    LRange := LWorksheet.range['F'+IntToStr(LIdx)];
    LDoc.ShipType := LRange.FormulaR1C1;
    LRange := LWorksheet.range['G'+IntToStr(LIdx)];
    LDoc.OwnerID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['H'+IntToStr(LIdx)];
    LDoc.OwnerName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['I'+IntToStr(LIdx)];
    LDoc.TechManageCountry := LRange.FormulaR1C1;
    LRange := LWorksheet.range['J'+IntToStr(LIdx)];
    LDoc.TechManagerID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['K'+IntToStr(LIdx)];
    LDoc.TechManagerName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['L'+IntToStr(LIdx)];
    LDoc.OperatorID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['M'+IntToStr(LIdx)];
    LDoc.OperatorName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['N'+IntToStr(LIdx)];
    LDoc.BuyingCompanyCountry := LRange.FormulaR1C1;
    LRange := LWorksheet.range['O'+IntToStr(LIdx)];
    LDoc.BuyingCompanyID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['P'+IntToStr(LIdx)];
    LDoc.BuyingCompanyName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['Q'+IntToStr(LIdx)];
    LDoc.ShipBuilderID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['R'+IntToStr(LIdx)];
    LDoc.ShipBuilderName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['S'+IntToStr(LIdx)];
    LDoc.VesselStatus := LRange.FormulaR1C1;
//    LRange := LWorksheet.range['T'+IntToStr(LIdx)];
//    if LRange.FormulaR1C1 <> '' then
//      LDoc.SpecialSurveyDueDate := LRange.FormulaR1C1;

//    LRange := LWorksheet.range['U'+IntToStr(LIdx)];
//    if LRange.FormulaR1C1 <> '' then
//      LDoc.DockingSurveyDueDate := LRange.FormulaR1C1;

    if (LDoc.VesselStatus <> '') and (LDoc.VesselStatus <> 'Broken Up') then
      AddOrUpdateVesselMasterFromVariant(LDoc);
//      AddVesselMasterFromVariant(LDoc);

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

end;

end.
