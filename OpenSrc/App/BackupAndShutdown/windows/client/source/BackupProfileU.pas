{ -----------------------------------------------------------------------------
  Unit Name: BackupProfileU
  Author: Tristan Marlow
  Purpose: Backup Profile and Manager objects.

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

  History: 04/05/2007 - First Release.

  ----------------------------------------------------------------------------- }
unit BackupProfileU;

interface

uses
  CommonU, BackupU, KeywordEmailU, LogU, SystemDetailsU, ProcessTimerU,
  PluginsU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms,
  Dialogs, Buttons, ExtCtrls, Registry,

  DateUtils, INIFiles;

const
  PROFILE_VERSION = 1;

type
  EBackupProfileException = class(Exception);
  EBackupProfileManagerException = class(Exception);

type
  TBackupStatus = (bsIdle, bsFileSearch, bsArchiving);
  TBackupProfileStorageType = (stRegistry, stINI);
  TCompressionLevel = (clNone, clLow, clNormal, clHigh, clMaximum);

type
  TOnStatusChange = procedure(Status: TBackupStatus) of object;

  TBackupProfileSMTPSettings = class(TPersistent)
  private
    FSMTPHostname: string;
    FSMTPPort: integer;
    FSMTPAuthentication: boolean;
    FSMTPSecure: boolean;
    FUsername: string;
    FPassword: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property SMTPHostname: string Read FSMTPHostname Write FSMTPHostname;
    property SMTPPort: integer Read FSMTPPort Write FSMTPPort;
    property SMTPAuthentication: boolean Read FSMTPAuthentication
      Write FSMTPAuthentication;
    property SMTPSecure: boolean Read FSMTPSecure Write FSMTPSecure;
    property Username: string Read FUsername Write FUsername;
    property Password: string Read FPassword Write FPassword;
  end;

  TBackupProfileEmailDetails = class(TPersistent)
  private
    FRecipients: string;
    FSenderAddress: string;
    FSenderName: string;
    FSubject: string;
    FBody: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Recipients: string Read FRecipients Write FRecipients;
    property SenderAddress: string Read FSenderAddress Write FSenderAddress;
    property SenderName: string Read FSenderName Write FSenderName;
    property Subject: string Read FSubject Write FSubject;
    property Body: string Read FBody Write FBody;
  end;

  TBackupProfileFile = class(TCollectionItem)
  private
    FFolder: string;
    FRecursive: boolean;
    FFileMask: string;
  protected
  public
  published
    property Folder: string Read FFolder Write FFolder;
    property Recursive: boolean Read FRecursive Write FRecursive;
    property FileMask: string Read FFileMask Write FFileMask;
  end;

  TBackupProfileFiles = class(TCollection)
  private
  protected
    function GetItem(Index: integer): TBackupProfileFile;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function Add(AFolder, AFileMask: string; ARecursive: boolean)
      : TBackupProfileFile;
    property Item[Index: integer]: TBackupProfileFile Read GetItem;
    function IndexByName(AFolder, AFileMask: string): integer;
    function ItemByName(AFolder, AFileMask: string): TBackupProfileFile;
  published
  end;

type
  TBackupProfile = class(TCollectionItem)
  private
    FProfileVersion: integer;
    FOnLog: TOnLog;
    FOnDebug: TOnDebug;
    FEnabled: boolean;
    FStorageType: TBackupProfileStorageType;
    FProfileName: string;
    FRootKey: HKEY;
    FRegistryKey: string;
    FINIFileName: TFileName;
    FPassword: string;
    FDescription: string;
    FZipType: TZipType;
    FZipFile: TFileName;
    FLogFile: TFileName;
    FLastBackup: TDate;
    FFiles: TBackupProfileFiles;
    FFileExclusions: TBackupProfileFiles;
    FShowAlerts: boolean;
    FAlertDays: integer;
    FActivePrograms: TStrings;
    FCloseGracefully: boolean;
    FSpanningSize: integer;
    FCompressionLevel: TCompressionLevel;
    FCustomSMTPSettings: boolean;
    FSMTPSettings: TBackupProfileSMTPSettings;
    FAlertEmailEnabled: boolean;
    FAlertEmailLastRun: TDateTime;
    FAlertEmailDetails: TBackupProfileEmailDetails;
    FLogEmailEnabled: boolean;
    FLogEmailDetails: TBackupProfileEmailDetails;
    FSystemState: boolean;
    procedure Log(AMessage: string);
    procedure Debug(AProcedure, AMessage: string);
  protected
    function LoadProfileRegistry(AProfileName: string): boolean;
    function DeleteProfileRegistry(AProfileName: string): boolean;
    function SaveProfileRegistry: boolean;
    function LoadProfileINI(AProfileName: string): boolean;
    function DeleteProfileINI(AProfileName: string): boolean;
    function SaveProfileINI: boolean;
    procedure LoadGlobalDefaults;
  public
    function SaveProfile: boolean;
    function LoadProfile: boolean; overload;
    function LoadProfile(AProfileName: string): boolean; overload;
    function DeleteProfile: boolean; overload;
    function DeleteProfile(AProfileName: string): boolean; overload;
    function CheckProfile: boolean;
    function IsBackupOverdue: boolean;
    procedure LoadDefaults;
    procedure SaveAsDefaults;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property ProfileVersion: integer Read FProfileVersion;
    property StorageType: TBackupProfileStorageType Read FStorageType
      Write FStorageType default stRegistry;
    property Enabled: boolean Read FEnabled Write FEnabled default True;
    property ZipType: TZipType Read FZipType Write FZipType default zSeven;
    property ProfileName: string Read FProfileName Write FProfileName;
    property Password: string Read FPassword Write FPassword;
    property Description: string Read FDescription Write FDescription;
    property ZipFile: TFileName Read FZipFile Write FZipFile;
    property LogFile: TFileName Read FLogFile Write FLogFile;
    property LastBackup: TDate Read FLastBackup Write FLastBackup;
    property ShowAlerts: boolean Read FShowAlerts Write FShowAlerts
      default True;
    property AlertDays: integer Read FAlertDays Write FAlertDays default 7;
    property CloseGracefully: boolean Read FCloseGracefully
      Write FCloseGracefully default True;
    property ActivePrograms: TStrings Read FActivePrograms
      Write FActivePrograms;
    property RegistryKey: string Read FRegistryKey Write FRegistryKey;
    property RootKey: HKEY Read FRootKey Write FRootKey
      default HKEY_CURRENT_USER;
    property INIFileName: TFileName Read FINIFileName Write FINIFileName;
    property Files: TBackupProfileFiles Read FFiles Write FFiles;
    property FileExclusions: TBackupProfileFiles Read FFileExclusions
      Write FFileExclusions;
    property SpanningSize: integer Read FSpanningSize Write FSpanningSize
      default 0;
    property CompressionLevel: TCompressionLevel Read FCompressionLevel
      Write FCompressionLevel;
    property CustomSMTPSettings: boolean Read FCustomSMTPSettings
      Write FCustomSMTPSettings;
    property SMTPSettings: TBackupProfileSMTPSettings Read FSMTPSettings;
    property AlertEmailEnabled: boolean Read FAlertEmailEnabled
      Write FAlertEmailEnabled;
    property AlertEmailLastRun: TDateTime Read FAlertEmailLastRun
      Write FAlertEmailLastRun;
    property AlertEmailDetails: TBackupProfileEmailDetails
      Read FAlertEmailDetails;
    property LogEmailEnabled: boolean Read FLogEmailEnabled
      Write FLogEmailEnabled;
    property LogEmailDetails: TBackupProfileEmailDetails Read FLogEmailDetails;
    property SystemState: boolean Read FSystemState Write FSystemState;
    property OnLog: TOnLog Read FOnLog Write FOnLog;
    property OnDebug: TOnDebug Read FOnDebug Write FOnDebug;
  end;

type
  TBackupProfiles = class(TCollection)
  private
  protected
    function GetItem(AIndex: integer): TBackupProfile;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function GetProfileIndex(AProfileName: string): integer;
    function ProfileByName(AProfileName: string): TBackupProfile;
    function Add(AProfileName: string): TBackupProfile;
    property Profile[AIndex: integer]: TBackupProfile Read GetItem;
  published
  end;

type
  TBackupProfileQueueStatus = (qsPending, qsInProgress, qsComplete, qsFailed,
    qsCancelled);

