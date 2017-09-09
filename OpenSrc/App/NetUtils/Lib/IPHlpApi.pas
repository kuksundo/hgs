{*******************************************************}
{                                                       }
{       Borland Delphi Runtime Library                  }
{       IP Helper API Interface Unit                    }
{                                                       }
{       Copyright (c) Microsoft Corporation.            }
{                                                       }
{       Translator: Vadim Crits                         }
{                                                       }
{*******************************************************}

unit IPHlpApi;

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

interface

uses Windows;

const

{ TAddressFamily }

  AF_UNSPEC = 0;
  AF_INET   = 2;
  AF_INET6  = 23;

type
  PUINT64 = ^UINT64;

  TAddressFamily = Word;

  PSockAddr = ^TSockAddr;
  TSockAddr = record
    sa_family: TAddressFamily;         { address family }
    sa_data: array[0..13] of AnsiChar; { up to 14 bytes of direct address }
  end;

  PInAddr = ^TInAddr;
  TInAddr = record
    S_un: record
      case Integer of
        0: (S_un_b: record s_b1, s_b2, s_b3, s_b4: Byte; end);
        1: (S_un_w: record s_w1, s_w2: Word; end);
        2: (S_addr: ULONG);
    end;
  end;

  PIn6Addr = ^TIn6Addr;
  TIn6Addr = record
    u: record
      case Integer of
        0: (Byte: array[0..15] of Byte);
        1: (Word: array[0..7] of Word);
    end;
  end;

  PIpv6Addr = ^TIpv6Addr;
  TIpv6Addr = TIn6Addr;

  PSockAddrIn = ^TSockAddrIn;
  TSockAddrIn = record
    sin_family: TAddressFamily;
    sin_port: Word;
    sin_addr: TInAddr;
    sin_zero: array[0..7] of AnsiChar;
  end;

  TScopeLevel = (
    ScopeLevelInterface    = 1,
    ScopeLevelLink         = 2,
    ScopeLevelSubnet       = 3,
    ScopeLevelAdmin        = 4,
    ScopeLevelSite         = 5,
    ScopeLevelOrganization = 8,
    ScopeLevelGlobal       = 14,
    ScopeLevelCount        = 16);

  PScopeId = ^TScopeId;
  TScopeId = record
    case Integer of
      0: (Flags: ULONG);
      1: (Value: ULONG);
  end;

  PSockAddrIn6 = ^TSockAddrIn6;
  TSockAddrIn6 = record
    sin6_family: TAddressFamily; { AF_INET6 }
    sin6_port: Word;             { Transport level port number }
    sin6_flowinfo: ULONG;        { IPv6 flow information }
    sin6_addr: TIn6Addr;         { IPv6 address }
    case Integer of
      0: (sin6_scope_id: ULONG); { set of interfaces for a scope }
      1: (sin6_scope_struct: TScopeId);
  end;

  PSockAddrInet = ^TSockAddrInet;
  TSockAddrInet = record
    case Integer of
      0: (Ipv4: TSockAddrIn);
      1: (Ipv6: TSockAddrIn6);
      2: (si_family: TAddressFamily);
  end;

  PSockAddrIn6Pair = ^TSockAddrIn6Pair;
  TSockAddrIn6Pair = record
    SourceAddress: PSockAddrIn6;
    DestinationAddress: PSockAddrIn6;
  end;

  PSocketAddress = ^TSocketAddress;
  TSocketAddress = record
    lpSockaddr: PSocketAddress;
    iSockaddrLength: Integer;
  end;
  
  PIoStatusBlock = ^TIoStatusBlock;
  TIoStatusBlock = record
    Status: Longint;
    Information: ULONG;
  end;

  TIoApcRoutine = procedure(ApcContext: Pointer; IoStatusBlock: PIoStatusBlock;
    Reserved: ULONG); stdcall;

  PNdisMedium = ^TNdisMedium;
  TNdisMedium = (
    NdisMedium802_3,
    NdisMedium802_5,
    NdisMediumFddi,
    NdisMediumWan,
    NdisMediumLocalTalk,
    NdisMediumDix,          { defined for convenience, not a real medium }
    NdisMediumArcnetRaw,
    NdisMediumArcnet878_2,
    NdisMediumAtm,
    NdisMediumWirelessWan,
    NdisMediumIrda,
    NdisMediumBpc,
    NdisMediumCoWan,
    NdisMedium1394,
    NdisMediumInfiniBand,
    NdisMediumTunnel,
    NdisMediumNative802_11,
    NdisMediumLoopback,
    NdisMediumMax);         { Not a real medium, defined as an upper-bound }

{ Physical Medium Type definitions. Used with OID_GEN_PHYSICAL_MEDIUM. }

  PNdisPhysicalMedium = ^TNdisPhysicalMedium;
  TNdisPhysicalMedium = (
    NdisPhysicalMediumUnspecified,
    NdisPhysicalMediumWirelessLan,
    NdisPhysicalMediumCableModem,
    NdisPhysicalMediumPhoneLine,
    NdisPhysicalMediumPowerLine,
    NdisPhysicalMediumDSL,          { includes ADSL and UADSL (G.Lite) }
    NdisPhysicalMediumFibreChannel,
    NdisPhysicalMedium1394,
    NdisPhysicalMediumWirelessWan,
    NdisPhysicalMediumNative802_11,
    NdisPhysicalMediumBluetooth,
    NdisPhysicalMediumInfiniband,
    NdisPhysicalMediumWiMax,
    NdisPhysicalMediumUWB,
    NdisPhysicalMedium802_3,
    NdisPhysicalMedium802_5,
    NdisPhysicalMediumIrda,
    NdisPhysicalMediumWiredWAN,
    NdisPhysicalMediumWiredCoWan,
    NdisPhysicalMediumOther,
    NdisPhysicalMediumMax);         { Not a real physical type, defined as an upper-bound }

const

