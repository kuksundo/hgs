{*******************************************************}
{                                                       }
{       Borland Delphi Runtime Library                  }
{       LM Server and Share API Interface Unit          }
{                                                       }
{       Copyright (c) 1990-1999 Microsoft Corporation.  }
{                                                       }
{       Translator: Vadim Crits                         }
{                                                       }
{*******************************************************}

unit LMNet;

{$ALIGN ON}
{$WEAKPACKAGEUNIT}

interface

uses Windows;

const
  NERR_Success = 0;
  PARMNUM_BASE_INFOLEVEL = 1000;

type
  NET_API_STATUS = DWORD;

{ Function Prototypes - SERVER }

function NetServerEnum(servername: LPCWSTR; level: DWORD; var bufptr: Pointer;
  prefmaxlen: DWORD; entriesread, totalentries: LPDWORD; servertype: DWORD;
  domain: LPCWSTR; resume_handle: LPDWORD): NET_API_STATUS; stdcall;

function NetServerEnumEx(ServerName: LPCWSTR; Level: DWORD; var Bufptr: Pointer;
  PrefMaxlen: DWORD; EntriesRead, totalentries: LPDWORD; servertype: DWORD;
  domain: LPCWSTR; FirstNameToReturn: LPCWSTR): NET_API_STATUS; stdcall;

function NetServerGetInfo(servername: LPWSTR; level: DWORD;
  var bufptr: Pointer): NET_API_STATUS; stdcall;

function NetServerSetInfo(servername: LPWSTR; level: DWORD; buf: Pointer;
  ParmError: LPDWORD): NET_API_STATUS; stdcall;

{ Temporary hack function. }

function NetServerSetInfoCommandLine(argc: WORD;
  argv: LPWSTR): NET_API_STATUS; stdcall;

function NetServerDiskEnum(servername: LPWSTR; level: DWORD; var bufptr: Pointer;
  prefmaxlen: DWORD; entriesread, totalentries,
  resume_handle: LPDWORD): NET_API_STATUS; stdcall;

function NetServerComputerNameAdd(ServerName, EmulatedDomainName,
  EmulatedServerName: LPWSTR): NET_API_STATUS; stdcall;

function NetServerComputerNameDel(ServerName,
  EmulatedServerName: LPWSTR): NET_API_STATUS; stdcall;

function NetServerTransportAdd(servername: LPWSTR; level: DWORD;
  bufptr: Pointer): NET_API_STATUS; stdcall;

function NetServerTransportAddEx(servername: LPWSTR; level: DWORD;
  bufptr: Pointer): NET_API_STATUS; stdcall;

function NetServerTransportDel(servername: LPWSTR; level: DWORD;
  bufptr: Pointer): NET_API_STATUS; stdcall;

function NetServerTransportEnum(servername: LPWSTR; level: DWORD;
  var bufptr: Pointer; prefmaxlen: DWORD; entriesread, totalentries,
  resumehandle: LPDWORD): NET_API_STATUS; stdcall;

{ The following function can be called by Win NT services to register
  their service type.  This function is exported from advapi32.dll.
  Therefore, if this is the only function called by that service, then
  it is not necessary to link to netapi32.lib. }

function SetServiceBits(hServiceStatus: THandle; dwServiceBits: DWORD;
  bSetBitsOn, bUpdateImmediately: BOOL): BOOL; stdcall;

{ Data Structures - SERVER }

