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
 * The Original Code is bildklassen.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: bildklassen.pas 127 2008-11-21 06:03:08Z hiisi $ }

{
@abstract Display classes for slides
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2008-11-21 00:03:08 -0600 (Fr, 21 Nov 2008) $
}
unit bildklassen;

{ pendenzen
 -TMCIBild.BildZeichnen: MediaPlayer.Capabilities<>usesWindows -> standardbild
 -BildZeichnen: starke vergrösserungen vermeiden?

 test
 -TSammelordner: was passiert bei leerem ordner? - exception! - aber wo?
 -implementation von IBildbearbeitung

 +TBildObjekt
		-abstrakte anzeigemethoden mit
			formular-, canvas-, window-handle- oder mediaplayer-argument
	+TBilderrahmen
		-statisches rahmenobjekt, das sich je nach Pfad wie ein
			TStandardBild, TMCIBild, TDirectShowBild oder TOLEBild verhält
	+TStandardBild
	+TMCIBild
  +TDirectShowBild
	+TOLEBild
}

interface

uses
	Classes, Forms, ComCtrls, Graphics, SysUtils, Windows, Controls, JPEG, MPlayer,
  Math,	globals, karsreg, dscontrol;

type
	TBildobjektKlasse=class of TBildobjekt;

  { @abstract(Abstract base class for displaying slides)
    This class represents a slide that can be displayed.
    The methods to display the slides are abstract. }
	TBildObjekt=class(TPersistent)
	private
    //zeiger auf passendes objekt in der MediaTypes-liste
		FMediaType: TMediaType;
		FPfad: string;
		FBitmapModus: TBitmapModus;
		FVergroesserung: cardinal;
		FHintergrundfarbe: TColor;
		FAusgabeCanvas: TCanvas;
		FAusgabePlayer: TWinControl;
		FBildGeladen: boolean;
		FSchluessel: integer;
    FAusgabeWindow: HWnd;
		function	GetPicture: TPicture; virtual; abstract;
		procedure SetPfad(const Value: string); virtual;
		function	GetBitmapModus: tBitmapModus; virtual;
		function	GetMediaType: TMediaType; virtual;
		function	GetPfad: string; virtual;
		procedure SetBitmapModus(const Value: tBitmapModus); virtual;
		function	GetHintergrundfarbe: tColor; virtual;
		procedure SetHintergrundfarbe(const Value: tColor); virtual;
		procedure SetAusgabeCanvas(const Value: TCanvas); virtual;
		procedure SetAusgabePlayer(const Value: TWinControl); virtual;
		procedure SetSchluessel(const Value: integer); virtual;
		function	GetSchluessel: integer; virtual;
		function	GetVergroesserung: cardinal; virtual;
		procedure SetVergroesserung(const Value: cardinal); virtual;
    procedure SetAusgabeWindow(const Value: HWnd); virtual;
	public
		constructor Create; virtual;
		destructor	Destroy; override;
		procedure Assign(Source: TPersistent); override;

		{	bereitmachen zum (wiederholten) BildZeichnen (datei in laden)
      EDateiFehlt-exception möglich
      <p>
		  BildLaden/BildFreigeben-mechanismus:
      das bild wird erst bei bedarf geladen (BildZeichnen, BildGroesse,
      BildKoordinaten) und bleibt dann im speicher,
      bis die AusgabeXxxx-properties alle auf nil gesetzt werden,
      das Objekt freigegeben wird oder BildFreigeben aufgerufen wird.
      BildLaden/BildFreigeben müssen nicht zwingend von ausserhalb
      aufgerufen werden, können aber helfen, speicherplatz zu sparen.}
		procedure BildLaden; virtual;
		{ grafikspeicher freigeben }
		procedure BildFreigeben; virtual;

		{ berechnet breite und höhe des bildes anhand der maximal verfügbaren
		  zeichenfläche abhängig vom BitmapModus }
		function	BildGroesse(const zeichenflaeche:tRect):tPoint; virtual; abstract;
		{ berechnet die bildabmessungen anhand der maximal verfügbaren zeichenfläche }
		function	BildKoordinaten(const zeichenflaeche:tRect):tRect; virtual; abstract;

		{ bild anzeigen auf AusgabeCanvas oder mit AusgabePlayer -
			BildZeichnen wählt das am besten geeignete ziel aus.
			zeichenflaeche soll die gewünschte grösse des ausgabebereichs enthalten. }
		procedure BildZeichnen(const zeichenflaeche:tRect); virtual; abstract;

		property	Pfad: string read GetPfad write SetPfad;
		property	MediaType: TMediaType read GetMediaType;
		property	BitmapModus: TBitmapModus read GetBitmapModus write SetBitmapModus;
		property	Vergroesserung: cardinal read GetVergroesserung write SetVergroesserung;
		property	Hintergrundfarbe: TColor read GetHintergrundfarbe write SetHintergrundfarbe;
		property	Schluessel: integer read GetSchluessel write SetSchluessel;
		property	Picture: TPicture read GetPicture;
		property	AusgabeCanvas: TCanvas read FAusgabeCanvas write SetAusgabeCanvas;
    property  AusgabeWindow: HWnd read FAusgabeWindow write SetAusgabeWindow;
		property	AusgabePlayer: TWinControl read FAusgabePlayer write SetAusgabePlayer;
	end;

  { @abstract(Dynamic bild object)
    This class changes its behaviour according to the file type assigned to
    Pfad. @link(BildObjekt) contains the actual object. All method calls are
    directed to that object. }
	TBilderrahmen=class(TBildobjekt)
	private
		FBildobjekt:TBildobjekt;
		function	GetPicture: TPicture; override;
		procedure SetPfad(const Value: string); override;
		function	GetBildobjekt: TBildobjekt;
		function	GetBitmapModus: tBitmapModus; override;
		function	GetMediaType: TMediaType; override;
		function	GetPfad: string; override;
		procedure SetBildobjekt(const Value: TBildobjekt);
		procedure SetBitmapModus(const Value: tBitmapModus); override;
		function	GetHintergrundfarbe: tColor; override;
		procedure SetHintergrundfarbe(const Value: tColor); override;
		procedure SetSchluessel(const Value: integer); override;
		function	GetSchluessel: integer; override;
		function	GetVergroesserung: cardinal; override;
		procedure SetVergroesserung(const Value: cardinal); override;
		procedure SetAusgabeCanvas(const Value: TCanvas); override;
		procedure SetAusgabePlayer(const Value: TWinControl); override;
    procedure SetAusgabeWindow(const Value: HWnd); override;
	public
		constructor Create; override;
		destructor	Destroy; override;

		property	Bildobjekt:TBildobjekt read GetBildobjekt write SetBildobjekt;

		procedure BildLaden; override;
		procedure BildFreigeben; override;
		function	BildGroesse(const zeichenflaeche:tRect):tPoint; override;
		function	BildKoordinaten(const zeichenflaeche:tRect):tRect; override;
		procedure BildZeichnen(const zeichenflaeche:tRect); override;
	end;

  { @abstract(Slide class for graphic files) }
	TStandardBild=class(TBildobjekt)
	private
		FPicture: TPicture;
		function	GetPicture: TPicture; override;
	public
		constructor Create; override;
		destructor	Destroy; override;
		procedure BildLaden; override;
		procedure BildFreigeben; override;
		function	BildGroesse(const zeichenflaeche:tRect):tPoint; override;
		function	BildKoordinaten(const zeichenflaeche:tRect):tRect; override;
		procedure BildZeichnen(const zeichenflaeche:tRect); override;
	end;

  { @abstract(Slide class for MCI movies) }
	TMCIBild=class(TBildobjekt)
	private
		fSchonGespielt:boolean;
		fOriginalgroesse:tPoint;
		function	GetPicture: TPicture; override;
	public
		constructor Create; override;
		procedure BildLaden; override;
		procedure BildFreigeben; override;
		function	BildGroesse(const zeichenflaeche:tRect):tPoint; override;
		function	BildKoordinaten(const zeichenflaeche:tRect):tRect; override;
		{	spielt nur einmal. vor einer wiederholung muss BildFreigeben aufgerufen werden. }
		procedure BildZeichnen(const zeichenflaeche:tRect); override;
	end;

  { @abstract(Slide class for DirectX movies) }
	TDirectShowBild=class(TBildobjekt)
	private
		FSchonGespielt: boolean;
  protected
		function	GetPicture: TPicture; override;
	public
		constructor Create; override;
    destructor  Destroy; override;
		procedure BildLaden; override;
		procedure BildFreigeben; override;
		function	BildGroesse(const zeichenflaeche: TRect): TPoint; override;
		function	BildKoordinaten(const zeichenflaeche: TRect): TRect; override;
		procedure BildZeichnen(const zeichenflaeche: TRect); override;
	end;

  { @abstract(Slide class for OLE objects - not implemented)
    This might be a future extension. }
	TOLEBild=class(TBildobjekt)
	public
		constructor Create; override;
	end;

