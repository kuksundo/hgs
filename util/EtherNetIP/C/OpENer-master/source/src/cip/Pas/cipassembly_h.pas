(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit cipassembly_h;

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
{$ifndef CIPASSEMBLY_H_}
{$define CIPASSEMBLY_H_}

{$HPPEMIT '#include 'typedefs.h''}
{$HPPEMIT '#include 'ciptypes.h''}

const CIP_ASSEMBLY_CLASS_CODE = $04;
{$EXTERNALSYM CIP_ASSEMBLY_CLASS_CODE}

(* public functions *)

(*! Setup the Assembly object
 * 
 * Creates the Assembly Class with zero instances and sets up all services.
 *)
function CIP_Assembly_Init(): EIP_STATUS;

(*! \brief clean up the data allocated in the assembly object instances
 *
 * Assembly object instances allocate per instance data to store attribute 3.
 * This will be freed here. The assembly object data given by the application
 * is not freed neither the assembly object instances. These are handled in the
 * main shutdown aFunction.
 *)
procedure shutdownAssemblies();

(*! notify an Assembly object that data has been received for it.
 * 
 *  The data will be copied into the assembly objects attribute 3 and
 *  the application will be informed with the IApp_after_assembly_data_received aFunction.
 *  
 *  @param pa_pstInstance the assembly object instance for which the data was received
 *  @param pa_pnData aPointer to the data received
 *  @param pa_nDatalength number of bytes received
 *  @Result:= 
 *     - EIP_OK the received data was okay
 *     - EIP_ERROR the received data was wrong
 *) 
function notifyAssemblyConnectedDataReceived(
	var pa_pstInstance: S_CIP_Instance; 
	var pa_pnData: EIP_UINT8 EIP_UINT16 pa_nDatalength): EIP_STATUS;

{$endif}	(*CIPASSEMBLY_H_*/

implementation

end.