{ Media types

  These are enumerated values of the ifType object defined in MIB-II's
  ifTable.  They are registered with IANA which publishes this list
  periodically, in either the Assigned Numbers RFC, or some derivative
  of it specific to Internet Network Management number assignments.
  See ftp://ftp.isi.edu/mib/ianaiftype.mib }

  MIN_IF_TYPE                     = 1;

  IF_TYPE_OTHER                   = 1;   { None of the below }
  IF_TYPE_REGULAR_1822            = 2;
  IF_TYPE_HDH_1822                = 3;
  IF_TYPE_DDN_X25                 = 4;
  IF_TYPE_RFC877_X25              = 5;
  IF_TYPE_ETHERNET_CSMACD         = 6;
  IF_TYPE_IS088023_CSMACD         = 7;
  IF_TYPE_ISO88024_TOKENBUS       = 8;
  IF_TYPE_ISO88025_TOKENRING      = 9;
  IF_TYPE_ISO88026_MAN            = 10;
  IF_TYPE_STARLAN                 = 11;
  IF_TYPE_PROTEON_10MBIT          = 12;
  IF_TYPE_PROTEON_80MBIT          = 13;
  IF_TYPE_HYPERCHANNEL            = 14;
  IF_TYPE_FDDI                    = 15;
  IF_TYPE_LAP_B                   = 16;
  IF_TYPE_SDLC                    = 17;
  IF_TYPE_DS1                     = 18;  { DS1-MIB }
  IF_TYPE_E1                      = 19;  { Obsolete; see DS1-MIB }
  IF_TYPE_BASIC_ISDN              = 20;
  IF_TYPE_PRIMARY_ISDN            = 21;
  IF_TYPE_PROP_POINT2POINT_SERIAL = 22;  { proprietary serial }
  IF_TYPE_PPP                     = 23;
  IF_TYPE_SOFTWARE_LOOPBACK       = 24;
  IF_TYPE_EON                     = 25;  { CLNP over IP }
  IF_TYPE_ETHERNET_3MBIT          = 26;
  IF_TYPE_NSIP                    = 27;  { XNS over IP }
  IF_TYPE_SLIP                    = 28;  { Generic Slip }
  IF_TYPE_ULTRA                   = 29;  { ULTRA Technologies }
  IF_TYPE_DS3                     = 30;  { DS3-MIB }
  IF_TYPE_SIP                     = 31;  { SMDS, coffee }
  IF_TYPE_FRAMERELAY              = 32;  { DTE only }
  IF_TYPE_RS232                   = 33;
  IF_TYPE_PARA                    = 34;  { Parallel port }
  IF_TYPE_ARCNET                  = 35;
  IF_TYPE_ARCNET_PLUS             = 36;
  IF_TYPE_ATM                     = 37;  { ATM cells }
  IF_TYPE_MIO_X25                 = 38;
  IF_TYPE_SONET                   = 39;  { SONET or SDH }
  IF_TYPE_X25_PLE                 = 40;
  IF_TYPE_ISO88022_LLC            = 41;
  IF_TYPE_LOCALTALK               = 42;
  IF_TYPE_SMDS_DXI                = 43;
  IF_TYPE_FRAMERELAY_SERVICE      = 44;  { FRNETSERV-MIB }
  IF_TYPE_V35                     = 45;
  IF_TYPE_HSSI                    = 46;
  IF_TYPE_HIPPI                   = 47;
  IF_TYPE_MODEM                   = 48;  { Generic Modem }
  IF_TYPE_AAL5                    = 49;  { AAL5 over ATM }
  IF_TYPE_SONET_PATH              = 50;
  IF_TYPE_SONET_VT                = 51;
  IF_TYPE_SMDS_ICIP               = 52;  { SMDS InterCarrier Interface }
  IF_TYPE_PROP_VIRTUAL            = 53;  { Proprietary virtual/internal }
  IF_TYPE_PROP_MULTIPLEXOR        = 54;  { Proprietary multiplexing }
  IF_TYPE_IEEE80212               = 55;  { 100BaseVG }
  IF_TYPE_FIBRECHANNEL            = 56;
  IF_TYPE_HIPPIINTERFACE          = 57;
  IF_TYPE_FRAMERELAY_INTERCONNECT = 58;  { Obsolete, use 32 or 44 }
  IF_TYPE_AFLANE_8023             = 59;  { ATM Emulated LAN for 802.3 }
  IF_TYPE_AFLANE_8025             = 60;  { ATM Emulated LAN for 802.5 }
  IF_TYPE_CCTEMUL                 = 61;  { ATM Emulated circuit }
  IF_TYPE_FASTETHER               = 62;  { Fast Ethernet (100BaseT) }
  IF_TYPE_ISDN                    = 63;  { ISDN and X.25 }
  IF_TYPE_V11                     = 64;  { CCITT V.11/X.21 }
  IF_TYPE_V36                     = 65;  { CCITT V.36 }
  IF_TYPE_G703_64K                = 66;  { CCITT G703 at 64Kbps }
  IF_TYPE_G703_2MB                = 67;  { Obsolete; see DS1-MIB }
  IF_TYPE_QLLC                    = 68;  { SNA QLLC }
  IF_TYPE_FASTETHER_FX            = 69;  { Fast Ethernet (100BaseFX) }
  IF_TYPE_CHANNEL                 = 70;
  IF_TYPE_IEEE80211               = 71;  { Radio spread spectrum }
  IF_TYPE_IBM370PARCHAN           = 72;  { IBM System 360/370 OEMI Channel }
  IF_TYPE_ESCON                   = 73;  { IBM Enterprise Systems Connection }
  IF_TYPE_DLSW                    = 74;  { Data Link Switching }
  IF_TYPE_ISDN_S                  = 75;  { ISDN S/T interface }
  IF_TYPE_ISDN_U                  = 76;  { ISDN U interface }
  IF_TYPE_LAP_D                   = 77;  { Link Access Protocol D }
  IF_TYPE_IPSWITCH                = 78;  { IP Switching Objects }
  IF_TYPE_RSRB                    = 79;  { Remote Source Route Bridging }
  IF_TYPE_ATM_LOGICAL             = 80;  { ATM Logical Port }
  IF_TYPE_DS0                     = 81;  { Digital Signal Level 0 }
  IF_TYPE_DS0_BUNDLE              = 82;  { Group of ds0s on the same ds1 }
  IF_TYPE_BSC                     = 83;  { Bisynchronous Protocol }
  IF_TYPE_ASYNC                   = 84;  { Asynchronous Protocol }
  IF_TYPE_CNR                     = 85;  { Combat Net Radio }
  IF_TYPE_ISO88025R_DTR           = 86;  { ISO 802.5r DTR }
  IF_TYPE_EPLRS                   = 87;  { Ext Pos Loc Report Sys }
  IF_TYPE_ARAP                    = 88;  { Appletalk Remote Access Protocol }
  IF_TYPE_PROP_CNLS               = 89;  { Proprietary Connectionless Proto }
  IF_TYPE_HOSTPAD                 = 90;  { CCITT-ITU X.29 PAD Protocol }
  IF_TYPE_TERMPAD                 = 91;  { CCITT-ITU X.3 PAD Facility }
  IF_TYPE_FRAMERELAY_MPI          = 92;  { Multiproto Interconnect over FR }
  IF_TYPE_X213                    = 93;  { CCITT-ITU X213 }
  IF_TYPE_ADSL                    = 94;  { Asymmetric Digital Subscrbr Loop }
  IF_TYPE_RADSL                   = 95;  { Rate-Adapt Digital Subscrbr Loop }
  IF_TYPE_SDSL                    = 96;  { Symmetric Digital Subscriber Loop }
  IF_TYPE_VDSL                    = 97;  { Very H-Speed Digital Subscrb Loop }
  IF_TYPE_ISO88025_CRFPRINT       = 98;  { ISO 802.5 CRFP }
  IF_TYPE_MYRINET                 = 99;  { Myricom Myrinet }
  IF_TYPE_VOICE_EM                = 100; { Voice recEive and transMit }
  IF_TYPE_VOICE_FXO               = 101; { Voice Foreign Exchange Office }
  IF_TYPE_VOICE_FXS               = 102; { Voice Foreign Exchange Station }
  IF_TYPE_VOICE_ENCAP             = 103; { Voice encapsulation }
  IF_TYPE_VOICE_OVERIP            = 104; { Voice over IP encapsulation }
  IF_TYPE_ATM_DXI                 = 105; { ATM DXI }
  IF_TYPE_ATM_FUNI                = 106; { ATM FUNI }
  IF_TYPE_ATM_IMA                 = 107; { ATM IMA }
  IF_TYPE_PPPMULTILINKBUNDLE      = 108; { PPP Multilink Bundle }
  IF_TYPE_IPOVER_CDLC             = 109; { IBM ipOverCdlc }
  IF_TYPE_IPOVER_CLAW             = 110; { IBM Common Link Access to Workstn }
  IF_TYPE_STACKTOSTACK            = 111; { IBM stackToStack }
  IF_TYPE_VIRTUALIPADDRESS        = 112; { IBM VIPA }
  IF_TYPE_MPC                     = 113; { IBM multi-proto channel support }
  IF_TYPE_IPOVER_ATM              = 114; { IBM ipOverAtm }
  IF_TYPE_ISO88025_FIBER          = 115; { ISO 802.5j Fiber Token Ring }
  IF_TYPE_TDLC                    = 116; { IBM twinaxial data link control }
  IF_TYPE_GIGABITETHERNET         = 117;
  IF_TYPE_HDLC                    = 118;
  IF_TYPE_LAP_F                   = 119;
  IF_TYPE_V37                     = 120;
  IF_TYPE_X25_MLP                 = 121; { Multi-Link Protocol }
  IF_TYPE_X25_HUNTGROUP           = 122; { X.25 Hunt Group }
  IF_TYPE_TRANSPHDLC              = 123;
  IF_TYPE_INTERLEAVE              = 124; { Interleave channel }
  IF_TYPE_FAST                    = 125; { Fast channel }
  IF_TYPE_IP                      = 126; { IP (for APPN HPR in IP networks) }
  IF_TYPE_DOCSCABLE_MACLAYER      = 127; { CATV Mac Layer }
  IF_TYPE_DOCSCABLE_DOWNSTREAM    = 128; { CATV Downstream interface }
  IF_TYPE_DOCSCABLE_UPSTREAM      = 129; { CATV Upstream interface }
  IF_TYPE_A12MPPSWITCH            = 130; { Avalon Parallel Processor }
  IF_TYPE_TUNNEL                  = 131; { Encapsulation interface }
  IF_TYPE_COFFEE                  = 132; { Coffee pot }
  IF_TYPE_CES                     = 133; { Circuit Emulation Service }
  IF_TYPE_ATM_SUBINTERFACE        = 134; { ATM Sub Interface }
  IF_TYPE_L2_VLAN                 = 135; { Layer 2 Virtual LAN using 802.1Q }
  IF_TYPE_L3_IPVLAN               = 136; { Layer 3 Virtual LAN using IP }
  IF_TYPE_L3_IPXVLAN              = 137; { Layer 3 Virtual LAN using IPX }
  IF_TYPE_DIGITALPOWERLINE        = 138; { IP over Power Lines }
  IF_TYPE_MEDIAMAILOVERIP         = 139; { Multimedia Mail over IP }
  IF_TYPE_DTM                     = 140; { Dynamic syncronous Transfer Mode }
  IF_TYPE_DCN                     = 141; { Data Communications Network }
  IF_TYPE_IPFORWARD               = 142; { IP Forwarding Interface }
  IF_TYPE_MSDSL                   = 143; { Multi-rate Symmetric DSL }
  IF_TYPE_IEEE1394                = 144; { IEEE1394 High Perf Serial Bus }
  IF_TYPE_IF_GSN                  = 145;
  IF_TYPE_DVBRCC_MACLAYER         = 146;
  IF_TYPE_DVBRCC_DOWNSTREAM       = 147;
  IF_TYPE_DVBRCC_UPSTREAM         = 148;
  IF_TYPE_ATM_VIRTUAL             = 149;
  IF_TYPE_MPLS_TUNNEL             = 150;
  IF_TYPE_SRP                     = 151;
  IF_TYPE_VOICEOVERATM            = 152;
  IF_TYPE_VOICEOVERFRAMERELAY     = 153;
  IF_TYPE_IDSL                    = 154;
  IF_TYPE_COMPOSITELINK           = 155;
  IF_TYPE_SS7_SIGLINK             = 156;
  IF_TYPE_PROP_WIRELESS_P2P       = 157;
  IF_TYPE_FR_FORWARD              = 158;
  IF_TYPE_RFC1483                 = 159;
  IF_TYPE_USB                     = 160;
  IF_TYPE_IEEE8023AD_LAG          = 161;
  IF_TYPE_BGP_POLICY_ACCOUNTING   = 162;
  IF_TYPE_FRF16_MFR_BUNDLE        = 163;
  IF_TYPE_H323_GATEKEEPER         = 164;
  IF_TYPE_H323_PROXY              = 165;
  IF_TYPE_MPLS                    = 166;
  IF_TYPE_MF_SIGLINK              = 167;
  IF_TYPE_HDSL2                   = 168;
  IF_TYPE_SHDSL                   = 169;
  IF_TYPE_DS1_FDL                 = 170;
  IF_TYPE_POS                     = 171;
  IF_TYPE_DVB_ASI_IN              = 172;
  IF_TYPE_DVB_ASI_OUT             = 173;
  IF_TYPE_PLC                     = 174;
  IF_TYPE_NFAS                    = 175;
  IF_TYPE_TR008                   = 176;
  IF_TYPE_GR303_RDT               = 177;
  IF_TYPE_GR303_IDT               = 178;
  IF_TYPE_ISUP                    = 179;
  IF_TYPE_PROP_DOCS_WIRELESS_MACLAYER      = 180;
  IF_TYPE_PROP_DOCS_WIRELESS_DOWNSTREAM    = 181;
  IF_TYPE_PROP_DOCS_WIRELESS_UPSTREAM      = 182;
  IF_TYPE_HIPERLAN2                        = 183;
  IF_TYPE_PROP_BWA_P2MP                    = 184;
  IF_TYPE_SONET_OVERHEAD_CHANNEL           = 185;
  IF_TYPE_DIGITAL_WRAPPER_OVERHEAD_CHANNEL = 186;
  IF_TYPE_AAL2                             = 187;
  IF_TYPE_RADIO_MAC                        = 188;
  IF_TYPE_ATM_RADIO                        = 189;
  IF_TYPE_IMT                              = 190;
  IF_TYPE_MVL                              = 191;
  IF_TYPE_REACH_DSL                        = 192;
  IF_TYPE_FR_DLCI_ENDPT                    = 193;
  IF_TYPE_ATM_VCI_ENDPT                    = 194;
  IF_TYPE_OPTICAL_CHANNEL                  = 195;
  IF_TYPE_OPTICAL_TRANSPORT                = 196;

  MAX_IF_TYPE                     = 196;

type
  TIfType = ULONG;

{ Access types }

  TIfAccessType = (
    IF_ACCESS_LOOPBACK             = 1,
    IF_ACCESS_BROADCAST            = 2,
    IF_ACCESS_POINT_TO_POINT       = 3,
    IF_ACCESS_POINT_TO_MULTI_POINT = 4);

const

{ Interface Capabilities (bit flags) }

  IF_CHECK_NONE  = $00;
  IF_CHECK_MCAST = $01;
  IF_CHECK_SEND  = $02;

{ Connection Types }

  IF_CONNECTION_DEDICATED = 1;
  IF_CONNECTION_PASSIVE   = 2;
  IF_CONNECTION_DEMAND    = 3;

  IF_ADMIN_STATUS_UP      = 1;
  IF_ADMIN_STATUS_DOWN    = 2;
  IF_ADMIN_STATUS_TESTING = 3;

type
  
{ The following are the the operational states for WAN and LAN interfaces.
  The order of the states seems weird, but is done for a purpose. All
  states >= CONNECTED can transmit data right away. States >= DISCONNECTED
  can tx data but some set up might be needed. States < DISCONNECTED can
  not transmit data.
  A card is marked UNREACHABLE if DIM calls InterfaceUnreachable for
  reasons other than failure to connect.

  NON_OPERATIONAL -- Valid for LAN Interfaces. Means the card is not
                       working or not plugged in or has no address.
  UNREACHABLE     -- Valid for WAN Interfaces. Means the remote site is
                       not reachable at this time.
  DISCONNECTED    -- Valid for WAN Interfaces. Means the remote site is
                       not connected at this time.
  CONNECTING      -- Valid for WAN Interfaces. Means a connection attempt
                       has been initiated to the remote site.
  CONNECTED       -- Valid for WAN Interfaces. Means the remote site is
                       connected.
  OPERATIONAL     -- Valid for LAN Interfaces. Means the card is plugged
                       in and working.

  It is the users duty to convert these values to MIB-II values if they
  are to be used by a subagent }

  TInternalIfOperStatus = (
    IF_OPER_STATUS_NON_OPERATIONAL = 0,
    IF_OPER_STATUS_UNREACHABLE     = 1,
    IF_OPER_STATUS_DISCONNECTED    = 2,
    IF_OPER_STATUS_CONNECTING      = 3,
    IF_OPER_STATUS_CONNECTED       = 4,
    IF_OPER_STATUS_OPERATIONAL     = 5);

const
  MIB_IF_TYPE_OTHER           = 1;
  MIB_IF_TYPE_ETHERNET        = 6;
  MIB_IF_TYPE_TOKENRING       = 9;
  MIB_IF_TYPE_FDDI            = 15;
  MIB_IF_TYPE_PPP             = 23;
  MIB_IF_TYPE_LOOPBACK        = 24;
  MIB_IF_TYPE_SLIP            = 28;

  MIB_IF_ADMIN_STATUS_UP      = 1;
  MIB_IF_ADMIN_STATUS_DOWN    = 2;
  MIB_IF_ADMIN_STATUS_TESTING = 3;

{ N.B. The name is a misnomer.  These are NOT the values used by MIB-II. }

  MIB_IF_OPER_STATUS_NON_OPERATIONAL = IF_OPER_STATUS_NON_OPERATIONAL;
  MIB_IF_OPER_STATUS_UNREACHABLE     = IF_OPER_STATUS_UNREACHABLE;
  MIB_IF_OPER_STATUS_DISCONNECTED    = IF_OPER_STATUS_DISCONNECTED;
  MIB_IF_OPER_STATUS_CONNECTING      = IF_OPER_STATUS_CONNECTING;
  MIB_IF_OPER_STATUS_CONNECTED       = IF_OPER_STATUS_CONNECTED;
  MIB_IF_OPER_STATUS_OPERATIONAL     = IF_OPER_STATUS_OPERATIONAL;

type
  PNetIfObjectId = ^TNetIfObjectId;
  TNetIfObjectId = ULONG;

  PNetIfAdminStatus = ^TNetIfAdminStatus;
  TNetIfAdminStatus = (
    NET_IF_ADMIN_STATUS_UP = 1,
    NET_IF_ADMIN_STATUS_DOWN = 2,
    NET_IF_ADMIN_STATUS_TESTING = 3);

  PNetIfOperStatus = ^TNetIfOperStatus;
  TNetIfOperStatus = (
    NET_IF_OPER_STATUS_UP = 1,
    NET_IF_OPER_STATUS_DOWN = 2,
    NET_IF_OPER_STATUS_TESTING = 3,
    NET_IF_OPER_STATUS_UNKNOWN = 4,
    NET_IF_OPER_STATUS_DORMANT = 5,
    NET_IF_OPER_STATUS_NOT_PRESENT = 6,
    NET_IF_OPER_STATUS_LOWER_LAYER_DOWN = 7);

const

{ Flags to extend operational status }

  NET_IF_OPER_STATUS_DOWN_NOT_AUTHENTICATED   = $00000001;
  NET_IF_OPER_STATUS_DOWN_NOT_MEDIA_CONNECTED = $00000002;
  NET_IF_OPER_STATUS_DORMANT_PAUSED           = $00000004;
  NET_IF_OPER_STATUS_DORMANT_LOW_POWER        = $00000008;

type
  PNetIfCompartmentId = ^TNetIfCompartmentId;
  TNetIfCompartmentId = UINT;

const

{ Define compartment ID type: }

  NET_IF_COMPARTMENT_ID_UNSPECIFIED = TNetIfCompartmentId(0);
  NET_IF_COMPARTMENT_ID_PRIMARY     = TNetIfCompartmentId(1);

  NET_IF_OID_IF_ALIAS       = $00000001; { identifies the ifAlias string for an interface  }
  NET_IF_OID_COMPARTMENT_ID = $00000002; { identifies the compartment ID for an interface. }
  NET_IF_OID_NETWORK_GUID   = $00000003; { identifies the NetworkGuid for an interface. }
  NET_IF_OID_IF_ENTRY       = $00000004; { identifies statistics for an interface. }

type  

{ Define NetworkGUID type: }

  PNetIfNetworkGuid = ^TNetIfNetworkGuid;
  TNetIfNetworkGuid = TGUID;

const

{ To prevent collisions between user-assigned and system-assigend site-ids,
  we partition the site-id space into two:
  1. User-Assigned: NET_SITEID_UNSPECIFIED < SiteId < NET_SITEID_MAXUSER
  2. System-Assigned: NET_SITEID_MAXUSER < SiteId < NET_SITEID_MAXSYSTEM

  Note: A network's SiteId doesn't really need to be settable.
  1. The network profile manager creates a network per network profile.
  2. NDIS/IF assigns a unique SiteId to each network. }

  NET_SITEID_UNSPECIFIED = 0;
  NET_SITEID_MAXUSER     = $07ffffff;
  NET_SITEID_MAXSYSTEM   = $0fffffff;

type
  PNetIfRcvAddressType = ^TNetIfRcvAddressType;
  TNetIfRcvAddressType = (
    NET_IF_RCV_ADDRESS_TYPE_OTHER = 1,
    NET_IF_RCV_ADDRESS_TYPE_VOLATILE = 2,
    NET_IF_RCV_ADDRESS_TYPE_NON_VOLATILE = 3);

  PNetIfRcvAddress = ^TNetIfRcvAddress;
  TNetIfRcvAddress = record
    ifRcvAddressType: TNetIfRcvAddressType;
    ifRcvAddressLength: Word;
    ifRcvAddressOffset: Word; { from beginning of this struct }
  end;

  PNetIfAlias = ^TNetIfAlias;
  TNetIfAlias = record
    ifAliasLength: Word; { in bytes, of ifAlias string }
    ifAliasOffset: Word; { in bytes, from beginning of this struct }
  end;

  PNetLuid = ^TNetLuid;
  TNetLuid = record
    case Integer of
      0: (Value: UINT64);
      1: (Info: UINT64);
  end;

  PIfLuid = ^TIfLuid;
  TIfLuid = TNetLuid;
  
  PNetIfIndex = ^TNetIfIndex;
  TNetIfIndex = ULONG;

  PNetIfType = ^TNetIfType;
  TNetIfType = Word;

const
  NET_IFINDEX_UNSPECIFIED = TNetIfIndex(0); { Not a valid ifIndex }
  NET_IFLUID_UNSPECIFIED  = 0;              { Not a valid if Luid }

{ Definitions for NET_IF_INFORMATION.Flags }

  NIIF_HARDWARE_INTERFACE      = $00000001; { Set iff hardware }
  NIIF_FILTER_INTERFACE        = $00000002;
  NIIF_NDIS_RESERVED1          = $00000004;
  NIIF_NDIS_RESERVED2          = $00000008;
  NIIF_NDIS_RESERVED3          = $00000010;
  NIIF_NDIS_WDM_INTERFACE      = $00000020;
  NIIF_NDIS_ENDPOINT_INTERFACE = $00000040;
  NIIF_NDIS_ISCSI_INTERFACE    = $00000080;

  NIIF_WAN_TUNNEL_TYPE_UNKNOWN = ULONG(-1);

type

{ Define datalink interface access types. }

  PNetIfAccessType = ^TNetIfAccessType;
  TNetIfAccessType = (
    NET_IF_ACCESS_LOOPBACK = 1,
    NET_IF_ACCESS_BROADCAST = 2,
    NET_IF_ACCESS_POINT_TO_POINT = 3,
    NET_IF_ACCESS_POINT_TO_MULTI_POINT = 4,
    NET_IF_ACCESS_MAXIMUM = 5);

{ Define datalink interface direction types. }

  PNetIfDirectionType = ^TNetIfDirectionType;
  TNetIfDirectionType = (
    NET_IF_DIRECTION_SENDRECEIVE,
    NET_IF_DIRECTION_SENDONLY,
    NET_IF_DIRECTION_RECEIVEONLY,
    NET_IF_DIRECTION_MAXIMUM);

  PNetIfConnectionType = ^TNetIfConnectionType;
  TNetIfConnectionType = (
   NET_IF_CONNECTION_DEDICATED = 1,
   NET_IF_CONNECTION_PASSIVE = 2,
   NET_IF_CONNECTION_DEMAND = 3,
   NET_IF_CONNECTION_MAXIMUM = 4);

  PNetIfMediaConnectState = ^TNetIfMediaConnectState;
  TNetIfMediaConnectState = (
    MediaConnectStateUnknown,
    MediaConnectStateConnected,
    MediaConnectStateDisconnected);

const
  NET_IF_LINK_SPEED_UNKNOWN = UINT64(-1);

type

{ Defines the duplex state of media }

  PNetIfMediaDuplexState = ^TNetIfMediaDuplexState;
  TNetIfMediaDuplexState = (
    MediaDuplexStateUnknown,
    MediaDuplexStateHalf,
    MediaDuplexStateFull);

const

{ Special values for fields in NET_PHYSICAL_LOCATION }

  NIIF_BUS_NUMBER_UNKNOWN      =  ULONG(-1);
  NIIF_SLOT_NUMBER_UNKNOWN     =  ULONG(-1);
  NIIF_FUNCTION_NUMBER_UNKNOWN =  ULONG(-1);

type
  PNetPhysicalLocation = ^TNetPhysicalLocation;
  TNetPhysicalLocation = record
    BusNumber: ULONG;      { Physical location }
    SlotNumber: ULONG;     { ... for hardware }
    FunctionNumber: ULONG; { ... devices. }
  end;

const

{ maximum string size in -wchar- units }

  IF_MAX_STRING_SIZE = 256;

type
  PIfCountedString = ^TIfCountedString;
  TIfCountedString = record
    Length: Word; { in -Bytes- }
    Str: array[0..IF_MAX_STRING_SIZE] of WCHAR;
  end;

const
  IF_MAX_PHYS_ADDRESS_LENGTH = 32;

type
  PIfPhysicalAddress = ^TIfPhysicalAddress;
  TIfPhysicalAddress = record
    Length: Word;
    Address: array[0..IF_MAX_PHYS_ADDRESS_LENGTH - 1] of UCHAR;
  end;

{ Define the interface index type.
  This type is not persistable.
  This must be unsigned (not an enum) to replace previous uses of
  an index that used a DWORD type. }

  PIfIndex = ^TIfIndex;
  TIfIndex = TNetIfIndex;

const
  IFI_UNSPECIFIED = NET_IFINDEX_UNSPECIFIED;
  
type

{ Types of tunnels (sub-type of IF_TYPE when IF_TYPE is IF_TYPE_TUNNEL). }

  PTunnelType = ^TTunnelType;
  TTunnelType = (
    TUNNEL_TYPE_NONE = 0,
    TUNNEL_TYPE_OTHER = 1,
    TUNNEL_TYPE_DIRECT = 2,
    TUNNEL_TYPE_6TO4 = 11,
    TUNNEL_TYPE_ISATAP = 13,
    TUNNEL_TYPE_TEREDO = 14,
    TUNNEL_TYPE_IPHTTPS = 15);

{ Datalink Interface Administrative State.
  Indicates whether the interface has been administratively enabled. }

  PIfAdministrativeState = ^TIfAdministrativeState;
  TIfAdministrativeState = (
    IF_ADMINISTRATIVE_DISABLED,
    IF_ADMINISTRATIVE_ENABLED,
    IF_ADMINISTRATIVE_DEMANDDIAL);

{ Note: Interface is Operational iff
  ((MediaSense is Connected) and (AdministrativeState is Enabled))
  or
  ((MediaSense is Connected) and (AdministrativeState is OnDemand))

  !Operational iff
  ((MediaSense != Connected) or (AdministrativeState is Disabled))


  OperStatus values from RFC 2863 }

  TIfOperStatus = (
    IfOperStatusUp = 1,
    IfOperStatusDown,
    IfOperStatusTesting,
    IfOperStatusUnknown,
    IfOperStatusDormant,
    IfOperStatusNotPresent,
    IfOperStatusLowerLayerDown);

  PNdisInterfaceInformation = ^TNdisInterfaceInformation;
  TNdisInterfaceInformation = record
    { rod fields }
    ifOperStatus: TNetIfOperStatus;
    ifOperStatusFlags: ULONG;
    MediaConnectState: TNetIfMediaConnectState;
    MediaDuplexState: TNetIfMediaDuplexState;
    ifMtu: ULONG;
    ifPromiscuousMode: Boolean;
    ifDeviceWakeUpEnable: Boolean;
    XmitLinkSpeed: UINT64;
    RcvLinkSpeed: UINT64;
    ifLastChange: UINT64;
    ifCounterDiscontinuityTime: UINT64;
    ifInUnknownProtos: UINT64;
    { OID_GEN_STATISTICS }
    ifInDiscards: UINT64;               { OID_GEN_RCV_DISCARDS = OID_GEN_RCV_ERROR + OID_GEN_RCV_NO_BUFFER }
    ifInErrors: UINT64;                 { OID_GEN_RCV_ERROR }
    ifHCInOctets: UINT64;               { OID_GEN_BYTES_RCV = OID_GEN_DIRECTED_BYTES_RCV + OID_GEN_MULTICAST_BYTES_RCV + OID_GEN_BROADCAST_BYTES_RCV }
    ifHCInUcastPkts: UINT64;            { OID_GEN_DIRECTED_FRAMES_RCV }
    ifHCInMulticastPkts: UINT64;        { OID_GEN_MULTICAST_FRAMES_RCV }
    ifHCInBroadcastPkts: UINT64;        { OID_GEN_BROADCAST_FRAMES_RCV }
    ifHCOutOctets: UINT64;              { OID_GEN_BYTES_XMIT = OID_GEN_DIRECTED_BYTES_XMIT + OID_GEN_MULTICAST_BYTES_XMIT + OID_GEN_BROADCAST_BYTES_XMIT }
    ifHCOutUcastPkts: UINT64;           { OID_GEN_DIRECTED_FRAMES_XMIT }
    ifHCOutMulticastPkts: UINT64;       { OID_GEN_MULTICAST_FRAMES_XMIT }
    ifHCOutBroadcastPkts: UINT64;       { OID_GEN_BROADCAST_FRAMES_XMIT }
    ifOutErrors: UINT64;                { OID_GEN_XMIT_ERROR }
    ifOutDiscards: UINT64;              { OID_GEN_XMIT_DISCARDS }
    ifHCInUcastOctets: UINT64;          { OID_GEN_DIRECTED_BYTES_RCV }
    ifHCInMulticastOctets: UINT64;      { OID_GEN_MULTICAST_BYTES_RCV }
    ifHCInBroadcastOctets: UINT64;      { OID_GEN_BROADCAST_BYTES_RCV }
    ifHCOutUcastOctets: UINT64;         { OID_GEN_DIRECTED_BYTES_XMIT }
    ifHCOutMulticastOctets: UINT64;     { OID_GEN_MULTICAST_BYTES_XMIT }
    ifHCOutBroadcastOctets: UINT64;     { OID_GEN_BROADCAST_BYTES_XMIT }
    CompartmentId: TNetIfCompartmentId;
    SupportedStatistics: ULONG;
  end;

const
 ANY_SIZE = 1;

type
  PMibIfNumber = ^TMibIfNumber;
  TMibIfNumber = record
    dwValue: DWORD;
  end;

{ $REVIEW: This has always been defined as 8.  However, this is not
  sufficient for all media types. }
  
const
  MAXLEN_PHYSADDR = 8;
  MAXLEN_IFDESCR = 256;
  MAX_INTERFACE_NAME_LEN = 256;

type
  PMibIfRow = ^TMibIfRow;
  TMibIfRow = record
    wszName: array[0..MAX_INTERFACE_NAME_LEN - 1] of WCHAR;
    dwIndex: TIfIndex;        { index of the interface }
    dwType: TIfType;          { type of interface }
    dwMtu: DWORD;             { max transmission unit }
    dwSpeed: DWORD;           { speed of the interface }
    dwPhysAddrLen: DWORD;     { length of physical address }
    bPhysAddr: array[0..MAXLEN_PHYSADDR - 1] of UCHAR; { physical addr of adapter }
    dwAdminStatus: DWORD;     { administrative status }
    dwOperStatus: TInternalIfOperStatus; { operational status }
    dwLastChange: DWORD;      { last time oper status changed }
    dwInOctets: DWORD;        { octets received }
    dwInUcastPkts: DWORD;     { unicast packets received }
    dwInNUcastPkts: DWORD;    { non-unicast packets received }
    dwInDiscards: DWORD;      { received packets discarded }
    dwInErrors: DWORD;        { erroneous packets received }
    dwInUnknownProtos: DWORD; { unknow protocol packets received }
    dwOutOctets: DWORD;       { octets sent }
    dwOutUcastPkts: DWORD;    { unicast packets sent }
    dwOutNUcastPkts: DWORD;   { non-unicast packets sent }
    dwOutDiscards: DWORD;     { outgoing packets discarded }
    dwOutErrors: DWORD;       { erroneous packets sent }
    dwOutQLen: DWORD;         { output queue length }
    dwDescrLen: DWORD;        { length of bDescr member }
    bDescr: array[0..MAXLEN_IFDESCR - 1] of UCHAR; { interface description }
  end;

  PMibIfTable = ^TMibIfTable;
  TMibIfTable = record
    dwNumEntries: DWORD; { number of entries in table }
    table: array[0..ANY_SIZE - 1] of TMibIfRow; { array of interface entries }
  end;

const
  NL_MAX_METRIC_COMPONENT = (ULONG(1) shl 31) - 1;

type
  TNlPrefixOrigin = (
    IpPrefixOriginOther = 0,
    IpPrefixOriginManual,
    IpPrefixOriginWellKnown,
    IpPrefixOriginDhcp,
    IpPrefixOriginRouterAdvertisement,
    IpPrefixOriginUnchanged = 1 shl 4);

const
  NlpoOther               = IpPrefixOriginOther;
  NlpoManual              = IpPrefixOriginManual;
  NlpoWellKnown           = IpPrefixOriginWellKnown;
  NlpoDhcp                = IpPrefixOriginDhcp;
  NlpoRouterAdvertisement = IpPrefixOriginRouterAdvertisement;

type  
  TNlSuffixOrigin = (
    NlsoOther = 0,
    NlsoManual,
    NlsoWellKnown,
    NlsoDhcp,
    NlsoLinkLayerAddress,
    NlsoRandom,
    IpSuffixOriginOther = 0,
    IpSuffixOriginManual,
    IpSuffixOriginWellKnown,
    IpSuffixOriginDhcp,
    IpSuffixOriginLinkLayerAddress,
    IpSuffixOriginRandom,
    IpSuffixOriginUnchanged = 1 shl 4);

  TNlDadState = (
    NldsInvalid,
    NldsTentative,
    NldsDuplicate,
    NldsDeprecated,
    NldsPreferred,
    IpDadStateInvalid = 0,
    IpDadStateTentative,
    IpDadStateDuplicate,
    IpDadStateDeprecated,
    IpDadStatePreferred);

{ Routing protocol values from RFC. }

  PNlRouteProtocol = ^TNlRouteProtocol;
  TNlRouteProtocol = (
    RouteProtocolOther = 1,
    RouteProtocolLocal,
    RouteProtocolNetMgmt,
    RouteProtocolIcmp,
    RouteProtocolEgp,
    RouteProtocolGgp,
    RouteProtocolHello,
    RouteProtocolRip,
    RouteProtocolIsIs,
    RouteProtocolEsIs,
    RouteProtocolCisco,
    RouteProtocolBbn,
    RouteProtocolOspf,
    RouteProtocolBgp,
    MIB_IPPROTO_OTHER = 1,
    MIB_IPPROTO_LOCAL = 2,
    MIB_IPPROTO_NETMGMT = 3,
    MIB_IPPROTO_ICMP = 4,
    MIB_IPPROTO_EGP = 5,
    MIB_IPPROTO_GGP = 6,
    MIB_IPPROTO_HELLO = 7,
    MIB_IPPROTO_RIP = 8,
    MIB_IPPROTO_IS_IS = 9,
    MIB_IPPROTO_ES_IS = 10,
    MIB_IPPROTO_CISCO = 11,
    MIB_IPPROTO_BBN = 12,
    MIB_IPPROTO_OSPF = 13,
    MIB_IPPROTO_BGP = 14,
    MIB_IPPROTO_NT_AUTOSTATIC = 10002,
    MIB_IPPROTO_NT_STATIC = 10006,
    MIB_IPPROTO_NT_STATIC_NON_DOD = 10007);

  PNlAddressType = ^TNlAddressType;
  TNlAddressType = (
    NlatUnspecified,
    NlatUnicast,
    NlatAnycast,
    NlatMulticast,
    NlatBroadcast,
    NlatInvalid);

{ Define route origin values. }

  PNlRouteOrigin = ^TNlRouteOrigin;
  TNlRouteOrigin = (
    NlroManual,
    NlroWellKnown,
    NlroDHCP,
    NlroRouterAdvertisement,
    Nlro6to4);

{ Define network layer neighbor state.  RFC 2461, section 7.3.2 has details.
  Note: Only state names are documented, we chose the values used here. }

  PNlNeighborState = ^TNlNeighborState;
  TNlNeighborState = (
    NlnsUnreachable,
    NlnsIncomplete,
    NlnsProbe,
    NlnsDelay,
    NlnsStale,
    NlnsReachable,
    NlnsPermanent,
    NlnsMaximum);

  TNlLinkLocalAddressBehavior = (
    LinkLocalAlwaysOff = 0,     { Never use link locals. }
    LinkLocalDelayed,           { Use link locals only if no other addresses.
                                  (default for IPv4).
                                  Legacy mapping: IPAutoconfigurationEnabled. }
    LinkLocalAlwaysOn,          { Always use link locals (default for IPv6). }
    LinkLocalUnchanged = -1);

  TNlInterfaceOffloadRodFlags = (
    NlChecksumSupported,
    NlOptionsSupported,
    TlDatagramChecksumSupported,
    TlStreamChecksumSupported,
    TlStreamOptionsSupported,
    FastPathCompatible,
    TlLargeSendOffloadSupported,
    TlGiantSendOffloadSupported);

  PNlInterfaceOffloadRod = ^TNlInterfaceOffloadRod;
  TNlInterfaceOffloadRod = set of TNlInterfaceOffloadRodFlags;

  TNlRouterDiscoveryBehavior = (
    RouterDiscoveryDisabled = 0,
    RouterDiscoveryEnabled,
    RouterDiscoveryDhcp,
    RouterDiscoveryUnchanged = -1);

  PNlBandwidthFlag = ^TNlBandwidthFlag;
  TNlBandwidthFlag = (
    NlbwDisabled = 0,
    NlbwEnabled,
    NlbwUnchanged = -1);

  PNlPathBandwidthRod = ^TNlPathBandwidthRod;
  TNlPathBandwidthRod = record
    Bandwidth: UINT64;
    Instability: UINT64;
    BandwidthPeaked: Boolean;
  end;

  PNlNetworkCategory = ^TNlNetworkCategory;
  TNlNetworkCategory = (
    NetworkCategoryPublic,
    NetworkCategoryPrivate,
    NetworkCategoryDomainAuthenticated,
    NetworkCategoryUnchanged = -1, { used in a set operation }
    NetworkCategoryUnknown = -1);  { returned in a query operation }

const
  NET_IF_CURRENT_SESSION = ULONG(-1);

  MIB_IPADDR_PRIMARY      = $0001; { Primary ipaddr }
  MIB_IPADDR_DYNAMIC      = $0004; { Dynamic ipaddr }
  MIB_IPADDR_DISCONNECTED = $0008; { Address is on disconnected interface }
  MIB_IPADDR_DELETED      = $0040; { Address being deleted }
  MIB_IPADDR_TRANSIENT    = $0080; { Transient address }
  MIB_IPADDR_DNS_ELIGIBLE = $0100; { Address is published in DNS. }

type
  PMibIpAddrRow = ^TMibIpAddrRow;
  TMibIpAddrRow = record
    dwAddr: DWORD;      { IP address }
    dwIndex: TIfIndex;  { interface index }
    dwMask: DWORD;      { subnet mask }
    dwBCastAddr: DWORD; { broadcast address }
    dwReasmSize: DWORD; { rassembly size }
    unused1: Word;      { not currently used }
    unused2: Word;      { not currently used }
  end;

  PMibIpAddrTable = ^TMibIpAddrTable;
  TMibIpAddrTable = record
    dwNumEntries: DWORD; { number of entries in the table }
    table: array[0..ANY_SIZE - 1] of TMibIpAddrRow; { array of IP address entries }
  end;  

  PMibIpForwardNumber = ^TMibIpForwardNumber;
  TMibIpForwardNumber = record
    dwValue: DWORD;
  end;

  TMibIpForwardProto = TNlRouteProtocol;

  TMibIpForwardType = (
    MIB_IPROUTE_TYPE_OTHER    = 1,
    MIB_IPROUTE_TYPE_INVALID  = 2,
    MIB_IPROUTE_TYPE_DIRECT   = 3,
    MIB_IPROUTE_TYPE_INDIRECT = 4);

  PMibIpForwardRow = ^TMibIpForwardRow;
  TMibIpForwardRow = record
    dwForwardDest: DWORD;                         { IP addr of destination }
    dwForwardMask: DWORD;                         { subnetwork mask of destination }
    dwForwardPolicy: DWORD;                       { conditions for multi-path route }
    dwForwardNextHop: DWORD;                      { IP address of next hop }
    dwForwardIfIndex: TIfIndex;                   { index of interface }
    case Integer of
      0: (dwForwardType: DWORD);
      1: (ForwardType: TMibIpForwardType;         { route type }
          case Integer of
            0: (dwForwardProto: DWORD);
            1: (ForwardProto: TMibIpForwardProto; { protocol that generated route }
                dwForwardAge: DWORD;              { age of route }
                dwForwardNextHopAS: DWORD;        { autonomous system number of next hop }
                dwForwardMetric1: DWORD;          { protocol-specific metric }
                dwForwardMetric2: DWORD;          { protocol-specific metric }
                dwForwardMetric3: DWORD;          { protocol-specific metric }
                dwForwardMetric4: DWORD;          { protocol-specific metric }
                dwForwardMetric5: DWORD););       { protocol-specific metric }
  end;

const
  MIB_IPROUTE_METRIC_UNUSED = DWORD(-1);

type
  PMibIpForwardTable = ^TMibIpForwardTable;
  TMibIpForwardTable = record
    dwNumEntries: DWORD; { number of entries in the table }
    table: array[0..ANY_SIZE - 1] of TMibIpForwardRow; { array of route entries }
  end;

  TMibIpNetType = (
    MIB_IPNET_TYPE_OTHER   = 1,
    MIB_IPNET_TYPE_INVALID = 2,
    MIB_IPNET_TYPE_DYNAMIC = 3,
    MIB_IPNET_TYPE_STATIC  = 4);

  PMibIpNetRow = ^TMibIpNetRow;
  TMibIpNetRow = record
    dwIndex: TIfIndex;    { adapeter index }
    dwPhysAddrLen: DWORD; { physical address length }
    bPhysAddr: array[0..MAXLEN_PHYSADDR - 1] of UCHAR; { physical address }
    dwAddr: DWORD;        { IP address }
    case Integer of
      0: (dwType: DWORD); { ARP entry type }
      1: (NetType: TMibIpNetType);
  end;

  PMibIpNetTable = ^TMibIpNetTable;
  TMibIpNetTable = record
    dwNumEntries: DWORD; { number of entries in table }
    table: array[0..ANY_SIZE - 1] of TMibIpNetRow; { array of ARP entries }
  end;

  TMibIpStatsForwarding = (
    MIB_IP_FORWARDING     = 1,
    MIB_IP_NOT_FORWARDING = 2);

const
  MIB_USE_CURRENT_TTL        = DWORD(-1);
  MIB_USE_CURRENT_FORWARDING = DWORD(-1);

type
  PMibIpStats = ^TMibIpStats;
  TMibIpStats = record
    case Integer of
      0: (dwForwarding: DWORD);
      1: (Forwarding: TMibIpStatsForwarding; { IP forwarding enabled or disabled }
          dwDefaultTTL: DWORD;      { default time-to-live }
          dwInReceives: DWORD;      { datagrams received }
          dwInHdrErrors: DWORD;     { received header errors }
          dwInAddrErrors: DWORD;    { received address errors }
          dwForwDatagrams: DWORD;   { datagrams forwarded }
          dwInUnknownProtos: DWORD; { datagrams with unknown protocol }
          dwInDiscards: DWORD;      { received datagrams discarded }
          dwInDelivers: DWORD;      { received datagrams delivered }
          dwOutRequests: DWORD;
          dwRoutingDiscards: DWORD;
          dwOutDiscards: DWORD;     { sent datagrams discarded }
          dwOutNoRoutes: DWORD;     { datagrams for which no route }
          dwReasmTimeout: DWORD;    { datagrams for which all frags didn't arrive }
          dwReasmReqds: DWORD;      { datagrams requiring reassembly }
          dwReasmOks: DWORD;        { successful reassemblies }
          dwReasmFails: DWORD;      { failed reassemblies }
          dwFragOks: DWORD;         { successful fragmentations }
          dwFragFails: DWORD;       { failed fragmentations }
          dwFragCreates: DWORD;     { datagrams fragmented }
          dwNumIf: DWORD;           { number of interfaces on computer }
          dwNumAddr: DWORD;         { number of IP address on computer }
          dwNumRoutes: DWORD);      { number of routes in routing table }
  end;

  PMibIcmpStats = ^TMibIcmpStats;
  TMibIcmpStats = record
    dwMsgs: DWORD;          { number of messages }
    dwErrors: DWORD;        { number of errors }
    dwDestUnreachs: DWORD;  { destination unreachable messages }
    dwTimeExcds: DWORD;     { time-to-live exceeded messages }
    dwParmProbs: DWORD;     { parameter problem messages }
    dwSrcQuenchs: DWORD;    { source quench messages }
    dwRedirects: DWORD;     { redirection messages }
    dwEchos: DWORD;         { echo requests }
    dwEchoReps: DWORD;      { echo replies }
    dwTimestamps: DWORD;    { timestamp requests }
    dwTimestampReps: DWORD; { timestamp replies }
    dwAddrMasks: DWORD;     { address mask requests }
    dwAddrMaskReps: DWORD;  { address mask replies }
  end;

  PMibIcmpInfo = ^TMibIcmpInfo;
  TMibIcmpInfo = record
    icmpInStats: TMibIcmpStats;  { stats for incoming messages }
    icmpOutStats: TMibIcmpStats; { stats for outgoing messages }
  end;

  PMibIcmp = ^TMibIcmp;
  TMibIcmp = record
    stats: TMibIcmpInfo; { contains ICMP stats }
  end;

  PMibIcmpStatsEx = ^TMibIcmpStatsEx;
  TMibIcmpStatsEx = record
    dwMsgs: DWORD;
    dwErrors: DWORD;
    rgdwTypeCount: array[0..255] of DWORD;
  end;

  PMibIcmpEx = ^TMibIcmpEx;
  TMibIcmpEx = record
    icmpInStats: TMibIcmpStatsEx;
    icmpOutStats: TMibIcmpStatsEx;
  end;

{ ICMP6_TYPE

  ICMPv6 Type Values from RFC 2292, 2461 (ND), and 3810 (MLDv2) }

  PIcmp6Type = ^TIcmp6Type;
  TIcmp6Type = (
    ICMP6_DST_UNREACH          =   1,
    ICMP6_PACKET_TOO_BIG       =   2,
    ICMP6_TIME_EXCEEDED        =   3,
    ICMP6_PARAM_PROB           =   4,
    ICMP6_ECHO_REQUEST         = 128,
    ICMP6_ECHO_REPLY           = 129,
    ICMP6_MEMBERSHIP_QUERY     = 130,
    ICMP6_MEMBERSHIP_REPORT    = 131,
    ICMP6_MEMBERSHIP_REDUCTION = 132,
    ND_ROUTER_SOLICIT          = 133,
    ND_ROUTER_ADVERT           = 134,
    ND_NEIGHBOR_SOLICIT        = 135,
    ND_NEIGHBOR_ADVERT         = 136,
    ND_REDIRECT                = 137,
    ICMP6_V2_MEMBERSHIP_REPORT = 143);

{ Used to identify informational/error messages. }

const
  ICMP6_INFOMSG_MASK = $80;

type

{ ICMP4_TYPE

  There are no RFC-specified defines for ICMPv4 message types, so we try to
  use the ICMP6 values from RFC 2292 modified to be prefixed with ICMP4. }

  PIcmp4Type = ^TIcmp4Type;
  TIcmp4Type = (
    ICMP4_ECHO_REPLY        =  0,  { Echo Reply. }
    ICMP4_DST_UNREACH       =  3,  { Destination Unreachable. }
    ICMP4_SOURCE_QUENCH     =  4,  { Source Quench. }
    ICMP4_REDIRECT          =  5,  { Redirect. }
    ICMP4_ECHO_REQUEST      =  8,  { Echo Request. }
    ICMP4_ROUTER_ADVERT     =  9,  { Router Advertisement. }
    ICMP4_ROUTER_SOLICIT    = 10,  { Router Solicitation. }
    ICMP4_TIME_EXCEEDED     = 11,  { Time Exceeded. }
    ICMP4_PARAM_PROB        = 12,  { Parameter Problem. }
    ICMP4_TIMESTAMP_REQUEST = 13,  { Timestamp Request. }
    ICMP4_TIMESTAMP_REPLY   = 14,  { Timestamp Reply. }
    ICMP4_MASK_REQUEST      = 17,  { Address Mask Request. }
    ICMP4_MASK_REPLY        = 18); { Address Mask Reply. }

  PMibIpMcastOif = ^TMibIpMcastOif;
  TMibIpMcastOif = record
    dwOutIfIndex: DWORD;
    dwNextHopAddr: DWORD;
    dwReserved: DWORD;
    dwReserved1: DWORD;
  end;

  PMibIpMcastMfe = ^TMibIpMcastMfe;
  TMibIpMcastMfe = record
    dwGroup: DWORD;
    dwSource: DWORD;
    dwSrcMask: DWORD;
    dwUpStrmNgbr: DWORD;
    dwInIfIndex: DWORD;
    dwInIfProtocol: DWORD;
    dwRouteProtocol: DWORD;
    dwRouteNetwork: DWORD;
    dwRouteMask: DWORD;
    ulUpTime: ULONG;
    ulExpiryTime: ULONG;
    ulTimeOut: ULONG;
    ulNumOutIf: ULONG;
    fFlags: DWORD;
    dwReserved: DWORD;
    rgmioOutInfo: array[0..ANY_SIZE - 1] of TMibIpMcastOif;
  end;

  PMibMfeTable = ^TMibMfeTable;
  TMibMfeTable = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibIpMcastMfe;
  end;

  PMibIpMcastOifStats = ^TMibIpMcastOifStats;
  TMibIpMcastOifStats = record
    dwOutIfIndex: DWORD;
    dwNextHopAddr: DWORD;
    dwDialContext: DWORD;
    ulTtlTooLow: ULONG;
    ulFragNeeded: ULONG;
    ulOutPackets: ULONG;
    ulOutDiscards: ULONG;
  end;

  PMibIpMcastMfeStats = ^TMibIpMcastMfeStats;
  TMibIpMcastMfeStats = record
    dwGroup: DWORD;
    dwSource: DWORD;
    dwSrcMask: DWORD;
    dwUpStrmNgbr: DWORD;
    dwInIfIndex: DWORD;
    dwInIfProtocol: DWORD;
    dwRouteProtocol: DWORD;
    dwRouteNetwork: DWORD;
    dwRouteMask: DWORD;
    ulUpTime: ULONG;
    ulExpiryTime: ULONG;
    ulNumOutIf: ULONG;
    ulInPkts: ULONG;
    ulInOctets: ULONG;
    ulPktsDifferentIf: ULONG;
    ulQueueOverflow: ULONG;
    rgmiosOutStats: array [0..ANY_SIZE - 1] of TMibIpMcastOifStats;
  end;

  PMibMfeStatsTable = ^TMibMfeStatsTable;
  TMibMfeStatsTable = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibIpMcastMfeStats;
  end;

  PMibIpMcastMfeStatsEx = ^TMibIpMcastMfeStatsEx;
  TMibIpMcastMfeStatsEx = record
    dwGroup: DWORD;
    dwSource: DWORD;
    dwSrcMask: DWORD;
    dwUpStrmNgbr: DWORD;
    dwInIfIndex: DWORD;
    dwInIfProtocol: DWORD;
    dwRouteProtocol: DWORD;
    dwRouteNetwork: DWORD;
    dwRouteMask: DWORD;
    ulUpTime: ULONG;
    ulExpiryTime: ULONG;
    ulNumOutIf: ULONG;
    ulInPkts: ULONG;
    ulInOctets: ULONG;
    ulPktsDifferentIf: ULONG;
    ulQueueOverflow: ULONG;
    ulUninitMfe: ULONG;
    ulNegativeMfe: ULONG;
    ulInDiscards: ULONG;
    ulInHdrErrors: ULONG;
    ulTotalOutPackets: ULONG;
    rgmiosOutStats: array[0..ANY_SIZE - 1] of TMibIpMcastOifStats;
  end;

  PMibMfeStatsTableEx = ^TMibMfeStatsTableEx;
  TMibMfeStatsTableEx = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibIpMcastMfeStatsEx;
  end;

  PMibIpMcastGlobal = ^TMibIpMcastGlobal;
  TMibIpMcastGlobal = record
    dwEnable: DWORD;
  end;

  PMibIpMcastIfEntry = ^TMibIpMcastIfEntry;
  TMibIpMcastIfEntry = record
    dwIfIndex: DWORD;
    dwTtl: DWORD;
    dwProtocol: DWORD;
    dwRateLimit: DWORD;
    ulInMcastOctets: ULONG;
    ulOutMcastOctets: ULONG;
  end;

  PMibIpMcastIfTable = ^TMibIpMcastIfTable;
  TMibIpMcastIfTable = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibIpMcastIfEntry;
  end;

{ Definitions and structures used by getnetworkparams and getadaptersinfo apis }

const
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_NAME_LENGTH        = 256;
  MAX_ADAPTER_ADDRESS_LENGTH     = 8;
  DEFAULT_MINIMUM_ENTITIES       = 32;
  MAX_HOSTNAME_LEN               = 128;
  MAX_DOMAIN_NAME_LEN            = 128;
  MAX_SCOPE_ID_LEN               = 256;
  MAX_DHCPV6_DUID_LENGTH         = 130; { RFC 3315. }
  MAX_DNS_SUFFIX_STRING_LENGTH   = 256;

{ Node Type }

  BROADCAST_NODETYPE    = 1;
  PEER_TO_PEER_NODETYPE = 2;
  MIXED_NODETYPE        = 4;
  HYBRID_NODETYPE       = 8;

type

{ IP_ADDRESS_STRING - store an IP address as a dotted decimal string }

  PIpAddressString = ^TIpAddressString;
  TIpAddressString = record
    Str: array[0..15] of AnsiChar;
  end;

  PIpMaskString = ^TIpMaskString;
  TIpMaskString = TIpAddressString;
  
  PIpAddrString = ^TIpAddrString;
  TIpAddrString = record
    Next: PIpAddrString;
    IpAddress: TIpAddressString;
    IpMask: TIpMaskString;
    Context: DWORD;
  end;

{ ADAPTER_INFO - per-adapter information. All IP addresses are stored as }

  PIpAdapterInfo = ^TIpAdapterInfo;
  TIpAdapterInfo = record
    Next: PIpAdapterInfo;
    ComboIndex: DWORD;
    AdapterName: array[0..MAX_ADAPTER_NAME_LENGTH + 3] of AnsiChar;
    Description: array[0..MAX_ADAPTER_DESCRIPTION_LENGTH + 3] of AnsiChar;
    AddressLength: UINT;
    Address: array[0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of Byte;
    Index: DWORD;
    uType: UINT;
    DhcpEnabled: UINT;
    CurrentIpAddress: PIpAddrString;
    IpAddressList: TIpAddrString;
    GatewayList: TIpAddrString;
    DhcpServer: TIpAddrString;
    HaveWins: BOOL;
    PrimaryWinsServer: TIpAddrString;
    SecondaryWinsServer: TIpAddrString;
    LeaseObtained: Longint;
    LeaseExpires: Longint;
  end;

  TIpPrefixOrigin = TNlPrefixOrigin;
  TIpSuffixOrigin = TNlSuffixOrigin;
  TIpDadState = TNlDadState;

  PIpAdapterUnicastAddressXp = ^TIpAdapterUnicastAddressXp;
  TIpAdapterUnicastAddressXp = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          Flags: DWORD;
          Next: PIpAdapterUnicastAddressXp;
          Address: TSocketAddress;
          PrefixOrigin: TIpPrefixOrigin;
          SuffixOrigin: TIpSuffixOrigin;
          DadState: TIpDadState;
          ValidLifetime: ULONG;
          PreferredLifetime: ULONG;
          LeaseLifetime: ULONG);
  end;

  PIpAdapterUnicastAddressLh = ^TIpAdapterUnicastAddressLh;
  TIpAdapterUnicastAddressLh = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          Flags: DWORD;
          Next: PIpAdapterUnicastAddressLh;
          Address: TSocketAddress;
          PrefixOrigin: TIpPrefixOrigin;
          SuffixOrigin: TIpSuffixOrigin;
          DadState: TIpDadState;
          ValidLifetime: ULONG;
          PreferredLifetime: ULONG;
          LeaseLifetime: ULONG;
          OnLinkPrefixLength: Byte);
  end;

  PIpAdapterAnycastAddress = ^TIpAdapterAnycastAddress;
  TIpAdapterAnycastAddress = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          Flags: DWORD;
          Next: PIpAdapterAnycastAddress;
          Address: TSocketAddress);
  end;

  PIpAdapterMulticastAddress = ^TIpAdapterMulticastAddress;
  TIpAdapterMulticastAddress = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          Flags: DWORD;
          Next: PIpAdapterMulticastAddress;
          Address: TSocketAddress);
  end;

  PIpAdapterDnsServerAddress = ^TIpAdapterDnsServerAddress;
  TIpAdapterDnsServerAddress = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          Reserved: DWORD;
          Next: PIpAdapterDnsServerAddress;
          Address: TSocketAddress);
  end;

  PIpAdapterWinsServerAddress = ^TIpAdapterWinsServerAddress;
  TIpAdapterWinsServerAddress = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          Reserved: DWORD;
          Next: PIpAdapterWinsServerAddress;
          Address: TSocketAddress);
  end;

  PIpAdapterGatewayAddress = ^TIpAdapterGatewayAddress;
  TIpAdapterGatewayAddress = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          Reserved: DWORD;
          Next: PIpAdapterGatewayAddress;
          Address: TSocketAddress);
  end;

  PIpAdapterPrefix = ^TIpAdapterPrefix;
  TIpAdapterPrefix = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          Flags: DWORD;
          Next: PIpAdapterPrefix;
          Address: TSocketAddress;
          PrefixLength: ULONG);
  end;

  PIpAdapterDnsSuffix = ^TIpAdapterDnsSuffix;
  TIpAdapterDnsSuffix = record
    Next: PIpAdapterDnsSuffix;
    Str: array[0..MAX_DNS_SUFFIX_STRING_LENGTH - 1] of WCHAR;
  end;

