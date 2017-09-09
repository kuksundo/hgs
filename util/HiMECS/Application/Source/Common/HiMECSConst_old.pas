unit HiMECSConst;

interface

uses Windows, Classes, StdCtrls;

type
  TpjhArrayHandle = array of THandle;

  //User Level 순서를 절대 바꾸면 안됨.
  THiMECSUserLevel = (HUL_Developer, HUL_Administrator, HUL_Expert, HUL_Operator);
  THiMECSUserCategory = (HC_Product_Engineer);

  TMessageSaveType = (mstNoSave, mstFile, mstDB);
  TMessageType = (mtError, mtInformation, mtAlarm, mtFault, mtShutdown);

  TSortMethod = (smSystem, smSensor);
  TSensorType = (stmA, stRTD, stTC, stPickup, stDI, stDO, stConfig, stCalculated);
  TParameterType = (ptDefault, ptAnalog, ptDigital, ptBool,
    ptMatrix1, ptMatrix2, ptMatrix3, ptMatrix1f, ptMatrix2f, ptMatrix3f);
  TParameterCatetory = (pcReadyToStart, pcEngineShutdown, pcEngineStatus, pcSpeed,
                      pcLOSystem, pcFOSystem, pcCWSystem, pcExhSystem, pcCAirSystem,
                      pcMainBearing, pcEtc, pcCombustionSystem, pcControlSystem,
                      pcEngineStructure, pcKnocking, pcIgnition, pcInjection, pcGenerator,
                      pcGasSystem, pcAlarmSystem);
  TParameterSource = (psECS_kumo, psECS_AVAT, psMT210, psMEXA7000, psLBX, psFlowMeter,//psECS_kumo=ACS
                      psDynamo ,psWT1600, psGasCalculated, psManualInput,
                      psECS_Woodward, psFlowMeterKral, psPLC_S7, psEngineParam, //psPLC_S7=Simens PLC MPI Protocol(NoDave.dll), psECS_Woodward= Modbus Standard
                      psHIC, psUnKnown, psPLC_Modbus,//psPLC_Modbus=03표준,Binary는 03으로 읽어와서 처리함
                      psPMSOPC);
  TNodeCatetory = (ncGroup, ncCategory);
  TTrendDataType = (tdtValue, tdtAlarm, tdtFault);

  TAxis = (aX, aY, aZ);
  TValueType = (mmtInteger, mmtReal);
  TpjhWindowState = (pwsNormal, pwsMinimized, pwsMaximized);
  TDragDropDataType = (dddtSingleRecord, dddtMultiRecord);

  TS7Area = (S7ASystemInfo,S7ASystemFlags,S7AanalogInputs,S7AanalogOutputs,
            S7AInputs,S7AOutputs,S7AFlags,S7ADatablock,S7AInstanceData,
            S7ALocalData,S7AunknownArea,S7ACounter,S7ATimer,S7APEW_PAW);
  TS7DataType = (S7DTByte,S7DTWord,S7DTInt,S7DTDWord,S7DTDInt,S7DTReal);

  TAlarmPriority = (apCritical, apWarning, apAdvisory, apLog);

  RDragFormatParam = record
    FCollectIndex: string;
  end;

  PDoublePoint = ^TDoublePoint;
  TDoublePoint = class(TObject)
    X: Double;
    Y: Double;
  end;

  TXYGraphInfo = class(TObject)
    FTagname: string;
    FAxis: TAxis;
    FParameterIndex: integer;
    //FConstant: double; //상수값을 그래프에 입력할 때 사용
    FUseConstant: boolean;  //상수값을 사용하면 True
    FIsDuplicated: boolean;
  end;

  PAlarmListRecord = ^TAlarmListRecord;
  TAlarmListRecord = class(TObject)
    FDBRowIndex: integer;
    FTagName: string[10];
    FValue: string[10];
    FAlarmDesc: string[100];
  end;

  TMatrixInteger = packed record
    Value: integer;
  end;
  TMatrixIArray = array of TMatrixInteger;

  TMatrixFloat = packed record
    Value: single;
  end;
  TMatrixFArray = array of TMatrixFloat;

  TMatrixData<T> = packed record
    Value: T;
  end;
  TMatrixArray<T> = array of TMatrixData<T>;

