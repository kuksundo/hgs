[Setup]
AppName=NativeJpg
AppVerName=NativeJpg 1.33 ("open-source" version)
AppPublisher=SimDesign B.V.
AppPublisherURL=http://www.simdesign.nl
AppSupportURL=http://www.simdesign.nl
AppUpdatesURL=http://www.simdesign.nl
DefaultDirName={pf}\SimDesign\NativeJpg133
DefaultGroupName=NativeJpg
LicenseFile=..\LICENSE.txt
OutputBaseFilename=NativeJpg

[Icons]
Name: "{userdesktop}\NativeJpg v1.33"; Filename: "{app}"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"

[Dirs]
Name: "{app}\simlib\nativejpg\demos\jpegtest\dcu"
Name: "{app}\simlib\nativejpg\demos\jpegtest\exe"
Name: "{app}\simlib\nativejpg\demos\tiledemo\dcu"
Name: "{app}\simlib\nativejpg\demos\tiledemo\exe"
Name: "{app}\simlib\nativejpg\packages\dcu"

[Files]

; Main folder
Source: "..\LICENSE.txt"; DestDir: "{app}\simlib\nativejpg";
Source: "..\NOTICE.txt"; DestDir: "{app}\simlib\nativejpg";
Source: "..\LICENSE.txt"; DestDir: "{app}";
Source: "..\readme.txt"; DestDir: "{app}";

; example
Source: "..\demos\viewer\exe\viewer.exe"; DestDir: "{app}\example";

; Documentation
;Source: "..\docu\NativeJpg.chm"; DestDir: "{app}"; -> now separate
Source: "..\versions.txt"; DestDir: "{app}\simlib\nativejpg";
Source: "..\issues.txt"; DestDir: "{app}\simlib\nativejpg";
Source: "..\versions.txt"; DestDir: "{app}";

; jpegtest demo
;Source: "..\demos\jpegtest\JpegTest.dpr"; DestDir: "{app}\simlib\nativejpg\demos\jpegtest";
;Source: "..\demos\jpegtest\JpegTest.dof"; DestDir: "{app}\simlib\nativejpg\demos\jpegtest";
;Source: "..\demos\jpegtest\JpegTest.cfg"; DestDir: "{app}\simlib\nativejpg\demos\jpegtest";
;Source: "..\demos\jpegtest\JpegTest.res"; DestDir: "{app}\simlib\nativejpg\demos\jpegtest";
;Source: "..\demos\jpegtest\JpegTestMain.dfm"; DestDir: "{app}\simlib\nativejpg\demos\jpegtest";
;Source: "..\demos\jpegtest\JpegTestMain.pas"; DestDir: "{app}\simlib\nativejpg\demos\jpegtest";

; tiledemo
Source: "..\demos\tiledemo\TileDemo.dpr"; DestDir: "{app}\simlib\nativejpg\demos\tiledemo";
Source: "..\demos\tiledemo\TileDemo.dof"; DestDir: "{app}\simlib\nativejpg\demos\tiledemo";
Source: "..\demos\tiledemo\TileDemo.cfg"; DestDir: "{app}\simlib\nativejpg\demos\tiledemo";
Source: "..\demos\tiledemo\TileDemo.res"; DestDir: "{app}\simlib\nativejpg\demos\tiledemo";
Source: "..\demos\tiledemo\TileDemoMain.pas"; DestDir: "{app}\simlib\nativejpg\demos\tiledemo";
Source: "..\demos\tiledemo\TileDemoMain.dfm"; DestDir: "{app}\simlib\nativejpg\demos\tiledemo";

; viewer demo
Source: "..\demos\viewer\viewer.dpr"; DestDir: "{app}\simlib\nativejpg\demos\viewer";
Source: "..\demos\viewer\viewer.dof"; DestDir: "{app}\simlib\nativejpg\demos\viewer";
Source: "..\demos\viewer\viewer.cfg"; DestDir: "{app}\simlib\nativejpg\demos\viewer";
Source: "..\demos\viewer\viewer.res"; DestDir: "{app}\simlib\nativejpg\demos\viewer";
Source: "..\demos\viewer\viewerMain.dfm"; DestDir: "{app}\simlib\nativejpg\demos\viewer";
Source: "..\demos\viewer\viewerMain.pas"; DestDir: "{app}\simlib\nativejpg\demos\viewer";

