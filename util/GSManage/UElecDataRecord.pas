unit UElecDataRecord;

interface

uses
  Classes,
  SynCommons,
  mORMot,
  CommonData,
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  UnitTodoCollect, FSMClass_Dic, FSMState, Vcl.Dialogs, UnitGSFileRecord;

type
  TSQLEmailMsgs = class;
//  TSQLGSFiles = class;

  PSQLInvoiceFileRec = ^TSQLInvoiceFileRec;
  TSQLInvoiceFileRec = Packed Record
    fFilename: RawUTF8;
    fGSInvoiceItemType: TGSInvoiceItemType;
    fData: RawByteString;
  end;

  TSQLInvoiceFileRecs = array of TSQLInvoiceFileRec;

  PSQLSubConRec = ^TSQLSubConRec;
  TSQLSubConRec = Packed Record
    fFilename: RawUTF8;
    fGSDocType: TGSDocType;
    fData: RawByteString;
  end;

  TSQLSubConRecs = array of TSQLSubConRec;

  TSQLInvoiceFile = class(TSQLRecord)
  private
    fTaskID: TID;
    fItemID: TID;
    fItemIndex: integer; //Item내 DynArray Index를 가리킴
    fFiles: TSQLInvoiceFileRecs;
  public
    FIsUpdate: Boolean;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property ItemID: TID read fItemID write fItemID;
    property ItemIndex: integer read fItemIndex write fItemIndex;
    property Files: TSQLInvoiceFileRecs read fFiles write fFiles;
  end;

  TSQLPerson = class(TSQLRecord)
  private
    fTaskID: TID;
    fFirstname, fSurname: RawUTF8;

    FIsUpdate: Boolean;
  public
    //True : DB Update, False: DB Add
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property FirstName: RawUTF8 read fFirstname write fFirstname;
    property Surname: RawUTF8 read fSurname write fSurname;
  end;

  TSQLCompany = class(TSQLPerson)
  private
    fEMail, fCompanyName: RawUTF8;
    fMobilePhone, fOfficePhone: RawUTF8;
    fCompanyAddress, fPosition: RawUTF8;
    fCompanyCode, fManagerName,
    fNation: RawUTF8;
    fCompanyType: TCompanyType;
  published
    property CompanyCode: RawUTF8 read fCompanyCode write fCompanyCode;
    property EMail: RawUTF8 read fEMail write fEMail;
    property CompanyName: RawUTF8 read fCompanyName write fCompanyName;
    property MobilePhone: RawUTF8 read fMobilePhone write fMobilePhone;
    property OfficePhone: RawUTF8 read fOfficePhone write fOfficePhone;
    property CompanyAddress: RawUTF8 read fCompanyAddress write fCompanyAddress;
    property Position: RawUTF8 read fPosition write fPosition;
    property ManagerName: RawUTF8 read fManagerName write fManagerName;
    property Nation: RawUTF8 read fNation write fNation;
    property CompanyType: TCompanyType read fCompanyType write fCompanyType;
  end;

  TSQLCustomer = class(TSQLCompany)
  private
    fAgentInfo: RawUTF8;
  published
    property AgentInfo: RawUTF8 read fAgentInfo write fAgentInfo;
  end;

  TSQLMasterCustomer = class(TSQLCompany)
  private
    fAgentInfo: RawUTF8;
  published
    property AgentInfo: RawUTF8 read fAgentInfo write fAgentInfo;
  end;

  TSQLSubCon = class(TSQLCompany)
  private
    fServicePO: RawUTF8;
  published
    property ServicePO: RawUTF8 read fServicePO write fServicePO;
  end;

  TSQLMaterial = class(TSQLRecord)
  private
    fTaskID: TID;
    fMaterialCode: RawUTF8;
    fDeliveryAddress, fUnitPrice: RawUTF8;
    fLeadTime: integer;

    FIsUpdate: Boolean;
  public
    //True : DB Update, False: DB Add
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property MaterialCodeList: RawUTF8 read fMaterialCode write fMaterialCode;
    property UnitPrice: RawUTF8 read fUnitPrice write fUnitPrice;

    property LeadTime: integer read fLeadTime write fLeadTime;
  end;

  TSQLMaterial4Project = class(TSQLMaterial)
  private
    fPORNo: RawUTF8;
    fSupplyCount: integer;
    FPORIssueDate: TTimeLog;
    fDeliveryAddress, fAirWayBill: RawUTF8;
    fDeliveryCharge, fDeliveryCompany: RawUTF8;

    FIsUpdate: Boolean;
  public
    //True : DB Update, False: DB Add
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property PORNo: RawUTF8 read fPORNo write fPORNo;
    property SupplyCount: integer read fSupplyCount write fSupplyCount;
    property PORIssueDate: TTimeLog read FPORIssueDate write FPORIssueDate;
    property DeliveryAddress: RawUTF8 read fDeliveryAddress write fDeliveryAddress;
    property AirWayBill: RawUTF8 read fAirWayBill write fAirWayBill;
    property DeliveryCharge: RawUTF8 read fDeliveryCharge write fDeliveryCharge;
    property DeliveryCompany: RawUTF8 read fDeliveryCompany write fDeliveryCompany;
  end;

  TSQLVesselInfo = class(TSQLRecord)
  private
    fTaskID: TID;
    fShipName, fShipType, fHullno,
    fIMONo, fMMSINo,
    fOwner, fShipManager,
    fShipOperator, fShipBuilder,
    fRegisteredOwner, fTechnicalManager: RawUTF8;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property ShipName: RawUTF8 read fShipName write fShipName;
    property ShipType: RawUTF8 read fShipType write fShipType;
    property Hullno: RawUTF8 read fHullno write fHullno;
    property IMONo: RawUTF8 read fIMONo write fIMONo;
    property MMSINo: RawUTF8 read fMMSINo write fMMSINo;
    property Owner: RawUTF8 read fOwner write fOwner;
    property ShipManager: RawUTF8 read fShipManager write fShipManager;
    property ShipOperator: RawUTF8 read fShipOperator write fShipOperator;
    property ShipBuilder: RawUTF8 read fShipBuilder write fShipBuilder;
    property RegisteredOwner: RawUTF8 read fRegisteredOwner write fRegisteredOwner;
    property TechnicalManager: RawUTF8 read fTechnicalManager write fTechnicalManager;
  end;

  TSQLOLMsg = class(TSQLRecord)
  private
    fEntryID, fStoreID, fParentID: RawUTF8;
  published
    //ParentID = EntryID + StoreID
    property ParentID: RawUTF8 read fParentID write fParentID;
    property EntryID: RawUTF8 read fEntryID write fEntryID;
    property StoreID: RawUTF8 read fStoreID write fStoreID;
  end;

  TSQLEmailMsg = class(TSQLOLMsg)
  private
    fSender, fReceiver, fSubject,
    FCarbonCopy, FBlindCC,
    FMailDesc: RawUTF8;
    FRecvDate: TTimeLog;
    FContainData: TContainData4Mail;
    //해당 메일이 누구한테 보내는 건지 구분하기 위함
    FProcDirection: TProcessDirection;
    FSavedOLFolderPath: RawUTF8;
  published
    property Subject: RawUTF8 read fSubject write fSubject;
    property Sender: RawUTF8 read fSender write fSender;
    property Receiver: RawUTF8 read fReceiver write fReceiver;
    property CarbonCopy: RawUTF8 read FCarbonCopy write FCarbonCopy;
    property BlindCC: RawUTF8 read FBlindCC write FBlindCC;
    property MailDesc: RawUTF8 read FMailDesc write FMailDesc;
    property RecvDate: TTimeLog read FRecvDate write FRecvDate;
    property ContainData: TContainData4Mail read FContainData write FContainData;
    property ProcDirection: TProcessDirection read FProcDirection write FProcDirection;
    property SavedOLFolderPath: RawUTF8 read FSavedOLFolderPath write FSavedOLFolderPath;
  end;

  TSQLGSTaskInfo = class(TSQLRecord)
  private
    FUniqueTaskID: RawUTF8;  //GUID: InvoiceTask와 정보 교환시 필요
    FHullNo,
    FShipName,
    FProductType,
    FCustomerCode,
    FPO_No,
    FQTN_No,
    FOrder_No,
    FCustomerAddress,
    FWorkSummary,
    FNationPort,
    FEtcContent,
    FShipOwner: RawUTF8;
    fSEList: RawUTF8;
    FChargeInPersonId: RawUTF8;//담당자 사번(또는 Emial)
    fSECount: integer;
    //화폐(0:원,1:USD,2:EUR)
    FCurrencyKind: integer;

    FSalesProcessType: TSalesProcessType;
