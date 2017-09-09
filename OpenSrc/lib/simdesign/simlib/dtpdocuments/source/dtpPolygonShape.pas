{
  Unit dtpPolygonShape

  TdtpPolygonShape is a TdtpEffectShape descendant that can be used to show
  (outlined) polygons.

  Project: DTP-Engine

  Creation Date: 22-08-2003 (NH)
  Version: 1.0

  Modifications:
  07-08-2003: Adapted so the core routines can also be used from other units

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpPolygonShape;

{$i simdesign.inc}

interface

uses
  Types, Windows, dtpEffectShape, dtpGraphics,
  SysUtils, Graphics, Math, NativeXmlOld, Classes, dtpShape, ExtCtrls,
  dtpDefaults, dtpTransform;

type
  ArrayOfFPoint = array of TdtpPoint;
  ArrayOfArrayOfFPoint = array of ArrayOfFPoint;
  
  // TdtpPolygonShape is a shape that can render a polygon with a fill color and
  // and an outline (with certain thickness). It will seldomly be used directly,
  // but serves as ascending object for freehand, character outline shapes, bezier
  // lines, polylines, arrows, circles, squares, ellipses etc.
  // By using effects on the shape, the fill and outline color can be replaced by
  // any bitmap, gradient, etc.
  TdtpPolygonShape = class(TdtpEffectShape)
  private
    FAdjusting: boolean;       // If true, the AdjustBounds procedure is doing work
    FDrawPolygon: TdtpPolygon; // The actual polygon drawn by G32
    FDrawOutline: TdtpPolygon; // The actual outline drawn by G32
    FIsClosed: boolean;        // True for closed polygons, false if not closed
    FOutlineWidth: single;     // Line width of the outline in [mm]
    FMustUpdate: boolean;      // If set, we must recalculate the G32 polygon
    FFillAlpha: cardinal;      // Alpha transparency used for fill
    FFillColor: TColor;        // Fill color
    FOutlineColor: TColor;     // Outline color
    FStipplecount: integer;
    FStippleSize: single;      // Size of stipples in [mm]
    FUseFill: boolean;         // Do a fill (alternating)
    FUseOutline: boolean;      // Draw an outline
    FUseStipple: boolean;      // Draw a stippled, animated line just like marching ants
    procedure SetFillColor(const Value: TColor);
    procedure SetOutlineColor(const Value: TColor);
    procedure SetUseOutline(const Value: boolean);
    procedure SetOutlineWidth(const Value: single);
    procedure SetUseFill(const Value: boolean);
    procedure SetFillAlpha(const Value: cardinal);
    procedure SetIsClosed(const Value: boolean);
    procedure SetUseStipple(const Value: boolean);
    procedure SetStippleSize(const Value: single);
    function GetLineCount: integer;
  protected
    // The polygon that is provided by app, points are relative to DocTop/DocLeft, so
    // [0, 0] corresponds to a point in the upper/left corner of the shape, and
    // [DocWidth, DocHeight] corresponds to a point in the lower/right corner of the shape
    FPts: ArrayOfArrayOfFPoint;
    FStorePoints: boolean;     // If True (default) the points are stored on save
    function BoundingBox: TdtpRect; virtual;
    procedure FitToRectangle(ARect: TdtpRect); virtual;
    function GetScale: single;
    procedure GeneratePoints; virtual;
    procedure Offset(Dx, Dy: single); virtual;
    procedure ScaleBy(Sx, Sy: single); virtual;
    procedure PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext); override;
    procedure SetDocSize(AWidth, AHeight: single); override;
    procedure SetTransformation(const ATrans: TdtpMatrix); override;
    function ShapeRegion: HRgn; override;
    procedure UpdatePolygons; virtual;
    procedure ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single); override;
    property MustUpdate: boolean read FMustUpdate write FMustUpdate;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Add(const P: TdtpPoint); overload; virtual;
    procedure Add(const X, Y: single); overload; virtual;
    procedure Clear; override;
    procedure ClearPolygon; virtual;
    procedure DoAnimate; override;
    function IsEmpty: boolean;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    procedure SetPropertyByName(const AName, AValue: string); override;
    procedure NewLine; virtual;
    property FillAlpha: cardinal read FFillAlpha write SetFillAlpha;
    property FillColor: TColor read FFillColor write SetFillColor;
    property IsClosed: boolean read FIsClosed write SetIsClosed;
    property LineCount: integer read GetLineCount;
    property OutlineWidth: single read FOutlineWidth write SetOutlineWidth;
    property OutlineColor: TColor read FOutlineColor write SetOutlineColor;
    property StorePoints: boolean read FStorePoints write FStorePoints;
    property UseFill: boolean read FUseFill write SetUseFill;
    property UseOutline: boolean read FUseOutline write SetUseOutline;
    property UseStipple: boolean read FUseStipple write SetUseStipple;
    property StippleSize: single read FStippleSize write SetStippleSize;
  end;

  // This shape shows an ellipse with the size of DocWidth, DocHeight. It uses
  // the inherited properties from TdtpPolygonShape to draw and fill the ellipse
  TdtpEllipseShape = class(TdtpPolygonShape)
  protected
    procedure GeneratePoints; override;
  public
    constructor Create; override;
  end;

  // This shape shows a rectangle with the size of DocWidth, DocHeight. It uses
  // the inherited properties from TdtpPolygonShape to draw and fill the rectangle
  TdtpRectangleShape = class(TdtpPolygonShape)
  protected
    procedure GeneratePoints; override;
  public
    constructor Create; override;
  end;

  // This shape shows a rectangle with rounded corners, with the size of DocWidth,
  // DocHeight. It uses the inherited properties from TdtpPolygonShape to draw
  // and fill the rectangle.
  TdtpRoundRectShape = class(TdtpPolygonShape)
  private
    FCornerWidth: single;
    FCornerHeight: single;
    FCornerPropertiesArePercentage: boolean;
    procedure SetCornerHeight(const Value: single);
    procedure SetCornerWidth(const Value: single);
    procedure SetCornerPropertiesArePercentage(const Value: boolean);
  protected
    procedure GeneratePoints; override;
  public
    constructor Create; override;
    property CornerWidth: single read FCornerWidth write SetCornerWidth;
    property CornerHeight: single read FCornerHeight write SetCornerHeight;
    property CornerPropertiesArePercentage: boolean read FCornerPropertiesArePercentage write SetCornerPropertiesArePercentage;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    procedure SetPropertyByName(const AName, AValue: string); override;
  end;

