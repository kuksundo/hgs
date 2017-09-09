{
  Unit dtpEffectShape

  TdtpEffectShape implements effects on the cache through the Effects[] object list.

  Project: DTP-Engine

  Creation Date: 22-08-2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpEffectShape;

{$i simdesign.inc}

interface

uses
  Classes, Contnrs, ExtCtrls, StdCtrls, SysUtils, dtpShape, dtpCommand, NativeXmlOld,
  dtpGraphics, dtpDefaults, Math, sdDebug;

const
  // Specific effect origins
  ceoPrevious = -2;
  ceoOriginal = -1;

type

  TdtpEffectShape = class;

  // This is the base class for all descending effects. An effect is an operation on
  // the shape's cache. The cache is a 32bit Bitmap, containing alpha transparency.
  // Therefore, effects can for instance also provide semi-transparent shadow.
  // Effects are layered in the Effects[] list in the TdtpEffectShape.
  TdtpEffect = class(TPersistent)
  private
    FEnabled: boolean;        // Effect is enabled
    FParent: TdtpEffectShape; // pointer to parent shape
    FSource: integer;         // Source DIB to use for effect, default is ceoPrevious
    FPreserve: boolean;       // Preserve the result in temporary DIB
    FResultDIB: TdtpBitmap;   // Temporary DIB to hold result while effects are being painted
    procedure SetEnabled(const Value: boolean);
    procedure SetSource(const Value: integer);
    function GetIndex: integer;
    function GetAsBinaryString: RawByteString;
    procedure SetAsBinaryString(const Value: RawByteString);
  protected
    procedure Changed;
    procedure Invalidate; virtual;
    procedure PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext); virtual;
    procedure Update; virtual;
    procedure SetParent(const Value: TdtpEffectShape); virtual;
    procedure ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single); virtual;
    procedure AddCmdToUndo(const AProp, AValue: string);
    procedure SetPropertyByName(const AName, AValue: string); virtual;
    property Index: integer read GetIndex;
    property AsBinaryString: RawByteString read GetAsBinaryString write SetAsBinaryString;
  public
    constructor Create; virtual;
    class function EffectName: string; virtual;
    procedure AddArchiveResourceNames(Names: TStrings); virtual;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromXml(ANode: TXmlNodeOld); virtual;
    procedure SaveToXml(ANode: TXmlNodeOld); virtual;
    procedure NextUndoNoRepeatedPropertyChange;
    procedure Refresh; virtual;
    property Enabled: boolean read FEnabled write SetEnabled;
    property Source: integer read FSource write SetSource;
    property Parent: TdtpEffectShape read FParent write SetParent;
    property Preserve: boolean read FPreserve write FPreserve;
    property ResultDIB: TdtpBitmap read FResultDIB;
  end;

  // Generic class for effects, used when registering effects.
  TdtpEffectClass = class of TdtpEffect;

  // TdtpEffectShape is a TdtpShape descendant that allows effects to be assigned.
  // Any shape that wants to use effects must descend from TdtpEffectShape.
  TdtpEffectShape = class(TdtpShape)
  private
    FEffects: TObjectList;
    FOriginalDIB: TdtpBitmap;
    function GetEffectCount: integer;
    function GetEffects(Index: integer): TdtpEffect;
  protected
    // Overloaded version of AddCmdToUndo specifically for undo/redo of effects and effect properties
    procedure AddCmdToUndo(ACommand: TdtpCommandType; AEffect: TdtpEffect;
     Index: integer; const AProp, AValue: string); overload;
    procedure AddArchiveResourceNames(Names: TStrings); override;
    function GetHasEffects: boolean; override;
    procedure PaintEffects(DIB: TdtpBitmap; const Device: TDeviceContext); override;
    procedure ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single); override;
    property OriginalDIB: TdtpBitmap read FOriginalDIB;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function EffectAdd(AEffect: TdtpEffect): integer;
    procedure EffectInsert(Index: integer; AEffect: TdtpEffect);
    procedure EffectAddClass(AClass: TdtpEffectClass; Enabled: boolean = True);
    procedure EffectInsertClass(Index: integer; AClass: TdtpEffectClass; Enabled: boolean = True);
    function EffectByClass(AClass: TdtpEffectClass): TdtpEffect;
    procedure EffectDelete(Index: integer);
    procedure EffectExchange(Idx1, Idx2: integer);
    function EffectIndexOf(AEffect: TdtpEffect): integer;
    function EffectRemove(AEffect: TdtpEffect): integer;
    function HasEffect(AClass: TdtpEffectClass): boolean;
    function PerformCommand(ACommand: TdtpCommand): boolean; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property EffectCount: integer read GetEffectCount;
    property Effects[Index: integer]: TdtpEffect read GetEffects;
  end;

  // TdtpGroupShape provides a method to group selected shapes and to ungroup
  // them (explode them back into the document).
  TdtpGroupShape = class(TdtpEffectShape)
  public
    // Group the selected shapes in the document into this shape. Normally one would
    // create a new TdtpGroupShape and then call this method to group a number of
    // shapes with this effect shape as parent.
    procedure Group;
    // Ungroup the shapes that are in this group shape and release them in the
    // current document.
    procedure Ungroup;
  end;