const
  cParameter      = 0;
  cClosedPage     = 1;
  cOpenPage       = 2;
  cClosedBook     = 3;
  cOpenBook       = 4;
  cDateValue      = 5;
  cStringValue    = 6;
  cBinaryValue    = 7;
  cAddBookmark    = 10;
  cRemoveBookmark = 11;

  USERLEVELCOUNT = integer(High(THiMECSUserLevel))+1;
  R_HiMECSUserLevel : array[0..USERLEVELCOUNT-1] of record
    Description : string;
    Value       : THiMECSUserLevel;
  end = ((Description : 'Developer';         Value : HUL_Developer),
         (Description : 'Administrator';     Value : HUL_Administrator),
         (Description : 'Expert';            Value : HUL_Expert),
         (Description : 'Operator';          Value : HUL_Operator));

  USERCATEGORYCOUNT = integer(High(THiMECSUserCategory))+1;
  R_USERCATEGORY : array[0..USERCATEGORYCOUNT-1] of record
    Description : string;
    Value       : THiMECSUserCategory;
  end = ((Description : 'Product Engineer';         Value : HC_Product_Engineer));

  SensorTypeCOUNT = integer(High(TSensorType))+1;
  R_SensorType : array[0..SensorTypeCOUNT-1] of record
    Description : string;
    Value       : TSensorType;
  end = ((Description : 'mA';             Value : stmA),
         (Description : 'RTD';            Value : stRTD),
         (Description : 'ThermoCouple';   Value : stTC),
         (Description : 'Pickup';         Value : stPickup),
         (Description : 'DI';  Value : stDI),
         (Description : 'DO'; Value : stDO),
         (Description : 'Config'; Value : stConfig),
         (Description : 'Calculated'; Value : stCalculated));

  ParameterTypeCOUNT = integer(High(TParameterType))+1;
  R_ParameterType : array[0..ParameterTypeCOUNT-1] of record
    Description : string;
    Value       : TParameterType;
  end = ((Description : 'Default';        Value : ptDefault),
         (Description : 'Analog';         Value : ptAnalog),
         (Description : 'Digital';        Value : ptDigital),
         (Description : 'Boolean';        Value : ptBool),
         (Description : 'Matrix1';        Value : ptMatrix1),
         (Description : 'Matrix2';        Value : ptMatrix2),
         (Description : 'Matrix3';        Value : ptMatrix3),
         (Description : 'Matrix1f';        Value : ptMatrix1f),
         (Description : 'Matrix2f';        Value : ptMatrix2f),
         (Description : 'Matrix3f';        Value : ptMatrix3f));

  ParameterCatetoryCOUNT = integer(High(TParameterCatetory))+1;
  R_ParameterCatetory : array[0..ParameterCatetoryCOUNT-1] of record
    Description : string;
    Value       : TParameterCatetory;
  end = ((Description : 'Ready To Start';       Value : pcReadyToStart),
         (Description : 'Engine Shutdown';      Value : pcEngineShutdown),
         (Description : 'Engine Status';        Value : pcEngineStatus),
         (Description : 'Speed';                Value : pcSpeed),
         (Description : 'L.O. System';          Value : pcLOSystem),
         (Description : 'F.O. System';          Value : pcFOSystem),
         (Description : 'Cooling Water System'; Value : pcCWSystem),
         (Description : 'Exh. System';          Value : pcExhSystem),
         (Description : 'Charge Air System';    Value : pcCAirSystem),
         (Description : 'Main Bearing';         Value : pcMainBearing),
         (Description : 'Etc.';                 Value : pcEtc),
         (Description : 'Combustion System';    Value : pcCombustionSystem),
         (Description : 'Control System';       Value : pcControlSystem),
         (Description : 'Engine Structure';     Value : pcEngineStructure),
         (Description : 'Knocking System';      Value : pcKnocking),
         (Description : 'Ignition System';   Value : pcIgnition),
         (Description : 'Injection System';   Value : pcInjection),
         (Description : 'Generator';   Value : pcGenerator),
         (Description : 'Gas System';   Value : pcGasSystem),
         (Description : 'Alarm System';   Value : pcAlarmSystem));

  ParameterSourceCOUNT = integer(High(TParameterSource))+1;
  R_ParameterSource : array[0..ParameterSourceCOUNT-1] of record
    Description : string;
    Value       : TParameterSource;
    SharedMemName: string;
  end = ((Description : 'ECS by kumo'; Value : psECS_kumo; SharedMemName:'ModBusCom_kumo'),
         (Description : 'ECS by AVAT'; Value : psECS_AVAT; SharedMemName:'ModBusCom_Avat'),
         (Description : 'MT210';       Value : psMT210; SharedMemName:'MT210'),
         (Description : 'MEXA7000';    Value : psMEXA7000; SharedMemName:'MEXA7000'),
         (Description : 'LBX';         Value : psLBX; SharedMemName:'LBX'),
         (Description : 'FlowMeter';   Value : psFlowMeter; SharedMemName:'FlowMeter'),
         (Description : 'DynamoMeter';   Value : psDynamo; SharedMemName:'DynamoMeter'),
         (Description : 'WT1600';      Value : psWT1600; SharedMemName:'WT1600'),
         (Description : 'Gas Calculated';Value : psGasCalculated; SharedMemName:'Gas_Total'),
         (Description : 'Manual Input';Value : psManualInput; SharedMemName:'Manual_Input'),
         (Description : 'ECS by Woodward';Value : psECS_Woodward; SharedMemName:'ModBus_Woodward'),
         (Description : 'KRAL';Value : psFlowMeterKral; SharedMemName:'KRAL'),
         (Description : 'S7 Siemens PLC';Value : psPLC_S7; SharedMemName:'PLC_S7'),
         //Parameter File을 읽어서 데이터 전송함
         (Description : 'Engine Parameter';Value : psEngineParam; SharedMemName:'EngineParam'),
         (Description : 'Hybrid Injector';Value : psHIC; SharedMemName:'HIC'),
         (Description : 'UnKnown Parameter Source';Value : psUnKnown; SharedMemName:'UnKnown_Parameter_Source'),
         (Description : 'PLC Modbus';Value : psPLC_Modbus; SharedMemName:'PLC_Modbus'),
         (Description : 'PMS OPC';Value : psPMSOPC; SharedMemName:'PMSOPC')
         );

  S7AreaCOUNT = integer(High(TS7Area))+1;
  R_S7Area : array[0..S7AreaCOUNT-1] of record
    Description : string;
    Value       : TS7Area;
  end = ((Description : 'System Info';            Value : S7ASystemInfo),
         (Description : 'System Flags';           Value : S7ASystemFlags),
         (Description : 'Analog Inputs(CPU 200)'; Value : S7AanalogInputs),
         (Description : 'Analog Outputs(CPU 200)';Value : S7AanalogOutputs),
         (Description : 'Inputs';                 Value : S7AInputs),
         (Description : 'Outputs';                Value : S7AOutputs),
         (Description : 'Flags';                  Value : S7AFlags),
         (Description : 'Data Block';             Value : S7ADatablock),
         (Description : 'Instance Data';          Value : S7AInstanceData),
         (Description : 'Local Data';             Value : S7ALocalData),
         (Description : 'Unknown Area';           Value : S7AunknownArea),
         (Description : 'Counter';                Value : S7ACounter),
         (Description : 'Timer';                  Value : S7ATimer),
         (Description : 'PEW_PAW';                Value : S7APEW_PAW));

  S7DataTypeCOUNT = integer(High(TS7DataType))+1;
  R_S7DataType : array[0..S7DataTypeCOUNT-1] of record
    Description : string;
    Value       : TS7DataType;
  end = ((Description : 'Byte';             Value : S7DTByte),
         (Description : 'Word';            Value : S7DTWord),
         (Description : 'Int';   Value : S7DTInt),
         (Description : 'DWord';         Value : S7DTDWord),
         (Description : 'DInt';  Value : S7DTDInt),
         (Description : 'Real'; Value : S7DTReal));

  AlarmPriorityCOUNT = integer(High(TAlarmPriority))+1;
  R_AlarmPriority : array[0..AlarmPriorityCOUNT-1] of record
    Description : string;
    Value       : TAlarmPriority;
  end = ((Description : 'Critical';   Value : apCritical),
         (Description : 'Warning';   Value : apWarning),
         (Description : 'Advisory';    Value : apAdvisory),
         (Description : 'Log';  Value : apLog));

  DefaultEncryption = False;
  DefaultMenuEncryption = True;
  DefaultOptionsFileName = 'DefaultHiMECS.option';
  DefaultMenFileNameOnLogOut = 'DefaultHiMECSOnLogOut.menu'; //로그아웃 상태시 메뉴
  DefaultMenFileNameOnLogIn = 'DefaultHiMECSOnLogIn.menu'; //로그인 상태시 메뉴
  DefaultPassPhrase = 'DefaultPassPhrase';
  DefaultFormsFileName = 'DefaultHiMECS.form';
  DefaultExesFileName = 'DefaultHiMECS.app';
  DefaultUserFileName = 'DefaultHiMECS.user';
  DefaultAlarmListConfigFileName = 'DefaultAlarmList.config';

  HiMECSWatchName = 'HiMECS_Watchp.exe';
  HiMECSWatchName2 = 'HiMECS_Watch2p.exe';
  AlarmListMode = '/mAlarmList';
  HiMECSWatchSaveName = 'HiMECS_WatchSavep.exe';
  HiMECSExcelRangeName = '.\SetCellPos.exe';
  WatchListPath = '..\WatchList\';
  HiMECSCommLauncher = 'Applications\HiMECS_COMM_LAUNCHER.exe';
  HiMECSMonitorLauncher = 'Applications\HiMECS_MON_LAUNCHER.exe';
  HiMECSAutoUpdateName = 'Applications\AutoUpdate.exe';
  HiMECSOptionAppName = 'Applications\HiMECSConfig.exe';

  // Name of our custom clipboard format.
  sDragFormatParam = 'DragFormatParam';

  HiMECS_HOME_PATH = 'E:\pjh\project\util\HiMECS\Application\Bin\';
  HIMECS_CROMIS_SERVER_NAME = 'HIMECS_CROMIS_SERVER_NAME';

  TMatrixTypes = [ptMatrix1, ptMatrix2, ptMatrix3, ptMatrix1f, ptMatrix2f, ptMatrix3f];

  function UserLevel2String(AUserLevel:THiMECSUserLevel) : string;
  function String2UserLevel(AUserLevel:string): THiMECSUserLevel;
  procedure UserLevel2Strings(AStrings: TStrings);
  procedure UserLevel2Combo(AComboBox:TComboBox);

  function UserCategory2String(ACategory:THiMECSUserCategory) : string;
  function String2UserCategory(ACategory:string): THiMECSUserCategory;
  procedure UserCatetory2Strings(AStrings: TStrings);
  procedure UserCategory2Combo(AComboBox:TComboBox);

  function ParameterType2String(AParameterType:TParameterType) : string;
  function String2ParameterType(AParameterType:string): TParameterType;
  procedure ParameterType2Combo(AComboBox:TComboBox);
  procedure ParameterType2Strings(AStrings: TStrings);

  function SensorType2String(ASensorType:TSensorType) : string;
  function String2SensorType(ASensorType:string): TSensorType;
  procedure SensorType2Combo(AComboBox:TComboBox);
  procedure SensorType2Strings(AStrings: TStrings);

  function ParameterCatetory2String(AParameterCatetory:TParameterCatetory) : string;
  function String2ParameterCatetory(AParameterCatetory:string): TParameterCatetory;
  procedure ParameterCatetory2Combo(AComboBox:TComboBox);
  procedure ParameterCatetory2Strings(AStrings: TStrings);

  function ParameterSource2String(AParameterSource:TParameterSource) : string;
  function String2ParameterSource(AParameterSource:string): TParameterSource;
  function ParameterSource2SharedMN(AParameterSource:TParameterSource) : string;
  procedure ParameterSource2Combo(AComboBox:TComboBox);
  procedure ParameterSource2Strings(AStrings: TStrings);
  procedure SharedName2Combo(AComboBox:TComboBox);
  function SharedName2ParameterSource(ASharedName: string): TParameterSource;

  function S7Area2String(AS7Area:TS7Area) : string;
  function String2S7Area(AS7Area:string): TS7Area;
  procedure S7Area2Strings(AStrings: TStrings);

  function S7DataType2String(AS7DataType:TS7DataType) : string;
  function String2S7DataType(AS7DataType:string): TS7DataType;
  procedure S7DataType2Strings(AStrings: TStrings);

  function GetDataSize(AS7DataType:TS7DataType): integer;

  function ArarmPriority2String(AAlarmPriority:TAlarmPriority) : string;
  function String2ArarmPriority(AAlarmPriority:string): TAlarmPriority;
