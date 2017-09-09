{*******************************************************}
{                                                       }
{       Borland Delphi Runtime Library                  }
{       SNMP API Interface Unit                         }
{                                                       }
{       Copyright (c) 1992-1999 Microsoft Corporation   }
{                                                       }
{       Translator: Vadim Crits                         }
{                                                       }
{*******************************************************}

unit Snmp;

{$ALIGN 4}

interface

uses Windows;

{ SNMP Type Definitions }

type
  PAsnOctetString = ^TAsnOctetString;
  TAsnOctetString = record
    stream: PByte;
    length: UINT;
    dynam: BOOL;
  end;

  PAsnObjectIdentifier = ^TAsnObjectIdentifier;
  TAsnObjectIdentifier = record
    idLength: UINT;
    ids: PUINT;
  end;

  PAsnInteger32 = ^TAsnInteger32;
  TAsnInteger32 = Longint;

  PAsnUnsigned32 = ^TAsnUnsigned32;
  TAsnUnsigned32 = ULONG;

  PTAsnCounter64 = ^TAsnCounter64;
  TAsnCounter64 = ULARGE_INTEGER;

  PAsnCounter32 = ^TAsnCounter32;
  TAsnCounter32 = TAsnUnsigned32;

  PAsnGauge32 = ^TAsnGauge32;
  TAsnGauge32 = TAsnUnsigned32;

  PAsnTimeticks = ^TAsnTimeticks;
  TAsnTimeticks = TAsnUnsigned32;

  PAsnBits = ^TAsnBits;
  TAsnBits = TAsnOctetString;

  PAsnSequence = ^TAsnSequence;
  TAsnSequence = TAsnOctetString;

  PAsnImplicitSequence = ^TAsnImplicitSequence;
  TAsnImplicitSequence = TAsnOctetString;

  PAsnIpAddress = ^TAsnIpAddress;
  TAsnIpAddress = TAsnOctetString;

  PAsnNetworkAddress = ^TAsnNetworkAddress;
  TAsnNetworkAddress = TAsnOctetString;

  PAsnDisplayString = ^TAsnDisplayString;
  TAsnDisplayString = TAsnOctetString;

  PAsnOpaque = ^TAsnOpaque;
  TAsnOpaque = TAsnOctetString;

  PAsnAny = ^TAsnAny;
  TAsnAny = record
    asnType: Byte;
    asnValue: record
      case Integer of
        0: (number: TAsnInteger32);      { ASN_INTEGER, ASN_INTEGER32 }
        1: (unsigned32: TAsnUnsigned32); { ASN_UNSIGNED32 }
        2: (counter64: TAsnCounter64);   { ASN_COUNTER64 }
        3: (str: TAsnOctetString);       { ASN_OCTETSTRING }
        4: (bits: TAsnBits);             { ASN_BITS }
        5: (obj: TAsnObjectIdentifier);  { ASN_OBJECTIDENTIFIER }
        6: (sequence: TAsnSequence);     { ASN_SEQUENCE }
        7: (address: TAsnIpAddress);     { ASN_IPADDRESS }
        8: (counter: TAsnCounter32);     { ASN_COUNTER32 }
        9: (gauge: TAsnGauge32);         { ASN_GAUGE32 }
       10: (ticks: TAsnTimeticks);       { ASN_TIMETICKS }
       11: (arbitrary: TAsnOpaque);      { ASN_OPAQUE }
    end;
  end;

  TAsnObjectName = TAsnObjectIdentifier;
  TAsnObjectSyntax = TAsnAny;

  PSnmpVarBind = ^TSnmpVarBind;
  TSnmpVarBind = record
    name: TAsnObjectName;
    value: TAsnObjectSyntax;
  end;

  PSnmpVarBindList = ^TSnmpVarBindList;
  TSnmpVarBindList = record
    list: PSnmpVarBind;
    len: UINT;
  end;

{ ASN/BER Base Types }

const
  ASN_UNIVERSAL              = $00;
  ASN_APPLICATION            = $40;
  ASN_CONTEXT                = $80;
  ASN_PRIVATE                = $C0;

  ASN_PRIMITIVE              = $00;
  ASN_CONSTRUCTOR            = $20;

