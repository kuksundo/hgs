(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Karsten Bilderschau, version 3.5.2.
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: shell.pas 148 2010-02-20 20:31:17Z hiisi $ }

{
@abstract Windows Shell API
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2010-02-20 21:31:17 +0100 (Sa, 20 Feb 2010) $

This unit contains elements of the Windows API
which are not part of the libraries shipped with Delphi.
}
unit shell;

interface
uses
  Windows, ShlObj;

type
  { Win32 API }
  PSHChangeNotifyEntry = ^TSHChangeNotifyEntry;
  { Win32 API }
  TSHChangeNotifyEntry = record
    pidl: PItemIDList;
    fRecursive: BOOL;
  end;

{ Win32 shell API.
  Note: This function is available in windows XP SP2,
  and might become unavailable in future versions [MSDN].
  We link it dynamically, and do nothing if it is not available. }
function SHChangeNotifyRegister(Window: HWnd; fSources: integer; fEvents: longint;
  wMsg: UINT; cEntries: integer; pfsne: PSHChangeNotifyEntry): ULONG; stdcall; platform;

{ Win32 shell API.
  Note: This function is available in windows XP SP2,
  and might become unavailable in future versions [MSDN].
  We link it dynamically, and do nothing if it is not available. }
function SHChangeNotifyDeregister(ulID: ULONG): BOOL; stdcall; platform;

implementation

{ The SHChangeNotify functions are not available in all windows versions.
  We thus link them dynamically. }
const
  shell32 = 'shell32.dll';

var
  hShell32: HMODULE;

type
  TSHChangeNotifyRegister = function(Window: HWnd; fSources: integer; fEvents: longint;
    wMsg: UINT; cEntries: integer; pfsne: PSHChangeNotifyEntry): ULONG; stdcall;
  TSHChangeNotifyDeregister = function(ulID: ULONG): BOOL; stdcall;

var
  SHChangeNotifyRegisterProc: TSHChangeNotifyRegister;
  SHChangeNotifyDeregisterProc: TSHChangeNotifyDeregister;

function SHChangeNotifyRegister;
begin
  if @SHChangeNotifyRegisterProc <> nil then
    result := SHChangeNotifyRegisterProc(Window, fSources, fEvents, wMsg,
      cEntries, pfsne)
  else
    result := 0;
end;

function SHChangeNotifyDeregister(ulID: ULONG): BOOL;
begin
  if @SHChangeNotifyDeregisterProc <> nil then
    result := SHChangeNotifyDeregisterProc(ulID)
  else
    result := false;
end;

procedure InitSHChangeNotifyProc;
begin
  @SHChangeNotifyRegisterProc := nil;
  @SHChangeNotifyDeregisterProc := nil;
  hShell32 := LoadLibrary(shell32);
  if hShell32 <> 0 then begin
    @SHChangeNotifyRegisterProc := GetProcAddress(hShell32, 'SHChangeNotifyRegister');
    if @SHChangeNotifyRegisterProc <> nil then
      @SHChangeNotifyDeregisterProc := GetProcAddress(hShell32, 'SHChangeNotifyDeregister');
  end;
end;

procedure FinalSHChangeNotifyProc;
var
  lib: HMODULE;
begin
  @SHChangeNotifyRegisterProc := nil;
  @SHChangeNotifyDeregisterProc := nil;
  lib := hShell32;
  hShell32 := 0;
  if lib <> 0 then FreeLibrary(lib);
end;

initialization
  InitSHChangeNotifyProc;
finalization
  FinalSHChangeNotifyProc;
end.
