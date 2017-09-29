unit CommonData;

interface

uses System.Classes, Outlook2010, Vcl.StdCtrls, FSMClass_Dic, FSMState;

type
  TGUIDFileName = record
    HasInput: boolean;
    FileName: string[255];
  end;

  TOLMsgFile4STOMP = record
    FHost, FUserId, FPasswd: string;
    FMsgFile: string;
  end;

  TEntryIdRecord = record
    FEntryId,
    FStoreId,
    FStoreId4Move,
    FFolderPath,
    FNewEntryId,
    FSubject,
    FTo,
    FHTMLBody,
    FHullNo,
    FAttached,
    FAttachFileName: string;
    FIgnoreReceiver2pjh: Boolean; //True = 수신자가 pjh인가 비교하지 않음
    FIgnoreEmailMove2WorkFolder: Boolean; //True = Working Folder로 이동 안함
    //True = Move하고자 선택한 폴더 아래에 HullNo Folder 생성 후 생성된 폴더에 메일 이동 함
    FIsCreateHullNoFolder: Boolean;
//    FIsShowMailContents: Boolean; //True = Mail Display
  end;

  TOLMsgFileRecord = record
    FEntryId,
    FStoreId,
    FSender,
    FReceiver,
    FCarbonCopy,
    FBlindCC,
    FSubject,
    FUserEmail,
    FUserName: string;
    FMailItem: MailItem;
    FReceiveDate: TDateTime;

    procedure Clear;
  end;

  TQueryDateType = (qdtNull, qdtInqRecv, qdtInvoiceIssue, qdtQTNInput,
    qdtOrderInput, qdtFinal);
  TElecProductType = (eptNull, eptEB, eptEC, eptEG, eptEM, eptER, eptFinal);
  TGSDocType = (dtNull,
              dtQuote2Cust4Material, dtQuote2Cust4Service, dtQuoteFromSubCon,
              dtPOFromCustomer, dtPO2SubCon,
              dtInvoice2Customer, dtInvoiceFromSubCon,
              dtSRFromSubCon,
              dtTaxBill2Customer, dtTaxBillFromSubCon,
              dtCompanySelection, dtConfirmComplete, dtBudgetApproval,
              dtContract, dtFinal);
  TGSInvoiceItemType = (iitNull, iitServiceReport, iitWorkDay, iitTravellingDay,
              iitMaterials, iitAirFare, iitAccommodation, iitTransportation,
              iitMeal, iitEtc, iitFinal);

  TCompanyType = (ctNull, ctNewCompany, ctMaker, ctOwner, ctAgent, ctCorporation, ctFinal);
  TSalesProcess = (spNone, spQtnReqRecvFromCust, spQtnReq2SubCon, spQtnRecvFromSubCon, spQtnSend2Cust,
    spSEAttendReqFromCust, spVslSchedReq2Cust, spSECanAvail2SubCon, spSEAvailRecvFromSubCon,
    spSECanAttend2Cust, spSEAttendConfirmFromCust, spPOReq2Cust, spPORecvFromCust, spSEDispatchReq2SubCon,//13
    spQtnInput, spQtnApproval, spOrderInput, spOrderApproval, spPORCreate, spPORCheck4HiPRO,//19
    spShipInstruct, spDelivery, spAWBRecv, spAWBSend2Cust, spSRRecvFromSubCon, //24
    spSRSend2Cust, spInvoiceRecvFromSubCon, spInvoiceSend2Cust, spInvoiceConfirmFromCust,//28
    spOrderPriceModify, spModifiedOrderApproval, spSalesPriceConfirm,
    spTaxBillReq2SubCon, spTaxBillIssue2Cust, spTaxBillRecvFromSubCon, spTaxBillSend2GeneralAffair, //35
    spSaleReq2GeneralAffair, spFinal //37
  );
  TSalesProcessType = (sptNone, sptForeignCustOnlyService, sptDomesticCustOnlyService,
    sptForeignCustOnlyMaterial,  sptDomesticCustOnlyMaterial,
    sptForeignCustWithServiceNMaterial, sptDomesticCustWithServiceNMaterial,
    sptForeignCustOnlyService4FieldService, sptDomesticCustOnlyService4FieldService,
    sptForeignCustWithServiceNMaterial4FieldService,
    sptDomesticCustWithServiceNMaterial4FieldService,
    sptFinal);
  TProcessDirection = (pdNone, pdToCustomer, pdFromCustomer, pdToSubCon, pdFromSubCon,
    pdToHElec, pdFromHElec, pdToHGS, pdFromHGS, pdFinal);
  TContainData4Mail = (cdmNone, cdmServiceReport,cdmQtn2Cust, cdmQtnFromSubCon,
    cdmPoFromCust, cdmPo2SubCon,cdmInvoice2Cust, cdmInvoiceFromSubCon,
    cdmTaxBillFromSubCon, cdmTaxBill2Cust, cdmFinal
  );
  TEngineerAgency = (eaNone, eaSubCon, eaHGS, eaHELEC);//엔지니어 소속사
  TCurrencyKind = (KW,USD,EUR);

