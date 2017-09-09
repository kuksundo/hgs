This program (included service and trayicon application) was written
to gather statistics of IP connections to InterBase (or to any other TCP) server. IPConSvc writes
information (IP Address, Host Name (if resolve is successful), DateTime
of connect and disconnect) into interbase.log file (or any other text file)
and shows information about active connections on the screen.
This helps to understand what client stations generated 10054 and other errors.
Also you can forcibly close the active connections.

WARNING - If you already have installed prev version, please, uninstall it, and install this version.

For service:

1. To install service run it at command prompt
ipconsvc.exe /install
2. Open "Services" from Control Panel, find "IP Connections" and
start it. Also you can configure automatic or manual startup of this
service.
3. To remove ipconsvc from Services run
ipconsvc.exe /uninstall

For application:

Install not needed, just run.

System requirements:

Windows XP or higher, InterBase server 4x or higher, or any clone, or any other TCP server.

This program is distributed with the a file IPConSvc.cfg, (it must be in the same folder
where the program) which are included parameters by default for Firebird 3.

ServerPort=3050 - Server Port
LogFile=C:\Program Files (x86)\Firebird\Firebird_3_0\firebird.log - Full path to the log file
TimeOut=1000 - The idle time in msec (from 0 and higher) 
SingleLine=False - See later
ClientPort=11970 - TCP port for ipconclt.exe

If parameter SingleLine=False (for record into interbase.log) lines in a file has the following kind:

SERVER	Sun Nov 27 17:05:05 2016
	IP Connections/Connect: address = 167.33.33.28, hostname - HOST1


SERVER	Sun Nov 27 17:05:09 2016
	IP Connections/Disconnect: address = 167.33.33.28, hostname - HOST1


If parameter SingleLine=True (for record into any other text file) line in a file has the following kind:

167.33.33.28    HOST1    11/27/2016 17:05:05    11/27/2016 17:05:09

You can create external table in any database on current server:

  CREATE TABLE IP_CONNECT EXTERNAL FILE 'Full path to the log file'(
    IP_ADDRESS CHAR(15),
    HOST_NAME CHAR(255),
    DT_OPEN CHAR(19),
    DT_CLOSE CHAR(19),
    EOL CHAR(2)
  )

and work with it.

Example queries:

If you want to view daily connections:

  select * from ip_connect
  where cast(dt_open as date) between '11/26/2016' and '11/27/2016'

If you want to view connections by IP address:

  select * from ip_connect
  where cast(ip_address as varchar(15)) = '167.33.33.28'

If you want to view connections by host name:

  select * from ip_connect
  where cast(host_name as varchar(255)) = 'HOST1'
