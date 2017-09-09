(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit cipethernetlink_h;

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
{$HPPEMIT '#include 'typedefs.h''}
{$HPPEMIT '#include 'ciptypes.h''}

const CIP_ETHERNETLINK_CLASS_CODE = $F6;
{$EXTERNALSYM CIP_ETHERNETLINK_CLASS_CODE}

(* public functions *)
(*!Initialize the Ethernet Link Objects data
 *)
function CIP_Ethernet_Link_Init(): EIP_STATUS;

implementation

end.
