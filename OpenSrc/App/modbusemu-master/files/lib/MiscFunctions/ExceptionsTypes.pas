unit ExceptionsTypes;

{$mode objfpc}{$H+}

interface

uses SysUtils;

const

  ERR_MB_ERR_CUSTOM                          = 60000;
  ERR_MB_ILLEGAL_FUNCTION                    = 60001;
  ERR_MB_ILLEGAL_DATA_ADDRESS                = 60002;
  ERR_MB_ILLEGAL_DATA_VALUE                  = 60003;
  ERR_MB_SLAVE_DEVICE_FAILURE                = 60004;
  ERR_MB_ACKNOWLEDGE                         = 60005;
  ERR_MB_SLAVE_DEVICE_BUSY                   = 60006;
  ERR_MB_MEMORY_PARITY_ERROR                 = 60008;
  ERR_MB_GATWAY_PATH_UNAVAILABLE             = 60010;
  ERR_MB_GATWAY_TARGET_DEVICE_FAILED_RESPOND = 60011;
  ERR_MASTER_BUFF_NOT_ASSIGNET               = 60012;
  ERR_MASTER_GET_MEMORY                      = 60013;
  ERR_MASTER_CRC                             = 60014;
  ERR_MASTER_WORD_READ                       = 60015;
  ERR_MASTER_PACK_LEN                        = 60016;
  ERR_MASTER_QUANTITY                        = 60017;
  ERR_MASTER_DEVICE_ADDRESS                  = 60018;
  ERR_OUT_OF_RANGE                           = 60019;
  ERR_MASTER_FIFO_COUNT                      = 60020;
  ERR_MASTER_MEI                             = 60021;
  ERR_MASTER_RDIC                            = 60022;
  ERR_MASTER_MOREFOLLOWS                     = 60023;
  ERR_MASTER_FUNCTION_CODE                   = 60024;
  ERR_MASTER_F72_CHKRKEY                     = 60025;
  ERR_MASTER_F72_QUANTITY                    = 60026;
  ERR_MASTER_F72_CRC                         = 60027;

type

  ECustomModbusException = class(Exception)
  protected
    FErrorCode: Cardinal;
  public
   constructor Create(const Msg: String = ''); reintroduce; virtual;
   property ErrorCode : Cardinal read FErrorCode;
  end;
  // Исключение: Недопустимый адрес данных, полученный в запросе.
  EMBIllegalDataAddress = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Недопустимый тип функции, полученный в запросе.
  EMBIllegalFunction = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Недопустимые значения, полученные в поле данных запроса.
  EMBIllegalDataValues = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Неустранимая ошибка при обработке устройством полученного запроса.
  EMBSlaveDeviceFailure = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Запрос принят. Выполняется длительная операция.
  EMBAcknowlege = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Устройство занято. Повторите запрос позже.
  EMBSlaveDeviceBusy = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: При чтении файла обнаружена ошибка четности памяти.
  EMBMemoryParityError = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Ошибка маршрутизации.
  EMBGetwayPathUnavailable = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Запрашиваемое устройство не ответило.
  EMBGetwayTargetDeviceFailedRespond = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Нераспознанная ошибка.
  EMBUninspacted = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Ключь переданный в ответе не соответствует ожидаемому.
  EMBF72ChkRKey = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Количество регистров в ответе выходит за допустимый дапазон.
  EMBF72Quantity = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Ошибка CRC блока данных.
  EMBF72CRC = class(ECustomModbusException)
   constructor Create(const Msg: String = ''); override;
  end;
  // Исключение: Ключь переданный в ответе не соответствует ожидаемому.
  EMBF110ChkWKey = EMBF72ChkRKey;
  // Исключение: Количество регистров в ответе выходит за допустимый дапазон.
  EMBF110Quantity = EMBF72Quantity;

  EXmlNotAssigned = class(Exception)
   public
    constructor Create(AClassName : String);
  end;

  EXmlNoNode = class(Exception)
   public
    constructor Create(AClassName, ANodeName : String);
  end;

  EXmlAttribute = class(Exception)
   public
    constructor Create(AClassName, ANodeName, AAttrName : String);
  end;

  EXmlAttributeValue = class(Exception)
   public
    constructor Create(AClassName, ANodeName, AAttrName, AValue : String);
  end;

  { EAddDevAlreadyExists }

  EAddDevAlreadyExists = class(Exception)
   public
    constructor Create(ADevNum : Byte);
  end;

  { ENeitherFunctioIsNotSet }

  ENeitherFunctioIsNotSet = class(Exception)
   public
    constructor Create;
  end;


  function GetMBErrorString(Error : Cardinal) : String;

