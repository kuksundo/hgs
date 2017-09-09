unit IPC_Modbus_Standard_Const;

interface

uses SynCommons;

type
  PEventData_Modbus_Standard = ^TEventData_Modbus_Standard;
  TEventData_Modbus_Standard = packed record
    InpDataBuf: array[0..255] of integer;
    InpDataBuf2: array[0..255] of Byte;
    InpDataBuf_double: array[0..1000] of double;
    NumOfData: integer;//데이타 갯수 반납
    NumOfBit: integer;//Bit 갯수 반납(01 function 일 경우 Bit 단위로 전달되기 때문임)
    //Block Mode 일경우 Modbus Block Start Address,
    //Individual Mode일경우 Modbus Address
    ModBusFunctionCode: integer;
    ModBusAddress: string[5];//String 변수는 공유메모리에 사용 불가함
    //ModBusAddress: array[0..19] of char;//String 변수는 공유메모리에 사용 불가함
    //ASCII Mode = 0, RTU Mode = 1, RTU mode simulation = 3;
    ModBusMode: integer;
    //ModBusComConst의 TCommMode 가 integer로 저장됨
    //TCommMode = (CM_DATA_READ, CM_CONFIG_READ, CM_DATA_WRITE, CM_CONFIG_WRITE, CM_CONFIG_WRITE_CONFIRM)
    DataMode: integer;
    //2: ptAnalog, 4: ptMatrix1, 5: ptMatrix2, 6: ptMatrix3, 7: ptMatrix1f...
    ParameterType: integer;
    BlockNo: integer;
    //9999: 정상,
    ErrorCode: integer;
    ModBusMapFileName: string[255];
    IPAddress: string[16];
    PowerOn: Boolean;
    EngineName: string[20];
  end;

  //MQ에 전달하기 위해 Json으로 변경함(dynamic array 만 지원함)-SetLength로 처리함
  TEventData_Modbus_Standard_DynArr = packed record
    InpDataBuf: array of integer;
    InpDataBuf2: array of Byte;
    InpDataBuf_double: array of double;
    NumOfData: integer;
    NumOfBit: integer;
    ModBusFunctionCode: integer;
    ModBusMode: integer;
    DataMode: integer;
    ParameterType: integer;
    BlockNo: integer;
    ErrorCode: integer;
    PowerOn: Boolean;
    ModBusMapFileName: string;
    IPAddress: string;
    EngineName: string;
    ModBusAddress: string;
  end;

  procedure Copy_DynArrRec_2_EventData_Modbus_Standard(
    const ADynArrRec: TEventData_Modbus_Standard_DynArr;
    var AEventData_Modbus_Standard: TEventData_Modbus_Standard);
//  procedure CustomWriter();
//  procedure CustomReader();
const
  PLCMODBUS_EVENT_NAME = 'MONITOR_EVENT_PLCMODBUS';

  __TEventData_Modbus_Standard_DynArr =
  'InpDataBuf array of integer InpDataBuf2 array of byte ' +
  'InpDataBuf_double array of double NumOfData integer NumOfBit integer ' +
  'ModBusFunctionCode integer ' +
  'ModBusMode integer DataMode integer ParameterType integer BlockNo integer ' +
  'ErrorCode integer PowerOn boolean ModBusMapFileName string IPAddress string EngineName string ModBusAddress string';

implementation

procedure Copy_DynArrRec_2_EventData_Modbus_Standard(
  const ADynArrRec: TEventData_Modbus_Standard_DynArr;
  var AEventData_Modbus_Standard: TEventData_Modbus_Standard);
var i: integer;
begin
  for i := Low(ADynArrRec.InpDataBuf) to High(ADynArrRec.InpDataBuf) do
    AEventData_Modbus_Standard.InpDataBuf[i] := ADynArrRec.InpDataBuf[i];

  for i := Low(ADynArrRec.InpDataBuf2) to High(ADynArrRec.InpDataBuf2) do
    AEventData_Modbus_Standard.InpDataBuf2[i] := ADynArrRec.InpDataBuf2[i];

  for i := Low(ADynArrRec.InpDataBuf_double) to High(ADynArrRec.InpDataBuf_double) do
    AEventData_Modbus_Standard.InpDataBuf_double[i] := ADynArrRec.InpDataBuf_double[i];

  AEventData_Modbus_Standard.NumOfData := ADynArrRec.NumOfData;
  AEventData_Modbus_Standard.NumOfBit := ADynArrRec.NumOfBit;
  AEventData_Modbus_Standard.ModBusFunctionCode := ADynArrRec.ModBusFunctionCode;
  AEventData_Modbus_Standard.ModBusMode := ADynArrRec.ModBusMode;
  AEventData_Modbus_Standard.DataMode := ADynArrRec.DataMode;
  AEventData_Modbus_Standard.ParameterType := ADynArrRec.ParameterType;
  AEventData_Modbus_Standard.BlockNo := ADynArrRec.BlockNo;
  AEventData_Modbus_Standard.ErrorCode := ADynArrRec.ErrorCode;
  AEventData_Modbus_Standard.PowerOn := ADynArrRec.PowerOn;
  AEventData_Modbus_Standard.ModBusMapFileName := ADynArrRec.ModBusMapFileName;
  AEventData_Modbus_Standard.IPAddress := ADynArrRec.IPAddress;
  AEventData_Modbus_Standard.ModBusAddress := ADynArrRec.ModBusAddress;
  AEventData_Modbus_Standard.EngineName := ADynArrRec.EngineName;
end;

initialization
  TTextWriter.RegisterCustomJSONSerializerFromText(
    TypeInfo(TEventData_Modbus_Standard_DynArr), __TEventData_Modbus_Standard_DynArr);
//  TTextWriter.RegisterCustomJSONSerializer(
//    TypeInfo(TEventData_Modbus_Standard),
end.