const
  R_QueryDateType : array[qdtNull..qdtFinal] of record
    Description : string;
    Value       : TQueryDateType;
  end = ((Description : '';                        Value : qdtNull),
         (Description : 'Inq 접수일 기준';         Value : qdtInqRecv),
         (Description : 'Invoice 발행일 기준';     Value : qdtInvoiceIssue),
         (Description : 'QTN 입력일 기준';         Value : qdtQTNInput),
         (Description : '수주통보서 입력일 기준';  Value : qdtOrderInput),
         (Description : '';                        Value : qdtFinal)
         );

  R_ElecProductType : array[eptNull..eptFinal] of record
    Description : string;
    Value       : TElecProductType;
  end = ((Description : '';                   Value : eptNull),
         (Description : 'EB-차단기';          Value : eptEB),
         (Description : 'EC-선박자동화';      Value : eptEC),
         (Description : 'EG-몰드변압기';      Value : eptEG),
         (Description : 'EM-배전반';          Value : eptEM),
         (Description : 'ER-발전기';          Value : eptER),
         (Description : 'ER-발전기';          Value : eptFinal)
         );

  R_GSDocType : array[dtNull..dtFinal] of record
    Description : string;
    Value       : TGSDocType;
  end = ((Description : '';                           Value : dtNull),
         (Description : '부품 견적서(To 고객)';       Value : dtQuote2Cust4Material),
         (Description : '서비스 견적서(To 고객)';     Value : dtQuote2Cust4Service),
         (Description : '부품 견적서(From 협력사)';   Value : dtQuoteFromSubCon),
         (Description : 'PO(From 고객)';              Value : dtPOFromCustomer),
         (Description : 'PO(To 협력사)';              Value : dtPO2SubCon),
         (Description : 'Invoice(To 고객)';           Value : dtInvoice2Customer),
         (Description : 'Invoice(From 협력사)';       Value : dtInvoiceFromSubCon),
         (Description : 'Service Report';             Value : dtSRFromSubCon),
         (Description : '세금계산서(To 고객)';        Value : dtTaxBill2Customer),
         (Description : '세금계산서(From 협력사)';    Value : dtTaxBillFromSubCon),
         (Description : '업체선정품의서';             Value : dtCompanySelection),
         (Description : '공사완료확인서';             Value : dtConfirmComplete),
         (Description : '예산승인품의서';             Value : dtBudgetApproval),
         (Description : '계약서';                     Value : dtContract),
         (Description : '';                           Value : dtFinal)
         );

  R_CompanyType : array[ctNull..ctFinal] of record
    Description : string;
    Value       : TCompanyType;
  end = ((Description : '';                   Value : ctNull),
         (Description : '1.New Company';      Value : ctNewCompany),
         (Description : '3.Maker';            Value : ctMaker),
         (Description : '4.Owner';            Value : ctOwner),
         (Description : '6.Agent';            Value : ctAgent),
         (Description : 'B.법인';             Value : ctCorporation),
         (Description : '';                   Value : ctFinal)
         );

  R_SalesProcess : array[spNone..spFinal] of record
    Description : string;
    Value       : TSalesProcess;
  end = ((Description : '';                         Value : spNone),
         (Description : '견적요청접수 <- 고객';     Value : spQtnReqRecvFromCust),
         (Description : '견적요청 -> 협력사';       Value : spQtnReq2SubCon),
         (Description : '젼적서입수 <- 협력사';     Value : spQtnRecvFromSubCon),
         (Description : '견적서송부 -> 고객';       Value : spQtnSend2Cust),
         (Description : 'SE파견요청접수 <- 고객';   Value : spSEAttendReqFromCust),
         (Description : '선박스케쥴요청 -> 고객';   Value : spVslSchedReq2Cust),
         (Description : 'SE파견가능문의 -> 협력사'; Value : spSECanAvail2SubCon),
         (Description : 'SE파견가능확인 <- 협력사'; Value : spSEAvailRecvFromSubCon),
         (Description : 'SE파견가능통보 -> 고객';   Value : spSECanAttend2Cust),
         (Description : 'PO발행요청 -> 고객';       Value : spPOReq2Cust),
         (Description : 'SE파견요청확인 <- 고객';   Value : spSEAttendConfirmFromCust),
         (Description : 'PO입수 <- 고객';           Value : spPORecvFromCust),
         (Description : 'SE파견요청 -> 협력사';     Value : spSEDispatchReq2SubCon),
         (Description : 'QUOTATION입력 -> MAPS';    Value : spQtnInput),
         (Description : 'QUOTATION승인 -> MAPS';    Value : spQtnApproval),
         (Description : '수주통보서입력 -> MAPS';   Value : spOrderInput),
         (Description : '수주통보서승인 -> MAPS';   Value : spOrderApproval),
         (Description : 'POR 생성 -> MAPS(POR관리)';   Value : spPORCreate),
         (Description : 'POR발행확인 -> Hi-PRO';    Value : spPORCheck4HiPRO),
         (Description : '출하지시등록 -> MAPS';     Value : spShipInstruct),
         (Description : '자재배송 -> 택배';         Value : spDelivery),
         (Description : 'AWB입수 <- 택배';          Value : spAWBRecv),
         (Description : 'AWB송부 -> 고객';          Value : spAWBSend2Cust),
         (Description : 'SR입수 <- 협력사';         Value : spSRRecvFromSubCon),
         (Description : 'SR송부 -> 고객';           Value : spSRSend2Cust),
         (Description : 'Invoice입수 <- 협력사';    Value : spInvoiceRecvFromSubCon),
         (Description : 'Invoice송부 -> 고객';      Value : spInvoiceSend2Cust),
         (Description : 'Invoice확인 <- 고객';      Value : spInvoiceConfirmFromCust),
         (Description : '수주통보서금액수정 -> MAPS';   Value : spOrderPriceModify),
         (Description : '수주통보서재승인 -> MAPS';     Value : spModifiedOrderApproval),
         (Description : '매출금액확인 -> MAPS(공사매출정보관리)';   Value : spSalesPriceConfirm),
         (Description : '세금계산서발행요청 -> 협력사'; Value : spTaxBillReq2SubCon),
         (Description : '세금계산서발행 -> 국내고객';   Value : spTaxBillIssue2Cust),
         (Description : '세금계산서입수 <- 협력사'; Value : spTaxBillRecvFromSubCon),
         (Description : '세금계산서전달 -> 담당자'; Value : spTaxBillSend2GeneralAffair),
         (Description : '매출처리요청 -> 담당자';   Value : spSaleReq2GeneralAffair),
         (Description : '작업완료';                 Value : spFinal));

  R_SalesProcessType : array[sptNone..sptFinal] of record
    Description : string;
    Value       : TSalesProcessType;
  end = ((Description : '';                           Value : sptNone),
         (Description : '유상용역-해외고객';          Value : sptForeignCustOnlyService),
         (Description : '자재구매-해외고객';          Value : sptForeignCustOnlyMaterial),
         (Description : '유상용역-국내고객';          Value : sptDomesticCustOnlyService),
         (Description : '자재구매-국내고객';          Value : sptDomesticCustOnlyMaterial),
         (Description : '유상용역/자재구매-해외고객'; Value : sptForeignCustWithServiceNMaterial),
         (Description : '유상용역/자재구매-국내고객'; Value : sptDomesticCustWithServiceNMaterial),
         (Description : '유상용역-해외고객(Field Service)';          Value : sptForeignCustOnlyService4FieldService),
         (Description : '유상용역-국내고객(Field Service)';          Value : sptDomesticCustOnlyService4FieldService),
         (Description : '유상용역/자재구매-해외고객(Field Service)'; Value : sptForeignCustWithServiceNMaterial4FieldService),
         (Description : '유상용역/자재구매-국내고객(Field Service)'; Value : sptDomesticCustWithServiceNMaterial4FieldService),
         (Description : ''; Value : sptFinal)
  );

  R_ProcessDirection : array[pdNone..pdFinal] of record
    Description : string;
    Value       : TProcessDirection;
  end = ((Description : '';                 Value : pdNone),
         (Description : 'To 고객';          Value : pdToCustomer),
         (Description : 'From 고객';        Value : pdFromCustomer),
         (Description : 'To 협력사';        Value : pdToSubCon),
         (Description : 'From 협력사';      Value : pdFromSubCon),
         (Description : 'To 현대일렉트릭';  Value : pdToHElec),
         (Description : 'From 현대일렉트릭';Value : pdFromHElec),
         (Description : 'To HGS';           Value : pdToHGS),
         (Description : 'From HGS';         Value : pdToHGS),
         (Description : '';                 Value : pdFinal)
  );

  R_ContainData4Mail : array[cdmNone..cdmFinal] of record
    Description : string;
    Value       : TContainData4Mail;
  end = ((Description : '';                         Value : cdmNone),
         (Description : 'Service Report';             Value : cdmServiceReport),
         (Description : 'Quotation -> Customer';           Value : cdmQtn2Cust),
         (Description : 'Quotation <- SubCon';         Value : cdmQtnFromSubCon),
         (Description : 'PO <- Customer';               Value : cdmPoFromCust),
         (Description : 'PO <- SubCon';             Value : cdmPo2SubCon),
         (Description : 'Invoice -> Customer';          Value : cdmInvoice2Cust),
         (Description : 'Invoice <- SubCon';        Value : cdmInvoiceFromSubCon),
         (Description : 'Tax Bill <- SubCon';     Value : cdmTaxBillFromSubCon),
         (Description : 'Tax Bill -> Customer';       Value : cdmTaxBill2Cust),
         (Description : 'Tax Bill -> Customer';       Value : cdmFinal)
  );

  R_GSInvoiceItemType : array[iitNull..iitFinal] of record
    Description : string;
    Value       : TGSInvoiceItemType;
  end = ((Description : '';                         Value : iitNull),
         (Description : 'Service Report';           Value : iitServiceReport),
         (Description : 'Work Day';                 Value : iitWorkDay),
         (Description : 'Trevelling Day';           Value : iitTravellingDay),
         (Description : 'Materials';                Value : iitMaterials),
         (Description : 'Ex(Airfare)';        Value : iitAirFare),
         (Description : 'Ex(Accommodation)';  Value : iitAccommodation),
         (Description : 'Ex(Transportation)'; Value : iitTransportation),
         (Description : 'Ex(Meal)';           Value : iitMeal),
         (Description : 'Ex(Etc)';            Value : iitEtc),
         (Description : '';                         Value : iitFinal)
  );

  gpSHARED_DATA_NAME = 'SharedData_{BCB1C40A-3B72-44FC-9E72-91E5FF498924}';
  SHARED_DATA_NAME = 'SharedData_{32EF1528-1D5E-48AE-B8AF-341309C303FA}';

  CONSUME_EVENT_NAME = SHARED_DATA_NAME + '_ConsumeEvent';
  PRODUCE_EVENT_NAME = SHARED_DATA_NAME + '_ProduceEvent';

  EMAIL_TOPIC_NAME = '/topic/emailtopic';
  FOLDER_LIST_FILE_NAME = 'FolderList';
  IPC_SERVER_NAME_4_OUTLOOK = 'Mail2CromisIPCServer';
  //Response가 필요할때 사용되는 서버임, 비동기 방식이 아님(비동기 방식은 Response가 안됨)
  IPC_SERVER_NAME_4_OUTLOOK2 = 'Mail2CromisIPCServer2';
  IPC_SERVER_NAME_4_INQMANAGE = 'Mail2CromisIPCClient';

  CMD_LIST = 'CommandList';
  CMD_SEND_MAIL_ENTRYID = 'Send Mail Entry Id';
  CMD_SEND_MAIL_ENTRYID2 = 'Send Mail Entry Id2';
  CMD_SEND_FOLDER_STOREID = 'Send Folder Store Id';
  CMD_RESPONDE_MOVE_FOLDER_MAIL = 'Resonse for Move Mail to Folder';
  CMD_REQ_MAIL_VIEW = 'Request Mail View';
  CMD_REQ_MAILINFO_SEND = 'Request Mail-Info to Send';
  //메일리스트에서 전송, TaskID에 자동으로 들어감
  CMD_REQ_MAILINFO_SEND2 = 'Request Mail-Info to Send2';
  CMD_REQ_MOVE_FOLDER_MAIL = 'Request Move Mail to Folder';
  CMD_REQ_REPLY_MAIL = 'Request Reply Mail';
  CMD_REQ_CREATE_MAIL = 'Request Create Mail';
  CMD_REQ_ADD_APPOINTMENT = 'Request Add Appointment';

  SALES_DIRECTOR_EMAIL_ADDR = 'shjeon@hyundai-gs.com';//매출처리담당자
  MATERIAL_INPUT_EMAIL_ADDR = 'geunhyuk.lim@pantos.com';//자재직투입요청
  FOREIGN_INPUT_EMAIL_ADDR = 'seryeongkim@hyundai-gs.com';//해외고객업체등록
  ELEC_HULL_REG_EMAIL_ADDR = 'seryeongkim@hyundai-gs.com';//전전비표준공사 생성 요청
  PO_REQ_EMAIL_ADDR = 'seryeongkim@hyundai-gs.com';//PO 요청
  SHIPPING_REQ_EMAIL_ADDR = 'yungem.kim@pantos.com';//출하 요청

  MY_EMAIL_SIG = '부품서비스2팀 박정현 차장';
  SHIPPING_MANAGER_SIG = '판토스 김윤겸 주임님';
  SALES_MANAGER_SIG = '부품서비스1팀 전선희 사원님';
  FIELDSERVICE_MANAGER_SIG = '필드서비스팀 이용준 부장님';

  //Task를 Outlook 첨부파일로 만들때 인식하기 위한 문자열
  TASK_JSON_DRAG_SIGNATURE = '{274C083F-EB64-49D8-ADE7-8804CFD0D030}';
  INVOICETASK_JSON_DRAG_SIGNATURE = '{144B4D16-A8E7-4E9A-89C1-994FE6AEC793}';

