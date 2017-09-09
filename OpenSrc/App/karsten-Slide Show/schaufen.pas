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
 * The Original Code is schaufen.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: schaufen.pas 128 2008-11-26 05:25:10Z hiisi $ }

{
@abstract SlideShow window
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 1999/07/24
@cvs $Date: 2008-11-25 23:25:10 -0600 (Di, 25 Nov 2008) $

Slide shows are run by the @link(TSchaufenster) class
(also the ones that display in external windows).
}
unit SchauFen;
{<pre>
pendenzen
-movie-wiedergabe ueber directshow
 -tastaturbefehle von video-fenster abfangen
 -stayontop fuer dscontrol
-sammlung: neues objekt fuehrt nicht mehr zu modified
-external-window-verfahren (aufgabenteilung mit SSTestPreviewWin)
  bildschirmflackern beim vorschau-start vermeiden!
</pre>}

{$R schaufen.res}

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtCtrls, StdCtrls, Menus, bildklassen, KarsCanv, ImgList, KarsReg,
	schnittstellen, globals, MPlayer, sammelklassen, karsten_tlb,
	ShellAPI, wallpaper, registry, sammlung, Mediaplayer, dscontrol,
  DirectShow, JvComponentBase, JvScreenSaveSuppress, ActnList, PngImageList,
  ActnPopup, multimonitor;

