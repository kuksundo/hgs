(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is sammelfen.pas of Karsten Bilderschau, version 3.2.12.
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: sammelfen.pas 123 2008-10-30 02:34:02Z hiisi $ }

{
@abstract Slide collection editor window
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 1999/05/29
@cvs $Date: 2008-10-29 21:34:02 -0500 (Mi, 29 Okt 2008) $
}
unit sammelfen;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Menus,
	Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
	ActnList, ToolWin, sammlung, ExtDlgs, SchauFen, Messages, Clipbrd,
  BandActn, ActnCtrls, ActnMan, ActnMenus, ActnPopup, XPStyleActnCtrls,
  JvComponentBase, JvAppStorage, JvAppRegistryStorage,
  JvFormPlacement, JvDockTree, JvDockControlForm, JvDockDelphiStyle,
  JvDockVIDStyle, PngImageList,
  globals, schnittstellen, karsten_tlb, sammelklassen, bildklassen,
  jobs, sammelfenUtils, thumbnails, repair, preview, ssconfig, recentfiles,
  multimonitor;

type
  TScrollDirection = (sdNone, sdLeft, sdRight, sdUp, sdDown);

  { @abstract Picture collection editor
    Note:
	  The OnDestroy event is hooked by external objects.
  }
	TCollectionForm = class(TForm)
		OpenDialog: TOpenDialog;
		SaveDialog: TSaveDialog;
    ReopenActionList: TActionList;
		AFileNew: TAction;
		AFileOpen: TAction;
		AFileSave: TAction;
		AFileSaveAs: TAction;
		AFileSend: TAction;
		AFileExit: TAction;
		AEditCut: TEditCut;
		AEditCopy: TEditCopy;
		AEditPaste: TEditPaste;
		AHelpAbout: TAction;
		StatusBar: TStatusBar;
		BilderListe: TListView;
    DefSmallIcons: TImageList;
    DefLargeIcons: TImageList;
		AEditInsertImage: TAction;
		AEditInsertFolder: TAction;
		AEditProperties: TAction;
		AEditDelete: TAction;
		AVSIcon: TAction;
		AVSSmallIcon: TAction;
		AVSList: TAction;
		AVSReport: TAction;
    BilderlistePopupMenu: TPopupActionBar;
		MIBLKEinzelbilder: TMenuItem;
		MIBLKSep1: TMenuItem;
		MIBLKEigenschaften: TMenuItem;
		MIBLKNeuOrdner: TMenuItem;
		MIBLKNeuBild: TMenuItem;
		MIBLKSep2: TMenuItem;
		MIBLKAusschneiden: TMenuItem;
		MIBLKKopieren: TMenuItem;
		MIBLKEinfuegen: TMenuItem;
		MIBLKLoeschen: TMenuItem;
		MIBLKAllesMarkieren: TMenuItem;
		MIBLKSep3: TMenuItem;
		MIBLKSep4: TMenuItem;
		MIBLKAnzeigen: TMenuItem;
		AEditSelectAll: TAction;
		AEditInsertFolderPictures: TAction;
		AHelpTopics: TAction;
		AHelpIndex: TAction;
		ASchauSchalten: TAction;
    ASortName: TAction;
    ASortFileName: TAction;
    ASortFilePath: TAction;
		ASortFrequency: TAction;
    ASortWaitTime: TAction;
    ASortNone: TAction;
    AOrderIncreasing: TAction;
    AOrderDecreasing: TAction;
    AFileClose: TAction;
    AFileNewWindow: TAction;
    OpenPicturesDialog: TOpenPictureDialog;
    AEditInsertImages: TAction;
    AAllowDuplicates: TAction;
    AFileRepair: TAction;
    AppStorage: TJvAppRegistryStorage;
    FormStorage: TJvFormStorage;
    JvDockServer: TJvDockServer;
    JvDockDelphiStyle: TJvDockDelphiStyle;
    JvDockVIDStyle: TJvDockVIDStyle;
    SmallIcons: TImageList;
    LargeIcons: TImageList;
    ActionManager: TActionManager;
    ActionMainMenuBar: TActionMainMenuBar;
    ActionToolBar: TActionToolBar;
    CustomizeActionBars1: TCustomizeActionBars;
    AShowWindow: TAction;
    AShowBorderless: TAction;
    AShowFullScreen: TAction;
    AShowWallpaper: TAction;
    AShowPause: TAction;
		AShowShowSlide: TAction;
    AShowScreenSaver: TAction;
    ReopenAction1: TAction;
    ReopenAction2: TAction;
    ReopenAction3: TAction;
    ReopenAction4: TAction;
    ReopenAction5: TAction;
    ReopenAction6: TAction;
    ReopenAction7: TAction;
    ReopenAction8: TAction;
    ReopenAction9: TAction;
    ReopenAction10: TAction;
    ADebugFunction: TAction;
    ActionImages: TPngImageList;
    ASortSequence: TAction;
    ScrollTimer: TTimer;
    AVSFilmStrip: TAction;
    MonitorActionList: TActionList;
		procedure AFileNewExecute(Sender: TObject);
		procedure AFileOpenExecute(Sender: TObject);
		procedure AFileSaveExecute(Sender: TObject);
		procedure AFileSaveAsExecute(Sender: TObject);
		procedure AFileSendExecute(Sender: TObject);
		procedure AFileExitExecute(Sender: TObject);
		procedure AHelpAboutExecute(Sender: TObject);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure AEditPropertiesExecute(Sender: TObject);
		procedure AEditInsertImageExecute(Sender: TObject);
		procedure AEditDeleteExecute(Sender: TObject);
		procedure BilderListeSelectItem(Sender: TObject; Item: TListItem;
			Selected: Boolean);
		procedure AEditInsertFolderExecute(Sender: TObject);
		procedure AShowPauseExecute(Sender: TObject);
		procedure AViewStyleExecute(Sender: TObject);
		procedure FormActivate(Sender: TObject);
		procedure BilderListeEdited(Sender: TObject; Item: TListItem;
			var S: String);
		procedure AEditSelectAllExecute(Sender: TObject);
		procedure AEditInsertFolderPicturesExecute(Sender: TObject);
		procedure AHelpTopicsExecute(Sender: TObject);
		procedure AHelpIndexExecute(Sender: TObject);
		procedure AHelpSearchExecute(Sender: TObject);
		procedure AShowProceedExecute(Sender: TObject);
		procedure AShowShowSlideExecute(Sender: TObject);
		procedure BilderListeKeyDown(Sender: TObject; var Key: Word;
			Shift: TShiftState);
		procedure ADebugFunctionExecute(Sender: TObject);
		procedure AShowScreenSaverExecute(Sender: TObject);
		procedure ASortExecute(Sender: TObject);
		procedure AOrderExecute(Sender: TObject);
		procedure BilderListeColumnClick(Sender: TObject; Column: TListColumn);
    procedure BilderListeDragOver(Sender, Source: TObject; X, Y: Integer;
			State: TDragState; var Accept: Boolean);
    procedure BilderListeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AFileCloseExecute(Sender: TObject);
    procedure AFileNewWindowExecute(Sender: TObject);
    procedure AEditCutExecute(Sender: TObject);
    procedure AEditCopyExecute(Sender: TObject);
    procedure AEditPasteExecute(Sender: TObject);
    procedure AEditPasteUpdate(Sender: TObject);
    procedure AEditInsertImagesExecute(Sender: TObject);
    procedure AAllowDuplicatesExecute(Sender: TObject);
    procedure BilderListeKeyPress(Sender: TObject; var Key: Char);
    procedure AFileRepairExecute(Sender: TObject);
    procedure ReopenActionExecute(Sender: TObject);
    procedure SlideShowActionsExecute(Sender: TObject);
    procedure SlideShowActionsUpdate(Sender: TObject);
    procedure AShowProceedUpdate(Sender: TObject);
    procedure AShowPauseUpdate(Sender: TObject);
    procedure AShowShowSlideUpdate(Sender: TObject);
    procedure AShowScreenSaverUpdate(Sender: TObject);
    procedure AViewStyleUpdate(Sender: TObject);
    procedure ASortUpdate(Sender: TObject);
    procedure AOrderUpdate(Sender: TObject);
    procedure AEditSelectAllUpdate(Sender: TObject);
    procedure AEditCutCopyUpdate(Sender: TObject);
    procedure AEditInsertFolderPicturesUpdate(Sender: TObject);
    procedure AFileNewWindowUpdate(Sender: TObject);
    procedure AFileExitUpdate(Sender: TObject);
    procedure AHelpTopicsUpdate(Sender: TObject);
    procedure AAllowDuplicatesUpdate(Sender: TObject);
    procedure ScrollTimerTimer(Sender: TObject);
    procedure BilderListeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure MonitorActionExecute(Sender: TObject);
    procedure MonitorActionUpdate(Sender: TObject);
	private
    class var
    	FSammlungClipFormat: integer;
      FRecentDocuments: TRecentFilesManager;
  private
		FSammlung: TBilderSammlung;
		FSchaufenster: TSchaufenster;
		FFilename: string;
		FReadOnly: boolean;
		FModified: boolean;
		FSetup: boolean;
    FPreviewForm: TPreviewForm;
    FListViewManager: TSammlungListViewManager;
    FScreenSaverConfigMode: boolean;
    FScrollDirection: TScrollDirection;
    FScrollWindow: TWinControl;
    FScrollMargin: integer;
    FScrollInterval: integer;
    FScrollCount: integer;
    FMonitorController: TMonitorController;
    FSchaufensterMonitor: integer;
		function	FileClose: boolean; //false=cancel
		procedure FormSetup;
		procedure SetFilename(const Value: string);
		procedure SetModified(const Value: boolean);
		procedure SetSammlung(const Value: TBildersammlung);
		procedure SetSchaufenster(const Value: TSchaufenster);
		function	GetSchaufenster: TSchaufenster;
    procedure SetScreenSaverConfigMode(const Value: boolean);
	protected
    { This form shall have its own task bar button. }
    procedure CreateParams(var Params: TCreateParams); override;
    { Override delphi's minimization/maximization mechanism. }
    procedure WMSysCommand(var message: TWMSysCommand); message WM_SYSCOMMAND;
    { Updates the ListView after changes to @link(Sammlung). }
		procedure SammlungChange(Sender: TBilderSammlung; changes: TSammlungChanges;
      Item: TSammelobjekt); virtual;
		procedure WMDropFiles(var message:tWMDropFiles); message wm_DropFiles;
		procedure	UpdateCaption; virtual;
    { Receives notification about a completed thumbnail extraction job,
      and updates the image lists and list view with the new information. }
		procedure JobDone(var message: TUMJobDone); message um_JobDone;
    procedure ListViewJobInfo(Sender: TObject; const message: string);
		procedure SchaufensterDestroy(Sender: TObject);
    { Copies the @link(TSammelobjekt.Selected) properties to the corresponding
      ListView items.
      @returns the number of selected items. }
    function  SelectionFromSammlung: integer;
    { Sets the @link(TSammelobjekt.Selected) properties from
      the corresponding ListView items.
      @returns the number of selected items. }
    function  SelectionToSammlung: integer;
    { Creates a backup copy of a file.
      Displays a message box where the user can choose to retry, ignore, or cancel
      if that fails.
      @param(Filename Path to the original file.)
      @returns(@true on success or ignore, @false on cancel) }
    function  FileSaveBackup(const Filename: string): boolean;
    { Add collection items from a list view to the collection.
      The source should be the @link(BilderList) list view of another
      collection window instance. The method is used in drag&drop operations. }
    procedure AddItemsFromListView(Source: TListView);
    { Moves the selected items to a new position in the sort order.
      This is supported for display time, frequency, and sequence sort keys only.
      The collection is resorted by the operation.

      @param(ADestination Collection item where the selected items are to be inserted.
        If the sort key is not unique, the destination is not well-defined,
        and the items might not be inserted at the specified destination.
        If the sort key is the sequence number,
        the method first renumbers the sequence so that the key is unique. ) }
    procedure MoveSelectedItems(const ADestination: TSammelobjekt);
	public
		constructor Create(AOwner: TComponent); override;
		destructor  Destroy; override;
		procedure SchauSchalten;
		function  BildBereit: boolean;
		{ liefert eine schnittstelle zum bearbeiten des aktuellen schaubild-objekts }
		function  Bildbearbeitung: IBildbearbeitung;
		{ Imports a picture, folder, or picture collection.
      @param(filepath Path and name of the file or folder.)
      @param(add If @true, add the file to the open collection,
        otherwise clear the collection before importing.)
      @param(Template Initialize properties of new items based on this template.
        If @nil, defaults apply.
        This parmeter has no effect if filepath denotes a collection file.) }
		procedure ImportAnyFile(filepath: string; add: boolean;
      const Template: TSammelObjekt = nil);
		procedure FileOpen(filepath: string);
		property  Filename: string read FFilename write SetFilename;
		property  Modified: boolean read FModified write SetModified;
    { Link to the picture collection being edited.
      @classname does not take ownership. }
		property  Sammlung: TBildersammlung read FSammlung write SetSammlung;
    { Link to the slide show window - if existing.
      @classname does not take ownership. }
		property  Schaufenster: TSchaufenster read GetSchaufenster write SetSchaufenster;
    { Switches the form to screen saver configuration mode,
      i.e. the picture collection is used by the screen saver.
      Some actions are not available in this mode. }
    property  ScreenSaverConfigMode: boolean read FScreenSaverConfigMode write SetScreenSaverConfigMode;
    { Moves the form to a specific monitor. }
    property  MonitorController: TMonitorController read FMonitorController;
	end;

var
	CollectionForm: TCollectionForm;

implementation

uses
  SysUtils, Mapi, About, BildProp, KarsReg, ShellAPI, ComServ,
	math, ShlObj, jclFileUtils, JclStrHashMap, gnugettext, sammelklassen.visitors;

{$R *.DFM}

resourcestring
	SWinTitleApplication = 'Karsten Slide Collection';
	SUntitled	= 'untitled';
	SSendError = 'Error sending E-Mail';
	SWarningNoSelection = 'Please select an item for editing first!';

	SFileChanged = 'The collection "%s" has changed. ' +
    'Would you like to save the changed version?';
	SFileReadOnly = 'The file "%s" is write-protected. ' +
    'Would you like to enter a new name [YES] or ignore the write protection [NO]?';
  SFileOpenFileNotFound = 'The file "%s" cannot be found.';
  SFileSaveBackupOSError = 'Cannot create backup copy of file "%s". '#13#10 +
    'Error message: "%s"';

  SRemoveDuplicatesConfirm = 'The collection contains %u duplicates. ' +
    'Do you want to delete them from the collection? ' +
    '(If you click [NO] the duplicate items will be highlighted.)';

procedure TCollectionForm.AFileNewExecute(Sender: TObject);
begin
	if FileClose then begin
		FileName  :=  '';
		if Assigned(FSchaufenster) then Schaufenster.Schaubild := nil;
		Sammlung.FreeAll;
		Modified := false;
		fReadOnly := false;
	end;
end;

procedure TCollectionForm.FileOpen(filepath:string);
var
	alterCursor:tCursor;
begin
	if (Length(filepath)>0) and FileExists(filepath) and FileClose then begin
		alterCursor := Screen.Cursor;
		Screen.Cursor := crHourglass;
		try
			if Assigned(FSchaufenster) then Schaufenster.Schaubild := nil;
			Sammlung.FreeAll;
			Filename := '';
			fReadOnly := false;
			filePath := ExpandFileName(filePath);
  		Sammlung.LoadFromFile(filepath);
			FileName := filepath;
			OpenDialog.InitialDir := ExtractFileDir(FileName);
			Modified := false;
      FRecentDocuments.AddFile(Filename);
      FRecentDocuments.HideFile(ReopenActionList, Filename);
			SHAddToRecentDocs(shard_Path,pChar(filepath));
		finally
			Screen.Cursor := alterCursor;
		end;
	end;
end;

procedure TCollectionForm.AFileOpenExecute(Sender: TObject);
begin
	if FileClose and OpenDialog.Execute then begin
		FileOpen(OpenDialog.FileName);
		fReadOnly := ofReadOnly in OpenDialog.Options;
	end;
end;

procedure TCollectionForm.ReopenActionExecute(Sender: TObject);
var
  RecentName: string;
begin
  RecentName := FRecentDocuments.Files[(Sender as TCustomAction).Tag];
  if FileExists(RecentName) then begin
    FileOpen(RecentName);
  end else begin
    MessageDlg(Format(SFileOpenFileNotFound, [ExtractFileName(RecentName)]),
      mtError, [mbOK], 0);
  end;
end;

function TCollectionForm.FileSaveBackup;
var
  done: boolean;
  err, msg: string;
begin
  done := false;
  repeat
    result := not FileExists(Filename) or FileBackup(Filename, false);
    if not result then begin
      err := SysErrorMessage(GetLastError);
      msg := Format(SFileSaveBackupOSError, [ExtractFileName(Filename), err]);
      case MessageDlg(msg, mtConfirmation, [mbRetry, mbIgnore, mbCancel], 0) of
        mrRetry:  done := false;
        mrIgnore: result := true;
        mrCancel: done := true;
      end;
    end;
  until
    result or done;
end;

procedure TCollectionForm.AFileSaveExecute(Sender: TObject);
var
	dlgResult: word;
	SaveCursor: TCursor;
begin
	if Filename = '' then
		AFileSaveAsExecute(Sender)
	else begin
		if FReadOnly then
      dlgResult := MessageDlg(Format(sFileReadOnly, [Filename]),
			  mtConfirmation, [mbYes, mbIgnore, mbCancel], 0)
    else
      dlgResult := mrIgnore;
		case dlgResult of
			mrYes: AFileSaveAsExecute(Sender);
			mrIgnore: begin
				SaveCursor := Screen.Cursor;
				Screen.Cursor := crHourglass;
				try
          if FileSaveBackup(Filename) then begin
            Sammlung.SaveToFile(Filename);
            Modified := false;
            SHChangeNotify(SHCNE_UPDATEITEM, SHCNF_PATH, PChar(Filename), nil);
          end;
				finally
					Screen.Cursor := SaveCursor;
				end;
			end;
		end;
	end;
end;

procedure TCollectionForm.AFileSaveAsExecute(Sender: TObject);
var
	SaveCursor: TCursor;
  shcne: UINT;
begin
	if Length(Filename)=0
		then SaveDialog.InitialDir := OpenDialog.InitialDir
		else SaveDialog.InitialDir := ExtractFileDir(FileName);
	if SaveDialog.Execute then begin
		SaveCursor := Screen.Cursor;
		Screen.Cursor := crHourglass;
		try
			Filename := SaveDialog.FileName;
      if FileExists(Filename) then
        shcne := SHCNE_UPDATEITEM
      else
        shcne := SHCNE_CREATE;
			Sammlung.SaveToFile(Filename);
			OpenDialog.InitialDir := ExtractFileDir(FileName);
			Modified := false;
			fReadOnly := false;
      FRecentDocuments.AddFile(Filename);
      FRecentDocuments.HideFile(ReopenActionList, Filename);
      SHChangeNotify(shcne, SHCNF_PATH, PChar(Filename), nil);
			SHAddToRecentDocs(shard_Path, PChar(Filename));
		finally
			Screen.Cursor := SaveCursor;
		end;
	end;
end;

procedure TCollectionForm.SetFilename(const Value: string);
begin
	FFilename  :=  Value;
	UpdateCaption;
end;

procedure TCollectionForm.UpdateCaption;
var
	part1,part2,part3:string;
begin
	part1 := sWinTitleApplication;
	if Length(fileName)>0 then part2 := ExtractFileName(fileName)
		else part2 := sUntitled;
	if Modified then part3 := ' *' else part3 := '';
	Caption := part1 + ' - ' + part2 + part3;
end;

procedure TCollectionForm.SetModified(const Value: boolean);
begin
	if fModified<>value then begin
		FModified  :=  Value;
		UpdateCaption;
	end;
end;

procedure TCollectionForm.AFileSendExecute(Sender: TObject);
var
	MapiMessage: TMapiMessage;
	MError: Cardinal;
begin
	with MapiMessage do
	begin
		ulReserved  :=  0;
		lpszSubject  :=  nil;
		lpszNoteText  :=  PChar(FileName);
		lpszMessageType  :=  nil;
		lpszDateReceived  :=  nil;
		lpszConversationID  :=  nil;
		flFlags  :=  0;
		lpOriginator  :=  nil;
		nRecipCount  :=  0;
		lpRecips  :=  nil;
		nFileCount  :=  0;
		lpFiles  :=  nil;
	end;

	MError  :=  MapiSendMail(0, 0, MapiMessage,
		MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0);
	if MError <> 0 then MessageDlg(SSendError, mtError, [mbOK], 0);
end;

procedure TCollectionForm.AFileCloseExecute(Sender: TObject);
begin
	Close;
end;

procedure TCollectionForm.AFileExitExecute(Sender: TObject);
begin
	PostMessage(Application.MainForm.Handle,um_CloseWindows,0,0);
end;

procedure TCollectionForm.AFileExitUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := not ScreenSaverConfigMode;
end;

procedure TCollectionForm.AHelpAboutExecute(Sender: TObject);
var
	AboutBox:TAboutBox;
begin
	AboutBox := TAboutBox.Create(Self);
	try
    AboutBox.PopupParent := Self;
		AboutBox.ShowModal;
	finally
		AboutBox.Free;
	end;
end;

procedure TCollectionForm.MonitorActionExecute(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Checked := true;
  FSchaufensterMonitor := Action.Tag;
  if Assigned(FSchaufenster) then
    Schaufenster.MonitorController.SetMonitor(Action.Tag);
end;

procedure TCollectionForm.MonitorActionUpdate(Sender: TObject);
var
  Action: TCustomAction;
  enable: boolean;
begin
  Action := Sender as TCustomAction;
  enable := Action.Tag <= Screen.MonitorCount;
  Action.Enabled := enable;
  Action.Visible := enable;
end;

procedure TCollectionForm.SlideShowActionsExecute(Sender: TObject);
begin
	if Assigned(Schaufenster) then begin
    Schaufenster.MonitorController.SetMonitor(FSchaufensterMonitor);
    Schaufenster.Show;
    Schaufenster.BringToFront;
    Schaufenster.AnzeigeModus := TAnzeigeModus((Sender as TComponent).Tag);
		Schaufenster.Angehalten := false;
	end;
end;

procedure TCollectionForm.SlideShowActionsUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := BildBereit;
  Action.Checked := Assigned(FSchaufenster) and
    (Ord(FSchaufenster.AnzeigeModus) = Action.Tag);
end;

procedure TCollectionForm.AShowProceedExecute(Sender: TObject);
begin
	SchauSchalten;
end;

procedure TCollectionForm.AShowProceedUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := (Sender as TCustomAction);
  Action.Enabled := BildBereit;
end;

procedure TCollectionForm.SchauSchalten;
begin
	if Assigned(Schaufenster) then Schaufenster.Weiterschalten;
end;

procedure TCollectionForm.AShowPauseExecute(Sender: TObject);
begin
	if Assigned(Schaufenster) then
		Schaufenster.Angehalten := not (Sender as TCustomAction).Checked;
end;

procedure TCollectionForm.AShowPauseUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := Assigned(FSchaufenster) and BildBereit;
	if Assigned(FSchaufenster) then begin
		Action.Checked := Schaufenster.Angehalten;
	end;
end;

procedure TCollectionForm.AShowShowSlideExecute(Sender: TObject);
var
	alterCursor:tCursor;
	Sammelobjekt:TSammelobjekt;
begin
	if Assigned(Schaufenster) and (BilderListe.SelCount=1) then begin
		alterCursor := Screen.Cursor;
		Screen.Cursor := crHourglass;
		try
			if Schaufenster.AnzeigeModus=amVersteckt
				then Schaufenster.AnzeigeModus := amNormal;
			Sammelobjekt := TSammelobjekt(BilderListe.Selected.Data);
			Schaufenster.Schaubild := Sammelobjekt;
			(*Schaufenster.Bildbearbeitung := Sammelobjekt;*)
		finally
			Screen.Cursor := alterCursor;
		end;
	end;
end;

procedure TCollectionForm.AShowShowSlideUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := Assigned(FSchaufenster) and (BilderListe.SelCount = 1);
end;

procedure TCollectionForm.SetScreenSaverConfigMode(const Value: boolean);
begin
  FScreenSaverConfigMode := Value;
end;

procedure TCollectionForm.AShowScreenSaverExecute(Sender: TObject);
var
	Dlg: TSSConfigForm;
begin
	Dlg := TSSConfigForm.Create(Self);
	try
		Dlg.CurrentBildersammlung := Filename;
    Dlg.PopupParent := Self;
		Dlg.ShowModal;
	finally
		Dlg.Free;
	end;
end;

procedure TCollectionForm.AShowScreenSaverUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := not ScreenSaverConfigMode;
end;

procedure TCollectionForm.FormSetup;
var
	Reg: TUserRegistry;
  ds: TDockSite;
  dw: integer;
begin
	fSetup := false;
	DragAcceptFiles(Handle, true);
	Reg := TUserRegistry.Create;
	try
		Reg.UpdateBilderlisteLV(BilderListe);
		OpenDialog.InitialDir := Reg.LetzterSammlungsordner;
    ds := Reg.PreviewSite;
    dw := Reg.PreviewWidth;
	finally
		Reg.Free;
	end;
  if ds <> dsNone then begin
    FPreviewForm.Show;
    case ds of
      dsLeft:   FPreviewForm.ManualDock(JvDockServer.LeftDockPanel);
      dsRight:  FPreviewForm.ManualDock(JvDockServer.RightDockPanel);
      dsTop:    FPreviewForm.ManualDock(JvDockServer.TopDockPanel);
      dsBottom: FPreviewForm.ManualDock(JvDockServer.BottomDockPanel);
      else      ;
    end;
    FPreviewForm.Width := dw;
  end;
  FRecentDocuments.LoadFromAppStorage(AppStorage, regkeyRecentDocuments);
  FSchaufensterMonitor := Monitor.MonitorNum + 1;
  (MonitorActionList.Actions[FSchaufensterMonitor - 1] as TCustomAction).Checked := true;
end;

procedure TCollectionForm.FormActivate(Sender: TObject);
begin
	if fSetup then FormSetup;
end;

procedure TCollectionForm.SetSammlung(const Value: TBildersammlung);
begin
  if Value <> FSammlung then begin
    if Assigned(FSammlung) then
      FSammlung.OnChange := nil;
    FSammlung  :=  Value;
    FListViewManager.Sammlung := FSammlung;
    if Assigned(FSammlung) then begin
      FSammlung.OnChange := SammlungChange;
      SammlungChange(FSammlung,
        [scAddObject, scChangeProperty, scChangeStatus, scChangeOrder], nil);
      Modified := false;
    end;
  end;
end;

procedure TCollectionForm.SchaufensterDestroy(Sender: TObject);
begin
	FSchaufenster := nil;
end;

procedure TCollectionForm.SetSchaufenster(const Value: TSchaufenster);
begin
	if Assigned(FSchaufenster) then with FSchaufenster do begin
		try
			if Sammlung=Self.Sammlung then Sammlung := nil;
			if Sammlungsfenster=Self then Sammlungsfenster := nil;
		except
			on EAccessViolation do;
		end;
	end;
	FSchaufenster  :=  Value;
	if Assigned(FSchaufenster) then with FSchaufenster do begin
		Sammlung := Self.Sammlung;
		Sammlungsfenster := Self;
	end;
end;

function TCollectionForm.GetSchaufenster: TSchaufenster;
begin
	if not Assigned(FSchaufenster) then
		Schaufenster := TSchaufenster.Create(Application); //Application will take care of destroying
	Result := FSchaufenster;
end;

constructor TCollectionForm.Create;
begin
	inherited;
  TranslateComponent(Self);
	FReadOnly := false;
	Modified := false;
	FSetup := true;
  FScrollMargin := 4;
  FScrollDirection := sdNone;
  FScrollWindow := nil;
  FScrollInterval := 100;
  FMonitorController := TMonitorController.Create(Self);
  SmallIcons.Assign(DefSmallIcons);
  LargeIcons.Assign(DefLargeIcons);
  FListViewManager := TSammlungListViewManager.Create(Self, BilderListe);
  BilderListe.OnCustomDrawItem := FListViewManager.CustomDrawItem;
  FListViewManager.OnJobInfo := ListViewJobInfo;
  AppStorage.Root := sIniPath;
  if not Assigned(FRecentDocuments) then
    FRecentDocuments := TRecentFilesManager.Create(ReopenActionList.ActionCount);
  if ReopenActionList.ActionCount > FRecentDocuments.MaxCount then
    FRecentDocuments.MaxCount := ReopenActionList.ActionCount;
  FRecentDocuments.RegisterActionList(ReopenActionList);
	{$ifdef debugging}
	ADebugFunction.Visible := true;
	ADebugFunction.Enabled := true;
	{$endif}
  FPreviewForm := TPreviewForm.Create(Self);
end;

procedure TCollectionForm.CreateParams;
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle and not WS_EX_TOOLWINDOW or WS_EX_APPWINDOW;
end;

procedure TCollectionForm.WMSysCommand;
begin
  case (message.CmdType and $FFF0) of
    SC_MINIMIZE: begin
      ShowWindow(Handle, SW_MINIMIZE);
      message.Result := 0;
    end;
    SC_RESTORE: begin
      ShowWindow(Handle, SW_RESTORE);
      message.Result := 0;
    end;
  else
    inherited;
  end;
end;

procedure TCollectionForm.FormClose;
var
	Reg: TUserRegistry;
  i: integer;
  CheckedPreviewForm: TPreviewForm;
  ds: TDockSite;
begin
	Reg := TUserRegistry.Create;
	try
		Reg.SaveBilderlisteLV(Bilderliste);
		Reg.LetzterSammlungsordner := OpenDialog.InitialDir;
    CheckedPreviewForm := nil;
    for i := 0 to ComponentCount - 1 do begin
      if TComponent(FPreviewForm) = Components[i] then begin
        CheckedPreviewForm := FPreviewForm;
        Break;
      end;
    end;
    if Assigned(CheckedPreviewForm) then begin
      Reg.PreviewWidth := CheckedPreviewForm.Width;
      if CheckedPreviewForm.Parent = JvDockServer.LeftDockPanel then
        ds := dsLeft
      else if CheckedPreviewForm.Parent = JvDockServer.RightDockPanel then
        ds := dsRight
      else if CheckedPreviewForm.Parent = JvDockServer.TopDockPanel then
        ds := dsTop
      else if CheckedPreviewForm.Parent = JvDockServer.BottomDockPanel then
        ds := dsBottom
      else
        ds := dsFloating;
    end else
      ds := dsNone;
    Reg.PreviewSite := ds;
	finally
		Reg.Free;
	end;
  FRecentDocuments.SaveToAppStorage(AppStorage, regkeyRecentDocuments);
	if Assigned(FSchaufenster) then begin
    FSchaufenster.Schaubild := nil;
    FSchaufenster.Close;
    FreeAndNil(FSchaufenster);
  end;
	action := caFree;
end;

destructor TCollectionForm.Destroy;
begin
	try
    FRecentDocuments.UnRegisterActionList(ReopenActionList);
		Schaufenster := nil;
		Sammlung := nil;
    FreeAndNil(FListViewManager);
    FreeAndNil(FMonitorController);
  	DragAcceptFiles(Handle, false);
	finally
		inherited;
	end;
end;

procedure TCollectionForm.FormCloseQuery;
begin
	CanClose := FileClose;
end;

function TCollectionForm.FileClose;
//stellt sicher, dass die sammlungsdaten verworfen werden dürfen,
//speichert evtl. und aktualisiert das Modified-flag,
//gibt die sammlung aber nicht frei.
var
	overwDlgAntw:word;
	dateiname:string;
begin
	if Modified then begin
		if Length(Filename)>0
			then dateiname := ExtractFileName(Filename)
			else dateiname := sUntitled;
		case
			MessageDlg(Format(sFileChanged,[dateiname]),mtConfirmation,[mbYes,mbNo,mbCancel],0)
		of
			mrYes: begin
				if fReadOnly then overwDlgAntw := MessageDlg(Format(sFileReadOnly,[dateiname]),
					mtConfirmation,[mbYes,mbIgnore,mbCancel],0) else overwDlgAntw := mrIgnore;
				case overwDlgAntw of
					mrYes: begin
						AFileSaveAs.Execute;
						result := true;
					end;
					mrIgnore: begin
						AFileSave.Execute;
						result := true;
					end;
					else result := false;
				end;
			end;
			mrNo: begin
				Modified := false;
				result := true;
			end;
			else result := false;
		end;
	end else result := true;
	if result and FileExists(Filename) then begin
    FRecentDocuments.AddFile(Filename);
    FRecentDocuments.HideFile(ReopenActionList, '');
  end;
end;

procedure TCollectionForm.BilderListeEdited(Sender: TObject; Item: TListItem;
	var S: String);
begin
	TSammelobjekt(Item.Data).Name := s;
end;

procedure TCollectionForm.JobDone;
begin
  FListViewManager.JobDone(message);
end;

procedure TCollectionForm.ListViewJobInfo;
begin
  StatusBar.SimpleText := message;
end;

procedure TCollectionForm.SammlungChange;
var
  statusChangeOnly: boolean;
begin
  statusChangeOnly := changes - [scChangeStatus, scChangeObjectStatus] = [];
  Modified := Modified or not statusChangeOnly;
  FListViewManager.SammlungChange(Sender, changes, Item);
  if (BilderListe.SelCount = 1) and
    ((Item = nil) or (BilderListe.Selected.Data = Item))
  then
    FPreviewForm.PreviewItem := TSammelobjekt(BilderListe.Selected.Data);
end;

function TCollectionForm.SelectionToSammlung;
var
  Sammelobjekt: TSammelobjekt;
  ListItem: TListItem;
  sel: boolean;
begin
  Sammlung.ResetSelection;
  result := 0;
  for ListItem in BilderListe.Items do begin
    Sammelobjekt := TSammelobjekt(ListItem.Data);
    sel := ListItem.Selected;
    Sammelobjekt.Selected := sel;
    if sel then Inc(result);
  end;
end;

function TCollectionForm.SelectionFromSammlung;
var
  Sammelobjekt: TSammelobjekt;
  ListItem: TListItem;
  sel: boolean;
begin
  result := 0;
  BilderListe.Items.BeginUpdate;
  try
    for ListItem in BilderListe.Items do begin
      Sammelobjekt := TSammelobjekt(ListItem.Data);
      sel := Sammelobjekt.Selected;
      ListItem.Selected := sel;
      if sel then Inc(result);
    end;
  finally
    BilderListe.Items.EndUpdate;
  end;
end;

procedure TCollectionForm.BilderListeKeyDown(Sender: TObject; var Key: Word;
	Shift: TShiftState);
begin
	if (key=vk_Return) and (shift=[]) and (Bilderliste.SelCount>0)
		then AEditProperties.Execute;
end;

procedure TCollectionForm.AEditPropertiesExecute(Sender: TObject);
var
	Dlg: TBildEigenschaftenDlg;
  ListItem: TListItem;
	Item: TSammelobjekt;
begin
	if Bilderliste.SelCount > 0 then begin
		Dlg := TBildEigenschaftenDlg.Create(Self);
		try
      Dlg.PopupParent := Self;
			Item := TSammelobjekt(Bilderliste.Selected.Data);
			if Bilderliste.SelCount > 1 then begin
				if Assigned(Bilderliste.ItemFocused) then
          Item := TSammelobjekt(Bilderliste.ItemFocused.Data);
				Dlg.MultiObjekt := Item;
				if Dlg.ShowModal = mrOk then begin
          Sammlung.BeginUpdate;
          try
            for ListItem in BilderListe.Items do begin
              if ListItem.Selected then begin
                Item := TSammelobjekt(ListItem.Data);
                Sammlung.ChangeItem(Item, Dlg.MultiObjekt, Dlg.Aenderungen);
              end;
            end;
          finally
            Sammlung.EndUpdate;
          end;
        end;
			end else begin
				Dlg.Sammelobjekt := Item;
				if Dlg.ShowModal = mrOk then begin
          Sammlung.BeginUpdate;
          try
  					Sammlung.ChangeItem(Item, Dlg.Sammelobjekt, Dlg.Aenderungen);
          finally
            Sammlung.EndUpdate;
          end;
        end;
			end;
		finally
			Dlg.Free;
		end;
	end else begin
		MessageBeep(mb_IconExclamation);
		MessageDlg(sWarningNoSelection, mtWarning, [mbOk], 0);
	end;
end;

procedure TCollectionForm.AEditInsertImageExecute(Sender: TObject);
var
	Dlg: TBildEigenschaftenDlg;
begin
	Dlg := TBildEigenschaftenDlg.Create(Self);
	try
		Dlg.BildAuswahl := true;
    Dlg.PopupParent := Self;
		if Dlg.ShowModal = mrOk then begin
      Sammlung.ResetSelection;
      Sammlung.AddItem(Dlg.Sammelobjekt);
      SelectionFromSammlung;
    end;
	finally
		Dlg.Free;
	end;
end;

procedure TCollectionForm.AEditInsertFolderExecute(Sender: TObject);
var
	Dlg: TBildEigenschaftenDlg;
begin
	Dlg := TBildEigenschaftenDlg.Create(Self);
	try
		Dlg.OrdnerAuswahl := true;
    Dlg.PopupParent := Self;
		if Dlg.ShowModal = mrOk then begin
      Sammlung.ResetSelection;
      Sammlung.AddItem(Dlg.Sammelobjekt);
      SelectionFromSammlung;
    end;
	finally
		Dlg.Free;
	end;
end;

procedure TCollectionForm.AEditDeleteExecute(Sender: TObject);
begin
  Sammlung.BeginUpdate;
  try
    SelectionToSammlung;
    // Schaubild links to the original sammlung item
    if
      Assigned(FSchaufenster) and Assigned(Schaufenster.Schaubild) and
      (Schaufenster.Schaubild.Selected)
    then
      Schaufenster.Schaubild := nil;
    Sammlung.FreeSelected;
  finally
    Sammlung.EndUpdate;
  end;
  BilderListe.Selected := nil;
end;

procedure TCollectionForm.ImportAnyFile;
var
	NewItem: TSammelobjekt;
begin
	if Length(filepath) = 0 then Exit;
  NewItem := nil;
  filepath := ExpandFileName(filepath);
  Sammlung.BeginUpdate;
  try
    if not add then begin
      if Assigned(FSchaufenster) then Schaufenster.Schaubild := nil;
      Sammlung.FreeAll;
    end;
    if SameText(ExtractFileExt(filepath), SaveDialog.DefaultExt) then begin
      Modified := true;
      Sammlung.LoadFromFile(filepath);
      if not add then begin
        Filename := filepath;
        Modified := false;
      end;
    end else begin
      try
        if FileExists(filepath) then begin
          NewItem := TSammelbild.Create;
          if Assigned(Template) then NewItem.Assign(Template);
          NewItem.Pfad := filepath;
          NewItem.Name := ExtractFileName(filepath);
        end else
          if DirectoryExists(filepath) then begin
            NewItem := TSammelordner.Create;
            if Assigned(Template) then NewItem.Assign(Template);
            NewItem.Pfad := filepath;
            NewItem.Name := sBilderAus + filepath;
          end;
        if Assigned(NewItem) then begin
          Sammlung.AddItem(NewItem);
          Modified := true;
        end;
      finally
        FreeAndNil(NewItem);
      end;
    end;
  finally
    Sammlung.EndUpdate;
  end;
end;

procedure TCollectionForm.WMDropFiles(var message: tWMDropFiles);
var
	nFiles, fileIdx: cardinal;
	dropfilename: string;
begin
	try
		nFiles := DragQueryFile(message.drop, $FFFFFFFF, nil, 0);
		if nFiles = 0 then Exit;
    Sammlung.BeginUpdate;
    try
      Bilderliste.Selected := nil;
      Sammlung.ResetSelection;
      for fileIdx := 0 to nFiles - 1 do begin
        SetLength(dropfilename, MAX_PATH);
        SetLength(dropfilename,
          DragQueryFile(message.drop, fileIdx, pChar(dropfilename), Length(dropfilename)));
        ImportAnyFile(dropfilename, true);
      end;
    finally
      Sammlung.EndUpdate;
    end;
	finally
		DragFinish(message.drop);
		message.Result := 0;
	end;
  SelectionFromSammlung;
end;

procedure TCollectionForm.AEditInsertImagesExecute;
var
	fileIdx:cardinal;
begin
  if OpenPicturesDialog.Execute then begin
    Sammlung.BeginUpdate;
		try
			Bilderliste.Selected := nil;
      Sammlung.ResetSelection;
			for fileIdx := 0 to OpenPicturesDialog.Files.Count - 1 do
				ImportAnyFile(OpenPicturesDialog.Files[fileIdx], true);
		finally
			Sammlung.EndUpdate;
		end;
    SelectionFromSammlung;
  end;
end;

procedure TCollectionForm.BilderListeSelectItem;
var
  Obj: TSammelobjekt;
begin
  if BilderListe.SelCount = 1 then begin
    Obj := TSammelobjekt(BilderListe.Selected.Data);
    if not Assigned(Sammlung) or (Sammlung.IndexOf(Obj) < 0) then Obj := nil;
  end else
    Obj := nil;
  FPreviewForm.PreviewItem := Obj;
end;

function TCollectionForm.BildBereit: boolean;
begin
	result := Assigned(Sammlung) and (Sammlung.count>0);
end;

procedure TCollectionForm.AViewStyleExecute(Sender: TObject);
var
  Action: TCustomAction;
  cvs: TCollectionViewStyle;
begin
  Action := Sender as TCustomAction;
  cvs := TCollectionViewStyle(Action.Tag);
  if cvs <= cvsReport then begin
  	BilderListe.ViewStyle := TViewStyle(cvs);
  end else begin
    // TODO : film strip layout
    BilderListe.ViewStyle := vsIcon;
  end;
end;

procedure TCollectionForm.AViewStyleUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  { "if Active then" is a workaround for a mysterious problem
    where Action.Checked := true does not succeed, i.e. Checked remains false,
    while the slide show form is maximized and borderless ("full screen").
    this causes an infinite OnUpdate loop and 100% CPU usage.
    the conditional works around the issue while the collection form
    is in the background. also, the problem disappears
    if the view style icons are removed from the action tool bar. }
  if Active then
    Action.Checked := Action.Tag = Ord(BilderListe.ViewStyle);
end;

procedure TCollectionForm.ASortExecute(Sender: TObject);
begin
	with Sender as TComponent do Sammlung.Sortierung := tSortierung(Tag);
end;

procedure TCollectionForm.ASortUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := BildBereit;
  if Assigned(Sammlung) then
    Action.Checked := Action.Tag = Ord(Sammlung.Sortierung);
end;

procedure TCollectionForm.AOrderExecute(Sender: TObject);
begin
	with Sender as TAction do	Sammlung.Richtung := Tag;
end;

procedure TCollectionForm.AOrderUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := BildBereit;
  if Assigned(Sammlung) then
    Action.Checked := Action.Tag = Sammlung.Richtung;
end;

procedure TCollectionForm.BilderListeColumnClick(Sender: TObject;
	Column: TListColumn);
var
	sortneu: TSortierung;
begin
	case Column.Index of
		0: sortneu := sortName;
		1: sortneu := sortWartezeit;
		2: sortneu := sortHaeufigkeit;
    3: sortneu := sortSequence;
		4: sortneu := sortDateipfad;
		else exit;
	end;
	if BildBereit then begin
    Sammlung.BeginUpdate;
    try
      if sortneu = Sammlung.Sortierung then
        Sammlung.Richtung := -Sammlung.Richtung
      else begin
        Sammlung.Sortierung := sortneu;
        Sammlung.Richtung := 1;
      end;
    finally
      Sammlung.EndUpdate;
    end;
	end;
end;

procedure TCollectionForm.AEditSelectAllExecute(Sender: TObject);
var
  Item: TListItem;
begin
  Bilderliste.Items.BeginUpdate;
  try
    for Item in Bilderliste.Items do
      Item.Selected := true;
  finally
    Bilderliste.Items.EndUpdate;
  end;
end;

procedure TCollectionForm.AEditSelectAllUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := BildBereit;
end;

procedure TCollectionForm.AEditInsertFolderPicturesExecute(Sender: TObject);
	procedure ImportBilderAusOrdner(Ordner: TSammelordner);
	var
		code: integer;
		sr: TSearchRec;
	begin
    // todo -cconfig : make inclusion of hidden files configurable
		code := SysUtils.FindFirst(Ordner.Pfad + '*.*', faReadOnly or faHidden, sr);
		try
      while code = 0 do begin
				if MediaTypes.GetGrafikformat(sr.Name) <> gfUnbekannt then
					ImportAnyFile(Ordner.Pfad + sr.Name, true, Ordner);
				code := SysUtils.FindNext(sr);
			end;
		finally
			SysUtils.FindClose(sr);
		end;
	end;

var
	LI: TListItem;
	SO: TSammelobjekt;
	idx: integer;
	SelOrdner: array of TSammelordner;
begin
	if Bilderliste.SelCount = 0 then Exit;
  SetLength(SelOrdner, Bilderliste.SelCount);
  Sammlung.BeginUpdate;
  try
    LI := Bilderliste.Selected;
    idx := 0;
    while Assigned(LI) do begin
      SO := TSammelobjekt(LI.Data);
      if SO is TSammelordner then begin
        SelOrdner[idx] := TSammelordner(SO);
        Inc(idx);
      end;
      LI := Bilderliste.GetNextItem(LI,sdAll,[isSelected]);
    end;
    Bilderliste.Selected := nil;
    Sammlung.ResetSelection;
    SetLength(SelOrdner, idx);
    Modified := true;
    for idx := Low(SelOrdner) to High(SelOrdner) do begin
      ImportBilderAusOrdner(SelOrdner[idx]);
      if Assigned(FSchaufenster) and
        (Schaufenster.Schaubild = SelOrdner[idx])
      then
        Schaufenster.Schaubild := nil;
      Sammlung.FreeItem(SelOrdner[idx]);
    end;
  finally
    Sammlung.EndUpdate;
  end;
  SelectionFromSammlung;
end;

procedure TCollectionForm.AEditInsertFolderPicturesUpdate(Sender: TObject);
var
  Action: TCustomAction;
  ListItem: TListItem;
	en: boolean;
begin
  Action := Sender as TCustomAction;
	en := BilderListe.SelCount >= 1;
  if en then begin
    if BilderListe.SelCount = 1 then begin
      en := TSammelobjekt(BilderListe.Selected.Data) is TSammelordner;
    end else begin
      for ListItem in Bilderliste.Items do begin
				if ListItem.Selected and
          not (TSammelobjekt(ListItem.Data) is TSammelordner)
        then begin
          en := false;
          Break;
				end;
      end;
    end;
  end;
	Action.Enabled := en;
end;

procedure TCollectionForm.AHelpTopicsExecute(Sender: TObject);
begin
	Application.HelpContext(1);
end;

procedure TCollectionForm.AHelpTopicsUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := FileExists(Application.CurrentHelpFile);
end;

procedure TCollectionForm.AHelpIndexExecute(Sender: TObject);
begin
	Application.HelpCommand(help_Finder,0);
end;

procedure TCollectionForm.AHelpSearchExecute(Sender: TObject);
begin
	Application.HelpCommand(help_Finder,0);
end;

function TCollectionForm.Bildbearbeitung: IBildbearbeitung;
begin
	if (Sammlung.Count>0) and Assigned(Sammlung.Schauobjekt) then
		Result := Sammlung.Schauobjekt
	else
		Result := nil;
end;

procedure TCollectionForm.ADebugFunctionExecute(Sender: TObject);
var
	output: string;
begin
	output := Format('debugcheckpoint = %u.', [0]);
	Application.MessageBox(PChar(output), 'Debug Function', mb_Ok or mb_IconInformation);
end;

procedure TCollectionForm.ScrollTimerTimer;
begin
  if (FScrollDirection = sdNone) or not Assigned(FScrollWindow) then Exit;
  LargeIcons.HideDragImage;
  SmallIcons.HideDragImage;
  case FScrollDirection of
    sdLeft:  SendMessage(FScrollWindow.Handle, WM_HSCROLL, SB_LINELEFT, 0);
    sdRight: SendMessage(FScrollWindow.Handle, WM_HSCROLL, SB_LINERIGHT, 0);
    sdUp:    SendMessage(FScrollWindow.Handle, WM_VSCROLL, SB_LINEUP, 0);
    sdDown:  SendMessage(FScrollWindow.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  end;
  LargeIcons.ShowDragImage;
  SmallIcons.ShowDragImage;
  Inc(FScrollCount);
  if FScrollCount = 10 then
    ScrollTimer.Interval := Ceil(FScrollInterval / 10);
end;

procedure TCollectionForm.BilderListeDragOver(Sender, Source: TObject; X,
	Y: Integer; State: TDragState; var Accept: Boolean);
var
  LV: TListView;
begin
	Accept := (Source is TListView) and
    ((Source <> BilderListe) or
    (Sammlung.Sortierung in [sortHaeufigkeit, sortWartezeit, sortSequence]));

  if not Accept then Exit;
  LV := Sender as TListView;
  if ((Y >= 0) and (Y < FScrollMargin)) then
    FScrollDirection := sdUp
  else if ((Y >= LV.ClientHeight - FScrollMargin) and (Y < LV.ClientHeight)) then
    FScrollDirection := sdDown
  else
    FScrollDirection := sdNone;

  if FScrollDirection = sdNone then begin
    ScrollTimer.Enabled := false;
    ScrollTimer.Interval := FScrollInterval;
    FScrollCount := 0;
  end else begin
    FScrollWindow := LV;
    ScrollTimer.Enabled := true;
  end;
end;

procedure TCollectionForm.BilderListeDragDrop(Sender, Source: TObject; X,	Y: Integer);
var
	SourceLV: TListView;
  DestItem: TListItem;
  DestObj: TObject;
begin
  ScrollTimer.Enabled := false;
  ScrollTimer.Interval := FScrollInterval;
  FScrollCount := 0;
	SourceLV := Source as TListView;
	if SourceLV.SelCount = 0 then Exit;
  if SourceLV = BilderListe then begin
    DestItem := BilderListe.DropTarget;
    if Assigned(DestItem) then
      DestObj := TObject(DestItem.Data)
    else
      DestObj := nil;
    if Assigned(DestObj) and (DestObj is TSammelobjekt) then
      MoveSelectedItems(TSammelobjekt(DestObj));
  end else
    AddItemsFromListView(SourceLV);
end;

procedure TCollectionForm.BilderListeEndDrag;
begin
  ScrollTimer.Enabled := false;
  ScrollTimer.Interval := FScrollInterval;
  FScrollCount := 0;
end;

procedure TCollectionForm.AddItemsFromListView(Source: TListView);
var
  Item: TListItem;
  Obj: TObject;
begin
  Bilderliste.Selected := nil;
  Sammlung.BeginUpdate;
  try
    Sammlung.ResetSelection;
    for Item in Source.Items do begin
      if Item.Selected then begin
        Obj := TObject(Item.Data);
        if Obj is TSammelobjekt then
          Sammlung.AddItem(TSammelobjekt(Obj));
      end;
    end;
  finally
    Sammlung.EndUpdate;
  end;
  SelectionFromSammlung;
end;

procedure TCollectionForm.MoveSelectedItems;
var
  iObj, iPrev: integer;
  PrevObj: TSammelobjekt;
  nsel: integer;
  Visitor: TSammelobjektVisitor;
begin
  Sammlung.BeginUpdate;
  try
    nsel := SelectionToSammlung;
    iObj := Sammlung.IndexOf(ADestination);
    if iObj > 0 then
      iPrev := iObj - 1
    else
      iPrev := iObj;
    PrevObj := Sammlung.Items[iPrev];
    case Sammlung.Sortierung of
      sortWartezeit: begin
        Visitor := TReorderSammelobjektDisplayTime.Create(nsel, PrevObj, ADestination);
      end;

      sortHaeufigkeit: begin
        Visitor := TReorderSammelobjektFrequency.Create(nsel, PrevObj, ADestination);
      end;

      sortSequence: begin
        Sammlung.RenumberSequence;
        Visitor := TReorderSammelobjektSequence.Create(ADestination.SequenceNumber, nsel);
      end;
    end;

    try
      Sammlung.AcceptItemsVisitor(Visitor);
    finally
      FreeAndNil(Visitor);
    end;
    Sammlung.Sort;
  finally
    Sammlung.EndUpdate;
  end;
  SelectionFromSammlung;
end;

procedure TCollectionForm.AFileNewWindowExecute(Sender: TObject);
var
	Launcher:IKarstenLauncher;
begin
	Launcher := CoKarstenLauncher.Create;
	Launcher.SammlungOeffnen('', Monitor.MonitorNum);
end;

procedure TCollectionForm.AFileNewWindowUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := not ScreenSaverConfigMode;
end;

procedure TCollectionForm.AEditCutCopyUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := Assigned(Sammlung) and (BilderListe.SelCount >= 1)
end;

procedure TCollectionForm.AEditCutExecute(Sender: TObject);
begin
	AEditCopyExecute(Sender);
	AEditDeleteExecute(Sender);
end;

procedure TCollectionForm.AEditCopyExecute(Sender: TObject);
var
  xml: string;
begin
	if BilderListe.SelCount = 0 then Exit;
  SelectionToSammlung;
  Sammlung.SaveToXMLString(xml, true);
  Clipboard.AsText := xml;
end;

procedure TCollectionForm.AEditPasteExecute(Sender: TObject);
var
  xml: string;
	memHandle: THandle;
begin
  Sammlung.ResetSelection;
	Clipboard.Open;
	try
		if Clipboard.HasFormat(CF_TEXT) then begin
      xml := Clipboard.AsText;
      Sammlung.LoadFromXMLString(xml, true);
		end else if Clipboard.HasFormat(CF_HDROP) then begin
			memHandle := Clipboard.GetAsHandle(CF_HDROP);
			SendMessage(Handle, wm_DropFiles, memHandle, 0);
		end;
	finally
		Clipboard.Close;
	end;
  SelectionFromSammlung;
end;

procedure TCollectionForm.AEditPasteUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := Assigned(Sammlung) and
    (Clipboard.HasFormat(CF_TEXT) or
    Clipboard.HasFormat(CF_HDROP));
end;

procedure TCollectionForm.AAllowDuplicatesExecute(Sender: TObject);
var
  DupList: TList;
  i1, i2: integer;
  Item1, Item2: TSammelobjekt;
  path1: string;
  hash1: THashValue;
  ViewItem: TListItem;
begin
  Sammlung.AllowDuplicates := not Sammlung.AllowDuplicates;
  if not Sammlung.AllowDuplicates then begin
    // optionally enforce DisallowDuplicates
    DupList := TList.Create;
    try
      for i1 := 0 to Sammlung.Count - 1 do begin
        Item1 := Sammlung.Items[i1];
        path1 := Item1.Pfad;
        hash1 := Item1.PfadHash;
        for i2 := i1 + 1 to Sammlung.Count-1 do begin
          Item2 := Sammlung.Items[i2];
          if (Item2.PfadHash = hash1) and SameFileName(path1, Item2.Pfad) then
            DupList.Add(Item2);
        end;
      end;
      if DupList.Count > 0 then
        case
          MessageDlg(Format(sRemoveDuplicatesConfirm, [DupList.Count]),
            mtConfirmation, [mbYes, mbNo], 0)
        of
          mrYes: begin
            Sammlung.BeginUpdate;
            try
              for i1 := 0 to DupList.Count - 1 do
                Sammlung.FreeItem(TSammelobjekt(DupList.Items[i1]));
            finally
              Sammlung.EndUpdate;
            end;
          end;
          mrNo: begin
            Bilderliste.Items.BeginUpdate;
            try
              BilderListe.Selected := nil;
              for i1 := 0 to DupList.Count - 1 do begin
                ViewItem := TListItem(TSammelobjekt(DupList.Items[i1]).ViewerItem);
                if Assigned(ViewItem) then ViewItem.Selected := true;
              end;
            finally
              Bilderliste.Items.EndUpdate;
            end;
          end;
        end;
    finally
      DupList.Free;
    end;
  end;
end;

procedure TCollectionForm.AAllowDuplicatesUpdate(Sender: TObject);
var
  Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := Assigned(Sammlung);
  Action.Checked := Assigned(Sammlung) and Sammlung.AllowDuplicates;
end;

procedure TCollectionForm.BilderListeKeyPress(Sender: TObject; var Key: Char);
var
  Obj: TSammelobjekt;
begin
  if BilderListe.SelCount = 1 then begin
  	Obj := TSammelobjekt(BilderListe.Selected.Data);
    case Key of
      '+': if Assigned(Obj) then
        Obj.Haeufigkeit := Min(Obj.Haeufigkeit * 2, High(THaeufigkeit));
      '-': if Assigned(Obj) then
        Obj.Haeufigkeit := Obj.Haeufigkeit div 2;
      '0'..'9': if Assigned(Obj) then
        Obj.Haeufigkeit := 100 * StrToInt(Key);
    end;
  end;
end;

procedure TCollectionForm.AFileRepairExecute(Sender: TObject);
var
  RepairForm: TSammlungRepairForm;
begin
  RepairForm := TSammlungRepairForm.Create(Self);
  try
    RepairForm.Sammlung := Sammlung;
    RepairForm.PopupParent := Self;
    RepairForm.ShowModal;
  finally
    RepairForm.Free;
  end;
end;

initialization
  TP_GlobalIgnoreClassProperty(TCustomActionManager, 'FileName');
  TP_GlobalIgnoreClassProperty(TCustomActionManager, 'PrioritySchedule');
  TP_GlobalIgnoreClassProperty(TCustomActionManager, 'Style');
  TP_GlobalIgnoreClass(TJvCustomAppStorage);
  TP_GlobalIgnoreClass(TJvFormPlacement);
  TP_GlobalIgnoreClass(TJvDockBaseControl);
  TP_GlobalIgnoreClass(TJvDockObservableStyle);
  TCollectionForm.FRecentDocuments := nil;
	TCollectionForm.FSammlungClipFormat := RegisterClipboardFormat('KarstenBildersammlung');
finalization
  FreeAndNil(TCollectionForm.FRecentDocuments);
end.