type
  TBackupProfileQueueItem = class(TCollectionItem)
  private
    FProfileName: string;
    FQueueStatus: TBackupProfileQueueStatus;
  protected
  public
  published
    property ProfileName: string Read FProfileName Write FProfileName;
    property QueueStatus: TBackupProfileQueueStatus Read FQueueStatus
      Write FQueueStatus;
  end;

type
  TBackupProfileQueue = class(TCollection)
  private
  protected
    function GetItem(Index: integer): TBackupProfileQueueItem;
    function GetCompletedCount: integer;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function FindProfileIndex(AProfileName: string): integer;
    function ProfileByName(AProfileName: string): TBackupProfileQueueItem;
    function Add(AProfileName: string): TBackupProfileQueueItem;
    property Item[Index: integer]: TBackupProfileQueueItem Read GetItem;
  published
  end;

type
  TOnCheckActiveApplications = procedure(AActiveApplications: TStrings;
    const ACloseGracefully: boolean; var ACancel: boolean) of object;
  TOnRemainingTime = procedure(ASender: TObject;
    ATotalAmount, ACurrentAmount: integer;
    AElapsedTime, AEstimatedTime: TDateTime) of object;
  TOnCancelQueueRequest = procedure(ASender: TObject; var ACancelAll: boolean)
    of object;
  TOnCancelConfirm = procedure(ASender: TObject; var ACancel: boolean)
    of object;
  TOnCloseActiveApplications = procedure(ASender: TObject;
    AActiveApplications: TStrings; ACloseGracefully: boolean;
    var AContinue: boolean) of object;
  TOnBackupAlerts = procedure(ASender: TObject; ACount: integer) of object;
  TOnStartBackup = procedure(ASender: TObject; ABackupProfile: TBackupProfile)
    of object;
  TOnFinishBackup = procedure(ASender: TObject; ABackupProfile: TBackupProfile)
    of object;

type
  TBackupProfileManager = class(TObject)
  private
    FDebugBackup: boolean;
    FOnLog: TOnLog;
    FOnDebug: TOnDebug;
    FStorageType: TBackupProfileStorageType;
    FRootKey: HKEY;
    FRegistryKey: string;
    FRootFolder: string;
    FDLLFolder: string;
    FLogFolder: string;
    FPlugins: TPlugins;
    FBackup: TBackup;
    FLog: TLog;
    FBackupActive: boolean;
    FBackupProfileQueue: TBackupProfileQueue;
    FBackupProfiles: TBackupProfiles;
    FSMTPSettings: TBackupProfileSMTPSettings;
    FProcessTimer: TProcessTimer;
    FOnBackupProgress: TOnProgress;
    FOnProfileProgress: TOnProgress;
    FOnTotalProgress: TOnProgress;
    FOnRemainingTime: TOnRemainingTime;
    FOnCancelConfirm: TOnCancelConfirm;
    FOnCancelQueueRequest: TOnCancelQueueRequest;
    FOnBackupAlerts: TOnBackupAlerts;
    FOnCloseActiveApplications: TOnCloseActiveApplications;
    FOnStartBackup: TOnStartBackup;
    FOnFinishBackup: TOnFinishBackup;
    FOnNTBackupStart: TNotifyEvent;
    FOnNTBackupFinished: TNotifyEvent;
    FOnPluginsStart: TNotifyEvent;
    FOnPluginsFileListStart: TNotifyEvent;
    FOnPluginsFileListFinished: TNotifyEvent;
    FOnPluginsFinished: TNotifyEvent;
    FPluginFolder: string;
    procedure Log(AMessage: string);
    procedure Debug(AProcedure, AMessage: string);
  protected
    function LoadProfilesRegistry: boolean;
    function LoadProfilesINI: boolean;
    function GetBackupActive: boolean;
    procedure InternalBackupOnLog(ASender: TObject; AMessage: string;
      AErrorCode: integer = BACKUP_LOG_INFO);
    procedure InternalBackupOnDebug(ASender: TObject;
      AProcedure, AMessage: string);
    procedure InternalBackupOnSearchProgress(ASender: TObject; AMessage: string;
      AProgress: integer);
    procedure InternalBackupOnBackupFinished(ASender: TObject;
      ASuccess: boolean);
    procedure InternalBackupOnItemProgress(ASender: TObject; AMessage: string;
      AProgress: integer);
    procedure InternalBackupOnTotalProgress(ASender: TObject; AMessage: string;
      AProgress: integer);
    procedure InternalBackupOnFileList(ASender: TObject; AFileList: TStrings);
    procedure InternalBackupOnFileExcludeList(ASender: TObject;
      AFileList: TStrings);
    procedure InternalBackupOnNTBackupStart(ASender: TObject);
    procedure InternalBackupOnNTBackupFinished(ASender: TObject);
    function ExecuteBackup(AProfileName: string; AZipFileList: TStrings)
      : TBackupResult;
    procedure SetProfileEmailKeywords(AKeyWordEmail: TKeywordEmail;
      ABackupProfile: TBackupProfile);
    function SendBackupLogEmail(ABackupProfile: TBackupProfile): boolean;
    function SendBackupAlertEmail(ABackupProfile: TBackupProfile): boolean;
    function CloseActiveApplications(ABackupProfile: TBackupProfile): boolean;
    function GetProfileByIndex(AIndex: integer): TBackupProfile;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function ProfileByName(AProfileName: string): TBackupProfile;
    property Profile[AIndex: integer]: TBackupProfile Read GetProfileByIndex;
    function NewProfile(AProfileName: string): TBackupProfile;
    function DeleteProfile(AProfileName: string): boolean;
    function ProfileCount: integer;
    function LoadProfiles: boolean;
    function SaveProfiles: boolean;
    function Backup: boolean;
    procedure CancelBackup;
    procedure QueueAllEnabled;
    procedure QueueOverdue;
    procedure QueueAll;
    procedure QueueAdd(AProfileName: string);
    procedure ClearQueue;
    procedure CheckBackupAlerts;
    property Queue: TBackupProfileQueue Read FBackupProfileQueue;
    property DebugBackup: boolean Read FDebugBackup Write FDebugBackup;
    property StorageType: TBackupProfileStorageType Read FStorageType
      Write FStorageType default stRegistry;
    property RegistryKey: string Read FRegistryKey Write FRegistryKey;
    property RootKey: HKEY Read FRootKey Write FRootKey
      default HKEY_CURRENT_USER;
    property RootFolder: string Read FRootFolder Write FRootFolder;
    property DLLFolder: string Read FDLLFolder Write FDLLFolder;
    property LogFolder: string Read FLogFolder Write FLogFolder;
    property PluginFolder: string Read FPluginFolder Write FPluginFolder;
    property SMTPSettings: TBackupProfileSMTPSettings Read FSMTPSettings;
    property IsBackupActive: boolean Read GetBackupActive;
    property OnLog: TOnLog Read FOnLog Write FOnLog;
    property OnDebug: TOnDebug Read FOnDebug Write FOnDebug;
    property OnStartBackup: TOnStartBackup Read FOnStartBackup
      Write FOnStartBackup;
    property OnFinishBackup: TOnFinishBackup Read FOnFinishBackup
      Write FOnFinishBackup;
    property OnBackupProgress: TOnProgress Read FOnBackupProgress
      Write FOnBackupProgress;
    property OnProfileProgress: TOnProgress Read FOnProfileProgress
      Write FOnProfileProgress;
    property OnTotalProgress: TOnProgress Read FOnTotalProgress
      Write FOnTotalProgress;
    property OnRemainingTime: TOnRemainingTime Read FOnRemainingTime
      Write FOnRemainingTime;
    property OnCancelConfirm: TOnCancelConfirm Read FOnCancelConfirm
      Write FOnCancelConfirm;
    property OnCancelQueueRequest: TOnCancelQueueRequest
      Read FOnCancelQueueRequest Write FOnCancelQueueRequest;
    property OnBackupAlerts: TOnBackupAlerts Read FOnBackupAlerts
      Write FOnBackupAlerts;
    property OnCloseActiveApplications: TOnCloseActiveApplications
      Read FOnCloseActiveApplications Write FOnCloseActiveApplications;
    property OnNTBackupStart: TNotifyEvent Read FOnNTBackupStart
      Write FOnNTBackupStart;
    property OnNTBackupFinished: TNotifyEvent Read FOnNTBackupFinished
      Write FOnNTBackupFinished;
    property OnPluginsStart: TNotifyEvent Read FOnPluginsStart
      Write FOnPluginsStart;
    property OnPluginsFinished: TNotifyEvent Read FOnPluginsFinished
      Write FOnPluginsFinished;
    property OnPluginsFileListStart: TNotifyEvent Read FOnPluginsFileListStart
      Write FOnPluginsFileListStart;
    property OnPluginsFileListFinished: TNotifyEvent
      Read FOnPluginsFileListFinished Write FOnPluginsFileListFinished;
  end;

