{
  Unit dtpMaskEffects

  Mask effects are TdtpEffect descendants that mask out certain parts of the
  cache bitmap (work on the alpha channel).

  Project: DTP-Engine

  Creation Date: 22-08-2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003 - 2006 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpMaskEffects;

{$i simdesign.inc}

interface

uses

  Classes, SysUtils, Contnrs, dtpEffectShape, dtpBitmapResource, NativeXmlOld,
  Windows, dtpGraphics, dtpPolygonShape, Math, Graphics, dtpShape, dtpTransform;

type

  // Mask combination modes - see MaskCombine and TdtpMask.Operation.
  TdtpMaskOperation = (
    moMultiply,   // Result = A * B, this is the default
    moAdd,        // Result = A + B
    moSubstract,  // Result = A - B
    moReplace,    // Result = B
    moMax,        // Result = Max(A, B)
    moMin,        // Result = Min(A, B)
    moDifference, // Result = Abs(A - B)
    moExclusion   // Result = A + B - (A * B) -- this is 1 - (1 - A) * (1 - B)
  );

  TdtpMaskEffect = class;

  // TdtpMask is the ancestor class for all mask types. A mask is an 8-bit grayscale
  // image that will be used to mask off the opaque parts of an image. Everywhere the
  // mask bitmap has value 255, the image will show, everywhere the mask bitmap has
  // value 0, the image will be transparent. All other values will yield semi-transparent
  // images.
  TdtpMask = class(TPersistent)
  private
    FEnabled: boolean;
    FParent: TdtpMaskEffect;
    FFlipAlphaChannel: boolean;
    FOperation: TdtpMaskOperation;
    procedure SetEnabled(const Value: boolean);
    procedure SetParent(const Value: TdtpMaskEffect);
    procedure SetFlipAlphaChannel(const Value: boolean);
    procedure SetOperation(const Value: TdtpMaskOperation);
  protected
    procedure PaintMask(Mask, Background: TdtpBytemap; View: TRect); virtual;
    procedure MaskChanged; virtual;
    procedure ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single); virtual;
  public
    constructor Create; virtual;
    class function MaskName: string;
    procedure AddArchiveResourceNames(Names: TStrings); virtual;
    procedure LoadFromXml(ANode: TXmlNodeOld); virtual;
    procedure SaveToXml(ANode: TXmlNodeOld); virtual;
    property Enabled: boolean read FEnabled write SetEnabled;
    property FlipAlphaChannel: boolean read FFlipAlphaChannel write SetFlipAlphaChannel;
    property Parent: TdtpMaskEffect read FParent write SetParent;
    property Operation: TdtpMaskOperation read FOperation write SetOperation;
  end;

  TdtpMaskClass = class of TdtpMask;

  // TdtpFeatherMask is a TdtpMask descendant that feathers a previous mask it
  // works on. Feathering is a process of blurring the alpha channel, thus creating
  // soft edges. Property Feather controls the amount of feathering.
  TdtpFeatherMask = class(TdtpMask)
  private
    FFeather: single;
    procedure SetFeather(const Value: single);
  protected
    procedure PaintMask(Mask, Background: TdtpBytemap; View: TRect); override;
    procedure ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single); override;
  public
    constructor Create; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    // Feather distance is expressed as fraction of the largest dimension
    property Feather: single read FFeather write SetFeather;
  end;

  TdtpRotationType = (frRotate0, frRotate90, frRotate180, frRotate270, frRotateFree);

  // TdtpPositionMask is a TdtpMask that functions as ancestor for any masks
  // that are positioned relative to the shape's cache.
  TdtpPositionMask = class(TdtpMask)
  private
    FHeight: single;
    FLeft: single;
    FTop: single;
    FWidth: single;
    FRotation: TdtpRotationType;
    procedure SetHeight(const Value: single);
    procedure SetLeft(const Value: single);
    procedure SetTop(const Value: single);
    procedure SetWidth(const Value: single);
    procedure SetRotation(const Value: TdtpRotationType);
  public
    constructor Create; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: single);
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property Left: single read FLeft write SetLeft;
    property Top: single read FTop write SetTop;
    property Width: single read FWidth write SetWidth;
    property Height: single read FHeight write SetHeight;
    property Rotation: TdtpRotationType read FRotation write SetRotation;
  end;

  TdtpBitmapMask = class(TdtpPositionMask)
  private
    FImage: TdtpBitmapResource;
    FOutsideIsTransparent: boolean;
    procedure SetOutsideIsTransparent(const Value: boolean);
    procedure ImageObjectChanged(Sender: TObject);
  protected
    procedure PaintMask(Mask, Background: TdtpBytemap; View: TRect); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddArchiveResourceNames(Names: TStrings); override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property Image: TdtpBitmapResource read FImage;
    property OutsideIsTransparent: boolean read FOutsideIsTransparent write SetOutsideIsTransparent;
  end;

  TdtpPolygonMaskStyle = (
    psUser,
    psGlyps,
    psStretchedGlyphs,
    psShape
  );

  TdtpPolygonMaskShape = (
    msEllipse,
    msRoundRect,
    msStar
  );

  TdtpPolygonMask = class(TdtpPositionMask)
  private
    // The FPts array contains points in range [0..1, 0..1] which represent fractions
    // of the mask position area (Left/Top/Width/Height)
    FPts: ArrayOfArrayOfFPoint;
    FMask: TdtpByteMap; // temp pointer to the current mask (used in paint event)
    FGlyphFontName: string;
    FShape: TdtpPolygonMaskShape;
    FStyle: TdtpPolygonMaskStyle;
    FGlyphFontStyles: TFontStyles;
    FGlyphText: widestring;
    FPolygonChanged: boolean;
    procedure FillPolygon(Dst: PdtpColor; DstX, DstY, Length: Integer; AlphaValues: PdtpColor);
    procedure SetGlyphFontName(const Value: string);
    procedure SetGlyphFontStyles(const Value: TFontStyles);
    procedure SetGlyphText(const Value: widestring);
    procedure SetShape(const Value: TdtpPolygonMaskShape);
    procedure SetStyle(const Value: TdtpPolygonMaskStyle);
  protected
    procedure ClearPolygon; virtual;
    procedure NewLine; virtual;
    procedure Add(X, Y: single); virtual;
    procedure PaintMask(Mask, Background: TdtpBytemap; View: TRect); override;
    procedure UpdatePolygon; virtual;
  public
    constructor Create; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property Style: TdtpPolygonMaskStyle read FStyle write SetStyle;
    property Shape: TdtpPolygonMaskShape read FShape write SetShape;
    property GlyphText: widestring read FGlyphText write SetGlyphText;
    property GlyphFontName: string read FGlyphFontName write SetGlyphFontName;
    property GlyphFontStyles: TFontStyles read FGlyphFontStyles write SetGlyphFontStyles;
  end;

  // TdtpMaskEffect is an effect that will add a mask to a shape. A mask is an 8-bit
  // grayscale image that will be used to mask off the opaque parts of a shape. The
  // actual masking consists of a list of TdtpMask masks that will be called in
  // order of the mask list, each working on the eventual mask bitmap.
  TdtpMaskEffect = class(TdtpEffect)
  private
    FMasks: TObjectList;
    function GetMasks(Index: integer): TdtpMask;
    function GetMaskCount: integer;
  protected
    procedure ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single); override;
    procedure PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddArchiveResourceNames(Names: TStrings); override;
    procedure PaintMasks(AMap: TdtpByteMap; AView: TRect); virtual;
    function MaskAdd(AMask: TdtpMask): integer;
    procedure MaskAddClass(AClass: TdtpMaskClass; Enabled: boolean = True);
    procedure MaskDelete(Index: integer);
    procedure MaskExchange(Idx1, Idx2: integer);
    property MaskCount: integer read GetMaskCount;
    property Masks[Index: integer]: TdtpMask read GetMasks;
    procedure FlattenMasks; virtual;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
  end;

