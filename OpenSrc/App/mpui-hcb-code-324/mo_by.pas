{   MPUI, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2005 Vasily Khoruzhick <fenix-fen@mail.ru>
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
unit mo_by;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('Адчыненне ...');
    LOCstr_Status_Closing := UTF8Decode('Зачыненне ...');
    LOCstr_Status_Playing := UTF8Decode('Прайграванне...');
    LOCstr_Status_Paused := UTF8Decode('Прыпынены');
    LOCstr_Status_Stopped := UTF8Decode('Стоп');
    LOCstr_Status_Error := UTF8Decode('Немагчыма прайграць файл (Націскніце, каб атрымаць больш інфармацыі)');
    BPlaylist.Hint := UTF8Decode('Адлюстраваць\схаваць спіс файлаў');
    BStreamInfo.Hint := UTF8Decode('Адлюстраваць\схаваць інфармацыю пра файл');
    BFullscreen.Hint := UTF8Decode('Перайсці ў поўнаэкранны рэжым');
    OSDMenu.Caption := UTF8Decode('Усталяваць рэжым OSD');
    MNoOSD.Caption := UTF8Decode('Без OSD');
    MDefaultOSD.Caption := UTF8Decode('Дэфолтавае OSD');
    MTimeOSD.Caption := UTF8Decode('Адлюстроўваць пазіцыю');
    MFullOSD.Caption := UTF8Decode('Адлюстроўваць пазіцыю\працягласць');
    MFile.Caption := UTF8Decode('Файл');
    MOpenFile.Caption := UTF8Decode('Адчыніць файл ...');
    MOpenURL.Caption := UTF8Decode('Адчыніць URL ...');
    LOCstr_OpenURL_Caption := UTF8Decode('Адчыніць URL');
    LOCstr_OpenURL_Prompt := UTF8Decode('Увядзіце жадаемы URL');
    MOpenDrive.Caption := UTF8Decode('Прайграць (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('Зачыніць');
    MQuit.Caption := UTF8Decode('Выхад');
    MView.Caption := UTF8Decode('Выгляд');
    MSizeAny.Caption := UTF8Decode('Адвольны памер (');
    MSize50.Caption := UTF8Decode('1/2 памера');
    MSize100.Caption := UTF8Decode('Арыгінальны памер');
    MSize200.Caption := UTF8Decode('Падвоены памер');
    MFullscreen.Caption := UTF8Decode('Поўнаэкранный рэжым');
    MOSD.Caption := UTF8Decode('Пераключыць OSD');
    MOnTop.Caption := UTF8Decode('Заўсёды зверху');
    MCompact.Caption := UTF8Decode('Кампактны');
    MSeek.Caption := UTF8Decode('Прайграванне');
    MPlay.Caption := UTF8Decode('Прайграваць');
    MPause.Caption := UTF8Decode('Прыпыніць');
    MPrev.Caption := UTF8Decode('Папярэдні трэк');
    MNext.Caption := UTF8Decode('Наступны трэк');
    MShowPlaylist.Caption := UTF8Decode('Спіс файлаў ...');
    MSeekF10.Caption := UTF8Decode('Наперад на 10 секунд');
    MSeekR10.Caption := UTF8Decode('Назад на 10 секунд');
    MSeekF60.Caption := UTF8Decode('Наперад на 1 хвіліну');
    MSeekR60.Caption := UTF8Decode('Назад на 1 хвіліну');
    MSeekF600.Caption := UTF8Decode('Наперад на 10 хвілін');
    MSeekR600.Caption := UTF8Decode('Назад на 10 хвілін');
    MMute.Caption := UTF8Decode('Выключыць гук');
    MExtra.Caption := UTF8Decode('Налады');
    MAudio.Caption := UTF8Decode('Аудыётрэк');
    MSubtitle.Caption := UTF8Decode('Субтытры');
    MAspects.Caption := UTF8Decode('Суадносіны старон');
    MAutoAspect.Caption := UTF8Decode('Аўтавызначэнне');
    MForce43.Caption := UTF8Decode('4:3');
    MForce169.Caption := UTF8Decode('16:9');
    MForceCinemascope.Caption := UTF8Decode('2.35:1');
    MDeinterlace.Caption := UTF8Decode('Дэінтэрлэйс');
    MNoDeint.Caption := UTF8Decode('Выключыць');
    MSimpleDeint.Caption := UTF8Decode('Просты');
    MAdaptiveDeint.Caption := UTF8Decode('Адаптыўны');
    MOptions.Caption := UTF8Decode('Опцыі ...');
    MLanguage.Caption := UTF8Decode('Мова');
    MStreamInfo.Caption := UTF8Decode('Адлюстраваць інфармацыю пра файл ...');
    MShowOutput.Caption := UTF8Decode('Адлюстроўваць вывад MPlayer');
    MHelp.Caption := UTF8Decode('Дапамога');
    MKeyHelp.Caption := UTF8Decode('Дапамога па клавіятуры ...');
    MAbout.Caption := UTF8Decode('Пра праграму ...');
  end;
  OptionsForm.BClose.Caption := UTF8Decode('Зачыніць');
  OptionsForm.HelpText.Text :=
    UTF8Decode(
    'Клавішы навігацыі:'^M^J +
    'Прабел'^I'Прайграваць/паўза'^M^J +
    'Управа'^I'Уперад на 10 секунд'^M^J +
    'Улева'^I'Назад на 10 секунд'^M^J +
    'Уверх'^I'Уперад на 1 хвіліну'^M^J +
    'Уніз'^I'Назад на 1 хвіліну'^M^J +
    'PgUp'^I'Уперад на 10 хвілін'^M^J +
    'PgDn'^I'Назад на 10 хвілін'^M^J +
    ^M^J+
    'Іншыя клавішы:'^M^J +
    'O'^I'Пераключыць OSD'^M^J +
    'F'^I'Переключыць поўнаэкранны рэжым'^M^J +
    'Q'^I'Выйсці тэрмінова'^M^J +
    '9/0'^I'Наладзіць гучнасць'^M^J +
    '-/+'^I'Наладзіць аўдыё\відыё сінхранізацыю'^M^J +
    '1/2'^I'Наладзіць яркасць'^M^J +
    '3/4'^I'Наладзіць кантраст'^M^J +
    '5/6'^I'Наладзіць гамму'^M^J +
    '7/8'^I'Наладзіць цветавую насычанасць');
  with OptionsForm do begin
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('Пра');
    LVersionMPUI.Caption := UTF8Decode('Версія MPUI-hcb: ');
    LVersionMPlayer.Caption := UTF8Decode('Версія MPlayer: ');
    Caption := UTF8Decode('Опцыі');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('Прымяніць');
    BSave.Caption := UTF8Decode('Захаваць');
    LAudioOut.Caption := UTF8Decode('Драйвер вывада гука');
    CAudioOut.Items[0] := UTF8Decode('(Не дэкадаваць гук)');
    CAudioOut.Items[1] := UTF8Decode('(Не прайграваць гук)');
    LAudioDev.Caption := UTF8Decode('Прылада DirectSound');
    LPostproc.Caption := UTF8Decode('Постпрацэсс');
    CPostproc.Items[0] := UTF8Decode('Адключаны');
    CPostproc.Items[1] := UTF8Decode('Аўтаматычны');
    CPostproc.Items[2] := UTF8Decode('Найлепшы');
    LOCstr_AutoLocale := UTF8Decode('(Аўтавызначэнне)');
    CIndex.Caption := UTF8Decode('Перабудаваць табліцу індэксаў AVI, калі неабходна');
    CSoftVol.Caption := UTF8Decode('Праграмная рэгуліроўка гуку');
    CPriorityBoost.Caption := UTF8Decode('Выконваць з большым прыарытэтам');
    LParams.Caption := UTF8Decode('Дадатковыя параметры MPlayer:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Спіс файлаў');
    BPlay.Hint := UTF8Decode('Прайграць');
    BAdd.Hint := UTF8Decode('Дадаць ...');
    BMoveUp.Hint := UTF8Decode('Уверх');
    BMoveDown.Hint := UTF8Decode('Уніз');
    BDelete.Hint := UTF8Decode('Выдаліць');
    CShuffle.Hint := UTF8Decode('Выбіраць адвольны трэк');
    CLoop.Hint := UTF8Decode('Паўтараць');
    BSave.Hint := UTF8Decode('Захаваць ...');
  end;
  InfoForm.Caption := UTF8Decode('Інфармацыя пра файл');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('На гэты час няма ніякай інфармацыі пра файл.');
  LOCstr_InfoFileFormat := UTF8Decode('Фармат');
  LOCstr_InfoPlaybackTime := UTF8Decode('Працягласць');
  LOCstr_InfoTags := UTF8Decode('Метададзеныя файла');
  LOCstr_InfoVideo := UTF8Decode('Відыётрэк');
  LOCstr_InfoAudio := UTF8Decode('Аудыётрэк');
  LOCstr_InfoDecoder := UTF8Decode('Дэкодэр');
  LOCstr_InfoCodec := UTF8Decode('Кодэк');
  LOCstr_InfoBitrate := UTF8Decode('Бітрэйт');
  LOCstr_InfoVideoSize := UTF8Decode('Памеры');
  LOCstr_InfoVideoFPS := UTF8Decode('Колькасць кадраў у секунду');
  LOCstr_InfoVideoAspect := UTF8Decode('Суадносіны старон');
  LOCstr_InfoAudioRate := UTF8Decode('Якасць сэмпліравання');
  LOCstr_InfoAudioChannels := UTF8Decode('Колькасць каналаў');
end;

begin
  RegisterLocale(UTF8Decode('Belarusian'), Activate, LANG_BELARUSIAN, RUSSIAN_CHARSET);
end.
