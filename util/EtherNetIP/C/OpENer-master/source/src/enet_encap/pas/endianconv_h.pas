(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit endianconv_h;

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
{$ifndef ENDIANCONV_H_}
{$define ENDIANCONV_H_}

{$HPPEMIT '#include 'typedefs.h''}

const OPENER_LITTLE_ENDIAN_PLATFORM = 0;
{$EXTERNALSYM OPENER_LITTLE_ENDIAN_PLATFORM}
const OPENER_BIG_ENDIAN_PLATFORM = 1;
{$EXTERNALSYM OPENER_BIG_ENDIAN_PLATFORM}

(*! \ingroup ENCAP
 * Get an 16Bit integer from the network buffer.
 * @param pa_buf aPointer to the network buffer aArray. This aPointer will be incremented by 2 not 
 *)EIP_UINT16
ltohs(EIP_UINT8 **pa_buf);

(*! \ingroup ENCAP
 * Get an 32Bit integer from the network buffer.
 * @param pa_buf aPointer to the network buffer aArray. This aPointer will be incremented by 4 not 
 *)EIP_UINT32
ltohl(EIP_UINT8 **pa_buf);

(*! \ingroup ENCAP
 * Write an 16Bit integer to the network buffer.
 * @param data value to write
 * @param pa_buf aPointer to the network buffer aArray. This aPointer will be incremented by 2 not 
 *)
procedure
htols(data: EIP_UINT16; var pa_buf: EIP_UINT8);

(*! \ingroup ENCAP
 * Write an 32Bit integer to the network buffer.
 * @param data value to write
 * @param pa_buf aPointer to the network buffer aArray. This aPointer will be incremented by 4 not 
 *)
procedure
htoll(data: EIP_UINT32; var pa_buf: EIP_UINT8);

{$ifdef OPENER_SUPPORT_64BIT_DATATYPES}

EIP_UINT64
ltoh64(EIP_UINT8 ** pa_pnBuf);

procedure
htol64(pa_unData: EIP_UINT64; var  pa_pnBuf: EIP_UINT8);

{$endif}

procedure
encapsulateIPAdress(
	pa_unPort: EIP_UINT16;  EIP_UINT32 pa_unAddr,
	var pa_acCommBuf: EIP_BYTE);

(*!\brief Encapsulate the sockaddr information as necessary for the CPF data items
 *)
procedure
encapsulateIPAdressCPF(
	pa_unPort: EIP_UINT16;  EIP_UINT32 pa_unAddr,
	var pa_acCommBuf: EIP_BYTE);



(** Identify if we are running on a big or little endian system and set
 * variable.
 *)
procedure determineEndianess();

(** Return the endianess identified on system startup
 * Result:=
 *    - -1 endianess has not been identified up to now
 *    - 0  little endian system
 *    - 1  big endian system
 *)
function getEndianess(): Integer;

{$endif}	(*ENDIANCONV_H_*/

implementation

end.
