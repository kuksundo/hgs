{ Project: Pyro
  Module: Pyro Core

  Description:
  Core document class. The TpgElement class is the base class for
  all element types. TpgDocument holds a list of elements, and is the base
  class for scenes.

  Author: Nils Haeck (n.haeck@simdesign.nl)<p>
  Copyright (c) 2006 - 2011 SimDesign BV

  Modified:
  19may2011: string > Utf8String
  20jun2011: pgDocument/pgElement/pgProp based on NativeXml
  26jan2015: reverted that and based on RelaxXml's TXmlNode
  27jan2015: reverted again and based on NativeXml
}
unit pgDocument;

{$i simdesign.inc}

interface

uses
  // delphi
  Classes, Contnrs, SysUtils,

  // simdesign
  sdSortedLists,
  NativeXml,
  sdDebug,

  // pyro
  pgStorage,
  pgParser,
  pgPlatform,
  Pyro;

type

  // fwd declarations
  TpgItem = class;
  TpgDocument = class;
  TpgStyle = class;
  TpgPropInfo = class;

  // Basic property class, all properties descend from TpgProp.
  TpgProp = class(TsdAttribute)  
  protected
    FID: longword;
    // Decode the prop data to the Utf8String TsdAttribute.Value.
    // Result = True if successful
    function Decode: boolean; virtual; abstract;
    // Encode the prop data from the Utf8String TsdAttribute.Value.
    // Result = True if successful
    function Encode: boolean; virtual; abstract;

    // AsString getter and setter
    function GetAsString: Utf8String;
    procedure SetAsString(const S: Utf8String);
    procedure DoBeforeChange(AParent: TpgItem);
    procedure DoAfterChange(AParent: TpgItem);
//todo    function GetParent: TpgItem;
//    function GetDocument: TpgDocument;
    // Override this method to copy all data of the property from AProp
    procedure CopyFrom(ANode: TObject); virtual;
  public
    constructor CreateID(AOwner: TpgDocument; AID: longword);
    property AsString: Utf8String read GetAsString write SetAsString;
    property ID: longword read FID;
//todo    property Parent: TpgItem read GetParent;
//    property Document: TpgDocument read GetDocument;
  end;

  TpgPropClass = class of TpgProp;

  TpgPropAccess = record
    ID: longword;
    Info: TpgPropInfo;
    Reader: TpgItem;
    Creator: TpgItem;
  end;

  // Basic item type which supports a list of properties, and inheritance
  // of properties through the parent.
  TpgItem = class(TsdElement)
  private
    procedure DoBeforeChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType);
    procedure DoAfterChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType);
    function GetDocument: TpgDocument;
//todo    function GetParent: TpgItem;
    function GetID: Utf8String;

  protected
    FFlags: TpgItemFlags;
    constructor Create(AOwner: TNativeXml); override;
    function LocalPropByID(AID: longword): TpgProp;
    procedure SetID(const AID: Utf8String);
    procedure SetDocument(ADocument: TpgDocument);
//todo    procedure SetParent(AParent: TpgItem);
    // Copy all information except the ID from AElement.
    procedure CopyFrom(ANode: TXmlNode); override;
    // Check for location of a property with AId in own LocalProps list, references
    // (clones and styles), parent and eventually defaults of the container.
    function CheckPropLocations(var APropAccess: TpgPropAccess): TpgProp;
    // Check for referenced properties and return AOwner of the property if any. By
    // default this method does nothing, but in the TpgStyleable it returns properties
    // from clones and styles.
    function CheckReferenceProps(var APropAccess: TpgPropAccess): TpgProp; virtual;
    // Check if this element allows a property with info AInfo.
    function CheckPropClass(PropInfo: TpgPropInfo): boolean; virtual;
    procedure DoItemAdd(AItem: TpgItem); virtual;
    procedure DoItemRemove(AItem: TpgItem); virtual;
    // DoBeforePropChange/DoAfterPropChange get called from the property whenever
    // it changes/gets added
    procedure DoBeforePropChange(APropID: longword; AChange: TpgChangeType); virtual;
    procedure DoAfterPropChange(APropID: longword; AChange: TpgChangeType); virtual;
    // DoAfterCreate is called after the element is created, and can be used to add
    // default props or subelements
    procedure DoAfterCreate; virtual;
    // DoBeforeSave is called before the element is saved to storage and can be
    // used to do any specific processing. The default does nothing
    procedure DoBeforeSave; virtual;
    // DoAfterLoad is called after the element is loaded from storage, and can
    // be used to do any specific processing based on the loaded prop or subelement
    // information
    procedure DoAfterLoad; virtual;
    //
    function GetItemCount: integer; virtual;
    //
    function GetItems(Index: integer): TpgItem; virtual;
    // create a new prop based on APropAccess.ID and other info
    function NewProp(APropAccess: TpgPropAccess): TpgProp;
  public
    // TODO: backward compat (must be removed)
    constructor CreateCopyFrom(AItem: TpgItem; AParent: TpgItem);
    // Create a new element with Parent = AParent. It will automatically be
    // added to the container in which AParent also resides.
    //constructor CreateParent(AOwner: TpgDocument; AParent: TpgElement); override;
    //destructor Destroy; override;
    // Returns a property with AID or nil if none found, also checks for inheritance
    // as well as clones and styles. Do not override this method!
    function PropByID(AID: longword): TpgProp;
    // check if the property exists locally
    function ExistsLocal(AProp: TpgProp): boolean;
    // Clear all properties in this element
    procedure Clear;
    // Some stringbased ID of this element within the container it is owned by.
    property ID: Utf8String read GetID write SetID;
    // Reference to document that owns this element.
    property Document: TpgDocument read GetDocument;
    // Reference to the parent of this element.
