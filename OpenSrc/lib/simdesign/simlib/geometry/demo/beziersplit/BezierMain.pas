{
  unit BezierMain

  This demo program shows how to split bezier curves at the point that is
  closest to the mouse.

  Author: Nils Haeck M.Sc.

  Copyright (c) 2005 - 2007 by Nils Haeck M.Sc. (Simdesign)
  Visit us at http://www.simdesign.nl

  This code is for demonstrational purposes only. You may NOT use it in any
  commercial or freeware project, unless with SPECIFIC permission from the author.

}
unit BezierMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, sdBeziers, ComCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    pbMain: TPaintBox;
    btnDrawRandomBezier: TButton;
    chbFollowMouse: TCheckBox;
    lbSteps: TLabel;
    Label4: TLabel;
    lbDist: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    udTolerance: TUpDown;
    chbControlPoints: TCheckBox;
    procedure btnDrawRandomBezierClick(Sender: TObject);
    procedure pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    ABezier: TsdBezier;
    APoint: TsdPoint;
    procedure DrawBezier;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnDrawRandomBezierClick(Sender: TObject);
var
  i: integer;
begin
  // Get 4 random points for the bezier curve (End-Control-Control-End)
  Randomize;
  for i := 0 to 3 do
  begin
    ABezier.P[i].X := Random(pbMain.Width);
    ABezier.P[i].Y := Random(pbMain.Height);
  end;
  APoint.X := Random(pbMain.Width);
  APoint.Y := Random(pbMain.Height);
  // And draw it
  DrawBezier;
end;

procedure TForm1.DrawBezier;
var
  P: array[0..3] of TPoint;
  A: double;
  Closest: TsdPoint;
  Steps, pobSteps: integer;
  Dist: double;
  B1, B2: TsdBezier;
  IsOver: boolean;
// Local
procedure PaintcontrolPoints;
var
  i: integer;
begin
  with pbMain.Canvas do
    if chbControlPoints.Checked then
    begin
      Pen.Color := clBlue;
      Pen.Width := 1;
      for i := 0 to 3 do
        Rectangle(Rect(P[i].X - 5, P[i].Y - 5, P[i].X + 5, P[i].Y + 5));
      Pen.Color := clAqua;
      // Move to the first point
      MoveTo(P[0].X, P[0].Y);
      // Line to the second point
      LineTo(P[1].X, P[1].Y);
      // Move to the third point
      MoveTo(P[2].X, P[2].Y);
      // Line to the last point
      LineTo(P[3].X, P[3].Y);
    end;
end;
// Main
begin
  // Find closest point on the bezier to point APoint
  ClosestPointOnBezier(ABezier, APoint, udTolerance.Position, A, Steps, Dist, Closest);

  // Split beziers using factor A
  SplitBezierWithFactor(ABezier, A, B1, B2);

  // Check if point is near bezier - a faster method for determining "MouseOver"
  IsOver := IsPointOnBezier(ABezier, APoint, pobSteps, 5);

  // Update labels
  lbSteps.Caption := Format('Steps (dist,over): %d, %d', [Steps, pobSteps]);
  lbDist.Caption := Format('Distance: %5.1f', [Dist]);

  // Update paintbox
  pbMain.Repaint;
  with pbMain.Canvas do
  begin

    // Paint first half bezier
    Pen.Style := psSolid;
    Pen.Color := clBlack;
    Pen.Width := 2;
    BezierToWindowsFormat(B1, P);
    PolyBezier(P);
    PaintControlPoints;

    // Paint second half bezier
    BezierToWindowsFormat(B2, P);
    Pen.Color := clGray;
    Pen.Width := 2;
    PolyBezier(P);
    PaintControlPoints;

    // Paint dot
    Pen.Style := psClear;
    Brush.Style := bsSolid;
    Brush.Color := clRed;
    Ellipse(round(APoint.X - 3), round(APoint.Y - 3), round(APoint.X + 3), round(APoint.Y + 3));

    // Paint closest
    if IsOver then
      Brush.Color := clLime
    else
      Brush.Color := clGreen;
    Ellipse(round(Closest.X - 5), round(Closest.Y - 5), round(Closest.X + 5), round(Closest.Y + 5));
  end;
end;

procedure TForm1.pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if not chbFollowMouse.Checked then exit;
  APoint.X := X;
  APoint.Y := Y;
  DrawBezier;
end;

end.
