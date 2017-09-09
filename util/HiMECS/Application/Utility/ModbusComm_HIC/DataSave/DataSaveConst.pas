unit DataSaveConst;

interface

uses messages;

const
  SAVEINIFILENAME = '.\DataSave_ECS.ini';
  SAVEDATA_FIX_SECTION = 'Fix Condition';
  SAVEDATA_PERIOD_SECTION = 'Period Condition';
  SAVEDATA_MEDIA_SECTION = 'Save Media';
  SAVEDATA_DB_SECTION = 'Database';
  SAVEDATA_ETC_SECTION = 'ETC';

  SAVEDATA_DATABASE_NAME = 'ModBusCom_kumo';
  SAVEDATA_LOGIN_ID = 'KUMO_ECS_SAVE';
  SAVEDATA_PASSWD = 'KUMO_ECS_SAVE';

  INIFILENAME = '.\kumo_ECS_DatasaveConfig_';
  DeviceName = 'KUMO-ECS';
  DATASAVE_SECTION = 'Datasave';
  ENGMONITOR_SECTION = 'Engine Monitor';
  WM_EVENT_ECS = WM_USER + 102;
  WM_EVENT_DYNAMO = WM_USER + 103;

type

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
  end;

  TModbusBlock = class(TObject)
    FStartAddr: string;//Block Scanning 시작 주소
    FCount: integer;   //Block Scanning Count
  end;

implementation

end.
 