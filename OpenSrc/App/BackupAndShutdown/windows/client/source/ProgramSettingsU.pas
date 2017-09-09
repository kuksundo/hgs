{$WARN SYMBOL_PLATFORM OFF}

{-----------------------------------------------------------------------------
 Unit Name: ProgramSettingsU
 Author: Tristan Marlow
 Purpose: Simple settings save / load features

 ----------------------------------------------------------------------------
 Copyright (c) 2009 Tristan David Marlow
 Copyright (c) 2009 Little Earth Solutions
 All Rights Reserved

 This product is protected by copyright and distributed under
 licenses restricting copying, distribution and decompilation

 ----------------------------------------------------------------------------

 History: 01/01/2006 - First Release.
          26/10/2011 - Form save / load now save active monitor if maximized.

 Todo:
    XML - Save / Load


-----------------------------------------------------------------------------}
unit ProgramSettingsU;

interface

uses
  Forms, SysUtils, Classes, Windows, ExtCtrls,
  Registry, INIFiles, Variants;

const
  DEFAULT_ENCRYPT_KEY = 'D3FAULT';

type
  EProgramSettingsError = class(Exception);

type
  TSettingsStore = (ssRegistry, ssINIFile);
  TLoadedState   = (lsNone, lsRegistry, lsINIFile);
  TSettingValueType      = (vtUnknown, vtString, vtInteger, vtFloat, vtCurrency,
    vtTime, vtDate, vtDateTime, vtBoolean, vtPassword);

type
  TSettingItem = class(TCollectionItem)
  private
    FKeyName:   string;
    FValue:     variant;
    FDefaultValue: variant;
    FValueType: TSettingValueType;
  published
    property KeyName: string Read FKeyName Write FKeyName;
    property Value: variant Read FValue Write FValue;
    property DefaultValue: variant Read FDefaultValue Write FDefaultValue;
    property ValueType: TSettingValueType Read FValueType Write FValueType;
  end;

type
  TSettings = class(TCollection)
  private
    function GetItem(Index: integer): TSettingItem;
    function GetValueByName(AName: string): variant;
    procedure SetValueByName(AName: string; AValue: variant);
  protected
  public
    function SuperCipher(const S, Key: string): string;
    function Add(AKeyName: string; AValueType: TSettingValueType;
      ADefaultValue: variant): TSettingItem;
    function AddValue(AKeyName: string; AValueType: TSettingValueType;
      AValue: variant): TSettingItem;
    function IndexByName(AName: string): integer;
    function KeyByName(AName: string): TSettingItem;
    function KeyExists(AName: string): boolean;
    property ValueByName[AName: string]: variant
      Read GetValueByName Write SetValueByName;
    property Item[Index: integer]: TSettingItem Read GetItem;
    function AsString: string;
  published
  end;

type
  TProgramSettingsSection = class(TCollectionItem)
  private
    FSectionName: string;
    FSettings:    TSettings;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property SectionName: string Read FSectionName Write FSectionName;
    property Settings: TSettings Read FSettings;
  end;

type
  TProgramSettingsSections = class(TCollection)
  private
    FBaseSectionName: string;
    FBaseSettings:    TSettings;
    function GetItem(Index: integer): TProgramSettingsSection;
  protected
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function Add(ASectionName: string; AKeyName: string;
      AValueType: TSettingValueType; AValue: variant): TProgramSettingsSection;
    function IndexByName(AName: string): integer;
    function SectionByName(AName: string): TProgramSettingsSection;
    property Section[Index: integer]: TProgramSettingsSection Read GetItem;
  published
    property BaseSectionName: string Read FBaseSectionName Write FBaseSectionName;
    property BaseSettings: TSettings Read FBaseSettings;
  end;

type
  TProgramSettingsBaseSection = class(TCollectionItem)
  private
    FProgramSettingsSections: TProgramSettingsSections;
  protected
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property ProgramSettingsSections: TProgramSettingsSections Read FProgramSettingsSections;
  end;

type
  TProgramSettingsBaseSections = class(TCollection)
  private
    function GetItem(Index: integer): TProgramSettingsBaseSection;
  protected
  public
    constructor Create; reintroduce;
    function Add(ABaseSectionName: string): TProgramSettingsBaseSection;
    function IndexByName(AName: string): integer;
    function BaseSectionByName(AName: string): TProgramSettingsBaseSection;
    property BaseSection[Index: integer]: TProgramSettingsBaseSection Read GetItem;
  published
  end;


type
  TOnLoadCustomINIFileSettings = procedure(ASender: TObject;
    AINIFile: TINIFile) of object;
  TOnLoadCustomRegistrySettings = procedure(ASender: TObject;
    ARegistry: TRegistry) of object;
  TOnSaveCustomINIFileSettings = procedure(ASender: TObject;
    AINIFile: TINIFile) of object;
  TOnSaveCustomRegistrySettings = procedure(ASender: TObject;
    ARegistry: TRegistry) of object;
  TOnLoadDefaultCustomINIFileSettings = procedure(ASender: TObject;
    AINIFile: TINIFile) of object;
  TOnLoadDefaultCustomRegistrySettings = procedure(ASender: TObject;
    ARegistry: TRegistry) of object;
  TOnSaveDefaultCustomINIFileSettings = procedure(ASender: TObject;
    AINIFile: TINIFile) of object;
  TOnSaveDefaultCustomRegistrySettings = procedure(ASender: TObject;
    ARegistry: TRegistry) of object;
  TOnBeforeLoadSettings = procedure(ASender: TObject; ASettings: TSettings) of object;
  TOnAfterLoadSettings = procedure(ASender: TObject; ASettings: TSettings) of object;
  TOnBeforeSaveSettings = procedure(ASender: TObject; ASettings: TSettings) of object;
  TOnAfterSaveSettings = procedure(ASender: TObject; ASettings: TSettings) of object;