const

{ Bit values of IP_ADAPTER_ADDRESSES Flags field. }

  IP_ADAPTER_DDNS_ENABLED               = $00000001;
  IP_ADAPTER_REGISTER_ADAPTER_SUFFIX    = $00000002;
  IP_ADAPTER_DHCP_ENABLED               = $00000004;
  IP_ADAPTER_RECEIVE_ONLY               = $00000008;
  IP_ADAPTER_NO_MULTICAST               = $00000010;
  IP_ADAPTER_IPV6_OTHER_STATEFUL_CONFIG = $00000020;
  IP_ADAPTER_NETBIOS_OVER_TCPIP_ENABLED = $00000040;
  IP_ADAPTER_IPV4_ENABLED               = $00000080;
  IP_ADAPTER_IPV6_ENABLED               = $00000100;
  IP_ADAPTER_IPV6_MANAGE_ADDRESS_CONFIG = $00000200;

type
  PIpAdapterAddresses = Pointer;
  
  PIpAdapterAddressesXp = ^TIpAdapterAddressesXp;
  TIpAdapterAddressesXp = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          IfIndex: TIfIndex;
          Next: PIpAdapterAddressesXp;
          AdapterName: PAnsiChar;
          FirstUnicastAddress: PIpAdapterUnicastAddressXp;
          FirstAnycastAddress: PIpAdapterAnycastAddress;
          FirstMulticastAddress: PIpAdapterMulticastAddress;
          FirstDnsServerAddress: PIpAdapterDnsServerAddress;
          DnsSuffix: PWCHAR;
          Description: PWCHAR;
          FriendlyName: PWCHAR;
          PhysicalAddress: array[0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of Byte;
          PhysicalAddressLength: DWORD;
          Flags: DWORD;
          Mtu: DWORD;
          IfType: DWORD;
          OperStatus: TIfOperStatus;
          Ipv6IfIndex: DWORD;
          ZoneIndices: array[0..15] of DWORD;
          FirstPrefix: PIpAdapterPrefix);
  end;

  PIpAdapterAddressesLh = ^TIpAdapterAddressesLh;
  TIpAdapterAddressesLh = record
    case Integer of
      0: (Alignment: UINT64);
      1: (Length: ULONG;
          IfIndex: TIfIndex;
          Next: PIpAdapterAddressesLh;
          AdapterName: PAnsiChar;
          FirstUnicastAddress: PIpAdapterUnicastAddressLh;
          FirstAnycastAddress: PIpAdapterAnycastAddress;
          FirstMulticastAddress: PIpAdapterMulticastAddress;
          FirstDnsServerAddress: PIpAdapterDnsServerAddress;
          DnsSuffix: PWCHAR;
          Description: PWCHAR;
          FriendlyName: PWCHAR;
          PhysicalAddress: array[0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of Byte;
          PhysicalAddressLength: ULONG;
          Flags: ULONG;
          Mtu: ULONG;
          IfType: TIfType;
          OperStatus: TIfOperStatus;
          Ipv6IfIndex: TIfIndex;
          ZoneIndices: array[0..15] of ULONG;
          FirstPrefix: PIpAdapterPrefix;
          TransmitLinkSpeed: UINT64;
          ReceiveLinkSpeed: UINT64;
          FirstWinsServerAddress: PIpAdapterWinsServerAddress;
          FirstGatewayAddress: PIpAdapterGatewayAddress;
          Ipv4Metric: ULONG;
          Ipv6Metric: ULONG;
          Luid: TIfLuid;
          Dhcpv4Server: TSocketAddress;
          CompartmentId: TNetIfCompartmentId;
          NetworkGuid: TNetIfNetworkGuid;
          ConnectionType: TNetIfConnectionType;
          TunnelType: TTunnelType;
          Dhcpv6Server: TSocketAddress;
          Dhcpv6ClientDuid: array[0.. MAX_DHCPV6_DUID_LENGTH - 1] of Byte;
          Dhcpv6ClientDuidLength: ULONG;
          Dhcpv6Iaid: ULONG;
          FirstDnsSuffix: PIpAdapterDnsSuffix);
  end;

const

{ Flags used as argument to GetAdaptersAddresses().
  "SKIP" flags are added when the default is to include the information.
  "INCLUDE" flags are added when the default is to skip the information. }

  GAA_FLAG_SKIP_UNICAST                = $0001;
  GAA_FLAG_SKIP_ANYCAST                = $0002;
  GAA_FLAG_SKIP_MULTICAST              = $0004;
  GAA_FLAG_SKIP_DNS_SERVER             = $0008;
  GAA_FLAG_INCLUDE_PREFIX              = $0010;
  GAA_FLAG_SKIP_FRIENDLY_NAME          = $0020;
  GAA_FLAG_INCLUDE_WINS_INFO           = $0040;
  GAA_FLAG_INCLUDE_GATEWAYS            = $0080;
  GAA_FLAG_INCLUDE_ALL_INTERFACES      = $0100;
  GAA_FLAG_INCLUDE_ALL_COMPARTMENTS    = $0200;
  GAA_FLAG_INCLUDE_TUNNEL_BINDINGORDER = $0400;

type

{ IP_PER_ADAPTER_INFO - per-adapter IP information such as DNS server list. }
  
  PIpPerAdapterInfo = ^TIpPerAdapterInfo;
  TIpPerAdapterInfo = record
    AutoconfigEnabled: UINT;
    AutoconfigActive: UINT;
    CurrentDnsServer: PIpAddrString;
    DnsServerList: TIpAddrString;
  end;

{ FIXED_INFO - the set of IP-related information which does not depend on DHCP }

  PFixedInfo = ^TFixedInfo;
  TFixedInfo = record
    HostName: array[0..MAX_HOSTNAME_LEN + 3] of AnsiChar;
    DomainName: array[0..MAX_DOMAIN_NAME_LEN + 3] of AnsiChar;
    CurrentDnsServer: PIpAddrString;
    DnsServerList: TIpAddrString;
    NodeType: UINT;
    ScopeId: array[0..MAX_SCOPE_ID_LEN + 3] of AnsiChar;
    EnableRouting: UINT;
    EnableProxy: UINT;
    EnableDns: UINT;
  end;

  PIpInterfaceNameInfo = ^TIpInterfaceNameInfo;
  TIpInterfaceNameInfo = record
    Index: ULONG;          { Interface Index }
    MediaType: ULONG;      { Interface Types }
    ConnectionType: UCHAR;
    AccessType: UCHAR;
    DeviceGuid: TGUID;     { Device GUID is the guid of the device
                             that IP exposes }
    InterfaceGuid: TGUID;  { Interface GUID, if not GUID_NULL is the
                             GUID for the interface mapped to the device. }
  end;

{ IP type definitions. }

  TIpAddr   = ULONG; { An IP address. }
  TIpMask   = ULONG; { An IP subnet mask. }
  TIpStatus = ULONG; { Status code returned from IP APIs. }

{ The ip_option_information structure describes the options to be
  included in the header of an IP packet. The TTL, TOS, and Flags
  values are carried in specific fields in the header. The OptionsData
  bytes are carried in the options area following the standard IP header.
  With the exception of source route options, this data must be in the
  format to be transmitted on the wire as specified in RFC 791. A source
  route option should contain the full route - first hop thru final
  destination - in the route data. The first hop will be pulled out of the
  data and the option will be reformatted accordingly. Otherwise, the route
  option should be formatted as specified in RFC 791. }

  PIpOptionInformation = ^TIpOptionInformation;
  TIpOptionInformation = record
    Ttl: UCHAR;          { Time To Live }
    Tos: UCHAR;          { Type Of Service }
    Flags: UCHAR;        { IP header flags }
    OptionsSize: UCHAR;  { Size in bytes of options data }
    OptionsData: PUCHAR; { Pointer to options data }
  end;

{ The icmp_echo_reply structure describes the data returned in response
  to an echo request. }

  PIcmpEchoReply = ^TIcmpEchoReply;
  TIcmpEchoReply = record
    Address: TIpAddr;              { Replying address }
    Status: ULONG;                 { Reply IP_STATUS }
    RoundTripTime: ULONG;          { RTT in milliseconds }
    DataSize: Word;                { Reply data size in bytes }
    Reserved: Word;                { Reserved for system use }
    Data: Pointer;                 { Pointer to the reply data }
    Options: TIpOptionInformation; { Reply options }
  end;

  PIpv6AddressEx = ^TIpv6AddressEx;
  TIpv6AddressEx = packed record
    sin6_port: Word;
    sin6_flowinfo: ULONG;
    sin6_addr: array[0..7] of Word;
    sin6_scope_id: ULONG;
  end;

  PIcmpv6EchoReply = ^TIcmpv6EchoReply;
  TIcmpv6EchoReply = record
    Address: TIpv6AddressEx; { Replying address. }
    Status: ULONG;           { Reply IP_STATUS. }
    RoundTripTime: UINT;     { RTT in milliseconds. }
    { Reply data follows this structure in memory. }
  end;

  PArpSendReply = ^TArpSendReply;
  TArpSendReply = record
    DestAddress: TIpAddr;
    SrcAddress: TIpAddr;
  end;

  PTcpReservePortRange = ^TTcpReservePortRange;
  TTcpReservePortRange = record
    UpperRange: Word;
    LowerRange: Word;
  end;

const
  MAX_ADAPTER_NAME = 128;

type
  PIpAdapterIndexMap = ^TIpAdapterIndexMap;
  TIpAdapterIndexMap = record
    Index: ULONG;
    Name: array[0..MAX_ADAPTER_NAME - 1] of WCHAR;
  end;

  PIpInterfaceInfo = ^TIpInterfaceInfo;
  TIpInterfaceInfo = record
    NumAdapters: Longint;
    Adapter: array[0..ANY_SIZE - 1] of TIpAdapterIndexMap;
  end;

  PIpUnidirectionalAdapterAddress = ^TIpUnidirectionalAdapterAddress;
  TIpUnidirectionalAdapterAddress = record
    NumAdapters: ULONG;
    Address: array[0..ANY_SIZE - 1] of TIpAddr;
  end;

  PIpAdapterOrderMap = ^TIpAdapterOrderMap;
  TIpAdapterOrderMap = record
    NumAdapters: ULONG;
    AdapterOrder: array[0..ANY_SIZE - 1] of ULONG;
  end;

  PIpMcastCounterInfo = ^TIpMcastCounterInfo;
  TIpMcastCounterInfo = record
    InMcastOctets: UINT64;
    OutMcastOctets: UINT64;
    InMcastPkts: UINT64;
    OutMcastPkts: UINT64;
  end;

const

{ IP_STATUS codes returned from IP APIs }

  IP_STATUS_BASE              = 11000;

  IP_SUCCESS                  = 0;
  IP_BUF_TOO_SMALL            = IP_STATUS_BASE + 1;
  IP_DEST_NET_UNREACHABLE     = IP_STATUS_BASE + 2;
  IP_DEST_HOST_UNREACHABLE    = IP_STATUS_BASE + 3;
  IP_DEST_PROT_UNREACHABLE    = IP_STATUS_BASE + 4;
  IP_DEST_PORT_UNREACHABLE    = IP_STATUS_BASE + 5;
  IP_NO_RESOURCES             = IP_STATUS_BASE + 6;
  IP_BAD_OPTION               = IP_STATUS_BASE + 7;
  IP_HW_ERROR                 = IP_STATUS_BASE + 8;
  IP_PACKET_TOO_BIG           = IP_STATUS_BASE + 9;
  IP_REQ_TIMED_OUT            = IP_STATUS_BASE + 10;
  IP_BAD_REQ                  = IP_STATUS_BASE + 11;
  IP_BAD_ROUTE                = IP_STATUS_BASE + 12;
  IP_TTL_EXPIRED_TRANSIT      = IP_STATUS_BASE + 13;
  IP_TTL_EXPIRED_REASSEM      = IP_STATUS_BASE + 14;
  IP_PARAM_PROBLEM            = IP_STATUS_BASE + 15;
  IP_SOURCE_QUENCH            = IP_STATUS_BASE + 16;
  IP_OPTION_TOO_BIG           = IP_STATUS_BASE + 17;
  IP_BAD_DESTINATION          = IP_STATUS_BASE + 18;

{ Variants of the above using IPv6 terminology, where different }

  IP_DEST_NO_ROUTE            = IP_STATUS_BASE + 2;
  IP_DEST_ADDR_UNREACHABLE    = IP_STATUS_BASE + 3;
  IP_DEST_PROHIBITED          = IP_STATUS_BASE + 4;
  IP_HOP_LIMIT_EXCEEDED       = IP_STATUS_BASE + 13;
  IP_REASSEMBLY_TIME_EXCEEDED = IP_STATUS_BASE + 14;
  IP_PARAMETER_PROBLEM        = IP_STATUS_BASE + 15;

{ IPv6-only status codes }

  IP_DEST_UNREACHABLE         = IP_STATUS_BASE + 40;
  IP_TIME_EXCEEDED            = IP_STATUS_BASE + 41;
  IP_BAD_HEADER               = IP_STATUS_BASE + 42;
  IP_UNRECOGNIZED_NEXT_HEADER = IP_STATUS_BASE + 43;
  IP_ICMP_ERROR               = IP_STATUS_BASE + 44;
  IP_DEST_SCOPE_MISMATCH      = IP_STATUS_BASE + 45;

{ The next group are status codes passed up on status indications to
  transport layer protocols. }

  IP_ADDR_DELETED             = IP_STATUS_BASE + 19;
  IP_SPEC_MTU_CHANGE          = IP_STATUS_BASE + 20;
  IP_MTU_CHANGE               = IP_STATUS_BASE + 21;
  IP_UNLOAD                   = IP_STATUS_BASE + 22;
  IP_ADDR_ADDED               = IP_STATUS_BASE + 23;
  IP_MEDIA_CONNECT            = IP_STATUS_BASE + 24;
  IP_MEDIA_DISCONNECT         = IP_STATUS_BASE + 25;
  IP_BIND_ADAPTER             = IP_STATUS_BASE + 26;
  IP_UNBIND_ADAPTER           = IP_STATUS_BASE + 27;
  IP_DEVICE_DOES_NOT_EXIST    = IP_STATUS_BASE + 28;
  IP_DUPLICATE_ADDRESS        = IP_STATUS_BASE + 29;
  IP_INTERFACE_METRIC_CHANGE  = IP_STATUS_BASE + 30;
  IP_RECONFIG_SECFLTR         = IP_STATUS_BASE + 31;
  IP_NEGOTIATING_IPSEC        = IP_STATUS_BASE + 32;
  IP_INTERFACE_WOL_CAPABILITY_CHANGE = IP_STATUS_BASE + 33;
  IP_DUPLICATE_IPADD          = IP_STATUS_BASE + 34;

  IP_GENERAL_FAILURE          = IP_STATUS_BASE + 50;
  MAX_IP_STATUS               = IP_GENERAL_FAILURE;
  IP_PENDING                  = IP_STATUS_BASE + 255;

{ Values used in the IP header Flags field of IP_OPTION_INFORMATION. }

  IP_FLAG_REVERSE = $1; { Do a round-trip echo request. }
  IP_FLAG_DF      = $2; { Don't fragment this packet. }


{ Supported IP Option Types. }

{ These types define the options which may be used in the OptionsData field
  of the ip_option_information structure.  See RFC 791 for a complete
  description of each. }

  IP_OPT_EOL          = 0;   { End of list option }
  IP_OPT_NOP          = 1;   { No operation }
  IP_OPT_SECURITY     = $82; { Security option }
  IP_OPT_LSRR         = $83; { Loose source route }
  IP_OPT_SSRR         = $89; { Strict source route }
  IP_OPT_RR           = $7;  { Record route }
  IP_OPT_TS           = $44; { Timestamp }
  IP_OPT_SID          = $88; { Stream ID (obsolete) }
  IP_OPT_ROUTER_ALERT = $94; { Router Alert Option }

  MAX_OPT_SIZE        = 40;  { Maximum length of IP options in bytes }

{ Ioctls code exposed by Memphis tcpip stack.
  For NT these ioctls are define in ntddip.h  (private\inc) }

  IOCTL_IP_RTCHANGE_NOTIFY_REQUEST        = 101;
  IOCTL_IP_ADDCHANGE_NOTIFY_REQUEST       = 102;
  IOCTL_ARP_SEND_REQUEST                  = 103;
  IOCTL_IP_INTERFACE_INFO                 = 104;
  IOCTL_IP_GET_BEST_INTERFACE             = 105;
  IOCTL_IP_UNIDIRECTIONAL_ADAPTER_ADDRESS = 106;

  TCPIP_OWNING_MODULE_SIZE = 16;

type

{ TCP states, as defined in the MIB. }

  TMibTcpState = (
    MIB_TCP_STATE_CLOSED     =  1,
    MIB_TCP_STATE_LISTEN     =  2,
    MIB_TCP_STATE_SYN_SENT   =  3,
    MIB_TCP_STATE_SYN_RCVD   =  4,
    MIB_TCP_STATE_ESTAB      =  5,
    MIB_TCP_STATE_FIN_WAIT1  =  6,
    MIB_TCP_STATE_FIN_WAIT2  =  7,
    MIB_TCP_STATE_CLOSE_WAIT =  8,
    MIB_TCP_STATE_CLOSING    =  9,
    MIB_TCP_STATE_LAST_ACK   = 10,
    MIB_TCP_STATE_TIME_WAIT  = 11,
    MIB_TCP_STATE_DELETE_TCB = 12);

{ Various Offload states a TCP connection can be in. }

  PTcpConnectionOffloadState = ^TTcpConnectionOffloadState;
  TTcpConnectionOffloadState = (
    TcpConnectionOffloadStateInHost,
    TcpConnectionOffloadStateOffloading,
    TcpConnectionOffloadStateOffloaded,
    TcpConnectionOffloadStateUploading,
    TcpConnectionOffloadStateMax);

  PMibTcpRow = ^TMibTcpRow;
  TMibTcpRow = record
    case Integer of
      0: (dwState: DWORD);      { state of the connection }
      1: (State: TMibTcpState;
          dwLocalAddr: DWORD;   { address on local computer }
          dwLocalPort: DWORD;   { port number on local computer }
          dwRemoteAddr: DWORD;  { address on remote computer }
          dwRemotePort: DWORD); { port number on remote computer }
  end;

  PMibTcpTable = ^TMibTcpTable;
  TMibTcpTable = record
    dwNumEntries: DWORD; { number of entries in the table }
    table: array[0..ANY_SIZE - 1] of TMibTcpRow; { array of TCP connections }
  end;

  PMibTcpRow2 = ^TMibTcpRow2;
  TMibTcpRow2 = record
    dwState: DWORD;
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwRemoteAddr: DWORD;
    dwRemotePort: DWORD;
    dwOwningPid: DWORD;
    dwOffloadState: TTcpConnectionOffloadState;
  end;

  PMibTcpTable2 = ^TMibTcpTable2;
  TMibTcpTable2 = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibTcpRow2;
  end;

  PMibTcpRowOwnerPid = ^TMibTcpRowOwnerPid;
  TMibTcpRowOwnerPid = record
    dwState: DWORD;
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwRemoteAddr: DWORD;
    dwRemotePort: DWORD;
    dwOwningPid: DWORD;
  end;

  PMibTcpTableOwnerPid = ^TMibTcpTableOwnerPid;
  TMibTcpTableOwnerPid = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibTcpRowOwnerPid;
  end;

  PMibTcpRowOwnerModule = ^TMibTcpRowOwnerModule;
  TMibTcpRowOwnerModule = record
    dwState: DWORD;
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwRemoteAddr: DWORD;
    dwRemotePort: DWORD;
    dwOwningPid: DWORD;
    liCreateTimestamp: LARGE_INTEGER;
    OwningModuleInfo: array[0..TCPIP_OWNING_MODULE_SIZE - 1] of UINT64;
  end;

  PMibTcpTableOwnerModule = ^TMibTcpTableOwnerModule;
  TMibTcpTableOwnerModule = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibTcpRowOwnerModule;
  end;

  PMibTcp6Row = ^TMibTcp6Row;
  TMibTcp6Row = record
    State: TMibTcpState;
    LocalAddr: TIn6Addr;
    dwLocalScopeId: DWORD;
    dwLocalPort: DWORD;
    RemoteAddr: TIn6Addr;
    dwRemoteScopeId: DWORD;
    dwRemotePort: DWORD;
  end;

  PMibTcp6Table = ^TMibTcp6Table;
  TMibTcp6Table = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibTcp6Row;
  end;

  PMibTcp6Row2 = ^TMibTcp6Row2;
  TMibTcp6Row2 = record
    LocalAddr: TIn6Addr;
    dwLocalScopeId: DWORD;
    dwLocalPort: DWORD;
    RemoteAddr: TIn6Addr;
    dwRemoteScopeId: DWORD;
    dwRemotePort: DWORD;
    State: TMibTcpState;
    dwOwningPid: DWORD;
    dwOffloadState: TTcpConnectionOffloadState;
  end;

  PMibTcp6Table2 = ^TMibTcp6Table2;
  TMibTcp6Table2 = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibTcp6Row2;
  end;

  PMibTcp6RowOwnerPid = ^TMibTcp6RowOwnerPid;
  TMibTcp6RowOwnerPid = record
    ucLocalAddr: array[0..15] of UCHAR;
    dwLocalScopeId: DWORD;
    dwLocalPort: DWORD;
    ucRemoteAddr: array[0..15] of UCHAR;
    dwRemoteScopeId: DWORD;
    dwRemotePort: DWORD;
    dwState: DWORD;
    dwOwningPid: DWORD;
  end;

  PMibTcp6TableOwnerPid = ^TMibTcp6TableOwnerPid;
  TMibTcp6TableOwnerPid = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibTcp6RowOwnerPid;
  end;

  PMibTcp6RowOwnerModule = ^TMibTcp6RowOwnerModule;
  TMibTcp6RowOwnerModule = record
    ucLocalAddr: array[0..15] of UCHAR;
    dwLocalScopeId: DWORD;
    dwLocalPort: DWORD;
    ucRemoteAddr: array[0..15] of UCHAR;
    dwRemoteScopeId: DWORD;
    dwRemotePort: DWORD;
    dwState: DWORD;
    dwOwningPid: DWORD;
    liCreateTimestamp: LARGE_INTEGER;
    OwningModuleInfo: array[0..TCPIP_OWNING_MODULE_SIZE - 1] of UINT64;
  end;

  PMibTcp6TableOwnerModule = ^TMibTcp6TableOwnerModule;
  TMibTcp6TableOwnerModule = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibTcp6RowOwnerModule;
  end;

const
  MIB_TCP_MAXCONN_DYNAMIC = ULONG(-1);

type
  PTcpRtoAlgorithm = ^TTcpRtoAlgorithm;
  TTcpRtoAlgorithm = (
    MIB_TCP_RTO_OTHER     = 1,
    MIB_TCP_RTO_CONSTANT  = 2,
    MIB_TCP_RTO_RSRE      = 3,
    MIB_TCP_RTO_VANJ      = 4);

  PMibTcpStats = ^TMibTcpStats;
  TMibTcpStats = record
    case Integer of
      0: (dwRtoAlgorithm: DWORD); { timeout algorithm }
      1: (RtoAlgorithm: TTcpRtoAlgorithm;
          dwRtoMin: DWORD;        { minimum timeout }
          dwRtoMax: DWORD;        { maximum timeout }
          dwMaxConn: DWORD;       { maximum connections }
          dwActiveOpens: DWORD;   { active opens }
          dwPassiveOpens: DWORD;  { passive opens }
          dwAttemptFails: DWORD;  { failed attempts }
          dwEstabResets: DWORD;   { establised connections reset }
          dwCurrEstab: DWORD;     { established connections }
          dwInSegs: DWORD;        { segments received }
          dwOutSegs: DWORD;       { segment sent }
          dwRetransSegs: DWORD;   { segments retransmitted }
          dwInErrs: DWORD;        { incoming errors }
          dwOutRsts: DWORD;       { outgoing resets }
          dwNumConns: DWORD);     { cumulative connections }
  end;

  PMibUdpRow = ^TMibUdpRow;
  TMibUdpRow = record
    dwLocalAddr: DWORD; { IP address on local computer }
    dwLocalPort: DWORD; { port number on local computer }
  end;

  PMibUdpTable = ^TMibUdpTable;
  TMibUdpTable = record
    dwNumEntries: DWORD; { number of entries in the table }
    table: array[0..ANY_SIZE - 1] of TMibUdpRow; { table of MIB_UDPROW structs }
  end;

  PMibUdpRowOwnerPid = ^TMibUdpRowOwnerPid;
  TMibUdpRowOwnerPid = record
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwOwningPid: DWORD;
  end;

  PMibUdpTableOwnerPid = ^TMibUdpTableOwnerPid;
  TMibUdpTableOwnerPid = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibUdpRowOwnerPid; 
  end;

  PMibUdpRowOwnerModule = ^TMibUdpRowOwnerModule;
  TMibUdpRowOwnerModule = record
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwOwningPid: DWORD;
    liCreateTimestamp: LARGE_INTEGER;
    case Integer of
      0: (SpecificPortBind: Integer);
      1: (dwFlags: Integer;
          OwningModuleInfo: array[0..TCPIP_OWNING_MODULE_SIZE - 1] of UINT64);
  end;

  PMibUdpTableOwnerModule = ^TMibUdpTableOwnerModule;
  TMibUdpTableOwnerModule = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibUdpRowOwnerModule;
  end;

  PMibUdp6Row = ^TMibUdp6Row;
  TMibUdp6Row = record
    LocalAddr: TIn6Addr;
    dwLocalScopeId: DWORD;
    dwLocalPort: DWORD;
  end;

  PMibUdp6Table = ^TMibUdp6Table;
  TMibUdp6Table = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibUdp6Row;
  end;

  PMibUdp6RowOwnerPid = ^TMibUdp6RowOwnerPid;
  TMibUdp6RowOwnerPid = record
    ucLocalAddr: array[0..15] of UCHAR;
    dwLocalScopeId: DWORD;
    dwLocalPort: DWORD;
    dwOwningPid: DWORD;
  end;

  PMibUdp6TableOwnerPid = ^TMibUdp6TableOwnerPid;
  TMibUdp6TableOwnerPid = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibUdp6RowOwnerPid;
  end;

  PMibUdp6RowOwnerModule = ^TMibUdp6RowOwnerModule;
  TMibUdp6RowOwnerModule = record
    ucLocalAddr: array[0..15] of UCHAR;
    dwLocalScopeId: DWORD;
    dwLocalPort: DWORD;
    dwOwningPid: DWORD;
    liCreateTimestamp: LARGE_INTEGER;
    case Integer of
      0: (SpecificPortBind: Integer);
      1: (dwFlags: Integer;
          OwningModuleInfo: array[0..TCPIP_OWNING_MODULE_SIZE - 1] of UINT64);
  end;

  PMibUdp6TableOwnerModule = ^TMibUdp6TableOwnerModule;
  TMibUdp6TableOwnerModule = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibUdp6RowOwnerModule;
  end;

  PMibUdpStats = ^TMibUdpStats;
  TMibUdpStats = record
    dwInDatagrams: DWORD;  { received datagrams }
    dwNoPorts: DWORD;      { datagrams for which no port }
    dwInErrors: DWORD;     { errors on received datagrams }
    dwOutDatagrams: DWORD; { sent datagrams }
    dwNumAddrs: DWORD;     { number of entries in UDP listener table }
  end;

const
  IPRTRMGR_PID = 10000;

{ The following #defines are the Ids of the MIB variables made accessible
  to the user via MprAdminMIBXXX Apis.  It will be noticed that these are
  not the same as RFC 1213, since the MprAdminMIBXXX APIs work on rows and
  groups instead of scalar variables }

  IF_NUMBER          = 0;
  IF_TABLE           = IF_NUMBER          + 1;
  IF_ROW             = IF_TABLE           + 1;
  IP_STATS           = IF_ROW             + 1;
  IP_ADDRTABLE       = IP_STATS           + 1;
  IP_ADDRROW         = IP_ADDRTABLE       + 1;
  IP_FORWARDNUMBER   = IP_ADDRROW         + 1;
  IP_FORWARDTABLE    = IP_FORWARDNUMBER   + 1;
  IP_FORWARDROW      = IP_FORWARDTABLE    + 1;
  IP_NETTABLE        = IP_FORWARDROW      + 1;
  IP_NETROW          = IP_NETTABLE        + 1;
  ICMP_STATS         = IP_NETROW          + 1;
  TCP_STATS          = ICMP_STATS         + 1;
  TCP_TABLE          = TCP_STATS          + 1;
  TCP_ROW            = TCP_TABLE          + 1;
  UDP_STATS          = TCP_ROW            + 1;
  UDP_TABLE          = UDP_STATS          + 1;
  UDP_ROW            = UDP_TABLE          + 1;
  MCAST_MFE          = UDP_ROW            + 1;
  MCAST_MFE_STATS    = MCAST_MFE          + 1;
  BEST_IF            = MCAST_MFE_STATS    + 1;
  BEST_ROUTE         = BEST_IF            + 1;
  PROXY_ARP          = BEST_ROUTE         + 1;
  MCAST_IF_ENTRY     = PROXY_ARP          + 1;
  MCAST_GLOBAL       = MCAST_IF_ENTRY     + 1;
  IF_STATUS          = MCAST_GLOBAL       + 1;
  MCAST_BOUNDARY     = IF_STATUS          + 1;
  MCAST_SCOPE        = MCAST_BOUNDARY     + 1;
  DEST_MATCHING      = MCAST_SCOPE        + 1;
  DEST_LONGER        = DEST_MATCHING      + 1;
  DEST_SHORTER       = DEST_LONGER        + 1;
  ROUTE_MATCHING     = DEST_SHORTER       + 1;
  ROUTE_LONGER       = ROUTE_MATCHING     + 1;
  ROUTE_SHORTER      = ROUTE_LONGER       + 1;
  ROUTE_STATE        = ROUTE_SHORTER      + 1;
  MCAST_MFE_STATS_EX = ROUTE_STATE        + 1;
  IP6_STATS          = MCAST_MFE_STATS_EX + 1;
  UDP6_STATS         = IP6_STATS          + 1;
  TCP6_STATS         = UDP6_STATS         + 1;

  NUMBER_OF_EXPORTED_VARIABLES = TCP6_STATS + 1;

type

{ MIB_OPAQUE_QUERY is the structure filled in by the user to identify a   
  MIB variable

   dwVarId     ID of MIB Variable (One of the Ids #defined above)
   dwVarIndex  Variable sized array containing the indices needed to
               identify a variable. NOTE: Unlike SNMP we dont require that
               a scalar variable be indexed by 0 }

  PMibOpaqueQuery = ^TMibOpaqueQuery;
  TMibOpaqueQuery = record
    dwVarId: DWORD;
    rgdwVarIndex: array [0..ANY_SIZE - 1] of DWORD;
  end;

{ The following are the structures which are filled in and returned to the 
  user when a query is made, OR  are filled in BY THE USER when a set is
  done }

  PTcpTableClass = ^TTcpTableClass;
  TTcpTableClass = (
    TCP_TABLE_BASIC_LISTENER,
    TCP_TABLE_BASIC_CONNECTIONS,
    TCP_TABLE_BASIC_ALL,
    TCP_TABLE_OWNER_PID_LISTENER,
    TCP_TABLE_OWNER_PID_CONNECTIONS,
    TCP_TABLE_OWNER_PID_ALL,
    TCP_TABLE_OWNER_MODULE_LISTENER,
    TCP_TABLE_OWNER_MODULE_CONNECTIONS,
    TCP_TABLE_OWNER_MODULE_ALL);

  PUdpTableClass = ^TUdpTableClass;
  TUdpTableClass = (
    UDP_TABLE_BASIC,
    UDP_TABLE_OWNER_PID,
    UDP_TABLE_OWNER_MODULE);

  PTcpIpOwnerModuleInfoClass = ^TTcpIpOwnerModuleInfoClass;
  TTcpIpOwnerModuleInfoClass = (
    TCPIP_OWNER_MODULE_INFO_BASIC);

  PTcpIpOwnerModuleBasicInfo = ^TTcpIpOwnerModuleBasicInfo;
  TTcpIpOwnerModuleBasicInfo = record
    pModuleName: PWCHAR;
    pModulePath: PWCHAR;
  end;

  PMibIpMcastBoundary = ^TMibIpMcastBoundary;
  TMibIpMcastBoundary = record
    dwIfIndex: DWORD;
    dwGroupAddress: DWORD;
    dwGroupMask: DWORD;
    dwStatus: DWORD;
  end;

  PMibIpMcastBoundaryTable = ^TMibIpMcastBoundaryTable;
  TMibIpMcastBoundaryTable = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibIpMcastBoundary;
  end;

  PMibBoundaryRow = ^TMibBoundaryRow;
  TMibBoundaryRow = record
    dwGroupAddress: DWORD;
    dwGroupMask: DWORD;
  end;

  PMibMcastLimitRow = ^TMibMcastLimitRow;
  TMibMcastLimitRow = record
    dwTtl: DWORD;
    dwRateLimit: DWORD;
  end;

const
  MAX_SCOPE_NAME_LEN = 255;

type

{ Scope names are unicode.  SNMP and MZAP use UTF-8 encoding. }

  TSnChar = WCHAR;
  TScopeNameBuffer = array[0..MAX_SCOPE_NAME_LEN] of TSnChar;
  TScopeName = ^TSnChar;

  PMibIpMcastScope = ^TMibIpMcastScope;
  TMibIpMcastScope = record
    dwGroupAddress: DWORD;
    dwGroupMask: DWORD;
    snNameBuffer: TScopeNameBuffer;
    dwStatus: DWORD;
  end;

  PMibIpDestRow = ^TMibIpDestRow;
  TMibIpDestRow = record
    ForwardRow: TMibIpForwardRow;
    dwForwardPreference: DWORD;
    dwForwardViewSet: DWORD;
  end;

  PMibIpDestTable = ^TMibIpDestTable;
  TMibIpDestTable = record
    dwNumEntries: DWORD;
    table: array[0..ANY_SIZE - 1] of TMibIpDestRow;
  end;

  PMibBestIf = ^TMibBestIf;
  TMibBestIf = record
    dwDestAddr: DWORD;
    dwIfIndex: DWORD;
  end;

  PMibProxyArp = ^TMibProxyArp;
  TMibProxyArp = record
    dwAddress: DWORD;
    dwMask: DWORD;
    dwIfIndex: DWORD;
  end;

  PMibIfStatus = ^TMibIfStatus;
  TMibIfStatus = record
    dwIfIndex: DWORD;
    dwAdminStatus: DWORD;
    dwOperationalStatus: DWORD;
    bMHbeatActive: BOOL;
    bMHbeatAlive: BOOL;
  end;

  PMibRouteState = ^TMibRouteState;
  TMibRouteState = record
    bRoutesSetToStack: BOOL;
  end;

  PMibOpaqueInfo = ^TMibOpaqueInfo;
  TMibOpaqueInfo = record
    dwId: DWORD;
    case Integer of
      0: (ullAlign: UINT64);
      1: (rgbyData: array[0..0] of Byte);
  end;

{ Please don't change the order of this enum. The order defined in this
  enum needs to match the order in EstatsToTcpObjectMappingTable. }

 PTcpEstatsType = ^TTcpEstatsType;
 TTcpEstatsType = (
    TcpConnectionEstatsSynOpts,
    TcpConnectionEstatsData,
    TcpConnectionEstatsSndCong,
    TcpConnectionEstatsPath,
    TcpConnectionEstatsSendBuff,
    TcpConnectionEstatsRec,
    TcpConnectionEstatsObsRec,
    TcpConnectionEstatsBandwidth,
    TcpConnectionEstatsFineRtt,
    TcpConnectionEstatsMaximum);

{ Define the states that a caller can specify when updating a boolean field. }

  PTcpBooleanOptional = ^TTcpBooleanOptional;
  TTcpBooleanOptional = (
    TcpBoolOptDisabled = 0,
    TcpBoolOptEnabled,
    TcpBoolOptUnchanged = -1);

{ Define extended SYN-exchange information maintained for TCP connections. }

  PTcpEstatsSynOptsRosv0 = ^TTcpEstatsSynOptsRosv0;
  TTcpEstatsSynOptsRosv0 = record
    ActiveOpen: Boolean;
    MssRcvd: ULONG;
    MssSent: ULONG;
  end;   

{ Enumerate the non-fatal errors recorded on each connection. }

  PTcpSoftError = ^TTcpSoftError;
  TTcpSoftError = (
    TcpErrorNone = 0,
    TcpErrorBelowDataWindow,
    TcpErrorAboveDataWindow,
    TcpErrorBelowAckWindow,
    TcpErrorAboveAckWindow,
    TcpErrorBelowTsWindow,
    TcpErrorAboveTsWindow,
    TcpErrorDataChecksumError,
    TcpErrorDataLengthError,
    TcpErrorMaxSoftError);

{ Define extended data-transfer information for TCP connections. }

  PTcpEstatsDataRodv0 = ^TTcpEstatsDataRodv0;
  TTcpEstatsDataRodv0 = record
    DataBytesOut: UINT64;
    DataSegsOut: UINT64;
    DataBytesIn: UINT64;
    DataSegsIn: UINT64;
    SegsOut: UINT64;
    SegsIn: UINT64;
    SoftErrors: ULONG;
    SoftErrorReason: ULONG;
    SndUna: ULONG;
    SndNxt: ULONG;
    SndMax: ULONG;
    ThruBytesAcked: UINT64;
    RcvNxt: ULONG;
    ThruBytesReceived: UINT64;
  end;

{ Define structure for enabling extended data-transfer information. }

  PTcpEstatsDataRwv0 = ^TTcpEstatsDataRwv0;
  TTcpEstatsDataRwv0 = record
    EnableCollection: Boolean;
  end;

{ Define extended sender-congestion information for TCP connections. }

  PTcpEstatsSndCongRodv0 = ^TTcpEstatsSndCongRodv0;
  TTcpEstatsSndCongRodv0 = record
    SndLimTransRwin: ULONG;
    SndLimTimeRwin: ULONG;
    SndLimBytesRwin: ULONG;
    SndLimTransCwnd: ULONG;
    SndLimTimeCwnd: ULONG;
    SndLimBytesCwnd: ULONG;
    SndLimTransSnd: ULONG;
    SndLimTimeSnd: ULONG;
    SndLimBytesSnd: ULONG;
    SlowStart: ULONG;
    CongAvoid: ULONG;
    OtherReductions: ULONG;
    CurCwnd: ULONG;
    MaxSsCwnd: ULONG;
    MaxCaCwnd: ULONG;
    CurSsthresh: ULONG;
    MaxSsthresh: ULONG;
    MinSsthresh: ULONG;
  end;

{ Define static extended sender-congestion information for TCP connections. }

  PTcpEstatsSndCongRosv0 = ^TTcpEstatsSndCongRosv0;
  TTcpEstatsSndCongRosv0 = record
    LimCwnd: ULONG;
  end;

{ Define structure for enabling extended sender-congestion information. }

  PTcpEstatsSndCongRwv0 = ^TTcpEstatsSndCongRwv0;
  TTcpEstatsSndCongRwv0 = record
    EnableCollection: Boolean;
  end;

{ Define extended path-measurement information for TCP connections. }

  PTcpEstatsPathRodv0 = ^TTcpEstatsPathRodv0;
  TTcpEstatsPathRodv0 = record
    FastRetran: ULONG;
    Timeouts: ULONG;
    SubsequentTimeouts: ULONG;
    CurTimeoutCount: ULONG;
    AbruptTimeouts: ULONG;
    PktsRetrans: ULONG;
    BytesRetrans: ULONG;
    DupAcksIn: ULONG;
    SacksRcvd: ULONG;
    SackBlocksRcvd: ULONG;
    CongSignals: ULONG;
    PreCongSumCwnd: ULONG;
    PreCongSumRtt: ULONG;
    PostCongSumRtt: ULONG;
    PostCongCountRtt: ULONG;
    EcnSignals: ULONG;
    EceRcvd: ULONG;
    SendStall: ULONG;
    QuenchRcvd: ULONG;
    RetranThresh: ULONG;
    SndDupAckEpisodes: ULONG;
    SumBytesReordered: ULONG;
    NonRecovDa: ULONG;
    NonRecovDaEpisodes: ULONG;
    AckAfterFr: ULONG;
    DsackDups: ULONG;
    SampleRtt: ULONG;
    SmoothedRtt: ULONG;
    RttVar: ULONG;
    MaxRtt: ULONG;
    MinRtt: ULONG;
    SumRtt: ULONG;
    CountRtt: ULONG;
    CurRto: ULONG;
    MaxRto: ULONG;
    MinRto: ULONG;
    CurMss: ULONG;
    MaxMss: ULONG;
    MinMss: ULONG;
    SpuriousRtoDetections: ULONG;
  end;

{ Define structure for enabling path-measurement information. }

  PTcpEstatsPathRwv0 = ^TTcpEstatsPathRwv0;
  TTcpEstatsPathRwv0 = record
    EnableCollection: Boolean;
  end;

{ Define extended output-queuing information for TCP connections. }

  PTcpEstatsSendBuffRodv0 = ^TTcpEstatsSendBuffRodv0;
  TTcpEstatsSendBuffRodv0 = record
    CurRetxQueue: ULONG;
    MaxRetxQueue: ULONG;
    CurAppWQueue: ULONG;
    MaxAppWQueue: ULONG;
  end;

{ Define structure for enabling output-queuing information. }

  PTcpEstatsSendBuffRwv0 = ^TTcpEstatsSendBuffRwv0;
  TTcpEstatsSendBuffRwv0 = record
    EnableCollection: Boolean;
  end;

{ Define extended local-receiver information for TCP connections. }

  PTcpEstatsRecRodv0 = ^TTcpEstatsRecRodv0;
  TTcpEstatsRecRodv0 = record
    CurRwinSent: ULONG;
    MaxRwinSent: ULONG;
    MinRwinSent: ULONG;
    LimRwin: ULONG;
    DupAckEpisodes: ULONG;
    DupAcksOut: ULONG;
    CeRcvd: ULONG;
    EcnSent: ULONG;
    EcnNoncesRcvd: ULONG;
    CurReasmQueue: ULONG;
    MaxReasmQueue: ULONG;
    CurAppRQueue: ULONG;
    MaxAppRQueue: ULONG;
    WinScaleSent: UCHAR;
  end;

{ Define structure for enabling local-receiver information. }

  PTcpEstatsRecRwv0 = ^TTcpEstatsRecRwv0;
  TTcpEstatsRecRwv0 = record
    EnableCollection: Boolean;
  end;

{ Define extended remote-receiver information for TCP connections. }

  PTcpEstatsObsRecRodv0 = ^TTcpEstatsObsRecRodv0;
  TTcpEstatsObsRecRodv0 = record
    CurRwinRcvd: ULONG;
    MaxRwinRcvd: ULONG;
    MinRwinRcvd: ULONG;
    WinScaleRcvd: UCHAR;
  end;

{ Define structure for enabling remote-receiver information. }

  PTcpEstatsObsRecRwv0 = ^TTcpEstatsObsRecRwv0;
  TTcpEstatsObsRecRwv0 = record
    EnableCollection: Boolean;
  end;

{ Define the structure for enabling bandwidth estimation for TCP connections. }

  PTcpEstatsBandwidthRwv0 = ^TTcpEstatsBandwidthRwv0;
  TTcpEstatsBandwidthRwv0 = record
    EnableCollectionOutbound: TTcpBooleanOptional;
    EnableCollectionInbound: TTcpBooleanOptional;
  end;

{ Define bandwidth estimation statistics for TCP connections.

  Bandwidth and Instability metrics are expressed as bits per second. }

  PTcpEstatsBandwidthRodv0 = ^TTcpEstatsBandwidthRodv0;
  TTcpEstatsBandwidthRodv0 = record
    OutboundBandwidth: UINT64;
    InboundBandwidth: UINT64;
    OutboundInstability: UINT64;
    InboundInstability: UINT64;
    OutboundBandwidthPeaked: Boolean;
    InboundBandwidthPeaked: Boolean;
  end;

{ Define the structure for enabling fine-grained RTT estimation for TCP
 connections. }

  PTcpEstatsFineRttRwv0 = ^TTcpEstatsFineRttRwv0;
  TTcpEstatsFineRttRwv0 = record
    EnableCollection: Boolean;
  end;

{ Define fine-grained RTT estimation statistics for TCP connections. }

  PTcpEstatsFineRttRodv0= ^TTcpEstatsFineRttRodv0;
  TTcpEstatsFineRttRodv0 = record
    RttVar: ULONG;
    MaxRtt: ULONG;
    MinRtt: ULONG;
    SumRtt: ULONG;
  end;

{ Retrieves the number of interfaces in the system. These include LAN and
  WAN interfaces }

function GetNumberOfInterfaces(pdwNumIf: PDWORD): DWORD; stdcall;

{ Gets the MIB-II ifEntry
  The dwIndex field of the MIB_IFROW should be set to the index of the
  interface being queried }

function GetIfEntry(pIfRow: PMibIfRow): DWORD; stdcall;

{ Gets the MIB-II IfTable }

function GetIfTable(pIfTable: PMibIfTable; pdwSize: PULONG;
  bOrder: BOOL): DWORD; stdcall;

{ Gets the Interface to IP Address mapping }

function GetIpAddrTable(pIpAddrTable: PMibIpAddrTable; pdwSize: PULONG;
  bOrder: BOOL): DWORD; stdcall;

{ Gets the current IP Address to Physical Address (ARP) mapping }

function GetIpNetTable(pIpNetTable: PMibIpNetTable; pdwSize: PULONG;
  bOrder: BOOL): DWORD; stdcall;

{ Gets the IP Routing Table }

function GetIpForwardTable(pIpForwardTable: PMibIpForwardTable; pdwSize: PULONG;
  bOrder: BOOL): DWORD; stdcall;

{ Gets TCP Connection/UDP Listener Table }

function GetTcpTable(pTcpTable: PMibTcpTable; pdwSize: PDWORD;
  bOrder: BOOL): DWORD; stdcall;
function GetExtendedTcpTable(pTcpTable: Pointer; pdwSize: PDWORD;
  bOrder: BOOL; ulAf: ULONG; TableClass: TTcpTableClass;
  Reserved: ULONG): DWORD; stdcall;
function GetOwnerModuleFromTcpEntry(pTcpEntry: PMibTcpRowOwnerModule;
  InfoClass: TTcpIpOwnerModuleInfoClass; pBuffer: Pointer;
  pdwSize: PDWORD): DWORD; stdcall;
function GetUdpTable(pUdpTable: PMibUdpTable; pdwSize: PDWORD;
  bOrder: BOOL): DWORD; stdcall;
function GetExtendedUdpTable(pUdpTable: Pointer; pdwSize: PDWORD;
  bOrder: BOOL; ulAf: ULONG; TableClass: TUdpTableClass;
  Reserved: ULONG): DWORD; stdcall;
function GetOwnerModuleFromUdpEntry(pUdpEntry: PMibUdpRowOwnerModule;
  InfoClass: TTcpIpOwnerModuleInfoClass; pBuffer: Pointer;
  pdwSize: PDWORD): DWORD; stdcall;
function GetTcpTable2(TcpTable: PMibTcpTable2; SizePointer: PULONG;
  Order: BOOL): ULONG; stdcall;

{ Deprecated APIs, Added for documentation. }

function AllocateAndGetTcpExTableFromStack(var ppTcpTable: Pointer; bOrder: BOOL;
  hHeap: THandle; dwFlags, dwFamily: DWORD): DWORD; stdcall;
function AllocateAndGetUdpExTableFromStack(var ppUdpTable: Pointer; bOrder: BOOL;
  hHeap: THandle; dwFlags, dwFamily: DWORD): DWORD; stdcall;

{ The following definitions require Winsock2. }

function GetTcp6Table(TcpTable: PMibTcp6Table; SizePointer: PULONG;
  Order: BOOL): ULONG; stdcall;
function GetTcp6Table2(TcpTable: PMibTcp6Table2; SizePointer: PULONG;
  Order: BOOL): ULONG; stdcall;
function GetPerTcpConnectionEStats(Row: PMibTcpRow; EstatsType: TTcpEstatsType;
  Rw: PUCHAR; RwVersion, RwSize: ULONG; Ros: PUCHAR; RosVersion, RosSize: ULONG;
  Rod: PUCHAR; RodVersion, RodSize: ULONG): ULONG; stdcall;
function SetPerTcpConnectionEStats(Row: PMibTcpRow; EstatsType: TTcpEstatsType;
  Rw: PUCHAR; RwVersion, RwSize, Offset: ULONG): ULONG; stdcall;
function GetPerTcp6ConnectionEStats(Row: PMibTcp6Row; EstatsType: TTcpEstatsType;
  Rw: PUCHAR; RwVersion, RwSize: ULONG; Ros: PUCHAR; RosVersion, RosSize: ULONG;
  Rod: PUCHAR; RodVersion, RodSize: ULONG): ULONG; stdcall;
function SetPerTcp6ConnectionEStats(Row: PMibTcp6Row; EstatsType: TTcpEstatsType;
  Rw: PUCHAR; RwVersion, RwSize, Offset: ULONG): ULONG; stdcall;
function GetOwnerModuleFromTcp6Entry(pTcpEntry: PMibTcp6RowOwnerModule;
  InfoClass: TTcpIpOwnerModuleInfoClass; pBuffer: Pointer;
  pdwSize: PDWORD): DWORD; stdcall;
function GetUdp6Table(Udp6Table: PMibUdp6Table; SizePointer: PDWORD;
  Order: BOOL): ULONG; stdcall;
function GetOwnerModuleFromUdp6Entry(pUdpEntry: PMibUdp6RowOwnerModule;
  InfoClass: TTcpIpOwnerModuleInfoClass; pBuffer: Pointer;
  pdwSize: PDWORD): DWORD; stdcall;
function GetOwnerModuleFromPidAndInfo(ulPid: ULONG; pInfo: PUINT64;
  InfoClass: TTcpIpOwnerModuleInfoClass; pBuffer: Pointer;
  pdwSize: PDWORD): DWORD; stdcall;

{ Gets IP/ICMP/TCP/UDP Statistics }

function GetIpStatistics(pStats: PMibIpStats): ULONG; stdcall;
function GetIcmpStatistics(pStats: PMibIcmp): ULONG; stdcall;
function GetTcpStatistics(pStats: PMibTcpStats): ULONG; stdcall;
function GetUdpStatistics(pStats: PMibUdpStats): ULONG; stdcall;
function GetIpStatisticsEx(pStats: PMibIpStats; Family: ULONG): ULONG; stdcall;
function SetIpStatisticsEx(pStats: PMibIpStats; Family: ULONG): ULONG; stdcall;
function GetIcmpStatisticsEx(pStats: PMibIcmpEx; Family: ULONG): ULONG; stdcall;
function GetTcpStatisticsEx(pStats: PMibTcpStats; Family: ULONG): ULONG; stdcall;
function GetUdpStatisticsEx(pStats: PMibUdpStats; Family: ULONG): ULONG; stdcall;

{ Used to set the ifAdminStatus on an interface.  The only fields of the
 MIB_IFROW that are relevant are the dwIndex (index of the interface
 whose status needs to be set) and the dwAdminStatus which can be either
 MIB_IF_ADMIN_STATUS_UP or MIB_IF_ADMIN_STATUS_DOWN }

function SetIfEntry(pIfRow: PMibIfRow): DWORD; stdcall;

{ Used to create, modify or delete a route.  In all cases the
  dwForwardIfIndex, dwForwardDest, dwForwardMask, dwForwardNextHop and
  dwForwardPolicy MUST BE SPECIFIED. Currently dwForwardPolicy is unused
  and MUST BE 0.
  For a set, the complete MIB_IPFORWARDROW structure must be specified }

function CreateIpForwardEntry(pRoute: PMibIpForwardRow): DWORD; stdcall;
function SetIpForwardEntry(pRoute: PMibIpForwardRow): DWORD; stdcall;
function DeleteIpForwardEntry(pRoute: PMibIpForwardRow): DWORD; stdcall;

{ Used to set the ipForwarding to ON or OFF (currently only ON->OFF is
  allowed) and to set the defaultTTL.  If only one of the fields needs to
  be modified and the other needs to be the same as before the other field
  needs to be set to MIB_USE_CURRENT_TTL or MIB_USE_CURRENT_FORWARDING as
  the case may be }

function SetIpStatistics(pIpStats: PMibIpStats): DWORD; stdcall;

{ Used to set the defaultTTL. }

function SetIpTTL(nTTL: UINT): DWORD; stdcall;

{ Used to create, modify or delete an ARP entry.  In all cases the dwIndex
 dwAddr field MUST BE SPECIFIED.
 For a set, the complete MIB_IPNETROW structure must be specified }

function CreateIpNetEntry(pArpEntry: PMibIpNetRow): DWORD; stdcall;
function SetIpNetEntry(pArpEntry: PMibIpNetRow): DWORD; stdcall;
function DeleteIpNetEntry(pArpEntry: PMibIpNetRow): DWORD; stdcall;
function FlushIpNetTable(dwIfIndex: DWORD): DWORD; stdcall;

{ Used to create or delete a Proxy ARP entry. The dwIndex is the index of  
  the interface on which to PARP for the dwAddress.  If the interface is
  of a type that doesnt support ARP, e.g. PPP, then the call will fail }

function CreateProxyArpEntry(dwAddress, dwMask, dwIfIndex: DWORD): DWORD; stdcall;
function DeleteProxyArpEntry(dwAddress, dwMask, dwIfIndex: DWORD): DWORD; stdcall;

{ Used to set the state of a TCP Connection. The only state that it can be
  set to is MIB_TCP_STATE_DELETE_TCB.  The complete MIB_TCPROW structure
  MUST BE SPECIFIED }

function SetTcpEntry(pTcpRow: PMibTcpRow): DWORD; stdcall;
function GetInterfaceInfo(pIfTable: PIpInterfaceInfo;
  dwOutBufLen: PULONG):DWORD; stdcall;
function GetUniDirectionalAdapterInfo(pIPIfInfo: PIpUnidirectionalAdapterAddress;
  dwOutBufLen: PULONG): DWORD; stdcall;

{ The NhpAllocateAndGetInterfaceInfoFromStack function has been deprecated.
  The GetAdaptersAddresses function and the associated IP_ADAPTER_ADDRESSES
  structure should be used instead. } 

function NhpAllocateAndGetInterfaceInfoFromStack(var ppTable: PIpInterfaceNameInfo;
  pdwCount: PDWORD; bOrder: BOOL; hHeap: THandle; dwFlags: DWORD): DWORD; stdcall;

{ Gets the "best" outgoing interface for the specified destination address }

function GetBestInterface(dwDestAddr: TIpAddr; pdwBestIfIndex: PDWORD): DWORD; stdcall;
function GetBestInterfaceEx(pDestAddr: PSockAddr; pdwBestIfIndex: PDWORD): DWORD; stdcall;

{ Gets the best (longest matching prefix) route for the given destination  
  If the source address is also specified (i.e. is not 0x00000000), and
  there are multiple "best" routes to the given destination, the returned
  route will be one that goes out over the interface which has an address
  that matches the source address }

function GetBestRoute(dwDestAddr, dwSourceAddr: DWORD; pBestRoute: PMibIpForwardRow): DWORD; stdcall;
function NotifyAddrChange(Handle: PHandle; overlapped: POverlapped): DWORD; stdcall;
function NotifyRouteChange(Handle: PHandle; overlapped: POverlapped): DWORD; stdcall;
function CancelIPChangeNotify(notifyOverlapped: POverlapped): BOOL; stdcall;
function GetAdapterIndex(AdapterName: LPWSTR; IfIndex: PULONG): DWORD; stdcall;
function AddIPAddress(Address: TIpAddr; IpMask: TIpMask; IfIndex: DWORD;
  NTEContext, NTEInstance: PULONG): DWORD; stdcall;
function DeleteIPAddress(NTEContext: ULONG): DWORD; stdcall;
function GetNetworkParams(pFixedInfo: PFixedInfo; pOutBufLen: PULONG): DWORD; stdcall;
function GetAdaptersInfo(pAdapterInfo: PIpAdapterInfo; pOutBufLen: PULONG): DWORD; stdcall;
function GetAdapterOrderMap: PIpAdapterOrderMap; stdcall;
function GetAdaptersAddresses(Family, Flags: ULONG; Reserved: Pointer;
  pAdapterAddresses: PIpAdapterAddresses; pOutBufLen: PULONG): DWORD; stdcall;
function GetPerAdapterInfo(IfIndex: ULONG; pPerAdapterInfo: PIpPerAdapterInfo;
  pOutBufLen: PULONG): DWORD; stdcall;
function IpReleaseAddress(AdapterInfo: PIpAdapterIndexMap): DWORD; stdcall;
function IpRenewAddress(AdapterInfo: PIpAdapterIndexMap): DWORD; stdcall;
function SendARP(DestIP, SrcIP: TIpAddr; pMacAddr, PhyAddrLen: PULONG): DWORD; stdcall;
function GetRTTAndHopCount(DestIpAddress: TIpAddr; HopCount: PULONG;
  MaxHops: ULONG; RTT: PULONG): BOOL; stdcall;
function GetFriendlyIfIndex(IfIndex: DWORD): DWORD; stdcall;
function EnableRouter(pHandle: PHandle; pOverlapped: POverlapped): DWORD; stdcall;
function UnenableRouter(pOverlapped: POverlapped; lpdwEnableCount: LPDWORD = nil): DWORD; stdcall;
function DisableMediaSense(pHandle: PHandle; pOverlapped: POverlapped): DWORD; stdcall;
function RestoreMediaSense(pOverlapped: POverlapped; lpdwEnableCount: LPDWORD = nil): DWORD; stdcall;
function GetIpErrorString(ErrorCode: TIpStatus; Buffer: PWCHAR; Size: PDWORD): DWORD; stdcall;

{ Note  This function is deprecated and not supported.
  Developers should use the ResolveIpNetEntry2 function. }

function ResolveNeighbor(NetworkAddress: PSockAddr; PhysicalAddress: Pointer;
  PhysicalAddressLength: PULONG): ULONG; stdcall;

{ Port reservation API routines. }

function CreatePersistentTcpPortReservation(StartPort, NumberOfPorts: Word;
  Token: PUINT64): ULONG; stdcall;
function CreatePersistentUdpPortReservation(StartPort, NumberOfPorts: Word;
  Token: PUINT64): ULONG; stdcall;
function DeletePersistentTcpPortReservation(StartPort,
  NumberOfPorts: Word): ULONG; stdcall;
function DeletePersistentUdpPortReservation(StartPort,
  NumberOfPorts: Word): ULONG; stdcall;
function LookupPersistentTcpPortReservation(StartPort, NumberOfPorts: Word;
  Token: PUINT64): ULONG; stdcall;
function LookupPersistentUdpPortReservation(StartPort, NumberOfPorts: Word;
  Token: PUINT64): ULONG; stdcall;

{ Network String parsing API }

const
  NET_STRING_IPV4_ADDRESS          = $00000001;
    { The string identifies an IPv4 Host/router using literal address.
      (port or prefix not allowed) }
  NET_STRING_IPV4_SERVICE          = $00000002;
    { The string identifies an IPv4 service using literal address.
     (port required; prefix not allowed) }
  NET_STRING_IPV4_NETWORK          = $00000004;
    { The string identifies an IPv4 network.
     (prefix required; port not allowed) }
  NET_STRING_IPV6_ADDRESS          = $00000008;
    { The string identifies an IPv6 Host/router using literal address.
    ( port or prefix not allowed; scope-id allowed) }
  NET_STRING_IPV6_ADDRESS_NO_SCOPE = $00000010;
    { The string identifies an IPv6 Host/router using literal address
      where the interface context is already known.
      (port or prefix not allowed; scope-id not allowed) }
  NET_STRING_IPV6_SERVICE          = $00000020;
    { The string identifies an IPv6 service using literal address.
      (port required; prefix not allowed; scope-id allowed) }
  NET_STRING_IPV6_SERVICE_NO_SCOPE = $00000040;
    { The string identifies an IPv6 service using literal address
      where the interface context is already known.
      (port required; prefix not allowed; scope-id not allowed) }
  NET_STRING_IPV6_NETWORK          = $00000080;
    { The string identifies an IPv6 network.
      (prefix required; port or scope-id not allowed) }
  NET_STRING_NAMED_ADDRESS         = $00000100;
    { The string identifies an Internet Host using DNS.
      (port or prefix or scope-id not allowed) }
  NET_STRING_NAMED_SERVICE         = $00000200;
    { The string identifies an Internet service using DNS.
      (port required; prefix or scope-id not allowed) }

  NET_STRING_IP_ADDRESS            = NET_STRING_IPV4_ADDRESS or
                                           NET_STRING_IPV6_ADDRESS;

  NET_STRING_IP_ADDRESS_NO_SCOPE   = NET_STRING_IPV4_ADDRESS or
                                           NET_STRING_IPV6_ADDRESS_NO_SCOPE;

  NET_STRING_IP_SERVICE            = NET_STRING_IPV4_SERVICE or
                                           NET_STRING_IPV6_SERVICE;

  NET_STRING_IP_SERVICE_NO_SCOPE   = NET_STRING_IPV4_SERVICE or
                                           NET_STRING_IPV6_SERVICE_NO_SCOPE;

  NET_STRING_IP_NETWORK            = NET_STRING_IPV4_NETWORK or
                                           NET_STRING_IPV6_NETWORK;

  NET_STRING_ANY_ADDRESS           = NET_STRING_NAMED_ADDRESS or
                                           NET_STRING_IP_ADDRESS;

  NET_STRING_ANY_ADDRESS_NO_SCOPE  = NET_STRING_NAMED_ADDRESS or
                                           NET_STRING_IP_ADDRESS_NO_SCOPE;

  NET_STRING_ANY_SERVICE           = NET_STRING_NAMED_SERVICE or
                                           NET_STRING_IP_SERVICE;

  NET_STRING_ANY_SERVICE_NO_SCOPE  = NET_STRING_NAMED_SERVICE or
                                           NET_STRING_IP_SERVICE_NO_SCOPE;

type
  TNetAddressFormat = (
    NET_ADDRESS_FORMAT_UNSPECIFIED = 0,
    NET_ADDRESS_DNS_NAME,
    NET_ADDRESS_IPV4,
    NET_ADDRESS_IPV6);

const
  DNS_MAX_NAME_BUFFER_LENGTH = 256;
  
type
  PNetAddressInfo = ^TNetAddressInfo;
  TNetAddressInfo = record
    Format: TNetAddressFormat;
    case Integer of
      0: (NamedAddress: record
            Address: array[0..DNS_MAX_NAME_BUFFER_LENGTH - 1] of WCHAR;
            Port: array[0..5] of WCHAR;
          end);
      1: (Ipv4Address: TSockAddrIn);
      2: (Ipv6Address: TSockAddrIn6);
      3: (IpAddress: TSockAddr);
  end;

function ParseNetworkString(const NetworkString: PWCHAR; Types: DWORD;
  AddressInfo: PNetAddressInfo = nil; PortNumber: PWord = nil;
  PrefixLength: PByte = nil): DWORD; stdcall;

{ Routine Name:

      IcmpCreateFile

  Routine Description:

      Opens a handle on which ICMP Echo Requests can be issued.

  Arguments:

      None.

  Return Value:

      An open file handle or INVALID_HANDLE_VALUE. Extended error information
      is available by calling GetLastError(). }

function IcmpCreateFile: THandle; stdcall;

{ Routine Name:

      Icmp6CreateFile

  Routine Description:

      Opens a handle on which ICMPv6 Echo Requests can be issued.

  Arguments:

      None.

  Return Value:

      An open file handle or INVALID_HANDLE_VALUE. Extended error information
      is available by calling GetLastError(). }

function Icmp6CreateFile: THandle; stdcall;

{ Routine Name:

      IcmpCloseHandle

  Routine Description:

      Closes a handle opened by ICMPOpenFile.

  Arguments:

      IcmpHandle  - The handle to close.

  Return Value:

      TRUE if the handle was closed successfully, otherwise FALSE. Extended
      error information is available by calling GetLastError(). }

function IcmpCloseHandle(IcmpHandle: THandle): BOOL; stdcall;

{ Routine Name:

      IcmpSendEcho

  Routine Description:

      Sends an ICMP Echo request and returns any replies. The
      call returns when the timeout has expired or the reply buffer
      is filled.

  Arguments:

      IcmpHandle           - An open handle returned by ICMPCreateFile.

      DestinationAddress   - The destination of the echo request.

      RequestData          - A buffer containing the data to send in the
                             request.

      RequestSize          - The number of bytes in the request data buffer.

      RequestOptions       - Pointer to the IP header options for the request.
                             May be NULL.

      ReplyBuffer          - A buffer to hold any replies to the request.
                             On return, the buffer will contain an array of
                             ICMP_ECHO_REPLY structures followed by the
                             options and data for the replies. The buffer
                             should be large enough to hold at least one
                             ICMP_ECHO_REPLY structure plus
                             MAX(RequestSize, 8) bytes of data since an ICMP
                             error message contains 8 bytes of data.

      ReplySize            - The size in bytes of the reply buffer.

      Timeout              - The time in milliseconds to wait for replies.

  Return Value:

      Returns the number of ICMP_ECHO_REPLY structures stored in ReplyBuffer.
      The status of each reply is contained in the structure. If the return
      value is zero, extended error information is available via
      GetLastError(). }

function IcmpSendEcho(IcmpHandle: THandle; DestinationAddress: TIpAddr;
  RequestData: Pointer; RequestSize: Word; RequestOptions: PIpOptionInformation;
  ReplyBuffer: Pointer; ReplySize: DWORD; Timeout: DWORD): DWORD; stdcall;

{ Routine Description:

     Sends an ICMP Echo request and the call returns either immediately
     (if Event or ApcRoutine is NonNULL) or returns after the specified
     timeout.   The ReplyBuffer contains the ICMP responses, if any.

  Arguments:

     IcmpHandle           - An open handle returned by ICMPCreateFile.

     Event                - This is the event to be signalled whenever an IcmpResponse
                            comes in.

     ApcRoutine           - This routine would be called when the calling thread
                            is in an alertable thread and an ICMP reply comes in.

     ApcContext           - This optional parameter is given to the ApcRoutine when
                            this call succeeds.

     DestinationAddress   - The destination of the echo request.

     RequestData          - A buffer containing the data to send in the
                            request.

     RequestSize          - The number of bytes in the request data buffer.

     RequestOptions       - Pointer to the IP header options for the request.
                            May be NULL.

     ReplyBuffer          - A buffer to hold any replies to the request.
                            On return, the buffer will contain an array of
                            ICMP_ECHO_REPLY structures followed by options
                            and data. The buffer must be large enough to
                            hold at least one ICMP_ECHO_REPLY structure.
                            It should be large enough to also hold
                            8 more bytes of data - this is the size of
                            an ICMP error message.

     ReplySize            - The size in bytes of the reply buffer.

     Timeout              - The time in milliseconds to wait for replies.
                            This is NOT used if ApcRoutine is not NULL or if Event
                            is not NULL.

  Return Value:

     Returns the number of replies received and stored in ReplyBuffer. If
     the return value is zero, extended error information is available
     via GetLastError().

  Remarks:

     On NT platforms,
     If used Asynchronously (either ApcRoutine or Event is specified), then
     ReplyBuffer and ReplySize are still needed.  This is where the response
     comes in.
     ICMP Response data is copied to the ReplyBuffer provided, and the caller of
     this function has to parse it asynchronously.  The function IcmpParseReply
     is provided for this purpose.

     On non-NT platforms,
     Event, ApcRoutine and ApcContext are IGNORED. }

function IcmpSendEcho2(IcmpHandle, Event: THandle; ApcRoutine: TIoApcRoutine;
  ApcContext: Pointer; DestinationAddress: TIpAddr; RequestData: Pointer;
  RequestSize: Word; RequestOptions: PIpOptionInformation; ReplyBuffer: Pointer;
  ReplySize, Timeout: DWORD): DWORD; stdcall;
function IcmpSendEcho2Ex(IcmpHandle, Event: THandle; ApcRoutine: TIoApcRoutine;
  ApcContext: Pointer; SourceAddress, DestinationAddress: TIpAddr; RequestData: Pointer;
  RequestSize: Word; RequestOptions: PIpOptionInformation; ReplyBuffer: Pointer;
  ReplySize, Timeout: DWORD): DWORD; stdcall;
function Icmp6SendEcho2(IcmpHandle, Event: THandle; ApcRoutine: TIoApcRoutine;
  ApcContext: Pointer; SourceAddress, DestinationAddress: PSockAddrIn6;
  RequestData, RequestSize: Word; RequestOptions: PIpOptionInformation;
  ReplyBuffer: Pointer; ReplySize, Timeout: DWORD): DWORD; stdcall;

{ Routine Description:

     Parses the reply buffer provided and returns the number of ICMP responses found.

  Arguments:

     ReplyBuffer            - This must be the same buffer that was passed to IcmpSendEcho2
                              This is rewritten to hold an array of ICMP_ECHO_REPLY structures.
                              (i.e. the type is PICMP_ECHO_REPLY).

     ReplySize              - This must be the size of the above buffer.

  Return Value:
     Returns the number of ICMP responses found.  If there is an errors, return value is
     zero.  The error can be determined by a call to GetLastError.

  Remarks:
     This function SHOULD NOT BE USED on a reply buffer that was passed to SendIcmpEcho.
     SendIcmpEcho actually parses the buffer before returning back to the user.  This function
     is meant to be used only with SendIcmpEcho2. }

function IcmpParseReplies(ReplyBuffer: Pointer; ReplySize: DWORD): DWORD; stdcall;
function Icmp6ParseReplies(ReplyBuffer: Pointer; ReplySize: DWORD): DWORD; stdcall;

type
  NETIOAPI_API = DWORD;

  PMibNotificationType = ^TMibNotificationType;
  TMibNotificationType = (
    MibParameterNotification, { ParameterChange. }
    MibAddInstance,           { Addition. }
    MibDeleteInstance,        { Deletion. }
    MibInitialNotification);  { Initial notification. }

  TInterfaceAndOperStatus = (
    HardwareInterface,
    FilterInterface,
    ConnectorPresent,
    NotAuthenticated,
    NotMediaConnected,
    Paused,
    LowPower,
    EndPointInterface);

  TInterfaceAndOperStatusFlags = set of TInterfaceAndOperStatus;

  PMibIfRow2 = ^TMibIfRow2;
  TMibIfRow2 = record
    InterfaceLuid: TNetLuid;
    InterfaceIndex: TNetIfIndex;
    InterfaceGuid: TGUID;
    Alias: array[0..IF_MAX_STRING_SIZE] of WCHAR;
    Description: array[0..IF_MAX_STRING_SIZE] of WCHAR;
    PhysicalAddressLength: ULONG;
    PhysicalAddress: array[0..IF_MAX_PHYS_ADDRESS_LENGTH - 1] of UCHAR;
    PermanentPhysicalAddress: array[0..IF_MAX_PHYS_ADDRESS_LENGTH - 1] of UCHAR;
    Mtu: ULONG;
    IfType: TIfType;          { Interface Type. }
    TunnelType: TTunnelType;  { Tunnel Type, if Type = IF_TUNNEL. }
    MediaType: TNdisMedium;
    PhysicalMediumType: TNdisPhysicalMedium;
    AccessType: TNetIfAccessType;
    DirectionType: TNetIfDirectionType;
    InterfaceAndOperStatusFlags: TInterfaceAndOperStatusFlags;
    OperStatus: TIfOperStatus;
    AdminStatus: TNetIfAdminStatus;
    MediaConnectState: TNetIfMediaConnectState;
    NetworkGuid: TNetIfNetworkGuid;
    ConnectionType: TNetIfConnectionType;
    { Statistics. }
    TransmitLinkSpeed: UINT64;
    ReceiveLinkSpeed: UINT64;
    InOctets: UINT64;
    InUcastPkts: UINT64;
    InNUcastPkts: UINT64;
    InDiscards: UINT64;
    InErrors: UINT64;
    InUnknownProtos: UINT64;
    InUcastOctets: UINT64;
    InMulticastOctets: UINT64;
    InBroadcastOctets: UINT64;
    OutOctets: UINT64;
    OutUcastPkts: UINT64;
    OutNUcastPkts: UINT64;
    OutDiscards: UINT64;
    OutErrors: UINT64;
    OutUcastOctets: UINT64;
    OutMulticastOctets: UINT64;
    OutBroadcastOctets: UINT64;
    OutQLen: UINT64;
  end;

  PMibIfTable2 = ^TMibIfTable2;
  TMibIfTable2 = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibIfRow2;
  end;

function GetIfEntry2(Row: PMibIfRow2): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves information for the specified interface on the local computer.

  Arguments:

      Row - Supplies a MIB_IF_ROW2 structure with either the Luid or Index
          initialized to that of the interface for which to retrieve
          information.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1.  At least one of InterfaceLuid or InterfaceIndex must be specified.

      On output, the remaining fields of Row are filled in. }

function GetIfTable2(var Table: PMibIfTable2): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves the MIB-II interface table.

  Arguments:

      Table - Returns the table of interfaces in a MIB_IFTABLE2 structure.
          Use FreeMibTable to free this buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      The API allocates the buffer for Table.  Use FreeMibTable to free it. }

type
  PMibIfTableLevel = ^TMibIfTableLevel;
  TMibIfTableLevel = (
    MibIfTableNormal,
    MibIfTableRaw);

function GetIfTable2Ex(Level: TMibIfTableLevel; var Table: PMibIfTable2): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves the MIB-II interface table.

  Arguments:

      Table - Returns the table of interfaces in a MIB_IFTABLE2 structure.
          Use FreeMibTable to free this buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      The API allocates the buffer for Table.  Use FreeMibTable to free it. }