// Create Effect classes
function RetrieveEffectClass(const AClassName: string): TdtpEffectClass;

// Register Effect classes
procedure RegisterEffectClass(AClass: TdtpEffectClass; IsPublished: boolean = True);

// Get a list with available effects
procedure GetAvailableEffectNames(AList: TStringList);

implementation

uses
  dtpDocument;

type
  TEffectClassHolder = class
  public
    FClass: TdtpEffectClass;
    FClassName: string;
    FIsPublished: boolean;
  end;

var
  FEffectClassList: TObjectList = nil;

function RetrieveEffectClass(const AClassName: string): TdtpEffectClass;
var
  i: integer;
begin
  Result := TdtpEffect;
  if assigned(FEffectClassList) then with FEffectClassList do
  begin
    for i := 0 to Count - 1 do
      if TEffectClassHolder(Items[i]).FClassName = AClassName then
      begin
        Result := TEffectClassHolder(Items[i]).FClass;
        exit;
      end;
  end;
end;

procedure RegisterEffectClass(AClass: TdtpEffectClass; IsPublished: boolean = True);
// Register currently unknown effect classes
var
  i: integer;
  NewClass: TEffectClassHolder;
begin
  if not assigned(FEffectClassList) then
    FEffectClassList := TObjectList.Create;
  // Unique?
  with FEffectClassList do
  begin
    for i := 0 to Count - 1 do
      if AClass = TEffectClassHolder(Items[i]).FClass then
        exit;
    // Add new class
    NewClass := TEffectClassHolder.Create;
    NewClass.FClass := AClass;
    NewClass.FClassName := AClass.ClassName;
    NewClass.FIsPublished := IsPublished;
    Add(NewClass);
  end;
end;

procedure GetAvailableEffectNames(AList: TStringList);
var
  i: integer;
begin
  if not assigned(AList) then
    exit;
  AList.Clear;

  if not assigned(FEffectClassList) then
    exit;
  with FEffectClassList do
    for i := 0 to Count - 1 do
      with TEffectClassHolder(Items[i]) do
        if FIsPublished then
          AList.AddObject(FClass.EffectName, TObject(FClass));

end;

{ TdtpEffect }

procedure TdtpEffect.AddArchiveResourceNames(Names: TStrings);
begin
//
end;

procedure TdtpEffect.AddCmdToUndo(const AProp, AValue: string);
begin
  if not assigned(FParent) then
    exit;
  FParent.AddCmdToUndo(cmdEffectSetProp, Self, Index, AProp, AValue);
end;

procedure TdtpEffect.Assign(Source: TPersistent);
var
  Xml: TNativeXmlOld;
