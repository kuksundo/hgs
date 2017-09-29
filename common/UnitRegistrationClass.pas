unit UnitRegistrationClass;

interface

uses Winapi.Windows, sysutils, StrUtils, classes, BaseConfigCollect, OnGuard, OgUtil,
  PJVersionInfo, uSMBIOS, Registry
  ,UnitRegCodeConst, UnitRegistrationRecord;

type
  TRegistrationInfoCollect = class;
  TRegistrationInfoItem = class;

  TRegistrationInfo = class(TpjhBase)
  private
    FRegistrationInfoCollect: TRegistrationInfoCollect;

    function EncryptString(ATextToEncrypt: string; AKey: string = DEFAULT_ENCRYPT_KEY): string;
    function DecryptString(AEncryptedString: string; AKey: string = DEFAULT_ENCRYPT_KEY): string;

    procedure GetCodeFromString(var ACode: Tcode; AEncodedStr: string);
  public
    FRegCodeRecord: TSQLRegCodeManage;
    FApplicationKey: TKey;
    //UsageCode 생성시 FApplicationKey 대신 SerialNo를 기준으로 하는 FSerialKey 생성함(데모버젼은 여러 카피 생성 할 때 중복 생성을 방지하기 위함)
    FSerialKey: TKey;
    FMachineKey : TKey;
    FVersionInfo: TPJVersionInfo;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure InitRegInfoFromClient(AAppName: string; AMachineId: Int64=0);
    procedure InitRegInfoFromManager(AIsUseMachineId: Boolean; ASerailNo: integer;
      AExpireDate: TDateTime = 0; AExpireUsage: integer = 0);
    procedure Clear;

    function IsValidReleaseCode(AReleaseCodeString: string='') : boolean;
    function IsValidApplicationName(AKey: TKey; AAppName: String): Boolean;
    function IsValidSerialCode(AHexSN: string=''): Boolean;
    function IsValidUsageCode: Boolean;
    function IsExpiredUsageCode: Boolean;
    //Count를 1 감소하고 FUsageCode를 갱신하여 반환함
    function DecUsageCount: string;

    procedure LoadFromRegistry; overload;
    procedure SaveToRegistry; overload;
    function IsExistRegInfoAtRegistry: Boolean;
    procedure DeleteRegistry;
    procedure SaveSerialNoToFile(AFileName: string);

    function GeneratePassword(AType, AInsChar, AInsCharNum, AMAX_PW_LEN: integer): string;
    procedure MakeKey(var AKey: TKey; AIsUseMachineId, AIsTrial: Boolean; AAppName: string = '');
    //Trial Version의 경우 App Name에 'Trial' 이 추가되어 생성됨
    function MakeApplicationKey(var AKey: TKey; AAppName: string; AIsTrial: Boolean=False): Boolean;
    function EncodeSerialNo(AKey: TKey; ASerialNo: Longint): string;
    function DecodeSerialNo(AKey: TKey; AHexSN: string=''): Longint;
    function EncodeMachineID(AKey: TKey; AMachineID: Int64): string;
    function DecodeMachineID(AKey: TKey; AHexMachID: string): Int64;
    function EncodeRegCode(AKey: TKey; ASerialCode: string; AExpireDate: TDateTime): string;
    function DecodeRegCode(AKey: TKey; ASerialCode: string; var ADecodedSerial, ADecodedMachID: Longint): boolean;
    //Demo 또는 Trial Version은 Usage Code를 Serial No로 사용함
    //FUsageCode = '' 이면 Demo version이 아님 또는 FCodeTypes에 utUsage가 없으면 Demo Version이 아님
    //Key = Encoded Serial No를 이용하여 Key를 생성함:MakeKey(Encoded Serial)
    function EncodeUsageCode(AKey: TKey; ACount : Word; AExpires : TDateTime): string;
    //현재 상태의 Usage Count를 반환함
    function DecodeUsageCode(AKey: TKey; AEncodedUsageCode: string): integer;

    //.iif 또는 .hjp 파일을 암호화 하여 저장할 때 사용하기 위함
    function MakePassPhrase(APhrase: string): string;
    function InsertSeperator(var AStr: string; ASep: String = '-'): string;
    function DeleteSeperator(var AStr: string): string;
    procedure SetMachineModifier2Key(AKey: TKey);

    //AIsUseOgUtil4MachineID : True = GenerateMachineModifierPrim 함수를 사용하여 MachineID를 가져옴
    //                         False = SMBIOS에서 Machind 가져옴
    //이 함수는 프로그램이 설치되는 PC에서만 실행 되어야 함
    function GetProcessorInfo(AIsUseOgUtil4MachineID: Boolean=True): int64;
    procedure GetVersionFromAppName;
    //정식버젼의 경우 SerialCode를, 데모버젼의 경우 UsageCode를 생성하여 SerialCode에 대입함
    function GenerateSerialOrUsageCode: string;
    //정식버젼의 경우 RegCode를, 데모버젼의 경우 UsageCode를 생성하여 RegCode에 대입함
    function GenerateRegOrUsageCode: string;
    procedure GenerateUsageCode;

