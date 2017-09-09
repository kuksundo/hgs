{ unit StandardItems

  Standard filtering on most common properties

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiStandardItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Contnrs, Masks, RXSpin, Mask, rxToolEdit, StdCtrls, ComCtrls,
  BrowseTrees, sdItems, Filters, guiFilterFrame, sdAbcFunctions;

type

  TFilterType = (ftNone, ftByFileType, ftFilterImages, ftFilterAudio, ftFilterVideo,
    ftByMask, ftByFileSize, ftByFileDate, ftByFolderSize, ftVarious, ftImageProps);

  TStandardFrame = class(TFilterFrame)
    pcFilter: TPageControl;
    tsByType: TTabSheet;
    GroupBox8: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    chFilterFileType: TCheckBox;
    cbbAllowFileType: TComboBox;
    chFileTypeImages: TCheckBox;
    edFileTypeImages: TEdit;
    btnFileTypeImages: TButton;
    chFileTypeAudio: TCheckBox;
    edFileTypeAudio: TEdit;
    btnFileTypeAudio: TButton;
    chFileTypeVideo: TCheckBox;
    edFileTypeVideo: TEdit;
    btnFileTypeVideo: TButton;
    chFileTypeCustom: TCheckBox;
    edFileTypeCustom: TEdit;
    btnFileTypeCustom: TButton;
    GroupBox9: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    chFilterFileMask: TCheckBox;
    cbbAllowFileMask: TComboBox;
    cbbFilterFileMask: TComboBox;
    tsBySize: TTabSheet;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    chFilterFileSize: TCheckBox;
    cbbAllowFileSize: TComboBox;
    rbFileSizeBigger: TRadioButton;
    rbFileSizeInbetween: TRadioButton;
    cbbFileSizeBigger: TComboBox;
    cbbFileSizeLower: TComboBox;
    cbbFileSizeUpper: TComboBox;
    rbFileSizeSmaller: TRadioButton;
    cbbFileSizeSmaller: TComboBox;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    chFilterFolderSize: TCheckBox;
    cbbAllowFolderSize: TComboBox;
    rbFolderSizeBigger: TRadioButton;
    rbFolderSizeInbetween: TRadioButton;
    cbbFolderSizeBigger: TComboBox;
    cbbFolderSizeLower: TComboBox;
    cbbFolderSizeUpper: TComboBox;
    rbFolderSizeSmaller: TRadioButton;
    cbbFolderSizeSmaller: TComboBox;
    tsByDate: TTabSheet;
    GroupBox7: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    chFilterFileDate: TCheckBox;
    cbbAllowFileDate: TComboBox;
    rbFileDateAfter: TRadioButton;
    rbFileDateBetween: TRadioButton;
    rbFileDateBefore: TRadioButton;
    deFileDateAfter: TDateEdit;
    deFileDateBefore: TDateEdit;
    deFileDateLower: TDateEdit;
    deFileDateUpper: TDateEdit;
    seFileDateLast: TRxSpinEdit;
    rbFileDateLast: TRadioButton;
    cbbFileDateLast: TComboBox;
    tsImage: TTabSheet;
    GroupBox10: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    lbSquarePixels: TLabel;
    Label16: TLabel;
    chFilterImage: TCheckBox;
    cbbAllowImage: TComboBox;
    rbImageSquare: TRadioButton;
    cbbImageSquare: TComboBox;
    cbbSquarePixels: TComboBox;
    rbImageCompress: TRadioButton;
    cbbImageCompress: TComboBox;
    seCompression: TRxSpinEdit;
    procedure chFileTypeImagesClick(Sender: TObject);
    procedure chFileTypeAudioClick(Sender: TObject);
    procedure chFileTypeVideoClick(Sender: TObject);
    procedure chFileTypeCustomClick(Sender: TObject);
    procedure btnFileTypeImagesClick(Sender: TObject);
    procedure btnFileTypeAudioClick(Sender: TObject);
    procedure btnFileTypeVideoClick(Sender: TObject);
    procedure btnFileTypeCustomClick(Sender: TObject);
    procedure cbbSquarePixelsChange(Sender: TObject);
  private
  public
    procedure DlgToFilter; override;
    procedure FilterToDlg; override;
    procedure ValidateTabs(Sender: TObject);
  end;

  TStandardItem = class(TBrowseItem)
  private
    FFilterType: TFilterType;
  protected
  public
    // By File Type
    FFilterFileType: boolean;
    FFilterFileTypeAllow: integer;
    FFileTypeImages: boolean;
    FFileTypeAudio: boolean;
    FFileTypeVideo: boolean;
    FFileTypeCustom: boolean;
    FFileTypeImagesStr: string;
    FFileTypeAudioStr: string;
    FFileTypeVideoStr: string;
    FFileTypeCustomStr: string;

    // By File Mask
    FFilterFileMask: boolean;
    FFilterFileMaskAllow: integer;
    FFileMaskStr: string;
    FMasks : TObjectList;

    // By File Size
    FFilterFileSize: boolean;
    FFilterFileSizeAllow: integer;
    FFilterFileSizeMethod: integer;
    FFileSizeBigger: integer;
    FFileSizeBiggerStr: string;
    FFileSizeSmaller: integer;
    FFileSizeSmallerStr: string;
    FFileSizeLower: integer;
    FFileSizeLowerStr: string;
    FFileSizeUpper: integer;
    FFileSizeUpperStr: string;

    // By Folder Size
    FFilterFolderSize: boolean;
    FFilterFolderSizeAllow: integer;
    FFilterFolderSizeMethod: integer;
    FFolderSizeBigger: integer;
    FFolderSizeBiggerStr: string;
    FFolderSizeSmaller: integer;
    FFolderSizeSmallerStr: string;
    FFolderSizeLower: integer;
    FFolderSizeLowerStr: string;
    FFolderSizeUpper: integer;
    FFolderSizeUpperStr: string;

    // By File Date
    FFilterFileDate: boolean;
    FFilterFileDateAllow: integer;
    FFilterFileDateMethod: integer;
    FFileDateAfter: TDateTime;
    FFileDateBefore: TDateTime;
    FFileDateLower: TDateTime;
    FFileDateUpper: TDateTime;
    FFileDateLast: TDateTime;
    FFileDateLastValue: TDateTime;
    FFileDateLastMethod: integer;

    // By Image
    FFilterImage: boolean;
    FFilterImageAllow: integer;
    FFilterImageMethod: integer;
    FFilterImageSquareMethod: integer;
    FFilterSquarePixelsStr: string;
    FFilterSquarePixels: cardinal;
    FFilterImageCompressMethod: integer;
    FFilterCompressionVal: double;

    destructor Destroy; override;
    property FilterType: TFilterType read FFilterType;
    procedure CreateFilterParams; override;
    procedure DetermineFilterType; virtual;
    procedure FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean); virtual;
    // Call InitialiseFilter after all settings have been set, and the filter
    // can start filtering. It wil determine filter type and set masks and set
    // biInitialised flag
    procedure InitialiseFilter; override;
    procedure SetupFileMasks(MaskStr: string);
  end;

