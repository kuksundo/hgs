{.GXFormatter.config=twm}
unit u_dzVersionInfo;

interface

uses
  SysUtils;

type
  EApplicationInfo = class(Exception);
  EAIChecksumError = class(EApplicationInfo);
  EAIUnknownProperty = class(EApplicationInfo);
  EAIInvalidVersionInfo = class(EApplicationInfo);

type
  TFileProperty = (FpProductName, FpProductVersion, FpFileDescription, FpFileVersion, FpCopyright,
    FpCompanyName, FpTrademarks, fpInternalName, fpOriginalFilename);
  TFilePropertySet = set of TFileProperty;

type
  TVersionParts = (vpMajor, vpMajorMinor, vpMajorMinorRevision, vpFull);

type
  TFileVersionRec = record
    Major: Integer;
    Minor: Integer;
    Revision: Integer;
    Build: Integer;
    IsValid: Boolean;
    procedure CheckValid;
    procedure Init(_Major, _Minor, _Revision, _Build: Integer);
    class operator GreaterThan(_a, _b: TFileVersionRec): Boolean;
    class operator GreaterThanOrEqual(_a, _b: TFileVersionRec): Boolean;
    class operator Equal(_a, _b: TFileVersionRec): Boolean;
    class operator NotEqual(_a, _b: TFileVersionRec): Boolean;
    class operator LessThan(_a, _b: TFileVersionRec): Boolean;
    class operator LessThanOrEqual(_a, _b: TFileVersionRec): Boolean;
  end;

type
  IFileInfo = interface ['{BF3A3600-1E39-4618-BD7A-FBBD6C148C2E}']
    function HasVersionInfo: Boolean;
    procedure SetAllowExceptions(_Value: Boolean);
    ///<summary> If set to false, any exceptions will be ignored and an empty string will
    ///          be returned. </summary>
    property AllowExceptions: Boolean write SetAllowExceptions;
    ///<summary> The file name.</summary>
    function Filename: string;
    ///<summary> The file directory whithout the filename with a terminating backslash </summary>
    function FileDir: string;
    ///<summary> The file description from the version resource </summary>
    function FileDescription: string;
    ///<summary> The file version from the file version resource </summary>
    function FileVersion: string;
    function FileVersionRec: TFileVersionRec;
    function FileVersionStr(_Parts: TVersionParts = vpMajorMinorRevision): string;
    ///<summary> The file's product name from the version resource </summary>
    function ProductName: string;
    ///<summary> The the product version from the version resource </summary>
    function ProductVersion: string;
    ///<summary> The company name from the version resource </summary>
    function Company: string; deprecated; // use CompanyName
    ///<summary> The company name from the version resource </summary>
    function CompanyName: string;
    ///<summary> The LegalCopyRight string from the file version resources </summary>
    function LegalCopyRight: string;
    ///<summary> The LegalTrademark string from the file version resources </summary>
    function LegalTradeMarks: string;
    function InternalName: string;
    function OriginalFilename: string;
  end;

type
  ///<summary> abstract ancestor, do not instantiate this class, instantiate one of
  ///          the derived classes below </summary>
  TCustomFileInfo = class(TInterfacedObject)
  private
    type
      TEXEVersionData = record
        CompanyName,
          FileDescription,
          FileVersion,
          InternalName,
          LegalCopyRight,
          LegalTradeMarks,
          OriginalFilename,
          ProductName,
          ProductVersion,
          Comments,
          PrivateBuild,
          SpecialBuild: string;
      end;
  private
    FAllowExceptions: Boolean;
    FFilename: string;

    FFilePropertiesRead: Boolean;
    FFileProperties: array[TFileProperty] of string;
    function GetFileProperty(_Property: TFileProperty): string; virtual;
    function ReadVersionData: TEXEVersionData;
  protected // implements IFileInfo
    procedure SetAllowExceptions(_Value: Boolean);
    function HasVersionInfo: Boolean;

    function Filename: string;
    function FileDir: string;
    function FileDescription: string;
    function FileVersion: string;
    function FileVersionRec: TFileVersionRec; virtual;
    function FileVersionStr(_Parts: TVersionParts = vpMajorMinorRevision): string;

    function ProductName: string;
    function ProductVersion: string;
    ///<summary> The company name from the version resource </summary>
    function Company: string;
    ///<summary> The company name from the version resource </summary>
    function CompanyName: string;
    ///<summary> The LegalCopyRight string from the file version resources </summary>
    function LegalCopyRight: string;
    ///<summary> The LegalTrademark string from the file version resources </summary>
    function LegalTradeMarks: string;
    function InternalName: string;
    function OriginalFilename: string;
  public
    constructor Create;
    destructor Destroy; override;
    property AllowExceptions: Boolean read FAllowExceptions write SetAllowExceptions;
  end;

