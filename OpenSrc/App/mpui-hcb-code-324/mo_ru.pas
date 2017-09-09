{   MPUI-hcb, an MPlayer frontend for Windows
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
unit mo_ru;
interface
implementation
uses Windows, Locale, Main, Options, plist, info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('Открытие ...');
    LOCstr_Status_Closing := UTF8Decode('Закрытие ...');
    LOCstr_Status_Playing := UTF8Decode('Проигрывание...');
    LOCstr_Status_Paused := UTF8Decode('Приостановлено');
    LOCstr_Status_Stopped := UTF8Decode('Остановлено');
    LOCstr_Status_Error := UTF8Decode('Невозможно проиграть носитель (Нажмите чтобы получить больше информации)');
    BPlaylist.Hint := UTF8Decode('Показать\скрыть плейлист');
    BStreamInfo.Hint := UTF8Decode('Показать\скрыть информацию о файле');
    BFullscreen.Hint := UTF8Decode('Переключится в полноэкранный режим');
    OSDMenu.Caption := UTF8Decode('Установить режим OSD');
    MNoOSD.Caption := UTF8Decode('Без OSD');
    MDefaultOSD.Caption := UTF8Decode('OSD по умолчанию');
    MTimeOSD.Caption := UTF8Decode('Показывать позицию');
    MFullOSD.Caption := UTF8Decode('Показывать позицию\длительность');
    MFile.Caption := UTF8Decode('Файл');
    MOpenFile.Caption := UTF8Decode('Открыть файл ...');
    MOpenURL.Caption := UTF8Decode('Открыть URL ...');
    LOCstr_OpenURL_Caption := UTF8Decode('Открыть URL');
    LOCstr_OpenURL_Prompt := UTF8Decode('Введите желаемый URL');
    MOpenDrive.Caption := UTF8Decode('Проиграть (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('Закрыть');
    MQuit.Caption := UTF8Decode('Выход');
    MView.Caption := UTF8Decode('Вид');
    MSizeAny.Caption := UTF8Decode('Произвольный размер (');
    MSize50.Caption := UTF8Decode('1/2 размера');
    MSize100.Caption := UTF8Decode('Оригинальный размер');
    MSize200.Caption := UTF8Decode('Двойной размер');
    MFullscreen.Caption := UTF8Decode('Полноэкранный режим');
    MCompact.Caption := UTF8Decode('Компактный');
    MOSD.Caption := UTF8Decode('Переключить OSD');
    MOnTop.Caption := UTF8Decode('Всегда наверху');
    MSeek.Caption := UTF8Decode('Проигрывание');
    MPlay.Caption := UTF8Decode('Играть');
    MPause.Caption := UTF8Decode('Приостановить');
    MPrev.Caption := UTF8Decode('Предыдущий трек');
    MNext.Caption := UTF8Decode('Следующий трек');
    MShowPlaylist.Caption := UTF8Decode('Плейлист ...');
    MSeekF10.Caption := UTF8Decode('Вперёд на 10 секунд');
    MSeekR10.Caption := UTF8Decode('Назад на 10 секунд');
    MSeekF60.Caption := UTF8Decode('Вперёд на 1 минуту');
    MSeekR60.Caption := UTF8Decode('Назад на 1 минуту');
    MSeekF600.Caption := UTF8Decode('Вперёд на 10 минут');
    MSeekR600.Caption := UTF8Decode('Назад на 10 минут');
    MMute.Caption := UTF8Decode('Выключить звук');
    MExtra.Caption := UTF8Decode('Настройки');
    MAudio.Caption := UTF8Decode('Аудиотрек');
    MSubtitle.Caption := UTF8Decode('Субтитры');
    MAspects.Caption := UTF8Decode('Соотношение сторон');
    MAutoAspect.Caption := UTF8Decode('Автоопределение');
    MForce43.Caption := UTF8Decode('Принудительно 4:3');
    MForce169.Caption := UTF8Decode('Принудительно 16:9');
    MForceCinemascope.Caption := UTF8Decode('Принудительно 2.35:1');
    MDeinterlace.Caption := UTF8Decode('Деинтерлейс');
    MNoDeint.Caption := UTF8Decode('Отключить');
    MSimpleDeint.Caption := UTF8Decode('Простой');
    MAdaptiveDeint.Caption := UTF8Decode('Адаптивный');
    MOptions.Caption := UTF8Decode('Опции ...');
    MLanguage.Caption := UTF8Decode('Язык');
    MStreamInfo.Caption := UTF8Decode('Показать информацию о файле ...');
    MShowOutput.Caption := UTF8Decode('Показывать вывод MPlayer');
    MHelp.Caption := UTF8Decode('Помощь');
    MKeyHelp.Caption := UTF8Decode('Помощь по клавиатуре ...');
    MAbout.Caption := UTF8Decode('О программе ...');
  end;
  OptionsForm.BClose.Caption := UTF8Decode('Закрыть');
  OptionsForm.HelpText.Text :=
    UTF8Decode(
    'Клавиши навигации:'^M^J +
    'Пробел'^I'Играть/пауза'^M^J +
    'Вправо'^I'Вперёд на 10 секунд'^M^J +
    'Влево'^I'Назад на 10 секунд'^M^J +
    'Вверх'^I'Вперёд на 1 минуту'^M^J +
    'Вниз'^I'Назад на 1 минуту'^M^J +
    'PgUp'^I'Вперёд на 10 минут'^M^J +
    'PgDn'^I'Назад на 10 минут'^M^J +
    ^M^J+
    'Другие клавиши:'^M^J +
    'O'^I'Переключить OSD'^M^J +
    'F'^I'Переключить полноэкранный режим'^M^J +
    'Q'^I'Выйти немедленно'^M^J +
    '9/0'^I'Настроить громкость'^M^J +
    '-/+'^I'Настроить аудио\видео синхронизацию'^M^J +
    '1/2'^I'Настроить яркость'^M^J +
    '3/4'^I'Настроить контраст'^M^J +
    '5/6'^I'Настроить hue'^M^J +
    '7/8'^I'Настроить цветовую насыщенность')
    ;

//because we need to set correct charset for font
  with OptionsForm do begin
    LVersionMPUI.Caption := UTF8Decode('Версия MPUI-hcb: ');
    LVersionMPlayer.Caption := UTF8Decode('Версия MPlayer: ');
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('О программе');
    Caption := UTF8Decode('Опции');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('Применить');
    BSave.Caption := UTF8Decode('Сохранить');
    LAudioOut.Caption := UTF8Decode('Драйвер вывода звука');
    CAudioOut.Items[0] := UTF8Decode('(Не декодировать звук)');
    CAudioOut.Items[1] := UTF8Decode('(Не проигрывать звук)');
    LAudioDev.Caption := UTF8Decode('Устройство DirectSound');
    LPostproc.Caption := UTF8Decode('Постобработка');
    CPostproc.Items[0] := UTF8Decode('Отключена');
    CPostproc.Items[1] := UTF8Decode('Автоматически');
    CPostproc.Items[2] := UTF8Decode('Наилучшее качество');
    LOCstr_AutoLocale := UTF8Decode('(Автовыбор)');
    CIndex.Caption := UTF8Decode('Перестроить таблицу индексов AVI, если необходимо');
    CSoftVol.Caption := UTF8Decode('Програмная регулировка громкости');
    CPriorityBoost.Caption := UTF8Decode('Выполнять с более высоким приоритетом');
    LParams.Caption := UTF8Decode('Дополнительные параметры MPlayer:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('Плейлист');
    BPlay.Hint := UTF8Decode('Проиграть');
    BAdd.Hint := UTF8Decode('Добавить ...');
    BMoveUp.Hint := UTF8Decode('Вверх');
    BMoveDown.Hint := UTF8Decode('Вниз');
    BDelete.Hint := UTF8Decode('Удалить');
    CShuffle.Hint := UTF8Decode('Выбирать случайную дорожку');
    CLoop.Hint := UTF8Decode('Повторять');
    BSave.Hint := UTF8Decode('Сохранить ...');
  end;
  InfoForm.Caption := UTF8Decode('Информация о файле');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('Информация недоступна на данный момент');
  LOCstr_InfoFileFormat := UTF8Decode('Формат');
  LOCstr_InfoPlaybackTime := UTF8Decode('Длительность');
  LOCstr_InfoTags := UTF8Decode('Метаданные файла');
  LOCstr_InfoVideo := UTF8Decode('Видео дорожка');
  LOCstr_InfoAudio := UTF8Decode('Аудио дорожка');
  LOCstr_InfoDecoder := UTF8Decode('Декодер');
  LOCstr_InfoCodec := UTF8Decode('Кодек');
  LOCstr_InfoBitrate := UTF8Decode('Битрэйт');
  LOCstr_InfoVideoSize := UTF8Decode('Размеры');
  LOCstr_InfoVideoFPS := UTF8Decode('Частота кадров');
  LOCstr_InfoVideoAspect := UTF8Decode('Отношения сторон');
  LOCstr_InfoAudioRate := UTF8Decode('Качество сэмплирования');
  LOCstr_InfoAudioChannels := UTF8Decode('Количество каналов');
end;

begin
  RegisterLocale(UTF8Decode('Русский (Russian)'), Activate, LANG_RUSSIAN, RUSSIAN_CHARSET);
end.
