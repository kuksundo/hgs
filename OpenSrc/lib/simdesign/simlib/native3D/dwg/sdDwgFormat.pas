{ sdDwgFormat

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdDwgFormat;

interface

uses
  Windows, Classes, SysUtils, Contnrs, sdDwgTypesAndConsts, sdDwgBitReader,
  sdDwgHeaderVars;

type

  TDwgFormat = class;
  TDwgItem = class;

  TDwgStringEvent = procedure (Sender: TObject; const AMessage: string) of object;

  TDwgAcadVersion = (
    avUnknown,
    avAcadR13,
    avAcadR14,
    avAcad2000
  );

  // Base property class of properties belonging to a TDxfObject
  TDwgProperty = class(TPersistent)
  private
    FGroupId: integer;
  protected
    function GetAsFloat: double; virtual;
    procedure SetAsFloat(const Value: double); virtual;
    function GetAsInteger: integer; virtual;
    procedure SetAsInteger(const Value: integer); virtual;
    function GetAsHandle: TDwgHandle; virtual;
    procedure SetAsHandle(const Value: TDwgHandle); virtual;
    // Load the property from bit reader R, using Method. If this fails, return False
    function Load(R: TDwgBitReader; Method: TDwgStorageMethod): boolean; virtual;
  public
    constructor Create(AGroupId: integer); virtual;
    property GroupId: integer read FGroupId write FGroupId;
    property AsFloat: double read GetAsFloat write SetAsFloat;
    property AsInteger: integer read GetAsInteger write SetAsInteger;
    property AsHandle: TDwgHandle read GetAsHandle write SetAsHandle;
  end;
  TDwgPropertyClass = class of TDwgProperty;

  TDwgPropertyList = class(TObjectList)
  private
    function GetItems(Index: integer): TDwgProperty;
  public
    property Items[Index: integer]: TDwgProperty read GetItems; default;
    function ByGroupId(AGroupId: integer): TDwgProperty;
  end;

  // Base class for all items that are in a drawing
  TDwgItem = class(TPersistent)
  private
    FOwner: TDwgFormat;
    FProperties: TDwgPropertyList;
    function GetHandle: TDwgHandle;
    function GetItemType: integer;
    procedure SetHandle(const Value: TDwgHandle);
    procedure SetItemType(const Value: integer);
  protected
    function ItemFamily: TDwgItemFamily; virtual;
    function ItemTypeName: string; virtual;
    function PropByGroupId(AGroupId: integer; CreateIfNotExist: boolean = False): TDwgProperty;
    function PropAdd(AGroupId: integer): TDwgProperty;
    procedure DoStatus(const AMessage: string);
    procedure DoError(const AMessage: string);
    procedure Load(R: TDwgBitReader; ABitPosition: integer); virtual;
    procedure LoadExtendedEntityData(R: TDwgBitReader; ASize: integer);
    procedure LoadItemData(R: TDwgBitReader); virtual;
    procedure LoadHandleData(R: TDwgBitReader); virtual;
    procedure LoadProp(R: TDwgBitReader; AGroupId: integer; AStorage: TDwgStorageMethod); virtual;
  public
    constructor Create(AOwner: TDwgFormat); virtual;
    destructor Destroy; override;
    property ItemType: integer read GetItemType write SetItemType;
    property Handle: TDwgHandle read GetHandle write SetHandle;
  end;

  TDwgItemClass = class of TDwgItem;

  // List of items in the drawing
  TDwgItemList = class(TObjectList)
  private
    function GetItems(Index: integer): TDwgItem;
  public
    property Items[Index: integer]: TDwgItem read GetItems;
  end;

  // TDwgFormat implements reading of Autocad DWG files
  TDwgFormat = class(TComponent)
  private
    FAcadVersion: TDwgAcadVersion;
    FItems: TDwgItemList;
    FIsC3: boolean;
    FStream: TMemoryStream;
    FHeader: TDwgHeader;
    FHeaderVars: TDwgHeaderVars;
    FSectionLocators: array of TDwgSectionLocator;
    FClassDefs: array of TDwgClassDef;
    FHandleRefs: array of TDwgHandleRef;
    FHandleRefCount: integer;
    FOnError: TDwgStringEvent;
    FOnStatus: TDwgStringEvent;
  protected
    function CalcCRC(FromPos, ToPos: integer; Seed: word): word;
    // Creates a new item of type AType, and adds it to the list
    function CreateItemByType(AType: integer): TDwgItem;
    procedure DoError(const AMessage: string);
    procedure DoStatus(const AMessage: string);
    procedure ReadHeaderVariables(R: TDwgBitReader);
    procedure ReadClassSection(R: TDwgBitReader);
    procedure ReadFromStream;
    procedure ReadItemMap(R: TDwgBitReader);
    procedure ReadItems(R: TDwgBitReader);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromStream(S: TStream);
    property Items: TDwgItemList read FItems;
    property OnError: TDwgStringEvent read FOnError write FOnError;
    property OnStatus: TDwgStringEvent read FOnStatus write FOnStatus;
    property AcadVersion: TDwgAcadVersion read FAcadVersion;
  end;

resourcestring

  // errors that are passed through OnError (non-critical) or raised as
  // exception (critical)
  sHeaderSentinelMismatch       = 'Header Sentinel Mismatch';
  sClassSectionSentinelMismatch = 'ClassSection Sentinel Mismatch';
  sHeaderVarSentinelMismatch    = 'HeaderVar Sentinel Mismatch';
  sHeaderCRCMismatch            = 'Header CRC Mismatch';
  sInvalidAcadHeader            = 'Invalid ACAD header';
  sObjectMapSectionError        = 'Object map section error';
  sObjectHandlesDoNotMatch      = 'Object handles do not match';
  sUnableToLoadPropertyGroup    = 'Unable to load property with groupid %d';
  sUnableToFindPropertyGroup    = 'Unable to find property with groupid %d';
  sObjectCRCMismatch            = 'Object CRC mismatch';
  sObjectMapCRCMismatch         = 'Object map CRC mismatch';
  sClassSectionCRCMismatch      = 'Class section CRC mismatch';
  sHeaderVarsCRCMismatch        = 'Header vars CRC Mismatch';
  sHeaderSizeMismatch           = 'Header size mismatch';

implementation

uses
  sdDwgItems, sdDwgProperties;

{ TDwgProperty }

constructor TDwgProperty.Create(AGroupId: integer);
begin
  inherited Create;
  FGroupId := AGroupId;
end;

function TDwgProperty.GetAsFloat: double;
begin
  Result := 0;
end;

function TDwgProperty.GetAsHandle: TDwgHandle;
begin
  Result.Code := 0;
  Result.Handle := 0;
end;

function TDwgProperty.GetAsInteger: integer;
begin
  Result := 0;
end;

function TDwgProperty.Load(R: TDwgBitReader; Method: TDwgStorageMethod): boolean;
begin
  Result := False;
end;

procedure TDwgProperty.SetAsFloat(const Value: double);
begin
// default does nothing
end;

procedure TDwgProperty.SetAsHandle(const Value: TDwgHandle);
begin
// default does nothing
end;

procedure TDwgProperty.SetAsInteger(const Value: integer);
begin
// default does nothing
end;

{ TDwgPropertyList }

function TDwgPropertyList.ByGroupId(AGroupId: integer): TDwgProperty;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].GroupId = AGroupId then begin
      Result := Items[i];
      exit;
    end;