type
  PServerInfo100 = ^TServerInfo100;
  TServerInfo100 = record
    sv100_platform_id: DWORD;
    sv100_name: LPWSTR;
  end;

  PServerInfo101 = ^TServerInfo101;
  TServerInfo101 = record
    sv101_platform_id: DWORD;
    sv101_name: LPWSTR;
    sv101_version_major: DWORD;
    sv101_version_minor: DWORD;
    sv101_type: DWORD;
    sv101_comment: LPWSTR;
  end;

  PServerInfo102 = ^TServerInfo102;
  TServerInfo102 = record
    sv102_platform_id: DWORD;
    sv102_name: LPWSTR;
    sv102_version_major: DWORD;
    sv102_version_minor: DWORD;
    sv102_type: DWORD;
    sv102_comment: LPWSTR;
    sv102_users: DWORD;
    sv102_disc: Longint;
    sv102_hidden: BOOL;
    sv102_announce: DWORD;
    sv102_anndelta: DWORD;
    sv102_licenses: DWORD;
    sv102_userpath: LPWSTR;
  end;

  PServerInfo103 = ^TServerInfo103;
  TServerInfo103 = record
    sv103_platform_id: DWORD;
    sv103_name: LPWSTR;
    sv103_version_major: DWORD;
    sv103_version_minor: DWORD;
    sv103_type: DWORD;
    sv103_comment: LPWSTR;
    sv103_users: DWORD;
    sv103_disc: Longint;
    sv103_hidden: BOOL;
    sv103_announce: DWORD;
    sv103_anndelta: DWORD;
    sv103_licenses: DWORD;
    sv103_userpath: LPWSTR;
    sv103_capabilities: DWORD;
  end;

  PServerInfo402 = ^TServerInfo402;
  TServerInfo402 = record
    sv402_ulist_mtime: DWORD;
    sv402_glist_mtime: DWORD;
    sv402_alist_mtime: DWORD;
    sv402_alerts: LPWSTR;
    sv402_security: DWORD;
    sv402_numadmin: DWORD;
    sv402_lanmask: DWORD;
    sv402_guestacct: LPWSTR;
    sv402_chdevs: DWORD;
    sv402_chdevq: DWORD;
    sv402_chdevjobs: DWORD;
    sv402_connections: DWORD;
    sv402_shares: DWORD;
    sv402_openfiles: DWORD;
    sv402_sessopens: DWORD;
    sv402_sessvcs: DWORD;
    sv402_sessreqs: DWORD;
    sv402_opensearch: DWORD;
    sv402_activelocks: DWORD;
    sv402_numreqbuf: DWORD;
    sv402_sizreqbuf: DWORD;
    sv402_numbigbuf: DWORD;
    sv402_numfiletasks: DWORD;
    sv402_alertsched: DWORD;
    sv402_erroralert: DWORD;
    sv402_logonalert: DWORD;
    sv402_accessalert: DWORD;
    sv402_diskalert: DWORD;
    sv402_netioalert: DWORD;
    sv402_maxauditsz: DWORD;
    sv402_srvheuristics: LPWSTR;
  end;

  PServerInfo403 = ^TServerInfo403;
  TServerInfo403 = record
    sv403_ulist_mtime: DWORD;
    sv403_glist_mtime: DWORD;
    sv403_alist_mtime: DWORD;
    sv403_alerts: LPWSTR;
    sv403_security: DWORD;
    sv403_numadmin: DWORD;
    sv403_lanmask: DWORD;
    sv403_guestacct: LPWSTR;
    sv403_chdevs: DWORD;
    sv403_chdevq: DWORD;
    sv403_chdevjobs: DWORD;
    sv403_connections: DWORD;
    sv403_shares: DWORD;
    sv403_openfiles: DWORD;
    sv403_sessopens: DWORD;
    sv403_sessvcs: DWORD;
    sv403_sessreqs: DWORD;
    sv403_opensearch: DWORD;
    sv403_activelocks: DWORD;
    sv403_numreqbuf: DWORD;
    sv403_sizreqbuf: DWORD;
    sv403_numbigbuf: DWORD;
    sv403_numfiletasks: DWORD;
    sv403_alertsched: DWORD;
    sv403_erroralert: DWORD;
    sv403_logonalert: DWORD;
    sv403_accessalert: DWORD;
    sv403_diskalert: DWORD;
    sv403_netioalert: DWORD;
    sv403_maxauditsz: DWORD;
    sv403_srvheuristics: LPWSTR;
    sv403_auditedevents: DWORD;
    sv403_autoprofile: DWORD;
    sv403_autopath: LPWSTR;
  end;

  PServerInfo502 = ^TServerInfo502;
  TServerInfo502 = record
    sv502_sessopens: DWORD;
    sv502_sessvcs: DWORD;
    sv502_opensearch: DWORD;
    sv502_sizreqbuf: DWORD;
    sv502_initworkitems: DWORD;
    sv502_maxworkitems: DWORD;
    sv502_rawworkitems: DWORD;
    sv502_irpstacksize: DWORD;
    sv502_maxrawbuflen: DWORD;
    sv502_sessusers: DWORD;
    sv502_sessconns: DWORD;
    sv502_maxpagedmemoryusage: DWORD;
    sv502_maxnonpagedmemoryusage: DWORD;
    sv502_enablesoftcompat: BOOL;
    sv502_enableforcedlogoff: BOOL;
    sv502_timesource: BOOL;
    sv502_acceptdownlevelapis: BOOL;
    sv502_lmannounce: BOOL;
  end;

  PServerInfo503 = ^TServerInfo503;
  TServerInfo503 = record
    sv503_sessopens: DWORD;
    sv503_sessvcs: DWORD;
    sv503_opensearch: DWORD;
    sv503_sizreqbuf: DWORD;
    sv503_initworkitems: DWORD;
    sv503_maxworkitems: DWORD;
    sv503_rawworkitems: DWORD;
    sv503_irpstacksize: DWORD;
    sv503_maxrawbuflen: DWORD;
    sv503_sessusers: DWORD;
    sv503_sessconns: DWORD;
    sv503_maxpagedmemoryusage: DWORD;
    sv503_maxnonpagedmemoryusage: DWORD;
    sv503_enablesoftcompat: BOOL;
    sv503_enableforcedlogoff: BOOL;
    sv503_timesource: BOOL;
    sv503_acceptdownlevelapis: BOOL;
    sv503_lmannounce: BOOL;
    sv503_domain: LPWSTR;
    sv503_maxcopyreadlen: DWORD;
    sv503_maxcopywritelen: DWORD;
    sv503_minkeepsearch: DWORD;
    sv503_maxkeepsearch: DWORD;
    sv503_minkeepcomplsearch: DWORD;
    sv503_maxkeepcomplsearch: DWORD;
    sv503_threadcountadd: DWORD;
    sv503_numblockthreads: DWORD;
    sv503_scavtimeout: DWORD;
    sv503_minrcvqueue: DWORD;
    sv503_minfreeworkitems: DWORD;
    sv503_xactmemsize: DWORD;
    sv503_threadpriority: DWORD;
    sv503_maxmpxct: DWORD;
    sv503_oplockbreakwait: DWORD;
    sv503_oplockbreakresponsewait: DWORD;
    sv503_enableoplocks: BOOL;
    sv503_enableoplockforceclose: BOOL;
    sv503_enablefcbopens: BOOL;
    sv503_enableraw: BOOL;
    sv503_enablesharednetdrives: BOOL;
    sv503_minfreeconnections: DWORD;
    sv503_maxfreeconnections: DWORD;
  end;

  PServerInfo599 = ^TServerInfo599;
  TServerInfo599 = record
    sv599_sessopens: DWORD;
    sv599_sessvcs: DWORD;
    sv599_opensearch: DWORD;
    sv599_sizreqbuf: DWORD;
    sv599_initworkitems: DWORD;
    sv599_maxworkitems: DWORD;
    sv599_rawworkitems: DWORD;
    sv599_irpstacksize: DWORD;
    sv599_maxrawbuflen: DWORD;
    sv599_sessusers: DWORD;
    sv599_sessconns: DWORD;
    sv599_maxpagedmemoryusage: DWORD;
    sv599_maxnonpagedmemoryusage: DWORD;
    sv599_enablesoftcompat: BOOL;
    sv599_enableforcedlogoff: BOOL;
    sv599_timesource: BOOL;
    sv599_acceptdownlevelapis: BOOL;
    sv599_lmannounce: BOOL;
    sv599_domain: LPWSTR;
    sv599_maxcopyreadlen: DWORD;
    sv599_maxcopywritelen: DWORD;
    sv599_minkeepsearch: DWORD;
    sv599_maxkeepsearch: DWORD;
    sv599_minkeepcomplsearch: DWORD;
    sv599_maxkeepcomplsearch: DWORD;
    sv599_threadcountadd: DWORD;
    sv599_numblockthreads: DWORD;
    sv599_scavtimeout: DWORD;
    sv599_minrcvqueue: DWORD;
    sv599_minfreeworkitems: DWORD;
    sv599_xactmemsize: DWORD;
    sv599_threadpriority: DWORD;
    sv599_maxmpxct: DWORD;
    sv599_oplockbreakwait: DWORD;
    sv599_oplockbreakresponsewait: DWORD;
    sv599_enableoplocks: BOOL;
    sv599_enableoplockforceclose: BOOL;
    sv599_enablefcbopens: BOOL;
    sv599_enableraw: BOOL;
    sv599_enablesharednetdrives: BOOL;
    sv599_minfreeconnections: DWORD;
    sv599_maxfreeconnections: DWORD;
    sv599_initsesstable: DWORD;
    sv599_initconntable: DWORD;
    sv599_initfiletable: DWORD;
    sv599_initsearchtable: DWORD;
    sv599_alertschedule: DWORD;
    sv599_errorthreshold: DWORD;
    sv599_networkerrorthreshold: DWORD;
    sv599_diskspacethreshold: DWORD;
    sv599_reserved: DWORD;
    sv599_maxlinkdelay: DWORD;
    sv599_minlinkthroughput: DWORD;
    sv599_linkinfovalidtime: DWORD;
    sv599_scavqosinfoupdatetime: DWORD;
    sv599_maxworkitemidletime: DWORD;
  end;

  PServerInfo598 = ^TServerInfo598;
  TServerInfo598 = record
    sv598_maxrawworkitems: DWORD;
    sv598_maxthreadsperqueue: DWORD;
    sv598_producttype: DWORD;
    sv598_serversize: DWORD;
    sv598_connectionlessautodisc: DWORD;
    sv598_sharingviolationretries: DWORD;
    sv598_sharingviolationdelay: DWORD;
    sv598_maxglobalopensearch: DWORD;
    sv598_removeduplicatesearches: DWORD;
    sv598_lockviolationoffset: DWORD;
    sv598_lockviolationdelay: DWORD;
    sv598_mdlreadswitchover: DWORD;
    sv598_cachedopenlimit: DWORD;
    sv598_otherqueueaffinity: DWORD;
    sv598_restrictnullsessaccess: BOOL;
    sv598_enablewfw311directipx: BOOL;
    sv598_queuesamplesecs: DWORD;
    sv598_balancecount: DWORD;
    sv598_preferredaffinity: DWORD;
    sv598_maxfreerfcbs: DWORD;
    sv598_maxfreemfcbs: DWORD;
    sv598_maxfreelfcbs: DWORD;
    sv598_maxfreepagedpoolchunks: DWORD;
    sv598_minpagedpoolchunksize: DWORD;
    sv598_maxpagedpoolchunksize: DWORD;
    sv598_sendsfrompreferredprocessor: BOOL;
    sv598_cacheddirectorylimit: DWORD;
    sv598_maxcopylength: DWORD;
    sv598_enablecompression: BOOL;
    sv598_autosharewks: BOOL;
    sv598_autoshareserver: BOOL;
    sv598_enablesecuritysignature: BOOL;
    sv598_requiresecuritysignature: BOOL;
    sv598_minclientbuffersize: DWORD;
    sv598_serverguid: TGUID;
    sv598_ConnectionNoSessionsTimeout: DWORD;
    sv598_IdleThreadTimeOut: DWORD;
    sv598_enableW9xsecuritysignature: BOOL;
    sv598_enforcekerberosreauthentication: BOOL;
    sv598_disabledos: BOOL;
    sv598_lowdiskspaceminimum: DWORD;
    sv598_disablestrictnamechecking: BOOL;
  end;

  PTServerInfo1005 = ^TServerInfo1005;
  TServerInfo1005 = record
    sv1005_comment: LPWSTR;
  end;

  PServerInfo1107 = ^TServerInfo1107;
  TServerInfo1107 = record
    sv1107_users: DWORD;
  end;

  PServerInfo1010 = ^TServerInfo1010;
  TServerInfo1010 = record
    sv1010_disc: Longint;
  end;

  PServerInfo1016 = ^TServerInfo1016;
  TServerInfo1016 = record
    sv1016_hidden: BOOL;
  end;

  PTServerInfo1017 = ^TServerInfo1017;
  TServerInfo1017 = record
    sv1017_announce: DWORD;
  end;

  PServerInfo1018 = ^TServerInfo1018;
  TServerInfo1018 = record
    sv1018_anndelta: DWORD;
  end;

  PServerInfo1501 = ^TServerInfo1501;
  TServerInfo1501 = record
    sv1501_sessopens: DWORD;
  end;

  PServerInfo1502 = ^TServerInfo1502;
  TServerInfo1502 = record
    sv1502_sessvcs: DWORD;
  end;

  PServerInfo1503 = ^TServerInfo1503;
  TServerInfo1503 = record
    sv1503_opensearch: DWORD;
  end;

  PServerInfo1506 = ^TServerInfo1506;
  TServerInfo1506 = record
    sv1506_maxworkitems: DWORD;
  end;

  PServerInfo1509 = ^TServerInfo1509;
  TServerInfo1509 = record
    sv1509_maxrawbuflen: DWORD;
  end;

  PServerInfo1510 = ^TServerInfo1510;
  TServerInfo1510 = record
    sv1510_sessusers: DWORD;
  end;
 
  PServerInfo1511 = ^TServerInfo1511;
  TServerInfo1511 = record
    sv1511_sessconns: DWORD;
  end;

  PServerInfo1512 = ^TServerInfo1512;
  TServerInfo1512 = record
    sv1512_maxnonpagedmemoryusage: DWORD;
  end;

  PServerInfo1513 = ^TServerInfo1513;
  TServerInfo1513 = record
    sv1513_maxpagedmemoryusage: DWORD;
  end;

  PServerInfo1514 = ^TServerInfo1514;
  TServerInfo1514 = record
    sv1514_enablesoftcompat: BOOL;
  end;

  PServerInfo1515 = ^TServerInfo1515;
  TServerInfo1515 = record
    sv1515_enableforcedlogoff: BOOL;
  end;

  PServerInfo1516 = ^TServerInfo1516;
  TServerInfo1516 = record
    sv1516_timesource: BOOL;
  end;

  PServerInfo1518 = ^TServerInfo1518;
  TServerInfo1518 = record
    sv1518_lmannounce: BOOL;
  end;

  PServerInfo1520 = ^TServerInfo1520;
  TServerInfo1520 = record
    sv1520_maxcopyreadlen: DWORD;
  end;

  PServerInfo1521 = ^TServerInfo1521;
  TServerInfo1521 = record
    sv1521_maxcopywritelen: DWORD;
  end;

  PServerInfo1522 = ^TServerInfo1522;
  TServerInfo1522 = record
    sv1522_minkeepsearch: DWORD;
  end;

  PServerInfo1523 = ^TServerInfo1523;
  TServerInfo1523 = record
    sv1523_maxkeepsearch: DWORD;
  end;

  PServerInfo1524 = ^TServerInfo1524;
  TServerInfo1524 = record
    sv1524_minkeepcomplsearch: DWORD;
  end;

  PServerInfo1525 = ^TServerInfo1525;
  TServerInfo1525 = record
    sv1525_maxkeepcomplsearch: DWORD;
  end;

  PServerInfo1528 = ^TServerInfo1528;
  TServerInfo1528 = record
    sv1528_scavtimeout: DWORD;
  end;

  PServerInfo1529 = ^TServerInfo1529;
  TServerInfo1529 = record
    sv1529_minrcvqueue: DWORD;
  end;

  PServerInfo1530 = ^TServerInfo1530;
  TServerInfo1530 = record
    sv1530_minfreeworkitems: DWORD;
  end;

  PServerInfo1533 = ^TServerInfo1533;
  TServerInfo1533 = record
    sv1533_maxmpxct: DWORD;
  end;

  PServerInfo1534 = ^TServerInfo1534;
  TServerInfo1534 = record
    sv1534_oplockbreakwait: DWORD;
  end;

  PServerInfo1535 = ^TServerInfo1535;
  TServerInfo1535 = record
    sv1535_oplockbreakresponsewait: DWORD;
  end;

  PServerInfo1536 = ^TServerInfo1536;
  TServerInfo1536 = record
    sv1536_enableoplocks: BOOL;
  end;

  PServerInfo1537 = ^TServerInfo1537;
  TServerInfo1537 = record
    sv1537_enableoplockforceclose: BOOL;
  end;

  PServerInfo1538 = ^TServerInfo1538;
  TServerInfo1538 = record
    sv1538_enablefcbopens: BOOL;
  end;

  PServerInfo1539 = ^TServerInfo1539;
  TServerInfo1539 = record
    sv1539_enableraw: BOOL;
  end;

  PServerInfo1540 = ^TServerInfo1540;
  TServerInfo1540 = record
    sv1540_enablesharednetdrives: BOOL;
  end;

  PServerInfo1541 = ^TServerInfo1541;
  TServerInfo1541 = record
    sv1541_minfreeconnections: BOOL;
  end;

  PServerInfo1542 = ^TServerInfo1542;
  TServerInfo1542 = record
    sv1542_maxfreeconnections: BOOL;
  end;

  PServerInfo1543 = ^TServerInfo1543;
  TServerInfo1543 = record
    sv1543_initsesstable: DWORD;
  end;

  PServerInfo1544 = ^TServerInfo1544;
  TServerInfo1544 = record
    sv1544_initconntable: DWORD;
  end;

  PServerInfo1545 = ^TServerInfo1545;
  TServerInfo1545 = record
    sv1545_initfiletable: DWORD;
  end;

  PServerInfo1546 = ^TServerInfo1546;
  TServerInfo1546 = record
    sv1546_initsearchtable: DWORD;
  end;

  PServerInfo1547 = ^TServerInfo1547;
  TServerInfo1547 = record
    sv1547_alertschedule: DWORD;
  end;

  PServerInfo1548 = ^TServerInfo1548;
  TServerInfo1548 = record
    sv1548_errorthreshold: DWORD;
  end;

  PServerInfo1549 = ^TServerInfo1549;
  TServerInfo1549 = record
    sv1549_networkerrorthreshold: DWORD;
  end;

  PServerInfo1550 = ^TServerInfo1550;
  TServerInfo1550 = record
    sv1550_diskspacethreshold: DWORD;
  end;

  PServerInfo1552 = ^TServerInfo1552;
  TServerInfo1552 = record
    sv1552_maxlinkdelay: DWORD;
  end;

  PServerInfo1553 = ^TServerInfo1553;
  TServerInfo1553 = record
    sv1553_minlinkthroughput: DWORD;
  end;

  PServerInfo1554 = ^TServerInfo1554;
  TServerInfo1554 = record
    sv1554_linkinfovalidtime: DWORD;
  end;

  PServerInfo1555 = ^TServerInfo1555;
  TServerInfo1555 = record
    sv1555_scavqosinfoupdatetime: DWORD;
  end;

  PServerInfo1556 = ^TServerInfo1556;
  TServerInfo1556 = record
    sv1556_maxworkitemidletime: DWORD;
  end;

  PServerInfo1557 = ^TServerInfo1557;
  TServerInfo1557 = record
    sv1557_maxrawworkitems: DWORD;
  end;

  PServerInfo1560 = ^TServerInfo1560;
  TServerInfo1560 = record
    sv1560_producttype: DWORD;
  end;

  PServerInfo1561 = ^TServerInfo1561;
  TServerInfo1561 = record
    sv1561_serversize: DWORD;
  end;

  PServerInfo1562 = ^TServerInfo1562;
  TServerInfo1562 = record
    sv1562_connectionlessautodisc: DWORD;
  end;

  PServerInfo1563 = ^TServerInfo1563;
  TServerInfo1563 = record
    sv1563_sharingviolationretries: DWORD;
  end;

  PServerInfo1564 = ^TServerInfo1564;
  TServerInfo1564 = record
    sv1564_sharingviolationdelay: DWORD;
  end;

  PServerInfo1565 = ^TServerInfo1565;
  TServerInfo1565 = record
    sv1565_maxglobalopensearch: DWORD;
  end;

  PServerInfo1566 = ^TServerInfo1566;
  TServerInfo1566 = record
    sv1566_removeduplicatesearches: BOOL;
  end;

  PServerInfo1567 = ^TServerInfo1567;
  TServerInfo1567 = record
    sv1567_lockviolationretries: DWORD;
  end;

  PServerInfo1568 = ^TServerInfo1568;
  TServerInfo1568 = record
    sv1568_lockviolationoffset: DWORD;
  end;

  PServerInfo1569 = ^TServerInfo1569;
  TServerInfo1569 = record
    sv1569_lockviolationdelay: DWORD;
  end;

  PServerInfo1570 = ^TServerInfo1570;
  TServerInfo1570 = record
    sv1570_mdlreadswitchover: DWORD;
  end;

  PServerInfo1571 = ^TServerInfo1571;
  TServerInfo1571 = record
    sv1571_cachedopenlimit: DWORD;
  end;

  PServerInfo1572 = ^TServerInfo1572;
  TServerInfo1572 = record
    sv1572_criticalthreads: DWORD;
  end;

  PServerInfo1573 = ^TServerInfo1573;
  TServerInfo1573 = record
    sv1573_restrictnullsessaccess: DWORD;
  end;

  PServerInfo1574 = ^TServerInfo1574;
  TServerInfo1574 = record
    sv1574_enablewfw311directipx: DWORD;
  end;

  PServerInfo1575 = ^TServerInfo1575;
  TServerInfo1575 = record
    sv1575_otherqueueaffinity: DWORD;
  end;

  PServerInfo1576 = ^TServerInfo1576;
  TServerInfo1576 = record
    sv1576_queuesamplesecs: DWORD;
  end;

  PServerInfo1577 = ^TServerInfo1577;
  TServerInfo1577 = record
    sv1577_balancecount: DWORD;
  end;

  PServerInfo1578 = ^TServerInfo1578;
  TServerInfo1578 = record
    sv1578_preferredaffinity: DWORD;
  end;

  PServerInfo1579 = ^TServerInfo1579;
  TServerInfo1579 = record
    sv1579_maxfreerfcbs: DWORD;
  end;

  PServerInfo1580 = ^TServerInfo1580;
  TServerInfo1580 = record
    sv1580_maxfreemfcbs: DWORD;
  end;

  PServerInfo1581 = ^TServerInfo1581;
  TServerInfo1581 = record
    sv1581_maxfreemlcbs: DWORD;
  end;

  PServerInfo1582 = ^TServerInfo1582;
  TServerInfo1582 = record
    sv1582_maxfreepagedpoolchunks: DWORD;
  end;

  PServerInfo1583 = ^TServerInfo1583;
  TServerInfo1583 = record
    sv1583_minpagedpoolchunksize: DWORD;
  end;

  PServerInfo1584 = ^TServerInfo1584;
  TServerInfo1584 = record
    sv1584_maxpagedpoolchunksize: DWORD;
  end;

  PServerInfo1585 = ^TServerInfo1585;
  TServerInfo1585 = record
    sv1585_sendsfrompreferredprocessor: BOOL;
  end;

  PServerInfo1586 = ^TServerInfo1586;
  TServerInfo1586 = record
    sv1586_maxthreadsperqueue: DWORD;
  end;

  PServerInfo1587 = ^TServerInfo1587;
  TServerInfo1587 = record
    sv1587_cacheddirectorylimit: DWORD;
  end;

  PServerInfo1588 = ^TServerInfo1588;
  TServerInfo1588 = record
    sv1588_maxcopylength: DWORD;
  end;

  PServerInfo1590 = ^TServerInfo1590;
  TServerInfo1590 = record
    sv1590_enablecompression: DWORD;
  end;

  PServerInfo1591 = ^TServerInfo1591;
  TServerInfo1591 = record
    sv1591_autosharewks: DWORD;
  end;

  PServerInfo1592 = ^TServerInfo1592;
  TServerInfo1592 = record
    sv1592_autosharewks: DWORD;
  end;

  PServerInfo1593 = ^TServerInfo1593;
  TServerInfo1593 = record
    sv1593_enablesecuritysignature: DWORD;
  end;

  PServerInfo1594 = ^TServerInfo1594;
  TServerInfo1594 = record
    sv1594_requiresecuritysignature: DWORD;
  end;

  PServerInfo1595 = ^TServerInfo1595;
  TServerInfo1595 = record
    sv1595_minclientbuffersize: DWORD;
  end;

  PServerInfo1596 = ^TServerInfo1596;
  TServerInfo1596 = record
    sv1596_ConnectionNoSessionsTimeout: DWORD;
  end;

  PServerInfo1597 = ^TServerInfo1597;
  TServerInfo1597 = record
    sv1597_IdleThreadTimeOut: DWORD;
  end;

  PServerInfo1598 = ^TServerInfo1598;
  TServerInfo1598 = record
    sv1598_enableW9xsecuritysignature: DWORD;
  end;

  PServerInfo1599 = ^TServerInfo1599;
  TServerInfo1599 = record
    sv1598_enforcekerberosreauthentication: BOOLEAN;
  end;

  PServerInfo1600 = ^TServerInfo1600;
  TServerInfo1600 = record
    sv1598_disabledos: BOOLEAN;
  end;

  PServerInfo1601 = ^TServerInfo1601;
  TServerInfo1601 = record
    sv1598_lowdiskspaceminimum: DWORD;
  end;

  PServerInfo1602 = ^TServerInfo1602;
  TServerInfo1602 = record
    sv_1598_disablestrictnamechecking: BOOL;
  end;

