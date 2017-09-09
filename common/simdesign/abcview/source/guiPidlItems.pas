{ unit PidlItems

  A generic folder item that is used to browse folders and other pidl's in the
  browser window.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiPidlItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BrowseTrees, sdItems, ShellUtilities, ShlObj, VirtualTrees,
  Contnrs, ComCtrls, StdCtrls, ActiveX, DropSource, sdSortedLists, sdAbcVars,
  sdAbcFunctions, guiFilterFrame;

type

  TPidlFrame = class(TFilterFrame)
    pcPidl: TPageControl;
    tsOptions: TTabSheet;
    tsProperties: TTabSheet;
    chbShowSubItems: TCheckBox;
  private
  public
    procedure DlgToFilter; override;
    procedure FilterToDlg; override;
  end;

  TPidlItem = class(TBrowseItem)
  private
    FChildrenInitialized: boolean; // indicates if children are read
    FFolderGuid: TGUID;      // Reference to the folder that is represented
    FNameSpace: TNameSpace;  // Namespace object (PIDL wrapper)
    FFoldersAccept: TSortedList;
    FFoldersDeny: TSortedList;
    FPage: integer;  // Active Page index in PidlFrame
    FShowSubItems: boolean; // Show the subfolder items too
    FVerified: boolean; // Used as verification flag in update
  protected
    procedure ConstructSubNSList(NSItems: TList);
    function EnumerateSubNS(
      APIDL: PItemIDList; AParent: TNamespace; Data: pointer; var Terminate: Boolean): Boolean;
    function GetChildCount: integer; override;
    function GetDragImage: integer; override;
    function GetDragTypes: TDragTypes; override;
    function GetDrive: string; virtual;
    procedure InitializeChildren; virtual;
    procedure SetNameSpace(AValue: TNameSpace);
    function GetPropID: word; override;
  public
    destructor Destroy; override;
    procedure AcceptDrop(var Effect: integer); override;
    function AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean; override;
    procedure AddSubPidl(SubPathName: string);
    function CheckState: TCheckState; override;
    function CheckType: TCheckType; override;
    procedure ClearSubNS;
    procedure CreateFilterParams; override;
    // Create a list of collection folders belonging to this Pidl
    procedure CreateFolderList(AList: TList; IncludeChildren: boolean); virtual;
    // Create a list of collection items belonging to this Pidl (folders, files, etc)
    procedure CreateItemList(AList: TList; IncludeChildren: boolean); virtual;
    procedure DoRename(ANewName: string); override;
    function FindSubByFolderName(AFolderName: string): TPidlItem; virtual;
    procedure FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean); virtual;
    // Foldername returns the name of the folder including the trailing \
    function FolderName: string;
    function GetEmptyWarning: string; override;
    function IsDrive: boolean;
    function IsReadOnly: boolean;
    // RenamePidl will check if the newname exists and then accordingly
    // change NS and outer appearance. NO folder is renamed physically.
    procedure RenamePidl(NewPathName: string);
    // Update Namespace
    procedure UpdateSubNS;
    property ChildrenInitialized: boolean read FChildrenInitialized;
    property Drive: string read GetDrive;
    property FolderGuid: TGUID read FFolderGuid write FFolderGuid;
    property NameSpace: TNameSpace read FNameSpace write SetNameSpace;
    property ShowSubItems: boolean read FShowSubItems write FShowSubItems;
  end;

implementation

uses
  Filters, sdRoots, Expanders, ItemLists,
  guiMain, DropLists, CopyFiles;

{$R *.DFM}

{ TPidlFrame }

procedure TPidlFrame.DlgToFilter;
begin
  with TPidlItem(Item) do
  begin
    FPage := pcPidl.ActivePageIndex;
    FShowSubItems := chbShowSubItems.Checked;
  end;
end;

procedure TPidlFrame.FilterToDlg;
begin
  with TPidlItem(Item) do
  begin
    pcPidl.ActivePageIndex := FPage;
    chbShowSubItems.Checked := FShowSubItems;
    if assigned(NameSpace) then
      DialogCaption := NameSpace.NameForParsing;
  end;
