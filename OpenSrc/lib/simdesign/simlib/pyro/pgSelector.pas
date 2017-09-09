{ Project: Pyro
  Module: Pyro Edit

  Description:
  Implementation of class for selection of grahic shapes by mouse.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV

  Modified:
  19may2011: string > Utf8String
}
unit pgSelector;

interface

uses
  Classes, SysUtils, Controls, Contnrs, pgPlatform, Pyro, pgTransform, pgDocument,
  pgScene, pgRender, pgCanvas, pgPath, pgContentProvider,
  pgGeometry, pgColor, pgViewer;

type

  TpgMoveFlag = (
    mfOnlyX,
    mfOnlyY,
    mfFlipX,
    mfFlipY,
    mfNoNegative
  );
  TpgMoveFlags = set of TpgMoveFlag;

  TpgTransformHandleStyle = (
    tsTranslate,
    tsRotate,
    tsScaleX,
    tsScaleY,
    tsScaleXY,
    tsSkewX,
    tsSkewY,
    tsProj1,  // ProjX are used in projective transforms
    tsProj2,
    tsProj3,
    tsProj4,
    tsDeltaX, // DeltaX/Y used in curved transform
    tsDeltaY
  );

  TpgSelector = class;

  TpgHandle = class(TPersistent)
  private
    FIsActive: boolean;
    FId: integer;
  protected
    FOwner: TpgSelector;
    FBaseC: TpgPoint;
    FDragC: TpgPoint;
    FBaseS: TpgPoint;
    FDragS: TpgPoint;
    FDeltaS: TpgPoint;
    FCursor: TCursor;
    function LocalTightBB(ACanvas: TpgCanvas; AGraphic: TpgGraphic): Tpgbox;
    procedure PlayToGraphic(AGraphic: TpgGraphic); virtual; abstract;
    procedure Render(ACanvas: TpgCanvas; ATransform: TpgTransform); virtual; abstract;
  public
    constructor Create(AOwner: TpgSelector);
    // base location in content coordinates
    property BaseC: TpgPoint read FBaseC write FBaseC;
    // base location in shape coordinates
    property BaseS: TpgPoint read FBaseS write FBaseS;
    // drag location in content coordinates (after correction for snap etc)
    property DragC: TpgPoint read FDragC write FDragC;
    // drag location in shape coordinates (after the handle has filtered all
    // allowed movement)
    property DragS: TpgPoint read FDragS write FDragS;
    // delta move in shape coordinates
    property DeltaS: TpgPoint read FDeltaS write FDeltaS;
    // If active, it takes part in dragging
    property IsActive: boolean read FIsActive write FIsActive;
    // Id of this handle
    property Id: integer read FId write FId;
    // Cursor for this handle
    property Cursor: TCursor read FCursor write FCursor;
  end;

  TpgHandleList = class(TObjectList)
  private
    function GetItems(Index: integer): TpgHandle;
  public
    property Items[Index: integer]: TpgHandle read GetItems; default;
  end;

  TpgSelector = class(TPersistent)
  private
    FHandles: TpgHandleList;
    FBaseTransforms: TpgTransformList;
    FCopyTransforms: TpgTransformList;
    FScratchTransforms: TObjectList; // list of owned transform objects that must be freed
    FGraphicPath: TpgRenderPath; // path used to depict graphic
    FTransformPath: TpgRenderPath;
    FGraphicPathScreen: TpgRenderPath;
    FTransformPathScreen: TpgRenderPath;
    FBox: TpgBox;
    FScreenScale: double; // initial pixel scale of screen transform
    FCurb: double; // curb distance used to offset transform handles
    FOwner: TObject; // pointer to Scene Editor
    FGraphic: TpgGraphic;     // pointer to graphic that is selected
    FGraphicCopy: TpgGraphic;
    FBasePoint: TpgPoint; // Start of drag from here, in content coordinates
    FIsDragging: boolean;
    procedure BuildMoveHandle(ABaseX, ABaseY: double; AFlags: TpgMoveFlags;
      AGraphic: TpgGraphic; APropX, APropY: longword; AHandleId: integer);
    procedure BuildHandleList;
    procedure BuildGraphicHandles;
    function BuildTransformHandle(ABaseX, ABaseY, AOriginX, AOriginY: double;
      AStyle: TpgTransformHandleStyle; ACursor: TCursor): TpgHandle;
    function BuildProjectiveHandle(ABaseX, ABaseY: double; ATransform: TpgProjectiveTransform;
      AStyle: TpgTransformHandleStyle; ACursor: TCursor): TpgHandle;
    procedure BuildTransformHandles;
  protected
    function GetTransformProp: TpgTransformProp;
    function GetRenderer: TpgRenderer;
    procedure BuildTransformList(ACanvas: TpgCanvas; AGraphic: TpgGraphic; AList: TpgTransformList);
    procedure GetSelectPath(ACanvas: TpgCanvas);
    procedure RenderSelect(ACanvas: TpgCanvas; ATransform: TpgTransform);
    // Correct for snapping, ALocation is in content coordinates
    function CorrectSnap(const Mouse: TpgMouseInfo; ALocation: TpgPoint): TpgPoint;
    procedure SetActiveHandleId(AId: integer);
  public
    constructor Create(AOwner: TObject; ACanvas: TpgCanvas; AElement: TpgElement; AScreenScale: double); virtual;
    destructor Destroy; override;
    procedure DoMouseStartDrag(const Mouse: TpgMouseInfo);
    procedure DoMouseDrag(ACanvas: TpgCanvas; const Mouse: TpgMouseInfo);
    procedure DoMouseCloseDrag(ACanvas: TpgCanvas; const Mouse: TpgMouseInfo);
    procedure Invalidate;
    procedure Render(ACanvas: TpgCanvas; ATransform: TpgTransform); virtual;
    function HitTest(ATransform: TpgTransform; const AMouse: TpgMouseInfo;
      var AHitTestInfo: TpgHitTestInfo): boolean; virtual;
    procedure Update(ACanvas: TpgCanvas);
    property Handles: TpgHandleList read FHandles;
    property Graphic: TpgGraphic read FGraphic;
    property GraphicCopy: TpgGraphic read FGraphicCopy;
    property BoundingBox: TpgBox read FBox;
  end;

  TpgSelectorList = class(TObjectList)
  private
    function GetItems(Index: integer): TpgSelector;
  public
    procedure SceneChange(Sender: TObject; AElement: TpgElement; APropId: longword;
      AChange: TpgChangeType); virtual;
    property Items[Index: integer]: TpgSelector read GetItems; default;
  end;

