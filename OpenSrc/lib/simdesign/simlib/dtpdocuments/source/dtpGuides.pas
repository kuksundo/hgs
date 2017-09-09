{ dtpGuides.pas

  original author: JF
  original date: 01feb2011
  
  Copyright (c) 2011 SimDesign BV

}
unit dtpGuides;

interface

uses Classes, Types, Contnrs, Graphics, dtpGraphics;

type

  TdtpGuide = class(TObject)  // change by J.F. June 2011

  protected
    
  public
    StartPoint: TdtpPoint;
    EndPoint: TdtpPoint;
    function IsVertical: boolean;  // added by J.F. June 2011
    function Position: single; // added by J.F. June 2011
  end;

  TdtpPageGuides = class(TPersistent)
  private
    FGuides: TObjectList;
    FOwnerPage: TObject;
    function GetGuideCount: integer;
  protected
    FGuideColor: TColor;
    function InverseColor(Color: TColor ): TColor;
    function GetGuideColor: TColor;
    procedure SetGuideColor(const Color: TColor);
  public
    constructor Create(Owner: TObject); virtual;
    destructor Destroy; override;
    function AddGuide(): TdtpGuide; // changed by J.F. June 2011
    function GuideByIndex(Index: integer): TdtpGuide;
    function GuideByPoint(APoint: TdtpPoint): TdtpGuide;  // changed by J.F. June 2011
    function GuidesXYByPoint(APoint: TdtpPoint): TdtpPoint;  //  added by J.F. July 2011
    procedure DeleteAllGuides();
    procedure DeleteGuide(Guide: TdtpGuide);
    procedure PaintAllGuides(const Canvas: TCanvas); virtual;
    procedure PaintGuide(const Canvas: TCanvas; const Guide: TdtpGuide);
    procedure UpdateAllGuides(); // changed by J.F. June 2011
    procedure UpdateGuide(const Guide: TdtpGuide; NewPosition: single);
    function ValidGuidePosition(const Guide: TdtpGuide): boolean;
    property GuideCount: integer read GetGuideCount;
    property GuideColor: TColor read GetGuideColor write SetGuideColor;
  end;

implementation

uses
  SysUtils, Math, dtpPage, Windows, dtpDefaults;  // changed by J.F. June 2011

function TdtpGuide.IsVertical: boolean;  // added by J.F. June 2011
begin
  Result:= StartPoint.X = EndPoint.X;
end;

function TdtpGuide.Position: single;  // added by J.F. June 2011
begin
  if StartPoint.X = EndPoint.X then
    Result:= StartPoint.X
  else
    Result:= StartPoint.Y;
end;

constructor TdtpPageGuides.Create(Owner: TObject);
begin
  inherited Create;
  FGuides := TObjectList.Create;
  FOwnerPage:= Owner;
  FGuideColor:= InverseColor(clRed);
end;

destructor TdtpPageGuides.Destroy;
begin
  FGuides.Free;
  inherited;
end;

function TdtpPageGuides.AddGuide(): TdtpGuide;  // changed by J.F. June 2011

begin
  try
    Result:= TdtpGuide.Create;
    if FGuides.Add(Result) < 0  then
      FreeAndNil(Result);
  except
    FreeAndNil(Result);
  end;
end;

procedure TdtpPageGuides.DeleteAllGuides(); //  changed by J.F. July 2011
begin
  FGuides.Clear;
end;

procedure TdtpPageGuides.DeleteGuide(Guide: TdtpGuide);
begin
  if Assigned(Guide) then
  try
    FGuides.Remove(Guide); //  changed by J.F. July 2011
  finally

  end;
end;

function TdtpPageGuides.GetGuideColor: TColor;
begin
  Result:= InverseColor(FGuideColor);
end;

function TdtpPageGuides.GetGuideCount: integer;
begin
  Result := FGuides.Count;
end;

function TdtpPageGuides.GuideByIndex(Index: integer): TdtpGuide;
begin
  Result := nil;
  try
    if (Index >= 0) and (Index < FGuides.Count) then
      Result := TdtpGuide(FGuides[Index]);
  finally

  end;
end;

function TdtpPageGuides.GuideByPoint(APoint: TdtpPoint): TdtpGuide; // changed by J.F. July 2011
var
  Index: integer;
  Found: boolean;  //  added by J.F. July 2011
begin
  Result:= nil;

  for Index := 0 to FGuides.Count - 1 do
  with TdtpGuide(FGuides[Index]) do
  try                                      // cDefaultHitSensitivity is a user click tolerance factor
                                           // changed by J.F. July 2011
    if IsVertical then
      Found:= (StartPoint.X > APoint.X - cDefaultHitSensitivity) and (StartPoint.X < APoint.X + cDefaultHitSensitivity)
              and (APoint.Y > StartPoint.Y - cDefaultHitSensitivity) and (APoint.Y < EndPoint.Y + cDefaultHitSensitivity)
    else
      Found:= (StartPoint.Y > APoint.Y - cDefaultHitSensitivity) and (StartPoint.Y < APoint.Y + cDefaultHitSensitivity)
              and (APoint.X > StartPoint.X - cDefaultHitSensitivity) and (APoint.X < EndPoint.X + cDefaultHitSensitivity);

    if Found then
    begin
      Result:= TdtpGuide(FGuides[Index]);
      Exit;
    end;
  finally

  end;
