{ -----------------------------------------------------------------------------
  Unit Name: AutoUpdateU
  Author: Tristan Marlow
  Purpose: Automatic update component (Requires Indy Components)

  ----------------------------------------------------------------------------
  License
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU Library General Public License as
  published by the Free Software Foundation; either version 2 of
  the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Library General Public License for more details.
  ----------------------------------------------------------------------------

  History: 27/06/2005 - First Release.

  ----------------------------------------------------------------------------- }
unit AutoUpdateU;

interface

uses
  ProgramSettingsU, CommonU, FileVersionInformationU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdHTTP,
  IdSocks, IdIOHandlerStack,
  INIFiles, IdHTTPHeaderInfo, SyncObjs;

type
  TApplicationVersionDetails = class(TComponent)
  private
    FMajorVersion: Integer;
    FMinorVersion: Integer;
    FReleaseVersion: Integer;
    FBuildVersion: Integer;
  protected
    procedure SetVersion(AVersionString: string);
    function GetVersion: string;
  public
    procedure Reset;
    function AsString: string;
    function IsCurrent(ACompareVersion: string): Boolean;
  published
    property Version: string read GetVersion write SetVersion;
    property MajorVersion: Integer read FMajorVersion write FMajorVersion;
    property MinorVersion: Integer read FMinorVersion write FMinorVersion;
    property ReleaseVersion: Integer read FReleaseVersion write FReleaseVersion;
    property BuildVersion: Integer read FBuildVersion write FBuildVersion;
  end;

type
  TOnUpdateAvailable = procedure(ASender: TObject;
    AApplicationName, ANewVersion, AOldVersion: String;
    var AStartUpdate: Boolean) of object;
  TOnUpdateNotRequired = procedure(ASender: TObject;
    AApplicationName, AFileVersion: String) of object;
  TOnUpdateBegin = procedure(ASender: TObject) of object;
  TOnUpdateProgress = procedure(ASender: TObject; AMessage: String;
    AProgress: Integer; var ACancel: Boolean) of object;
  TOnUpdateEnd = procedure(ASender: TObject; ASuccess: Boolean;
    AMessage: string; AUpdateFileName: TFileName; AUpdateParameters: string)
    of object;
  TOnUpdateExecute = procedure(ASender: TObject; var AExecute: Boolean;
    AUpdateFileName: TFileName; AUpdateParameters: string) of object;

type
  TProxyType = (ptHTTP, ptSocks);

type
  TAutoUpdateThread = class(TThread)
  private
    FidHTTP: TIdHTTP;
    FidIOHandlerStack: TIdIOHandlerStack;
    FidSocksInfo: TIdSocksInfo;
    FOnUpdateAvailable: TOnUpdateAvailable;
    FOnUpdateNotRequired: TOnUpdateNotRequired;
    FOnUpdateBegin: TOnUpdateBegin;
    FOnUpdateProgress: TOnUpdateProgress;
    FOnUpdateEnd: TOnUpdateEnd;
    FWorkCountMax: Integer;
    FUpdateURL: String;
    FApplicationName: String;
    FAutoUpdate: Boolean;
    FProxyEnabled: Boolean;
    FProxyHost: String;
    FProxyPort: Integer;
    FProxyAuthentication: Boolean;
    FProxyUserName: String;
    FProxyPassword: String;
    FProxyType: TProxyType;
    FProxySocksVersion: TSocksVersion;
    FCancel: Boolean;
    FProgressMessage: string;
    FProgressValue: Integer;
    FProgressLastValue: Integer;
    FProgressLastUpdate: TDateTime;
    FCurrentVersion: string;
    FNewVersion: string;
    FStartUpdate: Boolean;
    FSuccess: Boolean;
    FErrorMessage: string;
    FUpdateFileName: TFileName;
    FUpdateFileNameURL: string;
    FUpdateParameters: string;
  protected
    procedure IdHTTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure Progress(AMessage: String; AProgress: Integer);
    function DownloadURL(AURL: WideString; ADestination: TFileName): Boolean;
    function ExtractUrlFileName(const AURL: string): string;
    function GetAutoUpdateDetails(AFileName: TFileName): Boolean;
    function IsUpdateAvailable: Boolean;
    procedure SetProxyDetails;
    procedure SyncUpdateAvailable;
    procedure SyncUpdateNotRequired;
    procedure SyncUpdateBegin;
    procedure SyncUpdateProgress;
    procedure SyncUpdateEnd;
  public
    constructor Create(AURL: string; AApplicationName: string;
      ACurrentVersion: string; AOnUpdateAvailable: TOnUpdateAvailable;
      AOnUpdateNotRequired: TOnUpdateNotRequired;
      AOnUpdateBegin: TOnUpdateBegin; AOnUpdateProgress: TOnUpdateProgress;
      AOnUpdateEnd: TOnUpdateEnd; AAutoUpdate: Boolean = True;
      AProxyEnabled: Boolean = false; AProxyType: TProxyType = ptHTTP;
      AProxyHost: string = ''; AProxyPort: Integer = 8080;
      AProxyAuthentication: Boolean = false; AProxyUsername: string = '';
      AProxyPassword: string = '';
      AProxySocksVersion: TSocksVersion = svNoSocks); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
  end;

