unit SvgViewerMain;
{
  This demo shows some of the features of the Pyro library and its shape types.

  Author: Nils Haeck
  Date: 26jan2007

  copyright (c) 2007-2011 by SimDesign BV (www.simdesign.nl)
}

// Define if you downloaded the Pyro Raster additions
{$define RASTER}   

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, ExtCtrls,

  // pyro
  pgPlatform, pgDocument, pgScene, pgCustomView, pgColor, pgTransform,
  pgPath, pgSceneViewer, pgContentProvider, {pgPyroControl,} pgPyroCanvas,
  pgViewer, pgRender, pgScalableVectorGraphics, sdDebug, Pyro,

  {$ifdef RASTER}
  pgRasterJpg,
  //pgRasterGif,
  //pgRasterPng,
  {$endif}

  // simdesign
  NativeXml;

type
  TfrmMain = class(TForm)
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    mnuDemo: TMenuItem;
    mnuClear: TMenuItem;
    mnuAddLines: TMenuItem;
    mnuAddRectangles: TMenuItem;
    sbMain: TStatusBar;
    mnuAddPath: TMenuItem;
    mnuAddElllipses: TMenuItem;
    mnuAddText: TMenuItem;
    mnuTest: TMenuItem;
    mnuRefreshRate: TMenuItem;
    mnuSetAntiAliasing: TMenuItem;
    mnuAALow: TMenuItem;
    mnuAAMedium: TMenuItem;
    mnuAAHigh: TMenuItem;
    mnuAANone: TMenuItem;
    mnuAAVeryLow: TMenuItem;
    mnuSetPremultiplication: TMenuItem;
    mnuPlain: TMenuItem;
    mnuPremultiplied: TMenuItem;
    mnuLoadSVG: TMenuItem;
    mnuSetEngine: TMenuItem;
    mnuPyroEngine: TMenuItem;
    mnuGDIEngine: TMenuItem;
    mnuStressTest: TMenuItem;
    mnuInteractive: TMenuItem;
    mnuClickme: TMenuItem;
    PageControl1: TPageControl;
    tsImage: TTabSheet;
    tsDebug: TTabSheet;
    mmDebug: TMemo;
    mnuHelp: TMenuItem;
    mnuAbout: TMenuItem;
    tsSource: TTabSheet;
    mmSource: TMemo;
    procedure mnuExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuClearClick(Sender: TObject);
    procedure mnuAddLinesClick(Sender: TObject);
    procedure mnuAddRectanglesClick(Sender: TObject);
    procedure mnuAddPathClick(Sender: TObject);
    procedure mnuAddEllipsesClick(Sender: TObject);
    procedure mnuAddTextClick(Sender: TObject);
    procedure mnuRefreshRateClick(Sender: TObject);
    procedure mnuAALowClick(Sender: TObject);
    procedure mnuAAMediumClick(Sender: TObject);
    procedure mnuAAHighClick(Sender: TObject);
    procedure mnuAANoneClick(Sender: TObject);
    procedure mnuAAVeryLowClick(Sender: TObject);
    procedure mnuPremultipliedClick(Sender: TObject);
    procedure mnuPlainClick(Sender: TObject);
    procedure mnuLoadSVGClick(Sender: TObject);
    procedure mnuPyroEngineClick(Sender: TObject);
    procedure mnuGDIEngineClick(Sender: TObject);
    procedure mnuStressTestClick(Sender: TObject);
    procedure mnuClickmeClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
  private
    FScene: TpgScene;
    FViewer: TpgSceneViewer;
    FPanel: TpgCustomView;
    // call this method to force a redraw
    procedure ForceRedraw;
    function RandomColor: TpgColor32;
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
  public
    procedure SvgDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // We create a pyrographics scene here. It is a descendant of TComponent
  // so we can just create it with "Self", and do not have to explicitly destroy it.
  FScene := TpgScene.Create(Self);

  // Create a scene viewer, this is also a non-visual component
  // The engine package provides a more mature scene viewer, that does support interaction
  // like clicking in the document window.
  FViewer := TpgPyroViewer.Create(Self);

  // Add a custom view to the form, this is a TpgCustomControl descendant
  FPanel := TpgCustomView.Create(Self);
  FPanel.Parent := tsImage;
  FPanel.Align := alClient;
  FPanel.OnMouseDown := PanelMouseDown;

  // Use our Pyro canvas
  FPanel.CanvasType := ctPyro;
  mnuPyroEngine.Checked := True;

  // Connect the scene to the viewer
  FViewer.Scene := FScene;

  // The provider that will draw the panel is the viewer
  FPanel.Provider := FViewer;
