{ unit JpegTestMain;

  Author: Nils Haeck M.Sc.
  Copyright (c) 2007 SimDesign B.V.
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.
}
unit JpegTestMain;

{.$define useLITTLECMS}
{$define useMETADATA}

interface

uses
{$ifdef useLITTLECMS}
  lcmsdll,
{$endif}
{$ifdef useMETADATA}
  sdMetadata, sdMetadataExif, sdMetadataIptc,
{$endif}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls, ExtDlgs, ShellAPI,

  // simdesign
  sdFileList, NativeXml, sdDebug,

  sdJpegImage, sdJpegMarkers, sdMapIterator, sdBitmapConversionWin, sdJpegTypes;

type
  TfrmMain = class(TForm)
    mnuMain: TMainMenu;
    sbMain: TStatusBar;
    mnuFile: TMenuItem;
    mnuOpen: TMenuItem;
    mnuExit: TMenuItem;
    pnlRight: TPanel;
    Splitter1: TSplitter;
    pnlCenter: TPanel;
    pnlControl: TPanel;
    mmDebug: TMemo;
    Label1: TLabel;
    tbBrightness: TTrackBar;
    lbBrightness: TLabel;
    Label2: TLabel;
    tbContrast: TTrackBar;
    lbContrast: TLabel;
    mnuLossless: TMenuItem;
    mnuRotate90: TMenuItem;
    mnuRotate180: TMenuItem;
    mnuRotate270: TMenuItem;
    mnuFliphorizontal: TMenuItem;
    mnuFlipvertical: TMenuItem;
    mnuTranspose: TMenuItem;
    mnuOpenDiv2: TMenuItem;
    mnuOpenDiv4: TMenuItem;
    mnuOpenDiv8: TMenuItem;
    mnuCrop: TMenuItem;
    mnuSaveAs: TMenuItem;
    btnLeft: TButton;
    btnRight: TButton;
    mnuTouch: TMenuItem;
    lbCount: TLabel;
    mnuOptions: TMenuItem;
    mnuDebugOutput: TMenuItem;
    mnuFastIDCT: TMenuItem;
    mnuExtractICC: TMenuItem;
    mnuInjectICC: TMenuItem;
    mnuTiledLoading: TMenuItem;
    PageControl1: TPageControl;
    tsImage: TTabSheet;
    scbMain: TScrollBox;
    imMain: TImage;
    tsMetadata: TTabSheet;
    RichEdit1: TRichEdit;
    mnuReload: TMenuItem;
    mnuClear: TMenuItem;
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tbBrightnessChange(Sender: TObject);
    procedure tbContrastChange(Sender: TObject);
    procedure mnuRotate90Click(Sender: TObject);
    procedure mnuRotate180Click(Sender: TObject);
    procedure mnuRotate270Click(Sender: TObject);
    procedure mnuFliphorizontalClick(Sender: TObject);
    procedure mnuFlipverticalClick(Sender: TObject);
    procedure mnuTransposeClick(Sender: TObject);
    procedure mnuOpenDiv2Click(Sender: TObject);
    procedure mnuOpenDiv4Click(Sender: TObject);
    procedure mnuOpenDiv8Click(Sender: TObject);
    procedure mnuCropClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure mnuTouchClick(Sender: TObject);
    procedure mnuDebugOutputClick(Sender: TObject);
    procedure mnuFastIDCTClick(Sender: TObject);
    procedure mnuExtractICCClick(Sender: TObject);
    procedure mnuInjectICCClick(Sender: TObject);
    procedure mnuTiledLoadingClick(Sender: TObject);
    procedure mnuReloadClick(Sender: TObject);
    procedure mnuClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FBitmap: TBitmap;
    FJpegImage: TsdJpegImage;
    FList: TsdFileList;
    FListIdx: integer;
    FScale: TsdJpegScale;
    procedure LoadJpegFile(const AFileName: string);
    procedure LoadTiledJpegFile(const AFileName: string);
    procedure SaveJpegFile(const AFileName: string);
    function JpegCreateMap(var AIterator: TsdMapIterator): TObject;
    procedure JpegDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
    procedure LoadMetadata;
    function DialogExecute(var AFileName: string): boolean;
{$IFDEF useLITTLECMS}
    procedure JpegExternalCMS(Sender: TObject; var ABitmap: TBitmap);
{$ENDIF}
    procedure wmDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
    procedure AssignBitmap;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