implementation

// TBackupProfileSMTPSettings
procedure TBackupProfileSMTPSettings.Assign(Source: TPersistent);
begin
  if (Source is TBackupProfileSMTPSettings) then
  begin
    FSMTPHostname := (Source as TBackupProfileSMTPSettings).SMTPHostname;
    FSMTPPort := (Source as TBackupProfileSMTPSettings).SMTPPort;
    FSMTPAuthentication := (Source as TBackupProfileSMTPSettings)
      .SMTPAuthentication;
    FSMTPSecure := (Source as TBackupProfileSMTPSettings).SMTPSecure;
    FUsername := (Source as TBackupProfileSMTPSettings).Username;
    FPassword := (Source as TBackupProfileSMTPSettings).Password;
  end;
  // inherited Assign(Source);
end;

// TBackupProfileEmailDetails
procedure TBackupProfileEmailDetails.Assign(Source: TPersistent);
begin
  if (Source is TBackupProfileEmailDetails) then
  begin
    FRecipients := (Source as TBackupProfileEmailDetails).Recipients;
    FSenderAddress := (Source as TBackupProfileEmailDetails).SenderAddress;
    FSenderName := (Source as TBackupProfileEmailDetails).SenderName;
    FSubject := (Source as TBackupProfileEmailDetails).Subject;
    FBody := (Source as TBackupProfileEmailDetails).Body;
  end;
  // inherited Assign(Source);
end;


// TBackupProfileFiles

constructor TBackupProfileFiles.Create;
begin
  inherited Create(TBackupProfileFile);
end;

destructor TBackupProfileFiles.Destroy;
begin
  inherited Destroy;
end;

function TBackupProfileFiles.GetItem(Index: integer): TBackupProfileFile;
begin
  Result := inherited Items[Index] as TBackupProfileFile;
end;

function TBackupProfileFiles.Add(AFolder, AFileMask: string;
  ARecursive: boolean): TBackupProfileFile;
begin
  Result := nil;
  if Trim(AFolder) <> '' then
  begin
    Result := ItemByName(AFolder, AFileMask);
    if Result = nil then
    begin
      Result := inherited Add as TBackupProfileFile;
    end;
    with Result do
    begin
      Folder := AFolder;
      FileMask := AFileMask;
      Recursive := ARecursive;
    end;
  end;
end;

function TBackupProfileFiles.IndexByName(AFolder, AFileMask: string): integer;
var
  Idx: integer;
  Found: boolean;
begin
  Found := False;
  Result := -1;
  Idx := 0;
  while (not Found) and (Idx <= Pred(Self.Count)) do
  begin
    if (UpperCase(Self.Item[Idx].Folder) = UpperCase(AFolder)) and
      (UpperCase(Self.Item[Idx].FFileMask) = UpperCase(AFileMask)) then
    begin
      Result := Idx;
      Found := True;
    end;
    Inc(Idx);
  end;
end;

function TBackupProfileFiles.ItemByName(AFolder, AFileMask: string)
  : TBackupProfileFile;
var
  Idx: integer;
begin
  Idx := IndexByName(AFolder, AFileMask);
  if Idx <> -1 then
  begin
    Result := Self.Item[Idx];
  end
  else
  begin
    Result := nil;
  end;
end;

// TBackupProfile

constructor TBackupProfile.Create(Collection: TCollection);
begin
  FProfileVersion := -1;
  FEnabled := True;
  FZipType := zSeven;
  FSystemState := False;
  FStorageType := stRegistry;
  FRootKey := HKEY_CURRENT_USER;
  FPassword := '';
  FSpanningSize := 2000 * 1048576; // 2 GIG
  FCompressionLevel := clMaximum;
  FCloseGracefully := True;
  FCustomSMTPSettings := False;
  FShowAlerts := True;
  FAlertDays := 7;
  FAlertEmailLastRun := 0;
  FActivePrograms := TStringList.Create;
  FFiles := TBackupProfileFiles.Create;
  FFileExclusions := TBackupProfileFiles.Create;
  FSMTPSettings := TBackupProfileSMTPSettings.Create;
  FAlertEmailDetails := TBackupProfileEmailDetails.Create;
  FLogEmailDetails := TBackupProfileEmailDetails.Create;
  inherited Create(Collection);
end;

destructor TBackupProfile.Destroy;
begin
  FreeAndNil(FActivePrograms);
  FreeAndNil(FFiles);
  FreeAndNil(FFileExclusions);
  FreeAndNil(FSMTPSettings);
  FreeAndNil(FAlertEmailDetails);
  FreeAndNil(FLogEmailDetails);
  inherited Destroy;
end;

procedure TBackupProfile.Log(AMessage: string);
begin
  if Assigned(FOnLog) then
    FOnLog(Self, AMessage);
end;

procedure TBackupProfile.Debug(AProcedure, AMessage: string);
begin
  if Assigned(FOnDebug) then
    FOnDebug(Self, AProcedure, AMessage);
end;

function TBackupProfile.SaveProfile: boolean;
begin
  Log('Saving Profile: ' + FProfileName);
  if FStorageType = stRegistry then
  begin
    Result := SaveProfileRegistry;
  end
  else
  begin
    Result := SaveProfileINI;
  end;
end;

function TBackupProfile.SaveProfileRegistry: boolean;
var
  Registry: TRegistry;
  FileList: TStringList;
  i: integer;
begin
  Result := False;
  if FProfileName <> '' then
  begin
    try
      Registry := TRegistry.Create;
      FileList := TStringList.Create;
      with Registry do
      begin
        RootKey := FRootKey;
        if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName,
          True) then
        begin
          WriteInteger('ProfileVersion', PROFILE_VERSION);
          WriteBool('Enabled', FEnabled);
          WriteString('Password', FPassword);
          WriteString('Description', FDescription);
          WriteString('ZipFile', FZipFile);
          WriteInteger('ZipType', integer(FZipType));
          WriteString('LogFile', FLogFile);
          WriteDate('LastBackup', FLastBackup);
          WriteBool('ShowAlerts', FShowAlerts);
          WriteInteger('AlertDays', FAlertDays);
          WriteBool('CloseGracefully', FCloseGracefully);
          WriteBool('AlertEmailEnabled', FAlertEmailEnabled);
          WriteDateTime('AlertEmailLastRun', FAlertEmailLastRun);
          WriteBool('LogEmailEnabled', FLogEmailEnabled);
          WriteInteger('SpanningSize', FSpanningSize);
          WriteInteger('CompressionLevel', integer(FCompressionLevel));
          WriteBool('CustomSMTPSettings', FCustomSMTPSettings);
          WriteBool('SystemState', FSystemState);
          GetKeyNames(FileList);
          for i := 0 to Pred(FileList.Count) do
            DeleteKey(FileList[i]);
          for i := 0 to Pred(FFiles.Count) do
          begin
            with FFiles.Item[i] do
            begin
              CloseKey;
              if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) +
                FProfileName + '\Files\' + IntToStr(i), True) then
              begin
                WriteString('folder', Folder);
                WriteString('filemask', FileMask);
                WriteBool('recursive', Recursive);
              end;
            end;
          end;
          for i := 0 to Pred(FFileExclusions.Count) do
          begin
            with FFileExclusions.Item[i] do
            begin
              CloseKey;
              if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) +
                FProfileName + '\FileExclusions\' + IntToStr(i), True) then
              begin
                WriteString('folder', Folder);
                WriteString('filemask', FileMask);
                WriteBool('recursive', Recursive);
              end;
            end;
          end;
          for i := 0 to Pred(FActivePrograms.Count) do
          begin
            CloseKey;
            if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName
              + '\Active Programs', True) then
            begin
              WriteString(FActivePrograms.Names[i],
                FActivePrograms.ValueFromIndex[i]);
            end;
          end;
          with FAlertEmailDetails do
          begin
            CloseKey;
            if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName
              + '\AlertEmail', True) then
            begin
              WriteString('Recipients', Recipients);
              WriteString('SenderAddress', SenderAddress);
              WriteString('SenderName', SenderName);
              WriteString('Subject', Subject);
              WriteString('Body', Body);
              CloseKey;
            end;
          end;
          with FLogEmailDetails do
          begin
            CloseKey;
            if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName
              + '\LogEmail', True) then
            begin
              WriteString('Recipients', Recipients);
              WriteString('SenderAddress', SenderAddress);
              WriteString('SenderName', SenderName);
              WriteString('Subject', Subject);
              WriteString('Body', Body);
              CloseKey;
            end;
          end;
          with FSMTPSettings do
          begin
            CloseKey;
            if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName
              + '\SMTPSettings', True) then
            begin
              WriteString('SMTPHostname', SMTPHostname);
              WriteInteger('SMTPPort', SMTPPort);
              WriteString('Username', Username);
              WriteString('Password', Password);
              WriteBool('SMTPAuthentication', SMTPAuthentication);
              WriteBool('SMTPSecure', SMTPAuthentication);
              CloseKey;
            end;
          end;
          Result := True;
        end;
      end;
    finally
      FreeAndNil(Registry);
      FreeAndNil(FileList);
    end;
  end;
