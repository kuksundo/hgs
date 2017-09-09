unit IPC_ECS_kumo_Const;

interface

type
  TEventData_ECS_kumo = packed record
    InpDataBuf: array[0..255] of integer;
    InpDataBuf2: array[0..255] of Byte;
    InpDataBuf_double: array[0..255] of double;
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
  end;

const
  ECS_KUMO_EVENT_NAME = 'MONITOR_EVENT_ECS_kumo';

implementation

end.
