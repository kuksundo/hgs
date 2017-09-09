(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit cipioconnection_h;

{$I AlGun.inc}

interface

(*
** 'C2PTypes.pas' declares external windows data types for the conversion purposes.
** It's created by the CtoPas converter and saved under
** "\Program Files\Common Files\AlGun Shared\CToPas 2.0\P_Files" folder.
** Consult the Windows and Delphi help files for more information about defined data types
*)

uses
	C2PTypes, Windows, Messages, SysUtils, Classes, opener_api_h, typedefs_h;


(*******************************************************************************
 * Copyright (c) 2011, Rockwell Automation, Inc.
 * All rights reserved.
 *
 ******************************************************************************)

{$HPPEMIT '#include <opener_api.h>'}

(** \brief Setup all data in order to establish an IO connection
 *
 * This aFunction can be called after all data has been parsed from the forward open request
 * @param pa_pstConnObjData aPointer to the connection object structure holding the parsed data from the forward open request
 * @param pa_pnExtendedError the extended error code in  an error happened
 * @Result:= general status on the establishment
 *    - EIP_OK Args: array of const on = success;
{$EXTERNALSYM on}
 *    - On an error the general status code to be put into the response
 *)
function establishIOConnction(
	var pa_pstConnObjData: CIP_ConnectionObject; 
	var pa_pnExtendedError: EIP_UINT16): Integer;

(** \brief Take the data given in the connection object structure and open the necessary communication channels
 *
 * This aFunction will use the g_stCPFDataItem not 
 * @param pa_pstIOConnObj aPointer to the connection object data
 * @Result:= general status on the open process
 *    - EIP_OK Args: array of const on = success;
{$EXTERNALSYM on}
 *    - On an error the general status code to be put into the response
 *)
function openCommunicationChannels(	var pa_pstIOConnObj: CIP_ConnectionObject): Integer;

(* communication channels of the given connection and remove it
 * from the active connections list.
 *
 * @param pa_pstConnObjData aPointer to the connection object data
*)
procedure closeCommChannelsAndRemoveFromActiveConnsList(var pa_pstConnObjData: CIP_ConnectionObject);

var
  g_pnConfigDataBuffer: ^EIP_UINT8;
  g_unConfigDataLen: Cardinal;

implementation

end.