end;

procedure TBackupProfile.LoadGlobalDefaults;
var
  OldRootKey: HKEY;
  OldKey: string;
  OldProfileName: string;
begin
  OldRootKey := FRootKey;
  OldKey := FRegistryKey;
  OldProfileName := FProfileName;
  try
    FRootKey := HKEY_USERS;
    FRegistryKey := '.Default\Software\Little Earth Solutions\BandS';
    LoadProfile('.Default');
  finally
    FRootKey := OldRootKey;
    FRegistryKey := OldKey;
    FProfileName := OldProfileName;
  end;
end;

procedure TBackupProfile.LoadDefaults;
var
  DefProfile: TBackupProfile;
begin
  LoadGlobalDefaults;
  DefProfile := TBackupProfile.Create(Collection);
  try
    DefProfile.RootKey := FRootKey;
    DefProfile.RegistryKey := FRegistryKey;
    DefProfile.StorageType := FStorageType;
    if DefProfile.LoadProfile('.Default') then
    begin
      FPassword := DefProfile.Password;
      // FLogEmail.Assign(DefProfile.LogEmail);
      FShowAlerts := DefProfile.ShowAlerts;
      FAlertDays := DefProfile.AlertDays;
      // FAlertEmail.Assign(DefProfile.AlertEmail);
      FActivePrograms.Assign(DefProfile.ActivePrograms);
      FCloseGracefully := DefProfile.CloseGracefully;
    end;

  finally
    FreeAndNil(DefProfile);
  end;
end;

procedure TBackupProfile.SaveAsDefaults;
var
  DefProfile: TBackupProfile;
begin
  DefProfile := TBackupProfile.Create(Collection);
  DefProfile.RootKey := FRootKey;
  DefProfile.RegistryKey := FRegistryKey;
  DefProfile.StorageType := FStorageType;
  DefProfile.ProfileName := '.Default';
  DefProfile.Password := FPassword;
  // DefProfile.LogEmail.Assign(FLogEmail);
  DefProfile.ShowAlerts := FShowAlerts;
  DefProfile.AlertDays := FAlertDays;
  // DefProfile.AlertEmail.Assign(FAlertEmail);
  DefProfile.ActivePrograms.Assign(FActivePrograms);
  DefProfile.CloseGracefully := FCloseGracefully;
  DefProfile.SaveProfile;
  FreeAndNil(DefProfile);
end;

function TBackupProfile.LoadProfile: boolean;
begin
  Result := LoadProfile(FProfileName);
end;

function TBackupProfile.LoadProfile(AProfileName: string): boolean;
begin
  Log('Loading Profile: ' + AProfileName);
  Debug('LoadProfile', AProfileName);
  if FStorageType = stRegistry then
  begin
    Result := LoadProfileRegistry(AProfileName);
  end
  else
  begin
    Result := LoadProfileINI(AProfileName);
  end;
  if Result then
    Result := CheckProfile;
end;

function TBackupProfile.LoadProfileRegistry(AProfileName: string): boolean;
var
  Registry: TRegistry;
  FileList: TStringList;
  i: integer;
begin
  Result := False;
  if AProfileName <> '' then
  begin
    FProfileName := AProfileName;
    FFiles.Clear;
    FFileExclusions.Clear;
    FileList := TStringList.Create;
    Registry := TRegistry.Create;
    try
      with Registry do
      begin
        RootKey := FRootKey;
        if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + AProfileName,
          False) then
        begin
          if ValueExists('ProfileVersion') then
            FProfileVersion := ReadInteger('ProfileVersion');
          if ValueExists('Enabled') then
            FEnabled := ReadBool('Enabled');
          if ValueExists('ZipType') then
            FZipType := TZipType(ReadInteger('ZipType'));
          if ValueExists('Password') then
            FPassword := ReadString('Password');
          if ValueExists('Description') then
            FDescription := ReadString('Description');
          if ValueExists('ZipFile') then
            FZipFile := ReadString('ZipFile');
          if ValueExists('LogFile') then
            FLogFile := ReadString('LogFile');
          if ValueExists('LastBackup') then
            FLastBackup := ReadDate('LastBackup');
          if ValueExists('ShowAlerts') then
            FShowAlerts := ReadBool('ShowAlerts');
          if ValueExists('AlertDays') then
            FAlertDays := ReadInteger('AlertDays');
          if ValueExists('CloseGracefully') then
            FCloseGracefully := ReadBool('CloseGracefully');
          if ValueExists('AlertEmailEnabled') then
            FAlertEmailEnabled := ReadBool('AlertEmailEnabled');
          if ValueExists('LogEmailEnabled') then
            FLogEmailEnabled := ReadBool('AlertEmailEnabled');
          if ValueExists('AlertEmailLastRun') then
            FAlertEmailLastRun := ReadDateTime('AlertEmailLastRun');
          if ValueExists('SpanningSize') then
            FSpanningSize := ReadInteger('SpanningSize');
          if ValueExists('CompressionLevel') then
            FCompressionLevel :=
              TCompressionLevel(ReadInteger('CompressionLevel'));
          if ValueExists('CustomSMTPSettings') then
            FCustomSMTPSettings := ReadBool('CustomSMTPSettings');
          if ValueExists('SystemState') then
            FSystemState := ReadBool('SystemState');
          CloseKey;
          if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName +
            '\Files', False) then
          begin
            GetKeyNames(FileList);
            for i := 0 to Pred(FileList.Count) do
            begin
              CloseKey;
              if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) +
                FProfileName + '\Files\' + FileList[i], False) then
              begin
                FFiles.Add(ReadString('folder'), ReadString('filemask'),
                  ReadBool('recursive'));
              end;
            end;
          end;
          CloseKey;
          if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName +
            '\FileExclusions', False) then
          begin
            GetKeyNames(FileList);
            for i := 0 to Pred(FileList.Count) do
            begin
              CloseKey;
              if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) +
                FProfileName + '\FileExclusions\' + FileList[i], False) then
              begin
                FFileExclusions.Add(ReadString('folder'),
                  ReadString('filemask'), ReadBool('recursive'));
              end;
            end;
          end;
          CloseKey;
          if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName +
            '\Active Programs', True) then
          begin
            GetValueNames(FActivePrograms);
            for i := 0 to Pred(FActivePrograms.Count) do
            begin
              FActivePrograms[i] := FActivePrograms[i] + '=' +
                ReadString(FActivePrograms[i]);
            end;
            CloseKey;
          end;
          with FAlertEmailDetails do
          begin
            if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName
              + '\AlertEmail', True) then
            begin
              if ValueExists('Recipients') then
                Recipients := ReadString('Recipients');
              if ValueExists('SenderAddress') then
                SenderAddress := ReadString('SenderAddress');
              if ValueExists('SenderName') then
                SenderName := ReadString('SenderName');
              if ValueExists('Subject') then
                Subject := ReadString('Subject');
              if ValueExists('Body') then
                Body := ReadString('Body');
              CloseKey;
            end;
          end;
          with FLogEmailDetails do
          begin
            if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName
              + '\LogEmail', True) then
            begin
              if ValueExists('Recipients') then
                Recipients := ReadString('Recipients');
              if ValueExists('SenderAddress') then
                SenderAddress := ReadString('SenderAddress');
              if ValueExists('SenderName') then
                SenderName := ReadString('SenderName');
              if ValueExists('Subject') then
                Subject := ReadString('Subject');
              if ValueExists('Body') then
                Body := ReadString('Body');
              CloseKey;
            end;
          end;
          with FSMTPSettings do
          begin
            CloseKey;
            if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey) + FProfileName
              + '\SMTPSettings', True) then
            begin
              if ValueExists('SMTPHostname') then
                SMTPHostname := ReadString('SMTPHostname');
              if ValueExists('SMTPPort') then
                SMTPPort := ReadInteger('SMTPPort');
              if ValueExists('Username') then
                Username := ReadString('Username');
              if ValueExists('Password') then
                Password := ReadString('Password');
              if ValueExists('SMTPAuthentication') then
                SMTPAuthentication := ReadBool('SMTPAuthentication');
              if ValueExists('SMTPSecure') then
                SMTPSecure := ReadBool('SMTPSecure');
              CloseKey;
            end;
          end;
          FProfileVersion := PROFILE_VERSION;
          Result := True;
        end
        else
        begin
          Result := False;
        end;
      end;
    finally
      FreeAndNil(Registry);
      FreeAndNil(FileList);
    end;
  end;
