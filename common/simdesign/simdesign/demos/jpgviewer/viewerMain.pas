{ unit viewerMain;

  Small viewer that uses NativeJpg to view Jpeg files. This code uses
  Graphics-compatible TsdJpegGraphic. Under the hood, it uses the
  platform-independent TsdJpegImage (sdJpegImage.pas).

  Author: Nils Haeck M.Sc.
  Creation Date: 21apr2007
  Copyright (c) 2007 - 2011 SimDesign B.V.
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.
}
unit viewerMain;

{$i simdesign.inc}

// enable this if you want to use picture preview in open dialogs
{.$define usePicturePreview}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls, ExtDlgs,

  // additional
  sdFileList, ShellAPI,

  // metadata
  sdMetadata, sdMetadataExif, sdMetadataIptc, sdMetadataJpg, sdMetadataCiff,
  NativeXml,

  // nativejpg
  NativeJpg, sdJpegImage, sdJpegTypes, sdJpegMarkers, sdJpegLossless, sdDebug;

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
    mnuTiledDrawing: TMenuItem;
    PageControl1: TPageControl;
    tsImage: TTabSheet;
    scbMain: TScrollBox;
    imMain: TImage;
    tsMetadata: TTabSheet;
    reMetadata: TRichEdit;
    mnuReload: TMenuItem;
    mnuClearOutput: TMenuItem;
    mnuRotateFromExif: TMenuItem;
    mnuConvertFromBitmap: TMenuItem;
    mnuSaveDebugInfo: TMenuItem;
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
    procedure mnuOpenDiv4Click(Sender: TObject);
    procedure mnuOpenDiv8Click(Sender: TObject);
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
    procedure mnuRotateFromExifClick(Sender: TObject);
    procedure mnuConvertFromBitmapClick(Sender: TObject);
    procedure mnuAssignClick(Sender: TObject);
    procedure mnuSaveDebugInfoClick(Sender: TObject);
  private
    FJpgGraphic: TsdJpegGraphic;
    FJpgFileName: string;
    FList: TsdFileList;
    FListIdx: integer;
    procedure LoadJpegFile(const AFileName: string);
    procedure SaveJpegFile(const AFileName: string);
    procedure JpegDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
    procedure LoadMetadata;
    procedure wmDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FJpgGraphic := TsdJpegGraphic.Create;
  FJpgGraphic.OnDebugOut := JpegDebug;
  FList := TsdFileList.Create;

  // Accept dropped files (ShellAPI)
  DragAcceptFiles(handle, true);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
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
        FJpgGraphic.LoadFromStream(MS);
      except
        on E: Exception do
          ShowMessage(E.Message);
      end;

      // Assign the jpeg bitmap property to the image.picture.bitmap.
      // under the hood, this calls TsdJpegGraphic.AssignTo()
      imMain.Picture.Bitmap.Assign(FJpgGraphic);

      // load the metadata
      LoadMetadata;

      sbMain.SimpleText := Format('Finished %s', [AFileName]);

    finally
      MS.Free;
    end;

    // Update GUI elements
    Caption := Format('%s [%dx%d]', [AFileName, FJpgGraphic.Width, FJpgGraphic.Height]);
    lbCount.Caption := Format('%d/%d', [FListIdx + 1, FList.Count]);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.SaveJpegFile(const AFileName: string);
begin
  FJpgGraphic.SaveToFile(AFileName);
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuOpenClick(Sender: TObject);
var
{$ifdef usePicturePreview}
  OD: TOpenPictureDialog;
{$else}
  OD: TOpenDialog;
{$endif}
begin
{$ifdef usePicturePreview}
  OD := TOpenPictureDialog.Create(nil);
{$else}
  OD := TOpenDialog.Create(nil);  // this is easier to debug
{$endif}
  try
    OD.Filter := 'Jpeg files|*.jpg';
    if OD.Execute then
    begin
      FListIdx := -1;
      FJpgGraphic.Scale := jsFull;
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
{$ifdef usePicturePreview}
  with TOpenPictureDialog.Create(nil) do
{$else}
  with TOpenDialog.Create(nil) do  // this is easier to debug
{$endif}
    try
      Filter := 'Jpeg files|*.jpg';
      if Execute then
      begin
        FListIdx := -1;
        FJpgGraphic.Scale := jsDiv2;
        LoadJpegFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.mnuOpenDiv4Click(Sender: TObject);