// Helper routine to draw a rectangle
procedure PolyDrawRect(const Points: ArrayOfArrayOfFPoint; Left, Top, Width, Height: single);

// Helper routine to draw a rounded rect
procedure PolyDrawRoundedRect(const Points: ArrayOfArrayOfFPoint; Left, Top, Width, Height,
  CornerWidth, CornerHeight, Scale: single);

// Helper routine to convert a TFloatpoint polygon into a set of fill and outline
// TFixed polygons (TPolygon32). FFill and possibly FOutline are created, so take
// care to free them in caller code!
procedure FloatToFixedPolygons(const Points: ArrayOfArrayOfFPoint; const Trans:
  TdtpMatrix; var FFill: TdtpPolygon; var FOutline: TdtpPolygon; UseOutline, Closed: boolean; LineWidth: single);

// Some additions so we can draw stippled polylines
procedure PolyPolylineXSP(Bitmap: TdtpBitmap; const Points: TdtpArrayOfArrayOfFixedPoint;
  Color: TdtpColor; Closed: Boolean = False);

procedure PolylineXSP(Bitmap: TdtpBitmap; const Points: TdtpArrayOfFixedPoint;
  Color: TdtpColor; Closed: Boolean);

// Calculate Division + 1 quadpoints on the first 90 degrees of unity circle
procedure QuadrantPoints(SquareLength: single; var Quads: ArrayOfFPoint; var Division: integer);

implementation

uses
  dtpDocument, dtpCommand;

procedure PolyDrawRect(const Points: ArrayOfArrayOfFPoint; Left, Top, Width, Height: single);
// Helper routine to draw a rectangle

  // local
  procedure Add(X, Y: single);
  var
    H, L: integer;
    P: TdtpPoint;
  begin
    P := dtpPoint(X, Y);
    H := High(Points);
    L := Length(Points[H]);
    SetLength(Points[H], L + 1);
    Points[H][L] := P;
  end;
// main
begin
  // Build total circumference.. start at lefttop
  Add(Left,         Top);
  Add(Left + Width, Top);
  Add(Left + Width, Top + Height);
  Add(Left,         Top + Height);
end;

procedure PolyDrawRoundedRect(const Points: ArrayOfArrayOfFPoint; Left, Top, Width, Height,
  CornerWidth, CornerHeight, Scale: single);
// Helper routine to draw a rounded rect
var
  i, ADiv: integer;
  AQuad: ArrayOfFPoint;
  // local
  procedure Add(X, Y: single);
  var
    H, L: integer;
    P: TdtpPoint;
  begin
    P := dtpPoint(X, Y);
    H := High(Points);
    L := Length(Points[H]);
    SetLength(Points[H], L + 1);
    Points[H][L] := P;
  end;
