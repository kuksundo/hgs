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
 * The Original Code is karsreg.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: karsreg.pas 130 2008-11-29 05:18:08Z hiisi $ }

{
@abstract Registry interface
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2008-11-28 23:18:08 -0600 (Fr, 28 Nov 2008) $
}
unit karsreg;

interface

uses
	Classes, Registry, ComCtrls, globals, graphics,
	SysUtils, Windows, Messages, Forms, ShlObj,
	Jpeg, pngimage {$ifdef gifimage} , gifimage{$endif} ;

type
  TDockSite = (dsNone, dsFloating, dsLeft, dsRight, dsTop, dsBottom);

  { @abstract Wrapper for the karsten registry under the current user tree }
	TUserRegistry = class(TRegistry)
	private
		FCustomColors: TStrings;
		procedure SetCustomColors(const Value: TStrings);
		function  GetCustomColors: TStrings;
		function  GetLetzterBildordner: string;
		function  GetLetzterSammlungsordner: string;
		procedure SetLetzterBildordner(const Value: string);
		procedure SetLetzterSammlungsordner(const Value: string);
		function  GetScrDokument: string;
		procedure SetScrDokument(const Value: string);
		function  GetScrShowControlWin: boolean;
		procedure SetScrShowControlWin(const Value: boolean);
		function  GetUseDecryption: boolean;
		procedure SetUseDecryption(const Value: boolean);
		function  GetScrActive: boolean;
		function  GetScrExe: string;
		function  GetScrUsePasswd: boolean;
		procedure SetScrActive(const Value: boolean);
		procedure SetScrExe(const Value: string);
		function  GetScrMouseThreshold: cardinal;
		function  GetScrHookDeadTime: cardinal;
		function  GetScrSwitchDesktop: boolean;
    function  GetPreviewSite: TDockSite;
    function  GetPreviewWidth: integer;
    procedure SetPreviewSite(const Value: TDockSite);
    procedure SetPreviewWidth(const Value: integer);
	protected
		procedure WriteStringValue(const key,name,value: string;
			raiseregexceptions: boolean=false); virtual;
		function	ReadStringValue(const key,name,defaultvalue: string;
			raiseregexceptions: boolean=false): string; virtual;
		procedure WriteBooleanValue(const key,name: string; value: boolean;
			raiseregexceptions: boolean=false); virtual;
		function	ReadBooleanValue(const key,name: string; defaultvalue: boolean;
			raiseregexceptions: boolean=false):boolean; virtual;
		procedure WriteIntegerValue(const key,name: string; value: integer;
			raiseregexceptions: boolean=false); virtual;
		function	ReadIntegerValue(const key,name: string; defaultvalue: integer;
			raiseregexceptions: boolean=false): integer; virtual;
		procedure	OpenUserKey(const key: string; readonly: boolean=false); virtual;
		procedure	OpenKarstenKey(const key: string; readonly: boolean=false); virtual;
	public
		constructor Create; virtual;
		destructor Destroy; override;
		property	CustomColors: TStrings read GetCustomColors write SetCustomColors;
		property	LetzterSammlungsordner: string read GetLetzterSammlungsordner write SetLetzterSammlungsordner;
		property	LetzterBildordner: string read GetLetzterBildordner write SetLetzterBildordner;
    property  PreviewWidth: integer read GetPreviewWidth write SetPreviewWidth;
    property  PreviewSite: TDockSite read GetPreviewSite write SetPreviewSite;
		property	UseDecryption: boolean read GetUseDecryption write SetUseDecryption;
		property	ScrDokument: string read GetScrDokument write SetScrDokument;
		property	ScrShowControlWin: boolean read GetScrShowControlWin write SetScrShowControlWin;
		property	ScrExe: string read GetScrExe write SetScrExe;
		property	ScrUsePasswd: boolean read GetScrUsePasswd;
		property	ScrActive: boolean read GetScrActive write SetScrActive;
		property	ScrMouseThreshold: cardinal read GetScrMouseThreshold;
		property	ScrHookDeadTime: cardinal read GetScrHookDeadTime;
		property	ScrSwitchDesktop: boolean read GetScrSwitchDesktop; //default=winnt and true
		procedure SaveBilderlisteLV(const ListView: TListView); virtual;
		procedure UpdateBilderlisteLV(const ListView: TListView); virtual;
	end;

	ENoUserProfiles=class(ERegistryException);

	//same as TUserRegistry but for the default user
	TDefUserRegistry=class(TUserRegistry)
	protected
		procedure	OpenUserKey(const key:string; readonly:boolean=false); override;
		procedure	OpenKarstenKey(const key:string; readonly:boolean=false); override;
	public
    // raises ENoUserProfiles unless user profiles are active
		constructor	Create; override;
	end;

	TUserRegistryClass=class of TUserRegistry;
	TDefUserRegistryClass=class of TDefUserRegistry;