end;

function TBackupProfile.LoadProfileINI(AProfileName: string): boolean;
var
  INIFile: TINIFile;
begin
  INIFile := TINIFile.Create(FINIFileName);
  try
    with INIFile do
    begin

    end;

  finally
    FreeAndNil(INIFile);
  end;
  Result := True;
end;

function TBackupProfile.DeleteProfileINI(AProfileName: string): boolean;
var
  INIFile: TINIFile;
begin
  INIFile := TINIFile.Create(FINIFileName);
  try
    with INIFile do
    begin
    end;
  finally
    FreeAndNil(INIFile);
  end;

  Result := True;
end;

function TBackupProfile.SaveProfileINI: boolean;
var
  INIFile: TINIFile;
begin
  INIFile := TINIFile.Create(FINIFileName);
  with INIFile do
  begin
  end;
  FreeAndNil(INIFile);
  Result := True;
end;

function TBackupProfile.DeleteProfile: boolean;
begin
  Result := DeleteProfile(FProfileName);
end;

function TBackupProfile.DeleteProfile(AProfileName: string): boolean;
begin
  if FStorageType = stRegistry then
  begin
    Result := DeleteProfileRegistry(AProfileName);
  end
  else
  begin
    Result := DeleteProfileINI(AProfileName);
  end;
end;

function TBackupProfile.CheckProfile: boolean;
begin
  Result := True;
  if FProfileVersion = -1 then
  begin
    ChangeFileExt(FZipFile, '.7z');
  end;
end;

function TBackupProfile.IsBackupOverdue: boolean;
begin
  Result := False;
  if FShowAlerts and FEnabled then
  begin
    Debug('IsBackupOverdue', FProfileName + ', Last Backup: ' +
      DateToStr(FLastBackup));
    Debug('IsBackupOverdue', FProfileName + ', Due Date: ' +
      DateToStr(IncDay(FLastBackup, FAlertDays)));
    Result := IncDay(FLastBackup, FAlertDays) <= Today;
  end;
  Debug('IsBackupOverdue', FProfileName + ', Result: ' +
    BoolToStr(Result, True));
end;

function TBackupProfile.DeleteProfileRegistry(AProfileName: string): boolean;
var
  Registry: TRegistry;
begin
  Result := False;
  if AProfileName <> '' then
  begin
    Registry := TRegistry.Create;
    try
      with Registry do
      begin
        RootKey := FRootKey;
        if KeyExists(IncludeTrailingPathDelimiter(FRegistryKey) + AProfileName)
        then
        begin
          Result := DeleteKey(IncludeTrailingPathDelimiter(FRegistryKey) +
            AProfileName);
        end;
      end;
    finally
      FreeAndNil(Registry);
    end;
  end;

end;

// TBackupProfileQueue

constructor TBackupProfileQueue.Create;
begin
  inherited Create(TBackupProfileQueueItem);
end;

destructor TBackupProfileQueue.Destroy;
begin
  inherited Destroy;
end;

function TBackupProfileQueue.GetItem(Index: integer): TBackupProfileQueueItem;
begin
  Result := inherited Items[Index] as TBackupProfileQueueItem;
end;

function TBackupProfileQueue.GetCompletedCount: integer;
var
  Idx: integer;
begin
  Result := 0;
  for Idx := 0 to Pred(Self.Count) do
  begin
    if Self.Item[Idx].QueueStatus in [qsComplete, qsFailed, qsCancelled] then
      Inc(Result);
  end;
end;

function TBackupProfileQueue.FindProfileIndex(AProfileName: string): integer;
var
  Idx: integer;
begin
  Result := -1;
  Idx := 0;
  while (Result = -1) and (Idx < Self.Count) do
  begin
    if (Self.Item[Idx].ProfileName = AProfileName) then
    begin
      Result := Idx;
    end;
    Inc(Idx);
  end;
end;

function TBackupProfileQueue.ProfileByName(AProfileName: string)
  : TBackupProfileQueueItem;
var
  Idx: integer;
begin
  Result := nil;
  Idx := FindProfileIndex(AProfileName);
  if Idx <> -1 then
  begin
    Result := Item[Idx];
  end;
end;

function TBackupProfileQueue.Add(AProfileName: string): TBackupProfileQueueItem;
begin
  if FindProfileIndex(AProfileName) = -1 then
  begin
    Result := inherited Add as TBackupProfileQueueItem;
    with Result do
    begin
      ProfileName := AProfileName;
      QueueStatus := qsPending;
    end;
  end
  else
  begin
    raise Exception.CreateFmt('Profile already queued "%s"', [AProfileName]);
  end;
end;

// TBackupProfiles

function TBackupProfiles.GetItem(AIndex: integer): TBackupProfile;
begin
  Result := inherited Items[AIndex] as TBackupProfile;
end;

constructor TBackupProfiles.Create;
begin
  inherited Create(TBackupProfile);
end;

destructor TBackupProfiles.Destroy;
begin
  inherited Destroy;
end;

function TBackupProfiles.GetProfileIndex(AProfileName: string): integer;
var
  Idx: integer;
begin
  Result := -1;
  Idx := 0;
  while (Result = -1) and (Idx < Self.Count) do
  begin
    if (Self.Profile[Idx].ProfileName = AProfileName) then
    begin
      Result := Idx;
    end;
    Inc(Idx);
  end;
end;

function TBackupProfiles.ProfileByName(AProfileName: string): TBackupProfile;
var
  Idx: integer;
begin
  Result := nil;
  Idx := GetProfileIndex(AProfileName);
  if Idx <> -1 then
  begin
    Result := Profile[Idx];
  end;
end;

function TBackupProfiles.Add(AProfileName: string): TBackupProfile;
begin
  Result := ProfileByName(AProfileName);
  if Result = nil then
  begin
    Result := inherited Add as TBackupProfile;
  end;
  with Result do
  begin
    ProfileName := AProfileName;
  end;
end;

// TBackupProfileManager

constructor TBackupProfileManager.Create;
begin
  inherited Create;
  FDebugBackup := False;
  FBackup := TBackup.Create(nil);
  FLog := TLog.Create(nil);
  FBackupProfileQueue := TBackupProfileQueue.Create;
  FBackupProfiles := TBackupProfiles.Create;
  FProcessTimer := TProcessTimer.Create;
  FSMTPSettings := TBackupProfileSMTPSettings.Create;
  FPlugins := TPlugins.Create;
  FPluginFolder := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    'plugins\';
end;

destructor TBackupProfileManager.Destroy;
begin
  FreeAndNil(FBackup);
  FreeAndNil(FLog);
  FreeAndNil(FBackupProfileQueue);
  FreeAndNil(FBackupProfiles);
  FreeAndNil(FProcessTimer);
  FreeAndNil(FSMTPSettings);
  FreeAndNil(FPlugins);
  inherited Destroy;
end;

procedure TBackupProfileManager.Log(AMessage: string);
begin
  if Assigned(FOnLog) then
    FOnLog(Self, AMessage);
end;

procedure TBackupProfileManager.Debug(AProcedure, AMessage: string);
begin
  if Assigned(FOnDebug) then
    FOnDebug(Self, AProcedure, AMessage);
end;

function TBackupProfileManager.GetProfileByIndex(AIndex: integer)
  : TBackupProfile;
begin
  Result := FBackupProfiles.Profile[AIndex];
end;

function TBackupProfileManager.ProfileByName(AProfileName: string)
  : TBackupProfile;
begin
  Result := FBackupProfiles.ProfileByName(AProfileName);
end;

function TBackupProfileManager.NewProfile(AProfileName: string): TBackupProfile;
var
  NewProfileName: string;
  ProfileIdx: integer;
