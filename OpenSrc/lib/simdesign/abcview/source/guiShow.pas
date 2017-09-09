{ unit ShowForms

  The form showing the fullscreen version of an image

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit guiShow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ItemLists, ComCtrls, ToolWin, ImgList, StdActns, ActnList, ExtCtrls,
  guiViewer, sdItems, Menus, sdGraphicLoader, sdSortedLists, sdAbcVars;

type
  TfrmShow = class(TForm)
    nbMain: TNotebook;
    vwFile: TViewer;
    cbFile: TControlBar;
    sbFile: TStatusBar;
    alShowForm: TActionList;
    GoLeft: TAction;
    GoRight: TAction;
    Maximize: TAction;
    NormalWin: TAction;
    SlideShow: TAction;
    Randomize: TAction;
    SortName: TAction;
    SortDate: TAction;
    OptionsDlg: TAction;
    ZoomOut: TAction;
    ZoomIn: TAction;
    SetAsBackground: TAction;
    SortSeries: TAction;
    ItemDelete: TAction;
    SortSize: TAction;
    HelpContents: THelpContents;
    ItemRemove: TAction;
    SortDir: TAction;
    WindowsToolbar: TAction;
    ActionsToolbar: TAction;
    SortingToolbar: TAction;
    ItemsToolbar: TAction;
    ZoomFit: TAction;
    ImageUp: TAction;
    ImageDn: TAction;
    ImageLeft: TAction;
    ImageRight: TAction;
    ilMenu: TImageList;
    tbWindow: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton21: TToolButton;
    tbActions: TToolBar;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton18: TToolButton;
    ToolBar3: TToolBar;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    pmShowForm: TPopupMenu;
    PreviousItem1: TMenuItem;
    NextItem1: TMenuItem;
    N1: TMenuItem;
    Maximize1: TMenuItem;
    NormalWindow1: TMenuItem;
    N2: TMenuItem;
    Randomizelist1: TMenuItem;
    Sorting1: TMenuItem;
    SortonName1: TMenuItem;
    SortonDate1: TMenuItem;
    SwitchDirection1: TMenuItem;
    SortFolder: TAction;
    ByFolder1: TMenuItem;
    SlideShow1: TMenuItem;
    N3: TMenuItem;
    Item1: TMenuItem;
    Lossless1: TMenuItem;
    N4: TMenuItem;
    DeleteItems1: TMenuItem;
    RemoveItems1: TMenuItem;
    N5: TMenuItem;
    ItemProperties: TAction;
    RotateLeft: TAction;
    RotateRight: TAction;
    FlipHor: TAction;
    FlipVer: TAction;
    RotateLeft1: TMenuItem;
    RotateRight1: TMenuItem;
    FlipHorizontal1: TMenuItem;
    FlipVertical1: TMenuItem;
    Options1: TMenuItem;
    N6: TMenuItem;
    SetAsBackground1: TMenuItem;
    Properties1: TMenuItem;
    BySize1: TMenuItem;
    Rotate180: TAction;
    Rotate180deg1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MaximizeExecute(Sender: TObject);
    procedure NormalWinExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ZoomOutExecute(Sender: TObject);
    procedure ZoomInExecute(Sender: TObject);
    procedure ZoomFitExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImageUpExecute(Sender: TObject);
    procedure ImageDnExecute(Sender: TObject);
    procedure ImageLeftExecute(Sender: TObject);
    procedure ImageRightExecute(Sender: TObject);
    procedure alShowFormUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure GoLeftExecute(Sender: TObject);
    procedure GoRightExecute(Sender: TObject);
    procedure WMExitSizeMove(var Message: TMessage); message WM_EXITSIZEMOVE;
    procedure CMMouseWheel(var Message: TCMMouseWheel); message CM_MOUSEWHEEL;
    procedure SlideShowExecute(Sender: TObject);
    procedure RandomizeExecute(Sender: TObject);
    procedure SortNameExecute(Sender: TObject);
    procedure SortDateExecute(Sender: TObject);
    procedure OptionsDlgExecute(Sender: TObject);
    procedure SetAsBackgroundExecute(Sender: TObject);
    procedure ItemDeleteExecute(Sender: TObject);
    procedure ItemRemoveExecute(Sender: TObject);
    procedure SortFolderExecute(Sender: TObject);
    procedure SortDirExecute(Sender: TObject);
    procedure RotateLeftExecute(Sender: TObject);
    procedure RotateRightExecute(Sender: TObject);
    procedure FlipHorExecute(Sender: TObject);
    procedure FlipVerExecute(Sender: TObject);
    procedure vwFilepbPictureDblClick(Sender: TObject);
    procedure ItemPropertiesExecute(Sender: TObject);
    procedure Rotate180Execute(Sender: TObject);
    procedure vwFilepbPictureClick(Sender: TObject);
    procedure vwFilepbPictureMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FBgrColor: TColor;
    FOldLeft, FOldTop, FOldWidth, FOldHeight: integer;
    FShift: TShiftState;
    FLoader: TsdGraphicLoader;
  protected
    procedure SetNormalWindow;
    procedure SetMaximizedWindow;
    procedure SetBgrImage(const AValue: TPicture);
    procedure ViewerStatus(Sender: TObject; AMessage: string);
  public
    // Assign a TGraphic to Background to show an image for the background,
    // or if unassigned, the control's background will be filled with Color.
    property BgrColor: TColor read FBgrColor write FBgrColor;
    property BgrImage: TPicture write SetBgrImage;
    function IsFullscreen: boolean;
    procedure SetBackground(AFile: string; AColor: TColor);
    procedure SnapToMain;
    procedure ValidateToolbars;
  end;

type

  // TShowMngr will manage all "show" requests from the main application and will
  // control the ShowForm, so that it shows the correct file/group/series etc.
  // TShowMngr is directly connected to Root
  TShowMngr = class(TItemMngr)
  private
    FCurrentGuid: TGUID;
  protected
    procedure DoDecodeFile(AItem: TsdItem);
    procedure DoShowFile(AItem: TsdItem);
    // PictureCallback is called by the PictureMngr thread whenever a picture is
    // decoded.
    procedure PictureCallback(Sender: TObject; const AGuid: TGUID);
    // PictureProgress is called by the PictureMngr whenever a progress event is
    // generated in the decoding thread.
    procedure PictureProgress(Sender: TObject; AMessage: string);
    // ResampleCallback is called by the PictureMngr thread whenever a picture is
    // resampled.
    procedure ResampleCallback(Sender: TObject; const AGuid: TGUID);
    procedure SetCurrentGuid(const AValue: TGUID);
    procedure ShowBitmap(ABitmap: TBitmap);
    procedure ShowPictureError(AItem: TsdItem);
    procedure ShowPictureInfo(AItem: TsdItem);
    procedure ShowTitleInfo(AItem: TsdItem);
  public
    // ItemID is the currently shown item in the ShowForm. Assign a valid itemID
    // of one of the items in Root to activate the window, assign 0 to clear the
    // window.
    property CurrentGuid: TGUID read FCurrentGuid write SetCurrentGuid;
    procedure ClearItems(Sender: TObject); override;
    // Filename will return the filename of ItemID, or an empty string if none or n/a
    function FileName: string;
    procedure RemoveItems(Sender: TObject; AList: TList); override;
    procedure UpdateItems(Sender: TObject; AList: TList); override;
    procedure ViewerGetResample(Sender: TObject; AWidth, AHeight: integer;
      AResample: TBitmap; var ASuccess: boolean);
  end;

var

  frmShow: TfrmShow = nil;
  ShowMngr: TShowMngr;

const

  // Number of scale factors available
  ScaleFactorCount = 11;

  // Scale factors used for Zoom in and Zoom out
  ScaleFactors: array[0 .. ScaleFactorCount-1] of double =
   (0.125, 0.176776695, 0.25, 0.35355339, 0.5, 0.707106781, 1, 1.414213562, 2, 2.828427125, 4{, 5.656854249, 8});

implementation

{$R *.DFM}

uses
  sdProperties, guiMain, guiActions, sdRoots;

{ TShowForm }

procedure TfrmShow.WMExitSizeMove(var Message: TMessage);
begin
  inherited;
  vwFile.ExitSizeMove;
  Message.Result := 0;
end;

procedure TfrmShow.CMMouseWheel(var Message: TCMMouseWheel);
begin
  inherited;
  if not FAdvanceMouseWheel then
    exit;

  if Message.Result = 0  then
  with Message do
  begin
    Result := 1;

    if WheelDelta > 0 then
    begin
      // Move next
      GoRightExecute(Self);
    end else
    begin
      GoLeftExecute(Self)
    end;

  end;
end;

procedure TfrmShow.SetNormalWindow;
var
  LV: TListView;
begin
  if not IsFullscreen then
    exit;

  vwFile.IsResizing := True;
  try
    // Restore old size
    WindowState := wsNormal;
    SetBounds(FOldLeft, FOldTop, FOldWidth, FOldHeight);
    BorderStyle := bsSizeable;
    ValidateToolbars;
    vwFile.ShrinkToFit := FWinShrinkFit;
    vwFile.GrowToFit := FWinGrowFit;

    // Scroll focused item into view
    if assigned(frmMain.View) then
    begin
      LV := frmMain.View.Listview;
      if assigned(LV.ItemFocused) then
        LV.ItemFocused.MakeVisible(True);
    end;

  finally
    vwFile.IsResizing := False;
  end;
end;

procedure TfrmShow.ViewerStatus(Sender: TObject; AMessage: string);
begin
  sbFile.SimpleText := AMessage;
end;

procedure TfrmShow.SetMaximizedWindow;
begin
  if IsFullscreen then
    exit;

  FOldLeft := Left;
  FOldTop := Top;
  FOldWidth := Width;
  FOldHeight := Height;
  // This will avoid a recreation of the buffer
  vwFile.IsResizing := True;
  try
    // Maximize window
    WindowState := wsMaximized;
    BorderStyle := bsNone;
    ValidateToolbars;
    vwFile.ShrinkToFit := FFullShrinkFit;
    vwFile.GrowToFit := FFullGrowFit;
  finally
    // This will force the buffer to recreate
    vwFile.IsResizing := False;
  end;
end;

procedure TfrmShow.SetBgrImage(const AValue: TPicture);
begin
  // The control bar
  cbFile.Picture := AValue;
  // Invalidate does not work with speedbuttons, so do this trick:
  if cbFile.Visible then
  begin
    cbFile.Hide;
    Application.ProcessMessages;
    cbFile.Show;
  end;

  // The File Viewer
  vwFile.Background := AValue;
  vwFile.invalidate;
end;

function TfrmShow.IsFullscreen: boolean;
begin
  Result := (WindowState = wsMaximized);
end;

procedure TfrmShow.SetBackground(AFile: string; AColor: TColor);
var
  Picture: TPicture;
begin

  // Set the background
  Picture := TPicture.Create;
  try
    if FLoader.LoadFromFile(AFile) = gsGraphicsOK then
    begin
      Picture.Assign(FLoader.Bitmap);
      BgrImage := Picture;
    end else
      BgrImage := nil;
    Color := AColor;
    cbFile.Color := clBtnFace;
  finally
    Picture.Free;
  end;
  Invalidate;
end;

procedure TfrmShow.FormCreate(Sender: TObject);
begin
  FLoader := TsdGraphicLoader.Create;
  // Our frames need initialization
  vwFile.Initialize(Self);

  // Connect events
  vwFile.OnStatus := ViewerStatus;
  vwFile.OnGetResample := ShowMngr.ViewerGetResample;

end;

procedure TfrmShow.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLoader);
  // Our frames need finalization
  vwFile.Finalize(Self);
