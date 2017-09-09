unit IPHelper;

interface

uses Windows, WinSock;

const
 NO_ERROR = 0;

 MAX_ADAPTER_NAME_LENGTH        = 256;
 MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
 MAX_ADAPTER_ADDRESS_LENGTH    = 8;

 { используемая библиотека }
 Iphlpapi = 'Iphlpapi.dll';
 { максимальная длинна имени сетевого интерфейса }
 MAX_INTERFACE_NAME_LEN = 256;
 { максимальная длинна MAC-адреса }
 MAXLEN_PHYSADDR = 8;
 { максимальная длинна описания сетевого интерфейса }
 MAXLEN_IFDESCR = 256;
 { типы интерфейсов }
 MIB_IF_TYPE_OTHER     = 1;
 MIB_IF_TYPE_ETHERNET  = 6;
 MIB_IF_TYPE_TOKENRING = 9;
 MIB_IF_TYPE_FDDI      = 15;
 MIB_IF_TYPE_PPP       = 23;
 MIB_IF_TYPE_LOOPBACK  = 24;
 MIB_IF_TYPE_SLIP      = 28;
 MIB_IF_TYPE_ATM       = 37;
 MIB_IF_TYPE_IEEE80211 = 71;
 MIB_IF_TYPE_TUNEL     = 131;
 MIB_IF_TYPE_IEEE1394  = 144;
 MIB_IF_TYPE_IEEE80216 = 237;
 MIB_IF_TYPE_WWANPP    = 243;
 MIB_IF_TYPE_WWANPP2   = 244;

 { административный статус интерфейса }
 MIB_IF_ADMIN_STATUS_UP      = 1;
 MIB_IF_ADMIN_STATUS_DOWN    = 2;
 MIB_IF_ADMIN_STATUS_TESTING = 3;
 { оперативный статус интерфейса }
 MIB_IF_OPER_STATUS_NON_OPERATIONAL = 0;
 MIB_IF_OPER_STATUS_UNREACHABLE     = 1;
 MIB_IF_OPER_STATUS_DISCONNECTED    = 2;
 MIB_IF_OPER_STATUS_CONNECTING      = 3;
 MIB_IF_OPER_STATUS_CONNECTED       = 4;
 MIB_IF_OPER_STATUS_OPERATIONAL     = 5;

 SIO_GET_INTERFACE_LIST = $4004747F;
 IFF_UP                 = $00000001;
 IFF_BROADCAST          = $00000002;
 IFF_LOOPBACK           = $00000004;
 IFF_POINTTOPOINT       = $00000008;
 IFF_MULTICAST          = $00000010;