type
  ///<summary> Get informations about the given file.</summary>
  TFileInfo = class(TCustomFileInfo, IFileInfo)
  public
    constructor Create(const _Filename: string);
  end;

type
  ///<summary> Get informations about the current executable
  ///          If called from a dll it will return the info about the
  ///          calling executable, if called from an executable, it will return
  ///          info about itself. </summary>
  TApplicationInfo = class(TCustomFileInfo, IFileInfo)
  public
    constructor Create;
  end;

type
  ///<summary> Get informations about the current DLL.
  ///          It will always return info about itself regardless of whether it is
  ///          called from a dll or an executable </summary>
  TDllInfo = class(TCustomFileInfo, IFileInfo)
  public
    constructor Create;
  end;

type
  TDummyFileInfo = class(TCustomFileInfo, IFileInfo)
  protected
    function GetFileProperty(_Property: TFileProperty): string; override;
    function FileVersionRec: TFileVersionRec; override;
  public
    constructor Create;
  end;

implementation

uses
  Windows,
  Forms,
  u_dzTranslator,
  u_dzOsUtils;

{ TCustomFileInfo }

constructor TCustomFileInfo.Create;
begin
  inherited;

  FAllowExceptions := True;
  FFilePropertiesRead := False;
end;

function TCustomFileInfo.Filename: string;
begin
  Result := FFilename;
end;

destructor TCustomFileInfo.Destroy;
begin
  inherited;
end;

function TCustomFileInfo.FileDescription: string;
begin
  Result := GetFileProperty(FpFileDescription);
end;

function TCustomFileInfo.FileDir: string;
begin
  Result := ExtractFileDir(Filename);
  if Result <> '' then
    Result := IncludeTrailingPathDelimiter(Result);
end;

procedure TCustomFileInfo.SetAllowExceptions(_Value: Boolean);
begin
  FAllowExceptions := _Value;
end;

function TCustomFileInfo.ReadVersionData: TEXEVersionData;
// code taken from http://stackoverflow.com/a/5539411/49925
type
  PLandCodepage = ^TLandCodepage;
  TLandCodepage = record
    wLanguage,
      wCodePage: Word;
  end;
var
  Dummy,
    Len: Cardinal;
  Buf, pntr: Pointer;
  lang: string;