end;

procedure TfrmShow.SnapToMain;
begin
  Left := frmMain.Left + 3;
  Top := frmMain.Top + frmMain.Height - Height - frmMain.sbMain.Height - 3;
end;

procedure TfrmShow.ValidateToolbars;
begin
  // Validate the settings in the INI file
  case WindowState of
  wsNormal:
    begin
      cbFile.Visible := FWinShowToolbars;
      sbFile.Visible := FWinShowToolbars;
    end;
  wsMaximized:
    begin
      cbFile.Visible := FFullShowToolbars;
      sbFile.Visible := FFullShowToolbars;
    end;
  end;
end;

procedure TfrmShow.MaximizeExecute(Sender: TObject);
begin
  SetMaximizedWindow;
end;

procedure TfrmShow.NormalWinExecute(Sender: TObject);
begin
  SetNormalWindow;
  frmMain.View.ListView.SetFocus;
end;

procedure TfrmShow.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case UpCase(Key) of
  #13: // [Enter]
    if IsFullScreen then
      NormalWinExecute(Sender)
    else
      MaximizeExecute(Sender);
  #27: // [Esc]
    begin
      NormalWinExecute(Self);
      // Stop the slideshow
      if FSlideshow then
        dmActions.SlideShowExecute(Self);
    end;
  '+': ZoomInExecute(Self);
  '-': ZoomOutExecute(Self);
  'F', '*': ZoomFitExecute(Self);
  end;
