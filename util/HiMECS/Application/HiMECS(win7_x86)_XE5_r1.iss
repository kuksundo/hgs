;상수선언

#define AppName "HiMECS"
#define AppVerName "HiMECS v0.1(Win7)"
#define AppPublisher "jh park"

 

[Setup]
ChangesEnvironment=true
AppName={#AppName}(HiMsen Engine Control System)
;Setup파일 제목
AppVerName={#AppVerName}
;설치될 이름및 버전
AppPublisher={#AppPublisher}
;게시자
AllowNoIcons=no
;yes로 하면 시작메뉴에 프로그램 바로가기를 건너띔 (기본no)
DefaultDirName={pf}\{#AppName}
;설치할 폴더위치
DisableDirPage=no
;설치할 폴더의 위치를 보여줄지 여부 Yes면 안보여줌
DefaultGroupName={#AppName}
;시작 프로그램 폴더 그룹명
DisableProgramGroupPage=yes
;시작 프로그램 폴더 그룹 보여줄지 여부 Yes면 안보여줌
LicenseFile=e:\pjh\Project\util\HiMECS\Application\Document\license.txt
;라이센스 파일
;InfoBeforeFile=D:\Myproject\haminfo Project\Project\Infomation.txt
;설치시 준비파일
;InfoAfterFile=D:\Myproject\haminfo Project\Project\History.txt
;설치후 보여질 파일
DisableFinishedPage=no
;설치중 백그라운드로 실행되는 모드 대기 여부
OutputDir=e:\pjh\Project\util\HiMECS\Application\Setup
;설치파일이 컴파일 된 후 저장될 위치(실행파일 생성위치)
OutputBaseFilename=HiMECS Setup(Win7)
;설치파일이 컴파일된 후 파일이름(실행파일 이름)
;SetupIconFile=C:\Program Files (x86)\Inno Setup 5\Examples\setup.ico
;설치파일 만든놈의 아이콘 (실행파일 아이콘)
Password=himecs
;설치시 비밀번호
;WizardImageFile=D:\Myproject\haminfo Project\imgaes\title.bmp
;설치시 나오는 왼쪽그림
Compression=lzma
;압축 방식-기본(lzma)
SolidCompression=yes
;압축 해서 Setup파일을 만들꺼냐? Yes/No
VersionInfoDescription={#AppName}
;생성된 파일의 Description속성
VersionInfoVersion=0.1
;생성된 파일의 ProductVersion속성
VersionInfoCopyright={#AppPublisher}
;생성된 파일의 Copyright속성
UninstallFilesDir={app}
;삭제 프로그램의 폴더위치
Uninstallable=yes
;삭제 지원여부
;UninstallDisplayIcon=D:\Myproject\haminfo Project\imgaes\Uninstall_ico.ico
;시작 - 모든프로그램 메뉴에서 삭제표시할 아이콘
UninstallDisplayName={#AppName} uninstall
;제어판 : 프로그램 추가/삭제에 표시될 제목
CreateUninstallRegKey=yes
;제어판 : 프로그램 추가/삭제 항목에 표시여부 (기본 yes)
PrivilegesRequired=admin
;설치 프로그램에 admin 권한을 줌- win7/program files에 쓰기 위함
 
[dirs]
Name: "{app}"; Permissions: everyone-full;

[Languages]
;Name: korean; MessagesFile: compiler:Languages\Korean.isl

; 한글화

 

[Tasks]
Name: "desktopicon"; Description: {cm:CreateDesktopIcon}; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
;설치중 추가작업으로 바탕화면에 아이콘을 만들지...
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
;설치중 추가작업으로 퀵 런치에 아이콘을 만들지...

 

[Files]
;ignoreversion(버전무시), recursesubdirs(하위폴더까지 복사), createallsubdirs(하위폴더 없으면 만들기),
;overwritereadonly(쓰기금지된 파일까지 업어쓰기), external(설치파일에 포함안된 외부파일을 설치함)
;skipifsourcedoesntexist(컴파일시나 실행시에 소스가 없어도 에러메세지를 안냄-매뉴얼이나 cd에 있을 경우 사용하면됨)
;confirmoverwrite(기존파일을 덮어쓸때 물어보기), regserver (DLL/OCX,등록) ,restartreplace (재부팅 메세지표시),
;sharedfile , promptifolder (기존파일 유지)

 

Source: e:\pjh\Project\util\HiMECS\Application\Bin\*; DestDir: {app}; Flags: ignoreversion recursesubdirs


; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\bdertl190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\dbrtl190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\designide190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\ggbar.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\jcl190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\jclvcl190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\jvcore190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\jvcustom190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\jvdlgs190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\jvglobus190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\jvstdctrls190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\jvsystem190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\NxCollectionRun_DXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\NxInspectorRun_DXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\NxCommonRun_DXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\NxGridRun_DXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\NxSheetRun_DXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\IocompDelphiXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\DCP_XE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
;Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\SivakSQLite3.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: E:\pjh\project\util\VisualComm\Component\bpl\\ggButton.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\cepack.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\IndySystem190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\IndyCore190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\rtl190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\vcl190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\vclactnband190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\vcldb190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\vclimg190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\vclx190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\xmlrtl190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\vclsmp190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\12.0\bin\DbxCommonDriver190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
;Source: C:\Program Files (x86)\Raize\CS5\Deploy\Win32\CodeSiteExpressPkg190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
;Source: C:\Program Files (x86)\Embarcadero\RAD Studio\9.0\Redist\Win32\DSnap190.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\TMSDeDXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\TMSDXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\TMSExDXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\TMSWizDXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: C:\Users\Public\Documents\RAD Studio\12.0\Bpl\TMSXlsDXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: e:\pjh\project\util\VisualComm\Component\bpl\ExtLib_DXE5.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: e:\pjh\project\util\VisualComm\Component\bpl\A2_pjhCompSharedPkg.bpl; DestDir: {app}\systembpl; Flags:promptifolder
Source: E:\pjh\project\util\VisualComm\Component\bpl\F1_pjhPackageUnits.bpl; DestDir: {app}\systembpl; Flags:promptifolder

[Code]
// 설치시

function InitializeSetup(): Boolean;

begin
  if not DirExists('C:\Program Files (x86)\MLA') then
    Result := MsgBox('Are you install the {#AppName}?', mbConfirmation, MB_YESNO) = idYes
  else
    MsgBox('설치하려는 곳에 이미 폴더가 있습니다.' #13#13 '설치를 중단 합니다, 기존 파일을 삭제후 다시 시도하세요.', mbInformation, MB_OK);
//mbConfirmation :물음표, mbInformation:느낌표, mbError:삼각느낌표, mbCriticalError:X표
end;

 

// 업글시
function UpgradeSetup(): Boolean;
begin
  if not DirExists('C:\Program Files (x86)\MLA') then
  begin
    MsgBox('본 프로그램은 업그레이드 버전입니다.' #13#10 '원본이 먼저 설치 되있어야 합니다,' #13#13 '문의 : 시화센터  ', mbCriticalError, MB_Ok)
  end else begin
    Result := true;
  end;
end;

//Path 추가
function SettingPath(newValue: String): String;
var
  V: string;
  LStr: string;
begin
  if RegQueryStringValue(HKLM, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'Path', V) then
  begin
    LStr := ExpandConstant('{app}')+'\systembpl';
    if Pos(LStr, V) = 0 then
      Result := V + ';' + LStr
    else
      Result := V;
  end;
end;

//PATHEXT 추가
function SettingPathExt(newValue: String): String;
var
  V: string;
  LStr: string;
begin
  if RegQueryStringValue(HKLM, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'PATHEXT', V) then
  begin
    LStr := '.bpl';
    if Pos(LStr, V) = 0 then
      Result := V + ';' + LStr
    else
      Result := V;
  end;
end;

function CheckSerial(Serial: String): Boolean;
begin
  // serial format is XXXX-XXXX-XXXX-XXXX
  Serial := Trim(Serial);
  if Length(Serial) = 19 then
    result := true;
end;

[Icons]
;시작 프로그램등록 사항
Name: {group}\HiMECS; Filename: {app}\HiMECS.exe; Comment: {#AppName}을 실행합니다.
Name: {group}\HiMECS information; Filename: {app}\Infomation.txt; Comment: {#AppName}의 Infomation을 봅니다.
Name: {group}\HiMECS Uninstall; Filename: {uninstallexe}; Comment: remove the {#AppName}.; IconFilename: {app}\imgaes\Uninstall_ico.ico
Name: {commondesktop}\HiMECS; Filename: {app}\HiMECS.exe; Comment: run {#AppName}.; Tasks: desktopicon
;[Tasks]의 "desktopicon"에 종속됨
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\HiMECS; Filename: {app}\HiMECS.exe; Comment: run {#AppName}.; Tasks: quicklaunchicon
;[Tasks]의 "quicklaunchicon"에 종속됨

 

[Run]
;Flags : runHidden(숨김실행), shellexec(연결프로그램 실행),nowait(설치완료까지 실행안함),hidewizard(실행시 마법사 숨김)
;postinstall(마법사 완료때 사용자가 선택하도록 함), skipifdoesntexist(실행시 해당 파일이 없으면 오류표시 안함)
;skipifsilent(설치중 건너 띄어지시함 ↔ skipifnotsilent)
;Filename: {app}\HiMECS.exe; Description: {#AppName} run; Flags: nowait postinstall skipifsilent
;Filename: {app}\dbinidel.bat; Description: Tmp,ini초기화; Flags: runHidden skipifsilent
;windows 방화벽에 통신 프로그램 자동 등록
;Filename: netsh; Parameters: "firewall add allowedprogram ""{app}\MyProg.exe"" ""tango MyProg"" ENABLE"; flags: runminimized shellexec; OnlyBelowVersion: 0,6
;Filename: netsh; Parameters: "advfirewall firewall add rule name=""MyProg"" dir=in action=allow program=""{app}\MyProg.exe"" enable=yes description=""tango MyProg"" profile=any"; flags: runminimized shellexec;  MinVersion: 0,6
;Filename: netsh; Parameters: "advfirewall firewall add rule name=""MyProg"" dir=out action=allow program=""{app}\MyProg.exe"" enable=yes description=""tango MyProg"" profile=any"; flags: runminimized shellexec;MinVersion: 0,6



 

[UninstallDelete]
Type: filesandordirs; Name: {pf}\{#AppName}

 

[Registry]
;Flags: uninsdeletevalue(제거시 ValueData 삭제), uninsdeletekey(제거시 기값 Haminfo 까지 삭제)
;createvalueifdoesntexist(값이 이미 있을 경우 등록안함),deletekey(값이 이미 있으면 삭제, 없으면 등록)
;deletevalue(value값이 있으면 지우고 없으면 등록),dontcreatekey(값이 이미있으면 경고 메세지 띄움)
;noerror(오류가 있어도 표시하지 않음),uninsclearvalue(제거시 reg등록),
;ValueType: string (REG_SZ), dword(REG_DWORD), binary(REG_BINARY)
Root: HKLM; Subkey: Software\inno Setup\MLA; ValueType: string; ValueName: install; ValueData: v1.0; Flags: uninsdeletekey
Root: HKLM; Subkey: SYSTEM\CurrentControlSet\Control\Session Manager\Environment; ValueType: string; ValueName: "Path"; ValueData: {code:SettingPath|''};
Root: HKLM; Subkey: SYSTEM\CurrentControlSet\Control\Session Manager\Environment; ValueType: string; ValueName: "PATHEXT"; ValueData: {code:SettingPathExt|''};