{ PDU Type Values }

  SNMP_PDU_GET               = ASN_CONTEXT or ASN_CONSTRUCTOR or $0;
  SNMP_PDU_GETNEXT           = ASN_CONTEXT or ASN_CONSTRUCTOR or $1;
  SNMP_PDU_RESPONSE          = ASN_CONTEXT or ASN_CONSTRUCTOR or $2;
  SNMP_PDU_SET               = ASN_CONTEXT or ASN_CONSTRUCTOR or $3;
  SNMP_PDU_V1TRAP            = ASN_CONTEXT or ASN_CONSTRUCTOR or $4;
  SNMP_PDU_GETBULK           = ASN_CONTEXT or ASN_CONSTRUCTOR or $5;
  SNMP_PDU_INFORM            = ASN_CONTEXT or ASN_CONSTRUCTOR or $6;
  SNMP_PDU_TRAP              = ASN_CONTEXT or ASN_CONSTRUCTOR or $7;

{ SNMP Simple Syntax Values }

  ASN_INTEGER                = ASN_UNIVERSAL or ASN_PRIMITIVE or $02;
  ASN_BITS                   = ASN_UNIVERSAL or ASN_PRIMITIVE or $03;
  ASN_OCTETSTRING            = ASN_UNIVERSAL or ASN_PRIMITIVE or $04;
  ASN_NULL                   = ASN_UNIVERSAL or ASN_PRIMITIVE or $05;
  ASN_OBJECTIDENTIFIER       = ASN_UNIVERSAL or ASN_PRIMITIVE or $06;
  ASN_INTEGER32              = ASN_INTEGER;

{ SNMP Constructor Syntax Values }

  ASN_SEQUENCE               = ASN_UNIVERSAL or ASN_CONSTRUCTOR or $10;
  ASN_SEQUENCEOF             = ASN_SEQUENCE;

{ SNMP Application Syntax Values }

  ASN_IPADDRESS              = ASN_APPLICATION or ASN_PRIMITIVE or $00;
  ASN_COUNTER32              = ASN_APPLICATION or ASN_PRIMITIVE or $01;
  ASN_GAUGE32                = ASN_APPLICATION or ASN_PRIMITIVE or $02;
  ASN_TIMETICKS              = ASN_APPLICATION or ASN_PRIMITIVE or $03;
  ASN_OPAQUE                 = ASN_APPLICATION or ASN_PRIMITIVE or $04;
  ASN_COUNTER64              = ASN_APPLICATION or ASN_PRIMITIVE or $06;
  ASN_UNSIGNED32             = ASN_APPLICATION or ASN_PRIMITIVE or $07;
  ASN_RFC2578_UNSIGNED32     = ASN_GAUGE32;

{ SNMP Exception Conditions }

  SNMP_EXCEPTION_NOSUCHOBJECT   = ASN_CONTEXT or ASN_PRIMITIVE or $00;
  SNMP_EXCEPTION_NOSUCHINSTANCE = ASN_CONTEXT or ASN_PRIMITIVE or $01;
  SNMP_EXCEPTION_ENDOFMIBVIEW   = ASN_CONTEXT or ASN_PRIMITIVE or $02;

{ SNMP Request Types (used in SnmpExtensionQueryEx) }

  SNMP_EXTENSION_GET         = SNMP_PDU_GET;
  SNMP_EXTENSION_GET_NEXT    = SNMP_PDU_GETNEXT;
  SNMP_EXTENSION_GET_BULK    = SNMP_PDU_GETBULK;
  SNMP_EXTENSION_SET_TEST    = ASN_PRIVATE or ASN_CONSTRUCTOR or $0;
  SNMP_EXTENSION_SET_COMMIT  = SNMP_PDU_SET;
  SNMP_EXTENSION_SET_UNDO    = ASN_PRIVATE or ASN_CONSTRUCTOR or $1;
  SNMP_EXTENSION_SET_CLEANUP = ASN_PRIVATE or ASN_CONSTRUCTOR or $2;

