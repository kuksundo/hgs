unit PluginSettingsU;

interface

uses
  SysUtils, Windows, Classes, Registry;

const
  APPLICATION_REGISTRY_STORAGE =
    '\Software\Little Earth Solutions\BandS Plugins\MySQLDump';
  APPLICATION_SETTING_KEY = 'D3FAULT';

type
  TPluginSettings = class(TPersistent)
  private
    FRootkey: HKEY;
    FSettingsKey: string;
    FProfileName: string;
    FEnabled: boolean;
    FMySQLHostname: string;
    FMySQLPort: integer;
    FMySQLUserName: string;
    FMySQLPassword: string;
    FExcludedDatabases: TStringList;
  protected
    function SuperCipher(const S, Key: string): string;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SetDefaultExcludedDatabases;
  published
    property RootKey: HKEY Read FRootkey Write FRootkey;
    property SettingsKey: string Read FSettingsKey Write FSettingsKey;
    property ProfileName: string Read FProfileName Write FProfileName;
    property Enabled: boolean Read FEnabled Write FEnabled;
    property MySQLHostname: string Read FMySQLHostname Write FMySQLHostname;
    property MySQLPort: integer Read FMySQLPort Write FMySQLPort;
    property MySQLUserName: string Read FMySQLUserName Write FMySQLUserName;
    property MySQLPassword: string Read FMySQLPassword Write FMySQLPassword;
    property ExcludedDatabase: TStringList read FExcludedDatabases;
  end;

function GetModuleName: string;
function CalculatePercentage(AValue: integer; ATotal: integer): integer;
function FileExecute(const aCmdLine: string; aHide, aWait: boolean): boolean;

implementation

function FileExecute(const aCmdLine: string; aHide, aWait: boolean): boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  { setup the startup information for the application }
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    if aHide then
      wShowWindow := SW_HIDE
    else
      wShowWindow := SW_SHOWNORMAL;
  end;

  Result := CreateProcess(nil, PChar(aCmdLine), nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
  if aWait then
    if Result then
    begin
      WaitForInputIdle(ProcessInfo.hProcess, INFINITE);
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    end;
end;

function GetModuleName: string;
var
  szFileName: array [0 .. MAX_PATH] of char;
begin
  GetModuleFileName(HINSTANCE, szFileName, MAX_PATH);
  Result := szFileName;
end;

function CalculatePercentage(AValue: integer; ATotal: integer): integer;
begin
  Result := 0;
  if ATotal > 0 then
  begin
    Result := Round((AValue / ATotal) * 100);
  end;
end;

// TPluginSettings

constructor TPluginSettings.Create;
begin
  inherited Create;
  FExcludedDatabases := TStringList.Create;
  FExcludedDatabases.Sorted := True;
  FExcludedDatabases.Duplicates := dupIgnore;
  SetDefaultExcludedDatabases;
end;

destructor TPluginSettings.Destroy;
begin
  FreeAndNil(FExcludedDatabases);
  inherited Destroy;
end;

function TPluginSettings.SuperCipher(const S, Key: string): string;
var
  I, Z: integer;
  C: char;
  Code: byte;
begin
  Result := '';
  Z := length(Key);
  if (Z > 0) and (length(S) > 0) then
    for I := 1 to length(S) do
    begin
      Code := Ord(Key[(I - 1) mod Z + 1]);
      if S[I] >= #128 then
        C := Chr(Ord(S[I]) xor (Code and $7F))
      else if S[I] >= #64 then
        C := Chr(Ord(S[I]) xor (Code and $3F))
      else if S[I] >= #32 then
        C := Chr(Ord(S[I]) xor (Code and $1F))
      else
        C := S[I];
      Result := Result + C;
    end;
end;

procedure TPluginSettings.SetDefaultExcludedDatabases;
begin
  FExcludedDatabases.Clear;
  FExcludedDatabases.Add('information_schema');
  FExcludedDatabases.Add('performance_schema');
  FExcludedDatabases.Add('mysql');
end;

procedure TPluginSettings.LoadSettings;
var
  Registry: TRegistry;
  Key: string;
begin
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      RootKey := FRootkey;
      Key := IncludeTrailingPathDelimiter(FSettingsKey) + FProfileName + '\';
      if KeyExists(Key) then
      begin
        if OpenKeyReadOnly(Key) then
        begin
          FEnabled := ReadBool('Enabled');
          FMySQLHostname := ReadString('MySQLHostname');
          FMySQLPort := ReadInteger('MySQLPort');
          FMySQLUserName := ReadString('MySQLUserName');
          FMySQLPassword := SuperCipher(ReadString('MySQLPassword'),
            APPLICATION_SETTING_KEY);
          if ValueExists('ExcludedDatabases') then
          begin
            FExcludedDatabases.Text := ReadString('ExcludedDatabases');
          end
          else
          begin
            SetDefaultExcludedDatabases;
          end;
        end;
      end
      else
      begin
        SetDefaultExcludedDatabases;
      end;
    end;
  finally
    FreeAndNil(Registry);
  end;
end;

procedure TPluginSettings.SaveSettings;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      RootKey := FRootkey;
      if OpenKey(IncludeTrailingPathDelimiter(FSettingsKey) + FProfileName +
        '\', True) then
      begin
        WriteBool('Enabled', FEnabled);
        WriteString('MySQLHostname', FMySQLHostname);
        WriteInteger('MySQLPort', FMySQLPort);
        WriteString('MySQLUserName', FMySQLUserName);
        WriteString('MySQLPassword', SuperCipher(FMySQLPassword,
          APPLICATION_SETTING_KEY));
        WriteString('ExcludedDatabases', FExcludedDatabases.Text);
      end;
    end;
  finally
    FreeAndNil(Registry);
  end;
end;

end.