// main
begin
  // Pass longest side length (for a circle these are equal.. take worst case for ellipse)
  QuadrantPoints(Max(CornerWidth, CornerHeight) * Scale, AQuad, ADiv);
  // Calculate the rounded corner points
  for i := 0 to ADiv do
  begin
    AQuad[i].X := (1 - AQuad[i].X) * CornerWidth;
    AQuad[i].Y := (1 - AQuad[i].Y) * CornerHeight;
  end;

  // Build total circumference.. start at lefttop
  for i := 0 to ADiv do
    Add(Left + AQuad[i].X, Top + AQuad[i].Y);
  for i := ADiv downto 0 do
    Add(Left + Width - AQuad[i].X, Top + AQuad[i].Y);
  for i := 0 to ADiv do
    Add(Left + Width - AQuad[i].X, Top + Height - AQuad[i].Y);
  for i := ADiv downto 0 do
    Add(Left + AQuad[i].X, Top + Height - AQuad[i].Y);
end;

procedure FloatToFixedPolygons(const Points: ArrayOfArrayOfFPoint; const Trans:
  TdtpMatrix; var FFill: TdtpPolygon; var FOutline: TdtpPolygon; UseOutline, Closed: boolean; LineWidth: single);
// Helper routine to convert a TFloatpoint polygon into a set of fill and outline
// TFixed polygons (TPolygon32). FFill and possibly FOutline are created, so take
// care to free them in caller code!
var
  i, j: integer;
  ALine: TdtpArrayOfFixedPoint;
  F, P: TdtpPoint;
  APoly: TdtpPolygon;
begin
  // Create fill
  FFill := TdtpPolygon.Create;
  FFill.AntiAliased := True;
  dtpSetPolyFillMode(FFill, dtppfAlternate);
  FFill.Closed := Closed;

  // Copy our data to the FFill
  for i := 0 to high(Points) do
  begin
    // Copy one line
    SetLength(ALine, Length(Points[i]));
    for j := 0 to High(Points[i]) do
    begin
      // Calculate transformed point
      P := Points[i, j];
      F.X := Trans.A * P.X + Trans.C * P.Y + Trans.E;
      F.Y := Trans.B * P.X + Trans.D * P.Y + Trans.F;
      ALine[j] := dtpFixedPoint(F.X, F.Y);
    end;
    // and put it into the draw poly
    FFill.AddPoints(ALine[0], Length(ALine));
    FFill.NewLine;
  end;
  // Copy to FOutline if we need it
  if UseOutline and (LineWidth > 0) then
  begin
    APoly := FFill.Outline;
    APoly.Antialiased := True;
    dtpSetPolyFillMode(APoly, dtppfWinding);
    APoly.Closed := Closed;
    FOutline := APoly.Grow(round(LineWidth * Trans.A * 0.5 * $10000), 0.5);
    FreeAndNil(APoly);
  end;
end;

procedure PolyPolylineXSP(Bitmap: TdtpBitmap; const Points: TdtpArrayOfArrayOfFixedPoint;
  Color: TdtpColor; Closed: Boolean = False);
var
  I: Integer;
begin
  for I := 0 to High(Points) do
    PolylineXSP(Bitmap, Points[I], Color, Closed);
end;

procedure PolylineXSP(Bitmap: TdtpBitmap; const Points: TdtpArrayOfFixedPoint; Color: TdtpColor; Closed: Boolean);
var
  I, Count: Integer;
begin
  Count := Length(Points);
  if (Count = 1) and Closed then
    Bitmap.PixelXS[Points[0].X, Points[0].Y] := Color;
  if Count < 2 then
    Exit;
  Bitmap.BeginUpdate;
  Bitmap.PenColor := Color;
  Bitmap.MoveToX(Points[0].X, Points[0].Y);
  for I := 1 to Count - 1 do
    Bitmap.LineToXSP(Points[I].X, Points[I].Y);
  if Closed then
    Bitmap.LineToXSP(Points[0].X, Points[0].Y);
  Bitmap.EndUpdate;
  Bitmap.Changed;
end;

procedure QuadrantPoints(SquareLength: single; var Quads: ArrayOfFPoint; var Division: integer);
// Calculate Division + 1 quadpoints on the first 90 degrees of unity circle
var
  i: integer;
  ALength, A: single;
  ASin, ACos: extended;
