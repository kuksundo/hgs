{ unit Options

  Implements the options dialog.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, RxCombos, Mask, rxToolEdit,
  ExtDlgs, GraphicEx, RXSlider, IniFiles, sdApplicationOptions, MMSystem, guiActions,
  guiFolderOptions, Spin, Math, RXCtrls, RXSpin, ActnList, ImgList, guiPlugins,
  guiPluginFrames, CheckLst, jpeg, sdAbcTypes, sdAbcVars, sdAbcFunctions;

type
  TfrmOptions = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    pcOptions: TPageControl;
    tsBrowser: TTabSheet;
    tsViewer: TTabSheet;
    tsSlideshow: TTabSheet;
    GroupBox2: TGroupBox;
    chbWinShowToolbars: TCheckBox;
    ColorDialog: TColorDialog;
    OpenPictureDialog: TOpenPictureDialog;
    tsFiling: TTabSheet;
    GroupBox4: TGroupBox;
    chUseRecycleBin: TCheckBox;
    GroupBox5: TGroupBox;
    cbbResamplingFilter: TComboBox;
    chbResamplingOnTheFly: TCheckBox;
    GroupBox6: TGroupBox;
    DelaySlider: TRxSlider;
    Label2: TLabel;
    DelayLabel: TLabel;
    SequenceRadio: TRadioGroup;
    GroupBox7: TGroupBox;
    chbEnableRefresh: TCheckBox;
    chbFocusNew: TCheckBox;
    GroupBox8: TGroupBox;
    chbAutoCrc: TCheckBox;
    chbAutoPixRef: TCheckBox;
    Label4: TLabel;
    GroupBox9: TGroupBox;
    RescanCheck: TCheckBox;
    AutoSaveCheck: TCheckBox;
    SavePeriodEdit: TEdit;
    Label5: TLabel;
    tsThumbnails: TTabSheet;
    GroupBox10: TGroupBox;
    Label6: TLabel;
    Panel2: TPanel;
    imMainBgr: TImage;
    feBgrFile: TFilenameEdit;
    FontDialog: TFontDialog;
    lblFont: TLabel;
    GroupBox11: TGroupBox;
    WrapAroundCheck: TCheckBox;
    HideMouseCheck: TCheckBox;
    Bevel1: TBevel;
    Label7: TLabel;
    BitBtn4: TBitBtn;
    FilenameEdit1: TFilenameEdit;
    Button1: TButton;
    chProtectWarn: TCheckBox;
    raConfirmDialog: TRadioButton;
    raConfirmMessage: TRadioButton;
    Label8: TLabel;
    raNoConfirm: TRadioButton;
    chSingleFileNoWarn: TCheckBox;
    Label9: TLabel;
    rxsResampling: TRxSlider;
    lblResampling: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    cbbPriority: TComboBox;
    chbAutoThumb: TCheckBox;
    sedDecodeThreads: TSpinEdit;
    Label14: TLabel;
    GroupBox13: TGroupBox;
    chbShowInfotip: TCheckBox;
    sedThumbnailCache: TSpinEdit;
    sedGraphicsCache: TSpinEdit;
    GroupBox14: TGroupBox;
    sldVerSize: TRxSlider;
    sldHorSize: TRxSlider;
    pnlThumbSize: TPanel;
    lblPixels: TLabel;
    lblThumb: TLabel;
    pnlThumb: TPanel;
    imgThumb: TImage;
    rbSmall: TRadioButton;
    rbMedium: TRadioButton;
    rbLarge: TRadioButton;
    GroupBox15: TGroupBox;
    tsFields: TTabSheet;
    GroupBox16: TGroupBox;
    clbFileFields: TRxCheckListBox;
    GroupBox17: TGroupBox;
    RxCheckListBox2: TRxCheckListBox;
    btnDelete: TButton;
    btnAdd: TButton;
    btnModify: TButton;
    edFieldName: TEdit;
    Label15: TLabel;
    edDefaultValue: TEdit;
    Label16: TLabel;
    chbSearchable: TCheckBox;
    GroupBox18: TGroupBox;
    rbThumbCompressNone: TRadioButton;
    rbThumbCompressLZW: TRadioButton;
    rbThumbCompressJPG: TRadioButton;
    GroupBox19: TGroupBox;
    clbFolderFields: TRxCheckListBox;
    btnHelp: TBitBtn;
    chbSortTypeWithExt: TCheckBox;
    chbUpdateFromBgr: TCheckBox;
    chbStoreThumbs: TCheckBox;
    chbAutoVerify: TCheckBox;
    GroupBox12: TGroupBox;
    seViewListW: TRxSpinEdit;
    seViewListH: TRxSpinEdit;
    Label18: TLabel;
    Label19: TLabel;
    rbViewListIcons: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox20: TGroupBox;
    Label17: TLabel;
    Label20: TLabel;
    seViewSmallW: TRxSpinEdit;
    seViewSmallH: TRxSpinEdit;
    rbViewSmallIcons: TRadioButton;
    RadioButton4: TRadioButton;
    GroupBox21: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    seViewLargeW: TRxSpinEdit;
    seViewLargeH: TRxSpinEdit;
    rbViewLargeIcons: TRadioButton;
    RadioButton6: TRadioButton;
    GroupBox22: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    seViewDetailW: TRxSpinEdit;
    seViewDetailH: TRxSpinEdit;
    rbViewDetailIcons: TRadioButton;
    RadioButton8: TRadioButton;
    alOptions: TActionList;
    ilOptions: TImageList;
    BgrColor: TAction;
    BrgFont: TAction;
    pbMainBgr: TPaintBox;
    Label25: TLabel;
    SpeedButton1: TSpeedButton;
    Label27: TLabel;
    SpeedButton2: TSpeedButton;
    lblFontName: TLabel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    pbShowBgr: TPaintBox;
    Label28: TLabel;
    SpeedButton3: TSpeedButton;
    Panel1: TPanel;
    imShowBgr: TImage;
    feShowFile: TFilenameEdit;
    ShowColor: TAction;
    chbWinShrinkFit: TCheckBox;
    chbWinGrowFit: TCheckBox;
    GroupBox1: TGroupBox;
    chbFullShowToolbars: TCheckBox;
    chbFullShrinkFit: TCheckBox;
    chbFullGrowFit: TCheckBox;
    chbResampleWhenSlide: TCheckBox;
    chbBgrFile: TCheckBox;
    chbShowFile: TCheckBox;
    GroupBox23: TGroupBox;
    chbThumbHQ: TCheckBox;
    tsGeneral: TTabSheet;
    GroupBox24: TGroupBox;
    chbShowTipsOnStartup: TCheckBox;
    chbOverrideListviewBgr: TCheckBox;
    GroupBox25: TGroupBox;
    rbNoGrouping: TRadioButton;
    rbLightColors: TRadioButton;
    rbDarkColors: TRadioButton;
    GroupBox26: TGroupBox;
    Label26: TLabel;
    rbMatchIntensity: TRadioButton;
    rbMatchColors: TRadioButton;
    Label29: TLabel;
    cbbGranularity: TComboBox;
    Label3: TLabel;
    GroupBox27: TGroupBox;
    rbSortSimAuto: TRadioButton;
    rbSortSimSlow: TRadioButton;
    rbSortSimFast: TRadioButton;
    Label30: TLabel;
    seSimAutoLimit: TRxSpinEdit;
    Label31: TLabel;
    chbAutoSCrc: TCheckBox;
    frFolderOptions: TfrFolderOptions;
    tsPlugins: TTabSheet;
    GroupBox28: TGroupBox;
    frmPlugin: TfrmPlugin;
    GroupBox29: TGroupBox;
    chlbPlugins: TCheckListBox;
    Label32: TLabel;
    BitBtn1: TBitBtn;
    Label33: TLabel;
    procedure OptionsChanged(Sender: TObject);
    procedure DelaySliderChange(Sender: TObject);
    procedure feBgrFileBeforeDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure feBgrFileChange(Sender: TObject);
    procedure feShowFileChange(Sender: TObject);
    procedure feShowFileBeforeDialog(Sender: TObject;
      var Name: String; var Action: Boolean);
    procedure BitBtn4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chUseRecycleBinClick(Sender: TObject);
    procedure rxsResamplingChange(Sender: TObject);
    procedure chbResamplingOnTheFlyClick(Sender: TObject);
    procedure ThumbnailSizeDraw(Sender: TObject);
    procedure rbSmallClick(Sender: TObject);
    procedure rbMediumClick(Sender: TObject);
    procedure rbLargeClick(Sender: TObject);
    procedure clbFileFieldsClick(Sender: TObject);
    procedure BgrColorExecute(Sender: TObject);
    procedure BrgFontExecute(Sender: TObject);
    procedure pbMainBgrPaint(Sender: TObject);
    procedure ShowColorExecute(Sender: TObject);
    procedure pbShowBgrPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbBgrFileClick(Sender: TObject);
    procedure chbShowFileClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    FColumnsChanged: boolean;
    FBgrColor: TColor;
    FShowColor: TColor;
  public
    FActivating: boolean; // true while we're activating the control
    { Public declarations }
    procedure BrowserExampleDraw;
    procedure ShowExampleDraw;
    procedure SettingsToDlg;
    procedure DlgToSettings;
  end;

procedure SettingsToIni(AFilename: TFilename);
{procedure IniToSettings(AFilename: TFilename);}
procedure InitControlsFromIni(AFilename: TFilename);
procedure SaveControlsToIni(AFilename: TFilename);

var
  frmOptions: TfrmOptions;

implementation

{$R *.DFM}

uses
  guiItemView, guiMain, sdRoots, sdItems, guiShow, sdGraphicLoader, sdOptionRefs,
  sdProperties, ItemLists;

procedure TfrmOptions.SettingsToDlg;
var
  i: integer;
  Ini: TIniFile;
begin

  // Reflect state of the settings in the dialog box
  try
    FActivating := true;

    // Browser
    chbEnableRefresh.Checked := FShellNotify;
    chbFocusNew.Checked := FFocusNew;

    sedThumbnailCache.Value := FThumbnailCache;
    sedGraphicsCache.Value := FGraphicsCache;
    sedDecodeThreads.Value := FDecodeThreads;
    cbbPriority.ItemIndex := ord(FDecodePriority);

    chbAutoVerify.Checked := FAutoVerify;
    chbAutoThumb.Checked := FAutoThumb;
    chbAutoCrc.Checked := FAutoCRC;
    chbAutoSCrc.Checked := FAutoSCRC;
    chbAutoPixRef.Checked := FAutoPixRef;

    chbShowInfotip.Checked := FShowInfotip;
    chbUpdateFromBgr.Checked := FUpdateFromBgr;
    chbSortTypeWithExt.Checked := FSortTypeWithExt;
    chbOverrideListviewBgr.Checked := FOverrideListviewBgr;

    rbNoGrouping.Checked := FColorGrouping = cColorGroupingNone;
    rbLightColors.Checked := FColorGrouping = cColorGroupingPastel;
    rbDarkColors.Checked := FColorGrouping = cColorGroupingGloom;

    // Copy some temp settings
    FBgrColor := FMainBgrColor;
    FShowColor := FShowBgrColor;
    feBgrFile.Text := FMainBgrFile;
    feShowFile.Text := FShowBgrFile;
    // We assign the frmABC with this one as default
    if assigned(FMainBgrFont) then
      lblFont.Font.Assign(FMainBgrFont);

    // Viewer
    chbWinShowToolbars.Checked := FWinShowToolbars;
    chbWinShrinkFit.Checked := FWinShrinkFit;
    chbWinGrowFit.Checked := FWinGrowFit;

    chbFullShowToolbars.Checked := FFullShowToolbars;
    chbFullShrinkFit.Checked := FFullShrinkFit;
    chbFullGrowFit.Checked := FFullGrowFit;

    chbResamplingOnTheFly.Checked := FResamplingOnTheFly;
    cbbResamplingFilter.ItemIndex:=integer(FResamplingFilter);
    rxsResampling.Value := FResamplingDelay;
    lblResampling.Visible := FResamplingOnTheFly;
    rxsResampling.Visible := FResamplingOnTheFly;

    feShowFile.Text := FShowBgrFile;
    FShowColor := FShowBgrColor;

    // Slideshow
    DelaySlider.Value := FSlideShowDelay;
    DelayLabel.Caption := Format('%d msec', [FSlideShowDelay]);
    SequenceRadio.ItemIndex := integer(FSlideShowDir);
    WrapAroundCheck.Checked := FWrapAround;
    HideMouseCheck.Checked := FHideMouse;
    chbResampleWhenSlide.Checked := FResampleWhenSlide;

    // Filing
    raNoConfirm.Checked := (FDeleteConfirm = dcNever);
    raConfirmMessage.Checked := (FDeleteConfirm = dcMessage);
    raConfirmDialog.Checked := (FDeleteConfirm = dcDialog);
    chSingleFileNoWarn.Checked := FSingleFileNoWarn;
    chProtectWarn.Checked := FProtectWarn;
    chUseRecycleBin.Checked := FUseRecycleBin;

    RescanCheck.Checked := FRescanAfterLoad;

    // Folders
    frFolderOptions.SetOptions(FFolderOptions);

    // Thumbnails
    sldHorSize.Value := FThumbWidth;
    sldVerSize.Value := FThumbHeight;
    ThumbnailSizeDraw(nil);

    seViewListW.Value := FViewListW;
    seViewListH.Value := FViewListH;
    seViewSmallW.Value := FViewSmallW;
    seViewSmallH.Value := FViewSmallH;
    seViewLargeW.Value := FViewLargeW;
    seViewLargeH.Value := FViewLargeH;
    seViewDetailW.Value := FViewDetailW;
    seViewDetailH.Value := FViewDetailH;

    rbViewListIcons.Checked := FViewListShowIcons;
    rbViewSmallIcons.Checked := FViewSmallShowIcons;
    rbViewLargeIcons.Checked := FViewLargeShowIcons;
    rbViewDetailIcons.Checked := FViewDetailShowIcons;

    chbThumbHQ.Checked := FThumbHQ;
    chbStoreThumbs.Checked := FStoreThumbs;

    rbThumbCompressNone.Checked := (FThumbCompress = cThumbCompressNone);
    rbThumbCompressLZW.Checked := (FThumbCompress = cThumbCompressLZW);
    rbThumbCompressJPG.Checked := (FThumbCompress = cThumbCompressJPG);

    // General
    chbShowTipsOnStartup.Checked := FTipOfDay;
    frmPlugin.UpdateControls(Self);

    // PixRef
    rbMatchIntensity.Checked := FMatchMethod = cmmIntensity;
    rbMatchColors.Checked    := FMatchMethod = cmmColors;
    cbbGranularity.ItemIndex := FGranularity;

    rbSortSimAuto.Checked  := FSimilaritySortMethod = cssmAutoMethod;
    rbSortSimSlow.Checked  := FSimilaritySortMethod = cssmSlowMethod;
    rbSortSimFast.Checked  := FSimilaritySortMethod = cssmFastMethod;
    seSimAutoLimit.Value := FSimAutoLimit;

    // Plugin tab
    chlbPlugins.ItemEnabled[0] := FHasJP2Plugin;
    chlbPlugins.ItemEnabled[1] := FHasDXFPlugin;
    chlbPlugins.ItemEnabled[2] := FHasAVIPlugin;
    chlbPlugins.ItemEnabled[3] := FHasTTFPlugin;
    chlbPlugins.Checked[0] := FUseJP2Plugin and FHasJP2Plugin;
    chlbPlugins.Checked[1] := FUseDXFPlugin and FHasDXFPlugin;
    chlbPlugins.Checked[2] := FUseDWGPlugin and FHasDXFPlugin;
    chlbPlugins.Checked[3] := FUseAVIPlugin and FHasAVIPlugin;
    chlbPlugins.Checked[4] := FUseTTFPlugin and FHasTTFPlugin;

    // Some settings come directly from the INI file
    Ini := TIniFile.Create(FIniFile);
    try
      // File fields
      for i := 0 to clbFileFields.Items.Count - 1 do
      begin
        clbFileFields.Checked[i] :=
          Ini.ReadBool('FileColumns', Format('Visible%d', [i]), True);
      end;

      // Folder fields
      for i := 0 to clbFolderFields.Items.Count - 1 do
      begin
        clbFolderFields.Checked[i] :=
          Ini.ReadBool('FolderColumns', Format('Visible%d', [i]), True);
      end;

      // Clear the flag that indicates the user changed this
      FColumnsChanged := False;
    finally
      Ini.Free;
    end;

    FActivating:=False;
    BrowserExampleDraw;
    ShowExampleDraw;

  except
    // Silent exception
  end;
end;

procedure TfrmOptions.DlgToSettings;
var
  i: integer;
  Ini: TIniFile;
  AMatchMethod, AGranularity: integer;
begin
  try
    // Browser
    FShellNotify := chbEnableRefresh.Checked;
    FFocusNew := chbFocusNew.Checked;
    dmActions.snMain.Active := FShellNotify;

    FThumbnailCache := sedThumbnailCache.Value;
    FGraphicsCache := sedGraphicsCache.Value;
    FDecodeThreads := sedDecodeThreads.Value;
    frmMain.Mngr.ThreadCount := FDecodeThreads;
    FDecodePriority := TThreadPriority(cbbPriority.ItemIndex);
    frmMain.Mngr.SetThreadPriority(FDecodePriority);

    FAutoVerify := chbAutoVerify.Checked;
    FAutoThumb := chbAutoThumb.Checked;
    FAutoCRC := chbAutoCrc.Checked;
    FAutoSCRC := chbAutoSCrc.Checked;
    FAutoPixRef := chbAutoPixRef.Checked;

    FShowInfotip := chbShowInfotip.Checked;
    FUpdateFromBgr := chbUpdateFromBgr.Checked;
    FSortTypeWithExt := chbSortTypeWithExt.Checked;
    FOverrideListviewBgr := chbOverrideListviewBgr.Checked;

    if rbNoGrouping.Checked then
      FColorGrouping := cColorGroupingNone;
    if rbLightColors.Checked then
      FColorGrouping := cColorGroupingPastel;
    if rbDarkColors.Checked then
      FColorGrouping := cColorGroupingGloom;

    // Copy some temp settings
    FMainBgrColor := FBgrColor;
    FShowBgrColor := FShowColor;
    FMainBgrFile := feBgrFile.Text;
    FShowBgrFile := feShowFile.Text;

    if not assigned(FMainBgrFont) then
      FMainBgrFont := TFont.Create;
    FMainBgrFont.Assign(lblFont.Font);
    frmMain.SetBackground(FMainBgrFile, FMainBgrColor, FMainBgrFont);
    frmShow.SetBackground(FShowBgrFile, FShowBgrColor);

    // Viewer
    FWinShowToolbars := chbWinShowToolbars.Checked;
    FWinShrinkFit := chbWinShrinkFit.Checked;
    FWinGrowFit := chbWinGrowFit.Checked;

    FFullShowToolbars := chbFullShowToolbars.Checked;
    FFullShrinkFit := chbFullShrinkFit.Checked;
    FFullGrowFit := chbFullGrowFit.Checked;
    frmShow.ValidateToolbars;

    if frmShow.IsFullScreen then
    begin
      frmShow.vwFile.ShrinkToFit := FFullShrinkFit;
      frmShow.vwFile.GrowToFit := FFullGrowFit;
    end else
    begin
      frmShow.vwFile.ShrinkToFit := FWinShrinkFit;
      frmShow.vwFile.GrowToFit := FWinGrowFit;
    end;

    FResamplingOnTheFly := chbResamplingOnTheFly.Checked;
    FResamplingFilter := TResamplingFilter(cbbResamplingFilter.ItemIndex);
    FResamplingDelay := rxsResampling.Value;

    // Slideshow
    FSlideShowDelay:=DelaySlider.Value;
    FSlideShowDir:=TSlideShowDir(SequenceRadio.ItemIndex);
    FWrapAround:=WrapAroundCheck.Checked;
    FHideMouse:=HideMouseCheck.Checked;
    FResampleWhenSlide := chbResampleWhenSlide.Checked;

    // Filing
    if raNoConfirm.Checked then
      FDeleteConfirm := dcNever;
    if raConfirmMessage.Checked then
      FDeleteConfirm := dcMessage;
    if raConfirmDialog.Checked then
      FDeleteConfirm := dcDialog;
    FSingleFileNoWarn := chSingleFileNoWarn.Checked;
    FProtectWarn := chProtectWarn.Checked;

    FUseRecycleBin := chUseRecycleBin.Checked;
    FRescanAfterLoad := RescanCheck.Checked;

    // Folders
    FFolderOptions := frFolderOptions.GetOptions;

    // Thumbnails
    if (FThumbWidth  <> sldHorSize.Value) or
       (FThumbHeight <> sldVerSize.Value) or
       (FViewListW <> round(seViewListW.Value)) or
       (FViewListH <> round(seViewListH.Value)) or
       (FViewSmallW <> round(seViewSmallW.Value)) or
       (FViewSmallH <> round(seViewSmallH.Value)) or
       (FViewLargeW <> round(seViewLargeW.Value)) or
       (FViewLargeH <> round(seViewLargeH.Value)) or
       (FViewDetailW <> round(seViewDetailW.Value)) or
       (FViewDetailH <> round(seViewDetailH.Value)) or
       (FViewListShowIcons <> rbViewListIcons.Checked) or
       (FViewSmallShowIcons <> rbViewSmallIcons.Checked) or
       (FViewLargeShowIcons <> rbViewLargeIcons.Checked) or
       (FViewDetailShowIcons <> rbViewDetailIcons.Checked) then
    begin

      // Thumbnail sizes changed
      FThumbWidth  := sldHorSize.Value;
      FThumbHeight := sldVerSize.Value;

      FViewListW := round(seViewListW.Value);
      FViewListH := round(seViewListH.Value);

      FViewSmallW := round(seViewSmallW.Value);
      FViewSmallH := round(seViewSmallH.Value);

      FViewLargeW := round(seViewLargeW.Value);
      FViewLargeH := round(seViewLargeH.Value);

      FViewDetailW := round(seViewDetailW.Value);
      FViewDetailH := round(seViewDetailH.Value);

      FViewListShowIcons := rbViewListIcons.Checked;
      FViewSmallShowIcons := rbViewSmallIcons.Checked;
      FViewLargeShowIcons := rbViewLargeIcons.Checked;
      FViewDetailShowIcons := rbViewDetailIcons.Checked;

      // Throw away cache
      frmMain.Mngr.ClearItems(nil);

      // Adjust viewers
      frmMain.ItemView1.ResetIcons;
      //frmMain.ItemView2.ResetIcons;
    end;

    FStoreThumbs := chbStoreThumbs.Checked;
    FThumbHQ := chbThumbHQ.Checked;

    if rbThumbCompressNone.Checked then
      FThumbCompress := cThumbCompressNone;
    if rbThumbCompressLZW.Checked then
      FThumbCompress := cThumbCompressLZW;
    if rbThumbCompressJPG.Checked then
      FThumbCompress := cThumbCompressJPG;

    // Thumbnail compression is handled by Root.Mngr
    frmMain.Mngr.ThumbCompress := FThumbCompress;

    // General
    FTipOfDay := chbShowTipsOnStartup.Checked;

    // New pixref settings
    AMatchMethod := cmmIntensity;
    if rbMatchColors.Checked then AMatchMethod := cmmColors;
    AGranularity := cbbGranularity.ItemIndex;

    if rbSortSimAuto.Checked then
      FSimilaritySortMethod := cssmAutoMethod;
    if rbSortSimSlow.Checked then
      FSimilaritySortMethod := cssmSlowMethod;
    if rbSortSimFast.Checked then
      FSimilaritySortMethod := cssmFastMethod;
    FSimAutoLimit := round(seSimAutoLimit.Value);

    // Make sure to remove old pixrefs if there are changes
    if (AMatchMethod <> FMatchMethod) or (AGranularity <> FGranularity) then
    begin
      FMatchMethod := AMatchMethod;
      FGranularity := AGranularity;
      SetStateForList(frmMain.Root.DirectItems, [isPixRefd], False);
      RemoveAllPropertiesInList(frmMain.Root.DirectItems, prPixRef);
    end;

    // Plugin tab
    if FHasJP2Plugin then
      FUseJP2Plugin := chlbPlugins.Checked[0];
    if FHasDXFPlugin then
      FUseDXFPlugin := chlbPlugins.Checked[1];
    if FHasDWGPlugin then
      FUseDWGPlugin := chlbPlugins.Checked[2];
    if FHasAVIPlugin then
      FUseAVIPlugin := chlbPlugins.Checked[3];
    if FHasTTFPlugin then
      FUseTTFPlugin := chlbPlugins.Checked[4];
    if FHasSvgPlugin then
      FUseSvgPlugin := chlbPlugins.Checked[5];

    // Some settings go directly to the INI file
    Ini := TIniFile.Create(FIniFile);
    try
      if FColumnsChanged then
      begin
        // 'Name' can never be hidden
        clbFileFields.Checked[0] := True;
        // File fields
        for i := 0 to clbFileFields.Items.Count - 1 do
        begin
          Ini.WriteBool('FileColumns', Format('Visible%d', [i]), clbFileFields.Checked[i]);
        end;
        // Folder fields
        // 'Name' can never be hidden
        clbFolderFields.Checked[0] := True;
        for i := 0 to clbFolderFields.Items.Count - 1 do
        begin
          Ini.WriteBool('FolderColumns', Format('Visible%d', [i]), clbFolderFields.Checked[i]);
        end;
        // Signal the item views - reassigning forces a column refresh
        frmMain.ItemViewSetItemType(frmMain.ItemView1, frmMain.ItemView1.ItemviewType);
        //frmMain.ItemViewSetItemType(frmMain.Itemview2, frmMain.ItemView2.ItemviewType);
      end;
    finally
      Ini.Free;
    end;
  except
    //Silent exception
  end;
end;

procedure SettingsToIni(AFilename: TFilename);
begin
  // Save the options to ini
  SaveOpt.SaveToIni(AFileName);
  // Plugins
  glPlugins.SaveToIni(AFileName);
end;

procedure InitControlsFromIni(AFilename: TFilename);
var
  Ini: TIniFile;
  FRect: TRect;
begin
  Ini := TIniFile.Create(AFilename);
  try

  // Mainform splitters
  frmMain.Panel1.Width := Ini.ReadInteger('Placement', 'Splitter1', frmMain.Panel1.Width);
  //frmMain.Notebook2.Height := Ini.ReadInteger('Placement', 'Splitter2', frmMain.Notebook2.Height);
  //frmMain.Panel2.Width := Ini.ReadInteger('Placement', 'Splitter3', frmMain.Panel2.Width);
  if not FSingleMode then
    frmMain.DualView;
  // Mainform placement
  FRect := IniReadRect(Ini, 'Placement', 'MainRect',
    rect(50, 50, Screen.Width - 50, Screen.Height - 50));
  frmMain.SetBounds(FRect.Left, FRect.Top, FRect.Right - FRect.Left, FRect.Bottom - FRect.Top);
  FSingleMode := Ini.ReadBool('Placement', 'SingleMode', FSingleMode);

  // frmShow
  if not assigned(frmShow) then
    Application.CreateForm(TfrmShow, frmShow);
  frmShow.Width := Ini.ReadInteger('Placement', 'ShowWidth', frmMain.Panel1.Width);
  frmShow.Height := Ini.ReadInteger('Placement', 'ShowHeight', 300);

  // ViewStyles
  frmMain.Itemview1.ViewStyle := TListviewStyle(Ini.ReadInteger('Viewstyles', 'Itemview1', 4));
  //frmMain.Itemview2.ViewStyle := TListviewStyle(Ini.ReadInteger('Viewstyles', 'Itemview2', 3));

  // reflect change in shell notify
  if not assigned(dmActions) then
    Application.CreateForm(TdmActions, dmActions);
  dmActions.snMain.Active := FShellNotify;

  finally
    Ini.Free;
  end;

  // Filter Plugins
  glPlugins.LoadFromIni(AFileName);

end;

procedure SaveControlsToIni(AFilename: TFilename);
var
  Ini: TIniFile;
  FRect: TRect;
begin
  Ini := TIniFile.Create(AFilename);
  try

  // Position
  with frmMain do
  begin
    FRect := Bounds(Left, Top, Width, Height);
    IniWriteRect(Ini, 'Placement', 'MainRect', FRect);
    Ini.WriteInteger('Placement', 'Splitter1', Panel1.Width);
    //Ini.WriteInteger('Placement', 'Splitter2', Notebook2.Height);
    //Ini.WriteInteger('Placement', 'Splitter3', Panel2.Width);
    Ini.WriteBool('Placement', 'SingleMode', FSingleMode);
  end;
  // frmShow
  with frmShow do
  begin
    Ini.WriteInteger('Placement', 'ShowWidth', Width);
    Ini.WriteInteger('Placement', 'ShowHeight', Height);
  end;

  // ViewStyles
  Ini.WriteInteger('Viewstyles', 'Itemview1',  integer(frmMain.Itemview1.ViewStyle));
  //Ini.WriteInteger('Viewstyles', 'Itemview2',  integer(frmMain.Itemview2.ViewStyle));

  finally
    Ini.Free;
  end;
end;

procedure TfrmOptions.BrowserExampleDraw;
var
  Loader: TsdGraphicLoader;
begin
  if FActivating then
    exit;

  // Draw the example
  with imMainBgr.Canvas do
  begin

    Brush.Color := FBgrColor;
    Brush.Style := bsSolid;

    Loader := TsdGraphicLoader.Create;
    try
      if Loader.LoadFromFile(feBgrFile.Text) = gsGraphicsOK then
      begin
        Brush.Bitmap := TBitmap.Create;
        Brush.Bitmap.Assign(Loader.Bitmap);
        chbBgrFile.Checked := True;
      end else
      begin
        chbBgrFile.Checked := False;
        feBgrFile.Text := '';
      end;
    finally
      Loader.Free;
    end;
    FillRect(imMainBgr.ClientRect);
  end;
  with lblFont.Font do
    lblFontName.Caption := Format('%s, %d pts',[Name, Size]);
  pbMainBgr.Invalidate;
end;

procedure TfrmOptions.pbMainBgrPaint(Sender: TObject);
begin
  with pbMainBgr.Canvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := FBgrColor;
    Brush.Style := bsSolid;
    Rectangle(pbMainBgr.ClientRect);
  end;
end;

procedure TfrmOptions.BgrColorExecute(Sender: TObject);
begin
  ColorDialog.Color := FBgrColor;
  if ColorDialog.Execute then
  begin
    FBgrColor := ColorDialog.Color;
    BrowserExampleDraw;
    OptionsChanged(Sender);
  end;
end;

procedure TfrmOptions.BrgFontExecute(Sender: TObject);
begin
  FontDialog.Font := lblFont.Font;
  if FontDialog.Execute then
  begin
    lblFont.Font := FontDialog.Font;
    BrowserExampleDraw;
    OptionsChanged(Sender);
  end;
end;

procedure TfrmOptions.feBgrFileBeforeDialog(Sender: TObject; var Name: String; var Action: Boolean);
begin
  Action := False;
  if OpenPictureDialog.Execute then
    feBgrFile.Text := OpenPictureDialog.FileName;
end;

procedure TfrmOptions.feBgrFileChange(Sender: TObject);
begin
  if FActivating then
    exit;
  BrowserExampleDraw;
  OptionsChanged(Sender);
end;

procedure TfrmOptions.chbBgrFileClick(Sender: TObject);
begin
  if FActivating then
    exit;
  if not chbBgrFile.Checked then
    feBgrFile.Text := '';
  OptionsChanged(Sender);
end;

procedure TfrmOptions.feShowFileBeforeDialog(Sender: TObject; var Name: String; var Action: Boolean);
begin
  Action := False;
  if OpenPictureDialog.Execute then
    feShowFile.Text := OpenPictureDialog.FileName;
end;

procedure TfrmOptions.feShowFileChange(Sender: TObject);
begin
  if FActivating then
    exit;
  ShowExampleDraw;
  OptionsChanged(Sender);
end;

procedure TfrmOptions.chbShowFileClick(Sender: TObject);
begin
  if FActivating then
    exit;
  if not chbShowFile.Checked then
    feShowFile.Text := '';
  OptionsChanged(Sender);
end;

procedure TfrmOptions.ShowExampleDraw;
var
  Loader: TsdGraphicLoader;
begin
  if FActivating then
    exit;

  // Draw the example
  with imShowBgr.Canvas do
  begin

    Brush.Color := FShowColor;
    Brush.Style := bsSolid;

    Loader := TsdGraphicLoader.Create;
    try
      if Loader.LoadFromFile(feShowFile.Text) = gsGraphicsOK then
      begin
        Brush.Bitmap := TBitmap.Create;
        Brush.Bitmap.Assign(Loader.Bitmap);
        chbShowFile.Checked := True;
      end else
      begin
        feShowFile.Text := '';
        chbShowFile.Checked := False;
      end;
    finally
      Loader.Free;
    end;
    FillRect(imShowBgr.ClientRect);
  end;
  pbShowBgr.Invalidate;
end;

procedure TfrmOptions.pbShowBgrPaint(Sender: TObject);
begin
  with pbShowBgr.Canvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := FShowColor;
    Brush.Style := bsSolid;
    Rectangle(pbShowBgr.ClientRect);
  end;
end;

procedure TfrmOptions.ShowColorExecute(Sender: TObject);
begin
  ColorDialog.Color := FShowColor;
  if ColorDialog.Execute then
  begin
    FShowColor := ColorDialog.Color;
    ShowExampleDraw;
    OptionsChanged(Sender);
  end;
end;

procedure TfrmOptions.ThumbnailSizeDraw;
var
  AWidth, AHeight, AMin: integer;
begin
  AWidth := sldHorSize.Value;
  AHeight := sldVerSize.Value;
  AMin := Min(AWidth, AHeight);

  pnlThumb.Left := (pnlThumbSize.Width  - AWidth) div 2 - 2;
  pnlThumb.Top  := (pnlThumbSize.Height - AHeight) div 2 - 12;
  pnlThumb.Width := AWidth;
  pnlThumb.Height := AHeight;
  imgThumb.Left := (AWidth  - AMin) div 2;
  imgThumb.Top  := (AHeight - AMin) div 2;
  imgThumb.Width  := AMin;
  imgThumb.Height := AMin;

  lblThumb.Left := pnlThumb.Left;
  lblThumb.Top  := pnlThumb.Top + AHeight + 4;
  lblThumb.Width := AWidth;

  lblPixels.Caption := Format('%d x %d pixels', [AWidth, AHeight]);

  rbSmall.Checked  := (AWidth = cThumbSmall.X) and (AHeight = cThumbSmall.Y);
  rbMedium.Checked := (AWidth = cThumbMedium.X) and (AHeight = cThumbMedium.Y);
  rbLarge.Checked  := (AWidth = cThumbLarge.X) and (AHeight = cThumbLarge.Y);

  OptionsChanged(Sender);
end;

procedure TfrmOptions.OptionsChanged(Sender: TObject);
begin
  if FActivating then
    exit;
  FSettingsChanged := true;
end;

procedure TfrmOptions.DelaySliderChange(Sender: TObject);
begin
  DelayLabel.Caption:=Format('%d msec',[DelaySlider.Value]);
  OptionsChanged(Sender);
end;

procedure TfrmOptions.BitBtn4Click(Sender: TObject);
begin
  PlaySound(pchar(FileNameEdit1.Text), 0, SND_ASYNC or SND_FILENAME);
end;

procedure TfrmOptions.Button1Click(Sender: TObject);
begin
  PlaySound(nil, 0, 0);
end;

procedure TfrmOptions.chUseRecycleBinClick(Sender: TObject);
begin
  if not chUseRecyclebin.Checked then
    if MessageDlg(
      'It is unsafe to skip the use of'#13+
      'the recycle bin! Are you sure?', mtWarning, mbYesNoCancel, 0) <>  mrYes then
    begin
      chUseRecyclebin.Checked := true;
    end;
  OptionsChanged(Sender);
end;

procedure TfrmOptions.rxsResamplingChange(Sender: TObject);
begin
  lblResampling.Caption:=Format('Delay: %d ms', [rxsResampling.Value]);
  OptionsChanged(Sender);
end;

procedure TfrmOptions.chbResamplingOnTheFlyClick(Sender: TObject);
begin
  lblResampling.Visible := chbResamplingOnTheFly.Checked;
  rxsResampling.Visible := chbResamplingOnTheFly.Checked;
  OptionsChanged(Sender);
end;

procedure TfrmOptions.rbSmallClick(Sender: TObject);
begin
  sldHorSize.Value := cThumbSmall.X;
  sldVerSize.Value := cThumbSmall.Y;
end;

procedure TfrmOptions.rbMediumClick(Sender: TObject);
begin
  sldHorSize.Value := cThumbMedium.X;
  sldVerSize.Value := cThumbMedium.Y;
end;

procedure TfrmOptions.rbLargeClick(Sender: TObject);
begin
  sldHorSize.Value := cThumbLarge.X;
  sldVerSize.Value := cThumbLarge.Y;
end;

procedure TfrmOptions.clbFileFieldsClick(Sender: TObject);
begin
  FColumnsChanged := True;
  OptionsChanged(Sender);
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  pcOptions.ActivePage := tsBrowser;
end;

procedure TfrmOptions.btnHelpClick(Sender: TObject);
begin
  Application.HelpContext(pcOptions.ActivePage.HelpContext);
end;

end.
