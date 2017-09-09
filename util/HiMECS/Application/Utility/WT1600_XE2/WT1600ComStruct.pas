unit WT1600ComStruct;

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
    FValue: Integer;//실제값- MpdBus 통신으로부터 수신함
    FContact: Integer;//1: A접점(1일때 On), 2: B접점(1일때 Off), 3: C접점
  public

  end;

  TWMWT1600Data = record
    IPAddress: string;
    URMS1: string;
    URMS2: string;
    URMS3: string;
    IRMS1: string;
    IRMS2: string;
    IRMS3: string;
    PSIGMA: string;
    SSIGMA: string;
    QSIGMA: string;
    RAMDA: string;
    FREQUENCY: string;
    PowerMeterOn: boolean;
    PowerMeterNo: integer;
  end;

implementation

{ THiMap }

end.
