{ Paint helper in order to paint the original DOS commands in M$ Windows

  author: Nils Haeck
  date:   14jun2011
  copyright 2011 SimDesign BV
}
unit sdPaintHelper;

interface

uses
  Classes, Graphics;

const
  cDosColorCount = 16;

type

  TDosFillStyle = (SolidFill);
  TDosColor = TColor;
  TDosColors = array[0..cDosColorCount - 1] of TDosColor;
  TDosPlacement = (CenterText);

const

  // the DOS color palette - must check
  Color: TDosColors =
    (clWhite, clBlue, clLime, clGreen,    // 0  1  2  3
     clAqua, clBlack, clBlack, clBlack,    // 4  5  6  7
     clBlack, clYellow, clBlack, clBlack,  // 8  9  10 11
     clBlack, clBlack, clBlack, clBlack);  // 12 13 14 15

type

  TDosMouse = class
    function GetPosition(var AStatus: integer; var X, Y: integer): integer;
    procedure Show;
    procedure Hide;
  end;

  TDosBlock = class
  private
    FDx, FDy: integer;
    FStatus: boolean;
  public
    constructor Init(Dx, Dy: integer; AStatus: boolean);
    function Get(X, Y: integer): integer;
    function Put(X, Y: integer): integer;
  end;

var
  GMouse: TDosMouse;
  DosCanvas: TCanvas;
  CurrentLetter: integer;

// set the current fill style and color
function SetFillStyle(AStyle: TDosFillStyle; AColor: TDosColor): integer;

// set the current color
function SetColor(AColor: TDosColor): integer;

// fill ellipse
function FillEllipse(X, Y, Width, Height: integer): integer;

// draw bar
function DrawBar(X1, Y1, X2,  Y2: integer): integer;

// set letter
function SetLetter(ALetter: integer): integer;

// write text
// note: uses Utf8String instead of addr()
function WriteText(S: Utf8String;  X1, Y1, X2,  Y2: integer; XPlacement, YPlacement: TDosPlacement): integer;

// rectangle
function Rectangle(X1, Y1, X2, Y2: integer): integer;

// write cbox
// note: uses Utf8String instead of addr()
function WriteCBox(S: Utf8String; X1, Y1, X2, Y2: integer; W: integer): integer;

// write box
// note: uses Utf8String instead of addr()
function WriteBox(S: Utf8String; X1, Y1, X2, Y2: integer): integer;

// realtime delay
function RealDelay(MS: longword): integer;

// line
function Line(X1, Y1, X2, Y2: integer): integer;


implementation

uses
  Windows;

function SetFillStyle(AStyle: TDosFillStyle; AColor: TDosColor): integer;
begin
  if AStyle = SolidFill then
    DosCanvas.Brush.Style := bsSolid;
  DosCanvas.Brush.Color := AColor;
  Result := 0;
end;

function SetColor(AColor: TDosColor): integer;
begin
  DosCanvas.Pen.Style := psSolid;
  DosCanvas.Pen.Color := AColor;
  Result := 0;
end;

function FillEllipse(X, Y, Width, Height: integer): integer;
begin
//todo
  Result := 0;
end;

function DrawBar(X1, Y1, X2,  Y2: integer): integer;
begin
  DosCanvas.FillRect(Rect(X1, Y1, X2, Y2));
  Result := 0;
end;

function SetLetter(ALetter: integer): integer;
begin
  CurrentLetter := ALetter;
  Result := 0;
end;

function WriteText(S: Utf8String;  X1, Y1, X2,  Y2: integer; XPlacement, YPlacement: TDosPlacement): integer;
begin
//todo
  Result := 0;
end;

function Rectangle(X1, Y1, X2, Y2: integer): integer;
begin
  DosCanvas.Pen.Style := psSolid;
  DosCanvas.Rectangle(X1, Y1, X2, Y2);
  Result := 0;
end;

function WriteCBox(S: Utf8String;  X1, Y1, X2,  Y2: integer; W: integer): integer;
begin
//todo
  Result := 0;
end;

function WriteBox(S: Utf8String; X1, Y1, X2, Y2: integer): integer;
begin
//todo
  Result := 0;
end;

function RealDelay(MS: longword): integer;
var
  Res: cardinal;
begin
  Res := GetTickCount;
  repeat
  until GetTickCount > Res + MS;
  Result := 0;
end;

function Line(X1, Y1, X2, Y2: integer): integer;
begin
//todo
  Result := 0;
end;

{ TDosMouse }

function TDosMouse.GetPosition(var AStatus, X, Y: integer): integer;
begin
//todo
  AStatus := 0;
  X := 0;
  Y := 0;
  Result := 0;
end;

procedure TDosMouse.Hide;
begin
//todo
end;

procedure TDosMouse.Show;
begin
//todo
end;

{ TDosBlock }

function TDosBlock.Get(X, Y: integer): integer;
begin
//todo
  Result := 0;
end;

constructor TDosBlock.Init(Dx, Dy: integer; AStatus: boolean);
begin
  Create;
  FDx := Dx;
  FDy := Dy;
  FStatus := AStatus;
end;

function TDosBlock.Put(X, Y: integer): integer;
begin
//todo
  Result := 0;
end;

initialization

  GMouse := TDosMouse.Create;

finalization

  GMouse.Free;

end.