type
	EInvalidMediaType = class(EKarstenException);
	EIncompatibleOutputDevice = class(EKarstenException);

implementation

resourcestring
  SEInvalidMediaType = 'Incompatible media type';
  SEIncompatibleOutputDevice = 'Output device does not support %s files.';

{ TBildObjekt }

constructor TBildobjekt.Create;
begin
	inherited;
	fBitmapModus := cDefBitmapModus;
	fVergroesserung := cDefVergroesserung;
	fBildGeladen := false;
	fSchluessel := cDefSchluessel;
end;

procedure TBildObjekt.Assign(Source: TPersistent);
begin
	BildFreigeben;
	if Source is TBildobjekt then
		with Source as TBildobjekt do begin
			Self.Pfad := Pfad;
			Self.BitmapModus := BitmapModus;
			Self.Vergroesserung := Vergroesserung;
			Self.Hintergrundfarbe := Hintergrundfarbe;
			Self.Schluessel := Schluessel;
		end
	else inherited;
end;

procedure TBildObjekt.BildFreigeben;
begin
	fBildGeladen := false;
end;

procedure TBildObjekt.BildLaden;
begin
	if not FileExists(Pfad)
		then raise EDateiFehlt.CreateFmt(seDateiFehlt,[Pfad]);
end;