resourcestring
  smeMapsMustBeAssigned  = 'Maps must be assigned';
  smeMapsMustBeEqualSize = 'Maps must be equal size';
  smeIllegalMapIndex     = 'Illegal map index';

// Mask combine operations: Maps A and B are combined into map R. Maps A and B
// must have identical size. Map R will be made same size as A and B. Map R may
// be one of A and B.
procedure MaskCombine(const A, B, R: TdtpByteMap; Operation: TdtpMaskOperation);

// Scale the polygon so it lies in [0..1, 0..1]
procedure UnifyPolygon(const Points: ArrayOfArrayOfFPoint);

function RetrieveMaskClass(const AClassName: string): TdtpMaskClass;

procedure RegisterMaskClass(AClass: TdtpMaskClass; IsPublished: boolean = True);

procedure GetAvailableMaskNames(AList: TStringList);

implementation

uses
  dtpUtil;

procedure MaskCombine(const A, B, R: TdtpByteMap; Operation: TdtpMaskOperation);
var
  PA, PB, PR: PByte;
  i, Size: integer;
begin
  if not (assigned(A) and assigned(B) and assigned(R)) then
    raise Exception.Create(smeMapsMustBeAssigned);
  if (A.Width <> B.Width) or (A.Height <> B.Height) then
    raise Exception.Create(smeMapsMustBeEqualSize);
  R.SetSize(A.Width, A.Height);
  if A.Empty then
    exit;
  PA := A.ValPtr[0, 0];
  PB := B.ValPtr[0, 0];
  PR := R.ValPtr[0, 0];
  Size := A.Width * A.Height;
  case Operation of
  moAdd:
    for i := 0 to Size - 1 do
    begin
      PR^ := Min(255, PA^ + PB^);
      inc(PA);
      inc(PB);
      inc(PR);
    end;
  moSubstract:
    for i := 0 to Size - 1 do
    begin
      PR^ := Max(0, PA^ - PB^);
      inc(PA);
      inc(PB);
      inc(PR);
    end;
  moMultiply:
    for i := 0 to Size - 1 do
    begin
      if PA^ = 0 then
        PR^ := 0
      else if PB^ = 0 then
        PR^ := 0
      else if PA^ = 255 then
        PR^ := PB^
      else if PB^ = 255 then
        PR^ := PA^
      else
        PR^ := PA^ * PB^ div 255;
      inc(PA);
      inc(PB);
      inc(PR);
    end;
  moReplace:
    Move(PB^, PR^, Size);
  moMax:
    for i := 0 to Size - 1 do
    begin
      PR^ := Max(PA^, PB^);
      inc(PA);
      inc(PB);
      inc(PR);
    end;
  moMin:
    for i := 0 to Size - 1 do
    begin
      PR^ := Min(PA^, PB^);
      inc(PA);
      inc(PB);
      inc(PR);
    end;
  moDifference:
    for i := 0 to Size - 1 do
    begin
      PR^ := abs(PA^ - PB^);
      inc(PA);
      inc(PB);
      inc(PR);
    end;
  moExclusion:
    for i := 0 to Size - 1 do
    begin
      if PA^ = 255 then
        PR^ := 255
      else if PB^ = 255 then
        PR^ := 255
      else if PA^ = 0 then
        PR^ := PB^
      else if PB^ = 0 then
        PR^ := PA^
      else
        PR^ := ((PA^ xor $FF) * (PB^ xor $FF) div 255) xor $FF;
      inc(PA);
      inc(PB);
      inc(PR);
    end;
  end;//case
