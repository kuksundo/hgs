{ Project: Pyro
  Module: Pyro Edit

  Description:
    Base class for viewers. Viewers are connected to content (e.g. a scene), and
    to an associate control, and draw the content on the control. Viewers also
    provide for scrolling etc.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgViewer;

interface

uses
  Forms, Graphics, SysUtils, Controls, Messages, Classes, pgPlatform, pgTransform,
  pgRenderUsingCore, pgContentProvider, pgSurface, pgBackgroundFill,
  pgCanvas, pgCanvasUsingGDI, pgWinGDI, Math, pgColor, Pyro;

{$R cursors.res}

const

  cDragLineWidth = 0.5;
  cDragLineColor = clTrBlue32;

type

  TpgRenderEvent = procedure (Sender: TObject; ACanvas: TpgCanvas; ATransform: TpgTransform) of object;

  // Viewer base class: renders background to the canvas or device of the
  // associate
  TpgViewer = class(TpgContentProvider)
  private
    FBackground: TpgBackgroundFill;
    FRenderer: TpgCoreRenderer;
    FToolMode: TpgToolMode;
    FToolCursor: TCursor;
    FZoomMode: TpgZoomMode;
    FZoomFactor: double;
    FOnUserClick: TpgMouseEvent;
    FOnMessage: TpgMessageEvent;
    FOnModeChange: TNotifyEvent;
    FDragInfo: TpgDragInfo;
    FOnUserStartDrag: TpgMouseEvent;
    FOnUserDrag: TpgMouseEvent;
    FOnUserCloseDrag: TpgMouseEvent;
    FOnRender: TpgRenderEvent;
    procedure SetToolMode(const Value: TpgToolMode);
    procedure SetZoomMode(const Value: TpgZoomMode);
    procedure DoModeChange;
    function GetDragInfo: PpgDragInfo;
    // Render background, content and overlays.
    procedure Render(ACanvas: TpgCanvas);
  protected
    class function GetRendererClass: TpgRendererClass; virtual;
    procedure SetRenderer(const Value: TpgCoreRenderer); virtual;
    procedure SetToolCursor(const Value: TCursor);
    procedure SetWindowsCursor(ACursor: TCursor);
    // React to mouse events
    procedure DoLMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoLMouseDblClick(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoMMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoRMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoMouseStartDrag(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoMouseDrag(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoMouseMove(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoMouseCloseDrag(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    // Utility procs
    procedure UpdateWindowsCursor; virtual;
    procedure UpdateToolCursor; virtual;
    procedure UpdateHoverCursor; virtual;
    function IsDragging: boolean; virtual;
    procedure ResetDrag; virtual;
    procedure SetDragClose(AClose: TpgPoint);
    function DragBox: TpgBox;
    // Method to render the content to a given canvas, must be implemented
    // in all descendants. By default, the OnRender event will be fired to
    // render the content.
    procedure RenderContent(ACanvas: TpgCanvas); virtual;
    // Render the overlays on this window (zooming/selection rectangles)
    procedure RenderOverlays(ACanvas: TpgCanvas); virtual;
    property DragInfo: PpgDragInfo read GetDragInfo;
  public
    procedure DoMessage(const AMessage: string); virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // React to associate's calls
    procedure DoKeyDown(var Key: Word; Shift: TShiftState; var Handled: boolean); override;
    procedure Paint(ACanvas: TpgCanvas); override;
    // Zooming
    procedure Zoom100;
    procedure ZoomWidth;
    procedure ZoomHeight;
    procedure ZoomExtent;
    // Return to previous zoom
    procedure ZoomPrevious;
    // Zoom the client to occupy just AWindow, where AWindow is in content coordinates
    procedure ZoomToWindow(AWindow: TpgBox);
    // Zoom relative to X, Y (in associate's space), with factor Factor
    procedure ZoomRelative(const Factor, X, Y: double);
    property Associate;
    // Set the renderer for this viewer. The renderer is owned by the viewer,
    // so do not free it in application code!
    property Renderer: TpgCoreRenderer read FRenderer write SetRenderer;
  published
    property Background: TpgBackgroundFill read FBackground;
    property ToolMode: TpgToolMode read FToolMode write SetToolMode;
    property ToolCursor: TCursor read FToolCursor write SetToolCursor;
    property ZoomMode: TpgZoomMode read FZoomMode write SetZoomMode;
    // Zoom factor for zmZoomIn and zmZoomOut
    property ZoomFactor: double read FZoomFactor write FZoomFactor;

    // Events

    // OnUserClick is fired when ToolMode = tmUser and the user clicked on
    // the mouse.
    property OnUserClick: TpgMouseEvent read FOnUserClick write FOnUserClick;
    property OnUserStartDrag: TpgMouseEvent read FOnUserStartDrag write FOnUserStartDrag;
    property OnUserCloseDrag: TpgMouseEvent read FOnUserCloseDrag write FOnUserCloseDrag;
    property OnUserDrag: TpgMouseEvent read FOnUserDrag write FOnUserDrag;
    // OnMessage can be connected to receive text messages from the viewer. Examples
    // are messages related to add commands in the Scene Editor.
    property OnMessage: TpgMessageEvent read FOnMessage write FOnMessage;
    // OnModeChange is fired whenever any of the modes (toolmode, zoommode) changed,
    // so the application can update.
    property OnModeChange: TNotifyEvent read FOnModeChange write FOnModeChange;
    // Event that can be used to implement content rendering
    property OnRender: TpgRenderEvent read FOnRender write FOnRender;
  end;

const

  // Cursors
  crZoom             = -30;
  crZoomMinus        = -31;
  crZoomPlus         = -32;
  crHand             = -33;
  crHandDown         = -34;
  crTextInsert       = -35;
  crImageInsert      = -36;
  crRectInsert       = -37;
  crCircleInsert     = -38;
  crSizeCopy         = -39;
  crRotate           = -40;

implementation

{ TpgViewer }

constructor TpgViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRenderer := GetRendererClass.Create;
  FBackground := TpgBackgroundFill.Create;
  FBackground.OnChanged := DoInvalidate;
  FZoomFactor := 1.5;
  FToolCursor := crDefault;
end;

destructor TpgViewer.Destroy;
begin
  FreeAndNil(FBackground);
  FreeAndNil(FRenderer);
  inherited;
end;

procedure TpgViewer.DoKeyDown(var Key: word; Shift: TShiftState; var Handled: boolean);
var
  DeltaX, DeltaY: integer;
const
  Increment = 10;
begin
  DeltaX := 0;
  DeltaY := 0;
  Handled := True;
  case Key of
  pgVK_LEFT:  DeltaX := -Increment;
  pgVK_RIGHT: DeltaX :=  Increment;
  pgVK_UP:    DeltaY := -Increment;
  pgVK_DOWN:  DeltaY :=  Increment;
  else
    Handled := False;
  end;//case
  if (DeltaX <> 0) or (DeltaY <> 0) then
    DoScrollBy(DeltaX, DeltaY);
end;

procedure TpgViewer.DoLMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
  if ToolMode = tmUser then
  begin
    if assigned(FOnUserClick) then
    begin
      FOnUserClick(Self, Mouse);
      Handled := True;
    end;
  end;
end;

procedure TpgViewer.DoLMouseDblClick(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
//
end;

procedure TpgViewer.DoMessage(const AMessage: string);
begin
  if assigned(FOnMessage) then
    FOnMessage(Self, AMessage);
end;

procedure TpgViewer.DoMMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
//
end;

procedure TpgViewer.DoModeChange;
begin
  if assigned(FOnModeChange) then
    FOnModeChange(Self);
end;

procedure TpgViewer.DoMouseCloseDrag(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
  if FToolMode = tmUser then
    if assigned(FOnUserCloseDrag) then
    begin
      FOnUserCloseDrag(Self, Mouse);
      Handled := True;
      exit;
    end;

  if FDragInfo.DragOp = doZoomWindow then
  begin
    // Zoom to the window
    ZoomToWindow(DragBox);
    // Terminate drag
    ResetDrag;
    // we reset zoom mode
    ZoomMode := zmNone;
    Handled := True;
  end;
end;

procedure TpgViewer.DoMouseDrag(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
  if FToolMode = tmUser then
    if assigned(FOnUserDrag) then
    begin
      FOnUserDrag(Self, Mouse);
      Handled := True;
      exit;
    end;

  // Update drag rectangle
  SetDragClose(ToContent(Mouse.X, Mouse.Y));
  InvalidateContentRect(pgGrowBox(DragBox, cDragLineWidth * Transform.PixelScale));
  FDragInfo.DragClose := ToContent(Mouse.X, Mouse.Y);
  InvalidateContentRect(pgGrowBox(DragBox, cDragLineWidth * Transform.PixelScale));
  if ZoomMode = zmZoomWindow then
    Handled := True;
end;

procedure TpgViewer.DoMouseMove(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
  inherited;
  if (ToolMode <> tmNone) or (ZoomMode <> zmNone) then
    Handled := True;
end;

procedure TpgViewer.DoMouseStartDrag(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
  if FToolMode = tmUser then
    if assigned(FOnUserStartDrag) then
    begin
      FOnUserStartDrag(Self, Mouse);
      Handled := True;
      exit;
    end;

  // Start a drag operation
  FDragInfo.DragStart := ToContent(Mouse.X, Mouse.Y);
  FDragInfo.DragClose := FDragInfo.DragStart;
  if not Mouse.Left then
    exit;

  // Check for zoom window
  if ZoomMode = zmZoomWindow then
  begin
    FDragInfo.DragOp := doZoomWindow;
    Handled := True;
  end;
end;

procedure TpgViewer.DoRMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
  if ToolMode = tmUser then
  begin
    if assigned(FOnUserClick) then
    begin
      FOnUserClick(Self, Mouse);
      Handled := True;
    end;
  end;
end;

function TpgViewer.DragBox: TpgBox;
begin
  Result := pgBox(
    FDragInfo.DragStart.X, FDragInfo.DragStart.Y,
    FDragInfo.DragClose.X, FDragInfo.DragClose.Y);
end;

function TpgViewer.GetDragInfo: PpgDragInfo;
begin
  Result := @FDragInfo;
end;

class function TpgViewer.GetRendererClass: TpgRendererClass;
begin
  Result := TpgCoreRenderer;
end;

function TpgViewer.IsDragging: boolean;
begin
  Result := FDragInfo.DragOp <> doNone;
end;

procedure TpgViewer.Paint(ACanvas: TpgCanvas);
begin
  ACanvas.DeviceInfo^ := DeviceInfo^;
  Render(ACanvas);
end;

procedure TpgViewer.Render(ACanvas: TpgCanvas);
begin
  // Background
  Background.Render(ACanvas, Transform);
  // Render content
  RenderContent(ACanvas);
  // Render overlays
  RenderOverlays(ACanvas);
end;

procedure TpgViewer.RenderContent(ACanvas: TpgCanvas);
begin
  // Render content
  if assigned(FOnRender) then
    FOnRender(Self, ACanvas, Transform);
end;

procedure TpgViewer.RenderOverlays(ACanvas: TpgCanvas);
var
  S: TpgState;
  Stroke: TpgStroke;
  R: TpgBox;
begin
  case FDragInfo.DragOp of
  doZoomWindow, doInsert:
    begin
      S := ACanvas.Push;
      try
        ACanvas.AddTransform(Transform, True);
        Stroke := ACanvas.NewStroke;
        Stroke.Color := cDragLineColor;
        Stroke.Width := cDragLineWidth / Transform.PixelScale;
        R := DragBox;
        ACanvas.PaintRectangle(R.Lft, R.Top, R.Rgt - R.Lft, R.Btm - R.Top, 0, 0, nil, Stroke);
      finally
        ACanvas.Pop(S);
      end;
    end;
  end;
end;

procedure TpgViewer.ResetDrag;
begin
  FDragInfo.DragOp := doNone;
  InvalidateContentRect(pgGrowBox(DragBox, cDragLineWidth * Transform.PixelScale));
end;

procedure TpgViewer.SetDragClose(AClose: TpgPoint);
begin
  InvalidateContentRect(pgGrowBox(DragBox, cDragLineWidth * Transform.PixelScale));
  FDragInfo.DragClose := AClose;
  InvalidateContentRect(pgGrowBox(DragBox, cDragLineWidth * Transform.PixelScale));
end;

procedure TpgViewer.SetRenderer(const Value: TpgCoreRenderer);
begin
  if (FRenderer <> Value) and assigned(Value) then
  begin
    FreeAndNil(FRenderer);
    FRenderer := Value;
    Invalidate;
  end;
end;

procedure TpgViewer.SetToolCursor(const Value: TCursor);
begin
  FToolCursor := Value;
  if FToolMode <> tmNone then
    SetWindowsCursor(FToolCursor)
  else
    SetWindowsCursor(crDefault);
end;

procedure TpgViewer.SetToolMode(const Value: TpgToolMode);
begin
  if FToolMode <> Value then
  begin
    FToolMode := Value;
    UpdateWindowsCursor;
  end;
end;

procedure TpgViewer.SetWindowsCursor(ACursor: TCursor);
begin
  Associate.Cursor := ACursor;
end;

procedure TpgViewer.SetZoomMode(const Value: TpgZoomMode);
begin
  if FZoomMode <> Value then
  begin
    if FZoomMode in [zmZoomWindow, zmZoomDrag] then
      ResetDrag;
    FZoomMode := Value;
    UpdateWindowsCursor;
    DoModechange;
  end;
end;

procedure TpgViewer.UpdateHoverCursor;
begin
  SetWindowsCursor(crDefault);
end;

procedure TpgViewer.UpdateToolCursor;
begin
  SetWindowsCursor(FToolCursor)
end;

procedure TpgViewer.UpdateWindowsCursor;
begin
  // zoom cursor
  if FZoomMode <> zmNone then
  begin
    case FZoomMode of
    zmZoomIn: SetWindowsCursor(crZoomPlus);
    zmZoomOut: SetWindowsCursor(crZoomMinus);
    zmZoomWindow: SetWindowsCursor(crZoom);
    zmZoomDrag:
      if IsDragging then
        SetWindowsCursor(crHandDown)
      else
        SetWindowsCursor(crHand);
    end;
    exit;
  end;

  // tool cursor
  if FToolMode <> tmNone then
  begin
    UpdateToolCursor;
    exit;
  end;

  // Hover cursor
  UpdateHoverCursor;
end;

procedure TpgViewer.Zoom100;
begin
  PushTransform;
  Transform.Identity;
  UpdateAssociateBounds;
  ZoomMode := zmNone;
end;

procedure TpgViewer.ZoomExtent;
begin
  DoZoom(ztZoomExtent);
  ZoomMode := zmNone;
end;

procedure TpgViewer.ZoomHeight;
begin
  DoZoom(ztZoomHeight);
end;

procedure TpgViewer.ZoomPrevious;
begin
  PopTransform;
  UpdateAssociateBounds;
end;

procedure TpgViewer.ZoomRelative(const Factor, X, Y: double);
var
  C: TpgPoint;
begin
  PushTransform;
  // Get center in our own space
  Transform.InverseTransform(pgPoint(X, Y), C);
  Transform.Translate(C.X, C.Y);
  Transform.Scale(Factor, Factor);
  Transform.Translate(-C.X, -C.Y);
  UpdateAssociateBounds;
  if not (ZoomMode in [zmZoomIn, zmZoomOut]) then
    ZoomMode := zmNone;
end;

procedure TpgViewer.ZoomToWindow(AWindow: TpgBox);
var
  W: TpgBox;
  T: TpgAffineTransform;
begin
  PushTransform;
  W := pgGrowBox(AWindow, 0);
  T := BuildViewBoxTransform(0, 0, Associate.Width, Associate.Height,
    W.Lft, W.Top, W.Rgt - W.Lft,  W.Btm - W.Top,
    paXMidYMid, msMeet);
  Transform.Assign(T);
  T.Free;
  UpdateAssociateBounds;
end;

procedure TpgViewer.ZoomWidth;
begin
  DoZoom(ztZoomWidth);
end;

initialization

  // load the cursors we need
  Screen.Cursors[crZoom]         := pgLoadCursor(HInstance, 'CRZOOM');
  Screen.Cursors[crZoomMinus]    := pgLoadCursor(HInstance, 'CRZOOMMINUS');
  Screen.Cursors[crZoomPlus]     := pgLoadCursor(HInstance, 'CRZOOMPLUS');
  Screen.Cursors[crHand]         := pgLoadCursor(HInstance, 'CRHAND');
  Screen.Cursors[crHandDown]     := pgLoadCursor(HInstance, 'CRHANDDOWN');
  Screen.Cursors[crTextInsert]   := pgLoadCursor(HInstance, 'CRTEXTINSERT');
  Screen.Cursors[crImageInsert]  := pgLoadCursor(HInstance, 'CRIMAGEINSERT');
  Screen.Cursors[crRectInsert]   := pgLoadCursor(HInstance, 'CRRECTINSERT');
  Screen.Cursors[crCircleInsert] := pgLoadCursor(HInstance, 'CRCIRCLEINSERT');
  Screen.Cursors[crSizeCopy]     := pgLoadCursor(HInstance, 'CRSIZECOPY');
  Screen.Cursors[crRotate]       := pgLoadCursor(HInstance, 'CRROTATE');

end.
