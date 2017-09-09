{   MPUI, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Boyan Boychev <boyan7640@gmail.com>
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
unit mo_bg;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info, Core, Equalizer;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('Отваряне ...');
    LOCstr_Status_Closing := UTF8Decode('Затваряне ...');
    LOCstr_Status_Playing := UTF8Decode('Стартиране ...');
    LOCstr_Status_Paused := UTF8Decode('На пауза');
    LOCstr_Status_Stopped := UTF8Decode('Спрян');
    LOCstr_Status_Error := UTF8Decode('Не може да стартира носителя (Натиснете тук за повече информация)');
    LOCstr_SetPW_Caption := UTF8Decode('Въведете парола за следния Архив');
    LOCstr_Check_Mplayer_Prompt := UTF8Decode('Проверете местоположението на MPlayer.exe.');
    LOCstr_Error1_Prompt := UTF8Decode('Грешка ');
    LOCstr_Error2_Prompt := UTF8Decode(' при стартирането на MPlayer:');
    LOCstr_CmdLine_Prompt := UTF8Decode('командна линия:');
    OSD_Volume_Prompt := 'Усилване';
    OSD_ScreenShot_Prompt := 'Снимка на екрана ';
    OSD_Contrast_Prompt := 'Контраст';
    OSD_Brightness_Prompt := 'Яркост';
    OSD_Hue_Prompt := 'Оттенък';
    OSD_Saturation_Prompt := 'Наситеност';
    OSD_Gamma_Prompt := 'Гама';
    OSD_Enable_Prompt := 'Включено';
    OSD_Disable_Prompt := 'Изключено';
    OSD_VideoTrack_Prompt := 'Видео поток от данни';
    OSD_AudioTrack_Prompt := 'Аудио поток от данни';
    OSD_OnTop0_Prompt := 'Най-отгоре изключено';
    OSD_OnTop1_Prompt := 'Винаги най-отгоре';
    OSD_OnTop2_Prompt := 'Най-отгоре при режим на изпълнение';
    OSD_Auto_Prompt := 'Автоматично';
    OSD_Custom_Prompt := 'Потребителски режим';
    OSD_Size_Prompt := 'Размер';
    OSD_Scale_Prompt := 'Мащаб';
    OSD_Balance_Prompt := 'Баланс';
    OSD_Reset_Prompt := 'Нулиране';
    OSD_AudioDelay_Prompt := 'Забавяне на звука';
    OSD_SubDelay_Prompt := 'Забавяне на субтитрите';
    SubFilter := UTF8Decode('Файл със субтитри');
    AudioFilter := UTF8Decode('Аудио файл');
    AnyFilter := UTF8Decode('Всеки файл');
    FontFilter := UTF8Decode('TrueType шрифт');
    MediaFilter := UTF8Decode('Видео файл');
    LyricFilter := UTF8Decode('Файл с говор');
    BPause.Hint := LOCstr_Status_Paused;
    BOpen.Hint := UTF8Decode('Стартирай файл');
    BPlaylist.Hint := UTF8Decode('Покажи/скрий плейлист');
    BStreamInfo.Hint := UTF8Decode('Покажи/скрий информация за клип');
    BFullscreen.Hint := UTF8Decode('На цял екран');
    BCompact.Hint := UTF8Decode('Компактен режим');
    BMute.Hint := UTF8Decode('Без звук');
    BSkip.Hint := UTF8Decode('Пропусни Начало/Край');
    SeekBarSlider.Hint := UTF8Decode('MMB/RMB Укажи Начало,Край');
    MPCtrl.Caption := UTF8Decode('Покажи/скрий Контролния панел');
    OSDMenu.Caption := UTF8Decode('OSD режим');
    MNoOSD.Caption := UTF8Decode('Без OSD');
    MDefaultOSD.Caption := UTF8Decode('OSD по подразбиране');
    MTimeOSD.Caption := UTF8Decode('Покажи времетраенето');
    MFullOSD.Caption := UTF8Decode('Покажи позиция/времетраене');
    MFile.Caption := UTF8Decode('Файл');
    MOpenFile.Caption := UTF8Decode('Отвори файл ...');
    MOpenDir.Caption := UTF8Decode('Отвори директория ...');
    MOpenURL.Caption := UTF8Decode('Отвори URL ...');
    LOCstr_OpenURL_Caption := UTF8Decode('Отвори URL');
    LOCstr_OpenURL_Prompt := UTF8Decode('Въведете желаното от вас URL');
    MOpenDrive.Caption := UTF8Decode('Отвори (V)CD/DVD/BlueRay');
    MLoadLyric.Caption := UTF8Decode('Зареди файл с говор ...');
    MLoadSub.Caption := UTF8Decode('Зареди субтитри ...');
    FontTitle := UTF8Decode('OSD шрифт ...');
    MSubfont.Caption := UTF8Decode('Шрифт на субтитрите ...');
    MClose.Caption := UTF8Decode('Затвори');
    MQuit.Caption := UTF8Decode('Изход');
    MView.Caption := UTF8Decode('Изглед');
    MSizeAny.Caption := UTF8Decode('Потребителски размер (');
    MSize50.Caption := UTF8Decode('Размер на половина');
    MSize100.Caption := UTF8Decode('Оригинален размер');
    MSize200.Caption := UTF8Decode('Двоен размер');
    MFullscreen.Caption := UTF8Decode('На цял екран');
    MCompact.Caption := UTF8Decode('Компактен режим');
    MMaxW.Caption := UTF8Decode('Прозорецът в максимален размер');
    MOnTop.Caption := UTF8Decode('Поведение на прозореца');
    MNoOnTop.Caption := UTF8Decode('Най-отгоре изключено');
    MAOnTop.Caption := UTF8Decode('Винаги най-отгоре');
    MWOnTop.Caption := UTF8Decode('Най-отгоре при режим на изпълнение');
    MKaspect.Caption := UTF8Decode('Запази изображението според филма');
    MExpand.Caption := UTF8Decode('Разширяване с черни ленти');
    MNoExpand.Caption := UTF8Decode('Изключено');
    MSrtExpand.Caption := UTF8Decode('Субтитри Srt отдолу');
    MSubExpand.Caption := UTF8Decode('Субтитри Sub отдолу');
    Hide_menu.Caption := UTF8Decode('Автоматично скриване на Главното меню');
    Mctrl.Caption := UTF8Decode('Автоматично скриване на Контролния панел');
    MSeek.Caption := UTF8Decode('Навигация');
    MPlay.Caption := UTF8Decode('Старт');
    MPause.Caption := UTF8Decode('Пауза');
    MStop.Caption := UTF8Decode('Стоп');
    MPrev.Caption := UTF8Decode('Предишно заглавие');
    MNext.Caption := UTF8Decode('Следващо заглавие');
    MShowPlaylist.Caption := UTF8Decode('Плейлист ...');
    MSpeed.Caption := UTF8Decode('Скорост на изпълнение');
    MN4X.Caption := UTF8Decode('1/4X');
    MN2X.Caption := UTF8Decode('1/2X');
    M1X.Caption := UTF8Decode('1X');
    M2X.Caption := UTF8Decode('2X');
    M4X.Caption := UTF8Decode('4X');
    MAudiochannels.Caption := UTF8Decode('Аудио канали');
    MStereo.Caption := UTF8Decode('Стерео');
    MLchannels.Caption := UTF8Decode('Ляв канал');
    MRchannels.Caption := UTF8Decode('Десен канал');
    MMute.Caption := UTF8Decode('Без звук');
    MWheelControl.Caption := UTF8Decode('Поведение на скролера на мишката');
    MVol.Caption := UTF8Decode(OSD_Volume_Prompt);
    MSize.Caption := UTF8Decode(OSD_Size_Prompt);
    MSkip.Caption := UTF8Decode('Пропусни Начало/Край');
    MIntro.Caption := UTF8Decode('Начална точка ');
    MEnd.Caption := UTF8Decode('Крайна точка ');
    MSIE.Caption := UTF8Decode('Пропусни Начало/Край');
    MSeekF10.Caption := UTF8Decode('Напред с 10 секунди'^I'Right');
    MSeekR10.Caption := UTF8Decode('Назад с 10 секунди'^I'Left');
    MSeekF60.Caption := UTF8Decode('Напред с 1 минута'^I'Up');
    MSeekR60.Caption := UTF8Decode('Назад с 1 минута'^I'Down');
    MSeekF600.Caption := UTF8Decode('Напред с 10 минути'^I'PgUp');
    MSeekR600.Caption := UTF8Decode('Назад с 10 минути'^I'PgDn');
    MExtra.Caption := UTF8Decode('Настройки');
    MAudio.Caption := UTF8Decode('Аудио');
    MSubtitle.Caption := UTF8Decode('Субтитри');
    MShowSub.Caption := UTF8Decode('Покажи/скрий субтитри');
    MVideo.Caption := UTF8Decode('Видео');
    MDVDT.Caption := UTF8Decode('DVD заглавия');
    MRmMenu.Caption := UTF8Decode('Върни се към главното меню');
    MRnMenu.Caption := UTF8Decode('Върни се към най-близкото меню');
    MVCDT.Caption := UTF8Decode('VCD поток от данни');
    MCDT.Caption := UTF8Decode('CD поток от данни');
    MAspects.Caption := UTF8Decode('Съотношение на изображението');
    MAutoAspect.Caption := UTF8Decode('Автоматично');
    MForce43.Caption := UTF8Decode('Съотношение 4:3');
    MForce169.Caption := UTF8Decode('Съотношение 16:9');
    MForceCinemascope.Caption := UTF8Decode('Съотношение 2.35:1');
    MForce54.Caption := UTF8Decode('Съотношение 5:4');
    MForce85.Caption := UTF8Decode('Съотношение 16:10');
    MForce221.Caption := UTF8Decode('Съотношение 2.21:1');
    MForce11.Caption := UTF8Decode('Съотношение 1:1');
    MForce122.Caption := UTF8Decode('Съотношение 1.22:1');
    MCustomAspect.Caption := UTF8Decode('Потребителско съотношение ');
    MDeinterlace.Caption := UTF8Decode('Деинтерлейс');
    MNoDeint.Caption := UTF8Decode('Изключено');
    MSimpleDeint.Caption := UTF8Decode('Стандартно');
    MAdaptiveDeint.Caption := UTF8Decode('Адаптивно');
    MEqualizer.Caption := UTF8Decode('Видео Еквалайзер');
    MOptions.Caption := UTF8Decode('Настройки ...');
    MLanguage.Caption := UTF8Decode('Език');
    MUUni.Caption := UTF8Decode('Използвай Unicode за изходните данни');
    MStreamInfo.Caption := UTF8Decode('Покажи информация за клипа ...');
    MShowOutput.Caption := UTF8Decode('Покажи изходните данни от MPlayer');
    MVideos.Caption := UTF8Decode('Видео');
    MAudios.Caption := UTF8Decode('Аудио');
    MSub.Caption := UTF8Decode('Субтитри');
    M2ch.Caption := UTF8Decode('По подразбиране');
    M4ch.Caption := UTF8Decode('4.0 съраунд');
    M6ch.Caption := UTF8Decode('Пълно 5.1');
    MShot.Caption := UTF8Decode(OSD_ScreenShot_Prompt);
    MLoadAudio.Caption := UTF8Decode('Зареди външен аудио файл');
    MUloadAudio.Caption := UTF8Decode('Премахни външен аудио файл');
    MRotate0.Caption := UTF8Decode('0');
    MRotate9.Caption := UTF8Decode('+90');
    MRotateN9.Caption := UTF8Decode('-90');
    MScale.Caption := UTF8Decode(OSD_Scale_Prompt + ' на изображението');
    MScale0.Caption := UTF8Decode(OSD_Reset_Prompt + ' на ' + OSD_Scale_Prompt);
    MScale1.Caption := UTF8Decode('Приближи +');
    MScale2.Caption := UTF8Decode('Отдалечи -');
    MPan.Caption := UTF8Decode(OSD_Reset_Prompt + ' на ' + OSD_Balance_Prompt);
    MPan0.Caption := UTF8Decode(OSD_Balance_Prompt + ' +');
    MPan1.Caption := UTF8Decode(OSD_Balance_Prompt + ' -');
    MSubStep.Caption := UTF8Decode('Стъпка на субтитрите');
    MSubStep0.Caption := UTF8Decode('Назад с една стъпка в субтитрите');
    MSubStep1.Caption := UTF8Decode('Напред с една стъпка в субтитрите');
    MAudioDelay.Caption := UTF8Decode(OSD_AudioDelay_Prompt);
    MAudioDelay0.Caption := UTF8Decode('Ускори +');
    MAudioDelay1.Caption := UTF8Decode('Забави -');
    MAudioDelay2.Caption := UTF8Decode(OSD_Reset_Prompt + ' на ' + OSD_AudioDelay_Prompt);
    MSubDelay.Caption := UTF8Decode(OSD_SubDelay_Prompt);
    MSubDelay0.Caption := UTF8Decode('Измести напред +');
    MSubDelay1.Caption := UTF8Decode('Измести назад -');
    MSubDelay2.Caption := UTF8Decode(OSD_Reset_Prompt + ' на ' + OSD_SubDelay_Prompt);
    MHelp.Caption := UTF8Decode('Помощ');
    MKeyHelp.Caption := UTF8Decode('Помощ за клавиатурата ...');
    MAbout.Caption := UTF8Decode('Относно ...');
  end;
  OptionsForm.HelpText.Text := UTF8Decode(
    'Клавиши за навигация и други:'^M^J +
    'Space'^I'Старт/Пауза'^I'T/R'^I'Коригиране на позицията на субтитрите'^M^J +
    'Left'^I'Назад с 10 секунди'^I'Y/U'^I'Коригиране на стъпката на субтитрите'^M^J +
    'Right'^I'Напред с 10 секунди'^I'Z/X'^I'Коригиране на забавянето на субтитрите'^M^J +
    'Up'^I'Напред с 1 минута'^I'C'^I'Коригиране на подравняването на субтитрите'^M^J +
    'Down'^I'Назад с 1 минута'^I'B'^I'Промени езика на субтитрите'^M^J +
    'PgUp'^I'Напред с 10 минути'^I'V'^I'Покажи/скрий субтитрите'^M^J +
    'PgDn'^I'Назад с 10 минути'^I'A'^I'Превключи звука'^M^J +
    'Home'^I'Напред с 1 глава'^I'End'^I'Назад с 1 глава'^M^J +
    'O'^I'Активирай OSD'^I'F5'^I'Компактен режим'^M^J +
    'S'^I'Направи снимка на екрана'^I'Shift+S'^I'Старт/стоп създаване на снимка на екрана за всеки кадър'^M^J +
    'N'^I'Превключи съотношението на изображението'^I'F1'^I'Превключи режимите на поведението на прозореца'^M^J +
    'Q'^I'Превключи видеото'^I',/.'^I'Коригиране на баланса'^M^J +
    'D'^I'Превключи framedropping режима'^I'M'^I'Заглуши/пусни звука'^M^J +
    'G/H/;'^I'DVD навигационно меню/select/най-близко меню'^I'÷,9/*,0'^I'Намали/увеличи звука'^M^J +
    '-/+'^I'Коригиране на аудио/видео синхронизация'^I'I/K'^I'DVD навигация нагоре/надолу'^M^J +
    '1/2'^I'Коригиране на яркост'^I'J/L'^I'DVD навигация наляво/надясно'^M^J +
    '3/4'^I'Коригиране на контраст'^I'Back'^I'Нулиране на скоростта на възпроизвеждане до нормална'^M^J +
    '5/6'^I'Коригиране на oттенък'^I'-/='^I'Коригиране на скоростта на възпроизвеждане'^M^J +
    '7/8'^I'Коригиране на наситеност'^I'F/DblClick'^I'На цял екран'^M^J +
    'Enter'^I'Прозорец в максимален размер'^I'Ins/Del'^I'Коригиране на гама'^M^J +
    '[/]'^I'Укажи Начало/Край'^I'\'^I'Пропусни Начало/Край'^M^J +
    'P'^I'Превключи програмата'^I'LMB click StatusBar Timer'^I'Покажи време'^M^J +
    'W/E'^I'Мащаб на видеото'^I'MMB'^I'Коригиране на функциите на скрола на мишката'^M^J +
    'Ctrl+-/='^I'Мащаб на субтитрите'^I'Ctrl+LMB drag subtitle'^I'Мащаб на субтитрите'^M^J +
    'Ctrl+Wheel '^I'Търси'^I'LMB click video'^I'Старт/Пауза'^M^J +
    ''''^I'Деинтерлейс(ако има адаптивен деинтерлейс)'^I'/'^I'Спри на кадър'^M^J +
    'Shift+A'^I'Укажи ъгъл'^I'M/RMB click SeekBar Slider'^I'Укажи Начало/Край'^M^J +
    'Tab'^I'Покажи/скрий Главното меню и Контролния панел'^M^J +
    'LMB drag video'^I'Коригиране на позицията на прозореца'^M^J +
    'LMB drag subtitle'^I'Коригиране на позицията на субтитрите'^M^J +
    'Ctrl+←/→/↑/↓'^I'Превключи съотношението на изображението'^M^J +
    'Ctrl+LMB drag video'^I'Превключи съотношението на изображението'^M^J +
    'Shift+LMB drag video'^I'Превключи видеото,Намали/увеличи звука или размера'^M^J +
    '`'^I'Нулиране на яркост, контраст, oттенък, наситеност, гама'^M^J +
    'Alt+LMB drag video'^I'Коригиране на яркост, контраст, oттенък, наситеност, гама'^M^J +
    'Докато премествате/хващате, натиснете или отпуснете различни функционални клавиши, за да извикате различна функционалност');
  with OptionsForm do begin
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('Относно');
    LVersionMPUI.Caption := UTF8Decode('Версия на MPUI-hcb: ');
    LVersionMPlayer.Caption := UTF8Decode('Версия на MPlayer:');
    FY.Caption := UTF8Decode('Корекции от: ');
    Caption := UTF8Decode('Настройки');
    BOK.Caption := UTF8Decode('ДА');
    BApply.Caption := UTF8Decode('Приеми');
    BSave.Caption := UTF8Decode('Запамети');
    BClose.Caption := UTF8Decode('Затвори');
    TSystem.Caption := UTF8Decode('Система');
    TVideo.Caption := UTF8Decode('Видео');
    TAudio.Caption := UTF8Decode('Аудио');
    TSub.Caption := UTF8Decode('Субтитри');
    LAudioOut.Caption := UTF8Decode('Драйвер за звука');
    CAudioOut.Items[0] := UTF8Decode('(не декодирай звука)');
    CAudioOut.Items[1] := UTF8Decode('(изключи звука)');
    LAudioDev.Caption := UTF8Decode('Устройство DirectSound');
    LPostproc.Caption := UTF8Decode('Последваща обработка');
    CPostproc.Items[0] := UTF8Decode('Изключено');
    CPostproc.Items[1] := UTF8Decode('Автоматично');
    CPostproc.Items[2] := UTF8Decode('Най-добро качество');
    LOCstr_AutoLocale := UTF8Decode('(автоматично)');
    CIndex.Caption := UTF8Decode('Пресъздай файловия индекс, ако е необходимо');
    CIndex.Hint := UTF8Decode('Полезно при некоректни/непълни downloads или при лошо създадени файлове');
    CNi.Caption := UTF8Decode('Използвай non-interleaved AVI парсер');
    CNi.Hint := UTF8Decode('Поправя възпроизвеждането на някои лоши AVI файлове');
    CDnav.Caption := UTF8Decode('Използвай DVDNav');
    CNobps.Caption := UTF8Decode('Не използвай avg b/s за A-V sync');
    CNobps.Hint := UTF8Decode('Не използвай средна байт/секунда стойност за A-V sync. Това помага при възпроизвеждането на някой AVI файлове със счупена начална част');
    CFilter.Caption := UTF8Decode('Филтър DropFiles');
    CFilter.Hint := UTF8Decode('Когато зареждате файлове с включен филтър DropFiles, ще се зареждат само файлове поддържани от Mplayer.');
    CFlip.Caption := UTF8Decode('Завърти изображението');
    CMir.Caption := UTF8Decode('Огледално изображение');
    CGUI.Caption := UTF8Decode('Използвай GUI на Mplayer');
    SSF.Caption := UTF8Decode('Директория за снимките на екрана');
    CSoftVol.Caption := UTF8Decode('Софтуерна настройка на звука / Допълнително усилване');
    CDr.Caption := UTF8Decode('Директно рендиране');
    CDr.Hint := UTF8Decode('Включва директното рендиране (не се поддържа от всички кодеци и видео изходи)');
    double.Caption := UTF8Decode('Двоен буфер');
    double.Hint := UTF8Decode('Двойното буфериране поправя OSD трепванията като запаметява два кадъра в памета');
    CVolnorm.Caption := UTF8Decode('Нормализиране на усилването');
    CVolnorm.Hint := UTF8Decode('Максимизира усилването без да изкривява звука');
    CRFScr.Caption := UTF8Decode('Натисни MBR за размер на цял екран');
    CSPDIF.Caption := UTF8Decode('Passthrough S/PDIF');
    LCh.Caption := UTF8Decode('Стерео режим');
    LRot.Caption := UTF8Decode('Завърти изображението');
    SSubcode.Caption := UTF8Decode('Кодировка на субтитрите');
    SSubfont.Caption := UTF8Decode('Шрифт на субтитрите');
    SOsdfont.Caption := UTF8Decode('Osd шрифт');
    SOsdfont.Hint := UTF8Decode('Използвай OSD шрифт при по-новите версии на Mplayer');
    RMplayer.Caption := UTF8Decode('Разположение на Mplayer');
    RCMplayer.Caption := UTF8Decode('В същата директория, в която е MPUI');
    CWid.Caption := UTF8Decode('Използвай WID');
    LMAspect.Caption := UTF8Decode('Съотношение на картината на монитора');
    //LVideoOut.Caption:=UTF8Decode('Не използвай DirectX ускорение');
    //CDDXA.Hint:=UTF8Decode('Пробвайте тази опция ако имате проблеми с дисплея');
    CEq2.Caption := UTF8Decode('Изплозване на софтуерен видео еквалайзер');
    CEq2.Hint := UTF8Decode('за карти/драйвери, които не поддържат настройки за яркост и контраст на хардуерно ниво');
    CVSync.Caption := UTF8Decode('Вертикална синхронизация');
    CVSync.Hint := UTF8Decode('Полезно при видео обработката');
    CYuy2.Caption := UTF8Decode('YUY2 цветова схема');
    CYuy2.Hint := UTF8Decode('Полезно за видео карти/драйвери с бавна YV12, но бърза YUY2 поддръжка');
    CUni.Caption := UTF8Decode('Обработване на субтитрите като Unicode');
    CUtf.Caption := UTF8Decode('Обработване на субтитрите като UTF-8');
    SFol.Caption := UTF8Decode('Дебелина на шрифта');
    SFsize.Caption := UTF8Decode('Мащаб на текста на субтитрите');
    SFB.Caption := UTF8Decode('Радиус на размазване на шрифта');
    CWadsp.Caption := UTF8Decode('Използване на Winamp DSP плъгини');
    Clavf.Caption := UTF8Decode('Използване на lavf Demuxer');
    CFd.Caption := UTF8Decode('Използване на framedrop');
    CFd.Hint := UTF8Decode('Пропускай някои кадри, за да се поддържа A/V синхронизация на бавните системи');
    CAsync.Caption := UTF8Decode('Автоматична синхронизация');
    CAsync.Hint := UTF8Decode('Постепенна настройка на A/V синхронизацията базирано на измервания на забавянето на звука');
    CCache.Caption := UTF8Decode('Кеш');
    CCache.Hint := UTF8Decode('Определя колко памет (в kBytes) да се използва при кеширането на файл или URL. Особено полезно за бавни медии (носители на информация)');
    CPriorityBoost.Caption := UTF8Decode('Стартирай с по-висок приоритет');
    SFontColor.Caption := UTF8Decode('Цвят на текста');
    SOutline.Caption := UTF8Decode('Цвят на външната част');
    CISub.Caption := UTF8Decode('Включи субтитрите при изготвяне снимка на екрана');
    CEfont.Caption := UTF8Decode('Използвай вградените шрифтове');
    CEfont.Hint := UTF8Decode('Разреши обекти от вградените шрифтове Matroska. Тези шрифтове могат да бъдат използвани за SSA/ASS рендиране на субтитрите');
    CAss.Caption := UTF8Decode('Използвай libass за SubRender');
    CAss.Hint := UTF8Decode('Включва SSA/ASS рендиране на субтитрите. При избиране на тази опция libass ще бъде използван за SSA/ASS външни субтитри and Matroska поток от данни');
    LParams.Caption := UTF8Decode('Допълнителни параметри към MPlayer:');
    LHelp.Caption := THelp.Caption;
    SLyric.Caption := UTF8Decode('Директория с говор');
    TLyric.Caption := UTF8Decode('Говор');
    LTCL.Caption := UTF8Decode('Цвят на текста');
    LBCL.Caption := UTF8Decode('Фон');
    LHCL.Caption := UTF8Decode('Осветяване');
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Плейлист');
    BPlay.Hint := UTF8Decode('Стартирай');
    BAdd.Hint := UTF8Decode('Добави файл ...');
    BAddDir.Hint := UTF8Decode('Добави директория ...');
    BMoveUp.Hint := UTF8Decode('Нагоре');
    BMoveDown.Hint := UTF8Decode('Надолу');
    BDelete.Hint := UTF8Decode('Изтрий');
    BClear.Hint := UTF8Decode('Изчисти');
    CShuffle.Hint := UTF8Decode('Случ. избор');
    CLoop.Hint := UTF8Decode('Повтори всички');
    COneLoop.Hint := UTF8Decode('Повтори само текущия');
    BSave.Hint := UTF8Decode('Запамети ...');
    TntTabSheet1.Caption := Caption;
    TntTabSheet2.Caption := UTF8Decode('Говор');
    CP0.Caption := UTF8Decode('По подразбиране за системата');
    CPO.Caption := UTF8Decode('Други');
    SC.Caption := UTF8Decode('简体中文 (Simplified Chinese)');
    TC.Caption := UTF8Decode('繁體中文 (Traditional Chinese)');
    CY0.Caption := UTF8Decode('Русский (Russian)');
    BG.Caption := UTF8Decode('Български (Bulgarian)');
    CY.Caption := 'Cyrillic';
    AR.Caption := UTF8Decode('العربية (Arabic)');
    TU.Caption := 'Turkish';
    HE.Caption := 'Hebrew';
    JA.Caption := 'Japanese';
    KO.Caption := UTF8Decode('한국어 (Korean)');
    TH.Caption := 'Thai';
    FR.Caption := UTF8Decode('Français(French)');
    IC.Caption := 'Icelandic';
    PO.Caption := UTF8Decode('Português (Portuguese)');
    GR.Caption := 'Greek';
    BA.Caption := 'Baltic';
    VI.Caption := 'Vietnamese(1258,windows-1258)';
    WE.Caption := 'Western European (1252,iso-8859-1)';
    CE.Caption := 'Central European';
    ND.Caption := 'Nordic (OEM 865)';
    i18.Caption := 'IBM EBCDIC-International (500)';
    co.Caption := 'Croatia (MAC 10082)';
    rm.Caption := 'Romania (MAC 10010)';
    ro.Caption := 'Roman (MAC 10000)';
    pg.Caption := 'Punjabi(Gurmukhi) 57011';
    gu.Caption := 'Gujarati (57010)';
    ma.Caption := 'Malayalam (57009)';
    ka.Caption := 'Kannada (57008)';
    oy.Caption := 'Oriya (57007)';
    am.Caption := 'Assamese (57006)';
    te.Caption := 'Telugu (57005)';
    ta.Caption := 'Tamil (57004)';
    be.Caption := 'Bengali (57003)';
    dv.Caption := 'Devanagari (57002)';
  end;

  with EqualizerForm do begin
    Caption := MainForm.MEqualizer.Caption;
    BReset.Caption := UTF8Decode(OSD_Reset_Prompt);
    BClose.Caption := OptionsForm.BClose.Caption;
    SBri.Caption := UTF8Decode(OSD_Brightness_Prompt);
    SCon.Caption := UTF8Decode(OSD_Contrast_Prompt);
    SSat.Caption := UTF8Decode(OSD_Saturation_Prompt);
    SHue.Caption := UTF8Decode(OSD_Hue_Prompt);
  end;

  InfoForm.Caption := UTF8Decode('Информация за клипа');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('Няма информация за клипа.');
  LOCstr_InfoFileFormat := UTF8Decode('Формат');
  LOCstr_InfoPlaybackTime := UTF8Decode('Продължителност');
  LOCstr_InfoTags := UTF8Decode('Метаданни за клипа');
  LOCstr_InfoVideo := UTF8Decode('Видео');
  LOCstr_InfoAudio := UTF8Decode('Аудио');
  LOCstr_InfoDecoder := UTF8Decode('Декодер');
  LOCstr_InfoCodec := UTF8Decode('Кодек');
  LOCstr_InfoBitrate := UTF8Decode('Bitrate');
  LOCstr_InfoVideoSize := UTF8Decode('Размери');
  LOCstr_InfoVideoFPS := UTF8Decode('Кадри за секунда');
  LOCstr_InfoVideoAspect := UTF8Decode('Съотношение на изображението');
  LOCstr_InfoAudioRate := UTF8Decode('Sample Rate');
  LOCstr_InfoAudioChannels := UTF8Decode('Канали');
  Ccap := UTF8Decode('Глава'); Acap := UTF8Decode('Ъгъл');
end;

begin
  RegisterLocale(UTF8Decode('Български (Bulgarian)'), Activate, LANG_BULGARIAN, RUSSIAN_CHARSET);
end.