end;

procedure UnifyPolygon(const Points: ArrayOfArrayOfFPoint);
var
  i, j: integer;
  First: boolean;
  XMin, XMax, YMin, YMax, XWidth, YWidth: single;
begin
  First := True;
  XMin := 0; // Avoid compiler warning
  XMax := 0;
  YMin := 0;
  YMax := 0;
  for i := 0 to high(Points) do
  begin
    for j := 0 to high(Points[i]) do
    begin
      if First then
      begin
        XMin := Points[i][j].X;
        XMax := Points[i][j].X;
        YMin := Points[i][j].Y;
        YMax := Points[i][j].Y;
        First := False;
      end else
      begin
        XMin := Min(XMin, Points[i][j].X);
        XMax := Max(XMax, Points[i][j].X);
        YMin := Min(YMin, Points[i][j].Y);
        YMax := Max(YMax, Points[i][j].Y);
      end;
    end;
  end;
  XWidth := XMax - XMin;
  YWidth := YMax - YMin;
  if XWidth = 0 then
    XWidth := 1;
  if YWidth = 0 then
    YWidth := 1;
  for i := 0 to high(Points) do
    for j := 0 to high(Points[i]) do
    begin
      Points[i][j].X := (Points[i][j].X - XMin) / XWidth;
      Points[i][j].Y := (Points[i][j].Y - YMin) / YWidth;
    end;
end;

procedure LoadFontStyle(ANode: TXmlNodeOld; var Style: TFontStyles);
begin
  Style := [];
  if not assigned(ANode) then
    exit;
  if ANode.ReadBool('Bold', False) then
    Style := Style + [fsBold];
  if ANode.ReadBool('Italic', False) then
    Style := Style + [fsItalic];
  if ANode.ReadBool('Underline', False) then
    Style := Style + [fsUnderline];
  if ANode.ReadBool('Strikeout', False) then
    Style := Style + [fsStrikeout];
end;

procedure SaveFontStyle(ANode: TXmlNodeOld; const Style: TFontStyles);
begin
  ANode.WriteBool('Bold', fsBold in Style);
  ANode.WriteBool('Italic', fsItalic in Style);
  ANode.WriteBool('Underline', fsUnderline in Style);
  ANode.WriteBool('Strikeout', fsStrikeout in Style);
end;

type
  TMaskClassHolder = class
  public
    FClass: TdtpMaskClass;
    FClassName: string;
    FIsPublished: boolean;
  end;

var
  FMaskClassList: TObjectList = nil;

function RetrieveMaskClass(const AClassName: string): TdtpMaskClass;
var
  i: integer;
begin
  Result := TdtpMask;
  if assigned(FMaskClassList) then
    with FMaskClassList do
    begin
      for i := 0 to Count - 1 do
        if TMaskClassHolder(Items[i]).FClassName = AClassName then
        begin
          Result := TMaskClassHolder(Items[i]).FClass;
          exit;
        end;
    end;
end;

procedure RegisterMaskClass(AClass: TdtpMaskClass; IsPublished: boolean = True);
// Register currently unknown mask classes
var
  i: integer;
  ANewClass: TMaskClassHolder;
begin
  if not assigned(FMaskClassList) then
    FMaskClassList := TObjectList.Create;
  // Unique?
  with FMaskClassList do
  begin
    for i := 0 to Count - 1 do
      if AClass = TMaskClassHolder(Items[i]).FClass then
        exit;
    // Add new class
    ANewClass := TMaskClassHolder.Create;
    ANewClass.FClass := AClass;
    ANewClass.FClassName := AClass.ClassName;
    ANewClass.FIsPublished := IsPublished;
    Add(ANewClass);
  end;
