(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit cpf_h;

{$I AlGun.inc}

interface

(*
** 'C2PTypes.pas' declares external windows data types for the conversion purposes.
** It's created by the CtoPas converter and saved under
** "\Program Files\Common Files\AlGun Shared\CToPas 2.0\P_Files" folder.
** Consult the Windows and Delphi help files for more information about defined data types
*)

uses
	C2PTypes, Windows, Messages, SysUtils, Classes;


(*******************************************************************************
 * Copyright (c) 2009, Rockwell Automation, Inc.
 * All rights reserved. 
 *
 ******************************************************************************)
{$ifndef _CPF_H}
{$define _CPF_H}

{$HPPEMIT '#include 'typedefs.h''}
{$HPPEMIT '#include 'ciptypes.h''}
{$HPPEMIT '#include 'encap.h''}

(*) CPF is Common Packet Format
 CPF packet := <number of items> begin <items> end;
 item := <TypeID> <Length> <data>
 <number of items> := two bytes
 <TypeID> := two bytes
 <Length> := two bytes
 <data> := <the number of bytes specified by Length>
 *)

(* define Item ID numbers used for address and data items in CPF structures *)
const CIP_ITEM_ID_NULL = $0000;	(* Null Address Item *)
{$EXTERNALSYM CIP_ITEM_ID_NULL}
const CIP_ITEM_ID_LISTIDENTITY_RESPONSE = $000C;
{$EXTERNALSYM CIP_ITEM_ID_LISTIDENTITY_RESPONSE}
const CIP_ITEM_ID_CONNECTIONBASED = $00A1;	(* Connected Address Item *)
{$EXTERNALSYM CIP_ITEM_ID_CONNECTIONBASED}
const CIP_ITEM_ID_CONNECTIONTRANSPORTPACKET = $00B1;	(* Connected Data Item *)
{$EXTERNALSYM CIP_ITEM_ID_CONNECTIONTRANSPORTPACKET}
const CIP_ITEM_ID_UNCONNECTEDMESSAGE = $00B2;	(* Unconnected Data Item *)
{$EXTERNALSYM CIP_ITEM_ID_UNCONNECTEDMESSAGE}
const CIP_ITEM_ID_LISTSERVICE_RESPONSE = $0100;
{$EXTERNALSYM CIP_ITEM_ID_LISTSERVICE_RESPONSE}
const CIP_ITEM_ID_SOCKADDRINFO_O_TO_T = $8000;	(* Sockaddr info item originator to target (data) *)
{$EXTERNALSYM CIP_ITEM_ID_SOCKADDRINFO_O_TO_T}
const CIP_ITEM_ID_SOCKADDRINFO_T_TO_O = $8001;	(* Sockaddr info item target to originator (data) *)
{$EXTERNALSYM CIP_ITEM_ID_SOCKADDRINFO_T_TO_O}
const CIP_ITEM_ID_SEQUENCEDADDRESS = $8002;	(* Sequenced Address item *)
{$EXTERNALSYM CIP_ITEM_ID_SEQUENCEDADDRESS}

type  	
	S_Address_Data = record 
		ConnectionIdentifier: EIP_UINT32;	
		SequenceNumber: EIP_UINT32;	
	end;
	TS_Address_Data = S_Address_Data;
	{$EXTERNALSYM TS_Address_Data}


type  	
	S_Address_Item = record 
		TypeID: EIP_UINT16;	
		Length: EIP_UINT16;	
		Data: S_Address_Data;	
	end;
	TS_Address_Item = S_Address_Item;
	{$EXTERNALSYM TS_Address_Item}


type  	
	S_Data_Item = record 
		TypeID: EIP_UINT16;	
		Length: EIP_UINT16;	
		Data: ^EIP_UINT8;	
	end;
	TS_Data_Item = S_Data_Item;
	{$EXTERNALSYM TS_Data_Item}


type  	
	S_SockAddrInfo_Item = record 
		TypeID: EIP_UINT16;	
		Length: EIP_UINT16;	
		nsin_family: EIP_INT16;	
		nsin_port: EIP_UINT16;	
		nsin_addr: EIP_UINT32;	
		EIP_UINT8 nasin_zero[8];
	end;
	TS_SockAddrInfo_Item = S_SockAddrInfo_Item;
	{$EXTERNALSYM TS_SockAddrInfo_Item}


(* this one case of a CPF packet is supported:*)

type  	
	S_CIP_CPF_Data = record 
		ItemCount: EIP_UINT16;	
		stAddr_Item: S_Address_Item;	
		stDataI_Item: S_Data_Item;	
		S_SockAddrInfo_Item AddrInfo[2];
	end;
	TS_CIP_CPF_Data = S_CIP_CPF_Data;
	{$EXTERNALSYM TS_CIP_CPF_Data}


(*! \ingroup ENCAP
 * Parse the CPF data from a received unconnected explicit message and
 * hand the data on to the message router 
 *
 * @param  pa_stReceiveData aPointer to the encapsulation structure with the received message
 * @param  pa_acReplyBuf reply buffer
 * @Result:= number of bytes to be sent back. < 0 if nothing should be sent
 *)
function notifyCPF(
	var pa_stReceiveData: S_Encapsulation_Data; 
	var pa_acReplyBuf: EIP_UINT8): Integer;

(*! \ingroup ENCAP
 * Parse the CPF data from a received connected explicit message, check
 * the connection status, update any timers, and hand the data on to 
 * the message router 
 *
 * @param  pa_stReceiveData aPointer to the encapsulation structure with the received message
 * @param  pa_acReplyBuf reply buffer
 * @Result:= number of bytes to be sent back. < 0 if nothing should be sent
 *)
function notifyConnectedCPF(
	var pa_stReceiveData: S_Encapsulation_Data; 
	var pa_acReplyBuf: EIP_UINT8): Integer;

(*! \ingroup ENCAP
 *  Create CPF structure out of the received data.
 *  @param  pa_Data		aPointer to data which need to be structured.
 *  @param  pa_DataLength	length of data in pa_Data.
 *  @param  pa_CPF_data	aPointer to structure of CPF data item.
 *  @Result:= status
 * 	       EIP_OK .. success
 * 	       EIP_ERROR .. error
 *)
function createCPFstructure(
	var pa_Data: EIP_UINT8;  Integer pa_DataLength,
	var pa_CPF_data: S_CIP_CPF_Data): EIP_STATUS;

(*! \ingroup ENCAP
 * Copy data from MRResponse  and CPFDataItem into linear memory in pa_msg for transmission over in encapsulation.
 * @param  pa_MRResponse	aPointer to message router response which has to be aligned into linear memory.
 * @param  pa_CPFDataItem	aPointer to CPF structure which has to be aligned into linear memory.
 * @param  pa_msg		aPointer to linear memory.
 * @Result:= length of reply in pa_msg in bytes
 * 	   EIP_ERROR .. error
 *)
function assembleLinearMsg(
	var pa_MRResponse: S_CIP_MR_Response; 
	var pa_CPFDataItem: S_CIP_CPF_Data EIP_UINT8 * pa_msg): Integer;

(*!\ingroup ENCAP 
 * brief Data storage for the any cpf data
 * Currently we are single threaded and need only one cpf at the time.
 * For future extensions towards multithreading maybe more cpf data items may be necessary
 *)
 S_CIP_CPF_Data g_stCPFDataItem;

{$endif}

implementation

end.
