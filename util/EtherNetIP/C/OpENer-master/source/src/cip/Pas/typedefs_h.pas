(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit typedefs_h;

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
(*
 Do not use interface types for internal variables, such as 'int i;', which is
 commonly used for loop counters or counting things.

 Do not over-constrain data types. Prefer the use of the native 'int' and
 'unsigned' types.

*)

const EIP_BYTE = uint8;
{$EXTERNALSYM EIP_BYTE}
const EIP_INT8 = int8;
{$EXTERNALSYM EIP_INT8}
const EIP_INT16 = int16;
{$EXTERNALSYM EIP_INT16}
const EIP_INT32 = int32;
{$EXTERNALSYM EIP_INT32}
const EIP_UINT8 = uint8;
{$EXTERNALSYM EIP_UINT8}
const EIP_UINT16 = uint16;
{$EXTERNALSYM EIP_UINT16}
const EIP_UINT32 = uint32;
{$EXTERNALSYM EIP_UINT32}
const EIP_FLOAT = Single;
{$EXTERNALSYM EIP_FLOAT}
const EIP_DFLOAT = Double;
{$EXTERNALSYM EIP_DFLOAT}
const EIP_BOOL8 = Integer;
{$EXTERNALSYM EIP_BOOL8}

{$ifdef OPENER_SUPPORT_64BIT_DATATYPES}
const EIP_INT64 = int64_t;
{$EXTERNALSYM EIP_INT64}
const EIP_UINT64 = uint64_t;
{$EXTERNALSYM EIP_UINT64}
{$endif}

(* Constant identifying if a socket descriptor is invalid *)
const EIP_INVALID_SOCKET = -1;
{$EXTERNALSYM EIP_INVALID_SOCKET}

(*
 The following are generally true regarding Result:= status:
 -1 Args: array of const an = error occurred;
{$EXTERNALSYM an}
 0 Args: array of const success = ;
{$EXTERNALSYM success}

 Occasionally there is a variation on this:
 -1 Args: array of const an = error occurred;
{$EXTERNALSYM an}
 0 ..  success and there is no reply to send
 1 Args: array of const success = and there is a reply to send;
{$EXTERNALSYM success}

 For both of these cases EIP_STATUS is the Result:= aType.

 Other Result:= aType are:
 -- Result:= aPointer to thing, 0 if error (Result:= aType is 'pointer to thing') then 
 -- Result:= count of something, -1 if error, (Result:= aType is Integer) then 
 *)

type
	EIP_STATUS = (EIP_ERROR = -1, EIP_OK = 0, EIP_OK_SEND = 1);
	{$EXTERNALSYM EIP_STATUS}
	

const false = 0;
{$EXTERNALSYM false}
const true = 1;
{$EXTERNALSYM true}

implementation

end.