type
  TProgramSettings = class(TComponent)
  private
    FRootKey:     HKEY;
    FSettingsKey: string;
    FINIFileName: TFileName;
    FDefaultINIFileName: TFileName;
    FEncryptKey:  string;
    //FLoaded:      boolean;
    FSettingsStore: TSettingsStore;
    FLoadedState: TLoadedState;
    FDefaultsSettingsStore: TSettingsStore;
    FSettings:    TSettings;
    FProgramSettingsBaseSections: TProgramSettingsBaseSections;

    FOnLoadCustomINIFileSettings:  TOnLoadCustomINIFileSettings;
    FOnLoadCustomRegistrySettings: TOnLoadCustomRegistrySettings;
    FOnSaveCustomINIFileSettings:  TOnSaveCustomINIFileSettings;
    FOnSaveCustomRegistrySettings: TOnSaveCustomRegistrySettings;
    FOnLoadDefaultCustomINIFileSettings: TOnLoadDefaultCustomINIFileSettings;
    FOnLoadDefaultCustomRegistrySettings: TOnLoadDefaultCustomRegistrySettings;
    FOnSaveDefaultCustomINIFileSettings: TOnSaveDefaultCustomINIFileSettings;
    FOnSaveDefaultCustomRegistrySettings: TOnSaveDefaultCustomRegistrySettings;

    FOnBeforeLoadSettings: TOnBeforeLoadSettings;
    FOnAfterLoadSettings:  TOnAfterLoadSettings;
    FOnBeforeSaveSettings: TOnBeforeSaveSettings;
    FOnAfterSaveSettings:  TOnAfterSaveSettings;

    function GetItem(Index: integer): TSettingItem;
    function GetValueByName(AName: string): variant;
    procedure SetValueByName(AName: string; AValue: variant);
    function GetShortFilename(const FileName: TFileName): TFileName;
    procedure SaveDefaultsRegistry;
    procedure SaveDefaultsINIFile;
    procedure LoadDefaultsRegistry;
    procedure LoadDefaultsINIFile;
    procedure SaveSettingsRegistry;
    procedure SaveSettingsINIFile;
    procedure LoadSettingsRegistry;
    procedure LoadSettingsINIFile;
    procedure SaveFormINIFile(AForm: TForm; AFormClass: string = '');
    procedure LoadFormINIFile(AForm: TForm; AFormClass: string = '');
    procedure SaveFormRegistry(AForm: TForm; AFormClass: string = '');
    procedure LoadFormRegistry(AForm: TForm; AFormClass: string = '');
    procedure SetSettingsKey(AValue: string);
    procedure SetSettingsStore(AValue: TSettingsStore);
    procedure SaveValueINIFile(AName: string);
    procedure SaveValueRegistry(AName: string);
    procedure LoadValueINIFile(AName: string);
    procedure LoadValueRegistry(AName: string);
    function LoadCustomValueINIFile(ASection: string; AKeyName: string;
      AValueType: TSettingValueType; ADefaultValue: variant): variant;
    procedure SaveCustomValueINIFile(ASection: string; AKeyName: string;
      AValueType: TSettingValueType; AValue: variant);
    function LoadCustomValueRegistry(ASection: string; AKeyName: string;
      AValueType: TSettingValueType; ADefaultValue: variant): variant;
    procedure SaveCustomValueRegistry(ASection: string; AKeyName: string;
      AValueType: TSettingValueType; AValue: variant);
    procedure LoadSectionRegistry(AProgramSettingsSections: TProgramSettingsSections);
    procedure SaveSectionRegistry(AProgramSettingsSections: TProgramSettingsSections);
    procedure LoadSectionINIFile(AProgramSettingsSections: TProgramSettingsSections);
    procedure SaveSectionINIFile(AProgramSettingsSections: TProgramSettingsSections);
    procedure ChangeSettingsStore;
    procedure LoadSections;
    procedure SaveSections;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(ASource: TProgramSettings); reintroduce;
    function SuperCipher(const S, Key: string): string;
    procedure LoadDefaults; virtual;
    procedure SaveDefaults; virtual;
    procedure LoadSettings; virtual;
    procedure SaveSettings; virtual;
    procedure SaveValue(AName: string);
    procedure LoadValue(AName: string);
    function GetAutoRun: boolean;
    procedure SetAutoRun(AParameters: string; AEnabled: boolean);
    procedure SaveForm(AForm: TForm; AFormClass: string = '');
    procedure LoadForm(AForm: TForm; AFormClass: string = '');
    function LoadCustomValue(ASection: string; AKeyName: string;
      AValueType: TSettingValueType; ADefaultValue: variant): variant;
    procedure SaveCustomValue(ASection: string; AKeyName: string;
      AValueType: TSettingValueType; AValue: variant);
    function Add(AKeyName: string; AValueType: TSettingValueType;
      ADefaultValue: variant): TSettingItem;
    function IndexByName(AName: string): integer;
    function KeyByName(AName: string): TSettingItem;
    function KeyExists(AName: string): boolean;
    procedure Clear;
    property ValueByName[AName: string]: variant
      Read GetValueByName Write SetValueByName;
    property Setting[Index: integer]: TSettingItem Read GetItem;
    function Count: integer;
    property LoadedState: TLoadedState Read FLoadedState;
    function AddSection(ASectionName: string): TProgramSettingsSections;
    function GetSectionFromName(ASectionName: string): TProgramSettingsSections;
    procedure ClearSections;
    procedure LoadSection(ASectionName: string);
    procedure SaveSection(ASectionName: string);
  published
    property SettingsStore: TSettingsStore Read FSettingsStore Write SetSettingsStore;
    property DefaultSettingsStore: TSettingsStore
      Read FDefaultsSettingsStore Write FDefaultsSettingsStore;
    property RootKey: HKEY Read FRootKey Write FRootKey;
    property SettingsKey: string Read FSettingsKey Write SetSettingsKey;
    property EncryptKey: string Read FEncryptKey Write FEncryptKey;
    property INIFileName: TFileName Read FINIFileName Write FINIFileName;
    property DefaultINIFileName: TFileName Read FDefaultINIFileName
      Write FDefaultINIFileName;
    property OnLoadCustomINIFileSettings: TOnLoadCustomINIFileSettings
      Read FOnLoadCustomINIFileSettings Write FOnLoadCustomINIFileSettings;
    property OnLoadCustomRegistrySettings: TOnLoadCustomRegistrySettings
      Read FOnLoadCustomRegistrySettings Write FOnLoadCustomRegistrySettings;
    property OnSaveCustomINIFileSettings: TOnSaveCustomINIFileSettings
      Read FOnSaveCustomINIFileSettings Write FOnSaveCustomINIFileSettings;
    property OnSaveCustomRegistrySettings: TOnSaveCustomRegistrySettings
      Read FOnSaveCustomRegistrySettings Write FOnSaveCustomRegistrySettings;
    property OnLoadDefaultCustomINIFileSettings: TOnLoadDefaultCustomINIFileSettings
      Read FOnLoadDefaultCustomINIFileSettings Write FOnLoadDefaultCustomINIFileSettings;
    property OnLoadDefaultCustomRegistrySettings: TOnLoadDefaultCustomRegistrySettings
      Read FOnLoadDefaultCustomRegistrySettings Write FOnLoadDefaultCustomRegistrySettings;
    property OnSaveDefaultCustomINIFileSettings: TOnSaveDefaultCustomINIFileSettings
      Read FOnSaveDefaultCustomINIFileSettings Write FOnSaveDefaultCustomINIFileSettings;
    property OnSaveDefaultCustomRegistrySettings: TOnSaveDefaultCustomRegistrySettings
      Read FOnSaveDefaultCustomRegistrySettings Write FOnSaveDefaultCustomRegistrySettings;

    property OnBeforeLoadSettings: TOnBeforeLoadSettings
      Read FOnBeforeLoadSettings Write FOnBeforeLoadSettings;
    property OnAfterLoadSettings: TOnAfterLoadSettings
      Read FOnAfterLoadSettings Write FOnAfterLoadSettings;
    property OnBeforeSaveSettings: TOnBeforeSaveSettings
      Read FOnBeforeSaveSettings Write FOnBeforeSaveSettings;
    property OnAfterSaveSettings: TOnAfterSaveSettings
      Read FOnAfterSaveSettings Write FOnAfterSaveSettings;
  end;

implementation


// TSettings

{function TSettings.Add: TSettingItem;
begin
  Result := inherited Add as TSettingItem;
end;}

function TSettings.Add(AKeyName: string; AValueType: TSettingValueType;
  ADefaultValue: variant): TSettingItem;
begin
  if KeyExists(AKeyName) then
  begin
    Result := KeyByName(AKeyName);
  end
  else
  begin
    Result := inherited Add as TSettingItem;
  end;
  Result.KeyName      := AKeyName;
  Result.ValueType    := AValueType;
  Result.DefaultValue := ADefaultValue;
end;

function TSettings.AddValue(AKeyName: string; AValueType: TSettingValueType;
  AValue: variant): TSettingItem;
begin
  if KeyExists(AKeyName) then
  begin
    Result := KeyByName(AKeyName);
  end
  else
  begin
    Result := inherited Add as TSettingItem;
  end;
  Result.KeyName := AKeyName;
  Result.ValueType := AValueType;
  Result.DefaultValue := AValue;
  Result.Value := AValue;
end;

function TSettings.IndexByName(AName: string): integer;
var
  i:     integer;
  Found: boolean;
begin
  Found  := False;
  Result := -1;
  i      := 0;
  while (not Found) and (i <= Pred(Self.Count)) do
  begin
    if UpperCase(Self.Item[i].KeyName) = UpperCase(AName) then
    begin
      Result := i;
      Found  := True;
    end;
    Inc(i);
  end;
end;

function TSettings.KeyByName(AName: string): TSettingItem;
var
  Index: integer;
begin
  Index := IndexByName(AName);
  if Index <> -1 then
  begin
    Result := Self.Item[Index];
  end
  else
  begin
    raise EProgramSettingsError.CreateFmt('Invalid Key Name (%s)', [AName]);
    Result := nil;
  end;
end;

function TSettings.KeyExists(AName: string): boolean;
begin
  Result := IndexByName(AName) <> -1;
end;

function TSettings.AsString: string;
var
  Idx: integer;
begin
  Result := '';
  for Idx := 0 to Pred(Self.Count) do
  begin
    Result := Result + Item[Idx].KeyName + ': ' +
      VarToStrDef(Item[Idx].Value, '<cannot convert to string>');
  end;
end;

function TSettings.GetValueByName(AName: string): variant;
begin
  Result := KeyByName(AName).Value;
end;

procedure TSettings.SetValueByName(AName: string; AValue: variant);
begin
  KeyByName(AName).Value := AValue;
end;

function TSettings.SuperCipher(const S, Key: string): string;
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

function TSettings.GetItem(Index: integer): TSettingItem;
begin
  Result := inherited Items[Index] as TSettingItem;
end;


// TProgramSettingsSection

constructor TProgramSettingsSection.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FSettings := TSettings.Create(TSettingItem);
end;

destructor TProgramSettingsSection.Destroy;
begin
  FreeAndNil(FSettings);
  inherited Destroy;
end;

// TProgramSettingsSections

constructor TProgramSettingsSections.Create;
begin
  inherited Create(TProgramSettingsSection);
  FBaseSettings := TSettings.Create(TSettingItem);
end;

destructor TProgramSettingsSections.Destroy;
begin
  FreeAndNil(FBaseSettings);
  inherited Destroy;
