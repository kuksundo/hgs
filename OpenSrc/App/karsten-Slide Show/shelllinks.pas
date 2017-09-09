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
 * The Original Code is sammelklassen.pas of Karsten Bilderschau, version 3.3.4.
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

{ $Id: shelllinks.pas 128 2008-11-26 05:25:10Z hiisi $ }

{
@abstract Utility functions that deal with shell links
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2006-09-30
@cvs $Date: 2008-11-25 23:25:10 -0600 (Di, 25 Nov 2008) $
}
unit shelllinks;

interface
uses
  Windows, SysUtils, Classes, ShlObj, ComObj, ActiveX;

{ Creates a new shell link object and returns its interface.
  The path parameter sets the target path of the link.
  If path is empty the link target is left undefined. }
function CreateShellLink(const path: string): IShellLink;

{ Reads the path stored in a shell link
  without trying to resolve it.

  @returns(Path, or empty string if ShellLink = @nil.)
  @raises(EOleSysError if the IShellLink.GetPath method fails.) }
function GetShellLinkPath(const ShellLink: IShellLink): string;

{ Writes a shell link to the stream opened in a TWriter object. }
procedure WriteShellLink(const ShellLink: IShellLink; const Writer: TWriter);

{ Formats the persistent data of a shell link into a string of hex numbers }
function FormatShellLinkString(const ShellLink: IShellLink): string;

{ Reads a shell link from the stream opened in a TReader object
  in the way it was written by @link(WriteShellLink).
  ShellLink must exist, and Reader must be at the correct position.
  The procedure does not check if the stream content to be read
  actually corresponds to a shell link. }
procedure ReadShellLink(const ShellLink: IShellLink; const Reader: TReader);

{ Reads a shell link from a string of hex numbers
  in the way it was written by @link(FormatShellLinkString).
  ShellLink must exist.
  The procedure does not check if the string
  actually corresponds to a shell link. }
procedure ParseShellLinkString(const ShellLink: IShellLink; const s: string);

{ Resolves a shell link and returns the resolved path in UNC format.

  @param(Wnd is the parent window if a message box must be displayed.
    If 0, the function asks for No-UI mode.)

  @returns(Resolved path, or empty string if the link cannot be resolved.)
  @raises(EOleSysError if the IShellLink.GetPath method fails.) }
function ResolveShellLink(const ShellLink: IShellLink; Wnd: HWND): string;

{ Copies the contents of one shell link into another one.
  Both arguments must be valid shell link interfaces. }
procedure CloneShellLink(const Source, Dest: IShellLink);

implementation

function CreateShellLink;
begin
  OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IShellLink, Result));
  if Length(Path) > 0 then OleCheck(Result.SetPath(pChar(path)));
end;

procedure WriteShellLink;
var
  PS: IPersistStream;
  Stream: IStream;
  hGlob: THandle;
  pGlob: PByte;
  count: cardinal;
begin
  PS := ShellLink as IPersistStream;
  OleCheck(CreateStreamOnHGlobal(0, true, Stream));
  OleCheck(PS.Save(Stream, true));
  OleCheck(GetHGlobalFromStream(Stream, hGlob));
  count := GlobalSize(hGlob);
  if count = 0 then RaiseLastOSError;
  pGlob := PByte(GlobalLock(hGlob));
  if not Assigned(pGlob) then RaiseLastOSError;
  try
    Writer.WriteInteger(count);
    Writer.Write(pGlob^, count);
  finally
    GlobalUnlock(hGlob);
  end;
end;

function FormatShellLinkString;
var
  PS: IPersistStream;
  Stream: IStream;
  hGlob: THandle;
  pGlob: PByteArray;
  count: integer;
  idx: integer;
begin
  result := '';
  PS := ShellLink as IPersistStream;
  OleCheck(CreateStreamOnHGlobal(0, true, Stream));
  OleCheck(PS.Save(Stream, true));
  OleCheck(GetHGlobalFromStream(Stream, hGlob));
  count := GlobalSize(hGlob);
  if count = 0 then RaiseLastOSError;
  pGlob := PByteArray(GlobalLock(hGlob));
  if not Assigned(pGlob) then RaiseLastOSError;
  try
    for idx := 0 to count - 1 do
      result := result + IntToHex(pGlob^[idx], 2);
  finally
    GlobalUnlock(hGlob);
  end;
end;

procedure ReadShellLink;
var
  PS: IPersistStream;
  Stream: IStream;
  hGlob: THandle;
  pGlob: PByte;
  count: cardinal;
begin
  count := Reader.ReadInteger;
  PS := ShellLink as IPersistStream;
  hGlob := GlobalAlloc(gmem_Moveable or gmem_NoDiscard, count);
  if hGlob = 0 then RaiseLastOSError;
  try
    pGlob := PByte(GlobalLock(hGlob));
    if not Assigned(pGlob) then RaiseLastOSError;
    try
      Reader.Read(pGlob^, count);
    finally
      GlobalUnlock(hGlob);
    end;
    OleCheck(CreateStreamOnHGlobal(hGlob, false, Stream));
    OleCheck(PS.Load(Stream));
  finally
    GlobalFree(hGlob);
  end;
end;

procedure ParseShellLinkString;
var
  PS: IPersistStream;
  Stream: IStream;
  hGlob: THandle;
  pGlob: PByteArray;
  count: integer;
  idx: integer;
begin
  count := Length(s) div 2;
  PS := ShellLink as IPersistStream;
  hGlob := GlobalAlloc(gmem_Moveable or gmem_NoDiscard, count);
  if hGlob = 0 then RaiseLastOSError;
  try
    pGlob := PByteArray(GlobalLock(hGlob));
    if not Assigned(pGlob) then RaiseLastOSError;
    try
      for idx := 0 to count - 1 do
        pGlob^[idx] := StrToInt('$' + Copy(s, idx * 2 + 1, 2));
    finally
      GlobalUnlock(hGlob);
    end;
    OleCheck(CreateStreamOnHGlobal(hGlob, false, Stream));
    OleCheck(PS.Load(Stream));
  finally
    GlobalFree(hGlob);
  end;
end;

function GetShellLinkPath;
var
  Win32FindData: TWin32FindData;
begin
  if Assigned(ShellLink) then begin
    SetLength(result, MAX_PATH);
    OleCheck(ShellLink.GetPath(PChar(result), MAX_PATH, Win32FindData, SLGP_UNCPRIORITY));
    SetLength(result, StrLen(PChar(result)));
  end else
    result := '';
end;

function ResolveShellLink;
var
  flags: dword;
  Win32FindData: TWin32FindData;
begin
  flags := SLR_ANY_MATCH or SLR_UPDATE;
  if Wnd = 0 then flags := flags or SLR_NO_UI;
  if Assigned(ShellLink) and Succeeded(ShellLink.Resolve(Wnd, flags)) then begin
    SetLength(result, MAX_PATH);
    OleCheck(ShellLink.GetPath(PChar(result), MAX_PATH, Win32FindData, SLGP_UNCPRIORITY));
    SetLength(result, StrLen(PChar(result)));
  end else
    result := '';
end;

procedure CloneShellLink;
var
  SourcePS, DestPS: IPersistStream;
  SourceStream, DestStream: IStream;
begin
  SourcePS := Source as IPersistStream;
  DestPS := Dest as IPersistStream;
  OleCheck(CreateStreamOnHGlobal(0, true, SourceStream));
  OleCheck(SourceStream.Clone(DestStream));
  OleCheck(SourcePS.Save(SourceStream, true));
  OleCheck(DestPS.Load(DestStream));
end;

end.