//    property RootKey: HKEY read FRootKey write FRootKey;
//    property RegKey: string read FRegKey write FRegKey;
//    property RegKeyName: string read FRegKeyName write FRegKeyName;
  published
    property RegistrationInfoCollect: TRegistrationInfoCollect read FRegistrationInfoCollect write FRegistrationInfoCollect;
    property RegCodeRecord: TSQLRegCodeManage read fRegCodeRecord write fRegCodeRecord;
//    property RegFileName: string read FRegistrationFile write FRegistrationFile;
//    property CustomerCompanyName : string read FCustomerCompanyName write FCustomerCompanyName;
//    property CustomerUserName : string read FCustomerUserName write FCustomerUserName;
//    property CustomerEmail : string read FCustomerEmail write FCustomerEmail;
//    property AppName : string read FApplicationName write FApplicationName;
//    property AppFullPath : string read FAppFullPath write FAppFullPath;
//    property SerialNo: Longint read FSerialNo write FSerialNo;
//    property IsUseMachineId: Boolean read FIsUseMachineId write FIsUseMachineId;
//    property IsUseOgUtil4MachineId: Boolean read FIsUseGenerateMachineModifierPrim write FIsUseGenerateMachineModifierPrim;
//    property IsTrialVersion: Boolean read FIsTrialVersion write FIsTrialVersion;
//    property MachineID : Int64 read FMachineID write FMachineID;
//    property ExpireDate : TDateTime read FExpireDate write FExpireDate;
//    property ExpireUsage : integer read FExpireUsage write FExpireUsage;
//
//    property FileMajorVersion: Word read FFileMajorVersion write FFileMajorVersion;
//    property FileMinorVersion: Word read FFileMinorVersion write FFileMinorVersion;
//    property FileRevisionNo: Word read FFileRevisionNo write FFileRevisionNo;
//    property FileBuildNo: Word read FFileBuildNo write FFileBuildNo;
//    property ProductMajorVersion: Word read FProductMajorVersion write FProductMajorVersion;
//    property ProductMinorVersion: Word read FProductMinorVersion write FProductMinorVersion;
//    property ProductRevisionNo: Word read FProductRevisionNo write FProductRevisionNo;
//    property ProductBuildNo: Word read FProductBuildNo write FProductBuildNo;
//
//    property RegCode : string read FRegCode write FRegCode;
//    property SerialCode : string read FSerialCode write FSerialCode;
//    property UsageCode : string read FUsageCode write FUsageCode;
//    property MasterPassword : string read FMasterPassword write FMasterPassword;
//    property TempMasterPassword : string read FTempMasterPassword write FTempMasterPassword;
//    property CodeTypes : TMyCodeTypes read FCodeTypes write FCodeTypes;
  end;

  TRegistrationInfoItem = class(TCollectionItem)
  private
  published
  end;

  TRegistrationInfoCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TRegistrationInfoItem;
    procedure SetItem(Index: Integer; const Value: TRegistrationInfoItem);
  public
    function  Add: TRegistrationInfoItem;
    function Insert(Index: Integer): TRegistrationInfoItem;
    property Items[Index: Integer]: TRegistrationInfoItem read GetItem  write SetItem; default;
  end;

