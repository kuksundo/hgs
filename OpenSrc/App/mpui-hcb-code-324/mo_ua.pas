{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2005 vadim-l@foxtrot.kiev.ua
    Copyright (C) 2006 Andriy Zhouck <juksoft@ukr.net>
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
unit mo_ua;
interface
implementation
uses Windows, Locale, Main, Options, plist;

procedure Activate;
begin
  with MainForm do
  begin
    BFullscreen.Hint := UTF8Decode('Зміна режиму: На повний екран');
    LOCstr_Status_Opening:=UTF8Decode('Відкриття ...');  //додано
    LOCstr_Status_Closing:=UTF8Decode('Закриття ...');  //додано
      LOCstr_Status_Playing:=UTF8Decode('Відтворення...');  //додано
      LOCstr_Status_Paused:=UTF8Decode('Призупинено');  //додано
      LOCstr_Status_Stopped:=UTF8Decode('Зупинено');  //додано
      LOCstr_Status_Error:=UTF8Decode('Неможливо відтворити носій (Натисніть для отримання додаткової інформації)'); //додано
    BPlaylist.Hint:=UTF8Decode('Показати/приховати плейліст'); //додано
    BStreamInfo.Hint:=UTF8Decode('Показати/приховати інформацію про кліп'); // додано
    BCompact.Hint:=UTF8Decode('До компактного режиму');
    BMute.Hint:=UTF8Decode('Вимкнути/включити звук'); 
    MPCtrl.Caption:= UTF8Decode('Показати кнопки повноекранного режиму');

    OSDMenu.Caption := UTF8Decode('Встановлення: OSD режиму');
    MNoOSD.Caption := UTF8Decode('Вимкнути: OSD');
    MDefaultOSD.Caption := UTF8Decode('За умовчанням: OSD'); // виправлено
    MTimeOSD.Caption := UTF8Decode('Показати час');
    MFullOSD.Caption := UTF8Decode('Показати тривалість'); // виправлено
    MFile.Caption := UTF8Decode('Файл');
    MOpenFile.Caption := UTF8Decode('Завантажити файл ...'); // виправлено
    OpenDialog.Title := UTF8Decode('Відкрити файл'); // додано
    MOpenURL.Caption := UTF8Decode('Відтворити інтернет ярлик ...'); // виправлено
    LOCstr_OpenURL_Caption := UTF8Decode('Відтворити URL ...');
    LOCstr_OpenURL_Prompt := UTF8Decode('Який URL Ви хочете завантажити?'); // виправлено
    MOpenDrive.Caption := UTF8Decode('Грати (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('Закрити');
    MQuit.Caption := UTF8Decode('Вийти');
    MView.Caption := UTF8Decode('Перегляд');
    MSizeAny.Caption := UTF8Decode('Довільний розмір (');  // виправлено 18.04.06
    MSize50.Caption := UTF8Decode('Розмір 50%');
    MSize100.Caption := UTF8Decode('Розмір 100%');
    MSize200.Caption := UTF8Decode('Розмір 200%');
    MFullscreen.Caption := UTF8Decode('На повний екран');
    {+}
    BFullscreen.Hint := UTF8Decode('На повний екран'); // MFullscreen.Caption
    {+.}
    MOSD.Caption := UTF8Decode('Переключення OSD');
    MCompact.Caption:= UTF8Decode('Компактний режим');  // додано 18.04.06
    MOnTop.Caption := UTF8Decode('Завжди зверху'); // виправлено 18.04.06
    MSeek.Caption := UTF8Decode('Команди');
    MPlay.Caption := UTF8Decode('Грати');
    MPause.Caption := UTF8Decode('Пауза');
    MStop.Caption := UTF8Decode('Зупинити');
    MPrev.Caption:= UTF8Decode('Попередній кліп');  // додано 18.04.06
    MNext.Caption:= UTF8Decode('Наступний кліп'); // додано 18.04.06
    MShowPlaylist.Caption:= UTF8Decode('Плейліст ...'); // додано 18.04.06
    MMute.Caption:= UTF8Decode('Вимкнути звук'); // додано 18.04.06
    MSeekF10.Caption := UTF8Decode('Перейти на + 10 секунд');
    MSeekR10.Caption := UTF8Decode('Перейти на - 10 секунд');
    MSeekF60.Caption := UTF8Decode('Перейти на + 1 хвилину');
    MSeekR60.Caption := UTF8Decode('Перейти на - 1 хвилину');
    MSeekF600.Caption := UTF8Decode('Перейти на + 10 хвилин');
    MSeekR600.Caption := UTF8Decode('Перейти на - 10 хвилин');
    MExtra.Caption := UTF8Decode('Налаштування'); //'Options (Налаштування)');
    MAudio.Caption := UTF8Decode('Звукова доріжка');
    MSubtitle.Caption := UTF8Decode('Доріжка субтитрів');
    MAspects.Caption := UTF8Decode('Пропорції відео');
    MAutoAspect.Caption := UTF8Decode('Автовизначення');
    MForce43.Caption := UTF8Decode('Встановити як: 4:3');
    MForce169.Caption := UTF8Decode('Встановити як:  16:9');
    MForceCinemascope.Caption := UTF8Decode('Встановити як:  2.35:1');
    MDeinterlace.Caption := UTF8Decode('Згладжування картинки'); // виправлено (було «згладжування зображення»)
    MNoDeint.Caption := UTF8Decode('Вимкнено');
    MSimpleDeint.Caption := UTF8Decode('Просте');
    MAdaptiveDeint.Caption := UTF8Decode('Адаптивне');
    MOptions.Caption := UTF8Decode('Налаштування ...');
    MLanguage.Caption := UTF8Decode('Мова програми');
    MStreamInfo.Caption:= UTF8Decode('Показати інформацію про кліп');
    MShowOutput.Caption := UTF8Decode('Показати журнал MPlayer');
    MHelp.Caption := UTF8Decode('Допомога');
      MKeyHelp.Caption := UTF8Decode('Клавіатурні команди ...');  // виправлено
      MAbout.Caption := UTF8Decode('Про програму ...');
  end;
  OptionsForm.HelpText.Text :=UTF8Decode(
    'Навіація:'#13#10^M^J +
    'Space'^I'Грати/Пауза'^M^J +
    'Right'^I'Вперед на 10 секунд'^M^J +
    'Left'^I'Назад на 10 секунд'^M^J +
    'Up'^I'Вперед на 1 хвилину'^M^J +
    'Down'^I'Назад на 1 хвилину'^M^J +
    'PgUp'^I'Вперед на 10 хвилин'^M^J +
    'PgDn'^I'Назад на 10 хвилин'^M^J +
    ^M^J+
    #13#10 +
    'Інші:'#13#10^M^J +
    'O'^I'Змінити OSD'^M^J +
    'F'^I'Зміна повноекранного режиму'^M^J +
    'C'^I'Зміна компактного режиму'^M^J+
    'T'^I'Зміна режиму «завжди зверху»'^M^J+
    'Q'^I'Вийти негайно'^M^J +
    '9/0'^I'Регулювання рівня звуку'^M^J +
    '-/+'^I'Регулювання синхронності аудіо/відео'^M^J +
    '1/2'^I'Регулювання яскравості'^M^J +
    '3/4'^I'Регулювання контрасту'^M^J +
    '5/6'^I'Регулювання відтінків'^M^J +
    '7/8'^I'Регулювання насиченості')
    ; // виправлено

  with OptionsForm do begin
    LVersionMPUI.Caption := UTF8Decode('Версія MPUI-hcb: ');
    LVersionMPlayer.Caption := UTF8Decode('Версія програвача MPlayer: ');
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('Про програму');
    Caption := UTF8Decode('Налаштування');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('Застосувати');
    BSave.Caption := UTF8Decode('Зберегти');
    BClose.Caption := UTF8Decode('Закрити');
    LAudioOut.Caption := UTF8Decode('Виведення звуку через');
    LAudioDev.Caption := UTF8Decode('Пристрій виведення звуку');
    CAudioOut.Items[0] := UTF8Decode('(не декодувати звук)');
    CAudioOut.Items[1] := UTF8Decode('(не програвати звук)');
    LPostproc.Caption := UTF8Decode('Допоміжна обробка відео');
    CPostproc.Items[0] := UTF8Decode('Відключено');
    CPostproc.Items[1] := UTF8Decode('Автовизначення');
    CPostproc.Items[2] := UTF8Decode('Максимальна якість');
    LOCstr_AutoLocale := UTF8Decode('(Автовизначення)');
    CIndex.Caption := UTF8Decode('Перебудова індексу відео файла за необхідністю'); // виправлено
    CSoftVol.Caption:= UTF8Decode('Програмне регулювання гучності звуку');
    CPriorityBoost.Caption:= UTF8Decode('Запускати з підвищеним пріоритетом'); 
    LParams.Caption := UTF8Decode('Допоміжні налаштування MPlayer:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption:=UTF8Decode('Плейліст');
    BPlay.Hint:=UTF8Decode('Відтворити');
    BAdd.Hint:=UTF8Decode('Додати ...');
    BMoveUp.Hint:=UTF8Decode('Уверх');
    BMoveDown.Hint:=UTF8Decode('Донизу');
    BDelete.Hint:=UTF8Decode('Вилучити');
    CShuffle.Hint:= UTF8Decode('Випадково');
    CLoop.Hint:= UTF8Decode('Повторити');
    BSave.Hint:= UTF8Decode('Зберегти ...');
  end; 
end;

begin
  RegisterLocale(UTF8Decode('Українська (Ukrainian)'), Activate, LANG_UKRAINIAN, RUSSIAN_CHARSET);
end.