end;
               // for SnapToGuides
function TdtpPageGuides.GuidesXYByPoint(APoint: TdtpPoint): TdtpPoint;  //  added by J.F. July 2011
var
  I: integer;
  VerticalFound, HorizontalFound: boolean;
  HitSensitivity: single;
begin
  Result:= APoint;
  VerticalFound:= false;
  HorizontalFound:= false;
  HitSensitivity:= cDefaultHitSensitivity * 1.25; // make snapping easier
  for I := 0 to FGuides.Count - 1 do
  with TdtpGuide(FGuides[I]) do
  try                                      // HitSensitivity is a user click tolerance factor

    if IsVertical then
    begin
      if (StartPoint.X > APoint.X - HitSensitivity) and (StartPoint.X < APoint.X + HitSensitivity)
         and (APoint.Y > StartPoint.Y - HitSensitivity) and (APoint.Y < EndPoint.Y + HitSensitivity) then
      begin
        Result.X:= TdtpGuide(FGuides[I]).StartPoint.X;
        VerticalFound:= true;
      end;
    end
    else
    if (StartPoint.Y > APoint.Y - HitSensitivity) and (StartPoint.Y < APoint.Y + HitSensitivity)
         and (APoint.X > StartPoint.X - HitSensitivity) and (APoint.X < EndPoint.X + HitSensitivity) then
    begin
      Result.Y:= TdtpGuide(FGuides[I]).StartPoint.Y;
      HorizontalFound:= true;
    end;
    if VerticalFound and HorizontalFound then
      exit;
  finally

  end;
end;

function TdtpPageGuides.InverseColor(Color: TColor ): TColor;
var
  InverseRGB: TColorRef;

  function Inv( AByte: Byte ): Byte;
  begin
    if AByte > 128 Then
      result:= 0
   else
     result:= 255;
  end;

begin
  InverseRGB:= ColorToRgb(Color);
  InverseRGB:= RGB(Inv(GetRValue(InverseRGB)),Inv(GetGValue(InverseRGB)),Inv(GetBValue(InverseRGB)));
  Result := InverseRGB;
end;

procedure TdtpPageGuides.PaintAllGuides(const Canvas: TCanvas); //  changed by J.F. July 2011
var
  Index: integer;
begin
  for Index := 0 to FGuides.Count - 1 do
    PaintGuide(Canvas,TdtpGuide(FGuides.Items[Index]));
end;

procedure TdtpPageGuides.PaintGuide(const Canvas: TCanvas; const Guide: TdtpGuide);
var
  P: TPoint;
begin
  if Assigned(Guide) then   //  chnaged by J.F. July 2011
  with Canvas do
  try
    Pen.Color := FGuideColor;
    Pen.Style := psSolid;
    Pen.Width := 1;
    Pen.Mode  := pmXOR;
    P := TdtpPage(FOwnerPage).ShapeToPoint(Guide.StartPoint);
    MoveTo(P.X, P.Y);
    P := TdtpPage(FOwnerPage).ShapeToPoint(Guide.EndPoint);
    LineTo(P.X, P.Y);
  finally

  end;
end;

procedure TdtpPageGuides.SetGuideColor(const Color: TColor);
begin
  if FGuideColor <> Color then  
    FGuideColor:= InverseColor(Color);
end;

procedure  TdtpPageGuides.UpdateAllGuides();  // changed by J.F. June 2011
var i: integer;
begin
  for i := 0 to FGuides.Count - 1 do
  if not TdtpGuide(FGuides.Items[i]).IsVertical then  // changed by J.F. June 2011
    TdtpGuide(FGuides.Items[i]).EndPoint.X := TdtpPage(FOwnerPage).PageWidth
  else
    TdtpGuide(FGuides.Items[i]).EndPoint.Y := TdtpPage(FOwnerPage).PageHeight;
end;

procedure TdtpPageGuides.UpdateGuide(const Guide: TdtpGuide; NewPosition: single);
begin
  try
    if assigned(Guide) then
    begin
      if Guide.IsVertical then
      begin
        Guide.StartPoint.X:= NewPosition;
        Guide.EndPoint.X:= NewPosition;
      end
      else
      begin
        Guide.StartPoint.Y:= NewPosition;
        Guide.EndPoint.Y:= NewPosition;
      end;
    end;
  finally
  end;
end;

function TdtpPageGuides.ValidGuidePosition(const Guide: TdtpGuide): boolean;  //  added by J.F. June 2011
begin
  Result:= false;
  if Assigned(Guide) then
  if not Guide.IsVertical then
      // Horizontal                         // changed by J.F. June 2011
    Result:= not ((Guide.Position < 0.0) or (Guide.Position > TdtpPage(FOwnerPage).PageHeight))
  else
    Result:= not ((Guide.Position < 0.0) or (Guide.Position > TdtpPage(FOwnerPage).PageWidth));
end;

end.