implementation

uses ExceptionsResStrings;

function GetMBErrorString(Error : Cardinal) : String;
begin
 case Error of
  ERR_MB_ILLEGAL_FUNCTION                     : Result:=RS_MB_ILLEGAL_FUNCTION;
  ERR_MB_ILLEGAL_DATA_ADDRESS                 : Result:=RS_MB_ILLEGAL_DATA_ADDRESS;
  ERR_MB_ILLEGAL_DATA_VALUE                   : Result:=RS_MB_ILLEGAL_DATA_VALUE;
  ERR_MB_SLAVE_DEVICE_FAILURE                 : Result:=RS_MB_SLAVE_DEVICE_FAILURE;
  ERR_MB_ACKNOWLEDGE                          : Result:=RS_MB_ACKNOWLEDGE;
  ERR_MB_SLAVE_DEVICE_BUSY                    : Result:=RS_MB_SLAVE_DEVICE_BUSY;
  ERR_MB_MEMORY_PARITY_ERROR                  : Result:=RS_MB_MEMORY_PARITY_ERROR;
  ERR_MB_GATWAY_PATH_UNAVAILABLE              : Result:=RS_MB_GATWAY_PATH_UNAVAILABLE;
  ERR_MB_GATWAY_TARGET_DEVICE_FAILED_RESPOND  : Result:=RS_MB_GATWAY_TARGET_DEVICE_FAILED_RESPOND;
  ERR_MASTER_BUFF_NOT_ASSIGNET                : Result:=RS_MASTER_BUFF_NOT_ASSIGNET;
  ERR_MASTER_GET_MEMORY                       : Result:=RS_MASTER_GET_MEMORY;
  ERR_MASTER_CRC                              : Result:=RS_MASTER_CRC;
  ERR_MASTER_WORD_READ                        : Result:=RS_MASTER_WORD_READ;
  ERR_MASTER_PACK_LEN                         : Result:=RS_MASTER_F3_LEN;
  ERR_MASTER_QUANTITY                         : Result:=RS_MASTER_QUANTITY;
  ERR_MASTER_DEVICE_ADDRESS                   : Result:=RS_MASTER_DEVICE_ADDRESS;
  ERR_MASTER_FIFO_COUNT                       : Result:=RS_MASTER_FIFO_COUNT;
  ERR_MASTER_MEI                              : Result:=RS_MASTER_MEI;
  ERR_MASTER_RDIC                             : Result:=RS_MASTER_RDIC;
  ERR_MASTER_MOREFOLLOWS                      : Result:=RS_MASTER_MOREFOLLOWS;
  ERR_MASTER_FUNCTION_CODE                    : Result:=RS_MASTER_FUNCTION_CODE;
  ERR_MASTER_F72_CHKRKEY                      : Result:=RS_MASTER_F72_CHKRKEY;
  ERR_MASTER_F72_QUANTITY                     : Result:=RS_MASTER_F72_QUANTITY;
  ERR_MASTER_F72_CRC                          : Result:=RS_MASTER_F72_CRC;
 else
  Result:=RS_MB_UNINSPACTED;
 end;
end;

{ ENeitherFunctioIsNotSet }

constructor ENeitherFunctioIsNotSet.Create;
begin
  Message := rsExceptNeitherFunctioIsNotSet;
end;

{ EAddDevAlreadyExists }

