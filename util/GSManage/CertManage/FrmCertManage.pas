unit FrmCertManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBaseDlg, JvSelectDirectory,
  Vcl.ExtCtrls, AdvSmoothSplashScreen, Vcl.Menus, Vcl.ImgList, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, SBPro,
  AdvOfficeTabSet, Vcl.StdCtrls, AeroButtons, Vcl.ComCtrls, JvExControls,
  JvLabel, CurvyControls,
  UnitVesselData, UnitHGSCertRecord, UnitHGSCertData, AdvGroupBox,
  AdvOfficeButtons;

type
  TCertManageF = class(TForm)
    Splitter1: TSplitter;
    CurvyPanel1: TCurvyPanel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel3: TJvLabel;
    TraineeNameEdit: TEdit;
    CompanyNameEdit: TEdit;
    SubjectEdit: TEdit;
    Panel1: TPanel;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    AeroButton1: TAeroButton;
    CourseEdit: TEdit;
    TaskTab: TAdvOfficeTabSet;
    StatusBarPro1: TStatusBarPro;
    CertListGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    TrainedCourse: TNxTextColumn;
    UntilValidity: TNxTextColumn;
    ProductType: TNxTextColumn;
    CertNo: TNxTextColumn;
    TraineeName: TNxTextColumn;
    CompanyName: TNxTextColumn;
    TrainedSubject: TNxTextColumn;
    TrainedBeginDate: TNxTextColumn;
    TrainedEndDate: TNxTextColumn;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    ImportGeneratorMasterFromXlsFile1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    View1: TMenuItem;
    DataBase1: TMenuItem;
    ools1: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    ImageList32x32: TImageList;
    SplashScreen1: TAdvSmoothSplashScreen;
    Timer1: TTimer;
    JvSelectDirectory1: TJvSelectDirectory;
    JvLabel1: TJvLabel;
    ProdTypeCB: TComboBox;
    JvLabel4: TJvLabel;
    CertNoEdit: TEdit;
    PeriodPanel: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    ComboBox1: TComboBox;
    JvLabel2: TJvLabel;
    CertFileDBPath: TNxTextColumn;
    CertFileDBName: TNxTextColumn;
    UpdateDate: TNxTextColumn;
    N1: TMenuItem;
    DeleteSelectedCert1: TMenuItem;
    Attachments: TNxButtonColumn;
    CreateCertDocument2: TMenuItem;
    CertType: TNxTextColumn;
    GroupBox1: TGroupBox;
    EducationCheck: TCheckBox;
    APTServiceCheck: TCheckBox;
    CreateAPTCert1: TMenuItem;
    CompanyCode: TNxTextColumn;
    APTApprovalCheck: TCheckBox;
    CreateAPTApprovalCert1: TMenuItem;
    CompanyNation: TNxTextColumn;
    ImportVDRMasterFromXlsFile1: TMenuItem;
    N3: TMenuItem;
    CertNoFormat1: TMenuItem;
    ReportNo: TNxTextColumn;
    VDRSerialNo: TNxTextColumn;
    PlaceOfSurvey: TNxTextColumn;
    VDRType: TNxTextColumn;
    ClassSociety: TNxTextColumn;
    OwnerName: TNxTextColumn;
    ShipName: TNxTextColumn;
    IMONo: TNxTextColumn;
    HullNo: TNxTextColumn;
    PICEmail: TNxTextColumn;
    PICPhone: TNxTextColumn;
    APTServiceDate: TNxTextColumn;
    OrderNo: TNxTextColumn;
    SalesAmount: TNxTextColumn;
    N4: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure CertListGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure ImportGeneratorMasterFromXlsFile1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure CompanyNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure TraineeNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure SubjectEditKeyPress(Sender: TObject; var Key: Char);
    procedure CourseEditKeyPress(Sender: TObject; var Key: Char);
    procedure CertNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure Add1Click(Sender: TObject);
    procedure DeleteSelectedCert1Click(Sender: TObject);
    procedure AttachmentsButtonClick(Sender: TObject);
    procedure ImportVDRMasterFromXlsFile1Click(Sender: TObject);
    procedure CertNoFormat1Click(Sender: TObject);
    procedure CreateCertDocument2Click(Sender: TObject);
    procedure CreateAPTCert1Click(Sender: TObject);
    procedure CreateAPTApprovalCert1Click(Sender: TObject);
  private
    procedure ShowCertEditFormFromGrid(ARow: integer; AAttachPageView: Boolean=false);
    procedure GetCertList2Grid(AIsFromRemote: Boolean = False);
    procedure GetCertListFromVariant2Grid(ADoc: Variant);
    procedure SetCertListVisibleColumn;
    procedure GetCertSearchParam2Rec(var ACertSearchParamRec: TCertSearchParamRec);
    procedure GetCertListFromLocal(ACertSearchParamRec: TCertSearchParamRec);
    procedure DeleteHGSFileDB(ARow: integer);
    procedure ExecuteSearch(Key: Char);
    procedure MakeCertXls(ARow: integer);
    procedure ShowCertNoFormat;
  public
    { Public declarations }
  end;