{ IpInterface management routines. }

{ The MIB structure for Network layer Interface management routines. }

type
  PMibIpInterfaceRow = ^TMibIpInterfaceRow;
  TMibIpInterfaceRow = record
    { Key Structure; }
    Family: TAddressFamily;
    InterfaceLuid: TNetLuid;
    InterfaceIndex: TNetIfIndex;
    { Read-Write fields.  
      Fields currently not exposed. }
    MaxReassemblySize: ULONG;
    InterfaceIdentifier: UINT64;
    MinRouterAdvertisementInterval: ULONG;
    MaxRouterAdvertisementInterval: ULONG;
    { Fileds currently exposed. }
    AdvertisingEnabled: Boolean;
    ForwardingEnabled: Boolean;
    WeakHostSend: Boolean;
    WeakHostReceive: Boolean;
    UseAutomaticMetric: Boolean;
    UseNeighborUnreachabilityDetection: Boolean;
    ManagedAddressConfigurationSupported: Boolean;
    OtherStatefulConfigurationSupported: Boolean;
    AdvertiseDefaultRoute: Boolean;
    RouterDiscoveryBehavior: TNlRouterDiscoveryBehavior;
    DadTransmits: ULONG;                 { DupAddrDetectTransmits in RFC 2462. }
    BaseReachableTime: ULONG;
    RetransmitTime: ULONG;
    PathMtuDiscoveryTimeout: ULONG;      { Path MTU discovery timeout (in ms). }
    LinkLocalAddressBehavior: TNlLinkLocalAddressBehavior;
    LinkLocalAddressTimeout: ULONG;      { In ms. }
    ZoneIndices: array[0.. 15] of ULONG; { Zone part of a SCOPE_ID. }
    SitePrefixLength: ULONG;
    Metric: ULONG;
    NlMtu: ULONG;
    { Read Only fields. }
    Connected: Boolean;
    SupportsWakeUpPatterns: Boolean;
    SupportsNeighborDiscovery: Boolean;
    SupportsRouterDiscovery: Boolean;
    ReachableTime: ULONG;
    TransmitOffload: TNlInterfaceOffloadRod;
    ReceiveOffload: TNlInterfaceOffloadRod;
    { Disables using default route on the interface. This flag
      can be used by VPN clients to restrict Split tunnelling. }
    DisableDefaultRoutes: Boolean;
  end;

  PMibIpInterfaceTable = ^TMibIpInterfaceTable;
  TMibIpInterfaceTable = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibIpInterfaceRow;
  end;

  PMibIfStackRow = ^TMibIfStackRow;
  TMibIfStackRow = record
    HigherLayerInterfaceIndex: TNetIfIndex;
    LowerLayerInterfaceIndex: TNetIfIndex;
  end;

  PMibInvertedIfStackRow = ^TMibInvertedIfStackRow;
  TMibInvertedIfStackRow = record
    LowerLayerInterfaceIndex: TNetIfIndex;
    HigherLayerInterfaceIndex: TNetIfIndex;
  end;

  PMibIfStackTable = ^TMibIfStackTable;
  TMibIfStackTable = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibIfStackRow;
  end;

  PMibInvertedIfStackTable = ^TMibInvertedIfStackTable;
  TMibInvertedIfStackTable = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibInvertedIfStackRow;
  end;

  TIpInterfaceChangeCallback = procedure(CallerContext: Pointer;
    Row: PMibIpInterfaceRow; NotificationType: TMibNotificationType); stdcall;

