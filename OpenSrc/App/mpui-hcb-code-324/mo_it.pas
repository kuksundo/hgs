{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Andres Zanzani <azanzani@gmail.com>
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
unit mo_it;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('Aprendo ...');
    LOCstr_Status_Closing := UTF8Decode('Chiudendo ...');
    LOCstr_Status_Playing := UTF8Decode('In Apertura');
    LOCstr_Status_Paused := UTF8Decode('Fermato');
    LOCstr_Status_Stopped := UTF8Decode('Interrotto');
    LOCstr_Status_Error := UTF8Decode('Non in grado di mandare in play (Clicca per maggiori info)');
    BPlaylist.Hint := UTF8Decode('Mostra/Nascondi playlist');
    BStreamInfo.Hint := UTF8Decode('Mostra/Nascondi info su clip');
    BFullscreen.Hint := UTF8Decode('Attiva a tutto schermo');
    BCompact.Hint := UTF8Decode('Attiva modalita compatta');
    BMute.Hint := UTF8Decode('Imposta muto');
    MPCtrl.Caption := UTF8Decode('Mostra controlli di tutto schermo');
    OSDMenu.Caption := UTF8Decode('OSD');
    MNoOSD.Caption := UTF8Decode('NO OSD');
    MDefaultOSD.Caption := UTF8Decode('Default OSD');
    MTimeOSD.Caption := UTF8Decode('Mostra tempo');
    MFullOSD.Caption := UTF8Decode('Mostra tempo totale');
    MFile.Caption := UTF8Decode('File');
    MOpenFile.Caption := UTF8Decode('Apri file ...');
    MOpenURL.Caption := UTF8Decode('Apri URL ...');
    LOCstr_OpenURL_Caption := UTF8Decode('Apri URL');
    LOCstr_OpenURL_Prompt := UTF8Decode('Quale URL vuoi vedere?');
    MOpenDrive.Caption := UTF8Decode('Apri (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('Chiudi');
    MQuit.Caption := UTF8Decode('Esci');
    MView.Caption := UTF8Decode('Guarda');
    MSizeAny.Caption := UTF8Decode('Personalizza Dim (');
    MSize50.Caption := UTF8Decode('1/2 dimensione');
    MSize100.Caption := UTF8Decode('1/1 diensione');
    MSize200.Caption := UTF8Decode('2X dimensione');
    MFullscreen.Caption := UTF8Decode('Tutto Schermo');
    MCompact.Caption := UTF8Decode('Modo compatto');
    MOSD.Caption := UTF8Decode('Attiva OSD');
    MOnTop.Caption := UTF8Decode('In primo piano');
    MSeek.Caption := UTF8Decode('Clip');
    MPlay.Caption := UTF8Decode('Avvia');
    MPause.Caption := UTF8Decode('Pausa');
    MPrev.Caption := UTF8Decode('Titolo precedente');
    MNext.Caption := UTF8Decode('Prossimo titolo');
    MShowPlaylist.Caption := UTF8Decode('Playlist ...');
    MMute.Caption := UTF8Decode('Muto');
    MSeekF10.Caption := UTF8Decode('Avanza 10 secondi');
    MSeekR10.Caption := UTF8Decode('Indietro 10 secondi');
    MSeekF60.Caption := UTF8Decode('Avanza 1 minuto');
    MSeekR60.Caption := UTF8Decode('Indietro 1 minuto');
    MSeekF600.Caption := UTF8Decode('Avanza 10 minuti');
    MSeekR600.Caption := UTF8Decode('Indietro 10 minuti');
    MExtra.Caption := UTF8Decode('Strumenti');
    MAudio.Caption := UTF8Decode('Traccia Audio');
    MSubtitle.Caption := UTF8Decode('Traccia Sottotitoli');
    MAspects.Caption := UTF8Decode('Aspetto (AR)');
    MAutoAspect.Caption := UTF8Decode('Automatico');
    MForce43.Caption := UTF8Decode('Forza 4:3');
    MForce169.Caption := UTF8Decode('Forza 16:9');
    MForceCinemascope.Caption := UTF8Decode('Forza 2.35:1');
    MDeinterlace.Caption := UTF8Decode('Deinterlacciatura');
    MNoDeint.Caption := UTF8Decode('Disattivo');
    MSimpleDeint.Caption := UTF8Decode('Semplice');
    MAdaptiveDeint.Caption := UTF8Decode('Adattivo');
    MOptions.Caption := UTF8Decode('Opzioni ...');
    MLanguage.Caption := UTF8Decode('Linguaggio');
    MStreamInfo.Caption := UTF8Decode('Mostra info su clip ...');
    MShowOutput.Caption := UTF8Decode('Mostra MPlayer info ...');
    MHelp.Caption := UTF8Decode('Aiuto');
    MKeyHelp.Caption := UTF8Decode('Aiuto Tastiera ...');
    MAbout.Caption := UTF8Decode('Circa ...');
  end;
  OptionsForm.BClose.Caption := UTF8Decode('Chiudi');
  OptionsForm.HelpText.Text := UTF8Decode(
    'Tasti Navigazione:'^M^J +
    'Spazio'^I'Avvia/Pausa'^M^J +
    'Destra'^I'Avanza 10 secondi'^M^J +
    'Sinistra'^I'Indietro 10 secondi'^M^J +
    'Su'^I'Avanza 1 minuto'^M^J +
    'Giu'^I'Indietro 1 minuto'^M^J +
    'PgSu'^I'Avanza 10 minuti'^M^J +
    'PgGiu'^I'Indetro 10 minuti'^M^J +
    ^M^J+
    'Altri Tasti:'^M^J +
    'O'^I'Attiva OSD'^M^J +
    'F'^I'Attiva tutto schermo'^M^J +
    'C'^I'Attiva modalita compatta'^M^J +
    'T'^I'Attiva in primo piano'^M^J +
    'Q'^I'Esci subito'^M^J +
    '9/0'^I'Aggiusta volume'^M^J +
    '-/+'^I'Aggiusta sincro audio/video'^M^J +
    '1/2'^I'Aggiusta luminosita'^M^J +
    '3/4'^I'Aggiusta contrasto'^M^J +
    '5/6'^I'Aggiusta tono'^M^J +
    '7/8'^I'Aggiusta saturazione');

  with OptionsForm do begin
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('Circa');
    LVersionMPUI.Caption := UTF8Decode('Versione MPUI-hcb:');
    LVersionMPlayer.Caption := UTF8Decode('Versione MPlayer:');
    Caption := UTF8Decode('Opzioni');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('Applica');
    BSave.Caption := UTF8Decode('Salva');
    LAudioOut.Caption := UTF8Decode('Driver sonoro');
    CAudioOut.Items[0] := UTF8Decode('(non decodificare audio)');
    CAudioOut.Items[1] := UTF8Decode('(non fare suoni)');
    LAudioDev.Caption := UTF8Decode('Periferica DirectSound');
    LPostproc.Caption := UTF8Decode('Postprocessing');
    CPostproc.Items[0] := UTF8Decode('Disattivo');
    CPostproc.Items[1] := UTF8Decode('Automatico');
    CPostproc.Items[2] := UTF8Decode('Massima qualita');
    LOCstr_AutoLocale := UTF8Decode('(automatica)');
    CIndex.Caption := UTF8Decode('Ricostruisci indice se necessario');
    CSoftVol.Caption := UTF8Decode('Controllo Soft. del volume / Alza Volume');
    CPriorityBoost.Caption := UTF8Decode('Avvia in alta priorita');
    LParams.Caption := UTF8Decode('Parametri addizionali per MPlayer:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Playlist');
    BPlay.Hint := UTF8Decode('Avvia');
    BAdd.Hint := UTF8Decode('Aggiungi ...');
    BMoveUp.Hint := UTF8Decode('Alza');
    BMoveDown.Hint := UTF8Decode('Abbassa');
    BDelete.Hint := UTF8Decode('Togli');
  end;
  InfoForm.Caption := UTF8Decode('Informzioni sulla Clip');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('Nessuna informazione disponibile.');
  LOCstr_InfoFileFormat := UTF8Decode('Formato');
  LOCstr_InfoPlaybackTime := UTF8Decode('Durata');
  LOCstr_InfoTags := UTF8Decode('Clip Metadata');
  LOCstr_InfoVideo := UTF8Decode('Traccia video');
  LOCstr_InfoAudio := UTF8Decode('Traccia audio');
  LOCstr_InfoDecoder := UTF8Decode('Decoder');
  LOCstr_InfoCodec := UTF8Decode('Codec');
  LOCstr_InfoBitrate := UTF8Decode('Bitrate');
  LOCstr_InfoVideoSize := UTF8Decode('Dimensione');
  LOCstr_InfoVideoFPS := UTF8Decode('Frame Rate');
  LOCstr_InfoVideoAspect := UTF8Decode('Aspect Ratio');
  LOCstr_InfoAudioRate := UTF8Decode('Frequenza');
  LOCstr_InfoAudioChannels := UTF8Decode('Canali');
end;

begin
  RegisterLocale(UTF8Decode('Italiano (Italian)'), Activate, LANG_ITALIAN, ANSI_CHARSET);
end.
