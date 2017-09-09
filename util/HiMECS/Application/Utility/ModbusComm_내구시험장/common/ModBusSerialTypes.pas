unit ModBusSerialTypes;

interface

Uses ModbusTypes;

type
  TModBusSerialRequestBuffer = packed record
    SlaveNumber: Byte;
    FunctionCode: TModBusFunction;
    MBPData: TModBusDataBuffer;
  end;

  TModBusSerialResponseBuffer = packed record
    SlaveNumber: Byte;
    FunctionCode: TModBusFunction;
    MBPData: TModBusDataBuffer;
  end;

implementation

end.
