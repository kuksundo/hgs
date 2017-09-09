{   MPUI-hcb, an MPlayer frontend for Windows
    Copyright (C) 2005 Martin J. Fiedler <martin.fiedler@gmx.net>
    Copyright (C) 2006 Ken Y. Yun <dalbaragi@gmail.com>
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
unit mo_kr;
interface
implementation
uses Windows, Locale, Main, Options, plist, info;

procedure Activate;
begin
  with MainForm do begin
      LOCstr_Status_Opening:=UTF8Decode('여는 중 ...');
      LOCstr_Status_Closing:=UTF8Decode('닫는 중 ...');
      LOCstr_Status_Playing:=UTF8Decode('재생');
      LOCstr_Status_Paused:=UTF8Decode('멈춤');
      LOCstr_Status_Stopped:=UTF8Decode('중지');
      LOCstr_Status_Error:=UTF8Decode('미디어 재생 불가 (정보 얻기 클릭)');
    BPlaylist.Hint:=UTF8Decode('재생목록 보임/숨김');
    BStreamInfo.Hint:=UTF8Decode('클립정보 보임/숨김');
    BFullscreen.Hint:=UTF8Decode('전체화면 모드');
    BCompact.Hint:=UTF8Decode('콤팩트 모드');
    BMute.Hint:=UTF8Decode('음소거');
    MPCtrl.Caption:=UTF8Decode('전체화면시 콘트롤 보이기');
    OSDMenu.Caption:=UTF8Decode('OSD 선택');
      MNoOSD.Caption:=UTF8Decode('OSD 없음');
      MDefaultOSD.Caption:=UTF8Decode('기본 OSD');
      MTimeOSD.Caption:=UTF8Decode('시간 나타냄');
      MFullOSD.Caption:=UTF8Decode('전체시간 나타냄');
    MFile.Caption:=UTF8Decode('파일');
      MOpenFile.Caption:=UTF8Decode('파일 재생 ...');
      MOpenURL.Caption:=UTF8Decode('URL 재생 ...');
        LOCstr_OpenURL_Caption:=UTF8Decode('URL 재생');
        LOCstr_OpenURL_Prompt:=UTF8Decode('재생할 URL 을 입력하세요.');
      MOpenDrive.Caption:=UTF8Decode('(V)CD/DVD/BlueRay 재생');
      MClose.Caption:=UTF8Decode('닫기');
      MQuit.Caption:=UTF8Decode('종료');
    MView.Caption:=UTF8Decode('보기');
      MSizeAny.Caption:=UTF8Decode('사용자 크기 (');
      MSize50.Caption:=UTF8Decode('절반 크기');
      MSize100.Caption:=UTF8Decode('원래 크기');
      MSize200.Caption:=UTF8Decode('두배 크기');
      MFullscreen.Caption:=UTF8Decode('전체화면');
      MCompact.Caption:=UTF8Decode('콤팩트 모드');
      MOSD.Caption:=UTF8Decode('OSD 변경');
      MOnTop.Caption:=UTF8Decode('항상 위에');
    MSeek.Caption:=UTF8Decode('탐색');
      MPlay.Caption:=UTF8Decode('재생');
      MPause.Caption:=UTF8Decode('멈춤');
      MPrev.Caption:=UTF8Decode('이전 제목');
      MNext.Caption:=UTF8Decode('다음 제목');
      MShowPlaylist.Caption:=UTF8Decode('재생목록 ...');
      MMute.Caption:=UTF8Decode('음소거');
      MSeekF10.Caption:=UTF8Decode('앞으로 10초 이동');
      MSeekR10.Caption:=UTF8Decode('뒤로 10초 이동');
      MSeekF60.Caption:=UTF8Decode('앞으로 1분 이동');
      MSeekR60.Caption:=UTF8Decode('뒤로 1분 이동');
      MSeekF600.Caption:=UTF8Decode('앞으로 10분 이동');
      MSeekR600.Caption:=UTF8Decode('뒤로 10분 이동');
    MExtra.Caption:=UTF8Decode('도구');
      MAudio.Caption:=UTF8Decode('음성언어선택');
      MSubtitle.Caption:=UTF8Decode('자막언어선택');
      MAspects.Caption:=UTF8Decode('화면비율');
        MAutoAspect.Caption:=UTF8Decode('자동');
        MForce43.Caption:=UTF8Decode('4:3 고정');
        MForce169.Caption:=UTF8Decode('16:9 고정');
        MForceCinemascope.Caption:=UTF8Decode('2.35:1 고정');
      MDeinterlace.Caption:=UTF8Decode('잔상제거(Deinterlace)');
        MNoDeint.Caption:=UTF8Decode('사용안함');
        MSimpleDeint.Caption:=UTF8Decode('Simple');
        MAdaptiveDeint.Caption:=UTF8Decode('Adaptive');
      MOptions.Caption:=UTF8Decode('옵션 ...');
      MLanguage.Caption:=UTF8Decode('언어');
      MStreamInfo.Caption:=UTF8Decode('클립 정보 보기 ...');
      MShowOutput.Caption:=UTF8Decode('MPlayer 출력 보기 ...');
      MHelp.Caption:=UTF8Decode('도움말');
        MKeyHelp.Caption:=UTF8Decode('단축키 목록 ...');
        MAbout.Caption:=UTF8Decode('이 프로그램은 ...');
  end;
  OptionsForm.BClose.Caption:=UTF8Decode('닫기');
  OptionsForm.HelpText.Text:=UTF8Decode(
'탐색:'^M^J+
'Space'^I'재생/멈춤'^M^J+
'Right'^I'앞으로 10초 이동'^M^J+
'Left'^I'뒤로 10초 이동'^M^J+
'Up'^I'앞으로 1분 이동'^M^J+
'Down'^I'뒤로 1분 이동'^M^J+
'PgUp'^I'앞으로 10분 이동'^M^J+
'PgDn'^I'뒤로 10분 이동'^M^J+
^M^J+
'그외:'^M^J+
'O'^I'OSD 전환'^M^J+
'F'^I'전체화면으로 전환'^M^J+
'C'^I'콤팩트 모드로 전환'^M^J+
'T'^I'항상 위에 놓기'^M^J+
'Q'^I'종료'^M^J+
'9/0'^I'볼륨조절'^M^J+
'-/+'^I'오디오/비디오 싱크 조정'^M^J+
'1/2'^I'밝기 조정'^M^J+
'3/4'^I'선명도 조정'^M^J+
'5/6'^I'색상 조정'^M^J+
'7/8'^I'채도 조정'
  );

  with OptionsForm do begin
    THelp.Caption:=MainForm.MHelp.Caption;
    TAbout.Caption:=UTF8Decode('이 프로그램은');
    LVersionMPUI.Caption:=UTF8Decode('MPUI-hcb 버젼: ');
    LVersionMPlayer.Caption:=UTF8Decode('MPlayer 코어 버젼: ');
    Caption:=UTF8Decode('환경설정');
    BOK.Caption:=UTF8Decode('확인');
    BApply.Caption:=UTF8Decode('적용');
    BSave.Caption:=UTF8Decode('저장');
    LAudioOut.Caption:=UTF8Decode('사운드 출력 드라이버');
      CAudioOut.Items[0]:=UTF8Decode('(디코딩 않음)');
      CAudioOut.Items[1]:=UTF8Decode('(재생 않음)');
    LAudioDev.Caption:=UTF8Decode('다이렉트 사운드 출력 장치');
    LPostproc.Caption:=UTF8Decode('작업순위조정');
      CPostproc.Items[0]:=UTF8Decode('없음');
      CPostproc.Items[1]:=UTF8Decode('자동');
      CPostproc.Items[2]:=UTF8Decode('최대');
    LOCstr_AutoLocale:=UTF8Decode('(자동선택)');
    CIndex.Caption:=UTF8Decode('필요시 파일 인덱스를 재구성');
    CSoftVol.Caption:=UTF8Decode('소프트웨어 볼륨 조정 / 증폭');
    CPriorityBoost.Caption:=UTF8Decode('높은 작업순위로 재생');
    LParams.Caption:=UTF8Decode('MPlayer 파라미터 추가:');
    LHelp.Caption:=THelp.Caption;
  end;
  with PlaylistForm do begin
    Caption:=UTF8Decode('재생목록');
    BPlay.Hint:=UTF8Decode('재생');
    BAdd.Hint:=UTF8Decode('추가 ...');
    BMoveUp.Hint:=UTF8Decode('위로 이동');
    BMoveDown.Hint:=UTF8Decode('밑으로 이동');
    BDelete.Hint:=UTF8Decode('제거');
    CShuffle.Hint:=UTF8Decode('무작위');
    CLoop.Hint:=UTF8Decode('반복');
  end;
  InfoForm.Caption:=UTF8Decode('클립 정보');
  InfoForm.BClose.Caption:=OptionsForm.BClose.Caption;
  LOCstr_NoInfo:=UTF8Decode('클립 정보 보기는 현재 불가능 합니다.');
  LOCstr_InfoFileFormat:=UTF8Decode('포맷');
  LOCstr_InfoPlaybackTime:=UTF8Decode('길이');
  LOCstr_InfoTags:=UTF8Decode('메타데이터');
  LOCstr_InfoVideo:=UTF8Decode('비디오 트랙');
  LOCstr_InfoAudio:=UTF8Decode('오디오 트랙');
  LOCstr_InfoDecoder:=UTF8Decode('디코더');
  LOCstr_InfoCodec:=UTF8Decode('코덱');
  LOCstr_InfoBitrate:=UTF8Decode('비트레이트');
  LOCstr_InfoVideoSize:=UTF8Decode('화면크기');
  LOCstr_InfoVideoFPS:=UTF8Decode('프레임 레이트');
  LOCstr_InfoVideoAspect:=UTF8Decode('비율');
  LOCstr_InfoAudioRate:=UTF8Decode('샘플 레이트');
  LOCstr_InfoAudioChannels:=UTF8Decode('채널');
end;

begin
  RegisterLocale(UTF8Decode('한국어 (Korean)'),Activate,LANG_KOREAN,HANGEUL_CHARSET);
end.

