{ unit viewer32Main;

  Small viewer that uses NativeJpg to view Jpeg files in TBitmap32. This code uses
  Graphics-compatible TsdJpegGraphic. Under the hood, it uses the
  platform-independent TsdJpegImage (sdJpegImage.pas).

  Author: Nils Haeck M.Sc.
  Creation Date: 21apr2007
  Modified: 15jun2011 - use for TBitmap32
  Copyright (c) 2007 - 2011 SimDesign B.V.
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.
}
unit viewer32Main;

{$i simdesign.inc}

{$define DEPRECATEDMODE} // for GR32

interface

uses
  GR32, GR32_Image, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls, ExtDlgs,

  // additional
  sdFileList,

  // metadata
  sdMetadata, sdMetadataExif, sdMetadataIptc, sdMetadataJpg, sdMetadataCiff,
  NativeXml,

  // nativejpg
  NativeJpg32, sdJpegImage, sdJpegTypes, sdJpegMarkers, sdJpegLossless, sdDebug;

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
    mnuTiledDrawing: TMenuItem;
    PageControl1: TPageControl;
    tsImage: TTabSheet;
    scbMain: TScrollBox;
    tsMetadata: TTabSheet;
    reMetadata: TRichEdit;
    mnuReload: TMenuItem;
    mnuClearOutput: TMenuItem;
    mnuRotateFromExif: TMenuItem;
    mnuConvertFromBitmap: TMenuItem;
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuRotate90Click(Sender: TObject);
    procedure mnuRotate180Click(Sender: TObject);
    procedure mnuRotate270Click(Sender: TObject);
    procedure mnuFliphorizontalClick(Sender: TObject);
    procedure mnuFlipverticalClick(Sender: TObject);
    procedure mnuTransposeClick(Sender: TObject);
    procedure mnuOpenDiv2Click(Sender: TObject);
    procedure mnuCropClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure mnuTouchClick(Sender: TObject);
    procedure mnuDebugOutputClick(Sender: TObject);
    procedure mnuExtractICCClick(Sender: TObject);
    procedure mnuInjectICCClick(Sender: TObject);
    procedure mnuReloadClick(Sender: TObject);
    procedure mnuClearOutputClick(Sender: TObject);
    procedure mnuTiledDrawingClick(Sender: TObject);
    procedure mnuConvertFromBitmapClick(Sender: TObject);
  private
    FJpgGraphic32: TsdJpegGraphic32;
    imMain: TImage32;
    FJpgFileName: string;
    FList: TsdFileList;
    FListIdx: integer;
    procedure LoadJpegFile(const AFileName: string);
    procedure SaveJpegFile(const AFileName: string);
    procedure JpegDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
    procedure LoadMetadata;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FJpgGraphic32 := TsdJpegGraphic32.Create;
  FJpgGraphic32.OnDebugOut := JpegDebug;
  FList := TsdFileList.Create;
  // runtime creation to avoid installing design time
  imMain := TImage32.Create(Self);
  imMain.AutoSize := True;
  scbMain.InsertControl(imMain);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  imMain.Free;
  FreeAndNil(FList);
end;

procedure TfrmMain.JpegDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  mmDebug.Lines.Add(sdDebugMessageToString(Sender, WarnStyle, AMessage));
end;

procedure TfrmMain.LoadJpegFile(const AFileName: string);
var
  Folder: string;
  MS: TMemoryStream;
begin
  Screen.Cursor := crHourglass;
  try
    sbMain.SimpleText := Format('Loading %s...', [AFileName]);
    // Folder containing this file
    Folder := IncludeTrailingBackslash(ExtractFileDir(AFileName));

    // Scan the selected folder for jpeg files, so the back/forward buttons in
    // the app can be used to browse
    if (FList.Count = 0) or (FListIdx = -1) then
    begin
      FList.Clear;
      FList.Scan(Folder, '*.jpg', False);
      FListIdx := FList.IndexByName(AFileName);
    end;

    mmDebug.Clear;
    MS := TMemoryStream.Create;
    try
      FJpgFileName := AFileName;
      MS.LoadFromFile(FJpgFileName);
      MS.Position := 0;
      try
        FJpgGraphic32.LoadFromStream(MS);
      except
        on E: Exception do
          ShowMessage(E.Message);
      end;

      // Assign the jpeg bitmap property to the imMain.bitmap.
      // under the hood, this calls TsdJpegGraphic.AssignTo()
      imMain.Bitmap.Assign(FJpgGraphic32);

      // load the metadata
      LoadMetadata;

      sbMain.SimpleText := Format('Finished %s', [AFileName]);

    finally
      MS.Free;
    end;

    // Update GUI elements
    Caption := Format('%s [%dx%d]', [AFileName, FJpgGraphic32.Width, FJpgGraphic32.Height]);
    lbCount.Caption := Format('%d/%d', [FListIdx + 1, FList.Count]);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.SaveJpegFile(const AFileName: string);
begin
  FJpgGraphic32.SaveToFile(AFileName);
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuOpenClick(Sender: TObject);
var
  OD: TOpenDialog;
begin
  OD := TOpenDialog.Create(nil);  // this is easier to debug
  try
    OD.Filter := 'Jpeg files|*.jpg';
    if OD.Execute then
    begin
      FListIdx := -1;
      FJpgGraphic32.Scale := jsFull;
      LoadJpegFile(OD.FileName);
    end;
  finally
    OD.Free;
  end;
end;

procedure TfrmMain.mnuReloadClick(Sender: TObject);
begin
  LoadJpegFile(FList[FListIdx].FullName);
end;

