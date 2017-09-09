unit UnitCraneIoTConfigInterface;

interface

uses SynCommons, UnitAlarmConfigClass;

type
  ICraneIoTConfig = interface(IInvokable)
    ['{F5C46078-FE54-45A8-98CA-391D50C8B913}']
    //공장 리스트 반환
    function GetPlantList: TRawUTF8DynArray;
    //공장 내에 있는 엔진 리스트 반환
    procedure GetEngineListFromPlant(PlantName: string; out EngList: TAlarmConfigCollect);
    //엔진의 센서(태그)리스트 반환
    procedure GetTagListFromEngine(ProjNo, EngNo: string; out TagList: TAlarmConfigEPCollect);
    //엔진에 설정된 알람 설정 리스트를 DB로 부터 조회하여 반환
    procedure GetAlarmConfigList(UserId, CatCode, ProjNo, EngNo: string;
      out TagNames: TAlarmConfigCollect);
    //알람 설정값을 DB에 저장함
    function SetAlarmConfigList2(const TagNames: RawJSON): Boolean;
    procedure SetAlarmConfigList(TagNames: TAlarmConfigCollect);
  end;

implementation

end.