end;

procedure TfrmShow.ZoomOutExecute(Sender: TObject);
var
  i: integer;
begin
  for i := ScaleFactorCount - 2 downto 0 do
    if ScaleFactors[i] < (vwFile.Scale - 0.005) then
    begin
      vwFile.Scale := ScaleFactors[i];
      break;
    end;
end;

procedure TfrmShow.ZoomInExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to ScaleFactorCount - 1 do
    if ScaleFactors[i] > (vwFile.Scale + 0.005) then
    begin
      vwFile.Scale := ScaleFactors[i];
      break;
    end;
end;

procedure TfrmShow.ZoomFitExecute(Sender: TObject);
begin
  vwFile.DoZoomFit;
end;

procedure TfrmShow.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Virtual key codes
  case Key of
  VK_PAUSE: dmActions.SlideShowExecute(Self);  // Pause key
  // these are now handled by hotkeys in actions, so commented out here
  //  VK_DELETE: dmActions.ItemDeleteExecute(Self); // Delete key
  //  VK_PRIOR: dmActions.GoLeftExecute(Self);     // PgUp key
  //  VK_NEXT : dmActions.GoRightExecute(Self);    // PgDn key
  end;//case
end;

procedure TfrmShow.ImageUpExecute(Sender: TObject);
begin
  // Move up in the image
  vwFile.DragImage(0, 20);