type
  TAutoUpdate = class(TComponent)
  private
    FBusy: Boolean;
    FCancel: Boolean;
    FUpdateURL: String;
    FApplicationName: String;
    FAutoUpdate: Boolean;
    FHTTPProxy: Boolean;
    FHTTPHost: String;
    FHTTPPort: Integer;
    FHTTPAuthentication: Boolean;
    FHTTPUserName: String;
    FHTTPPassword: String;
    FSocksProxy: Boolean;
    FSocksVersion: TSocksVersion;
    FSocksHost: String;
    FSocksPort: Integer;
    FSocksUserName: String;
    FSocksPassword: String;
    FSocksAuthentication: Boolean;
    FOnUpdateAvailable: TOnUpdateAvailable;
    FOnUpdateNotRequired: TOnUpdateNotRequired;
    FOnUpdateBegin: TOnUpdateBegin;
    FOnUpdateProgress: TOnUpdateProgress;
    FOnUpdateEnd: TOnUpdateEnd;
    FOnUpdateExecute: TOnUpdateExecute;

    FTimerThread: TThreadTimer;
    FMonitorIntervalHours: Integer;
    FProgramSettings: TProgramSettings;
    FEnabled: Boolean;
    FOnLog: TOnLog;
    FOnDebug: TOnDebug;
  protected
    procedure Log(AMessage: String);
    procedure Debug(AProcedure: string; AMessage: string);
    procedure Progress(AMessage: String; AProgress: Integer);
    procedure InternalOnTimer(ASender: TObject);
    procedure SetActive(AValue: Boolean);
    function GetActive: Boolean;
    function GetCurrentVersion: string;
    procedure InternalOnUpdateAvailable(ASender: TObject;
      AApplicationName, ANewVersion, AOldVersion: String;
      var AStartUpdate: Boolean);
    procedure InternalOnUpdateNotRequired(ASender: TObject;
      AApplicationName, AFileVersion: String);
    procedure InternalOnUpdateBegin(ASender: TObject);
    procedure InternalOnUpdateProgress(ASender: TObject; AMessage: String;
      AProgress: Integer; var ACancel: Boolean);
    procedure InternalOnUpdateEnd(ASender: TObject; ASuccess: Boolean;
      AMessage: string; AUpdateFileName: TFileName; AUpdateParameters: string);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure Execute;
    procedure Cancel;
  published
    property Active: Boolean read GetActive write SetActive;
    property UpdateURL: String read FUpdateURL write FUpdateURL;
    property ApplicationName: String read FApplicationName
      write FApplicationName;
    property AutoUpdate: Boolean read FAutoUpdate write FAutoUpdate
      default false;
    property ProgramSettings: TProgramSettings read FProgramSettings
      write FProgramSettings;
    property HTTPProxy: Boolean read FHTTPProxy write FHTTPProxy default false;
    property HTTPHost: String read FHTTPHost write FHTTPHost;
    property HTTPPort: Integer read FHTTPPort write FHTTPPort default 8080;
    property HTTPAuthentication: Boolean read FHTTPAuthentication
      write FHTTPAuthentication default false;
    property HTTPUserName: String read FHTTPUserName write FHTTPUserName;
    property HTTPPassword: String read FHTTPPassword write FHTTPPassword;
    property SocksProxy: Boolean read FSocksProxy write FSocksProxy
      default false;
    property SocksHost: String read FSocksHost write FSocksHost;
    property SocksPort: Integer read FSocksPort write FSocksPort default 1080;
    property SocksVersion: TSocksVersion read FSocksVersion write FSocksVersion
      default svNoSocks;
    property SocksAuthentication: Boolean read FSocksAuthentication
      write FSocksAuthentication default false;
    property SocksUserName: String read FSocksUserName write FSocksUserName;
    property SocksPassword: String read FSocksPassword write FSocksPassword;
    property MonitorIntervalHours: Integer read FMonitorIntervalHours
      write FMonitorIntervalHours default 12;
    property OnUpdateAvailable: TOnUpdateAvailable read FOnUpdateAvailable
      write FOnUpdateAvailable;
    property OnUpdateNotRequired: TOnUpdateNotRequired read FOnUpdateNotRequired
      write FOnUpdateNotRequired;
    property OnUpdateBegin: TOnUpdateBegin read FOnUpdateBegin
      write FOnUpdateBegin;
    property OnUpdateProgress: TOnUpdateProgress read FOnUpdateProgress
      write FOnUpdateProgress;
    property OnUpdateExecute: TOnUpdateExecute read FOnUpdateExecute
      write FOnUpdateExecute;
    property OnUpdateEnd: TOnUpdateEnd read FOnUpdateEnd write FOnUpdateEnd;
    property OnLog: TOnLog read FOnLog write FOnLog;
    property OnDebug: TOnDebug read FOnDebug write FOnDebug;
  end;

