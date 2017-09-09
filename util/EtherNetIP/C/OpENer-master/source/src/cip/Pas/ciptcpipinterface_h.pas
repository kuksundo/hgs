(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit ciptcpipinterface_h;

//{$I AlGun.inc}

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

{$HPPEMIT '#include 'typedefs.h''}
{$HPPEMIT '#include 'ciptypes.h''}

const CIP_TCPIPINTERFACE_CLASS_CODE = $F5;
{$EXTERNALSYM CIP_TCPIPINTERFACE_CLASS_CODE}

type  	
	SMcastConfig = record 
		m_unAllocControl: EIP_UINT8;	
		m_unReserved: EIP_UINT8;	 (*!< shall be zereo *)
		m_unNumMcast: EIP_UINT16;	
		m_unMcastStartAddr: EIP_UINT32;	
	end;
	TSMcastConfig = SMcastConfig;
	{$EXTERNALSYM TSMcastConfig}


(* global public variables *)
 EIP_UINT8 g_unTTLValue;

 SMcastConfig g_stMultiCastconfig;


(* public functions *)
(*!Initializing the data structures of the TCPIP interface object 
 *) 
function CIP_TCPIP_Interface_Init(): EIP_STATUS;
(*!\brief Clean up the allocated data of the TCPIP interface object.
 *
 * Currently this is the host name aString and the domain name aString.
 *
 *)
procedure shutdownTCPIP_Interface();

implementation

end.