begin
  if Source is TdtpEffect then
  begin
    Xml := CreateXmlForDtp('');
    try
      TdtpEffect(Source).SaveToXml(Xml.Root);
      LoadFromXml(Xml.Root);
    finally
      Xml.Free;
    end;
  end else
    inherited;
end;

procedure TdtpEffect.Changed;
// Call this procedure when an effect property changes. It will force the shape
// to redraw, and set its changed property
begin
  Update;
  Refresh;
  if assigned(Parent) then
    Parent.Changed;
end;

constructor TdtpEffect.Create;
begin
  inherited Create;
  // Defaults
  FEnabled := True;
  FSource := ceoPrevious;
end;

class function TdtpEffect.EffectName: string;
begin
  Result := copy(ClassName, 5, Length(ClassName) - 10);
end;

function TdtpEffect.GetAsBinaryString: RawByteString;
// Write out all the effect's properties and resources as one binary string
var
  Names: TStringList;
  M, R: TMemoryStream;
  i, Count: integer;
  Xml: TNativeXmlOld;
begin
  M := TMemoryStream.Create;
  R := TMemoryStream.Create;
  try
    // Add all used resources
    Names := TStringList.Create;
    try
      AddArchiveResourceNames(Names);
      // Store these resources
      Count := Names.Count;
      if FParent.Archive = nil then
        Count := 0;
      M.Write(Count, SizeOf(Count));
      for i := 0 to Count - 1 do
      begin
        WriteStringToStream(UTF8String(Names[i]), M);
        R.Clear;
        if FParent.Archive.StreamExists(UTF8String(Names[i])) then
          FParent.Archive.StreamRead(UTF8String(Names[i]), R);
        WriteStreamToStream(R, M);
      end;
    finally
      Names.Free;
    end;

    // Add properties in form of XML
    R.Clear;
    Xml := CreateXmlForDtp('effect');
    try
      SaveToXml(Xml.Root);
      Xml.SaveToStream(R);
    finally
      Xml.Free;
    end;
    WriteStreamToStream(R, M);
    // to do: find a way to add events and object references

    // Add all to result
    SetLength(Result, M.Size);
    if M.Size > 0 then
      move(M.Memory^, Result[1], M.Size);

  finally
    R.Free;
    M.Free;
  end;

end;

function TdtpEffect.GetIndex: integer;
begin
  Result := FParent.FEffects.IndexOf(Self);
end;

procedure TdtpEffect.Invalidate;
begin
  if assigned(Parent) then
    Parent.Invalidate;
end;

procedure TdtpEffect.LoadFromXml(ANode: TXmlNodeOld);
// Load data from XML (override in descendants!)
begin
  if not assigned(ANode) then
    exit;
  FEnabled := ANode.ReadBool('Enabled');
  FSource  := ANode.ReadInteger('Source', ceoPrevious);
end;

procedure TdtpEffect.NextUndoNoRepeatedPropertyChange;
begin
  if assigned(Parent) then
    Parent.NextUndoNoRepeatedPropertyChange;
end;

procedure TdtpEffect.PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext);
// Override this method to paint the effect onto DIB
begin
// Default does nothing
end;

procedure TdtpEffect.Refresh;
// In this case, the shape must be redrawn - we have to refresh the parent
begin
  if assigned(Parent) then
    Parent.Refresh;
end;

procedure TdtpEffect.SaveToXml(ANode: TXmlNodeOld);
begin
  if not assigned(ANode) then
    exit;
  // Save our class name first
  ANode.WriteString('ClassName', UTF8String(ClassName));
  ANode.WriteBool('Enabled', FEnabled);
  ANode.WriteInteger('Source', FSource, ceoPrevious);
end;

procedure TdtpEffect.SetAsBinaryString(const Value: RawByteString);
// Read in all the effect's properties and resources from one binary string
var
  Name: string;
  M, R: TMemoryStream;
  i, Count: integer;
  Xml: TNativeXmlOld;
