unit UnitMakeHgsDB;

interface

uses Sysutils, Dialogs, Classes, UnitExcelUtil, Syncommons, Forms,
  UnitVesselMasterRecord, UnitStringUtil, UnitFileSearchUtil, CommonData,
  UnitVesselData;

procedure ImportVesselMasterFromXlsFile(AFileName: string);
procedure ImportVesselMasterFromMapsExportedXlsFile(AFileName: string);
procedure ImportVesselMasterFromMapsExportedXlsFile2(AFileName: string);
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
  UnitEngineMasterData, UnitmORMotUtil;

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

    LRange := LWorksheet.range['B'+IntToStr(LIdx)];
    LDoc.HullNo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['C'+IntToStr(LIdx)];
    LDoc.ShipName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['D'+IntToStr(LIdx)];
    LDoc.IMONo := LRange.FormulaR1C1;
    LRange := LWorksheet.range['E'+IntToStr(LIdx)];
    LDoc.SClass1 := LRange.FormulaR1C1;
    LRange := LWorksheet.range['F'+IntToStr(LIdx)];
    LDoc.SClass2 := LRange.FormulaR1C1;
    LRange := LWorksheet.range['G'+IntToStr(LIdx)];
    LDoc.ShipType := LRange.FormulaR1C1;
    LRange := LWorksheet.range['H'+IntToStr(LIdx)];
    LDoc.OwnerID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['I'+IntToStr(LIdx)];
    LDoc.OwnerName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['J'+IntToStr(LIdx)];
    LDoc.TechManagerCountry := LRange.FormulaR1C1;
    LRange := LWorksheet.range['K'+IntToStr(LIdx)];
    LDoc.TechManagerID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['L'+IntToStr(LIdx)];
    LDoc.TechManagerName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['M'+IntToStr(LIdx)];
    LDoc.OperatorID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['N'+IntToStr(LIdx)];
    LDoc.OperatorName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['O'+IntToStr(LIdx)];
    LDoc.BuyingCompanyCountry := LRange.FormulaR1C1;
    LRange := LWorksheet.range['P'+IntToStr(LIdx)];
    LDoc.BuyingCompanyID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['Q'+IntToStr(LIdx)];
    LDoc.BuyingCompanyName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['R'+IntToStr(LIdx)];
    LDoc.ShipBuilderID := LRange.FormulaR1C1;
    LRange := LWorksheet.range['S'+IntToStr(LIdx)];
    LDoc.ShipBuilderName := LRange.FormulaR1C1;
    LRange := LWorksheet.range['T'+IntToStr(LIdx)];
    LDoc.VesselStatus := LRange.FormulaR1C1;
    LRange := LWorksheet.range['U'+IntToStr(LIdx)];
    LDoc.SpecialSurveyDueDate := LRange.Value;
    LRange := LWorksheet.range['V'+IntToStr(LIdx)];
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

procedure ImportVesselMasterFromMapsExportedXlsFile2(AFileName: string);
const
  VesselListDBColumnAry : array[0..49] of string =
    ('VesselSanction', 'InstalledLocation', 'HullNo', 'ShipName', 'IMONo', 'ShipType', 'CargoSize', //6
     'GroupOwnerSanction', 'GroupOwnerCountry', 'GroupOwnerID',//9
     'GroupOwnerName', 'TechManagerSanction', 'TechManagerCountry', 'TechManagerID', 'TechManagerName',//14
     'OperatorSanction', 'OperatorCountry', 'OperatorID',//17
     'OperatorName', 'BuyingCompanySanction',//19
     'BuyingCompanyCountry', 'BuyingCompanyID', 'BuyingCompanyName',//22
     'ShipManagerSanction', 'ShipManagerCountry','ShipManagerID', 'ShipManagerName',//26
     'DocCompanySanction', 'DocCompCountry','DocCompID', 'DocCompanyName.',//30
     'RegOwnerSanction', 'RegOwnerCountry','RegOwnerID', 'RegOwnerName',//34
     'BareOwnerSanction', 'BareOwnerCountry','BareOwnerID', 'BareOwnerName',//38
     'ShipBuilderID',//39
     'ShipBuilderName', 'VesselStatus', 'DeliveryDate', 'SClass1', 'SpecialSurveyDueDate',//44
     'DockingSurveyDueDate', 'SClass2', 'SpecialSurveyDueDate2', 'DockingSurveyDueDate2', 'UpdatedDate');//49
var
  LCsvFile: string;
  LDoc: Variant;
  LCSVDynUtf8: TRawUTF8DynArray;
  LCSVDynArr: TDynArray;
  LCSVUtf8: RawUTF8;
  LStrList: TStringList;
  i,j,LLastRow: integer;
begin
//  XlsStrFindAndReplaceAll(AFileName, ',', '|');
  LCsvFile := XlsSave2CSV(AFileName);

  if LCsvFile = '' then
    exit;

  LStrList := TStringList.Create;
  try
    TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);
    LCSVDynArr.Init(TypeInfo(TRawUTF8DynArray), LCSVDynUtf8);

    LStrList.LoadFromFile(LCsvFile);
