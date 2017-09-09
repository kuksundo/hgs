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
 * The Original Code is Karsten Bilderschau, version 3.2.12.
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

{ $Id: karsmain.pas 148 2010-02-20 20:31:17Z hiisi $ }

{
@abstract Document and window management
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2010-02-20 21:31:17 +0100 (Sa, 20 Feb 2010) $
}
unit karsmain;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, ComObj, ActiveX, karsten_TLB, syncObjs, ShlObj, StdVcl, XPMan,
	jclFileUtils, jclDateTime, jclShell, 
  shell, globals, sammlung, sammelfen, schaufen;

type
	TDocument = class
	private
		FFileName: string;
    FFileTime: TDateTime;
    // owner: Self (TDocument)
		FSammlung: TBilderSammlung;
    // owner: Application
		FSammlungsfenster: TCollectionForm;
    // owner: Application
		FSchaufenster: TSchaufenster;
		FOnFensterDestroy: TNotifyEvent;
    FAutoUpdate: boolean;
    FSHChangeNotifyID: cardinal;
    FAutoUpdateWindow: HWND;
		procedure SetFilename(const Value: string);
		procedure	FensterDestroy(Sender: TObject);
		function	GetFilename: string;
    procedure SetAutoUpdate(const Value: boolean);
  protected
    { Registers for shell change notification message
      for the @link(AutoUpdate) feature.
      @link(um_um_ShellChangeNotify) messages will be sent to the application main form. }
    procedure RegisterShellNotifier;
    { Unregisters the shell change notification message. }
    procedure UnregisterShellNotifier;
	public
		{ constructs the document and its Sammlung }
		constructor	Create;
		{ destroys the document and its Sammlung
		  the Sammlungsfenster and Schaufenster should be/have been closed by Application }
		destructor	Destroy; override;
		{ File name associated with the document.
      Setting the property does not load a file,
      call @link(LoadFile) to load the file into the open slide show or collection windows. }
		property	FileName: string read GetFileName write SetFileName;
    { Time stamp of the file when it was loaded.
      Call @link(UpdateFileTime) to read the time from the file system. }
    property  FileTime: TDateTime read FFileTime;
    { Reads the time stamp of the file @link(FileName) from the file system,
      and updates the @link(FileTime) property. }
    procedure UpdateFileTime;
    { Specifies whether the document should update
      when the file is changed by another program.
      This is currently supported only if there is no collection form. }
    property  AutoUpdate: boolean read FAutoUpdate write SetAutoUpdate;
    { Window to receive shell notification messages.
      Must be set if @link(AutoUpdate) is used. }
    property  AutoUpdateWindow: HWND read FAutoUpdateWindow write FAutoUpdateWindow;
    { Performs the auto update if requested and necessary. }
    procedure DoAutoUpdate;
		{ Creates a @link(TSammlungsfenster) with the document (or show it again).
      @param(monitorIndex refers to the monitor in Screen.Monitors
        where the window shall be shown.
        0 (default) = same as main form, 1 = primary, 2 = secondary, ...) }
		procedure	ShowSammlungsfenster(monitorIndex: integer = 0);
		{ Creates a @link(TSchaufenster) with the document (or show it again).
      @param(monitorIndex refers to the monitor in Screen.Monitors
        where the window shall be shown.
        0 (default) = same as main form, 1 = primary, 2 = secondary, ...) }
		procedure	ShowSchaufenster(monitorIndex: integer = 0);
    { Loads the file specified in @link(FileName) into the @link(Sammlung).
      This is used by @link(TKarstenLauncher) and the @link(AutoUpdate) feature. }
    procedure LoadFile;
		{ posts wm_Close to all document windows (except for COM-documents).
		  after a window has really closed (closing can be prohibited by OnCloseQuery)
		  an OnFensterDestroy event is generated. }
		procedure	Close;
    { Holds the collection of the document. }
		property	Sammlung: TBilderSammlung read FSammlung;
    { References the collection window if one is associated with the document.
      Call @link(ShowSammlungsfenster) to create a collection window. }
		property	Sammlungsfenster: TCollectionForm read FSammlungsfenster;
    { References the slide show window if one is associated with the document. 
      Call @link(ShowSchaufenster) to create a slide show window. }
		property	Schaufenster: TSchaufenster read FSchaufenster;
		// event occurs after all document windows have been destroyed. Sender=Self
		property	OnFensterDestroy: TNotifyEvent read FOnFensterDestroy write FOnFensterDestroy;
	end;

	{ all methods and properties except con/destructors are thread-safe
	  events are synchronized with ApplicationSection }
	TDocumentList = class(TThreadList)
	private
		FOnCreateDocument: TNotifyEvent;
		FOnRemoveDocument: TNotifyEvent;
		FOnEmptyList: TNotifyEvent;
		function GetCount: integer;
	protected
		procedure	Clear;
		procedure	DocumentFensterDestroy(Sender: TObject);
	public
		constructor Create;
		destructor Destroy; override;
		{ create new document in list. calls OnCreateDocument }
		function	CreateDocument: TDocument;
		{ calls TThreadList.Remove and OnRemoveDocument
		  if no document remains, also calls OnEmptyList }
		procedure Remove(Item: Pointer);
		{ calls TDocument.Close for all documents in the list }
		procedure	CloseDocuments;
    { Reloads slide show documents that have changed on disk. }
    procedure DoAutoUpdate;
		property	Count: integer read GetCount;
		property	OnCreateDocument: TNotifyEvent read FOnCreateDocument write FOnCreateDocument;
		property	OnRemoveDocument: TNotifyEvent read FOnRemoveDocument write FOnRemoveDocument;
		property	OnEmptyList: TNotifyEvent read FOnEmptyList write FOnEmptyList;
	end;

	TKarstenLauncher = class(TAutoObject, IKarstenLauncher)
	public
    procedure SammlungOeffnen(const filename: WideString; monitor: Integer);
      safecall;
    procedure DesktopWechseln(const filename: WideString; once: integer); safecall;
    procedure SchauStarten(const filename: WideString; modus, monitor,
      autoupdate: Integer); safecall;
    procedure DebugShowMainWin; safecall;
	end;

	TKarstenMain = class(TForm)
		Memo1: TMemo;
    XPManifest1: TXPManifest;
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
	private
		FDocumentList: TDocumentList;
	protected
		procedure	DocumentListEmpty(Sender: TObject);
		procedure	ComServerLastRelease(var shutdown: boolean);
		procedure	CloseWindows(var message: TMessage); message um_CloseWindows;
    procedure UMShellChangeNotify(var message: TMessage); message um_ShellChangeNotify;
	public
		property  DocumentList: TDocumentList read FDocumentList;
	end;