type
	TMediaType=class
	private
		FDisplaySupported: boolean;
		FFileExt: string;
		FDescription: string;
		FGrafikformat: tGrafikformat;
		procedure SetDescription(const Value: string);
		procedure SetDisplaySupported(const Value: boolean);
		procedure SetFileExt(const Value: string);
		procedure SetGrafikformat(const Value: tGrafikformat);
		function GetGraphicClass: TGraphicClass;
	public
		property	FileExt:string read FFileExt write SetFileExt;
		property	Description:string read FDescription write SetDescription;
		property	Grafikformat:tGrafikformat read FGrafikformat write SetGrafikformat;
		property	GraphicClass:TGraphicClass read GetGraphicClass;
		property	DisplaySupported:boolean read FDisplaySupported write SetDisplaySupported;
	end;

	{	speichert erweiterung in Strings und @link(TMediaType)-objekt in Objects.
		erweiterung jeweils inklusive punkt }
	TMediaTypeList=class(TStringList)
	private
		function	GetFileFilters: string;
	public
		constructor Create;
		destructor	Destroy; override;
		procedure	RegisterMediaType(fileextension, description: string;
			grafikformat: TGrafikFormat);
		procedure	RegisterMCIFormats;
    procedure RegisterDirectShowFormats;
		function	GetGrafikformat(const fileNameOrExtension: string): TGrafikFormat;
		function	GetMediaType(const fileNameOrExtension: string): TMediaType;
		function	IsDisplaySupported(const fileNameOrExtension: string): boolean;
    //für TOpenDialog
		property	FileFilters: string read GetFileFilters;
	end;

var
	MediaTypes: TMediaTypeList;
	KarstenScrPath: string;

const
	sIniPath = 'Software\mma software\karsten\3.0';
	sKeyRecentFiles = 'RecentFiles';
  regkeyRecentDocuments = 'RecentDocuments';

implementation

uses
  regstr;

const
	sDefUserName = '.default';
	sKeyWinDesktop = REGSTR_PATH_SCREENSAVE; //control panel\desktop
	sKeyUserProfilesList = REGSTR_PATH_SETUP+'\ProfileList'; //Software\Microsoft\Windows\CurrentVersion
	sKeyControlset = REGSTR_PATH_CURRENT_CONTROL_SET; //'system\currentcontrolset\control';
	sValCSUsername = REGSTR_VAL_CURRENT_USER; //'current user';

	sKeyCustomColors = 'CustomColors';
	sKeyBilderListView = 'ListView';

	sValLVStyle = 'Style';
	sValLVColumnWidths = 'ColumnWidths';
	sValSammlungOrdner = 'CollectionFolder';
	sValBildOrdner = 'PictureFolder';
  sValPreviewWidth = 'PreviewWidth';
  sValPreviewSite = 'PreviewSite';

	sKeyScreensaver = 'ScreenSaver';
	sValScrDocument = 'SlideShowDoc';
	sValScrHookDeadTime = 'MouseHookDeadTime';
	cDefScrHookDeadTime = 2000;
	sValScrShowControlWin = 'ShowControlWin';
	sValScrSwitchDesktop = 'SwitchDesktop';
	sValScrExe = 'scrnsave.exe';
	sValScrActive = 'ScreenSaveActive';
	sValScrUsePasswd = REGSTR_VALUE_USESCRPASSWORD; //ScreenSaveUsePassword
	sKeyScrMouseThreshold = REGSTR_PATH_SETUP+'\Screen Savers';
	sValScrMouseThreshold = 'Mouse Threshold';
	cDefScrMouseThreshold = 50;

	sKeySammlungExt = '.kbs';
	sKeySammlungTyp = 'karsten.bildersammlung';
	sKeyShellOpenCommand = 'shell\open\command';

	sValUseDecryption = 'UseDecryption';

	SKeyMCIExtensions = 'software\microsoft\multimedia\directxmedia\extensions';
	SKeyDirectShowExtensions = 'Media Type\Extensions'; // under HKEY_CLASSES_ROOT
	SValMediaTypeDescription = 'MediaType.Description';
  SValExtensionMIME = 'Extension.MIME';

resourcestring
	SValSammlungTitel = 'Karsten Slide Collection';
	SAlleBilder = 'All Image Files';
	SAlleMultimedia = 'All Media Files';
	SAlleDateien = 'All Files';
	SAlleBekannten = 'All Image and Media Files';
	SDefMediaTypeDescription = 'No Description';

	SEOpenKeyException =
    'Error opening the Windows registry: ' +
    'Access to the key %s\%s is denied.';
	SENoUserProfiles =
		'Caution: Your operating system does not support multiple users.';

