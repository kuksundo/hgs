{
  Unit pgVirtualScrollbox

  TpgVirtScrollbox is a TCustomControl descendant just like TScrollBox but it will
  not create a bigger canvas than the normal client size. Scrolling is based on
  the parameters VirtualWidth, VirtualHeight (the "virtual area") and VirtualLeft,
  VirtualTop, which form the upperleft corner of the virtual window.

  With SetVirtualBounds() you can set all bounds at once to avoid flicker.

  With ScrollBy() you can scroll the window by an amount DeltaX, DeltaY. Scrollbar
  positions as well as internal variables are updated, and minima/maxima are checked.

  Project: Pyro

  Creation Date: 11nov2003 (NH)
  Version: 1.0

  Modifications:
  12jun2011: replaced units Windows.pas and FLAT_SB.pas by unit pgPlatform.pas,
   to create platform-independent code

  Copyright (c) 2003 - 2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
}
unit pgVirtualScrollbox;

interface

uses
  Forms, Classes, Graphics, Controls, Dialogs, Messages, SysUtils,
  pgControlUsingPyro, pgCanvas, pgPlatform, Pyro, pgWinGDI;

type

  // The TpgVirtScrollBox is a windowed control that can virtually scroll over its
  // scrollable area, indicated by VirtualWidth and VirtualHeight. The left and top
  // position of the virtual window is indicated by VirtualLeft and VirtualTop. Set
  // them all together using SetVirtualBounds() in order to avoid flicker
  TpgVirtualScrollBox = class(TpgPyroControl)
  private
    FAutoScroll: Boolean;    // If set, the control will automatically scroll
    FBorderStyle: TBorderStyle; // Border style for this scrollbox (bsNone or bsSingle)
    FBoxPlacement: TpgBoxPlacement; // Default placement when scrollbox is smaller than client
    FVirtualLeft: integer;    // Left position of virtual window relative to client (0,0)
    FVirtualTop: integer;     // Top position of virtual window relative to client (0, 0)
    FVirtualWidth: integer;   // Total width of virtual window
    FVirtualHeight: integer;  // Total height of virtual window
    FScrollScale: single;    // Scale on scrolling in case Width or Height > 32767 (handled automatically)
    FTracking: boolean;      // If set (default), the window updates immediately when scrollbars are moved
    FIncrement: integer;     // Increment (in pixels) when arrows on scrollbar are clicked
    FOnVirtualWindowChanged: TNotifyEvent;
    procedure SetAutoScroll(const Value: Boolean);
    procedure ProcessScrollMessage(const AMessage: TWMHScroll; ACode: word; var APos: integer; ASize, AClient: integer);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure SetBorderStyle(const Value: TBorderStyle);
    function CalculateThumbPosition(const Requested, Size, Client: integer): integer;
    procedure SetBoxPlacement(const Value: TpgBoxPlacement);
    function GetVirtualRect: TpgRect;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure PaintBackground(Canvas: TpgCanvas); virtual;
    procedure Paint; override;
    procedure RemoveScrollbars;
    // Update the scrollbars, returns true if FVirtualLeft or FVirtualTop changed
    function UpdateScrollbars: boolean;
    procedure DoVirtualWindowChanged; virtual;
    property AutoScroll: Boolean read FAutoScroll write SetAutoScroll default True;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property BoxPlacement: TpgBoxPlacement read FBoxPlacement write SetBoxPlacement default bpCenter;
    property Increment: integer read FIncrement write FIncrement default 8;
    // Left position of client in virtual window
    property VirtualLeft: integer read FVirtualLeft;
    // Top position of client in virtual window
    property VirtualTop: integer read FVirtualTop;
    // Total width of virtual window
    property VirtualWidth: integer read FVirtualWidth;
    // Total height of virtual window
    property VirtualHeight: integer read FVirtualHeight;
    // Returns rectangle of virtual window relative to client window
    property VirtualRect: TpgRect read GetVirtualRect;
    property Tracking: boolean read FTracking write FTracking default True;
    // Event OnVirtualWindowChanged is fired whenever the virtual window changes
    // (user has scrolled or set through code).
    property OnVirtualWindowChanged: TNotifyEvent read FOnVirtualWindowChanged write FOnVirtualWindowChanged;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetVirtualBounds(ALeft, ATop, AWidth, AHeight: integer); virtual;
    procedure ScrollBy(var DeltaX, DeltaY: integer); virtual;
    // Use ClientToBox to determine the position of mouse coordinates X and Y in
    // box coordinates. If the mouse is outside the box, the function returns False.
    function ClientToBox(X, Y: integer; var BoxX, BoxY: integer): boolean;
  end;

