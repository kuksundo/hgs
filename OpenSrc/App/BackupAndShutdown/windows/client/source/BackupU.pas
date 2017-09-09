{-----------------------------------------------------------------------------
 Unit Name: BackupU
 Author: Tristan Marlow
 Purpose: Backup object (7zip and Zip support in one object)

 NOTE: Currently only 7Zip support spanning.

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

-----------------------------------------------------------------------------}
unit BackupU;

interface

uses
  CommonU, JclUnicode,
  Windows, SysUtils, Variants, Classes, Dialogs, ZipMstr, SevenZipVCL;

const
  BACKUP_LOG_DEBUG   = -1;
  BACKUP_LOG_INFO    = 0;
  BACKUP_LOG_WARNING = 1;
  BACKUP_LOG_ERROR   = 2;
  BACKUP_LOG_FATAL   = 3;

type
  TZipType      = (zZip, zSeven, zNTBackup);
  TZipCompression = (zcNone, zcFast, zcNormal, zcHigh, zcMaximum);
  TBackupResult = (brComplete, brFailed, brCancelled);
  TOnBackupLog  = procedure(ASender: TObject; AMessage: string;
    AErrorCode: integer = BACKUP_LOG_INFO) of object;
  TOnBackupFileList     = procedure(ASender: TObject; AFileList: TStrings) of object;
  TOnBackupFileExclusionList = procedure(ASender: TObject;
    AFileList: TStrings) of object;
  TOnSearchProgress = procedure(ASender: TObject; AMessage: string;
    AProgress: integer; var ACancel: boolean) of object;
  TOnBackupFinished = procedure(ASender: TObject;
    ABackupResult: TBackupResult) of object;

  TBackupFile = class(TCollectionItem)
  private
    FFolder:    string;
    FRecursive: boolean;
    FFileMask:  string;
  protected
  public
  published
    property Folder: string Read FFolder Write FFolder;
    property Recursive: boolean Read FRecursive Write FRecursive;
    property FileMask: string Read FFileMask Write FFileMask;
  end;

  TBackupFiles = class(TCollection)
  private
    FCancelled:  boolean;
    FOnLog:      TOnBackupLog;
    FOnProgress: TOnSearchProgress;
    FOnDebug:    TOnDebug;
  protected
    function GetItem(Index: integer): TBackupFile;
    procedure Log(AMessage: string; AErrorCode: integer = BACKUP_LOG_INFO);
    procedure Debug(AProcedure, AMessage: string);
    procedure Progress(AMessage: string; AProgress: integer; var ACancel: boolean);
    procedure InternalOnQuickFileSearchProgress(AMessage: string;
      AProgress: integer; var ACancel: boolean);
    procedure FileSearch(const APathName, AFileName: string;
      const ARecurse: boolean; AFileList: TStrings);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function Add(AFolder, AFileMask: string; ARecursive: boolean): TBackupFile;
      overload;
    function Add: TBackupFile; overload;
    property Item[Index: integer]: TBackupFile Read GetItem;
    function IndexByName(AName: string): integer;
    function ItemByName(AName: string): TBackupFile;
    procedure GenerateFileList(AFileList: TStrings);
  published
    property OnLog: TOnBackupLog Read FOnLog Write FOnLog;
    property OnDebug: TOnDebug Read FOnDebug Write FOnDebug;
    property OnProgress: TOnSearchProgress Read FOnProgress Write FOnProgress;
  end;

  TBackup = class(TComponent)
  private
    FOnLog:     TOnBackupLog;
    FOnDebug:   TOnDebug;
    FOnItemProgress: TOnProgress;
    FOnTotalProgress: TOnProgress;
    FOnFileSearchProgress: TOnProgress;
    FOnBackupFinished: TOnBackupFinished;
    FOnNTBackupStart: TNotifyEvent;
    FOnBackupFileList: TOnBackupFileList;
    FOnBackupFileExclusionList: TOnBackupFileExclusionList;
    FOnNTBackupFinished: TNotifyEvent;
    FZipMaster: TZipMaster;
    FSevenZip:  TSevenZip;
    FZipFileName: TFileName;
    FBackupFiles: TBackupFiles;
    //FBackupFileExclusions : TBackupFileExclusions;
    FBackupFileExclusions: TBackupFiles;
    FTotalProgressMax: int64;
    FItemProgressMax: int64;
    FZipType:   TZipType;
    FZipCompression: TZipCompression;
    FZipDescription: string;
    FZipPassword: string;
    FVolumeSize: integer;
    FBusy:      boolean;
    FCancelled: boolean;
    FSystemState: boolean;
  protected
    procedure Log(AMessage: string; AErrorCode: integer = BACKUP_LOG_INFO);
    procedure Debug(AProcedure, AMessage: string);
    procedure SetItemProgress(AMessage: string; AProgress: integer);
    procedure SetTotalProgress(AMessage: string; AProgress: integer);
    function LoadZipDll: boolean;
    function UnloadZipDll: boolean;
    function GenerateFileList: boolean;
    procedure SetDllDirectory(ADllDirectory: string);
    function GetDllDirectory: string;
    function GetBusy: boolean;
    function GetTempFolder: string;
    function GetTempFile(APrefix: string): string;
    //procedure InternalZipOnTotalProgress(Sender: TObject; TotalSize: Int64; PerCent: Integer);
    procedure InternalZipOnProgress(Sender: TObject; details: TZMProgressDetails);
    procedure InternalZipOnMessage(Sender: TObject; ErrCode: integer;
      const ErrMsg: String);
    procedure Internal7zOnAddFile(Sender: TObject; Filename: WideString;
      Filesize: int64);
    procedure Internal7zOnPreProgress(Sender: TObject; MaxProgress: int64);
    procedure Internal7zOnProgress(Sender: TObject; Filename: WideString;
      FilePosArc, FilePosFile: int64);
    procedure Internal7zOnMessage(Sender: TObject; ErrCode: integer;
      Message: string; Filename: WideString);
    procedure InternalOnSearchProgress(ASender: TObject; AMessage: string;
      AProgress: integer; var ACancel: boolean);
    function GetSevenZipCompression: TCompressStrength;
    function GetZipCompression: integer;
    function CreateBKSFile(AFileName: string): boolean;
    function ExecuteNTBackup(ABFKFileName: TFileName = '';
      ASystemStateOnly: boolean = False; AHide: boolean = False): boolean;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    function Backup(AZipFileList: TStrings): TBackupResult;
    procedure Cancel;
    procedure SplitFile(AFileName: TFileName; AFilesByteSize: integer);
    procedure MergeFiles(ASourceFile, ADestFile: TFileName);
  published
    property Files: TBackupFiles Read FBackupFiles Write FBackupFiles;
    //property Exclusions : TBackupFileExclusions read FBackupFileExclusions write FBackupFileExclusions;
    property Exclusions: TBackupFiles Read FBackupFileExclusions
      Write FBackupFileExclusions;
    property DllDirectory: string Read GetDllDirectory Write SetDllDirectory;
    property ZipFileName: TFileName Read FZipFileName Write FZipFileName;
    property ZipType: TZipType Read FZipType Write FZipType;
    property ZipCompression: TZipCompression Read FZipCompression Write FZipCompression;
    property ZipDescription: string Read FZipDescription Write FZipDescription;
    property ZipPassword: string Read FZipPassword Write FZipPassword;
    property VolumeSize: integer Read FVolumeSize Write FVolumeSize;
    property SystemState: boolean Read FSystemState Write FSystemState;
    property Busy: boolean Read GetBusy;
    property OnLog: TOnBackupLog Read FOnLog Write FOnLog;
    property OnDebug: TOnDebug Read FOnDebug Write FOnDebug;
    property OnTotalProgress: TOnProgress Read FOnTotalProgress Write FOnTotalProgress;
    property OnItemProgress: TOnProgress Read FOnItemProgress Write FOnItemProgress;
    property OnFileSearchProgress: TOnProgress
      Read FOnFileSearchProgress Write FOnFileSearchProgress;
    property OnBackupFinished: TOnBackupFinished
      Read FOnBackupFinished Write FOnBackupFinished;
    property OnNTBackupStart: TNotifyEvent Read FOnNTBackupStart Write FOnNTBackupStart;
    property OnBackupFileList: TOnBackupFileList
      Read FOnBackupFileList Write FOnBackupFileList;
    property OnBackupFileExclusionList: TOnBackupFileExclusionList
      Read FOnBackupFileExclusionList Write FOnBackupFileExclusionList;
    property OnNTBackupFinished: TNotifyEvent
      Read FOnNTBackupFinished Write FOnNTBackupFinished;
  end;

