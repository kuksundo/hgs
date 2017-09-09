; ***** BEGIN LICENSE BLOCK *****
; Version: MPL 1.1/GPL 2.0/LGPL 2.1
;
; The contents of this file are subject to the Mozilla Public License Version
; 1.1 (the "License"); you may not use this file except in compliance with
; the License. You may obtain a copy of the License at
; http://www.mozilla.org/MPL/
;
; Software distributed under the License is distributed on an "AS IS" basis,
; WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
; for the specific language governing rights and limitations under the
; License.
;
; The Original Code is Karsten Bilderschau, Version 3.2.12.
;
; The Initial Developer of the Original Code is Matthias Muntwiler.
; Portions created by the Initial Developer are Copyright (C) 2006
; the Initial Developer. All Rights Reserved.
;
; Contributor(s):
;
; Alternatively, the contents of this file may be used under the terms of
; either the GNU General Public License Version 2 or later (the "GPL"), or
; the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
; in which case the provisions of the GPL or the LGPL are applicable instead
; of those above. If you wish to allow use of your version of this file only
; under the terms of either the GPL or the LGPL, and not to allow others to
; use your version of this file under the terms of the MPL, indicate your
; decision by deleting the provisions above and replace them with the notice
; and other provisions required by the GPL or the LGPL. If you do not delete
; the provisions above, a recipient may use your version of this file under
; the terms of any one of the MPL, the GPL or the LGPL.
;
; ***** END LICENSE BLOCK ***** *)

;karsten slide show installer
;$Id: karsten.iss 151 2010-12-30 13:19:32Z hiisi $
;

;this is the path where karsten.iss is located
#define setupsrc SourcePath
#include <source-paths.iss>
;customize your source locations in local include file
;use source-paths.iss as a template
#ifexist "source-paths.local.iss"
#include <source-paths.local.iss>
#endif

#define exepath AddBackslash(binsrc) + "karsten.exe"
#define appver GetFileVersionString(exepath)
#define appMajVer Copy(appVer, 1, Pos(".", appVer) - 1)
#define appMinVer Copy(appVer, Pos(".", appVer) + 1)
#define appRelease Copy(appMinVer, Pos(".", appMinVer) + 1)
#define appMinVer Copy(appMinVer, 1, Pos(".", appMinVer) - 1)
#define appRelease Copy(appRelease, 1, Pos(".", appRelease) - 1)
#define appMajMinVer appMajVer + "." + appMinVer
#define appReleaseVer appMajMinVer + "." + appRelease
#define appcopyright GetFileCopyright(exepath)