implementation

{ TpgVirtualScrollBox }

procedure TpgVirtualScrollBox.DoVirtualWindowChanged;
// Override in descendants to update a label that displays scroll position etc
begin
  // Default fires event
  if assigned(FOnVirtualWindowChanged) then
    FOnVirtualWindowChanged(Self);
end;

function TpgVirtualScrollBox.CalculateThumbPosition(const Requested, Size, Client: integer): integer;
var
  OverShoot: integer;
begin
  if FBoxPlacement = bpCenter then
  begin
    if Size = 0 then
      OverShoot := 0
    else
      OverShoot := pgMax(0, Client - Size);
  end else
    OverShoot := 0;
  Result := pgMax(-OverShoot div 2, pgMin(Requested, Size - Client));
end;

function TpgVirtualScrollBox.ClientToBox(X, Y: integer; var BoxX, BoxY: integer): boolean;
begin
  BoxX := 0;
  BoxY := 0;
  Result := False;
  if (FVirtualWidth <= 0) or (FVirtualHeight <= 0) then
    exit;
  BoxX := X - FVirtualLeft;
  BoxY := Y - FVirtualTop;
  if (BoxX >= 0) and (BoxX < FVirtualWidth) and (BoxY >= 0) and (BoxY < FVirtualHeight) then
    Result := True;
end;

constructor TpgVirtualScrollBox.Create(AOwner: TComponent);
begin
  inherited;
  FAutoScroll := True;
  FIncrement := 9;
  FScrollScale  := 1.0;
  FTracking := True;
  FillBackground := False;
  Color := clAppWorkspace;
  Width := 150;
  Height := 250;
  FBorderStyle := bsNone;//bsSingle;
end;