{ A special structure definition is required in order for this
  structure to work with RPC.  The problem is that having addresslength
  indicate the number of bytes in address means that RPC must know the
  link between the two. }

  PServerTransportInfo0 = ^TServerTransportInfo0;
  TServerTransportInfo0 = record
    svti0_numberofvcs: DWORD;
    svti0_transportname: LPWSTR;
    svti0_transportaddress: Pointer;
    svti0_transportaddresslength: DWORD;
    svti0_networkaddress: LPWSTR;
  end;

  PServerTransportInfo1 = ^TServerTransportInfo1;
  TServerTransportInfo1 = record
    svti1_numberofvcs: DWORD;
    svti1_transportname: LPWSTR;
    svti1_transportaddress: Pointer;
    svti1_transportaddresslength: DWORD;
    svti1_networkaddress: LPWSTR;
    svti1_domain: LPWSTR;
  end;

  PServerTransportInfo2 = ^TServerTransportInfo2;
  TServerTransportInfo2 = record
    svti2_numberofvcs: DWORD;
    svti2_transportname: LPWSTR;
    svti2_transportaddress: Pointer;
    svti2_transportaddresslength: DWORD;
    svti2_networkaddress: LPWSTR;
    svti2_domain: LPWSTR;
    svti2_flags: ULONG;
  end;

  PServerTransportInfo3 = ^TServerTransportInfo3;
  TServerTransportInfo3 = record
    svti3_numberofvcs: DWORD;
    svti3_transportname: LPWSTR;
    svti3_transportaddress: Pointer;
    svti3_transportaddresslength: DWORD;
    svti3_networkaddress: LPWSTR;
    svti3_domain: LPWSTR;
    svti3_flags: ULONG;
    svti3_passwordlength: DWORD;
    svti3_password: array [0..255] of Byte;
  end;