procedure CreateAutoUpdateProgramSettings(AProgramSettings: TProgramSettings);

implementation

uses
  DateUtils;

function GetApplicationName: String;
var
  ApplicationVersionInfo: TApplicationVersionInfo;
begin
  Result := '';
  ApplicationVersionInfo := TApplicationVersionInfo.Create;
  try
    with ApplicationVersionInfo do
    begin
      try
        Result := ProductName;
      except
        Result := Application.Title;
      end;
    end;
  finally
    FreeAndNil(ApplicationVersionInfo);
  end;
end;

procedure CreateAutoUpdateProgramSettings(AProgramSettings: TProgramSettings);
begin
  with AProgramSettings do
  begin
    Add('AutomaticUpdateEnabled', vtBoolean, True);
    Add('AutomaticUpdateApplication', vtString, GetApplicationName);
    Add('AutomaticUpdateURL', vtString,
      'http://autoupdate.littleearthsolutions.net/autoupdate.ini');
    Add('AutomaticUpdateAutomatic', vtBoolean, false);
    Add('AutomaticUpdateInterval', vtInteger, 12);
  end;
end;


// TApplicationVersionDetails

procedure TApplicationVersionDetails.Reset;
begin
  FMajorVersion := 0;
  FMinorVersion := 0;
  FReleaseVersion := 0;
  FBuildVersion := 0;
end;

function TApplicationVersionDetails.AsString: string;
begin
  Result := IntToStr(FMajorVersion) + '.' + IntToStr(FMinorVersion) + '.' +
    IntToStr(FReleaseVersion) + '.' + IntToStr(FBuildVersion);
end;

function TApplicationVersionDetails.GetVersion: string;
begin
  Result := AsString;
end;

procedure TApplicationVersionDetails.SetVersion(AVersionString: string);
var
  TempStr: string;
  Idx, VersionIdx: Integer;
begin
  Reset;
  TempStr := '';
  Idx := 1;
  VersionIdx := 0;
  AVersionString := AVersionString + '.';
  while (Idx <= Length(AVersionString)) do
  begin
    if (AVersionString[Idx] = '.') then
    begin
      case VersionIdx of
        0:
          FMajorVersion := StrToIntDef(TempStr, 0);
        1:
          FMinorVersion := StrToIntDef(TempStr, 0);
        2:
          FReleaseVersion := StrToIntDef(TempStr, 0);
        3:
          FBuildVersion := StrToIntDef(TempStr, 0);
      end;
      Inc(VersionIdx);
      TempStr := '';
    end
    else
    begin
      TempStr := TempStr + AVersionString[Idx];
    end;
    Inc(Idx);
  end;
end;

function TApplicationVersionDetails.IsCurrent(ACompareVersion: string): Boolean;
var
  CompareVersionDetails: TApplicationVersionDetails;
  compareVersionMajorMinor: Integer;
  compareVersionReleaseBuild: Integer;
  currentVersionMajorMinor: Integer;
  currentVersionReleaseBuild: Integer;
begin
  Result := false;

  CompareVersionDetails := TApplicationVersionDetails.Create(nil);
  try
    CompareVersionDetails.Version := ACompareVersion;

    compareVersionMajorMinor := CompareVersionDetails.MajorVersion * 1000 +
      CompareVersionDetails.MinorVersion;
    currentVersionMajorMinor := Self.MajorVersion * 1000 + Self.MinorVersion;

    if compareVersionMajorMinor > currentVersionMajorMinor then
    begin
      Result := True;
    end
    else
    begin
      if compareVersionMajorMinor = currentVersionMajorMinor then
      begin
        compareVersionReleaseBuild := CompareVersionDetails.ReleaseVersion *
          1000 + CompareVersionDetails.BuildVersion;
        currentVersionReleaseBuild := Self.ReleaseVersion * 1000 +
          Self.BuildVersion;

        if compareVersionReleaseBuild >= currentVersionReleaseBuild then
        begin
          Result := True;
        end;
      end;
    end;
  finally
    FreeAndNil(CompareVersionDetails)
  end;