begin
  Len := GetFileVersionInfoSize(PChar(Filename), Dummy);
  if Len = 0 then
    RaiseLastOSError;
  GetMem(Buf, Len);
  try
    if not GetFileVersionInfo(PChar(Filename), 0, Len, Buf) then
      RaiseLastOSError;

    if not VerQueryValue(Buf, '\VarFileInfo\Translation\', pntr, Len) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);

    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\CompanyName'), pntr, Len) { and (@len <> nil)} then
      Result.CompanyName := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\FileDescription'), pntr, Len) { and (@len <> nil)} then
      Result.FileDescription := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\FileVersion'), pntr, Len) { and (@len <> nil)} then
      Result.FileVersion := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\InternalName'), pntr, Len) { and (@len <> nil)} then
      Result.InternalName := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\LegalCopyright'), pntr, Len) { and (@len <> nil)} then
      Result.LegalCopyRight := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\LegalTrademarks'), pntr, Len) { and (@len <> nil)} then
      Result.LegalTradeMarks := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\OriginalFileName'), pntr, Len) { and (@len <> nil)} then
      Result.OriginalFilename := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\ProductName'), pntr, Len) { and (@len <> nil)} then
      Result.ProductName := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\ProductVersion'), pntr, Len) { and (@len <> nil)} then
      Result.ProductVersion := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\Comments'), pntr, Len) { and (@len <> nil)} then
      Result.Comments := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\PrivateBuild'), pntr, Len) { and (@len <> nil)} then
      Result.PrivateBuild := PChar(pntr);
    if VerQueryValue(Buf, PChar('\StringFileInfo\' + lang + '\SpecialBuild'), pntr, Len) { and (@len <> nil)} then
      Result.SpecialBuild := PChar(pntr);
  finally
    FreeMem(Buf);
  end;
end;

function TCustomFileInfo.HasVersionInfo: Boolean;
var
  Handle: DWORD;
  Size: DWORD;
begin
  Size := GetFileVersionInfoSize(PChar(Filename), Handle);
  Result := Size <> 0;
end;

function TCustomFileInfo.GetFileProperty(_Property: TFileProperty): string;
var
  fi: TEXEVersionData;
begin
  Result := '';

  if not FFilePropertiesRead then begin
    try
      case _Property of
        FpProductName,
          FpProductVersion,
          FpCompanyName,
          FpFileDescription,
          FpFileVersion,
          FpCopyright,
          fpInternalName,
          fpOriginalFilename: begin
            if not HasVersionInfo then begin
              if FAllowExceptions then
                raise Exception.CreateFmt(_('File "%s" has no version information.'), [Filename]);
              Exit;
            end;

            fi := Self.ReadVersionData;

            FFileProperties[FpFileVersion] := fi.FileVersion;
            FFileProperties[FpFileDescription] := fi.FileDescription;
            FFileProperties[FpProductName] := fi.ProductName;
            FFileProperties[FpProductVersion] := fi.ProductVersion;
            FFileProperties[FpCopyright] := fi.LegalCopyRight;
            FFileProperties[FpTrademarks] := fi.LegalTradeMarks;
            FFileProperties[FpCompanyName] := fi.CompanyName;
            FFileProperties[fpOriginalFilename] := fi.OriginalFilename;
            FFileProperties[fpInternalName] := fi.InternalName;

            FFilePropertiesRead := True;
          end;
      end;
    except
      if FAllowExceptions then
        raise;
      Exit;
    end;
  end;

  Result := FFileProperties[_Property];
end;

function TCustomFileInfo.InternalName: string;
begin
  Result := GetFileProperty(fpInternalName);
end;

function TCustomFileInfo.Company: string;
begin
  Result := CompanyName;
end;

function TCustomFileInfo.CompanyName: string;
begin
  Result := GetFileProperty(FpCompanyName);
end;

function TCustomFileInfo.LegalCopyRight: string;
begin
  Result := GetFileProperty(FpCopyright);
end;

function TCustomFileInfo.LegalTradeMarks: string;
begin
  Result := GetFileProperty(FpTrademarks);
end;

function TCustomFileInfo.OriginalFilename: string;
begin
  Result := GetFileProperty(fpOriginalFilename);
end;

function TCustomFileInfo.FileVersion: string;
begin
  Result := GetFileProperty(FpFileVersion);
end;

function TCustomFileInfo.FileVersionRec: TFileVersionRec;
begin
  ZeroMemory(@Result, SizeOf(Result));
  Result.IsValid := GetFileBuildInfo(FFilename, Result.Major, Result.Minor, Result.Revision, Result.Build);
end;

function TCustomFileInfo.FileVersionStr(_Parts: TVersionParts = vpMajorMinorRevision): string;
var
  Rec: TFileVersionRec;
begin
  Rec := FileVersionRec;
  if Rec.IsValid then begin
    case _Parts of
      vpMajor: Result := IntToStr(Rec.Major);
      vpMajorMinor: Result := IntToStr(Rec.Major) + '.' + IntToStr(Rec.Minor);
      vpMajorMinorRevision: Result := IntToStr(Rec.Major) + '.' + IntToStr(Rec.Minor) + '.' + IntToStr(Rec.Revision);
      vpFull: Result := IntToStr(Rec.Major) + '.' + IntToStr(Rec.Minor) + '.' + IntToStr(Rec.Revision) + '.' + IntToStr(Rec.Build)
    else
      raise EApplicationInfo.CreateFmt(_('Invalid version part (%d)'), [Ord(_Parts)]);
    end;
  end else
    Result := _('<no version information>');
end;

function TCustomFileInfo.ProductName: string;
begin
  Result := GetFileProperty(FpProductName);
end;

function TCustomFileInfo.ProductVersion: string;
begin
  Result := GetFileProperty(FpProductVersion);
end;

{ TFileInfo }

constructor TFileInfo.Create(const _Filename: string);
begin
  inherited Create;
  FFilename := ExpandFileName(_Filename);
end;

{ TApplicationInfo }

constructor TApplicationInfo.Create;
begin
  inherited Create;
  FFilename := GetModuleFilename(0);
end;

{ TDllInfo }

constructor TDllInfo.Create;
begin
  inherited Create;
  FFilename := GetModuleFilename;
end;

{ TFileVersionRec }

procedure TFileVersionRec.CheckValid;
begin
  if not IsValid then
    raise EAIInvalidVersionInfo.Create(_('Invalid version info'));
end;

class operator TFileVersionRec.Equal(_a, _b: TFileVersionRec): Boolean;
begin
  _a.CheckValid;
  _b.CheckValid;

  Result := (_a.Major = _b.Major) and (_a.Minor = _b.Minor) and (_a.Revision = _b.Revision) and (_a.Build = _b.Build);
end;

class operator TFileVersionRec.GreaterThan(_a, _b: TFileVersionRec): Boolean;
begin
  _a.CheckValid;
  _b.CheckValid;

  Result := _a.Major > _b.Major;
  if not Result and (_a.Major = _b.Major) then begin
    Result := _a.Minor > _b.Minor;
    if not Result and (_a.Minor = _b.Minor) then begin
      Result := _a.Revision > _b.Revision;
      if not Result and (_a.Revision = _b.Revision) then
        Result := _a.Build > _b.Build;
    end;
  end;
end;

class operator TFileVersionRec.GreaterThanOrEqual(_a, _b: TFileVersionRec): Boolean;
begin
  _a.CheckValid;
  _b.CheckValid;

  Result := not (_a < _b);
end;

procedure TFileVersionRec.Init(_Major, _Minor, _Revision, _Build: Integer);
begin
  Major := _Major;
  Minor := _Minor;
  Revision := _Revision;
  Build := _Build;
end;

class operator TFileVersionRec.LessThan(_a, _b: TFileVersionRec): Boolean;
begin
  _a.CheckValid;
  _b.CheckValid;

  Result := _a.Major < _b.Major;
  if not Result and (_a.Major = _b.Major) then begin
    Result := _a.Minor < _b.Minor;
    if not Result and (_a.Minor = _b.Minor) then begin
      Result := _a.Revision < _b.Revision;
      if not Result and (_a.Revision = _b.Revision) then
        Result := _a.Build < _b.Build;
    end;
  end;
end;

class operator TFileVersionRec.LessThanOrEqual(_a, _b: TFileVersionRec): Boolean;
begin
  _a.CheckValid;
  _b.CheckValid;

  Result := not (_a > _b);
end;

class operator TFileVersionRec.NotEqual(_a, _b: TFileVersionRec): Boolean;
begin
  _a.CheckValid;
  _b.CheckValid;

  Result := not (_a = _b);
end;

{ TDummyFileInfo }

constructor TDummyFileInfo.Create;
begin
  inherited Create;
  AllowExceptions := False;
end;

function TDummyFileInfo.FileVersionRec: TFileVersionRec;
begin
  ZeroMemory(@Result, SizeOf(Result));
  Result.IsValid := False;
end;

function TDummyFileInfo.GetFileProperty(_Property: TFileProperty): string;
begin
  Result := '';
end;

end.