function GetSpecialFolderPath(csidl: integer): string;
var
	pidl: PItemIdList;
	folderPath: string;
begin
	result:='';
	if Succeeded(SHGetSpecialFolderLocation(0, csidl, pidl)) then begin
		SetLength(folderPath, max_path);
		SHGetPathFromIDList(pidl, PChar(FolderPath));
		SetLength(FolderPath, strlen(PChar(FolderPath)));
		result := folderPath;
	end;
end;

function GetLongPathName(PathName: String): String;
var
  p: integer;
	Drive: string;
  Dir: string;
	Path: string;
	SearchRec: TSearchRec;
begin
  repeat
    p := Pos('"', PathName);
    if p >= 1 then
      PathName := Copy(PathName, 1, p - 1) +
        Copy(PathName, p + 1, Length(PathName));
  until
    p < 1;
	if Length(PathName)>0 then begin
		Drive := ExtractFileDrive(PathName);
		Path := Copy(PathName, Length(Drive) + 1, Length(PathName));
		if (Path = '') or (Path = '\') then begin
			Result := PathName;
			if Result[Length(Result)] = '\' then
				Delete(Result, Length(Result), 1);
    end	else begin
      Dir := ExtractFileDir(PathName);
      // prevent recursive stack overflow in unforeseen situations
      // (normally, the recursive loop is ended in the 'then' statement)
      if not SameFileName(Dir, PathName) then
  			Path := GetLongPathName(Dir);
			if SysUtils.FindFirst(PathName, faAnyFile, SearchRec) = 0 then begin
				Result := Path + '\' + SearchRec.FindData.cFileName;
				SysUtils.FindClose(SearchRec);
      end	else
        Result := Path + '\' + ExtractFileName(PathName) end
	end else
    result := '';
end;

{ TUserRegistry }

destructor TUserRegistry.Destroy;
begin
	FCustomColors.Free;
	inherited;
end;

function TUserRegistry.GetCustomColors: TStrings;
var
	idx:integer;
	s:string;
begin
	if Assigned(FCustomColors)
		then FCustomColors.Clear
		else FCustomColors := TStringList.Create;
	Result := FCustomColors;
	try
		try
			OpenKarstenKey(sKeyCustomColors,true);
			GetValueNames(FCustomColors);
			if FCustomColors.Count>0 then
				for idx := 0 to FCustomColors.Count-1 do
					try
						s := ReadString(FCustomColors[idx]);
						FCustomColors[idx] := FCustomColors[idx]+'='+s;
					except
						on ERegistryException do FCustomColors.Delete(idx);
					end;
		except
			on ERegistryException do FCustomColors.Clear;
		end;
	finally
		CloseKey;
	end;
end;

procedure TUserRegistry.SetCustomColors(const Value: TStrings);
var
	idx:integer;
	s1,s2:string;
begin
	try
		try
			OpenKarstenKey(sKeyCustomColors);
			if (Value.Count>0) then
				for idx := 0 to Value.Count-1 do begin
					s1 := Value.Names[idx];
					if Length(s1)>0 then begin
						s2 := Value.Values[s1];
						if (Length(s2)>0) then WriteString(s1,s2);
					end;
				end;
		except
			on ERegistryException do if Assigned(Application)
				then Application.HandleException(Self) else raise;
		end;
	finally
		FCustomColors.Free;
		FCustomColors := nil;
		CloseKey;
	end;
end;

procedure TUserRegistry.SaveBilderlisteLV(const ListView: TListView);
var
	idx: integer;
  SL: TStrings;
begin
  SL := TStringList.Create;
	try
		try
			OpenKarstenKey(sKeyBilderListView);
      WriteInteger(sValLVStyle, Ord(ListView.ViewStyle));
      SL.Clear;
      for idx := 0 to ListView.Columns.Count - 1 do
        SL.Add(IntToStr(ListView.Columns[idx].WidthType));
      if GetDataType(sValLVColumnWidths) <> rdString then
        DeleteValue(sValLVColumnWidths);
      WriteString(sValLVColumnWidths, SL.CommaText);
		except
			on ERegistryException do if Assigned(Application)
				then Application.HandleException(Self) else raise;
		end;
	finally
    SL.Free;
		CloseKey;
	end;
end;

procedure TUserRegistry.UpdateBilderlisteLV(const ListView: TListView);
var
  SL: TStrings;
	idx: integer;
  v: integer;
begin
  SL := TStringList.Create;
	try
		try
			OpenKarstenKey(sKeyBilderListView,true);
      v := ReadInteger(sValLVStyle);
      if (v >= Ord(Low(TViewStyle))) and (v <= Ord(High(TViewStyle))) then
        ListView.ViewStyle := TViewStyle(v);

      if GetDataType(sValLVColumnWidths) = rdString then begin
        SL.CommaText := ReadString(sValLVColumnWidths);
        if SL.Count = ListView.Columns.Count then begin
          for idx := 0 to ListView.Columns.Count - 1 do
            ListView.Columns[idx].Width :=
              StrToIntDef(SL[idx], ListView.Columns[idx].Width);
        end;
      end;
		except
      on ERegistryException do {ignore};
		end;
	finally
    SL.Free;
		CloseKey;
	end;
end;

function TUserRegistry.GetLetzterBildordner: string;
begin
	result := ReadStringValue(sKeyRecentFiles,sValBildOrdner,'');
	if (Length(result)=0) then result := GetSpecialFolderPath(csidl_Personal);
end;

function TUserRegistry.GetLetzterSammlungsordner: string;
begin
	result := ReadStringValue(sKeyRecentFiles,sValSammlungOrdner,'');
	if (Length(result)=0) then result := GetSpecialFolderPath(csidl_Personal);
end;

procedure TUserRegistry.OpenUserKey(const key: string; readonly: boolean);
begin
	if readonly then begin
		if (Length(key)>0) and not OpenKeyReadOnly(key) then
			raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,key]);
	end else begin
		if (Length(key)>0) and not OpenKey(key,true) then
			raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,key]);
	end;
