{*******************************************************}
{                                                       }
{       Borland Delphi Runtime Library                  }
{       SNMP Management API Interface Unit              }
{                                                       }
{       Copyright (c) 1992-1999 Microsoft Corporation   }
{                                                       }
{       Translator: Vadim Crits                         }
{                                                       }
{*******************************************************}

unit MgmtAPI;

{$WEAKPACKAGEUNIT}

interface

uses Windows, Snmp;

{ MGMT API error code definitions}

const
  SNMP_MGMTAPI_TIMEOUT         = 40;
  SNMP_MGMTAPI_SELECT_FDERRORS = 41;
  SNMP_MGMTAPI_TRAP_ERRORS     = 42;
  SNMP_MGMTAPI_TRAP_DUPINIT    = 43;
  SNMP_MGMTAPI_NOTRAPS         = 44;
  SNMP_MGMTAPI_AGAIN           = 45;
  SNMP_MGMTAPI_INVALID_CTL     = 46;
  SNMP_MGMTAPI_INVALID_SESSION = 47;
  SNMP_MGMTAPI_INVALID_BUFFER  = 48;

{ MGMT API control codes }

  MGMCTL_SETAGENTPORT          = $01;

{ MGMT API type definitions}

type
  PSnmpMgrSession = Pointer;

{ MGMT API prototypes}

function SnmpMgrOpen(lpAgentAddress, lpAgentCommunity: LPSTR;
  nTimeOut, nRetries: Integer): PSnmpMgrSession; stdcall;

function SnmpMgrCtl(session: PSnmpMgrSession; dwCtlCode: DWORD;
  lpvInBuffer: Pointer; cbInBuffer: DWORD; lpvOUTBuffer: Pointer;
  cbOUTBuffer: DWORD; lpcbBytesReturned: LPDWORD): BOOL; stdcall;

function SnmpMgrClose(session: PSnmpMgrSession): BOOL; stdcall;

function SnmpMgrRequest(session: PSnmpMgrSession; requestType: Byte;
  variableBindings: PSnmpVarBindList; errorStatus, errorIndex: PAsnInteger32): SNMPAPI; stdcall;

function SnmpMgrStrToOid(str: LPSTR; oid: PAsnObjectIdentifier): BOOL; stdcall;

function SnmpMgrOidToStr(oid: PAsnObjectIdentifier; str: PLPSTR): BOOL; stdcall;

function SnmpMgrTrapListen(phTrapAvailable: PHandle): BOOL; stdcall;

function SnmpMgrGetTrap(enterprise: PAsnObjectIdentifier; IpAddress: PAsnNetworkAddress;
  genericTrap, specificTrap: PAsnInteger32; timeStamp: PAsnTimeticks;
  variableBindings: PSnmpVarBindList): BOOL; stdcall;
  
function SnmpMgrGetTrapEx(enterprise: PAsnObjectIdentifier;
  agentAddress, sourceAddress: PAsnNetworkAddress;
  genericTrap, specificTrap: PAsnInteger32;
  community: PAsnOctetString; timeStamp: PAsnTimeticks;
  variableBindings: PSnmpVarBindList): BOOL; stdcall;

implementation

const
  mgmtapilib = 'mgmtapi.dll';

function SnmpMgrOpen; external mgmtapilib name 'SnmpMgrOpen';
function SnmpMgrCtl; external mgmtapilib name 'SnmpMgrCtl';
function SnmpMgrClose; external mgmtapilib name 'SnmpMgrClose';
function SnmpMgrRequest; external mgmtapilib name 'SnmpMgrRequest';
function SnmpMgrStrToOid; external mgmtapilib name 'SnmpMgrStrToOid';
function SnmpMgrOidToStr; external mgmtapilib name 'SnmpMgrOidToStr';
function SnmpMgrTrapListen; external mgmtapilib name 'SnmpMgrTrapListen';
function SnmpMgrGetTrap; external mgmtapilib name 'SnmpMgrGetTrap';
function SnmpMgrGetTrapEx; external mgmtapilib name 'SnmpMgrGetTrapEx';

end.