end;

procedure GetAvailableMaskNames(AList: TStringList);
var
  i: integer;
begin
  if not assigned(AList) then
    exit;
  AList.Clear;

  if not assigned(FMaskClassList) then
    exit;
  with FMaskClassList do
    for i := 0 to Count - 1 do
      with TMaskClassHolder(Items[i]) do
        if FIsPublished then
          AList.AddObject(FClass.MaskName, TObject(FClass));

end;

{ TdtpMaskEffect }

procedure TdtpMaskEffect.AddArchiveResourceNames(Names: TStrings);
var
  i: integer;
begin
  inherited;
  for i := 0 to MaskCount - 1 do
    Masks[i].AddArchiveResourceNames(Names);
end;

constructor TdtpMaskEffect.Create;
begin
  inherited;
  FMasks := TObjectList.Create;
end;

destructor TdtpMaskEffect.Destroy;
begin
  FreeAndNil(FMasks);
  inherited;
end;

procedure TdtpMaskEffect.FlattenMasks;
begin
// to do
end;

function TdtpMaskEffect.GetMaskCount: integer;
begin
  if assigned(FMasks) then
    Result := FMasks.Count
  else
    Result := 0;
end;

function TdtpMaskEffect.GetMasks(Index: integer): TdtpMask;
begin
  if (Index >= 0) and (Index < MaskCount) then
    Result := TdtpMask(FMasks[Index])
  else
    Result := nil;
end;

procedure TdtpMaskEffect.LoadFromXml(ANode: TXmlNodeOld);
var
  i: integer;
  AList: TList;
  AChild: TXmlNodeOld;
  AMaskClass: TdtpMaskClass;
  AMask: TdtpMask;
begin
  inherited;
  FMasks.Clear;
  // Load masks
  AList := TList.Create;
  try
    ANode.NodesByName('Mask', AList);
    for i := 0 to AList.Count - 1 do
    begin
      AChild := AList[i];
      AMaskClass := RetrieveMaskClass(string(AChild.ReadString('ClassName')));
      AMask := AMaskClass.Create;
      MaskAdd(AMask);
      AMask.LoadFromXml(AChild);
    end;
  finally
    AList.Free;
  end;
end;

function TdtpMaskEffect.MaskAdd(AMask: TdtpMask): integer;
begin
  Result := -1;
  if assigned(AMask) and assigned(FMasks) then
  begin
    // Invalidate shape
    Invalidate;
    Result := FMasks.Add(AMask);
    AMask.Parent := Self;
    // Refresh the cache
    Refresh;
    // Properties changed.. new mask added
    Changed;
  end;
end;

procedure TdtpMaskEffect.MaskAddClass(AClass: TdtpMaskClass;
  Enabled: boolean);
// Add the mask with class AClass
var
  AMask: TdtpMask;
begin
  if not assigned(AClass) then
    exit;
  AMask := AClass.Create;
  AMask.Enabled := Enabled;
  MaskAdd(AMask);
end;

procedure TdtpMaskEffect.MaskDelete(Index: integer);
begin
  if (Index >= 0) and (Index < MaskCount) then
  begin
    // Before removing, first invalidate
    Invalidate;
    // Now delete
    FMasks.Delete(Index);
    // Refresh the cache (and this also checks curbs and invalidates the new shape size)
    Refresh;
    // Properties changed.. new effect added
    Changed;
  end;
end;

procedure TdtpMaskEffect.MaskExchange(Idx1, Idx2: integer);
begin
  // Check for errors
  if (Idx1 = Idx2) or (Idx1 < 0) or (Idx2 < 0) or
     (Idx1 >= MaskCount) or (Idx2 >= MaskCount) then
    exit;
  // Invalidate our rect first
  Invalidate;
  // Exchange the effects
  FMasks.Exchange(Idx1, Idx2);
  // Update
  Refresh;
  Changed;
end;

procedure TdtpMaskEffect.PaintEffect(DIB: TdtpBitmap; const Device: TDeviceContext);
var
  LT, RB: TdtpPoint;
  View: TRect;
  Map: TdtpByteMap;
begin
  if not assigned(Parent) then
    exit;
  with Parent do
  begin
    LT := ShapeToFloat(dtpPoint(0, 0));
    RB := ShapeToFloat(dtpPoint(DocWidth, DocHeight));
  end;
  Map := TdtpByteMap.Create;
  try
    // Copy alpha channel to map
    dtpReadFromMap(Map, DIB, dtpctAlpha);
    // Viewport of the shape (the shape rectangle excluding any effects)
    View.Left   := round(LT.X);
    View.Top    := round(LT.Y);
    View.Right  := round(RB.X);
    View.Bottom := round(RB.Y);
    // Paint the masks in turn
    PaintMasks(Map, View);
    // Copy alpha channel back to DIB
    dtpWriteToMap(Map, DIB, dtpctAlpha);
  finally
    Map.Free;
  end;