const
  PASS_PHRASE_SUFFIX = '_!@#';

implementation

uses SynCommons, SynCrypto, mORMot;

{ TProjectInfoCollect }

function TRegistrationInfoCollect.Add: TRegistrationInfoItem;
begin
  Result := TRegistrationInfoItem(inherited Add);
end;

function TRegistrationInfoCollect.GetItem(Index: Integer): TRegistrationInfoItem;
begin
  Result := TRegistrationInfoItem(inherited Items[Index]);
end;

function TRegistrationInfoCollect.Insert(Index: Integer): TRegistrationInfoItem;
begin
  Result := TRegistrationInfoItem(inherited Insert(Index));
end;

procedure TRegistrationInfoCollect.SetItem(Index: Integer;
  const Value: TRegistrationInfoItem);
begin
  Items[Index].Assign(Value);
end;

{ TProjectInfo }

procedure TRegistrationInfo.Assign(Source: TPersistent);
begin
//  GeneratorInfoCollect.Assign();
  with RegCodeRecord do
  begin
    RegFileName := TRegistrationInfo(Source).RegCodeRecord.RegFileName;
    CustomerCompanyName := TRegistrationInfo(Source).RegCodeRecord.CustomerCompanyName;
    CustomerUserName := TRegistrationInfo(Source).RegCodeRecord.CustomerUserName;
    CustomerEmail := TRegistrationInfo(Source).RegCodeRecord.CustomerEmail;
    AppName := TRegistrationInfo(Source).RegCodeRecord.AppName;
    AppFullPath := TRegistrationInfo(Source).RegCodeRecord.AppFullPath;
    SerialCode := TRegistrationInfo(Source).RegCodeRecord.SerialCode;
    RegCode := TRegistrationInfo(Source).RegCodeRecord.RegCode;
    UsageCode := TRegistrationInfo(Source).RegCodeRecord.UsageCode;
    SerialNo := TRegistrationInfo(Source).RegCodeRecord.SerialNo;
    MachineID := TRegistrationInfo(Source).RegCodeRecord.MachineID;
    ExpireDate := TRegistrationInfo(Source).RegCodeRecord.ExpireDate;
    ExpireUsage := TRegistrationInfo(Source).RegCodeRecord.ExpireUsage;

    IsUseMachineId := TRegistrationInfo(Source).RegCodeRecord.IsUseMachineId;

    IsUseOgUtil4MachineId := TRegistrationInfo(Source).RegCodeRecord.IsUseOgUtil4MachineId;
    IsTrialVersion := TRegistrationInfo(Source).RegCodeRecord.IsTrialVersion;

    FileMajorVersion := TRegistrationInfo(Source).RegCodeRecord.FileMajorVersion;
    FileMinorVersion := TRegistrationInfo(Source).RegCodeRecord.FileMinorVersion;
    FileRevisionNo := TRegistrationInfo(Source).RegCodeRecord.FileRevisionNo;
    FileBuildNo := TRegistrationInfo(Source).RegCodeRecord.FileBuildNo;
    ProductMajorVersion := TRegistrationInfo(Source).RegCodeRecord.ProductMajorVersion;
    ProductMinorVersion := TRegistrationInfo(Source).RegCodeRecord.ProductMinorVersion;
    ProductRevisionNo := TRegistrationInfo(Source).RegCodeRecord.ProductRevisionNo;
    ProductBuildNo := TRegistrationInfo(Source).RegCodeRecord.ProductBuildNo;

    MasterPassword := TRegistrationInfo(Source).RegCodeRecord.MasterPassword;
    TempMasterPassword := TRegistrationInfo(Source).RegCodeRecord.TempMasterPassword;
    CodeTypes := TRegistrationInfo(Source).RegCodeRecord.CodeTypes;
  end;
end;

procedure TRegistrationInfo.Clear;
begin
;
end;

constructor TRegistrationInfo.Create(AOwner: TComponent);
begin
  FRegistrationInfoCollect := TRegistrationInfoCollect.Create(TRegistrationInfoItem);
  FVersionInfo := TPJVersionInfo.Create(nil);

  RegCodeRecord := TSQLRegCodeManage.Create;