end;

procedure TfrmMain.mnuLoadSVGClick(Sender: TObject);
var
  FS: TFileStream;
  Svg: TpgSvgImport;
begin
  with TOpenDialog.Create(nil) do
  begin
    try
      Filter := 'SVG files (*.svg)|*.svg';
      if Execute then
      begin
        FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
        try
          mmDebug.Lines.Clear;

          // Instantiate the SVG import module
          Svg := TpgSvgImport.Create(Self);
          try

            // show the source XML on the source tab
            mmSource.Lines.Clear;
            mmSource.Lines.LoadFromStream(FS);
            mmSource.Update;

            // Import the scene from the SVG in stream FS
            Svg.OnDebugOut := SvgDebug;
            Svg.ImportScene(FScene, FS);

          finally
            Svg.Free;
          end;
        finally
          FS.Free;
        end;
      end;
    finally
      Free;
    end;
  end;
  ForceRedraw;
end;

procedure TfrmMain.ForceRedraw;
begin
  // Make sure the panel redraws..
  FPanel.Invalidate;
end;

procedure TfrmMain.PanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// This routine is part of the clickme example. We test which graphic shape
// was hit.
var
  MouseInfo: TpgMouseInfo;
  Parent: TpgGroup;
  HitInfo: TpgHitTestInfo;
begin
  // Convert mouse info
  MouseInfo.X := X;
  MouseInfo.Y := Y;

  // Determine where we clicked. The viewer has a renderer class that also
  // provides the hittesting functionality. We call this class' HitTest function
  if TpgRenderer(FViewer.Renderer).HitTest(FPanel.Canvas,
    FScene.ViewPort, FViewer.Transform, MouseInfo, HitInfo) then
  begin
    // We hit something.. what did we hit?
    if HitInfo.Graphic.Parent is TpgGroup then
    begin
      // The parent of the graphic is a TpgGroup (see mnuClickMe), so the
      // index 1 sub element is the text
      Parent := TpgGroup(HitInfo.Graphic.Parent);
      ShowMessage(Format('you clicked %s!', [TpgText(Parent.Elements[1]).Text.StringValue]));
    end;
  end;
end;

procedure TfrmMain.mnuClearClick(Sender: TObject);
begin
  FScene.Clear;
  ForceRedraw;
end;

procedure TfrmMain.mnuAddLinesClick(Sender: TObject);
// Add some random lines to the scene
var
  i: integer;
  Line: TpgLine;
  Parent: TpgGraphic;
  W, H: integer;
begin
  FScene.Clear;

  // Some quickies
  W := FPanel.Width;
  H := FPanel.Height;

  // The parent of the shapes is the default scene's viewport
  Parent := FScene.Viewport;
  Randomize;
  for i := 1 to 50{100} do
  begin
    Line := TpgLine.CreateParent(FScene, Parent);

    // Set start and endpoint. Done with integers here but you can add with float
    // precision
    Line.X1.FloatValue := random(W);
    Line.Y1.FloatValue := random(H);
    Line.X2.FloatValue := random(W);
    Line.Y2.FloatValue := random(H);

    // Set line stroke width. Again, we have float precision. It's even possible
    // to draw lines less than one pixel wide (due to anti-aliasing).
    case i mod 4 of
    0: Line.StrokeWidth.FloatValue := 0.7;
    1: Line.StrokeWidth.FloatValue := 1.3;
    2: Line.StrokeWidth.FloatValue := 2.5;
    3: Line.StrokeWidth.FloatValue := 3.6;
    end;

    // Set line stroke colour
    Line.Stroke.AsColor32 := RandomColor;
  end;

  // After changing the document we redraw it
  ForceRedraw;

  FScene.XmlFormat := xfReadable;
  FScene.SaveToFile('C:\temp\svgtestline.svg');
  //FScene.SaveToBinaryFile('svgtestline_binary.bxm');
  //FScene.SymbolTable.SaveToFile('strings.txt');
