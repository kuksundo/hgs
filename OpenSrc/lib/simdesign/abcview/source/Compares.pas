{ Unit Compares

  compare functions for items (files, folders).

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Compares;

interface

uses
  SysUtils, sdItems, sdSortedLists, sdAbcTypes, sdAbcVars, sdAbcFunctions;

// Function CompareItems will compare 2 items (Item1 and Item2) and returns -1 if
// Item1 < Item2, returns +1 if Item1 > Item2, and returns 0 if Item1 = Item2.
// Info must point to a TSortMethod object which will be used in the compare.
function CompareItems(Object1, Object2: TObject; Info: pointer): integer;

// Does the same as CompareItems but just for 1st level
function CompareItemsOneLevel(Item1, Item2: TsdItem; Info: pointer): integer;

implementation

uses

  sdSorter, sdProperties, Duplicates, PixRefs;

function CompareFiles(File1, File2: TsdFile; Method: TSortMethodType; Direction: TSortDirectionType): integer;
// local function to compare files
var
  String1, String2: string;
  dbl1, dbl2: double;
  Prop1, Prop2: TsdProperty;
begin
  case Method of
  smNoSort, smRandom:
    // Pointer compare
    Result := CompareInt(integer(File1), integer(File2));
  smByID:
    Result := CompareGuid(File1.Guid, File2.Guid);
  smByName:
    Result := AnsiCompareText(File1.Name, File2.Name);
  smByNameNum:
    Result := CompareStringNum(File1.Name, File2.Name);
  smBySize:
    //Result := CompareInt(File1.Size, File2.Size);
    Result := CompareInt64(File1.Size, File2.Size);
  smByType:
    begin
      if FSortTypeWithExt then begin
        String1 := ExtractFileExt(File1.Name);
        String2 := ExtractFileExt(File2.Name);
      end else begin
        String1 := File1.FileType;
        String2 := File2.FileType;
      end;
      Result := AnsiCompareText(String1, String2);
    end;
  smByDate:
    Result := CompareDouble(File1.Modified, File2.Modified);
  smByFolder:
    begin
      Result := CompareGuid(File1.FolderGuid, File2.FolderGuid);
      if Result <> 0 then
        Result := AnsiCompareText(File1.FolderName, File2.FolderName);
    end;
  smByFolderID:
      Result := CompareGuid(File1.FolderGuid, File2.FolderGuid);
  smBySeries:
    Result := CompareInt(File1.Series, File2.Series);
  smByRating:
    Result := CompareWord(File1.Rating, File2.Rating);
  smByStatus:
    Result := AnsiCompareText(File1.StatusString, File2.StatusString);
  smByGroupCount:
    Result := 0; // NOT IMPLEMENTED!!
  smByCRC:
    Result := CompareCardinal(File1.CRC, File2.CRC);
  smByDescription:
    Result := AnsiCompareText(File1.Description, File2.Description);
  smByDupeGroup, smByBand:
    begin
      Prop1 := File1.GetProperty(prDupeGroup);
      Prop2 := File2.GetProperty(prDupeGroup);
      if assigned(Prop1) and assigned(Prop2) then
        Result := CompareInt(TprDupeGroup(Prop1).GroupID, TprDupeGroup(Prop2).GroupID)
      else begin
        Result := CompareInt(integer(Prop1), integer(Prop2));
        if Direction = sdAscending then
          Result := Result * -1;
      end;
    end;
  smByDimensions:
    Result := CompareInt64(File1.Width * File1.Height, File2.Width * File2.Height);
  smByCompression:
    begin
      Result := CompareBool(File1.CompressionRatio(Dbl1), File2.CompressionRatio(Dbl2));
      if Result = 0 then
        Result := CompareDouble(Dbl1, Dbl2);
    end;
  smByOrigName:
    Result := AnsiCompareText(File1.OriginalName, File2.OriginalName);
  smBySimilarity:
    Result := ComparePixRef(File1.GetProperty(prPixRef), File2.GetProperty(prPixRef), FMatchTolerance);
  else
    Result := 0; // Items are equal by default
  end;//case
end;

function CompareFolders(Folder1, Folder2: TsdFolder; Method: TSortMethodType; Direction: TSortDirectionType): integer;
// local function to compare folders
var
  Int1, Int2: integer;
  Dbl1, Dbl2: double;
const
  BoolVal: array[boolean] of integer = (0, 1);
begin
  case Method of
  smNoSort, smRandom:
    // Pointer compare
    Result := CompareInt(integer(Folder1), integer(Folder2));
  smByID:
    Result := CompareGuid(Folder1.Guid, Folder2.Guid);
  smByName, smByFolder:
    Result := AnsiCompareText(Folder1.FolderName, Folder2.FolderName);
  smByNumItems:
    begin
      Folder1.GetStatistics(Int1, Dbl1);
      Folder2.GetStatistics(Int2, Dbl2);
      Result := CompareInt(Int1, Int2);
    end;
  smBySize:
    begin
      Folder1.GetStatistics(Int1, Dbl1);
      Folder2.GetStatistics(Int2, Dbl2);
      Result := CompareDouble(Dbl1, Dbl2);
    end;
  smByType:
    Result := AnsiCompareText(Folder1.FFolderType, Folder2.FFolderType);
  smByDate:
    Result := CompareDouble(Folder1.Modified, Folder2.Modified);
  smByStatus:
    Result := AnsiCompareText(Folder1.GetStatusString, Folder2.GetStatusString);
  smByGroupCount:
    Result := 0; // NOT IMPLEMENTED!!
  smByAttributes:
    Result := CompareInt(Folder1.FAttr, Folder2.FAttr);
  smByFilter:
    begin
      with Folder1.Options do
        Int1 := BoolVal[AddHidden] + 2 * BoolVal[AddSystem] + 4 * BoolVal[GraphicsOnly];
      with Folder2.Options do
        Int2 := BoolVal[AddHidden] + 2 * BoolVal[AddSystem] + 4 * BoolVal[GraphicsOnly];
      Result := CompareInt(Int1, Int2);
    end;
  smByProtection:
    Result := CompareBool(Folder1.Options.DeleteProtected, Folder2.Options.DeleteProtected);
  smByVolumeLabel:
    // For compatibility with empty Volume labels (version 1.0)
    if (length(Folder1.FVolume) = 0) or (Length(Folder2.FVolume) = 0) then
      Result := 0
    else
      Result := AnsiCompareText(Folder1.FVolume, Folder2.FVolume);
  smByShortName:
    Result := AnsiCompareText(Folder1.Name, Folder2.Name);
  smByDescription:
    Result := AnsiCompareText(Folder1.Description, Folder2.Description);
  else
    Result := 0; // Items are equal by default
  end;//case
end;

function CompareItems(Object1, Object2: TObject; Info: pointer): integer;
// CompareItems will compare Item1 and Item2 using TSortmethod info from
// Info.
var
  Item1, Item2: TsdItem;
  Level: integer;
begin
  if Info = nil then
    raise Exception.Create(
    'CompareItems is called with un-initialized "Info" pointer.');
  if not ((Object1 is TsdItem) and (Object2 is TsdItem)) then
  begin
    Result := 0;
    exit;
  end;

  Item1 := TsdItem(Object1);
  Item2 := TsdItem(Object2);

  if Item1.ItemType = Item2.ItemType then
  begin

    Level := 0;
    with TSortMethod(Info) do repeat

      case Item1.ItemType of
      itFile:
        Result := CompareFiles(TsdFile(Item1), TsdFile(Item2), Method[Level], Direction[Level]);
      itFolder:
        Result := CompareFolders(TsdFolder(Item1), TsdFolder(Item2), Method[Level], Direction[Level]);
      else
        Result := 0;
      end;//case

      if Direction[Level] = sdDescending then
        Result := Result * -1;
      inc(Level);

    until (Result <> 0) or (Level >= Count);

  end else
    if Item1.ItemType < Item2.ItemType then
      Result := -1
    else
      Result := 1;
end;

function CompareItemsOneLevel(Item1, Item2: TsdItem; Info: pointer): integer;
// CompareItemsOneLevel will compare Item1 and Item2 using TSortmethod info level 0
begin
  if Info = nil then raise Exception.Create(
    'CompareItems is called with un-initialized "Info" pointer.');

  if Item1.ItemType = Item2.ItemType then begin

    with TSortMethod(Info) do begin

      case Item1.ItemType of
      itFile:
        Result := CompareFiles(TsdFile(Item1), TsdFile(Item2), Method[0], Direction[0]);
      itFolder:
        Result := CompareFolders(TsdFolder(Item1), TsdFolder(Item2), Method[0], Direction[0]);
      else
        Result := 0;
      end;//case

      if Direction[0] = sdDescending then
        Result := Result * -1;
    end;

  end else
    if Item1.ItemType < Item2.ItemType then
      Result := -1
    else
      Result := 1;
end;

end.