{ Defines - SERVER }

const

{ The platform ID indicates the levels to use for platform-specific
  information. }

  SV_PLATFORM_ID_OS2 = 400;
  SV_PLATFORM_ID_NT  = 500;

{ Mask to be applied to svX_version_major in order to obtain
  the major version number. }

  MAJOR_VERSION_MASK = $0F;

{ Bit-mapped values for svX_type fields. X = 1, 2 or 3. }

  SV_TYPE_WORKSTATION       = $00000001;
  SV_TYPE_SERVER            = $00000002;
  SV_TYPE_SQLSERVER         = $00000004;
  SV_TYPE_DOMAIN_CTRL       = $00000008;
  SV_TYPE_DOMAIN_BAKCTRL    = $00000010;
  SV_TYPE_TIME_SOURCE       = $00000020;
  SV_TYPE_AFP               = $00000040;
  SV_TYPE_NOVELL            = $00000080;
  SV_TYPE_DOMAIN_MEMBER     = $00000100;
  SV_TYPE_PRINTQ_SERVER     = $00000200;
  SV_TYPE_DIALIN_SERVER     = $00000400;
  SV_TYPE_XENIX_SERVER      = $00000800;
  SV_TYPE_SERVER_UNIX       = SV_TYPE_XENIX_SERVER;
  SV_TYPE_NT                = $00001000;
  SV_TYPE_WFW               = $00002000;
  SV_TYPE_SERVER_MFPN       = $00004000;
  SV_TYPE_SERVER_NT         = $00008000;
  SV_TYPE_POTENTIAL_BROWSER = $00010000;
  SV_TYPE_BACKUP_BROWSER    = $00020000;
  SV_TYPE_MASTER_BROWSER    = $00040000;
  SV_TYPE_DOMAIN_MASTER     = $00080000;
  SV_TYPE_SERVER_OSF        = $00100000;
  SV_TYPE_SERVER_VMS        = $00200000;
  SV_TYPE_WINDOWS           = $00400000; { Windows95 and above }
  SV_TYPE_DFS               = $00800000; { Root of a DFS tree }
  SV_TYPE_CLUSTER_NT        = $01000000; { NT Cluster }
  SV_TYPE_TERMINALSERVER    = $02000000; { Terminal Server(Hydra) }
  SV_TYPE_CLUSTER_VS_NT     = $04000000; { NT Cluster Virtual Server Name }
  SV_TYPE_DCE               = $10000000; { IBM DSS (Directory and Security Services) or equivalent }
  SV_TYPE_ALTERNATE_XPORT   = $20000000; { return list for alternate transport }
  SV_TYPE_LOCAL_LIST_ONLY   = $40000000; { Return local list only }
  SV_TYPE_DOMAIN_ENUM       = $80000000;
  SV_TYPE_ALL               = $FFFFFFFF; { handy for NetServerEnum2 }

{ Special value for sv102_disc that specifies infinite disconnect
  time. }

  SV_NODISC = DWORD(-1); { No autodisconnect timeout enforced }

{ Values of svX_security field. X = 2 or 3. }

  SV_USERSECURITY  = 1;
  SV_SHARESECURITY = 0;

{ Values of svX_hidden field. X = 2 or 3. }

  SV_HIDDEN  = 1;
  SV_VISIBLE = 0;

{ Values for ParmError parameter to NetServerSetInfo. }

  SV_PLATFORM_ID_PARMNUM   = 101;
  SV_NAME_PARMNUM          = 102;
  SV_VERSION_MAJOR_PARMNUM = 103;
  SV_VERSION_MINOR_PARMNUM = 104;
  SV_TYPE_PARMNUM          = 105;
  SV_COMMENT_PARMNUM       = 5;
  SV_USERS_PARMNUM         = 107;
  SV_DISC_PARMNUM          = 10;
  SV_HIDDEN_PARMNUM        = 16;
  SV_ANNOUNCE_PARMNUM      = 17;
  SV_ANNDELTA_PARMNUM      = 18;
  SV_USERPATH_PARMNUM      = 112;

  SV_ULIST_MTIME_PARMNUM   = 401;
  SV_GLIST_MTIME_PARMNUM   = 402;
  SV_ALIST_MTIME_PARMNUM   = 403;
  SV_ALERTS_PARMNUM        = 11;
  SV_SECURITY_PARMNUM      = 405;
  SV_NUMADMIN_PARMNUM      = 406;
  SV_LANMASK_PARMNUM       = 407;
  SV_GUESTACC_PARMNUM      = 408;
  SV_CHDEVQ_PARMNUM        = 410;
  SV_CHDEVJOBS_PARMNUM     = 411;
  SV_CONNECTIONS_PARMNUM   = 412;
  SV_SHARES_PARMNUM        = 413;
  SV_OPENFILES_PARMNUM     = 414;
  SV_SESSREQS_PARMNUM      = 417;
  SV_ACTIVELOCKS_PARMNUM   = 419;
  SV_NUMREQBUF_PARMNUM     = 420;
  SV_NUMBIGBUF_PARMNUM     = 422;
  SV_NUMFILETASKS_PARMNUM  = 423;
  SV_ALERTSCHED_PARMNUM    = 37;
  SV_ERRORALERT_PARMNUM    = 38;
  SV_LOGONALERT_PARMNUM    = 39;
  SV_ACCESSALERT_PARMNUM   = 40;
  SV_DISKALERT_PARMNUM     = 41;
  SV_NETIOALERT_PARMNUM    = 42;
  SV_MAXAUDITSZ_PARMNUM    = 43;
  SV_SRVHEURISTICS_PARMNUM = 431;

  SV_SESSOPENS_PARMNUM                       = 501;
  SV_SESSVCS_PARMNUM                         = 502;
  SV_OPENSEARCH_PARMNUM                      = 503;
  SV_SIZREQBUF_PARMNUM                       = 504;
  SV_INITWORKITEMS_PARMNUM                   = 505;
  SV_MAXWORKITEMS_PARMNUM                    = 506;
  SV_RAWWORKITEMS_PARMNUM                    = 507;
  SV_IRPSTACKSIZE_PARMNUM                    = 508;
  SV_MAXRAWBUFLEN_PARMNUM                    = 509;
  SV_SESSUSERS_PARMNUM                       = 510;
  SV_SESSCONNS_PARMNUM                       = 511;
  SV_MAXNONPAGEDMEMORYUSAGE_PARMNUM          = 512;
  SV_MAXPAGEDMEMORYUSAGE_PARMNUM             = 513;
  SV_ENABLESOFTCOMPAT_PARMNUM                = 514;
  SV_ENABLEFORCEDLOGOFF_PARMNUM              = 515;
  SV_TIMESOURCE_PARMNUM                      = 516;
  SV_ACCEPTDOWNLEVELAPIS_PARMNUM             = 517;
  SV_LMANNOUNCE_PARMNUM                      = 518;
  SV_DOMAIN_PARMNUM                          = 519;
  SV_MAXCOPYREADLEN_PARMNUM                  = 520;
  SV_MAXCOPYWRITELEN_PARMNUM                 = 521;
  SV_MINKEEPSEARCH_PARMNUM                   = 522;
  SV_MAXKEEPSEARCH_PARMNUM                   = 523;
  SV_MINKEEPCOMPLSEARCH_PARMNUM              = 524;
  SV_MAXKEEPCOMPLSEARCH_PARMNUM              = 525;
  SV_THREADCOUNTADD_PARMNUM                  = 526;
  SV_NUMBLOCKTHREADS_PARMNUM                 = 527;
  SV_SCAVTIMEOUT_PARMNUM                     = 528;
  SV_MINRCVQUEUE_PARMNUM                     = 529;
  SV_MINFREEWORKITEMS_PARMNUM                = 530;
  SV_XACTMEMSIZE_PARMNUM                     = 531;
  SV_THREADPRIORITY_PARMNUM                  = 532;
  SV_MAXMPXCT_PARMNUM                        = 533;
  SV_OPLOCKBREAKWAIT_PARMNUM                 = 534;
  SV_OPLOCKBREAKRESPONSEWAIT_PARMNUM         = 535;
  SV_ENABLEOPLOCKS_PARMNUM                   = 536;
  SV_ENABLEOPLOCKFORCECLOSE_PARMNUM          = 537;
  SV_ENABLEFCBOPENS_PARMNUM                  = 538;
  SV_ENABLERAW_PARMNUM                       = 539;
  SV_ENABLESHAREDNETDRIVES_PARMNUM           = 540;
  SV_MINFREECONNECTIONS_PARMNUM              = 541;
  SV_MAXFREECONNECTIONS_PARMNUM              = 542;
  SV_INITSESSTABLE_PARMNUM                   = 543;
  SV_INITCONNTABLE_PARMNUM                   = 544;
  SV_INITFILETABLE_PARMNUM                   = 545;
  SV_INITSEARCHTABLE_PARMNUM                 = 546;
  SV_ALERTSCHEDULE_PARMNUM                   = 547;
  SV_ERRORTHRESHOLD_PARMNUM                  = 548;
  SV_NETWORKERRORTHRESHOLD_PARMNUM           = 549;
  SV_DISKSPACETHRESHOLD_PARMNUM              = 550;
  SV_MAXLINKDELAY_PARMNUM                    = 552;
  SV_MINLINKTHROUGHPUT_PARMNUM               = 553;
  SV_LINKINFOVALIDTIME_PARMNUM               = 554;
  SV_SCAVQOSINFOUPDATETIME_PARMNUM           = 555;
  SV_MAXWORKITEMIDLETIME_PARMNUM             = 556;
  SV_MAXRAWWORKITEMS_PARMNUM                 = 557;
  SV_PRODUCTTYPE_PARMNUM                     = 560;
  SV_SERVERSIZE_PARMNUM                      = 561;
  SV_CONNECTIONLESSAUTODISC_PARMNUM          = 562;
  SV_SHARINGVIOLATIONRETRIES_PARMNUM         = 563;
  SV_SHARINGVIOLATIONDELAY_PARMNUM           = 564;
  SV_MAXGLOBALOPENSEARCH_PARMNUM             = 565;
  SV_REMOVEDUPLICATESEARCHES_PARMNUM         = 566;
  SV_LOCKVIOLATIONRETRIES_PARMNUM            = 567;
  SV_LOCKVIOLATIONOFFSET_PARMNUM             = 568;
  SV_LOCKVIOLATIONDELAY_PARMNUM              = 569;
  SV_MDLREADSWITCHOVER_PARMNUM               = 570;
  SV_CACHEDOPENLIMIT_PARMNUM                 = 571;
  SV_CRITICALTHREADS_PARMNUM                 = 572;
  SV_RESTRICTNULLSESSACCESS_PARMNUM          = 573;
  SV_ENABLEWFW311DIRECTIPX_PARMNUM           = 574;
  SV_OTHERQUEUEAFFINITY_PARMNUM              = 575;
  SV_QUEUESAMPLESECS_PARMNUM                 = 576;
  SV_BALANCECOUNT_PARMNUM                    = 577;
  SV_PREFERREDAFFINITY_PARMNUM               = 578;
  SV_MAXFREERFCBS_PARMNUM                    = 579;
  SV_MAXFREEMFCBS_PARMNUM                    = 580;
  SV_MAXFREELFCBS_PARMNUM                    = 581;
  SV_MAXFREEPAGEDPOOLCHUNKS_PARMNUM          = 582;
  SV_MINPAGEDPOOLCHUNKSIZE_PARMNUM           = 583;
  SV_MAXPAGEDPOOLCHUNKSIZE_PARMNUM           = 584;
  SV_SENDSFROMPREFERREDPROCESSOR_PARMNUM     = 585;
  SV_MAXTHREADSPERQUEUE_PARMNUM              = 586;
  SV_CACHEDDIRECTORYLIMIT_PARMNUM            = 587;
  SV_MAXCOPYLENGTH_PARMNUM                   = 588;
  SV_ENABLECOMPRESSION_PARMNUM               = 590;
  SV_AUTOSHAREWKS_PARMNUM                    = 591;
  SV_AUTOSHARESERVER_PARMNUM                 = 592;
  SV_ENABLESECURITYSIGNATURE_PARMNUM         = 593;
  SV_REQUIRESECURITYSIGNATURE_PARMNUM        = 594;
  SV_MINCLIENTBUFFERSIZE_PARMNUM             = 595;
  SV_CONNECTIONNOSESSIONSTIMEOUT_PARMNUM     = 596;
  SV_IDLETHREADTIMEOUT_PARMNUM               = 597;
  SV_ENABLEW9XSECURITYSIGNATURE_PARMNUM      = 598;
  SV_ENFORCEKERBEROSREAUTHENTICATION_PARMNUM = 599;
  SV_DISABLEDOS_PARMNUM                      = 600;
  SV_LOWDISKSPACEMINIMUM_PARMNUM             = 601;
  SV_DISABLESTRICTNAMECHECKING_PARMNUM       = 602;
  SV_ENABLEAUTHENTICATEUSERSHARING_PARMNUM   = 603;