type
  //das OnDestroy-ereignis kann von externen objekten abgefangen werden.
	TSchaufenster = class(TForm)
		TiBildwechsel: TTimer;
    ScreenSaveSuppressor: TJvScreenSaveSuppressor;
    ShowContextMenu: TPopupActionBar;
    ShowActionList: TActionList;
    ShowImageList: TPngImageList;
    ShowPauseAction: TAction;
    ShowResumeAction: TAction;
    ShowProceedAction: TAction;
    ShowStopMediaAction: TAction;
    ShowMediaControlAction: TAction;
    ShowGotoCollectionAction: TAction;
    ShowPickColorAction: TAction;
    ShowCloseAction: TAction;
    ShowModeWindowAction: TAction;
    ShowModeBorderlessAction: TAction;
    ShowModeFullScreenAction: TAction;
    ShowModeWallpaperAction: TAction;
    ShowPauseItem: TMenuItem;
    ShowResumeItem: TMenuItem;
    ShowProceedItem: TMenuItem;
    ShowStopMediaItem: TMenuItem;
    ShowMediaControlItem: TMenuItem;
    ShowSeparator2: TMenuItem;
    ShowCloseItem: TMenuItem;
    ShowGotoCollectionItem: TMenuItem;
    ShowSeparator3: TMenuItem;
    ShowModeItem: TMenuItem;
    ShowSeparator1: TMenuItem;
    ShowModeWindowItem: TMenuItem;
    ShowModeBorderlessItem: TMenuItem;
    ShowModeFullScreenItem: TMenuItem;
    ShowModeWallpaperItem: TMenuItem;
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure FormDeactivate(Sender: TObject);
		procedure FormHide(Sender: TObject);
		procedure FormPaint(Sender: TObject);
		procedure FormResize(Sender: TObject);
		procedure FormDblClick(Sender: TObject);
		procedure ShowGotoCollectionActionExecute(Sender: TObject);
		procedure ShowDisplayModeActionExecute(Sender: TObject);
		procedure ShowPauseActionExecute(Sender: TObject);
		procedure ShowCloseActionExecute(Sender: TObject);
		procedure ShowProceedActionExecute(Sender: TObject);
		procedure ShowPickColorActionExecute(Sender: TObject);
		procedure TiBildwechselTimer(Sender: TObject);
		procedure MediaPlayerNotify(Sender: TObject);
		procedure ShowStopMediaActionExecute(Sender: TObject);
		procedure ShowMediaControlActionExecute(Sender: TObject);
		procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ShowPauseActionUpdate(Sender: TObject);
    procedure ShowProceedActionUpdate(Sender: TObject);
    procedure ShowStopMediaActionUpdate(Sender: TObject);
    procedure ShowMediaControlActionUpdate(Sender: TObject);
    procedure ShowGotoCollectionActionUpdate(Sender: TObject);
    procedure ShowPickColorActionUpdate(Sender: TObject);
    procedure ShowDisplayModeActionUpdate(Sender: TObject);
    procedure ShowResumeActionExecute(Sender: TObject);
    procedure ShowResumeActionUpdate(Sender: TObject);
	private
    {Implements ISammlungsfenster}
		FSammlungsfenster: TCustomForm;
		FSammlung: TBildersammlung;
		FSchauCanvas: TKarstenCanvas;
		FSchaubild: TSammelobjekt;
		FBild: TBildobjekt;
		FWallpaper: TWallpaper;
    { Original WindowProc method of the VCL. }
		FOriginalWndProc: TWndMethod;
    { Internal display mode.
      @link(amNormal), @link(amRahmenlos), @link(amDesktopDirekt),
      @link(amWallpaper) allowed only.
      The property @link(AnzeigeModus) can assume any declared display mode
      (user display mode). }
		FAnzeigeModus: TAnzeigeModus;
		FAngehalten: boolean;
		FFarbAufnahme: boolean;
		FExternalWindow: hWnd;
		FOnInvalidWindow: TExceptionEvent;
		FMediaPlayerForm: TMediaPlayerForm;
		FMediaPlayer: TMediaPlayer;
		FShowMediaPlayerForm: boolean;
		FDisableUserActions: boolean;
		FSetup: boolean;
		FError: boolean;
		FErrorTitle: string;
		FErrorMessage: string;
		FInhibitPainting: boolean;
    FDirectShowControl: TDirectShowControl;
    FMonitorController: TMonitorController;
		procedure SetAnzeigeModus(modus: TAnzeigeModus);
		function	GetAnzeigeModus: TAnzeigeModus;
		function	GetSchauCanvas: TKarstenCanvas;
		procedure ReCreateCanvas;
		procedure SetAngehalten(value: boolean);
		procedure WMNCHitTest(var message: TWMNCHitTest); message wm_NCHitTest;
		procedure WMEraseBkgnd(var message: TWMEraseBkgnd); message WM_ERASEBKGND;
		procedure WMNCRButtonUp(var message: TWMNCRButtonUp); message wm_NCRButtonUp;
		procedure SetSchaubild(const Value: TSammelobjekt);
		procedure	SetBild(const Value:TBildobjekt);
		procedure PaintPicture;
		procedure	UMSpecialPaint(var message: TWMNoParams); message um_SpecialPaint;
		procedure SetFarbAufnahme(const Value: boolean);
		procedure FarbAufnahmeWndProc(var message:tMessage);
		procedure InhibitPaintingWndProc(var message:tMessage);
		procedure SetExternalWindow(const Value: hWnd);
		procedure MediaPlayerClick(Sender: TObject; Button: TMPBtnType;
			var DoDefault: Boolean);
		procedure SetSammlung(const Value: TBildersammlung);
		procedure SetDisableUserActions(const Value: boolean);
		procedure SetInhibitPainting(const Value: boolean);
    procedure DirectShowMediaEvent(Sender: TObject; eventcode: integer);
    procedure DirectShowControlShortCut(var Msg: TWMKey; var Handled: Boolean);
	protected
    { This form shall have its own task bar button. }
    procedure CreateParams(var Params: TCreateParams); override;
    { Override delphi's minimization/maximization mechanism. }
    procedure WMSysCommand(var message: TWMSysCommand); message WM_SYSCOMMAND;
		procedure FormSetup; virtual;
		property	SchauCanvas:TKarstenCanvas read GetSchauCanvas;
		property	FarbAufnahme:boolean read fFarbAufnahme write SetFarbAufnahme;
		procedure	UMWeiterschalten(var message: TWMNoParams); message um_Weiterschalten;
		procedure WMDropFiles(var message: TWMDropFiles); message wm_DropFiles;
		procedure	WMPowerBroadcast(var message: TMessage); message wm_PowerBroadcast;
    { Displays the given error message as the only content of the window.
      The message is saved to private fields,
      and displayed by the @link(PaintPicture) method
      during the regular paint event.

      @param(title A title of the message, to be displayed in bold font)
      @param(msg A detailed message string, to be displayed in plain font) }
		procedure ShowErrorMessage(const title, msg: string);
		procedure	ClearErrorMessage;
	public
		constructor Create(AOwner: TComponent); override;
		destructor  Destroy; override;
		property  OnInvalidWindow: TExceptionEvent read FOnInvalidWindow write FOnInvalidWindow;
		property  AnzeigeModus: TAnzeigeModus read GetAnzeigeModus write SetAnzeigeModus;
		(*procedure	ISchaufenster.AnzeigemodusWechseln=SetAnzeigeModus;*)
		property  ExternalWindow: hWnd read FExternalWindow write SetExternalWindow;
		property  Angehalten: boolean read fAngehalten write SetAngehalten;
		(*procedure ISchaufenster.AblaufmodusWechseln=SetAngehalten;*)
		//aus beliebiger hierarchiestufe aufrufbar, da das schalten ?er PostMessage verz?ert wird
		procedure Weiterschalten;
		procedure StopAnimation;
    { This is a reference to the original sammelobjekt. }
		property  Schaubild: TSammelobjekt read FSchaubild write SetSchaubild;
		property  Bild: TBildobjekt read FBild write SetBild;

		property  Sammlungsfenster: TCustomForm read FSammlungsfenster write FSammlungsfenster; //verweis!
		property  Sammlung: TBildersammlung read FSammlung write SetSammlung; //verweis!
		property  MediaPlayerForm: TMediaPlayerForm read FMediaPlayerForm;
		property  MediaPlayer: TMediaPlayer read FMediaPlayer;
    property  DirectShowControl: TDirectShowControl read FDirectShowControl;
  	{ TODO 5 : DisableUserActions is not implemented yet. }
		property  DisableUserActions: boolean read FDisableUserActions write SetDisableUserActions;
		{	unterdr?kt FormPaint bis zum n?hsten bildschalten, um das aufblinken
			des fensters w?rend einem moduswechsel zu vermeiden. wird von
			UMWeiterschalten automatisch zur?kgesetzt. }
		property  InhibitPainting: boolean read FInhibitPainting write SetInhibitPainting;
    { Moves the form to a specific monitor. }
    property  MonitorController: TMonitorController read FMonitorController;
	end;

var
	Schaufenster: TSchaufenster;

const
	crPipette = 1;

implementation
uses
  Math, gnugettext, Jpeg, pngimage {$ifdef gifimage} , gifimage {$endif} ;

{$R *.DFM}

resourcestring
	SSchaufenstertitel = 'Karsten SlideShow';
	SDragNDrop = 'Drag&Drop';
	SESetBild = 'Error loading file';
	SEPaintPicture = 'Error displaying image';
	SEWeiterschalten = 'Error switching image';
	SEKeinBild = 'No image loaded';

type
	TAnzeigeModusUmwandlung = record
		amuInternerModus: TAnzeigeModus;
		amuFensterStatus: TWindowState;
		amuVisible: boolean;
		amuRahmenStil: TFormBorderStyle;
	end;

const
	cAnzeigeModi: array[TAnzeigeModus] of TAnzeigeModusUmwandlung = (
		(amuInternerModus: amNormal;        amuFensterStatus: wsNormal;    amuVisible: false; amuRahmenStil:bsSizeable),  //amVersteckt
		(amuInternerModus: amNormal;        amuFensterStatus: wsNormal;    amuVisible: true;  amuRahmenStil:bsSizeable),  //amNormal
		(amuInternerModus: amNormal;        amuFensterStatus: wsMaximized; amuVisible: true;  amuRahmenStil:bsSizeable),  //amMaximiert
		(amuInternerModus: amNormal;        amuFensterStatus: wsMinimized; amuVisible: true;  amuRahmenStil:bsSizeable),  //amMinimiert
		(amuInternerModus: amRahmenlos;     amuFensterStatus: wsMaximized; amuVisible: true;  amuRahmenStil:bsNone),      //amMaxVollbild
		(amuInternerModus: amDesktopDirekt; amuFensterStatus: wsMinimized; amuVisible: false; amuRahmenStil:bsSizeable),  //amDesktopDirekt
		(amuInternerModus: amWallpaper;     amuFensterStatus: wsMinimized; amuVisible: false; amuRahmenStil:bsSizeable),  //amWallpaper
		(amuInternerModus: amRahmenlos;     amuFensterStatus: wsNormal;    amuVisible: true;  amuRahmenStil:bsNone),			//amRahmenlos
		(amuInternerModus: amExtern;        amuFensterStatus: wsNormal;    amuVisible: false; amuRahmenStil:bsSizeable)   //amExtern
		);

constructor TSchaufenster.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
  TranslateComponent(Self);
	fAnzeigeModus := amNormal;
	fError := true;
	fErrorTitle := seKeinBild;
	fErrorMessage := '';
	Caption := sSchaufenstertitel;
	fFarbAufnahme := false;
	FOriginalWndProc := WindowProc;
	FBild := TBilderrahmen.Create;
  FMonitorController := TMonitorController.Create(Self);
	FMediaPlayerForm := TMediaPlayerForm.Create(Self);
	FMediaPlayer := MediaPlayerForm.MediaPlayer;
	MediaPlayer.OnNotify := MediaPlayerNotify;
	MediaPlayer.OnClick := MediaPlayerClick;
  FDirectShowControl := TDirectShowControl.Create(Self);
  DirectShowControl.OnMediaEvent := DirectShowMediaEvent;
  DirectShowControl.OnShortCut := DirectShowControlShortCut;
end;

procedure TSchaufenster.CreateParams;
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle and not WS_EX_TOOLWINDOW or WS_EX_APPWINDOW;
end;

procedure TSchaufenster.WMSysCommand;
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

procedure TSchaufenster.FormActivate(Sender: TObject);
begin
	if fSetup then FormSetup;
	fSetup := false;
end;

procedure TSchaufenster.FormSetup;
begin
	if ClassType = TSchaufenster then begin
    DragAcceptFiles(Handle, true);
    ScreenSaveSuppressor.Active := true;
  end;
end;

procedure TSchaufenster.FormDeactivate(Sender: TObject);
begin
	FarbAufnahme := false;
end;

procedure TSchaufenster.FormClose(Sender: TObject;
	var Action: TCloseAction);
begin
  StopAnimation;
	WindowState := wsNormal;
  if Assigned(Sammlungsfenster)
    then action := caHide
    else action := caFree;
	Angehalten := true;
	FSchaubild := nil;
  if Assigned(FWallpaper) then begin
    FWallpaper.RestoreWallpaper;
    FreeAndNil(FWallpaper);
  end;
end;

procedure TSchaufenster.FormHide(Sender: TObject);
begin
	FarbAufnahme := false;
  StopAnimation;
	if Assigned(MediaPlayerForm) then MediaPlayerForm.Hide;
  if Assigned(DirectShowControl) then DirectShowControl.Hide;
end;

destructor TSchaufenster.Destroy;
begin
  try
  	DragAcceptFiles(Handle,false);
  	MediaPlayer.Close;
  	MediaPlayer.Display := nil;
  except
  end;
	FMediaPlayer := nil;
	FSammlung := nil;
	FSammlungsfenster := nil;
	FreeAndNil(FSchauCanvas);
	FreeAndNil(FWallpaper);
	FreeAndNil(FBild);
	FreeAndNil(FMediaPlayerForm);
  FreeAndNil(FDirectShowControl);
  FreeAndNil(FMonitorController);
	inherited;
end;

procedure TSchaufenster.ShowGotoCollectionActionExecute(Sender: TObject);
begin
	if Assigned(Sammlungsfenster) then Sammlungsfenster.Show;
end;

procedure TSchaufenster.ShowGotoCollectionActionUpdate(Sender: TObject);
var
	Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
  Action.Enabled := Assigned(Sammlungsfenster);
end;

procedure TSchaufenster.SetSchaubild;
begin
	StopAnimation;
	if Assigned(Value) then begin
		try
			TiBildwechsel.Enabled := false;
      TiBildwechsel.Interval := Value.Wartezeit * 1000;
			if Length(Value.Name)>0 then
				Caption := sSchaufenstertitel+' - '+Value.Name
			else
				Caption := sSchaufenstertitel;
			Bild := Value.Bild;
			FSchaubild := Value;
      TiBildwechsel.Enabled := not FAngehalten and
        (not Assigned(Bild.MediaType) or
        not (Bild.MediaType.Grafikformat in [gfMCI, gfDirectShow, gfOLE]));
    except
      on EKarstenException do begin
        TiBildwechsel.Interval := 5000;
        TiBildwechsel.Enabled := not FAngehalten;
      end;
		end;
	end else FSchaubild := nil;
end;

procedure TSchaufenster.SetBild(const Value: TBildobjekt);
var
	alterCursor: TCursor;
	gf: TGrafikformat;
begin
	StopAnimation;
	if Assigned(Value) and Assigned(Value.MediaType) then begin
		ClearErrorMessage;
		try
			alterCursor := Screen.Cursor;
			if alterCursor<>crNone then Screen.Cursor := crHourGlass;
			try
        // release previous picture
				try
					if Assigned(FBild) and Assigned(FBild.AusgabePlayer) then begin
            FShowMediaPlayerForm := FBild.AusgabePlayer.Visible;
            FBild.AusgabePlayer.Hide;
          end;
				except
					on EAccessViolation do fShowMediaPlayerForm := false;
				end;
				FBild.BildFreigeben;
				FSchaubild := nil;	//Bildbearbeitung := nil;
        // set new picture
				FBild.Assign(Value);
				gf := FBild.MediaType.Grafikformat;
        // display new picture
				FBild.AusgabeCanvas := SchauCanvas;
        case gf of
          gfMCI: begin
    				MediaPlayer.Display := Self;
    				FBild.AusgabePlayer := MediaPlayer;
          end;
          gfDirectShow: begin
            FBild.AusgabePlayer := DirectShowControl;
          end;
          else begin
            FBild.AusgabePlayer := nil;
          end;
        end;
				case fAnzeigeModus of
					amWallpaper: begin
            if not (gf in [gfMCI, gfDirectShow, gfOLE])
						then FWallpaper.SetWallpaperBild(FBild)
						else Weiterschalten;
          end;
					amExtern: begin
            FBild.AusgabeWindow := ExternalWindow;
            if not (gf in [gfMCI, gfDirectShow, gfOLE])
						then PostMessage(Handle,um_SpecialPaint,0,0)
						else Weiterschalten;
          end;
					else begin
            FBild.AusgabeWindow := Handle;
						FBild.BildLaden;
						if Visible then Invalidate else PostMessage(Handle,um_SpecialPaint,0,0);
					end;
				end;
        if Assigned(FBild.AusgabePlayer) then
          FBild.AusgabePlayer.Visible := FShowMediaPlayerForm;
			finally
				Screen.Cursor := alterCursor;
			end;
		except
			on E:Exception do ShowErrorMessage(seSetBild,E.Message);
		end;
	end;
end;

procedure TSchaufenster.MediaPlayerClick(Sender: TObject; Button: TMPBtnType; var DoDefault: Boolean);
begin
	case button of
		btStop: begin
			Bild.BildFreigeben;
			with MediaPlayer do
				EnabledButtons := EnabledButtons+[btPause]-[btPlay];
			Weiterschalten;
			doDefault := false;
		end;
		btPlay: with MediaPlayer do
			EnabledButtons := EnabledButtons+[btPause]-[btPlay];
		btPause: with MediaPlayer do
			EnabledButtons := EnabledButtons+[btPlay]-[btPause];
		else with MediaPlayer do
			EnabledButtons := EnabledButtons+[btPlay]-[btPause];
	end;
end;

procedure TSchaufenster.MediaPlayerNotify(Sender: TObject);
begin
	if MediaPlayer.NotifyValue<>nvAborted then begin
		Bild.BildFreigeben;
		if not Angehalten then Weiterschalten;
	end;
end;

procedure TSchaufenster.DirectShowMediaEvent(Sender: TObject;
  eventcode: integer);
begin
  if
    (eventcode = EC_COMPLETE) or
    (eventcode = EC_USERABORT) or
    (eventcode = EC_ERRORABORT)
  then begin
    DirectShowControl.Stop;
    Bild.BildFreigeben;
		if not Angehalten then Weiterschalten;
  end;
end;

procedure TSchaufenster.DirectShowControlShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  Handled := ShowActionList.IsShortCut(Msg);
end;

procedure TSchaufenster.StopAnimation;
begin
  if Assigned(FBild) and Assigned(FBild.MediaType) then
    case FBild.MediaType.Grafikformat of
      gfMCI: with MediaPlayer do
    		if (deviceID<>0) and (Mode in [mpPlaying,mpRecording,mpSeeking,mpPaused])
    			then Stop;
      gfDirectShow: DirectShowControl.Stop;
    end;
end;

procedure TSchaufenster.Weiterschalten;
begin
	TiBildwechsel.Enabled := false;
	PostMessage(Handle,um_Weiterschalten,0,0);
end;

procedure TSchaufenster.UMWeiterschalten;
var
	alterCursor: TCursor;
begin
	TiBildwechsel.Enabled := false;
	FInhibitPainting := false;
	if AnzeigeModus <> amVersteckt then begin
		alterCursor := Screen.Cursor;
		if alterCursor <> crNone then Screen.Cursor := crHourglass;
		try
			Sammlung.SchaubildSchalten;
			Schaubild := Sammlung.Schauobjekt;
		except
			on E: Exception do begin
        ShowErrorMessage(seWeiterschalten, E.Message);
        TiBildwechsel.Interval := 5000;
        TiBildwechsel.Enabled := true;
      end;
		end;
		Screen.Cursor := alterCursor;
	end;
end;

procedure TSchaufenster.ShowStopMediaActionExecute(Sender: TObject);
begin
	StopAnimation;
end;

procedure TSchaufenster.ShowStopMediaActionUpdate(Sender: TObject);
var
	Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
	Action.Enabled := Assigned(Bild) and Assigned(Bild.MediaType) and
    (Bild.MediaType.Grafikformat in [gfMCI, gfDirectShow]);
end;

procedure TSchaufenster.ShowMediaControlActionExecute(Sender: TObject);
begin
	FShowMediaPlayerForm := true;
  if Assigned(FBild.AusgabePlayer) then FBild.AusgabePlayer.Show;
end;

procedure TSchaufenster.ShowMediaControlActionUpdate(Sender: TObject);
var
	Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
	Action.Enabled := Assigned(Bild) and Assigned(Bild.MediaType) and
    (Bild.MediaType.Grafikformat in [gfMCI, gfDirectShow]);
end;

procedure TSchaufenster.ShowProceedActionExecute(Sender: TObject);
begin
	Weiterschalten;
end;

procedure TSchaufenster.ShowProceedActionUpdate(Sender: TObject);
var
	Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
	Action.Enabled := Assigned(Sammlung) and (Sammlung.Count > 0);
end;

procedure TSchaufenster.TiBildwechselTimer(Sender: TObject);
begin
	Weiterschalten;
end;

procedure TSchaufenster.WMDropFiles(var message: tWMDropFiles);
var
	nFiles:cardinal;
	filename:string;
	AufbauBild:TSammelbild;
begin
	try
		nFiles := DragQueryFile(message.drop,$FFFFFFFF,nil,0);
		if nFiles>0 then begin
			SetLength(filename,max_Path);
			SetLength(filename,
				DragQueryFile(message.drop,0,pChar(filename),Length(filename)));
			if (Length(filename)>0) and FileExists(filename) then begin
				AufbauBild := TSammelbild.Create;
				try
					AufbauBild.Pfad := filename;
					AufbauBild.Name := sDragNDrop+': '+ExtractFileName(filename);
					Angehalten := true;
					Schaubild := AufbauBild;
					Angehalten := true;
				finally
					AufbauBild.Free;
					Schaubild := nil;
				end;
			end;
		end;
	finally
		DragFinish(message.drop);
		message.Result := 0;
	end;
end;

procedure TSchaufenster.PaintPicture;
var
	zf: TRect;

	procedure PaintErrorMessage;
	var
		ts:tSize;
		midtop:tPoint;
	begin
		with SchauCanvas do begin
			Brush.Color := clWindow;
			Font.Style := Font.Style+[fsBold];
			ts := TextExtent(fErrorTitle);
			midtop.x := zf.Right+zf.Left;
			midtop.y := zf.Top+5;
			TextOut((midtop.x-ts.cx) div 2,midtop.y,fErrorTitle);
			midtop.y := midtop.y+ts.cy+2;
			Font.Style := Font.Style-[fsBold];
			ts := TextExtent(fErrorMessage);
			TextOut((midtop.x-ts.cx) div 2,midtop.y,fErrorMessage);
		end;
	end;

begin
	if Assigned(SchauCanvas) then with SchauCanvas do begin
		try
			BeginPaint;
			try
				zf := Zeichenflaeche;
				if FError then PaintErrorMessage
				else begin
					if (FAnzeigeModus=amDesktopDirekt)
						then Brush.Color := clBackground
						else Brush.Color := Bild.Hintergrundfarbe;
					FillRect(zf);
					Bild.BildZeichnen(zf);
          case Bild.MediaType.Grafikformat of
            gfMCI:
              if
                not Assigned(MediaPlayerForm) or
                not (MediaPlayerForm.MediaPlayer.Mode in [mpPlaying, mpSeeking, mpPaused])
              then begin
                TiBildwechsel.Interval := 5000;
                TiBildwechsel.Enabled := true;
              end;
            gfDirectShow:
              if
                not Assigned(DirectShowControl) or
                not DirectShowControl.Playing
              then begin
                TiBildwechsel.Interval := 5000;
                TiBildwechsel.Enabled := true;
              end;
          end;
				end;
			finally
				EndPaint;
			end;
		except
			on E: EInvalidWindowHandle do
				if Assigned(OnInvalidWindow) then OnInvalidWindow(Self, E) else raise;
			on E: Exception do begin
        ShowErrorMessage(sePaintPicture, E.Message);
        TiBildwechsel.Interval := 5000;
        TiBildwechsel.Enabled := true;
      end;
		end;
	end;
end;

procedure TSchaufenster.WMEraseBkgnd(var message: tWMEraseBkgnd);
begin
	if FError then inherited else message.result := 1;
end;

procedure TSchaufenster.UMSpecialPaint(var message: tWMNoParams);
begin
	if Visible then Invalidate else FormPaint(nil);
end;

procedure TSchaufenster.FormPaint(Sender: TObject);
var
	alterCursor:tCursor;
begin
	if FInhibitPainting then Exit;
	alterCursor := Screen.Cursor;
	if alterCursor<>crNone then Screen.Cursor := crHourglass;
	try
		if not (AnzeigeModus in [amVersteckt,amMinimiert,amWallpaper])
			then PaintPicture;
	finally
		Screen.Cursor := alterCursor;
	end;
end;

procedure TSchaufenster.SetInhibitPainting(const Value: boolean);
begin
	if FInhibitPainting xor value then begin
		FInhibitPainting := Value;
		if FInhibitPainting then WindowProc := InhibitPaintingWndProc else WindowProc := fOriginalWndProc;
	end;
end;

procedure TSchaufenster.InhibitPaintingWndProc(var message: tMessage);
begin
	if (message.msg=wm_Paint) or (message.msg=wm_NCPaint)
	then message.Result := 0 else FOriginalWndProc(message);
end;

procedure TSchaufenster.ClearErrorMessage;
begin
	fError := false;
end;

procedure TSchaufenster.ShowErrorMessage(const title,msg: string);
begin
	fError := true;
	fErrorTitle := title;
	fErrorMessage := msg;
	Invalidate;
end;

procedure TSchaufenster.FormResize(Sender: TObject);
begin
	Invalidate;
end;

function TSchaufenster.GetAnzeigeModus: tAnzeigeModus;
begin
	result := fAnzeigeModus;
	case fAnzeigeModus of
		amNormal: if Visible then begin
				case WindowState of
					wsMaximized: if BorderStyle=bsNone
							then result := amMaxVollbild
							else result := amMaximiert;
					wsMinimized: result := amMinimiert;
					wsNormal: if BorderStyle=bsNone then result := amRahmenlos;
				end;
			end else result := amVersteckt;
		amRahmenlos: if WindowState=wsMaximized then result := amMaxVollbild;
	end;
end;

procedure TSchaufenster.SetAnzeigeModus;
var
	modAlt, intModAlt, intModNeu: TAnzeigeModus;
begin
	intModAlt := fAnzeigeModus;
	intModNeu := cAnzeigeModi[modus].amuInternerModus;
	modAlt := GetAnzeigeModus;
	if modus<>modAlt then begin
		fAnzeigeModus := intModNeu;
		case intModAlt of
			amDesktopDirekt: Windows.InvalidateRect(0,nil,true);
			amWallpaper: begin
      	if Assigned(FWallpaper) then FWallpaper.RestoreWallpaper;
      	FWallpaper.Free;
        FWallpaper := nil
      end;
		end;
		if intModAlt<>intModNeu then ReCreateCanvas;
		case intModNeu of
			amWallpaper: if not Assigned(FWallpaper) then begin
				FWallpaper := TWallpaper.Create;
        FWallpaper.SaveWallpaper;
      end;
		end;
		if cAnzeigeModi[modus].amuVisible then begin
			//f? verl?sliche fenstergr?sen-buchhaltung Borderstyle nur im wsNormal umschalten:
			if BorderStyle<>cAnzeigeModi[modus].amuRahmenstil then WindowState := wsNormal;
			BorderStyle := cAnzeigeModi[modus].amuRahmenstil;
			WindowState := cAnzeigeModi[modus].amuFensterStatus;
			Show;
			Invalidate;
		end else begin
			WindowState := cAnzeigeModi[modus].amuFensterStatus;
			Hide;
			FormPaint(nil);
		end;
	end;
end;

procedure TSchaufenster.SetExternalWindow(const Value: hWnd);
begin
	FExternalWindow := Value;
	if fAnzeigeModus=amExtern then
		(SchauCanvas as TExternalCanvas).WindowHandle := value;
end;

function TSchaufenster.GetSchauCanvas: TKarstenCanvas;
begin
	if not Assigned(FSchauCanvas) then ReCreateCanvas;
	Result := FSchauCanvas;
end;

procedure TSchaufenster.ReCreateCanvas;
// SchauCanvas-objekt gem?s fAnzeigeModus erzeugen
var
	neueKlasse,alteKlasse:TKarstenCanvasKlasse;
begin
	if Assigned(FSchauCanvas) then
		alteKlasse := TKarstenCanvasKlasse(FSchauCanvas.ClassType)
	else alteKlasse := nil;
	case fAnzeigeModus of
		{amRahmenlos    : neueKlasse := TWindowCanvas;}
		amDesktopDirekt: neueKlasse := TDesktopCanvas;
		amExtern:				neueKlasse := TExternalCanvas;
		else              neueKlasse := TClientCanvas;
	end;
	if neueKlasse<>alteKlasse then begin
		FSchauCanvas.Free;
		FSchauCanvas := nil;
		FSchauCanvas := NeueKlasse.Create(Self);
	end;
	if (fAnzeigeModus=amExtern) and (fExternalWindow<>0)
		then (FSchauCanvas as TExternalCanvas).WindowHandle := fExternalWindow;
end;

procedure TSchaufenster.ShowDisplayModeActionExecute(Sender: TObject);
begin
	AnzeigeModus := TAnzeigeModus((Sender as TComponent).Tag);
end;

procedure TSchaufenster.ShowDisplayModeActionUpdate(Sender: TObject);
var
	Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
	Action.Enabled := Assigned(Sammlung) and (Sammlung.Count > 0);
  Action.Checked := AnzeigeModus = TAnzeigeModus(Action.Tag);
end;

procedure TSchaufenster.ShowPauseActionExecute(Sender: TObject);
begin
	Angehalten := true;
end;

procedure TSchaufenster.ShowPauseActionUpdate(Sender: TObject);
var
	Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
	Action.Enabled := Assigned(Sammlung) and (Sammlung.Count > 0) and not FAngehalten;
end;

procedure TSchaufenster.ShowResumeActionExecute(Sender: TObject);
begin
  Angehalten := false;
end;

procedure TSchaufenster.ShowResumeActionUpdate(Sender: TObject);
var
	Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
	Action.Enabled := Assigned(Sammlung) and (Sammlung.Count > 0) and FAngehalten;
end;

procedure TSchaufenster.SetAngehalten(value: boolean);
begin
	fAngehalten := value;
	if TiBildwechsel.Enabled<>not value then begin
		if value then TiBildwechsel.Enabled := false;
		if not value then begin
			if AnzeigeModus=amVersteckt then AnzeigeModus := amNormal;
			Weiterschalten;
		end;
	end;
end;

procedure TSchaufenster.SetSammlung(const Value: TBildersammlung);
begin
	FSammlung := Value;
end;

procedure TSchaufenster.ShowCloseActionExecute(Sender: TObject);
begin
	Close;
end;

procedure TSchaufenster.ShowPickColorActionExecute(Sender: TObject);
begin
	Farbaufnahme := not Farbaufnahme;
end;

procedure TSchaufenster.ShowPickColorActionUpdate(Sender: TObject);
var
	Action: TCustomAction;
begin
  Action := Sender as TCustomAction;
	Action.Enabled := Assigned(Sammlung) and (Sammlung.Count > 0);
end;

procedure TSchaufenster.SetFarbAufnahme(const Value: boolean);
begin
	fFarbAufnahme := value;
	if value then begin
		Cursor := crPipette;
		WindowProc := FarbaufnahmeWndProc;
	end else begin
		WindowProc := FOriginalWndProc;
		Cursor := crDefault;
	end;
end;

procedure TSchaufenster.FarbAufnahmeWndProc(var message: tMessage);
var
	farbe:tColor;
begin
	try
		with message do
			if (msg>=wm_KeyFirst) and (msg<=wm_KeyLast)
				or (msg>=wm_MouseFirst) and (msg<=wm_MouseLast) then begin
				if (msg=wm_LButtonDown) then begin
					farbe := Canvas.Pixels[lParamLo,lParamHi];
					if Assigned(Bild) then begin
						Bild.Hintergrundfarbe := farbe;
						Invalidate;
					end;
					try
						if Assigned(Schaubild) then
							Schaubild.Hintergrundfarbe := farbe;
						//if Assigned(Bildbearbeitung) then
						//	BildBearbeitung.SetHintergrundfarbe(farbe);
					except
						{$ifdef debugging} MessageBeep(MB_ICONERROR);{$endif}
					end;
				end;
			end;
	finally
		FOriginalWndProc(message);
	end;
end;

procedure TSchaufenster.SetDisableUserActions(const Value: boolean);
begin
	FDisableUserActions := Value;
end;

procedure TSchaufenster.WMNCHitTest(var message: tWMNCHitTest);
var
	pkt:tPoint;
	cxsf,cysf,cyc:integer;
begin
	inherited;
	if (AnzeigeModus=amRahmenlos) and (message.result=htClient) then
	with message do begin
		pkt.x := XPos;
		pkt.y := YPos;
		pkt := ScreenToClient(pkt);
		cxsf := GetSystemMetrics(sm_cxSizeFrame);
		cysf := GetSystemMetrics(sm_cySizeFrame);
		cyc := GetSystemMetrics(sm_cyCaption);
		if not FarbAufnahme then result := htCaption; {?erall verschieben}
		if pkt.y<cysf then begin {oberer rand}
			if pkt.x<cyc then result := htTopLeft
			else begin
				if pkt.x>=width-cyc then result := htTopRight
				else result := htTop;
			end;
		end else begin
			if pkt.y>=height-cysf then begin {unterer rand}
				if pkt.x<cyc then result := htBottomLeft
				else begin
					if pkt.x>=width-cyc then result := htBottomRight
					else result := htBottom;
				end;
			end else begin
				if pkt.x<cxsf then begin {linker rand}
					if pkt.y<cyc then result := htTopLeft
					else begin
						if pkt.y>=height-cyc then result := htBottomLeft
						else result := htLeft;
					end;
				end else begin
					if pkt.x>=width-cxsf then begin {rechter rand}
						if pkt.y<cyc then result := htTopRight
						else begin
							if pkt.y>=height-cyc then result := htBottomRight
							else result := htRight;
						end;
					end;
				end;
			end;
		end;
	end;
end;

procedure TSchaufenster.WMNCRButtonUp;
var
	pkt1:tPoint;
	pkt2:tSmallPoint;
begin
	if (message.HitTest=htCaption) and (fAnzeigeModus=amRahmenlos) then begin
		pkt1.x := message.XCursor;
		pkt1.y := message.YCursor;
		pkt1 := ScreenToClient(pkt1);
		pkt2.x := pkt1.x;
		pkt2.y := pkt1.y;
		message.result := Perform(wm_RButtonUp,0,longint(pkt2))
	end else inherited;
end;

procedure TSchaufenster.WMPowerBroadcast(var message: TMessage);
begin
	//case message.WParam of
		//PBT_APMBATTERYLOW:	{Battery power is low.}
		//PBT_APMOEMEVENT:	{OEM-defined event occurred.}
		//PBT_APMPOWERSTATUSCHANGE:	{Power status has changed.}
		//PBT_APMQUERYSUSPEND:	{Request for permission to suspend.}
		//PBT_APMQUERYSUSPENDFAILED:	{Suspension request denied.}
		//PBT_APMRESUMESUSPEND:	{Operation resuming after suspension.}
		//PBT_APMSUSPEND:	{System is suspending operation.}
	//end;
	message.Result := 1;
end;

procedure TSchaufenster.FormDblClick(Sender: TObject);
{$ifdef debugging}
var
	ausgabe:string;
begin
	ausgabe := Format('debugcheckpoint=%u.',[debugcheckpoint]);
	Application.MessageBox(
		pChar(ausgabe),
		'Debug-Function',mb_Ok or mb_IconInformation);
end;
{$else}
begin
	OnDblClick := nil;
end;
{$endif}

procedure TSchaufenster.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '+': if Assigned(Schaubild) then
      Schaubild.Haeufigkeit := Min(Schaubild.Haeufigkeit * 2, High(THaeufigkeit));
    '-': if Assigned(Schaubild) then
      Schaubild.Haeufigkeit := Schaubild.Haeufigkeit div 2;
    '0'..'9': if Assigned(Schaubild) then
      Schaubild.Haeufigkeit := 100 * StrToInt(Key);
    'h': ShowPauseAction.Execute;
    'f': ShowResumeAction.Execute;
    'w': ShowProceedAction.Execute;
  end;
end;

initialization
	Screen.Cursors[crPipette] := LoadCursor(hInstance,'PIPETTE');
end.