end;

function TDwgPropertyList.GetItems(Index: integer): TDwgProperty;
begin
  Result := Get(Index);
end;

{ TDwgItem }

constructor TDwgItem.Create(AOwner: TDwgFormat);
begin
  inherited Create;
  FOwner := AOwner;
  FProperties := TDwgPropertyList.Create;
end;

destructor TDwgItem.Destroy;
begin
  FreeAndNil(FProperties);
  inherited;
end;

procedure TDwgItem.DoError(const AMessage: string);
begin
  FOwner.DoError(AMessage);
end;

procedure TDwgItem.DoStatus(const AMessage: string);
begin
  FOwner.DoStatus(AMessage);
end;

function TDwgItem.GetHandle: TDwgHandle;
var
  AProp: TDwgProperty;
begin
  AProp := PropByGroupId(cPropHandle);
  if assigned(AProp) then
    Result := AProp.AsHandle
  else begin
    Result.Code := 0;
    Result.Handle := 0;
  end;
end;

function TDwgItem.GetItemType: integer;
var
  AProp: TDwgProperty;
begin
  AProp := PropByGroupId(cPropType);
  if assigned(AProp) then
    Result := AProp.AsInteger
  else
    Result := 0;
end;

function TDwgItem.ItemFamily: TDwgItemFamily;
begin
  Result := ifUnknown;
