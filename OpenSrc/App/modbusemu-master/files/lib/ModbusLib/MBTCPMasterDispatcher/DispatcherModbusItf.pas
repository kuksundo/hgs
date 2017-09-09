unit DispatcherModbusItf;

{$mode objfpc}{$H+}

interface

uses MBDefine;

{
const
  ER_SLAVE_ANSVER_TIMEOUT   = 90000;
  ER_SLAVE_ANSVER_NODATA    = 90001;
  ER_SLAVE_ANSVER_READDATA  = 90002;
  ER_SLAVE_ANSVER_WRITEDATA = 90003;
  ER_SLAVE_CONNECT_BROKEN   = 90004;
  ER_SLAVE_SENT_NOT_FULL    = 90005;
}

type

  TMBDispEventEnumStringArray = array [TMBDispEventEnum] of string;

const

  MBDispEventEnumStrings : TMBDispEventEnumStringArray = ('mdeeConnect','mdeeDisconnect','mdeeSend','mdeeReceive','mdeeSocketError','mdeeMBError');

type
  IMBDispDevSubscriberItf = interface
  ['{B8ADED95-7F0A-E511-99AD-E0CB4E44D5C7}']
   procedure Notify; stdcall;
  end;

  IMBDispDeviceItf = interface
  ['{549A085A-26E3-E411-8BEF-E0CB4E44D5C7}']
   function  GetDeviceNum : Byte; stdcall;

   function  GetCoilValue(ARegNumber : Word) : Boolean; stdcall;
   function  GetDiscretValue(ARegNumber : Word) : Boolean; stdcall;
   function  GetHoldingValue(ARegNumber : Word) : Word; stdcall;
   function  GetInputValue(ARegNumber : Word) : Word; stdcall;

   procedure SetCoilValue(ARegNumber : Word; AValue : Boolean); stdcall;
   procedure SetDiscretValue(ARegNumber : Word; AValue : Boolean); stdcall;
   procedure SetHoldingValue(ARegNumber : Word; AValue : Word); stdcall;
   procedure SetInputValue(ARegNumber : Word; AValue : Word); stdcall;

  end;

  IMBDispDeviceTCPItf = interface(IMBDispDeviceItf)
  ['{7C0F6181-27E3-E411-8BEF-E0CB4E44D5C7}']
   function  GetDeviceIP : Cardinal; stdcall;
   function  GetDevicePort : Word; stdcall;
  end;

  IMBDispCallBackItf = interface
  ['{90552565-83F7-4F39-938C-26526492B43E}']
  {
   ItemProp : TMBTCPSlavePollingItem - параметры с которыми производилась подписка
   Package - динамический массив созначениями в заданном диапазоне регистров.
             Тип значений зависит от функции описанной в параметрах: либо
             значения типа Boolean, либо Word. Динамический массив формируется и
             разрушается вызывающей стороной т.е. диспетчером.
  }
   procedure ProcessBitRegChangesPackage(ItemProp : TMBTCPSlavePollingItem; Package : array of Boolean); stdcall;
   procedure ProcessWordRegChangesPackage(ItemProp : TMBTCPSlavePollingItem; Package : array of Word); stdcall;
   procedure SendEvent(ItemProp : TMBTCPSlavePollingItem; EvType : TMBDispEventEnum;
                                                          Code1  : Cardinal = 0;
                                                          Code2  : Cardinal = 0);  stdcall;
  end;

  IMBDispatcherBaseItf = interface
  ['{569E456C-37C4-4FBA-A723-F1FF4D9CA74C}']
   // управление набором устройств для мониторинга
   procedure AddPollingItem(ItemProp : TMBTCPSlavePollingItem; CallBack : IMBDispCallBackItf); stdcall;
   procedure DelPollingItem(ItemProp : TMBTCPSlavePollingItem); stdcall;
   procedure ClearPollingList; stdcall;
   // запуск/остановка мониторинга всех устройств
   procedure StartAll; stdcall;
   procedure StopAll; stdcall;
   // активация/деактивация устройства для мониторинга
   procedure Activate(ItemProp : TMBTCPSlavePollingItem); stdcall;
   procedure Deactivate(ItemProp : TMBTCPSlavePollingItem); stdcall;
  end;

  IMBDispatcherItf = interface(IMBDispatcherBaseItf)
  ['{B43A05AC-44C4-429B-8FD6-65D6CFC1646C}']
   function IsActive(ItemProp : TMBTCPSlavePollingItem): Boolean; stdcall;

   function SetCoilValue(ADevItf : IMBDispDeviceTCPItf; ARegAddress : Word; ARegValue : Boolean) : Boolean; stdcall;
   function SetInputValue(ADevItf : IMBDispDeviceTCPItf; ARegAddress : Word; ARegValue : Word) : Boolean; stdcall;
  end;

  IMBSlaveProxyItf = interface(IMBDispatcherItf)
  ['{51E247A8-8C6B-47B0-93C5-344086C25B21}']
  end;

  IMBSlaveConnectionItf = interface(IMBDispatcherBaseItf)
  ['{2A03861A-4D89-4482-AFC5-62C71553E84C}']
   function  GetActive: Boolean; stdcall;
   procedure SetConnectionParam(const Value: TMBTCPSlavePollingParam); stdcall;
  end;

implementation

end.
