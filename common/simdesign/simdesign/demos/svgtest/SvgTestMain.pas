{ svg test mainform

  Creation Date:
  03apr2010

  Author: Nils Haeck M.Sc.
  Copyright (c) 2010 - 2011 SimDesign B.V.
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.
}
unit SvgTestMain;

{.$define usePicturePreview} // undefine to allow easier debugging
{$define sourcepos}

interface

uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, ShellAPI,
  Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls, sdFileList, ExtDlgs,
  NativeXml, NativeSvg, Pyro, pgRasterJpg,

  //synedit
  SynEdit, SynEditHighlighter, SynHighlighterHtml, SynMemo;

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
    mnuSaveAs: TMenuItem;
    btnLeft: TButton;
    btnRight: TButton;
    lbCount: TLabel;
    mnuOptions: TMenuItem;
    mnuDebugOutput: TMenuItem;
    SynHTMLSyn1: TSynHTMLSyn;
    pcMain: TPageControl;
    tsImage: TTabSheet;
    scbImage: TScrollBox;
    imImage: TImage;
    tsText: TTabSheet;
    seText: TSynEdit;
    PageControl1: TPageControl;
    tsDebug: TTabSheet;
    mmDebug: TMemo;
    mnuWsInfo: TMenuItem;
    mnuWsHint: TMenuItem;
    mnuWsWarn: TMenuItem;
    mnuWsFail: TMenuItem;
    mnuSavetoBitmap: TMenuItem;
    procedure mnuExitClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure mnuDebugOutputClick(Sender: TObject);
    procedure mnuWsInfoClick(Sender: TObject);
    procedure mnuSavetoBitmapClick(Sender: TObject);
  private
    FSvgGraphic: TsdSvgGraphic;
    FList: TsdFileList;
    FListIdx: integer;
    FIWarnStyles: integer;

    procedure LoadSvgFile(const AFileName: string);
    procedure SaveSvgFile(const AFileName: string);
    procedure SvgDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
    procedure wmDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FSvgGraphic := TsdSvgGraphic.Create;
  FSvgGraphic.OnDebugOut := SvgDebug;
  FList := TsdFileList.Create;

  // Accept dropped files (ShellAPI)
  DragAcceptFiles(handle, true);
  mnuWsInfoClick(nil);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FList);
  FreeAndNil(FSvgGraphic);
end;

procedure TfrmMain.SvgDebug(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if ((1 shl ord(WarnStyle)) and FIWarnStyles) <> 0 then
  begin
    mmDebug.Lines.Add(sdDebugMessageToString(Sender, WarnStyle, AMessage));
  end;
end;

procedure TfrmMain.LoadSvgFile(const AFileName: string);
var
  Folder: string;
begin
  if mnuDebugOutput.Checked then
    FSvgGraphic.OnDebugOut := SvgDebug
  else
    FSvgGraphic.OnDebugOut := nil;

  sbMain.SimpleText := Format('Loading %s...', [AFileName]);
  // Folder containing this file
  Folder := IncludeTrailingPathDelimiter(ExtractFileDir(AFileName));

  // Scan the selected folder for jpeg files, so the back/forward buttons can
  // be used to browse through
  if (FList.Count = 0) or (FListIdx = -1) then
  begin
    FList.Clear;
    FList.Scan(Folder, '*.svg', False);
    FListIdx := FList.IndexByName(AFileName);
  end;

  mmDebug.Clear;

  FSvgGraphic.LoadFromFile(AFileName);
  //FSvgGraphic.SaveToFile('C:\temp\test.svg');
  
  // Assign the svg property to the image.picture.bitmap
  imImage.Picture.Bitmap.Assign(FSvgGraphic);

  // synedit also wants the file
  seText.Lines.LoadFromFile(AFileName);

  // Update GUI elements
  Caption := Format('%s [%dx%d]', [AFileName, FSvgGraphic.Width, FSvgGraphic.Height]);

  lbCount.Caption := Format('%d/%d', [FListIdx + 1, FList.Count]);

  sbMain.SimpleText := sbMain.SimpleText + ' Done.';
end;

procedure TfrmMain.SaveSvgFile(const AFileName: string);
begin
  FSvgGraphic.SaveToFile(AFileName);
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuOpenClick(Sender: TObject);
begin
{$ifdef usePicturePreview}
  with TOpenPictureDialog.Create(nil) do
{$else usePicturePreview}
  with TOpenDialog.Create(nil) do  // this is easier to debug
{$endif usePicturePreview}
    try
      Filter := 'Svg files|*.svg';
      if Execute then
      begin
        FListIdx := -1;
        LoadSvgFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.mnuSaveAsClick(Sender: TObject);
begin
  with TSavePictureDialog.Create(nil) do
    try
      Filter := 'Svg files|*.svg';
      if Execute then
      begin
        SaveSvgFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.mnuSavetoBitmapClick(Sender: TObject);
begin
  with TSavePictureDialog.Create(nil) do
    try
      Filter := 'Bitmap files|*.bmp';
      if Execute then
      begin
        FSvgGraphic.Bitmap.SaveToFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.btnLeftClick(Sender: TObject);
begin
  if FListIdx = 0 then
    FListIdx := FList.Count - 1
  else
    dec(FListIdx);
  LoadSvgFile(FList[FListIdx].FullName);
end;

procedure TfrmMain.btnRightClick(Sender: TObject);
begin
  if FListIdx >= FList.Count - 1 then
    FListIdx := 0
  else
    inc(FListIdx);
  LoadSvgFile(FList[FListIdx].FullName);
end;

procedure TfrmMain.mnuDebugOutputClick(Sender: TObject);
begin
  mnuDebugOutput.Checked := not mnuDebugOutput.Checked;
end;

procedure TfrmMain.wmDropFiles(var Msg: TWMDropFiles);
var
  FileName: array[0..255] of char;
begin
  // Get filename of dropped file
  DragQueryFile(Msg.Drop, 0, FileName, 254);
  // allow another folder
  FList.Clear;
  // Open the file
  LoadSvgFile(FileName);
end;

procedure TfrmMain.mnuWsInfoClick(Sender: TObject);
begin
  // debug warn levels
  FIWarnStyles := 0;
  if mnuWsInfo.Checked then
    inc(FIWarnStyles, 1);
  if mnuWsHint.Checked then
    inc(FIWarnStyles, 2);
  if mnuWsWarn.Checked then
    inc(FIWarnStyles, 4);
  if mnuWsFail.Checked then
    inc(FIWarnStyles, 8);
end;

end.
