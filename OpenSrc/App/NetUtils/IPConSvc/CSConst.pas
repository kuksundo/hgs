unit CSConst;

interface

{ Client & Service constants }

const
  //Do not localize
  SL_KEY = 'Server List\';
  SServiceName = 'IPConnections';
  SServiceTitle = 'IP Connections';
  SServiceTip = 'IP Connections (%d)';
  SCfgFile = 'IPConSvc.cfg';
  SServerPort = 'ServerPort';
  SLogFile = 'LogFile';
  STimeOut = 'TimeOut';
  SSingleLine = 'SingleLine';
  SClientPort = 'ClientPort';
  SConnect = 'Connect';
  SDisconnect = 'Disconnect';
  SFmtStr = #13#10'%s'#9'%s'#13#10#9'%s/%s: address = %s, hostname = %s'#13#10#13#10;
  SDTFmtStr = 'ddd mmm dd hh:nn:ss yyyy';
  SSingleFmtStr = '%-15s%-255s%-19s%-19s'#13#10;
  SDTSingleFmtStr = 'mm/dd/yyyy hh:nn:ss';
  cFldSep = #126;

{ Action command }

  acGetConnTable = $C0000001;
  acResult       = $C0000002;
  acCloseConnect = $C0000003;

{ Action command size }

  AC_SIZE = SizeOf(acGetConnTable);

implementation

end.