var
	KarstenMain: TKarstenMain;
	ApplicationSection: TCriticalSection;

procedure EvalStartupParameters;

implementation

uses
  ComServ, gnugettext, wallpaper, multimonitor;

{$R *.DFM}

procedure EvalStartupParameters;
var
	Launcher: IKarstenLauncher;
	idx: integer;
	param, value: string;
  opennew: boolean;
  monitor: integer;
  autoupdate: boolean;
begin
	if ComServer.StartMode=smStandalone then begin
		Launcher := CoKarstenLauncher.Create;
    idx := 1;
    opennew := true;
    monitor := 0;
    autoupdate := false;
    while idx <= ParamCount do begin
			param := LowerCase(paramStr(idx));
			if IsDelimiter('/-', ParamStr(idx), 1) then begin
        param := Copy(param, 2, Length(param));
        if idx < ParamCount then
          value := LowerCase(ParamStr(idx + 1))
        else
          value := '';
        if SameText(param, 'normal') then begin
          if FileExists(value) then begin
            Launcher.SchauStarten(value, Ord(amNormal), monitor, Ord(autoupdate));
            opennew := false;
          end;
          Inc(idx);
        end else if SameText(param, 'maximize') then begin
          if FileExists(value) then begin
            Launcher.SchauStarten(value, Ord(amMaxVollbild), monitor, Ord(autoupdate));
            opennew := false;
          end;
          Inc(idx);
        end else if SameText(param, 'noframe') then begin
          if FileExists(value) then begin
            Launcher.SchauStarten(value, Ord(amRahmenlos), monitor, Ord(autoupdate));
            opennew := false;
          end;
          Inc(idx);
        end else if SameText(param, 'wponce') then begin
          if FileExists(value) then begin
            Launcher.DesktopWechseln(value, 1);
            opennew := false;
          end;
          Inc(idx);
        end else if SameText(param, 'wpcont') then begin
          if FileExists(value) then begin
            Launcher.DesktopWechseln(value, 0);
            opennew := false;
          end;
          Inc(idx);
        end else if SameText(param, 'monitor') then begin
          monitor := StrToIntDef(value, 0);
          Inc(idx);
        end else if SameText(param, 'autoupdate') then begin
          autoupdate := true;
        end else if SameText(param, 'DebugShowMainWin') then begin
          Launcher.DebugShowMainWin;
          opennew := false;
        end;
      end else begin
      	if FileExists(param) then begin
					Launcher.SammlungOeffnen(param, monitor);
          opennew := false;
        end;
      end;
      Inc(idx);
    end;
		if opennew then Launcher.SammlungOeffnen('', monitor);
	end;
