{ Unit CopyFiles

  File move/copy commands using shell

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit CopyFiles;

interface

uses
  Classes, Windows, Controls, Dialogs, ShFileOp, ActiveX, SysUtils,
  sdItems, sdAbcTypes, sdAbcVars, sdAbcFunctions;

// Move items in AList to the folder AFolder. Items may be TFile or TFolder.
// Moves the file(s), and updates the items. Scanning is avoided.
procedure MoveInternal(Sender: TObject; AList: TList; AFolder: TsdFolder);

// this procedure will copy files and/or directories from AList to ATarget, and
// update all controls in ABCVM.

// Effect can be DROPEFFECT_COPY, DROPEFFECT_MOVE, DROPEFFECT_LINK

procedure CopyMoveFiles(Sender: TObject; AList: TStringList; ATarget: string; Effect: integer);

implementation

uses
  guiMain, sdRoots, sdScanFolders, guiPidlItems;

procedure MoveInternal(Sender: TObject; AList: TList; AFolder: TsdFolder);

// Move items in AList to the folder AFolder. Items may be TFile, TFolder or TPidlItem
// Moves the file(s), and updates the items. Scanning is avoided.

var
  i, ErrCount: integer;
  OldName, NewName: string;
  OldRoot, NewRoot: string;
  MustUpdatePidl: boolean;
  IsFolder: boolean;
  PidlFolder: TsdFolder;

// local
procedure PidlUpdated(APath: string);
begin
  if assigned(frmMain.Root.FBTree1) {and assigned(frmMain.Root.FBTree2)} then
  begin
    frmMain.Root.FBTree1.PidlFolderUpdate(Sender, APath);
    //frmMain.Root.FBTree2.PidlFolderUpdate(Sender, APath);
  end;
end;
// main
begin
  if not assigned(AFolder) then
    exit;
  // init
  ErrCount := 0;
  MustUpdatePidl := False;

  Inc(FShellNotifyRef);
  try
  for i := 0 to AList.Count - 1 do
  begin
    OldName := '';
    NewName := '';
    IsFolder := False;
    if (TObject(AList[i]) is TsdFile) then
    begin
      OldName := TsdItem(AList[i]).FileName;
      NewName := AFolder.FolderName + TsdItem(AList[i]).Name;
    end;
    if (TObject(AList[i]) is TsdFolder) then
    begin
      OldName := TsdItem(AList[i]).FileName;
      NewName := AFolder.FolderName + TsdFolder(AList[i]).Name;
      IsFolder := True;
    end;
    if (TObject(AList[i]) is TPidlItem) then
    begin
      OldName := ExcludeTrailingPathDelimiter(TPidlItem(AList[i]).FolderName);
      NewName := AFolder.FolderName + ExtractFileName(OldName);
      IsFolder := True;
    end;

    // Warn for folder move
    if IsFolder then
      if MessageDlg('You are about to move the folder to its new location'#13 +
        NewName + #13#13 + 'Are you sure?', mtWarning,
        [mbYes, mbNo, mbCancel, mbHelp], 0) <> mrYes then
        exit;

    // Valid result?
    if (Length(OldName) = 0) or (Length(NewName) = 0) or
       (NewName = OldName) then
      continue;

    // Call Windows MoveFile, also works on folders (but not to different drive)
    if MoveFile(pchar(OldName), pchar(NewName)) then
    begin

      // Pidl references a new folder ID
      if TObject(AList[i]) is TPidlItem then
      begin
        // A trick, we let AList[i] become the folder so we can smartly use the code below
        PidlFolder := frmMain.Root.FolderByName(TPidlItem(AList[i]).FolderName);
        if assigned(PidlFolder) then
          AList[i] := PidlFolder;
      end;

      // File references a new folder ID
      if TObject(AList[i]) is TsdFile then
        TsdFile(AList[i]).FolderGuid := AFolder.Guid;

      // Folder references a new folder ID
      if TObject(AList[i]) is TsdFolder then
      begin
        OldRoot := GetParentFolder(TsdFolder(AList[i]).FolderName);
        NewRoot := AFolder.FolderName;
        TsdFolder(AList[i]).FolderName := AFolder.FolderName + TsdFolder(AList[i]).Name;
        MustUpdatePidl := True;
      end;

      // Set update flag
      if TObject(AList[i]) is TsdItem then
        TsdItem(AList[i]).Update([ufListing]);

    end else
    begin

      // Unsuccesful move, so Error Message - only once
      if ErrCount = 0 then
      begin
        MessageDlg(Format(
          'ABC-View Manager could not move file'#13+
          '%s to folder %s.', [TsdItem(AList[i]).Name, NewName]),
          mtError, [mbOK, mbHelp], 0);
        inc(ErrCount);
      end;
    end;
  end;

  // Force an update now
  frmMain.Root.FlushBatchedItems;
  // If we must update the pidl then here, after flushing
  if MustUpdatePidl then
  begin
    if length(OldRoot) > 0 then  PidlUpdated(OldRoot);
    if length(NewRoot) > 0 then  PidlUpdated(NewRoot);
  end;

  finally
    Dec(FShellNotifyRef);
  end;
end;

procedure CopyMoveFiles(Sender: TObject; AList: TStringList; ATarget: string; Effect: integer);
var
  i: integer;
  Shell: TShellFileOp;
  UpdateSource,
  UpdateTarget,
  MoveCopyDir,
  UpdatePidl,
  SourceInCollection,
  TargetInCollection: boolean;
  SourceFolders,
  SourceMasks,
  TargetFolders,
  TargetMasks: TStringList;
begin
  // nothing to do?
  if AList.Count = 0 then
    exit;

  // init
  UpdateSource := False;
  UpdateTarget := False;
  SourceInCollection := False;
  TargetInCollection := False;
  MoveCopyDir := False;
  UpdatePidl := False;

  // Switch off watchdog
  inc(FShellNotifyRef);
  try
    // shell operation
    Shell := TShellFileOp.Create(frmMain);
    Shell.RenameOnCollision := True;
    SourceFolders := TStringList.Create;
    SourceMasks := TStringList.Create;
    TargetFolders := TStringList.Create;
    TargetMasks := TStringList.Create;
    try
      // Add the files
      for i := 0 to AList.Count - 1 do
      begin
        // Folder? just include the backslash
        if DirectoryExists(AList[i]) then
        begin
          AList[i] := IncludeTrailingPathDelimiter(AList[i]);
          MoveCopyDir := True;
        end;
        if (Effect = DROPEFFECT_LINK) or
           assigned(frmMain.Root.FolderByName(ExtractFileDir(AList[i]))) then
        begin
          SourceFolders.Add(ExtractFileDir(AList[i]));
          SourceMasks.Add(ExtractFileName(AList[i]));
          SourceInCollection := assigned(frmMain.Root.FolderByName(ExtractFileDir(AList[i])));
        end;
        if length(ATarget) > 0 then
        begin
          TargetFolders.Add(ATarget);
          TargetMasks.Add(ExtractFileName(AList[i]));
          TargetInCollection := assigned(frmMain.Root.FolderByName(ATarget));
        end;
        Shell.AddTarget(ExcludeTrailingPathDelimiter(AList[i]));
      end;

      case Effect of
      DROPEFFECT_MOVE:
        begin
          UpdateSource := SourceInCollection;
          UpdateTarget := TargetInCollection;
          if length(ATarget) > 0 then
          begin
            UpdatePidl := MoveCopyDir;
            Shell.MoveFiles(ATarget);
          end;
          frmMain.StatusMessage(Sender, Format('Moved %d items', [AList.Count]), suPanel1);
        end;
      DROPEFFECT_COPY:
        begin
          UpdateTarget := TargetInCollection;
          if length(ATarget) > 0 then
          begin
            UpdatePidl := MoveCopyDir;
            Shell.CopyFiles(ATarget);
          end;
          frmMain.StatusMessage(Sender, Format('Copied %d items', [AList.Count]), suPanel1);
        end;
      DROPEFFECT_LINK:
        begin
          UpdateSource := True;
          frmMain.StatusMessage(Sender, Format('Creating reference to %d items', [AList.Count]), suPanel1);
        end;
      end;//case

      // Updates
      if UpdatePidl then
        if assigned(frmMain.Root.FBTree1) then
        begin
          frmMain.Root.FBTree1.PidlFolderUpdate(Sender, ATarget);
        end;
      if UpdateSource then
        for i := 0 to SourceFolders.Count - 1 do
          RunScan(SourceFolders[i], False, False, SourceMasks[i], '',
            frmMain.RootClearBatchedItems);
      if UpdateTarget then
        for i := 0 to TargetFolders.Count - 1 do
          RunScan(TargetFolders[i], False, False, TargetMasks[i], '',
            frmMain.RootClearBatchedItems);

    finally
      Shell.Free;
      SourceFolders.Free;
      SourceMasks.Free;
      TargetFolders.Free;
      TargetMasks.Free;
    end;
  finally
    // Turn watchdog on again
    dec(FShellNotifyRef);
  end;
end;

end.
