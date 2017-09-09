{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Peter Habcak <p.habcak@zoznam.sk>
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
unit mo_sk;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('Otváranie...');
    LOCstr_Status_Closing := UTF8Decode('Zatváranie...');
    LOCstr_Status_Playing := UTF8Decode('Prehrávanie');
    LOCstr_Status_Paused := UTF8Decode('Pozastavené');
    LOCstr_Status_Stopped := UTF8Decode('Zastavené');
    LOCstr_Status_Error := UTF8Decode('Nie je možné prehrať (kliknite pre viac informácií)');
    BPlaylist.Hint := UTF8Decode('Zoznam skladieb');
    BStreamInfo.Hint := UTF8Decode('Informácie o klipe');
    BFullscreen.Hint := UTF8Decode('Celá obrazovka');
    BCompact.Hint := UTF8Decode('Kompaktný režim');
    BMute.Hint := UTF8Decode('Stlmiť');
    MPCtrl.Caption := UTF8Decode('Show fullscreen controls');
    OSDMenu.Caption := UTF8Decode('Režim OSD');
    MNoOSD.Caption := UTF8Decode('Bez OSD');
    MDefaultOSD.Caption := UTF8Decode('Štandardné OSD');
    MTimeOSD.Caption := UTF8Decode('Zobraziť odohraný čas');
    MFullOSD.Caption := UTF8Decode('Zobraziť celkový čas');
    MFile.Caption := UTF8Decode('Súbor');
    MOpenFile.Caption := UTF8Decode('Prehrať súbor ...');
    MOpenURL.Caption := UTF8Decode('Prehrať URL ...');
    LOCstr_OpenURL_Caption := UTF8Decode('Prehrať URL');
    LOCstr_OpenURL_Prompt := UTF8Decode('Zadajte URL, ktoré chcete prehrať');
    MOpenDrive.Caption := UTF8Decode('Prehrať (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('Zatvoriť');
    MQuit.Caption := UTF8Decode('Koniec');
    MView.Caption := UTF8Decode('Zobraziť');
    MSizeAny.Caption := UTF8Decode('Vlastná veľkosť (');
    MSize50.Caption := UTF8Decode('Polovičná veľkosť');
    MSize100.Caption := UTF8Decode('Pôvodná veľkosť');
    MSize200.Caption := UTF8Decode('Dvojnásobná veľkosť');
    MFullscreen.Caption := UTF8Decode('Celá obrazovka');
    MCompact.Caption := UTF8Decode('Kompatný režim');
    MOSD.Caption := UTF8Decode('Prepnúť OSD');
    MOnTop.Caption := UTF8Decode('Vždy na vrchu');
    MSeek.Caption := UTF8Decode('Prehrať');
    MPlay.Caption := UTF8Decode('Prehrávať');
    MPause.Caption := UTF8Decode('Pauza');
    MPrev.Caption := UTF8Decode('Predchádzajúci');
    MNext.Caption := UTF8Decode('Nasledujúci');
    MShowPlaylist.Caption := UTF8Decode('Zoznam skladieb ...');
    MMute.Caption := UTF8Decode('Stlmiť');
    MSeekF10.Caption := UTF8Decode('Dopredu o 10 sekúnd');
    MSeekR10.Caption := UTF8Decode('Dozadu o 10 sekúnd');
    MSeekF60.Caption := UTF8Decode('Dopredu o 1 minútu');
    MSeekR60.Caption := UTF8Decode('Dozadu o 1 minútu');
    MSeekF600.Caption := UTF8Decode('Dopredu o 10 minút');
    MSeekR600.Caption := UTF8Decode('Dozadu o 10 minút');
    MExtra.Caption := UTF8Decode('Nástroje');
    MAudio.Caption := UTF8Decode('Audio stopa');
    MSubtitle.Caption := UTF8Decode('Titulková stopa');
    MAspects.Caption := UTF8Decode('Pomer strán');
    MAutoAspect.Caption := UTF8Decode('Automatický');
    MForce43.Caption := UTF8Decode('Vždy 4:3');
    MForce169.Caption := UTF8Decode('Vždy 16:9');
    MForceCinemascope.Caption := UTF8Decode('Vždy 2.35:1');
    MDeinterlace.Caption := UTF8Decode('Rozriadkovanie');
    MNoDeint.Caption := UTF8Decode('Vypnuté');
    MSimpleDeint.Caption := UTF8Decode('Jednoduché');
    MAdaptiveDeint.Caption := UTF8Decode('Adaptívne');
    MOptions.Caption := UTF8Decode('Nastavenia ...');
    MLanguage.Caption := UTF8Decode('Jazyk');
    MStreamInfo.Caption := UTF8Decode('Zobraziť informácie o klipe ...');
    MShowOutput.Caption := UTF8Decode('Zobraziť výstup MPlayeru ...');
    MHelp.Caption := UTF8Decode('Pomocník');
    MKeyHelp.Caption := UTF8Decode('Klávesové skratky ...');
    MAbout.Caption := UTF8Decode('O programe ...');
  end;
  OptionsForm.BClose.Caption := UTF8Decode('Zatvoriť');
  OptionsForm.HelpText.Text := UTF8Decode(
    'Navigačné klávesy:'^M^J +
    'Medzerník'^I'Prehrať/Pauza'^M^J +
    'Šípka doprava'^I'Doperdu o 10 sekúnd'^M^J +
    'Šípka doľava'^I'Dozadu o 10 sekúnd'^M^J +
    'Šípka hore'^I'Dopredu o 1 minútu'^M^J +
    'Šípka dole'^I'Dozadu o 1 minútu'^M^J +
    'PgUp'^I'Dopredu o 10 minút'^M^J +
    'PgDn'^I'Dozadu o 10 minút'^M^J +
    ^M^J+
    'Iné klávesy:'^M^J +
    'O'^I'Prepnúť OSD'^M^J +
    'F'^I'Celá obrazovka'^M^J +
    'C'^I'Kompaktný režim'^M^J +
    'T'^I'Vždy na vrchu'^M^J +
    'Q'^I'Koniec'^M^J +
    '9/0'^I'Nastavenie hlasitosti'^M^J +
    '-/+'^I'Nastavenie audio/video synchronizácie'^M^J +
    '1/2'^I'Nastavenie jasu'^M^J +
    '3/4'^I'Nastavenie kontrastu'^M^J +
    '5/6'^I'Nastavenie farieb'^M^J +
    '7/8'^I'Nastavenie sýtosti'
    );

  with OptionsForm do begin
    LVersionMPUI.Caption := UTF8Decode('Verzia MPUI-hcb:');
    LVersionMPlayer.Caption := UTF8Decode('Verzia MPlayer:');
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('O programe');
    Caption := UTF8Decode('Nastavenie');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('Použiť');
    BSave.Caption := UTF8Decode('Uložiť');
    LAudioOut.Caption := UTF8Decode('Výstupný ovládač zvuku');
    CAudioOut.Items[0] := UTF8Decode('(nedekódovať zvuk)');
    CAudioOut.Items[1] := UTF8Decode('(neprehrávať zvuk)');
    LAudioDev.Caption := UTF8Decode('Výstupné zariadenie DirectSound');
    LPostproc.Caption := UTF8Decode('Postprocessing');
    CPostproc.Items[0] := UTF8Decode('Vypnutý');
    CPostproc.Items[1] := UTF8Decode('Automatický');
    CPostproc.Items[2] := UTF8Decode('Maximálna kvalita');
    LOCstr_AutoLocale := UTF8Decode('(Automatický výber)');
    CIndex.Caption := UTF8Decode('Opraviť index súboru, ak je to nevyhnutné');
    CSoftVol.Caption := UTF8Decode('Softwarové ovládanie hlasitosti / Volume boost');
    CPriorityBoost.Caption := UTF8Decode('Spustiť s vyššou prioritou');
    LParams.Caption := UTF8Decode('Dotatočné parametre MPlayera:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Zoznam skladieb');
    BPlay.Hint := UTF8Decode('Prehrať');
    BAdd.Hint := UTF8Decode('Pridať ...');
    BMoveUp.Hint := UTF8Decode('Presunúť hore');
    BMoveDown.Hint := UTF8Decode('Presunúť dole');
    BDelete.Hint := UTF8Decode('Odstrániť');
    CShuffle.Hint := UTF8Decode('Náhodne');
    CLoop.Hint := UTF8Decode('Opakovať');
    BSave.Hint := UTF8Decode('Uložiť ...');
  end;
  InfoForm.Caption := UTF8Decode('Informácie o klipe');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('V tejto chvíli nie sú dostupné žiadne informácie.');
  LOCstr_InfoFileFormat := UTF8Decode('Formát');
  LOCstr_InfoPlaybackTime := UTF8Decode('Trvanie');
  LOCstr_InfoTags := UTF8Decode('Metadáta klipu');
  LOCstr_InfoVideo := UTF8Decode('Video stopa');
  LOCstr_InfoAudio := UTF8Decode('Audio stopa');
  LOCstr_InfoDecoder := UTF8Decode('Dekóder');
  LOCstr_InfoCodec := UTF8Decode('Kodek');
  LOCstr_InfoBitrate := UTF8Decode('Bitrate');
  LOCstr_InfoVideoSize := UTF8Decode('Dimensions');
  LOCstr_InfoVideoFPS := UTF8Decode('Počet snímkov za sekundu');
  LOCstr_InfoVideoAspect := UTF8Decode('Pomer strán');
  LOCstr_InfoAudioRate := UTF8Decode('Vzorkovacia frekvencia');
  LOCstr_InfoAudioChannels := UTF8Decode('Kanály');
end;

begin
  RegisterLocale(UTF8Decode('Slovenčina (Slovenian)'), Activate, LANG_SLOVAK, EASTEUROPE_CHARSET);
end.
