unit TileDemoMain;
{
  This demo shows how to use NativeJpg in TileMode, and how to scroll the jpeg
  image using the a virtual scrollbox.

  This way, the memory consumption is minimal.

  It also shows how to generate a jpeg file without fully holding the jpeg's
  bitmap in memory, using SaveToStreamStripByStrip. The image generated is
  part of the Mandelbrot fractal (this is just an example, could be anything).

  TileDemo now uses TsdJpegGraphic

  Author: Nils Haeck M.Sc.
  Copyright (c) 2007 - 2011 SimDesign BV (www.simdesign.nl)

}

{$i simdesign.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, ComCtrls, ShellAPI,

  // NativeJpg
  NativeJpg, sdJpegImage, sdVirtualScrollbox,
  sdBitmapConversionWin, sdMapIterator, sdJpegTypes, sdDebug;

type
  TfrmTileDemo = class(TForm)
    MainMenu1: TMainMenu;
    sbMain: TStatusBar;
    mnuFile: TMenuItem;
    mnuOpenJpeg: TMenuItem;
    N1: TMenuItem;
    mnuExit: TMenuItem;
    mnuScale: TMenuItem;
    mnuFullSize: TMenuItem;
    mnuHalfSize: TMenuItem;
    mnuQuarterSize: TMenuItem;
    mnuEighthSize: TMenuItem;
    mnuGenerateJpeg: TMenuItem;
    mnuHelp: TMenuItem;
    mnuVisitWebsite: TMenuItem;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure mnuOpenJpegClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuFullSizeClick(Sender: TObject);
    procedure mnuHalfSizeClick(Sender: TObject);
    procedure mnuQuarterSizeClick(Sender: TObject);
    procedure mnuEighthSizeClick(Sender: TObject);
    procedure mnuGenerateJpegClick(Sender: TObject);
    procedure mnuVisitWebsiteClick(Sender: TObject);
  private
    FJpeg: TsdJpegGraphic;     // Simdesign's NativeJpg
    FBox: TsdVirtualScrollbox; // Simdesign's virtual scrollbox component
    FBitmap: TBitmap;          // (partial) bitmap
    FPalette: array of T32bitPaletteEntry;
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
    procedure BoxPaint(Sender: TObject; ACanvas: TCanvas);
    procedure LoadJpegFile(const AFileName: Utf8String);
    procedure UpdateScale;
    procedure CreateRainbowPalette;
    procedure Mandelbrot(AIter: TsdMapIterator; ALeft, ATop: integer;
      const XScl, XOfs, YScl, YOfs, Lim: double);
    procedure JpegProvideStrip(Sender: TObject; ALeft, ATop: integer; ABitmapIter: TsdMapIterator);
    function JpegCreateMap(var AIterator: TsdMapIterator): TObject;
  public
    { Public declarations }
  end;

var
  frmTileDemo: TfrmTileDemo;

implementation

{$R *.dfm}

procedure TfrmTileDemo.FormCreate(Sender: TObject);
begin
  // Create jpegformat object
  FJpeg := TsdJpegGraphic.Create;

  // use tiled drawing
  FJpeg.UseTiledDrawing := True;

  // Create virtual scrollbox, done at runtime to
  // avoid having to install it on the component palette
  FBox := TsdVirtualScrollbox.Create(Self);
  FBox.Parent := Self;
  FBox.Align := alClient;

  // The OnPaint of the virtual scrollbox we connect to BoxPaint
  FBox.OnPaint := BoxPaint;
end;

procedure TfrmTileDemo.FormDestroy(Sender: TObject);
begin
//
end;

procedure TfrmTileDemo.mnuOpenJpegClick(Sender: TObject);
begin
  // Show a dialog to the user to select a jpeg file
  with TOpenDialog.Create(nil) do
    try
      Title := 'Open Jpeg file interactively';
      Filter := 'Jpeg files (*.jpg)|*.jpg';
      if Execute then
      begin
        LoadJpegFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TfrmTileDemo.LoadJpegFile(const AFileName: Utf8String);
// For tiled mode, we must hold that stream open as long as we're
// scrolling. The data for the part of the bitmap that scrolls into view will
// be loaded interactively from the jpeg file.
begin
  DoDebugOut(Self, wsInfo, 'Loading jpeg from stream...');

  // Load the jpeg. It is in TileMode already, and LoadFromFile will not actually
  // allocate any memory for the coefficients or samples, just loads through the
  // file and stores info on where the blocks are located. Note that only
  // jpeg files with baseline encoding are supported. If you try opening another
  // type (e.g. progressive), an exception will be generated.
  try
    FJpeg.Image.OnCreateMap := JpegCreateMap;
    FJpeg.LoadFromFile(AFileName);

    // We set the scrollbox to the jpeg image size
    FBox.SetScrollBounds(0, 0, FJpeg.Width, FJpeg.Height);
    DoDebugOut(Self, wsInfo, Format('Loading Jpeg "%s" (%d x %d - %3.1f Mpixel, %d bytes)',
      [AFileName,
       FJpeg.Width, FJpeg.Height,
       FJpeg.Width * FJpeg.Height / 1000000,
       FJpeg.DataSize]));

    // this will fire BoxPaint
    FBox.Invalidate;

  except
    on E: Exception do
    begin
      sbMain.SimpleText := E.Message;
    end;
  end;
end;

procedure TfrmTileDemo.BoxPaint(Sender: TObject; ACanvas: TCanvas);
// We arrive here when the virtual scrollbox has to refresh an area
var
  C: TRect;
begin
  // Do we already have a jpeg loaded?
  if FJpeg.DataSize = 0 then
    exit;

  // Here we need to figure out which part of the jpeg to load.
  // We use method LoadTileBlock.

  // Figure out which part of the screen needs updating
  C := ACanvas.ClipRect;
  OffsetRect(C, FBox.ScrollLeft, FBox.ScrollTop);

  // Anything to update?
  if (C.Right - C.Left <= 0) or (C.Bottom - C.Top <= 0) then
    exit;

  // Now call the Jpeg LoadTileBlock function
  FJpeg.LoadTileBlock(C.Left, C.Top, C.Right, C.Bottom);

  // The jpeg's bitmap now has this block, we draw it to the canvas
  ACanvas.Draw(
    C.Left - FBox.ScrollLeft,
    C.Top - FBox.ScrollTop,
    FBitmap);
end;

procedure TfrmTileDemo.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  sbMain.SimpleText := sdDebugMessageToString(Sender, WarnStyle, AMessage);
  Application.ProcessMessages;
end;

procedure TfrmTileDemo.mnuGenerateJpegClick(Sender: TObject);
var
  D: Utf8String;
  W: integer;
begin
  // Here we will generate a Jpeg file of cWidth x cHeight pixels, with a nice
  // mandelbrot fractal pattern. This demo shows how to use the NativeJpg library
  // to save the jpeg strip-by-strip, to avoid holding the complete bitmap
  // in memory up front. We can use this jpeg file later to test the tiled scrolling.

  CreateRainbowPalette;
  FJpeg.Image.SaveOptions.Quality := 80;

  D := InputBox('Specify dimensions of generated image', 'Dimension:', '5000');
  W := StrToIntDef(D, 5000);

  with TSaveDialog.Create(nil) do
    try
      Title := 'Save generated Jpeg file';
      Filter := 'Jpeg files (*.jpg)|*.jpg';
      FileName := 'mandelbrot.jpg';
      if Execute then
      begin
        //FSaveStream := TMemoryStream.Create;
        try
          FJpeg.Image.OnProvideStrip := JpegProvideStrip;
          FJpeg.Image.OnCreateMap := JpegCreateMap;
          FJpeg.Image.SaveBitmapStripByStrip(W, W);
          DoDebugOut(Self, wsInfo, 'Rendering done, saving file to disk...');
          FJpeg.SaveToFile(FileName);
          DoDebugOut(Self, wsInfo, 'Done.');
        finally
          //FSaveStream.Free;
        end;
      end;
    finally
      Free;
    end;
end;

procedure TfrmTileDemo.JpegProvideStrip(Sender: TObject; ALeft, ATop: integer; ABitmapIter: TsdMapIterator);
// For each strip in the jpeg file to be saved, this event is called, and we must fill
// ABitmap with the correct strip in the mandelbrot set
begin
  // Mandelbrot set from -1.5,0.5 in x and -1.0,1.0 in y
  //Mandelbrot(ABitmapIter, ALeft, ATop, 2/ABitmapIter.Width, -1.5, 2/ABitmapIter.Width, -1.0, 4);

  // Mandelbrot set from -1.2 in x and -0.34 in y (width 0.14)
  Mandelbrot(ABitmapIter, ALeft, ATop, 0.14/ABitmapIter.Width, -1.2, 0.14/ABitmapIter.Width, -0.34, 4);
  if ATop < 40 then
  begin
{todo      ABitmap.Canvas.Font.Color := clWhite;
    ABitmap.Canvas.Brush.Style := bsClear;
    ABitmap.Canvas.TextOut(0, -ATop, 'SimDesign BV demo: mandelbrot generated jpg');}
  end;
  DoDebugOut(Self, wsInfo, Format('Rendering mandelbrot line %d of %d (%3.1f%%), Jpeg size %d Kb',
    [ATop, ABitmapIter.Width, ATop * 100 / ABitmapIter.Width, round(FJpeg.DataSize / 1024)]));
end;

function TfrmTileDemo.JpegCreateMap(var AIterator: TsdMapIterator): TObject;
begin
  DoDebugOut(Self, wsInfo, Format('create TBitmap x=%d y=%d stride=%d',
    [AIterator.Width, AIterator.Height, AIterator.CellStride]));

  if (not assigned(FBitmap)) or (FBitmap.Width <> AIterator.Width) or
    (FBitmap.Height <> AIterator.Height) then
  begin
    // create a new bitmap with iterator size and pixelformat
    FreeAndNil(FBitmap);
    FBitmap := SetBitmapFromIterator(AIterator);
  end;

  // also update the iterator with bitmap properties
  GetBitmapIterator(FBitmap, AIterator);

  Result := FBitmap;
end;

procedure TfrmTileDemo.CreateRainbowPalette;
// Create a colourful 500-colour rainbow palette
var
  i, Col0, Col1, Col2, Col3, Col4, Col5: integer;
begin
  SetLength(FPalette, 500);
  Col0 := $00000000; // Black
  Col1 := $00FF00FF; // Magenta
  Col2 := $000000FF; // Red
  Col3 := $0000FFFF; // Yellow
  Col4 := $0000FF00; // Green
  Col5 := $00FF0000; // Blue
  for i := 0 to 100 - 1 do
  begin
    FPalette[i      ].Color := InterpolateColor(Col0, Col1, i / 100);
    FPalette[i + 100].Color := InterpolateColor(Col1, Col2, i / 100);
    FPalette[i + 200].Color := InterpolateColor(Col2, Col3, i / 100);
    FPalette[i + 300].Color := InterpolateColor(Col3, Col4, i / 100);
    FPalette[i + 400].Color := InterpolateColor(Col4, Col5, i / 100);
  end;
end;

procedure TfrmTileDemo.Mandelbrot(AIter: TsdMapIterator; ALeft, ATop: integer;
  const XScl, XOfs, YScl, YOfs, Lim: double);
// Mandelbrot will provide a generated image into the AIter iterator describing
// the bitmap
var
  xi, yi, lp: integer;
  PB: Pbyte;
  xv, yv, a1, a2, b1, b2, a1s, b1s: double;
  X: array of double;
begin
  SetLength(X, AIter.Width);
  for xi := 0 to AIter.Width - 1 do
    X[xi] := (ALeft + xi) * XScl + XOfs;
  PB := AIter.First;
  for yi := 0 to AIter.Height - 1 do
  begin
    yv := (ATop + yi) * YScl + YOfs;
    for xi := 0 to AIter.Width - 1 do
    begin
      xv := X[xi];
      // Mandelbrot formula
      a1 := xv;
      b1 := yv;
      lp := 0;
      a1s := a1 * a1;
      b1s := b1 * b1;
      repeat
        // Do one iteration. Calculate Cnew = Cold^2 + X
        inc(lp);
        // Cnew = a2 + i*b2, done componentwise
        a2 := a1s - b1s + xv;
        b2 := 2 * a1 * b1 + yv;
        // Cold = Cnew
        a1 := a2;
        b1 := b2;
        a1s := a1 * a1;
        b1s := b1 * b1;
      until (lp > 499) or (a1s + b1s > Lim);
      // The first condition is satisfied if we have convergence.
      // The second is satisfied if we have divergence.
      if lp > 499 then
        lp := 0;
      PB^ := FPalette[lp].B; inc(PB);
      PB^ := FPalette[lp].G; inc(PB);
      PB^ := FPalette[lp].R;
      PB := AIter.Next;
      if PB = nil then
      begin
        exit;
      end;
    end;
  end;
end;

procedure TfrmTileDemo.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTileDemo.UpdateScale;
begin
  // Reload. After a scale change, this is always necessary
  DoDebugOut(Self, wsInfo, 'Loading at different scale...');
  FJpeg.Image.Reload;

  // We set the scrollbox to the jpeg size
  FBox.SetScrollBounds(0, 0, FJpeg.Width, FJpeg.Height);

  DoDebugOut(Self, wsInfo, Format('Jpeg size %d x %d, %d Kb',
    [FJpeg.Width, FJpeg.Height, round(FJpeg.DataSize / 1024)]));

  FBox.Invalidate;
end;

procedure TfrmTileDemo.mnuFullSizeClick(Sender: TObject);
begin
  FJpeg.Scale := jsFull;
  mnuFullSize.Checked := True;
  UpdateScale;
end;

procedure TfrmTileDemo.mnuHalfSizeClick(Sender: TObject);
begin
  FJpeg.Scale := jsDiv2;
  mnuHalfSize.Checked := True;
  UpdateScale;
end;

procedure TfrmTileDemo.mnuQuarterSizeClick(Sender: TObject);
begin
  FJpeg.Scale := jsDiv4;
  mnuQuarterSize.Checked := True;
  UpdateScale;
end;

procedure TfrmTileDemo.mnuEighthSizeClick(Sender: TObject);
begin
  FJpeg.Scale := jsDiv8;
  mnuEighthSize.Checked := True;
  UpdateScale;
end;

procedure TfrmTileDemo.mnuVisitWebsiteClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://www.simdesign.nl/nativejpg.html', nil, nil, SW_SHOWDEFAULT);
end;

end.