; viewer32 demo for gr32
Source: "..\demos\viewer32\NativeJpg32.pas"; DestDir: "{app}\simlib\nativejpg\demos\viewer32";
Source: "..\demos\viewer32\viewer32.dpr"; DestDir: "{app}\simlib\nativejpg\demos\viewer32";
Source: "..\demos\viewer32\viewer32.dof"; DestDir: "{app}\simlib\nativejpg\demos\viewer32";
Source: "..\demos\viewer32\viewer32.cfg"; DestDir: "{app}\simlib\nativejpg\demos\viewer32";
Source: "..\demos\viewer32\viewer32.res"; DestDir: "{app}\simlib\nativejpg\demos\viewer32";
Source: "..\demos\viewer32\viewer32Main.dfm"; DestDir: "{app}\simlib\nativejpg\demos\viewer32";
Source: "..\demos\viewer32\viewer32Main.pas"; DestDir: "{app}\simlib\nativejpg\demos\viewer32";

; nativejpg packages
Source: "..\packages\NativeJpgD7.dpk"; DestDir: "{app}\simlib\nativejpg\packages";
Source: "..\packages\NativeJpgD7.res"; DestDir: "{app}\simlib\nativejpg\packages";
Source: "..\packages\NativeJpgDXE.dpk"; DestDir: "{app}\simlib\nativejpg\packages";
Source: "..\packages\NativeJpgDXE.dproj"; DestDir: "{app}\simlib\nativejpg\packages";
Source: "..\packages\NativeJpgDXE.res"; DestDir: "{app}\simlib\nativejpg\packages";

; nativejpg source
Source: "..\NativeJpg.pas"; DestDir: "{app}\simlib\nativejpg";
Source: "..\sdJpegBitstream.pas"; DestDir: "{app}\simlib\nativejpg";
Source: "..\sdJpegCoder.pas"; DestDir: "{app}\simlib\nativejpg";
Source: "..\sdJpegDCT.pas"; DestDir: "{app}\simlib\nativejpg";
Source: "..\sdJpegHuffman.pas"; DestDir: "{app}\simlib\nativejpg";
Source: "..\sdJpegImage.pas"; DestDir: "{app}\simlib\nativejpg";
Source: "..\sdJpegLossless.pas"; DestDir: "{app}\simlib\nativejpg";
Source: "..\sdJpegMarkers.pas"; DestDir: "{app}\simlib\nativejpg";
Source: "..\sdJpegTypes.pas"; DestDir: "{app}\simlib\nativejpg";

; simlib bitmap
Source: "..\..\bitmap\sdMapIterator.pas"; DestDir: "{app}\simlib\bitmap";
Source: "..\..\bitmap\sdBitmapConversionWin.pas"; DestDir: "{app}\simlib\bitmap";
Source: "..\..\bitmap\sdBitmapResize.pas"; DestDir: "{app}\simlib\bitmap";

; simlib disk
Source: "..\..\disk\sdFileList.pas"; DestDir: "{app}\simlib\disk";

; simlib general
Source: "..\..\general\simdesign.inc"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdSortedLists.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdDebug.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdStreams.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdMetadata.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdMetadataCiff.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdMetadataExif.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdMetadataIptc.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdMetadataJpg.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdMetadataTiff.pas"; DestDir: "{app}\simlib\general";

; simlib color
Source: "..\..\color\sdColorTransforms.pas"; DestDir: "{app}\simlib\color";

; virtualscrollbox
Source: "..\..\virtualscrollbox\sdVirtualScrollbox.pas"; DestDir: "{app}\simlib\virtualscrollbox";

; extlib
Source: "..\..\..\extlib\color\lcms\lcms.dll"; DestDir: "{app}\extlib\color\lcms";
Source: "..\..\..\extlib\color\lcms\lcmsdll.pas"; DestDir: "{app}\extlib\color\lcms";
Source: "..\..\..\extlib\color\lcms\LittleCMS_License.txt"; DestDir: "{app}\extlib\color\lcms";
Source: "..\..\..\extlib\extmem\Fast\FastMM.pas"; DestDir: "{app}\extlib\extmem\Fast";


