{ Single-field infolevels for NetServerSetInfo. }

  SV_COMMENT_INFOLEVEL                         = PARMNUM_BASE_INFOLEVEL + SV_COMMENT_PARMNUM;
  SV_USERS_INFOLEVEL                           = PARMNUM_BASE_INFOLEVEL + SV_USERS_PARMNUM;
  SV_DISC_INFOLEVEL                            = PARMNUM_BASE_INFOLEVEL + SV_DISC_PARMNUM;
  SV_HIDDEN_INFOLEVEL                          = PARMNUM_BASE_INFOLEVEL + SV_HIDDEN_PARMNUM;
  SV_ANNOUNCE_INFOLEVEL                        = PARMNUM_BASE_INFOLEVEL + SV_ANNOUNCE_PARMNUM;
  SV_ANNDELTA_INFOLEVEL                        = PARMNUM_BASE_INFOLEVEL + SV_ANNDELTA_PARMNUM;
  SV_SESSOPENS_INFOLEVEL                       = PARMNUM_BASE_INFOLEVEL + SV_SESSOPENS_PARMNUM;
  SV_SESSVCS_INFOLEVEL                         = PARMNUM_BASE_INFOLEVEL + SV_SESSVCS_PARMNUM;
  SV_OPENSEARCH_INFOLEVEL                      = PARMNUM_BASE_INFOLEVEL + SV_OPENSEARCH_PARMNUM;
  SV_MAXWORKITEMS_INFOLEVEL                    = PARMNUM_BASE_INFOLEVEL + SV_MAXWORKITEMS_PARMNUM;
  SV_MAXRAWBUFLEN_INFOLEVEL                    = PARMNUM_BASE_INFOLEVEL + SV_MAXRAWBUFLEN_PARMNUM;
  SV_SESSUSERS_INFOLEVEL                       = PARMNUM_BASE_INFOLEVEL + SV_SESSUSERS_PARMNUM;
  SV_SESSCONNS_INFOLEVEL                       = PARMNUM_BASE_INFOLEVEL + SV_SESSCONNS_PARMNUM;
  SV_MAXNONPAGEDMEMORYUSAGE_INFOLEVEL          = PARMNUM_BASE_INFOLEVEL + SV_MAXNONPAGEDMEMORYUSAGE_PARMNUM;
  SV_MAXPAGEDMEMORYUSAGE_INFOLEVEL             = PARMNUM_BASE_INFOLEVEL + SV_MAXPAGEDMEMORYUSAGE_PARMNUM;
  SV_ENABLESOFTCOMPAT_INFOLEVEL                = PARMNUM_BASE_INFOLEVEL + SV_ENABLESOFTCOMPAT_PARMNUM;
  SV_ENABLEFORCEDLOGOFF_INFOLEVEL              = PARMNUM_BASE_INFOLEVEL + SV_ENABLEFORCEDLOGOFF_PARMNUM;
  SV_TIMESOURCE_INFOLEVEL                      = PARMNUM_BASE_INFOLEVEL + SV_TIMESOURCE_PARMNUM;
  SV_LMANNOUNCE_INFOLEVEL                      = PARMNUM_BASE_INFOLEVEL + SV_LMANNOUNCE_PARMNUM;
  SV_MAXCOPYREADLEN_INFOLEVEL                  = PARMNUM_BASE_INFOLEVEL + SV_MAXCOPYREADLEN_PARMNUM;
  SV_MAXCOPYWRITELEN_INFOLEVEL                 = PARMNUM_BASE_INFOLEVEL + SV_MAXCOPYWRITELEN_PARMNUM;
  SV_MINKEEPSEARCH_INFOLEVEL                   = PARMNUM_BASE_INFOLEVEL + SV_MINKEEPSEARCH_PARMNUM;
  SV_MAXKEEPSEARCH_INFOLEVEL                   = PARMNUM_BASE_INFOLEVEL + SV_MAXKEEPSEARCH_PARMNUM;
  SV_MINKEEPCOMPLSEARCH_INFOLEVEL              = PARMNUM_BASE_INFOLEVEL + SV_MINKEEPCOMPLSEARCH_PARMNUM;
  SV_MAXKEEPCOMPLSEARCH_INFOLEVEL              = PARMNUM_BASE_INFOLEVEL + SV_MAXKEEPCOMPLSEARCH_PARMNUM;
  SV_SCAVTIMEOUT_INFOLEVEL                     = PARMNUM_BASE_INFOLEVEL + SV_SCAVTIMEOUT_PARMNUM;
  SV_MINRCVQUEUE_INFOLEVEL                     = PARMNUM_BASE_INFOLEVEL + SV_MINRCVQUEUE_PARMNUM;
  SV_MINFREEWORKITEMS_INFOLEVEL                = PARMNUM_BASE_INFOLEVEL + SV_MINFREEWORKITEMS_PARMNUM;
  SV_MAXMPXCT_INFOLEVEL                        = PARMNUM_BASE_INFOLEVEL + SV_MAXMPXCT_PARMNUM;
  SV_OPLOCKBREAKWAIT_INFOLEVEL                 = PARMNUM_BASE_INFOLEVEL + SV_OPLOCKBREAKWAIT_PARMNUM;
  SV_OPLOCKBREAKRESPONSEWAIT_INFOLEVEL         = PARMNUM_BASE_INFOLEVEL + SV_OPLOCKBREAKRESPONSEWAIT_PARMNUM;
  SV_ENABLEOPLOCKS_INFOLEVEL                   = PARMNUM_BASE_INFOLEVEL + SV_ENABLEOPLOCKS_PARMNUM;
  SV_ENABLEOPLOCKFORCECLOSE_INFOLEVEL          = PARMNUM_BASE_INFOLEVEL + SV_ENABLEOPLOCKFORCECLOSE_PARMNUM;
  SV_ENABLEFCBOPENS_INFOLEVEL                  = PARMNUM_BASE_INFOLEVEL + SV_ENABLEFCBOPENS_PARMNUM;
  SV_ENABLERAW_INFOLEVEL                       = PARMNUM_BASE_INFOLEVEL + SV_ENABLERAW_PARMNUM;
  SV_ENABLESHAREDNETDRIVES_INFOLEVEL           = PARMNUM_BASE_INFOLEVEL + SV_ENABLESHAREDNETDRIVES_PARMNUM;
  SV_MINFREECONNECTIONS_INFOLEVEL              = PARMNUM_BASE_INFOLEVEL + SV_MINFREECONNECTIONS_PARMNUM;
  SV_MAXFREECONNECTIONS_INFOLEVEL              = PARMNUM_BASE_INFOLEVEL + SV_MAXFREECONNECTIONS_PARMNUM;
  SV_INITSESSTABLE_INFOLEVEL                   = PARMNUM_BASE_INFOLEVEL + SV_INITSESSTABLE_PARMNUM;
  SV_INITCONNTABLE_INFOLEVEL                   = PARMNUM_BASE_INFOLEVEL + SV_INITCONNTABLE_PARMNUM;
  SV_INITFILETABLE_INFOLEVEL                   = PARMNUM_BASE_INFOLEVEL + SV_INITFILETABLE_PARMNUM;
  SV_INITSEARCHTABLE_INFOLEVEL                 = PARMNUM_BASE_INFOLEVEL + SV_INITSEARCHTABLE_PARMNUM;
  SV_ALERTSCHEDULE_INFOLEVEL                   = PARMNUM_BASE_INFOLEVEL + SV_ALERTSCHEDULE_PARMNUM;
  SV_ERRORTHRESHOLD_INFOLEVEL                  = PARMNUM_BASE_INFOLEVEL + SV_ERRORTHRESHOLD_PARMNUM;
  SV_NETWORKERRORTHRESHOLD_INFOLEVEL           = PARMNUM_BASE_INFOLEVEL + SV_NETWORKERRORTHRESHOLD_PARMNUM;
  SV_DISKSPACETHRESHOLD_INFOLEVEL              = PARMNUM_BASE_INFOLEVEL + SV_DISKSPACETHRESHOLD_PARMNUM;
  SV_MAXLINKDELAY_INFOLEVEL                    = PARMNUM_BASE_INFOLEVEL + SV_MAXLINKDELAY_PARMNUM;
  SV_MINLINKTHROUGHPUT_INFOLEVEL               = PARMNUM_BASE_INFOLEVEL + SV_MINLINKTHROUGHPUT_PARMNUM;
  SV_LINKINFOVALIDTIME_INFOLEVEL               = PARMNUM_BASE_INFOLEVEL + SV_LINKINFOVALIDTIME_PARMNUM;
  SV_SCAVQOSINFOUPDATETIME_INFOLEVEL           = PARMNUM_BASE_INFOLEVEL + SV_SCAVQOSINFOUPDATETIME_PARMNUM;
  SV_MAXWORKITEMIDLETIME_INFOLEVEL             = PARMNUM_BASE_INFOLEVEL + SV_MAXWORKITEMIDLETIME_PARMNUM;
  SV_MAXRAWWORKITEMS_INFOLOEVEL                = PARMNUM_BASE_INFOLEVEL + SV_MAXRAWWORKITEMS_PARMNUM;
  SV_PRODUCTTYPE_INFOLOEVEL                    = PARMNUM_BASE_INFOLEVEL + SV_PRODUCTTYPE_PARMNUM;
  SV_SERVERSIZE_INFOLOEVEL                     = PARMNUM_BASE_INFOLEVEL + SV_SERVERSIZE_PARMNUM;
  SV_CONNECTIONLESSAUTODISC_INFOLOEVEL         = PARMNUM_BASE_INFOLEVEL + SV_CONNECTIONLESSAUTODISC_PARMNUM;
  SV_SHARINGVIOLATIONRETRIES_INFOLOEVEL        = PARMNUM_BASE_INFOLEVEL + SV_SHARINGVIOLATIONRETRIES_PARMNUM;
  SV_SHARINGVIOLATIONDELAY_INFOLOEVEL          = PARMNUM_BASE_INFOLEVEL + SV_SHARINGVIOLATIONDELAY_PARMNUM;
  SV_MAXGLOBALOPENSEARCH_INFOLOEVEL            = PARMNUM_BASE_INFOLEVEL + SV_MAXGLOBALOPENSEARCH_PARMNUM;
  SV_REMOVEDUPLICATESEARCHES_INFOLOEVEL        = PARMNUM_BASE_INFOLEVEL + SV_REMOVEDUPLICATESEARCHES_PARMNUM;
  SV_LOCKVIOLATIONRETRIES_INFOLOEVEL           = PARMNUM_BASE_INFOLEVEL + SV_LOCKVIOLATIONRETRIES_PARMNUM;
  SV_LOCKVIOLATIONOFFSET_INFOLOEVEL            = PARMNUM_BASE_INFOLEVEL + SV_LOCKVIOLATIONOFFSET_PARMNUM;
  SV_LOCKVIOLATIONDELAY_INFOLOEVEL             = PARMNUM_BASE_INFOLEVEL + SV_LOCKVIOLATIONDELAY_PARMNUM;
  SV_MDLREADSWITCHOVER_INFOLOEVEL              = PARMNUM_BASE_INFOLEVEL + SV_MDLREADSWITCHOVER_PARMNUM;
  SV_CACHEDOPENLIMIT_INFOLOEVEL                = PARMNUM_BASE_INFOLEVEL + SV_CACHEDOPENLIMIT_PARMNUM;
  SV_CRITICALTHREADS_INFOLOEVEL                = PARMNUM_BASE_INFOLEVEL + SV_CRITICALTHREADS_PARMNUM;
  SV_RESTRICTNULLSESSACCESS_INFOLOEVEL         = PARMNUM_BASE_INFOLEVEL + SV_RESTRICTNULLSESSACCESS_PARMNUM;
  SV_ENABLEWFW311DIRECTIPX_INFOLOEVEL          = PARMNUM_BASE_INFOLEVEL + SV_ENABLEWFW311DIRECTIPX_PARMNUM;
  SV_OTHERQUEUEAFFINITY_INFOLEVEL              = PARMNUM_BASE_INFOLEVEL + SV_OTHERQUEUEAFFINITY_PARMNUM;
  SV_QUEUESAMPLESECS_INFOLEVEL                 = PARMNUM_BASE_INFOLEVEL + SV_QUEUESAMPLESECS_PARMNUM;
  SV_BALANCECOUNT_INFOLEVEL                    = PARMNUM_BASE_INFOLEVEL + SV_BALANCECOUNT_PARMNUM;
  SV_PREFERREDAFFINITY_INFOLEVEL               = PARMNUM_BASE_INFOLEVEL + SV_PREFERREDAFFINITY_PARMNUM;
  SV_MAXFREERFCBS_INFOLEVEL                    = PARMNUM_BASE_INFOLEVEL + SV_MAXFREERFCBS_PARMNUM;
  SV_MAXFREEMFCBS_INFOLEVEL                    = PARMNUM_BASE_INFOLEVEL + SV_MAXFREEMFCBS_PARMNUM;
  SV_MAXFREELFCBS_INFOLEVEL                    = PARMNUM_BASE_INFOLEVEL + SV_MAXFREELFCBS_PARMNUM;
  SV_MAXFREEPAGEDPOOLCHUNKS_INFOLEVEL          = PARMNUM_BASE_INFOLEVEL + SV_MAXFREEPAGEDPOOLCHUNKS_PARMNUM;
  SV_MINPAGEDPOOLCHUNKSIZE_INFOLEVEL           = PARMNUM_BASE_INFOLEVEL + SV_MINPAGEDPOOLCHUNKSIZE_PARMNUM;
  SV_MAXPAGEDPOOLCHUNKSIZE_INFOLEVEL           = PARMNUM_BASE_INFOLEVEL + SV_MAXPAGEDPOOLCHUNKSIZE_PARMNUM;
  SV_SENDSFROMPREFERREDPROCESSOR_INFOLEVEL     = PARMNUM_BASE_INFOLEVEL + SV_SENDSFROMPREFERREDPROCESSOR_PARMNUM;
  SV_MAXTHREADSPERQUEUE_INFOLEVEL              = PARMNUM_BASE_INFOLEVEL + SV_MAXTHREADSPERQUEUE_PARMNUM;
  SV_CACHEDDIRECTORYLIMIT_INFOLEVEL            = PARMNUM_BASE_INFOLEVEL + SV_CACHEDDIRECTORYLIMIT_PARMNUM;
  SV_MAXCOPYLENGTH_INFOLEVEL                   = PARMNUM_BASE_INFOLEVEL + SV_MAXCOPYLENGTH_PARMNUM;
  SV_ENABLECOMPRESSION_INFOLEVEL               = PARMNUM_BASE_INFOLEVEL + SV_ENABLECOMPRESSION_PARMNUM;
  SV_AUTOSHAREWKS_INFOLEVEL                    = PARMNUM_BASE_INFOLEVEL + SV_AUTOSHAREWKS_PARMNUM;
  SV_AUTOSHARESERVER_INFOLEVEL                 = PARMNUM_BASE_INFOLEVEL + SV_AUTOSHARESERVER_PARMNUM;
  SV_ENABLESECURITYSIGNATURE_INFOLEVEL         = PARMNUM_BASE_INFOLEVEL + SV_ENABLESECURITYSIGNATURE_PARMNUM;
  SV_REQUIRESECURITYSIGNATURE_INFOLEVEL        = PARMNUM_BASE_INFOLEVEL + SV_REQUIRESECURITYSIGNATURE_PARMNUM;
  SV_MINCLIENTBUFFERSIZE_INFOLEVEL             = PARMNUM_BASE_INFOLEVEL + SV_MINCLIENTBUFFERSIZE_PARMNUM;
  SV_CONNECTIONNOSESSIONSTIMEOUT_INFOLEVEL     = PARMNUM_BASE_INFOLEVEL + SV_CONNECTIONNOSESSIONSTIMEOUT_PARMNUM;
  SV_IDLETHREADTIMEOUT_INFOLEVEL               = PARMNUM_BASE_INFOLEVEL + SV_IDLETHREADTIMEOUT_PARMNUM;
  SV_ENABLEW9XSECURITYSIGNATURE_INFOLEVEL      = PARMNUM_BASE_INFOLEVEL + SV_ENABLEW9XSECURITYSIGNATURE_PARMNUM;
  SV_ENFORCEKERBEROSREAUTHENTICATION_INFOLEVEL = PARMNUM_BASE_INFOLEVEL + SV_ENFORCEKERBEROSREAUTHENTICATION_PARMNUM;
  SV_DISABLEDOS_INFOLEVEL                      = PARMNUM_BASE_INFOLEVEL + SV_DISABLEDOS_PARMNUM;
  SV_LOWDISKSPACEMINIMUM_INFOLEVEL             = PARMNUM_BASE_INFOLEVEL + SV_LOWDISKSPACEMINIMUM_PARMNUM;
  SV_DISABLESTRICTNAMECHECKING_INFOLEVEL       = PARMNUM_BASE_INFOLEVEL + SV_DISABLESTRICTNAMECHECKING_PARMNUM;
  SV_ENABLEAUTHENTICATEUSERSHARING_INFOLEVEL   = PARMNUM_BASE_INFOLEVEL + SV_ENABLEAUTHENTICATEUSERSHARING_PARMNUM;  

  SVI1_NUM_ELEMENTS = 5;
  SVI2_NUM_ELEMENTS = 40;
  SVI3_NUM_ELEMENTS = 44;

