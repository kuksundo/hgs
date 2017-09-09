unit PluginsU;

interface

uses
  CommonU,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TProcGetPluginName = function : PChar;
  TProcGetPluginVersion = function : PChar;
  TProcGetPluginDeveloper = function : PChar;
  TProcShowConfig = procedure(AProfileName : PChar);
  TProcBackupBegin = procedure(AProfileName : PChar);
  TProcBackupFileList = function(AProfileName : PChar; AFileList : PChar) : PChar;
  TProcBackupProgress = procedure(AProfileName : PChar; AProgress : Integer; AMessage : PChar);
  TProcBackupEnd = procedure(AProfileName : PChar; AStatus : Integer; AZipFileName, ALogFileName : PChar);

type TPluginItem = class(TCollectionItem)
  private
    FPluginHandle : THandle;
    FFileName : TFileName;
    FPluginName : String;
    FPluginVersion : String;
    FPluginDeveloper : String;
    FProcShowConfig : TProcShowConfig;
    FProcBackupBegin : TProcBackupBegin;
    FProcBackupProgress : TProcBackupProgress;
    FProcBackupEnd : TProcBackupEnd;
    FProcBackupFileList : TProcBackupFileList;
  public
    destructor Destroy; override;
    property ShowConfig : TProcShowConfig read FProcShowConfig write FProcShowConfig;
    property BackupBegin : TProcBackupBegin read FProcBackupBegin write FProcBackupBegin;
    property BackupProgress : TProcBackupProgress read FProcBackupProgress write FProcBackupProgress;
    property BackupEnd : TProcBackupEnd read FProcBackupEnd write FProcBackupEnd;
    property BackupFileList : TProcBackupFileList read FProcBackupFileList write FProcBackupFileList;
  published
    property Filename : TFileName read FFileName write FFileName;
    property PluginName : String read FPluginName write FPluginName;
    property PluginVersion : String read FPluginVersion write FPluginVersion;
    property PluginDeveloper : String read FPluginDeveloper write FPluginDeveloper;
    property PluginHandle : THandle read FPluginHandle write FPluginHandle;
end;

type
  TPlugins = class(TCollection)
  private
    FActive : Boolean;
    FPluginFolder : String;
    FProfileName : String;
    function GetItem(Index: Integer): TPluginItem;
    function GetPluginByName(AName : String) : TPluginItem;
    procedure SetActive(AValue : Boolean);
    procedure GetPluginDetails;
  protected
    procedure BackupStart(APluginName : String; AProfileName : String);
    procedure BackupFileList(APluginName : String; AProfileName : String; AFileList : TStrings);
    procedure BackupEnd(APluginName : String; AProfileName : String; AStatus : Integer; AZipFiles : TStrings; ALogFileName : String);
    procedure BackupProgress(APluginName : String; AProfileName : String; AProgress : Integer; AMessage : String);
  public
    constructor Create; reintroduce;
    function Add: TPluginItem; overload;
    function IndexByName(AName : String) : Integer;
    procedure Config(APluginName : String; AProfileName : String); overload;
    procedure Config(APluginName : String); overload;
    procedure NotifyBackupStart;
    procedure NotifyBackupFileList(AFileList : TStrings);
    procedure NotifyBackupEnd(AStatus : Integer; AZipFiles : TStrings; ALogFileName : String);
    procedure NotifyBackupProgress(AProgress : Integer; AMessage : String);
    procedure Refresh;
    property PluginByName[AName : String] : TPluginItem read GetPluginByName;
    property Item[Index: Integer]: TPluginItem read GetItem;
  published
    property Active : Boolean read FActive write SetActive default False;
    property PluginFolder : String read FPluginFolder write FPluginFolder;
    property ProfileName : String read FProfileName write FProfileName;
end;

implementation



destructor TPluginItem.Destroy;
begin
  if FPluginHandle <> 0 then
    begin
      try
        FreeLibrary(FPluginHandle);
      except
      end;
    end;
  inherited Destroy;
