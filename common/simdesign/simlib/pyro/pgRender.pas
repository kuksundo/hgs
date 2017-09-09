{ Project: Pyro
  Module: Pyro Edit

  Description:
    This unit contains TpgEditRenderer, a class that deals with hittesting and
    selection of shapes in a scene editor, as well as rendering related
    to selections and hovering.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV

  Modified:
  19may2011: string > Utf8String
}
unit pgRender;

interface

uses
  SysUtils, Controls, Classes, Contnrs,
  // pyro
  pgTransform, pgCanvas, pgRenderUsingCore, pgPath, pgContentProvider, pgColor,
  pgDocument, pgScene, Pyro;

type

  TpgHitTestInfo = record
    HitCursor: TCursor;  // Type of cursor for place where hit
    Graphic: TpgGraphic; // Graphic (shape, text, etc) that was hit at location
    GPoint: TpgPoint;    // Point in graphic's coordinates where hit
  end;

  // fwd declaration
  TpgRenderer = class;

  // Synced item that contains additional bounds info
  TpgBoundsItem = class(TPersistent)//(TpgSyncItem)
  private
    FBoundsValid: boolean;  // the bounds are valid (calculated)
    FHasBounds: boolean;    // this element doesn't have bounds (e.g. group with no members)
    FTightBB: TpgBox;       // Tight bounding box (fits just around the shape's path)
    FLooseBB: TpgBox;       // Loose bounding box (encompasses stroke and effects too)
    function GetItem: TpgItem;
  protected
    procedure Invalidate; virtual;
    procedure InvalidateBounds; virtual;
    property Item: TpgItem read GetItem;
  public
    procedure UpdateBounds(ACanvas: TpgCanvas; ARenderer: TpgRenderer);
    property BoundsValid: boolean read FBoundsValid;
    property LooseBB: TpgBox read FLooseBB;
  end;

  // Contains info about selected items
  TpgSelectInfo = class(TPersistent)
  end;

  // Bounds item that contains additional info about selection
  TpgSelectItem = class(TpgBoundsItem)
  private
    FInfo: TpgSelectInfo;
  protected
    function PreventDrop: boolean; virtual;
  public
    destructor Destroy; override;
  end;

  TpgRenderer = class(TpgCoreRenderer)
  private
    //FSyncList: TpgSyncList; // owned sync list for bounding boxes
  protected
    function HitTestGraphic(ACanvas: TpgCanvas; AGraphic: TpgGraphic; const Pparent: TpgPoint;
      var Pgraphic: TpgPoint; Scale: single): TpgGraphic;
    function HitTestShape(ACanvas: TpgCanvas; AShape: TpgShape; const Pp: TpgPoint; Scale: single): TpgGraphic;
    procedure RenderGraphic(ACanvas: TpgCanvas; AGraphic: TpgGraphic); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure SetScene(AScene: TpgScene); override;
    function LocalTightBB(ACanvas: TpgCanvas; AGraphic: TpgGraphic; var IsEmpty: boolean): TpgBox;
    function LooseFromTightBB(ACanvas: TpgCanvas; const ABox: TpgBox; AGraphic: TpgGraphic): TpgBox;
    procedure PlayHoverPath(ACanvas: TpgCanvas; AGraphic: TpgGraphic; APath: TpgPath);
    // Returns the transform list from AGraphic towards device. ATransform
    // must contain the transform from content to device.
    function GetTransformListForGraphic(ACanvas: TpgCanvas; AGraphic: TpgGraphic;
      ATransform: TpgTransform; AScratch: TObjectList): TpgTransformList;
    // Returns the element closest under the given position in screen coordinates. AGraphic is the
    // root graphic from which to check (usually a viewport) and ATransform describes the transform
    // from document to screen. Result = true if something was hit, HitTestInfo contains result
    function HitTest(ACanvas: TpgCanvas; AGraphic: TpgGraphic; ATransform: TpgTransform;
      const AMouse: TpgMouseInfo; var AHitTestInfo: TpgHitTestInfo): boolean; virtual;
    // Render a hover element
    procedure RenderHover(ACanvas: TpgCanvas; AGraphic: TpgGraphic; ATransform: TpgTransform); virtual;
    // Render a temp polyline during insert command
    procedure RenderInsertPoly(ACanvas: TpgCanvas; First: PpgPoint; Count: integer; ATransform: TpgTransform); virtual;
    // A list containing sync items with scene
    //property SyncList: TpgSyncList read FSyncList write FSyncList;
  end;

