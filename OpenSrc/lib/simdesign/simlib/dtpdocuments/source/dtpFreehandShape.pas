{
  unit dtpFreehand: implements a freely drawable shape by mouse.

  Project: DTP-Engine

  Creation Date: 28-12-2003
  Version: 1.0

  Modifications:

  Copyright (c) 2003-2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpFreehandShape;

{$i simdesign.inc}

interface

uses
  Types, Classes, Windows, Graphics, dtpPolygonShape, dtpDocument, dtpGraphics, dtpShape,
  dtpDefaults, NativeXmlOld;

type

  // TdtpFreehandShape is a shape that displays a polygon that can be drawn by the
  // user. Mouse movement and buttons are captured when Recording is True.
  TdtpFreehandShape = class(TdtpPolygonShape)
  private
    FAutoRestart: boolean;
    FLastPos: TdtpPoint;
    FRecording: boolean;
    procedure RecalculateBounds;
  protected
    procedure DoEditClose(Accept: boolean); override;
    procedure GeneratePoints; override;
    procedure AddPoint(const APoint: TdtpPoint);
  public
    constructor Create; override;
    procedure Edit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure MouseDown(Left, Right, Shift, Ctrl: boolean; X, Y: integer); override;
    procedure MouseMove(Left, Right, Shift, Ctrl: boolean; X, Y: integer); override;
    procedure MouseUp(Left, Right, Shift, Ctrl: boolean; X, Y: integer); override;
    procedure NewLine; override;
    procedure PaintSelectionBorder(Canvas: TCanvas); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property AutoRestart: boolean read FAutoRestart write FAutoRestart;
    property Recording: boolean read FRecording write FRecording;
  end;

implementation

{ TdtpFreehandShape }

procedure TdtpFreehandShape.AddPoint(const APoint: TdtpPoint);
begin
  Add(APoint);
  RecalculateBounds;
  if MustCache then
    Refresh
  else
    Invalidate;
end;

constructor TdtpFreehandShape.Create;
begin
  inherited;
  // Defaults
  FAutoRestart := True;
  FStorePoints := True;
  IsClosed := False;
  UseFill  := False;
end;

procedure TdtpFreehandShape.DoEditClose(Accept: boolean);
begin
  // If we are a poor empty freehand or not accepted, just delete ourselfs
  if (not Accept or IsEmpty) and assigned(Document) then
  begin
    TdtpDocument(Document).ShapeRemove(Self);
    exit;
  end;

  // Remove empty lines at end
  while High(FPts) >= 0 do
  begin
    if Length(FPts[High(FPts)]) > 1 then
      break;
    // Remove this one
    FPts[High(FPts)] := nil;
    SetLength(FPts, length(FPts) - 1);
  end;
  Invalidate;
  EndUndo;
end;

procedure TdtpFreehandShape.Edit;
begin
  // we do not cancel the edit in this shape class
  BeginUndo;
end;

procedure TdtpFreehandShape.GeneratePoints;
begin
  // We do not generate any points
end;

procedure TdtpFreehandShape.KeyDown(var Key: Word; Shift: TShiftState);
// We can use the keys to terminate the edit state (enter=accept, esc=cancel)
begin
  case Key of
  VK_RETURN, VK_EXECUTE, VK_F2, VK_TAB:
    TdtpDocument(Document).DoEditClose(True);
  VK_SPACE:
    begin
      IsClosed := True;
      TdtpDocument(Document).DoEditClose(True);
    end;
  VK_ESCAPE, VK_CANCEL:
    TdtpDocument(Document).DoEditClose(False);
  end;
end;

procedure TdtpFreehandShape.LoadFromXml(ANode: TXmlNodeOld);
begin
  inherited;
  FAutoRestart := ANode.ReadBool('AutoRestart');
end;

procedure TdtpFreehandShape.MouseDown(Left, Right, Shift, Ctrl: boolean; X, Y: integer);
begin
  if Right = True then
  begin
    // Right button: stop
    TdtpDocument(Document).DoEditClose(True);
    exit;
  end;
  // Mouse down, so we start the freehand recorder
  FRecording := True;
  FLastPos := ScreenToShape(Point(X, Y));
  NewLine;
  AddPoint(FLastPos);
end;

procedure TdtpFreehandShape.MouseMove(Left, Right, Shift, Ctrl: boolean; X, Y: integer);
var
  FNewPos: TdtpPoint;
begin
  if FRecording then
  begin
    // New position
    FNewPos := ScreenToShape(Point(X, Y));

    // Store another point if LastPos - NewPos > threshold
    if sqr(FNewPos.X - FLastPos.X) + sqr(FNewPos.Y - FLastPos.Y) > sqr(cFreehandThreshold) then
    begin
      // Store the point
      FLastPos := FNewPos;
      AddPoint(FLastPos);
    end;
  end;
end;
procedure TdtpFreehandShape.MouseUp(Left, Right, Shift, Ctrl: boolean; X, Y: integer);
var
  FNewPos: TdtpPoint;
begin
  if FRecording then
  begin
    // Store the last position if different
    FNewPos := ScreenToShape(Point(X, Y));
    if (FNewPos.X <> FLastPos.X) or (FNewPos.Y <> FLastPos.Y) then
      AddPoint(FNewPos);

    // Stop recording
    FRecording := False;

    // And terminate
    if assigned(Document) then
    begin

      // Do we autorestart?
      if AutoRestart then with TdtpDocument(Document) do
      begin
        // Do not close, just start a new polygon
        NewLine;
      end else
      begin
        // This closes the current freehand
        TdtpDocument(Document).DoEditClose(True);
      end;

    end;
  end;
end;

procedure TdtpFreehandShape.NewLine;
// Only add a new line if we have at least two points in prev line. If there is
// only 1 point, simply clear it
begin
  if (length(FPts) = 0) then
  begin
    inherited;
    exit;
  end;
  if length(FPts[High(FPts)]) < 2 then
  begin
    FPts[High(FPts)] := nil;
    exit;
  end;
  inherited;
end;

procedure TdtpFreehandShape.PaintSelectionBorder(Canvas: TCanvas);
begin
  // Only paint them if we're not editing
  if not IsEditing then
    inherited;
end;

procedure TdtpFreehandShape.RecalculateBounds;
// Whenever a point gets added, we must recalculate these bounds so that
// the bounds encompass the points
var
  B: TdtpRect;
begin
  B := BoundingBox;
  if (B.Right > B.Left) and (B.Bottom > B.Top) then
  begin
    Offset(-B.Left, -B.Top);
    SetDocBounds(DocLeft + B.Left, DocTop + B.Top, B.Right - B.Left, B.Bottom - B.Top);
  end;
end;

procedure TdtpFreehandShape.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  ANode.WriteBool('AutoRestart', FAutoRestart);
end;

initialization

  RegisterShapeClass(TdtpFreehandShape);

end.