begin
  // Length along the curve (for a circle.. take worst case for ellipse)
  ALength := 0.5 * pi * SquareLength;

  // The empirical formula below states how many segments we need in order to
  // draw a circle with lines and still make it look like a circle.
  if ALength <= 0.5 then
    // Very small distances, less than half pixel: just a straight line
    Division := 1
  else if ALength < 3 then
    // Smaller than 3 pixels: just 2 lines
    Division := 2
  else if ALength < 7 then
    // Smaller than 7 pixels: just 3 lines
    Division := 3
  else if ALength < 100 then
    // Smaller than 100 pixels: use a line for each 5 pixels
    Division := ceil(ALength / 5.0)
  else
    // Bigger than 100 pixels: use a line for each 10 pixels
    Division := ceil(ALength / 10.0);

  // Calculate the quadrant points
  SetLength(Quads, Division + 1);
  Quads[0].X := 1;
  Quads[0].Y := 0;
  for i := 1 to Division - 1 do
  begin
    A := (i / Division) * 0.5 * pi;
    SinCos(A, ASin, ACos);
    Quads[i].X := ACos;
    Quads[i].Y := ASin;
  end;
  Quads[Division].X := 0;
  Quads[Division].Y := 1;
end;

{ TdtpPolygonShape }

procedure TdtpPolygonShape.Add(const P: TdtpPoint);
var
  H, L: Integer;
begin
  H := High(FPts);
  L := Length(FPts[H]);
  SetLength(FPts[H], L + 1);
  FPts[H][L] := P;
end;

procedure TdtpPolygonShape.Add(const X, Y: single);
begin
  Add(dtpPoint(X, Y));
end;

function TdtpPolygonShape.BoundingBox: TdtpRect;
var
  i, j: integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  // Find maxima & minima
  for i := 0 to High(FPts) do
  begin
    for j := 0 to High(FPts[i]) do
    begin
      if (i = 0) and (j = 0) then
      begin
        Result.Left   := FPts[i][j].X;
        Result.Right  := FPts[i][j].X;
        Result.Top    := FPts[i][j].Y;
        Result.Bottom := FPts[i][j].Y;
      end else
      begin
        Result.Left   := Min(Result.Left  , FPts[i][j].X);
        Result.Right  := Max(Result.Right , FPts[i][j].X);
        Result.Top    := Min(Result.Top   , FPts[i][j].Y);
        Result.Bottom := Max(Result.Bottom, FPts[i][j].Y);
      end;
    end;
  end;
end;

procedure TdtpPolygonShape.Clear;
begin
  ClearPolygon;
  inherited;
end;

procedure TdtpPolygonShape.ClearPolygon;
begin
  FPts := nil;
  SetLength(FPts, 1);
  FPts[0] := nil;
end;

constructor TdtpPolygonShape.Create;
begin
  inherited;
  // Owned objects
  ClearPolygon;
  FDrawPolygon := TdtpPolygon.Create;
  FDrawOutline := TdtpPolygon.Create;
  // Defaults
  FDrawPolygon.AntiAliased := True;
  dtpSetPolyFillMode(FDrawPolygon, dtppfAlternate);
  DocWidth      := cDefaultPolygonWidth;
  DocHeight     := cDefaultPolygonHeight;
  FFillAlpha    := $FF;
  FFillColor    := cDefaultPolygonFillColor;
  FIsClosed     := True;
  FOutlineColor := cDefaultPolygonOutlineColor;
  OutlineWidth  := cDefaultPolygonOutlineWidth; // 0.0 will force a 1pixel line (and stipples)
  FStippleSize  := cDefaultStippleSize;
  FStorePoints  := False;
  FUseOutline   := True;
  FUseFill      := True;
  FUseStipple   := False;
end;

destructor TdtpPolygonShape.Destroy;
begin
  FPts := nil;
  FreeAndNil(FDrawPolygon);
  FreeAndNil(FDrawOutline);
  inherited;
end;

procedure TdtpPolygonShape.DoAnimate;
begin
//NH: This was just for testing: animated stippling effect
{  if FUseStipple then begin
    inc(FStippleCount);
    Invalidate;
  end;}
end;

procedure TdtpPolygonShape.FitToRectangle(ARect: TdtpRect);
var
  B: TdtpRect;
  ScaleX, ScaleY: single;
begin
  B := BoundingBox;
  Offset(-B.Left, -B.Top);
  if (B.Right > B.Left) and (B.Bottom > B.Top) and (ARect.Right > ARect.Left) and (ARect.Bottom > ARect.Top) then
  begin
    ScaleX := (ARect.Right - ARect.Left) / (B.Right - B.Left);
    ScaleY := (ARect.Bottom - ARect.Top) / (B.Bottom - B.Top);
    ScaleBy(ScaleX, ScaleY);
  end;
  Offset(ARect.Left, ARect.Top);