const

  cFilterImageIndex: array [TFilterType] of integer =
    (12, 16, 18, 17, 19,
     16,  7, 15,  7,  6,
     18);

  cFilterTabIndex: array[TFilterType] of integer =
    (0, 0, 0, 0, 0,
     0, 1, 2, 1, 0,
     3);

  cStdFilterName: array[TFilterType] of string =
    ('No Filter Selected', 'File Type', 'Images', 'Audio', 'Video',
     'File Mask', 'File Size', 'File Date', 'Folder Size', 'Various Filters',
     'Image Properties');

  cTimeUnit: array[0..5] of double =
    (1/(24*60), // Minutes
     1/24,      // Hours
     1,         // Days
     7,         // Weeks
     31,        // Months
     365);      // Years

  cDefaultImagesStr = '.bmp;.dib;.rle;.jpg;.jpe;.jpeg;.gif;.tif;.png;.wmf;';
  cDefaultAudioStr  = '.mp3;.wav;.ra;';
  cDefaultVideoStr  = '.mpg;.mpeg;.mpe;.mov;.ra;.rm;.ram;.avi;.asf;.asx;.wmv;';
  cDefaultCustomStr = '';

implementation

{$R *.DFM}

{ TStandardFrame }

procedure TStandardFrame.DlgToFilter;
begin
  try
  with TStandardItem(Item) do begin

    // By FileType
    FFilterFileType := chFilterFileType.Checked;
    FFilterFileTypeAllow := cbbAllowFileType.ItemIndex;
    FFileTypeImages := chFileTypeImages.Checked;
    FFileTypeAudio := chFileTypeAudio.Checked;
    FFileTypeVideo := chFileTypeVideo.Checked;
    FFileTypeCustom := chFileTypeCustom.Checked;
    FFileTypeImagesStr := edFileTypeImages.Text;
    FFileTypeAudioStr := edFileTypeAudio.Text;
    FFileTypeVideoStr := edFileTypeVideo.Text;
    FFileTypeCustomStr := edFileTypeCustom.Text;

    // By FileMask
    FFilterFileMask := chFilterFileMask.Checked;
    FFilterFileMaskAllow := cbbAllowFileMask.ItemIndex;
    FFileMaskStr := cbbFilterFileMask.Text;

    // By FileSize
    FFilterFileSize := chFilterFileSize.Checked;
    FFilterFileSizeAllow := cbbAllowFileSize.ItemIndex;
    if rbFileSizeBigger.Checked then FFilterFileSizeMethod := 0;
    if rbFileSizeSmaller.Checked then FFilterFileSizeMethod := 1;
    if rbFileSizeInbetween.Checked then FFilterFileSizeMethod := 2;
    FFileSizeBiggerStr := cbbFileSizeBigger.Text;
    FFileSizeBigger := SizeStrToInt(FFileSizeBiggerStr);
    FFileSizeSmallerStr := cbbFileSizeSmaller.Text;
    FFileSizeSmaller := SizeStrToInt(FFileSizeSmallerStr);
    FFileSizeLowerStr := cbbFileSizeLower.Text;
    FFileSizeLower := SizeStrToInt(FFileSizeLowerStr);
    FFileSizeUpperStr := cbbFileSizeUpper.Text;
    FFileSizeUpper := SizeStrToInt(FFileSizeUpperStr);
    if FFileSizeLower > FFileSizeUpper then
      SwapInteger(FFileSizeLower, FFileSizeUpper);

    // By File Date
    FFilterFileDate := chFilterFileDate.Checked;
    FFilterFileDateAllow := cbbAllowFileDate.ItemIndex;
    if rbFileDateAfter.Checked then FFilterFileDateMethod := 0;
    if rbFileDateBefore.Checked then FFilterFileDateMethod := 1;
    if rbFileDateBetween.Checked then FFilterFileDateMethod := 2;
    if rbFileDateLast.Checked then FFilterFileDateMethod := 3;
    FFileDateAfter := deFileDateAfter.Date;
    FFileDateBefore := deFileDateBefore.Date;
    FFileDateLower := deFileDateLower.Date;
    FFileDateUpper := deFileDateUpper.Date;
    if FFileDateLower > FFileDateUpper then
      SwapDouble(double(FFileDateLower), double(FFileDateUpper));
    FFileDateLast :=  round(seFileDateLast.Value);
    FFileDateLastMethod := cbbFileDateLast.ItemIndex;
    FFileDateLastValue := Now - FFileDateLast * cTimeUnit[FFileDateLastMethod];

    // By Folder Size
    FFilterFolderSize := chFilterFolderSize.Checked;
    FFilterFolderSizeAllow := cbbAllowFolderSize.ItemIndex;
    if rbFolderSizeBigger.Checked then FFilterFolderSizeMethod := 0;
    if rbFolderSizeSmaller.Checked then FFilterFolderSizeMethod := 1;
    if rbFolderSizeInbetween.Checked then FFilterFolderSizeMethod := 2;
    FFolderSizeBiggerStr := cbbFolderSizeBigger.Text;
    FFolderSizeBigger := SizeStrToInt(FFolderSizeBiggerStr);
    FFolderSizeSmallerStr := cbbFolderSizeSmaller.Text;
    FFolderSizeSmaller := SizeStrToInt(FFolderSizeSmallerStr);
    FFolderSizeLowerStr := cbbFolderSizeLower.Text;
    FFolderSizeLower := SizeStrToInt(FFolderSizeLowerStr);
    FFolderSizeUpperStr := cbbFolderSizeUpper.Text;
    FFolderSizeUpper := SizeStrToInt(FFolderSizeUpperStr);
    if FFolderSizeLower > FFolderSizeUpper then
      SwapInteger(FFolderSizeLower, FFolderSizeUpper);

    // By Image
    FFilterImage := chFilterImage.Checked;
    FFilterImageAllow := cbbAllowImage.ItemIndex;
    if rbImageSquare.Checked then FFilterImageMethod := 0;
    if rbImageCompress.Checked then FFilterImageMethod := 1;
    FFilterImageSquareMethod := cbbImageSquare.ItemIndex;
    FFilterSquarePixelsStr := cbbSquarePixels.Text;
    FFilterSquarePixels := SquareStrToInt(FFilterSquarePixelsStr);
    FFilterImageCompressMethod := cbbImageCompress.ItemIndex;
    FFilterCompressionVal := seCompression.Value;

    InitialiseFilter;
  end;
  except
  // silent exception
  end;
