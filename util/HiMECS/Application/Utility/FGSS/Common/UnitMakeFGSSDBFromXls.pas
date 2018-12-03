unit UnitMakeFGSSDBFromXls;

interface

uses Sysutils, Dialogs, Classes, UnitExcelUtil, Syncommons,
  UnitFGSSKMTagRecord, UnitFGSSTagRecord;

procedure ImportKMTagFromXlsFile(AFileName: string);
procedure ImportKMTerminalInfoFromXlsFile(AFileName: string);

implementation

procedure ImportKMTagFromXlsFile(AFileName: string);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2: string;
  LIdx, LLastRow: integer;
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);

  LStr := 'B';
  LIdx := 2;
  LStr2 := IntToStr(LIdx);
  LRange := LWorksheet.range[LStr+LStr2];

  while LRange.FormulaR1C1 <> '' do
  begin
    LDoc.RevNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['C'+LStr2];
    LDoc.RevNote := LRange.FormulaR1C1;
    LRange := LWorksheet.range['D'+LStr2];
    LDoc.Used := LRange.FormulaR1C1;
    LRange := LWorksheet.range['E'+LStr2];
    LDoc.Area := LRange.FormulaR1C1;
    LRange := LWorksheet.range['F'+LStr2];
    LDoc.SupplierTag := LRange.FormulaR1C1;
    LRange := LWorksheet.range['G'+LStr2];
    LDoc.SupplierDesc := LRange.FormulaR1C1;
    LRange := LWorksheet.range['H'+LStr2];
    LDoc.IAS_SystemNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['I'+LStr2];
    LDoc.IAS_EquipCode := LRange.FormulaR1C1;
    LRange := LWorksheet.range['J'+LStr2];
    LDoc.IAS_EquipNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['K'+LStr2];
    LDoc.IAS_FuncCode := LRange.FormulaR1C1;
    LRange := LWorksheet.range['L'+LStr2];
    LDoc.IAS_IOTag := LRange.FormulaR1C1;
    LRange := LWorksheet.range['M'+LStr2];
    LDoc.IAS_EquipDesc := LRange.FormulaR1C1;
    LRange := LWorksheet.range['N'+LStr2];
    LDoc.IAS_SignalDesc := LRange.FormulaR1C1;
    LRange := LWorksheet.range['O'+LStr2];
    LDoc.IAS_Length := LRange.FormulaR1C1;
    LRange := LWorksheet.range['P'+LStr2];
    LDoc.IAS_IOType := LRange.FormulaR1C1;
    LRange := LWorksheet.range['Q'+LStr2];
    LDoc.IAS_SignalType := LRange.FormulaR1C1;
    LRange := LWorksheet.range['R'+LStr2];
    LDoc.IAS_Power := LRange.FormulaR1C1;
    LRange := LWorksheet.range['S'+LStr2];
    LDoc.IAS_IS := LRange.FormulaR1C1;
    LRange := LWorksheet.range['T'+LStr2];
    LDoc.IAS_NumOfWire := LRange.FormulaR1C1;
    LRange := LWorksheet.range['U'+LStr2];
    LDoc.IAS_ExtIsolator := LRange.FormulaR1C1;
    LRange := LWorksheet.range['V'+LStr2];
    LDoc.CabinetName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['W'+LStr2];
    LDoc.ControlRoomName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['X'+LStr2];
    LDoc.Eng_Low_Range := LRange.FormulaR1C1;
    LRange := LWorksheet.range['Y'+LStr2];
    LDoc.Eng_High_Range := LRange.FormulaR1C1;
    LRange := LWorksheet.range['Z'+LStr2];
    LDoc.Eng_Unit := LRange.FormulaR1C1;
    LRange := LWorksheet.range['AA'+LStr2];
    LDoc.Alarm_LL := LRange.FormulaR1C1;
    LRange := LWorksheet.range['AB'+LStr2];
    LDoc.Alarm_L := LRange.FormulaR1C1;
    LRange := LWorksheet.range['AC'+LStr2];
    LDoc.Alarm_H := LRange.FormulaR1C1;
    LRange := LWorksheet.range['AD'+LStr2];
    LDoc.Alarm_HH := LRange.FormulaR1C1;
    LRange := LWorksheet.range['AE'+LStr2];
    LDoc.Alarm_Delay := LRange.FormulaR1C1;
    LRange := LWorksheet.range['AF'+LStr2];
    LDoc.Alarm_BLK_Grp := LRange.FormulaR1C1;
    LRange := LWorksheet.range['AG'+LStr2];
    LDoc.Alarm_AC_Grp := LRange.FormulaR1C1;
    LRange := LWorksheet.range['AH'+LStr2];
    LDoc.RevRemark := LRange.FormulaR1C1;

    LDoc.UpdateDate := DateToStr(now);

    AddOrUpdateFGSSTagFromVariant(LDoc);

    Inc(LIdx);
    LStr2 := IntToStr(LIdx);
    LRange := LWorksheet.range[LStr+LStr2];

    if LIdx > LLastRow then
      Break;
  end;

  LWorkBook.Close;
  LExcel.Quit;
end;

procedure ImportKMTerminalInfoFromXlsFile(AFileName: string);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2: string;
  LIdx, LLastRow: integer;
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);

  LStr := 'L';
  LIdx := 2;
  LStr2 := IntToStr(LIdx);
  LRange := LWorksheet.range[LStr+LStr2];

  while LRange.FormulaR1C1 <> '' do
  begin
    LDoc.IAS_IOTag := LRange.FormulaR1C1;
    LRange := LWorksheet.range['BN'+LStr2];
    LDoc.HWLoopType := LRange.FormulaR1C1;
    LRange := LWorksheet.range['BO'+LStr2];
    LDoc.PosNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['BP'+LStr2];
    LDoc.IOChannel := LRange.FormulaR1C1;
    LRange := LWorksheet.range['BQ'+LStr2];
    LDoc.TerminalBlock := LRange.FormulaR1C1;
    LRange := LWorksheet.range['BR'+LStr2];
    LDoc.TB_A := LRange.FormulaR1C1;
    LRange := LWorksheet.range['BS'+LStr2];
    LDoc.TB_B := LRange.FormulaR1C1;
    LRange := LWorksheet.range['BT'+LStr2];
    LDoc.TB_C := LRange.FormulaR1C1;
    LRange := LWorksheet.range['BU'+LStr2];
    LDoc.TB_D := LRange.FormulaR1C1;
    LRange := LWorksheet.range['BV'+LStr2];
    LDoc.Note := LRange.FormulaR1C1;

    LDoc.UpdateDate := DateToStr(now);

    AddOrUpdateFGSSKMTerminalInfoFromVariant(LDoc);

    Inc(LIdx);
    LStr2 := IntToStr(LIdx);
    LRange := LWorksheet.range[LStr+LStr2];

    if LIdx > LLastRow then
      Break;
  end;

  LWorkBook.Close;
  LExcel.Quit;
end;

end.