end;

{ TKarstenLauncher }

procedure TKarstenLauncher.SammlungOeffnen(const filename: WideString;
  monitor: Integer);
var
	Doc: TDocument;
begin
	Doc := KarstenMain.DocumentList.CreateDocument; // create a TBildersammlung
	Doc.ShowSammlungsfenster(monitor); // create and show a TLogoAppForm
	Doc.Sammlungsfenster.FileOpen(filename); // open file
  Doc.UpdateFileTime;
	KarstenMain.Memo1.Lines.Add(filename);
end;

procedure TKarstenLauncher.DesktopWechseln(const filename: WideString; once: Integer);
var
	Doc: TDocument;
  Sammlung: TBilderSammlung;
  WP: TWallpaper;
begin
	if once<>0 then begin
  	// change the wallpaper once and exit
	  Sammlung := TBilderSammlung.Create;
	  try
	  	Sammlung.LoadFromFile(filename);
	    Sammlung.SchaubildSchalten;
		  WP := TWallpaper.Create;
		  try
		  	WP.SetWallpaperBild(Sammlung.Schaubild);
		  finally
		  	WP.Free;
		  end;
	  finally
	  	FreeAndNil(Sammlung);
	  end;
  end else begin
  	// open a schaufenster in wallpaper mode
		Doc := KarstenMain.DocumentList.CreateDocument;
    Doc.FileName := filename;
    Doc.LoadFile;
	  Doc.ShowSchaufenster(0);
	  Doc.Schaufenster.AnzeigeModus := amWallpaper;
    Doc.Schaufenster.Angehalten := false;
  	KarstenMain.Memo1.Lines.Add(filename);
  end;
end;

procedure TKarstenLauncher.SchauStarten;
var
  Doc: TDocument;
  am: TAnzeigeModus;
begin
  if (modus >= Ord(Low(TAnzeigeModus))) and (modus <= Ord(High(TAnzeigeModus))) then
    am := TAnzeigeModus(modus)
  else
    am := amNormal;
  if not (am in [amNormal, amMaximiert, amMaxVollbild, amWallpaper, amRahmenlos]) then
    am := amNormal;
  Doc := KarstenMain.DocumentList.CreateDocument;
  Doc.Filename := filename;
  Doc.LoadFile; 
  Doc.ShowSchaufenster(monitor);
  Doc.Schaufenster.AnzeigeModus := am;
  Doc.Schaufenster.Angehalten := false;
  Doc.AutoUpdateWindow := KarstenMain.Handle;
  Doc.AutoUpdate := autoupdate <> 0;
  KarstenMain.Memo1.Lines.Add(filename);
end;

procedure TKarstenLauncher.DebugShowMainWin;
begin
  KarstenMain.Show;
end;

{ TDocumentList }

procedure TDocumentList.Clear;
var
	List:TList;
	idx:integer;
begin
	List := LockList;
	try
		with List do
			if Count>0 then
				for idx := 0 to Count-1 do
					TObject(Items[idx]).Free;
	finally
		UnlockList;
	end;
	inherited Clear;
end;

procedure TDocumentList.CloseDocuments;
var
	List:TList;
	idx:integer;
begin
	List := LockList;
	try
		if List.Count>0 then
			for idx := List.Count-1 downto 0 do
				(TObject(List.Items[idx]) as TDocument).Close;
	finally
		UnlockList;
	end;
end;

constructor TDocumentList.Create;
begin
	inherited;
end;

function TDocumentList.CreateDocument: TDocument;
begin
	Result := TDocument.Create;
	Result.OnFensterDestroy := DocumentFensterDestroy;
	Add(pointer(Result));
	if Assigned(FOnCreateDocument) then begin
		ApplicationSection.Enter;
		try
			OnCreateDocument(Self);
		finally
			ApplicationSection.Leave;
		end;
	end;
end;

destructor TDocumentList.Destroy;
begin
	Clear;
	inherited;
end;

procedure TDocumentList.DocumentFensterDestroy(Sender: TObject);
begin
	Remove(Sender);
end;

function TDocumentList.GetCount: integer;
var
	List:TList;
