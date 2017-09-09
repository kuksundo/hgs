unit DataStruct4GasEngine;

interface

uses IPCThrd_WT1600, IPCThrd_MEXA7000, IPCThrd_MT210, IPCThrd_ECS_AVAT,
      IPCThrd_GasCalc;

const
  INIFILENAME = '.\TCPServer4GasEngine';

type
  TEventData_IPCAll = packed record
    ECS_AVAT_Data: TEventData_ECS_avat;//array[0..255] of double;
    //ECS_AVAT_Data2: array[0..255] of integer;
    WT1600: TEventData_WT1600;//array[0..13] of double;
    MEXA7000: TEventData_MEXA7000;//array[0..7] of double;
    GasCalc: TEventData_GasCalc;//array[0..30] of double;
    MT210: TEventData_MT210;//double;
    //ModBusFunctionCode,
    //ModBusMode,
    //NumOfData: integer;
    //BlockNo: integer;
  end;

implementation

end.
