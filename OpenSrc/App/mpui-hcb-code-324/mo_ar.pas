{   MPUI, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Mohamed Magdy <alnokta@yahoo.com>
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
unit mo_ar;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('جارى الفتح ...');
    LOCstr_Status_Closing := UTF8Decode('جارى الاغلاق ...');
    LOCstr_Status_Playing := UTF8Decode('جارى العرض');
    LOCstr_Status_Paused := UTF8Decode('ايقاف مؤقت');
    LOCstr_Status_Stopped := UTF8Decode('متوقف');
    LOCstr_Status_Error := UTF8Decode('غير قادر على العرض (اضغط لمزيد من المعلومات)');
    BPlaylist.Hint := UTF8Decode('اظهار/اخفاء نافذة العرض');
    BStreamInfo.Hint := UTF8Decode('اظهار/اخفاء معلومات ملف الفيديو');
    BFullscreen.Hint := UTF8Decode('تشغيل وضعية الشاشة الكاملة');
    BCompact.Hint := UTF8Decode('تفعيل الوضعية المضغوطة');
    BMute.Hint := UTF8Decode('تفعيل الوضع الصامت');
    MPCtrl.Caption := UTF8Decode('اظهار ازرار التحكم فى الشاشة الكاملة');
    OSDMenu.Caption := UTF8Decode('OSD وضعية');
    MNoOSD.Caption := UTF8Decode('OSDبدون');
    MDefaultOSD.Caption := UTF8Decode('الافتراضى OSD');
    MTimeOSD.Caption := UTF8Decode('اظهار الزمن');
    MFullOSD.Caption := UTF8Decode('اظهار الزمن الكلى');
    MFile.Caption := UTF8Decode('ملف');
    MOpenFile.Caption := UTF8Decode('عرض ملف');
    MOpenURL.Caption := UTF8Decode('فتح عنوان ويب ...');
    LOCstr_OpenURL_Caption := UTF8Decode('عرض عنوان ويب');
    LOCstr_OpenURL_Prompt := UTF8Decode('ما عنوان الانترنت الذى تريد عرضه؟');
    MOpenDrive.Caption := UTF8Decode('عرض (V)CD/DVD/BlueRay');
    MClose.Caption := UTF8Decode('اغلاق');
    MQuit.Caption := UTF8Decode('خروج');
    MView.Caption := UTF8Decode('مظهر');
    MSizeAny.Caption := UTF8Decode('حجم معرف (');
    MSize50.Caption := UTF8Decode('نصف الحجم');
    MSize100.Caption := UTF8Decode('الحجم الاصلى');
    MSize200.Caption := UTF8Decode('الحجم مضاعف');
    MFullscreen.Caption := UTF8Decode('الشاشة كلها');
    MCompact.Caption := UTF8Decode('الوضعية المضغوطة');
    MOSD.Caption := UTF8Decode('تفعيل OSD');
    MOnTop.Caption := UTF8Decode('دائما على القمة');
    MSeek.Caption := UTF8Decode('عرض');
    MPlay.Caption := UTF8Decode('عرض');
    MPause.Caption := UTF8Decode('وقف مؤقت');
    MPrev.Caption := UTF8Decode('Previous title');
    MNext.Caption := UTF8Decode('Next title');
    MShowPlaylist.Caption := UTF8Decode('لائحة العرض ...');
    MMute.Caption := UTF8Decode('صامت');
    MSeekF10.Caption := UTF8Decode('تقدم عشر ثوان');
    MSeekR10.Caption := UTF8Decode('رجوع عشر ثوان');
    MSeekF60.Caption := UTF8Decode('تقدم دقيقة واحدة');
    MSeekR60.Caption := UTF8Decode('رجوع دقيقة واحدة');
    MSeekF600.Caption := UTF8Decode('تقدم عشر دقائق');
    MSeekR600.Caption := UTF8Decode('رجوع عشر دقائق');
    MExtra.Caption := UTF8Decode('أدوات');
    MAudio.Caption := UTF8Decode('تراك الصوت');
    MSubtitle.Caption := UTF8Decode('تراك الترجمة');
    MAspects.Caption := UTF8Decode('نسبة المظهر');
    MAutoAspect.Caption := UTF8Decode('كشف تلقائى');
    MForce43.Caption := UTF8Decode('اجبار 4:3');
    MForce169.Caption := UTF8Decode('اجبار 16:9');
    MForceCinemascope.Caption := UTF8Decode('اجبار 2.35:1');
    MDeinterlace.Caption := UTF8Decode('Deinterlace');
    MNoDeint.Caption := UTF8Decode('مغلق');
    MSimpleDeint.Caption := UTF8Decode('بسيط');
    MAdaptiveDeint.Caption := UTF8Decode('متكيف');
    MOptions.Caption := UTF8Decode('خيارات ...');
    MLanguage.Caption := UTF8Decode('اللغة');
    MStreamInfo.Caption := UTF8Decode('اظهار معلومات الكليب ...');
    MShowOutput.Caption := UTF8Decode('اظهار خرج امبلاير');
    MHelp.Caption := UTF8Decode('مساعدة');
    MKeyHelp.Caption := UTF8Decode('مساعدة لوحة المفاتيح ...');
    MAbout.Caption := UTF8Decode('عن ...');
  end;
  OptionsForm.HelpText.Text := UTF8Decode(
    'مفاتيح الملاحة:'^M^J +
    'Space'^I'عرض/وقف'^M^J +
    'Right'^I'تقدم عشر ثوان'^M^J +
    'Left'^I'عودة عشر ثوان'^M^J +
    'Up'^I'تقدم دقيقة واحدة'^M^J +
    'Down'^I'عودة دقيقة واحدة'^M^J +
    'PgUp'^I'تقدم عشر دقائق'^M^J +
    'PgDn'^I'عودة عشر دقائق'^M^J +
    'مفاتيح اخرى:'^M^J +
    'O'^I'تفعيل OSD'^M^J +
    'F'^I'تفعيل الشاشة الكاملة'^M^J +
    'C'^I'تفعيل الوضعية المنضغطة'^M^J +
    'T'^I'تفعيل دائما على الاعلى'^M^J +
    'Q'^I'الخروج حالا'^M^J +
    '9/0'^I'تعديل الصوت'^M^J +
    '-/+'^I'Adjust audio/video sync'^M^J +
    '1/2'^I'تعديل درجة فتاحية اللون'^M^J +
    '3/4'^I'تعديل contrast'^M^J +
    '5/6'^I'تعديل hue'^M^J +
    '7/8'^I'تعديل saturation');
  with OptionsForm do begin
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('عن');
    LVersionMPUI.Caption := UTF8Decode('MPUI-hcb نسخة:');
    LVersionMPlayer.Caption := UTF8Decode('MPlayerنسخة صميم:');
    Caption := UTF8Decode('خيارات');
    BOK.Caption := UTF8Decode('نعم');
    BApply.Caption := UTF8Decode('تنفيذ');
    BSave.Caption := UTF8Decode('حفظ');
    BClose.Caption := UTF8Decode('غلق');
    LAudioOut.Caption := UTF8Decode('مشغل مخرج الصوت');
    CAudioOut.Items[0] := UTF8Decode('(لا تفك شفرة الصوت)');
    CAudioOut.Items[1] := UTF8Decode('(لا تقم بتشغيل الصوت)');
    LAudioDev.Caption := UTF8Decode('DirectSound جهاز تخريج');
    LPostproc.Caption := UTF8Decode('بعد المعالجة');
    CPostproc.Items[0] := UTF8Decode('مطفأ');
    CPostproc.Items[1] := UTF8Decode('تلقائى');
    CPostproc.Items[2] := UTF8Decode('الكفاءة القصوى');
    LOCstr_AutoLocale := UTF8Decode('(اختيار تلقائى)');
    CIndex.Caption := UTF8Decode('اعادة بناء فهرس الملف فى حالة الضرورة');
    CSoftVol.Caption := UTF8Decode('Software volume control / Volume boost');
    CPriorityBoost.Caption := UTF8Decode('تشغيل باأولوية عالية');
    LParams.Caption := UTF8Decode('اوامر امبلاير اضافية:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('لائحة العرض');
    BPlay.Hint := UTF8Decode('عرض');
    BAdd.Hint := UTF8Decode('اضف ...');
    BMoveUp.Hint := UTF8Decode('انقل للأعلى');
    BMoveDown.Hint := UTF8Decode('انقل للأسفل');
    BDelete.Hint := UTF8Decode('ازالة');
    CShuffle.Hint := UTF8Decode('عشوائى');
    CLoop.Hint := UTF8Decode('اعادة');
    BSave.Hint := UTF8Decode('حفظ ...');
  end;
  InfoForm.Caption := UTF8Decode('معلومات الكليب');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('لا توجد معلومات عن الكليب حاليا.');
  LOCstr_InfoFileFormat := UTF8Decode('النوعية');
  LOCstr_InfoPlaybackTime := UTF8Decode('المدة');
  LOCstr_InfoTags := UTF8Decode('معلومات الكليب الاولية');
  LOCstr_InfoVideo := UTF8Decode('تراك الصورة');
  LOCstr_InfoAudio := UTF8Decode('تراك الصوت');
  LOCstr_InfoDecoder := UTF8Decode('مفكك الشفرة');
  LOCstr_InfoCodec := UTF8Decode('التشفير');
  LOCstr_InfoBitrate := UTF8Decode('معدل الكسرة');
  LOCstr_InfoVideoSize := UTF8Decode('الابعاد');
  LOCstr_InfoVideoFPS := UTF8Decode('معدل الاطار');
  LOCstr_InfoVideoAspect := UTF8Decode('نسبة المظهر');
  LOCstr_InfoAudioRate := UTF8Decode('معدل العينة');
  LOCstr_InfoAudioChannels := UTF8Decode('القنوات');
end;


begin
  RegisterLocale(UTF8Decode('العربية (Arabic)'), Activate, LANG_ARABIC, ARABIC_CHARSET);
end.