end;

procedure TdtpPolygonShape.GeneratePoints;
// Here the shape should generate its points based on the loaded properties,
// in case "StorePoints" = False. This is the place to optimize for line
// segment length in circles, bezier, etc
begin
// Default does nothing
{ Demo code:
  ClearPolygon;
  // shape with hole and chamfer for testing
  Add( 0,  0);
  Add( 0, 30);
  Add(20, 30);
  Add(30, 15);
  Add(30,  0);
  // This adds a new polygon
  NewLine;
  Add(10, 14);
  Add(14, 14);
  Add(14, 10);
  Add(10, 10);
  // As an example: we must make sure that our points fall within [0, 0, DocWidth, DocHeight]
  FitToRectangle(FloatRect(0, 0, DocWidth, DocHeight));}
end;

function TdtpPolygonShape.GetLineCount: integer;
// Number of polylines in the poly-polygon
begin
  Result := length(FPts);
end;

function TdtpPolygonShape.GetScale: single;
begin
  if assigned(Transform) then
    Result := Transform.Matrix.A
  else
    // In cases that shape is not yet initialized, we return a reasonable value
    Result := 1;
  //if Result = 0 then Result := 1;
end;

function TdtpPolygonShape.IsEmpty: boolean;
begin
  Result := True;
  if Length(FPts) = 0 then exit;
  if (Length(FPts) = 1) and (Length(FPts[0]) = 0) then exit;
  Result := False;
end;

procedure TdtpPolygonShape.LoadFromXml(ANode: TXmlNodeOld);
var
  i, j: integer;
  ALines, APoints: TList;
  X, Y: single;
  Sub1, Sub2, Sub3: TXmlNodeOld;
begin
  inherited;
  // Props
  OutlineWidth  := ANode.ReadFloat('OutlineWidth');
  FFillAlpha    := ANode.ReadInteger('FillAlpha');
  FFillColor    := ANode.ReadColor('FillColor');
  FOutlineColor := ANode.ReadColor('OutlineColor');
  FUseFill      := ANode.ReadBool('UseFill');
  FUseOutline   := ANode.ReadBool('UseOutline');
  FUseStipple   := ANode.ReadBool('UseStipple');
  FStippleSize  := ANode.ReadFloat('StippleSize', cDefaultStippleSize);
  FIsClosed     := ANode.ReadBool('IsClosed', True);
  FStorePoints  := ANode.ReadBool('StorePoints', False);

  // Load points
  if FStorePoints then
  begin
    ClearPolygon;
    Sub1 := ANode.NodeByName('Polygon');
    ALines := TList.Create;
    try
      Sub1.NodesByName('Line', ALines);
      // Loop through lines
      for i := 0 to ALines.Count - 1 do
      begin
        Sub2 := TXmlNodeOld(ALines[i]);
        if i > 0 then
          NewLine;
        APoints := TList.Create;
        try
          Sub2.NodesByName('Point', APoints);
          // Loop through points in line
          for j := 0 to APoints.Count - 1 do
          begin
            Sub3 := TXmlNodeOld(APoints[j]);
            begin
              X := Sub3.ReadFloat('X');
              Y := Sub3.ReadFloat('Y');
              Add(X, Y);
            end;
          end;
        finally
          APoints.Free;
        end;
      end;
    finally
      ALines.Free;
    end;
  end else
  begin
    GeneratePoints;
  end;
end;

procedure TdtpPolygonShape.NewLine;
begin
  SetLength(FPts, Length(FPts) + 1);
  FPts[High(FPts)] := nil;
end;

procedure TdtpPolygonShape.Offset(Dx, Dy: single);
var
  i, j: integer;
begin
  if (Dx = 0) and (Dy = 0) then
    exit;
  for i := 0 to High(FPts) do
    for j := 0 to High(FPts[i]) do
    begin
      FPts[i, j].X := FPts[i, j].X + Dx;
      FPts[i, j].Y := FPts[i, j].Y + Dy;
    end;
end;