end;

procedure TfrmMain.mnuAddRectanglesClick(Sender: TObject);
// Add some random rectangles to the scene
var
  i: integer;
  R: double;
  Rectangle: TpgRectangle;
  Parent: TpgGraphic;
  W, H: integer;
  ATransform: TpgAffineTransform;
begin
  FScene.Clear;

  // Some quickies
  W := FPanel.Width;
  H := FPanel.Height;

  // The parent of the shapes is the default scene's viewport
  Parent := FScene.Viewport;
  for i := 1 to 100 do
  begin
    Rectangle := TpgRectangle.CreateParent(FScene, Parent);

    // Set width and height
    Rectangle.Width.FloatValue := random(W div 3 + 20);
    Rectangle.Height.FloatValue := random(H div 3 + 20);

    // set X and Y
    Rectangle.X.FloatValue := 0;
    Rectangle.Y.FloatValue := 0;

    // In 1 out of 4, set rounding of corners
    if i mod 4 = 0 then
    begin
      R := pgMin(Rectangle.Width.FloatValue / 4, Rectangle.Height.FloatValue / 4);
      Rectangle.RX.FloatValue := R;
      Rectangle.RY.FloatValue := R;
    end;

    // Set colours, solid for stroke, transparent for fill
    Rectangle.Stroke.AsColor32 := RandomColor;
    Rectangle.Fill.AsColor32 := RandomColor;

    // This sets the fill to semi-transparent (0=transparent, 1=opaque)
    Rectangle.FillOpacity.FloatValue := 0.5;

    // Set strokewidth
    Rectangle.StrokeWidth.FloatValue := 2;

    // Do some rotation around rectangle center, then translate it
    ATransform := TpgAffineTransform.Create;
    ATransform.Rotate(Random(40) - 20, Rectangle.Width.FloatValue/2, Rectangle.Height.FloatValue/2);
    ATransform.Translate(random(W), random(H));
    Rectangle.Transform.TransformValue := ATransform;

  end;
  // After changing the document we redraw it
  ForceRedraw;
  FScene.XmlFormat := xfReadable;
  FScene.SaveToFile('svgtestrect.svg');
end;

procedure TfrmMain.mnuAddPathClick(Sender: TObject);
// This demo shows how to add a path in two ways
var
  Parent: TpgGraphic;
  PathShape: TpgPathShape;
  ATransform: TpgAffineTransform;

  // construct a command path with lines, an arc and a cubic bezier curve
  function ConstructPath: TpgCommandPath;
  begin
    Result := TpgCommandPath.Create;
    Result.MoveToAbs(10, 100);
    Result.LineToAbs(190, 100);
    Result.ArcToAbs(20, 20, 45, false, false, 210, 80);
    Result.LineToAbs(210, 10);
    Result.LineToAbs(40, 10);
    Result.CurveToCubicAbs(40,50,10,50,10,80);
    Result.ClosePath;
  end;