var
  FormStorageName: string;
  FormStorage: TNativeXml;
begin
  FJpegImage := TsdJpegImage.Create(Self);

  // this is the event that creates the bitmap for the jpeg image
  FJpegImage.OnCreateMap := JpegCreateMap;

  // event for debugging
  FJpegImage.OnDebugOut := JpegDebug;

{$IFDEF useLITTLECMS}
  FJpg.OnExternalCMS := JpegExternalCMS;
{$ENDIF}

  FList := TsdFileList.Create;

  // Accept dropped files (ShellAPI)
  DragAcceptFiles(handle, true);

  // form storage
  FormStorageName := Application.ExeName + '.xml';
  JpegDebug(Self, wsInfo, FormStorageName);
  FormStorage := TNativeXml.CreateName('form');
  try
    if FileExists(FormStorageName) then
      FormStorage.LoadFromFile(FormStorageName);
    frmMain.Left := FormStorage.Root.ReadAttributeInteger('left', frmMain.Left);
    frmMain.Top := FormStorage.Root.ReadAttributeInteger('top', frmMain.Top);
    frmMain.Width := FormStorage.Root.ReadAttributeInteger('width', frmMain.Width);
    frmMain.Height := FormStorage.Root.ReadAttributeInteger('height', frmMain.Height);
    pnlRight.width := FormStorage.Root.ReadAttributeInteger('pwidth', pnlRight.Width);
  finally
    FormStorage.Free;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  FormStorageName: string;
  FormStorage: TNativeXml;
begin
  // form storage
  FormStorageName := Application.ExeName + '.xml';
  FormStorage := TNativeXml.CreateName('form');
  try
    if FileExists(FormStorageName) then
      FormStorage.LoadFromFile(FormStorageName);
    FormStorage.Root.WriteAttributeInteger('left', frmMain.Left);
    FormStorage.Root.WriteAttributeInteger('top', frmMain.Top);
    FormStorage.Root.WriteAttributeInteger('width', frmMain.Width);
    FormStorage.Root.WriteAttributeInteger('height', frmMain.Height);
    FormStorage.Root.WriteAttributeInteger('pwidth', pnlRight.Width);
    FormStorage.SaveToFile(FormStorageName);
  finally
    FormStorage.Free;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FList);
end;

function TfrmMain.JpegCreateMap(var AIterator: TsdMapIterator): TObject;
begin
  //JpegDebug(Self, wsInfo, Format('create TBitmap x=%d y=%d stride=%d',
  //  [AIterator.Width, AIterator.Height, AIterator.CellStride]));

  if (not assigned(FBitmap)) or (FBitmap.Width <> AIterator.Width) or
    (FBitmap.Height <> AIterator.Height) then
  begin
    // create a new bitmap with iterator size and pixelformat
    FreeAndNil(FBitmap);
    FBitmap := SetBitmapFromIterator(AIterator);
  end;

  // also update the iterator with bitmap properties
  GetBitmapIterator(FBitmap, AIterator);
  //JpegDebug(Self, wsHint, Format('AIterator bitmap scanstride=%d', [AIterator.ScanStride]));

  Result := FBitmap;
end;

procedure TfrmMain.JpegDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  mmDebug.Lines.Add(sdDebugMessageToString(Sender, WarnStyle, AMessage));
end;

procedure TfrmMain.LoadJpegFile(const AFileName: string);
var
  Folder: string;
