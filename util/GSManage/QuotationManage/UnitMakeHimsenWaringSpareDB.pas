unit UnitMakeHimsenWaringSpareDB;

interface

uses Sysutils, Dialogs, Classes, UnitExcelUtil, Syncommons,
  UnitHimsenWearingSpareMarineRecord, UnitHimsenWearingSpareStationaryRecord;

procedure ImportHimsenWearingSpareMFromXlsFile(AFileName: string);
procedure ImportHimsenWearingSpareSFromXlsFile(AFileName: string);

implementation

uses UnitStringUtil;

procedure ImportHimsenWearingSpareMFromXlsFile(AFileName: string);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2, LStr3: string;
  LIdx: integer;
  LDoc: Variant;
  LUseTC, LUseCyl: Boolean;
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
  LIdx := 8;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LIdx < 253 do
  begin
    LRange := LWorksheet.range['A'+IntToStr(LIdx)];

    if LRange.FormulaR1C1 <> '' then
    begin
      LDoc.MSDesc := LRange.FormulaR1C1;
      Inc(LIdx);
    end;

    LDoc.EngineType := 'H17M';

    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    if LRange.FormulaR1C1 <> '' then
    begin
      LDoc.PartDesc := LRange.FormulaR1C1;

      LRange := LWorksheet.range['U'+IntToStr(LIdx)];
      LDoc.SectionNo := LRange.FormulaR1C1;
      LUseTC := Pos('S8', LDoc.SectionNo) <> 0;
      //TC 사양에 따라 PlateNo,도면번호 등이 달라짐
      if LUseTC then
      begin
        LStr3 := LDoc.PartDesc;
        if Pos('(', LStr3) <> 0 then
        begin
          strToken(LStr3, '(');
          LDoc.TurboChargerModel := strToken(LStr3, ')');
        end
        else
          LDoc.TurboChargerModel := '*';
      end
      else
        LDoc.TurboChargerModel := '*';

      LUseCyl := Pos('S42', LDoc.SectionNo) <> 0;
      //실린더수에 따라 PlateNo,도면번호 등이 달라짐
      if LUseCyl then
      begin
        LStr3 := LDoc.PartDesc;
        if Pos('(', LStr3) <> 0 then
        begin
          strToken(LStr3, '(');
          LDoc.AdaptedCylCount := strToken(LStr3, ')');
        end
        else
          LDoc.AdaptedCylCount := '*';
      end
      else
        LDoc.AdaptedCylCount := '*';

      LRange := LWorksheet.range['V'+IntToStr(LIdx)];
      LDoc.PartNo := LRange.FormulaR1C1;

      LRange := LWorksheet.range['W'+IntToStr(LIdx)];
      LDoc.PlateNo := LRange.FormulaR1C1;

      LRange := LWorksheet.range['X'+IntToStr(LIdx)];
      LDoc.DrawingNo := LRange.FormulaR1C1;

      LRange := LWorksheet.range['Y'+IntToStr(LIdx)];
      LDoc.UsedAmount := LRange.FormulaR1C1;

      LRange := LWorksheet.range['Z'+IntToStr(LIdx)];
      LDoc.SpareAmount := LRange.FormulaR1C1;
      LDoc.PartUnit := 'EA';

      LDoc.MSNo := LDoc.SectionNo + '-' + LDoc.PartNo;

      LRange := LWorksheet.range['AB'+IntToStr(LIdx)];

      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS4000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS4000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AC'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS8000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS8000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AD'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS12000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS12000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AE'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS16000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS16000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AF'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS20000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS20000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AG'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS24000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS24000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AH'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS28000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS28000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AI'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS32000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS32000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AJ'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS36000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS36000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AK'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS40000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS40000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AL'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS44000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS44000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AM'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS48000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS48000ApplyNo := Trim(LStr2);
      end;

      AddHimsenWaringSpareMFromVariant(LDoc);
    end;

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;
end;

procedure ImportHimsenWearingSpareSFromXlsFile(AFileName: string);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2, LStr3: string;
  LIdx: integer;
  LDoc: Variant;
  LUseTC, LUseCyl: Boolean;
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
  LIdx := 8;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LIdx < 253 do
  begin
    LRange := LWorksheet.range['A'+IntToStr(LIdx)];

    if LRange.FormulaR1C1 <> '' then
    begin
      LDoc.MSDesc := LRange.FormulaR1C1;
      Inc(LIdx);
    end;

    LDoc.EngineType := 'H17S';

    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    if LRange.FormulaR1C1 <> '' then
    begin
      LDoc.PartDesc := LRange.FormulaR1C1;

      LRange := LWorksheet.range['U'+IntToStr(LIdx)];
      LDoc.SectionNo := LRange.FormulaR1C1;
      LUseTC := Pos('S8', LDoc.SectionNo) <> 0;//H21=A, H25=C, H17=S
      //TC 사양에 따라 PlateNo,도면번호 등이 달라짐
      if LUseTC then
      begin
        LStr3 := LDoc.PartDesc;
        if Pos('(', LStr3) <> 0 then
        begin
          strToken(LStr3, '(');
          LDoc.TurboChargerModel := strToken(LStr3, ')');
        end
        else
          LDoc.TurboChargerModel := '*';
      end
      else
        LDoc.TurboChargerModel := '*';

      LUseCyl := Pos('S42', LDoc.SectionNo) <> 0;
      //실린더수에 따라 PlateNo,도면번호 등이 달라짐
      if LUseCyl then
      begin
        LStr3 := LDoc.PartDesc;
        if Pos('(', LStr3) <> 0 then
        begin
          strToken(LStr3, '(');
          LDoc.AdaptedCylCount := strToken(LStr3, ')');
        end
        else
          LDoc.AdaptedCylCount := '*';
      end
      else
        LDoc.AdaptedCylCount := '*';

      LRange := LWorksheet.range['V'+IntToStr(LIdx)];
      LDoc.PartNo := LRange.FormulaR1C1;

      LRange := LWorksheet.range['W'+IntToStr(LIdx)];
      LDoc.PlateNo := LRange.FormulaR1C1;

      LRange := LWorksheet.range['X'+IntToStr(LIdx)];
      LDoc.DrawingNo := LRange.FormulaR1C1;

      LRange := LWorksheet.range['Y'+IntToStr(LIdx)];
      LDoc.UsedAmount := LRange.FormulaR1C1;

      LRange := LWorksheet.range['Z'+IntToStr(LIdx)];
      LDoc.SpareAmount := LRange.FormulaR1C1;
      LDoc.PartUnit := 'EA';

      LDoc.MSNo := LDoc.SectionNo + '-' + LDoc.PartNo;

      LRange := LWorksheet.range['AB'+IntToStr(LIdx)];

      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS3000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS3000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AC'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS6000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS6000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AD'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS9000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS9000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AE'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS12000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS12000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AF'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS15000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS15000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AG'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS18000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS18000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AH'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS21000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS21000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AI'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS24000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS24000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AJ'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS27000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS27000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AK'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS30000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS30000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AL'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS33000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS33000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AM'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS36000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS36000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AN'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS39000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS39000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AO'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS42000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS42000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AP'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS45000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS45000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AQ'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 = '-' then
        LDoc.HRS48000ApplyNo := '0'
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.CalcFormula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.CalcFormula := '*';
          LStr2 := '0';
        end;

        LDoc.HRS48000ApplyNo := Trim(LStr2);
      end;

      AddHimsenWaringSpareSFromVariant(LDoc);
    end;

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;
end;

end.