end;

procedure TdtpMaskEffect.PaintMasks(AMap: TdtpByteMap; AView: TRect);
var
  i: integer;
  MaskMap: TdtpByteMap;
begin
  MaskMap := TdtpByteMap.Create;
  try
    MaskMap.SetSize(AMap.Width, AMap.Height);
    for i := 0 to MaskCount - 1 do
      if Masks[i].Enabled then
      begin
        MaskMap.Clear(0);
        Masks[i].PaintMask(MaskMap, AMap, AView);
        // combine maps
        MaskCombine(AMap, MaskMap, AMap, Masks[i].Operation);
      end;
  finally
    MaskMap.Free;
  end;
end;

procedure TdtpMaskEffect.SaveToXml(ANode: TXmlNodeOld);
var
  i: integer;
  AChild: TXmlNodeOld;
begin
  inherited;
  // Masks
  for i := 0 to MaskCount - 1 do
  begin
    AChild := ANode.NodeNew('Mask');
    AChild.AttributeAdd('Index', IntToStr(i + 1));
    Masks[i].SaveToXml(AChild);
  end;
end;

procedure TdtpMaskEffect.ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single);
var
  i: integer;
begin
  inherited;
  for i := 0 to MaskCount - 1 do
    Masks[i].ValidateCurbSizes(CurbLeft, CurbTop, CurbRight, CurbBottom);
end;

{ TdtpMask }

procedure TdtpMask.AddArchiveResourceNames(Names: TStrings);
begin
// default does nothing
end;

constructor TdtpMask.Create;
begin
  inherited Create;
  FEnabled := True;
end;

procedure TdtpMask.LoadFromXml(ANode: TXmlNodeOld);
begin
  FEnabled          := ANode.ReadBool('Enabled');
  FFlipAlphaChannel := ANode.ReadBool('FlipAlphaChannel');
  FOperation := TdtpMaskOperation(ANode.ReadInteger('Operation'));
end;

procedure TdtpMask.MaskChanged;
begin
  // The mask's properties changed, so we must refresh the parent and call changed
  if assigned(Parent) then
  begin
    Parent.Changed;
  end;
end;

class function TdtpMask.MaskName: string;
begin
  Result := copy(ClassName, 5, Length(ClassName));
end;

procedure TdtpMask.PaintMask(Mask, Background: TdtpBytemap; View: TRect);
var
  i: integer;
  P: PByte;
begin
  // Default only flips alpha channel if selected. It should be done *after*
  // the other paint operations are done
  if Mask.Empty then
    exit;

  if FlipAlphaChannel then
  begin

    P := @Mask.Bits[0];

    for i := 0 to Mask.Width * Mask.Height - 1 do
    begin
      P^ := P^ XOR $FF;
      inc(P);
    end;
  end;
end;

procedure TdtpMask.SaveToXml(ANode: TXmlNodeOld);
begin
  // Save our class name first
  ANode.WriteString('ClassName', UTF8String(ClassName));
  ANode.WriteBool('Enabled', FEnabled);
  ANode.WriteBool('FlipAlphaChannel', FFlipAlphaChannel);
  ANode.WriteInteger('Operation', integer(FOperation));
end;

procedure TdtpMask.SetEnabled(const Value: boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    MaskChanged;
  end;
end;

procedure TdtpMask.SetFlipAlphaChannel(const Value: boolean);
begin
  if FFlipAlphaChannel <> Value then
  begin
    FFlipAlphaChannel := Value;
    MaskChanged;
  end;
end;

procedure TdtpMask.SetOperation(const Value: TdtpMaskOperation);
begin
  if FOperation <> Value then
  begin
    FOperation := Value;
    MaskChanged;
  end;
end;

procedure TdtpMask.SetParent(const Value: TdtpMaskEffect);
begin
  FParent := Value;
end;

procedure TdtpMask.ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight,
  CurbBottom: single);
begin
// does nothing
end;

{ TdtpFeatherMask }

constructor TdtpFeatherMask.Create;
begin
  inherited;
  FFeather := 0.01;
  FOperation := moReplace;
end;

procedure TdtpFeatherMask.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FFeather := ANode.ReadFloat('Feather');
end;

procedure TdtpFeatherMask.PaintMask(Mask, Background: TdtpBytemap; View: TRect);
var
  Dib: TdtpBitmap;
  Scale: single;
  P: PByte;
  i: integer;
  LUT: array[byte] of byte;
begin
  // We make a feather bitmap
  Dib := TdtpBitmap.Create;
  try
    // Dib takes the background mask
    dtpWriteToMap(Background, Dib, dtpctAlpha);

    // We now do a blur on it
    AlphaShr16Intensity(Dib, 1.0);

    // Blur with feather.. use special recursive (FAST) method
    Scale := Max(View.Right - View.Left, View.Bottom - View.Top);
    dtpUtil.Feather(Dib, FFeather * Scale);

    // Add color, shift back Alpha
    AlphaShl16Color(Dib, 0);

    // And result in mask
    dtpReadFromMap(Mask, Dib, dtpctAlpha);
    for i := 0 to 255 do
      LUT[i] := max(0, round(((i / 255) - 0.5) * 2 * 255));
    P := Mask.ValPtr[0, 0];
    for i := 0 to Mask.Width * Mask.Height - 1 do
    begin
      P^ := LUT[P^];
      inc(P);
    end;
  finally
    Dib.Free;
  end;
  inherited;
