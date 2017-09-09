(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit cipclass3connection_h;

//{$I AlGun.inc}

interface

(*
** 'C2PTypes.pas' declares external windows data types for the conversion purposes.
** It's created by the CtoPas converter and saved under
** "\Program Files\Common Files\AlGun Shared\CToPas 2.0\P_Files" folder.
** Consult the Windows and Delphi help files for more information about defined data types
*)

uses
	C2PTypes, Windows, Messages, SysUtils, Classes, typedefs_h, opener_api_h;


(*******************************************************************************
 * Copyright (c) 2011, Rockwell Automation, Inc.
 * All rights reserved.
 *
 ******************************************************************************)

{$HPPEMIT '#include <opener_api.h>'}

(** \brief Check if Class3 connection is available and if yes setup all data.
 *
 * This aFunction can be called after all data has been parsed from the forward open request
 * @param pa_pstConnObj aPointer to the connection object structure holding the parsed data from the forward open request
 * @param pa_pnExtendedError the extended error code in  an error happened
 * @Result:= general status on the establishment
 *    - EIP_OK Args: array of const on = success;
{$EXTERNALSYM on}
 *    - On an error the general status code to be put into the response
 *)
function establishClass3Connection(var pa_pstConnObj: CIP_ConnectionObject; var pa_pnExtendedError: EIP_UINT16): Integer;

procedure initializeClass3ConnectionData;

implementation

end.