procedure TdtpPolygonShape.PaintDib(Dib: TdtpBitmap; const Device: TDeviceContext);
begin
  // Check if we must update the draw polygons
  if MustUpdate then
    UpdatePolygons;

  // Set some defaults
  //DIB.Clear(0);
  //DIB.CombineMode := cmMerge;
  if FUseFill then
    FDrawPolygon.DrawFill(DIB, SetAlpha(dtpColor(FFillColor), FillAlpha));

  if FUseOutline then
  begin
    if OutlineWidth = 0 then
    begin
      if not UseStipple then
        FDrawPolygon.DrawEdge(DIB, dtpColor(FOutlineColor))
    end else
      FDrawOutline.DrawFill(DIB, dtpColor(FOutlineColor));
  end;

  if UseStipple then
  begin
    DIB.SetStipple([clWhite32, clWhite32, clWhite32, clWhite32, clBlack32, clBlack32, clBlack32, clBlack32]);
    DIB.StippleStep := 8 / (GetScale * StippleSize);
    DIB.StippleCounter := FStipplecount * DIB.StippleStep * GetScale / 10;

    PolyPolylineXSP(DIB, FDrawPolygon.Points, dtpColor(FOutlineColor), FDrawPolygon.Closed);
  end;

end;

procedure TdtpPolygonShape.SaveToXml(ANode: TXmlNodeOld);
var
  i, j: integer;
  Sub1, Sub2, Sub3: TXmlNodeOld;
begin
  inherited;
  // Props
  ANode.WriteFloat('OutlineWidth', OutlineWidth);
  ANode.WriteInteger('FillAlpha',  FFillAlpha);
  ANode.WriteColor('FillColor',    FFillColor);
  ANode.WriteColor('OutlineColor', FOutlineColor);
  ANode.WriteBool('UseFill',       FUseFill);
  ANode.WriteBool('UseOutline',    FUseOutline);
  ANode.WriteBool('UseStipple',    FUseStipple);
  ANode.WriteFloat('StippleSize',  FStippleSize, cDefaultStippleSize);
  ANode.WriteBool('IsClosed',      FIsClosed, True);
  ANode.WriteBool('StorePoints',   FStorePoints, False);

  // Save points
  if FStorePoints then
  begin
    Sub1 := ANode.NodeNew('Polygon');
    // Loop through lines
    for i := 0 to High(FPts) do
    begin
      Sub2 := Sub1.NodeNew('Line');
      // Loop through points on line
      for j := 0 to High(FPts[i]) do
      begin
        Sub3 := Sub2.NodeNew('Point');
        Sub3.WriteFloat('X', FPts[i, j].X);
        Sub3.WriteFloat('Y', FPts[i, j].Y);
      end;
    end;
  end;
end;

procedure TdtpPolygonShape.ScaleBy(Sx, Sy: single);
var
  i, j: integer;
begin
  for i := 0 to High(FPts) do
    for j := 0 to High(FPts[i]) do
    begin
      FPts[i, j].X := FPts[i, j].X * Sx;
      FPts[i, j].Y := FPts[i, j].Y * Sy;
    end;
end;

procedure TdtpPolygonShape.SetDocSize(AWidth, AHeight: single);
var
  OldWidth, OldHeight: single;
begin
  OldWidth  := DocWidth;
  OldHeight := DocHeight;
  // Change the doc size
  inherited;
  if not FAdjusting and (AWidth > 0) and (AHeight > 0) and (OldWidth > 0) and (OldHeight > 0) then
  begin
    if StorePoints then
    begin
      // Avoid scaling when we're editing and calling this method to adjust around
      // the points
      if not IsEditing then
        // We adjust all points with the new factors
        ScaleBy(DocWidth / OldWidth, DocHeight / OldHeight);
    end else
    begin
      // Otherwise, we generate the points again
      GeneratePoints;
    end;
  end;
end;

procedure TdtpPolygonShape.SetFillAlpha(const Value: cardinal);
begin
  if FFillAlpha <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'FillAlpha', FFillAlpha);
    FFillAlpha := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPolygonShape.SetFillColor(const Value: TColor);
begin
  if FFillColor <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'FillColor', FFillColor);
    FFillColor := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPolygonShape.SetIsClosed(const Value: boolean);
begin
  if FIsClosed <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'IsClosed', FIsClosed);
    FIsClosed := Value;
    if assigned(FDrawPolygon) then
      FDrawPolygon.Closed := FIsClosed;
    MustUpdate := True;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPolygonShape.SetOutlineColor(const Value: TColor);
begin
  if FOutlineColor <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'OutlineColor', FOutlineColor);
    FOutlineColor := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPolygonShape.SetOutlineWidth(const Value: single);
begin
  SetCurbSize(Max(0.1, Value * 0.5));
  if FOutlineWidth <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'OutlineWidth', FOutlineWidth);
    Invalidate;
    FOutlineWidth := Value;
    // We must set the curb sizes accordingly, since the shape's DocBounds are
    // right up to the mid of the lines (so the lines may - and *will* stick
    // out at most half their thickness)
    SetCurbSize(Max(0.1, FOutlineWidth * 0.5));
    MustUpdate := True;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPolygonShape.SetPropertyByName(const AName, AValue: string);