{ SNMP Error Codes }

  SNMP_ERRORSTATUS_NOERROR             = 0;
  SNMP_ERRORSTATUS_TOOBIG              = 1;
  SNMP_ERRORSTATUS_NOSUCHNAME          = 2;
  SNMP_ERRORSTATUS_BADVALUE            = 3;
  SNMP_ERRORSTATUS_READONLY            = 4;
  SNMP_ERRORSTATUS_GENERR              = 5;
  SNMP_ERRORSTATUS_NOACCESS            = 6;
  SNMP_ERRORSTATUS_WRONGTYPE           = 7;
  SNMP_ERRORSTATUS_WRONGLENGTH         = 8;
  SNMP_ERRORSTATUS_WRONGENCODING       = 9;
  SNMP_ERRORSTATUS_WRONGVALUE          = 10;
  SNMP_ERRORSTATUS_NOCREATION          = 11;
  SNMP_ERRORSTATUS_INCONSISTENTVALUE   = 12;
  SNMP_ERRORSTATUS_RESOURCEUNAVAILABLE = 13;
  SNMP_ERRORSTATUS_COMMITFAILED        = 14;
  SNMP_ERRORSTATUS_UNDOFAILED          = 15;
  SNMP_ERRORSTATUS_AUTHORIZATIONERROR  = 16;
  SNMP_ERRORSTATUS_NOTWRITABLE         = 17;
  SNMP_ERRORSTATUS_INCONSISTENTNAME    = 18;

{ SNMPv1 Trap Types }

  SNMP_GENERICTRAP_COLDSTART           = 0;
  SNMP_GENERICTRAP_WARMSTART           = 1;
  SNMP_GENERICTRAP_LINKDOWN            = 2;
  SNMP_GENERICTRAP_LINKUP              = 3;
  SNMP_GENERICTRAP_AUTHFAILURE         = 4;
  SNMP_GENERICTRAP_EGPNEIGHLOSS        = 5;
  SNMP_GENERICTRAP_ENTERSPECIFIC       = 6;

{ SNMP Access Types }

  SNMP_ACCESS_NONE                     = 0;
  SNMP_ACCESS_NOTIFY                   = 1;
  SNMP_ACCESS_READ_ONLY                = 2;
  SNMP_ACCESS_READ_WRITE               = 3;
  SNMP_ACCESS_READ_CREATE              = 4;

{ SNMP API Return Code Definitions }

type
  SNMPAPI                              = Integer;

const  
  SNMPAPI_NOERROR                      = True;
  SNMPAPI_ERROR                        = False;

{ SNMP Extension API Prototypes }

function LoadSnmpExtension(const LibFileName: string): Boolean;

procedure FreeSnmpExtension;

var
  SnmpExtensionInit: function(dwUptimeReference: DWORD; phSubagentTrapEvent: PHandle;
    pFirstSupportedRegion: PAsnObjectIdentifier): BOOL; stdcall;
  SnmpExtensionInitEx: function(pNextSupportedRegion: PAsnObjectIdentifier): BOOL; stdcall;
  SnmpExtensionMonitor: function(pAgentMgmtData: Pointer): BOOL; stdcall;
  SnmpExtensionQuery: function(bPduType: Byte; pVarBindList: PSnmpVarBindList;
    pErrorStatus, pErrorIndex: PAsnInteger32): BOOL; stdcall;
  SnmpExtensionQueryEx: function(nRequestType, nTransactionId: UINT;
    pVarBindList: PSnmpVarBindList; pContextInfo: PAsnOctetString;
    pErrorStatus, pErrorIndex: PAsnInteger32): BOOL; stdcall;
  SnmpExtensionTrap: function(pEnterpriseOid: PAsnObjectIdentifier;
    pGenericTrapId, pSpecificTrapId: PAsnInteger32; pTimeStamp: PAsnTimeticks;
    pVarBindList: PSnmpVarBindList): BOOL; stdcall;
  SnmpExtensionClose: procedure; stdcall;

{ SNMP API Prototypes }

