library FTP;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  FastMM4,
  SysUtils,
  Windows,
  Classes,
  Dialogs,
  StrUtils,
  frmConfigU in 'frmConfigU.pas' {frmConfig} ,
  frmFTPTransferU in 'frmFTPTransferU.pas' {frmFTPTransfer} ,
  PluginSettingsU in 'PluginSettingsU.pas',
  CommonU in '..\..\..\common\CommonU.pas',
  ProcessTimerU in '..\..\..\common\ProcessTimerU.pas',
  SystemDetailsU in '..\..\..\common\SystemDetailsU.pas',
  FileVersionInformationU in '..\..\..\common\FileVersionInformationU.pas';

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
end;

{ function BackupFileList(AProfileName : PChar; AFileList : PChar) : PChar;
  var
  FileList : TStringList;
  begin
  FileList := TStringList.Create;
  try
  FileList.Text := StringReplace(AFileList,';',#13#10,[rfReplaceAll]);
  // Process File List
  FileList.Text := StringReplace(FileList.Text,#13#10,';',[rfReplaceAll]);
  Result := StrAlloc(Length(FileList.Text));
  StrPCopy(Result,FileList.Text);
  finally
  FreeAndNil(FileList);
  end;
  end; }

function BackupFileList(AProfileName: PChar; AFileList: PChar): PChar;
begin
  Result := AFileList;
end;

procedure BackupProgress(AProfileName: PChar; AProgress: Integer;
  AMessage: PChar);
begin
end;

procedure BackupEnd(AProfileName: PChar; AStatus: Integer;
  AZipFiles, ALogFileName: PChar);
var
  frmFTPTransfer: TfrmFTPTransfer;
  FTPFileList: TStringList;
begin
  // Status (brComplete, brFailed, brCancelled);
  if AStatus = 0 then // Complete
  begin
    frmFTPTransfer := TfrmFTPTransfer.Create(nil);
    FTPFileList := TStringList.Create;
    try
      // FTPFileList.Text := StringReplace(AZipFiles,';',#13#10,[rfReplaceAll]);
      FTPFileList.Text := AZipFiles;
      frmFTPTransfer.FTPUpload(AProfileName, FTPFileList, ALogFileName);
    finally
      FreeAndNil(frmFTPTransfer);
      FreeAndNil(FTPFileList);
    end;
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