type
 TItfTypeEnum = (itOTHER = 1, itETHERNET = 6, itTOKENRING = 9, itFDDI = 15,
                 itPPP = 23, itLOOPBACK = 24, ItSLIP = 28, itATM = 37,
                 itIEEE80211 = 71, itTUNEL = 131, itIEEE1394  = 144,
                 itIEEE80216 = 237, itWWANPP = 243, itWWANPP2   = 244);

 TAdmStatusEnum = (asUP = 1, asDOWN = 2, asTESTING = 3);

 TOperStatusEnum = (osNON_OPERATIONAL = 0, osUNREACHABLE = 1, osDISCONNECTED = 2,
                    osCONNECTING = 3, osCONNECTED = 4, osOPERATIONAL = 5);

  // Структуры для выполнения GetAdaptersInfo
  time_t = Longint;

  IP_ADDRESS_STRING = record
    S: array [0..15] of Char;
  end;
  IP_MASK_STRING = IP_ADDRESS_STRING;
  PIP_MASK_STRING = ^IP_MASK_STRING;

  PIP_ADDR_STRING = ^IP_ADDR_STRING;
  IP_ADDR_STRING = record
    Next      : PIP_ADDR_STRING;
    IpAddress : IP_ADDRESS_STRING;
    IpMask    : IP_MASK_STRING;
    Context   : DWORD;
  end;

 PIP_ADAPTER_INFO = ^IP_ADAPTER_INFO;
 IP_ADAPTER_INFO = record
   Next                : PIP_ADAPTER_INFO;
   ComboIndex          : DWORD;
   AdapterName         : array [0..MAX_ADAPTER_NAME_LENGTH + 3] of Char;
   Description         : array [0..MAX_ADAPTER_DESCRIPTION_LENGTH + 3] of Char;
   AddressLength       : UINT;
   Address             : array [0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of BYTE;
   Index               : DWORD;
   Type_               : UINT;
   DhcpEnabled         : UINT;
   CurrentIpAddress    : PIP_ADDR_STRING;
   IpAddressList       : IP_ADDR_STRING;
   GatewayList         : IP_ADDR_STRING;
   DhcpServer          : IP_ADDR_STRING;
   HaveWins            : BOOL;
   PrimaryWinsServer   : IP_ADDR_STRING;
   SecondaryWinsServer : IP_ADDR_STRING;
   LeaseObtained       : time_t;
   LeaseExpires        : time_t;
 end;

 PMIB_IFROW = ^MIB_IFROW;
 MIB_IFROW = record
   wszName           : array [1..MAX_INTERFACE_NAME_LEN] of WideChar;
   dwIndex           : Cardinal;
   dwType            : Cardinal;
   dwMtu             : Cardinal;
   dwSpeed           : Cardinal;
   dwPhysAddrLen     : Cardinal;
   bPhysAddr         : array [1..MAXLEN_PHYSADDR] of Byte;
   dwAdminStatus     : Cardinal;
   dwOperStatus      : Cardinal;
   dwLastChange      : Cardinal;
   dwInOctets        : Cardinal;
   dwInUcastPkts     : Cardinal;
   dwInNUcastPkts    : Cardinal;
   dwInDiscards      : Cardinal;
   dwInErrors        : Cardinal;
   dwInUnknownProtos : Cardinal;
   dwOutOctets       : Cardinal;
   dwOutUcastPkts    : Cardinal;
   dwOutNUcastPkts   : Cardinal;
   dwOutDiscards     : Cardinal;
   dwOutErrors       : Cardinal;
   dwOutQLen         : Cardinal;
   dwDescrLen        : Cardinal;
   bDescr            : array [1..MAXLEN_IFDESCR] of Byte;
 end;

 PMIB_IFTABLE = ^MIB_IFTABLE;
 MIB_IFTABLE = record
   dwNumEntries : Cardinal;
   table        : PMIB_IFROW;
 end;

 sockaddr_gen = packed record
  AddressIn : sockaddr_in;
  filler    : packed array [0..7] of char;
 end;

 type INTERFACE_INFO = packed record
  iiFlags            : u_long;       // Флаги интерфейса
  iiAddress          : sockaddr_gen; // Адрес интерфейса
  iiBroadcastAddress : sockaddr_gen; // Broadcast адрес
  iiNetmask          : sockaddr_gen; // Маска подсети
 end;

{$EXTERNALSYM GetIfTable}
function GetIfTable(pIfTable: PMIB_IFTABLE; pdwSize: PCardinal; bOrder: LongBool): Cardinal; stdcall;
{$EXTERNALSYM SetIfEntry}
function SetIfEntry(pIfRow: PMIB_IFROW): Cardinal; stdcall;
{$EXTERNALSYM GetAdaptersInfo}
function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO; pOutBufLen: PCardinal): Cardinal; stdcall;

function GetIfTable(pIfTable: PMIB_IFTABLE; pdwSize: PCardinal; bOrder: LongBool): Cardinal; stdcall; external Iphlpapi name 'GetIfTable';
function SetIfEntry(pIfRow: PMIB_IFROW): Cardinal; stdcall; external Iphlpapi name 'SetIfEntry';
function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO; pOutBufLen: PCardinal): Cardinal; stdcall; external Iphlpapi name 'GetAdaptersInfo';


function GetIfRow(pIfTable: PMIB_IFTABLE; const dwIndex: Cardinal): MIB_IFROW;
function GetIfRowP(pIfTable: PMIB_IFTABLE; const dwIndex: Cardinal): PMIB_IFROW;
function IfTypeToStr(IfRow: MIB_IFROW): String; overload;
function IfTypeToStr(IfRow: TItfTypeEnum): String; overload;
function GetHardwareAddress(IfRow: MIB_IFROW): String;
function GetAdminStatus(IfRow: MIB_IFROW): String; overload;
function GetAdminStatus(IfRow: TAdmStatusEnum): String; overload;
function GetOperStatus(IfRow: MIB_IFROW): String; overload;
function GetOperStatus(IfRow: TOperStatusEnum): String; overload;