//  GetProcessorInfo;

  RegCodeRecord.RootKey := HKEY_CURRENT_USER; //HKEY_LOCAL_MACHINE;  //HKEY_CURRENT_USER
  RegCodeRecord.RegKey := 'Software\DreamsComeTrue\';
//  RegCodeRecord.RegKeyName := 'RegFile';
end;

function TRegistrationInfo.DecodeMachineID(AKey: TKey;
  AHexMachID: string): Int64;
var
  LCode: TCode;
  LStr: string;
begin
  LStr := AHexMachID;
  LStr := StringReplace(LStr, '-', '', [rfReplaceAll, rfIgnoreCase]);

  if not HexToBuffer(LStr, LCode, SizeOf(LCode)) then
    FillChar(LCode, SizeOf(LCode), 0);

  Result := GetSpecialCodeValue(AKey, LCode);
end;

function TRegistrationInfo.DecodeRegCode(AKey: TKey; ASerialCode: string;
  var ADecodedSerial, ADecodedMachID: Integer): boolean;
begin

end;

function TRegistrationInfo.DecodeSerialNo(AKey: TKey; AHexSN: string): Longint;
var
  LCode: TCode;
  LStr: string;
begin
  if AHexSN = '' then
    AHexSN := RegCodeRecord.SerialCode;

  LStr := AHexSN;
  LStr := StringReplace(LStr, '-', '', [rfReplaceAll, rfIgnoreCase]);

  if not HexToBuffer(LStr, LCode, SizeOf(LCode)) then
    FillChar(LCode, SizeOf(LCode), 0);

  Result := GetSerialNumberCodeValue(AKey, LCode);
end;

function TRegistrationInfo.DecodeUsageCode(AKey: TKey;
  AEncodedUsageCode: string): integer;
var
  LCode: TCode;
  LStr: string;
begin
  LStr := AEncodedUsageCode;
  LStr := StringReplace(LStr, '-', '', [rfReplaceAll, rfIgnoreCase]);

  if not HexToBuffer(LStr, LCode, SizeOf(LCode)) then
    FillChar(LCode, SizeOf(LCode), 0);

  Result := GetUsageCodeValue(AKey, LCode);
end;

function TRegistrationInfo.DecryptString(AEncryptedString: string;
  AKey: string = DEFAULT_ENCRYPT_KEY): string;
var
  key : TSHA256Digest;
  aes : TAESCFB;
  s:RawByteString;
begin
  SynCommons.HexToBin(Pointer(SHA256(DEFAULT_ENCRYPT_KEY)), @key, 32);

  aes := TAESCFB.Create(key, 256);
  try
    s := StringToUTF8(AEncryptedString);
    s := aes.DecryptPKCS7(Base64ToBin(s), True);
    Result := UTF8ToString(s);
  finally
    aes.Free;
  end;
end;

function TRegistrationInfo.DecUsageCount: string;
var
  LCode: TCode;
  LStr: string;
  LExpireCount: integer;
begin
  LStr := RegCodeRecord.UsageCode;
  LStr := DeleteSeperator(LStr);//, '-', '', [rfReplaceAll, rfIgnoreCase]);

  if not HexToBuffer(LStr, LCode, SizeOf(LCode)) then
    FillChar(LCode, SizeOf(LCode), 0);

  DecUsageCode(FSerialKey, LCode);
  LExpireCount := GetUsageCodeValue(FSerialKey, LCode);

  RegCodeRecord.UsageCode := EncodeUsageCode(FSerialKey, LExpireCount, RegCodeRecord.ExpireDate);
end;

procedure TRegistrationInfo.DeleteRegistry;
var
  LRegKey: string;
  LReg: TRegistry;
begin
  LReg := TRegistry.Create(KEY_WRITE);
  try
    LReg.RootKey := RegCodeRecord.RootKey;
    LReg.DeleteKey(RegCodeRecord.RegKey+RegCodeRecord.SerialCode);
  finally
    LReg.CloseKey;
    LReg.Free;
  end;
end;

