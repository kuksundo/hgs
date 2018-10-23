unit UnitMakeHimsenWaringSpareDB;

interface

uses Sysutils, Dialogs, Classes, UnitExcelUtil, Syncommons,
  UnitHimsenWearingSpareMarineRecord, UnitHimsenWearingSpareStationaryRecord;

procedure ImportHimsenWearingSpareMFromXlsFile(AFileName, AEngType: string; ATierStep: integer);
procedure ImportHimsenWearingSpareSFromXlsFile(AFileName, AEngType: string; ATierStep: integer);
procedure ImportHimsenWearingSpareFromXlsFile(AFileName, AEngType: string; ATierStep, AUsage: integer);

implementation

uses UnitStringUtil, FrmQuotationManage;

procedure ImportHimsenWearingSpareMFromXlsFile(AFileName, AEngType: string; ATierStep: integer);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2, LStr3, LSectionPrefix: string;
  LIdx, LLastRow: integer;
  LDoc: Variant;
  LUseTC, LUseCyl, LUseRPM, LUseMB: Boolean;
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  if Pos('H17', AEngType) <> 0 then
    LSectionPrefix := 'S'
  else
  if Pos('H21', AEngType) <> 0 then
    LSectionPrefix := 'A'
  else
  if Pos('H25', AEngType) <> 0 then
    LSectionPrefix := 'C'
  else
  if Pos('H32', AEngType) <> 0 then
    LSectionPrefix := 'L'
  else
  if Pos('H35DF', AEngType) <> 0 then
    LSectionPrefix := 'LDF';

  LStr := 'A';
  LIdx := 8;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LIdx < LLastRow do //253
  begin
    LRange := LWorksheet.range['A'+IntToStr(LIdx)];

    if LRange.FormulaR1C1 <> '' then
    begin
      LDoc.MSDesc := LRange.FormulaR1C1;
      Inc(LIdx);
    end;

    LDoc.EngineType := AEngType;

    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    if LRange.FormulaR1C1 <> '' then
    begin
      LDoc.PartDesc := LRange.FormulaR1C1;

      LRange := LWorksheet.range['U'+IntToStr(LIdx)];
      LDoc.SectionNo := LRange.FormulaR1C1;
      //H21=A, H25=C, H17=S, H32=L, H35DF=LDF
      LUseTC := Pos(LSectionPrefix + '8', LDoc.SectionNo) <> 0;
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

      LUseCyl := Pos(LSectionPrefix + '42', LDoc.SectionNo) <> 0;
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

      LUseRPM := Pos(LSectionPrefix + '51', LDoc.SectionNo) <> 0;
      //RPM에 따라 도면번호가 달라짐
      if LUseRPM then
      begin
        LStr3 := LDoc.PartDesc;
        if Pos('(', LStr3) <> 0 then
        begin
          strToken(LStr3, '(');
          LDoc.RatedRPM := strToken(LStr3, ')');
        end
        else
          LDoc.RatedRPM := '*';
      end
      else
        LDoc.RatedRPM := '*';

      LUseMB := (Pos(LSectionPrefix + '13', LDoc.SectionNo) <> 0) or
        (Pos(LSectionPrefix + '32', LDoc.SectionNo) <> 0);
      //Main Bearing Maker에 따라 도면번호가 달라짐
      if LUseMB then
      begin
        LStr3 := LDoc.PartDesc;
        if Pos('(', LStr3) <> 0 then
        begin
          strToken(LStr3, '(');
          LDoc.MainBearingMaker := strToken(LStr3, ')');
        end
        else
          LDoc.MainBearingMaker := '*';
      end
      else
        LDoc.MainBearingMaker := '*';

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

      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS4000ApplyNo := '0';
        LDoc.HRS4000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS4000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS4000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS4000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS4000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AC'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS8000ApplyNo := '0';
        LDoc.HRS8000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS8000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS8000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS8000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS8000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AD'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS12000ApplyNo := '0';
        LDoc.HRS12000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS12000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS12000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS12000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS12000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AE'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS16000ApplyNo := '0';
        LDoc.HRS16000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS16000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS16000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS16000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS16000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AF'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS20000ApplyNo := '0';
        LDoc.HRS20000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS20000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS20000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS20000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS20000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AG'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS24000ApplyNo := '0';
        LDoc.HRS24000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS24000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS24000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS24000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS24000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AH'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS28000ApplyNo := '0';
        LDoc.HRS28000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS28000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS28000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS28000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS28000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AI'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS32000ApplyNo := '0';
        LDoc.HRS32000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS32000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS32000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS32000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS32000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AJ'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS36000ApplyNo := '0';
        LDoc.HRS36000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS36000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS36000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS36000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS36000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AK'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS40000ApplyNo := '0';
        LDoc.HRS40000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS40000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS40000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS40000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS40000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AL'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS44000ApplyNo := '0';
        LDoc.HRS44000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS44000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS44000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS44000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS44000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AM'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS48000ApplyNo := '0';
        LDoc.HRS48000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS48000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS48000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS48000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS48000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AN'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS60000ApplyNo := '0';
        LDoc.HRS60000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS60000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS60000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS60000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS60000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AO'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS72000ApplyNo := '0';
        LDoc.HRS72000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS72000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS72000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS72000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS72000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AP'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS88000ApplyNo := '0';
        LDoc.HRS88000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS88000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS88000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS88000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS88000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AQ'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS100000ApplyNo := '0';
        LDoc.HRS100000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS100000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS100000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS100000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS100000ApplyNo := Trim(LStr2);
      end;

      AddHimsenWaringSpareMFromVariant(LDoc, ATierStep);
    end;

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  LWorkBook.Close;
  LExcel.Quit;
