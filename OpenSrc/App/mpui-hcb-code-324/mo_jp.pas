{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Masayuki Mogi <mogmog9@gmail.com>
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
unit mo_jp;
interface
implementation
uses Windows, Locale, Main, Options, plist, Info;

procedure Activate;
begin
  with MainForm do begin
    LOCstr_Status_Opening := UTF8Decode('開く ...');
    LOCstr_Status_Closing := UTF8Decode('閉じる ...');
    LOCstr_Status_Playing := UTF8Decode('再生');
    LOCstr_Status_Paused := UTF8Decode('一時停止');
    LOCstr_Status_Stopped := UTF8Decode('停止');
    LOCstr_Status_Error := UTF8Decode('再生不可能です(クリックで詳細)');
    BPlaylist.Hint := UTF8Decode('再生リストウインドウ 表示/非表示');
    BStreamInfo.Hint := UTF8Decode('クリップ情報 表示/非表示');
    BFullscreen.Hint := UTF8Decode('全画面モードに切り替え');
    BCompact.Hint := UTF8Decode('コンパクトモードに切り替え');
    BMute.Hint := UTF8Decode('ミュート');
    MPCtrl.Caption := UTF8Decode('全画面時にコントロールを表示');
    OSDMenu.Caption := UTF8Decode('OSD モード');
    MNoOSD.Caption := UTF8Decode('OSD なし');
    MDefaultOSD.Caption := UTF8Decode('デフォルト OSD');
    MTimeOSD.Caption := UTF8Decode('時間を表示');
    MFullOSD.Caption := UTF8Decode('総計時間を表示');
    MFile.Caption := UTF8Decode('ファイル');
    MOpenFile.Caption := UTF8Decode('ファイルから再生 ...');
    MOpenURL.Caption := UTF8Decode('URLから再生 ...');
    LOCstr_OpenURL_Caption := UTF8Decode('URLから再生');
    LOCstr_OpenURL_Prompt := UTF8Decode('どのURLから再生しますか?');
    MOpenDrive.Caption := UTF8Decode('(V)CD/DVD/BlueRayから再生');
    MClose.Caption := UTF8Decode('閉じる');
    MQuit.Caption := UTF8Decode('終了');
    MView.Caption := UTF8Decode('表示');
    MSizeAny.Caption := UTF8Decode('カスタムサイズ (');
    MSize50.Caption := UTF8Decode('1/2 サイズ');
    MSize100.Caption := UTF8Decode('オリジナルサイズ');
    MSize200.Caption := UTF8Decode('X2 サイズ');
    MFullscreen.Caption := UTF8Decode('全画面');
    MCompact.Caption := UTF8Decode('コンパクトモード');
    MOSD.Caption := UTF8Decode('OSDの切り替え');
    MOnTop.Caption := UTF8Decode('常に手前に表示');
    MSeek.Caption := UTF8Decode('再生');
    MPlay.Caption := UTF8Decode('再生');
    MPause.Caption := UTF8Decode('一時停止');
    MPrev.Caption := UTF8Decode('前のタイトル');
    MNext.Caption := UTF8Decode('次のタイトル');
    MShowPlaylist.Caption := UTF8Decode('再生リスト ...');
    MMute.Caption := UTF8Decode('ミュート');
    MSeekF10.Caption := UTF8Decode('10 秒早送り');
    MSeekR10.Caption := UTF8Decode('10 秒巻き戻す');
    MSeekF60.Caption := UTF8Decode('1 分早送り');
    MSeekR60.Caption := UTF8Decode('1 分巻き戻す');
    MSeekF600.Caption := UTF8Decode('10 分早送り');
    MSeekR600.Caption := UTF8Decode('10 分巻き戻す');
    MExtra.Caption := UTF8Decode('ツール');
    MAudio.Caption := UTF8Decode('音声トラック');
    MSubtitle.Caption := UTF8Decode('字幕トラック');
    MAspects.Caption := UTF8Decode('アスペクト比');
    MAutoAspect.Caption := UTF8Decode('自動検知');
    MForce43.Caption := UTF8Decode('4:3 に強制');
    MForce169.Caption := UTF8Decode('16:9 に強制');
    MForceCinemascope.Caption := UTF8Decode('2.35:1 に強制');
    MDeinterlace.Caption := UTF8Decode('デインターレース');
    MNoDeint.Caption := UTF8Decode('off');
    MSimpleDeint.Caption := UTF8Decode('Simple');
    MAdaptiveDeint.Caption := UTF8Decode('Adaptive');
    MOptions.Caption := UTF8Decode('オプション ...');
    MLanguage.Caption := UTF8Decode('言語');
    MStreamInfo.Caption := UTF8Decode('クリップ情報を表示 ...');
    MShowOutput.Caption := UTF8Decode('MPlayer出力を表示 ...');
    MHelp.Caption := UTF8Decode('ヘルプ');
    MKeyHelp.Caption := UTF8Decode('キーボードヘルプ ...');
    MAbout.Caption := UTF8Decode('MPUIについて ...');
  end;
  OptionsForm.BClose.Caption := UTF8Decode('閉じる');
  OptionsForm.HelpText.Text := UTF8Decode(
    '操作キー:'^M^J +
    'Space'^I'再生/一時停止'^M^J +
    'Right'^I'10 秒早送り'^M^J +
    'Left'^I'10 秒巻き戻し'^M^J +
    'Up'^I'1 分早送り'^M^J +
    'Down'^I'1 分巻き戻し'^M^J +
    'PgUp'^I'10 分早送り'^M^J +
    'PgDn'^I'10 分巻き戻し'^M^J +
    ^M^J+
    'その他のキー:'^M^J +
    'O'^I'切り替え OSD'^M^J +
    'F'^I'切り替え 全画面'^M^J +
    'C'^I'切り替え コンパクト'^M^J +
    'T'^I'切り替え 前面表示'^M^J +
    'Q'^I'直ちに終了'^M^J +
    '9/0'^I'調整 音量'^M^J +
    '-/+'^I'調整 音声/映像の同期'^M^J +
    '1/2'^I'調整 明るさ'^M^J +
    '3/4'^I'調整 コントラスト'^M^J +
    '5/6'^I'調節 色合い'^M^J +
    '7/8'^I'調節 彩度'
    );

  with OptionsForm do begin
    THelp.Caption := MainForm.MHelp.Caption;
    TAbout.Caption := UTF8Decode('について');
    LVersionMPUI.Caption := UTF8Decode('MPUI-hcbのバージョン:');
    LVersionMPlayer.Caption := UTF8Decode('MPlayerコアのバージョン:');
    Caption := UTF8Decode('オプション');
    BOK.Caption := UTF8Decode('OK');
    BApply.Caption := UTF8Decode('適用');
    BSave.Caption := UTF8Decode('保存');
    LAudioOut.Caption := UTF8Decode('サウンド出力ドライバ');
    CAudioOut.Items[0] := UTF8Decode('(サウンドをデコードしない)');
    CAudioOut.Items[1] := UTF8Decode('(サウンドを再生しない)');
    LAudioDev.Caption := UTF8Decode('DirectSound出力デバイス');
    LPostproc.Caption := UTF8Decode('ポストプロセッシング');
    CPostproc.Items[0] := UTF8Decode('オフ');
    CPostproc.Items[1] := UTF8Decode('自動');
    CPostproc.Items[2] := UTF8Decode('最高品質');
    LOCstr_AutoLocale := UTF8Decode('(自動選択)');
    CIndex.Caption := UTF8Decode('必要ならファイルのインデックスを再構築');
    CSoftVol.Caption := UTF8Decode('ソフトウェア音量調整 / 音量ブースト');
    CPriorityBoost.Caption := UTF8Decode('起動時に優先度を高める');
    LParams.Caption := UTF8Decode('MPlayerに追加のパラメータ:');
    LHelp.Caption := THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption := UTF8Decode('再生リスト');
    BPlay.Hint := UTF8Decode('再生');
    BAdd.Hint := UTF8Decode('追加 ...');
    BMoveUp.Hint := UTF8Decode('上に移動');
    BMoveDown.Hint := UTF8Decode('下に移動');
    BDelete.Hint := UTF8Decode('除去');
    CShuffle.Hint := UTF8Decode('シャッフル');
    CLoop.Hint := UTF8Decode('繰り返し');
    BSave.Hint := UTF8Decode('保存 ...');
  end;
  InfoForm.Caption := UTF8Decode('クリップ情報');
  InfoForm.BClose.Caption := OptionsForm.BClose.Caption;
  LOCstr_NoInfo := UTF8Decode('利用可能なクリップ情報がありません.');
  LOCstr_InfoFileFormat := UTF8Decode('形式');
  LOCstr_InfoPlaybackTime := UTF8Decode('合計時間');
  LOCstr_InfoTags := UTF8Decode('クリップのメタデータ');
  LOCstr_InfoVideo := UTF8Decode('映像トラック');
  LOCstr_InfoAudio := UTF8Decode('音声トラック');
  LOCstr_InfoDecoder := UTF8Decode('デコーダ');
  LOCstr_InfoCodec := UTF8Decode('コーデック');
  LOCstr_InfoBitrate := UTF8Decode('ビットレート');
  LOCstr_InfoVideoSize := UTF8Decode('サイズ');
  LOCstr_InfoVideoFPS := UTF8Decode('フレームレート');
  LOCstr_InfoVideoAspect := UTF8Decode('アスペクト比');
  LOCstr_InfoAudioRate := UTF8Decode('サンプルレート');
  LOCstr_InfoAudioChannels := UTF8Decode('チャンネル');
end;

begin
  RegisterLocale(UTF8Decode('日本語 (Japanese)'), Activate, LANG_JAPANESE, SHIFTJIS_CHARSET);
end.