//todo    property Parent: TpgItem read GetParent{ write SetParent};
    // Set of flags for element
    property Flags: TpgItemFlags read FFlags write FFlags;
    // Returns the number of sub elements in this element
    property ItemCount: integer read GetItemCount;
    // Returns the sub element at Index in the sub element list. Warning: this
    // will raise an exception if the element doesn't allow storage of sub-elements
    property Items[Index: integer]: TpgItem read GetItems;
  end;

  TpgItemClass = class of TpgItem;

  // TpgDocument
  TpgDocument = class(TNativeXml)
  private
    FDocumentID: longword;
  protected
    FUpdateCount: integer;
    procedure NodeBeforeSave(Sender: TObject; ANode: TXmlNode);
    procedure DoBeforeChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType); virtual;
    procedure DoAfterChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType); virtual;
  public
    FParser: TpgParser;
    FWriter: TpgWriter;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
//todo    procedure SaveToStream(Stream: TStream); override;
    function ExistsItem(AItem: TpgItem): boolean;
//todo    function FindItem(AItemClass: TpgItemClass; AList: TsdNodeList; AIndex: integer = 0): TpgItem;
//todo    function NewItem(AItemClass: TpgItemClass; AParent: TpgItem): TpgItem;
    function ItemByID(const AID: Utf8String): TpgItem;
    property DocumentID: longword read FDocumentID;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
  end;

  TpgPropInfo = class(TPersistent)
  private
    FID: longword;
    FMinItemClass: TpgItemClass;
    FFlags: TpgPropInfoFlags;
    FName: Utf8String;
    FDefaultValue: Utf8String;
    FPropClass: TpgPropClass;
  public
    function NewProp(AOwner: TpgDocument): TpgProp;
    property Id: longword read FId;
    property PropClass: TpgPropClass read FPropClass;
    property Name: Utf8String read FName;
    property MinItemClass: TpgItemClass read FMinItemClass;
    property Flags: TpgPropInfoFlags read FFlags;
    property DefaultValue: Utf8String read FDefaultValue;
  end;

  TpgItemInfo = class(TPersistent)
  private
    FName: Utf8String;
    FItemClass: TpgItemClass;
  public
    function New: TpgItem;
    property ItemClass: TpgItemClass read FItemClass;
    property Name: Utf8String read FName;
  end;

  TpgBoolProp = class(TpgProp)
  private
    FBoolValue: boolean;
  protected
//todo    procedure SetBoolValue(const Value: boolean);
    function Decode: boolean; override;
    function Encode: boolean; override;
    procedure CopyFrom(ANode: TObject); override;
  public
//todo    property BoolValue: boolean read FBoolValue write SetBoolValue;
  end;

  TpgIntProp = class(TpgProp)
  private
    FIntValue: integer;
  protected
//todo    procedure SetIntValue(const IV: integer);
//todo    function Decode: boolean; override;
//todo    function Encode: boolean; override;
    procedure CopyFrom(ANode: TObject); override;
  public
//todo    property IntValue: integer read FIntValue write SetIntValue;
  end;

  TpgFloatProp = class(TpgProp)
  private
    FFloatValue: double;
  protected
//todo    procedure SetFloatValue(const Value: double);
//todo    function Decode: boolean; override;
//todo    function Encode: boolean; override;
    procedure CopyFrom(ANode: TObject); override;
  public
//todo    property FloatValue: double read FFloatValue write SetFloatValue;
  end;

  TpgStringProp = class(TpgProp)
  private
    FStringValue: Utf8String;
  protected
//todo    procedure SetStringValue(const Value: Utf8String);
    function Decode: boolean; override;
    function Encode: boolean; override;
    procedure CopyFrom(ANode: TObject); override;
  public
