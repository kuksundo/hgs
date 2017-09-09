; ABC-View installer script

[Setup]
AppName=ABC-View Manager
AppVerName=ABC-View Manager version 1.5
AppCopyright=Copyright (C) 2001-2004 ABC-View.com
DefaultDirName={pf}\ABC-View Manager
DefaultGroupName=ABC-View Manager
UninstallDisplayIcon={app}\abc-view.exe
LicenseFile=exe\license.txt
DisableStartupPrompt=yes

[Files]
Source: "exe\abcview.exe"; DestDir: "{app}"; DestName: "abc-view.exe"; Flags: ignoreversion
Source: "exe\zipdll.dll"; DestDir: "{app}"
Source: "exe\jpegtran.exe"; DestDir: "{app}"

Source: "exe\abc-view.chm"; DestDir: "{app}"
Source: "exe\abc-view.cnt"; DestDir: "{app}"
Source: "exe\abc-view.hlp"; DestDir: "{app}"
Source: "exe\readme.html"; DestDir: "{app}"; Flags: isreadme
Source: "exe\license.txt"; DestDir: "{app}"
Source: "exe\tipofday.txt"; DestDir: "{app}"
Source: "exe\splash.rtf"; DestDir: "{app}"
Source: "exe\logo.bmp"; DestDir: "{app}"

Source: "source\resources\wall\blue marble.jpg"; DestDir: "{app}"
Source: "source\resources\wall\blue speckled.jpg"; DestDir: "{app}"
Source: "source\resources\wall\blue spots.jpg"; DestDir: "{app}"
Source: "source\resources\wall\blue water.jpg"; DestDir: "{app}"
Source: "source\resources\wall\grey cracked.jpg"; DestDir: "{app}"
Source: "source\resources\wall\paper.jpg"; DestDir: "{app}"
Source: "source\resources\wall\red rust.jpg"; DestDir: "{app}"
Source: "source\resources\wall\white marble.jpg"; DestDir: "{app}"
Source: "source\resources\wall\white speckled.jpg"; DestDir: "{app}"
Source: "source\resources\wall\white wall.jpg"; DestDir: "{app}"

Source: "source\resources\templates\backgr.jpg"; DestDir: "{app}\Templates"
Source: "source\resources\templates\bg_name.gif"; DestDir: "{app}\Templates"
Source: "source\resources\templates\bg_title.gif"; DestDir: "{app}\Templates"
Source: "source\resources\templates\image.html"; DestDir: "{app}\Templates"
Source: "source\resources\templates\sheet.html"; DestDir: "{app}\Templates"
Source: "source\resources\templates\tablebg.gif"; DestDir: "{app}\Templates"

Source: "exe\plugins\plugins.txt"; DestDir: "{app}\Plugins"

[Icons]
Name: "{group}\ABC-View Manager"; Filename: "{app}\abc-view.exe"
Name: "{group}\ABC-View Manager Help"; Filename: "{app}\abc-view.hlp"
Name: "{group}\ABC-View Manager Readme"; Filename: "{app}\readme.html"
Name: "{userdesktop}\ABC-View Manager"; Filename: "{app}\abc-view.exe"

[UninstallDelete]
Type: dirifempty; Name: "{app}\temp"
Type: files; Name: "{app}\abc-view.ini"
Type: dirifempty; Name: "{app}"

[Run]
Filename: "{app}\abc-view.exe"; Description: "Launch application"; Flags: postinstall nowait skipifsilent unchecked


