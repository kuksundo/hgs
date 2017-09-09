; ----------------------------------------------------------------------------
; Backup and Shutdown - Installation Script
; Author: Tristan Marlow
; Purpose: Install application
;
; ----------------------------------------------------------------------------
; Copyright (c) 2015 Tristan David Marlow
; Copyright (c) 2015 Little Earth Solutions
; All Rights Reserved
;
; This product is protected by copyright and distributed under
; licenses restricting copying, distribution and decompilation
;
; ----------------------------------------------------------------------------
;
; History: 14/02/2011 - First Release.
;
;-----------------------------------------------------------------------------
#define ConstAppVersion GetFileVersion("..\windows\client\bin\win32\release\BandS.exe") ; define variable
#define ConstAppName "Backup and Shutdown"
#define ConstAppMutex "Backup and Shutdown"
#define ConstAppDescription "Backup and Shutdown"
#define ConstAppPublisher "Little Earth Solutions"
#define ConstAppCopyright "Copyright (C) 2015 Little Earth Solutions"
#define ConstAppURL "http://www.littleearthsolutions.net/"
#define ConstAppExeName "BandS.exe"


[Setup]
AppID={{E11B318C-BD09-453E-BB5D-A665F64646F5}
AppMutex={#ConstAppMutex}
AppName={#ConstAppName}
AppVerName={#ConstAppName} {#ConstAppVersion}
AppPublisher={#ConstAppPublisher}
AppPublisherURL={#ConstAppURL}
AppSupportURL={#ConstAppURL}
AppUpdatesURL={#ConstAppURL}
AppCopyright={#ConstAppCopyright}
VersionInfoCompany={#ConstAppPublisher}
VersionInfoDescription={#ConstAppName}
VersionInfoCopyright={#ConstAppCopyright}
VersionInfoVersion={#ConstAppVersion}
VersionInfoTextVersion={#ConstAppVersion}
OutputDir=output
OutputBaseFilename=BandS-Setup-{#ConstAppVersion}
UninstallDisplayName={#ConstAppName}
DefaultDirName={pf}\{#ConstAppPublisher}\{#ConstAppName}
DefaultGroupName={#ConstAppPublisher}\{#ConstAppName}
AllowNoIcons=true
MinVersion=0,5.0.2195sp3
InfoBeforeFile=..\docs\{#ConstAppName} - Release Notes.rtf
LicenseFile=..\docs\{#ConstAppName} - License.rtf
WizardImageFile=images\WizardImageFile.bmp
WizardSmallImageFile=images\WizardSmallImageFile.bmp
SetupIconFile=images\les.ico
UninstallDisplayIcon={app}\{#ConstAppExeName}
InternalCompressLevel=ultra
Compression=lzma/ultra
ArchitecturesInstallIn64BitMode=x64
; Note: We don't set ProcessorsAllowed because we want this
; installation to run on all architectures (including Itanium,
; since it's capable of running 32-bit code too).

[Types]
Name: typical; Description: Typical Installation
Name: custom; Description: Custom Installation; Flags: iscustom

[Components]
Name: code; Description: Source Code; Types: custom
Name: program; Description: Program Files; Types: typical custom

[Tasks]
Name: desktopicon; Description: Create a &Desktop icon; GroupDescription: Additional icons:
Name: quicklaunchicon; Description: Create a &Quick Launch icon; GroupDescription: Additional icons:

[Dirs]
Name: {app}\plugins; Components: program
; Source Code Components
Name: {app}\source\windows\client\dcu; Components: code
Name: {app}\source\windows\client\bin; Components: code

[Files]
; 32bit
Source: "lib\x86\*.*"; DestDir: "{app}"; Flags: promptifolder recursesubdirs; Components: program; Check: not Is64BitInstallMode
Source: "..\windows\client\bin\win32\release\BandS.exe"; DestDir: "{app}"; Flags: promptifolder replacesameversion; Components: program; Check: not Is64BitInstallMode
Source: "..\windows\client\bin\win32\release\BandS.map"; DestDir: "{app}"; Flags: promptifolder; Components: program; Check: not Is64BitInstallMode
; 64bit
Source: "lib\x64\*.*"; DestDir: "{app}"; Flags: promptifolder recursesubdirs; Components: program; Check: Is64BitInstallMode
Source: "..\windows\client\bin\win64\release\BandS.exe"; DestDir: "{app}"; Flags: promptifolder replacesameversion; Components: program; Check: Is64BitInstallMode
Source: "..\windows\client\bin\win64\release\BandS.map"; DestDir: "{app}"; Flags: promptifolder; Components: program; Check: Is64BitInstallMode

; common
Source: "..\docs\*.*"; DestDir: "{app}"; Flags: recursesubdirs; Components: program
Source: "..\icons\BandS256x256.ico"; DestDir: "{app}"; DestName: "BandS.ico"

; Included Plugins

; 32bit
Source: "..\windows\client\bin\win32\release\plugins\ftp.dll"; DestDir: "{app}\plugins\"; Flags: promptifolder replacesameversion; Components: program; Check: not Is64BitInstallMode
Source: "..\windows\client\bin\win32\release\plugins\MySQLDump.dll"; DestDir: "{app}\plugins\"; Flags: promptifolder replacesameversion; Components: program; Check: not Is64BitInstallMode
; 64bit
Source: "..\windows\client\bin\win64\release\plugins\ftp.dll"; DestDir: "{app}\plugins\"; Flags: promptifolder replacesameversion; Components: program; Check: Is64BitInstallMode
Source: "..\windows\client\bin\win64\release\plugins\MySQLDump.dll"; DestDir: "{app}\plugins\"; Flags: promptifolder replacesameversion; Components: program; Check: Is64BitInstallMode

; Source Code Components
Source: "..\windows\common\*.pas"; DestDir: "{app}\source\windows\client\source\"; Components: code
Source: "..\windows\client\source\*.pas"; DestDir: "{app}\source\windows\client\source\"; Components: code
Source: "..\windows\client\source\*.dfm"; DestDir: "{app}\source\windows\client\source\"; Components: code
Source: "..\windows\client\source\*.dpr"; DestDir: "{app}\source\windows\client\source\"; Components: code
Source: "..\windows\client\source\*.res"; DestDir: "{app}\source\windows\client\source\"; Components: code
Source: "..\windows\client\source\*.cfg"; DestDir: "{app}\source\windows\client\source\"; Components: code

Source: "..\windows\plugins\ftp\source\*.pas"; DestDir: "{app}\source\windows\plugins\ftp\source\"; Components: code
Source: "..\windows\plugins\ftp\source\*.dfm"; DestDir: "{app}\source\windows\plugins\ftp\source\"; Components: code
Source: "..\windows\plugins\ftp\source\*.dpr"; DestDir: "{app}\source\windows\plugins\ftp\source\"; Components: code
Source: "..\windows\plugins\ftp\source\*.res"; DestDir: "{app}\source\windows\plugins\ftp\source\"; Components: code

Source: "..\windows\plugins\MySQLDump\source\*.pas"; DestDir: "{app}\source\windows\plugins\MySQLDump\source\"; Components: code
Source: "..\windows\plugins\MySQLDump\source\*.dfm"; DestDir: "{app}\source\windows\plugins\MySQLDump\source\"; Components: code
Source: "..\windows\plugins\MySQLDump\source\*.dpr"; DestDir: "{app}\source\windows\plugins\MySQLDump\source\"; Components: code
Source: "..\windows\plugins\MySQLDump\source\*.res"; DestDir: "{app}\source\windows\plugins\MySQLDump\source\"; Components: code

Source: "..\images\*.*"; DestDir: "{app}\source\images\"; Flags: recursesubdirs; Components: code
Source: "..\icons\*.*"; DestDir: "{app}\source\icons\"; Flags: recursesubdirs; Components: code
Source: "..\docs\*.*"; DestDir: "{app}\source\docs\"; Flags: recursesubdirs; Components: code
Source: "..\installer\*.*"; DestDir: "{app}\source\installer\"; Flags: recursesubdirs; Components: code; Excludes: "\output\*.*"


;[INI]
;Filename: {app}\BandS.url; Section: InternetShortcut; Key: URL; String: {#ConstAppURL}

[Icons]
;Name: {group}\Uninstall {#ConstAppName}; Filename: {uninstallexe}; WorkingDir: {app}

; Program Components
Name: {group}\{#ConstAppName}; Filename: {app}\{#ConstAppExeName}; WorkingDir: {app}; IconFilename: {app}\BandS.ico; Components: program
;Name: {group}\{#ConstAppName} on the Web; Filename: {app}\BandS.url; IconFilename: {app}\BandS.ico; Components: program
Name: {commondesktop}\{#ConstAppName}; Filename: {app}\{#ConstAppExeName}; Tasks: desktopicon; WorkingDir: {app}; IconFilename: {app}\BandS.ico; Components: program
;Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\{#ConstAppName}; Filename: {app}\{#ConstAppExeName}; Tasks: quicklaunchicon; WorkingDir: {app}; IconFilename: {app}\BandS.ico; Components: program

; Source Code Components
Name: {group}\{#ConstAppName} Source Code; Filename: {app}\Source; Flags: foldershortcut; Components: code; Tasks: 

[Run]
Filename: {app}\{#ConstAppExeName}; Description: Launch {#ConstAppName}; WorkingDir: {app}; Flags: nowait postinstall runasoriginaluser

[UninstallDelete]
Type: files; Name: {app}\BandS.url

[Registry]
Root: HKCU; SubKey: Software\Microsoft\Windows\CurrentVersion\Run; ValueType: string; ValueName: Backup and Shutdown; ValueData: {app}\BandS.exe /HIDE; Flags: uninsdeletevalue

[Code]

function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  if sUninstallString = '' then
  begin
    sUnInstPath := ExpandConstant('Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
    if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
      RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
    end;
  Result := sUnInstallString;
end;

function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;

function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

function InitializeSetup: Boolean;
begin
  Result := True;
  if (IsUpgrade()) then
    begin
    Result := False;
    if MsgBox('The previous version of "' + ExpandConstant('{#emit SetupSetting("AppName")}') + '" must be uninstalled prior to upgrade. Are you sure you want to continue?', mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES then
      begin
        Result := UnInstallOldVersion() <> 2;
      end;
    end;
end;