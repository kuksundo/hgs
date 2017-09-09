{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Florin Valcu <florin.valcu@gmail.com>
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
unit mo_ro;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('Se deschide ...');
    LOCstr_Status_Closing := UTF8Decode('Se inchide ...');
    LOCstr_Status_Playing := UTF8Decode('Redare');
    LOCstr_Status_Paused := UTF8Decode('Pauză');
    LOCstr_Status_Stopped := UTF8Decode('Oprit');
    LOCstr_Status_Error := UTF8Decode('Fisierul multimedia nu poate fi redat (Click pentru informaţii suplimentare)');
    BPlaylist.Hint := UTF8Decode('Arată/ascunde lista de redare');
    BStreamInfo.Hint := UTF8Decode('Arată/ascunde informaţii despre fişierul curent');
    BFullscreen.Hint := UTF8Decode('Activează modul fullscreen');
    BCompact.Hint := UTF8Decode('Activează modul compact');
    BMute.Hint := UTF8Decode('Fără sonor');
    MPCtrl.Caption := UTF8Decode('Arată controalele in modul fullscreen');
    OSDMenu.Caption := UTF8Decode('Mod OSD');
    MNoOSD.Caption := UTF8Decode('Fără OSD');
    MDefaultOSD.Caption := UTF8Decode('OSD-ul implicit');
    MTimeOSD.Caption := UTF8Decode('Arată durata redării');
    MFullOSD.Caption := UTF8Decode('Arată durata totală');
    MFile.Caption := UTF8Decode('Fişier');
    MOpenFile.Caption := UTF8Decode('Redă fişierul multimedia ...');
    MOpenURL.Caption := UTF8Decode('Redă de la locaţia din Internet ...');
    LOCstr_OpenURL_Caption := UTF8Decode('Redă de la locaţia din Internet');
    LOCstr_OpenURL_Prompt := UTF8Decode('De la care locaţie din Internet doriţi sa se efectueze redarea?');
    MOpenDrive.Caption := UTF8Decode('Redă (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('Închide');
    MQuit.Caption := UTF8Decode('Ieşire');
    MView.Caption := UTF8Decode('Vizualizare');
    MSizeAny.Caption := UTF8Decode('Mărime particulară (');
    MSize50.Caption := UTF8Decode('Jumătate din mărimea originală');
    MSize100.Caption := UTF8Decode('Mărimea originală');
    MSize200.Caption := UTF8Decode('Mărime dublă');
    MFullscreen.Caption := UTF8Decode('Fullscreen');
    MCompact.Caption := UTF8Decode('Modul compact');
    MOSD.Caption := UTF8Decode('Activează OSD');
    MOnTop.Caption := UTF8Decode('Fereastra întotdeauna vizibilă');
    MSeek.Caption := UTF8Decode('Redare');
    MPlay.Caption := UTF8Decode('Redare');
    MPause.Caption := UTF8Decode('Pauză');
    MPrev.Caption := UTF8Decode('Titlul anterior');
    MNext.Caption := UTF8Decode('Titlul următor');
    MShowPlaylist.Caption := UTF8Decode('Lista de redare ...');
    MMute.Caption := UTF8Decode('Fără sonor');
    MSeekF10.Caption := UTF8Decode('Înainte 10 secunde');
    MSeekR10.Caption := UTF8Decode('Înapoi 10 secunde');
    MSeekF60.Caption := UTF8Decode('Înainte 1 minut');
    MSeekR60.Caption := UTF8Decode('Înapoi 1 minut');
    MSeekF600.Caption := UTF8Decode('Înainte 10 minute');
    MSeekR600.Caption := UTF8Decode('Înapoi 10 minute');
    MExtra.Caption := UTF8Decode('Opţiuni');
    MAudio.Caption := UTF8Decode('Canal audio');
    MSubtitle.Caption := UTF8Decode('Canal subtitrări');
    MAspects.Caption := UTF8Decode('Aspectul redării');
    MAutoAspect.Caption := UTF8Decode('Detectează automat');
    MForce43.Caption := UTF8Decode('Forţează 4:3');
    MForce169.Caption := UTF8Decode('Forţează 16:9');
    MForceCinemascope.Caption := UTF8Decode('Forţează 2.35:1');
    MDeinterlace.Caption := UTF8Decode('Filtrare de tip deinterlace');
    MNoDeint.Caption := UTF8Decode('Dezactivată');
    MSimpleDeint.Caption := UTF8Decode('Simplă');
    MAdaptiveDeint.Caption := UTF8Decode('Adaptivă');
    MOptions.Caption := UTF8Decode('Reglaje ...');
    MLanguage.Caption := UTF8Decode('Limbă');
    MStreamInfo.Caption := UTF8Decode('Arată informaţii despre fişierul multimedia ...');
    MShowOutput.Caption := UTF8Decode('Arată mesajele de informare de la MPlayer ...');
    MHelp.Caption := UTF8Decode('Ajutor');
    MKeyHelp.Caption := UTF8Decode('Operare cu tastele ...');
    MAbout.Caption := UTF8Decode('Despre ...');
  end;
  OptionsForm.BClose.Caption := UTF8Decode('Închide');
  OptionsForm.HelpText.Text := UTF8Decode(
    'Taste de navigare:'^M^J +
    'Space'^I'Redare/Pauză'^M^J +
    'Right'^I'Înainte 10 secunde'^M^J +
    'Left'^I'Înapoi 10 secunde'^M^J +
    'Up'^I'Înainte 1 minut'^M^J +
    'Down'^I'Înapoi 1 minut'^M^J +
    'PgUp'^I'Înainte 10 minute'^M^J +
    'PgDn'^I'Înapoi 10 minute'^M^J +
    ^M^J+
    'Alte taste:'^M^J +
    'O'^I'Activează/dezactivează OSD'^M^J +
    'F'^I'Activează/dezactivează mod fullscreen'^M^J +
    'C'^I'Activează/dezactivează mod compact'^M^J +
    'T'^I'Activează/dezactivează opţiune fereastră întotdeauna vizibilă'^M^J +
    'Q'^I'Abandonare program'^M^J +
    '9/0'^I'Ajustează volumul'^M^J +
    '-/+'^I'Ajustează sincronizarea audio/video'^M^J +
    '1/2'^I'Ajustează strălucirea'^M^J +
    '3/4'^I'Ajustează contrastul'^M^J +
    '5/6'^I'Ajustează nuanţele'^M^J +
    '7/8'^I'Ajustează saturaţia'
    );

  with OptionsForm do begin
    TAbout.Caption := UTF8Decode('Despre');
    THelp.Caption := MainForm.MHelp.Caption;
    LVersionMPUI.Caption := UTF8Decode('Versiunea MPUI-hcb:');
    LVersionMPlayer.Caption := UTF8Decode('Versiunea MPlayer:');
    Caption := UTF8Decode('Opţiuni');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('Aplică');
    BSave.Caption := UTF8Decode('Salvează');
    LAudioOut.Caption := UTF8Decode('Driver-ul pentru sunet');
    CAudioOut.Items[0] := UTF8Decode('(nu decodifica sunetul)');
    CAudioOut.Items[1] := UTF8Decode('(nu reda sunetul)');
    LAudioDev.Caption := UTF8Decode('Ieşire DirectSound');
    LPostproc.Caption := UTF8Decode('Postprocesare');
    CPostproc.Items[0] := UTF8Decode('Dezactivată');
    CPostproc.Items[1] := UTF8Decode('Automată');
    CPostproc.Items[2] := UTF8Decode('Calitate maximă');
    LOCstr_AutoLocale := UTF8Decode('(Selecţie automată)');
    CIndex.Caption := UTF8Decode('Reconstruieşte indecşii fişierului multimedia dacă este necesar');
    CSoftVol.Caption := UTF8Decode('Control software al volumului / Amplificarea Volumului');
    CPriorityBoost.Caption := UTF8Decode('Execută aplicaţia cu prioritate de tip higher');
    LParams.Caption := UTF8Decode('Parametri adiţionali pentru MPlayer:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Lista de redare');
    BPlay.Hint := UTF8Decode('Redă');
    BAdd.Hint := UTF8Decode('Adaugă ...');
    BMoveUp.Hint := UTF8Decode('Deplasează in sus');
    BMoveDown.Hint := UTF8Decode('Deplasează in jos');
    BDelete.Hint := UTF8Decode('Elimină');
    CShuffle.Hint := UTF8Decode('Amestecă');
    CLoop.Hint := UTF8Decode('Repetă');
    BSave.Hint := UTF8Decode('Salvează ...');
  end;
  InfoForm.Caption := UTF8Decode('Informaţii despre fişierul multimedia');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('Acum nu este disponibilă nici o informaţie despre fisierul multimedia.');
  LOCstr_InfoFileFormat := UTF8Decode('Format');
  LOCstr_InfoPlaybackTime := UTF8Decode('Întindere');
  LOCstr_InfoTags := UTF8Decode('Date suplimentare');
  LOCstr_InfoVideo := UTF8Decode('Canalul video');
  LOCstr_InfoAudio := UTF8Decode('Canalul audio');
  LOCstr_InfoDecoder := UTF8Decode('Decodor');
  LOCstr_InfoCodec := UTF8Decode('Codec');
  LOCstr_InfoBitrate := UTF8Decode('Rata de transfer');
  LOCstr_InfoVideoSize := UTF8Decode('Dimensiuni');
  LOCstr_InfoVideoFPS := UTF8Decode('Numărul de cadre');
  LOCstr_InfoVideoAspect := UTF8Decode('Aspect');
  LOCstr_InfoAudioRate := UTF8Decode('Rata sample-urilor');
  LOCstr_InfoAudioChannels := UTF8Decode('Numărul de canale');
end;

begin
  RegisterLocale(UTF8Decode('Română (Romania)'), Activate, LANG_ENGLISH, EASTEUROPE_CHARSET);
end.