function GetIPFromHost(var HostName, IPaddr, WSAErr: String): Boolean;
function GetLocalIP: String;


implementation

uses SysUtils, SocketResStrings;

function GetIfRow(pIfTable: PMIB_IFTABLE; const dwIndex: Cardinal): MIB_IFROW;
begin
 Result := PMIB_IFROW(PtrUInt(pIfTable) + SizeOf(Cardinal) + dwIndex * SizeOf(MIB_IFROW))^;
end;

function GetIfRowP(pIfTable: PMIB_IFTABLE; const dwIndex: Cardinal): PMIB_IFROW;
begin
 Result := PMIB_IFROW(PtrUInt(pIfTable) + SizeOf(Cardinal) + dwIndex * SizeOf(MIB_IFROW));
end;

function IfTypeToStr(IfRow: MIB_IFROW): String;
begin
 case IfRow.dwType of
   MIB_IF_TYPE_ETHERNET  : Result := rsMIB_IF_TYPE_ETHERNET;
   MIB_IF_TYPE_TOKENRING : Result := rsMIB_IF_TYPE_TOKENRING;
   MIB_IF_TYPE_FDDI      : Result := rsMIB_IF_TYPE_FDDI;
   MIB_IF_TYPE_PPP       : Result := rsMIB_IF_TYPE_PPP;
   MIB_IF_TYPE_LOOPBACK  : Result := rsMIB_IF_TYPE_LOOPBACK;
   MIB_IF_TYPE_SLIP      : Result := rsMIB_IF_TYPE_SLIP;
   MIB_IF_TYPE_ATM       : Result := rsMIB_IF_TYPE_ATM;
   MIB_IF_TYPE_IEEE80211 : Result := rsMIB_IF_TYPE_IEEE80211;
   MIB_IF_TYPE_TUNEL     : Result := rsMIB_IF_TYPE_TUNNEL;
   MIB_IF_TYPE_IEEE1394  : Result := rsMIB_IF_TYPE_IEEE1394;
   MIB_IF_TYPE_IEEE80216 : Result := rsMIB_IF_TYPE_IEEE80216;
   MIB_IF_TYPE_WWANPP    : Result := rsMIB_IF_TYPE_WWANP;
   MIB_IF_TYPE_WWANPP2   : Result := rsMIB_IF_TYPE_WWANP2;
 else
   Result := rsMIB_IF_TYPE_UNKNOWN;
 end;
end;

function IfTypeToStr(IfRow: TItfTypeEnum): String;
begin
  case IfRow of
   itETHERNET  : Result := rsMIB_IF_TYPE_ETHERNET;
   itTOKENRING : Result := rsMIB_IF_TYPE_TOKENRING;
   itFDDI      : Result := rsMIB_IF_TYPE_FDDI;
   itPPP       : Result := rsMIB_IF_TYPE_PPP;
   itLOOPBACK  : Result := rsMIB_IF_TYPE_LOOPBACK;
   itSLIP      : Result := rsMIB_IF_TYPE_SLIP;
   itATM       : Result := rsMIB_IF_TYPE_ATM;
   itIEEE80211 : Result := rsMIB_IF_TYPE_IEEE80211;
   itTUNEL     : Result := rsMIB_IF_TYPE_TUNNEL;
   itIEEE1394  : Result := rsMIB_IF_TYPE_IEEE1394;
   itIEEE80216 : Result := rsMIB_IF_TYPE_IEEE80216;
   itWWANPP    : Result := rsMIB_IF_TYPE_WWANP;
   itWWANPP2   : Result := rsMIB_IF_TYPE_WWANP2;
 else
   Result := rsMIB_IF_TYPE_UNKNOWN;
 end;
end;

function GetHardwareAddress(IfRow: MIB_IFROW): String;
var
 I: Byte;
begin
 Result := '';
 for I := 1 to MAXLEN_PHYSADDR do
  if I < MAXLEN_PHYSADDR then Result := Result + IntToHex(IfRow.bPhysAddr[I], 2) + '-'
   else Result := Result + IntToHex(IfRow.bPhysAddr[I], 2);
end;

function GetAdminStatus(IfRow: MIB_IFROW): String;
begin
 case IfRow.dwAdminStatus of
   MIB_IF_ADMIN_STATUS_UP   : Result := rsMIB_IF_ADMIN_STATUS_UP;
   MIB_IF_ADMIN_STATUS_DOWN : Result := rsMIB_IF_ADMIN_STATUS_DOWN;
 else
   Result := rsMIB_IF_ADMIN_STATUS_CHACKED;
 end;
