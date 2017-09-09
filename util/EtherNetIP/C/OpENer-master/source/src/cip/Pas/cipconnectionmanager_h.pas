(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit cipconnectionmanager_h;

//{$I AlGun.inc}

interface

(*
** 'C2PTypes.pas' declares external windows data types for the conversion purposes.
** It's created by the CtoPas converter and saved under
** "\Program Files\Common Files\AlGun Shared\CToPas 2.0\P_Files" folder.
** Consult the Windows and Delphi help files for more information about defined data types
*)

uses
	C2PTypes, Windows, Messages, SysUtils, Classes, typedefs_h, ciptypes_h, opener_api_h;

(*******************************************************************************
 * Copyright (c) 2009, Rockwell Automation, Inc.
 * All rights reserved. 
 *
 ******************************************************************************)
{$HPPEMIT '#include 'opener_user_conf.h''}
{$HPPEMIT '#include 'opener_api.h''}
{$HPPEMIT '#include 'typedefs.h''}
{$HPPEMIT '#include 'ciptypes.h''}

const CONSUMING = 0;	(* these are used as array indexes, watch out if changing these values *)
{$EXTERNALSYM CONSUMING}
const PRODUCING = 1;
{$EXTERNALSYM PRODUCING}

const CIP_POINT_TO_POINT_CONNECTION = $4000;
{$EXTERNALSYM CIP_POINT_TO_POINT_CONNECTION}
const CIP_MULTICAST_CONNECTION = $2000;
{$EXTERNALSYM CIP_MULTICAST_CONNECTION}


(* Connection Manager Error codes *)
const CIP_CON_MGR_SUCCESS = $00;
{$EXTERNALSYM CIP_CON_MGR_SUCCESS}
const CIP_CON_MGR_ERROR_CONNECTION_IN_USE = $0100;
{$EXTERNALSYM CIP_CON_MGR_ERROR_CONNECTION_IN_USE}
const CIP_CON_MGR_ERROR_TRANSPORT_TRIGGER_NOT_SUPPORTED = $0103;
{$EXTERNALSYM CIP_CON_MGR_ERROR_TRANSPORT_TRIGGER_NOT_SUPPORTED}
const CIP_CON_MGR_ERROR_OWNERSHIP_CONFLICT = $0106;
{$EXTERNALSYM CIP_CON_MGR_ERROR_OWNERSHIP_CONFLICT}
const CIP_CON_MGR_ERROR_CONNECTION_NOT_FOUND_AT_TARGET_APPLICATION = $0107;
{$EXTERNALSYM CIP_CON_MGR_ERROR_CONNECTION_NOT_FOUND_AT_TARGET_APPLICATION}
const CIP_CON_MGR_ERROR_INVALID_O_TO_T_CONNECTION_TYPE = $123;
{$EXTERNALSYM CIP_CON_MGR_ERROR_INVALID_O_TO_T_CONNECTION_TYPE}
const CIP_CON_MGR_ERROR_INVALID_T_TO_O_CONNECTION_TYPE = $124;
{$EXTERNALSYM CIP_CON_MGR_ERROR_INVALID_T_TO_O_CONNECTION_TYPE}
const CIP_CON_MGR_ERROR_INVALID_O_TO_T_CONNECTION_SIZE = $127;
{$EXTERNALSYM CIP_CON_MGR_ERROR_INVALID_O_TO_T_CONNECTION_SIZE}
const CIP_CON_MGR_ERROR_INVALID_T_TO_O_CONNECTION_SIZE = $128;
{$EXTERNALSYM CIP_CON_MGR_ERROR_INVALID_T_TO_O_CONNECTION_SIZE}
const CIP_CON_MGR_ERROR_NO_MORE_CONNECTIONS_AVAILABLE = $0113;
{$EXTERNALSYM CIP_CON_MGR_ERROR_NO_MORE_CONNECTIONS_AVAILABLE}
const CIP_CON_MGR_ERROR_VENDERID_OR_PRODUCTCODE_ERROR = $0114;
{$EXTERNALSYM CIP_CON_MGR_ERROR_VENDERID_OR_PRODUCTCODE_ERROR}
const CIP_CON_MGR_ERROR_DEVICE_TYPE_ERROR = $0115;
{$EXTERNALSYM CIP_CON_MGR_ERROR_DEVICE_TYPE_ERROR}
const CIP_CON_MGR_ERROR_REVISION_MISMATCH = $0116;
{$EXTERNALSYM CIP_CON_MGR_ERROR_REVISION_MISMATCH}
const CIP_CON_MGR_INVALID_CONFIGURATION_APP_PATH = $0129;
{$EXTERNALSYM CIP_CON_MGR_INVALID_CONFIGURATION_APP_PATH}
const CIP_CON_MGR_INVALID_CONSUMING_APPLICATION_PATH = $012A;
{$EXTERNALSYM CIP_CON_MGR_INVALID_CONSUMING_APPLICATION_PATH}
const CIP_CON_MGR_INVALID_PRODUCING_APPLICATION_PATH = $012B;
{$EXTERNALSYM CIP_CON_MGR_INVALID_PRODUCING_APPLICATION_PATH}
const CIP_CON_MGR_INCONSISTENT_APPLICATION_PATH_COMBO = $012F;
{$EXTERNALSYM CIP_CON_MGR_INCONSISTENT_APPLICATION_PATH_COMBO}
const CIP_CON_MGR_NON_LISTEN_ONLY_CONNECTION_NOT_OPENED = $0119;
{$EXTERNALSYM CIP_CON_MGR_NON_LISTEN_ONLY_CONNECTION_NOT_OPENED}
const CIP_CON_MGR_ERROR_PARAMETER_ERROR_IN_UNCONNECTED_SEND_SERVICE = $0205;
{$EXTERNALSYM CIP_CON_MGR_ERROR_PARAMETER_ERROR_IN_UNCONNECTED_SEND_SERVICE}
const CIP_CON_MGR_ERROR_INVALID_SEGMENT_TYPE_IN_PATH = $0315;
{$EXTERNALSYM CIP_CON_MGR_ERROR_INVALID_SEGMENT_TYPE_IN_PATH}
const CIP_CON_MGR_TARGET_OBJECT_OUT_OF_CONNECTIONS = $011A;
{$EXTERNALSYM CIP_CON_MGR_TARGET_OBJECT_OUT_OF_CONNECTIONS}

const CIP_CONN_PRODUCTION_TRIGGER_MASK = $70;
{$EXTERNALSYM CIP_CONN_PRODUCTION_TRIGGER_MASK}
const CIP_CONN_CYCLIC_CONNECTION = $0;
{$EXTERNALSYM CIP_CONN_CYCLIC_CONNECTION}
const CIP_CONN_COS_TRIGGERED_CONNECTION = $10;
{$EXTERNALSYM CIP_CONN_COS_TRIGGERED_CONNECTION}
const CIP_CONN_APLICATION_TRIGGERED_CONNECTION = $20;
{$EXTERNALSYM CIP_CONN_APLICATION_TRIGGERED_CONNECTION}

(*macros for comparing sequence numbers according to CIP spec vol 2 3-4.2*)
function SEQ_LEQ32(a, b: integer): Bool;
function SEQ_GEQ32(a, b: integer): Bool;

(* similar macros for comparing 16 bit sequence numbers *)
function SEQ_LEQ16(a, b: SmallInt): Bool;
function SEQ_GEQ16(a, b: SmallInt): Bool;
function SEQ_GT32(a,b: Integer): Bool;
{$EXTERNALSYM SEQ_GT32}

(*! States of a connection *)
const CONN_STATE_NONEXISTENT = 0;
const CONN_STATE_CONFIGURING = 1;
const CONN_STATE_WAITINGFORCONNECTIONID = 2 (* only used in DeviceNet*);
const CONN_STATE_ESTABLISHED = 3;
const CONN_STATE_TIMEDOUT = 4;
const CONN_STATE_DEFERREDDELETE = 5 (* only used in DeviceNet *);
const CONN_STATE_CLOSING	= 6;

type
	CONN_STATE = CONN_STATE_NONEXISTENT..CONN_STATE_CLOSING;
	{$EXTERNALSYM CONN_STATE}


(* instance_type attributes *)
const enConnTypeExplicit         = 0;
const enConnTypeIOExclusiveOwner = $01;
const enConnTypeIOInputOnly      = $11;
const enConnTypeIOListenOnly     = $21;

type
	EConnType = enConnTypeExplicit..enConnTypeIOListenOnly;
	{$EXTERNALSYM EConnType}

(*! Possible values for the watch dog time out action of a connection *)
const enWatchdogTransitionToTimedOut = 0; (*!< ; invalid for explicit message connections *)
const enWatchdogAutoDelete = 1; (*!< Default for explicit message connections; default for I/O connections on EIP*)
const enWatchdogAutoReset = 2; (*!< Invalid for explicit message connections *)
const enWatchdogDeferredDelete = 3;

type
  EWatchdogTimeOutAction = enWatchdogTransitionToTimedOut..enWatchdogDeferredDelete;

type  	
	S_Link_Consumer = record 
		state: CONN_STATE;	
		ConnectionID: EIP_UINT16;	
(*TODO think if this is needed anymore
		m_ptfuncReceiveData: TCMReceiveDataFunc;	 *)
	end;
	TS_Link_Consumer = S_Link_Consumer;
	{$EXTERNALSYM TS_Link_Consumer}


type  	
	S_Link_Producer = record 
		state: CONN_STATE;	
		ConnectionID: EIP_UINT16;	
	end;
	TS_Link_Producer = S_Link_Producer;
	{$EXTERNALSYM TS_Link_Producer}


type  	
	S_Link_Object = record 
		Consumer: S_Link_Consumer;	
		Producer: S_Link_Producer;	
	end;
	TS_Link_Object = S_Link_Object;
	{$EXTERNALSYM TS_Link_Object}


(*! The data needed for handling connections. This data is strongly related to
 * the connection object defined in the CIP-specification. However the full
 * functionality of the connection object is not implemented. Therefore this
 * data can not be accessed with CIP means.
 *)
type  	
	CIP_ConnectionObject = record 
		State: CONN_STATE;	
		m_eInstanceType: EConnType;	
  (* conditional
		DeviceNetProductedConnectionID: UINT16;	
		DeviceNetConsumedConnectionID: UINT16;	
   *)
		DeviceNetInitialCommCharacteristics: EIP_BYTE;	
		ProducedConnectionSize: EIP_UINT16;	
		ConsumedConnectionSize: EIP_UINT16;
		ExpectedPacketRate: EIP_UINT16;	
  (*conditional*)
		CIPProducedConnectionID: EIP_UINT32;	
		CIPConsumedConnectionID: EIP_UINT32;	
  (**)
		WatchdogTimeoutAction: EWatchdogTimeOutAction;	
		ProducedConnectionPathLength: EIP_UINT16;	
		ProducedConnectionPath: S_CIP_EPATH;
		ConsumedConnectionPathLength: EIP_UINT16;	
		ConsumedConnectionPath: S_CIP_EPATH;	
  (* conditional
		ProductionInhibitTime: UINT16;	
   *)
  (* non CIP Attributes, only relevant for opened connections *)
		Priority_Timetick: EIP_BYTE;	
		Timeoutticks: EIP_UINT8;	
		ConnectionSerialNumber: EIP_UINT16;	
		OriginatorVendorID: EIP_UINT16;	
		OriginatorSerialNumber: EIP_UINT32;	
		ConnectionTimeoutMultiplier: EIP_UINT16;	
		O_to_T_RPI: EIP_UINT32;	
		O_to_T_NetworkConnectionParameter: EIP_UINT16;	
		T_to_O_RPI: EIP_UINT32;	
		T_to_O_NetworkConnectionParameter: EIP_UINT16;	
		TransportTypeClassTrigger: EIP_BYTE;	
		ConnectionPathSize: EIP_UINT8;	
		ElectronicKey: S_CIP_ElectronicKey;	
		ConnectionPath: S_CIP_ConnectionPath;	 (* padded EPATH*)
		stLinkObject: S_Link_Object;	
		p_stConsumingInstance: ^S_CIP_Instance;	
		(*S_CIP_CM_Object *p_stConsumingCMObject; *)
		p_stProducingInstance: ^S_CIP_Instance;	
		(*S_CIP_CM_Object *p_stProducingCMObject; *)
		EIPSequenceCountProducing: EIP_UINT32;	 (* the EIP level sequence Count for Class 0/1 Producing Connections may have a different value than SequenceCountProducing*)
		EIPSequenceCountConsuming: EIP_UINT32;	 (* the EIP level sequence Count for Class 0/1 Producing Connections may have a different value than SequenceCountProducing*)
		SequenceCountProducing: EIP_UINT16;	 (* sequence Count for Class 1 Producing Connections*)
		SequenceCountConsuming: EIP_UINT16;	 (* sequence Count for Class 1 Producing Connections*)
		TransmissionTriggerTimer: EIP_INT32;	
		InnacitvityWatchdogTimer: EIP_INT32;	
  (*! Minimal time between the production of two application triggered or change of state triggered
   * I/O connection messages
   *)
		m_unProductionInhibitTime: EIP_UINT16;	
  (*! Timer for the production inhibition of application triggered or change-of-state
   *  I/O connections.
   *)
		m_nProductionInhibitTimer: EIP_INT32;	
		remote_addr: sockaddr_in;	 (* socket address for produce *)
		m_stOriginatorAddr: sockaddr_in;	  (* the address of the originator that established the connection. needed for scanning if the right packet is arriving *)
		sockfd: array[0..1] of Integer; (* socket handles, indexed by CONSUMING or PRODUCING *)
  (* pointers to connection handling functions *)
		m_pfCloseFunc: TConnCloseFunc;	
		m_pfTimeOutFunc: TConnTimeOutFunc;	
		m_pfSendDataFunc: TConnSendDataFunc;	
		m_pfReceiveDataFunc: TConnRecvDataFunc;	
  (* pointers to be used in the active connection list *)
		m_pstNext: ^ CIP_ConnectionObject;	
		m_pstFirst: ^ CIP_ConnectionObject;	
		CorrectOTSize: EIP_UINT16;	
		CorrectTOSize: EIP_UINT16;	
	end;
	S_CIP_ConnectionObject = CIP_ConnectionObject;
	{$EXTERNALSYM S_CIP_ConnectionObject}


const CIP_CONNECTION_MANAGER_CLASS_CODE = $06;
{$EXTERNALSYM CIP_CONNECTION_MANAGER_CLASS_CODE}

(* public functions *)

(*! Initialize the data of the connection manager object
 *)
function Connection_Manager_Init(pa_nUniqueConnID: EIP_UINT16): EIP_STATUS;

(*!  Get a connected object dependent on requested ConnectionID.
 *
 *   @param ConnectionID  requested ConnectionID of opened connection
 *   @Result:= aPointer to connected Object
 *           0 .. connection not present in device
 *)
function getConnectedObject(ConnectionID: EIP_UINT32): ^S_CIP_ConnectionObject;

(*!  Get a connection object for a given output assembly.
 *
 *   @param pa_unOutputAssemblyId requested output assembly of requested connection
 *   @Result:= aPointer to connected Object
 *           0 .. connection not present in device
 *)
function getConnectedOutputAssembly(pa_unOutputAssemblyId: EIP_UINT32): ^S_CIP_ConnectionObject;

(*! Copy the given connection data from pa_pstSrc to pa_pstDst
 *)
procedure copyConnectionData(
	var pa_pstDst: S_CIP_ConnectionObject;
	var pa_pstSrc: S_CIP_ConnectionObject);

(** \brief Close the given connection
 *
 * This aFunction will take the data form the connection and correctly closes the connection (e.g., open sockets)
 * @param pa_pstConnObj aPointer to the connection object structure to be closed
 *)
procedure closeConnection(var pa_pstConnObj: S_CIP_ConnectionObject);

function isConnectedOutputAssembly(pa_nInstanceNr: EIP_UINT32): EIP_BOOL8;

(** \brief Generate the ConnectionIDs and set the general configuration parameter
 * in the given connection object.
 *
 * @param pa_pstConnObj aPointer to the connection object that should be set up.
 *)
procedure generalConnectionConfiguration(var pa_pstConnObj: S_CIP_ConnectionObject);


(** \brief Insert the given connection object to the list of currently active and managed connections.
 *
 * By adding a connection to the active connection list the connection manager will
 * perform the supervision and handle the timing (e.g., timeout, production inhibit, etc).
 *
 * @param pa_pstConn aPointer to the connection object to be added.
 *)
procedure addNewActiveConnection(var pa_pstConn: S_CIP_ConnectionObject);

procedure removeFromActiveConnections(var pa_pstConn: S_CIP_ConnectionObject);

implementation

function SEQ_LEQ32(a, b: integer): Bool;
begin
  Result := (a - b) <= 0;
end;

function SEQ_GEQ32(a, b: integer): Bool;
begin
  Result := (a - b) >= 0;
end;

function SEQ_LEQ16(a, b: SmallInt): Bool;
begin
  Result := (a - b) <= 0;
end;

function SEQ_GEQ16(a, b: SmallInt): Bool;
begin
  Result := (a - b) >= 0;
end;

function SEQ_GT32(a,b: Integer): Bool;
begin
  Result := (a - b) > 0;
end;

end.
