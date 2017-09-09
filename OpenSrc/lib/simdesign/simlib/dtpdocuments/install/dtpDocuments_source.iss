; dtpDocuments installer script

[Setup]
AppName=DtpDocuments Component Source
AppVerName=DtpDocuments Component Source v2.92
AppCopyright=Copyright (C) 2001-2011 SimDesign BV
DefaultDirName={pf}\SimDesign\DtpDocuments292
DefaultGroupName=SimDesign
LicenseFile=..\license.txt
InfoAfterFile=..\Readme.txt
;DisableStartupPrompt=yes
OutputBaseFilename=DtpDocuments292

[Icons]
Name: "{userdesktop}\DtpDocuments v2.92"; Filename: "{app}"; Tasks: desktopicon

[Dirs]
Name: "{app}\simlib\dtpdocuments\demos\Editor\dcu"
Name: "{app}\simlib\dtpdocuments\demos\Editor\exe"
Name: "{app}\simlib\dtpdocuments\demos\MultiDemo\dcu"
Name: "{app}\simlib\dtpdocuments\demos\MultiDemo\exe"
Name: "{app}\simlib\dtpdocuments\demos\BitmapMasks\exe"
Name: "{app}\simlib\dtpdocuments\demos\BitmapMasks\dcu"
Name: "{app}\simlib\dtpdocuments\demos\SpeechBubbles\exe"
Name: "{app}\simlib\dtpdocuments\demos\SpeechBubbles\dcu"
Name: "{app}\simlib\dtpdocuments\packages\dcu"

[Components]
Name: "extplugin"; Description: "Install External Graphics plugins"; types: full;

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon";

[Messages]
SelectTasksLabel2=Select the additional tasks you would like Setup to perform while installing [name], then click Next.%n%nYou must close all running instances of Delphi before you continue!

[Files]
Source: "..\License.txt"; DestDir: "{app}"
Source: "..\Readme.txt"; DestDir: "{app}"

; package Delphi7
Source: "..\packages\dtpDocumentsD7.dpk"; DestDir: "{app}\simlib\dtpdocuments\packages";
Source: "..\packages\dtpDocumentsD7.res"; DestDir: "{app}\simlib\dtpdocuments\packages";

; package DelphiXE
Source: "..\packages\dtpDocumentsDXE.dpk"; DestDir: "{app}\simlib\dtpdocuments\packages";
Source: "..\packages\dtpDocumentsDXE.dproj"; DestDir: "{app}\simlib\dtpdocuments\packages";
Source: "..\packages\dtpDocumentsDXE.res"; DestDir: "{app}\simlib\dtpdocuments\packages";

; Demos
Source: "..\demos\Editor\DropCursors.res"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor"
Source: "..\demos\Editor\Editor.cfg"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor"
Source: "..\demos\Editor\Editor.dpr"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor"
Source: "..\demos\Editor\Editor.dof"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor"
Source: "..\demos\Editor\Editor.res"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor"
Source: "..\demos\Editor\Readme.txt"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor"
Source: "..\demos\Editor\*.dfm"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor"
Source: "..\demos\Editor\*.pas"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor"
Source: "..\demos\Editor\exe\Colors.dtp"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor\exe"
Source: "..\demos\Editor\exe\DemoDocument.dtp"; DestDir: "{app}\simlib\dtpdocuments\demos\Editor\exe"

Source: "..\demos\MultiDemo\MultiDemo.cfg"; DestDir: "{app}\simlib\dtpdocuments\demos\MultiDemo"
Source: "..\demos\MultiDemo\MultiDemo.dpr"; DestDir: "{app}\simlib\dtpdocuments\demos\MultiDemo"
Source: "..\demos\MultiDemo\MultiDemo.res"; DestDir: "{app}\simlib\dtpdocuments\demos\MultiDemo"
Source: "..\demos\MultiDemo\Readme.txt"; DestDir: "{app}\simlib\dtpdocuments\demos\MultiDemo"
Source: "..\demos\MultiDemo\*.dfm"; DestDir: "{app}\simlib\dtpdocuments\demos\MultiDemo"
Source: "..\demos\MultiDemo\*.pas"; DestDir: "{app}\simlib\dtpdocuments\demos\MultiDemo"

Source: "..\demos\BitmapMasks\BitmapMask.cfg"; DestDir: "{app}\simlib\dtpdocuments\demos\BitmapMasks"
Source: "..\demos\BitmapMasks\BitmapMask.dpr"; DestDir: "{app}\simlib\dtpdocuments\demos\BitmapMasks"
Source: "..\demos\BitmapMasks\BitmapMask.res"; DestDir: "{app}\simlib\dtpdocuments\demos\BitmapMasks"
Source: "..\demos\BitmapMasks\*.jpg"; DestDir: "{app}\simlib\dtpdocuments\demos\BitmapMasks"
Source: "..\demos\BitmapMasks\*.dfm"; DestDir: "{app}\simlib\dtpdocuments\demos\BitmapMasks"
Source: "..\demos\BitmapMasks\*.pas"; DestDir: "{app}\simlib\dtpdocuments\demos\BitmapMasks"

Source: "..\demos\SpeechBubbles\dtpSpeechBubbles.pas"; DestDir: "{app}\simlib\dtpdocuments\demos\SpeechBubbles"
Source: "..\demos\SpeechBubbles\SpeechBubbles.dpr"; DestDir: "{app}\simlib\dtpdocuments\demos\SpeechBubbles"
Source: "..\demos\SpeechBubbles\SpeechBubblesMain.pas"; DestDir: "{app}\simlib\dtpdocuments\demos\SpeechBubbles"
Source: "..\demos\SpeechBubbles\SpeechBubblesMain.dfm"; DestDir: "{app}\simlib\dtpdocuments\demos\SpeechBubbles"

