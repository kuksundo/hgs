/// it's a good practice to put all data definition into a stand-alone unit
// - this unit will be shared between client and server
unit ScheduleSampleDataModel;

interface

uses
  SynCommons,
  mORMot, HolidayCollect;

const
  PROJ_SCH_DB_NAME = 'Schedule_Himsen.db3';
  PROJ_BASE_INFO_DB_NAME = 'Base_Info_Himsen.db3';
  HOLIDAY_INFO_DB_NAME = 'HoliDay_Info_Himsen.db3';

type
  //계획일정, 수정(예측)일정,실적일정
  TAdaptSchedule = (asPlan, asPredict, asActual);

  R_BaseInfo = packed record
    FEngineType: RawUTF8;
    FPPartNo: RawUTF8; //선행공정
    FPJobCode: RawUTF8;//선행작업
    FAPartNo: RawUTF8; //후행공정
    FAJobCode: RawUTF8;//후행작업
    FRelType: RawUTF8; //관계유형 : FS = FinishStart, SS = StartStart
    FBufferDay: RawUTF8;//버퍼일수
    FBigo: RawUTF8;
  end;

  R_BaseInfos = array of R_BaseInfo;

  TSQLHimsenJobRelation = class(TSQLRecord)
  private
    FEngineType: RawUTF8;
    FPPartNo: RawUTF8; //선행공정
    FPJobCode: RawUTF8;//선행작업
    FAPartNo: RawUTF8; //후행공정
    FAJobCode: RawUTF8;//후행작업
    FRelType: RawUTF8; //관계유형 : FS = FinishStart, SS = StartStart
    FBufferDay: RawUTF8;//버퍼일수
    FBigo: RawUTF8;
  published
    property EngineType: RawUTF8 read FEngineType write FEngineType;
    property PPartNo: RawUTF8 read FPPartNo write FPPartNo;
    property PJobCode: RawUTF8 read FPJobCode write FPJobCode;
    property APartNo: RawUTF8 read FAPartNo write FAPartNo;
    property AJobCode: RawUTF8 read FAJobCode write FAJobCode;
    property RelType: RawUTF8 read FRelType write FRelType;
    property BufferDay: RawUTF8 read FBufferDay write FBufferDay;
    property Bigo: RawUTF8 read FBigo write FBigo;
  end;

  TSQLScheduleSampleRecord = class(TSQLRecord)
  private
    FProjNo: RawUTF8;
    FShipNo: RawUTF8;
    FCylCount: RawUTF8;
    FEngineType: RawUTF8;
    FEngineCount: RawUTF8;
    FDeliveryDate: TDateTime;
    FActCode: RawUTF8;
    FDescription: RawUTF8;
    FDuration: RawUTF8;
    FProcessNo: RawUTF8; //공정번호
    FFactoryName: RawUTF8;
    FProcessDept: RawUTF8;
    FMachineNo: RawUTF8;
    FStandardOfEstimate: RawUTF8; //표준품셈
    FSOEAdjustFactor: RawUTF8; //품셈 조정 Factor
    FRealAdjustValue: RawUTF8; //조정품셈
    FMHPerDay: RawUTF8; //일투입공수
    FStartDatePlan: TDateTime;
    FEndDatePlan: TDateTime;
    FStartDateActual: TDateTime;
    FEndDateActual: TDateTime;
    FStartDatePredict: TDateTime;
    FEndDatePredict: TDateTime;
    FPrevJobCode,
    FAfterJobCode,
    FRelType: RawUTF8; //FS = FinishStart, SS = StartStart
    FBigo: RawUTF8;
//    F: TModTime;
  public
    property PrevJobCode: RawUTF8 read FPrevJobCode write FPrevJobCode;
    property AfterJobCode: RawUTF8 read FAfterJobCode write FAfterJobCode;
    property RelType: RawUTF8 read FRelType write FRelType;
  published
