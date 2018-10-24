unit CommonData;

interface

uses System.Classes, System.SysUtils, System.StrUtils, Outlook2010, Vcl.StdCtrls,
  UnitEnumHelper;

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
    FSubFolder,
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
    FUserName,
    FSavedOLFolderPath: string;
    FMailItem: MailItem;
    FReceiveDate: TDateTime;

    procedure Clear;
  end;

  TOLAccountInfo = record
    SmtpAddress, DisplayName, UserName: string;
  end;

  TSettingInfo = record
    FSalesDirectorEmailAddr,
    FMaterialInputEmailAddr,
    FForeignInputEmailAddr,
    FElecHullRegEmailAddr,
    FShippingReqEmailAddr,
    FFieldServiceReqEmailAddr,
    FSubConPaymentEmailAddr,
    FMyNameSig,
    FShippingPICSig,
    FSalesPICSig,
    FFieldServicePICSig,
    FElecHullRegPICSig,
    FSubConPaymentPICSig
    : string;
  end;

  TTierStep = (tsNull, tsTierI, tsTierII, tsTierIII, tsFinal);
  TTierSteps = set of TTierStep;
                      //
  TElecProductType = (eptNull, eptEB, eptEC, eptEG, eptEM, eptER, eptFinal);
  TElecProductTypes = set of TElecProductType;
  TElecProductDetailType = (epdtNull, epdtACB, epdtVCB, epdtMCCB, epdtHIMAP_BC,
    epdtHIMAP_F, epdtHIMAP_FI, epdtHIMAP_M, epdtHIMAP_T, epdtGenerator,
    epdtBowThruster, epdtMSBD, epdtESBD, epdtACONIS, epdtHiWMS, epdtHiVDR, epdtA2KPMS,
    epdtPMS, epdtBWTS, epdtStarterPanel, epdtFinal);
  TElecProductDetailTypes = set of TElecProductDetailType;

  TCompanyType = (ctNull, ctNewCompany, ctMaker, ctOwner, ctAgent, ctCorporation, ctSubContractor, ctFinal);
  TCompanyTypes = set of TCompanyType;
  TBusinessArea = (baNull, baShip, baEngine, baElectric, baFinal);  //조선,엔진,전기전자
  TBusinessAreas = set of TBusinessArea;
  TCurrencyKind = (ckNone, ckKW, ckUSD, ckEUR);
  TBusinessRegion = (brNone, brSouthEurope, brNorthEurope, brMiddleEast, brGreece,
    brSingapore, brAmerica, brEastSouthAsia, brEastNorthAsia, brFinal);
  TBusinessRegions = set of TBusinessRegion;

const
  R_TierStep : array[Low(TTierStep)..High(TTierStep)] of string =
    ('', 'Tier I', 'Tier II', 'Tier III', '');

  R_ElecProductType : array[eptNull..eptFinal] of record
    Description : string;
    Value       : TElecProductType;
  end = ((Description : '';                 Value : eptNull),
         (Description : '차단기';           Value : eptEB),
         (Description : '선박자동화';       Value : eptEC),
         (Description : '몰드변압기';       Value : eptEG),
         (Description : '배전반';           Value : eptEM),
         (Description : '발전기';           Value : eptER),
         (Description : '';                 Value : eptFinal)
         );

  R_ElecProductDetailType : array[epdtNull..epdtFinal] of record
    Description : string;
    Value       : TElecProductDetailType;
  end = ((Description : '';             Value : epdtNull),
         (Description : 'ACB';          Value : epdtACB),
         (Description : 'VCB';          Value : epdtVCB),
         (Description : 'MCCB';         Value : epdtMCCB),
         (Description : 'HIMAP-BC(G)';  Value : epdtHIMAP_BC),
         (Description : 'HIMAP-F';      Value : epdtHIMAP_F),
         (Description : 'HIMAP-FI';     Value : epdtHIMAP_FI),
         (Description : 'HIMAP-M';      Value : epdtHIMAP_M),
         (Description : 'HIMAP-T';      Value : epdtHIMAP_T),
         (Description : 'Generator';    Value : epdtGenerator),
         (Description : 'Bow Thruster'; Value : epdtBowThruster),
         (Description : 'MSBD';         Value : epdtMSBD),
         (Description : 'ESBD';         Value : epdtESBD),
         (Description : 'ACONIS';       Value : epdtACONIS),
         (Description : 'HiWMS';       Value : epdtHiWMS),
         (Description : 'HiVDR';       Value : epdtHiVDR),
         (Description : 'A2K-PMS';       Value : epdtA2KPMS),
         (Description : 'PMS';       Value : epdtPMS),
         (Description : 'BWTS';       Value : epdtBWTS),
         (Description : 'Starter Panel';       Value : epdtStarterPanel),
         (Description : '';             Value : epdtFinal)
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
         (Description : '협력사';             Value : ctSubContractor),
         (Description : '';                   Value : ctFinal)
         );

  R_BusinessArea : array[baNull..baFinal] of record
    Description : string;
    Value       : TBusinessArea;
  end = ((Description : '';           Value : baNull),
         (Description : '조선';       Value : baShip),
         (Description : '엔진';       Value : baEngine),
         (Description : '전전';       Value : baElectric),
         (Description : '';           Value : baFinal)
         );

  R_CurrencyKind : array[ckNone..ckEUR] of record
    Description : string;
    Value       : TCurrencyKind;
  end = ((Description : '';             Value : ckNone),
         (Description : 'KRW'; Value : ckKW),
         (Description : 'USD'; Value : ckUSD),
         (Description : 'EUR'; Value : ckEUR)
         );