end;

function TProgramSettingsSections.GetItem(Index: integer): TProgramSettingsSection;
begin
  Result := inherited Items[Index] as TProgramSettingsSection;
end;

function TProgramSettingsSections.Add(ASectionName: string; AKeyName: string;
  AValueType: TSettingValueType; AValue: variant): TProgramSettingsSection;
begin
  Result := SectionByName(ASectionName);
  if Result = nil then
  begin
    Result := inherited Add as TProgramSettingsSection;
  end;
  Result.SectionName := ASectionName;
  Result.Settings.AddValue(AKeyName, AValueType, AValue);
end;

function TProgramSettingsSections.IndexByName(AName: string): integer;
var
  i:     integer;
  Found: boolean;
begin
  Found  := False;
  Result := -1;
  i      := 0;
  while (not Found) and (i <= Pred(Self.Count)) do
  begin
    if UpperCase(Self.Section[i].SectionName) = UpperCase(AName) then
    begin
      Result := i;
      Found  := True;
    end;
    Inc(i);
  end;
end;


function TProgramSettingsSections.SectionByName(AName: string): TProgramSettingsSection;
var
  Index: integer;
begin
  Index := IndexByName(AName);
  if Index <> -1 then
  begin
    Result := Self.Section[Index];
  end
  else
  begin
    //raise EProgramSettingsError.CreateFmt('Invalid Section Name (%s)', [AName]);
    Result := nil;
  end;
end;


// TProgramSettingsBaseSection

constructor TProgramSettingsBaseSection.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FProgramSettingsSections := TProgramSettingsSections.Create;
end;

destructor TProgramSettingsBaseSection.Destroy;
begin
  FreeAndNil(FProgramSettingsSections);
  inherited Destroy;
end;

// TProgramSettingsBaseSections

constructor TProgramSettingsBaseSections.Create;
begin
  inherited Create(TProgramSettingsBaseSection);
end;

function TProgramSettingsBaseSections.GetItem(Index: integer): TProgramSettingsBaseSection;
begin
  Result := inherited Items[Index] as TProgramSettingsBaseSection;
end;

function TProgramSettingsBaseSections.Add(ABaseSectionName: string):
TProgramSettingsBaseSection;
begin
  Result := BaseSectionByName(ABaseSectionName);
  if Result = nil then
  begin
    Result := inherited Add as TProgramSettingsBaseSection;
  end;
  Result.ProgramSettingsSections.BaseSectionName := ABaseSectionName;
end;

function TProgramSettingsBaseSections.IndexByName(AName: string): integer;
var
  i:     integer;
  Found: boolean;
begin
  Found  := False;
  Result := -1;
  i      := 0;
  while (not Found) and (i <= Pred(Self.Count)) do
  begin
    if UpperCase(Self.BaseSection[i].ProgramSettingsSections.BaseSectionName) =
      UpperCase(AName) then
    begin
      Result := i;
      Found  := True;
    end;
    Inc(i);
  end;
end;

function TProgramSettingsBaseSections.BaseSectionByName(AName: string):
TProgramSettingsBaseSection;
var
  Index: integer;
begin
  Index := IndexByName(AName);
  if Index <> -1 then
  begin
    Result := Self.BaseSection[Index];
  end
  else
  begin
    //raise EProgramSettingsError.CreateFmt('Invalid Section Name (%s)', [AName]);
    Result := nil;
  end;
end;

// TProgramSettings

function TProgramSettings.GetShortFilename(const FileName: TFileName): TFileName;
var
  buffer: array[0..MAX_PATH - 1] of char;
begin
  SetString(Result, buffer, GetShortPathName(PChar(FileName), buffer, MAX_PATH - 1));
end;

constructor TProgramSettings.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLoadedState := lsNone;
  FSettings    := TSettings.Create(TSettingItem);
  FProgramSettingsBaseSections := TProgramSettingsBaseSections.Create;
  //FLoaded      := False;
  FEncryptKey  := DEFAULT_ENCRYPT_KEY;
  FRootKey     := HKEY_CURRENT_USER;
  FSettingsStore := ssINIFile;
  FDefaultsSettingsStore := ssINIFile;
  FINIFileName := ChangeFileExt(ParamStr(0), '.ini');
end;

destructor TProgramSettings.Destroy;
begin
  FreeAndNil(FSettings);
  FreeAndNil(FProgramSettingsBaseSections);
  inherited Destroy;
end;

procedure TProgramSettings.SetSettingsKey(AValue: string);
begin
  if Trim(AValue) <> '' then
  begin
    FSettingsKey := IncludeTrailingBackslash(AValue);
  end
  else
  begin
    FSettingsKey := '';
  end;
end;

procedure TProgramSettings.ChangeSettingsStore;
begin

    try
      case FSettingsStore of
        ssRegistry:
        begin
          SaveSettingsINIFile;
        end;
        ssINIFile:
        begin
          SaveSettingsRegistry;
        end;
      end;
    except
      on E: Exception do
      begin
        raise EProgramSettingsError.Create('Failed to save settings on setting store change, Error: ' + E.Message);
      end;
    end;

    case SettingsStore of
      ssRegistry: FSettingsStore := ssINIFile;
      ssINIFile: FSettingsStore  := ssRegistry;
    end;

    try
      case FSettingsStore of
        ssRegistry: LoadSettingsRegistry;
        ssINIFile: LoadSettingsINIFile;
      end;
    except
      on E: Exception do
      begin
        raise EProgramSettingsError.Create('Failed to save settings on setting store change, Error: ' + E.Message);
      end;
    end;
end;

procedure TProgramSettings.SetSettingsStore(AValue: TSettingsStore);
begin
  if AValue <> FSettingsStore then
  begin

    // Check and change Default settings store.
    if FSettingsStore = FDefaultsSettingsStore then
    begin
      FDefaultsSettingsStore := AValue;
    end;

    case FLoadedState of
      lsNone:
      begin
        FSettingsStore := AValue;
      end;
      lsRegistry:
      begin
        if AValue <> ssRegistry then
        begin
          ChangeSettingsStore;
        end;
      end;
      lsINIFile:
      begin
        if AValue <> ssINIFile then
        begin
          ChangeSettingsStore;
        end;
      end;
    end;
  end;
end;

procedure TProgramSettings.Assign(ASource: TProgramSettings);
begin
  if Assigned(ASource) then
  begin
    with Self do
    begin
      SettingsStore := ASource.SettingsStore;
      DefaultSettingsStore := ASource.DefaultSettingsStore;
      RootKey     := ASource.RootKey;
      SettingsKey := ASource.SettingsKey;
      EncryptKey  := ASource.EncryptKey;
      INIFileName := ASource.INIFileName;
      DefaultINIFileName := ASource.DefaultINIFileName;
    end;
  end;
end;

function TProgramSettings.GetItem(Index: integer): TSettingItem;
begin
  Result := FSettings.GetItem(Index);
end;


function TProgramSettings.GetValueByName(AName: string): variant;
begin
  Result := FSettings.GetValueByName(AName);
end;

procedure TProgramSettings.SetValueByName(AName: string; AValue: variant);
begin
  FSettings.SetValueByName(AName, AValue);
end;

function TProgramSettings.Add(AKeyName: string; AValueType: TSettingValueType;
  ADefaultValue: variant): TSettingItem;
begin
  Result := FSettings.Add(AKeyName, AValueType, ADefaultValue);
end;

function TProgramSettings.IndexByName(AName: string): integer;
begin
  Result := FSettings.IndexByName(AName);
end;

function TProgramSettings.KeyByName(AName: string): TSettingItem;
begin
  Result := FSettings.KeyByName(AName);
end;

function TProgramSettings.KeyExists(AName: string): boolean;
begin
  Result := FSettings.KeyExists(AName);
end;

procedure TProgramSettings.Clear;
begin
  FSettings.Clear;
end;

function TProgramSettings.Count: integer;
begin
  Result := FSettings.Count;
end;

function TProgramSettings.SuperCipher(const S, Key: string): string;
begin
  Result := FSettings.SuperCipher(S, Key);
end;

procedure TProgramSettings.SetAutoRun(AParameters: string; AEnabled: boolean);
var
  Registry: TRegistry;
begin
  if Application.Title <> '' then
  begin
    Registry := TRegistry.Create;
    if AEnabled = False then // Remove startup entry
    begin
      with Registry do
      begin
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) then
        begin
          if ValueExists(Application.Title) then
            DeleteValue(Application.Title);
          CloseKey;
        end;
      end;
    end
    else
    begin
      with Registry do
      begin
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) then
        begin
          WriteString(Application.Title, GetShortFilename(ParamStr(0)) +
            ' ' + AParameters);
          CloseKey;
        end;
      end;
    end;
    FreeAndNil(Registry);
  end;