end;

constructor TPlugins.Create;
begin
  inherited Create(TPluginItem);
end;

procedure TPlugins.GetPluginDetails;
var
  FileList : TStringList;
  FileID : Integer;
  DLLHandle: THandle;
  ProcGetPluginName : TProcGetPluginName;
  ProcGetPluginVersion : TProcGetPluginVersion;
  ProcGetPluginDeveloper : TProcGetPluginDeveloper;
begin
  Self.Clear;
  FileList := TStringList.Create;
  QuickFileSearch(FPluginFolder,'*.dll',False,FileList,nil);
  For FileId := 0 to Pred(FileList.Count) do
    begin
      DLLHandle := LoadLibrary(PChar(FileList[FileID]));
      if DLLHandle <> 0 then
        begin
          @ProcGetPluginDeveloper := GetProcAddress(DLLHandle,'GetPluginDeveloper');
          @ProcGetPluginName := GetProcAddress(DLLHandle,'GetPluginName');
          @ProcGetPluginVersion := GetProcAddress(DLLHandle,'GetPluginVersion');
          if Assigned(ProcGetPluginName) and Assigned(ProcGetPluginDeveloper) and Assigned(ProcGetPluginVersion) then
            begin
              with Self.Add do
                begin
                  FileName := FileList[FileID];
                  PluginHandle := DLLHandle;
                  PluginName := String(ProcGetPluginName);
                  PluginVersion := String(ProcGetPluginVersion);
                  PluginDeveloper := String(ProcGetPluginDeveloper);
                  @ShowConfig := GetProcAddress(DLLHandle,'ShowConfig');
                  @BackupBegin := GetProcAddress(DLLHandle,'BackupBegin');
                  @BackupEnd := GetProcAddress(DLLHandle,'BackupEnd');
                  @BackupProgress := GetProcAddress(DLLHandle,'BackupProgress');
                  @BackupFileList := GetProcAddress(DLLHandle,'BackupFileList');
                end;
            end;
        end;
    end;
  FreeAndNil(FileList);
end;

procedure TPlugins.Refresh;
begin
  if FActive then
    begin
      GetPluginDetails;
    end;
end;

procedure TPlugins.NotifyBackupStart;
var
  PluginIdx : Integer;
begin
  for PluginIdx := 0 to Pred(Self.Count) do
    begin
      BackupStart(Self.Item[PluginIdx].PluginName,FProfileName);
    end;
end;

procedure TPlugins.NotifyBackupFileList(AFileList : TStrings);
var
  PluginIdx : Integer;
begin
  for PluginIdx := 0 to Pred(Self.Count) do
    begin
      BackupFileList(Self.Item[PluginIdx].PluginName,FProfileName,AFileList);
    end;
end;

procedure TPlugins.NotifyBackupEnd(AStatus : Integer; AZipFiles : TStrings; ALogFileName : String);
var
  PluginIdx : Integer;
begin
  for PluginIdx := 0 to Pred(Self.Count) do
    begin
      BackupEnd(Self.Item[PluginIdx].PluginName,FProfileName,AStatus,AZipFiles,ALogFileName);
    end;
end;

procedure TPlugins.NotifyBackupProgress(AProgress : Integer; AMessage : String);
var
  PluginIdx : Integer;
begin
  for PluginIdx := 0 to Pred(Self.Count) do
    begin
      BackupProgress(Self.Item[PluginIdx].PluginName,FProfileName,AProgress,AMessage);
    end;
end;

procedure TPlugins.Config(APluginName : String);
begin
  Config(APluginName,FProfileName);
end;

procedure TPlugins.Config(APluginName : String; AProfileName : String);
begin
  if FActive then
    begin
      if IndexByName(APluginName) <> -1 then
        begin
          if Assigned(PluginByName[APluginName].ShowConfig) then
            begin
              PluginByName[APluginName].ShowConfig(PChar(AProfileName));
            end;
        end;
    end;
