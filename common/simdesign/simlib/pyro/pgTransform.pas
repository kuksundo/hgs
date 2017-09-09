{ Project: Pyro
  Module: Core Document Engine

  Description:
    Document transformations:
    - abstract TpgTransform
    - affine transform (TpgAffineTransform)
    - UV transform (TpgUVTransform)
    - projective transform (TpgProjectiveTransform)
    - curved transform (TpgCurvedTransform)

    Transform List

  TODO: implement function TpgTransformList.ToXForm

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgTransform;

{$i simdesign.inc}

interface

uses
  // delphi
  Classes, SysUtils, Contnrs,
  // simdesign
  sdSortedLists,
  // pyro
  pgStorage, pgGeometry, Pyro;

type

  TpgTransform = class(TPersistent)
  public
    constructor Create; virtual;
    procedure Assign(ASource: TPersistent); override;
    // Concat another transform to this one. By default this raises an exception,
    // must be implemented in descendants
    procedure Concat(ATransform: TpgTransform); virtual;
    // Invert the transform, or return false if not possible
    function Invert: boolean; virtual;
    function GetPixelScale(ADirection: TpgCartesianDirection): double; virtual; abstract;
    // PixelScale is the number of pixels that each unit occupies. It should
    // always return the largest number if there are differences in scale
    // among directions/regions in the valid transformed area
    function PixelScale: double;
    function Transform(const APoint: TpgPoint): TpgPoint; virtual; abstract;
    // Do an inverse transform of APoint, and put result in AInverse. If the inverse
    // transform is not possible, then Result = false.
    function InverseTransform(const APoint: TpgPoint; var AInverse: TpgPoint): boolean; virtual;
    function IsLinear: boolean; virtual; abstract;
    procedure TransformPoints(ASource, ADest: PpgPoint; ACount: integer); virtual;
    procedure Read(AStorage: TpgStorage); virtual; abstract;
    procedure Write(AStorage: TpgStorage); virtual; abstract;
  end;

  TpgTransformClass = class of TpgTransform;

  TpgTransformList = class(TObjectList)
  private
    FOptimizedList: TpgTransformList;
    FBuf1, FBuf2: array of TpgPoint;
    FXForm: TpgXForm;
    function GetItems(Index: integer): TpgTransform;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    procedure InternalTransformPoints(ASource, ADest: PpgPoint; ACount: integer);
    function CanOptimize: boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // Concat a transform (add at the end) to the list. Concat can be called with nil,
    // in this case no transform is added
    procedure Concat(ATransform: TpgTransform);
    // Precat a transform (insert at the start) to the list. Precat can be called with nil,
    // in this case no transform is added
    procedure Precat(ATransform: TpgTransform);
    // Transform a point APoint trhough all the transforms in the list, result is
    // given as function result.
    function Transform(const APoint: TpgPoint): TpgPoint;
    // Inverse-transform a point APoint through all transforms in the list (backwards),
    // result is given in AInverse. If the function returns "false" this is because
    // one or more of the transforms in the list is uninvertible.
    function InverseTransform(const APoint: TpgPoint; var AInverse: TpgPoint): boolean;
    procedure TransformPoints(ASource, ADest: PpgPoint; ACount: integer);
    // Create a transform list that is optimized: it concats all affine transforms
    function CreateOptimizedList: TpgTransformList;
    // Invert the transformlist
    procedure Invert;
    // Is the total resulting transform linear?
    function IsLinear: boolean;
    // Get the combined pixel scale of all transforms for given direction
    function GetPixelScale(ADirection: TpgCartesianDirection): double;
    function PixelScale: double;
    procedure Invalidate;
    // Convert to pgGeometry.XForm. TODO!
    function ToXForm: TpgXForm;
    property Items[Index: integer]: TpgTransform read GetItems; default;
  end;

  TpgAffineTransform = class(TpgTransform)
  private
    FMatrix: TpgMatrix;
    function GetMatrix: PpgMatrix;
  protected
  public
    constructor Create; override;
    procedure Assign(ASource: TPersistent); override;
    procedure Concat(ATransform: TpgTransform); override;
    procedure Identity;
    function GetPixelScale(ADirection: TpgCartesianDirection): double; override;
    procedure MultiplyMatrix(A, B, C, D, E, F: double);
    // Translate the coordinate system over Tx and Ty in X and Y
    procedure Translate(const Tx, Ty: double);
    // Rotate the coordinate system over angle Angle (degrees!) around point Cx, Cy
    procedure Rotate(const Angle, Cx, Cy: double);
    // Scale the coordinate system with scale factors Sx and Sy in X and Y
    procedure Scale(const Sx, Sy: double);
    // Skew the coordinate system in X with Angle degrees
    procedure SkewX(const Angle: double);
    // Skew the coordinate system in Y with Angle degrees
    procedure SkewY(const Angle: double);
    function Invert: boolean; override;
    function IsLinear: boolean; override;
    function Transform(const APoint: TpgPoint): TpgPoint; override;
    procedure TransformPoints(ASource, ADest: PpgPoint; ACount: integer); override;
    procedure Read(AStorage: TpgStorage); override;
    procedure Write(AStorage: TpgStorage); override;
    // Pointer to the matrix structure
    property Matrix: PpgMatrix read GetMatrix;
  end;

  TpgTransformInfo = class(TPersistent)
  private
    FId: longword;
    FName: Utf8String;
    FTransformClass: TpgTransformClass;
  public
    property Id: longword read FId;
    property TransformClass: TpgTransformClass read FTransformClass;
    property Name: Utf8String read FName;
  end;

  // Abstract base class for transforms operating in u,v space (u and v are
  // generalized coordinates between 0 and 1)
  TpgUVTransform = class(TpgTransform)
  private
    FIsValid: boolean;
    FHeight: double;
    FMinY: double;
    FMinX: double;
    FWidth: double;
    procedure SetHeight(const Value: double);
    procedure SetMinX(const Value: double);
    procedure SetMinY(const Value: double);
    procedure SetWidth(const Value: double);
  protected
    procedure UpdateTransform; virtual; abstract;
    function UVMapping: TpgMatrix;
  public
    constructor Create; override;
    procedure Assign(ASource: TPersistent); override;
    procedure Read(AStorage: TpgStorage); override;
    procedure Write(AStorage: TpgStorage); override;
    property IsValid: boolean read FIsValid write FIsValid;
    // MinX of the viewbox mapping into the uv projection
    property MinX: double read FMinX write SetMinX;
    // MinY of the viewbox mapping into the projection
    property MinY: double read FMinY write SetMinY;
    // Width of the viewbox mapping into the projection
    property Width: double read FWidth write SetWidth;
    // Height of the viewbox mapping into the projection
    property Height: double read FHeight write SetHeight;
  end;

  // Projective transformation of domain into a 4-point area described by
  // the points Points[0] through Points[3].
  TpgProjectiveTransform = class(TpgUVTransform)
  private
    FPoints: array[0..3] of TpgPoint;
    FMatrix: TpgMatrix3x3;
    FInverseMatrix: TpgMatrix3x3;
    function GetPoints(Index: integer): PpgPoint;
  protected
    procedure UpdateTransform; override;
  public
    procedure Assign(ASource: TPersistent); override;
    function Invert: boolean; override;
    function GetPixelScale(ADirection: TpgCartesianDirection): double; override;
    function Transform(const APoint: TpgPoint): TpgPoint; override;
    function InverseTransform(const APoint: TpgPoint; var AInverse: TpgPoint): boolean; override;
    function IsLinear: boolean; override;
    procedure TransformPoints(ASource, ADest: PpgPoint; ACount: integer); override;
    procedure Read(AStorage: TpgStorage); override;
    procedure Write(AStorage: TpgStorage); override;
    procedure SetPoint(Index: integer; const Value: TpgPoint);
    // Array of 4 points, P[0] through P[3], describing the 4 corner points of
    // the projection. P[0] corresponds to topleft, P[1] to topright, P[2] to
    // botttomleft, and P[3] to bottomright.
    property Points[Index: integer]: PpgPoint read GetPoints;
  end;

  TpgCurvedTransform = class(TpgProjectiveTransform)
  private
    FDeltaY: double;
    FDeltaX: double;
    FInverted: boolean;
    procedure SetDeltaX(const Value: double);
    procedure SetDeltaY(const Value: double);
  protected
    function CurveTransform(const APoint: TpgPoint): TpgPoint; virtual;
    function InverseCurveTransform(const APoint: TpgPoint): TpgPoint; virtual;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure Read(AStorage: TpgStorage); override;
    procedure Write(AStorage: TpgStorage); override;
    function Invert: boolean; override;
    function InverseTransform(const APoint: TpgPoint; var AInverse: TpgPoint): boolean; override;
    function Transform(const APoint: TpgPoint): TpgPoint; override;
    function IsLinear: boolean; override;
    procedure TransformPoints(ASource, ADest: PpgPoint; ACount: integer); override;
    // Additional offset in X halfway down the height of the box, given in box
    // coordinates
    property DeltaX: double read FDeltaX write SetDeltaX;
    // Additional offset in Y halway down the width of the box, given in box
    // coordinates
    property DeltaY: double read FDeltaY write SetDeltaY;
  end;

  TpgTransformInfoList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TpgTransformInfo;
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    function ById(AId: longword): TpgTransformInfo;
    property Items[Index: integer]: TpgTransformInfo read GetItems; default;
  end;

var

  // global transform info list
  glTransformInfoList: TpgTransformInfoList = nil;


// Utility function that takes ABox, transforms its corner points and constructs
// a box around the result.
function TransformBox(const ABox: TpgBox; ATransform: TpgTransform): TpgBox; overload;
function TransformBox(const ABox: TpgBox; ATransformList: TpgTransformList): TpgBox; overload;

// Utility function to build the viewbox transform from given values.
function BuildViewBoxTransform(PortX, PortY, PortW, PortH: double;
  BoxMinX, BoxMinY, BoxW, BoxH: double;
  APreserveAspect: TpgPreserveAspect;
  AMeetOrSlice: TpgMeetOrSlice): TpgAffineTransform;

function GetTransformInfoById(AId: longword): TpgTransformInfo;
function GetTransformInfoByClass(AClass: TpgTransformClass): TpgTransformInfo;

procedure RegisterTransform(AId: longword; ATransformClass: TpgTransformClass; const AName: Utf8String);

implementation

{ TpgTransform }

procedure TpgTransform.Assign(ASource: TPersistent);
begin
  if not(ASource is TpgTransform) then
    inherited;
end;

procedure TpgTransform.Concat(ATransform: TpgTransform);
begin
  raise Exception.Create(sCannotConcatTransform);
end;

constructor TpgTransform.Create;
begin
  inherited Create;
end;

function TpgTransform.InverseTransform(const APoint: TpgPoint; var AInverse: TpgPoint): boolean;
// Default implementation
var
  T: TpgTransform;
begin
  T := TpgTransformClass(ClassType).Create;
  try

    T.Assign(Self);
    Result := T.Invert;
    if not Result then
      exit;

    AInverse := T.Transform(APoint);

  finally
    T.Free;
  end;
end;

function TpgTransform.Invert: boolean;
begin
  Result := False;
end;

function TpgTransform.PixelScale: double;
begin
  Result := GetPixelScale(cdUnknown);
end;

procedure TpgTransform.TransformPoints(ASource, ADest: PpgPoint; ACount: integer);
var
  i: integer;
begin
  // by default use the TransformPoint
  for i := 0 to ACount - 1 do
  begin
    ADest^ := Transform(ASource^);
    inc(ASource);
    inc(ADest);
  end;
end;

{ TpgAffineTransform }

procedure TpgAffineTransform.Assign(ASource: TPersistent);
begin
  inherited;
  if ASource is TpgAffineTransform then
    FMatrix := TpgAffineTransform(ASource).FMatrix;
end;

procedure TpgAffineTransform.Concat(ATransform: TpgTransform);
begin
  if not assigned(ATransform) then
    exit;

  if ATransform is TpgAffineTransform then
    FMatrix := MatrixMultiply(FMatrix, TpgAffineTransform(ATransform).FMatrix)
  else
    raise Exception.Create(sCannotConcatTransform);
end;

constructor TpgAffineTransform.Create;
begin
  inherited Create;
  FMatrix := cIdentityMatrix;
end;

function TpgAffineTransform.GetMatrix: PpgMatrix;
begin
  Result := @FMatrix;
end;

function TpgAffineTransform.GetPixelScale(ADirection: TpgCartesianDirection): double;
begin
  Result := MatrixScale(FMatrix, ADirection);
end;

procedure TpgAffineTransform.Identity;
begin
  FMatrix := cIdentityMatrix;
end;

function TpgAffineTransform.Invert: boolean;
begin
  if abs(FMatrix.A * FMatrix.D - FMatrix.B * FMatrix.C) < 1E-15 then
    // Det close to 0
    Result := False
  else
  begin
    InvertMatrix(FMatrix);
    Result := True;
  end;
end;

function TpgAffineTransform.IsLinear: boolean;
begin
  Result := True;
end;

procedure TpgAffineTransform.MultiplyMatrix(A, B, C, D, E, F: double);
var
  M: TpgMatrix;
begin
  SetMatrix(M, A, B, C, D, E, F);
  FMatrix := MatrixMultiply(FMatrix, M);
end;

procedure TpgAffineTransform.Read(AStorage: TpgStorage);
begin
  FMatrix.A := AStorage.ReadFloat;
  FMatrix.B := AStorage.ReadFloat;
  FMatrix.C := AStorage.ReadFloat;
  FMatrix.D := AStorage.ReadFloat;
  FMatrix.E := AStorage.ReadFloat;
  FMatrix.F := AStorage.ReadFloat;
end;

procedure TpgAffineTransform.Rotate(const Angle, Cx, Cy: double);
var
  A: double;
  S, C: extended;
  M: TpgMatrix;
begin
  if not ((Cx = 0) and (Cy = 0)) then
    Translate(Cx, Cy);
  A := Angle * pi / 180;
  pgSinCos(A, S, C);
  SetMatrix(M, C, S, -S, C, 0, 0);
  FMatrix := MatrixMultiply(FMatrix, M);
  if not ((Cx = 0) and (Cy = 0)) then
    Translate(-Cx, -Cy);
end;

procedure TpgAffineTransform.Scale(const Sx, Sy: double);
var
  M: TpgMatrix;
begin
  M := cIdentityMatrix;
  M.A := Sx;
  M.D := Sy;
  FMatrix := MatrixMultiply(FMatrix, M);
end;

procedure TpgAffineTransform.SkewX(const Angle: double);
var
  M: TpgMatrix;
begin
  M := cIdentityMatrix;
  M.C := pgTan(Angle * (pi/180));
  FMatrix := MatrixMultiply(FMatrix, M);
end;

procedure TpgAffineTransform.SkewY(const Angle: double);
var
  M: TpgMatrix;
begin
  M := cIdentityMatrix;
  M.B := pgTan(Angle * (pi/180));
  FMatrix := MatrixMultiply(FMatrix, M);
end;

function TpgAffineTransform.Transform(const APoint: TpgPoint): TpgPoint;
begin
  Result := MatrixMulVector(FMatrix, APoint);
end;

procedure TpgAffineTransform.TransformPoints(ASource, ADest: PpgPoint; ACount: integer);
// Do some research here to see if it makes sense to go to single * single multipl
var
  i: integer;
  A, B, C, D, E, F: double;
  Sx, Sy, Dx, Dy: PpgFloat;
begin
  if ACount = 0 then
    exit;

  // Copy locally for speed
  A := FMatrix.A; B := FMatrix.B; C := FMatrix.C;
  D := FMatrix.D; E := FMatrix.E; F := FMatrix.F;
  Sx := @ASource.X;
  Sy := @ASource.Y;
  Dx := @ADest.X;
  Dy := @ADest.Y;
  for i := 0 to ACount - 1 do
  begin
    Dx^ := A * Sx^ + C * Sy^ + E;
    Dy^ := B * Sx^ + D * Sy^ + F;
    // Advance pointers
    inc(Sx, 2);
    inc(Sy, 2);
    inc(Dx, 2);
    inc(Dy, 2);
  end;
end;

procedure TpgAffineTransform.Translate(const Tx, Ty: double);
var
  M: TpgMatrix;
begin
  M := cIdentityMatrix;
  M.E := Tx;
  M.F := Ty;
  FMatrix := MatrixMultiply(FMatrix, M);
end;

procedure TpgAffineTransform.Write(AStorage: TpgStorage);
begin
  AStorage.WriteFloat(FMatrix.A);
  AStorage.WriteFloat(FMatrix.B);
  AStorage.WriteFloat(FMatrix.C);
  AStorage.WriteFloat(FMatrix.D);
  AStorage.WriteFloat(FMatrix.E);
  AStorage.WriteFloat(FMatrix.F);
end;

{ TpgTransformList }

function TpgTransformList.CanOptimize: boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to Count - 2 do
    // Look for two affine transforms in a row
    if (Items[i] is TpgAffineTransform) and (Items[i + 1] is TpgAffineTransform) then
    begin
      Result := True;
      exit;
    end;
end;

procedure TpgTransformList.Concat(ATransform: TpgTransform);
begin
  if not assigned(ATransform) then
    exit;
  Add(ATransform);
end;

constructor TpgTransformList.Create;
begin
  // Since the transforms are usually owned by the transform props, we don't own them
  inherited Create(False);
end;

function TpgTransformList.CreateOptimizedList: TpgTransformList;
var
  i: integer;
  Current: TpgTransform;
begin
  Result := TpgTransformList.Create;
  Result.OwnsObjects := True;
  Current := nil;
  for i := 0 to Count - 1 do
  begin
    if (Current is TpgAffineTransform) and (Items[i] is TpgAffineTransform) then
    begin
      // We can concat all affine transforms
      Current.Concat(Items[i]);
    end else
    begin
      Current := TpgTransformClass(Items[i].ClassType).Create;
      Current.Assign(Items[i]);
      Result.Add(Current);
    end;
  end;
end;

destructor TpgTransformList.Destroy;
begin
  FreeAndNil(FOptimizedList);
  FreeAndNil(FXForm);
  inherited;
end;

function TpgTransformList.GetItems(Index: integer): TpgTransform;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

function TpgTransformList.GetPixelScale(ADirection: TpgCartesianDirection): double;
var
  i: integer;
begin
  Result := 1.0;
  for i := 0 to Count - 1 do
    Result := Result * Items[i].GetPixelScale(ADirection);
end;

procedure TpgTransformList.InternalTransformPoints(ASource, ADest: PpgPoint; ACount: integer);
var
  i: integer;
  B1, B2, T: PpgPoint;
begin
  if ACount = 0 then
    exit;

  case Count of
  0:
    begin
      // Copy source to dest
      if ASource <> ADest then
        System.Move(ASource^, ADest^, ACount * SizeOf(TpgPoint));
    end;
  1:
    begin
      // Create first buffer
      // For just one transform
      if ASource <> ADest then
        B1 := ADest
      else
      begin
        // Make sure to use buffer if in-place
        SetLength(FBuf1, pgMax(length(FBuf1), ACount));
        B1 := @FBuf1[0];
      end;
      Items[0].TransformPoints(ASource, B1, ACount);
      if (B1 <> ADest) then
        System.Move(B1^, ADest^, ACount * SizeOf(TpgPoint));
    end;
  else
    // More than 1 transform: we need two buffers
    SetLength(FBuf1, pgMax(length(FBuf1), ACount));
    SetLength(FBuf2, pgMax(length(FBuf2), ACount));
    // From source to buf1
    B1 := @FBuf1[0];
    B2 := @FBuf2[0];
    Items[Count - 1].TransformPoints(ASource, B1, ACount);
    for i := Count - 2 downto 1 do
    begin
      Items[i].TransformPoints(B1, B2, ACount);
      // Swap buffers
      T := B1; B1 := B2; B2 := T;
    end;
    // Last: from B1 to Dest
    Items[0].TransformPoints(B1, ADest, ACount);
  end;
end;

procedure TpgTransformList.Invalidate;
begin
  FreeAndNil(FOptimizedList);
end;

function TpgTransformList.InverseTransform(const APoint: TpgPoint; var AInverse: TpgPoint): boolean;
var
  i: integer;
begin
  if assigned(FOptimizedList) then
    // We *must* check this as the optimized list might contain the only correct
    // copy after Invert.
    Result := FOptimizedList.InverseTransform(APoint, AInverse)
  else
  begin
    Result := True;
    AInverse := APoint;
    for i := 0 to Count - 1 do
    begin
      Result :=  Items[i].InverseTransform(AInverse, AInverse);
      if not Result then
        exit;
    end;
  end;
end;

procedure TpgTransformList.Invert;
var
  i: integer;
begin
  if OwnsObjects = false then
  begin
    if not assigned(FOptimizedList) then
      CreateOptimizedList;
    FOptimizedList.Invert;
  end else
  begin
    // Here we are working in the optimized list.
    // Reverse list
    for i := 0 to (Count div 2) - 1 do
      Exchange(i, Count - 1 - i);
    // Invert all transforms
    for i := 0 to Count - 1 do
      Items[i].Invert;
  end;
end;

function TpgTransformList.IsLinear: boolean;
var
  i: integer;
begin
  Result := True;
  for i := 0 to Count - 1 do
    if not Items[i].IsLinear then
    begin
      Result := False;
      exit;
    end;
end;

procedure TpgTransformList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  // any changes render the optimized list useless
  Invalidate;
end;

function TpgTransformList.PixelScale: double;
begin
  Result := GetPixelScale(cdUnknown);
end;

procedure TpgTransformList.Precat(ATransform: TpgTransform);
begin
  if not assigned(ATransform) then
    exit;
  Insert(0, ATransform);
end;

function TpgTransformList.ToXForm: TpgXForm;
begin
  // todo!
  FreeAndNil(FXForm);
  FXForm := TpgAffineXForm.Create;
  Result := FXForm;
end;

function TpgTransformList.Transform(const APoint: TpgPoint): TpgPoint;
var
  i: integer;
begin
  if assigned(FOptimizedList) then
    // We *must* check this as the optimized list might contain the only correct
    // copy after Invert.
    Result := FOptimizedList.Transform(APoint)
  else
  begin
    Result := APoint;
    for i := Count - 1 downto 0 do
      Result := Items[i].Transform(Result);
  end;
end;

procedure TpgTransformList.TransformPoints(ASource, ADest: PpgPoint; ACount: integer);
begin
  // do we create an optimized list?
  if (ACount > 4) and not assigned(FOptimizedList) and CanOptimize then
    FOptimizedList := CreateOptimizedList;

  if assigned(FOptimizedList) then
  begin
    // We *must* check this as the optimized list might contain the only correct
    // copy after Invert.
    FOptimizedList.InternalTransformPoints(ASource, ADest, ACount)
  end else
    InternalTransformPoints(ASource, ADest, ACount);
end;

{ TpgTransformInfoList }

function TpgTransformInfoList.ById(AId: longword): TpgTransformInfo;
var
  Index, AMin, AMax: integer;
begin
  // Find position for insert - binary method
  AMin := 0;
  AMax := Count;
  while AMin < AMax do
  begin
    Index := (AMin + AMax) div 2;
    case CompareInteger(Items[Index].FId, AId) of
    -1: AMin := Index + 1;
     0: begin
          Result := Items[Index];
          exit;
        end;
     1: AMax := Index;
    end;
  end;
  Result := nil;
end;

function TpgTransformInfoList.DoCompare(Item1, Item2: TObject): integer;
begin
  Result := CompareInteger(TpgTransformInfo(Item1).FId, TpgTransformInfo(Item2).FId);
end;

function TpgTransformInfoList.GetItems(Index: integer): TpgTransformInfo;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

{ TpgUVTransform }

procedure TpgUVTransform.Assign(ASource: TPersistent);
begin
  inherited;
  if ASource is TpgUVTransform then begin
    FMinX := TpgUVTransform(ASource).FMinX;
    FMinY := TpgUVTransform(ASource).FMinY;
    FWidth := TpgUVTransform(ASource).FWidth;
    FHeight := TpgUVTransform(ASource).FHeight;
    FIsValid := False;
  end;
end;

constructor TpgUVTransform.Create;
begin
  inherited Create;
  FWidth := 1;
  FHeight := 1;
end;

procedure TpgUVTransform.Read(AStorage: TpgStorage);
begin
  FMinX := AStorage.ReadFloat;
  FMinY := AStorage.ReadFloat;
  FWidth := AStorage.ReadFloat;
  FHeight := AStorage.ReadFloat;
end;

procedure TpgUVTransform.SetHeight(const Value: double);
begin
  FHeight := Value;
  FIsValid := False;
end;

procedure TpgUVTransform.SetMinX(const Value: double);
begin
  FMinX := Value;
  FIsValid := False;
end;

procedure TpgUVTransform.SetMinY(const Value: double);
begin
  FMinY := Value;
  FIsValid := False;
end;

procedure TpgUVTransform.SetWidth(const Value: double);
begin
  FWidth := Value;
  FIsValid := False;
end;

function TpgUVTransform.UVMapping: TpgMatrix;
var
  T: TpgAffineTransform;
begin
  // UV matrix
  T := BuildViewboxTransform(0, 0, 1, 1, FMinX, FMinY, FWidth, FHeight, paNone, msUnknown);
  Result := T.Matrix^;
  T.Free;
end;

procedure TpgUVTransform.Write(AStorage: TpgStorage);
begin
  AStorage.WriteFloat(FMinX);
  AStorage.WriteFloat(FMinY);
  AStorage.WriteFloat(FWidth);
  AStorage.WriteFloat(FHeight);
end;

{ TpgProjectiveTransform }

procedure TpgProjectiveTransform.Assign(ASource: TPersistent);
begin
  inherited;
  if ASource is TpgProjectiveTransform then
    Move(TpgProjectiveTransform(ASource).FPoints[0], FPoints[0], 4 * SizeOf(TpgPoint));
end;

function TpgProjectiveTransform.GetPixelScale(ADirection: TpgCartesianDirection): double;
var
  i: integer;
  X, Y: double;
  P: array[0..2] of TpgPoint;
begin
  if not FIsValid then UpdateTransform;
  // Transform 3 points in center of FOV
  P[0] := pgPoint(FMinX + FWidth / 2, FMinY + Height / 2);
  P[1] := P[0]; P[1].X := P[1].X + 0.001;
  P[2] := P[0]; P[2].Y := P[2].Y + 0.001;
  for i := 0 to 2 do
    P[i] := Transform(P[i]);

  X := (P[1].X - P[0].X) * 1000;
  Y := (P[2].Y - P[0].Y) * 1000;

  case ADirection of
  cdHorizontal: Result := abs(X);
  cdVertical:   Result := abs(Y);
  cdUnknown:    Result := sqrt(abs(X * Y));
  else
    Result := 1;
  end;
end;

function TpgProjectiveTransform.GetPoints(Index: integer): PpgPoint;
begin
  Result := @FPoints[Index];
  FIsValid := False;
end;

function TpgProjectiveTransform.InverseTransform(const APoint: TpgPoint; var AInverse: TpgPoint): boolean;
var
  X, Y, Z: double;
begin
  Result := False;
  if not FIsValid then UpdateTransform;

  X := APoint.X; Y := APoint.Y;
  Z := FInverseMatrix[2, 0] * X + FInverseMatrix[2, 1] * Y + FInverseMatrix[2, 2];
  if Z = 0 then Exit
  else if Z = 1 then begin

    AInverse.X := FInverseMatrix[0, 0] * X + FInverseMatrix[0, 1] * Y + FInverseMatrix[0, 2];
    AInverse.Y := FInverseMatrix[1, 0] * X + FInverseMatrix[1, 1] * Y + FInverseMatrix[1, 2];

  end else begin

    Z := 1 / Z;
    AInverse.X := (FInverseMatrix[0, 0] * X + FInverseMatrix[0, 1] * Y + FInverseMatrix[0, 2]) * Z;
    AInverse.Y := (FInverseMatrix[1, 0] * X + FInverseMatrix[1, 1] * Y + FInverseMatrix[1, 2]) * Z;

  end;
  Result := True;
end;

function TpgProjectiveTransform.Invert: boolean;
var
  Temp: TpgMatrix3x3;
begin
  if not FIsValid then UpdateTransform;
  Temp := FMatrix;
  FMatrix := FInverseMatrix;
  FInverseMatrix := Temp;
  Result := True;
end;

function TpgProjectiveTransform.IsLinear: boolean;
begin
  Result := (FMatrix[2, 0] = 0) and (FMatrix[2, 1] = 0);
end;

procedure TpgProjectiveTransform.Read(AStorage: TpgStorage);
var
  i: integer;
begin
  inherited;
  for i := 0 to 3 do begin
    FPoints[i].X := AStorage.ReadFloat;
    FPoints[i].Y := AStorage.ReadFloat;
  end;
end;

procedure TpgProjectiveTransform.SetPoint(Index: integer; const Value: TpgPoint);
begin
  FPoints[Index] := Value;
end;

function TpgProjectiveTransform.Transform(const APoint: TpgPoint): TpgPoint;
var
  X, Y, Z: double;
begin
  if not FIsValid then UpdateTransform;

  X := APoint.X; Y := APoint.Y;

  if IsLinear then begin

    Result.X := FMatrix[0, 0] * X + FMatrix[0, 1] * Y + FMatrix[0, 2];
    Result.Y := FMatrix[1, 0] * X + FMatrix[1, 1] * Y + FMatrix[1, 2];

  end else begin

    Z := FMatrix[2, 0] * X + FMatrix[2, 1] * Y + FMatrix[2, 2];
    if Z = 0 then Exit;
    Z := 1 / Z;

    Result.X := (FMatrix[0, 0] * X + FMatrix[0, 1] * Y + FMatrix[0, 2]) * Z;
    Result.Y := (FMatrix[1, 0] * X + FMatrix[1, 1] * Y + FMatrix[1, 2]) * Z;

  end;
end;

procedure TpgProjectiveTransform.TransformPoints(ASource, ADest: PpgPoint; ACount: integer);
var
  i: integer;
  X, Y, Z, M00, M01, M02, M10, M11, M12, M20, M21, M22: double;
begin
  if not FIsValid then UpdateTransform;

  // Cache matrix elements
  M00 := FMatrix[0, 0];
  M01 := FMatrix[0, 1];
  M02 := FMatrix[0, 2];
  M10 := FMatrix[1, 0];
  M11 := FMatrix[1, 1];
  M12 := FMatrix[1, 2];

  if IsLinear then
  begin

    for i := 0 to ACount - 1 do
    begin
      X := ASource.X; Y := ASource.Y;
      ADest.X := M00 * X + M01 * Y + M02;
      ADest.Y := M10 * X + M11 * Y + M12;
      inc(ASource);
      inc(ADest);
    end;

  end else
  begin

    M20 := FMatrix[2, 0];
    M21 := FMatrix[2, 1];
    M22 := FMatrix[2, 2];

    for i := 0 to ACount - 1 do
    begin
      X := ASource.X; Y := ASource.Y;
      Z := M20 * X + M21 * Y + M22;
      if Z = 0 then continue;
      Z := 1 / Z;
      ADest.X := (M00 * X + M01 * Y + M02) * Z;
      ADest.Y := (M10 * X + M11 * Y + M12) * Z;
      inc(ASource);
      inc(ADest);
    end;

  end;
end;

procedure TpgProjectiveTransform.UpdateTransform;
var
  Dx1, Dx2, Px, Dy1, Dy2, Py: double;
  g, h, k: double;
  R: TpgMatrix3x3;
  M: TpgMatrix;
begin
  Px  := FPoints[0].X - FPoints[1].X + FPoints[2].X - FPoints[3].X;
  Py  := FPoints[0].Y - FPoints[1].Y + FPoints[2].Y - FPoints[3].Y;

  if (abs(px) < 1E-12) and (abs(py) < 1E-12) then
  begin

    // affine mapping
    FMatrix[0, 0] := FPoints[1].X - FPoints[0].X;
    FMatrix[0, 1] := FPoints[2].X - FPoints[1].X;
    FMatrix[0, 2] := FPoints[0].X;

    FMatrix[1, 0] := FPoints[1].Y - FPoints[0].Y;
    FMatrix[1, 1] := FPoints[2].Y - FPoints[1].Y;
    FMatrix[1, 2] := FPoints[0].Y;

    FMatrix[2, 0] := 0;
    FMatrix[2, 1] := 0;
    FMatrix[2, 2] := 1;

  end else
  begin

    // projective mapping
    Dx1 := FPoints[1].X - FPoints[2].X;
    Dx2 := FPoints[3].X - FPoints[2].X;
    Dy1 := FPoints[1].Y - FPoints[2].Y;
    Dy2 := FPoints[3].Y - FPoints[2].Y;
    k := Dx1 * Dy2 - Dx2 * Dy1;
    if k <> 0 then begin

      g := (Px * Dy2 - Py * Dx2) / k;
      h := (Dx1 * Py - Dy1 * Px) / k;

      FMatrix[0, 0] := FPoints[1].X - FPoints[0].X + g * FPoints[1].X;
      FMatrix[0, 1] := FPoints[3].X - FPoints[0].X + h * FPoints[3].X;
      FMatrix[0, 2] := FPoints[0].X;

      FMatrix[1, 0] := FPoints[1].Y - FPoints[0].Y + g * FPoints[1].Y;
      FMatrix[1, 1] := FPoints[3].Y - FPoints[0].Y + h * FPoints[3].Y;
      FMatrix[1, 2] := FPoints[0].Y;

      FMatrix[2, 0] := g;
      FMatrix[2, 1] := h;
      FMatrix[2, 2] := 1;

    end else
    begin

      FillChar(FMatrix, SizeOf(FMatrix), 0);

    end;
  end;

  // UV matrix
  M := UVMapping;
  R := Matrix2x3To3x3(M);
  FMatrix := MatrixMultiply3x3(FMatrix, R);

  FInverseMatrix := FMatrix;
  InvertMatrix3x3(FInverseMatrix);

  FIsValid := True;
end;

procedure TpgProjectiveTransform.Write(AStorage: TpgStorage);
var
  i: integer;
begin
  inherited;
  for i := 0 to 3 do begin
    AStorage.WriteFloat(FPoints[i].X);
    AStorage.WriteFloat(FPoints[i].Y);
  end;
end;

{ TpgCurvedTransform }

procedure TpgCurvedTransform.Assign(ASource: TPersistent);
begin
  inherited;
  if ASource is TpgCurvedTransform then begin
    FDeltaX := TpgCurvedTransform(ASource).FDeltaX;
    FDeltaY := TpgCurvedTransform(ASource).FDeltaY;
  end;
end;

function TpgCurvedTransform.CurveTransform(const APoint: TpgPoint): TpgPoint;
var
  u, v: double;
begin
  if (FWidth = 0) or (FHeight = 0) or ((FDeltaX = 0) and (FDeltaY = 0))then
  begin
    Result := APoint;
    exit;
  end;
  if FDeltaX = 0 then
    Result.X := APoint.X
  else
  begin
    v := (APoint.Y - FMinY) / FHeight;
    Result.X := APoint.X + FDeltaX * (1 - 4 * sqr(v - 0.5));
  end;
  if FDeltaY = 0 then
    Result.Y := APoint.Y
  else
  begin
    u := (APoint.X - FMinX) / FWidth;
    Result.Y := APoint.Y + FDeltaY * (1 - 4 * sqr(u - 0.5));
  end;
end;

function TpgCurvedTransform.InverseCurveTransform(
  const APoint: TpgPoint): TpgPoint;
var
  u, v: double;
begin
  if (FWidth = 0) or (FHeight = 0) or ((FDeltaX = 0) and (FDeltaY = 0))then
  begin
    Result := APoint;
    exit;
  end;
  if FDeltaX = 0 then
    Result.X := APoint.X
  else
  begin
    v := (APoint.Y - FMinY) / FHeight;
    Result.X := APoint.X - FDeltaX * (1 - 4 * sqr(v - 0.5));
  end;
  if FDeltaY = 0 then
    Result.Y := APoint.Y
  else
  begin
    u := (APoint.X - FMinX) / FWidth;
    Result.Y := APoint.Y - FDeltaY * (1 - 4 * sqr(u - 0.5));
  end;
end;

function TpgCurvedTransform.InverseTransform(const APoint: TpgPoint; var AInverse: TpgPoint): boolean;
begin
  Result := inherited InverseTransform(APoint, AInverse);
  AInverse := InverseCurveTransform(AInverse);
end;

function TpgCurvedTransform.Invert: boolean;
begin
  FInverted := not FInverted;
  Result := True;
end;

function TpgCurvedTransform.IsLinear: boolean;
begin
  Result := inherited IsLinear;
  if not Result then exit;
  Result := (FDeltaX = 0) and (FDeltaY = 0);
end;

procedure TpgCurvedTransform.Read(AStorage: TpgStorage);
begin
  inherited;
  FDeltaX := AStorage.ReadFloat;
  FDeltaY := AStorage.ReadFloat;
end;

procedure TpgCurvedTransform.SetDeltaX(const Value: double);
begin
  FDeltaX := Value;
  FIsValid := False;
end;

procedure TpgCurvedTransform.SetDeltaY(const Value: double);
begin
  FDeltaY := Value;
  FIsValid := False;
end;

function TpgCurvedTransform.Transform(const APoint: TpgPoint): TpgPoint;
begin
  if FInverted then
    InverseTransform(APoint, Result)
  else
    Result := inherited Transform(CurveTransform(APoint));
end;

procedure TpgCurvedTransform.TransformPoints(ASource, ADest: PpgPoint; ACount: integer);
var
  i: integer;
begin
  if (not FInverted) and
   ((FWidth = 0) or (FHeight = 0) or ((FDeltaX = 0) and (FDeltaY = 0))) then
  begin
    inherited TransformPoints(ASource, ADest, ACount);
    exit;
  end;
  for i := 0 to ACount - 1 do
  begin
    ADest^ := Transform(ASource^);
    inc(ASource);
    inc(ADest);
  end;
end;

procedure TpgCurvedTransform.Write(AStorage: TpgStorage);
begin
  inherited;
  AStorage.WriteFloat(FDeltaX);
  AStorage.WriteFloat(FDeltaY);
end;

{ functions }

function TransformBox(const ABox: TpgBox; ATransform: TpgTransform): TpgBox;
var
  i: integer;
  IsFirst: boolean;
  Points: array[0..3] of TpgPoint;
begin
  pgBoxToPoints(ABox, @Points[0]);
  if assigned(ATransform) then
    ATransform.TransformPoints(@Points[0], @Points[0], 4);
  IsFirst := True;
  for i := 0 to 3 do
    pgUpdateBox(Result, Points[i], IsFirst);
end;

function TransformBox(const ABox: TpgBox; ATransformList: TpgTransformList): TpgBox;
var
  i: integer;
  IsFirst: boolean;
  Points: array[0..3] of TpgPoint;
begin
  pgBoxToPoints(ABox, @Points[0]);
  if assigned(ATransformList) then
    ATransformList.TransformPoints(@Points[0], @Points[0], 4);
  IsFirst := True;
  for i := 0 to 3 do
    pgUpdateBox(Result, Points[i], IsFirst);
end;

function BuildViewBoxTransform(PortX, PortY, PortW, PortH: double;
  BoxMinX, BoxMinY, BoxW, BoxH: double;
  APreserveAspect: TpgPreserveAspect;
  AMeetOrSlice: TpgMeetOrSlice): TpgAffineTransform;
var
  Scale, ScaleX, ScaleY, XLeft, YTop: double;
begin
  Result := TpgAffineTransform.Create;

  // Viewport transform
  Result.Translate(PortX, PortY);

  // Do we have a viewbox?
  if not ((BoxW = 0) or (BoxH = 0)) then
  begin

    // Scale of individual axes
    ScaleX := PortW / BoxW;
    ScaleY := PortH / BoxH;

    // Do we preserve aspect?
    if APreserveAspect <> paNone then
    begin

      // Meet or slice?
      if AMeetOrSlice = msSlice then
      begin

        // msSlice: take the bigger of scales
        Scale := pgMax(ScaleX, ScaleY);

      end else
      begin

        // msUnknown, msMeet
        Scale := pgMin(ScaleX, ScaleY);

      end;

      // Scale uniformly
      XLeft := PortW - BoxW * Scale;
      YTop  := PortH - BoxH * Scale;

      // Preserve aspect adaptions
      case APreserveAspect of

      paXMinYMin:; // no need to adapt
      paXMidYMin:
        Result.Translate(XLeft / 2, 0);
      paXMaxYMin:
        Result.Translate(XLeft, 0);
      paXMinYMid:
        Result.Translate(0, YTop / 2);
      paXMidYMid:
        Result.Translate(XLeft / 2, YTop / 2);
      paXMaxYMid:
        Result.Translate(XLeft, YTop / 2);
      paXMinYMax:
        Result.Translate(0, YTop);
      paXMidYMax:
        Result.Translate(XLeft / 2, YTop);
      paXMaxYMax:
        Result.Translate(XLeft, YTop);

      end;
      Result.Scale(Scale, Scale);

    end else
    begin

      // Scale separately
      Result.Scale(ScaleX, ScaleY);

    end;

    // Finally translate to MinX MinY at zero
    Result.Translate(-BoxMinX, -BoxMinY);
  end;
end;

function GetTransformInfoById(AId: longword): TpgTransformInfo;
begin
  Result := glTransformInfoList.ById(AId)
end;

function GetTransformInfoByClass(AClass: TpgTransformClass): TpgTransformInfo;
var
  i: integer;
  AInfo: TpgTransformInfo;
begin
  for i := 0 to glTransformInfoList.Count - 1 do
  begin
    AInfo := glTransformInfoList[i];
    if AInfo.TransformClass = AClass then
    begin
      Result := AInfo;
      exit;
    end;
  end;
  Result := nil;
end;

procedure RegisterTransform(AId: longword; ATransformClass: TpgTransformClass; const AName: Utf8String);
var
  TransformInfo: TpgTransformInfo;
begin
  if assigned(glTransformInfoList.ById(AId)) then
    raise Exception.CreateFmt(sDuplicateTransformRegistered, [AId]);
  TransformInfo := TpgTransformInfo.Create;
  TransformInfo.FId := AId;
  TransformInfo.FTransformClass := ATransformClass;
  TransformInfo.FName := AName;
  glTransformInfoList.Add(TransformInfo);
end;

initialization

  glTransformInfoList := TpgTransformInfoList.Create;

  RegisterTransform(tiAffine, TpgAffineTransform, 'Affine');
  RegisterTransform(tiProjective, TpgProjectiveTransform, 'Projective');
  RegisterTransform(tiCurved, TpgCurvedTransform, 'Curved');


finalization

  FreeAndNil(glTransformInfoList);

end.