end;

procedure TUserRegistry.OpenKarstenKey(const key: string; readonly: boolean);
begin
	if readonly then begin
		if OpenKeyReadOnly(sIniPath) then begin
			if (Length(key)>0) and not OpenKeyReadOnly(key) then
				raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,key]);
		end else raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,sIniPath]);
	end else begin
		if OpenKey(sIniPath,true) then begin
			if (Length(key)>0) and not OpenKey(key,true) then
				raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,key]);
		end else raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,sIniPath]);
	end;
end;

function TUserRegistry.ReadStringValue;
begin
	result := '';
	try
		OpenKarstenKey(key,true);
		try
			result := ReadString(name);
		finally
			CloseKey;
		end;
	except
		on ERegistryException do begin
			result := defaultvalue;
			if raiseregexceptions then raise;
		end;
	end;
end;

function TUserRegistry.ReadBooleanValue(const key, name: string;
	defaultvalue: boolean; raiseregexceptions: boolean): boolean;
begin
	try
		OpenKarstenKey(key,true);
		try
			result := ReadBool(name);
		finally
			CloseKey;
		end;
	except
		on ERegistryException do begin
			result := defaultvalue;
			if raiseregexceptions then raise;
		end;
	end;
end;

function TUserRegistry.ReadIntegerValue(const key, name: string;
	defaultvalue: integer; raiseregexceptions: boolean): integer;
begin
	try
		OpenKarstenKey(key,true);
		try
			result := ReadInteger(name);
		finally
			CloseKey;
		end;
	except
		on ERegistryException do begin
			result := defaultvalue;
			if raiseregexceptions then raise;
		end;
	end;
end;

procedure TUserRegistry.WriteStringValue;
begin
	try
		OpenKarstenKey(key);
		try
			WriteString(name,value);
		finally
			CloseKey;
		end;
	except
		on ERegistryException do begin
			if raiseregexceptions then raise
				else if Assigned(Application) then Application.HandleException(Self);
		end;
	end;
end;

procedure TUserRegistry.WriteBooleanValue(const key, name: string; value,
	raiseregexceptions: boolean);
begin
	try
		OpenKarstenKey(key);
		try
			WriteBool(name,value);
		finally
			CloseKey;
		end;
	except
		on ERegistryException do begin
			if raiseregexceptions then raise
				else if Assigned(Application) then Application.HandleException(Self);
		end;
	end;
end;

procedure TUserRegistry.WriteIntegerValue(const key, name: string;
	value: integer; raiseregexceptions: boolean);
begin
	try
		OpenKarstenKey(key);
		try
			WriteInteger(name,value);
		finally
			CloseKey;
		end;
	except
		on ERegistryException do begin
			if raiseregexceptions then raise
				else if Assigned(Application) then Application.HandleException(Self);
		end;
	end;
end;

procedure TUserRegistry.SetLetzterBildordner(const Value: string);
begin
	WriteStringValue(sKeyRecentFiles,sValBildOrdner,value);
end;

procedure TUserRegistry.SetLetzterSammlungsordner(const Value: string);
begin
	WriteStringValue(sKeyRecentFiles,sValSammlungOrdner,value);
