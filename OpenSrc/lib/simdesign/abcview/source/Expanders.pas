{ unit Expanders

  Expand selection with folders belonging to files etc.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Expanders;

interface

uses
  Windows, SysUtils, Classes, ItemLists, sdSortedLists, sdAbcTypes;

type
  // TExpandMethod is used in DoExpandSelection to indicate expand method
  TExpandMethod = (emRemoving, emSelecting);

// Call DoExpandSelection to expand the selection in AList to contain related
// items (e.g. folders/series/groups in which files are present, files which
// are in series etcetera. Use AMethod = emRemoving for expansion of a remove list,
// and AMethod = emSelecting for expansion of a selection list.
procedure ExpandSelection(AList: TList; AExpand: TSortedList; ASource: TItemMngr; AMethod: TExpandMethod);

// ExpandSelectionMerge calls ExpandSelection and then merges AExpand with AList
// to create a single expanded list AList.
procedure ExpandSelectionMerge(AList: TList; ASource: TItemMngr; AMethod: TExpandMethod);

const

  cTraverseSourceLimit = 20000; // The max size of ASource to be traversed directly

implementation

uses
  guiMain, sdItems, sdRoots;

procedure ExpandSelection(AList: TList; AExpand: TSortedList; ASource: TItemMngr; AMethod: TExpandMethod);
var
  i, j, FirstID: integer;
  AddList, CheckList: TList;
  Dummy: TsdFile;
  DummyID: integer;
  AFolder: TsdFolder;
  Source: TItemList;
  Tick: dword;
  // local
  procedure StatusMessage(AMessage: string);
  begin
   if assigned(frmMain.Root) then
     frmMain.Root.DoStatusMessage(nil, AMessage);
  end;
  // local
  procedure DoProgress(var ATick: dword; Num, Den: integer);
  var
    ANewTick, AInterval: dword;
  begin
    ANewTick := GetTickCount;
    AInterval := ANewTick - ATick;

    if AInterval >= cProgressInterval then
    begin
      ATick := ANewTick;
      if (Den > 0) then
        StatusMessage(Format('Expanding selection (%3.1f%%)',[Num/Den * 100]));
    end;
  end;
// main
begin
  if not assigned(AList) or not assigned(AExpand) then
    exit;

  // Make sure to have a valid reference
  Source := nil;
  if (ASource is TItemList) then
    Source := TItemList(ASource);
  // Assign root if no valid reference
  if not assigned(Source) then
  begin
    Source := frmMain.Root;
    if not assigned(Source) then
      exit;
  end;

  AddList := TList.Create;
  CheckList := TList.Create;
  Source.LockRead;
  try

    StatusMessage('Expanding selection (preparing)...');

    // Loop through list - both methods
    for i := 0 to AList.Count - 1 do
    begin
      case TsdItem(AList[i]).ItemType of
      itFile:
        with TsdFile(AList[i]) do
        begin
          // To do: add file->series to checklist
          if AMethod = emSelecting then
          begin
            // Add File's folder to the list
            AFolder := Folder;
            if assigned(AFolder) and (AddList.IndexOf(AFolder) < 0) then
              AddList.Add(AFolder);
          end;
        end;
      itFolder:
        // Add files in folder to list - both methods
        with TsdFolder(AList[i]) do
        begin
          // Add the files in this folder to the remove list
          if Source.Count > cTraverseSourceLimit then
          begin

            // We will use AllFiles because it is sorted on FolderID
            Dummy := TsdFile.Create;
            try
              Dummy.FolderGuid := Guid;
              frmMain.Root.FAllFiles.Find(Dummy, FirstID);
              while (FirstID >= 0) and (FirstID < frmMain.Root.FAllFiles.Count) and
                    (CompareGuid(TsdFile(frmMain.Root.FAllFiles[FirstID]).FolderGuid, Guid) = 0) do
              begin
                // add file to list
                AddList.Add(frmMain.Root.FAllFiles[FirstID]);
                inc(FirstID);
              end;
            finally
              Dummy.Free;
            end;

          end else
          begin

            // Traverse the source and add any files in this folder
            for j := 0 to Source.Count - 1 do
              if (Source[j].ItemType = itFile) and
                 (CompareGuid(TsdFile(Source[j]).FolderGuid, Guid) = 0) then
                AddList.Add(Source[j]);
          end;

        end;
      itSeries:;
      // Series
      // TO DO: add files in series to the FileList
      itGroup:;
      // Group
      // TO DO: add files&series in group to the FileList
      else
        //
      end;//case
    end;

    // To do: Loop through checklist to see if any of the items is completely
    // present

    // Now we must create the expand, but also warrant against dupes
    AExpand.Clear;
    Tick := GetTickCount;
    for i := 0 to AddList.Count - 1 do
    begin
      DoProgress(Tick, i, AddList.Count);
      if not AExpand.Find(AddList[i], DummyID) and
         (AList.IndexOf(AddList[i]) < 0) and
         Source.Find(AddList[i], FirstID) then
        AExpand.Add(AddList[i]);
    end;

    StatusMessage(Format('Expanded selection: %d items', [AExpand.Count]));

  finally
    Source.UnlockRead;
    AddList.Free;
    CheckList.Free;
  end;
end;

procedure ExpandSelectionMerge(AList: TList; ASource: TItemMngr; AMethod: TExpandMethod);
var
  i: integer;
  Expand: TSortedList;
begin
  Expand := TSortedList.Create(False);
  try
    // Find the expanded items
    ExpandSelection(AList, Expand, ASource, AMethod);
    // Merge the two
    for i := 0 to Expand.Count - 1 do
      AList.Add(Expand[i]);
  finally
    Expand.Free;
  end;
end;

end.
