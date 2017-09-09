(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit cipidentity_h;

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

const CIP_IDENTITY_CLASS_CODE = $01;
{$EXTERNALSYM CIP_IDENTITY_CLASS_CODE}

const CIP_IDENTITY_STATUS_OWNED = $0001;
{$EXTERNALSYM CIP_IDENTITY_STATUS_OWNED}
const CIP_IDENTITY_STATUS_CONFIGURED = $0004;
{$EXTERNALSYM CIP_IDENTITY_STATUS_CONFIGURED}
const CIP_IDENTITY_STATUS_MINOR_RECOV_FLT = $0100;
{$EXTERNALSYM CIP_IDENTITY_STATUS_MINOR_RECOV_FLT}
const CIP_IDENTITY_STATUS_MINOR_UNRECOV_FLT = $0200;
{$EXTERNALSYM CIP_IDENTITY_STATUS_MINOR_UNRECOV_FLT}
const CIP_IDENTITY_STATUS_MAJOR_RECOV_FLT = $0400;
{$EXTERNALSYM CIP_IDENTITY_STATUS_MAJOR_RECOV_FLT}
const CIP_IDENTITY_STATUS_MAJOR_UNRECOV_FLT = $0800;
{$EXTERNALSYM CIP_IDENTITY_STATUS_MAJOR_UNRECOV_FLT}

const CIP_IDENTITY_EXTENDED_STATUS_SELFTESTING_UNKNOWN = $0000;
{$EXTERNALSYM CIP_IDENTITY_EXTENDED_STATUS_SELFTESTING_UNKNOWN}
const CIP_IDENTITY_EXTENDED_STATUS_FIRMEWARE_UPDATE_IN_PROGRESS = $0010;
{$EXTERNALSYM CIP_IDENTITY_EXTENDED_STATUS_FIRMEWARE_UPDATE_IN_PROGRESS}
const CIP_IDENTITY_EXTENDED_STATUS_AT_LEAST_ONE_FAULTED_IO_CONNECTION = $0020;
{$EXTERNALSYM CIP_IDENTITY_EXTENDED_STATUS_AT_LEAST_ONE_FAULTED_IO_CONNECTION}
const CIP_IDENTITY_EXTENDED_STATUS_NO_IO_CONNECTIONS_ESTABLISHED = $0030;
{$EXTERNALSYM CIP_IDENTITY_EXTENDED_STATUS_NO_IO_CONNECTIONS_ESTABLISHED}
const CIP_IDENTITY_EXTENDED_STATUS_NON_VOLATILE_CONFIGURATION_BAD = $0040;
{$EXTERNALSYM CIP_IDENTITY_EXTENDED_STATUS_NON_VOLATILE_CONFIGURATION_BAD}
const CIP_IDENTITY_EXTENDED_STATUS_MAJOR_FAULT = $0050;
{$EXTERNALSYM CIP_IDENTITY_EXTENDED_STATUS_MAJOR_FAULT}
const CIP_IDENTITY_EXTENDED_STATUS_AT_LEAST_ONE_IO_CONNECTION_IN_RUN_MODE = $0060;
{$EXTERNALSYM CIP_IDENTITY_EXTENDED_STATUS_AT_LEAST_ONE_IO_CONNECTION_IN_RUN_MODE}
const CIP_IDENTITY_EXTENDED_STATUS_AT_LEAST_ONE_IO_CONNECTION_ESTABLISHED_ALL_IN_IDLE_MODE = $0070;
{$EXTERNALSYM CIP_IDENTITY_EXTENDED_STATUS_AT_LEAST_ONE_IO_CONNECTION_ESTABLISHED_ALL_IN_IDLE_MODE}

(* global public variables *)

(* public functions *)
function CIP_Identity_Init(): EIP_STATUS;
{$endif}	(*CIPIDENTITY_H_*/

implementation

end.
