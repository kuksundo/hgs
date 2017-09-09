unit SocketMisc;

interface

uses SysUtils, Classes
     {$IFDEF WINDOWS}
     , SocketSimpleTypes
     {$ENDIF}
     ;

{$IFDEF UNIX}
const
  INVALID_SOCKET = LongInt(-1);
{$ENDIF}

type
   PIPRecord = ^TIPRecord;
   TIPRecord = packed record
     case integer of
       0: (Byte1 : Byte;
           Byte2 : Byte;
           Byte3 : Byte;
           Byte4 : Byte);
       1: (Addr : DWORD);
     end;

{function GetSocketInfo(ASocket: TCustomWinSocket): String;}
function SocketErrorToString(Error : Cardinal): String;
{$IFDEF WINDOWS}
function SocketErrorToComent(Error : Cardinal): String;
function SocketEventToSting(Event : TErrorEvent): String;
{$ENDIF}
function NetToHostIP(IP : Cardinal):Cardinal;
{function HostToIP: Cardinal;}
function GetIPStr(AHost: Cardinal): String;
function GetIPFromStr(AIPStr : String): Cardinal;
{function MakeIpAddress: Cardinal;}

{$IFDEF WINDOWS} function GetLocalHostName : String;{$ENDIF}


implementation

uses SocketErrorCode, SocketErrorRString
     {$IFDEF WINDOWS}, WinSock2 {$ENDIF};

{function GetSocketInfo(ASocket: TCustomWinSocket): String;
var str1, str2: String;
begin
  if ASocket = nil then
  begin
    Result:= rsSocketNotExist;
    exit;
  end;

  str1:= GetIPStr(Cardinal(ASocket.Addr.sin_addr.S_addr));
  if ASocket.Connected then str2:= rsConnected
  else str2:= rsDisConnected;
  Result:= format(rsSocket, [str1, str2]);
end;}

{function MakeIpAddress: Cardinal;
const
  bufsize=255;
var
  buf: pointer;
  RemoteHost : PHostEnt;
begin
  buf:=NIL;
  try
    buf := AllocMem(bufsize);
    winsock.gethostname(buf,bufsize);
    RemoteHost:=Winsock.GetHostByName(buf);
    if RemoteHost=NIL then Result:=winsock.htonl($7F000001)
     else Result:=longint(pointer(RemoteHost^.h_addr_list^)^);
  finally
    if buf<>NIL then  FreeMem(buf,bufsize);
  end;
  result:=winsock.ntohl(result);
end;}

function GetIPStr(AHost: Cardinal): String;
begin
  Result:= (IntToStr((AHost and $ff000000) shr 24) + '.' +
    IntToStr((AHost and $ff0000) shr 16) + '.' +
    IntToStr((AHost and $ff00) shr 8) + '.' +
    IntToStr(AHost and $ff))
end;

function GetIPFromStr(AIPStr : String): Cardinal;
var TempIP : TIPRecord;
    Temp   : TStringList;
begin
 Result := 0;
 Temp := TStringList.Create;
 Temp.Delimiter:='.';
 try
  Temp.DelimitedText:=Trim(AIPStr);
  if Temp.Count<>4 then Exit;
  TempIP.Byte4:=StrToInt(Temp.Strings[0]);
  TempIP.Byte3:=StrToInt(Temp.Strings[1]);
  TempIP.Byte2:=StrToInt(Temp.Strings[2]);
  TempIP.Byte1:=StrToInt(Temp.Strings[3]);
  Result:=TempIP.Addr;
 finally
  Temp.Free;
 end;
end;