function TRegistrationInfo.DeleteSeperator(var AStr: string): string;
begin
  // Remove spaces from the Release code
  while pos(' ', AStr) > 0 do
    System.Delete(AStr, pos(' ', AStr), 1);

  // Remove '-' from the Release code
  while pos('-', AStr) > 0 do
    System.Delete(AStr, pos('-', AStr), 1);

  Result := AStr;
end;

destructor TRegistrationInfo.Destroy;
begin
  inherited Destroy;

  RegCodeRecord.Free;
  FRegistrationInfoCollect.Free;
  FVersionInfo.Free;
end;

function TRegistrationInfo.EncodeMachineID(AKey: TKey;
  AMachineID: Int64): string;
var
  LCode: TCode;
//  Li: integer;
begin
  if AMachineID = -1 then
    AMachineID := ABS(CreateMachineID([midSystem]));

  InitSpecialCode(AKey, AMachineID, 0, LCode);
  Result := BufferToHex(LCode, sizeof(LCode));
//  Li := ABS(CreateMachineID([{midUser,} midSystem{, midNetwork, midDrives}]));
//  ApplyModifierToKeyPrim(AMachineID, AKey, sizeof(AKey));
end;

function TRegistrationInfo.EncodeRegCode(AKey: TKey; ASerialCode: string;
  AExpireDate: TDateTime): string;
var
  LCode: TCode;
begin
  InitRegCode(AKey, ASerialCode, AExpireDate, LCode);
  Result := BufferToHex(LCode, sizeof(LCode));
//  InsertSeperator(Result);
end;

//MakeApplicationKey함수를 이용하여 Key 생성 후 Serial No 생성 함
function TRegistrationInfo.EncodeSerialNo(AKey: TKey;
  ASerialNo: integer): string;
var
  LCode: TCode;
//  LStr: string;
begin
  InitSerialNumberCode(AKey, ASerialNo, 0, LCode);
  Result := BufferToHex(LCode, sizeof(LCode));
  // Insert spaces in the release code string for easier reading
//  System.Insert('-', LStr, 13);
//  System.Insert('-', LStr, 09);
//  System.Insert('-', LStr, 05);
//  Result := LStr;
end;

function TRegistrationInfo.EncryptString(ATextToEncrypt: string; AKey: string = DEFAULT_ENCRYPT_KEY): string;
var
  key : TSHA256Digest;
  aes : TAESCFB;
  s:RawByteString;
begin
  SynCommons.HexToBin(Pointer(SHA256(DEFAULT_ENCRYPT_KEY)), @key, 32);

  aes := TAESCFB.Create(key, 256);
  try
    s := StringToUTF8(ATextToEncrypt);
    s := BinToBase64(aes.EncryptPKCS7(s, True));
    Result := UTF8ToString(s);
  finally
    aes.Free;
  end;
end;

//AType:
//AInsChar: Dash or UnderScore
//AInsCharNum: AInsChar 갯수
//AMAX_PW_LEN: Password 전체 길이
function TRegistrationInfo.GeneratePassword(AType, AInsChar, AInsCharNum, AMAX_PW_LEN: integer): string;
var
  i: Byte;
  L: Integer;
  s, sep, P, R, C: string;
begin
  case TPassWordType(AType) of
    pwtString: s := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    pwtNumber: s := '0123456789';
    pwtBoth: s := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  end;

  Result := '';
  Randomize;

  for i := 0 to AMAX_PW_LEN-1 do
    Result := Result + s[Random(Length(s)-1)+1];

  if TPassWordInsertChar(AInsChar) <> pwicNone then
  begin
    if TPassWordInsertChar(AInsChar) = pwicDash then
      sep := '-'
    else
      sep := '_';

    L := Length(Result) div (AInsCharNum+1);
    R := '';

    if Odd(Length(Result)) then
    begin
      C := Result[Length(Result)];
      Result := LeftStr(Result, Length(Result) - 1);

      for i := 0 to AInsCharNum do
      begin
        Result := RightStr(Result, Length(Result)-Length(R));
        R := Copy(Result, 0, L);
        if i < AInsCharNum then
          R := R + sep;
        P := P + R;
      end;

      P := P + C;
    end
    else
    begin
      for i := 0 to AInsCharNum do
      begin
        Result := RightStr(Result, Length(Result)-Length(R));
        R := Copy(Result, 0, L);

        if i < AInsCharNum then
          R := R + sep;
        P := P + R;
      end;
    end;

    Result := P;
  end;
