{ Project: Pyro

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgScrollBoxView;

interface

uses
  Classes, Controls, SysUtils, Messages, pgVirtualScrollBox, pgTransform,
  pgContentProvider, pgPlatform, Pyro;

type

  // A scrollable viewing panel for a content provider (viewer, editor, etc)
  TpgScrollBoxView = class(TpgVirtualScrollBox)
  private
    FProvider: TpgContentProvider;
    FScaleX: double;
    FScaleY: double;
    procedure CMWantSpecialKey(var Message: TMessage); message CM_WANTSPECIALKEY;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonDblClick(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMMButtonDown(var Message: TWMRButtonDown); message WM_MBUTTONDOWN;
    procedure WMMButtonUp(var Message: TWMRButtonUp); message WM_MBUTTONUP;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure SetProvider(const Value: TpgContentProvider);
  protected
    procedure Paint; override;
    procedure DoVirtualWindowChanged; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Zoom(ZoomType: TpgZoomType);
    procedure DoInvalidateRect(Rect: TpgRect);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property VirtualRect;
    property VirtualLeft;
    property VirtualTop;
    property VirtualWidth;
    property VirtualHeight;
    property ScaleX: double read FScaleX;
    property ScaleY: double read FScaleY;
  published
    // Referenced content provider
    property Provider: TpgContentProvider read FProvider write SetProvider;
    property Align;
    property Anchors;
    property AutoScroll;
    property BorderStyle;
    property BoxPlacement;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property Enabled;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Tracking;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property OnUnDock;
    property OnVirtualWindowChanged;
  end;

implementation

{ TpgScrollBoxView }

procedure TpgScrollBoxView.CMWantSpecialKey(var Message: TMessage);
begin
  Message.Result := 1;
end;

constructor TpgScrollBoxView.Create(AOwner: TComponent);
begin
  inherited;
  FScaleX := 1.0;
  FScaleY := 1.0;
end;

destructor TpgScrollBoxView.Destroy;
begin
  if assigned(FProvider) then
    FProvider.SetAssociate(nil);
  SetProvider(nil);
  inherited;
end;

procedure TpgScrollBoxView.DoVirtualWindowChanged;
var
  CW, CH: double;
begin
  // New scales
  if assigned(FProvider) then
  begin
    // Get content size
    CW := FProvider.ContentWidth;
    CH := FProvider.ContentHeight;
    if (CW > 0) and (CH > 0) then
    begin
      FScaleX := VirtualWidth / CW;
      FScaleY := VirtualHeight / CH;
    end;
  end;
  inherited;

  // Inform provider
  if assigned(FProvider) then
    FProvider.VirtualBoundsChange(
      VirtualLeft, VirtualTop, VirtualWidth, VirtualHeight);
end;

procedure TpgScrollBoxView.DoInvalidateRect(Rect: TpgRect);
begin
  pgInvalidateRect(Handle, @Rect, false);
end;

procedure TpgScrollBoxView.KeyDown(var Key: Word; Shift: TShiftState);
var
  Handled: boolean;
begin
  inherited;
  Handled := False;
  if assigned(FProvider) then
    FProvider.DoKeyDown(Key, Shift, Handled);
end;

procedure TpgScrollBoxView.Paint;
var
  UR: TpgRect;
begin

  // Call provider drawing
  if assigned(FProvider) then
  begin
    // Check if we have to paint anything
    pgIntersectRect(UR, VirtualRect, Canvas.DeviceRect);
    if not pgIsRectEmpty(UR) then
    begin
//      Canvas.ClipRectangle(UR.Left, UR.Top, UR.Right - UR.Left, UR.Bottom - UR.Top, 0, 0);
      FProvider.Paint(Canvas);
    end;
  end;

  PaintBackground(Canvas);
end;

procedure TpgScrollBoxView.SetProvider(const Value: TpgContentProvider);
begin
  if FProvider <> Value then
  begin
    if assigned(FProvider) then
    begin
      FProvider.OnScrollBy := nil;
      FProvider.OnSetVirtualBounds := nil;
      FProvider.OnZoom := nil;
      FProvider.OnInvalidateRect := nil;
      FProvider.SetAssociate(nil);
    end;
    FProvider := Value;
    if assigned(FProvider) then
    begin
      FProvider.OnScrollBy := ScrollBy;
      FProvider.OnSetVirtualBounds := SetVirtualBounds;
      FProvider.OnZoom := Zoom;
      FProvider.OnInvalidateRect := DoInvalidateRect;
      FProvider.SetAssociate(Self);
    end;
  end;
end;

procedure TpgScrollBoxView.WMLButtonDblClick(var Message: TWMLButtonDblClk);
begin
  inherited;
  SetFocus;
  if assigned(FProvider) then
    FProvider.WMLButtonDblClick(Message);
end;

procedure TpgScrollBoxView.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  SetFocus;
  if assigned(FProvider) then
    FProvider.WMLButtonDown(Message);
end;

procedure TpgScrollBoxView.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  SetFocus;
  if assigned(FProvider) then
    FProvider.WMLButtonUp(Message);
end;

procedure TpgScrollBoxView.WMMButtonDown(var Message: TWMRButtonDown);
begin
  inherited;
  SetFocus;
  if assigned(FProvider) then
    FProvider.WMMButtonDown(Message);
end;

procedure TpgScrollBoxView.WMMButtonUp(var Message: TWMRButtonUp);
begin
  inherited;
  SetFocus;
  if assigned(FProvider) then
    FProvider.WMMButtonUp(Message);
end;

procedure TpgScrollBoxView.WMMouseMove(var Message: TWMMouseMove);
begin
  inherited;
  SetFocus;
  if assigned(FProvider) then
    FProvider.WMMouseMove(Message);
end;

procedure TpgScrollBoxView.WMRButtonDown(var Message: TWMRButtonDown);
begin
  inherited;
  SetFocus;
  if assigned(FProvider) then
    FProvider.WMRButtonDown(Message);
end;

procedure TpgScrollBoxView.WMRButtonUp(var Message: TWMRButtonUp);
begin
  inherited;
  SetFocus;
  if assigned(FProvider) then
    FProvider.WMRButtonUp(Message);
end;

procedure TpgScrollBoxView.Zoom(ZoomType: TpgZoomType);
const
  cWinMargin = 2;
  cWinScroll = 18;
var
  CW, CH, S: double;
  W, H, NewVW, NewVH: integer;
begin
  if not assigned(FProvider) then
    exit;

  // Get content size
  CW := FProvider.ContentWidth;
  CH := FProvider.ContentHeight;
  if (CW = 0) or (CH = 0) then
    exit;

  RemoveScrollbars;
  NewVW := VirtualWidth;
  NewVH := VirtualHeight;
  case ZoomType of

  ztZoomWidth:
    begin
      W := Width - cWinMargin;
      FScaleX := W / CW;
      NewVW := W;
      NewVH := pgCeil(FScaleX * CH);
      if NewVH > Height - cWinMargin then
      begin
        // Height is limiting
        W := Width - cWinScroll;
        FScaleX := W / CW;
        NewVW := W;
        NewVH := pgCeil(FScaleX * CH);
      end;
      S := FScaleX;
    end;

  ztZoomHeight:
    begin
      H := Height - cWinMargin;
      FScaleY := H / CH;
      NewVH := H;
      NewVW := pgCeil(FScaleY * CW);
      if NewVW > Width - cWinMargin then
      begin
        // Width is limiting
        H := Height - cWinScroll;
        FScaleY := H / CH;
        NewVH := H;
        NewVW := pgCeil(FScaleY * CW);
      end;
      S := FScaleY;
    end;

  ztZoomExtent:
    begin
      W := Width - cWinMargin;
      H := Height - cWinMargin;
      FScaleX := W / CW;
      FScaleY := H / CH;
      S := pgMin(FScaleX, FScaleY);
      NewVW := pgCeil(S * CW);
      NewVH := pgCeil(S * CH);
    end;

  else
    S := 1;  
  end;

  SetVirtualBounds(VirtualLeft, VirtualTop, NewVW, NewVH);
  if assigned(FProvider) then
    FProvider.ScaleChange(S);
end;

end.