begin
  Screen.Cursor := crHourglass;
  try
    sbMain.SimpleText := Format('Loading %s...', [AFileName]);
    // Folder containing this file
    Folder := IncludeTrailingBackslash(ExtractFileDir(AFileName));

    // Scan the selected folder for jpeg files, so the back/forward buttons can
    // be used to browse through
    if (FList.Count = 0) or (FListIdx = -1) then
    begin
      FList.Clear;
      FList.Scan(Folder, '*.jpg', False);
      FListIdx := FList.IndexByName(AFileName);
    end;

    mmDebug.Clear;
    FJpegImage.LoadScale := FScale;
    FJpegImage.LoadOptions := [];

    try
      if mnuTiledLoading.Checked then
      begin

        // load the jpeg in a tiled way
        LoadTiledJpegFile(AFileName);

      end else
      begin

        // load the jpeg in the normal way
        FJpegImage.LoadFromFile(AFileName);

        // Assign the jpeg bitmap property to the image.picture.bitmap
        AssignBitmap;

      end;
    except
      on E: Exception do
        sbMain.SimpleText := E.Message;
    end;

    // load metadata
    LoadMetadata;

    // Update GUI elements
    Caption := Format('%s [%dx%d]', [AFileName, FJpegImage.ImageWidth, FJpegImage.ImageHeight]);
    lbCount.Caption := Format('%d/%d', [FListIdx + 1, FList.Count]);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.LoadTiledJpegFile(const AFileName: string);
// We will load from a memory stream, and then do a tile update for each
// tileblock. As an example, a tile block of 128x128 pixels.
// We must first use LoadFromStream, then LoadTileBock repeatedly (on the same stream)
var
  x, y, Left, Top, Right, Bottom, XCount, YCount: integer;
  M: TMemoryStream;
  B: TBitmap;
const
  // Tilesize to use (e.g. 256x256 pixel blocks)
  cTileSize = 256;
begin
  // Set to TileMode
  FJpegImage.LoadOptions := [loTileMode];

  // Create a memory stream for the image
  M := TMemoryStream.Create;
  try

    // load the memory stream
    M.LoadFromFile(AFileName);

    // Load from the memory stream
    FJpegImage.LoadFromStream(M);

    // Create bitmap with correct size for scale
    B := imMain.Picture.Bitmap;
    B.Width := FJpegImage.Width;
    B.Height := FJpegImage.Height;

    // Number of blocks in X and Y direction
    XCount := (FJpegImage.Width + cTileSize - 1) div cTileSize;
    YCount := (FJpegImage.Height + cTileSize - 1) div cTileSize;

    // Loop through these blocks left to right, top to bottom
    for y := 0 to YCount - 1 do
    begin
      for x := 0 to XCount - 1 do
      begin
        Left   := x * cTileSize;
        Top    := y * cTileSize;
        Right  := Left + cTileSize;
        Bottom := Top + cTileSize;

        // Load a tile block. Each of these blocks is put in the application's
        // FBitmap field by OnCreateMap, but the Jpeg's bitmap size will
        // thus remain very small and consume less memory.
        FJpegImage.LoadTileBlock(Left, Top, Right, Bottom);

        // copy to image bitmap at correct location
        B.Canvas.Draw(Left, Top, FBitmap);

        // Make sure user can see it. Actually this adds a lot of overhead to
        // loading time, but this is demo code
        Application.ProcessMessages;
      end;
    end;

  finally
    M.Free;
  end;
end;

procedure TfrmMain.SaveJpegFile(const AFileName: string);
begin
{  if FJpegImage.JpegInfo.FEncodingMethod = emProgressiveDCT then
    FJpegImage.Reload;}
  FJpegImage.SaveToFile(AFileName);
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

