{ Unit sdItems

  This unit implements these datastructures:
  - TsdItem:  basic item type (ancestor for other types)
  - TsdFile:  file item type (holds all data for one file)
  - TsdFolder: folder (=directory) item type
  - TsdSeries: series item type
  - TsdGroup: group item type

  Features:

  Issues:
  Items are in itself NOT threadsafe. Always use the containing list's
  Lock and Unlock procedures when accessing items or descendants.

  Initial release: 20-12-2000

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2013 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit sdItems;

interface

uses
  Classes, SysUtils, Graphics, ComCtrls, Contnrs, Math,
  ShFileOp, ShellAPI, RxNotify, SyncObjs, sdProperties, Dialogs,
  DropSource, sdSortedLists, sdAbcTypes, sdAbcVars, sdAbcFunctions,

  // simdesign nativexml
  NativeXml;

type

  TSelectBit = (sbBit1, sbBit2);

type

  // File flags (States)
  TsdItemState = (
    isCRCDone,   // File is CRCed, field CRC is filled
    isPixRefd,   // File is Pixel-referenced
    isThumbDone, // File has passed thumbnailing thread
    isNewItem,   // This file is added in current session
    isDeleted,   // Deleted from disk
    isNoAccess,  // File could not be accessed (not found)
    isVerified,  // File is verified after being loaded and its
                 // ffNoAccess and ffDeleted flags are valid
    isDecodeErr, // Decoding error in file

    isTemporary, // This item is only a temporary element of the collection

    isReadOnly,
    isHidden,

    // we "misuse" the state to also allow 4 selection sets
    isSelectBit1,  // Selection bit 1
    isSelectBit2   // Selection bit 2

  );
  TsdItemStates = set of TsdItemState;

const

  isSelectBits: array[TSelectBit] of TsdItemState =
    (isSelectBit1, isSelectBit2);

  csNoSeries   =  0; // No Series selected

  cDefaultRating = 100; // Default rating

  cAbcviewFileVersion: byte = 12;

type

  TsdItem = class;

  // The item type of a TItem object.
  TItemType = (
    itItem,
    itFile,
    itFolder,
    itGroup,
    itSeries
  );

  TItemTypes = set of TItemType;

  // Update types
  TUpdateFlag = (
    ufListing,   // The listing updated, and item needs to be redrawn in the list
    ufGraphic    // The graphic updated, item needs to be thumbnailed again etc
  );

  TUpdateFlags = set of TUpdateFlag;

  TNotifyItemEvent = procedure(Sender: TObject; AItem: TsdItem) of object;

  TNotifyGuidEvent = procedure (Sender: TObject; const AGuid: TGUID) of object;

  TNotifyItemTypeEvent = procedure (Sender: TObject; AItemType: TItemType) of object;

  TStatusMessageEvent = procedure(Sender: TObject; AMessage: string) of object;

  TRequestType = (
    rtThumbnail,
    rtGraphic,
    rtResample
  );

  TRequestPriority = (
    rpHigh,
    rpMedium,
    rpLow
  );

  TGraphicResult = (
    grOK,
    grDelayed,
    grDecodeErr,
    grResampleErr,
    grExpired,
    grNotFound
  );

  // TsdItem is the basic class that contains an item in the general sense. The
  // minimal footprint for TItem is kept as low as possible to allow a list
  // of them to reside in memory.

  // Some core functionality is present for:
  // - Loading/Storing itself from/to a stream
  // - Options
  // - Thumbnail representation
  // - Properties

  // TsdItem class
  TsdItem = class
  private
    FGuid: TGUID;            // Globally unique ID for reference within the list, the list is sorted on this value
  protected
    FBand: smallint;         // Group number for the color band or -1 for no color
    FIcon: integer;          // Pointer to system or imagelist icon - not stored
    FRating: word;           // Popularity (rating) of item
    FStates: TsdItemStates;  // States
    FProps: TsdPropertyList; // Owned list of custom properties for this item
    function GetDescription: string; virtual;
    function GetDragTypes: TDragTypes; virtual;
    function GetDrive: string; virtual;
    function GetFileName: string; virtual;
    function GetFolderName: string; virtual;
    function GetHeight: integer; virtual;
    function GetIcon: integer; virtual;
    function GetIsSelected(Index: TSelectBit): boolean; virtual;
    function GetItemType: TItemType; virtual;
    function GetName: string; virtual;
    function GetWidth: integer; virtual;
    procedure SetBand(AValue: integer); virtual;
    procedure SetDescription(AValue: string); virtual;
    procedure SetFolderName(AValue: string); virtual;
    procedure SetIsSelected(Index: TSelectBit; AValue: boolean); virtual;
    procedure SetIsThumbed(AValue: boolean); virtual;
    procedure SetName(AValue: string); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetGuid(const AGuid: TGUID);
    // Call AcceptDrop to let the item handle a drop
    procedure AcceptDrop(var Effect: integer); virtual;
    // Call AllowDrop to verify if the item can handle a drop from the
    // global DropList. AllowDrop returns true if it can and returns false
    // if the types are not drop-compatible. The Effect should be set to
    // DROPEFFECT_COPY or DROPEFFECT_LINK if no move is supported
    function AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean; virtual;
    // Call AddGraphic to add a graphic to the internal cache
    procedure AddGraphic(ARequest: TRequestType; APriority: TRequestPriority;
      AWidth, AHeight: integer; AGraphic: TBitmap);
    // Use AddProperty to add the TProperty object AProperty to the chain of
    // properties.
    function AddProperty(AProperty: TsdProperty): TsdProperty;
    // Calculate the pixel reference for this item (will be added as property)
    procedure CalculatePixRef;
    // GetAspectRatio returns the aspect ratio of the image or 0 if
    // no image is present. Ratio is defined as Width / Height
    function GetAspectRatio: double;
    // GetBitmap will try to retrieve the normal, unresized bitmap for this item
    // and copy the result in ABitmap
    procedure GetBitmap(ABitmap: TBitmap);
    // Call GetGraphic to obtain a thumbnail or full graphic of the item provided
    // that a copy is present. If it is not present, a request is issued automatically
    // and the application is notified through ACallBack. For parameters see
    // TPictureMngr.GetGraphic. Call RetrieveThumbnail or RetrievePicture if you
    // want to get an instant copy.
    function GetGraphic(ARequest: TRequestType; APriority: TRequestPriority;
      AWidth, AHeight, ADelay: integer; ACallBack: TNotifyGuidEvent; AProgress: TStatusMessageEvent;
      AGraphic: TBitmap): TGraphicResult;
    // Call GetImageDimensions to get the images width, height and Bits Per Pixel
    // The function returns True if successful and False if not (e.g. not an image)
    // The dimensions are found from property TPicDim or if not there, from loading
    // the image.
    function GetImageDimensions(var SizeX, SizeY: integer; var PixelFormat: TPixelFormat): boolean;
    // Getproperty will return a pointer to the property with AnID, or nil if
    // the property does not exist.
    function GetProperty(APropID: integer): TsdProperty;
    // Call GetTags to get Exif, Ciff and Iptc tags into XML. XML must be an initialised
    // XML Object
    procedure GetTags(AXml: TXmlNode); virtual;
    // This function returns true if the item can produce a bitmap (other than icon)
    function HasBitmap: boolean; virtual;
    // Call HasGraphic to obtain a graphic of the item provided a copy is present.
    // No requests are issued.
    function HasGraphic(ARequest: TRequestType; APriority: TRequestPriority;
      AWidth, AHeight: integer; ACallBack: TNotifyGuidEvent;
      AGraphic: TBitmap): TGraphicResult;
    // HasProperty will return True if a property with AnID exists, or False if not
    function HasProperty(APropID: integer): boolean;
    procedure ReadComponents(S: TStream); virtual;
    procedure RemoveProperty(APropID: integer);
    function Rename(NewName: string): string; virtual;
    procedure Request(ARequest: TRequestType; APriority: TRequestPriority;
      AWidth, AHeight, ADelay: integer; ABitmap: TBitmap; ACallBack: TNotifyGuidEvent;
      AProgress: TStatusMessageEvent);
    // RetrievePicture will put a copy of the Item's picture in ALoader.Bitmap. Use
    // the properties of ALoader to select what quality the bitmap must be.
    // ALoader is of class TsdGraphicLoader, but can't be passed as such because
    // of circular unit reference
    procedure RetrievePicture(ALoader: TObject); virtual;
    procedure RetrievePictureInfo(var ASizeX, ASizeY: integer;
      var APixelFormat: TPixelFormat); virtual;
    // Retrieve the thumbnail of this item and put it in ABitmap (synchronous).
    // ABitmap must be initialized
    procedure RetrieveThumbnail(ABitmap: TBitmap; ALoader: TObject); virtual;
    // Retrieves the thumbnail and put it in stream S
    function RetrieveThumbnailStream(S: TStream): boolean; virtual;
    // Call Update with [ufListing] when
    // - a change that should be saved is made
    // - a change of a property that can be sorted or is showing in the list is made
    // Call Update with [ufGraphic]
    // - a change is made to the graphic (rotated, flipped, cropped etc)
    // - a change is made to file content (filesize, content, etc)
    procedure Update(UpdateFlags: TUpdateFlags);
    procedure WriteComponents(S: TStream); virtual;
    procedure SetState(AState: TsdItemState; AValue: boolean); virtual;
    procedure SetStates(const AStates: TsdItemStates; AValue: boolean); virtual;
    // Band returns the color band code for this item. This is -1 if none, or
    // 0...Number of Bands - 1 when the item belongs to a band. This principle
    // is used for e.g. duplicate groups
    property Band: smallint read FBand write FBand;
    // Description returns the description property or '' if not present
    property Description: string read GetDescription write SetDescription;
    // DragType returns the allowed drag methods for this item (move, copy, link)
    property DragTypes: TDragTypes read GetDragTypes;
    // Returns the drive this item is associated with (for ancestors)
    property Drive: string read GetDrive;
    // Filename returns the fully qualified filename of the item (for descendants)
    property FileName: string read GetFileName;
    // Foldername returns the fully qualified name of the folder including trailing backslash
    property FolderName: string read GetFolderName write SetFolderName;
    // Height is the vertical number of pixels
    property Height: integer read GetHeight;
    // Icon is the index number of the Item's icon in the system image
    // list.
    property Icon: integer read GetIcon;
    // Test if an item is selected in the selection set Index. Index can have
    // values sbBit1 through sbBit4. Set the IsSelected property to select
    // an Item in the list
    property IsSelected[Index: TSelectBit]: boolean read GetIsSelected write
      SetIsSelected;
    property IsThumbed: boolean {read GetIsThumbed} write SetIsThumbed;
    // The Guid is a globally unique 16byte value for each item. At insertion of a new
    // item in the root list this value is assigned a unique value through the
    // GetGuid function.
    property Guid: TGUID read FGuid;
    // ItemType represents the Items type. It equals itItem for TItem and is
    // different for descendants of TItem.
    property ItemType: TItemType read GetItemType;
    // Name is the general string representing the name of the TItem. It is
    // meaningless in a TItem but not meaningless in its descendants:
    // - In TFile it represents the filename of the file, without the path but
    //   including the extension.
    // - In TFolder it represents the short name of the folder (last part of
    //  the path, no backslashes)
    // - In TGroup it represents the group name.
    // - In TSeries it represents the series name.
    property Name: string read GetName write SetName;
    // Rating indicates the quality rating of the item,
    // ranging from 0 to 200 for the moment
    // 0   = poor
    // 200 = excellent
    // Future expansion could use the upper byte.
    property Rating: word read FRating write FRating;
    // Read States to determine the state of the item. Set States to True or False
    // to indicate a changed state of the item. States include:
    // - isCRCDone    : File is CRC-ed, field FCRC is filled
    // - isPixRefd  : File is Pixel-referenced, and fields FMini/FAspect are filled
    // - isNewItem  : Item is added in current session
    // - isDeleted  : File/Folder is deleted from disk
    // - isNoAccess : File/Folder could not be accessed (is not found on disk)
    // - isVerified : File is verified after being loaded and still exists
    // - isDecodeErr: Decoding error in file/folder/series/group graphic
    // - isTemporary: This item is only a temporary element of the collection
    // - isReadOnly : This item is read-only in the file system
    // - isHidden   : This item is hidden in the file system
    // Specify more than one state by adding them, e.g. States[State1 + State2]
    property States: TsdItemStates read FStates write FStates;
    property Width: integer read GetWidth;
  end;

  TsdFolder = class(TsdItem)
  protected
    FDrive: string;       // Drive name (UNC) eg 'C:\'
    FParentGuid: TGUID;   // ID of parent folder, or empty if no parent
    FModified: TDateTime; // Folder date&time
    FPath: string;        // Folder path without drive, includes trailing \
    FOptions: TFolderOptions;
    function GetDragTypes: TDragTypes; override;
    function GetDrive: string; override;
    // Returns the foldername *without* the slash
    function GetFileName: string; override;
    // Returns the foldername *with* the slash
    function GetFolderName: string; override;
    function GetIncludeSubdirs: boolean;
    function GetItemType: TItemType; override;
    // GetName returns the short folder name (only last part, without slash)
    function GetName: string; override;
    function GetParentGuid: TGUID;
    function GetParentFolderName: string;
    procedure SetFolderName(AValue: string); override;
    procedure SetOptions(AValue: TFolderOptions);
  public

    FAttr: integer;       // Folder attributes
    FFolderType: string;  // Folder type
    FVolume: string;      // Disk Volume label

    property IncludeSubdirs: boolean read GetIncludeSubdirs;
    property Modified: TDateTime read FModified write FModified;
    property Options: TFolderOptions read FOptions write SetOptions;
    // Parent ID will yield the ItemID of the parent folder, if any. ParentID
    // will return 0 if no parent folder is present.
    property ParentGuid: TGUID read GetParentGuid write FParentGuid;
    // ParentFolderName will return the name including backslash of the parent
    // folder, or empty string if the folder is already the root.
    property ParentFolderName: string read GetParentFolderName;

    constructor Create; override;
    destructor Destroy; override;
    procedure AcceptDrop(var Effect: integer); override;
    function AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean; override;
    // Gets icon index and filetype string.
    procedure GetIconAndType(var AIcon: integer; var AType: string);
    // Get the statistics for this folder. ATotalSize is in KB
    procedure GetStatistics(var ANumFiles: integer; var ATotalSize: double);
    // Get the status string for the folder
    function GetStatusString: string;
    function HasAsParent(const AParentGuid: TGUID): boolean;
    function IsReadOnly: boolean;
    function Rename(NewName: string): string; override;
    procedure ReadComponents(S: TStream); override;
    procedure WriteComponents(S: TStream); override;
  end;

  TFolderStatsProp = class(TsdProperty)
  protected
    function GetPropID: word; override;
  public
    FNumFiles: integer;
    FTotalSize: double;
  end;

  TsdFile = class(TsdItem)
  protected
    FCRC: cardinal;       // Cyclic Redundancy Check (CRC32) of the file
    FFolderGuid: TGUID;   // ID of Folder where this file resides
    FModified: TDateTime; // File date & time
    FName: string;        // The name of the item (filename, foldername etc)
    FSeries: integer;     // ID of Series where this file belongs to
    FSize: int64;         // File size in bytes - used to be only up to 2GB but now 64bit
    // A CRC-like value for just the first 1024 bytes. If this FSmallCRC = 0 then
    // it is not calculated, otherwise it is always > 0
    FSmallCRC: word;
    function GetComprRatioAsString: string; virtual;
    function GetCRCAsString: string; virtual;
    function GetDimensions: string; virtual;
    function GetDragTypes: TDragTypes; override;
    function GetDrive: string; override;
    // FileName returns the fully qualified filename of TFile.
    function GetFileName: string; override;
    function GetFolder: TsdFolder; virtual;
    function GetFolderName: string; override;
    function GetGroupsAsString: string; virtual;
    function GetIcon: integer; override;
    function GetItemType: TItemType; override;
    function GetModifiedAsString: string; virtual;
    function GetName: string; override;
    function GetRatingAsString: string; virtual;
    function GetSizeAsString: string; virtual;
    function GetSeriesAsString: string; virtual;
    // Get the status string of a file.
    function GetStatusString: string; virtual;
    function GetTypeAsString: string; virtual;
    procedure SetName(AValue: string); override;
    procedure SetSize(Value: int64); 
  public
    property ComprRatioAsString: string read GetComprRatioAsString;
    property CRC: cardinal read FCRC write FCRC;
    property CRCAsString: string read GetCRCAsString;
    property Dimensions: string read GetDimensions;
    property Folder: TsdFolder read GetFolder;
    property FolderGuid: TGUID read FFolderGuid write FFolderGuid;
    property GroupsAsString: string read GetGroupsAsString;
    property Modified: TDateTime read FModified write FModified;
    property ModifiedAsString: string read GetModifiedAsString;
    property RatingAsString: string read GetRatingAsString;
    property Series: integer read FSeries write FSeries;
    property SeriesAsString: string read GetSeriesAsString;
    property Size: int64 read FSize write SetSize;
    property SizeAsString: string read GetSizeAsString;
    property SmallCRC: word read FSmallCRC write FSmallCRC;
    property StatusString: string read GetStatusString;
    property TypeAsString: string read GetTypeAsString;
    constructor Create; override;
    procedure AcceptDrop(var Effect: integer); override;
    function AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean; override;
    procedure CalculateCRCValue;
    procedure CalculateSmallCRCValue;
    function CompressionRatio(var Ratio: double): boolean;
    function HasBitmap: boolean; override;
    procedure ReadComponents(S: TStream); override;
    // Gets icon index and filetype string.
    procedure GetIconAndType(var AIcon: integer; var AType: string);
    // Extension returns the extension of the file (including the dot),
    // in lower case
    function Extension: string;
    // FileType returns the filetype name according to the shell
    function FileType: string;
    procedure GetTags(AXml: TXmlNode); override;
    // Call IsGraphicsFile to determine if a file is a graphics file and
    // can be decoded as a bitmap. The test is based on file extension only!
    function IsGraphicsFile: boolean;
    // OriginalName returns the name of the item as it might have been
    // before auto-renaming (so "_2", "copy of" etcetera is stripped).
    function OriginalName: string;
    function Rename(NewName: string): string; override;
    procedure RetrievePicture(ALoader: TObject); override;
    procedure RetrievePictureInfo(var ASizeX, ASizeY: integer;
      var APixelFormat: TPixelFormat); override;
    function SquarePixels(var SqPix: cardinal): boolean;
    // Call Verify to verify the file (check existance). This will
    // set the ffVerified flag
    procedure Verify;
    procedure WriteComponents(S: TStream); override;
  end;

  TsdGroup = class(TsdItem)
  protected
    function GetItemType: TItemType; override;
  public
    procedure AcceptDrop(var Effect: integer); override;
    function AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean; override;
  end;

  TsdSeries = class(TsdItem)
  protected
    function GetItemType: TItemType; override;
  public
    procedure AcceptDrop(var Effect: integer); override;
    function AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean; override;
  end;

  TItemDifferenceFunction = function(Item1, Item2: TsdItem; Data1, Data2: pointer; Limit: integer): integer;
  TDataPointerFunction = function(Item: TsdItem): pointer;


const
  cEmptyGuid: TGUID = (D1: 0; D2: 0; D3: 0; D4: (0, 0, 0, 0, 0, 0, 0, 0));

function CompareItemGuid(Item1, Item2: TObject; Info: pointer): integer;

implementation

uses
  guiMain, guiShow, Crc32, Filers, Thumbnails, PixRefs,
  sdStreamableData, sdGraphicLoader, sdMetadata, guiPlugins, Pictures,
  ActiveX;


{ ffCRCed      = $0001;  // File is CRCed, field CRC is filled
  ffPixRefd    = $0002;  // File is Pixel-referenced
  ffThumbed    = $0080;  // File has passed thumbnailing thread
  ffNewItem    = $0004;  // This file is added in current session
  ffDeleted    = $0008;  // Deleted from disk
  ffNoAccess   = $0010;  // File could not be accessed (not found)
  ffVerified   = $0020;  // File is verified after being loaded and its
                         // ffNoAccess and ffDeleted flags are valid
  ffDecodeErr  = $0040;  // Decoding error in file

  ffTemporary  = $0100;  // This item is only a temporary element of the collection

  ffSelectBit1 = $1000;  // Selection bit 1
  ffSelectBit2 = $2000;  //
  ffSelectBit3 = $4000;  //
  ffSelectBit4 = $8000;  // Selection bit 4}

function FlagsToStates(AFlags: word): TsdItemStates;
begin
  Result := [];
  if AFlags and $0001 <> 0 then include(Result, isCRCDone);
  if AFlags and $0002 <> 0 then include(Result, isPixRefd);
  if AFlags and $0080 <> 0 then include(Result, isThumbDone);
  if AFlags and $0004 <> 0 then include(Result, isNewItem);
  if AFlags and $0008 <> 0 then include(Result, isDeleted);
  if AFlags and $0010 <> 0 then include(Result, isNoAccess);
  if AFlags and $0020 <> 0 then include(Result, isVerified);
  if AFlags and $0040 <> 0 then include(Result, isDecodeErr);
  if AFlags and $0100 <> 0 then include(Result, isTemporary);
  if AFlags and $0200 <> 0 then include(Result, isReadOnly);
  if AFlags and $0400 <> 0 then include(Result, isHidden);
end;

function StatesToFlags(const AStates: TsdItemStates): word;
begin
  Result := 0;
  if isCRCDone   in AStates then inc(Result, $0001);
  if isPixRefd   in AStates then inc(Result, $0002);
  if isThumbDone in AStates then inc(Result, $0080);
  if isNewItem   in AStates then inc(Result, $0004);
  if isDeleted   in AStates then inc(Result, $0008);
  if isNoAccess  in AStates then inc(Result, $0010);
  if isVerified  in AStates then inc(Result, $0020);
  if isDecodeErr in AStates then inc(Result, $0040);
  if isTemporary in AStates then inc(Result, $0100);
  if isReadOnly  in AStates then inc(Result, $0200);
  if isHidden    in AStates then inc(Result, $0400);
end;

function CompareItemGuid(Item1, Item2: TObject; Info: pointer): integer;
begin
  Result := CompareGuid(TsdItem(Item1).Guid, TsdItem(Item2).Guid);
end;

{ TsdItem }

function TsdItem.GetDescription: string;
var
  Prop: TsdProperty;
begin
  Result := '';
  Prop := GetProperty(prDescription);
  if assigned(Prop) then
    Result := Prop.Value;
end;

function TsdItem.GetDragTypes: TDragTypes;
begin
  // Defaults to all
  Result := [dtMove, dtCopy, dtLink];
end;

function TsdItem.GetDrive: string;
begin
  Result := '';
end;

function TsdItem.GetFileName: string;
begin
  // No filename per default
  Result := '';
end;

function TsdItem.GetFolderName: string;
begin
  // No foldername per default
  Result := '';
end;

function TsdItem.GetHeight: integer;
var
  Prop: TsdProperty;
begin
  Result := 0;
  Prop := GetProperty(prDimensions);
  if assigned(Prop) then
    Result := TprDimensions(Prop).SizeY;
end;

function TsdItem.GetIcon: integer;
begin
  // Default returns the FIcon
  Result := FIcon;
end;

function TsdItem.GetIsSelected(Index: TSelectBit): boolean;
begin
  Result := isSelectBits[Index] in FStates;
end;

function TsdItem.GetItemType: TItemType;
begin
  Result := itItem;
end;

function TsdItem.GetName: string;
begin
  Result := GuidToString(Guid);
end;

function TsdItem.GetWidth: integer;
var
  Prop: TsdProperty;
begin
  Result := 0;
  Prop := GetProperty(prDimensions);
  if assigned(Prop) then
    Result := TprDimensions(Prop).SizeX;
end;

procedure TsdItem.SetBand(AValue: integer);
begin
  // Default does nothing
end;

procedure TsdItem.SetDescription(AValue: string);
var
  Prop: TprDescription;
begin
  if length(AValue) > 0 then
  begin
    if not HasProperty(prDescription) then
    begin
      Prop := TprDescription.Create;
      AddProperty(Prop);
    end else
      Prop := TprDescription(GetProperty(prDescription));

    // Store new value
    if AValue <> Prop.FDescription then
    begin
      Prop.FDescription := AValue;
      Update([ufListing]);
    end;

  end else
  begin
    if HasProperty(prDescription) then
    begin
      RemoveProperty(prDescription);
      Update([ufListing]);
    end;
  end;
end;

procedure TsdItem.SetFolderName(AValue: string);
begin
//default does nothing
end;

procedure TsdItem.SetIsSelected(Index: TSelectBit; AValue: boolean);
begin
  SetState(isSelectBits[Index], AValue);
end;

procedure TsdItem.SetIsThumbed(AValue: boolean);
begin
  if AValue = False then
    RemoveProperty(prThumbnail);
  SetState(isThumbDone, AValue);
end;

procedure TsdItem.SetName(AValue: string);
begin
//default does nothing
end;

procedure TsdItem.SetState(AState: TsdItemState; AValue: boolean);
begin
  if AValue then
    include(FStates, AState)
  else
    exclude(FStates, AState);
end;

procedure TsdItem.SetStates(const AStates: TsdItemStates; AValue: boolean);
begin
  if AValue then
    FStates := FStates + AStates
  else
    FStates := FStates - AStates;
end;

constructor TsdItem.Create;
begin
  inherited Create;
  FGuid := NewGuid;
  FProps := TsdPropertyList.Create(True);
  FBand := ciNoBand;
  FIcon := ciNoIcon;
  FRating := cDefaultRating;
end;

destructor TsdItem.Destroy;
begin
  // We must free all the properties
  FreeAndNil(FProps);
  inherited;
end;

procedure TsdItem.AcceptDrop(var Effect: integer);
begin
// Nothing
end;

function TsdItem.AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean;
begin
  Result := False;
end;

procedure TsdItem.CalculatePixRef;
var
  PixRef: TprPixRef;
  Bitmap: TBitmap;
begin
  // Did we already?
  if isPixRefd in States then
    exit;
  // No, so do it now
  SetState(isPixRefd, True);
  // calculate Pixel Reference
  PixRef := TprPixRef(GetProperty(prPixRef));
  if not assigned(PixRef) then
  begin
    // Create pixel reference
    PixRef := TprPixRef.Create;
    // These come from Globalvars
    PixRef.SetSizeTo(FGranularity, FMatchMethod);
    // Get the file's bitmap
    Bitmap := TBitmap.Create;
    try
      RetrieveThumbnail(Bitmap, nil);
      if HasContent(Bitmap) then
      begin
        PixRef.RefFromBitmap(Bitmap);
        // Add this pixref to the file
        AddProperty(PixRef);
      end else
        PixRef.Free;
    finally
      Bitmap.Free;
    end;
  end;
end;

procedure TsdItem.AddGraphic(ARequest: TRequestType; APriority: TRequestPriority;
  AWidth, AHeight: integer; AGraphic: TBitmap);
begin
  if assigned(frmMain.Root) and assigned(frmMain.Root.Mngr) then
    frmMain.Root.Mngr.AddGraphic(Guid, ARequest, APriority, AWidth, AHeight, AGraphic);
end;

function TsdItem.AddProperty(AProperty: TsdProperty): TsdProperty;
begin
  Result := nil;
  if not assigned(AProperty) then
    exit;
  FProps.Add(AProperty);
  if AProperty.IsStored then
    frmMain.Root.IsChanged := True;
  Result := AProperty;
end;

function TsdItem.GetAspectRatio: double;
var
  X, Y: integer;
  Pix: TPixelFormat;
begin
  Result := 0;
  if GetImageDimensions(X, Y, Pix) then
    Result := X / Y;
end;

procedure TsdItem.GetBitmap(ABitmap: TBitmap);
var
  Loader: TsdGraphicLoader;
begin
  if assigned(ABitmap) then
  begin
    Loader := TsdGraphicLoader.Create;
    try
      RetrievePicture(Loader);
      ABitmap.Assign(Loader.Bitmap);
    finally
      Loader.Free;
    end;
  end;
end;

function TsdItem.GetGraphic(ARequest: TRequestType; APriority: TRequestPriority;
  AWidth, AHeight, ADelay: integer; ACallBack: TNotifyGuidEvent; AProgress: TStatusMessageEvent;
  AGraphic: TBitmap): TGraphicResult;
begin
  Result := grDecodeErr;
  if States * [isDecodeErr, isNoAccess] <> [] then
  begin
    if ARequest = rtThumbnail then
    begin
      // Check thumbnail storage
      RetrieveThumbnail(AGraphic, nil);
      if HasContent(AGraphic) then
        Result := grOK;
    end;
  end else
  begin
    if assigned(frmMain.Root) and assigned(frmMain.Root.Mngr) and not (isDecodeErr in States) then
    begin

      // Check cache
      Result := frmMain.Root.Mngr.GetGraphic(Guid, ARequest, APriority, AWidth, AHeight,
        ADelay, ACallBack, AProgress, AGraphic);

      if Result = grDecodeErr then
        SetState(isDecodeErr, True);
    end;
  end;
end;

function TsdItem.GetImageDimensions(var SizeX, SizeY: integer; var PixelFormat: TPixelFormat): boolean;
var
  Dims: TprDimensions;
begin
  // Try to read them from the property
  Dims := TprDimensions(GetProperty(prDimensions));
  if assigned(Dims) then
  begin
    SizeX := Dims.SizeX;
    SizeY := Dims.SizeY;
    PixelFormat := Dims.PixelFormat;
    Result := True;
  end else
  begin
    RetrievePictureInfo(SizeX, SizeY, PixelFormat);
    Result := (SizeX > 0) and (SizeY > 0);
    // Set for future use
    if Result then
    begin
      Dims := TprDimensions.Create;
      Dims.SizeX := SizeX;
      Dims.SizeY := SizeY;
      Dims.PixelFormat := PixelFormat;
      AddProperty(Dims);
      if FUpdateFromBgr then
        Update([ufListing]);
    end;
  end;
end;

function TsdItem.GetProperty(APropID: integer): TsdProperty;
begin
  Result := FProps.ByPropID(APropID);
end;

procedure TsdItem.GetTags(AXML: TXmlNode);
begin
// Default does nothing
end;

function TsdItem.HasBitmap: boolean;
begin
  Result := False;
end;

function TsdItem.HasGraphic(ARequest: TRequestType; APriority: TRequestPriority;
      AWidth, AHeight: integer; ACallBack: TNotifyGuidEvent;
      AGraphic: TBitmap): TGraphicResult;
begin
  Result := grDecodeErr;
  if assigned(frmMain.Root) and assigned(frmMain.Root.Mngr) and not (isDecodeErr in States) then
  begin

    Result := frmMain.Root.Mngr.HasGraphic(Guid, ARequest, APriority, AWidth, AHeight,
      AGraphic);
    if Result = grDecodeErr then
      SetState(isDecodeErr, True);

  end;
end;

function TsdItem.HasProperty(APropID: integer): boolean;
begin
  Result := assigned(FProps.ByPropID(APropID))
end;

procedure TsdItem.Update(UpdateFlags: TUpdateFlags);
begin
  if ufGraphic in UpdateFlags then
  begin
    // Remove thumbnail (if present)
    frmMain.Root.Mngr.Remove(Self);
    if assigned(ShowMngr) then
      ShowMngr.Remove(Self);

    // Remove properties
    RemoveProperty(prDimensions);
    RemoveProperty(prAttachment);
    RemoveProperty(prDupeGroup);
    IsThumbed := False;
    SetStates([isCRCDone, isPixRefd], False);
    FIcon := -1;

    // Root should index again
    frmMain.Root.MustIndex := True;
    // Update the listing since the dimensions might have changed
    UpdateFlags := UpdateFlags + [ufListing];
  end;

  if ufListing in UpdateFlags then
  begin
    frmMain.Root.AddUpdateItem(Self);
  end;
end;

procedure TsdItem.RetrievePicture(ALoader: TObject);
begin
// does nothing, must be overridden in descendants
end;

procedure TsdItem.RetrievePictureInfo(var ASizeX, ASizeY: integer; var APixelFormat: TPixelFormat);
begin
  // does nothing, must be overridden in descendants
  ASizeX := 0;
  ASizeY := 0;
  APixelFormat := pfDevice;
end;

procedure TsdItem.RetrieveThumbnail(ABitmap: TBitmap; ALoader: TObject);
  //local
  procedure ThumbFromBacking(Resample: boolean);
  var
    Orig: TBitmap;
    Thumb: TprThumbnail;
  begin
    Thumb := TprThumbnail(GetProperty(prThumbnail));
    // Do we have the property?
    if assigned(Thumb) then with Thumb do
    begin
      // The right format?
      if Resample or ((Thumb.Width = FThumbWidth) and (Thumb.Height = FThumbHeight)) then
      begin
        if Resample then
        begin

          // Use resampling
          Orig := TBitmap.Create;
          try
            if LoadBitmap(Orig) and assigned(ABitmap) then
            begin
              ABitmap.PixelFormat := pf24bit;
              // use fancy upsampling if FThumbHQ = True
              RescaleImage(Orig, ABitmap, FThumbWidth, FThumbHeight, True, True, FThumbHQ);
            end;
          finally
            Orig.Free;
          end;

        end else

          // No resampling
          LoadBitmap(ABitmap);

      end;
    end;
  end;
  // local
  procedure ThumbFromFile;
  var
    Thumb: TprThumbnail;
    L: TsdGraphicLoader;
  begin
    try
      L := TsdGraphicLoader(ALoader);
      if not assigned(L) then
        L := TsdGraphicLoader.Create;
      try
        // Use a 1/X loading technique
        L.Quality := iqThumb;
        L.SetDestSize(FThumbWidth, FThumbHeight);
        RetrievePicture(L);

        if HasContent(L.Bitmap) and assigned(ABitmap) then
        begin

          // Create 24bit bitmaps to make sure we don't get bleached colors
          ABitmap.PixelFormat := pf24Bit;

          // Rescale to thumbnail size
          RescaleImage(L.Bitmap, ABitmap,
            FThumbWidth, FThumbHeight,
            True,     // Downscale the image
            False,    // Do not upscale the image
            FThumbHQ);   // Fancy sampling for high quality thumbnails

          // Here we can create the thumbnail property
          if FStoreThumbs then
          begin

            Thumb := TprThumbnail(GetProperty(prThumbnail));
            if not assigned(Thumb) then
            begin
              Thumb := TprThumbnail.Create;

              Thumb.Width := FThumbWidth;
              Thumb.Height := FThumbHeight;
              Thumb.SaveBitmap(ABitmap);

              SetState(isThumbDone, True);
              AddProperty(Thumb);
            end;
          end;
        end;
      finally
        if L <> ALoader then
          L.Free;
      end;
    except
      // some load error
      SetState(isDecodeErr, True);
    end;
  end;
//main
begin
  // Try to read from backing file with no resampling
  ThumbFromBacking(False);

  if not HasContent(ABitmap) then
    // Try to read from file directly
    ThumbFromFile;

  if not HasContent(ABitmap) then
    // Try to read from backing file WITH resampling - last hope
    ThumbFromBacking(True);
end;

function TsdItem.RetrieveThumbnailStream(S: TStream): boolean;
var
  Thumb: TprThumbnail;
begin
  Result := False;
  Thumb := TprThumbnail(GetProperty(prThumbnail));
  // Do we have the property?
  if not assigned(Thumb) then
    exit;

 // The right format?
  if (Thumb.Width = FThumbWidth) and (Thumb.Height = FThumbHeight) then
    Result := Thumb.LoadStream(S);
end;

procedure TsdItem.ReadComponents(S: TStream);
var
  Ver: byte;
  Flags: word;
begin
  // Read Version No
  StreamReadByte(S, Ver);
  if Ver <> cAbcviewFileVersion then
    raise Exception.Create('invalid stream version');
  StreamReadGuid(S, FGuid);
  StreamReadWord(S, Flags);
  FStates := FlagsToStates(Flags);
  StreamReadWord(S, FRating);

  // Read custom properties chain
  FProps.ReadFromStream(S);
end;

procedure TsdItem.RemoveProperty(APropID: integer);
var
  i: integer;
begin
  for i := FProps.Count - 1 downto 0 do
  begin
    if FProps[i].PropID = APropID then
      FProps.Delete(i);
  end;
end;

function TsdItem.Rename(NewName: string): string;
begin
  // Default just sets the name
  Name := NewName;
  Result := Name;
end;

procedure TsdItem.Request(ARequest: TRequestType; APriority: TRequestPriority;
  AWidth, AHeight, ADelay: integer; ABitmap: TBitmap; ACallBack: TNotifyGuidEvent; AProgress: TStatusMessageEvent);
var
  Mngr: TPictureMngr;
begin
  Mngr := nil;
  if assigned(frmMain.Root) then
    Mngr := frmMain.Root.Mngr;
  if assigned(Mngr) and not (isDecodeErr in States) then
  begin
    Mngr.Request(Guid, ARequest, APriority, AWidth, AHeight, ADelay, ABitmap,
      ACallBack, AProgress);
  end;
end;

procedure TsdItem.WriteComponents(S: TStream);
var
  Flags: word;
begin
  // Write Version No
  StreamWriteByte(S, cAbcviewFileVersion);

  StreamWriteGuid(S, FGuid);
  Flags := StatesToFlags(FStates);
  StreamWriteWord(S, Flags);
  StreamWriteWord(S, FRating);

  FProps.WriteToStream(S);
end;

procedure TsdItem.SetGuid(const AGuid: TGUID);
begin
  FGuid := AGuid;
end;

{ TsdFolder }

function TsdFolder.GetDragTypes: TDragTypes;
begin
  Result := inherited GetDragTypes;
  if IsReadOnly or IsWindowsFolder(FolderName) then
    Result := Result - [dtMove];
end;

function TsdFolder.GetDrive: string;
begin
  Result := FDrive;
end;

function TsdFolder.GetFileName: string;
begin
  Result := ExcludeTrailingPathDelimiter(FolderName);
end;

function TsdFolder.GetFolderName: string;
begin
{$warnings off}
  Result := IncludeTrailingBackslash(FDrive) + FPath;
{$warnings on}

end;

function TsdFolder.GetIncludeSubdirs: boolean;
begin
  Result := FOptions.InclSubdirs;
end;

function TsdFolder.GetItemType: TItemType;
begin
  Result := itFolder;
end;

function TsdFolder.GetName: string;
var
  AName: string;
  Index: integer;
begin
  AName := ExcludeTrailingPathDelimiter(FolderName);
  Index := LastDelimiter('\', AName);
  if Index > 0 then
    Result := copy(AName, Index + 1, length(AName))
  else
    Result := AName;
end;

function TsdFolder.GetParentFolderName: string;
begin
  Result := GetParentFolder(FolderName);
end;

function TsdFolder.GetParentGuid: TGUID;
var
  AFolder: TsdFolder;
begin
  if IsEmptyGuid(FParentGuid) then
  begin
    // Use the root to find the parent folder
    AFolder := frmMain.Root.FolderByName(ParentFolderName);
    if assigned(AFolder) then
      FParentGuid := AFolder.Guid;
  end;
{  // We searched but did not find, don't do another search
  // When adding folders, all 0's must be reset to -1's again by root
  if IsEmptyGuid(FParentGuid) then
    FParentID := 0;
  Result := FParentID;}
end;

procedure TsdFolder.SetFolderName(AValue: string);
var
  Full: string;
begin
  Full := ExpandFilename(IncludeTrailingPathDelimiter(Avalue));
  FDrive := ExtractFileDrive(Full);
  FPath  := ExtractRelativePath(FDrive, Full);
  // Get volume name but skip A: (makes sound during startup)
  if FDrive <> 'A:' then
    FVolume := GetDiskVolumeLabel(FDrive);
  // Make sure to re-determine parent
  FParentGuid := cEmptyGuid;
end;

procedure TsdFolder.SetOptions(AValue: TFolderOptions);
begin
  FOptions := AValue;
end;

constructor TsdFolder.Create;
begin
  inherited Create;
  FIcon := -1;
  FParentGuid := cEmptyGuid;
end;

destructor TsdFolder.Destroy;
begin
  inherited Destroy;
end;

procedure TsdFolder.GetIconAndType(var AIcon: integer; var AType: string);
var
  Info: TShFileInfo;
//main
begin
  // Icon and Type
  AIcon := FIcon;
  if AIcon < 0 then
  begin

    // We must access the folder
    if not (isNoAccess in States) then
    begin

      // get the folder info
      ShellGetFolderInfo(FolderName, Info);
      AIcon := info.IICon;
      AType := Info.szTypeName;
      if length(AType) = 0 then
        AType := 'Unknown';

      if (AICon > 0) then

        // use this icon and store the reference for future
        FIcon := AIcon;

    end;
  end;
end;

procedure TsdFolder.GetStatistics(var ANumFiles: integer; var ATotalSize: double);
var
  FirstID: integer;
  Dummy, AFile: TsdFile;
  Prop: TFolderStatsProp;
  TotalSize: int64;
begin
  // The statistics are stored in a property. If not, we have to create it
  if HasProperty(prFolderStats) then begin

    // Yes we have it
    with TFolderStatsProp(GetProperty(prFolderStats)) do begin
      ANumFiles := FNumFiles;
      ATotalSize := FTotalSize;
    end;

  end else begin
    // No we don't, so calculate

    // Calculate number of files
    ANumFiles := 0;
    TotalSize := 0;
    if assigned(frmMain.Root.FAllFiles) then begin
      Dummy := TsdFile.Create;
      try
        Dummy.FolderGuid := Guid;
        frmMain.Root.FAllFiles.Find(Dummy, FirstID);
        while (FirstID >= 0) and (FirstID < frmMain.Root.FAllFiles.Count) and
              (CompareGuid(TsdFile(frmMain.Root.FAllFiles[FirstID]).FolderGuid, Guid) = 0) do
        begin
          // Process file in folder
          AFile := TsdFile(frmMain.Root.FAllFiles[FirstID]);
          inc(ANumFiles);
          TotalSize := TotalSize +int64(AFile.Size);
          inc(FirstID);
        end;
        ATotalSize := round(TotalSize / 1024);
      finally
        Dummy.Free;
      end;
    end;

    // Create the property
    Prop := TFolderStatsProp.Create;
    with Prop do begin
      FNumFiles := ANumFiles;
      FTotalSize := ATotalSize;
    end;
    AddProperty(Prop);

  end;
end;

function TsdFolder.GetStatusString: string;
begin
  Result:='';

  if not (isVerified in States) then
    Result := 'Not Verified';

  if (isNewItem in States) and (Length(Result) = 0) then
    Result := 'New folder';

  if States * [isDeleted, isNoAccess] <> [] then
  begin
    if isDeleted in States  then
      Result := 'Deleted';
    if isNoAccess in States then
      Result := 'No Access';
  end;

end;

function TsdFolder.HasAsParent(const AParentGuid: TGUID): boolean;
var
  Parent: TsdFolder;
begin
  Result := False;
  if IsEmptyGuid(ParentGuid) then exit;
  if CompareGuid(ParentGuid, AParentGuid) = 0 then begin
    Result := True
  end else begin
    Parent := frmMain.Root.FolderByID(ParentGuid);
    if assigned(Parent) then
      Result := Parent.HasAsParent(AParentGuid);
  end;
end;

function TsdFolder.IsReadOnly: boolean;
begin
{$warnings off}
  Result := (FAttr and faReadOnly) > 0;
{$warnings on}
end;

function TsdFolder.Rename(NewName: string): string;
begin
  // Make sure to only use the last part
  NewName := ExtractFileName(ExcludeTrailingPathDelimiter(NewName));
  // Combine parent folder and new name and assign to Name property
  FolderName := IncludeTrailingPathDelimiter(ParentFolderName + NewName);
  // Read back Name property as result
  Result := FolderName;
end;

procedure TsdFolder.ReadComponents(S: TStream);
var
  ver: byte;
  AModified: integer;
begin
  inherited ReadComponents(S);
  // Read Version No
  StreamReadByte(S, Ver);
  try
    // Version 10
    StreamReadString(S, FPath);
    StreamReadString(S, FDrive);
    if Ver < 12 then
      S.Read(FOptions, SizeOf(TOldFolderOptions))
    else
      S.Read(FOptions, SizeOf(FOptions));
    if Ver <= 10 then exit;

    // Version 11
    StreamReadInteger(S, FAttr);
    StreamReadString(S, FFolderType);
    if Ver < 12 then begin
      StreamReadInteger(S, AModified);
      FModified := FileDateToDateTime(AModified);
    end else
      StreamReadDouble(S, double(FModified));
    StreamReadString(S, FVolume);

  finally
    //  States[ffVerified] := False;
  end;
end;

procedure TsdFolder.WriteComponents(S: TStream);
begin
  inherited WriteComponents(S);

  // Write Version No
  StreamWriteByte(S, 12);

  // Version 10
  StreamWriteString(S, FPath);
  StreamWriteString(S, FDrive);
  S.Write(FOptions, SizeOf(FOptions));

  // Version 11
  StreamWriteInteger(S, FAttr);
  StreamWriteString(S, FFolderType);
  StreamWriteDouble(S, FModified);
  StreamWriteString(S, FVolume);

end;

procedure TsdFolder.AcceptDrop(var Effect: integer);
begin
  // Nothing yet
  Effect := 0;
end;

function TsdFolder.AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean;
begin
  Result := False;
  with DropList do begin
    if Contains(TsdFile) or Contains(TsdFolder) then begin
      // Accept TFile and TFolder
      if ssCtrl in Shift then begin
        Effect := DROPEFFECT_COPY;
        AMessage := 'Copy to folder';
      end else begin
        Effect := DROPEFFECT_MOVE;
        AMessage := 'Move to folder';
      end;
      Result := True;
      exit;
    end;
    if Contains(TsdSeries) then begin
      // Only accept TSuries with move (move files in series to this folder)
      Effect := DROPEFFECT_MOVE;
      AMessage := 'Move files in series to this folder';
      Result := True;
      exit;
    end;
  end;
end;

{ TFolderStatsProp }

function TFolderStatsProp.GetPropID: word;
begin
  Result := prFolderStats;
end;

{ TsdFile }

function TsdFile.GetComprRatioAsString: string;
var
  Ratio: double;
begin
  if CompressionRatio(Ratio) then
    Result := Format('%3.2f', [Ratio])
  else
    Result := '';
end;

function TsdFile.GetCRCAsString: string;
begin
  if isCRCDone in States then
    Result := LowerCase(Format('%.8x', [Crc]))
  else
    Result := '';
end;

function TsdFile.GetDimensions: string;
begin
  if HasProperty(prDimensions) then
    Result := GetProperty(prDimensions).Value
  else
    Result := '';
end;

function TsdFile.GetDragTypes: TDragTypes;
var
  AFolder: TsdFolder;
begin
  Result := [];
  AFolder := GetFolder;
  if assigned(AFolder) then
    Result := AFolder.DragTypes;
end;

function TsdFile.GetDrive: string;
var
  AFolder: TsdFolder;
begin
  // Retrieve the drive from the folder
  Result := '';
  AFolder := GetFolder;
  if assigned(AFolder) then
    Result := AFolder.Drive;
end;

function TsdFile.GetFileName: string;
begin
  Result := FolderName + Name;
end;

function TsdFile.GetFolderName: string;
var
  AFolder: TsdFolder;
begin
  Result := '';
  AFolder := GetFolder;
  if assigned(AFolder) then Result := AFolder.FolderName;
end;

function TsdFile.GetGroupsAsString: string;
begin
  // Must change!
  Result := 'Unknown';
end;

function TsdFile.GetIcon: integer;
var
  AType: string;
begin
  if FIcon < 0 then
    GetIconAndType(FIcon, AType);
  Result := Max(FIcon, 0);
end;

function TsdFile.GetFolder: TsdFolder;
begin
  Result := nil;
  if assigned(frmMain.Root.FAllFolders) then
    Result := TsdFolder(frmMain.Root.FAllFolders.ItemByGuid(FFolderGuid));
end;

function TsdFile.GetItemType: TItemType;
begin
  Result := itFile;
end;

function TsdFile.GetModifiedAsString;
begin
  if isDeleted in States then
    Result := 'Deleted'
  else
    Result := DateTimeToStr(Modified);
end;

function TsdFile.GetName: string;
begin
  Result := FName;
end;

function TsdFile.GetRatingAsString: string;
begin
  Result := Format('%3.1f', [Rating / 20.0]);
end;

function TsdFile.GetSeriesAsString: string;
begin
  if Series = csNoSeries then
  begin
    Result := 'None';
  end else
  begin
    // Must change this - search name!
    Result := IntToStr(Series);
  end;
end;

function TsdFile.GetSizeAsString: string;
begin
  Result := IntToStr(Size);
end;

function TsdFile.GetTypeAsString: string;
var
  AIcon: integer;
begin
  GetIconAndType(AIcon, Result);
end;

procedure TsdFile.SetName(AValue: string);
begin
  if FName <> AValue then
  begin
    FName := AValue;
  end;
end;

constructor TsdFile.Create;
begin
  inherited Create;
  FSeries := csNoSeries;
  FStates := [isNewItem];
end;

procedure TsdFile.AcceptDrop(var Effect: integer);
begin
  // Nothing yet
  Effect := 0;
end;

function TsdFile.AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean;
begin
  Result := False;
  with DropList do
    if Contains(TsdGroup) or Contains(TsdSeries) then
    begin
      Effect := DROPEFFECT_LINK;
      Result := True;
      exit;
    end;
end;

procedure TsdFile.CalculateCRCValue;
begin
  if not (isCRCDone in States) then
  begin
    try
      FCRC := ComputeFileCRC32(FileName);
      SetState(isCRCDone, True);
    except
      FCRC := 0;
      SetState(isCRCDone, False);
    end;
  end;
end;

procedure TsdFile.CalculateSmallCRCValue;
begin
  if FSmallCRC = 0 then
    try
      FSmallCRC := ComputeFileCRCSmall(FileName);
      if FSmallCRC = 0 then FSmallCRC := 1;
    except
      FSmallCRC := 0;
    end;
end;

function TsdFile.CompressionRatio(var Ratio: double): boolean;
var
  SqPix: cardinal;
begin
  Result := False;
  Ratio := 0;
  // Try to read them from the property
  if SquarePixels(SqPix) and (SqPix > 0) then
  begin
    Ratio := Size / SqPix;
    Result := True;
  end;
end;

procedure TsdFile.ReadComponents(S: TStream);
var
  Ver: byte;
  AModified: integer;
begin
  inherited ReadComponents(S);

  // Read Version No
  StreamReadByte(S, Ver);
  StreamReadString(S, FName);
  StreamReadInt64(S, FSize);  // modified 27dec2013
  if Ver < 12 then
  begin
    // Before version 12, filedate was stored as an integer
    // but this caused problems with daylightsaving
    StreamReadInteger(S, AModified);
    FModified := FileDateToDateTime(AModified);
  end else
    StreamReadDouble(S, double(FModified));
  StreamReadInteger(S, FSeries);
  StreamReadGuid(S, FFolderGuid);
  if Ver < 11 then
    StreamReadWord(S, FRating); // rating is in Item now
  StreamReadWord(S, FSmallCRC);
  StreamReadCardinal(S, FCRC);

  // Clear flags
  SetStates([isVerified, isNoAccess, isDeleted, isDecodeErr, isNewItem], False);

  // No icon yet
  FIcon   :=-1;

  if Ver <= 11 then
    exit; // exit for Version 11

  {Add future version code}
end;

function TsdFile.SquarePixels(var SqPix: cardinal): boolean;
var
  Dims: TprDimensions;
begin
  Result := False;
  SqPix := 0;
  // Try to read them from the property
  Dims := TprDimensions(GetProperty(prDimensions));
  if assigned(Dims) then
  begin
    SqPix := Dims.SizeX * Dims.SizeY;
    Result := True;
  end;
end;

procedure TsdFile.Verify;
begin
  SetState(isVerified, True);

  // Clear ffDeleted and ffNoAccess
  SetStates([isDeleted, isNoAccess], False);

  // Check existance again
  if not FileExists(FileName) then
  begin
    SetState(isNoAccess, True);
    if DirectoryExists(FolderName) then
    begin
      SetState(isDeleted, True);
    end else
      if not IsRemovableDrive(FolderName[1]) then
        SetState(isDeleted, True);
  end;
end;

procedure TsdFile.WriteComponents(S: TStream);
begin
  SetStates([isDeleted, isNoAccess], False);
  inherited WriteComponents(S);

  // Write Version No
  StreamWriteByte(S, 12);

  StreamWriteString(S, FName);
  StreamWriteInt64(S, FSize); // modified on 17dec2013 to use int64 inst of int32
  StreamWriteDouble(S, double(FModified));
  StreamWriteInteger(S, FSeries);
  StreamWriteGuid(S, FFolderGuid);
//  StreamWriteWord(S, FAspect);
  StreamWriteWord(S, FSmallCRC);
  StreamWriteCardinal(S, FCRC);

end;

function TsdFile.GetStatusString: string;
begin
  Result := 'Not Verified';

  // States in increasing order of importance

  if isVerified in States then
    Result := '';
  if isNewItem in States then
    Result := 'New File';
  if isNoAccess in States then
    Result := 'No Access';
  if isDeleted in States then
    Result := 'Deleted';

end;

procedure TsdFile.GetTags(AXml: TXmlNode);
var
  FS: TStream;
begin
  if not assigned(AXML) then
    exit;
  // Read the file with tags
  FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    AXML.Clear;
    // Tags? read them with Verbose = False
    sdReadMetadata(FS, 0, AXML, False);
    AXML.Name := 'Tags';
    AXML.DeleteEmptyNodes;

  finally
    FS.Free;
  end;
end;

procedure TsdFile.GetIconAndType(var AIcon: integer; var AType: string);
var
  AExt: string;
  ExtIndex: integer;
  Info: TShFileInfo;
  AExtData: TExtData;
begin
  // Icon and Type
  AIcon := FIcon;
  if AIcon >= 0 then
    AType := FFileTypeNames[AIcon];

  if AIcon < 0 then
  begin

    // We haven't got the iconindex yet
    AExt := Extension;

    if (Pos(AExt + ';', cApplicExt) = 0) AND
       FKnownExt.Find(AExt, ExtIndex) then
    begin

      // This is a known extension, so use it!
      AIcon := TExtData(FKnownExt.Objects[ExtIndex]).FIconIndex;
      AType := TExtData(FKnownExt.Objects[ExtIndex]).FTypeName;
      FIcon := AIcon;

    end else
    begin

      // We must retrieve the file extension
      if assigned(frmMain.Root) then
      begin

        // get the file info - works for non-accessible files as well
        ShellGetFileInfo(FileName, Info);
        AIcon := info.IICon;
        AType := Info.szTypeName;
        if length(AType) = 0 then
          AType := Format('%s file', [UpperCase(Copy(Extension, 2, 10))]);

        if (AICon > 0) and (AIcon <= cMaxIconsStored) then
        begin

          // use this icon and store the reference for future
          FIcon := AIcon;
          while AIcon >= FFileTypeNames.Count do
            FFileTypeNames.Add('');
          FFileTypeNames[AIcon] := AType;

          // Not an application with specific icon?
          if Pos(AExt + ';', cApplicExt) = 0 then
          begin
            // Then create a "known filetype" object for this extension
            AExtData := TExtData.Create;
            AExtData.FIconIndex := AIcon;
            AExtData.FTypeName := AType;
            FKnownExt.AddObject(AExt, AExtData);
          end;

        end;
      end;
    end;
  end;
end;

function TsdFile.Extension: string;
begin
  Result := LowerCase(ExtractFileExt(FileName));
end;

function TsdFile.FileType: string;
var
  Dummy: integer;
begin
  GetIconAndType(Dummy, Result);
end;

function TsdFile.HasBitmap: boolean;
begin
  Result := IsGraphicsFile;
end;

function TsdFile.IsGraphicsFile: boolean;
begin
  IsGraphicsFile := Pos(Extension + ';', cGraphicsExt) > 0;
end;

function TsdFile.OriginalName: string;
begin
  Result := ConvertURLCodedToFileName(StripFileNameOfCopy(Name));
end;

function TsdFile.Rename(NewName: string): string;
begin
  if NewName <> Name then
  begin
    // Turn off ShellNotify for a while
    inc(FShellNotifyRef);
    try
      // Does file already exist?
      if FileExists(FolderName + NewName) then
      begin
        MessageDlg(Format(
          'ABC-View Manager cannot rename to %s because a file'#13 +
          'with this name already exists in the current folder.', [NewName]),
          mtError, [mbOK, mbHelp], 0);
        exit;
      end;
      // Perform the file rename
      if RenameFile(FileName, FolderName + NewName) then
      begin
        Name := NewName;
        Update([ufGraphic, ufListing]);
      end else
      begin
        MessageDlg(
          'ABC-View Manager could not rename the file.',
          mtError, [mbOK, mbHelp], 0);
      end;

    // Turn on watchdog again
    finally
      // Turn on Shell Notify again
      dec(FShellNotifyRef);
    end;
    Result := Name;
  end;
end;

procedure TsdFile.RetrievePicture(ALoader: TObject);
var
  GraphResult: TsdGraphicStatus;
  Prop: TprDimensions;
  AError: string;
  L: TsdGraphicLoader;
begin
  L := TsdGraphicLoader(ALoader);

  // Check if we can access file and decode
  if States * [isDeleted, isNoAccess, isDecodeErr] <> [] then
    exit;

  // Check if the file extension is a valid type for decoding
  L.Clear;
  if IsGraphicsFile then
  begin
    try
      GraphResult := L.LoadFromFile(FileName);
      if GraphResult in [gsGraphicsOK, gsDecodeWarning] then
      begin
        // We decoded OK or with minor warning
        if L.Quality <> iqMini then
        begin

          // Set the dimensions for this file
          Prop := TprDimensions.Create;
          if assigned(Prop) then with Prop do
          begin
            SizeX := L.SourceWidth;
            SizeY := L.SourceHeight;
            PixelFormat := L.Bitmap.PixelFormat;
          end;
          AddProperty(Prop);
        end;

      end else
        SetState(isDecodeErr, True);

    except
      // File not accessible
      SetState(isNoAccess, True);
    end;
  end else
  begin
    // Special formats - outside of GraphicEx library
    GraphResult := gsDecodeError;

    // AVI video
    if FHasAVIPlugin and FUseAVIPlugin and (Pos(Extension + ';', cAviVideoExt) > 0) then
    begin
      try
        ReadAvi(Filename, L.Bitmap);
      except
      end;
    end;

    // Temporary solution for TTF
    if FHasTTFPlugin and FUseTTFPlugin and (Extension = '.ttf') then
    begin
      try
        ReadTTF(Filename, L.Bitmap);
      except
      end;

    end;

    // Temporary solution for DXF
    if FHasDXFPlugin and FUseDXFPlugin and (Extension = '.dxf') then
    begin
      try
        ReadDxf(Filename, AError, L.Bitmap);
      except
      end;
    end;

    // Temporary solution for DWG
    if FHasDWGPlugin and FUseDWGPlugin and (Extension = '.dwg') then
    begin
      try
        ReadDwg(Filename, AError, L.Bitmap);
      except
      end;
    end;

    // Temporary solution for JP2 (and some other: PNM, RAS)
    if FHasJP2Plugin and FUseJP2Plugin and
      ((Extension = '.jp2') or (Extension = '.pnm') or (Extension = '.ras')) then
    begin
      try
        ReadJP2(Filename, AError, L.Bitmap);
      except
      end;
    end;

    // Temporary solution for Svg
    if FHasSvgPlugin and FUseSvgPlugin and (Extension = '.svg') then
    begin
      try
        ReadSvg(Filename, L.Bitmap);
      except
      end;
    end;

    L.SourceWidth := L.Bitmap.Width;
    L.SourceHeight := L.Bitmap.Height;
    if HasContent(L.Bitmap) then
      GraphResult := gsGraphicsOK;
    if GraphResult = gsDecodeError then
      SetState(isDecodeErr, True);
  end;

end;

procedure TsdFile.RetrievePictureInfo(var ASizeX, ASizeY: integer; var APixelFormat: TPixelFormat);
var
  S: TStream;
  SourceW, SourceH: integer;
  GraphResult: TsdGraphicStatus;
  Loader: TsdGraphicLoader;
begin
  inherited RetrievePictureInfo(ASizeX, ASizeY, APixelFormat);

  // Check if we can access file and decode
  if States * [isDeleted, isNoAccess, isDecodeErr] <> [] then
    exit;

  // Check if the file extension is a valid type for decoding
  if not IsGraphicsFile then
    exit;

  try
    S := TFileStream.Create(Filename, fmOpenRead or fmShareDenyNone);
    try
      Loader := TsdGraphicLoader.Create;
      try
        Loader.OnlyMetadata := True;
        GraphResult := Loader.LoadFromStream(S, Extension);
        SourceW := Loader.SourceWidth;
        SourceH := Loader.SourceHeight;
      finally
        Loader.Free;
      end;
      if GraphResult in [gsGraphicsOK, gsDecodeWarning] then
      begin
        ASizeX := SourceW;
        ASizeY := SourceH;
        APixelFormat := pf24Bit; // Not correct, but we do not know
      end else
        SetState(isDecodeErr, True);
    finally
      S.Free;
    end;
  except
    // File not accessible
    SetState(isNoAccess, True);
  end;
end;

procedure TsdFile.SetSize(Value: int64);
begin
//
  FSize := Value;
end;

{ TsdGroup }


function TsdGroup.GetItemType: TItemType;
begin
  Result := itGroup;
end;

procedure TsdGroup.AcceptDrop(var Effect: integer);
begin
// to do
end;

function TsdGroup.AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean;
begin
  Result := False;
  if DropList.Contains(TsdFile) then begin
    Result := True;
    AMessage := 'Add file(s) to group';
    exit;
  end;
  if DropList.Contains(TsdFolder) then begin
    Result := True;
    AMessage := 'Add folder(s) to group';
    exit;
  end;
  if DropList.Contains(TsdSeries) then begin
    Result := True;
    AMessage := 'Add serie(s) to group';
    exit;
  end;
end;

{ TsdSeries }

function TsdSeries.GetItemType: TItemType;
begin
  Result := itSeries;
end;

procedure TsdSeries.AcceptDrop(var Effect: integer);
begin
//
end;

function TsdSeries.AllowDrop(var Effect: integer; Shift: TShiftState; var AMessage: string): boolean;
begin
  Result := False;
  if DropList.Contains(TsdFile) then
  begin
    AMessage := 'Add file(s) to series';
    Result := True;
    exit;
  end;
  if DropList.Contains(TsdSeries) then
  begin
    AMessage := 'Merge the series';
    Result := True;
    exit;
  end;
end;

end.