implementation

type
  TShapeAccess = class(TpgShape);

{ TpgBoundsItem }

function TpgBoundsItem.GetItem: TpgItem;
begin
//todo
  Result := nil;
end;

procedure TpgBoundsItem.Invalidate;
begin
  InvalidateBounds;
end;

procedure TpgBoundsItem.InvalidateBounds;
var
  P: TpgItem;
  Item: TpgBoundsItem;
begin
  if FBoundsValid then
  begin
    FBoundsValid := False;
    // We must also invalidate the bounds of any parent that is not a viewport,
    // since its bounds may also no longer be valid (they enclose ours)
    P := nil; //todo Element.Parent;
    if assigned(P) and not (P is TpgViewPort) then
    begin
      Item := nil; //todo TpgBoundsItem(Owner.ById(P.Id));
      if assigned(Item) then
        Item.Invalidate;
    end;
  end;
end;

procedure TpgBoundsItem.UpdateBounds(ACanvas: TpgCanvas; ARenderer: TpgRenderer);
var
//  i: integer;
  //List: TpgSyncChildList;
//  Child: TpgBoundsItem;
  Graphic: TpgGraphic;
//  Transform: TpgTransform;
  L, S: TpgBox;
  Empty: boolean;

  // local
  procedure CombineBounds;
  begin
    if not FHasBounds then
    begin
      FLooseBB := L;
      FTightBB := S;
      FHasBounds := True;
    end else
    begin
      FLooseBB := pgUnionBox(L, FLooseBB);
      FTightBB := pgUnionBox(S, FTightBB);
    end;
  end;

// main
begin
  if not FBoundsValid then
  begin
    FHasBounds := False;
    Graphic := TpgGraphic(Item);
    if not (Graphic is TpgViewPort) then
    begin

      {todo // Get child list
      List := GetChildList;
      try

        // Update all children
        for i := 0 to List.Count - 1 do
        begin
          Child := TpgBoundsItem(List[i]);
          Child.UpdateBounds(ACanvas, ARenderer);
          if Child.FHasBounds then
          begin
            Transform := TpgGraphic(Child.Element).Transform.TransformValue;
            L := TransformBox(Child.FLooseBB, Transform);
            S := TransformBox(Child.FTightBB, Transform);
            CombineBounds;
          end;
        end;
      finally
        List.Free;
      end;}

    end;

    // Get graphic element's bounding box
    S := ARenderer.LocalTightBB(ACanvas, Graphic, Empty);
    if not Empty then
    begin
      L := ARenderer.LooseFromTightBB(ACanvas, S, Graphic);
      CombineBounds;
    end;
    FBoundsValid := True;
  end;
end;

{ TpgSelectItem }

destructor TpgSelectItem.Destroy;
begin
  FreeAndNil(FInfo);
  inherited;
end;

function TpgSelectItem.PreventDrop: boolean;
begin
  Result := assigned(FInfo);
end;

{ TpgRenderer }

constructor TpgRenderer.Create;
begin
  inherited;
  // setup synclist
{  FSyncList := TpgSyncList.Create;
  FSyncList.ItemClass := TpgSelectItem;
  FSyncList.FilterClass := TpgGraphic;
  FSyncList.Options := [soBeforeChange, soDropChildren];}
end;

