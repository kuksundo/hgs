unit ModbusComStruct;

interface

Type
  THiMap = class(TObject)
    FSid: integer;//ID = 200번 부터 Block Scanning임
    FName: string;//이름
    FAddress: string;//Modbus 주소
    FDescription: string;//설명
    FBlockNo: integer;//ModBus Block Scanning 번호(DB의 cnt 필드 값)
    FMaxval: real;//최대값
    FUnit: string;//단위
    FAlarm: Boolean;//Alarm이면 True
    FValue: Variant;//통신으로 받는 값
    //FValue2: Variant;//FValue를 실제값으로 변환한 값
    FContact: Integer;//1: A접점(1일때 On), 2: B접점(1일때 Off), 3: C접점
  public
    procedure GetMapDataFromFile;

  end;

  TModbusBlock = class(TObject)
    FStartAddr: string;//Block Scanning 시작 주소
    FCount: integer;   //Block Scanning Count
  end;

  TWMModbusData = record
    InpDataBuf: array[0..255] of integer;
    NumOfData: integer;//데이타 갯수 반납
    NumOfBit: integer;//Bit 갯수 반납
    //Block Mode 일경우 Modbus Block Start Address,
    //Individual Mode일경우 Modbus Address
    ModBusAddress: string;
    ModBusFunctionCode: integer;
    ModBusMode: integer;
  end;

implementation

{ THiMap }

//File로 부터 Map Data를 읽어와서 클래스 변수에 저장함.
procedure THiMap.GetMapDataFromFile;
begin

end;

end.