end;

function TDwgItem.ItemTypeName: string;
begin
  if ItemType < 74 then
    Result := cDwgEntityNames[ItemType]
  else
    Result := '"special"';
end;

procedure TDwgItem.Load(R: TDwgBitReader; ABitPosition: integer);
// Unfortunately badly documented in docs
var
  ODSizeInBits: integer; // Size of object data in bits
  EEDSize: integer;
  GraphicPresentFlag: boolean;
begin
  ODSizeInBits := 0;
  // Common object data (for all objects)
  if R.IsR2000 then
    ODSizeInBits := R.RL;

  try

    LoadProp(R, cPropHandle, smH);
    EEDSize := R.BS;
    if EEDSize <> 0 then begin
      //DoStatus(Format('Extended entity data found in %s %.6x', [ItemTypeName, Handle.Handle]));
      LoadExtendedEntityData(R, EEDSize);
    end;

    case ItemFamily of
    ifUnknown:
      begin
        DoStatus(Format('Unknown item family in %.6x (type %.2x)', [Handle.Handle, ItemType]));
        exit;
      end;
    ifEntity:
      begin
        GraphicPresentFlag := R.Bit;
        if GraphicPresentFlag then begin
          // Proxy entity graphics - to do
          DoStatus(Format('Proxy entity graphics found in %.6x', [Handle.Handle]));
          exit;//R.Skip(R.RL); // skip
        end;
      end;
    end;

    if R.IsR1314 then
      ODSizeInBits := R.RL;

    // Load the item data
    LoadItemData(R);

  finally

    if ODSizeInBits > 0 then begin
      // Go to handle data
{      if R.BitPosition < ABitPosition + ODSizeInBits then
        DoStatus('contains unloaded item data');}
      R.BitPosition := ABitPosition + ODSizeInBits;

      // Item handle data
      LoadHandleData(R);
    end;

  end;

end;

procedure TDwgItem.LoadExtendedEntityData(R: TDwgBitReader; ASize: integer);
// These are the extended entity codes 1000 - 1071
var
  i: integer;
  AppHandle: TDwgHandle;
  //ItemCode: byte;
  ItemData: string;
begin
  // To do, for now we just read them and do nothing with it
  while ASize > 0 do
  begin
    AppHandle := R.H;
    R.RC;
    SetLength(ItemData, ASize - 1);
    for i := 1 to ASize - 1 do
      ItemData[i] := char(R.RC);
    ASize := R.BS;
  end;
end;

procedure TDwgItem.LoadHandleData(R: TDwgBitReader);
//var
  //AHandle: TDwgHandle;
begin
  // AHandle := R.H; // test
  // default does nothing
end;

procedure TDwgItem.LoadItemData(R: TDwgBitReader);
begin
// default does nothing
end;

procedure TDwgItem.LoadProp(R: TDwgBitReader; AGroupId: integer; AStorage: TDwgStorageMethod);
var
  i: integer;
  AProp: TDwgProperty;
begin
  // Lookup property class by group id
  for i := 0 to cPropertyGroupCount - 1 do
    if cPropertyGroups[i].GroupId = AGroupId then begin
      // Create the property
      AProp := cPropertyGroups[i].ClassType.Create(AGroupId);
      // Load the property
      if AProp.Load(R, AStorage) then begin
        // Load succeeded, add the property - we own it
        FProperties.Add(AProp);
      end else begin
        // Load failed..
        AProp.Free;
        raise Exception.CreateFmt(sUnableToLoadPropertyGroup, [AGroupId]);
      end;
      exit;
    end;
  // Arriving here means we didn't find the property
  raise Exception.CreateFmt(sUnableToFindPropertyGroup, [AGroupId]);
end;

function TDwgItem.PropAdd(AGroupId: integer): TDwgProperty;
var
  i: integer;