//    LStrList.Text := StringReplace(LStrList.Text, ',', '|', [rfReplaceAll, rfIgnoreCase]);
    LLastRow := LStrList.Count;

    for i := 1 to LLastRow - 1 do
    begin
      VesselListF.SplashScreen1.BeginUpdate;
      VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(i+1) + '/' + IntToStr(LLastRow) + ')';
      VesselListF.SplashScreen1.ProgressBar.Position := (i+1)/LLastRow*100;
      VesselListF.SplashScreen1.EndUpdate;
      VesselListF.SplashScreen1.Show;

      LCSVUtf8 := StringToUTF8(LStrList.Strings[i]);
      CSVToRawUTF8DynArray(PUTF8Char(LCSVUtf8),LCSVDynUtf8,'|', False,True);

      for j := Low(LCSVDynUtf8) to High(LCSVDynUtf8) do
        if VesselListDBColumnAry[j] <> '' then
          TDocVariantData(LDoc).Value[VesselListDBColumnAry[j]] := LCSVDynUtf8[j];

      LDoc.ShipTypeDesc := '';
      LDoc.UpdatedDate := TimeLogFromDateTime(now);

      if LDoc.IMONo <> '' then
        AddOrUpdateVesselMasterFromVariant(LDoc);

      LCSVDynArr.Clear;
    end;
  finally
    LStrList.Free;
    VesselListF.SplashScreen1.Hide;
  end;
end;

procedure ImportVesselMasterFromMapsExportedXlsFile(AFileName: string);
const
  VesselListDBColumnAry : array[0..49] of string =
    ('VesselSanction', 'InstalledLocation', 'HullNo', 'ShipName', 'IMONo', 'ShipType', 'CargoSize',
     'GroupOwnerSanction', 'GroupOwnerCountry', 'GroupOwnerID',
     'GroupOwnerName', 'TechManagerSanction', 'TechManagerCountry', 'TechManagerID', 'TechManagerName',
     'OperatorSanction', 'OperatorCountry', 'OperatorID',
     'OperatorName', 'BuyingCompanySanction',
     'BuyingCompanyCountry', 'BuyingCompanyID', 'BuyingCompanyName',
     'ShipManagerSanction', 'ShipManagerCountry','ShipManagerID', 'ShipManagerName',
     'DocCompanySanction', 'DocCompCountry','DocCompID', 'DocCompanyName.',
     'RegOwnerSanction', 'RegOwnerCountry','RegOwnerID', 'RegOwnerName',
     'BareOwnerSanction', 'BareOwnerCountry','BareOwnerID', 'BareOwnerName',
     'ShipBuilderID',
     'ShipBuilderName', 'VesselStatus', 'DeliveryDate', 'SClass1', 'SpecialSurveyDueDate',
     'DockingSurveyDueDate', 'SClass2', 'SpecialSurveyDueDate2', 'DockingSurveyDueDate2', 'UpdatedDate');

  VesselListExcelColumnAry : array[0..49] of string =
    ('Vessel Sanction', '설치위치', '호선번호', '호선명', 'IMO No.', '선종', '선형',
     'Group Owner Sacntion', 'Group Owner Country', 'Group Owner ID',
     'Group Owner', 'Tech. Manager Sanction', 'Tech. Manager Country', 'Tech. Manager ID', 'Tech. Manager',
     'Operator Sanction', 'Operator Country', 'Operator ID',
     'Operator', 'Buying Co. Sanction',
     'Buying Company Country', 'Buying Company ID', 'Buying Company',
     'Ship Manager Sanction', 'Ship Manager Country','Ship Manager ID', 'Ship Manager',
     'Doc. Company Sanction', 'Doc. Comp. Country','Doc. Comp. ID', 'Doc. Comp.',
     'Reg. Owner Sanction', 'Reg. Owner Country','Reg. Owner ID', 'Reg. Owner',
     'Bare. Owner Sanction', 'Bare. Owner Country','Bare. Owner ID', 'Bare. Owner',
     '조선소 ID',
     '조선소명', '상태', '선박인도일', '선급1', 'Special Survey Due 1',
     'Docking Survey Due 1', '선급2', 'Special Survey Due 2', 'Docking Survey Due 2', 'UpdatedDate');
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LStr, LStr2, LColNoChar: string;
  i, LCol, LRow, LLastRow, LLastColumn: integer;
  LDoc: Variant;
  LExcelColumnList, LDBColumnIndexList: TStringList;

  procedure BuildColumnIndexList;
  var
    Li: integer;
    LColChar: string;
  begin
    LColChar := 'A';

    for Li := 1 to LLastColumn do
    begin
      LRange := LWorksheet.range[LColChar+'1'];
      LStr2 := LRange.FormulaR1C1;
      LCol := LExcelColumnList.IndexOf(LStr2);

      if LCol <> -1 then
      begin
        LColNoChar := GetExcelColumnAlphabetByInt(LCol+1);
        LDBColumnIndexList.AddObject(LColNoChar, TObject(LCol));
      end;

      LColChar := GetIncXLColumn(LColChar);
    end;
  end;
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
  LLastColumn := GetLastColNumFromExcel(LWorkSheet);
  TDocVariant.New(LDoc, [dvoReturnNullForUnknownProperty]);

  LStr := 'A';