destructor TpgRenderer.Destroy;
begin
//  FreeAndNil(FSyncList);
  inherited;
end;

function TpgRenderer.GetTransformListForGraphic(ACanvas: TpgCanvas;
  AGraphic: TpgGraphic; ATransform: TpgTransform; AScratch: TObjectList): TpgTransformList;
var
  E: TpgItem;
  T: TpgTransform;
begin
  Result := TpgTransformList.Create;
  E := AGraphic;
  while (E is TpgGraphic) do
  begin
    if E is TpgViewPort then
    begin
      T := TpgViewPort(E).BuildViewBoxTransform(ACanvas.DeviceInfo^);
      Result.Precat(T);
      AScratch.Add(T);
    end;
    Result.Precat(TpgGraphic(E).Transform.TransformValue);
    E := E.Parent;
  end;
  Result.Precat(ATransform);
end;

function TpgRenderer.HitTest(ACanvas: TpgCanvas; AGraphic: TpgGraphic; ATransform: TpgTransform;
  const AMouse: TpgMouseInfo; var AHitTestInfo: TpgHitTestInfo): boolean;
var
  Pscreen: TpgPoint;
  Pparent: TpgPoint;
  Pgraphic: TpgPoint;
  Graphic: TpgGraphic;
  Scale: single;
begin
  // Pscreen: screen coordinates
  Pscreen := pgPoint(AMouse.X, AMouse.Y);

  // Pparent: document coordinates. The parent coordinates of the graphic
  ATransform.InverseTransform(Pscreen, Pparent);
  Scale := ATransform.PixelScale;

  // See if we hit a graphic element. Pgraphic is the coordinate of the hit in the
  // resulting graphic's coordinates
  Graphic := HitTestGraphic(ACanvas, AGraphic, Pparent, Pgraphic, Scale);
  Result := assigned(Graphic);
  if Result then
    AHitTestInfo.HitCursor := crHandPoint
  else
    AHitTestInfo.HitCursor := crDefault;
  AHitTestInfo.Graphic := Graphic;
  AHitTestInfo.GPoint := Pgraphic;
end;

function TpgRenderer.HitTestGraphic(ACanvas: TpgCanvas; AGraphic: TpgGraphic;
  const Pparent: TpgPoint; var Pgraphic: TpgPoint; Scale: single): TpgGraphic;
var
  i: integer;
  AItem: TpgItem;
  Exists: boolean;
  T: TpgTransform;
  Pchild: TpgPoint;
//  Item: TpgSelectItem;
begin
  Result := nil;

  // Add our transform
  T := TpgGraphic(AGraphic).Transform.TransformValue;
  if assigned(T) then
  begin
    Exists := T.InverseTransform(Pparent, Pgraphic);
    if not Exists then
      exit;
    Scale := Scale * T.PixelScale;
  end else
    Pgraphic := Pparent;

  // if it is a viewport, we have to add the viewbox transform as well
  if AGraphic is TpgViewPort then
  begin
    T := TpgViewPort(AGraphic).BuildViewBoxTransform(ACanvas.DeviceInfo^);
    Scale := Scale * T.PixelScale;
    Exists := T.InverseTransform(Pgraphic, Pgraphic);
    T.Free;
    if not Exists then
      exit;
  end;

