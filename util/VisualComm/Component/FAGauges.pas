unit FAGauges;

{**************************OpenFAVCL PROJECT***********************************}
//  VCL NAME  : TFAGauge
//  Copyright : Soon Lyeol, Kim(c) by 2000.7 ~
//  NOTE      :
//            - 이 모델을 이용하여 상업용 소프트웨어를 제작하고 판매하는 방식으로
//              이윤을 획득하는 행위에 대해서는 일체 금함.
//            - 이 모델을 이용하여 프로젝트에 사용하는 것은 허가함.
//            - 이 모델을 바탕으로 코드를 수정하는 것은 제작자에게 통보해주는
//              조건 하에서 허가함(소스관리적 차원)
//  URL       : http://myhome.shinbiro.com/~opencomm
//  Email     : networld@dreamx.net
//
{******************************************************************************}
//  B U G     F I X E D    &    M O D I F I E D      L I S T
//==============================================================================

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FAMemMan_pjh;

type

  TFAGaugeKind = (gkText, gkHorizontalBar, gkVerticalBar, gkPie, gkNeedle);

  TFAGauge = class(TGraphicControl)
  private
    FMinValue: Longint;
    FMaxValue: Longint;
    FCurValue: Longint;
    FKind: TFAGaugeKind;
    FShowText: Boolean;
    FBorderStyle: TBorderStyle;
    FForeColor: TColor;
    FBackColor: TColor;

    FUnitText: string;         // 추가
    FOnChange: TNotifyEvent;   // 추가

    FFAMemMan : TpjhFAMemMan;
    FPlcMax   : SmallInt;
    FAnalogMin: Single;
    FAnalogMax: Single;
    FMemConvert : boolean;     // PLC에서 가져와서 지정된 메모리에 보관시 Convert할지 여부
    FMemIndex : integer;       // PLC에서 가져온 데이타를 보관할 메모리 위치
    FMemName  : TMemName;      //                  "                    종류
    FDestMemConvert : boolean; // 지정된 메모리에있는값을 다른 메모리에 복사시 Convert할지 여부
    FDestMemIndex: Integer;    // FMemName,FMemIndex로 복사가 되어질곳의 메모리 위치
    FDestMemName : TMemName;   //                  "                            종류

    procedure PaintBackground(AnImage: TBitmap);
    procedure PaintAsText(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsNothing(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsPie(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsNeedle(AnImage: TBitmap; PaintRect: TRect);
    procedure SetFAGaugeKind(Value: TFAGaugeKind);
    procedure SetShowText(Value: Boolean);
    procedure SetUnitText(Value: string);  // 추가
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetForeColor(Value: TColor);
    procedure SetBackColor(Value: TColor);
    procedure SetMinValue(Value: Longint);
    procedure SetMaxValue(Value: Longint);
    procedure SetProgress(Value: Longint);
    function GetPercentDone: Longint;

    procedure SetAnalogMax(A: single);
    procedure SetAnalogMin(A: single);
    procedure SetMemConvert(A: boolean);
    procedure SetMemName(A: TMemName);
    procedure SetDestMemConvert(A: boolean);
    procedure SetDestMemName(A: TMemName);
  protected
    procedure Paint; override;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure SetFAMemMan(mm:TpjhFAMemMan);
    procedure MemManValueToThis;
    procedure ThisToMemManValue;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddProgress(Value: Longint);
    property PercentDone: Longint read GetPercentDone;

    destructor Destroy; override;
    procedure ApplyUpdate;
    function SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult; override;
  published
    property Align;
    property Anchors;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Color;
    property Constraints;
    property Enabled;
    property ForeColor: TColor read FForeColor write SetForeColor default clBlack;
    property Font;
    property Kind: TFAGaugeKind read FKind write SetFAGaugeKind default gkHorizontalBar;
    property MinValue: Longint read FMinValue write SetMinValue default 0;
    property MaxValue: Longint read FMaxValue write SetMaxValue default 100;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Progress: Longint read FCurValue write SetProgress;
    property ShowHint;
    property ShowText: Boolean read FShowText write SetShowText default True;
    property UnitText: string read FUnitText write SetUnitText;      // 추가
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;  // 추가

    property FAMemoryManager: TpjhFAMemMan read FFAMemMan write SetFAMemMan;
    property FAMemName: TMemName read FMemName write SetMemName;
    property FAMemIndex: Integer read FMemIndex write FMemIndex;
    property FAMemConvert: boolean read FMemConvert write SetMemConvert;
    property FADestMemName: TMemName read FDestMemName write SetDestMemName;
    property FADestMemIndex: Integer read FDestMemIndex write FDestMemIndex;
    property FADestMemConvert: boolean read FDestMemConvert write SetDestMemConvert;
    property FAPLCAnalogRangeMax: smallint read FPlcMax write FPlcMax default 2000;
    property FAAnalogMax: single read FAnalogMax write SetAnalogMax;
    property FAAnalogMin: single read FAnalogMin write SetAnalogMin;
  end;

implementation

uses Consts;

type
  TBltBitmap = class(TBitmap)
    procedure MakeLike(ATemplate: TBitmap);
  end;


{ TBltBitmap }

procedure TBltBitmap.MakeLike(ATemplate: TBitmap);
begin
  Width := ATemplate.Width;
  Height := ATemplate.Height;
  Canvas.Brush.Color := clWindowFrame;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(Rect(0, 0, Width, Height));
end;

{ This function solves for x in the equation "x is y% of z". }
function SolveForX(Y, Z: Longint): Longint;
begin
  Result := Longint(Trunc( Z * (Y * 0.01) ));
end;

{ This function solves for y in the equation "x is y% of z". }
function SolveForY(X, Z: Longint): Longint;
begin
  if Z = 0 then Result := 0
  else Result := Longint(Trunc( (X * 100.0) / Z ));
end;

{ TFAGauge }

constructor TFAGauge.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csFramed, csOpaque];
  { default values }
  FMinValue := 0;
  FMaxValue := 100;
  FCurValue := 0;
  FKind := gkHorizontalBar;
  FShowText := True;
  FBorderStyle := bsSingle;
  FForeColor := clBlack;
  FBackColor := clWhite;
  Width := 100;
  Height := 100;
  FUnitText := '';  // 추가

  FPlcMax   := 2000;
  FAAnalogMax := 100;
end;

destructor TFAGauge.Destroy;
begin
  if FFAMemMan <> nil then
    FFAMemMan.KickOutNewsMember(Self);
  inherited Destroy;
end;

function TFAGauge.GetPercentDone: Longint;
begin
  Result := SolveForY(FCurValue - FMinValue, FMaxValue - FMinValue);
end;

procedure TFAGauge.Paint;
var
  TheImage: TBitmap;
  OverlayImage: TBltBitmap;
  PaintRect: TRect;
begin
  with Canvas do
  begin
    TheImage := TBitmap.Create;
    try
      TheImage.Height := Height;
      TheImage.Width := Width;
      PaintBackground(TheImage);
      PaintRect := ClientRect;
      if FBorderStyle = bsSingle then InflateRect(PaintRect, -1, -1);
      OverlayImage := TBltBitmap.Create;
      try
        OverlayImage.MakeLike(TheImage);
        PaintBackground(OverlayImage);
        case FKind of
          gkText: PaintAsNothing(OverlayImage, PaintRect);
          gkHorizontalBar, gkVerticalBar: PaintAsBar(OverlayImage, PaintRect);
          gkPie: PaintAsPie(OverlayImage, PaintRect);
          gkNeedle: PaintAsNeedle(OverlayImage, PaintRect);
        end;
        TheImage.Canvas.CopyMode := cmSrcInvert;
        TheImage.Canvas.Draw(0, 0, OverlayImage);
        TheImage.Canvas.CopyMode := cmSrcCopy;
        if ShowText then PaintAsText(TheImage, PaintRect);
      finally
        OverlayImage.Free;
      end;
      Canvas.CopyMode := cmSrcCopy;
      Canvas.Draw(0, 0, TheImage);
    finally
      TheImage.Destroy;
    end;
  end;
end;

procedure TFAGauge.PaintBackground(AnImage: TBitmap);
var
  ARect: TRect;
begin
  with AnImage.Canvas do
  begin
    CopyMode := cmBlackness;
    ARect := Rect(0, 0, Width, Height);
    CopyRect(ARect, Animage.Canvas, ARect);
    CopyMode := cmSrcCopy;
  end;
end;

procedure TFAGauge.PaintAsText(AnImage: TBitmap; PaintRect: TRect);
var
  S: string;
  X, Y: Integer;
  OverRect: TBltBitmap;
begin
  OverRect := TBltBitmap.Create;
  try
    OverRect.MakeLike(AnImage);
    PaintBackground(OverRect);
    S := Format('%d'+FUnitText, [PercentDone]);
    with OverRect.Canvas do
    begin
      Brush.Style := bsClear;
      Font := Self.Font;
      Font.Color := clWhite;
      with PaintRect do
      begin
        X := (Right - Left + 1 - TextWidth(S)) div 2;
        Y := (Bottom - Top + 1 - TextHeight(S)) div 2;
      end;
      TextRect(PaintRect, X, Y, S);
    end;
    AnImage.Canvas.CopyMode := cmSrcInvert;
    AnImage.Canvas.Draw(0, 0, OverRect);
  finally
    OverRect.Free;
  end;
end;

procedure TFAGauge.PaintAsNothing(AnImage: TBitmap; PaintRect: TRect);
begin
  with AnImage do
  begin
    Canvas.Brush.Color := BackColor;
    Canvas.FillRect(PaintRect);
  end;
end;

procedure TFAGauge.PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
var
  FillSize: Longint;
  W, H: Integer;
begin
  W := PaintRect.Right - PaintRect.Left + 1;
  H := PaintRect.Bottom - PaintRect.Top + 1;
  with AnImage.Canvas do
  begin
    Brush.Color := BackColor;
    FillRect(PaintRect);
    Pen.Color := ForeColor;
    Pen.Width := 1;
    Brush.Color := ForeColor;
    case FKind of
      gkHorizontalBar:
        begin
          FillSize := SolveForX(PercentDone, W);
          if FillSize > W then FillSize := W;
          if FillSize > 0 then FillRect(Rect(PaintRect.Left, PaintRect.Top,
            FillSize, H));
        end;
      gkVerticalBar:
        begin
          FillSize := SolveForX(PercentDone, H);
          if FillSize >= H then FillSize := H - 1;
          FillRect(Rect(PaintRect.Left, H - FillSize, W, H));
        end;
    end;
  end;
end;

procedure TFAGauge.PaintAsPie(AnImage: TBitmap; PaintRect: TRect);
var
  MiddleX, MiddleY: Integer;
  Angle: Double;
  W, H: Integer;
begin
  W := PaintRect.Right - PaintRect.Left;
  H := PaintRect.Bottom - PaintRect.Top;
  if FBorderStyle = bsSingle then
  begin
    Inc(W);
    Inc(H);
  end;
  with AnImage.Canvas do
  begin
    Brush.Color := Color;
    FillRect(PaintRect);
    Brush.Color := BackColor;
    Pen.Color := ForeColor;
    Pen.Width := 1;
    Ellipse(PaintRect.Left, PaintRect.Top, W, H);
    if PercentDone > 0 then
    begin
      Brush.Color := ForeColor;
      MiddleX := W div 2;
      MiddleY := H div 2;
      Angle := (Pi * ((PercentDone / 50) + 0.5));
      Pie(PaintRect.Left, PaintRect.Top, W, H,
        Integer(Round(MiddleX * (1 - Cos(Angle)))),
        Integer(Round(MiddleY * (1 - Sin(Angle)))), MiddleX, 0);
    end;
  end;
end;

procedure TFAGauge.PaintAsNeedle(AnImage: TBitmap; PaintRect: TRect);
var
  MiddleX: Integer;
  Angle: Double;
  X, Y, W, H: Integer;
begin
  with PaintRect do
  begin
    X := Left;
    Y := Top;
    W := Right - Left;
    H := Bottom - Top;
    if FBorderStyle = bsSingle then
    begin
      Inc(W);
      Inc(H);
    end;
  end;
  with AnImage.Canvas do
  begin
    Brush.Color := Color;
    FillRect(PaintRect);
    Brush.Color := BackColor;
    Pen.Color := ForeColor;
    Pen.Width := 1;
    Pie(X, Y, W, H * 2 - 1, X + W, PaintRect.Bottom - 1, X, PaintRect.Bottom - 1);
    MoveTo(X, PaintRect.Bottom);
    LineTo(X + W, PaintRect.Bottom);
    if PercentDone > 0 then
    begin
      Pen.Color := ForeColor;
      MiddleX := Width div 2;
      MoveTo(MiddleX, PaintRect.Bottom - 1);
      Angle := (Pi * ((PercentDone / 100)));
      LineTo(Integer(Round(MiddleX * (1 - Cos(Angle)))),
        Integer(Round((PaintRect.Bottom - 1) * (1 - Sin(Angle)))));
    end;
  end;
end;

procedure TFAGauge.SetFAGaugeKind(Value: TFAGaugeKind);
begin
  if Value <> FKind then
  begin
    FKind := Value;
    Refresh;
  end;
end;

procedure TFAGauge.SetShowText(Value: Boolean);
begin
  if Value <> FShowText then
  begin
    FShowText := Value;
    Refresh;
  end;
end;

procedure TFAGauge.SetUnitText(Value: string);  // 추가
begin
  if Value <> FUnitText then
  begin
    FUnitText := Value;
    Refresh;
  end;
end;

procedure TFAGauge.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    Refresh;
  end;
end;

procedure TFAGauge.SetForeColor(Value: TColor);
begin
  if Value <> FForeColor then
  begin
    FForeColor := Value;
    Refresh;
  end;
end;

procedure TFAGauge.SetBackColor(Value: TColor);
begin
  if Value <> FBackColor then
  begin
    FBackColor := Value;
    Refresh;
  end;
end;

procedure TFAGauge.SetMinValue(Value: Longint);
begin
  if Value <> FMinValue then
  begin
    if Value > FMaxValue then
      if not (csLoading in ComponentState) then
        raise EInvalidOperation.CreateFmt(SOutOfRange, [-MaxInt, FMaxValue - 1]);
    FMinValue := Value;
    if FCurValue < Value then FCurValue := Value;
    Refresh;
  end;
end;

procedure TFAGauge.SetMaxValue(Value: Longint);
begin
  if Value <> FMaxValue then
  begin
    if Value < FMinValue then
      if not (csLoading in ComponentState) then
        raise EInvalidOperation.CreateFmt(SOutOfRange, [FMinValue + 1, MaxInt]);
    FMaxValue := Value;
    if FCurValue > Value then FCurValue := Value;
    Refresh;
  end;
end;

procedure TFAGauge.SetProgress(Value: Longint);
var
  TempPercent: Longint;
begin
  TempPercent := GetPercentDone;  { remember where we were }
  if Value < FMinValue then
    Value := FMinValue
  else if Value > FMaxValue then
    Value := FMaxValue;
  if FCurValue <> Value then
  begin
    FCurValue := Value;
    if Assigned(FOnChange) then  // 추가
      OnChange(Self);            //
    if TempPercent <> GetPercentDone then { only refresh if percentage changed }
      Refresh;
  end;
  //////////////////
  ThisToMemManValue;
  //////////////////
end;

procedure TFAGauge.AddProgress(Value: Longint);
begin
  Progress := FCurValue + Value;
  Refresh;
end;

//****************************************************************************//

procedure TFAGauge.SetAnalogMax(A: Single);
begin
  if A <> FAnalogMax then
  begin
    FAnalogMax := A;
    FMaxValue := Trunc(A);
  end;
end;

procedure TFAGauge.SetAnalogMin(A: Single);
begin
  if A <> FAnalogMin then
  begin
    FAnalogMin := A;
    FMinValue := Trunc(A);
  end;
end;

procedure TFAGauge.SetMemConvert(A: boolean);
begin
  if A <> FMemConvert then
  begin
    FMemConvert := A;
  end;
end;

procedure TFAGauge.SetMemName(A : TMemName);
begin
  if FMemName <> A then
  begin
    FMemName := A;
    SetDestMemName( FDestMemName );
  end;
end;

procedure TFAGauge.SetDestMemConvert(A: boolean);
begin
  if A <> FDestMemConvert then
  begin
    FDestMemConvert := A;
    if not FDestMemConvert then
      //FDestMemName := NONE
    else
      if FDestMemName <> NONE then
        SetDestMemName( FDestMemName );
  end;
end;

procedure TFAGauge.SetDestMemName(A : TMemName);
begin
  FDestMemName := NONE;  // 초기화 (SetDestMemConvert에서 호출때 적용)
  // DestMemConvert 가 True이면
  if FDestMemConvert then
  begin
    if (FMemName = A_MEM) or (FMemName = F_MEM) then
      if (A = R_MEM) or (A = W_MEM) then
        FDestMemName := A
      else
        ShowMessage('DestMemConvert가 True일때 FAMemName이 A,F_MEM이면'+chr(13)+chr(13)+'FADestMemName는 R,W_MEM으로 지정되어야 함');
    if (FMemName = R_MEM) or (FMemName = W_MEM) then
      if (A = A_MEM) or (A = F_MEM) then
        FDestMemName := A
      else
        ShowMessage('DestMemConvert가 True일때 FAMemName이 R,W_MEM이면'+chr(13)+chr(13)+'FADestMemName는 A,F_MEM으로 지정되어야 함');
  end
  else
    FDestMemName := A;
end;

//------------------------------------------------------------------------------
// 상위 TFAMemoryManager 와 통신을 위한 프로시져들
//------------------------------------------------------------------------------

// TpjhFAMemMan VCL을 등록할 때 ....
procedure TFAGauge.SeTFAMemMan(mm:TpjhFAMemMan);
begin
  FFAMemMan := mm;
end;

// The Notification method is called automatically when the component specified
// by AComponent is about to be inserted or removed. --> online help.
procedure TFAGauge.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  // 참조된 TFAMemMan이 제거 되었음을 통지 받았다면..
  if (Operation=opRemove) and (AComponent=FFAMemMan) then
    FFAMemMan := nil;
end;

procedure TFAGauge.Loaded;
begin
  inherited Loaded;
  // TFAMemMan로부터 메모리 변경시 통보받기 위하여 이 컴포넌트를 TFAMemMan에 등록한다.
  if FFAMemMan<>nil then
    FFAMemMan.RegisterNewsMember(Self, FAMemName, FAMemIndex);
end;

// TFAMemMan의 값을 이 컴포넌트에 대입...
procedure TFAGauge.MemManValueToThis;
var
  v: extended;
begin
  if (csDesigning in ComponentState) then
    Exit;

  v := 0; //초기화..
  // TFAMemMan이 본 컴포넌트에 지정되었다면..
  if FFAMemMan<>nil then
  begin
    // TFAMemMan의 값을 가져와 Casting한다..
    if FMemConvert then
    begin
      case FMemName of
        {PLC의 아날로그값(word) --> 엔지니어링값(double)}
        R_MEM : v := (FFAMemMan.GetR(FMemIndex) * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin;
        W_MEM : v := (FFAMemMan.GetW(FMemIndex) * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin;
        {엔지니어링값(double) --> PLC의 아날로그값(word)}
        A_MEM : v := trunc(((FFAMemMan.GetA(FMemIndex)-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin));
        F_MEM : v := trunc(((FFAMemMan.GetF(FMemIndex)-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin));
      end;
    end
    else
    begin
      case FMemName of
        R_MEM : v := FFAMemMan.GetR(FMemIndex);
        W_MEM : v := FFAMemMan.GetW(FMemIndex);
        A_MEM : v := FFAMemMan.GetA(FMemIndex);
        F_MEM : v := FFAMemMan.GetF(FMemIndex);
      end;
    end;
    // 값을 VCL에 반영.....
    Progress := trunc(v);
  end;
end;

// 이 컴포넌트의 값을 TFAMemMan에 반영시킨다.
procedure TFAGauge.ThisToMemManValue;
var
  v : extended;
begin
  if (csDesigning in ComponentState) then
    Exit;

  // TFAMemMan이 본 컴포넌트에 지정되었다면..
  if FFAMemMan<>nil then
  begin
    // 데이타 이동(FADestMemName) 기능 사용시 보내는값을 Progress값이 아닌, Memory값을 사용
    v := 0;
    case FMemName of
      R_MEM : v := FFAMemMan.GetR(FMemIndex);
      W_MEM : v := FFAMemMan.GetW(FMemIndex);
      A_MEM : v := FFAMemMan.GetA(FMemIndex);
      F_MEM : v := FFAMemMan.GetF(FMemIndex);
    end;

    if FDestMemConvert then
    begin
      case FDestMemName of
        {엔지니어링값(double) --> PLC의 아날로그값(word)}
        R_MEM : FFAMemMan.SetR( FDestMemIndex, trunc(((v-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin)) );
        W_MEM : FFAMemMan.SetW( FDestMemIndex, trunc(((v-FAnalogMin) * FPlcMax) / (FAnalogMax - FAnalogMin)) );
        {PLC의 아날로그값(word) --> 엔지니어링값(double)}
        A_MEM : FFAMemMan.SetA( FDestMemIndex, (v * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin );
        F_MEM : FFAMemMan.SetF( FDestMemIndex, (v * (FAnalogMax-FAnalogMin) / FPlcMax) + FAnalogMin );
      end;
    end
    else
    begin
      case FDestMemName of
        R_MEM : FFAMemMan.SetR( FDestMemIndex, trunc(v) );
        W_MEM : FFAMemMan.SetW( FDestMemIndex, trunc(v) );
        A_MEM : FFAMemMan.SetA( FDestMemIndex, v );
        F_MEM : FFAMemMan.SetF( FDestMemIndex, v );
      end;
    end;
  end;
end;

// 이 함수는 TFAMemMan과의 통신을 위하여 임의로 조작되었음..
// 사용에 주의하기 바람..
function TFAGauge.SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult;
var
  bFromMemMan: boolean;
begin
  // TpjhFAMemMan 에서 호출된 것인지를 확인하는 과정..
  bFromMemMan := False;

  if FFAMemMan<>nil then
  begin
    if (FFAMemMan = ExceptObject) and (ExceptAddr=nil) then
      bFromMemMan := True;
  end;

  // TFAMemMan에서 호출된 것이 확실하다면..
  if bFromMemMan then
  begin
    Result := 0;
    ApplyUpdate; // 강제 갱신 지시...
  end
  else
  begin
    // 원래의 용도로 호출된것이라면... 조상 함수를 Call..
    Result := inherited SafeCallException(ExceptObject,ExceptAddr);
  end;
end;

// 프로그램 상에서 혹은 TpjhFAMemMan 에 의해서 호출된다..
procedure TFAGauge.ApplyUpdate;
begin
  // 메모리 변경값을 반영..
  MemManValueToThis;
end;

end.
