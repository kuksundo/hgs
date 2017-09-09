{ Project: Pyro

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV

  modified:
  26jun2011: pgSyncList removed
}
unit pgEditorUsingScene;

interface

uses
  // delphi
  Controls, Contnrs, Classes, SysUtils, Messages,

  // pyro
  pgViewerUsingScene, pgContentProvider,
  pgRender, pgPlatform, Pyro, pgViewer, pgScene, pgDocument,
  pgCanvas, pgTransform, pgRenderUsingCore, pgSelector, pgBitmap, pgCanvasUsingPyro,
  pgWinGDI;

type

  TpgEditorCommand = (
    ecNone,
    ecTextFirst,
    ecTextEnd,
    ecBitmapFirst,
    ecBitmapNext,
    ecBitmapEnd,
    ecRectFirst,
    ecRectNext,
    ecRectEnd,
    ecEllipseFirst,
    ecEllipseNext,
    ecEllipseEnd,
    ecPolygonFirst,
    ecPolygonNext,
    ecPolygonEnd,
    ecLineFirst,
    ecLineNext,
    ecLineEnd
  );

  TpgCommandDrawMethod = (
    dmNone,
    dmPoly
  );

  TpgCommandInfo = class(TPersistent)
  protected
    procedure AddPoint(APoint: TpgPoint);
    procedure Clear;
  public
    Points: array of TpgPoint;
    DrawMethod: TpgCommandDrawMethod;
  end;

  TpgCommandCompleteEvent = procedure (Sender: TObject; ACommand: TpgEditorCommand;
    AInfo: TpgCommandInfo) of object;

  TpgItemEvent = procedure (Sender: TObject; AElement: TpgElement) of object;

  TpgSceneEditor = class(TpgSceneViewer)
  private
    //FSyncList: TpgSyncList;
    FCommand: TpgEditorCommand;
    FCommandInfo: TpgCommandInfo;
    FOnCommandComplete: TpgCommandCompleteEvent;
    FHover: TpgElement;
    FSelectors: TpgSelectorList;
    FOnHoverItem: TpgItemEvent;
    FOnSelectItem: TpgItemEvent;
    FHoverHighlighting: boolean;
    procedure SetHover(Value: TpgElement);
    function GetEditRenderer: TpgRenderer;
    procedure SetHoverHighlighting(const Value: boolean);
  protected
    class function GetRendererClass: TpgRendererClass; override;
    procedure SetScene(const Value: TpgScene); override;
    procedure DoLMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoRMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoMouseMove(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoMouseStartDrag(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoMouseDrag(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure DoMouseCloseDrag(const Mouse: TpgMouseInfo; var Handled: boolean); override;
    procedure SetCommand(const Value: TpgEditorCommand);
    procedure DoCommandComplete(ACommand: TpgEditorCommand); virtual;
    procedure UpdateHoverCursor; override;
    procedure RenderOverlays(ACanvas: TpgCanvas); override;
    procedure HandleLeftClickCommands(const Mouse: TpgMouseInfo; var Handled: boolean); virtual;
    // Invalidate just this graphic
    procedure InvalidateGraphic(AElement: TpgElement);
    // Select the graphic
    procedure SelectGraphic(AElement: TpgElement);
    procedure SceneBeforeChange(Sender: TObject; AElement: TpgElement; APropId: longword;
      AChange: TpgChangeType); override;
    property Command: TpgEditorCommand read FCommand write SetCommand;
    // element that's hovered over
    property Hover: TpgElement read FHover write SetHover;
    property EditRenderer: TpgRenderer read GetEditRenderer;
    // Sync list owned by renderer
    //property SyncList: TpgSyncList read FSyncList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoKeyDown(var Key: Word; Shift: TShiftState; var Handled: boolean); override;
    // Dynamically add shapes
    procedure AddText;
    procedure AddBitmap;
    procedure AddRectangle;
    procedure AddEllipse;
    procedure AddPolygon;
    procedure AddLine;
    // Do we have a selection?
    function HasSelection: boolean;
    // Cancel current selection
    procedure CancelSelection;
    // Delete all elements in selection
    procedure DeleteSelection;
    // Render the whole scene to a bitmap, using ABackgroundColor as a backdrop
    // color. This can be a transparent color. ABitmap must already be initialized,
    // and will be sized using current scene's size.
    procedure RenderToBitmap(ABitmap: TpgBitmap; ABackgroundColor: TpgColor32);
    // List of selectors
    property Selectors: TpgSelectorList read FSelectors;
    // If True (default), hovering over an item highlights it. Set to False to
    // switch this feature off
    property HoverHighlighting: boolean read FHoverHighlighting write SetHoverHighlighting;
    // After any of the add commands finished, this event will be fired to indicate the
    // command is completed.
    property OnCommandComplete: TpgCommandCompleteEvent read FOnCommandComplete write
      FOnCommandComplete;
    // OnHoverItem is fired whenever the item that is hovered changes. AId is the
    // id of the shape, or 0 if no shape is hovered.
    property OnHoverItem: TpgItemEvent read FOnHoverItem write FOnHoverItem;
    // OnSelectItem is fired whenever an item gets selected. AId is the id of the
    // shape, or 0 if an item got deselected.
    property OnSelectItem: TpgItemEvent read FOnSelectItem write FOnSelectItem;
  end;

const
  cCommandMessages: array[TpgEditorCommand] of string =
    ('',
     'Add text: select insert location',
     'Text inserted',
     'Add bitmap: select top/left location',
     'Add bitmap: select bottom/right location',
     '',
     'Add rectangle: select top/left location and drag',
     'Add rectangle: select bottom/right location',
     'Rectangle inserted',
     'Add ellipse: select top/left location and drag',
     'Add ellipse: select bottom/right location',
     'Ellipse inserted',
     'Add polygon: select first point',
     'Add polygon: select next point or rightclick to close',
     'Polygon inserted',
     'Add line: select start point',
     'Add line: select end point',
     'Line inserted'
     );

  cCommandToolMode: array[TpgEditorCommand] of TpgToolMode =
    (tmNone,
     tmInsert, tmNone,
     tmInsert, tmInsert, tmNone,
     tmInsert, tmInsert, tmNone,
     tmInsert, tmInsert, tmNone,
     tmInsert, tmInsert, tmNone,
     tmInsert, tmInsert, tmNone);

  cCommandCursors: array[TpgEditorCommand] of TCursor =
    (crDefault,
     crTextInsert, crDefault,
     crImageInsert, crImageInsert, crDefault,
     crRectInsert, crRectInsert, crDefault,
     crCircleInsert, crCircleInsert, crDefault,
     crCross, crCross, crDefault,
     crCross, crCross, crDefault);

resourcestring

  sCanvasMustBeBitmap = 'Canvas must be TpgBitmapCanvas for this function';

implementation

type

  TBitmapCanvasAccess = class(TpgPyroBitmapCanvas);

{ TpgCommandInfo }

procedure TpgCommandInfo.AddPoint(APoint: TpgPoint);
begin
  SetLength(Points, length(Points) + 1);
  Points[length(Points) - 1] := APoint;
end;

procedure TpgCommandInfo.Clear;
begin
  SetLength(Points, 0);
  DrawMethod := dmNone;
end;

{ TpgSceneEditor }

procedure TpgSceneEditor.AddBitmap;
begin
  FCommandInfo.Clear;
  Command := ecBitmapFirst;
end;

procedure TpgSceneEditor.AddEllipse;
begin
  FCommandInfo.Clear;
  Command := ecEllipseFirst;
end;

procedure TpgSceneEditor.AddLine;
begin
  FCommandInfo.Clear;
  FCommandInfo.DrawMethod := dmPoly;
  Command := ecLineFirst;
end;

procedure TpgSceneEditor.AddPolygon;
begin
  FCommandInfo.Clear;
  FCommandInfo.DrawMethod := dmPoly;
  Command := ecPolygonFirst;
end;

procedure TpgSceneEditor.AddRectangle;
begin
  FCommandInfo.Clear;
  Command := ecRectFirst;
end;

procedure TpgSceneEditor.AddText;
begin
  FCommandInfo.Clear;
  Command := ecTextFirst;
end;

procedure TpgSceneEditor.CancelSelection;
begin
  if assigned(FSelectors) and (FSelectors.Count > 0) then
  begin
    FSelectors.Clear;
    // Tell the connected control that there is no selected item
    if assigned(FOnSelectItem) then
      FOnSelectItem(Self, nil);
    Invalidate;
  end;
end;

constructor TpgSceneEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHoverHighlighting := True;
  FCommandInfo := TpgCommandInfo.Create;
  FSelectors := TpgSelectorList.Create;
end;

procedure TpgSceneEditor.DeleteSelection;
var
  i: integer;
begin
  for i := FSelectors.Count - 1 downto 0 do
    FSelectors[i].Graphic.Free;
  CancelSelection;
end;

destructor TpgSceneEditor.Destroy;
begin
  FreeAndNil(FCommandInfo);
  FreeAndNil(FSelectors);
  inherited;
end;

procedure TpgSceneEditor.DoCommandComplete(ACommand: TpgEditorCommand);
begin
  if assigned(FOnCommandComplete) then
    FOnCommandComplete(Self, ACommand, FCommandInfo);
  FCommandInfo.Clear;
  ToolMode := tmNone;
end;

procedure TpgSceneEditor.DoKeyDown(var Key: Word; Shift: TShiftState;
  var Handled: boolean);
begin
  inherited;
  case Key of
  pgVK_ESCAPE: // Escape key - cancel drag operations
    begin
      CancelSelection;
      Handled := True;
    end;
  pgVK_DELETE: // Delete current selection
    begin
      DeleteSelection;
      Handled := True;
    end;
  end;
end;

procedure TpgSceneEditor.DoLMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean);
var
  i: integer;
  HitInfo: TpgHitTestInfo;
  HasHit: boolean;
begin
  inherited;
  if Handled then
    exit;

  // Deal with the insertion commands on left mouse button click
  HandleLeftClickCommands(Mouse, Handled);
  if Handled then
    exit;

  // Deal with selecting items
  if HasSelection then
  begin

    HasHit := False;
    for i := 0 to FSelectors.Count - 1 do
    begin
      HasHit := FSelectors[i].HitTest(Transform, Mouse, HitInfo);
      if HasHit then
        break;
    end;
    if not HasHit then
      CancelSelection;

  end;

  if not HasSelection then
  begin

    // Select items
    EditRenderer.HitTest(Associate.Canvas, Scene.ViewPort, Transform, Mouse, HitInfo);
    if assigned(HitInfo.Graphic) then
      SelectGraphic(HitInfo.Graphic);

  end;
  Handled := True;
end;

procedure TpgSceneEditor.DoMouseCloseDrag(const Mouse: TpgMouseInfo;
  var Handled: boolean);
var
  i: integer;
  Pt: TpgPoint;
begin
  inherited;
  if Handled then
    exit;

  if HasSelection then
  begin
    for i := 0 to FSelectors.Count - 1 do
      FSelectors[i].DoMouseCloseDrag(Associate.Canvas, Mouse);
    Handled := True;
    exit;
  end;

  if ToolMode = tmInsert then
  begin

    case FCommand of
    ecBitmapNext:
      begin
        Command := ecBitmapEnd;
        Pt := ToContent(Mouse.X, Mouse.Y);
        FCommandInfo.AddPoint(Pt);
        DoCommandComplete(Command);
      end;
    ecRectNext:
      begin
        Command := ecRectEnd;
        Pt := ToContent(Mouse.X, Mouse.Y);
        FCommandInfo.AddPoint(Pt);
        DoCommandComplete(Command);
      end;
    ecEllipseNext:
      begin
        Command := ecEllipseEnd;
        Pt := ToContent(Mouse.X, Mouse.Y);
        FCommandInfo.AddPoint(Pt);
        DoCommandComplete(Command);
      end;
    end;

    // since a user sometimes accidentally drags instead of clicks, we deal
    // with "clicks" here as well
    HandleLeftClickCommands(Mouse, Handled);

    // Terminate drag
    ResetDrag;
    Handled := True;
    exit;
  end;

end;

procedure TpgSceneEditor.DoMouseDrag(const Mouse: TpgMouseInfo; var Handled: boolean);
var
  i: integer;
begin
  inherited;
  if Handled then
    exit;

  if HasSelection then
  begin
    for i := 0 to FSelectors.Count - 1 do
      FSelectors[i].DoMouseDrag(Associate.Canvas, Mouse);
    Handled := True;
    exit;
  end;
end;

procedure TpgSceneEditor.DoMouseMove(const Mouse: TpgMouseInfo; var Handled: boolean);
var
  i: integer;
  HitInfo: TpgHitTestInfo;
  HasHit: boolean;
begin
  inherited;
  if Handled then
    exit;

  if not assigned(Scene) then
    exit;

  if HasSelection then
  begin

    // Hittest the selection, focus on other handles
    HasHit := False;
    for i := 0 to FSelectors.Count - 1 do
    begin
      HasHit := FSelectors[i].HitTest(Transform, Mouse, HitInfo);
      if HasHit then
      begin
        SetWindowsCursor(HitInfo.HitCursor);
        break;
      end;
    end;
    if not HasHit then
      SetWindowsCursor(crDefault);

  end else
  begin

    // Hovering hittest
    EditRenderer.HitTest(Associate.Canvas, Scene.ViewPort, Transform, Mouse, HitInfo);
    if assigned(HitInfo.Graphic) then
      SetHover(HitInfo.Graphic)
    else
      SetHover(nil);

  end;
end;

procedure TpgSceneEditor.DoMouseStartDrag(const Mouse: TpgMouseInfo; var Handled: boolean);
var
  i: integer;
  Pt: TpgPoint;
  HasHit: boolean;
  HitInfo: TpgHitTestInfo;
begin
  inherited;
  if Handled then
    exit;

  case Command of
  ecBitmapFirst:
    begin
      Command := ecBitmapNext;
      Pt := ToContent(Mouse.X, Mouse.Y);
      FCommandInfo.AddPoint(Pt);
      DragInfo.DragOp := doInsert;
      Handled := True;
    end;
  ecRectFirst:
    begin
      Command := ecRectNext;
      Pt := ToContent(Mouse.X, Mouse.Y);
      FCommandInfo.AddPoint(Pt);
      DragInfo.DragOp := doInsert;
      Handled := True;
    end;
  ecEllipseFirst:
    begin
      Command := ecEllipseNext;
      Pt := ToContent(Mouse.X, Mouse.Y);
      FCommandInfo.AddPoint(Pt);
      DragInfo.DragOp := doInsert;
      Handled := True;
    end;
  end;
  if Handled then
    exit;

  // Make sure that when we start a drag, we are starting from a shape
  if HasSelection then
  begin
    HasHit := False;
    for i := 0 to FSelectors.Count - 1 do
    begin
      HasHit := FSelectors[i].HitTest(Transform, Mouse, HitInfo);
      if HasHit then
        break;
    end;
    if not HasHit then
      CancelSelection;
  end;

  if not HasSelection then
  begin
    // Select items
    EditRenderer.HitTest(Associate.Canvas, Scene.ViewPort, Transform, Mouse, HitInfo);
    if assigned(HitInfo.Graphic) then
      SelectGraphic(HitInfo.Graphic);
  end;

  if HasSelection then
  begin
    for i := 0 to FSelectors.Count - 1 do
      FSelectors[i].DoMouseStartDrag(Mouse);
    Handled := True;
    exit;
  end;
end;

procedure TpgSceneEditor.DoRMouseClick(const Mouse: TpgMouseInfo; var Handled: boolean);
begin
  inherited;
  if Handled then
    exit;

  if ToolMode = tmInsert then
  begin

    case FCommand of
    ecPolygonNext:
      begin
        Command := ecPolygonend;
        DoCommandComplete(Command);
        Invalidate;
      end;
    end;
    Handled := True;
    exit;

  end;
end;

function TpgSceneEditor.GetEditRenderer: TpgRenderer;
begin
  Result := TpgRenderer(Renderer);
end;

class function TpgSceneEditor.GetRendererClass: TpgRendererClass;
begin
  Result := TpgRenderer;
end;

procedure TpgSceneEditor.HandleLeftClickCommands(const Mouse: TpgMouseInfo; var Handled: boolean);
var
  Pt: TpgPoint;
begin
  if ToolMode = tmInsert then
  begin

    case FCommand of
    ecTextFirst:
      begin
        Command := ecTextEnd;
        Pt := ToContent(Mouse.X, Mouse.Y);
        FCommandInfo.AddPoint(Pt);
        DoCommandComplete(Command);
      end;
    ecPolygonFirst:
      begin
        Command := ecPolygonNext;
        Pt := ToContent(Mouse.X, Mouse.Y);
        FCommandInfo.AddPoint(Pt);
      end;
    ecPolygonNext:
      begin
        Pt := ToContent(Mouse.X, Mouse.Y);
        FCommandInfo.AddPoint(Pt);
        Invalidate;
      end;
    ecLineFirst:
      begin
        Command := ecLineNext;
        Pt := ToContent(Mouse.X, Mouse.Y);
        FCommandInfo.AddPoint(Pt);
      end;
    ecLineNext:
      begin
        Command := ecLineEnd;
        Pt := ToContent(Mouse.X, Mouse.Y);
        FCommandInfo.AddPoint(Pt);
        DoCommandComplete(Command);
      end;
    end;

    Handled := True;
  end;
end;

function TpgSceneEditor.HasSelection: boolean;
begin
  Result := FSelectors.Count > 0;
end;

procedure TpgSceneEditor.InvalidateGraphic(AElement: TpgElement);
var
  Item: TpgBoundsItem;
  Graphic: TpgGraphic;
  TL: TpgTransformList;
  SL: TObjectList;
  R: TpgBox;
begin
  //Item := TpgBoundsItem(FSyncList.ById(AId));
  Item := nil;
  if not assigned(Item) then
    exit;
  if not Item.BoundsValid then
    Item.UpdateBounds(Associate.Canvas, EditRenderer);
  Graphic := TpgGraphic(AElement);
  SL := TObjectList.Create;
  TL := EditRenderer.GetTransformListForGraphic(
    Associate.Canvas, Graphic, nil{Transform}, SL);
  R := TransformBox(Item.LooseBB, TL);
  TL.Free;
  SL.Free;
  InvalidateContentRect(R);
end;

procedure TpgSceneEditor.RenderOverlays(ACanvas: TpgCanvas);
var
  i: integer;
  Element: TpgElement;
begin
  if HasSelection then
  begin

    // Render selectors
    for i := 0 to FSelectors.Count - 1 do
      FSelectors[i].Render(ACanvas, Transform);

  end else
  begin

    // Render Hover
    if FHoverHighlighting and assigned(Hover) then
    begin
      Element := Hover;
      if Element is TpgGraphic then
        EditRenderer.RenderHover(Associate.Canvas, TpgGraphic(Element), Transform);
    end;

  end;

  // Render command insert polygon
  if FCommandInfo.DrawMethod = dmPoly then
  begin
    if length(FCommandInfo.Points) > 0 then
      EditRenderer.RenderInsertPoly(Associate.Canvas,
        @FCommandInfo.Points[0], length(FCommandInfo.Points), Transform);
  end;

  // Render zoom rectangle in inherited
  inherited;
end;

procedure TpgSceneEditor.RenderToBitmap(ABitmap: TpgBitmap; ABackgroundColor: TpgColor32);
var
  R: TpgRect;
  Canvas: TpgPyroBitmapCanvas;
begin
  Canvas := TpgPyroBitmapCanvas.Create;
  try
    R := pgRect(0, 0, pgCeil(ContentWidth), pgCeil(ContentHeight));
    // force the size of the internal bitmap (in case it is larger than WxH)
    Canvas.DeviceRect := R;
    Canvas.FillDeviceRect(R, ABackgroundColor);
    Renderer.Render(Canvas, Scene.ViewPort, nil);
    ConvertBmpToMapWithInfo(
      TBitmapCanvasAccess(Canvas).Bitmap,
      TBitmapCanvasAccess(Canvas).SurfaceColorInfo^,
      ABitmap, ABitmap.ColorInfo);
  finally
    Canvas.Free;
  end;
end;

procedure TpgSceneEditor.SceneBeforeChange(Sender: TObject; AElement: TpgElement;
  APropId: longword; AChange: TpgChangeType);
begin
  inherited;
  // Here we react to changes in the scene. We must reflect changes in the
  // selection.
  FSelectors.SceneChange(Sender, AElement, APropId, AChange);
end;

procedure TpgSceneEditor.SelectGraphic(AElement: TpgElement);
var
  Selector: TpgSelector;
begin
  InvalidateGraphic(AElement);
  Selector := TpgSelector.Create(Self, Associate.Canvas, AElement, Transform.PixelScale);
  FSelectors.Add(Selector);
  Selector.Invalidate;
  if assigned(FOnSelectItem) then
    FOnSelectItem(Self, AElement);
end;

procedure TpgSceneEditor.SetCommand(const Value: TpgEditorCommand);
begin
  if FCommand <> Value then
  begin
    FCommand := Value;
    DoMessage(cCommandMessages[FCommand]);
    ToolMode := cCommandToolMode[FCommand];
    ToolCursor := cCommandCursors[FCommand];
    CancelSelection;
  end;
end;

procedure TpgSceneEditor.SetHoverHighlighting(const Value: boolean);
begin
  if FHoverHighlighting <> Value then
  begin
    FHoverHighlighting := Value;
    Invalidate;
  end;
end;

procedure TpgSceneEditor.SetHover(Value: TpgElement);
begin
  if FHover <> Value then
  begin
    InvalidateGraphic(FHover);
    FHover := Value;
    UpdateWindowsCursor;
    InvalidateGraphic(FHover);
    if assigned(FOnHoverItem) then
      FOnHoverItem(Self, FHover);
  end;
end;

procedure TpgSceneEditor.SetScene(const Value: TpgScene);
begin
  // Before using a new scene we must make sure that there are no shapes selected
  // in the current scene
  CancelSelection;
  inherited SetScene(Value);
end;

procedure TpgSceneEditor.UpdateHoverCursor;
begin
  if assigned(FHover) then
    SetWindowsCursor(crHandPoint)
  else
    SetWindowsCursor(crDefault);
end;

end.
