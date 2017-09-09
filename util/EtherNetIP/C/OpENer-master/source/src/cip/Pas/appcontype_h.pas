(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit appcontype_h;

//{$I AlGun.inc}

interface

(*
** 'C2PTypes.pas' declares external windows data types for the conversion purposes.
** It's created by the CtoPas converter and saved under
** "\Program Files\Common Files\AlGun Shared\CToPas 2.0\P_Files" folder.
** Consult the Windows and Delphi help files for more information about defined data types
*)

uses
	C2PTypes, Windows, Messages, SysUtils, Classes, opener_api_h, typedefs_h, cipconnectionmanager_h;


(*******************************************************************************
 * Copyright (c) 2009, Rockwell Automation, Inc.
 * All rights reserved.
 *
 ******************************************************************************)
{$HPPEMIT '#include 'cipconnectionmanager.h''}

procedure initializeIOConnectionData();

(*! \brief check if for the given connection data received in a forward_open request
 *  a suitable connection is available.
 *
 *  If a suitable connection is found the connection data is transfered the
 *  application connection aType is set (i.e., EConnType).
 *  @param pa_pstConnData connection data to be used
 *  @param pa_pnExtendedError if an error occurred this value has the according
 *     error code for the response
 *  @Result:=
 *        - on success: A aPointer to the connection object already containing the connection
 *          data given in pa_pstConnData.
 *        - on error: 0
 *)
function getIOConnectionForConnectionData(var pa_pstConnData: ^S_CIP_ConnectionObject;
    pa_pnExtendedError: ^EIP_UINT16): ^S_CIP_ConnectionObject;

(*! \brief Check if there exists already an exclusive owner or listen only connection
 *         which produces the input assembly.
 *
 *  @param pa_unInputPoint the Input point to be produced
 *  @Result:= if a connection could be found a aPointer to this connection if not 0
 *)
function getExistingProdMulticastConnection(pa_unInputPoint: EIP_UINT32): ^S_CIP_ConnectionObject;

(*! \brief check if there exists an producing multicast exclusive owner or
 * listen only connection that should produce the same input but is not in charge
 * of the connection.
 *
 * @param pa_unInputPoint the produced input
 * @Result:= if a connection could be found the aPointer to this connection
 *      otherwise 0.
 *)
function getNextNonCtrlMasterCon(pa_unInputPoint: EIP_UINT32): ^S_CIP_ConnectionObject;

(*! \brief Close all connection producing the same input and have the same type
 * (i.e., listen only or input only).
 *
 * @param pa_unInputPoint  the input point
 * @param pa_eInstanceType the connection application aType
 *)
procedure closeAllConnsForInputWithSameType(
	pa_unInputPoint: EIP_UINT32; 
	pa_eInstanceType: EConnType);


(*!\brief close all open connections.
 *
 * For I/O connections the sockets will be freed. The sockets for explicit
 * connections are handled by the encapsulation layer, and freed there.
 *)
procedure closeAllConnections();


(*! \brief Check if there is an established connection that uses the same
 * config point.
 *)
function connectionWithSameConfigPointExists(pa_unConfigPoint: EIP_UINT32): EIP_BOOL8;

implementation

end.