//  gpSHARED_DATA_NAME = 'SharedData_{BCB1C40A-3B72-44FC-9E72-91E5FF498924}';
//  SHARED_DATA_NAME = 'SharedData_{32EF1528-1D5E-48AE-B8AF-341309C303FA}';

//  CONSUME_EVENT_NAME = SHARED_DATA_NAME + '_ConsumeEvent';
//  PRODUCE_EVENT_NAME = SHARED_DATA_NAME + '_ProduceEvent';

  FOLDER_NAME_4_TEMP_MSG_FILES = 'c:\temp\emailmsgs\';
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
  CMD_SEND_MAIL_2_MSGFILE = 'Send Mail To Msg File';

  CMD_RESPONDE_MOVE_FOLDER_MAIL = 'Resonse for Move Mail to Folder';
  CMD_REQ_MAIL_VIEW = 'Request Mail View';
  CMD_REQ_MAIL_VIEW_FROM_MSGFILE = 'Request Mail View From .msg file';
  CMD_REQ_MAILINFO_SEND = 'Request Mail-Info to Send';
  //메일리스트에서 전송, TaskID에 자동으로 들어감
  CMD_REQ_MAILINFO_SEND2 = 'Request Mail-Info to Send2';
  CMD_REQ_MOVE_FOLDER_MAIL = 'Request Move Mail to Folder';
  CMD_REQ_REPLY_MAIL = 'Request Reply Mail';
  CMD_REQ_CREATE_MAIL = 'Request Create Mail';
  CMD_REQ_FORWARD_MAIL = 'Request Forward Mail';
  CMD_REQ_ADD_APPOINTMENT = 'Request Add Appointment';
  //Remote Command
  CMD_REQ_TASK_LIST = 'Request Task List';
  CMD_REQ_TASK_DETAIL = 'Request Task Detail';
  CMD_REQ_TASK_EAMIL_LIST = 'Request Task Email List';
  CMD_REQ_TASK_EAMIL_CONTENT = 'Request Task Email Content';
  CMD_EXECUTE_SAVE_TASK_DETAIL = 'Execute Save Task Detail';
  CMD_REQ_VESSEL_LIST = 'Request Vessel List';

//  SALES_DIRECTOR_EMAIL_ADDR = 'shjeon@hyundai-gs.com';//매출처리담당자
  SALES_DIRECTOR_EMAIL_ADDR = 'seonyunshin@hyundai-gs.com';//매출처리담당자
  MATERIAL_INPUT_EMAIL_ADDR = 'geunhyuk.lim@pantos.com';//자재직투입요청
  FOREIGN_INPUT_EMAIL_ADDR = 'seryeongkim@hyundai-gs.com';//해외고객업체등록
  ELEC_HULL_REG_EMAIL_ADDR = 'seryeongkim@hyundai-gs.com';//전전비표준공사 생성 요청
  PO_REQ_EMAIL_ADDR = 'seryeongkim@hyundai-gs.com';//PO 요청
  SHIPPING_REQ_EMAIL_ADDR = 'yungem.kim@pantos.com';//출하 요청
  FIELDSERVICE_REQ_EMAIL_ADDR = 'yongjunelee@hyundai-gs.com';//필드서비스 팀장

  MY_EMAIL_SIG = '부품서비스2팀 박정현 차장';
  SHIPPING_MANAGER_SIG = '판토스 김윤겸 주임님';