var
  CertManageF: TCertManageF;

implementation

uses UnitEnumHelper, SynCommons, FrmCertEdit, UnitExcelUtil, UnitMakeXls,
  FrmCertNoFormat, UnitHGSVDRRecord;

{$R *.dfm}

procedure TCertManageF.Add1Click(Sender: TObject);
begin
  if CreateCertEditFormFromDB('') = mrOK then
    GetCertList2Grid;
end;

procedure TCertManageF.AeroButton1Click(Sender: TObject);
begin
  NextGridToExcel(CertListGrid);
end;

procedure TCertManageF.AttachmentsButtonClick(Sender: TObject);
begin
  if CertListGrid.SelectedRow = -1 then
    Exit;

  ShowCertEditFormFromGrid(CertListGrid.SelectedRow, True);
end;

procedure TCertManageF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TCertManageF.btn_SearchClick(Sender: TObject);
begin
  GetCertList2Grid;
end;

procedure TCertManageF.CertListGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  ShowCertEditFormFromGrid(ARow);
end;

procedure TCertManageF.CertNoEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TCertManageF.CertNoFormat1Click(Sender: TObject);
begin
  ShowCertNoFormat;
end;

procedure TCertManageF.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TCertManageF.CompanyNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TCertManageF.CourseEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TCertManageF.CreateAPTApprovalCert1Click(Sender: TObject);
begin
  if CreateCertEditFormFromDB('', hctProductApproval) = mrOK then
    GetCertList2Grid;
end;

procedure TCertManageF.CreateAPTCert1Click(Sender: TObject);
begin
  if CreateCertEditFormFromDB('', hctAPTService) = mrOK then
    GetCertList2Grid;
end;

procedure TCertManageF.CreateCertDocument2Click(Sender: TObject);
begin
  if CreateCertEditFormFromDB('', hctEducation) = mrOK then
    GetCertList2Grid;
end;

procedure TCertManageF.DeleteHGSFileDB(ARow: integer);
var
  LDBFileName: string;
begin
  LDBFileName := CertListGrid.CellsByName['CertFileDBPath', ARow] +
    CertListGrid.CellsByName['CertFileDBName', ARow];

  if FileExists(LDBFileName) then
    DeleteFile(LDBFileName);
end;

procedure TCertManageF.DeleteSelectedCert1Click(Sender: TObject);
var
  LCertNo: string;
begin
  if CertListGrid.SelectedRow = -1 then
    exit;

  if MessageDlg('Selected Cert. will be deleted.' + #13#10 + 'Are you sure?',
    mtConfirmation, [mbYes, mbNo], 0)= mrNo then
    exit;

  LCertNo := CertListGrid.CellsByName['CertNo', CertListGrid.SelectedRow];

  if LCertNo <> '' then
  begin
    DeleteHGSCert(LCertNo);
    DeleteHGSFileDB(CertListGrid.SelectedRow);
    GetCertList2Grid;
    CertListGrid.ScrollToRow(CertListGrid.SelectedRow);
  end;
end;