end;

function GetAdminStatus(IfRow: TAdmStatusEnum): String;
begin
 case IfRow of
   asUP      : Result := rsMIB_IF_ADMIN_STATUS_UP;
   asDOWN    : Result := rsMIB_IF_ADMIN_STATUS_DOWN;
   asTESTING : Result := rsMIB_IF_ADMIN_STATUS_CHACKED;
 else
   Result := rsMIB_IF_OPER_STATUS_LAN_UNKNOWN;// rsMIB_IF_ADMIN_STATUS_CHACKED;
 end;
end;

function GetOperStatus(IfRow: MIB_IFROW): String;
begin
 case IfRow.dwOperStatus of
   MIB_IF_OPER_STATUS_NON_OPERATIONAL : Result := rsMIB_IF_OPER_STATUS_NON_OPERATIONAL;
   MIB_IF_OPER_STATUS_UNREACHABLE     : Result := rsMIB_IF_OPER_STATUS_UNREACHABLE;
   MIB_IF_OPER_STATUS_DISCONNECTED    : Result := rsMIB_IF_OPER_STATUS_DISCONNECTED;
   MIB_IF_OPER_STATUS_CONNECTING      : Result := rsMIB_IF_OPER_STATUS_CONNECTING;
   MIB_IF_OPER_STATUS_CONNECTED       : Result := rsMIB_IF_OPER_STATUS_LAN_CONNECTED;
 else
   Result := rsMIB_IF_OPER_STATUS_LAN_CONNECTED;
 end;
end;

function GetOperStatus(IfRow: TOperStatusEnum): String;
begin
 case IfRow of
   osNON_OPERATIONAL : Result := rsMIB_IF_OPER_STATUS_NON_OPERATIONAL;
   osUNREACHABLE     : Result := rsMIB_IF_OPER_STATUS_UNREACHABLE;
   osDISCONNECTED    : Result := rsMIB_IF_OPER_STATUS_DISCONNECTED;
   osCONNECTING      : Result := rsMIB_IF_OPER_STATUS_CONNECTING;
   osCONNECTED       : Result := rsMIB_IF_OPER_STATUS_LAN_CONNECTED;
   osOPERATIONAL     : Result := rsMIB_IF_OPER_STATUS_LAN_OPERATIONAL;
 else
   Result := rsMIB_IF_OPER_STATUS_LAN_UNKNOWN;
 end;
end;


function GetIPFromHost(var HostName, IPaddr, WSAErr: String): Boolean;
type
  Name = array[0..100] of Char;
  PName = ^Name;
var
  HEnt    : pHostEnt;
  HName   : PName;
  WSAData : TWSAData;
  i       : Integer;
begin
  Result := False;
  WSAData.wVersion := 0;
  if WSAStartup($0101, WSAData) <> 0 then
   begin
    WSAErr := 'Winsock is not responding."';
    Exit;
   end;
  IPaddr := '';
  New(HName);
  if GetHostName(HName^, SizeOf(Name)) = 0 then
   begin
    HostName := StrPas(HName^);
    HEnt := GetHostByName(HName^);
    for i := 0 to HEnt^.h_length - 1 do
     IPaddr :=
      Concat(IPaddr,
      IntToStr(Ord(HEnt^.h_addr_list^[i])) + '.');
    SetLength(IPaddr, Length(IPaddr) - 1);
    Result := True;
   end
  else
   begin
    case WSAGetLastError of
     WSANOTINITIALISED:WSAErr:='WSANotInitialised';
     WSAENETDOWN      :WSAErr:='WSAENetDown';
     WSAEINPROGRESS   :WSAErr:='WSAEInProgress';
    end;
   end;
  Dispose(HName);
  WSACleanup;
end;

function GetLocalIP: String;
const WSVer = $101;
var wsaData: TWSAData;
    P: PHostEnt;
    Buf: array [0..127] of Char;
begin
  Result := '';
  wsaData.wVersion := 0;
  if WSAStartup(WSVer, wsaData) = 0 then
   begin
    if GetHostName(@Buf, 128) = 0 then
     begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := inet_ntoa(PInAddr(p^.h_addr_list^)^);
     end;
    WSACleanup;
   end;
end;

end.