{todo  // Shortcut test: bounding box
  Item := TpgSelectItem(FsyncList.ById(AGraphic.Id));
  if not assigned(Item) then
    Item := TpgSelectItem(FSyncList.AddItem(AGraphic.Id));
  if not Item.FBoundsValid then
    Item.UpdateBounds(ACanvas, Self);
  if not pgPointInBox(Item.FLooseBB, Pgraphic) then
    exit;}

  // First test children, from Count - 1 downto 0. This ensures to find the
  // latest items drawn first (which are the top items)
  for i := AGraphic.ElementCount - 1 downto 0 do
  begin
    AItem := AGraphic.Items[i];
    if AItem is TpgGraphic then
    begin
      Result := HitTestGraphic(ACanvas, TpgGraphic(AItem), Pgraphic, Pchild, Scale);
      if assigned(Result) then
      begin
        // set the result to the coordinates of the child graphic
        Pgraphic := Pchild;
        exit;
      end;
    end;
  end;

  // still here? Do our own hittest

  // Does the graphic allow selection?
  if eoDenySelect in AGraphic.EditorOptions.IntValue then
    exit;

  if AGraphic is TpgShape then
    Result := HitTestShape(ACanvas, TpgShape(AGraphic), Pgraphic, Scale);

  if (AGraphic is TpgText) or (AGraphic is TpgImageView) then
  begin

    // Use tight bounding box
//todo    if pgPointInBox(Item.FTightBB, Pgraphic) then
      Result := AGraphic;
  end;
end;

function TpgRenderer.HitTestShape(ACanvas: TpgCanvas; AShape: TpgShape;
  const Pp: TpgPoint; Scale: single): TpgGraphic;
var
  P: TpgBoundsPath;
  B: TpgBox;
  W: double; // half the strokewidth
begin
  Result := nil;

  // Get the bounding path
  P := TpgBoundsPath.Create;
  try

    P.PixelScale := Scale;
    TShapeAccess(AShape).PlayFillPath(P, ACanvas.DeviceInfo^);
    W := AShape.StrokeWidth.ToDevice(ACanvas.DeviceInfo^) * 0.5;
    B := pgGrowBox(P.BoundingBox, W);

    // Inside the bounding box + Strokewidth?
    if not pgPointInBox(B, Pp) then
      exit;

    // Inside the fillpath?
    if (AShape.Fill.PaintStyle <> psNone) and P.PointInPath(Pp.X, Pp.Y, AShape.FillRule.IntValue) then
    begin
      Result := AShape;
      exit;
    end;

    // If not inside, it may be *on* the path
    if (AShape.Stroke.PaintStyle <> psNone) and P.PointOnPath(Pp.X, Pp.Y, W) then
    begin
      Result := AShape;
      exit;
    end;

  finally
    P.Free;
  end;
end;

function TpgRenderer.LocalTightBB(ACanvas: TpgCanvas; AGraphic: TpgGraphic; var IsEmpty: boolean): TpgBox;
var
  P: TpgBoundsPath;
begin
  IsEmpty := True;

  P := TpgBoundsPath.Create;
  try
    PlayHoverPath(ACanvas, AGraphic, P);
    if not P.IsEmpty then
    begin
      Result := P.BoundingBox;
      IsEmpty := False;
    end;
  finally
    P.Free;
  end;

end;

function TpgRenderer.LooseFromTightBB(ACanvas: TpgCanvas; const ABox: TpgBox; AGraphic: TpgGraphic): TpgBox;
var
  SW: double;
begin
  // Augment for stroke and effects. Just stroke for now
  Result := ABox;
  if AGraphic is TpgPaintable then
  begin
    SW := AGraphic.StrokeWidth.ToDevice(ACanvas.DeviceInfo^) * 0.5;
    // to do: miter limit
    if SW > 0 then
      Result := pgGrowBox(Result, SW);
  end;
end;

procedure TpgRenderer.PlayHoverPath(ACanvas: TpgCanvas; AGraphic: TpgGraphic; APath: TpgPath);
var
  S: TpgState;
  Text: TpgText;
  Font: TpgFont;
  X, Y, FontSize: double;
  Box: TpgBox;
  US: Utf8String;