type

  TpgGraphicType = (
    gtUnknown,
    gtText,
    gtRectangle,
    gtEllipse,
    gtImageView,
    gtPolygon,
    gtLine
  );

function GraphicType(AGraphic: TpgGraphic): TpgGraphicType;

implementation

uses
  pgEditorUsingScene, pgSelectHandles;

type

  TGraphicAccess = class(TpgGraphic);
  TViewPortAccess = class(TpgViewPort);
  TSceneEditAccess = class(TpgSceneEditor);

function GraphicType(AGraphic: TpgGraphic): TpgGraphicType;
begin
  Result := gtUnknown;
  if AGraphic is TpgText then
    Result := gtText
  else if AGraphic is TpgRectangle then
    Result := gtRectangle
  else if AGraphic is TpgEllipse then
    Result := gtEllipse
  else if AGraphic is TpgImageView then
    Result := gtImageView
  else if AGraphic is TpgPolygonShape then
    Result := gtPolygon
  else if AGraphic is TpgLine then
    Result := gtLine;
end;

{ TpgHandle }

constructor TpgHandle.Create(AOwner: TpgSelector);
begin
  inherited Create;
  FOwner := AOwner;
  FCursor := crSize;
end;

function TpgHandle.LocalTightBB(ACanvas: TpgCanvas; AGraphic: TpgGraphic): Tpgbox;
var
  IsEmpty: boolean;