function GetIfStackTable(var Table: PMibIfStackTable): NETIOAPI_API; stdcall;
function GetInvertedIfStackTable(var Table: PMibInvertedIfStackTable): NETIOAPI_API; stdcall;
function GetIpInterfaceEntry(Row: PMibIpInterfaceRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves IP information for the specified interface on the local computer.

  Arguments:

      Row - Supplies a MIB_IPINTERFACE_ROW structure with either the Luid or
          Index initialized to that of the interface for which to retrieve
          information.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. Family: it must be either AF_INET or AF_INET6
      2. At least one of InterfaceLuid or InterfaceIndex must be specified.

      On output, the remaining fields of Row are filled in. }

function GetIpInterfaceTable(Family: TAddressFamily;
  var Table: PMibIpInterfaceTable): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves the network-layer interface table.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only returns IPv4 MIB entries.

          AF_INET6: Only returns IPv6 MIB entries.

          AF_UNSPEC: Returns both IPv4 and IPv6 MIB entries.

      Table - Returns the table of interfaces in a MIB_IPINTERFACE_TABLE
          structure.  Use FreeMibTable to free this buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      The API allocates the buffer for Table.  Use FreeMibTable to free it. }

function InitializeIpInterfaceEntry(Row: PMibIpInterfaceRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Initialize the MIB_IPINTERFACE_ROW entry for use in SetIpInterfaceRow.

  Arguments:

      Row - Returns an initialized MIB_IPINTERFACE_ROW structure.

  Return Value:

      None.

  Notes:

      InitializeIpInterfaceEntry must be used to initialize the fields of
      MIB_IPINTERFACE_ROW with default values.  The caller can then update the
      fields it wishes to modify and invoke SetIpInterfaceEntry. }