end;

function TUserRegistry.GetUseDecryption: boolean;
begin
	result := ReadBooleanValue('',sValUseDecryption,false);
end;

procedure TUserRegistry.SetUseDecryption(const Value: boolean);
begin
	WriteBooleanValue('',sValUseDecryption,value);
end;

function TUserRegistry.GetPreviewSite: TDockSite;
var
  v: integer;
begin
  v := ReadIntegerValue('', sValPreviewSite, Ord(dsRight));
  if (v >= Ord(Low(TDockSite))) and (v <= Ord(High(TDockSite))) then
    result := TDockSite(v)
  else
    result := dsRight;
end;

function TUserRegistry.GetPreviewWidth: integer;
begin
  result := ReadIntegerValue('', sValPreviewWidth, 200);
end;

procedure TUserRegistry.SetPreviewSite(const Value: TDockSite);
begin
  WriteIntegerValue('', sValPreviewSite, Ord(Value));
end;

procedure TUserRegistry.SetPreviewWidth(const Value: integer);
begin
  WriteIntegerValue('', sValPreviewWidth, Value);
end;

function TUserRegistry.GetScrDokument: string;
begin
	result := ReadStringValue(sKeyScreensaver,sValScrDocument,'');
end;

procedure TUserRegistry.SetScrDokument(const Value: string);
begin
	WriteStringValue(sKeyScreensaver,sValScrDocument,value);
end;

function TUserRegistry.GetScrShowControlWin: boolean;
begin
	result := ReadBooleanValue(sKeyScreensaver,sValScrShowControlWin,false);
end;

procedure TUserRegistry.SetScrShowControlWin(const Value: boolean);
begin
	WriteBooleanValue(sKeyScreensaver,sValScrShowControlWin,value);
end;

function TUserRegistry.GetScrHookDeadTime: cardinal;
begin
	result := ReadIntegerValue(sKeyScreensaver,sValScrHookDeadTime,cDefScrHookDeadTime);
end;

function TUserRegistry.GetScrActive: boolean;
begin
	try
		try
			OpenUserKey(sKeyWinDesktop, true);
			result := ReadString(sValScrActive) <> '0';
		except
			on ERegistryException do result := false;
		end;
	finally
		CloseKey;
	end;
	result := result and SameFileName(ScrExe, KarstenScrPath);
end;

function TUserRegistry.GetScrExe: string;
begin
  result := '';
  if Win32Platform >= VER_PLATFORM_WIN32_NT then begin
 		try
 			try
 				OpenUserKey(sKeyWinDesktop, true);
 				result := ReadString(sValScrExe);
 			except
 				on ERegistryException do result := '';
 			end;
 		finally
 			CloseKey;
 		end;
  end else begin
 		SetLength(result, max_Path + 20);
 		SetLength(result, GetPrivateProfileString('boot', sValScrExe, '',
 			pChar(result), Length(result), 'system.ini'));
	end;
	result := GetLongPathName(result);
end;

procedure TUserRegistry.SetScrActive(const Value: boolean);
var
  oldValue: boolean;
begin
  oldValue := ScrActive;
	try
    OpenUserKey(sKeyWinDesktop);
    WriteString(sValScrActive, Chr(Ord('0') + Ord(value)) );
	finally
		CloseKey;
	end;
	if value and not oldValue then ScrExe := KarstenScrPath;
end;

procedure TUserRegistry.SetScrExe(const Value: string);
begin
  try
    OpenUserKey(sKeyWinDesktop);
    WriteString(sValScrExe, Value);
  finally
    CloseKey;
  end;
end;

function TUserRegistry.GetScrUsePasswd: boolean;
begin
	try
		try
			OpenUserKey(sKeyWinDesktop,true);
			result := ReadBool(sValScrShowControlWin);
		except
			on ERegistryException do result := false;
		end;
	finally
		CloseKey;
	end;
end;

function TUserRegistry.GetScrMouseThreshold: cardinal;
begin
	try
		try
			OpenUserKey(sKeyScrMouseThreshold,true);
			result := ReadInteger(sValScrMouseThreshold);
		except
			on ERegistryException do result := cDefScrMouseThreshold;
		end;
	finally
		CloseKey;
	end;
end;

constructor TUserRegistry.Create;
begin
	inherited;
end;

function TUserRegistry.GetScrSwitchDesktop: boolean;
begin
	result := (Win32Platform=VER_PLATFORM_WIN32_NT) and
		ReadBooleanValue(sKeyScreensaver, sValScrSwitchDesktop, true);
end;

{ TDefUserRegistry }

