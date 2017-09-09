{
  Unit dtpW2K3Handles

  dtpW2K3Handles overrides the default handle drawing with handles and draglines
  that mimick MS Word2003 drawing.

  Project: DTP-Engine

  Creation Date: 14-11-2004 (NH)

  Modifications:

  Copyright (c) 2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpW2K3Handles;

{$i simdesign.inc}

interface

uses
  SysUtils, Graphics, dtpHandles;

type

  // This handlepainter mimicks the Word 2003 handles
  TdtpW2K3HandlePainter = class(TdtpHandlePainter)
  public
    procedure CreateBlockHandles; override;
    procedure PaintHandle(Canvas: TCanvas; Index: integer); override;
    procedure PaintSelectionBorder(Canvas: TCanvas); override;
  end;

implementation

uses
  dtpShape;

{ TdtpW2K3HandlePainter }

procedure TdtpW2K3HandlePainter.CreateBlockHandles;
begin
  if not assigned(Shape) then
    raise Exception.Create(shpShapeMustBeAssigned);

  // By default we create 8 handles on the corners plus 1 for rotate
  with TdtpShape(Shape) do begin
    HandleCount := 9;

    // The dragging handles
    Handles[0].Pos.X := 0;
    Handles[0].Pos.Y := 0;
    Handles[0].HitTest := htLT;
    Handles[1].Pos.X := DocWidth/2;
    Handles[1].Pos.Y := 0;
    Handles[1].HitTest := htTop;
    Handles[2].Pos.X := DocWidth;
    Handles[2].Pos.Y := 0;
    Handles[2].HitTest := htRT;
    Handles[3].Pos.X := DocWidth;
    Handles[3].Pos.Y := DocHeight/2;
    Handles[3].HitTest := htRight;
    Handles[4].Pos.X := DocWidth;
    Handles[4].Pos.Y := DocHeight;
    Handles[4].HitTest := htRB;
    Handles[5].Pos.X := DocWidth/2;
    Handles[5].Pos.Y := DocHeight;
    Handles[5].HitTest := htBottom;
    Handles[6].Pos.X := 0;
    Handles[6].Pos.Y := DocHeight;
    Handles[6].HitTest := htLB;
    Handles[7].Pos.X := 0;
    Handles[7].Pos.Y := DocHeight/2;
    Handles[7].HitTest := htLeft;

    // This is the rotation handle
    Handles[HandleCount - 1].Pos.X  := DocWidth  / 2;
    Handles[HandleCount - 1].Pos.Y  := - 5;
    Handles[HandleCount - 1].HitTest := htRotate;

    // We have 5 drag lines, the rectangle surrounding the shape and from shape to
    // rotation handle
    DraglineCount := 5;

    // The Drag lines connect always between two handles, H1 and H2. The value
    // provided is the index into the above handle array. The hittest information
    // is used when the user clicks the drag line.
    Draglines[0].H1 := 0; Draglines[0].H2 := 2;
    Draglines[0].HitTest := htNone;
    DragLines[0].DrawWhenSelect := False;
    Draglines[1].H1 := 2; Draglines[1].H2 := 4;
    Draglines[1].HitTest := htNone;
    DragLines[1].DrawWhenSelect := False;
    Draglines[2].H1 := 4; Draglines[2].H2 := 6;
    Draglines[2].HitTest := htNone;
    DragLines[2].DrawWhenSelect := False;
    Draglines[3].H1 := 6; Draglines[3].H2 := 0;
    Draglines[3].HitTest := htNone;
    DragLines[3].DrawWhenSelect := False;
    Draglines[4].H1 := 1; Draglines[4].H2 := 8;
    Draglines[4].HitTest := htNone;
    DragLines[4].DrawWhenDrag := False;
    DragLines[4].DrawWhenSelect := AllowRotate;
  end;
end;

procedure TdtpW2K3HandlePainter.PaintHandle(Canvas: TCanvas;
  Index: integer);
begin
  if not assigned(Shape) then
    raise Exception.Create(shpShapeMustBeAssigned);

  with Canvas do begin
    Pen.Style := psSolid;
    Brush.Style := bsSolid;
    case Handles[Index].HitTest of
    htRotate:
      if TdtpShape(shape).AllowRotate then begin
        Pen.Color := clBlack;
        Brush.Color := clLime;
        Ellipse(GetHandleRect(Index));
      end;
    htShape..htTop, htPoint:
      begin
        Pen.Color := clBlack;
        Brush.Color := clWhite;
        Ellipse(GetHandleRect(Index));
      end;
    end;
    Brush.Color := clWhite;
  end;
end;

procedure TdtpW2K3HandlePainter.PaintSelectionBorder(Canvas: TCanvas);
var
  i: integer;
begin
  if not assigned(Shape) then
    raise Exception.Create(shpShapeMustBeAssigned);

  // just one line
  with Canvas do begin
    Pen.Color := clBlack;
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;
    Brush.Style := bsClear;
    PaintBorderLines(Canvas);
  end;

  // Handles
  for i := 0 to HandleCount - 1 do
    PaintHandle(Canvas, i);
end;

end.
