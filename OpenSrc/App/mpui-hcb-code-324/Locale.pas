{   MPUI-hcb, an MPlayer frontend for Windows
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
unit Locale;
interface
uses Graphics, SysUtils, TntForms, TntSysUtils;

type proc = procedure;
  TLocale = record
    Name: WideString;
    Func: proc;
    LangID: integer;
    Charset: TFontCharset;
  end;
var Locales: array of TLocale;

var LOCstr_Title: WideString;
  LOCstr_OpenURL_Caption: WideString;
  LOCstr_OpenURL_Prompt: WideString;
  LOCstr_SetPW_Caption: WideString;
  LOCstr_VolAsk_Caption: WideString;
  LOCstr_Check_Mplayer_Prompt: WideString;
  LOCstr_Error1_Prompt: WideString;
  LOCstr_Error2_Prompt: WideString;
  LOCstr_CmdLine_Prompt: WideString;
  LOCstr_AutoLocale: WideString;
  LOCstr_Status_Opening: WideString;
  LOCstr_Status_Closing: WideString;
  LOCstr_Status_Playing: WideString;
  LOCstr_Status_Paused: WideString;
  LOCstr_Status_Stopped: WideString;
  LOCstr_Status_Error: WideString;
  FontTitle: WideString;
  OSD_Volume_Prompt: string;
  OSD_ScreenShot_Prompt: string;
  OSD_Contrast_Prompt: string;
  OSD_Brightness_Prompt: string;
  OSD_Hue_Prompt: string;
  OSD_Saturation_Prompt: string;
  OSD_Gamma_Prompt: string;
  OSD_Enable_Prompt: string;
  OSD_Disable_Prompt: string;
  OSD_VideoTrack_Prompt: string;
  OSD_AudioTrack_Prompt: string;
  OSD_OnTop0_Prompt: string;
  OSD_OnTop1_Prompt: string;
  OSD_OnTop2_Prompt: string;
  OSD_Auto_Prompt: string;
  OSD_Custom_Prompt: string;
  OSD_Size_Prompt: string;
  OSD_Scale_Prompt: string;
  OSD_Balance_Prompt: string;
  OSD_Reset_Prompt: string;
  OSD_AudioDelay_Prompt: string;
  OSD_SubDelay_Prompt: string;
  OSD_DownSubtitle_Prompt: string;
  SubFilter: WideString;
  MediaFilter: WideString;
  AudioFilter: WideString;
  AnyFilter: WideString;
  FontFilter: WideString;
  LyricFilter: WideString;
  IKeyHint, IKeyerror,IKeyerror1: WideString;

var LOCstr_NoInfo: WideString;
  LOCstr_InfoFileName: WideString;
  LOCstr_InfoFileFormat: WideString;
  LOCstr_InfoPlaybackTime: WideString;
  LOCstr_InfoTags: WideString;
  LOCstr_InfoVideo: WideString;
  LOCstr_InfoAudio: WideString;
  LOCstr_InfoDecoder: WideString;
  LOCstr_InfoCodec: WideString;
  LOCstr_InfoBitrate: WideString;
  LOCstr_InfoVideoSize: WideString;
  LOCstr_InfoVideoFPS: WideString;
  LOCstr_InfoVideoAspect: WideString;
  LOCstr_InfoAudioRate: WideString;
  LOCstr_InfoAudioChannels: WideString;

const NoLocale = -1;
  AutoLocale = -1;

procedure RegisterLocale(const _Name: WideString; const _Func: proc; _LangID: integer; _Charset: TFontCharset);
procedure ActivateLocale(Index: integer);

implementation
uses Windows, Forms, Main, Options, plist, Info, Core, Equalizer;

procedure RegisterLocale(const _Name: WideString; const _Func: proc; _LangID: integer; _Charset: TFontCharset);
begin
  SetLength(Locales, length(Locales) + 1);
  with Locales[High(Locales)] do begin
    Name := _Name;
    Func := _Func;
    LangID := _LangID;
    Charset := _Charset;
  end;
end;

procedure ActivateLocale(Index: integer);
var i, j, WantedLangID: integer;
begin
  if Index = AutoLocale then begin
    WantedLangID := GetUserDefaultLangID;
    if Byte(WantedLangID) = LANG_CHINESE then begin
      if (WantedLangID = $804) or (WantedLangID = $1004) then
        WantedLangID := $804
      else
        WantedLangID := $404;
    end
    else WantedLangID := Byte(WantedLangID);
    Index := 0;
    for i := Low(Locales) to High(Locales) do
      if Locales[i].LangID = WantedLangID then begin
        Index := i;
        break;
      end;
  end;
  if (Index < Low(Locales)) or (Index > High(Locales)) then exit;
  case Locales[Index].LangID of
    $804, $404: begin
        if not Win32PlatformIsUnicode then begin
          MainForm.Font.Size := 9; OptionsForm.Font.Size := 9;
          PlaylistForm.Font.Size := 9; InfoForm.Font.Size := 9;
          OptionsForm.Font.Size := 9;
        end;
        DTFormat := 'dddddd@tt';
      end;
  else begin
      if not Win32PlatformIsUnicode then begin
        MainForm.Font.Size := 8; OptionsForm.Font.Size := 8;
        PlaylistForm.Font.Size := 8; InfoForm.Font.Size := 8;
        OptionsForm.Font.Size := 8;
      end;
      DTFormat := 'ddddd@tt';
    end;
  end;

  MainForm.Font.Charset := Locales[Index].Charset;
  OptionsForm.Font.Charset := Locales[Index].Charset;
  PlaylistForm.Font.Charset := Locales[Index].Charset;
  InfoForm.Font.Charset := Locales[Index].Charset;
  EqualizerForm.Font.Charset := Locales[Index].Charset;

  OptionsForm.LHelp.Font.Charset := Locales[Index].Charset;
  OptionsForm.LVersionMPUI.Font.Charset := Locales[Index].Charset;
  OptionsForm.LVersionMPlayer.Font.Charset := Locales[Index].Charset;

  CurrentLocale := Index;
  MainForm.MLanguage.Items[CurrentLocale].Checked := true;
  Locales[Index].Func;
  OptionsForm.Localize;
  InfoForm.UpdateInfo(true);
  MainForm.Localize;
  case Status of
    sNone: MainForm.LStatus.Caption := '';
    sOpening: MainForm.LStatus.Caption := LOCstr_Status_Opening;
    sClosing: MainForm.LStatus.Caption := LOCstr_Status_Closing;
    sPlaying: MainForm.LStatus.Caption := LOCstr_Status_Playing;
    sPaused: MainForm.LStatus.Caption := LOCstr_Status_Paused;
    sStopped: MainForm.LStatus.Caption := LOCstr_Status_Stopped;
    sError: MainForm.LStatus.Caption := LOCstr_Status_Error;
  end;
  for i := 3 to MainForm.MDVDT.Count - 1 do begin
    for j := 0 to MainForm.MDVDT.Items[i].Count - 1 do begin
      case MainForm.MDVDT.Items[i].Items[j].Tag of
        0: MainForm.MDVDT.Items[i].Items[j].Caption := Ccap;
        1: MainForm.MDVDT.Items[i].Items[j].Caption := Acap;
      end;
    end;
  end;
  for i := 0 to MainForm.MBRT.Count - 1 do begin
    for j := 0 to MainForm.MBRT.Items[i].Count - 1 do begin
      case MainForm.MBRT.Items[i].Items[j].Tag of
        0: MainForm.MBRT.Items[i].Items[j].Caption := Ccap;
        1: MainForm.MBRT.Items[i].Items[j].Caption := Acap;
      end;
    end;
  end;
  TntApplication.Title := LOCstr_Title;
  MainForm.UpdateCaption;
end;

begin
  SetLength(Locales, 0);
  CurrentLocale := NoLocale;
  LOCstr_Title := 'MPUI-hcb';
  LOCstr_OpenURL_Caption := 'URL';
  LOCstr_OpenURL_Prompt := 'URL?';
  LOCstr_AutoLocale := 'auto';
  LOCstr_Status_Opening := 'OPENING';
  LOCstr_Status_Closing := 'CLOSING';
  LOCstr_Status_Playing := 'PLAYING';
  LOCstr_Status_Paused := 'PAUSED';
  LOCstr_Status_Stopped := 'STOPPED';
  LOCstr_NoInfo := 'NO_INFO';
  LOCstr_InfoFileFormat := 'FILE_FORMAT';
  LOCstr_InfoPlaybackTime := 'LENGTH';
  LOCstr_InfoTags := 'TAGS';
  LOCstr_InfoVideo := 'VIDEO';
  LOCstr_InfoAudio := 'AUDIO';
  LOCstr_InfoDecoder := 'DECODER';
  LOCstr_InfoCodec := 'CODEC';
  LOCstr_InfoBitrate := 'BITRATE';
  LOCstr_InfoVideoSize := 'SIZE';
  LOCstr_InfoVideoFPS := 'FPS';
  LOCstr_InfoVideoAspect := 'ASPECT';
  LOCstr_InfoAudioRate := 'RATE';
  LOCstr_InfoAudioChannels := 'NCH';
  LOCstr_Status_Error := 'Unable to play media (Click for more info)';
  LOCstr_SetPW_Caption := 'Please input a password to decrypt the following Archive';
  LOCstr_VolAsk_Caption := 'Please select last volume';
  LOCstr_Check_Mplayer_Prompt := 'Please check MPlayer.exe location.';
  LOCstr_Error1_Prompt := 'Error ';
  LOCstr_Error2_Prompt := ' while starting MPlayer:';
  LOCstr_CmdLine_Prompt := 'command line:';
  OSD_Volume_Prompt := 'Volume';
  OSD_ScreenShot_Prompt := 'ScreenShot';
  OSD_Contrast_Prompt := 'Contrast';
  OSD_Brightness_Prompt := 'Brightness';
  OSD_Hue_Prompt := 'Hue';
  OSD_Saturation_Prompt := 'Saturation';
  OSD_Gamma_Prompt := 'Gamma';
  OSD_Enable_Prompt := 'Enable';
  OSD_Disable_Prompt := 'Disable';
  OSD_VideoTrack_Prompt := 'Video Track';
  OSD_AudioTrack_Prompt := 'Audio Track';
  OSD_OnTop0_Prompt := 'Nerve On Top';
  OSD_OnTop1_Prompt := 'Always On Top';
  OSD_OnTop2_Prompt := 'While Playing On Top';
  OSD_Auto_Prompt := 'Auto';
  OSD_Custom_Prompt := 'Custom';
  OSD_Size_Prompt := 'Size';
  OSD_Scale_Prompt := 'Scale';
  OSD_Balance_Prompt := 'Balance';
  OSD_Reset_Prompt := 'Reset';
  OSD_AudioDelay_Prompt := 'Audio Delay';
  OSD_SubDelay_Prompt := 'Subtitle Delay';
  OSD_DownSubtitle_Prompt := 'Download Subtitle';
  IKeyHint := 'Please press hotkey';
  IKeyerror := ' ,Shortcut already exists';
  FontTitle := 'OSD font ...';
end.