implementation

function UserLevel2String(AUserLevel:THiMECSUserLevel) : string;
begin
  if AUserLevel < High(THiMECSUserlevel) then
    Result := R_HiMECSUserLevel[ord(AUserLevel)].Description;
end;

function String2UserLevel(AUserLevel:string): THiMECSUserLevel;
var Li: integer;
begin
  for Li := 0 to USERLEVELCOUNT - 1 do
  begin
    if R_HiMECSUserLevel[Li].Description = AUserLevel then
    begin
      Result := R_HiMECSUserLevel[Li].Value;
      exit;
    end;
  end;
end;

function UserCategory2String(ACategory:THiMECSUserCategory) : string;
begin
  Result := R_USERCATEGORY[ord(ACategory)].Description;
end;

function String2UserCategory(ACategory:string): THiMECSUserCategory;
var Li: integer;
begin
  for Li := 0 to USERCATEGORYCOUNT - 1 do
  begin
    if R_USERCATEGORY[Li].Description = ACategory then
    begin
      Result := R_USERCATEGORY[Li].Value;
      exit;
    end;
  end;
end;

function ParameterType2String(AParameterType:TParameterType) : string;
begin
  Result := R_ParameterType[ord(AParameterType)].Description;
end;

function String2ParameterType(AParameterType:string): TParameterType;
var Li: integer;
begin
  for Li := 0 to ParameterTypeCOUNT - 1 do
  begin
    if R_ParameterType[Li].Description = AParameterType then
    begin
      Result := R_ParameterType[Li].Value;
      exit;
    end;
  end;