begin
  inherited;
  if AnsiCompareText(AName, 'IsClosed')     = 0 then IsClosed     := BoolFrom(AValue);
  if AnsiCompareText(AName, 'OutlineWidth') = 0 then OutlineWidth := FloatFrom(AValue);
  if AnsiCompareText(AName, 'FillAlpha')    = 0 then FillAlpha    := StrToInt(AValue);
  if AnsiCompareText(AName, 'FillColor')    = 0 then FillColor    := StrToInt(AValue);
  if AnsiCompareText(AName, 'OutlineColor') = 0 then OutlineColor := StrToInt(AValue);
  if AnsiCompareText(AName, 'UseFill')      = 0 then UseFill      := BoolFrom(AValue);
  if AnsiCompareText(AName, 'UseOutline')   = 0 then UseOutline   := BoolFrom(AValue);
  if AnsiCompareText(AName, 'UseStipple')   = 0 then UseStipple   := BoolFrom(AValue);
end;

procedure TdtpPolygonShape.SetStippleSize(const Value: single);
begin
  if FStippleSize <> Value then
  begin
    FStippleSize := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPolygonShape.SetTransformation(const ATrans: TdtpMatrix);
// Whenever the transformation is set, we must update to ensure that our polygon
// matches it
begin
  inherited;
  MustUpdate := True;
end;

procedure TdtpPolygonShape.SetUseFill(const Value: boolean);
begin
  if FUseFill <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'UseFill', FUseFill);
    FUseFill := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPolygonShape.SetUseOutline(const Value: boolean);
begin
  if FUseOutline <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'UseOutline', FUseOutline);
    Invalidate;
    FUseOutline := Value;
    MustUpdate := True;
    Refresh;
    Changed;
  end;
end;

procedure TdtpPolygonShape.SetUseStipple(const Value: boolean);
begin
  if FUseStipple <> Value then
  begin
    FUseStipple := Value;
    Refresh;
    Changed;
  end;
end;

function TdtpPolygonShape.ShapeRegion: HRgn;
// Get the shape region up till pixel accuracy. The region does NOT include the
// 1/2 linewidth outside of the fill region.
var
  i, j, k: integer;
  ALength: integer;
  PointList: array of TPoint;
  VertexList: array of integer;
begin
  // Get total count of points
  ALength := 0;
  for i := 0 to high(FPts) do
    inc(ALength, length(FPts[i]));

  // Reserve mem (will be freed automatically when leaving this function)
  SetLength(PointList, ALength);
  SetLength(VertexList, Length(FPts));
  try

    // Fill
    k := 0;
    for i := 0 to high(FPts) do
    begin
      for j := 0 to high(FPts[i]) do
      begin
        PointList[k] := dtpGraphics.Point(ShapeToScreen(FPts[i, j]));
        inc(k);
      end;
      VertexList[i] := Length(FPts[i]);
    end;

    // Now call the GDI function
    Result := CreatePolyPolygonRgn(PointList[0], VertexList[0], length(FPts), ALTERNATE);
    
  finally
    // thx JF 
    SetLength(PointList, 0);
    SetLength(VertexList, 0);
  end;
end;

procedure TdtpPolygonShape.UpdatePolygons;
//
begin
  // Generate
  if not StorePoints then
    GeneratePoints;

  // free draw and outline polygons first
  FreeAndNil(FDrawPolygon);
  FreeAndNil(FDrawOutline);

  // now generate them
  FloatToFixedPolygons(FPts, Transform.Matrix, FDrawPolygon, FDrawOutline,
    UseOutline, IsClosed, OutlineWidth);

  // reset
  MustUpdate := False;
end;

procedure TdtpPolygonShape.ValidateCurbSizes(var CurbLeft, CurbTop, CurbRight, CurbBottom: single);
var
  B: TdtpRect;
begin
  if not StorePoints then
    GeneratePoints;
  B := BoundingBox;

  if UseOutline then
    InflateRect(B, Max(0.5, OutlineWidth), Max(0.5, OutlineWidth));

  CurbLeft   := Max(CurbLeft, - B.Left);
  CurbTop    := Max(CurbTop, -B.Top);
  CurbRight  := Max(CurbRight, B.Right - DocWidth);
  CurbBottom := Max(CurbBottom, B.Bottom - DocHeight);
  inherited;
end;

{ TdtpEllipseShape }

constructor TdtpEllipseShape.Create;
begin
  inherited;
  InsertCursor := crDtpCrossEllipse;
end;

procedure TdtpEllipseShape.GeneratePoints;
var
  i, ADiv: integer;
  Wdiv2, Hdiv2: single;
  Quads: ArrayOfFPoint;
