{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Kristjan Schmidt <Kristjan@yandex.ru>
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
unit mo_eo;
interface
implementation
uses Windows,Locale,Main,Options,plist,Info;

procedure Activate;
begin
  with MainForm do begin
      LOCstr_Status_Opening:=UTF8Decode('malfermi ...');
      LOCstr_Status_Closing:=UTF8Decode('fermi ...');
      LOCstr_Status_Playing:=UTF8Decode('ludigo');
      LOCstr_Status_Paused:=UTF8Decode('haltigita');
      LOCstr_Status_Stopped:=UTF8Decode('rompita');
      LOCstr_Status_Error:=UTF8Decode('ludigo malsukcesis (klaku por pli da informoj)');
    BPlaylist.Hint:=UTF8Decode('ludigoliston montri/kaŝi');
    BStreamInfo.Hint:=UTF8Decode('Clip-informoj montri/kaŝi');
    BFullscreen.Hint:=UTF8Decode('tutekrano-moduson enŝalti/elŝalti');
    BCompact.Hint:=UTF8Decode('kompaktan vidaĵon enŝalti/elŝalti');
    MPCtrl.Caption:=UTF8Decode('montri direktilojn en la tutekrano-moduso');
    OSDMenu.Caption:=UTF8Decode('OSD-moduso');
      MNoOSD.Caption:=UTF8Decode('sen OSD');
      MDefaultOSD.Caption:=UTF8Decode('kutima OSD');
      MTimeOSD.Caption:=UTF8Decode('tempoindiko');
      MFullOSD.Caption:=UTF8Decode('tuttempoindiko');
    BMute.Hint:=UTF8Decode('mutigon enŝalti/elŝalti');
    MFile.Caption:=UTF8Decode('dosiero');
      MOpenFile.Caption:=UTF8Decode('ludi dosieron ...');
      MOpenURL.Caption:=UTF8Decode('ludi adreson ...');
        LOCstr_OpenURL_Caption:=UTF8Decode('ludi adreson');
        LOCstr_OpenURL_Prompt:=UTF8Decode('Kiun adreson ekludu?');
      MOpenDrive.Caption:=UTF8Decode('ludi (V)CD/DVD/BlueRay');
      MClose.Caption:=UTF8Decode('fermi');
      MQuit.Caption:=UTF8Decode('eliro');
    MView.Caption:=UTF8Decode('vidaĵo');
      MSizeAny.Caption:=UTF8Decode('ajna grandeco (');
      MSize50.Caption:=UTF8Decode('duona grandeco');
      MSize100.Caption:=UTF8Decode('ĝusta grandeco');
      MSize200.Caption:=UTF8Decode('duopla grandeco');
      MFullscreen.Caption:=UTF8Decode('tutekrano-moduso');
      MCompact.Caption:=UTF8Decode('kompakta vidaĵo');
      MOSD.Caption:=UTF8Decode('ŝanĝi OSDn');
      MOnTop.Caption:=UTF8Decode('ĉiam antaŭe');
    MSeek.Caption:=UTF8Decode('ludigo');
      MPlay.Caption:=UTF8Decode('ludi');
      MPause.Caption:=UTF8Decode('paŭzo');
      MPrev.Caption:=UTF8Decode('antaŭa titolo');
      MNext.Caption:=UTF8Decode('sekva titolo');
      MShowPlaylist.Caption:=UTF8Decode('ludigolisto ...');
      MMute.Caption:=UTF8Decode('muta');
      MSeekF10.Caption:=UTF8Decode('dek sekundoj antaŭen');
      MSeekR10.Caption:=UTF8Decode('dek sekundoj reen');
      MSeekF60.Caption:=UTF8Decode('unu minuto antaŭen');
      MSeekR60.Caption:=UTF8Decode('unu minuto reen');
      MSeekF600.Caption:=UTF8Decode('dek minutoj antaŭen');
      MSeekR600.Caption:=UTF8Decode('dek minutoj reen');
    MExtra.Caption:=UTF8Decode('aliaĵoj');
      MAudio.Caption:=UTF8Decode('sonoŝpuro');
      MSubtitle.Caption:=UTF8Decode('subtitoloŝpuro');
      MAspects.Caption:=UTF8Decode('rilato inter la flankoj');
        MAutoAspect.Caption:=UTF8Decode('aŭtomata');
        MForce43.Caption:=UTF8Decode('ĉiam 4:3');
        MForce169.Caption:=UTF8Decode('ĉiam 16:9');
        MForceCinemascope.Caption:=UTF8Decode('ĉiam 2.35:1');
      MDeinterlace.Caption:=UTF8Decode('Deinterlacing');
        MNoDeint.Caption:=UTF8Decode('elŝaltita');
        MSimpleDeint.Caption:=UTF8Decode('simpla');
        MAdaptiveDeint.Caption:=UTF8Decode('Adaptiv');
      MOptions.Caption:=UTF8Decode('kalibrigoj ...');
      MLanguage.Caption:=UTF8Decode('lingvo');
      MStreamInfo.Caption:=UTF8Decode('montri Clip-informojn ...');
      MShowOutput.Caption:=UTF8Decode('montri MPlayer-indikon ...');
      MHelp.Caption:=UTF8Decode('helpo');
        MKeyHelp.Caption:=UTF8Decode('klavarohelpo ...');
        MAbout.Caption:=UTF8Decode('pri ...');
  end;
  OptionsForm.BClose.Caption:=UTF8Decode('fermi');
  OptionsForm.HelpText.Text:=UTF8Decode(
'navigada klavoj:'^M^J+
'spacoklavo'^I'ludi/paŭzo'^M^J+
'dekstre'^I'dek sekundoj antaŭen'^M^J+
'maldekstres'^I'dek sekundoj reen'^M^J+
'supre'^I'unu minuto antaŭen'^M^J+
'sube'^I'unu minuto reen'^M^J+
'BildoSupren'^I'dek minutoj antauen'^M^J+
'BildSuben'^I'dek minutoj reen'^M^J+
^M^J+
'aliaj klavoj:'^M^J+
'O'^I'ŝanĝi OSD'^M^J+
'F'^I'tutekrano-moduson enŝalti/elŝalti'^M^J+
'C'^I'kompaktan vidaĵon enŝalti/elŝalti'^M^J+
'T'^I'ĉiam antaŭe enŝalti/elŝalti'^M^J+
'Q'^I'fermi tuj'^M^J+
'9/0'^I'reguli sonfortecon'^M^J+
'-/+'^I'reguli bildo/sono-sinkronigon'^M^J+
'1/2'^I'reguli helecon'^M^J+
'3/4'^I'reguli kontraston'^M^J+
'5/6'^I'reguli kolortonon'^M^J+
'7/8'^I'reguli saturitecon'
  );
  with OptionsForm do begin
    THelp.Caption:=MainForm.MHelp.Caption;
    TAbout.Caption:=UTF8Decode('pri');
    LVersionMPUI.Caption:=UTF8Decode('MPUI-hcb versio:');
    LVersionMPlayer.Caption:=UTF8Decode('MPlayer-versio:');
    Caption:=UTF8Decode('kalibrigoj');
    BOK.Caption:=UTF8Decode('okej');
    BApply.Caption:=UTF8Decode('akcepti');
    BSave.Caption:=UTF8Decode('konservi');
    LAudioOut.Caption:=UTF8Decode('sonoeligilo');
      CAudioOut.Items[0]:=UTF8Decode('(ne malkodadi sonon)');
      CAudioOut.Items[1]:=UTF8Decode('(ne eligi sonon)');
    LAudioDev.Caption:=UTF8Decode('DirectSound-eligilo');
    LPostproc.Caption:=UTF8Decode('Postprocessing');
      CPostproc.Items[0]:=UTF8Decode('elŝalti');
      CPostproc.Items[1]:=UTF8Decode('aŭtomata');
      CPostproc.Items[2]:=UTF8Decode('plej bona kvalito');
    LOCstr_AutoLocale:=UTF8Decode('(aŭtomata)');
    CIndex.Caption:=UTF8Decode('rekonstrui dosieran indekson, se estas necesa');
    CSoftVol.Caption:=UTF8Decode('softvara sonregulado (ebligas pli laŭta sono)');
    CPriorityBoost.Caption:=UTF8Decode('pli alta prioritato');
    LParams.Caption:=UTF8Decode('pliaj MPlayer-parametro:');
    LHelp.Caption:=THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption:=UTF8Decode('ludigolisto');
    BPlay.Hint:=UTF8Decode('ludi');
    BAdd.Hint:=UTF8Decode('aldoni ...');
    BMoveUp.Hint:=UTF8Decode('supren');
    BMoveDown.Hint:=UTF8Decode('suben');
    BDelete.Hint:=UTF8Decode('forigi');
  end;
  InfoForm.Caption:=UTF8Decode('Clip-informoj');
  InfoForm.BClose.Caption:=OptionsForm.BClose.Caption;
  LOCstr_NoInfo:=UTF8Decode('Ĉitempe informoj ne estas disponebla.');
  LOCstr_InfoFileFormat:=UTF8Decode('formato');
  LOCstr_InfoPlaybackTime:=UTF8Decode('ludodaŭro');
  LOCstr_InfoTags:=UTF8Decode('informdataoj');
  LOCstr_InfoVideo:=UTF8Decode('videoŝpuro');
  LOCstr_InfoAudio:=UTF8Decode('sonoŝpuro');
  LOCstr_InfoDecoder:=UTF8Decode('malkodadilo');
  LOCstr_InfoCodec:=UTF8Decode('Codec');
  LOCstr_InfoBitrate:=UTF8Decode('bitkvoto');
  LOCstr_InfoVideoSize:=UTF8Decode('bildograndeco');
  LOCstr_InfoVideoFPS:=UTF8Decode('framokvoto');
  LOCstr_InfoVideoAspect:=UTF8Decode('rilato inter la flankoj');
  LOCstr_InfoAudioRate:=UTF8Decode('Samplerate');
  LOCstr_InfoAudioChannels:=UTF8Decode('kanaloj');
end;

begin
  RegisterLocale(UTF8Decode('Esperanto'),Activate,$F00,TURKISH_CHARSET);
end.