implementation

// TBackupFiles

constructor TBackupFiles.Create;
begin
  inherited Create(TBackupFile);
end;

destructor TBackupFiles.Destroy;
begin
  inherited Destroy;
end;

function TBackupFiles.GetItem(Index: integer): TBackupFile;
begin
  Result := inherited Items[Index] as TBackupFile;
end;

procedure TBackupFiles.Log(AMessage: string; AErrorCode: integer = BACKUP_LOG_INFO);
begin
  if Assigned(FOnLog) then
    FOnLog(Self, AMessage, AErrorCode);
end;

procedure TBackupFiles.Debug(AProcedure, AMessage: string);
begin
  if Assigned(FOnDebug) then
    FOnDebug(Self, AProcedure, AMessage);
end;

procedure TBackupFiles.Progress(AMessage: string; AProgress: integer;
  var ACancel: boolean);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, AMessage, AProgress, ACancel);
  FCancelled := ACancel;
end;

function TBackupFiles.Add(AFolder, AFileMask: string; ARecursive: boolean): TBackupFile;
begin
  Debug('Add', AFolder + ',' + AFileMask + ',' + BoolToStr(ARecursive, True));
  Result := Self.Add;
  with Result do
  begin
    Folder    := AFolder;
    FileMask  := AFileMask;
    Recursive := ARecursive;
  end;