begin
  // Lookup property class by group id
  for i := 0 to cPropertyGroupCount - 1 do
    if cPropertyGroups[i].GroupId = AGroupId then begin
      // Create the property
      Result := cPropertyGroups[i].ClassType.Create(AGroupId);
      FProperties.Add(Result);
      exit;
    end;

  // Arriving here means we didn't find the property
  raise Exception.CreateFmt(sUnableToFindPropertyGroup, [AGroupId]);
end;

function TDwgItem.PropByGroupId(AGroupId: integer; CreateIfNotExist: boolean): TDwgProperty;
begin
  Result := FProperties.ByGroupId(AGroupId);
  if not assigned(Result) and CreateIfNotExist then
    Result := PropAdd(AGroupId);
end;

procedure TDwgItem.SetHandle(const Value: TDwgHandle);
var
  AProp: TDwgProperty;
begin
  AProp := PropByGroupId(cPropHandle, True);
  AProp.AsHandle := Value;
end;

procedure TDwgItem.SetItemType(const Value: integer);
var
  AProp: TDwgProperty;
begin
  AProp := PropByGroupId(cPropType, True);
  AProp.AsInteger := Value;
end;

{ TDwgItemList }

function TDwgItemList.GetItems(Index: integer): TDwgItem;
begin
  Result := Get(Index);
end;

{ TDwgFormat }

function TDwgFormat.CalcCRC(FromPos, ToPos: integer; Seed: word): word;
var
  Count: integer;
  Idx: byte;
  P: Pbyte;
begin
  P := FStream.Memory;
  inc(P, FromPos);
  Count := ToPos - FromPos;
  Result := Seed;
  while Count > 0 do begin
    Idx := P^ XOR (Result AND $FF);
    Result := Result shr 8;
    Result := Result XOR DwgCrcTable[Idx];
    inc(P);
    dec(Count);
  end;
end;

procedure TDwgFormat.Clear;
begin
  FAcadVersion := avUnknown;
  FItems.Clear;
  FStream.Clear;
  FillChar(FHeader, SizeOf(FHeader), 0);
  SetLength(FSectionLocators, 0);
  SetLength(FClassDefs, 0);
  SetLength(FHandleRefs, 0);
  FHandleRefCount := 0;
end;

constructor TDwgFormat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TDwgItemList.Create;
  FStream := TMemoryStream.Create;
end;

function TDwgFormat.CreateItemByType(AType: integer): TDwgItem;
var
  AClass: TDwgItemClass;
begin
  // Create appropriate class
  AClass := DwgItemClassFor(AType);
  if assigned(AClass) then begin
    Result := AClass.Create(Self);
  end else begin
    // To do: find "dynamic" classes (AType >= 500) from classlist
    Result := TDwgItem.Create(Self);
  end;
  Result.ItemType := AType;
  FItems.Add(Result);
end;

destructor TDwgFormat.Destroy;
begin
  FreeAndNil(FStream);
  FreeAndNil(FItems);
  inherited;
end;

procedure TDwgFormat.DoError(const AMessage: string);
begin
  if assigned(FOnError) then FOnError(Self, AMessage);
end;

procedure TDwgFormat.DoStatus(const AMessage: string);
begin
  if assigned(FOnStatus) then FOnStatus(Self, AMessage);
end;

procedure TDwgFormat.LoadFromFile(const AFileName: string);
var
  F: TFileStream;
begin
  F := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(F);
  finally
    F.Free;
  end;
end;

procedure TDwgFormat.LoadFromStream(S: TStream);
begin
  Clear;
  FStream.Size := S.Size;
  FStream.Position := 0;
  FStream.CopyFrom(S, S.Size);
  ReadFromStream;
end;

procedure TDwgFormat.ReadClassSection(R: TDwgBitReader);
var
  //ClosePos: DwgLong;
  ADef: PDwgClassDef;
  ASentinel: DwgSentinel;
  StreamPosition, Start, Size: integer;
  CRCFile, CRCCalc: word;