//    FCompanyType: TCompanyType;
    FCurrentWorkStatus, FNextWork: integer;
    FEngineerAgency: TEngineerAgency;//엔지니어 소속사(HGS, HElectric, SubCon)
    FSubConRecs: TSQLSubConRecs; //협력사 정보 Array(한 작업에 여러 협력사가 가능함)
    FSubConPrice, //협력사 견적 금액
    FShippingNo,//출하지시번호
    FSalesPrice,//매출금액
    FExchangeRate: RawUTF8; //환율
    FBaseProjectNo: RawUTF8; //본공사번호

    FDeliveryCondition,//납품조건
    FEstimateType, //견적유형
    FTermsOfPayment: integer; //지불조건

    FInqRecvDate,
    FInvoiceIssueDate,
    FQTNIssueDate,
    FQTNInputDate,
    FOrderInputDate,
    FAttendScheduled,
    FWorkBeginDate, FWorkEndDate,
    FCurWorkFinishDate,
    FSRRecvDate, FSubConInvoiceIssueDate,
    FSalesReqDate, FShippingDate: TTimeLog; //출하일자

    FIsUpdate: Boolean;
  public
    //True : DB Update, False: DB Add
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property HullNo: RawUTF8 read FHullNo write FHullNo;
    property ShipName: RawUTF8 read FShipName write FShipName;
    property ProductType: RawUTF8 read FProductType write FProductType;
    property PO_No: RawUTF8 read FPO_No write FPO_No;
    property QTN_No: RawUTF8 read FQTN_No write FQTN_No;
    property Order_No: RawUTF8 read FOrder_No write FOrder_No;
    property WorkSummary: RawUTF8 read FWorkSummary write FWorkSummary;
    property NationPort: RawUTF8 read FNationPort write FNationPort;
    property EtcContent: RawUTF8 read FEtcContent write FEtcContent;
    property ShipOwner: RawUTF8 read FShipOwner write FShipOwner;
    property ChargeInPersonId: RawUTF8 read FChargeInPersonId write FChargeInPersonId;

    property SalesProcessType: TSalesProcessType read FSalesProcessType write FSalesProcessType;
//    property CompanyType: TCompanyType read FCompanyType write FCompanyType;
    property CurrentWorkStatus: integer read FCurrentWorkStatus write FCurrentWorkStatus;
    property NextWork: integer read FNextWork write FNextWork;
    property SECount: integer read fSECount write fSECount;
    property SEList: RawUTF8 read fSEList write fSEList;
    property SubConRecs: TSQLSubConRecs read FSubConRecs write FSubConRecs;
    property EngineerAgency: TEngineerAgency read FEngineerAgency write FEngineerAgency;
    property SubConPrice: RawUTF8 read FSubConPrice write FSubConPrice;
    property SalesPrice: RawUTF8 read FSalesPrice write FSalesPrice;
    property ExchangeRate: RawUTF8 read FExchangeRate write FExchangeRate;
    property BaseProjectNo: RawUTF8 read FBaseProjectNo write FBaseProjectNo;
    property ShippingNo: RawUTF8 read FShippingNo write FShippingNo;
    property CurrencyKind: integer read FCurrencyKind write FCurrencyKind;
    property DeliveryCondition: integer read FDeliveryCondition write FDeliveryCondition;
    property EstimateType: integer read FEstimateType write FEstimateType;
    property TermsOfPayment: integer read FTermsOfPayment write FTermsOfPayment;

    property InqRecvDate: TTimeLog read FInqRecvDate write FInqRecvDate;
    property InvoiceIssueDate: TTimeLog read FInvoiceIssueDate write FInvoiceIssueDate;
    property QTNIssueDate: TTimeLog read FQTNIssueDate write FQTNIssueDate;
    property QTNInputDate: TTimeLog read FQTNInputDate write FQTNInputDate;
    property OrderInputDate: TTimeLog read FOrderInputDate write FOrderInputDate;
    property AttendScheduled: TTimeLog read FAttendScheduled write FAttendScheduled;
    property WorkBeginDate: TTimeLog read FWorkBeginDate write FWorkBeginDate;
    property WorkEndDate: TTimeLog read FWorkEndDate write FWorkEndDate;
    property CurWorkFinishDate: TTimeLog read FCurWorkFinishDate write FCurWorkFinishDate;
    property SRRecvDate: TTimeLog read FSRRecvDate write FSRRecvDate;
    property SubConInvoiceIssueDate: TTimeLog read FSubConInvoiceIssueDate write FSubConInvoiceIssueDate;
    property SalesReqDate: TTimeLog read FSalesReqDate write FSalesReqDate;
    property ShippingDate: TTimeLog read FShippingDate write FShippingDate;
    property UniqueTaskID: RawUTF8 read FUniqueTaskID write FUniqueTaskID;
  end;

  TSQLGSTask = class(TSQLGSTaskInfo)
  private
    fCustomerID, fSubConId, fToDoId: TID;//고객사 Table의 ID
    fEmailMsg: TSQLEmailMsgs;
  published
    property CustomerID: TID read fCustomerID write fCustomerID;
    property SubConId: TID read fSubConId write fSubConId;
    property ToDoId: TID read fToDoId write fToDoId;
    property EmailMsg: TSQLEmailMsgs read fEmailMsg;
  end;

  TSQLEmailMsgs = class(TSQLRecordMany)
  private
    fSource: TSQLGSTask;
    fDest: TSQLEmailMsg;
  published
    property Source: TSQLGSTask read fSource;
    property Dest: TSQLEmailMsg read fDest;
  end;

  TSQLToDoItem = class(TSQLRecord)
  private
    fTaskID: TID;

    FToDo_Code,
    FAppointmentEntryId,
    FAppointmentStoreId,
    FEmailEntryId,
    FEmailStoreId,
    FTask_Code,
    FPlan_Code,
    FSubject,
    FNotes,
    FToDoReourece,
    FModId,
    FCategory,
    FProject,
    FResource: string;

    FCreationDate,
    FDueDate,
    FCompletionDate,
    FModDate,
    FAlarmTime1: TTimeLog;

    FImageIndex,
    FTag,
    FCompletion,
    FStatus,
    FPriority,
    FAlarmType,
    FAlarmFlag,
    FAlarm2Msg,
    FAlarm2Note,
    FAlarmTime2,
    FAlarm2Email: integer;

    FTotalTime: double;

    FComplete,
    FIsUpdate: Boolean;
  public
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property AppointmentEntryId: string read FAppointmentEntryId write FAppointmentEntryId;
    property AppointmentStoreId: string read FAppointmentStoreId write FAppointmentStoreId;
    property EmailEntryId: string read FEmailEntryId write FEmailEntryId;
    property EmailStoreId: string read FEmailStoreId write FEmailStoreId;
    property ToDo_Code: string read FToDo_Code write FToDo_Code;
    property Task_Code: string read FTask_Code write FTask_Code;
    property Plan_Code: string read FPlan_Code write FPlan_Code;
    property Subject: string read FSubject write FSubject;
    property Notes: string read FNotes write FNotes;
    property ToDoReourece: string read FToDoReourece write FToDoReourece;
    property ModId: string read FModId write FModId;
    property Category: string read FCategory write FCategory;
    property Project: string read FProject write FProject;
    property Resource: string read FResource write FResource;

    property CreationDate: TTimeLog read FCreationDate write FCreationDate;
    property DueDate: TTimeLog read FDueDate write FDueDate;
    property CompletionDate: TTimeLog read FCompletionDate write FCompletionDate;
    property ModDate: TTimeLog read FModDate write FModDate;
    property AlarmTime1: TTimeLog read FAlarmTime1 write FAlarmTime1;
    property AlarmTime2: integer read FAlarmTime2 write FAlarmTime2;

    property ImageIndex: Integer read FImageIndex write FImageIndex;
    property Tag: Integer read FTag write FTag;
    property Completion: integer read FCompletion write FCompletion;
    property Complete: Boolean read FComplete write FComplete;
    property Status: integer read FStatus write FStatus;
    property Priority: integer read FPriority write FPriority;
    property TotalTime: double read FTotalTime write FTotalTime;
    property AlarmType: integer read FAlarmType write FAlarmType;
    property AlarmFlag: integer read FAlarmFlag write FAlarmFlag;
    property Alarm2Msg: integer read FAlarm2Msg write FAlarm2Msg;
    property Alarm2Note: integer read FAlarm2Note write FAlarm2Note;
    property Alarm2Email: integer read FAlarm2Email write FAlarm2Email;
  end;

  TSQLMAPS_QTN = class(TSQLRecord)
  private
    fTaskID: TID;
    FIsUpdate: Boolean;
  public
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property TaskID: TID read fTaskID write fTaskID;
  end;

  //협력사에서 청구서 만들떄 사용
  TSQLInvoiceTask = class(TSQLRecord)
  private
    FUniqueTaskID: RawUTF8;  //GUID: InvoiceTask와 정보 교환시 필요
    FIsUpdate: Boolean;
    FHullNo,
    FShipName,
    FWorkSummary,
    FNationPort,
    FEtcContent,
    FShipOwner: RawUTF8;
    fSEList: RawUTF8;
    fAgentInfo: RawUTF8;
    FOrder_No, //공사번호
    FChargeInPersonId: RawUTF8;//담당자 사번
    FInvoicePrice,//청구금액
    FExchangeRate: RawUTF8; //환율

    fCustCompanyCode,
    fCustEMail,
    fCustCompanyName,
    fCustMobilePhone,
    fCustOfficePhone,
    fCustCompanyAddress,
    fCustPosition,
    fCustManagerName,
    fCustNation,
    fCustAgentInfo,

    fSubConCompanyCode,
    fSubConEMail,
    fSubConCompanyName,
    fSubConMobilePhone,
    fSubConOfficePhone,
    fSubConCompanyAddress,
    fSubConPosition,
    fSubConManagerName,
    fSubConNation  : RawUTF8;

    //화폐(0:원,1:USD,2:EUR)
    FCurrencyKind: integer;

    FAttendScheduled,
    FInqRecvDate,
    FInvoiceIssueDate,
    FWorkBeginDate, FWorkEndDate: TTimeLog;
  public
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property UniqueTaskID: RawUTF8 read FUniqueTaskID write FUniqueTaskID;
    property HullNo: RawUTF8 read FHullNo write FHullNo;
    property ShipName: RawUTF8 read FShipName write FShipName;
    property WorkSummary: RawUTF8 read FWorkSummary write FWorkSummary;
    property NationPort: RawUTF8 read FNationPort write FNationPort;
    property EtcContent: RawUTF8 read FEtcContent write FEtcContent;
    property ShipOwner: RawUTF8 read FShipOwner write FShipOwner;
    property SEList: RawUTF8 read fSEList write fSEList;
    property Order_No: RawUTF8 read FOrder_No write FOrder_No;
    property ChargeInPersonId: RawUTF8 read FChargeInPersonId write FChargeInPersonId;
    property InvoicePrice: RawUTF8 read FInvoicePrice write FInvoicePrice;
    property ExchangeRate: RawUTF8 read FExchangeRate write FExchangeRate;

    property CustCompanyCode: RawUTF8 read fCustCompanyCode write fCustCompanyCode;
    property CustEMail: RawUTF8 read fCustEMail write fCustEMail;
    property CustCompanyName: RawUTF8 read fCustCompanyName write fCustCompanyName;
    property CustMobilePhone: RawUTF8 read fCustMobilePhone write fCustMobilePhone;
    property CustOfficePhone: RawUTF8 read fCustOfficePhone write fCustOfficePhone;
    property CustCompanyAddress: RawUTF8 read fCustCompanyAddress write fCustCompanyAddress;
    property CustPosition: RawUTF8 read fCustPosition write fCustPosition;
    property CustManagerName: RawUTF8 read fCustManagerName write fCustManagerName;
    property CustNation: RawUTF8 read fCustNation write fCustNation;
    property CustAgentInfo: RawUTF8 read fCustAgentInfo write fCustAgentInfo;

    property SubConCompanyCode: RawUTF8 read fSubConCompanyCode write fSubConCompanyCode;
    property SubConEMail: RawUTF8 read fSubConEMail write fSubConEMail;
    property SubConCompanyName: RawUTF8 read fSubConCompanyName write fSubConCompanyName;
    property SubConMobilePhone: RawUTF8 read fSubConMobilePhone write fSubConMobilePhone;
    property SubConOfficePhone: RawUTF8 read fSubConOfficePhone write fSubConOfficePhone;
    property SubConCompanyAddress: RawUTF8 read fSubConCompanyAddress write fSubConCompanyAddress;
    property SubConPosition: RawUTF8 read fSubConPosition write fSubConPosition;
    property SubConManagerName: RawUTF8 read fSubConManagerName write fSubConManagerName;
    property SubConNation: RawUTF8 read fSubConNation write fSubConNation;

    property CurrencyKind: integer read FCurrencyKind write FCurrencyKind;

    property AttendScheduled: TTimeLog read FAttendScheduled write FAttendScheduled;
    property InqRecvDate: TTimeLog read FInqRecvDate write FInqRecvDate;
    property InvoiceIssueDate: TTimeLog read FInvoiceIssueDate write FInvoiceIssueDate;
    property WorkBeginDate: TTimeLog read FWorkBeginDate write FWorkBeginDate;
    property WorkEndDate: TTimeLog read FWorkEndDate write FWorkEndDate;
  end;

  TSQLInvoiceItem = class(TSQLRecord)
  private
    FUniqueItemID: RawUTF8;  //GUID: InvoiceTask와 정보 교환시 필요
    fTaskID: TID;
    fItemID: TID; //Variant로 저장 후 로딩시 ItemID가 필요함
    FIsUpdate: Boolean;
    fItemDesc,
    fQty,
    ffUnit,
    fUnitPrice,
    fTotalPrice: RawUTF8;
    fGSInvoiceItemType: TGSInvoiceItemType;
  public
    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
  published
    property UniqueItemID: RawUTF8 read FUniqueItemID write FUniqueItemID;
    property TaskID: TID read fTaskID write fTaskID;
    property ItemID: TID read fItemId write fItemId;
    property ItemDesc: RawUTF8 read fItemDesc write fItemDesc;
    property Qty: RawUTF8 read fQty write fQty;
    property fUnit: RawUTF8 read ffUnit write ffUnit;
    property UnitPrice: RawUTF8 read fUnitPrice write fUnitPrice;
    property TotalPrice: RawUTF8 read fTotalPrice write fTotalPrice;
    property InvoiceItemType: TGSInvoiceItemType read fGSInvoiceItemType write fGSInvoiceItemType;
  end;