end;

function TBackupFiles.Add: TBackupFile;
begin
  Result := inherited Add as TBackupFile;
end;

function TBackupFiles.IndexByName(AName: string): integer;
var
  Idx:   integer;
  Found: boolean;
begin
  Found  := False;
  Result := -1;
  Idx    := 0;
  while (not Found) and (Idx <= Pred(Self.Count)) do
  begin
    if UpperCase(Self.Item[Idx].Folder) = UpperCase(AName) then
    begin
      Result := Idx;
      Found  := True;
    end;
    Inc(Idx);
  end;
end;

function TBackupFiles.ItemByName(AName: string): TBackupFile;
var
  Idx: integer;
begin
  Idx := IndexByName(AName);
  if Idx <> -1 then
  begin
    Result := Self.Item[Idx];
  end
  else
  begin
    Result := nil;
  end;
end;

procedure TBackupFiles.InternalOnQuickFileSearchProgress(AMessage: string;
  AProgress: integer; var ACancel: boolean);
begin
  if Assigned(FOnProgress) then
  begin
    FOnProgress(Self, AMessage, AProgress, FCancelled);
  end;
end;

procedure TBackupFiles.FileSearch(const APathName, AFileName: string;
  const ARecurse: boolean; AFileList: TStrings);
begin
  QuickFileSearch(APathName, AFileName, ARecurse, AFileList,
    InternalOnQuickFileSearchProgress);
end;

procedure TBackupFiles.GenerateFileList(AFileList: TStrings);
var
  FileIdx: integer;
  // FileSpecArg : String;
begin
  FCancelled := False;
  FileIdx    := 0;
  AFileList.Clear;
  Debug('GenerateFileList', 'Items: ' + IntToStr(Self.Count));
  while (FileIdx < Self.Count) and (not FCancelled) do
  begin
    Debug('GenerateFileList', IncludeTrailingPathDelimiter(Item[FileIdx].Folder) +
      Item[FileIdx].FileMask + ', Recursive: ' +
      BoolToStr(Item[FileIdx].Recursive, True));
    Log('Scanning: ' + IncludeTrailingPathDelimiter(Item[FileIdx].Folder) +
      Item[FileIdx].FileMask + ', Recursive: ' +
      BoolToStr(Item[FileIdx].Recursive, True));
    FileSearch(IncludeTrailingPathDelimiter(Item[FileIdx].Folder),
      Item[FileIdx].FileMask, Item[FileIdx].Recursive, AFileList);
    Inc(FileIdx);
  end;
  Debug('GenerateFileList', 'Cancelled: ' + BoolToStr(FCancelled, True));
end;

// TBackupFileExclusions