//  LRow := 2;

  LExcelColumnList := TStringList.Create;
  LDBColumnIndexList := TStringList.Create;

  try
    for i := Low(VesselListExcelColumnAry) to High(VesselListExcelColumnAry) do
      LExcelColumnList.Add(VesselListExcelColumnAry[i]);

    BuildColumnIndexList();

//    while LRange.FormulaR1C1 <> '' do
    for LRow := 2 to LLastRow do
    begin
      VesselListF.SplashScreen1.BeginUpdate;
      VesselListF.SplashScreen1.BasicProgramInfo.ProgramName.Text := 'Importing Data from xls...(' + IntToStr(LRow) + '/' + IntToStr(LLastRow) + ')';
      VesselListF.SplashScreen1.ProgressBar.Position := LRow/LLastRow*100;
      VesselListF.SplashScreen1.EndUpdate;
      VesselListF.SplashScreen1.Show;

//      LColNoChar := '';

      for i := 0 to LDBColumnIndexList.Count - 1 do
      begin
        LColNoChar := LDBColumnIndexList.Strings[i];
        LRange := LWorksheet.range[LColNoChar+IntToStr(LRow)];
        LCol := Integer(LDBColumnIndexList.Objects[i]);

        if VesselListDBColumnAry[LCol] <> '' then
          TDocVariantData(LDoc).Value[VesselListDBColumnAry[LCol]] := LRange.FormulaR1C1;
      end;//for

//      LRange := LWorksheet.range['B'+IntToStr(LIdx)];
//      LDoc.HullNo := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['C'+IntToStr(LIdx)];
//      LDoc.ShipName := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['D'+IntToStr(LIdx)];
//      LDoc.IMONo := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['E'+IntToStr(LIdx)];
//      LDoc.ShipType := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['F'+IntToStr(LIdx)];
//      LDoc.OwnerID := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['G'+IntToStr(LIdx)];
//      LDoc.OwnerName := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['H'+IntToStr(LIdx)];
//      LDoc.TechManagerCountry := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['I'+IntToStr(LIdx)];
//      LDoc.TechManagerID := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['J'+IntToStr(LIdx)];
//      LDoc.TechManagerName := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['K'+IntToStr(LIdx)];
//      LDoc.OperatorID := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['L'+IntToStr(LIdx)];
//      LDoc.OperatorName := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['M'+IntToStr(LIdx)];
//      LDoc.BuyingCompanyCountry := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['N'+IntToStr(LIdx)];
//      LDoc.BuyingCompanyID := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['O'+IntToStr(LIdx)];
//      LDoc.BuyingCompanyName := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['P'+IntToStr(LIdx)];
//      LDoc.ShipBuilderID := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['Q'+IntToStr(LIdx)];
//      LDoc.ShipBuilderName := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['R'+IntToStr(LIdx)];
//      LDoc.VesselStatus := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['S'+IntToStr(LIdx)];
//      LStr2 := LRange.Value;
//      LDoc.DeliveryDate := GetTimeLogFromStr(LStr2);
//      LRange := LWorksheet.range['T'+IntToStr(LIdx)];
//      LDoc.SClass1 := LRange.FormulaR1C1;
//      LRange := LWorksheet.range['U'+IntToStr(LIdx)];
//      LStr2 := LRange.Value;
//      LDoc.SpecialSurveyDueDate := GetTimeLogFromStr(LStr2);
//      LRange := LWorksheet.range['V'+IntToStr(LIdx)];
//      LStr2 := LRange.Value;
//      LDoc.DockingSurveyDueDate := GetTimeLogFromStr(LStr2);
//      LRange := LWorksheet.range['W'+IntToStr(LIdx)];
//      LDoc.SClass2 := LRange.FormulaR1C1;

      LDoc.ShipTypeDesc := '';
      LDoc.UpdatedDate := TimeLogFromDateTime(now);

      //    if (LDoc.VesselStatus <> '') and (LDoc.VesselStatus <> 'Broken Up') then
      if LDoc.IMONo <> '' then
        AddOrUpdateVesselMasterFromVariant(LDoc);

//      Inc(LRow);
//      LRange := LWorksheet.range['A'+IntToStr(LRow)];
    end;//for
  finally
    LExcelColumnList.Free;
    LDBColumnIndexList.Free;
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
