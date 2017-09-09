{ Unit sdRoots

  This unit implements the TRoot object and its direct methods. This object is
  used to store all basic Item, File, Folder, Group and Series information.

  Project: ABC-View Manager

  Initial release: 20-12-2000

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit sdRoots;

{$I+} // Turn on I/O exception handling in this unit

interface

uses
  Windows, Classes, SysUtils, Graphics, Forms, ComCtrls, Contnrs,
  ShFileOp, ShellAPI, RxNotify, SyncObjs, Dialogs,
  Messages, Controls, ActnList, ImgList, ToolWin, ExtCtrls, Math, sdStreamableData,
  sdSorter, ItemLists, Filters, sdItems, Pictures,
  guiFolderOptions, BrowseTrees, FileThreads, sdAbcTypes, sdAbcVars;

type


  TStatusEvent = procedure(Sender: TObject; AMessage: string; Panel: integer) of object;

  // TsdRoot desecends from TItemList and is the basic container of files, folders,
  // groups and series. Refer to the global variable Root.
  TsdRoot = class(TItemList)
  private
    // Thread that indexes the new files
    FFileThread: TFileThread;
    FIsChanged: boolean;
    FIsFlushing: boolean;
    FMngr: TPictureMngr;
    FMustIndex: boolean;
    FOldTick: cardinal;
    FOnStatusMessage: TStatusEvent;
    FTmpThumbs: TStream; // Temporary thumbnail stream
    FTmpThumbsName: string;
    FSavThumbs: TStream; // Saved thumbnail stream
    FSavThumbsName: string;
    FThumbFrag: int64;
    FThumbLock: TCriticalSection;
  protected
    procedure DoClearItems; override;
    procedure DoRemoveItems(AList: TList); override;
    procedure RootChanged(Sender: TObject);
    procedure SetMustIndex(Value: boolean);
  public
    FInserts: TList;
    FRemoves: TList;
    FUpdates: TList;

    // AllFolders
    FAllFolders: TTypeFilter;

    // AllFiles
    FAllFiles: TTypeFilter;

    // used to have two browsetree objects but now only one:
    FBTree1: TBrowseTree;

    property IsChanged: boolean read FIsChanged write FIsChanged;
    property IsFlushing: boolean read FIsFlushing;
    // Mngr points to a TPictureMngr object that is managing all picture bitmaps
    // throughout the application.
    property Mngr: TPictureMngr read FMngr;
    // MustIndex is a flag that indicates that FileThread must start indexing
    property MustIndex: boolean read FMustIndex write SetMustIndex;
    // Connect to OnStatusMessage to get
    property OnStatusMessage: TStatusEvent read FOnStatusMessage write FOnStatusMessage;
    property TmpThumbs: TStream read FTmpThumbs;
    property SavThumbs: TStream read FSavThumbs;
    constructor Create;
    destructor Destroy; override;
    // Call Add UpdateItem to add an item to the update list. These items will be
    // updated on the next RootUpdate call
    procedure AddUpdateItem(AItem: TsdItem);
    // Do a Batch Rename on all items in Items. The list points to TBatchRenameItem objects.
    procedure BatchRename(Items: TList);
    // Do a Batch Touch filedate for all items in Items. The list points to a TBatchChangeFileDate
    // object
    procedure BatchTouchDate(Items: TList);
    // Clear the batched insert/remove/update items
    procedure ClearBatchedItems;
    procedure FlushBatchedItems;
    // Call DeleteItems to physically delete the files in AList from the disk. Use
    // caution with this procedure! The items are removed from the root list as well,
    // and all subsequent controls are updated. if FUseRecycleBin is true, files will
    // be put in the recycle-bin.
    procedure DeleteItems(Sender: TObject; AList: TList; var Confirm: boolean);
    procedure DoStatusMessage(Sender: TObject; AMessage: string);
    // FileByName returns the file if found in the list, and returns nil if
    // not found.
    function FileByName(AFilename: string): TsdFile;
    // FolderByID returns a folder if the reference ID is found, or nil if not.
    function  FolderByID(const AFolderGuid: TGUID): TsdFolder;
    // FolderByName returns the folder if found in the list, and returns nil
    // if not found.
    function FolderByName(AFoldername: string): TsdFolder;
    // MonitorChange is called by the folder's Monitor object whenever a folder's
    // contents is changed.
    procedure ReadComponents(S: TStream); override;
    // Call this procedure to schedule the items in Items for removal a.s.a.p.
    procedure RemoveItemsAsync(Sender: TObject; Items: TList);
    // Call RootUpdate to flush all batched insert/remove/update requests and
    // generate a fully qualified list
    procedure RootUpdate(Sender: TObject);
    // Thumbnail streams
    procedure ThumbstreamSave(AFileName: string);
    procedure ThumbstreamOpen(AFileName: string);
    procedure ThumbLock;
    procedure ThumbUnlock;
    procedure WriteComponents(S: TStream); override;
  end;

const

  // Root update interval (in msec)
  cRootUpdateInterval = 5000;

  // Thumbnail file fragmentation limit
  cThumbFragLimit = 1048576; {1Mb}

implementation

uses
  guiMain, guiDeleteFile, Zipfiles, guiAddFolder,
  guiShow, Expanders, sdProcessThread, Thumbnails,
  sdProperties, guiActions, sdScanFolders, guiRenameFiles, guiChangeFileDate,
  DropLists;

{ TsdRoot }

procedure TsdRoot.DoStatusMessage(Sender: TObject; AMessage: string);
begin
  if assigned(FOnStatusMessage) then
    FOnStatusMessage(Sender, AMessage, suPanel1);
end;

procedure TsdRoot.ClearBatchedItems;
begin
  if assigned(FInserts) then FInserts.Clear;
  if assigned(FRemoves) then FRemoves.Clear;
  if assigned(FUpdates) then FUpdates.Clear;
end;

procedure TsdRoot.FlushBatchedItems;
// This routine will flush all batched items. NEVER call this routine when
// the scanner is running (IsScanBusy = True)
begin
  if FIsFlushing then
    exit; // we're already busy, so let the user wait till next round

  FIsFlushing := True;
  try

    // Inserts
    if FInserts.Count > 0 then
    begin
      InsertItems(Self, FInserts);
      // Do we display the last one?
      if FFocusNew then
        if assigned(frmMain.View) and (FInserts.Count > 0) then
          frmMain.View.CurItemID := TsdItem(FInserts[FInserts.Count - 1]).Guid;
      FInserts.Clear;

      // Restart the filethread so new items are indexed
      MustIndex := True;
    end;

    // Removes
    if FRemoves.Count > 0 then
    begin
      RemoveItems(Self, FRemoves);
      FRemoves.Clear;
    end;

    // Updates
    if FUpdates.Count > 0 then
    begin

      UpdateItems(Self, FUpdates);

      // Clear the list
      FUpdates.Clear;
    end;
  finally
    FIsFlushing := False;
  end;
end;

procedure TsdRoot.RemoveItemsAsync(Sender: TObject; Items: TList);
var
  i: integer;
  OldCursor: TCursor;
begin
  if not assigned(Items) then
    exit;

  if FIsFlushing then
  begin
    raise Exception.Create('Call to Remove_Async while flushing');
  end;
  
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  FIsFlushing := True;
  try
    // Copy items to remove list
    for i := 0 to Items.Count - 1 do
      FRemoves.Add(Items[i]);
    Items.Clear;
    // Schedule a flush
    frmMain.tmMain.OnTimer := frmMain.FlushTimer;
    frmMain.tmMain.Interval := 100;
    frmMain.tmMain.Enabled := True;
  finally
    FIsFlushing := False;
    Screen.Cursor := OldCursor;
  end;
end;

procedure TsdRoot.DoClearItems;
begin
  inherited;

  // Make sure to clear batch lists
  ClearBatchedItems;

  //Make sure to clear thumbnail list
  ThumbLock;
  try
    if assigned(FTmpThumbs) then
      FTmpThumbs.Size := 0;
  finally
    ThumbUnlock;
  end;
end;

procedure TsdRoot.DoRemoveItems(AList: TList);
var
  i: integer;
begin
  inherited;
  if assigned(AList) then
    for i := 0 to AList.Count - 1 do
    begin
      FInserts.Remove(AList[i]);
      FRemoves.Remove(AList[i]);
      FUpdates.Remove(AList[i]);
    end;
end;

procedure TsdRoot.RootChanged(Sender: TObject);
begin
  // We must save
  IsChanged := true;
end;

procedure TsdRoot.SetMustIndex(Value: boolean);
begin
  FMustIndex := Value;
  // Wakeup call
  if FMustIndex and assigned(FFileThread) then
    FFileThread.Status := psRun;
end;

constructor TsdRoot.Create;
begin
  // We own the objects
  inherited Create(True);

  // Batched insert/remove/update
  FInserts := TList.Create;
  FRemoves := TList.Create;
  FUpdates := TList.Create;

  // Drop List
  DropList := TDropList.Create;

  // Thumbnails
  FTmpThumbsName := frmMain.GetNewTempFile;
  DeleteFile(FTmpThumbsName);
  FTmpThumbs := TFileStream.Create(FTmpThumbsName, fmCreate or fmShareDenyWrite);
  FThumbLock := TCriticalSection.Create;

  // Add our own update procedure per default
  OnUpdate := RootChanged;

  // Create AllFolders
  FAllFolders := TTypeFilter.Create;
  FAllFolders.Name := 'complete folder list';
  FAllFolders.AcceptedTypes := [itFolder];
  // Create the sort method for AllFolders
  FAllFolders.SortMethod := TSortMethod.Create;
  // Volume and Name must match!
  FAllFolders.SortMethod.AddMethod(smByVolumeLabel, sdAscending);
  FAllFolders.SortMethod.AddMethod(smByName, sdAscending);
  ConnectNode(FAllFolders);

  // Create AllFiles
  FAllFiles := TTypeFilter.Create;
  FAllFiles.Name := 'complete file list';
  FAllFiles.AcceptedTypes := [itFile];
  // Create the sort method for AllFiles
  FAllFiles.SortMethod := TSortMethod.Create;
  // AllFiles is first sorted by Folder ID, then by name. The lastly added
  // method will be the topmost sorting method
  FAllFiles.SortMethod.AddMethod(smByName, sdAscending);
  FAllFiles.SortMethod.AddMethod(smByFolderID, sdAscending);
  ConnectNode(FAllFiles);

  // Create two browsetree objects
  FBTree1 := TBrowseTree.Create(frmMain.Browser1.vstBrowse, frmMain.ItemView1);
  FBTree1.Source := Self;
  FAllFolders.ConnectNode(FBTree1.Mngr); //-> this seems the culprit

  //FBTree2 := TBrowseTree.Create(frmMain.Browser2.vstBrowse, frmMain.ItemView2);

  // To do: change into a ThreadedFilter
  // Setup FileThread
  FMustIndex := true;
  FFileThread := TFileThread.Create(True, glProcessList);
  (FFileThread as TFileThread).Name := 'CRC and thumb';
  (FFileThread as TFileThread).Priority := tpLower;
  (FFileThread as TFileThread).Resume;

  // Create the picture manager
  FMngr := TPictureMngr.Create(Self);
  ConnectNode(FMngr);
end;

destructor TsdRoot.Destroy;
begin
  // Terminate picture manager
  FreeAndNil(FMngr);

  // The filethread is already stopped
  // at this point with StopFileThread
  FFileThread := nil;

  FreeAndNil(FBTree1);
  //FreeAndNil(FBTree2);

  FreeAndNil(FAllFolders);
  FreeAndNil(FAllFiles);

  FreeAndNil(DropList);
  FreeAndNil(FInserts);
  FreeAndNil(FRemoves);
  FreeAndNil(FUpdates);

  if assigned(FSavThumbs) then FreeAndNil(FSavThumbs);
  FreeAndNil(FTmpThumbs);
  FreeAndNil(FThumbLock);

  inherited Destroy;
end;

procedure TsdRoot.AddUpdateItem(AItem: TsdItem);
begin
  if not assigned(FUpdates) then
    exit;
  if FIsFlushing then
    exit;

  if not FUpdates.IndexOf(AItem) >= 0 then
  begin
    FUpdates.Add(AItem);
    IsChanged := True;
  end;
end;

procedure TsdRoot.BatchRename(Items: TList);
var
  i: integer;
  Errors: boolean;
  BR: TBatchRenameItem;
begin
  // Turn off ShellNotify for a while
  inc(FShellNotifyRef);
  Errors := False;
  try
    for i := 0 to Items.Count - 1 do
    begin
      BR := TBatchRenameItem(Items[i]);
      // Perform the file rename
      case BR.Ref.ItemType of
      itFile:
        begin
          if RenameFile(BR.Folder + BR.OldName, BR.Folder + BR.NewName) then
          begin
            BR.Ref.Name := BR.NewName;
            BR.Ref.Update([ufGraphic, ufListing]);
          end else
            Errors := True;
        end;
      // We must add other renames here later
      end;//case
    end;
    if Errors then
      MessageDlg('There were errors while renaming the file(s)', mtWarning,
        [mbOK, mbHelp], 0);
  finally
    // Turn on Shell Notify again
    dec(FShellNotifyRef);
  end;
end;

procedure TsdRoot.BatchTouchDate(Items: TList);
var
  i: integer;
  Handle: integer;
  Errors: boolean;
  BC: TBatchChangeDateItem;
begin
  // Turn off ShellNotify for a while
  inc(FShellNotifyRef);
  Errors := False;
  try
    for i := 0 to Items.Count - 1 do
    begin
      BC := TBatchChangeDateItem(Items[i]);
      // Perform the file rename
      case BC.Ref.ItemType of
      itFile:
        begin
          TsdFile(BC.Ref).Modified := BC.NewDate;
          Handle := FileOpen(TsdFile(BC.Ref).FileName, fmOpenWrite + fmShareDenyNone);
          if Handle > 0 then
          begin
            FileSetDate(Handle, DateTimeToFileDate(BC.NewDate));
            FileClose(Handle);
          end else
            Errors := True;
        end;
      // We must add other date changers here later
      end;//case
    end;
    if Errors then
      MessageDlg('There were errors while changing the filedate of the file(s)', mtWarning,
        [mbOK, mbHelp], 0);
  finally
    // Turn on Shell Notify again
    dec(FShellNotifyRef);
  end;
end;

procedure TsdRoot.DeleteItems(Sender: TObject; AList: TList; var Confirm: boolean);
var
  FileList,
  FolderList,
  UndoList: TList;
  i: integer;
  ShFile: TShellFileOp;
  AFile: TsdFile;
  ProtectIsWarned: boolean;
  Dialog: TfrmDeleteFiles;
  DeleteMethod: TDeletionMethod;
  NoRmDirCount: integer;
begin
  Confirm := False;
  if not assigned(AList) or (AList.Count = 0) then
    exit; // nothing to do

  // Init
  ProtectIsWarned := false;

  LockRead;
  FileList := TList.Create;
  FolderList := TList.Create;
  UndoList := TList.Create;

  // Turn off ShellNotify for a while
  inc(FShellNotifyRef);
  try

    // Expand the list to include items that are related
    ExpandSelectionMerge(AList, Self, emRemoving);

    // Check the list
    for i := 0 to AList.Count - 1 do
    begin
      case TsdItem(AList[i]).ItemType of
      // Files
      itFile:
        begin
          AFile := TsdFile(AList[i]);

          if (isReadOnly in AFile.States) then
          begin
            // Tell user
            if FProtectWarn and not ProtectIsWarned then
            begin
              MessageDlg(Format(
                  'You are trying to delete the read-only file:'#13+
                  '"%s". This is not allowed. This file will be'#13+
                  'skipped, but the references are removed from the'#13+
                  'catalog.', [AFile.Name]),
                mtWarning, [mbOK, mbHelp], 0);
              ProtectIsWarned := true;
              end;
            end else
            begin
              // A valid file, so add it to the list
              FileList.Add(AList[i]);
            end;
        end;

      // Folders
      itFolder: FolderList.Add(AList[i]);

      // Series - future work?
      // Groups - future work?

      end;//case
    end;

    // Check with the user
    Confirm := false;
    if FUseRecycleBin then
      DeleteMethod := dmRecyclebin
    else
      DeleteMethod := dmDelete;

    if (FileList.Count = 1) and FSingleFileNoWarn then
      Confirm := true
    else
    begin
      case FDeleteConfirm of
      dcNever:
        Confirm := true;
      dcMessage:
        if FileList.Count=1 then
        begin

          // Delete one item
          if MessageDlg(
            Format('Do you really want to delete file'+#13#10+'%s from the disk?',
            [TsdFile(AList[0]).Filename]),
            mtWarning, mbYesNoCancel, 0) = mrYes then
          begin
            Confirm := true;
          end;

        end else
        begin

          // Delete multiple items
          if MessageDlg(
            Format('Do you really want to delete %d files'+#13#10+'(%s to %s) from the disk?',
            [AList.Count, TsdFile(AList[0]).FileName, TsdFile(AList[AList.Count-1]).FileName]),
            mtWarning, mbYesNoCancel, 0) = mrYes then
          begin
            Confirm := true;
          end;

        end;
      dcDialog:
        begin
          // Open the dialog
          Application.CreateForm(TfrmDeleteFiles, Dialog);
          try
            Dialog.FileList := FileList;
            Dialog.UndoList := UndoList;
            if Dialog.ShowModal = mrOK then
            begin
              Confirm := True;
            end;
            DeleteMethod := Dialog.FMethod;
          finally
            Dialog.Free;
          end;

        end;
      end;//case
    end;

    if Confirm then
    begin

      Screen.Cursor := crHourGlass;
      case DeleteMethod of
      dmRecycleBin, dmDelete, dmMovetoArchive:
        begin
          // Delete the files
          ShFile := TShellFileOp.Create(nil);
          try
            ShFile.NoConfirmation := true;
            ShFile.Animate := true;
            ShFile.RenameOnCollision := true; // for move case
            ShFile.AutoMakeDir := true;

            for i := 0 to FileList.Count - 1 do
              ShFile.AddTarget(TsdFile(FileList[i]).Filename);

            // The actual deletion: put in recycle bin or completely delete
            try
              case DeleteMethod of
              dmRecycleBin:    ShFile.RecycleFiles;
              dmDelete:        ShFile.DeleteFiles;
              dmMovetoArchive: ShFile.MoveFiles(FArchiveFolder);
              end;
            except
              On E: Exception do
              begin
                MessageDlg(
                  'The shell could not complete the operation!'#13#13 +
                  'reason: '#13 + E.Message,
                  mtWarning, [mbOK], 0);
              end;
            end;

          finally
            ShFile.Free;
          end;

        end;
      dmMovetoZip:
        MoveToZip(FileList, FZipFileName, DoStatusMessage);
      end;//case
      Screen.Cursor := crDefault;

      // remove any folders that were selected, but only if they're empty
      NoRmDirCount := 0;
      for i := 0 to FolderList.Count - 1 do
      begin
        try
          RmDir(TsdFolder(FolderList[i]).Name);
        except
          inc(NoRmDirCount);
        end;
      end;

      if NoRmDirCount > 0 then
        ShowMessage(Format(
          'ABC-View did not remove %d folders because'#13#10 +
          'they still contain data.', [NoRmDirCount]));

      // Add the files that were consequentially deleted to the remove list
      for i := 0 to FileList.Count - 1 do
        if AList.IndexOf(FileList[i]) < 0 then
          AList.Add(FileList[i]);

      // Remove the items that were undone by user from the remove list
      for i := 0 to UndoList.Count - 1 do
        AList.Remove(UndoList[i]);

      // Signal ourselves
      RemoveItems(Self, AList);

    end;

  finally
    UnlockRead;
    FileList.Free;
    FolderList.Free;
    UndoList.Free;
    // Turn on Shell Notify again
    dec(FShellNotifyRef);
  end;

end;

function TsdRoot.FileByName(AFilename: string): TsdFile;
var
  Index: integer;
  Folder: TsdFolder;
  AFile: TsdFile;
  Full: string;
begin
  Result := nil;
  Full := ExpandUNCFileName(AFilename);
  Folder := FolderByName(ExtractFileDir(Full));
  if assigned(Folder) then
  begin
    AFile := TsdFile.Create;
    try
      AFile.Name := ExtractFileName(Full);
      AFile.FolderGuid := Folder.Guid;
      if FAllFiles.Match(AFile, Index) then
        Result := TsdFile(FAllFiles.Items[Index]);
    finally
      AFile.Free;
    end;
  end;
end;

function TsdRoot.FolderByID(const AFolderGuid: TGUID): TsdFolder;
begin
  Result := TsdFolder(FAllFolders.ItemByGuid(AFolderGuid));
end;

function TsdRoot.FolderByName(AFoldername: string): TsdFolder;
var
  Index: integer;
  Folder: TsdFolder;
begin
  Result := nil;
  if length(AFolderName) = 0 then
    exit;
  Folder := TsdFolder.Create;
  try
    Folder.FolderName := AFolderName;
    if FAllFolders.Match(Folder, Index) then
      Result := TsdFolder(FAllFolders.Items[Index]);
  finally
    Folder.Free;
  end;
end;

procedure TsdRoot.ReadComponents(S: TStream);
var
  i: integer;
  Ver: byte; // version on disk
  Count: integer;
  List: TList;
  Identifier: word;
  ItemType: TItemType;
  Item: TsdItem;
begin

  // Read Version No
  StreamReadByte(S, Ver);

  // Prepare Load Items
  StreamReadInteger(S, Count);

  List := TList.Create;
  List.Capacity := Count;

//  FNextUniqueID := 1;

  // Load all items in one loop
  for i := 0 to Count - 1 do
  begin

    StreamReadWord(S, Identifier);
    ItemType := TItemType(Identifier);

    // Create correct type
    case ItemType of
    itItem:   Item := TsdItem.Create;
    itFile:   Item := TsdFile.Create;
    itFolder: Item := TsdFolder.Create;
    itGroup:  Item := TsdGroup.Create;
    itSeries: Item := TsdSeries.Create;
    else
      // Future support?
      Item := TsdItem.Create;
    end;

    // Load the item
    Item.ReadComponents(S);

    List.Add(Item);
  end;

  // Assign the list
  AssignItems(Self, List);
  List.Free;

end;

procedure TsdRoot.RootUpdate(Sender: TObject);
// This procedure is called whenever an update should occur in Root.
begin
  if not glAutoFlush then
    exit;
  if GetTickCount - FOldTick > cRootUpdateInterval then
  begin
    // No update if the scanner is running!
    if not IsScanBusy then
      // OK, safe to flush the batch
      FlushBatchedItems;
    FOldTick := GetTickCount;
  end;
end;

procedure TsdRoot.ThumbstreamSave(AFileName: string);
var
  i, ACount, Next: integer;
  Thumb: TprThumbnail;
  FOldName,
  NewFilename: string;
  S, NewThumbs: TStream;
begin
  try
    // Not a valid save name
    if length(AFileName) = 0 then
      exit;

    // Old and new names
    FOldName := FSavThumbsName;
    if length(FOldName) = 0 then
      FOldName := AFileName;
    FSavThumbsName := AFileName;

    // Do we have fragmentation?
    if (FThumbFrag > cThumbFragLimit) or (FOldName <> FSavThumbsName) then
    begin

      // Fragmented case -> rewrite completely

      // Create a file with name *.tmp
      NewFilename := ChangeFileExt(FSavThumbsName, '.tmp');

      // Delete leftover junk
      if FileExists(NewFileName) then
        DeleteFile(NewFileName);

      // New destination stream
      if not FileExists(NewFileName) then
      begin

        NewThumbs := TFileStream.Create(NewFilename, fmCreate or fmShareDenyWrite);
        try
          for i := 0 to Count - 1 do
          begin
            if (i mod 100) = 0 then
              DoStatusMessage(Self, Format('Storing thumbnails... %3.1f%%', [(i + 1) / count * 100]));
            Thumb := TprThumbnail(Items[i].GetProperty(prThumbnail));
            if assigned(Thumb) then
            begin
              S := TMemoryStream.Create;
              try
                // Load thumbnail
                Thumb.LoadStream(S);
                ACount := S.Size;
                if ACount > 0 then
                begin
                  // Save it to the new (temp) stream
                  Thumb.Pos := NewThumbs.Position;
                  S.Seek(0, soFromBeginning);
                  Next := Thumb.Pos + sizeof(integer)*2 + ACount;
                  NewThumbs.Write(Next, sizeof(integer));
                  NewThumbs.Write(ACount, sizeof(integer));
                  NewThumbs.CopyFrom(S, ACount);
                  Thumb.IsTemporary := False;
                end else
                begin
                  // No length indicates error in Thumb, so remove it
                  Items[i].RemoveProperty(prThumbnail);
                end;
              finally
                S.Free;
              end;
            end;
          end;
        finally
          NewThumbs.Free;
        end;

        // Now try to delete the original
        if assigned(FSavThumbs) then
          FreeAndNil(FSavThumbs);

        // Delete the original thumbnail cache file
        DeleteFile(FSavThumbsName);

        // And rename the temp to original
        RenameFile(NewFileName, FSavThumbsName);
      end;
    end else
    begin

      // Unfragmented case, also oldname=newname
      if assigned(FSavThumbs) then
      begin
        FSavThumbs.Free;
        FSavThumbs := TFileStream.Create(FSavThumbsName, fmOpenReadWrite or fmShareDenyWrite);
      end else
      begin
        FSavThumbs := TFileStream.Create(FSavThumbsName, fmCreate or fmShareDenyWrite)
      end;
      FSavThumbs.Seek(0, soFromEnd);

      for i := 0 to Count - 1 do
      begin
        if (i mod 100) = 0 then
          DoStatusMessage(Self, Format('Storing thumbnails... %3.1f%%', [(i + 1) / count * 100]));
        Thumb := TprThumbnail(Items[i].GetProperty(prThumbnail));
        // Append the temporary items to the saved stream
        if assigned(Thumb) and Thumb.IsTemporary then
        begin
          S := TMemoryStream.Create;
          try
            // Load thumbnail
            Thumb.LoadStream(S);
            ACount := S.Size;
            if ACount > 0 then
            begin
              // Save it to the original stream
              Thumb.Pos := FSavThumbs.Position;
              S.Seek(0, soFromBeginning);
              Next := Thumb.Pos + sizeof(integer)*2 + ACount;
              FSavThumbs.Write(Next, sizeof(integer));
              FSavThumbs.Write(ACount, sizeof(integer));
              FSavThumbs.CopyFrom(S, ACount);
              Thumb.IsTemporary := False;
             end else
             begin
              // No length indicates error in Thumb, so remove it
              Items[i].RemoveProperty(prThumbnail);
            end;
          finally
            S.Free;
          end;
        end;
      end;
    end;
  finally
    if assigned(FTmpThumbs) then
      FTmpThumbs.Size := 0;
    if assigned(FSavThumbs) then
      FreeAndNil(FSavThumbs);
  end;
end;

procedure TsdRoot.ThumbstreamOpen(AFileName: string);
var
  i: integer;
  Thumb: TprThumbnail;
begin
  if assigned(FSavThumbs) then
    FreeAndNil(FSavThumbs);
  try
    // Open it
    FSavThumbsName := AFileName;
    // Create a zero length reference
    if not FileExists(AFileName) then
    begin
      FSavThumbs := TFileStream.Create(FSavThumbsName, fmCreate or fmShareDenyWrite);
      FSavThumbs.Free;
    end;
    // Open as read-only
    FSavThumbs := TFileStream.Create(FSavThumbsName, fmOpenRead or fmShareDenyWrite);

    // After the loop FThumbFrag will contain the number of fragmented bytes
    FThumbFrag := FSavThumbs.Size;

    // Check our current items!
    for  i:= 0 to Count - 1 do
    begin
      if (Items[i].ItemType in [itFile]) then
      begin
        Thumb := TprThumbnail(Items[i].GetProperty(prThumbnail));
        if assigned(Thumb) then
        begin
          if Thumb.IsTemporary or (Thumb.Pos < 0) or (Thumb.Pos >= FSavThumbs.Size) then
            // Remove thumbnail reference
            Items[i].IsThumbed := False
          else
            // Substract existing record size from FThumbFrag
            Dec(FThumbFrag, Thumb.StreamSize + 2 * SizeOf(Integer));
        end;
      end else begin
        Items[i].SetState(isThumbDone, False);
        end;
    end;

  except
    // We cannot open or create
    FSavThumbs := nil;
  end;
end;

procedure TsdRoot.ThumbLock;
begin
  if assigned(FThumbLock) then
    FThumbLock.Enter;
end;

procedure TsdRoot.ThumbUnlock;
begin
  if assigned(FThumbLock) then
    FThumbLock.Leave;
end;

procedure TsdRoot.WriteComponents(S: TStream);
var
  i: integer;
begin
  // Write Version No
  StreamWriteByte(S, 10);

  // Save Item list

  StreamWriteInteger(S, Count);

  LockRead;
  try

    for i := 0 to Count - 1 do
    begin

      // Save type info
      StreamWriteWord(S, ord(Items[i].ItemType));

      // Save each Item
      Items[i].WriteComponents(S);
    end;

  finally
    UnlockRead;
  end;

end;

end.
