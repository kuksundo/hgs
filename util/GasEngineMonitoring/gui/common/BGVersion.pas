(*----------------------------------------------------------------
  File : BGVersion.pas

  Description
    리소스의 버전 정보를 읽는다

    
  MODIFIED
  2009/03/11 Kim Byung Gun   Create


  Note
    현재 프로젝트에서는 Major, Minor 정보만 필요하기에 그 외에는
    인터페이스를 생성하지 않았지만 실제는 VS_FIXEDFILEINFO 를
    저장하고 있다.

  사용법 : ShowMessage( TBGVersion.GetInstance().ToString()  );
----------------------------------------------------------------*)
unit BGVersion;
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
////                        Interface                         ////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
interface
//////////////////////////////////////////////////////////////////
//                             Uses                             //
//////////////////////////////////////////////////////////////////
uses
  windows;      // for TVSFixedFileInfo
//////////////////////////////////////////////////////////////////
//                      type definition                         //
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// Class definition
type
  ////////////////////////////////////////////////////////////////
  // TBGVersion
  TBGVersion = class
  // class function
  public
    class function GetInstance() : TBGVersion;
  // constructor & destructor
  public
    constructor Create();
    destructor  Destory();
  // public functions
  public
    function  ToString() : string;
  // private functions
  private
    procedure ReadInfo();
    function  GetMajor() : WORD;
    function  GetMinor() : WORD;
    function  GetRelease() : WORD;
    function  GetBuild() : WORD;
  // member variable
  private
    m_fixedFileInfo : TVSFixedFileInfo;

  // properties
  public
    property  Build : WORD read GetBuild;
    property  Major : WORD  read GetMajor;
    property  Minor : WORD  read GetMinor;
    property  Release : WORD read GetRelease;
  end;

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
////                     Implementation                       ////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
implementation
//////////////////////////////////////////////////////////////////
//                       Private Uses                           //
//////////////////////////////////////////////////////////////////
uses
  SysUtils;       // for Format()
//////////////////////////////////////////////////////////////////
//                   Private Global Variables                   //
//////////////////////////////////////////////////////////////////
var
  // singleton 으로 구현
  __g_version : TBGVersion;
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
////                    TBGVersion implementation             ////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

(*----------------------------------------------------------------
  Name    : TBGVersion.GetInstance()
  Desc    : return to instance
  Input   : None
  Output  : TBGVersion instance
----------------------------------------------------------------*)
class function TBGVersion.GetInstance: TBGVersion;
begin
  if( __g_version = nil  ) then
    __g_version := TBGVersion.Create();
  Result := __g_version;
end;

(*----------------------------------------------------------------
  Name   :  TBGVersion.Create()
  Desc   :  constructor
----------------------------------------------------------------*)
constructor TBGVersion.Create;
begin
  ReadInfo();
end;

(*----------------------------------------------------------------
  Name   :  TBGVersion.Destory()
  Desc   :  destructor
----------------------------------------------------------------*)
destructor TBGVersion.Destory;
begin

end;

(*----------------------------------------------------------------
  Name    : TBGVersion.ToString()
  Desc    : return string to version infomation
  Input   : None
  Output  : version infomation string
----------------------------------------------------------------*)
function TBGVersion.ToString() : string;
begin
  Result := Format( '%u.%u.%u.%u', [ Major, Minor, Release, Build] ) ;
end;

(*----------------------------------------------------------------
  Name   :  TBGVersion.ReadInfo()
  Desc   :  리소스로부터 버전 정보를 얻는다
  Input   : None
  Output  : None
----------------------------------------------------------------*)
procedure TBGVersion.ReadInfo;
var
  hVersion : THandle;
  hResVersion : THandle;
  pVersionInfoInstance : Pointer;
  pVersionInfo : Pointer;
  pFixedFileInfo  : Pointer;
  wInfoSize : WORD;
  dwLen : DWord;
begin
  pVersionInfo := nil;
  pVersionInfoInstance := nil;
  dwLen := 0;              

  hVersion := FindResource( hInstance, MAKEINTRESOURCE(VS_VERSION_INFO), RT_VERSION );
  if hVersion <> 0 then
  begin
    hResVersion := LoadResource( hInstance, hVersion );
    if hResVersion <> 0 then
    begin
      pVersionInfo := LockResource( hResVersion );
      if pVersionInfo <> nil then
      begin
        (*
            VS_VERSIONINFO {
                WORD  wLength;
                WORD  wValueLength;
                WORD  wType;
                WCHAR szKey[];
                WORD  Padding1[];
                VS_FIXEDFILEINFO Value;
                WORD  Padding2[];
                WORD  Children[];
              };
        *)
        // 버전 정보 크기를 구한다
        Move( pVersionInfo^, wInfoSize, sizeof(WORD) );
        
        GetMem( pVersionInfoInstance, wInfoSize );
        Move( pVersionInfo^, pVersionInfoInstance^, wInfoSize);

        VerQueryValue(pVersionInfoInstance,'\', Pointer(pFixedFileInfo),dwLen);
        Move(pFixedFileInfo^, m_fixedFileInfo, sizeof(TVSFixedFileInfo) );
      end;  // end if pVersionInfo <> 0 then
    end;  // end if hResVersion <> 0 then

    UnlockResource( hResVersion );
    FreeResource( hResVersion );
    FreeMem(pVersionInfoInstance);    
  end;   // end if hVersion <> 0 then
end;

(*----------------------------------------------------------------
  Name   :  TBGVersion.GetBuild()
  Desc   :  return to build version
  Input   : None
  Output  : build version
----------------------------------------------------------------*)
function TBGVersion.GetBuild: WORD;
begin
  Result := LoWord(m_fixedFileInfo.dwProductVersionLS);
end;

(*----------------------------------------------------------------
  Name   :  TBGVersion.GetBuild()
  Desc   :  return to major version
  Input   : None
  Output  : major version
----------------------------------------------------------------*)
function TBGVersion.GetMajor: WORD;
begin
  Result := HiWord(m_fixedFileInfo.dwProductVersionMS);
end;

(*----------------------------------------------------------------
  Name   :  TBGVersion.GetMinor()
  Desc   :  return to minor version
  Input   : None
  Output  : minor version
----------------------------------------------------------------*)
function TBGVersion.GetMinor: WORD;
begin
  Result := LoWord(m_fixedFileInfo.dwProductVersionMS);
end;

(*----------------------------------------------------------------
  Name   :  TBGVersion.GetRelease()
  Desc   :  return to release version
  Input   : None
  Output  : release version
----------------------------------------------------------------*)
function TBGVersion.GetRelease: WORD;
begin
  Result := HiWord(m_fixedFileInfo.dwProductVersionLS);
end;

end.