procedure TCertManageF.ExecuteSearch(Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    btn_SearchClick(nil);
end;

procedure TCertManageF.FormCreate(Sender: TObject);
begin
  InitHGSCertClient(HGS_CERT_DB_NAME);

  g_ShipProductType.SetType2Combo(ProdTypeCB);
  g_CertQueryDateType.SetType2Combo(ComboBox1);
end;

procedure TCertManageF.GetCertList2Grid(AIsFromRemote: Boolean);
var
  LSQLHGSCertRecord: TSQLHGSCertRecord;
  LCertSearchParamRec: TCertSearchParamRec;
  LDoc: Variant;
begin
  CertListGrid.BeginUpdate;
  try
    SetCertListVisibleColumn;
    CertListGrid.ClearRows;
    GetCertSearchParam2Rec(LCertSearchParamRec);

//    if AIsFromRemote then
//      GetVesselListFromRemote(LCertSearchParamRec)
//    else
      GetCertListFromLocal(LCertSearchParamRec);
  finally
    CertListGrid.EndUpdate;
  end;
end;

procedure TCertManageF.GetCertListFromLocal(
  ACertSearchParamRec: TCertSearchParamRec);
var
  LSQLHGSCertRecord: TSQLHGSCertRecord;
  LDoc: Variant;
begin
  LSQLHGSCertRecord := GetHGSCertRecordFromSearchRec(ACertSearchParamRec);
  try
    if LSQLHGSCertRecord.IsUpdate then
    begin
      LSQLHGSCertRecord.FillRewind;

      while LSQLHGSCertRecord.FillOne do
      begin
        LDoc := GetVariantFromHGSCertRecord(LSQLHGSCertRecord);
        GetCertListFromVariant2Grid(LDoc);
      end;//while

      StatusBarPro1.Panels[1].Text := IntToStr(CertListGrid.RowCount);
    end;
  finally
    LSQLHGSCertRecord.Free;
  end;
end;

procedure TCertManageF.GetCertListFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
  LShipProductTypes: integer;//TShipProductTypes;
begin
  LRow := CertListGrid.AddRow;

  CertListGrid.CellsByName['CertNo', LRow] := ADoc.CertNo;
  CertListGrid.CellsByName['TraineeName', LRow] := ADoc.TraineeName;
  CertListGrid.CellsByName['CompanyName', LRow] := ADoc.CompanyName;
  CertListGrid.CellsByName['CompanyCode', LRow] := ADoc.CompanyCode;
  CertListGrid.CellsByName['CompanyNation', LRow] := ADoc.CompanyNatoin;
  CertListGrid.CellsByName['OrderNo', LRow] := ADoc.OrderNo;
  CertListGrid.CellsByName['SalesAmount', LRow] := ADoc.SalesAmount;
  CertListGrid.CellsByName['TrainedSubject', LRow] := ADoc.TrainedSubject;
  CertListGrid.CellsByName['TrainedCourse', LRow] := ADoc.TrainedCourse;
  CertListGrid.CellsByName['CertFileDBPath', LRow] := ADoc.CertFileDBPath;
  CertListGrid.CellsByName['CertFileDBName', LRow] := ADoc.CertFileDBName;

  CertListGrid.CellsByName['ReportNo', LRow] := ADoc.ReportNo;
  CertListGrid.CellsByName['PlaceOfSurvey', LRow] := ADoc.PlaceOfSurvey;
  CertListGrid.CellsByName['VDRType', LRow] := ADoc.VDRType;
  CertListGrid.CellsByName['VDRSerialNo', LRow] := ADoc.VDRSerialNo;
  CertListGrid.CellsByName['ClassSociety', LRow] := ADoc.ClassSociety;
  CertListGrid.CellsByName['OwnerName', LRow] := ADoc.OwnerName;
  CertListGrid.CellsByName['ShipName', LRow] := ADoc.ShipName;
  CertListGrid.CellsByName['IMONo', LRow] := ADoc.IMONo;
  CertListGrid.CellsByName['HullNo', LRow] := ADoc.HullNo;
  CertListGrid.CellsByName['PICEmail', LRow] := ADoc.PICEmail;
  CertListGrid.CellsByName['PICPhone', LRow] := ADoc.PICPhone;
  CertListGrid.CellsByName['OrderNo', LRow] := ADoc.OrderNo;
  CertListGrid.CellsByName['SalesAmount', LRow] := ADoc.SalesAmount;

  if ADoc.APTServiceDate > 127489752310 then
    CertListGrid.CellsByName['APTServiceDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.APTServiceDate));

  LShipProductTypes := ADoc.ProductType;
  CertListGrid.CellsByName['ProductType', LRow] := g_ShipProductType.ToString(LShipProductTypes);
  CertListGrid.CellsByName['CertType', LRow] := g_HGSCertType.ToString(ADoc.CertType);

  if ADoc.TrainedBeginDate > 127489752310 then
    CertListGrid.CellsByName['TrainedBeginDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.TrainedBeginDate));
  if ADoc.TrainedEndDate > 127489752310 then
    CertListGrid.CellsByName['TrainedEndDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.TrainedEndDate));
  if ADoc.UntilValidity > 127489752310 then
    CertListGrid.CellsByName['UntilValidity', LRow] := DateToStr(TimeLogToDateTime(ADoc.UntilValidity));
  if ADoc.UpdateDate > 127489752310 then
    CertListGrid.CellsByName['UpdateDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.UpdateDate));

  CertListGrid.CellByName['Attachments', LRow].AsInteger := ADoc.FileCount;
//    High(TIDList4Invoice(AGrid.Row[i].Data).fInvoiceFile.Files)+1;
end;

procedure TCertManageF.GetCertSearchParam2Rec(
  var ACertSearchParamRec: TCertSearchParamRec);
var
  LCertQueryDateType: TCertQueryDateType;
begin
  ACertSearchParamRec := Default(TCertSearchParamRec);

  if ComboBox1.ItemIndex = -1 then
    LCertQueryDateType := cqdtNull
  else
    LCertQueryDateType := g_CertQueryDateType.ToType(ComboBox1.ItemIndex);

  ACertSearchParamRec.fQueryDate := LCertQueryDateType;
  ACertSearchParamRec.FFrom := dt_Begin.Date;
  ACertSearchParamRec.FTo := dt_end.Date;
  ACertSearchParamRec.fCertNo := CertNoEdit.Text;
  ACertSearchParamRec.fTraineeName := TraineeNameEdit.Text;
  ACertSearchParamRec.fCompanyName := CompanyNameEdit.Text;
  ACertSearchParamRec.fTrainedSubject := SubjectEdit.Text;
  ACertSearchParamRec.fTrainedCourse := CourseEdit.Text;

  if not(EducationCheck.Checked and APTServiceCheck.Checked and APTApprovalCheck.Checked) then
  begin
    if EducationCheck.Checked then
      ACertSearchParamRec.fCertType := hctEducation
    else
    if APTServiceCheck.Checked then
      ACertSearchParamRec.fCertType := hctAPTService
    else
    if APTApprovalCheck.Checked then
      ACertSearchParamRec.fCertType := hctProductApproval;
  end;

  if ProdTypeCB.ItemIndex = -1 then
    ACertSearchParamRec.fProductType := g_ShipProductType.ToType(0)
  else
    ACertSearchParamRec.fProductType := g_ShipProductType.ToType(ProdTypeCB.ItemIndex);
end;

procedure TCertManageF.ImportGeneratorMasterFromXlsFile1Click(Sender: TObject);
begin
  CreateCertEditFormFromDB('');
end;

procedure TCertManageF.ImportVDRMasterFromXlsFile1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      InitHGSVDRClient(HGS_VDRLIST_DB_NAME);
      try
        ImportVDRMasterFromXlsFile(OpenDialog1.FileName);
      finally
        DestroyHGSVDR;
      end;
    end;
  end;
end;

procedure TCertManageF.MakeCertXls(ARow: integer);
//var
//  LExcel: OleVariant;
//  LWorkBook: OleVariant;
//  LRange: OleVariant;
//  LWorksheet: OleVariant;
//  LPicture: OleVariant;
//  LStr, LStr2: string;
begin
//  LStr := CertListGrid.CellsByName['CertFileDBPath', ARow];
//
//  LExcel := GetActiveExcelOleObject(True);
//  try
//    LWorkBook := LExcel.Workbooks.Open(LStr + 'Cert.xls');
//    LWorksheet := LExcel.ActiveSheet;
//
//    LStr := CertListGrid.CellsByName['CertNo', ARow];
//    strToken(LStr, '-'); //CertNo에서 HGA 제거
//    LStr2 := strToken(LStr, '-'); //년도
//    LRange := LWorksheet.range['Q2'];
//    LRange.FormulaR1C1 := LStr2;
//    LRange := LWorksheet.range['U2'];
//    LRange.FormulaR1C1 := LStr;
//    LRange := LWorksheet.range['Z29'];
//    LRange.FormulaR1C1 := CertListGrid.CellsByName['TrainedSubject', ARow];
//    LRange := LWorksheet.range['Z34'];
//    LRange.FormulaR1C1 := CertListGrid.CellsByName['TraineeName', ARow];
//    LRange := LWorksheet.range['Z38'];
//    LRange.FormulaR1C1 := CertListGrid.CellsByName['CompanyName', ARow];
//    LRange := LWorksheet.range['Z41'];
//    LRange.FormulaR1C1 := CertListGrid.CellsByName['TrainedBeginDate', ARow] + ' ~ ' +
//      CertListGrid.CellsByName['TrainedEndDate', ARow];
//    LRange := LWorksheet.range['Z45'];
//    LRange.FormulaR1C1 := CertListGrid.CellsByName['TrainedSubject', ARow];
//    LRange := LWorksheet.range['Z48'];
//    LRange.FormulaR1C1 := CertListGrid.CellsByName['TrainedCourse', ARow];
//    LRange := LWorksheet.range['AP52'];
//    LRange.FormulaR1C1 := CertListGrid.CellsByName['UntilValidity', ARow];
//    LRange := LWorksheet.range['AT52'];
//    LRange.FormulaR1C1 := CertListGrid.CellsByName['UntilValidity', ARow];
//    LRange := LWorksheet.range['AS55'];
//    LRange.Left;
//  finally
//    LWorkBook.Close;
//    LExcel.Quit;
//  end;
end;

procedure TCertManageF.rg_periodClick(Sender: TObject);
var
  Ly,Lm,Ld: word;
begin
  dt_begin.Enabled := False;
  dt_end.Enabled := False;

  case rg_period.ItemIndex of
    0:
      begin
        dt_begin.Date := now;
        DecodeDate(dt_begin.Date,Ly,Lm,Ld);
        Ly := Ly - 1;
        Lm := 1;
        Ld := 1;
        dt_begin.Date := EncodeDate(Ly,Lm,Ld);
        Lm := 12;
        Ld := 31;
        dt_end.Date := EncodeDate(Ly,Lm,Ld);;
      end;
    1:
      begin
        dt_begin.Date := now;
        DecodeDate(dt_begin.Date,Ly,Lm,Ld);
        Ly := Ly - 2;
        Lm := 1;
        Ld := 1;
        dt_begin.Date := EncodeDate(Ly,Lm,Ld);
        Lm := 12;
        Ld := 31;
        dt_end.Date := EncodeDate(Ly,Lm,Ld);;
      end;
    2:
      begin
        dt_begin.Date := now;
        DecodeDate(dt_begin.Date,Ly,Lm,Ld);
        Ly := Ly - 5;
        Lm := 1;
        Ld := 1;
        dt_begin.Date := EncodeDate(Ly,Lm,Ld);
        Lm := 12;
        Ld := 31;
        dt_end.Date := EncodeDate(Ly,Lm,Ld);;
      end;
    3:
      begin
        dt_begin.Enabled := True;
        dt_end.Enabled := True;
      end;
  end;
end;

procedure TCertManageF.SetCertListVisibleColumn;
var
  LBool: Boolean;
begin
  LBool := EducationCheck.Checked;
  CertListGrid.ColumnByName['TrainedSubject'].Visible := LBool;
  CertListGrid.ColumnByName['TrainedCourse'].Visible := LBool;
  CertListGrid.ColumnByName['TraineeName'].Visible := LBool;
  CertListGrid.ColumnByName['TrainedBeginDate'].Visible := LBool;
  CertListGrid.ColumnByName['TrainedEndDate'].Visible := LBool;

  LBool := APTServiceCheck.Checked;
  CertListGrid.ColumnByName['ReportNo'].Visible := LBool;
  CertListGrid.ColumnByName['VDRSerialNo'].Visible := LBool;
  CertListGrid.ColumnByName['PlaceOfSurvey'].Visible := LBool;
  CertListGrid.ColumnByName['VDRType'].Visible := LBool;
  CertListGrid.ColumnByName['ClassSociety'].Visible := LBool;
  CertListGrid.ColumnByName['OwnerName'].Visible := LBool;
  CertListGrid.ColumnByName['ShipName'].Visible := LBool;
  CertListGrid.ColumnByName['IMONo'].Visible := LBool;
  CertListGrid.ColumnByName['HullNo'].Visible := LBool;
  CertListGrid.ColumnByName['PICEmail'].Visible := LBool;
  CertListGrid.ColumnByName['PICPhone'].Visible := LBool;
  CertListGrid.ColumnByName['APTServiceDate'].Visible := LBool;
end;

procedure TCertManageF.ShowCertEditFormFromGrid(ARow: integer; AAttachPageView: Boolean);
var
  LCertNo: string;
begin
  LCertNo := CertListGrid.CellsByName['CertNo', ARow];

  if CreateCertEditFormFromDB(LCertNo, hctNull, AAttachPageView) = mrOK then
  begin
    GetCertList2Grid;
    CertListGrid.ScrollToRow(ARow);
  end;
end;

procedure TCertManageF.ShowCertNoFormat;
begin
  CreateCertNoFormat;
end;

procedure TCertManageF.SubjectEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

procedure TCertManageF.TraineeNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  ExecuteSearch(Key);
end;

end.