; Docu
;Source: "..\docu\DtpDocuments.chm"; DestDir: "{app}"
Source: "..\versions.txt"; DestDir: "{app}"
Source: "..\issues.txt"; DestDir: "{app}"

; Sources
Source: "..\source\*.res"; DestDir: "{app}\simlib\dtpdocuments\source"
Source: "..\source\*.dcr"; DestDir: "{app}\simlib\dtpdocuments\source"
Source: "..\source\*.dfm"; DestDir: "{app}\simlib\dtpdocuments\source"
Source: "..\source\*.pas"; DestDir: "{app}\simlib\dtpdocuments\source"
Source: "..\source\*.inc"; DestDir: "{app}\simlib\dtpdocuments\source"

; Third party GR32
Source: "..\..\..\extlib\graphics32_190\*.inc"; DestDir: "{app}\extlib\graphics32_190";
Source: "..\..\..\extlib\graphics32_190\*.pas"; DestDir: "{app}\extlib\graphics32_190";
Source: "..\..\..\extlib\graphics32_190\*.txt"; DestDir: "{app}\extlib\graphics32_190";

; Third party ColorPickerButton
Source: "..\..\..\extlib\ColorPickerButton\*.pas"; DestDir: "{app}\extlib\ColorPickerButton";
Source: "..\..\..\extlib\ColorPickerButton\*.dcr"; DestDir: "{app}\extlib\ColorPickerButton";

; Third party RsRuler
Source: "..\..\..\extlib\RsRuler\dtpRsRuler.pas"; DestDir: "{app}\extlib\RsRuler";
Source: "..\..\..\extlib\RsRuler\dtpRsRuler.dcr"; DestDir: "{app}\extlib\RsRuler";
Source: "..\..\..\extlib\RsRuler\dtpRsRuler.txt"; DestDir: "{app}\extlib\RsRuler";

; Third party gifimage
Source: "..\..\..\extlib\formats\gifimage\*.pas"; DestDir: "{app}\extlib\formats\gifimage";
Source: "..\..\..\extlib\formats\gifimage\*.txt"; DestDir: "{app}\extlib\formats\gifimage";

; Third party CWBudde's GR32_PNG
Source: "..\..\..\extlib\Formats\png\*.pas"; DestDir: "{app}\extlib\Formats\png";
Source: "..\..\..\extlib\Formats\png\*.inc"; DestDir: "{app}\extlib\Formats\png";

; nativexml
Source: "..\..\nativexml\*.txt"; DestDir: "{app}\simlib\nativexml";
Source: "..\..\nativexml\NativeXml.pas"; DestDir: "{app}\simlib\nativexml";
;Source: "..\..\nativexml\NativeXmlC14n.pas"; DestDir: "{app}\simlib\nativexml";
Source: "..\..\nativexml\NativeXmlObjectStorage.pas"; DestDir: "{app}\simlib\nativexml";

; virtualscrollbox
Source: "..\..\virtualscrollbox\*.txt"; DestDir: "{app}\simlib\virtualscrollbox";
Source: "..\..\virtualscrollbox\*.pas"; DestDir: "{app}\simlib\virtualscrollbox";

; simlib general source
Source: "..\..\bitmap\sdMapIterator.pas"; DestDir: "{app}\simlib\bitmap";
Source: "..\..\bitmap\sdBitmapConversionWin.pas"; DestDir: "{app}\simlib\bitmap";
Source: "..\..\bitmap\sdBitmapResize.pas"; DestDir: "{app}\simlib\bitmap";
;Source: "..\..\bitmap\sdBitmapPlatform.pas"; DestDir: "{app}\simlib\bitmap";
;Source: "..\..\bitmap\sdGraphicTypes.pas"; DestDir: "{app}\simlib\bitmap";

Source: "..\..\disk\sdFileList.pas"; DestDir: "{app}\simlib\disk";

Source: "..\..\general\simdesign.inc"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdDebug.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdSortedLists.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdWidestrings.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdStreams.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdOptionRefs.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdStorage.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdStringTable.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdBufferParser.pas"; DestDir: "{app}\simlib\general";
Source: "..\..\general\sdStringEncoding.pas"; DestDir: "{app}\simlib\general";

Source: "..\..\color\sdColorTransforms.pas"; DestDir: "{app}\simlib\color";
Source: "..\..\virtualscrollbox\sdVirtualScrollbox.pas"; DestDir: "{app}\simlib\virtualscrollbox";

; nativejpg source
Source: "..\..\nativejpg\*.txt"; DestDir: "{app}\simlib\nativejpg";
Source: "..\..\nativejpg\*.pas"; DestDir: "{app}\simlib\nativejpg";

; external color manager lcms
Source: "..\..\..\extlib\color\lcms\lcms.dll"; DestDir: "{app}\extlib\color\lcms"; components: "extplugin";
Source: "..\..\..\extlib\color\lcms\lcmsdll.pas"; DestDir: "{app}\extlib\color\lcms"; components: "extplugin";
Source: "..\..\..\extlib\color\lcms\LittleCMS_License.txt"; DestDir: "{app}\extlib\color\lcms"; components: "extplugin";
Source: "..\..\..\extlib\extmem\Fast\FastMM.pas"; DestDir: "{app}\extlib\extmem\Fast"; components: "extplugin";

[UninstallDelete]

[Run]





































