unit UnitMakeMasterCustomerDB;

interface

uses Sysutils, Dialogs, Classes, UnitExcelUtil, Syncommons, UElecDataRecord,
  CommonData;

procedure ImportMasterCustomerFromXlsFile(AFileName: string);

implementation

uses UnitStringUtil;

procedure ImportMasterCustomerFromXlsFile(AFileName: string);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LY,LM,LD: word;
  LStr, LStr2, LStr3, LSectionPrefix: string;
  LIdx: integer;
  LDoc: Variant;
  LCompanyTypes: TCompanyTypes;
  LBusinessAreas: TBusinessAreas;
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

  LStr := 'C';
  LIdx := 5;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while true do
  begin
    LRange := LWorksheet.range['C'+IntToStr(LIdx)];

    if LRange.FormulaR1C1 <> '' then
      LDoc.Nation := LRange.FormulaR1C1
    else
      break;

    LRange := LWorksheet.range['D'+IntToStr(LIdx)];
    LDoc.City := LRange.FormulaR1C1;

    LRange := LWorksheet.range['E'+IntToStr(LIdx)];
    LDoc.CompanyName := LRange.FormulaR1C1;

    LRange := LWorksheet.range['G'+IntToStr(LIdx)];
    LStr := LRange.FormulaR1C1;
    if LStr <> '' then
    begin
      LStr2 := strToken(LStr, '.');
      if LStr2 <> '' then
      begin
        LY := 0;
        LM := 0;
        LD := 0;

        LY := StrToIntDef(LStr2, 0);

        LStr2 := strToken(LStr, '.');
        LM := StrToIntDef(LStr2, 0);
        LD := StrToIntDef(LStr, 0);

        LDoc.ContractDueDate := DateToStr(EncodeDate(LY, LM, LD));
      end;
    end;

    LRange := LWorksheet.range['H'+IntToStr(LIdx)];
    LDoc.Notes := LRange.FormulaR1C1;

    LRange := LWorksheet.range['M'+IntToStr(LIdx)];
    LDoc.ManagerName := LRange.FormulaR1C1;

    LRange := LWorksheet.range['N'+IntToStr(LIdx)];
    LDoc.MobilePhone := LRange.FormulaR1C1;

    LRange := LWorksheet.range['O'+IntToStr(LIdx)];
    LDoc.OfficePhone := LRange.FormulaR1C1;

    LRange := LWorksheet.range['Q'+IntToStr(LIdx)];
    LDoc.EMail := LRange.FormulaR1C1;

    LRange := LWorksheet.range['R'+IntToStr(LIdx)];
    LDoc.CompanyCode := LRange.FormulaR1C1;

    LRange := LWorksheet.range['S'+IntToStr(LIdx)];
    LDoc.CompanyName2 := LRange.FormulaR1C1;

    LDoc.TaskID := 0;
    LDoc.FirstName := '';
    LDoc.Surname := '';
    LDoc.CompanyAddress := '';
    LDoc.Position := '';
    LDoc.AgentInfo := '';
    LCompanyTypes := [ctSubContractor];
    LDoc.CompanyTypes := TCompanyType_SetToInt(LCompanyTypes);

    if LWorksheet.Name = '조선' then
      LBusinessAreas := [baShip]
    else
    if LWorksheet.Name = '엔진' then
      LBusinessAreas := [baEngine]
    else
      LBusinessAreas := [baElectric];

    LDoc.BusinessAreas := TBusinessArea_SetToInt(LBusinessAreas);

    AddMasterCustomerFromVariant(LDoc);

    Inc(LIdx);
  end;

  LWorkBook.Close;
  LExcel.Quit;
end;

end.
