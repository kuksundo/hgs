unit UElecDataRecord;

interface

uses
  SynCommons,
  mORMot,
  CommonData,
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  UnitTodoCollect;

type
  TSQLEmailMsgs = class;
//  TSQLGSFiles = class;

  PSQLGSFileRec = ^TSQLGSFileRec;
  TSQLGSFileRec = Packed Record
    fFilename: RawUTF8;
    fGSDocType: TGSDocType;
    fData: RawByteString;
  end;

  TSQLGSFileRecs = array of TSQLGSFileRec;

  PSQLSubConRec = ^TSQLSubConRec;
  TSQLSubConRec = Packed Record
    fFilename: RawUTF8;
    fGSDocType: TGSDocType;
    fData: RawByteString;
  end;

  TSQLSubConRecs = array of TSQLSubConRec;

  TSQLGSFile = class(TSQLRecord)
  private
    fTaskID: TID;
    fFiles: TSQLGSFileRecs;
  published
    property TaskID: TID read fTaskID write fTaskID;
    property Files: TSQLGSFileRecs read fFiles write fFiles;
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
  published
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
  end;

  TSQLGSTaskInfo = class(TSQLRecord)
  private
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
    property ShippingNo: RawUTF8 read FShippingNo write FShippingNo;
    property CurrencyKind: integer read FCurrencyKind write FCurrencyKind;

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

function CreateProjectModel: TSQLModel;
function CreateMasterModel: TSQLModel;
function CreateFilesModel: TSQLModel;
procedure InitClient();

function GetFilesFromTask(ATask: TSQLGSTask): TSQLGSFile;
function GetCustomerFromTask(ATask: TSQLGSTask): TSQLCustomer;
function GetSubConFromTask(ATask: TSQLGSTask): TSQLSubCon;
function GetMaterial4ProjFromTask(ATask: TSQLGSTask): TSQLMaterial4Project;
function GetMasterCustomerFromCompanyCodeNName(ACompanyCode, ACompanyName: string): TSQLMasterCustomer;
function GetToDoItemFromTask(ATask: TSQLGSTask): TSQLToDoItem;

procedure InsertOrUpdateToDoList2DB(ApjhTodoItem: TpjhTodoItem; AIdAdd: Boolean);
procedure DeleteToDoListFromDB(ApjhTodoItem: TpjhTodoItem);
procedure LoadToDoCollectFromTask(ATask: TSQLGSTask; var AToDoCollect: TpjhToDoItemCollection);

procedure AssignpjhTodoItemToSQLToDoItem(ApjhTodoItem: TpjhTodoItem; ASQLToDoItem: TSQLToDoItem);
procedure AssignSQLToDoItemTopjhTodoItem(ASQLToDoItem: TSQLToDoItem; ApjhTodoItem: TpjhTodoItem);

var
  g_ProjectDB,
  g_MasterDB,
  g_FileDB: TSQLRestClientURI;
  ProjectModel, MasterModel, FileModel: TSQLModel;
  g_IPCClient: TIPCClient;

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

  LStr := LStr.Replace('_Master.db3', '_Files.db3');
  FileModel := CreateFilesModel;
  g_FileDB:= TSQLRestClientDB.Create(FileModel, CreateFilesModel,
    LStr, TSQLRestServerDB);
  TSQLRestClientDB(g_FileDB).Server.CreateMissingTables;
end;

function CreateProjectModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLGSTask,TSQLEmailMsg,TSQLEmailMsgs,TSQLToDoItem]);
end;

function CreateMasterModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLCustomer, TSQLSubCon, TSQLMaterial4Project, TSQLMasterCustomer]);
end;

function CreateFilesModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLGSFile]);
end;

function GetFilesFromTask(ATask: TSQLGSTask): TSQLGSFile;
begin
  Result := TSQLGSFile.CreateAndFillPrepare(g_FileDB, 'TaskID = ?', [ATask.ID]);
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

function GetMasterCustomerFromCompanyCodeNName(ACompanyCode, ACompanyName: string): TSQLMasterCustomer;
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

    Result := TSQLMasterCustomer.CreateAndFillPrepare(g_MasterDB, Lwhere, ConstArray);

    if Result.FillOne then
    begin
      Result.FillRewind;
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

initialization
  g_IPCClient := TIPCClient.Create;
  g_IPCClient.ServerName := IPC_SERVER_NAME_4_OUTLOOK;
  g_IPCClient.ConnectClient;

finalization
  FreeAndNil(g_ProjectDB);
  FreeAndNil(ProjectModel);
  FreeAndNil(g_MasterDB);
  FreeAndNil(MasterModel);
  FreeAndNil(g_IPCClient);
end.