//todo    property StringValue: Utf8String read FStringValue write SetStringValue;
  end;

  // TpgBinaryProp stores binary information in a string
  TpgBinaryProp = class(TpgStringProp)
  protected
    function Decode: boolean; override;
    function Encode: boolean; override;
  public
//    procedure SetBinary(First: pointer; Count: integer);
  end;

  // TpgRefProp stores ID of reference element
  TpgRefProp = class(TpgProp)
  private
    FRefItem: TpgItem;
  protected
//todo    procedure SetRefItem(const Value: TpgItem);
    function Decode: boolean; override;
//todo    function Encode: boolean; override;
    procedure CopyFrom(ANode: TObject); override;
  public
//todo    property RefItem: TpgItem read FRefItem write SetRefItem;
  end;

  TpgRefItem = class(TpgItem)
  private
    FRefCount: integer;
  protected
    procedure IncRef;
    procedure DecRef;
  end;

  // TpgStyleable is a TpgElement descendant that can be cloned from another
  // element, or contain reference to a style element
  TpgStyleable = class(TpgItem)
  private
    function GetClone: TpgRefProp;
    function GetStyle: TpgRefProp;
    function GetStyleName: TpgStringProp;
  protected
    function IntPropById(AId: longword): TpgIntProp;
    function FloatPropById(AId: longword): TpgFloatProp;
    function StringPropById(AId: longword): TpgStringProp;
    function RefPropById(AId: longword): TpgRefProp;
    function CheckReferenceProps(var APropAccess: TpgPropAccess): TpgProp; override;
  public
    property Clone: TpgRefProp read GetClone;
    property Style: TpgRefProp read GetStyle;
    // StyleName instead of Name because of clash with TpgElement.Name
    property StyleName: TpgStringProp read GetStyleName;
  end;

  // TpgStyle is an element that can store style properties. These are properties
  // with property info flag pfStyle set.
  TpgStyle = class(TpgStyleable)
  protected
    function CheckPropClass(AInfo: TpgPropInfo): boolean; override;
  end;

function GetPropInfo(AId: longword): TpgPropInfo;
function GetPropInfoByName(const AName: Utf8String; AItemClass: TpgItemClass): TpgPropInfo;
function GetItemInfoByClass(AClass: TpgItemClass): TpgItemInfo;
function GetItemInfoByName(const AName: Utf8String): TpgItemInfo;

procedure RegisterItem(AItemClass: TpgItemClass; const AName: Utf8String);

procedure RegisterProp(AId: longword; APropClass: TpgPropClass; const AName: Utf8String;
  AMinItemClass: TpgItemClass; AFlags: TpgPropInfoFlags; const ADefault: Utf8String = '');

implementation

type

  TpgPropInfoList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TpgPropInfo;
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    function NewDefault(AInfo: TpgPropInfo; AParent: TpgItem): TpgProp;
    function ByID(AID: longword): TpgPropInfo;
    property Items[Index: integer]: TpgPropInfo read GetItems; default;
  end;

  TpgItemInfoList = class(TObjectList)
  private
    function GetItems(Index: integer): TpgItemInfo;
  public
    function ByClass(AItemClass: TpgItemClass): TpgItemInfo;
    property Items[Index: integer]: TpgItemInfo read GetItems; default;
  end;

var

  glPropInfoList: TpgPropInfoList = nil;
  glItemInfoList: TpgItemInfoList = nil;

procedure RegisterItem(AItemClass: TpgItemClass; const AName: Utf8String);
var
  ItemInfo: TpgItemInfo;
begin
  if assigned(glItemInfoList.ByClass(AItemClass)) then
    raise Exception.CreateFmt(sDuplicateElementRegistered, [AItemClass]);
  ItemInfo := TpgItemInfo.Create;
  ItemInfo.FItemClass := AItemClass;
  ItemInfo.FName := AName;
  glItemInfoList.Add(ItemInfo);
end;

procedure RegisterProp(AId: longword; APropClass: TpgPropClass; const AName: Utf8String;
  AMinItemClass: TpgItemClass; AFlags: TpgPropInfoFlags; const ADefault: Utf8String);
var
  PropInfo: TpgPropInfo;
begin
  if assigned(glPropInfoList.ById(AId)) then
    raise Exception.CreateFmt(sDuplicatePropertyRegistered, [AId]);
  PropInfo := TpgPropInfo.Create;
  PropInfo.FId := AId;
  PropInfo.FPropClass := APropClass;
  PropInfo.FName := AName;
  PropInfo.FMinItemClass := AMinItemClass;
  PropInfo.FFlags := AFlags;
  PropInfo.FDefaultValue := ADefault;
  glPropInfoList.Add(PropInfo);
end;

function GetPropInfo(AId: longword): TpgPropInfo;
begin
  Result := glPropInfoList.ById(AId)
end;

