{ *********************************************************************** }
{                                                                         }
{ Graph                                                                   }
{                                                                         }
{ Copyright (c) 2006 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit Graph;

{$B-}
{$I Directives.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GraphicUtils, GraphicTypes, Parser, ValueTypes;

type
  TPointArray = array of array of TPoint;
  TRectangularTraceEvent = procedure(Sender: TObject; const X, Y: Double) of object;
  TPolarTraceEvent = procedure(Sender: TObject; const Angle, X, Y: Double) of object;
  TCoordinateSystem = (csRectangular, csPolar);

const
  DefaultHeight = 300;
  DefaultWidth = 300;
  DefaultQuality = 1;
  DefaultCoordinateSystem = csRectangular;
  DefaultMaxX = 5;
  DefaultMaxY = 5;
  DefaultMargin = 0;

type
  {$IFNDEF DELPHI_2006}
  TBitmap = class(Graphics.TBitmap)
  public
    procedure SetSize(AWidth, AHeight: Integer); virtual;
  end;
  {$ENDIF}

  TGraph = class(TCustomControl)
  private
    FBuffer: TBitmap;
    FCoordinateSystem: TCoordinateSystem;
    FOnRectangularTrace: TRectangularTraceEvent;
    FPolarAxisPen: TPen;
    FAxisFont: TFont;
    FIndexValue: TValue;
    FTracePointArray: TPointArray;
    FFormulaFont: TFont;
    FShowGrid: Boolean;
    FShowAxis: Boolean;
    FVertSpacing: Double;
    FGraphPen: TPen;
    FMaxX: Integer;
    FMaxY: Integer;
    FAccuracy: TSize;
    FPointArray: TPointArray;
    FValue: TValue;
    FTracing: Boolean;
    FParser: TParser;
    FQuality: Integer;
    FMargin: Integer;
    FGridPen: TPen;
    FOnPolarTrace: TPolarTraceEvent;
    FTracePen: TPen;
    FHorzSpacing: Double;
    FAxisPen: TPen;
    function GetFormula: string;
    procedure SetFormula(const Value: string);
    procedure SetParser(const Value: TParser);
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure DrawLine(const Angle: Extended); virtual;
    procedure Paint; override;
    procedure Resize; override;
    function WorkArea: TRect; virtual;
    function CheckPoint(const APoint: TExactPoint; const Area: PRect = nil): Boolean; virtual;
    procedure Attach; virtual;
    procedure Detach; virtual;
    procedure DoTrace(const X, Y: Double); overload; virtual;
    procedure DoTrace(const Angle, X, Y: Double); overload; virtual;
    procedure Filter; virtual;
    function Compare(const APoint, BPoint: TPoint): Boolean; virtual;
    procedure Draw(const Target: TCanvas; const PointArray: TPointArray;
      const Pen: TPen = nil); virtual;
    property PointArray: TPointArray read FPointArray write FPointArray;
    property TracePointArray: TPointArray read FTracePointArray
      write FTracePointArray;
    property Value: TValue read FValue write FValue;
    property IndexValue: TValue read FIndexValue write FIndexValue;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Calculate; virtual;
    procedure Clear; virtual;
    function GetX(const X: Double): Double; virtual;
    function GetY(const Y: Double): Double; virtual;
    property Buffer: TBitmap read FBuffer write FBuffer;
  published
    property Accuracy: TSize read FAccuracy write FAccuracy;
    property Align;
    property Anchors;
    property AutoSize;
    property AxisFont: TFont read FAxisFont write FAxisFont;
    property AxisPen: TPen read FAxisPen write FAxisPen;
    property BiDiMode;
    property Color;
    property Constraints;
    property CoordinateSystem: TCoordinateSystem read FCoordinateSystem
      write FCoordinateSystem default DefaultCoordinateSystem;
    property Ctl3D;
    property Cursor default crCross;
    property UseDockManager;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Formula: string read GetFormula write SetFormula;
    property FormulaFont: TFont read FFormulaFont write FFormulaFont;
    property GraphPen: TPen read FGraphPen write FGraphPen;
    property GridPen: TPen read FGridPen write FGridPen;
    property PolarAxisPen: TPen read FPolarAxisPen write FPolarAxisPen;
    property Height default DefaultHeight;
    property HorzSpacing: Double read FHorzSpacing write FHorzSpacing;
    property Margin: Integer read FMargin write FMargin default DefaultMargin;
    property MaxX: Integer read FMaxX write FMaxX default DefaultMaxX;
    property MaxY: Integer read FMaxY write FMaxY default DefaultMaxY;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Parser: TParser read FParser write SetParser;
    property PopupMenu;
    property Quality: Integer read FQuality write FQuality default DefaultQuality;
    property ShowAxis: Boolean read FShowAxis write FShowAxis default True;
    property ShowGrid: Boolean read FShowGrid write FShowGrid default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TracePen: TPen read FTracePen write FTracePen;
    property Tracing: Boolean read FTracing write FTracing default True;
    property VertSpacing: Double read FVertSpacing write FVertSpacing;
    property Visible;
    property Width default DefaultWidth;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
    property OnRectangularTrace: TRectangularTraceEvent read FOnRectangularTrace
      write FOnRectangularTrace;
    property OnPolarTrace: TPolarTraceEvent read FOnPolarTrace write FOnPolarTrace;
  end;

const
  DefaultShowAxis = True;
  DefaultShowGrid = True;
  DefaultHorzSpacing = 1;
  DefaultVertSpacing = 1;
  AngleIncrement = 0.001;
  AngleVariableName = 'Angle';
  XVariableName = 'X';
  IndexVariableName = 'Index';
  CoordinateSystemError = 'Coordinate system out of range';

function Add(var Target: TPointArray; Index: Integer; Point: TPoint): Integer; overload;
function Add(var Target: TPointArray; const PointArray: array of TPoint): Integer; overload;
procedure Delete(var Target: TPointArray);

procedure Register;

implementation

uses
  Math, NumberUtils, TextConsts, Types, {$IFDEF DELPHI_XE2}System.UITypes, {$ENDIF}
  ValueUtils;

procedure Register;
begin
  RegisterComponents('Samples', [TGraph]);
end;

function Add(var Target: TPointArray; Index: Integer; Point: TPoint): Integer;
begin
  if Index > High(Target) then SetLength(Target, Index + 1);
  Result := Length(Target[Index]);
  SetLength(Target[Index], Result + 1);
  Target[Index][Result] := Point;
end;

function Add(var Target: TPointArray; const PointArray: array of TPoint): Integer;
var
  I: Integer;
begin
  Result := Length(Target);
  SetLength(Target, Result + 1);
  for I := Low(PointArray) to High(PointArray) do
    Add(Target, Result, PointArray[I]);
end;

procedure Delete(var Target: TPointArray);
var
  I: Integer;
begin
  for I := Low(Target) to High(Target) do Target[I] := nil;
  Target := nil;
end;

{$IFNDEF DELPHI_2006}

{ TBitmap }

procedure TBitmap.SetSize(AWidth, AHeight: Integer);
begin
  Width := AWidth;
  Height := AHeight;
end;

{$ENDIF}

{ TGraph }

procedure TGraph.Attach;
begin
  if Assigned(FParser) then
  begin
    FParser.AddVariable(AngleVariableName, FValue, False, False, vtDouble);
    FParser.AddVariable(XVariableName, FValue, False, False, vtDouble);
    FParser.AddVariable(IndexVariableName, FIndexValue, False, False, vtInteger);
  end;
end;

procedure TGraph.Calculate;
var
  I: Integer;
  Output, Center: TExactPoint;
  Area: TRect;
  Factor, XFactor, YFactor, Distance: Double;
  APointArray: TPointArray;

  procedure Insert;
  var
    J: Integer;
  begin
    if CheckPoint(Output, @Area) then
      Add(APointArray, I, Point(Round(Output.X), Round(Output.Y)))
    else begin
      J := Length(APointArray);
      if (J > 0) and (Length(APointArray[J - 1]) > 0) then
        I := Add(APointArray, []);
    end;
  end;

begin
  if Trim(Formula) <> '' then
  begin
    Delete(FTracePointArray);
    FParser.StringToScript(AnsiLowerCase(FParser.Text));
    FParser.Optimize;
    Center := MakePoint(ClientWidth / 2, ClientHeight / 2);
    Area := WorkArea;
    XFactor := (Center.X - Area.Left) / FMaxX;
    YFactor := (Center.Y - Area.Left) / FMaxY;
    I := 0;
    AssignInteger(FIndexValue, 0);
    case FCoordinateSystem of
      csRectangular:
        begin
          Factor := FMaxX / Area.Right / FQuality;
          AssignDouble(FValue, - FMaxX);
          while LessOrEqual(FValue.Float64, FMaxX) do
          begin
            Output.X := Center.X + FValue.Float64 * XFactor;
            Output.Y := Center.Y - Convert(FParser.Execute^, vtDouble).Float64 * YFactor;
            Insert;
            AssignDouble(FValue, FValue.Float64 + Factor);
            AssignInteger(FIndexValue, Convert(FIndexValue, vtInteger).Signed32 + 1);
          end;
        end;
      csPolar:
        begin
          Factor := AngleIncrement / FQuality;
          AssignDouble(FValue, 0);
          while LessOrEqual(FValue.Float64, DoublePi) do
          begin
            Distance := Convert(FParser.Execute^, vtDouble).Float64;
            Output := GetCoordinate(Center, FValue.Float64, Distance, XFactor, YFactor);
            Insert;
            AssignDouble(FValue, FValue.Float64 + Factor);
            AssignInteger(FIndexValue, Convert(FIndexValue, vtInteger).Signed32 + 1);
          end;
        end;
    else raise Exception.Create(CoordinateSystemError);
    end;
    FPointArray := APointArray;
    Filter;
  end;
end;

function TGraph.CheckPoint(const APoint: TExactPoint;
  const Area: PRect): Boolean;
var
  BArea: TRect;
begin
  if Assigned(Area) then BArea := Area^
  else BArea := WorkArea;
  Result := not IsNan(APoint.X) and not IsInfinite(APoint.X) and not IsNan(APoint.Y) and
    not IsInfinite(APoint.Y) and
    PtInRect(BArea, Point(Round(APoint.X), Round(APoint.Y)));
end;

procedure TGraph.Clear;
begin
  Delete(FPointArray);
  Delete(FTracePointArray);
  Formula := '';
end;

function TGraph.Compare(const APoint, BPoint: TPoint): Boolean;
begin
  Result := (Abs(APoint.X - BPoint.X) >= FAccuracy.cx) or
    (Abs(APoint.Y - BPoint.Y) >= FAccuracy.cy);
end;

constructor TGraph.Create(AOwner: TComponent);
begin
  inherited;
  Cursor := crCross;
  FMaxX := DefaultMaxX;
  FMaxY := DefaultMaxY;
  FAxisFont := TFont.Create;
  FAxisPen := TPen.Create;
  FFormulaFont := TFont.Create;
  FGraphPen := TPen.Create;
  FGraphPen.Color := clRed;
  FGridPen := TPen.Create;
  FGridPen.Color := clGray;
  FGridPen.Style := psDot;
  FPolarAxisPen := TPen.Create;
  FPolarAxisPen.Color := clGray;
  FTracePen := TPen.Create;
  FTracePen.Mode := pmNotXor;
  FTracePen.Color := clBlue;
  FTracePen.Style := psDot;
  FShowAxis := DefaultShowAxis;
  FShowGrid := DefaultShowGrid;
  FHorzSpacing := DefaultHorzSpacing;
  FVertSpacing := DefaultVertSpacing;
  FQuality := DefaultQuality;
  FCoordinateSystem := DefaultCoordinateSystem;
  FTracing := True;
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf24bit;
end;

destructor TGraph.Destroy;
begin
  FAxisFont.Free;
  FAxisPen.Free;
  FFormulaFont.Free;
  FGraphPen.Free;
  FGridPen.Free;
  FPolarAxisPen.Free;
  FTracePen.Free;
  FBuffer.Free;
  inherited;
end;

procedure TGraph.Detach;
begin
  if Assigned(FParser) then
  begin
    FParser.DeleteVariable(FValue);
    FParser.DeleteVariable(FValue);
    FParser.DeleteVariable(FIndexValue);
  end;
end;

procedure TGraph.DoTrace(const Angle, X, Y: Double);
begin
  if Assigned(FOnPolarTrace) then FOnPolarTrace(Self, Angle, X, Y);
end;

procedure TGraph.DoTrace(const X, Y: Double);
begin
  if Assigned(FOnRectangularTrace) then FOnRectangularTrace(Self, X, Y);
end;

procedure TGraph.Draw(const Target: TCanvas; const PointArray: TPointArray;
  const Pen: TPen);
var
  I, J: Integer;
  APoint, BPoint: PPoint;
begin
  if Assigned(Pen) then Target.Pen := Pen;
  for I := Low(PointArray) to High(PointArray) do
    for J := Low(PointArray[I]) + 1 to High(PointArray[I]) do
    begin
      APoint := @PointArray[I][J - 1];
      BPoint := @PointArray[I][J];
      Target.MoveTo(APoint.X, APoint.Y);
      Target.LineTo(BPoint.X, BPoint.Y);
    end;
end;

procedure TGraph.DrawLine(const Angle: Extended);
var
  APoint, BPoint: TExactPoint;
  Area: TRect;
  XFactor, YFactor: Double;
begin
  APoint := MakePoint(FBuffer.Width / 2, FBuffer.Height / 2);
  Area := WorkArea;
  XFactor := (APoint.X - Area.Left) / FMaxX;
  YFactor := (APoint.Y - Area.Left) / FMaxY;
  APoint := GetIntersection(MakePoint(- FMaxX, FMaxY), MakePoint(FMaxX, FMaxY),
    APoint, GetPoint(APoint, Angle, 1, XFactor, YFactor));
  BPoint := MakePoint(Area.Right - APoint.X, Area.Bottom - APoint.Y);
  FBuffer.Canvas.PolyLine([MakePoint(APoint), MakePoint(BPoint)]);
  APoint.X := Area.Right - APoint.X;
  BPoint.X := Area.Right - BPoint.X;
  FBuffer.Canvas.PolyLine([MakePoint(APoint), MakePoint(BPoint)]);
end;

procedure TGraph.Filter;
var
  APoint, BPoint: PPoint;
  I, J: Integer;
  APointArray: TPointArray;
begin
  APoint := nil;
  SetLength(APointArray, Length(FPointArray));
  for I := Low(FPointArray) to High(FPointArray) do
    for J := Low(FPointArray[I]) to High(FPointArray[I]) do
    begin
      BPoint := @FPointArray[I][J];
      if not Assigned(APoint) then
      begin
        APoint := BPoint;
        Add(APointArray, I, APoint^);
      end
      else if Compare(APoint^, BPoint^) then
      begin
        APoint := BPoint;
        Add(APointArray, I, APoint^);
      end;
    end;
  FPointArray := APointArray;
end;

function TGraph.GetFormula: string;
begin
  if Assigned(FParser) then Result := FParser.Text
  else Result := '';
end;

function TGraph.GetX(const X: Double): Double;
var
  BorderSize: Integer;
  A: Double;
begin
  BorderSize := FMargin + BevelWidth + BorderWidth;
  A := ClientWidth / 2 - BorderSize;
  Result := (X - BorderSize - A) * FMaxX / A;
end;

function TGraph.GetY(const Y: Double): Double;
var
  BorderSize: Integer;
  A: Double;
begin
  BorderSize := FMargin + BevelWidth + BorderWidth;
  A := ClientHeight / 2 - BorderSize;
  Result := (A - (Y - BorderSize)) * FMaxY / A;
end;

procedure TGraph.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Area: TRect;
  Output, Center: TExactPoint;
  A, XFactor, YFactor: Double;
begin
  inherited;
  if FTracing and (Trim(GetFormula) <> '') then
  begin
    Draw(Canvas, FTracePointArray, FTracePen);
    Delete(FTracePointArray);
    Area := WorkArea;
    Center := MakePoint(ClientWidth / 2, ClientHeight / 2);
    XFactor := (Center.X - Area.Left) / FMaxX;
    YFactor := (Center.Y - Area.Left) / FMaxY;
    case FCoordinateSystem of
      csRectangular:
        begin
          AssignDouble(FValue, GetX(X));
          try
            A := Center.Y - Convert(FParser.Execute^, vtDouble).Float64 * YFactor;
            if not IsInfinite(A) and PtInRect(Area, Point(X, Round(A))) then
            begin
              DoTrace(X, A);
              Add(FTracePointArray, [Point(X, Area.Top), Point(X, Area.Bottom)]);
              Add(FTracePointArray, [Point(Area.Left, Round(A)), Point(Area.Right, Round(A))]);
            end;
          except
            Delete(FTracePointArray);
          end;
        end;
      csPolar:
        begin
          A := GetAngle(MakePoint(FMaxX, 0), MakePoint(0, 0), MakePoint(GetX(X), GetY(Y)));
          if NumberUtils.Greater(Y, Center.Y) then A := DoublePi - A;
          AssignDouble(FValue, A);
          Output := GetCoordinate(Center, FValue.Float64, Convert(FParser.Execute^, vtDouble).Float64,
            XFactor, YFactor);
          if CheckPoint(Output, @Area) then
          begin
            DoTrace(A, Output.X, Output.Y);
            Add(FTracePointArray, [Point(Round(Center.X), Round(Center.Y)), Point(Round(Output.X), Round(Output.Y))]);
            Add(FTracePointArray, [Point(Area.Left, Round(Output.Y)), Point(Area.Right, Round(Output.Y))]);
          end;
        end;
    end;
    Draw(Canvas, FTracePointArray);
  end;
end;

procedure TGraph.Notification(Component: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (Component = FParser) then
    SetParser(nil);
end;

procedure TGraph.Paint;
const
  Arrow: TSize = (cx: 15; cy: 8);
  ArrowWidth = 1;
  XText = 'X';
  YText = 'Y';
  TextMargin = 20;
var
  Center: TPoint;
  Area: TRect;
  X, Y, XSpacing, YSpacing: Double;
  XFlag, YFlag: Boolean;
  I: Integer;
  S: string;
begin
  inherited;
  Delete(FTracePointArray);
  FBuffer.SetSize(ClientWidth, ClientHeight);
  FBuffer.Canvas.Brush.Color := Color;
  FBuffer.Canvas.FillRect(Rect(0, 0, FBuffer.Width, FBuffer.Height));
  Center := Point(FBuffer.Width div 2, FBuffer.Height div 2);
  Area := WorkArea;
  if FShowGrid then
  begin
    X := (Area.Right - Area.Left) / 2;
    XSpacing := X * FVertSpacing / FMaxX;
    XFlag := LessOrEqual(XSpacing, X);
    Y := (Area.Bottom - Area.Top) / 2;
    YSpacing := Y * FHorzSpacing / FMaxY;
    YFlag := LessOrEqual(YSpacing, Y);
    case FCoordinateSystem of
      csRectangular:
        begin
          FBuffer.Canvas.Pen.Assign(FGridPen);
          if NumberUtils.Greater(FVertSpacing, 0) then
          begin
            if LessOrEqual(XSpacing, X) then
            begin
              X := Center.X;
              for I := 0 to FMaxX do
              begin
                FBuffer.Canvas.PolyLine([Point(Round(X), Area.Top), Point(Round(X), Area.Bottom)]);
                X := X + XSpacing;
              end;
              X := Center.X;
              for I := 0 to FMaxX do
              begin
                FBuffer.Canvas.PolyLine([Point(Round(X), Area.Top), Point(Round(X), Area.Bottom)]);
                X := X - XSpacing;
              end;
            end;
          end;
          if FHorzSpacing > 0 then
          begin
            if LessOrEqual(YSpacing, Y) then
            begin
              Y := Center.Y;
              for I := 0 to FMaxY do
              begin
                FBuffer.Canvas.PolyLine([Point(Area.Left, Round(Y)), Point(Area.Right, Round(Y))]);
                Y := Y + YSpacing;
              end;
              Y := Center.Y;
              for I := 0 to FMaxY do
              begin
                FBuffer.Canvas.PolyLine([Point(Area.Left, Round(Y)), Point(Area.Right, Round(Y))]);
                Y := Y - YSpacing;
              end;
            end;
          end;
        end;
      csPolar:
        begin
          FBuffer.Canvas.Pen.Assign(FPolarAxisPen);
          DrawLine(Pi / 4);
          FBuffer.Canvas.Pen.Assign(FGridPen);
          DrawLine(Pi / 8);
          DrawLine(TriplePi / 8);
          if XFlag and YFlag then
          begin
            X := XSpacing;
            Y := YSpacing;
            while LessOrEqual(Y, Area.Bottom) or LessOrEqual(X, Area.Right) do
            begin
              FBuffer.Canvas.Brush.Style := bsClear;
              FBuffer.Canvas.Ellipse(Round(Center.X - X), Round(Center.Y - Y),
                Round(Center.X + X), Round(Center.Y + Y));
              X := X + XSpacing;
              Y := Y + YSpacing;
            end;
          end;
        end;
    end;
  end;
  if FShowAxis then
    with FBuffer, Canvas do
    begin
      Pen.Assign(FAxisPen);
      I := FAxisPen.Width - 1;
      PolyLine([Point(Area.Left + I, Center.Y), Point(Area.Right - I, Center.Y)]);
      PolyLine([Point(Center.X, Area.Top + I), Point(Center.X, Area.Bottom - I)]);
      Pen.Width := ArrowWidth;
      Brush.Color := Pen.Color;
      Polygon([Point(Area.Right - Arrow.cx, Center.Y - Arrow.cy), Point(Area.Right, Center.Y),
        Point(Area.Right - Arrow.cx, Center.Y + Arrow.cy)]);
      Polygon([Point(Center.X - Arrow.cy, Area.Top + Arrow.cx), Point(Center.X, Area.Top),
        Point(Center.X + Arrow.cy, Area.Top + Arrow.cx)]);
      Brush.Style := bsClear;
      Font.Assign(FAxisFont);
      TextOut(Area.Right - TextWidth(XText), Center.Y - TextMargin - TextHeight(XText), XText);
      S := IntToStr(FMaxX);
      TextOut(Area.Right - TextWidth(S), Center.Y + TextMargin, S);
      S := Minus + Space + S;
      TextOut(Area.Left, Center.Y + TextMargin, S);
      TextOut(Center.X - TextMargin - TextWidth(YText), Area.Top, YText);
      S := IntToStr(FMaxY);
      TextOut(Center.X + TextMargin, Area.Top, S);
      S := Minus + Space + S;
      TextOut(Center.X + TextMargin, Area.Bottom - TextHeight(S), S);
    end;
  Draw(FBuffer.Canvas, FPointArray, FGraphPen);
  Canvas.Draw(0, 0, FBuffer);
end;

procedure TGraph.Resize;
begin
  inherited;
  if Trim(GetFormula) <> '' then Calculate
  else Delete(FPointArray);
  Paint;
end;

procedure TGraph.SetFormula(const Value: string);
begin
  if Assigned(FParser) then FParser.Text := Value;
end;

procedure TGraph.SetParser(const Value: TParser);
begin
  if FParser <> Value then
  begin
    Detach;
    FParser := Value;
    Attach;
  end;
end;

function TGraph.WorkArea: TRect;
var
  I: Integer;
begin
  I := FMargin + BevelWidth + BorderWidth;
  Result := Rect(I, I, ClientWidth - I, ClientHeight - I);
end;

end.
