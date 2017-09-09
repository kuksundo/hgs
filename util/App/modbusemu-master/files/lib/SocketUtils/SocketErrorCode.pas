unit SocketErrorCode;

interface

{uses Windows;}

const

// взято с http://msdn.microsoft.com/en-us/library/ms740668(VS.85).aspx

  WSA_INVALID_HANDLE    = 6;
  WSA_NOT_ENOUGH_MEMORY = 8;
  WSA_INVALID_PARAMETER = 87;
  WSA_OPERATION_ABORTED = 995;
  WSA_IO_INCOMPLETE     = 996;
  WSA_IO_PENDING        = 997;
  WSAEINTR              = 10004;
  WSAEBADF              = 10009;
  WSAEACCES             = 10013;
  WSAEFAULT             = 10014;
  WSAEINVAL             = 10022;
  WSAEMFILE             = 10024;
  WSAEWOULDBLOCK        = 10035;
  WSAEINPROGRESS        = 10036;
  WSAEALREADY           = 10037;
  WSAENOTSOCK           = 10038;
  WSAEDESTADDRREQ       = 10039;
  WSAEMSGSIZE           = 10040;
  WSAEPROTOTYPE         = 10041;
  WSAENOPROTOOPT        = 10042;
  WSAEPROTONOSUPPORT    = 10043;
  WSAESOCKTNOSUPPORT    = 10044;
  WSAEOPNOTSUPP         = 10045;
  WSAEPFNOSUPPORT       = 10046;
  WSAEAFNOSUPPORT       = 10047;
  WSAEADDRINUSE         = 10048;
  WSAEADDRNOTAVAIL      = 10049;
  WSAENETDOWN           = 10050;
  WSAENETUNREACH        = 10051;
  WSAENETRESET          = 10052;
  WSAECONNABORTED       = 10053;
  WSAECONNRESET         = 10054;
  WSAENOBUFS            = 10055;
  WSAEISCONN            = 10056;
  WSAENOTCONN           = 10057;
  WSAESHUTDOWN          = 10058;
  WSAETOOMANYREFS       = 10059;
  WSAETIMEDOUT          = 10060;
  WSAECONNREFUSED       = 10061;
  WSAELOOP              = 10062;
  WSAENAMETOOLONG       = 10063;
  WSAEHOSTDOWN          = 10064;
  WSAEHOSTUNREACH       = 10065;
  WSAENOTEMPTY          = 10066;
  WSAEPROCLIM           = 10067;
  WSAEUSERS             = 10068;
  WSAEDQUOT             = 10069;
  WSAESTALE             = 10070;
  WSAEREMOTE            = 10071;
  WSASYSNOTREADY        = 10091;

{That the appropriate Windows Sockets DLL file is in the current path.
That they are not trying to use more than one Windows Sockets implementation simultaneously. If there is more than one Winsock DLL on your system, be sure the first one in the path is appropriate for the network subsystem currently loaded.
The Windows Sockets implementation documentation to be sure all necessary components are currently installed and configured correctly.}

  WSAVERNOTSUPPORTED         = 10092;
  WSANOTINITIALISED          = 10093;
  WSAEDISCON                 = 10101;
  WSAENOMORE                 = 10102;
  WSAECANCELLED              = 10103;
  WSAEINVALIDPROCTABLE       = 10104;
  WSAEINVALIDPROVIDER        = 10105;
  WSAEPROVIDERFAILEDINIT     = 10106;
  WSASYSCALLFAILURE          = 10107;
  WSASERVICE_NOT_FOUND       = 10108;
  WSATYPE_NOT_FOUND          = 10109;
  WSA_E_NO_MORE              = 10110;
  WSA_E_CANCELLED            = 10111;
  WSAEREFUSED                = 10112;
  WSAHOST_NOT_FOUND          = 11001;
  WSATRY_AGAIN               = 11002;
  WSANO_RECOVERY             = 11003;
  WSANO_DATA                 = 11004;
  WSA_QOS_RECEIVERS          = 11005;
  WSA_QOS_SENDERS            = 11006;
  WSA_QOS_NO_SENDERS         = 11007;
  WSA_QOS_NO_RECEIVERS       = 11008;
  WSA_QOS_REQUEST_CONFIRMED  = 11009;
  WSA_QOS_ADMISSION_FAILURE  = 11010;
  WSA_QOS_POLICY_FAILURE     = 11011;
  WSA_QOS_BAD_STYLE          = 11012;
  WSA_QOS_BAD_OBJECT         = 11013;
  WSA_QOS_TRAFFIC_CTRL_ERROR = 11014;
  WSA_QOS_GENERIC_ERROR      = 11015;
  WSA_QOS_ESERVICETYPE       = 11016;
  WSA_QOS_EFLOWSPEC          = 11017;
  WSA_QOS_EPROVSPECBUF       = 11018;
  WSA_QOS_EFILTERSTYLE       = 11019;
  WSA_QOS_EFILTERTYPE        = 11020;
  WSA_QOS_EFILTERCOUNT       = 11021;
  WSA_QOS_EOBJLENGTH         = 11022;
  WSA_QOS_EFLOWCOUNT         = 11023;
  WSA_QOS_EUNKOWNPSOBJ       = 11024;
  WSA_QOS_EPOLICYOBJ         = 11025;
  WSA_QOS_EFLOWDESC          = 11026;
  WSA_QOS_EPSFLOWSPEC        = 11027;
  WSA_QOS_EPSFILTERSPEC      = 11028;
  WSA_QOS_ESDMODEOBJ         = 11029;
  WSA_QOS_ESHAPERATEOBJ      = 11030;
  WSA_QOS_RESERVED_PETYPE    = 11031;

