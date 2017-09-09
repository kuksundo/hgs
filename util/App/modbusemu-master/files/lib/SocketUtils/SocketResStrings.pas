unit SocketResStrings;

{$mode objfpc}{$H+}

interface

resourcestring
  rsServerSocketName     = 'Сервер';
  rsClientConnectionName = 'Клиентское соединение';

  rsNameErrEventGeneral    = 'Сокет. Общие ошибки(eeGeneral)';
  rsNameErrEventSend       = 'Сокет. Ошибки отсылки данных(eeSend)';
  rsNameErrEventReceive    = 'Сокет. Ошибки приема данных(eeReceive)';
  rsNameErrEventConnect    = 'Сокет. Ошибки при соединении(eeConnect)';
  rsNameErrEventDisconnect = 'Сокет. Ошибки при разъединении(eeDisconnect)';
  rsNameErrEventAccept     = 'Сокет. Ошибки accept';
  rsNameErrEventLookup     = 'Сокет. Ошибки lookup';
  rsNameErrEventSelect     = 'Сокет. Ошибки select';
  rsNameErrEventBind       = 'Сокет. Ошибки связывания(eeBind)';
  rsNameErrEventSocket     = 'Сокет. Ошибки сокета(eeSocket)';
  rsNameErrEventNone       = 'Сокет. Не известные ошибки(eeNone)';

  rsErrorCode  = 'Код ошибки: %d';

  rsNameSocketEventLookup     = 'Сокет. (Lookup)';
  rsNameSocketEventConnecting = 'Сокет. Установка соединения (Connecting)';
  rsNameSocketEventConnect    = 'Сокет. Установка соединения (Connect)';
  rsNameSocketEventDisconnect = 'Сокет. Разрыв соединения (Disconnect)';
  rsNameSocketEventListen     = 'Сокет. Ожидание подключения (Listen)';
  rsNameSocketEventAccept     = 'Сокет. Подтверждение подключения (Accept)';
  rsNameSocketEventWrite      = 'Сокет. Запись данных (Write)';
  rsNameSocketEventRead       = 'Сокет. Чтение данных (Read)';
  rsNameSocketEventSelect     = 'Сокет. Получение состояния (Select)';
  rsNameSocketEventBind       = 'Сокет. Связываение (Bind)';

  rsUDPSendPackage1 = 'UDP server. SentPackege';
  rsUDPSendPackage2 = 'Попытка отослать пустой пакет';

  rsOnUDPSign1 = 'UDP server';
  rsOnUDPSign2 = 'UDP server. Получение пакета';
  rsOnUDPSign3 = 'Пакет отброшен';
  rsOnUDPSign4 = 'Не установлен робработчик пакетов.';
  rsOnUDPSign5 = 'Ошибка обработчика пришедшего пакета: %s';

  rsUDPClSentPack1 = 'UDP client. SentPackege';
  rsUDPClSentPack2 = 'Попытка отослать пустой пакет';
  rsUDPClSentPack3 = 'Пакет слишком большой: %d';

  rsUDPClGetPack1 = 'UDP client. Получение пакета';
  rsUDPClGetPack2 = 'Ошибка обработчика пришедшего пакета: %s';

  rsWRData1 = 'Требуется использовать блокирующий сокет(BlockingSocket = True), без использования потока отслеживания состояний (SelectEnable := False).';

  rsClOnResData1 = 'ClientObject.OnClientReceiveData. Ошибка: %s';
  rsClOnResData2 = 'ClientObject.OnClientReceiveInfo. Ошибка: %s';

  rsSrvAccept1 = 'Превышено допустимое количество одновременных соединений.';

  rsBSrvSockRemCl1 = 'Клиент удален.Количество соединений: %d';

  rsClLasrErrSet1 = 'Клиент: %s:%d - Ошибка: %s - %s';

  rsClConnect1 = 'Присоеденился клиент. Количество соединений: %d';

  rsSocketNotExist = 'Socket is not exists';
  rsConnected      = 'Connected';
  rsDisConnected   = 'Disonnected';
  rsSocket         = 'Socket %s (%s);';

  rsErrorSocketDescr = 'SelectThread. Должен быть передан действующий дескриптор сокета.';

  rsROWNotInstalled = 'Структура параметров интерфейса не установлена.';

  rsGetInf1 = 'Имя: %s';
  rsGetInf2 = 'IP адреса:';
  rsGetInf3 = 'IP: %s';
  rsGetInf4 = 'Маска IP: %s';
  rsGetInf5 = 'Шлюзы:';
  rsGetInf6 = 'DHSP: ';
  rsGetInf7 = 'Разрешен: %s';
  rsGetInf8 = 'WINS: ';
  rsGetInf9 = 'IP первичного: %s';
  rsGetInf10 = 'Маска первичного: %s';
  rsGetInf11 = 'IP вторичного: %s';
  rsGetInf12 = 'Маска вторичного: %s';

  rsLinNetInfo1 = 'Сокет для получения информации не задан.';

  rsMIB_IF_OPER_STATUS_NON_OPERATIONAL = 'LAN-адаптер отключен';
  rsMIB_IF_OPER_STATUS_UNREACHABLE     = 'WAN-адаптер отключен';
  rsMIB_IF_OPER_STATUS_DISCONNECTED    = 'Кабель отключен или нет сигнала';
  rsMIB_IF_OPER_STATUS_CONNECTING      = 'WAN-адаптер в процессе подключения';
  rsMIB_IF_OPER_STATUS_CONNECTED       = 'WAN-адаптер установил соединение';
  rsMIB_IF_OPER_STATUS_LAN_CONNECTED   = 'Кабель подключен';
  rsMIB_IF_OPER_STATUS_LAN_OPERATIONAL = 'LAN-адаптер OPERATIONAL';
  rsMIB_IF_OPER_STATUS_LAN_UNKNOWN     = 'Не известный статус';

  rsMIB_IF_ADMIN_STATUS_UP      = 'Включен';
  rsMIB_IF_ADMIN_STATUS_DOWN    = 'Выключен';
  rsMIB_IF_ADMIN_STATUS_CHACKED = 'Проверка';

  rsMIB_IF_TYPE_ETHERNET  = 'Ethernet';
  rsMIB_IF_TYPE_TOKENRING = 'Token ring';
  rsMIB_IF_TYPE_FDDI      = 'FDDI';
  rsMIB_IF_TYPE_PPP       = 'PPP';
  rsMIB_IF_TYPE_LOOPBACK  = 'Замыкание на себя';
  rsMIB_IF_TYPE_SLIP      = 'Подключение к UNIX';
  rsMIB_IF_TYPE_ATM       = 'ATM';
  rsMIB_IF_TYPE_IEEE80211 = 'An IEEE 802.11 wireless network interface';
  rsMIB_IF_TYPE_TUNNEL    = 'A tunnel type encapsulation network interface.';
  rsMIB_IF_TYPE_IEEE1394  = 'An IEEE 1394 (Firewire) high performance serial bus network interface.';
  rsMIB_IF_TYPE_IEEE80216 = 'A mobile broadband interface for WiMax devices.';
  rsMIB_IF_TYPE_WWANP     = 'A mobile broadband interface for GSM-based devices.';
  rsMIB_IF_TYPE_WWANP2    = 'An mobile broadband interface for CDMA-based devices.';

  rsMIB_IF_TYPE_UNKNOWN   = 'Неизвестный тип';

  rsMsgStatusChange    = 'Административный статус изменен.';
  rsMsgStatusNotChange = 'Не удалось изменить административный статус интерфейса!';
  rsLanItfNotChange    = 'Не выбран сетевой интерфейс!';
  rsFormatOutQLen      = 'Байт в очереди на отправку: %d';
  rsFormatErrors       = 'Ошибок пакетов: %d';
  rsFormatDiscards     = 'Пакетов отклонено: %d';
  rsFormatOctetsM      = 'Отправлено, Мбайт: %d';
  rsFormatOctets       = 'Отправлено, байт: %d';
  rsFormatOut          = 'Исходящий трафик';
  rsFormatInUnknProts  = 'Пакетов, полученных по неизвестным протоколам: %d';
  rsFormatIn           = 'Входящий трафик';
  rsFormatOperStatus   = 'Оперативный статус: %s';
  rsFormatAdminStatus  = 'Административный статус: %s';
  rsFormatMACAddress   = 'MAC-адрес: %s';
  rsFormatMTU          = 'MTU: %d';
  rsFormatSpeedM       = 'Скорость подключения, МБит/с.: %d';
  rsFormatSpeed        = 'Cкорость подключения, бит/с.: %d';
  rsFormatType         = 'Тип: %s';
  rsFormatGetIfError   = 'Ошибки во время вызова GetIfTable. Код ошибки: %d';
  rsFormatUnicast      = 'Число одноадресных пакетов: %d';
  rsFormatNUnicast     = 'Число не одноадресных пакетов: %d';
  rsFormatIndex        = 'Индекс интерфейса: %d';

  strHostNotFound           = 'Не удалось произвести разрешение имен для "%s".';
  strSocketCreationFailed   = 'Не удалось создать сокет: %s';
  strSocketBindFailed       = 'Binding of socket failed: %s';
  strSocketListenFailed     = 'Ошибка ожидания соединения #%d , ошибка: %d';
  strSocketConnectFailed    = 'Не удалось установить соединение с %s.';
  strSocketAcceptFailed     = 'Could not accept a client connection on socket: %d, error %d';
  strSocketAcceptWouldBlock = 'Accept would block on socket: %d';
  strErrNoStream            = 'Socket stream not assigned';

  rsSockServ1 = 'Failed to set linger: %d';
  rsSockServ2 = 'Failed to set SO_REUSEADDR to %d: %d';
  rsSockServ3 = 'Failed to set linger: %d';
  rsSockServ4 = 'Failed to get SO_KEEPALIVE: %d';
  rsSockServ5 = 'Failed to get SO_REUSEADDR to %d: %d';

  SErrInvalidProtocol = 'Invalid protocol : "%s"';
  SErrReadingSocket = 'Error reading data from socket';
  SErrInvalidProtocolVersion = 'Invalid protocol version in response: "%s"';
  SErrInvalidStatusCode = 'Invalid response status code: %s';
  SErrUnexpectedResponse = 'Unexpected response status code: %d';
  SErrChunkTooBig = 'Chunk too big';
  SErrChunkLineEndMissing = 'Chunk line end missing';
  SErrMaxRedirectsReached    = 'Maximum allowed redirects reached : %d';



implementation

end.

