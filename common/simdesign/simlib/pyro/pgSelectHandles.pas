{ Project: Pyro
  Module: Pyro Edit

  Description:
  Specific handles used in selector

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgSelectHandles;

interface

uses
  pgSelector, pgTransform, pgScene, pgCanvas,
  pgGeometry, Pyro, pgColor;

type

  // Handle that incorporates an insertion point
  TpgInsertHandle = class(TpgHandle)
  protected
    procedure PlayToGraphic(AGraphic: TpgGraphic); override;
    procedure Render(ACanvas: TpgCanvas; ATransform: TpgTransform); override;
  public
    procedure BuildFromGraphic(AGraphic: TpgGraphic; AInfo: integer);
  end;

  // Handle that incorporates a polygon point
  TpgPointHandle = class(TpgHandle)
  private
    FInfo: integer; // index of point number
  protected
    procedure PlayToGraphic(AGraphic: TpgGraphic); override;
    procedure Render(ACanvas: TpgCanvas; ATransform: TpgTransform); override;
  public
    procedure BuildFromGraphic(AGraphic: TpgGraphic; AInfo: integer);
  end;

  // Handle that incorporates a move function on one of the length props
  TpgMoveHandle = class(TpgHandle)
  private
    FMoveFlags: TpgMoveFlags;
    FPropIdX: longword;
    FPropIdY: longword;
    FOrig: TpgPoint;
  protected
    procedure PlayToGraphic(AGraphic: TpgGraphic); override;
    procedure Render(ACanvas: TpgCanvas; ATransform: TpgTransform); override;
  public
    procedure BuildFromGraphic(AGraphic: TpgGraphic; APropIdX, APropIdY: longword);
    property MoveFlags: TpgMoveFlags read FMoveFlags write FMoveFlags;
  end;

  TpgTransformHandle = class(TpgHandle)
  private
    FStyle: TpgTransformHandleStyle;
    FOriginS: TpgPoint;
    FTransform: TpgTransform;
  protected
    procedure PlayToGraphic(AGraphic: TpgGraphic); override;
    procedure Render(ACanvas: TpgCanvas; ATransform: TpgTransform); override;
  public
    property Style: TpgTransformHandleStyle read FStyle write FStyle;
    // Origin about which we rotate, scale, shear, etc
    property OriginS: TpgPoint read FOriginS write FOriginS;
    // Pointer to original transform of shape
    property Transform: TpgTransform read FTransform write FTransform;
  end;

implementation

{ TpgInsertHandle }

procedure TpgInsertHandle.BuildFromGraphic(AGraphic: TpgGraphic;
  AInfo: integer);
begin
  FillChar(FBaseS, SizeOf(FBaseS), 0);
  case GraphicType(AGraphic) of
  gtText:
    // Insert point
    FBaseS := pgPoint(
      TpgText(AGraphic).X.Values[0].Value,
      TpgText(AGraphic).Y.Values[0].Value);
  gtRectangle:
    FBaseS := pgPoint(
      TpgRectangle(AGraphic).X.FloatValue,
      TpgRectangle(AGraphic).Y.FloatValue);
  gtEllipse:
    FBaseS := pgPoint(
      TpgEllipse(AGraphic).Cx.FloatValue,
      TpgEllipse(AGraphic).Cy.FloatValue);
  gtImageView:
    FBaseS := pgPoint(
      TpgImageView(AGraphic).X.FloatValue,
      TpgImageView(AGraphic).Y.FloatValue);
  end;
end;

procedure TpgInsertHandle.PlayToGraphic(AGraphic: TpgGraphic);
begin
  FDragS := pgAddPoint(FBaseS, FDeltaS);
  case GraphicType(AGraphic) of
  gtText:
    begin
      TpgText(AGraphic).X.Values[0].Value := FDragS.X;
      TpgText(AGraphic).Y.Values[0].Value := FDragS.Y;
    end;
  gtRectangle:
    begin
      TpgRectangle(AGraphic).X.FloatValue := FDragS.X;
      TpgRectangle(AGraphic).Y.FloatValue := FDragS.Y;
    end;
  gtEllipse:
    begin
      TpgEllipse(AGraphic).Cx.FloatValue := FDragS.X;
      TpgEllipse(AGraphic).Cy.FloatValue := FDragS.Y;
    end;
  gtImageView:
    begin
      TpgImageView(AGraphic).X.FloatValue := FDragS.X;
      TpgImageView(AGraphic).Y.FloatValue := FDragS.Y;
    end;
  end;
end;

procedure TpgInsertHandle.Render(ACanvas: TpgCanvas; ATransform: TpgTransform);
var
  S: TpgState;
  P: TpgPoint;
  Fill: TpgFill;
  Stroke: TpgStroke;
begin
  S := ACanvas.Push;
  try
    Fill := ACanvas.NewFill;
    Stroke := ACanvas.NewStroke;
    Fill.Color := clWhite32;
    Stroke.Color := clBlack32;
    if IsActive then Stroke.Width := 1.5 else Stroke.Width := 0.7;
    P := ATransform.Transform(DragC);
    ACanvas.PaintEllipse(P.X, P.Y, 3, 3, Fill, Stroke);
  finally
    ACanvas.Pop(S);
  end;
end;

{ TpgPointHandle }

procedure TpgPointHandle.BuildFromGraphic(AGraphic: TpgGraphic; AInfo: integer);
begin
  FInfo := AInfo;
  case GraphicType(AGraphic) of
  gtPolygon:
    FBaseS := pgPoint(
      TpgPolygonShape(AGraphic).Points.Values[FInfo * 2    ].Value,
      TpgPolygonShape(AGraphic).Points.Values[FInfo * 2 + 1].Value);
  gtLine:
    case FInfo of
    0: FBaseS := pgPoint(
         TpgLine(AGraphic).X1.FloatValue,
         TpgLine(AGraphic).Y1.FloatValue);
    1: FBaseS := pgPoint(
         TpgLine(AGraphic).X2.FloatValue,
         TpgLine(AGraphic).Y2.FloatValue);
    end;
  end;
end;

procedure TpgPointHandle.PlayToGraphic(AGraphic: TpgGraphic);
begin
  FDragS := pgAddPoint(FBaseS, FDeltaS);
  case GraphicType(AGraphic) of
  gtPolygon:
    begin
      TpgPolygonShape(AGraphic).Points.Values[FInfo * 2    ].Value := FDragS.X;
      TpgPolygonShape(AGraphic).Points.Values[FInfo * 2 + 1].Value := FDragS.Y;
    end;
  gtLine:
    case FInfo of
    0:
      begin
        TpgLine(AGraphic).X1.FloatValue := FDragS.X;
        TpgLine(AGraphic).Y1.FloatValue := FDragS.Y;
      end;
    1:
      begin
        TpgLine(AGraphic).X2.FloatValue := FDragS.X;
        TpgLine(AGraphic).Y2.FloatValue := FDragS.Y;
      end;
    end;
  end;
end;

procedure TpgPointHandle.Render(ACanvas: TpgCanvas; ATransform: TpgTransform);
var
  S: TpgState;
  P: TpgPoint;
  Fill: TpgFill;
  Stroke: TpgStroke;
begin
  S := ACanvas.Push;
  try
    Fill := ACanvas.NewFill;
    Stroke := ACanvas.NewStroke;
    Fill.Color := clYellow32;
    Stroke.Color := clBlack32;
    if IsActive then Stroke.Width := 1.5 else Stroke.Width := 0.7;
    P := ATransform.Transform(DragC);
    ACanvas.PaintEllipse(P.X, P.Y, 2, 2, Fill, Stroke);
  finally
    ACanvas.Pop(S);
  end;
end;

{ TpgMoveHandle }

procedure TpgMoveHandle.BuildFromGraphic(AGraphic: TpgGraphic; APropIdX, APropIdY: longword);
var
  Prop: TpgLengthProp;
begin
  FPropIdX := APropIdX;
  FPropIdY := APropIdY;
  // Get original value
  if not (mfOnlyY in FMoveFlags) then begin
    Prop := TpgLengthProp(AGraphic.PropById(FPropIdX));
    FOrig.X := Prop.FloatValue;
  end;
  if not (mfOnlyX in FMoveFlags) then begin
    Prop := TpgLengthProp(AGraphic.PropById(FPropIdY));
    FOrig.Y := Prop.FloatValue;
  end;
end;

procedure TpgMoveHandle.PlayToGraphic(AGraphic: TpgGraphic);
var
  Prop: TpgLengthProp;
  Value: double;
begin
  if not (mfOnlyY in FMoveFlags) then begin
    Prop := TpgLengthProp(AGraphic.PropById(FPropIdX));
    if mfFlipX in FMoveFlags then
      Value := -FDeltaS.X
    else
      Value := FDeltaS.X;
    Value := FOrig.X + Value;
    if mfNoNegative in FMoveFlags then Value := pgMax(0, Value);
    Prop.FloatValue := Value;
  end;
  if not (mfOnlyX in FMoveFlags) then begin
    Prop := TpgLengthProp(AGraphic.PropById(FPropIdY));
    if mfFlipY in FMoveFlags then
      Value := -FDeltaS.Y
    else
      Value := FDeltaS.Y;
    Value := FOrig.Y + Value;
    if mfNoNegative in FMoveFlags then Value := pgMax(0, Value);
    Prop.FloatValue := Value;
  end;
end;

procedure TpgMoveHandle.Render(ACanvas: TpgCanvas; ATransform: TpgTransform);
var
  S: TpgState;
  P: TpgPoint;
  Fill: TpgFill;
  Stroke: TpgStroke;
begin
  S := ACanvas.Push;
  try
    Fill := ACanvas.NewFill;
    Stroke := ACanvas.NewStroke;
    case Id of
    1: Fill.Color := clYellow32;
    2: Fill.Color := clFuchsia32;
    end;
    Stroke.Color := clBlack32;
    if IsActive then Stroke.Width := 1.5 else Stroke.Width := 0.7;
    P := ATransform.Transform(DragC);
    ACanvas.PaintRectangle(P.X - 2.5, P.Y - 2.5, 5, 5, 0, 0, Fill, Stroke);
  finally
    ACanvas.Pop(S);
  end;
end;

{ TpgTransformHandle }

procedure TpgTransformHandle.PlayToGraphic(AGraphic: TpgGraphic);
var
  Index: integer;
  AT: TpgAffineTransform;
  PT: TpgProjectiveTransform;
  CT: TpgCurvedTransform;
  Angle: double;
  Scale: double;
  DragP: TpgPoint;
begin
  case FStyle of
  tsTranslate..tsSkewY:
    begin
      AT := TpgAffineTransform(AGraphic.Transform.Value);
      // Original state
      AT.Assign(FTransform);
      case FStyle of
      tsTranslate: AT.Translate(DeltaS.X, DeltaS.Y);
      tsRotate:
        begin
          Angle := pgArcTan2(DeltaS.X, OriginS.Y - BaseS.Y - DeltaS.Y);
          AT.Rotate(Angle * 180 / pi, OriginS.X, OriginS.Y);
        end;
      tsScaleX:
        begin
          Scale := (BaseS.X - OriginS.X + DeltaS.X) / (BaseS.X - OriginS.X);
          AT.Translate(OriginS.X, OriginS.Y);
          AT.Scale(Scale, 1);
          AT.Translate(-OriginS.X, -OriginS.Y);
        end;
      tsScaleY:
        begin
          Scale := (BaseS.Y - OriginS.Y + DeltaS.Y) / (BaseS.Y - OriginS.Y);
          AT.Translate(OriginS.X, OriginS.Y);
          AT.Scale(1, Scale);
          AT.Translate(-OriginS.X, -OriginS.Y);
        end;
      tsScaleXY:
        begin
          Scale := sqrt(
           (sqr(BaseS.Y - OriginS.Y + DeltaS.Y) + sqr(BaseS.X - OriginS.X + DeltaS.X)) /
           (sqr(BaseS.Y - OriginS.Y) + sqr(BaseS.X - OriginS.X)));
          AT.Translate(OriginS.X, OriginS.Y);
          AT.Scale(Scale, Scale);
          AT.Translate(-OriginS.X, -OriginS.Y);
        end;
      tsSkewX:
        begin
          Angle := pgArcTan2(DeltaS.X, BaseS.Y - OriginS.Y + DeltaS.Y);
          AT.Translate(OriginS.X, OriginS.Y);
          AT.SkewX(Angle * 180 / pi);
          AT.Translate(-OriginS.X, -OriginS.Y);
        end;
      tsSkewY:
        begin
          Angle := pgArcTan2(DeltaS.Y, BaseS.X - OriginS.X + DeltaS.X);
          AT.Translate(OriginS.X, OriginS.Y);
          AT.SkewY(Angle * 180 / pi);
          AT.Translate(-OriginS.X, -OriginS.Y);
        end;
      end;
    end;
  tsProj1..tsProj4:
    begin
      PT := TpgProjectiveTransform(AGraphic.Transform.Value);
      DragP := PT.Transform(DragS);
      Index := 0;
      case FStyle of
      tsProj1: Index := 0;
      tsProj2: Index := 1;
      tsProj3: Index := 2;
      tsProj4: Index := 3;
      end;
      PT.SetPoint(Index, DragP);
    end;
  tsDeltaX:
    begin
      CT := TpgCurvedTransform(AGraphic.Transform.Value);
      CT.Assign(FTransform);
      CT.DeltaX := CT.DeltaX + DeltaS.X;
    end;
  tsDeltaY:
    begin
      CT := TpgCurvedTransform(AGraphic.Transform.Value);
      CT.Assign(FTransform);
      CT.DeltaY := CT.DeltaY + DeltaS.Y;
    end;
  end;//case
end;

procedure TpgTransformHandle.Render(ACanvas: TpgCanvas; ATransform: TpgTransform);
var
  S: TpgState;
  P: TpgPoint;
  Fill: TpgFill;
  Stroke: TpgStroke;
begin
  S := ACanvas.Push;
  try
    Fill := ACanvas.NewFill;
    Stroke := ACanvas.NewStroke;
    case FStyle of
    tsTranslate:
      Fill.Color := clBlue32;
    tsRotate:
      Fill.Color := clLime32;
    tsScaleX, tsScaleY, tsScaleXY:
      Fill.Color := $FF8080FF;
    tsSkewX, tsSkewY:
      Fill.Color := clLightGray32;
    tsProj1..tsProj4:
      Fill.Color := clBlue32;
    tsDeltaX, tsDeltaY:
      Fill.Color := clRed32;
    end;
    Stroke.Color := clBlack32;
    if IsActive then Stroke.Width := 1.5 else Stroke.Width := 0.7;
    P := ATransform.Transform(DragC);
    ACanvas.PaintEllipse(P.X, P.Y, 2.5, 2.5, Fill, Stroke);
  finally
    ACanvas.Pop(S);
  end;
end;

end.