begin
  ProfileIdx := 1;
  NewProfileName := AProfileName;
  while FBackupProfiles.ProfileByName(NewProfileName) <> nil do
  begin
    NewProfileName := AProfileName + ' ' + IntToStr(ProfileIdx);
    Inc(ProfileIdx);
  end;
  Result := FBackupProfiles.Add(NewProfileName);
  with Result do
  begin
    OnLog := Self.OnLog;
    OnDebug := Self.OnDebug;
    StorageType := Self.StorageType;
    RegistryKey := Self.RegistryKey;
    RootKey := Self.RootKey;
    LoadDefaults;
    ProfileName := NewProfileName;
  end;
end;

function TBackupProfileManager.DeleteProfile(AProfileName: string): boolean;
var
  BackupProfile: TBackupProfile;
begin
  Result := False;
  BackupProfile := ProfileByName(AProfileName);
  if BackupProfile <> nil then
  begin
    Result := BackupProfile.DeleteProfile;
    FBackupProfiles.Delete(FBackupProfiles.GetProfileIndex(AProfileName));
  end;
end;

function TBackupProfileManager.ProfileCount: integer;
begin
  Result := FBackupProfiles.Count;
end;

function TBackupProfileManager.LoadProfilesRegistry: boolean;
var
  Registry: TRegistry;
  TempList: TStringList;
  Idx: integer;
begin
  Result := False;
  TempList := TStringList.Create;
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      Debug('LoadProfilesRegistry', FRegistryKey);
      RootKey := FRootKey;
      if OpenKey(IncludeTrailingPathDelimiter(FRegistryKey), False) then
      begin
        GetKeyNames(TempList);
        for Idx := 0 to Pred(TempList.Count) do
        begin
          if UpperCase(TempList[Idx]) <> '.DEFAULT' then
          begin
            Debug('LoadProfilesRegistry', 'Loading profile: ' + TempList[Idx]);
            with FBackupProfiles.Add(TempList[Idx]) do
            begin
              OnLog := Self.OnLog;
              OnDebug := Self.OnDebug;
              StorageType := Self.StorageType;
              RegistryKey := Self.RegistryKey;
              RootKey := Self.RootKey;
              LoadProfile;
            end;
          end
          else
          begin
            Debug('LoadProfilesRegistry', 'Ignoring .DEFAULT profile.');
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(Registry);
    FreeAndNil(TempList);
  end;
end;

function TBackupProfileManager.LoadProfilesINI: boolean;
begin
  Result := False;
end;

function TBackupProfileManager.GetBackupActive: boolean;
begin
  Result := FBackupActive;
end;

function TBackupProfileManager.LoadProfiles: boolean;
begin
  Result := False;
  FBackupProfiles.Clear;
  case FStorageType of
    stRegistry:
      Result := LoadProfilesRegistry;
    stINI:
      Result := LoadProfilesINI;
  end;
end;

function TBackupProfileManager.SaveProfiles: boolean;
var
  ProfileIdx: integer;
begin
  Result := True;
  for ProfileIdx := 0 to Pred(FBackupProfiles.Count) do
  begin
    if not FBackupProfiles.Profile[ProfileIdx].SaveProfile then
    begin
      Log('Failed to save profile: ' + FBackupProfiles.Profile[ProfileIdx]
        .ProfileName);
      Result := False;
    end;
  end;
end;

procedure TBackupProfileManager.InternalBackupOnLog(ASender: TObject;
  AMessage: string; AErrorCode: integer = BACKUP_LOG_INFO);
begin
  // Log(AMessage);
  if FLog.Active then
    FLog.Add(AMessage);
end;

procedure TBackupProfileManager.InternalBackupOnDebug(ASender: TObject;
  AProcedure, AMessage: string);
begin
  if FDebugBackup then
  begin
    if FLog.Active then
    begin
      FLog.Add('Debug: (' + AProcedure + ') ' + AMessage);
    end;
  end;
end;

procedure TBackupProfileManager.InternalBackupOnSearchProgress(ASender: TObject;
  AMessage: string; AProgress: integer);
begin
  InternalBackupOnItemProgress(ASender, AMessage, AProgress);
end;

procedure TBackupProfileManager.InternalBackupOnBackupFinished(ASender: TObject;
  ASuccess: boolean);
begin

end;

procedure TBackupProfileManager.InternalBackupOnItemProgress(ASender: TObject;
  AMessage: string; AProgress: integer);
begin
  if Assigned(FOnBackupProgress) then
  begin
    FOnBackupProgress(ASender, AMessage, AProgress);
  end;
  if Assigned(FOnRemainingTime) then
  begin
    with FProcessTimer do
    begin
      FOnRemainingTime(ASender, Total, Current, ElapsedTime, EstimatedTime);
    end;
  end;
end;

procedure TBackupProfileManager.InternalBackupOnTotalProgress(ASender: TObject;
  AMessage: string; AProgress: integer);
var
  TotalProgress: integer;
begin
  if Assigned(FOnProfileProgress) then
  begin
    FOnProfileProgress(ASender, AMessage, AProgress);
  end;
  if Assigned(FOnTotalProgress) then
  begin
    TotalProgress := Round(((FBackupProfileQueue.GetCompletedCount * 100) +
      AProgress) / (FBackupProfileQueue.Count * 100) * 100);
    FOnTotalProgress(ASender, IntToStr(TotalProgress) + '%', TotalProgress);
  end;
  if FProcessTimer.Running then
  begin
    FProcessTimer.UpdateProgress(((FBackupProfileQueue.GetCompletedCount) * 100)
      + AProgress);
  end;
  if FPlugins.Active then
  begin
    try
      FPlugins.NotifyBackupProgress(AProgress, AMessage);
    except
      on E: Exception do
      begin
        Log('Plugin Exception: ' + E.Message);
      end;
    end;
  end;
end;

procedure TBackupProfileManager.InternalBackupOnFileList(ASender: TObject;
  AFileList: TStrings);
begin
  if FPlugins.Active then
  begin
    try
      if Assigned(FOnPluginsFileListStart) then
        FOnPluginsFileListStart(Self);
      try
        Debug('InternalBackupOnFileList', 'Sending file list to plugins...');
        FPlugins.NotifyBackupFileList(AFileList);
      except
        on E: Exception do
        begin
          Log('Plugin Exception: ' + E.Message);
        end;
      end;
    finally
      if Assigned(FOnPluginsFileListFinished) then
        FOnPluginsFileListFinished(Self);

    end;
  end;
end;

procedure TBackupProfileManager.InternalBackupOnFileExcludeList
  (ASender: TObject; AFileList: TStrings);
begin

end;

procedure TBackupProfileManager.InternalBackupOnNTBackupStart(ASender: TObject);
begin
  if Assigned(FOnNTBackupStart) then
    FOnNTBackupStart(ASender);
end;

procedure TBackupProfileManager.InternalBackupOnNTBackupFinished
  (ASender: TObject);
begin
  if Assigned(FOnNTBackupFinished) then
    FOnNTBackupFinished(ASender);
end;

function TBackupProfileManager.ExecuteBackup(AProfileName: string;
  AZipFileList: TStrings): TBackupResult;
var
  BackupProfile: TBackupProfile;
  FileIdx: integer;