end;

function SensorType2String(ASensorType:TSensorType) : string;
begin
  Result := R_SensorType[ord(ASensorType)].Description;
end;

function String2SensorType(ASensorType:string): TSensorType;
var Li: integer;
begin
  for Li := 0 to SensorTypeCOUNT - 1 do
  begin
    if R_SensorType[Li].Description = ASensorType then
    begin
      Result := R_SensorType[Li].Value;
      exit;
    end;
  end;
end;

function ParameterCatetory2String(AParameterCatetory:TParameterCatetory) : string;
begin
  Result := R_ParameterCatetory[ord(AParameterCatetory)].Description;
end;

function String2ParameterCatetory(AParameterCatetory:string): TParameterCatetory;
var Li: integer;
begin
  for Li := 0 to ParameterCatetoryCOUNT - 1 do
  begin
    if R_ParameterCatetory[Li].Description = AParameterCatetory then
    begin
      Result := R_ParameterCatetory[Li].Value;
      exit;
    end;
  end;
end;

procedure UserLevel2Strings(AStrings: TStrings);
var Li: integer;
begin
  for Li := 0 to USERLEVELCOUNT - 1 do
    AStrings.Add(R_HiMECSUserLevel[Li].Description);
end;

procedure UserLevel2Combo(AComboBox:TComboBox);
var Li: integer;
begin
  for Li := 0 to USERLEVELCOUNT - 1 do
  begin
    AComboBox.Items.Add(R_HiMECSUserLevel[Li].Description);
  end;