end;

function TProgramSettings.GetAutoRun: boolean;
var
  Registry: TRegistry;
begin
  Result := False;
  if Application.Title <> '' then
  begin
    Registry := TRegistry.Create;
    with Registry do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) then
      begin
        Result := ValueExists(Application.Title);
        CloseKey;
      end;
    end;
    FreeAndNil(Registry);
  end;
end;


procedure TProgramSettings.SaveValueINIFile(AName: string);
var
  INIFile:     TINIFile;
  SettingItem: TSettingItem;
begin
  SettingItem := KeyByName(AName);
  if SettingItem <> nil then
  begin
    if FEncryptKey = '' then
      FEncryptKey := DEFAULT_ENCRYPT_KEY;
    INIFile := TIniFile.Create(FINIFileName);
    try
      with INIFile do
      begin
        case SettingItem.ValueType of
          vtString, vtUnknown:
          begin
            WriteString('Settings', SettingItem.KeyName, SettingItem.Value);
          end;
          vtPassword: WriteString('Settings', SettingItem.KeyName,
              SuperCipher(SettingItem.Value, FEncryptKey));
          vtInteger: WriteInteger('Settings', SettingItem.KeyName,
              SettingItem.Value);
          vtFloat, vtCurrency: WriteFloat(
              'Settings', SettingItem.KeyName, SettingItem.Value);
          vtTime: WriteTime('Settings', SettingItem.KeyName, SettingItem.Value);
          vtDate: WriteDate('Settings', SettingItem.KeyName, SettingItem.Value);
          vtDateTime: WriteDateTime(
              'Settings', SettingItem.KeyName, SettingItem.Value);
          vtBoolean: WriteBool('Settings', SettingItem.KeyName,
              SettingItem.Value);
        end;
      end;
    finally
      FreeAndNil(INIFile);
    end;
  end;
end;

procedure TProgramSettings.SaveValueRegistry(AName: string);
var
  Registry:    TRegistry;
  SettingItem: TSettingItem;
begin
  SettingItem := KeyByName(AName);
  if SettingItem <> nil then
  begin
    if FEncryptKey = '' then
      FEncryptKey := DEFAULT_ENCRYPT_KEY;
    Registry := TRegistry.Create;
    try
      with Registry do
      begin
        RootKey := FRootKey;
        if OpenKey(FSettingsKey, True) then
        begin
          case SettingItem.ValueType of
            vtString, vtUnknown:
            begin
              WriteString(SettingItem.KeyName, SettingItem.Value);
            end;
            vtPassword: WriteString(SettingItem.KeyName,
                SuperCipher(SettingItem.Value, FEncryptKey));
            vtInteger: WriteInteger(SettingItem.KeyName, SettingItem.Value);
            vtFloat, vtCurrency: WriteFloat(SettingItem.KeyName, SettingItem.Value);
            vtTime: WriteTime(SettingItem.KeyName, SettingItem.Value);
            vtDate: WriteDate(SettingItem.KeyName, SettingItem.Value);
            vtDateTime: WriteDateTime(SettingItem.KeyName, SettingItem.Value);
            vtBoolean: WriteBool(SettingItem.KeyName, SettingItem.Value);
          end;
        end;
      end;
    finally
      FreeAndNil(Registry);
    end;
  end;
end;

procedure TProgramSettings.LoadValueINIFile(AName: string);
var
  INIFile:     TINIFile;
  SettingItem: TSettingItem;
begin
  SettingItem := KeyByName(AName);
  if SettingItem <> nil then
  begin
    if FEncryptKey = '' then
      FEncryptKey := DEFAULT_ENCRYPT_KEY;
    INIFile := TIniFile.Create(FINIFileName);
    try
      with INIFile do
      begin
        case SettingItem.ValueType of
          vtString, vtUnknown:
          begin
            SettingItem.Value :=
              ReadString('Settings', SettingItem.KeyName, SettingItem.DefaultValue);
          end;
          vtPassword: SuperCipher(
              ReadString('Settings', SettingItem.KeyName, SettingItem.DefaultValue),
              FEncryptKey);
          vtInteger: SettingItem.Value  :=
              ReadInteger('Settings', SettingItem.KeyName, SettingItem.DefaultValue);
          vtFloat, vtCurrency: SettingItem.Value :=
              ReadFloat('Settings', SettingItem.KeyName, SettingItem.DefaultValue);
          vtTime: SettingItem.Value     :=
              ReadTime('Settings', SettingItem.KeyName, SettingItem.DefaultValue);
          vtDate: SettingItem.Value     :=
              ReadDate('Settings', SettingItem.KeyName, SettingItem.DefaultValue);
          vtDateTime: SettingItem.Value :=
              ReadDateTime('Settings', SettingItem.KeyName, SettingItem.DefaultValue);
          vtBoolean: SettingItem.Value  :=
              ReadBool('Settings', SettingItem.KeyName, SettingItem.DefaultValue);
        end;
      end;
    finally
      FreeAndNil(INIFile);
    end;
  end;
end;

procedure TProgramSettings.LoadValueRegistry(AName: string);
var
  Registry:    TRegistry;
  SettingItem: TSettingItem;
begin
  SettingItem := KeyByName(AName);
  if SettingItem <> nil then
  begin
    if FEncryptKey = '' then
      FEncryptKey := DEFAULT_ENCRYPT_KEY;
    Registry := TRegistry.Create;
    try
      with Registry do
      begin
        RootKey := FRootKey;
        if OpenKeyReadOnly(FSettingsKey) then
        begin
          if ValueExists(SettingItem.KeyName) then
          begin
            case SettingItem.ValueType of
              vtString, vtUnknown:
              begin
                SettingItem.Value :=
                  ReadString(SettingItem.KeyName);
              end;
              vtPassword: SuperCipher(
                  ReadString(SettingItem.KeyName),
                  FEncryptKey);
              vtInteger: SettingItem.Value  :=
                  ReadInteger(SettingItem.KeyName);
              vtFloat, vtCurrency: SettingItem.Value :=
                  ReadFloat(SettingItem.KeyName);
              vtTime: SettingItem.Value     := ReadTime(SettingItem.KeyName);
              vtDate: SettingItem.Value     := ReadDate(SettingItem.KeyName);
              vtDateTime: SettingItem.Value := ReadDateTime(SettingItem.KeyName);
              vtBoolean: SettingItem.Value  := ReadBool(SettingItem.KeyName);
            end;
          end;
        end;
      end;
    finally
      FreeAndNil(Registry);
    end;
  end;
end;


procedure TProgramSettings.LoadValue(AName: string);
begin
  case FSettingsStore of
    ssRegistry: LoadValueRegistry(AName);
    ssINIFile: LoadValueINIFile(AName);
  end;
end;

procedure TProgramSettings.SaveValue(AName: string);
begin
  case FSettingsStore of
    ssRegistry: SaveValueRegistry(AName);
    ssINIFile: SaveValueINIFile(AName);
  end;
end;

procedure TProgramSettings.LoadDefaults;
begin
  case FDefaultsSettingsStore of
    ssRegistry: LoadDefaultsRegistry;
    ssINIFile: LoadDefaultsINIFile;
  end;
end;

procedure TProgramSettings.LoadDefaultsINIFile;
var
  INIFile: TINIFile;
  i: integer;
  DatabaseList: TStringList;