end;

procedure TPlugins.BackupStart(APluginName : String; AProfileName : String);
begin
  if FActive then
    begin
      if IndexByName(APluginName) <> -1 then
        begin
          if Assigned(PluginByName[APluginName].BackupBegin) then
            begin
              PluginByName[APluginName].BackupBegin(PChar(AProfileName));
            end;
        end;
    end;
end;

procedure TPlugins.BackupFileList(APluginName : String; AProfileName : String; AFileList : TStrings);
var
  FileList : String;
begin
  //FileList := StringReplace(AFileList.Text,#13#10,';',[rfReplaceAll]);
  FileList := AFileList.Text;
  try
  if FActive then
    begin
      if IndexByName(APluginName) <> -1 then
        begin
          if Assigned(PluginByName[APluginName].BackupFileList) then
            begin
              FileList := PluginByName[APluginName].BackupFileList(PChar(AProfileName),PChar(FileList));
            end;
        end;
    end;
  finally
    //AFileList.Text := StringReplace(FileList,';',#13#10,[rfReplaceAll]);
    AFileList.Text := FileList;
  end;
end;

procedure TPlugins.BackupEnd(APluginName : String; AProfileName : String; AStatus : Integer; AZipFiles : TStrings; ALogFileName : String);
begin
  if FActive then
    begin
      if IndexByName(APluginName) <> -1 then
        begin
          if Assigned(PluginByName[APluginName].BackupBegin) then
            begin
              // PluginByName[APluginName].BackupEnd(PChar(AProfileName),AStatus,PChar(StringReplace(AZipFiles.Text,#13#10,';',[rfReplaceAll])),PChar(ALogFileName));
              PluginByName[APluginName].BackupEnd(PChar(AProfileName),AStatus,PChar(AZipFiles.Text),PChar(ALogFileName));
            end;
        end;
    end;
end;

procedure TPlugins.BackupProgress(APluginName : String; AProfileName : String; AProgress : Integer; AMessage : String);
begin
  if FActive then
    begin
      if IndexByName(APluginName) <> -1 then
        begin
          if Assigned(PluginByName[APluginName].BackupProgress) then
            begin
              PluginByName[APluginName].BackupProgress(PChar(AProfileName),AProgress,PChar(AMessage));
            end;
        end;
    end;
end;

procedure TPlugins.SetActive(AValue : Boolean);
begin
  if AValue then
    begin
      if FPluginFolder <> '' then
        begin
          if CheckDirectoryExists(FPluginFolder,True) then
            begin
              GetPluginDetails;
              FActive := True;
            end else
            begin
              raise Exception.CreateFmt('Failed to locate plugin folder "%s"',[FPluginFolder]);
              FActive := False;
            end;
        end else
        begin
          raise Exception.Create('No plugin folder has been specified.');
          FActive := False;
        end;
    end else
    begin
      Self.Clear;
      FActive := False;
    end;
end;

function TPlugins.Add: TPluginItem;
begin
  Result := inherited Add as TPluginItem;
end;

function TPlugins.GetItem(Index: Integer): TPluginItem;
begin
  Result := inherited Items[Index] as TPluginItem;
end;

function TPlugins.IndexByName(AName : String) : Integer;
var
  i : Integer;
  Found : Boolean;
begin
  Found := False;
  Result := -1;
  i := 0;
  while (not Found) and (i <= Pred(Self.Count)) do
    begin
      if UpperCase(Self.Item[i].PluginName) = UpperCase(AName) then
        begin
          Result := i;
          Found := True;
        end;
      inc(i);
    end;
end;

function TPlugins.GetPluginByName(AName : String) : TPluginItem;
var
  Index : Integer;
begin
  Index := IndexByName(AName);
  if Index <> -1 then
    begin
      Result := Self.Item[Index];
    end else
    begin
      raise Exception.CreateFmt('Invalid Plugin Name (%s)',[AName]);
      Result := nil;
    end;
end;

end.