function SnmpUtilOidCpy(pOidDst, pOidSrc: PAsnObjectIdentifier): SNMPAPI; stdcall;
function SnmpUtilOidAppend(pOidDst, pOidSrc: PAsnObjectIdentifier): SNMPAPI; stdcall;
function SnmpUtilOidNCmp(pOid1, pOid2: PAsnObjectIdentifier; nSubIds: UINT): SNMPAPI; stdcall;
function SnmpUtilOidCmp(pOid1, pOid2: PAsnObjectIdentifier): SNMPAPI; stdcall;
procedure SnmpUtilOidFree(pOid: PAsnObjectIdentifier); stdcall;
function SnmpUtilOctetsCmp(pOctets1, pOctets2: PAsnOctetString): SNMPAPI; stdcall;
function SnmpUtilOctetsNCmp(pOctets1, pOctets2: PAsnOctetString; nChars: UINT): SNMPAPI; stdcall;
function SnmpUtilOctetsCpy(pOctetsDst, pOctetsSrc: PAsnOctetString): SNMPAPI; stdcall;
procedure SnmpUtilOctetsFree(pOctets: PAsnOctetString); stdcall;
function SnmpUtilAsnAnyCpy(pAnyDst, pAnySrc: PAsnAny): SNMPAPI; stdcall;
procedure SnmpUtilAsnAnyFree(pAny: PAsnAny); stdcall;
function SnmpUtilVarBindCpy(pVbDst, pVbSrc: PSnmpVarBind): SNMPAPI; stdcall;
procedure SnmpUtilVarBindFree(pVb: PSnmpVarBind); stdcall;
function SnmpUtilVarBindListCpy(pVblDst, pVblSrc: PSnmpVarBindList): SNMPAPI; stdcall;
procedure SnmpUtilVarBindListFree(pVbl: PSnmpVarBindList); stdcall;
procedure SnmpUtilMemFree(pMem: Pointer); stdcall;
function SnmpUtilMemAlloc(nBytes: UINT): Pointer; stdcall;
function SnmpUtilMemReAlloc(pMem: Pointer; nBytes: UINT): Pointer; stdcall;
function SnmpUtilOidToA(Oid: PAsnObjectIdentifier): LPSTR; stdcall;
function SnmpUtilIdsToA(Ids: PUINT; IdLength: UINT): LPSTR; stdcall;
procedure SnmpUtilPrintOid(Oid: PAsnObjectIdentifier); stdcall;
procedure SnmpUtilPrintAsnAny(pAny: PAsnAny); stdcall;
function SnmpSvcGetUptime: DWORD; stdcall;
procedure SnmpSvcSetLogLevel(nLogLevel: Integer); stdcall;
procedure SnmpSvcSetLogType(nLogType: Integer); stdcall;

{ SNMP Debugging Definitions }

const
  SNMP_LOG_SILENT                 = $0;
  SNMP_LOG_FATAL                  = $1;
  SNMP_LOG_ERROR                  = $2;
  SNMP_LOG_WARNING                = $3;
  SNMP_LOG_TRACE                  = $4;
  SNMP_LOG_VERBOSE                = $5;

  SNMP_OUTPUT_TO_CONSOLE          = $1;
  SNMP_OUTPUT_TO_LOGFILE          = $2;
  SNMP_OUTPUT_TO_EVENTLOG         = $4; { no longer supported }
  SNMP_OUTPUT_TO_DEBUGGER         = $8;

{ SNMP Debugging Prototypes }

procedure SnmpUtilDbgPrint(nLogLevel: Integer; szFormat: LPSTR); stdcall;

{ Miscellaneous definitions }

const
  DEFINE_NULLOID:
    TAsnObjectIdentifier        = (idLength: 0; ids: nil);
  DEFINE_NULLOCTETS:
    TAsnOctetString             = (stream: nil; length: 0; dynam: False);

  DEFAULT_SNMP_PORT_UDP         = 161;
  DEFAULT_SNMP_PORT_IPX         = 36879;
  DEFAULT_SNMPTRAP_PORT_UDP     = 162;
  DEFAULT_SNMPTRAP_PORT_IPX     = 36880;

  SNMP_MAX_OID_LEN              = 128;

{ API Error Code Definitions }

  SNMP_MEM_ALLOC_ERROR          = 1;
  SNMP_BERAPI_INVALID_LENGTH    = 10;
  SNMP_BERAPI_INVALID_TAG       = 11;
  SNMP_BERAPI_OVERFLOW          = 12;
  SNMP_BERAPI_SHORT_BUFFER      = 13;
  SNMP_BERAPI_INVALID_OBJELEM   = 14;
  SNMP_PDUAPI_UNRECOGNIZED_PDU  = 20;
  SNMP_PDUAPI_INVALID_ES        = 21;
  SNMP_PDUAPI_INVALID_GT        = 22;
  SNMP_AUTHAPI_INVALID_VERSION  = 30;
  SNMP_AUTHAPI_INVALID_MSG_TYPE = 31;
  SNMP_AUTHAPI_TRIV_AUTH_FAILED = 32;

implementation

var
  hSnmpExtension: THandle;