//    property Time: TModTime read fTime write fTime;
    property ProjNo: RawUTF8 read FProjNo write FProjNo;
    property ShipNo: RawUTF8 read FShipNo write FShipNo;
    property CylCount: RawUTF8 read FCylCount write FCylCount;
    property EngineType: RawUTF8 read FEngineType write FEngineType;
    property EngineCount: RawUTF8 read FEngineCount write FEngineCount;
    property DeliveryDate: TDateTime read FDeliveryDate write FDeliveryDate;
    property ActCode: RawUTF8 read FActCode write FActCode;
    property Description: RawUTF8 read FDescription write FDescription;
    property Duration: RawUTF8 read FDuration write FDuration;
    property ProcessNo: RawUTF8 read FProcessNo write FProcessNo;
    property FactoryName: RawUTF8 read FFactoryName write FFactoryName;
    property ProcessDept: RawUTF8 read FProcessDept write FProcessDept;
    property MachineNo: RawUTF8 read FMachineNo write FMachineNo;
    property StandardOfEstimate: RawUTF8 read FStandardOfEstimate write FStandardOfEstimate;
    property SOEAdjustFactor: RawUTF8 read FSOEAdjustFactor write FSOEAdjustFactor;
    property RealAdjustValue: RawUTF8 read FRealAdjustValue write FRealAdjustValue;
    property MHPerDay: RawUTF8 read FMHPerDay write FMHPerDay;
    property StartDatePlan: TDateTime read FStartDatePlan write FStartDatePlan;
    property EndDatePlan: TDateTime read FEndDatePlan write FEndDatePlan;
    property StartDateActual: TDateTime read FStartDateActual write FStartDateActual;
    property EndDateActual: TDateTime read FEndDateActual write FEndDateActual;
    property StartDatePredict: TDateTime read FStartDatePredict write FStartDatePredict;
    property EndDatePredict: TDateTime read FEndDatePredict write FEndDatePredict;
    property Bigo: RawUTF8 read FBigo write FBigo;
  end;

  TSQLHolidayRecord = class(TSQLRecord)
  private
    FHolidayDate, FUpdateDate: TDate;
    FDescription: RawUTF8;
    FHolidayGubun: THolidayGubun;
  published
    property HolidayDate: TDate read FHolidayDate write FHolidayDate;
    property Description: RawUTF8 read FDescription write FDescription;
    property HolidayGubun: THolidayGubun read FHolidayGubun write FHolidayGubun;
    property UpdateDate: TDate read FUpdateDate write FUpdateDate;
  end;

  TSQLKTPD212Record = class(TSQLRecord)
  private
    FPROJNO      :RawUTF8;    // index 10;
    FSUBPROJNO   :RawUTF8;    //(3 BYTE)                  NOT NULL,
    FPARTNO      :RawUTF8;    //(21 BYTE)                 NOT NULL,
    FJBCODE      :RawUTF8;    //(5 BYTE)                  NOT NULL,
    FDUR         :integer;    //NUMBER(3)                         DEFAULT 0,
    FSHOPDIV     :RawUTF8;    //(4 BYTE),
    FJBDEPT      :RawUTF8;    //(8 BYTE),
    FMCNO        :RawUTF8;    //(5 BYTE),
    FMANH        :integer;
    FFACTOR      :integer;    //(5,2),
    FCMANH       :integer;
    FDMANH       :integer;
    FBWPST       :integer;
    FBWPED       :integer;
    FFWPST       :integer;
    FFWPED       :integer;
    FBREVSDATE   :TDateTime;
    FBREVFDATE   :TDateTime;
    FSREVSDATE   :TDateTime;
    FSREVFDATE   :TDateTime;
    FFREVSDATE   :TDateTime;
    FFREVFDATE   :TDateTime;
    F_REVSDATE    :TDateTime;
    F_REVFDATE    :TDateTime;
    FZREVSDATE   :TDateTime;
    FZREVFDATE   :TDateTime;
    FYREVSDATE   :TDateTime;
    FYREVFDATE   :TDateTime;
    FMAIN        :RawUTF8;    //(1 BYTE),
    FMPARTNO     :RawUTF8;    //(21 BYTE),
    FMJBCODE     :RawUTF8;    //(5 BYTE),
    FJAJE        :RawUTF8;    //(1 BYTE),
    FFIX         :RawUTF8;    //(1 BYTE),
    F_LAG         :RawUTF8;    //NCHAR(1),
    FSTEP        :integer;    //                            DEFAULT 0,
    FMOVE        :RawUTF8;    //(1 BYTE),
    FREVSDATE_T  :TDateTime;
    FREVFDATE_T  :TDateTime;
    F_FLAG        :RawUTF8;    //(1 BYTE),
    FSTEP_T      :integer;    //                            DEFAULT 0,
    FINDATE      :TDateTime;
  published
    property PROJNO      :RawUTF8   read FPROJNO write FPROJNO;
    property SUBPROJNO   :RawUTF8   read FSUBPROJNO write FSUBPROJNO;
    property PARTNO      :RawUTF8   read FPARTNO write FPARTNO;
    property JBCODE      :RawUTF8   read FJBCODE write FJBCODE;
    property DUR         :integer   read FDUR write FDUR;
    property SHOPDIV     :RawUTF8   read FSHOPDIV write FSHOPDIV;
    property JBDEPT      :RawUTF8   read FJBDEPT write FJBDEPT;
    property MCNO        :RawUTF8   read FMCNO write FMCNO;
    property MANH        :integer   read FMANH write FMANH;
    property FACTOR      :integer   read FFACTOR write FFACTOR;
    property CMANH       :integer   read FCMANH write FCMANH;
    property DMANH       :integer   read FDMANH write FDMANH;
    property BWPST       :integer   read FBWPST write FBWPST;
    property BWPED       :integer   read FBWPED write FBWPED;
    property FWPST       :integer   read FFWPST write FFWPST;
    property FWPED       :integer   read FFWPED write FFWPED;
    property BREVSDATE   :TDateTime read FBREVSDATE write FBREVSDATE;
    property BREVFDATE   :TDateTime read FBREVFDATE write FBREVFDATE;
    property SREVSDATE   :TDateTime read FSREVSDATE write FSREVSDATE;
    property SREVFDATE   :TDateTime read FSREVFDATE write FSREVFDATE;
    property FREVSDATE   :TDateTime read FFREVSDATE write FFREVSDATE;
    property FREVFDATE   :TDateTime read FFREVFDATE write FFREVFDATE;
    property REVSDATE    :TDateTime read F_REVSDATE write F_REVSDATE;
    property REVFDATE    :TDateTime read F_REVFDATE write F_REVFDATE;
    property ZREVSDATE   :TDateTime read FZREVSDATE write FZREVSDATE;
    property ZREVFDATE   :TDateTime read FZREVFDATE write FZREVFDATE;
    property YREVSDATE   :TDateTime read FYREVSDATE write FYREVSDATE;
    property YREVFDATE   :TDateTime read FYREVFDATE write FYREVFDATE;
    property MAIN        :RawUTF8   read FMAIN write FMAIN;
    property MPARTNO     :RawUTF8   read FMPARTNO write FMPARTNO;
    property MJBCODE     :RawUTF8   read FMJBCODE write FMJBCODE;
    property JAJE        :RawUTF8   read FJAJE write FJAJE;
    property FIX         :RawUTF8   read FFIX write FFIX;
    property LAG         :RawUTF8   read F_LAG write F_LAG;
    property STEP        :integer   read FSTEP write FSTEP;
    property MOVE        :RawUTF8   read FMOVE write FMOVE;
    property REVSDATE_T  :TDateTime read FREVSDATE_T write FREVSDATE_T;
    property REVFDATE_T  :TDateTime read FREVFDATE_T write FREVFDATE_T;
    property FLAG        :RawUTF8   read F_FLAG write F_FLAG;
    property STEP_T      :integer   read FSTEP_T write FSTEP_T;
    property INDATE      :TDateTime read FINDATE write FINDATE;
  end;