{constructor TBackupFileExclusions.Create;
begin
  inherited Create(TBackupFileExclusion);
end;

destructor TBackupFileExclusions.Destroy;
begin
  inherited Destroy;
end;

function TBackupFileExclusions.GetItem(Index: Integer): TBackupFileExclusion;
begin
  Result := inherited Items[Index] as TBackupFileExclusion;
end;

procedure TBackupFileExclusions.Log(AMessage : String; AErrorCode : Integer = BACKUP_LOG_INFO);
begin
  if Assigned(FOnLog) then FOnLog(Self,AMessage,AErrorCode);
end;

procedure TBackupFileExclusions.Debug(AProcedure, AMessage : String);
begin
  if Assigned(FOnDebug) then FOnDebug(Self,AProcedure,AMessage);
end;

function TBackupFileExclusions.Add(AFolder, AFileMask : String) : TBackupFileExclusion;
begin
  Debug('Add',AFolder + ',' + AFileMask);
  Result := Self.Add;
  with Result do
    begin
      Folder := AFolder;
      FileMask := AFileMask;
    end;
end;

function TBackupFileExclusions.Add : TBackupFileExclusion;
begin
  Result := inherited Add as TBackupFileExclusion;
end;

function TBackupFileExclusions.IndexByName(AName : String) : Integer;
var
  Idx : Integer;
  Found : Boolean;
begin
  Found := False;
  Result := -1;
  Idx := 0;
  while (not Found) and (Idx <= Pred(Self.Count)) do
    begin
      if UpperCase(Self.Item[Idx].Folder) = UpperCase(AName) then
        begin
          Result := Idx;
          Found := True;
        end;
      inc(Idx);
    end;
end;

function TBackupFileExclusions.ItemByName(AName : String) : TBackupFileExclusion;
var
  Idx : Integer;
begin
  Idx := IndexByName(AName);
  if Idx <> -1 then
    begin
      Result := Self.Item[Idx];
    end else
    begin
      Result := nil;
    end;
end;

procedure TBackupFileExclusions.GenerateFileList(AFileList : TStrings);
var
  FileIdx : Integer;
  FileSpecArg : String;
begin
  For FileIdx := 0 to Pred(Self.Count) do
    begin
      FileSpecArg := '';
      //if Item[FileIdx].Recursive then FileSpecArg := '>';
      FileSpecArg := FileSpecArg + IncludeTrailingPathDelimiter(Item[FileIdx].Folder);
      FileSpecArg := FileSpecArg + Item[FileIdx].FileMask;
      Debug('GenerateFileList',FileSpecArg);
      AFileList.Add(FileSpecArg);
    end;
end;}

//TBackup

constructor TBackup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FZipType     := zSeven;
  FVolumeSize  := 0;
  FZipCompression := zcMaximum;
  FBackupFiles := TBackupFiles.Create;
  with FBackupFiles do
  begin
    OnLog      := Self.OnLog;
    OnDebug    := Self.OnDebug;
    OnProgress := InternalOnSearchProgress;
  end;
  // FBackupFileExclusions := TBackupFileExclusions.Create;
  FBackupFileExclusions := TBackupFiles.Create;
  with FBackupFileExclusions do
  begin
    OnLog      := Self.OnLog;
    OnDebug    := Self.OnDebug;
    OnProgress := InternalOnSearchProgress;
  end;
  FZipMaster := TZipMaster.Create(Self);
  with FZipMaster do
  begin
    OnProgress := InternalZipOnProgress;
    OnMessage  := InternalZipOnMessage;
  end;
  FSevenZip := TSevenZip.Create(Self);
  with FSevenZip do
  begin
    OnAddfile     := Internal7zOnAddFile;
    OnProgress    := Internal7zOnProgress;
    OnPreProgress := Internal7zOnPreProgress;
    OnMessage     := Internal7zOnMessage;
  end;
  FBusy      := False;
  FCancelled := False;
end;

destructor TBackup.Destroy;
begin
  FreeAndNil(FBackupFiles);
  FreeAndNil(FBackupFileExclusions);
  FreeAndNil(FZipMaster);
  FreeAndNil(FSevenZip);
  inherited Destroy;
end;

procedure TBackup.Log(AMessage: string; AErrorCode: integer = BACKUP_LOG_INFO);
begin
  if Assigned(FOnLog) then
    FOnLog(Self, AMessage, AErrorCode);
end;

procedure TBackup.Debug(AProcedure, AMessage: string);
begin
  if Assigned(FOnDebug) then
    FOnDebug(Self, AProcedure, AMessage);
end;

procedure TBackup.SetItemProgress(AMessage: string; AProgress: integer);
begin
  if Assigned(FOnItemProgress) then
    FOnItemProgress(Self, AMessage, AProgress);
end;

procedure TBackup.SetTotalProgress(AMessage: string; AProgress: integer);
begin
  if Assigned(FOnTotalProgress) then
    FOnTotalProgress(Self, AMessage, AProgress);
end;


procedure TBackup.SetDllDirectory(ADllDirectory: string);
begin
  FZipMaster.DLLDirectory := ADllDirectory;
end;

function TBackup.GetDllDirectory: string;
begin
  Result := FZipMaster.DLLDirectory;
end;

function TBackup.GetBusy: boolean;
begin
  Result := False;
  case FZipType of
    zZip:
    begin
      Result := FZipMaster.State = zsBusy;
    end;
    zSeven:
    begin
      Result := FBusy;
    end;
  end;
end;