//  TSQLGSFiles = class(TSQLRecordMany)
//  private
//    fSource: TSQLGSTask;
//    fDest: TSQLGSFile;
//  published
//    property Source: TSQLGSTask read fSource;
//    property Dest: TSQLGSFile read fDest;
//  end;

  TIDList = class
    fTaskId,
    fEmailId : TID;
  published
    property TaskId: TID read fTaskId write fTaskId;
    property EmailId: TID read fEmailId write fEmailId;
  end;

  TIDList4Invoice = class
    fTaskId  : TID;
    fItemId  : TID;
    fItemAction: integer;  //1: Add, 2: Delete
    fUniqueItemID: RawUTF8;
    fItemType : TGSInvoiceItemType;
    fInvoiceFile: TSQLInvoiceFile;
  published
    property TaskId: TID read fTaskId write fTaskId;
    property ItemId: TID read fItemId write fItemId;
    property ItemAction: integer read fItemAction write fItemAction;
    property UniqueItemID: RawUTF8 read fUniqueItemID write fUniqueItemID;
    property ItemType: TGSInvoiceItemType read fItemType write fItemType;
    property InvoiceFile: TSQLInvoiceFile read fInvoiceFile write fInvoiceFile;
  end;

function CreateProjectModel: TSQLModel;
function CreateMasterModel: TSQLModel;
function CreateInvoiceFilesModel: TSQLModel;
function CreateInvoiceTaskModel: TSQLModel;
function CreateInvoiceItemModel: TSQLModel;
procedure InitClient();
procedure InitFSM;
procedure Add2FSM(ASPType:TSalesProcessType=sptNone;
  ACompanyType: TCompanyType=ctNull);

function CreateOrGetLoadTask(const ATaskID: integer): TSQLGSTask;
function GetLoadTask(const ATaskID: integer): TSQLGSTask;

function GetTaskFromHullNoNPONo(AHullNo, APONo: string): TSQLGSTask;
function GetFilesFromTask(ATask: TSQLGSTask): TSQLGSFile;
function GetCustomerFromTask(ATask: TSQLGSTask): TSQLCustomer;
function GetSubConFromTask(ATask: TSQLGSTask): TSQLSubCon;
function GetMaterial4ProjFromTask(ATask: TSQLGSTask): TSQLMaterial4Project;
function GetMasterCustomerFromCompanyCodeNName(ACompanyCode, ACompanyName: string;
  ACompanyType: TCompanyType = ctNull): TSQLMasterCustomer;
function GetToDoItemFromTask(ATask: TSQLGSTask): TSQLToDoItem;

procedure DeleteTask(ATaskID: TID);
procedure DeleteMailsFromTask(ATask: TSQLGSTask);
procedure DeleteFilesFromTask(ATask: TSQLGSTask);
procedure DeleteCustomerFromTask(ATask: TSQLGSTask);
procedure DeleteSubConFromTask(ATask: TSQLGSTask);
procedure DeleteMaterial4ProjFromTask(ATask: TSQLGSTask);
procedure DeleteToDoListFromTask(ATask: TSQLGSTask);

function GetCompanyCode(ATask: TSQLGSTask): string;
function GetQTNContent(ATask: TSQLGSTask): string;

procedure AddOrUpdateTask(ATask: TSQLGSTask);
procedure AddOrUpdateCustomer(ACustomer: TSQLCustomer);
procedure AddOrUpdateSubCon(ASubCon: TSQLSubCon);
procedure AddOrUpdateMaterial4Project(AMaterial4Project: TSQLMaterial4Project);