function TBildObjekt.GetBitmapModus: tBitmapModus;
begin
	result := fBitmapModus;
end;

function TBildObjekt.GetVergroesserung: cardinal;
begin
	result := fVergroesserung;
end;

function TBildObjekt.GetHintergrundfarbe: tColor;
begin
	result := fHintergrundfarbe;
end;

function TBildObjekt.GetMediaType: TMediaType;
begin
	result := FMediaType;
end;

function TBildObjekt.GetPfad: string;
begin
	result := fPfad;
end;

procedure TBildObjekt.SetAusgabeCanvas(const Value: TCanvas);
begin
	if FAusgabeCanvas<>Value then begin
		FAusgabeCanvas  :=  Value;
		if
      not Assigned(FAusgabeCanvas) and not Assigned(FAusgabePlayer) and
      (FAusgabeWindow = 0)
		then
      BildFreigeben;
	end;
end;

procedure TBildObjekt.SetAusgabeWindow(const Value: HWnd);
begin
  if FAusgabeWindow <> Value then begin
    FAusgabeWindow := Value;
		if
      not Assigned(FAusgabeCanvas) and not Assigned(FAusgabePlayer) and
      (FAusgabeWindow = 0)
		then
      BildFreigeben;
  end;
end;

procedure TBildObjekt.SetAusgabePlayer(const Value: TWinControl);
begin
	if FAusgabePlayer<>Value then begin
		FAusgabePlayer  :=  Value;
		if
      not Assigned(FAusgabeCanvas) and not Assigned(FAusgabePlayer) and
      (FAusgabeWindow = 0)
		then
      BildFreigeben;
	end;
end;

procedure TBildObjekt.SetVergroesserung(const Value: cardinal);
begin
	fVergroesserung := value;
end;

procedure TBildObjekt.SetBitmapModus(const Value: tBitmapModus);
begin
	fBitmapModus := value;
end;

procedure TBildObjekt.SetHintergrundfarbe(const Value: tColor);
begin
	fHintergrundfarbe := value;
end;