end;

// TAutoUpdateThread

constructor TAutoUpdateThread.Create(AURL: string; AApplicationName: string;
  ACurrentVersion: string; AOnUpdateAvailable: TOnUpdateAvailable;
  AOnUpdateNotRequired: TOnUpdateNotRequired; AOnUpdateBegin: TOnUpdateBegin;
  AOnUpdateProgress: TOnUpdateProgress; AOnUpdateEnd: TOnUpdateEnd;
  AAutoUpdate: Boolean = True; AProxyEnabled: Boolean = false;
  AProxyType: TProxyType = ptHTTP; AProxyHost: string = '';
  AProxyPort: Integer = 8080; AProxyAuthentication: Boolean = false;
  AProxyUsername: string = ''; AProxyPassword: string = '';
  AProxySocksVersion: TSocksVersion = svNoSocks);
begin
  inherited Create;
  FreeOnTerminate := True;
  FidIOHandlerStack := TIdIOHandlerStack.Create(nil);
  with FidIOHandlerStack do
  begin
    TransparentProxy := FidSocksInfo;
  end;
  FidHTTP := TIdHTTP.Create(nil);
  with FidHTTP do
  begin
    IOHandler := FidIOHandlerStack;
    OnStatus := IdHTTPStatus;
    OnWorkBegin := IdHTTPWorkBegin;
    OnWork := IdHTTPWork;
    OnWorkEnd := IdHTTPWorkEnd;
  end;
  FApplicationName := AApplicationName;
  FUpdateURL := AURL;
  FWorkCountMax := 0;
  FCancel := false;
  FProgressLastValue := -1;
  FProgressLastUpdate := 0;
  FProgressMessage := '';
  FProgressValue := 0;
  FCurrentVersion := ACurrentVersion;
  FNewVersion := '0.0.0.0';
  FStartUpdate := false;
  FSuccess := false;
  FErrorMessage := '';
  FUpdateFileName := '';
  FUpdateParameters := '';
  FOnUpdateAvailable := AOnUpdateAvailable;
  FOnUpdateNotRequired := AOnUpdateNotRequired;
  FOnUpdateBegin := AOnUpdateBegin;
  FOnUpdateProgress := AOnUpdateProgress;
  FOnUpdateEnd := AOnUpdateEnd;
  FAutoUpdate := AAutoUpdate;
  FProxyEnabled := AProxyEnabled;
  FProxyHost := AProxyHost;
  FProxyPort := AProxyPort;
  FProxyAuthentication := AProxyAuthentication;
  FProxyUserName := AProxyUsername;
  FProxyPassword := AProxyPassword;
  FProxyType := AProxyType;
  FProxySocksVersion := AProxySocksVersion;
end;

destructor TAutoUpdateThread.Destroy;
begin
  FreeAndNil(FidHTTP);
  FreeAndNil(FidIOHandlerStack);
  FreeAndNil(FidSocksInfo);
  inherited Destroy;
end;

procedure TAutoUpdateThread.Execute;
var
  INIFileName: String;
