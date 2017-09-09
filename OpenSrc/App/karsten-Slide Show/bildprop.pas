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
 * The Original Code is bildprop.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: bildprop.pas 117 2008-02-11 02:21:22Z hiisi $ }

{
@abstract Slide properties dialog
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2008-02-10 20:21:22 -0600 (So, 10 Feb 2008) $
}
unit bildprop;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Controls,
	StdCtrls, ExtCtrls, Forms, ComCtrls, Buttons, sammelklassen, Dialogs, ExtDlgs,
	globals, Mask, JvExMask, JvSpin;

type
  { @abstract(Slide properties dialog) }
	TBildEigenschaftenDlg = class(TForm)
		EFName: TEdit;
		GBDateipfad: TGroupBox;
		BDateipfad: TBitBtn;
		GBWartezeit: TGroupBox;
		TBWartezeit: TTrackBar;
		UDWartezeitMin: TUpDown;
		GBHaeufigkeit: TGroupBox;
		TBHaeufigkeit: TTrackBar;
		UDHaeufigkeit: TUpDown;
		BOk: TBitBtn;
		BAbbrechen: TBitBtn;
		LName: TLabel;
		EFWartezeitMin: TEdit;
		EFWartezeitSek: TEdit;
		EFHaeufigkeit: TEdit;
		UDWartezeitSek: TUpDown;
		LWartezeitMin: TLabel;
		LWartezeitSek: TLabel;
		OpenPictureDialog: TOpenPictureDialog;
		EFDateipfad: TEdit;
		LTBMinWartezeit: TLabel;
    LTBMaxWartezeit: TLabel;
		LTBMinHaeufigkeit: TLabel;
		LTBMaxHaeufigkeit: TLabel;
		GBHintergrundfarbe: TGroupBox;
    CBHintergrundfarbe: TColorBox;
		BHilfe: TBitBtn;
		GBVergroesserung: TGroupBox;
		RBBMNormal: TRadioButton;
		RBBMIsoStrecken: TRadioButton;
		RBBMAnisoStrecken: TRadioButton;
		RBBMIsoSpeziell: TRadioButton;
		CBVergroesserung: TComboBox;
    RBBMIntegerStrecken: TRadioButton;
    GBSequenceNumber: TGroupBox;
    EFSequenceNumber: TJvSpinEdit;
		procedure BDateipfadClick(Sender: TObject);
		procedure TBWartezeitChange(Sender: TObject);
		procedure TBHaeufigkeitChange(Sender: TObject);
		procedure EFHaeufigkeitChange(Sender: TObject);
		procedure EFWartezeitChange(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormDestroy(Sender: TObject);
		procedure EFNameChange(Sender: TObject);
		procedure EFDateipfadChange(Sender: TObject);
		procedure CBHintergrundfarbeChange(Sender: TObject);
		procedure RBBMClick(Sender: TObject);
    procedure CBVergroesserungChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
	private
		FBitmapModus: TBitmapModus;
		FObjekt: TSammelobjekt;
		FHaeufigkeitUpdating: boolean;
		FWartezeitUpdating: boolean;
		FBildAuswahl: boolean;
		FOrdnerAuswahl: boolean;
		FAenderungen: TSammelobjektProperties;
		FMultiObjekt: boolean;
		procedure SetHaeufigkeit(Value: THaeufigkeit);
		procedure SetObjName(const Value: string);
		procedure SetWartezeit(Value: TWartezeit);
		function	GetWartezeit: TWartezeit;
		function  GetHaeufigkeit: THaeufigkeit;
		function  GetObjName: string;
		function  GetDateipfad: string;
		procedure SetDateipfad(const Value: string);
		procedure SetSammelobjekt(const Value: TSammelobjekt);
		function  GetSammelobjekt: TSammelobjekt;
		procedure SetOrdnerAuswahl(const Value: boolean);
		function	GetOrdnerAuswahl: boolean;
		function  GetBildAuswahl: boolean;
		procedure SetBildAuswahl(const Value: boolean);
		procedure UpdateDlgTitel;
		procedure SetBitmapModus(const Value: TBitmapModus);
		procedure SetMultiObjekt(const Value: TSammelobjekt);
		function  GetMultiobjekt: TSammelobjekt;
		procedure SetHintergrundfarbe(const Value: TColor);
		function  GetHintergrundfarbe: TColor;
		procedure AenderungMelden(aenderung:TSammelobjektProperty);
		procedure UpdateHelpContexts;
    function  GetVergroesserung: cardinal;
    procedure SetVergroesserung(const Value: cardinal);
    function GetSequenceNumber: integer;
    procedure SetSequenceNumber(const Value: integer);
	public
		{	der dialog als virtuelles TSammelobjekt }
		property Sammelobjekt: TSammelobjekt read GetSammelobjekt write SetSammelobjekt;
		{	write: true fordert ein TBildOrdner als Sammelobjekt <br>
			read: true, falls Sammelobjekt ein TBildOrdner ist }
		property OrdnerAuswahl: boolean read GetOrdnerAuswahl write SetOrdnerAuswahl;
		{	write: true fordert ein TBild als Sammelobjekt <br>
			read: true, falls Sammelobjekt ein TBild ist }
		property BildAuswahl: boolean read GetBildAuswahl write SetBildAuswahl;
		{ der dialog als virtuelles TSammelobjekt für Multi-Objekt-Bearbeitung }
		property MultiObjekt: TSammelobjekt read GetMultiobjekt write SetMultiObjekt;
		{	gibt die veränderten TSammelobjekt-eigenschaften an }
		property Aenderungen: TSammelobjektProperties read fAenderungen;

		property ObjName: string read GetObjName write SetObjName;
		property Dateipfad: string read GetDateipfad write SetDateipfad;
		property BitmapModus: TBitmapModus read fBitmapModus write SetBitmapModus;
		property Vergroesserung: cardinal read GetVergroesserung write SetVergroesserung;
		property Wartezeit: TWartezeit read GetWartezeit write SetWartezeit;
		property Haeufigkeit: THaeufigkeit read GetHaeufigkeit write SetHaeufigkeit;
    property SequenceNumber: integer read GetSequenceNumber write SetSequenceNumber;
		property Hintergrundfarbe: TColor read GetHintergrundfarbe write SetHintergrundfarbe;
	end;

var
	BildEigenschaftenDlg: TBildEigenschaftenDlg;

resourcestring
	SBilderAus = 'Images from ';

implementation
uses
  Math, gnugettext, KarsReg;

{$R *.DFM}

resourcestring
	SOrdnerDialogTitel = 'Select any image from the desired folder';
	SBildDialogTitel = 'Select image file';
	SFehlerKeinName = 'Please enter a title.';
	SFehlerKeinPfad = 'The selected file path is invalid.';
	SFehlerVergroesserung = 'The selected zoom mode or zoom factor is invalid.';
	SBildpropDefTitel = 'Slide Properties';
	SBildpropBildTitel = 'Slide Properties';
	SBildpropOrdnerTitel = 'Folder Properties';
	SBildpropDefDateipfad = 'File &Path';
	SBildpropBildDateipfad = '&Path to Image File';
	SBildpropOrdnerDateipfad = '&Path of Image Folder';
	SMehrfachauswahl = '(Multiple Selection)';
	SUnveraendert = ' (unchanged)';

procedure TBildEigenschaftenDlg.BDateipfadClick(Sender: TObject);
var
	neuDir,altDir:string;
begin
	if not fMultiObjekt then begin
		with OpenPictureDialog do begin
			altDir := InitialDir;
			if fOrdnerAuswahl then begin
				Title := sOrdnerDialogTitel;
				neuDir := EFDateipfad.Text;
				FileName := '';
				Options := [ofHideReadOnly,ofPathMustExist,ofEnableSizing];
			end else begin
				Title := sBildDialogTitel;
				neuDir := ExtractFileDir(EFDateipfad.Text);
				FileName := ExtractFileName(EFDateipfad.Text);
				Options := [ofHideReadOnly,ofPathMustExist,ofFileMustExist,ofEnableSizing];
			end;
			if (Length(neuDir)=0) or not DirectoryExists(neuDir) then neuDir := altDir;
			InitialDir := neuDir;
			try
				if Execute then begin
					if fOrdnerAuswahl then Dateipfad := ExtractFilePath(FileName)
						else Dateipfad := FileName;
					InitialDir := ExtractFileDir(FileName);
				end else begin
					InitialDir := altDir;
				end;
			except
				on EInvalidGraphic do ;
			end;
		end;
		EFDateipfad.SetFocus;
	end;
end;

procedure TBildEigenschaftenDlg.SetObjName;
begin
	EFName.Text := Value;
	AenderungMelden(soaName);
end;

procedure TBildEigenschaftenDlg.SetDateipfad(const Value: string);
begin
	EFDateipfad.Text := value;
	AenderungMelden(soaPfad);
	if Length(ObjName)=0 then
		if fOrdnerAuswahl then ObjName := sBilderAus+value
		else ObjName := ExtractFileName(value);
end;

function TBildEigenschaftenDlg.GetObjName: string;
begin
	result := EFName.Text;
end;

function TBildEigenschaftenDlg.GetDateipfad: string;
begin
	result := EFDateipfad.Text;
end;

procedure TBildEigenschaftenDlg.EFNameChange(Sender: TObject);
begin
	AenderungMelden(soaName);
end;

procedure TBildEigenschaftenDlg.EFDateipfadChange(Sender: TObject);
begin
	AenderungMelden(soaPfad);
	UpdateHelpContexts;
end;

procedure TBildEigenschaftenDlg.SetBitmapModus(const Value: tBitmapModus);
var
	idx:integer;
begin
	with GBVergroesserung do
		for idx := 0 to ControlCount-1 do
			if Controls[idx].Tag=Ord(value) then begin
				(Controls[idx] as TRadioButton).Checked := true;
				Break;
			end;
	fBitmapModus := value;
	AenderungMelden(soaBitmapModus);
end;

procedure TBildEigenschaftenDlg.SetSequenceNumber(const Value: integer);
begin
  EFSequenceNumber.Value := Value;
  AenderungMelden(soaSequenceNumber);
end;

function TBildEigenschaftenDlg.GetSequenceNumber: integer;
begin
  result := Trunc(EFSequenceNumber.Value);
end;

procedure TBildEigenschaftenDlg.SetHaeufigkeit;
begin
	UDHaeufigkeit.Position := value;
	AenderungMelden(soaHaeufigkeit);
end;

function TBildEigenschaftenDlg.GetHaeufigkeit: tHaeufigkeit;
begin
	result := UDHaeufigkeit.Position;
end;

procedure TBildEigenschaftenDlg.TBHaeufigkeitChange(Sender: TObject);
var
	exponent,wert:extended;
begin
	if (not fHaeufigkeitUpdating) and (ActiveControl=TBHaeufigkeit) then begin
		fHaeufigkeitUpdating := true;
		exponent := TBHaeufigkeit.Position/100;
		Assert((exponent>=0) and (exponent<=9),'Unerlaubter Wert: TBHaeufigkeit.Position');
		wert := Power(10,exponent);
		if wert>High(tHaeufigkeit) then wert := High(tHaeufigkeit);
		if wert<Low(tHaeufigkeit) then wert := Low(tHaeufigkeit);
		Haeufigkeit := round(wert);
		fHaeufigkeitUpdating := false;
	end;
end;

procedure TBildEigenschaftenDlg.EFHaeufigkeitChange(Sender: TObject);
var
	exponent:extended;
begin
	if not fHaeufigkeitUpdating then begin
		fHaeufigkeitUpdating := true;
		if UDHaeufigkeit.Position>0 then begin
			exponent := Log10(UDHaeufigkeit.Position);
			TBHaeufigkeit.Position := round(exponent*100);
		end else TBHaeufigkeit.Position := TBHaeufigkeit.Min;
		AenderungMelden(soaHaeufigkeit);
		fHaeufigkeitUpdating := false;
	end;
end;

procedure TBildEigenschaftenDlg.TBWartezeitChange(Sender: TObject);
var
	exponent,zeitwert:extended;
begin
	if (not fWartezeitUpdating) and (ActiveControl=TBWartezeit) then begin
		fWartezeitUpdating := true;
		exponent := TBWartezeit.Position/100;
		Assert((exponent>=0) and (exponent<=9),'Unerlaubter Wert: TBWartezeit.Position');
		zeitwert := Power(10,exponent);
		if zeitwert>High(tWartezeit) then zeitwert := High(tWartezeit);
		Wartezeit := round(zeitwert);
		fWartezeitUpdating := false;
	end;
end;

procedure TBildEigenschaftenDlg.EFWartezeitChange(Sender: TObject);
var
	exponent:extended;
begin
	if not fWartezeitUpdating then begin
		fWartezeitUpdating := true;
		if (Sender=EFWartezeitSek) then begin
			if (UDWartezeitSek.Position>=60) then begin
				UDWartezeitSek.Position := UDWartezeitSek.Position-60;
				UDWartezeitMin.Position := UDWartezeitMin.Position+1;
			end;
			if UDWartezeitSek.Position<0 then begin
				UDWartezeitSek.Position := UDWartezeitSek.Position+60;
				UDWartezeitMin.Position := UDWartezeitMin.Position-1;
			end;
		end;
		if Wartezeit>0 then begin
			exponent := Log10(Wartezeit); //Wartezeit-property liest editfelder aus
			TBWartezeit.Position := round(exponent*100);
		end else TBWartezeit.Position := TBWartezeit.Min;
		AenderungMelden(soaWartezeit);
		fWartezeitUpdating := false;
	end;
end;

function TBildEigenschaftenDlg.GetWartezeit: tWartezeit;
var
	wert:cardinal;
begin
	wert := UDWartezeitMin.Position*60+UDWartezeitSek.Position;
	if wert<Low(tWartezeit) then wert := Low(tWartezeit);
	if wert>High(tWartezeit) then wert := High(tWartezeit);
	result := wert;
end;

procedure TBildEigenschaftenDlg.SetWartezeit;
begin
	UDWartezeitMin.Position := value div 60;
	UDWartezeitSek.Position := value mod 60;
	AenderungMelden(soaWartezeit);
end;

procedure TBildEigenschaftenDlg.FormCloseQuery(Sender: TObject;
	var CanClose: Boolean);
begin
	if (ModalResult=mrOk) then begin
		if (BitmapModus=bmIsoSpeziell) and (Vergroesserung<1) then begin
			MessageDlg(sFehlerVergroesserung,mtWarning,[mbOk],0);
			canClose := false;
		end;
		if not fMultiObjekt then begin
			if Length(ObjName)=0 then begin
				MessageDlg(sFehlerKeinName,mtWarning,[mbOk],0);
				CanClose := false;
			end else begin
				if (fOrdnerAuswahl or not FileExists(Dateipfad))
				and (fBildAuswahl or not DirectoryExists(Dateipfad)) then begin
					MessageDlg(sFehlerKeinPfad,mtWarning,[mbOk],0);
					CanClose := false;
				end;
			end;
		end;
	end;
end;

procedure TBildEigenschaftenDlg.UpdateDlgTitel;
begin
	if not (fOrdnerAuswahl or fBildAuswahl) then begin
		Caption := sBildpropDefTitel;
		GBDateipfad.Caption := sBildpropDefDateipfad;
	end else
		if fOrdnerAuswahl then begin
			Caption := sBildpropOrdnerTitel;
			GBDateipfad.Caption := sBildpropOrdnerDateipfad;
		end else begin
			Caption := sBildpropBildTitel;
			GBDateipfad.Caption := sBildpropBildDateipfad;
		end;
	EFName.Enabled := not fMultiObjekt;
	EFDateipfad.Enabled := not fMultiObjekt;
	BDateipfad.Enabled := not fMultiObjekt;
	GBDateipfad.Enabled := not fMultiObjekt;
end;

procedure TBildEigenschaftenDlg.UpdateHelpContexts;
begin
	if fMultiObjekt then begin
		EFDateipfad.HelpContext := 900;
		BDateipfad.HelpContext := 900;
	end else begin
		if fOrdnerAuswahl then begin
			EFDateipfad.HelpContext := 9022;
			BDateipfad.HelpContext := 9032;
		end else begin
			EFDateipfad.HelpContext := 9021;
			BDateipfad.HelpContext := 9031;
		end;
	end;
end;

procedure TBildEigenschaftenDlg.SetOrdnerAuswahl(const Value: boolean);
begin
	if value<>fOrdnerAuswahl then begin
		fOrdnerAuswahl := Value;
		if fOrdnerAuswahl then fBildAuswahl := false;
		UpdateDlgTitel;
	end;
	UpdateHelpContexts;
end;

procedure TBildEigenschaftenDlg.SetBildAuswahl(const Value: boolean);
begin
	if value<>fBildAuswahl then begin
		fBildAuswahl := value;
		if fBildAuswahl then fOrdnerAuswahl := false;
		UpdateDlgTitel;
	end;
	UpdateHelpContexts;
end;

function TBildEigenschaftenDlg.GetOrdnerAuswahl: boolean;
begin
	result := not fMultiObjekt and not fBildAuswahl and DirectoryExists(Dateipfad);
end;


function TBildEigenschaftenDlg.GetBildAuswahl: boolean;
begin
	result := not fMultiObjekt and not fOrdnerAuswahl and FileExists(Dateipfad);
end;

procedure TBildEigenschaftenDlg.FormCreate(Sender: TObject);
var
	Reg:TUserRegistry;
begin
  TranslateComponent(Self);
	FObjekt := nil;
	fHaeufigkeitUpdating := false;
	fWartezeitUpdating := false;
	fBildAuswahl := false;
	fOrdnerAuswahl := false;
	fMultiObjekt := false;
	fAenderungen := soaAlle;
	TBWartezeit.Min := 0;
	TBWartezeit.Max := Round(Log10(High(tWartezeit))*100);
	UDWartezeitMin.Min := Low(tWartezeit) div 60;
	UDWartezeitMin.Max := High(tWartezeit) div 60;
	UDWartezeitSek.Min := -10;
	UDWartezeitSek.Max := 69;
	Wartezeit := cDefWartezeit;
	TBHaeufigkeit.Min := 0;
	TBHaeufigkeit.Max := Round(Log10(High(tHaeufigkeit))*100);
	UDHaeufigkeit.Min := Low(tHaeufigkeit);
	UDHaeufigkeit.Max := High(tHaeufigkeit);
	Haeufigkeit := cDefHaeufigkeit;
  EFSequenceNumber.MinValue := Low(integer);
  EFSequenceNumber.MaxValue := High(integer);
  SequenceNumber := cDefSequenceNumber;
	EFName.Clear;
	EFDateipfad.Clear;
	BitmapModus := cDefBitmapModus;
	Vergroesserung := cDefVergroesserung;
	Reg := TUserRegistry.Create;
	try
		OpenPictureDialog.InitialDir := Reg.LetzterBildordner;
	finally
		Reg.Free;
	end;
	CBHintergrundfarbe.DefaultColorColor := cDefHintergrundfarbe;
	OpenPictureDialog.Filter := MediaTypes.FileFilters;
end;

procedure TBildEigenschaftenDlg.FormDestroy(Sender: TObject);
var
	Reg:TUserRegistry;
begin
	FObjekt.Free;
	FObjekt := nil;
	Reg := TUserRegistry.Create;
	try
		Reg.LetzterBildordner := OpenPictureDialog.InitialDir;
	finally
		Reg.Free;
	end;
end;

procedure TBildEigenschaftenDlg.FormShow(Sender: TObject);
begin
  // force update of colorbox (VCL bug - QC 35845)
  CBHintergrundfarbe.Style := CBHintergrundfarbe.Style + [cbIncludeNone];
  CBHintergrundfarbe.Style := CBHintergrundfarbe.Style - [cbIncludeNone];
end;

procedure TBildEigenschaftenDlg.SetSammelobjekt(const Value: TSammelobjekt);
begin
	if fMultiObjekt then begin
		fMultiObjekt := false;
		UpdateDlgTitel;
	end;
	ObjName := Value.Name;
	OrdnerAuswahl := Value is TSammelordner;
	BildAuswahl := Value is TSammelbild;
	Dateipfad := Value.Pfad;
  SequenceNumber := Value.SequenceNumber;
	Haeufigkeit := Value.Haeufigkeit;
	Wartezeit := Value.Wartezeit;
	BitmapModus := Value.BitmapModus;
	Vergroesserung := Value.Vergroesserung;
	Hintergrundfarbe := Value.Hintergrundfarbe;
	fAenderungen := [];
	UpdateHelpContexts;
end;

function TBildEigenschaftenDlg.GetSammelobjekt: TSammelobjekt;
var
	Klasse:TSammelobjektKlasse;
begin
	if not fMultiObjekt then begin
		if OrdnerAuswahl then Klasse := TSammelordner else Klasse := TSammelbild;
		if not Assigned(FObjekt) or not (FObjekt is Klasse) then begin
			FObjekt.Free;
			FObjekt := Klasse.Create;
		end;
		Result := FObjekt;
		Result.Name := ObjName;
		Result.Pfad := Dateipfad;
    Result.SequenceNumber := SequenceNumber;
		Result.Haeufigkeit := Haeufigkeit;
		Result.Wartezeit := Wartezeit;
		Result.BitmapModus := BitmapModus;
		Result.Vergroesserung := Vergroesserung;
		Result.Hintergrundfarbe := Hintergrundfarbe;
	end else
    Result := nil;
end;

procedure TBildEigenschaftenDlg.SetMultiObjekt;
begin
	if not fMultiObjekt then begin
		fMultiObjekt := true;
		EFName.Text := sMehrfachauswahl;
		EFDateipfad.Text := sMehrfachauswahl;
		OrdnerAuswahl := false;
		BildAuswahl := false;
		UpdateDlgTitel;
	end;
  SequenceNumber := Value.SequenceNumber;
  with GBSequenceNumber do
    Caption := Caption + SUnveraendert;
	Haeufigkeit := Value.Haeufigkeit;
	with GBHaeufigkeit do
    Caption := Caption + SUnveraendert;
	Wartezeit := Value.Wartezeit;
	with GBWartezeit do
    Caption := Caption + SUnveraendert;
	BitmapModus := Value.BitmapModus;
	with GBVergroesserung do
    Caption := Caption + SUnveraendert;
	Hintergrundfarbe := Value.Hintergrundfarbe;
	with GBHintergrundfarbe do
    Caption := Caption + SUnveraendert;
	fAenderungen := [];
	UpdateHelpContexts;
end;

function TBildEigenschaftenDlg.GetMultiobjekt: TSammelobjekt;
var
	Klasse:TSammelobjektKlasse;
begin
	if fMultiObjekt then begin
		Klasse := TSammelobjekt;
		if not Assigned(FObjekt) or not (FObjekt is Klasse) then begin
			FObjekt.Free;
			FObjekt := Klasse.Create;
		end;
		Result := FObjekt;
		Result.Name := ObjName;
		Result.Pfad := Dateipfad;
    Result.SequenceNumber := SequenceNumber;
		Result.Haeufigkeit := Haeufigkeit;
		Result.Wartezeit := Wartezeit;
		Result.BitmapModus := BitmapModus;
		Result.Vergroesserung := Vergroesserung;
		Result.Hintergrundfarbe := Hintergrundfarbe;
	end else
    Result := nil;
end;

procedure TBildEigenschaftenDlg.CBHintergrundfarbeChange(Sender: TObject);
begin
	AenderungMelden(soaHintergrundfarbe);
end;

procedure TBildEigenschaftenDlg.SetHintergrundfarbe(const Value: tColor);
begin
	CBHintergrundfarbe.Selected := Value;
	AenderungMelden(soaHintergrundfarbe);
end;

function TBildEigenschaftenDlg.GetHintergrundfarbe: tColor;
begin
	result := CBHintergrundfarbe.Selected;
end;

procedure TBildEigenschaftenDlg.AenderungMelden;
	function TitelKorrektur(const bisher:string):string;
	var
		idx:integer;
	begin
		idx := Pos(sUnveraendert,bisher);
		if idx>0 then result := Copy(bisher,1,idx) else result := bisher;
	end;
begin
	if Active then begin
		if fMultiObjekt and not (aenderung in fAenderungen) then begin
			case aenderung of
				soaBitmapModus, soaVergroesserung:
          with GBVergroesserung do
            Caption := TitelKorrektur(Caption);
				soaHintergrundfarbe:
          with GBHintergrundfarbe do
            Caption := TitelKorrektur(Caption);
				soaWartezeit:
          with GBWartezeit do
            Caption := TitelKorrektur(Caption);
				soaHaeufigkeit:
          with GBHaeufigkeit do
            Caption := TitelKorrektur(Caption);
        soaSequenceNumber:
          with GBSequenceNumber do
            Caption := TitelKorrektur(Caption);
			end;
		end;
		Include(fAenderungen, aenderung);
	end;
end;

function TBildEigenschaftenDlg.GetVergroesserung: cardinal;
var
	sWert:string;
	iProzent:integer;
begin
	try
		sWert := CBVergroesserung.Text;
		iProzent := Pos('%',sWert);
		if iProzent>0 then begin
			SetLength(sWert,iProzent-1);
			result := StrToInt(sWert);
		end else
			result := Round(Abs(StrToFloat(sWert))*100);
	except
		on EConvertError do result := 0;
		on EMathError do result := 0;
		on EIntError do result := 0;
	end;
end;

procedure TBildEigenschaftenDlg.SetVergroesserung(const Value: cardinal);
begin
	CBVergroesserung.Text := Format('%u%%',[value]);
	AenderungMelden(soaVergroesserung);
end;

procedure TBildEigenschaftenDlg.RBBMClick(Sender: TObject);
begin
	fBitmapModus := tBitmapModus((Sender as TComponent).Tag);
	CBVergroesserung.Enabled := RBBMIsoSpeziell.Checked;
	AenderungMelden(soaBitmapModus);
end;

procedure TBildEigenschaftenDlg.CBVergroesserungChange(Sender: TObject);
begin
	AenderungMelden(soaVergroesserung);
end;

end.