//  SALES_MANAGER_SIG = '부품서비스1팀 전선희 사원님';
  SALES_MANAGER_SIG = '부품서비스2팀 신선윤씨';
  FIELDSERVICE_MANAGER_SIG = '필드서비스팀 이용준 부장님';

  //Task를 Outlook 첨부파일로 만들때 인식하기 위한 문자열
  TASK_JSON_DRAG_SIGNATURE = '{274C083F-EB64-49D8-ADE7-8804CFD0D030}';
  INVOICETASK_JSON_DRAG_SIGNATURE = '{144B4D16-A8E7-4E9A-89C1-994FE6AEC793}';

  REGEX_HULLNO_PATTERN = '^[A-Za-z]{1,4}\d{4}$';
  REGEX_SHIPNAME_PATTERN = '^[A-Za-z]+[A-Za-z0-9]+$';
  REGEX_ORDERNO_PATTERN = '^[A-Za-z]{3}[0-9]{1,7}$';

  QUOTATION_MANAGE_EXE_NAME = 'QuotationManage.exe';

function GetCylCountFromEngineModel(AEngineModel: string): string;
procedure OLMsgFileRecordClear;

//function ShipProductType2String(AShipProductType:TShipProductType) : string;
//function String2ShipProductType(AShipProductType:string): TShipProductType;
//procedure ShipProductType2Combo(AComboBox:TComboBox);
//function EngineProductType2String(AShipProductType:TShipProductType) : string;
//function String2ShipProductType(AShipProductType:string): TShipProductType;
//procedure ShipProductType2Combo(AComboBox:TComboBox);
function ElecProductType2String(AElecProductType:TElecProductType) : string;
function String2ElecProductType(AElecProductType:string): TElecProductType;
procedure ElecProductType2Combo(AComboBox:TComboBox);
function ElecProductDetailType2String(AElecProductDetailType:TElecProductDetailType) : string;
function String2ElecProductDetailType(AElecProductDetailType:string): TElecProductDetailType;
procedure ElecProductDetailType2Combo(AComboBox:TComboBox);
function TElecProductDetailType_SetToInt(ss : TElecProductDetailTypes) : integer;
function IntToTElecProductDetailType_Set(mask : integer) : TElecProductDetailTypes;
function IsInFromInt2TElecProductDetailType(mask : integer; ss: TElecProductDetailType): Boolean;
function IsInFromElecProductDetailTypes2TElecProductDetailType(mask : TElecProductDetailTypes; ss: TElecProductDetailType): Boolean;
function IsInFromElecProductDetailTypes2TElecProductDetailTypes(mask : TElecProductDetailTypes; ss: TElecProductDetailTypes): Boolean;
function GetElecProductDetailTypes2String(AElecProductDetailTypes: TElecProductDetailTypes): string;
function GetElecProductDetailTypesFromCommaString(ACommaStr: string): TElecProductDetailTypes;

//function GSInvoiceItemType2String(AGSInvoiceItemType:TGSInvoiceItemType) : string;
//function String2GSInvoiceItemType(AGSInvoiceItemType:string): TGSInvoiceItemType;
//procedure GSInvoiceItemType2Combo(AComboBox:TComboBox);
function CompanyType2String(ACompanyType:TCompanyType) : string;
function String2CompanyType(ACompanyType:string): TCompanyType;
procedure CompanyType2Combo(AComboBox:TComboBox);
function TCompanyType_SetToInt(ss : TCompanyTypes) : integer;
function IntToTCompanyType_Set(mask : integer) : TCompanyTypes;
function IsInFromInt2TCompanyType(mask : integer; ss: TCompanyType): Boolean;
function IsInFromCompanyTypes2TCompanyType(mask : TCompanyTypes; ss: TCompanyType): Boolean;
function GetCompanyTypes2String(ACompanyTypes: TCompanyTypes): string;
function GetCompanyTypesFromCommaString(ACommaStr:string): TCompanyTypes;
function String2TCompanyType_Set(AStr:string): TCompanyTypes;
function HVCodes2TCompanyType_Set(ASepecialConfig:string): TCompanyTypes;
function GetFirstCompanyTypeIndex(ss: TCompanyTypes) : integer;
function TBusinessArea_SetToInt(ss : TBusinessAreas) : integer;
function IntToTBusinessArea_Set(mask : integer) : TBusinessAreas;
function GetBusinessAreasFromCommaString(ACommaStr:string): TBusinessAreas;
function IsInFromInt2TBusinessArea(mask : integer; ss: TBusinessArea): Boolean;
function IsInFromTBusinessAreas2TBusinessAreas(mask : TBusinessAreas; ss: TBusinessAreas): Boolean;
function GetBusinessAreas2String(ABusinessAreas: TBusinessAreas): string;
function BusinessArea2String(ABusinessArea:TBusinessArea) : string;
function String2BusinessArea(ABusinessArea:string): TBusinessArea;

