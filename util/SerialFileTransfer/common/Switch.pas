unit Switch;

{$R SW.RES}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TCaptionPos = (posLeft, posRight, posCenter, posTop, posBottom);
  TCaptionStyle = (stFlat, stRaised, stSunken);
  TSwitch = class(TCustomControl)
  private
    { Private declarations }
    mEmer : TBitmap;
    mCaptionStyle : TCaptionStyle;
    mChecked : Boolean;
    mCaption : String;
    mCaptionPos : TCaptionPos;
    mDiameter : Cardinal;
    mOnColor : TColor;
    mFocused : Boolean;
    mDrawFocus : Boolean;

    Function GetCaptionPos : TCaptionPos;
    Procedure SetCaptionPos(p : TCaptionPos);
    Function GetCaptionStyle : TCaptionStyle;
    Procedure SetCaptionStyle(p : TCaptionStyle);
    Procedure SetChecked(Value : Boolean);
    Procedure Draw3DText(SX, SY : Integer; cap : String; st : TCaptionStyle);
    Procedure DrawCaption(r : TRect);
    Procedure DrawPicture;
    Procedure DrawFocus;
    Procedure SetCaption(Value : String);
    Procedure SetDiameter(Value : Cardinal);
    Procedure SetOnColor(Value : TColor);
    Procedure WMSetFocus(var Message : TWMSetFocus); Message WM_SETFOCUS;
    Procedure WMKillFocus(var Message : TWMKillFocus); Message WM_KILLFOCUS;
  protected
    { Protected declarations }
    Procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure Click; override;
published
    { Published declarations }
    Property CaptionStyle : TCaptionStyle Read GetCaptionStyle Write SetCaptionStyle;
    Property CaptionPos : TCaptionPos Read GetCaptionPos Write SetCaptionPos;
    Property Diameter : Cardinal Read mDiameter Write SetDiameter;
    property Enabled;
    Property Caption : String Read mCaption Write SetCaption;
    Property Checked : Boolean Read mChecked Write SetChecked;
    Property OnColor : TColor Read mOnColor Write SetOnColor;
    Property Font;
    Property Color;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    Property Focused : Boolean Read mFocused Write mFocused;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('°ø°³Btn', [TSwitch]);
end;

constructor TSwitch.Create(AOwner : TComponent);
Begin
     inherited Create(AOwner);
     mEmer := TBitmap.Create;
     mDiameter := 100;
     mChecked := True;
     mOnColor := clRed;
     mFocused := False;
     mDrawFocus := False;
End;

destructor TSwitch.Destroy;
Begin
    mEmer.Free;
    inherited Destroy;
End;

Function TSwitch.GetCaptionStyle : TCaptionStyle;
Begin
    Result := mCaptionStyle;
End;

Procedure TSwitch.SetCaptionStyle(p : TCaptionStyle);
Begin
    mCaptionStyle := p;
    Invalidate;
End;

Function TSwitch.GetCaptionPos : TCaptionPos;
Begin
    Result := mCaptionPos;
End;

Procedure TSwitch.SetCaptionPos(p : TCaptionPos);
Begin
    mCaptionPos := p;
    Invalidate;
End;

Procedure TSwitch.SetCaption(Value : String);
Begin
  mCaption := Value;
  Invalidate;
End;

Procedure TSwitch.SetChecked(Value : Boolean);
Begin
  mChecked := Value;
  Invalidate;
End;

Procedure TSwitch.SetDiameter(Value : Cardinal);
Begin
  If mDiameter <> Value Then
  Begin
    mDiameter := Value;
    Invalidate;
  End;
End;

Procedure TSwitch.SetOnColor(Value : TColor);
Begin
  If mOnColor <> Value Then
  Begin
    mOnColor := Value;
    DrawPicture;
  End;
End;

Procedure TSwitch.WMSetFocus(var Message : TWMSetFocus);
Begin
  mFocused := True;
  DrawFocus;
End;

Procedure TSwitch.WMKillFocus(var Message : TWMKillFocus);
Begin
  mFocused := False;
  DrawFocus;
End;

procedure TSwitch.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
  end;
end;

procedure TSwitch.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    mChecked := Not mChecked;
    DrawPicture;
  end;
end;

procedure TSwitch.Click;
begin
  inherited Click;
end;