end;

procedure TfrmShow.ImageDnExecute(Sender: TObject);
begin
  // Move down in the image
  vwFile.DragImage(0, -20);
end;

procedure TfrmShow.ImageLeftExecute(Sender: TObject);
begin
  // Move left in the image
  vwFile.DragImage(20, 0);
end;

procedure TfrmShow.ImageRightExecute(Sender: TObject);
begin
  // Move right in the image
  vwFile.DragImage(-20, 0);
end;

procedure TfrmShow.alShowFormUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin

  Maximize.Enabled := not IsFullscreen;
  NormalWin.Enabled := IsFullscreen;

  GoLeft.Enabled := dmActions.GoLeftEnabled;
  GoRight.Enabled := dmActions.GoRightEnabled;

  with SlideShow do
  begin
    Checked := FSlideShow;
    if FSlideShow then
      ImageIndex := 17
    else
      ImageIndex := 10;
  end;

  Handled := True;
end;

procedure TfrmShow.GoLeftExecute(Sender: TObject);
begin
  // We have to pass on to main
  dmActions.GoLeft.Execute;
end;

procedure TfrmShow.GoRightExecute(Sender: TObject);
begin
  // We have to pass on to main
  dmActions.GoRight.Execute;
end;

procedure TfrmShow.SlideShowExecute(Sender: TObject);
begin
  dmActions.SlideShowExecute(Sender);
end;

procedure TfrmShow.RandomizeExecute(Sender: TObject);
begin
  dmActions.RandomizeExecute(Sender);
end;