end;

procedure TdtpFeatherMask.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteFloat('Feather', FFeather);
end;

procedure TdtpFeatherMask.SetFeather(const Value: single);
begin
  if FFeather <> Value then
  begin
    FFeather := Value;
    MaskChanged;
  end;
end;

procedure TdtpFeatherMask.ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single);
var
  Increase: single;
begin
  // Find scale
  with Parent.Parent do
    Increase := Max(DocWidth, DocHeight) * FFeather * 1.5;
  CurbLeft := CurbLeft + Increase;
  CurbRight := CurbRight + Increase;
  CurbTop := CurbTop + Increase;
  CurbBottom := CurbBottom + Increase;
end;

{ TdtpPositionMask }

constructor TdtpPositionMask.Create;
begin
  inherited;
  // Defaults
  FLeft   := 0;
  FTop    := 0;
  FWidth  := 1;
  FHeight := 1;
  FRotation := frRotate0;
end;

procedure TdtpPositionMask.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FHeight := ANode.ReadFloat('Height', 1);
  FLeft   := ANode.ReadFloat('Left');
  FTop    := ANode.ReadFloat('Top');
  FWidth  := ANode.ReadFloat('Width', 1);
  FRotation := TdtpRotationType(ANode.ReadInteger('Rotation'));
end;

procedure TdtpPositionMask.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteFloat('Height', FHeight, 1);
  ANode.WriteFloat('Left', FLeft);
  ANode.WriteFloat('Top', FTop);
  ANode.WriteFloat('Width', FWidth, 1);
  ANode.WriteInteger('Rotation', integer(FRotation));
end;

procedure TdtpPositionMask.SetBounds(ALeft, ATop, AWidth, AHeight: single);
begin
  if (FLeft <> ALeft) or (FTop <> ATop) or (FWidth <> AWidth) or (FHeight <> AHeight) then
  begin
    FLeft   := ALeft;
    FTop    := ATop;
    FWidth  := AWidth;
    FHeight := AHeight;
    MaskChanged;
  end;
end;

procedure TdtpPositionMask.SetHeight(const Value: single);
begin
  if FHeight <> Value then
  begin
    FHeight := Value;
    MaskChanged;
  end;
end;

procedure TdtpPositionMask.SetLeft(const Value: single);
begin
  if FLeft <> Value then
  begin
    FLeft := Value;
    MaskChanged;
  end;
end;

procedure TdtpPositionMask.SetRotation(const Value: TdtpRotationType);
begin
  if FRotation <> Value then
  begin
    FRotation := Value;
    MaskChanged;
  end;
end;

procedure TdtpPositionMask.SetTop(const Value: single);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    MaskChanged;
  end;
end;

procedure TdtpPositionMask.SetWidth(const Value: single);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    MaskChanged;
  end;
end;

{ TdtpBitmapMask }

procedure TdtpBitmapMask.AddArchiveResourceNames(Names: TStrings);
begin
  inherited;
  FImage.AddArchiveResourceNames(Names);
end;

constructor TdtpBitmapMask.Create;
begin
  inherited;
  FImage := TdtpBitmapResource.Create;
  FImage.OnObjectChanged := ImageObjectChanged;
end;

destructor TdtpBitmapMask.Destroy;
begin
  FreeAndNil(FImage);
  inherited;
end;

procedure TdtpBitmapMask.ImageObjectChanged(Sender: TObject);
begin
  MaskChanged;
end;

procedure TdtpBitmapMask.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FOutsideIsTransparent := ANode.ReadBool('OutsideIsTransparent');
  // Load resource
  FImage.LoadFromXml(ANode.NodeByName('Image'));
end;

procedure TdtpBitmapMask.PaintMask(Mask, Background: TdtpBytemap; View: TRect);
var
  i: integer;
  Source, Dest: TdtpBitmap;
  VWidth, VHeight: integer;
  DRect: TRect;
  PB: PByte;
  PC: PdtpColor;
  Color: TdtpColor;