begin
  Result := FOwner.GetRenderer.LocalTightBB(ACanvas, AGraphic, IsEmpty);
end;

{ TpgHandleList }

function TpgHandleList.GetItems(Index: integer): TpgHandle;
begin
  Result := Get(Index);
end;

{ TpgSelector }

procedure TpgSelector.BuildGraphicHandles;
var
  i: integer;
  PointHandle: TpgPointHandle;
  InsertHandle: TpgInsertHandle;
  GType: TpgGraphicType;
  T: TpgText;
  R: TpgRectangle;
  E: TpgEllipse;
  IV: TpgImageView;
begin
  if not assigned(FGraphic) then exit;
  GType := GraphicType(FGraphic);
  case GType of
  gtPolygon:
    // polygon point handles
    for i := 0 to TpgPolygonShape(FGraphic).Points.Values.Count div 2 - 1 do begin
      PointHandle := TpgPointHandle.Create(Self);
      PointHandle.BuildFromGraphic(FGraphic, i);
      PointHandle.IsActive := True;
      FHandles.Add(PointHandle);
    end;
  gtLine:
    for i := 0 to 1 do begin
      PointHandle := TpgPointHandle.Create(Self);
      PointHandle.BuildFromGraphic(FGraphic, i);
      PointHandle.IsActive := True;
      FHandles.Add(PointHandle);
    end;
  else
    // insert handle for other graphics
    InsertHandle := TpgInsertHandle.Create(Self);
    InsertHandle.BuildFromGraphic(FGraphic, 0);
    InsertHandle.IsActive := True;
    FHandles.Add(InsertHandle);
    // Move handles
    case GType of
    gtText:
      begin
        T := TpgText(FGraphic);
        BuildMoveHandle(T.X.Values[0].Value, T.Y.Values[0].Value - T.FontSize.FloatValue,
          [mfNoNegative, mfFlipY, mfOnlyY], T, 0, piFontSize, 2);
      end;
    gtRectangle:
      begin
        R := TpgRectangle(FGraphic);
        BuildMoveHandle(R.X.FloatValue + R.Width.FloatValue, R.Y.FloatValue + R.Height.FloatValue,
          [mfNoNegative], R, piRectWidth, piRectHeight, 1);
        BuildMoveHandle(R.X.FloatValue + R.Width.FloatValue -  R.Rx.FloatValue, R.Y.FloatValue + R.Ry.FloatValue,
          [mfNoNegative, mfFlipX], R, piRectRx, piRectRy, 2);
      end;
    gtEllipse:
      begin
        E := TpgEllipse(FGraphic);
        BuildMoveHandle(E.Cx.FloatValue + E.Rx.FloatValue, E.Cy.FloatValue,
          [mfOnlyX, mfNoNegative], E, piEllipseRx, 0, 1);
        BuildMoveHandle(E.Cx.FloatValue, E.Cy.FloatValue + E.Ry.FloatValue,
          [mfOnlyY, mfNoNegative], E, 0, piEllipseRy, 1);
      end;
    gtImageView:
      begin
        IV := TpgImageView(FGraphic);
        BuildMoveHandle(IV.X.FloatValue + IV.Width.FloatValue, IV.Y.FloatValue + IV.Height.FloatValue,
          [mfNoNegative], IV, piVPWidth, piVPHeight, 1);
      end;
    end;
  end;
end;

procedure TpgSelector.BuildHandleList;
var
  i: integer;
begin
  FHandles.Clear;
  if not assigned(FGraphic) then exit;
  BuildGraphicHandles;
  BuildTransformHandles;
  // Now transform bases back to content and set Drag = Base
  for i := 0 to FHandles.Count - 1 do begin
    FHandles[i].BaseC := FBaseTransforms.Transform(FHandles[i].BaseS);
    FHandles[i].DragC := FHandles[i].BaseC;
  end;
