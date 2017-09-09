{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Jens Kikkenborg <flanke@gmail.com>
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
unit mo_dk;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('Åbner ...');
    LOCstr_Status_Closing := UTF8Decode('Lukker ...');
    LOCstr_Status_Playing := UTF8Decode('Spiller');
    LOCstr_Status_Paused := UTF8Decode('Pauset');
    LOCstr_Status_Stopped := UTF8Decode('Stoppet');
    LOCstr_Status_Error := UTF8Decode('Kan ikke afspille media  (klik for mere info)');
    BPlaylist.Hint := UTF8Decode('Vis/skjul spilleliste vindue');
    BStreamInfo.Hint := UTF8Decode('Vis/skjul klip information');
    BFullscreen.Hint := UTF8Decode('Skift fuldskærms mode');
    BCompact.Hint := UTF8Decode('Kompakt mode til/fra');
    BMute.Hint := UTF8Decode('Lydløs til/fra');
    MPCtrl.Caption := UTF8Decode('Vis fuldskærms controls');
    OSDMenu.Caption := UTF8Decode('OSD mode');
    MNoOSD.Caption := UTF8Decode('Ingen OSD');
    MDefaultOSD.Caption := UTF8Decode('Normal OSD');
    MTimeOSD.Caption := UTF8Decode('Vis tid');
    MFullOSD.Caption := UTF8Decode('Vis sammenlagt tid');
    MFile.Caption := UTF8Decode('Filer');
    MOpenFile.Caption := UTF8Decode('Afspil fil ...');
    MOpenURL.Caption := UTF8Decode('Afspil Internetadresse ...');
    LOCstr_OpenURL_Caption := UTF8Decode('Afspil Internetadresse');
    LOCstr_OpenURL_Prompt := UTF8Decode('Hvilken Internetadresse vil du gerne afspille?');
    MOpenDrive.Caption := UTF8Decode('Afspil (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('Luk');
    MQuit.Caption := UTF8Decode('Afslut');
    MView.Caption := UTF8Decode('Vis');
    MSizeAny.Caption := UTF8Decode('Normal størrelse (');
    MSize50.Caption := UTF8Decode('Halv størrelse');
    MSize100.Caption := UTF8Decode('Original størrelse');
    MSize200.Caption := UTF8Decode('Dobbelt størrelse');
    MFullscreen.Caption := UTF8Decode('Fuldsk' +
      'rm');
    MCompact.Caption := UTF8Decode('Kompakt mode');
    MOSD.Caption := UTF8Decode('Skift OSD');
    MOnTop.Caption := UTF8Decode('Altid på toppen');
    MSeek.Caption := UTF8Decode('Afspil');
    MPlay.Caption := UTF8Decode('Afspil');
    MPause.Caption := UTF8Decode('Pause');
    MPrev.Caption := UTF8Decode('Forrige titel');
    MNext.Caption := UTF8Decode('Næste titel');
    MShowPlaylist.Caption := UTF8Decode('Afspilningsliste ...');
    MMute.Caption := UTF8Decode('Lydløs');
    MSeekF10.Caption := UTF8Decode('Spol 10 sekunder fremad');
    MSeekR10.Caption := UTF8Decode('Spol 10 Sekunder tilbage');
    MSeekF60.Caption := UTF8Decode('Spol 1 minut fremad');
    MSeekR60.Caption := UTF8Decode('Spol 1 minut tilbage');
    MSeekF600.Caption := UTF8Decode('Spol 10 minutter fremad');
    MSeekR600.Caption := UTF8Decode('Spol 10 minutter tilbage');
    MExtra.Caption := UTF8Decode('Værktøjer');
    MAudio.Caption := UTF8Decode('Lydspor');
    MSubtitle.Caption := UTF8Decode('Undertextspor');
    MAspects.Caption := UTF8Decode('Aspekt Forhold');
    MAutoAspect.Caption := UTF8Decode('Opfang Automatisk');
    MForce43.Caption := UTF8Decode('Tving 4:3');
    MForce169.Caption := UTF8Decode('Tving 16:9');
    MForceCinemascope.Caption := UTF8Decode('Tving 2.35:1');
    MDeinterlace.Caption := UTF8Decode('Fjern Interfacet');
    MNoDeint.Caption := UTF8Decode('Slået fra');
    MSimpleDeint.Caption := UTF8Decode('Simpel');
    MAdaptiveDeint.Caption := UTF8Decode('Tilpasselig');
    MOptions.Caption := UTF8Decode('Funktioner ...');
    MLanguage.Caption := UTF8Decode('Sprog');
    MStreamInfo.Caption := UTF8Decode('Vis Klip information ...');
    MShowOutput.Caption := UTF8Decode('Vis MPlayer udlæsning ...');
    MHelp.Caption := UTF8Decode('Hjælp');
    MKeyHelp.Caption := UTF8Decode('Tastaturhjælp ...');
    MAbout.Caption := UTF8Decode('Om ...');
  end;
  OptionsForm.BClose.Caption := UTF8Decode('Luk');
  OptionsForm.HelpText.Text := UTF8Decode(
    'Navigationstast:'^M^J +
    'Mellemrum'^I'Afspil/pause'^M^J +
    'Højre'^I'Spol 10 sekunder fremad'^M^J +
    'Venstre'^I'Spol 10 sekunder tilbage'^M^J +
    'Op'^I'Spol 1 minut fremad'^M^J +
    'Ned'^I'Spol 1 minut tilbage'^M^J +
    'PgUp'^I'Spol 10 minutter fremad'^M^J +
    'PgDn'^I'Spol 10 minutter Tilbage'^M^J +
    ^M^J+
    'Andre taster:'^M^J +
    'O'^I'OSD'^M^J +
    'F'^I'Fuldskærm til/fra'^M^J +
    'C'^I'Kompakt mode til/fra'^M^J +
    'T'^I'Altid på toppen til/fra'^M^J +
    'Q'^I'Afslut med det samme'^M^J +
    '9/0'^I'Tilpas lydstyrke'^M^J +
    '-/+'^I'Tilpas lyd/video sync'^M^J +
    '1/2'^I'Tilpas lysstyrke'^M^J +
    '3/4'^I'Tilpas kontrast'^M^J +
    '5/6'^I'Tilpas farve'^M^J +
    '7/8'^I'Tilpas mætning');
  with OptionsForm do begin
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('Om');
    LVersionMPUI.Caption := UTF8Decode('MPUI-hcb version:');
    LVersionMPlayer.Caption := UTF8Decode('MPlayer kerne version:');
    Caption := UTF8Decode('Funktioner');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('Tilføj');
    BSave.Caption := UTF8Decode('Gem');
    LAudioOut.Caption := UTF8Decode('Lydudlæsnings driver');
    CAudioOut.Items[0] := UTF8Decode('(Lad være med at afkode lyd)');
    CAudioOut.Items[1] := UTF8Decode('(Lad være med at afspille lyd)');
    LAudioDev.Caption := UTF8Decode('DirectSound udlæsnings apparat');
    LPostproc.Caption := UTF8Decode('Efterprocessering');
    CPostproc.Items[0] := UTF8Decode('Slået fra');
    CPostproc.Items[1] := UTF8Decode('Automatisk');
    CPostproc.Items[2] := UTF8Decode('Maksimal kvalitet');
    LOCstr_AutoLocale := UTF8Decode('(Vælg Automatisk)');
    CIndex.Caption := UTF8Decode('Genopbyg filindekset hvis det er nødvendigt');
    CSoftVol.Caption := UTF8Decode('Software lydstyrke kontrol / Forstærk lydstyrken');
    CPriorityBoost.Caption := UTF8Decode('Kør med højere prioritet');
    LParams.Caption := UTF8Decode('Flere MPlayer parametre:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Spilleliste');
    BPlay.Hint := UTF8Decode('Afspil');
    BAdd.Hint := UTF8Decode('Tilføj ...');
    BMoveUp.Hint := UTF8Decode('Flyt op');
    BMoveDown.Hint := UTF8Decode('Flyt ned');
    BDelete.Hint := UTF8Decode('Fjern');
    CShuffle.Hint := UTF8Decode('Bland');
    CLoop.Hint := UTF8Decode('Gentag');
    BSave.Hint := UTF8Decode('Gem ...');
  end;
  InfoForm.Caption := UTF8Decode('Klip information');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('Ingen klip information er tilgængelig i øjeblikket.');
  LOCstr_InfoFileFormat := UTF8Decode('Format');
  LOCstr_InfoPlaybackTime := UTF8Decode('Varighed');
  LOCstr_InfoTags := UTF8Decode('Klip Metadata');
  LOCstr_InfoVideo := UTF8Decode('Videospor');
  LOCstr_InfoAudio := UTF8Decode('Lydspor');
  LOCstr_InfoDecoder := UTF8Decode('Afkoder');
  LOCstr_InfoCodec := UTF8Decode('Codec');
  LOCstr_InfoBitrate := UTF8Decode('Bithastighed');
  LOCstr_InfoVideoSize := UTF8Decode('Dimensioner');
  LOCstr_InfoVideoFPS := UTF8Decode('Formhastighed');
  LOCstr_InfoVideoAspect := UTF8Decode('Aspekt Forhold');
  LOCstr_InfoAudioRate := UTF8Decode('Prøvehastighed');
  LOCstr_InfoAudioChannels := UTF8Decode('Kanaler');
end;

begin
  RegisterLocale(UTF8Decode('Dansk'), Activate, LANG_ENGLISH, ANSI_CHARSET);
end.