procedure TBildObjekt.SetSchluessel(const Value: integer);
begin
	fSchluessel  :=  Value;
end;

function TBildObjekt.GetSchluessel: integer;
begin
	result := fSchluessel;
end;

procedure TBildObjekt.SetPfad(const Value: string);
var
	MT:TMediaType;
begin
	if CompareText(fPfad,value)<>0 then begin
		BildFreigeben;
		MT := MediaTypes.GetMediaType(value);
		if
      ((MT.Grafikformat = gfMCI) xor (Self is TMCIBild)) or
			((MT.Grafikformat = gfOLE) xor (Self is TOLEBild))
    then raise
      EInvalidMediaType.Create(SEInvalidMediaType);
		fPfad := value;
		FMediaType := MT;
	end;
end;

destructor TBildObjekt.Destroy;
begin
	BildFreigeben;
	inherited;
end;

{ TStandardBild }

procedure TStandardBild.BildFreigeben;
begin
	if Assigned(FPicture) then FPicture.Graphic := nil;
	fBildGeladen := false;
end;

procedure TStandardBild.BildLaden;
begin
	if not fBildGeladen then begin
		inherited; // inherited: check if file exists
		Picture.LoadFromFile(Pfad);
		fBildGeladen := true;
	end;
end;

function TStandardBild.BildGroesse(const zeichenflaeche: tRect): tPoint;
var
	koordinaten:tRect;
begin
	koordinaten := BildKoordinaten(zeichenflaeche);
	result.x := abs(koordinaten.Right-koordinaten.left);
	result.y := abs(koordinaten.bottom-koordinaten.Top);
end;

function TStandardBild.BildKoordinaten;
// zeichenfläche = abmessungen des fensters/klientbereichs/bildschirms
// result = ausgabe-bildposition in fensterkoordinaten
var
	originalHoehe, originalBreite: integer;
	xVerhaeltnis, yVerhaeltnis: single;
begin
	if not Assigned(Picture.Graphic) then BildLaden;
	if Picture.Graphic is TMetafile then
    with Picture.Graphic as TMetafile do begin
  		originalHoehe := Height;
  		originalBreite := Width;
  	end
  else begin
		originalHoehe := Picture.Graphic.Height;
		originalBreite := Picture.Graphic.Width;
	end;
  if BitmapModus=bmNormal then begin
 		result.left := (zeichenflaeche.right + zeichenflaeche.left - originalBreite) div 2;
 		result.top := (zeichenflaeche.bottom + zeichenflaeche.top - originalHoehe) div 2;
 		result.Right := result.Left + originalBreite;
 		result.Bottom := result.Top + originalHoehe;
	end else begin
		xVerhaeltnis := (zeichenflaeche.right - zeichenflaeche.left + 1) / originalBreite;
		yVerhaeltnis := (zeichenflaeche.bottom - zeichenflaeche.Top + 1) / originalHoehe;
    case BitmapModus of
      bmIsoSpeziell: begin
  			xVerhaeltnis := Vergroesserung / 100;
  			yVerhaeltnis := xVerhaeltnis;
      end;
  		bmIsoStrecken: begin
  			if xVerhaeltnis >= yVerhaeltnis
    			then xVerhaeltnis := yVerhaeltnis
          else yVerhaeltnis := xVerhaeltnis;
  		end;
      bmIntegerStrecken: begin
        if xVerhaeltnis >= 1
          then xVerhaeltnis := Floor(xVerhaeltnis)
          else xVerhaeltnis := 1 / Ceil(1 / xVerhaeltnis);
        if yVerhaeltnis >= 1
          then yVerhaeltnis := Floor(yVerhaeltnis)
          else yVerhaeltnis := 1 / Ceil(1 / yVerhaeltnis);
  			if xVerhaeltnis >= yVerhaeltnis
    			then xVerhaeltnis := yVerhaeltnis
          else yVerhaeltnis := xVerhaeltnis;
      end;
		end;
		result.Left := (zeichenflaeche.Left + zeichenflaeche.Right -
      Round(originalBreite * xVerhaeltnis) ) div 2;
		result.Right := result.Left + Round(originalBreite * xVerhaeltnis);
		result.Top := (zeichenflaeche.top + zeichenflaeche.bottom -
      Round(originalHoehe * yVerhaeltnis) ) div 2;
		result.Bottom := result.Top + Round(originalHoehe * yVerhaeltnis);
	end;
