{ unit Properties

  Property base class and some simple descendants

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit sdProperties;

interface

uses
  SysUtils, Classes, sdSortedLists, Graphics, sdStreamableData;

type

  TsdOptionBit = (
    obStored,     // Stored on file
    obReadOnly,   // Read-only
    obTemporary   // Temporary status
   );
  TsdOptionBits = set of TsdOptionBit;

const

  // Predefined Property IDs
  prEOF         = $0000;      // No more properties
  prDescription = $0001;      // Description
  prDimensions  = $0002;      // Dimensions (HxBxColDepth)

  // outside of this unit
  prDupeGroup   = $0003; // Duplicates group ID
  prAttachment  = $0004; // File in resampled format as attachment
  prFolderStats = $0005; // Folder statistics
  prThumbnail   = $0006; // Item's thumbnail stored on the thumbstream
  prPixRef      = $0007; // Item's pixel reference


type

  TsdProperty = class(TObject)
  private
    FGuid: TGuid;
    function GetIsReadOnly: boolean;
    function GetIsStored: boolean;
    function GetIsTemporary: boolean;
    procedure SetIsReadOnly(const Value: boolean);
    procedure SetIsStored(const Value: boolean);
    procedure SetIsTemporary(const Value: boolean);
  protected
    FOptions: TsdOptionBits;
    function GetName: string; virtual;
    function GetValue: string; virtual;
    // GetPropID MUST be overridden and it must return the property ID
    function GetPropID: word; virtual; abstract;
    procedure ReadComponents(S: TStream); virtual;
    procedure WriteComponents(S: TStream); virtual;
  public
    //constructor Create; virtual;
    procedure ReadFromStream(S: TStream); virtual;
    procedure WriteToStream(S: TStream); virtual;
    property Name: string read GetName;
    property Value: string read GetValue;
    property IsStored: boolean read GetIsStored write SetIsStored;
    property IsReadOnly: boolean read GetIsReadOnly write SetIsReadOnly;
    property IsTemporary: boolean read GetIsTemporary write SetIsTemporary;
    property PropID: word read GetPropID;
    property Options: TsdOptionBits read FOptions write FOptions;
  end;

  TsdPropertyList = class(TGuidList)
  private
    function GetItems(Index: integer): TsdProperty;
  protected
    function GetGuid(AItem: TObject): TGuid; override;
  public
    procedure ReadFromStream(S: TStream);
    procedure WriteToStream(S: TStream);
    function ByPropID(APropID: integer): TsdProperty;
    //function IndexByID(APropID: integer; var Index: integer): boolean;
    //procedure RemoveByPropID(APropID: integer);
    property Items[Index: integer]: TsdProperty read GetItems; default;
  end;

  TStoredProperty = class(TsdProperty)
  public
    constructor Create; virtual;
    procedure ReadComponents(S: TStream); override;
    procedure WriteComponents(S: TStream); override;
  end;

  // Description
  TprDescription = class(TStoredProperty)
  public
    FDescription: string;
    function GetName: string; override;
    function GetPropID: word; override;
    function GetValue: string; override;
    procedure ReadComponents(S: TStream); override;
    procedure WriteComponents(S: TStream); override;
  end;

  TprDimensions = class(TStoredProperty)
  public
    SizeX, SizeY: integer;
    PixelFormat: TPixelFormat;
    function GetName: string; override;
    function GetPropID: word; override;
    function GetValue: string; override;
    procedure ReadComponents(S: TStream); override;
    procedure WriteComponents(S: TStream); override;
  end;

// Call this function with a property ID to create a known property. This function
// is used in the catalog's LoadFromStream function to recreate saved properties.
// Always adapt this function for *stored* derived properties.
function CreateProperty(ID: word): TsdProperty;

// Remove the property APropertyID of each item in AList
procedure RemoveAllPropertiesInList(AList: TList; APropertyID: word);

const
  cColorBits: array[TPixelFormat] of string =
    ('device', '1bit','4bit','8bit','15bit','16bit','24bit','32bit','custom');

implementation

uses
  Thumbnails, Filers, PixRefs, sdItems, guiPlugins, Duplicates;

function CreateProperty(ID: word): TsdProperty;
begin
  Result := nil;
  // This routine is used for stored properties
  case ID of
  prDescription: Result := TprDescription.Create;
  prDimensions:  Result := TprDimensions.Create;
  prThumbnail:   Result := TprThumbnail.Create;
  prPixRef:      Result := TprPixRef.Create;
  prDupeGroup:   Result := TprDupeGroup.Create;
  $1000..$2000:  Result := TprPlugin.Create;
  end;// case

  // add a new guid for this created property
  if assigned(Result) then
  begin
    Result.FGuid := NewGuid;
  end;
end;

procedure RemoveAllPropertiesInList(AList: TList; APropertyID: word);
// Remove the property APropertyID of each item in AList
var
  i: integer;
begin
  if not assigned(AList) then
    exit;
  for i := 0 to AList.Count - 1 do
    if TObject(AList[i]) is TsdItem then
      TsdItem(AList[i]).RemoveProperty(APropertyID);
end;

function FlagsToOptions(AFlags: byte): TsdOptionBits;
begin
  Result := [];
  if AFlags and $01 > 0 then Include(Result, obStored);
  if AFlags and $02 > 0 then Include(Result, obReadOnly);
  if AFlags and $04 > 0 then Include(Result, obTemporary);
end;

function OptionsToFlags(Options: TsdOptionBits): byte;
begin
  Result := 0;
  if obStored    in Options then inc(Result, $01);
  if obReadOnly  in Options then inc(Result, $02);
  if obTemporary in Options then inc(Result, $04);
end;

const
  Mask: array[0..7] of byte =
  ($01, $02, $04, $08, $10, $20, $40, $80);

{ TsdProperty }

function TsdProperty.GetIsReadOnly: boolean;
begin
  Result := obReadOnly in FOptions;
end;

function TsdProperty.GetIsStored: boolean;
begin
  Result := obStored in FOptions;
end;

function TsdProperty.GetIsTemporary: boolean;
begin
  Result := obTemporary in FOptions;
end;

function TsdProperty.GetName: string;
begin
  Result := '';
end;

function TsdProperty.GetValue: string;
begin
  Result := '';
end;

procedure TsdProperty.ReadComponents(S: TStream);
begin
// default does nothing
end;

procedure TsdProperty.ReadFromStream(S: TStream);
var
  Len: integer;
  M: TStream;
begin
  // Read ourselves from stream
  StreamReadInteger(S, Len);
  M := TMemoryStream.Create;
  try
    M.CopyFrom(S, Len);
    M.Seek(0, soFromBeginning);
    ReadComponents(M);
  finally
    M.Free;
  end;
end;

procedure TsdProperty.SetIsReadOnly(const Value: boolean);
begin
  if Value then
    Include(FOptions, obReadOnly) else Exclude(FOptions, obReadOnly);
end;

procedure TsdProperty.SetIsStored(const Value: boolean);
begin
  if Value then
    Include(FOptions, obStored) else Exclude(FOptions, obStored);
end;

procedure TsdProperty.SetIsTemporary(const Value: boolean);
begin
  if Value then
    Include(FOptions, obTemporary) else Exclude(FOptions, obTemporary);
end;

procedure TsdProperty.WriteComponents(S: TStream);
begin
// default does nothing
end;

procedure TsdProperty.WriteToStream(S: TStream);
var
  Len: integer;
  M: TStream;
begin
  // Write ourselves to stream
  M := TMemoryStream.Create;
  try
    WriteComponents(M);
    Len := M.Position;
    M.Seek(0, soFromBeginning);
    StreamWriteInteger(S, Len);
    S.CopyFrom(M, Len);
  finally
    M.Free;
  end;
end;

{ TsdPropertyList }

function TsdPropertyList.ByPropID(APropID: integer): TsdProperty;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if Items[i].PropID = APropID then
      Result := Items[i];
  end;
end;

function TsdPropertyList.GetGuid(AItem: TObject): TGuid;
begin
  // verify if the guid is not empty
  if IsEmptyGuid(TsdProperty(AItem).FGuid) then
  begin
    TsdProperty(AItem).FGuid := NewGuid;
  end;
  Result := TsdProperty(AItem).FGuid;
end;

function TsdPropertyList.GetItems(Index: integer): TsdProperty;
begin
  Result := Get(Index);
end;

procedure TsdPropertyList.ReadFromStream(S: TStream);
var
  Len: integer;
  PropID: word;
  Prop: TsdProperty;
begin
  StreamReadWord(S, PropID);
  while PropID <> prEOF do
  begin

    // Try to create the property
    Prop := CreateProperty(PropID);
    if assigned(Prop) then
    begin

      // Known type, add + read it
      Add(Prop);
      Prop.ReadFromStream(S);

    end else
    begin

      // This is an unknown type, so skip it.
      StreamReadInteger(S, Len);
      S.Seek(Len, soFromCurrent);

    end;
    // Next PropID
    StreamReadWord(S, PropID);
  end;
end;

procedure TsdPropertyList.WriteToStream(S: TStream);
var
  i: integer;
  Prop: TsdProperty;
begin
  for i := 0 to Count - 1 do
  begin
    Prop := Items[i];
    if Prop.IsStored then
    begin
      StreamWriteWord(S, Prop.PropID);
      Prop.WriteToStream(S);
    end;
  end;
  // Write the termination code
  StreamWriteWord(S, prEOF);
end;

{ TStoredProperty }

constructor TStoredProperty.Create;
begin
  inherited Create;
  FOptions := [obStored];
end;

procedure TStoredProperty.ReadComponents(S: TStream);
var
  Flags: byte;
begin
  // We read the options
  StreamReadByte(S, Flags);
  FOptions := FlagsToOptions(Flags);
end;
procedure TStoredProperty.WriteComponents(S: TStream);
var
  Flags: byte;
begin
  // We store the options
  Flags := OptionsToFlags(FOptions);
  StreamWriteByte(S, Flags);
end;

{ TprDescription }

function TprDescription.GetName: string;
begin
  Result := 'Description';
end;

function TprDescription.GetPropID: word;
begin
  Result := prDescription;
end;

function TprDescription.GetValue: string;
begin
  Result := FDescription;
end;

procedure TprDescription.ReadComponents(S: TStream);
var
  Ver: byte;
begin
  inherited;
  // Read Version No
  StreamReadByte(S, Ver);
  StreamReadString(S, FDescription);
  if Ver <= 10 then exit; // exit for Version 10
  // Add future version code here
end;

procedure TprDescription.WriteComponents(S: TStream);
begin
  inherited;
  // Write Version No
  StreamWriteByte(S, 10);
  StreamWriteString(S, FDescription);
end;

{ TprDimensions }

function TprDimensions.GetName: string;
begin
  Result:='Dimensions';
end;

function TprDimensions.GetPropID: word;
begin
  Result := prDimensions;
end;

function TprDimensions.GetValue: string;
begin
  Result:=Format('%d x %d (%s)',[SizeX, SizeY, cColorBits[PixelFormat]]);
end;

procedure TprDimensions.ReadComponents(S: TStream);
var
  Ver: byte;
begin
  inherited;
  // Read Version No
  StreamReadByte(S, Ver);
  StreamReadInteger(S, SizeX);
  StreamReadInteger(S, SizeY);
  S.Read(PixelFormat, SizeOf(PixelFormat));
  if Ver <= 10 then exit; // exit for Version 10
  // Add future version code here
end;

procedure TprDimensions.WriteComponents(S: TStream);
begin
  inherited;
  // Write Version No
  StreamWriteByte(S, 10);
  StreamWriteInteger(S, SizeX);
  StreamWriteInteger(S, SizeY);
  S.Write(PixelFormat, SizeOf(PixelFormat));
end;

end.