function CurrencyKind2String(ACurrencyKind:TCurrencyKind) : string;
function String2CurrencyKind(ACurrencyKind:string): TCurrencyKind;
procedure CurrencyKind2Combo(AComboBox:TComboBox);

var
  g_MyEmailInfo: TOLAccountInfo;

  g_TierStep: TLabelledEnum<TTierStep>;

implementation

uses UnitStringUtil;

function GetCylCountFromEngineModel(AEngineModel: string): string;
begin
  Result := '';

  if POS('H', AEngineModel) >= 0 then
  begin
    Result := strToken(AEngineModel, 'H');
  end
  else
  if POS('L', AEngineModel) >= 0 then
  begin
    Result := strToken(AEngineModel, 'L');
  end;
end;

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

//function ShipProductType2String(AShipProductType:TShipProductType) : string;
//begin
//  if AShipProductType <= High(TShipProductType) then
//    Result := R_ShipProductType[AShipProductType].Description;
//end;
//
//function String2ShipProductType(AShipProductType:string): TShipProductType;
//var Li: TShipProductType;
//begin
//  for Li := shptNull to shptFinal do
//  begin
//    if R_ShipProductType[Li].Description = AShipProductType then
//    begin
//      Result := R_ShipProductType[Li].Value;
//      exit;
//    end;
//  end;
//end;
//
//procedure ShipProductType2Combo(AComboBox:TComboBox);
//var Li: TShipProductType;
//begin
//  AComboBox.Clear;
//
//  for Li := shptNull to Pred(shptFinal) do
//  begin
//    AComboBox.Items.Add(R_ShipProductType[Li].Description);
//  end;
//end;

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

function ElecProductDetailType2String(AElecProductDetailType:TElecProductDetailType) : string;
begin
  if AElecProductDetailType <= High(TElecProductDetailType) then
    Result := R_ElecProductDetailType[AElecProductDetailType].Description;
end;

function String2ElecProductDetailType(AElecProductDetailType:string): TElecProductDetailType;
var Li: TElecProductDetailType;
begin
  for Li := epdtNull to epdtFinal do
  begin
    if R_ElecProductDetailType[Li].Description = AElecProductDetailType then
    begin
      Result := R_ElecProductDetailType[Li].Value;
      exit;
    end;
  end;
end;

procedure ElecProductDetailType2Combo(AComboBox:TComboBox);
var Li: TElecProductDetailType;
begin
  AComboBox.Clear;

  for Li := epdtNull to Pred(epdtFinal) do
  begin
    AComboBox.Items.Add(R_ElecProductDetailType[Li].Description);
  end;
end;

function TElecProductDetailType_SetToInt(ss : TElecProductDetailTypes) : integer;
var intset : TIntegerSet;
    s : TElecProductDetailType;
begin
  intSet := [];
  for s in ss do
    include(intSet, ord(s));
  result := integer(intSet);
end;

function IntToTElecProductDetailType_Set(mask : integer) : TElecProductDetailTypes;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);
  result := [];
  for b in intSet do
    include(result, TElecProductDetailType(b));
end;

function IsInFromInt2TElecProductDetailType(mask : integer; ss: TElecProductDetailType): Boolean;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);

  for b in intSet do
  begin
    Result := TElecProductDetailType(b) = ss;

    if Result then
      break;
  end;
end;

function IsInFromElecProductDetailTypes2TElecProductDetailType(mask : TElecProductDetailTypes; ss: TElecProductDetailType): Boolean;
var
  i: integer;
begin
  i := TElecProductDetailType_SetToInt(mask);
  Result := IsInFromInt2TElecProductDetailType(i, ss);
end;

function IsInFromElecProductDetailTypes2TElecProductDetailTypes(mask : TElecProductDetailTypes; ss: TElecProductDetailTypes): Boolean;
var
  intSet : TIntegerSet;
  b : byte;
  LBa, LBa2: TElecProductDetailType;
begin
  Result := False;

  for LBa in ss do
  begin
    for LBa2 in mask do
    begin
      Result := LBa2 = LBa;

      if Result then
        exit;
    end;
  end;
