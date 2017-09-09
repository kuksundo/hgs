{ Unit WebpageItems

  This unit implements the generation of web pages off items in ABC-View's collection.

  Modifications:
  23May2004: Added FrameOKClick check to see if something was generated

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit guiWebpageItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RxCombos, StdCtrls, RXSpin, ExtCtrls, rxToolEdit, Mask,
  Buttons, ComCtrls, BrowseTrees, ThumbItems, sdItems, Math, ShellAPI, jpeg,
  sdAbcVars, guiFilterFrame, sdAbcFunctions;

type
  TWebpageFrame = class(TFilterFrame)
    pcWebpage: TPageControl;
    tsGenerate: TTabSheet;
    Panel2: TPanel;
    chbGenerateHtml: TCheckBox;
    chbGenerateSheets: TCheckBox;
    chbGeneratePages: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox14: TCheckBox;
    Panel3: TPanel;
    chbThumbsGenerate: TCheckBox;
    chbThumbsSkipExisting: TCheckBox;
    pnlGenerateImages: TPanel;
    chbImagesGenerate: TCheckBox;
    chbImagesSkipExisting: TCheckBox;
    btnGenerate: TBitBtn;
    chbPreviewHtml: TCheckBox;
    tsHtmlSheet: TTabSheet;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    deSheetFolder: TDirectoryEdit;
    edSheetMask: TEdit;
    feSheetTemplate: TFilenameEdit;
    btnEditTemplate: TBitBtn;
    GroupBox15: TGroupBox;
    rbSheetAltDescr: TCheckBox;
    GroupBox17: TGroupBox;
    Label31: TLabel;
    pbThumbnails: TPaintBox;
    Label32: TLabel;
    lbThumbCount: TLabel;
    Label36: TLabel;
    lbSheetCount: TLabel;
    Label23: TLabel;
    seThumbRows: TRxSpinEdit;
    seThumbCols: TRxSpinEdit;
    rbThumbsAsTable: TRadioButton;
    rbThumbsAsImage: TRadioButton;
    GroupBox21: TGroupBox;
    rbThumbLinkImage: TRadioButton;
    rbThumbLinkPage: TRadioButton;
    TabSheet2: TTabSheet;
    lbThumbFolder: TLabel;
    deThumbFolder: TDirectoryEdit;
    gbThumbSize: TGroupBox;
    Label27: TLabel;
    Label28: TLabel;
    seThumbMaxWidth: TRxSpinEdit;
    seThumbMaxHeight: TRxSpinEdit;
    gbThumbOptions: TGroupBox;
    lbBevelType: TLabel;
    lbBevelWidth: TLabel;
    chbThumbAddBevel: TCheckBox;
    cbbBevelType: TComboBox;
    seBevelWidth: TRxSpinEdit;
    chbThumbHQSamp: TCheckBox;
    GroupBox14: TGroupBox;
    lbThumbQual: TLabel;
    rbThumbFormatGif: TRadioButton;
    rbThumbFormatJpg: TRadioButton;
    chbThumbAdjustQual: TCheckBox;
    seThumbAdjustVal: TRxSpinEdit;
    rbThumbFormatLink: TRadioButton;
    tsHtmlImage: TTabSheet;
    Label24: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    dePageFolder: TDirectoryEdit;
    edPageMask: TEdit;
    fePageTemplate: TFilenameEdit;
    BitBtn2: TBitBtn;
    GroupBox20: TGroupBox;
    rbLinkNextImage: TRadioButton;
    rbLinkRandomImage: TRadioButton;
    rbLinkOrigImage: TRadioButton;
    rbLinkIndex: TRadioButton;
    rbNoLink: TRadioButton;
    TabSheet3: TTabSheet;
    lbImageFolder: TLabel;
    deImageFolder: TDirectoryEdit;
    GroupBox16: TGroupBox;
    lbImageQual: TLabel;
    rbImageFormatJpg: TRadioButton;
    rbImageFormatLink: TRadioButton;
    chbImageAdjustQual: TCheckBox;
    seImageAdjustVal: TRxSpinEdit;
    gbImageSize: TGroupBox;
    Label33: TLabel;
    Label34: TLabel;
    seImageMaxWidth: TRxSpinEdit;
    seImageMaxHeight: TRxSpinEdit;
    gbImageOptions: TGroupBox;
    Label35: TLabel;
    Label22: TLabel;
    chbImageHQSamp: TCheckBox;
    chbImageAddFrame: TCheckBox;
    cbbImageAddFrameCol: TColorComboBox;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Edit4: TEdit;
    Button2: TButton;
    RxSpinEdit1: TRxSpinEdit;
    TabSheet1: TTabSheet;
    GroupBox11: TGroupBox;
    edWebTitle: TEdit;
    imgThumb: TImage;
    procedure pbThumbnailsPaint(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure WebPageChange(Sender: TObject);
  private
  public
    procedure DlgToFilter; override;
    procedure FilterToDlg; override;
    procedure FrameOKClick; override;
    procedure ValidateTabs(Sender: TObject);
  end;

  TWebPageItem = class(TBrowseItem)
  private
    FImageFolder: string;
    FThumbsPerPage: integer;
    FThumbs: TThumbMngr;
    FThumbFolder: string;
  protected
    procedure SetImageFolder(AFolder: string);
    procedure SetThumbFolder(AFolder: string);
  public
    FHasGenerated: boolean;
    FGenerateHtml: boolean;
    FGenerateSheets: boolean;
    FGeneratePages: boolean;
    FImageAddFrame: boolean;
    FImageAddFrameCol: TColor;
    FImageAdjustQual: boolean;
    FImageAdjustVal: integer;
    FImageFormat: integer;
    FImageHQSamp: boolean;
    FImageMaxWidth,
    FImageMaxHeight: integer;
    FImagesGenerate,
    FImagesGenerateAll: boolean;
    FPageFolder: string;
    FPageTemplate: string;
    FPageMask: string;
    FPageLinkType: integer;
    FPreviewHtml: boolean;
    FSheetFolder: string;
    FSheetTemplate: string;
    FSheetMask: string;
    FSheetAltDescr: boolean;
    FThumbAdjustQual: boolean;
    FThumbAdjustVal: integer;
    FThumbCols: integer;
    FThumbFormat: integer;
    FThumbHQSamp: boolean;
    FThumbLink: integer;
    FThumbMaxWidth,
    FThumbMaxHeight: integer;
    FThumbRows: integer;
    FThumbsAsImage: boolean;
    FThumbsAsTable: boolean;
    FThumbsGenerate,
    FThumbsGenerateAll: boolean;
    FWebTitle: string;
    destructor Destroy; override;
    property ImageFolder: string read FImageFolder write SetImageFolder;
    property Thumbs: TThumbMngr read FThumbs;
    property ThumbFolder: string read FThumbFolder write SetThumbFolder;
    procedure CreateFilterParams; override;
    procedure FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean); virtual;
    procedure GenerateWebPage;
  end;

implementation

uses
  guiFeedback, guiMain, Filters, ImageProcessors, sdRoots, {$warnings off}FileCtrl,{$warnings on}
  Links, {Utils,} guiOptions;

const

  // Constants that are used inside HTML templates
  cDate         = '{Date}';
  cDescription  = '{Description}';
  cImage        = '{Image}';
  cImageName    = '{ImageName}';
  cImageTitle   = '{ImageTitle}';
  cPagePeerHor  = '{PagePeerHor}';
  cPagePrev     = '{PagePrev}';
  cPageNext     = '{PageNext}';
  cPageSheet    = '{PageSheet}';
  cSheetTitle   = '{SheetTitle}';
  cSheetPeerHor = '{SheetPeerHor}';
  cSheetPrev    = '{SheetPrev}';
  cSheetNext    = '{SheetNext}';
  cThumbnails   = '{Thumbnails}';


{$R *.DFM}

{ TWebPageFrame }

procedure TWebPageFrame.DlgToFilter;
begin
  with TWebPageItem(Item) do
  begin
    // Generate
    FGenerateHtml := chbGenerateHtml.Checked;
    FGenerateSheets := chbGenerateSheets.Checked;
    FGeneratePages := chbGeneratePages.Checked;
    FPreviewHtml := chbPreviewHtml.Checked;
    FThumbsGenerate := chbThumbsGenerate.Checked;
    FThumbsGenerateAll := not chbThumbsSkipExisting.Checked;
    FImagesGenerate := chbImagesGenerate.Checked;
    FImagesGenerateAll := not chbImagesSkipExisting.Checked;
    // Html Sheet
    FSheetFolder := IncludeTrailingPathDelimiter(deSheetFolder.Text);
    FSheetTemplate := feSheetTemplate.Text;
    FSheetMask := edSheetMask.Text;
    FThumbCols := round(seThumbCols.Value);
    FThumbRows := round(seThumbRows.Value);
    FThumbsAsTable := rbThumbsAsTable.Checked;
    FThumbsAsImage := rbThumbsAsImage.Checked;
    if rbThumbLinkImage.Checked then
      FThumbLink := 0;
    if rbThumbLinkPage.Checked then
      FThumbLink := 1;
    FSheetAltDescr := rbSheetAltDescr.Checked;
    // Thumbnails
    ThumbFolder := IncludeTrailingPathDelimiter(deThumbFolder.Text);
    FThumbHQSamp := chbThumbHQSamp.Checked;
    FThumbMaxWidth  := round(seThumbMaxWidth.Value);
    FThumbMaxHeight := round(seThumbMaxHeight.Value);
    FThumbAdjustQual := chbThumbAdjustQual.Checked;
    FThumbAdjustVal  := round(seThumbAdjustVal.Value);
    if rbThumbFormatLink.Checked = True then
      FThumbFormat := 0;
    if rbThumbFormatGif.Checked = True then
      FThumbFormat := 1;
    if rbThumbFormatJpg.Checked = True then
      FThumbFormat := 2;
    // Html Page
    FPageFolder := IncludeTrailingPathDelimiter(dePageFolder.Text);
    FPageTemplate := fePageTemplate.Text;
    FPageMask := edPageMask.Text;
    if rbNoLink.Checked then
      FPageLinkType := 0;
    if rbLinkNextImage.Checked then
      FPageLinkType := 1;
    if rbLinkRandomImage.Checked then
      FPageLinkType := 2;
    if rbLinkOrigImage.Checked then
      FPageLinkType := 3;
    if rbLinkIndex.Checked then
      FPageLinkType := 4;
    // Images
    ImageFolder := IncludeTrailingPathDelimiter(deImageFolder.Text);
    FImageAddFrame := chbImageAddFrame.Checked;
    FImageAddFrameCol := cbbImageAddFrameCol.ColorValue;
    FImageHQSamp := chbImageHQSamp.Checked;
    FImageMaxWidth  := round(seImageMaxWidth.Value);
    FImageMaxHeight := round(seImageMaxHeight.Value);
    if rbImageFormatLink.Checked = True then
      FImageFormat := 0;
    if rbImageFormatJpg.Checked = True
      then FImageFormat := 1;
    FImageAdjustQual := chbImageAdjustQual.Checked;
    FImageAdjustVal  := round(seImageAdjustVal.Value);
    // Titles
    FWebTitle := edWebTitle.Text;

    pcWebpage.ActivePage := tsGenerate;
  end;
end;

procedure TWebPageFrame.FilterToDlg;
begin
  with TWebPageItem(Item) do
  begin
    FHasGenerated := False;
    // Generate
    chbPreviewHtml.Checked := FPreviewHtml;
    // Html Sheet
    deSheetFolder.Text := FSheetFolder;
    if length(FSheetTemplate) = 0 then
      FSheetTemplate := FAppFolder + 'templates\sheet.html';
    feSheetTemplate.Text := FSheetTemplate;
    // Thumbnails
    deThumbFolder.Text := ThumbFolder;
    // Html Page
    if length(FPageTemplate) = 0 then
      FPageTemplate := FAppFolder + 'templates\image.html';
    fePageTemplate.Text := FPageTemplate;
    // Images
    deImageFolder.Text := ImageFolder;
    // Titles
    edWebTitle.Text := FWebTitle;
    // Do the validation
    ValidateTabs(Self);
  end;
end;

procedure TWebPageFrame.pbThumbnailsPaint(Sender: TObject);
var
  r, c: integer;
  DeltaX: double;
  DeltaY: double;
begin
  // Paint an impression of the thumbnail sheet
  with pbThumbnails do
  begin
    DeltaX := Width  / (seThumbCols.Value + 1);
    DeltaY := Height / (seThumbRows.Value + 1);
    with Canvas do
    begin
      Pen.Color := clBlack;
      Brush.Style := bsSolid;
      Brush.Color := clWhite;
      // Background
      Rectangle(0, 0, Width, Height);
      // Paint impression of R x C thumbnails
      for r := 0 to round(seThumbRows.Value) - 1 do
        for c := 0 to round(seThumbCols.Value) - 1 do
        begin
          StretchDraw(
            Rect(
              round((DeltaX / 2) + 1 + c * DeltaX),
              round((DeltaY / 2) + 1 + r * DeltaY),
              round((DeltaX / 2) - 1 + (c + 1) * DeltaX),
              round((DeltaY / 2) - 1 + (r + 1) * DeltaY)
              ), imgThumb.Picture.Graphic);
        end;
    end;
  end;
end;

procedure TWebPageFrame.ValidateTabs(Sender: TObject);
var
  Vis: boolean;
  ThumbCount: integer;
begin
  // Generate
  chbGeneratePages.Visible := rbThumbLinkPage.Checked;
  pnlGenerateImages.Visible := not rbImageFormatLink.Checked;

  // Html Sheet
  pbThumbnails.Invalidate;
  ThumbCount := round(seThumbRows.Value * seThumbCols.Value);
  lbThumbCount.Caption := IntToStr(ThumbCount);
  try
    lbSheetCount.Caption := IntToStr((TWebPageItem(Item).Thumbs.ThumbCount + ThumbCount - 1) div ThumbCount);
  except
    // div by 0 or other errors
    lbSheetCount.Caption := '0';
  end;

  tsHtmlImage.TabVisible := rbThumbLinkPage.Checked;

  // Thumbnails
  lbBevelType.Visible := chbThumbAddBevel.Checked;
  cbbBevelType.Visible := chbThumbAddBevel.Checked;
  lbBevelWidth.Visible := chbThumbAddBevel.Checked;
  seBevelWidth.Visible := chbThumbAddBevel.Checked;
  Vis := not rbThumbFormatLink.Checked;
  lbThumbFolder.Visible := Vis;
  deThumbFolder.Visible := Vis;
  gbThumbSize.Visible := Vis;
  gbThumbOptions.Visible := Vis;
  lbThumbQual.Visible := chbThumbAdjustQual.Checked;
  seThumbAdjustVal.Visible := chbThumbAdjustQual.Checked;

  // Images
  Vis := not rbImageFormatLink.Checked;
  lbImageFolder.Visible := Vis;
  deImageFolder.Visible := Vis;
  gbImageSize.Visible := Vis;
  gbImageOptions.Visible := Vis;
  lbImageQual.Visible := chbImageAdjustQual.Checked;
  seImageAdjustVal.Visible := chbImageAdjustQual.Checked;
end;


{ TWebPageItem }

procedure TWebPageItem.SetImageFolder(AFolder: string);
begin
  if FImageFolder <> AFolder then
  begin
    if assigned(Thumbs) then Thumbs.ImageFolder := AFolder;
    // New folder name
    FImageFolder := AFolder;
  end;
end;

procedure TWebPageItem.SetThumbFolder(AFolder: string);
begin
  if FThumbFolder <> AFolder then
  begin
    if assigned(Thumbs) then Thumbs.ThumbFolder := AFolder;
    // New folder name
    FThumbFolder := AFolder;
  end;
end;

procedure TWebPageItem.CreateFilterParams;
begin
  Options := Options + [biAllowRename, biAllowRemove];
  // Defaults
  Caption := 'Web Page';
  ImageIndex := 20;
  FPreviewHtml := True;

  DialogCaption := 'Build-a-Web';
  DialogIcon := 15;

  // Thumbnails
  FThumbs := TThumbMngr.Create;

  // add a normal filter with OnAcceptItem connected to SelectionItem
  Filter := TFilter.Create;
  with TFilter(Filter) do
  begin
    ExpandedSelection := False;
    OnAcceptItem := FilterAcceptItem;
    AddNode(Thumbs);
  end;

  // Set frame class
  FrameClass := TWebpageFrame;
end;

destructor TWebPageItem.Destroy;
begin
  if assigned(Filter) and assigned(Filter.Parent) then
    Filter.Parent.DisconnectAll;
  inherited;
end;

procedure TWebPageItem.FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean);
begin
  Accept := False;
  if assigned(Item) and (Item.ItemType = itFile) then
    Accept := True;
