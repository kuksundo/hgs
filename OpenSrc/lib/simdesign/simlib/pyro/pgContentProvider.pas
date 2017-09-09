{ Project: Pyro
  Module: Pyro View/Edit

  Description:
    TpgContentProvider is an abstract ancestor for viewer and editor classes.
    It translates the WMxxx mouse messages to more sensible Mouse events.

    Some notes on mouse events:

    When user singleclicks with left button, Windows sends:

    * WMLButtonDown
    * WMLButtonUp
    * WMMouseMove

    This is translated into DoLMouseClick, DoMouseMove

    When user double-clicks with left button, Windows sends:

    * WMLButtonDown
    * WMLButtonUp
    * WMMouseMove
    * WMLButtonDblClick
    * WMLButtonUp
    * WMMouseMove

    This is translated into DoLMouseClick, DoMouseMove, DoLMouseDblClick, DoMouseMove

    When user does drag with left button, Windows sends:

    * WMLButtonDown
    * WMMouseMove (n times)
    * WMLButtonUp

    This is translated into DoMouseStartDrag, DoMouseDrag (n times), DoMouseCloseDrag

    Using this method, the descendants do not have to worry if they deal with
    clicks or drags, this is already determined.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgContentProvider;

interface

uses
  SysUtils, Contnrs, Classes, Controls, Messages,
  pgCanvas, pgTransform, pgPyroControl, pgPlatform, Pyro;

type

  TpgInvalidateRectEvent = procedure (Rect: TpgRect) of object;

  // Generic content provider, which is the base for scene viewers and editors,
  // and document viewers and editors. It can be tied to visual controls like
  // paintboxes and scrollboxes. ContentProvider also translates low-level mouse
  // messages into more usable highlevel methods.
  TpgContentProvider = class(TComponent)
  private
    FAssociate: TpgPyroControl;
    FOnScrollBy: TpgScrollByEvent;
    FOnSetVirtualBounds: TpgSetVirtualBoundsEvent;
    FOnZoom: TpgZoomEvent;
    FContentHeight: double;
    FContentWidth: double;
    FTransform: TpgAffineTransform;
    FOnInvalidateRect: TpgInvalidateRectEvent;
    FDeviceInfo: TpgDeviceInfo;
    FLMouseDn, FMMouseDn, FRMouseDn,
    FLMouseDbl: boolean;
    FIsDragging: boolean;
    FTransformStack: TObjectList;
    procedure ClearMouseData;
    function GetDeviceInfo: PpgDeviceInfo;
  protected
    // utility proc to get the mouse parameters
    procedure GetMouseState(Message: TWMMouse; var Info: TpgMouseInfo);
    procedure DoLMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean); virtual;
    procedure DoRMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean); virtual;
    procedure DoLMouseDblClick(const Mouse: TpgMouseInfo; var Handled: boolean); virtual;
    procedure DoMMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean); virtual;
    procedure DoMouseStartDrag(const Mouse: TpgMouseInfo; var Handled: boolean); virtual;
    procedure DoMouseDrag(const Mouse: TpgMouseInfo; var Handled: boolean); virtual;
    procedure DoMouseCloseDrag(const Mouse: TpgMouseInfo; var Handled: boolean); virtual;
    procedure DoMouseMove(const Mouse: TpgMouseInfo; var Handled: boolean); virtual;
    // Cancel current drag operation if the the drag should actually be a click.
    // Subsequent mouse moves will cause DoMouseMove instead of DoMouseDrag
    procedure CancelDrag;
    // True if currently dragging
    property IsDragging: boolean read FIsDragging;
    // invalidates the associate for just the given rectangle (ARect is in content
    // units).
    procedure InvalidateContentRect(const ARect: TpgBox);
    // used by the descendants to scroll the associate
    procedure DoScrollBy(var DeltaX, DeltaY: integer);
    // used by the descendants to make associate zoom to type
    procedure DoZoom(ZoomType: TpgZoomType);
    // Push/pop the current transform (for zoom undo stack)
    procedure PushTransform;
    procedure PopTransform;
    // Update the associate's bounds according to our transform
    procedure UpdateAssociateBounds;
    // used by descendants to set the current content size
    procedure SetContentSize(const AWidth, AHeight: double);

    // The TpgPyroControl that we're associated with
    property Associate: TpgPyroControl read FAssociate;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Called by the associate to set itself
    procedure SetAssociate(const Value: TpgPyroControl);
    // Content Width in pixels when 100%
    property ContentWidth: double read FContentWidth write FContentWidth;
    // Content Height in pixels when 100%
    property ContentHeight: double read FContentHeight write FContentHeight;
    // Is called by the associate for key or mouse messages
    procedure WMLButtonDown(var Message: TWMLButtonDown); virtual;
    procedure WMLButtonUp(var Message: TWMLButtonUp); virtual;
    procedure WMMouseMove(var Message: TWMMouseMove); virtual;
    procedure WMLButtonDblClick(var Message: TWMLButtonDblClk); virtual;
    procedure WMMButtonDown(var Message: TWMRButtonDown); virtual;
    procedure WMMButtonUp(var Message: TWMRButtonUp); virtual;
    procedure WMRButtonDown(var Message: TWMRButtonDown); virtual;
    procedure WMRButtonUp(var Message: TWMRButtonUp); virtual;
    // Is called by associate to indicate scale change
    procedure ScaleChange(const AScale: double);
    // Mouse and key events to be overridden in descendants
    procedure DoKeyDown(var Key: Word; Shift: TShiftState; var Handled: boolean); virtual;
    // Paint is called by the associate to paint the content onto ACanvas.
    // Only the part inside ACanvas.DeviceRect needs to be painted. This
    // abstract method must be implemented by content providers
    procedure Paint(ACanvas: TpgCanvas); virtual; abstract;
    // Transform client (mouse) coordinates to content coordinates
    function ToContent(X, Y: integer): TpgPoint;
    // Transform content coordinates to client coordinates
    function ToClient(X, Y: double): TpgPoint;
    // used by the descendants or application to invalidate the associate
    procedure Invalidate;
    // same as invalidate, but can be called from notify event
    procedure DoInvalidate(Sender: TObject);
    // Is called by the associate to indicate its virtual bounds have changed
    procedure VirtualBoundsChange(Left, Top, Width, Height: integer);
    // Resolution in dots per inch of the device
    property DeviceInfo: PpgDeviceInfo read GetDeviceInfo;
    // Transform from the content to device, includes zoom factor and scrolling
    property Transform: TpgAffineTransform read FTransform;
    // Events that the associate can/must connect to in order to get content
    property OnScrollBy: TpgScrollByEvent read FOnScrollBy write FOnScrollBy;
    property OnSetVirtualBounds: TpgSetVirtualBoundsEvent read FOnSetVirtualBounds
      write FOnSetVirtualBounds;
    property OnZoom: TpgZoomEvent read FOnZoom write FOnZoom;
    property OnInvalidateRect: TpgInvalidateRectEvent read FOnInvalidateRect
      write FOnInvalidateRect;
  end;

