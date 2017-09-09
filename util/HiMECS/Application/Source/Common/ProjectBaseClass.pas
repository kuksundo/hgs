unit ProjectBaseClass;

interface

uses System.SysUtils, Classes, Generics.Legacy, BaseConfigCollect;

type
  TProjectInfoItem = class(TCollectionItem)
  private
    FProjectNo, //공사번호
    FEngNo,    //엔진순번
    FEngType, //엔진타입
    FInternalTester //자체 시운전 담당자 이름
    : string;
  published
    property ProjectNo: string read FProjectNo write FProjectNo;
    property EngNo: string read FEngNo write FEngNo;
    property EngType: string read FEngType write FEngType;
    property InternalTester: string read FInternalTester write FInternalTester;
  end;

  TProjectInfoCollect<T: TProjectInfoItem> = class(Generics.Legacy.TCollection<T>)
  private
  public
  end;

  TVesselInfo = class(TpjhBase)
  private
    FProjectInfoCollect: TProjectInfoCollect<TProjectInfoItem>;

    FProjectName, //공사명
    FProjectNo,   //공사번호
    FProjectSeqNo,//공사순번(1개 공사를 여러개로 분리하여 관리 할 경우 사용됨)
    FSiteName,
    FSiteNo,
    FPlantName,
    FPlantNo,
    FShipName,    //호선명
    FShipNo,      //호선번호
    FEngineCount,//설치된 엔진 수량
    FAssyFactory, //조립공장
    FTestFactory, //시운전공장
    FSJDept, //선조립부서
    FSWDept, //수압+HEAD 부서
    FJJDept, //중조립부서
    FShipOwner,  //선주이름
    FClassSociety, //선급이름
    FEvaluatedBy,  //
    FOperatedBy,
    FFACTester,
    FModule1,
    FModule2,
    FModule3,
    FModule4 : string;

    FInternalTestDate: TDateTime;
    FFACDate: TDateTime; //Factory Acceptance Test Date
    FDeliveryDate: TDateTime; //납기
    FAssyStartDate: TDateTime; //조립 착수일

    FGetDataCompleted: Boolean; //구조체에 DB로부터 데이터를 채웠으면 True
  public
    //세부 공정관련 JSON 리스트를 저장함 (TreeGrid Data_Url에 사용)
    FProcessList: TStringList;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
    property GetDataCompleted: Boolean read FGetDataCompleted write FGetDataCompleted;
  published
    property ProjectInfoCollect: TProjectInfoCollect<TProjectInfoItem> read FProjectInfoCollect write FProjectInfoCollect;

    property ProjectName: string read FProjectName write FProjectName;
    property ProjectNo: string read FProjectNo write FProjectNo;
    property ProjectSeqNo: string read FProjectSeqNo write FProjectSeqNo;
    property SiteName: string read FSiteName write FSiteName;
    property SiteNo: string read FSiteNo write FSiteNo;
    property PlantName: string read FPlantName write FPlantName;
    property PlantNo: string read FPlantNo write FPlantNo;
    property ShipName: string read FShipName write FShipName;
    property ShipNo: string read FShipNo write FShipNo;
    property EngineCount: string read FEngineCount write FEngineCount;
    property AssyFactory: string read FAssyFactory write FAssyFactory;
    property TestFactory: string read FTestFactory write FTestFactory;
    property SJDept: string read FSJDept write FSJDept;
    property SWDept: string read FSWDept write FSWDept;
    property JJDept: string read FJJDept write FJJDept;
    property ShipOwner: string read FShipOwner write FShipOwner;
    property ClassSociety: string read FClassSociety write FClassSociety;
    property EvaluatedBy: string read FEvaluatedBy write FEvaluatedBy;
    property OperatedBy: string read FOperatedBy write FOperatedBy;
    property Module1: string read FModule1 write FModule1;
    property Module2: string read FModule2 write FModule2;
    property Module3: string read FModule3 write FModule3;
    property Module4: string read FModule4 write FModule4;
    property InternalTestDate: TDateTime read FInternalTestDate write FInternalTestDate;
    property FACDate: TDateTime read FFACDate write FFACDate;
    property DeliveryDate: TDateTime read FDeliveryDate write FDeliveryDate;
    property AssyStartDate: TDateTime read FAssyStartDate write FAssyStartDate;
  end;

implementation

{ TProjectInfoCollect }

{ TProjectInfo }

procedure TVesselInfo.Clear;
begin
;
end;

constructor TVesselInfo.Create(AOwner: TComponent);
begin
  FProjectInfoCollect := TProjectInfoCollect<TProjectInfoItem>.Create;
  FProcessList := TStringList.Create;
end;

destructor TVesselInfo.Destroy;
begin
  inherited Destroy;

  FProjectInfoCollect.Free;
  FProcessList.Free;
end;

end.
