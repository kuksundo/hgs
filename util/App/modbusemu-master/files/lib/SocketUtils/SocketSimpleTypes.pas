unit SocketSimpleTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Sockets
  {$IFDEF WINDOWS}
  ,windows
  {$ENDIF}
  ;

{$IFDEF WINDOWS}
const
  CM_SOCKETMESSAGE  = WM_USER + $0001;
  CM_DEFERFREE      = WM_USER + $0002;
  CM_LOOKUPCOMPLETE = WM_USER + $0003;
{$ENDIF}

const
  INADDR_ANY          = $00000000;
  INADDR_ANY_STR      = '0.0.0.0';
  INADDR_LOOPBACK     = $7F000001;
  INADDR_LOOPBACK_STR = '127.0.0.1';
  INADDR_BROADCAST    = $FFFFFFFF;
  INADDR_BROADCAST_STR= '255.255.255.255';
  INADDR_NONE         = $FFFFFFFF;
  INADDR_NONE_STR     = '255.255.255.255';
  ADDR_ANY	      = INADDR_ANY;
  INVALID_SOCKET      = LongInt(NOT(0));
  SOCKET_ERROR        = -1;
  MAXGETHOSTSTRUCT    = 1024;
  SO_REUSEPORT        = 15;

  FIONREAD             = $541B;
  MAX_SOCKET_BYFF_SIZE = 65535;
  MAX_NUM_PARALLEL_CON = 500;


  // из libc
  IF_NAMESIZE     = 16;
  IFHWADDRLEN     = 6;
  IFNAMSIZ        = IF_NAMESIZE;

  IFF_UP          = $1;
  IFF_BROADCAST   = $2;
  IFF_DEBUG       = $4;
  IFF_LOOPBACK    = $8;
  IFF_POINTOPOINT = $10;
  IFF_NOTRAILERS  = $20;
  IFF_RUNNING     = $40;
  IFF_NOARP       = $80;
  IFF_PROMISC     = $100;
  IFF_ALLMULTI    = $200;
  IFF_MASTER      = $400;
  IFF_SLAVE       = $800;
  IFF_MULTICAST   = $1000;
  IFF_PORTSEL     = $2000;
  IFF_AUTOMEDIA   = $4000;

  // из ioctlsh.inc

  SIOCGIFCONF    = $8912;
  SIOCGIFNETMASK = $891b;

type
  TServerType  = (stNonBlocking, stThreadBlocking);
  TClientType  = (ctNonBlocking, ctBlocking);
  TAsyncStyle  = (asRead, asWrite, asOOB, asAccept, asConnect, asClose);
  TAsyncStyles = set of TAsyncStyle;
  TSocketEvent = (seLookup, seConnecting, seConnect, seDisconnect,
                  seListen, seAccept, seWrite, seRead, seSelect, seBind);
  TLookupState = (lsIdle, lsLookupAddress, lsLookupService);
  TErrorEvent  = (eeGeneral, eeSend, eeReceive, eeConnect, eeDisconnect,
                  eeAccept, eeLookup, eeSelect, eeBind, eeSocket, eeNone);

// из libc nifh.inc
  Pif_nameindex = ^_if_nameindex;
  _if_nameindex = record
       if_index : dword;
       if_name  : Pchar;
  end;
  P_if_nameindex = ^_if_nameindex;

  Pifaddr = ^ifaddr;
  ifaddr = record
   ifa_addr : sockaddr;
   ifa_ifu  : record
   case longint of
    0 : ( ifu_broadaddr : sockaddr );
    1 : ( ifu_dstaddr : sockaddr );
   end;
   ifa_ifp  : Pointer; // Piface;
   ifa_next : Pifaddr;
  end;

   Pifmap = ^ifmap;
   ifmap = record
    mem_start : dword;
    mem_end   : dword;
    base_addr : word;
    irq       : byte;
    dma       : byte;
    port      : byte;
   end;

   Pifreq = ^ifreq;
   ifreq = record
    ifr_ifrn : record
                case longint of
                  0 : ( ifrn_name : array[0..(IFNAMSIZ)-1] of char );
               end;
    ifr_ifru : record
                case longint of
                 0 : ( ifru_addr      : sockaddr );
                 1 : ( ifru_dstaddr   : sockaddr );
                 2 : ( ifru_broadaddr : sockaddr );
                 3 : ( ifru_netmask   : sockaddr );
                 4 : ( ifru_hwaddr    : sockaddr );
                 5 : ( ifru_flags     : smallint );
                 6 : ( ifru_ivalue    : longint );
                 7 : ( ifru_mtu       : longint );
                 8 : ( ifru_map       : ifmap );
                 9 : ( ifru_slave     : array[0..(IFNAMSIZ)-1] of char );
                10 : ( ifru_newname   : array[0..(IFNAMSIZ)-1] of char );
                11 : ( ifru_data      : char);//__caddr_t );
               end;
   end;

   Pifconf = ^ifconf;
   ifconf = record
    ifc_len : longint;
    ifc_ifcu : record
                case longint of
                 0 : ( ifcu_buf : char);//__caddr_t );
                 1 : ( ifcu_req : Pifreq );
               end;
   end;

  TIfNameIndex = _if_nameindex;
  PIfNameIndex = ^TIfNameIndex;

  TIfAddr = ifaddr;
  TIFreq  = ifreq;

function GetEttorEventName(AEvent : TErrorEvent): string;
function GetSocketEventName(AEvent : TSocketEvent): string;

implementation

uses SocketResStrings;

function GetSocketEventName(AEvent : TSocketEvent): string;
begin
 Result := '';
 case AEvent of
  seLookup     : Result := rsNameSocketEventLookup;
  seConnecting : Result := rsNameSocketEventConnecting;
  seConnect    : Result := rsNameSocketEventConnect;
  seDisconnect : Result := rsNameSocketEventDisconnect;
  seListen     : Result := rsNameSocketEventListen;
  seAccept     : Result := rsNameSocketEventAccept;
  seWrite      : Result := rsNameSocketEventWrite;
  seRead       : Result := rsNameSocketEventRead;
  seSelect     : Result := rsNameSocketEventSelect;
  seBind       : Result := rsNameSocketEventBind;
 end;
end;

function GetEttorEventName(AEvent : TErrorEvent): string;
begin
  Result := '';
  case AEvent of
   eeGeneral    : Result := rsNameErrEventGeneral;
   eeSend       : Result := rsNameErrEventSend;
   eeReceive    : Result := rsNameErrEventReceive;
   eeConnect    : Result := rsNameErrEventConnect;
   eeDisconnect : Result := rsNameErrEventDisconnect;
   eeAccept     : Result := rsNameErrEventAccept;
   eeLookup     : Result := rsNameErrEventLookup;
   eeSelect     : Result := rsNameErrEventSelect;
   eeBind       : Result := rsNameErrEventBind;
   eeSocket     : Result := rsNameErrEventSocket;
   eeNone       : Result := rsNameErrEventNone;
  end;
end;

end.