procedure TfrmMain.mnuOpenDiv2Click(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do  // this is easier to debug
    try
      Filter := 'Jpeg files|*.jpg';
      if Execute then
      begin
        FListIdx := -1;
        FJpgGraphic32.Scale := jsDiv2;
        LoadJpegFile(FileName);
      end;
    finally
      Free;
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

procedure TfrmMain.mnuRotate90Click(Sender: TObject);
begin
  FJpgGraphic32.Image.Lossless.Rotate90;
  imMain.Bitmap.Assign(FJpgGraphic32);
end;

procedure TfrmMain.mnuRotate180Click(Sender: TObject);
begin
  FJpgGraphic32.Image.Lossless.Rotate180;
  imMain.Bitmap.Assign(FJpgGraphic32);
end;

procedure TfrmMain.mnuRotate270Click(Sender: TObject);
begin
  FJpgGraphic32.Image.Lossless.Rotate270;
  imMain.Bitmap.Assign(FJpgGraphic32);
end;

procedure TfrmMain.mnuFliphorizontalClick(Sender: TObject);
begin
  FJpgGraphic32.Image.Lossless.FlipHorizontal;
  imMain.Bitmap.Assign(FJpgGraphic32);
end;

procedure TfrmMain.mnuFlipverticalClick(Sender: TObject);
begin
  FJpgGraphic32.Image.Lossless.FlipVertical;
  imMain.Bitmap.Assign(FJpgGraphic32);
end;

procedure TfrmMain.mnuTransposeClick(Sender: TObject);
begin
  FJpgGraphic32.Image.Lossless.Transpose;
  imMain.Bitmap.Assign(FJpgGraphic32);
end;

procedure TfrmMain.mnuCropClick(Sender: TObject);
var
  W, H, L, T, R, B: integer;
begin
  W := FJpgGraphic32.Width;
  H := FJpgGraphic32.Height;
  L := round(0.1 * W);
  T := round(0.1 * H);
  R := round(0.9 * W);
  B := round(0.9 * H);
  FJpgGraphic32.Image.Lossless.Crop(L, T, R, B);
  imMain.Bitmap.Assign(FJpgGraphic32);
end;

procedure TfrmMain.mnuTouchClick(Sender: TObject);
begin
  FJpgGraphic32.Image.Lossless.Touch;
  imMain.Bitmap.Assign(FJpgGraphic32);
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
    FJpgGraphic32.OnDebugOut := JpegDebug
  else
    FJpgGraphic32.OnDebugOut := nil;
end;

procedure TfrmMain.mnuTiledDrawingClick(Sender: TObject);
begin
  mnuTiledDrawing.Checked := not mnuTiledDrawing.Checked;
  FJpgGraphic32.UseTiledDrawing := mnuTiledDrawing.Checked;
end;

procedure TfrmMain.mnuExtractICCClick(Sender: TObject);
// Save the ICC profile that is embedded in the jpeg to a file
var
  Profile: TsdJpegICCProfile;
  SD: TSaveDialog;
begin
  Profile := FJpgGraphic32.Image.ICCProfile;
  if assigned(Profile) then
  begin
    SD := TSaveDialog.Create(nil);
    try
      SD.Title := 'Save ICC profile';
      SD.Filter := 'ICC profiles (*.icm)|*.icm';
      if SD.Execute then
      begin
        Profile.SaveToFile(SD.FileName);
      end;
    finally
      SD.Free;
    end;
  end else
  begin
    ShowMessage('No ICC profile found in this Jpeg');
  end;
end;

procedure TfrmMain.mnuInjectICCClick(Sender: TObject);
var
  Profile: TsdJpegICCProfile;
  OD: TOpenDialog;
begin
  Profile := TsdJpegICCProfile.Create;
  try
    OD := TOpenDialog.Create(nil);
    try
      OD.Title := 'Load ICC profile';
      OD.Filter := 'ICC profiles (*.icm)|*.icm';
      if OD.Execute then
      begin
        Profile.LoadFromFile(OD.FileName);
        FJpgGraphic32.Image.ICCProfile := Profile;
        ShowMessage(Format('Profile is injected in the Jpeg (%d bytes)', [Profile.DataLength]));
      end;
    finally
      OD.Free;
    end;
  finally
    Profile.Free;
  end;
end;

procedure TfrmMain.LoadMetadata;
var
  Xml: TNativeXml;
  DataStream: TMemoryStream;
begin
  // EXIF and IPCT metadata
  Xml := TNativeXml.CreateName('metadata');
  try
    DataStream := TMemoryStream.Create;
    try
      DataStream.LoadFromFile(FJpgFileName);
      DataStream.Position := 0;
      sdReadMetadata(DataStream, 0, Xml.Root, False, JpegDebug);
      Xml.XmlFormat := xfReadable;
      Xml.IndentString := '  ';

      reMetadata.Lines.Clear;
      reMetadata.Lines.Add(Xml.Root.WriteToString);
    finally
      DataStream.Free;
    end;
  finally
    Xml.Free;
  end;

end;

procedure TfrmMain.mnuClearOutputClick(Sender: TObject);
begin
  mmDebug.Lines.Clear;
end;

procedure TfrmMain.mnuConvertFromBitmapClick(Sender: TObject);
var
  Bitmap32: TBitmap32;
begin
  with TOpenDialog.Create(nil) do  // this is easier to debug
    try
      Filter := 'Bitmap files|*.bmp';
      if Execute then
      begin
        Bitmap32 := TBitmap32.Create;
        try
          Bitmap32.LoadFromFile(FileName);
          FListIdx := -1;
          FJpgGraphic32.Assign(Bitmap32);
        finally
          Bitmap32.Free;
        end;
        //
        imMain.Bitmap.Assign(FJpgGraphic32);
      end;
    finally
      Free;
    end;
end;

end.