begin
  FScene.Clear;
  Parent := FScene.Viewport;

  // Create a path shape
  PathShape := TpgPathShape.CreateParent(FScene, Parent);
  PathShape.Path.PathValue := ConstructPath;
  PathShape.Stroke.AsColor32 := clGreen32;
  PathShape.StrokeWidth.FloatValue := 4.0;

  // Create the same path but add dash, transparency and transform
  PathShape := TpgPathShape.CreateParent(FScene, Parent);
  PathShape.Path.PathValue := ConstructPath;

  PathShape.Stroke.AsColor32 := clRed32;
  PathShape.StrokeWidth.FloatValue := 4.0;

  // Add a dash pattern
  PathShape.StrokeDashArray.Add(12, luNone);
  PathShape.StrokeDashArray.Add(3, luNone);

  // Fill it semi-transparently
  PathShape.Fill.AsColor32 := clYellow32;
  PathShape.FillOpacity.FloatValue := 0.5;

  // Add a transform to move it to a slightly different location and scale up
  ATransform := TpgAffineTransform.Create;
  ATransform.Scale(1.5, 1.5);
  ATransform.Translate(20, 20);
  PathShape.Transform.TransformValue := ATransform;

  // After changing the document we redraw it
  ForceRedraw;
end;

procedure TfrmMain.mnuAddEllipsesClick(Sender: TObject);
var
  i: integer;
  Ellipse: TpgEllipse;
  Parent: TpgGraphic;
  W, H: integer;
  ATransform: TpgAffineTransform;
begin
  FScene.Clear;
  // Add some random ellipses to the scene

  // Some quickies
  W := FPanel.Width;
  H := FPanel.Height;

  // The parent of the shapes is the default scene's viewport
  Parent := FScene.Viewport;
  for i := 1 to 100 do
  begin
    Ellipse := TpgEllipse.CreateParent(FScene, Parent);

    // Set X and Y lengths of the radii
    Ellipse.Rx.FloatValue := random(W div 6 + 10);
    Ellipse.Ry.FloatValue := random(H div 6 + 10);

    // Set colours, solid for stroke, transparent for fill
    Ellipse.Stroke.AsColor32 := RandomColor;
    Ellipse.Fill.AsColor32 := RandomColor;

    // This sets the fill to semi-transparent (0=transparent, 1=opaque)
    Ellipse.FillOpacity.FloatValue := 0.5;

    // Set strokewidth
    Ellipse.StrokeWidth.FloatValue := 2;

    // Do some rotation around ellipse center, then translate it
    ATransform := TpgAffineTransform.Create;
    ATransform.Rotate(Random(40) - 20, 0, 0);
    ATransform.Translate(random(W), random(H));
    Ellipse.Transform.TransformValue := ATransform;

  end;
  // After changing the document we redraw it
  ForceRedraw;
end;

procedure TfrmMain.mnuAddTextClick(Sender: TObject);
var
  i: integer;
  W, H: integer;
  Text: TpgText;
  Parent: TpgGraphic;
  ATransform: TpgAffineTransform;
begin
  FScene.Clear;
  Parent := FScene.Viewport;
  W := FPanel.Width;
  H := FPanel.Height;

  // Loop through a circle
  for i := 0 to 17 do
  begin
    Text := TpgText.CreateParent(FScene, Parent);

    // Font and size
    Text.FontFamily.StringValue := 'Verdana';
    Text.FontSize.FloatValue := 20;

    // Set stroke and strokewidth
    Text.Fill.AsColor32 := clBlack32;

    // Set text (this is a Utf8String)
    Text.Text.AsString := 'Hello World!';

    // Override properties in some cases
    case i mod 4 of
//    0: Span.FontWeight.FloatValue := fwBold;
    1: Text.Fill.AsColor32 := clRed32;
    2:
      begin
        Text.Fill.AsColor32 := clLime32;
        Text.Stroke.AsColor32 := clGreen32;
        Text.StrokeWidth.FloatValue := 0.05; // check this!}
      end;
//    3: Span.FontStyle.FloatValue := fsItalic;
    end;//case

    // Add a transform to the text
    ATransform := TpgAffineTransform.Create;
    ATransform.Translate(W div 2, H div 2);
    ATransform.Rotate(i * 20, 0, 0);
    ATransform.Translate(50, 0);
    Text.Transform.TransformValue := ATransform;

  end;
  // After changing the document we redraw it
  ForceRedraw;
