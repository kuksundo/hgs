unit IPC_ModbusComm_Const;

interface

type
  //IPCClient에 Config Data 보낼때 사용
  //3차원 배열의 크기 때문에(0..50) stack over flow 에러 발생함)
  TConfigData_ModbusComm = packed record
    XAxisData: array[0..99] of integer;
    YAxisData: array[0..99] of integer;
    ZAxisData: array[0..99] of integer;
    XAxisData_f: array[0..99] of single;
    YAxisData_f: array[0..99] of single;
    ZAxisData_f: array[0..99] of single;
    DataBuf: array[0..255] of integer;
    DataBuf_f: array[0..255] of single;
    //데이타 갯수 반납(Function 16의 경우 Quantity of Registers)
    //Byte Count = NumOfData x 2
    NumOfData_X: integer;  //XAxis data count
    NumOfData_Y: integer;  //YAxis data count
    NumOfData_Z: integer;  //ZAxis data count
    NumOfData: integer;    //Matrix data count

    SlaveNo: integer;
    ModBusFunctionCode: integer;
    ModBusAddress: string[5];
    //2: ptAnalog, 4: ptMatrix1, 5: ptMatrix2, 6: ptMatrix3, 7: ptMatrix1f...
    ParameterType: integer;
    //ASCII Mode = 0, RTU Mode = 1, RTU mode simulation = 3;
    ModbusMode: integer;
    //0: Repeat Read, 1: Only One read(config data), 2: Only One Write, 3: Only One Write for Confirm
    CommMode: integer;
    BlockNo: integer;
    ModBusMapFileName: string[255];
    //IPCClient가 Free될때 pulse event를 한번 하므로 Termination=true로 하면 no action하기 위함
    //Read시에는 문제 안 생겼으나 Write시에 문제 생겨서 해결함(2013.2.20)
    //IPCClient.free 직전에 True로 줄 것
    Termination: boolean;
  end;

const
  MODBUSCOMM_EVENT_NAME = 'MONITOR_EVENT_MODBUSCOMM';

implementation

end.