end;

procedure TStandardFrame.FilterToDlg;
begin
  try
  with TStandardItem(Item) do begin

    // By FileType
    chFilterFileType.Checked := FFilterFileType;
    cbbAllowFileType.ItemIndex := FFilterFileTypeAllow;
    chFileTypeImages.Checked := FFileTypeImages;
    chFileTypeAudio.Checked := FFileTypeAudio;
    chFileTypeVideo.Checked := FFileTypeVideo;
    chFileTypeCustom.Checked := FFileTypeCustom;
    edFileTypeImages.Text := FFileTypeImagesStr;
    edFileTypeAudio.Text := FFileTypeAudioStr;
    edFileTypeVideo.Text := FFileTypeVideoStr;
    edFileTypeCustom.Text := FFileTypeCustomStr;

    // By FileMask
    chFilterFileMask.Checked := FFilterFileMask;
    cbbAllowFileMask.ItemIndex := FFilterFileMaskAllow;
    cbbFilterFileMask.Text := FFileMaskStr;

    // By FileSize
    chFilterFileSize.Checked := FFilterFileSize;
    cbbAllowFileSize.ItemIndex := FFilterFileSizeAllow;

    rbFileSizeBigger.Checked := FFilterFileSizeMethod = 0;
    rbFileSizeSmaller.Checked := FFilterFileSizeMethod = 1;
    rbFileSizeInbetween.Checked := FFilterFileSizeMethod = 2;

    cbbFileSizeBigger.Text := FFileSizeBiggerStr;
    cbbFileSizeSmaller.Text := FFileSizeSmallerStr;
    cbbFileSizeLower.Text := FFileSizeLowerStr;
    cbbFileSizeUpper.Text := FFileSizeUpperStr;

    // By File Date
    chFilterFileDate.Checked := FFilterFileDate;
    cbbAllowFileDate.ItemIndex := FFilterFileDateAllow;
    rbFileDateAfter.Checked := FFilterFileDateMethod = 0;
    rbFileDateBefore.Checked := FFilterFileDateMethod = 1;
    rbFileDateBetween.Checked := FFilterFileDateMethod = 2;
    rbFileDateLast.Checked := FFilterFileDateMethod = 3;
    deFileDateAfter.Date := FFileDateAfter;
    deFileDateBefore.Date := FFileDateBefore;
    deFileDateLower.Date := FFileDateLower;
    deFileDateUpper.Date := FFileDateUpper;
    seFileDateLast.Value := FFileDateLast;
    cbbFileDateLast.ItemIndex := FFileDateLastMethod;

    // By Folder Size
    chFilterFolderSize.Checked := FFilterFolderSize;
    cbbAllowFolderSize.ItemIndex := FFilterFolderSizeAllow;

    rbFolderSizeBigger.Checked := FFilterFolderSizeMethod = 0;
    rbFolderSizeSmaller.Checked := FFilterFolderSizeMethod = 1;
    rbFolderSizeInbetween.Checked := FFilterFolderSizeMethod = 2;

    cbbFolderSizeBigger.Text := FFolderSizeBiggerStr;
    cbbFolderSizeSmaller.Text := FFolderSizeSmallerStr;
    cbbFolderSizeLower.Text := FFolderSizeLowerStr;
    cbbFolderSizeUpper.Text := FFolderSizeUpperStr;

    // By Image
    chFilterImage.Checked := FFilterImage;
    cbbAllowImage.ItemIndex := FFilterImageAllow;
    rbImageSquare.Checked := FFilterImageMethod = 0;
    rbImageCompress.Checked := FFilterImageMethod = 1;
    cbbImageSquare.ItemIndex := FFilterImageSquareMethod;
    cbbSquarePixels.Text := FFilterSquarePixelsStr;
    cbbImageCompress.ItemIndex := FFilterImageCompressMethod;
    seCompression.Value := FFilterCompressionVal;

    ValidateTabs(Self);

    DetermineFilterType;
    pcFilter.ActivePageIndex := cFilterTabIndex[FilterType];
  end;
  except
  // silent exception
  end;