constructor TDefUserRegistry.Create;
{$ifdef debugging}
var
	noUserProfiles:boolean;
	kuplOkro,kuplHsk:boolean;
	csuOkro,csuVe:boolean;
	csuRs,gun:string;
	nGun:cardinal;
begin
	inherited;
	RootKey := HKEY_LOCAL_MACHINE;
	try
		kuplOkro := OpenKeyReadOnly(sKeyUserProfilesList);
		kuplHsk := HasSubKeys;
		noUserProfiles := not (kuplOkro and kuplHsk);
	finally
		CloseKey;
	end;
	try
		csuOkro := OpenKeyReadOnly(sKeyControlset);
		csuVe := ValueExists(sValCSUsername);
		if csuVe then csuRs := ReadString(sValCSUsername);
	finally
		CloseKey;
	end;
	noUserProfiles := noUserProfiles or
		not csuOkro or not csuVe or
		(CompareText(csuRs,sDefUserName)=0);
	DebugLog.AddEntry('TDefUserRegistry.Create');
	DebugLog.AddEntry(Format('  kuplOkro=%d, kuplHsk=%d, csuOkro=%d, csuVe=%d, nup=%d',
		[Ord(kuplOkro),Ord(kuplHsk),Ord(csuOkro),Ord(csuVe),Ord(noUserProfiles)]));
	nGun := 256;
	SetLength(gun,nGun);
	if GetUserName(pChar(gun),nGun) then SetLength(gun,nGun-1) else gun := 'GUN failed';
	DebugLog.AddEntry(Format('  csuRs=%s, GUN=%s',[csuRs,gun]));
	RootKey := hkey_Users;
	if noUserProfiles	then raise ENoUserProfiles.Create(seNoUserProfiles);
	{
	win2k
	04.07.2000 20:22:54:   kuplOkro=0, kuplHsk=0, csuOkro=1, csuVe=0, nup=1
	04.07.2000 20:22:54:   csuRs=, GUN=matthias
	}
end;
{$else}
var
	noUserProfiles:boolean;
begin
	inherited;
	RootKey := HKEY_LOCAL_MACHINE;
	noUserProfiles := not (OpenKeyReadOnly(sKeyUserProfilesList) and HasSubKeys);
	CloseKey;
	noUserProfiles := noUserProfiles or
		not OpenKeyReadOnly(sKeyControlset) or not ValueExists(sValCSUsername) or
		(CompareText(ReadString(sValCSUsername),sDefUserName)=0);
	CloseKey;
	RootKey := HKEY_USERS;
	if noUserProfiles	then raise ENoUserProfiles.Create(seNoUserProfiles);
end;
{$endif}

procedure TDefUserRegistry.OpenKarstenKey(const key: string;
	readonly: boolean);
begin
	if readonly then begin
		if not OpenKeyReadOnly(sDefUserName) then
			raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,sDefUserName]);
	end else begin
		if not OpenKey(sDefUserName,true) then
			raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,sDefUserName]);
	end;
	inherited;
end;

procedure TDefUserRegistry.OpenUserKey(const key: string;
	readonly: boolean);
begin
	if readonly then begin
		if not OpenKeyReadOnly(sDefUserName) then
			raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,sDefUserName]);
	end else begin
		if not OpenKey(sDefUserName,true) then
			raise ERegistryException.CreateFmt(seOpenKeyException,[CurrentPath,sDefUserName]);
	end;
	inherited;
end;

{ TMediaTypeList }
const
	{$ifdef gifimage} nGrafikFileExt=8; {$else} nGrafikFileExt=7; {$endif}
	sGrafikFileExt:array[0..nGrafikFileExt-1] of string=
		('.bmp','.ico','.wmf','.emf','.jpg','.jpeg','.png'
		{$ifdef gifimage} ,'.gif'{$endif} );
	cGrafikFormat:array[0..nGrafikFileExt-1] of tGrafikformat=
		(gfBitmap, gfIcon, gfMetafile, gfMetafile, gfJPEG, gfJPEG, gfPNG
		{$ifdef gifimage} ,gfGIF{$endif} );

constructor TMediaTypeList.Create;
var
	idx:integer;
begin
	inherited;
	Sorted := true;
	Duplicates := dupError;
	for idx := Low(sGrafikFileExt) to High(sGrafikFileExt) do begin
		RegisterMediaType(sGrafikFileExt[idx],
			sGrafikFormatName[cGrafikFormat[idx]], cGrafikFormat[idx]);
	end;
  RegisterDirectShowFormats;
	RegisterMCIFormats;
end;

destructor TMediaTypeList.Destroy;
var
	idx:integer;
begin
	for idx := 0 to Count-1 do
		Objects[idx].Free;
end;