end;

function TRegistrationInfo.GenerateRegOrUsageCode: string;
begin
  if RegCodeRecord.IsTrialVersion then
  begin
    MakeKey(FSerialKey, False, RegCodeRecord.IsTrialVersion, RegCodeRecord.SerialCode);
    RegCodeRecord.UsageCode := EncodeUsageCode(FSerialKey, RegCodeRecord.ExpireUsage, RegCodeRecord.ExpireDate);
    RegCodeRecord.RegCode := RegCodeRecord.UsageCode;
    Result := RegCodeRecord.UsageCode;
  end
  else
  begin
    MakeKey(FApplicationKey, RegCodeRecord.IsUseMachineId, RegCodeRecord.IsTrialVersion);
    RegCodeRecord.RegCode := EncodeRegCode(FApplicationKey, RegCodeRecord.SerialCode, RegCodeRecord.ExpireDate);
    Result := RegCodeRecord.RegCode;
  end;
end;

function TRegistrationInfo.GenerateSerialOrUsageCode: string;
begin
  MakeKey(FApplicationKey, RegCodeRecord.IsUseMachineId, RegCodeRecord.IsTrialVersion);
  RegCodeRecord.SerialCode := EncodeSerialNo(FApplicationKey, RegCodeRecord.SerialNo);

  if RegCodeRecord.IsTrialVersion then
  begin
    MakeKey(FSerialKey, False, RegCodeRecord.IsTrialVersion, RegCodeRecord.SerialCode);
    RegCodeRecord.UsageCode := EncodeUsageCode(FSerialKey, RegCodeRecord.ExpireUsage, RegCodeRecord.ExpireDate);
    Result := RegCodeRecord.UsageCode;
  end
  else
    Result := RegCodeRecord.SerialCode;
end;

procedure TRegistrationInfo.GenerateUsageCode;
begin
;
end;

function TRegistrationInfo.EncodeUsageCode(AKey: TKey; ACount: Word;
  AExpires: TDateTime): string;
var
  LCode: TCode;
begin
  InitUsageCode(AKey, ACount, AExpires, LCode);
  Result := BufferToHex(LCode, sizeof(LCode));
  InsertSeperator(Result);
  RegCodeRecord.CodeTypes := RegCodeRecord.CodeTypes + [ctUsage];
end;

procedure TRegistrationInfo.GetCodeFromString(var ACode: Tcode;
  AEncodedStr: string);
var
  LStr: string;
begin
  LStr := AEncodedStr;
  LStr := StringReplace(LStr, '-', '', [rfReplaceAll, rfIgnoreCase]);

  if not HexToBuffer(LStr, ACode, SizeOf(ACode)) then
    FillChar(ACode, SizeOf(ACode), 0);
end;

function TRegistrationInfo.GetProcessorInfo(AIsUseOgUtil4MachineID: Boolean): int64;
Var
  SMBios: TSMBios;
  i: integer;
  LProcessorInfo: TProcessorInformation;
begin
  RegCodeRecord.IsUseOgUtil4MachineId := AIsUseOgUtil4MachineID;

  if AIsUseOgUtil4MachineID then
  begin
    RegCodeRecord.MachineID := GenerateMachineModifierPrim;
  end
  else
  begin
    SMBios := TSMBios.Create;
    try
      if SMBios.HasProcessorInfo then
      begin
        for i := Low(SMBios.ProcessorInfo) to High(SMBios.ProcessorInfo) do
        begin
          LProcessorInfo := SMBios.ProcessorInfo[i];
          RegCodeRecord.MachineID := LProcessorInfo.RAWProcessorInformation^.ProcessorID;
          break;
        end;
      end;
    finally
      SMBios.Free;
    end;
  end;

  Result := RegCodeRecord.MachineID;
end;

