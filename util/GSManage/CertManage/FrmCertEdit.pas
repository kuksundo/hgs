unit FrmCertEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ActiveX, TypInfo,
  DropSource, DragDrop, DropTarget, DragDropFile,
  Vcl.ImgList, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, AdvGlowButton, Vcl.ComCtrls,
  NxEdit, JvExControls, JvLabel, AdvOfficePager, Vcl.ExtCtrls, AeroButtons,
  UnitHGSCertRecord, UnitGSFileRecord, FrameGSFileList, UnitHGSSerialRecord,
  UnitQRCodeFrame, Vcl.Menus, AdvEdit, AdvEdBtn, UnitHGSCertData, UnitHGSVDRRecord,
  Vcl.Mask, JvExMask, JvToolEdit, JvMaskEdit, JvCheckedMaskEdit,
  JvDatePickerEdit;

const
  ATR_FILENAME = 'ANNUAL_TEST_REPORT.pjh';
  COC_FILENAME = 'Certificate_of_compliance_with_field.pjh';
  VDRConfigFileName = 'VDRConfig.ini';
type
  TCertEditF = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    AdvOfficePage1: TAdvOfficePager;
    CertInfoPage: TAdvOfficePage;
    AttachmentPage: TAdvOfficePage;
    ImageList16x16: TImageList;
    Imglist16x16: TImageList;
    CheckBox1: TCheckBox;
    GSFileFrame: TGSFileListFrame;
    IsCryptSerialCheck: TCheckBox;
    QRCodePage: TAdvOfficePage;
    QRCodeFrame1: TQRCodeFrame;
    btnCopy: TButton;
    Button1: TButton;
    edtText: TEdit;
    AeroButton3: TAeroButton;
    AeroButton2: TAeroButton;
    AeroButton1: TAeroButton;
    btn_Close: TAeroButton;
    JvLabel8: TJvLabel;
    CertTypeCB: TComboBox;
    EducationPanel: TPanel;
    APTPanel: TPanel;
    JvLabel4: TJvLabel;
    TrainedSubjectEdit: TNxButtonEdit;
    JvLabel7: TJvLabel;
    CourseLevelCB: TComboBox;
    JvLabel31: TJvLabel;
    TrainedCourseEdit: TNxButtonEdit;
    JvLabel1: TJvLabel;
    TraineeNameEdit: TEdit;
    JvLabel20: TJvLabel;
    Label1: TLabel;
    CommonPanel: TPanel;
    JvLabel3: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel49: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel9: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel10: TJvLabel;
    ProductTypeCB: TComboBox;
    CertNoButtonEdit: TNxButtonEdit;
    CertFileDBPathEdit: TNxButtonEdit;
    CertFileDBNameEdit: TNxButtonEdit;
    PrevCertNoEdit: TEdit;
    SubCompanyEdit: TAdvEditBtn;
    JvLabel13: TJvLabel;
    JvLabel6: TJvLabel;
    ReportNoEdit: TNxButtonEdit;
    JvLabel12: TJvLabel;
    CompanyNationEdit: TEdit;
    JvLabel11: TJvLabel;
    CompanyCodeEdit: TEdit;
    JvLabel14: TJvLabel;
    OwnerNameEdit: TEdit;
    JvLabel16: TJvLabel;
    JvLabel17: TJvLabel;
    VDRSerialNoEdit: TNxButtonEdit;
    JvLabel18: TJvLabel;
    IMONoEdit: TNxButtonEdit;
    JvLabel19: TJvLabel;
    JvLabel21: TJvLabel;
    JvLabel22: TJvLabel;
    JvLabel23: TJvLabel;
    JvLabel24: TJvLabel;
    ShipNameEdit: TNxButtonEdit;
    HullNoEdit: TNxButtonEdit;
    PlaceOfSurveyEdit: TEdit;
    ClassSocietyEdit: TEdit;
    PICEmailEdit: TEdit;
    PICPhoneEdit: TEdit;
    JvLabel25: TJvLabel;
    VDRTypeEdit: TEdit;
    JvLabel26: TJvLabel;
    VDRConfigMemo: TMemo;
    JvLabel27: TJvLabel;
    OrderNoEdit: TEdit;
    JvLabel28: TJvLabel;
    SalesAmountEdit: TEdit;
    MakeZipButton: TAeroButton;
    APTServiceDatePicker: TJvDatePickerEdit;
    TrainedBeginDatePicker: TJvDatePickerEdit;
    TrainedEndDatePicker: TJvDatePickerEdit;
    IssueDatePicker: TJvDatePickerEdit;
    UntilValidityDatePicker: TJvDatePickerEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CertNoButtonEditButtonClick(Sender: TObject);
    procedure QRCodeFrame1pbPreviewPaint(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure CertFileDBPathEditButtonClick(Sender: TObject);
    procedure CertFileDBNameEditButtonClick(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrainedSubjectEditButtonClick(Sender: TObject);
    procedure TrainedCourseEditButtonClick(Sender: TObject);
    procedure SubCompanyEditClickBtn(Sender: TObject);
    procedure ReportNoEditButtonClick(Sender: TObject);
    procedure CertTypeCBChange(Sender: TObject);
    procedure IMONoEditButtonClick(Sender: TObject);
    procedure ShipNameEditButtonClick(Sender: TObject);
    procedure HullNoEditButtonClick(Sender: TObject);
    procedure VDRSerialNoEditButtonClick(Sender: TObject);
    procedure MakeZipButtonClick(Sender: TObject);
    procedure IssueDatePickerChange(Sender: TObject);
    procedure UntilValidityDatePickerChange(Sender: TObject);
    procedure APTServiceDatePickerChange(Sender: TObject);
    procedure CourseLevelCBChange(Sender: TObject);
    procedure ProductTypeCBChange(Sender: TObject);
    procedure PlaceOfSurveyEditKeyPress(Sender: TObject; var Key: Char);
    procedure ClassSocietyEditKeyPress(Sender: TObject; var Key: Char);
    procedure TraineeNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure TrainedBeginDatePickerChange(Sender: TObject);
    procedure TrainedEndDatePickerChange(Sender: TObject);
  private
    FGSFileDBName,
    FGSFileDBPath: string;
    FActiveControl: TWinControl;
    FPrevInactiveColor: TColor;
    FDisableEditPosition: Boolean;

    procedure GetCertDetailFromCertRecord(ASQLHGSCertRecord: TSQLHGSCertRecord);
    procedure GetCertFileList2FileGrid(const AFileDBName: string);
    procedure SaveGSFile2DB;
    function LoadCertDetail2CertRecordFromForm(var ACertRecord: TSQLHGSCertRecord): Boolean;
    procedure CreateQRCode;
    procedure CreateVDRTestReportNo;
    function CheckQRCodeIsValid: Boolean;
    function GetCertInfo2Json(AHGSCertType:THGSCertType=hctNull): string;
    function GetSerialNoFromCertNo(ACertNo: string; var AYear: integer): string;
    function GetVDRConfigFromIMONo(AIMONo: string): string;
    procedure ShowSearchVesselForm(Sender: TObject);
    procedure ShowSearchVDRForm;
    procedure DisplayEditPosition;
    procedure RestoreColorExceptComponent(ATag: integer);
    procedure ScreenActiveControlChange(Sender: TObject);

    function GetTempATRFileName: string;
    function GetTempCOCFileName: string;
    function GetTempZipFileName: string;
    function GetTempVDRConfigFileName: string;
  public
    function CreateCertNo(AProdType, ACertType: integer; IsCryptSerial: Boolean): string;
    procedure MakeCertXls;
    procedure MakeCertDoc(ACertType: integer; AIsSaveFile: Boolean=False; AIsWordClose: Boolean=False);
    procedure MakeZip4APTDoc(AShowCompletionMsg: Boolean=false);
  end;

function CreateCertEditFormFromDB(ACertNo: string; ACertType: THGSCertType=hctNull; AAttachPageView: Boolean=false): integer;

var
  CertEditF: TCertEditF;

implementation

uses SynCommons, UnitVesselData,  DragDropInternet, DragDropFormats, DateUtils,
  UnitCryptUtil, QRGraphics, System.StrUtils, iniFiles,
  UnitFolderUtil, UnitExcelUtil,
  UnitStringUtil, UnitHGSCurriculumData, FrmCourseManage,
  UnitMSWordUtil, FrmSearchCustomer, CommonData, FrmSearchVessel, FrmSearchVDR,
  SynZip, UnitFormUtil;//, Excel2000;

{$R *.dfm}

function CreateCertEditFormFromDB(ACertNo: string; ACertType: THGSCertType;
  AAttachPageView: Boolean): integer;
var
  LCertEditF: TCertEditF;
  LSQLHGSCertRecord,
  LSQLHGSCertRecord2: TSQLHGSCertRecord;
  LDoc: variant;
  LYear: integer;
begin
  LCertEditF := TCertEditF.Create(nil);
  try
    LCertEditF.GSFileFrame.InitDragDrop;
    LCertEditF.GSFileFrame.AddButton.Align :=alLeft;
    LCertEditF.GSFileFrame.ApplyButton.Visible := False;
    LCertEditF.GSFileFrame.CloseButton.Visible := False;

    LSQLHGSCertRecord := GetHGSCertFromCertNo(ACertNo);
    try
      LCertEditF.GetCertDetailFromCertRecord(LSQLHGSCertRecord);

      if AAttachPageView then
        LCertEditF.AdvOfficePage1.ActivePageIndex := 1
      else
        LCertEditF.AdvOfficePage1.ActivePageIndex := 0;

      if ACertType <> hctNull then
      begin
        LCertEditF.CertTypeCB.ItemIndex := Ord(ACertType);
        LCertEditF.CertTypeCBChange(nil);

        if ACertType = hctAPTService then
        begin
          LCertEditF.ProductTypeCB.ItemIndex := ORd(shptVDR);
          LCertEditF.ProductTypeCBChange(nil);
        end;
      end;

      Result := LCertEditF.ShowModal;

      if Result = mrOK then
      begin
        //CertNo <> ''이면 DB에 저장
        if LCertEditF.LoadCertDetail2CertRecordFromForm(LSQLHGSCertRecord) then
        begin
          AddOrUpdateHGSCert(LSQLHGSCertRecord);
          LSQLHGSCertRecord.NextSerialNo := LCertEditF.GetSerialNoFromCertNo(LSQLHGSCertRecord.CertNo, LYear);
          AddOrUpdateNextHGSSerial(LYear, Ord(LSQLHGSCertRecord.ProductType),
            Ord(LSQLHGSCertRecord.CertType), StrToIntDef(LSQLHGSCertRecord.NextSerialNo, 0));
          LCertEditF.SaveGSFile2DB;

          ShowMessage('Data Save Is OK!');
        end;
      end
      else
      if Result = mrYes then
      begin
        LSQLHGSCertRecord2 := TSQLHGSCertRecord.Create;
        try
          if LCertEditF.LoadCertDetail2CertRecordFromForm(LSQLHGSCertRecord2) then
          begin
            AddOrUpdateHGSCert(LSQLHGSCertRecord2);
            LSQLHGSCertRecord2.NextSerialNo := LCertEditF.GetSerialNoFromCertNo(LSQLHGSCertRecord2.CertNo, LYear);
            AddOrUpdateNextHGSSerial(LYear,Ord(LSQLHGSCertRecord2.ProductType),
              Ord(LSQLHGSCertRecord2.CertType), StrToIntDef(LSQLHGSCertRecord2.NextSerialNo, 0));
            LCertEditF.SaveGSFile2DB;

            ShowMessage('Data Add is successful!');
          end;
        finally
          LSQLHGSCertRecord2.Free;
        end;
      end;
    finally
      LSQLHGSCertRecord.Free;
    end;
  finally
    LCertEditF.Free;
  end;
end;

{ TCertEditF }

procedure TCertEditF.AeroButton2Click(Sender: TObject);
begin
  MakeCertDoc(CertTypeCB.ItemIndex);
end;

procedure TCertEditF.MakeZipButtonClick(Sender: TObject);
begin
  MakeZip4APTDoc(True);
end;

procedure TCertEditF.PlaceOfSurveyEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    DisplayEditPosition;
end;

procedure TCertEditF.ProductTypeCBChange(Sender: TObject);
begin
  DisplayEditPosition;
end;

procedure TCertEditF.APTServiceDatePickerChange(Sender: TObject);
begin
  DisplayEditPosition;
end;

procedure TCertEditF.btnCopyClick(Sender: TObject);
begin
  QRCodeFrame1.CopyBitmapToClipboard;
end;

procedure TCertEditF.Button1Click(Sender: TObject);
var
  LIsValid: Boolean;
begin
  LIsValid := CheckQRCodeIsValid;

  if LIsValid then
    ShowMessage('QR Code is OK!')
  else
    ShowMessage('QR Code is invalid!');
end;

procedure TCertEditF.CertFileDBNameEditButtonClick(Sender: TObject);
begin
  if CertNoButtonEdit.Text = '' then
  begin
    ShowMessage('Please check cert. no. first!');
    exit;
  end;

  CertFileDBNameEdit.Text := GetDefaultDBName(CertNoButtonEdit.Text);
end;

procedure TCertEditF.CertFileDBPathEditButtonClick(Sender: TObject);
var
  LPath: string;
begin
  LPath := GetDefaultDBPath + 'files\';
  LPath := ExtractRelativePathBaseApplication(ExtractFilePath(Application.ExeName), LPath);
  CertFileDBPathEdit.Text := LPath;
end;

procedure TCertEditF.CertNoButtonEditButtonClick(Sender: TObject);
var
  LProdType, LCertType: integer;
begin
  LProdType := ProductTypeCB.ItemIndex;
  LCertType := CertTypeCB.ItemIndex;

  if LProdType < 1 then
  begin
    ShowMessage('Please select the product type!');
    exit;
  end;

  if LCertType < 1 then
  begin
    ShowMessage('Please select the Cert type!');
    exit;
  end;

  CertNoButtonEdit.Text := CreateCertNo(LProdType, LCertType, False);
  CreateQRCode;

  if CertFileDBNameEdit.Text = '' then
    CertFileDBNameEditButtonClick(nil);

  DisplayEditPosition;
end;

procedure TCertEditF.CertTypeCBChange(Sender: TObject);
const
  DefaultHeight = 650;
begin
  case g_HGSCertType.ToType(CertTypeCB.ItemIndex) of
    hctEducation: begin
      EducationPanel.Visible := True;
      APTPanel.Visible := False;
      Self.Height := DefaultHeight - APTPanel.Height;
      MakeZipButton.Visible := False;
    end;
    hctAPTService: begin
      EducationPanel.Visible := False;
      APTPanel.Visible := True;
      Self.Height := DefaultHeight - EducationPanel.Height;
      MakeZipButton.Visible := True;
    end;
    hctProductApproval: begin
      EducationPanel.Visible := False;
      APTPanel.Visible := False;
      Self.Height := DefaultHeight - EducationPanel.Height - APTPanel.Height;
      MakeZipButton.Visible := False;
    end;
  end;

  DisplayEditPosition;
end;

procedure TCertEditF.CheckBox1Click(Sender: TObject);
begin
  CertNoButtonEdit.Enabled := CheckBox1.Checked;
end;

function TCertEditF.CheckQRCodeIsValid: Boolean;
var
  LJson: string;
begin
  LJson := GetCertInfo2Json;
//  LJson := UnitCryptUtil.GetHashStringFromSCrypt(LJson);

  Result := CheckHashStringFromSCrypt(LJson, edtText.Text);
end;

procedure TCertEditF.ClassSocietyEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    DisplayEditPosition;
end;

procedure TCertEditF.CourseLevelCBChange(Sender: TObject);
begin
  DisplayEditPosition;
end;

function TCertEditF.CreateCertNo(AProdType, ACertType: integer; IsCryptSerial: Boolean): string;
var
  LSerialNo: integer;
  LIssuedYear: string;
begin
  LIssuedYear :=FormatDateTime('yy', Now);
  LSerialNo := GetNextHGSSerialFromProductType(StrToInt(LIssuedYear), AProdType, ACertType);

  if IsCryptSerial then
  begin

  end;

  Result := 'HGA-'+ LIssuedYear + '-' +
//    LeftStr(g_ShipProductCode.ToString(ProductTypeCB.ItemIndex),2) + '-' +
    g_ShipProductCode.ToString(AProdType) + '-' +
    g_HGSCertTypeCode.ToString(ACertType) + '-' +
    format('%.4d', [LSerialNo]);

  if CheckIfExistHGSCertNo(Result) then
  begin
    ShowMessage('Cert No is already exist!');
    Exit;
  end;
end;

procedure TCertEditF.CreateQRCode;
var
  LJson: string;
begin
  LJson := GetCertInfo2Json;

  LJson := UnitCryptUtil.GetHashStringFromSCrypt(LJson);
  QRCodeFrame1.edtText.Text := LJson;
  QRCodeFrame1.RemakeQR;
end;

procedure TCertEditF.CreateVDRTestReportNo;
var
  LYear: string;
begin
  if HullNoEdit.Text = '' then
  begin
    ShowMessage('Please select Hull no. First!');
    exit;
  end;

  LYear := FormatDateTime('yy', APTServiceDatePicker.Date);

  ReportNoEdit.Text := 'VDR-TR' + LYear + '-' + HullNoEdit.Text;
  DisplayEditPosition;
end;

procedure TCertEditF.DisplayEditPosition;
begin
  if FDisableEditPosition then
    exit;

  if CertTypeCB.ItemIndex = -1 then
  begin
    CertTypeCB.Color := clYellow;
    RestoreColorExceptComponent(CertTypeCB.Tag);
    exit;
  end;

  if ProductTypeCB.ItemIndex = -1 then
  begin
    ProductTypeCB.Color := clYellow;
    RestoreColorExceptComponent(ProductTypeCB.Tag);
    exit;
  end;

  if SubCompanyEdit.Text = '' then
  begin
    SubCompanyEdit.Color := clYellow;
    RestoreColorExceptComponent(SubCompanyEdit.Tag);
    exit;
  end;

  case g_HGSCertType.ToType(CertTypeCB.ItemIndex) of
    hctEducation: begin
      if TrainedSubjectEdit.Text = '' then
      begin
        TrainedSubjectEdit.Color := clYellow;
        RestoreColorExceptComponent(TrainedSubjectEdit.Tag);
        exit;
      end;

      if TrainedCourseEdit.Text = '' then
      begin
        TrainedCourseEdit.Color := clYellow;
        RestoreColorExceptComponent(TrainedCourseEdit.Tag);
        exit;
      end;

      if CourseLevelCB.ItemIndex = -1 then
      begin
        CourseLevelCB.Color := clYellow;
        RestoreColorExceptComponent(CourseLevelCB.Tag);
        exit;
      end;

      if TraineeNameEdit.Text = '' then
      begin
        TraineeNameEdit.Color := clYellow;
        RestoreColorExceptComponent(TraineeNameEdit.Tag);
        exit;
      end;

      if TrainedBeginDatePicker.Color = clWindow then
      begin
        TrainedBeginDatePicker.Color := clYellow;
        RestoreColorExceptComponent(TrainedBeginDatePicker.Tag);
        exit;
      end;

      if TrainedEndDatePicker.Color = clWindow then
      begin
        TrainedEndDatePicker.Color := clYellow;
        RestoreColorExceptComponent(TrainedEndDatePicker.Tag);
        exit;
      end;

      if UntilValidityDatePicker.Color = clWindow then
      begin
        UntilValidityDatePicker.Color := clYellow;
        RestoreColorExceptComponent(UntilValidityDatePicker.Tag);
        exit;
      end;

      if CertNoButtonEdit.Text = '' then
      begin
        CertNoButtonEdit.Color := clYellow;
        RestoreColorExceptComponent(CertNoButtonEdit.Tag);
        exit;
      end;
    end;
    hctAPTService: begin
      if CertNoButtonEdit.Text = '' then
      begin
        CertNoButtonEdit.Color := clYellow;
        RestoreColorExceptComponent(CertNoButtonEdit.Tag);
        exit;
      end;

      if IMONoEdit.Text = '' then
      begin
        IMONoEdit.Color := clYellow;
        RestoreColorExceptComponent(IMONoEdit.Tag);
        exit;
      end;

      if ShipNameEdit.Text = '' then
      begin
        ShipNameEdit.Color := clYellow;
        RestoreColorExceptComponent(ShipNameEdit.Tag);
        exit;
      end;

      if HullNoEdit.Text = '' then
      begin
        HullNoEdit.Color := clYellow;
        RestoreColorExceptComponent(HullNoEdit.Tag);
        exit;
      end;

      if VDRSerialNoEdit.Text = '' then
      begin
        VDRSerialNoEdit.Color := clYellow;
        RestoreColorExceptComponent(VDRSerialNoEdit.Tag);
        exit;
      end;

      if ReportNoEdit.Text = '' then
      begin
        ReportNoEdit.Color := clYellow;
        RestoreColorExceptComponent(ReportNoEdit.Tag);
        exit;
      end;

      if PlaceOfSurveyEdit.Text = '' then
      begin
        PlaceOfSurveyEdit.Color := clYellow;
        RestoreColorExceptComponent(PlaceOfSurveyEdit.Tag);
        exit;
      end;

      if ClassSocietyEdit.Text = '' then
      begin
        ClassSocietyEdit.Color := clYellow;
        RestoreColorExceptComponent(ClassSocietyEdit.Tag);
        exit;
      end;

      if VDRTypeEdit.Text = '' then
      begin
        VDRTypeEdit.Color := clYellow;
        RestoreColorExceptComponent(VDRTypeEdit.Tag);
        exit;
      end;

      if (PlaceOfSurveyEdit.Text <> '') and (ClassSocietyEdit.Text <> '') then
        if APTServiceDatePicker.Color = clWindow then
        begin
          APTServiceDatePicker.Color := clYellow;
          RestoreColorExceptComponent(APTServiceDatePicker.Tag);
          exit;
        end;
    end;
    hctProductApproval: begin

    end;
  end;
end;

procedure TCertEditF.FormCreate(Sender: TObject);
begin
  QRCodeFrame1.Panel1.Visible := False;
  g_ShipProductType.SetType2Combo(ProductTypeCB);
  g_AcademyCourseLevelDesc.SetType2Combo(CourseLevelCB);
  g_HGSCertType.SetType2Combo(CertTypeCB);
  InitHGSSerialClient('HGSSerial.sqlite');
  FGSFileDBName := '';

//  Screen.OnActiveControlChange := ScreenActiveControlChange;
end;

procedure TCertEditF.FormDestroy(Sender: TObject);
begin
//  Screen.OnActiveControlChange := nil;
  DestroyHGSSerial;
  DestroyGSFile;
end;

function TCertEditF.GetTempATRFileName: string;
begin
  Result := 'c:\temp\'+HullNoEdit.Text+'_'+ATR_FILENAME;
end;

procedure TCertEditF.GetCertDetailFromCertRecord(
  ASQLHGSCertRecord: TSQLHGSCertRecord);
begin
  FDisableEditPosition := True;
  try
    if ASQLHGSCertRecord.IsUpdate then
    begin
      with ASQLHGSCertRecord do
      begin
        CertTypeCB.ItemIndex := Ord(CertType);
        CertTypeCBChange(nil);
        CertNoButtonEdit.Text := CertNo;
        SubCompanyEdit.Text := CompanyName;
        CompanyCodeEdit.Text := CompanyCode;
        CompanyNationEdit.Text := CompanyNatoin;
        OrderNoEdit.Text := OrderNo;
        SalesAmountEdit.Text := SalesAmount;

        CertFileDBPathEdit.Text := CertFileDBPath;
        CertFileDBNameEdit.Text := CertFileDBName;

        PrevCertNoEdit.Text := PrevCertNo;
        ProductTypeCB.ItemIndex := Ord(ProductType);
        IssueDatePicker.Date := TimeLogToDateTime(IssueDate);
        UntilValidityDatePicker.Date := TimeLogToDateTime(UntilValidity);

        TrainedSubjectEdit.Text := TrainedSubject;
        TrainedCourseEdit.Text := TrainedCourse;
        TraineeNameEdit.Text := TraineeName;
        CourseLevelCB.ItemIndex := Ord(CourseLevel);
        TrainedBeginDatePicker.Date := TimeLogToDateTime(TrainedBeginDate);
        TrainedEndDatePicker.Date := TimeLogToDateTime(TrainedEndDate);

        ReportNoEdit.Text := ReportNo;
        VDRSerialNoEdit.Text := VDRSerialNo;
        PlaceOfSurveyEdit.Text := PlaceOfSurvey;
        PICEmailEdit.Text := PICEmail;
        PICPhoneEdit.Text := PICPhone;
        IMONoEdit.Text := IMONo;
        ShipNameEdit.Text := ShipName;
        HullNoEdit.Text := HullNo;
        OwnerNameEdit.Text := OwnerName;
        VDRTypeEdit.Text := VDRType;
        ClassSocietyEdit.Text := ClassSociety;
        APTServiceDatePicker.Date := TimeLogToDateTime(APTServiceDate);
        VDRConfigMemo.Text := GetVDRConfigFromIMONo(IMONo);

        if CertFileDBName <> '' then
        begin
          FGSFileDBName := 'files\'+CertFileDBName;
          FGSFileDBPath := CertFileDBPath;
          GetCertFileList2FileGrid(FGSFileDBName);
        end;

        CreateQRCode;
      end;
    end
    else
    begin//Create Cert.(신규) 인 경우
      CertFileDBPathEditButtonClick(nil);
      CertNoButtonEdit.Enabled := True;
      CheckBox1.Checked := True;
      IssueDatePicker.Date := now;
      APTServiceDatePicker.Date := now;
    end;
  finally
    FDisableEditPosition := False;
  end;
end;

procedure TCertEditF.GetCertFileList2FileGrid(const AFileDBName: string);
//var
//  LSQLGSFile: TSQLGSFile;
begin
  InitGSFileClient2(AFileDBName);
  try
    if Assigned(GSFileFrame.FGSFiles_) then
      FreeAndNil(GSFileFrame.FGSFiles_);

    GSFileFrame.FGSFiles_ := GetGSFiles;
    try
      if GSFileFrame.FGSFiles_.IsUpdate then
      begin
        GSFileFrame.LoadFiles2Grid;
      end;
    finally
//      FreeAndNil(GSFileFrame.FGSFiles_);
    end;
  finally
    DestroyGSFile;
  end;
end;

function TCertEditF.GetCertInfo2Json(AHGSCertType:THGSCertType): string;
var
  LDoc: Variant;
begin
  if CertNoButtonEdit.Text = '' then
  begin
    ShowMessage('Cert. No. is invalid!');
    exit;
  end;

  TDocVariant.New(LDoc);

  LDoc.CertNo := CertNoButtonEdit.Text;
  LDoc.ProductType := ProductTypeCB.ItemIndex;
  LDoc.CertType := CertTypeCB.ItemIndex;
  LDoc.CompanyName := SubCompanyEdit.Text;
  LDoc.CompanyCode := CompanyCodeEdit.Text;
  LDoc.CompanyNatoin := CompanyNationEdit.Text;
  LDoc.OrderNo := OrderNoEdit.Text;
  LDoc.SalesAmount := SalesAmountEdit.Text;
  LDoc.CertFileDBName := CertFileDBNameEdit.Text;
  LDoc.UntilValidity := UntilValidityDatePicker.Date;

  if AHGSCertType = hctEducation then
  begin
    LDoc.TrainedCourse := TrainedCourseEdit.Text;
    LDoc.TrainedSubject := TrainedSubjectEdit.Text;
    LDoc.CourseLevel := CourseLevelCB.ItemIndex;
    LDoc.TraineeName := TraineeNameEdit.Text;
    LDoc.TrainedBeginDate := TrainedBeginDatePicker.Date;
    LDoc.TrainedEndDate := TrainedEndDatePicker.Date;
  end
  else
  if AHGSCertType = hctAPTService then
  begin
    LDoc.ReportNo := ReportNoEdit.Text;
    LDoc.VDRSerialNo := VDRSerialNoEdit.Text;
    LDoc.PlaceOfSurvey := PlaceOfSurveyEdit.Text;
    LDoc.PICEmail := PICEmailEdit.Text;
    LDoc.PICPhone := PICPhoneEdit.Text;
    LDoc.IMONo := IMONoEdit.Text;
//    LDoc.ShipName := ShipNameEdit.Text;
    LDoc.HullNo := HullNoEdit.Text;
//    LDoc.OwnerName := OwnerNameEdit.Text;
//    LDoc.ClassSociety := ClassSocietyEdit.Text;
    LDoc.APTServiceDate := APTServiceDatePicker.Date;
  end
  else
  if AHGSCertType = hctProductApproval then
  begin

  end
  else
  begin

  end;
//  LDoc.CertFileDBPath := CertFileDBPathEdit.Text;

  Result := _JSON(LDoc);
end;

function TCertEditF.GetTempCOCFileName: string;
begin
  Result := 'c:\temp\'+HullNoEdit.Text+'_'+COC_FILENAME;
end;

function TCertEditF.GetTempVDRConfigFileName: string;
begin
  Result := 'c:\temp\'+VDRConfigFileName;
end;

function TCertEditF.GetTempZipFileName: string;
begin

end;

function TCertEditF.GetVDRConfigFromIMONo(AIMONo: string): string;
var
  LSQLHGSVDRRecord: TSQLHGSVDRRecord;
begin
  Result := '';

  InitHGSVDRClient(HGS_VDRLIST_DB_NAME);
  try
    LSQLHGSVDRRecord := GetHGSVDRFromIMONo(AIMONo);

    if LSQLHGSVDRRecord.IsUpdate then
    begin
      Result := LSQLHGSVDRRecord.VDRConfig;
      Result := StringReplace(Result, #10, #13#10, [rfReplaceAll]);
    end;
  finally
    DestroyHGSVDR;
  end;
end;

function TCertEditF.GetSerialNoFromCertNo(ACertNo: string; var AYear: integer): string;
var
  LStr: string;
begin
  Result := '';

//  if Length(ACertNo) = 17 then
//  begin
    LStr := ACertNo;
    strToken(LStr, '-');
    LStr := strToken(LStr, '-');
    AYear := StrToIntDef(LStr,0);
    Result := RightStr(ACertNo,4);
//  end;
end;

procedure TCertEditF.HullNoEditButtonClick(Sender: TObject);
begin
  ShowSearchVesselForm(Sender);
  DisplayEditPosition;
end;

procedure TCertEditF.IMONoEditButtonClick(Sender: TObject);
begin
  ShowSearchVesselForm(Sender);
  DisplayEditPosition;
end;

procedure TCertEditF.IssueDatePickerChange(Sender: TObject);
begin
  DisplayEditPosition;
end;

function TCertEditF.LoadCertDetail2CertRecordFromForm(
  var ACertRecord: TSQLHGSCertRecord): Boolean;
begin
  Result := CertNoButtonEdit.Text <> '';

  if not Result then
  begin
    ShowMessage('Cert. No. is invalid!');
    exit;
  end;

  with ACertRecord do
  begin
    CertType := g_HGSCertType.ToType(CertTypeCB.ItemIndex);
    CertNo := CertNoButtonEdit.Text;
    CompanyName := SubCompanyEdit.Text;
    CompanyCode := CompanyCodeEdit.Text;
    CompanyNatoin := CompanyNationEdit.Text;
    OrderNo := OrderNoEdit.Text;
    SalesAmount := SalesAmountEdit.Text;
    ProductType := g_ShipProductType.ToType(ProductTypeCB.ItemIndex);
    CertFileDBPath := CertFileDBPathEdit.Text;
    CertFileDBName := CertFileDBNameEdit.Text;
    PrevCertNo := PrevCertNoEdit.Text;
    FileCount := GSFileFrame.fileGrid.RowCount;
    UntilValidity := TimeLogFromDateTime(UntilValidityDatePicker.Date);
    UpdateDate := TimeLogFromDateTime(now);
    IssueDate := TimeLogFromDateTime(IssueDatePicker.Date);

    TrainedSubject := TrainedSubjectEdit.Text;
    TrainedCourse := TrainedCourseEdit.Text;
    TraineeName := TraineeNameEdit.Text;
    if CourseLevelCB.ItemIndex <> -1 then
      CourseLevel := g_AcademyCourseLevel.ToType(CourseLevelCB.ItemIndex);
    TrainedBeginDate := TimeLogFromDateTime(TrainedBeginDatePicker.Date);
    TrainedEndDate := TimeLogFromDateTime(TrainedEndDatePicker.Date);

    ReportNo := ReportNoEdit.Text;
    VDRSerialNo := VDRSerialNoEdit.Text;
    PlaceOfSurvey := PlaceOfSurveyEdit.Text;
    PICEmail := PICEmailEdit.Text;
    PICPhone := PICPhoneEdit.Text;
    IMONo := IMONoEdit.Text;
    ShipName := ShipNameEdit.Text;
    HullNo := HullNoEdit.Text;
    OwnerName := OwnerNameEdit.Text;
    ClassSociety := ClassSocietyEdit.Text;
    VDRType := VDRTypeEdit.Text;
    APTServiceDate := TimeLogFromDateTime(APTServiceDatePicker.Date);
  end;
end;

//ACertType = 1 : Education용 Cert
//            2 : APT Report용 Cert
//            3 : Product Approval용 Cert
procedure TCertEditF.MakeCertDoc(ACertType: integer; AIsSaveFile: Boolean;
  AIsWordClose: Boolean);
var
  LCompanyName, LDate: string;
  LStr, LStr2, LStr3: string;
  FormatStrings: TFormatSettings;
  LMonth: integer;
  WordApp, WordApp2: OLEVariant;
  LWordDocument: OLEVariant;
  LTable, LTable2, LCell: OLEVariant;
  LIni: TMemIniFile;
begin
  SetCurrentDir(ExtractFilePath(Application.exename));
  LStr := CertFileDBPathEdit.Text;

  if LStr = '' then
  begin
    ShowMessage('Please fill in the "File DB Path" first!');
    exit;
  end;

  QRCodeFrame1.CopyBitmapToClipboard;

  case ACertType of
    1: LStr2 := 'Education_Cert.docx';
    2: begin
      LStr2 := ATR_FILENAME;
      LStr3 := COC_FILENAME;
    end;
    3: LStr2 := 'APT_Approval_Certificate.docx';
  end;

  LStr := LStr+LStr2;

  if not FileExists(LStr) then
  begin
    ShowMessage('File (' + LStr + ') is not exists');
    exit;
  end;

  LStr := ExpandFileName(LStr);
  WordApp := GetActiveMSWordOleObject(LStr, True);

  case ACertType of
    1: begin
      Word_StringReplace2(WordApp, 'Cert_No', CertNoButtonEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'T_Course', TrainedSubjectEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'T_Name', TraineeNameEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'C_Name', SubCompanyEdit.Text, [wrfReplaceAll]);
      LStr := FormatDateTime('mmm.dd', TrainedBeginDatePicker.Date) + ' ~ ' +
        FormatDateTime('mmm.dd,yyyy', TrainedEndDatePicker.Date);
      Word_StringReplace2(WordApp, 'T_Period', LStr, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'T_Subject', TrainedSubjectEdit.Text, [wrfReplaceAll]);
      LStr := FormatDateTime('mmm, yyyy',UntilValidityDatePicker.Date);
      Word_StringReplace2(WordApp, 'V_Date', LStr, [wrfReplaceAll]);
      Word_InsertImageFromClipboard(WordApp);
    end;
    2: begin
      Word_StringReplace2(WordApp, 'Report_No', ReportNoEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'PlaceOfSurvey', PlaceOfSurveyEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'PIC@Email', PICEmailEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'Phone_No', PICPhoneEdit.Text, [wrfReplaceAll]);

      LStr := VDRTypeEdit.Text;
      if LStr = 'E' then
        LStr := 'HIVDR-' + LStr + ' ' + VDRSerialNoEdit.Text
      else
      if LStr = 'N' then
        LStr := 'HIVDR ' + VDRSerialNoEdit.Text;

      Word_StringReplace2(WordApp, 'VDR_Serial_No', LStr, [wrfReplaceAll]);
      LStr := FormatDateTime('yyyy-mm-dd', APTServiceDatePicker.Date);//IssueDatePicker
      Word_StringReplace2(WordApp, 'Issue_Date', LStr, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'Class_Society', ClassSocietyEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'Company_Name', OwnerNameEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'Ship_Name', ShipNameEdit.Text, [wrfReplaceAll]);

      GetLocaleFormatSettings($0409, FormatStrings);
      LMonth := MonthOf(APTServiceDatePicker.Date);
      LStr := FormatStrings.LongMonthNames[LMonth] + ' ';
      LDate := FormatDateTime('yyyy', APTServiceDatePicker.Date);
      LStr := LStr + LDate;
      Word_StringReplace2(WordApp, 'Service_Date', LStr, [wrfReplaceAll]);

      LWordDocument := WordApp.ActiveDocument;
      LTable := LWordDocument.Tables.Item(1);
      LTable2 := LTable.Tables.Item(1);
      LCell := LTable2.Cell(1,1);
      Word_InsertImageToCellFromClipboard(LCell);
      Word_StringReplaceFooter(WordApp, 'Report_No', ReportNoEdit.Text, []);

      if AIsSaveFile then
      begin
        WordApp.ActiveDocument.SaveAs(GetTempATRFileName);
      end;

      if AIsWordClose then
      begin
        WordApp.ActiveDocument.Close;
        WordApp.Quit;
      end;

      LStr := CertFileDBPathEdit.Text;
      LStr := LStr+LStr3;

      if not FileExists(LStr) then
      begin
        ShowMessage('File (' + LStr + ') is not exists');
        exit;
      end;

      LStr := ExpandFileName(LStr);
      WordApp2 := GetActiveMSWordOleObject(LStr, True);
      Word_StringReplace2(WordApp2, 'Cert_No', CertNoButtonEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp2, 'Ship_Name', ShipNameEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp2, 'Imo_No', IMONoEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp2, 'VDR_Serial_No', VDRSerialNoEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp2, 'Place_Of_Survey', PlaceOfSurveyEdit.Text, [wrfReplaceAll]);

      LStr := FormatDateTime('dd', APTServiceDatePicker.Date) + ' ' +
        FormatStrings.LongMonthNames[LMonth] + ' ';
      LStr := LStr + LDate;
      Word_StringReplace2(WordApp2, 'Service_Date', LStr, [wrfReplaceAll]);

      Word_StringReplace2(WordApp2, 'Agent_Name', SubCompanyEdit.Text, [wrfReplaceAll]);
      Word_StringReplace2(WordApp2, 'Agent_Nation', CompanyNationEdit.Text, [wrfReplaceAll]);
      Word_InsertImageFromClipboard(WordApp2);

      if AIsSaveFile then
      begin
        WordApp2.ActiveDocument.SaveAs(GetTempCOCFileName);
      end;

      if AIsWordClose then
      begin
        WordApp2.ActiveDocument.Close;
        WordApp2.Quit;
      end;

      if VDRConfigMemo.Text <> '' then
      begin
        LIni := TMemIniFile.Create('');
        try
          LIni.SetStrings(VDRConfigMemo.Lines);

          LStr := LIni.ReadString('Normal Configuration Data', 'Vessel', '');
          LMonth := VDRConfigMemo.Lines.IndexOf('Vessel='+LStr);
          if LMonth > -1 then
            VDRConfigMemo.Lines.Strings[LMonth] := 'Vessel='+ShipNameEdit.Text;

          LStr := LIni.ReadString('Normal Configuration Data', 'IMO Vessel ID', '');
          LMonth := VDRConfigMemo.Lines.IndexOf('IMO Vessel ID='+LStr);
          if LMonth > -1 then
            VDRConfigMemo.Lines.Strings[LMonth] := 'IMO Vessel ID='+IMONoEdit.Text;

          LStr := LIni.ReadString('Normal Configuration Data', 'Type Approval Authority', '');
          LMonth := VDRConfigMemo.Lines.IndexOf('Type Approval Authority='+LStr);
          if LMonth > -1 then
            VDRConfigMemo.Lines.Strings[LMonth] := 'Type Approval Authority='+ClassSocietyEdit.Text;

          VDRConfigMemo.Lines.SaveToFile(GetTempVDRConfigFileName);
        finally
          LIni.Free;
        end;
      end;

    end;
    3: begin
      LCompanyName := SubCompanyEdit.Text;
      Word_StringReplace2(WordApp, 'CompanyName1', LCompanyName, [wrfReplaceAll]);
      LCompanyName := CompanyNationEdit.Text;
      Word_StringReplace2(WordApp, 'CompanyNation', LCompanyName, [wrfReplaceAll]);
      LMonth := MonthOf(IssueDatePicker.Date);
      GetLocaleFormatSettings($0409, FormatStrings);
      LStr := FormatStrings.LongMonthNames[LMonth] + ' ';
      LDate := FormatDateTime('dd yyyy', IssueDatePicker.Date);
      Insert(LStr, LDate, 4);
      Word_StringReplace2(WordApp, 'Date1', LDate, [wrfReplaceAll]);
      Word_StringReplace2(WordApp, 'Cert_No', CertNoButtonEdit.Text, [wrfReplaceAll]);
      Word_InsertImageFromClipboard(WordApp,2);
    end;
  end;
end;

procedure TCertEditF.MakeCertXls;
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;
  LPicture: OleVariant;
  LStr, LStr2: string;
begin
  LStr := CertFileDBPathEdit.Text;

  LExcel := GetActiveExcelOleObject(True);
  try
    LWorkBook := LExcel.Workbooks.Open(LStr + 'Cert.ods');
    LWorksheet := LExcel.ActiveSheet;

    LStr := CertNoButtonEdit.Text;
    strToken(LStr, '-'); //CertNo에서 HGA 제거
    LStr2 := strToken(LStr, '-'); //년도
    LRange := LWorksheet.range['Q2'];
    LRange.FormulaR1C1 := LStr2;
    LRange := LWorksheet.range['U2'];
    LRange.Value := '''' + LStr;
    LRange := LWorksheet.range['Z29'];
    LRange.FormulaR1C1 := TrainedSubjectEdit.Text;
    LRange := LWorksheet.range['Z34'];
    LRange.FormulaR1C1 := TraineeNameEdit.Text;
    LRange := LWorksheet.range['Z38'];
    LRange.FormulaR1C1 := SubCompanyEdit.Text;
    LRange := LWorksheet.range['Z41'];
    LRange.FormulaR1C1 := FormatDateTime('mmm.dd', TrainedBeginDatePicker.Date) + ' ~ ' +
      FormatDateTime('mmm.dd,yyyy', TrainedEndDatePicker.Date);
    LRange := LWorksheet.range['Z45'];
    LRange.FormulaR1C1 := TrainedSubjectEdit.Text;
    LRange := LWorksheet.range['Z48'];
    LRange.FormulaR1C1 := TrainedCourseEdit.Text;
    LRange := LWorksheet.range['AP52'];
    LRange.FormulaR1C1 := FormatDateTime('mmm',UntilValidityDatePicker.Date);
    LRange := LWorksheet.range['AT52'];
    LRange.FormulaR1C1 := FormatDateTime('yyyy',UntilValidityDatePicker.Date);
    QRCodeFrame1.CopyBitmapToClipboard;
    LRange := LWorksheet.range['AS55'];
    LRange.Select;
    LWorksheet.Paste;
//    LPicture := LRange.ColumnWidth;
//    LPicture := LRange.RowHeight;
    LExcel.Selection.ShapeRange.Width := LRange.ColumnWidth*6;
    LExcel.Selection.ShapeRange.Height := LRange.RowHeight*6;
  finally
//    LWorkBook.Close;
//    LExcel.Quit;
  end;
end;

procedure TCertEditF.MakeZip4APTDoc(AShowCompletionMsg: Boolean);
var
  LZip: TZipWrite;
  LZipFileName, LTempDir, LFileName, LFileName2: string;
begin
  LZipFileName := ReportNoEdit.Text;

  if LZipFileName = '' then
  begin
    ShowMessage('Please check the Report No.');
    exit;
  end;

  LTempDir := 'c:\temp\';
  EnsureDirectoryExists(LTempDir);
  MakeCertDoc(CertTypeCB.ItemIndex, True, True);
  LZipFileName := ChangeFileExt(LZipFileName, '.zip');
  LZip := TZipWrite.Create(LTempDir+LZipFileName);
  try
    LFileName := GetTempATRFileName;

    if FileExists(LFileName) then
    begin
      LFileName2 := ExtractFileName(ChangeFileExt(LFileName, '.doc'));
      LZip.AddDeflated(LFileName, True, 6, LFileName2);
    end;

    LFileName := GetTempCOCFileName;

    if FileExists(LFileName) then
    begin
      LFileName2 := ExtractFileName(ChangeFileExt(LFileName, '.doc'));
      LZip.AddDeflated(LFileName, True, 6, LFileName2);
    end;

    LFileName := GetTempVDRConfigFileName;

    if FileExists(LFileName) then
      LZip.AddDeflated(LFileName);

  finally
    FreeAndNil(LZip);
  end;

  if AShowCompletionMsg then
  begin
    DeleteFile(GetTempATRFileName);
    DeleteFile(GetTempCOCFileName);
    DeleteFile(GetTempVDRConfigFileName);
    ShowMessage('Zip File is created successfully in ' + LTempDir+LZipFileName);
  end;
end;

procedure TCertEditF.QRCodeFrame1pbPreviewPaint(Sender: TObject);
begin
  QRCodeFrame1.pbPreviewPaint(Self);
end;

procedure TCertEditF.ReportNoEditButtonClick(Sender: TObject);
begin
  CreateVDRTestReportNo;
end;

procedure TCertEditF.RestoreColorExceptComponent(ATag: integer);
var
  i:integer;
begin
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if Self.Components[i].Tag <> 0 then
      if Self.Components[i].Tag <> ATag then
        if IsPublishedProp(Self.Components[i], 'Color') then
          if Self.Components[i].ClassType = TJvDatePickerEdit then
          begin
            if TJvDatePickerEdit(Self.Components[i]).Color = clYellow then
              SetOrdProp(Self.Components[i], 'Color', clInfoBk);
          end
          else
            SetOrdProp(Self.Components[i], 'Color', clWindow);
  end;
end;

procedure TCertEditF.SaveGSFile2DB;
begin
  if CertFileDBNameEdit.Text = '' then
  begin
    ShowMessage('File DB Name is empty!');
    exit;
  end;

  InitGSFileClient2('files\'+CertFileDBNameEdit.Text);
  try
    if not Assigned(GSFileFrame.FGSFiles_) then
      GSFileFrame.FGSFiles_ := GetGSFiles;

    if High(GSFileFrame.FGSFiles_.Files) >= 0 then
    begin
      g_FileDB.Delete(TSQLGSFile, GSFileFrame.FGSFiles_.ID);
      g_FileDB.Add(GSFileFrame.FGSFiles_, true);
    end
    else
      g_FileDB.Delete(TSQLGSFile, GSFileFrame.FGSFiles_.ID);
  finally
    DestroyGSFile;
  end;
end;

procedure TCertEditF.ScreenActiveControlChange(Sender: TObject);
begin
  UnitFormUtil.ScreenActiveControlChange(Sender, FActiveControl, FPrevInactiveColor);
end;

procedure TCertEditF.ShipNameEditButtonClick(Sender: TObject);
begin
  ShowSearchVesselForm(Sender);
  DisplayEditPosition;
end;

procedure TCertEditF.ShowSearchVDRForm;
var
  LSearchVDRF: TSearchVDRF;
begin
  LSearchVDRF := TSearchVDRF.Create(nil);
  try
    LSearchVDRF.VDRSerialNoEdit.Text := Self.VDRSerialNoEdit.Text;

    if Self.ImoNoEdit.Text <> '' then
      LSearchVDRF.ImoNoEdit.Text := Self.ImoNoEdit.Text
    else
    if Self.HullNoEdit.Text <> '' then
      LSearchVDRF.HullNoEdit.Text := Self.HullNoEdit.Text
    else
    if Self.ShipNameEdit.Text <> '' then
      LSearchVDRF.ShipNameEdit.Text := Self.ShipNameEdit.Text;

    if (LSearchVDRF.ImoNoEdit.Text <> '') or (Self.HullNoEdit.Text <> '')
                                          or (Self.ShipNameEdit.Text <> '') then
      LSearchVDRF.SearchButtonClick(nil);

    if LSearchVDRF.ShowModal = mrOK then
    begin
      if LSearchVDRF.VDRListGrid.SelectedRow <> -1 then
      begin
        VDRSerialNoEdit.Text := LSearchVDRF.VDRListGrid.CellsByName['VDRSerialNo',LSearchVDRF.VDRListGrid.SelectedRow];
        VDRTypeEdit.Text := LSearchVDRF.VDRListGrid.CellsByName['VDRType',LSearchVDRF.VDRListGrid.SelectedRow];
        VDRConfigMemo.Text := LSearchVDRF.VDRListGrid.CellsByName['VDRConfig',LSearchVDRF.VDRListGrid.SelectedRow];

        if HullNoEdit.Text = '' then
          HullNoEdit.Text := LSearchVDRF.VDRListGrid.CellsByName['HullNo',LSearchVDRF.VDRListGrid.SelectedRow];

        if ShipNameEdit.Text = '' then
          ShipNameEdit.Text := LSearchVDRF.VDRListGrid.CellsByName['ShipName',LSearchVDRF.VDRListGrid.SelectedRow];

        if ImoNoEdit.Text = '' then
          ImoNoEdit.Text := LSearchVDRF.VDRListGrid.CellsByName['ImoNo',LSearchVDRF.VDRListGrid.SelectedRow];
      end;
    end;
  finally
    LSearchVDRF.Free;
    DisplayEditPosition;
  end;
end;

procedure TCertEditF.ShowSearchVesselForm(Sender: TObject);
var
  LSearchVesselF: TSearchVesselF;
begin
  LSearchVesselF := TSearchVesselF.Create(nil);
  try
    if TNxButtonEdit(Sender).Name = 'IMONoEdit' then
      LSearchVesselF.ImoNoEdit.Text := Self.IMONoEdit.Text
    else
    if TNxButtonEdit(Sender).Name = 'ShipNameEdit' then
      LSearchVesselF.ShipNameEdit.Text := Self.ShipNameEdit.Text
    else
    if TNxButtonEdit(Sender).Name = 'HullNoEdit' then
      LSearchVesselF.HullNoEdit.Text := Self.HullNoEdit.Text;

    if (Self.IMONoEdit.Text <> '') or (Self.ShipNameEdit.Text <> '')
                                      or (Self.HullNoEdit.Text <> '') then
      LSearchVesselF.SearchButtonClick(nil);

    if LSearchVesselF.ShowModal = mrOK then
    begin
      if LSearchVesselF.VesselListGrid.SelectedRow <> -1 then
      begin
        HullNoEdit.Text := LSearchVesselF.VesselListGrid.CellsByName['HullNo',LSearchVesselF.VesselListGrid.SelectedRow];
        ShipNameEdit.Text := LSearchVesselF.VesselListGrid.CellsByName['ShipName',LSearchVesselF.VesselListGrid.SelectedRow];
        ImoNoEdit.Text := LSearchVesselF.VesselListGrid.CellsByName['ImoNo',LSearchVesselF.VesselListGrid.SelectedRow];
        OwnerNameEdit.Text := LSearchVesselF.VesselListGrid.CellsByName['OwnerName',LSearchVesselF.VesselListGrid.SelectedRow];
        ClassSocietyEdit.Text := LSearchVesselF.VesselListGrid.CellsByName['SClass1',LSearchVesselF.VesselListGrid.SelectedRow];
      end;
    end;
  finally
    LSearchVesselF.Free;
  end;
end;

procedure TCertEditF.SubCompanyEditClickBtn(Sender: TObject);
var
  LSearchCustomerF: TSearchCustomerF;
begin
  LSearchCustomerF := TSearchCustomerF.Create(nil);
  try
    with LSearchCustomerF do
    begin
      FCompanyType := [ctAgent];

      if ShowModal = mrOk then
      begin
        if NextGrid1.SelectedRow <> -1 then
        begin
          Self.SubCompanyEdit.Text := NextGrid1.CellByName['CompanyName', NextGrid1.SelectedRow].AsString;
          Self.CompanyCodeEdit.Text := NextGrid1.CellByName['CompanyCode', NextGrid1.SelectedRow].AsString;
          Self.CompanyNationEdit.Text := NextGrid1.CellByName['Nation', NextGrid1.SelectedRow].AsString;
        end;
      end;
    end;
  finally
    LSearchCustomerF.Free;
    DisplayEditPosition;
  end;
end;

procedure TCertEditF.TrainedBeginDatePickerChange(Sender: TObject);
begin
  DisplayEditPosition;
end;

procedure TCertEditF.TrainedCourseEditButtonClick(Sender: TObject);
var
  LSubject, LCourseName: string;
begin
  if CreateCourseManageForm(LSubject, LCourseName) = mrOK then
  begin
    TrainedSubjectEdit.Text := LSubject;
    TrainedCourseEdit.Text := LCourseName;
    DisplayEditPosition;
  end;
end;

procedure TCertEditF.TrainedEndDatePickerChange(Sender: TObject);
begin
  DisplayEditPosition;
end;

procedure TCertEditF.TrainedSubjectEditButtonClick(Sender: TObject);
var
  LSubject, LCourseName: string;
begin
  if CreateCourseManageForm(LSubject, LCourseName) = mrOK then
  begin
    TrainedSubjectEdit.Text := LSubject;
    TrainedCourseEdit.Text := LCourseName;
    DisplayEditPosition;
  end;
end;

procedure TCertEditF.TraineeNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    DisplayEditPosition;
end;

procedure TCertEditF.UntilValidityDatePickerChange(Sender: TObject);
begin
  DisplayEditPosition;
end;

procedure TCertEditF.VDRSerialNoEditButtonClick(Sender: TObject);
begin
  InitHGSVDRClient(HGS_VDRLIST_DB_NAME);
  try
    ShowSearchVDRForm;
  finally
    DestroyHGSVDR;
  end;
end;

end.