function LoadSnmpExtension(const LibFileName: string): Boolean;
begin
  Result := False;
  hSnmpExtension := LoadLibrary(PChar(LibFileName));
  if hSnmpExtension <> 0 then
  begin
    @SnmpExtensionInit := GetProcAddress(hSnmpExtension, 'SnmpExtensionInit');
    @SnmpExtensionInitEx := GetProcAddress(hSnmpExtension, 'SnmpExtensionInitEx');
    @SnmpExtensionMonitor := GetProcAddress(hSnmpExtension, 'SnmpExtensionMonitor');
    @SnmpExtensionQuery := GetProcAddress(hSnmpExtension, 'SnmpExtensionQuery');
    @SnmpExtensionQueryEx := GetProcAddress(hSnmpExtension, 'SnmpExtensionQueryEx');
    @SnmpExtensionTrap := GetProcAddress(hSnmpExtension, 'SnmpExtensionTrap');
    @SnmpExtensionClose := GetProcAddress(hSnmpExtension, 'SnmpExtensionClose');
    Result := Assigned(SnmpExtensionInit);
    if not Result then
      FreeSnmpExtension;
  end;
end;

procedure FreeSnmpExtension;
begin
  if hSnmpExtension <> 0 then
  begin
    FreeLibrary(hSnmpExtension);
    hSnmpExtension := 0;
    @SnmpExtensionInit := nil;
    @SnmpExtensionInitEx := nil;
    @SnmpExtensionMonitor := nil;
    @SnmpExtensionQuery := nil;
    @SnmpExtensionQueryEx := nil;
    @SnmpExtensionTrap := nil;
    @SnmpExtensionClose := nil;
  end;
end;

const
  snmpapilib = 'snmpapi.dll';

function SnmpUtilOidCpy; external snmpapilib name 'SnmpUtilOidCpy';
function SnmpUtilOidAppend; external snmpapilib name 'SnmpUtilOidAppend';
function SnmpUtilOidNCmp; external snmpapilib name 'SnmpUtilOidNCmp';
function SnmpUtilOidCmp; external snmpapilib name 'SnmpUtilOidCmp';
procedure SnmpUtilOidFree; external snmpapilib name 'SnmpUtilOidFree';
function SnmpUtilOctetsCmp; external snmpapilib name 'SnmpUtilOctetsCmp';
function SnmpUtilOctetsNCmp; external snmpapilib name 'SnmpUtilOctetsNCmp';
function SnmpUtilOctetsCpy; external snmpapilib name 'SnmpUtilOctetsCpy';
procedure SnmpUtilOctetsFree; external snmpapilib name 'SnmpUtilOctetsFree';
function SnmpUtilAsnAnyCpy; external snmpapilib name 'SnmpUtilAsnAnyCpy';
procedure SnmpUtilAsnAnyFree; external snmpapilib name 'SnmpUtilAsnAnyFree';
function SnmpUtilVarBindCpy; external snmpapilib name 'SnmpUtilVarBindCpy';
procedure SnmpUtilVarBindFree; external snmpapilib name 'SnmpUtilVarBindFree';
function SnmpUtilVarBindListCpy; external snmpapilib name 'SnmpUtilVarBindListCpy';
procedure SnmpUtilVarBindListFree; external snmpapilib name 'SnmpUtilVarBindListFree';
procedure SnmpUtilMemFree; external snmpapilib name 'SnmpUtilMemFree';
function SnmpUtilMemAlloc; external snmpapilib name 'SnmpUtilMemAlloc';
function SnmpUtilMemReAlloc; external snmpapilib name 'SnmpUtilMemReAlloc';
function SnmpUtilOidToA; external snmpapilib name 'SnmpUtilOidToA';
function SnmpUtilIdsToA; external snmpapilib name 'SnmpUtilIdsToA';
procedure SnmpUtilPrintOid; external snmpapilib name 'SnmpUtilPrintOid';
procedure SnmpUtilPrintAsnAny; external snmpapilib name 'SnmpUtilPrintAsnAny';
function SnmpSvcGetUptime; external snmpapilib name 'SnmpSvcGetUptime';
procedure SnmpSvcSetLogLevel; external snmpapilib name 'SnmpSvcSetLogLevel';
procedure SnmpSvcSetLogType; external snmpapilib name 'SnmpSvcSetLogType';
procedure SnmpUtilDbgPrint; external snmpapilib name 'SnmpUtilDbgPrint';

end.
