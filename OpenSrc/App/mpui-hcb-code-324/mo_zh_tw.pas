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
unit mo_zh_tw;
interface
implementation
uses SysUtils,Windows,Locale,Main,Options,plist,Info,Core,Equalizer,DLyric,OpenDevice;

procedure Activate;
begin
  with MainForm do begin
      LOCstr_Status_Opening:=UTF8Decode('正在開啟 ...');
      LOCstr_Status_Closing:=UTF8Decode('正在關閉 ...');
      LOCstr_Status_Playing:=UTF8Decode('播放中');
      LOCstr_Status_Paused:=UTF8Decode('暫停/幀進');
      LOCstr_Status_Stopped:=UTF8Decode('停止');
      LOCstr_Status_Error:=UTF8Decode('無法播放媒體（點此查看更多訊息）');
      LOCstr_SetPW_Caption:=UTF8Decode('請輸入下列文檔的正確解壓密碼');
      LOCstr_VolAsk_Caption:=UTF8Decode('請選擇下一個分卷');
      LOCstr_Check_Mplayer_Prompt:=UTF8Decode('請檢查MPlayer.exe的位置是否正確');
      LOCstr_Error1_Prompt:=UTF8Decode('錯誤代碼(');
      LOCstr_Error2_Prompt:=UTF8Decode('): 在加載MPlayer時');
      LOCstr_CmdLine_Prompt:=UTF8Decode('命令行:');
      OSD_Volume_Prompt:='音量';
      OSD_ScreenShot_Prompt:='截屏 ';
      OSD_Contrast_Prompt:='對比度';
      OSD_Brightness_Prompt:='亮度';
      OSD_Hue_Prompt:='色調';
      OSD_Saturation_Prompt:='飽和度';
      OSD_Gamma_Prompt:='灰度';
      OSD_Enable_Prompt:='啟用';
      OSD_Disable_Prompt:='停用';
      OSD_VideoTrack_Prompt:='視頻軌';
      OSD_AudioTrack_Prompt:='音頻軌';
      OSD_OnTop0_Prompt:='取消置頂';
      OSD_OnTop1_Prompt:='總在最上';
      OSD_OnTop2_Prompt:='播放時總在最上';
      OSD_Auto_Prompt:='自動';
      OSD_Custom_Prompt:='自定義';
      OSD_Size_Prompt:='尺寸';
      OSD_Scale_Prompt:='縮放';
      OSD_Balance_Prompt:='聲道左右平衡';
      OSD_Reset_Prompt:='重置';
      OSD_AudioDelay_Prompt:='音頻延遲';
      OSD_SubDelay_Prompt:='字幕延遲';
      OSD_DownSubtitle_Prompt := '下載 字幕';
      SubFilter:=UTF8Decode('字幕文件');
      AudioFilter:=UTF8Decode('音頻文件');
      AnyFilter:=UTF8Decode('所有文件');
      FontFilter:=UTF8Decode('字體文件');
      MediaFilter:=UTF8Decode('媒體文件');
      LyricFilter:=UTF8Decode('歌詞文件');
    BPause.Hint:=LOCstr_Status_Paused;
    BOpen.Hint:=UTF8Decode('打開 文件');
    BPlaylist.Hint:=UTF8Decode('顯示/隱藏播放清單');
    BStreamInfo.Hint:=UTF8Decode('顯示/隱藏影片資訊');
    BFullscreen.Hint:=UTF8Decode('切換全螢幕模式');
    BCompact.Hint:=UTF8Decode('切換精簡模式');
    BMute.Hint:=UTF8Decode('切換靜音');
    BSkip.Hint:=UTF8Decode('啟用/停止 跳過片頭、片尾');
    SeekBarSlider.Hint:=UTF8Decode('鼠標中鍵/右鍵單擊 設置片頭/片尾位置');
    MPCtrl.Caption:=UTF8Decode('顯示菜單和控制面板');
    OSDMenu.Caption:=UTF8Decode('OSD 模式');
      MNoOSD.Caption:=UTF8Decode('關閉 OSD');
      MDefaultOSD.Caption:=UTF8Decode('預設 OSD');
      MTimeOSD.Caption:=UTF8Decode('顯示時間');
      MFullOSD.Caption:=UTF8Decode('顯示完整時間');
    MFile.Caption:=UTF8Decode('檔案');
      MOpenFile.Caption:=UTF8Decode('播放檔案 ...');
      MOpenDir.Caption:=UTF8Decode('播放目錄 ...');
      MOpenURL.Caption:=UTF8Decode('播放網址 ...');
        LOCstr_OpenURL_Caption:=UTF8Decode('播放網址');
        LOCstr_OpenURL_Prompt:=UTF8Decode('請輸入您想播放的網址');
      MOpenDrive.Caption:=UTF8Decode('播放 (V)CD/DVD/BlueRay 鐳射光碟');
      MOpenDevices.Caption:=UTF8Decode('打開 設備');
      MRFile.Caption:=UTF8Decode('最近打開的檔案');
      MFClear.Caption:=UTF8Decode('清除列表');
      MLoadLyric.Caption:=UTF8Decode('載入歌詞...');
      MDownloadLyric.Caption:=UTF8Decode('下載歌詞...');
      MLoadSub.Caption:=UTF8Decode('載入字幕...');
      MSubfont.Caption:=UTF8Decode('字幕字體...');
	  FontTitle:=UTF8Decode('OSD字體...');
      MClose.Caption:=UTF8Decode('關閉');
      MQuit.Caption:=UTF8Decode('退出');
    MView.Caption:=UTF8Decode('檢視');
      MSizeAny.Caption:=UTF8Decode('自訂畫面大小 (');
      MSCS.Caption:=UTF8Decode('設置 自訂畫面大小');
      MSize50.Caption:=UTF8Decode('一半大小');
      MSize100.Caption:=UTF8Decode('原始大小');
      MSize200.Caption:=UTF8Decode('兩倍大小');
      MFullscreen.Caption:=UTF8Decode('全螢幕');
      MMaxW.Caption:=UTF8Decode('最大化窗口');
      MCompact.Caption:=UTF8Decode('精簡模式');
      MOnTop.Caption:=UTF8Decode('永遠在視窗最上層');
        MNoOnTop.Caption:=UTF8Decode('從不');
        MAOnTop.Caption:=UTF8Decode('總是置頂');
        MWOnTop.Caption:=UTF8Decode('播放時置頂');
      MKaspect.Caption:=UTF8Decode('維持縱橫比');
      MExpand.Caption:=UTF8Decode('用黑邊擴展視頻');
        MNoExpand.Caption:=UTF8Decode('關');
        MSrtExpand.Caption:=UTF8Decode('Srt字幕');
        MSubExpand.Caption:=UTF8Decode('Sub字幕');
      Hide_menu.Caption:=UTF8Decode('自動隱藏 主菜單');
      Mctrl.Caption:=UTF8Decode('自動隱藏 控制面板');
      MTM.Caption:=UTF8Decode('切換 顯示器');
    MSeek.Caption:=LOCstr_Status_Playing;
      MPlay.Caption:=LOCstr_Status_Playing;
      MPause.Caption:=LOCstr_Status_Paused;
      MStop.Caption:=UTF8Decode('停止');
      MPrev.Caption:=UTF8Decode('上一個主題');
      MNext.Caption:=UTF8Decode('下一個主題');
      MShowPlaylist.Caption:=UTF8Decode('播放清單 ...');
      MSpeed.Caption:=UTF8Decode('播放速度');
        MN4X.Caption:=UTF8Decode('1/4倍速');
        MN2X.Caption:=UTF8Decode('1/2倍速');
        M1X.Caption:=UTF8Decode('1倍速');
        M2X.Caption:=UTF8Decode('2倍速');
        M4X.Caption:=UTF8Decode('4倍速');
      MAudiochannels.Caption:=UTF8Decode('聲道');
        MStereo.Caption:=UTF8Decode('立體聲');
        MLchannels.Caption:=UTF8Decode('左聲道');
        MRchannels.Caption:=UTF8Decode('右聲道');
        MMute.Caption:=BMute.Hint;
      MWheelControl.Caption:=UTF8Decode('鼠標滾輪控制');
        MVol.Caption:=UTF8Decode(OSD_Volume_Prompt);
        MSize.Caption:=UTF8Decode(OSD_Size_Prompt);
      MSkip.Caption:=UTF8Decode('跳過片頭片尾');
        MIntro.Caption:=UTF8Decode('開始點 ');
        MEnd.Caption:=UTF8Decode('結束點 ');
        MSIE.Caption:=UTF8Decode('跳過片頭片尾');
      MSeekF10.Caption:=UTF8Decode('向前 10秒');
      MSeekR10.Caption:=UTF8Decode('向後 10秒');
      MSeekF60.Caption:=UTF8Decode('向前 1分鐘');
      MSeekR60.Caption:=UTF8Decode('向後 1分鐘');
      MSeekF600.Caption:=UTF8Decode('向前 10分鐘');
      MSeekR600.Caption:=UTF8Decode('向後 10分鐘');
    MExtra.Caption:=UTF8Decode('工具');
      MAudio.Caption:=UTF8Decode(OSD_AudioTrack_Prompt);
      MSubtitle.Caption:=UTF8Decode('字幕軌');
      MShowSub.Caption:=UTF8Decode('顯示/隱藏 字幕');
      MVideo.Caption:=UTF8Decode(OSD_VideoTrack_Prompt);
      MDVDT.Caption:=UTF8Decode('DVD 標題');
      MBRT.Caption:=UTF8Decode('藍光 標題');
      MRmMenu.Caption:=UTF8Decode('返回主菜單');
      MRnMenu.Caption:=UTF8Decode('返回最近的菜單');
      MVCDT.Caption:=UTF8Decode('VCD 軌');
      MCDT.Caption:=UTF8Decode('CD 軌');
      MAspects.Caption:=UTF8Decode('顯示比例');
        MAutoAspect.Caption:=UTF8Decode('自動偵測');
        MForce43.Caption:=UTF8Decode('4:3');
        MForce169.Caption:=UTF8Decode('16:9');
        MForceCinemascope.Caption:=UTF8Decode('2.35:1');
        MForce54.Caption:=UTF8Decode('5:4');
        MForce85.Caption:=UTF8Decode('16:10');
        MForce221.Caption:=UTF8Decode('2.21:1');
        MForce11.Caption:=UTF8Decode('1:1');
        MForce122.Caption:=UTF8Decode('1.22:1');
        MCustomAspect.Caption:=UTF8Decode('自定義 ');
      MDeinterlace.Caption:=UTF8Decode('反交錯');
        MNoDeint.Caption:=UTF8Decode('關閉');
        MSimpleDeint.Caption:=UTF8Decode('簡單模式');
        MAdaptiveDeint.Caption:=UTF8Decode('適應模式');
      MEqualizer.Caption:=UTF8Decode('視頻均衡器');
      MOptions.Caption:=UTF8Decode('選項 ...');
      MLanguage.Caption:=UTF8Decode('語系');
      MStreamInfo.Caption:=UTF8Decode('顯示影片訊息 ...');
      MUUni.Caption:=UTF8Decode('使用Unicode顯示輸出訊息');
      MShowOutput.Caption:=UTF8Decode('顯示 MPlayer 輸出 ...');
    MVideos.Caption:=UTF8Decode('視頻');
    MAudios.Caption:=UTF8Decode('音頻');
    MSub.Caption:=UTF8Decode('字幕');
    M2ch.Caption:=UTF8Decode('2.0 立體聲');
      M4ch.Caption:=UTF8Decode('4.0 環繞立體聲');
      M6ch.Caption:=UTF8Decode('5.1 環繞立體聲');
      M8ch.Caption:=UTF8Decode('7.1 環繞立體聲');
    MShot.Caption:=UTF8Decode('截取單幀畫面');
    MLoadAudio.Caption:=UTF8Decode('載入伴音');
    MUloadAudio.Caption:=UTF8Decode('卸載伴音');
    MRotate0.Caption:=UTF8Decode('不旋轉');
      MRotate9.Caption:=UTF8Decode('順時針旋轉90度');
      MRotateN9.Caption:=UTF8Decode('逆時針旋轉90度');
    MScale.Caption:=UTF8Decode(OSD_Scale_Prompt)+' '+MVideos.Caption;
      MScale0.Caption:=UTF8Decode(OSD_Reset_Prompt+' '+OSD_Scale_Prompt);
      MScale1.Caption:=UTF8Decode('放大');
      MScale2.Caption:=UTF8Decode('縮小');
    MPan.Caption:=UTF8Decode(OSD_Reset_Prompt+' '+OSD_Balance_Prompt);
      MPan0.Caption:=UTF8Decode(OSD_Balance_Prompt+' 向右');
      MPan1.Caption:=UTF8Decode(OSD_Balance_Prompt+' 向左');
    Mdownloadsubtitle.Caption:=UTF8Decode(OSD_DownSubtitle_Prompt);
    MSubStep.Caption:=UTF8Decode('字幕 語句');
      MSubStep0.Caption:=UTF8Decode('上一句');
      MSubStep1.Caption:=UTF8Decode('下一句');
   SCodepage.Caption:=UTF8Decode('字幕編碼');;
   more1.Caption:=UTF8Decode('更多');
    MAudioDelay.Caption:=UTF8Decode(OSD_AudioDelay_Prompt);
      MAudioDelay0.Caption:=UTF8Decode('延遲 +');
      MAudioDelay1.Caption:=UTF8Decode('延遲 -');
      MAudioDelay2.Caption:=UTF8Decode(OSD_Reset_Prompt+' '+OSD_AudioDelay_Prompt);
    MSubDelay.Caption:=UTF8Decode(OSD_SubDelay_Prompt);
      MSubDelay0.Caption:=MAudioDelay0.Caption;
      MSubDelay1.Caption:=MAudioDelay1.Caption;
      MSubDelay2.Caption:=UTF8Decode(OSD_Reset_Prompt+' '+OSD_SubDelay_Prompt);
   MSubScale.Caption:=UTF8Decode(OSD_Scale_Prompt)+' '+MSub.Caption;
     MSubScale0.Caption:=MScale1.Caption;
     MSubScale1.Caption:=MScale2.Caption;
     MSubScale2.Caption:=UTF8Decode(OSD_Reset_Prompt)+' '+MSub.Caption+UTF8Decode(OSD_Scale_Prompt);
   MHelp.Caption:=UTF8Decode('說明');
     MKeyHelp.Caption:=UTF8Decode('快速鍵說明 ...');
     MAbout.Caption:=UTF8Decode('關於 ...');
  end;
  OptionsForm.HelpText.Text:=UTF8Decode(
'雙擊左鍵'^I'切換全屏'^M^J+
'“Ctrl+左鍵拖曳” 或 “左鍵+右鍵拖曳”'^I'調節視頻寬高比'^M^J+
'“Ctrl+左鍵拖曳字幕” 或 “右鍵拖曳字幕”'^I'縮放 字幕'^M^J+
'中鍵'^I'切換滾輪功能'^M^J+
'“Ctrl+滾輪” 或 “右鍵拖曳” 或 “滾輪+右鍵”'^I'前進/後退 媒體'^M^J+
'左鍵 單擊'^I'播放/暫停'^M^J+
'左鍵拖曳'^I'調節窗體位置'^M^J+
'“Shift+左鍵拖曳” 或 “中鍵拖曳”'^I'縮放視頻'^M^J+
'左鍵拖曳字幕'^I'調節字幕在屏位置'^M^J+
'左鍵 單擊狀態欄時間'^I'切換時間顯示模式'^M^J+
'中鍵/右鍵 單擊進度條滑塊'^I'設置片頭/片尾'^M^J^M^J+
'如果MPUI目錄下存在''MPUI.ini''檔案，MPUI將優先讀取和保存設置到這個檔案'^M^J+
'MPUI將以DVD、VCD、SVCD或藍光的方式打開包含''VIDEO_TS''、''MPEGAV''、''MPEG2'''^M^J+
'或''BDMV''子目錄的目錄');

  with OptionsForm do begin
  	ads.Caption:=UTF8Decode('播放視頻時自動下載字幕');
    Cconfig.Caption:=UTF8Decode('在播放的時候打開配置面板');
    Cconfig.Hint:=UTF8Decode('勾選它或添加":cfg=1"到winamp插件路徑后，在播放的時候將打開配置面板');
    Esubfont.Hint:=UTF8Decode('輸入字體的完整路徑或系統字體目錄下字體的字體名、字體文件名');
    Csubfont.Hint:=Esubfont.Hint;
    Cosdfont.Hint:=Esubfont.Hint;
    Eosdfont.Hint:=Esubfont.Hint;
    LVersionMPUI.Caption:=UTF8Decode('MPUI-hcb 版本: ');
    LVersionMPlayer.Caption:=UTF8Decode('MPlayer 核心版本');
    FY.Caption:=UTF8Decode('作者:');
    Caption:=UTF8Decode('選項');
    BOK.Caption:=UTF8Decode('確認');
    BApply.Caption:=UTF8Decode('套用');
    BSave.Caption:=UTF8Decode('儲存');
    BClose.Caption:=UTF8Decode('關閉');
    TSystem.Caption:=UTF8Decode('系統');
    TLog.Caption:=UTF8Decode('日誌');
    TVideo.Caption:=MainForm.MVideos.Caption;
    TAudio.Caption:=MainForm.MAudios.Caption;
    TSub.Caption:=MainForm.MSub.Caption;
    TAbout.Caption:=UTF8Decode('關於');
	CLS.Caption:=UTF8Decode('彈出 “下載 歌詞/字幕” 對話框');
	CLS.Hint:=UTF8Decode('當mpui不能找到合適的歌詞、字幕時，彈出 “下載 歌詞/字幕” 對話框');
    THelp.Caption:=MainForm.MHelp.Caption;
    CSP.Caption:=UTF8Decode('單擊畫面暫停');
    CRS.Caption:=UTF8Decode('啟動時使用上次的窗體大小');
    CRP.Caption:=UTF8Decode('啟動時使用上次的窗體位置');
    CTime.Caption:=UTF8Decode('在狀態欄顯示系統時間');
    LAudioOut.Caption:=UTF8Decode('音效輸出驅動程式');
      CAudioOut.Items[0]:=UTF8Decode('(不解碼音效)');
      CAudioOut.Items[1]:=UTF8Decode('(不播放音效)');
    LAudioDev.Caption:=UTF8Decode('DirectSound 輸出裝置');
    LPostproc.Caption:=UTF8Decode('後置處理');
      CPostproc.Items[0]:=OptionsForm.BClose.Caption;
      CPostproc.Items[1]:=UTF8Decode('自動');
      CPostproc.Items[2]:=UTF8Decode('最佳品質');
    LOCstr_AutoLocale:=UTF8Decode('(自動選擇)');
    Cone.Caption:=UTF8Decode('僅運行一個MPUI實例');
    CIndex.Caption:=UTF8Decode('必要時重建檔案索引');
    CIndex.Hint:=UTF8Decode('在沒有找到索引的情況下重建AVI文件的索引, 從而允許搜索.'^M^J+
                            '對于損壞的/不完整的下載, 或制作低劣的AVI.');
    CSoftVol.Caption:=UTF8Decode('軟體音量控制/音量增強');
    CGUI.Caption:=UTF8Decode('使用Mplayer的GUI');
    CGUI.Hint:=UTF8Decode('對于那些沒有-nogui選項的Mplayer，也可以勾選此項避免錯誤');
    CRFScr.Caption:=UTF8Decode('右鍵全屏');
    CRFScr.Hint:=UTF8Decode('右鍵進行切換全屏操作時，右鍵菜單將不會彈出');
    CDr.Caption:=UTF8Decode('直接渲染');
    CDr.Hint:=UTF8Decode('打開直接渲染功能(不是所有的編解碼器和視頻輸出都支持),'^M^J+
                         '警告: 可能導致OSD/字幕損壞!');
    double.Caption:=UTF8Decode('雙倍緩存');
    double.Hint:=UTF8Decode('啟用雙倍緩沖. 通過在內存里儲存兩幀來解決閃爍問題,'^M^J+
                            '在顯示一幀的同時解碼另一幀. 會影響OSD. 需要單一緩'^M^J+
                            '沖方式兩倍的內存. 所以不能用于顯存很少的顯卡.');
    CVolnorm.Caption:=UTF8Decode('標準化音量');
    CVolnorm.Hint:=UTF8Decode('最大化文件的音量而不失真');
    nMsgM.Caption:=UTF8Decode('使用nomsgmodule選項');
    nMsgM.Hint:=UTF8Decode('不在每條控制臺信息前添加模塊名稱。對于那些不支持-nomsgmodule選項的Mplayer，'^M^J+
                           '可以取消勾選此項以避免錯誤');
    nFconf.Caption:=UTF8Decode('使用nofontconfig選項');
    nFconf.Hint:=UTF8Decode('對于那些不支持-nofontconfig選項的Mplayer，可以'^M^J+
                            '取消勾選此項以避免錯誤');
    CSPDIF.Caption:=UTF8Decode('通過S/PDIF輸出AC3/DTS');
    LCh.Caption:=UTF8Decode('立體聲模式');
    LRot.Caption:=UTF8Decode('旋轉視頻');
    SSubcode.Caption:=UTF8Decode('字幕編碼:');
    SSubfont.Caption:=UTF8Decode('字幕字體:');
    SOsdfont.Caption:=UTF8Decode('OSD字體:');
    SOsdfont.Hint:=UTF8Decode('最近的Mplayer版本需要單獨設置OSD字體');
    RMplayer.Caption:=UTF8Decode('Mplayer的位置:');
    RCMplayer.Caption:=UTF8Decode('Mplayer和MPUI在同一目錄下');
    CWid.Caption:=UTF8Decode('使用WID');
    LVideoOut.Caption:=UTF8Decode('視效輸出驅動程式');
    CEq2.Caption:=UTF8Decode('使用軟件視頻均衡器');
    CEq2.Hint:=UTF8Decode('用于不支持硬件亮度對比度控制的顯卡/驅動');
    CYuy2.Caption:=UTF8Decode('YUY2色域');
    CYuy2.Hint:=UTF8Decode('指定使用YV12/I420或422P到YUY2的軟件轉換.用于當顯卡/驅動'^M^J+
                           '顯示YV12速度慢而YUY2速度快的情況.');
    CFlip.Caption:=UTF8Decode('上下翻轉視頻');
    CMir.Caption:=UTF8Decode('左右翻轉視頻');
    CVSync.Caption:=UTF8Decode('vsync垂直同步');
    CVSync.Hint:=UTF8Decode('對於解決圖像撕裂情況有所幫助');
    CNi.Caption:=UTF8Decode('使用非交錯的AVI解析器');
    CNi.Hint:=UTF8Decode('用來處理某些質量差的AVI文件的播放');
    CNobps.Caption:=UTF8Decode('不用平均比特率維持AV同步');
    CNobps.Hint:=UTF8Decode('不使用平均比特率值來維持A-V同步(AVI),'^M^J+
                            '對某些文件頭損壞的AVI文件有幫助');
    CFilter.Caption:=UTF8Decode('過濾 拖放的文件');
    CFilter.Hint:=UTF8Decode('通過拖放載入文件時，僅載入支持的媒體文件');
    CDnav.Caption:=UTF8Decode('使用DVD導航菜單');
    CDnav.Hint:=UTF8Decode('如果編譯了DVDNav');
    CUni.Caption:=UTF8Decode('以UNICODE格式處理字幕');
    CUtf.Caption:=UTF8Decode('以UTF-8格式處理字幕');
    SFontColor.Caption:=UTF8Decode('字幕顏色');
    SOutline.Caption:=UTF8Decode('字幕輪廓顏色');
    CEfont.Caption:=UTF8Decode('使用內嵌字體');
    CEfont.Hint:=UTF8Decode('允許抽取 Matroska 內嵌字體，這些字體'^M^J+
                            '能用于 SSA/ASS 字幕渲染');
    CAss.Caption:=UTF8Decode('使用SSA/ASS庫渲染字幕');
    CAss.Hint:=UTF8Decode('打開 SSA/ASS 字幕渲染，libass 將用于 SSA/ASS'^M^J+
                          '外部字幕和 Matroska 內部字幕');
    CISub.Caption:=UTF8Decode('截圖包含字幕');
    SFol.Caption:=UTF8Decode('字幕文字輪廓寬度:');
    SFsize.Caption:=UTF8Decode('字幕文字大小:');
    SFB.Caption:=UTF8Decode('字體模糊半徑:');
    CWadsp.Caption:=UTF8Decode('使用Winamp的DSP插件(如果編譯了Wadsp補丁)');
    Clavf.Caption:=UTF8Decode('使用libavformat進行Demux');
    Clavf.Hint:=UTF8Decode('對某些不能播放的文件,可以試試這個選項,'^M^J+
                           '可能造成時間顯示不準確');
    CFd.Caption:=UTF8Decode('啟用丟幀');
    CFd.Hint:=UTF8Decode('跳過一些幀從而在慢的機器上實現A/V同步.視頻濾鏡不會'^M^J+
                         '應用到這些幀上.對于B幀解碼也會完全跳過');
    CAsync.Caption:=UTF8Decode('自動同步');
    CAsync.Hint:=UTF8Decode('基于音頻延遲的檢測逐步調整A/V同步,對于某些不能連續讀取、'^M^J+
                            '幀速較低的文件（如一些屏幕捕捉的視頻）反而不是很好');
    CCache.Caption:=UTF8Decode('緩存');
    CCache.Hint:=UTF8Decode('設定播放 文件/URL的預緩沖(以kBytes為單位),'^M^J+
                            '對速度慢的媒體特別有用');
    CPriorityBoost.Caption:=UTF8Decode('以高優先級運行');
    CPriorityBoost.Hint:=UTF8Decode('使用高的優先級會避免因系統繁忙造成的播放不流暢的現象，'^M^J+
                                    '有時候可能造成其他的一些問題');
    LMAspect.Caption:=UTF8Decode('顯示器的寬高比');
    LParams.Caption:=UTF8Decode('其它 MPlayer 播放參數: ');
    LHelp.Caption:=THelp.Caption;
    CAddsFiles.Caption:=UTF8Decode('添加連續文件');
    SSF.Caption:=UTF8Decode('保存截圖的目錄');
    SLyric.Caption:=UTF8Decode('歌詞目錄:');
    TLyric.Caption:=UTF8Decode('歌詞');
    Ldlod.Caption:=UTF8Decode('桌面歌詞');
    LTCL.Caption:=UTF8Decode('文字');
    LBCL.Caption:=UTF8Decode('背景');
    LHCL.Caption:=UTF8Decode('高亮');
    TBa.Caption:=UTF8Decode('全選');
    TBn.Caption:=UTF8Decode('無');
    TFadd.Caption:=UTF8Decode('添加');
    TFdel.Caption:=UTF8Decode('刪除');
    TFSet.Caption:=UTF8Decode('關聯');
    TOther.Caption:=UTF8Decode('其他');
    RHK.Caption:=UTF8Decode('重置 快捷鍵');
    HK.Columns[0].Caption:=UTF8Decode('快捷鍵');
    HK.Columns[1].Caption:=UTF8Decode('操作');
    TUnit.Caption:=UTF8Decode('秒/查尋');
    TseekL.Caption:=UTF8Decode('跳躍');
    CDs.Caption:=UTF8Decode('總是顯示視頻界面');
    CAV.Caption:=UTF8Decode('libavcodec解碼線程數');
    
    HK.Hint:=UTF8Decode('按下快捷鍵去查找對應的記錄，雙擊記錄去修改快捷鍵');
    HK.Items[0].SubItems.Strings[0]:=UTF8Decode('增加視頻高度');
    HK.Items[1].SubItems.Strings[0]:=UTF8Decode('減小視頻高度');
    HK.Items[2].SubItems.Strings[0]:=UTF8Decode('減小視頻寬度');
    HK.Items[3].SubItems.Strings[0]:=UTF8Decode('增加視頻寬度');
    HK.Items[4].SubItems.Strings[0]:=UTF8Decode('放大字幕');
    HK.Items[5].SubItems.Strings[0]:=UTF8Decode('縮小字幕');
    HK.Items[6].SubItems.Strings[0]:=UTF8Decode('自定義尺寸');
    HK.Items[7].SubItems.Strings[0]:=MainForm.MSize50.Caption;
    HK.Items[8].SubItems.Strings[0]:=MainForm.MSize100.Caption;
    HK.Items[9].SubItems.Strings[0]:=MainForm.MSize200.Caption;
    HK.Items[10].SubItems.Strings[0]:=UTF8Decode('切換視角');
    HK.Items[11].SubItems.Strings[0]:=MainForm.MEqualizer.Caption;
    HK.Items[12].SubItems.Strings[0]:=UTF8Decode('重置縮放');
    HK.Items[13].SubItems.Strings[0]:=UTF8Decode('開始/停止 截取每幀畫面');
    HK.Items[14].SubItems.Strings[0]:=MainForm.MSubDelay2.Caption;
    HK.Items[15].SubItems.Strings[0]:=UTF8Decode('減小音頻延遲');
    HK.Items[16].SubItems.Strings[0]:=UTF8Decode('增加音頻延遲');
    HK.Items[17].SubItems.Strings[0]:=UTF8Decode('切換 OSD');
    HK.Items[18].SubItems.Strings[0]:=UTF8Decode('重置 視頻均衡器');
    HK.Items[19].SubItems.Strings[0]:=UTF8Decode('切換反交錯(自適應反交錯時有效)');
    HK.Items[20].SubItems.Strings[0]:=UTF8Decode('放大視頻');
    HK.Items[21].SubItems.Strings[0]:=UTF8Decode('縮小視頻');
    HK.Items[22].SubItems.Strings[0]:=UTF8Decode('減小對比');
    HK.Items[23].SubItems.Strings[0]:=UTF8Decode('增大對比');
    HK.Items[24].SubItems.Strings[0]:=UTF8Decode('減小亮度');
    HK.Items[25].SubItems.Strings[0]:=UTF8Decode('增大亮度');
    HK.Items[26].SubItems.Strings[0]:=UTF8Decode('減小色調');
    HK.Items[27].SubItems.Strings[0]:=UTF8Decode('增大色調');
    HK.Items[28].SubItems.Strings[0]:=UTF8Decode('減小飽和');
    HK.Items[29].SubItems.Strings[0]:=UTF8Decode('增大飽和');
    HK.Items[30].SubItems.Strings[0]:=UTF8Decode('減小音量');
    HK.Items[31].SubItems.Strings[0]:=UTF8Decode('增大音量');
    HK.Items[32].SubItems.Strings[0]:=UTF8Decode('減小 gamma');
    HK.Items[33].SubItems.Strings[0]:=UTF8Decode('增大 gamma');
    HK.Items[34].SubItems.Strings[0]:=CFd.Caption;
    HK.Items[35].SubItems.Strings[0]:=MainForm.BFullscreen.Hint;
    HK.Items[36].SubItems.Strings[0]:=UTF8Decode('切換字幕的對齊方式');
    HK.Items[37].SubItems.Strings[0]:=UTF8Decode('向上移動字幕');
    HK.Items[38].SubItems.Strings[0]:=UTF8Decode('向下移動字幕');
    HK.Items[39].SubItems.Strings[0]:=MainForm.MShowSub.Caption;
    HK.Items[40].SubItems.Strings[0]:=MainForm.MShot.Caption;
    HK.Items[41].SubItems.Strings[0]:=UTF8Decode('上一句字幕');
    HK.Items[42].SubItems.Strings[0]:=UTF8Decode('下一句字幕');
    HK.Items[43].SubItems.Strings[0]:=UTF8Decode('減小字幕延遲');
    HK.Items[44].SubItems.Strings[0]:=UTF8Decode('增加字幕延遲');
    HK.Items[45].SubItems.Strings[0]:=UTF8Decode('DVD菜單 - ')+MainForm.MRmMenu.Caption;
    HK.Items[46].SubItems.Strings[0]:=UTF8Decode('DVD菜單 - 選擇');
    HK.Items[47].SubItems.Strings[0]:=UTF8Decode('DVD菜單 - 向上');
    HK.Items[48].SubItems.Strings[0]:=UTF8Decode('DVD菜單 - 向下');
    HK.Items[49].SubItems.Strings[0]:=UTF8Decode('DVD菜單 - 向左');
    HK.Items[50].SubItems.Strings[0]:=UTF8Decode('DVD菜單 - 向右');
    HK.Items[51].SubItems.Strings[0]:=UTF8Decode('DVD菜單 - ')+MainForm.MRnMenu.Caption;
    HK.Items[52].SubItems.Strings[0]:=MainForm.MKaspect.Caption;
    HK.Items[53].SubItems.Strings[0]:=MainForm.Hide_menu.Caption;
    HK.Items[54].SubItems.Strings[0]:=MainForm.Mctrl.Caption;
    HK.Items[55].SubItems.Strings[0]:=MainForm.MCompact.Caption;
    HK.Items[56].SubItems.Strings[0]:=UTF8Decode('下一個字幕編碼 ');
    HK.Items[57].SubItems.Strings[0]:=MainForm.MPCtrl.Caption;
    HK.Items[58].SubItems.Strings[0]:=MainForm.MMaxW.Caption;
    HK.Items[59].SubItems.Strings[0]:=MainForm.MOpenFile.Caption;
    HK.Items[60].SubItems.Strings[0]:=MainForm.MOpenURL.Caption;
    HK.Items[61].SubItems.Strings[0]:=MainForm.MClose.Caption;
    HK.Items[62].SubItems.Strings[0]:=MainForm.MStop.Caption;
    HK.Items[63].SubItems.Strings[0]:=MainForm.MPan.Caption;
    HK.Items[64].SubItems.Strings[0]:=MainForm.MQuit.Caption;
    HK.Items[65].SubItems.Strings[0]:=MainForm.MOpenDir.Caption;
    HK.Items[66].SubItems.Strings[0]:=MainForm.MAudioDelay2.Caption;
    HK.Items[67].SubItems.Strings[0]:=MainForm.MQuit.Caption;
    HK.Items[68].SubItems.Strings[0]:=MainForm.MStereo.Caption;
    HK.Items[69].SubItems.Strings[0]:=MainForm.MLchannels.Caption;
    HK.Items[70].SubItems.Strings[0]:=MainForm.MRchannels.Caption;
    HK.Items[71].SubItems.Strings[0]:=UTF8Decode('向後 '+IntToStr(seekLen)+'秒');
    HK.Items[72].SubItems.Strings[0]:=UTF8Decode('向前 '+IntToStr(seekLen)+'秒');
    HK.Items[73].SubItems.Strings[0]:=MainForm.MSeekF60.Caption;
    HK.Items[74].SubItems.Strings[0]:=MainForm.MSeekR60.Caption;
    HK.Items[75].SubItems.Strings[0]:=MainForm.MSeekF600.Caption;
    HK.Items[76].SubItems.Strings[0]:=MainForm.MSeekR600.Caption;
    HK.Items[77].SubItems.Strings[0]:=UTF8Decode('前進一個章節');
    HK.Items[78].SubItems.Strings[0]:=UTF8Decode('後退一個章節');
    HK.Items[79].SubItems.Strings[0]:=UTF8Decode('重置 速度');
    HK.Items[80].SubItems.Strings[0]:=UTF8Decode('減速');
    HK.Items[81].SubItems.Strings[0]:=UTF8Decode('加速');
    HK.Items[82].SubItems.Strings[0]:=MainForm.MMute.Caption;
    HK.Items[83].SubItems.Strings[0]:=UTF8Decode('切換縱橫比');
    HK.Items[84].SubItems.Strings[0]:=UTF8Decode('切換字幕');
    HK.Items[85].SubItems.Strings[0]:=UTF8Decode('切換視頻軌');
    HK.Items[86].SubItems.Strings[0]:=UTF8Decode('切換節目');
    HK.Items[87].SubItems.Strings[0]:=MainForm.MPan1.Caption;
    HK.Items[88].SubItems.Strings[0]:=MainForm.MPan0.Caption;
    HK.Items[89].SubItems.Strings[0]:=UTF8Decode('切換音軌');
    HK.Items[90].SubItems.Strings[0]:=UTF8Decode('切換 置頂');
    HK.Items[91].SubItems.Strings[0]:=MainForm.MShowPlaylist.Caption;
    HK.Items[92].SubItems.Strings[0]:=MainForm.MOptions.Caption;
    HK.Items[93].SubItems.Strings[0]:=MainForm.MStreamInfo.Caption;
    HK.Items[94].SubItems.Strings[0]:=MainForm.MShowOutput.Caption;
    HK.Items[95].SubItems.Strings[0]:=MainForm.MIntro.Caption;
    HK.Items[96].SubItems.Strings[0]:=MainForm.MEnd.Caption;
    HK.Items[97].SubItems.Strings[0]:=MainForm.MSkip.Caption;
    HK.Items[98].SubItems.Strings[0]:=MainForm.MPause.Caption;
    HK.Items[99].SubItems.Strings[0]:=UTF8Decode('播放/暫停');
    HK.Items[100].SubItems.Strings[0]:=MainForm.MPrev.Caption;
    HK.Items[101].SubItems.Strings[0]:=MainForm.MNext.Caption;
    HK.Items[102].SubItems.Strings[0]:=MainForm.MTM.Caption;
  end;
  with PlaylistForm do begin
    TMLyric.Hint:=UTF8Decode('通過右鍵菜單，可以改變歌詞的編碼');
    Caption:=UTF8Decode('播放清單');
    BPlay.Hint:=UTF8Decode('播放');
    BAdd.Hint:=UTF8Decode('新增 ...');
    BAddDir.Hint:=UTF8Decode('新增目錄 ...');
    BMoveUp.Hint:=UTF8Decode('上移');
    BMoveDown.Hint:=UTF8Decode('下移');
    BDelete.Hint:=UTF8Decode('移除');
    CShuffle.Hint:=UTF8Decode('隨機播放');
    CLoop.Hint:=UTF8Decode('重複播放');
    COneLoop.Hint:=UTF8Decode('循環播放當前');
    BSave.Hint:=UTF8Decode('儲存清單為 ...');
    TntTabSheet1.Caption:=Caption;
    TntTabSheet2.Caption:=UTF8Decode('歌詞');
    CPA.Caption:=UTF8Decode('自動選擇');
    CP0.Caption:=UTF8Decode('系統默認');
    MGB.Caption:=UTF8Decode('簡體<-->繁體');
    MDownloadLyric.Caption:=MainForm.MDownloadLyric.Caption;
    MLoadLyric.Caption:=MainForm.MLoadlyric.Caption;
    CPO.Caption:=UTF8Decode('其他');
    SC.Caption:=UTF8Decode('簡體中文');
    TC.Caption:=UTF8Decode('繁體中文');
    CY0.Caption:=UTF8Decode('Русский (俄文 OEM866)');
    CY.Caption:=UTF8Decode('西里爾文');
    CY4.Caption:=UTF8Decode('Русский (俄文, 20866,KOI8-R)');
    CY6.Caption:=UTF8Decode('Українська (烏克蘭文,21866,KOI8-U)');
    AR.Caption:=UTF8Decode('العربية (阿拉伯文)');
    TU.Caption:=UTF8Decode('Türkiye (土耳其文)');
    HE.Caption:=UTF8Decode('עִבְרִית‎ (希伯來文)');
    JA.Caption:=UTF8Decode('日文');
    KO.Caption:=UTF8Decode('한국어 (韓文)');
    TH.Caption:=UTF8Decode('ภาษาไทย (泰文)');
    FR.Caption:=UTF8Decode('Français(法文)');
    IC.Caption:=UTF8Decode('íslenska (冰島文)');
    BG.Caption:=UTF8Decode('Български (保加利亞文)');
    PO.Caption:=UTF8Decode('Português(葡萄牙文)');
    GR.Caption:=UTF8Decode('Ελληνικά (希臘文)');
    BA.Caption:=UTF8Decode('波羅的海文');
    VI.Caption:=UTF8Decode('Việt (越南文1258,windows-1258)');
    WE.Caption:=UTF8Decode('西歐(1252,iso-8859-1)');
    CE.Caption:=UTF8Decode('中歐');
    ND.Caption:=UTF8Decode('Norsk (挪威文)');
    i18.Caption:=UTF8Decode('國際');
    co.Caption:=UTF8Decode('Hrvatska (克羅地亞文)');
    rm.Caption:=UTF8Decode('Română (羅馬尼亞文)');
    ro.Caption:=UTF8Decode('羅馬文');
    pg.Caption:=UTF8Decode('ਪੰਜਾਬੀ 旁遮普(古爾木其)文');
    gu.Caption:=UTF8Decode('ગુજરાતી (古吉拉特文)');
    ma.Caption:=UTF8Decode('മലയാളം (馬拉亞拉姆文)');
    ka.Caption:=UTF8Decode('ಕನ್ನಡ (卡納達文)');
    oy.Caption:=UTF8Decode('奧里亞文');
    am.Caption:=UTF8Decode('অসমীয়া (阿薩姆文)');
    te.Caption:=UTF8Decode('తెలుగు (泰盧固文)');
    ta.Caption:=UTF8Decode('தமிழ் (泰米爾文)');
    be.Caption:=UTF8Decode('বাংলা (孟加拉文)');
    dv.Caption:=UTF8Decode('संस्कृतम् (梵文)');
  end;
  AddDirCp:=UTF8Decode('選擇一個文件夾');
  with EqualizerForm do begin
    Caption:=MainForm.MEqualizer.Caption;
    BReset.Caption:=UTF8Decode(OSD_Reset_Prompt);
    BClose.Caption:=OptionsForm.BClose.Caption;
    SBri.Caption:=UTF8Decode(OSD_Brightness_Prompt);
    SCon.Caption:=UTF8Decode(OSD_Contrast_Prompt);
    SSat.Caption:=UTF8Decode(OSD_Saturation_Prompt);
    SHue.Caption:=UTF8Decode(OSD_Hue_Prompt);
  end;
  with OpenDevicesForm do begin
    LVideoDevices.Caption:=UTF8Decode('視頻設備');
    LAudioDevices.Caption:=UTF8Decode('音頻設備');
    LCountryCode.Caption:=UTF8Decode('國家代碼');
    TOpen.Caption:=UTF8Decode('打開');
    TScan.Caption:=UTF8Decode('掃描');
    TStop.Caption:=UTF8Decode('停止');
    TView.Caption:=UTF8Decode('查看');
    TPrev.Caption:=UTF8Decode('上一個');
    TNext.Caption:=UTF8Decode('下一個');
    TClear.Caption:=UTF8Decode('清空列表');
    TLoad.Caption:=UTF8Decode('載入列表');
    TSave.Caption:=UTF8Decode('保存列表');
    HK.Columns[0].Caption:=UTF8Decode('頻道');
    HK.Columns[1].Caption:=UTF8Decode('頻率');
  end;
  InfoForm.Caption:=UTF8Decode('影片資訊');
  with DLyricForm do begin
    BSearch.Caption:=UTF8Decode('搜索');
    LyricListView.Column[1].Caption:=UTF8Decode('歌手');
    LyricListView.Column[2].Caption:=UTF8Decode('標題');
    SubListView.Column[1].Caption:=UTF8Decode('片名');
    SubListView.Column[2].Caption:=UTF8Decode('語言');
    SubListView.Column[3].Caption:=UTF8Decode('格式');
    SubListView.Column[4].Caption:=UTF8Decode('CD數');
    SubListView.Column[5].Caption:=UTF8Decode('下載數');
    SubListView.Column[6].Caption:=UTF8Decode('添加日期');
    SSubtitle.Caption:=MainForm.MSub.Caption;
    slyric.Caption:=UTF8Decode('歌詞');
    LArtist.Caption:=LyricListView.Column[1].Caption + ':';
    LTitle.Caption:=LyricListView.Column[2].Caption + ':';
    LSLang.Caption:=SubListView.Column[2].Caption + ':';
    LSTitle.Caption:=LTitle.Caption;
    BApply.Caption:=OptionsForm.BApply.Caption;
    BLApply.Caption:=OptionsForm.BApply.Caption;
    BSave.Caption:=OptionsForm.BSave.Caption;
    BLSave.Caption:=BSave.Caption;
    BSave.Hint:=UTF8Decode('保存 歌詞');
    BLSave.Hint:=UTF8Decode('保存 字幕');
    BClose.Caption:=OptionsForm.BClose.Caption;
    BLClose.Caption:=BClose.Caption;
    BSSearch.Caption:=BSearch.Caption;
  end;
  InfoForm.BClose.Caption:=OptionsForm.BClose.Caption;
  InfoForm.TCB.Caption:=UTF8Decode('拷貝資訊');
  LOCstr_NoInfo:=UTF8Decode('目前沒有可用的影片資訊');
  LOCstr_InfoFileName:=UTF8Decode('影片');
  LOCstr_InfoFileFormat:=UTF8Decode('影片格式');
  LOCstr_InfoPlaybackTime:=UTF8Decode('影片長度');
  LOCstr_InfoTags:=UTF8Decode('影片 metadata');
  LOCstr_InfoVideo:=UTF8Decode(OSD_VideoTrack_Prompt);
  LOCstr_InfoAudio:=UTF8Decode(OSD_AudioTrack_Prompt);
  LOCstr_InfoDecoder:=UTF8Decode('解碼器');
  LOCstr_InfoCodec:=UTF8Decode('CODEC');
  LOCstr_InfoBitrate:=UTF8Decode('平均流量');
  LOCstr_InfoVideoSize:=UTF8Decode('畫面大小');
  LOCstr_InfoVideoFPS:=UTF8Decode('畫面頻率');
  LOCstr_InfoVideoAspect:=UTF8Decode('顯示比例');
  LOCstr_InfoAudioRate:=UTF8Decode('取樣率');
  LOCstr_InfoAudioChannels:=UTF8Decode(' 聲道數');
  IKeyHint:=UTF8Decode('請按下快捷鍵');
  IKeyerror:=UTF8Decode('快捷鍵已被使用');
  IKeyerror1:=UTF8Decode('要覆蓋它嗎？');
  Ccap:=UTF8Decode('章節'); Tcap:=UTF8Decode('軌');
  Acap:=UTF8Decode('視角');
end;

begin
  RegisterLocale(UTF8Decode('繁體中文 (Traditional Chinese)'),Activate,$404,CHINESEBIG5_CHARSET);
end.