{function HostToIP: Cardinal;
var wsdata : TWSAData;
    hostName : array [0..255] of char;
    hostEnt : PHostEnt;
    addr : PAnsiChar;
    TempIP :TIPRecord;
begin
 Result:=0;
 ZeroMemory(@wsdata,sizeof(TWSAData));
 WSAStartup ($0101, wsdata);
 try
  gethostname (hostName, sizeof (hostName));
  hostEnt := gethostbyname (hostName);
  if Assigned (hostEnt) then
    if Assigned (hostEnt^.h_addr_list) then
      begin
        addr := hostEnt^.h_addr_list^;
        if Assigned (addr) then
         begin
          TempIP.Byte1:=byte (addr [0]);
          TempIP.Byte2:=byte (addr [1]);
          TempIP.Byte3:=byte (addr [2]);
          TempIP.Byte4:=byte (addr [3]);
          Result := TempIP.Addr;
         end;
      end;
 finally
   WSACleanup;
 end
end;}

{$IFDEF WINDOWS}
function GetLocalHostName : String;
var hostName : array [0..255] of AnsiChar;
    wsdata : TWSAData;
begin
  wsdata.wVersion := 0;
  hostName[0] := #0;
  FillByte(wsdata,sizeof(TWSAData),0);
  WSAStartup ($0101, wsdata);
  try
   FillChar(hostName, sizeof(hostName),#0);
   gethostname(hostName, sizeof (hostName));
   Result := StrPas(hostName);
  finally
   WSACleanup;
  end;
end;
{$ENDIF}

function NetToHostIP(IP : Cardinal):Cardinal;
var TempIP1,TempIP2:TIPRecord;
begin
 TempIP1.Addr:=IP;
 TempIP2.Byte1:=TempIP1.Byte4;
 TempIP2.Byte2:=TempIP1.Byte3;
 TempIP2.Byte3:=TempIP1.Byte2;
 TempIP2.Byte4:=TempIP1.Byte1;
 Result:=TempIP2.Addr;
end;

{$IFDEF WINDOWS}
function  SocketEventToSting(Event : TErrorEvent): String;
begin
 case Event of
   eeGeneral    : Result := rsMiscSocketErrEvent2;
   eeSend       : Result := rsMiscSocketErrEvent3;
   eeReceive    : Result := rsMiscSocketErrEvent4;
   eeConnect    : Result := rsMiscSocketErrEvent5;
   eeDisconnect : Result := rsMiscSocketErrEvent6;
   eeAccept     : Result := rsMiscSocketErrEvent7;
   eeLookup     : Result := rsMiscSocketErrEvent8;
 else
  Result := rsMiscSocketErrEvent1;
 end;
end;
{$ENDIF}

function SocketErrorToString(Error : Cardinal):String ;
begin
 case Error of
  WSA_INVALID_HANDLE          : Result := rsWSA_INVALID_HANDLE         ;// 'Specified event object handle is invalid.';
  WSA_NOT_ENOUGH_MEMORY       : Result := rsWSA_NOT_ENOUGH_MEMORY      ;// 'Insufficient memory available.';
  WSA_INVALID_PARAMETER       : Result := rsWSA_INVALID_PARAMETER      ;// 'One or more parameters are invalid.';
  WSA_OPERATION_ABORTED       : Result := rsWSA_OPERATION_ABORTED      ;// 'Overlapped operation aborted.';
  WSA_IO_INCOMPLETE           : Result := rsWSA_IO_INCOMPLETE          ;// 'Overlapped I/O event object not in signaled state.';
  WSA_IO_PENDING              : Result := rsWSA_IO_PENDING             ;// 'Overlapped operations will complete later.';
  WSAEINTR                    : Result := rsWSAEINTR                   ;// 'Interrupted function call.';
  WSAEBADF                    : Result := rsWSAEBADF                   ;// 'File handle is not valid.';
  WSAEACCES                   : Result := rsWSAEACCES                  ;// 'Permission denied.';
  WSAEFAULT                   : Result := rsWSAEFAULT                  ;// 'Bad address.';
  WSAEINVAL                   : Result := rsWSAEINVAL                  ;// 'Invalid argument.';
  WSAEMFILE                   : Result := rsWSAEMFILE                  ;// 'Too many open files.';
  WSAEWOULDBLOCK              : Result := rsWSAEWOULDBLOCK             ;// 'Resource temporarily unavailable.';
  WSAEINPROGRESS              : Result := rsWSAEINPROGRESS             ;// 'Operation now in progress.';
  WSAEALREADY                 : Result := rsWSAEALREADY               ;// 'Operation already in progress.';
  WSAENOTSOCK                 : Result := rsWSAENOTSOCK               ;// 'Socket operation on nonsocket.';
  WSAEDESTADDRREQ             : Result := rsWSAEDESTADDRREQ           ;// 'Destination address required.';
  WSAEMSGSIZE                 : Result := rsWSAEMSGSIZE               ;// 'Message too long.';
  WSAEPROTOTYPE               : Result := rsWSAEPROTOTYPE             ;// 'Protocol wrong type for socket.';
  WSAENOPROTOOPT              : Result := rsWSAENOPROTOOPT            ;// 'Bad protocol option.';
  WSAEPROTONOSUPPORT          : Result := rsWSAEPROTONOSUPPORT        ;// 'Protocol not supported.';
  WSAESOCKTNOSUPPORT          : Result := rsWSAESOCKTNOSUPPORT        ;// 'Socket type not supported.';
  WSAEOPNOTSUPP               : Result := rsWSAEOPNOTSUPP             ;// 'Operation not supported.';
  WSAEPFNOSUPPORT             : Result := rsWSAEPFNOSUPPORT           ;// 'Protocol family not supported.';
  WSAEAFNOSUPPORT             : Result := rsWSAEAFNOSUPPORT           ;// 'Address family not supported by protocol family.';
  WSAEADDRINUSE               : Result := rsWSAEADDRINUSE             ;// 'Address already in use.';
  WSAEADDRNOTAVAIL            : Result := rsWSAEADDRNOTAVAIL          ;// 'Cannot assign requested address.';
  WSAENETDOWN                 : Result := rsWSAENETDOWN               ;// 'Network is down.';
  WSAENETUNREACH              : Result := rsWSAENETUNREACH            ;// 'Network is unreachable.';
  WSAENETRESET                : Result := rsWSAENETRESET              ;// 'Network dropped connection on reset.';
  WSAECONNABORTED             : Result := rsWSAECONNABORTED           ;// 'Software caused connection abort.';
  WSAECONNRESET               : Result := rsWSAECONNRESET             ;// 'Connection reset by peer.';
  WSAENOBUFS                  : Result := rsWSAENOBUFS                ;// 'No buffer space available.';
  WSAEISCONN                  : Result := rsWSAEISCONN                ;// 'Socket is already connected.';
  WSAENOTCONN                 : Result := rsWSAENOTCONN               ;// 'Socket is not connected.';
  WSAESHUTDOWN                : Result := rsWSAESHUTDOWN              ;// 'Cannot send after socket shutdown.';
  WSAETOOMANYREFS             : Result := rsWSAETOOMANYREFS           ;// 'Too many references.';
  WSAETIMEDOUT                : Result := rsWSAETIMEDOUT              ;// 'Connection timed out.';
  WSAECONNREFUSED             : Result := rsWSAECONNREFUSED           ;// 'Connection refused.';
  WSAELOOP                    : Result := rsWSAELOOP                  ;// 'Cannot translate name.';
  WSAENAMETOOLONG             : Result := rsWSAENAMETOOLONG           ;// 'Name too long.';
  WSAEHOSTDOWN                : Result := rsWSAEHOSTDOWN              ;// 'Host is down.';
  WSAEHOSTUNREACH             : Result := rsWSAEHOSTUNREACH           ;// 'No route to host.';
  WSAENOTEMPTY                : Result := rsWSAENOTEMPTY              ;// 'Directory not empty.';
  WSAEPROCLIM                 : Result := rsWSAEPROCLIM               ;// 'Too many processes.';
  WSAEUSERS                   : Result := rsWSAEUSERS                 ;// 'User quota exceeded.';
  WSAEDQUOT                   : Result := rsWSAEDQUOT                 ;// 'Disk quota exceeded.';
  WSAESTALE                   : Result := rsWSAESTALE                 ;// 'Stale file handle reference.';
  WSAEREMOTE                  : Result := rsWSAEREMOTE                ;// 'Item is remote.';
  WSASYSNOTREADY              : Result := rsWSASYSNOTREADY            ;// 'Network subsystem is unavailable.';
  WSAVERNOTSUPPORTED          : Result := rsWSAVERNOTSUPPORTED        ;// 'Winsock.dll version out of range.';
  WSANOTINITIALISED           : Result := rsWSANOTINITIALISED         ;// 'Successful WSAStartup not yet performed.';
  WSAEDISCON                  : Result := rsWSAEDISCON                ;// 'Graceful shutdown in progress.';
  WSAENOMORE                  : Result := rsWSAENOMORE                ;// 'No more results.';
  WSAECANCELLED               : Result := rsWSAECANCELLED             ;// 'Call has been canceled.';
  WSAEINVALIDPROCTABLE        : Result := rsWSAEINVALIDPROCTABLE      ;// 'Procedure call table is invalid.';
  WSAEINVALIDPROVIDER         : Result := rsWSAEINVALIDPROVIDER       ;// 'Service provider is invalid.';
  WSAEPROVIDERFAILEDINIT      : Result := rsWSAEPROVIDERFAILEDINIT    ;// 'Service provider failed to initialize.';
  WSASYSCALLFAILURE           : Result := rsWSASYSCALLFAILURE         ;// 'System call failure.';
  WSASERVICE_NOT_FOUND        : Result := rsWSASERVICE_NOT_FOUND      ;// 'Service not found.';
  WSATYPE_NOT_FOUND           : Result := rsWSATYPE_NOT_FOUND         ;// 'Class type not found.';
  WSA_E_NO_MORE               : Result := rsWSA_E_NO_MORE             ;// 'No more results.';
  WSA_E_CANCELLED             : Result := rsWSA_E_CANCELLED           ;// 'Call was canceled.';
  WSAEREFUSED                 : Result := rsWSAEREFUSED               ;// 'Database query was refused.';
  WSAHOST_NOT_FOUND           : Result := rsWSAHOST_NOT_FOUND         ;// 'Host not found.';
  WSATRY_AGAIN                : Result := rsWSATRY_AGAIN              ;// 'Nonauthoritative host not found.';
  WSANO_RECOVERY              : Result := rsWSANO_RECOVERY            ;// 'This is a nonrecoverable error.';
  WSANO_DATA                  : Result := rsWSANO_DATA                ;// 'Valid name, no data record of requested type.';
  WSA_QOS_RECEIVERS           : Result := rsWSA_QOS_RECEIVERS         ;// 'QOS receivers.';
  WSA_QOS_SENDERS             : Result := rsWSA_QOS_SENDERS           ;// 'QOS senders.';
  WSA_QOS_NO_SENDERS          : Result := rsWSA_QOS_NO_SENDERS        ;// 'No QOS senders.';
  WSA_QOS_NO_RECEIVERS        : Result := rsWSA_QOS_NO_RECEIVERS      ;// 'QOS no receivers.';
  WSA_QOS_REQUEST_CONFIRMED   : Result := rsWSA_QOS_REQUEST_CONFIRMED ;// 'QOS request confirmed.';
  WSA_QOS_ADMISSION_FAILURE   : Result := rsWSA_QOS_ADMISSION_FAILURE ;// 'QOS admission error.';
  WSA_QOS_POLICY_FAILURE      : Result := rsWSA_QOS_POLICY_FAILURE    ;// 'QOS policy failure.';
  WSA_QOS_BAD_STYLE           : Result := rsWSA_QOS_BAD_STYLE         ;// 'QOS bad style.';
  WSA_QOS_BAD_OBJECT          : Result := rsWSA_QOS_BAD_OBJECT        ;// 'QOS bad object.';
  WSA_QOS_TRAFFIC_CTRL_ERROR  : Result := rsWSA_QOS_TRAFFIC_CTRL_ERROR;// 'QOS traffic control error.';
  WSA_QOS_GENERIC_ERROR       : Result := rsWSA_QOS_GENERIC_ERROR     ;// 'QOS generic error.';
  WSA_QOS_ESERVICETYPE        : Result := rsWSA_QOS_ESERVICETYPE      ;// 'QOS service type error.';
  WSA_QOS_EFLOWSPEC           : Result := rsWSA_QOS_EFLOWSPEC         ;// 'QOS flowspec error.';
  WSA_QOS_EPROVSPECBUF        : Result := rsWSA_QOS_EPROVSPECBUF      ;// 'Invalid QOS provider buffer.';
  WSA_QOS_EFILTERSTYLE        : Result := rsWSA_QOS_EFILTERSTYLE      ;// 'Invalid QOS filter style.';
  WSA_QOS_EFILTERTYPE         : Result := rsWSA_QOS_EFILTERTYPE       ;// 'Invalid QOS filter type.';
  WSA_QOS_EFILTERCOUNT        : Result := rsWSA_QOS_EFILTERCOUNT      ;// 'Incorrect QOS filter count.';
  WSA_QOS_EOBJLENGTH          : Result := rsWSA_QOS_EOBJLENGTH        ;// 'Invalid QOS object length.';
  WSA_QOS_EFLOWCOUNT          : Result := rsWSA_QOS_EFLOWCOUNT        ;// 'Incorrect QOS flow count.';
  WSA_QOS_EUNKOWNPSOBJ        : Result := rsWSA_QOS_EUNKOWNPSOBJ      ;// 'Unrecognized QOS object.';
  WSA_QOS_EPOLICYOBJ          : Result := rsWSA_QOS_EPOLICYOBJ        ;// 'Invalid QOS policy object.';
  WSA_QOS_EFLOWDESC           : Result := rsWSA_QOS_EFLOWDESC         ;// 'Invalid QOS flow descriptor.';
  WSA_QOS_EPSFLOWSPEC         : Result := rsWSA_QOS_EPSFLOWSPEC       ;// 'Invalid QOS provider-specific flowspec.';
  WSA_QOS_EPSFILTERSPEC       : Result := rsWSA_QOS_EPSFILTERSPEC     ;// 'Invalid QOS provider-specific filterspec.';
  WSA_QOS_ESDMODEOBJ          : Result := rsWSA_QOS_ESDMODEOBJ        ;// 'Invalid QOS shape discard mode object.';
  WSA_QOS_ESHAPERATEOBJ       : Result := rsWSA_QOS_ESHAPERATEOBJ     ;// 'Invalid QOS shaping rate object.';
  WSA_QOS_RESERVED_PETYPE     : Result := rsWSA_QOS_RESERVED_PETYPE   ;// 'Reserved policy QOS element type.';
 else
  Result := Format(rsUNKNOWN_ERR,[Error,SysErrorMessage(Error)]);
 end;
end;

{$IFDEF WINDOWS}
function SocketErrorToComent(Error : Cardinal):String ;
begin
 case Error of
  WSA_INVALID_HANDLE          : Result := rsLongWSA_INVALID_HANDLE         ;// 'Specified event object handle is invalid.';
  WSA_NOT_ENOUGH_MEMORY       : Result := rsLongWSA_NOT_ENOUGH_MEMORY      ;// 'Insufficient memory available.';
  WSA_INVALID_PARAMETER       : Result := rsLongWSA_INVALID_PARAMETER      ;// 'One or more parameters are invalid.';
  WSA_OPERATION_ABORTED       : Result := rsLongWSA_OPERATION_ABORTED      ;// 'Overlapped operation aborted.';
  WSA_IO_INCOMPLETE           : Result := rsLongWSA_IO_INCOMPLETE          ;// 'Overlapped I/O event object not in signaled state.';
  WSA_IO_PENDING              : Result := rsLongWSA_IO_PENDING             ;// 'Overlapped operations will complete later.';
  WSAEINTR                    : Result := rsLongWSAEINTR                   ;// 'Interrupted function call.';
  WSAEBADF                    : Result := rsLongWSAEBADF                   ;// 'File handle is not valid.';
  WSAEACCES                   : Result := rsLongWSAEACCES                  ;// 'Permission denied.';
  WSAEFAULT                   : Result := rsLongWSAEFAULT                  ;// 'Bad address.';
  WSAEINVAL                   : Result := rsLongWSAEINVAL                  ;// 'Invalid argument.';
  WSAEMFILE                   : Result := rsLongWSAEMFILE                  ;// 'Too many open files.';
  WSAEWOULDBLOCK              : Result := rsLongWSAEWOULDBLOCK             ;// 'Resource temporarily unavailable.';
  WSAEINPROGRESS              : Result := rsLongWSAEINPROGRESS             ;// 'Operation now in progress.';
  WSAEALREADY                 : Result := rsLongWSAEALREADY               ;// 'Operation already in progress.';
  WSAENOTSOCK                 : Result := rsLongWSAENOTSOCK               ;// 'Socket operation on nonsocket.';
  WSAEDESTADDRREQ             : Result := rsLongWSAEDESTADDRREQ           ;// 'Destination address required.';
  WSAEMSGSIZE                 : Result := rsLongWSAEMSGSIZE               ;// 'Message too long.';
  WSAEPROTOTYPE               : Result := rsLongWSAEPROTOTYPE             ;// 'Protocol wrong type for socket.';
  WSAENOPROTOOPT              : Result := rsLongWSAENOPROTOOPT            ;// 'Bad protocol option.';
  WSAEPROTONOSUPPORT          : Result := rsLongWSAEPROTONOSUPPORT        ;// 'Protocol not supported.';
  WSAESOCKTNOSUPPORT          : Result := rsLongWSAESOCKTNOSUPPORT        ;// 'Socket type not supported.';
  WSAEOPNOTSUPP               : Result := rsLongWSAEOPNOTSUPP             ;// 'Operation not supported.';
  WSAEPFNOSUPPORT             : Result := rsLongWSAEPFNOSUPPORT           ;// 'Protocol family not supported.';
  WSAEAFNOSUPPORT             : Result := rsLongWSAEAFNOSUPPORT           ;// 'Address family not supported by protocol family.';
  WSAEADDRINUSE               : Result := rsLongWSAEADDRINUSE             ;// 'Address already in use.';
  WSAEADDRNOTAVAIL            : Result := rsLongWSAEADDRNOTAVAIL          ;// 'Cannot assign requested address.';
  WSAENETDOWN                 : Result := rsLongWSAENETDOWN               ;// 'Network is down.';
  WSAENETUNREACH              : Result := rsLongWSAENETUNREACH            ;// 'Network is unreachable.';
  WSAENETRESET                : Result := rsLongWSAENETRESET              ;// 'Network dropped connection on reset.';
  WSAECONNABORTED             : Result := rsLongWSAECONNABORTED           ;// 'Software caused connection abort.';
  WSAECONNRESET               : Result := rsLongWSAECONNRESET             ;// 'Connection reset by peer.';
  WSAENOBUFS                  : Result := rsLongWSAENOBUFS                ;// 'No buffer space available.';
  WSAEISCONN                  : Result := rsLongWSAEISCONN                ;// 'Socket is already connected.';
  WSAENOTCONN                 : Result := rsLongWSAENOTCONN               ;// 'Socket is not connected.';
  WSAESHUTDOWN                : Result := rsLongWSAESHUTDOWN              ;// 'Cannot send after socket shutdown.';
  WSAETOOMANYREFS             : Result := rsLongWSAETOOMANYREFS           ;// 'Too many references.';
  WSAETIMEDOUT                : Result := rsLongWSAETIMEDOUT              ;// 'Connection timed out.';
  WSAECONNREFUSED             : Result := rsLongWSAECONNREFUSED           ;// 'Connection refused.';
  WSAELOOP                    : Result := rsLongWSAELOOP                  ;// 'Cannot translate name.';
  WSAENAMETOOLONG             : Result := rsLongWSAENAMETOOLONG           ;// 'Name too long.';
  WSAEHOSTDOWN                : Result := rsLongWSAEHOSTDOWN              ;// 'Host is down.';
  WSAEHOSTUNREACH             : Result := rsLongWSAEHOSTUNREACH           ;// 'No route to host.';
  WSAENOTEMPTY                : Result := rsLongWSAENOTEMPTY              ;// 'Directory not empty.';
  WSAEPROCLIM                 : Result := rsLongWSAEPROCLIM               ;// 'Too many processes.';
  WSAEUSERS                   : Result := rsLongWSAEUSERS                 ;// 'User quota exceeded.';
  WSAEDQUOT                   : Result := rsLongWSAEDQUOT                 ;// 'Disk quota exceeded.';
  WSAESTALE                   : Result := rsLongWSAESTALE                 ;// 'Stale file handle reference.';
  WSAEREMOTE                  : Result := rsLongWSAEREMOTE                ;// 'Item is remote.';
  WSASYSNOTREADY              : Result := rsLongWSASYSNOTREADY            ;// 'Network subsystem is unavailable.';
  WSAVERNOTSUPPORTED          : Result := rsLongWSAVERNOTSUPPORTED        ;// 'Winsock.dll version out of range.';
  WSANOTINITIALISED           : Result := rsLongWSANOTINITIALISED         ;// 'Successful WSAStartup not yet performed.';
  WSAEDISCON                  : Result := rsLongWSAEDISCON                ;// 'Graceful shutdown in progress.';
  WSAENOMORE                  : Result := rsLongWSAENOMORE                ;// 'No more results.';
  WSAECANCELLED               : Result := rsLongWSAECANCELLED             ;// 'Call has been canceled.';
  WSAEINVALIDPROCTABLE        : Result := rsLongWSAEINVALIDPROCTABLE      ;// 'Procedure call table is invalid.';
  WSAEINVALIDPROVIDER         : Result := rsLongWSAEINVALIDPROVIDER       ;// 'Service provider is invalid.';
  WSAEPROVIDERFAILEDINIT      : Result := rsLongWSAEPROVIDERFAILEDINIT    ;// 'Service provider failed to initialize.';
  WSASYSCALLFAILURE           : Result := rsLongWSASYSCALLFAILURE         ;// 'System call failure.';
  WSASERVICE_NOT_FOUND        : Result := rsLongWSASERVICE_NOT_FOUND      ;// 'Service not found.';
  WSATYPE_NOT_FOUND           : Result := rsLongWSATYPE_NOT_FOUND         ;// 'Class type not found.';
  WSA_E_NO_MORE               : Result := rsLongWSA_E_NO_MORE             ;// 'No more results.';
  WSA_E_CANCELLED             : Result := rsLongWSA_E_CANCELLED           ;// 'Call was canceled.';
  WSAEREFUSED                 : Result := rsLongWSAEREFUSED               ;// 'Database query was refused.';
  WSAHOST_NOT_FOUND           : Result := rsLongWSAHOST_NOT_FOUND         ;// 'Host not found.';
  WSATRY_AGAIN                : Result := rsLongWSATRY_AGAIN              ;// 'Nonauthoritative host not found.';
  WSANO_RECOVERY              : Result := rsLongWSANO_RECOVERY            ;// 'This is a nonrecoverable error.';
  WSANO_DATA                  : Result := rsLongWSANO_DATA                ;// 'Valid name, no data record of requested type.';
  WSA_QOS_RECEIVERS           : Result := rsLongWSA_QOS_RECEIVERS         ;// 'QOS receivers.';
  WSA_QOS_SENDERS             : Result := rsLongWSA_QOS_SENDERS           ;// 'QOS senders.';
  WSA_QOS_NO_SENDERS          : Result := rsLongWSA_QOS_NO_SENDERS        ;// 'No QOS senders.';
  WSA_QOS_NO_RECEIVERS        : Result := rsLongWSA_QOS_NO_RECEIVERS      ;// 'QOS no receivers.';
  WSA_QOS_REQUEST_CONFIRMED   : Result := rsLongWSA_QOS_REQUEST_CONFIRMED ;// 'QOS request confirmed.';
  WSA_QOS_ADMISSION_FAILURE   : Result := rsLongWSA_QOS_ADMISSION_FAILURE ;// 'QOS admission error.';
  WSA_QOS_POLICY_FAILURE      : Result := rsLongWSA_QOS_POLICY_FAILURE    ;// 'QOS policy failure.';
  WSA_QOS_BAD_STYLE           : Result := rsLongWSA_QOS_BAD_STYLE         ;// 'QOS bad style.';
  WSA_QOS_BAD_OBJECT          : Result := rsLongWSA_QOS_BAD_OBJECT        ;// 'QOS bad object.';
  WSA_QOS_TRAFFIC_CTRL_ERROR  : Result := rsLongWSA_QOS_TRAFFIC_CTRL_ERROR;// 'QOS traffic control error.';
  WSA_QOS_GENERIC_ERROR       : Result := rsLongWSA_QOS_GENERIC_ERROR     ;// 'QOS generic error.';
  WSA_QOS_ESERVICETYPE        : Result := rsLongWSA_QOS_ESERVICETYPE      ;// 'QOS service type error.';
  WSA_QOS_EFLOWSPEC           : Result := rsLongWSA_QOS_EFLOWSPEC         ;// 'QOS flowspec error.';
  WSA_QOS_EPROVSPECBUF        : Result := rsLongWSA_QOS_EPROVSPECBUF      ;// 'Invalid QOS provider buffer.';
  WSA_QOS_EFILTERSTYLE        : Result := rsLongWSA_QOS_EFILTERSTYLE      ;// 'Invalid QOS filter style.';
  WSA_QOS_EFILTERTYPE         : Result := rsLongWSA_QOS_EFILTERTYPE       ;// 'Invalid QOS filter type.';
  WSA_QOS_EFILTERCOUNT        : Result := rsLongWSA_QOS_EFILTERCOUNT      ;// 'Incorrect QOS filter count.';
  WSA_QOS_EOBJLENGTH          : Result := rsLongWSA_QOS_EOBJLENGTH        ;// 'Invalid QOS object length.';
  WSA_QOS_EFLOWCOUNT          : Result := rsLongWSA_QOS_EFLOWCOUNT        ;// 'Incorrect QOS flow count.';
  WSA_QOS_EUNKOWNPSOBJ        : Result := rsLongWSA_QOS_EUNKOWNPSOBJ      ;// 'Unrecognized QOS object.';
  WSA_QOS_EPOLICYOBJ          : Result := rsLongWSA_QOS_EPOLICYOBJ        ;// 'Invalid QOS policy object.';
  WSA_QOS_EFLOWDESC           : Result := rsLongWSA_QOS_EFLOWDESC         ;// 'Invalid QOS flow descriptor.';
  WSA_QOS_EPSFLOWSPEC         : Result := rsLongWSA_QOS_EPSFLOWSPEC       ;// 'Invalid QOS provider-specific flowspec.';
  WSA_QOS_EPSFILTERSPEC       : Result := rsLongWSA_QOS_EPSFILTERSPEC     ;// 'Invalid QOS provider-specific filterspec.';
  WSA_QOS_ESDMODEOBJ          : Result := rsLongWSA_QOS_ESDMODEOBJ        ;// 'Invalid QOS shape discard mode object.';
  WSA_QOS_ESHAPERATEOBJ       : Result := rsLongWSA_QOS_ESHAPERATEOBJ     ;// 'Invalid QOS shaping rate object.';
  WSA_QOS_RESERVED_PETYPE     : Result := rsLongWSA_QOS_RESERVED_PETYPE   ;// 'Reserved policy QOS element type.';
 else
  Result := rsUNKNOWN_ERR;
 end;
end;
{$ENDIF}

end.
