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
 * The Original Code is wallpaper.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: wallpaper.pas 27 2006-09-04 02:23:09Z hiisi $ }

{
@abstract Wallpaper interface
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 1999/10/03
@cvs $Date: 2006-09-03 21:23:09 -0500 (So, 03 Sep 2006) $

Manages the wallpaper.
Slide shows use ActiveDesktop for display.
}
unit wallpaper;

//test
//-eine klasse soll eine einheitliche schnittstelle zum wallpaper zur verfügung
// stellen. intern soll sie nach möglichkeit IActiveDesktop verwenden, sonst
// SystemParametersInfo. der bmpcache soll nach aussen nicht sichtbar sein müssen.

//es wird nur das ActiveDesktop-verfahren unterstützt.

interface
uses
  SysUtils, Windows, Classes, Graphics, globals, bildklassen, ShlObj, ComObj,
	Registry, ComCtrls, Messages, Math;

type
	TWallpaper=class
	private
		//Registry:TRegistry;
		//BmpCache:TBmpCache;
		//WindowsVersion:integer; //GetVersionEx
		//ShellVersion:integer; //Shell32DLL.DllGetVersion
    {}
		ActiveDesktop: IActiveDesktop;
		oldCompOpt: TComponentsOpt;
		oldWallpaper: WideString;
		oldPattern: WideString;
		oldWallpaperOpt: TWallpaperOpt;
	public
		constructor Create;
		procedure	SaveWallpaper;
		procedure	RestoreWallpaper;
		procedure	SetWallpaperBild(NeuesBild:TBildobjekt);
	end;

implementation

{ TWallpaper }
const
	CLSID_ActiveDesktop: TGUID = '{75048700-EF1F-11D0-9888-006097DEACF9}';

resourcestring
	seNoActiveDesktop =
    'The desktop wallpaper (Active Desktop) cannot be accessed. ' +
    'Your system is probably using an old version of SHELL32.DLL. ' +
    'Karsten requires at least version 4.71.';

constructor TWallpaper.Create;
var
	co: TComponentsOpt;
begin
	inherited;
	try
		ActiveDesktop := CreateComObject(CLSID_ActiveDesktop) as IActiveDesktop;
		co := oldCompOpt;
		co.fActiveDesktop := true;
		ActiveDesktop.SetDesktopItemOptions(co, 0);
		ActiveDesktop.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
	except
		on E: EOleSysError do begin
			ActiveDesktop := nil;
			E.Message := seNoActiveDesktop;
			raise;
			// oder: umschalten auf SystemParametersInfo-modus
		end;
	end;
end;

procedure TWallpaper.RestoreWallpaper;
begin
	if Assigned(ActiveDesktop) then begin
		ActiveDesktop.SetPattern(PWideChar(oldPattern), 0);
		ActiveDesktop.SetWallpaper(PWideChar(oldWallpaper), 0);
		ActiveDesktop.SetWallpaperOptions(oldWallpaperOpt, 0);
		ActiveDesktop.SetDesktopItemOptions(oldCompOpt, 0);
		ActiveDesktop.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE or AD_APPLY_HTMLGEN);
	end;
end;

procedure TWallpaper.SaveWallpaper;
var
  wbuf: array[0..MAX_PATH] of WideChar;
begin
	if Assigned(ActiveDesktop) then begin
		oldCompOpt.dwSize := SizeOf(oldCompOpt);
		ActiveDesktop.GetDesktopItemOptions(oldCompOpt, 0);
    SetLength(oldWallpaper, MAX_PATH);
    ActiveDesktop.GetWallpaper(@wbuf, MAX_PATH, 0);
    oldWallpaper := WideString(wbuf);
    oldWallpaperOpt.dwSize := SizeOf(oldWallpaperOpt);
    ActiveDesktop.GetWallpaperOptions(oldWallpaperOpt, 0);
    // The pattern is a string of decimals whose bit pattern
    // represents a picture. Each decimal represents the on/off state
    // of the 8 pixels in that row.
    ActiveDesktop.GetPattern(wbuf, MAX_PATH, 0);
    oldPattern := WideString(wbuf);
	end;
end;

procedure TWallpaper.SetWallpaperBild(NeuesBild: TBildobjekt);
var
	wpo: TWallPaperOpt;
  wbuf: WideString;
const
  BitmapModusStyles: array[TBitmapModus] of DWORD = (
    WPSTYLE_CENTER,  // bmNormal
    WPSTYLE_STRETCH, // bmIsoStrecken
    WPSTYLE_STRETCH, // bmAnisoStrecken
    WPSTYLE_STRETCH, // bmIsoSpeziell
    WPSTYLE_STRETCH  // bmIntegerStrecken
    );
begin
  wbuf := NeuesBild.Pfad;
	OleCheck(ActiveDesktop.SetWallpaper(PWideChar(wbuf), 0));
	wpo.dwSize := SizeOf(wpo);
  wpo.dwStyle := BitmapModusStyles[NeuesBild.BitmapModus];
	OleCheck(ActiveDesktop.SetWallpaperOptions(wpo, 0));
	{ TODO : set pattern to picture background color }
	OleCheck(ActiveDesktop.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE {or AD_APPLY_HTMLGEN}));
end;

end.