begin
  StreamPosition := FSectionLocators[1].Seeker;
  R.SetMemory(StreamPosition);
  if R.Sentinel <> cClassStartSentinel then
    DoError(sClassSectionSentinelMismatch);
  Size := R.RL;
  Start := R.BytePosition;
  while R.BytePosition < Start + Size do begin
    // Add new class definition
    SetLength(FClassDefs, length(FClassDefs) + 1);
    ADef := @FClassDefs[length(FClassDefs) - 1];
    // Read it
    ADef.ClassNum     := R.BS;
    ADef.Version      := R.BS;
    ADef.AppName      := R.Text;
    ADef.CppClassName := R.Text;
    ADef.DxfClassName := R.Text;
    ADef.WasaProxy    := R.Bit;
    ADef.ItemClassId  := R.BS;
{    DoStatus(Format('class: classnum %d; Version %d ItemClassId %d ClassName %s',
      [ADef.ClassNum, ADef.Version, ADef.ItemClassId, ADef.CppClassName]));}
  end;
  R.Flush;
  CRCFile := R.RS; // Read CRC
  CRCCalc := CalcCRC(StreamPosition + Start - 4, StreamPosition + Start + Size, $C0C1);
  if CRCFile <> CRCCalc then
    DoError(sClassSectionCRCMismatch);


  // Read sentinel
  ASentinel := r.Sentinel;
  if ASentinel <>  cClassCloseSentinel then
    DoError(sClassSectionSentinelMismatch);
end;

procedure TDwgFormat.ReadFromStream;
var
  i: integer;
  CRCFile, CRCcalc: word;
  Sentinel: DwgSentinel;
  R: TDwgBitReader;
begin
  // Read header
  FStream.Position := 0;
  FStream.Read(FHeader, SizeOf(FHeader));

  // Format detection
  if FHeader.AcadVer = 'AC1012' then FAcadVersion := avAcadR13;
  if FHeader.AcadVer = 'AC1014' then FAcadVersion := avAcadR14;
  if FHeader.AcadVer = 'AC1015' then FAcadVersion := avAcad2000;
  FIsC3 := FHeader.RecCount >= 4;
  if not (FAcadVersion in [avAcadR13, avAcadR14, avAcad2000]) or (FHeader.RecCount > 6) then
    raise Exception.Create(sInvalidAcadHeader);

  // Read section locators
  SetLength(FSectionLocators, FHeader.RecCount);
  for i := 0 to length(FSectionLocators) - 1 do
    FStream.Read(FSectionLocators[i], SizeOf(TDwgSectionLocator));

  // Read and check CRC
  CRCCalc := CalcCRC(0, FStream.Position, 0);
  FStream.Read(CRCFile, SizeOf(CRCFile));
  case FHeader.RecCount of
  3: CRCCalc := CRCCalc XOR $A598;
  4: CRCCalc := CRCCalc XOR $8101;
  5: CRCCalc := CRCCalc XOR $3CC4;
  6: CRCCalc := CRCCalc XOR $8461;
  end;//case
  if CRCFile <> CRCCalc then
    DoError(sHeaderCRCMismatch);

  // Read and check Sentinel
  FStream.Read(Sentinel, SizeOf(Sentinel));
  if Sentinel <> cHeaderSentinel then
    DoError(sHeaderSentinelMismatch);

  // Setup bit reader
  R := TDwgBitReader.Create(FStream, Self);
  try
    // Read header variables
    ReadHeaderVariables(R);
    // Read class section
    ReadClassSection(R);
    // Read object map
    ReadItemMap(R);
    // Read individual items
    ReadItems(R);
  finally
    R.Free;
  end;
end;

procedure TDwgFormat.ReadHeaderVariables(R: TDwgBitReader);
var
  StreamPosition, Start: integer;
  Size: DwgLong;
  CRCFile, CRCCalc: word;
  ASentinel: DwgSentinel;