begin
  ClearPolygon;
  // Length along the curve (for a circle.. take worst case for ellipse)
  QuadrantPoints(2 * pi * Max(DocWidth, DocHeight) * GetScale, Quads, ADiv);
  // Prepare
  Wdiv2 := DocWidth  / 2;
  Hdiv2 := DocHeight / 2;
  for i := 0 to ADiv do
  begin
    Quads[i].X := Quads[i].X * Wdiv2;
    Quads[i].Y := Quads[i].Y * Hdiv2;
  end;
  // 1st quadrant
  for i := 0 to ADiv - 1 do
    Add(Quads[i].X + Wdiv2, Quads[i].Y + Hdiv2);
  // 2nd quadrant
  for i := ADiv downto 1 do
    Add(-Quads[i].X + Wdiv2, Quads[i].Y + Hdiv2);
  // 3rd quadrant
  for i := 0 to ADiv - 1 do
    Add(-Quads[i].X + Wdiv2, -Quads[i].Y + Hdiv2);
  // 4th quadrant
  for i := ADiv downto 1 do
    Add(Quads[i].X + Wdiv2, -Quads[i].Y + Hdiv2);
end;

{ TdtpRectangleShape }

constructor TdtpRectangleShape.Create;
begin
  inherited;
  InsertCursor := crDtpCrossRectangle;
end;

procedure TdtpRectangleShape.GeneratePoints;
begin
  ClearPolygon;
  Add(0,        0);
  Add(0,        DocHeight);
  Add(DocWidth, DocHeight);
  Add(DocWidth, 0);
end;

{ TdtpRoundRectShape }

constructor TdtpRoundRectShape.Create;
begin
  inherited;
  // Defaults
  FCornerWidth  := 0.25 * DocWidth;
  FCornerHeight := 0.25 * DocHeight;
  InsertCursor := crDtpCrossRectangle;
end;

procedure TdtpRoundRectShape.GeneratePoints;
var
  ACornerWidth, ACornerHeight: single;
begin
  ClearPolygon;

  // Limit if neccesary
  if FCornerPropertiesArePercentage then
  begin
    ACornerWidth  := Min(DocWidth  * CornerWidth  / 100, DocWidth  / 2);
    ACornerHeight := Min(DocHeight * CornerHeight / 100, DocHeight / 2);
  end else
  begin
    ACornerWidth  := Min(CornerWidth,  DocWidth  / 2);
    ACornerHeight := Min(CornerHeight, DocHeight / 2);
  end;

  // Use the helper routine to draw
  PolyDrawRoundedRect(FPts, 0, 0, DocWidth, DocHeight, ACornerWidth, ACornerHeight, GetScale);
end;

procedure TdtpRoundRectShape.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FCornerWidth  := ANode.ReadFloat('CornerWidth');
  FCornerHeight := ANode.ReadFloat('CornerHeight');
  FCornerPropertiesArePercentage := ANode.ReadBool('CornerPropertiesArePercentage');
end;

procedure TdtpRoundRectShape.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteFloat('CornerWidth', FCornerWidth);
  ANode.WriteFloat('CornerHeight', FCornerHeight);
  ANode.WriteBool('CornerPropertiesArePercentage',   FCornerPropertiesArePercentage);
end;

procedure TdtpRoundRectShape.SetCornerHeight(const Value: single);
begin
  if FCornerHeight <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'CornerHeight', FCornerHeight);
    FCornerHeight := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpRoundRectShape.SetCornerPropertiesArePercentage(
  const Value: boolean);
begin
  if FCornerPropertiesArePercentage <> Value then
  begin
    FCornerPropertiesArePercentage := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpRoundRectShape.SetCornerWidth(const Value: single);
begin
  if FCornerWidth <> Value then
  begin
    AddCmdToUndo(cmdSetProp, 'CornerWidth', FCornerWidth);
    FCornerWidth := Value;
    Refresh;
    Changed;
  end;
end;

procedure TdtpRoundRectShape.SetPropertyByName(const AName, AValue: string);
begin
  inherited;
  if AnsiCompareText(AName, 'CornerWidth') = 0 then
    CornerWidth := FloatFrom(AValue);
  if AnsiCompareText(AName, 'CornerHeight') = 0 then
    CornerHeight := FloatFrom(AValue);
end;

initialization

  RegisterShapeClass(TdtpPolygonShape);
  RegisterShapeClass(TdtpEllipseShape);
  RegisterShapeClass(TdtpRectangleShape);
  RegisterShapeClass(TdtpRoundRectShape);

end.