[Setup]
AppName={cm:MyAppName}
AppVerName={cm:MyAppVerName,{#appReleaseVer}}
AppVersion={#appReleaseVer}
AppMutex={{82B80F40-BAF9-11D3-A7E5-0000B4812410}_FirstInst_Mutex
AppPublisher=Karsten SlideShow Project
AppPublisherURL=http://karsten.sourceforge.net
AppSupportURL=http://karsten.sourceforge.net
AppUpdatesURL=http://karsten.sourceforge.net
DefaultDirName={pf}\{cm:MyAppName}
DefaultGroupName={cm:MyAppName}
ChangesAssociations=true
MinVersion=4.01,5.00
AllowNoIcons=yes
AppCopyright={#appcopyright}
LicenseFile={#auxsrc}\setup\license-en.rtf
InfoBeforeFile={#auxsrc}\setup\readme-en.rtf
UninstallDisplayIcon={app}\karsten.exe
ShowLanguageDialog=yes
AllowUNCPath=false
OutputBaseFilename=karsten-setup-{#appReleaseVer}
OutputDir=../dist
PrivilegesRequired=poweruser
Compression=lzma
SolidCompression=yes

[Languages]
Name: en; MessagesFile: compiler:Default.isl; LicenseFile: {#auxsrc}\setup\license-en.rtf; InfoBeforeFile: {#auxsrc}\setup\readme-en.rtf
Name: de; MessagesFile: compiler:Languages\German.isl; LicenseFile: {#auxsrc}\setup\license-de.rtf; InfoBeforeFile: {#auxsrc}\setup\readme-de.rtf

[Messages]
en.BeveledLabel=English
de.BeveledLabel=Deutsch

[CustomMessages]
en.MyAppName=Karsten SlideShow
en.MyAppVerName=Karsten SlideShow %1
de.MyAppName=Karsten Bilderschau
de.MyAppVerName=Karsten Bilderschau %1
en.InstallScreenSaver=Install Screensaver
de.InstallScreenSaver=Bildschirmschoner installieren
en.StatusRegisterServer=Registering OLE server...
de.StatusRegisterServer=Registriert den OLE Server...

[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked
Name: quicklaunchicon; Description: {cm:CreateQuickLaunchIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked

[Files]
Source: {#binsrc}\karsten.exe; DestDir: {app}; Flags: replacesameversion
Source: {#binsrc}\KarstenScrSav.scr; DestDir: {app}; Flags: replacesameversion
Source: {#binsrc}\karsten.hlp; DestDir: {app}
Source: {#binsrc}\karsten.cnt; DestDir: {app}
Source: {#vclsrc}\rtl100.bpl; DestDir: {sys}; Flags: sharedfile restartreplace uninsrestartdelete
Source: {#vclsrc}\dbrtl100.bpl; DestDir: {sys}; Flags: sharedfile restartreplace uninsrestartdelete
Source: {#vclsrc}\vcl100.bpl; DestDir: {sys}; Flags: sharedfile restartreplace uninsrestartdelete
Source: {#vclsrc}\vclx100.bpl; DestDir: {sys}; Flags: sharedfile restartreplace uninsrestartdelete
Source: {#vclsrc}\vcljpg100.bpl; DestDir: {sys}; Flags: sharedfile restartreplace uninsrestartdelete
Source: {#vclsrc}\xmlrtl100.bpl; DestDir: {sys}; Flags: sharedfile restartreplace uninsrestartdelete
Source: {#delphibin}\vclactnband100.bpl; DestDir: {app}
Source: {#libsrc}\jcl100.bpl; DestDir: {app}
Source: {#libsrc}\jclvcl100.bpl; DestDir: {app}
Source: {#libsrc}\JvSystemD10R.bpl; DestDir: {app}
Source: {#libsrc}\JvCoreD10R.bpl; DestDir: {app}
Source: {#libsrc}\JvStdCtrlsD10R.bpl; DestDir: {app}
Source: {#libsrc}\JvCustomD10R.bpl; DestDir: {app}
Source: {#libsrc}\JvDlgsD10R.bpl; DestDir: {app}
Source: {#libsrc}\JvDockingD10R.bpl; DestDir: {app}
Source: {#libsrc}\Jv3rdD10R.bpl; DestDir: {app}
Source: {#libsrc}\PNGD10.bpl; DestDir: {app}
Source: {#libsrc}\PngComponentsD10.bpl; DestDir: {app}
Source: {#auxsrc}\karsten.tlb; DestDir: {app}; Flags: regtypelib
Source: {#auxsrc}\template.kbs; DestDir: {app}
Source: {#auxsrc}\setup\license-en.rtf; DestDir: {app}
Source: {#auxsrc}\setup\readme-en.rtf; DestDir: {app}
Source: {#auxsrc}\setup\license-de.rtf; DestDir: {app}
Source: {#auxsrc}\setup\readme-de.rtf; DestDir: {app}
Source: {#auxsrc}\setup\MPL-1.1.html; DestDir: {app}
Source: {#binsrc}\madBasic_.bpl; DestDir: {app}; Flags: skipifsourcedoesntexist
Source: {#binsrc}\madDisAsm_.bpl; DestDir: {app}; Flags: skipifsourcedoesntexist
Source: {#binsrc}\madExcept_.bpl; DestDir: {app}; Flags: skipifsourcedoesntexist

;translations
Source: {#binsrc}\locale\de\LC_MESSAGES\default.mo; DestDir: {app}\locale\de\LC_MESSAGES; Flags: replacesameversion
Source: {#binsrc}\locale\de\LC_MESSAGES\plurals.mo; DestDir: {app}\locale\de\LC_MESSAGES; Flags: replacesameversion
Source: {#binsrc}\locale\de\LC_MESSAGES\delphi2006.mo; DestDir: {app}\locale\de\LC_MESSAGES; Flags: replacesameversion
Source: {#binsrc}\locale\de\LC_MESSAGES\jvcl.mo; DestDir: {app}\locale\de\LC_MESSAGES; Flags: replacesameversion
Source: {#binsrc}\locale\it\LC_MESSAGES\default.mo; DestDir: {app}\locale\it\LC_MESSAGES; Flags: replacesameversion
Source: {#binsrc}\locale\it\LC_MESSAGES\plurals.mo; DestDir: {app}\locale\it\LC_MESSAGES; Flags: replacesameversion

[INI]
Filename: {app}\karsten.url; Section: InternetShortcut; Key: URL; String: http://karsten.sf.net

[Icons]
Name: {group}\{cm:MyAppName}; Filename: {app}\karsten.exe
Name: {group}\{cm:InstallScreenSaver}; Filename: rundll32.exe; Parameters: "desk.cpl,InstallScreenSaver ""{app}\karstenScrSav.scr"""; IconFilename: {app}\KarstenScrSav.scr
Name: {group}\{cm:ProgramOnTheWeb,{cm:MyAppName}}; Filename: {app}\karsten.url
Name: {userdesktop}\{cm:MyAppName}; Filename: {app}\karsten.exe; Tasks: desktopicon
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\{cm:MyAppName}; Filename: {app}\karsten.exe; Tasks: quicklaunchicon

[Run]
Filename: {app}\karsten.exe; Parameters: /regserver; StatusMsg: {cm:StatusRegisterServer}; Flags: runascurrentuser
Filename: {app}\KarstenScrSav.scr; Parameters: /regserver; StatusMsg: {cm:StatusRegisterServer}; Flags: runascurrentuser
Filename: {app}\karsten.exe; Description: {cm:LaunchProgram,{cm:MyAppName}}; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: files; Name: {app}\karsten.url

[Registry]
Root: HKCR; SubKey: .kbs; ValueType: string; ValueData: karsten.bildersammlung; Flags: uninsdeletekey
Root: HKCR; SubKey: karsten.bildersammlung; ValueType: string; ValueData: {cm:MyAppName}; Flags: uninsdeletekey
Root: HKCR; SubKey: karsten.bildersammlung\Shell\Open\Command; ValueType: string; ValueData: """{app}\karsten.exe"" ""%1"""; Flags: uninsdeletevalue
Root: HKCR; Subkey: karsten.bildersammlung\DefaultIcon; ValueType: string; ValueData: {app}\karsten.exe,-1; Flags: uninsdeletevalue
Root: HKCR; Subkey: .kbs\ShellNew; ValueType: string; ValueName: FileName; ValueData: {app}\template.kbs; Flags: uninsdeletevalue
Root: HKLM; Subkey: SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\karsten.exe; ValueType: string; Flags: uninsdeletekey; ValueData: {app}\karsten.exe
Root: HKLM; Subkey: SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\karsten.exe; ValueType: string; ValueName: Path; ValueData: "{app};{cf}\mm\lib"; Flags: uninsdeletevalue