procedure OLMsgFileRecordClear;
function QueryDateType2String(AQueryDateType:TQueryDateType) : string;
function String2QueryDateType(AQueryDateType:string): TQueryDateType;
procedure QueryDateType2Combo(AComboBox:TComboBox);
function ElecProductType2String(AElecProductType:TElecProductType) : string;
function String2ElecProductType(AElecProductType:string): TElecProductType;
procedure ElecProductType2Combo(AComboBox:TComboBox);
function GSDocType2String(AGSDocType:TGSDocType) : string;
function String2GSDocType(AGSDocType:string): TGSDocType;
procedure GSDocType2Combo(AComboBox:TComboBox);
function CompanyType2String(ACompanyType:TCompanyType) : string;
function String2CompanyType(ACompanyType:string): TCompanyType;
procedure CompanyType2Combo(AComboBox:TComboBox);
function SalesProcess2String(ASalesProcess:TSalesProcess) : string;
function String2SalesProcess(ASalesProcess:string): TSalesProcess;
procedure SalesProcess2Combo(AComboBox:TComboBox);
function SalesProcessType2String(ASalesProcessType:TSalesProcessType) : string;
function String2SalesProcessType(ASalesProcessType:string): TSalesProcessType;
procedure SalesProcessType2Combo(AComboBox:TComboBox);
function ContainData4Mail2String(AContainData4Mail:TContainData4Mail) : string;
function String2ContainData4Mail(AContainData4Mail:string): TContainData4Mail;
procedure ContainData4Mail2Combo(AComboBox:TComboBox);
function ProcessDirection2String(AProcessDirection:TProcessDirection) : string;
function String2ProcessDirection(AProcessDirection:string): TProcessDirection;
procedure ProcessDirection2Combo(AComboBox:TComboBox);
procedure SalesProcess2List(AList: TStringList; AFSMState: TFSMState);
function GSInvoiceItemType2String(AGSInvoiceItemType:TGSInvoiceItemType) : string;
function String2GSInvoiceItemType(AGSInvoiceItemType:string): TGSInvoiceItemType;
procedure GSInvoiceItemType2Combo(AComboBox:TComboBox);

