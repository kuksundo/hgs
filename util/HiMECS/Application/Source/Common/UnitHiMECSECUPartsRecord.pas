unit UnitHiMECSECUPartsRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  UnitpjhSQLRecord,
  UnitECUData;

type
  TSQLDFECUPartsRecord = class(TSQLRecord)
  private
    fAreaCode, //A1: Engine Room, A2: GRU Room, A3: Engine Control Room
    fPanelCode,//T1: MCP or ACP, T2: ICM, T2: CMM, T4: LOP, M1: Engine, M2: Generator, M3: GRU
    fMachineCode,
    fCompanyName,
    fCompanyCode,
    fCompanyNatoin,
    fPICOfOrder,//수주 담당자
    fInstructors,//강사 리스트 Json Array 형식[{"Name":"pjh","CompanyName":"HGSA","Position":"차장"}]
    fCourseName,
    fOrderNo, //수통 번호
    fSalesAmount,
    fProjFileDBPath,
    fProjFileDBName,
    fNotes
    : RawUTF8;

    fTrainingStatus: TGATrainingStatus;
    fTrainingType: TGATrainingType;
    fTrainingPlace: TGATrainingPlace;
    fInstructorOrg: TGAInstructorOrg;
    fHotel: TGAHotel;

    fTrainingPlannedBeginDate, //교육 예정 시작 일자
    fTrainingPlannedEndDate, //교육 예정 종료 일자
    fTrainingActualBeginDate, //교육 시작 일자
    fTrainingActualEndDate, //교육 종료 일자

    fOrderDate,//수주 일자
    fSalesDate,//매출 일자
    fBillDate, //수금 일자
    fBillClearDate, //수금 정리 일자
    fUpdateDate
    : TTimeLog;
  public
    FIsUpdate: Boolean;
    fNextSerialNo: RawUTF8;
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
    property NextSerialNo: RawUTF8 read fNextSerialNo write fNextSerialNo;
  published
    property ProjectNo: RawUTF8 read fProjectNo write fProjectNo stored AS_UNIQUE;
    property ProjectName: RawUTF8 read fProjectName write fProjectName;
    property CompanyName: RawUTF8 read fCompanyName write fCompanyName;
    property CompanyCode: RawUTF8 read fCompanyCode write fCompanyCode;
    property CompanyNatoin: RawUTF8 read fCompanyNatoin write fCompanyNatoin;
    property PICOfOrder: RawUTF8 read fPICOfOrder write fPICOfOrder;
    property Instructors: RawUTF8 read fInstructors write fInstructors;
    property CourseName: RawUTF8 read fCourseName write fCourseName;
    property OrderNo: RawUTF8 read fOrderNo write fOrderNo;
    property SalesAmount: RawUTF8 read fSalesAmount write fSalesAmount;
    property ProjFileDBPath: RawUTF8 read fProjFileDBPath write fProjFileDBPath;
    property ProjFileDBName: RawUTF8 read fProjFileDBName write fProjFileDBName;
    property Notes: RawUTF8 read fNotes write fNotes;

    property TrainingStatus: TGATrainingStatus read fTrainingStatus write fTrainingStatus;
    property TrainingType: TGATrainingType read fTrainingType write fTrainingType;
    property TrainingPlace: TGATrainingPlace read fTrainingPlace write fTrainingPlace;
    property InstructorOrg: TGAInstructorOrg read fInstructorOrg write fInstructorOrg;
    property Hotel: TGAHotel read fHotel write fHotel;

    property OrderDate: TTimeLog read fOrderDate write fOrderDate;
    property SalesDate: TTimeLog read fSalesDate write fSalesDate;
    property BillDate: TTimeLog read fBillDate write fBillDate;
    property BillClearDate: TTimeLog read fBillClearDate write fBillClearDate;
    property UpdateDate: TTimeLog read fUpdateDate write fUpdateDate;
  end;

  TGAClass = class(TpjhSQLRecord)
    FSQLGARecord: TSQLGARecord;
    FGADB: TSQLRestClientURI;
    FGAModel: TSQLModel;
  public
    constructor Create; override;
    destructor Destroy; override;

    function GetAllGARecord(AGADB: TSQLRestClientURI = nil): TSQLGARecord;

    property SQLGARecord: TSQLGARecord read FSQLGARecord write FSQLGARecord;
  end;

implementation

end.