function TMediaTypeList.GetFileFilters: string;
var
	idx:integer;
	fmt:tGrafikformat;
	MT:TMediaType;
	filter:array[tGrafikFormat] of string;
	bilder,multimedia:string;
begin
	for idx := 0 to Count-1 do begin
		MT := (Objects[idx] as TMediaType);
		fmt := MT.Grafikformat;
		if fmt<>gfUnbekannt then begin
			if Length(filter[fmt])>0 then filter[fmt] := filter[fmt]+';';
			filter[fmt] := filter[fmt]+'*'+Strings[idx];
			if fmt=gfMCI then begin
				if Length(multimedia)>0 then multimedia := multimedia+'|';
				multimedia := multimedia+MT.Description+' (*'+MT.FileExt+')|*'+MT.FileExt;
			end else begin
				if Length(bilder)>0 then bilder := bilder+';';
				bilder := bilder+'*'+Strings[idx];
			end;
		end;
	end;
	result := sAlleBilder+'|'+bilder;
	if Length(filter[gfMCI])>0 then begin
		result := sAlleBekannten+'|'+bilder+filter[gfMCI]+'|'+result;
		result := result+'|'+sAlleMultimedia+'|'+filter[gfMCI];
	end;
	for fmt := Low(filter) to High(filter) do
		case fmt of
			gfMCI: if Length(multimedia)>0 then result := result+'|'+multimedia;
			gfOLE: ;
			else if Length(filter[fmt])>0 then
				result := result+'|'+sGrafikFormatName[fmt]+' ('+filter[fmt]+')|'+filter[fmt];
		end;
end;

function TMediaTypeList.GetGrafikformat;
var
	fileext: string;
  i: integer;
begin
	fileext := LowerCase(ExtractFileExt(fileNameOrExtension));
  i := IndexOf(fileext);
  if i >= 0 then
		Result := (Objects[i] as TMediaType).Grafikformat
  else
    Result := gfUnbekannt;
end;

function TMediaTypeList.GetMediaType(
	const fileNameOrExtension: string): TMediaType;
var
	fileext: string;
  i: integer;
begin
	fileext := LowerCase(ExtractFileExt(fileNameOrExtension));
  i := IndexOf(fileext);
  if i >= 0 then
		Result := Objects[i] as TMediaType
  else
    Result := nil;
end;

function TMediaTypeList.IsDisplaySupported;
begin
	Result := GetGrafikformat(filenameorextension)<>gfUnbekannt;
end;

procedure TMediaTypeList.RegisterMCIFormats;
var
	R: TRegistry;
	KeyNames: TStrings;
	MT: TMediaType;
	knIdx, mflIdx: integer;
