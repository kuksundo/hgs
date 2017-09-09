unit PluginSettingsU;

interface

uses
  SysUtils, Windows, Classes, Registry;

const
  APPLICATION_REGISTRY_STORAGE = '\Software\Little Earth Solutions\BandS Plugins\FTP';
  APPLICATION_SETTING_KEY = 'D3FAULT';

type
  TPluginSettings = class(TPersistent)
    private
      FRootkey : HKEY;
      FSettingsKey : String;
      FProfileName : String;
      FEnabled : Boolean;
      FFTPServer : String;
      FFTPPort : Integer;
      FFTPRemotePath : String;
      FFTPUserName : String;
      FFTPPassword : String;
      FFTPUMask : String;
      FFTPPassive : Boolean;
    protected
      function SuperCipher(const S, Key: string): string;
    public
      procedure LoadSettings;
      procedure SaveSettings;
    published
      property RootKey : HKEY read FRootkey write FRootkey;
      property SettingsKey : String read FSettingsKey write FSettingsKey;
      property ProfileName : String read FProfileName write FProfileName;
      property Enabled : Boolean read FEnabled write FEnabled;
      property FTPServer : String read FFTPServer write FFTPServer;
      property FTPPort : Integer read FFTPPort write FFTPPort;
      property FTPRemotePath : String read FFTPRemotePath write FFTPRemotePath;
      property FTPUsername : String read FFTPUserName write FFTPUserName;
      property FTPPassword : String read FFTPPassword write FFTPPassword;
      property FTPUMask : String read FFTPUMask write FFTPUMask;
      property FTPPassive : Boolean read FFTPPassive write FFTPPassive;
  end;

function GetModuleName: String;
function CalculatePercentage(AValue : Integer; ATotal : Integer) : Integer;

implementation

function GetModuleName: String;
var
  szFileName: array[0..MAX_PATH] of Char;
begin
  GetModuleFileName(HINSTANCE, szFileName, MAX_PATH);
  Result := szFileName;
end;

function CalculatePercentage(AValue : Integer; ATotal : Integer) : Integer;
begin
  Result := 0;
  if ATotal > 0 then
    begin
      Result := Round((AValue / ATotal) * 100);
    end;
end;

// TPluginSettings

function TPluginSettings.SuperCipher(const S, Key: string): string;
var
  I, Z: integer;
  C:    char;
  Code: byte;
begin
  Result := '';
  Z      := length(Key);
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


procedure TPluginSettings.LoadSettings;
var
  Registry : TRegistry;
begin
  Registry := TRegistry.Create;
  try
  with Registry do
    begin
      RootKey := FRootkey;
      if OpenKey(IncludeTrailingPathDelimiter(FSettingsKey) + FProfileName + '\',False) then
        begin
          FEnabled := ReadBool('Enabled');
          FFTPServer := ReadString('FTPServer');
          FFTPPort := ReadInteger('FTPPort');
          FFTPRemotePath := ReadString('FTPRemotePath');
          FFTPUserName := ReadString('FTPUserName');
          FFTPPassword := SuperCipher(ReadString('FTPPassword'),APPLICATION_SETTING_KEY);
          FFTPUMask := ReadString('FTPUMask');
          FFTPPassive := ReadBool('FTPPassive');
        end;
    end;
  finally
    FreeAndNil(Registry);
  end;
end;

procedure TPluginSettings.SaveSettings;
var
  Registry : TRegistry;
begin
  Registry := TRegistry.Create;
  try
  with Registry do
    begin
      RootKey := FRootkey;
      if OpenKey(IncludeTrailingPathDelimiter(FSettingsKey) + FProfileName + '\',True) then
        begin
          WriteBool('Enabled',FEnabled);
          WriteString('FTPServer',FFTPServer);
          WriteInteger('FTPPort',FFTPPort);
          WriteString('FTPRemotePath',FFTPRemotePath);
          WriteString('FTPUserName',FFTPUserName);
          WriteString('FTPPassword', SuperCipher(FFTPPassword,APPLICATION_SETTING_KEY));
          WriteString('FTPUMask',FFTPUMask);
          WriteBool('FTPPassive',FFTPPassive);
        end;
    end;
  finally
    FreeAndNil(Registry);
  end;
end;

end.
