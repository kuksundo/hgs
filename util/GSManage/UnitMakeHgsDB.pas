unit UnitMakeHgsDB;

interface

uses Sysutils, Dialogs, Classes, UnitExcelUtil, Syncommons, Forms,
  UnitVesselMasterRecord, UnitStringUtil, UnitFileSearchUtil, CommonData,
  UnitVesselData;

procedure ImportVesselMasterFromXlsFile(AFileName: string);
procedure ImportVesselDeliveryFromXlsFile(AFileName: string);
procedure ImportVesselGuaranteePerionNDeliveryDateFromXlsFile(AFileName: string);
procedure ImportNationListFromXlsFile(AFileName: string);
procedure ImportNationNameKOFromXlsFile(AFileName: string);
procedure ImportNationFlagIconFromFolder(AFolderName: string);
procedure ImportNationFlagImageFromFolder(AFolderName: string);
procedure ImportEngineMasterFromXlsFile(AFileName: string);
procedure ImportGeneratorMasterFromXlsFile(AFileName: string);

procedure UpdateInstalledProductInVesselMasterFromEngineMaster;
procedure RemoveGEFromInstalledProductInVesselMaster;

implementation

uses FrmVesselList, UnitNationRecord, UnitEngineMasterRecord, UnitGeneratorRecord,
  UnitEngineMasterData;//, Vcl.Imaging.PngImage;

procedure ImportVesselMasterFromXlsFile(AFileName: string);
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'A';
  LIdx := 2;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LRange.FormulaR1C1 <> '' do
  begin
    VesselListF.SplashScreen1.BeginUpdate;
    VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
    VesselListF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
    VesselListF.SplashScreen1.EndUpdate;
    VesselListF.SplashScreen1.Show;

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
    LDoc.TechManagerCountry := LRange.FormulaR1C1;
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
    LRange := LWorksheet.range['T'+IntToStr(LIdx)];
    LDoc.SpecialSurveyDueDate := LRange.Value;
    LRange := LWorksheet.range['U'+IntToStr(LIdx)];
    LDoc.DockingSurveyDueDate := LRange.Value;

    LDoc.ShipTypeDesc := '';
    LDoc.DeliveryDate := '';
    LDoc.LastDryDockDate := '';

    //    if (LDoc.VesselStatus <> '') and (LDoc.VesselStatus <> 'Broken Up') then
    if LDoc.IMONo <> '' then
      AddOrUpdateVesselMasterFromVariant(LDoc);
//      AddVesselMasterFromVariant(LDoc);

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  VesselListF.SplashScreen1.Hide;
  LWorkBook.Close;
  LExcel.Quit;
end;

procedure ImportVesselDeliveryFromXlsFile(AFileName: string);
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'B';
  LIdx := 2;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LRange.FormulaR1C1 <> '' do
  begin
    VesselListF.SplashScreen1.BeginUpdate;
    VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
    VesselListF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
    VesselListF.SplashScreen1.EndUpdate;
    VesselListF.SplashScreen1.Show;

    LDoc.ShipBuilderName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    LDoc.HullNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['J'+IntToStr(LIdx)];

    if LRange.FormulaR1C1 = '' then
      LRange := LWorksheet.range['I'+IntToStr(LIdx)];

    LDoc.DeliveryDate := LRange.Value;
    LRange := LWorksheet.range['L'+IntToStr(LIdx)];
    LDoc.ShipTypeDesc := LRange.FormulaR1C1;
    LRange := LWorksheet.range['D'+IntToStr(LIdx)];
    LDoc.ShipName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['K'+IntToStr(LIdx)];
    LDoc.ShipType := LRange.FormulaR1C1;
    LRange := LWorksheet.range['M'+IntToStr(LIdx)];
    LDoc.SClass1 := LRange.FormulaR1C1;

    if LDoc.ShipBuilderName = '현중' then
    begin
      LDoc.HullNo := 'HHI' + LDoc.HullNo;
      LDoc.ShipBuilderName := '현대중공업(주)';
    end
    else
    if LDoc.ShipBuilderName = '삼호' then
    begin
      LDoc.HullNo := 'SHI' + LDoc.HullNo;
      LDoc.ShipBuilderName := '현대삼호중공업(주)';
    end
    else
    if LDoc.ShipBuilderName = '미포' then
    begin
      LDoc.HullNo := 'HMD' + LDoc.HullNo;
      LDoc.ShipBuilderName := '(주)현대미포조선';
    end;

    AddOrUpdateVesselDeliveryDateFromVariant(LDoc);

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  VesselListF.SplashScreen1.Hide;
  LWorkBook.Close;
  LExcel.Quit;
