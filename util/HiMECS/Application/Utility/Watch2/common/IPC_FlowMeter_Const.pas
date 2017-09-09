unit IPC_FlowMeter_Const;

interface

type
  TEventData_FlowMeter = packed record
    InpDataBuf: array[0..255] of integer;
    InpDataBuf2: array[0..255] of Byte;
    NumOfData: integer;//데이타 갯수 반납
    NumOfBit: integer;//Bit 갯수 반납(01 function 일 경우 Bit 단위로 전달되기 때문임)
    //Block Mode 일경우 Modbus Block Start Address,
    //Individual Mode일경우 Modbus Address
    ModBusFunctionCode: integer;
    ModBusAddress: array[0..19] of char;//String 변수는 공유메모리에 사용 불가함
    //ASCII Mode = 0, RTU Mode = 1;
    ModBusMode: integer;
    PowerOn: Boolean;
  end;

const
  FLOWMETER_EVENT_NAME = 'MONITOR_EVENT_FlowMeter';

implementation

end.