end;

procedure TWebPageItem.GenerateWebPage;
var
  i, r, c,
  ThumbIdx,
  SheetNum,
  Rnd,
  NumPages: integer;
  ImageGen, ThumbGen: TImageProcessor;
  Template,
  Sheet,
  Page,
  Html,
  ThumbLink,
  ImageLink,
  OrigLink,
  SheetLink,
  FileName,
  Second,
  CellSizeReq,
  FOrig, FDest,
  Anchor, Alt, Tmp,
  PreviewAddress: string;
  Links, RndLinks,
  FileList: TStrings;
  S: TStream;
  AFile: TsdFile;
begin
  // Checks
  if not assigned(Filter) then
    exit;
  FThumbsPerPage := FThumbCols * FThumbRows;
  if FThumbsPerPage <= 0 then
    exit;

  FHasGenerated := True;

  // Copy some stuff to ThumbMngr
  Thumbs.ThumbFormat := FThumbFormat;
  Thumbs.ImageFormat := FImageFormat;

  // Lock the root
  frmMain.Root.LockRead;
  Links := TStringList.Create;
  RndLinks := TStringList.Create;
  Feedback.Start;
  try
    with Thumbs do
    begin
      // add tasks to display
      if FThumbsGenerate then
        if FThumbsGenerateAll then
          Feedback.Add(Format('Create %d thumbnails', [ThumbCount]))
        else
          Feedback.Add(Format('Update %d thumbnails', [ThumbCount]));
      if FImagesGenerate then
        if FImagesGenerateAll then
          Feedback.Add(Format('Create %d web images', [ThumbCount]))
        else
          Feedback.Add(Format('Update %d web images', [ThumbCount]));
      if FGenerateHtml and FGeneratePages and (FThumbLink = 1) then
        Feedback.Add(Format('Create %d html image pages', [ThumbCount]));
      NumPages := (ThumbCount + FThumbsPerPage - 1) div FThumbsPerPage;
      if FGenerateHtml and FGenerateSheets then
        Feedback.Add(Format('Create %d html index pages', [NumPages]));

      // Create Generators
      ImageGen := TImageProcessor.Create;
      with ImageGen do
      begin
        // Resample or Resize
        if FImageHQSamp then
          Commands.Add(CreateDownSampleCommand(FImageMaxWidth, FImageMaxHeight))
        else
          Commands.Add(CreateDownSizeCommand(FImageMaxWidth, FImageMaxHeight));
          if FImageAddFrame then
            Commands.Add(CreateAddFrameCommand(FImageAddFrameCol));
        if FImageAdjustQual then
          OutputQuality := FImageAdjustVal;
      end;
      ThumbGen := TImageProcessor.Create;
      with ThumbGen do
      begin
        // Resample or Resize
        if FThumbHQSamp then
          Commands.Add(CreateResampleCommand(FThumbMaxWidth, FThumbMaxHeight))
        else
          Commands.Add(CreateResizeCommand(FThumbMaxWidth, FThumbMaxHeight));
        case FThumbFormat of
        1: OutputFormat := gfGif;
        2: OutputFormat := gfJPG;
        end;
        if FThumbAdjustQual then
          OutputQuality := FThumbAdjustVal;
      end;

      // Check folders
      ForceDirectories(FSheetFolder);
      ForceDirectories(FPageFolder);
      ForceDirectories(FImageFolder);
      ForceDirectories(FThumbFolder);

      // Thumbnails
      if FThumbsGenerate then
      begin
        for i := 0 to ThumbCount - 1 do
        begin
          Feedback.Info := Format('Creating thumbnail %s from %s',
            [ExtractFileName(Thumbs[i].ThumbFileName), Thumbs[i].Item.Name]);;
          if FThumbFormat > 0 then
            Thumbs[i].GenerateThumb(ThumbGen, FThumbsGenerateAll);
          Feedback.Progress := (i + 1) * 100 / ThumbCount;
        end;
        Feedback.Status := tsCompleted;
      end;

      // Images
      if FImagesGenerate then
      begin
        for i := 0 to ThumbCount - 1 do
        begin
          Feedback.Info := Format('Creating image %s from %s',
            [ExtractFileName(Thumbs[i].ImageFileName), Thumbs[i].Item.Name]);;
          if FImageFormat > 0 then
            Thumbs[i].GenerateImage(ImageGen, FImagesGenerateAll);
          Feedback.Progress := (i + 1) * 100 / ThumbCount;
        end;
        Feedback.Status := tsCompleted;
      end;

      // Image Page Html
      if FGenerateHtml and FGeneratePages and (FThumbLink = 1) then
      begin

        Links.Clear;
        RndLinks.Clear;
        for i := 0 to ThumbCount - 1 do
        begin
          Links.Add(NumberFormatFromMask(FPageMask, i + 1));
          RndLinks.Add(Links[i]);
        end;

        // Randomizer (for random links)
        if (FPageLinkType = 2) and (ThumbCount > 1) then
          for i := 0 to ThumbCount - 1 do
          begin
            repeat
              Rnd := random(Thumbcount);
            until Rnd <> i;
            Tmp := RndLinks[i];
            RndLinks[i] := RndLinks[Rnd];
            RndLinks[Rnd] := Tmp;
          end;

        // Load Template
        S := TFileStream.Create(FPageTemplate, fmOpenRead or fmShareDenyWrite);
        try
          SetLength(Template, S.Size);
          S.Read(Template[1], S.Size);
        finally
          S.Free;
        end;

        // Parse the template for filenames, and if found, copy the referenced
        // files to the output dir
        CopyWebpageReferences(Template, FPageTemplate, FPageFolder);

        for i := 0 to ThumbCount - 1 do
        begin
          // Temp copy in Page
          Page := Template;

          if ThumbCount > 1 then
          begin
            // PageNext
            Page := StringReplace(Page, cPagePrev,
              MakeLink('[&nbsp;<<&nbsp;]', Links[Max(i - 1, 0)], Links[i]), [rfReplaceAll]);
            Page := StringReplace(Page, cPageNext,
              MakeLink('[&nbsp;>>&nbsp;]', Links[Min(i + 1, ThumbCount - 1)], Links[i]), [rfReplaceAll]);
            // PagePeerHor
            Page := StringReplace(Page, cPagePeerHor,
              MakePeerLinks(nil, Links, '', '', '', '', '', '[]', i, 10), [rfReplaceAll]);
          end else
          begin
            // No need for links
            Page := StringReplace(cPagePrev, '', Page, [rfReplaceAll]);
            Page := StringReplace(cPageNext, '', Page, [rfReplaceAll]);
            Page := StringReplace(cPagePeerHor, '', Page, [rfReplaceAll]);
          end;

          // Back to sheet link
          SheetNum := i div FThumbsPerPage;
          SheetLink := ConvertToForwardSlash(ExtractRelativePath(FPageFolder,
            Format('%s%s', [FSheetFolder, NumberFormatFromMask(FSheetMask, SheetNum + 1)])));
          Page := StringReplace(Page, cPageSheet,
            MakeLink('[&nbsp;^^&nbsp;]', SheetLink, ''), [rfReplaceAll]);

          // Description
          Page := StringReplace(Page, cDescription, Thumbs[i].Item.Description, [rfReplaceAll]);;

          // Image Name
          Page := StringReplace(Page, cImageName, Thumbs[i].ImageName, [rfReplaceAll]);;

          // Image Title
          Page := StringReplace(Page, cImageTitle,
            Format('%s - %s', [FWebTitle, Thumbs[i].ImageName]), [rfReplaceAll]);;

          // Image link
          ImageLink := ConvertToForwardSlash(ExtractRelativePath(FPageFolder, Thumbs[i].ImageFileName));
          OrigLink  := ConvertToForwardSlash(ExtractRelativePath(FPageFolder, Thumbs[i].OrigName));

          // Image anchor
          Anchor := '';
          Alt := '';
          if FPageLinkType > 0 then
          begin
            case FPageLinkType of
            1: // Link  to next
              begin
                Anchor := Links[(i + 1) Mod ThumbCount];
                Alt := 'Click for Next Image';
              end;
            2: // Link to random
              begin
                Anchor := RndLinks[i];
                Alt := 'Click for Random Image';
              end;
            3: // Link to Original
              begin
                Anchor := OrigLink;
                Alt := 'Click for Original Image';
              end;
            4: // Link to index
              begin
                Anchor := SheetLink;
                Alt := 'Back to Index';
              end;
            end;// case
          end;

          // Create <img .. > link
          ImageLink := MakeImgLink(ImageLink, Alt);

          // if anchored, do it here
          if length(Anchor) > 0 then
            ImageLink := MakeLink(ImageLink, Anchor, '');

          Page := StringReplace(Page, cImage, ImageLink, [rfReplaceAll]);

          // Footer
          Page := StringReplace(Page, cDate, FormatDateTime('ddmmmyyyy', Date), [rfReplaceAll]);

          // Save sheet
          S := TFileStream.Create(
            Format('%s%s', [FPageFolder, Links[i]]),
            fmCreate or fmShareDenyWrite);
          try
            S.Write(Page[1], length(Page));
          finally
            S.Free;
          end;
          Feedback.Progress := (i + 1) / ThumbCount * 100;
        end;
        // Finished with Image Page Html
        Feedback.Status := tsCompleted;
      end;

      // Sheet Html
      if FGenerateHtml and FGenerateSheets then
      begin
        Links.Clear;
        for i := 0 to NumPages - 1 do
        begin
          Links.Add(NumberFormatFromMask(FSheetMask, i + 1));
        end;

        // Load Template
        S := TFileStream.Create(FSheetTemplate, fmOpenRead or fmShareDenyWrite);
        try
          SetLength(Template, S.Size);
          S.Read(Template[1], S.Size);
        finally
          S.Free;
        end;

        // Parse the template for filenames, and if found, copy the referenced
        // files to the output dir
        CopyWebpageReferences(Template, FSheetTemplate, FSheetFolder);

        for i := 0 to NumPages - 1 do
        begin
          // Temp copy in Sheet
          Sheet := Template;

          // SheetTitle
          Sheet := StringReplace(Sheet, cSheetTitle, Format('%s - Sheet %d', [FWebTitle, i + 1]),
            [rfReplaceAll]);

          if NumPages > 1 then
          begin
            // SheetNext
            Sheet := StringReplace(Sheet, cSheetPrev,
              MakeLink('[&nbsp;<<&nbsp;]', Links[Max(i - 1, 0)], Links[i]), [rfReplaceAll]);
            Sheet := StringReplace(Sheet, cSheetNext,
              MakeLink('[&nbsp;>>&nbsp;]', Links[Min(i + 1, NumPages - 1)], Links[i]), [rfReplaceAll]);
            // SheetPeerHor
            Sheet := StringReplace(Sheet, cSheetPeerHor,
              MakePeerLinks(nil, Links, '', '', '', '', '', '[]', i, 10), [rfReplaceAll]);
          end else
          begin
            // No need for links
            Sheet := StringReplace(Sheet, cSheetPrev, '', [rfReplaceAll]);
            Sheet := StringReplace(Sheet, cSheetNext, '', [rfReplaceAll]);
            Sheet := StringReplace(Sheet, cSheetPeerHor,
              Format('<a href="%s">%d Items</a>', [Links[0], Thumbcount]), [rfReplaceAll]);
          end;

          // Generate thumbnails
          Html := '';
          CellSizeReq := format('width="%d" height="%d"',[FThumbMaxWidth + 10, FThumbMaxHeight-10]);
          // Upper line
          Html := Html + '    <tr>'#13#10;
          for c := 0 to FThumbCols - 1 do
          begin
            Html := Html + '      <td height="10">'#13#10;
            Html := Html + '      </td>'#13#10;
          end;
          Html := Html + '    </tr>'#13#10;
          for r := 0 to FThumbRows - 1 do
          begin

            Html := Html + '    <tr>'#13#10;
            for c := 0 to FThumbCols - 1 do
            begin
              Html := Html + '      <td align="center" valign="middle" ' + CellSizeReq + '>'#13#10;
              // The thumbnail + link
              ThumbIdx := i * FThumbsPerPage + r * FThumbCols + c;
              if assigned(Thumbs[ThumbIdx]) then
              begin
                ThumbLink := ConvertToForwardSlash(ExtractRelativePath(FSheetFolder, Thumbs[ThumbIdx].ThumbFileName));

                if FThumbLink = 0 then
                  // Linked directly
                  ImageLink := ConvertToForwardSlash(ExtractRelativePath(FSheetFolder, Thumbs[ThumbIdx].ImageFileName))
                else
                  // Linked to page
                  ImageLink := ConvertToForwardSlash(ExtractRelativePath(FSheetFolder,
                    Format('%s%s', [FPageFolder, NumberFormatFromMask(FPageMask, ThumbIdx + 1)])));

                Alt := '';
                if FSheetAltDescr then
                  Alt := Format(' alt="%s"', [Thumbs[ThumbIdx].Item.Description]);

                Html := Html +
                  Format('        <a href="%s"><img src="%s"%s></a>',
                    [ImageLink, ThumbLink, Alt])
                  + #13#10;
              end else
                Html := Html + '&nbsp;'#13#10;
              Html := Html + '      </td>'#13#10;
            end;
            Html := Html + '    </tr>'#13#10;

            // Filename & Size
            Html := Html + '    <tr>'#13#10;
            for c := 0 to FThumbCols - 1 do
            begin
              Html := Html + '      <td align="center">'#13#10;
              ThumbIdx := i * FThumbsPerPage + r * FThumbCols + c;
              if assigned(Thumbs[ThumbIdx]) then
              begin
                ImageLink := ConvertToForwardSlash(ExtractRelativePath(FSheetFolder, Thumbs[ThumbIdx].ImageFileName));
                AFile := TsdFile(Thumbs[ThumbIdx].Item);
                FileName := '';
                Second := '';
                if assigned(AFile) then
                begin
                  // First line
                  FileName := ExtractFileName(AFile.FileName);
                  // Second line
                  if AFile.Size < 1048576 then
                    Second := format('%3.1fKb', [AFile.Size / 1024])
                  else
                    Second := format('%3.1fMb', [AFile.Size / 1048576]);
                  Second := CommaToDot(Second);
                end;
                Html := Html +
                  Format('        <a href="%s">%s</a>',
                    [ImageLink, FileName]) + #13#10 +
                  Format('        <br><b>%s</b><br><br>',
                    [Second]) + #13#10;
              end else
                Html := Html + '&nbsp;'#13#10;
              Html := Html + '      </td>'#13#10;
            end;
            Html := Html + '    </tr>'#13#10;
          end;

          // Insert into sheet
          Sheet := StringReplace(Sheet, cThumbnails, Html, [rfReplaceAll]);

          // Footer
          Sheet := StringReplace(Sheet, cDate, FormatDateTime('ddmmmyyyy', Date), [rfReplaceAll]);

          // Save sheet
          S := TFileStream.Create(
            Format('%s%s', [FSheetFolder, Links[i]]),
            fmCreate or fmShareDenyWrite);
          try
            S.Write(Sheet[1], length(Sheet));
          finally
            S.Free;
          end;
          Feedback.Progress := (i + 1) / Numpages * 100;
        end;
        // Completion of Html sheets
        Feedback.Status := tsCompleted;
      end;
    end;

    // Preview?
    if FPreviewHtml then
    begin
      PreviewAddress := FSheetFolder + NumberFormatFromMask(FSheetMask, 1);
      ShellExecute(frmMain.Handle, 'open', pchar(PreviewAddress),
      nil, nil, SW_SHOWNORMAL);
    end;

  finally
    Links.Free;
    RndLinks.Free;
    frmMain.Root.UnlockRead;
    Feedback.Finish;
  end;
end;

procedure TWebpageFrame.btnGenerateClick(Sender: TObject);
begin
  if assigned(Item) then
    with TWebPageItem(Item) do
    begin
      // Make sure to update first
      DlgToFilter;
      // Now generate
      GenerateWebPage;
    end;
end;

procedure TWebpageFrame.WebPageChange(Sender: TObject);
begin
  ValidateTabs(Sender);
end;

procedure TWebpageFrame.FrameOKClick;
// Process the OK button click here.. We will ask the user to generate the page
// if this was not already done in this session
begin
  if not assigned(Item) then
    exit;
  if not TWebPageItem(Item).FHasGenerated then
    if MessageDlg('Do you want to generate the HTML now?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
      TWebPageItem(Item).GenerateWebPage;
end;

end.