function NotifyIpInterfaceChange(Family: TAddressFamily;
  Callback: TIpInterfaceChangeCallback; CallerContext: Pointer;
  InitialNotification: Boolean; NotificationHandle: PHandle): NETIOAPI_API; stdcall;

{ Routine Description:

      Register for notification for IP interface changes.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only register for IPv4 change notifications.

          AF_INET6: Only register for IPv6 change notifications.

          AF_UNSPEC: Register for both IPv4 and IPv6 change notifications.

      Callback - Supplies a callback function.  This function will be invoked
          when an interface notification is received.

      CallerContext - Provides the user specific caller context.  This context
          will be supplied to the callback function.

      InitialNotification - Supplies a boolean to indicate whether an
          initialization notification should be provided.

      NotificationHandle - Returns a handle to the notification registration.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      1. Invokation of the callback function is serialized.

      2. Use CancelMibChangeNotify2 to deregister for change notifications. }

function SetIpInterfaceEntry(Row: PMibIpInterfaceRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Set the properties of an IP interface.

  Arguments:

      Row - Supplies a MIB_IPINTERFACE_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      InitializeIpInterfaceEntry must be used to initialize the fields of
      MIB_IPINTERFACE_ROW with default values.  The caller can then update the
      fields it wishes to modify and invoke SetIpInterfaceEntry.

      On input, the following key fields of Row must be initialized after
      invoking InitializeIpInterfaceEntry:
      1. Family: To AF_INET or AF_INET6.
      2. At least one of InterfaceLuid or InterfaceIndex must be specified. }

{ Unicast address management routines. }

{ The structure for unicast IP Address management. }

type
  PMibUnicastIpAddressRow = ^TMibUnicastIpAddressRow;
  TMibUnicastIpAddressRow = record
    { Key Structure. }
    Address: TSockAddrInet;
    InterfaceLuid: TNetLuid;
    InterfaceIndex: TNetIfIndex;
    { Read-Write Fileds. }
    PrefixOrigin: TNlPrefixOrigin;
    SuffixOrigin: TNlSuffixOrigin;
    ValidLifetime: ULONG;
    PreferredLifetime: ULONG;
    OnLinkPrefixLength: Byte;
    SkipAsSource: Boolean;
    { Read-Only Fields. }
    DadState: TNlDadState;
    ScopeId: TScopeId;
    CreationTimeStamp: LARGE_INTEGER;
  end;

  PMibUnicastIpAddressTable = ^TMibUnicastIpAddressTable;
  TMibUnicastIpAddressTable = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibUnicastIpAddressRow;
  end;

  TUnicastIpAddressChangeCallback = procedure(CallerContext: Pointer;
    Row: PMibUnicastIpAddressRow; NotificationType: TMibNotificationType); stdcall;

function CreateUnicastIpAddressEntry(const Row: PMibUnicastIpAddressRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Create a unicast IP address entry on the local computer.

  Arguments:

      Row - Supplies a MIB_UNICASTIPADDRESS_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      InitializeUnicastIpAddressEntry must be used to initialize the fields of
      MIB_UNICASTIPADDRESS_ROW with default values.  The caller can then update
      the fields it wishes to modify and invoke CreateIpInterfaceEntry.

      On input, the following key fields of Row must be initialized after
      invoking InitializeUnicastIpAddressEntry:
      1. Address to a valid IPv4 or IPv6 unicast address.
      2. At least one of InterfaceLuid or InterfaceIndex must be specified. }

function DeleteUnicastIpAddressEntry(const Row: PMibUnicastIpAddressRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Delete a unicast IP address entry on the local computer.

  Arguments:

      Row - Supplies a MIB_UNICASTIPADDRESS_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. Address to a valid IPv4 or IPv6 unicast address.
      2. At least one of InterfaceLuid or InterfaceIndex must be specified. }

function GetUnicastIpAddressEntry(Row: PMibUnicastIpAddressRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves information for the specified unicast IP address entry on the
          local computer.

  Arguments:

      Address - Supplies a MIB_UNICASTIPADDRESS_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. Address to a valid IPv4 or IPv6 unicast address.
      2. At least one of InterfaceLuid or InterfaceIndex must be specified.

      On output, the remaining fields of Row are filled in. }

function GetUnicastIpAddressTable(Family: TAddressFamily;
  var Table: PMibUnicastIpAddressTable): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves the unicast IP address table on a local computer.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only returns IPv4 unicast addresses.

          AF_INET6: Only returns IPv6 unicast addresses.

          AF_UNSPEC: Returns both IPv4 and IPv6 unicast addresses.

      Table - Returns the table of unicast IP addresses in a
          MIB_UNICASTIPADDRESS_TABLE Structure.  Use FreeMibTable to free this
          buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      The API allocates the buffer for Table.  Use FreeMibTable to free it. }

procedure InitializeUnicastIpAddressEntry(Row: PMibUnicastIpAddressRow); stdcall;

{ Routine Description:

      Initialize the MIB_UNICASTIPADDRESS_ROW entry for use in
      CreateUnicastIpAddressEntry and SetUnicastIpAddressEntry.

  Arguments:

      Address - Returns an initialized MIB_UNICASTIPADDRESS_ROW structure.

  Return Value:

      None.

  Notes:

      InitializeUnicastIpAddressEntry must be used to initialize the fields of
      MIB_UNICASTIPADDRESS_ROW with default values.  The caller can then update
      the fields it wishes to modify and invoke CreateUnicastIpAddressEntry or
      SetUnicastIpAddressEntry. }

function NotifyUnicastIpAddressChange(Family: TAddressFamily;
  Callback: TUnicastIpAddressChangeCallback; CallerContext: Pointer;
  InitialNotification: Boolean; NotificationHandle: PHandle): NETIOAPI_API; stdcall;