end;

function GetElecProductDetailTypes2String(AElecProductDetailTypes: TElecProductDetailTypes): string;
var
  LCt: TElecProductDetailType;
begin
  Result := '';

  for LCt in AElecProductDetailTypes do
  begin
    Result := Result + ElecProductDetailType2String(LCt) + ',';
  end;

  Delete(Result, Length(Result), 1); //마지막 ';' 삭제
end;

function GetElecProductDetailTypesFromCommaString(ACommaStr: string): TElecProductDetailTypes;
var
  LStrList: TStringList;
  LElecProductDetailType: TElecProductDetailType;
  i: integer;
begin
  Result := [];
  LStrList := TStringList.Create;
  try
    LStrList.CommaText := ACommaStr;

    for i := 0 to LStrList.Count - 1 do
    begin
      LElecProductDetailType := String2ElecProductDetailType(LStrList.Strings[i]);
      Result := Result + [LElecProductDetailType];
    end;
  finally
    LStrList.Free;
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

function TCompanyType_SetToInt(ss : TCompanyTypes) : integer;
var intset : TIntegerSet;
    s : TCompanyType;
begin
  intSet := [];
  for s in ss do
    include(intSet, ord(s));
  result := integer(intSet);
end;

function IntToTCompanyType_Set(mask : integer) : TCompanyTypes;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);
  result := [];
  for b in intSet do
    include(result, TCompanyType(b));
end;

function IsInFromInt2TCompanyType(mask : integer; ss: TCompanyType): Boolean;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);

  for b in intSet do
  begin
    Result := TCompanyType(b) = ss;

    if Result then
      break;
  end;
end;

function IsInFromCompanyTypes2TCompanyType(mask : TCompanyTypes; ss: TCompanyType): Boolean;
var
  i: integer;
begin
  i := TCompanyType_SetToInt(mask);
  Result := IsInFromInt2TCompanyType(i, ss);
end;

function GetCompanyTypes2String(ACompanyTypes: TCompanyTypes): string;
var
  LCt: TCompanyType;
begin
  Result := '';

  for LCt in ACompanyTypes do
  begin
    Result := Result + CompanyType2String(LCt) + ';';
  end;

  Delete(Result, Length(Result), 1); //마지막 ';' 삭제
end;

function GetCompanyTypesFromCommaString(ACommaStr:string): TCompanyTypes;
var
  LStrList: TStringList;
  LCompanyType: TCompanyType;
  i: integer;
begin
  Result := [];
  LStrList := TStringList.Create;
  try
    ACommaStr := StringReplace(ACommaStr, ';', ',',  [rfReplaceAll]);
    LStrList.CommaText := ACommaStr;

    for i := 0 to LStrList.Count - 1 do
    begin
      LCompanyType := String2CompanyType(LStrList.Strings[i]);
      Result := Result + [LCompanyType];
    end;
  finally
    LStrList.Free;
  end;
end;

function String2TCompanyType_Set(AStr:string): TCompanyTypes;
var
  LStr:string;
begin
  Result := [];

  while true do
  begin
    if AStr = '' then
      break;

    LStr := StrToken(AStr, ';');
    Result := Result + [String2CompanyType(LStr)];
  end;
end;

function HVCodes2TCompanyType_Set(ASepecialConfig:string): TCompanyTypes;
var
  LStr: string;
  i: integer;
begin
  Result := [];

  for i := 1 to Length(ASepecialConfig) do
  begin
    LStr := LeftStr(ASepecialConfig, i);
    if LStr <> '' then
    begin
      System.Delete(ASepecialConfig, 1, 1);
//      Result := Result + [HVCode2CompanyType(LStr)];
    end;
  end;
end;

function GetFirstCompanyTypeIndex(ss: TCompanyTypes) : integer;
var s : TCompanyType;
begin
  for s in ss do
  begin
    result := ord(s);
    break;
  end;
end;

function TBusinessArea_SetToInt(ss : TBusinessAreas) : integer;
var intset : TIntegerSet;
    s : TBusinessArea;
begin
//  intSet := [];
//  for s in ss do
//    include(intSet, ord(s));
//  result := integer(intSet);
  Result := SetToInt(ss, SizeOf(ss));
end;

function IntToTBusinessArea_Set(mask : integer) : TBusinessAreas;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);
  result := [];
  for b in intSet do
    include(result, TBusinessArea(b));
end;