begin
  Source := TdtpBitmap.Create;
  Dest := TdtpBitmap.Create;
  try
    // Load source
    Source.Assign(Image.Bitmap);
    if Source.Empty then
      exit;

    // Rotate it
    case Rotation of
    frRotate0:; // nothing to do
    frRotate90:  DIBRotate90(Source);
    frRotate180: DIBRotate180(Source);
    frRotate270: DIBRotate270(Source);
    frRotateFree:; // not implemented yet
    end;//case

    // Destination bitmap. From performance persp this would be better as a bytemap
    // but then a new class must be written.
    Dest.SetSize(Mask.Width, Mask.Height);

    // Clear destination bitmap with correct color
    if FOutsideIsTransparent then
      Dest.Clear(clWhite32)
    else
      Dest.Clear(clBlack32);

    // Setup dest rectangles
    VWidth  := View.Right - View.Left;
    VHeight := View.Bottom - View.Top;
    DRect.Left   := round(View.Left + VWidth  * FLeft);
    DRect.Top    := round(View.Top  + VHeight * FTop);
    DRect.Right  := round(View.Left + VWidth  * FWidth);
    DRect.Bottom := round(View.Top  + VHeight * FHeight);

    // Stretch it to required size.
    SetStretchFilter(Dest, dtpsfLinear);
    dtpGraphics.StretchTransfer(Dest, DRect, Dest.BoundsRect, Source, Source.BoundsRect,
      Dest.Resampler, dtpdmOpaque, nil);

    // Combine into final map
    PB := @Mask.Bits[0];
    PC := @Dest.Bits[0];
    for i := 0 to Mask.Width * Mask.Height - 1 do
    begin
      Color := PC^ and $00FFFFFF;
      if Color = 0 then
        PB^ := 0
      else if Color = $FFFFFF then
        PB^ := $FF
      else
        PB^ := (Color shr 16 + (Color and $0000FF00) shr 8 + (Color and $000000FF)) div 3;
      inc(PB);
      inc(PC);
    end;

  finally
    Source.Free;
    Dest.Free;
    // Call this last - the ancestor might want to flip the alpha channel
    inherited;
  end;
end;

procedure TdtpBitmapMask.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteBool('OutsideIsTransparent', FOutsideIsTransparent);
  // Save resource
  FImage.SaveToXml(ANode.NodeNew('Image'));
end;

procedure TdtpBitmapMask.SetOutsideIsTransparent(const Value: boolean);
begin
  if FOutsideIsTransparent <> Value then
  begin
    FOutsideIsTransparent := Value;
    MaskChanged;
  end;
end;

{ TdtpPolygonMask }

procedure TdtpPolygonMask.Add(X, Y: single);
var
  H, L: integer;
begin
  if length(FPts) = 0 then
    NewLine;
  H := High(FPts);
  L := Length(FPts[H]);
  SetLength(FPts[H], L + 1);
  FPts[H][L] := dtpPoint(X, Y);
end;

procedure TdtpPolygonMask.ClearPolygon;
begin
  FPts := nil;
end;

constructor TdtpPolygonMask.Create;
begin
  inherited;
  // Test
  FPolygonChanged := True;
  FStyle := psShape;
end;

procedure TdtpPolygonMask.FillPolygon(Dst: PdtpColor; DstX, DstY,
  Length: Integer; AlphaValues: PdtpColor);
var
  X, i: integer;
begin
  for i := 0 to Length - 1 do
  begin
    X := DstX + i;
    if (X < 0) or (X >= FMask.Width) or (DstY < 0) or (DstY >= FMask.Height) then
      exit;
    FMask[X, DstY] := AlphaValues^ and $FF;
    inc(AlphaValues);
  end;
end;

procedure TdtpPolygonMask.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FGlyphFontName := string(ANode.ReadString('GlyphFontName'));
  FShape := TdtpPolygonMaskShape(ANode.ReadInteger('Shape'));
  FStyle := TdtpPolygonMaskStyle(ANode.ReadInteger('Style'));
  LoadFontStyle(ANode.NodeByName('GlyphFontStyle'), FGlyphFontStyles);
  FGlyphText := sdUtf8ToUnicode(ANode.ReadString('GlyphText'));
  FPolygonChanged := True;
end;

procedure TdtpPolygonMask.NewLine;
var
  L: integer;
begin
  L := length(FPts);
  SetLength(FPts, L + 1);
  FPts[L] := nil;
end;

procedure TdtpPolygonMask.PaintMask(Mask, Background: TdtpBytemap; View: TRect);
var
  Poly, Dummy: TdtpPolygon;
  Matrix: TdtpMatrix;
  Dib: TdtpBitmap;
  VWidth, VHeight: integer;
begin
  // Check polygon
  if FPolygonChanged then
  begin
    UpdatePolygon;
    FPolygonChanged := False;
  end;
  // Start by creating the transform
  Poly := nil;
  // We need to have a Bitmap32, the Poly.DrawFill requires it. It would be
  // good if Graphics32 would provide a method without it. This bitmap here is created
  // only for this purpose and destroyed directly after finally.
  Dib := TdtpBitmap.Create;
  try
    Dib.SetSize(Mask.Width, Mask.Height);
    Matrix := cIdentityMatrix;
    VWidth := View.Right - View.Left;
    VHeight := View.Bottom - View.Top;
    Matrix.A := FWidth * VWidth;
    Matrix.D := FHeight * VHeight;
    Matrix.E := FLeft * VWidth + View.Left;
    Matrix.F := FTop * VHeight + View.Top;

    // Convert to G32 TPolygon32
    try
      FloatToFixedPolygons(FPts, Matrix, Poly, Dummy, False, True, 0);

      // Paint TPolygon32 with callback (Graphics32)
      FMask := Mask;
      dtpDrawFill(Poly, Dib, FillPolygon);

    finally
      Poly.Free;
      Dummy.Free;
    end;
  finally
    Dib.Free;
    Poly.Free;
  end;
  inherited;