implementation

//type
//  wsaevent = THandle;

//const

// Взято из IdWinSock2 Indy Winsock2.h

{// All Windows Sockets error constants are biased by WSABASEERR from the "normal"

  wsabaseerr              = 10000;

// Windows Sockets definitions of regular Microsoft C error constants

  wsaeintr                = wsabaseerr+  4;
  wsaebadf                = wsabaseerr+  9;
  wsaeacces               = wsabaseerr+ 13;
  wsaefault               = wsabaseerr+ 14;
  wsaeinval               = wsabaseerr+ 22;
  wsaemfile               = wsabaseerr+ 24;

// Windows Sockets definitions of regular Berkeley error constants

  wsaewouldblock          = wsabaseerr+ 35;
  wsaeinprogress          = wsabaseerr+ 36;
  wsaealready             = wsabaseerr+ 37;
  wsaenotsock             = wsabaseerr+ 38;
  wsaedestaddrreq         = wsabaseerr+ 39;
  wsaemsgsize             = wsabaseerr+ 40;
  wsaeprototype           = wsabaseerr+ 41;
  wsaenoprotoopt          = wsabaseerr+ 42;
  wsaeprotonosupport      = wsabaseerr+ 43;
  wsaesocktnosupport      = wsabaseerr+ 44;
  wsaeopnotsupp           = wsabaseerr+ 45;
  wsaepfnosupport         = wsabaseerr+ 46;
  wsaeafnosupport         = wsabaseerr+ 47;
  wsaeaddrinuse           = wsabaseerr+ 48;
  wsaeaddrnotavail        = wsabaseerr+ 49;
  wsaenetdown             = wsabaseerr+ 50;
  wsaenetunreach          = wsabaseerr+ 51;
  wsaenetreset            = wsabaseerr+ 52;
  wsaeconnaborted         = wsabaseerr+ 53;
  wsaeconnreset           = wsabaseerr+ 54;
  wsaenobufs              = wsabaseerr+ 55;
  wsaeisconn              = wsabaseerr+ 56;
  wsaenotconn             = wsabaseerr+ 57;
  wsaeshutdown            = wsabaseerr+ 58;
  wsaetoomanyrefs         = wsabaseerr+ 59;
  wsaetimedout            = wsabaseerr+ 60;
  wsaeconnrefused         = wsabaseerr+ 61;
  wsaeloop                = wsabaseerr+ 62;
  wsaenametoolong         = wsabaseerr+ 63;
  wsaehostdown            = wsabaseerr+ 64;
  wsaehostunreach         = wsabaseerr+ 65;
  wsaenotempty            = wsabaseerr+ 66;
  wsaeproclim             = wsabaseerr+ 67;
  wsaeusers               = wsabaseerr+ 68;
  wsaedquot               = wsabaseerr+ 69;
  wsaestale               = wsabaseerr+ 70;
  wsaeremote              = wsabaseerr+ 71;

// Extended Windows Sockets error constant definitions

  wsasysnotready          = wsabaseerr+ 91;
  wsavernotsupported      = wsabaseerr+ 92;
  wsanotinitialised       = wsabaseerr+ 93;
  wsaediscon              = wsabaseerr+101;
  wsaenomore              = wsabaseerr+102;
  wsaecancelled           = wsabaseerr+103;
  wsaeinvalidproctable    = wsabaseerr+104;
  wsaeinvalidprovider     = wsabaseerr+105;
  wsaeproviderfailedinit  = wsabaseerr+106;
  wsasyscallfailure       = wsabaseerr+107;
  wsaservice_not_found    = wsabaseerr+108;
  wsatype_not_found       = wsabaseerr+109;
  wsa_e_no_more           = wsabaseerr+110;
  wsa_e_cancelled         = wsabaseerr+111;
  wsaerefused             = wsabaseerr+112;}


