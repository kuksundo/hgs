unit ExceptionsResStrings;

{$mode objfpc}{$H+}

interface

resourcestring

  rsNoError                                  = 'Нет ошибки.';
  RS_MB_ERR_CUSTOM                           = 'Ошибка Modbus: %s';
  RS_MB_ILLEGAL_FUNCTION                     = 'Недопустимый тип функции, полученный в запросе.';
  RS_MB_ILLEGAL_DATA_ADDRESS                 = 'Недопустимый адрес данных, полученный в запросе.';
  RS_MB_ILLEGAL_DATA_VALUE                   = 'Недопустимые значения, полученные в поле данных запроса.';
  RS_MB_SLAVE_DEVICE_FAILURE                 = 'Неустранимая ошибка при обработке устройством полученного запроса.';
  RS_MB_ACKNOWLEDGE                          = 'Запрос принят. Выполняется длительная операция.';
  RS_MB_SLAVE_DEVICE_BUSY                    = 'Устройство занято. Повторите запрос позже.';
  RS_MB_MEMORY_PARITY_ERROR                  = 'При чтении файла обнаружена ошибка четности памяти.';
  RS_MB_GATWAY_PATH_UNAVAILABLE              = 'Ошибка маршрутизации.';
  RS_MB_GATWAY_TARGET_DEVICE_FAILED_RESPOND  = 'Запрашиваемое устройство не ответило.';
  RS_MB_UNINSPACTED                          = 'Нераспознанная ошибка.';

  RS_MASTER_BUFF_NOT_ASSIGNET                = 'Передан пустой буфер.';
  RS_MASTER_GET_MEMORY                       = 'Системная ошибка.  Код ошибки: %d. - %s';
  RS_MASTER_CRC                              = 'Ошибка расчета CRC16 полученного пакета.';

  RS_MASTER_WORD_READ                        = 'Передано не четное количество байт.';
  RS_MASTER_F3_LEN                           = 'Неверная длина пакета.';
  RS_MASTER_QUANTITY                         = 'Количество записанных регистров превышает допустимое.';
  RS_MASTER_DEVICE_ADDRESS                   = 'Пакет предназначен другому устройству.';
  RS_MASTER_FIFO_COUNT                       = 'Количество FIFO регистров превышает допустимое.';
  RS_MASTER_MEI                              = 'Функция 43. Данный MEI не поддерживается.';
  RS_MASTER_RDIC                             = 'Данный код чтения устройства не реализован.';
  RS_MASTER_MOREFOLLOWS                      = 'Недопустимое значение MoreFollows.';

  RS_MASTER_FUNCTION_CODE                    = 'Неверный код функции в ответном сообщении.';

  RS_MASTER_F72_CHKRKEY                      = 'Ключь переданный в ответе не соответствует ожидаемому.';
  RS_MASTER_F72_QUANTITY                     = 'Количество регистров в ответе выходит за допустимый дапазон.';
  RS_MASTER_F72_CRC                          = 'Ошибка CRC блока данных.';

  rsExceptXmlNotAssigned                     = 'Объект XML документа не задан.';
  rsExceptXlmNoNode                          = '%s Тег %s отсутствует в документе';
  rsExceptXlmNoAttr                          = '%s Тег %s. Отсутствует обязательный атрибут %s';
  rsExceptXMLAttrVal                         = '%s Тег %s. Атрибут %s имеет недопустимое значение %s';

  rsExceptAddDevAlreadyExists                = 'Устройство с адресом %d уже существует.';
  rsExceptNeitherFunctioIsNotSet             = 'Ни одна функция не установлена';


implementation

end.