end;

procedure TpgSelector.BuildMoveHandle(ABaseX, ABaseY: double;
  AFlags: TpgMoveFlags; AGraphic: TpgGraphic; APropX, APropY: longword;
  AHandleId: integer);
var
  MoveHandle: TpgMoveHandle;
begin
  MoveHandle := TpgMoveHandle.Create(Self);
  MoveHandle.BaseS := pgPoint(ABaseX, ABaseY);
  MoveHandle.MoveFlags := AFlags;
  MoveHandle.BuildFromGraphic(AGraphic, APropX, APropY);
  MoveHandle.Id := AHandleId;
  FHandles.Add(MoveHandle);
end;

function TpgSelector.BuildProjectiveHandle(ABaseX, ABaseY: double;
  ATransform: TpgProjectiveTransform; AStyle: TpgTransformHandleStyle;
  ACursor: TCursor): TpgHandle;
var
  Origin: TpgPoint;
begin
  // We store the origin location as the base point (which is given in shape coords)
  // stored in parent coords of the transform.
  Origin := ATransform.Transform(pgPoint(ABaseX, ABaseY));
  Result := BuildTransformHandle(ABaseX, ABaseY, Origin.X, Origin.Y, AStyle, ACursor);
  Result.Id := 0;
end;

function TpgSelector.BuildTransformHandle(ABaseX, ABaseY, AOriginX, AOriginY: double;
  AStyle: TpgTransformHandleStyle; ACursor: TCursor): TpgHandle;
var
  Handle: TpgTransformHandle;
begin
  Handle := TpgTransformHandle.Create(Self);
  Handle.BaseS := pgPoint(ABaseX, ABaseY);
  Handle.OriginS := pgPoint(AOriginX, AOriginY);
  Handle.Id := 2;
  Handle.Style := AStyle;
  Handle.Transform := FGraphic.Transform.TransformValue;
  Handle.Cursor := ACursor;
  FHandles.Add(Handle);
  Result := Handle;
end;

procedure TpgSelector.BuildTransformHandles;
var
  i: integer;
  MidX, MidY: double;
  Transform: TpgTransform;
  PT: TpgProjectiveTransform;
  PHandles: array[0..5] of TpgTransformHandle;
