{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Michal Sindlar <sindlar@gmail.com>
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
unit mo_nl;
interface
implementation
uses Windows,Locale,Main,Options,plist,Info;

procedure Activate;
begin
  with MainForm do begin
      LOCstr_Status_Opening:=UTF8Decode('Openen ...');
      LOCstr_Status_Closing:=UTF8Decode('Sluiten ...');
      LOCstr_Status_Playing:=UTF8Decode('Speelt');
      LOCstr_Status_Paused:=UTF8Decode('Gepauseerd');
      LOCstr_Status_Stopped:=UTF8Decode('Gestopt');
      LOCstr_Status_Error:=UTF8Decode('Media niet afspeelbaar (Klik voor meer info)');
    BPlaylist.Hint:=UTF8Decode('Toon/verberg speellijst');
    BStreamInfo.Hint:=UTF8Decode('Toon/verberg media-informatie');
    BFullscreen.Hint:=UTF8Decode('Beeldvullend afspelen');
    BCompact.Hint:=UTF8Decode('Compacte modus');
    BMute.Hint:=UTF8Decode('Geluid aan/uit');
    MPCtrl.Caption:=UTF8Decode('Knoppen in beeldvullende modus');
    OSDMenu.Caption:=UTF8Decode('OSD (on-screen display) modus');
      MNoOSD.Caption:=UTF8Decode('Geen OSD');
      MDefaultOSD.Caption:=UTF8Decode('Standaard OSD');
      MTimeOSD.Caption:=UTF8Decode('Verstreken speeltijd');
      MFullOSD.Caption:=UTF8Decode('Totale speeltijd');
    MFile.Caption:=UTF8Decode('Bestand');
      MOpenFile.Caption:=UTF8Decode('Bestand laden ...');
      MOpenURL.Caption:=UTF8Decode('URL laden ...');
        LOCstr_OpenURL_Caption:=UTF8Decode('URL afspelen');
        LOCstr_OpenURL_Prompt:=UTF8Decode('Welke URL wenst u af te spelen?');
      MOpenDrive.Caption:=UTF8Decode('Laad (V)CD/DVD/BlueRay');
      MClose.Caption:=UTF8Decode('Media sluiten');
      MQuit.Caption:=UTF8Decode('Afsluiten');
    MView.Caption:=UTF8Decode('Beeld');
      MSizeAny.Caption:=UTF8Decode('Willekeurig formaat (');
      MSize50.Caption:=UTF8Decode('Half formaat');
      MSize100.Caption:=UTF8Decode('Origineel formaat');
      MSize200.Caption:=UTF8Decode('Dubbel formaat');
      MFullscreen.Caption:=UTF8Decode('Beeldvullend');
      MCompact.Caption:=UTF8Decode('Compacte modus');
      MOSD.Caption:=UTF8Decode('OSD-modus wijzigen');
      MOnTop.Caption:=UTF8Decode('Venster altijd zichtbaar');
    MSeek.Caption:=UTF8Decode('Afspelen');
      MPlay.Caption:=UTF8Decode('Afspelen');
      MPause.Caption:=UTF8Decode('Pause');
      MPrev.Caption:=UTF8Decode('Vorig item in speellijst');
      MNext.Caption:=UTF8Decode('Volgend item in speellijst');
      MShowPlaylist.Caption:=UTF8Decode('Speellijst ...');
      MMute.Caption:=UTF8Decode('Geluid aan/uit');
      MSeekF10.Caption:=UTF8Decode('10 seconden doorspoelen');
      MSeekR10.Caption:=UTF8Decode('10 seconden terugspoelen');
      MSeekF60.Caption:=UTF8Decode('1 minuut doorspoelen');
      MSeekR60.Caption:=UTF8Decode('1 minuut terugspoelen');
      MSeekF600.Caption:=UTF8Decode('10 minuten doorspoelen');
      MSeekR600.Caption:=UTF8Decode('10 minuten terugspoelen');
    MExtra.Caption:=UTF8Decode('Extra');
      MAudio.Caption:=UTF8Decode('Audiospoor');
      MSubtitle.Caption:=UTF8Decode('Ondertitelspoor');
      MAspects.Caption:=UTF8Decode('Verhouding');
        MAutoAspect.Caption:=UTF8Decode('Detecteren');
        MForce43.Caption:=UTF8Decode('4:3 forceren');
        MForce169.Caption:=UTF8Decode('16:9 forceren');
        MForceCinemascope.Caption:=UTF8Decode('2.35:1 Forceren');
      MDeinterlace.Caption:=UTF8Decode('Deinterlacing');
        MNoDeint.Caption:=UTF8Decode('Uit');
        MSimpleDeint.Caption:=UTF8Decode('Eenvoudig');
        MAdaptiveDeint.Caption:=UTF8Decode('Adaptief');
      MOptions.Caption:=UTF8Decode('Opties ...');
      MLanguage.Caption:=UTF8Decode('Taal');
      MStreamInfo.Caption:=UTF8Decode('Toon media-informatie ...');
      MShowOutput.Caption:=UTF8Decode('Toon MPlayer output ...');
      MHelp.Caption:=UTF8Decode('Help');
        MKeyHelp.Caption:=UTF8Decode('Toetsenbord help ...');
        MAbout.Caption:=UTF8Decode('Info ...');
  end;
  OptionsForm.BClose.Caption:='Sluiten';
  OptionsForm.HelpText.Text:=UTF8Decode(
'Navigatietoetsen:'^M^J+
'Spatie'^I'Afspelen/Pause'^M^J+
'Rechts'^I'10 seconden doorspoelen'^M^J+
'Links'^I'10 seconden terugspoelen'^M^J+
'Boven'^I'1 minuut doorspoelen'^M^J+
'Beneden'^I'1 minuut terugspoelen'^M^J+
'PgUp'^I'10 minuten doorspoelen'^M^J+
'PgDn'^I'10 minuten terugspoelen'^M^J+
^M^J+
'Overige toetsen:'^M^J+
'O'^I'OSD-modus wijzigen'^M^J+
'F'^I'Beeldvullend'^M^J+
'C'^I'Compact modus'^M^J+
'T'^I'Venster altijd zichtbaar'^M^J+
'Q'^I'Afsluiten'^M^J+
'9/0'^I'Volume aanpassen'^M^J+
'-/+'^I'Audio/video sync aanpassen'^M^J+
'1/2'^I'Helderheid aanpassen'^M^J+
'3/4'^I'Contrast aanpassen'^M^J+
'5/6'^I'Kleurbalans aanpassen'^M^J+
'7/8'^I'Kleurverzadiging aanpassen');

  with OptionsForm do begin
    THelp.Caption:=MainForm.MHelp.Caption;
    TAbout.Caption:=UTF8Decode('Over');
    LVersionMPUI.Caption:=UTF8Decode('MPUI-hcb versie:');
    LVersionMPlayer.Caption:=UTF8Decode('MPlayer core versie:');
    Caption:=UTF8Decode('Opties');
    BOK.Caption:=UTF8Decode('OK');
    BApply.Caption:=UTF8Decode('Toepassen');
    BSave.Caption:=UTF8Decode('Opslaan');
    LAudioOut.Caption:=UTF8Decode('Stuurprogramma voor geluid');
      CAudioOut.Items[0]:=UTF8Decode('(geluidsspoor niet decoderen)');
      CAudioOut.Items[1]:=UTF8Decode('(geluidsspoor niet afspelen)');
    LAudioDev.Caption:=UTF8Decode('DirectSound stuurprogramma');
    LPostproc.Caption:=UTF8Decode('Postprocessing');
      CPostproc.Items[0]:=UTF8Decode('Uit');
      CPostproc.Items[1]:=UTF8Decode('Automatisch');
      CPostproc.Items[2]:=UTF8Decode('Beste kwaliteit');
    LOCstr_AutoLocale:=UTF8Decode('(Automatisch)');
    CIndex.Caption:=UTF8Decode('Video-index hergenereren indien nodig');
    CSoftVol.Caption:=UTF8Decode('Softwarematige volumeregeling / Volume boost');
    CPriorityBoost.Caption:=UTF8Decode('Afspelen met hogere prioriteit');
    LParams.Caption:=UTF8Decode('Additionele MPlayer parameters:');
    LHelp.Caption:=THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption:=UTF8Decode('Speellijst');
    BPlay.Hint:=UTF8Decode('Afspelen');
    BAdd.Hint:=UTF8Decode('Toevoegen ...');
    BMoveUp.Hint:=UTF8Decode('Naar boven');
    BMoveDown.Hint:=UTF8Decode('Naar beneden');
    BDelete.Hint:=UTF8Decode('Verwijderen');
    CShuffle.Hint:=UTF8Decode('Shuffle');
    CLoop.Hint:=UTF8Decode('Herhalen');
    BSave.Hint:=UTF8Decode('Opslaan ...');
  end;
  InfoForm.Caption:=UTF8Decode('Media-informatie');
  InfoForm.BClose.Caption:=OptionsForm.BClose.Caption;
  LOCstr_NoInfo:=UTF8Decode('Momenteel geen media-informatie beschikbaar.');
  LOCstr_InfoFileFormat:=UTF8Decode('Bestandsformaat');
  LOCstr_InfoPlaybackTime:=UTF8Decode('Speelduur');
  LOCstr_InfoTags:=UTF8Decode('Metadata');
  LOCstr_InfoVideo:=UTF8Decode('Videospoor');
  LOCstr_InfoAudio:=UTF8Decode('Audiospoor');
  LOCstr_InfoDecoder:=UTF8Decode('Decoder');
  LOCstr_InfoCodec:=UTF8Decode('Codec');
  LOCstr_InfoBitrate:=UTF8Decode('Bitrate');
  LOCstr_InfoVideoSize:=UTF8Decode('Afmetingen');
  LOCstr_InfoVideoFPS:=UTF8Decode('Beelden per seconde');
  LOCstr_InfoVideoAspect:=UTF8Decode('Verhoudingen');
  LOCstr_InfoAudioRate:=UTF8Decode('Samplerate');
  LOCstr_InfoAudioChannels:=UTF8Decode('Kanalen');
end;

begin
  RegisterLocale(UTF8Decode('Nederlands (Dutch)') ,Activate, LANG_DUTCH, ANSI_CHARSET);
end.
