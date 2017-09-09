{   MPUI-hcb, an MPlayer frontend for Windows
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
unit Main;

interface

uses
  Windows, TntWindows, SysUtils, TntSysutils, Variants, Classes, Graphics, Messages,
  Forms, TntForms, Dialogs, TntDialogs, ComCtrls, TntComCtrls, Buttons, TntButtons,
  ExtCtrls, TntExtCtrls, Menus, TntMenus, StdCtrls, TntStdCtrls, ShellAPI, AppEvnts,
  ImgList, TntClipBrd, ToolWin, jpeg, Controls, MultiMon, TntSystem,
  TntFileCtrl, INIFiles, plist;

const
  ES_SYSTEM_REQUIRED = $01;
  ES_DISPLAY_REQUIRED = $02;
const
  VK_MEDIA_NEXT_TRACK = $B0;
  VK_MEDIA_PREV_TRACK = $B1;
  VK_MEDIA_STOP = $B2;
  VK_MEDIA_PLAY_PAUSE = $B3;
  VK_VOLUME_MUTE = $AD;
  VK_VOLUME_DOWN = $AE;
  VK_VOLUME_UP = $AF;

type
  TMainForm = class(TTntForm)
    MainMenu: TTntMainMenu;
    OMFile: TTntMenuItem;
    CPanel: TTntPanel;
    BPlay: TTntSpeedButton;
    BPause: TTntSpeedButton;
    UpdateTimer: TTimer;
    SeekBarFrame: TTntPanel;
    SeekBarSlider: TTntPanel;
    MOpenFile: TTntMenuItem;
    MClose: TTntMenuItem;
    N1: TTntMenuItem;
    MQuit: TTntMenuItem;
    OMView: TTntMenuItem;
    MSize50: TTntMenuItem;
    MSize100: TTntMenuItem;
    MSize200: TTntMenuItem;
    MFullscreen: TTntMenuItem;
    OMSeek: TTntMenuItem;
    MSeekF10: TTntMenuItem;
    MSeekR10: TTntMenuItem;
    MSeekF60: TTntMenuItem;
    MSeekR60: TTntMenuItem;
    MSeekF600: TTntMenuItem;
    MSeekR600: TTntMenuItem;
    N2: TTntMenuItem;
    MPause: TTntMenuItem;
    MPlay: TTntMenuItem;
    N3: TTntMenuItem;
    MOptions: TTntMenuItem;
    MOSD: TTntMenuItem;
    MSizeAny: TTntMenuItem;
    MOpenURL: TTntMenuItem;
    MOnTop: TTntMenuItem;
    OMHelp: TTntMenuItem;
    MAbout: TTntMenuItem;
    MKeyHelp: TTntMenuItem;
    MShowOutput: TTntMenuItem;
    OMExtra: TTntMenuItem;
    N4: TTntMenuItem;
    MLanguage: TTntMenuItem;
    BFullscreen: TTntSpeedButton;
    BStreamInfo: TTntSpeedButton;
    MAudio: TTntMenuItem;
    N5: TTntMenuItem;
    MSubtitle: TTntMenuItem;
    MDeinterlace: TTntMenuItem;
    MOpenDrive: TTntMenuItem;
    MNoDeint: TTntMenuItem;
    MSimpleDeint: TTntMenuItem;
    MAdaptiveDeint: TTntMenuItem;
    OpenDialog: TTntOpenDialog;
    MAspects: TTntMenuItem;
    MAutoAspect: TTntMenuItem;
    MForce43: TTntMenuItem;
    MForce169: TTntMenuItem;
    MForceCinemascope: TTntMenuItem;
    OPanel: TTntPanel;
    Logo: TTntImage;
    IPanel: TTntPanel;
    BPrev: TTntSpeedButton;
    BNext: TTntSpeedButton;
    MPrev: TTntMenuItem;
    MNext: TTntMenuItem;
    MShowPlaylist: TTntMenuItem;
    N6: TTntMenuItem;
    BStop: TTntSpeedButton;
    BPlaylist: TTntSpeedButton;
    PStatus: TTntPanel;
    LTime: TTntLabel;
    SeekBar: TTntPanel;
    VolFrame: TTntPanel;
    VolSlider: TTntPanel;
    BMute: TTntSpeedButton;
    VolImage: TTntImage;
    MAudiochannels: TTntMenuItem;
    N7: TTntMenuItem;
    MMute: TTntMenuItem;
    MStreamInfo: TTntMenuItem;
    VolBoost: TTntPanel;
    BCompact: TTntSpeedButton;
    MCompact: TTntMenuItem;
    MStop: TTntMenuItem;
    LStatus: TTntLabel;
    MenuBar: TTntToolBar;
    MFile: TTntToolButton;
    MView: TTntToolButton;
    MSeek: TTntToolButton;
    MVideos: TTntToolButton;
    MAudios: TTntToolButton;
    MSub: TTntToolButton;
    MExtra: TTntToolButton;
    MHelp: TTntToolButton;
    MVideo: TTntMenuItem;
    N11: TTntMenuItem;
    Hide_menu: TTntMenuItem;
    Mctrl: TTntMenuItem;
    MExpand: TTntMenuItem;
    MNoExpand: TTntMenuItem;
    MSrtExpand: TTntMenuItem;
    MSubExpand: TTntMenuItem;
    N12: TTntMenuItem;
    MSpeed: TTntMenuItem;
    MN4X: TTntMenuItem;
    MN2X: TTntMenuItem;
    M1X: TTntMenuItem;
    M2X: TTntMenuItem;
    M4X: TTntMenuItem;
    MStereo: TTntMenuItem;
    MLchannels: TTntMenuItem;
    MRchannels: TTntMenuItem;
    N14: TTntMenuItem;
    MForce85: TTntMenuItem;
    MForce54: TTntMenuItem;
    MForce221: TTntMenuItem;
    MLoadSub: TTntMenuItem;
    MSubfont: TTntMenuItem;
    N16: TTntMenuItem;
    MCustomAspect: TTntMenuItem;
    MKaspect: TTntMenuItem;
    MNoOnTop: TTntMenuItem;
    MAOnTop: TTntMenuItem;
    MWOnTop: TTntMenuItem;
    BOpen: TTntSpeedButton;
    MForce11: TTntMenuItem;
    MForce122: TTntMenuItem;
    MPopup: TTntPopupMenu;
    MPPlay: TTntMenuItem;
    MPPause: TTntMenuItem;
    MPStop: TTntMenuItem;
    N10: TTntMenuItem;
    MPPrev: TTntMenuItem;
    MPNext: TTntMenuItem;
    N8: TTntMenuItem;
    MPOpenFile: TTntMenuItem;
    MPExpand: TTntMenuItem;
    MPNoExpand: TTntMenuItem;
    MPSrtExpand: TTntMenuItem;
    MPSubExpand: TTntMenuItem;
    N13: TTntMenuItem;
    MPFullscreen: TTntMenuItem;
    MPCtrl: TTntMenuItem;
    MPCompact: TTntMenuItem;
    OSDMenu: TTntMenuItem;
    MPNoOSD: TTntMenuItem;
    MPDefaultOSD: TTntMenuItem;
    MPTimeOSD: TTntMenuItem;
    MPFullOSD: TTntMenuItem;
    N9: TTntMenuItem;
    MPQuit: TTntMenuItem;
    MWheelControl: TTntMenuItem;
    MVol: TTntMenuItem;
    MDVDT: TTntMenuItem;
    SkipBar: TTntPanel;
    MSkip: TTntMenuItem;
    MIntro: TTntMenuItem;
    MEnd: TTntMenuItem;
    MSIE: TTntMenuItem;
    BSkip: TTntSpeedButton;
    BackBar: TTntPanel;
    MPWheelControl: TTntMenuItem;
    MPVol: TTntMenuItem;
    MPSize: TTntMenuItem;
    MSize: TTntMenuItem;
    MNoOSD: TTntMenuItem;
    MDefaultOSD: TTntMenuItem;
    MTimeOSD: TTntMenuItem;
    MFullOSD: TTntMenuItem;
    MOpenDir: TTntMenuItem;
    MMaxW: TTntMenuItem;
    MPMaxW: TTntMenuItem;
    MEqualizer: TTntMenuItem;
    MVCDT: TTntMenuItem;
    MShowSub: TTntMenuItem;
    MRmMenu: TTntMenuItem;
    MRnMenu: TTntMenuItem;
    N17: TTntMenuItem;
    N18: TTntMenuItem;
    OMAudio: TTntMenuItem;
    OMVideo: TTntMenuItem;
    OMSub: TTntMenuItem;
    MFlip: TTntMenuItem;
    MMirror: TTntMenuItem;
    MRotate: TTntMenuItem;
    MChannels: TTntMenuItem;
    M2ch: TTntMenuItem;
    M4ch: TTntMenuItem;
    M6ch: TTntMenuItem;
    MSpdif: TTntMenuItem;
    MRotate0: TTntMenuItem;
    MRotate9: TTntMenuItem;
    MRotateN9: TTntMenuItem;
    N19: TTntMenuItem;
    MShot: TTntMenuItem;
    N20: TTntMenuItem;
    MSEqualizer: TTntMenuItem;
    MLoadAudio: TTntMenuItem;
    N22: TTntMenuItem;
    MSoftVol: TTntMenuItem;
    N23: TTntMenuItem;
    MUloadAudio: TTntMenuItem;
    MScale: TTntMenuItem;
    MScale0: TTntMenuItem;
    MScale1: TTntMenuItem;
    MScale2: TTntMenuItem;
    MPan: TTntMenuItem;
    N24: TTntMenuItem;
    MPan0: TTntMenuItem;
    MPan1: TTntMenuItem;
    MCX: TTntMenuItem;
    MPostproc: TTntMenuItem;
    MPostOff: TTntMenuItem;
    MPostAuto: TTntMenuItem;
    MPostquality: TTntMenuItem;
    N25: TTntMenuItem;
    N26: TTntMenuItem;
    N27: TTntMenuItem;
    MUseASS: TTntMenuItem;
    N15: TTntMenuItem;
    MLoopAll: TTntMenuItem;
    MOneLoop: TTntMenuItem;
    MShuffle: TTntMenuItem;
    N28: TTntMenuItem;
    MAudioDelay: TTntMenuItem;
    MAudiodelay0: TTntMenuItem;
    MAudioDelay1: TTntMenuItem;
    MAudioDelay2: TTntMenuItem;
    N29: TTntMenuItem;
    MSubDelay: TTntMenuItem;
    N30: TTntMenuItem;
    MSubDelay0: TTntMenuItem;
    MSubDelay1: TTntMenuItem;
    N31: TTntMenuItem;
    MSubDelay2: TTntMenuItem;
    MSubStep: TTntMenuItem;
    MSubStep0: TTntMenuItem;
    MSubStep1: TTntMenuItem;
    N32: TTntMenuItem;
    MForce155: TTntMenuItem;
    MLoadlyric: TTntMenuItem;
    N33: TTntMenuItem;
    N34: TTntMenuItem;
    MUUni: TTntMenuItem;
    MSubScale: TTntMenuItem;
    MSubScale0: TTntMenuItem;
    MSubScale1: TTntMenuItem;
    N21: TTntMenuItem;
    MSubScale2: TTntMenuItem;
    MSCS: TTntMenuItem;
    N35: TTntMenuItem;
    MRFile: TTntMenuItem;
    N36: TTntMenuItem;
    MFClear: TTntMenuItem;
    N37: TTntMenuItem;
    Imagery: TImageList;
    M8ch: TTntMenuItem;
    MOpenDevices: TTntMenuItem;
    Mdownloadsubtitle: TTntMenuItem;
    N38: TTntMenuItem;
    MDownloadLyric: TTntMenuItem;
    MCDT: TTntMenuItem;
    SCodepage: TTntMenuItem;
    SSD: TTntMenuItem;
    UTF1: TTntMenuItem;
    UT1: TTntMenuItem;
    UTF16BE1: TTntMenuItem;
    GB180301: TTntMenuItem;
    BIG51: TTntMenuItem;
    SHIFTJIS1: TTntMenuItem;
    ISO2022JP1: TTntMenuItem;
    ISO2022CN1: TTntMenuItem;
    ISO2022KR1: TTntMenuItem;
    ISO885951: TTntMenuItem;
    ISO885971: TTntMenuItem;
    ISO885981: TTntMenuItem;
    EUCJP1: TTntMenuItem;
    EUCKR1: TTntMenuItem;
    EUCTW1: TTntMenuItem;
    KOI8R1: TTntMenuItem;
    IBM8551: TTntMenuItem;
    IBM8552: TTntMenuItem;
    WINDOWS12511: TTntMenuItem;
    WINDOWS12521: TTntMenuItem;
    WINDOWS12531: TTntMenuItem;
    WINDOWS12551: TTntMenuItem;
    N39: TTntMenuItem;
    N40: TTntMenuItem;
    more1: TTntMenuItem;
    HZ1: TTntMenuItem;
    ISO885921: TTntMenuItem;
    WINDOWS12501: TTntMenuItem;
    MBRT: TTntMenuItem;
    N41: TTntMenuItem;
    MTM: TTntMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BPlayClick(Sender: TObject);
    procedure BPauseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HotKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure SeekBarSliderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SeekBarSliderMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SeekBarSliderMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SeekBarFrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SimulateKey(Sender: TObject);
    procedure MSizeClick(Sender: TObject);
    procedure MShowOutputClick(Sender: TObject);
    procedure MOSDClick(Sender: TObject);
    procedure MCloseClick(Sender: TObject);
    procedure MAudioClick(Sender: TObject);
    procedure MSubtitleClick(Sender: TObject);
    procedure MDVDCClick(Sender: TObject);
    procedure MDVDAClick(Sender: TObject);
    procedure MVCDTClick(Sender: TObject);
    procedure MRFClick(Sender: TObject);
    procedure MAudiochannelsClick(Sender: TObject);
    procedure MSpeedClick(Sender: TObject);
    procedure MVideoClick(Sender: TObject);
    procedure UpdateMenus(Sender: TObject);
    procedure MDeinterlaceClick(Sender: TObject);
    procedure MOpenURLClick(Sender: TObject);
    procedure MOpenDriveClick(Sender: TObject);
    procedure MKeyHelpClick(Sender: TObject);
    procedure MAboutClick(Sender: TObject);
    procedure MLanguageClick(Sender: TObject);
    procedure MAspectClick(Sender: TObject);
    procedure MOptionsClick(Sender: TObject);
    procedure BPrevNextClick(Sender: TObject);
    procedure MShowPlaylistClick(Sender: TObject);
    procedure BStopClick(Sender: TObject);
    procedure SeekBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VolSliderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VolSliderMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure VolSliderMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BMuteClick(Sender: TObject);
    procedure MStreamInfoClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DisplayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DisplayClick(Sender: TObject);
    procedure DisplayDblClick(Sender: TObject);
    procedure DisplayMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure DisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MPopupPopup(Sender: TObject);
    procedure MPCtrlClick(Sender: TObject);
    procedure LStatusClick(Sender: TObject);
    procedure VolBoostClick(Sender: TObject);
    procedure MExpandClick(Sender: TObject);
    procedure MctrlClick(Sender: TObject);
    procedure Hide_menuClick(Sender: TObject);
    procedure ToggleAlwaysOnTop(Sender: TObject);
    procedure MLoadsubClick(Sender: TObject);
    procedure MSubfontClick(Sender: TObject);
    procedure MKaspectClick(Sender: TObject);
    procedure LTimeClick(Sender: TObject);
    procedure MWheelControlClick(Sender: TObject);
    procedure MIntroClick(Sender: TObject);
    procedure MEndClick(Sender: TObject);
    procedure MSIEClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MOpenDirClick(Sender: TObject);
    procedure MEqualizerClick(Sender: TObject);
    procedure MQuitClick(Sender: TObject);
    procedure MChannelsClick(Sender: TObject);
    procedure MFlipClick(Sender: TObject);
    procedure MMirrorClick(Sender: TObject);
    procedure MRotateClick(Sender: TObject);
    procedure MSpdifClick(Sender: TObject);
    procedure MSEqualizerClick(Sender: TObject);
    procedure MLoadAudioClick(Sender: TObject);
    procedure MSoftVolClick(Sender: TObject);
    procedure MUloadAudioClick(Sender: TObject);
    procedure VolImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MScale0Click(Sender: TObject);
    procedure MPanClick(Sender: TObject);
    procedure MPostprocClick(Sender: TObject);
    procedure MUseASSClick(Sender: TObject);
    procedure MOneLoopClick(Sender: TObject);
    procedure MLoopAllClick(Sender: TObject);
    procedure MShuffleClick(Sender: TObject);
    procedure MAudioDelay2Click(Sender: TObject);
    procedure MSubDelay2Click(Sender: TObject);
    procedure MLoadlyricClick(Sender: TObject);
    procedure MUUniClick(Sender: TObject);
    procedure MSubScale2Click(Sender: TObject);
    procedure MSCSClick(Sender: TObject);
    procedure MFClearClick(Sender: TObject);
    procedure MOpenDevicesClick(Sender: TObject);
    procedure MdownloadsubtitleClick(Sender: TObject);
    procedure MDownloadLyricClick(Sender: TObject);
    procedure SSDClick(Sender: TObject);
    procedure more1Click(Sender: TObject);
    procedure MTMClick(Sender: TObject);

  private
    { Private declarations }
    FirstShow, Seeking, CV, MV: boolean;
    WStyle: longint; WheelRolled: boolean;
    FS_PX, FS_PY, FS_SX, FS_SY, lm, lw, lh, SeekMouseX, ViewMode: integer;
    HideMouseAt, UpdateSeekBarAt: Cardinal; //,ScreenSaverActive:Cardinal;
    procedure FormDropFiles(var msg: TMessage); message WM_DROPFILES;
    procedure Init_MOpenDrive;
    procedure Init_MLanguage;
    procedure FormGetMinMaxInfo(var msg: TMessage); message WM_GETMINMAXINFO;
    procedure FormMove(var msg: TMessage); message WM_MOVE;
    procedure FormWantSpecialKey(var msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure PassMsg(var msg: Tmessage); message $0401;
    procedure HandleLog(var msg: Tmessage); message $0402;
  public
    { Public declarations }
    procedure UpdateMRF;
    procedure FixSize;
    procedure SetupPlay;
    procedure SetupStop;
    procedure UpdateSeekBar;
    procedure Unpaused;
    procedure VideoSizeChanged;
    procedure DoOpen(const URL, DisplayName: widestring);
    procedure SetFullscreen(Mode: boolean);
    procedure SetCompact(Mode: boolean);
    procedure NextAudio;
    procedure NextMonitor;
    procedure NextVideo;
    procedure NextSub;
    procedure NextSubCP;
    procedure NextAspect;
    procedure NextAngle;
    procedure NextOnTop;
    procedure NextFile(Direction: integer; ExitState: TPlaybackState);
    procedure UpdateStatus;
    procedure UpdateParams;
    procedure UpdateTime;
    procedure UpdateCaption;
    procedure UpdateVolSlider;
    procedure SetVolumeRel(Increment: integer);
    procedure UpdateDockedWindows;
    procedure Localize;
    procedure SetCtrlV(Mode: boolean);
    procedure SetMenuBarV(Mode: boolean);
    procedure SetMouseV(Mode: boolean);
    procedure UpdateMenuEV(Mode: boolean);
    procedure UpdateMenuCheck;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TDDEnumCallbackEx = function(lpGuid: PGUID; lpDriverDescription, lpDriverName: PChar; lpContext: pointer; hm: HMONITOR): LongBool; stdcall;
  TDownSubtitle_CallBackFinish = procedure(number, bad_number: Integer); stdcall;
  TDownSubtitle_CallBackW = procedure(const sub_path: PWChar; is_eng, sub_delay: Integer); stdcall;

var MainForm: TMainForm; IsUser32Loaded: THandle = 0; IsSLoaded: THandle = 0;
  DownloaderSubtitleW: function(const filepath: PWChar; eng_sub: Boolean; Callback: TDownSubtitle_CallBackW; callbf: TDownSubtitle_CallBackFinish): Integer; stdcall;
  UpdateLyricShowForm: function(Handle: THandle; hdcDest: HDC; pptDst: PPoint; _psize: PSize;
    hdcSrc: HDC; pptSrc: PPoint; crKey: COLORREF; pblend: PBLENDFUNCTION; dwFlags: DWORD): Boolean; stdcall;
procedure DownSubtitle_CallBackFinish(number, bad_number: integer); stdcall;
procedure DownSubtitle_CallBackW(const sub_path: PWChar; is_eng, sub_delay: Integer); stdcall;
procedure LoadSLibrary;
procedure UnLoadSLibrary;
procedure LoadUser32Library;
procedure UnLoadUser32Library;

implementation
uses Locale, Config, Options, Info, UnRAR, Equalizer, SevenZip, Core, DLyric,
  OpenDevice, GDIPAPI, GDIPOBJ, LyricShow, MediaInfoDll;

{$R *.dfm}

function SetThreadExecutionState(esFlags: Cardinal): Cardinal; stdcall; external kernel32;

procedure LoadUser32Library;
begin
  if IsUser32Loaded <> 0 then exit;
  IsUser32Loaded := Tnt_LoadLibraryW('user32.dll');
  if IsUser32Loaded <> 0 then begin
    @UpdateLyricShowForm := GetProcAddress(IsUser32Loaded, 'UpdateLayeredWindow');
  end;
end;

procedure UnLoadUser32Library;
begin
  if IsUser32Loaded <> 0 then begin
    FreeLibrary(IsUser32Loaded);
    IsUser32Loaded := 0;
    UpdateLyricShowForm := nil;
  end;
end;

procedure LoadSLibrary;
begin
  if IsSLoaded <> 0 then exit;
  IsSLoaded := Tnt_LoadLibraryW(sddll);
  if IsSLoaded <> 0 then begin
    @DownloaderSubtitleW := GetProcAddress(IsSLoaded, 'DownloaderSubtitleW');
  end;
end;

procedure UnLoadSLibrary;
begin
  if IsSLoaded <> 0 then begin
    FreeLibrary(IsSLoaded);
    IsSLoaded := 0;
    DownloaderSubtitleW := nil;
  end;
end;

procedure DownSubtitle_CallBackFinish(number, bad_number: integer); stdcall;
begin
  if number > bad_number then dsEnd := true;
end;

procedure DownSubtitle_CallBackW(const sub_path: PWChar; is_eng, sub_delay: Integer); stdcall;
var s, i: integer; j: WideString;
begin
  VobFileCount := 0; s := 0;
  Loadsub := 1; j := Tnt_WideLowerCase(WideExtractFileExt(sub_path));
  if j = '.idx' then begin
    j := GetFileName(sub_path);
    if not WideFileExists(j + '.sub') then j := loadArcSub(sub_path);
    if j <> '' then begin
      inc(VobFileCount);
      if VobFileCount = 1 then begin
        Vobfile := j; LoadVob := 1; Restart;
      end;
    end;
  end
  else begin
    i := CheckInfo(MediaType, j);
    if (i > -1) and (i <= ZipTypeCount) then begin
      if IsLoaded(j) then begin
        j := ExtractSub(sub_path, playlist.FindPW(sub_path));
        if j <> '' then begin
          inc(VobFileCount);
          if VobFileCount = 1 then begin
            Vobfile := j; LoadVob := 1; Restart;
          end;
        end;
      end;
    end
    else begin
      j := sub_path;
      if (not IsWideStringMappableToAnsi(j)) or (pos(',', j) > 0) then j := WideExtractShortPathName(j);
      if pos(j, substring) = 0 then begin
        if not Win32PlatformIsUnicode then begin
          Loadsub := 2; Loadsrt := 2;
          AddChain(s, substring, EscapeParam(j));
        end
        else
          SendCommand('sub_load ' + Tnt_WideStringReplace(EscapeParam(j), '\', '/', [rfReplaceAll]));
      end;
    end;
  end;
  if (not Win32PlatformIsUnicode) and (s > 0) then Restart;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
//AllocConsole;
  randomize;
{$IFDEF VER150}
  // some fixes for Delphi>=7 VCLs
  OPanel.ParentBackground := False; IPanel.ParentBackground := False;
  PStatus.ParentBackground := False; SeekBar.ParentBackground := False;
  SkipBar.ParentBackground := False; BackBar.ParentBackground := False;
  VolSlider.ParentBackground := False; SeekBarSlider.ParentBackground := False;
{$ENDIF}
  CurMonitor := Screen.MonitorFromWindow(Handle);
  if CurMonitor = nil then CurMonitor := Screen.Monitors[0];
  MonitorW := CurMonitor.Width; MonitorH := CurMonitor.Height;
  MonitorID := CurMonitor.MonitorNum;

  FirstShow := true; AutoQuit := false; ViewMode := 0;
  HideMouseAt := 0; UpdateSeekBarAt := 0; PlayMsgAt := 0;
  WantFullscreen := false; WantCompact := false;
  Constraints.MinWidth := Width; Constraints.MinHeight := Height;
  Load(HomeDir + 'autorun.inf', 0); Load(HomeDir + DefaultFileName, 0);
  if subcode = '' then subcode := 'CP' + IntToStr(LCIDToCodePage(LOCALE_USER_DEFAULT)); //AnsiCodePage
  SSD.Caption := subcode; SSD.Checked := True;
  UpdateVolSlider;
  if Wid and Win32PlatformIsUnicode and ds then begin
    SetWindowLong(Handle, GWL_STYLE, DWORD(GetWindowLong(Handle, GWL_STYLE)) or WS_SIZEBOX or WS_MAXIMIZEBOX);
    Opanel.Visible := true; Logo.Visible := true; MFullscreen.Visible := true;
    MCompact.Visible := true; MPFullscreen.Visible := true; MMaxW.Visible := true;
    Hide_menu.Visible := true; Mctrl.Visible := true; MPCtrl.Visible := true; MPMaxW.Visible := true;
    MPCompact.Visible := true; BFullscreen.Enabled := true; BCompact.Enabled := true;
    if EW < OPanel.Width then EW := OPanel.Width;
    if RS then Width := Width - OPanel.Width + EW;
  end;
  Left := CurMonitor.Left + (CurMonitor.Width - Width) div 2;
  if RP then Left := EL;
  if Wid and Win32PlatformIsUnicode then begin
    if ds then begin
      if RS then begin
        if EH < defaultHeight then EH := defaultHeight;
        Height := MWC + MenuBar.Height + CPanel.Height + Width - OPanel.Width + EH;
        Top := CurMonitor.Top + (CurMonitor.Height - Height) div 2;
      end
      else begin
        Top := CurMonitor.Top + (CurMonitor.Height - defaultHeight) div 2 - 60;
        Height := defaultHeight;
      end;
    end
    else Top := CurMonitor.Top + (CurMonitor.Height - Height) div 2;
    if RP then Top := ET;
  end
  else Top := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - Height;

  if RFScr then begin
    OPanel.PopupMenu := nil; IPanel.PopupMenu := nil;
  end
  else begin
    OPanel.PopupMenu := MPopup; IPanel.PopupMenu := MPopup;
  end;
  Init_MLanguage; TeeGDIPlusStartup; LoadUser32Library;
  dlod := dlod and (GdipHandle > 0) and Assigned(UpdateLyricShowForm);
  with Logo do ControlStyle := ControlStyle + [csOpaque];
  with IPanel do ControlStyle := ControlStyle + [csOpaque];
  MOSD.Items[OSDLevel].Checked := true; OSDMenu.Items[OSDLevel].Checked := true;
  if OnTop = 1 then SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
//  SystemParametersInfo(SPI_GETSCREENSAVEACTIVE,0,@ScreenSaverActive, 0);
//  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,0,nil, 0);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  procArc := false; ForceStop; ClearTmpFiles(TempDir);
//  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, ScreenSaverActive, nil, 0);
  Config.Save(HomeDir + DefaultFileName, 1);
  UnLoadRarLibrary; UnLoadZipLibrary; UnLoad7zLibrary;
  UnLoadShell32Library; UnLoadDsLibrary;
  UnLoadSLibrary; UnLoadCLibrary; UnLoadUser32Library;
  UnLoadMediaInfoLibrary;
  FontPaths.Free; SetErrorMode(0);
end;

procedure TMainForm.FormShow(Sender: TObject);
var i, PCount: integer; FileName: WideString; IsFirst: boolean;
  t: TTntMenuItem;
begin
  UpdateDockedWindows;
  if FirstShow then begin
    FirstShow := false;
    if not Win32PlatformIsUnicode then begin
      MPause.Visible := false; MPPause.Visible := false;
      BPause.Enabled := false;
    end;

    CurMonitor := Screen.MonitorFromWindow(Handle);
    if CurMonitor = nil then CurMonitor := Screen.Monitors[0];
    MonitorW := CurMonitor.Width; MonitorH := CurMonitor.Height;
    MonitorID := CurMonitor.MonitorNum;
    if Width > MonitorW then Width := MonitorW; if Height > MonitorH then Height := MonitorH;
    if (Left < CurMonitor.Left) or ((Left + Width) > (CurMonitor.Left + CurMonitor.Width)) then
      Left := CurMonitor.Left + (CurMonitor.Width - Width) div 2;
    if (Top < CurMonitor.Top) or ((Top + Height) > (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)) then begin
      if Wid and Win32PlatformIsUnicode then
        Top := CurMonitor.Top + (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - Height) div 2
      else Top := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - Height;
    end;

    for i := 0 to Screen.MonitorCount - 1 do begin
      t := TTntMenuItem.Create(MTM);
      t.Caption := IntToStr(i); t.Tag := i; t.GroupIndex := $0A;
      t.RadioItem := true; t.OnClick := MTMClick;
      MTM.Add(t);
    end;
    MTM.Items[CurMonitor.MonitorNum].Checked := true;

    ActivateLocale(DefaultLocale); DragAcceptFiles(Handle, true);
    Application.ProcessMessages;

    if WideParamStr(1) <> '' then begin
      PCount := WideParamCount; IsFirst := true;
      for i := 1 to PCount do begin
        FileName := WideParamStr(i);
        if not CheckOption(FileName) then begin
          if IsFirst then begin
            PClear := true; EndOpenDir := true; IsFirst := false;
          end;
          if WideDirectoryExists(FileName) then Playlist.AddDirectory(FileName, false)
          else Playlist.AddFiles(FileName, false);
        end;
      end;
    end
    else begin
      if AutoPlay then begin
        PClear := true; EndOpenDir := true;
        Playlist.AddDirectory('.', false);
      end;
    end;
    Playlist.Changed;
  end;
end;

procedure TMainForm.FormHide(Sender: TObject);
begin
  DragAcceptFiles(Handle, false);
end;

procedure TMainForm.FormDropFiles(var msg: TMessage);
var hDrop: THandle; fnbuf, j, t: widestring; k: boolean;
  i, DropCount, s, a: integer; FList: TWStringList;
  tw: array[0..1024] of wideChar; ta: array[0..1024] of Char;
begin
  hDrop := msg.wParam;
  if Win32PlatformIsUnicode then DropCount := DragQueryFileW(hDrop, cardinal(-1), nil, 0)
  else DropCount := DragQueryFile(hDrop, cardinal(-1), nil, 0);
  VobFileCount := 0; s := 0;
  FList := TWStringList.Create;
  for i := 0 to DropCount - 1 do begin
    if Win32PlatformIsUnicode then begin
      DragQueryFileW(hDrop, i, tw, 1024); fnbuf := tw;
    end
    else begin
      DragQueryFile(hDrop, i, ta, 1024); fnbuf := WideString(ta);
    end;
    FList.Add(fnbuf);
  end;
  FList.SortStr(plist.mysort);
  for i := 0 to DropCount - 1 do begin
    fnbuf := FList[i];
    if WideDirectoryExists(fnbuf) then begin
      if i = 0 then begin PClear := true; EndOpenDir := true; end;
      Playlist.AddDirectory(fnbuf, false);
    end
    else begin
      j := Tnt_WideLowerCase(WideExtractFileExt(fnbuf));
      a := CheckInfo(MediaType, j);
      if FilterDrop then k := a > ZipTypeCount
      else k := (CheckInfo(SubType, j) = -1) and ((a = -1) or (a > ZipTypeCount));
      if k then begin
        if i = 0 then begin PClear := true; EndOpenDir := true; end;
        Playlist.AddFiles(fnbuf, false);
      end
      else begin
        if j = '.idx' then begin
          if Running and HaveVideo then begin
            j := GetFileName(fnbuf); Loadsub := 1;
            if not WideFileExists(j + '.sub') then j := loadArcSub(fnbuf);
            if j <> '' then begin
              inc(VobFileCount);
              if VobFileCount = 1 then begin
                Vobfile := j; LoadVob := 1; Restart;
              end;
            end;
          end;
        end
        else begin
          if (a > -1) and (a <= ZipTypeCount) then begin
            if IsLoaded(j) then begin
              TmpPW := playlist.FindPW(fnbuf);
              if AddMovies(fnbuf, TmpPW, false, false) > 0 then begin //因为AddDir使用多线程，所以不能扰乱TmpPW，就不修改TmpPW了
                if i = 0 then begin PClear := true; EndOpenDir := true; end;
                AddMovies(fnbuf, TmpPW, true, false);
              end;
              if Running and HaveVideo then begin
                Loadsub := 1;
                t := ExtractSub(fnbuf, TmpPW);
                if t <> '' then begin
                  inc(VobFileCount);
                  if VobFileCount = 1 then begin
                    Vobfile := t; LoadVob := 1; Restart;
                  end;
                end;
              end;
              if HaveLyric = 0 then ExtractLyric(fnbuf, TmpPW);
            end;
          end
          else begin
            if j = '.lrc' then begin
              {j:=WideExtractFileName(MediaURL);
              j:=Tnt_WideLowerCase(GetFileName(j));
              t:=WideExtractFileName(fnbuf);
              t:=Tnt_WideLowerCase(GetFileName(t));
              if j=t then   }
              if HaveLyric = 0 then Lyric.ParseLyric(fnbuf);
            end
            else if Running then begin
              Loadsub := 1;
              t := fnbuf;
              if (not IsWideStringMappableToAnsi(t)) or (pos(',', t) > 0) then t := WideExtractShortPathName(t);
              if pos(t, substring) = 0 then begin
                if not Win32PlatformIsUnicode then begin
                  Loadsub := 2; Loadsrt := 2;
                  AddChain(s, substring, EscapeParam(t));
                end
                else
                  SendCommand('sub_load ' + Tnt_WideStringReplace(EscapeParam(t), '\', '/', [rfReplaceAll]));
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  DragFinish(hDrop);
  FList.Free;
  Playlist.Changed;
  if (not Win32PlatformIsUnicode) and (s > 0) then Restart;
  msg.Result := 0;
end;

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WinClassName := 'hcb428';
end;

procedure TMainForm.HandleLog(var msg: TMessage);
begin
  if Boolean(Msg.wParam) then begin
    HandleInputLine(PString(Msg.lParam)^); dispose(PString(Msg.lParam));
  end;
end;

procedure TMainForm.PassMsg(var msg: Tmessage);
var OpenFileName: WideString; t: string;
begin
  if not Win32PlatformIsUnicode then begin
    SetLength(t, msg.LParam);
    GlobalGetAtomName(msg.WParam, PChar(t), msg.LParam + 1);
    OpenFileName := WideString(t);
  end
  else begin
    SetLength(OpenFileName, msg.LParam);
    GlobalGetAtomNameW(msg.WParam, PWChar(OpenFileName), msg.LParam + 1);
  end;
  GlobalDeleteAtom(msg.WParam);
  if not CheckOption(OpenFileName) then begin
    if not HaveMsg then begin
      PClear := true; EndOpenDir := true; HaveMsg := true;
      if IsIconic(Application.Handle) then Application.Restore
      else Application.BringToFront;
      SetForegroundWindow(Application.Handle);
    end;
    if WideDirectoryExists(OpenFileName) then Playlist.AddDirectory(OpenFileName, true)
    else Playlist.AddFiles(OpenFileName, true);
    Playlist.Changed;
  end;
end;

procedure TMainForm.DoOpen(const URL, DisplayName: widestring);
begin
  ForceStop;
  Sleep(50); // wait for the processing threads to finish
  Application.ProcessMessages; // let the VCL process the finish messages
  if Firstrun then MediaURL := URL; //MakeURL(URL,DisplayURL);
  DisplayURL := DisplayName;
  UpdateCaption;
  FirstOpen := true;
  Start;
end;

procedure TMainForm.BPlayClick(Sender: TObject);
begin
  if BPause.Down then SendCommand('pause')
  else if not Running then NextFile(0, psPlaying);
  BPlay.Down := Running;
end;

procedure TMainForm.BPauseClick(Sender: TObject);
begin
  BPause.Down := True;
  if core.Status = sPaused then SendCommand('frame_step')
  else SendCommand('pause');
end;

procedure TMainForm.Unpaused;
begin
  if core.Status = sPaused then begin
    BPause.Down := false; BPlay.Down := true;
    core.Status := sPlaying; UpdateStatus;
    SendCommand('set_property mute 0');
  end;
end;

procedure TMainForm.UpdateVolSlider;
begin
  if Volume < 0 then Volume := 0;
  if (Volume > 100) and (not SoftVol) then Volume := 100;
  if Volume > 1000 then Volume := 1000;
  if Volume > 100 then begin
    VolBoost.Visible := True;
    VolBoost.Caption := IntToStr(Volume) + '%';
  end
  else begin
    VolBoost.Visible := False;
    VolSlider.Left := Volume * (VolFrame.ClientWidth - VolSlider.Width) div 100;
  end;
end;

procedure TMainForm.SetVolumeRel(Increment: integer);
begin
  if mute then exit;
  if (Volume > 100) or ((Volume = 100) and (Increment > 0))
    then Increment := Increment * 10 div 3; // bigger volume change steps if >100%
  inc(Volume, Increment);
  UpdateVolSlider;
  SendVolumeChangeCommand(Volume);
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if OptionsForm.HotKeyToOldKey(Shift, Key) = nil then begin
    Key := 0; Shift := [];
  end
  else HotKeyDown(Sender, Key, Shift);
end;

procedure TMainForm.HotKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var i, j: integer; t: TMenuItem;
  procedure HandleCommand(const Command: string); begin
    if not Win32PlatformIsUnicode then exit;
    SendCommand(Command);
  end;
  procedure HandleSeekCommand(const Command: string); begin
    if not Win32PlatformIsUnicode then exit;
    if core.Status = sPaused then SendCommand(Command)
    else begin
      SendCommand('set_property mute 1');
      SendCommand(Command);
      SendCommand('set_property mute 0');
    end;
    if HaveChapters then Sendcommand('get_property chapter');
    SendCommand('get_time_length');
  end;
begin
  if MVideos.Visible then begin
    if ssCtrl in Shift then begin
      case Key of
        VK_RIGHT: if Wid then begin
            IPanel.Left := IPanel.Left - 3; IPanel.Width := IPanel.Width + 6;
            CBHSA := 2;
          end;
        VK_LEFT: if Wid then begin
            if IPanel.Width = 32 then exit;
            IPanel.Width := IPanel.Width - 6;
            if IPanel.Width < 32 then IPanel.Width:=32;
            IPanel.Left := (OPanel.Width - IPanel.Width) div 2;
            CBHSA := 2;
          end;
        VK_UP: if Wid then begin
            IPanel.Top := IPanel.Top - 3; IPanel.Height := IPanel.Height + 6;
            CBHSA := 2;
          end;
        VK_DOWN: if Wid then begin
            if IPanel.Height = 32 then exit;
            IPanel.Height := IPanel.Height - 6;
            if IPanel.Height < 32 then IPanel.Height := 32;
            IPanel.Top := (OPanel.Height - IPanel.Height) div 2;
            CBHSA := 2;
          end;
      {+=} 187: begin
            HandleCommand('sub_scale +0.1'); FSize := FSize + 0.1;
            if FSize > 10 then FSize := 10;
          end;
      {_-} 189: begin
            HandleCommand('sub_scale -0.1'); FSize := FSize - 0.1;
            if FSize < 0.1 then FSize := 0.1;
          end;
      end;
    end
    else begin
      if Wid and (ssAlt in Shift) then begin
        case Key of
          Ord('3'): MSizeClick(MSizeAny);
          {`~} 192: MSizeClick(MSize50);
          Ord('1'): MSizeClick(MSize100);
          Ord('2'): MSizeClick(MSize200);
        end;
      end
      else begin
        if ssShift in Shift then begin
          case Key of
            Ord('A'): NextAngle;
            Ord('E'): MEqualizerClick(nil);
            {`~} 192: if Wid then MScale0Click(nil);
            Ord('S'): HandleCommand('screenshot 1');
            Ord('Z'): MSubDelay2Click(nil);
          end;
        end
        else begin
          case Key of
            VK_SUBTRACT: if HaveVideo and HaveAudio and (Adelay > -99.9) then begin
                Adelay := Adelay - 0.1; HandleCommand('audio_delay -0.100');
              end;
            VK_ADD: if HaveVideo and HaveAudio and (Adelay < 99.9) then begin
                Adelay := Adelay + 0.1; HandleCommand('audio_delay +0.100');
              end;
            Ord('O'): begin
                if OSDLevel < 2 then OSDLevel := 3
                else if DefaultOSDLevel > 1 then OSDLevel := 1
                else OSDLevel := DefaultOSDLevel;
                HandleCommand('osd ' + IntToStr(OSDLevel));
                MOSD.Items[OSDLevel].Checked := true;
                OSDMenu.Items[OSDLevel].Checked := true;
              end;
          {`~} 192: EqualizerForm.BResetClick(nil);
          {'"} 222: if Deinterlace = 2 then HandleCommand('step_property deinterlace');
            Ord('E'): if Wid then begin
                Scale := Scale + 1; LastScale := Scale;
                MSizeAny.Checked := True; MSizeAny.Checked := false;
                MKaspect.Checked := true; FixSize;
              end;
            Ord('W'): if Wid and (Scale > 1) then begin
                Scale := Scale - 1; LastScale := Scale;
                MSizeAny.Checked := True; MSizeAny.Checked := false;
                MKaspect.Checked := true; FixSize;
              end;
            Ord('1'), VK_NUMPAD1: begin
                HandleCommand('contrast -3');
                SendCommand('osd_show_property_text "' + OSD_Contrast_Prompt + ':${contrast}"');
              end;
            Ord('2'), VK_NUMPAD2: begin
                HandleCommand('contrast +3');
                SendCommand('osd_show_property_text "' + OSD_Contrast_Prompt + ':${contrast}"');
              end;
            Ord('3'), VK_NUMPAD3: begin
                HandleCommand('brightness -3');
                SendCommand('osd_show_property_text "' + OSD_Brightness_Prompt + ':${brightness}"');
              end;
            Ord('4'), VK_NUMPAD4: begin
                HandleCommand('brightness +3');
                SendCommand('osd_show_property_text "' + OSD_Brightness_Prompt + ':${brightness}"');
              end;
            Ord('5'), VK_NUMPAD5: begin
                HandleCommand('hue -3');
                SendCommand('osd_show_property_text "' + OSD_Hue_Prompt + ':${hue}"');
              end;
            Ord('6'), VK_NUMPAD6: begin
                HandleCommand('hue +3');
                SendCommand('osd_show_property_text "' + OSD_Hue_Prompt + ':${hue}"');
              end;
            Ord('7'), VK_NUMPAD7: begin
                HandleCommand('saturation -3');
                SendCommand('osd_show_property_text "' + OSD_Saturation_Prompt + ':${saturation}"');
              end;
            Ord('8'), VK_NUMPAD8: begin
                HandleCommand('saturation +3');
                SendCommand('osd_show_property_text "' + OSD_Saturation_Prompt + ':${saturation}"');
              end;
            VK_INSERT: begin
                HandleCommand('gamma +3');
                SendCommand('osd_show_property_text "' + OSD_Gamma_Prompt + ':${gamma}"');
              end;
            VK_DELETE: begin
                HandleCommand('gamma -3');
                SendCommand('osd_show_property_text "' + OSD_Gamma_Prompt + ':${gamma}"');
              end;
            Ord('D'): HandleCommand('frame_drop');

            Ord('C'): if MSubtitle.Count > 0 then HandleCommand('sub_alignment');
            Ord('T'): if (MSubtitle.Count > 0) and (not Ass) then begin
                HandleCommand('sub_pos +2'); subpos := subpos + 2;
                if SubPos > 100 then SubPos := 100;
              end;
            Ord('R'): if (MSubtitle.Count > 0) and (not Ass) then begin
                HandleCommand('sub_pos -2'); subpos := subpos - 2;
                if SubPos < 0 then SubPos := 0;
              end;
            Ord('V'): if MSubtitle.Count > 0 then begin
                MShowSub.Checked := not MShowSub.Checked;
                if MShowSub.Checked then HandleCommand('sub_visibility 1')
                else HandleCommand('sub_visibility 0');
              end;
            Ord('S'): HandleCommand('screenshot 0');
            Ord('Y'): if MSubtitle.Count > 0 then HandleCommand('sub_step -1');
            Ord('U'): if MSubtitle.Count > 0 then HandleCommand('sub_step +1');
            Ord('Z'): if MSubtitle.Count > 0 then begin
                Sdelay := Sdelay - 0.1; HandleCommand('sub_delay -0.1');
              end;
            Ord('X'): if MSubtitle.Count > 0 then begin
                Sdelay := Sdelay + 0.1; HandleCommand('sub_delay +0.1');
              end;
        Ord('G'): if Dnav then HandleCommand('dvdnav menu'); {5}
    Ord('H'): if Dnav then HandleCommand('dvdnav selset'); {6}
        Ord('I'): if Dnav then HandleCommand('dvdnav up'); {1}
        Ord('K'): if Dnav then HandleCommand('dvdnav down'); {2}
            Ord('J'): if Dnav then HandleCommand('dvdnav left'); {3}
            Ord('L'): if Dnav then HandleCommand('dvdnav right'); {4}
            {;:} 186: if Dnav then HandleCommand('dvdnav prev');
            Ord('N'): NextAspect;
            Ord('B'): NextSub;
            Ord('Q'): NextVideo;
            Ord('P'): if (DemuxerName = 'mpegts') or (DemuxerName = 'lavf') or (DemuxerName = 'lavfpref') then
                HandleCommand('step_property switch_program');

          end;
        end;
      end;
    end;
  end;
  if ssCtrl in Shift then begin
    case Key of
      Ord('O'): PlaylistForm.BAddClick(Sender);
      Ord('A'): NextMonitor;
      Ord('L'): MOpenURLClick(nil);
      Ord('W'): MCloseClick(nil);
      Ord('S'): BStopClick(nil);
      {`~} 192: MPanClick(nil);
      Ord('Q'): Close;
      Ord('D'): MOpenDirClick(nil);
      VK_BACK: MAudioDelay2Click(nil);
    end;
  end
  else begin
    if ssAlt in Shift then begin
      case Key of
        VK_F4: Close;
      end;
    end
    else begin
      if ssShift in Shift then begin
        case Key of
          Ord('D'): MAudiochannelsClick(MStereo);
          Ord('L'): MAudiochannelsClick(MLchannels);
          Ord('R'): MAudiochannelsClick(MRchannels);
        end;
      end
      else begin
        case Key of
          VK_RIGHT: HandleSeekCommand('seek +' + IntToStr(seekLen));
          VK_LEFT: HandleSeekCommand('seek -' + IntToStr(seekLen));
          VK_UP: HandleSeekCommand('seek +60');
          VK_DOWN: HandleSeekCommand('seek -60');
          VK_PRIOR: HandleSeekCommand('seek +600');
          VK_NEXT: HandleSeekCommand('seek -600');
          VK_HOME: begin
              if not Running then exit;
              if bluray then t := MBRT
              else t := MDVDT;
              i := CheckMenu(t, TID);
              if i < 0 then exit;
              if CheckMenu(t.Items[i], 0) < 0 then exit;
              j := CheckMenu(t.Items[i].Items[0], CID + 1);
              if j < 0 then exit;
              t.Items[i].Items[0].Items[j].Checked := true;
              inc(CID);
              if Win32PlatformIsUnicode then
                HandleSeekCommand('seek_chapter +1')
              else begin
                Dreset := true; Restart;
              end;
            end;
          VK_END: begin
              if not Running then exit;
              if bluray then t := MBRT
              else t := MDVDT;
              i := CheckMenu(t, TID);
              if i < 0 then exit;
              if CheckMenu(t.Items[i], 0) < 0 then exit;
              j := CheckMenu(t.Items[i].Items[0], CID - 1);
              if j < 0 then exit;
              t.Items[i].Items[0].Items[j].Checked := true;
              dec(CID);
              if Win32PlatformIsUnicode then
                HandleSeekCommand('seek_chapter -1')
              else begin
                Dreset := true; Restart;
              end;
            end;
          VK_BACK: MSpeedClick(M1X);
       {-_} 189: if Speed > 0.01 then begin
              HandleCommand('speed_mult 0.9090909');
              Speed := Speed * 0.9090909; MCX.Checked := true;
              if Speed < 0.01 then Speed := 0.01
            end;
       {+=} 187: if Speed < 100 then begin
              HandleCommand('speed_mult 1.1');
              Speed := Speed * 1.1; MCX.Checked := true;
              if Speed > 100 then Speed := 100;
            end;
          Ord('M'), VK_VOLUME_MUTE: BMuteClick(nil);
          Ord('9'), VK_NUMPAD9, VK_DIVIDE, VK_VOLUME_DOWN: SetVolumeRel(-3);
          Ord('0'), VK_NUMPAD0, VK_MULTIPLY, VK_VOLUME_UP: SetVolumeRel(+3);
        {,<} 188: begin
              HandleSeekCommand('balance -0.1');
              SendCommand('osd_show_property_text "${balance}"');
            end;
        {.>} 190: begin
              HandleSeekCommand('balance +0.1');
              SendCommand('osd_show_property_text "${balance}"');
            end;
          Ord('A'): NextAudio;
          VK_F1: NextOnTop;
          VK_F9: MShowPlaylistClick(nil);
          VK_F10: MOptionsClick(nil);
          VK_F11: MStreamInfoClick(nil);
          VK_F12: MShowOutputClick(nil);
         {[} 219: MIntroClick(nil);
         {]} 221: MEndClick(nil);
        {\|} 220: MSIEClick(nil);
        {/?} 191: BPauseClick(nil);
          VK_SPACE, VK_MEDIA_PLAY_PAUSE: if Running then SendCommand('pause')
            else if BPlay.Enabled then NextFile(0, psPlaying);
          VK_MEDIA_STOP: if BStop.Enabled then BStopClick(nil);
          VK_MEDIA_PREV_TRACK, VK_F7: if BPrev.Enabled then BPrevNextClick(BPrev);
          VK_MEDIA_NEXT_TRACK, VK_F8: if BNext.Enabled then BPrevNextClick(BNext);
        end;
        if MVideos.Visible or ds then begin
          case Key of
            Ord('F'): if Wid then begin
                case ViewMode of
                  0: SetFullscreen(not (MFullscreen.Checked));
                  1: SimulateKey(MCompact);
                  2: SimulateKey(MMaxW);
                end;
              end
              else HandleCommand('vo_fullscreen');
            VK_F2: if Wid then MKaspectClick(nil);
            VK_F3: if Wid then Hide_menuClick(nil);
            VK_F4: if Wid then MctrlClick(nil);
            VK_F5: if Wid then begin
                MCompact.Checked := not MCompact.Checked;
                BCompact.Down := MCompact.Checked;
                MPCompact.Checked := MCompact.Checked;
                if MCompact.Checked and MMaxW.Checked then begin
                  MMaxW.Checked := false; MPMaxW.Checked := false;
                  SetWindowLong(Handle, GWL_STYLE, (WS_THICKFRAME or WS_VISIBLE) and (not WS_DLGFRAME));
                  SetBounds(Left - 3, Top - 3, Width + 6, Height + 6); MFunc := 1;
                  MWheelControl.Items[1].Checked := true;
                  MPWheelControl.Items[1].Checked := true;
                end
                else
                  SetCompact(MCompact.Checked);
              end;
            VK_F6: NextSubCP;
            VK_TAB: if Wid then MPCtrlClick(nil);
            VK_RETURN: if Wid then begin
                if MCompact.Checked then begin
                  SetCompact(false); BCompact.Down := false;
                  MCompact.Checked := false; MPCompact.Checked := false;
                end;
                MMaxW.Checked := not MMaxW.Checked;
                SetCompact(MMaxW.Checked);
                MPMaxW.Checked := MMaxW.Checked;
              end;
          end;
        end;
      end;
    end;
  end;
  Key := 0; Shift := [];
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  OptionsForm.HotKeyToOldKey(Shift, Key);
  if HaveVideo then begin
    case Key of
      Ord('1'), VK_NUMPAD1, Ord('2'), VK_NUMPAD2: begin
          CBHSA := 1; SendCommand('get_property contrast'); end;
      Ord('3'), VK_NUMPAD3, Ord('4'), VK_NUMPAD4: begin
          CBHSA := 1; SendCommand('get_property brightness'); end;
      Ord('5'), VK_NUMPAD5, Ord('6'), VK_NUMPAD6: begin
          CBHSA := 1; SendCommand('get_property hue'); end;
      Ord('7'), VK_NUMPAD7, Ord('8'), VK_NUMPAD8: begin
          CBHSA := 1; SendCommand('get_property saturation'); end;
      VK_INSERT, VK_DELETE: begin
          CBHSA := 1; SendCommand('get_property gamma'); end;
                            {,<} 188, {.>} 190: SendCommand('get_property balance');
    end;
    if CBHSA = 2 then begin
      InterW := IPanel.Width; InterH := IPanel.Height;
      MKaspect.Checked := true; CBHSA := 0;
      Aspect := MCustomAspect.Tag; MCustomAspect.Checked := true;
      NativeHeight := InterH * NativeWidth div InterW;
      FixSize;
    end;
  end;
  Key := 0; Shift := [];
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
var P: Tpoint; TickCount: Cardinal;
begin
  TickCount := GetTickCount; Init_MOpenDrive;
  if (CPanel.Visible or MenuBar.Visible) and (not seeking)
    and (not MPCtrl.Checked) then begin
    GetCursorPos(p);
    if not PtInRect(BoundsRect, p) then begin
      SetCtrlV(false); SetMenuBarV(false);
    end;
  end;
  CurMonitor := Screen.MonitorFromWindow(Handle);
  if CurMonitor = nil then begin
    CurMonitor := Screen.Monitors[0];
    if Width > Screen.Width then Width := Screen.Width;
    if Height > Screen.Height then Height := Screen.Height;
    if (Left < 0) or (Left > Screen.Width) then Left := (Screen.Width - Width) div 2;
    if (Top < 0) or (Top > Screen.Height) then Top := (Screen.Height - Height) div 2;
    if Assigned(LyricShowForm) then begin
      LyricShowForm.Left := 0;
      LyricShowForm.Height:=Screen.WorkAreaHeight*140 div 770;
      LyricShowForm.Top := Screen.WorkAreaHeight - LyricShowForm.Height;
      LyricShowForm.Width := Screen.Width;
      GDILyric.SetWidthAndHeight(LyricShowForm.Width, LyricShowForm.Height);
    end;
  end
  else begin
    if MonitorID <> CurMonitor.MonitorNum then begin
      MTM.Items[CurMonitor.MonitorNum].Checked := true;
      MonitorID := CurMonitor.MonitorNum; MonitorW := CurMonitor.Width; MonitorH := CurMonitor.Height;
      if Width > CurMonitor.Width then Width := CurMonitor.Width;
      if Height > CurMonitor.Height then Height := CurMonitor.Height;
      if Wid and Win32PlatformIsUnicode and IsDx then Restart;
      if Assigned(LyricShowForm) then begin
        LyricShowForm.Left := CurMonitor.Left;
        LyricShowForm.Height:=(CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)*140 div 770;
        LyricShowForm.Top := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - LyricShowForm.Height;
        LyricShowForm.Width := MonitorW;
        GDILyric.SetWidthAndHeight(LyricShowForm.Width, LyricShowForm.Height);
      end;
    end;
    if (CurMonitor.Width <> MonitorW) or (CurMonitor.Height <> MonitorH) then begin
      MonitorW := CurMonitor.Width; MonitorH := CurMonitor.Height;
      if Width > CurMonitor.Width then Width := CurMonitor.Width;
      if Height > CurMonitor.Height then Height := CurMonitor.Height;
      if (Left + Width) > (CurMonitor.Left + CurMonitor.Width) then
        Left := CurMonitor.Left + CurMonitor.Width - Width;
      if (Top + Height) > (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top) then
        Top := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - Height;
      if Wid and Win32PlatformIsUnicode and IsDx then Restart;
      if Assigned(LyricShowForm) then begin
        LyricShowForm.Left := CurMonitor.Left;
        LyricShowForm.Height:=(CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)*140 div 770;
        LyricShowForm.Top := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - LyricShowForm.Height;
        LyricShowForm.Width := MonitorW;
        GDILyric.SetWidthAndHeight(LyricShowForm.Width, LyricShowForm.Height);
      end;
    end;
  end;

  if (TickCount >= PlayMsgAt) and HaveMsg then HaveMsg := false;
  if Running then begin
    if core.Status = sPlaying then begin
      if TickCount >= UpdateSeekBarAt then UpdateSeekBar;
      if HaveVideo or (HaveLyric <> 0) then SetThreadExecutionState(ES_DISPLAY_REQUIRED)
      else SetThreadExecutionState(ES_SYSTEM_REQUIRED);
    end; {//Allow OS into "Stand by" or "Hibernate" state when player in "pause" state
    else SetThreadExecutionState(ES_SYSTEM_REQUIRED); }

    if (TotalTime > 0) and UpdateSkipBar then begin
      UpdateSkipBar := false;
      if (Bp > 0) and (Bp < TotalTime) then
        SkipBar.Left := SeekBar.Left + SeekBar.Width * Bp div TotalTime
      else SkipBar.Left := SeekBar.Left;
      if (Ep > 0) and (Ep < TotalTime) then
        SkipBar.Width := (SeekBar.Width * Ep div TotalTime) - SkipBar.Left + SeekBar.Left
      else SkipBar.Width := SeekBar.Width - SkipBar.Left + SeekBar.Left;
    end;
    //鼠标为手形时，不隐藏鼠标
   { if (MouseMode=0) and (OuterPanel.Cursor<>-1) and (InnerPanel.Cursor=crDefault)
      and (GetTickCount>=HideMouseAt) then SetMousV(false);
    ///////////////////// }
    //无论鼠标为何种形状，当鼠标不是隐藏状态时都会去执行鼠标隐藏。当鼠标隐藏时不会执行拖曳字幕功能
    if (MouseMode = 0) and (not IsDMenu) and (IPanel.Cursor <> -1)
      and (TickCount >= HideMouseAt) then SetMouseV(false);
    ///////////////////
  end
  else if CT and (core.Status in [sNone, sStopped]) then LTime.Caption := FormatDateTime(DTFormat, Now, FormatSet);
end;

procedure TMainForm.FixSize;
var NX, NY, w, h: integer;
begin
  if (not FirstShow) and (LastHaveVideo or ds) then begin
    EW := Opanel.Width; EH := Opanel.Height;
  end;

  if (NativeWidth = 0) or (NativeHeight = 0)
    or (not MKaspect.Checked) then begin
    IPanel.Align := alClient; exit;
  end
  else IPanel.Align := alNone;

  NY := OPanel.Height; NX := NativeWidth * OPanel.Height div NativeHeight;
  if NX > OPanel.Width then begin
    NX := OPanel.Width; NY := NativeHeight * OPanel.Width div NativeWidth;
  end;
  with IPanel do begin
    w := NX * LastScale div 100;
    h := NY * LastScale div 100;
    if (LastScale <> 100) and ((w < 32) or ( h < 32)) then begin
      if w > h then begin
        h := 32;
        LastScale := h*100 div NY;
        w := NX * LastScale div 100;
      end
      else begin
        w := 32;
        LastScale := w*100 div NX;
        h := NY * LastScale div 100;
      end;
    end;
    Width := w;
    Height := h;
    Left := (OPanel.Width - Width) div 2;
    Top := (OPanel.Height - Height) div 2;
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
var CX, CY: integer;
begin
  if SeekBarSlider.Visible then UpdateSeekBar;
  if (TotalTime > 0) and SkipBar.Visible then begin
    if (Bp > 0) and (Bp < TotalTime) then
      SkipBar.Left := SeekBar.Left + SeekBar.Width * Bp div TotalTime
    else SkipBar.Left := SeekBar.Left;
    if (Ep > 0) and (Ep < TotalTime) then
      SkipBar.Width := (SeekBar.Width * Ep div TotalTime) - SkipBar.Left + SeekBar.Left
    else SkipBar.Width := SeekBar.Width - SkipBar.Left + SeekBar.Left;
  end;

  CX := OPanel.ClientWidth;
  CY := OPanel.ClientHeight;
  Logo.Left := (CX - Logo.Width) div 2;
  Logo.Top := (CY - Logo.Height) div 2;
  UpdateDockedWindows;
  if ControlledResize then
    ControlledResize := false
  else begin
    MSizeAny.Checked := true; MSizeAny.Checked := false;
  end;
  if not (MSize50.Checked or MSize100.Checked or MSize200.Checked) then LastScale := Scale;
  FixSize;
end;

procedure TMainForm.SetupPlay;
begin
  BPlay.Enabled := true;
  BPlay.Down := true;
  BStop.Enabled := true;
  SeekBarSlider.Visible := true;
  BPause.Enabled := true;
  BPause.Down := false;
  Logo.Visible := not HaveVideo;
  IPanel.Visible := HaveVideo and Wid;
  Seeking := false; LTime.Cursor := crHandPoint;
  LTime.Font.Size := 14; LTime.Top := -2;
  InfoForm.UpdateInfo(true);
  core.Status := sPlaying; UpdateStatus;
end;

procedure TMainForm.SetupStop;
begin
  BPlay.Down := false;
  BPlay.Enabled := (Playlist.Count > 0);
  BStop.Enabled := false;
  SeekBarSlider.Visible := false;
  IPanel.Visible := false;
  BPause.Enabled := false;
  BPause.Down := false;
  Logo.Visible := not Running;
  SetMouseV(true);
  MLoadSub.Visible := false;
  MShowSub.Visible := false; N17.Visible := MShowSub.Visible;
  LTime.Cursor := crDefault; LTime.Caption := '';
  LTime.Font.Size := 12; LTime.Top := 0;
  TntApplication.Title := Caption;
end;

procedure TMainForm.UpdateSeekBar;
var MaxPos: integer;
begin
  if Seeking or (TotalTime = 0) then exit;
  MaxPos := SeekBarFrame.ClientWidth - SeekBarSlider.Width;
  SeekBarSlider.Left := MaxPos * SecondPos div TotalTime;
  if SeekBarSlider.Left > MaxPos then SeekBarSlider.Left := MaxPos;
end;

procedure TMainForm.SeekBarSliderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (TotalTime > 0) then begin
    Seeking := true; SeekBarSlider.ShowHint := false;
    SeekBarSlider.BevelInner := bvRaised;
    SeekMouseX := X;
  end;
  if Button = mbmiddle then MIntroClick(nil);
  if Button = mbright then MEndClick(nil);
end;

procedure TMainForm.SeekBarSliderMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var NewX, MaxX: integer;
begin
  if not (ssLeft in Shift) or (not Seeking) or (TotalTime = 0) then exit;
  NewX := X - SeekMouseX + SeekBarSlider.Left;
  MaxX := SeekBarFrame.ClientWidth - SeekBarSlider.Width;
  if MaxX = 0 then exit;
  if NewX < 0 then NewX := 0;
  if NewX > MaxX then NewX := MaxX;
  SeekBarSlider.Left := NewX;
  LastPos := TotalTime * NewX div MaxX;
  if ETime then
    LTime.Caption := '-' + SecondsToTime(TotalTime - LastPos) + '/' + Duration
  else
    LTime.Caption := SecondsToTime(LastPos) + '/' + Duration;
  TntApplication.Title := DisplayURL + ' [' + LTime.Caption + ']';
  if Mctrl.Checked then
    Caption := DisplayURL + ' [' + LTime.Caption + ']' + ' - ' + LOCstr_Title;
end;

procedure TMainForm.SeekBarSliderMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button <> mbLeft) or (TotalTime = 0) then exit;
  SeekBarSlider.BevelInner := bvLowered;
  {if (CID>1) and HaveChapters then SendCommand('seek '+IntToStr(LastPos-SecondPos))
  else SendCommand('seek '+IntToStr(LastPos)+' 2');}
  if core.Status = sPaused then SendCommand('seek ' + IntToStr(LastPos - SecondPos))
  else begin
    SendCommand('set_property mute 1');
    SendCommand('seek ' + IntToStr(LastPos - SecondPos));
    SendCommand('set_property mute 0');
  end;
  if HaveVideo then SendCommand('osd_show_text ' + IntToStr(100 * LastPos div TotalTime) + '%');
  Seeking := false; SeekBarSlider.ShowHint := true;
  UpdateSeekBarAt := GetTickCount() + 500;
  if not Win32PlatformIsUnicode then Restart;
end;

procedure TMainForm.SeekBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var P: TPoint;
begin
  P := SeekBarFrame.ScreenToClient(SeekBar.ClientToScreen(Point(X, Y)));
  SeekBarFrameMouseDown(Sender, Button, Shift, P.X, P.Y);
end;

procedure TMainForm.SeekBarFrameMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var MaxPos: integer;
begin
  if (not SeekBarSlider.Visible) or (Button <> mbLeft) or (TotalTime = 0) then exit;
  dec(X, SeekBarSlider.Width div 2);
  MaxPos := SeekBarFrame.ClientWidth - SeekBarSlider.Width;
  if MaxPos = 0 then exit;
  {if (CID>1) and HaveChapters then SendCommand('seek '+IntToStr((TotalTime*X DIV MaxPos)-SecondPos))
  else SendCommand('seek '+IntToStr(TotalTime*X DIV MaxPos)+' 2'); }
  if core.Status = sPaused then SendCommand('seek ' + IntToStr((TotalTime * X div MaxPos) - SecondPos))
  else begin
    SendCommand('set_property mute 1');
    SendCommand('seek ' + IntToStr((TotalTime * X div MaxPos) - SecondPos));
    SendCommand('set_property mute 0');
  end;
  if HaveVideo then SendCommand('osd_show_text ' + IntToStr(100 * X div MaxPos) + '%');
  SeekBarSlider.Left := X; UpdateSeekBarAt := GetTickCount() + 500;
  if not Win32PlatformIsUnicode then Restart;
end;

procedure TMainForm.SimulateKey(Sender: TObject);
var Key: word; Shift: TShiftState;
begin
  Shift := [];
  if Sender = MRnMenu then Key := 186 //;
  else if Sender = MRmMenu then Key := 71 //g
  else if Sender = MSubScale0 then begin
    Key := 187; Shift := [ssCtrl]; end //-_
  else if Sender = MSubScale1 then begin
    Key := 189; Shift := [ssCtrl]; end //+=
  else HkToShiftKey((Sender as TComponent).Tag, Shift, Key);
  HotKeyDown(Sender, Key, Shift);
end;

procedure TMainForm.VideoSizeChanged;
var SX, SY, PX, PY: integer;
begin
  if (not Wid) or (not Win32PlatformIsUnicode) or
    (NativeWidth = 0) or (NativeHeight = 0) then exit;
  if (not (MSize50.Checked or MSize100.Checked or MSize200.Checked or MSizeAny.Checked))
    or MFullscreen.Checked then begin
    FixSize;
    exit;
  end;
  SX := NativeWidth; SY := NativeHeight;
  if MSize50.Checked then begin
    SX := SX div 2; SY := SY div 2;
    if SX < Constraints.MinWidth then begin
      SX := Constraints.MinWidth;
      if NativeWidth <> 0 then SY := SX * NativeHeight div NativeWidth;
    end;
  end;
  if MSize200.Checked then begin
    SX := SX * 2; SY := SY * 2;
  end;
  if MSizeAny.Checked then begin
    if NW <> 0 then SX := NW; if NH <> 0 then SY := NH; 
  end;
  PX := Left + ((OPanel.Width - SX) div 2);
  PY := Top + ((OPanel.Height - SY) div 2);
  SX := Width - (OPanel.Width - SX);
  SY := Height - (OPanel.Height - SY);
  if PX < CurMonitor.Left then PX := CurMonitor.Left; if PY < CurMonitor.Top then PY := CurMonitor.Top;
  if (SX > CurMonitor.Width) then begin
    SX := CurMonitor.Width; MSizeAny.Checked := True; MSizeAny.Checked := false; end;
  if (SY > (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)) then begin
    SY := CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top; MSizeAny.Checked := True; MSizeAny.Checked := false; end;
  if ((PX + SX) > (CurMonitor.Left + CurMonitor.Width)) then begin PX := CurMonitor.Left + CurMonitor.Width - SX; end;
  if ((PY + SY) > (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)) then begin
    PY := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - SY; end;
  if (SX = Width) and (SY = Height) then FixSize;
  SetWindowLong(Handle, GWL_STYLE, DWORD(GetWindowLong(Handle, GWL_STYLE)) and (not WS_MAXIMIZE));
  ControlledResize := true; SetBounds(PX, PY, SX, SY);
  if WantCompact then begin
    SimulateKey(MCompact); WantCompact := false;
  end;
  if WantFullscreen then begin
    SimulateKey(MFullscreen); WantFullscreen := False;
  end;
  ControlledResize := false;
end;

procedure TMainForm.MSizeClick(Sender: TObject);
begin
  if MFullscreen.Checked then SimulateKey(MFullscreen)
  else if (Sender as TTntMenuItem).Checked then exit;
  (Sender as TTntMenuItem).Checked := True;
  LastScale := 100;
  VideoSizeChanged;
end;

procedure TMainForm.MShowOutputClick(Sender: TObject);
begin
  if not OptionsForm.Visible then begin
    OptionsForm.Tab.ActivePage := OptionsForm.TLog;
    OptionsForm.Showmodal;
  end;
end;

procedure TMainForm.MOSDClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  OSDLevel := (Sender as TTntMenuItem).Tag;
  MOSD.Items[OSDLevel].Checked := true;
  OSDMenu.Items[OSDLevel].Checked := true;
  case OSDLevel of
    0: SendCommand('osd_show_text "OSD: ' + OSD_Disable_Prompt + '"');
    1: SendCommand('osd_show_text "OSD: ' + OSD_Enable_Prompt + '"');
  end;
  SendCommand('osd ' + IntToStr(OSDLevel));
  if not Win32PlatformIsUnicode then Restart;
end;

procedure TMainForm.ToggleAlwaysOnTop(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  OnTop := (Sender as TTntMenuItem).Tag;
  (Sender as TTntMenuItem).Checked := true;
  case OnTop of
    0: begin
        if not MFullscreen.Checked then begin
          if HaveVideo and (not Wid) then SendCommand('vo_ontop 0')
          else SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
        end;
        if HaveVideo and Wid then SendCommand('osd_show_text "' + OSD_OnTop0_Prompt + '"');
      end;
    1: begin
        if not MFullscreen.Checked then begin
          if HaveVideo and (not Wid) then SendCommand('vo_ontop 1')
          else SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
        end;
        if HaveVideo and Wid then SendCommand('osd_show_text "' + OSD_OnTop1_Prompt + '"');
      end;
    2: if Running then begin
        if (core.Status = sPlaying) and (not MFullscreen.Checked) then begin
          if HaveVideo and (not Wid) then SendCommand('set_property ontop 1')
          else SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
        end;
        if HaveVideo then SendCommand('osd_show_text "' + OSD_OnTop2_Prompt + '"');
      end
      else SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure TMainForm.MCloseClick(Sender: TObject);
begin
  CloseMedia
end;

procedure TMainForm.MSpeedClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  (Sender as TTntMenuItem).Checked := True;
  case (Sender as TTntMenuItem).Tag of
    1: begin
        Speed := 0.25; SendCommand('speed_set 0.25'); end;
    2: begin
        Speed := 0.5; SendCommand('speed_set 0.5'); end;
    3: begin
        Speed := 1; SendCommand('speed_set 1'); end;
    4: begin
        Speed := 2; SendCommand('speed_set 2'); end;
    5: begin
        Speed := 4; SendCommand('speed_set 4'); end;
    7: SendCommand('speed_set ' + FloatToStr(Speed));
  end;
  if not Win32PlatformIsUnicode then Restart;
end;

procedure TMainForm.MVideoClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  (Sender as TTntMenuItem).Checked := True;
  VideoID := (Sender as TTntMenuItem).Tag;
  if (CheckInfo(VideoDemuxer, DemuxerName) < 0) or (not Win32PlatformIsUnicode) then
    Restart
  else begin
    SendCommand('set_property switch_video ' + IntToStr(VideoID));
    SendCommand('osd_show_text "' + OSD_VideoTrack_Prompt + ': ' + IntToStr(VideoID) + #34);
  end;
end;

procedure TMainForm.MAudioClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  (Sender as TTntMenuItem).Checked := True;
  AudioID := (Sender as TTntMenuItem).Tag;
  if (CheckInfo(AudioDemuxer, DemuxerName) < 0) or (not Win32PlatformIsUnicode) then
    Restart
  else begin
    SendCommand('switch_audio ' + IntToStr(AudioID));
    if HaveVideo then
      SendCommand('osd_show_text "' + OSD_AudioTrack_Prompt + ': ' + IntToStr(AudioID) + #34);
  end;
end;

procedure TMainForm.MAudiochannelsClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  (Sender as TTntMenuItem).Checked := True;
  balance := (Sender as TTntMenuItem).Tag;
  SendCommand('set_property balance ' + FloatToStr(balance));
  if HaveVideo then SendCommand('osd_show_text "' + UTF8Encode(Trim(copy((Sender as TTntMenuItem).Caption, 1, Pos('(', (Sender as TTntMenuItem).Caption) - 1))) + '"');
end;

procedure TMainForm.MSubtitleClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  (Sender as TTntMenuItem).Checked := True;
  SubID := (Sender as TTntMenuItem).Tag;
  SendCommand('sub_select ' + IntToStr(SubID));
end;

procedure TMainForm.MFClearClick(Sender: TObject);
var i: integer; INI: TMemIniFile; FileName: WideString;
begin
  if NoAccess > 0 then exit; FileName := HomeDir + DefaultFileName;
  if not WideFileExists(FileName) then begin
    FileName := AppdataDir + DefaultFileName;
    if not WideFileExists(FileName) then exit;
  end;
  if WideFileIsReadOnly(FileName) then WideFileSetReadOnly(FileName, false);
  FileName := WideExtractShortPathName(FileName);
  INI := TMemIniFile.Create(FileName);
  try
    for i := MRFile.Count - 1 downto 2 do begin
      MRFile.delete(i); INI.DeleteKey(SectionName, 'RF' + IntToStr(i - 2));
    end;
    INI.UpdateFile;
  finally
    INI.Free;
  end;
  MRFile.Visible := false;
end;

procedure TMainForm.MRFClick(Sender: TObject);
var Entry: TPlaylistEntry; w, g: WideString; h: integer;
begin
  PClear := true; EndOpenDir := true;
  w := (Sender as TTntMenuItem).Hint;
  h := pos('|', w); g := '';
  if h > 0 then begin
    g := copy(w, h + 1, MaxInt); w := copy(w, 1, h - 1);
  end;
  if g <> '' then Entry.DisplayURL := g
  else Entry.DisplayURL := WideExtractFileName(w);
  Entry.FullURL := w;
  Entry.State := psNotPlayed;
  playlist.Add(Entry);
  if Addsfiles then Plist.addEpisode(w);
  Playlist.Changed;
end;

procedure TMainForm.UpdateMRF;
var t: TTntMenuItem; s: WideString;
begin
  s := MediaURL + '|' + DisplayURL;
  if (MRfile.Count > 2) and (TTntMenuItem(MRFile.Items[2]).Hint = s) then exit;
  if (Copy(MediaURL, 1, 12) = ' -dvd-device') or (Copy(MediaURL, 1, 14) = ' -cdrom-device')
    or (Copy(MediaURL, 1, 15) = ' -bluray-device') then exit;
  if MRFile.Count = (RFileMax + 2) then MRFile.Delete(RFileMax + 1);
  t := TTntMenuItem.Create(MRFile);
  t.Caption := DisplayURL; t.Hint := s;
  t.OnClick := MRFClick;
  MRFile.Insert(2, t);
  MRFile.Visible := true;
end;

procedure TMainForm.MDVDCClick(Sender: TObject);
var index, r, e: integer; t: TMenuItem;
begin
  if (Sender as TTntMenuItem).Checked then exit;
  if bluray then t := MBRT
  else t := MDVDT;
  if TID = 0 then index := 1
  else index := TID;
  r := CheckMenu(t, index);
  if r >= 0 then begin
    e := CheckMenu(t.Items[r], 0);
    if e >= 0 then begin
      index := CheckMenu(t.Items[r].Items[e], CID);
      if index >= 0 then t.Items[r].Items[e].Items[index].Checked := false;
    end;
  end;
  CID := (Sender as TTntMenuItem).Tag;
  index := (Sender as TTntMenuItem).Parent.Parent.Tag;
  (Sender as TTntMenuItem).Parent.Parent.Checked := true;
  (Sender as TTntMenuItem).Checked := True;
  if not Running then begin
    MSecPos := -1; LastPos := 0; SecondPos := -1; Duration := '0:00:00';
    SeekBarSlider.Left := 0; UpdateSkipBar := SkipBar.Visible;
    if TID <> index then begin TID := index; AID := 1 end;
    Dreset := true;
    Start;
    exit;
  end;
  if Win32PlatformIsUnicode then begin
    if TID = index then
      SendCommand('seek_chapter ' + IntToStr(CID - 1) + ' 1')
    else begin
      TID := index;
      if Dnav and dvd then begin
        SendCommand('switch_title ' + IntToStr(TID));
        SendCommand('seek_chapter ' + IntToStr(CID - 1) + ' 1');
      end
      else begin Dreset := true; Restart; end;
    end;
  end
  else begin
    TID := index; Dreset := true;
    Restart;
  end;
end;

procedure TMainForm.MDVDAClick(Sender: TObject);
var index: integer;
begin
  if (Sender as TTntMenuItem).Checked then exit;
  if TID = 0 then index := 1
  else index := TID;
  if index <> (Sender as TTntMenuItem).Parent.Parent.Tag then exit;
  index := CheckMenu((Sender as TTntMenuItem).Parent, AID);
  (Sender as TTntMenuItem).Parent.Items[index].Checked := false;
  AID := (Sender as TTntMenuItem).Tag;
  (Sender as TTntMenuItem).Checked := True;
  if not Running then exit;
  if Win32PlatformIsUnicode and (not Dnav) then
    SendCommand('switch_angle ' + IntToStr(AID - 1))
  else begin
    Dreset := true; Restart;
  end;
end;

procedure TMainForm.MVCDTClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  MSecPos := -1; LastPos := 0; SecondPos := -1; TotalTime := 0; Duration := '0:00:00';
  SeekBarSlider.Left := 0; UpdateSkipBar := SkipBar.Visible; Firstrun := true; FirstOpen := true;
  CDID := (Sender as TTntMenuItem).Tag;
  (Sender as TTntMenuItem).Checked := True;
  ForceStop;
  Sleep(50); // wait for the processing threads to finish
  Application.ProcessMessages;
  Start;
end;

procedure TMainForm.UpdateMenus(Sender: TObject);
begin
  MCX.Caption := Copy(MCustomAspect.Caption, 1, Pos(' ', MCustomAspect.Caption)) + FloatToStr(Speed);
  MCustomAspect.Caption := Copy(MCustomAspect.Caption, 1, Pos(' ', MCustomAspect.Caption)) + IntToStr(InterW) + ':' + IntToStr(InterH);
  if (NW = 0) or (NH = 0) then
    MSizeAny.Caption := Copy(MSizeAny.Caption, 1, Pos(' (', MSizeAny.Caption)) + '(100%)'
  else
    MSizeAny.Caption := Copy(MSizeAny.Caption, 1, Pos(' (', MSizeAny.Caption)) + '(' + IntToStr(NW) + ':' + IntToStr(NH) + ')';
  MIntro.Caption := Copy(MIntro.Caption, 1, Pos(' ', MIntro.Caption)) + SecondsToTime(Bp);
  MEnd.Caption := Copy(MEnd.Caption, 1, Pos(' ', MEnd.Caption)) + SecondsToTime(Ep);
  MNext.Enabled := BNext.Enabled;
  MPlay.Enabled := BPlay.Enabled; MPlay.Checked := BPlay.Down;
  MPause.Enabled := BPause.Enabled; MPause.Checked := BPause.Down; ;
  MStop.Enabled := BStop.Enabled; MPrev.Enabled := BPrev.Enabled;
  MAudioDelay.Visible := MVideo.Visible and Running;
  MShowSub.Visible := (MSubtitle.Count > 0) and Running;
  MSubScale.Visible := MShowSub.Visible; N30.Visible := MShowSub.Visible;
  MSubDelay.Visible := MShowSub.Visible; MLoadSub.Visible := Running;
  MSubStep.Visible := MShowSub.Visible; N15.Visible := MShowSub.Visible;
  N17.Visible := MShowSub.Visible; MUloadAudio.Visible := AudioFile <> '';
end;

procedure TMainForm.MPopupPopup(Sender: TObject);
begin
  MPPlay.Enabled := BPlay.Enabled; MPPlay.Checked := BPlay.Down;
  MPPause.Enabled := BPause.Enabled; MPPause.Checked := BPause.Down;
  MPStop.Enabled := BStop.Enabled; MPPrev.Enabled := BPrev.Enabled;
  MPNext.Enabled := BNext.Enabled;
end;

procedure TMainForm.MDeinterlaceClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  (Sender as TTntMenuItem).Checked := true;
  Deinterlace := (Sender as TTntMenuItem).Tag;
 // if Deinterlace = 2 then SendCommand('set_property deinterlace 1')
  //else begin
  //  SendCommand('set_property deinterlace 0');
  Restart;
 // end;
end;

procedure TMainForm.MAspectClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  (Sender as TTntMenuItem).Checked := true;
  MKaspect.Checked := true;
  Aspect := (Sender as TTntMenuItem).Tag;
  if (Expand = 2) or (not Win32PlatformIsUnicode) then Restart
  else begin
    CBHSA := 3;
    case Aspect of
      0: begin
          SendCommand('switch_ratio -1'); SendCommand('osd_show_text "' + OSD_Auto_Prompt + '"'); end;
      1: begin
          SendCommand('switch_ratio 1.3333'); SendCommand('osd_show_text 4:3'); end;
      2: begin
          SendCommand('switch_ratio 1.7777'); SendCommand('osd_show_text 16:9'); end;
      3: begin
          SendCommand('switch_ratio 2.35'); SendCommand('osd_show_text 2.35:1'); end;
      4: begin
          SendCommand('switch_ratio 1.5555'); SendCommand('osd_show_text 14:9'); end;
      5: begin
          SendCommand('switch_ratio 1.25'); SendCommand('osd_show_text 1.25:1'); end;
      6: begin
          SendCommand('switch_ratio 1.6'); SendCommand('osd_show_text 16:10'); end;
      7: begin
          SendCommand('switch_ratio 2.21'); SendCommand('osd_show_text 2.21:1'); end;
      8: begin
          SendCommand('switch_ratio 1'); SendCommand('osd_show_text 1:1'); end;
      9: begin
          SendCommand('switch_ratio 1.22'); SendCommand('osd_show_text 1.22:1'); end;
      10: begin
          if (InterW <> 0) and (InterW > 3 * InterH) then InterW := 3 * InterH;
          NativeHeight := InterH * NativeWidth div InterW; VideoSizeChanged;
          SendCommand('osd_show_text "' + OSD_Custom_Prompt + ' ' + IntToStr(InterW) + ':' + IntToStr(InterH) + #34);
        end;
    end;
  end;
end;

procedure TMainForm.MOpenDirClick(Sender: TObject);
var s: widestring;
begin
  if WideSelectDirectory(AddDirCp, '', s) then begin
    PClear := true; EndOpenDir := true;
    Playlist.AddDirectory(s, false);
    //Playlist.Changed;
  end;
end;

procedure TMainForm.MOpenURLClick(Sender: TObject);
var s: WideString;
begin
  s := Trim(TntClipboard.AsWideText);
  if (Pos(^M, s) > 0) or (Pos(^J, s) > 0) or (Pos(^I, s) > 0) or
    ((Pos('//', s) = 0) and (Pos('\\', s) = 0) and (Pos(':', s) = 0))
    then s := '';
  if (WideInputQuery(LOCstr_OpenURL_Caption, LOCstr_OpenURL_Prompt, s)) and (s <> '') then begin
    PClear := true; EndOpenDir := true;
    if WideDirectoryExists(s) then Playlist.AddDirectory(s, false)
    else Playlist.AddFiles(s, false);
    Playlist.Changed;
  end;
end;

procedure TMainForm.Init_MOpenDrive;
var Mask: cardinal; Name: array[0..3] of char; Drive: char;
  Item: TTntMenuItem; MDrive: WideString; i: Integer;
begin
  NoAccess := 0;
  MDrive := Tnt_WideLowerCase(WideExtractFileDrive(HomeDir));
  if length(MDrive) > 2 then NoAccess := 1;
  Name := '@:\'; Mask := GetLogicalDrives;
  for Drive := 'A' to 'Z' do begin
    Name[0] := Drive; i := CheckMenu(MOpenDrive, Ord(Drive));
    if (Mask and (1 shl (Ord(Drive) - 65))) <> 0 then begin
      if (i = -1) and (GetDriveType(Name) = DRIVE_CDROM) then begin
        Item := TTntMenuItem.Create(MOpenDrive);
        with Item do begin
          Caption := Drive + ':';
          Tag := Ord(Drive);
          RadioItem := true;
          OnClick := MOpenDriveClick;
          if MDrive = Tnt_WideLowerCase(Caption) then NoAccess := 2;
        end;
        MOpenDrive.Add(Item);
      end;
    end
    else if i > -1 then begin
      MOpenDrive.Delete(i);
    end;
  end;

  MOpenDrive.Visible := MOpenDrive.Count > 0;
end;

procedure TMainForm.MOpenDriveClick(Sender: TObject);
begin
  PClear := true; EndOpenDir := true;
  Playlist.AddDirectory(char((Sender as TTntMenuItem).Tag) + ':', false);
  Playlist.Changed;
end;

procedure TMainForm.MKeyHelpClick(Sender: TObject);
begin
  if not OptionsForm.Visible then begin
    OptionsForm.Tab.ActivePage := OptionsForm.THelp;
    OptionsForm.Showmodal;
  end;
end;

procedure TMainForm.MAboutClick(Sender: TObject);
begin
  if not OptionsForm.Visible then begin
    OptionsForm.Tab.ActivePage := OptionsForm.TAbout;
    OptionsForm.Showmodal;
  end;
end;

procedure TMainForm.Init_MLanguage;
var i: integer; Item: TTntMenuItem;
begin
  MLanguage.Clear;
  for i := 0 to High(Locales) do begin
    Item := TTntMenuItem.Create(MLanguage);
    with Item do begin
      Caption := Locales[i].Name;
      GroupIndex := $70;
      RadioItem := true;
      AutoCheck := true;
      Tag := i;
      OnClick := MLanguageClick;
    end;
    MLanguage.Add(Item);
  end;
end;

procedure TMainForm.MLanguageClick(Sender: TObject);
begin
  ActivateLocale((Sender as TTntMenuItem).Tag);
end;

procedure TMainForm.MOptionsClick(Sender: TObject);
begin
  if not OptionsForm.Visible then begin
    if OptionsForm.Tab.TabIndex > 3 then OptionsForm.Tab.TabIndex := 0;
    OptionsForm.Showmodal;
  end;
end;

procedure TMainForm.SetCtrlV(Mode: boolean);
begin
  if Mctrl.Checked then begin
    Cpanel.Visible := Mode;
    fixsize;
  end;
end;

procedure TMainForm.SetMenuBarV(Mode: boolean);
begin
  if Hide_menu.Checked then begin
    MenuBar.Visible := Mode;
    fixsize;
  end;
end;

procedure TMainForm.MPCtrlClick(Sender: TObject);
begin
  MPCtrl.Checked := not MPCtrl.Checked;
  CPanel.Visible := MPCtrl.Checked;
  Mctrl.Checked := not MPCtrl.Checked;
  MenuBar.Visible := MPCtrl.Checked;
  Hide_menu.Checked := not MPCtrl.Checked;
  if CPanel.Visible then UpdateCaption;
  VideoSizeChanged;
end;

procedure TMainForm.SetFullscreen(Mode: boolean);
var PX, PY, SX, SY: integer;
begin
  MFullscreen.Checked := Mode; BFullscreen.Down := Mode;
  MPFullscreen.Checked := Mode;
  if not ControlledResize then begin
    if MCompact.Checked then begin
      ControlledResize := True; SetCompact(False);
      MCompact.Checked := false; BCompact.Down := false;
      MPCompact.Checked := false; ViewMode := 1;
    end;
    if MMaxW.Checked then begin
      ControlledResize := True; SetCompact(False);
      MMaxW.Checked := false; MPMaxW.Checked := false;
      ViewMode := 2;
    end;
  end;

  if MFullscreen.Checked then begin
    lm := CurMonitor.MonitorNum; lw := CurMonitor.Width; lh := CurMonitor.Height;
    FS_PX := Left; FS_PY := Top; FS_SX := Width; FS_SY := Height;
    CV := CPanel.Visible; MV := MenuBar.Visible;
    CPanel.Visible := false; MenuBar.Visible := false;
    mctrl.Checked := true; hide_menu.Checked := true;
    MPCtrl.Checked := false;
    PX := CurMonitor.Left + (OPanel.Width - Width) div 2;
    PY := CurMonitor.Top + (OPanel.Width - Width) div 2;
    SX := CurMonitor.Width + Width - OPanel.Width;
    SY := CurMonitor.Height + Width - OPanel.Width;

    ControlledResize := true;
    WStyle := GetWindowLong(Handle, GWL_STYLE);
    SetWindowLong(Handle, GWL_STYLE, WS_VISIBLE and (not WS_DLGFRAME));
    SetWindowPos(Handle, HWND_TOPMOST, PX, PY, SX, SY, 0);
  end
  else begin
    if (lm <> CurMonitor.MonitorNum) or (lw <> CurMonitor.Width) or (lh <> CurMonitor.Height) then begin
      if FS_SX > CurMonitor.Width then FS_SX := CurMonitor.Width;
      if FS_SY > CurMonitor.Height then FS_SY := CurMonitor.Height;
      if (FS_PX < CurMonitor.Left) or ((FS_PX + FS_SX) > (CurMonitor.Left + CurMonitor.Width)) then
        FS_PX := CurMonitor.Left + (CurMonitor.Width - FS_SX) div 2;
      if (FS_PY < CurMonitor.Top) or
        ((FS_PY + FS_SY) > (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)) then
        FS_PY := CurMonitor.Top + (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - FS_SY) div 2;
    end;
    ControlledResize := true; SetWindowLong(Handle, GWL_STYLE, WStyle and (not WS_MAXIMIZE));
    case OnTop of
      0: SetWindowPos(Handle, HWND_NOTOPMOST, FS_PX, FS_PY, FS_SX, FS_SY, 0);
      1: SetWindowPos(Handle, HWND_TOPMOST, FS_PX, FS_PY, FS_SX, FS_SY, 0);
      2: if core.Status = sPlaying then
          SetWindowPos(Handle, HWND_TOPMOST, FS_PX, FS_PY, FS_SX, FS_SY, 0)
        else
          SetWindowPos(Handle, HWND_NOTOPMOST, FS_PX, FS_PY, FS_SX, FS_SY, 0);
    end;
    CPanel.Visible := CV; MenuBar.Visible := MV; ViewMode := 0;
    Mctrl.Checked := not CV; Hide_Menu.Checked := not MV;
    MPCtrl.Checked := CV and MV;
    if MSize50.Checked or MSize100.Checked or MSize200.Checked or MSizeAny.Checked then LastScale := 100;
    ControlledResize := true; FormResize(nil);
    if CV then UpdateCaption;
  end;
end;

procedure TMainForm.SetCompact(Mode: boolean);
var L, T, W, H: integer;
begin
  if MFullscreen.Checked and not (ControlledResize) then begin
    ControlledResize := True; SetFullscreen(False);
  end;

  if Mode then begin
    FS_PX := Left; FS_PY := Top; FS_SX := Width; FS_SY := Height;
    WheelRolled := false; WStyle := GetWindowLong(Handle, GWL_STYLE);
    //SetWindowLong(Handle,GWL_STYLE,(DWORD(GetWindowLong(Handle,GWL_STYLE)) OR WS_POPUP) AND (NOT WS_DLGFRAME));
    if (Width >= (CurMonitor.Width - 20))
      or (Height >= (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - 20))
      or MMaxW.Checked then begin
      SetWindowLong(Handle, GWL_STYLE, WS_VISIBLE and (not WS_DLGFRAME));
      MFunc := 0; MWheelControl.Items[0].Checked := true;
      MPWheelControl.Items[0].Checked := true;
      L := CurMonitor.Left + (OPanel.Width - Width) div 2; T := CurMonitor.Top + (OPanel.Width - Width) div 2;
      W := CurMonitor.Width + Width - OPanel.Width;
      if (OPanel.Width = CurMonitor.Width) and (Height = CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top + Width - OPanel.Width)
        then H := Height + 1 //in this case, size don't change, SetBounds(L,T,W,H) will directly exit, so +1 to avoid this case.
      else H := CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top + Width - OPanel.Width;
    end
    else begin
      L := Left + IPanel.Left; T := Top + MWC + OPanel.Top + IPanel.Top;
      W := Width - 2 * IPanel.Left; H := IPanel.Height + Width - OPanel.Width;

      if (W < Constraints.MinWidth) and (NativeWidth <> 0) then begin
        W := Constraints.MinWidth;
        L := Left + (Width - W) div 2;
        H := Constraints.MinWidth * NativeHeight div NativeWidth;
        T := Top + (Height - H) div 2;
      end;
      //SetWindowLong(Handle,GWL_STYLE,(WS_THICKFRAME OR WS_VISIBLE) AND (NOT WS_DLGFRAME));
      SetWindowLong(Handle, GWL_STYLE, WStyle and (not WS_CAPTION));
      ControlledResize := true; MFunc := 1;
      MWheelControl.Items[1].Checked := true;
      MPWheelControl.Items[1].Checked := true;
    end;
    CPanel.Visible := False; MenuBar.Visible := False;
    Mctrl.Checked := true; Hide_menu.Checked := true;
    MPCtrl.Checked := false;
    SetBounds(L, T, W, H);
  end
  else begin
    SetWindowLong(Handle, GWL_STYLE, WStyle and (not WS_MAXIMIZE));
    //SetWindowLong(Handle,GWL_STYLE,(DWORD(GetWindowLong(Handle,GWL_STYLE)) OR WS_DLGFRAME) AND (NOT WS_POPUP));

    if MPMaxW.Checked and (not WheelRolled) then begin
      L := FS_PX; T := FS_PY; W := FS_SX; H := FS_SY;
    end
    else begin
      L := Left; W := Width; T := Top - (MWC + MenuBar.Height - OPanel.Top);
      if not Mctrl.Checked then H := Height + MWC + MenuBar.Height - OPanel.Top
      else if not Hide_menu.Checked then H := Height + MWC + MenuBar.Height - OPanel.Top + CPanel.Height
      else H := Height + MWC + MenuBar.Height + CPanel.Height;

      if L < CurMonitor.Left then L := CurMonitor.Left; if T < CurMonitor.Top then T := CurMonitor.Top;
      if W > CurMonitor.Width then W := CurMonitor.Width;
      if H > (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top) then
        H := CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top;
      if (L + W) > (CurMonitor.Left + CurMonitor.Width) then L := CurMonitor.Left + CurMonitor.Width - W;
      if (T + H) > (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top) then
        T := (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top) - H;
    end;
    CPanel.Visible := true; MenuBar.Visible := true;
    Mctrl.Checked := false; Hide_menu.Checked := false;
    MPCtrl.Checked := true;
    ControlledResize := true; SetBounds(L, T, W, H);
    UpdateCaption; MFunc := 0;
    MWheelControl.Items[0].Checked := true;
    MPWheelControl.Items[0].Checked := true;
  end;
end;

procedure TMainForm.FormGetMinMaxInfo(var msg: TMessage);
begin
  if MFullscreen.Checked then
    with PMinMaxInfo(msg.lParam)^.ptMaxTrackSize do begin
      X := 4095;
      Y := 4095;
    end;
  msg.Result := 0;
end;

procedure TMainForm.NextAudio;
var i, AudioIndex: integer;
begin
  if MAudio.Count < 2 then exit;
  AudioIndex := -1;
  for i := 0 to MAudio.Count - 1 do begin
    if MAudio.Items[i].Checked then begin
      AudioIndex := (i + 1) mod MAudio.Count;
    end;
  end;
  if AudioIndex < 0 then exit;
  with MAudio.Items[AudioIndex] do begin
    Checked := True;
    AudioID := Tag;
  end;
  if (CheckInfo(AudioDemuxer, DemuxerName) < 0) or (not Win32PlatformIsUnicode) then
    Restart
  else begin
    SendCommand('switch_audio ' + IntToStr(AudioID));
    if HaveVideo then
      SendCommand('osd_show_text "' + OSD_AudioTrack_Prompt + ': ' + IntToStr(AudioID) + #34);
  end;
end;

procedure TMainForm.NextVideo;
var i, VideoIndex: integer;
begin
  if MVideo.Count < 2 then exit;
  VideoIndex := -1;
  for i := 0 to MVideo.Count - 1 do begin
    if MVideo.Items[i].Checked then begin
      VideoIndex := (i + 1) mod MVideo.Count;
    end;
  end;
  if VideoIndex < 0 then exit;
  with MVideo.Items[VideoIndex] do begin
    Checked := True;
    VideoID := Tag;
  end;
  if (CheckInfo(VideoDemuxer, DemuxerName) < 0) or (not Win32PlatformIsUnicode) then
    Restart
  else begin
    SendCommand('set_property switch_video ' + IntToStr(VideoID));
    SendCommand('osd_show_text "' + OSD_VideoTrack_Prompt + ': ' + IntToStr(VideoID) + #34);
  end;
end;

procedure TMainForm.NextAspect;
begin
  MKaspect.Checked := true;
  Aspect := (Aspect + 1) mod MAspects.Count;
  MAspects.Items[Aspect].Checked := True;
  if (Expand = 2) or (not Win32PlatformIsUnicode) then Restart
  else begin
    CBHSA := 3;
    case Aspect of
      0: begin
          SendCommand('switch_ratio -1'); SendCommand('osd_show_text "' + OSD_Auto_Prompt + '"'); end;
      1: begin
          SendCommand('switch_ratio 1.3333'); SendCommand('osd_show_text 4:3'); end;
      2: begin
          SendCommand('switch_ratio 1.7777'); SendCommand('osd_show_text 16:9'); end;
      3: begin
          SendCommand('switch_ratio 2.35'); SendCommand('osd_show_text 2.35:1'); end;
      4: begin
          SendCommand('switch_ratio 1.5555'); SendCommand('osd_show_text 14:9'); end;
      5: begin
          SendCommand('switch_ratio 1.25'); SendCommand('osd_show_text 1.25:1'); end;
      6: begin
          SendCommand('switch_ratio 1.6'); SendCommand('osd_show_text 16:10'); end;
      7: begin
          SendCommand('switch_ratio 2.21'); SendCommand('osd_show_text 2.21:1'); end;
      8: begin
          SendCommand('switch_ratio 1'); SendCommand('osd_show_text 1:1'); end;
      9: begin
          SendCommand('switch_ratio 1.22'); SendCommand('osd_show_text 1.22:1'); end;
      10: begin
          if (InterW <> 0) and (InterW > 3 * InterH) then InterW := 3 * InterH;
          NativeHeight := InterH * NativeWidth div InterW; VideoSizeChanged;
          SendCommand('osd_show_text "' + OSD_Custom_Prompt + ' ' + IntToStr(InterW) + ':' + IntToStr(InterH) + #34);
        end;
    end;
  end;
end;

procedure TMainForm.NextAngle;
var i: integer; t: TMenuItem;
begin
  if not Running then exit;
  if bluray then t := MBRT
  else t := MDVDT;
  i := CheckMenu(t, TID);
  if i < 0 then exit;
  if CheckMenu(t.Items[i], 1) < 0 then exit;
  if t.Items[i].Items[1].Count < 2 then exit;
  if AID < 1 then AID := 1;
  AID := AID mod t.Items[i].Items[1].Count + 1;
  t.Items[i].Items[1].Items[AID - 1].Checked := True;
  if Win32PlatformIsUnicode and (not Dnav) then
    SendCommand('switch_angle ' + IntToStr(AID - 1))
  else begin
    Dreset := true; Restart;
  end;
end;

procedure TMainForm.NextMonitor;
var index: integer;
begin
  index := (CurMonitor.MonitorNum + 1) mod MTM.Count;
  MTMClick(MTM.Items[index]);
end;

procedure TMainForm.NextSub;
begin
  if MSubtitle.Count < 1 then exit;
  if SubID < 0 then SubID := 0;
  SubID := (SubID + 1) mod MSubtitle.Count;
  MSubtitle.Items[SubID].Checked := True;
  SendCommand('sub_select ' + IntToStr(SubID));
end;

procedure TMainForm.NextSubCP;
var i, CPindex: Integer;
begin
  if MSubtitle.Count < 1 then exit;
  for i := 0 to SCodepage.Count - 3 do begin
    if SCodepage.Items[i].Checked then begin
      SCodepage.Items[i].Checked := false;
      CPindex := (i + 1) mod (SCodepage.Count - 2);
      SSDClick(SCodepage.Items[CPindex]);
      Break;
    end;
  end;
end;

procedure TMainForm.NextFile(Direction: integer; ExitState: TPlaybackState);
var Index: integer;
begin
  //ForceStop;
  Index := Playlist.GetNext(ExitState, Direction);
  if Index < 0 then begin
    if AutoQuit then Close;
    if not Win32PlatformIsUnicode then TerminateMP else Stop;
    exit;
  end;
  Playlist.NowPlaying(Index);
  DoOpen(Playlist[Index].FullURL, Playlist[Index].DisplayURL);
end;

procedure TMainForm.NextOnTop;
begin
  OnTop := (OnTop + 1) mod MOnTop.Count;
  MOnTop.Items[OnTop].Checked := True;
  case OnTop of
    0: begin
        if not MFullscreen.Checked then begin
          if HaveVideo and (not Wid) then SendCommand('vo_ontop 0')
          else SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
        end;
        if HaveVideo and Wid then SendCommand('osd_show_text "' + OSD_OnTop0_Prompt + '"');
      end;
    1: begin
        if not MFullscreen.Checked then begin
          if HaveVideo and (not Wid) then SendCommand('vo_ontop 1')
          else SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
        end;
        if HaveVideo and Wid then SendCommand('osd_show_text "' + OSD_OnTop1_Prompt + '"');
      end;
    2: begin
        if (core.Status = sPlaying) and (not MFullscreen.Checked) then begin
          if HaveVideo and (not Wid) then SendCommand('set_property ontop 1')
          else SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
        end;
        if HaveVideo then SendCommand('osd_show_text "' + OSD_OnTop2_Prompt + '"');
      end;
  end;
end;

procedure TMainForm.BPrevNextClick(Sender: TObject);
begin
  UpdateParams; AutoNext := false;
  NextFile((Sender as TComponent).Tag, psSkipped);
end;

procedure TMainForm.MShowPlaylistClick(Sender: TObject);
begin
  if PlaylistForm.Visible then
    PlaylistForm.Hide
  else
    PlaylistForm.Show;
end;

procedure TMainForm.MStreamInfoClick(Sender: TObject);
begin
  if MStreamInfo.Checked then
    InfoForm.Hide
  else
    InfoForm.Show;
end;

procedure TMainForm.BStopClick(Sender: TObject);
begin
  CBHSA := 0;
  SetLastPos;
  Stop;
  //Playlist.GetNext(psSkipped,0);
end;

procedure TMainForm.UpdateStatus;
begin
  case core.Status of
    sPlaying: LStatus.Caption := LOCstr_Status_Playing;
    sPaused: LStatus.Caption := LOCstr_Status_Paused;
    sStopped: LStatus.Caption := LOCstr_Status_Stopped;
    sError: LStatus.Caption := LOCstr_Status_Error;
  end;
  if core.Status = sError then LStatus.Cursor := crHandPoint
  else LStatus.Cursor := crDefault;
  if (OnTop = 2) and (not MFullscreen.Checked) then begin
    if core.Status = sPlaying then begin
      if HaveVideo and (not Wid) then SendCommand('set_property ontop 1')
      else SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    end
    else begin
      if HaveVideo and (not Wid) then SendCommand('set_property ontop 0')
      else SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    end;
    if Plist.PlaylistForm.Visible then SetWindowPos(Plist.PlaylistForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    if InfoForm.Visible then SetWindowPos(InfoForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    if OptionsForm.Visible then SetWindowPos(OptionsForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    if EqualizerForm.Visible then SetWindowPos(EqualizerForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure TMainForm.UpdateParams;
begin
  Loadsub := 0; Loadsrt := 0; LoadVob := 0; MSecPos := -1; Adelay := 0; Sdelay := 0; HaveChapters := false;
  ETime := false; CBHSA := 0; Firstrun := true; HaveAudio := false; HaveVideo := false;
  Vobfile := ''; substring := ''; MShowSub.Checked := true; IsDMenu := false; SMenu := true;
  AudioID := -1; SubID := -1; VideoID := -1; TID := 1; CID := 1; AID := 1; CDID := 1;
  subcount := 0; Lastsubcount := 0; CurrentSubCount := 0;
  procArc := false; Dreset := false;
  LastPos := 0; SecondPos := -1; TotalTime := 0; Duration := '0:00:00'; ChapterLen := 0; ChaptersLen := 0;
  SeekBarSlider.Left := 0; UpdateSkipBar := SkipBar.Visible; dsEnd := false;
  AudioFile := '';
end;

procedure TMainForm.UpdateTime;
var s: string;
begin
  if Seeking then exit;
  if ETime then
    LTime.Caption := '-' + SecondsToTime(TotalTime - SecondPos) + '/' + Duration
  else
    LTime.Caption := SecondsToTime(SecondPos) + '/' + Duration;
  s := '';
  if cd or vcd then s := Tcap + IntToStr(CDID);
  if CID > 1 then s := Ccap + IntToStr(CID);
  if AID > 1 then begin
    if s <> '' then s := Acap + IntToStr(AID) + '@' + s else s := Acap + IntToStr(AID);
  end;
  if s <> '' then LTime.Caption := '[' + s + '] ' + LTime.Caption;
  TntApplication.Title := DisplayURL + ' [' + LTime.Caption + ']';
  if Mctrl.Checked then Caption := TntApplication.Title;
end;

procedure TMainForm.UpdateCaption;
begin
  if length(DisplayURL) <> 0 then Caption := DisplayURL
  else Caption := LOCstr_Title;
end;


procedure TMainForm.VolSliderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then exit;
  VolSlider.BevelInner := bvLowered;
  SeekMouseX := X;
end;

procedure TMainForm.VolSliderMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var NewX, MaxX, NewVolume: integer;
begin
  if not (ssLeft in Shift) then exit;
  NewX := X - SeekMouseX + VolSlider.Left;
  MaxX := VolFrame.ClientWidth - VolSlider.Width;
  if MaxX = 0 then exit;
  if NewX < 0 then NewX := 0;
  if NewX > MaxX then NewX := MaxX;
  VolSlider.Left := NewX;
  NewVolume := (NewX * 100 + (MaxX shr 1)) div MaxX;
  if NewVolume = Volume then exit;
  Volume := NewVolume;
  SendVolumeChangeCommand(Volume);
end;

procedure TMainForm.VolSliderMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  VolSlider.BevelInner := bvRaised;
end;

procedure TMainForm.BMuteClick(Sender: TObject);
begin
  VolFrame.Enabled := Mute; Mute := not (Mute);
  BMute.Down := Mute; MMute.Checked := BMute.Down;
  if mute then SendCommand('set_property volume 0')
  else begin
    if SoftVol then SendCommand('set_property volume ' + IntToStr(Volume div 10))
    else SendCommand('set_property volume ' + IntToStr(Volume));
  end;
end;

procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var i, j: integer;
begin
  if (ssCtrl in Shift) or (ssRight in Shift) then begin
    IPanel.PopupMenu:=nil;    OPanel.PopupMenu:=nil;
    if core.Status = sPaused then SendCommand('seek ' + IntToStr(WheelDelta div 20))
    else begin
      SendCommand('set_property mute 1');
      SendCommand('seek ' + IntToStr(WheelDelta div 20));
      SendCommand('set_property mute 0');
    end;
  end
  else begin
    case MFunc of
      0: SetVolumeRel(WheelDelta div 40);
      1: if MFullscreen.Checked then SetVolumeRel(WheelDelta div 40)
        else if ds or (NativeWidth <> 0) then begin
          if ((OPanel.Width = CurMonitor.Width) and (Height = CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top + Width - OPanel.Width) and (WheelDelta > 0)) or
            MFullscreen.Checked then exit;
          if ds then begin
            if Height = Constraints.MinWidth then exit; end
          else if (Height = Constraints.MinWidth * NativeHeight div NativeWidth) and (WheelDelta < 0) then exit;
          if WindowState = wsMaximized then
            SetWindowLong(Handle, GWL_STYLE, DWORD(GetWindowLong(Handle, GWL_STYLE)) and (not WS_MAXIMIZE));
          i := Width; j := Height; WheelRolled := true;
          Height := j + WheelDelta div 2; if j <> 0 then Width := Height * i div j;
          if (not ds) and (Width = Constraints.MinWidth) then Height := Constraints.MinWidth * NativeHeight div NativeWidth;
          Left := Left - (Width - i) div 2; Top := Top - (Height - j) div 2;
          if Left < (CurMonitor.Left + (OPanel.Width - Width) div 2) then Left := CurMonitor.Left + (OPanel.Width - Width) div 2;
          if Top < (CurMonitor.Top + (OPanel.Width - Width) div 2) then Top := CurMonitor.Top + (OPanel.Width - Width) div 2;
          if Width > (CurMonitor.Width + Width - OPanel.Width) then Width := CurMonitor.Width + Width - OPanel.Width;
          if Height > (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top + Width - OPanel.Width) then
            Height := CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top + Width - OPanel.Width;
          if (Left + Width) > (CurMonitor.Left + CurMonitor.Width + (Width - OPanel.Width) div 2) then
            Left := CurMonitor.Left + CurMonitor.Width - (Width + OPanel.Width) div 2;
          if (Top + Height) > (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top + (Width - OPanel.Width) div 2) then
            Top := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - Height + (Width - OPanel.Width) div 2;
        end;
    end;
  end;
end;

procedure TMainForm.UpdateDockedWindows;
begin
//PlaylistForm Docked
  if plist.LDocked and ((Left + Width) <= (CurMonitor.Left + CurMonitor.Width - 100)) then begin
    PlaylistForm.ControlledMove := false;
    PlaylistForm.Left := Left + Width;
    PlaylistForm.top := Top - Plist.TT;
  end;

  if plist.RDocked and (Left >= 100) then begin
    PlaylistForm.ControlledMove := false;
    PlaylistForm.Left := Left - PlaylistForm.Width;
    PlaylistForm.top := Top - Plist.TT;
  end;

  if plist.TDocked and ((Top + Height) <= (CurMonitor.Top + CurMonitor.Height - 100)) then begin
    PlaylistForm.ControlledMove := false;
    PlaylistForm.Top := Top + Height;
    PlaylistForm.left := left - Plist.LL;
  end;

  if plist.BDocked and (Top >= PlaylistForm.Height) then begin
    PlaylistForm.ControlledMove := false;
    PlaylistForm.Top := Top - PlaylistForm.Height;
    PlaylistForm.left := left - Plist.LL;
  end;

//InfoForm Docked
  if Info.Docked and ((Left + Width) <= (CurMonitor.Left + CurMonitor.Width - 100)) then begin
    InfoForm.ControlledMove := True;
    InfoForm.Left := Left + Width;
    InfoForm.ControlledMove := True;
    InfoForm.Top := Top;
  end;
end;

procedure TMainForm.FormMove(var msg: TMessage);
begin
  msg.Result := 0;
  UpdateDockedWindows;
end;

procedure TMainForm.Localize;
begin
  MPPlay.Caption := MPlay.Caption;
  MPPause.Caption := MPause.Caption;
  MPStop.Caption := MStop.Caption;
  MPPrev.Caption := MPrev.Caption;
  MPNext.Caption := MNext.Caption;
  MPOpenFile.Caption := MOpenFile.Caption;
  MPExpand.Caption := MExpand.Caption;
  MPNoExpand.Caption := MNoExpand.Caption;
  MPSrtExpand.Caption := MSrtExpand.Caption;
  MPSubExpand.Caption := MSubExpand.Caption;
  MPWheelcontrol.Caption := MWheelcontrol.Caption;
  MPVol.Caption := MVol.Caption; MPSize.Caption := MSize.Caption;
  MOSD.Caption := OSDMenu.Caption;
  MPNoOSD.Caption := MNoOSD.Caption; MPDefaultOSD.Caption := MDefaultOSD.Caption;
  MPTimeOSD.Caption := MTimeOSD.Caption; MPFullOSD.Caption := MFullOSD.Caption;
  MPFullscreen.Caption := MFullscreen.Caption; MSEqualizer.Caption := OptionsForm.CEq2.Caption;
  MPCompact.Caption := MCompact.Caption; MFlip.Caption := OptionsForm.CFlip.Caption;
  MPMaxW.Caption := MMaxW.Caption; MMirror.Caption := OptionsForm.CMir.Caption;
  MPQuit.Caption := MQuit.Caption; MRotate.Caption := OptionsForm.LRot.Caption;
  MChannels.Caption := OptionsForm.LCh.Caption; MSoftVol.Caption := OptionsForm.CSoftVol.Caption;
  MSpdif.Caption := OptionsForm.CSPDIF.Caption; MUseASS.Caption := OptionsForm.CAss.Caption;
  MShuffle.Caption := Playlistform.CShuffle.Hint; MLoopAll.Caption := Playlistform.CLoop.Hint;
  MOneLoop.Caption := PlaylistForm.COneLoop.Hint;
end;

procedure TMainForm.DisplayClick(Sender: TObject);
begin
  if poped then begin poped:=false; exit; end;

  if Running and (MouseMode > -1) then begin
    if Dnav and IsDMenu then begin
      SendCommand('dvdnav mouse'); //'dvdnav select' or 'dvdnav 6'
      exit;
    end;
    if SP then SendCommand('pause');
  end;
end;

procedure TMainForm.DisplayDblClick(Sender: TObject);
begin
  if SP and Running and (not (Dnav and IsDMenu)) and (MouseMode > -1) then SendCommand('pause');
  SimulateKey(MFullscreen);
end;

procedure TMainForm.DisplayMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p: TPoint;
begin
  GetCursorPos(p); OldX := p.X; OldY := p.Y;
  if (Shift=[ssMiddle]) or (Shift=[ssShift,ssLeft]) then MouseMode := 3 //Scale video
  else if (Shift=[ssLeft,ssRight]) or (Shift=[ssCtrl,ssLeft]) then MouseMode := 4 //Adjust aspect ratio
  else if IPanel.Cursor = crHandPoint then MouseMode := 2 //Drag Subtitle
  else if Shift=[ssRight] then MouseMode := 5 //Seek video
  else if ((Width <= CurMonitor.Width) or (Height <= (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)))
       and (WindowState = wsNormal) and (Shift=[ssLeft]) then MouseMode := 1;
end;

procedure TMainForm.DisplayMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var p: TPoint; OY,i,w,h : integer; t: boolean;
begin
  GetCursorPos(p);
  if (p.X = OldX) and (p.Y = OldY) then exit; //过滤播放器的UpdateTimer定时器中防系统休眠操作触发这个函数，误触发会造成很多不可预期的鼠标操作问题
  OY := p.Y - OPanel.ClientOrigin.Y;
  if (not MPCtrl.Checked) and (MouseMode = 0) then begin
    if CPanel.Visible then t := OY < OPanel.Height
    else begin
      if (MSubtitle.Count > 0) and Running then t := OY >= (OPanel.Height - 25)
      else t := OY >= (OPanel.Height - CPanel.Height);
    end;
    if t then SetCtrlV(not CPanel.Visible);

    if MenuBar.Visible then t := OY > 0
    else begin
      if (MSubtitle.Count > 0) and Running then t := OY <= 10
      else t := OY <= MenuBar.Height;
    end;
    if t then SetMenuBarV(not MenuBar.Visible);
  end;

  if abs(MouseMode) = 1 then begin
    SetCursor(Screen.Cursors[crSizeAll]);
    MouseMode := -1; //在拖动时不进行单击、双击事件
    left := left + p.X - OldX; Top := Top + p.Y - OldY;
    OldX := p.X; OldY := p.Y;
  end;

  if not Running then exit;
  if IPanel.Width < 1 then IPanel.Width := 1;
  if IPanel.Height < 1 then IPanel.Height := 1;
  i := (p.Y - IPanel.ClientOrigin.Y) * 100 div IPanel.Height;

  if (MouseMode = 0) and ((p.X <> OldX) or (p.Y <> OldY)) then begin
    OldX := p.X; OldY := p.Y; //Hide Cursor
//    if Dnav and (Sender = IPanel) and IsDMenu then SendCommand('set_mouse_pos ' + IntToStr(X * NativeWidth div IPanel.Width) + ' ' + IntToStr(Y * NativeHeight div IPanel.Height));
    if Dnav and (Sender = IPanel) and IsDMenu then SendCommand('set_mouse_pos ' + IntToStr(X) + ' ' + IntToStr(Y));
    if (MSubtitle.Count > 0) and (not IsDMenu) and (abs(i - SubPos) <= 10) then begin
      IPanel.Cursor := crHandPoint; OPanel.Cursor := crHandPoint;
      HideMouseAt := GetTickCount + 2000;
    end
    else SetMouseV(true);
  end;

  if abs(MouseMode) = 2 then begin
    MouseMode := -2; //在拖动时不进行单击、双击事件
    if ([ssCtrl,ssLeft]=shift) or ([ssRight]=shift) then begin //Scale Subtitle
      IPanel.PopupMenu:=nil; OPanel.PopupMenu:=nil;
      FSize := FSize + (p.X - OldX) / 60;
      OldX := p.X; OldY := p.Y;
      if FSize > 10 then FSize := 10; if FSize < 0.1 then FSize := 0.1;
      if ass then SendCommand('sub_scale ' + FloatToStr(FSize / Fscale) + ' 1')
      else SendCommand('sub_scale ' + FloatToStr(FSize) + ' 1');
    end
    else if (not ass) and ([ssLeft]=shift) then begin //Move Subtitle
      SubPos := i;
      if SubPos < 0 then SubPos := 0; if SubPos > 100 then SubPos := 100;
      SendCommand('sub_pos ' + IntToStr(SubPos) + ' 1');
    end;
  end;

  if abs(MouseMode) = 3 then begin   //Scale Video}
    MouseMode := -3; //在拖动时不进行单击、双击事件
    IPanel.PopupMenu:=nil; OPanel.PopupMenu:=nil;
    MSizeAny.Checked := True; MSizeAny.Checked := false;
    w:= OldY - p.Y; h:= p.X - OldX;
    if abs(w) > abs(h) then Scale := Scale + w
    else Scale := Scale + h;
    if Scale < 1 then Scale := 1;
    LastScale := Scale; MKaspect.Checked := true;
    FixSize;
    OldX := p.X; OldY := p.Y;
  end;

  if abs(MouseMode) = 4 then begin //Ajust Aspect ratio
    MouseMode := -4; //在拖动时不进行单击、双击事件
    SetCursor(Screen.Cursors[crCross]);
    IPanel.PopupMenu:=nil; OPanel.PopupMenu:=nil;
    w:= IPanel.Width + (p.X - OldX) * 2;
    h:= IPanel.Height - (p.Y - OldY) * 2;
    if w < 32 then begin
      IPanel.Left := OPanel.Width div 2 - 16;
      IPanel.Width:=32;
    end
    else begin
      IPanel.Left := IPanel.Left - (p.X - OldX);
      IPanel.Width := w;
    end;
    if h < 32 then begin
      IPanel.Top := OPanel.Height div 2 - 16;
      IPanel.Height := 32;
    end
    else begin
      IPanel.Top := IPanel.Top + (p.Y - OldY);
      IPanel.Height := h;
    end;
    OldX := p.X; OldY := p.Y;
  end;

  if abs(MouseMode) = 5 then begin
    MouseMode:= -5;
    IPanel.PopupMenu:=nil; OPanel.PopupMenu:=nil;
  end;
end;

procedure TMainForm.DisplayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p: TPoint;
begin
  GetCursorPos(p);
  if MouseMode = -4 then begin
    InterW := IPanel.Width; InterH := IPanel.Height;
    MKaspect.Checked := true;
    Aspect := MCustomAspect.Tag; MCustomAspect.Checked := true;
    NativeHeight := InterH * NativeWidth div InterW;
    FixSize;
  end
  else if MouseMode= 3 then begin
    MFunc := (MFunc + 1) mod 2;
    case MFunc of
      0: SendCommand('osd_show_text "0:' + OSD_Volume_Prompt + '"');
      1: SendCommand('osd_show_text "1:' + OSD_Size_Prompt + '"');
    end;
    MWheelControl.Items[MFunc].Checked := true;
    MPWheelControl.Items[MFunc].Checked := true;
  end
  else if MouseMode= -5 then begin
    if core.Status = sPaused then SendCommand('seek ' + IntToStr(p.X - OldX))
    else begin
      SendCommand('set_property mute 1');
      SendCommand('seek ' + IntToStr(p.X - OldX));
      SendCommand('set_property mute 0');
    end;
    OldX := p.X; OldY := p.Y;
  end;
  if (MouseMode < -1) and (not RFScr) then begin
    if Button=mbRight then begin IPanel.PopupMenu:=MPopup; OPanel.PopupMenu:=MPopup; end;
    if MouseMode < -2 then poped:=true;
  end
  else if Button=mbRight then begin
    if RFScr then SimulateKey(MFullscreen)
    else begin
      poped:=true;
      IPanel.PopupMenu:=MPopup; OPanel.PopupMenu:=MPopup;
    end;
  end;

  MouseMode := 0;
end;

procedure TMainForm.SetMouseV(Mode: boolean);
begin
  if Mode then begin
    Logo.Cursor := crDefault;
    IPanel.Cursor := crDefault;
    OPanel.Cursor := crDefault;
    HideMouseAt := GetTickCount + 500;
  end
  else begin
    OPanel.Cursor := -1;
    IPanel.Cursor := -1;
    Logo.Cursor := -1;
  end;
end;

procedure TMainForm.UpdateMenuCheck;
var i, a: Integer; s: string;
begin
  MChannels.Items[Ch].Checked := true;
  MRotate.Items[Rot].Checked := true;
  MDeinterlace.Items[Deinterlace].Checked := true;
  MAspects.Items[Aspect].Checked := true;
  MPostproc.Items[Postproc].Checked := true;
  MSEqualizer.Checked := Eq2;
  MFlip.Checked := Flip;
  MMirror.Checked := Mirror;
  MSpdif.Checked := SPDIF;
  MSoftVol.Checked := SoftVol;
  MUseASS.Checked := Ass;
  for i := 0 to SCodepage.Count - 3 do begin
    s := SCodepage.Items[i].Caption;
    a := Pos('&', s);
    s := Copy(s, 1, a - 1) + Copy(s, a + 1, MaxInt);
    if s = subcode then begin
      SCodepage.Items[i].Checked := True;
      Break;
    end
    else MainForm.SCodepage.Items[i].Checked := false;
  end;
end;

procedure TMainForm.UpdateMenuEV(Mode: boolean);
begin
  MVideos.Visible := Mode; MSub.Visible := Mode; MPWheelControl.Visible := Mode;
  N12.Visible := Mode and Wid; MPFullscreen.Visible := (Mode and Wid) or ds; N3.Visible := Mode;
  MPExpand.Visible := Mode; OSDMenu.Visible := Mode; MWheelControl.Visible := Mode and Wid;
  MOSD.Visible := Mode; MFullscreen.Visible := (Mode and Wid) or ds; MSCS.Visible := Mode and Wid;
  N35.Visible := Mode and Wid; MSizeAny.Visible := Mode and Wid; MSize50.Visible := Mode and Wid;
  MSize200.Visible := Mode and Wid; MSize100.Visible := Mode and Wid;
  MCompact.Visible := (Mode and Wid) or ds; Hide_menu.Visible := (Mode and Wid) or ds;
  Mctrl.Visible := (Mode and Wid) or ds; MKaspect.Visible := Mode and Wid;
  MPCtrl.Visible := (Mode and Wid) or ds; MPCompact.Visible := (Mode and Wid) or ds;
  MMaxW.Visible := (Mode and Wid) or ds; MPMaxW.Visible := (Mode and Wid) or ds;

  BFullscreen.Enabled := Mode and Wid; BCompact.Enabled := Mode and Wid;
end;

procedure TMainForm.FormWantSpecialKey(var msg: TCMWantSpecialKey);
begin
  msg.Result := 1;
end;

procedure TMainForm.LStatusClick(Sender: TObject);
begin
  if (core.Status = sError) and (not OptionsForm.Visible) then begin
    OptionsForm.Tab.ActivePage := OptionsForm.TLog;
    OptionsForm.Showmodal;
  end;
end;

procedure TMainForm.VolBoostClick(Sender: TObject);
begin
  if Volume > 100 then begin
    SendVolumeChangeCommand(100);
    Volume := 100;
    VolBoost.Visible := false;
  end;
end;

procedure TMainForm.MExpandClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  Expand := (Sender as TTntMenuItem).Tag;
  MExpand.Items[Expand].Checked := true;
  MPExpand.Items[Expand].Checked := true;
  Restart;
end;

procedure TMainForm.MctrlClick(Sender: TObject);
begin
  Mctrl.Checked := not Mctrl.Checked;
  CPanel.Visible := not Mctrl.Checked;
  MPCtrl.Checked := not (Mctrl.Checked or Hide_menu.Checked);
  if CPanel.Visible then UpdateCaption;
  VideoSizeChanged;
end;

procedure TMainForm.Hide_menuClick(Sender: TObject);
begin
  Hide_menu.Checked := not Hide_menu.Checked;
  MenuBar.Visible := not Hide_menu.Checked;
  MPCtrl.Checked := not (Mctrl.Checked or Hide_menu.Checked);
  VideoSizeChanged;
end;

procedure TMainForm.MLoadsubClick(Sender: TObject);
var i, s, a: integer; j: WideString;
begin
  with OpenDialog do begin
    Title := MLoadSub.Caption;
    Options := Options + [ofAllowMultiSelect] - [ofoldstyledialog];
    filter := SubFilter + '|*.utf*;*.idx;*.sub;*.srt;*.smi;*.rt;*.txt;*.ssa;*.aqt;*.jss;*.js;'
      + '*.arj;*.bz2;*.z;*.lzh;*.cab;*.lzma;*.xar;*.hfs;*.dmg;*.wim;*.split;*.rpm;*.deb;*.cpio;*.tar;*.gz;'
      + '*.ass;*.ifo;*.mpsub;*.rar;*.7z;*.zip;*.001|' + AnyFilter + '(*.*)|*.*';
    if Execute then begin
      VobFileCount := 0; s := 0;
      for i := 0 to Files.Count - 1 do begin
        Loadsub := 1; j := Tnt_WideLowerCase(WideExtractFileExt(Files[i]));
        if j = '.idx' then begin
          j := GetFileName(Files[i]);
          if not WideFileExists(j + '.sub') then j := loadArcSub(Files[i]);
          if j <> '' then begin
            inc(VobFileCount);
            if VobFileCount = 1 then begin
              Vobfile := j; LoadVob := 1; Restart;
            end;
          end;
        end
        else begin
          a := CheckInfo(MediaType, j);
          if (a > -1) and (a <= ZipTypeCount) then begin
            if IsLoaded(j) then begin
              j := ExtractSub(Files[i], playlist.FindPW(Files[i]));
              if j <> '' then begin
                inc(VobFileCount);
                if VobFileCount = 1 then begin
                  Vobfile := j; LoadVob := 1; Restart;
                end;
              end;
            end;
          end
          else begin
            j := Files[i];
            if (not IsWideStringMappableToAnsi(j)) or (pos(',', j) > 0) then j := WideExtractShortPathName(j);
            if pos(j, substring) = 0 then begin
              if not Win32PlatformIsUnicode then begin
                Loadsub := 2; Loadsrt := 2;
                AddChain(s, substring, EscapeParam(j));
              end
              else
                SendCommand('sub_load ' + Tnt_WideStringReplace(EscapeParam(j), '\', '/', [rfReplaceAll]));
            end;
          end;
        end;
      end;
      if (not Win32PlatformIsUnicode) and (s > 0) then Restart;
    end;
  end;
end;

procedure TMainForm.MSubfontClick(Sender: TObject);
begin
  if not OptionsForm.Visible then begin
    OptionsForm.Tab.ActivePage := OptionsForm.TSub;
    OptionsForm.Showmodal;
  end;
end;

procedure TMainForm.MKaspectClick(Sender: TObject);
begin
  MKaspect.Checked := not MKaspect.Checked;
  FixSize;
end;

procedure TMainForm.LTimeClick(Sender: TObject);
begin
  if Running then ETime := not ETime;
end;

procedure TMainForm.MWheelControlClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  MFunc := (Sender as TTntMenuItem).Tag;
  MWheelControl.Items[MFunc].Checked := true;
  MPWheelControl.Items[MFunc].Checked := true;
  case MFunc of
    0: SendCommand('osd_show_text "0:' + OSD_Volume_Prompt + '"');
    1: SendCommand('osd_show_text "1:' + OSD_Size_Prompt + '"');
  end;
end;

procedure TMainForm.MIntroClick(Sender: TObject);
begin
  Bp := SecondPos;
  if Bp > 0 then begin
    if TotalTime > 0 then SkipBar.Left := SeekBar.Left + SeekBar.Width * Bp div TotalTime;
    SkipBar.Visible := true; BackBar.Visible := true;
  end
  else SkipBar.Left := SeekBar.Left;
  if Bp >= Ep then Ep := 0;
  if Ep > 0 then begin
    if TotalTime > 0 then SkipBar.Width := (SeekBar.Width * Ep div TotalTime) - SkipBar.Left + SeekBar.Left
  end
  else SkipBar.Width := SeekBar.Width - SkipBar.Left + SeekBar.Left;
end;

procedure TMainForm.MEndClick(Sender: TObject);
begin
  Ep := SecondPos;
  if Ep <= Bp then begin
    Bp := 0; SkipBar.Left := SeekBar.Left;
  end;
  if Ep > 0 then begin
    if TotalTime > 0 then SkipBar.Width := (SeekBar.Width * Ep div TotalTime) - SkipBar.Left + SeekBar.Left;
    SkipBar.Visible := true; BackBar.Visible := true;
  end
  else SkipBar.Width := SeekBar.Width - SkipBar.Left + SeekBar.Left;
end;

procedure TMainForm.MSIEClick(Sender: TObject);
var key: word;
begin
  MSIE.Checked := not MSIE.Checked;
  BSkip.Down := MSIE.Checked;
  UpdateSkipBar := MSIE.Checked;
  SkipBar.Visible := MSIE.Checked;
  BackBar.Visible := MSIE.Checked;
  if MSIE.Checked then begin
    SkipBar.Color := $0051AEE6;
    if TotalTime > 0 then begin
      if (Bp > 0) and (Bp < TotalTime) then begin
        if Bp > SecondPos then begin
          if core.Status = sPaused then SendCommand('seek ' + IntToStr(Bp - SecondPos))
          else begin
            SendCommand('set_property mute 1');
            SendCommand('seek ' + IntToStr(Bp - SecondPos));
            SendCommand('set_property mute 0');
          end;
        end;
        SkipBar.Left := SeekBar.Left + SeekBar.Width * Bp div TotalTime;
      end
      else SkipBar.Left := SeekBar.Left;

      if (Ep > 0) and (Ep < TotalTime) then begin
        SkipBar.Width := (SeekBar.Width * Ep div TotalTime) - SkipBar.Left + SeekBar.Left;
        if SecondPos > Ep then begin
          if HaveChapters then begin
            key := VK_HOME;
            FormKeyDown(nil, key, []);
          end
          else begin
            UpdateParams; NextFile(1, psPlayed);
          end
        end;
      end
      else SkipBar.Width := SeekBar.Width - SkipBar.Left + SeekBar.Left;
    end;
  end
  else SkipBar.Color := $0078DD73;
end;

procedure TMainForm.MEqualizerClick(Sender: TObject);
begin
  if not EqualizerForm.Visible then EqualizerForm.Showmodal;
end;

procedure TMainForm.MQuitClick(Sender: TObject);
begin
  close;
end;

procedure TMainForm.MChannelsClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  Ch := (Sender as TTntMenuItem).Tag;
  MChannels.Items[Ch].Checked := true;
  Restart;
end;

procedure TMainForm.MFlipClick(Sender: TObject);
begin
  Flip := not Flip;
  Restart; MFlip.Checked := Flip;
end;

procedure TMainForm.MMirrorClick(Sender: TObject);
begin
  Mirror := not Mirror;
  Restart; MMirror.Checked := Mirror;
end;

procedure TMainForm.MRotateClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  Rot := (Sender as TTntMenuItem).Tag;
  MRotate.Items[Rot].Checked := true;
  Restart;
end;

procedure TMainForm.MSpdifClick(Sender: TObject);
begin
  SPDIF := not SPDIF; MSpdif.Checked := SPDIF;
  Restart;
end;

procedure TMainForm.MSEqualizerClick(Sender: TObject);
begin
  Eq2 := not Eq2; MSEqualizer.Checked := Eq2;
  Restart;
end;

procedure TMainForm.MLoadAudioClick(Sender: TObject);
begin
  with OpenDialog do begin
    Title := MLoadAudio.Caption;
    Options := Options - [ofAllowMultiSelect] - [ofoldstyledialog];
    filter := AudioFilter + '|*.aa;*.a52;*.aif*;*.au*;*.mp2;*.snd;*.cda;*.ac3;*.dts;'
      + '*.mp3;*.ogg;*.mp4;*.wma;*.mka;*.mid*;*.rmi;*.rm;*.wav;*.dtswav;'
      + '*.ra;*.mpa;*.m4a;*.aac;*.m1a;*.mod;*.fla*;*.m2a;*.far;*.it;'
      + '*.s3m;*.stm;*.mtm;*.umx;*.asf;*.ram;*.mpc;*.mp+;*.tta;*.ape;*.mac;'
      + '*.mp1;*.mp3pro;*.xm;*.xmz|' + AnyFilter + '(*.*)|*.*';
    if Execute then begin
      if IsWideStringMappableToAnsi(fileName) then AudioFile := fileName
      else AudioFile := WideExtractShortPathName(fileName);
      restart;
      MUloadAudio.Visible := true;
    end;
  end;
end;

procedure TMainForm.MSoftVolClick(Sender: TObject);
begin
  SoftVol := not SoftVol; MSoftVol.Checked := SoftVol;
  Restart;
end;

procedure TMainForm.MUloadAudioClick(Sender: TObject);
begin
  AudioFile := '';
  restart;
  MUloadAudio.Visible := false;
end;

procedure TMainForm.VolImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var MaxPos: integer;
begin
  if VolBoost.Visible or (Button <> mbLeft) then exit;
  dec(X, VolSlider.Width div 2);
  MaxPos := VolImage.Width - VolSlider.Width;
  if MaxPos = 0 then exit;
  if X < 0 then X := 0; if X > MaxPos then X := MaxPos;
  Volume := 100 * X div MaxPos;
  SendVolumeChangeCommand(Volume);
  VolSlider.Left := X;
end;

procedure TMainForm.MScale0Click(Sender: TObject);
begin
  LastScale := 100; Scale := 100; FixSize;
  SendCommand('osd_show_text "' + OSD_Reset_Prompt + ' ' + OSD_Scale_Prompt + '"')
end;

procedure TMainForm.MPanClick(Sender: TObject);
begin
  SendCommand('set_property balance 0'); balance := 0;
  if HaveVideo then SendCommand('osd_show_text "' + OSD_Reset_Prompt + ' ' + OSD_Balance_Prompt + '"');
end;

procedure TMainForm.MPostprocClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  Postproc := (Sender as TTntMenuItem).Tag;
  MPostproc.Items[Postproc].Checked := true;
  Restart;
end;

procedure TMainForm.MUseASSClick(Sender: TObject);
begin
  Ass := not Ass; MUseASS.Checked := Ass;
  Restart;
end;

procedure TMainForm.MOneLoopClick(Sender: TObject);
begin
  PlaylistForm.COneLoopClick(nil);
end;

procedure TMainForm.MLoopAllClick(Sender: TObject);
begin
  PlaylistForm.CLoopClick(nil);
end;

procedure TMainForm.MShuffleClick(Sender: TObject);
begin
  PlaylistForm.CShuffleClick(nil);
end;

procedure TMainForm.MAudioDelay2Click(Sender: TObject);
begin
  SendCommand('audio_delay 0 1'); Adelay := 0;
  SendCommand('osd_show_text "' + OSD_Reset_Prompt + ' ' + OSD_AudioDelay_Prompt + '"');
end;

procedure TMainForm.MSubDelay2Click(Sender: TObject);
begin
  SendCommand('sub_delay 0 1'); Sdelay := 0;
  SendCommand('osd_show_text "' + OSD_Reset_Prompt + ' ' + OSD_SubDelay_Prompt + '"');
end;

procedure TMainForm.MLoadlyricClick(Sender: TObject);
var j: WideString; i: integer;
begin
  with OpenDialog do begin
    Title := MLoadlyric.Caption;
    Options := Options - [ofAllowMultiSelect] - [ofoldstyledialog];
    filter := LyricFilter + '|*.lrc;*.7z;*.rar;*.zip;*.001;'
      + '*.arj;*.bz2;*.z;*.lzh;*.cab;*.lzma;*.xar;*.hfs;*.dmg;*.wim;*.split;*.rpm;*.deb;*.cpio;*.tar;*.gz'
      + '|' + AnyFilter + '(*.*)|*.*';
    if Execute then begin
      j := Tnt_WideLowerCase(WideExtractFileExt(FileName));
      i := CheckInfo(MediaType, j);
      if (i > -1) and (i <= ZipTypeCount) then begin
        if IsLoaded(j) then ExtractLyric(FileName, playlist.FindPW(FileName));
      end
      else Lyric.ParseLyric(fileName);
    end;
  end;
end;

procedure TMainForm.MUUniClick(Sender: TObject);
begin
  MUUni.Checked := not UseUni;
  UseUni := MUUni.Checked;
  Restart;
end;

procedure TMainForm.MSubScale2Click(Sender: TObject);
begin
  if ass then SendCommand('set_property sub_scale 1.4')
  else SendCommand('set_property sub_scale 4.5');
  FSize := 4.5;
  SendCommand('osd_show_text "' + OSD_Reset_Prompt + ' ' + OSD_Scale_Prompt + '"');
end;

procedure TMainForm.MSCSClick(Sender: TObject);
begin
  NW := OPanel.Width; NH := OPanel.Height;
  Config.Save(HomeDir + DefaultFileName, 3);
end;

procedure TMainForm.MOpenDevicesClick(Sender: TObject);
begin
  if not OpenDevicesForm.Visible then OpenDevicesForm.ShowModal;
end;

procedure TMainForm.MdownloadsubtitleClick(Sender: TObject);
begin
  DLyricForm.Show; DLyricForm.PLS.ActivePageIndex := 1;
  DLyricForm.PLSChange(nil);
  if dsEnd or (not AutoDs) then exit;
  LoadSLibrary;
  if IsSLoaded <> 0 then
    DownloaderSubtitleW(PWChar(MediaURL), True, DownSubtitle_CallBackW, DownSubtitle_CallBackFinish);
end;

procedure TMainForm.MDownloadLyricClick(Sender: TObject);
begin
  PlaylistForm.MDownloadLyricClick(nil);
end;

procedure TMainForm.SSDClick(Sender: TObject);
var s: string; i: Integer;
begin
  if (Sender as TTntMenuItem).Checked then Exit;
  (Sender as TTntMenuItem).Checked := true;
  s := (Sender as TTntMenuItem).Caption;
  i := Pos('&', s);
  subcode := Copy(s, 1, i - 1) + Copy(s, i + 1, MaxInt);
  Restart;
end;

procedure TMainForm.more1Click(Sender: TObject);
begin
  if not OptionsForm.Visible then begin
    OptionsForm.Tab.ActivePage := OptionsForm.TSub;
    OptionsForm.Showmodal;
  end;
end;

procedure TMainForm.MTMClick(Sender: TObject);
begin
  if (Sender as TTntMenuItem).Checked then exit;
  (Sender as TTntMenuItem).Checked := true;
  CurMonitor := Screen.Monitors[(Sender as TTntMenuItem).tag];
  if (Width > CurMonitor.Width) or MFullscreen.Checked then Width := CurMonitor.Width;
  if (Height > CurMonitor.Height) or MFullscreen.Checked then Height := CurMonitor.Height;
  if MMaxW.Checked then begin
    Width := CurMonitor.Width;
    Height := CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top;
  end;
  Left := CurMonitor.Left + (CurMonitor.Width - Width) div 2;
  Top := CurMonitor.Top + (CurMonitor.Height - Height) div 2;
end;

end.