begin
  Transform := FGraphicCopy.Transform.TransformValue;
  if not assigned(Transform) then exit;
  MidX := (FBox.Rgt + FBox.Lft) * 0.5;
  MidY := (FBox.Btm + FBox.Top) * 0.5;

  if Transform is TpgAffineTransform then begin
    BuildTransformHandle(FBox.Lft - FCurb, FBox.Top - FCurb, MidX, MidY, tsTranslate, crSize);
    BuildTransformHandle(MidX, FBox.Top - FCurb, MidX, MidY, tsRotate, crRotate);
    BuildTransformHandle(FBox.Rgt + FCurb, FBox.Top - FCurb, MidX, MidY, tsScaleX, crSize);
    BuildTransformHandle(FBox.Rgt + FCurb, MidY, MidX, MidY, tsSkewY, crSize);
    BuildTransformHandle(FBox.Rgt + FCurb, FBox.Btm + FCurb, MidX, MidY, tsScaleXY, crSize);
    BuildTransformHandle(MidX, FBox.Btm + FCurb, MidX, MidY, tsSkewX, crSize);
    BuildTransformHandle(FBox.Lft - FCurb, FBox.Btm + FCurb, MidX, MidY, tsScaleY, crSize);
  end;
  if Transform is TpgProjectiveTransform then begin
    // All other handles with Id = 0 must go to another Id, because when we move the
    // shape, only these handles should move
    for i := 0 to FHandles.Count - 1 do
      if FHandles[i].Id = 0 then FHandles[i].Id := 10;

    PT := TpgProjectiveTransform(Transform);
    PHandles[0] := TpgTransformHandle(BuildProjectiveHandle(FBox.Lft - FCurb, FBox.Top - FCurb, PT, tsProj1, crSize));
    PHandles[1] := TpgTransformHandle(BuildProjectiveHandle(FBox.Rgt + FCurb, FBox.Top - FCurb, PT, tsProj2, crSize));
    PHandles[2] := TpgTransformHandle(BuildProjectiveHandle(FBox.Rgt + FCurb, FBox.Btm + FCurb, PT, tsProj3, crSize));
    PHandles[3] := TpgTransformHandle(BuildProjectiveHandle(FBox.Lft - FCurb, FBox.Btm + FCurb, PT, tsProj4, crSize));
    // Curved transforms have two additional points
    if PT is TpgCurvedTransform then begin
      PHandles[4] := TpgTransformHandle(BuildProjectiveHandle(MidX, FBox.Top - FCurb, PT, tsDeltaY, crSize));
      PHandles[4].Id := 1;
      PHandles[5] := TpgTransformHandle(BuildProjectiveHandle(FBox.Rgt + FCurb, MidY, PT, tsDeltaX, crSize));
      PHandles[5].Id := 1;
    end;
    // Already adapt the transform now to match with handles
    // Set new viewbox
    PT.MinX := PHandles[0].FBaseS.X;
    PT.MinY := PHandles[0].FBaseS.Y;
    PT.Width := PHandles[2].FBaseS.X - PHandles[0].FBaseS.X;
    PT.Height := PHandles[2].FBaseS.Y - PHandles[0].FBaseS.Y;
    // Set 4 new points from original
    for i := 0 to 3 do begin
      PT.Points[i].X := PHandles[i].OriginS.X;
      PT.Points[i].Y := PHandles[i].OriginS.Y;
    end;
  end;
end;

procedure TpgSelector.BuildTransformList(ACanvas: TpgCanvas; AGraphic: TpgGraphic; AList: TpgTransformList);
var
  E: TpgElement;
  T: TpgTransform;
begin
  AList.Clear;
  AList.Precat(AGraphic.Transform.TransformValue);// not the local transform!
  E := FGraphic.Parent;
  while (E is TpgGraphic) do begin
    if E is TpgViewPort then
    begin
      T := TpgViewPort(E).BuildViewBoxTransform(ACanvas.DeviceInfo^);
      AList.Precat(T);
      FScratchTransforms.Add(T);
    end;
    AList.Precat(TGraphicAccess(E).Transform.TransformValue);
    E := E.Parent;
  end;
end;

function TpgSelector.CorrectSnap(const Mouse: TpgMouseInfo;
  ALocation: TpgPoint): TpgPoint;
begin
  // to do
  Result := ALocation;
end;

constructor TpgSelector.Create(AOwner: TObject; ACanvas: TpgCanvas; AElement: TpgElement; AScreenScale: double);
begin
  inherited Create;
  FHandles := TpgHandleList.Create;
  FBaseTransforms := TpgTransformList.Create;
  FCopyTransforms := TpgTransformList.Create;
  FScratchTransforms := TObjectList.Create(True);
  FGraphicPath := TpgRenderPath.Create;
  FTransformPath := TpgRenderPath.Create;
  FGraphicPathScreen := TpgRenderPath.Create;
  FTransformPathScreen := TpgRenderPath.Create;
  FOwner := AOwner;
  FScreenScale := AScreenScale;
  FGraphic := TpgGraphic(AElement);
  Update(ACanvas);
end;

destructor TpgSelector.Destroy;
begin
  FreeAndNil(FHandles);
  FreeAndNil(FBaseTransforms);
  FreeAndNil(FCopyTransforms);
  FreeAndNil(FScratchTransforms);
  FreeAndNil(FGraphicPath);
  FreeAndNil(FTransformPath);
  FreeAndNil(FGraphicPathScreen);
  FreeAndNil(FTransformPathScreen);
  FreeAndNil(FGraphicCopy);
  inherited;
