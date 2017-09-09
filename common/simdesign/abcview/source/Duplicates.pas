{ Unit Duplicates

  This unit provides support for the analysis of duplicate files. It instantiates
  a special filter, TDupeFilter, that is based on a TDuplexFilter and which
  is able to detect identical files, in a threaded environment.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Duplicates;

interface

uses
  Windows, Classes, SysUtils, Dialogs, Filters, ThreadedFilters, ItemLists, sdItems,
  sdProperties, sdAbcFunctions;

type

  TDupeFilter = class(TChainFilter)
  private
    FActiveCRC: boolean;
    FOnPreAccept: TAcceptItemEvent;
    FOnPostProcess: TNotifyEvent;
    procedure DoPostProcess(Sender: TObject);
  public
    constructor Create;
    property ActiveCRC: boolean read FActiveCRC write FActiveCRC;
    property OnPreAccept: TAcceptItemEvent read FOnPreAccept write FOnPreAccept;
    property OnPostProcess: TNotifyEvent read FOnPostProcess write FOnPostProcess;
    procedure DupeAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
  end;

  TprDupeGroup = class(TStoredProperty)
  private
    FGroupID: integer;
  protected
    function GetName: string; override;
    function GetValue: string; override;
    function GetPropID: word; override;
  public
    property GroupID: integer read FGroupID write FGroupID;
    function GetUniqueID: integer;
    procedure ReadComponents(S: TStream); override;
    procedure WriteComponents(S: TStream); override;
  end;

function CompareFileSize(Object1, Object2: TObject; Info: pointer): integer;

var

  FNextUniqueDupeGroup: integer = 1;

implementation

uses
  sdRoots, sdStreamableData, sdSortedLists;

{ TDupeFilter }

constructor TDupeFilter.Create;
var
  Filter: TItemMngr;
begin
  inherited Create;

  // First step: a filter that sorts on file size
  Filter := TItemList.Create(False);
  with TItemList(Filter) do
  begin
    Name := 'size-sorted list';
    OnCompare := CompareFileSize;
    Sorted := True;
  end;
  AddFilter(Filter);

  // Second step: a threaded filter, with OnAccept assigned to DupeAccept
  Filter := TThreadedFilter.Create;
  with TThreadedFilter(Filter) do
  begin
    Name := 'duplicates list';
    OnAcceptItem := DupeAcceptItem;
    OnPostProcess := DoPostProcess;
    ExpandedSelection := True;
  end;
  AddFilter(Filter);

end;

procedure TDupeFilter.DoPostProcess(Sender: TObject);
begin
  if assigned(FOnPostProcess) then
    FOnPostProcess(Sender);
end;

procedure TDupeFilter.DupeAcceptItem(Sender: TObject; AItem: TsdItem; var Accept: boolean);
var
  Index,
  Offset: integer;
  Item2: TsdItem;
  DupeGroup1,
  DupeGroup2: integer;
  SortSize: TItemList;
  EqualSize: boolean;
  PreAccept: boolean;
// local function
function GetDupeGroup(AItem: TsdItem): integer;
var
  DupeGroup: TsdProperty;
begin
  Result := 0;
  if not assigned(AItem) then
    exit;

  DupeGroup := AItem.GetProperty(prDupeGroup);
  if assigned(DupeGroup) then
    // We have a dupegroup property
    Result := TprDupeGroup(DupeGroup).GroupID;
end;
// local function
procedure SetDupeGroup(AItem: TsdItem; AValue: integer);
var
  DupeGroup: TsdProperty;
begin
  if not assigned(AItem) then
    exit;

  if AValue > 0 then
  begin

    DupeGroup := AItem.GetProperty(prDupeGroup);
    if not assigned(DupeGroup) then
      // Create new property
      DupeGroup := AItem.AddProperty(TprDupeGroup.Create);
    TprDupeGroup(DupeGroup).GroupID := AValue;

  end else
  begin
    AItem.RemoveProperty(prDupeGroup);
  end;
end;
// local function
procedure NewDupeGroup(AItem: TsdItem);
var
  DupeGroup: TsdProperty;
begin
  if not assigned(AItem) then
    exit;
  DupeGroup := AItem.AddProperty(TprDupeGroup.Create);
  with TprDupeGroup(DupeGroup) do
    GroupID := GetUniqueID;
end;
// local function
function IsIdentical(File1, File2: TsdFile; var AEqualSize: boolean): boolean;
begin
  Result := False;
  AEqualSize := False;

  if assigned(File1) and assigned(File2) then
  begin

    if (File1.Size = File2.Size) then
    begin
      // Identical size
      AEqualSize := True;
      if (isCRCDone in File1.States) and
         (isCRCDone in File2.States) then
      begin

        // Both CRC-ed
        if File1.CRC = File2.CRC then
          // CRCs match
          Result:=True;

      end else
      begin

        // Do we determine CRC values on the fly?
        if ActiveCRC then
        begin

          // Actively calculate the CRC value for each file as needed
          File1.CalculateSmallCRCValue;
          File2.CalculateSmallCRCValue;

          // we have updated file info, which is not detected by the root
          // so we must signal this.
          // We cannot use Update here because that will invoke the updater
          // too often (5 sec instead of 30 sec).
          TsdRoot(Root).IsChanged := true;

          if File1.SmallCRC = File2.SmallCRC then
          begin

            File1.CalculateCRCValue;
            File2.CalculateCRCValue;

            // Re-do the compare
            if (isCRCDone in File1.States) and
               (isCRCDone in File2.States) and
               (File1.CRC = File2.CRC) then

                // CRCs match
                Result := True;
          end;
        end;
      end;
    end;
  end;
end;
// main
begin
  Accept := False;
  // Call the owner's accept
  PreAccept := True;
  if assigned(FOnPreAccept) then
    FOnPreAccept(Self, AItem, PreAccept);
  if not PreAccept then exit;

  Item2 := nil;

  SortSize := TItemList(Filters[0]);
  if not assigned(SortSize) then
    exit;

  if (AItem.ItemType = itFile) then
  begin

    // Find place in list
    if SortSize.Find(AItem, Index) then
    begin

      // Compare with neighbours
      // check downwards
      Offset := 1;
      Accept := False;
      EqualSize := True;
      while not Accept and EqualSize and (Index - Offset >= 0) do
      begin
        Item2 := SortSize[Index - Offset];
        Accept := IsIdentical(TsdFile(AItem), TsdFile(Item2), EqualSize);
        inc(Offset);
      end;
      // check upwards
      Offset := 1;
      EqualSize := True;
      while not Accept and EqualSize and (Index + Offset < SortSize.Count) do
      begin
        Item2 := SortSize[Index + Offset];
        Accept := IsIdentical(TsdFile(AItem), TsdFile(Item2), EqualSize);
        inc(Offset);
      end;
    end;
  end;

  // Dupe Groups
  if Accept then
  begin
    // Identical items
    DupeGroup1 := GetDupeGroup(AItem);
    DupeGroup2 := GetDupeGroup(Item2);
    if (DupeGroup1 = 0) and (DupeGroup2 = 0) then
    begin

      // Set both to new duplicate group
      NewDupeGroup(AItem);
      SetDupeGroup(Item2, GetDupeGroup(AItem));

    end else
    begin

      // Copy group ID from one to other
      if (DupeGroup1 > 0) then
        SetDupeGroup(Item2, DupeGroup1)
      else
        if (DupeGroup2 > 0) then
          SetDupeGroup(AItem, DupeGroup2);

    end;
  end else
  begin
    // Non identical
    SetDupeGroup(AItem, 0);
  end;

end;

// Functions

function CompareFileSize(Object1, Object2: TObject; Info: pointer): integer;
var
  Item1, Item2: TsdItem;
begin
  if not ((Object1 is TsdItem) and (Object2 is TsdItem)) then
  begin
    Result := 0;
    exit;
  end;
  Item1 := TsdItem(Object1);
  Item2 := TsdItem(Object2);
  if (Item1.ItemType = itFile) and (Item2.ItemType = itFile) then
  begin
    Result := -CompareInt(TsdFile(Item1).Size, TsdFile(Item2).Size);
  end else
  begin
    // Separate items <> itFile
    Result := CompareInt(Integer(Item1.ItemType), Integer(Item2.ItemType));
  end;
  if Result = 0 then
    Result := CompareGuid(Item1.Guid, Item2.Guid);
end;

{ TDupeProp }

function TprDupeGroup.GetName: string;
begin
  Result := 'DupeGroup';
end;

function TprDupeGroup.GetValue: string;
begin
  Result := Format('%.4d', [GroupID]);
end;

function TprDupeGroup.GetPropID: word;
begin
  Result := prDupeGroup;
end;

function TprDupeGroup.GetUniqueID: integer;
begin
  // Get a new unique ID
  Result := FNextUniqueDupeGroup;
  inc(FNextUniqueDupeGroup);
end;

procedure TprDupeGroup.ReadComponents(S: TStream);
var
  Ver: byte;
begin
  inherited;
  // Read Version No
  StreamReadByte(S, Ver);
  // Read group ID
  StreamReadInteger(S, FGroupID);
  // Make sure that unique is unique
  if FNextUniqueDupeGroup <= FGroupID then
    FNextUniqueDupeGroup := FGroupID + 1;
end;

procedure TprDupeGroup.WriteComponents(S: TStream);
begin
  inherited;
  // Write Version No
  StreamWriteByte(S, 10);
  // Write group ID
  StreamWriteInteger(S, FGroupID);
end;

end.

