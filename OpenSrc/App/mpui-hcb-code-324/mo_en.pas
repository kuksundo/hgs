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
unit mo_en;
interface
implementation
uses SysUtils, Windows, Locale, Main, Options, plist, Info, Core, Equalizer, DLyric, OpenDevice;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := 'Opening ...';
    LOCstr_Status_Closing := 'Closing ...';
    LOCstr_Status_Playing := 'Playing';
    LOCstr_Status_Paused := 'Pause/Frame step';
    LOCstr_Status_Stopped := 'Stopped';
    LOCstr_Status_Error := 'Unable to play media (Click for more info)';
    LOCstr_SetPW_Caption := 'Please enter password of following Archive';
    LOCstr_VolAsk_Caption := 'Please select last volume';
    LOCstr_Check_Mplayer_Prompt := 'Please check MPlayer.exe location.';
    LOCstr_Error1_Prompt := 'Error ';
    LOCstr_Error2_Prompt := ' while starting MPlayer:';
    LOCstr_CmdLine_Prompt := 'command line:';
    OSD_Volume_Prompt := 'Volume';
    OSD_ScreenShot_Prompt := 'ScreenShot ';
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
    OSD_DownSubtitle_Prompt := 'Download Subtitle...';
    SubFilter := 'Subtitle Files';
    AudioFilter := 'Audio File';
    AnyFilter := 'Any File';
    FontFilter := 'TrueType Font';
    MediaFilter := 'Media Files';
    LyricFilter := 'Lyric File';
    BPause.Hint := LOCstr_Status_Paused;
    BOpen.Hint := 'Play file';
    BPlaylist.Hint := 'Show/hide playlist window';
    BStreamInfo.Hint := 'Show/hide clip information';
    BFullscreen.Hint := 'Toggle fullscreen mode';
    BCompact.Hint := 'Toggle compact mode';
    BMute.Hint := 'Toggle Mute';
    BSkip.Hint := 'Toggle Skip Intro Ending';
    SeekBarSlider.Hint := 'MMB/RMB Set Intro,Ending';
    MPCtrl.Caption := 'Show/hide Controls';
    OSDMenu.Caption := 'OSD mode';
    MNoOSD.Caption := 'No OSD';
    MDefaultOSD.Caption := 'Default OSD';
    MTimeOSD.Caption := 'Show time';
    MFullOSD.Caption := 'Show total time';
    MFile.Caption := 'File';
    MOpenFile.Caption := 'Play file ...';
    MOpenDir.Caption := 'Open Directory ...';
    MOpenURL.Caption := 'Play URL ...';
    LOCstr_OpenURL_Caption := 'Play URL';
    LOCstr_OpenURL_Prompt := 'Which URL do you want to play?';
    MOpenDrive.Caption := 'Play (V)CD/DVD/BlueRay disk';
    MOpenDevices.Caption := 'Open Devices';
    MRFile.Caption := 'Recent files';
    MFClear.Caption := 'Clear list';
    MLoadLyric.Caption := 'Load Lyric File...';
    MDownloadLyric.Caption := 'Download Lyric...';
    MLoadSub.Caption := 'Load Subtitle...';
    FontTitle := 'OSD Font...';
    MSubfont.Caption := 'Subtitle Font...';
    MClose.Caption := 'Close';
    MQuit.Caption := 'Quit';
    MView.Caption := 'View';
    MSizeAny.Caption := 'Custom size (';
    MSCS.Caption := 'Set custom size';
    MSize50.Caption := 'Half size';
    MSize100.Caption := 'Original size';
    MSize200.Caption := 'Double size';
    MFullscreen.Caption := 'Fullscreen';
    MCompact.Caption := 'Compact mode';
    MMaxW.Caption := 'Maximize Windows';
    MOnTop.Caption := 'On Top';
    MNoOnTop.Caption := 'Never On Top';
    MAOnTop.Caption := 'Always on top';
    MWOnTop.Caption := 'While Playing On Top';
    MKaspect.Caption := 'Keep movie aspect';
    MExpand.Caption := 'Expand with black bands';
    MNoExpand.Caption := 'Off';
    MSrtExpand.Caption := 'Srt';
    MSubExpand.Caption := 'Sub';
    Hide_menu.Caption := 'AutoHide MainMenu';
    Mctrl.Caption := 'AutoHide ControlPanel';
    MTM.Caption := 'Toggle Monitor';
    MSeek.Caption := 'Play';
    MPlay.Caption := MSeek.Caption;
    MPause.Caption := LOCstr_Status_Paused;
    MStop.Caption := 'Stop';
    MPrev.Caption := 'Previous title';
    MNext.Caption := 'Next title';
    MShowPlaylist.Caption := 'Playlist ...';
    MSpeed.Caption := 'Play Speed';
    MN4X.Caption := '1/4X';
    MN2X.Caption := '1/2X';
    M1X.Caption := '1X';
    M2X.Caption := '2X';
    M4X.Caption := '4X';
    MAudiochannels.Caption := 'Channel';
    MStereo.Caption := 'Stereo';
    MLchannels.Caption := 'Left channels';
    MRchannels.Caption := 'Right channels';
    MMute.Caption := 'Mute';
    MWheelControl.Caption := 'Mouse wheel control';
    MVol.Caption := OSD_Volume_Prompt;
    MSize.Caption := OSD_Size_Prompt;
    MSkip.Caption := 'Skip Intro Ending';
    MIntro.Caption := 'BeginPoint ';
    MEnd.Caption := 'EndPoint ';
    MSIE.Caption := MSkip.Caption;
    MSeekF10.Caption := 'Forward 10 seconds';
    MSeekR10.Caption := 'Rewind 10 seconds';
    MSeekF60.Caption := 'Forward 1 minute';
    MSeekR60.Caption := 'Rewind 1 minute ';
    MSeekF600.Caption := 'Forward 10 minutes';
    MSeekR600.Caption := 'Rewind 10 minutes';
    MExtra.Caption := 'Tools';
    MAudio.Caption := OSD_AudioTrack_Prompt;
    MSubtitle.Caption := 'Subtitle track';
    MShowSub.Caption := 'Show/Hide Subtitles';
    MVideo.Caption := OSD_VideoTrack_Prompt;
    MDVDT.Caption := 'DVD Titles';
    MBRT.Caption := 'BluRay Titles';
    MRmMenu.Caption := 'Return to main menu';
    MRnMenu.Caption := 'Return to nearest menu';
    MVCDT.Caption := 'VCD Tracks';
    MCDT.Caption := 'CD Tracks';
    MAspects.Caption := 'Aspect ratio';
    MAutoAspect.Caption := 'Autodetect';
    MForce43.Caption := 'Force 4:3';
    MForce169.Caption := 'Force 16:9';
    MForceCinemascope.Caption := 'Force 2.35:1';
    MForce155.Caption := 'Force 14:9';
    MForce54.Caption := 'Force 5:4';
    MForce85.Caption := 'Force 16:10';
    MForce221.Caption := 'Force 2.21:1';
    MForce11.Caption := 'Force 1:1';
    MForce122.Caption := 'Force 1.22:1';
    MCustomAspect.Caption := 'Custom ';
    MDeinterlace.Caption := 'Deinterlace';
    MNoDeint.Caption := 'Off';
    MSimpleDeint.Caption := 'Simple';
    MAdaptiveDeint.Caption := 'Adaptive';
    MEqualizer.Caption := 'Video Equalizer';
    MOptions.Caption := 'Options ...';
    MLanguage.Caption := 'Language';
    MUUni.Caption := 'Use Unicode for output info';
    MStreamInfo.Caption := 'Show clip information ...';
    MShowOutput.Caption := 'Show MPlayer output ...';
    MVideos.Caption := 'Video';
    MAudios.Caption := 'Audio';
    MSub.Caption := 'Subtitles';
    M2ch.Caption := 'Default';
    M4ch.Caption := '4.0 surround';
    M6ch.Caption := 'Full 5.1';
    M8ch.Caption := 'Full 7.1';
    MShot.Caption := OSD_ScreenShot_Prompt;
    MLoadAudio.Caption := 'Load external Audio';
    MUloadAudio.Caption := 'Unload external Audio';
    MRotate0.Caption := '0';
    MRotate9.Caption := '+90';
    MRotateN9.Caption := '-90';
    MScale.Caption := OSD_Scale_Prompt + ' image';
    MScale0.Caption := OSD_Reset_Prompt + ' ' + OSD_Scale_Prompt;
    MScale1.Caption := 'Zoom +';
    MScale2.Caption := 'Zoom -';
    MPan.Caption := OSD_Reset_Prompt + ' ' + OSD_Balance_Prompt;
    MPan0.Caption := OSD_Balance_Prompt + ' +';
    MPan1.Caption := OSD_Balance_Prompt + ' -';
    Mdownloadsubtitle.Caption := OSD_DownSubtitle_Prompt;
    MSubStep.Caption := 'Subtitle Step';
    MSubStep0.Caption := 'Step backward';
    MSubStep1.Caption := 'Step forward';
    SCodepage.Caption := 'Subtitle CodePage';
    more1.Caption := 'More';
    MAudioDelay.Caption := OSD_AudioDelay_Prompt;
    MAudioDelay0.Caption := 'Delay +';
    MAudioDelay1.Caption := 'Delay -';
    MAudioDelay2.Caption := OSD_Reset_Prompt + ' ' + OSD_AudioDelay_Prompt;
    MSubDelay.Caption := OSD_SubDelay_Prompt;
    MSubDelay0.Caption := MAudioDelay0.Caption;
    MSubDelay1.Caption := MAudioDelay1.Caption;
    MSubDelay2.Caption := OSD_Reset_Prompt + ' ' + OSD_SubDelay_Prompt;
    MSubScale.Caption := MSub.Caption + ' ' + UTF8Decode(OSD_Scale_Prompt);
    MSubScale0.Caption := MScale1.Caption;
    MSubScale1.Caption := MScale2.Caption;
    MSubScale2.Caption := UTF8Decode(OSD_Reset_Prompt) + ' ' + MSubScale.Caption;
    MHelp.Caption := 'Help';
    MKeyHelp.Caption := 'Keyboard help ...';
    MAbout.Caption := 'About ...';
  end;
  with OptionsForm do begin
    BClose.Caption := 'Close';
    ads.Caption := 'Auto download subtitle as playing a video';
    HelpText.Text := UTF8Decode(
      'DblClick'^I'Toggle fullscreen'^M^J +
      'LMB click StatusBar Timer'^I'Toggle Time'^M^J +
      'MMB'^I'Toggle Wheel function'^M^J +
      'Ctrl+LMB or RMB drag subtitle '^I'Scale subtitle'^M^J +
      'Ctrl+Wheel, Wheel+RMB or RMB drag '^I'Seek'^M^J +
      'LMB click video'^I'Play/Pause'^M^J +
      'M/RMB click SeekBar Slider'^I'Set Intro/Ending'^M^J +
      'LMB drag video'^I'Adjust window position'^M^J +
      'LMB drag subtitle'^I'Adjust subtitle position'^M^J +
      'Ctrl+LMB or LMB+RMB drag video,'^I'Adjust aspect ratio'^M^J +
      'Shift+LMB or MMB drag video'^I'Scale video'^M^J^M^J +
      'If "MPUI.ini" exist in MPUI folder, MPUI will firstly read or save setting to this file.'^M^J +
      'If open a folder contained ''VIDEO_TS'', ''MPEGAV'',''MPEG2'' or ''BDMV'' folder, MPUI will try to'^M^J +
      'play this folder with DVD, VCD, SVCD or BluRay mode.');

    Cconfig.Caption := 'Show config window while play';
    Cconfig.Hint := 'Check it or add ":cfg=1" to path of Winamp plugin, to open config window as play';
    Esubfont.Hint := 'please input font name, font''s file name of font in system font folder,'^M^J +
      'or font''s whole path';
    Csubfont.Hint := Esubfont.Hint;
    Cosdfont.Hint := Esubfont.Hint;
    Eosdfont.Hint := Esubfont.Hint;
    CLS.Caption := 'Popup "Download Lyric/Subtitle" dialog';
    CLS.Hint := 'When mpui don''t find suitable lyric/subtitle, popup "DownLoad Lyric/Subtitle" dialog';
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := 'About';
    LVersionMPUI.Caption := 'MPUI-hcb version:';
    LVersionMPlayer.Caption := 'MPlayer core version:';
    FY.Caption := 'Author:';
    Caption := 'Options';
    BOK.Caption := 'OK';
    BApply.Caption := 'Apply';
    BSave.Caption := 'Save';
    TSystem.Caption := 'System';
    TVideo.Caption := 'Video';
    TAudio.Caption := 'Audio';
    TSub.Caption := 'Subtitle';
    CSP.Caption := 'Click video to pause';
    CRS.Caption := 'start MPUI with last size';
    CTime.Caption := 'Display OS time in status bar';
    CRP.Caption := 'start MPUI with last postion';
    LAudioOut.Caption := 'Sound output driver';
    CAudioOut.Items[0] := '(don''t decode sound)';
    CAudioOut.Items[1] := '(don''t play sound)';
    LAudioDev.Caption := 'DirectSound output device';
    LPostproc.Caption := 'Postprocessing';
    CPostproc.Items[0] := 'Off';
    CPostproc.Items[1] := 'Automatic';
    CPostproc.Items[2] := 'Maximum quality';
    LOCstr_AutoLocale := '(Auto-select)';
    CIndex.Caption := 'Rebuild file index if necessary';
    CIndex.Hint := 'Useful with broken/incomplete downloads,'^M^J +
      'or badly created files';
    CNi.Caption := 'Use non-interleaved AVI parser';
    CNi.Hint := 'Fixes playback of some bad AVI files';
    Cone.Caption := 'Use only one instance of MPUI';
    CDnav.Caption := 'Use DVD menu';
    CDnav.Hint := 'if Mplayer is compiled with DVDnav lib, you can use'^M^J +
      'mouse to handle DVD menu on screen';
    CNobps.Caption := 'Don''t use avg b/s for A-V sync';
    CNobps.Hint := 'Don''t use average byte/second value for A-V sync.'^M^J +
      'Helps with some AVI files with broken header';
    CFilter.Caption := 'Filter DropFiles';
    CFilter.Hint := 'When to load files by drop, only load'^M^J +
      'files supported by Mplayer.';
    CFlip.Caption := 'Flip image';
    CMir.Caption := 'Mirrors image';
    CGUI.Caption := 'Use GUI of Mplayer';
    CGUI.Hint := 'Avoid GMplayer to use GUI of itself. For mplayer without ''-nogui'','^M^J +
      'you can cancel this checkbox to ensure mplayer can be runed';
    SSF.Caption := 'ScreenShot Folder';
    CSoftVol.Caption := 'Software volume boost';
    CDr.Caption := 'Direct rendering';
    CDr.Hint := 'Turns on direct rendering (not supported by'^M^J +
      'all codecs and video outputs)';
    double.Caption := 'double buffer';
    double.Hint := 'Double buffering fixes OSD flicker by '^M^J +
      'storing two frames in memory';
    CVolnorm.Caption := 'Normalize volume';
    CVolnorm.Hint := 'Maximizes the volume without distorting the sound';
    nMsgM.Caption := 'Use nomsgmodule option';
    nMsgM.Hint := 'Don''t prepend module name in front of each console message';
    nFconf.Caption := 'Use nofontconfig option';
    nFconf.Hint := 'For mplayer without ''-nofontconfig'' option, you can'^M^J +
      'uncheck this box to ensure mplayer can be runed';
    CRFScr.Caption := 'Click MBR to FullScreen';
    CRFScr.Hint := 'Click Right button of Mouse to FullScreen.';
    CSPDIF.Caption := 'Passthrough S/PDIF';
    LCh.Caption := 'Stereo Mode';
    LRot.Caption := 'Rotate image';
    SSubcode.Caption := 'Subtitle encoding';
    SSubfont.Caption := 'Subtitle Font';
    SOsdfont.Caption := 'Osd Font';
    SOsdfont.Hint := 'Use OSDfont for recent Mplayer version';
    RMplayer.Caption := 'Mplayer location';
    RCMplayer.Caption := 'In the same directory as MPUI';
    CWid.Caption := 'Use WID';
    LMAspect.Caption := 'Monitor Aspect ratio';
    LVideoOut.Caption := 'Video output driver';
    CEq2.Caption := 'Use Software video Equalizer';
    CEq2.Hint := 'for cards/drivers that do not support brightness'^M^J +
      ' and contrast controls in hardware';
    CVSync.Caption := 'vsync';
    CVSync.Hint := 'Useful for video laniated';
    CYuy2.Caption := 'YUY2 colorspace';
    CYuy2.Hint := 'Useful for video cards/drivers with '^M^J +
      'slow YV12 but fast YUY2 support';
    CUni.Caption := 'Handle subtitle as unicode';
    CUtf.Caption := 'Handle subtitle as UTF-8';
    SFol.Caption := 'Font outline thickness';
    SFsize.Caption := 'Subtitle text scale';
    SFB.Caption := 'Font blur radius';
    CWadsp.Caption := 'Use Winamp DSP plugins';
    Clavf.Caption := 'Use lavf Demuxer';
    Clavf.Hint := 'For unplayable files, try this option, TimeCode may be wrong.';
    CFd.Caption := 'Enable framedrop';
    CFd.Hint := 'Skip displaying some frames to maintain '^M^J +
      'A/V sync on slow systems';
    CAsync.Caption := 'Autosync';
    CAsync.Hint := 'Gradually adjusts the A/V sync based '^M^J +
      'on audio delay measurements';
    CCache.Caption := 'Cache';
    CCache.Hint := 'Specifies how much memory (in kBytes) to use when precaching'^M^J +
      'a file or URL. Especially useful on slow media';
    CPriorityBoost.Caption := 'Priority boost';
    SFontColor.Caption := 'Text Color';
    SOutline.Caption := 'Outline Color';
    CISub.Caption := 'Include Subtitles on Screenshot';
    CEfont.Caption := 'Use embedded fonts';
    CEfont.Hint := 'Enables extraction of Matroska embedded fonts.These fonts'^M^J +
      'can be used for SSA/ASS subtitle rendering';
    CAss.Caption := 'Use libass for SubRender';
    CAss.Hint := 'Turn on SSA/ASS subtitle rendering. With this option, libass will'^M^J +
      'be used for SSA/ASS external subtitles and Matroska tracks';
    LParams.Caption := 'Additional MPlayer parameters:';
    LHelp.Caption := THelp.Caption;
    SLyric.Caption := 'Lyric folder';
    TLyric.Caption := 'Lyric';
    TLog.Caption := 'Log';
    Ldlod.Caption := 'Display lyric on desktop';
    LTCL.Caption := 'Text Color';
    LBCL.Caption := 'Background';
    LHCL.Caption := 'Hightlight';
    TBa.Caption := 'Select All';
    TBn.Caption := 'None';
    TFadd.Caption := 'Add';
    TFdel.Caption := 'Delete';
    TFSet.Caption := 'Associate';
    TOther.Caption := 'Other';
    CDs.Caption := 'Always show video interface';
    RHK.Caption := 'Reset HotKey';
    HK.Columns[0].Caption := 'HotKey';
    HK.Columns[1].Caption := 'Action';
    TUnit.Caption := 'seconds/seek';
    CAV.Caption := 'libavcodec decoding threads';
    TseekL.Caption := 'Jump';
    CAddsFiles.Caption := 'Add sequence files';
    HK.Hint := 'Press hotKey to search related entry.'^M^J +
      'Double clik entry to modify hotKey.';
    HK.Items[0].SubItems.Strings[0] := 'Increase height of video';
    HK.Items[1].SubItems.Strings[0] := 'Decrease height of video';
    HK.Items[2].SubItems.Strings[0] := 'Decrease width of video';
    HK.Items[3].SubItems.Strings[0] := 'Increase width of video';
    HK.Items[4].SubItems.Strings[0] := 'Zoom in subtitle';
    HK.Items[5].SubItems.Strings[0] := 'Zoom out subtitle';
    HK.Items[6].SubItems.Strings[0] := 'Custom size';
    HK.Items[7].SubItems.Strings[0] := MainForm.MSize50.Caption;
    HK.Items[8].SubItems.Strings[0] := MainForm.MSize100.Caption;
    HK.Items[9].SubItems.Strings[0] := MainForm.MSize200.Caption;
    HK.Items[10].SubItems.Strings[0] := 'Next angle';
    HK.Items[11].SubItems.Strings[0] := MainForm.MEqualizer.Caption;
    HK.Items[12].SubItems.Strings[0] := 'Reset scale';
    HK.Items[13].SubItems.Strings[0] := 'Start/stop screenshot eachframe';
    HK.Items[14].SubItems.Strings[0] := MainForm.MSubDelay2.Caption;
    HK.Items[15].SubItems.Strings[0] := 'Decrease audio delay';
    HK.Items[16].SubItems.Strings[0] := 'Increase audio delay';
    HK.Items[17].SubItems.Strings[0] := 'Toggle OSD';
    HK.Items[18].SubItems.Strings[0] := 'Reset video equalizer';
    HK.Items[19].SubItems.Strings[0] := 'Toggle deinterlace(if use adaptive mode)';
    HK.Items[20].SubItems.Strings[0] := 'Zoom in video';
    HK.Items[21].SubItems.Strings[0] := 'Zoom out video';
    HK.Items[22].SubItems.Strings[0] := 'Decrease contrast';
    HK.Items[23].SubItems.Strings[0] := 'Increase contrast';
    HK.Items[24].SubItems.Strings[0] := 'Decrease brightness';
    HK.Items[25].SubItems.Strings[0] := 'Increase brightness';
    HK.Items[26].SubItems.Strings[0] := 'Decrease hue';
    HK.Items[27].SubItems.Strings[0] := 'Increase hue';
    HK.Items[28].SubItems.Strings[0] := 'Decrease saturation';
    HK.Items[29].SubItems.Strings[0] := 'Increase saturation';
    HK.Items[30].SubItems.Strings[0] := 'Decrease volume';
    HK.Items[31].SubItems.Strings[0] := 'Increase volume';
    HK.Items[32].SubItems.Strings[0] := 'Decrease gamma';
    HK.Items[33].SubItems.Strings[0] := 'Increase gamma';
    HK.Items[34].SubItems.Strings[0] := 'Drop frame';
    HK.Items[35].SubItems.Strings[0] := MainForm.BFullscreen.Hint;
    HK.Items[36].SubItems.Strings[0] := 'Toggle subtitle alignment';
    HK.Items[37].SubItems.Strings[0] := 'Move up subtitle';
    HK.Items[38].SubItems.Strings[0] := 'Move down subtitle';
    HK.Items[39].SubItems.Strings[0] := MainForm.MShowSub.Caption;
    HK.Items[40].SubItems.Strings[0] := MainForm.MShot.Caption;
    HK.Items[41].SubItems.Strings[0] := 'Rewind subtitle step';
    HK.Items[42].SubItems.Strings[0] := 'Forward subtitle step';
    HK.Items[43].SubItems.Strings[0] := 'Decrease subtitle delay';
    HK.Items[44].SubItems.Strings[0] := 'Increase subtitle delay';
    HK.Items[45].SubItems.Strings[0] := 'DVDnav - Menu';
    HK.Items[46].SubItems.Strings[0] := 'DVDnav - Select';
    HK.Items[47].SubItems.Strings[0] := 'DVDnav - Up';
    HK.Items[48].SubItems.Strings[0] := 'DVDnav - Down';
    HK.Items[49].SubItems.Strings[0] := 'DVDnav - Left';
    HK.Items[50].SubItems.Strings[0] := 'DVDnav - Right';
    HK.Items[51].SubItems.Strings[0] := 'DVDnav - Previous menu';
    HK.Items[52].SubItems.Strings[0] := MainForm.MKaspect.Caption;
    HK.Items[53].SubItems.Strings[0] := MainForm.Hide_menu.Caption;
    HK.Items[54].SubItems.Strings[0] := MainForm.Mctrl.Caption;
    HK.Items[55].SubItems.Strings[0] := 'Next Subtile CodePage';
    HK.Items[56].SubItems.Strings[0] := MainForm.MCompact.Caption;
    HK.Items[57].SubItems.Strings[0] := MainForm.MPCtrl.Caption;
    HK.Items[58].SubItems.Strings[0] := MainForm.MMaxW.Caption;
    HK.Items[59].SubItems.Strings[0] := MainForm.MOpenFile.Caption;
    HK.Items[60].SubItems.Strings[0] := MainForm.MOpenURL.Caption;
    HK.Items[61].SubItems.Strings[0] := MainForm.MClose.Caption;
    HK.Items[62].SubItems.Strings[0] := MainForm.MStop.Caption;
    HK.Items[63].SubItems.Strings[0] := MainForm.MPan.Caption;
    HK.Items[64].SubItems.Strings[0] := MainForm.MQuit.Caption;
    HK.Items[65].SubItems.Strings[0] := MainForm.MOpenDir.Caption;
    HK.Items[66].SubItems.Strings[0] := MainForm.MAudioDelay2.Caption;
    HK.Items[67].SubItems.Strings[0] := MainForm.MQuit.Caption;
    HK.Items[68].SubItems.Strings[0] := MainForm.MStereo.Caption;
    HK.Items[69].SubItems.Strings[0] := MainForm.MLchannels.Caption;
    HK.Items[70].SubItems.Strings[0] := MainForm.MRchannels.Caption;
    HK.Items[71].SubItems.Strings[0] := 'Rewind ' + IntToStr(seekLen) + ' seconds';
    HK.Items[72].SubItems.Strings[0] := 'Forward ' + IntToStr(seekLen) + ' seconds';
    HK.Items[73].SubItems.Strings[0] := MainForm.MSeekF60.Caption;
    HK.Items[74].SubItems.Strings[0] := MainForm.MSeekR60.Caption;
    HK.Items[75].SubItems.Strings[0] := MainForm.MSeekF600.Caption;
    HK.Items[76].SubItems.Strings[0] := MainForm.MSeekR600.Caption;
    HK.Items[77].SubItems.Strings[0] := 'Forward 1 chapter';
    HK.Items[78].SubItems.Strings[0] := 'Rewind 1 chapter';
    HK.Items[79].SubItems.Strings[0] := 'Reset speed';
    HK.Items[80].SubItems.Strings[0] := 'Decrease speed';
    HK.Items[81].SubItems.Strings[0] := 'Increase speed';
    HK.Items[82].SubItems.Strings[0] := MainForm.MMute.Caption;
    HK.Items[83].SubItems.Strings[0] := 'Next aspect';
    HK.Items[84].SubItems.Strings[0] := 'Next subtitle';
    HK.Items[85].SubItems.Strings[0] := 'Next video track';
    HK.Items[86].SubItems.Strings[0] := 'Next program';
    HK.Items[87].SubItems.Strings[0] := MainForm.MPan1.Caption;
    HK.Items[88].SubItems.Strings[0] := MainForm.MPan0.Caption;
    HK.Items[89].SubItems.Strings[0] := 'Next audio track';
    HK.Items[90].SubItems.Strings[0] := 'Toggle OnTop';
    HK.Items[91].SubItems.Strings[0] := MainForm.MShowPlaylist.Caption;
    HK.Items[92].SubItems.Strings[0] := MainForm.MOptions.Caption;
    HK.Items[93].SubItems.Strings[0] := MainForm.MStreamInfo.Caption;
    HK.Items[94].SubItems.Strings[0] := MainForm.MShowOutput.Caption;
    HK.Items[95].SubItems.Strings[0] := MainForm.MIntro.Caption;
    HK.Items[96].SubItems.Strings[0] := MainForm.MEnd.Caption;
    HK.Items[97].SubItems.Strings[0] := MainForm.MSkip.Caption;
    HK.Items[98].SubItems.Strings[0] := MainForm.MPause.Caption;
    HK.Items[99].SubItems.Strings[0] := 'Play/Pause';
    HK.Items[100].SubItems.Strings[0] := MainForm.MPrev.Caption;
    HK.Items[101].SubItems.Strings[0] := MainForm.MNext.Caption;
    HK.Items[102].SubItems.Strings[0] := MainForm.MTM.Caption;
  end;
  with PlaylistForm do begin
    Caption := 'Playlist';
    BPlay.Hint := 'Play';
    BAdd.Hint := 'Add Files...';
    BAddDir.Hint := 'Add Directory...';
    BMoveUp.Hint := 'Move up';
    BMoveDown.Hint := 'Move down';
    BDelete.Hint := 'Remove';
    BClear.Hint := 'Clear';
    CShuffle.Hint := 'Shuffle';
    CLoop.Hint := 'Repeat All';
    COneLoop.Hint := 'Repeat Current';
    BSave.Hint := 'Save list...';
    TntTabSheet1.Caption := Caption;
    TntTabSheet2.Caption := 'Lyric';
    TMLyric.Hint := 'Change codePage of lyric with popup menu';
    MDownloadLyric.Caption := MainForm.MDownloadLyric.Caption;
    MLoadLyric.Caption := MainForm.MLoadlyric.Caption;
    CPA.Caption := 'Auto Detect';
    CP0.Caption := 'System Default';
    CPO.Caption := 'Other';
    SC.Caption := UTF8Decode('简体中文 (Simplified Chinese)');
    TC.Caption := UTF8Decode('繁體中文 (Traditional Chinese)');
    CY0.Caption := UTF8Decode('Русский (Russian OEM866)');
    CY.Caption := 'Cyrillic';
    CY4.Caption := UTF8Decode('Русский (Russian,20866,KOI8-R)');
    CY6.Caption := UTF8Decode('Українська (UKrainian,21866,KOI8-U)');
    AR.Caption := UTF8Decode('العربية (Arabic)');
    TU.Caption := UTF8Decode('Türkiye (Turkish)');
    HE.Caption := UTF8Decode('עִבְרִית‎ (Hebrew)');
    JA.Caption := UTF8Decode('日本語 (Japanese)');
    KO.Caption := UTF8Decode('한국어 (Korean)');
    TH.Caption := UTF8Decode('ภาษาไทย (Thai)');
    FR.Caption := UTF8Decode('Français(French)');
    IC.Caption := UTF8Decode('íslenska (Icelandic)');
    BG.Caption := UTF8Decode('Български (Bulgarian)');
    PO.Caption := UTF8Decode('Português (Portuguese)');
    GR.Caption := UTF8Decode('Ελληνικά (Greek)');
    BA.Caption := 'Baltic';
    VI.Caption := UTF8Decode('Việt (Vietnamese,1258,windows-1258)');
    WE.Caption := 'Western European (1252,iso-8859-1)';
    CE.Caption := 'Central European';
    ND.Caption := UTF8Decode('Norsk (Nordic OEM865)');
    i18.Caption := 'IBM EBCDIC-International (500)';
    co.Caption := UTF8Decode('Hrvatska (Croatia MAC10082)');
    rm.Caption := UTF8Decode('Română (Romania MAC10010)');
    ro.Caption := 'Roman (MAC 10000)';
    pg.Caption := UTF8Decode('ਪੰਜਾਬੀ Punjabi(Gurmukhi) 57011');
    gu.Caption := UTF8Decode('ગુજરાતી (Gujarati 57010)');
    ma.Caption := UTF8Decode('മലയാളം (Malayalam 57009)');
    ka.Caption := UTF8Decode('ಕನ್ನಡ (Kannada 57008)');
    oy.Caption := 'Oriya (57007)';
    am.Caption := UTF8Decode('অসমীয়া (Assamese 57006)');
    te.Caption := UTF8Decode('తెలుగు (Telugu 57005)');
    ta.Caption := UTF8Decode('தமிழ் (Tamil 57004)');
    be.Caption := UTF8Decode('বাংলা (Bengali 57003)');
    dv.Caption := UTF8Decode('संस्कृतम् (Devanagari 57002)');
  end;
  AddDirCP := 'Select a folder';
  with EqualizerForm do begin
    Caption := MainForm.MEqualizer.Caption;
    BReset.Caption := OSD_Reset_Prompt;
    BClose.Caption := OptionsForm.BClose.Caption;
    SBri.Caption := OSD_Brightness_Prompt;
    SCon.Caption := OSD_Contrast_Prompt;
    SSat.Caption := OSD_Saturation_Prompt;
    SHue.Caption := OSD_Hue_Prompt;
  end;
  with OpenDevicesForm do begin
    LVideoDevices.Caption := 'Video Devices';
    LAudioDevices.Caption := 'Audio Devices';
    LCountryCode.Caption := 'Country Code';
    TOpen.Caption := 'Open';
    TScan.Caption := 'Scan';
    TStop.Caption := 'Stop';
    TView.Caption := 'View';
    TPrev.Caption := 'Prev';
    TNext.Caption := 'Next';
    TClear.Caption := 'Clear';
    TLoad.Caption := 'Load';
    TSave.Caption := 'Save';
    HK.Columns[0].Caption := 'Channel';
    HK.Columns[1].Caption := 'Freq';
  end;
  with DLyricForm do begin
    LyricListView.Column[1].Caption := 'Artist';
    LyricListView.Column[2].Caption := 'Title';
    SubListView.Column[1].Caption := 'Movie Name';
    SubListView.Column[2].Caption := 'Language';
    SubListView.Column[3].Caption := 'Format';
    SubListView.Column[4].Caption := 'CD Sum';
    SubListView.Column[5].Caption := 'Download Count';
    SubListView.Column[6].Caption := 'Add Date';
    SSubtitle.Caption := MainForm.MSub.Caption;
    slyric.Caption := 'Lyric';
    LArtist.Caption := LyricListView.Column[1].Caption + ':';
    LTitle.Caption := LyricListView.Column[2].Caption + ':';
    LSLang.Caption := SubListView.Column[2].Caption + ':';
    LSTitle.Caption := LTitle.Caption;
    BApply.Caption := OptionsForm.BApply.Caption;
    BLApply.Caption := OptionsForm.BApply.Caption;
    BSave.Caption := OptionsForm.BSave.Caption;
    BLSave.Caption := BSave.Caption;
    BSave.Hint := 'Save Lyric';
    BLSave.Hint := 'Save Subtitle';
    BClose.Caption := OptionsForm.BClose.Caption;
    BLClose.Caption := BClose.Caption;
    BSearch.Caption := 'Search';
    BSSearch.Caption := BSearch.Caption;
  end;
  InfoForm.Caption := 'Clip information';
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  InfoForm.TCB.Caption := 'Copy Info';
  LOCstr_NoInfo := 'No clip information is available at the moment.';
  LOCstr_InfoFileName := 'Clip name';
  LOCstr_InfoFileFormat := 'Format';
  LOCstr_InfoPlaybackTime := 'Duration';
  LOCstr_InfoTags := 'Clip Metadata';
  LOCstr_InfoVideo := OSD_VideoTrack_Prompt;
  LOCstr_InfoAudio := OSD_AudioTrack_Prompt;
  LOCstr_InfoDecoder := 'Decoder';
  LOCstr_InfoCodec := 'Codec';
  LOCstr_InfoBitrate := 'Bitrate';
  LOCstr_InfoVideoSize := 'Dimensions';
  LOCstr_InfoVideoFPS := 'Frame Rate';
  LOCstr_InfoVideoAspect := 'Aspect Ratio';
  LOCstr_InfoAudioRate := 'Sample Rate';
  LOCstr_InfoAudioChannels := 'Channels';
  IKeyHint := 'Please press hotkey';
  IKeyerror := 'Shortcut is already in use';
  IKeyerror1 := 'Overwrite?';
  Ccap := 'Chapter'; Acap := 'Angle'; Tcap := 'Track';
end;

begin
  RegisterLocale('English', Activate, LANG_ENGLISH, ANSI_CHARSET);
end.