function TfrmMain.DialogExecute(var AFileName: string): boolean;
begin
  Result := False;
  AFileName := '';
  //with TOpenPictureDialog.Create(nil) do
  with TOpenDialog.Create(nil) do  // this is easier to debug
    try
      Filter := 'Jpeg files|*.jpg';
      if Execute then
      begin
        FListIdx := -1;
        AFileName := FileName;
        Result := True;
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.mnuOpenClick(Sender: TObject);
var
  FileName: string;
begin
  if DialogExecute(FileName) then
  begin
    FScale := jsFull;
    LoadJpegFile(FileName);
  end;
end;

procedure TfrmMain.mnuReloadClick(Sender: TObject);
begin
  LoadJpegFile(FList[FListIdx].FullName);
end;

procedure TfrmMain.mnuOpenDiv2Click(Sender: TObject);
var
  FileName: string;
begin
  if DialogExecute(FileName) then
  begin
    FScale := jsDiv2;
    LoadJpegFile(FileName);
  end;
end;

procedure TfrmMain.mnuOpenDiv4Click(Sender: TObject);
var
  FileName: string;
begin
  if DialogExecute(FileName) then
  begin
    FScale := jsDiv4;
    LoadJpegFile(FileName);
  end;
end;

procedure TfrmMain.mnuOpenDiv8Click(Sender: TObject);
var
  FileName: string;
begin
  if DialogExecute(FileName) then
  begin
    FScale := jsDiv8;
    LoadJpegFile(FileName);
  end;
end;

procedure TfrmMain.mnuSaveAsClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
    try
      Filter := 'Jpeg files|*.jpg';
      if Execute then
      begin
        SaveJpegFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.AssignBitmap;
begin
  FJpegImage.LoadJpeg(FJpegImage.LoadScale, True);
  imMain.Picture.Bitmap.Assign(FBitmap);
end;

procedure TfrmMain.tbBrightnessChange(Sender: TObject);
begin
  FJpegImage.Lossless.AdjustBrightness(tbBrightness.Position);
  AssignBitmap;
  lbBrightness.Caption := IntToStr(tbBrightness.Position);
end;

procedure TfrmMain.tbContrastChange(Sender: TObject);
var
  C: double;
begin
  C := Exp(tbContrast.Position / 200);
  FJpegImage.Lossless.AdjustBrightnessContrast(tbBrightness.Position, C);
  AssignBitmap;
  lbContrast.Caption := Format('%5.3f', [C]);;
end;

procedure TfrmMain.mnuRotate90Click(Sender: TObject);
begin
  FJpegImage.Lossless.Rotate90;
  AssignBitmap;
end;

procedure TfrmMain.mnuRotate180Click(Sender: TObject);
begin
  FJpegImage.Lossless.Rotate180;
  AssignBitmap;
end;

procedure TfrmMain.mnuRotate270Click(Sender: TObject);
begin
  FJpegImage.Lossless.Rotate270;
  AssignBitmap;
end;

procedure TfrmMain.mnuFliphorizontalClick(Sender: TObject);
begin
  FJpegImage.Lossless.FlipHorizontal;
  AssignBitmap;
end;

procedure TfrmMain.mnuFlipverticalClick(Sender: TObject);
begin
  FJpegImage.Lossless.FlipVertical;
  AssignBitmap;
end;

procedure TfrmMain.mnuTransposeClick(Sender: TObject);
begin
  FJpegImage.Lossless.Transpose;
  AssignBitmap;
end;

procedure TfrmMain.mnuCropClick(Sender: TObject);
var
  W, H, L, T, R, B: integer;
begin
  W := FJpegImage.ImageWidth;
  H := FJpegImage.ImageHeight;
  L := round(0.1 * W);
  T := round(0.1 * H);
  R := round(0.9 * W);
  B := round(0.9 * H);
  FJpegImage.Lossless.Crop(L, T, R, B);
  AssignBitmap;
end;

procedure TfrmMain.mnuTouchClick(Sender: TObject);
begin
  FJpegImage.Lossless.Touch;
  AssignBitmap;