end;

procedure TStandardBild.BildZeichnen;
var
	DestRect: TRect;
  scale: integer;
  JPEGImage: TJPEGImage;
begin
	if Assigned(AusgabeCanvas) then begin
		DestRect := BildKoordinaten(zeichenflaeche);
    AusgabeCanvas.Lock;
    try
      if BitmapModus = bmNormal then begin
        AusgabeCanvas.Draw(DestRect.left, DestRect.top, Picture.Graphic);
      end else begin
        if Picture.Graphic is TJPEGImage then begin
          JPEGImage := TJPEGImage(Picture.Graphic);
          scale := Min(Picture.Width div (DestRect.Right - DestRect.Left),
            Picture.Height div (DestRect.Bottom - DestRect.Top));
          if scale >= 8 then
            JPEGImage.Scale := jsEighth
          else if scale >= 4 then
            JPEGImage.Scale := jsQuarter
          else if scale >= 2 then
            JPEGImage.Scale := jsHalf
          else
            JPEGImage.Scale := jsFullSize;
        end;
        AusgabeCanvas.StretchDraw(DestRect, Picture.Graphic);
      end;
    finally
      AusgabeCanvas.Unlock;
    end;
	end else
		raise EIncompatibleOutputDevice.CreateFmt(SEIncompatibleOutputDevice,
			[ExtractFileExt(Pfad)]);
end;

constructor TStandardBild.Create;
begin
	inherited;
	FPicture := nil;
end;

destructor TStandardBild.Destroy;
begin
	FPicture.Free;
	FPicture := nil;
	inherited;
end;

function TStandardBild.GetPicture: TPicture;
begin
	if not Assigned(FPicture) then FPicture := TPicture.Create;
	Result := FPicture;
end;

{ TMCIBild }

procedure TMCIBild.BildLaden;
begin
	if not fBildGeladen then
    with AusgabePlayer as TMediaPlayer do begin
  		inherited; // FileExists-abfrage
  		FileName := Pfad;
  		Open;
  		fBildGeladen := Error=0;
  		fOriginalgroesse.x := DisplayRect.Right-DisplayRect.Left;
  		fOriginalgroesse.y := DisplayRect.Bottom-DisplayRect.Top;
  	end;
end;

procedure TMCIBild.BildFreigeben;
begin
	if fBildGeladen then begin
		fBildGeladen := false;
		(AusgabePlayer as TMediaPlayer).Close;
	end;
	fSchonGespielt := false;
end;

function TMCIBild.BildGroesse(const zeichenflaeche: TRect): TPoint;
var
	koordinaten: TRect;
begin
	koordinaten := BildKoordinaten(zeichenflaeche);
	result.x := abs(koordinaten.Right - koordinaten.Left);
	result.y := abs(koordinaten.Bottom - koordinaten.Top);
end;

function TMCIBild.BildKoordinaten(const zeichenflaeche: tRect): tRect;
// zeichenfläche = abmessungen des fensters/klientbereichs/bildschirms
// result = ausgabe-bildposition in fensterkoordinaten
var
	xVerhaeltnis, yVerhaeltnis: single;