function GetPropInfoByName(const AName: Utf8String; AItemClass: TpgItemClass): TpgPropInfo;
var
  i: integer;
  Info: TpgPropInfo;
begin
  Result := nil;
  if not assigned(AItemClass) then
    exit;
  for i := 0 to glPropInfoList.Count - 1 do
  begin
    Info := glPropInfoList[i];
    if (Info.Name = AName) and AItemClass.InheritsFrom(Info.MinItemClass) then
    begin
      Result := Info;
      exit;
    end;
  end;
end;

function GetItemInfoByClass(AClass: TpgItemClass): TpgItemInfo;
var
  i: integer;
  Info: TpgItemInfo;
begin
  for i := 0 to glItemInfoList.Count - 1 do
  begin
    Info := glItemInfoList[i];
    if Info.ItemClass = AClass then
    begin
      Result := Info;
      exit;
    end;
  end;
  Result := nil;
end;

function GetItemInfoByName(const AName: Utf8String): TpgItemInfo;
var
  i: integer;
  Info: TpgItemInfo;
begin
  for i := 0 to glItemInfoList.Count - 1 do
  begin
    Info := glItemInfoList[i];
    if Info.Name = AName then
    begin
      Result := Info;
      exit;
    end;
  end;
  Result := nil;
end;

{ TpgProp }

procedure TpgProp.CopyFrom(ANode: TObject);
begin
  //inherited; todo
  FID := TpgProp(ANode).FID;
end;

constructor TpgProp.CreateID(AOwner: TpgDocument; AID: longword);
begin
  Create(AOwner);
  FID := AID;
end;

procedure TpgProp.DoBeforeChange(AParent: TpgItem);
begin
  if assigned(AParent) then
    AParent.DoBeforePropChange(ID, ctPropUpdate);
end;

procedure TpgProp.DoAfterChange(AParent: TpgItem);
begin
  if assigned(AParent) then
    AParent.DoAfterPropChange(ID, ctPropUpdate);
end;

function TpgProp.GetAsString: Utf8String;
begin
  Decode;
  Result := Value;
end;

procedure TpgProp.SetAsString(const S: Utf8String);
begin
  Value := S;
  Encode;
end;

{function TpgProp.GetParent: TpgItem;
begin
  Result := TpgItem(FParent);
end;todo}

{function TpgProp.GetDocument: TpgDocument;
begin
  if assigned(Parent) then
    Result := Parent.Document
  else
    Result := nil;
end;todo}

{ TpgItem }

function TpgItem.CheckPropClass(PropInfo: TpgPropInfo): boolean;
begin
  if not InheritsFrom(PropInfo.MinItemClass) then
  begin
    DoDebugOut(Self, wsFail, Format(sNoSuchPropertyForClass, [ClassName]));
    Result := False;
    exit;
  end;

  // In other cases it is ok
  Result := True;
end;

function TpgItem.CheckPropLocations(var APropAccess: TpgPropAccess): TpgProp;
begin
  // Check our own list
  Result := LocalPropById(APropAccess.ID);
  if assigned(Result) then
  begin
    APropAccess.Creator := Self;
    exit;
  end;

  // Get the info now
  APropAccess.Info := glPropInfoList.ById(APropAccess.ID);
  if not assigned(APropAccess.Info) then
  begin
    DoDebugOut(Self, wsFail, Format(sUknownPropertyType, [APropAccess.ID]));
    exit;
  end;

  // Check correct property class
  if not CheckPropClass(APropAccess.Info) then
  begin
    exit;
  end;

  // lets now assume we create the prop
  APropAccess.Creator := Self;

  // Reference? (eg. style)
  Result := CheckReferenceProps(APropAccess);
  if assigned(Result) then
  begin
    exit;
  end;

{  // Parent?
  if (pfInherit in APropAccess.Info.Flags) and assigned(FParent)
    and (FParent is APropAccess.Info.MinElementClass) then
  begin
    Result := Parent.CheckPropLocations(APropAccess);
  end;}

end;

function TpgItem.CheckReferenceProps(var APropAccess: TpgPropAccess): TpgProp;
begin
  // This behaviour is implemented in TpgStyleable. If no style prop, just
  // debugmessage this
  DoDebugOut(Self, wsWarn, Format('no style defined for propid %d', [APropAccess.ID]));
  Result := nil;
end;

procedure TpgItem.Clear;
begin
// todo  FNodes.Clear;
end;

procedure TpgItem.CopyFrom(ANode: TXmlNode);
begin
  inherited;
  FFlags := TpgItem(ANode).FFlags;
end;

constructor TpgItem.Create(AOwner: TNativeXml);
var
  Info: TpgItemInfo;
begin
  inherited;
  // create the name
  Info := glItemInfoList.ByClass(TpgItemClass(ClassType));
  if assigned(Info) then
    SetName(Info.Name);