procedure TRegistrationInfo.GetVersionFromAppName;
begin
  FVersionInfo.FileName := RegCodeRecord.AppFullPath + RegCodeRecord.AppName;
  RegCodeRecord.FileMajorVersion := FVersionInfo.FileVersionNumber.V1;
  RegCodeRecord.FileMinorVersion := FVersionInfo.FileVersionNumber.V2;
  RegCodeRecord.FileRevisionNo := FVersionInfo.FileVersionNumber.V3;
  RegCodeRecord.FileBuildNo := FVersionInfo.FileVersionNumber.V4;

  RegCodeRecord.ProductMajorVersion := FVersionInfo.ProductVersionNumber.V1;
  RegCodeRecord.ProductMinorVersion := FVersionInfo.ProductVersionNumber.V2;
  RegCodeRecord.ProductRevisionNo := FVersionInfo.ProductVersionNumber.V3;
  RegCodeRecord.ProductBuildNo := FVersionInfo.ProductVersionNumber.V4;
end;

procedure TRegistrationInfo.InitRegInfoFromClient(AAppName: string;
  AMachineId: Int64);
begin
  RegCodeRecord.AppFullPath := ExtractFilePath(AAppName);
  RegCodeRecord.AppName := ExtractFileName(AAppName);

  if AMachineId <> 0 then
    RegCodeRecord.MachineID := AMachineId;
end;

procedure TRegistrationInfo.InitRegInfoFromManager(AIsUseMachineId: Boolean;
  ASerailNo: integer; AExpireDate: TDateTime; AExpireUsage: integer);
begin
  RegCodeRecord.IsUseMachineId := AIsUseMachineId;
  RegCodeRecord.SerialNo := ASerailNo;
  RegCodeRecord.ExpireDate := AExpireDate;
//  RegCodeRecord.ExpireUsage := AExpireUsage;
end;

function TRegistrationInfo.InsertSeperator(var AStr: string; ASep: String): string;
begin
  // Insert spaces in the release code string for easier reading
  System.Insert(ASep, AStr, 13);
  System.Insert(ASep, AStr, 09);
  System.Insert(ASep, AStr, 05);

  Result := AStr;
end;

function TRegistrationInfo.IsExistRegInfoAtRegistry: Boolean;
var
  LRegKey: string;
  LReg: TRegistry;