end;

procedure TfrmMain.btnLeftClick(Sender: TObject);
begin
  if FListIdx = 0 then
    FListIdx := FList.Count - 1
  else
    dec(FListIdx);
  LoadJpegFile(FList[FListIdx].FullName);
end;

procedure TfrmMain.btnRightClick(Sender: TObject);
begin
  if FListIdx >= FList.Count - 1 then
    FListIdx := 0
  else
    inc(FListIdx);
  LoadJpegFile(FList[FListIdx].FullName);
end;

procedure TfrmMain.mnuDebugOutputClick(Sender: TObject);
begin
  mnuDebugOutput.Checked := not mnuDebugOutput.Checked;
  if mnuDebugOutput.Checked then
    FJpegImage.OnDebugOut := JpegDebug
  else
    FJpegImage.OnDebugOut := nil;
end;

procedure TfrmMain.mnuFastIDCTClick(Sender: TObject);
begin
  mnuFastIDCT.Checked := not mnuFastIDCT.Checked;
  if mnuFastIDCT.Checked then
    FJpegImage.DCTCodingMethod := dmFast
  else
    FJpegImage.DCTCodingMethod := dmAccurate;
  AssignBitmap;
end;

procedure TfrmMain.mnuTiledLoadingClick(Sender: TObject);
begin
  mnuTiledLoading.Checked := not mnuTiledLoading.Checked;
end;

procedure TfrmMain.mnuExtractICCClick(Sender: TObject);
// Save the ICC profile that is embedded in the jpeg to a file
var
  Profile: TsdJpegICCProfile;
begin
  Profile := FJpegImage.ICCProfile;
  if assigned(Profile) then
  begin
    with TSaveDialog.Create(nil) do
      try
        Title := 'Save ICC profile';
        Filter := 'ICC profiles (*.icm)|*.icm';
        if Execute then
        begin
          Profile.SaveToFile(FileName);
        end;
      finally
        Free;
      end;
  end else
  begin
    ShowMessage('No ICC profile found in this Jpeg');
  end;
end;

procedure TfrmMain.mnuInjectICCClick(Sender: TObject);
var
  Profile: TsdJpegICCProfile;
begin
  Profile := TsdJpegICCProfile.Create;
  try
    with TOpenDialog.Create(nil) do
      try
        Title := 'Load ICC profile';
        Filter := 'ICC profiles (*.icm)|*.icm';
        if Execute then
        begin
          Profile.LoadFromFile(FileName);
          FJpegImage.ICCProfile := Profile;
          ShowMessage(Format('Profile is injected in the Jpeg (%d bytes)', [Profile.DataLength]));
        end;
      finally
        Free;
      end;
  finally
    Profile.Free;
  end;
end;

procedure TfrmMain.wmDropFiles(var Msg: TWMDropFiles);
var
  FileName: array[0..255] of char;
begin
  // Get filename of dropped file
  DragQueryFile(Msg.Drop, 0, FileName, 254);
  // Open the file
  FListIdx := -1;
  LoadJpegFile(FileName);
end;

{$IFDEF useLITTLECMS}
procedure TfrmMain.JpegExternalCMS(Sender: TObject; var ABitmap: TsdBitmap);
// In case the user uses LittleCMS..
var
  i, W, H: integer;
  HSrc, HPrf, HDst: cmsHPROFILE;
  XForm: cmsHTRANSFORM;
  B: TsdBitmap;
  InputFormat, OutputFormat: cardinal;
  Jpg: TsdJpegFormat;
  SCS: TsdJpegColorSpace;
  PT: array[0..2] of cmsHPROFILE;
  Profile: TsdJpegICCProfile;