end;

constructor TpgItem.CreateCopyFrom(AItem: TpgItem; AParent: TpgItem);
begin
  raise Exception.Create('depreciated method');
end;

procedure TpgItem.DoAfterChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType);
begin
  if FOwner is TpgDocument then
    TpgDocument(FOwner).DoAfterChange(Self, APropId, AChange);
end;

procedure TpgItem.DoAfterCreate;
begin
  DoDebugOut(Self, wsInfo, format('created element %s', [Name]));
end;

procedure TpgItem.DoAfterLoad;
begin
// default does nothing
end;

procedure TpgItem.DoAfterPropChange(APropId: longword; AChange: TpgChangeType);
begin
  DoAfterChange(Self, APropId, AChange)
end;

procedure TpgItem.DoBeforeChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType);
begin
  if FOwner is TpgDocument then
    TpgDocument(FOwner).DoBeforeChange(AItem, APropId, AChange);
end;

procedure TpgItem.DoBeforePropChange(APropId: longword; AChange: TpgChangeType);
begin
  DoBeforeChange(Self, APropId, AChange)
end;

procedure TpgItem.DoBeforeSave;
begin
// default does nothing
end;

procedure TpgItem.DoItemAdd(AItem: TpgItem);
begin
  NodeAdd(AItem);
end;

procedure TpgItem.DoItemRemove(AItem: TpgItem);
begin
  NodeRemove(AItem);
end;

function TpgItem.ExistsLocal(AProp: TpgProp): boolean;
begin
  Result := assigned(LocalPropByID(AProp.ID));
end;

function TpgItem.GetDocument: TpgDocument;
begin
  Result := TpgDocument(FOwner);
end;

function TpgItem.GetItemCount: integer;
begin
  Result := GetContainerCount;
end;

function TpgItem.GetItems(Index: integer): TpgItem;
begin
  Result := TpgItem(GetContainers(Index));
end;

function TpgItem.GetID: Utf8String;
begin
  Result := '';
end;

{function TpgItem.GetParent: TpgItem;
begin
  Result := TpgItem(FParent);
end;todo}

function TpgItem.LocalPropByID(AID: longword): TpgProp;
var
  i: integer;
  Node: TXmlNode;
begin
  // the local properties are attributes of this element
  Result := nil;

  //todo: properties should be sorted, and if sorted, this can be faster
  // with a binary compare
  if AID = 0 then
    exit;
  for i := 0 to DirectNodeCount - 1 do
  begin
    Node := Nodes[i];
    if Node is TpgProp then
    begin
      if TpgProp(Node).FID = AID then
      begin
        Result := TpgProp(Node);
        exit;
      end;
    end;
  end;
end;

function TpgItem.NewProp(APropAccess: TpgPropAccess): TpgProp;
begin
  Result := APropAccess.Info.NewProp(Document);

  // the result now should be created
  if assigned(Result) then
    NodeAdd(Result)
  else
    // this exception really should not occur
    raise Exception.Create(sUnexpectedStructErr);
end;

function TpgItem.PropByID(AID: longword): TpgProp;
var
  APropAccess: TpgPropAccess;
  //DefaultItem: TpgItem;
begin
  // propaccess record
  APropAccess.ID := AID;
  APropAccess.Info := nil;
  APropAccess.Reader := Self;
  APropAccess.Creator := nil;

  // Check if the property can be found somewhere
  Result := CheckPropLocations(APropAccess);

  // Found? we can stop
  if assigned(Result) then
    exit;

  // brand new prop, created by us (Creator is Self, usually)
  if assigned(APropAccess.Creator) then
    Result := APropAccess.Creator.NewProp(APropAccess);

{  // Last resort: create a default property in container
  if assigned(Document) then
  begin
    DefaultElement := Document.FDefaultElement;
    if assigned(DefaultElement) then
      Result := DefaultElement.PropByID(AID);
  end;}
end;

procedure TpgItem.SetDocument(ADocument: TpgDocument);
begin
  FOwner := ADocument;
end;

procedure TpgItem.SetID(const AID: Utf8String);
begin
//!todo: create a ID property
end;

{procedure TpgItem.SetParent(AParent: TpgItem);
begin
  if AParent <> FParent then
  begin
    if FParent is TpgItem then
      TpgItem(FParent).DoItemRemove(Self);

    FParent := AParent;

    if FParent is TpgItem then
      TpgItem(FParent).DoItemAdd(Self);
  end;
end;todo}

{ TpgDocument }

constructor TpgDocument.Create(AOwner: TComponent);
begin
  inherited CreateEx(True, True, AOwner);
  FParser := TpgParser.CreateDebug(Self);
  FWriter := TpgWriter.CreateDebug(Self);
