{ Unit Actions

  This unit implements the main actions with their execute methods.

  alActions contains the action list for the main application

  snMain is the ShellNotify hook that ABC-View uses to get informed about
  all kinds of shell changes.

  Initial release: 20-12-2000

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiActions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShellAPI, ImgList, StdActns, ActnList, Printers, sdItems, kbShellNotify,
  Clipbrd, ComCtrls, guiItemView, sdSortedLists, sdAbcTypes, sdAbcVars,
  sdAbcFunctions;

type
  TdmActions = class(TDataModule)
    alActions: TActionList;
    MenuToolbar: TAction;
    FileOpen: TAction;
    FileNew: TAction;
    ViewLarge: TAction;
    ViewSmall: TAction;
    ViewList: TAction;
    ViewDetail: TAction;
    ExitAction: TAction;
    FileSave: TAction;
    ViewThumb: TAction;
    SingleView: TAction;
    DualView: TAction;
    AddFolders: TAction;
    RefreshAll: TAction;
    Preview: TAction;
    GoLeft: TAction;
    GoRight: TAction;
    Maximize: TAction;
    NormalWin: TAction;
    SlideShow: TAction;
    EmailFriend: TAction;
    Randomize: TAction;
    SortName: TAction;
    SortDate: TAction;
    CreateCD: TAction;
    OptionsDlg: TAction;
    ZoomOut: TAction;
    ZoomIn: TAction;
    FileSaveAs: TAction;
    SetAsBackground: TAction;
    SortSeries: TAction;
    ItemDelete: TAction;
    SortSize: TAction;
    HelpContents: THelpContents;
    About: TAction;
    GotoWeb: TAction;
    ItemRemove: TAction;
    SortDir: TAction;
    CatalogToolbar: TAction;
    WindowsToolbar: TAction;
    ActionsToolbar: TAction;
    WizardsToolbar: TAction;
    ViewsToolbar: TAction;
    SortingToolbar: TAction;
    ItemsToolbar: TAction;
    BuildWeb: TAction;
    ilMenu: TImageList;
    FileOpenDialog: TOpenDialog;
    FileSaveDialog: TSaveDialog;
    PrinterSetup: TAction;
    PrintPreview: TAction;
    PrintDialog: TAction;
    BgrProcess: TAction;
    RefreshFolder: TAction;
    FileExport: TAction;
    Register: TAction;
    acForum: TAction;
    snMain: TkbShellNotify;
    Copy: TAction;
    Cut: TAction;
    Paste: TAction;
    CopyImage: TAction;
    SelectAll: TAction;
    SelectInvert: TAction;
    RotateLeft: TAction;
    RotateRight: TAction;
    Rotate180: TAction;
    FlipHor: TAction;
    FlipVer: TAction;
    SelectDupes: TAction;
    SelectDupeFolder: TAction;
    SelectSmart: TAction;
    Rename: TAction;
    SortFolder: TAction;
    ChangeFiledate: TAction;
    Tipofday: TAction;
    RotateOri: TAction;
    acDownloadPugins: TAction;
    procedure MenuToolbarExecute(Sender: TObject);
    procedure FileOpenExecute(Sender: TObject);
    procedure FileNewExecute(Sender: TObject);
    procedure ViewLargeExecute(Sender: TObject);
    procedure ViewSmallExecute(Sender: TObject);
    procedure ViewListExecute(Sender: TObject);
    procedure ViewDetailExecute(Sender: TObject);
    procedure ExitActionExecute(Sender: TObject);
    procedure FileSaveExecute(Sender: TObject);
    procedure ViewThumbExecute(Sender: TObject);
    procedure SingleViewExecute(Sender: TObject);
    procedure DualViewExecute(Sender: TObject);
    procedure AddFoldersExecute(Sender: TObject);
    procedure RefreshAllExecute(Sender: TObject);
    procedure PreviewExecute(Sender: TObject);
    procedure GoLeftExecute(Sender: TObject);
    procedure GoRightExecute(Sender: TObject);
    procedure NormalWinExecute(Sender: TObject);
    procedure SlideShowExecute(Sender: TObject);
    procedure EmailFriendExecute(Sender: TObject);
    procedure RandomizeExecute(Sender: TObject);
    procedure SortNameExecute(Sender: TObject);
    procedure SortDateExecute(Sender: TObject);
    procedure CreateCDExecute(Sender: TObject);
    procedure OptionsDlgExecute(Sender: TObject);
    procedure FileSaveAsExecute(Sender: TObject);
    procedure SetAsBackgroundExecute(Sender: TObject);
    procedure ItemDeleteExecute(Sender: TObject);
    procedure SortSizeExecute(Sender: TObject);
    procedure AboutExecute(Sender: TObject);
    procedure GotoWebExecute(Sender: TObject);
    procedure ItemRemoveExecute(Sender: TObject);
    procedure SortDirExecute(Sender: TObject);
    procedure CatalogToolbarExecute(Sender: TObject);
    procedure WindowsToolbarExecute(Sender: TObject);
    procedure ActionsToolbarExecute(Sender: TObject);
    procedure WizardsToolbarExecute(Sender: TObject);
    procedure ViewsToolbarExecute(Sender: TObject);
    procedure SortingToolbarExecute(Sender: TObject);
    procedure ItemsToolbarExecute(Sender: TObject);
    procedure BuildWebExecute(Sender: TObject);
    procedure PrintDialogExecute(Sender: TObject);
    procedure PrinterSetupExecute(Sender: TObject);
    procedure alActionsUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure BgrProcessExecute(Sender: TObject);
    procedure RefreshFolderExecute(Sender: TObject);
    procedure FileExportExecute(Sender: TObject);
    procedure HelpContentsExecute(Sender: TObject);
    procedure acForumExecute(Sender: TObject);
    procedure snMainFolderUpdated(Sender: TObject; PIDL: Pointer;
      Path: TFileName; IsInterrupt: Boolean);
    procedure snMainFolderRenamed(Sender: TObject; OldPIDL: Pointer;
      OldPath: TFileName; NewPIDL: Pointer; NewPath: TFileName;
      IsInterrupt: Boolean);
    procedure snMainFolderCreated(Sender: TObject; PIDL: Pointer;
      Path: TFileName; IsInterrupt: Boolean);
    procedure snMainFolderDeleted(Sender: TObject; PIDL: Pointer;
      Path: TFileName; IsInterrupt: Boolean);
    procedure snMainItemCreated(Sender: TObject; PIDL: Pointer;
      Path: TFileName; IsInterrupt: Boolean);
    procedure snMainItemDeleted(Sender: TObject; PIDL: Pointer;
      Path: TFileName; IsInterrupt: Boolean);
    procedure snMainItemRenamed(Sender: TObject; OldPIDL: Pointer;
      OldPath: TFileName; NewPIDL: Pointer; NewPath: TFileName;
      IsInterrupt: Boolean);
    procedure snMainItemUpdated(Sender: TObject; PIDL: Pointer;
      Path: TFileName; IsInterrupt: Boolean);
    procedure snMainMediaChanged(Sender: TObject; PIDL: Pointer;
      Path: TFileName; IsInterrupt: Boolean);
    procedure CopyExecute(Sender: TObject);
    procedure CutExecute(Sender: TObject);
    procedure PasteExecute(Sender: TObject);
    procedure CopyImageExecute(Sender: TObject);
    procedure SelectAllExecute(Sender: TObject);
    procedure SelectInvertExecute(Sender: TObject);
    procedure RotateLeftExecute(Sender: TObject);
    procedure RotateRightExecute(Sender: TObject);
    procedure Rotate180Execute(Sender: TObject);
    procedure FlipHorExecute(Sender: TObject);
    procedure FlipVerExecute(Sender: TObject);
    procedure RenameExecute(Sender: TObject);
    procedure SortFolderExecute(Sender: TObject);
    procedure ChangeFiledateExecute(Sender: TObject);
    procedure SelectDupesExecute(Sender: TObject);
    procedure SelectDupeFolderExecute(Sender: TObject);
    procedure SelectSmartExecute(Sender: TObject);
    procedure TipofdayExecute(Sender: TObject);
    procedure RotateOriExecute(Sender: TObject);
    procedure acDownloadPuginsExecute(Sender: TObject);
  private
    FPredecodeID: TGUID;
  protected
    procedure PredecodeCallback(Sender: TObject; const AGuid: TGUID);
    procedure FocusOnItem(AView: TItemView; AIndex, APredecodeIndex: integer);
  public
    procedure DoSendToMySelection;
    function GoLeftEnabled: boolean;
    function GoRightEnabled: boolean;
    procedure StopSlideshow;
  end;

var
  dmActions: TdmActions;

implementation

uses
  guiAddFolder, guiOptions, guiAbout, guiMain, guiFolderOptions,
  sdRoots, guiShow, guiEmail,
  sdProcessThread,
  guiExportFormat, guiBuildWeb, sdScanFolders, BrowseTrees,
  guiSelectionItems, guiRenamefiles, guiTipOfDay, sdGraphicLoader, guiProcess;

{$R *.DFM}

procedure TdmActions.FileOpenExecute(Sender: TObject);
begin
  if frmMain.Root.IsChanged then
  begin
    case MessageDlg('You have made changes to the catalog. Do you'+#13#10+
      ('want to save these changes first?'), mtWarning, mbYesNoCancel,0) of
    mrYes:    FileSaveAsExecute(Sender);
    mrCancel: Exit;
    end; //case
  end;

  if length(FLoadSaveFolder) > 0 then
    FileOpenDialog.InitialDir := FLoadSaveFolder;

  // Check Filename
  if FileOpenDialog.Execute then
  begin

    FLoadFilename := FileOpenDialog.Filename;

    // open setup
    if FLoadFilename <> '' then
    begin

      FLoadSaveFolder := IncludeTrailingPathDelimiter(ExtractFileDir(FLoadFileName));

      frmMain.LoadCollection(FLoadFilename);

    end;

  end;
end;

procedure TdmActions.ExitActionExecute(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TdmActions.ViewThumbExecute(Sender: TObject);
// View as thumbnail
begin
  frmMain.View.ViewThumbExecute(Sender);
end;

procedure TdmActions.ViewLargeExecute(Sender: TObject);
// View as large icon
begin
  frmMain.View.ViewLargeExecute(Sender);
end;

procedure TdmActions.ViewSmallExecute(Sender: TObject);
// View as small icon
begin
  frmMain.View.ViewSmallExecute(Sender);
end;

procedure TdmActions.ViewListExecute(Sender: TObject);
// View as list
begin
  frmMain.View.ViewListExecute(Sender);
end;

procedure TdmActions.ViewDetailExecute(Sender: TObject);
// View as detail
begin
  frmMain.View.ViewDetailExecute(Sender);
end;

procedure TdmActions.FileSaveExecute(Sender: TObject);
begin
  // Save the file here
  if not FileExists(FLoadFilename) then
    FileSaveAsExecute(Sender)
  else
    frmMain.SaveCatalog(FLoadFilename);
end;

procedure TdmActions.FileSaveAsExecute(Sender: TObject);
begin
  FileSaveDialog.Filename := FLoadFilename;
  if FileSaveDialog.Execute then
  begin
     FLoadFilename := FileSaveDialog.Filename;
    if length(ExtractFileExt(FLoadFileName)) > 0 then
      ChangeFileExt(FileSaveDialog.Filename, '.abc')
    else
      FLoadFileName := FLoadFileName + '.abc';

    frmMain.SaveCatalog(FLoadFilename);
    frmMain.SetFormTitle;
  end;
end;

procedure TdmActions.SingleViewExecute(Sender: TObject);
begin
  frmMain.SingleView;
end;

procedure TdmActions.DualViewExecute(Sender: TObject);
begin
  // Put into Dual mode
  frmMain.DualView;
end;

procedure TdmActions.AddFoldersExecute(Sender: TObject);
// add a folder
var
  Dlg: TdlgAddFolder;
begin
  // Settings to dialog
  Dlg := TdlgAddFolder.Create(Application);
  try
    Dlg.SettingsToAddFolderDlg;
    if Dlg.ShowModal = mrOK then
    begin
      // Dialog to settings
      Dlg.AddFolderDlgToSettings;

      // And run the scan!
      RunScan(FAddDialogFolder, FFolderOptions.InclSubDirs, FFolderOptions.InclSubDirs, '', '',
        frmMain.RootClearBatchedItems);
    end;
  finally
    Free;
  end;
end;

procedure TdmActions.PreviewExecute(Sender: TObject);
begin
  if Preview.Checked then
  begin

    // Uncheck preview mode
    frmShow.Hide;
    Preview.Checked:=false;

  end else
  begin

    frmShow.Show;
    Preview.Checked:=true;

  end;
end;

procedure TdmActions.FocusOnItem(AView: TItemView; AIndex, APredecodeIndex: integer);
var
  AItem: TsdItem;
  LV: TListView;
begin
  // Set ItemIndex to the new value
  if (AIndex >= 0) and (AIndex < AView.ItemList.Count) then
    AView.ItemIndex := AIndex;

  // Predecode request
  AItem := AView.ItemList[APredecodeIndex];
  if assigned(AItem) then
  begin
    FPredecodeID := AItem.Guid;
    AItem.Request(rtGraphic, rpLow, 0, 0, 0, nil, PredecodeCallback, nil);
  end;

  // Focus on this item
  LV := AView.ListView;
  LV.ItemFocused := LV.Items[AView.ItemIndex];
  LV.Selected := nil;
  LV.Selected := LV.ItemFocused;
    if not frmShow.IsFullscreen and assigned(LV.ItemFocused) then
      LV.ItemFocused.MakeVisible(True);

end;

procedure TdmActions.GoLeftExecute(Sender: TObject);
var
  NewIndex: integer;
  View: TItemView;
begin
  if Sender <> frmMain.FSlideShowThread then
    StopSlideshow;

  View := frmMain.View;
  if assigned(View) then
  begin

    // Move Left
    NewIndex := View.ItemIndex - 1;

    // Wrap around if allowed
    if (NewIndex < 0) and FWrapAround then
      NewIndex := View.ItemList.Count - 1;

    FocusOnItem(View, NewIndex, NewIndex - 1);
  end;
end;

procedure TdmActions.GoRightExecute(Sender: TObject);
var
  NewIndex: integer;
  View: TItemView;
begin
  if Sender <> frmMain.FSlideShowThread then
    StopSlideshow;

  View := frmMain.View;
  if assigned(View) then
  begin

    // Move Left
    NewIndex := View.ItemIndex + 1;

    // Wrap around if allowed
    if (NewIndex >= View.ItemList.Count) and FWrapAround then
      NewIndex := 0;

    FocusOnItem(View, NewIndex, NewIndex + 1);
  end;
end;

procedure TdmActions.NormalWinExecute(Sender: TObject);
begin
  frmShow.NormalWinExecute(Sender);
end;

procedure TdmActions.StopSlideshow;
begin
  // Set back normal cursor
  FSlideshow := False;
  frmShow.vwFile.Cursor := crDefault;
end;

procedure TdmActions.SlideShowExecute(Sender: TObject);
begin
  // Start/stop the slideshow!
  FSlideShow := not FSlideShow;
  if FSlideShow then
  begin
    if FHidemouse then
      frmShow.vwFile.Cursor := crNone;
    frmMain.FSlideShowThread.Status := psRun;
  end else
  begin
    StopSlideShow;
  end;
end;

procedure TdmActions.RandomizeExecute(Sender: TObject);
begin
  frmMain.View.SortByMethod(smRandom, sdAscending);
end;

procedure TdmActions.SortNameExecute(Sender: TObject);
begin
  frmMain.View.SortNameExecute(Sender);
end;

procedure TdmActions.SortDateExecute(Sender: TObject);
begin
  frmMain.View.SortDateExecute(Sender);
end;

procedure TdmActions.SortSizeExecute(Sender: TObject);
begin
  frmMain.View.SortSizeExecute(Sender);
end;

procedure TdmActions.SortDirExecute(Sender: TObject);
begin
  frmMain.View.SortOrderExecute(Sender);
end;

procedure TdmActions.SortFolderExecute(Sender: TObject);
begin
  frmMain.View.SortFolderExecute(Sender);
end;

procedure TdmActions.OptionsDlgExecute(Sender: TObject);
var
  Frm: TfrmOptions;
begin
  Frm := TfrmOptions.Create(Application);
  try
    Frm.SettingsToDlg;
    if Frm.ShowModal = mrOK then
    begin
      Frm.DlgToSettings;
      SettingsToIni(FIniFile);
      // Restart the filethread
      frmMain.Root.MustIndex := True;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TdmActions.FileExportExecute(Sender: TObject);
var
  Frm: TfrmExport;
begin
  Frm := TfrmExport.Create(Application);
  try
    Frm.DoExportWizard;
  finally
    Frm.Free;
  end;
end;

procedure TdmActions.FileNewExecute(Sender: TObject);
begin
  // Check if we can close
  if frmMain.Root.IsChanged then
  begin
    case MessageDlg('Do you want to save the catalog before starting a new one?',
           mtWarning, mbYesNoCancel, 0) of
      mrYes:    FileSaveExecute(Self); // Save
      mrCancel: exit;
    end;
  end;

  // Clear old catalog
  frmMain.Root.ClearItems(Self);
  frmMain.Root.IsChanged := false;

  frmMain.SetFormTitle;
end;

procedure TdmActions.SetAsBackgroundExecute(Sender: TObject);
var
  Filename: string;
begin
  Filename := ShowMngr.Filename;
  frmMain.SetBackground(FileName, FMainBgrColor, FMainBgrFont);
  frmShow.SetBackground(FileName, FMainBgrColor);
end;

procedure TdmActions.ItemDeleteExecute(Sender: TObject);
begin
  // Pass this one on to the focused control
  if assigned(frmMain.View) then
    frmMain.View.ItemDeleteExecute(Sender);
end;

procedure TdmActions.RefreshAllExecute(Sender: TObject);
var
  i: integer;
begin
  // Clear all ffDeleted, ffDecodeErr, ffNoAccess, ffVerified
  for i := 0 to frmMain.Root.Count - 1 do
    frmMain.Root[i].SetStates([isDeleted, isDecodeErr, isNoAccess, isVerified], False);

  // Run the scans
  for i := 0 to frmMain.Root.FAllFolders.Count - 1 do
    RunScan(TsdFolder(frmMain.Root.FAllFolders[i]).FolderName, False, False, '', '',
      frmMain.RootClearBatchedItems);
end;

procedure TdmActions.AboutExecute(Sender: TObject);
var
  Frm: TForm;
begin
  Frm := TfrmAbout.Create(Application);
  try
    Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

procedure TdmActions.GotoWebExecute(Sender: TObject);
begin
  // Go to our webpage
  ShellExecute(frmMain.Handle,'open',pchar(cWebAddress),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TdmActions.ItemRemoveExecute(Sender: TObject);
begin
  // Pass this one on to the focused control
  frmMain.View.ItemRemoveExecute(Sender);
end;

procedure TdmActions.CatalogToolbarExecute(Sender: TObject);
begin
  CatalogToolbar.Checked := not CatalogToolbar.Checked;
  frmMain.tbCatalog.Visible := CatalogToolbar.Checked;
end;

procedure TdmActions.WindowsToolbarExecute(Sender: TObject);
begin
  WindowsToolbar.Checked := not WindowsToolbar.Checked;
  frmMain.tbWindows.Visible := WindowsToolbar.Checked;
end;

procedure TdmActions.ActionsToolbarExecute(Sender: TObject);
begin
  ActionsToolbar.Checked := not ActionsToolbar.Checked;
  frmMain.tbActions.Visible := ActionsToolbar.Checked;
end;

procedure TdmActions.ViewsToolbarExecute(Sender: TObject);
begin
  ViewsToolbar.Checked := not ViewsToolbar.Checked;
  frmMain.tbViews.Visible := ViewsToolbar.Checked;
end;

procedure TdmActions.WizardsToolbarExecute(Sender: TObject);
begin
  WizardsToolbar.Checked := not WizardsToolbar.Checked;
  frmMain.tbWizards.Visible := WizardsToolbar.Checked;
end;

procedure TdmActions.SortingToolbarExecute(Sender: TObject);
begin
  SortingToolbar.Checked := not SortingToolbar.Checked;
  frmMain.tbSorting.Visible := SortingToolbar.Checked;
end;

procedure TdmActions.MenuToolbarExecute(Sender: TObject);
begin
  MenuToolbar.Checked := not MenuToolbar.Checked;
  frmMain.tbMenu.Visible := MenuToolbar.Checked;
end;

procedure TdmActions.ItemsToolbarExecute(Sender: TObject);
begin
  ItemsToolbar.Checked := not ItemsToolbar.Checked;
  frmMain.tbItems.Visible := ItemsToolbar.Checked;
end;

procedure TdmActions.EmailFriendExecute(Sender: TObject);
begin
  // Show 1st dialog
  frmEmail.SendEmail;
end;

procedure TdmActions.CreateCDExecute(Sender: TObject);
begin
  // Not implemented
  ShowMessage('"Create-a-CD" is not yet implemented');
end;

procedure TdmActions.BuildWebExecute(Sender: TObject);
var
  Frm: TfrmBuildWeb;
begin
  Frm := TfrmBuildWeb.Create(Application);
  try
    Frm.DoBuildWebWizard;
  finally
    Frm.Free;
  end;
end;

procedure TdmActions.PrintDialogExecute(Sender: TObject);
var
  AItem: TsdItem;
  Loader: TsdGraphicLoader;
  Target: TBitmap;
  OldCursor: TCursor;
begin
  if assigned(frmMain.SelectedItems) and (frmMain.SelectedItems.Count > 0) then
  begin
    // Create a printer dialog
    if Printer.Printers.Count > 0 then
    begin
      if frmMain.dlgPrint = nil then
        frmMain.dlgPrint := TPrintDialog.Create(Application);
      if frmMain.dlgPrint.Execute then
      begin
        AItem := frmMain.SelectedItems[0];
        Loader := TsdGraphicLoader.Create;
        Target := TBitmap.Create;
        OldCursor := Screen.Cursor;
        Screen.Cursor := crHourGlass;
        frmShow.FormStyle := fsNormal;
        try
          frmMain.ItemviewMessage(Self, 'Preparing print...');
          AItem.RetrievePicture(Loader);
          // Resample to printer size
          RescaleImage(Loader.Bitmap, Target, Printer.PageWidth, Printer.PageHeight,
            True, True, True);

          frmMain.ItemviewMessage(Self, 'Sending to printer...');
          Printer.BeginDoc;
          Printer.Canvas.Draw((Printer.PageWidth - Target.Width) div 2,
                              (Printer.PageHeight - Target.Height) div 2,
                               Target);
          Printer.EndDoc;
        finally
          Loader.Free;
          Target.Free;
          Screen.Cursor := OldCursor;
          frmShow.FormStyle := fsStayOnTop;
        end;
        frmMain.ItemviewMessage(Self, 'All data is sent to printer.');
      end;
    end else
      MessageDlg('Please install a printer first!', mtWarning,
        [mbOK, mbHelp], 0);
  end else
  begin
    ShowMessage('Before you can print you must select a file first!');
  end;
end;

procedure TdmActions.PrinterSetupExecute(Sender: TObject);
begin
  if Printer.Printers.Count > 0 then
  begin
    if frmMain.dlgPrintSetup = nil then
      frmMain.dlgPrintSetup := TPrinterSetupDialog.Create(Application);
    frmMain.dlgPrintSetup.Execute;
  end;
end;

procedure TdmActions.alActionsUpdate(Action: TBasicAction; var Handled: Boolean);
var
  HasItems: boolean;
begin
  FileSave.Enabled   := frmMain.Root.IsChanged;
  FileSaveAs.Enabled := frmMain.Root.Count > 0;
  FileExport.Enabled := frmMain.Root.Count > 0;

  GoLeft.Enabled := GoLeftEnabled;
  GoRight.Enabled := GoRightEnabled;

  Maximize.Enabled := frmShow.WindowState <> wsMaximized;
  NormalWin.Enabled := frmShow.WindowState <> wsNormal;

  HasItems := False;
  if assigned(frmMain.View) then
    HasItems := frmMain.View.ItemList.Count > 0;
  RefreshFolder.Enabled := HasItems;
  RefreshAll.Enabled := frmMain.Root.Count > 0;
  ItemDelete.Enabled := frmMain.HasSelection;
  ItemRemove.Enabled := frmMain.HasSelection;
  PrintDialog.Enabled := frmMain.HasSelection;

  SingleView.Checked := FSingleMode;
  DualView.Checked := not FSingleMode;

  Copy.Enabled := frmMain.HasSelection;
  Cut.Enabled := frmMain.HasSelection;
  Paste.Enabled := ClipBoard.HasFormat(CF_HDROP);
  CopyImage.Enabled := (frmMain.SelectedItems.Count = 1) and
    TsdItem(frmMain.SelectedItems[0]).HasBitmap;
  SetAsBackground.Enabled := CopyImage.Enabled;

  SelectAll.Enabled := HasItems;
  SelectInvert.Enabled := HasItems;
  frmMain.SelectSpecial1.Enabled := HasItems;

  Rename.Enabled := frmMain.HasSelection;
  ChangeFileDate.Enabled := frmMain.HasSelection;
  frmMain.Lossless1.Enabled := frmMain.HasSelection;
  frmMain.RemoveEmbeddedInfo1.Enabled := frmMain.HasSelection;

  SlideShow.Enabled := HasItems;
  SlideShow.Checked := FSlideShow;
  if FSlideShow then
    SlideShow.ImageIndex := cSlideShowRunning
  else
    SlideShow.ImageIndex := cSlideShowStopped;

  if frmMain.SelectedMustUpdate then
    frmMain.ItemViewSelectionChanged(Self, False);

  frmMain.Root.RootUpdate(Self);
  Handled := True;
end;

procedure TdmActions.BgrProcessExecute(Sender: TObject);
begin
  frmProcesses.Show;
end;

procedure TdmActions.PredecodeCallback(Sender: TObject; const AGuid: TGUID);
var
  Width, Height: integer;
  AItem: TsdItem;
begin
  // We arrive here when the thumb thread has decoded the predecode request
  if IsEqualGuid(FPredecodeID, AGuid) and assigned(frmShow) then
  begin

    // Only when still in predecode status

    Width := frmShow.vwFile.pbPicture.Width;
    Height := frmShow.vwFile.pbPicture.Height;

    AItem := frmMain.Root.ItemByGuid(FPredecodeID);
    if assigned(AItem) then
      // Determine if we have to resize
      if (((Width < AItem.Width) or (Height < AItem.Height)) and frmShow.vwFile.ShrinkToFit) or
         (((Width > AItem.Width) and (Height > AItem.Height)) and frmShow.vwFile.GrowToFit) then
      begin

        // Probably, so do the resample request
        if assigned(frmMain.Root.Mngr) then
          frmMain.Root.Mngr.Request(FPredecodeID, rtResample, rpLow, Width, Height,
            0, nil, nil, nil);
      end;
  end;
end;

function TdmActions.GoLeftEnabled: boolean;
begin
  Result := False;
  if assigned(frmMain.View) then
  begin
    if frmMain.View.ItemList.Count = 0 then
      exit;
    Result := (frmMain.View.ItemIndex > 0) or FWrapAround;
  end;
end;

function TdmActions.GoRightEnabled: boolean;
begin
  Result := False;
  if assigned(frmMain.View) then
  begin
    if frmMain.View.ItemList.Count = 0 then
      exit;
    Result := (frmMain.View.ItemIndex < frmMain.View.ItemList.Count - 1) or FWrapAround;
  end;
end;

procedure TdmActions.RefreshFolderExecute(Sender: TObject);
var
  Folder: string;
  Item: TsdItem;
begin
  if not IsEmptyGuid(frmMain.View.CurItemID) then
  begin
    // Get current item
    Item := frmMain.Root.ItemByGuid(frmMain.View.CurItemID);
    Folder := '';
    if assigned(Item) then
      Folder := Item.FolderName;
    // Scan this folder
    if length(Folder) > 0 then
      // Run a scan
      RunScan(Folder, False, False, '', '',
        frmMain.RootClearBatchedItems);
  end;
end;

procedure TdmActions.HelpContentsExecute(Sender: TObject);
begin
  Application.HelpCommand(15, 0);
end;

procedure TdmActions.acForumExecute(Sender: TObject);
begin
  ShellExecute(frmMain.Handle,'open', pchar(cWebForum),
    nil, nil, SW_SHOWNORMAL);
end;

// snMain: TShellNotify methods

// Here we react to any changes in the shell centrally!

procedure TdmActions.snMainFolderUpdated(Sender: TObject; PIDL: Pointer;
  Path: TFileName; IsInterrupt: Boolean);
var
  Folder: TsdFolder;
begin
  if FShellNotifyRef > 0 then
    exit;

  // Folder updated, so we re-scan it's contents
  Folder := frmMain.Root.FolderByName(Path);
  if assigned(Folder) then
    RunScan(Path, False, False, '', '',
      frmMain.RootClearBatchedItems);
  if assigned(frmMain.Root.FBTree1) then
  begin
    frmMain.Root.FBTree1.PidlFolderUpdate(Self, Path);
  end;
end;

procedure TdmActions.snMainFolderRenamed(Sender: TObject; OldPIDL: Pointer;
  OldPath: TFileName; NewPIDL: Pointer; NewPath: TFileName;
  IsInterrupt: Boolean);
var
  Folder: TsdFolder;
begin
  if FShellNotifyRef > 0 then
    exit;

  // If OldPath contains "RECYCLE" this means that the directory came back
  // from the recycle bin. Use FolderCreated instead
  if Pos('RECYCLE', OldPath) > 0 then
    snMainFolderCreated(Sender, NewPIDL, NewPath, IsInterrupt);

  // If NewPath contains "RECYCLE" this means that the directory was put
  // in the recycle bin. Use FolderDeleted instead
  if Pos('RECYCLE', NewPath) > 0 then
    snMainFolderDeleted(Sender, OldPIDL, OldPath, IsInterrupt);

  // Do we have the folder?
  Folder := frmMain.Root.FolderByName(OldPath);
  if assigned(Folder) then
  begin
    Folder.FolderName := NewPath;
    Folder.Update([ufListing]);
  end;

  // Signal the change to the Pidl
  if assigned(frmMain.Root.FBTree1) {and assigned(frmMain.Root.FBTree2)} then
  begin
    frmMain.Root.FBTree1.PidlFolderRename(OldPath, NewPath);
    //frmMain.Root.FBTree2.PidlFolderRename(OldPath, NewPath);
  end;
end;

procedure TdmActions.snMainFolderCreated(Sender: TObject; PIDL: Pointer; Path: TFileName; IsInterrupt: Boolean);
var
  Folder: TsdFolder;
begin
  if FShellNotifyRef > 0 then
    exit;

  // A folder was created - do we have the parent
  Folder := frmMain.Root.FolderByName(GetParentFolder(Path));
  if assigned(Folder) and Folder.IncludeSubdirs then

    // We will add the newly created folder to the collection
    RunScan(Path, True, False, '', '',
      frmMain.RootClearBatchedItems);

  // We show it in the tree - if in a visible part
  if assigned(frmMain.Root.FBTree1) {and assigned(frmMain.Root.FBTree2)} then
  begin
    frmMain.Root.FBTree1.PidlFolderAdd(Self, Path);
    //frmMain.Root.FBTree2.PidlFolderAdd(Self, Path);
  end;
end;

procedure TdmActions.snMainFolderDeleted(Sender: TObject; PIDL: Pointer; Path: TFileName; IsInterrupt: Boolean);
var
  Folder: TsdFolder;
begin
  if FShellNotifyRef > 0 then
    exit;

  // A folder was deleted - do we have it?
  Folder := frmMain.Root.FolderByName(Path);
  if assigned(Folder) then
    frmMain.Root.Remove(Folder);
  if assigned(frmMain.Root.FBTree1) {and assigned(frmMain.Root.FBTree2)} then
  begin
    frmMain.Root.FBTree1.PidlFolderDelete(Self, Path);
    //frmMain.Root.FBTree2.PidlFolderDelete(Self, Path);
  end;
end;

procedure TdmActions.snMainItemCreated(Sender: TObject; PIDL: Pointer; Path: TFileName; IsInterrupt: Boolean);
begin
  if FShellNotifyRef > 0 then
    exit;
  // We will update the folder belonging to it
  snMainFolderUpdated(Sender, PIDL, ExtractFileDir(Path), IsInterrupt);
end;

procedure TdmActions.snMainItemDeleted(Sender: TObject; PIDL: Pointer; Path: TFileName; IsInterrupt: Boolean);
begin
  if FShellNotifyRef > 0 then
    exit;
  // We will update the folder belonging to it
  snMainFolderUpdated(Sender, PIDL, ExtractFileDir(Path), IsInterrupt);
end;

procedure TdmActions.snMainItemRenamed(Sender: TObject; OldPIDL: Pointer;
  OldPath: TFileName; NewPIDL: Pointer; NewPath: TFileName;
  IsInterrupt: Boolean);
var
  OldFile: TsdFile;
  NewFolder: TsdFolder;
begin
  if FShellNotifyRef > 0 then
    exit;

  // If OldPath contains "RECYCLE" this means that the item came back
  // from the recycle bin. Use ItemCreated instead
  if Pos('RECYCLE', OldPath) > 0 then
    snMainItemCreated(Sender, NewPIDL, NewPath, IsInterrupt);

  // If NewPath contains "RECYCLE" this means that the item was put
  // in the recycle bin. Use ItemDeleted instead
  if Pos('RECYCLE', NewPath) > 0 then
    snMainItemDeleted(Sender, OldPIDL, OldPath, IsInterrupt);

  OldFile := frmMain.Root.FileByName(OldPath);
  if assigned(OldFile) then
  begin
    NewFolder := frmMain.Root.FolderByName(ExtractFilePath(NewPath));
    if assigned(NewFolder) then
    begin
      // Make the updates
      OldFile.FolderGuid := NewFolder.Guid;
      Name := ExtractFileName(NewPath);
      OldFile.Update([ufListing]);
    end else
    begin
      // Item was pulled out of the catalog
      frmMain.Root.Remove(OldFile);
    end;
  end else
  begin
    // Do this two step
    snMainItemDeleted(Sender, OldPIDL, OldPath, IsInterrupt);
    // Check if the item becomes part of the collection
    snMainItemCreated(Sender, NewPIDL, NewPath, IsInterrupt);
  end;

end;

procedure TdmActions.snMainItemUpdated(Sender: TObject; PIDL: Pointer; Path: TFileName; IsInterrupt: Boolean);
var
  FFile: TsdFile;
begin
  if FShellNotifyRef > 0 then
    exit;

  FFile := frmMain.Root.FileByName(Path);
  if assigned(FFile) then
    FFile.Update([ufGraphic]);
end;

procedure TdmActions.snMainMediaChanged(Sender: TObject; PIDL: Pointer;
  Path: TFileName; IsInterrupt: Boolean);
// This event catches OnDriveAdded, OnDriveRemoved, OnMediaInserted, OnMediaRemoved,
// OnNetworkDriveAdded, OnResourceShared, OnResourceUnshared, OnServerDisconencted
begin
  if FShellNotifyRef > 0 then
    exit;

  if assigned(frmMain.Root.FBTree1) {and assigned(frmMain.Root.FBTree2)} then
  begin
    // Update the Browser trees
    frmMain.Root.FBTree1.PidlDriveUpdate(Self, Path);
    //frmMain.Root.FBTree2.PidlDriveUpdate(Self, Path);
  end;
end;

procedure TdmActions.CopyExecute(Sender: TObject);
begin
  // What to copy?

  // Right now we only check the itemviewers for files to copy to the
  // clipboard
  if assigned(frmMain.View) then
    frmMain.View.CopyItems;
end;

procedure TdmActions.CutExecute(Sender: TObject);
begin
  // Right now we only check the itemviewers for files to copy to the
  // clipboard
  if assigned(frmMain.View) then
    frmMain.View.CutItems;
end;

procedure TdmActions.PasteExecute(Sender: TObject);
begin
  // Right now we only check the itemviewers for files to copy to the
  // clipboard
  if assigned(frmMain.View) then
    frmMain.View.PasteItems;
end;

procedure TdmActions.CopyImageExecute(Sender: TObject);
var
  AItem: TsdItem;
  Bitmap: TBitmap;
begin
  // Copy the graphic of an image to the clipboard
  if frmMain.SelectedItems.Count = 1 then
  begin
    AItem := TsdItem(frmMain.SelectedItems[0]);
    Bitmap := TBitmap.Create;
    try
      AItem.GetBitmap(Bitmap);
      Clipboard.Assign(Bitmap);
    finally
      Bitmap.Free;
    end;
  end;
end;

procedure TdmActions.DoSendToMySelection;
var
  AItem: TSelectionItem;
begin
  if frmMain.SelectedItems.Count > 0 then
  begin
    if assigned(frmMain.Browser) then if assigned(frmMain.Browser.BrowseTree) then
    begin
      AItem := TSelectionItem(frmMain.Browser.BrowseTree.ItemWithNode(frmMain.UserSelectionNode));
      if not assigned(AItem) then
      begin
        // Create a new BrowseItem for this!
        AItem := TSelectionItem.Create;
        AItem.Caption := 'My Selection';
        // Add it to the browse tree
        frmMain.Browser.BrowseTree.AddItem(AItem, frmMain.Browser.BrowseTree.AllItems.Node);
        if assigned(frmMain.Browser.BrowseTree.AllItems.Filter) then
          frmMain.Browser.BrowseTree.AllItems.Filter.ConnectNode(AItem.Filter);
        frmMain.Browser.BrowseTree.AllItems.Expanded := True;
        frmMain.UserSelectionNode := AItem.Node;
      end;
      // Add current selection
      AItem.AddItems(Self, frmMain.SelectedItems);
    end;
  end;
end;

procedure TdmActions.SelectAllExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.SelectAllExecute(Sender);
end;

procedure TdmActions.SelectInvertExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.SelectInvertExecute(Sender);
end;

procedure TdmActions.SelectDupesExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.SelectDuplicatesExecute(Sender);
end;

procedure TdmActions.SelectDupeFolderExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.SelectDupeInFolderExecute(Sender);
end;

procedure TdmActions.SelectSmartExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.SelectSmartExecute(Sender);
end;

procedure TdmActions.RotateLeftExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.RotateLeftExecute(Sender);
end;

procedure TdmActions.RotateRightExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.RotateRightExecute(Sender);
end;

procedure TdmActions.Rotate180Execute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.Rotate180Execute(Sender);
end;

procedure TdmActions.FlipHorExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.FlipHorExecute(Sender);
end;

procedure TdmActions.FlipVerExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.FlipVerExecute(Sender);
end;

procedure TdmActions.RenameExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.RenameExecute(Self);
end;

procedure TdmActions.ChangeFiledateExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.ChangeFiledateExecute(Self);
end;

procedure TdmActions.TipofdayExecute(Sender: TObject);
begin
  FTipOfDay := True;
  ShowTipOfDay;
end;

procedure TdmActions.RotateOriExecute(Sender: TObject);
begin
  if assigned(frmMain.View) then
    frmMain.View.RotateOriExecute(Self);
end;

procedure TdmActions.acDownloadPuginsExecute(Sender: TObject);
begin
  ShellExecute(frmMain.Handle,'open', pchar(cDownloadPlugins),
    nil, nil, SW_SHOWNORMAL);
end;

end.