function CreateScheduleModel: TSQLModel;
function CreateBaseInfoModel: TSQLModel;
function CreateHolidayModel: TSQLModel;
function GetBaseInfoFrom(ASource: TSQLHimsenJobRelation): R_BaseInfo;

implementation

function CreateScheduleModel: TSQLModel;
begin
//  result := TSQLModel.Create([TSQLScheduleSampleRecord]);
  result := TSQLModel.Create([TSQLScheduleSampleRecord]);
end;

function CreateBaseInfoModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHimsenJobRelation]);
end;

function CreateHolidayModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHolidayRecord]);
end;

function GetBaseInfoFrom(ASource: TSQLHimsenJobRelation): R_BaseInfo;
begin
  Result.FEngineType := ASource.EngineType;
  Result.FPPartNo := ASource.PPartNo;
  Result.FPJobCode := ASource.PJobCode;
  Result.FAPartNo := ASource.APartNo;
  Result.FAJobCode := ASource.AJobCode;
  Result.FRelType := ASource.RelType;
  Result.FBufferDay := ASource.BufferDay;
  Result.FBigo := ASource.FBigo;
end;

end.
||||||| .r0
=======
/// it's a good practice to put all data definition into a stand-alone unit
// - this unit will be shared between client and server
unit ScheduleSampleDataModel;

