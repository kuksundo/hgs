unit UnitMakeXls;

interface

uses Sysutils, Dialogs, Classes, StrUtils, UnitExcelUtil, Syncommons;

procedure ImportVDRMasterFromXlsFile(AFileName: string);

implementation

uses UnitHGSVDRRecord;

procedure ImportVDRMasterFromXlsFile(AFileName: string);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2: string;
  LIdx, LLastRow: integer;
  LDoc: Variant;
  LYear, LMon, LDay: string;
  Ly, Lm, Ld: word;
  LSQLHGSVDRRecord: TSQLHGSVDRRecord;
begin
  if not FileExists(AFileName) then
  begin
    ShowMessage('File(' + AFileName + ')이 존재하지 않습니다');
    exit;
  end;


  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(AFileName);
  LExcel.Visible := true;
  LWorksheet := LExcel.ActiveSheet;
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'A';
  LIdx := 5;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LRange.FormulaR1C1 <> '' do
  begin
    LRange := LWorksheet.range['B'+IntToStr(LIdx)];
    LDoc.ProjectNo := LRange.FormulaR1C1;;
    LRange := LWorksheet.range['D'+IntToStr(LIdx)];
    LDoc.HullNo := LRange.FormulaR1C1;;
    LRange := LWorksheet.range['E'+IntToStr(LIdx)];
    LDoc.VDRSerialNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['G'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    if LStr2 <> '' then
    begin
      LYear := LeftStr(LStr2,4);
      LMon := Copy(LStr2,5,2);
      LDay := RightStr(LStr2,2);
      Ly := StrToInt(LYear);
      Lm := StrToInt(LMon);
      Ld := StrToInt(LDay);
      LDoc.DeliveryDate := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
    end
    else
      LDoc.DeliveryDate := 0;

    LRange := LWorksheet.range['H'+IntToStr(LIdx)];
    LDoc.VDRType := LRange.FormulaR1C1;
    LRange := LWorksheet.range['I'+IntToStr(LIdx)];
    LDoc.MainBoard := LRange.FormulaR1C1;
    LRange := LWorksheet.range['J'+IntToStr(LIdx)];
    LDoc.Video := LRange.FormulaR1C1;
    LRange := LWorksheet.range['K'+IntToStr(LIdx)];
    LDoc.HDD := LRange.FormulaR1C1;;
    LRange := LWorksheet.range['L'+IntToStr(LIdx)];
    LDoc.HINEI := LRange.FormulaR1C1;
    LRange := LWorksheet.range['M'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    if LStr2 <> '' then
      LDoc.IsIMO := True
    else
      LDoc.IsIMO := False;

    LRange := LWorksheet.range['N'+IntToStr(LIdx)];
    LDoc.VCSType := LRange.FormulaR1C1;
    LRange := LWorksheet.range['O'+IntToStr(LIdx)];
    LDoc.CapsuleType := LRange.FormulaR1C1;
    LRange := LWorksheet.range['Q'+IntToStr(LIdx)];
    LDoc.Remark := LRange.FormulaR1C1;
    LRange := LWorksheet.range['R'+IntToStr(LIdx)];
    LDoc.IMONo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['S'+IntToStr(LIdx)];
    LDoc.ShipName := LRange.FormulaR1C1;

    if LDoc.ShipName = '' then
    begin
      LRange := LWorksheet.range['F'+IntToStr(LIdx)];
      LDoc.ShipName := LRange.FormulaR1C1;
    end;

    AddOrUpdateHGSVDRFromVariant(LDoc, True);

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  LWorkBook.Close;
  LExcel.Quit;
end;

end.