end;

destructor TpgDocument.Destroy;
begin
  FParser.Free;
  FWriter.Free;
  inherited;
end;

procedure TpgDocument.DoAfterChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType);
begin
// default does nothing
end;

procedure TpgDocument.DoBeforeChange(AItem: TpgItem; APropId: longword; AChange: TpgChangeType);
begin
// default does nothing
end;

function TpgDocument.ItemByID(const AID: Utf8String): TpgItem;
var
  Node: TXmlNode;
  Item: TpgItem;
begin
  Result := nil;
  Node := FindFirst;
  while assigned(Node) do
  begin
    if Node is TpgItem then
    begin
      Item := TpgItem(Node);
      if AID = Item.ID then
      begin
        Result := Item;
        exit;
      end;
    end;
    Node := FindNext(Node);
  end;

  // still here? debug it
  DoDebugOut(Self, wsWarn, format('Item with ID=%s could not be found', [AID]));
end;

function TpgDocument.ExistsItem(AItem: TpgItem): boolean;
begin
  Result := False;
  if not assigned(AItem) then
    exit;
  //todo: check if can be found in rootnodelist; for now just this result
  Result := True;
end;

{function TpgDocument.FindItem(AItemClass: TpgItemClass; AList: TsdNodeList; AIndex: integer): TpgItem;
var
  Node: TXmlNode;
  Item: TpgItem;
begin
  Result := nil;
  Node := AList.FindFirst;
  while assigned(Node) do
  begin
    if Node is AItemClass then
    begin
      Item := TpgItem(Node);

      // search for the next until AIndex = 0
      if AIndex = 0 then
      begin
        Result := Item;
        exit;
      end else
        dec(AIndex);

    end;
    Node := AList.FindNext(Node);
  end;
end;todo}

{function TpgDocument.NewItem(AItemClass: TpgItemClass; AParent: TpgItem): TpgItem;
begin
  Result := nil;
  if not assigned(AParent) then
  begin
    DoDebugOut(Self, wsFail, sParentIsRequired);
    exit;
  end;

  if assigned(AItemClass) then
  begin
    Result := AItemClass.CreateParent(Self, AParent);
  end;
end;todo}

procedure TpgDocument.Clear;
begin
  DoBeforeChange(nil, 0, ctListClear);
  inherited;
  DoAfterChange(nil, 0, ctListClear);
end;

procedure TpgDocument.BeginUpdate;
begin
  if FUpdateCount = 0 then
    DoBeforeChange(nil, 0, ctListUpdate);
  inc(FUpdateCount);
end;

procedure TpgDocument.EndUpdate;
begin
  dec(FUpdateCount);
  if FUpdateCount < 0 then
    raise Exception.Create(sUpdateBeginEndMismatch);
  if FUpdateCount = 0 then
    DoAfterChange(nil, 0, ctListUpdate);
end;

{procedure TpgDocument.SaveToStream(Stream: TStream);
begin
  // call NodeBeforeSave for each node before saving to stream,
  // so the element and property values are updated
  ForEach(Self, NodeBeforeSave);
  inherited;
end;}

procedure TpgDocument.NodeBeforeSave(Sender: TObject; ANode: TXmlNode);
begin
  // before saving we force the attribute string values
  if (Sender = Self) and (ANode is TpgProp) then
  begin
    // this forces the attribute string value
    TpgProp(ANode).GetAsString;
//test    TpgProp(ANode).SetAsString('*' + TpgProp(ANode).GetAsString);
  end;
end;

{ TpgPropInfo }

function TpgPropInfo.NewProp(AOwner: TpgDocument): TpgProp;
begin
  if assigned(FPropClass) then
  begin
    Result := FPropClass.Create(AOwner);
    // create the resulting prop's id and name
    Result.FID := FID;
    Result.Name := FName;
    // create prop's default value if applicable
    if length(FDefaultValue) > 0 then
      Result.SetAsString(FDefaultValue);
  end else
    Result := nil;
end;

{ TpgPropInfoList }

function TpgPropInfoList.ById(AId: longword): TpgPropInfo;
var
  Index, AMin, AMax: integer;
begin
  // Find position for insert - binary method
  AMin := 0;
  AMax := Count;
  while AMin < AMax do
  begin
    Index := (AMin + AMax) div 2;
    case CompareInteger(Items[Index].FId, AId) of
    -1: AMin := Index + 1;
     0: begin
          Result := Items[Index];
          exit;
        end;
     1: AMax := Index;
    end;
  end;
  Result := nil;
end;

function TpgPropInfoList.DoCompare(Item1, Item2: TObject): integer;
begin
  Result := CompareInteger(TpgPropInfo(Item1).FId, TpgPropInfo(Item2).FId);
end;

function TpgPropInfoList.GetItems(Index: integer): TpgPropInfo;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