implementation

{ TpgContentProvider }

procedure TpgContentProvider.CancelDrag;
begin
  FIsDragging := False;
end;

procedure TpgContentProvider.ClearMouseData;
begin
  FLMouseDn := False;
  FMMouseDn := False;
  FRMouseDn := False;
  FLMouseDbl := False;
end;

constructor TpgContentProvider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTransform := TpgAffineTransform.Create;
  FTransformStack := TObjectList.Create;
  // Some defaults
  FContentHeight := 40;
  FContentWidth := 30;
  // Device DPI: this seems to be the default that the Acrobat viewer uses
  FDeviceInfo.DPI.X := 96;
  FDeviceInfo.DPI.Y := 96;
end;

destructor TpgContentProvider.Destroy;
begin
  FreeAndNil(FTransform);
  FreeAndNil(FTransformStack);
  inherited;
end;

procedure TpgContentProvider.DoInvalidate(Sender: TObject);
begin
  Invalidate;
end;

procedure TpgContentProvider.DoKeyDown(var Key: Word; Shift: TShiftState; var Handled: boolean);
begin
// default does nothing
end;

procedure TpgContentProvider.DoLMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
// default does nothing
end;

procedure TpgContentProvider.DoLMouseDblClick(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
// default does nothing
end;

procedure TpgContentProvider.DoMMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
// default does nothing
end;

procedure TpgContentProvider.DoMouseCloseDrag(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
// default does nothing
end;

procedure TpgContentProvider.DoMouseDrag(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
// default does nothing
end;

procedure TpgContentProvider.DoMouseMove(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
// default does nothing
end;

procedure TpgContentProvider.DoMouseStartDrag(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
// default does nothing
end;

procedure TpgContentProvider.DoRMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
// default does nothing
end;

procedure TpgContentProvider.DoScrollBy(var DeltaX, DeltaY: integer);
begin
  if assigned(FOnScrollBy) then
    FOnScrollBy(DeltaX, DeltaY);
end;

procedure TpgContentProvider.DoZoom(ZoomType: TpgZoomType);
begin
  PushTransform;
  if assigned(FOnZoom) then
    FOnZoom(ZoomType);
end;

function TpgContentProvider.GetDeviceInfo: PpgDeviceInfo;
begin
  Result := @FDeviceInfo;
end;

procedure TpgContentProvider.GetMouseState(Message: TWMMouse; var Info: TpgMouseInfo);
begin
  Info.Shift  := (Message.Keys AND pgMK_SHIFT   <> 0);
  Info.Ctrl   := (Message.Keys AND pgMK_CONTROL <> 0);
  Info.Left   := (Message.Keys AND pgMK_LBUTTON <> 0);
  Info.Middle := (Message.Keys AND pgMK_MBUTTON <> 0);
  Info.Right  := (Message.Keys AND pgMK_RBUTTON <> 0);
  Info.X := Message.XPos;
  Info.Y := Message.YPos;
  // Alt key
  Info.Alt := (pgGetKeyState(pgVK_MENU) and $8000) > 0;
end;

procedure TpgContentProvider.Invalidate;
begin
  if assigned(FOnInvalidateRect) then
    FOnInvalidateRect(TpgRect(FAssociate.ClientRect));
end;

procedure TpgContentProvider.InvalidateContentRect(const ARect: TpgBox);
var
  LT, RB: TpgPoint;
  X1, X2, Y1, Y2: double;
begin
  LT := ToClient(ARect.Lft, ARect.Top);
  RB := ToClient(ARect.Rgt, ARect.Btm);
  X1 := LT.X; Y1 := LT.Y; X2 := RB.X; Y2 := RB.Y;
  if assigned(FOnInvalidateRect) then
    FOnInvalidateRect(pgRect(
      pgFloor(pgMin(X1, X2)), pgFloor(pgMin(Y1, Y2)),
      pgCeil (pgMax(X1, X2)), pgCeil (pgMax(Y1, Y2))));
end;

procedure TpgContentProvider.PopTransform;
var
  T: TpgAffineTransform;
begin
  if FTransformStack.Count = 0 then exit;
  T := TpgAffineTransform(FTransformStack[0]);
  Transform.Assign(T);
  FTransformStack.Delete(0);
end;

procedure TpgContentProvider.PushTransform;
var
  T: TpgAffineTransform;
begin
  T := TpgAffineTransform.Create;
  T.Assign(Transform);
  FTransformStack.Insert(0, T);
  while FTransformStack.Count > 20 do FTransformStack.Delete(20);
end;

procedure TpgContentProvider.ScaleChange(const AScale: double);
var
  L, T: double;
begin
  // Our associate changed scale, we update our scale
  L := FTransform.Matrix.E;
  T := FTransform.Matrix.F;
  FTransform.Identity;
  FTransform.Translate(L, T);
  FTransform.Scale(AScale, AScale);
end;

procedure TpgContentProvider.SetAssociate(const Value: TpgPyroControl);
begin
  FAssociate := Value;
  if assigned(FAssociate) then
    UpdateAssociateBounds;
end;

procedure TpgContentProvider.SetContentSize(const AWidth, AHeight: double);
begin
  FContentWidth := AWidth;
  FContentHeight := AHeight;
  UpdateAssociateBounds;
end;

function TpgContentProvider.ToClient(X, Y: double): TpgPoint;
begin
  Result := Transform.Transform(pgPoint(X, Y));
end;

function TpgContentProvider.ToContent(X, Y: integer): TpgPoint;
begin
  Transform.InverseTransform(pgPoint(X, Y), Result);
end;

procedure TpgContentProvider.UpdateAssociateBounds;
var
  P: TpgPoint;
  L, T, W, H: integer;
begin
  // Determine L,T,W,H virtual bounds based on our transform
  P := Transform.Transform(pgPoint(0, 0));
  L := pgFloor(P.X);
  T := pgFloor(P.Y);
  P := Transform.Transform(pgPoint(ContentWidth, ContentHeight));
  W := pgCeil(P.X - L);
  H := pgCeil(P.Y - T);
  // Send these bounds to the associate
  if assigned(FOnSetVirtualBounds) then
    FOnSetVirtualBounds(L, T, W, H);
end;

procedure TpgContentProvider.VirtualBoundsChange(Left, Top, Width,
  Height: integer);
var
  S: double;
begin
  // Our associate changed bounds.. we only change our left,top and leave scale unchanged
  S := FTransform.Matrix.A;
  FTransform.Identity;
  FTransform.Translate(Left, Top);
  FTransform.Scale(S, S);
  Invalidate;
end;

procedure TpgContentProvider.WMLButtonDblClick(var Message: TWMLButtonDblClk);
begin
  FLMouseDbl := True;
end;

procedure TpgContentProvider.WMLButtonDown(var Message: TWMLButtonDown);
begin
  FLMouseDn := True;
end;

procedure TpgContentProvider.WMLButtonUp(var Message: TWMLButtonUp);
var
  Mouse: TpgMouseInfo;
  Handled: boolean;
begin
  GetMouseState(Message, Mouse);
  Handled := False;
  if FLMouseDn then begin
    ClearMouseData;
    Mouse.Left := True;
    DoLMouseClick(Mouse, Handled);
    exit;
  end;
  if FLMouseDbl then begin
    ClearMouseData;
    DoLMouseDblClick(Mouse, Handled);
    exit;
  end;
  if FIsDragging then begin
    DoMouseCloseDrag(Mouse, Handled);
    FIsDragging := False;
  end;
end;

procedure TpgContentProvider.WMMButtonDown(var Message: TWMRButtonDown);
begin
  FMMouseDn := true;
end;

procedure TpgContentProvider.WMMButtonUp(var Message: TWMRButtonUp);
var
  Mouse: TpgMouseInfo;
  Handled: boolean;
begin
  GetMouseState(Message, Mouse);
  Handled := False;
  if FMMouseDn then begin
    ClearMouseData;
    Mouse.Middle := True;
    DoMMouseClick(Mouse, Handled);
    exit;
  end;
  if FIsDragging then begin
    DoMouseCloseDrag(Mouse, Handled);
    FIsDragging := False;
  end;
end;

procedure TpgContentProvider.WMMouseMove(var Message: TWMMouseMove);
var
  Mouse: TpgMouseInfo;
  Handled: boolean;
begin
  GetMouseState(Message, Mouse);
  Handled := False;
  if FLMouseDn or FMMouseDn or FRMouseDn then begin
    ClearMouseData;
    FIsDragging := True;
    DoMouseStartDrag(Mouse, Handled);
    exit;
  end;
  if FIsDragging then
    DoMouseDrag(Mouse, Handled)
  else
    DoMouseMove(Mouse, Handled);
end;

procedure TpgContentProvider.WMRButtonDown(var Message: TWMRButtonDown);
begin
  FRMouseDn := True;
end;

procedure TpgContentProvider.WMRButtonUp(var Message: TWMRButtonUp);
var
  Mouse: TpgMouseInfo;
  Handled: boolean;
begin
  GetMouseState(Message, Mouse);
  Handled := False;
  if FRMouseDn then begin
    ClearMouseData;
    Mouse.Right := True;
    DoRMouseClick(Mouse, Handled);
    exit;
  end;
  if FIsDragging then begin
    DoMouseCloseDrag(Mouse, Handled);
    FIsDragging := False;
  end;
end;

end.