end;

{ TPidlItem }

procedure TPidlItem.ConstructSubNSList(NSItems: TList);
// Construct a sub namespace list (a list of "subfolders")
var
  i, j: integer;
begin
  // Construct a namespace list
  if assigned(NameSpace) then
  begin
    NameSpace.EnumerateFolder(
      True,  // Folders
      False, // Non-folders
      True,  // Hidden
      Self.EnumerateSubNS, pointer(NSItems));
  end;
  // Sort this list alphabetically
  if assigned(NSItems) then
  begin
    for i := 0 to NSItems.Count - 2 do
      for j:= i + 1 to NSItems.Count - 1 do
        if AnsiCompareText(TNameSpace(NSItems[j]).NameForParsing, TNameSpace(NSItems[i]).NameForParsing) < 0 then
          NSItems.Exchange(i, j);
  end;
end;

function TPidlItem.EnumerateSubNS(APIDL: PItemIDList; AParent: TNamespace; Data: pointer; var Terminate: Boolean): Boolean;
var
  NS: TNameSpace;
begin
  Result := False;
  NS := TNameSpace.Create(APidl, AParent);
  if assigned(NS) then
  begin
    if NS.FileSystem and assigned(Data) then
    begin
      Result := True;
      TList(Data).Add(NS);
    end else
    begin
      NS.Free;
    end;
  end;
end;

function TPidlItem.GetChildCount: integer;
begin
  if not FChildrenInitialized then
    InitializeChildren;
  // Childcount
  Result := inherited GetChildCount;
end;

function TPidlItem.GetDragImage: integer;
begin
  // The Folder Icon
  Result := 26;
end;

function TPidlItem.GetDragTypes: TDragTypes;
begin
  Result := [];
  // Drives can't be dragged.. too dangerous
  if IsDrive then exit;

  // Pidl items can be dragged as long as not readonly or windows folder
  Result := [dtMove, dtCopy, dtLink];
  if IsReadOnly or IsWindowsFolder(FolderName) then
    Result := Result - [dtMove];
end;

function TPidlItem.GetDrive: string;
begin
  Result := ExtractFileDrive(ExpandUNCFileName(FolderName));
end;

function TPidlItem.GetEmptyWarning: string;
begin
  if IsRoot then
  begin
    Result := 'Browse your computer to add some items to your collection.';
  end else
  begin
    if IsDrive then
      Result := 'Double-click on the drive to show the folders.'
    else
      Result := 'You can select this folder by checking the little white square.';
  end;
end;

procedure TPidlItem.InitializeChildren;
var
  OldCursor: TCursor;
begin
  FChildrenInitialized := True;
  // This can be a lengthy process so we change the cursor and inform user
  DoStatusMessage(Format('Opening %s...', [FolderName]));
  OldCursor := Screen.Cursor;
  Screen.Cursor := crAppStart;
  try
    UpdateSubNS;
  finally
    Screen.Cursor := OldCursor;
    DoStatusMessage('');
  end;
end;

procedure TPidlItem.SetNameSpace(AValue: TNameSpace);
var
  AFolder: TsdFolder;
begin
  // Free the old one
  if assigned(FNameSpace) then
    FreeAndNil(FNameSpace);
  // Set new namespace
  FNameSpace := AValue;
  if assigned(FNameSpace) then
  with FNameSpace do
  begin
    // Check attributes
    if IsWindowsFolder(FolderName) or IsDrive then
    begin
      Options := Options - [biAllowRename];
      Options := Options - [biAllowRemove];
    end else
    begin
      Options := Options + [biAllowRename];
      Options := Options + [biAllowRemove];
    end;
    // Set caption accordingly
    Caption := NameNormal;
    // Set our filter's name
    if assigned(Filter) then
      Filter.Name := ExcludeTrailingPathDelimiter(FolderName);
    // Set state image accordingly
    StateIndexClose := GetIconIndex(False, icSmall, True);
    StateIndexOpen  := GetIconIndex(True, icSmall, True);
    // Find matching folder
    AFolder := frmMain.Root.FolderByName(FolderName);
    if assigned(AFolder) then
      FolderGuid := AFolder.Guid;
  end;