end;

procedure TfrmMain.mnuStressTestClick(Sender: TObject);
// Stress test: add 500 x 500 = 250.000 rectangles to the scene
const
  cXCount = 100;
  cYCount = 100;
var
  i, j: integer;
  RW, RH: double;
  Rectangle: TpgRectangle;
  Parent: TpgGraphic;
begin
  FScene.Clear;
  Parent := FScene.Viewport;
  RW := FPanel.Width / cXCount;
  RH := FPanel.Height / cYCount;
  for i := 0 to cXCount - 1 do
  begin
    for j := 0 to cYCount - 1 do
    begin
      Rectangle := TpgRectangle.CreateParent(FScene, Parent);
      // Set width and height
      Rectangle.Width.FloatValue := RW;
      Rectangle.Height.FloatValue := RH;
      // set X and Y
      Rectangle.X.FloatValue := i * RW;
      Rectangle.Y.FloatValue := j * RH;
      // Color
      Rectangle.Fill.AsColor32 := RandomColor;
    end;
  end;
  // After changing the document we redraw it
  ForceRedraw;
end;

procedure TfrmMain.mnuRefreshRateClick(Sender: TObject);
// Test the refresh rate
var
  i, W2, H2: integer;
  //ScaleFactor,
  Delta: double;
  Ang, FPS: double;
  Tick, DT: longword;
  Transform: TpgAffineTransform;
begin
  sbMain.SimpleText := 'Testing...';
  Application.ProcessMessages;

  // Register start time
  Tick := pgGetTickCount;
  DT := Tick;
  W2 := FPanel.Width div 2;
  H2 := FPanel.Height div 2;

  // Now loop and do this with an angle
  Ang := 0;
  for i := 1 to 100 do
  begin

    // In this case we add a rotate to the viewer so we visually see the scene change
    //ScaleFactor := 1 + 0.5 * sin(i/25 * pi);
    Transform := TpgAffineTransform.Create;

    // rotate the scene
    //Transform.Translate(W2, H2);
    //Transform.Scale(ScaleFactor, ScaleFactor);
    //Transform.Translate(-W2, -H2);
    Transform.Rotate(Ang, W2, H2);
    FViewer.Transform.Assign(Transform);
    Transform.Free;

    // Make sure the panel redraws..
    ForceRedraw;
    Application.ProcessMessages;

    // update the loop
    Ang := Ang - 0.5;
    FPS := 1000 / pgMax(pgGetTickCount - DT, 1);
    DT := pgGetTickCount;
    frmMain.Caption := Format('%3.1f FPS', [FPS]);
  end;

  // Register end time and display
  Delta := (pgGetTickCount - Tick) / 1000; // time in seconds that passed
  sbMain.SimpleText := Format('Average framerate: %5.1f FPS', [100 / Delta]);
  sbMain.Invalidate;
end;

procedure TfrmMain.mnuAANoneClick(Sender: TObject);
begin
  // No AA
  pgSetAntiAliasing(0);
  mnuAANone.Checked := True;
  ForceRedraw;
end;

procedure TfrmMain.mnuAAVeryLowClick(Sender: TObject);
begin
  // 2-level AA
  pgSetAntiAliasing(1);
  mnuAAVeryLow.Checked := True;
  ForceRedraw;
end;

procedure TfrmMain.mnuAALowClick(Sender: TObject);
begin
  // 4-level AA
  pgSetAntiAliasing(2);
  mnuAALow.Checked := True;
  ForceRedraw;
end;

procedure TfrmMain.mnuAAMediumClick(Sender: TObject);
begin
  // 16-level AA
  pgSetAntiAliasing(3);
  mnuAAMedium.Checked := True;
  ForceRedraw;
end;