end;

procedure UserCatetory2Strings(AStrings: TStrings);
var Li: integer;
begin
  for Li := 0 to USERCATEGORYCOUNT - 1 do
    AStrings.Add(R_USERCATEGORY[Li].Description);
end;

procedure UserCategory2Combo(AComboBox:TComboBox);
var Li: integer;
begin
  for Li := 0 to USERCATEGORYCOUNT - 1 do
  begin
    AComboBox.Items.Add(R_USERCATEGORY[Li].Description);
  end;
end;

function ParameterSource2String(AParameterSource:TParameterSource) : string;
begin
  Result := R_ParameterSource[ord(AParameterSource)].Description;
end;

function String2ParameterSource(AParameterSource:string): TParameterSource;
var Li: integer;
begin
  for Li := 0 to ParameterSourceCOUNT - 1 do
  begin
    if R_ParameterSource[Li].Description = AParameterSource then
    begin
      Result := R_ParameterSource[Li].Value;
      exit;
    end;
  end;
end;

function ParameterSource2SharedMN(AParameterSource:TParameterSource) : string;
begin
  Result := R_ParameterSource[ord(AParameterSource)].SharedMemName;
end;

procedure ParameterType2Combo(AComboBox:TComboBox);
var Li: integer;
begin
  for Li := 0 to ParameterTypeCOUNT - 1 do
  begin
    AComboBox.Items.Add(R_ParameterType[Li].Description);
  end;
end;

procedure SensorType2Combo(AComboBox:TComboBox);
var Li: integer;
begin
  for Li := 0 to SensorTypeCOUNT - 1 do
  begin
    AComboBox.Items.Add(R_SensorType[Li].Description);
  end;
end;