Procedure TSwitch.DrawFocus;
Begin
  Canvas.Pen.Style := psDash;
  Canvas.Pen.Mode := pmNot;
  If mFocused Then
  Begin
    Canvas.Rectangle(0,0,Width, Height);
    mDrawFocus := True;
  End
  Else
  Begin
    If mDrawFocus Then
    Begin
      Canvas.Rectangle(0,0,Width, Height);
      mDrawFocus := False;
    End;
  End;
  Canvas.Pen.Mode := pmCopy;
  Canvas.Pen.Style := psSolid;
End;

Procedure TSwitch.Draw3DText(SX, SY : Integer; cap : String; st : TCaptionStyle);
Var
    PrevColor : TColor;
Begin
    SetBkMode(Canvas.Handle, TRANSPARENT);
    Case st Of
        stFlat:
                Canvas.TextOut(SX, SY, cap);
        stRaised:
            Begin
                PrevColor := Canvas.Font.Color;
                Canvas.Font.Color := clWhite;
                Canvas.TextOut(SX, SY, cap);
                Canvas.Font.Color := PrevColor;
                Canvas.TextOut(SX+1, SY+1, cap);
            End;
        stSunken:
            Begin
                PrevColor := Canvas.Font.Color;
                Canvas.Font.Color := clWhite;
                Canvas.TextOut(SX+1, SY+1, cap);
                Canvas.Font.Color := PrevColor;
                Canvas.TextOut(SX, SY, cap);
            End;
    End;
End;

Procedure TSwitch.DrawCaption(r : TRect);
Var
    SX, SY : Integer;
    TX, TY : Integer;
Begin
  TX := Canvas.TextWidth(mCaption);
  TY := Canvas.TextHeight(mCaption);
  Case mCaptionPos Of
    posLeft:
      Begin
          SX := 0;
          SY := (r.Bottom - TY) div 2;
      End;
    posRight:
      Begin
          SX := 32;
          SY := (r.Bottom - TY) div 2;
      End;
    posCenter:
      Begin
          SX := (r.Right - TX) div 2;
          SY := (r.Bottom - TY) div 2;
      End;
    posTop:
      Begin
          SX := (r.Right - TX) div 2;
          SY := 0;
      End;
    posBottom:
      Begin
          SX := (r.Right - TX) div 2;
          SY := 47
      End;
 End;
 Draw3DText(SX, SY, mCaption, mCaptionStyle);
End;

Procedure TSwitch.DrawPicture;
Var
   TX, TY : Integer;
   PicX, PicY : Integer;
Begin
  TX := Canvas.TextWidth(mCaption);
  TY := Canvas.TextHeight(mCaption);

  If Checked Then
    mEmer.Handle := LoadBitmap(hInstance, 'ON1')
  Else
    mEmer.Handle := LoadBitmap(hInstance, 'OFF1');

  Case mCaptionPos Of
    posLeft:
      Begin
        PicX := TX + 2;
        PicY := (Height - 45) div 2;
      End;
    posRight:
      Begin
        PicX := 0;
        PicY := (Height - 45) div 2;
      End;
    posCenter:
      Begin
        PicX := (Width - 30) div 2;
        PicY := (Height - 45) div 2;
      End;
    posTop:
      Begin
        PicX := (Width - 30) div 2;
        PicY := TY + 2;
      End;
    posBottom:
      Begin
        PicX := (Width - 30) div 2;
        PicY := 0;
      End;
    End;
   Canvas.Draw(PicX, PicY, TGraphic(mEmer));
   If mChecked Then
   Begin
     Canvas.Brush.Color := mOnColor;
     Canvas.FloodFill(PicX + 13,PicY + 30,clBlack, fsBorder);
   End
   Else
   Begin
     Canvas.Brush.Color := clGray;
     Canvas.FloodFill(PicX + 11,PicY + 26,clBlack, fsBorder);
   End;
End;

Procedure TSwitch.Paint;
Var
   i : Integer;
   rcDraw : TRect;
   PrevFont : TFont;
   TX, TY : Integer;
   PicX, PicY : Integer;
Begin
  rcDraw.Left := 0;
  rcDraw.Right := Width;
  rcDraw.Top := 0;
  rcDraw.Bottom := Height;
  TX := Canvas.TextWidth(mCaption);
  TY := Canvas.TextHeight(mCaption);

  If Checked Then
    mEmer.Handle := LoadBitmap(hInstance, 'ON1')
  Else
    mEmer.Handle := LoadBitmap(hInstance, 'OFF1');

  DrawPicture;
  PrevFont := Canvas.Font;
  Canvas.Font := Font;
  DrawCaption(rcDraw);
  Canvas.Font := PrevFont;
  DrawFocus;
End;

end.