end;

procedure TStandardFrame.ValidateTabs(Sender: TObject);
begin
  // Image tab
  lbSquarePixels.Caption := Format('(%d pixels)',
    [SquareStrToInt(cbbSquarePixels.Text)]);
end;

{ TStandardItem }

destructor TStandardItem.Destroy;
begin
  if assigned(FMasks) then
    FreeAndNil(FMasks);
  inherited;
end;

procedure TStandardItem.CreateFilterParams;
begin
  Options := Options + [biAllowRemove];
  FMasks := TObjectList.Create;

  DialogCaption := 'Specify Filter Parameters';
  DialogIcon := 1;

  // add a standard filter with OnAcceptItem connected to StandardItem
  Filter := TFilter.Create;
  with TFilter(Filter) do begin
    ExpandedSelection := True;
    OnAcceptItem := FilterAcceptItem;
  end;

  // Defaults FileType
  FFileTypeImagesStr := cDefaultImagesStr;
  FFileTypeAudioStr := cDefaultAudioStr;
  FFileTypeVideoStr := cDefaultVideoStr;
  FFileTypeCustomStr := cDefaultCustomStr;

  // Defaults FileMask
  FFileMaskStr := 'Dscf####.jpg';

  // Defaults FileSize
  FFilterFileSizeMethod := -1;
  FFileSizeBiggerStr := '20K';
  FFileSizeSmallerStr:= '100K';
  FFileSizeLowerStr := '20K';
  FFileSizeUpperStr := '100K';

  // Defaults FileDate
  FFileDateAfter := Date - 7;
  FFileDateBefore := Date - 7;
  FFileDateLower := Date - 14;
  FFileDateUpper := Date - 3;
  FFileDateLast := 5;

  // Defaults Image
  FFilterSquarePixelsStr := '640x480';
  FFilterCompressionVal := 0.3;

  DetermineFilterType;
  // Set frame class
  FrameClass := TStandardFrame;
