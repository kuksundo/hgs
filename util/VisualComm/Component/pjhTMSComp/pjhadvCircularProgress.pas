unit pjhadvCircularProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  Graphics, Math,
  AdvCircularProgress, AdvGDIP, pjhclasses, pjhDesignCompIntf, pjhTMSCompConst;

type
  TpjhAdvCircularProgress = class(TAdvCircularProgress, IpjhDesignCompInterface)
  protected
    //For IpjhDesignCompInterface
    FpjhTagInfo: TpjhTagInfo;
    FpjhValue: string;
    FpjhBplFileName: string;
    FActive: Boolean;

    FpjhInnerCircleRgn: TGPRegion;
    FpjhClipDraw: Boolean;
    FpjhActiveBehind: Boolean;
    FpjhSegPath: array[1..SEGMENT_COUNT] of TGPGraphicsPath;

    function GetpjhValue: string;
    procedure SetpjhValue(AValue: string);
    function GetpjhTagInfo: TpjhTagInfo;
    procedure SetpjhTagInfo(AValue: TpjhTagInfo);
    function GetBplFileName: string;
    procedure SetBplFileName(AValue: string);
    //For IpjhDesignCompInterface

    function GetActive: Boolean;
    procedure SetActive(AValue: Boolean);

    procedure Loaded; override;
    procedure Paint; override;
    procedure pjhDrawSegments;
    procedure pjhDrawSegment(Seg: Integer; graphics: TGPGraphics);
    procedure pjhIncreaseByOne;
    procedure pjhCalculateSegmentSize;
    procedure pjhClearSegmentSize;
  public
    constructor Create(AOwner: TComponent);  override;
    destructor  Destroy;                     override;
  published
    //For IpjhDesignCompInterface
    property pjhTagInfo: TpjhTagInfo read GetpjhTagInfo write SetpjhTagInfo;
    property pjhValue: string read GetpjhValue write SetpjhValue;
    property pjhBplFileName: string read GetBplFileName write SetBplFileName;
    //For IpjhDesignCompInterface
    property Active: Boolean read GetActive write SetActive;
  end;

implementation

{ TpjhAdvSmoothTimeLine }

constructor TpjhAdvCircularProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhTMSCompBplFileName;
end;

destructor TpjhAdvCircularProgress.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhAdvCircularProgress.GetActive: Boolean;
begin
  Result := FActive;
end;

function TpjhAdvCircularProgress.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhAdvCircularProgress.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhAdvCircularProgress.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhAdvCircularProgress.Loaded;
begin
  inherited;

  pjhCalculateSegmentSize;
end;

procedure TpjhAdvCircularProgress.Paint;
begin
  if FActive then
    inherited
  else
  begin
    if (Appearance.BackGroundColor <> clNone) then
    begin
      Canvas.Brush.Color := Appearance.BackGroundColor;
      Canvas.Pen.Color := Appearance.BackGroundColor;
      Canvas.Rectangle(ClientRect);
    end;


    if (Appearance.BorderColor <> clNone) then
    begin
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Color := Appearance.BorderColor;
      Canvas.Rectangle(ClientRect);
    end;

    pjhDrawSegments;

  end;
end;

procedure TpjhAdvCircularProgress.pjhCalculateSegmentSize;
var
  i, j, k: Integer;
  R: TRect;
  rectf: TGPRectF;
  Path: TGPGraphicsPath;
begin
  pjhClearSegmentSize;

  k := Math.Max(Width, Height);
  if (K < 40) then
  begin
    j := 22;
  end
  else if (k < 60) then
  begin
    j := 23;
  end
  else if (k < 100) then
  begin
    j := 24;
  end
  else if (k < 200) then
  begin
    j := 25;
  end
  else
  begin
    j := 26;
  end;

  //--- Segments
  R := GetMyClientRect;
  rectf := MakeRect(R.Left,R.Top,R.Right,R.Bottom);
  for i := 1 to SEGMENT_COUNT do
  begin
    if (FpjhSegPath[i] = nil) then
    begin
      FpjhSegPath[i] := TGPGraphicsPath.Create;
    end;
    FpjhSegPath[i].AddPie(rectf, ((i - 1) * 30) - 90, j);
  end;

  //--- Inner Circle
  R := GetInnerCircleRect;
  rectf := MakeRect(R.Left,R.Top,R.Right,R.Bottom);
  Path := TGPGraphicsPath.Create;
  Path.AddPie(rectf, 0, 360);
  FpjhInnerCircleRgn := TGPRegion.Create(Path);
  Path.Free;
