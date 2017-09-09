[Setup]
AppName=Triangulator
AppVerName=Triangulator 1.01 (Source version)
AppPublisher=SimDesign B.V.
AppPublisherURL=http://www.simdesign.nl
AppSupportURL=http://www.simdesign.nl
AppUpdatesURL=http://www.simdesign.nl
DefaultDirName={pf}\Triangulator101
DefaultGroupName=Triangulator
LicenseFile=License_source.txt
OutputBaseFilename=Triangulator101

[Icons]
Name: "{userdesktop}\Triangulator v1.01"; Filename: "{app}"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"

[Dirs]
Name: "{app}\general"
Name: "{app}\geometry"
Name: "{app}\geometry\demo\triangulator"
Name: "{app}\geometry\demo\triangulator\dcu"
Name: "{app}\geometry\demo\triangulator\exe"

[Files]

; Main folder
Source: "License_source.txt"; DestDir: "{app}"; DestName: "License.txt";

; Documentation
Source: "..\docu\Triangulator.chm"; DestDir: "{app}";
Source: "..\versions.txt"; DestDir: "{app}";

; Demos
Source: "..\TestTriang2D.dpr"; DestDir: "{app}\geometry\demo\triangulator";
Source: "..\TestTriang2DMain.pas"; DestDir: "{app}\geometry\demo\triangulator";
Source: "..\TestTriang2DMain.dfm"; DestDir: "{app}\geometry\demo\triangulator";

; Source
Source: "..\..\..\sdTriMesh2D.pas"; DestDir: "{app}\geometry";
Source: "..\..\..\sdTriangulate2D.pas"; DestDir: "{app}\geometry";
Source: "..\..\..\sdPoints2D.pas"; DestDir: "{app}\geometry";
Source: "..\..\..\sdDelaunay2D.pas"; DestDir: "{app}\geometry";
Source: "..\..\..\sdConvexHull2D.pas"; DestDir: "{app}\geometry";
Source: "..\..\..\..\general\sdSortedLists.pas"; DestDir: "{app}\general";
Source: "..\..\..\..\general\sdDebug.pas"; DestDir: "{app}\general";
Source: "..\..\..\..\general\simdesign.inc"; DestDir: "{app}\general";