begin
  M := TMemoryStream.Create;
  R := TMemoryStream.Create;
  try
    // Get M
    M.Size := length(Value);
    if M.Size = 0 then
      exit;

    move(Value[1], M.Memory^, M.Size);

    // Read all used resources
    M.Read(Count, SizeOf(Count));
    for i := 0 to Count - 1 do
    begin
      Name := string(ReadStringFromStream(M));
      ReadStreamFromStream(R, M);
      if (R.Size > 0) and (FParent.Archive <> nil) then
        // write to the archive
        FParent.Archive.StreamWrite(UTF8String(Name), R);
    end;

    // properties
    ReadStreamFromStream(R, M);
    Xml := CreateXmlForDtp('');
    try
      Xml.LoadFromStream(R);
      LoadFromXml(Xml.Root);
    finally
      Xml.Free;
    end;

  finally
    R.Free;
    M.Free;
  end;

end;

procedure TdtpEffect.SetEnabled(const Value: boolean);
begin
  if FEnabled <> Value then
  begin
    AddCmdToUndo('Enabled', BoolAsString(FEnabled));
    FEnabled := Value;
    Refresh;
  end;
end;

procedure TdtpEffect.SetParent(const Value: TdtpEffectShape);
begin
  // Default just sets parent
  FParent := Value;
end;

procedure TdtpEffect.SetPropertyByName(const AName, AValue: string);
begin
  if AName = 'Source' then
  begin
    Source := StrToInt(AValue);
  end else
    if AName = 'Enabled' then
    begin
      Enabled := BoolAsString(AValue);
    end;
end;

procedure TdtpEffect.SetSource(const Value: integer);
begin
  if FSource <> Value then
  begin
    AddCmdToUndo('Source', IntToStr(FSource));
    FSource := Value;
    Changed;
  end;
end;

procedure TdtpEffect.Update;
// This procedure is called after loading, and after properties are changed.
// Override it to do pre-processing
begin
// Default does nothing
end;

procedure TdtpEffect.ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single);
// Validate that the listed Curb sizes will be adequate to house our effect..
// ..we can check the original curbs with Parent.CurbLeft..etc. *ONLY* make them
// bigger! never smaller!
begin
// Default does nothing
end;

{ TdtpEffectShape }

procedure TdtpEffectShape.AddArchiveResourceNames(Names: TStrings);
var
  i: integer;
begin
  inherited;
  // Effects can have archives too
  for i := 0 to EffectCount - 1 do
    Effects[i].AddArchiveResourceNames(Names);
end;

procedure TdtpEffectShape.AddCmdToUndo(ACommand: TdtpCommandType; AEffect: TdtpEffect;
  Index: integer; const AProp, AValue: string);
// Overloaded version of AddCmdToUndo specifically for undo/redo of effects
var
  S: TStream;
  Cmd: TdtpCommand;
  i: integer;
  Names: TStringList;
begin
  // no document? then just exit
  if not assigned(Document) then
    exit;

  Cmd := nil;

  case ACommand of
  cmdEffectInsert:
    begin
      // Insert effect AEffect into the document when undoing; so now we must save it
      // and create the Undo command
      S := TMemoryStream.Create;
      // Write effect info
      WriteStringToStream(AEffect.AsBinaryString, S);
      // Remove the resources the effect was using
      if Archive <> nil then
      begin
        Names := TStringList.Create;
        try
          AEffect.AddArchiveResourceNames(Names);
          for i := 0 to Names.Count - 1 do
          begin
            if Archive.StreamIsUnique(UTF8String(Names[i])) then
              Archive.StreamDelete(UTF8String(Names[i]));
          end;
        finally
          Names.Free;
        end;
      end;

      // Store ACommand (cmdEffectInsert), SessionRef, Prop=IntToStr(Index),
      // Value=our classname, S contains a copy of the shape
      Cmd := TdtpCommand.Create(ACommand, SessionRef, IntToStr(Index), AEffect.ClassName, S);
    end;
  cmdEffectDelete:
    begin
      // Store delete index as string in Value
      Cmd := TdtpCommand.Create(ACommand, SessionRef, '', IntToStr(Index), nil);
    end;
  cmdEffectSetProp:
    begin
      // Add cmdEffectSetProp, SessionRef, Prop = Index.PropName, AValue, nil
      Cmd := TdtpCommand.Create(ACommand, SessionRef,
        Format('%d.%s', [Index, AProp]), AValue, nil);
    end;
  end;//case

  if not assigned(Cmd) then
    exit;

  if UndoEnabled then
    TdtpDocument(Document).UndoAdd(Cmd)
  else
    TdtpDocument(Document).RedoAdd(Cmd);
