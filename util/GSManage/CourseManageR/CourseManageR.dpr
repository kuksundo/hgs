program CourseManageR;

uses
  Vcl.Forms,
  FrmCourseManage in 'FrmCourseManage.pas' {CourseManageF},
  UnitHGSCurriculumRecord in '..\CertManage\UnitHGSCurriculumRecord.pas',
  UnitHGSCurriculumData in '..\CertManage\UnitHGSCurriculumData.pas',
  UnitVesselData in '..\VesselList\UnitVesselData.pas',
  VarRecUtils in '..\..\..\common\openarr\source\VarRecUtils.pas',
  FrmCourseEdit in 'FrmCourseEdit.pas' {CourseEditF},
  FrameGSFileList in '..\..\..\common\Frames\FrameGSFileList.pas',
  FrmFileSelect in '..\FrmFileSelect.pas',
  UnitGSFileRecord in '..\UnitGSFileRecord.pas',
  UnitElecServiceData in '..\UnitElecServiceData.pas',
  CommonData in '..\CommonData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCourseManageF, CourseManageF);
  Application.Run;
end.