begin
  FWorkCountMax := 0;
  FCancel := false;
  FSuccess := false;
  Synchronize(SyncUpdateBegin);
  try
    Progress('Checking for updates , please wait...', 0);
    if FUpdateURL <> '' then
    begin
      // INIFileName := GetTempFolder + ExtractUrlFileName(FUpdateURL);
      INIFileName := GetTempFile('UPD');
      if FileExists(INIFileName) then
        DeleteFile(INIFileName);
      if DownloadURL(FUpdateURL, INIFileName) then
      begin
        if FileExists(INIFileName) then
        begin
          if GetAutoUpdateDetails(INIFileName) then
          begin
            if IsUpdateAvailable and (not FCancel) then
            begin
              if not FCancel then
              begin
                Progress('Update Available', 100);
                // Log('Update available: ' + AutoUpdateDetails.VersionString);
                Synchronize(SyncUpdateAvailable);
              end;

              if (FStartUpdate) and not(FCancel) then
              begin
                Progress('Download initializing...', 0);

                FWorkCountMax := 0;
                FUpdateFileName := GetTempFolder +
                  ExtractUrlFileName(FUpdateFileNameURL);
                if DownloadURL(FUpdateFileNameURL, FUpdateFileName) then
                begin
                  Progress('Download complete.', 100);
                  FErrorMessage := '';
                  FSuccess := True;
                  FUpdateParameters := FUpdateParameters;
                end
                else
                begin
                  if not FCancel then
                  begin
                    Progress('Download failed.', 100);
                    FErrorMessage := 'Failed to download update' +
                      FUpdateFileNameURL;
                    FSuccess := false;
                  end
                  else
                  begin
                    Progress('Download cancelled.', 100);
                    FErrorMessage := 'Download cancelled.';
                    FSuccess := false;
                  end;
                end;
              end
              else
              begin
                Progress('Download cancelled.', 100);
                FErrorMessage := 'Download cancelled.';
                FSuccess := false;
              end;
            end
            else
            begin
              Progress('Already at latest version', 100);
              Synchronize(SyncUpdateNotRequired);
            end;
          end
          else
          begin
            FSuccess := false;
            FErrorMessage := 'Error loading "' + FApplicationName +
              '" update details.';
          end;
        end
        else
        begin
          FSuccess := false;
          FErrorMessage := 'Error loading "' + FApplicationName +
            '" update details.';
          Synchronize(SyncUpdateEnd);
        end;
        if FileExists(INIFileName) then
          DeleteFile(INIFileName);
      end
      else
      begin
        FSuccess := false;
        FErrorMessage := '';
      end;
    end
    else
    begin
      FSuccess := false;
      FErrorMessage := 'No update URL specified.';
    end;

  finally
    Synchronize(SyncUpdateEnd);
  end;

end;

procedure TAutoUpdateThread.IdHTTPStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  // Log(AStatusText);
end;

procedure TAutoUpdateThread.IdHTTPWorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  if AWorkMode = wmRead then
  begin
    FWorkCountMax := AWorkCountMax;
    Progress('Starting Download...', 0);
  end;
end;

procedure TAutoUpdateThread.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  if AWorkMode = wmRead then
  begin
    if FWorkCountMax > 0 then
    begin
      Progress(IntToStr(100 * AWorkCount div FWorkCountMax) + '% (' +
        IntToStr(AWorkCount) + ' of ' + IntToStr(FWorkCountMax) + ' Bytes)',
        (100 * AWorkCount div FWorkCountMax));
    end
    else
    begin
      Progress('Recieving...', 0);
    end;
    if (FCancel) or (Self.Terminated) then
    begin
      FCancel := True;
      Progress('Cancelling...', 100);
      // Log('Cancelling...');
      FidHTTP.Disconnect;
    end;
  end;
end;

procedure TAutoUpdateThread.IdHTTPWorkEnd(ASender: TObject;
  AWorkMode: TWorkMode);
begin
  if AWorkMode = wmRead then
  begin
    Progress('Complete', 100);
    // Log('Complete.');
  end;
end;

procedure TAutoUpdateThread.Progress(AMessage: String; AProgress: Integer);
begin
  if (AProgress <> FProgressLastValue) or
    (SecondsBetween(Now, FProgressLastUpdate) > 15) then
  begin
    FProgressMessage := AMessage;
    FProgressValue := AProgress;
    Synchronize(SyncUpdateProgress);
    FProgressLastUpdate := Now;
    FProgressLastValue := AProgress;
  end;
end;

procedure TAutoUpdateThread.SetProxyDetails;
begin
  if FProxyEnabled then
  begin
    case FProxyType of
      ptHTTP:
        begin
          with FidHTTP.ProxyParams do
          begin
            BasicAuthentication := FProxyAuthentication;
            ProxyServer := FProxyHost;
            ProxyPort := FProxyPort;
            ProxyUsername := FProxyUserName;
            ProxyPassword := FProxyPassword;
          end;
        end;
      ptSocks:
        begin
          with FidSocksInfo do
          begin
            Version := FProxySocksVersion;
            Host := FProxyHost;
            Port := FProxyPort;
            if FProxyAuthentication then
            begin
              Authentication := saUsernamePassword;
            end
            else
            begin
              Authentication := saNoAuthentication;
            end;
            Username := FProxyUserName;
            Password := FProxyPassword;
          end;
        end;
    end;
  end
  else
  begin
    with FidHTTP.ProxyParams do
    begin
      BasicAuthentication := false;
      ProxyServer := '';
    end;
    with FidSocksInfo do
    begin
      Version := svNoSocks;
      Host := '';
    end;
  end;
end;

function TAutoUpdateThread.GetAutoUpdateDetails(AFileName: TFileName): Boolean;
var
  INIFile: TINIFile;