end;

procedure TStandardItem.DetermineFilterType;
var
  FSubType: TFilterType;
begin
  FFilterType := ftNone;

  if FFilterFileType then
    if FFilterType = ftNone then
      FFilterType := ftByFileType
    else
      FFilterType := ftVarious;

  if FFilterFileMask then
    if FFilterType = ftNone then
      FFilterType := ftByMask
    else
      FFilterType := ftVarious;

  if FFilterFileSize then
    if FFilterType = ftNone then
      FFilterType := ftByFileSize
    else
      FFilterType := ftVarious;

  if FFilterFileDate then
    if FFilterType = ftNone then
      FFilterType := ftByFileDate
    else
      FFilterType := ftVarious;

  if FFilterImage then
    if FFilterType = ftNone then
      FFilterType := ftImageProps
    else
      FFilterType := ftVarious;

  if FFilterType = ftByFileType then begin
    FSubType := ftNone;
    // Images, Audio, Video?
    if FFileTypeImages then
      if FSubType = ftNone then
        FSubType := ftFilterImages
      else
        FSubType := ftVarious;
    if FFileTypeAudio then
      if FSubType = ftNone then
        FSubType := ftFilterAudio
      else
        FSubType := ftVarious;
    if FFileTypeVideo then
      if FSubType = ftNone then
        FSubType := ftFilterVideo
      else
        FSubType := ftVarious;
    if not (FSubType in [ftNone, ftVarious]) then
      FFilterType := FSubType;

  end;
  ImageIndex := cFilterImageIndex[FFilterType];
  Caption := cStdFilterName[FilterType];