{ Routine Description:

      Register for notification for unicast IP address changes.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only register for IPv4 change notifications.

          AF_INET6: Only register for IPv6 change notifications.

          AF_UNSPEC: Register for both IPv4 and IPv6 change notifications.

      Callback - Supplies a callback function.  This function will be invoked
          when an unicast IP address notification is received.

      CallerContext - Provides the user specific caller context.  This context
          will be supplied to the callback function.

      InitialNotification - Supplies a boolean to indicate whether an
          initialization notification should be provided.

      NotificationHandle - Returns a handle to the notification registration.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      1. Invokation of the callback function is serialized.

      2. Use CancelMibChangeNotify2 to deregister for change notifications. }

type
  TStableUnicastIpAddressTableCallback = procedure(CallerContext: Pointer;
    AddressTable: PMibUnicastIpAddressTable); stdcall;

function NotifyStableUnicastIpAddressTable(Family: TAddressFamily;
  var Table: PMibUnicastIpAddressTable; CallerCallback: TStableUnicastIpAddressTableCallback;
  CallerContext: Pointer; NotificationHandle: PHandle): NETIOAPI_API; stdcall;
function SetUnicastIpAddressEntry(const Row: PMibUnicastIpAddressRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Set the properties of an unicast IP address.

  Arguments:

      Address - Supplies a MIB_UNICASTIPADDRESS_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      InitializeUnicastIpAddressEntry must be used to initialize the fields of
      MIB_UNICASTIPADDRESS_ROW with default values.  The caller can then update
      the fields it wishes to modify and invoke SetUnicastIpAddressEntry.

      On input, the following key fields of Row must be initialized after
      invoking InitializeUnicastIpAddressEntry:
      1. Address to a valid IPv4 or IPv6 unicast address.
      2. At least one of InterfaceLuid or InterfaceIndex must be specified. }

{ Anycast address management routines. }

type
  PMibAnycastIpAddressRow = ^TMibAnycastIpAddressRow;
  TMibAnycastIpAddressRow = record
    { Key Structure. }
    Address: TSockAddrInet;
    InterfaceLuid: TNetLuid;
    InterfaceIndex: TNetIfIndex;
    { Read-Only Fields. }
    ScopeId: TScopeId;
  end; 

  PMibAnycastIpAddressTable = ^TMibAnycastIpAddressTable;
  TMibAnycastIpAddressTable = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibAnycastIpAddressRow;
  end;

function CreateAnycastIpAddressEntry(const Row: PMibAnycastIpAddressRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Create an anycast IP address entry on the local computer.

  Arguments:

      Address - Supplies a MIB_ANYCASTIPADDRESS_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. Address to a valid IPv4 or IPv6 anycast address.
      2. At least one of InterfaceLuid or InterfaceIndex must be specified. }

function DeleteAnycastIpAddressEntry(const Row: PMibAnycastIpAddressRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Delete an anycast IP address entry on the local computer.

  Arguments:

      Address - Supplies a MIB_ANYCASTIPADDRESS_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. Address to a valid IPv4 or IPv6 anycast address.
      2. At least one of InterfaceLuid or InterfaceIndex must be specified. }

function GetAnycastIpAddressEntry(Row: PMibAnycastIpAddressRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves information for the specified anycast IP address entry on the
      local computer.

  Arguments:

      Address - Supplies a MIB_ANYCASTIPADDRESS_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. Address to a valid IPv4 or IPv6 anycast address.
      2. At least one of InterfaceLuid or InterfaceIndex must be specified.

      On output, the remaining fields of Row are filled in. }

function GetAnycastIpAddressTable(Family: TAddressFamily;
  var Table: PMibAnycastIpAddressTable): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves the anycast IP address table.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only returns IPv4 anycast addresses.

          AF_INET6: Only returns IPv6 anycast addresses.

          AF_UNSPEC: Returns both IPv4 and IPv6 anycast addresses.

      Table - Returns the table of anycast IP addresses in a
          MIB_ANYCASTIPADDRESS_TABLE Structure.  Use FreeMibTable to free this
          buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      The API allocates the buffer for Table.  Use FreeMibTable to free it. }

{ Multicast address management routines. }

type
  PMibMulticastIpAddressRow = ^TMibMulticastIpAddressRow;
  TMibMulticastIpAddressRow = record
    { Key Structure. }
    Address: TSockAddrInet;
    InterfaceIndex: TNetIfIndex;
    InterfaceLuid: TNetLuid;
    { Read-Only Fields. }
    ScopeId: TScopeId;
  end;

  PMibMulticastIpAddressTable = ^TMibMulticastIpAddressTable;
  TMibMulticastIpAddressTable = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibMulticastIpAddressRow;
  end;


function GetMulticastIpAddressEntry(Row: PMibMulticastIpAddressRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves information for the specified mulitcast IP address entry on the
      local computer.

  Arguments:

      Row - Supplies a MIB_MULTICASTIPADDRESS_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized.
      1. Address to a valid IPv4 or IPv6 multicast address.
      2. At least one of InterfaceLuid or InterfaceIndex must be specified.

      On output, the remaining fields of Row are filled in. }

function GetMulticastIpAddressTable(Family: TAddressFamily;
  var Table: PMibMulticastIpAddressTable): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves the multicast IP address table on the local computer.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only returns IPv4 multicast addresses.

          AF_INET6: Only returns IPv6 multicast addresses.

          AF_UNSPEC: Returns both IPv4 and IPv6 multicast addresses.

      Table - Returns the table of multicast IP addresses in a
          MIB_MULTICASTIPADDRESS_TABLE Structure.  Use FreeMibTable to free this
          buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      The API allocates the buffer for Table.  Use FreeMibTable to free it. }

{ Route management routines. }

type
  PIpAddressPrefix = ^TIpAddressPrefix;
  TIpAddressPrefix = record
    Prefix: TSockAddrInet;
    PrefixLength: Byte;
  end;

  PMibIpForwardRow2 = ^TMibIpForwardRow2;
  TMibIpForwardRow2 = record
    { Key Structure. }
    InterfaceLuid: TNetLuid;
    InterfaceIndex: TNetIfIndex;
    DestinationPrefix: TIpAddressPrefix;
    NextHop: TSockAddrInet;
    { Read-Write Fields. }
    SitePrefixLength: UCHAR;
    ValidLifetime: ULONG;
    PreferredLifetime: ULONG;
    Metric: ULONG;
    Protocol: TNlRouteProtocol;
    Loopback: Boolean;
    AutoconfigureAddress: Boolean;
    Publish: Boolean;
    Immortal: Boolean;
    { Read-Only Fields. }
    Age: ULONG;
    Origin: TNlRouteOrigin;
  end;

  PMibIpForwardTable2 = ^TMibIpForwardTable2;
  TMibIpForwardTable2 = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibIpForwardRow2;
  end;

  TIpForwardChangeCallback = procedure(CallerContext: Pointer;
    Row: PMibIpForwardRow2; NotificationType: TMibNotificationType); stdcall;

function CreateIpForwardEntry2(const Row: PMibIpForwardRow2): NETIOAPI_API; stdcall;

{ Routine Description:

      Create a route on the local computer.

  Arguments:

      Row - Supplies a MIB_IPFORWARD_ROW2 structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      InitializeIpForwardEntry must be used to initialize the fields of
      MIB_IPFORWARD_ROW2 with default values.  The caller can then update the
      fields it wishes to modify and invoke CreateIpForwardEntry2.

      On input, the following key fields of Row must be initialized after
      invoking InitializeIpForwardEntry:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. DestinationPrefix.
      3. NextHop. }

function DeleteIpForwardEntry2(const Row: PMibIpForwardRow2): NETIOAPI_API; stdcall;

{ Routine Description:

      Delete a route on the local computer.

  Arguments:

      Row - Supplies a MIB_IPFORWARD_ROW2 structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. DestinationPrefix.
      3. NextHop. }

function GetBestRoute2(InterfaceLuid: PNetLuid; InterfaceIndex: TNetIfIndex;
  const SourceAddress, DestinationAddress: PSockAddrInet; AddressSortOptions: ULONG;
  BestRoute: PMibIpForwardRow2; BestSourceAddress: PSockAddrInet): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieve the best route between source and destination address on a local
          computer.

  Arguments:

      InterfaceLuid - Supplies Luid to specify an interface.

      InterfaceIndex - Supplies Index to specify an interface.

      SourceAddress - Supplies source address.

      DestinationAddress - Supplies destination address.

      AddressSortOptions - Supplies AddressSortOptions.

      BestRoute - Returns the MIB structure that holds the best route.

      BestSourceAddress - Returns the source address of the best route.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following parameters must be supplied:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. SourceAddress.
      3. DestinationAddress. }

function GetIpForwardEntry2(Row: PMibIpForwardRow2): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves information for the specified route entry on the local computer.

  Arguments:

      Route - Supplies a MIB_IPFORWARD_ROW2 structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. DestinationPrefix and NextHop can be specified.

      On output, the remaining fields of Row are filled in.

      If one or more routes matches the specified criteria,
      this API matches the first entry. }

function GetIpForwardTable2(Family: TAddressFamily;
  var Table: PMibIpForwardTable2): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves the route table on a local computer.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only returns IPv4 route entries.

          AF_INET6: Only returns IPv6 route entries.

          AF_UNSPEC: Returns both IPv4 and IPv6 route entries.

      Table - Returns the table of routes in a MIB_IPFORWARD_TABLE2 Structure.
          Use FreeMibTable to free this buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      The API allocates the buffer for Table.  Use FreeMibTable to free it. }

procedure InitializeIpForwardEntry(Row: PMibIpForwardRow2); stdcall;

{ Routine Description:

      Initialize the MIB_IPFORWARD_ROW2 entry for use in SetIpForwardEntry2.

  Arguments:

      Row - Returns an initialized PMIB_IPFORWARD_ROW2 structure.

  Return Value:

      None.

  Notes:

      InitializeIpForwardEntry must be used to initialize the fields of
          MIB_IPFORWARD_ROW2 with default values.  The caller can then update the
          fields it wishes to modify and invoke SetIpForwardEntry2. }

function NotifyRouteChange2(AddressFamily: TAddressFamily;
  Callback: TIpForwardChangeCallback; CallerContext: Pointer;
  InitialNotification: Boolean; NotificationHandle: PHandle): NETIOAPI_API; stdcall;

{ Routine Description:

      Register for notification for route changes.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only register for IPv4 route change notifications.

          AF_INET6: Only register for IPv6 route change notifications.

          AF_UNSPEC: Register for both IPv4 and IPv6 route change notifications.

      Callback - Supplies a callback function. This function will be invoked when
          an unicast IP address notification is received.

      CallerContext - Provides the user specific caller context. This context
          will be supplied to the callback function.

      InitialNotification - Supplies a boolean to indicate whether an
          initialization notification should be provided.

      NotificationHandle - Returns a handle to the notification registration.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      1. Invokation of the callback function is serialized.

      2. Use CancelMibChangeNotify2 to deregister for change notifications. }

function SetIpForwardEntry2(const Route: PMibIpForwardRow2): NETIOAPI_API; stdcall;

{ Routine Description:

      Set the properties of a route entry.

  Arguments:

      Route - Supplies a MIB_UNICASTIPADDRESS_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      InitializeIpForwardEntry must be used to initialize the fields of
      MIB_IPFORWARD_ROW2 with default values.  The caller can then update the
      fields it wishes to modify and invoke SetIpForwardEntry2.

      On input, the following key fields of Row must be initialized after
      invoking InitializeIpForwardEntry:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. DestinationPrefix.
      3. NextHop. }

{ Path management routines. }

type
  PMibIpPathRow = ^TMibIpPathRow;
  TMibIpPathRow = record
    { Key. }
    Source: TSockAddrInet;
    Destination: TSockAddrInet;
    InterfaceLuid: TNetLuid;
    InterfaceIndex: TNetIfIndex;
    { The current next hop.  This can change over the lifetime of a path. }
    CurrentNextHop: TSockAddrInet;
    { MTU of path to destination. Includes the IP header length. }
    PathMtu: ULONG;
    { Estimated mean RTT. }
    RttMean: ULONG;
    { Mean deviation of RTT. }
    RttDeviation: ULONG;
    case Integer of
      0: (LastReachable: ULONG);  { Milliseconds. }
      1: (LastUnreachable: ULONG; { Milliseconds. }
          IsReachable: Boolean;
          { Estimated speed. }
          LinkTransmitSpeed: UINT64;
          LinkReceiveSpeed: UINT64);
  end;

  PMibIpPathTable = ^TMibIpPathTable;
  TMibIpPathTable = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibIpPathRow;
  end;

function FlushIpPathTable(Family: TAddressFamily): NETIOAPI_API; stdcall;

{ Routine Description:

      Flush the IP Path table on the local computer.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only flush the IPv4 path table.

          AF_INET6: Only flush the IPv6 path table.

          AF_UNSPEC: Flush both IPv4 and IPv6 path table.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function GetIpPathEntry(Row: PMibIpPathRow): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves information for the specified path entry on the local computer.

  Arguments:

      Row - Supplies a MIB_IPPATH_ROW structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. Source.
      3. Destination.

      On output, the remaining fields of Row are filled in. }

function GetIpPathTable(Family: TAddressFamily;
  var Table: PMibIpPathTable): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves the path table on a local computer.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only returns IPv4 paths.

          AF_INET6: Only returns IPv6 paths.

          AF_UNSPEC: Returns both IPv4 and IPv6 paths.

      Table - Returns the table of paths in a MIB_IPPATH_TABLE
          structure.  Use FreeMibTable to free this buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      The API allocates the buffer for Table.  Use FreeMibTable to free it. }

{ ARP and IPv6 Neighbor management routines. }

type
  PMibIpNetRow2 = ^TMibIpNetRow2;
  TMibIpNetRow2 = record
    { Key Struture. }
    Address: TSockAddrInet;
    InterfaceIndex: TNetIfIndex;
    InterfaceLuid: TNetLuid;
    { Read-Write. }
    PhysicalAddress: array[0..IF_MAX_PHYS_ADDRESS_LENGTH - 1] of UCHAR;
    { Read-Only. }
    PhysicalAddressLength: ULONG;
    State: TNlNeighborState;
    Flags: UCHAR;
    ReachabilityTime: record
      case Integer of
        0: (LastReachable: ULONG);
        1: (LastUnreachable: ULONG);
    end;
  end;

  PMibIpNetTable2 = ^TMibIpNetTable2;
  TMibIpNetTable2 = record
    NumEntries: ULONG;
    Table: array[0..ANY_SIZE - 1] of TMibIpNetRow2;
  end;

function CreateIpNetEntry2(const Row: PMibIpNetRow2): NETIOAPI_API; stdcall;

{ Routine Description:

      Create a neighbor entry on the local computer.

  Arguments:

      Row - Supplies a MIB_IPNET_ROW2 structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. Address.
      3. PhysicalAddress. }

function DeleteIpNetEntry2(const Row: PMibIpNetRow2): NETIOAPI_API; stdcall;

{ Routine Description:

      Delete a neighbor entry on the local computer.

  Arguments:

      Row - Supplies a MIB_IPNET_ROW2 structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. Address. }

function FlushIpNetTable2(Family: TAddressFamily;
  InterfaceIndex: TNetIfIndex): NETIOAPI_API; stdcall;

{ Routine Description:

      Flush the neighbor entry table on the local computer.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only flush the IPv4 neighbor table.

          AF_INET6: Only flush the IPv6 neighbor table.

          AF_UNSPEC: Flush both IPv4 and IPv6 neighbor table.

      InterfaceIndex - Supplies the Interface index.  If the index is specified,
          flush the neighbor entries on a specific interface, otherwise flush the
          neighbor entries on all the interfaces.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function GetIpNetEntry2(Row: PMibIpNetRow2): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves information for the specified neighbor entry on the local
      computer.

  Arguments:

      Row - Supplies a MIB_IPNET_ROW2 structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. Address.

      On output, the remaining fields of Row are filled in. }

function GetIpNetTable2(Family: TAddressFamily;
  var Table: PMibIpNetTable2): NETIOAPI_API; stdcall;

{ Routine Description:

      Retrieves the neighbor table on the local computer.

  Arguments:

      Family - Supplies the address family.

          AF_INET: Only returns IPv4 neighbor entries.

          AF_INET6: Only returns IPv6 neighbor entries.

          AF_UNSPEC: Returns both IPv4 and IPv6 neighbor entries.

      Table - Returns the table of neighbor entries in a MIB_IPNET_TABLE2
          structure.  Use FreeMibTable to free this buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      The API allocates the buffer for Table.  Use FreeMibTable to free it. }

function ResolveIpNetEntry2(Row: PMibIpNetRow2;
  const SourceAddress: PSockAddrInet = nil): NETIOAPI_API; stdcall;

{ Routine Description:

      Resolve the physical address of a specific neighbor.

  Arguments:

      NetEntry - Supplies a MIB_IPNET_ROW2 structure.

      SourceAddress - Supplies the source address.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      This API flushes any existing neighbor entry and resolves the MAC address
      by sending ARP requests (IPv4) or Neighbor Solicitation (IPv6).
      If source address is not provided, the API will automatically select the
      best interface to send the request on.

      On input, the following key fields of Row must be initialized:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. Address.

      On output, the remaining fields of Row are filled in. }

function SetIpNetEntry2(Row: PMibIpNetRow2): NETIOAPI_API; stdcall;

{ Routine Description:

      Set the physical address of a neighbor entry.

  Arguments:

      NetEntry - Supplies a MIB_IPNET_ROW2 structure.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      On input, the following key fields of Row must be initialized:
      1. At least one of InterfaceLuid or InterfaceIndex must be specified.
      2. Address.
      3. PhysicalAddress. }

{ Teredo APIs. }

const
  MIB_INVALID_TEREDO_PORT_NUMBER = 0;

type
  TTeredoPortChangeCallback = procedure(CallerContext: Pointer; Port: Word;
    NotificationType: TMibNotificationType); stdcall;

function NotifyTeredoPortChange(Callback: TTeredoPortChangeCallback;
  CallerContext: Pointer; InitialNotification: Boolean;
  NotificationHandle: PHandle): NETIOAPI_API; stdcall;

function GetTeredoPort(Port: PWord): NETIOAPI_API; stdcall;

