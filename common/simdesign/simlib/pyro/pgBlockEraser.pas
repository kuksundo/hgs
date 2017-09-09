{ Project: Pyro
  Module: Pyro Core

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgBlockEraser;

interface

uses
  Classes, SysUtils,
  pgContentProvider, pgBitmap, pgTransform, Pyro, pgColor;

type

  TpgBlockEraser = class(TPersistent)
  private
    FOnStopEraser: TNotifyEvent;
    FMask: TpgBitmap;
    FHotX: integer;
    FHotY: integer;
    FTransform: TpgAffineTransform;
    FBitmap: TpgBitmap;
    FColor: TpgColor32;
    FOnInvalidate: TNotifyEvent;
    FStartX, FStartY: integer;
    procedure SetMask(const Value: TpgBitmap);
  protected
    procedure Stamp(AX, AY: integer);
    procedure Bresenham(X1, Y1, X2, Y2: integer);
    procedure ToContent(Sx, Sy: integer; var Cx, Cy: integer);
    procedure DoInvalidate;
  public
    destructor Destroy; override;
    procedure MouseClick(Sender: TObject; const Mouse: TpgMouseInfo);
    procedure MouseStartDrag(Sender: TObject; const Mouse: TpgMouseInfo);
    procedure MouseCloseDrag(Sender: TObject; const Mouse: TpgMouseInfo);
    procedure MouseDrag(Sender: TObject; const Mouse: TpgMouseInfo);
  published
    // Mask used for erasing, must be an 8bit 1ch bitmap. Hotspot will be the
    // center. The block eraser takes ownership of the bitmap when setting mask.
    property Mask: TpgBitmap read FMask write SetMask;
    // Bitmap on which the eraser works, must be a 4ch 8bit bitmap. This bitmap
    // is not owned by the eraser.
    property Bitmap: TpgBitmap read FBitmap write FBitmap;
    // This event is fired when the eraser stops (right mouse click)
    property OnStopEraser: TNotifyEvent read FOnStopEraser write FOnStopEraser;
    // This event is fired when the bitmap is changed and thus must be invalidated
    property OnInvalidate: TNotifyEvent read FOnInvalidate write FOnInvalidate;
    // Pointer to transformation from content to device
    property Transform: TpgAffineTransform read FTransform write FTransform;
    // Color to use for erasing
    property Color: TpgColor32 read FColor write FColor;
  end;

implementation

{ TpgBlockEraser }

procedure TpgBlockEraser.Bresenham(X1, Y1, X2, Y2: integer);
var
  Tmp: integer;
  x, xi, y, Mx, Dx, Dy, Run: integer;
begin
  // Make sure Y2 >= Y1
  if Y2 < Y1 then
  begin
    Tmp := Y1; Y1 := Y2; Y2 := Tmp;
    Tmp := X1; X1 := X2; X2 := Tmp;
  end;
  Mx := 1;
  if X2 < X1 then
  begin
    X2 := 2 * X1 - X2;
    Mx := -1;
  end;
  Dx := X2 - X1;
  Dy := Y2 - Y1;
  Stamp(X1, Y1);
  if Dy >= Dx then
  begin

    // vertical
    Run := Dy div 2; // bias
    x := X1;
    for y := Y1 + 1 to Y2 do
    begin
      inc(Run, Dx);
      if Run > Dy then
      begin
        inc(x, Mx);
        dec(Run, Dy);
      end;
      Stamp(x, y);
    end;
  end else
  begin

    // horizontal
    Run := Dx div 2;//bias
    y := Y1;
    xi := X1 + Mx;
    for x := X1 + 1 to X2 do
    begin
      inc(Run, Dy);
      if Run > Dx then
      begin
        inc(y);
        dec(Run, Dx);
      end;
      inc(xi, Mx);
      Stamp(xi, y)
    end;
  end;
end;

destructor TpgBlockEraser.Destroy;
begin
  FreeAndNil(FMask);
  inherited;
end;

procedure TpgBlockEraser.DoInvalidate;
begin
  if assigned(FOnInvalidate) then
    FOnInvalidate(Self);
end;

procedure TpgBlockEraser.MouseClick(Sender: TObject; const Mouse: TpgMouseInfo);
var
  Cx, Cy: integer;
begin
  if Mouse.Right then
  begin
    if assigned(FOnStopEraser) then
      FOnStopEraser(Self);
    exit;
  end;
  ToContent(Mouse.X, Mouse.Y, Cx, Cy);
  Stamp(Cx, Cy);
  DoInvalidate;
end;

procedure TpgBlockEraser.MouseCloseDrag(Sender: TObject; const Mouse: TpgMouseInfo);
var
  Cx, Cy: integer;
begin
  ToContent(Mouse.X, Mouse.Y, Cx, Cy);
  Bresenham(FStartX, FStartY, Cx, Cy);
  FStartX := Cx;
  FStartY := Cy;
  DoInvalidate;
end;

procedure TpgBlockEraser.MouseDrag(Sender: TObject; const Mouse: TpgMouseInfo);
var
  Cx, Cy: integer;
begin
  ToContent(Mouse.X, Mouse.Y, Cx, Cy);
  Bresenham(FStartX, FStartY, Cx, Cy);
  FStartX := Cx;
  FStartY := Cy;
  DoInvalidate;
end;

procedure TpgBlockEraser.MouseStartDrag(Sender: TObject; const Mouse: TpgMouseInfo);
begin
  ToContent(Mouse.X, Mouse.Y, FStartX, FStartY);
  Stamp(FStartX, FStartY);
  DoInvalidate;
end;

procedure TpgBlockEraser.SetMask(const Value: TpgBitmap);
begin
  if FMask <> Value then
  begin
    FreeAndNil(FMask);
    FMask := Value;
    FHotX := FMask.Width div 2;
    FHotY := FMask.Height div 2;
  end;
end;

procedure TpgBlockEraser.Stamp(AX, AY: integer);
var
  x, y, bx, by, W, H: integer;
  S: TpgColor32;
begin
  if not assigned(FMask) or not assigned(FBitmap) then
    exit;
  W := FBitmap.Width;
  H := FBitmap.Height;

  // Stamp the Mask into Bitmap at location AX, AY
  for y := 0 to Mask.Height - 1 do
  begin
    by := AY + y - FHotY;
    if (by < 0) or (by >= H) then
      continue;
    for x := 0 to Mask.Width - 1 do
    begin
      bx := AX + x - FHotX;
      if (bx < 0) or (bx >= W) then
        continue;
      S := FBitmap.Pixels[bx, by];
      FBitmap.Pixels[bx, by] := pgColorBlend32(@S, @FColor, PByte(Mask.Elements[x,y])^);
    end;
  end;

end;

procedure TpgBlockEraser.ToContent(Sx, Sy: integer; var Cx, Cy: integer);
var
  S: TpgPoint;
  C: TpgPoint;
begin
  S := pgPoint(Sx, Sy);
  if assigned(FTransform) then
    FTransform.InverseTransform(S, C)
  else
    C := S;

  Cx := round(C.X);
  Cy := round(C.Y);
end;

end.
