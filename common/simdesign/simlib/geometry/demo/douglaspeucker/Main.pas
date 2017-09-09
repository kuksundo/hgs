unit Main;
{ Unit Main

  This is a demonstration program for the Douglas-Peucker algorithm

  This file requires the RxLib to be installed. This library is freely
  available from the internet here: http://sourceforge.net/projects/rxlib/

  copyright (c) 2003 Nils Haeck M.Sc. SimDesign

  ****************************************************************
  The contents of this file are subject to the Mozilla Public
  License Version 1.1 (the "License"); you may not use this file
  except in compliance with the License. You may obtain a copy of
  the License at:
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an
  "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
  implied. See the License for the specific language governing
  rights and limitations under the License.

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Contnrs, RXSpin, sdSimplifyPolylineDouglasPeucker, Mask;

type
  TForm1 = class(TForm)
    pbMain: TPaintBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    sePrecision: TRxSpinEdit;
    Label6: TLabel;
    lbNumPtsOrig: TLabel;
    Label7: TLabel;
    lbNumPtsSimple: TLabel;
    Label8: TLabel;
    sePenWidth: TRxSpinEdit;
    Label9: TLabel;
    procedure pbMainPaint(Sender: TObject);
    procedure pbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chbDrawControlsClick(Sender: TObject);
    procedure sePrecisionChange(Sender: TObject);
    procedure sePenWidthChange(Sender: TObject);
  private
    { Private declarations }
    procedure AddPointToCurve(X, Y: integer);
    procedure CreateSimplifiedPolyline;
  public
    OrigList: array of TPoint;
    SimpleList: array of TPoint;
    PosX, PosY: integer;
  end;

var
  Form1: TForm1;

const
  cMinCurveDist = 2.0; // Maximum allowed distance between points in original curve

implementation

{$R *.DFM}

procedure TForm1.AddPointToCurve(X, Y: integer);
var
  APoint: TPoint;
begin
  PosX := X;
  PosY := Y;
  APoint.X := X;
  APoint.Y := Y;
  SetLength(OrigList, Length(OrigList) + 1);
  OrigList[Length(OrigList) - 1] := APoint;
end;

procedure TForm1.pbMainPaint(Sender: TObject);
begin
  with pbMain.Canvas do
  begin
    // Draw original polyline
    if Length(OrigList) > 0 then
    begin
      Pen.Color := clBlack;
      Pen.Width := 1;
      PolyLine(OrigList);
    end;

    // Draw simplification
    if Length(SimpleList) > 0 then
    begin
      Pen.Color := clRed;
      Pen.Width := round(sePenWidth.Value);
      PolyLine(SimpleList);
    end;

  end;
  // Other controls
  lbNumPtsOrig.Caption   := IntToStr(Length(OrigList));
  lbNumPtsSimple.Caption := IntToStr(Length(SimpleList));
end;

procedure TForm1.pbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Delete the old curves
  SetLength(OrigList, 0);
  SetLength(SimpleList, 0);
  // Add the new startpoint
  AddPointToCurve(X, Y);
end;

procedure TForm1.pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i, Count, MedX, MedY: integer;
  Dist: double;
begin
  // Add points to the curve as long as the mouse is down
  if ssLeft in Shift then
  begin
    Dist := sqrt(sqr(X - PosX) + sqr(Y - PosY));
    if Dist >= cMinCurveDist then
    begin
      // For fast mouse movements we should add intermediate points
      Count := trunc(Dist / cMinCurveDist);
      if Count > 1 then
        for i := 1 to Count - 1 do
        begin
          MedX := PosX + round((X - PosX) * i / Count);
          MedY := PosY + round((Y - PosY) * i / Count);
          // Store the intermediate point
          AddPointToCurve(MedX, MedY);
        end;
      // Store the new point
      AddPointToCurve(X, Y);
      pbMain.Invalidate;
    end;
  end;
end;

procedure TForm1.pbMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Mouse is released so finalize the curve
  CreateSimplifiedPolyline;
  pbMain.Invalidate;
end;

procedure TForm1.chbDrawControlsClick(Sender: TObject);
begin
  pbMain.Invalidate;
end;

procedure TForm1.sePrecisionChange(Sender: TObject);
begin
  // We must re-do the approximation
  CreateSimplifiedPolyline;
  pbMain.Invalidate;
end;

procedure TForm1.CreateSimplifiedPolyline;
// Create the simple polyline approximation
var
  ALength: integer;
begin
  // Create the simple polyline approximation
  SetLength(SimpleList, Length(OrigList));
  if length(OrigList) > 2 then
  begin
    ALength := PolySimplifyInt2D(sePrecision.Value, OrigList, SimpleList);
    SetLength(SimpleList, ALength);
  end;
end;

procedure TForm1.sePenWidthChange(Sender: TObject);
begin
  pbMain.Invalidate;
end;

end.