procedure TpgVirtualScrollBox.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of longword = (0, pgWS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    with WindowClass do
      style := style and not (pgCS_HREDRAW or pgCS_VREDRAW);
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not pgWS_BORDER;
      ExStyle := ExStyle or pgWS_EX_CLIENTEDGE;
    end;
  end;
end;

function TpgVirtualScrollBox.GetVirtualRect: TpgRect;
begin
  Result := pgRect(FVirtualLeft, FVirtualTop, FVirtualWidth + FVirtualLeft, FVirtualHeight + FVirtualTop);
end;

procedure TpgVirtualScrollBox.Paint;
// Override this method in descendants. Call "inherited" if you want to automatically
// clear the area that is outside of the scrollbox
begin
  PaintBackground(Canvas);
end;

procedure TpgVirtualScrollBox.PaintBackground(Canvas: TpgCanvas);
// Override this method in descendants.
// clear the area that is outside of the virtual box
var
  C, R, B, Dest: TpgRect;
  Col: TpgColor32;

  // local
  procedure PaintRect;
  begin
    if pgIsRectEmpty(R) then
      exit;
    pgIntersectRect(Dest, R, C);
    if pgIsRectEmpty(Dest) then
      exit;
    Canvas.FillDeviceRect(Dest, Col);
  end;

// main
begin
  C := Canvas.DeviceRect;
  Col := GDIToColor32(Color, $FF);
  B := GetVirtualRect;
  R := pgRect(0, 0, ClientWidth, ClientHeight);
  pgIntersectRect(Dest, B, R);
  if pgEqualRect(Dest, R) then
    exit;

  R := pgRect(0, 0, ClientWidth, B.Top);
  PaintRect;
  R := pgRect(0, B.Top, B.Left, B.Bottom);
  PaintRect;
  R := pgRect(B.Right, B.Top, ClientWidth, B.Bottom);
  PaintRect;
  R := pgRect(0, B.Bottom, ClientWidth, ClientHeight);
  PaintRect;
end;

procedure TpgVirtualScrollBox.ProcessScrollMessage(const AMessage: TWMHScroll; ACode: word;
  var APos: integer; ASize, AClient: integer);

  // local
  procedure SetPosition(ANewPos: single);
  var
    NewPos: single;
    Delta: integer;
    IntPos: integer;
  begin
    // Calculate new position
    NewPos := pgMin(pgMax(0, ANewPos), pgMax(0, ASize - AClient));
    Delta := round(NewPos - APos);
    if Delta = 0 then
      exit; // no changes

    APos := round(NewPos);
    DoVirtualWindowChanged;

    // Scroll the window
    case ACode of
    pgSB_HORZ: pgScrollWindow(Handle, -Delta, 0, nil, nil);
    pgSB_VERT: pgScrollWindow(Handle, 0, -Delta, nil, nil);
    end;//case

    // Set scrollbar position
    IntPos := round(ANewPos * FScrollScale);
    if pgGetScrollPos(Handle, ACode) <> IntPos then
      pgSetScrollPos(Handle, ACode, IntPos, True);
  end;

// main
begin
  if not AutoScroll then
    exit;
  with AMessage do
  begin
    case ScrollCode of
    pgSB_LINEUP:        SetPosition(APos - Increment);
    pgSB_LINEDOWN:      SetPosition(APos + Increment);
    pgSB_PAGEUP:        SetPosition(APos - AClient);
    pgSB_PAGEDOWN:      SetPosition(APos + AClient);
    pgSB_THUMBPOSITION: SetPosition(Pos / FScrollScale);
    pgSB_THUMBTRACK:
      if FTracking then
        SetPosition(Pos / FScrollScale);
    pgSB_TOP:           SetPosition(0);
    pgSB_BOTTOM:        SetPosition(ASize - AClient);
    pgSB_ENDSCROLL:     ;
    end;//case
  end;
end;

procedure TpgVirtualScrollBox.RemoveScrollbars;
var
  ScrollInfo: TpgScrollInfo;
begin
  if not HandleAllocated then
    exit;

  // Horizontal scrollbar
  FillChar(ScrollInfo, SizeOf(ScrollInfo), 0);
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  ScrollInfo.fMask := pgSIF_ALL;
  pgSetScrollInfo(Handle, pgSB_HORZ, ScrollInfo, True);

  // Vertical scrollbar
  pgSetScrollInfo(Handle, pgSB_VERT, ScrollInfo, True);
end;

procedure TpgVirtualScrollBox.ScrollBy(var DeltaX, DeltaY: integer);
// Call this procedure to scroll the window and update the scrollbars, all in
// one command
var
  NewX, NewY: integer;
  ThumbPosX, ThumbPosY: integer;
begin
  // Calculate new position in X and Y
  NewX := CalculateThumbPosition(DeltaX - FVirtualLeft, FVirtualWidth, ClientWidth);
  DeltaX := NewX + FVirtualLeft;
  NewY := CalculateThumbPosition(DeltaY - FVirtualTop, FVirtualHeight, ClientHeight);
  DeltaY := NewY + FVirtualTop;
  if (DeltaX = 0) and (DeltaY = 0) then
    exit; // no changes

  FVirtualLeft := -NewX;
  FVirtualTop  := -NewY;
  DoVirtualWindowChanged;

  // Scroll the window
  pgScrollWindow(Handle, -DeltaX, -DeltaY, nil, nil);

  // Set scrollbar positions
  ThumbPosX := round(NewX * FScrollScale);
  ThumbPosY := round(NewY * FScrollScale);
  if pgGetScrollPos(Handle, pgSB_HORZ) <> ThumbPosX then
    pgSetScrollPos(Handle, pgSB_HORZ, ThumbPosX, True);
  if pgGetScrollPos(Handle, pgSB_VERT) <> ThumbPosY then
    pgSetScrollPos(Handle, pgSB_VERT, ThumbPosY, True);
end;

procedure TpgVirtualScrollBox.SetAutoScroll(const Value: Boolean);
begin
  if FAutoScroll <> Value then
  begin
    FAutoScroll := Value;
    if Value then
      UpdateScrollBars
    else
    begin
      RemoveScrollbars;
      FVirtualLeft := 0;
      FVirtualTop  := 0;
    end;
    DoVirtualWindowChanged;
  end;
end;

procedure TpgVirtualScrollBox.SetBorderStyle(const Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TpgVirtualScrollBox.SetBoxPlacement(const Value: TpgBoxPlacement);
begin
  if FBoxPlacement <> Value then
  begin
    FBoxPlacement := Value;
    UpdateScrollBars;
    DoVirtualWindowChanged;
  end;
end;

procedure TpgVirtualScrollBox.SetVirtualBounds(ALeft, ATop, AWidth, AHeight: integer);
begin
  if (FVirtualLeft <> ALeft) or (FVirtualTop <> ATop) or
     (FVirtualWidth <> AWidth) or (FVirtualHeight <> AHeight) then
  begin
    FVirtualLeft := ALeft;
    FVirtualTop := ATop;
    FVirtualWidth := AWidth;
    FVirtualHeight := AHeight;

    // In UpdateScrollbars, the validity of the newly set FVirtualLeft and
    // FVirtualTop is checked, hence they might change
    UpdateScrollbars;
    DoVirtualWindowChanged;
  end;
end;

function TpgVirtualScrollBox.UpdateScrollbars: boolean;
var
  ScrollInfo: TpgScrollInfo;
  Mx: integer;
  VL, VT: integer;
begin
  Result := False;
  if not HandleAllocated then
    exit;

  // Adjust scale
  Mx := pgMax(FVirtualWidth, FVirtualHeight);
  if Mx > 30000 then
    FScrollScale := 30000 / Mx
  else
    FScrollScale := 1.0;

  // Check limits on Pos
  VL := -CalculateThumbPosition(-FVirtualLeft, FVirtualWidth, ClientWidth);
  VT := -CalculateThumbPosition(-FVirtualTop, FVirtualHeight, ClientHeight);
  if (VL <> FVirtualLeft) or (VT <> FVirtualTop) then
  begin
    FVirtualLeft := VL;
    FVirtualTop  := VT;
    Result := True;

    // We need an extra invalidate here, the standard WinControl seems to
    // forget this case
    Invalidate;
  end;
  if not AutoScroll then
    exit;

  // Horizontal scrollbar
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  ScrollInfo.fMask := pgSIF_ALL;
  ScrollInfo.nMin := 0;
  ScrollInfo.nMax := round(FVirtualWidth * FScrollScale);
  ScrollInfo.nPage := round(ClientWidth * FScrollScale);
  ScrollInfo.nPos := round(-FVirtualLeft * FScrollScale);
  ScrollInfo.nTrackPos := ScrollInfo.nPos;
  pgSetScrollInfo(Handle, pgSB_HORZ, ScrollInfo, True);

  // Vertical scrollbar
  ScrollInfo.nMin := 0;
  ScrollInfo.nMax := round(FVirtualHeight * FScrollScale);
  ScrollInfo.nPage := round(ClientHeight * FScrollScale);
  ScrollInfo.nPos := round(-FVirtualTop * FScrollScale);
  ScrollInfo.nTrackPos := ScrollInfo.nPos;
  pgSetScrollInfo(Handle, pgSB_VERT, ScrollInfo, True);
end;

procedure TpgVirtualScrollBox.WMEraseBkgnd(var Message: TWMEraseBkgnd);
// This message handler is called when windows is about to work on the background
// of the window, and this procedure signals not to "erase" (or fill) it, to
// avoid flicker
begin
  // No automatic erase of background
  Message.Result := integer(False);
end;

procedure TpgVirtualScrollBox.WMHScroll(var Message: TWMHScroll);
var
  L: integer;
begin
  L := -FVirtualLeft;
  ProcessScrollMessage(Message, pgSB_HORZ, L, FVirtualWidth, ClientWidth);
  FVirtualLeft := -L;
  DoVirtualWindowChanged;
end;

procedure TpgVirtualScrollBox.WMSize(var Message: TWMSize);
// React to a resize
begin
  // use the info to update the scrollbars
  if UpdateScrollbars then
    DoVirtualWindowChanged;

  // and call inherited method
  inherited;
end;

procedure TpgVirtualScrollBox.WMVScroll(var Message: TWMVScroll);
var
  T: integer;
begin
  T := -FVirtualTop;
  ProcessScrollMessage(Message, pgSB_VERT, T, FVirtualHeight, ClientHeight);
  FVirtualTop := -T;
  DoVirtualWindowChanged;
end;

end.