procedure ParameterSource2Combo(AComboBox:TComboBox);
var Li: integer;
begin
  for Li := 0 to ParameterSourceCOUNT - 1 do
  begin
    AComboBox.Items.Add(R_ParameterSource[Li].Description);
  end;
end;

procedure SharedName2Combo(AComboBox:TComboBox);
var Li: integer;
begin
  for Li := 0 to ParameterSourceCOUNT - 1 do
  begin
    AComboBox.Items.Add(R_ParameterSource[Li].SharedMemName);
  end;
end;

function SharedName2ParameterSource(ASharedName: string): TParameterSource;
var Li: integer;
begin
  for Li := 0 to ParameterSourceCOUNT - 1 do
  begin
    if R_ParameterSource[Li].SharedMemName = ASharedName then
    begin
      Result := R_ParameterSource[Li].Value;
      exit;
    end;
  end;

  Result := psUnKnown; //Unknown
end;

procedure ParameterCatetory2Combo(AComboBox:TComboBox);
var Li: integer;
begin
  for Li := 0 to ParameterCatetoryCOUNT - 1 do
  begin
    AComboBox.Items.Add(R_ParameterCatetory[Li].Description);
  end;
end;

procedure ParameterType2Strings(AStrings: TStrings);
var Li: integer;
begin
  for Li := 0 to ParameterTypeCOUNT - 1 do
  begin
    AStrings.Add(R_ParameterType[Li].Description);
  end;
end;

procedure SensorType2Strings(AStrings: TStrings);
var Li: integer;
begin
  for Li := 0 to SensorTypeCOUNT - 1 do
  begin
    AStrings.Add(R_SensorType[Li].Description);
  end;
end;

procedure ParameterSource2Strings(AStrings: TStrings);
var Li: integer;
begin
  for Li := 0 to ParameterSourceCOUNT - 1 do
  begin
    AStrings.Add(R_ParameterSource[Li].Description);
  end;
end;

procedure ParameterCatetory2Strings(AStrings: TStrings);
var Li: integer;
begin
  for Li := 0 to ParameterCatetoryCOUNT - 1 do
  begin
    AStrings.Add(R_ParameterCatetory[Li].Description);
  end;
end;

function S7Area2String(AS7Area:TS7Area) : string;
begin
  Result := R_S7Area[ord(AS7Area)].Description;
end;

function String2S7Area(AS7Area:string): TS7Area;
var Li: integer;
begin
  for Li := 0 to S7AreaCOUNT - 1 do
  begin
    if R_S7Area[Li].Description = AS7Area then
    begin
      Result := R_S7Area[Li].Value;
      exit;
    end;
  end;
end;

procedure S7Area2Strings(AStrings: TStrings);
var Li: integer;
begin
  for Li := 0 to S7AreaCOUNT - 1 do
  begin
    AStrings.Add(R_S7Area[Li].Description);
  end;
end;

function S7DataType2String(AS7DataType:TS7DataType) : string;
begin
  Result := R_S7DataType[ord(AS7DataType)].Description;
end;

function String2S7DataType(AS7DataType:string): TS7DataType;
var Li: integer;
begin
  for Li := 0 to S7DataTypeCOUNT - 1 do
  begin
    if R_S7DataType[Li].Description = AS7DataType then
    begin
      Result := R_S7DataType[Li].Value;
      exit;
    end;
  end;
end;

procedure S7DataType2Strings(AStrings: TStrings);
var Li: integer;
begin
  for Li := 0 to S7DataTypeCOUNT - 1 do
  begin
    AStrings.Add(R_S7DataType[Li].Description);
  end;
end;

function GetDataSize(AS7DataType:TS7DataType): integer;
begin
  Case AS7DataType of
    S7DTByte: Result := 1;
    S7DTWord: Result := 2;
    S7DTInt: Result := 2;
    S7DTDWord: Result := 4;
    S7DTDInt: Result := 4;
    S7DTReal: Result := 4;
  End;
end;

function ArarmPriority2String(AAlarmPriority:TAlarmPriority) : string;
begin
  Result := R_AlarmPriority[ord(AAlarmPriority)].Description;
end;

function String2ArarmPriority(AAlarmPriority:string): TAlarmPriority;
var Li: integer;
begin
  for Li := 0 to AlarmPriorityCOUNT - 1 do
  begin
    if R_AlarmPriority[Li].Description = AAlarmPriority then
    begin
      Result := R_AlarmPriority[Li].Value;
      exit;
    end;
  end;
end;

end.