procedure InsertOrUpdateToDoList2DB(ApjhTodoItem: TpjhTodoItem; AIdAdd: Boolean);
procedure DeleteToDoListFromDB(ApjhTodoItem: TpjhTodoItem);
procedure LoadToDoCollectFromTask(ATask: TSQLGSTask; var AToDoCollect: TpjhToDoItemCollection);

procedure AssignpjhTodoItemToSQLToDoItem(ApjhTodoItem: TpjhTodoItem; ASQLToDoItem: TSQLToDoItem);
procedure AssignSQLToDoItemTopjhTodoItem(ASQLToDoItem: TSQLToDoItem; ApjhTodoItem: TpjhTodoItem);

procedure LoadTaskFromVariant(ATask:TSQLGSTask; ADoc: variant);
procedure LoadCustomerFromVariant(ACustomer: TSQLCustomer; ADoc: variant);
procedure LoadSubConFromVariant(ASubCon: TSQLSubCon; ADoc: variant);
procedure LoadMaterial4ProjectFromVariant(AMat4Proj: TSQLMaterial4Project; ADoc: variant);

procedure InitClient4InvoiceManage;
function CreateOrGetLoadInvoiceTask(const ATaskID: integer): TSQLInvoiceTask;
function GetInvoiceTaskFromID(const ATaskID: integer): TSQLInvoiceTask;
function GetFilesFromInvoiceTask(ATask: TSQLInvoiceTask): TSQLInvoiceFile;
function GetFilesFromInvoiceItem(AItem: TSQLInvoiceItem): TSQLInvoiceFile;
function GetFilesFromInvoiceIDList(AIDList: TIDList4Invoice): TSQLInvoiceFile;
function GetItemsFromInvoiceTask(ATask: TSQLInvoiceTask): TSQLInvoiceItem;
function GetInvoiceTaskFromHullNoNOrderNo(AHullNo, AOrderNo: string): TSQLInvoiceTask;
function GetInvoiceTaskFromUniqueID(AUniqueID: string): TSQLInvoiceTask;
function GetInvoiceItemFromUniqueID(AUniqueID: string): TSQLInvoiceItem;
function GetInvoiceItemUpdate(AItem: TSQLInvoiceItem): Boolean;
function GetInvoiceItemFromID(ATaskID, AItemID: TID): TSQLInvoiceItem;
procedure GetInvoiceItem2StrList(AItem:TSQLInvoiceItem; var AList: TStringList);
function GetInvoiceFileFromID(ATaskID, AItemID: TID): TSQLInvoiceFile;
function GetInvoiceFileUpdate(AFiles: TSQLInvoiceFile): Boolean;

procedure AddOrUpdateInvoiceTask(ATask: TSQLInvoiceTask);
procedure DeleteInvoiceTaskFromID(ATaskID: TID);
procedure DeleteFilesFromInvoiceTask(ATask: TSQLInvoiceTask);
procedure AddOrUpdateInvoiceItem(AItem: TSQLInvoiceItem);
procedure DeleteInvoiceItemFromTask(ATask: TSQLInvoiceTask);
procedure DeleteInvoiceItemFromID(AItemID: TID);
procedure AddOrUpdateInvoiceFiles(AFiles: TSQLInvoiceFile);
procedure DeleteFilesFromInvoiceItem(AItem: TSQLInvoiceItem);
procedure DeleteFilesFromID(ATaskID, AItemID: TID);

var
  g_ProjectDB,
  g_MasterDB,
  g_InvoiceFileDB,
  g_InvoiceProjectDB,
  g_InvoiceItemDB: TSQLRestClientURI;
  ProjectModel, MasterModel, InvoiceFileModel, InvoiceTaskModel,
  InvoiceItemModel: TSQLModel;
  g_IPCClient: TIPCClient;
  g_FSMClass: TFSMClass;

implementation

uses SysUtils, mORMotSQLite3, Forms, TodoList, VarRecUtils;

procedure InitClient();
var
  LStr: string;
begin
  LStr := ChangeFileExt(Application.ExeName,'.db3');
  ProjectModel:= CreateProjectModel;
  g_ProjectDB:= TSQLRestClientDB.Create(ProjectModel, CreateProjectModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_ProjectDB).Server.CreateMissingTables;

  LStr := LStr.Replace('.db3', '_Master.db3');
  MasterModel := CreateMasterModel;
  g_MasterDB:= TSQLRestClientDB.Create(MasterModel, CreateMasterModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_MasterDB).Server.CreateMissingTables;

  InitGSFileClient(Application.ExeName);
end;

function CreateProjectModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLGSTask,TSQLEmailMsg,TSQLEmailMsgs,TSQLToDoItem]);
end;

function CreateMasterModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLCustomer, TSQLSubCon, TSQLMaterial4Project, TSQLMasterCustomer]);
end;

function CreateInvoiceFilesModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLInvoiceFile]);
end;

function CreateInvoiceTaskModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLInvoiceTask]);
end;

function CreateInvoiceItemModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLInvoiceItem]);
end;

procedure InitFSM;
var Li: TSalesProcessType;
begin
  g_FSMClass := TFSMClass.Create(0);

  for Li := sptNone to sptFinal do
    Add2FSM(LI);
end;

procedure Add2FSM(ASPType:TSalesProcessType=sptNone;
  ACompanyType: TCompanyType=ctNull);
var
  LFSMState: TFSMState;
  LNumOfTransaction: integer;
begin
  if (ASPType = sptForeignCustOnlyService4FieldService) or
    (ASPType = sptForeignCustOnlyService4FieldService) or
    (ASPType = sptForeignCustOnlyService4FieldService) or
    (ASPType = sptForeignCustOnlyService4FieldService) then
  begin
    LFSMState := TFSMState.Create(ord(ASPType), 10);

    with LFSMState do
    begin
      AddTransition(ord(spNone), ord(spQtnReq2SubCon));
      AddTransition(ord(spQtnReq2SubCon), ord(spQtnRecvFromSubCon));
      AddTransition(ord(spQtnRecvFromSubCon), ord(spSECanAvail2SubCon));
      AddTransition(ord(spSECanAvail2SubCon), ord(spSEAvailRecvFromSubCon));
      AddTransition(ord(spSEAvailRecvFromSubCon), ord(spSEDispatchReq2SubCon));
      AddTransition(ord(spSEDispatchReq2SubCon), ord(spSRRecvFromSubCon));
      AddTransition(ord(spSRRecvFromSubCon), ord(spInvoiceRecvFromSubCon));
      AddTransition(ord(spInvoiceRecvFromSubCon), ord(spTaxBillReq2SubCon));
      AddTransition(ord(spTaxBillReq2SubCon), ord(spTaxBillRecvFromSubCon));
      AddTransition(ord(spTaxBillRecvFromSubCon), ord(spFinal));
    end;
  end
  else
  begin
    LNumOfTransaction := 27;

    if ASPType > sptDomesticCustOnlyService then
      LNumOfTransaction := LNumOfTransaction + 6
    else
      LNumOfTransaction := LNumOfTransaction + 1;

    LFSMState := TFSMState.Create(ord(ASPType), LNumOfTransaction);

    with LFSMState do
    begin
      AddTransition(ord(spNone), ord(spQtnReqRecvFromCust));
      AddTransition(ord(spQtnReqRecvFromCust), ord(spQtnReq2SubCon));
      AddTransition(ord(spQtnReq2SubCon), ord(spQtnRecvFromSubCon));
      AddTransition(ord(spQtnRecvFromSubCon), ord(spQtnSend2Cust));
      AddTransition(ord(spQtnSend2Cust), ord(spVslSchedReq2Cust));
      AddTransition(ord(spVslSchedReq2Cust), ord(spSECanAvail2SubCon));
      AddTransition(ord(spSECanAvail2SubCon), ord(spSEAvailRecvFromSubCon));
      AddTransition(ord(spSEAvailRecvFromSubCon), ord(spSECanAttend2Cust));
      AddTransition(ord(spSECanAttend2Cust), ord(spPOReq2Cust));
      AddTransition(ord(spPOReq2Cust), ord(spPORecvFromCust));
      AddTransition(ord(spPORecvFromCust), ord(spSEDispatchReq2SubCon));
      AddTransition(ord(spSEDispatchReq2SubCon), ord(spQtnInput));
      AddTransition(ord(spQtnInput), ord(spQtnApproval));
      AddTransition(ord(spQtnApproval), ord(spOrderInput));
      AddTransition(ord(spOrderInput), ord(spOrderApproval));

      if ASPType > sptDomesticCustOnlyService then
      begin
        //자재가 없으면 아래 생략할 것
        AddTransition(ord(spOrderApproval), ord(spPORCheck4HiPRO));
        AddTransition(ord(spPORCheck4HiPRO), ord(spShipInstruct));//출하지시
        AddTransition(ord(spShipInstruct), ord(spDelivery));
        AddTransition(ord(spDelivery), ord(spAWBRecv));
        AddTransition(ord(spAWBRecv), ord(spAWBSend2Cust));
        AddTransition(ord(spAWBSend2Cust), ord(spSRRecvFromSubCon));
      end
      else
        AddTransition(ord(spOrderApproval), ord(spSRRecvFromSubCon));

      AddTransition(ord(spSRRecvFromSubCon), ord(spSRSend2Cust));
      AddTransition(ord(spSRSend2Cust), ord(spInvoiceRecvFromSubCon));
      AddTransition(ord(spInvoiceRecvFromSubCon), ord(spInvoiceSend2Cust));
      AddTransition(ord(spInvoiceSend2Cust), ord(spInvoiceConfirmFromCust));
      AddTransition(ord(spInvoiceConfirmFromCust), ord(spOrderPriceModify));
      AddTransition(ord(spOrderPriceModify), ord(spModifiedOrderApproval));
      AddTransition(ord(spModifiedOrderApproval), ord(spTaxBillReq2SubCon));
      AddTransition(ord(spTaxBillReq2SubCon), ord(spTaxBillIssue2Cust));
      AddTransition(ord(spTaxBillIssue2Cust), ord(spTaxBillRecvFromSubCon));
      AddTransition(ord(spTaxBillRecvFromSubCon), ord(spTaxBillSend2GeneralAffair));
      AddTransition(ord(spTaxBillSend2GeneralAffair), ord(spSaleReq2GeneralAffair));
      AddTransition(ord(spTaxBillSend2GeneralAffair), ord(spFinal));
    end;
  end;

  g_FSMClass.AddState(LFSMState);