end;

procedure TdtpEffectShape.Clear;
begin
  FEffects.Clear;
  inherited;
end;

constructor TdtpEffectShape.Create;
begin
  inherited;
  FEffects := TObjectList.Create;
end;

destructor TdtpEffectShape.Destroy;
begin
  FreeAndNil(FEffects);
  inherited;
end;

function TdtpEffectShape.EffectAdd(AEffect: TdtpEffect): integer;
begin
  Result := -1;
  if assigned(AEffect) and assigned(FEffects) then
  begin
    // Invalidate old shape size
    Invalidate;
    AddCmdToUndo(cmdEffectDelete, AEffect, FEffects.Count, '', '');
    Result := FEffects.Add(AEffect);
    AEffect.Parent := Self;
    // Refresh the cache (and this also checks curbs and invalidates the new shape size)
    Refresh;
    // Properties changed.. new effect added
    Changed;
  end;
end;

procedure TdtpEffectShape.EffectAddClass(AClass: TdtpEffectClass; Enabled: boolean);
// Add the effect with class AClass
var
  Effect: TdtpEffect;
begin
  if not assigned(AClass) then
    exit;
  Effect := AClass.Create;
  Effect.Enabled := Enabled;
  EffectAdd(Effect);
end;

function TdtpEffectShape.EffectByClass(AClass: TdtpEffectClass): TdtpEffect;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to EffectCount - 1 do
    if Effects[i] is AClass then
    begin
      Result := Effects[i];
      exit;
    end;
end;

procedure TdtpEffectShape.EffectDelete(Index: integer);
begin
  if (Index >= 0) and (Index < EffectCount) then
  begin
    // Before removing, first invalidate to ensure that effects that were
    // enlarging the curbed sizes are completely cleared
    Invalidate;
    // Undo
    AddCmdToUndo(cmdEffectInsert, TdtpEffect(FEffects[Index]), Index, '', '');
    // Now delete
    FEffects.Delete(Index);
    // Refresh the cache (and this also checks curbs and invalidates the new shape size)
    Refresh;
    // Properties changed.. new effect added
    Changed;
  end;
end;

procedure TdtpEffectShape.EffectExchange(Idx1, Idx2: integer);
begin
  // Check for errors
  if (Idx1 = Idx2) or (Idx1 < 0) or (Idx2 < 0) or
     (Idx1 >= EffectCount) or (Idx2 >= EffectCount) then
    exit;
  // Invalidate our rect first
  Invalidate;
  // Exchange the effects
  FEffects.Exchange(Idx1, Idx2);
  // Update
  Refresh;
  Changed;
end;

function TdtpEffectShape.EffectIndexOf(AEffect: TdtpEffect): integer;
begin
  Result := -1;
  if assigned(FEffects) and assigned(AEffect) then
    Result := FEffects.IndexOf(AEffect);
end;

procedure TdtpEffectShape.EffectInsert(Index: integer; AEffect: TdtpEffect);
begin
  if assigned(AEffect) and (Index >= 0) and (Index <= EffectCount) then
  begin
    // Invalidate old shape size
    Invalidate;
    AddCmdToUndo(cmdEffectDelete, AEffect, Index, '', '');
    FEffects.Insert(Index, AEffect);
    AEffect.Parent := Self;
    // Refresh the cache (and this also checks curbs and invalidates the new shape size)
    Refresh;
    // Properties changed.. new effect added
    Changed;
  end else
    if assigned(AEffect) then
      FreeAndNil(AEffect);  // changed by J.F. Feb 2011