implementation

procedure OLMsgFileRecordClear;
begin
end;

{ TOLMsgFileRecord }

procedure TOLMsgFileRecord.Clear;
begin
  FEntryId := '';
  FStoreId := '';
  FSender := '';
  FReceiver := '';
  FCarbonCopy := '';
  FBlindCC := '';
  FSubject := '';
  FReceiveDate := 0;
  FMailItem := nil;
end;

function QueryDateType2String(AQueryDateType:TQueryDateType) : string;
begin
  if AQueryDateType <= High(TQueryDateType) then
    Result := R_QueryDateType[AQueryDateType].Description;
end;

function String2QueryDateType(AQueryDateType:string): TQueryDateType;
var Li: TQueryDateType;
begin
  for Li := qdtNull to qdtFinal do
  begin
    if R_QueryDateType[Li].Description = AQueryDateType then
    begin
      Result := R_QueryDateType[Li].Value;
      exit;
    end;
  end;
end;

procedure QueryDateType2Combo(AComboBox:TComboBox);
var Li: TQueryDateType;
begin
  AComboBox.Clear;

  for Li := qdtNull to Pred(qdtFinal) do
  begin
    AComboBox.Items.Add(R_QueryDateType[Li].Description);
  end;
end;

function ElecProductType2String(AElecProductType:TElecProductType) : string;
begin
  if AElecProductType <= High(TElecProductType) then
    Result := R_ElecProductType[AElecProductType].Description;