end;

procedure TStandardItem.FilterAcceptItem(Sender: TObject; Item: TsdItem; var Accept: boolean);
var
  TmpAccept: boolean;
  i, NumFiles: integer;
  Size, Ratio: double;
  SqPix: cardinal;
begin
  Accept := False;
  if not assigned(Item) then exit;

  case Item.ItemType of
  itFile:
  with TsdFile(Item) do begin

    // Filter on File Type
    if FFilterFileType then begin
      TmpAccept := False;
      if FFileTypeImages then
        TmpAccept := TmpAccept or (Pos(LowerCase(Extension), FFileTypeImagesStr) > 0);
      if FFileTypeAudio then
        TmpAccept := TmpAccept or (Pos(LowerCase(Extension), FFileTypeAudioStr) > 0);
      if FFileTypeVideo then
        TmpAccept := TmpAccept or (Pos(LowerCase(Extension), FFileTypeVideoStr) > 0);
      if FFileTypeCustom then
        TmpAccept := TmpAccept or (Pos(LowerCase(Extension), FFileTypeCustomStr) > 0);
      case FFilterFileTypeAllow of
      0: Accept := Accept or TmpAccept; // Allow
      1: Accept := Accept or not TmpAccept; // Deny
      end;//case
    end;

    // Filter on FileMask
    if FFilterFileMask then begin
      TmpAccept := False;
      for i := 0 to FMasks.Count - 1 do
        with TMask(FMasks[i]) do
          TmpAccept := TmpAccept or Matches(Name);
      case FFilterFileMaskAllow of
      0: Accept := Accept or TmpAccept; // Allow
      1: Accept := Accept or not TmpAccept; // Deny
      end;//case
    end;

    // Filter on File Size
    if FFilterFileSize then begin
      TmpAccept := False;
      case FFilterFileSizeMethod of
      // Bigger than
      0: TmpAccept := Size > FFileSizeBigger;
      // Smaller than
      1: TmpAccept := Size < FFileSizeSmaller;
      // Inbetween
      2: TmpAccept := (Size >= FFileSizeLower) AND (Size <= FFileSizeUpper);
      end;//case
      case FFilterFileSizeAllow of
      0: Accept := Accept or TmpAccept; // Allow
      1: Accept := Accept or not TmpAccept; // Deny
      end;//case
    end;

    // Filter on File Date
    if FFilterFileDate then begin
      TmpAccept := False;
      case FFilterFileDateMethod of
      // After
      0: TmpAccept := Modified > FFileDateAfter;
      // Before
      1: TmpAccept := Modified < FFileDateBefore;
      // Between
      2: TmpAccept := (Modified >= FFileDateLower) AND (Modified <= FFileDateUpper);
      // Last
      3: TmpAccept := (Modified >= FFileDateLastValue);
      end;//case
      case FFilterFileDateAllow of
      0: Accept := Accept or TmpAccept; // Allow
      1: Accept := Accept or not TmpAccept; // Deny
      end;//case
    end;

    // Filter on Image props
    if FFilterImage then begin
      TmpAccept := False;
      case FFilterImageMethod of
      0: // Image Square
        if SquarePixels(SqPix) then
          case FFilterImageSquareMethod of
          // Exceeding
          0: TmpAccept := SqPix > FFilterSquarePixels;
          // Exactly equal to
          1: TmpAccept := SqPix = FFilterSquarePixels;
          // Smaller than
          2: TmpAccept := SqPix < FFilterSquarePixels;
          end;//case
      1: // Image Compression
        if CompressionRatio(Ratio) then
          case FFilterImageCompressMethod of
          // Larger than
          0: TmpAccept := Ratio > FFilterCompressionVal;
          // Smaller than (or equal to)
          1: TmpAccept := Ratio <= FFilterCompressionVal;
          end;//case
      end;//case
      case FFilterImageAllow of
      0: Accept := Accept or TmpAccept; // Allow
      1: Accept := Accept or not TmpAccept; // Deny
      end;//case
    end;
  end;
  itFolder:
  with TsdFolder(Item) do begin
    // Filter on folder size
    if FFilterFolderSize then begin
      TmpAccept := False;
      GetStatistics(NumFiles, Size);
      Size := Size * 1024; // We need size in bytes, not KB
      case FFilterFolderSizeMethod of
      // Bigger than
      0: TmpAccept := Size > FFolderSizeBigger;
      // Smaller than
      1: TmpAccept := Size < FFolderSizeSmaller;
      // Inbetween
      2: TmpAccept := (Size >= FFolderSizeLower) AND (Size <= FFolderSizeUpper);
      end;//case
      case FFilterFolderSizeAllow of
      0: Accept := Accept or TmpAccept; // Allow
      1: Accept := Accept or not TmpAccept; // Deny
      end;//case
    end;
  end;
  end;//case