begin
  // JPeg object
  Jpg := TsdJpegFormat(Sender);

  // Detect stored colorspace
  SCS := Jpg.DetectInternalColorSpace;

  // Create source profile (of what is in the file)
  case SCS of
  jcGray, jcGrayA:
    HSrc := cmsCreateGrayProfile(nil, nil);
  jcRGB, jcRGBA:
    HSrc := cmsCreateRGBProfile(nil, nil, nil);
  jcYCbCr, jcYCbCrA:
    begin
      HSrc := cmsCreate_sRGBProfile;
      cmsSetColorSpace(HSrc, icSigYCbCrData);
    end;
  jcCMYK:
    begin
      HSrc := cmsCreateRGBProfile(nil, nil, nil);
      cmsSetColorSpace(HSrc, icSigCmykData);
    end;
  else
    // for now: no solution for other color spaces
    exit;
  end;
  cmsSetDeviceClass(HSrc, icSigInputClass);

  InputFormat := COLORSPACE_SH(_cmsLCMScolorSpace(cmsGetColorSpace(HSrc)));
  case SCS of
  jcGray:   inc(InputFormat, BYTES_SH(1) or CHANNELS_SH(1));
  jcGrayA:  inc(InputFormat, BYTES_SH(1) or CHANNELS_SH(1) or EXTRA_SH(1));
  jcRGB:    inc(InputFormat, BYTES_SH(1) or CHANNELS_SH(3));
  jcRGBA:   inc(InputFormat, BYTES_SH(1) or CHANNELS_SH(3) or EXTRA_SH(1));
  jcYCbCr:  inc(InputFormat, BYTES_SH(1) or CHANNELS_SH(3));
  jcYCbCrA: inc(InputFormat, BYTES_SH(1) or CHANNELS_SH(3) or EXTRA_SH(1));
  jcCMYK:   inc(InputFormat, BYTES_SH(1) or CHANNELS_SH(4));
  end;

  // ICC profile defined in Jpeg file (if any)
  Profile := Jpg.ICCProfile;
  if assigned(Profile) then
    HPrf := cmsOpenProfileFromMem(Profile.Data, Profile.DataLength)
  else
    HPrf := nil;

  // We output to sRGB for now - feel free to exchange for any device-calibrated
  // profile.
  HDst := cmsCreate_sRGBProfile;
  OutputFormat := TYPE_BGR_8;

  // if we have a profile we use the multitransform
  if assigned(Profile) then
  begin
    PT[0] := HSrc;
    PT[1] := HPrf;
    PT[2] := HDst;
    XForm := cmsCreateMultiProfileTransform(@PT[0], 3, InputFormat, OutputFormat, INTENT_PERCEPTUAL, 0);
  end else
  begin
    XForm := cmsCreateTransform(HSrc, InputFormat, HDst, OutputFormat, INTENT_PERCEPTUAL, 0);
  end;

  // Bitmap size
  W := ABitmap.Width;
  H := ABitmap.Height;

  // Create new bitmap
  B := TsdBitmap.Create;
  B.PixelFormat := spf24bit;
  B.Width := W;
  B.Height := H;

  // Apply the transform, scanline by scanline
  for i := 0 to H - 1 do
  begin
    cmsDoTransform(XForm, ABitmap.ScanLine[i], B.ScanLine[i], W);
  end;

  // Clean up
  ABitmap.Free;
  ABitmap := B;
  cmsDeleteTransform(XForm);
  cmsCloseProfile(HSrc);
  cmsCloseProfile(HDst);
  if assigned(Profile) then
    cmsCloseProfile(HPrf);
end;
{$ENDIF}

procedure TfrmMain.LoadMetadata;
var
  MD: TsdJpegMarkerList;
begin
  // EXIF and IPCT metadata
  MD := TsdJpegMarkerList.Create(nil);
  try
    FJpegImage.ExtractMetadata(MD);

  finally
    MD.Free;
  end;
end;

procedure TfrmMain.mnuClearClick(Sender: TObject);
begin
  imMain.Picture.Bitmap := nil;
end;

end.
