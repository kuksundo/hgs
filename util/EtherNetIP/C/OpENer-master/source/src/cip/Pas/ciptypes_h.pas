(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit ciptypes_h;

//{$I AlGun.inc}

interface

(*
** 'C2PTypes.pas' declares external windows data types for the conversion purposes.
** It's created by the CtoPas converter and saved under
** "\Program Files\Common Files\AlGun Shared\CToPas 2.0\P_Files" folder.
** Consult the Windows and Delphi help files for more information about defined data types
*)

uses
	C2PTypes, Windows, Messages, SysUtils, Classes, typedefs_h;


(*******************************************************************************
 * Copyright (c) 2009, Rockwell Automation, Inc.
 * All rights reserved.
 *
 ******************************************************************************)
//{$ifndef CIPTYPES_H_}
//{$define CIPTYPES_H_}

{$HPPEMIT '#include 'typedefs.h''}

(* TODO -- find some portable way of defining all these with enums rather than #defines so that the names rather than hex number are displayed in the debugger*)
{$ifdef __GNUC__}
//const SEG_PORT = $00;
//const SEG_EXTPORT = $10;
//const SEG_CLASS = $20;
//const SEG_INSTANCE = $24;
//const SEG_ATTRIBUTE = $30;
//const SEG_NETWORK = $40;
//const SEG_PACKED_SIZE = ENUM_INT8;

//type
//	SEG_TYPE = SEG_PORT..SEG_PACKED_SIZE	PACKED;
//	{$EXTERNALSYM SEG_TYPE}

{$else}
const SEG_PORT = $00;
{$EXTERNALSYM SEG_PORT}
const SEG_EXTPORT = $10;
{$EXTERNALSYM SEG_EXTPORT}
const SEG_CLASS = $20;
{$EXTERNALSYM SEG_CLASS}
const SEG_INSTANCE = $24;
{$EXTERNALSYM SEG_INSTANCE}
const SEG_ATTRIBUTE = $30;
{$EXTERNALSYM SEG_ATTRIBUTE}
const SEG_NETWORK = $40;
{$EXTERNALSYM SEG_NETWORK}
{$endif}

(* definition of CIP basic data types *)
const CIP_ANY = $00;	(*data type that can not be directly encoded *)
{$EXTERNALSYM CIP_ANY}
const CIP_BOOL = $C1;
{$EXTERNALSYM CIP_BOOL}
const CIP_SINT = $C2;
{$EXTERNALSYM CIP_SINT}
const CIP_INT = $C3;
{$EXTERNALSYM CIP_INT}
const CIP_DINT = $C4;
{$EXTERNALSYM CIP_DINT}
const CIP_LINT = $C5;
{$EXTERNALSYM CIP_LINT}
const CIP_USINT = $C6;
{$EXTERNALSYM CIP_USINT}
const CIP_UINT = $C7;
{$EXTERNALSYM CIP_UINT}
const CIP_UDINT = $C8;
{$EXTERNALSYM CIP_UDINT}
const CIP_ULINT = $C9;
{$EXTERNALSYM CIP_ULINT}
const CIP_REAL = $CA;
{$EXTERNALSYM CIP_REAL}
const CIP_LREAL = $CB;
{$EXTERNALSYM CIP_LREAL}
const CIP_STIME = $CC;
{$EXTERNALSYM CIP_STIME}
const CIP_DATE = $CD;
{$EXTERNALSYM CIP_DATE}
const CIP_TIME_OF_DAY = $CE;
{$EXTERNALSYM CIP_TIME_OF_DAY}
const CIP_DATE_AND_TIME = $CF;
{$EXTERNALSYM CIP_DATE_AND_TIME}
const CIP_STRING = $D0;
{$EXTERNALSYM CIP_STRING}
const CIP_BYTE = $D1;
{$EXTERNALSYM CIP_BYTE}
const CIP_WORD = $D2;
{$EXTERNALSYM CIP_WORD}
const CIP_DWORD = $D3;
{$EXTERNALSYM CIP_DWORD}
const CIP_LWORD = $D4;
{$EXTERNALSYM CIP_LWORD}
const CIP_STRING2 = $D5;
{$EXTERNALSYM CIP_STRING2}
const CIP_FTIME = $D6;
{$EXTERNALSYM CIP_FTIME}
const CIP_LTIME = $D7;
{$EXTERNALSYM CIP_LTIME}
const CIP_ITIME = $D8;
{$EXTERNALSYM CIP_ITIME}
const CIP_STRINGN = $D9;
{$EXTERNALSYM CIP_STRINGN}
const CIP_SHORT_STRING = $DA;
{$EXTERNALSYM CIP_SHORT_STRING}
const CIP_TIME = $DB;
{$EXTERNALSYM CIP_TIME}
const CIP_EPATH = $DC;
{$EXTERNALSYM CIP_EPATH}
const CIP_ENGUNIT = $DD;
{$EXTERNALSYM CIP_ENGUNIT}

(* definition of some CIP structs *)
(* need to be validated in IEC 1131-3 subclause 2.3.3 *)
const CIP_USINT_USINT = $A0;
{$EXTERNALSYM CIP_USINT_USINT}
const CIP_UDINT_UDINT_UDINT_UDINT_UDINT_STRING = $A1;
{$EXTERNALSYM CIP_UDINT_UDINT_UDINT_UDINT_UDINT_STRING}
const CIP_6USINT = $A2;	(* for MAC Address*)
{$EXTERNALSYM CIP_6USINT}
const CIP_MEMBER_LIST = $A3;
{$EXTERNALSYM CIP_MEMBER_LIST}
const CIP_BYTE_ARRAY = $A4;
{$EXTERNALSYM CIP_BYTE_ARRAY}

const INTERNAL_UINT16_6 = $f0;	(* bogus hack, for port class attribute 9, TODO figure out the right way to handle it *)
{$EXTERNALSYM INTERNAL_UINT16_6}

(* definition of CIP service codes *)
const CIP_GET_ATTRIBUTE_SINGLE = $0E;
{$EXTERNALSYM CIP_GET_ATTRIBUTE_SINGLE}
const CIP_SET_ATTRIBUTE_SINGLE = $10;
{$EXTERNALSYM CIP_SET_ATTRIBUTE_SINGLE}
const CIP_RESET = $05;
{$EXTERNALSYM CIP_RESET}
const CIP_CREATE = $08;
{$EXTERNALSYM CIP_CREATE}
const CIP_GET_ATTRIBUTE_ALL = $01;
{$EXTERNALSYM CIP_GET_ATTRIBUTE_ALL}
const CIP_FORWARD_OPEN = $54;
{$EXTERNALSYM CIP_FORWARD_OPEN}
const CIP_FORWARD_CLOSE = $4E;
{$EXTERNALSYM CIP_FORWARD_CLOSE}
const CIP_UNCONNECTED_SEND = $52;
{$EXTERNALSYM CIP_UNCONNECTED_SEND}
const CIP_GET_CONNECTION_OWNER = $5A;
{$EXTERNALSYM CIP_GET_CONNECTION_OWNER}

(* definition of Flags for CIP Attributes *)
const CIP_ATTRIB_NONE = $00;
{$EXTERNALSYM CIP_ATTRIB_NONE}
const CIP_ATTRIB_GETABLEALL = $01;
{$EXTERNALSYM CIP_ATTRIB_GETABLEALL}
const CIP_ATTRIB_GETABLESINGLE = $02;
{$EXTERNALSYM CIP_ATTRIB_GETABLESINGLE}
const CIP_ATTRIB_SETABLE = $04;
{$EXTERNALSYM CIP_ATTRIB_SETABLE}
(*combined for conveniance *)
const CIP_ATTRIB_SETGETABLE = $07;	(* both set and getable *)
{$EXTERNALSYM CIP_ATTRIB_SETGETABLE}
const CIP_ATTRIB_GETABLE = $03;	(* both single and all *)
{$EXTERNALSYM CIP_ATTRIB_GETABLE}

type
	EIOConnectionEvent = (enOpened,enTimedOut,enClosed);
{$EXTERNALSYM EIOConnectionEvent}


type
	S_CIP_Byte_Array = record
		len: EIP_UINT16;
		Data: ^EIP_BYTE;
	end;
//	TS_CIP_Byte_Array = S_CIP_Byte_Array;
//	{$EXTERNALSYM TS_CIP_Byte_Array}


type
	S_CIP_Short_String = record
		Length: EIP_UINT8;
		aString: ^EIP_BYTE;
	end;
//	TS_CIP_Short_String = S_CIP_Short_String;
//	{$EXTERNALSYM TS_CIP_Short_String}

type
	S_CIP_String = record
		Length: EIP_INT16;
		aString: ^EIP_BYTE;
	end;
//	TS_CIP_String = S_CIP_String;
//	{$EXTERNALSYM TS_CIP_String}

type
	S_CIP_EPATH = packed record
		PathSize: EIP_UINT8;
		ClassID: EIP_UINT16;
		InstanceNr: EIP_UINT16;
		AttributNr: EIP_UINT16;
	end;
//	TS_CIP_EPATH = S_CIP_EPATH;
//{$EXTERNALSYM TS_CIP_EPATH}

type
	S_CIP_ConnectionPath = record 
		PathSize: EIP_UINT8;	
		ClassID: EIP_UINT32;	
		ConnectionPoint: array[0..2] of EIP_UINT32;
		DataSegment: EIP_UINT8;	
		SegmentData: ^EIP_UINT8;	
	end;
//	TS_CIP_ConnectionPath = S_CIP_ConnectionPath;
//	{$EXTERNALSYM TS_CIP_ConnectionPath}

type
	S_CIP_KeyData = record 
		VendorID: EIP_UINT16;
		DeviceType: EIP_UINT16;	
		ProductCode: EIP_UINT16;	
		MajorRevision: EIP_BYTE;	
		MinorRevision: EIP_UINT8;
	end;
//	TS_CIP_KeyData = S_CIP_KeyData;
//	{$EXTERNALSYM TS_CIP_KeyData}

type  	
	S_CIP_Revision = record 
		MajorRevision: EIP_UINT8;	
		MinorRevision: EIP_UINT8;
	end;
//	TS_CIP_Revision = S_CIP_Revision;
//	{$EXTERNALSYM TS_CIP_Revision}

type
	S_CIP_ElectronicKey = record 
		SegmentType: EIP_UINT8;	
		KeyFormat: EIP_UINT8;	
		KeyData: S_CIP_KeyData;	
	end;
//	TS_CIP_ElectronicKey = S_CIP_ElectronicKey;
//	{$EXTERNALSYM TS_CIP_ElectronicKey}

type  	
	S_CIP_MR_Request = packed record
		Service: EIP_UINT8;
		RequestPath: S_CIP_EPATH;
		DataLength: EIP_INT16;	
		Data: ^EIP_UINT8;	
	end;
//	TS_CIP_MR_Request = S_CIP_MR_Request;
//	{$EXTERNALSYM TS_CIP_MR_Request}

const MAX_SIZE_OF_ADD_STATUS = 2;	(* for now we support extended status codes up to 2 16bit values
									there is mostly only one 16bit value used *)
{$EXTERNALSYM MAX_SIZE_OF_ADD_STATUS}
type  	
	S_CIP_MR_Response = record 
		ReplyService: EIP_UINT8;	
		Reserved: EIP_UINT8;	
		GeneralStatus: EIP_UINT8;	
		SizeofAdditionalStatus: EIP_UINT8;	
		AdditionalStatus: array[0..MAX_SIZE_OF_ADD_STATUS-1] of EIP_UINT16;
		DataLength: EIP_INT16;	
		Data: ^EIP_UINT8;	
	end;
//	TS_CIP_MR_Response = S_CIP_MR_Response;
//	{$EXTERNALSYM TS_CIP_MR_Response}


type  	
	S_CIP_attribute_struct = record
		CIP_AttributNr: EIP_UINT16;	
		CIP_Type: EIP_UINT8;	
		CIP_AttributeFlags: EIP_BYTE;	 //bit 0: getable_all; bit 1: getable_single; bit 2: setable_single; bits 3-7 reserved
		pt2data: Pointer;	
	end;

(* type definition of CIP service sructure *)

(* instances are stored in a linked list*)
type
	S_CIP_Instance = record
		nInstanceNr: EIP_UINT32;	 (* this instance's number (unique within the class) *)
		pstAttributes: ^S_CIP_attribute_struct;	 (* pointer to an array of attributes which is unique to this instance *)
		pstClass: ^S_CIP_Class;	 (*!> class the instance belongs to *)
		pstNext: ^S_CIP_Instance;	 (*!> next instance, all instances of a class live in a linked list *)
	end;
//	S_CIP_Instance = CIP_Instance;
	{$EXTERNALSYM S_CIP_Instance}


type
	S_CIP_Class = record
     (* Class is a subclass of Instance*)
		m_stSuper: S_CIP_Instance;
  (* the rest of theswe are specific to the Class class only. *)
		nClassID: EIP_UINT32;	 (*!> class ID *)
		nRevision: EIP_UINT16;	 (*!> class revision*)
		nNr_of_Instances: EIP_UINT16;	 (*!> number of instances in the class (not including instance 0)*)
		nNr_of_Attributes: EIP_UINT16;	 (*!> number of attributes of each instance*)
		nMaxAttribute: EIP_UINT16;	 (*!> highest defined attribute number (attribute numbers are not necessarily consecutive)*)
		nGetAttrAllMask: EIP_UINT32;	 (*!> mask indicating which attributes are returned by getAttributeAll*)
		nNr_of_Services: EIP_UINT16;	 (*!> number of services supported*)
		pstInstances: ^S_CIP_Instance;	 (*!> pointer to the list of instances*)
		pstServices: ^CIP_service_struct;	 (*!> pointer to the array of services*)
		acName: PAnsiChar;	 (*!> class name *)
	end;
//	PS_CIP_Class = ^S_CIP_Class;
//	{$EXTERNALSYM S_CIP_Class}


(*! \ingroup CIP_API
 *  type  EIP_STATUS (TCIPServiceFunc)(S_CIP_Instance *pa_pstInstance, S_CIP_MR_Request *pa_MRRequest, S_CIP_MR_Response *pa_MRResponse)
 *  brief Signature definition for the implementation of CIP services.
 *
 *  CIP services have to follow this signature in order to be handled correctly by the stack.
 *  @param pa_pstInstance the instance which was referenced in the service request
 *  @param pa_MRRequest request data
 *  @param pa_MRResponse storage for the response data, including a buffer for extended data
 *  @Result:= EIP_OK_SEND if service could be executed successfully and a response should be sent
 *)
type
 TCIPServiceFunc = function(pa_pstInstance: ^S_CIP_Instance;
    pa_MRRequest: ^S_CIP_MR_Request; pa_MRResponse: ^S_CIP_MR_Response) : EIP_STATUS;


(* service descriptor. These are stored in an array*)
type  	
	CIP_service_struct = record
		CIP_ServiceNr: EIP_UINT8;	 (*!> service number*)
		m_ptfuncService: TCIPServiceFunc; (*!> pointer to a function call*)
		name: PAnsiChar;	 (*!> name of the service *)
	end;
//	S_CIP_service_type
//	 = CIP_service_struct = record
//	end;YM S_CIP_service_}

type
	S_CIP_TCPIPNetworkInterfaceConfiguration = record
		IPAddress: EIP_UINT32;
		NetworkMask: EIP_UINT32;
		Gateway: EIP_UINT32;
		NameServer: EIP_UINT32;
		NameServer2: EIP_UINT32;
		DomainName: S_CIP_String;
	end;
//	TS_CIP_TCPIPNetworkInterfaceConfiguration = S_CIP_TCPIPNetworkInterfaceConfiguration;
//	{$EXTERNALSYM TS_CIP_TCPIPNetworkInterfaceConfiguration}

type
	S_CIP_RPATH = record
		PathSize: EIP_UINT8;
		Port: EIP_UINT32;	 (* support up to 32 bit path*)
		Address: EIP_UINT32;
	end;
//	TS_CIP_RPATH = S_CIP_RPATH;
//	{$EXTERNALSYM TS_CIP_RPATH}

type  	
	CIP_UnconnectedSend_Param_Struct = record
		Priority: EIP_BYTE;	
		Timeout_Ticks: EIP_UINT8;
		Message_Request_Size: EIP_UINT16;
		Message_Request: S_CIP_MR_Request;
		Message_Response: ^S_CIP_MR_Response;
		Reserved: EIP_UINT8;
		Route_Path: S_CIP_RPATH;
		CPFdata: Pointer;
	end;
//	S_CIP_UnconnectedSend_Param_Struct = CIP_UnconnectedSend_Param_Struct;
//	{$EXTERNALSYM S_CIP_UnconnectedSend_Param_Struct}

(* these are used for creating the getAttributeAll masks
{$HPPEMIT 'TODO there might be a way simplifying this using __VARARGS__ in #define'}	*)
function MASK1(a: integer): integer;
function MASK2(a,b: integer): integer;
function MASK3(a,b,c: integer): integer;
function MASK4(a,b,c,d: integer): integer;
function MASK5(a,b,c,d,e: integer): integer;
function MASK6(a,b,c,d,e,f: integer): integer;
function MASK7(a,b,c,d,e,f,g: integer): integer;
function MASK8(a,b,c,d,e,f,g,h: integer): integer;

//{$endif}	(*CIPTYPES_H_*/

implementation

function MASK1(a: integer): integer;
begin
 Result := (1 shl (a));
end;

function MASK2(a,b: integer): integer;
begin
  Result := (1 shl (a)) or (1 shl (b));
end;

function MASK3(a,b,c: integer): integer;
begin
  Result := (1 shl (a)) or (1 shl (b)) or (1 shl (c));
end;

function MASK4(a,b,c,d: integer): integer;
begin
  Result := (1 shl (a)) or (1 shl (b)) or (1 shl (c)) or (1 shl (d));
end;

function MASK5(a,b,c,d,e: integer): integer;
begin
  Result := (1 shl (a)) or (1 shl (b)) or (1 shl (c)) or (1 shl (d)) or (1 shl (e));
end;

function MASK6(a,b,c,d,e,f: integer): integer;
begin
  Result := (1 shl (a)) or (1 shl (b)) or (1 shl (c)) or (1 shl (d)) or (1 shl (e)) or (1 shl (f));
end;

function MASK7(a,b,c,d,e,f,g: integer): integer;
begin
  Result := (1 shl (a)) or (1 shl (b)) or (1 shl (c)) or (1 shl (d)) or (1 shl (e)) or (1 shl (f)) or (1 shl (g));
end;

function MASK8(a,b,c,d,e,f,g,h: integer): integer;
begin
  Result := (1 shl (a)) or (1 shl (b)) or (1 shl (c)) or (1 shl (d)) or (1 shl (e)) or (1 shl (f)) or (1 shl (g)) or (1 shl (h));
end;

end.
