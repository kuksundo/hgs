unit IPC_HIC_Const;

interface

type
  //HIC Data를 Monitor에  보낼때 사용
  TEventData_HIC = packed record
    //Config Data일 경우(DataMode=CM_CONFIG_READ) InpDataBuf 배열에
    //Matrix1 = XAxis Data 다음에 Value Data 옴
    //Matrix2 = XAxis Data, YAxis Data, Value Data
    //Matrix3 = XAxis Data, YAxis Data, YAxis Data, Value Data 옴
    InpDataBuf: array[0..255] of integer;
    InpDataBuf_b: array[0..255] of Byte;
    InpDataBuf_f: array[0..255] of single;
    NumOfData: integer;//데이타 갯수 반납
    NumOfBit: integer;//Bit 갯수 반납(01 function 일 경우 Bit 단위로 전달되기 때문임)
    //Block Mode 일경우 Modbus Block Start Address,
    //Individual Mode일경우 Modbus Address
    ModBusFunctionCode: integer;
    ModBusAddress: string[5];
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
    PowerOn: Boolean;
  end;

const
  HIC_EVENT_NAME = 'MONITOR_EVENT_HIC';

implementation

end.