begin
	List := LockList;
	try
		result := List.Count;
	finally
		UnlockList;
	end;
end;

procedure TDocumentList.Remove(Item: Pointer);
var
	List:TList;
begin
	inherited;
	if Assigned(FOnRemoveDocument) then begin
		ApplicationSection.Enter;
		try
			OnRemoveDocument(Self);
		finally
			ApplicationSection.Leave;
		end;
	end;
	if Assigned(FOnEmptyList) then begin
		List := LockList;
		try
			if List.Count=0 then begin
				ApplicationSection.Enter;
				try
					OnEmptyList(Self);
				finally
					ApplicationSection.Leave;
				end;
			end;
		finally
			UnlockList;
		end;
	end;
end;

procedure TDocumentList.DoAutoUpdate;
var
	List: TList;
  Doc: TDocument;
  i: integer;
begin
	List := LockList;
	try
		for i := 0 to List.Count - 1 do begin
      Doc := TDocument(List[i]);
      Doc.DoAutoUpdate;
    end;
	finally
		UnlockList;
	end;
end;

{ TDocument }

constructor TDocument.Create;
begin
	inherited Create;
	FSammlung := TBilderSammlung.Create;
end;

destructor TDocument.Destroy;
begin
  UnregisterShellNotifier;
	FreeAndNil(FSammlung);
	inherited;
end;

function TDocument.GetFilename: string;
begin
	ApplicationSection.Enter;
	try
		if Assigned(FSammlungsfenster) then result := Sammlungsfenster.Filename else result := fFilename;
	finally
		ApplicationSection.Leave;
	end;
end;

procedure TDocument.SetAutoUpdate;
begin
  if Value <> FAutoUpdate then begin
    if Value then
      RegisterShellNotifier
    else
      UnregisterShellNotifier;
    FAutoUpdate := Value;
  end;
end;

procedure TDocument.RegisterShellNotifier;
var
  fsne: TSHChangeNotifyEntry;
const
  events = SHCNE_RENAMEITEM or SHCNE_CREATE or SHCNE_DELETE or
    SHCNE_UPDATEDIR or SHCNE_UPDATEITEM;
begin
  if
    (FSHChangeNotifyID = 0) and
    (FFileName <> '') and
    FileExists(FFileName) and
    Assigned(Application)
  then begin
    fsne.pidl := PathToPidl(ExtractFilePath(FFileName), nil);
    fsne.fRecursive := true;
    try
      FSHChangeNotifyID := SHChangeNotifyRegister(KarstenMain.Handle, 3,
        events, um_ShellChangeNotify, 1, @fsne);
    finally
      PidlFree(fsne.pidl);
    end;
  end;
end;

procedure TDocument.UnregisterShellNotifier;
var
  id: cardinal;
begin
  if FSHChangeNotifyID <> 0 then begin
    id := FSHChangeNotifyID;
    FSHChangeNotifyID := 0;
    SHChangeNotifyDeregister(id);
  end;
end;

procedure TDocument.SetFilename(const Value: string);
begin
	ApplicationSection.Enter;
	try
    if Value <> FFileName then begin
  		FFilename := Value;
      UnregisterShellNotifier;
      if FAutoUpdate then RegisterShellNotifier;
    end;
		if Assigned(FSammlungsfenster) then Sammlungsfenster.Filename := value;
	finally
		ApplicationSection.Leave;
	end;
end;

procedure TDocument.ShowSammlungsfenster;
begin
	ApplicationSection.Enter;
	try
    AutoUpdate := false;
		if Assigned(FSchaufenster) and Assigned(Schaufenster.Sammlungsfenster) then
			FSammlungsfenster := Schaufenster.Sammlungsfenster as TCollectionForm;
		if not Assigned(FSammlungsfenster) then begin
			Application.CreateForm(TCollectionForm,FSammlungsfenster);
			Sammlungsfenster.Sammlung := FSammlung;
			Sammlungsfenster.Filename := FFilename;
			Sammlungsfenster.Schaufenster := FSchaufenster;
			if Assigned(FSchaufenster) then Schaufenster.Sammlungsfenster := Sammlungsfenster;
		end;
		Sammlungsfenster.OnDestroy := FensterDestroy;
    Sammlungsfenster.MonitorController.SetMonitor(monitorIndex);
		Sammlungsfenster.Show
	finally
		ApplicationSection.Leave;
	end;
end;

