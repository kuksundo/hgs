unit DammenConfig;

interface

uses
  Graphics, Dialogs, Math;

var

  // Derived Global vars
  bmpDambord: TBitmap;

const

  // Global Constants
  cProgName = 'SimDesign International Draughts 2.2';

type

  TClock = class
  public
    function Time(hr,mn,sc,sh: integer): integer; virtual; abstract;
    function Halted: boolean; virtual; abstract;
  end;

{ from former WBasic.pas }

type

{Point object}

  PPoint = ^TPoint;
  TPoint = object
    X, Y: integer;
    Constructor Init(AnX,AnY: integer);
    Constructor SameAs(APoint: TPoint);
    {move/resize}
    procedure Drag(Dx,Dy: integer);
    {information}
    function IsEqualTo(APoint: TPoint): boolean;
    function EqualsZero: boolean;
    {math: result in itself}
    procedure AplusB(A,B: Tpoint);
    procedure AminusB(A,B: TPoint);
    procedure Max(A,B: TPoint);
    procedure Min(A,B: TPoint);
  end;

{TRect object}

  PRect = ^TRect;
  TRect = object
    A, B: TPoint;
    {initialisation}
    constructor Init(ax,ay,bx,by: integer);
    constructor SameAs(PARect: PRect);
    destructor Done; virtual;
    procedure Clip(PARect: PRect); virtual;
    procedure Share(PARect: PRect); virtual;
    procedure MakeEmpty; virtual;
    {move/resize}
    procedure Drag(Dx,Dy: integer); virtual;
    procedure Grow(Dx,Dy: integer); virtual;
    procedure Resize(dax,day,dbx,dby: integer); virtual;
    procedure SetBounds(ax,ay,bx,by: integer); virtual;
    procedure GetBounds(var ax,ay,bx,by: integer); virtual;
    {information}
    function IsEmpty: boolean; virtual;
    function IsInside(P: PRect): boolean; virtual;
    function IsEqualTo(P: PRect): boolean; virtual;
    function HasPoint(P: PPoint): boolean; virtual;
    procedure GetSize(var Size: TPoint); virtual;
  end;

{functions}

procedure BeepError;
procedure BeepOK;

implementation

{Point object}
constructor TPoint.Init;
begin
  X:=AnX;
  Y:=AnY;
end;

constructor TPoint.SameAs;
begin
  X:=APoint.X;
  Y:=Apoint.Y;
end;

function TPoint.IsEqualTo;
begin
  if (X=APoint.X) and (Y=APoint.Y) then
    IsEqualTo:=true
  else
    IsEqualTo:=false;
end;

function TPoint.EqualsZero;
begin
  if (X=0) and (Y=0) then
    EqualsZero:=true
  else
    EqualsZero:=false;
end;

procedure TPoint.Drag;
begin
  X:=X+Dx;
  Y:=Y+Dy;
end;

procedure TPoint.AplusB;
begin
  X:=A.X+B.X;
  Y:=A.Y+B.Y;
end;

procedure TPoint.AminusB;
begin
  X:=A.X-B.X;
  Y:=A.Y-B.Y;
end;

procedure TPoint.Max(A,B: TPoint);
begin
  X:= Math.Max(A.X,B.X);
  Y:= Math.Max(A.Y,B.Y);
end;

procedure TPoint.Min(A,B: TPoint);
begin
  X:= Math.Min(A.X,B.X);
  Y:= Math.Min(A.Y,B.Y);
end;

{Rect object}

constructor TRect.Init;
begin
  A.X:=ax;
  A.Y:=ay;
  B.X:=bx;
  B.Y:=by;
end;

constructor TRect.SameAs;
begin
  A.SameAs(PARect^.A);
  B.SameAs(PARect^.B);
end;

destructor TRect.Done;
begin
end;

procedure TRect.Clip;
begin
  A.Max(A,PARect^.A);
  B.Min(B,PARect^.B);
end;

procedure TRect.Share;
begin
  A.Min(A,PARect^.A);
  B.Max(B,PARect^.B);
end;

procedure TRect.MakeEmpty;
begin
  A.X:=B.X+1;
end;

procedure TRect.Drag;
begin
  A.Drag(Dx,Dy);
  B.Drag(Dx,Dy);
end;

procedure TRect.Grow;
begin
  B.Drag(Dx,Dy);
end;

procedure TRect.Resize;
var gx,gy: integer;
begin
  if (dax<>0) or (day<>0) then
    Drag(dax,day);
  gx:=dbx-dax; gy:=dby-day;
  if (gx<>0) or (gy<>0) then
    Grow(gx,gy);
end;

procedure TRect.SetBounds;
begin
  Drag(ax-A.X,ay-A.Y);
  Grow(bx-B.X,by-B.Y);
end;

procedure TRect.GetBounds;
begin
  ax:=A.X; ay:=A.Y; bx:=B.X; by:=B.Y;
end;

function TRect.IsEmpty;
begin
  IsEmpty:=(A.X>B.X) or (A.Y>B.Y);
end;

function TRect.IsInside;
begin
  IsInside:=False;
  if A.X >= P^.A.X then
    if A.Y >= P^.A.Y then
      if B.X <= P^.B.X then
        if B.Y <= P^.B.Y then
          IsInside:= True;
end;

function TRect.IsEqualTo;
begin
  IsEqualTo:=False;
  if A.IsEqualTo(P^.A) then
    if B.IsEqualTo(P^.B) then
      IsEqualTo:=true;
end;

function TRect.HasPoint;
begin
  HasPoint:=False;
  if A.X <= P^.X then
    if A.Y <= P^.Y then
      if B.X >= P^.X then
        if B.Y >= P^.Y then
          HasPoint:= True;
end;

procedure TRect.GetSize;
begin
  Size.X:=B.X-A.X;
  Size.Y:=B.Y-A.Y;
end;

procedure BeepError;
begin
//todo
end;

procedure BeepOK;
begin
//todo
end;

initialization

finalization

end.