end;

destructor TPidlItem.Destroy;
begin
  FreeAndNil(FNameSpace);
  FreeAndNil(FFoldersAccept);
  FreeAndNil(FFoldersDeny);
  inherited;
end;

procedure TPidlItem.AcceptDrop(var Effect: integer);
var
  AList: TStringList;
  AFolder: TsdFolder;
begin
  // Call the CopyFiles macro
  AList := TStringList.Create;
  try
    // Which files to move
    DropList.GetFiles(AList);
    // Now, if internal and move, already adapt the objects
    if (Droplist.Contains(TsdItem) or DropList.Contains(TPidlItem)) and
       (Effect = DROPEFFECT_MOVE) then
    begin
      AFolder := frmMain.Root.FolderByName(FolderName);
      if assigned(AFolder) then
      begin
        // Complete internal move, we'll use the MoveInternal tool
        MoveInternal(Self, DropList, AFolder);
        exit;
      end else
      begin
        if MessageDlg(
          'This will remove the items from the collection.'#13#13+
          'Do you want to proceed?',
          mtWarning, [mbYes, mbNo, mbCancel, mbHelp], 0) <> mrYes then
            exit;
      end;
    end;
    // We MUST flush the updates before doing any copying
    frmMain.Root.FlushBatchedItems;
    // Do the physical move/copy
    CopyMoveFiles(Self, AList, FolderName, Effect);
  finally
    AList.Free;
  end;
end;

function TPidlItem.AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean;
var
  i: integer;
  AFolder: string;
  ADrive: string;
begin
  Result := False;
  // Accept drops from these sources
  with DropList do
  begin
    if Contains(TsdItem) or Contains(TPidlItem) or Contains(TExtFile) then
    begin
      // No drop on readonly
      Result := (not IsReadOnly);
      AFolder := '';
      ADrive := '';
      for i := 0 to Count - 1 do
      begin
        // TFile & TFolder
        if TObject(Items[i]) is TsdItem then
        begin
          AFolder := TsdItem(Items[i]).FolderName;
          ADrive := TsdItem(Items[i]).Drive;
          break;
        end;
        // TPidlItem
        if TObject(Items[i]) is TPidlItem then
        begin
          AFolder := TPidlItem(Items[i]).FolderName;
          ADrive := TPidlItem(Items[i]).Drive;
          break;
        end;
      end;
      // No drop on our folder
      if (AnsiCompareText(FolderName, AFolder) = 0) then
        Result := False;
      // Determine effect
      if (Drive <> ADrive) xor (ssCtrl in Shift) then
      begin
        Effect := DROPEFFECT_COPY;
        AMessage := 'Copy here';
      end else
      begin
        Effect := DROPEFFECT_MOVE;
        AMessage := 'Move here';
      end;
      exit;
    end;

  end;
end;

procedure TPidlItem.AddSubPidl(SubPathName: string);
var
  NS: TNameSpace;
  PIDL: PItemIDList;
  SubItem: TPidlItem;
begin
  NS := nil;
  PIDL := PathToPIDL(SubPathName);
  if Assigned(PIDL) then
    NS := TNameSpace.Create(PIDL, nil);

  if assigned(NS) then
  begin
    if NS.FileSystem then
    begin
      SubItem := TPidlItem.Create;
      SubItem.NameSpace := NS;
      Tree.AddItem(SubItem, Node);
    end else
    begin
      NS.Free;
    end;
  end;
end;

function TPidlItem.CheckState: TCheckState;
begin
  if not IsEmptyGuid(FolderGuid) then
    Result := csCheckedNormal
  else
    Result := csUncheckedNormal;
end;

function TPidlItem.CheckType: TCheckType;
begin
  if IsRoot then
    Result := ctNone
  else
    Result := ctCheckbox;
end;

procedure TPidlItem.ClearSubNS;
// Clear the complete Sub Namespace
var
  i: integer;