end;

procedure ImportVesselGuaranteePerionNDeliveryDateFromXlsFile(AFileName: string);
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'C';
  LIdx := 2;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LRange.FormulaR1C1 <> '' do
  begin
    VesselListF.SplashScreen1.BeginUpdate;
    VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
    VesselListF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
    VesselListF.SplashScreen1.EndUpdate;
    VesselListF.SplashScreen1.Show;

    LRange := LWorksheet.range['AA'+IntToStr(LIdx)];
    LDoc.IMONo := LRange.FormulaR1C1;

    if LDoc.IMONo <> '' then
    begin
      LRange := LWorksheet.range['Q'+IntToStr(LIdx)];
      LDoc.DeliveryDate := LRange.Value;
      LRange := LWorksheet.range['R'+IntToStr(LIdx)];
      LDoc.GuaranteePeriod := LRange.Value;

      AddOrUpdateVesselGPNDeliveryDateFromVariant(LDoc);
    end;

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  VesselListF.SplashScreen1.Hide;
  LWorkBook.Close;
  LExcel.Quit;
end;

procedure ImportNationListFromXlsFile(AFileName: string);
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'A';
  LIdx := 2;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LRange.FormulaR1C1 <> '' do
  begin
    VesselListF.SplashScreen1.BeginUpdate;
    VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
    VesselListF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
    VesselListF.SplashScreen1.EndUpdate;
    VesselListF.SplashScreen1.Show;

    LDoc.NationName_EN := LRange.FormulaR1C1;

    LRange := LWorksheet.range['D'+IntToStr(LIdx)];
    LDoc.NationNumeric := LRange.FormulaR1C1;
    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    LDoc.NationAlpha3 := LRange.FormulaR1C1;
    LRange := LWorksheet.range['B'+IntToStr(LIdx)];
    LDoc.NationAlpha2 := LRange.FormulaR1C1;
    LRange := LWorksheet.range['E'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.Independent := LStr2 = 'Yes';
    LDoc.NationName_KO := '';
    LDoc.Continent := 0;
//    LDoc.FlagImage := '';
//    LDoc.UpdateDate := DateToStr(now);

    AddNationFromVariant(LDoc);

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  VesselListF.SplashScreen1.Hide;
  LWorkBook.Close;
  LExcel.Quit;
end;

procedure ImportNationNameKOFromXlsFile(AFileName: string);
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'A';
  LIdx := 2;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LRange.FormulaR1C1 <> '' do
  begin
    VesselListF.SplashScreen1.BeginUpdate;
    VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
    VesselListF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
    VesselListF.SplashScreen1.EndUpdate;
    VesselListF.SplashScreen1.Show;

    LDoc.NationName_KO := LRange.FormulaR1C1;

    LRange := LWorksheet.range['D'+IntToStr(LIdx)];
    LDoc.NationAlpha2 := LRange.FormulaR1C1;

    AddOrUpdateNationNameKOFromVariant(LDoc);

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  VesselListF.SplashScreen1.Hide;
  LWorkBook.Close;
  LExcel.Quit;
end;

procedure ImportNationFlagIconFromFolder(AFolderName: string);
var
  LSQLNationRecord: TSQLNationRecord;
  LNationName_EN, LFileName: string;
  LStream: TMemoryStream;
  LImage: RawByteString;
  LIdx, LLastRow: integer;
//  LImage: TPngImage;
begin
  if AFolderName = '' then
    AFolderName := ExtractFilePath(Application.ExeName);

  LStream := TMemoryStream.Create;
//  LImage := TPngImage.Create;
  LSQLNationRecord := TSQLNationRecord.CreateAndFillPrepare(g_NationDB,
    'ID > ?', [0]);
  try
    LLastRow := LSQLNationRecord.FillTable.RowCount;

    while LSQLNationRecord.FillOne do
    begin
      VesselListF.SplashScreen1.BeginUpdate;
      VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from Folder...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
      VesselListF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
      VesselListF.SplashScreen1.EndUpdate;
      VesselListF.SplashScreen1.Show;

      LFileName := '';
      LNationName_EN := LSQLNationRecord.NationName_EN;
      LFileName := GetFirstFileNameIfExist(AFolderName, '*' + LNationName_EN + '*');

      if LFileName <> '' then
      begin
        LImage := StringFromFile(LFileName);
        g_NationDB.UpdateBlob(TSQLNationRecord, LSQLNationRecord.ID, 'FlagIcon', LImage);
      end;

      Inc(LIdx);
    end;
  finally
    VesselListF.SplashScreen1.Hide;
//    LImage.Free;
    LStream.Free;
    LSQLNationRecord.Free;
  end;
end;

procedure ImportNationFlagImageFromFolder(AFolderName: string);
var
  LSQLNationRecord: TSQLNationRecord;
  LNationAlpha3, LFileName: string;
  LStream: TMemoryStream;
  LImage: RawByteString;
  LIdx, LLastRow: integer;
//  LImage: TPngImage;
begin
  if AFolderName = '' then
    AFolderName := ExtractFilePath(Application.ExeName);

  LStream := TMemoryStream.Create;
//  LImage := TPngImage.Create;
  LSQLNationRecord := TSQLNationRecord.CreateAndFillPrepare(g_NationDB,
    'ID > ?', [0]);
  try
    LLastRow := LSQLNationRecord.FillTable.RowCount;

    while LSQLNationRecord.FillOne do
    begin
      VesselListF.SplashScreen1.BeginUpdate;
      VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from Folder...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
      VesselListF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
      VesselListF.SplashScreen1.EndUpdate;
      VesselListF.SplashScreen1.Show;

      LFileName := '';
      LNationAlpha3 := LSQLNationRecord.NationAlpha3;
      LFileName := GetFirstFileNameIfExist(AFolderName, '*' + LNationAlpha3 + '*');

      if LFileName <> '' then
      begin
        LImage := StringFromFile(LFileName);
        g_NationDB.UpdateBlob(TSQLNationRecord, LSQLNationRecord.ID, 'FlagImage', LImage);
      end;

      Inc(LIdx);
    end;
  finally
    VesselListF.SplashScreen1.Hide;
//    LImage.Free;
    LStream.Free;
    LSQLNationRecord.Free;
  end;
end;

procedure ImportEngineMasterFromXlsFile(AFileName: string);
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
  LLastRow := GetLastRowNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'B';
  LIdx := 2;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LRange.FormulaR1C1 <> '' do
  begin
    VesselListF.SplashScreen1.BeginUpdate;
    VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
    VesselListF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
    VesselListF.SplashScreen1.EndUpdate;
    VesselListF.SplashScreen1.Show;

    LDoc.ProjectNo := LRange.FormulaR1C1;

    LRange := LWorksheet.range['A'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;

    if LStr2 = '' then
    begin
      Inc(LIdx);
      LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
      continue;
    end;

    LDoc.HullNo := LStr2;
    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    LDoc.ProjectName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['E'+IntToStr(LIdx)];
    LDoc.ProductType := g_EngineProductType.ToOrdinal(LRange.FormulaR1C1);
    LRange := LWorksheet.range['I'+IntToStr(LIdx)];
    LDoc.Mark := LRange.FormulaR1C1;
    LRange := LWorksheet.range['G'+IntToStr(LIdx)];
    LDoc.ProductModel := LRange.FormulaR1C1;
    LRange := LWorksheet.range['X'+IntToStr(LIdx)];
    LDoc.Usage := LRange.FormulaR1C1;
    LRange := LWorksheet.range['R'+IntToStr(LIdx)];
    LDoc.Class1 := LRange.FormulaR1C1;
    LRange := LWorksheet.range['S'+IntToStr(LIdx)];
    LDoc.Class2 := LRange.FormulaR1C1;
    LRange := LWorksheet.range['F'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.CylCount := StrToIntDef(LStr2,0);
    LRange := LWorksheet.range['H'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.Bore := StrToIntDef(LStr2,0);
    LRange := LWorksheet.range['J'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.Tier := StrToIntDef(LStr2,0);
    LRange := LWorksheet.range['M'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.MCR_KW := StrToIntDef(LStr2,0);
    LRange := LWorksheet.range['N'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.BHP := StrToIntDef(LStr2,0);
    LRange := LWorksheet.range['O'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.RPM := StrToIntDef(LStr2,0);
    LRange := LWorksheet.range['P'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.InstalledCount := StrToIntDef(LStr2,0);
    LRange := LWorksheet.range['AB'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.WarrantyMonth1 := StrToIntDef(LStr2,0);
    LRange := LWorksheet.range['AC'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    LDoc.WarrantyMonth2 := StrToIntDef(LStr2,0);
    LRange := LWorksheet.range['Y'+IntToStr(LIdx)];
    LDoc.ProductDeliveryDate := LRange.Value;
    LRange := LWorksheet.range['Z'+IntToStr(LIdx)];
    LDoc.ShipDeliveryDate := LRange.Value;
    LRange := LWorksheet.range['AA'+IntToStr(LIdx)];
    LDoc.WarrantyDueDate := LRange.Value;
    LDoc.IMONo := '';

//    AddOrUpdateEngineMasterFromVariant(LDoc);
    AddOrUpdateEngineMasterFromVariant(LDoc, True);

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  VesselListF.SplashScreen1.Hide;
  LWorkBook.Close;
  LExcel.Quit;
end;

procedure ImportGeneratorMasterFromXlsFile(AFileName: string);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2: string;
  LIdx, LLastRow: integer;
  LDoc: Variant;
  LSQLVesselMaster: TSQLVesselMaster;
  LYear, LMon, LDay: string;
  Ly, Lm, Ld: word;
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
  LIdx := 2;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while LRange.FormulaR1C1 <> '' do
  begin
    VesselListF.SplashScreen1.BeginUpdate;
    VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(LIdx) + '/' + IntToStr(LLastRow) + ')';
    VesselListF.SplashScreen1.ProgressBar.Position := LIdx/LLastRow*100;
    VesselListF.SplashScreen1.EndUpdate;
    VesselListF.SplashScreen1.Show;

    LDoc.ProjectNo := LRange.FormulaR1C1;

    LRange := LWorksheet.range['B'+IntToStr(LIdx)];
    LDoc.ProjectName := LRange.FormulaR1C1;;
    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    LDoc.SpecDesc := LRange.FormulaR1C1;
    LRange := LWorksheet.range['D'+IntToStr(LIdx)];
    LDoc.ModelNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['E'+IntToStr(LIdx)];
    LDoc.QuantyPerShip := LRange.FormulaR1C1;
    LRange := LWorksheet.range['F'+IntToStr(LIdx)];
    LDoc.ClassSociety := LRange.FormulaR1C1;
    LRange := LWorksheet.range['H'+IntToStr(LIdx)];
    LStr2 := LRange.FormulaR1C1;
    if LStr2 <> '' then
    begin
      LStr2 := InsertSymbols(LStr2, '-', 6);
      LStr2 := InsertSymbols(LStr2, '-', 4);

      LYear := strToken(LStr2,'-');
      LMon := strToken(LStr2,'-');
      LDay := strToken(LStr2,'-');
      Ly := StrToInt(LYear);
      Lm := StrToInt(LMon);
      Ld := StrToInt(LDay);
      LDoc.ProductDate := TimeLogFromDateTime(EncodeDate(Ly, Lm, Ld));
    end
    else
      LDoc.ProductDate := 0;
    LRange := LWorksheet.range['O'+IntToStr(LIdx)];
    LDoc.HullNo := Trim(LRange.FormulaR1C1);
    LRange := LWorksheet.range['L'+IntToStr(LIdx)];
    LDoc.OutputCapacity := LRange.FormulaR1C1;
    LRange := LWorksheet.range['M'+IntToStr(LIdx)];
    LDoc.Voltage := LRange.FormulaR1C1;
    LDoc.InstallDate := 0;
    LSQLVesselMaster := GetVesselMasterFromHullNo(LDoc.HullNo);
    try
      if LSQLVesselMaster.IsUpdate then
      begin
        LDoc.TaskID := LSQLVesselMaster.TaskID;

        if not (shptGEN in LSQLVesselMaster.InstalledProductTypes) then
        begin
          LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes + [shptGEN];
          AddOrUpdateVesselMaster(LSQLVesselMaster);
        end;
      end
      else
        LDoc.TaskID := 0;

      AddGeneratorFromVariant(LDoc);
    finally
      LSQLVesselMaster.Free;
    end;

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  VesselListF.SplashScreen1.Hide;
  LWorkBook.Close;
  LExcel.Quit;
end;

procedure UpdateInstalledProductInVesselMasterFromEngineMaster;
var
  LSQLVesselMaster: TSQLVesselMaster;
  LSQLEngineMaster:TSQLEngineMaster;
  LIsUpdate: Boolean;
begin
  LSQLEngineMaster := GetEngineMasterFromHullNo('');
  try
    LSQLEngineMaster.FillRewind;

    while LSQLEngineMaster.FillOne do
    begin
      LSQLVesselMaster := GetVesselMasterFromHullNo(LSQLEngineMaster.HullNo);
      try
        if LSQLVesselMaster.IsUpdate then
        begin
//          LSQLEngineMaster.TaskID := LSQLVesselMaster.TaskID;
          LIsUpdate := False;

          if pos('KA2', LSQLEngineMaster.Usage) > 0  then
          begin
            if not (shptME in LSQLVesselMaster.InstalledProductTypes) then
            begin
              LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes + [shptME];
              LIsUpdate := True;
            end;
          end
          else
          if pos('KB2', LSQLEngineMaster.Usage) > 0  then
          begin
            if not (shptGE in LSQLVesselMaster.InstalledProductTypes) then
            begin
              LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes + [shptGE];
              LIsUpdate := True;
            end;
//            LSQLEngineMaster.IMONo := LSQLVesselMaster.IMONo;
//            AddOrUpdateEngineMaster(LSQLEngineMaster);
          end
          else
          if pos('KF23', LSQLEngineMaster.Usage) > 0  then
          begin
            if not (shptSCR in LSQLVesselMaster.InstalledProductTypes) then
            begin
              LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes + [shptSCR];
              LIsUpdate := True;
            end;
          end
          else
          if pos('KF25', LSQLEngineMaster.Usage) > 0  then
          begin
            if not (shptBWTS in LSQLVesselMaster.InstalledProductTypes) then
            begin
              LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes + [shptBWTS];
              LIsUpdate := True;
            end;
          end
          else
          if pos('KF21', LSQLEngineMaster.Usage) > 0  then
          begin
            if not (shptFGSS in LSQLVesselMaster.InstalledProductTypes) then
            begin
              LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes + [shptFGSS];
              LIsUpdate := True;
            end;
          end
          else
          if pos('KH2S', LSQLEngineMaster.Usage) > 0  then
          begin
            if not (shptCOPT in LSQLVesselMaster.InstalledProductTypes) then
            begin
              LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes + [shptCOPT];
              LIsUpdate := True;
            end;
          end
          else
          if pos('KD21', LSQLEngineMaster.Usage) > 0  then
          begin
            if not (shptPROPELLER in LSQLVesselMaster.InstalledProductTypes) then
            begin
              LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes + [shptPROPELLER];
              LIsUpdate := True;
            end;
          end
          else
          if pos('KF27', LSQLEngineMaster.Usage) > 0  then
          begin
            if not (shptEGR in LSQLVesselMaster.InstalledProductTypes) then
            begin
              LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes + [shptEGR];
              LIsUpdate := True;
            end;
          end;

          if LIsUpdate then
            AddOrUpdateVesselMaster(LSQLVesselMaster);
        end;
      finally
        LSQLVesselMaster.Free;
      end;
    end;
  finally
    LSQLEngineMaster.Free;
  end;
end;

procedure RemoveGEFromInstalledProductInVesselMaster;
var
  LSQLVesselMaster: TSQLVesselMaster;
begin
  LSQLVesselMaster := GetVesselMasterFromHullNo('');
  try
    LSQLVesselMaster.FillRewind;
    
    while LSQLVesselMaster.FillOne do
    begin
      if shptGE in LSQLVesselMaster.InstalledProductTypes then
      begin
        LSQLVesselMaster.InstalledProductTypes := LSQLVesselMaster.InstalledProductTypes - [shptGE];
        LSQLVesselMaster.IsUpdate := True;
        AddOrUpdateVesselMaster(LSQLVesselMaster);
      end;
    end;
  finally
    LSQLVesselMaster.Free;
  end;
end;

end.