end;

procedure TpjhAdvCircularProgress.pjhClearSegmentSize;
var
  i: Integer;
begin
  for i := 1 to SEGMENT_COUNT do
  begin
    if (FpjhSegPath[i] <> nil) then
    begin
      FpjhSegPath[i].Free;
    end;
    FpjhSegPath[i] := nil;
  end;

  if (FpjhInnerCircleRgn <> nil) then
  begin
    FpjhInnerCircleRgn.Free;
    FpjhInnerCircleRgn := nil;
  end;
end;

procedure TpjhAdvCircularProgress.pjhDrawSegment(Seg: Integer;
  graphics: TGPGraphics);
var
  solidBrush: TGPSolidBrush;
  Clr: TColor;
  ProgSeg: Integer;
begin
  if Assigned(graphics) then
  begin
    if FActive then
    begin
      ProgSeg := GetProgressSegment;

      if (Seg = Appearance.TransitionSegmentColor) then  // Transition Segment
      begin
        clr := Appearance.TransitionSegmentColor;
        solidBrush := TGPSolidBrush.Create(ColorToARGB(clr));
      end
      else if (Seg < Appearance.TransitionSegmentColor) then // Inactive/Progress Segment
      begin
        if (Seg <= ProgSeg) and not FpjhActiveBehind then   // ProgressSegment
        begin
          clr := Appearance.ProgressSegmentColor;
          solidBrush := TGPSolidBrush.Create(ColorToARGB(clr));
        end
        else
        begin
          if FpjhActiveBehind then
          begin
            clr := Appearance.ActiveSegmentColor;
            solidBrush := TGPSolidBrush.Create(ColorToARGB(clr));
          end
          else
          begin
            clr := Appearance.InActiveSegmentColor;
            solidBrush := TGPSolidBrush.Create(ColorToARGB(clr));
          end;
        end;
      end
      else
      begin
        if FpjhActiveBehind then
        begin
          if (Seg <= ProgSeg) then   // ProgressSegment
          begin
            clr := Appearance.ProgressSegmentColor;
            solidBrush := TGPSolidBrush.Create(ColorToARGB(clr));
          end
          else
          begin
            clr := Appearance.InActiveSegmentColor;
            solidBrush := TGPSolidBrush.Create(ColorToARGB(clr));
          end;
        end
        else
        begin
          clr := Appearance.ActiveSegmentColor;
          solidBrush := TGPSolidBrush.Create(ColorToARGB(clr));
        end;
      end;
    end
    else
    begin
      clr := Appearance.InActiveSegmentColor;
      solidBrush := TGPSolidBrush.Create(ColorToARGB(clr));
    end;

    if (clr <> clNone) then
      graphics.FillPath(solidbrush, FpjhSegPath[Seg]);
    solidbrush.Free;
  end;
end;

procedure TpjhAdvCircularProgress.pjhDrawSegments;
var
  i: Integer;
  graphics: TGPGraphics;
begin
  graphics := TGPGraphics.Create(Canvas.Handle);

  if Assigned(FpjhInnerCircleRgn) then
  begin
    graphics.ExcludeClip(FpjhInnerCircleRgn);
  end;

  graphics.SetSmoothingMode(SmoothingModeAntiAlias);

  // Create segment pieces
  //j := Math.Max(1, FTransitionSegment-1);
  for i := 1 to SEGMENT_COUNT do
  begin
    {if FClipDraw then
    begin
      if not (i in [FTransitionSegment, j, 12]) then
        Continue;
    end;
    }
    pjhDrawSegment(i, graphics);
  end;
  graphics.free;

  if FpjhClipDraw then
    FpjhClipDraw := False;
end;

procedure TpjhAdvCircularProgress.pjhIncreaseByOne;
begin
  inherited;
end;

procedure TpjhAdvCircularProgress.SetActive(AValue: Boolean);
begin
  if FActive <> AValue then
    FActive := AValue;
end;

procedure TpjhAdvCircularProgress.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhAdvCircularProgress.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhAdvCircularProgress.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    //Value := StrToFloatDef(AValue,0.0);
  end;
end;

end.