begin
  // Clear the unflagged items
  i := 0;
  while i < ChildCount do
    if (Childs[i] is TPidlItem) and (TPidlItem(Childs[i]).FVerified = False) then
      Tree.Remove(Childs[i])
    else
      inc(i);
end;

procedure TPidlItem.CreateFilterParams;
begin
  Options := Options + [biNoStatistics, biHasChildren];
  Caption := 'folder';
  DialogCaption := '';
  DialogIcon := -1;

  // add a standard filter with OnAcceptItem connected to StandardItem
  Filter := TFilter.Create;
  with TFilter(Filter) do
  begin
    OnAcceptItem := FilterAcceptItem;
  end;
  // Create the Folders Accept and Deny lists
  if assigned(FFoldersAccept) then
    FFoldersAccept.Clear
  else
  begin
    FFoldersAccept := TSortedList.Create(False);
    FFoldersAccept.CompareMethod := CompareItemGuid;
  end;
  if assigned(FFoldersDeny) then
    FFoldersDeny.Clear
  else
  begin
    FFoldersDeny := TSortedList.Create(False);
    FFoldersDeny.CompareMethod := CompareItemGuid;
  end;

  // Set frame class
  FrameClass := TPidlFrame;
end;

procedure TPidlItem.CreateFolderList(AList: TList; IncludeChildren: boolean);
var
  i: integer;
  Folder: TsdFolder;
begin
  if not assigned(AList) then
    exit;
  // This folder
  Folder := nil;
  // Try ID
  if not IsEmptyGuid(FolderGuid) then
    Folder := frmMain.Root.FolderByID(FolderGuid);
  // Add to list
  if assigned(Folder) then
    AList.Add(Folder);
  // Child folders
  if IncludeChildren and assigned(frmMain.Root.FAllFolders) and assigned(Folder) then
  begin
    for i := 0 to frmMain.Root.FAllFolders.Count - 1 do
      if TsdFolder(frmMain.Root.FAllFolders[i]).HasAsParent(Folder.Guid) then
        AList.Add(frmMain.Root.FAllFolders[i]);
  end;
end;

procedure TPidlItem.CreateItemList(AList: TList; IncludeChildren: boolean);
begin
  CreateFolderList(AList, IncludeChildren);
  ExpandSelectionMerge(AList, frmMain.Root, emRemoving);
end;

function TPidlItem.IsDrive: boolean;
begin
  if assigned(Parent) then
    Result := Parent.IsRoot
  else
    Result := length(GetParentFolder(FolderName)) = 0;
end;

function TPidlItem.IsReadOnly: boolean;
begin
  // Use the namespace to find out
  Result := True;
  if assigned(NameSpace) then
    Result := NameSpace.ReadOnly;
end;

procedure TPidlItem.DoRename(ANewName: string);
// Rename this item.. it involves renaming the TFolder (if present) and the
// shell folder
var
  AFolder: TsdFolder;
  OldName, NewName: string;
begin
  // Old name and new name (full)
  OldName := FolderName;
  NewName := IncludeTrailingPathDelimiter(GetParentFolder(FolderName) + ANewName);
  // Do the shell rename - turn off watchdog
  inc(FShellNotifyRef);
  try
    if not RenameFile(OldName, NewName) then
      MessageDlg(
        'The folder could not be renamed.'#13#13+
        'Please make sure you have typed in a valid new name'#13+
        'and that the folder is not read-only.', mtWarning, [mbOK, mbHelp], 0)
    else
    begin
      // Rename TFolder
      AFolder := nil;
      if not IsEmptyGuid(FolderGuid) then
        AFolder := frmMain.Root.FolderByID(FolderGuid);
      if assigned(AFolder) then
        AFolder.Rename(NewName);
      // Rename ourselve
      RenamePidl(NewName);
    end;
  finally
    dec(FShellNotifyRef);
  end;
end;

procedure TPidlItem.FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean);
var
  Folder: TsdFolder;
  Dummy: integer;