interface

uses
  SynCommons,
  mORMot, HolidayCollect;

const
  PROJ_SCH_DB_NAME = 'Schedule_Himsen.db3';
  PROJ_BASE_INFO_DB_NAME = 'Base_Info_Himsen.db3';
  HOLIDAY_INFO_DB_NAME = 'HoliDay_Info_Himsen.db3';

type
  //계획일정, 수정(예측)일정,실적일정
  TAdaptSchedule = (asPlan, asPredict, asActual);

  R_BaseInfo = packed record
    FEngineType: RawUTF8;
    FPPartNo: RawUTF8; //선행공정
    FPJobCode: RawUTF8;//선행작업
    FAPartNo: RawUTF8; //후행공정
    FAJobCode: RawUTF8;//후행작업
    FRelType: RawUTF8; //관계유형 : FS = FinishStart, SS = StartStart
    FBufferDay: RawUTF8;//버퍼일수
    FBigo: RawUTF8;
  end;

  R_BaseInfos = array of R_BaseInfo;

  TSQLHimsenJobRelation = class(TSQLRecord)
  private
    FEngineType: RawUTF8;
    FPPartNo: RawUTF8; //선행공정
    FPJobCode: RawUTF8;//선행작업
    FAPartNo: RawUTF8; //후행공정
    FAJobCode: RawUTF8;//후행작업
    FRelType: RawUTF8; //관계유형 : FS = FinishStart, SS = StartStart
    FBufferDay: RawUTF8;//버퍼일수
    FBigo: RawUTF8;
  published
    property EngineType: RawUTF8 read FEngineType write FEngineType;
    property PPartNo: RawUTF8 read FPPartNo write FPPartNo;
    property PJobCode: RawUTF8 read FPJobCode write FPJobCode;
    property APartNo: RawUTF8 read FAPartNo write FAPartNo;
    property AJobCode: RawUTF8 read FAJobCode write FAJobCode;
    property RelType: RawUTF8 read FRelType write FRelType;
    property BufferDay: RawUTF8 read FBufferDay write FBufferDay;
    property Bigo: RawUTF8 read FBigo write FBigo;
  end;

  TSQLScheduleSampleRecord = class(TSQLRecord)
  private
    FProjNo: RawUTF8;
    FShipNo: RawUTF8;
    FCylCount: RawUTF8;
    FEngineType: RawUTF8;
    FEngineCount: RawUTF8;
    FDeliveryDate: TDateTime;
    FActCode: RawUTF8;
    FDescription: RawUTF8;
    FDuration: RawUTF8;
    FProcessNo: RawUTF8; //공정번호
    FFactoryName: RawUTF8;
    FProcessDept: RawUTF8;
    FMachineNo: RawUTF8;
    FStandardOfEstimate: RawUTF8; //표준품셈
    FSOEAdjustFactor: RawUTF8; //품셈 조정 Factor
    FRealAdjustValue: RawUTF8; //조정품셈
    FMHPerDay: RawUTF8; //일투입공수
    FStartDatePlan: TDateTime;
    FEndDatePlan: TDateTime;
    FStartDateActual: TDateTime;
    FEndDateActual: TDateTime;
    FStartDatePredict: TDateTime;
    FEndDatePredict: TDateTime;
    FPrevJobCode,
    FAfterJobCode,
    FRelType: RawUTF8; //FS = FinishStart, SS = StartStart