function TBackup.LoadZipDll: boolean;
begin
  FZipMaster.Dll_Load := True;
  Result := FZipMaster.Dll_Load;
  Log('LoadZipDll: ' + BoolToStr(Result, True) + ' ' + FZipMaster.Dll_Path +
    ' ' + FZipMaster.Dll_Version);
end;

function TBackup.UnloadZipDll: boolean;
begin
  FZipMaster.Dll_Load := False;
  Result := FZipMaster.Dll_Load;
  Log('UnloadZipDll: ' + BoolToStr(Result, True));
end;

function TBackup.GetTempFolder: string;
var
  Buffer: array[0..MAX_PATH] of char;
begin
  GetTempPath(MAX_PATH, Buffer);
  Result := IncludeTrailingPathDelimiter(Buffer);
end;

function TBackup.GetTempFile(APrefix: string): string;
var
  Temp: array[0..MAX_PATH] of char;
begin
  GetTempFilename(PChar(GetTempFolder), PChar(APrefix), 0, Temp);
  Result := string(Temp);
end;

function TBackup.GenerateFileList: boolean;
var
  FileList, ExcludeList: TStringList;
  FileIdx: integer;
begin
  Result      := False;
  FileList    := TStringList.Create;
  ExcludeList := TStringList.Create;
  try
    Log('Generating file list...');
    FBackupFiles.GenerateFileList(FileList);
    FBackupFileExclusions.GenerateFileList(ExcludeList);
    Log('Processing file list...');
    if Assigned(FOnBackupFileList) then
      FOnBackupFileList(Self, FileList);
    Log('Processing exclusion file list...');
    if Assigned(FOnBackupFileExclusionList) then
      FOnBackupFileExclusionList(Self, ExcludeList);
    case FZipType of
      zZip:
      begin
        FZipMaster.FSpecArgs.Assign(FileList);
        FZipMaster.FSpecArgsExcl.Assign(ExcludeList);
        Debug('GenerateFileList', 'Include Count: ' +
          IntToStr(FZipMaster.FSpecArgs.Count));
        Debug('GenerateFileList', 'Exclude Count: ' +
          IntToStr(FZipMaster.FSpecArgsExcl.Count));
        Result := (FZipMaster.FSpecArgs.Count > 0) and (not FCancelled);
      end;
      zSeven:
      begin
        FSevenZip.Files.Clear;
        FileIdx := 0;
        while (FileIdx < FileList.Count) and (not FCancelled) do
        begin
          SetItemProgress(FileList[FileIdx], 0);
          if ExcludeList.IndexOf(FileList[FileIdx]) = -1 then
          begin
            Debug('GenerateFileList', 'Add: ' + FileList[FileIdx]);
            FSevenZip.Files.AddString(FileList[FileIdx]);
          end
          else
          begin
            Debug('GenerateFileList', 'Exclude: ' + FileList[FileIdx]);
          end;
          Inc(FileIdx);
        end;
        Debug('GenerateFileList', 'Include Count: ' + IntToStr(FSevenZip.Files.Count));
        Result := (FSevenZip.Files.Count > 0) and (not FCancelled);
      end;
    end;
  finally
    FreeAndNil(FileList);
    FreeAndNil(ExcludeList);
  end;
end;

{procedure TBackup.InternalZipOnTotalProgress(Sender: TObject; TotalSize: Int64; PerCent: Integer);
var
  Cancel : Boolean;
begin
  Cancel := FZipMaster.Cancel;
  SetTotalProgress(FZipMaster.ZipFileName,PerCent);
  FZipMaster.Cancel := Cancel;
end; }

procedure TBackup.InternalZipOnProgress(Sender: TObject; details: TZMProgressDetails);
var
  Cancel: boolean;
begin
  Cancel := FCancelled;
  SetItemProgress(details.ItemName, details.ItemPerCent);
  SetTotalProgress(FZipMaster.ZipFileName, details.TotalPerCent);
  FZipMaster.Cancel := Cancel;
end;

procedure TBackup.InternalZipOnMessage(Sender: TObject; ErrCode: integer;
  const ErrMsg: String);
begin
  Log(ErrMsg, ErrCode);
end;

procedure TBackup.Internal7zOnAddFile(Sender: TObject; Filename: WideString;
  Filesize: int64);
begin
  Log(Filename + ' (' + IntToStr(Filesize) + ')');
  FItemProgressMax := Filesize;
end;

procedure TBackup.Internal7zOnPreProgress(Sender: TObject; MaxProgress: int64);
begin
  FTotalProgressMax := MaxProgress;
end;

