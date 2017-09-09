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
 * The Original Code is globals.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: globals.pas 148 2010-02-20 20:31:17Z hiisi $ }

{
@abstract Global types and constants
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2010-02-20 21:31:17 +0100 (Sa, 20 Feb 2010) $
}
unit globals;

interface
uses
  Windows, SysUtils, Graphics, Messages, Forms, Classes, Controls;

type
  { Wait time in seconds }
	TWartezeit = 1..100000;
  { Relative display frequency }
	THaeufigkeit = 0..10000;

	{ Display modes of the slide show }
	TAnzeigeModus = (
    amVersteckt,     //< Hidden window
    amNormal,        //< Normal size window (with borders)
    amMaximiert,     //< Full size window (with borders)
    amMinimiert,     //< Minimized window
    amMaxVollbild,   //< Full screen (window borders are painted over)
    amDesktopDirekt, //< Desktop device context
    amWallpaper,     //< Wallpaper (through ActiveDesktop)
    amRahmenlos,     //< Borderless, normal size window (borders are painted over)
    amExtern);       //< External window (of another process)

  { Bitmap stretch modes }
	TBitmapModus = (
    bmNormal,           //< Original size
    bmIsoStrecken,      //< Maximum stretch, keeping original aspect ratio
    bmAnisoStrecken,    //< Maximum stretch, neglegt aspect ratio
    bmIsoSpeziell,      //< User-defined stretch factor, keep original aspect ratio
    bmIntegerStrecken); //< Stretch by an integer multiple, keep original aspect ratio

  { Graphics format.
    Internally handled image types must come before the multimedia formats
    MCI, DirectShow, OLE which karsten does display on its own. }
	TGrafikformat = (
    gfUnbekannt,    //< unknown format
    gfBitmap,       //< BMP - Windows bitmap
    gfIcon,         //< ICO - Windows icon
    gfMetafile,     //< WMF,EMF - Windows metafile
    gfJPEG,         //< JPG, JPEG
    gfPNG,          //< PNG
    gfGIF,          //< GIF - currently not supported
    gfMCI,          //< various multimedia formats handled by the media control interface (deprecated)
    gfDirectShow,   //< various multimedia formats handled through DirectShow
    gfOLE);         //< OLE - currently not supported

  { Sort field }
	TSortierung = (
    sortKeine,        //< undefined
    sortName,         //< by title
    sortDateiname,    //< by file name
    sortDateipfad,    //< by file path
		sortWartezeit,    //< by display time
    sortHaeufigkeit,  //< by frequency
    sortSequence);    //< by sequence number

  { Reference tags for collection item properties }
	TSammelobjektProperty = (
    soaName,              //< title
    soaPfad,              //< path
    soaAktiv,             //< active
    soaStatus,            //< status
    soaBitmapModus,       //< bitmap stretch mode
    soaWartezeit,         //< display time
    soaHaeufigkeit,       //< frequency
    soaHintergrundfarbe,  //< background colour
    soaVergroesserung,    //< zoom factor
    soaSchluessel,        //< decryption key
    soaSequenceNumber);   //< sequence number

  { Set of collection item properties }
	TSammelobjektProperties = set of TSammelobjektProperty;

  { Extended list view style for the collection window.
    The first four items coincide with TViewStyle. }
  TCollectionViewStyle = (
    cvsIcon,         //< same as vsIcon
    cvsSmallIcon,    //< same as vsSmallIcon
    cvsList,         //< same as vsList
    cvsReport,       //< same as vsReport
    cvsFilmStrip);   //< vsIcon, but the list view is laid out horizontally (planned feature)

{ Non-localizable tags used in data files, registry, etc. }
const
  SBitmapModusTags: array[TBitmapModus] of string =
    ('normal', 'isostretch', 'stretch', 'custom', 'integerstretch');
  SGrafikformatTags: array[TGrafikformat] of string =
    ('unknown', 'bitmap', 'icon', 'metafile', 'jpeg', 'png', 'gif',
    'mci', 'directshow', 'ole');
  SSortierungTags: array[TSortierung] of string =
    ('none', 'title', 'filename', 'filepath', 'waittime', 'frequency',
    'sequence');
  SSammelobjektPropertyTags: array[TSammelobjektProperty] of string =
    ('title', 'filepath', 'active', 'status', 'bitmapmode', 'waittime',
    'frequency', 'backgroundcolor', 'zoom', 'key', 'seqnumber');
  SBooleanTags: array[boolean] of string =
    ('false', 'true');
  SRichtungTags: array[-1..1] of string =
    ('descending', 'undefined', 'ascending');