end;

procedure TStandardItem.InitialiseFilter;
begin
  // Determine filter type and set correct name
  DetermineFilterType;
  // File Masks need to be initialized
  SetupFileMasks(FFileMaskStr);
  // Set Initialized flag
  Options := Options + [biInitialised];
end;

procedure TStandardItem.SetupFileMasks(MaskStr: string);
//local
procedure CreateMask(AMask: string);
var
  PosC: integer;
begin
  // Prepare string (all '#' become '[0-9]')
  repeat
    PosC := Pos('#', AMask);
    if PosC > 0 then begin
      Delete(AMask, PosC, 1);
      Insert('[0-9]', AMask, PosC);
    end;
  until PosC = 0;
  // Create Mask
  FMasks.Add(TMask.Create(AMask));
end;
var
  PosS: integer;
begin
  // File Masks
  if not assigned(FMasks) then exit;
  FMasks.Clear;

  PosS := Pos(';', MaskStr);
  while PosS > 0 do begin
    CreateMask(Copy(MaskStr, 1, PosS - 1));
    Delete(MaskStr, 1, PosS);
    PosS := Pos(';', MaskStr);
  end;
  if length(MaskStr) > 0 then
    CreateMask(MaskStr);
end;

procedure TStandardFrame.chFileTypeImagesClick(Sender: TObject);
begin
  if chFileTypeImages.Checked then chFilterFileType.Checked := True;
end;

procedure TStandardFrame.chFileTypeAudioClick(Sender: TObject);
begin
  if chFileTypeAudio.Checked then chFilterFileType.Checked := True;
end;

procedure TStandardFrame.chFileTypeVideoClick(Sender: TObject);
begin
  if chFileTypeVideo.Checked then chFilterFileType.Checked := True;
end;

procedure TStandardFrame.chFileTypeCustomClick(Sender: TObject);
begin
  if chFileTypeCustom.Checked then chFilterFileType.Checked := True;
end;

procedure TStandardFrame.btnFileTypeImagesClick(Sender: TObject);
begin
  edFileTypeImages.Text := cDefaultImagesStr;
end;

procedure TStandardFrame.btnFileTypeAudioClick(Sender: TObject);
begin
  edFileTypeAudio.Text := cDefaultAudioStr;
end;

procedure TStandardFrame.btnFileTypeVideoClick(Sender: TObject);
begin
  edFileTypeVideo.Text := cDefaultVideoStr;
end;

procedure TStandardFrame.btnFileTypeCustomClick(Sender: TObject);
begin
  edFileTypeCustom.Text := cDefaultCustomStr;
end;

procedure TStandardFrame.cbbSquarePixelsChange(Sender: TObject);
begin
  ValidateTabs(Sender);
end;

end.