procedure TBackup.Internal7zOnProgress(Sender: TObject; Filename: WideString;
  FilePosArc, FilePosFile: int64);
var
  Cancel: boolean;
  TotalProgress, ItemProgress: integer;
begin
  Cancel := False;
  TotalProgress := 0;
  ItemProgress := 0;
  if (FilePosArc > 0) and (FTotalProgressMax > 0) then
  begin
    TotalProgress := Round((FilePosArc / FTotalProgressMax) * 100);
  end;
  if (FilePosFile > 0) and (FItemProgressMax > 0) then
  begin
    ItemProgress := Round((FilePosFile / FItemProgressMax) * 100);
  end;
  SetItemProgress(Filename, ItemProgress);
  SetTotalProgress(FSevenZip.SZFileName, TotalProgress);
  if Cancel then
    FSevenZip.Cancel;
end;

procedure TBackup.Internal7zOnMessage(Sender: TObject; ErrCode: integer;
  Message: string; Filename: WideString);
begin
  Log(Message, ErrCode);
end;

procedure TBackup.InternalOnSearchProgress(ASender: TObject;
  AMessage: string; AProgress: integer; var ACancel: boolean);
begin
  ACancel := FCancelled;
  if ACancel then
    Debug('InternalOnSearchProgress', 'Cancel request.');
  if Assigned(FOnFileSearchProgress) then
    FOnFileSearchProgress(ASender, AMessage, AProgress);
end;

procedure TBackup.SplitFile(AFileName: TFileName; AFilesByteSize: integer);
var
  fs, ss: TFileStream;
  cnt:    integer;
  SplitName: string;
begin
  fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    for cnt := 1 to Trunc(fs.Size / AFilesByteSize) + 1 do
    begin
      SplitName := ChangeFileExt(AFileName, Format('%s%d', ['._', cnt]));
      ss := TFileStream.Create(SplitName, fmCreate or fmShareExclusive);
      try
        if fs.Size - fs.Position < AFilesByteSize then
          AFilesByteSize := fs.Size - fs.Position;
        ss.CopyFrom(fs, AFilesByteSize);
      finally
        ss.Free;
      end;
    end;
  finally
    fs.Free;
  end;
end;

procedure TBackup.MergeFiles(ASourceFile, ADestFile: TFileName);
var
  fs, ss: TFileStream;
  cnt:    integer;
begin
  cnt := 1;
  fs  := TFileStream.Create(ADestFile, fmCreate or fmShareExclusive);
  try
    while FileExists(ASourceFile) do
    begin
      ss := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
      try
        fs.CopyFrom(ss, 0);
      finally
        ss.Free;
      end;
      Inc(cnt);
      ASourceFile := ChangeFileExt(ASourceFile, Format('%s%d', ['._', cnt]));
    end;
  finally
    fs.Free;
  end;
end;

function TBackup.GetSevenZipCompression: TCompressStrength;
begin
  case FZipCompression of
    zcNone: Result   := SAVE;
    zcFast: Result   := FAST;
    zcNormal: Result := NORMAL;
    zcHigh: Result   := MAXIMUM;
    else
      Result := ULTRA;
  end;
  Debug('GetSevenZipCompression', 'Result: ' + IntToStr(integer(Result)));
end;

function TBackup.GetZipCompression: integer;
begin
  case FZipCompression of
    zcNone: Result   := 0;
    zcFast: Result   := 2;
    zcNormal: Result := 5;
    zcHigh: Result   := 7;
    else
      Result := 9;
  end;
  Debug('GetZipCompression', 'Result: ' + IntToStr(Result));
end;

function TBackup.CreateBKSFile(AFileName: string): boolean;
var
  FileList:   TWideStringList;
  FileIdx:    integer;
  FileStream: TFileStream;
  FileName:   TFileName;
  PluginFileList: TStringList;