begin
  INIFile := TINIFile.Create(AFileName);
  try
    with INIFile do
    begin
      if SectionExists(FApplicationName) then
      begin
        FUpdateParameters := ReadString(FApplicationName, 'Params', '');
        FUpdateFileNameURL := ReadString(FApplicationName, 'URL', '');
        FUpdateFileName := ExtractUrlFileName(FUpdateFileNameURL);
        FNewVersion := ReadString(FApplicationName, 'Version', '0.0.0.0');
        Result := True;
      end
      else
      begin
        Result := false;
      end;
    end;
  finally
    FreeAndNil(INIFile);
  end;
end;

function TAutoUpdateThread.IsUpdateAvailable: Boolean;
var
  VersionDetails: TApplicationVersionDetails;
begin
  VersionDetails := TApplicationVersionDetails.Create(nil);
  try
    VersionDetails.Version := FNewVersion;
    Result := not VersionDetails.IsCurrent(FCurrentVersion);
  finally
    FreeAndNil(VersionDetails);
  end;
end;

function TAutoUpdateThread.ExtractUrlFileName(const AURL: string): string;
var
  i: Integer;
begin
  i := LastDelimiter('/', AURL);
  Result := Copy(AURL, i + 1, Length(AURL) - (i));
end;

function TAutoUpdateThread.DownloadURL(AURL: WideString;
  ADestination: TFileName): Boolean;
var
  FileStream: TFileStream;
  TempFileName: String;
begin
  FCancel := false;
  Result := false;
  TempFileName := GetTempFile('LES');
  FileStream := TFileStream.Create(TempFileName, fmCreate);
  try
    try
      FidHTTP.Get(AURL, FileStream);
    except
      on E: Exception do
      begin
        // Log(E.Message);
      end;
    end;
  finally
    FileStream.Free;
  end;
  // Log(FidHTTP.Response.ResponseText);
  if (FidHTTP.Response.ResponseCode = 200) and (not FCancel) then
  begin
    Progress('Download Complete.', 100);
    if FileExists(ADestination) then
    begin
      // Log('File ' + ADestination + ' has been removed.');
      DeleteFile(ADestination);
    end;
    if RenameFile(TempFileName, ADestination) then
    begin
      Result := True;
    end
    else
    begin
      // Log('Failed to rename temporary file ' + TempFileName);
      // FErrorMessage := 'Failed to rename temporary file ' + TempFileName;
    end;
  end
  else
  begin
    Progress('Download Failed.', 100);
    // FErrorMessage := 'Download failed.';
    If FCancel then
    begin
      Progress('Download cancelled by user.', 100);
      // FErrorMessage := 'Download cancelled by user.';
      // Log('Download cancelled by user.');
    end;
  end;
end;

procedure TAutoUpdateThread.SyncUpdateAvailable;
begin
  if Assigned(FOnUpdateAvailable) then
  begin
    FOnUpdateAvailable(Self, FApplicationName, FNewVersion, FCurrentVersion,
      FStartUpdate)
  end;
end;

procedure TAutoUpdateThread.SyncUpdateNotRequired;
begin
  if Assigned(FOnUpdateNotRequired) then
  begin
    FOnUpdateNotRequired(Self, FApplicationName, FCurrentVersion);
  end;
end;

procedure TAutoUpdateThread.SyncUpdateBegin;
begin
  if Assigned(FOnUpdateBegin) then
  begin
    FOnUpdateBegin(Self);
  end;
end;

procedure TAutoUpdateThread.SyncUpdateProgress;
begin
  if Assigned(FOnUpdateProgress) then
  begin
    FOnUpdateProgress(Self, FProgressMessage, FProgressValue, FCancel);
  end;
end;

procedure TAutoUpdateThread.SyncUpdateEnd;
begin
  if Assigned(FOnUpdateEnd) then
  begin
    FOnUpdateEnd(Self, FSuccess, FErrorMessage, FUpdateFileName,
      FUpdateParameters);
  end;
end;

// TAutoUpdate

constructor TAutoUpdate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FBusy := false;
  FApplicationName := GetApplicationName;
  FUpdateURL := 'http://autoupdate.littleearthsolutions.net/autoupdate.ini';
  FCancel := false;
end;

destructor TAutoUpdate.Destroy;
begin
  SetActive(false);
  inherited Destroy;
end;