end;

procedure TdtpPolygonMask.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteString('GlyphFontName', UTF8String(FGlyphFontName));
  ANode.WriteInteger('Shape', integer(FShape));
  ANode.WriteInteger('Style', integer(FStyle));
  if FGlyphFontStyles <> [] then
    SaveFontStyle(ANode.NodeNew('GlyphFontStyle'), FGlyphFontStyles);
  ANode.WriteString('GlyphText', sdUnicodeToUtf8(FGlyphText));
end;

procedure TdtpPolygonMask.SetGlyphFontName(const Value: string);
begin
  if FGlyphFontName <> Value then
  begin
    FGlyphFontName := Value;
    FPolygonChanged := True;
    MaskChanged;
  end;
end;

procedure TdtpPolygonMask.SetGlyphFontStyles(const Value: TFontStyles);
begin
  if FGlyphFontStyles <> Value then
  begin
    FGlyphFontStyles := Value;
    FPolygonChanged := True;
    MaskChanged;
  end;
end;

procedure TdtpPolygonMask.SetGlyphText(const Value: widestring);
begin
  if FGlyphText <> Value then
  begin
    FGlyphText := Value;
    FPolygonChanged := True;
    MaskChanged;
  end;
end;

procedure TdtpPolygonMask.SetShape(const Value: TdtpPolygonMaskShape);
begin
  if FShape <> Value then
  begin
    FShape := Value;
    FPolygonChanged := True;
    MaskChanged;
  end;
end;

procedure TdtpPolygonMask.SetStyle(const Value: TdtpPolygonMaskStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    FPolygonChanged := True;
    MaskChanged;
  end;
end;

procedure TdtpPolygonMask.UpdatePolygon;
var
  i, ADiv: integer;
  Quads: ArrayOfFPoint;
  A: single;
begin
  // user-defined: we don't touch it
  if FStyle = psUser then
    exit;
  ClearPolygon;
  case FStyle of
  psGlyps:;
  psStretchedGlyphs:;
  psShape:
    begin
      case FShape of
      msEllipse:
        // Draw an ellipse
        begin
          // Length along the curve (for a circle.. take worst case for ellipse)
          QuadrantPoints(100, Quads, ADiv);
          // Prepare
          for i := 0 to ADiv do
          begin
            Quads[i].X := Quads[i].X * 0.5;
            Quads[i].Y := Quads[i].Y * 0.5;
          end;
          // 1st quadrant
          for i := 0 to ADiv - 1 do
            Add(Quads[i].X + 0.5, Quads[i].Y + 0.5);
          // 2nd quadrant
          for i := ADiv downto 1 do
            Add(-Quads[i].X + 0.5, Quads[i].Y + 0.5);
          // 3rd quadrant
          for i := 0 to ADiv - 1 do
            Add(-Quads[i].X + 0.5, -Quads[i].Y + 0.5);
          // 4th quadrant
          for i := ADiv downto 1 do
            Add(Quads[i].X + 0.5, -Quads[i].Y + 0.5);
        end;
      msRoundRect:
        // Draw a rounded rect
        begin
          // Pass longest side length (for a circle these are equal.. take worst case for ellipse)
          QuadrantPoints(100, Quads, ADiv);
          // Calculate the rounded corner points
          for i := 0 to ADiv do
          begin
            Quads[i].X := (1 - Quads[i].X) * 0.2;
            Quads[i].Y := (1 - Quads[i].Y) * 0.2;
          end;
          // Build total circumference.. start at lefttop
          for i := 0 to ADiv do
            Add(Quads[i].X, Quads[i].Y);
          for i := ADiv downto 0 do
            Add(1 - Quads[i].X, Quads[i].Y);
          for i := 0 to ADiv do
            Add(1 - Quads[i].X, 1 - Quads[i].Y);
          for i := ADiv downto 0 do
            Add(Quads[i].X, 1 - Quads[i].Y);
        end;
      msStar:
        // Draw a pentagon
        begin
          for i := 0 to 4 do
          begin
            A := 2 * pi * i / 5 - 0.5 * pi;
            Add(cos(A), Sin(A));
            A := A + 2 * pi / 10;
            Add(cos(A) * 0.39, Sin(A) *  0.39);
          end;
          UnifyPolygon(FPts);
        end;
      end;
    end;
  end;
end;

initialization

  RegisterEffectClass(TdtpMaskEffect);
  RegisterMaskClass(TdtpMask, False);
  RegisterMaskClass(TdtpFeatherMask);
  RegisterMaskClass(TdtpBitmapMask);
  RegisterMaskClass(TdtpPolygonMask);

finalization

  FreeAndNil(FMaskClassList);

end.
