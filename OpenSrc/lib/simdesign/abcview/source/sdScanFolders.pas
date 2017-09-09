{
  Scan folders recursively

  This is also an example of threaded code with locking (entering and leaving)

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  Goal: make sdScanFolders.pas completely independent of abcview code.
  In order to do this it must use event handlers

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit sdScanFolders;

interface

uses
  SysUtils, Classes, sdProcessThread, Windows, Forms, sdItems,
  Contnrs, SyncObjs;

type

  // Description for one folder
  TScanFolder = class
  public
    FFolder: string;               // Folder Name (with or without trailing bslash)
    FIncludeNewSubDirs: boolean;   // Include new subdirectories in scan
    FIncludeKnownSubDirs: boolean; // Include known subdirectories in scan
    FMask: string;                 // If empty, *.* is used
    FFilter: string;               // If empty, all files are accepted
    function CompleteMask: string; // Returns the complete correctly formed mask
  end;

  // Specialised list for TScanFolder items, this list is thread protected
  TScanList = class
  private
    FItems: TObjectList;
  protected
    function GetCount: integer;
    function GetItems(Index: integer): TScanFolder;
  public
    constructor Create;
    destructor Destroy; override;
    // Add a folder to the collection. If the folder object is a duplicatate,
    // the folder will not be added
    procedure Add(AFolder: TScanFolder);
    procedure Delete(Index: integer);
    property Count: integer read GetCount;
    property Items[Index: integer]: TScanFolder read GetItems; default;
  end;

  TScanner = class(TProcess)
  private
    FTick,
    FFlushTick: integer;
    FTempFolderName: string;
    FCurFolder: string;
    FScanNewSubdirs: boolean;
    FScanKnownSubdirs: boolean;
    FCurMask: string;
    FCurFilter: string;
    FOnClearItems: TNotifyEvent;
    FOnFlushItems: TNotifyEvent;
  protected
    procedure ClearItems;
    procedure DoProgress;
    procedure EndProgress;
    procedure FlushItems;
    procedure Run; override;
    procedure ScanFile(S: TSearchRec; AFolder: TsdFolder);
    procedure ScanFolder(AFolderName: string);
    procedure PostProcess;
    procedure StartProgress;
  public
    FAddHidden: boolean;
    FAddSystem: boolean;
    FGraphicsOnly: boolean;
    FFolderCount,
    FNewCount,
    FTotalCount: longint;
    constructor Create(CreateSuspended: boolean; AParent: TProcessList); override;
    property OnClearItems: TNotifyEvent read FOnClearItems write FOnClearItems;
    property OnFlushItems: TNotifyEvent read FOnFlushItems write FOnFlushItems;
  end;

const
  cScanFlushInterval = 30000; // half minute between updates

// Run a scan on folder AFolder with mask AMask (empty is *.*), IncludeSubdir
// set to True for recursive scanning or set to False for just one folder,
// FFilter set to '' for all files or a list of filemasks for filtering,
// e.g. '.jpg;.gif;' will add all *.jpg and *.gif files.

procedure RunScan(AFolder: string; IncludeNewSubdirs, IncludeKnownSubdirs: boolean;
  AMask, AFilter: string; OnClearItems: TNotifyEvent);

// Determine if a scan is currently running
function IsScanBusy: boolean;

implementation

uses
  guiMain,
  sdAbcTypes,
  sdAbcVars,      // for glAutoFlush
  sdAbcFunctions, // for IsGraphicsFile
  sdProperties;

var

  // Allow only one scan at the time! So when creating a scanner this
  // should be checked.
  glScanBusy: boolean = False;
  // Use this criticalsection to lock access to Scanbusy and Scanlist
  glScanLock: TCriticalSection = nil;
  // List containing TScanFolder entries to scan
  glScanList: TScanList = nil;



{ TScanFolder }

function TScanFolder.CompleteMask: string;
begin
  if FMask = '' then
    FMask := '*.*';
  Result := IncludeTrailingPathDelimiter(FFolder) + FMask;
end;

{ TScanList }

function TScanList.GetCount: integer;
begin
  glScanLock.Enter;
  try
    Result := 0;
    if assigned(FItems) then
      Result := FItems.Count;
  finally
    glScanLock.Leave;
  end;
end;

function TScanList.GetItems(Index: integer): TScanFolder;
begin
  glScanLock.Enter;
  try
    Result := nil;
    if assigned(FItems) and (Index >= 0) and (Index < FItems.Count) then
      Result := TScanFolder(FItems[Index]);
  finally
    glScanLock.Leave;
  end;
end;

constructor TScanList.Create;
begin
  inherited;
  FItems := TObjectList.Create;
end;

destructor TScanList.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TScanList.Add(AFolder: TScanFolder);
var
  i: integer;
begin
  glScanLock.Enter;
  try
    if assigned(AFolder) and assigned(FItems) then
    begin
      for i := 0 to FItems.Count - 1 do
        if (AFolder.CompleteMask = TScanFolder(FItems[i]).CompleteMask) and
           (AFolder.FIncludeNewSubdirs = TScanFolder(FItems[i]).FIncludeNewSubdirs) and
           (AFolder.FIncludeKnownSubdirs = TScanFolder(FItems[i]).FIncludeKnownSubdirs) and
           (AFolder.FFilter = TScanFolder(FItems[i]).FFilter) then
        begin
          // Duplicate
          AFolder.Free;
          exit;
        end;
      FItems.Add(AFolder);
    end;
  finally
    glScanLock.Leave;
  end;
end;

procedure TScanList.Delete(Index: integer);
begin
  glScanLock.Enter;
  try
    if assigned(FItems) and (Index >= 0) and (Index < FItems.Count) then
      FItems.Delete(Index);
  finally
    glScanLock.Leave;
  end;
end;

{ TScanner }

constructor TScanner.Create(CreateSuspended: boolean; AParent: TProcessList);
begin
  inherited;
  // The folder list
  FreeOnTerminate := True;
end;

procedure TScanner.ClearItems;
begin
  if assigned(FOnClearItems) then
    FOnClearItems(Self);
//  frmMain.Root.ClearBatchedItems;
end;

procedure TScanner.DoProgress;
begin
  //if assigned(FOnStatusMessage) then
  begin
    frmMain.Root.DoStatusMessage(Self,
    //FOnStatusMessage(Self, wsInfo,
    Format('Scanning: %d new files of %d total, current folder %s',
    [FNewCount, FTotalCount, FTempFolderName]));
  end;
  Task := format('Scan folder (%d items)', [FTotalCount]);
  Application.ProcessMessages;
end;

procedure TScanner.EndProgress;
begin
  //if assigned(FOnStatusMessage) then
  begin
    frmMain.Root.DoStatusMessage(Self, 'Scanning finished.');
    //FOnStatusMessage(Self, wsInfo, 'Scanning finished.');
  end;
  Task := format('Scan finished', [FTotalCount]);
end;

procedure TScanner.FlushItems;
begin
  // Transfer the items to the root
  if assigned(FOnFlushItems) then
    FOnFlushItems(Self);
  //frmMain.Root.FlushBatchedItems;
end;

procedure TScanner.PostProcess;
begin
//
end;

procedure TScanner.Run;
// This is the core engine for the scanner
var
  FOldAutoFlush: boolean;
begin
  // Try - except block to catch all exceptions in the thread
  try
    // Do we have valid starting point?
    Name := 'scanner';
    FOldAutoFlush := glAutoFlush;
    glAutoFlush := False;
    inc(FShellNotifyRef);
    try
      // Make sure to have a the objects!
      if assigned(frmMain.Root) and assigned(glScanList) then
      begin
        // Do scan
        FFolderCount := 0;
        FNewCount := 0;
        FTotalCount := 0;
        FFlushTick := GetTickCount;
        synchronize(StartProgress);
        while glScanList.Count > 0 do
        begin
          // Grab the first folder
          glScanLock.Enter;
          try
            FCurFolder := IncludeTrailingPathDelimiter(glScanList[0].FFolder);
            FScanNewSubdirs := glScanList[0].FIncludeNewSubdirs;
            FScanKnownSubdirs := glScanList[0].FIncludeKnownSubdirs;
            FCurMask := glScanList[0].FMask;
            if FCurMask = '' then
              FCurMask := '*.*';
            FCurFilter := glScanList[0].FFilter;
          finally
            glScanLock.Leave;
          end;
          ScanFolder(FCurFolder);
          // Now delete the folder entry, we're done
          glScanList.Delete(0);
        end;

        synchronize(FlushItems);
        synchronize(EndProgress);
      end;
    finally
      glAutoFlush := FOldAutoFlush;
      dec(FShellNotifyRef);
      glScanLock.Enter;
      try
        glScanBusy := False;
      finally
        glScanlock.Leave;
      end;
    end;
  except
    // An exception in the thread!
    synchronize(ClearItems);
  end;
end;

procedure TScanner.ScanFile(S: TSearchRec; AFolder: TsdFolder);
var
  MustAdd: boolean;
  AFile: TsdFile;
  Index: integer;
  ItemStates: TsdItemStates;
//
procedure CopyFileSize(var AFile: TsdFile; ASearchRec: TSearchRec);
{$warnings off}
var
  FD: TWin32FindData;
begin
  FD := ASearchRec.FindData;
  AFile.Size := (FD.nFileSizeHigh shl 32) or FD.nFileSizeLow;
{$warnings on}
end;
//
begin
  MustAdd := true;
{$warnings off}
  // Do we want hidden files?
  if not FAddHidden and (S.Attr AND faHidden > 0) then
    MustAdd := false;

  // Do we want system files?
  if not FAddSystem and (S.Attr AND faSysFile > 0) then
    MustAdd := false;

  // reflect ReadOnly files
  if (S.Attr AND faReadOnly > 0) then
  begin
    ItemStates := AFile.States;
    include(ItemStates, isReadOnly);
    AFile.States := ItemStates;
  end;
{$warnings on}

  // Do we want non-graphic files?
  if FGraphicsOnly and not IsGraphicsFile(S.Name) then
    MustAdd := false;

  if MustAdd then
  begin

    // Create a dummy file to verify
    AFile := TsdFile.Create;
    AFile.FolderGuid := AFolder.Guid;
    AFile.Name := S.Name;

    if frmMain.Root.FAllFiles.Match(AFile, Index) then
    begin

      // Already exists
      FreeAndNil(AFile);

      AFile := TsdFile(frmMain.Root.FAllFiles.Items[Index]);
      if assigned(AFile) then
      begin

        AFile.SetState(isVerified, True);
        AFile.SetStates([isDeleted, isNoAccess], False);

        // Modified?
        if (AFile.Size <> S.Size) or (AFile.Modified <> FileDateToDateTime(S.Time)) then
        begin

          // Update properties
          CopyFileSize(AFile, S);
          AFile.Modified := FileDateToDateTime(S.Time);
          AFile.SetStates([isCRCDone, isPixRefd, isDecodeErr], False);

          // Add it to the update list
          frmMain.Root.FUpdates.Add(frmMain.Root.FAllFiles[Index]);
        end;
      end;

    end else
    begin

      // New file
      inc(FNewCount);

      // unique id kept integrally
      CopyFileSize(AFile, S);
      AFile.Modified := FileDateToDateTime(S.Time);
      AFile.SetState(isVerified, True);
      frmMain.Root.FInserts.Add(AFile);

    end;
  end;
end;

procedure TScanner.ScanFolder(AFolderName: string);
var
  R: integer;
  Index: integer;
  AIcon: integer;
  S: TSearchRec;
  Folder, Sub: TsdFolder;
  AFile: TsdFile;
  AOptions: TFolderOptions;
  // local
  function FirstFileWithFolderID(const AFolderID: TGUID): integer;
  var
    Dummy: TsdFile;
  begin
    Dummy := TsdFile.Create;
    try
      Dummy.FolderGuid := AFolderID;
      frmMain.Root.FAllFiles.Find(Dummy, Result);
    finally
      Dummy.Free;
    end;
  end;
// main
begin
  // Verify if there are any new files in the folder,
  // and it's subfolders and add these files

  // Try to locate the folder
  Folder := frmMain.Root.FolderByName(AFolderName);

  // For the status message:
  FTempFolderName := ExcludeTrailingPathDelimiter(AFolderName);

  // Add the folder if it does not exist
  if Folder = nil then
  begin

    Folder := TsdFolder.Create;
    Folder.FolderName := AFolderName;

    AOptions.AddHidden := FAddHidden;
    AOptions.AddSystem := FAddSystem;
    AOptions.GraphicsOnly := FGraphicsOnly;
    Folder.Options := AOptions;

    Folder.SetState(isNewItem, true);
    Folder.GetIconAndType(AIcon, Folder.FFolderType);
    frmMain.Root.FInserts.Add(Folder);
  end;

  // Clear all ffVerified flags of files in this folder
  Index := FirstFileWithFolderID(Folder.Guid);
  while (Index >= 0) and (Index < frmMain.Root.FAllFiles.Count) and
        IsEqualGuid(TsdFile(frmMain.Root.FAllFiles[Index]).FolderGuid, Folder.Guid) do
  begin
    // Clear the flag
    TsdFile(frmMain.Root.FAllFiles[Index]).SetState(isVerified, False);
    inc(Index);
  end;

  Folder.SetState(isVerified, True);
  inc(FFolderCount);

  // Check if the folder exists on disk
  if DirectoryExists(Folder.FolderName) then
  begin

    R := FindFirst(Folder.FolderName + FCurMask, faAnyFile, S);
    while R = 0 do
    begin

      if (S.Attr and faDirectory > 0) then
      begin
        // A directory
        if (S.Name = '.') then
        begin
          // Our folder
          Folder.FAttr := S.Attr;
          Folder.Modified := FileDateToDateTime(S.Time);
        end;

        if (S.Name <> '..') and (S.Name <> '.') then
        begin

          // This is a folder, scan subdirs if desired
          if FScanNewSubdirs or FScanKnownSubdirs then
          begin

            // Scan it and add it, only if known folder and scanknown on, or new and scannew on
            Sub := frmMain.Root.FolderByName(Folder.FolderName + S.Name);
            if (assigned(Sub) and FScanKnownSubdirs) or (not assigned(Sub) and FScanNewSubdirs) then
            begin

              ScanFolder(Folder.FolderName + S.Name);

            end else
            begin

              // Just add it if not there
              Sub := frmMain.Root.FolderByName(Folder.FolderName + S.Name);
              if not assigned(Sub) then
              begin
                Sub := TsdFolder.Create;
                Sub.Name := Folder.FolderName + S.Name;
                AOptions.AddHidden := FAddHidden;
                AOptions.AddSystem := FAddSystem;
                AOptions.GraphicsOnly := FGraphicsOnly;
                Sub.Options := AOptions;
                Sub.SetState(isNewItem, True);
                Sub.GetIconAndType(AIcon, Sub.FFolderType);
                Sub.FAttr := S.Attr;
                Sub.Modified := FileDateToDateTime(S.Time);
                frmMain.Root.FInserts.Add(Sub);
              end;

            end;
            inc(FFolderCount);
          end;
        end;

      end else
      begin

        // A File
        inc(FTotalCount);
        if (length(FCurFilter) = 0) or (Pos(ExtractFileExt(S.Name) + ';', FCurFilter) > 0) then
        begin
          ScanFile(S, Folder);
        end;

      end;

      // Flush
      if (integer(GetTickCount) - cScanFlushInterval) > FFlushTick then
      begin
        synchronize(FlushItems);
        FFlushTick := GetTickCount;
      end;

      // Progress
      if (integer(GetTickCount) - cProgressInterval) >= FTick then
      begin
        synchronize(DoProgress);
        FTick := GetTickCount;
      end;

      // Check pause mode - outside of locks
      if Status = psPausing then
        Pause;

      // Check user termination
      if Terminated then
        Break;


      R := FindNext(S);
    end;
    SysUtils.FindClose(S);

    // Check for deleted files in specific folder
    // Create a dummy file

    Index := FirstFileWithFolderID(Folder.Guid);
    while (Index >= 0) and (Index < frmMain.Root.FAllFiles.Count) and
          IsEqualGuid(TsdFile(frmMain.Root.FAllFiles[Index]).FolderGuid, Folder.Guid) do
    begin
      // Process file in folder
      AFile := TsdFile(frmMain.Root.FAllFiles[Index]);
      if not (isVerified in AFile.States) then
      begin
        if not FileExists(AFile.FileName) then
        begin
          AFile.SetStates([isDeleted, isVerified], True);
          frmMain.Root.FRemoves.Add(frmMain.Root.FAllFiles[Index]);
        end;
      end;
      inc(Index);
    end;

  end else
  begin

    // The directory does not exist or is inaccessible
    if DirectoryExists(Folder.ParentFolderName) then
    begin

      // The parent folder does exist so the folder is deleted, moved or renamed
      // so we remove it and all files in it
      Index := FirstFileWithFolderID(Folder.Guid);
      while (Index >= 0) and (Index < frmMain.Root.FAllFiles.Count) and
            IsEqualGuid(TsdFile(frmMain.Root.FAllFiles[Index]).FolderGuid, Folder.Guid) do
      begin
        frmMain.Root.FRemoves.Add(frmMain.Root.FAllFiles[Index]);
        inc(Index);
      end;
      frmMain.Root.FRemoves.Add(Folder);

    end else
    begin

      // The directory does not exist, could be inaccessible
      Folder.SetState(isNoAccess, True);
      Index := FirstFileWithFolderID(Folder.Guid);
      while (Index >= 0) and (Index < frmMain.Root.FAllFiles.Count) and
            IsEqualGuid(TsdFile(frmMain.Root.FAllFiles[Index]).FolderGuid, Folder.Guid) do
      begin
        TsdFile(frmMain.Root.FAllFiles[Index]).SetStates([isNoAccess, isVerified], True);
        inc(Index);
      end;
    end;

  end;
  // Clear statistical information for this folder
  if assigned(Folder) then
    Folder.RemoveProperty(prFolderStats);
end;

procedure TScanner.StartProgress;
begin
  FTick := GetTickCount;
end;

// Procedures

procedure RunScan(AFolder: string; IncludeNewSubdirs, IncludeKnownSubdirs: boolean; AMask, AFilter: string;
  OnClearItems: TNotifyEvent);
var
  Scanner: TScanner;
  ScanFolder: TScanFolder;
begin
  // Add the folder to the list
  ScanFolder := TScanFolder.Create;
  ScanFolder.FFolder := AFolder;
  ScanFolder.FIncludeNewSubdirs := IncludeNewSubdirs;
  ScanFolder.FIncludeKnownSubdirs := IncludeKnownSubdirs;
  ScanFolder.FMask := AMask;
  ScanFolder.FFilter := AFilter;
  glScanList.Add(ScanFolder);

  // Don't start the thread if it is already busy
  glScanLock.Enter;
  try
    if glScanBusy then
      exit
    else
      glScanBusy := True;
  finally
    glScanLock.Leave;
  end;

  try
    // Create a scanner
    Scanner := TScanner.Create(True, glProcessList);
    Scanner.Name := 'Folder scanner';
    //Scanner.FOptions := FFolderOptions;
    Scanner.FAddHidden := FFolderOptions.AddHidden;
    Scanner.FAddSystem := FFolderOptions.AddSystem;
    Scanner.FGraphicsOnly := FFolderOptions.GraphicsOnly;
    Scanner.Priority := FScanPriority;
    Scanner.OnClearItems := OnClearItems;
    Scanner.Resume;
  except
    glScanBusy := False;
  end;
end;

function IsScanBusy: boolean;
begin
  glScanLock.Enter;
  try
    Result := glScanBusy;
  finally
    glScanLock.Leave;
  end;
end;

initialization

  glScanLock := TCriticalSection.Create;
  glScanList := TScanList.Create;

finalization

  FreeandNil(glScanList);
  FreeAndNil(glScanLock);

end.