procedure TAutoUpdate.LoadSettings;
begin
  if Assigned(FProgramSettings) then
  begin
    with FProgramSettings do
    begin
      FEnabled := ValueByName['AutomaticUpdateEnabled'];
      FApplicationName := ValueByName['AutomaticUpdateApplication'];
      FAutoUpdate := ValueByName['AutomaticUpdateAutomatic'];
      FUpdateURL := ValueByName['AutomaticUpdateURL'];
      FHTTPProxy := ValueByName['HTTPProxy'];
      FHTTPHost := ValueByName['HTTPHost'];
      FHTTPPort := ValueByName['HTTPPort'];
      FHTTPAuthentication := ValueByName['HTTPAuthentication'];
      FHTTPUserName := ValueByName['HTTPUserName'];
      FHTTPPassword := ValueByName['HTTPPassword'];
      FSocksProxy := ValueByName['SOCKSProxy'];
      FSocksHost := ValueByName['SOCKSHost'];
      FSocksPort := ValueByName['SOCKSPort'];
      FSocksVersion := TSocksVersion(Integer(ValueByName['SOCKSVersion']));
      FSocksAuthentication := ValueByName['SOCKSAuthentication'];
      FSocksUserName := ValueByName['SOCKSUserName'];
      FSocksPassword := ValueByName['SOCKSPassword'];
      FMonitorIntervalHours := ValueByName['AutomaticUpdateInterval'];
    end;
  end
  else
  begin
    raise Exception.Create('Property ProgramSettings has not been assigned.');
  end;
end;

procedure TAutoUpdate.SaveSettings;
begin
  if Assigned(FProgramSettings) then
  begin
    with FProgramSettings do
    begin
      ValueByName['AutomaticUpdateEnabled'] := FEnabled;
      ValueByName['AutomaticUpdateApplication'] := FApplicationName;
      ValueByName['AutomaticUpdateAutomatic'] := FAutoUpdate;
      ValueByName['AutomaticUpdateURL'] := FUpdateURL;
      ValueByName['HTTPProxy'] := FHTTPProxy;
      ValueByName['HTTPHost'] := FHTTPHost;
      ValueByName['HTTPPort'] := FHTTPPort;
      ValueByName['HTTPAuthentication'] := FHTTPAuthentication;
      ValueByName['HTTPUserName'] := FHTTPUserName;
      ValueByName['HTTPPassword'] := FHTTPPassword;
      ValueByName['SOCKSProxy'] := FSocksProxy;
      ValueByName['SOCKSHost'] := FSocksHost;
      ValueByName['SOCKSPort'] := FSocksPort;
      ValueByName['SOCKSVersion'] := Integer(FSocksVersion);
      ValueByName['SOCKSAuthentication'] := FSocksAuthentication;
      ValueByName['SOCKSUserName'] := FSocksUserName;
      ValueByName['SOCKSPassword'] := FSocksPassword;
      ValueByName['AutoUpdateInterval'] := FMonitorIntervalHours;
    end;
  end
  else
  begin
    raise Exception.Create('Property ProgramSettings has not been assigned.');
  end;
end;

procedure TAutoUpdate.SetActive(AValue: Boolean);
begin
  if AValue then
  begin
    if (not Assigned(FTimerThread)) and FEnabled then
    begin
      FTimerThread := TThreadTimer.Create(InternalOnTimer,
        (FMonitorIntervalHours * 60) * (60000));
    end;
  end
  else
  begin
    if Assigned(FTimerThread) then
    begin
      try
        FTimerThread.Terminate;
      finally
        FTimerThread := nil;
      end;

    end;
  end;
end;

function TAutoUpdate.GetActive: Boolean;
begin
  Result := Assigned(FTimerThread);
end;

function TAutoUpdate.GetCurrentVersion: string;
var
  CurrentVersion: TFileVersionInformation;
begin
  Result := '0.0.0.0';
  CurrentVersion := TFileVersionInformation.Create;
  try
    try
      CurrentVersion.FileName := ParamStr(0);
      Result := CurrentVersion.FileVersion;
    except

    end;
  finally
    FreeAndNil(CurrentVersion);
  end;
end;

procedure TAutoUpdate.InternalOnUpdateAvailable(ASender: TObject;
  AApplicationName, ANewVersion, AOldVersion: String;
  var AStartUpdate: Boolean);
begin
  Log(Format('"%s" (%s) a new version "%s" is available', [AApplicationName,
    AOldVersion, ANewVersion]));
  if Assigned(FOnUpdateAvailable) then
  begin
    FOnUpdateAvailable(Self, AApplicationName, ANewVersion, AOldVersion,
      AStartUpdate);
  end;
end;

procedure TAutoUpdate.InternalOnUpdateNotRequired(ASender: TObject;
  AApplicationName, AFileVersion: String);
begin
  Log(Format('"%s" is already up to date "%s"', [AApplicationName,
    AFileVersion]));
  if Assigned(FOnUpdateNotRequired) then
  begin
    FOnUpdateNotRequired(Self, AApplicationName, AFileVersion);
  end;