begin
{$ifdef usePicturePreview}
  with TOpenPictureDialog.Create(nil) do
{$else}
  with TOpenDialog.Create(nil) do  // this is easier to debug
{$endif}
    try
      Filter := 'Jpeg files|*.jpg';
      if Execute then
      begin
        FListIdx := -1;
        FJpgGraphic.Scale := jsDiv4;
        LoadJpegFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.mnuOpenDiv8Click(Sender: TObject);
begin
{$ifdef usePicturePreview}
  with TOpenPictureDialog.Create(nil) do
{$else}
  with TOpenDialog.Create(nil) do  // this is easier to debug
{$endif}
    try
      Filter := 'Jpeg files|*.jpg';
      if Execute then
      begin
        FListIdx := -1;
        FJpgGraphic.Scale := jsDiv8;
        LoadJpegFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.mnuSaveAsClick(Sender: TObject);
begin
{$ifdef usePicturePreview}
  with TSavePictureDialog.Create(nil) do
{$else}
  with TSaveDialog.Create(nil) do
{$endif}
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

procedure TfrmMain.mnuRotateFromExifClick(Sender: TObject);
var
  Xml: TNativeXml;
  DataStream: TMemoryStream;
  Child: TXmlNode;
  // exif orientation data
  Node: TXmlNode;
  Value: Utf8String;
  Raw: Utf8String;
  NumVal: integer;
  Action: TsdLosslessAction;
  ActionString: Utf8String;
  Res: integer;
begin
  Action := laNoAction;
  NumVal := 0;

  Xml := TNativeXml.CreateName('root');
  try
    DataStream := TMemoryStream.Create;
    try
      DataStream.LoadFromFile(FJpgFileName);
      DataStream.Position := 0;
      sdReadMetadata(DataStream, 0, Xml.Root, True);
      Xml.XmlFormat := xfReadable;

      JpegDebug(Self, wsInfo, Xml.WriteToString);

      Child := Xml.Root.NodeByName('EXIF');
      if assigned(Child) then
      begin
        // Start position of EXIF info in the file
        //ChildSPos := StrToInt('$' + Child.AttributeByName['SPOS'].Value);
        // DateTime field
        Node := Child.NodeByName('Orientation');
        if assigned(Node) then
        begin
          //Error := 0;
          Value := Node.Value;
          // Stream position
          //SPos := SPos + StrToInt('$' + Node.AttributeByName['SPOS'].Value);
          // Raw value
          Raw := Node.AttributeByName['RDAT'].Value;
          // Bias in case RAW is longer than one byte
          //inc(SPos, length(Raw) div 2 - 1);
          // Get numeric value
          NumVal := StrToIntDef('$' + Raw, 0);
          // Some cameras put the value in the first byte (e.g. Canon A80)!
          if NumVal >= 256 then
            NumVal := NumVal div 256;
          // Decide what to do
          case NumVal of
          1: Action := laNoAction;
          2: Action := laFlipHor;
          3: Action := laRotate180;
          4: Action := laFlipVer;
          6: Action := laRotateRight;
          8: Action := laRotateLeft;
          end;//case
        end;
      end;

      ActionString := Format(
        'EXIF orientation setting (%d) determined this action: %s',
        [NumVal, cLosslessActionMsg[Action]]) + #13#13 +
        'Do you want to continue?';
      Res := MessageDlg(ActionString, mtConfirmation, mbOKCancel, 0);
      if Res = mrOK then
      begin

        case Action of
        laRotateLeft: FJpgGraphic.Image.Lossless.Rotate90;
        laRotate180: FJpgGraphic.Image.Lossless.Rotate180;
        laRotateRight: FJpgGraphic.Image.Lossless.Rotate270;
        end;

        // todo: must also reset the orientation flag in exif..

      end;
    finally
      DataStream.Free;
    end;

  finally
    Xml.Free;
  end;
end;