//    F: TModTime;
  public
    property PrevJobCode: RawUTF8 read FPrevJobCode write FPrevJobCode;
    property AfterJobCode: RawUTF8 read FAfterJobCode write FAfterJobCode;
    property RelType: RawUTF8 read FRelType write FRelType;
  published
//    property Time: TModTime read fTime write fTime;
    property ProjNo: RawUTF8 read FProjNo write FProjNo;
    property ShipNo: RawUTF8 read FShipNo write FShipNo;
    property CylCount: RawUTF8 read FCylCount write FCylCount;
    property EngineType: RawUTF8 read FEngineType write FEngineType;
    property EngineCount: RawUTF8 read FEngineCount write FEngineCount;
    property DeliveryDate: TDateTime read FDeliveryDate write FDeliveryDate;
    property ActCode: RawUTF8 read FActCode write FActCode;
    property Description: RawUTF8 read FDescription write FDescription;
    property Duration: RawUTF8 read FDuration write FDuration;
    property ProcessNo: RawUTF8 read FProcessNo write FProcessNo;
    property FactoryName: RawUTF8 read FFactoryName write FFactoryName;
    property ProcessDept: RawUTF8 read FProcessDept write FProcessDept;
    property MachineNo: RawUTF8 read FMachineNo write FMachineNo;
    property StandardOfEstimate: RawUTF8 read FStandardOfEstimate write FStandardOfEstimate;
    property SOEAdjustFactor: RawUTF8 read FSOEAdjustFactor write FSOEAdjustFactor;
    property RealAdjustValue: RawUTF8 read FRealAdjustValue write FRealAdjustValue;
    property MHPerDay: RawUTF8 read FMHPerDay write FMHPerDay;
    property StartDatePlan: TDateTime read FStartDatePlan write FStartDatePlan;
    property EndDatePlan: TDateTime read FEndDatePlan write FEndDatePlan;
    property StartDateActual: TDateTime read FStartDateActual write FStartDateActual;
    property EndDateActual: TDateTime read FEndDateActual write FEndDateActual;
    property StartDatePredict: TDateTime read FStartDatePredict write FStartDatePredict;
    property EndDatePredict: TDateTime read FEndDatePredict write FEndDatePredict;
  end;

  TSQLHolidayRecord = class(TSQLRecord)
  private
    FHolidayDate, FUpdateDate: TDate;
    FDescription: RawUTF8;
    FHolidayGubun: THolidayGubun;
  published
    property HolidayDate: TDate read FHolidayDate write FHolidayDate;
    property Description: RawUTF8 read FDescription write FDescription;
    property HolidayGubun: THolidayGubun read FHolidayGubun write FHolidayGubun;
    property UpdateDate: TDate read FUpdateDate write FUpdateDate;
  end;

function CreateScheduleModel: TSQLModel;
function CreateBaseInfoModel: TSQLModel;
function CreateHolidayModel: TSQLModel;
function GetBaseInfoFrom(ASource: TSQLHimsenJobRelation): R_BaseInfo;

implementation

function CreateScheduleModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLScheduleSampleRecord]);
end;

function CreateBaseInfoModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHimsenJobRelation]);
end;

function CreateHolidayModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLHolidayRecord]);
end;

function GetBaseInfoFrom(ASource: TSQLHimsenJobRelation): R_BaseInfo;
begin
  Result.FEngineType := ASource.EngineType;
  Result.FPPartNo := ASource.PPartNo;
  Result.FPJobCode := ASource.PJobCode;
  Result.FAPartNo := ASource.APartNo;
  Result.FAJobCode := ASource.AJobCode;
  Result.FRelType := ASource.RelType;
  Result.FBufferDay := ASource.BufferDay;
  Result.FBigo := ASource.FBigo;
end;

end.
>>>>>>> .r2045