end;

procedure TdtpEffectShape.EffectInsertClass(Index: integer; AClass: TdtpEffectClass; Enabled: boolean);
var
  Effect: TdtpEffect;
begin
  if not assigned(AClass) then
    exit;
  Effect := AClass.Create;
  Effect.Enabled := Enabled;
  EffectInsert(Index, Effect);
end;

function TdtpEffectShape.EffectRemove(AEffect: TdtpEffect): integer;
begin
  Result := EffectIndexOf(AEffect);
  EffectDelete(Result);
end;

function TdtpEffectShape.GetEffectCount: integer;
begin
  Result := 0;
  if assigned(FEffects) then
    Result := FEffects.Count;
end;

function TdtpEffectShape.GetEffects(Index: integer): TdtpEffect;
begin
  Result := nil;
  if (Index >= 0) and (Index < EffectCount) then
    Result := TdtpEffect(FEffects[Index]);
end;

function TdtpEffectShape.GetHasEffects: boolean;
var
  i: integer;
begin
  Result := inherited GetHasEffects;
  if Result  then
    exit;
  for i := 0 to EffectCount - 1 do
    if Effects[i].Enabled then
    begin
      Result := True;
      exit;
    end;
end;

function TdtpEffectShape.HasEffect(AClass: TdtpEffectClass): boolean;
begin
  Result := assigned(EffectByClass(AClass));
end;

procedure TdtpEffectShape.LoadFromXml(ANode: TXmlNodeOld);
var
  i: integer;
  List: TList;
  Child: TXmlNodeOld;
  EffectClass: TdtpEffectClass;
  Effect: TdtpEffect;
begin
  inherited;
  // Load effects
  List := TList.Create;
  try
    ANode.NodesByName('Effect', List);
    for i := 0 to List.Count - 1 do
    begin
      Child := List[i];
      EffectClass := RetrieveEffectClass(string(Child.ReadString('ClassName')));
      Effect := EffectClass.Create;
      EffectAdd(Effect);
      Effect.LoadFromXml(Child);
      Effect.Update;
    end;
  finally
    List.Free;
  end;
end;

procedure TdtpEffectShape.PaintEffects(DIB: TdtpBitmap; const Device: TDeviceContext);
var
  i: integer;
begin
  // Preview round to see which effects need to be preserved.
  for i := 0 to EffectCount - 1 do
    if Effects[i].Source = ceoOriginal then
    begin
      if not assigned(FOriginalDIB) then
      begin
        FOriginalDIB := TdtpBitmap.Create;
        FOriginalDIB.Assign(DIB);
      end;
    end else
      if Effects[i].Source <> ceoPrevious then
        Effects[Effects[i].Source].Preserve := True;

  // Paint the effects
  for i := 0 to EffectCount - 1 do
  begin
    if Effects[i].Enabled then
    begin
      Effects[i].PaintEffect(DIB, Device);
    end;
    if Effects[i].Preserve then
    begin
      Effects[i].FResultDIB := TdtpBitmap.Create;
      Effects[i].FResultDIB.Assign(DIB);
    end;
  end;

  // And get rid of any preserved
  for i := 0 to EffectCount - 1 do
  begin
    Effects[i].Preserve := False;
    FreeAndNil(Effects[i].FResultDIB);
  end;
  FreeAndNil(FOriginalDIB);

  // Call this as last - applies mirror and flip
  inherited;
end;

function TdtpEffectShape.PerformCommand(ACommand: TdtpCommand): boolean;
var
  EC: TdtpEffectClass;
  Effect: TdtpEffect;
  Idx, P: integer;
  Prop: string;