begin
	BildLaden;
	if BitmapModus=bmNormal then begin
		result.left := (zeichenflaeche.right + zeichenflaeche.left - FOriginalGroesse.x) div 2;
		result.top := (zeichenflaeche.bottom + zeichenflaeche.top - FOriginalGroesse.y) div 2;
		result.Right := FOriginalGroesse.x;
		result.Bottom := FOriginalGroesse.y;
	end else begin
		xVerhaeltnis := (zeichenflaeche.right - zeichenflaeche.left + 1) / FOriginalGroesse.x;
		yVerhaeltnis := (zeichenflaeche.bottom - zeichenflaeche.Top + 1) / FOriginalGroesse.y;
    case BitmapModus of
      bmIsoSpeziell: begin
  			xVerhaeltnis := Vergroesserung / 100;
  			yVerhaeltnis := xVerhaeltnis;
      end;
  		bmIsoStrecken: begin
  			if xVerhaeltnis >= yVerhaeltnis
    			then xVerhaeltnis := yVerhaeltnis
          else yVerhaeltnis := xVerhaeltnis;
  		end;
      bmIntegerStrecken: begin
        if xVerhaeltnis >= 1
          then xVerhaeltnis := Floor(xVerhaeltnis)
          else xVerhaeltnis := 1 / Ceil(1 / xVerhaeltnis);
        if yVerhaeltnis >= 1
          then yVerhaeltnis := Floor(yVerhaeltnis)
          else yVerhaeltnis := 1 / Ceil(1 / yVerhaeltnis);
  			if xVerhaeltnis >= yVerhaeltnis
    			then xVerhaeltnis := yVerhaeltnis
          else yVerhaeltnis := xVerhaeltnis;
      end;
		end;
		result.Left := (zeichenflaeche.Left + zeichenflaeche.Right -
      Round(FOriginalGroesse.x * xVerhaeltnis) ) div 2;
		result.Top := (zeichenflaeche.Top + zeichenflaeche.Bottom -
      Round(FOriginalGroesse.y * yVerhaeltnis) ) div 2;
		result.Right := Round(fOriginalGroesse.x * xVerhaeltnis);
		result.Bottom := Round(fOriginalGroesse.y * yVerhaeltnis);
	end;
end;

procedure TMCIBild.BildZeichnen(const zeichenflaeche: tRect);
begin
	if Assigned(AusgabePlayer) then begin
		if not FSchonGespielt then
      with AusgabePlayer as TMediaPlayer do begin
  			BildLaden;
  			DisplayRect := BildKoordinaten(zeichenflaeche);
  			Wait := false;
  			Notify := true;
  			Play;
  			FSchonGespielt := Error=0;
  		end;
	end else begin
		raise EIncompatibleOutputDevice.CreateFmt(SEIncompatibleOutputDevice,
			[ExtractFileExt(Pfad)]);
	end;
end;

constructor TMCIBild.Create;
begin
	inherited;
end;

function TMCIBild.GetPicture: TPicture;
begin
	Result := nil;
end;

{ TDirectShowBild }

constructor TDirectShowBild.Create;
begin
  inherited;
end;

destructor TDirectShowBild.Destroy;
begin
  inherited;
end;

procedure TDirectShowBild.BildLaden;
begin
  if not FBildGeladen and Assigned(AusgabePlayer) then
    with AusgabePlayer as TDirectShowControl do begin
  		inherited; // FileExists-abfrage
      LoadFile(Pfad);
      FBildGeladen := true;
      FSchonGespielt := false;
    end;
end;

procedure TDirectShowBild.BildFreigeben;
begin
  if FBildGeladen and Assigned(AusgabePlayer) then
    with AusgabePlayer as TDirectShowControl do begin
      FBildGeladen := false;
      FSchonGespielt := false;
      ReleaseMedia;
    end;
  inherited;
end;

function TDirectShowBild.BildGroesse(const zeichenflaeche: TRect): TPoint;
var
	koordinaten: TRect;
begin
	koordinaten := BildKoordinaten(zeichenflaeche);
	result.x := abs(koordinaten.Right - koordinaten.Left);
	result.y := abs(koordinaten.Bottom - koordinaten.Top);
end;

function TDirectShowBild.BildKoordinaten(const zeichenflaeche: TRect): TRect;
// zeichenfläche = abmessungen des fensters/klientbereichs/bildschirms
// result = ausgabe-bildposition in fensterkoordinaten
var
  originalGroesse: TPoint;
	xVerhaeltnis, yVerhaeltnis: single;