procedure TfrmShow.SortNameExecute(Sender: TObject);
begin
  dmActions.SortNameExecute(Sender);
end;

procedure TfrmShow.SortDateExecute(Sender: TObject);
begin
  dmActions.SortDateExecute(Sender);
end;

procedure TfrmShow.OptionsDlgExecute(Sender: TObject);
begin
  dmActions.OptionsDlgExecute(Sender);
end;

procedure TfrmShow.SetAsBackgroundExecute(Sender: TObject);
var
  AItem: TsdItem;
begin
  // Set the current image as background
  with ShowMngr do
  begin
    AItem := TsdItem(Root.ItemByGuid(CurrentGuid));
    if assigned(AItem) and (AItem.ItemType = itFile) then
      FShowBgrFile := TsdFile(AItem).FileName;
    SetBackground(FShowBgrFile, BgrColor);
  end;
end;

procedure TfrmShow.ItemDeleteExecute(Sender: TObject);
begin
  dmActions.ItemDeleteExecute(Sender);
end;

procedure TfrmShow.ItemRemoveExecute(Sender: TObject);
begin
  dmActions.ItemRemoveExecute(Sender);
end;

procedure TfrmShow.SortFolderExecute(Sender: TObject);
begin
  dmActions.SortFolderExecute(Sender);
end;

procedure TfrmShow.SortDirExecute(Sender: TObject);
begin
  dmActions.SortDirExecute(Sender);
end;

procedure TfrmShow.RotateLeftExecute(Sender: TObject);
begin
  frmMain.View.RotateLeftExecute(Sender);
end;

procedure TfrmShow.RotateRightExecute(Sender: TObject);
begin
  frmMain.View.RotateRightExecute(Sender);
end;

procedure TfrmShow.Rotate180Execute(Sender: TObject);
begin
  frmMain.View.Rotate180Execute(Sender);
end;

procedure TfrmShow.FlipHorExecute(Sender: TObject);
begin
  frmMain.View.FlipHorExecute(Sender);
end;

procedure TfrmShow.FlipVerExecute(Sender: TObject);
begin
  frmMain.View.FlipVerExecute(Sender);
end;

procedure TfrmShow.vwFilepbPictureDblClick(Sender: TObject);
begin
  // Double click.. Maximise or minimise
  if IsFullscreen then
    NormalWinExecute(Sender)
  else
    MaximizeExecute(Sender);
end;

procedure TfrmShow.vwFilepbPictureClick(Sender: TObject);
begin
  // Mouse Click.. Progress to next item
  if FAdvanceMouseClick and not vwFile.WasDragging then
    // Use the stored shift state value (stored in MouseDown)
    if ssShift in FShift then
      GoLeftExecute(Sender)
    else
      GoRightExecute(Sender);
  vwFile.WasDragging := False;
end;

procedure TfrmShow.ItemPropertiesExecute(Sender: TObject);
begin
  frmMain.View.PropertiesExecute(Sender);
end;

procedure TfrmShow.vwFilepbPictureMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // The frame
  vwFile.pbPictureMouseDown(Sender, Button, Shift, X, Y);

  // Store shiftstate
  FShift := Shift;
end;

{ TShowMngr }

procedure TShowMngr.ShowPictureError(AItem: TsdItem);
var
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  try

  if assigned(AItem) then
  with AItem do
  begin
    // Didn't decode.. so try to get an icon
    if assigned(FLargeIcons) AND (Icon >= 0) then
    begin

      FLargeIcons.GetBitmap(Icon, Bitmap);

    end else
    begin

      // Nothing worked: draw a red cross
      with Bitmap do
      begin
        Width  := 100;
        Height := 100;
        with Canvas do
        begin
          Pen.Color := clRed;
          Pen.Width := 5;
          PenPos := point(0, 0);
          LineTo(100, 100);
          PenPos := point(0, 99);
          LineTo(100, -1);
        end;
      end;

    end;
  end;

  ShowBitmap(Bitmap);
  finally
    Bitmap.Free;
  end;
  frmShow.ViewerStatus(Self, 'Unable to decode item.');