end;

procedure ImportHimsenWearingSpareSFromXlsFile(AFileName, AEngType: string; ATierStep: integer);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2, LStr3, LSectionPrefix: string;
  LIdx, LLastRow: integer;
  LDoc: Variant;
  LUseTC, LUseCyl, LUseRPM, LUseMB: Boolean;
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'A';
  LIdx := 8;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  if Pos('H17', AEngType) <> 0 then
    LSectionPrefix := 'S'
  else
  if Pos('H21', AEngType) <> 0 then
    LSectionPrefix := 'A'
  else
  if Pos('H25', AEngType) <> 0 then
    LSectionPrefix := 'C'
  else
  if Pos('H32', AEngType) <> 0 then
    LSectionPrefix := 'L'
  else
  if Pos('H35DF', AEngType) <> 0 then
    LSectionPrefix := 'LDF';

  while LIdx < LLastRow do
  begin
    LRange := LWorksheet.range['A'+IntToStr(LIdx)];

    if LRange.FormulaR1C1 <> '' then
    begin
      LDoc.MSDesc := LRange.FormulaR1C1;
      Inc(LIdx);
    end;

    LDoc.EngineType := AEngType;

    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    if LRange.FormulaR1C1 <> '' then
    begin
      LDoc.PartDesc := LRange.FormulaR1C1;

      LRange := LWorksheet.range['U'+IntToStr(LIdx)];
      LDoc.SectionNo := LRange.FormulaR1C1;
      //H21=A, H25=C, H17=S, H32=L, H35DF=LDF
      LUseTC := Pos(LSectionPrefix + '8', LDoc.SectionNo) <> 0;
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

      LUseCyl := Pos(LSectionPrefix + '42', LDoc.SectionNo) <> 0;
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

      LUseRPM := Pos(LSectionPrefix + '51', LDoc.SectionNo) <> 0;
      //RPM에 따라 도면번호가 달라짐
      if LUseRPM then
      begin
        LStr3 := LDoc.PartDesc;
        if Pos('(', LStr3) <> 0 then
        begin
          strToken(LStr3, '(');
          LDoc.RatedRPM := strToken(LStr3, ')');
        end
        else
          LDoc.RatedRPM := '*';
      end
      else
        LDoc.RatedRPM := '*';

      LUseMB := Pos(LSectionPrefix + '13', LDoc.SectionNo) <> 0;
      //Main Bearing Maker에 따라 도면번호가 달라짐
      if LUseMB then
      begin
        LStr3 := LDoc.PartDesc;
        if Pos('(', LStr3) <> 0 then
        begin
          strToken(LStr3, '(');
          LDoc.MainBearingMaker := strToken(LStr3, ')');
        end
        else
          LDoc.MainBearingMaker := '*';
      end
      else
        LDoc.MainBearingMaker := '*';

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

      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS3000ApplyNo := '0';
        LDoc.HRS3000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS3000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS3000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS3000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS3000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AC'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS6000ApplyNo := '0';
        LDoc.HRS6000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS6000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS6000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS6000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS6000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AD'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS9000ApplyNo := '0';
        LDoc.HRS9000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS9000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS9000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS9000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS9000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AE'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS12000ApplyNo := '0';
        LDoc.HRS12000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS12000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS12000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS12000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS12000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AF'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS15000ApplyNo := '0';
        LDoc.HRS15000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS15000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS15000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS15000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS15000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AG'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS18000ApplyNo := '0';
        LDoc.HRS18000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS18000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS18000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS18000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS18000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AH'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS21000ApplyNo := '0';
        LDoc.HRS21000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS21000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS21000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS21000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS21000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AI'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS24000ApplyNo := '0';
        LDoc.HRS24000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS24000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS24000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS24000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS24000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AJ'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS27000ApplyNo := '0';
        LDoc.HRS27000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS27000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS27000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS27000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS27000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AK'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS30000ApplyNo := '0';
        LDoc.HRS30000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS30000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS30000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS30000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS30000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AL'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS33000ApplyNo := '0';
        LDoc.HRS33000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS33000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS33000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS33000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS33000ApplyNo := LStr2;
      end;

      LRange := LWorksheet.range['AM'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS36000ApplyNo := '0';
        LDoc.HRS36000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS36000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS36000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS36000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS36000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AN'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS39000ApplyNo := '0';
        LDoc.HRS39000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS39000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS39000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS39000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS39000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AO'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS42000ApplyNo := '0';
        LDoc.HRS42000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS42000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS42000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS42000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS42000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AP'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS45000ApplyNo := '0';
        LDoc.HRS45000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS45000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS45000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS45000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS45000ApplyNo := Trim(LStr2);
      end;

      LRange := LWorksheet.range['AQ'+IntToStr(LIdx)];
      if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
      begin
        LDoc.HRS48000ApplyNo := '0';
        LDoc.HRS48000Formula := '*';
      end
      else
      begin
        LStr2 := LRange.Formula;
        strToken(LStr2, ')');

        if Pos('*', LStr2) <> 0 then
        begin
          LDoc.HRS48000Formula := '*';
          strToken(LStr2, '*');
        end
        else
        if Pos('+', LStr2) <> 0 then
        begin
          LDoc.HRS48000Formula := '+';
          strToken(LStr2, '+');
        end
        else
        begin
          LDoc.HRS48000Formula := '*';
          LStr2 := '1';
        end;

        LDoc.HRS48000ApplyNo := Trim(LStr2);
      end;

      AddHimsenWaringSpareSFromVariant(LDoc, ATierStep);
    end;

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  LWorkBook.Close;
  LExcel.Quit;
end;

procedure ImportHimsenWearingSpareFromXlsFile(AFileName, AEngType: string; ATierStep, AUsage: integer);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2, LStr3, LSectionPrefix: string;
  LIdx, LLastRow: integer;
  LDoc: Variant;
  LUseTC, LUseCyl, LUseRPM, LUseMB, LUseGT, LUsePOR, LUseFuel: Boolean;
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  //H21=A, H25=C, H17=S, H32=L, H35DF=LDF
  if Pos('H17', AEngType) <> 0 then
    LSectionPrefix := 'S'
  else
  if Pos('H21', AEngType) <> 0 then
    LSectionPrefix := 'A'
  else
  if Pos('H25', AEngType) <> 0 then
    LSectionPrefix := 'C'
  else
  if Pos('H32', AEngType) <> 0 then
    LSectionPrefix := 'L'
  else
  if Pos('H35DF', AEngType) <> 0 then
    LSectionPrefix := 'LDF';

  LStr := 'A';
  LIdx := 8;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LIdx < LLastRow do
  begin
    HimsenWearSpareQF.SplashScreen1.BeginUpdate;
    HimsenWearSpareQF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
    HimsenWearSpareQF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
    HimsenWearSpareQF.SplashScreen1.EndUpdate;
    HimsenWearSpareQF.SplashScreen1.Show;

    try
      LRange := LWorksheet.range['A'+IntToStr(LIdx)];

      if LRange.FormulaR1C1 <> '' then
      begin
        LDoc.MSDesc := LRange.FormulaR1C1;
        Inc(LIdx);
      end;

      LDoc.EngineType := AEngType;

      LRange := LWorksheet.range['C'+IntToStr(LIdx)];
      if LRange.FormulaR1C1 <> '' then
      begin
        LDoc.PartDesc := LRange.FormulaR1C1;

        LRange := LWorksheet.range['W'+IntToStr(LIdx)];
        LStr3 := LRange.FormulaR1C1;
        LUseTC := LStr3 <> '';

        //TC 사양에 따라 PlateNo,도면번호 등이 달라짐
        if LUseTC then
          LDoc.TurboChargerModel := LStr3
        else
          LDoc.TurboChargerModel := '*';

        LRange := LWorksheet.range['U'+IntToStr(LIdx)];
        LStr3 := LRange.FormulaR1C1;
        LUseCyl := LStr3 <> '';

        //실린더수에 따라 PlateNo,도면번호 등이 달라짐
        if LUseCyl then
          LDoc.AdaptedCylCount := LStr3
        else
          LDoc.AdaptedCylCount := '*';

        LRange := LWorksheet.range['V'+IntToStr(LIdx)];
        LStr3 := LRange.FormulaR1C1;
        LUseRPM := LStr3 <> '';

        //RPM에 따라 도면번호가 달라짐
        if LUseRPM then
          LDoc.RatedRPM := LStr3
        else
          LDoc.RatedRPM := '*';

        LRange := LWorksheet.range['Y'+IntToStr(LIdx)];
        LStr3 := LRange.FormulaR1C1;
        LUseMB := LStr3 <> '';

        //Main Bearing Maker에 따라 도면번호가 달라짐
        if LUseMB then
          LDoc.MainBearingMaker := LStr3
        else
          LDoc.MainBearingMaker := '*';

        LRange := LWorksheet.range['X'+IntToStr(LIdx)];
        LStr3 := LRange.FormulaR1C1;
        LUseMB := LStr3 <> '';

        //Governor Type에 따라 도면번호가 달라짐
        if LUseGT then
          LDoc.GovernorType := LStr3
        else
          LDoc.GovernorType := '*';

        LRange := LWorksheet.range['Z'+IntToStr(LIdx)];
        LStr3 := LRange.FormulaR1C1;
        LUsePOR := LStr3 = '1';

        //POR 발행 여부
        if LUsePOR then
          LDoc.PORIssue := LStr3
        else
          LDoc.PORIssue := '*';

        LRange := LWorksheet.range['AA'+IntToStr(LIdx)];
        LStr3 := LRange.FormulaR1C1;
        LUseFuel := LStr3 <> '';

        //Fuel 종류에 따라 도면번호가 달라짐
        if LUseFuel then
          LDoc.FuelKind := LStr3
        else
          LDoc.FuelKind := '*';

        LRange := LWorksheet.range['AB'+IntToStr(LIdx)];
        LDoc.SectionNo := LRange.FormulaR1C1;

        LRange := LWorksheet.range['AC'+IntToStr(LIdx)];
        LDoc.PartNo := LRange.FormulaR1C1;

        LRange := LWorksheet.range['AD'+IntToStr(LIdx)];
        LDoc.PlateNo := LRange.FormulaR1C1;

        LRange := LWorksheet.range['AE'+IntToStr(LIdx)];
        LDoc.DrawingNo := LRange.FormulaR1C1;

        LRange := LWorksheet.range['AF'+IntToStr(LIdx)];
        LDoc.UsedAmount := LRange.FormulaR1C1;

        LRange := LWorksheet.range['AG'+IntToStr(LIdx)];
        LDoc.SpareAmount := LRange.FormulaR1C1;

        LDoc.PartUnit := 'EA';

        LDoc.MSNo := LDoc.SectionNo + '-' + LDoc.PartNo;

        LRange := LWorksheet.range['AI'+IntToStr(LIdx)];

        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS4000ApplyNo := '0';
          LDoc.HRS4000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS4000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS4000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS4000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS4000ApplyNo := Trim(LStr2);
        end;

        LRange := LWorksheet.range['AJ'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS8000ApplyNo := '0';
          LDoc.HRS8000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS8000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS8000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS8000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS8000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AK'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS12000ApplyNo := '0';
          LDoc.HRS12000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS12000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS12000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS12000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS12000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AL'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS16000ApplyNo := '0';
          LDoc.HRS16000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS16000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS16000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS16000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS16000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AM'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS20000ApplyNo := '0';
          LDoc.HRS20000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS20000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS20000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS20000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS20000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AN'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS24000ApplyNo := '0';
          LDoc.HRS24000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS24000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS24000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS24000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS24000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AO'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS28000ApplyNo := '0';
          LDoc.HRS28000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS28000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS28000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS28000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS28000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AP'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS32000ApplyNo := '0';
          LDoc.HRS32000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS32000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS32000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS32000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS32000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AQ'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS36000ApplyNo := '0';
          LDoc.HRS36000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS36000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS36000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS36000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS36000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AR'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS40000ApplyNo := '0';
          LDoc.HRS40000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS40000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS40000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS40000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS40000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AS'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS44000ApplyNo := '0';
          LDoc.HRS44000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS44000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS44000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS44000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS44000ApplyNo := LStr2;
        end;

        LRange := LWorksheet.range['AT'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS48000ApplyNo := '0';
          LDoc.HRS48000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS48000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS48000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS48000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS48000ApplyNo := Trim(LStr2);
        end;

        LRange := LWorksheet.range['AU'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS60000ApplyNo := '0';
          LDoc.HRS60000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS60000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS60000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS60000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS60000ApplyNo := Trim(LStr2);
        end;

        LRange := LWorksheet.range['AV'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS72000ApplyNo := '0';
          LDoc.HRS72000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS72000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS72000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS72000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS72000ApplyNo := Trim(LStr2);
        end;

        LRange := LWorksheet.range['AW'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS88000ApplyNo := '0';
          LDoc.HRS88000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS88000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS88000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS88000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS88000ApplyNo := Trim(LStr2);
        end;

        LRange := LWorksheet.range['AX'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.HRS100000ApplyNo := '0';
          LDoc.HRS100000Formula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.HRS100000Formula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.HRS100000Formula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.HRS100000Formula := '*';
            LStr2 := '1';
          end;

          LDoc.HRS100000ApplyNo := Trim(LStr2);
        end;

        LRange := LWorksheet.range['AY'+IntToStr(LIdx)];
        if (LRange.FormulaR1C1 = '-') or (LRange.FormulaR1C1 = '')  then
        begin
          LDoc.RetrofitApplyNo := '0';
          LDoc.RetrofitFormula := '*';
        end
        else
        begin
          LStr2 := LRange.Formula;
          strToken(LStr2, ')');

          if Pos('*', LStr2) <> 0 then
          begin
            LDoc.RetrofitFormula := '*';
            strToken(LStr2, '*');
          end
          else
          if Pos('+', LStr2) <> 0 then
          begin
            LDoc.RetrofitFormula := '+';
            strToken(LStr2, '+');
          end
          else
          begin
            LDoc.RetrofitFormula := '*';
            LStr2 := '1';
          end;

          LDoc.RetrofitApplyNo := Trim(LStr2);
        end;

        AddHimsenWaringSpareMFromVariant(LDoc, ATierStep);
      end;

      Inc(LIdx);
      LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
    finally
      HimsenWearSpareQF.SplashScreen1.Hide;
    end;
  end;

  LWorkBook.Close;
  LExcel.Quit;
end;

end.