end;

procedure TpgSelector.DoMouseCloseDrag(ACanvas: TpgCanvas; const Mouse: TpgMouseInfo);
var
  i: integer;
begin
  // Now we must play the handle to the graphic, not the copy

  // The handle we're working with
  //FGraphic.Transform.BeforeChange;
  FGraphic.Transform.Assign(FGraphicCopy.Transform);
  for i := 0 to FHandles.Count - 1 do
    if FHandles[i].IsActive then
      if not (FHandles[i] is TpgTransformHandle) then
        FHandles[i].PlayToGraphic(FGraphic);
  //FGraphic.Transform.AfterChange;
  // Rebuild the list
  Update(ACanvas);
  FIsDragging := False;
  // Invalidate
  Invalidate;
end;

procedure TpgSelector.DoMouseDrag(ACanvas: TpgCanvas; const Mouse: TpgMouseInfo);
var
  i: integer;
  DragPoint, DeltaC, DragC: TpgPoint;
  Handle: TpgHandle;
begin
  DragPoint := TpgSceneEditor(FOwner).ToContent(Mouse.X, Mouse.Y);
  for i := 0 to FHandles.Count - 1 do
    if FHandles[i].IsActive then begin
      // The handle we're working with
      Handle := FHandles[i];

      // New location of handle, corrected for snap
      DeltaC := pgDelta(FBasePoint, DragPoint);
      DragC := pgAddPoint(Handle.FBaseC, DeltaC);
      Handle.FDragC := CorrectSnap(Mouse, DragC);

      // Calculate the drag delta for the handle (in shapes coordinates)
      FBaseTransforms.InverseTransform(Handle.BaseC, Handle.FBaseS);
      FBaseTransforms.InverseTransform(Handle.DragC, Handle.FDragS);
      Handle.FDeltaS := pgDelta(Handle.FBaseS, Handle.FDragS);

      // Let the handle change the graphics copy
      Handle.PlayToGraphic(FGraphicCopy);

      // We recalculate the drag position in content coordinates
      Handle.FDragC := FBaseTransforms.Transform(Handle.FDragS);
    end;
  GetSelectPath(ACanvas);
  Invalidate;
end;

procedure TpgSelector.DoMouseStartDrag(const Mouse: TpgMouseInfo);
begin
  FBasePoint := TpgSceneEditor(FOwner).ToContent(Mouse.X, Mouse.Y);
  FIsDragging := True;
end;

function TpgSelector.GetRenderer: TpgRenderer;
begin
  Result := nil;
  if assigned(FOwner) then Result := TSceneEditAccess(FOwner).EditRenderer;
end;

procedure TpgSelector.GetSelectPath(ACanvas: TpgCanvas);
var
  S: TpgState;
  Text: TpgText;
  Font: TpgFont;
  X, Y, Width, Height, FontSize: double;
  Box: TpgBox;
  WS: widestring;
  VP: TpgViewPort;
  DInfo: PpgDeviceInfo;
  CH, CL: double;
  PS: double;