end;

function CreateOrGetLoadTask(const ATaskID: integer): TSQLGSTask;
begin
  if ATaskID = 0 then
  begin
    Result := TSQLGSTask.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    Result:= TSQLGSTask.Create(g_ProjectDB, ATaskID);
    if Result.ID = ATaskID then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end
    else
    begin
      Result := TSQLGSTask.Create;
      Result.IsUpdate := False;
    end;
  end;
end;

function GetLoadTask(const ATaskID: integer): TSQLGSTask;
begin
  Result := nil;

  if ATaskID > 0 then
  begin
    Result:= TSQLGSTask.Create(g_ProjectDB, ATaskID);
    Result.IsUpdate := True;
  end;
end;

function GetTaskFromHullNoNPONo(AHullNo, APONo: string): TSQLGSTask;
begin
  Result := TSQLGSTask.CreateAndFillPrepare(g_ProjectDB,
    'HullNo = ? AND PO_No = ?', [AHullNo, APONo]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetFilesFromTask(ATask: TSQLGSTask): TSQLGSFile;
begin
  Result := GetGSFilesFromID(ATask.ID);
end;

function GetCustomerFromTask(ATask: TSQLGSTask): TSQLCustomer;
begin
  Result := TSQLCustomer.CreateAndFillPrepare(g_MasterDB, 'TaskID = ?', [ATask.ID]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
  begin
    Result := TSQLCustomer.Create;
    Result.IsUpdate := False;
  end
end;

function GetSubConFromTask(ATask: TSQLGSTask): TSQLSubCon;
begin
  Result := TSQLSubCon.CreateAndFillPrepare(g_MasterDB, 'TaskID = ?', [ATask.ID]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
  begin
    Result := TSQLSubCon.Create;
    Result.IsUpdate := False;
  end
end;

function GetMaterial4ProjFromTask(ATask: TSQLGSTask): TSQLMaterial4Project;
begin
  Result := TSQLMaterial4Project.CreateAndFillPrepare(g_MasterDB, 'TaskID = ?', [ATask.ID]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
  begin
    Result := TSQLMaterial4Project.Create;
    Result.IsUpdate := False;
  end
end;

function GetMasterCustomerFromCompanyCodeNName(ACompanyCode, ACompanyName: string;
  ACompanyType: TCompanyType): TSQLMasterCustomer;
var
  ConstArray: TConstArray;
  LWhere, LStr: string;
begin
  LWhere := '';
  ConstArray := CreateConstArray([]);
  try
    if ACompanyName <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACompanyName+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'CompanyName LIKE ? ';
    end;

    if ACompanyCode <> '' then
    begin
      AddConstArray(ConstArray, ['%'+ACompanyCode+'%']);
      if LWhere <> '' then
        LWhere := LWhere + ' and ';
      LWhere := LWhere + 'CompanyCode LIKE ? ';
    end;

    if LWhere = '' then
    begin
      AddConstArray(ConstArray, [-1]);
      LWhere := 'ID <> ? ';
    end;

    AddConstArray(ConstArray, [Ord(ctSubContractor)]);
    if LWhere <> '' then
      LWhere := LWhere + ' and ';

    if ACompanyType = ctSubContractor then
      LWhere := LWhere + 'CompanyType = ? '
    else
      LWhere := LWhere + 'CompanyType <> ? ';

    Result := TSQLMasterCustomer.CreateAndFillPrepare(g_MasterDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
//      Result.FillRewind;
      Result.IsUpdate := True;
    end
    else
    begin
      Result := TSQLMasterCustomer.Create;
      Result.IsUpdate := False;
    end
  finally
    FinalizeConstArray(ConstArray);
  end;
end;

function GetToDoItemFromTask(ATask: TSQLGSTask): TSQLToDoItem;
begin
  Result := TSQLToDoItem.CreateAndFillPrepare(g_ProjectDB, 'TaskID = ?', [ATask.ID]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
  begin
    Result := TSQLToDoItem.Create;
    Result.IsUpdate := False;
  end
end;

procedure DeleteTask(ATaskID: TID);
var
  LTask: TSQLGSTask;
begin
  LTask := GetLoadTask(ATaskID);

  if Assigned(LTask) then
  begin
    DeleteMailsFromTask(LTask);
    DeleteFilesFromTask(LTask);
    DeleteCustomerFromTask(LTask);
    DeleteSubConFromTask(LTask);
    DeleteMaterial4ProjFromTask(LTask);
    DeleteToDoListFromTask(LTask);

    g_ProjectDB.Delete(TSQLGSTask, LTask.ID);
  end;
end;

procedure DeleteMailsFromTask(ATask: TSQLGSTask);
var
  LIds: TIDDynArray;
  i: integer;
begin
  ATask.EmailMsg.DestGet(g_ProjectDB, ATask.ID, LIds);

  for i := Low(LIds) to High(LIds) do
  begin
    ATask.EmailMsg.ManyDelete(g_ProjectDB, ATask.ID, LIds[i]);
    g_ProjectDB.Delete(TSQLEmailMsg, LIds[i]);
  end;
end;

procedure DeleteFilesFromTask(ATask: TSQLGSTask);
var
  LSQLGSFile: TSQLGSFile;
begin
  LSQLGSFile := GetFilesFromTask(ATask);

  try
    while LSQLGSFile.FillOne do
    begin
      g_FileDB.Delete(TSQLGSFile, LSQLGSFile.ID);
    end;
  finally
    FreeAndNil(LSQLGSFile);
  end;
end;

procedure DeleteCustomerFromTask(ATask: TSQLGSTask);
var
  LSQLCustomer: TSQLCustomer;
begin
  LSQLCustomer := GetCustomerFromTask(ATask);
  try
    g_MasterDB.Delete(TSQLCustomer, LSQLCustomer.ID);
  finally
    FreeAndNil(LSQLCustomer);
  end;
end;

procedure DeleteMaterial4ProjFromTask(ATask: TSQLGSTask);
var
  LSQLMaterial4Project: TSQLMaterial4Project;
begin
  LSQLMaterial4Project := GetMaterial4ProjFromTask(ATask);
  try
    g_MasterDB.Delete(TSQLMaterial4Project, LSQLMaterial4Project.ID);
  finally
    FreeAndNil(LSQLMaterial4Project);
  end;
end;

procedure DeleteSubConFromTask(ATask: TSQLGSTask);
var
  LSQLSubCon: TSQLSubCon;
begin
  LSQLSubCon := GetSubConFromTask(ATask);
  try
    g_MasterDB.Delete(TSQLSubCon, LSQLSubCon.ID);
  finally
    FreeAndNil(LSQLSubCon);
  end;
end;

procedure DeleteToDoListFromTask(ATask: TSQLGSTask);
var
  LSQLToDoItem: TSQLToDoItem;
begin
  LSQLToDoItem := GetToDoItemFromTask(ATask);
  try
//    LSQLToDoItem.FillRewind;

    while LSQLToDoItem.FillOne do
      g_ProjectDB.Delete(TSQLToDoItem, LSQLToDoItem.ID);
  finally
    FreeAndNil(LSQLToDoItem);
  end;
end;

function GetCompanyCode(ATask: TSQLGSTask): string;
var
  LCustomer: TSQLCustomer;
begin
  LCustomer := GetCustomerFromTask(ATask);
  try
    if LCustomer.IsUpdate then
    begin
      Result := UTF8ToString(LCustomer.fCompanyCode);
    end;
  finally
    LCustomer.Free;
  end;
end;

function GetQTNContent(ATask: TSQLGSTask): string;
begin
  Result := ATask.HullNo + ' ' + ATask.ShipName + #13#10 +
            '작업일: ' + FormatDateTime('YYYY.MM.DD', TimeLogToDateTime(ATask.WorkBeginDate)) +
            ' ~ ' + FormatDateTime('YYYY.MM.DD',TimeLogToDateTime(ATask.WorkEndDate)) + #13#10 +
            '작업내용: ' + ATask.WorkSummary + ' (' + ATask.NationPort + ')';

end;

procedure AddOrUpdateTask(ATask: TSQLGSTask);
begin
  if ATask.IsUpdate then
  begin
    g_ProjectDB.Update(ATask);
    ShowMessage('Task Update 완료');
  end
  else
  begin
    g_ProjectDB.Add(ATask, true);
    ShowMessage('Task Add 완료');
  end;
end;

procedure AddOrUpdateCustomer(ACustomer: TSQLCustomer);
begin
  if ACustomer.IsUpdate then
  begin
    g_MasterDB.Update(ACustomer);
//    ShowMessage('Customer Update 완료');
  end
  else
  begin
    g_MasterDB.Add(ACustomer, true);
//    ShowMessage('Customer Add 완료');
  end;
end;

procedure AddOrUpdateMaterial4Project(
  AMaterial4Project: TSQLMaterial4Project);
begin
  if AMaterial4Project.IsUpdate then
  begin
    g_MasterDB.Update(AMaterial4Project);
//    ShowMessage('자재 Update 완료');
  end
  else
  begin
    g_MasterDB.Add(AMaterial4Project, true);
//    ShowMessage('자재 Add 완료');
  end;
end;

procedure AddOrUpdateSubCon(ASubCon: TSQLSubCon);
begin
  if ASubCon.IsUpdate then
  begin
    g_MasterDB.Update(ASubCon);
//    ShowMessage('협력사 Update 완료');
  end
  else
  begin
    g_MasterDB.Add(ASubCon, true);
//    ShowMessage('협력사 Add 완료');
  end;
end;

procedure InsertOrUpdateToDoList2DB(ApjhTodoItem: TpjhTodoItem; AIdAdd: Boolean);
var
  LSQLToDoItem: TSQLToDoItem;
  LTaskID: TID;
begin
  LTaskID := StrToIntDef(ApjhTodoItem.TaskCode, -1);
  LSQLToDoItem := TSQLToDoItem.CreateAndFillPrepare(g_ProjectDB, 'TaskID = ?', [LTaskID]);

  try
    if LSQLToDoItem.FillOne then
      LSQLToDoItem.IsUpdate := True
    else
    begin
      LSQLToDoItem := TSQLToDoItem.Create;
      LSQLToDoItem.IsUpdate := False;
    end;

//    if LSQLToDoItem.IsUpdate then
    AssignpjhTodoItemToSQLToDoItem(ApjhTodoItem, LSQLToDoItem);

    if AIdAdd then
      g_ProjectDB.Add(LSQLToDoItem, True)
    else
      g_ProjectDB.Update(LSQLToDoItem);
  finally
    FreeAndNil(LSQLToDoItem);
  end;
end;

procedure DeleteToDoListFromDB(ApjhTodoItem: TpjhTodoItem);
var
  LSQLToDoItem: TSQLToDoItem;
  LTaskID: TID;
begin
  LTaskID := StrToInt(ApjhTodoItem.TaskCode);
  LSQLToDoItem := TSQLToDoItem.CreateAndFillPrepare(g_ProjectDB, 'TaskID = ? and ToDo_Code = ?', [LTaskID, ApjhTodoItem.TodoCode]);

  try
    if LSQLToDoItem.FillOne then
    begin
      g_ProjectDB.Delete(TSQLToDoItem, LSQLToDoItem.ID);
    end;
  finally
    FreeAndNil(LSQLToDoItem);
  end;
end;

procedure LoadToDoCollectFromTask(ATask: TSQLGSTask; var AToDoCollect: TpjhToDoItemCollection);
var
  LSQLToDoItem: TSQLToDoItem;
  LpjhToDoItem: TpjhToDoItem;
begin
//  AToDoCollect.Clear;

  LSQLToDoItem := TSQLToDoItem.CreateAndFillPrepare(g_ProjectDB, 'TaskID = ?', [ATask.ID]);
  try
    while LSQLToDoItem.FillOne do
    begin
      LpjhToDoItem := AToDoCollect.Add;
      LSQLToDoItem.Project := ATask.HullNo;
      AssignSQLToDoItemTopjhTodoItem(LSQLToDoItem, LpjhToDoItem);
    end;
  finally
    FreeAndNil(LSQLToDoItem);
  end;
end;

procedure AssignpjhTodoItemToSQLToDoItem(ApjhTodoItem: TpjhTodoItem; ASQLToDoItem: TSQLToDoItem);
begin
  ASQLToDoItem.fTaskID := StrToIntDef(ApjhTodoItem.TaskCode, 0);

  ASQLToDoItem.Category := ApjhTodoItem.Category;
  ASQLToDoItem.Complete := ApjhTodoItem.Complete;
  ASQLToDoItem.Completion := ApjhTodoItem.Completion;
  ASQLToDoItem.CompletionDate := TimeLogFromDateTime(ApjhTodoItem.CompletionDate);
  ASQLToDoItem.CreationDate := TimeLogFromDateTime(ApjhTodoItem.CreationDate);
  ASQLToDoItem.DueDate := TimeLogFromDateTime(ApjhTodoItem.DueDate);
  ASQLToDoItem.ImageIndex := ApjhTodoItem.ImageIndex;
  ASQLToDoItem.Notes := ApjhTodoItem.Notes.Text;
  ASQLToDoItem.Priority := Ord(ApjhTodoItem.Priority);
  ASQLToDoItem.Project := ApjhTodoItem.Project;
  ASQLToDoItem.Resource := ApjhTodoItem.Resource;
  ASQLToDoItem.Status := Ord(ApjhTodoItem.Status);
  ASQLToDoItem.Subject := ApjhTodoItem.Subject;
  ASQLToDoItem.Tag := ApjhTodoItem.Tag;
  ASQLToDoItem.TotalTime := ApjhTodoItem.TotalTime;

  ASQLToDoItem.Todo_Code := ApjhTodoItem.TodoCode;
  ASQLToDoItem.Task_Code := ApjhTodoItem.TaskCode;
  ASQLToDoItem.Plan_Code := ApjhTodoItem.PlanCode;
  ASQLToDoItem.ModId := ApjhTodoItem.ModId;

  ASQLToDoItem.AlarmType := ApjhTodoItem.AlarmType;
  ASQLToDoItem.AlarmTime1 := TimeLogFromDateTime(ApjhTodoItem.AlarmTime);
  ASQLToDoItem.AlarmTime2 := ApjhTodoItem.AlarmTime2;
  ASQLToDoItem.AlarmFlag := ApjhTodoItem.AlarmFlag;
  ASQLToDoItem.Alarm2Msg := ApjhTodoItem.Alarm2Msg;
  ASQLToDoItem.Alarm2Note := ApjhTodoItem.Alarm2Note;
  ASQLToDoItem.Alarm2Email := ApjhTodoItem.Alarm2Email;

  ASQLToDoItem.ModDate := TimeLogFromDateTime(ApjhTodoItem.ModDate);
end;

procedure AssignSQLToDoItemTopjhTodoItem(ASQLToDoItem: TSQLToDoItem; ApjhTodoItem: TpjhTodoItem);
begin
  ApjhTodoItem.TaskCode := IntToStr(ASQLToDoItem.fTaskID);

  ApjhTodoItem.Category := ASQLToDoItem.Category;
  ApjhTodoItem.Complete := ASQLToDoItem.Complete;
  ApjhTodoItem.Completion := ASQLToDoItem.Completion;
  ApjhTodoItem.CompletionDate := TimeLogToDateTime(ASQLToDoItem.CompletionDate);
  ApjhTodoItem.CreationDate := TimeLogToDateTime(ASQLToDoItem.CreationDate);
  ApjhTodoItem.DueDate := TimeLogToDateTime(ASQLToDoItem.DueDate);
  ApjhTodoItem.ImageIndex := ASQLToDoItem.ImageIndex;
  ApjhTodoItem.Notes.Text := ASQLToDoItem.Notes;
  ApjhTodoItem.Priority := TTodoPriority(ASQLToDoItem.Priority);
  ApjhTodoItem.Project := ASQLToDoItem.Project;
  ApjhTodoItem.Resource := ASQLToDoItem.Resource;
  ApjhTodoItem.Status := TTodoStatus(ASQLToDoItem.Status);
  ApjhTodoItem.Subject := ASQLToDoItem.Subject;
  ApjhTodoItem.Tag := ASQLToDoItem.Tag;
  ApjhTodoItem.TotalTime := ASQLToDoItem.TotalTime;

  ApjhTodoItem.TodoCode := ASQLToDoItem.Todo_Code;
  ApjhTodoItem.TaskCode := ASQLToDoItem.Task_Code;
  ApjhTodoItem.PlanCode := ASQLToDoItem.Plan_Code;
  ApjhTodoItem.ModId := ASQLToDoItem.ModId;

  ApjhTodoItem.AlarmType := ASQLToDoItem.AlarmType;
  ApjhTodoItem.AlarmTime1 := ASQLToDoItem.AlarmTime1;
  ApjhTodoItem.AlarmTime2 := ASQLToDoItem.AlarmTime2;
  ApjhTodoItem.AlarmFlag := ASQLToDoItem.AlarmFlag;
  ApjhTodoItem.Alarm2Msg := ASQLToDoItem.Alarm2Msg;
  ApjhTodoItem.Alarm2Note := ASQLToDoItem.Alarm2Note;
  ApjhTodoItem.Alarm2Email := ASQLToDoItem.Alarm2Email;

  ApjhTodoItem.ModDate := TimeLogToDateTime(ASQLToDoItem.ModDate);
end;

procedure LoadTaskFromVariant(ATask:TSQLGSTask; ADoc: variant);
begin
  if ADoc = null then
    exit;

  ATask.HullNo := ADoc.HullNo;
  ATask.ShipName := ADoc.ShipName;
  ATask.ProductType := ADoc.ProductType;
  ATask.PO_No := ADoc.PO_No;
  ATask.QTN_No := ADoc.QTN_No;
  ATask.Order_No := ADoc.Order_No;
  ATask.WorkSummary := ADoc.WorkSummary;
  ATask.NationPort := ADoc.NationPort;
  ATask.EtcContent := ADoc.EtcContent;
  ATask.ShipOwner := ADoc.ShipOwner;
  ATask.ChargeInPersonId := ADoc.ChargeInPersonId;

  ATask.SalesProcessType := ADoc.SalesProcessType;
//  ATask.CompanyType := TCompanyType read FCompanyType write FCompanyType;
  ATask.CurrentWorkStatus := ADoc.CurrentWorkStatus;
  ATask.NextWork := ADoc.NextWork;
  ATask.SECount := ADoc.SECount;
  ATask.SEList := ADoc.SEList;
//  ATask.SubConRecs := ADoc.SubConRecs;
  ATask.EngineerAgency := ADoc.EngineerAgency;
  ATask.SubConPrice := ADoc.SubConPrice;
  ATask.SalesPrice := ADoc.SalesPrice;
  ATask.ExchangeRate := ADoc.ExchangeRate;
  ATask.BaseProjectNo := ADoc.BaseProjectNo;
  ATask.ShippingNo := ADoc.ShippingNo;
  ATask.CurrencyKind := ADoc.CurrencyKind;
  ATask.DeliveryCondition := ADoc.DeliveryCondition;
  ATask.EstimateType := ADoc.EstimateType;
  ATask.TermsOfPayment := ADoc.TermsOfPayment;

  ATask.InqRecvDate := ADoc.InqRecvDate;
  ATask.InvoiceIssueDate := ADoc.InvoiceIssueDate;
  ATask.QTNIssueDate := ADoc.QTNIssueDate;
  ATask.QTNInputDate := ADoc.QTNInputDate;
  ATask.OrderInputDate := ADoc.OrderInputDate;
  ATask.AttendScheduled := ADoc.AttendScheduled;
  ATask.WorkBeginDate := ADoc.WorkBeginDate;
  ATask.WorkEndDate := ADoc.WorkEndDate;
  ATask.CurWorkFinishDate := ADoc.CurWorkFinishDate;
  ATask.SRRecvDate := ADoc.SRRecvDate;
  ATask.SubConInvoiceIssueDate := ADoc.SubConInvoiceIssueDate;
  ATask.SalesReqDate := ADoc.SalesReqDate;
  ATask.ShippingDate := ADoc.ShippingDate;
  ATask.CustomerID := ADoc.CustomerID;
  ATask.SubConId := ADoc.SubConId;
  ATask.ToDoId := ADoc.ToDoId;
  ATask.UniqueTaskID := ADoc.UniqueTaskID;
//  ATask.EmailMsg := ADoc.EmailMsg;
end;

procedure LoadCustomerFromVariant(ACustomer: TSQLCustomer; ADoc: variant);
begin
  if ADoc = null then
    exit;

  ACustomer.TaskID := ADoc.TaskID;
  ACustomer.FirstName := ADoc.FirstName;
  ACustomer.Surname := ADoc.Surname;
  ACustomer.CompanyCode := ADoc.CompanyCode;
  ACustomer.EMail := ADoc.EMail;
  ACustomer.CompanyName := ADoc.CompanyName;
  ACustomer.MobilePhone := ADoc.MobilePhone;
  ACustomer.OfficePhone := ADoc.OfficePhone;
  ACustomer.CompanyAddress := ADoc.CompanyAddress;
  ACustomer.Position := ADoc.Position;
  ACustomer.ManagerName := ADoc.ManagerName;
  ACustomer.Nation := ADoc.Nation;
  ACustomer.CompanyType := ADoc.CompanyType;
  ACustomer.AgentInfo := ADoc.AgentInfo;
end;

procedure LoadSubConFromVariant(ASubCon: TSQLSubCon; ADoc: variant);
begin
  if ADoc = null then
    exit;

  ASubCon.TaskID := ADoc.TaskID;
  ASubCon.FirstName := ADoc.FirstName;
  ASubCon.Surname := ADoc.Surname;
  ASubCon.CompanyCode := ADoc.CompanyCode;
  ASubCon.EMail := ADoc.EMail;
  ASubCon.CompanyName := ADoc.CompanyName;
  ASubCon.MobilePhone := ADoc.MobilePhone;
  ASubCon.OfficePhone := ADoc.OfficePhone;
  ASubCon.CompanyAddress := ADoc.CompanyAddress;
  ASubCon.Position := ADoc.Position;
  ASubCon.ManagerName := ADoc.ManagerName;
  ASubCon.Nation := ADoc.Nation;
  ASubCon.CompanyType := ADoc.CompanyType;

end;

procedure LoadMaterial4ProjectFromVariant(AMat4Proj: TSQLMaterial4Project; ADoc: variant);
begin
  if ADoc = null then
    exit;

  AMat4Proj.PORNo :=ADoc.PORNo;
  AMat4Proj.SupplyCount :=ADoc.SupplyCount;
  AMat4Proj.PORIssueDate :=ADoc.PORIssueDate;
  AMat4Proj.DeliveryAddress :=ADoc.DeliveryAddress;
  AMat4Proj.AirWayBill :=ADoc.AirWayBill;
  AMat4Proj.DeliveryCharge :=ADoc.DeliveryCharge;
  AMat4Proj.DeliveryCompany :=ADoc.DeliveryCompany;
end;

procedure InitClient4InvoiceManage;
var
  LStr: string;
begin
  LStr := ChangeFileExt(Application.ExeName,'.db3');
  InvoiceTaskModel:= CreateInvoiceTaskModel;
  g_InvoiceProjectDB:= TSQLRestClientDB.Create(InvoiceTaskModel, CreateInvoiceTaskModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_InvoiceProjectDB).Server.CreateMissingTables;

  LStr := LStr.Replace('.db3', '_Items.db3');
  InvoiceItemModel := CreateInvoiceItemModel;
  g_InvoiceItemDB:= TSQLRestClientDB.Create(InvoiceItemModel, CreateInvoiceItemModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_InvoiceItemDB).Server.CreateMissingTables;

  LStr := LStr.Replace('.db3', '_Files.db3');
  InvoiceFileModel := CreateInvoiceFilesModel;
  g_InvoiceFileDB:= TSQLRestClientDB.Create(InvoiceFileModel, CreateInvoiceFilesModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_InvoiceFileDB).Server.CreateMissingTables;
end;

function CreateOrGetLoadInvoiceTask(const ATaskID: integer): TSQLInvoiceTask;
begin
  if ATaskID = 0 then
  begin
    Result := TSQLInvoiceTask.Create;
    Result.IsUpdate := False;
  end
  else
  begin
    Result:= TSQLInvoiceTask.Create(g_InvoiceProjectDB, ATaskID);
    if Result.ID = ATaskID then
    begin
      Result.IsUpdate := True;
    end
    else
    begin
      Result := TSQLInvoiceTask.Create;
      Result.IsUpdate := False;
    end;
  end;
end;

function GetInvoiceTaskFromID(const ATaskID: integer): TSQLInvoiceTask;
begin
  Result := nil;

  if ATaskID > 0 then
  begin
    Result:= TSQLInvoiceTask.Create(g_InvoiceProjectDB, ATaskID);
    Result.IsUpdate := True;
  end;
end;

function GetFilesFromInvoiceTask(ATask: TSQLInvoiceTask): TSQLInvoiceFile;
begin
  Result := TSQLInvoiceFile.CreateAndFillPrepare(g_InvoiceFileDB, 'TaskID = ?', [ATask.ID]);
end;

function GetFilesFromInvoiceItem(AItem: TSQLInvoiceItem): TSQLInvoiceFile;
begin
  Result := TSQLInvoiceFile.CreateAndFillPrepare(g_InvoiceFileDB, 'TaskID = ? and ItemID = ?', [AItem.TaskID, AItem.ItemID]);
end;

function GetFilesFromInvoiceIDList(AIDList: TIDList4Invoice): TSQLInvoiceFile;
begin
  Result := TSQLInvoiceFile.CreateAndFillPrepare(g_InvoiceFileDB, 'TaskID = ? and ItemID = ?', [AIDList.TaskID, AIDList.ItemId]);
end;

function GetItemsFromInvoiceTask(ATask: TSQLInvoiceTask): TSQLInvoiceItem;
begin
  Result := TSQLInvoiceItem.CreateAndFillPrepare(g_InvoiceItemDB, 'TaskID = ?', [ATask.ID]);
end;

function GetInvoiceTaskFromHullNoNOrderNo(AHullNo, AOrderNo: string): TSQLInvoiceTask;
begin
  Result := TSQLInvoiceTask.CreateAndFillPrepare(g_InvoiceProjectDB,
    'HullNo = ? AND Order_No = ?', [AHullNo, AOrderNo]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetInvoiceTaskFromUniqueID(AUniqueID: string): TSQLInvoiceTask;
begin
  Result := TSQLInvoiceTask.CreateAndFillPrepare(g_InvoiceProjectDB,
    'UniqueTaskID = ?', [AUniqueID]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetInvoiceItemFromUniqueID(AUniqueID: string): TSQLInvoiceItem;
begin
  Result := TSQLInvoiceItem.CreateAndFillPrepare(g_InvoiceItemDB,
    'UniqueItemID = ?', [AUniqueID]);

  if Result.FillOne then
    Result.IsUpdate := True
  else
    Result.IsUpdate := False;
end;

function GetInvoiceItemUpdate(AItem: TSQLInvoiceItem): Boolean;
var
  LItem: TSQLInvoiceItem;
begin
  LItem := TSQLInvoiceItem.CreateAndFillPrepare(g_InvoiceItemDB,
    'TaskID = ?', [AItem.TaskID]);

  try
    Result := LItem.FillOne;
  finally
    LItem.Free;
  end;
end;

function GetInvoiceItemFromID(ATaskID, AItemID: TID): TSQLInvoiceItem;
begin
  Result := TSQLInvoiceItem.CreateAndFillPrepare(g_InvoiceItemDB,
    'TaskID = ? and ID = ?', [ATaskID, AItemID]);
end;

procedure GetInvoiceItem2StrList(AItem:TSQLInvoiceItem; var AList: TStringList);
var
  LStr: string;
begin
  if AItem.FillRewind then
  begin
    AList.Clear;

    while AItem.FillOne do
    begin
      LStr := GSInvoiceItemType2String(AItem.InvoiceItemType) + ';';
      LStr := LStr + AItem.ItemDesc + ';';
      LStr := LStr + AItem.Qty + ';';
      LStr := LStr + AItem.fUnit + ';';
      LStr := LStr + AItem.UnitPrice + ';';
      LStr := LStr + AItem.TotalPrice;

      AList.Add(LStr);
    end;
  end;
end;

function GetInvoiceFileFromID(ATaskID, AItemID: TID): TSQLInvoiceFile;
begin
  Result := TSQLInvoiceFile.CreateAndFillPrepare(g_InvoiceFileDB, 'TaskID = ? and ItemID = ?', [ATaskID, AItemID]);
end;

function GetInvoiceFileUpdate(AFiles: TSQLInvoiceFile): Boolean;
var
  LFile: TSQLInvoiceFile;
begin
  LFile := TSQLInvoiceFile.CreateAndFillPrepare(g_InvoiceFileDB,
    'TaskID = ? and ItemID = ?', [AFiles.TaskID, AFiles.ItemID]);

  try
    Result := LFile.FillOne;
  finally
    LFile.Free;
  end;
end;

procedure AddOrUpdateInvoiceTask(ATask: TSQLInvoiceTask);
begin
  if ATask.IsUpdate then
  begin
    g_InvoiceProjectDB.Update(ATask);
    ShowMessage('Task Update 완료');
  end
  else
  begin
    g_InvoiceProjectDB.Add(ATask, true);
    ShowMessage('Task Add 완료');
  end;
end;

procedure DeleteInvoiceTaskFromID(ATaskID: TID);
var
  LTask: TSQLInvoiceTask;
begin
  LTask := GetInvoiceTaskFromID(ATaskID);

  if Assigned(LTask) then
  begin
    DeleteInvoiceItemFromTask(LTask);

    g_InvoiceProjectDB.Delete(TSQLInvoiceTask, LTask.ID);
  end;
end;

procedure DeleteFilesFromInvoiceTask(ATask: TSQLInvoiceTask);
var
  LSQLGSFile: TSQLInvoiceFile;
begin
  LSQLGSFile := GetFilesFromInvoiceTask(ATask);

  try
    while LSQLGSFile.FillOne do
    begin
      g_InvoiceFileDB.Delete(TSQLInvoiceFile, LSQLGSFile.ID);
    end;
  finally
    FreeAndNil(LSQLGSFile);
  end;
end;

procedure AddOrUpdateInvoiceItem(AItem: TSQLInvoiceItem);
begin
  if AItem.IsUpdate then
  begin
//    g_InvoiceItemDB.Delete(TSQLInvoiceItem, 'TaskID = ?', [AItem.TaskID]);
    g_InvoiceItemDB.Update(AItem);
  end
  else
  begin
    g_InvoiceItemDB.Add(AItem, true);
  end;

  AItem.ItemID := AItem.ID;
  g_InvoiceItemDB.Update(AItem);
end;

procedure DeleteInvoiceItemFromTask(ATask: TSQLInvoiceTask);
var
  LItem: TSQLInvoiceItem;
begin
  LItem := GetItemsFromInvoiceTask(ATask);

  try
    while LItem.FillOne do
    begin
      DeleteFilesFromInvoiceItem(LItem);

      DeleteInvoiceItemFromID(LItem.ID);
    end;
  finally
    FreeAndNil(LItem);
  end;
end;

procedure DeleteInvoiceItemFromID(AItemID: TID);
begin
  g_InvoiceItemDB.Delete(TSQLInvoiceItem, AItemID);
end;

procedure AddOrUpdateInvoiceFiles(AFiles: TSQLInvoiceFile);
begin
  if AFiles.FIsUpdate then
  begin
//    DeleteFilesFromID(AFiles.TaskID, AFiles.ItemID);
//    g_InvoiceFileDB.Add(AFiles, True);
    g_InvoiceFileDB.Update(AFiles);
  end
  else
  begin
    g_InvoiceFileDB.Add(AFiles, true);
  end;
end;

procedure DeleteFilesFromInvoiceItem(AItem: TSQLInvoiceItem);
var
  LInvoiceFile: TSQLInvoiceFile;
begin
  LInvoiceFile := GetFilesFromInvoiceItem(AItem);

  try
    while LInvoiceFile.FillOne do
    begin
      g_InvoiceFileDB.Delete(TSQLInvoiceFile, LInvoiceFile.ID);
    end;
  finally
    FreeAndNil(LInvoiceFile);
  end;
end;

procedure DeleteFilesFromID(ATaskID, AItemID: TID);
var
  LIDList: TIDList4Invoice;
  LSQLGSFile: TSQLInvoiceFile;
begin
  LIDList := TIDList4Invoice.Create;
  try
    LIDList.TaskId := ATaskID;
    LIDList.ItemId := AItemID;

    LSQLGSFile := GetFilesFromInvoiceIDList(LIDList);
    try
      while LSQLGSFile.FillOne do
      begin
        g_InvoiceFileDB.Delete(TSQLInvoiceFile, LSQLGSFile.ID);
      end;
    finally
      FreeAndNil(LSQLGSFile);
    end;
  finally
    LIDList.Free;
  end;
end;

initialization
  InitFSM;

  g_IPCClient := TIPCClient.Create;
  g_IPCClient.ServerName := IPC_SERVER_NAME_4_OUTLOOK;
  g_IPCClient.ConnectClient;

finalization
  g_FSMClass.Destroy;

  if Assigned(g_ProjectDB) then
    FreeAndNil(g_ProjectDB);
  if Assigned(ProjectModel) then
    FreeAndNil(ProjectModel);
  if Assigned(g_MasterDB) then
    FreeAndNil(g_MasterDB);
  if Assigned(MasterModel) then
    FreeAndNil(MasterModel);
  if Assigned(InvoiceTaskModel) then
    FreeAndNil(InvoiceTaskModel);
  if Assigned(g_IPCClient) then
    FreeAndNil(g_IPCClient);
end.