begin
  if FileExists(AFileName) then
    DeleteFile(AFileName);
  Log(Format('Generating BKS file list (%s)', [AFileName]), BACKUP_LOG_INFO);
  FileList   := TWideStringList.Create;
  PluginFileList := TStringList.Create;
  FileStream := TFileStream.Create(AFileName, fmCreate or fmOpenWrite);
  try
    for FileIdx := 0 to Pred(FBackupFiles.Count) do
    begin
      FileName := IncludeTrailingPathDelimiter(FBackupFiles.Item[FileIdx].Folder) +
        FBackupFiles.Item[FileIdx].FileMask;
      if FileExists(FileName) then
      begin
        FileList.Add(FileName);
      end
      else
      begin
        FileList.Add(IncludeTrailingPathDelimiter(FBackupFiles.Item[FileIdx].Folder));
      end;
    end;
    for FileIdx := 0 to Pred(FBackupFileExclusions.Count) do
    begin
      FileName := IncludeTrailingPathDelimiter(
        FBackupFileExclusions.Item[FileIdx].Folder) +
        FBackupFileExclusions.Item[FileIdx].FileMask;
      if FileExists(FileName) then
      begin
        FileList.Add(FileName);
      end
      else
      begin
        FileList.Add(IncludeTrailingPathDelimiter(
          FBackupFileExclusions.Item[FileIdx].Folder));
      end;
    end;
    if Assigned(FOnBackupFileList) then
      FOnBackupFileList(Self, PluginFileList);
    for FileIdx := 0 to Pred(PluginFileList.Count) do
    begin
      FileList.Add(PluginFileList[FileIdx]);
    end;
    if FSystemState then
    begin
      Log('Backing up system state.', BACKUP_LOG_INFO);
      FileList.Add('SystemState');
    end;
    Log('BKS File list: ' + FileList.Text, BACKUP_LOG_INFO);
    Log(Format('BKS file %s', [AFileName]), BACKUP_LOG_INFO);
    FileStream.WriteBuffer(PWideChar(FileList.Text)^, Length(FileList.Text) *
      SizeOf(widechar));
  finally
    FreeAndNil(PluginFileList);
    FreeAndNil(FileList);
    FileStream.Free;
  end;
  Result := FileExists(AFileName);
end;

function TBackup.ExecuteNTBackup(ABFKFileName: TFileName = '';
  ASystemStateOnly: boolean = False; AHide: boolean = False): boolean;
var
  BKSFileName, BKFFileName: TFileName;
  Command: string;

  function FileExecute(const aCmdLine: string; aHide, aWait: boolean): boolean;
  var
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
  begin
    {setup the startup information for the application }
    FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
    with StartupInfo do
    begin
      cb      := SizeOf(TStartupInfo);
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

begin
  Result := False;
  if Assigned(FOnNTBackupStart) then
    FOnNTBackupStart(Self);
  BKFFileName := ABFKFileName;
  BKSFileName := GetTempFolder + ChangeFileExt(ExtractFileName(FZipFileName), '.bks');
  try
    if ASystemStateOnly then
    begin
      if BKFFileName = '' then
        BKFFileName := GetTempFolder + ChangeFileExt(
          ExtractFileName(FZipFileName), '.bkf');
      Command := 'ntbackup backup systemstate /j "System State" /f "' +
        BKFFileName + '"';
      Log(Format('Starting NT Backup %s', [Command]), BACKUP_LOG_INFO);
      if FileExecute(Command, AHide, True) then
      begin
        Result := True;
      end;
    end
    else
    begin
      if BKFFileName = '' then
        BKFFileName := FZipFileName;
      Command := 'ntbackup backup "@' + BKSFileName + '" /j "' +
        ChangeFileExt(ExtractFileName(FZipFileName), '') + '"  /f "' + BKFFileName + '"';
      if CreateBKSFile(BKSFileName) then
      begin
        Log(Format('Starting NT Backup %s', [Command]), BACKUP_LOG_INFO);
        if FileExecute(Command, AHide, True) then
        begin
          Result := True;
        end;
      end;
    end;
  finally
    if Assigned(FOnNTBackupFinished) then
      FOnNTBackupFinished(Self);
  end;
end;

function TBackup.Backup(AZipFileList: TStrings): TBackupResult;
var
  BKFFileName: TFileName;
  ZipFileIdx:  integer;
