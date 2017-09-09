{ Project: Pyro

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgCustomView;

interface

uses
  Messages, Classes, Graphics,
  pgPyroControl, pgContentProvider, pgPlatform, Pyro;

type

  // Simple viewer based on TpgPyroControl, thus having a TpgCanvas, and
  // implementing a provider connection (without any mouse handling)
  TpgCustomView = class(TpgPyroControl)
  private
    FProvider: TpgContentProvider;
    procedure SetProvider(const Value: TpgContentProvider);
  protected
    procedure DoInvalidateRect(Rect: TpgRect);
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;  
  published
    property Provider: TpgContentProvider read FProvider write SetProvider;
    property Align;
    property Anchors;
    property AutoSize;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderWidth;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    //property ParentBackground; // not in D6
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
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
  end;

implementation

type
  TProviderAccess = class(TpgContentProvider);

{ TpgCustomView }

constructor TpgCustomView.Create(AOwner: TComponent);
begin
  inherited;
  FillBackground := False;
end;

destructor TpgCustomView.Destroy;
begin
  if assigned(FProvider) then
    TProviderAccess(FProvider).SetAssociate(nil);
  SetProvider(nil);
  inherited;
end;

procedure TpgCustomView.DoInvalidateRect(Rect: TpgRect);
begin
  pgInvalidateRect(Handle, @Rect, false);
end;

procedure TpgCustomView.Paint;
begin
  // If we have a provider, let it paint our clipping rect
  if assigned(FProvider) then
    TProviderAccess(FProvider).Paint(Canvas);
end;

procedure TpgCustomView.SetProvider(const Value: TpgContentProvider);
begin
  if FProvider <> Value then
  begin
    if assigned(FProvider) then
    begin
      TProviderAccess(FProvider).OnInvalidateRect := nil;
      TProviderAccess(FProvider).SetAssociate(nil);
    end;
    FProvider := Value;
    if assigned(FProvider) then
    begin
      TProviderAccess(FProvider).OnInvalidateRect := DoInvalidateRect;
      TProviderAccess(FProvider).SetAssociate(Self);
    end;
  end;
end;

end.
