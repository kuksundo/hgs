{ unit ThumbItems

  Thumbnails inside generated webpages

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit ThumbItems;

interface

uses
  Windows, Classes, Contnrs, SysUtils, Graphics, {$warnings off}FileCtrl, {$warnings on}ShellAPI,
  BrowseTrees, sdItems, ItemLists, ImageProcessors, Links, Math;

type

  TThumbOption = (
    toIsThumbed,  // Thumbnail is created
    toIsImaged    // Web Image is created
    );
  TThumbOptions = set of TThumbOption;

  TThumbMngr = class;

  TThumbItem = class
  private
    FImageName: string;   // Web Image filename without path
    FGuid: TGUID; // Pointer to the item which it belongs to
    FThumbName: string;   // Thumbnails filename without path
    FOptions: TThumbOptions;
    FParent: TThumbMngr;
  protected
    procedure FindImageName;
    procedure FindThumbName;
    function GetImageFileName: string;
    function GetItem: TsdItem;
    function GetOrigName: string;
    function GetThumbFileName: string;
  public
    constructor Create(AParent: TThumbMngr; const AID: TGUID); virtual;
    destructor Destroy; override;
    property ImageFileName: string read GetImageFileName;
    property ImageName: string read FImageName write FImageName;
    property Guid: TGUID read FGuid;
    property Item: TsdItem read GetItem;
    property Options: TThumbOptions read FOptions write FOptions;
    property OrigName: string read GetOrigName;
    property Parent: TThumbMngr read FParent;
    property ThumbFileName: string read GetThumbFileName;
    property ThumbName: string read FThumbName write FThumbName;
    procedure GenerateImage(AEngine: TImageProcessor; GenerateAll: boolean);
    procedure GenerateThumb(AEngine: TImageProcessor; GenerateAll: boolean);
  end;

  TThumbMngr = class(TItemMngr)
  private
    FImageFolder: string;
    FImageFormat: integer;
    FThumbs: TObjectList;  // FThumbs holds the TThumbItem objects
    FThumbFolder: string;
    FThumbFormat: integer;
  protected
    function GetThumbs(Index: integer): TThumbItem;
    function GetThumbCount: integer;
    procedure SetImageFormat(AValue: integer);
    procedure SetThumbFormat(AValue: integer);
  public
    constructor Create;
    destructor Destroy; override;
    property ImageFolder: string read FImageFolder write FImageFolder;
    property ImageFormat: integer read FImageFormat write SetImageFormat;
    property Thumbs[Index: integer]: TThumbItem read GetThumbs;
    property ThumbCount: integer read GetThumbCount;
    property ThumbFolder: string read FThumbFolder write FThumbFolder;
    property ThumbFormat: integer read FThumbFormat write SetThumbFormat;
    procedure Add(AThumb: TThumbItem);
    procedure ClearItems(Sender: TObject); override;
    procedure Delete(AThumb: TThumbItem);
    procedure InsertItems(Sender: TObject; AList: TList); override;
    procedure RemoveItems(Sender: TObject; AList: TList); override;
    function ThumbFormatExtension: string;
    function ThumbByID(const AID: TGUID): TThumbItem;
    function ThumbByImageName(AName: string): TThumbItem;
    function ThumbByThumbName(AName: string): TThumbItem;
  end;

implementation

uses
  Filters, sdRoots, sdGraphicLoader, guiFeedback,
  guiMain;

const

  // Constants that are used inside HTML templates
  cDate         = '{Date}';
  cDescription  = '{Description}';
  cImage        = '{Image}';
  cImageName    = '{ImageName}';
  cImageTitle   = '{ImageTitle}';
  cPagePeerHor  = '{PagePeerHor}';
  cPagePrev     = '{PagePrev}';
  cPageNext     = '{PageNext}';
  cPageSheet    = '{PageSheet}';
  cSheetTitle   = '{SheetTitle}';
  cSheetPeerHor = '{SheetPeerHor}';
  cSheetPrev    = '{SheetPrev}';
  cSheetNext    = '{SheetNext}';
  cThumbnails   = '{Thumbnails}';

{ TThumbItem }

procedure TThumbItem.FindImageName;
var
  AItem: TsdItem;
  AName: string;
  CopyNum: integer;
begin
  AItem := Item;
  FImageName := '';
  if assigned(Parent) and assigned(AItem) then
  begin
    if Parent.FImageFormat = 0 then
    begin
      // Just a link to the original image
      AName := OrigName;
    end else begin
      // A JPG copy of the original
      AName := ChangeFileExt(Item.Name, '.jpg');
      // Create unique name
      CopyNum := 1;
      while assigned(Parent.ThumbByImageName(AName)) do
      begin
        inc(CopyNum);
        AName := Format('%s_%d%s',
          [ChangeFileExt(Item.Name, ''), CopyNum, '.jpg']);
      end;
    end;
    FImageName := AName;
  end;
end;

procedure TThumbItem.FindThumbName;
var
  AItem: TsdItem;
  AName: string;
  CopyNum: integer;
const
  Prefix = 'th_';
begin
  AItem := Item;
  FThumbName := '';
  if assigned(Parent) and assigned(AItem) then
  begin
    if Parent.FThumbFormat = 0 then
    begin
      // Direct link so just the image name
      AName := ImageFileName;
    end else begin
      // Either a GIF or JPG thumbnail
      AName := Prefix + ChangeFileExt(Item.Name, Parent.ThumbFormatExtension);
      // Create unique name
      CopyNum := 1;
      while assigned(Parent.ThumbByThumbName(AName)) do
      begin
        inc(CopyNum);
        AName := Format('%s%s_%d%s',
          [Prefix, ChangeFileExt(Item.Name, ''),  CopyNum, Parent.ThumbFormatExtension]);
      end;
    end;
    FThumbName := AName;
  end;
end;

function TThumbItem.GetImageFileName: string;
begin
  Result := '';
  if assigned(Parent) then
    if Parent.FImageFormat = 0 then
      Result := FImageName
    else
      Result := Parent.ImageFolder + FImageName;
end;

function TThumbItem.GetItem: TsdItem;
begin
  Result := nil;
  if assigned(frmMain.Root) then
    Result := frmMain.Root.ItemByGuid(FGuid);
end;

function TThumbItem.GetOrigName: string;
begin
  // Original name
  Result := '';
  if assigned(Item) then
    Result := TsdFile(Item).FileName;
end;

function TThumbItem.GetThumbFileName: string;
begin
  Result := '';
  if assigned(Parent) then
    if Parent.FThumbFormat = 0 then
      Result := FThumbName
    else
      Result := Parent.ThumbFolder + FThumbName;
end;

constructor TThumbItem.Create(AParent: TThumbMngr; const AID: TGUID);
begin
  inherited Create;
  FParent := AParent;
  FGuid := AID;
end;

destructor TThumbItem.Destroy;
begin
  inherited;
end;

procedure TThumbItem.GenerateImage(AEngine: TImageProcessor; GenerateAll: boolean);
var
  AItem: TsdItem;
  AName: string;
begin
  // initial checks
  if not assigned(Parent) then
    exit;
  if length(ImageName) = 0 then
    exit;

  // We only link, so don't generate
  if Parent.FImageFormat = 0 then
    exit;

  AName := Parent.ImageFolder + ImageName;
  // Do we need to generate?
  if GenerateAll or not FileExists(AName) then
  begin
    // Remove old file
    if GenerateAll and FileExists(AName) then
      DeleteFile(AName);
    // Checks
    AItem := Item;
    if assigned(AItem) and (AItem.ItemType = itFile) and assigned(AEngine) then
    begin
      // Now let the engine run!
      with AEngine do
      begin
        InputFile := TsdFile(AItem).FileName;
        OutputFile := AName;
        Execute;
        // do we have a image
        if OutputResult <> gsGraphicsOK then
        begin
          ImageName := '';
        end;
      end;
    end;
  end;
end;

procedure TThumbItem.GenerateThumb(AEngine: TImageProcessor; GenerateAll: boolean);
var
  AItem: TsdItem;
  AName: string;
begin
  // initial checks
  if not assigned(Parent) then
    exit;
  if length(Thumbname) = 0 then
    exit;

  // We only link, so don't generate
  if Parent.FThumbFormat = 0 then exit;

  AName := Parent.ThumbFolder + ThumbName;
  // Do we need to generate?
  if GenerateAll or not FileExists(AName) then
  begin
    // Remove old file
    if GenerateAll and FileExists(AName) then
      DeleteFile(AName);
    // Checks
    AItem := Item;
    if assigned(AItem) and (AItem.ItemType = itFile) and assigned(AEngine) then
    begin
      // Now let the engine run!
      with AEngine do
      begin
        InputFile := TsdFile(AItem).FileName;
        OutputFile := AName;
        Execute;
        // do we have a thumbnail
        if OutputResult <> gsGraphicsOK then
        begin
          // To do: get the icon as GIF and save.
          ThumbName := '';
        end;
      end;
    end;
  end;
end;

{ TThumbMngr }

function TThumbMngr.GetThumbs(Index: integer): TThumbItem;
begin
  Result := nil;
  if assigned(FThumbs) and (Index >= 0) and (Index < FThumbs.Count) then
    Result := TThumbItem(FThumbs[Index]);
end;

function TThumbMngr.GetThumbCount: integer;
begin
  Result := 0;
  if assigned(FThumbs) then
    Result := FThumbs.Count;
end;

procedure TThumbMngr.SetImageFormat(AValue: integer);
var
  i: integer;
begin
  if AValue <> FImageFormat then
  begin
    FImageFormat := AValue;
    for i := 0 to ThumbCount - 1 do
    begin
      Thumbs[i].FindImageName;
      Thumbs[i].FindThumbName;
    end;
  end;
end;

procedure TThumbMngr.SetThumbFormat(AValue: integer);
var
  i: integer;
begin
  if AValue <> FThumbFormat then
  begin
    FThumbFormat := AValue;
    for i := 0 to ThumbCount - 1 do
    begin
      Thumbs[i].FindImageName;
      Thumbs[i].FindThumbName;
    end;
  end;
end;

constructor TThumbMngr.Create;
begin
  inherited;
  FThumbs := TObjectList.Create;
  FThumbFormat := 1;
  FImageFormat := 1;
end;

destructor TThumbMngr.Destroy;
begin
  if assigned(FThumbs) then
    FreeAndNil(FThumbs);
  inherited;
end;

procedure TThumbMngr.Add(AThumb: TThumbItem);
begin
  if assigned(FThumbs) and assigned(AThumb) then
  begin
    // Make sure to have unique names
    AThumb.FindImageName;
    AThumb.FindThumbName;
    // Add to our list
    FThumbs.Add(AThumb);
  end;
end;

procedure TThumbMngr.ClearItems(Sender: TObject);
begin
  // Clear thumb list
  if assigned(FThumbs) then
    FThumbs.Clear;
  inherited;
end;

procedure TThumbMngr.Delete(AThumb: TThumbItem);
begin
  if assigned(FThumbs) then
    FThumbs.Remove(AThumb);
end;

procedure TThumbMngr.InsertItems(Sender: TObject; AList: TList);
var
  i: integer;
  Thumb: TThumbItem;
begin
  // Insert new thumbs in thumb list
  for i := 0 to AList.Count - 1 do
  begin
    // This routine is rather slow.. must find a better solution
    Thumb := ThumbByID(TsdItem(AList[i]).Guid);
    if not assigned(Thumb) then
    begin
      // Create new and add
      Thumb := TThumbItem.Create(Self, TsdItem(AList[i]).Guid);
      Add(Thumb);
    end;
  end;
  inherited;
end;

procedure TThumbMngr.RemoveItems(Sender: TObject; AList: TList);
var
  i: integer;
  Thumb: TThumbItem;
begin
  // Remove thumbs from thumb list
  for i := 0 to AList.Count - 1 do
  begin
    Thumb := ThumbByID(TsdItem(AList[i]).Guid);
    if assigned(Thumb) then
      Delete(Thumb);
  end;
  inherited;
end;

function TThumbMngr.ThumbFormatExtension: string;
begin
  Result := '';
  case FThumbFormat of
  1: Result := '.gif';
  2: Result := '.jpg';
  end;
end;

function TThumbMngr.ThumbByID(const AID: TGUID): TThumbItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ThumbCount - 1 do
    if IsEqualGuid(Thumbs[i].Guid, AID) then
    begin
      Result := Thumbs[i];
      Exit;
    end;
end;

function TThumbMngr.ThumbByImageName(AName: string): TThumbItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ThumbCount - 1 do
    if AnsiSameText(Thumbs[i].ImageName, AName) then
    begin
      Result := Thumbs[i];
      Exit;
    end;
end;

function TThumbMngr.ThumbByThumbName(AName: string): TThumbItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ThumbCount - 1 do
    if AnsiSameText(Thumbs[i].ThumbName, AName) then
    begin
      Result := Thumbs[i];
      Exit;
    end;
end;

end.
