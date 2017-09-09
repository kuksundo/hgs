(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit encap_h;

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
{$ifndef ENCAP_H_}
{$define ENCAP_H_}

{$HPPEMIT '#include 'typedefs.h''}


(**  \defgroup ENCAP OpENer Ethernet encapsulation layer
 * The Ethernet encapsulation layer handles provides the abstraction between the Ethernet and the CIP layer.
 *)

(*** defines ***)

const ENCAPSULATION_HEADER_LENGTH = 24;
{$EXTERNALSYM ENCAPSULATION_HEADER_LENGTH}
const OPENER_ETHERNET_PORT = $AF12;
{$EXTERNALSYM OPENER_ETHERNET_PORT}

(* definition of status codes in encapsulation protocol *)
const OPENER_ENCAP_STATUS_SUCCESS = $0000;
{$EXTERNALSYM OPENER_ENCAP_STATUS_SUCCESS}
const OPENER_ENCAP_STATUS_INVALID_COMMAND = $0001;
{$EXTERNALSYM OPENER_ENCAP_STATUS_INVALID_COMMAND}
const OPENER_ENCAP_STATUS_INSUFFICIENT_MEM = $0002;
{$EXTERNALSYM OPENER_ENCAP_STATUS_INSUFFICIENT_MEM}
const OPENER_ENCAP_STATUS_INCORRECT_DATA = $0003;
{$EXTERNALSYM OPENER_ENCAP_STATUS_INCORRECT_DATA}
const OPENER_ENCAP_STATUS_INVALID_SESSION_HANDLE = $0064;
{$EXTERNALSYM OPENER_ENCAP_STATUS_INVALID_SESSION_HANDLE}
const OPENER_ENCAP_STATUS_INVALID_LENGTH = $0065;
{$EXTERNALSYM OPENER_ENCAP_STATUS_INVALID_LENGTH}
const OPENER_ENCAP_STATUS_UNSUPPORTED_PROTOCOL = $0069;
{$EXTERNALSYM OPENER_ENCAP_STATUS_UNSUPPORTED_PROTOCOL}


(*** structs ***)
 S_Encapsulation_Data
  begin 
    EIP_UINT16 nCommand_code;
    EIP_UINT16 nData_length;
    EIP_UINT32 nSession_handle;
    EIP_UINT32 nStatus;
    (* The sender context is not needed any more with the new minimum data copy design *)
    (* EIP_UINT8 anSender_context[SENDER_CONTEXT_SIZE];  *)
    EIP_UINT32 nOptions;
    EIP_UINT8 *m_acCommBufferStart;       (*Pointer to the communication buffer used for this message *)
    EIP_UINT8 *m_acCurrentCommBufferPos;  (*The current position in the communication buffer during the decoding process *)
  );

 S_Encapsulation_Interface_Information
  begin 
    EIP_UINT16 TypeCode;
    EIP_UINT16 Length;
    EIP_UINT16 EncapsulationProtocolVersion;
    EIP_UINT16 CapabilityFlags;
    EIP_INT8 NameofService[16];
  );

(*** global variables (public) ***)

(*** public functions ***)
(*! \ingroup ENCAP 
 * brief Initialize the encapsulation layer.
 *)
procedure encapInit();

(*! \ingroup ENCAP
 * brief Shutdown the encapsulation layer.
 *
 * This means that all open sessions including their sockets are closed.
 *)
procedure encapShutDown();


(*! \ingroup ENCAP
 * brief Handle delayed encapsulation message responses
 *
 * Certain encapsulation message requests require a delayed sending of the response
 * message. This functions checks if messages need to be sent and performs the
 * sending.
 *)
procedure manageEncapsulationMessages();

{$endif}	(*ENCAP_H_*/

implementation

end.