end;

procedure TShowMngr.ShowPictureInfo(AItem: TsdItem);
begin
  // to do: Put picture information on status bar
end;

procedure TShowMngr.ShowBitmap(ABitmap: TBitmap);
var
  Picture: TPicture;
begin
  if assigned(ABitmap) then
  begin

    // Recreate a TPicture object
    Picture := TPicture.Create;
    try
      Picture.Assign(ABitmap);

      // Assign it to the Showform
      frmShow.vwFile.Picture := Picture;

    finally
      // Free the picture
      FreeAndNil(Picture);
    end;

  end else

    // We have no bitmap, so clear the picture in showform
    frmShow.vwFile.Picture := nil;
end;

procedure TShowMngr.PictureCallback(Sender: TObject; const AGuid: TGUID);
var
  Bitmap: TBitmap;
  Item: TsdItem;
begin
  // We arrive here when the background thread has decoded the item

  // The item id changed in the meantime.. we will ignore any previous callbacks
  if not IsEqualGuid(AGuid, FCurrentGuid) then
    exit;

  Bitmap := TBitmap.Create;
  try

    Item := Root.ItemByGuid(AGuid);

    // Decode the picture belonging to Item (a TFile object)
    if assigned(Item) then
    with Item do
    begin

      ShowTitleInfo(Item);
      case HasGraphic(rtGraphic, rpHigh, 0, 0, PictureCallback, Bitmap) of
      grOK:
        begin
          // Show the bitmap
          ShowBitmap(Bitmap);
          // Show Picture info
          ShowPictureInfo(Item);
        end;
      grDecodeErr:
          ShowPictureError(Item);
      else
        // Not a grahics file? Show Icon!
        if Icon >= 0 then
        begin
          FLargeIcons.GetBitmap(Icon, Bitmap);
          ShowBitmap(Bitmap);
          if Item is TsdFile then
            frmShow.sbFile.SimpleText := TsdFile(Item).FileType;
        end;
      end;//case

    end;

  finally
    FreeAndNil(Bitmap);
  end;
end;

procedure TShowMngr.PictureProgress(Sender: TObject; AMessage: string);
begin
  // We get feedback from current picture decoding thread
  frmShow.sbFile.SimpleText := AMessage;
end;

procedure TShowMngr.ResampleCallback(Sender: TObject; const AGuid: TGUID);
var
  Bitmap: TBitmap;
  Width,
  Height: integer;
begin
  // The item id changed in the meantime.. we will ignore any previous callbacks
  if not IsEqualGuid(AGuid, FCurrentGuid) then
    exit;

  if (not IsEmptyGuid(AGuid)) and assigned(Root) then
  begin

    Width := frmShow.vwFile.Scaled.Width;
    Height := frmShow.vwFile.Scaled.Height;

    Bitmap := TBitmap.Create;
    try
      // Do a request for the graphic
      case TsdRoot(Root).Mngr.HasGraphic(AGuid, rtResample, rpMedium, Width, Height,
        Bitmap) of
      grOK:
        // It is there
        frmShow.vwFile.Scaled := Bitmap;
      end;//case
    finally
      Bitmap.Free;
    end;
  end;
end;

procedure TShowMngr.ShowTitleInfo(AItem: TsdItem);
begin
  if assigned(AItem) then
  begin

    // Add Form Title
    case AItem.ItemType of
    itFile:
      with TsdFile(AItem) do
      begin
        frmShow.Caption := Format('%s (%d bytes)',
          [FileName, Size]);
      end;
    else
      frmShow.Caption := AItem.Name;
    end;//case
  end else
  begin
    frmShow.Caption := 'No item selected';
  end;

  // Clear status bar
  frmShow.sbFile.SimpleText := '';

end;

