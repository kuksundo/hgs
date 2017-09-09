; NativeSvg "source" installer script

[Setup]
AppName=NativeSvg + Pyro Source
AppVerName=NativeSvg + Pyro Source v1.10
AppCopyright=Copyright (C) 2001-2011 SimDesign BV
DefaultDirName={pf}\SimDesign\NativeSvg110
DefaultGroupName=SimDesign
LicenseFile=license_source.txt
;InfoAfterFile=readme_source.txt
DisableStartupPrompt=yes
OutputBaseFilename=NativeSvg

[Icons]
Name: "{userdesktop}\NativeSvg v1.10"; Filename: "{app}"; Tasks: desktopicon

[Dirs]
Name: "{app}\simlib\nativesvg\demos\svgviewer\dcu"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon";

[Messages]
SelectTasksLabel2=Select the additional tasks you would like Setup to perform while installing [name], then click Next.%n%nYou must close all running instances of Delphi before you continue!

[Files]
Source: "..\..\pyro\License_source.txt"; DestDir: "{app}"; DestName: "License.txt";
Source: "..\..\pyro\versions.txt"; DestDir: "{app}"; DestName: "versions.txt";


; Example SVG file
Source: "..\demos\svgviewer\exe\tiger.svg"; DestDir: "{app}\simlib\nativesvg\demos\svgviewer\exe"
Source: "..\demos\svgviewer\exe\opacity01.svg"; DestDir: "{app}\simlib\nativesvg\demos\svgviewer\exe"
Source: "..\demos\svgviewer\exe\PreserveAspectRatio.svg"; DestDir: "{app}\simlib\nativesvg\demos\svgviewer\exe"
;Source: "..\demos\svgviewer\exe\SvgViewer.exe"; DestDir: "{app}"

; Demos
Source: "..\demos\svgviewer\*.res"; DestDir: "{app}\simlib\nativesvg\demos\svgviewer"
Source: "..\demos\svgviewer\*.cfg"; DestDir: "{app}\simlib\nativesvg\demos\svgviewer"
Source: "..\demos\svgviewer\*.dof"; DestDir: "{app}\simlib\nativesvg\demos\svgviewer"
Source: "..\demos\svgviewer\*.dpr"; DestDir: "{app}\simlib\nativesvg\demos\svgviewer"
Source: "..\demos\svgviewer\*.pas"; DestDir: "{app}\simlib\nativesvg\demos\svgviewer"
Source: "..\demos\svgviewer\*.dfm"; DestDir: "{app}\simlib\nativesvg\demos\svgviewer"
;Source: "..\demos\svgtest\*.res"; DestDir: "{app}\simlib\nativesvg\demos\svgtest"
;Source: "..\demos\svgtest\*.cfg"; DestDir: "{app}\simlib\nativesvg\demos\svgtest"
;Source: "..\demos\svgtest\*.dof"; DestDir: "{app}\simlib\nativesvg\demos\svgtest"
;Source: "..\demos\svgtest\*.dpr"; DestDir: "{app}\simlib\nativesvg\demos\svgtest"
;Source: "..\demos\svgtest\*.pas"; DestDir: "{app}\simlib\nativesvg\demos\svgtest"
;Source: "..\demos\svgtest\*.dfm"; DestDir: "{app}\simlib\nativesvg\demos\svgtest"

; Documentation
Source: "..\docu\NativeSvg.chm"; DestDir: "{app}"
Source: "..\..\pyro\docu\Pyro.chm"; DestDir: "{app}"

; nativesvg source
Source: "..\*.pas"; DestDir: "{app}\simlib\nativesvg"
Source: "..\demos\svgviewer\instructions_svgviewer.txt"; DestDir: "{app}"

; readme
Source: "..\..\pyro\readme.txt"; DestDir: "{app}"
Source: "..\..\pyro\versions.txt"; DestDir: "{app}"

; pyro source
Source: "..\..\pyro\source\*.pas"; DestDir: "{app}\simlib\pyro\source"
Source: "..\..\pyro\source\gui\*.res"; DestDir: "{app}\simlib\pyro\source\gui"
Source: "..\..\pyro\source\gui\*.dfm"; DestDir: "{app}\simlib\pyro\source\gui"
Source: "..\..\pyro\source\gui\*.pas"; DestDir: "{app}\simlib\pyro\source\gui"

; nativexml source
Source: "..\..\nativexml\*.inc"; DestDir: "{app}\simlib\nativexml";
Source: "..\..\nativexml\*.pas"; DestDir: "{app}\simlib\nativexml";
Source: "..\..\nativexml\versions.txt"; DestDir: "{app}\simlib\nativexml";

; nativejpg source
Source: "..\..\nativejpg\*.inc"; DestDir: "{app}\simlib\nativejpg";
Source: "..\..\nativejpg\*.pas"; DestDir: "{app}\simlib\nativejpg";
Source: "..\..\nativejpg\versions.txt"; DestDir: "{app}\simlib\nativejpg";

; extlib
Source: "..\..\..\extlib\extmem\Fast\FastMM.pas"; DestDir: "{app}\extlib\extmem\Fast";

; simlib bitmap
Source: "..\..\bitmap\sdGraphicTypes.pas";   DestDir: "{app}\simlib\bitmap";
Source: "..\..\bitmap\sdBitmapPlatform.pas";   DestDir: "{app}\simlib\bitmap";
Source: "..\..\bitmap\sdBitmapResize.pas";     DestDir: "{app}\simlib\bitmap";
Source: "..\..\bitmap\sdMapIterator.pas";      DestDir: "{app}\simlib\bitmap";
Source: "..\..\bitmap\sdBitmapConversionWin.pas"; DestDir: "{app}\simlib\bitmap";

; simlib disk
Source: "..\..\disk\sdFileList.pas";           DestDir: "{app}\simlib\disk";

; simlib general
Source: "..\..\general\sdStringTable.pas";     DestDir: "{app}\simlib\general";
Source: "..\..\general\sdStringEncoding.pas";  DestDir: "{app}\simlib\general";
Source: "..\..\general\sdStreams.pas";         DestDir: "{app}\simlib\general";
Source: "..\..\general\sdBufferParser.pas";    DestDir: "{app}\simlib\general";
Source: "..\..\general\sdDebug.pas";           DestDir: "{app}\simlib\general";
Source: "..\..\general\sdSortedLists.pas";     DestDir: "{app}\simlib\general";
Source: "..\..\general\simdesign.inc";         DestDir: "{app}\simlib\general";

; simlib color
Source: "..\..\color\sdColorTransforms.pas";   DestDir: "{app}\simlib\color";



