var
	sGrafikFormatName: array[TGrafikformat] of string;

const
	cDefWartezeit = 10;
	cDefHaeufigkeit = 100;
	cDefBitmapModus = bmNormal;
	cDefVergroesserung = 100;
	cDefHintergrundfarbe = clAppWorkspace;
	cDefSchluessel = 0;
  cDefSequenceNumber = 0;

	cFileVersion = 311;
  // This token appears in data files of older versions.
  // It must not be localized.
	cFileFormatName='Karsten Bildersammlung';

	soaAlle=[Low(TSammelobjektProperty)..High(TSammelobjektProperty)];

type
  { Base class for all exceptions generated by karsten code }
  EKarstenException = class(Exception);
  { Problem with a file }
	EDateiproblem = class(EKarstenException);
  { Empty picture folder }
	EOrdnerLeer = class(EDateiproblem);
  { File not found }
	EDateiFehlt = class(EDateiproblem);

resourcestring
	seOrdnerLeer = 'The folder "%s" contains no image files.';
	seDateiFehlt = 'The file "%s" cannot be found.';

//user-defined messages
const
	um_Weiterschalten = wm_User + 1;
	um_UserTerminate = wm_User + 2;
	um_SSActivate = wm_User + 3;
	um_SpecialPaint = wm_User + 4;
	um_CloseWindows = wm_User + 5;
  um_MediaEvent = wm_User + 6;
  um_JobDone = wm_User + 7;
  um_ShellChangeNotify = wm_User + 8;

{ Returns true if this process is the first running instance of the application.
  This function can be called multiple times in the same process. }
function IsFirstAppInstance: boolean;

implementation

uses
  JclAppInst, gnugettext, karsten_TLB, actnlist;

function IsFirstAppInstance: boolean;
begin
  with JclAppInstances do begin
    if InstanceCount = 0 then
      // CheckInstance can be called only once in a process
      result := CheckInstance(1)
    else
      result := ProcessIDs[0] = GetCurrentProcessId;
  end;
end;

resourcestring
	sgfUnbekannt = 'unknown';
	sgfBitmap = 'Bitmap';
	sgfIcon = 'Icon';
	sgfMetafile = 'Metafile';
	sgfJPEG = 'JPEG Image';
	sgfPNG = 'PNG Image';
	sgfGIF = 'GIF Image';
	sgfMCI = 'Media File';
	sgfOLE = 'OLE Object';

procedure	SetGrafikformatnamen;
begin
	sGrafikformatName[gfUnbekannt] := sgfUnbekannt;
	sGrafikformatName[gfBitmap] := sgfBitmap;
	sGrafikformatName[gfIcon] := sgfIcon;
	sGrafikformatName[gfMetafile] := sgfMetafile;
	sGrafikformatName[gfJPEG] := sgfJPEG;
	sGrafikformatName[gfPNG] := sgfPNG;
	sGrafikformatName[gfGIF] := sgfGIF;
	sGrafikformatName[gfMCI] := sgfMCI;
	sGrafikformatName[gfOLE] := sgfOLE;
end;

procedure InitGetText;
begin
  AddDomainForResourceString('delphi2006');
  AddDomainForResourceString('jvcl');
  TP_GlobalIgnoreClassProperty(TAction, 'Category');
  TP_GlobalIgnoreClassProperty(TControl, 'HelpKeyword');
  TP_GlobalIgnoreClass(TFont);
end;

initialization
  CreateMutex(nil, False, PChar(GUIDToString(LIBID_karsten) + '_FirstInst_Mutex'));
  JclAppInstances(GUIDToString(LIBID_karsten));
  InitGetText;
	SetGrafikformatNamen;
end.

