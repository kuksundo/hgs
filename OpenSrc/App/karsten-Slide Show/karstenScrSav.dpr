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
 * The Original Code is Karsten Bilderschau, version 3.2.12.
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
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
{ $Id: karstenScrSav.dpr 129 2008-11-29 01:44:21Z hiisi $ }
{
@abstract Screen saver program
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2000/02/19
@cvs $Date: 2008-11-28 19:44:21 -0600 (Fr, 28 Nov 2008) $

This program launches a karsten screensaver.
It creates an invisible main window that communicates
with the main program karsten.exe through the COM interface.
}
program karstenScrSav;



{%File 'karstenScrSav.tlb'}

uses
  {$ifdef madExcept}
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  {$endif}
  gnugettext,
  Forms,
  Dialogs,
  Windows,
  SysUtils,
  globals,
  karsreg,
  scrsav.mainform in 'scrsav.mainform.pas' {ScrMain},
  KarstenScrSav_TLB in 'KarstenScrSav_TLB.pas',
  scrsav.client in 'scrsav.client.pas';

{$E scr}

{$R *.TLB}

{$R *.RES}

var
  Arg1, Arg2: string;
  SysDir: string;
  NewLen: integer;
  MyMod: THandle;
  PwdFunc: function(a: PChar; ParentHandle: THandle; b, c: integer): integer; stdcall;
  Reg: TUserRegistry;
  iColon: integer;

begin
  ssMode := ssConfig;
  Arg1 := UpperCase(ParamStr(1));
  Arg2 := UpperCase(ParamStr(2));
  if (Copy(Arg1,1,2) = '/S') or (Copy(Arg1,1,2) = '-S') or
     (Copy(Arg1,1,1) = 'S') then
    SSMode := ssNormal;
  if (Copy(Arg1,1,2) = '/A') or (Copy(Arg1,1,2) = '-A') or
     (Copy(Arg1,1,1) = 'A') then
    SSMode := ssSetPwd;
  if (Copy(Arg1,1,2) = '/P') or (Copy(Arg1,1,2) = '-P') or
     (Copy(Arg1,1,1) = 'P') then
    begin
      SSMode := ssPreview;
      iColon := LastDelimiter(':',arg1);
      if iColon>0 then arg2 := Copy(arg1,iColon+1,32);
    end;
  if (Copy(Arg1,1,2) = '/C') or (Copy(Arg1,1,2) = '-C') or
     (Copy(Arg1,1,1) = 'C') or (Arg1 = '') then
    SSMode := ssConfig;

  if SSMode = ssSetPwd then begin
    SetLength(SysDir, MAX_PATH);
    NewLen := GetSystemDirectory(PChar(SysDir), MAX_PATH);
    SetLength(SysDir, NewLen);
    if (Length(SysDir) > 0) and (SysDir[Length(SysDir)] <> '\') then
      SysDir := SysDir+'\';
    MyMod := LoadLibrary(PChar(SysDir + 'MPR.DLL'));
    if MyMod <> 0 then begin
      PwdFunc := GetProcAddress(MyMod, 'PwdChangePasswordA');
      if Assigned(PwdFunc) then
        PwdFunc('SCRSAVE', StrToInt(Arg2), 0, 0);
      FreeLibrary(MyMod);
    end;
    Halt;
  end;

  Application.Initialize;
  Application.Title := 'Karsten ScreenSaver';
  if SSMode = ssPreview then begin
    DemoWnd := StrToInt(Arg2);
    while not IsWindowVisible(DemoWnd) do Application.ProcessMessages;
  end else demoWnd:=0;

  Application.CreateForm(TScrMain, ScrMain);
  Reg := TUserRegistry.Create;
  try
    if (ssMode=ssPreview) or not Reg.ScrShowControlWin then
      Application.ShowMainForm := false;
  finally
    Reg.Free;
  end;

  Application.Run;
end.
