unit UnitHGSCurriculumData;

interface

uses System.Classes, UnitEnumHelper;

type
  TAcademyCourseLevel = (aclNull, aclBasic, aclAdvanced, aclExpert,
    aclFinal);
  TAcademyActivityLevel = (aalNull, aalIntroduction, aalOperation, aalCommissioning,
    aalMaintenance, aalOptimization, aalTroubleShooting, aalFinal);

const
  HGS_CURRICULUM_DB_NAME = 'HGSCurriculumMaster.sqlite';

  R_AcademyCourseLevel : array[Low(TAcademyCourseLevel)..High(TAcademyCourseLevel)] of string =
    ('', 'B', 'A', 'S', '');
  R_AcademyCourseLevelDesc : array[Low(TAcademyCourseLevel)..High(TAcademyCourseLevel)] of string =
    ('', 'Basic', 'Advanced', 'Expert', '');
  R_AcademyActivityLevel : array[Low(TAcademyActivityLevel)..High(TAcademyActivityLevel)] of string =
    ('', 'A', 'B', 'C', 'D', 'E', 'F', '');
  R_AcademyActivityLevelDesc : array[Low(TAcademyActivityLevel)..High(TAcademyActivityLevel)] of string =
    ('', 'Introduction', 'Operation', 'Commissioning', 'Maintenance', 'Optimization', 'TroubleShooting', '');

procedure AcademyCourseLevel2List(AList:TStrings);
procedure AcademyActivityLevel2List(AList:TStrings);

var
  g_AcademyCourseLevel: TLabelledEnum<TAcademyCourseLevel>;
  g_AcademyCourseLevelDesc: TLabelledEnum<TAcademyCourseLevel>;
  g_AcademyActivityLevel: TLabelledEnum<TAcademyActivityLevel>;
  g_AcademyActivityLevelDesc: TLabelledEnum<TAcademyActivityLevel>;

implementation

procedure AcademyCourseLevel2List(AList:TStrings);
var Li: TAcademyCourseLevel;
begin
  AList.Clear;

  for Li := Succ(Low(TAcademyCourseLevel)) to Pred(High(TAcademyCourseLevel)) do
  begin
    AList.Add(R_AcademyCourseLevelDesc[Li]);
  end;
end;

procedure AcademyActivityLevel2List(AList:TStrings);
var Li: TAcademyActivityLevel;
begin
  AList.Clear;

  for Li := Succ(Low(TAcademyActivityLevel)) to Pred(High(TAcademyActivityLevel)) do
  begin
    AList.Add(R_AcademyActivityLevelDesc[Li]);
  end;
end;

initialization
  g_AcademyCourseLevel.InitArrayRecord(R_AcademyCourseLevel);
  g_AcademyCourseLevelDesc.InitArrayRecord(R_AcademyCourseLevelDesc);
  g_AcademyActivityLevel.InitArrayRecord(R_AcademyActivityLevel);
  g_AcademyActivityLevelDesc.InitArrayRecord(R_AcademyActivityLevelDesc);

end.
