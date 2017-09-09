{------------------------------------------------------------------------------}
{ component  : ScrollPanel                                                     }
{ version    : 1.0                                                             }
{ last update: 2003/03/21                                                      }
{ written for: Borland Delphi 6.0                                              }
{ written by : jung-honey, Park                                                }
{ e-mail     : kuksundo@dreamwiz.com                                           }
{------------------------------------------------------------------------------}

unit ScrollPanel;

{==============================================================================}
interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.ExtCtrls;

{const
  cl3DHiLight  = COLOR_3DHILIGHT or $80000000;
  cl3DLight    = COLOR_3DLIGHT or $80000000;
  cl3DFace     = COLOR_3DFACE or $80000000;
  cl3DShadow   = COLOR_3DSHADOW or $80000000;
  cl3DDkShadow = COLOR_3DDKSHADOW or $80000000;
}
{ PanelWallpaper }
type
{  TPanelWallpaper_pjhStyle = (wpNone,wpCenter,wpStretch,wpTile);

  TPanelWallpaper_pjh = class(TPersistent)
  private
    FBitmap  : TBitmap;
    FStyle   : TPanelWallpaper_pjhStyle;
    FOnChange: TNotifyEvent;
    procedure SetBitmap(Value: TBitmap);
    procedure SetStyle(Value: TPanelWallpaper_pjhStyle);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Paint(Canvas: TCanvas; Rect: TRect; Color: TColor);
    property  OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property  Bitmap: TBitmap read FBitmap write SetBitmap;
    property  Style: TPanelWallpaper_pjhStyle read FStyle write SetStyle;
  end;
}
{ SimpleScroller }

  TCustomScroller_pjh = class(TScrollBox{TWinControl})
  private
    FCanvas     : TCanvas;

    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_EraseBkgnd;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected
    procedure PaintWindow(DC: HDC); override;
    procedure Paint; virtual;
    function  GetWorkspace: TRect; virtual;
    procedure SetWorkspace(AWidth,AHeight: Integer); virtual;
    property  Canvas: TCanvas read FCanvas;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

{ AdvancedScroller }

  TCustomAdvancedScroller_pjh = class(TCustomScroller_pjh)
  private
    //FWallpaper : TPanelWallpaper_pjh;
    //procedure SetWallpaper(Value: TPanelWallpaper_pjh);
    FGrid: TBitmap;
    FShowGrid: Boolean;
  protected
    procedure SetShowGrid(Value: Boolean);
    procedure DrawGrid; virtual;
    procedure Paint; override;
    //procedure WallpaperChange(Sender: TObject);
    //property  Wallpaper: TPanelWallpaper_pjh read FWallpaper write SetWallpaper;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ShowGrid: Boolean read fShowGrid write SetShowGrid default False;
  end;

implementation

{- TPanelWallpaper_pjh ------------------------------------------------------------}

