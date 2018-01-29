unit UnitMakeAnsiDeviceDB;

interface

uses Sysutils, Dialogs, Classes, UnitExcelUtil, Syncommons,
  UnitAnsiDeviceRecord;

procedure ImportAnsiDeviceFromXlsFile(AFileName: string);

implementation

procedure ImportAnsiDeviceFromXlsFile(AFileName: string);
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
  LStr2 := IntToStr(LIdx);
  LRange := LWorksheet.range[LStr+LStr2];

  while LRange.FormulaR1C1 <> '' do
  begin
    LRange := LWorksheet.range['A'+LStr2];
    LDoc.AnsiDeviceNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['B'+LStr2];
    LDoc.AnsiDeviceName_Kor := LRange.FormulaR1C1;
    LRange := LWorksheet.range['C'+LStr2];
    LDoc.AnsiDeviceName_Eng := LRange.FormulaR1C1;
    LRange := LWorksheet.range['D'+LStr2];
    LDoc.AnsiDeviceDesc_Eng := LRange.FormulaR1C1;
    LRange := LWorksheet.range['E'+LStr2];
    LDoc.AnsiDeviceDesc_Kor := LRange.FormulaR1C1;
    LDoc.UpdateDate := DateToStr(now);

    AddOrUpdateAnsiDeviceFromVariant(LDoc);

    Inc(LIdx);
    LStr2 := IntToStr(LIdx);
    LRange := LWorksheet.range[LStr+LStr2];
  end;

end;

end.