procedure TfrmMain.mnuRotate90Click(Sender: TObject);
begin
  FJpgGraphic.Image.Lossless.Rotate90;
  imMain.Picture.Bitmap.Assign(FJpgGraphic);
end;

procedure TfrmMain.mnuRotate180Click(Sender: TObject);
begin
  FJpgGraphic.Image.Lossless.Rotate180;
  imMain.Picture.Bitmap.Assign(FJpgGraphic);
end;

procedure TfrmMain.mnuRotate270Click(Sender: TObject);
begin
  FJpgGraphic.Image.Lossless.Rotate270;
  imMain.Picture.Bitmap.Assign(FJpgGraphic);
end;

procedure TfrmMain.mnuFliphorizontalClick(Sender: TObject);
begin
  FJpgGraphic.Image.Lossless.FlipHorizontal;
  imMain.Picture.Bitmap.Assign(FJpgGraphic);
end;

procedure TfrmMain.mnuFlipverticalClick(Sender: TObject);
begin
  FJpgGraphic.Image.Lossless.FlipVertical;
  imMain.Picture.Bitmap.Assign(FJpgGraphic);
end;

procedure TfrmMain.mnuTransposeClick(Sender: TObject);
begin
  FJpgGraphic.Image.Lossless.Transpose;
  imMain.Picture.Bitmap.Assign(FJpgGraphic);
end;

procedure TfrmMain.mnuCropClick(Sender: TObject);
var
  W, H, L, T, R, B: integer;
begin
  W := FJpgGraphic.Width;
  H := FJpgGraphic.Height;
  L := round(0.1 * W);
  T := round(0.1 * H);
  R := round(0.9 * W);
  B := round(0.9 * H);
  FJpgGraphic.Image.Lossless.Crop(L, T, R, B);
  imMain.Picture.Bitmap.Assign(FJpgGraphic);
end;

procedure TfrmMain.mnuTouchClick(Sender: TObject);
begin
  FJpgGraphic.Image.Lossless.Touch;
  imMain.Picture.Bitmap.Assign(FJpgGraphic);
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
    FJpgGraphic.OnDebugOut := JpegDebug
  else
    FJpgGraphic.OnDebugOut := nil;
end;

procedure TfrmMain.mnuTiledDrawingClick(Sender: TObject);
begin
  mnuTiledDrawing.Checked := not mnuTiledDrawing.Checked;
  FJpgGraphic.UseTiledDrawing := mnuTiledDrawing.Checked;
end;

procedure TfrmMain.mnuExtractICCClick(Sender: TObject);
// Save the ICC profile that is embedded in the jpeg to a file
var
  Profile: TsdJpegICCProfile;
  SD: TSaveDialog;
begin
  Profile := FJpgGraphic.Image.ICCProfile;
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
        FJpgGraphic.Image.ICCProfile := Profile;
        ShowMessage(Format('Profile is injected in the Jpeg (%d bytes)', [Profile.DataLength]));
      end;
    finally
      OD.Free;
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
  Bmp: TBitmap;
begin
{$ifdef usePicturePreview}
  with TOpenPictureDialog.Create(nil) do
{$else}
  with TOpenDialog.Create(nil) do  // this is easier to debug
{$endif}
    try
      Filter := 'Bitmap files|*.bmp';
      if Execute then
      begin
        Bmp := TBitmap.Create;
        try
          Bmp.LoadFromFile(FileName);
          FListIdx := -1;
          FJpgGraphic.Assign(Bmp);
        finally
          Bmp.Free;
        end;
        //
        imMain.Picture.Bitmap.Assign(FJpgGraphic);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.mnuAssignClick(Sender: TObject);
begin
//
end;

procedure TfrmMain.mnuSaveDebugInfoClick(Sender: TObject);
var
  Name: string;
  FS: TFileStream;
begin
  Name := ExtractFilePath(Application.ExeName) + 'debuginfo.txt';
  FS := TFileStream.Create(Name, fmCreate);
  try
    mmDebug.Lines.SaveToStream(FS);
  finally
    FS.Free;
    sbMain.SimpleText := Format('saved debug info %s', [Name]);
  end;
end;

end.