end;

function String2ElecProductType(AElecProductType:string): TElecProductType;
var Li: TElecProductType;
begin
  for Li := eptNull to eptFinal do
  begin
    if R_ElecProductType[Li].Description = AElecProductType then
    begin
      Result := R_ElecProductType[Li].Value;
      exit;
    end;
  end;
end;

procedure ElecProductType2Combo(AComboBox:TComboBox);
var Li: TElecProductType;
begin
  AComboBox.Clear;

  for Li := eptNull to Pred(eptFinal) do
  begin
    AComboBox.Items.Add(R_ElecProductType[Li].Description);
  end;
end;

function GSDocType2String(AGSDocType:TGSDocType) : string;
begin
  if AGSDocType <= High(TGSDocType) then
    Result := R_GSDocType[AGSDocType].Description;
end;

function String2GSDocType(AGSDocType:string): TGSDocType;
var Li: TGSDocType;
begin
  for Li := dtNull to dtFinal do
  begin
    if R_GSDocType[Li].Description = AGSDocType then
    begin
      Result := R_GSDocType[Li].Value;
      exit;
    end;
  end;
end;

procedure GSDocType2Combo(AComboBox:TComboBox);
var Li: TGSDocType;
begin
  AComboBox.Clear;

  for Li := dtNull to Pred(dtFinal) do
  begin
    AComboBox.Items.Add(R_GSDocType[Li].Description);
  end;
