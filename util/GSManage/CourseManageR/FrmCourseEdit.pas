unit FrmCourseEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, Vcl.StdCtrls,
  FrameGSFileList, Vcl.ComCtrls, NxEdit, JvExControls, JvLabel,
  AdvOfficePager, AeroButtons, Vcl.ExtCtrls,
  UnitHGSCurriculumRecord, UnitGSFileRecord;

type
  TCourseEditF = class(TForm)
    Panel1: TPanel;
    AeroButton1: TAeroButton;
    btn_Close: TAeroButton;
    Panel3: TPanel;
    AdvOfficePage1: TAdvOfficePager;
    CertInfoPage: TAdvOfficePage;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel49: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    ProductTypeCB: TComboBox;
    UpdateDatePicker: TDateTimePicker;
    TrainedSubjectEdit: TNxButtonEdit;
    TrainedCourseEdit: TNxButtonEdit;
    CourseFileDBPathEdit: TNxButtonEdit;
    CourseFileDBNameEdit: TNxButtonEdit;
    CourseLevelCB: TComboBox;
    AttachmentPage: TAdvOfficePage;
    GSFileFrame: TGSFileListFrame;
    ImageList16x16: TImageList;
    Imglist16x16: TImageList;
    JvLabel1: TJvLabel;
    JvLabel5: TJvLabel;
    TrainDaysEdit: TEdit;
    TargetGroupEdit: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    FGSFileDBName,
    FGSFileDBPath: string;

    procedure GetCourseDetailFromCurriculumRecord(ASQLHGSCurriculumRecord: TSQLHGSCurriculumRecord);
    procedure GetCourseFileList2FileGrid(const AFileDBName: string);
    procedure SaveGSFile2DB;
    function LoadCourseDetail2CurriculumRecordFromForm(var ACurriculumRecord: TSQLHGSCurriculumRecord): Boolean;
  public
    { Public declarations }
  end;

function CreateCourseEditFormFromDB(ASubject,ACourseName: string;
  ASelectMode: Boolean=false; AAttachPageView: Boolean=false): integer;

var
  CourseEditF: TCourseEditF;

implementation

uses SynCommons, UnitVesselData,  DragDropInternet, DragDropFormats, DateUtils,
  UnitCryptUtil, System.StrUtils, UnitFolderUtil, UnitExcelUtil,
  UnitStringUtil, UnitHGSCurriculumData;//, Excel2000;

{$R *.dfm}

function CreateCourseEditFormFromDB(ASubject,ACourseName: string;
  ASelectMode: Boolean=false; AAttachPageView: Boolean=false): integer;
var
  LCourseEditF: TCourseEditF;
  LSQLHGSCurriculumRecord: TSQLHGSCurriculumRecord;
  LDoc: variant;
begin
  LCourseEditF := TCourseEditF.Create(nil);
  try
    LCourseEditF.GSFileFrame.InitDragDrop;
    LCourseEditF.GSFileFrame.AddButton.Align :=alLeft;
    LCourseEditF.GSFileFrame.ApplyButton.Visible := False;
    LCourseEditF.GSFileFrame.CloseButton.Visible := False;

    if (ASubject = '') and (ACourseName = '') then
      LSQLHGSCurriculumRecord := TSQLHGSCurriculumRecord.Create
    else
      LSQLHGSCurriculumRecord := GetHGSCurriculumFromSubject(ASubject,ACourseName);

    try
      LCourseEditF.GetCourseDetailFromCurriculumRecord(LSQLHGSCurriculumRecord);

      if AAttachPageView then
        LCourseEditF.AdvOfficePage1.ActivePageIndex := 1
      else
        LCourseEditF.AdvOfficePage1.ActivePageIndex := 0;

      Result := LCourseEditF.ShowModal;

      if Result = mrOK then
      begin
        if LCourseEditF.LoadCourseDetail2CurriculumRecordFromForm(LSQLHGSCurriculumRecord) then
        begin
          AddOrUpdateHGSCurriculum(LSQLHGSCurriculumRecord);
          LCourseEditF.SaveGSFile2DB;

          ShowMessage('Data Save Is OK!');
        end;
      end;
    finally
      LSQLHGSCurriculumRecord.Free;
    end;
  finally
    LCourseEditF.Free;
  end;
end;

{ TCourseEditF }

procedure TCourseEditF.FormCreate(Sender: TObject);
begin
  g_ShipProductType.SetType2Combo(ProductTypeCB);
  g_AcademyCourseLevelDesc.SetType2Combo(CourseLevelCB);
end;

procedure TCourseEditF.GetCourseDetailFromCurriculumRecord(
  ASQLHGSCurriculumRecord: TSQLHGSCurriculumRecord);
begin
  if ASQLHGSCurriculumRecord.IsUpdate then
  begin
    with ASQLHGSCurriculumRecord do
    begin
      TrainedSubjectEdit.Text := Subject;
      TrainedCourseEdit.Text := CourseName;
      TrainDaysEdit.Text := IntToStr(TrainDays);
      TargetGroupEdit.Text := TargetGroup;
      CourseFileDBPathEdit.Text := CourseFileDBPath;
      CourseFileDBNameEdit.Text := CourseFileDBName;

      ProductTypeCB.ItemIndex := Ord(ProductType);
      CourseLevelCB.ItemIndex := Ord(CourseLevel);
      UpdateDatePicker.Date := TimeLogToDateTime(UpdateDate);

      if CourseFileDBName <> '' then
      begin
        FGSFileDBName := 'files\'+CourseFileDBName;
        FGSFileDBPath := CourseFileDBPath;
        GetCourseFileList2FileGrid(FGSFileDBName);
      end;
    end;
  end;
end;

procedure TCourseEditF.GetCourseFileList2FileGrid(const AFileDBName: string);
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

function TCourseEditF.LoadCourseDetail2CurriculumRecordFromForm(
  var ACurriculumRecord: TSQLHGSCurriculumRecord): Boolean;
begin
  Result := TrainedSubjectEdit.Text <> '';

  if not Result then
  begin
    ShowMessage('Subject is invalid!');
    exit;
  end;

  with ACurriculumRecord do
  begin
    Subject := TrainedSubjectEdit.Text;
    CourseName := TrainedCourseEdit.Text;
    TrainDays := StrToIntDef(TrainDaysEdit.Text,0);
    TargetGroup := TargetGroupEdit.Text;
    CourseFileDBPath := CourseFileDBPathEdit.Text;
    CourseFileDBName := CourseFileDBNameEdit.Text;
    FileCount := GSFileFrame.fileGrid.RowCount;

    ProductType := g_ShipProductType.ToType(ProductTypeCB.ItemIndex);
    CourseLevel := g_AcademyCourseLevel.ToType(CourseLevelCB.ItemIndex);
    UpdateDate := TimeLogFromDateTime(now);
  end;
end;

procedure TCourseEditF.SaveGSFile2DB;
begin
  if CourseFileDBNameEdit.Text = '' then
  begin
    ShowMessage('File DB Name is empty!');
    exit;
  end;

  InitGSFileClient2('files\'+CourseFileDBNameEdit.Text);
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

end.