function GetBusinessAreasFromCommaString(ACommaStr:string): TBusinessAreas;
var
  LStrList: TStringList;
  LBusinessArea: TBusinessArea;
  i: integer;
begin
  Result := [];
  LStrList := TStringList.Create;
  try
    ACommaStr := StringReplace(ACommaStr, ';', ',',  [rfReplaceAll]);
    LStrList.CommaText := ACommaStr;

    for i := 0 to LStrList.Count - 1 do
    begin
      LBusinessArea := String2BusinessArea(LStrList.Strings[i]);
      Result := Result + [LBusinessArea];
    end;
  finally
    LStrList.Free;
  end;
end;

//mask안에 ss가 포함 되는지 확인
function IsInFromInt2TBusinessArea(mask : integer; ss: TBusinessArea): Boolean;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);

  for b in intSet do
  begin
    Result := TBusinessArea(b) = ss;

    if Result then
      break;
  end;
end;

//mask: DB의 내용, ss: 검색창에서 선택한 내용
function IsInFromTBusinessAreas2TBusinessAreas(mask : TBusinessAreas; ss: TBusinessAreas): Boolean;
var
  intSet : TIntegerSet;
  b : byte;
  LBa, LBa2: TBusinessArea;
begin
//  i := TBusinessArea_SetToInt(mask);
//  intSet := TIntegerSet(i);

  Result := False;

  for LBa in ss do
  begin
    for LBa2 in mask do
    begin
      Result := LBa2 = LBa;

      if Result then
        exit;
    end;
  end;
end;

function GetBusinessAreas2String(ABusinessAreas: TBusinessAreas): string;
var
  LBa: TBusinessArea;
begin
  Result := '';
//  i := TBusinessArea_SetToInt(mask);
//  intSet := TIntegerSet(i);
  for LBa in ABusinessAreas do
  begin
    Result := Result + BusinessArea2String(LBa) + ',';
  end;

  Delete(Result, Length(Result), 1); //마지막 ',' 삭제
end;

function BusinessArea2String(ABusinessArea:TBusinessArea) : string;
begin
  if ABusinessArea <= High(TBusinessArea) then
    Result := R_BusinessArea[ABusinessArea].Description;
end;

function String2BusinessArea(ABusinessArea:string): TBusinessArea;
var Li: TBusinessArea;
begin
  for Li := baNull to baFinal do
  begin
    if R_BusinessArea[Li].Description = ABusinessArea then
    begin
      Result := R_BusinessArea[Li].Value;
      exit;
    end;
  end;
end;

//function GSInvoiceItemType2String(AGSInvoiceItemType: TGSInvoiceItemType) : string;
//begin
//  if AGSInvoiceItemType <= High(TGSInvoiceItemType) then
//    Result := R_GSInvoiceItemType[AGSInvoiceItemType].Description;
//end;
//
//function String2GSInvoiceItemType(AGSInvoiceItemType: string): TGSInvoiceItemType;
//var Li: TGSInvoiceItemType;
//begin
//  for Li := iitNull to iitFinal do
//  begin
//    if R_GSInvoiceItemType[Li].Description = AGSInvoiceItemType then
//    begin
//      Result := R_GSInvoiceItemType[Li].Value;
//      exit;
//    end;
//  end;
//end;
//
//procedure GSInvoiceItemType2Combo(AComboBox: TComboBox);
//var Li: TGSInvoiceItemType;
//begin
//  AComboBox.Clear;
//
//  for Li := iitNull to Pred(iitFinal) do
//  begin
//    AComboBox.Items.Add(R_GSInvoiceItemType[Li].Description);
//  end;
//end;

function CurrencyKind2String(ACurrencyKind:TCurrencyKind) : string;
begin
  if ACurrencyKind <= High(TCurrencyKind) then
    Result := R_CurrencyKind[ACurrencyKind].Description;
end;

function String2CurrencyKind(ACurrencyKind:string): TCurrencyKind;
var Li: TCurrencyKind;
begin
  for Li := ckNone to ckEUR do
  begin
    if R_CurrencyKind[Li].Description = ACurrencyKind then
    begin
      Result := R_CurrencyKind[Li].Value;
      exit;
    end;
  end;
end;

procedure CurrencyKind2Combo(AComboBox:TComboBox);
var Li: TCurrencyKind;
begin
  AComboBox.Clear;

  for Li := ckNone to ckEUR do
  begin
    AComboBox.Items.Add(R_CurrencyKind[Li].Description);
  end;
end;

initialization
  g_TierStep.InitArrayRecord(R_TierStep);

end.