begin
  FGraphicPath.Clear;
  FTransformPath.Clear;
  PS := FBaseTransforms.PixelScale;
  FGraphicPath.PixelScale := PS;
  FTransformPath.PixelScale := PS;
  if not FBaseTransforms.IsLinear then begin
    FGraphicPath.BreakupLength := 1 / PS;
    FTransformPath.BreakupLength := 1 / PS;
  end;
  DInfo := ACanvas.DeviceInfo;

  // Shape
  if (FGraphicCopy is TpgShape) then
    FGraphicCopy.PlayFillPath(FGraphicPath, DInfo^);

  // Viewport (Image)
  if (FGraphicCopy is TpgViewPort) then begin
    // Here we deviate from a normal hover path, because we cannot deal easily
    // with the viewport transform in the selector.
    VP := TpgViewPort(FGraphicCopy);
    X := VP.X.ToDevice(DInfo^);
    Y := VP.Y.ToDevice(DInfo^);
    Width := VP.Width.ToDevice(DInfo^);
    Height := VP.Height.ToDevice(DInfo^);
    FGraphicPath.Rectangle(X, Y, Width, Height, 0, 0);
  end;

  // Text
  if (FGraphicCopy is TpgText) then begin
    // Let the canvas measure the text
    Text := TpgText(FGraphicCopy);
    WS := UTF8Decode(Text.Text.AsString);
    if length(WS) = 0 then exit;
    X := 0;
    if Text.X.Values.Count > 0 then
      X := Text.X.Values[0].Value;
    Y := 0;
    if Text.Y.Values.Count > 0 then
      Y := Text.Y.Values[0].Value;
    S := ACanvas.Push;
    try
      FontSize := Text.FontSize.ToDevice(DInfo^);
      Font := ACanvas.NewFont(Text.FontFamily.Value);
      Box := ACanvas.MeasureText(X, Y, WS, Font, FontSize);
    finally
      ACanvas.Pop(S);
    end;
    FGraphicPath.Rectangle(Box.Lft, Box.Top, pgWidth(Box), pgHeight(Box), 0, 0);
  end;

  // Also get the bounding box
  FBox := FGraphicPath.BoundingBox;
  // Curb is the offset distance of transform handles from bounding box
  FCurb := cDefaultAffineCurb / (FCopyTransforms.GetPixelScale(cdUnknown) * FScreenScale);
  CH := FCurb * 1.2;
  CL := FCurb * 0.8;

  // And build the path for the transform border
  FTransformPath.MoveTo(FBox.Lft - CH, FBox.Top - CH);
  FTransformPath.LineTo(FBox.Rgt + CH, FBox.Top - CH);
  FTransformPath.LineTo(FBox.Rgt + CH, FBox.Btm + CH);
  FTransformPath.LineTo(FBox.Lft - CH, FBox.Btm + CH);
  FTransformPath.ClosePath;
  FTransformPath.MoveTo(FBox.Lft - CL, FBox.Top - CL);
  FTransformPath.LineTo(FBox.Lft - CL, FBox.Btm + CL);
  FTransformPath.LineTo(FBox.Rgt + CL, FBox.Btm + CL);
  FTransformPath.LineTo(FBox.Rgt + CL, FBox.Top - CL);
  FTransformPath.ClosePath;
end;

function TpgSelector.GetTransformProp: TpgTransformProp;
begin
  Result := nil;
  if assigned(FGraphic) then Result := FGraphic.Transform;
end;

function TpgSelector.HitTest(ATransform: TpgTransform;
  const AMouse: TpgMouseInfo; var AHitTestInfo: TpgHitTestInfo): boolean;
var
  i: integer;
  Pc, Ps: TpgPoint;
  S: double;
  ScSqr: double;
begin
  // Get mouse in shape coordinates
  Pc := pgPoint(AMouse.X, AMouse.Y);
  ATransform.InverseTransform(Pc, Ps);
  S := ATransform.PixelScale;
  for i := 0 to FBaseTransforms.Count - 1 do begin
    FBaseTransforms[i].InverseTransform(Ps, Ps);
    S := S * FBaseTransforms[i].PixelScale;
  end;
  ScSqr := sqr(8/S);

  // Hittest our handles
  for i := 0 to FHandles.Count - 1 do
    if pgDistanceSqr(Ps, FHandles[i].FBaseS) < ScSqr then
    begin
      Result := True;
      AHitTestInfo.HitCursor := FHandles[i].Cursor;
      SetActiveHandleId(-1); // this deselects all
      FHandles[i].IsActive := True;
      Invalidate;
      exit;
    end;

  // No handle hit: hittest our shape
  if FGraphicPath.PointInPath(Ps.X, Ps.Y, frNonZero) or
     FGraphicPath.PointOnPath(Ps.X, Ps.Y, 8/S) then begin
    Result := True;
    AHitTestInfo.HitCursor := crHandPoint;
    SetActiveHandleId(0);
    Invalidate;
    exit;
  end;

  AHitTestInfo.HitCursor := crDefault;
  Result := False;
