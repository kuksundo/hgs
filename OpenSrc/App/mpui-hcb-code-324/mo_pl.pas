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
		
		Polish translation by Wojciech Gałecki alias Kamikazee 
		v0.9 alpha
		http://kamikaze.mp.waw.pl/
		kamikazeepl[at]gmail[dot]com
}
unit mo_pl;
interface
implementation
uses Windows,Locale,Main,Options,plist,Info,Core,Equalizer;

procedure Activate;
begin
  with MainForm do begin
      LOCstr_Status_Opening:=UTF8Decode('Otwieranie...');
      LOCstr_Status_Closing:=UTF8Decode('Zamykanie...');
      LOCstr_Status_Playing:=UTF8Decode('Odtwarzanie');
      LOCstr_Status_Paused:=UTF8Decode('Pauza');
      LOCstr_Status_Stopped:=UTF8Decode('Zatrzymane');
      LOCstr_Status_Error:=UTF8Decode('Brak moźliwości otwarcia pliku (Nacisnij aby uzyskac wiecej informacji)');
      LOCstr_SetPW_Caption:=UTF8Decode('Wpisz hasło do otwarcia archiwum');
      LOCstr_Check_Mplayer_Prompt:=UTF8Decode('Sprawdź ścieżkę do programu MPlayer.');
      LOCstr_Error1_Prompt:=UTF8Decode('Błąd ');
      LOCstr_Error2_Prompt:=UTF8Decode(' przy uruchamianiu MPlayer:');
      LOCstr_CmdLine_Prompt:=UTF8Decode('linia poleceń:');
      OSD_Volume_Prompt:='Głośność';
      OSD_ScreenShot_Prompt:='Zrzut ekranu ';
      OSD_Contrast_Prompt:='Kontrast';
      OSD_Brightness_Prompt:='Jasność';
      OSD_Hue_Prompt:='Odcień';
      OSD_Saturation_Prompt:='Nasycenie';
      OSD_Gamma_Prompt:='Gamma';
      OSD_Enable_Prompt:='Włącz';
      OSD_Disable_Prompt:='Wyłącz';
      OSD_VideoTrack_Prompt:='Ścieżka video';
      OSD_AudioTrack_Prompt:='Ścieżka audio';
      OSD_OnTop0_Prompt:='Nigdy na wierzchu';
      OSD_OnTop1_Prompt:='Zawsze na wierzchu';
      OSD_OnTop2_Prompt:='Na wierzchu podczas odtwarzania';
      OSD_Auto_Prompt:='Auto';
      OSD_Custom_Prompt:='Własny';
      OSD_Size_Prompt:='Rozmiar';
      OSD_Scale_Prompt:='Skala';
      OSD_Balance_Prompt:='Balans';
      OSD_Reset_Prompt:='Reset';
      OSD_AudioDelay_Prompt:='Opóźnienie dźwięku';
      OSD_SubDelay_Prompt:='Opóźnienie napisów';
      SubFilter:=UTF8Decode('Pliki napisów');
      AudioFilter:=UTF8Decode('Plik audio');
      AnyFilter:=UTF8Decode('Dowolny plik');
      FontFilter:=UTF8Decode('Czcionka TrueType');
      MediaFilter:=UTF8Decode('Pliki multimedialne');
      LyricFilter:=UTF8Decode('Plik Lyric');
    BPause.Hint:=LOCstr_Status_Paused;
    BOpen.Hint:=UTF8Decode('Odtwarzaj plik');
    BPlaylist.Hint:=UTF8Decode('Pokaż/Ukryj okno listy odtwarzania');
    BStreamInfo.Hint:=UTF8Decode('Pokaż/Ukryj informacje o pliku');
    BFullscreen.Hint:=UTF8Decode('Przełącza na Pełny ekran');
    BCompact.Hint:=UTF8Decode('Przełącza w tryb kompaktowy');
    BMute.Hint:=UTF8Decode('Włącz wyciszenie dźwięku');
    BSkip.Hint:=UTF8Decode('Toggle Skip Intro Ending');
    SeekBarSlider.Hint:=UTF8Decode('MMB/RMB Set Intro,Ending');
    MPCtrl.Caption:=UTF8Decode('Pokaż/Ukryj przyciski');
    OSDMenu.Caption:=UTF8Decode('OSD');
      MNoOSD.Caption:=UTF8Decode('Wyłącz OSD');
      MDefaultOSD.Caption:=UTF8Decode('Pasek wyszukiwania');
      MTimeOSD.Caption:=UTF8Decode('Pokaż czas');
      MFullOSD.Caption:=UTF8Decode('Pokaż czas/całkowity');
    MFile.Caption:=UTF8Decode('Plik');
      MOpenFile.Caption:=UTF8Decode('Otwórz plik ...');
      MOpenDir.Caption:=UTF8Decode('Otwórz katalog ...');
      MOpenURL.Caption:=UTF8Decode('Otórz URL ...');
        LOCstr_OpenURL_Caption:=UTF8Decode('Odtwarzaj URL');
        LOCstr_OpenURL_Prompt:=UTF8Decode('Który URL chcesz odtwarzać?');
      MOpenDrive.Caption:=UTF8Decode('Otwórz (V)CD/DVD/BlueRay');
      MLoadLyric.Caption:=UTF8Decode('Wczytaj plik Lyric');
      MLoadSub.Caption:=UTF8Decode('Wczytaj napisy...');
      FontTitle:=UTF8Decode('Czcionka OSD...');
      MSubfont.Caption:=UTF8Decode('Czcionka napisów...');
      MClose.Caption:=UTF8Decode('Zamknij');
      MQuit.Caption:=UTF8Decode('Zakończ');
    MView.Caption:=UTF8Decode('Widok');
      MSizeAny.Caption:=UTF8Decode('Własny rozmiar (');
      MSize50.Caption:=UTF8Decode('Połowa rozmiaru 50%');
      MSize100.Caption:=UTF8Decode('Oryginalny rozmiar 100%');
      MSize200.Caption:=UTF8Decode('Podwójny rozmiar 200%');
      MFullscreen.Caption:=UTF8Decode('Pełny ekran');
      MCompact.Caption:=UTF8Decode('Tryb kompaktowy');
      MMaxW.Caption:=UTF8Decode('Maksymalizuj okno');
      MOnTop.Caption:=UTF8Decode('Na wierzchu');
        MNoOnTop.Caption:=UTF8Decode('Nigdy na wierzchu');
        MAOnTop.Caption:=UTF8Decode('Zawsze na wierzchu');
        MWOnTop.Caption:=UTF8Decode('Na wierzchu podczas odtwarzania');
      MKaspect.Caption:=UTF8Decode('Utrzymuj współczynnik proporcji');
      MExpand.Caption:=UTF8Decode('Rozszerz czarnymi pasami');
        MNoExpand.Caption:='Off';
        MSrtExpand.Caption:='Srt';
        MSubExpand.Caption:='Sub';
      Hide_menu.Caption:=UTF8Decode('Autoukrywanie menu');
      Mctrl.Caption:=UTF8Decode('Autoukrywanie przycisków');
    MSeek.Caption:=UTF8Decode('Odtwórz');
      MPlay.Caption:=MSeek.Caption;
      MPause.Caption:=LOCstr_Status_Paused;
      MStop.Caption:=UTF8Decode('Zatrzymaj');
      MPrev.Caption:=UTF8Decode('Poprzedni');
      MNext.Caption:=UTF8Decode('Następny');
      MShowPlaylist.Caption:=UTF8Decode('Lista odtwarzania...');
      MSpeed.Caption:=UTF8Decode('Prędkość odtwarzania');
        MN4X.Caption:='1/4X';
        MN2X.Caption:='1/2X';
        M1X.Caption:='1X';
        M2X.Caption:='2X';
        M4X.Caption:='4X';
      MAudiochannels.Caption:=UTF8Decode('Kanały');
        MStereo.Caption:=UTF8Decode('Tryb stereo');
        MLchannels.Caption:=UTF8Decode('Lewy kanał');
        MRchannels.Caption:=UTF8Decode('Prawy kanał');
        MMute.Caption:=UTF8Decode('Wycisz');
      MWheelControl.Caption:=UTF8Decode('Kontroluj rolką myszki');
        MVol.Caption:=OSD_Volume_Prompt;
        MSize.Caption:=OSD_Size_Prompt;
      MSkip.Caption:=UTF8Decode('Skip Intro Ending');
        MIntro.Caption:=UTF8Decode('BeginPoint');
        MEnd.Caption:=UTF8Decode('EndPoint');
        MSIE.Caption:=UTF8Decode('Skip Intro Ending');
      MSeekF10.Caption:=UTF8Decode('Przewiń 10 sekund');
      MSeekR10.Caption:=UTF8Decode('Cofnij 10 sekund');
      MSeekF60.Caption:=UTF8Decode('Przewiń 1 minute');
      MSeekR60.Caption:=UTF8Decode('Rewind 1 minute ');
      MSeekF600.Caption:=UTF8Decode('Przewiń 10 minut');
      MSeekR600.Caption:=UTF8Decode('Cofnij 10 minut');
    MExtra.Caption:=UTF8Decode('Ustawienia');
      MAudio.Caption:=OSD_AudioTrack_Prompt;
      MSubtitle.Caption:=UTF8Decode('Scieżka napisów');
      MShowSub.Caption:=UTF8Decode('Pokaż/Ukryj napisy');
      MVideo.Caption:=OSD_VideoTrack_Prompt;
      MDVDT.Caption:=UTF8Decode('DVD tytuły');
      MRmMenu.Caption:=UTF8Decode('Wróć do głównego menu DVD');
      MRnMenu.Caption:=UTF8Decode('Wróć do najbliższego menu DVD');
      MVCDT.Caption:=UTF8Decode('Ścieżka VCD');
      MCDT.Caption:=UTF8Decode('Ścieżka CD');
      MAspects.Caption:=UTF8Decode('Współczynnik proporcji');
        MAutoAspect.Caption:=UTF8Decode('Wykryj automatycznie');
        MForce43.Caption:=UTF8Decode('Wymuś 4:3');
        MForce169.Caption:=UTF8Decode('wymuś 16:9');
        MForceCinemascope.Caption:=UTF8Decode('Wymuś 2.35:1');
        MForce54.Caption:=UTF8Decode('Wymuś 5:4');
        MForce85.Caption:=UTF8Decode('Wymuś 16:10');
        MForce221.Caption:=UTF8Decode('Wymuś 2.21:1');
        MForce11.Caption:=UTF8Decode('Wymuś 1:1');
        MForce122.Caption:=UTF8Decode('Wymuś 1.22:1');
        MCustomAspect.Caption:=UTF8Decode('Własny ');
      MDeinterlace.Caption:=UTF8Decode('Usuwanie przeplotu');
        MNoDeint.Caption:=UTF8Decode('Wyłącz');
        MSimpleDeint.Caption:=UTF8Decode('Prosty');
        MAdaptiveDeint.Caption:=UTF8Decode('Automatyczny');
      MEqualizer.Caption:=UTF8Decode('Korektor wideo');
      MOptions.Caption:=UTF8Decode('Ustawienia ...');
      MLanguage.Caption:=UTF8Decode('Język');
      MUUni.Caption:=UTF8Decode('Użyj Unicode dla informacji wyjściowych');
      MStreamInfo.Caption:=UTF8Decode('Pokaż informacje o pliku...');
      MShowOutput.Caption:=UTF8Decode('Pokaż konsolę MPlayer...');
    MVideos.Caption:=UTF8Decode('Wideo');
    MAudios.Caption:=UTF8Decode('Audio');
    MSub.Caption:=UTF8Decode('Napisy');
      M2ch.Caption:=UTF8Decode('Stereo');
      M4ch.Caption:=UTF8Decode('4.0 surround');
      M6ch.Caption:=UTF8Decode('Full 5.1 surround');
    MShot.Caption:=OSD_ScreenShot_Prompt;
    MLoadAudio.Caption:=UTF8Decode('Wczytaj zewnętrzny dźwięk');
    MUloadAudio.Caption:=UTF8Decode('Wyładuj zewnętrzny dźwięk');
    MRotate0.Caption:='0';
      MRotate9.Caption:='+90';
      MRotateN9.Caption:='-90';
    MScale.Caption:=UTF8Decode('Scale image');
      MScale0.Caption:=UTF8Decode('Reset Scale');
      MScale1.Caption:=UTF8Decode('Zoom +');
      MScale2.Caption:=UTF8Decode('Zoom -');
   MPan.Caption:=UTF8Decode('Reset Balance');
     MPan0.Caption:=UTF8Decode('Balance +');
     MPan1.Caption:=UTF8Decode('Balance -');
   MSubStep.Caption:=UTF8Decode('Wiersz napisów');
     MSubStep0.Caption:=UTF8Decode('Następny wiersz napisów');
     MSubStep1.Caption:=UTF8Decode('Poprzedni wiersz napisów');
   MAudioDelay.Caption:=UTF8Decode('Audio Delay');
     MAudioDelay0.Caption:=UTF8Decode('Delay +');
     MAudioDelay1.Caption:=UTF8Decode('Delay -');
     MAudioDelay2.Caption:=UTF8Decode('Reset Audio Delay');
   MSubDelay.Caption:=UTF8Decode('Subtitle Delay');
     MSubDelay0.Caption:=UTF8Decode('Delay +');
     MSubDelay1.Caption:=UTF8Decode('Delay -');
     MSubDelay2.Caption:=UTF8Decode('Reset Subtitle Delay');
   MSubScale.Caption:=UTF8Decode('Subtitles Scale');
     MSubScale0.Caption:=UTF8Decode('Zoom +');
     MSubScale1.Caption:=UTF8Decode('Zoom -');
     MSubScale2.Caption:=UTF8Decode('Reset Subtitles Scale');
   MHelp.Caption:=UTF8Decode('Pomoc');   
     MKeyHelp.Caption:=UTF8Decode('Skróty klawiszowe...');
     MAbout.Caption:=UTF8Decode('O programie...');
  end;
  OptionsForm.BClose.Caption:=UTF8Decode('Zamknij');
  OptionsForm.HelpText.Text:=UTF8Decode(
'Space'^I'Play/Pause'^I'T/R'^I'Adjust subtitle position'^M^J+
'Left'^I'Rewind 10 seconds'^I'Y/U'^I'Adjust subtitle step'^M^J+
'Right'^I'Forward 10 seconds Z/X'^I'Adjust subtitle delay'^M^J+
'Up'^I'Forward 1 minute'^I'C'^I'Adjust subtitle alignment'^M^J+
'Down'^I'Rewind 1 minute'^I'B'^I'Switch subtitle language'^M^J+
'PgUp'^I'Forward 10 minutes'^I'V'^I'Toggle subtitle visibility'^M^J+
'PgDn'^I'Rewind 10 minutes'^I'A'^I'switch audio'^M^J+
'Home'^I'Forward 1 chapter'^I'End'^I'Rewind 1 chapter'^M^J+
'O'^I'Toggle OSD'^I'F5'^I'Toggle compact mode'^M^J+
'S'^I'Screen shot'^I'Shift+S'^I'Start/stop screenshot eachframe'^M^J+
'N'^I'switch aspect ratio'^I'F1'^I'Cycle toggle on top mode'^M^J+
'Q'^I'switch video'^I',/.'^I'Adjust balance'^M^J+
'D'^I'Toggle framedrop'^I'M'^I'Toggle mute'^M^J+
'G/H/;'^I'DVDnav menu/select/nearest menu'^I'Ă·,9/*,0'^I'Adjust volume'^M^J+
'-/+'^I'Adjust audio delay'^I'I/K'^I'DVD nav up/down'^M^J+
'1/2'^I'Adjust brightness'^I'J/L'^I'DVD nav left/right'^M^J+
'3/4'^I'Adjust contrast'^I'Back'^I'Reset speed to normal'^M^J+
'5/6'^I'Adjust hue'^I'-/='^I'Adjust playback speed'^M^J+
'7/8'^I'Adjust saturation'^I'F/DblClick'^I'Toggle fullscreen'^M^J+
'Enter'^I'Maximize windows'^I'Ins/Del'^I'Adjust gamma'^M^J+
'[/]'^I'Set Intro/Ending'^I'\'^I'Toggle Skip Intro/Ending'^M^J+
'P'^I'switch program'^I'LMB click StatusBar Timer'^I'Toggle Time'^M^J+
'W/E'^I'Scale video'^I'MMB'^I'Toggle Wheel function'^M^J+
'Ctrl+-/='^I'Scale subtitle'^I'Ctrl+LMB drag subtitle'^I'Scale subtitle'^M^J+
'Ctrl+Wheel '^I'Seek'^I'LMB click video'^I'Play/Pause'^M^J+
''''^I'Deinterlace(if adaptive deinterlace)'^I'/'^I'Frame step'^M^J+
'Shift+A'^I'Toggle Angle'^I'M/RMB click SeekBar Slider'^I'Set Intro/Ending'^M^J+
'Tab'^I'Toggle Menu and ControlPanel'^M^J+
'LMB drag video'^I'Adjust window position'^M^J+
'LMB drag subtitle'^I'Adjust subtitle position'^M^J+
'Ctrl+Left/Right/Up/Down'^I'Adjust aspect ratio'^M^J+
'Ctrl+LMB drag video'^I'Adjust aspect ratio'^M^J+
'Shift+LMB drag video'^I'Scale video,Adjust volume or size'^M^J+
'`'^I'Reset brightness,contrast,hue,saturation,gamma'^M^J+
'Alt+LMB drag video'^I'Adjust brightness,contrast,hue,saturation,gamma'^M^J+
'While drag,release or press different function key invoke different function');
  with OptionsForm do begin
    THelp.Caption:=MainForm.MHelp.Caption;
    TAbout.Caption:=UTF8Decode('O programie');
    LVersionMPUI.Caption:=UTF8Decode('MPUI-hcb wersja:');
    LVersionMPlayer.Caption:=UTF8Decode('MPlayer core version:');
    FY.Caption:=UTF8Decode('Mender:');
    Caption:=UTF8Decode('Ustawienia');
    BOK.Caption:=UTF8Decode('OK');
    BApply.Caption:=UTF8Decode('Zastosuj');
    BSave.Caption:=UTF8Decode('Zapisz');
    TSystem.Caption:=UTF8Decode('System');
    TVideo.Caption:=UTF8Decode('Wideo');
    TAudio.Caption:=UTF8Decode('Audio');
    TSub.Caption:=UTF8Decode('Napisy');
    LAudioOut.Caption:=UTF8Decode('Sterownik dźwięku');
      CAudioOut.Items[0]:=UTF8Decode('nie dekoduj dźwięku');
      CAudioOut.Items[1]:=UTF8Decode('nie odtwarzaj dźwięku');
    LAudioDev.Caption:=UTF8Decode('Urządzenie wyjściowe DirectSound');
    LPostproc.Caption:=UTF8Decode('Postprocessing');
      CPostproc.Items[0]:=UTF8Decode('Off');
      CPostproc.Items[1]:=UTF8Decode('Automatyczny');
      CPostproc.Items[2]:=UTF8Decode('Maksymalna jakość');
    LOCstr_AutoLocale:=UTF8Decode('Wybierz automatycznie');
    CIndex.Caption:=UTF8Decode('Odbuduj index pliku jeśli to konieczne');
    CIndex.Hint:=UTF8Decode('Użyteczne przy uszkodzony/niedociągniętych plikach');
    CNi.Caption:=UTF8Decode('Use non-interleaved AVI parser');
    CNi.Hint:=UTF8Decode('Pomaga odtwarzacz niektóre uszkodzne pliki AVI');
    Cone.Caption:=UTF8Decode('Używaj tylko jednego okna MPUI');
    CDnav.Caption:=UTF8Decode('Użyj DVDNav - menu DVD');
    CDnav.Hint:=UTF8Decode('Jeżeli MPlayer posiada DVDnav lib, użyć myszki do nawigacji w menu płyty DVD');
    CNobps.Caption:=UTF8Decode('Don''t use avg b/s for A-V sync');
    CNobps.Hint:=UTF8Decode('Don''t use average byte/second value for A-V sync.'^M^J+
                 'Helps with some AVI files with broken header');
    CFilter.Caption:=UTF8Decode('Filter DropFiles');
    CFilter.Hint:=UTF8Decode('When to load files by drop, only load'^M^J+
                  'files supported by Mplayer.');
    CFlip.Caption:=UTF8Decode('Obróć obraz');
    CMir.Caption:=UTF8Decode('Lustrzany obrót obrazu');
    CGUI.Caption:=UTF8Decode('Użyj GUI Mplayer');
    CGUI.Hint:=UTF8Decode('Avoid GMplayer to use GUI of itself. For mplayer without ''-nogui'','^M^J+
               'you can cancel this checkbox to ensure mplayer can be runed');
    SSF.Caption:=UTF8Decode('Folder zrzutów ekranowych');
    CSoftVol.Caption:=UTF8Decode('Programowe wzmocnienie dźwięku');
    CDr.Caption:=UTF8Decode('Bezpośrednu rendering');
    CDr.Hint:=UTF8Decode('Włącz bezpośredni rendering nie współpracuje'^M^J+
              'ze wszystkimi kodekami');
    double.Caption:=UTF8Decode('Podwójne buforowanie');
    double.Hint:=UTF8Decode('Redukuje migotanie poprzez przechowywanie w pamięci 2 klatek'^M^J+
												'może wpływać negatywnie na OSD');
    CVolnorm.Caption:=UTF8Decode('Normalzacja dźwięku');
    CVolnorm.Hint:=UTF8Decode('Zwiększa głośność bez zniekształcania dźwięku');
    nFconf.Caption:=UTF8Decode('Use nofontconfig option');
    nFconf.Hint:=UTF8Decode('For mplayer without ''-nofontconfig'' option, you can'^M^J+
                 'uncheck this box to ensure mplayer can be runed');
    CRFScr.Caption:=UTF8Decode('PKM do pełnego ekranu');
    CRFScr.Hint:=UTF8Decode('Kliknięcie prawego klawisza myszy przełącza na Pełny ekran.');
    CSPDIF.Caption:=UTF8Decode('Użyj sprzętowego przejścia S/PDIF');
    LCh.Caption:=UTF8Decode('Standardowo tryb Stereo');
    LRot.Caption:=UTF8Decode('Obrót obrazu');
    SSubcode.Caption:=UTF8Decode('Strona kodowa napisów');
    SSubfont.Caption:=UTF8Decode('Czcionka napisów');
    SOsdfont.Caption:=UTF8Decode('Czcionka OSD');
    SOsdfont.Hint:=UTF8Decode('Use OSDfont for recent Mplayer version');
    RMplayer.Caption:=UTF8Decode('Lokalizacja pliku MPlayer');
    RCMplayer.Caption:=UTF8Decode('W tym samym katalogu co MPUI');
    CWid.Caption:=UTF8Decode('Użyj WID');
    LMAspect.Caption:=UTF8Decode('Współczynnik proporcji monitora');
    LVideoOut.Caption:=UTF8Decode('Sterownik wyjściowy wideo');
    CEq2.Caption:=UTF8Decode('Użyj programowego korektora wideo');
    CEq2.Hint:=UTF8Decode('Użyj jeśli twoja karta nie pozwala na regulację jasności/kontrastu');
    CVSync.Caption:=UTF8Decode('vsync');
    CVSync.Hint:=UTF8Decode('Useful for video laniated');
    CYuy2.Caption:=UTF8Decode('YUY2 colorspace');
    CYuy2.Hint:=UTF8Decode('Useful for video cards/drivers with '^M^J+
                'slow YV12 but fast YUY2 support');
    CUni.Caption:=UTF8Decode('Traktuj napisy jako unicode');
    CUtf.Caption:=UTF8Decode('Traktuj napisy jako UTF-8');
    SFol.Caption:=UTF8Decode('Grubość konturu czcionki');
    SFsize.Caption:=UTF8Decode('Skala napisów');
    SFB.Caption:=UTF8Decode('Rozmiar rozmycia napisów');
    CWadsp.Caption:=UTF8Decode('Użyj pluginów DSP programu Winamp');
    Clavf.Caption:=UTF8Decode('Użyj lavf Demuxer');
    Clavf.Hint:=UTF8Decode('Użyj dla plików, które się nie odtwarzają');
    CFd.Caption:=UTF8Decode('Włącz pomijanie klatek');
    CFd.Hint:=UTF8Decode('Pomija klatki w celu zachowania synchronizacji A/V na słabszych maszynach');
    CAsync.Caption:=UTF8Decode('Autosync');
    CAsync.Hint:=UTF8Decode('Gradually adjusts the A/V sync based '^M^J+
                 'on audio delay measurements');
    CCache.Caption:=UTF8Decode('Bufor');
    CCache.Hint:=UTF8Decode('Określa ile pamięci przydzielić dla bufora');
    CPriorityBoost.Caption:=UTF8Decode('Priorytet MPlayer');
    SFontColor.Caption:=UTF8Decode('Kolor tekstu');
    SOutline.Caption:=UTF8Decode('Kolo konturu');
    CISub.Caption:=UTF8Decode('Dołącz napisy na zrzutach ekranowych');
    CEfont.Caption:=UTF8Decode('Użyj dołączonych czcionek');
    CEfont.Hint:=UTF8Decode('Enables extraction of Matroska embedded fonts.These fonts'^M^J+
                 'can be used for SSA/ASS subtitle rendering');
    CAss.Caption:=UTF8Decode('Use libass for SubRender');
    CAss.Hint:=UTF8Decode('Turn on SSA/ASS subtitle rendering. With this option, libass will'^M^J+
               'be used for SSA/ASS external subtitles and Matroska tracks');
    LParams.Caption:=UTF8Decode('Dodatkowe parametry wywołania MPlayer:');
    LHelp.Caption:=THelp.Caption;
    SLyric.Caption:=UTF8Decode('Katalog Lyric');
    TLyric.Caption:=UTF8Decode('Lyric');
    LTCL.Caption:=UTF8Decode('Kolor tekstu');
    LBCL.Caption:=UTF8Decode('Tło');
    LHCL.Caption:=UTF8Decode('Podświetlenie');
  end;
  with PlaylistForm do begin
    Caption:=UTF8Decode('Lista odtwarzania');
    BPlay.Hint:=UTF8Decode('Odtwarzaj');
    BAdd.Hint:=UTF8Decode('Dodaj pliki...');
    BAddDir.Hint:=UTF8Decode('Dodaj katalog...');
    BMoveUp.Hint:=UTF8Decode('Przesuń w górę');
    BMoveDown.Hint:=UTF8Decode('Przesuń w dół');
    BDelete.Hint:=UTF8Decode('Usuń');
    BClear.Hint:=UTF8Decode('Wyczyść');
    CShuffle.Hint:=UTF8Decode('Losuj');
    CLoop.Hint:=UTF8Decode('Powtarzaj wszystko');
    COneLoop.Hint:=UTF8Decode('Powtarzaj bieżący');
    BSave.Hint:=UTF8Decode('Zapisz listę odtwarzania...');
    TntTabSheet1.Caption:=UTF8Decode('Tytuł');
    TntTabSheet2.Caption:=UTF8Decode('Lyric');
    CP0.Caption:=UTF8Decode('Domyślny');
    CPO.Caption:=UTF8Decode('Inny');
    SC.Caption:=UTF8Decode('简体中文 (Simplified Chinese)');
    TC.Caption:=UTF8Decode('繁體中文 (Traditional Chinese)');
    CY0.Caption:=UTF8Decode('Русский (Russian OEM866)');
    CY.Caption:='Cyrillic';
    CY4.Caption:=UTF8Decode('Русский (Russian,20866,KOI8-R)');
    CY6.Caption:=UTF8Decode('Українська (UKrainian,21866,KOI8-U)');
    AR.Caption:=UTF8Decode('العربية (Arabic)');
    TU.Caption:=UTF8Decode('Türkiye (Turkish)');
    HE.Caption:=UTF8Decode('עִבְרִית‎ (Hebrew)');
    JA.Caption:=UTF8Decode('日本語 (Japanese)');
    KO.Caption:=UTF8Decode('한국어 (Korean)');
    TH.Caption:=UTF8Decode('ภาษาไทย (Thai)');
    FR.Caption:=UTF8Decode('Français(French)');
    IC.Caption:=UTF8Decode('íslenska (Icelandic)');
    BG.Caption:=UTF8Decode('Български (Bulgarian)');
    PO.Caption:=UTF8Decode('Português (Portuguese)');
    GR.Caption:=UTF8Decode('Ελληνικά (Greek)');
    BA.Caption:='Baltic';
    VI.Caption:=UTF8Decode('Việt (Vietnamese,1258,windows-1258)');
    WE.Caption:='Western European (1252,iso-8859-1)';
    CE.Caption:='Central European';
    ND.Caption:=UTF8Decode('Norsk (Nordic OEM865)');
    i18.Caption:='IBM EBCDIC-International (500)';
    co.Caption:=UTF8Decode('Hrvatska (Croatia MAC10082)');
    rm.Caption:=UTF8Decode('Română (Romania MAC10010)');
    ro.Caption:='Roman (MAC 10000)';
    pg.Caption:=UTF8Decode('ਪੰਜਾਬੀ Punjabi(Gurmukhi) 57011');
    gu.Caption:=UTF8Decode('ગુજરાતી (Gujarati 57010)');
    ma.Caption:=UTF8Decode('മലയാളം (Malayalam 57009)');
    ka.Caption:=UTF8Decode('ಕನ್ನಡ (Kannada 57008)');
    oy.Caption:='Oriya (57007)';
    am.Caption:=UTF8Decode('অসমীয়া (Assamese 57006)');
    te.Caption:=UTF8Decode('తెలుగు (Telugu 57005)');
    ta.Caption:=UTF8Decode('தமிழ் (Tamil 57004)');
    be.Caption:=UTF8Decode('বাংলা (Bengali 57003)');
    dv.Caption:=UTF8Decode('संस्कृतम् (Devanagari 57002)');
  end;
  AddDirCP:=UTF8Decode('Wybierz folder');
  with EqualizerForm do begin
    Caption:=MainForm.MEqualizer.Caption;
    BReset.Caption:=UTF8Decode(OSD_Reset_Prompt);
    BClose.Caption:=OptionsForm.BClose.Caption;
    SBri.Caption:=UTF8Decode(OSD_Brightness_Prompt);
    SCon.Caption:=UTF8Decode(OSD_Contrast_Prompt);
    SSat.Caption:=UTF8Decode(OSD_Saturation_Prompt);
    SHue.Caption:=UTF8Decode(OSD_Hue_Prompt);
  end;
  InfoForm.Caption:=UTF8Decode('Informacje o pliku');
  InfoForm.BClose.Caption:=OptionsForm.BClose.Caption;
  LOCstr_NoInfo:=UTF8Decode('Brak informacji o pliku w tym momencie');
  LOCstr_InfoFileFormat:=UTF8Decode('Format');
  LOCstr_InfoPlaybackTime:=UTF8Decode('Czas trwania');
  LOCstr_InfoTags:=UTF8Decode('Metadane');
  LOCstr_InfoVideo:=UTF8Decode(OSD_VideoTrack_Prompt);
  LOCstr_InfoAudio:=UTF8Decode(OSD_AudioTrack_Prompt);
  LOCstr_InfoDecoder:=UTF8Decode('Dekoder');
  LOCstr_InfoCodec:=UTF8Decode('Codec');
  LOCstr_InfoBitrate:=UTF8Decode('Bitrate');
  LOCstr_InfoVideoSize:=UTF8Decode('wymiary');
  LOCstr_InfoVideoFPS:=UTF8Decode('Frame Rate');
  LOCstr_InfoVideoAspect:=UTF8Decode('Aspect Ratio');
  LOCstr_InfoAudioRate:=UTF8Decode('Sample Rate');
  LOCstr_InfoAudioChannels:=UTF8Decode('Channels');
  Ccap:=UTF8Decode('Chapter'); Acap:=UTF8Decode('Angle');
end;

begin
  RegisterLocale(UTF8Decode('Polski (Polish)'),Activate,LANG_POLISH,EASTEUROPE_CHARSET);
end.