end;

function CompanyType2String(ACompanyType:TCompanyType) : string;
begin
  if ACompanyType <= High(TCompanyType) then
    Result := R_CompanyType[ACompanyType].Description;
end;

function String2CompanyType(ACompanyType:string): TCompanyType;
var Li: TCompanyType;
begin
  for Li := ctNull to ctFinal do
  begin
    if R_CompanyType[Li].Description = ACompanyType then
    begin
      Result := R_CompanyType[Li].Value;
      exit;
    end;
  end;
end;

procedure CompanyType2Combo(AComboBox:TComboBox);
var Li: TCompanyType;
begin
  AComboBox.Clear;

  for Li := ctNull to Pred(ctFinal) do
  begin
    AComboBox.Items.Add(R_CompanyType[Li].Description);
  end;
end;

function SalesProcess2String(ASalesProcess:TSalesProcess) : string;
begin
  if ASalesProcess <= High(TSalesProcess) then
    Result := R_SalesProcess[ASalesProcess].Description;
end;

function String2SalesProcess(ASalesProcess:string): TSalesProcess;
var Li: TSalesProcess;
begin
  for Li := spNone to spFinal do
  begin
    if R_SalesProcess[Li].Description = ASalesProcess then
    begin
      Result := R_SalesProcess[Li].Value;
      exit;
    end;
  end;
end;

procedure SalesProcess2Combo(AComboBox:TComboBox);
var
  Li: TSalesProcess;
  i: integer;