begin
  if Assigned(AZipFileList) then
  begin
    AZipFileList.Clear;
    Result := brFailed;
    with FBackupFiles do
    begin
      OnLog      := Self.OnLog;
      OnDebug    := Self.OnDebug;
      OnProgress := InternalOnSearchProgress;
    end;
    with FBackupFileExclusions do
    begin
      OnLog      := Self.OnLog;
      OnDebug    := Self.OnDebug;
      OnProgress := InternalOnSearchProgress;
    end;
    Log('Initialising backup, please wait...');
    SetTotalProgress('Gathering details, please wait...', 0);
    SetItemProgress('Gathering details, please wait...', 0);
    FBusy      := True;
    FCancelled := False;
    case FZipType of
      zZip:
      begin
        if LoadZipDll then
        begin
          if GenerateFileList then
          begin
            if FSystemState then
            begin
              Log('Performing System State Backup, Please wait...');
              BKFFileName :=
                GetTempFolder + ChangeFileExt(ExtractFileName(FZipFileName), '.bkf');
              if ExecuteNTBackup(BKFFileName, True, True) then
              begin
                FZipMaster.FSpecArgs.Add(BKFFileName);
              end;
            end;
            Log('Backup in progress, Please wait...');
            FZipMaster.TempDir := GetTempFolder;
            FZipMaster.AddOptions    := [AddDirNames, AddHiddenFiles];
            //AddFreshen,AddUpdate
            FZipMaster.SpanOptions := [spNoVolumeName];
            //FZipMaster.WriteOptions  := [zwoDiskSpan];
            //FZipMaster.MaxVolumeSize := FVolumeSize;
            FZipMaster.AddCompLevel  := GetZipCompression;
            FZipMaster.ZipFileName   := FZipFileName;
            FZipMaster.ZipComment    := AnsiString(FZipDescription);
            FZipMaster.Password      := FZipPassword;
            if Trim(FZipMaster.Password) <> '' then
            begin
              FZipMaster.AddOptions := FZipMaster.AddOptions + [AddEncrypt];
            end;
            SetItemProgress('Starting ZIP compression...', 0);
            if FZipMaster.Add = 0 then
              Result := brComplete;
            AZipFileList.Add(FZipMaster.ZipFileName);
          end
          else
          begin
            Log('File list is empty, backup cannot continue', BACKUP_LOG_WARNING);
          end;
        end
        else
        begin
          Log('Failed to load Zip Dll', BACKUP_LOG_ERROR);
        end;
      end;
      zSeven:
      begin
        if GenerateFileList then
        begin
          if FSystemState then
          begin
            Log('Performing System State Backup, Please wait...');
            BKFFileName :=
              GetTempFolder + ChangeFileExt(ExtractFileName(FZipFileName), '.bkf');
            if ExecuteNTBackup(BKFFileName, True, True) then
            begin
              FSevenZip.Files.AddString(BKFFileName);
            end;
          end;
          Log('Backup in progress, Please wait...');
          FSevenZip.LZMACompressStrength := GetSevenZipCompression;
          Debug('Backup', 'SZFileName: ' + FZipFileName);
          FSevenZip.SZFileName := FZipFileName;
          Debug('Backup', 'Volumesize: ' + IntToStr(FVolumeSize));
          FSevenZip.VolumeSize := FVolumeSize;
          FSevenZip.SevenZipComment := FZipDescription;
          FSevenZip.Password := FZipPassword;
          if Trim(FSevenZip.Password) <> '' then
          begin
            FSevenZip.AddOptions := FSevenZip.AddOptions + [AddEncryptFilename];
          end;
          SetItemProgress('Starting 7z compression...', 0);
          if FSevenZip.Add = 0 then
            Result := brComplete;
          Debug('Backup', 'Zip Volumes: ' + IntToStr(
            Length(FSevenZip.NamesOfVolumesWritten)) + ' file(s)');
          for ZipFileIdx := 0 to (Length(FSevenZip.NamesOfVolumesWritten) - 1) do
          begin
            Debug('Backup', 'Zip Volumes: ' +
              FSevenZip.NamesOfVolumesWritten[ZipFileIdx]);
            AZipFileList.Add(FSevenZip.NamesOfVolumesWritten[ZipFileIdx]);
          end;
        end
        else
        begin
          Log('File list is empty, backup cannot continue.', BACKUP_LOG_WARNING);
        end;
      end;
      zNTBackup:
      begin
        if ExecuteNTBackup then
        begin
          Result := brComplete;
          AZipFileList.Add(FZipFileName);
        end
        else
        begin
          Log('NT Backup failed.', BACKUP_LOG_WARNING);
        end;
      end;
    end;
    FBusy := False;
    if not FCancelled then
    begin
      if Result = brComplete then
      begin
        Log('Backup Complete.');
      end
      else
      begin
        Log('Backup Failed.', BACKUP_LOG_WARNING);
      end;
    end
    else
    begin
      Log('Backup Cancelled.', BACKUP_LOG_WARNING);
      Result := brCancelled;
    end;
    if Assigned(FOnBackupFinished) then
      FOnBackupFinished(Self, Result);
  end
  else
  begin
    raise Exception.Create('ZIPFileList has not been assigned.');
  end;
end;

procedure TBackup.Cancel;
begin
  case FZipType of
    zZip:
    begin
      if not FCancelled then
        FZipMaster.Cancel;
    end;
    zSeven:
    begin
      if not FCancelled then
        FSevenZip.Cancel;
    end;
  end;
  FCancelled := True;
end;

end.

