unit COMPortResStr;

{$mode objfpc}{$H+}

interface

resourcestring

  rsStopBitError  = 'Недопустимое значение количества стоповых бит.';
  rsSpeedError    = 'Недопустимое значение скорости передачи данных.';
  rsBiteSizeError = 'Недопустимое значение размера байта данных.';
  rsErrPortUninspected  = 'Ошибка. Код ошибки: %d Сообщение: %s';
  rsErrPortPathOther    = 'Нестандартны путь к порту не задан.';
  rsErrPortAlreadyOpen  = 'Порт уже открыт.';
  rsErrPortNotOpen      = 'Порт не открыт.';
  rsErrPortBuff         = 'Не задан буфер.';
  rsErrPortBuffSmoll    = 'Слишком маленьки буфер.';
  rsErrPortAlreadyClose = 'Порт уже закрыт.';
  rsOther = 'Другой';

  rsCOMUnknown      = 'COM%d отсутствует.';
  rsCOMAccessible   = 'COM%d доступен.';
  rsCOMUnAccessible = 'COM%d недоступен.';
  rsCOMErrString1   = 'Ошибка линии.';
  rsCOMErrString2   = 'Аппаратные средства обнаружили разрыв линии.';
  rsCOMErrString3   = 'Параллельное устройство не выбрано.';
  rsCOMErrString4   = 'Аппаратные средства обнаружили ошибку кадровой синхронизации.';
  rsCOMErrString5   = 'Произошла ошибка ввода/вывода.';
  rsCOMErrString6   = 'Требуемый режим не поддерживается, или hFile параметр недопустим.';
  rsCOMErrString7   = 'В принтере отсутствует бумага.';
  rsCOMErrString8   = 'Произошло переполнение символьного буфера. Следующий символ потерян.';
  rsCOMErrString9   = 'Таймаут на параллельном устройстве.';
  rsCOMErrString10  = 'Переполнение входного буфера.';
  rsCOMErrString11  = 'Ошибка паритета.';
  rsCOMErrString12  = 'Переполнение выходного буфера.';
  rsCOMErrString13  = 'Неопознанная ошибка.';
  rsCOMErrString14  = 'Неизвестная категория ошибки.';
  rsCOMErrString15  = 'Категория ошибки: %s. Ошибка : %s';
  rsCOMString1 = 'COM%d-не установлен';
  rsCOMString2 = 'доступен';
  rsCOMString3 = 'не доступен';
  rsCOMString4 = 'не установлен';
  rsCOMString5 = 'занят';

  rsPortName = 'Последовательный порт';

  rsReadBitsState1 = 'Получение бит статуса. Ошибка: %d - %s';
  rsReadBitsState2 = 'Получение бит статуса. Ошибка: %s';
  rsReadBitsState3 = 'OnLEChange. Ошибка: %s';
  rsReadBitsState4 = 'OnCTSChange. Ошибка: %s';
  rsReadBitsState5 = 'OnDCDChange. Ошибка: %s';
  rsReadBitsState6 = 'OnDSRChange. Ошибка: %s';
  rsReadBitsState7 = 'OnRNGChange. Ошибка: %s';
  rsReadBitsState8 = 'OnRTSChange. Ошибка: %s';
  rsReadBitsState9 = 'OnDTRChange. Ошибка: %s';
  rsReadBitsState10 = 'WaitForData. Ошибка: %s';
  rsReadBitsState11 = 'Серверный порт. Ошибка: %d - %s';
  rsReadBitsState12 = 'TNPCServerCOMPortThread.Execute. Ошибка: %s';

  rsOpen1  = '%s открыт';
  rsClose1 = '%s закрыт';

  rsReadData1 = 'Буфер: %d(%d)';


implementation

end.