procedure TShowMngr.DoDecodeFile(AItem: TsdItem);
var
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  try

    // Decode the picture belonging to AItem (a TFile object)
    if assigned(AItem) then
    with AItem do
    begin

      // Do a request for the graphic
      case GetGraphic(rtGraphic, rpHigh, 0, 0, 1, PictureCallback, PictureProgress, Bitmap) of
      grOK:
        // It is there
        begin
          ShowTitleInfo(AItem);
          // Show the bitmap
          ShowBitmap(Bitmap);
          // Show Picture info
          ShowPictureInfo(AItem);
        end;
      grDelayed:
        // It is delayed, it will pop up in PictureCallback
        frmShow.ViewerStatus(Self, 'Processing...');
      grDecodeErr:
        // A decoding error
        begin
          ShowTitleInfo(AItem);
          ShowBitmap(nil);
          ShowPictureError(AItem);
        end;
      end;//case

    end else
    begin
      ShowTitleInfo(nil);
      ShowBitmap(nil);
      frmShow.ViewerStatus(Self, '');
    end;

  finally
    FreeAndNil(Bitmap);
  end;

end;

procedure TShowMngr.DoShowFile(AItem: TsdItem);
begin
  if not assigned(frmShow) or (csDestroying in frmShow.ComponentState) then
    exit;

  // setup the "File" page
  frmShow.nbMain.ActivePage := 'File';

  // Decode request
  DoDecodeFile(AItem);

  // Show the form
  if assigned(AItem) then
    frmShow.Visible := True;
end;

procedure TShowMngr.SetCurrentGuid(const AValue: TGUID);
var
  Item: TsdItem;
begin
  if not assigned(Root) then
    exit;
  if not IsEqualGuid(AValue, FCurrentGuid) then
  begin
    FCurrentGuid := AValue;

    // Find the item
    Root.LockRead;
    try
      Item := nil;
      if not IsEmptyGuid(FCurrentGuid) then
        Item := Root.ItemByGuid(FCurrentGuid);

      if assigned(Item) then
      begin

        if (Item is TsdFile) then
          DoShowFile(Item);

      end else
      begin
        // Empty item
        DoShowFile(nil);
      end;

    finally
      Root.UnlockRead;
    end;
  end;
end;

procedure TShowMngr.ClearItems(Sender: TObject);
begin
  CurrentGuid := cEmptyGuid;
end;

function TShowMngr.FileName: string;
var
  Item: TsdItem;
begin
  Result := '';
  Item := Root.ItemByGuid(CurrentGuid);
  if assigned(Item) then
  with Item do
  begin
    case ItemType of
    itFile: Result := TsdFile(Item).Filename;
    end;//case
  end;
end;

procedure TShowMngr.RemoveItems(Sender: TObject; AList: TList);
var
  i: integer;
begin
  // Check if we're displaying any of the items in the remove list
  for i := 0 to AList.Count - 1 do
    if IsEqualGuid(TsdItem(AList[i]).Guid, CurrentGuid) then
    begin
      // If so, quit showing them
      CurrentGuid := cEmptyGuid;
      break;
    end;
end;

procedure TShowMngr.UpdateItems(Sender: TObject; AList: TList);
var
  i: integer;
begin
  for i := 0 to AList.Count - 1 do
    if IsEqualGuid(TsdItem(AList[i]).Guid, CurrentGuid) then
    begin
      // show none
      CurrentGuid := cEmptyGuid;
      // switch back
      CurrentGuid := TsdItem(AList[i]).Guid;
      break;
    end;
end;

procedure TShowMngr.ViewerGetResample(Sender: TObject; AWidth, AHeight: integer;
  AResample: TBitmap; var ASuccess: boolean);
begin
  // Here we handle resample requests
  ASuccess := False;
  if FResamplingOnTheFly and
    ((not FSlideShow) or (FSlideShow and FResampleWhenSlide)) then
    begin

    // Resample the picture belonging to ItemID
    if (not IsEmptyGuid(CurrentGuid)) and assigned(Root) then
    begin

      // Do a request for the graphic
      case TsdRoot(Root).Mngr.GetGraphic(CurrentGuid, rtResample, rpMedium, AWidth, AHeight,
        FResamplingDelay, ResampleCallback, nil, AResample) of
      // It is there
      grOK: ASuccess := True;

      end;//case
    end;
  end;
end;

end.