{ Maxmimum length for command string to NetServerAdminCommand. }

  SV_MAX_CMD_LEN = 256;

{ Masks describing AUTOPROFILE parameters }

  SW_AUTOPROF_LOAD_MASK = $1;
  SW_AUTOPROF_SAVE_MASK = $2;

{ Max size of svX_srvheuristics. }

  SV_MAX_SRV_HEUR_LEN = 32; { Max heuristics info string length. }

{ Equate for use with sv102_licenses. }

  SV_USERS_PER_LICENSE = 5;

{ Equate for use with svti2_flags in NetServerTransportAddEx. }

  SVTI2_REMAP_PIPE_NAMES = $2;
  SVTI2_SCOPED_NAME      = $4;
  SVTI2_VALID_FLAGS      = SVTI2_REMAP_PIPE_NAMES or SVTI2_SCOPED_NAME;

{ Server capability information }

  SRV_SUPPORT_HASH_GENERATION = $0001;
  SRV_HASH_GENERATION_ACTIVE  = $0002;


{ Function Prototypes - Share }

function NetShareAdd(servername: LPWSTR; level: DWORD; buf: Pointer;
  parm_err: LPDWORD): NET_API_STATUS; stdcall;

function NetShareEnum(servername: LPWSTR; level: DWORD;
  var bufptr: Pointer; prefmaxlen: DWORD; entriesread, totalentries,
  resume_handle: LPDWORD): NET_API_STATUS; stdcall;