end;

procedure TpgSelector.Invalidate;
begin
  // for now: invalidate owner -> must change to some bounding box
  TpgSceneEditor(FOwner).Invalidate;
end;

procedure TpgSelector.Render(ACanvas: TpgCanvas; ATransform: TpgTransform);
var
  i: integer;
begin
  if not assigned(ATransform) then exit;
  // Render stippled selection path
  RenderSelect(ACanvas, ATransform);
  // Render handles
  for i := 0 to Handles.Count - 1 do begin
    FHandles[i].Render(ACanvas, ATransform);
  end;
end;

procedure TpgSelector.RenderSelect(ACanvas: TpgCanvas; ATransform: TpgTransform);
var
  S: TpgState;
  i: integer;
  Scale: double;
  Fill: TpgFill;
  Stroke: TpgStroke;
begin
  S := ACanvas.Push;
  try

    // Canvas transform
    FCopyTransforms.Precat(ATransform);
    for i := 0 to FCopyTransforms.Count - 1 do
      ACanvas.AddTransform(FCopyTransforms[i], True);

    // Fill and stroke
    Fill := ACanvas.NewFill;
    Stroke := ACanvas.NewStroke;
    if FIsDragging then
      Fill.Color := $300000FF
    else
      Fill.PaintStyle := psNone;
    Stroke.Color := $C0FFFFFF;
    Scale := 1 / ACanvas.PixelScale;
    Stroke.Width := Scale;
    Stroke.Dashes[0] := Scale * 2;

    // Paint first pixel dashes
    ACanvas.PaintPath(FGraphicPath, nil, Stroke);

    // Paint second pixel dashes + fill
    Stroke.DashOffset := Scale * 2;
    Stroke.Color := $C0000000;
    ACanvas.PaintPath(FGraphicPath, Fill, Stroke);

    // Paint transform border
    if assigned(FGraphicCopy.Transform.TransformValue) then begin
      Fill.Color := $100000FF;
      ACanvas.PaintPath(FTransformPath, Fill, nil);
    end;

  finally
    ACanvas.Pop(S);
  end;

  // Remove precatted transform
  FCopyTransforms.Delete(0);
end;

procedure TpgSelector.SetActiveHandleId(AId: integer);
var
  i: integer;
begin
  for i := 0 to FHandles.Count - 1 do
    FHandles[i].IsActive := FHandles[i].Id = AId;
end;

procedure TpgSelector.Update(ACanvas: TpgCanvas);
begin
  if not assigned(FGraphic) then exit;
  FGraphicCopy := TpgGraphic(TpgElementClass(FGraphic.ClassType).CreateCopyFrom(FGraphic, nil));
  FGraphicCopy.Flags := FGraphicCopy.Flags + [efTemporary];
  FScratchTransforms.Clear;
  BuildTransformList(ACanvas, FGraphic,     FBaseTransforms);
  BuildTransformList(ACanvas, FGraphicCopy, FCopyTransforms);
  GetSelectPath(ACanvas);
  BuildHandleList;
end;

{ TpgSelectorList }

function TpgSelectorList.GetItems(Index: integer): TpgSelector;
begin
  Result := Get(Index);
end;

procedure TpgSelectorList.SceneChange(Sender: TObject; AElement: TpgElement;
  APropId: longword; AChange: TpgChangeType);
begin
  if AChange = ctListClear then Clear;
end;

end.