begin
	BildLaden;
  originalGroesse := (AusgabePlayer as TDirectShowControl).GetVideoSize;
	if BitmapModus=bmNormal then begin
		result.left := (zeichenflaeche.right + zeichenflaeche.left - originalGroesse.x) div 2;
		result.top := (zeichenflaeche.bottom + zeichenflaeche.top - originalGroesse.y) div 2;
		result.Right := originalGroesse.x;
		result.Bottom := originalGroesse.y;
	end else begin
		xVerhaeltnis := (zeichenflaeche.right - zeichenflaeche.left + 1) / originalGroesse.x;
		yVerhaeltnis := (zeichenflaeche.bottom - zeichenflaeche.Top + 1) / originalGroesse.y;
    case BitmapModus of
      bmIsoSpeziell: begin
  			xVerhaeltnis := Vergroesserung / 100;
  			yVerhaeltnis := xVerhaeltnis;
      end;
  		bmIsoStrecken: begin
  			if xVerhaeltnis >= yVerhaeltnis
    			then xVerhaeltnis := yVerhaeltnis
          else yVerhaeltnis := xVerhaeltnis;
  		end;
      bmIntegerStrecken: begin
        if xVerhaeltnis >= 1
          then xVerhaeltnis := Floor(xVerhaeltnis)
          else xVerhaeltnis := 1 / Ceil(1 / xVerhaeltnis);
        if yVerhaeltnis >= 1
          then yVerhaeltnis := Floor(yVerhaeltnis)
          else yVerhaeltnis := 1 / Ceil(1 / yVerhaeltnis);
  			if xVerhaeltnis >= yVerhaeltnis
    			then xVerhaeltnis := yVerhaeltnis
          else yVerhaeltnis := xVerhaeltnis;
      end;
		end;
		result.Left := (zeichenflaeche.Left + zeichenflaeche.Right -
      Round(originalGroesse.x * xVerhaeltnis) ) div 2;
		result.Top := (zeichenflaeche.Top + zeichenflaeche.Bottom -
      Round(originalGroesse.y * yVerhaeltnis) ) div 2;
		result.Right := Round(originalGroesse.x * xVerhaeltnis);
		result.Bottom := Round(originalGroesse.y * yVerhaeltnis);
	end;
end;

procedure TDirectShowBild.BildZeichnen(const zeichenflaeche: TRect);
begin
	if Assigned(AusgabePlayer) and (AusgabeWindow <> 0) and not FSchonGespielt then
    with AusgabePlayer as TDirectShowControl do begin
 			BildLaden;
      DisplayWindow := AusgabeWindow;
      DisplayRect := BildKoordinaten(zeichenflaeche);
      Play;
 			FSchonGespielt := true;
 		end;
end;

function TDirectShowBild.GetPicture: TPicture;
begin
  result := nil;
end;

{ TBilderrahmen }

procedure TBilderrahmen.BildFreigeben;
begin
	inherited;
	if Assigned(Bildobjekt) then
		Bildobjekt.BildFreigeben;
end;

function TBilderrahmen.BildGroesse(const zeichenflaeche: tRect): tPoint;
begin
	result := Bildobjekt.BildGroesse(zeichenflaeche)
end;

function TBilderrahmen.BildKoordinaten(const zeichenflaeche: tRect): tRect;
begin
	result := Bildobjekt.BildKoordinaten(zeichenflaeche)
end;

procedure TBilderrahmen.BildLaden;
begin
	if Assigned(Bildobjekt) then begin
		Bildobjekt.BildLaden;
		fBildGeladen := true;
	end;
end;

procedure TBilderrahmen.BildZeichnen;
begin
	if Assigned(Bildobjekt) then
		Bildobjekt.BildZeichnen(zeichenflaeche);
end;

constructor TBilderrahmen.Create;
begin
	inherited;
	FBildobjekt := nil;
end;

destructor TBilderrahmen.Destroy;
begin
	FBildobjekt.Free;
	FBildobjekt := nil;
	inherited;
end;

function TBilderrahmen.GetBildobjekt: TBildobjekt;
begin
	Result := FBildobjekt;
end;

function TBilderrahmen.GetBitmapModus: tBitmapModus;
begin
	if Assigned(Bildobjekt) then result := Bildobjekt.BitmapModus
	else result := cDefBitmapModus;
end;

function TBilderrahmen.GetVergroesserung: cardinal;
begin
	if Assigned(Bildobjekt) then result := Bildobjekt.Vergroesserung
	else result := cDefVergroesserung;
end;