function NetShareEnumSticky(servername: LPWSTR; level: DWORD;
  var bufptr: Pointer; prefmaxlen: DWORD; entriesread, totalentries,
  resume_handle: LPDWORD): NET_API_STATUS; stdcall;

function NetShareGetInfo(servername, netname: LPWSTR; level: DWORD;
  var bufptr: Pointer): NET_API_STATUS; stdcall;

function NetShareSetInfo(servername, netname: LPWSTR; level: DWORD;
  buf: Pointer; parm_err: LPDWORD): NET_API_STATUS; stdcall;

function NetShareDel(servername, netname: LPWSTR;
  reserved: DWORD): NET_API_STATUS; stdcall;

function NetShareDelSticky(servername, netname: LPWSTR;
  reserved: DWORD): NET_API_STATUS; stdcall;

function NetShareCheck(servername, device: LPWSTR;
  scharetype: LPDWORD): NET_API_STATUS; stdcall;

function NetShareDelEx(servername: LPWSTR; level: DWORD;
  buf: Pointer): NET_API_STATUS; stdcall;

{ Data Structures - Share }

type
  PShareInfo0 = ^TShareInfo0;
  TShareInfo0 = record
    shi0_netname: LPWSTR;
  end;

  PShareInfo1 = ^TShareInfo1;
  TShareInfo1 = record
    shi1_netname: LPWSTR;
    shi1_type: DWORD;
    shi1_remark: LPWSTR;
  end;

  PShareInfo2 = ^TShareInfo2;
  TShareInfo2 = record
    shi2_netname: LPWSTR;
    shi2_type: DWORD;
    shi2_remark: LPWSTR;
    shi2_permissions: DWORD;
    shi2_max_uses: DWORD;
    shi2_current_uses: DWORD;
    shi2_path: LPWSTR;
    shi2_passwd: LPWSTR;
  end;

  PShareInfo501 = ^TShareInfo501;
  TShareInfo501 = record
    shi501_netname: LPWSTR;
    shi501_type: DWORD;
    shi501_remark: LPWSTR;
    shi501_flags: DWORD;
  end;

  PShareInfo502 = ^TShareInfo502;
  TShareInfo502 = record
    shi502_netname: LPWSTR;
    shi502_type: DWORD;
    shi502_remark: LPWSTR;
    shi502_permissions: DWORD;
    shi502_max_uses: DWORD;
    shi502_current_uses: DWORD;
    shi502_path: LPWSTR;
    shi502_passwd: LPWSTR;
    shi502_reserved: DWORD;
    shi502_security_descriptor: PSECURITY_DESCRIPTOR;
  end;

  PShareInfo503 = ^TShareInfo503;
  TShareInfo503 = record
    shi503_netname: LPWSTR;
    shi503_type: DWORD;
    shi503_remark: LPWSTR;
    shi503_permissions: DWORD;
    shi503_max_uses: DWORD;
    shi503_current_uses: DWORD;
    shi503_path: LPWSTR;
    shi503_passwd: LPWSTR;
    shi503_servername: LPWSTR;
    shi503_reserved: DWORD;
    shi503_security_descriptor: PSECURITY_DESCRIPTOR;
  end;

  PShareInfo1004 = ^TShareInfo1004;
  TShareInfo1004 = record
    shi1004_remark: LPWSTR;
  end;

  PShareInfo1005 = ^TShareInfo1005;
  TShareInfo1005 = record
    shi1005_flags: DWORD;
  end;

  PShareInfo1006 = ^TShareInfo1006;
  TShareInfo1006 = record
    shi1006_max_uses: DWORD;
  end;

  PShareInfo1501 = ^TShareInfo1501;
  TShareInfo1501 = record
    shi1501_reserved: DWORD;
    shi1501_security_descriptor: PSECURITY_DESCRIPTOR;
  end;

  PShareInfo1503 = ^TShareInfo1503;
  TShareInfo1503  = record
    shi1503_sharefilter: TGUID;
  end;

{ NetShareAlias functions }

function NetServerAliasAdd(servername: LPWSTR; level: DWORD;
  buf: Pointer): NET_API_STATUS; stdcall;

function NetServerAliasDel(servername: LPWSTR; level: DWORD;
  buf: Pointer): NET_API_STATUS; stdcall;

function NetServerAliasEnum(servername: LPWSTR; level: DWORD;
  var bufptr: Pointer; prefmaxlen: DWORD; entriesread, totalentries,
  resumehandle: LPDWORD): NET_API_STATUS; stdcall;

type
  PServerAliasInfo0 = ^TServerAliasInfo0;
  TServerAliasInfo0 = record
    srvai0_alias: LPWSTR;
    srvai0_target: LPWSTR;
    srvai0_default: Boolean;
    srvai0_reserved: ULONG;
  end;

{ Special Values and Constants - Share }

const

{ Values for parm_err parameter. }

  SHARE_NETNAME_PARMNUM      = 1;
  SHARE_TYPE_PARMNUM         = 3;
  SHARE_REMARK_PARMNUM       = 4;
  SHARE_PERMISSIONS_PARMNUM  = 5;
  SHARE_MAX_USES_PARMNUM     = 6;
  SHARE_CURRENT_USES_PARMNUM = 7;
  SHARE_PATH_PARMNUM         = 8;
  SHARE_PASSWD_PARMNUM       = 9;
  SHARE_FILE_SD_PARMNUM      = 501;
  SHARE_SERVER_PARMNUM       = 503;

{ Single-field infolevels for NetShareSetInfo. }

  SHARE_REMARK_INFOLEVEL   = PARMNUM_BASE_INFOLEVEL + SHARE_REMARK_PARMNUM;
  SHARE_MAX_USES_INFOLEVEL = PARMNUM_BASE_INFOLEVEL + SHARE_MAX_USES_PARMNUM;
  SHARE_FILE_SD_INFOLEVEL  = PARMNUM_BASE_INFOLEVEL + SHARE_FILE_SD_PARMNUM;

  SHI1_NUM_ELEMENTS = 4;
  SHI2_NUM_ELEMENTS = 10;

{ Share types (shi1_type and shi2_type fields). }

  STYPE_DISKTREE     = 0;
  STYPE_PRINTQ       = 1;
  STYPE_DEVICE       = 2;
  STYPE_IPC          = 3;

  STYPE_TEMPORARY    = $40000000;
  STYPE_SPECIAL      = $80000000;

  SHI_USES_UNLIMITED = DWORD(-1);

{ Flags values for the 501 and 1005 levels }

  SHI1005_FLAGS_DFS      = $01; { Share is in the DFS }
  SHI1005_FLAGS_DFS_ROOT = $02; { Share is root of DFS }

  CSC_MASK               = $30; { Used to mask off the following states }

  CSC_CACHE_MANUAL_REINT = $00; { No automatic file by file reintegration }
  CSC_CACHE_AUTO_REINT   = $10; { File by file reintegration is OK }
  CSC_CACHE_VDO          = $20; { no need to flow opens }
  CSC_CACHE_NONE         = $30; { no CSC for this share }

  SHI1005_FLAGS_RESTRICT_EXCLUSIVE_OPENS    = $0100; { Used to disallow read-deny read behavior }
  SHI1005_FLAGS_FORCE_SHARED_DELETE         = $0200; { Used to allows force shared delete }
  SHI1005_FLAGS_ALLOW_NAMESPACE_CACHING     = $0400; { The clients may cache the namespace }
  SHI1005_FLAGS_ACCESS_BASED_DIRECTORY_ENUM = $0800; { Trim visible files in enumerations based on access }
  SHI1005_FLAGS_FORCE_LEVELII_OPLOCK        = $1000; { Only issue level2 oplock }
  SHI1005_FLAGS_ENABLE_HASH                 = $2000; { Enable hash generation and retrieval requests from share }