begin
  Accept := False;
  if not assigned(Item) then
    exit;
  if IsEmptyGuid(FolderGuid) then
    exit;

  // Check direct items
  case Item.ItemType of
  itFile: Accept := IsEqualGuid(TsdFile(Item).FolderGuid, FolderGuid);
  itFolder: Accept := IsEqualGuid(TsdFolder(Item).Guid, FolderGuid);
  end;//case
  if Accept then
    exit;

  if (not Expanded) or FShowSubItems then
  begin
    // Also check for any subdirectories
    case Item.ItemType of
    itFile:
      begin
        Folder := frmMain.Root.FolderByID(TsdFile(Item).FolderGuid);
        if assigned(Folder) then
        begin
          if Folder.HasAsParent(FolderGuid) then
          begin
            // Is it in the list of folders we deny?
            if FFoldersDeny.Find(Folder, Dummy) then
              exit;
            Accept := True;
            // is it in the folders we accept?
            if FFoldersAccept.Find(Folder, Dummy) then
            begin
              FFoldersAccept.Add(Folder);
              exit;
            end;
          end else
          begin
            // This folder is not in our path, so add to deny list
            FFoldersDeny.Add(Folder);
          end;
        end;
      end;
    end;
  end;
end;

function TPidlItem.FindSubByFolderName(AFolderName: string): TPidlItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ChildCount - 1 do
    if Childs[i] is TPidlItem then
      if AnsiCompareText(TPidlItem(Childs[i]).FolderName, IncludeTrailingPathDelimiter(AFolderName)) = 0 then
      begin
        Result := TPidlItem(Childs[i]);
        exit;
      end;
end;

function TPidlItem.FolderName: string;
begin
  Result := '';
  if assigned(NameSpace) then
    Result := IncludeTrailingPathDelimiter(NameSpace.NameForParsing);
end;

procedure TPidlItem.RenamePidl(NewPathName: string);
var
  NS: TNameSpace;
  PIDL: PItemIDList;
begin
  NS := nil;
  PIDL := PathToPIDL(NewPathName);
  if Assigned(PIDL) then
    NS := TNameSpace.Create(PIDL, nil);
  if assigned(NS) then
  begin
    NameSpace := NS;
    Update;
  end;
end;

procedure TPidlItem.UpdateSubNS;
var
  i: integer;
  NSItems: TObjectList;
  ASubItem: TPidlItem;
  NS: TNameSpace;
begin
  // NSItems holds the sub NS items
  NSItems := TObjectList.Create;
  try
    // Construct Sub NS list and sort it
    ConstructSubNSList(NSItems);

    // Clear flags
    for i := 0 to ChildCount - 1 do
      if Childs[i] is TPidlItem then
        TPidlItem(Childs[i]).FVerified := False;

    // Iterate
    i := 0;
    while i < NSItems.Count do
    begin
      ASubItem := FindSubByFolderName(TNameSpace(NSItems[i]).NameForParsing);
      if assigned(ASubItem) and
        (ASubItem.Caption = TNameSpace(NSItems[i]).NameNormal) then
      begin
        // The item is found, so flag it
        ASubItem.FVerified := True;
        // Delete the NS
        NSItems.Delete(i);
      end else
        // Advance
        inc(i);
    end;

    // Clear the unflagged items
    i := 0;
    while i < ChildCount do
      if (Childs[i] is TPidlItem) and (TPidlItem(Childs[i]).FVerified = False) then
        Tree.Remove(Childs[i])
      else
        inc(i);

    // Add the newly found NS
    while NSItems.Count > 0 do
    begin
      NS := TNameSpace(NSItems[0]);
      NSItems.Extract(NS);
      if NS.FileSystem then
      begin
        ASubItem := TPidlItem.Create;
        ASubItem.NameSpace := NS;
        Tree.AddItem(ASubItem, Node);
      end else
      begin
        NS.Free;
      end;
    end;
  finally
    NSItems.Free;
  end;
end;

function TPidlItem.GetPropID: word;
begin
//todo
  Result := 0;
end;

end.
