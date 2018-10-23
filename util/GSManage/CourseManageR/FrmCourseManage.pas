unit FrmCourseManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBaseDlg, JvSelectDirectory,
  Vcl.ExtCtrls, AdvSmoothSplashScreen, Vcl.Menus, Vcl.ImgList, Vcl.ComCtrls,
  Vcl.StdCtrls, AdvGroupBox, AdvOfficeButtons, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, SBPro,
  AdvOfficeTabSet, AeroButtons, JvExControls, JvLabel, CurvyControls,
  UnitHGSCurriculumRecord, UnitHGSCurriculumData, UnitVesselData;

type
  TCourseManageF = class(TForm)
    Splitter1: TSplitter;
    CurvyPanel1: TCurvyPanel;
    JvLabel6: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel1: TJvLabel;
    SubjectEdit: TEdit;
    Panel1: TPanel;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    AeroButton1: TAeroButton;
    CourseEdit: TEdit;
    ProdTypeCB: TComboBox;
    TaskTab: TAdvOfficeTabSet;
    StatusBarPro1: TStatusBarPro;
    CourseListGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    TargetGroup: TNxTextColumn;
    ProductType: TNxTextColumn;
    Subject: TNxTextColumn;
    CourseName: TNxTextColumn;
    TrainDays: TNxTextColumn;
    CertFileDBPath: TNxTextColumn;
    CertFileDBName: TNxTextColumn;
    Attachments: TNxButtonColumn;
    UpdateDate: TNxTextColumn;
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
    CreateCertDocument1: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    N1: TMenuItem;
    DeleteSelectedCert1: TMenuItem;
    ImageList32x32: TImageList;
    SplashScreen1: TAdvSmoothSplashScreen;
    Timer1: TTimer;
    JvSelectDirectory1: TJvSelectDirectory;
    JvLabel2: TJvLabel;
    CourseLevelCB: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure ImportGeneratorMasterFromXlsFile1Click(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure CourseListGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure Add1Click(Sender: TObject);
    procedure DeleteSelectedCert1Click(Sender: TObject);
  private
    procedure GetCourseList2Grid(AIsFromRemote: Boolean = False);
    procedure GetCourseSearchParam2Rec(var ACourseSearchParamRec: TCurriculumSearchParamRec);
    procedure GetCourseListFromLocal(ACourseSearchParamRec: TCurriculumSearchParamRec);
    procedure GetCourseListFromVariant2Grid(ADoc: Variant);
    procedure ShowCourseEditFormFromGrid(ARow: integer; ASelectMode: Boolean; AAttachPageView: Boolean=false);
    procedure DeleteHGSFileDB(ARow: integer);
  public
    FSelectMode: Boolean;
    FSubject,FCourseName: string;
  end;

function CreateCourseManageForm(var ASubject,ACourseName: string;
  ASelectMode: Boolean=true): integer;

var
  CourseManageF: TCourseManageF;

implementation

uses UnitEnumHelper, SynCommons, UnitExcelUtil, FrmCourseEdit;

{$R *.dfm}

function CreateCourseManageForm(var ASubject,ACourseName: string;
  ASelectMode: Boolean=true): integer;
var
  LCourseManageF: TCourseManageF;
  LSQLHGSCurriculumRecord: TSQLHGSCurriculumRecord;
  LDoc: variant;
begin
  LCourseManageF := TCourseManageF.Create(nil);
  try
    LCourseManageF.FSelectMode := ASelectMode;

    if ASelectMode then
    begin
      LCourseManageF.SubjectEdit.Text := ASubject;
      LCourseManageF.CourseEdit.Text := ACourseName;
      LCourseManageF.btn_Close.Visible := False;
      LCourseManageF.GetCourseList2Grid;
      Result := LCourseManageF.ShowModal;

      if Result = mrOK then
      begin
        ASubject := LCourseManageF.FSubject;
        ACourseName := LCourseManageF.FCourseName;
      end;
    end
    else
    begin

    end;
  finally
    LCourseManageF.Free;
  end;
end;

procedure TCourseManageF.Add1Click(Sender: TObject);
begin
  CreateCourseEditFormFromDB('','');
  GetCourseList2Grid;
end;

procedure TCourseManageF.AeroButton1Click(Sender: TObject);
begin
  NextGridToExcel(CourseListGrid);
end;

procedure TCourseManageF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TCourseManageF.btn_SearchClick(Sender: TObject);
begin
  GetCourseList2Grid;
end;

procedure TCourseManageF.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TCourseManageF.CourseListGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  if FSelectMode then
  begin
    FSubject := CourseListGrid.CellsByName['Subject', ARow];
    FCourseName := CourseListGrid.CellsByName['CourseName', ARow];
    Self.ModalResult := mrOK;
  end
  else
    ShowCourseEditFormFromGrid(ARow, False);
end;

procedure TCourseManageF.DeleteHGSFileDB(ARow: integer);
var
  LDBFileName: string;
begin
  LDBFileName := CourseListGrid.CellsByName['CourseFileDBPath', ARow] +
    CourseListGrid.CellsByName['CourseFileDBName', ARow];

  if FileExists(LDBFileName) then
    DeleteFile(LDBFileName);
end;

procedure TCourseManageF.DeleteSelectedCert1Click(Sender: TObject);
var
  LSubject: string;
begin
  if CourseListGrid.SelectedRow = -1 then
    exit;

  if MessageDlg('Selected Course will be deleted.' + #13#10 + 'Are you sure?',
    mtConfirmation, [mbYes, mbNo], 0)= mrNo then
    exit;

  LSubject := CourseListGrid.CellsByName['Subject', CourseListGrid.SelectedRow];

  if LSubject <> '' then
  begin
    DeleteHGSCurriculum(LSubject);
    DeleteHGSFileDB(CourseListGrid.SelectedRow);
    GetCourseList2Grid;
    CourseListGrid.ScrollToRow(CourseListGrid.SelectedRow);
  end;
end;

procedure TCourseManageF.FormCreate(Sender: TObject);
begin
  InitHGSCurriculumClient(HGS_CURRICULUM_DB_NAME);

  g_ShipProductType.SetType2Combo(ProdTypeCB);
  g_AcademyCourseLevelDesc.SetType2Combo(CourseLevelCB);
end;

procedure TCourseManageF.GetCourseList2Grid(AIsFromRemote: Boolean);
var
  LSQLHGSCurriculumRecord: TSQLHGSCurriculumRecord;
  LCurriculumSearchParamRec: TCurriculumSearchParamRec;
  LDoc: Variant;
begin
  CourseListGrid.BeginUpdate;
  try
    CourseListGrid.ClearRows;
    GetCourseSearchParam2Rec(LCurriculumSearchParamRec);

//    if AIsFromRemote then
//      GetVesselListFromRemote(LCourseSearchParamRec)
//    else
      GetCourseListFromLocal(LCurriculumSearchParamRec);
  finally
    CourseListGrid.EndUpdate;
  end;
end;

procedure TCourseManageF.GetCourseListFromLocal(
  ACourseSearchParamRec: TCurriculumSearchParamRec);
var
  LSQLHGSCurriculumRecord: TSQLHGSCurriculumRecord;
  LDoc: Variant;
begin
  LSQLHGSCurriculumRecord := GetHGSCurriculumRecordFromSearchRec(ACourseSearchParamRec);
  try
    if LSQLHGSCurriculumRecord.IsUpdate then
    begin
      LSQLHGSCurriculumRecord.FillRewind;

      while LSQLHGSCurriculumRecord.FillOne do
      begin
        LDoc := GetVariantFromHGSCurriculumRecord(LSQLHGSCurriculumRecord);
        GetCourseListFromVariant2Grid(LDoc);
      end;//while

      StatusBarPro1.Panels[1].Text := IntToStr(CourseListGrid.RowCount);
    end;
  finally
    LSQLHGSCurriculumRecord.Free;
  end;
end;

procedure TCourseManageF.GetCourseListFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
  LShipProductTypes: integer;//TShipProductTypes;
begin
  LRow := CourseListGrid.AddRow;

  CourseListGrid.CellsByName['Subject', LRow] := ADoc.Subject;
  CourseListGrid.CellsByName['CourseName', LRow] := ADoc.CourseName;
  CourseListGrid.CellsByName['TargetGroup', LRow] := ADoc.TargetGroup;
  CourseListGrid.CellsByName['TrainDays', LRow] := ADoc.TrainDays;
  LShipProductTypes := ADoc.ProductType;
  CourseListGrid.CellsByName['ProductType', LRow] := g_ShipProductType.ToString(LShipProductTypes);

  if ADoc.UpdateDate > 127489752310 then
    CourseListGrid.CellsByName['UpdateDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.UpdateDate));

  CourseListGrid.CellByName['Attachments', LRow].AsInteger := ADoc.FileCount;
end;

procedure TCourseManageF.GetCourseSearchParam2Rec(
  var ACourseSearchParamRec: TCurriculumSearchParamRec);
begin
  ACourseSearchParamRec := Default(TCurriculumSearchParamRec);
  ACourseSearchParamRec.fSubject := SubjectEdit.Text;
  ACourseSearchParamRec.fCourseName := CourseEdit.Text;

  if CourseLevelCB.ItemIndex = -1 then
    ACourseSearchParamRec.fCourseLevel := g_AcademyCourseLevelDesc.ToType(0)
  else
    ACourseSearchParamRec.fCourseLevel := g_AcademyCourseLevelDesc.ToType(CourseLevelCB.ItemIndex);

  if ProdTypeCB.ItemIndex = -1 then
    ACourseSearchParamRec.fProductType := g_ShipProductType.ToType(0)
  else
    ACourseSearchParamRec.fProductType := g_ShipProductType.ToType(ProdTypeCB.ItemIndex);;
end;

procedure TCourseManageF.ImportGeneratorMasterFromXlsFile1Click(
  Sender: TObject);
begin
  CreateCourseEditFormFromDB('','');
  GetCourseList2Grid;
end;

procedure TCourseManageF.ShowCourseEditFormFromGrid(ARow: integer;
  ASelectMode, AAttachPageView: Boolean);
var
  LSubject, LCourseName: string;
begin
  LSubject := CourseListGrid.CellsByName['Subject', ARow];
  LCourseName := CourseListGrid.CellsByName['CourseName', ARow];

  if CreateCourseEditFormFromDB(LSubject, LCourseName, ASelectMode, AAttachPageView) = mrOK then
  begin
    GetCourseList2Grid;
    CourseListGrid.ScrollToRow(ARow);
  end;
end;

end.