begin
  StreamPosition := FSectionLocators[0].Seeker;
  R.SetMemory(StreamPosition);
  if R.Sentinel <> cHeaderStartSentinel then
    DoError(sHeaderVarSentinelMismatch);
  Start := R.BytePosition;
  Size := R.RL;

  // Read header variables (see unit sdDwgHeaderVars)
  ReadHeaderVars(R, FHeaderVars);

  // Check if header reader didn't read too much
  if R.BytePosition > Start + Size then
    DoError(sHeaderSizeMismatch);

  // Position for CRC
  R.BytePosition := Start + Size + 4;
  // Read CRC and compare
  CRCFile := R.RS;
  CRCCalc := CalcCRC(StreamPosition + Start, StreamPosition + Start + Size + 4, $C0C1);
  if CRCFile <> CRCCalc then
      DoError(sHeaderVarsCRCMismatch);

  // Read closing sentinel
  ASentinel := R.Sentinel;
  if ASentinel <> cHeaderCloseSentinel then
    DoError(sHeaderVarSentinelMismatch);
end;

procedure TDwgFormat.ReadItemMap(R: TDwgBitReader);
var
  Start: integer;
  Size: word;
  ARef: PDwgHandleRef;
  HandleValue, FilePosition: integer;
  CRCFile, CRCCalc: word;
  StreamPosition: integer;
  // Local
  function NewHandleRef: PDwgHandleRef;
  begin
    if length(FHandleRefs) <= FHandleRefCount then
      SetLength(FHandleRefs, length(FHandleRefs) * 3 div 2 + 100);
    Result := @FHandleRefs[FHandleRefCount];
    inc(FHandleRefCount);
  end;
// Main
begin
  StreamPosition := FSectionLocators[2].Seeker;
  R.SetMemory(StreamPosition);

  // Read sections
  repeat
    HandleValue := 0;
    FilePosition := 0;
    Start := R.BytePosition;
    Size := swap(R.RS); // Size as BIG endian format
    if Size <= 2 then break;
    if Size > 2048 then
    begin
      DoError(sObjectMapSectionError);
      exit;
    end;

    // Read handles in sections
    repeat
      // Read handle value, always positive (modular unsigned char!).. was not in docs
      inc(HandleValue, R.MuC);
      // Read file position, can be negative, so modular char
      inc(FilePosition, R.MC);
      // Create the handle reference
      ARef := NewHandleRef;
      ARef.Value := HandleValue;
      ARef.Position := FilePosition;
    until R.BytePosition >= Start + Size;

    // CRC of section
    R.Flush;
    CRCFile := swap(R.RS); // CRC as BIG endian format
    // We found the seed through reverse engineering
    CRCCalc := CalcCRC(StreamPosition + Start, StreamPosition + Start + Size, $C0C1);
    if CRCFile <> CRCCalc then
      DoError(sObjectMapCRCMismatch);

  until False;
end;

procedure TDwgFormat.ReadItems(R: TDwgBitReader);
var
  i: integer;
  ARef: PDwgHandleRef;
  Size, AType: integer;
  AItem: TDwgItem;
  CRCFile, CRCCalc: word;
  BitPosition: integer;
begin
  // Use the list of handles to read the objects
  for i := 0 to FHandleRefCount - 1 do begin
    // The handle reference
    ARef := @FHandleRefs[i];
    // Set to the position in the file
    R.SetMemory(ARef.Position);
    // Read size of object, including the size byte(s)
    Size := R.MS;
    BitPosition := R.BitPosition;
    AType := R.BS;
    try
      // Create a new object by type, and load it
      try
        AItem := CreateItemByType(AType);
        AItem.Load(R, BitPosition);
        if integer(AItem.Handle.Handle) <> ARef.Value then
          raise Exception.Create(sObjectHandlesDoNotMatch);
{        DoStatus(Format('object %.5d loaded: type %.2x; handle %.6x size %d pos %d pos + size %d',
          [i, AItem.ItemType, AItem.Handle.Handle, Size, ARef.Position, Size + ARef.Position]));}
      finally
        // There seem to be 2 additionaly bytes after the record, which we skip
        R.BytePosition := Size + 2;
        // Check CRC
        CRCFile := R.RS;
        // Through reverse-engineering found seed $C0C1
        CRCCalc := CalcCRC(ARef.Position, ARef.Position + Size + 2, $C0C1);
        if CRCFile <> CRCCalc then
          DoError(sObjectCRCMismatch);
      end;
    except
      // Something went wrong with loading the object, inform app
      on E: Exception do begin
        DoError(Format('object %d (type %d) with handle %.6x load error: %s',
          [i, AType, ARef.Value, E.Message]));
      end;
    end;
  end;
end;

end.
