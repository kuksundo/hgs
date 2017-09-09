{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006-2013 Huang Chen Bin <hcb428@foxmail.com>
    based on work by Martin J. Fiedler <martin.fiedler@gmx.net>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit mo_de;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('Öffne ...');
    LOCstr_Status_Closing := UTF8Decode('Schließe ...');
    LOCstr_Status_Playing := UTF8Decode('Wiedergabe');
    LOCstr_Status_Paused := UTF8Decode('Angehalten');
    LOCstr_Status_Stopped := UTF8Decode('Abgebrochen');
    LOCstr_Status_Error := UTF8Decode('Abspielen fehlgeschlagen (Klicken für weitere Informationen)');
    BPlaylist.Hint := UTF8Decode('Wiedergabeliste anzeigen/verbergen');
    BStreamInfo.Hint := UTF8Decode('Clip-Informationen anzeigen/verbergen');
    BFullscreen.Hint := UTF8Decode('Vollbildmodus ein/ausschalten');
    BCompact.Hint := UTF8Decode('Kompakte Darstellung ein/ausschalten');
    MPCtrl.Caption := UTF8Decode('Steuerelemente im Vollbildmodus anzeigen');
    OSDMenu.Caption := UTF8Decode('OSD-Modus');
    MNoOSD.Caption := UTF8Decode('Kein OSD');
    MDefaultOSD.Caption := UTF8Decode('Standard-OSD');
    MTimeOSD.Caption := UTF8Decode('Zeitanzeige');
    MFullOSD.Caption := UTF8Decode('Gesamtzeitanzeige');
    BMute.Hint := UTF8Decode('Stummschaltung ein/aus');
    MFile.Caption := UTF8Decode('Datei');
    MOpenFile.Caption := UTF8Decode('Datei abspielen ...');
    MOpenURL.Caption := UTF8Decode('URL abspielen ...');
    LOCstr_OpenURL_Caption := UTF8Decode('URL abspielen');
    LOCstr_OpenURL_Prompt := UTF8Decode('Welche URL soll abgespielt werden?');
    MOpenDrive.Caption := UTF8Decode('(V)CD/DVD/BlueRay abspielen');
    MClose.Caption := UTF8Decode('Schließen');
    MQuit.Caption := UTF8Decode('Beenden');
    MView.Caption := UTF8Decode('Ansicht');
    MSizeAny.Caption := UTF8Decode('Beliebige Größe (');
    MSize50.Caption := UTF8Decode('Halbe Größe');
    MSize100.Caption := UTF8Decode('Originalgröße');
    MSize200.Caption := UTF8Decode('Doppelte Größe');
    MFullscreen.Caption := UTF8Decode('Vollbildmodus');
    MCompact.Caption := UTF8Decode('Kompakte Darstellung');
    MOSD.Caption := UTF8Decode('OSD umschalten');
    MOnTop.Caption := UTF8Decode('Immer im Vordergrund');
    MSeek.Caption := UTF8Decode('Wiedergabe');
    MPlay.Caption := UTF8Decode('Abspielen');
    MPause.Caption := UTF8Decode('Pause');
    MPrev.Caption := UTF8Decode('Voriger Titel');
    MNext.Caption := UTF8Decode('Nächster Titel');
    MShowPlaylist.Caption := UTF8Decode('Wiedergabeliste ...');
    MMute.Caption := UTF8Decode('Stumm');
    MSeekF10.Caption := UTF8Decode('10 Sekunden vorwärts');
    MSeekR10.Caption := UTF8Decode('10 Sekunden zurück');
    MSeekF60.Caption := UTF8Decode('1 Minute vorwärts');
    MSeekR60.Caption := UTF8Decode('1 Minute zurück');
    MSeekF600.Caption := UTF8Decode('10 Minuten vorwärts');
    MSeekR600.Caption := UTF8Decode('10 Minuten zurück');
    MExtra.Caption := UTF8Decode('Extras');
    MAudio.Caption := UTF8Decode('Tonspur');
    MSubtitle.Caption := UTF8Decode('Untertitelspur');
    MAspects.Caption := UTF8Decode('Seitenverhältnis');
    MAutoAspect.Caption := UTF8Decode('Automatisch');
    MForce43.Caption := UTF8Decode('Immer 4:3');
    MForce169.Caption := UTF8Decode('Immer 16:9');
    MForceCinemascope.Caption := UTF8Decode('Immer 2.35:1');
    MDeinterlace.Caption := UTF8Decode('Deinterlacing');
    MNoDeint.Caption := UTF8Decode('Aus');
    MSimpleDeint.Caption := UTF8Decode('Einfach');
    MAdaptiveDeint.Caption := UTF8Decode('Adaptiv');
    MOptions.Caption := UTF8Decode('Optionen ...');
    MLanguage.Caption := UTF8Decode('Sprache');
    MStreamInfo.Caption := UTF8Decode('Clip-Informationen anzeigen ...');
    MShowOutput.Caption := UTF8Decode('MPlayer-Ausgabe anzeigen ...');
    MHelp.Caption := UTF8Decode('Hilfe');
    MKeyHelp.Caption := UTF8Decode('Tastaturhilfe ...');
    MAbout.Caption := UTF8Decode('Über ...');
  end;
  OptionsForm.BClose.Caption := UTF8Decode('Schließen');
  OptionsForm.HelpText.Text := UTF8Decode(
    'Navigationstasten:'^M^J +
    'Leertaste'^I'Abspielen/Pause'^M^J +
    'Rechts'^I'10 Sekunden vorwärts'^M^J +
    'Links'^I'10 Sekunden zurück'^M^J +
    'Oben'^I'1 Minute vorwärts'^M^J +
    'Unten'^I'1 Minute zurück'^M^J +
    'BildAuf'^I'10 Minuten vorwärts'^M^J +
    'BildAb'^I'10 Minuten zurück'^M^J +
    ^M^J+
    'Sonstige Tasten:'^M^J +
    'O'^I'OSD umschalten'^M^J +
    'F'^I'Vollbildmodus ein/aus'^M^J +
    'C'^I'Kompakte Darstellung ein/aus'^M^J +
    'T'^I'Immer im Vordergrund ein/aus'^M^J +
    'Q'^I'Sofort beenden'^M^J +
    '9/0'^I'Lautstärke einstellen'^M^J +
    '-/+'^I'Bild/Ton-Synchronisation einstellen'^M^J +
    '1/2'^I'Helligkeit einstellen'^M^J +
    '3/4'^I'Kontrast einstellen'^M^J +
    '5/6'^I'Farbton einstellen'^M^J +
    '7/8'^I'Sättigung einstellen');
  with OptionsForm do begin
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('Über');
    LVersionMPUI.Caption := UTF8Decode('MPUI-hcb Version:');
    LVersionMPlayer.Caption := UTF8Decode('MPlayer-Version:');
    Caption := UTF8Decode('Optionen');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('Übernehmen');
    BSave.Caption := UTF8Decode('Speichern');
    LAudioOut.Caption := UTF8Decode('Soundausgabetreiber');
    CAudioOut.Items[0] := UTF8Decode('(keinen Sound decodieren)');
    CAudioOut.Items[1] := UTF8Decode('(keinen Sound ausgeben)');
    LAudioDev.Caption := UTF8Decode('DirectSound-Ausgabegerät');
    LPostproc.Caption := UTF8Decode('Postprocessing');
    CPostproc.Items[0] := UTF8Decode('Aus');
    CPostproc.Items[1] := UTF8Decode('Automatisch');
    CPostproc.Items[2] := UTF8Decode('Maximale Qualität');
    LOCstr_AutoLocale := UTF8Decode('(Automatisch)');
    CIndex.Caption := UTF8Decode('Dateiindex rekonstruieren, wenn notwendig');
    CSoftVol.Caption := UTF8Decode('Software-Lautstärkereglung (ermöglicht höhere Lautstärke)');
    CPriorityBoost.Caption := UTF8Decode('Höhere Priorität');
    LParams.Caption := UTF8Decode('Zusätzliche MPlayer-Parameter:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Wiedergabeliste');
    BPlay.Hint := UTF8Decode('Abspielen');
    BAdd.Hint := UTF8Decode('Hinzufügen ...');
    BMoveUp.Hint := UTF8Decode('Nach oben');
    BMoveDown.Hint := UTF8Decode('Nach unten');
    BDelete.Hint := UTF8Decode('Entfernen');
    CShuffle.Hint := UTF8Decode('Zufall');
    CLoop.Hint := UTF8Decode('Wiederholen');
    BSave.Hint := UTF8Decode('Speichern ...');
  end;
  InfoForm.Caption := UTF8Decode('Clip-Informationen');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('Zur Zeit sind keine Informationen verfügbar.');
  LOCstr_InfoFileFormat := UTF8Decode('Format');
  LOCstr_InfoPlaybackTime := UTF8Decode('Abspieldauer');
  LOCstr_InfoTags := UTF8Decode('Metadaten');
  LOCstr_InfoVideo := UTF8Decode('Videospur');
  LOCstr_InfoAudio := UTF8Decode('Tonspur');
  LOCstr_InfoDecoder := UTF8Decode('Decoder');
  LOCstr_InfoCodec := UTF8Decode('Codec');
  LOCstr_InfoBitrate := UTF8Decode('Bitrate');
  LOCstr_InfoVideoSize := UTF8Decode('Bildgröße');
  LOCstr_InfoVideoFPS := UTF8Decode('Framerate');
  LOCstr_InfoVideoAspect := UTF8Decode('Seitenverhältnis');
  LOCstr_InfoAudioRate := UTF8Decode('Samplerate');
  LOCstr_InfoAudioChannels := UTF8Decode('Kanäle');
end;

begin
  RegisterLocale(UTF8Decode('Deutsch'), Activate, LANG_GERMAN, DEFAULT_CHARSET);
end.