begin
  APath.Clear;

  // Shape and ViewPort (includes Image)
  if (AGraphic is TpgShape) or (AGraphic is TpgViewPort) then
  begin
    TShapeAccess(AGraphic).PlayFillPath(APath, ACanvas.DeviceInfo^);
    exit;
  end;

  // Text
  if (AGraphic is TpgText) then
  begin

    // Let the canvas measure the text
    Text := TpgText(AGraphic);
    US := Text.Text.AsString;
    if length(US) = 0 then
      exit;

    X := 0;
    if Text.X.Values.Count > 0 then
      X := Text.X.Values[0].Value;
    Y := 0;
    if Text.Y.Values.Count > 0 then
      Y := Text.Y.Values[0].Value;

    S := ACanvas.Push;
    try
      FontSize := Text.FontSize.ToDevice(ACanvas.DeviceInfo^);
      Font := ACanvas.NewFont(Text.FontFamily.Value);
      Box := ACanvas.MeasureText(X, Y, US, Font, FontSize);
    finally
      ACanvas.Pop(S);
    end;
    APath.Rectangle(Box.Lft, Box.Top, pgWidth(Box), pgHeight(Box), 0, 0);

  end;
end;

procedure TpgRenderer.RenderGraphic(ACanvas: TpgCanvas; AGraphic: TpgGraphic);
var
  Item: TpgBoundsItem;
  Stroke: TpgStroke;
  State: TpgState;
  R: TpgBox;
begin
  inherited;
  // diag
  Item := TpgBoundsItem.Create; //todo based on AGraphic;
  if assigned(Item) and Item.BoundsValid then
  begin
    State := ACanvas.Push;
    Stroke := ACanvas.NewStroke;
    Stroke.Color := clBlue32;
    Stroke.Width := 1;
    R := Item.FTightBB;
    ACanvas.PaintRectangle(R.Left, R.Top, pgWidth(R), pgHeight(R), 0, 0, nil, Stroke);
    ACanvas.Pop(State);
  end;
end;

procedure TpgRenderer.RenderHover(ACanvas: TpgCanvas; AGraphic: TpgGraphic; ATransform: TpgTransform);
var
  S: TpgState;
  i: integer;
  TL: TpgTransformList;
  SL: TObjectList;
  Fill: TpgFill;
  Stroke: TpgStroke;
  Path: TpgPath;
begin
  SL := TObjectList.Create;
  TL := GetTransformListForGraphic(ACanvas, AGraphic, ATransform, SL);
  S := ACanvas.Push;
  try

    Fill := ACanvas.NewFill;
    Fill.Color := $50FFBBBB;
    Stroke := ACanvas.NewStroke;
    Stroke.Color := $B0FFAAAA;

    for i := 0 to TL.Count - 1 do
      ACanvas.AddTransform(TL[i], True);

    Path := ACanvas.NewPath;
    Path.PixelScale := ACanvas.PixelScale(cdUnknown);
    Stroke.Width := 1 / ACanvas.PixelScale(cdUnknown);
    PlayHoverPath(ACanvas, AGraphic, Path);
    ACanvas.PaintPath(Path, Fill, Stroke);

  finally
    ACanvas.Pop(S);
  end;
  TL.Free;
  SL.Free;
end;

procedure TpgRenderer.RenderInsertPoly(ACanvas: TpgCanvas; First: PpgPoint; Count: integer;
  ATransform: TpgTransform);
var
  S: TpgState;
  i: integer;
  Stroke: TpgStroke;
  Path: TpgPath;
begin
  S := ACanvas.Push;
  try

    Stroke := ACanvas.NewStroke;
    Stroke.Color := clBlack32;
    Stroke.Width := 1;
    Path := ACanvas.NewPath;
    Path.MoveTo(First.X, First.Y);
    inc(First);

    for i := 1 to Count - 1 do
    begin
      Path.LineTo(First.X, First.Y);
      inc(First);
    end;

    ACanvas.AddTransform(ATransform, True);
    ACanvas.PaintPath(Path, nil, Stroke);

  finally
    ACanvas.Pop(S);
  end;
end;

procedure TpgRenderer.SetScene(AScene: TpgScene);
begin
//  FSyncList.Scene := AScene;
end;

end.