begin
  Result := False;

  LReg := TRegistry.Create(KEY_READ);
  try
    LReg.RootKey := RegCodeRecord.RootKey;
    if LReg.OpenKey(RegCodeRecord.RegKey+'\'+RegCodeRecord.SerialCode, False) then
    begin
      Result := LReg.ValueExists(RegCodeRecord.RegKeyName);  //+'\'+RegKeyName
    end;
  finally
    LReg.CloseKey;
    LReg.Free;
  end;
end;

function TRegistrationInfo.IsExpiredUsageCode: Boolean;
var
  LCode: TCode;
begin
  GetCodeFromString(LCode, RegCodeRecord.usageCode);
  Result := IsUsageCodeExpired(FSerialKey, LCode);
end;

function TRegistrationInfo.IsValidReleaseCode(AReleaseCodeString: string): boolean;
var
  CalculatedReleaseCode : TCode;
begin
  if AReleaseCodeString = '' then
    AReleaseCodeString := RegCodeRecord.RegCode;

  DeleteSeperator(AReleaseCodeString);
//  MakeKey(FMachineKey, FIsUseMachineId, FIsTrialVersion);
  MakeKey(FApplicationKey, RegCodeRecord.IsUseMachineId, RegCodeRecord.IsTrialVersion);
  // Calculate the release code based on the serial number and the calculated machine modifier
  InitRegCode(FApplicationKey, RegCodeRecord.SerialCode, RegCodeRecord.ExpireDate, CalculatedReleaseCode);

  // Compare the two release codes
  result := CompareText(AReleaseCodeString,BufferToHex(CalculatedReleaseCode, sizeof(CalculatedReleaseCode))) = 0;
end;

function TRegistrationInfo.IsValidApplicationName(AKey: TKey;
  AAppName:  String): Boolean;
var
  LKey: TKey;
begin
//  LKey := HexToBuffer(AKey, SizeOf(AKey));
//  GenerateTMDKeyPrim(AKey, SizeOf(AKey), AnsiString(AnsiUpperCase(AAppName)));
//  Result := LKey = AKey;
end;

function TRegistrationInfo.IsValidSerialCode(AHexSN: string): Boolean;
var
  LCode: TCode;
  LKey: TKey;
  LStr: string;
begin
  if AHexSN = '' then
    AHexSN := RegCodeRecord.SerialCode;

  if AHexSN = '' then
  begin
    Result := False;
    Exit;
  end;

  LStr := AHexSN;
  LStr := StringReplace(LStr, '-', '', [rfReplaceAll, rfIgnoreCase]);

  if not HexToBuffer(LStr, LCode, SizeOf(LCode)) then
    FillChar(LCode, SizeOf(LCode), 0);

  MakeKey(LKey, RegCodeRecord.IsUseMachineId, RegCodeRecord.IsTrialVersion);
  Result := IsSerialNumberCodeValid(LKey, LCode);
end;

function TRegistrationInfo.IsValidUsageCode: Boolean;
var
  LCode: TCode;
begin
  GetCodeFromString(LCode, RegCodeRecord.usageCode);
  Result := IsUsageCodeValid(FSerialKey, LCode);
end;

procedure TRegistrationInfo.LoadFromRegistry;
var
  LPhrase: String;
begin
  LPhrase := MakePassPhrase(RegCodeRecord.AppName);
  LoadFromRegistry(RegCodeRecord.RootKey, RegCodeRecord.RegKey+'\'+RegCodeRecord.SerialCode, RegCodeRecord.RegKeyName, LPhrase, True);
//  LJson := DecryptString(LJson);
//  LJson := UTF8ToString(JSONToObject(LJson));
end;

function TRegistrationInfo.MakeApplicationKey(var AKey: TKey;
  AAppName: string; AIsTrial: Boolean): Boolean;
begin
  if AIsTrial then
    AAppName := AAppName + DEFAULT_TRIAL_STRING;
  AAppName := MakePassPhrase(AAppName);
  GenerateTMDKeyPrim(AKey, SizeOf(AKey), UpperCase(AAppName));
//  AKey := BufferToHex(AKey, SizeOf(AKey));
  Result := True;
end;

//Application Name + MachID를 이용하여 TKey 생성
procedure TRegistrationInfo.MakeKey(var AKey: TKey;  AIsUseMachineId, AIsTrial: Boolean;
  AAppName: string = '');
begin
  if AAppName = '' then
    AAppName := RegCodeRecord.AppName;

  FillChar(AKey, SizeOf(AKey), 0);
  MakeApplicationKey(AKey, AAppName, AIsTrial);

  if AIsUseMachineId then
    ApplyModifierToKeyPrim(RegCodeRecord.MachineID, AKey, sizeof(AKey));
end;

function TRegistrationInfo.MakePassPhrase(APhrase: string): string;
begin
  Result := '_!@#p' + APhrase + '#jh@!_';
end;

procedure TRegistrationInfo.SaveSerialNoToFile(AFileName: string);
var
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Text := RegCodeRecord.SerialCode;
    LStrLIst.SaveToFile(AFileName);
  finally
    LStrList.Free;
  end;
end;

procedure TRegistrationInfo.SaveToRegistry;
var
  LPhrase: String;
begin
  LPhrase := MakePassPhrase(RegCodeRecord.AppName);
//  LJson := UTF8ToString(ObjectToJSON(Self));
//  LJson := EncryptString(LJson);
  SaveToRegistry(RegCodeRecord.RootKey, RegCodeRecord.RegKey+'\'+RegCodeRecord.SerialCode, RegCodeRecord.RegKeyName, LPhrase, True);
end;

procedure TRegistrationInfo.SetMachineModifier2Key(AKey: TKey);
var
  Li: integer;
begin
  Li := ABS(CreateMachineID([{midUser,} midSystem{, midNetwork, midDrives}]));
  ApplyModifierToKeyPrim(Li, AKey, sizeof(AKey));
end;

end.