{constructor TPanelWallpaper_pjh.Create;
begin
  inherited;
  FBitmap := TBitmap.Create;
  FStyle := wpCenter;
  FOnChange := nil;
end;

destructor TPanelWallpaper_pjh.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TPanelWallpaper_pjh.Assign;
begin
  if Source is TPanelWallpaper_pjh then begin
    FBitmap.Assign(TPanelWallpaper_pjh(Source).Bitmap);
    FStyle := TPanelWallpaper_pjh(Source).Style;
    if Assigned(FOnChange) then FOnChange(Self);
  end
  else inherited;
end;

procedure TPanelWallpaper_pjh.SetBitmap;
begin
  FBitmap.Assign(Value);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TPanelWallpaper_pjh.SetStyle;
begin
  if FStyle <> Value then begin
    FStyle := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPanelWallpaper_pjh.Paint;
var
  SrcRect  : TRect;
  SrcWidth : Integer;
  SrcHeight: Integer;
  DstRect  : TRect;
  DstWidth : Integer;
  DstHeight: Integer;
  SrcDC    : HDC;
  DstDC    : HDC;

  procedure PaintRect(X1,Y1,X2,Y2: Integer);
  begin
    if X1 < Rect.Left then X1 := Rect.Left;
    if Y1 < Rect.Top then Y1 := Rect.Top;
    if X2 > Rect.Right then X2 := Rect.Right;
    if Y2 > Rect.Bottom then Y2 := Rect.Bottom;
    if (X1 < X2) and (Y1 < Y2) then with Canvas do begin
      Brush.Color := Color;
      Brush.Style := bsSolid;
      FillRect(Bounds(X1,Y1,X2-X1,Y2-Y1));
    end;
  end;

begin
  if FBitmap.Empty then PaintRect(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom)
  else begin
    DstRect := Rect;
    DstDC := Canvas.Handle;
    SrcDC := FBitmap.Canvas.Handle;
    case FStyle of
      wpNone: begin
        BitBlt(DstDC,DstRect.Left,DstRect.Top,
               DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,
               SrcDC,0,0,SRCCOPY);
        PaintRect(Rect.Left+FBitmap.Width,Rect.Top,Rect.Right,Rect.Top+FBitmap.Height);
        PaintRect(Rect.Left,Rect.Top+FBitmap.Height,Rect.Right,Rect.Bottom);
      end;
      wpCenter: begin
        SrcRect := Bounds(0,0,FBitmap.Width,FBitmap.Height);
        SrcWidth := SrcRect.Right-SrcRect.Left;
        DstWidth := DstRect.Right-DstRect.Left;
        if SrcWidth > DstWidth then
          SrcRect.Left := SrcRect.Left+((SrcWidth-DstWidth) div 2)
        else if SrcWidth < DstWidth then begin
          DstRect.Left := DstRect.Left+((DstWidth-SrcWidth) div 2);
          DstRect.Right := DstRect.Left+SrcWidth;
        end;
        SrcHeight := SrcRect.Bottom-SrcRect.Top;
        DstHeight := DstRect.Bottom-DstRect.Top;
        if SrcHeight > DstHeight then
          SrcRect.Top := SrcRect.Top+((SrcHeight-DstHeight) div 2)
        else if SrcHeight < DstHeight then begin
          DstRect.Top := DstRect.Top+((DstHeight-SrcHeight) div 2);
          DstRect.Bottom := DstRect.Top+SrcHeight;
        end;
        BitBlt(DstDC,DstRect.Left,DstRect.Top,
               DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,
               SrcDC,SrcRect.Left,SrcRect.Top,SRCCOPY);
        PaintRect(Rect.Left,Rect.Top,Rect.Right,DstRect.Top);
        PaintRect(Rect.Left,DstRect.Top,DstRect.Left,DstRect.Bottom);
        PaintRect(DstRect.Right,DstRect.Top,Rect.Right,DstRect.Bottom);
        PaintRect(Rect.Left,DstRect.Bottom,Rect.Right,Rect.Bottom);
      end;
      wpStretch: begin
        SetStretchBltMode(DstDC,COLORONCOLOR);
        StretchBlt(DstDC,DstRect.Left,DstRect.Top,
                   DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,
                   SrcDC,0,0,FBitmap.Width,FBitmap.Height,SRCCOPY);
      end;
      wpTile: begin
        while DstRect.Top < DstRect.Bottom do begin
          BitBlt(DstDC,DstRect.Left,DstRect.Top,
                 DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,
                 SrcDC,0,0,SRCCOPY);
          Inc(DstRect.Left,FBitmap.Width);
          if DstRect.Left >= DstRect.Right then begin
            DstRect.Left := Rect.Left;
            Inc(DstRect.Top,FBitmap.Height);
          end;
        end;
      end;
    end;
  end;
end;

{- TCustomScroller_pjh ------------------------------------------------------}

constructor TCustomScroller_pjh.Create;
begin
  inherited;
  ControlStyle := [csAcceptsControls,csCaptureMouse,csClickEvents,csSetCaption,
                   csDoubleClicks];
  HorzScrollBar.Tracking := true;
  VertScrollBar.Tracking := true;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  Width := 145;
  Height := 145;
end;

destructor TCustomScroller_pjh.Destroy;
begin
  FCanvas.Free;
  inherited;
end;

procedure TCustomScroller_pjh.WMEraseBkgnd;
begin
  Message.Result := 1;
end;

procedure TCustomScroller_pjh.WMPaint;
begin
  PaintHandler(Message);
end;

procedure TCustomScroller_pjh.WMHScroll(var Message: TWMHScroll);
begin
  Invalidate;
  inherited;
end;

procedure TCustomScroller_pjh.WMVScroll(var Message: TWMVScroll);
begin
  Invalidate;
  inherited;
end;

procedure TCustomScroller_pjh.PaintWindow;
begin
  FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
      Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

procedure TCustomScroller_pjh.Paint;
begin
  //Invalidate;
end;

function TCustomScroller_pjh.GetWorkspace;
begin
  Result := ClientRect;
  if HorzScrollBar.Visible then begin
    Result.Right := Result.Left+HorzScrollBar.Range;
    Result.Left := 0-HorzScrollBar.Position;
  end;
  if VertScrollBar.Visible then begin
    Result.Top := 0-VertScrollBar.Position;
    Result.Bottom := Result.Top+VertScrollBar.Range;
  end;
end;

procedure TCustomScroller_pjh.SetWorkspace;
begin
  if AWidth <> HorzScrollBar.Range then HorzScrollBar.Range := AWidth;
  if AHeight <> VertScrollBar.Range then VertScrollBar.Range := AHeight;
end;

{- TCustomAdvancedScroller_pjh ----------------------------------------------------}

constructor TCustomAdvancedScroller_pjh.Create;
begin
  inherited;
  FGrid := TBitmap.Create;
  FGrid.Width := 8;
  FGrid.Height := 8;
  FShowGrid := True;
  //FWallpaper := TPanelWallpaper_pjh.Create;
  //FWallpaper.OnChange := WallpaperChange;
end;

destructor TCustomAdvancedScroller_pjh.Destroy;
begin
  //FWallpaper.Free;
  FGrid.Free;
  inherited;
end;

{procedure TCustomAdvancedScroller_pjh.SetWallpaper;
begin
  FWallpaper.Assign(Value);
end;

procedure TCustomAdvancedScroller_pjh.WallpaperChange;
begin
  Invalidate;
end;

}
procedure TCustomAdvancedScroller_pjh.DrawGrid;
var
  X, Y: Integer;
  ClientRect: TRect;
begin
  ClientRect := Canvas.ClipRect;
  with FGrid.Canvas do
  begin
    Brush.Color := Color;
    Brush.Style := bsSolid;
    FillRect(Rect(0, 0, 8, 8));
    Pixels[0,0] := clBlack;
  end;//with

  Canvas.Brush.Bitmap := FGrid;
  Canvas.FillRect(ClientRect);
  Canvas.Brush.Bitmap := nil;
end;

procedure TCustomAdvancedScroller_pjh.Paint;
var
  Rect: TRect;
begin
  Canvas.Lock;
  try
    inherited;

    if ShowGrid then
      DrawGrid;

    //Rect := GetClientRect;
    //if HorzScrollBar.Visible then Dec(Rect.Left,HorzScrollBar.Position);
    //if VertScrollBar.Visible then Dec(Rect.Top,VertScrollBar.Position);
    //if not FWallpaper.FBitmap.Empty then
      //FWallpaper.Paint(Canvas,Rect,Color);
  finally
    Canvas.Unlock;
  end;
end;

procedure TCustomAdvancedScroller_pjh.SetShowGrid(Value: Boolean);
begin
  if ShowGrid <> Value then
  begin
    fShowGrid := Value;
    Invalidate;
  end;
end;

end.