begin
  Result := False;
  if not assigned(ACommand) then
    exit;

  // Check for whom the command is destined
  if (ACommand.Ref = SessionRef) and
    (ACommand.Command in [cmdEffectDelete, cmdEffectInsert, cmdEffectSetProp]) then
  begin

    case ACommand.Command of
    cmdEffectDelete:
      // Delete index was stored in ACommand.Value
      EffectDelete(StrToInt(ACommand.Value));
    cmdEffectInsert:
      begin
        EC := RetrieveEffectClass(ACommand.Value);
        Effect := EC.Create;
        Idx := StrToInt(ACommand.Prop);
        EffectInsert(Idx, Effect);
        Effect.AsBinaryString := RawByteString(ReadStringFromStream(ACommand.Stream));
      end;
    cmdEffectSetProp:
      begin
        P := Pos('.', ACommand.Prop);
        Idx := StrToInt(copy(ACommand.Prop, 1, P - 1));
        Prop := copy(ACommand.Prop, P + 1, length(ACommand.Prop));
        Effects[Idx].SetPropertyByName(Prop, ACommand.Value);
      end;
    end;
    // Set as handled
    Result := True;

  end else
    Result := inherited PerformCommand(ACommand);
end;

procedure TdtpEffectShape.SaveToXml(ANode: TXmlNodeOld);
var
  i: integer;
  Child: TXmlNodeOld;
begin
  inherited;
  // Effects
  for i := 0 to EffectCount - 1 do
  begin
    Child := ANode.NodeNew('Effect');
    Child.AttributeAdd('Index', IntToStr(i + 1));
    Effects[i].SaveToXml(Child);
  end;
end;

procedure TdtpEffectShape.ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single);
var
  i: integer;
begin
  for i := 0 to EffectCount - 1 do
    Effects[i].ValidateCurbSizes(CurbLeft, CurbTop, CurbRight, CurbBottom);
  // We let the original shape do the last validation
  inherited;
end;

{ TdtpGroupShape }

procedure TdtpGroupShape.Group;
// Join the currently selected shapes in Document into one group
var
  i: integer;
  Shape: TdtpShape;
  Doc: TdtpDocument;
begin
  if not assigned(Document) then exit;
  Doc := TdtpDocument(Document);

  // Add all selected shapes to our list
  for i := Doc.ShapeCount - 1 downto 0 do
  begin
    Shape := Doc.Shapes[i];
    if Shape.Selected and (Shape <> Self) then
      // Extract from doc and add to group
      ShapeInsert(0, Doc.ShapeExtract(Shape));
  end;

  // This will change our bounds to fit just about around the grouped shapes
  FindFittingBounds;
  Selected := True;
end;

procedure TdtpGroupShape.Ungroup;
var
  LeftTop: TdtpPoint;
  Shape: TdtpShape;
  Idx: integer;
begin
  if not (Document is TdtpDocument) then
    exit;
  // Start after our own index with insertion (so the shapes will have
  // the same Z depth when the group shape is finally removed)
  Idx := Index + 1;
  while ShapeCount > 0 do
  begin
    // Process the first shape
    Shape := Shapes[0];
    Shape.AllowSelect := True;
    // Correct this shapes lefttop position
    LeftTop := ShapeToParent(dtpPoint(Shape.DocLeft, Shape.DocTop));
    Shape.DocMove(LeftTop.X, LeftTop.Y);

    // The groups DocAngle must be added to the Shapes DocAngle
    Shape.DocAngle := Shape.DocAngle + DocAngle;

    // Extract from group, add to document
    TdtpDocument(Document).ShapeInsert(Idx, ShapeExtract(Shape));
    Shape.Selected := True;
    inc(Idx);
  end;
end;

initialization

  RegisterShapeClass(TdtpEffectShape);
  RegisterShapeClass(TdtpGroupShape);
  RegisterEffectClass(TdtpEffect, False);

finalization

  FreeAndNil(FEffectClassList);

end.