{ Error return codes from gethostbyname and gethostbyaddr
  (when using the resolver). Note that these errors are
  retrieved via WSAGetLastError and must therefore follow
  the rules for avoiding clashes with error numbers from
  specific implementations or language run-time systems.
  For this reason the codes are based at WSABASEERR+1001.
  Note also that [WSA]NO_ADDRESS is defined only for
  compatibility purposes. }

{// Authoritative Answer: Host not found
  wsahost_not_found        = wsabaseerr+1001;

// Non-Authoritative: Host not found, or SERVERFAIL
  wsatry_again             = wsabaseerr+1002;

// Non recoverable errors, FORMERR, REFUSED, NOTIMP
  wsano_recovery           = wsabaseerr+1003;

// Valid name, no data record of requested type
  wsano_data               = wsabaseerr+1004;

// no address, look for MX record
  wsano_address            = wsano_data;

// Define QOS related error return codes

  wsa_qos_receivers          = wsabaseerr+1005; // at least one reserve has arrived
  wsa_qos_senders            = wsabaseerr+1006; // at least one path has arrived
  wsa_qos_no_senders         = wsabaseerr+1007; // there are no senders
  wsa_qos_no_receivers       = wsabaseerr+1008; // there are no receivers
  wsa_qos_request_confirmed  = wsabaseerr+1009; // reserve has been confirmed
  wsa_qos_admission_failure  = wsabaseerr+1010; // error due to lack of resources
  wsa_qos_policy_failure     = wsabaseerr+1011; // rejected for administrative reasons - bad credentials
  wsa_qos_bad_style          = wsabaseerr+1012; // unknown or conflicting style
  wsa_qos_bad_object         = wsabaseerr+1013; // problem with some part of the filterspec or providerspecific buffer in general
  wsa_qos_traffic_ctrl_error = wsabaseerr+1014; // problem with some part of the flowspec
  wsa_qos_generic_error      = wsabaseerr+1015; // general error
  wsa_qos_eservicetype       = wsabaseerr+1016; // invalid service type in flowspec
  wsa_qos_eflowspec          = wsabaseerr+1017; // invalid flowspec
  wsa_qos_eprovspecbuf       = wsabaseerr+1018; // invalid provider specific buffer
  wsa_qos_efilterstyle       = wsabaseerr+1019; // invalid filter style
  wsa_qos_efiltertype        = wsabaseerr+1020; // invalid filter type
  wsa_qos_efiltercount       = wsabaseerr+1021; // incorrect number of filters
  wsa_qos_eobjlength         = wsabaseerr+1022; // invalid object length
  wsa_qos_eflowcount         = wsabaseerr+1023; // incorrect number of flows
  wsa_qos_eunkownpsobj       = wsabaseerr+1024; // unknown object in provider specific buffer
  wsa_qos_epolicyobj         = wsabaseerr+1025; // invalid policy object in provider specific buffer
  wsa_qos_eflowdesc          = wsabaseerr+1026; // invalid flow descriptor in the list
  wsa_qos_epsflowspec        = wsabaseerr+1027; // inconsistent flow spec in provider specific buffer
  wsa_qos_epsfilterspec      = wsabaseerr+1028; // invalid filter spec in provider specific buffer
  wsa_qos_esdmodeobj         = wsabaseerr+1029; // invalid shape discard mode object in provider specific buffer
  wsa_qos_eshaperateobj      = wsabaseerr+1030; // invalid shaping rate object in provider specific buffer
  wsa_qos_reserved_petype    = wsabaseerr+1031; // reserved policy element in provider specific buffer}


{ WinSock 2 extension -- new error codes and type definition }
{  wsa_io_pending          = error_io_pending;
  wsa_io_incomplete       = error_io_incomplete;
  wsa_invalid_handle      = error_invalid_handle;
  wsa_invalid_parameter   = error_invalid_parameter;
  wsa_not_enough_memory   = error_not_enough_memory;
  wsa_operation_aborted   = error_operation_aborted;
  wsa_invalid_event       = wsaevent(nil);
  wsa_maximum_wait_events = maximum_wait_objects;
  wsa_wait_failed         = $ffffffff;
  wsa_wait_event_0        = wait_object_0;
  wsa_wait_io_completion  = wait_io_completion;
  wsa_wait_timeout        = wait_timeout;
  wsa_infinite            = infinite;}

end.
