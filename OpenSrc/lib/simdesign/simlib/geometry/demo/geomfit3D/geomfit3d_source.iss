[Setup]
AppName=geomfit3d
AppVerName=geomfit3d 1.00 ("Source" version)
AppPublisher=SimDesign B.V.
AppPublisherURL=http://www.simdesign.nl
AppSupportURL=http://www.simdesign.nl
AppUpdatesURL=http://www.simdesign.nl
DefaultDirName={pf}\SimDesign\GeomFit3D_100
DefaultGroupName=GeomFit3D
;LicenseFile=License_opensource.txt
;InfoBeforeFile=Readme_opensource.txt
OutputBaseFilename=geomfit3d

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"

[Icons]
Name: "{userdesktop}\GeomFit3D v1.00"; Filename: "{app}"; Tasks: desktopicon

[Dirs]
Name: "{app}\geometry\demo\geomfit3d\data"
Name: "{app}\geometry\demo\geomfit3d\dcu"
Name: "{app}\geometry\demo\geomfit3d\exe"
Name: "{app}\geometry"
Name: "{app}\general"

[Files]

; Main folder
source: "versions.txt"; Destdir: "{app}";
source: "readme.txt"; Destdir: "{app}";

; testfiles
Source: "data\cone.p3d";  DestDir: "{app}\geometry\demo\geomfit3d\data";
Source: "data\large countersink with noise.csv"; DestDir: "{app}\geometry\demo\geomfit3d\data";

; geomfit3d source
Source: "GeomFit.cfg"; DestDir: "{app}\geometry\demo\geomfit3d";
Source: "GeomFit.dof"; DestDir: "{app}\geometry\demo\geomfit3d";
Source: "GeomFit.dpr"; DestDir: "{app}\geometry\demo\geomfit3d";
Source: "GeomFitMain.dfm"; DestDir: "{app}\geometry\demo\geomfit3d";
Source: "GeomFitMain.pas"; DestDir: "{app}\geometry\demo\geomfit3d";

; geometry source
source: "..\..\sdGeomFit3D.pas"; Destdir: "{app}\geometry";
source: "..\..\sdPoints3D.pas"; Destdir: "{app}\geometry";
source: "..\..\sdMatrices.pas"; Destdir: "{app}\geometry";

source: "..\..\..\general\sdDebug.pas"; DestDir: "{app}\general";
source: "..\..\..\Formats3D\simple\sdP3DFormat.pas"; DestDir: "{app}\Formats3D\simple";
source: "..\..\..\Formats3D\simple\sdCSVFormat.pas"; DestDir: "{app}\Formats3D\simple";


