end;

procedure TAutoUpdate.InternalOnUpdateBegin(ASender: TObject);
begin
  Log('Checking for software update...');
  if Assigned(FOnUpdateBegin) then
  begin
    FOnUpdateBegin(Self);
  end;
end;

procedure TAutoUpdate.InternalOnUpdateProgress(ASender: TObject;
  AMessage: String; AProgress: Integer; var ACancel: Boolean);
begin
  if Assigned(FOnUpdateProgress) then
  begin
    ACancel := FCancel;
    FOnUpdateProgress(Self, AMessage, AProgress, ACancel);
  end;
end;

procedure TAutoUpdate.InternalOnUpdateEnd(ASender: TObject; ASuccess: Boolean;
  AMessage: string; AUpdateFileName: TFileName; AUpdateParameters: string);
var
  ErrorCode: Integer;
  ExecuteUpdate: Boolean;
begin
  FBusy := false;

  if Assigned(FOnUpdateEnd) then
  begin
    FOnUpdateEnd(Self, ASuccess, AMessage, AUpdateFileName, AUpdateParameters);
  end;

  if ASuccess then
  begin
    ExecuteUpdate := True;
    if Assigned(FOnUpdateExecute) then
    begin
      FOnUpdateExecute(Self, ExecuteUpdate, AUpdateFileName, AUpdateParameters);
    end;

    if (ExecuteUpdate) and (FileExists(AUpdateFileName)) then
    begin
      ErrorCode := ExecuteFile('open', AUpdateFileName, AUpdateParameters,
        GetApplicationDir, SW_NORMAL);
      If ErrorCode > 32 then
      begin
        Application.Terminate;
      end
      else
      begin
        Log('Error executing file,  "' + AUpdateFileName + '", Error Code: ' +
          IntToStr(ErrorCode));
      end;
    end
    else
    begin
      Log('File not found: "' + AUpdateFileName + '"');
    end;
  end
  else
  begin
    if Trim(AMessage) <> '' then
    begin
      Log('ERROR: ' + AMessage);
    end;
  end;
end;

procedure TAutoUpdate.InternalOnTimer(ASender: TObject);
begin
  Execute;
end;

procedure TAutoUpdate.Log(AMessage: String);
begin
  if Assigned(FOnLog) then
  begin
    FOnLog(Self, AMessage);
  end;
end;

procedure TAutoUpdate.Debug(AProcedure: string; AMessage: string);
begin
  if Assigned(FOnDebug) then
  begin
    FOnDebug(Self, AProcedure, AMessage);
  end;
end;

procedure TAutoUpdate.Progress(AMessage: String; AProgress: Integer);
begin
  if Assigned(FOnUpdateProgress) then
  begin
    FOnUpdateProgress(Self, AMessage, AProgress, FCancel);
  end;
end;

procedure TAutoUpdate.Cancel;
begin
  FCancel := True;
end;

procedure TAutoUpdate.Execute;
var
  ProxyEnabled: Boolean;
  ProxyType: TProxyType;
  ProxyHostname: string;
  ProxyPort: Integer;
  ProxyAuthentication: Boolean;
  ProxyUsername: string;
  ProxyPassword: string;
begin
  if not FBusy then
  begin
    FBusy := True;
    FCancel := false;
    ProxyEnabled := (FHTTPProxy or FSocksProxy);
    if SocksProxy then
      ProxyType := ptSocks;
    if FHTTPProxy then
      ProxyType := ptHTTP;
    case ProxyType of

      ptHTTP:
        begin
          ProxyHostname := FHTTPHost;
          ProxyPort := FHTTPPort;
          ProxyAuthentication := FHTTPAuthentication;
          ProxyUsername := FHTTPUserName;
          ProxyPassword := FHTTPPassword;
        end;
      ptSocks:
        begin
          ProxyHostname := FSocksHost;
          ProxyPort := FSocksPort;
          ProxyAuthentication := FSocksAuthentication;
          ProxyUsername := FSocksUserName;
          ProxyPassword := FSocksPassword;
        end;
    end;
    TAutoUpdateThread.Create(FUpdateURL, FApplicationName, GetCurrentVersion,
      InternalOnUpdateAvailable, InternalOnUpdateNotRequired,
      InternalOnUpdateBegin, InternalOnUpdateProgress, InternalOnUpdateEnd,
      FAutoUpdate, ProxyEnabled, ProxyType, ProxyHostname, ProxyPort,
      ProxyAuthentication, ProxyUsername, ProxyPassword, FSocksVersion);
  end
  else
  begin
    Debug('Execute', 'An update request is already active.');
  end;
end;

end.