function TpgPropInfoList.NewDefault(AInfo: TpgPropInfo; AParent: TpgItem): TpgProp;
var
  Document: TpgDocument;
begin
  Result := nil;
  if (AParent = nil) or (AInfo = nil) or (AInfo.PropClass = nil) then
    exit;

  Document := AParent.Document;
  Result := AInfo.PropClass.Create(Document);
  AParent.NodeAdd(Result);

  if length(AInfo.DefaultValue) > 0 then
    Result.SetAsString(AInfo.DefaultValue);
end;

{ TpgItemInfo }

function TpgItemInfo.New: TpgItem;
begin
  if assigned(FItemClass) then
    Result := FItemClass.Create(nil)
  else
    Result := nil;
end;

{ TpgItemInfoList }

function TpgItemInfoList.ByClass(AItemClass: TpgItemClass): TpgItemInfo;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].FItemClass = AItemClass then
    begin
      Result := Items[i];
      exit;
    end;
end;

function TpgItemInfoList.GetItems(Index: integer): TpgItemInfo;
begin
  Result := Get(Index)
end;

{ TpgBoolProp }

procedure TpgBoolProp.CopyFrom(ANode: TObject);
begin
  inherited;
  FBoolValue := TpgBoolProp(ANode).FBoolValue;
end;

function TpgBoolProp.Decode: boolean;
// decode sets DSEG
begin
  SetValueAsBool(FBoolValue);
  Result := True;
end;

function TpgBoolProp.Encode: boolean;
// encode gets
begin
  Result := True;
  FBoolValue := GetValueAsBool;
end;

{procedure TpgBoolProp.SetBoolValue(const Value: boolean);
begin
  // Do we have to write?
  if (FBoolValue <> Value) then
  begin
    DoBeforeChange(Parent);
    FBoolValue := Value;
    DoAfterChange(Parent);
  end;
end;todo}

{ TpgIntProp }

procedure TpgIntProp.CopyFrom(ANode: TObject);
begin
  inherited;
  FIntValue := TpgIntProp(ANode).FIntValue;
end;

{function TpgIntProp.Decode: boolean;
// decode sets
begin
  SetValue(Document.FWriter.pgWriteInteger(FIntValue));
  Result := True;
end;todo}

{function TpgIntProp.Encode: boolean;
// encode gets
begin
  FIntValue := Document.FParser.pgParseInteger(GetValue);
  Result := True;
end;todo}

{procedure TpgIntProp.SetIntValue(const IV: integer);
begin
  // Do we have to write?
  if (FIntValue <> IV) then
  begin
    DoBeforeChange(Parent);
    FIntValue := IV;
    GetAsString;
    DoAfterChange(Parent);
  end;
end;todo}

{ TpgFloatProp }

procedure TpgFloatProp.CopyFrom(ANode: TObject);
begin
  inherited;
  FFloatValue := TpgFloatProp(ANode).FFloatValue;
end;

{function TpgFloatProp.Decode: boolean;
begin
  Value := sdFloatToString(FFloatValue);
  Result := True;
end;todo}

{function TpgFloatProp.Encode: boolean;
begin
  FFloatValue := sdFloatFromString(Value);
  Result := True;
end;todo}

{procedure TpgFloatProp.SetFloatValue(const Value: double);
begin
  // Do we have to write?
  if (FFloatValue <> Value) then
  begin
    DoBeforeChange(Parent);
    FFloatValue := Value;
    DoAfterChange(Parent);
  end;
end;todo}

{ TpgStringProp }

procedure TpgStringProp.CopyFrom(ANode: TObject);
begin
  inherited;
  FStringValue := TpgStringProp(ANode).FStringValue;
end;

function TpgStringProp.Decode: boolean;
begin
  Value := FStringValue;
  Result := True;
end;

function TpgStringProp.Encode: boolean;
begin
  FStringValue := Value;
  Result := True;
end;

{procedure TpgStringProp.SetStringValue(const Value: Utf8String);
begin
  // Do we have to write?
  if (FStringValue <> Value) then
  begin
    DoBeforeChange(Parent);
    FStringValue := Value;
    DoAfterChange(Parent);
  end;
end;todo}

{ TpgBinaryProp }

function TpgBinaryProp.Decode: boolean;
begin
//todo
  Result := False;
end;

function TpgBinaryProp.Encode: boolean;
begin
//todo
  Result := False;
end;

{procedure TpgBinaryProp.SetBinary(First: pointer; Count: integer);
begin
  DoBeforeChange(Parent);

  SetLength(FStringValue, Count);
  if Count > 0 then
    Move(First^, FStringValue[1], Count);

  DoAfterChange(Parent);
end;todo}

{ TpgRefProp }