begin
  if FEncryptKey = '' then
    FEncryptKey := DEFAULT_ENCRYPT_KEY;
  INIFile := TIniFile.Create(FDefaultINIFileName);
  DatabaseList := TStringList.Create;
  try
    with INIFile do
    begin
      for i := 0 to Pred(FSettings.Count) do
      begin
        case FSettings.Item[i].ValueType of
          vtString, vtUnknown:
          begin
            FSettings.Item[i].DefaultValue :=
              ReadString('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          end;
          vtPassword: FSettings.Item[i].DefaultValue :=
              SuperCipher(ReadString('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue), FEncryptKey);
          vtInteger: FSettings.Item[i].DefaultValue  :=
              ReadInteger('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtFloat, vtCurrency: FSettings.Item[i].DefaultValue :=
              ReadFloat('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtTime: FSettings.Item[i].DefaultValue     :=
              ReadTime('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtDate: FSettings.Item[i].DefaultValue     :=
              ReadDate('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtDateTime: FSettings.Item[i].DefaultValue :=
              ReadDateTime('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtBoolean: FSettings.Item[i].DefaultValue  :=
              ReadBool('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
        end;
      end;
      if Assigned(FOnLoadDefaultCustomINIFileSettings) then
        FOnLoadDefaultCustomINIFileSettings(Self, INIFile);
    end;
  finally
    FreeAndNil(INIFile);
    FreeAndNil(DatabaseList);
  end;
end;

procedure TProgramSettings.LoadDefaultsRegistry;
var
  Registry: TRegistry;
  i: integer;
  DefaultKey: string;
begin
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      RootKey := HKEY_USERS;
      if FSettingsKey[1] <> '\' then
      begin
        DefaultKey := '.Default\' + FSettingsKey;
      end
      else
      begin
        DefaultKey := '.Default' + FSettingsKey;
      end;
      if OpenKey(DefaultKey, True) then
      begin
        for i := 0 to Pred(FSettings.Count) do
        begin
          if ValueExists(FSettings.Item[i].KeyName) then
          begin
            case FSettings.Item[i].ValueType of
              vtUnknown, vtString:
              begin
                FSettings.Item[i].DefaultValue :=
                  Registry.ReadString(FSettings.Item[i].KeyName);
              end;
              vtPassword: FSettings.Item[i].DefaultValue :=
                  SuperCipher(Registry.ReadString(FSettings.Item[i].KeyName),
                  FEncryptKey);
              vtInteger: FSettings.Item[i].DefaultValue  :=
                  Registry.ReadInteger(FSettings.Item[i].KeyName);
              vtCurrency: FSettings.Item[i].DefaultValue :=
                  Registry.ReadCurrency(FSettings.Item[i].KeyName);
              vtFloat: FSettings.Item[i].DefaultValue    :=
                  Registry.ReadFloat(FSettings.Item[i].KeyName);
              vtTime: FSettings.Item[i].DefaultValue     :=
                  Registry.ReadTime(FSettings.Item[i].KeyName);
              vtDate: FSettings.Item[i].DefaultValue     :=
                  Registry.ReadDate(FSettings.Item[i].KeyName);
              vtDateTime: FSettings.Item[i].DefaultValue :=
                  Registry.ReadDateTime(FSettings.Item[i].KeyName);
              vtBoolean: FSettings.Item[i].DefaultValue  :=
                  Registry.ReadBool(FSettings.Item[i].KeyName);
            end;
          end
          else
          begin
            FSettings.Item[i].Value := FSettings.Item[i].DefaultValue;
          end;
        end;
        CloseKey;
      end;
      if Assigned(FOnLoadDefaultCustomRegistrySettings) then
        FOnLoadDefaultCustomRegistrySettings(Self, Registry);
    end;
  finally
    FreeAndNil(Registry);
  end;
end;

procedure TProgramSettings.SaveDefaults;
begin
  case FDefaultsSettingsStore of
    ssRegistry: SaveDefaultsRegistry;
    ssINIFile: SaveDefaultsINIFile;
  end;
end;

procedure TProgramSettings.SaveDefaultsINIFile;
var
  INIFile: TINIFile;
  i: integer;
begin
  if FEncryptKey = '' then
    FEncryptKey := DEFAULT_ENCRYPT_KEY;
  INIFile := TIniFile.Create(FDefaultINIFileName);
  try
    with INIFile do
    begin
      for i := 0 to Pred(FSettings.Count) do
      begin
        case FSettings.Item[i].ValueType of
          vtString, vtUnknown:
          begin
            WriteString('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          end;
          vtPassword: WriteString('.Defaults', FSettings.Item[i].KeyName,
              SuperCipher(FSettings.Item[i].DefaultValue, FEncryptKey));
          vtInteger: WriteInteger('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtFloat, vtCurrency: WriteFloat(
              '.Defaults', FSettings.Item[i].KeyName, FSettings.Item[i].DefaultValue);
          vtTime: WriteTime('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtDate: WriteDate('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtDateTime: WriteDateTime('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtBoolean: WriteBool('.Defaults', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
        end;
      end;
      if Assigned(FOnSaveDefaultCustomINIFileSettings) then
        FOnSaveDefaultCustomINIFileSettings(Self, INIFile);
    end;
  finally
    FreeAndNil(INIFile);
  end;
end;

procedure TProgramSettings.SaveDefaultsRegistry;
var
  Registry: TRegistry;
  i: integer;
  DefaultKey: string;
begin
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      RootKey := HKEY_USERS;
      if FSettingsKey[1] <> '\' then
      begin
        DefaultKey := '.Default\' + FSettingsKey;
      end
      else
      begin
        DefaultKey := '.Default' + FSettingsKey;
      end;
      if OpenKey(DefaultKey, True) then
      begin
        for i := 0 to Pred(FSettings.Count) do
        begin
          case FSettings.Item[i].ValueType of
            vtUnknown, vtString:
            begin
              Registry.WriteString(
                FSettings.Item[i].KeyName, FSettings.Item[i].DefaultValue);
            end;
            vtPassword: Registry.WriteString(
                FSettings.Item[i].KeyName,
                SuperCipher(FSettings.Item[i].DefaultValue, FEncryptKey));
            vtInteger: Registry.WriteInteger(FSettings.Item[i].KeyName,
                FSettings.Item[i].DefaultValue);
            vtCurrency: Registry.WriteCurrency(FSettings.Item[i].KeyName,
                FSettings.Item[i].DefaultValue);
            vtFloat: Registry.WriteFloat(FSettings.Item[i].KeyName,
                FSettings.Item[i].DefaultValue);
            vtTime: Registry.WriteTime(FSettings.Item[i].KeyName,
                FSettings.Item[i].DefaultValue);
            vtDate: Registry.WriteDate(FSettings.Item[i].KeyName,
                FSettings.Item[i].DefaultValue);
            vtDateTime: Registry.WriteDateTime(FSettings.Item[i].KeyName,
                FSettings.Item[i].DefaultValue);
            vtBoolean: Registry.WriteBool(FSettings.Item[i].KeyName,
                FSettings.Item[i].DefaultValue);
          end;
        end;
        CloseKey;
      end;
      if Assigned(FOnSaveDefaultCustomRegistrySettings) then
        FOnSaveDefaultCustomRegistrySettings(Self, Registry);
    end;
  finally
    FreeAndNil(Registry);
  end;

end;

procedure TProgramSettings.LoadSettings;
begin
  FLoadedState := lsNone;
  if Assigned(FOnBeforeLoadSettings) then
    FOnBeforeLoadSettings(Self, FSettings);
  try
    case FSettingsStore of
      ssRegistry:
      begin
        LoadSettingsRegistry;
        FLoadedState := lsRegistry;
      end;
      ssINIFile:
      begin
        LoadSettingsINIFile;
        FLoadedState := lsINIFile;
      end;
    end;
    LoadSections;
  finally
    if Assigned(FOnAfterLoadSettings) then
      FOnAfterLoadSettings(Self, FSettings);
  end;
end;

procedure TProgramSettings.LoadSettingsINIFile;
var
  INIFile: TINIFile;
  i: integer;
begin
  if FEncryptKey = '' then
    FEncryptKey := DEFAULT_ENCRYPT_KEY;
  INIFile := TIniFile.Create(FINIFileName);
  try
    with INIFile do
    begin
      for i := 0 to Pred(FSettings.Count) do
      begin
        case FSettings.Item[i].ValueType of
          vtString, vtUnknown:
          begin
            FSettings.Item[i].Value :=
              ReadString('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          end;
          vtPassword: FSettings.Item[i].Value :=
              SuperCipher(ReadString('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue), FEncryptKey);
          vtInteger: FSettings.Item[i].Value  :=
              ReadInteger('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtFloat, vtCurrency: FSettings.Item[i].Value :=
              ReadFloat('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtTime: FSettings.Item[i].Value     :=
              ReadTime('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtDate: FSettings.Item[i].Value     :=
              ReadDate('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtDateTime: FSettings.Item[i].Value :=
              ReadDateTime('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
          vtBoolean: FSettings.Item[i].Value  :=
              ReadBool('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].DefaultValue);
        end;
      end;
      if Assigned(FOnLoadCustomINIFileSettings) then
        FOnLoadCustomINIFileSettings(Self, INIFile);
    end;
  finally
    FreeAndNil(INIFile);
  end;
  //FLoaded := True;
end;

procedure TProgramSettings.LoadSettingsRegistry;
var
  Registry: TRegistry;
  i: integer;
begin
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      RootKey := FRootKey;
      if OpenKeyReadOnly(FSettingsKey) then
      begin
        for i := 0 to Pred(FSettings.Count) do
        begin
          if ValueExists(FSettings.Item[i].KeyName) then
          begin
            case FSettings.Item[i].ValueType of
              vtUnknown, vtString:
              begin
                FSettings.Item[i].Value :=
                  Registry.ReadString(FSettings.Item[i].KeyName);
              end;
              vtPassword: FSettings.Item[i].Value :=
                  SuperCipher(Registry.ReadString(FSettings.Item[i].KeyName),
                  FEncryptKey);
              vtInteger: FSettings.Item[i].Value  :=
                  Registry.ReadInteger(FSettings.Item[i].KeyName);
              vtCurrency: FSettings.Item[i].Value :=
                  Registry.ReadCurrency(FSettings.Item[i].KeyName);
              vtFloat: FSettings.Item[i].Value    :=
                  Registry.ReadFloat(FSettings.Item[i].KeyName);
              vtTime: FSettings.Item[i].Value     :=
                  Registry.ReadTime(FSettings.Item[i].KeyName);
              vtDate: FSettings.Item[i].Value     :=
                  Registry.ReadDate(FSettings.Item[i].KeyName);
              vtDateTime: FSettings.Item[i].Value :=
                  Registry.ReadDateTime(FSettings.Item[i].KeyName);
              vtBoolean: FSettings.Item[i].Value  :=
                  Registry.ReadBool(FSettings.Item[i].KeyName);
            end;
          end
          else
          begin
            FSettings.Item[i].Value := FSettings.Item[i].DefaultValue;
          end;
        end;
        CloseKey;
      end
      else
      begin
        // Key does not exists load default.
        for i := 0 to Pred(FSettings.Count) do
        begin
          FSettings.Item[i].Value := FSettings.Item[i].DefaultValue;
        end;
      end;
      if Assigned(FOnLoadCustomRegistrySettings) then
      begin
        FOnLoadCustomRegistrySettings(Self, Registry);
      end;
    end;
  finally
    FreeAndNil(Registry);
  end;
  //FLoaded := True;
end;

procedure TProgramSettings.SaveSettings;
begin
  if Assigned(FOnBeforeSaveSettings) then
    FOnBeforeSaveSettings(Self, FSettings);
  try
    case FSettingsStore of
      ssRegistry:
      begin
        SaveSettingsRegistry;
      end;
      ssINIFile:
      begin
        SaveSettingsINIFile;
      end;
    end;
    SaveSections;
  finally
    if Assigned(FOnAfterSaveSettings) then
      FOnAfterSaveSettings(Self, FSettings);
  end;
end;

procedure TProgramSettings.SaveSettingsINIFile;
var
  INIFile: TINIFile;
  i: integer;
begin
  if FEncryptKey = '' then
    FEncryptKey := DEFAULT_ENCRYPT_KEY;
  INIFile := TIniFile.Create(FINIFileName);
  try
    with INIFile do
    begin
      for i := 0 to Pred(FSettings.Count) do
      begin
        case FSettings.Item[i].ValueType of
          vtString, vtUnknown:
          begin
            WriteString('Settings', FSettings.Item[i].KeyName, FSettings.Item[i].Value);
          end;
          vtPassword: WriteString('Settings', FSettings.Item[i].KeyName,
              SuperCipher(FSettings.Item[i].Value, FEncryptKey));
          vtInteger: WriteInteger('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].Value);
          vtFloat, vtCurrency: WriteFloat(
              'Settings', FSettings.Item[i].KeyName, FSettings.Item[i].Value);
          vtTime: WriteTime('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].Value);
          vtDate: WriteDate('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].Value);
          vtDateTime: WriteDateTime('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].Value);
          vtBoolean: WriteBool('Settings', FSettings.Item[i].KeyName,
              FSettings.Item[i].Value);
        end;
      end;
      if Assigned(FOnSaveCustomINIFileSettings) then
        FOnSaveCustomINIFileSettings(Self, INIFile);
    end;
  finally
    FreeAndNil(INIFile);
  end;
end;

procedure TProgramSettings.SaveSettingsRegistry;
var
  Registry: TRegistry;
  i: integer;
begin
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      RootKey := FRootKey;
      if OpenKey(FSettingsKey, True) then
      begin
        for i := 0 to Pred(FSettings.Count) do
        begin
          case FSettings.Item[i].ValueType of
            vtUnknown, vtString:
            begin
              WriteString(FSettings.Item[i].KeyName, FSettings.Item[i].Value);
            end;
            vtPassword: WriteString(
                FSettings.Item[i].KeyName, SuperCipher(FSettings.Item[i].Value,
                FEncryptKey));
            vtInteger: WriteInteger(
                FSettings.Item[i].KeyName, FSettings.Item[i].Value);
            vtCurrency: WriteCurrency(
                FSettings.Item[i].KeyName, FSettings.Item[i].Value);
            vtFloat: WriteFloat(FSettings.Item[i].KeyName, FSettings.Item[i].Value);
            vtTime: WriteTime(FSettings.Item[i].KeyName, FSettings.Item[i].Value);
            vtDate: WriteDate(FSettings.Item[i].KeyName, FSettings.Item[i].Value);
            vtDateTime: WriteDateTime(
                FSettings.Item[i].KeyName, FSettings.Item[i].Value);
            vtBoolean: WriteBool(FSettings.Item[i].KeyName, FSettings.Item[i].Value);
          end;
        end;
        CloseKey;
      end;
      if Assigned(FOnSaveCustomRegistrySettings) then
      begin
        FOnSaveCustomRegistrySettings(Self, Registry);
      end;
    end;
  finally
    FreeAndNil(Registry);
  end;
end;

procedure TProgramSettings.SaveForm(AForm: TForm; AFormClass: string = '');
begin
  case FSettingsStore of
    ssRegistry: SaveFormRegistry(AForm, AFormClass);
    ssINIFile: SaveFormINIFile(AForm, AFormClass);
  end;
end;

procedure TProgramSettings.SaveFormINIFile(AForm: TForm; AFormClass: string = '');
var
  INIFile:  TINIFile;
  FormName: string;
begin
  FormName := AFormClass;
  if FormName = '' then
    FormName := AForm.ClassName;
  INIFile := TIniFile.Create(FINIFileName);
  try
    with AForm, INIFile do
    begin
      if WindowState <> wsMaximized then
      begin
        WriteInteger('Form.' + FormName, 'Left', Left);
        WriteInteger('Form.' + FormName, 'Top', Top);
        WriteInteger('Form.' + FormName, 'Width', Width);
        WriteInteger('Form.' + FormName, 'Height', Height);
      end;
       case WindowState of
          wsNormal, wsMaximized:
          begin
            WriteInteger('Form.' + FormName, 'WindowState', integer(WindowState));
          end;
          else
            WriteInteger('Form.' + FormName, 'WindowState', integer(wsNormal));
        end;
      WriteInteger('Form.' + FormName, 'FormStyle', integer(FormStyle));
      WriteInteger('Form.' + FormName, 'Monitor', Monitor.MonitorNum);
    end;
  finally
    FreeAndNil(INIFile);
  end;
end;

procedure TProgramSettings.SaveFormRegistry(AForm: TForm; AFormClass: string = '');
var
  Registry: TRegistry;
  FormName: string;
begin
  Registry := TRegistry.Create;
  try
    with AForm do
    begin
      FormName := AFormClass;
      if FormName = '' then
        FormName := AForm.ClassName;
      Registry.CloseKey;
      Registry.RootKey := FRootKey;
      if Registry.OpenKey(IncludeTrailingPathDelimiter(FSettingsKey) +
        'Forms\' + FormName, True) then
      begin
        if WindowState <> wsMaximized then
        begin
          Registry.WriteInteger('Left', Left);
          Registry.WriteInteger('Top', Top);
          Registry.WriteInteger('Width', Width);
          Registry.WriteInteger('Height', Height);
        end;
        case WindowState of
          wsNormal, wsMaximized:
          begin
            Registry.WriteInteger('WindowState', integer(WindowState));
          end;
          else
            Registry.WriteInteger('WindowState', integer(wsNormal));
        end;
        Registry.WriteInteger('FormStyle', integer(FormStyle));
        Registry.WriteInteger('Monitor', Monitor.MonitorNum);
        Registry.CloseKey;
      end;
    end;
  finally
    FreeAndNil(Registry);
  end;

end;

procedure TProgramSettings.LoadForm(AForm: TForm; AFormClass: string = '');
begin
  case FSettingsStore of
    ssRegistry: LoadFormRegistry(AForm, AFormClass);
    ssINIFile: LoadFormINIFile(AForm, AFormClass);
  end;
end;

procedure TProgramSettings.LoadFormINIFile(AForm: TForm; AFormClass: string = '');
var
  INIFile:  TINIFile;
  FormName: string;
  MonitorNumber: integer;
begin
  FormName := AFormClass;
  if FormName = '' then
    FormName := AForm.ClassName;
  INIFile := TIniFile.Create(FINIFileName);
  try
    with AForm, INIFile do
    begin
      Position := poDesigned;
      Left     := ReadInteger('Form.' + FormName, 'Left', Left);
      Top      := ReadInteger('Form.' + FormName, 'Top', Top);
      Width    := ReadInteger('Form.' + FormName, 'Width', Width);
      Height   := ReadInteger('Form.' + FormName, 'Height', Height);



      FormStyle := TFormStyle(ReadInteger('Form.' + FormName,
        'FormStyle', integer(FormStyle)));

      if TWindowState(ReadInteger('Form.' + FormName, 'WindowState',
        integer(WindowState))) <> wsNormal then
      begin
        // Set correct monitor if window state is Maximized or Minimized.
        MonitorNumber := ReadInteger('Form.' + FormName, 'Monitor', 0);
        if (MonitorNumber < Screen.MonitorCount) and (MonitorNumber > 0) then
        begin
          Left := Screen.Monitors[MonitorNumber].Left;
          Top  := Screen.Monitors[MonitorNumber].Top;
        end;
      end;

      WindowState := TWindowState(ReadInteger('Form.' + FormName,
        'WindowState', integer(WindowState)));
    end;
  finally
    FreeAndNil(INIFile);
  end;
  if AForm.WindowState = wsMinimized then
    AForm.WindowState := wsNormal;
end;

procedure TProgramSettings.LoadFormRegistry(AForm: TForm; AFormClass: string = '');
var
  Registry:      TRegistry;
  FormName:      string;
  MonitorNumber: integer;
  FormWindowState: TWindowState;
begin
  Registry := TRegistry.Create;
  try
    with AForm do
    begin
      Registry.CloseKey;
      Registry.RootKey := FRootKey;
      FormWindowState := wsNormal;
      FormName := AFormClass;
      if FormName = '' then
        FormName := AForm.ClassName;
      if Registry.OpenKey(IncludeTrailingPathDelimiter(FSettingsKey) +
        'Forms\' + FormName, False) then
      begin
        Position := poDesigned;
        if Registry.ValueExists('Left') then
          Left := Registry.ReadInteger('Left');
        if Registry.ValueExists('Top') then
          Top := Registry.ReadInteger('Top');
        if Registry.ValueExists('Width') then
          Width := Registry.ReadInteger('Width');
        if Registry.ValueExists('Height') then
          Height := Registry.ReadInteger('Height');
        if Registry.ValueExists('FormStyle') then
          FormStyle := TFormStyle(Registry.ReadInteger('FormStyle'));

        if Registry.ValueExists('WindowState') then
        begin
          FormWindowState := TWindowState(Registry.ReadInteger('WindowState'));
          // Set correct monitor if window state is maximized or minmized.
          if FormWindowState <> wsNormal then
          begin
            if Registry.ValueExists('Monitor') then
            begin
              MonitorNumber := Registry.ReadInteger('Monitor');
              if (MonitorNumber < Screen.MonitorCount) and (MonitorNumber > 0) then
              begin
                Left := Screen.Monitors[MonitorNumber].Left;
                Top  := Screen.Monitors[MonitorNumber].Top;
              end;
            end;
          end;

        end;

        WindowState := FormWindowState;

        Registry.CloseKey;
      end;
    end;
  finally
    FreeAndNil(Registry);
  end;

end;



function TProgramSettings.LoadCustomValueINIFile(ASection: string;
  AKeyName: string; AValueType: TSettingValueType; ADefaultValue: variant): variant;
var
  INIFile: TINIFile;
begin
  INIFile := TIniFile.Create(FINIFileName);
  try
    with INIFile do
    begin
      case AValueType of
        vtString, vtUnknown:
        begin
          Result :=
            ReadString(ASection, AKeyName, ADefaultValue);
        end;
        vtPassword: SuperCipher(
            ReadString(ASection, AKeyName, ADefaultValue),
            FEncryptKey);
        vtInteger: Result  :=
            ReadInteger(ASection, AKeyName, ADefaultValue);
        vtFloat, vtCurrency: Result :=
            ReadFloat(ASection, AKeyName, ADefaultValue);
        vtTime: Result     :=
            ReadTime(ASection, AKeyName, ADefaultValue);
        vtDate: Result     :=
            ReadDate(ASection, AKeyName, ADefaultValue);
        vtDateTime: Result :=
            ReadDateTime(ASection, AKeyName, ADefaultValue);
        vtBoolean: Result  :=
            ReadBool(ASection, AKeyName, ADefaultValue);
      end;
    end;
  finally
    INIFile.Free;
  end;
end;


procedure TProgramSettings.SaveCustomValueINIFile(ASection: string;
  AKeyName: string; AValueType: TSettingValueType; AValue: variant);
var
  INIFile: TINIFile;
begin
  INIFile := TIniFile.Create(FINIFileName);
  try
    with INIFile do
    begin
      case AValueType of
        vtString, vtUnknown:
        begin
          WriteString(ASection, AKeyName, AValue);
        end;
        vtPassword: WriteString(ASection, AKeyName, SuperCipher(AValue, FEncryptKey));
        vtInteger: WriteInteger(ASection, AKeyName, AValue);
        vtFloat, vtCurrency: WriteFloat(ASection, AKeyName, AValue);
        vtTime: WriteTime(ASection, AKeyName, AValue);
        vtDate: WriteDate(ASection, AKeyName, AValue);
        vtDateTime: WriteDateTime(ASection, AKeyName, AValue);
        vtBoolean: WriteBool(ASection, AKeyName,
            AValue);
      end;
    end;
  finally
    INIFile.Free;
  end;
end;

function TProgramSettings.LoadCustomValueRegistry(ASection: string;
  AKeyName: string; AValueType: TSettingValueType; ADefaultValue: variant): variant;
var
  Registry: TRegistry;
begin
  //Debug('LoadCustomValueRegistry',ASection + ', KeyName: ' + AKeyName);
  Result := ADefaultValue;
  if FEncryptKey = '' then
    FEncryptKey := DEFAULT_ENCRYPT_KEY;
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      RootKey := FRootKey;
      if OpenKeyReadOnly(ASection) then
      begin
        if ValueExists(AKeyName) then
        begin
          case AValueType of
            vtString, vtUnknown:
            begin
              Result :=
                ReadString(AKeyName);
            end;
            vtPassword: Result :=
                SuperCipher(ReadString(AKeyName), FEncryptKey);
            vtInteger: Result  :=
                ReadInteger(AKeyName);
            vtFloat, vtCurrency: Result :=
                ReadFloat(AKeyName);
            vtTime: Result     := ReadTime(AKeyName);
            vtDate: Result     := ReadDate(AKeyName);
            vtDateTime: Result := ReadDateTime(AKeyName);
            vtBoolean: Result  := ReadBool(AKeyName);
          end;
        end;
        CloseKey;
      end;
    end;
  finally
    FreeAndNil(Registry);
  end;
end;

procedure TProgramSettings.SaveCustomValueRegistry(ASection: string;
  AKeyName: string; AValueType: TSettingValueType; AValue: variant);
var
  Registry: TRegistry;
begin
  if FEncryptKey = '' then
    FEncryptKey := DEFAULT_ENCRYPT_KEY;
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      RootKey := FRootKey;
      if OpenKey(ASection, True) then
      begin
        case AValueType of
          vtString, vtUnknown:
          begin
            WriteString(AKeyName, AValue);
          end;
          vtPassword: WriteString(AKeyName,
              SuperCipher(AValue, FEncryptKey));
          vtInteger: WriteInteger(AKeyName, AValue);
          vtFloat, vtCurrency: WriteFloat(AKeyName, AValue);
          vtTime: WriteTime(AKeyName, AValue);
          vtDate: WriteDate(AKeyName, AValue);
          vtDateTime: WriteDateTime(AKeyName, AValue);
          vtBoolean: WriteBool(AKeyName, AValue);
        end;
        CloseKey;
      end;
    end;
  finally
    FreeAndNil(Registry);
  end;
end;

function TProgramSettings.LoadCustomValue(ASection: string; AKeyName: string;
  AValueType: TSettingValueType; ADefaultValue: variant): variant;
begin
  case FSettingsStore of
    ssRegistry: Result := LoadCustomValueRegistry(FSettingsKey +
        ASection, AKeyName, AValueType, ADefaultValue);
    ssINIFile: Result  := LoadCustomValueINIFile(ASection, AKeyName,
        AValueType, ADefaultValue);
  end;
end;

procedure TProgramSettings.SaveCustomValue(ASection: string; AKeyName: string;
  AValueType: TSettingValueType; AValue: variant);
begin
  case FSettingsStore of
    ssRegistry: SaveCustomValueRegistry(FSettingsKey + ASection,
        AKeyName, AValueType, AValue);
    ssINIFile: SaveCustomValueINIFile(ASection, AKeyName, AValueType, AValue);
  end;

end;

procedure TProgramSettings.LoadSectionRegistry(AProgramSettingsSections:
  TProgramSettingsSections);
var
  Registry:   TRegistry;
  SectionKey: string;
  Sections:   TStringList;
  SectionIdx: integer;
  BaseIdx:    integer;
  Value:      variant;
begin
  Registry := TRegistry.Create;
  Sections := TStringList.Create;
  try
    AProgramSettingsSections.Clear;
    with Registry do
    begin
      RootKey := FRootKey;
      if OpenKeyReadOnly(FSettingsKey + AProgramSettingsSections.BaseSectionName) then
      begin
        GetKeyNames(Sections);
        //Debug('LoadSectionRegistry', Sections.Text);
        for SectionIdx := 0 to Pred(Sections.Count) do
        begin
          SectionKey := IncludeTrailingBackslash(FSettingsKey +
            AProgramSettingsSections.BaseSectionName) + Sections[SectionIdx];
          if OpenKeyReadOnly(SectionKey) then
          begin
            for BaseIdx := 0 to Pred(AProgramSettingsSections.BaseSettings.Count) do
            begin
              Value := LoadCustomValueRegistry(SectionKey,
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].KeyName,
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].ValueType,
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].DefaultValue);

              AProgramSettingsSections.Add(Sections[SectionIdx],
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].KeyName,
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].ValueType, Value);
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(Registry);
    FreeAndNil(Sections);
  end;
end;

procedure TProgramSettings.SaveSectionRegistry(AProgramSettingsSections:
  TProgramSettingsSections);
var
  Registry:   TRegistry;
  SectionKey: string;
  SettingIdx: integer;
  SectionIdx: integer;
begin
  Registry := TRegistry.Create;
  try
    with Registry do
    begin
      RootKey := FRootKey;
      if KeyExists(FSettingsKey + AProgramSettingsSections.BaseSectionName) then
        DeleteKey(FSettingsKey + AProgramSettingsSections.BaseSectionName);

      if OpenKey(FSettingsKey + AProgramSettingsSections.BaseSectionName, True) then
      begin
        for SectionIdx := 0 to Pred(AProgramSettingsSections.Count) do
        begin
          SectionKey := IncludeTrailingBackslash(FSettingsKey +
            AProgramSettingsSections.BaseSectionName) +
            AProgramSettingsSections.Section[SectionIdx].SectionName;
          for SettingIdx := 0 to Pred(
              AProgramSettingsSections.Section[SectionIdx].Settings.Count) do
          begin
            SaveCustomValueRegistry(SectionKey,
              AProgramSettingsSections.Section[SectionIdx].Settings.Item[
              SettingIdx].KeyName,
              AProgramSettingsSections.Section[SectionIdx].Settings.Item[
              SettingIdx].ValueType,
              AProgramSettingsSections.Section[SectionIdx].Settings.Item[SettingIdx].Value);
          end;

        end;
      end;
    end;
  finally
    FreeAndNil(Registry);
  end;
end;

procedure TProgramSettings.LoadSectionINIFile(AProgramSettingsSections: TProgramSettingsSections);
var
  INIFile:    TIniFile;
  Sections:   TStringList;
  SectionIdx: integer;
  BaseIdx:    integer;
  Value:      variant;
begin
  INIFile  := TINIFile.Create(FINIFileName);
  Sections := TStringList.Create;
  try
    AProgramSettingsSections.Clear;
    with INIFile do
    begin
      if SectionExists(AProgramSettingsSections.BaseSectionName) then
      begin
        ReadSection(AProgramSettingsSections.BaseSectionName, Sections);
        for SectionIdx := 0 to Pred(Sections.Count) do
        begin
          if SectionExists(Sections[SectionIdx]) then
          begin
            for BaseIdx := 0 to Pred(AProgramSettingsSections.BaseSettings.Count) do
            begin
              Value := LoadCustomValueINIFile(Sections[SectionIdx],
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].KeyName,
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].ValueType,
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].DefaultValue);

              AProgramSettingsSections.Add(Sections[SectionIdx],
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].KeyName,
                AProgramSettingsSections.BaseSettings.Item[BaseIdx].ValueType, Value);
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(INIFile);
    FreeAndNil(Sections);
  end;
end;

procedure TProgramSettings.SaveSectionINIFile(AProgramSettingsSections: TProgramSettingsSections);
var
  INIFile:    TINIFile;
  SettingIdx: integer;
  SectionIdx: integer;
begin
  INIFile := TIniFile.Create(FINIFileName);
  try
    with INIFile do
    begin
      if SectionExists(AProgramSettingsSections.BaseSectionName) then
      begin
        EraseSection(AProgramSettingsSections.BaseSectionName);
      end;


      for SectionIdx := 0 to Pred(AProgramSettingsSections.Count) do
      begin
        WriteString(AProgramSettingsSections.BaseSectionName,
          AProgramSettingsSections.Section[SectionIdx].SectionName, '');
        for SettingIdx := 0 to Pred(
            AProgramSettingsSections.Section[SectionIdx].Settings.Count) do
        begin
          SaveCustomValueINIFile(AProgramSettingsSections.Section[SectionIdx].SectionName,
            AProgramSettingsSections.Section[SectionIdx].Settings.Item[
            SettingIdx].KeyName,
            AProgramSettingsSections.Section[SectionIdx].Settings.Item[
            SettingIdx].ValueType,
            AProgramSettingsSections.Section[SectionIdx].Settings.Item[SettingIdx].Value);
        end;

      end;
    end;
  finally
    FreeAndNil(INIFile);
  end;
end;

function TProgramSettings.AddSection(ASectionName: string): TProgramSettingsSections;
begin
  Result := FProgramSettingsBaseSections.Add(ASectionName).ProgramSettingsSections;
end;

function TProgramSettings.GetSectionFromName(ASectionName: string): TProgramSettingsSections;
var
  ProgramSettingsBaseSection: TProgramSettingsBaseSection;
begin
  Result := nil;
  ProgramSettingsBaseSection := FProgramSettingsBaseSections.BaseSectionByName(ASectionName);
  if ProgramSettingsBaseSection <> nil then
  begin
    Result := ProgramSettingsBaseSection.ProgramSettingsSections;
  end;
end;

procedure TProgramSettings.ClearSections;
begin
  FProgramSettingsBaseSections.Clear;
end;

procedure TProgramSettings.LoadSections;
var
  SectionIdx: integer;
begin
  for SectionIdx := 0 to Pred(FProgramSettingsBaseSections.Count) do
  begin
    case FSettingsStore of
      ssRegistry: LoadSectionRegistry(
          FProgramSettingsBaseSections.BaseSection[SectionIdx].ProgramSettingsSections);
      ssINIFile: LoadSectionINIFile(
          FProgramSettingsBaseSections.BaseSection[SectionIdx].ProgramSettingsSections);
    end;
  end;
end;

procedure TProgramSettings.SaveSections;
var
  SectionIdx: integer;
begin
  for SectionIdx := 0 to Pred(FProgramSettingsBaseSections.Count) do
  begin
    case FSettingsStore of
      ssRegistry: SaveSectionRegistry(
          FProgramSettingsBaseSections.BaseSection[SectionIdx].ProgramSettingsSections);
      ssINIFile: SaveSectionINIFile(
          FProgramSettingsBaseSections.BaseSection[SectionIdx].ProgramSettingsSections);
    end;
  end;
end;

procedure TProgramSettings.LoadSection(ASectionName: string);
var
  ProgramSettingsBaseSection: TProgramSettingsBaseSection;
begin
  ProgramSettingsBaseSection := FProgramSettingsBaseSections.BaseSectionByName(ASectionName);
  if ProgramSettingsBaseSection <> nil then
  begin
    case FSettingsStore of
      ssRegistry: LoadSectionRegistry(ProgramSettingsBaseSection.ProgramSettingsSections);
      ssINIFile: LoadSectionINIFile(ProgramSettingsBaseSection.ProgramSettingsSections);
    end;
  end;
end;

procedure TProgramSettings.SaveSection(ASectionName: string);
var
  ProgramSettingsBaseSection: TProgramSettingsBaseSection;
begin
  ProgramSettingsBaseSection := FProgramSettingsBaseSections.BaseSectionByName(ASectionName);
  if ProgramSettingsBaseSection <> nil then
  begin
    case FSettingsStore of
      ssRegistry: SaveSectionRegistry(ProgramSettingsBaseSection.ProgramSettingsSections);
      ssINIFile: SaveSectionINIFile(ProgramSettingsBaseSection.ProgramSettingsSections);
    end;
  end;
end;

end.

