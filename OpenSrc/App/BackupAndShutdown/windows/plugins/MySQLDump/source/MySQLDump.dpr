library MySQLDump;

uses
  FastMM4,
  SysUtils,
  Windows,
  Classes,
  Dialogs,
  StrUtils,
  System.UITypes,
  frmConfigU in 'frmConfigU.pas' {frmConfig},
  frmMySQLBackupU in 'frmMySQLBackupU.pas' {frmMySQLBackup},
  MySQLBackupU in 'MySQLBackupU.pas',
  CommonU in '..\..\..\common\CommonU.pas',
  FileVersionInformationU in '..\..\..\common\FileVersionInformationU.pas',
  ProcessTimerU in '..\..\..\common\ProcessTimerU.pas',
  SystemDetailsU in '..\..\..\common\SystemDetailsU.pas',
  PluginSettingsU in 'PluginSettingsU.pas',
  dlgAddDatabaseU in 'dlgAddDatabaseU.pas' {dlgAddDatabase};

var
  TempFileName: string;

{$R *.res}

function GetPluginName: PChar;
var
  FileVersionInformation: TFileVersionInformation;
begin
  FileVersionInformation := TFileVersionInformation.Create;
  with FileVersionInformation do
  begin
    FileName := GetModuleName;
    Result := PChar(ProductName);
  end;
  FreeAndNil(FileVersionInformation);
end;

function GetPluginVersion: PChar;
var
  FileVersionInformation: TFileVersionInformation;
begin
  FileVersionInformation := TFileVersionInformation.Create;
  with FileVersionInformation do
  begin
    FileName := GetModuleName;
    Result := PChar(FileVersion);
  end;
  FreeAndNil(FileVersionInformation);
end;

function GetPluginDeveloper: PChar;
var
  FileVersionInformation: TFileVersionInformation;
begin
  FileVersionInformation := TFileVersionInformation.Create;
  with FileVersionInformation do
  begin
    FileName := GetModuleName;
    Result := StrAlloc(Length(CompanyName));
    StrPCopy(Result, CompanyName);
  end;
  FreeAndNil(FileVersionInformation);
end;

procedure ShowConfig(AProfileName: PChar);
var
  frmConfig: TfrmConfig;
begin
  frmConfig := TfrmConfig.Create(nil);
  try
    frmConfig.Execute(AProfileName);
  finally
    FreeAndNil(frmConfig);
  end;
end;

procedure BackupBegin(AProfileName: PChar);
begin
  TempFileName := '';
end;

function BackupFileList(AProfileName: PChar; AFileList: PChar): PChar;
var
  PluginSettings: TPluginSettings;
  FileList: TStringList;
  MySQLBackup: TMySQLBackup;
  frmMySQLBackup: TfrmMySQLBackup;
begin
  frmMySQLBackup := TfrmMySQLBackup.Create(nil);
  PluginSettings := TPluginSettings.Create;
  MySQLBackup := TMySQLBackup.Create(nil);
  FileList := TStringList.Create;
  try
    try
      FileList.Text := AFileList;
      with PluginSettings do
      begin
        RootKey := HKEY_CURRENT_USER;
        SettingsKey := APPLICATION_REGISTRY_STORAGE;
        ProfileName := string(AProfileName);
        LoadSettings;
        if Enabled then
        begin
          TempFileName := GetTempFolder + MySQLHostname +
            FormatDateTime('yymmddhhnn', Now) + '.sql';
          // TempFileName := GetTempFile('SQL');
          frmMySQLBackup.Show('Performing MySQL Dump...');
          MySQLBackup.Hostname := MySQLHostname;
          MySQLBackup.Port := MySQLPort;
          MySQLBackup.Username := MySQLUserName;
          MySQLBackup.Password := MySQLPassword;
          MySQLBackup.ExcludedDatabases.Assign(ExcludedDatabase);
          MySQLBackup.FileName := TempFileName;
          MySQLBackup.OnTotalProgress := frmMySQLBackup.TotalProgress;
          MySQLBackup.OnItemProgress := frmMySQLBackup.ItemProgress;
          MySQLBackup.OnDatabaseProgress := frmMySQLBackup.DatabaseProgress;
          MySQLBackup.OnLog := frmMySQLBackup.Log;
          MySQLBackup.OnDebug := frmMySQLBackup.Debug;
          if MySQLBackup.Execute then
          begin
            if FileExists(TempFileName) then
            begin
              FileList.Add(TempFileName);
            end;
          end
          else
          begin
            MessageDlg('MySQL Backup failed.', mtError, [mbOK], 0);
          end;
          frmMySQLBackup.Hide;
        end;
      end;
    except
      on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Result := StrAlloc(Length(FileList.Text));
    StrPCopy(Result, FileList.Text);
    FreeAndNil(FileList);
    FreeAndNil(PluginSettings);
    FreeAndNil(MySQLBackup);
    FreeAndNil(frmMySQLBackup);
  end;
end;

procedure BackupProgress(AProfileName: PChar; AProgress: integer;
  AMessage: PChar);
begin
end;

procedure BackupEnd(AProfileName: PChar; AStatus: integer;
  AZipFiles, ALogFileName: PChar);
begin
  if Trim(TempFileName) <> '' then
  begin
    if FileExists(TempFileName) then
      DeleteFile(PChar(TempFileName));
  end;
end;

exports
  GetPluginName,
  GetPluginVersion,
  GetPluginDeveloper,
  ShowConfig,
  BackupBegin,
  BackupFileList,
  BackupEnd,
  BackupProgress;

begin

end.