begin
  BackupProfile := ProfileByName(AProfileName);
  if BackupProfile <> nil then
  begin
    try
      with FLog do
      begin
        BackupProfile.LogFile := FLogFolder + BackupProfile.ProfileName
          + '.log';
        Active := False;
        FileName := BackupProfile.LogFile;
        Active := True;
      end;

      with FPlugins do
      begin
        PluginFolder := Self.PluginFolder;
        ProfileName := AProfileName;
        Active := True;
        if Assigned(FOnPluginsStart) then
          FOnPluginsStart(Self);
        try
          NotifyBackupStart;
        except
          on E: Exception do
          begin
            Log('Plugin Exception: ' + E.Message);
          end;
        end;
      end;

      with FBackup do
      begin
        OnLog := InternalBackupOnLog;
        OnDebug := InternalBackupOnDebug;
        OnTotalProgress := InternalBackupOnTotalProgress;
        OnItemProgress := InternalBackupOnItemProgress;
        OnFileSearchProgress := InternalBackupOnSearchProgress;
        OnNTBackupStart := InternalBackupOnNTBackupStart;
        OnNTBackupFinished := InternalBackupOnNTBackupFinished;
        OnBackupFileList := InternalBackupOnFileList;
        OnBackupFileExclusionList := InternalBackupOnFileExcludeList;
        Debug('ExecuteBackup', 'DllDirectory: ' + FDLLFolder);
        DllDirectory := FDLLFolder;
        Debug('ExecuteBackup', 'ZipType: zSeven (7zip)');
        ZipType := BackupProfile.ZipType;
        SystemState := BackupProfile.SystemState;
        Debug('ExecuteBackup', 'ZipFileName: ' + BackupProfile.ZipFile);
        ZipFileName := BackupProfile.ZipFile;
        Debug('ExecuteBackup', 'VolumeSize: ' +
          IntToStr(BackupProfile.SpanningSize));
        VolumeSize := BackupProfile.SpanningSize;
        case BackupProfile.CompressionLevel of
          clNone:
            ZipCompression := zcNone;
          clLow:
            ZipCompression := zcFast;
          clNormal:
            ZipCompression := zcNormal;
          clHigh:
            ZipCompression := zcHigh;
        else
          ZipCompression := zcMaximum;
        end;
        Debug('ExecuteBackup', 'ZipCompression: ' +
          IntToStr(integer(ZipCompression)));
        ZipDescription := BackupProfile.Description;
        Debug('ExecuteBackup', 'ZipDescription: ' + ZipDescription);
        with Files do
        begin
          Clear;
          for FileIdx := 0 to Pred(BackupProfile.Files.Count) do
          begin
            Add(BackupProfile.Files.Item[FileIdx].Folder,
              BackupProfile.Files.Item[FileIdx].FileMask,
              BackupProfile.Files.Item[FileIdx].Recursive);
          end;
        end;
        with Exclusions do
        begin
          Clear;
          for FileIdx := 0 to Pred(BackupProfile.FileExclusions.Count) do
          begin
            Add(BackupProfile.FileExclusions.Item[FileIdx].Folder,
              BackupProfile.FileExclusions.Item[FileIdx].FileMask,
              BackupProfile.FileExclusions.Item[FileIdx].Recursive);
          end;
        end;
        Result := Backup(AZipFileList);
        Debug('ExecuteBackup', 'ZipFileList: ' + AZipFileList.Text);
        with FPlugins do
        begin
          try
            try
              NotifyBackupEnd(integer(Result), AZipFileList, FLog.FileName);
            except
              on E: Exception do
              begin
                Log('Plugin Exception: ' + E.Message);
              end;
            end;
          finally
            Active := False;
            if Assigned(FOnPluginsFinished) then
              FOnPluginsFinished(Self);
          end;
        end;
        FLog.Active := False;
        if Result = brComplete then
        begin
          BackupProfile.LastBackup := Now;
        end;
      end;
    finally
      FLog.Active := False;
      BackupProfile.SaveProfile;
      if BackupProfile.LogEmailEnabled then
      begin
        if SendBackupLogEmail(BackupProfile) then
        begin
          Debug('ExecuteBackup', 'SendBackupLogEmail: Ok');
        end
        else
        begin
          Debug('ExecuteBackup', 'SendBackupLogEmail: Failed');
        end;
      end;
    end;
  end
  else
  begin
    raise EBackupProfileManagerException.CreateFmt
      ('Unable to load backup profile "%s"', [AProfileName]);
  end;
end;

procedure TBackupProfileManager.CancelBackup;
var
  Cancel: boolean;
begin
  Cancel := True;
  if Assigned(FOnCancelConfirm) then
  begin
    FOnCancelConfirm(Self, Cancel);
  end;
  if Cancel then
  begin
    Log('Backup Cancel Request...');
    FBackup.Cancel;
  end;
end;

function TBackupProfileManager.Backup: boolean;
var
  Cancelled: boolean;
  QueueIdx: integer;
  ZipFileList: TStringList;
begin
  Result := True;
  Cancelled := False;
  FBackupActive := True;
  ZipFileList := TStringList.Create;

  try
    Log('Starting Backup...');
    FProcessTimer.Start(FBackupProfileQueue.Count * 100);
    QueueIdx := 0;
    while (QueueIdx < FBackupProfileQueue.Count) do
    begin
      ZipFileList.Clear;
      Cancelled := not CloseActiveApplications
        (FBackupProfiles.ProfileByName(FBackupProfileQueue.Item[QueueIdx]
        .ProfileName));
      if not Cancelled then
      begin
        Log('Starting Backup: ' + FBackupProfileQueue.Item[QueueIdx]
          .ProfileName);
        if Assigned(FOnStartBackup) then
          FOnStartBackup(Self, FBackupProfiles.ProfileByName
            (FBackupProfileQueue.Item[QueueIdx].ProfileName));
        FBackupProfileQueue.Item[QueueIdx].QueueStatus := qsInProgress;
        try
          case ExecuteBackup(FBackupProfileQueue.Item[QueueIdx].ProfileName,
            ZipFileList) of
            brComplete:
              begin
                if Assigned(FOnFinishBackup) then
                  FOnFinishBackup(Self,
                    FBackupProfiles.ProfileByName(FBackupProfileQueue.Item
                    [QueueIdx].ProfileName));
                Log('Backup Complete: ' + FBackupProfileQueue.Item[QueueIdx]
                  .ProfileName + ', Zip Files: ' + ZipFileList.Text);
                FBackupProfileQueue.Item[QueueIdx].QueueStatus := qsComplete;
              end;
            brFailed:
              begin
                if Assigned(FOnFinishBackup) then
                  FOnFinishBackup(Self,
                    FBackupProfiles.ProfileByName(FBackupProfileQueue.Item
                    [QueueIdx].ProfileName));
                Log('Backup Failed: ' + FBackupProfileQueue.Item[QueueIdx]
                  .ProfileName);
                FBackupProfileQueue.Item[QueueIdx].QueueStatus := qsFailed;
                Result := False;
              end;
            brCancelled:
              begin
                if Assigned(FOnFinishBackup) then
                  FOnFinishBackup(Self,
                    FBackupProfiles.ProfileByName(FBackupProfileQueue.Item
                    [QueueIdx].ProfileName));
                Log('Backup Cancelled: ' + FBackupProfileQueue.Item[QueueIdx]
                  .ProfileName);
                FBackupProfileQueue.Item[QueueIdx].QueueStatus := qsCancelled;
                Result := False;
                Cancelled := True;
                if (QueueIdx <> (FBackupProfileQueue.Count - 1)) then
                begin
                  if Assigned(FOnCancelQueueRequest) then
                  begin
                    FOnCancelQueueRequest(Self, Cancelled);
                  end;
                end;
              end;
          end;
        except
          on E: Exception do
          begin
            if Assigned(FOnFinishBackup) then
              FOnFinishBackup(Self,
                FBackupProfiles.ProfileByName(FBackupProfileQueue.Item[QueueIdx]
                .ProfileName));
            Log('Backup Failed: ' + FBackupProfileQueue.Item[QueueIdx]
              .ProfileName + ', Error: ' + E.Message);
            FBackupProfileQueue.Item[QueueIdx].QueueStatus := qsFailed;
            Result := False;
          end;
        end;
      end
      else
      begin
        Log('Backup Cancelled: ' + FBackupProfileQueue.Item[QueueIdx]
          .ProfileName);
        FBackupProfileQueue.Item[QueueIdx].QueueStatus := qsCancelled;
      end;
      Inc(QueueIdx);
    end;
  finally
    FProcessTimer.Stop;
    FBackupActive := False;
    FreeAndNil(ZipFileList);
  end;
  Log('Backup Complete.');
end;

procedure TBackupProfileManager.QueueAllEnabled;
var
  ProfileIdx: integer;
begin
  FBackupProfileQueue.Clear;
  for ProfileIdx := 0 to Pred(FBackupProfiles.Count) do
  begin
    Debug('QueueAllEnabled', 'Checking profile: ' + FBackupProfiles.Profile
      [ProfileIdx].ProfileName);
    if FBackupProfiles.Profile[ProfileIdx].Enabled then
    begin
      FBackupProfileQueue.Add(FBackupProfiles.Profile[ProfileIdx].ProfileName);
    end;
  end;
end;

procedure TBackupProfileManager.QueueOverdue;
var
  ProfileIdx: integer;
begin
  FBackupProfileQueue.Clear;
  for ProfileIdx := 0 to Pred(FBackupProfiles.Count) do
  begin
    Debug('QueueAllEnabled', 'Checking profile: ' + FBackupProfiles.Profile
      [ProfileIdx].ProfileName);
    if FBackupProfiles.Profile[ProfileIdx].ShowAlerts then
    begin
      if DaysBetween(Now, FBackupProfiles.Profile[ProfileIdx].LastBackup) >=
        FBackupProfiles.Profile[ProfileIdx].AlertDays then
      begin
        FBackupProfileQueue.Add(FBackupProfiles.Profile[ProfileIdx]
          .ProfileName);
      end;
    end;
  end;
