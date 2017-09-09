#define AppName "CalContextMenuAddin"
#define AppVerName "Test v0.1"
#define AppPublisher "jh park"

[Setup]
AppName= {#AppName} (Outlook Calendar Context Menu Add-in)
AppVerName={#AppVerName}
AppPublisher={#AppPublisher}
DefaultDirName={pf}\{#AppName}
DisableProgramGroupPage=yes
OutputDir=E:\pjh\project\util\OutLookAddIn\Test
OutputBaseFilename=Setup Test
Compression=lzma
SolidCompression=yes
VersionInfoDescription={#AppName}
VersionInfoCopyright={#AppPublisher}
UninstallFilesDir={app}
Uninstallable=yes
UninstallDisplayName={#AppName} uninstall
CreateUninstallRegKey=yes
PrivilegesRequired=admin

;AppVersion=1.0
;DefaultGroupName=My Program
;UninstallDisplayIcon={app}\MyProg.exe
;OutputDir=userdocs:Inno Setup Examples Output

[dirs]
Name: "{app}"; Permissions: everyone-full;

[Files]
Source: "CalContextMenuAddIn\CalContextAddIn.dll"; DestDir: "{app}"; Flags: regserver
;Source: "MyProg.chm"; DestDir: "{app}"
;Source: "Readme.txt"; DestDir: "{app}"; Flags: isreadme
;Source: {syswow64}\*; DestDir: {syswow64}; Flags: onlyifdoesntexist
;Source: {sys}\*; DestDir: {sys}; Flags: onlyifdoesntexist

[Icons]
;Name: "{group}\My Program"; Filename: "{app}\MyProg.exe"

; NOTE: Most apps do not need registry entries to be pre-created. If you
; don't know what the registry is or if you need to use it, then chances are
; you don't need a [Registry] section.
[Registry]
; Start "Software\My Company\My Program" keys under HKEY_CURRENT_USER
; and HKEY_LOCAL_MACHINE. The flags tell it to always delete the
; "My Program" keys upon uninstall, and delete the "My Company" keys
; if there is nothing left in them.
;Root: HKCU; Subkey: "Software\My Company"; Flags: uninsdeletekeyifempty
;Root: HKCU; Subkey: "Software\My Company\My Program"; Flags: uninsdeletekey
;Root: HKLM; Subkey: "Software\My Company"; Flags: uninsdeletekeyifempty
;Root: HKLM; Subkey: "Software\My Company\My Program"; Flags: uninsdeletekey
;Root: HKLM; Subkey: "Software\My Company\My Program\Settings"; ValueType: string; ValueName: "Path"; ValueData: "{app}"