{ The subset of 1005 infolevel flags that can be set via the API }

  SHI1005_VALID_FLAGS_SET = CSC_MASK or
                            SHI1005_FLAGS_RESTRICT_EXCLUSIVE_OPENS or
                            SHI1005_FLAGS_FORCE_SHARED_DELETE or
                            SHI1005_FLAGS_ALLOW_NAMESPACE_CACHING or
                            SHI1005_FLAGS_ACCESS_BASED_DIRECTORY_ENUM or
                            SHI1005_FLAGS_FORCE_LEVELII_OPLOCK or
                            SHI1005_FLAGS_ENABLE_HASH;

{ SESSION API }

{ Function Prototypes Session }

function NetSessionEnum(servername, UncClientName, username: LPWSTR;
  level: DWORD; var bufptr: Pointer; prefmaxlen: DWORD; entriesread, totalentries,
  resume_handle: LPDWORD): NET_API_STATUS; stdcall;

function NetSessionDel(servername, UncClientName,
  username: LPWSTR): NET_API_STATUS; stdcall;

function NetSessionGetInfo(servername, UncClientName, username: LPWSTR;
  level: DWORD; var bufptr: Pointer): NET_API_STATUS; stdcall;

{ Data Structures - Session }

type
  PSessionInfo0 = ^TSessionInfo0;
  TSessionInfo0 = record
    sesi0_cname: LPWSTR; { client name (no backslashes) }
  end;

  PSessionInfo1 = ^TSessionInfo1;
  TSessionInfo1 = record
    sesi1_cname: LPWSTR; { client name (no backslashes) }
    sesi1_username: LPWSTR;
    sesi1_num_opens: DWORD;
    sesi1_time: DWORD;
    sesi1_idle_time: DWORD;
    sesi1_user_flags: DWORD;
  end;

  PSessionInfo2 = ^TSessionInfo2;
  TSessionInfo2 = record
    sesi2_cname: LPWSTR; { client name (no backslashes) }
    sesi2_username: LPWSTR;
    sesi2_num_opens: DWORD;
    sesi2_time: DWORD;
    sesi2_idle_time: DWORD;
    sesi2_user_flags: DWORD;
    sesi2_cltype_name: LPWSTR;
  end;

  PSessionInfo10 = ^TSessionInfo10;
  TSessionInfo10 = record
    sesi10_cname: LPWSTR; { client name (no backslashes) }
    sesi10_username: LPWSTR;
    sesi10_time: DWORD;
    sesi10_idle_time: DWORD;
  end;

  PSessionInfo502 = ^TSessionInfo502;
  TSessionInfo502 = record
    sesi502_cname: LPWSTR; { client name (no backslashes) }
    sesi502_username: LPWSTR;
    sesi502_num_opens: DWORD;
    sesi502_time: DWORD;
    sesi502_idle_time: DWORD;
    sesi502_user_flags: DWORD;
    sesi502_cltype_name: LPWSTR;
    sesi502_transport: LPWSTR;
  end;

{ Special Values and Constants - Session }

const

{ Bits defined in sesi1_user_flags. }

  SESS_GUEST        = $00000001; { session is logged on as a guest }
  SESS_NOENCRYPTION = $00000002; { session is not using encryption }

  SESI1_NUM_ELEMENTS = 8;
  SESI2_NUM_ELEMENTS = 9;

{ Function Prototypes - CONNECTION }

function NetConnectionEnum(servername, qualifier: LPWSTR; level: DWORD;
  var bufptr: Pointer; prefmaxlen: DWORD; entriesread, totalentries,
  resume_handle: LPDWORD): NET_API_STATUS; stdcall;

{ Data Structures - CONNECTION }

type
  PConnectionInfo0 = ^TConnectionInfo0;
  TConnectionInfo0 = record
    coni0_id: DWORD;
  end;

  PConnectionInfo1 = ^TConnectionInfo1;
  TConnectionInfo1 = record
    coni1_id: DWORD;
    coni1_type: DWORD;
    coni1_num_opens: DWORD;
    coni1_num_users: DWORD;
    coni1_time: DWORD;
    coni1_username: LPWSTR;
    coni1_netname: LPWSTR;
  end;

{ FILE API }

{ Function Prototypes - FILE }

function NetFileClose(servername: LPWSTR; fileid: DWORD): NET_API_STATUS; stdcall;

function NetFileEnum(servername, basepath, username: LPWSTR;
  level: DWORD; var bufptr: Pointer; prefmaxlen: DWORD; entriesread,
  totalentries, resume_handle: LPDWORD): NET_API_STATUS; stdcall;

function NetFileGetInfo(servername: LPWSTR; fileid, level: DWORD;
  var bufptr: Pointer): NET_API_STATUS; stdcall;

{ Data Structures - File }

{  File APIs are available at information levels 2 & 3 only. Levels 0 &
  1 are not supported. }

type
  PFileInfo2 = ^TFileInfo2;
  TFileInfo2 = record
    fi2_id: DWORD;
  end;

  PFileInfo3 = ^TFileInfo3;
  TFileInfo3 = record
    fi3_id: DWORD;
    fi3_permissions: DWORD;
    fi3_num_locks: DWORD;
    fi3_pathname: LPWSTR;
    fi3_username: LPWSTR;
  end;

{ Special Values and Constants - File }

const

{ bit values for permissions }

  PERM_FILE_READ   = $1; { user has read access }
  PERM_FILE_WRITE  = $2; { user has write access }
  PERM_FILE_CREATE = $4; { user has create access }

{ Value to be used with APIs which have a "preferred maximum length"
  parameter.  This value indicates that the API should just allocate
  "as much as it takes." }

  MAX_PREFERRED_LENGTH = DWORD(-1);

{ NetApiBuffer Function Prototypes }

function NetApiBufferAllocate(ByteCount: DWORD;
  var Buffer: Pointer): NET_API_STATUS; stdcall;

function NetApiBufferFree(Buffer: Pointer): NET_API_STATUS; stdcall;

function NetApiBufferReallocate(OldBuffer: Pointer; NewByteCount: DWORD;
  var NewBuffer: Pointer): NET_API_STATUS; stdcall;

function NetApiBufferSize(Buffer: Pointer;
  ByteCount: LPDWORD): NET_API_STATUS; stdcall;

{ Misc Function Prototypes }

type
  PNetSetupJoinStatus = ^TNetSetupJoinStatus;
  TNetSetupJoinStatus = (
    NetSetupUnknownStatus = 0,
    NetSetupUnjoined,
    NetSetupWorkgroupName,
    NetSetupDomainName);

function NetGetJoinInformation(lpServer: LPCWSTR; var lpNameBuffer: LPWSTR;
  BufferType: PNetSetupJoinStatus): NET_API_STATUS; stdcall;

type
  PTimeOfDayInfo = ^TTimeOfDayInfo;
  TTimeOfDayInfo = record
    tod_elapsedt: DWORD;
    tod_msecs: DWORD;
    tod_hours: DWORD;
    tod_mins: DWORD;
    tod_secs: DWORD;
    tod_hunds: DWORD;
    tod_timezone: Longint;
    tod_tinterval: DWORD;
    tod_day: DWORD;
    tod_month: DWORD;
    tod_year: DWORD;
    tod_weekday: DWORD;
  end;
    
function NetRemoteTOD(UncServerName: LPCWSTR;
  var BufferPtr: PByte): NET_API_STATUS; stdcall;

implementation

const
  netapilib = 'netapi32.dll';

function NetServerEnum; external netapilib name 'NetServerEnum';
function NetServerEnumEx; external netapilib name 'NetServerEnumEx';
function NetServerGetInfo; external netapilib name 'NetServerGetInfo';
function NetServerSetInfo; external netapilib name 'NetServerSetInfo';
function NetServerSetInfoCommandLine; external netapilib name 'NetServerSetInfoCommandLine';
function NetServerDiskEnum; external netapilib name 'NetServerDiskEnum';
function NetServerComputerNameAdd; external netapilib name 'NetServerComputerNameAdd';
function NetServerComputerNameDel; external netapilib name 'NetServerComputerNameDel';
function NetServerTransportAdd; external netapilib name 'NetServerTransportAdd';
function NetServerTransportAddEx; external netapilib name 'NetServerTransportAddEx';
function NetServerTransportDel; external netapilib name 'NetServerTransportDel';
function NetServerTransportEnum; external netapilib name 'NetServerTransportEnum';
function SetServiceBits; external netapilib name 'SetServiceBits';

function NetShareAdd; external netapilib name 'NetShareAdd';
function NetShareEnum; external netapilib name 'NetShareEnum';
function NetShareEnumSticky; external netapilib name 'NetShareEnumSticky';
function NetShareGetInfo; external netapilib name 'NetShareGetInfo';
function NetShareSetInfo; external netapilib name 'NetShareSetInfo';
function NetShareDel; external netapilib name 'NetShareDel';
function NetShareDelSticky; external netapilib name 'NetShareDelSticky';
function NetShareCheck; external netapilib name 'NetShareCheck';
function NetShareDelEx; external netapilib name 'NetShareDelEx';
function NetServerAliasAdd; external netapilib name 'NetServerAliasAdd';
function NetServerAliasDel; external netapilib name 'NetServerAliasDel';
function NetServerAliasEnum; external netapilib name 'NetServerAliasEnum';
function NetSessionEnum; external netapilib name 'NetSessionEnum';
function NetSessionDel; external netapilib name 'NetSessionDel';
function NetSessionGetInfo; external netapilib name 'NetSessionGetInfo';
function NetConnectionEnum; external netapilib name 'NetConnectionEnum';
function NetFileClose; external netapilib name 'NetFileClose';
function NetFileEnum; external netapilib name 'NetFileEnum';
function NetFileGetInfo; external netapilib name 'NetFileGetInfo';

function NetApiBufferAllocate; external netapilib name 'NetApiBufferAllocate';
function NetApiBufferFree; external netapilib name 'NetApiBufferFree';
function NetApiBufferReallocate; external netapilib name 'NetApiBufferReallocate';
function NetApiBufferSize; external netapilib name 'NetApiBufferSize';

function NetGetJoinInformation; external netapilib name 'NetGetJoinInformation';
function NetRemoteTOD; external netapilib name 'NetRemoteTOD';

end.