begin
	R := nil;
	KeyNames := nil;
	MT := nil;
	try
		R := TRegistry.Create;
		KeyNames := TStringList.Create;
		R.RootKey := HKEY_LOCAL_MACHINE;
		if R.OpenKeyReadOnly(sKeyMCIExtensions) then begin
			R.GetKeyNames(KeyNames);
			R.CloseKey;
			if KeyNames.Count>0 then
				for knIdx := 0 to KeyNames.Count-1 do
					if R.OpenKeyReadOnly(sKeyMCIExtensions + '\' + KeyNames[knIdx]) then
					try
            if not Find(KeyNames[knIdx], mflIdx) then begin
  						MT := TMediaType.Create;
  						mflIdx := Add(KeyNames[knIdx]);
  						Objects[mflIdx] := MT;
              MT.FileExt := KeyNames[knIdx];
              MT.Grafikformat := gfMCI;
              MT.DisplaySupported := true;
              MT.Description := R.ReadString(sValMediaTypeDescription);
              if Length(MT.Description) = 0 then
                MT.Description := sDefMediaTypeDescription;
            end;
            MT := nil;
				finally
					R.CloseKey;
				end;
		end;
	finally
		R.Free;
		KeyNames.Free;
		MT.Free;
	end;
end;

procedure TMediaTypeList.RegisterDirectShowFormats;
  procedure RegDSExt(const R: TRegistry; const FileExt: string);
  var
    MT: TMediaType;
    mflIdx: integer;
    FileKey: string;
  begin
    if not Find(FileExt, mflIdx) then begin
      MT := TMediaType.Create;
      mflIdx := Add(FileExt);
      Objects[mflIdx] := MT;
      MT.FileExt := FileExt;
      MT.Grafikformat := gfDirectShow;
      MT.DisplaySupported := true;
      R.CloseKey;
      if R.OpenKeyReadOnly(FileExt) then begin
        FileKey := R.ReadString('');
        if R.OpenKeyReadOnly(FileKey) then begin
          MT.Description := R.ReadString('');
        end;
      end;
      if Length(MT.Description) = 0 then
        MT.Description := sDefMediaTypeDescription;
    end;
  end;

var
	R: TRegistry;
  ParentKey, KeyPath, Key: string;
  KeyNames: TStrings;
  knIdx: integer;
begin
  R := TRegistry.Create;
	try
    R.RootKey := HKEY_CLASSES_ROOT;
		if R.OpenKeyReadOnly(sKeyDirectShowExtensions) then begin
      ParentKey := R.CurrentPath;
      KeyNames := TStringList.Create;
      try
        R.GetKeyNames(KeyNames);
        KeyNames.Add('.avi');
        for knIdx := 0 to KeyNames.Count - 1 do begin
          R.CloseKey;
          Key := KeyNames[knIdx];
          KeyPath := IncludeTrailingBackslash(ParentKey) + Key;
          RegDSExt(R, Key);
        end;
      finally
        KeyNames.Free;
      end;
    end;
	finally
		R.Free;
	end;
end;

procedure TMediaTypeList.RegisterMediaType;
var
	idx:integer;
	MT:TMediaType;
begin
	fileextension := LowerCase(fileextension);
	try
		idx := Add(fileextension);
		MT := TMediaType.Create;
		Objects[idx] := MT;
	except
		on EListError do begin
			MT := Objects[IndexOf(fileextension)] as TMediaType;
		end;
	end;
	MT.FileExt := fileextension;
	MT.Description := description;
	MT.Grafikformat := grafikformat;
	MT.DisplaySupported := true;
end;

{ TMediaType }
function TMediaType.GetGraphicClass: TGraphicClass;
begin
	case Grafikformat of
		gfBitmap: result := graphics.TBitmap;
		gfIcon: result := TIcon;
		gfMetafile: result := TMetafile;
		gfJPEG: result := TJPEGImage;
		gfPNG: result := TPNGObject;
		{$ifdef gifimage} gfGIF: result := TGIFImage; {$endif}
		else result := nil;
	end;
end;

procedure TMediaType.SetDescription(const Value: string);
begin
	FDescription := Value;
end;

procedure TMediaType.SetDisplaySupported(const Value: boolean);
begin
	FDisplaySupported := Value;
end;

procedure TMediaType.SetFileExt(const Value: string);
begin
	FFileExt := Value;
end;

procedure TMediaType.SetGrafikformat(const Value: tGrafikformat);
begin
	FGrafikformat := Value;
end;

{ various procedures }
procedure RegisterSammlung;
var
	Reg: TRegistry;
	doUpdate: boolean;
begin
	Reg := TRegistry.Create;
	try
		if Assigned(Reg) then with Reg do begin
			RootKey := hkey_Classes_Root;
			doUpdate := not KeyExists(sKeySammlungExt) or not KeyExists(sKeySammlungTyp);
			try
				if OpenKey(sKeySammlungExt, true) then begin
					doUpdate := doUpdate or (Length(ReadString('')) = 0);
					if doUpdate then WriteString('', sKeySammlungTyp);
				end;
			finally
				CloseKey;
			end;
			if doUpdate then
				try
					if OpenKey(sKeySammlungTyp, true) then begin
						WriteString('', sValSammlungTitel);
						if OpenKey(sKeyShellOpenCommand, true) then
							WriteString('', Application.ExeName + ' "%1"');
					end;
				finally
					CloseKey;
				end;
		end;
	finally
		Reg.Free;
	end;
end;

const
	sScrName: array[0..3] of string = (
    'KarstenScrSav.scr',
		'KarstenBildschirmschoner.scr',
		'KarstenScreenSaver.scr',
		'karsten.scr');

function GetKarstenScrPath:string;
var
	scrapppath,scrwinpath,appdir,windir:string;
	i:integer;
begin
	result := '';

	appdir := ExtractFilePath(Application.ExeName);
	if appdir[Length(appdir)]<>'\' then appdir := appdir+'\';
	SetLength(windir,max_path);
	SetLength(windir,GetWindowsDirectory(pChar(windir),Length(windir)));
	if windir[Length(windir)]<>'\' then windir := windir+'\';

	for i := Low(sScrName) to High(sScrName) do begin
		scrapppath := appdir+sScrName[i];
		if FileExists(scrapppath) then begin
			result := scrapppath;
			break;
		end;
		scrwinpath := windir+sScrName[i];
		if FileExists(scrwinpath) then begin
			result := scrwinpath;
			break;
		end;
	end;
	result := GetLongPathName(result);
end;

initialization
	RegisterSammlung;
	MediaTypes := TMediaTypeList.Create;
	KarstenScrPath := GetKarstenScrPath;
finalization
	MediaTypes.Free;
end.