{ Routine Description:

      Get the Teredo client port.

  Arguments:

      Port - returns the Teredo port.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

{ Generic (not IP-specific) interface definitions. }

function CancelMibChangeNotify2(NotificationHandle: THandle): NETIOAPI_API; stdcall;

{ Routine Description:

      Deregister for change notifications.

  Arguments:

      NotificationHandle - Supplies the handle returned from a notification
          registration.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure.

  Notes:

      Blocks until all callback have returned. }

procedure FreeMibTable(Memory: Pointer); stdcall;

{ Routine Description:

      Free the buffer allocated by Get*Table APIs.

  Arguments:

      Memory - Supplies the buffer to free.

  Return Value:

      None. }

function CreateSortedAddressPairs(const SourceAddressList: PSockAddrIn6;
  SourceAddressCount: ULONG; const DestinationAddressList: PSockAddrIn6;
  DestinationAddressCount, AddressSortOptions: ULONG;
  var SortedAddressPairList: PSockAddrIn6Pair;
  SortedAddressPairCount: PULONG): NETIOAPI_API; stdcall;

{ Routine Description:

      Given a list of source and destination addresses, returns a list of
      pairs of addresses in sorted order.  The list is sorted by which address
      pair is best suited for communication between two peers.

      The list of source addresses is optional, in which case the function
      automatically uses all the host machine's local addresses.

  Arguments:

      SourceAddressList - Supplies list of potential source addresses.
          If NULL the routine automatically uses all local addresses.
          IPv4 addresses can be specified in IPv4-mapped format.
          Reserved for future use.  Must be NULL.

      SourceAddressCount - Supplies the number of addresses in the
          SourceAddressList.
          Reserved for future use.  Must be 0.

      DestinationAddressList - Supplies list of potential destination addresses.
          IPv4 addresses can be specified in IPv4-mapped format.

      DestinationAddressCount -  Supplies the number of addresses in the
          DestinationAddressList.

      AddressSortOptions - Reserved for future use.  Must be 0.

      SortedAddressPairList - Returns a sorted list of pairs of addresses
          in prefered order of communication.  The list must be freed with a
          single call to NetioFreeMemory.

      SortedAddressPairCount - Returns the number of address pairs in
          SortedAddressPairList.

  Return Value:

      ERROR_SUCCESS on success.  WIN32 error code on error. }

function ConvertInterfaceNameToLuid(const InterfaceName: PWideChar;
  InterfaceLuid: PNetLuid): NETIOAPI_API; stdcall;
function ConvertInterfaceNameToLuidA(const InterfaceName: PAnsiChar;
  InterfaceLuid: PNetLuid): NETIOAPI_API; stdcall;
function ConvertInterfaceNameToLuidW(const InterfaceName: PWideChar;
  InterfaceLuid: PNetLuid): NETIOAPI_API; stdcall;

{ Routine Description:

      Convert an Interface Name to Luid.

  Arguments:

      InterfaceName - Supplies the interface name to be converted.

      InterfaceLuid - Returns the interface Luid.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function ConvertInterfaceLuidToName(const InterfaceLuid: PNetLuid;
  InterfaceName: PWideChar; Length: DWORD): NETIOAPI_API; stdcall;
function ConvertInterfaceLuidToNameA(const InterfaceLuid: PNetLuid;
  InterfaceName: PAnsiChar; Length: DWORD): NETIOAPI_API; stdcall;
function ConvertInterfaceLuidToNameW(const InterfaceLuid: PNetLuid;
  InterfaceName: PWideChar; Length: DWORD): NETIOAPI_API; stdcall;

{ Routine Description:

      Convert an Interface Luid to Name.

  Arguments:

      InterfaceLuid - Supplies the interface Luid to be converted.

      InterfaceName - Returns the interface name.

      Length - Supplies the length of the InterfaceName buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function ConvertInterfaceLuidToIndex(const InterfaceLuid: PNetLuid;
  InterfaceIndex: PNetIfIndex): NETIOAPI_API; stdcall;

{ Routine Description:

      Convert an Interface Luid to Index.

  Arguments:

      InterfaceLuid - Supplies the interface Luid to be converted.

      InterfaceName - Returns the interface Index.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function ConvertInterfaceIndexToLuid(InterfaceIndex: TNetIfIndex;
  InterfaceLuid: PNetLuid): NETIOAPI_API; stdcall;

{ Routine Description:

      Convert an Interface Index to Luid.

  Arguments:

      InterfaceName - Supplies the interface Index to be converted.

      InterfaceLuid - Returns the interface Luid.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function ConvertInterfaceLuidToAlias(const InterfaceLuid: PNetLuid;
  InterfaceAlias: PWideChar; Length: DWORD): NETIOAPI_API; stdcall;

{ Routine Description:

      Convert an Interface Luid to Alias.

  Arguments:

      InterfaceLuid - Supplies the interface Luid to be converted.

      InterfaceAlias - Returns the interface Alias.

      Length - Supplies the length of InterfaceAlias buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function ConvertInterfaceAliasToLuid(const InterfaceAlias: PWideChar;
  InterfaceLuid: PNetLuid): NETIOAPI_API; stdcall;

{ Routine Description:

      Convert an Interface Alias to Luid.

  Arguments:

      InterfaceAlias - Supplies the null terminated interface Alias.

      InterfaceLuid - Returns the interface Luid.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function ConvertInterfaceLuidToGuid(const InterfaceLuid: PNetLuid;
  InterfaceGuid: PGUID): NETIOAPI_API; stdcall;

{ Routine Description:

      Convert an Interface Luid to Guid.

  Arguments:

      InterfaceLuid - Supplies the interface Luid to be converted.

      InterfaceGuid - Returns the interface Guid.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function ConvertInterfaceGuidToLuid(const InterfaceGuid: PGUID;
  InterfaceLuid: PNetLuid): NETIOAPI_API; stdcall;

{ Routine Description:

      Convert an Interface Luid to Guid.

  Arguments:

      InterfaceGuid - Supplies the interface Guid to be converted.

      InterfaceGuid - Returns the interface Luid.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

const
  IF_NAMESIZE = IF_MAX_STRING_SIZE;

function if_nametoindex(const InterfaceName: PAnsiChar): TNetIfIndex; stdcall;

{ Routine Description:

      Convert an Interface name to Index.

  Arguments:

      InterfaceName - Supplies the null terminated interface name to convert.

  Return Value:

      Interface index on success, 0 otherwise. }


function if_indextoname(InterfaceIndex: TNetIfIndex;
  InterfaceName: PAnsiChar): PAnsiChar; stdcall;

{ Routine Description:

      Convert an Interface index to Name.

  Arguments:

      InterfaceIndex - Supplies the Interface index to convert.

      InterfaceName - Returns the null terminated interface name.

  Return Value:

      Interface name on success, NULL otherwise.

  Notes:

      The length of InterfaceName buffer must be equal to or greater than
          IF_NAMESIZE. }

function GetCurrentThreadCompartmentId: TNetIfCompartmentId; stdcall;

{ Routine Description:

      Get the compartment ID of current thread.

  Arguments:

      None.

  Return Value:

      The compartment ID of current thread. }

function SetCurrentThreadCompartmentId(
  CompartmentId: TNetIfCompartmentId): NETIOAPI_API; stdcall;

{ Routine Description:

      Set the compartment ID of current thread.

  Arguments:

      CompartmentId - Supplies the compartment ID to be set.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function GetSessionCompartmentId(SessionId: ULONG): TNetIfCompartmentId; stdcall;

{ Routine Description:

      Get the compartment ID of the session.

  Arguments:

      SessionId - Supplies the session ID.

  Return Value:

      The compartment ID of the session. }

function SetSessionCompartmentId(SessionId: ULONG;
  CompartmentId: TNetIfCompartmentId): NETIOAPI_API; stdcall;

{ Routine Description:

      Set the compartment ID of the session.

  Arguments:

      SessionId - Supplies the session ID.

      CompartmentId - Supplies the compartment ID to be set.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function GetNetworkInformation(const NetworkGuid: PNetIfNetworkGuid;
  CompartmentId: PNetIfCompartmentId; SiteId: PULONG; NetworkName: PWCHAR;
  Length: ULONG): NETIOAPI_API; stdcall;

{ Routine Description:

      Get the network information.

  Arguments:

      NetworkGuid - Supplies the Network GUID.

      CompartmentId - Returns the compartment ID.

      SiteId - Returns Site ID.

      NetowrkName - Returns the network name.

      Length - Supplies the length of NetworkName buffer.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function SetNetworkInformation(const NetworkGuid: PNetIfNetworkGuid;
  CompartmentId: TNetIfCompartmentId; const NetworkName: PWCHAR): NETIOAPI_API; stdcall;

{ Routine Description:

      Set the Network Information.

  Arguments:

      NetworkGuid - Supplies the session ID.

      CompartmentId - Supplies the compartment ID to be set.

      NetworkName - Supplies the Network name to be set.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function ConvertLengthToIpv4Mask(MaskLength: ULONG; Mask: PULONG): NETIOAPI_API; stdcall;

{ Routine Description:

      Converts a prefixLength to a subnet mask.

  Arguments:

      MaskLength - Prefix Length.

      Mask - Mask generated.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function ConvertIpv4MaskToLength(Mask: ULONG; MaskLength: PByte): NETIOAPI_API; stdcall;

{ Routine Description:

      Converts a subnet mask to a prefix length.

  Arguments:

      Mask - Subnet mask to use.

      MaskLength - Prefix length computed.

  Return Value:

      User-Mode: NO_ERROR on success, error code on failure.

      Kernel-Mode: STATUS_SUCCESS on success, error code on failure. }

function RtlIpv4AddressToString(const Addr: PInAddr; S: PWideChar): PWideChar; stdcall;
function RtlIpv4AddressToStringA(const Addr: PInAddr; S: PAnsiChar): PAnsiChar; stdcall;
function RtlIpv4AddressToStringW(const Addr: PInAddr; S: PWideChar): PWideChar; stdcall;

function RtlIpv4AddressToStringEx(const Address: PInAddr; Port: Word;
  AddressString: PWideChar; AddressStringLength: PULONG): Longint; stdcall;
function RtlIpv4AddressToStringExA(const Address: PInAddr; Port: Word;
  AddressString: PAnsiChar; AddressStringLength: PULONG): Longint; stdcall;
function RtlIpv4AddressToStringExW(const Address: PInAddr; Port: Word;
  AddressString: PWideChar; AddressStringLength: PULONG): Longint; stdcall;

function RtlIpv4StringToAddress(const S: PWideChar; Strict: Boolean;
  var Terminator: PWideChar; Address: PInAddr): Longint; stdcall;
function RtlIpv4StringToAddressA(const S: PAnsiChar; Strict: Boolean;
  var Terminator: PAnsiChar; Address: PInAddr): Longint; stdcall;
function RtlIpv4StringToAddressW(const S: PWideChar; Strict: Boolean;
  var Terminator: PWideChar; Address: PInAddr): Longint; stdcall;

function RtlIpv4StringToAddressEx(const AddressString: PWideChar; Strict: Boolean;
  Address: PInAddr; Port: PWord): Longint; stdcall;
function RtlIpv4StringToAddressExA(const AddressString: PAnsiChar; Strict: Boolean;
  Address: PInAddr; Port: PWord): Longint; stdcall;
function RtlIpv4StringToAddressExW(const AddressString: PWideChar; Strict: Boolean;
  Address: PInAddr; Port: PWord): Longint; stdcall;

function RtlIpv6AddressToString(const Addr: PIn6Addr; S: PWideChar): PWideChar; stdcall;
function RtlIpv6AddressToStringA(const Addr: PIn6Addr; S: PAnsiChar): PAnsiChar; stdcall;
function RtlIpv6AddressToStringW(const Addr: PIn6Addr; S: PWideChar): PWideChar; stdcall;

function RtlIpv6AddressToStringEx(const Address: PIn6Addr; ScopeId: ULONG;
  Port: Word; AddressString: PWideChar; AddressStringLength: PULONG): Longint; stdcall;
function RtlIpv6AddressToStringExA(const Address: PIn6Addr; ScopeId: ULONG;
  Port: Word; AddressString: PAnsiChar; AddressStringLength: PULONG): Longint; stdcall;
function RtlIpv6AddressToStringExW(const Address: PIn6Addr; ScopeId: ULONG;
  Port: Word; AddressString: PWideChar; AddressStringLength: PULONG): Longint; stdcall;

function RtlIpv6StringToAddress(const S: PWideChar; var Terminator: PWideChar;
  Addr: PIn6Addr): Longint; stdcall;
function RtlIpv6StringToAddressA(const S: PAnsiChar; var Terminator: PAnsiChar;
  Addr: PIn6Addr): Longint; stdcall;
function RtlIpv6StringToAddressW(const S: PWideChar; var Terminator: PWideChar;
  Addr: PIn6Addr): Longint; stdcall;

function RtlIpv6StringToAddressEx(const AddressString: PWideChar; Address: PIn6Addr;
  ScopeId: PULONG; Port: PWord): Longint; stdcall;
function RtlIpv6StringToAddressExA(const AddressString: PAnsiChar; Address: PIn6Addr;
  ScopeId: PULONG; Port: PWord): Longint; stdcall;
function RtlIpv6StringToAddressExW(const AddressString: PWideChar; Address: PIn6Addr;
  ScopeId: PULONG; Port: PWord): Longint; stdcall;

function RtlEthernetAddressToString(const Addr: Pointer; S: PWideChar): PWideChar; stdcall;
function RtlEthernetAddressToStringA(const Addr: Pointer; S: PAnsiChar): PAnsiChar; stdcall;
function RtlEthernetAddressToStringW(const Addr: Pointer; S: PWideChar): PWideChar; stdcall;

function RtlEthernetStringToAddress(const S: PWideChar; var Terminator: PWideChar;
  Addr: Pointer): Longint; stdcall;
function RtlEthernetStringToAddressA(const S: PAnsiChar; var Terminator: PAnsiChar;
  Addr: Pointer): Longint; stdcall;
function RtlEthernetStringToAddressW(const S: PWideChar; var Terminator: PWideChar;
  Addr: Pointer): Longint; stdcall;
  
implementation

const
  iphlpapilib = 'iphlpapi.dll';
  ntdlllib = 'ntdll.dll';

function GetNumberOfInterfaces; external iphlpapilib name 'GetNumberOfInterfaces';
function GetIfEntry; external iphlpapilib name 'GetIfEntry';
function GetIfTable; external iphlpapilib name 'GetIfTable';
function GetIpAddrTable; external iphlpapilib name 'GetIpAddrTable';
function GetIpNetTable; external iphlpapilib name 'GetIpNetTable';
function GetIpForwardTable; external iphlpapilib name 'GetIpForwardTable';
function GetTcpTable; external iphlpapilib name 'GetTcpTable';
function GetExtendedTcpTable; external iphlpapilib name 'GetExtendedTcpTable';
function GetOwnerModuleFromTcpEntry; external iphlpapilib name 'GetOwnerModuleFromTcpEntry';
function GetUdpTable; external iphlpapilib name 'GetUdpTable';
function GetExtendedUdpTable; external iphlpapilib name 'GetExtendedUdpTable';
function GetOwnerModuleFromUdpEntry; external iphlpapilib name 'GetOwnerModuleFromUdpEntry';
function GetTcpTable2; external iphlpapilib name 'GetTcpTable2';
function AllocateAndGetTcpExTableFromStack; external iphlpapilib name 'AllocateAndGetTcpExTableFromStack';
function AllocateAndGetUdpExTableFromStack; external iphlpapilib name 'AllocateAndGetUdpExTableFromStack';
function GetTcp6Table; external iphlpapilib name 'GetTcp6Table';
function GetTcp6Table2; external iphlpapilib name 'GetTcp6Table2';
function GetPerTcpConnectionEStats; external iphlpapilib name 'GetPerTcpConnectionEStats';
function SetPerTcpConnectionEStats; external iphlpapilib name 'SetPerTcpConnectionEStats';
function GetPerTcp6ConnectionEStats; external iphlpapilib name 'GetPerTcp6ConnectionEStats';
function SetPerTcp6ConnectionEStats; external iphlpapilib name 'SetPerTcp6ConnectionEStats';
function GetOwnerModuleFromTcp6Entry; external iphlpapilib name 'GetOwnerModuleFromTcp6Entry';
function GetUdp6Table; external iphlpapilib name 'GetUdp6Table';
function GetOwnerModuleFromUdp6Entry; external iphlpapilib name 'GetOwnerModuleFromUdp6Entry';
function GetOwnerModuleFromPidAndInfo; external iphlpapilib name 'GetOwnerModuleFromPidAndInfo';
function GetIpStatistics; external iphlpapilib name 'GetIpStatistics';
function GetIcmpStatistics; external iphlpapilib name 'GetIcmpStatistics';
function GetTcpStatistics; external iphlpapilib name 'GetTcpStatistics';
function GetUdpStatistics; external iphlpapilib name 'GetUdpStatistics';
function GetIpStatisticsEx; external iphlpapilib name 'GetIpStatisticsEx';
function SetIpStatisticsEx; external iphlpapilib name 'SetIpStatisticsEx';
function GetIcmpStatisticsEx; external iphlpapilib name 'GetIcmpStatisticsEx';
function GetTcpStatisticsEx; external iphlpapilib name 'GetTcpStatisticsEx';
function GetUdpStatisticsEx; external iphlpapilib name 'GetUdpStatisticsEx';
function SetIfEntry; external iphlpapilib name 'SetIfEntry';
function CreateIpForwardEntry; external iphlpapilib name 'CreateIpForwardEntry';
function SetIpForwardEntry; external iphlpapilib name 'SetIpForwardEntry';
function DeleteIpForwardEntry; external iphlpapilib name 'DeleteIpForwardEntry';
function SetIpStatistics; external iphlpapilib name 'SetIpStatistics';
function SetIpTTL; external iphlpapilib name 'SetIpTTL';
function CreateIpNetEntry; external iphlpapilib name 'CreateIpNetEntry';
function SetIpNetEntry; external iphlpapilib name 'SetIpNetEntry';
function DeleteIpNetEntry; external iphlpapilib name 'DeleteIpNetEntry';
function FlushIpNetTable; external iphlpapilib name 'FlushIpNetTable';
function CreateProxyArpEntry; external iphlpapilib name 'CreateProxyArpEntry';
function DeleteProxyArpEntry; external iphlpapilib name 'DeleteProxyArpEntry';
function SetTcpEntry; external iphlpapilib name 'SetTcpEntry';
function GetInterfaceInfo; external iphlpapilib name 'GetInterfaceInfo';
function GetUniDirectionalAdapterInfo; external iphlpapilib name 'GetUniDirectionalAdapterInfo';
function NhpAllocateAndGetInterfaceInfoFromStack; external iphlpapilib name 'NhpAllocateAndGetInterfaceInfoFromStack';
function GetBestInterface; external iphlpapilib name 'GetBestInterface';
function GetBestInterfaceEx; external iphlpapilib name 'GetBestInterfaceEx';
function GetBestRoute; external iphlpapilib name 'GetBestRoute';
function NotifyAddrChange; external iphlpapilib name 'NotifyAddrChange';
function NotifyRouteChange; external iphlpapilib name 'NotifyRouteChange';
function CancelIPChangeNotify; external iphlpapilib name 'CancelIPChangeNotify';
function GetAdapterIndex; external iphlpapilib name 'GetAdapterIndex';
function AddIPAddress; external iphlpapilib name 'AddIPAddress';
function DeleteIPAddress; external iphlpapilib name 'DeleteIPAddress';
function GetNetworkParams; external iphlpapilib name 'GetNetworkParams';
function GetAdaptersInfo; external iphlpapilib name 'GetAdaptersInfo';
function GetAdapterOrderMap; external iphlpapilib name 'GetAdapterOrderMap';
function GetAdaptersAddresses; external iphlpapilib name 'GetAdaptersAddresses';
function GetPerAdapterInfo; external iphlpapilib name 'GetPerAdapterInfo';
function IpReleaseAddress; external iphlpapilib name 'IpReleaseAddress';
function IpRenewAddress; external iphlpapilib name 'IpRenewAddress';
function SendARP; external iphlpapilib name 'SendARP';
function GetRTTAndHopCount; external iphlpapilib name 'GetRTTAndHopCount';
function GetFriendlyIfIndex; external iphlpapilib name 'GetFriendlyIfIndex';
function EnableRouter; external iphlpapilib name 'EnableRouter';
function UnenableRouter; external iphlpapilib name 'UnenableRouter';
function DisableMediaSense; external iphlpapilib name 'DisableMediaSense';
function RestoreMediaSense; external iphlpapilib name 'RestoreMediaSense';
function GetIpErrorString; external iphlpapilib name 'GetIpErrorString';
function ResolveNeighbor; external iphlpapilib name 'ResolveNeighbor';
function CreatePersistentTcpPortReservation; external iphlpapilib name 'CreatePersistentTcpPortReservation';
function CreatePersistentUdpPortReservation; external iphlpapilib name 'CreatePersistentUdpPortReservation';
function DeletePersistentTcpPortReservation; external iphlpapilib name 'DeletePersistentTcpPortReservation';
function DeletePersistentUdpPortReservation; external iphlpapilib name 'DeletePersistentUdpPortReservation';
function LookupPersistentTcpPortReservation; external iphlpapilib name 'LookupPersistentTcpPortReservation';
function LookupPersistentUdpPortReservation; external iphlpapilib name 'LookupPersistentUdpPortReservation';
function ParseNetworkString; external iphlpapilib name 'ParseNetworkString';
function IcmpCreateFile; external iphlpapilib name 'IcmpCreateFile';
function Icmp6CreateFile; external iphlpapilib name 'Icmp6CreateFile';
function IcmpCloseHandle; external iphlpapilib name 'IcmpCloseHandle';
function IcmpSendEcho; external iphlpapilib name 'IcmpSendEcho';
function IcmpSendEcho2; external iphlpapilib name 'IcmpSendEcho2';
function IcmpSendEcho2Ex; external iphlpapilib name 'IcmpSendEcho2Ex';
function Icmp6SendEcho2; external iphlpapilib name 'Icmp6SendEcho2';
function IcmpParseReplies; external iphlpapilib name 'IcmpParseReplies';
function Icmp6ParseReplies; external iphlpapilib name 'Icmp6ParseReplies';
function GetIfEntry2; external iphlpapilib name 'GetIfEntry2';
function GetIfTable2; external iphlpapilib name 'GetIfTable2';
function GetIfTable2Ex; external iphlpapilib name 'GetIfTable2Ex';
function GetIfStackTable; external iphlpapilib name 'GetIfStackTable';
function GetInvertedIfStackTable; external iphlpapilib name 'GetInvertedIfStackTable';
function GetIpInterfaceEntry; external iphlpapilib name 'GetIpInterfaceEntry';
function GetIpInterfaceTable; external iphlpapilib name 'GetIpInterfaceTable';
function InitializeIpInterfaceEntry; external iphlpapilib name 'InitializeIpInterfaceEntry';
function NotifyIpInterfaceChange; external iphlpapilib name 'NotifyIpInterfaceChange';
function SetIpInterfaceEntry; external iphlpapilib name 'SetIpInterfaceEntry';
function CreateUnicastIpAddressEntry; external iphlpapilib name 'CreateUnicastIpAddressEntry';
function DeleteUnicastIpAddressEntry; external iphlpapilib name 'DeleteUnicastIpAddressEntry';
function GetUnicastIpAddressEntry; external iphlpapilib name 'GetUnicastIpAddressEntry';
function GetUnicastIpAddressTable; external iphlpapilib name 'GetUnicastIpAddressTable';
procedure InitializeUnicastIpAddressEntry; external iphlpapilib name 'InitializeUnicastIpAddressEntry';
function NotifyUnicastIpAddressChange; external iphlpapilib name 'NotifyUnicastIpAddressChange';
function NotifyStableUnicastIpAddressTable; external iphlpapilib name 'NotifyStableUnicastIpAddressTable';
function SetUnicastIpAddressEntry; external iphlpapilib name 'SetUnicastIpAddressEntry';
function CreateAnycastIpAddressEntry; external iphlpapilib name 'CreateAnycastIpAddressEntry';
function DeleteAnycastIpAddressEntry; external iphlpapilib name 'DeleteAnycastIpAddressEntry';
function GetAnycastIpAddressEntry; external iphlpapilib name 'GetAnycastIpAddressEntry';
function GetAnycastIpAddressTable; external iphlpapilib name 'GetAnycastIpAddressTable';
function GetMulticastIpAddressEntry; external iphlpapilib name 'GetMulticastIpAddressEntry';
function GetMulticastIpAddressTable; external iphlpapilib name 'GetMulticastIpAddressTable';
function CreateIpForwardEntry2; external iphlpapilib name 'CreateIpForwardEntry2';
function DeleteIpForwardEntry2; external iphlpapilib name 'DeleteIpForwardEntry2';
function GetBestRoute2; external iphlpapilib name 'GetBestRoute2';
function GetIpForwardEntry2; external iphlpapilib name 'GetIpForwardEntry2';
function GetIpForwardTable2; external iphlpapilib name 'GetIpForwardTable2';
procedure InitializeIpForwardEntry; external iphlpapilib name 'InitializeIpForwardEntry';
function NotifyRouteChange2; external iphlpapilib name 'NotifyRouteChange2';
function SetIpForwardEntry2; external iphlpapilib name 'SetIpForwardEntry2';
function FlushIpPathTable; external iphlpapilib name 'FlushIpPathTable';
function GetIpPathEntry; external iphlpapilib name 'GetIpPathEntry';
function GetIpPathTable; external iphlpapilib name 'GetIpPathTable';
function CreateIpNetEntry2; external iphlpapilib name 'CreateIpNetEntry2';
function DeleteIpNetEntry2; external iphlpapilib name 'DeleteIpNetEntry2';
function FlushIpNetTable2; external iphlpapilib name 'FlushIpNetTable2';
function GetIpNetEntry2; external iphlpapilib name 'GetIpNetEntry2';
function GetIpNetTable2; external iphlpapilib name 'GetIpNetTable2';
function ResolveIpNetEntry2; external iphlpapilib name 'ResolveIpNetEntry2';
function SetIpNetEntry2; external iphlpapilib name 'SetIpNetEntry2';
function NotifyTeredoPortChange; external iphlpapilib name 'NotifyTeredoPortChange';
function GetTeredoPort; external iphlpapilib name 'GetTeredoPort';
function CancelMibChangeNotify2; external iphlpapilib name 'CancelMibChangeNotify2';
procedure FreeMibTable; external iphlpapilib name 'FreeMibTable';
function CreateSortedAddressPairs; external iphlpapilib name 'CreateSortedAddressPairs';
function ConvertInterfaceNameToLuid; external iphlpapilib name 'ConvertInterfaceNameToLuidW';
function ConvertInterfaceNameToLuidA; external iphlpapilib name 'ConvertInterfaceNameToLuidA';
function ConvertInterfaceNameToLuidW; external iphlpapilib name 'ConvertInterfaceNameToLuidW';
function ConvertInterfaceLuidToName; external iphlpapilib name 'ConvertInterfaceLuidToNameW';
function ConvertInterfaceLuidToNameA; external iphlpapilib name 'ConvertInterfaceLuidToNameA';
function ConvertInterfaceLuidToNameW; external iphlpapilib name 'ConvertInterfaceLuidToNameW';
function ConvertInterfaceLuidToIndex; external iphlpapilib name 'ConvertInterfaceLuidToIndex';
function ConvertInterfaceIndexToLuid; external iphlpapilib name 'ConvertInterfaceIndexToLuid';
function ConvertInterfaceLuidToAlias; external iphlpapilib name 'ConvertInterfaceLuidToAlias';
function ConvertInterfaceAliasToLuid; external iphlpapilib name 'ConvertInterfaceAliasToLuid';
function ConvertInterfaceLuidToGuid; external iphlpapilib name 'ConvertInterfaceLuidToGuid';
function ConvertInterfaceGuidToLuid; external iphlpapilib name 'ConvertInterfaceGuidToLuid';
function if_nametoindex; external iphlpapilib name 'if_nametoindex';
function if_indextoname; external iphlpapilib name 'if_indextoname';
function GetCurrentThreadCompartmentId; external iphlpapilib name 'GetCurrentThreadCompartmentId';
function SetCurrentThreadCompartmentId; external iphlpapilib name 'SetCurrentThreadCompartmentId';
function GetSessionCompartmentId; external iphlpapilib name 'GetSessionCompartmentId';
function SetSessionCompartmentId; external iphlpapilib name 'SetSessionCompartmentId';
function GetNetworkInformation; external iphlpapilib name 'GetNetworkInformation';
function SetNetworkInformation; external iphlpapilib name 'SetNetworkInformation';
function ConvertLengthToIpv4Mask; external iphlpapilib name 'ConvertLengthToIpv4Mask';
function ConvertIpv4MaskToLength; external iphlpapilib name 'ConvertIpv4MaskToLength';

function RtlIpv4AddressToString; external ntdlllib name 'RtlIpv4AddressToStringW';
function RtlIpv4AddressToStringA; external ntdlllib name 'RtlIpv4AddressToStringA';
function RtlIpv4AddressToStringW; external ntdlllib name 'RtlIpv4AddressToStringW';
function RtlIpv4AddressToStringEx; external ntdlllib name 'RtlIpv4AddressToStringExW';
function RtlIpv4AddressToStringExA; external ntdlllib name 'RtlIpv4AddressToStringExA';
function RtlIpv4AddressToStringExW; external ntdlllib name 'RtlIpv4AddressToStringExW';
function RtlIpv4StringToAddress; external ntdlllib name 'RtlIpv4StringToAddressW';
function RtlIpv4StringToAddressA; external ntdlllib name 'RtlIpv4StringToAddressA';
function RtlIpv4StringToAddressW; external ntdlllib name 'RtlIpv4StringToAddressW';
function RtlIpv4StringToAddressEx; external ntdlllib name 'RtlIpv4StringToAddressExW';
function RtlIpv4StringToAddressExA; external ntdlllib name 'RtlIpv4StringToAddressExA';
function RtlIpv4StringToAddressExW; external ntdlllib name 'RtlIpv4StringToAddressExW';
function RtlIpv6AddressToString; external ntdlllib name 'RtlIpv6AddressToStringW';
function RtlIpv6AddressToStringA; external ntdlllib name 'RtlIpv6AddressToStringA';
function RtlIpv6AddressToStringW; external ntdlllib name 'RtlIpv6AddressToStringW';
function RtlIpv6AddressToStringEx; external ntdlllib name 'RtlIpv6AddressToStringExW';
function RtlIpv6AddressToStringExA; external ntdlllib name 'RtlIpv6AddressToStringExA';
function RtlIpv6AddressToStringExW; external ntdlllib name 'RtlIpv6AddressToStringExW';
function RtlIpv6StringToAddress; external ntdlllib name 'RtlIpv6StringToAddressW';
function RtlIpv6StringToAddressA; external ntdlllib name 'RtlIpv6StringToAddressA';
function RtlIpv6StringToAddressW; external ntdlllib name 'RtlIpv6StringToAddressW';
function RtlIpv6StringToAddressEx; external ntdlllib name 'RtlIpv6StringToAddressExW';
function RtlIpv6StringToAddressExA; external ntdlllib name 'RtlIpv6StringToAddressExA';
function RtlIpv6StringToAddressExW; external ntdlllib name 'RtlIpv6StringToAddressExW';
function RtlEthernetAddressToString; external ntdlllib name 'RtlEthernetAddressToStringW';
function RtlEthernetAddressToStringA; external ntdlllib name 'RtlEthernetAddressToStringA';
function RtlEthernetAddressToStringW; external ntdlllib name 'RtlEthernetAddressToStringW';
function RtlEthernetStringToAddress; external ntdlllib name 'RtlEthernetStringToAddressW';
function RtlEthernetStringToAddressA; external ntdlllib name 'RtlEthernetStringToAddressA';
function RtlEthernetStringToAddressW; external ntdlllib name 'RtlEthernetStringToAddressW';

end.

