Эта программа (включает сервис и trayicon приложение) была написана
с целью вести статистику удаленных TCP подключений к InterBase (или к любому другому TCP) серверу.
Она записывает информацию (IP Address, Host Name (если resolve успешен),
DateTime входа и выхода) в interbase.log (или любой другой текстовый файл),
и отображает информацию о активных подключениях на экране.
Также можно принудительно закрывать активные подключения.

ВНИМАНИЕ - если Вы имеете предыдущую версию, пожалуйста удалите её.

Сервис:

1.Чтобы установить сервис запустите в командной строке ipconsvc.exe /install.
2.Запустите "Services", найдите сервис "IP Connections" и
  запустите его, в "Startup" параметрах настройте как удобно "Manual" или "Automatic".
3.Для удаления из системы запустите в командной строке ipconsvc.exe /uninstall.

Приложение:

В инсталляции не нуждается, просто запустите. 

Системные требования: Windows XP и выше, InterBase Server 4x и выше, или любой клон, или любой другой TCP сервер.

С программой распространяется файл IPConSvc.cfg, (он должен находится в той же папке
где и программа) который включает параметры по умолчанию для Firebird 3. 

ServerPort=3050 - Порт сервера
LogFile=C:\Program Files (x86)\Firebird\Firebird_3_0\firebird.log - Полный путь к log файлу
TimeOut=1000 - Время простоя в миллисекундах (от 0 и выше) 
SingleLine=False - см. ниже
ClientPort=11970 - TCP порт для ipconclt.exe

Если параметр SingleLine=False (для записи в interbase.log) cтроки в файле имеет следующий вид:

SERVER	Sun Nov 27 17:05:05 2016
	IP Connections/Connect: address = 167.33.33.28, hostname - HOST1


SERVER	Sun Nov 27 17:05:09 2016
	IP Connections/Disconnect: address = 167.33.33.28, hostname - HOST1

Если параметр SingleLine=True (для записи в любой другой текстовый файл) cтрока в файле имеет следующий вид:

167.33.33.28    HOST1    11/27/2016 17:05:05    11/27/2016 17:05:09

Вы можете создайть таблицу в любой из баз данных на текущем сервере:

  CREATE TABLE IP_CONNECT EXTERNAL FILE 'Полный путь к log файлу'(
    IP_ADDRESS CHAR(15),
    HOST_NAME CHAR(255),
    DT_OPEN CHAR(19),
    DT_CLOSE CHAR(19),
    EOL CHAR(2)
  )

и работать с ней.

Примеры запросов:

Если Вы хотите посмотреть подключения за один день выполните следующий запрос:

  select * from ip_connect
  where cast(dt_open as date) between '11/26/2016' and '11/27/2016'

Если Вы хотите посмотреть подключения по IP адресу выполните следующий запрос:

  select * from ip_connect
  where cast(ip_address as varchar(15)) = '167.33.33.28'

Если Вы хотите посмотреть подключения по имени хоста выполните следующий запрос:

  select * from ip_connect
  where cast(host_name as varchar(255)) = 'HOST1'