procedure TpgRefProp.CopyFrom(ANode: TObject);
begin
  inherited;
  FRefItem := TpgRefProp(ANode).FRefItem;
end;

function TpgRefProp.Decode: boolean;
begin
  Result := True;
  if assigned(FRefItem) then
    Value := TpgItem(FRefItem).ID
  else
  begin
    DoDebugOut(Self, wsWarn, 'reference item = nil');
    Value := '';
    Result := False;
  end;
end;

{function TpgRefProp.Encode;
begin
  Result := True;
  FRefItem := Document.ItemById(Value);
  if FRefItem = nil then
  begin
    DoDebugOut(Self, wsWarn, Format('reference cannot be found from ID=%s', [Value]));
    Result := False;
  end;
end;todo}

{procedure TpgRefProp.SetRefItem(const Value: TpgItem);
begin
  if (FRefItem <> Value) then
  begin
    DoBeforeChange(Parent);
    FRefItem := Value;
    DoAfterChange(Parent);
  end;
end;todo}

{ TpgStyleable }

function TpgStyleable.CheckReferenceProps(var APropAccess: TpgPropAccess): TpgProp;
var
  CloneItem: TpgItem;
  StyleItem: TpgStyle;
  CloneProp, StyleProp: TpgProp;
begin
  CloneItem := nil;
  StyleItem := nil;
  Result := nil;

  // Do we have a referenced element?
  CloneProp := LocalPropByID(piClone);
  if assigned(CloneProp) then
//todo    CloneItem := TpgRefProp(CloneProp).RefItem;

  // Do we have a style element?
  StyleProp := LocalPropByID(piStyle);
  if assigned(StyleProp) then
//todo    StyleItem := TpgStyle(TpgRefProp(StyleProp).RefItem);

  // Check style
  if assigned(StyleItem) then
  begin
    Result := StyleItem.CheckPropLocations(APropAccess);
    if assigned(Result) then
      exit;
  end;

  // Check clone
  if assigned(CloneItem) then
    // Correct class?
    if CloneItem.InheritsFrom(APropAccess.Info.MinItemClass) then
      // Let the referenced element check
      Result := CloneItem.CheckPropLocations(APropAccess);

{  // call the ancestor
  if Result = nil then
    Result := inherited CheckReferenceProps(APropAccess);}
end;

function TpgStyleable.FloatPropById(AId: longword): TpgFloatProp;
begin
  Result := TpgFloatProp(PropById(AId));
end;

function TpgStyleable.GetClone: TpgRefProp;
begin
  Result := RefPropbyId(piClone);
end;

function TpgStyleable.GetStyleName: TpgStringProp;
begin
  Result := StringPropById(piName);
end;

function TpgStyleable.GetStyle: TpgRefProp;
begin
  Result := TpgRefProp(PropByID(piStyle));
end;

function TpgStyleable.IntPropById(AID: longword): TpgIntProp;
begin
  Result := TpgIntProp(PropByID(AId));
end;

function TpgStyleable.RefPropById(AID: longword): TpgRefProp;
begin
  Result := TpgRefProp(PropByID(AId));
end;

function TpgStyleable.StringPropById(AID: longword): TpgStringProp;
begin
  Result := TpgStringProp(PropByID(AId));
end;

{ TpgStyle }

function TpgStyle.CheckPropClass(AInfo: TpgPropInfo): boolean;
begin
  Result := pfStyle in AInfo.Flags;
end;

{ TpgRefItem }

procedure TpgRefItem.DecRef;
begin
  dec(FRefCount);
  if FRefCount <= 0 then
  begin
    // We do not free the ref element as before, just clear it. Freeing it
    // gives problems with the container's clear method, as it doesn't expect
    // the element to be freed through DecRef when doing a free on the total list
    // This may have the side effect of reference elements hanging around, but
    // the scene should be able to check for these (using the RefCount)
    Clear;
  end;
end;

procedure TpgRefItem.IncRef;
begin
  inc(FRefCount);
end;

initialization

  glPropInfoList := TpgPropInfoList.Create;
  glItemInfoList := TpgItemInfoList.Create;

  RegisterItem(TpgItem, 'item');

  RegisterItem(TpgStyleable, 'styleable');
  RegisterItem(TpgStyle,     'style');

  RegisterProp(piClone, TpgRefProp, 'clone', TpgStyleable, [pfInherit, pfStyle, pfStored]);
  RegisterProp(piStyle, TpgRefProp, 'style', TpgStyleable, [pfStyle, pfStored]);
  RegisterProp(piName, TpgStringProp, 'name', TpgStyleable, [pfStored]);
  RegisterProp(piID, TpgStringProp, 'id', TpgStyleable, [pfStored]);

finalization

  FreeAndNil(glItemInfoList);
  FreeAndNil(glPropInfoList);

end.