constructor EAddDevAlreadyExists.Create(ADevNum : Byte);
begin
  Message := Format(rsExceptAddDevAlreadyExists,[ADevNum]);
end;

{ EXmlAttributeValue }

constructor EXmlAttributeValue.Create(AClassName, ANodeName, AAttrName, AValue : String);
begin
  Message := Format(rsExceptXMLAttrVal,[AClassName,ANodeName,AAttrName,AValue]);
end;

{ EXmlAttribute }

constructor EXmlAttribute.Create(AClassName, ANodeName, AAttrName : String);
begin
  Message := Format(rsExceptXlmNoAttr,[AClassName,ANodeName,AAttrName]);
end;

{ EXmlNoNode }

constructor EXmlNoNode.Create(AClassName, ANodeName : String);
begin
  Message := Format(rsExceptXlmNoNode,[AClassName,ANodeName]);
end;

{ EXmlNotAssigned }

constructor EXmlNotAssigned.Create(AClassName : String);
begin
  Message := Format('%s %s',[AClassName,rsExceptXmlNotAssigned]);
end;

{ ECustomModbusException }

constructor ECustomModbusException.Create(const Msg: String);
begin
  if Msg=''then inherited Create(Format(RS_MB_ERR_CUSTOM,['']))
   else inherited Create(Msg);
  FErrorCode:= ERR_MB_ERR_CUSTOM;
end;

{ EMBIllegalDataAddress }

constructor EMBIllegalDataAddress.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_ILLEGAL_DATA_ADDRESS])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MB_ILLEGAL_DATA_ADDRESS;
end;

{ EMBIllegalFunction }

constructor EMBIllegalFunction.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_ILLEGAL_FUNCTION])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MB_ILLEGAL_FUNCTION;
end;

{ EMBIllegalDataValues }

constructor EMBIllegalDataValues.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_ILLEGAL_DATA_VALUE])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MB_ILLEGAL_DATA_VALUE;
end;

{ EMBSlaveDeviceFailure }

constructor EMBSlaveDeviceFailure.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_SLAVE_DEVICE_FAILURE])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MB_SLAVE_DEVICE_FAILURE;
end;

{ EMBAcknowlege }

constructor EMBAcknowlege.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_ACKNOWLEDGE])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MB_ACKNOWLEDGE;
end;

{ EMBSlaveDeviceBusy }

constructor EMBSlaveDeviceBusy.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_SLAVE_DEVICE_BUSY])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MB_SLAVE_DEVICE_BUSY;
end;

{ EMBMemoryParityError }

constructor EMBMemoryParityError.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_MEMORY_PARITY_ERROR])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MB_MEMORY_PARITY_ERROR;
end;

{ EMBGetwayPathUnavailable }

constructor EMBGetwayPathUnavailable.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_GATWAY_PATH_UNAVAILABLE])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MB_GATWAY_PATH_UNAVAILABLE;
end;

{ EMBGetwayTargetDeviceFailedRespond }

constructor EMBGetwayTargetDeviceFailedRespond.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_GATWAY_TARGET_DEVICE_FAILED_RESPOND])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MB_GATWAY_TARGET_DEVICE_FAILED_RESPOND;
end;

{ EMBUninspacted }

constructor EMBUninspacted.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MB_UNINSPACTED])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= MaxLongint;
end;

{ EMBF72ChkRKey }

constructor EMBF72ChkRKey.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MASTER_F72_CHKRKEY])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MASTER_F72_CHKRKEY;
end;

{ EMBF72Quantity }

constructor EMBF72Quantity.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MASTER_F72_QUANTITY])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MASTER_F72_QUANTITY;
end;

{ EMBF72CRC }

constructor EMBF72CRC.Create(const Msg: String);
begin
  inherited Create;
  if Msg = '' then  Message:=Format(RS_MB_ERR_CUSTOM,[RS_MASTER_F72_CRC])
  else Message:=Format(RS_MB_ERR_CUSTOM,[Msg]);
  FErrorCode:= ERR_MASTER_F72_CRC;
end;

end.