procedure TfrmMain.mnuAAHighClick(Sender: TObject);
begin
  // 256-level AA
  pgSetAntiAliasing(4);
  mnuAAHigh.Checked := True;
  ForceRedraw;
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuPlainClick(Sender: TObject);
begin
  // Set the canvas surface color info to non-premultiplied colors
  TpgPyroBitmapCanvas(FPanel.Canvas).SurfaceColorInfo^ := cARGB_8b_Org;
  mnuPlain.Checked := True;
  ForceRedraw;
end;

procedure TfrmMain.mnuPremultipliedClick(Sender: TObject);
begin
  // Set the canvas surface color info to premultiplied colors
  TpgPyroBitmapCanvas(FPanel.Canvas).SurfaceColorInfo^ := cARGB_8b_Pre;
  mnuPremultiplied.Checked := True;
  ForceRedraw;
end;

procedure TfrmMain.mnuPyroEngineClick(Sender: TObject);
begin
  FPanel.CanvasType := ctPyro;
  mnuPyroEngine.Checked := True;
  ForceRedraw;
end;

procedure TfrmMain.mnuGDIEngineClick(Sender: TObject);
begin
  FPanel.CanvasType := ctGDI;
  mnuGDIEngine.Checked := True;
  ForceRedraw;
end;

procedure TfrmMain.mnuClickmeClick(Sender: TObject);
  // Create a few "buttons" and we detect where the user clicked
  procedure AddButton(X, Y, W, H: double; const AText: string);
  var
    Group: TpgGroup;
    Rect: TpgRectangle;
    Text: TpgText;
  begin
    Group := TpgGroup.CreateParent(FScene, FScene.ViewPort);
    Rect := TpgRectangle.CreateParent(FScene, Group);
    Rect.X.FloatValue := X;
    Rect.Y.FloatValue := Y;
    Rect.Width.FloatValue := W;
    Rect.Height.FloatValue := H;
    Rect.Rx.FloatValue := W / 10;
    Rect.Stroke.AsColor32 := clBlue32;
    Rect.StrokeWidth.FloatValue := 2.5;
    Rect.Fill.AsColor32 := clTeal32;
    Text := TpgText.CreateParent(FScene, Group);
    Text.Text.StringValue := AText;
    Text.X.Add(X + 10, luNone);
    Text.Y.Add(Y + H / 2 + 5, luNone);
    Text.Fill.AsColor32 := clLightGray32;
  end;
var
  r, c: integer;
  W, H, BX, BY, BW, BH: double;
begin
  FScene.Clear;
  W := FPanel.Width ;
  H := FPanel.Height;

  // we set the viewport width and height to ensure the hittesting will analyse
  // the viewport.
  FScene.ViewPort.Width.FloatValue := W;
  FScene.ViewPort.Height.FloatValue := H;

  // 4x3 buttons
  BX := W / 4;
  BY := H / 3;
  BW := BX * 0.8;
  BH := BY * 0.6;

  // font
  FScene.ViewPort.FontFamily.StringValue := 'Verdana';
  FScene.ViewPort.FontSize.FloatValue := 12;
  FScene.ViewPort.FontSize.Units := luPt;

  for r := 0 to 2 do
    for c := 0 to 3 do
    begin
      AddButton(c * BX + BX * 0.1, r * BY + BY * 0.2, BW, BH,
        Format('Button %d', [r * 4 + c + 1]));
    end;
  ForceRedraw;
end;

function TfrmMain.RandomColor: TpgColor32;
begin
  Result := TpgColor32(pgColorARGB(random(256), random(256), random(256), 255));
end;

procedure TfrmMain.SvgDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  mmDebug.Lines.Add(sdDebugMessageToString(Sender, WarnStyle, AMessage));
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
var
  Version: string;
begin
  Version := cPyroVersion;
  ShowMessage(
    'Pyrographics SVG Import trial version'#13 +
    'Copyright (c) SimDesign BV'#13#13 +
    'Version: ' + Version + #13#13 +
    'More information about the purchase of this software can be found here:'#13 +
    'web: www.simdesign.nl'#13 +
    'e-mail: info@simdesign.nl');

end;

end.