begin
  i := AComboBox.ItemIndex;
  AComboBox.Clear;

  for Li := spNone to spFinal do
  begin
    AComboBox.Items.Add(R_SalesProcess[Li].Description);
  end;

  AComboBox.ItemIndex := i;
end;

function SalesProcessType2String(ASalesProcessType:TSalesProcessType) : string;
begin
  if ASalesProcessType <= High(TSalesProcessType) then
    Result := R_SalesProcessType[ASalesProcessType].Description;
end;

function String2SalesProcessType(ASalesProcessType:string): TSalesProcessType;
var Li: TSalesProcessType;
begin
  for Li := sptNone to sptFinal do
  begin
    if R_SalesProcessType[Li].Description = ASalesProcessType then
    begin
      Result := R_SalesProcessType[Li].Value;
      exit;
    end;
  end;
end;

procedure SalesProcessType2Combo(AComboBox:TComboBox);
var Li: TSalesProcessType;
begin
  AComboBox.Clear;

  for Li := sptNone to Pred(sptFinal) do
  begin
    AComboBox.Items.Add(R_SalesProcessType[Li].Description);
  end;
end;

function ContainData4Mail2String(AContainData4Mail:TContainData4Mail) : string;
begin
  if AContainData4Mail <= High(TContainData4Mail) then
    Result := R_ContainData4Mail[AContainData4Mail].Description;
end;

function String2ContainData4Mail(AContainData4Mail:string): TContainData4Mail;
var Li: TContainData4Mail;
begin
  for Li := cdmNone to cdmFinal do
  begin
    if R_ContainData4Mail[Li].Description = AContainData4Mail then
    begin
      Result := R_ContainData4Mail[Li].Value;
      exit;
    end;
  end;
end;

procedure ContainData4Mail2Combo(AComboBox:TComboBox);
var Li: TContainData4Mail;
begin
  AComboBox.Clear;

  for Li := cdmNone to Pred(cdmFinal) do
  begin
    AComboBox.Items.Add(R_ContainData4Mail[Li].Description);
  end;
end;

function ProcessDirection2String(AProcessDirection:TProcessDirection) : string;
begin
  if AProcessDirection <= High(TProcessDirection) then
    Result := R_ProcessDirection[AProcessDirection].Description;
end;

function String2ProcessDirection(AProcessDirection:string): TProcessDirection;
var Li: TProcessDirection;
begin
  for Li := pdNone to pdFinal do
  begin
    if R_ProcessDirection[Li].Description = AProcessDirection then
    begin
      Result := R_ProcessDirection[Li].Value;
      exit;
    end;
  end;
end;

procedure ProcessDirection2Combo(AComboBox:TComboBox);
var Li: TProcessDirection;
begin
  AComboBox.Clear;

  for Li := pdNone to Pred(pdFinal) do
  begin
    AComboBox.Items.Add(R_ProcessDirection[Li].Description);
  end;
end;

procedure SalesProcess2List(AList: TStringList; AFSMState: TFSMState);
var
  LIntArr: TIntegerArray;
  i: integer;
begin
  AList.Clear;
  AList.Add('');
  LIntArr := AFSMState.GetOutputs;

  for i := Low(LIntArr) to High(LIntArr) do
    AList.Add(SalesProcess2String(TSalesProcess(LIntArr[i])));
end;

function GSInvoiceItemType2String(AGSInvoiceItemType: TGSInvoiceItemType) : string;
begin
  if AGSInvoiceItemType <= High(TGSInvoiceItemType) then
    Result := R_GSInvoiceItemType[AGSInvoiceItemType].Description;
end;

function String2GSInvoiceItemType(AGSInvoiceItemType: string): TGSInvoiceItemType;
var Li: TGSInvoiceItemType;
begin
  for Li := iitNull to iitFinal do
  begin
    if R_GSInvoiceItemType[Li].Description = AGSInvoiceItemType then
    begin
      Result := R_GSInvoiceItemType[Li].Value;
      exit;
    end;
  end;
end;

procedure GSInvoiceItemType2Combo(AComboBox: TComboBox);
var Li: TGSInvoiceItemType;
begin
  AComboBox.Clear;

  for Li := iitNull to Pred(iitFinal) do
  begin
    AComboBox.Items.Add(R_GSInvoiceItemType[Li].Description);
  end;
end;

end.