procedure TDocument.ShowSchaufenster;
begin
	ApplicationSection.Enter;
	try
		if Assigned(FSammlungsfenster) and Assigned(Sammlungsfenster.Schaufenster) then
			FSchaufenster := Sammlungsfenster.Schaufenster;
		if not Assigned(FSchaufenster) then begin
			Application.CreateForm(TSchaufenster,FSchaufenster);
			Schaufenster.Sammlung := FSammlung;
			Schaufenster.Sammlungsfenster := FSammlungsfenster;
			if Assigned(FSammlungsfenster) then Sammlungsfenster.Schaufenster := Schaufenster;
		end;
		Schaufenster.OnDestroy := FensterDestroy;
    Schaufenster.MonitorController.SetMonitor(monitorIndex);
		Schaufenster.Show
	finally
		ApplicationSection.Leave;
	end;
end;

procedure TDocument.DoAutoUpdate;
var
  dt: TDateTime;
begin
  if AutoUpdate then begin
    if FFileName <> '' then begin
      dt := FileTimeToLocalDateTime(GetFileLastWrite(FFileName));
      if dt > FFileTime then
        LoadFile;
    end;
  end;
end;

procedure TDocument.LoadFile;
begin
  ApplicationSection.Enter;
  try
    if Assigned(Sammlung) then begin
      Sammlung.BeginUpdate;
      try
        Sammlung.FreeAll;
        Sammlung.LoadFromFile(Filename);
        UpdateFileTime;
      finally
        Sammlung.EndUpdate;
      end;
    end;
  finally
    ApplicationSection.Leave;
  end;
end;

procedure TDocument.UpdateFileTime;
begin
  if FFileName <> '' then
    FFileTime := FileTimeToLocalDateTime(GetFileLastWrite(FFileName));
end;

procedure TDocument.FensterDestroy(Sender: TObject);
begin
	if Sender is TSchaufenster then FSchaufenster := nil;
	if Sender is TCollectionForm then begin
		fFilename := Sammlungsfenster.Filename;
		FSammlungsfenster := nil;
	end;
	if Assigned(FOnFensterDestroy) and
		not (Assigned(FSchaufenster) or Assigned(FSammlungsfenster)) then
			OnFensterDestroy(Self);
end;

procedure TDocument.Close;
begin
  UnregisterShellNotifier;
	if Assigned(FSammlungsfenster) then
    PostMessage(Sammlungsfenster.Handle, wm_Close, 0, 0)
	else if Assigned(FSchaufenster) then 
    PostMessage(Schaufenster.Handle, wm_Close, 0, 0);
end;

{ TKarstenMain }

procedure TKarstenMain.ComServerLastRelease(var shutdown: boolean);
begin
	shutdown := DocumentList.Count=0;
end;

procedure TKarstenMain.DocumentListEmpty(Sender: TObject);
begin
	if ComServer.ObjectCount=0 then PostMessage(Handle,wm_Close,0,0);
end;

procedure TKarstenMain.FormCreate(Sender: TObject);
begin
  TranslateComponent(Self);
	FDocumentList := TDocumentList.Create;
	DocumentList.OnEmptyList := DocumentListEmpty;
	ComServer.OnLastRelease := ComServerLastRelease;
  ShowWindow(Application.Handle, SW_HIDE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
    GetWindowLong(Application.Handle, GWL_EXSTYLE) and not WS_EX_APPWINDOW
    or WS_EX_TOOLWINDOW);
  ShowWindow(Application.Handle, SW_SHOW);
end;

procedure TKarstenMain.FormDestroy(Sender: TObject);
begin
	FreeAndNil(FDocumentList);
end;

procedure TKarstenMain.FormCloseQuery(Sender: TObject;
	var CanClose: Boolean);
begin
	canClose := canClose and (ComServer.ObjectCount=0) {and (DocumentList.Count=0)};
end;

procedure TKarstenMain.FormClose(Sender: TObject;
	var Action: TCloseAction);
begin
	DocumentList.CloseDocuments;
	action := caFree;
end;

procedure TKarstenMain.CloseWindows(var message: TMessage);
begin
	DocumentList.CloseDocuments;
end;

procedure TKarstenMain.UMShellChangeNotify;
begin
  DocumentList.DoAutoUpdate;
end;

initialization
	ApplicationSection := TCriticalSection.Create;
	if IsFirstAppInstance then
		TAutoObjectFactory.Create(ComServer, TKarstenLauncher, Class_KarstenLauncher,
			ciMultiInstance, tmApartment);
			// COM objects shall be created only within the first application instance
finalization
	FreeAndNil(ApplicationSection);
end.