end;

procedure TBackupProfileManager.QueueAll;
var
  ProfileIdx: integer;
begin
  FBackupProfileQueue.Clear;
  for ProfileIdx := 0 to Pred(FBackupProfiles.Count) do
  begin
    FBackupProfileQueue.Add(FBackupProfiles.Profile[ProfileIdx].ProfileName);
  end;
end;

procedure TBackupProfileManager.QueueAdd(AProfileName: string);
begin
  FBackupProfileQueue.Add(AProfileName);
end;

procedure TBackupProfileManager.ClearQueue;
begin
  FBackupProfileQueue.Clear;
end;

procedure TBackupProfileManager.CheckBackupAlerts;
var
  AlertCount: integer;
  ProfileIdx: integer;
begin
  AlertCount := 0;
  for ProfileIdx := 0 to Pred(FBackupProfiles.Count) do
  begin
    if FBackupProfiles.Profile[ProfileIdx].IsBackupOverdue then
    begin
      Inc(AlertCount);
      if FBackupProfiles.Profile[ProfileIdx].AlertEmailEnabled then
      begin
        if HoursBetween(Now, FBackupProfiles.Profile[ProfileIdx]
          .AlertEmailLastRun) > 24 then
        begin
          if SendBackupAlertEmail(FBackupProfiles.Profile[ProfileIdx]) then
          begin
            FBackupProfiles.Profile[ProfileIdx].AlertEmailLastRun := Now;
            FBackupProfiles.Profile[ProfileIdx].SaveProfile;
          end;
        end;
      end;
    end;
  end;
  if AlertCount > 0 then
  begin
    if Assigned(FOnBackupAlerts) then
    begin
      FOnBackupAlerts(Self, AlertCount);
    end;
  end;
end;

procedure TBackupProfileManager.SetProfileEmailKeywords(AKeyWordEmail
  : TKeywordEmail; ABackupProfile: TBackupProfile);
var
  Log: TStringList;
begin
  if (ABackupProfile <> nil) then
  begin
    AKeyWordEmail.Clear;
    with AKeyWordEmail.Add do
    begin
      Keyword := '%computername%';
      Value := GetNetworkComputerName;
    end;
    with AKeyWordEmail.Add do
    begin
      Keyword := '%username%';
      Value := GetNetworkUserName;
    end;
    with AKeyWordEmail.Add do
    begin
      Keyword := '%ipaddress%';
      Value := GetNetworkIPAddress;
    end;
    with AKeyWordEmail.Add do
    begin
      Keyword := '%profilename%';
      Value := ABackupProfile.ProfileName;
    end;
    with AKeyWordEmail.Add do
    begin
      Keyword := '%lastbackup%';
      Value := DateToStr(ABackupProfile.LastBackup);
    end;
    with AKeyWordEmail.Add do
    begin
      Keyword := '%daysoverdue%';
      Value := IntToStr(DaysBetween(IncDay(ABackupProfile.LastBackup,
        ABackupProfile.AlertDays), Now));
    end;
    with AKeyWordEmail.Add do
    begin
      Keyword := '%zipfile%';
      Value := ABackupProfile.ZipFile;
    end;
    with AKeyWordEmail.Add do
    begin
      Keyword := '%logfile%';
      Value := ABackupProfile.LogFile;
    end;
    with AKeyWordEmail.Add do
    begin
      Keyword := '%description%';
      Value := ABackupProfile.Description;
    end;
    with AKeyWordEmail.Add do
    begin
      Log := TStringList.Create;
      try
        if FileExists(ABackupProfile.LogFile) then
        begin
          Log.LoadFromFile(ABackupProfile.LogFile);
        end
        else
        begin
          Log.Add(ABackupProfile.LogFile + ' does not exists.');
        end;
        Keyword := '%log%';
        Value := Log.Text;
      finally
        FreeAndNil(Log);
      end;
    end;
  end;
end;

function TBackupProfileManager.CloseActiveApplications(ABackupProfile
  : TBackupProfile): boolean;
begin
  Result := True;
  if Assigned(ABackupProfile) then
  begin
    if Assigned(FOnCloseActiveApplications) then
    begin
      FOnCloseActiveApplications(Self, ABackupProfile.ActivePrograms,
        ABackupProfile.CloseGracefully, Result);
    end;
  end;
end;

function TBackupProfileManager.SendBackupAlertEmail(ABackupProfile
  : TBackupProfile): boolean;
var
  KeywordEmail: TKeywordEmail;
begin
  Result := False;
  if ABackupProfile <> nil then
  begin
    KeywordEmail := TKeywordEmail.Create;
    try
      SetProfileEmailKeywords(KeywordEmail, ABackupProfile);
      with KeywordEmail do
      begin
        Recipients := ABackupProfile.AlertEmailDetails.Recipients;
        SenderAddress := ABackupProfile.AlertEmailDetails.SenderAddress;
        SenderName := ABackupProfile.AlertEmailDetails.SenderName;
        Subject := ABackupProfile.AlertEmailDetails.Subject;
        Body.Text := ABackupProfile.AlertEmailDetails.Body;
        if ABackupProfile.CustomSMTPSettings then
        begin
          SMTPHostname := ABackupProfile.SMTPSettings.SMTPHostname;
          SMTPPort := ABackupProfile.SMTPSettings.SMTPPort;
          SMTPAuthentication := ABackupProfile.SMTPSettings.SMTPAuthentication;
          SMTPSecure := ABackupProfile.SMTPSettings.SMTPSecure;
          SMTPUserName := ABackupProfile.SMTPSettings.Username;
          SMTPPassword := ABackupProfile.SMTPSettings.Password;
        end
        else
        begin
          SMTPHostname := FSMTPSettings.SMTPHostname;
          SMTPPort := FSMTPSettings.SMTPPort;
          SMTPAuthentication := FSMTPSettings.SMTPAuthentication;
          SMTPSecure := FSMTPSettings.SMTPSecure;
          SMTPUserName := FSMTPSettings.Username;
          SMTPPassword := FSMTPSettings.Password;
        end;
        try
          Result := Send;
        except
          on E: Exception do
          begin
            Log(E.Message);
          end;
        end;
      end;
    finally
      FreeAndNil(KeywordEmail);
    end;
  end
  else
  begin
    Result := False;
  end;
end;

function TBackupProfileManager.SendBackupLogEmail(ABackupProfile
  : TBackupProfile): boolean;
var
  KeywordEmail: TKeywordEmail;
begin
  Result := False;
  if ABackupProfile <> nil then
  begin
    KeywordEmail := TKeywordEmail.Create;
    try
      SetProfileEmailKeywords(KeywordEmail, ABackupProfile);
      with KeywordEmail do
      begin
        Recipients := ABackupProfile.LogEmailDetails.Recipients;
        SenderAddress := ABackupProfile.LogEmailDetails.SenderAddress;
        SenderName := ABackupProfile.LogEmailDetails.SenderName;
        Subject := ABackupProfile.LogEmailDetails.Subject;
        Body.Text := ABackupProfile.LogEmailDetails.Body;
        if ABackupProfile.CustomSMTPSettings then
        begin
          SMTPHostname := ABackupProfile.SMTPSettings.SMTPHostname;
          SMTPPort := ABackupProfile.SMTPSettings.SMTPPort;
          SMTPAuthentication := ABackupProfile.SMTPSettings.SMTPAuthentication;
          SMTPSecure := ABackupProfile.SMTPSettings.SMTPSecure;
          SMTPUserName := ABackupProfile.SMTPSettings.Username;
          SMTPPassword := ABackupProfile.SMTPSettings.Password;
        end
        else
        begin
          SMTPHostname := FSMTPSettings.SMTPHostname;
          SMTPPort := FSMTPSettings.SMTPPort;
          SMTPAuthentication := FSMTPSettings.SMTPAuthentication;
          SMTPSecure := FSMTPSettings.SMTPSecure;
          SMTPUserName := FSMTPSettings.Username;
          SMTPPassword := FSMTPSettings.Password;
        end;
        Attachments.Add(ABackupProfile.LogFile);
        try
          Result := Send;
        except
          on E: Exception do
          begin
            Log(E.Message);
          end;
        end;
      end;
    finally
      FreeAndNil(KeywordEmail);
    end;
  end
  else
  begin
    Result := False;
  end;
end;

end.
