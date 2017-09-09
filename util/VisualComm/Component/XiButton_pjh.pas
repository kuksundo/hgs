{=========================================================

      XiButton

      Author: Eugene Genev
      Web site: http://egenev.tripod.com
      E-mail: egenev@lycos.com

      Released: 12 May 2003

==========================================================}

unit XiButton_pjh;

interface

uses
  Windows, Classes, Controls, Graphics, Messages, Types, Forms;

type
  TBtnState = (bsNormal, bsOver, bsDown);
  TButtonLayout = (blGlyphLeft, blGlyphRight, blGlyphTop, blGlyphBottom);
  TColorScheme = (csDesert, csGrass, csSky, csSun, csRose, csSilver, csCustom);

  TXiButton_pjh = class(TGraphicControl)//(TCustomControl)
  private
    FColorFace: TColor;
    FColorBorder: TColor;
    FColorLight: TColor;
    FColorDark: TColor;
    FColorText: TColor;
    FOverColorFace: TColor;
    FOverColorBorder: TColor;
    FOverColorLight: TColor;
    FOverColorDark: TColor;
    FOverColorText: TColor;
    FDownColorFace: TColor;
    FDownColorBorder: TColor;
    FDownColorLight: TColor;
    FDownColorDark: TColor;
    FDownColorText: TColor;
    FDisabledColorFace:TColor;
    FDisabledColorBorder: TColor;
    FDisabledColorLight: TColor;
    FDisabledColorDark: TColor;
    FDisabledColorText: TColor;
    FColorFocusRect: TColor;
    FFocused: Boolean;
    FColorScheme: TColorScheme;
    FCtl3D: boolean;
    FLayout: TButtonLayout;
    FGlyph: TBitmap;
    FTransparentGlyph: Boolean;
    FSpacing: integer;
    FModalResult: TModalResult;
    FCancel: Boolean;
    FDefault: Boolean;
    FHotTrack: Boolean;
    FClicked: Boolean;
    procedure SetColors(Index: integer; Value: TColor);
    procedure SetColorScheme(Value: TColorScheme);
    procedure SetCtl3D(Value: Boolean);
    procedure SetLayout(Value: TButtonLayout);
    procedure SetGlyph(Value: TBitmap);
    procedure SetTransparentGlyph(Value: Boolean);
    procedure SetSpacing(Value: Integer);
    procedure SetModalResult(Value: TModalResult);
    procedure SetCancel(Value: Boolean);
    procedure SetDefault(Value: Boolean);
    procedure SetHotTrack(Value: Boolean);
  protected
    FBtnState: TBtnState;
    procedure Paint; override;
    procedure Click; Override;
    procedure MouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove (Shift: TShiftState; X, Y: Integer); override;
    procedure WMSetFocus(var msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMKeyUp(var msg: TWMKeyUp); message WM_KEYUP;
    procedure WMKeyDown(var msg: TWMKeyDown); message WM_KEYDOWN;
    procedure CMDialogKey(var msg: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var msg: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMTextChanged (var msg: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var msg: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged (var msg: TMessage); message CM_ENABLEDCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ColorFace: TColor index 0 read FColorFace write SetColors;
    property ColorDark: TColor index 1 read FColorDark write SetColors;
    property ColorLight: TColor index 2 read FColorLight write SetColors;
    property ColorBorder: TColor index 3 read FColorBorder write SetColors;
    property ColorText: TColor index 4 read FColorText write SetColors;
    property OverColorFace: TColor index 5 read FOverColorFace write SetColors;
    property OverColorDark: TColor index 6 read FOverColorDark write SetColors;
    property OverColorLight: TColor index 7 read FOverColorLight write SetColors;
    property OverColorBorder: TColor index 8 read FOverColorBorder write SetColors;
    property OverColorText: TColor index 9 read FOverColorText write SetColors;
    property DownColorFace: TColor index 10 read FDownColorFace write SetColors;
    property DownColorDark: TColor index 11 read FDownColorDark write SetColors;
    property DownColorLight: TColor index 12 read FDownColorLight write SetColors;
    property DownColorBorder: TColor index 13 read FDownColorBorder write SetColors;
    property DownColorText: TColor index 14 read FDownColorText write SetColors;
    property DisabledColorFace: TColor index 15 read FDisabledColorFace write SetColors;
    property DisabledColorDark: TColor index 16 read FDisabledColorDark write SetColors;
    property DisabledColorLight: TColor index 17 read FDisabledColorLight write SetColors;
    property DisabledColorBorder: TColor index 18 read FDisabledColorBorder write SetColors;
    property DisabledColorText: TColor index 19 read FDisabledColorText write SetColors;
    property ColorFocusRect: TColor index 20 read FColorFocusRect write SetColors;
    property ColorScheme: TColorScheme read FColorScheme write SetColorScheme;
    property Ctl3D: Boolean read FCtl3D write SetCtl3D;
    property Layout: TButtonLayout read FLayout write SetLayout;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property Spacing: integer read FSpacing write SetSpacing;
    property TransparentGlyph: Boolean read FTransparentGlyph write SetTransparentGlyph;
    property HotTrack: Boolean read FHotTrack write FHotTrack;
    property Action;
    property Align;
    property Anchors;
    property BiDiMode;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Caption;
    property Constraints;
    property Default: Boolean read FDefault write SetDefault default False;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ModalResult: TModalResult read FModalResult write SetModalResult default 0;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    //property TabOrder;
    //property TabStop default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    //property OnEnter;
    //property OnExit;
    //property OnKeyDown;
    //property OnKeyPress;
    //property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

//{$R XiButton.res}

implementation

procedure Register;
begin
  RegisterComponents('°ø°³Btn', [TXiButton_pjh]);
end;

constructor TXiButton_pjh.Create(AOwner: TComponent);
begin
  inherited;
  Width:= 75;
  Height:= 25;
  FCtl3D:= True;
  FGlyph:= TBitmap.Create;
  TransparentGlyph:= True;
  //TabStop:= True;
  FSpacing:= 4;
  FCancel:= False;
  FDefault:= False;
  FHotTrack:= True;
  ColorScheme:= csDesert;
  FClicked:= False;
end;

procedure TXiButton_pjh.Paint;
var
  BtnBmp: TBitmap;
  CaptionRect: TRect;
  GlyphLeft, GlyphTop, TextTop, TextLeft, TextWidth, TextHeight: integer;
  FaceColor, LightColor, DarkColor, BorderColor, TextColor: TColor;
begin
  BtnBmp:= TBitmap.Create;
  BtnBmp.Width:= Width;
  BtnBmp.Height:= Height;

  case FBtnState of
    bsNormal: begin
                FaceColor:= FColorFace;
                LightColor:= FColorLight;
                DarkColor:= FColorDark;
                BorderColor:= FColorBorder;
                TextColor:= FColorText;
              end;

    bsOver:   begin
                FaceColor:= FOverColorFace;
                LightColor:= FOverColorLight;
                DarkColor:= FOverColorDark;
                BorderColor:= FOverColorBorder;
                TextColor:= FOverColorText;
              end;

    bsDown:   begin
                FaceColor:= FDownColorFace;
                LightColor:= FDownColorLight;
                DarkColor:= FDownColorDark;
                BorderColor:= FDownColorBorder;
                TextColor:= FDownColorText;
              end;
  end;
  if not Enabled then begin
    FaceColor:= FDisabledColorFace;
    LightColor:= FDisabledColorLight;
    DarkColor:= FDisabledColorDark;
    BorderColor:= FDisabledColorBorder;
    TextColor:= FDisabledColorText;
  end;

  with BtnBmp.Canvas do begin
    Brush.Color:= FaceColor;
    Brush.Style:= bsSolid;
    Rectangle(0, 0, Width, Height);
  end;

  BtnBmp.Canvas.Font:= Font;
  BtnBmp.Canvas.Font.Color:= TextColor;
  TextWidth:= BtnBmp.Canvas.TextWidth(Caption);
  TextHeight:= BtnBmp.Canvas.TextHeight(Caption);
  TextTop:= (Height - TextHeight) div 2;
  TextLeft:= (Width - TextWidth) div 2;

  if not Glyph.Empty then begin
    GlyphLeft:= 0;
    case FLayout of
      blGlyphLeft:   begin
                       GlyphTop:= (Height - FGlyph.Height) div 2;
                       GlyphLeft:= TextLeft - FGlyph.Width div 2;
                       inc(TextLeft, FGlyph.Width div 2);
                       if not (Caption = '') then begin
                         GlyphLeft:= GlyphLeft - FSpacing div 2 - FSpacing mod 2;
                         inc(TextLeft, FSpacing div 2);
                       end;
                     end;
      blGlyphRight:  begin
                       GlyphTop:= (Height - FGlyph.Height) div 2;
                       GlyphLeft:= TextLeft + TextWidth - FGlyph.Width div 2;
                       inc(TextLeft, - FGlyph.Width div 2);
                       if not (Caption = '') then begin
                         GlyphLeft:= GlyphLeft + FSpacing div 2 + FSpacing mod 2;
                         inc(TextLeft, - FSpacing div 2);
                       end;
                     end;
      blGlyphTop:    begin
                       GlyphLeft:= (Width - FGlyph.Width) div 2;
                       GlyphTop:= TextTop - FGlyph.Height div 2 - FGlyph.Height mod 2;
                       inc(TextTop, FGlyph.Height div 2);
                       if not (Caption = '') then begin
                         GlyphTop:= GlyphTop - FSpacing div 2 - FSpacing mod 2;
                         inc(TextTop, + FSpacing div 2);
                       end;
                     end;
      blGlyphBottom: begin
                       GlyphLeft:= (Width - FGlyph.Width) div 2;
                       GlyphTop:= TextTop + TextHeight - Glyph.Height div 2;
                       inc(TextTop, - FGlyph.Height div 2);
                       if not (Caption = '') then begin
                         GlyphTop:= GlyphTop + FSpacing div 2 + FSpacing mod 2;
                         inc(TextTop, - FSpacing div 2);
                       end;
                     end;
    end;
    
    if FBtnState = bsDown then begin
      inc(GlyphTop, 1);
      inc(GlyphLeft, 1);
    end;
    FGlyph.TransparentColor:= FGlyph.Canvas.Pixels[0, 0];
    FGlyph.Transparent:= FTransparentGlyph;
    BtnBmp.Canvas.Draw(GlyphLeft, GlyphTop, FGlyph);
  end;
  if FBtnState = bsDown then begin
    inc(TextTop);
    inc(TextLeft);
  end;
  with CaptionRect do begin
    Top:= TextTop;
    Left:=TextLeft;
    Right:= Left + TextWidth;
    Bottom:= Top + TextHeight;
  end;
  DrawText(BtnBmp.Canvas.Handle, PChar(Caption), length(Caption), CaptionRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE);

  with BtnBmp.Canvas do begin
    Pen.Style:= psSolid;
    Brush.Color:= FaceColor;
    Pen.Color:= BorderColor;
    Brush.Style:= bsClear;
    Rectangle(0, 0, Width, Height);

    if Ctl3D then begin
      Pen.Color:= LightColor;
      MoveTo(1, Height-2);
      LineTo(1, 1);
      LineTo(Width -1 , 1);

      Pen.Color:= DarkColor;
      MoveTo(Width-2, 1);
      LineTo(Width-2, Height-2);
      LineTo(1, Height-2);
    end;
  end;

  if FFocused then begin
    BtnBmp.Canvas.Pen.Color:= FColorFocusRect;
    BtnBmp.Canvas.Brush.Style:= bsClear;
    BtnBmp.Canvas.Rectangle(3, 3, Width-3, Height-3)
  end;

  Canvas.Draw(0, 0, BtnBmp);
  BtnBmp.Free;
end;

procedure TXiButton_pjh.Click;
begin
  if Parent <> nil then
    GetParentForm(self).ModalResult:= ModalResult;
  FBtnState:= bsNormal;
  Paint;
  inherited;
end;

procedure TXiButton_pjh.MouseEnter(var msg: TMessage);
begin
  if csDesigning in ComponentState then exit;
  if not FHotTrack then exit;
  if FClicked then
    FBtnState:= bsDown
  else
    FBtnState:= bsOver;
  Paint;
end;

procedure TXiButton_pjh.MouseLeave(var msg: TMessage);
begin
  inherited;
  FBtnState:= bsNormal;
  Paint;
end;

procedure TXiButton_pjh.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button <> mbLeft then Exit;
  FClicked:= True;
  FBtnState:= bsDown;
  //if TabStop then SetFocus;
  Paint;
end;

procedure TXiButton_pjh.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FClicked:= False;
  if (x>0) and (y>0) and (x<width) and (y<height) then
    if FHotTrack then FBtnState:= bsOver
  else
    FBtnState:= bsNormal;
  Paint;
end;

procedure TXiButton_pjh.MouseMove (Shift: TShiftState; X, Y: Integer);
begin
  inherited;
end;

procedure TXiButton_pjh.WMSetFocus(var msg: TWMSetFocus);
begin
  FFocused:= true;
  Paint;
end;

procedure TXiButton_pjh.WMKillFocus(var msg: TWMKillFocus);
begin
  FFocused:= false;
  FBtnState:= bsNormal;
  Paint;
end;

procedure TXiButton_pjh.WMKeyDown(var msg: TWMKeyDown);
begin
  if msg.CharCode = VK_SPACE then FBtnState:= bsDown;
  if msg.CharCode = VK_RETURN then Click;
  Paint;
end;

procedure TXiButton_pjh.WMKeyUp(var msg: TWMKeyUp);
begin
  if (msg.CharCode = VK_SPACE) then begin
    FBtnState:= bsNormal;
    Paint;
    Click;
  end;
end;

procedure TXiButton_pjh.CMTextChanged (var msg: TMessage);
begin
  Invalidate;
end;

procedure TXiButton_pjh.SetCtl3D(Value: Boolean);
begin
  FCtl3D:= Value;
  Invalidate;
end;

procedure TXiButton_pjh.SetLayout(Value: TButtonLayout);
begin
  FLayout:= Value;
  Invalidate;
end;

procedure TXiButton_pjh.SetGlyph(Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Invalidate;
end;

procedure TXiButton_pjh.SetSpacing(Value: integer);
begin
  FSpacing:= Value;
  Invalidate;
end;

procedure TXiButton_pjh.SetTransparentGlyph(Value: Boolean);
begin
  FTransparentGlyph:= Value;
  Invalidate;
end;

procedure TXiButton_pjh.CMFontChanged(var msg: TMessage);
begin
  Invalidate;
end;

procedure TXiButton_pjh.CMDialogKey(var msg: TCMDialogKey);
begin
  with msg do begin
    if  (((CharCode = VK_RETURN) and FFocused) or
         ((CharCode = VK_ESCAPE) and FCancel)) and
         (KeyDataToShiftState(KeyData) = []) then//and CanFocus
    begin
      Click;
      Result := 1;
    end else if FDefault  then begin
      Click;
      Result := 1;
    end
    else inherited;
  end;
end;

procedure TXiButton_pjh.CMEnabledChanged(var msg: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TXiButton_pjh.CMDialogChar(var msg: TCMDialogChar);
begin
  with msg do
    if IsAccel(CharCode, Caption) and Enabled then begin
      Click;
      Result := 1;
    end;
end;

procedure TXiButton_pjh.SetModalResult(Value: TModalResult);
begin
  FModalResult:= Value;
end;

procedure TXiButton_pjh.SetCancel(Value: Boolean);
begin
  FCancel:= Value;
end;

procedure TXiButton_pjh.SetDefault(Value: Boolean);
var
  Form: TCustomForm;
begin
  FDefault := Value;
{  if HandleAllocated then
  begin
    Form := GetParentForm(Self);
    if Form <> nil then
      Form.Perform(CM_FOCUSCHANGED, 0, Longint(Form.ActiveControl));
  end;
}
end;

procedure TXiButton_pjh.SetHotTrack(Value: Boolean);
begin
  FHotTrack:= Value;
  Invalidate;
end;

procedure TXiButton_pjh.SetColors(Index: Integer; Value: TColor);
begin
  case Index of
    0: FColorFace:= Value;
    1: FColorDark:= Value;
    2: FColorLight:= Value;
    3: FColorBorder:= Value;
    4: FColorText:= Value;
    5: FOverColorFace:= Value;
    6: FOverColorDark:= Value;
    7: FOverColorLight:= Value;
    8: FOverColorBorder:= Value;
    9: FOverColorText:= Value;
    10: FDownColorFace:= Value;
    11: FDownColorDark:= Value;
    12: FDownColorLight:= Value;
    13: FDownColorBorder:= Value;
    14: FDownColorText:= Value;
    15: FDisabledColorFace:= Value;
    16: FDisabledColorDark:= Value;
    17: FDisabledColorLight:= Value;
    18: FDisabledColorBorder:= Value;
    19: FDisabledColorText:= Value;
    20: FColorFocusRect:= Value;
  end;
  ColorScheme:= csCustom;
  Invalidate;
end;

procedure TXiButton_pjh.SetColorScheme(Value: TColorScheme);
begin
  FColorScheme:= Value;
  case FColorScheme of
  csDesert:      begin
                   ColorFace:=$0095DDFF;
                   ColorLight:=$00B9E7FF;
                   ColorDark:=$00009CE8;
                   ColorBorder:=$00005680;
                   ColorText:=clBlack;
                   OverColorFace:=$006FD0FF;
                   OverColorLight:=$0095DAFF;
                   OverColorDark:=$00008ED2;
                   OverColorBorder:=$00005680;
                   OverColorText:=clBlack;
                   DownColorFace:=$006FD0FF;
                   DownColorLight:=$000077B7;
                   DownColorDark:=$008AD9FF;
                   DownColorBorder:=$000070A6;
                   DownColorText:=clBlack;
                   DisabledColorFace:=$00E2E2E2;
                   DisabledColorLight:=$00EAEAEA;
                   DisabledColorDark:=$00D8D8D8;
                   DisabledColorBorder:=$00C4C4C4;
                   DisabledColorText:=clGray;
                   ColorFocusRect:= $004080FF;
                 end;
  csGrass:       begin
                   ColorFace:=$0098EBB7;
                   ColorLight:=$00CBF5DB;
                   ColorDark:=$0024B95C;
                   ColorBorder:=$00156F37;
                   ColorText:=clBlack;
                   OverColorFace:=$0068E196;
                   OverColorLight:=$00B5F0CB;
                   OverColorDark:=$0023B459;
                   OverColorBorder:=$0017793D;
                   OverColorText:=clBlack;
                   DownColorFace:=$004EDC83;
                   DownColorLight:=$00177D3E;
                   DownColorDark:=$0089E7AC;
                   DownColorBorder:=$00167439;
                   DownColorText:=clBlack;
                   DisabledColorFace:=$00E2E2E2;
                   DisabledColorLight:=$00EAEAEA;
                   DisabledColorDark:=$00D8D8D8;
                   DisabledColorBorder:=$00C4C4C4;
                   DisabledColorText:=clGray;
                   ColorFocusRect:= $0000A421;
                 end;
   csSky:        begin
                   ColorFace:=$00FFE0C1;
                   ColorLight:=$00FFECD9;
                   ColorDark:=$00FFA953;
                   ColorBorder:=$00B35900;
                   ColorText:=clBlack;
                   OverColorFace:=$00FFCD9B;
                   OverColorLight:=$00FFE4CA;
                   OverColorDark:=$00FFB164;
                   OverColorBorder:=$00B35900;
                   OverColorText:=clBlack;
                   DownColorFace:=$00FFC082;
                   DownColorLight:=$00FF9122;
                   DownColorDark:=$00FFD3A8;
                   DownColorBorder:=$00B35900;
                   DownColorText:=clBlack;
                   DisabledColorFace:=$00E2E2E2;
                   DisabledColorLight:=$00EAEAEA;
                   DisabledColorDark:=$00D8D8D8;
                   DisabledColorBorder:=$00C4C4C4;
                   DisabledColorText:=clGray;
                   ColorFocusRect:= $00DC9B14;
                 end;
   csRose:  begin
                   ColorFace:=$00C6C6FF;
                   ColorLight:=$00DDDDFF;
                   ColorDark:=$008282FF;
                   ColorBorder:=$0000009D;
                   ColorText:=clBlack;
                   OverColorFace:=$00B0B0FF;
                   OverColorLight:=$00D7D7FF;
                   OverColorDark:=$006A6AFF;
                   OverColorBorder:=$0000009D;
                   OverColorText:=clBlack;
                   DownColorFace:=$009F9FFF;
                   DownColorLight:=$005E5EFF;
                   DownColorDark:=$008888FF;
                   DownColorBorder:=$0000009D;
                   DownColorText:=clBlack;
                   DisabledColorFace:=$00E2E2E2;
                   DisabledColorLight:=$00EAEAEA;
                   DisabledColorDark:=$00D8D8D8;
                   DisabledColorBorder:=$00C4C4C4;
                   DisabledColorText:=clGray;
                   ColorFocusRect:= $005E5EFF;
                 end;
  csSun:         begin
                   ColorFace:=$00A8FFFF;
                   ColorLight:=$00F2FFFF;
                   ColorDark:=$0000BBBB;
                   ColorBorder:=$00006464;
                   ColorText:=clBlack;
                   OverColorFace:=$0066F3FF;
                   OverColorLight:=$00CCFFFF;
                   OverColorDark:=$0000A6A6;
                   OverColorBorder:=$00006464;
                   OverColorText:=clBlack;
                   DownColorFace:=$0022EEFF;
                   DownColorLight:=$00008484;
                   DownColorDark:=$0066F3FF;
                   DownColorBorder:=$00006464;
                   DownColorText:=clBlack;
                   DisabledColorFace:=$00E2E2E2;
                   DisabledColorLight:=$00EAEAEA;
                   DisabledColorDark:=$00D8D8D8;
                   DisabledColorBorder:=$00C4C4C4;
                   DisabledColorText:=clGray;
                   ColorFocusRect:= $00008CF4;
                 end;
  csSilver:      begin
                   ColorFace:=$00E0E0E0;
                   ColorLight:=$00F7F7F7;
                   ColorDark:=$00AEAEAE;
                   ColorBorder:=$00626262;
                   ColorText:=clBlack;
                   OverColorFace:=$00CFCFCF;
                   OverColorLight:=$00EEEEEE;
                   OverColorDark:=$00797979;
                   OverColorBorder:=$00757575;
                   OverColorText:=clBlack;
                   DownColorFace:=$00D3D3D3;
                   DownColorLight:=$007C7C7C;
                   DownColorDark:=$00E9E9E9;
                   DownColorBorder:=$004E4E4E;
                   DownColorText:=clBlack;
                   DisabledColorFace:=$00E2E2E2;
                   DisabledColorLight:=$00EAEAEA;
                   DisabledColorDark:=$00D8D8D8;
                   DisabledColorBorder:=$00C4C4C4;
                   DisabledColorText:=clGray;
                   ColorFocusRect:= $008A8A8A;
                 end;
  end;
  Invalidate;
  FColorScheme:= Value;
end;

end.
