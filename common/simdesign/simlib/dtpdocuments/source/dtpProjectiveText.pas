{
  Unit dtpProjectiveText

  Project: DTP-Engine

  Creation Date: 01Sep2004 (NH)
  Version: 1.0
  Contributor: JohnF (JF)

  Modifications:
  23jun2010:
  changed class hierarchy, TdtpProjectiveText now inherits from TdtpTransformText (JF)

  Copyright (c) 2004 - 2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpProjectiveText;

{$i simdesign.inc}

interface

uses

  Classes, dtpShape, dtpPolygonText, dtpGraphics, Math, NativeXmlOld, dtpHandles, dtpTextShape;

type

  // TdtpProjetiveText is a polygon-based text shape that provides 4 draggable
  // corners that can be moved at will by the user, providing a projectively
  // transformed text in the 4-sided polygon. Text is always filled out exactly
  // to the limits of the polygon. FontHeight is calculated as the average height
  // of the shape. By setting FontHeight you can change the size of the shape,
  // It is also possible to set Points at document size at runtime.

  TdtpProjectiveText = class(TdtpTransformText)
  private
    FPoints: array of TdtpPoint; // Position of draggable corners relative to top/left
    FSavedPoints: array of TdtpPoint; //  added by J.F. July 2011
    FSavedDocLeft: single;  //  added by J.F. July 2011
    FSavedTextLength: integer;  //  added by J.F. July 2011
    function GetPoints(Index: integer): TdtpPoint;
    procedure SetPoints(Index: integer; const Value: TdtpPoint);
  protected
    procedure AdjustPoints; virtual;
    procedure CreateHandles; override;
    procedure CalculateCaretPositionsOfSpan(ASpan: TdtpTextSpan; ADpm: single); override; //  added by J.F. July 2011
    procedure DoEditClose(Accept: boolean); override; //  added by J.F. July 2011
    procedure PerformTransformationEffect(AWidth, AHeight: integer); override;
    procedure SetDocSize(AWidth, AHeight: single); override;
    procedure SetText(const Value: widestring);override; //  added by J.F. July 2011
    function GetLineHeight: single; override; //  added by J.F. July 2011
    function GetFontHeight: single; override;
    procedure SetFontHeight(const Value: single); override;
  public
    procedure AcceptDragBorder; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure Edit; override; //  added by J.F. July 2011
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    // Points is an array of 4 TFloatPoint points that are the corners of the
    // projective text. You can drag the corners to any position. Points[i] returns
    // the position in document coordinates of the i-th point. Set Points[i] to
    // a location in document coordinates through code.
    property Points[Index: integer]: TdtpPoint read GetPoints write SetPoints;
  end;

implementation

{ TdtpProjectiveText }

procedure TdtpProjectiveText.CalculateCaretPositionsOfSpan(
  ASpan: TdtpTextSpan; ADpm: single);  //  added by J.F. July 2011
var
  i: integer;
  AText: widestring;
  PolyWidth, PolyHeight: double;
begin
  AText := ASpan.Text;
  if length(AText) = 0 then
    exit;
  inherited;
  GetTextExtent(0,0,PolyWidth, PolyHeight);
  PolyWidth:= PolyWidth / DocWidth;
  for i := 0 to ASpan.CharCount - 1 do
    FCaretPositions[ASpan.CharPos + i - 1].X :=  FCaretPositions[ASpan.CharPos + i - 1].X / PolyWidth;
  FCaretPositions[ASpan.CharPos + ASpan.CharCount - 1].X :=
    FCaretPositions[ASpan.CharPos + ASpan.CharCount - 1].X / PolyWidth;
end;

procedure TdtpProjectiveText.AcceptDragBorder;
// A point was dragged
begin
  if (DragHandle >= 0) and (DragHandle < 4) then
  begin
    Invalidate;
    Points[DragHandle] := Handles[DragHandle].Drag
  end else
    inherited;
end;

procedure TdtpProjectiveText.AdjustPoints;
var
  i: integer;
  B: TdtpRect;
  NewPos: TdtpPoint;
  NewWidth, NewHeight: single;
begin
  if IsAdjusting then
    exit;

  DisableUndo;
  IsAdjusting := True;
  try
    // Find the bounding box around the points
    if (DocWidth * DocHeight > 0) and (length(FPoints) = 4) then
    begin
      B.Left   := FPoints[0].X;
      B.Right  := FPoints[0].X;
      B.Top    := FPoints[0].Y;
      B.Bottom := FPoints[0].Y;
      for i := 1 to 3 do
      begin
        B.Left   := Min(B.Left  , FPoints[i].X);
        B.Right  := Max(B.Right , FPoints[i].X);
        B.Top    := Min(B.Top   , FPoints[i].Y);
        B.Bottom := Max(B.Bottom, FPoints[i].Y);
      end;
      // Calculate new values
      NewPos    := ShapeToParent(dtpPoint(B.Left, B.Top));
      NewWidth  := (B.Right - B.Left);
      NewHeight := (B.Bottom - B.Top);

      // Only adjust if height <> 0
      if NewHeight <> 0 then
      begin
        // Adjust points
        for i := 0 to 3 do
        begin
          FPoints[i].X := FPoints[i].X - B.Left;
          FPoints[i].Y := FPoints[i].Y - B.Top;
        end;
        // This will set the font to fill up vertically
        if NewHeight <> DocHeight then
          // A new fontheight will automatically call "AdjustBounds"
          FontHeight := (NewHeight / DocHeight) * FontHeight
        else
          // otherwise, force update
          AdjustBounds;
        // Set the new bounds
        SetDocBounds(NewPos.X, NewPos.Y, NewWidth, NewHeight);
      end;
    end;
  finally
    EnableUndo;
    IsAdjusting := False;
  end;
end;

constructor TdtpProjectiveText.Create;
begin
  inherited;
  ScaleToTransform := False;
  AutoSize := false;
  // Default size - we need this otherwise the points are all zero
  DocWidth := 40;
  DocHeight := 30;
  // Points
  SetLength(FPoints, 4);
  FPoints[0] := dtpPoint(0,        0);
  FPoints[1] := dtpPoint(DocWidth, 0);
  FPoints[2] := dtpPoint(0,        DocHeight);
  FPoints[3] := dtpPoint(DocWidth, DocHeight);
  SetLength(FSavedPoints, 4); //  added by J.F. July 2011
end;

procedure TdtpProjectiveText.CreateHandles;
var
  i: integer;
begin
  if length(FPoints) <> 4 then
    exit;
  CreateHandleObject;
  // Create the points for the handles
  Handles.HandleCount := 5;
  Handles.DraglineCount := 4;

  // The dragging handles
  for i := 0 to 3 do
  begin
    Handles[i].Pos.X := FPoints[i].X;
    Handles[i].Pos.Y := FPoints[i].Y;
    Handles[i].HitTest := htPoint;
  end;
  // Rotation handle
  Handles[4].Pos.X := (Handles[1].Pos.X + Handles[3].Pos.X)/2 + DocWidth * 0.03;
  Handles[4].Pos.Y := (Handles[1].Pos.Y + Handles[3].Pos.Y)/2;
  Handles[4].HitTest := htRotate;

  // The drag lines
  Handles.Draglines[0].H1 := 0; Handles.DragLines[0].H2 := 1;
  Handles.Draglines[0].HitTest := htTop;
  Handles.Draglines[1].H1 := 1; Handles.DragLines[1].H2 := 3;
  Handles.Draglines[1].HitTest := htRight;
  Handles.Draglines[2].H1 := 3; Handles.DragLines[2].H2 := 2;
  Handles.Draglines[2].HitTest := htBottom;
  Handles.Draglines[3].H1 := 2; Handles.DragLines[3].H2 := 0;
  Handles.Draglines[3].HitTest := htLeft;

end;

destructor TdtpProjectiveText.Destroy;
begin
  FPoints := nil;
  FSavedPoints:= nil; //  added by J.F. July 2011
  inherited;
end;

procedure TdtpProjectiveText.DoEditClose(Accept: boolean);  //  added by J.F. July 2011
begin
  Move(FSavedPoints[0],FPoints[0], length(FPoints) * SizeOf(TdtpPoint));
  AdjustPoints;
  DocLeft:= FSavedDocLeft;
  inherited DoEditClose(Accept);
end;

procedure TdtpProjectiveText.Edit; //  added by J.F. July 2011
begin
  Move(FPoints[0],FSavedPoints[0], length(FPoints) * SizeOf(TdtpPoint));
  FSavedDocLeft:= DocLeft;
  FSavedTextLength:= Length(Text);
  if FPoints[0].X < FPoints[2].X then
    FPoints[2].X:= FPoints[0].X
  else
    FPoints[0].X:= FPoints[2].X;
  if FPoints[1].X < FPoints[3].X then
    FPoints[1].X:= FPoints[3].X
  else
    FPoints[3].X:= FPoints[1].X;
  AdjustPoints;
  inherited;
end;

function TdtpProjectiveText.GetLineHeight: single;  //  added by J.F. July 2011

begin
  Result := DocHeight;
end;

function TdtpProjectiveText.GetFontHeight: single;
begin
  Result := 0;
  if length(FPoints) = 4 then
    Result := (FPoints[2].Y - FPoints[0].Y + FPoints[3].Y - FPoints[1].Y) * 0.5;
end;

function TdtpProjectiveText.GetPoints(Index: integer): TdtpPoint;
// Return the point in document cooordinates
begin
  Result := dtpPoint(0, 0);
  if (Index >= 0) and (Index < length(FPoints)) then
    Result := FPoints[Index];
end;

procedure TdtpProjectiveText.LoadFromXml(ANode: TXmlNodeOld);
var
  i: integer;
  AList: TList;
begin
  inherited;
  AList := TList.Create;
  try
    // Load the 4 points
    if length(FPoints) <> 4 then
      exit;
    ANode.NodesByName('Point', AList);
    for i := 0 to Min(4, AList.Count) - 1 do
    begin
      FPoints[i].X := TXmlNodeOld(AList[i]).ReadFloat('X');
      FPoints[i].Y := TXmlNodeOld(AList[i]).ReadFloat('Y');
    end;
  finally
    AList.Free;
  end;
end;

procedure TdtpProjectiveText.PerformTransformationEffect(AWidth, AHeight: integer);
var
  i, j: integer;
  P0, P1, P2, P3, C1, C2: TdtpFixedPoint;
  A, B: TFixed;
begin
  if length(FPoints) <> 4 then
    exit;
  P0 := dtpFixedPoint(FPoints[0]);
  P1 := dtpFixedPoint(FPoints[1]);
  P2 := dtpFixedPoint(FPoints[2]);
  P3 := dtpFixedPoint(FPoints[3]);
  // Loop through points and compute the transform
  if assigned(FPoly) then with FPoly do
    for i := 0 to high(Points) do
      for j := 0 to high(Points[i]) do
      begin
        B := FixedDiv(Points[i, j].X, AWidth);
        A := $10000 - B;
        C1.X := FixedMul(P0.X, A) + FixedMul(P1.X, B);
        C1.Y := FixedMul(P0.Y, A) + FixedMul(P1.Y, B);
        C2.X := FixedMul(P2.X, A) + FixedMul(P3.X, B);
        C2.Y := FixedMul(P2.Y, A) + FixedMul(P3.Y, B);
        B := FixedDiv(Points[i, j].Y, AHeight);
        A := $10000 - B;
        Points[i, j].X := FixedMul(C1.X, A) + FixedMul(C2.X, B);
        Points[i, j].Y := FixedMul(C1.Y, A) + FixedMul(C2.Y, B);
      end;
end;

procedure TdtpProjectiveText.SaveToXml(ANode: TXmlNodeOld);
var
  i: integer;
begin
  // Save the 4 points
  for i := 0 to 3 do
    with ANode.NodeNew('Point') do
    begin
      WriteFloat('X', FPoints[i].X);
      WriteFloat('Y', FPoints[i].Y);
    end;
  inherited;
end;

procedure TdtpProjectiveText.SetDocSize(AWidth, AHeight: single);
var
  i: integer;
  ScaleX, ScaleY: double;
begin
  if (DocWidth * DocHeight > 0) then
  begin
    ScaleX := AWidth / DocWidth;
    ScaleY := AHeight / DocHeight;
  end else
  begin
    ScaleX := 1;
    ScaleY := 1;
  end;

  // The standard method
  inherited;

  // Now check if we must adapt points
  if not IsAdjusting and (length(FPoints) = 4) and ((ScaleX <> 1) or (ScaleY <> 1)) then
  begin
    // Setting document size means we must also scale the points
    Invalidate;
    for i := 0 to 3 do
    begin
      FPoints[i].X := FPoints[i].X * ScaleX;
      FPoints[i].Y := FPoints[i].Y * ScaleY;
    end;
    AdjustPoints;
    Changed;
  end;
end;

procedure TdtpProjectiveText.SetFontHeight(const Value: single);
var
  Scale: double;
begin
  if IsAdjusting then
    inherited
  else
    if (Value <> FontHeight) and (FontHeight <> 0) then
    begin
      Scale := Value / FontHeight;
      SetDocBounds(DocLeft, DocTop, DocWidth * Scale, DocHeight * Scale);
    end;
end;

procedure TdtpProjectiveText.SetPoints(Index: integer;
  const Value: TdtpPoint);
begin
  if (Index >= 0) and (Index < 4) then
  begin
    FPoints[Index] := Value;
    Invalidate;
    AdjustPoints;
    Regenerate;
    Changed;
  end;
end;

procedure TdtpProjectiveText.SetText(const Value: widestring); //  added by J.F. July 2011
var
  Change: single;
  NewPoint: TdtpPoint;
begin
  if Text <> Value then
  begin
    inherited SetText(Value);
    if IsEditing then
    begin
      Change:= Length(Text) / FSavedTextLength;
      NewPoint:= FPoints[1];
      NewPoint.X:= FPoints[1].X * Change;
      Points[1]:= NewPoint;
      NewPoint:= FPoints[3];
      NewPoint.X:= FPoints[3].X * Change;
      Points[3]:= NewPoint;
      FSavedPoints[1].X:=  FSavedPoints[1].X * Change;
      FSavedPoints[3].X:=  FSavedPoints[3].X * Change;
      FSavedTextLength:= Length(Value);
    end;
  end;
end;

initialization

  RegisterShapeClass(TdtpProjectiveText);

end.