function TBilderrahmen.GetHintergrundfarbe: tColor;
begin
	if Assigned(Bildobjekt) then result := Bildobjekt.Hintergrundfarbe
	else result := cDefHintergrundfarbe;
end;

function TBilderrahmen.GetSchluessel: integer;
begin
	if Assigned(Bildobjekt) then result := Bildobjekt.Schluessel
	else result := cDefSchluessel;
end;

function TBilderrahmen.GetMediaType: TMediaType;
begin
	if Assigned(Bildobjekt) then Result := Bildobjekt.MediaType
	else Result := nil;
end;

function TBilderrahmen.GetPfad: string;
begin
	if Assigned(Bildobjekt) then result := Bildobjekt.Pfad
	else result := '';
end;

function TBilderrahmen.GetPicture: TPicture;
begin
	if Assigned(Bildobjekt) then Result := Bildobjekt.Picture
	else Result := nil;
end;

procedure TBilderrahmen.SetBitmapModus(const Value: tBitmapModus);
begin
	inherited;
	if Assigned(Bildobjekt) then Bildobjekt.BitmapModus := value;
end;

procedure TBilderrahmen.SetVergroesserung(const Value: cardinal);
begin
	inherited;
	if Assigned(Bildobjekt) then Bildobjekt.Vergroesserung := value;
end;

procedure TBilderrahmen.SetHintergrundfarbe(const Value: tColor);
begin
	inherited;
	if Assigned(Bildobjekt) then Bildobjekt.Hintergrundfarbe := value;
end;

procedure TBilderrahmen.SetSchluessel(const Value: integer);
begin
	inherited;
	if Assigned(Bildobjekt) then Bildobjekt.Schluessel := value;
end;

procedure TBilderrahmen.SetAusgabeCanvas(const Value: TCanvas);
begin
	inherited;
	if Assigned(Bildobjekt)
		then Bildobjekt.AusgabeCanvas := Value;
end;

procedure TBilderrahmen.SetAusgabeWindow(const Value: HWnd);
begin
	inherited;
	if Assigned(Bildobjekt)
		then Bildobjekt.AusgabeWindow := Value;
end;

procedure TBilderrahmen.SetAusgabePlayer(const Value: TWinControl);
begin
	inherited;
	if Assigned(Bildobjekt)
		then Bildobjekt.AusgabePlayer := Value;
end;

procedure TBilderrahmen.SetBildobjekt(const Value: TBildobjekt);
var
	Klasse:TBildobjektKlasse;
begin
	FBildobjekt.Free;
	FBildobjekt := nil;
	if Assigned(Value) then begin
		Klasse := TBildobjektKlasse(Value.ClassType);
		FBildobjekt := Klasse.Create;
		try
			FBildobjekt.Assign(Value);
		except
			FBildobjekt.Free;
			FBildobjekt := nil;
		end;
	end;
end;

procedure TBilderrahmen.SetPfad(const Value: string);
var
	bNeu:boolean;
begin
	if Assigned(FBildobjekt) then with FBildobjekt do begin
		Self.fBitmapModus := BitmapModus;
		Self.fVergroesserung := Vergroesserung;
		Self.fHintergrundfarbe := Hintergrundfarbe;
		bNeu := CompareText(Pfad,value)<>0;
	end else begin
		bNeu := true;
	end;
	if bNeu then begin
		FBildobjekt.Free;
		FBildobjekt := nil;
		if FileExists(value) then begin
    	FPfad := value;
			case MediaTypes.GetGrafikformat(value) of
				gfUnbekannt: ;
				gfMCI: FBildobjekt := TMCIBild.Create;
        gfDirectShow: FBildObjekt := TDirectShowBild.Create;
				gfOLE: ;
				else FBildobjekt := TStandardBild.Create;
			end;
			try
				with FBildobjekt do begin
					Pfad := value;
					BitmapModus := Self.fBitmapModus;
					Vergroesserung := Self.fVergroesserung;
					Hintergrundfarbe := Self.fHintergrundfarbe;
				end;
			except
				FBildobjekt.Free;
				FBildobjekt := nil;
			end;
		end;
	end;
end;

{ TOLEBild }

constructor TOLEBild.Create;
begin
	inherited;
end;

end.
