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
unit Core;
interface
uses Windows, TntWindows, SysUtils, TntSysUtils, TntSystem, Classes, Forms, Menus, TntMenus,
  Controls, Graphics, Dialogs, MultiMon, ShlObj, TntClasses;

const ABOVE_NORMAL_PRIORITY_CLASS: Cardinal = $00008000;
const PauseCMD: array[0..1] of WideString = ('pause', 'frame_step');
const PauseInfo: array[0..1] of WideString = ('=  PAUSE  =', '= 暂停 =');
const CacheFill: array[0..4] of WideString = ('Cache fill:', '缓存填充:', '缓冲填充:', '緩存填充:', '緩沖填充:');
const GenIndex: array[0..2] of WideString = ('Generating Index:', '正在生成索引:', '正在生成索引:');
const defaultHeight = 340; RFileMax = 10; stopTimeout = 1000; Dsubpos = 96;
const szdllCount = 2; Fscale = 4.2;
const sddll = 'SubDownloader.dll';
const szdll: array[0..szdllCount] of WideString = ('7zxa.dll', '7za.dll', '7z.dll');

const SubTypeCount = 15;
  SubType: array[0..SubTypeCount] of WideString = (
    '.lrc', '.utf', '.utf8', '.utf-8', '.srt', '.smi', '.rt', '.txt', '.ssa', '.aqt', '.jss',
    '.js', '.ass', '.mpsub', '.idx', '.sub'
    );

const ZipTypeCount = 19;
const MediaType: array[0..229] of WideString = ('.7z', '.rar', '.zip', '.001', '.arj', '.bz2', '.z', '.lzh',
    '.cab', '.lzma', '.xar', '.hfs', '.dmg', '.wim', '.split', '.rpm', '.deb', '.cpio','.tar', '.gz',
    '.aac', '.ac3', '.acc', '.act', '.aif', '.aifc', '.aiff', '.alac', '.amf', '.amr', '.amv', '.ape',
    '.as', '.asf', '.asx',
    '.a52', '.ape', '.apl', '.au', '.avi', '.avs', '.bik', '.bin', '.cda', '.cmf', '.cmn', '.cpk', '.csf',
    '.d2v', '.dat', '.drc', '.dsm', '.dsv', '.dsa', '.dss', '.dts', '.dtswav',
    '.dv', '.dvd', '.dvr-ms', '.divx', '.evo', '.f4v', '.far', '.fla', '.flac', '.flc', '.fli', '.flic', '.flm',
    '.flv', '.grf', '.hdmov', '.hlv',
    '.img', '.iso', '.ivf', '.ivm', '.it', '.itz', '.jsv', '.kar', '.m1a', '.m2a', '.m2p', '.m2t', '.m2ts',
    '.m1v', '.m2v', '.m3u', '.m3u8', '.m4a', '.m4b', '.m4p', '.m4v', '.mac', '.mdz', '.mid',
    '.midi', '.miz', '.mjf', '.mka', '.mkv', '.mod', '.mov', '.mp1', '.mp2', '.mp2v',
    '.mp3', '.mp3pro', '.mp4', '.mp4v', '.mp5', '.mpa', '.mpc', '.mpcpl', '.mpe',
    '.mpeg', '.mpeg1', '.mpeg2', '.mpeg4', '.mpg', '.mpga', '.mp+', '.mpp',
    '.mtm', '.mpv', '.mpv2', '.mpv4', '.mqv', '.mts', '.nrg', '.nsa', '.nst', '.nsv', '.nuv', '.ofr', '.ofs', '.oga', '.ogg',
    '.ogm', '.ogv', '.ogx', '.okt', '.pls', '.pm2', '.pmp',
    '.pmp2', '.pss', '.ptm', '.pva', '.qt', '.ra', '.ram', '.rat', '.ratdvd', '.rm', '.rmi', '.rmj',
    '.rmm', '.rmp', '.rms', '.rmvb', '.rmx', '.rnx', '.roq', '.rp', '.rpm', '.rsc', '.rsm', '.rt', '.rv', '.realpix',
    '.s3m', '.s3z', '.scm', '.sdp', '.smil', '.smk', '.smpl', '.smv', '.snd', '.stm', '.stz', '.swa', '.swf', '.tim', '.tod', '.tp', '.tpr',
    '.tps', '.ts', '.tta', '.ttpl', '.ult', '.umx', '.vcd', '.vfw', '.vg2', '.vid', '.vivo', '.vob', '.voc', '.vp3', '.vp4', '.vp5',
    '.vp6', '.vp7', '.vqf', '.wav', '.wax', '.webm', '.wm', '.wma', '.wmp', '.wmv', '.wmx',
    '.wpl', '.wv', '.wvx', '.xm', '.xmz', '.xspf',
    '.261', '.264', '.3g2', '.3gp', '.3gpp', '.3gp2', '.669'
    );

const PlaylistType: array[0..10] of WideString = (
    '.m3u', '.asx', '.wpl', '.pls', '.ttpl', '.rmp', '.xspf',
    '.smpl', '.m3u8', '.mpcpl', '.wmx'
    );

const VideoDemuxer: array[0..5] of WideString = (
    'avinini', 'avini', 'avi', 'mpegts', 'lavf', 'lavfpref'
    );

const AudioDemuxer: array[0..12] of WideString = (
    'mkv', 'mpegts', 'mpegps', 'mpegpes', 'mpeges',
    'mpeg4es', 'h264es', 'lavf', 'lavfpref', 'avinini', 'avini', 'avi', 'pmp'
    );

const DefaultFass = '0aac,1ac3,1acc,1act,1aif,1aifc,1aiff,0amf,1amr,1amv,0ape,0as,1asf,1asx,'
    + '0a52,0apl,1au,1avi,0avs,1bik,0bin,0cda,0cmf,0cmn,0cpk,0cue,1d2v,0dat,0drc,'
    + '1dsm,1dsv,1dsa,1dss,1dts,0dtswav,0dv,0dvr-ms,0divx,1evo,0far,0fla,0flac,1flc,'
    + '1fli,1flic,0flm,1flv,0grf,0hdmov,0img,0iso,1ivf,0it,0itz,0jsv,0kar,0m1a,0m2a,'
    + '1m2p,1m2ts,1m1v,1m2v,1m3u,1m3u8,1m4a,1m4b,1m4p,1m4v,0mac,0mdz,0miz,'
    + '0mjf,1mka,1mkv,1mod,1mov,0mp1,1mp2,0mp2v,1mp3,0mp3pro,1mp4,0mp5,0mpa,0mpc,1mpcpl,'
    + '1mpe,1mpeg,1mpg,1mpga,0mp+,0mpp,0mtm,0mpv,0mpv2,0mqv,1mts,0nrg,0nsa,0nst,0nsv,0nuv,'
    + '0ogg,0ogm,0okt,0pls,1pmp,1pmp2,1pss,0ptm,1pva,1qt,1ra,1ram,1ratdvd,1rm,0rmi,0rmj,'
    + '0rmm,0rmp,0rms,1rmvb,0rmx,0rnx,0roq,0rp,1rpm,0rt,0rv,1realpix,0s3m,0s3z,1scm,0sdp,'
    + '1smil,1smk,1smpl,0snd,0stm,0stz,1tp,1tpr,1ts,0tta,0ttpl,0ult,0umx,0vcd,0vfw,1vg2,'
    + '1vid,0vivo,1vob,0voc,0vp3,0vp4,0vp5,1vp6,1vp7,1vqf,0wav,1wax,1wm,1wma,1wmp,1wmv,1wmx,'
    + '0wpl,1wv,1wvx,0xm,0xmz,0xspf,0261,0264,13g2,13gp,13gpp,13gp2,0669';

const DefaultHotKey: array[0..102] of Integer = (
    262182, 262184, 262181, 262183, 262331, 262333, 131123, 131264, 131121, 131122,
    65601, 65605, 65728, 65619, 65626, 109, 107, 79, 192, 222, 69, 87, 49, 50, 51, 52, 53,
    54, 55, 56, 57, 48, 46, 45, 68, 70, 67, 84, 82, 86, 83, 89, 85, 90, 88, 71, 72, 73, 75, 74,
    76, 186, 113, 114, 115, 116,117, 9, 13, 262223, 262220, 262231, 262227, 262336, 262225,
    262212, 262152, 131187, 65604, 65612, 65618, 37, 39, 38, 40, 33, 34, 36, 35, 8, 189,
    187, 77, 78, 66, 81, 80, 188, 190, 65, 112, 120, 121, 122, 123, 219, 221, 220, 191, 32, 118, 119,262209);

const DefaultHKS = '262182,262184,262181,262183,262331,262333,131123,131264,131121,131122,'
    + '65601,65605,65728,65619,65626,109,107,79,192,222,69,87,49,50,51,52,53,'
    + '54,55,56,57,48,46,45,68,70,67,84,82,86,83,89,85,90,88,71,72,73,75,74,'
    + '76,186,113,114,115,116,117,9,13,262223,262220,262231,262227,262336,262225,'
    + '262212,262152,131187,65604,65612,65618,37,39,38,40,33,34,36,35,8,189,'
    + '187,77,78,66,81,80,188,190,65,112,120,121,122,123,219,221,220,191,32,118,119,262209';

type TStatus = (sNone, sOpening, sClosing, sPlaying, sPaused, sStopped, sError);
var Status: TStatus;

  HomeDir, SystemDir, TempDir, AppdataDir: WideString;
  MediaURL, TmpURL, ArcMovie, Params, AddDirCP,avThread,cl: WideString;
  ArcPW, TmpPW, DisplayURL, AudioFile: WideString;
  Duration, LyricF, fass, HKS, lastP1, lastFN: string;
  substring, Vobfile, ShotDir, LyricDir, LyricURL: WideString;
  subfont, osdfont, Ccap, Acap, Tcap, DemuxerName: WideString;
  MplayerLocation, WadspL, AsyncV, CacheV: widestring;
  MAspect, subcode, VideoOut: string;
  FirstOpen, PClear, Fd, Async, Cache, uof, oneM, FilterDrop,AutoDs: boolean;
  Wid, Dreset, UpdateSkipBar, Pri, HaveChapters, HaveMsg, skip,bluray,dvd,vcd,cd: boolean;
  CT, RP, RS, SP, AutoPlay, ETime, InSubDir, SPDIF, ML, GUI, dlod: boolean;
  Shuffle, Loop, OneLoop, Uni, Utf, UseUni,ADls: boolean;
  ControlledResize, ni, nobps, Dnav, IsDMenu, SMenu, lavf, UdvdTtime, vsync: boolean;
  Flip, Mirror, Yuy2, Eq2, LastEq2, Dda, LastDda, Wadsp, addsFiles: boolean;
  WantFullscreen, WantCompact, AutoQuit, IsPause, IsDx, dsEnd,uav: boolean;
  VideoID, Ch, CurPlay, LyricS, HaveLyric: integer;
  AudioID, MouseMode, SubPos, NoAccess: integer;
  SubID, TID, tmpTID, CID, AID, VCDST, CDID: integer;
  subcount, Bp, Ep, CurrentLocale: integer;
  Lastsubcount: integer;
  CurLyric, NextLyric, LyricCount,MaxLenLyric: integer;
  VobsubCount, VobFileCount: integer;
  CurrentSubCount, OnTop, VobAndInterSubCount, IntersubCount: integer;
  IL, IT, EL, ET, EW, EH, InterW, InterH, NW, NH, OldX, OldY, Scale, LastScale: integer;
  MFunc, CBHSA, bri, briD, contr, contrD, hu, huD, sat, satD, gam, gamD: integer;
  AudioOut, AudioDev, Postproc, Deinterlace, Aspect: integer;
  ReIndex, SoftVol, RFScr, dbbuf, nfc, nmsg, Firstrun, Volnorm, Dr: boolean;
  Loadsrt, LoadVob, Loadsub, Expand, TotalTime, TTime, ChapterLen, ChaptersLen: integer;
  HaveAudio, HaveVideo, LastHaveVideo, ChkAudio, ChkVideo, ChkStartPlay: boolean;
  NativeWidth, NativeHeight, MonitorID, MonitorW, MonitorH: integer;
  LastPos, SecondPos, OSDLevel, DefaultOSDLevel, MSecPos: integer;
  Volume, MWC, CP, seekLen: integer;
  ds, tEnd, procArc, Mute, Ass, Efont, ISub, AutoNext, UpdatePW, sconfig, EndOpenDir: boolean;
  DTFormat: string;
  FormatSet: TFormatSettings;
  ExplicitStop, Rot, DefaultFontIndex: integer;
  TextColor, OutColor, LTextColor, LbgColor, LhgColor: Longint;
  Speed, FSize, Fol, FB, dy, LyricV, Adelay, Sdelay, balance: real;
  CurMonitor: TMonitor;
  FontPaths: TTntStringList;
  poped: boolean;
  PlayMsgAt: Cardinal;

var StreamInfo: record
    FileName, FileFormat, PlaybackTime: WideString;
    Video: record
      Decoder, Codec: WideString;
      Bitrate, Width, Height: integer;
      FPS, Aspect: real;
    end;
    Audio: record
      Decoder, Codec: Widestring;
      Bitrate, Rate, Channels: integer;
    end;
    ClipInfo: array[0..9] of record
      Key, Value: WideString;
    end;
  end;

function CheckMenu(Menu: TMenuItem; ID: integer): integer;
function GetLongPath(const ShortName: WideString): WideString;
function GetLongPathNameA(lpszShortPath, lpszLongPath: PChar; cchBuffer: DWORD): DWORD;
stdcall; external kernel32 name 'GetLongPathNameA';
function GetLongPathNameW(lpszShortPath, lpszLongPath: PWideChar; cchBuffer: DWORD): DWORD;
stdcall; external kernel32 name 'GetLongPathNameW';
procedure AddChain(var Count: integer; var rs: WideString; const s: WideString);
function WideGetEnvironmentVariable(const Name: WideString): WideString;
function WideExpandUNCFileName(const FileName: WideString): WideString;
function WideGetUniversalName(const FileName: WideString): WideString;
function CheckOption(OPTN: WideString): boolean;
function SecondsToTime(Seconds: integer): string;
function EscapeParam(const Param: widestring): widestring;
function CheckSubfont(Sfont: WideString): WideString;
function CheckInfo(const Map: array of WideString; Value: WideString): integer;
procedure SetLastPos;
procedure Init;
procedure Start;
procedure Stop;
procedure CloseMedia;
procedure Restart;
procedure ForceStop;
function Running: boolean;
function IsLoaded(ArcType: WideString): boolean;
function AddMovies(ArcName, PW: widestring; Add,msg:boolean): integer;
procedure ExtractMovie(ArcName, PW: WideString);
procedure ExtractLyric(ArcName, PW: WideString);
function ExtractSub(ArcName, PW: WideString): WideString;
procedure TerminateMP;
procedure SendCommand(Command: string);
procedure SendVolumeChangeCommand(Vol: integer);
procedure ResetStreamInfo;
function ExpandName(const BasePath, FileName: WideString): WideString;
procedure HandleInputLine(Line: string);
function GetFileName(const fileName: WideString): WideString;
procedure loadLyricSub(path: WideString); overload;
procedure loadLyricSub(folder,filename: WideString); overload;
procedure loadArcLyric(path: WideString); overload;
procedure loadArcLyric(folder,ArcName: WideString); overload;
function loadArcSub(path: WideString):WideString; overload;
function loadArcSub(folder,ArcName: WideString):WideString; overload;

implementation
uses Main, config, plist, Info, UnRAR, Equalizer, Locale, Options, SevenZip,
     DLyric, OpenDevice, MediaInfoDll;

type TClientWaitThread = class(TThread)
  private procedure ClientDone;
  protected procedure Execute; override;
  public hProcess: Cardinal;
  end;
type TProcessor = class(TThread)
  private Data: string;
  private procedure Process;
  protected procedure Execute; override;
  public hPipe: Cardinal;
  end;

var ClientWaitThread: TClientWaitThread;
  Processor: TProcessor;
  ClientProcess, ReadPipe, WritePipe: Cardinal;
  FirstChance: boolean;
  ExitCode: DWORD;
  LastLine: string;
  LineRepeatCount: integer;

procedure HandleIDLine(ID: string; Content: WideString); forward;

function ExpandName(const BasePath, FileName: WideString): WideString;
begin                               
  Result := FileName;
  if (Pos(':', FileName) > 0) or (length(FileName)>515) then exit;
  if (length(FileName) > 1) and ((FileName[1] = '/') or (FileName[1] = '\')) then exit;
  Result := WideExpandUNCFileName(BasePath + FileName);
end;

function CheckMenu(Menu: TMenuItem; ID: integer): integer;
var a: integer;
begin
  for a := Menu.Count - 1 downto 0 do begin
    if Menu.Items[a].Tag = ID then begin
      Result := a; exit;
    end;
  end;
  Result := -1;
end;

function GetLongPath(const ShortName: WideString): WideString;
var SA: AnsiString;
begin
  if Win32PlatformIsUnicode then begin
    SetLength(Result, MAX_PATH + 1);
    SetLength(Result, GetLongPathNameW(PWideChar(ShortName), PWideChar(Result), MAX_PATH));
  end
  else begin
    SetLength(SA, MAX_PATH + 1);
    SetLength(SA, GetLongPathNameA(PChar(AnsiString(ShortName)), PChar(SA), MAX_PATH));
    Result := WideString(SA);
  end;
end;

function GetFileName(const fileName: WideString): WideString;
begin
  Result := WideChangeFileExt(fileName, '');
end;

procedure loadLyricSub(path: WideString);
var t,i: integer; m,n:WideString;
begin
  m:=GetFileName(path);
  if path<>MediaURL then begin
    if (LoadVob=0) and WideFileExists(m + '.idx') and WideFileExists(m + '.sub') then begin //idx
      LoadVob := 1; Vobfile := m; end;

    for i := 1 to SubTypeCount - 2 do begin  //srt,etc
      n := m + SubType[i];
      if WideFileExists(n) then begin
        if (not IsWideStringMappableToAnsi(n)) or (pos(',', n) > 0) then n := WideExtractShortPathName(n);
        if pos(n,substring)=0 then begin
          Loadsub := 2; Loadsrt := 2;
          AddChain(t, substring, EscapeParam(n));
        end;
      end;
    end;
  end;

  if HaveLyric = 0 then begin
    n := m + '.lrc';
    if not WideFileExists(n) then begin
      n:=WideIncludeTrailingPathDelimiter(ExpandName(HomeDir, LyricDir));
      n := n + WideExtractFileName(m) + '.lrc';
    end;
    if WideFileExists(n) then Lyric.ParseLyric(n);
  end;
end;

procedure loadLyricSub(folder, filename: WideString);
begin
  loadLyricSub(WideIncludeTrailingBackslash(folder) + filename);
end;

procedure loadArcLyric(path: WideString);
begin
  loadArcLyric(WideExtractFileDir(path),WideExtractFileName(path));
end;

procedure loadArcLyric(folder, ArcName: WideString);
var i: integer; s:WideString;
begin
  ArcName := WideIncludeTrailingBackslash(folder) + GetFileName(ArcName);
  for i := 0 to ZipTypeCount do begin
    if WideFileExists(ArcName + MediaType[i]) then begin
      if IsLoaded(MediaType[i]) then begin
        s:=ArcName + MediaType[i];
        if HaveLyric = 0 then ExtractLyric(s, playlist.FindPW(s))
        else exit;
      end;
    end;
  end;
end;

function loadArcSub(path: WideString):WideString;
begin
  Result:=loadArcSub(WideExtractFileDir(path),WideExtractFileName(path));
end;

function loadArcSub(folder, ArcName: WideString):WideString;
var i: integer; s:WideString;
begin
  Result := ''; ArcName := WideIncludeTrailingBackslash(folder) + GetFileName(ArcName);
  for i := 0 to ZipTypeCount do begin
    if WideFileExists(ArcName + MediaType[i]) then begin
      if IsLoaded(MediaType[i]) then begin
        s:=ArcName + MediaType[i];
        if Result = '' then Result := ExtractSub(s, playlist.FindPW(s))
        else exit;
      end;
    end;
  end;
end;

function IsLoaded(ArcType: WideString): boolean;
begin
  if ArcType = '.rar' then begin
    LoadRarLibrary;
    Result := IsRarLoaded <> 0;
    if not Result then begin
      Load7zLibrary;
      Result := Is7zLoaded > 2;
    end;
  end
  else if ArcType = '.zip' then begin
    LoadZipLibrary;
    Result := IsZipLoaded <> 0;
    if not Result then begin
      Load7zLibrary;
      Result := Is7zLoaded > 2;
    end;
  end
  else begin
    Load7zLibrary;
    if (ArcType = '.7z') or (ArcType = '.001') then begin
      Result := Is7zLoaded <> 0;
      if not Result then begin
        LoadZipLibrary;
        Result := IsZipLoaded <> 0;
      end;
    end
    else Result := Is7zLoaded > 2;
  end;
end;

function AddMovies(ArcName, PW: widestring; Add,msg:boolean): integer;
var ArcType:WideString;
begin
  Result := -1; ArcType:=Tnt_WideLowerCase(WideExtractFileExt(ArcName));
  if ArcType = '.rar' then begin
    if IsRarLoaded <> 0 then Result := AddRarMovies(ArcName, PW, Add, msg)
    else if Is7zLoaded > 2 then Result := Add7zMovies(ArcName, PW, Add, msg);
  end
  else if ArcType = '.zip' then begin
    if IsZipLoaded <> 0 then Result := AddZipMovies(ArcName, PW, Add, msg)
    else if Is7zLoaded > 2 then Result := Add7zMovies(ArcName, PW, Add, msg);
  end
  else if (ArcType = '.7z') or (ArcType = '.001') then begin
    if Is7zLoaded <> 0 then Result := Add7zMovies(ArcName, PW, Add, msg)
    else if IsZipLoaded <> 0 then Result := AddZipMovies(ArcName, PW, Add, msg);
  end
  else if Is7zLoaded > 2 then Result := Add7zMovies(ArcName, PW, Add, msg);
end;

procedure ExtractMovie(ArcName, PW: widestring);
var ArcType:WideString;
begin
  ArcType:=Tnt_WideLowerCase(WideExtractFileExt(ArcName));
  if ArcType = '.rar' then begin
    if IsRarLoaded <> 0 then ExtractRarMovie(ArcName, PW)
    else if Is7zLoaded > 2 then Extract7zMovie(ArcName, PW);
  end
  else if ArcType = '.zip' then begin
    if IsZipLoaded <> 0 then ExtractZipMovie(ArcName, PW)
    else if Is7zLoaded > 2 then Extract7zMovie(ArcName, PW);
  end
  else if (ArcType = '.7z') or (ArcType = '.001') then begin
    if Is7zLoaded <> 0 then Extract7zMovie(ArcName, PW)
    else if IsZipLoaded <> 0 then ExtractZipMovie(ArcName, PW);
  end
  else if Is7zLoaded > 2 then Extract7zMovie(ArcName, PW);
end;

procedure ExtractLyric(ArcName, PW: WideString);
var ArcType:WideString;
begin
  if ArcMovie='' then exit;
  ArcType:=Tnt_WideLowerCase(WideExtractFileExt(ArcName));
  if ArcType = '.rar' then begin
    if IsRarLoaded <> 0 then ExtractRarLyric(ArcName, PW)
    else if Is7zLoaded > 2 then Extract7zLyric(ArcName, PW);
  end
  else if ArcType = '.zip' then begin
    if IsZipLoaded <> 0 then ExtractZipLyric(ArcName, PW)
    else if Is7zLoaded > 2 then Extract7zLyric(ArcName, PW);
  end
  else if (ArcType = '.7z') or (ArcType = '.001') then begin
    if Is7zLoaded <> 0 then Extract7zLyric(ArcName, PW)
    else if IsZipLoaded <> 0 then ExtractZipLyric(ArcName, PW);
  end
  else if Is7zLoaded > 2 then Extract7zLyric(ArcName, PW);
end;

function ExtractSub(ArcName, PW: WideString): WideString;
var ArcType:WideString;
begin
  Result := ''; ArcType:=Tnt_WideLowerCase(WideExtractFileExt(ArcName));
  if ArcType = '.rar' then begin
    if IsRarLoaded <> 0 then Result := ExtractRarSub(ArcName, PW)
    else if Is7zLoaded > 2 then Result := Extract7zSub(ArcName, PW);
  end
  else if ArcType = '.zip' then begin
    if IsZipLoaded <> 0 then Result := ExtractZipSub(ArcName, PW)
    else if Is7zLoaded > 2 then Result := Extract7zSub(ArcName, PW);
  end
  else if (ArcType = '.7z') or (ArcType = '.001') then begin
    if Is7zLoaded <> 0 then Result := Extract7zSub(ArcName, PW)
    else if IsZipLoaded <> 0 then Result := ExtractZipSub(ArcName, PW);
  end
  else if Is7zLoaded > 2 then Result := Extract7zSub(ArcName, PW);
end;

function WideGetEnvironmentVariable(const Name: WideString): WideString;
var Len: integer;
begin
  Result := '';
  if Win32PlatformIsUnicode then begin
    Len := GetEnvironmentVariableW(PWChar(Name), nil, 0);
    if Len > 0 then begin
      SetLength(Result, Len - 1);
      GetEnvironmentVariableW(PWChar(Name), PWChar(Result), Len);
    end;
  end
  else Result := WideString(GetEnvironmentVariable(string(Name)));
end;

function WideExpandUNCFileName(const FileName: WideString): WideString;
begin
  Result := WideExpandFileName(FileName);
  if (Length(Result) >= 3) and (Result[2] = ':') and (Upcase(char(Result[1])) >= 'A')
    and (Upcase(char(Result[1])) <= 'Z') then
    Result := WideGetUniversalName(Result);
end;

function WideGetUniversalName(const FileName: WideString): WideString;
var Size: LongWord; RemoteNameInfo: array[0..1023] of Byte;
begin
  Result := FileName;
  if (Win32Platform <> VER_PLATFORM_WIN32_WINDOWS) or (Win32MajorVersion > 4) then begin
    Size := SizeOf(RemoteNameInfo);
    if WNetGetUniversalNameW(PWideChar(FileName), UNIVERSAL_NAME_INFO_LEVEL, @RemoteNameInfo, Size) <> NO_ERROR then Exit;
    Result := PRemoteNameInfoW(@RemoteNameInfo).lpUniversalName;
  end
end;

function SplitLine(var Line: WideString): WideString;
var i: integer;
begin
  i := Pos(#32, Line);
  if (length(Line) < 72) or (i < 1) then begin
    Result := Line;
    Line := '';
    exit;
  end;
  if (i > 71) then begin
    Result := Copy(Line, 1, i - 1);
    Delete(Line, 1, i);
    exit;
  end;
  i := 72; while Line[i] <> #32 do dec(i);
  Result := Copy(Line, 1, i - 1);
  Delete(Line, 1, i);
end;

procedure AddChain(var Count: integer; var rs: WideString; const s: WideString);
begin
  inc(Count);
  if rs = '' then rs := s
  else rs := rs + ',' + s;
end;

function CheckOption(OPTN: WideString): boolean;
begin
  OPTN := Tnt_WideLowerCase(OPTN); Result := False;
  if OPTN = '-fs' then begin
    WantFullscreen := True; Result := True; end;
  if OPTN = '-compact' then begin
    WantCompact := True; Result := True; end;
  if OPTN = '-autoquit' then begin
    AutoQuit := True; Result := True; end;
  if OPTN = '-enqueue' then Result := True;
end;

function EscapeParam(const Param: widestring): widestring;
begin
  if Pos(#32, Param) > 0 then Result := #34 + Param + #34 else Result := Param;
end;

function SecondsToTime(Seconds: integer): string;
var m, s: integer;
begin
  if Seconds < 0 then Seconds := 0;
  m := (Seconds div 60) mod 60;
  s := Seconds mod 60;
  Result := IntToStr(Seconds div 3600)
    + ':' + char(48 + m div 10) + char(48 + m mod 10)
    + ':' + char(48 + s div 10) + char(48 + s mod 10);
end;

function TimeToSeconds(TimeCode: string): integer;
begin
  Result := (StrToIntDef(copy(TimeCode, 1, 2), 0) * 60 + StrToIntDef(copy(TimeCode, 4, 2), 0)) * 60 + StrToIntDef(copy(TimeCode, 7, 2), 0);
end;

function CheckInfo(const Map: array of WideString; Value: WideString): integer;
var i: integer;
begin
  if Value <> '' then
    for i := Low(Map) to High(Map) do
      if Map[i] = Value then begin
        Result := i;
        exit;
      end;
  Result := -1;
end;

function CheckSubfont(Sfont: WideString): WideString;
var i: integer;
begin
  if WideFileExists(ExpandName(HomeDir, Sfont)) then begin
    Result := Sfont;
    if not IsWideStringMappableToAnsi(Sfont) then Result := WideExtractShortPathName(Sfont);
  end
  else begin
    Result := ''; Sfont := Trim(Tnt_WideLowerCase(Sfont));
    for i := 0 to FontPaths.Count - 1 do begin
      if (Sfont = Tnt_WideLowerCase(OptionsForm.CSubfont.Items[i])) or (Sfont = FontPaths[i]) then begin
        Result := ExpandName(SystemDir + 'fonts\', FontPaths[i]);
        exit;
      end;
    end;

    if Result = '' then begin
      if DefaultFontIndex > -1 then Result := ExpandName(SystemDir + 'fonts\', FontPaths[DefaultFontIndex])
      else if FileExists(SystemDir + 'fonts\arial.ttf') then
        Result := SystemDir + 'fonts\arial.ttf'
      else if WideFileExists(HomeDir + 'mplayer\subfont.ttf') then begin
        if IsWideStringMappableToAnsi(HomeDir + 'mplayer\subfont.ttf') then
          Result := HomeDir + 'mplayer\subfont.ttf'
        else
          Result := WideExtractShortPathName(HomeDir + 'mplayer\subfont.ttf');
      end;
    end;
  end;
end;

function ColorToStr(Color: Longint): WideString;
var i: integer; s: WideString;
begin
  Result := '';
  s := Tnt_WideFormat('%.8x', [Color]);
  for i := length(s) downto 1 do Result := Result + s[i];
end;

procedure SetLastPos;
begin
  if not HaveVideo then
    LastPos := SecondPos
  else begin
    if SecondPos < 15 then
      LastPos := SecondPos - 5
    else
      LastPos := SecondPos - 15;
  end;
end;

function GetFolderPath(csidl: integer): WideString;
var Buffer: PAnsiChar; BufferW: PWideChar;
begin
  if Win32PlatformIsUnicode then begin
    new(BufferW);
    if SHGetSpecialFolderPathW(0, BufferW, csidl, false) then
      Result := BufferW
    else Result := '';
    dispose(BufferW);
  end
  else begin
    new(Buffer);
    if SHGetSpecialFolderPath(0, Buffer, csidl, false) then
      Result := WideString(Buffer)
    else Result := '';
    dispose(Buffer);
  end;
end;

procedure Init;
const RFID_APPDATA: TGUID = '{3EB685DB-65F9-4CF6-A03A-E3EF65729F3D}';
      RFID_PERSONAL: TGUID = '{FDD39AD0-238F-46AF-ADB4-6C85480369C7}';
      // use by SHGetKnownFolderPath http://msdn.microsoft.com/en-us/library/bb762584(VS.85).aspx
begin
  SystemDir := Tnt_WideLowerCase(WideIncludeTrailingPathDelimiter(WideGetEnvironmentVariable('windir')));
  TempDir := WideIncludeTrailingPathDelimiter(WideGetEnvironmentVariable('TEMP')) + 'MPUI\';
  HomeDir := Tnt_WideLowerCase(WideIncludeTrailingPathDelimiter(WideExtractFileDir(WideExpandFileName(WideParamStr(0)))));

  if Win32PlatformIsVista then AppdataDir := GetShellPath(RFID_APPDATA)
  else AppdataDir := GetFolderPath(CSIDL_APPDATA);
  if AppdataDir = '' then AppdataDir := HomeDir else AppdataDir := WideIncludeTrailingPathDelimiter(AppdataDir);

  if Win32PlatformIsVista then ShotDir := GetShellPath(RFID_PERSONAL)
  else ShotDir := GetFolderPath(CSIDL_PERSONAL);
  if ShotDir = '' then ShotDir := TempDir + 'MPUISnap' else ShotDir := WideIncludeTrailingPathDelimiter(ShotDir) + 'MPUISnap';
  WadspL:= HomeDir + 'plugins\dsp_enh.dll';
  LyricDir := ShotDir;
  MplayerLocation := HomeDir + 'mplayer.exe';

  MWC := Windows.GetSystemMetrics(SM_CYCAPTION);
  GetLocaleFormatSettings(GetUserDefaultLCID, FormatSet);
  if Pos('ddd', FormatSet.ShortDateFormat) = 0 then FormatSet.ShortDateFormat := 'ddd ' + FormatSet.ShortDateFormat;
  if Pos('ddd', FormatSet.LongDateFormat) = 0 then FormatSet.LongDateFormat := 'dddd ' + FormatSet.LongDateFormat;
  SetErrorMode(SEM_FAILCRITICALERRORS);
  //SetThreadLocale(LOCALE_SYSTEM_DEFAULT);
  {//在user_def和sys_def不同时，为了使mpui能够正常播放sys_def的文件添加了这句，但菜单可能显示不正常。
  原因就是string和widestring在ansi环境下默认转化造成的。}
  Load(HomeDir + DefaultFileName, 1);
end;

procedure Start;
var DummyPipe1, DummyPipe2: THandle;
  si: TStartupInfoW;
  pi: TProcessInformation;
  sec: TSecurityAttributes;
  CmdLine, S, a,n, afChain: WideString;
  Success: boolean; Error: DWORD;
  ErrorMessage: array[0..1023] of Char;
  ErrorMessageW: array[0..1023] of WideChar;
  i, t, h: integer; UnRART: TUnRARThread; m:TMenuItem;
begin
  if Running or (length(MediaURL) = 0) then exit;
  Status := sOpening; IsPause := false; IsDx := false;
  if FirstOpen then begin
    MainForm.LTime.Caption := '';
    MainForm.LStatus.Caption := LOCstr_Status_Opening;
  end;

  FirstChance := true; afChain := ''; h := 0;
  ClientWaitThread := TClientWaitThread.Create(true);
  ClientWaitThread.FreeOnTerminate := true;
  Processor := TProcessor.Create(true);
  Processor.FreeOnTerminate := true;
  if ML then CmdLine := EscapeParam(ExpandName(HomeDir, MplayerLocation))
  else CmdLine := EscapeParam(HomeDir + 'mplayer.exe');
  if not GUI then CmdLine := CmdLine + ' -nogui -noconsolecontrols';
  CmdLine := CmdLine + ' -slave -identify -noquiet -nofs -noterm-osd -hr-mp3-seek'
    + ' -subalign 1 -spualign 1 -sub-fuzziness 0 -subfont-autoscale 2'
    + ' -subfont-osd-scale 4.8 -subfont-text-scale ' + FloatToStr(FSize)
    + ' -subfont-outline ' + FloatToStr(Fol) + ' -subfont-blur ' + FloatToStr(FB);

  if uav then CmdLine := CmdLine + ' -lavdopts threads=' + avThread;
  if AudioFile <> '' then CmdLine := CmdLine + ' -audiofile ' + EscapeParam(AudioFile);
  if Async then CmdLine := CmdLine + ' -autosync ' + AsyncV;

  if Pri then begin
    CmdLine := CmdLine + ' -priority abovenormal';
    SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);
  end
  else SetPriorityClass(GetCurrentProcess, ABOVE_NORMAL_PRIORITY_CLASS);

  CurMonitor := Screen.MonitorFromWindow(MainForm.Handle);
  MonitorID := CurMonitor.MonitorNum; MonitorW := CurMonitor.Width; MonitorH := CurMonitor.Height;

  if not CurMonitor.Primary then CmdLine := CmdLine + ' -adapter ' + IntToStr(MonitorID);

  if nmsg then CmdLine := CmdLine + ' -nomsgmodule';
  if UseUni then CmdLine := CmdLine + ' -msgcharset noconv';
  if Fd then CmdLine := CmdLine + ' -framedrop';
  if ni then CmdLine := CmdLine + ' -ni';
  if nobps then CmdLine := CmdLine + ' -nobps';
  if ReIndex then CmdLine := CmdLine + ' -idx';
  if SoftVol then begin
    if mute then CmdLine := CmdLine + ' -softvol -softvol-max 1000 -volume 0'
    else CmdLine := CmdLine + ' -softvol -softvol-max 1000 -volume ' + IntToStr(Volume div 10);
  end
  else begin
    if mute then CmdLine := CmdLine + ' -volume 0'
    else CmdLine := CmdLine + ' -volume ' + IntToStr(Volume);
  end;
  MainForm.UpdateVolSlider;
  if Uni then CmdLine := CmdLine + ' -unicode';
  if Utf then CmdLine := CmdLine + ' -utf8';
  if lavf then CmdLine := CmdLine + ' -demuxer lavf';
  if vsync then CmdLine := CmdLine + ' -vsync';
  if Wid and Win32PlatformIsUnicode then
    CmdLine := CmdLine + ' -colorkey 0x101010 -nokeepaspect' + ' -wid ' + IntToStr(MainForm.IPanel.Handle)
  else if ontop > 0 then CmdLine := CmdLine + ' -ontop';
  if OSDLevel <> 1 then CmdLine := CmdLine + ' -osdlevel ' + IntToStr(OSDLevel);
  if Dr then CmdLine := CmdLine + ' -dr';
  if dbbuf then CmdLine := CmdLine + ' -double';
  if nfc then CmdLine := CmdLine + ' -nofontconfig';
  if Ass then begin
    CmdLine := CmdLine + ' -ass'; SubPos := Dsubpos;
    if Efont then CmdLine := CmdLine + ' -embeddedfonts';
    CmdLine := CmdLine + ' -ass-color ' + ColorToStr(TextColor)
      + ' -ass-border-color ' + ColorToStr(OutColor)
      + ' -ass-font-scale ' + FloatToStr(FSize / Fscale);
    if ISub then CmdLine := CmdLine + ' -vf-pre ass';
  end;
  s := CheckSubfont(subfont);
  if uof then begin
    if s <> '' then CmdLine := CmdLine + ' -subfont ' + EscapeParam(s);
    s := CheckSubfont(osdfont);
  end;
  if s <> '' then CmdLine := CmdLine + ' -font ' + EscapeParam(s);
  case Expand of
    0: if ISub and (not Ass) then CmdLine := CmdLine + ' -vf-pre expand=osd=1 -noslices';
    1: if ISub and (not Ass) then CmdLine := CmdLine + ' -vf-pre expand=:-80::40:1 -noslices'
      else CmdLine := CmdLine + ' -vf-pre expand=:-80::40';
    2: if ISub and (not Ass) then CmdLine := CmdLine + ' -vf-pre expand=::::1:4/3 -noslices'
      else CmdLine := CmdLine + ' -vf-pre expand=aspect=4/3';
  end;

  if Flip then CmdLine := CmdLine + ' -vf-add flip';
  if Mirror then CmdLine := CmdLine + ' -vf-add mirror';

  case Rot of
    1: CmdLine := CmdLine + ' -vf-add rotate=1';
    2: CmdLine := CmdLine + ' -vf-add rotate=2';
  end;

  s := Trim(LowerCase(VideoOut));
  if s <> '' then begin
    if s = 'novideo' then CmdLine := CmdLine + ' -novideo'
    else if s = 'null' then CmdLine := CmdLine + ' -vo null'
    else if s <> 'auto' then CmdLine := CmdLine + ' -vo ' + s + ',';
  end;

  if not Dda then begin
    if Yuy2 then CmdLine := CmdLine + ' -vf-add yuy2';
    if Eq2 then CmdLine := CmdLine + ' -vf-add eq2';
    case Deinterlace of
      1: CmdLine := CmdLine + ' -vf-add pp=fd';
      2: CmdLine := CmdLine + ' -vf-add kerndeint';
    end;
  end;

  if Speed <> 1 then CmdLine := CmdLine + ' -speed ' + FloatToStr(Speed);
  if Adelay <> 0 then CmdLine := CmdLine + ' -delay ' + FloatToStr(Adelay);
  if Sdelay <> 0 then CmdLine := CmdLine + ' -subdelay ' + FloatToStr(Sdelay);
  if SPDIF then CmdLine := CmdLine + ' -afm hwac3';

  case Postproc of
    1: CmdLine := CmdLine + ' -autoq 10 -vf-add pp';
    2: CmdLine := CmdLine + ' -vf-add pp=ac';
  end;

  case AudioOut of
    0: CmdLine := CmdLine + ' -nosound';
    1: CmdLine := CmdLine + ' -ao null';
    3: CmdLine := CmdLine + ' -ao win32,';
    4: if OptionsForm.CAudioDev.ItemIndex > -1 then CmdLine := CmdLine + ' -ao dsound:device=' + IntToStr(AudioDev) + ',';
  end;

  case Ch of
    1: CmdLine := CmdLine + ' -channels 4';
    2: CmdLine := CmdLine + ' -channels 6';
    3: CmdLine := CmdLine + ' -channels 8';
  end;

  if Firstrun then begin
    ClearTmpFiles(TempDir); Lyric.ClearLyric; procArc := true;
    a:=WideIncludeTrailingPathDelimiter(ExpandName(HomeDir, LyricDir));
    s := Tnt_WideLowerCase(WideExtractFileExt(MediaURL));
    n:= WideExtractFileName(MediaURL);
    ArcMovie := DisplayURL;
    i:= CheckInfo(MediaType, s);
    if (i > -1) and (i <= ZipTypeCount) then begin
      i := Pos(':', DisplayURL);
      if i > 0 then ArcPW := copy(DisplayURL, i + 1, length(DisplayURL) - i)
      else ArcPW := '';
      i := Pos(' <-- ', DisplayURL);
      if i > 0 then ArcMovie := copy(DisplayURL, 1, i - 1);
    end
    else i := -1;

    TmpURL := Tnt_WideLowerCase(GetFileName(ArcMovie));
    if WideFileExists(LyricURL) then begin //拖放的歌词或用户指定的歌词
      s := WideExtractFileName(LyricURL);
      s := Tnt_WideLowerCase(GetFileName(s));
      if TmpURL = s then Lyric.ParseLyric(LyricURL);
    end;

    loadLyricSub(MediaURL);
    loadLyricSub(a + n);
    
    if HaveLyric = 0 then loadArcLyric(MediaURL);
    if LoadVob = 0 then begin
      TmpURL := loadArcSub(MediaURL);
      if TmpURL <> '' then begin
        Vobfile := TmpURL; LoadVob := 1; end;
    end;

    if HaveLyric = 0 then loadArcLyric(a,n);
    if LoadVob = 0 then begin
      TmpURL := loadArcSub(a,n);
      if TmpURL <> '' then begin
        Vobfile := TmpURL; LoadVob := 1; end;
    end;

    if i>0 then begin
      n:= WideExtractFileDir(MediaURL);
      loadLyricSub(n,ArcMovie);
      loadLyricSub(a,ArcMovie);

      if HaveLyric = 0 then loadArcLyric(n,ArcMovie);
      if LoadVob = 0 then begin
        TmpURL := loadArcSub(n,ArcMovie);
        if TmpURL <> '' then begin
          Vobfile := TmpURL; LoadVob := 1; end;
      end;

      if HaveLyric = 0 then loadArcLyric(a,ArcMovie);
      if LoadVob = 0 then begin
        TmpURL := loadArcSub(a,ArcMovie);
        if TmpURL <> '' then begin
          Vobfile := TmpURL; LoadVob := 1; end;
      end;
    end;

    MainForm.UpdateMRF;

    if (i > 0) and IsLoaded(s) then begin
      tEnd := false;
      TmpURL := MediaURL; //避免系统调度UNRART线程的不确定性造成线程执行时获取的是已经变化的MediaURL
      MediaURL := TempDir + ArcMovie;
      UnRART := TUnRARThread.Create(true);
      UnRART.FreeOnTerminate := true;
      UnRART.Priority := tpTimeCritical;
      UNRART.Resume;
      SwitchToThread;

      while not tEnd do begin
        Application.ProcessMessages;
        if WideFileExists(MediaURL) then begin
          WaitForSingleObject(UnRART.Handle,1000);
          break;
        end;
      end;
      if not WideFileExists(MediaURL) then begin
        MainForm.LStatus.Caption := ''; Status := sNone;
        exit;
      end;
    end;
  end;

   {  ______________________________________________________________________
     |   vob (-vob vobfile)         | ID_VOBSUB_ID   |   |                  |
     |______________________________|________________| VobAndInterSubCount  |
     |  inter (DVD/MKV/OGM)         | ID_SUBTITLE_ID |   |                  |
     |______________________________|________________|___|__                |
     | lastsub (-sub substring)     |                |      |               |
     |                              |                | Lastsubcount    CurrentSub
     |    (re)start                 |                |      |__             |
     |______________________________|                |______|  |            |
     | autoloaded Sub               |                |         |            |
     | (samedirSub)                 | ID_FILE_SUB_ID |      SubCount        |
     |  (re)start                   |                |         |            |
     |______________________________|                |_________|____________|
     | running (sub_load) loadsub=1 |                |      |__|
     |______________________________|________________|______|
  }

  if Loadsrt > 0 then begin //必须放到LoadVOB的判断前面，因为要考虑到VOB字幕加载失败时需要对SubID进行调整
    if Loadsrt = 1 then begin
      if (SubID >= (VobAndInterSubCount + Lastsubcount)) and (SubID < CurrentSubCount) then
        SubID := SubID + (subcount - Lastsubcount) //Adjust location of subtitles autoloaded调整自动加载的外部字幕的位置
      else
        if SubID >= CurrentSubCount then //Adjust location of subtitles recently loaded调整新近加载的外部字幕的位置
          SubID := SubID - (CurrentSubCount - Lastsubcount - VobAndInterSubCount);
      Lastsubcount := subcount;
      Loadsrt := 2;
    end;
    if substring <> '' then CmdLine := CmdLine + ' -sub ' + substring;
  end;

  if (LoadVob > 0) and (LoadVob < 3) then begin //必须放到Loadsrt的判断后面，因为要考虑到VOB字幕加载失败时需要对SubID进行调整
    if LoadVob = 1 then begin
      LoadVob := 3; SubID := SubID - VobsubCount; //考虑到VOB字幕加载失败时需要对SubID进行调整
    end;
    if Vobfile <> '' then begin
      s := Vobfile;
      if not IsWideStringMappableToAnsi(s) then begin
        s := WideExtractShortPathName(Vobfile + '.idx'); s := GetFileName(s);
      end;
      CmdLine := CmdLine + ' -vobsub ' + EscapeParam(s);
    end;
  end;

  if (VideoID >= 0) then CmdLine := CmdLine + ' -vid ' + IntToStr(VideoID);
  if (AudioID >= 0) and (AudioOut > 0) then CmdLine := CmdLine + ' -aid ' + IntToStr(AudioID);
  if subcode <> '' then begin
    if Pos(' (', subcode) > 0 then
      CmdLine := CmdLine + ' -subcp ' + copy(subcode, 1, Pos(' (', subcode) - 1)
    else CmdLine := CmdLine + ' -subcp ' + subcode;
  end;
  if MAspect <> '' then begin
    if Trim(LowerCase(MAspect)) = 'default' then
      CmdLine := CmdLine + ' -monitoraspect ' + IntTostr(CurMonitor.Width) + ':' + IntTostr(CurMonitor.Height)
    else CmdLine := CmdLine + ' -monitoraspect ' + MAspect; OptionsForm.CAspect.Items.Count
  end;
  if Aspect = MainForm.MAspects.Count - 1 then begin
    if InterW > 3 * InterH then InterW := 3 * InterH;
    CmdLine := CmdLine + ' -aspect ' + IntToStr(InterW) + ':' + IntToStr(InterH);
  end
  else if Aspect > 0 then CmdLine := CmdLine + ' -aspect ' + OptionsForm.CAspect.Items[Aspect];


  if Wadsp then begin
    s := ExpandName(HomeDir, WadspL);
    h := pos(':', s); a := '';
    if h > 0 then begin
      t := pos(':', copy(s, h + 1, MaxInt));
      if t > 0 then begin
        a := copy(s, h + t, MaxInt); s := copy(s, 1, h + t - 1);
      end;
    end;
    if WideFileExists(s) then begin
      if (not IsWideStringMappableToAnsi(s)) or (pos(',', s) > 0) then s := WideExtractShortPathName(s);
      if sconfig or (a <> '') then AddChain(h, afChain, 'wadsp=' + EscapeParam(s) + ':cfg=1')
      else AddChain(h, afChain, 'wadsp=' + EscapeParam(s));
    end;
  end;
  if Volnorm then AddChain(h, afChain, 'volnorm=2');

  if afChain <> '' then CmdLine := CmdLine + ' -af ' + afChain;
  if length(Params) > 0 then CmdLine := CmdLine + #32 + Params;
  CmdLine := CmdLine + ' -subpos ' + IntToStr(SubPos) + ' -vf-add screenshot';
  if FirstOpen and Mainform.MSIE.Checked and (Bp > 0) then begin
    if Bp > 15 then
      i := Bp - 15
    else
      i := Bp - 5;
    if i > LastPos then LastPos := i;
  end;
  bluray:= Copy(MediaURL, 1, 15) = ' -bluray-device';
  dvd:= Copy(MediaURL, 1, 12) = ' -dvd-device';
  cd:=pos('cdda://',MediaURL)>0;
  vcd:=pos('vcd://',MediaURL)>0;
  if dvd or bluray then begin
    if TotalTime > 0 then begin
      i := 0;
      if HaveChapters and (CID > 1) then begin
      	if bluray then m:=MainForm.MBRT
      	else m:=MainForm.MDVDT; 
        t := CheckMenu(m, TID);
        {if Dnav then i:=CheckMenu(m.Items[t].Items[0],CID-1)
        else } i := CheckMenu(m.Items[t].Items[0], CID);
        s := m.Items[t].Items[0].Items[i].Caption;
        i := pos('(', s);
        if i>0 then begin
          s := Copy(s, i + 1, 8);
          i := TimeToSeconds(s);
        end;
      end;
      if Dreset then LastPos := i
      else if not UDVDTtime then LastPos := LastPos + i;
    end;
    if LastPos > 0 then begin
      SecondPos := LastPos; CmdLine := CmdLine + ' -ss ' + SecondsToTime(LastPos); end;

    if Dnav and dvd then begin
      CmdLine := CmdLine + ' -nocache';
      CmdLine := CmdLine + MediaURL + 'nav://';
    end
    else begin
      if Cache then CmdLine := CmdLine + ' -cache ' + CacheV;
      CmdLine := CmdLine + MediaURL + '://';
    end;

    if Firstrun then begin
      if bluray then i := StrToIntDef(copy(DisplayURL, 9, Pos(' <-- ', DisplayURL) - 9), TID)
      else i := StrToIntDef(copy(DisplayURL, 5, Pos(' <-- ', DisplayURL) - 5), TID);
      if Dnav and SMenu and (i = 1) and dvd then TID := 0
      else TID := i;
    end;
    if (not Dnav) and (TID = 0) then TID := 1; //tmpTID:=TID;
    if TID > 0 then CmdLine := CmdLine + IntToStr(TID);
    if CID > 1 then begin
      if bluray then CmdLine := CmdLine + ' -bluray-chapter ' + IntToStr(CID-1)
      else CmdLine := CmdLine + ' -chapter ' + IntToStr(CID);
    end;
    if AID > 1 then begin
      if bluray then CmdLine := CmdLine + ' -bluray-angle ' + IntToStr(AID-1)
      else CmdLine := CmdLine + ' -dvdangle ' + IntToStr(AID);
    end;
  end
  else begin
    if LastPos > 0 then CmdLine := CmdLine + ' -ss ' + SecondsToTime(LastPos);
    if Cache then CmdLine := CmdLine + ' -cache ' + CacheV;
    if cd or vcd then begin
      CmdLine := CmdLine + MediaURL;
      if CDID > 1 then CmdLine := CmdLine + IntToStr(CDID);
    end
    else if Pos('tv://', MediaURL) > 0 then CmdLine := CmdLine + #32 + MediaURL
    else if (Pos('://', MediaURL) > 1) or IsWideStringMappableToAnsi(MediaURL) then
      CmdLine := CmdLine + #32 + EscapeParam(MediaURL)
    else CmdLine := CmdLine + #32 + EscapeParam(WideExtractShortPathName(MediaURL));
  end;

  with OptionsForm do begin
    TheLog.Clear;
    AddLine(LOCstr_CmdLine_Prompt);
    s := CmdLine;
    while length(s) > 0 do AddLine(SplitLine(s));
    AddLine('');
  end;

  if Loadsub <> 2 then Loadsub := -1;
  ExplicitStop := 0; Dreset := false;
  Firstrun := false;
  ResetStreamInfo;
  ChkVideo := true; ChkAudio := true;
  ChkStartPlay := true; HaveChapters := false;
  StreamInfo.FileName := DisplayURL;
  LastLine := ''; LineRepeatCount := 0;
  VobsubCount := 0; IntersubCount := 0;
  with MainForm do begin
    for i := MDVDT.Count - 1 downto 3 do MDVDT.delete(i);
    MBRT.Clear;
    MDVDT.Visible := dvd;
    MBRT.Visible := bluray;
    MVideo.Clear; MVideo.Visible := false;
    MAudio.Clear; MAudio.Visible := false;
    MSubtitle.Clear; MSubtitle.Visible := false;
    MVCDT.Clear; MVCDT.Visible := false;
    MCDT.Clear; MCDT.Visible:= false;
  end;

  with sec do begin
    nLength := sizeof(sec);
    lpSecurityDescriptor := nil;
    bInheritHandle := true;
  end;
  CreatePipe(ReadPipe, DummyPipe1, @sec, 0);

  with sec do begin
    nLength := sizeof(sec);
    lpSecurityDescriptor := nil;
    bInheritHandle := true;
  end;
  CreatePipe(DummyPipe2, WritePipe, @sec, 0);

  FillChar(si, sizeof(si), 0);
  si.cb := sizeof(si);
  si.dwFlags := STARTF_USESTDHANDLES;
  si.hStdInput := DummyPipe2;
  si.hStdOutput := DummyPipe1;
  si.hStdError := DummyPipe1;

  s := ExpandName(HomeDir, ShotDir);
  if not WideDirectoryExists(s) then
    if not WideCreateDir(s) then s := TempDir;

  Success := Tnt_CreateProcessW(nil, PwideChar(CmdLine), nil, nil, true, DETACHED_PROCESS, nil, PwideChar(s), si, pi);
  Error := GetLastError;

  CloseHandle(DummyPipe1);
  CloseHandle(DummyPipe2);

  if not Success then begin
    OptionsForm.AddLine(LOCstr_Error1_Prompt + IntToStr(Error) + LOCstr_Error2_Prompt);
    if Win32PlatformIsUnicode then begin
      FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, nil, Error, 0, @ErrorMessageW[0], 1023, nil);
      OptionsForm.AddLine(ErrorMessageW);
    end
    else begin
      FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, Error, 0, @ErrorMessage[0], 1023, nil);
      OptionsForm.AddLine(ErrorMessage);
    end;
    if Error = 2 then OptionsForm.AddLine(LOCstr_Check_Mplayer_Prompt);
    ClientWaitThread.ClientDone; // this is a synchronized function, so I may
                                  // call it here from this thread as well
    exit;
  end;

  ClientProcess := pi.hProcess;
  ClientWaitThread.hProcess := ClientProcess;
  Processor.hPipe := ReadPipe;

  ClientWaitThread.Resume;
  Processor.Resume;
end;

procedure TClientWaitThread.ClientDone;
begin
  ClientProcess := 0;
  CloseHandle(ReadPipe); ReadPipe := 0;
  CloseHandle(WritePipe); WritePipe := 0;
  ClientWaitThread.Terminate;
  if Assigned(Processor) then Processor.Terminate;
  FirstOpen := false;
  if ExplicitStop > 0 then ExitCode := 0;
  //if (winos='WIN9X') and (Status=sClosing) then ExitCode:=0;
  if (Status = sOpening) or (ExitCode <> 0) then begin
    Status := sError; SetLastPos;
  end;

  if (ExplicitStop > 0) or (Status = sError) then begin
    if ExplicitStop = 2 then exit;
    if Status <> sError then Status := sStopped;
    MainForm.SetupStop;
    if ExplicitStop = 3 then begin
      MainForm.BPlay.Enabled := false; Status := sNone;
      MediaURL := ''; DisplayURL := '';
      MainForm.LStatus.Caption := '';
    end;
    MainForm.UpdateCaption;
    MainForm.UpdateStatus;
  end
  else begin
    MainForm.UpdateParams; MainForm.NextFile(1, psPlayed);
    if not Running then begin
      if MainForm.BNext.Enabled then DisplayURL := Playlist[0].DisplayURL;
      MainForm.UpdateCaption; MainForm.SetupStop;
      Status := sStopped; MainForm.UpdateStatus;
    end;
  end;
end;

procedure TClientWaitThread.Execute;
begin
  WaitForSingleObject(hProcess, INFINITE);
  GetExitCodeProcess(hProcess, ExitCode);
  Synchronize(ClientDone);
end;

procedure TProcessor.Process;
var LastEOL, EOL, Len: integer; S: PString;
begin
  Len := length(Data);
  LastEOL := 0;
  for EOL := 1 to Len do
    if (EOL > LastEOL) and (Data[EOL] in [#13, #10]) then begin
      new(S); S^ := Copy(Data, LastEOL + 1, EOL - (LastEOL + 1));
      if not PostMessage(MainForm.Handle, $0402, integer(true), integer(S)) then dispose(S);
      LastEOL := EOL;
      if (LastEOL < Len) and (Data[LastEOL + 1] = #10) then inc(LastEOL);
    end;
  if LastEOL <> 0 then Delete(Data, 1, LastEOL);
end;

procedure TProcessor.Execute;
const BufSize = 1024;
var Buffer: array[0..BufSize] of char;
  BytesRead: cardinal;
begin
  Data := ''; LastLine := ''; LineRepeatCount := 0;
  repeat
    BytesRead := 0;
    if Processor.Terminated or (not ReadFile(hPipe, Buffer[0], BufSize, BytesRead, nil)) then break;
    Buffer[BytesRead] := #0;
    Data := Data + Buffer;
    Process;
  until BytesRead = 0;
end;

function Running: boolean;
begin
  Result := ClientProcess <> 0;
end;

procedure Stop;
begin
  if not Running then exit;
  Status := sClosing;
  MainForm.LStatus.Caption := LOCstr_Status_Closing;
  ExplicitStop := 1;
  if not Win32PlatformIsUnicode then FirstChance := false;
  if FirstChance then begin
    SendCommand('quit');
    FirstChance := false;
    if WaitForSingleObject(ClientProcess, stopTimeout) <> WAIT_TIMEOUT then exit;
  end;
  TerminateMP;
end;

procedure TerminateMP;
begin
  if not Running then exit;
  TerminateProcess(ClientProcess, cardinal(-1));
end;

procedure ForceStop;
begin
  if not Running then exit;
  ExplicitStop := 2;
  if FirstChance then begin
    SendCommand('quit');
    FirstChance := false;
    if WaitForSingleObject(ClientProcess, stopTimeout) <> WAIT_TIMEOUT then exit;
  end;
  TerminateMP;
end;

procedure CloseMedia;
var i:integer;
begin
  for i := MainForm.MDVDT.Count - 1 downto 3 do MainForm.MDVDT.delete(i);
  MainForm.MBRT.Clear; MainForm.MBRT.Visible := false;
  MainForm.MDVDT.Visible := false; MainForm.MAudios.Visible:=false;
  MainForm.MVideo.Clear; MainForm.MVideo.Visible := false;
  MainForm.MAudio.Clear; MainForm.MAudio.Visible := false;
  MainForm.MSubtitle.Clear; MainForm.MSubtitle.Visible := false;
  MainForm.MVCDT.Clear; MainForm.MVCDT.Visible := false;
  MainForm.MCDT.Clear; MainForm.MCDT.Visible:= false;
  MainForm.UpdateMenuEV(false);
  if not Running then begin
    MainForm.BPlay.Enabled := false; Status := sNone;
    MediaURL := ''; DisplayURL := '';
    MainForm.LStatus.Caption := '';
    MainForm.UpdateCaption;
    MainForm.UpdateStatus;
    exit;
  end;
  ExplicitStop := 3; Status := sClosing;
  MainForm.LStatus.Caption := LOCstr_Status_Closing;
  if FirstChance then begin
    SendCommand('quit');
    FirstChance := false;
    if WaitForSingleObject(ClientProcess, stopTimeout) <> WAIT_TIMEOUT then exit;
  end;
  TerminateMP;
end;

procedure SendCommand(Command: string);
var Dummy: cardinal; np:boolean;
procedure SC(c:string);
begin
  c:=  c + #10;
  if (Status = sPaused) and np then c:='pausing_keep ' + c;
  WriteFile(WritePipe, c[1], length(c), Dummy, nil);
end;
begin
  if (not Running) or (WritePipe = 0) or (not Win32PlatformIsUnicode) then exit;
  np:= CheckInfo(PauseCMD, Command) < 0;

  if np then SC('set_property osdlevel 0');
  SC(Command);
  if np then SC('set_property osdlevel ' + IntToStr(OSDLevel));
end;

procedure SendVolumeChangeCommand(Vol: integer);
begin
  if SoftVol then Vol := Vol div 10;
  SendCommand('volume ' + IntToStr(Vol) + ' 1');
  if HaveVideo then SendCommand('osd_show_property_text "' + OSD_Volume_Prompt + ':${volume}"');
end;

procedure Restart;
begin
  if not Running then exit;
  SetLastPos;
  ForceStop;
  Sleep(50); // wait for the processing threads to finish
  Application.ProcessMessages;
  CBHSA := 4;
  Start;
  MainForm.UpdateSeekBar;
end;

////////////////////////////////////////////////////////////////////////////////



procedure HandleInputLine(Line: string);
var r, i, j, p, len: integer; s: string; f: real; b:boolean;
    t: TTntMenuItem; key: word; a:TDownLoadLyric; m:TMenuItem;
    h:Cardinal;
  function SubMenu_Add(Menu: TMenuItem; ID, SelectedID: integer; Handler: TNotifyEvent): integer;
  begin
    t := TTntMenuItem.Create(Menu);
    t.Caption := IntToStr(ID); t.Tag := ID; t.GroupIndex := $0A;
    t.RadioItem := true; t.OnClick := Handler;
    Menu.Add(t);
    Menu.Visible := true;
    Result := Menu.Count - 1;
    if ID = SelectedID then Menu.Items[Result].Checked := true
    else begin
      if SelectedID < 0 then begin
        if (Menu = MainForm.MDVDT) and (Menu.Count = 4) then Menu.Items[Result].Checked := true
        else if Menu.Count = 1 then Menu.Items[Result].Checked := true;
      end;
    end;
  end;

  procedure SubMenu_SetNameLang(Menu: TTntMenuItem; ID: integer; NameLang: string);
  var a: integer;
  begin
    for a := Menu.Count - 1 downto 0 do begin
      with Menu.Items[a] do begin
        if Tag = ID then begin
          Caption := Caption + ' (' + NameLang + ')';
          exit;
        end;
      end;
    end;
  end;

  function CheckVobsubID: boolean;
  begin
    Result := false;
    if (len > 13) and (Copy(Line, 1, 13) = 'ID_VOBSUB_ID=') then begin
      Val(Copy(Line, 14, MaxInt), i, r);
      if (r = 0) and (i >= 0) and (i < 256) then begin
        if LoadVob = 3 then begin
          LoadVob := 2; SubID := 0;
          SendCommand('set_property sub 0');
          MainForm.MShowSub.Checked := true;
        end;
        if CheckMenu(MainForm.MSubtitle, i) < 0 then begin
          SubMenu_Add(MainForm.MSubtitle, i, SubID, MainForm.MSubtitleClick);
          inc(VobsubCount); CurrentSubCount := IntersubCount + VobsubCount;
        end;
      end;
      Result := true;
    end;
  end;

  function CheckVobsubLang: boolean;
  begin
    Result := false;
    if (len > 8) and (Copy(Line, 1, 8) = 'ID_VSID_') then begin
      s := Copy(Line, 9, MaxInt);
      p := Pos('_LANG=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i >= 0) and (i < 256) then begin
        if CheckMenu(MainForm.MSubtitle, i) < 0 then begin
          SubMenu_Add(MainForm.MSubtitle, i, SubID, MainForm.MSubtitleClick);
          inc(VobsubCount); CurrentSubCount := IntersubCount + VobsubCount;
        end;
        SubMenu_SetNameLang(MainForm.MSubtitle, i, copy(s, p + 6, MaxInt));
      end;
      Result := true;
    end;
  end;

  function CheckBRT: boolean;
  var a: integer; Entry: TPlaylistEntry;
  begin
    Result := false;
    if (len > 17) and (Copy(Line, 1, 17) = 'ID_BLURAY_TITLES=') then begin
      Val(Copy(Line, 18, MaxInt), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        for a := 1 to i do begin
          if FirstOpen then begin
            s := 'BlueRay-' + IntToStr(a) + Copy(DisplayURL, Pos(' <-- ', DisplayURL), MaxInt);
            if playlist.FindItem('', s) < 0 then begin
              with Entry do begin
                State := psNotPlayed;
                FullURL := MediaURL;
                DisplayURL := s;
              end;
              playlist.Add(Entry);
              if a = i then Playlist.Changed;
            end;
          end;
          if CheckMenu(MainForm.MBRT, a) < 0 then begin
            r := SubMenu_Add(MainForm.MBRT, a, TID, nil);

            t := TTntMenuItem.Create(MainForm.MBRT.Items[r]);
            t.Caption := Ccap; t.Tag := 0; t.GroupIndex := $0A;
            MainForm.MBRT.Items[r].Add(t);

            t := TTntMenuItem.Create(MainForm.MBRT.Items[r]);
            t.Caption := Acap; t.Tag := 1; t.GroupIndex := $0A;
            MainForm.MBRT.Items[r].Add(t);
          end;
        end;
      end;
      Result := true;
    end;
  end;

  function CheckDVDT: boolean;
  var a: integer; Entry: TPlaylistEntry;
  begin
    Result := false;
    if (len > 14) and (Copy(Line, 1, 14) = 'ID_DVD_TITLES=') then begin
      Val(Copy(Line, 15, MaxInt), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        for a := 1 to i do begin
          if FirstOpen then begin
            s := 'DVD-' + IntToStr(a) + Copy(DisplayURL, Pos(' <-- ', DisplayURL), MaxInt);
            if playlist.FindItem('', s) < 0 then begin
              with Entry do begin
                State := psNotPlayed;
                FullURL := MediaURL;
                DisplayURL := s;
              end;
              playlist.Add(Entry);
              if a = i then Playlist.Changed;
            end;
          end;
          if CheckMenu(MainForm.MDVDT, a) < 0 then begin
            r := SubMenu_Add(MainForm.MDVDT, a, TID, nil);

            t := TTntMenuItem.Create(MainForm.MDVDT.Items[r]);
            t.Caption := Ccap; t.Tag := 0; t.GroupIndex := $0A;
            MainForm.MDVDT.Items[r].Add(t);

            t := TTntMenuItem.Create(MainForm.MDVDT.Items[r]);
            t.Caption := Acap; t.Tag := 1; t.GroupIndex := $0A;
            MainForm.MDVDT.Items[r].Add(t);
          end;
        end;
      end;
      Result := true;
    end;
  end;

  function CheckBRC: boolean;
  var k: integer;
  begin
    Result := false;
    if (len > 16) and (Copy(Line, 1, 16) = 'ID_BLURAY_TITLE_') then begin
      s := Copy(Line, 17, MaxInt);
      p := Pos('_CHAPTERS=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        Val(Copy(s, p + 10, MaxInt), j, r);
        if (r = 0) and (j > 0) and (j < 8191) then begin
          for k := 1 to j do begin
            r := CheckMenu(MainForm.MBRT, i);
            if r < 0 then r := SubMenu_Add(MainForm.MBRT, i, TID, nil);
            if CheckMenu(MainForm.MBRT.Items[r], 0) < 0 then begin
              t := TTntMenuItem.Create(MainForm.MBRT.Items[r]);
              t.Caption := Ccap; t.Tag := 0; t.GroupIndex := $0A;
              MainForm.MBRT.Items[r].Add(t);
            end;
            if CheckMenu(MainForm.MBRT.Items[r].Items[0], k) < 0 then begin
              if i = TID then
                SubMenu_Add(MainForm.MBRT.Items[r].Items[0], k, CID, MainForm.MDVDCClick)
              else
                SubMenu_Add(MainForm.MBRT.Items[r].Items[0], k, 0, MainForm.MDVDCClick);
            end;
          end;
        end;
        Result := true;
      end;
    end;
  end;

  function CheckDVDC: boolean;
  var k: integer;
  begin
    Result := false;
    if (len > 13) and (Copy(Line, 1, 13) = 'ID_DVD_TITLE_') then begin
      s := Copy(Line, 14, MaxInt);
      p := Pos('_CHAPTERS=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        Val(Copy(s, p + 10, MaxInt), j, r);
        if (r = 0) and (j > 0) and (j < 8191) then begin
          for k := 1 to j do begin
            r := CheckMenu(MainForm.MDVDT, i);
            if r < 0 then r := SubMenu_Add(MainForm.MDVDT, i, TID, nil);
            if CheckMenu(MainForm.MDVDT.Items[r], 0) < 0 then begin
              t := TTntMenuItem.Create(MainForm.MDVDT.Items[r]);
              t.Caption := Ccap; t.Tag := 0; t.GroupIndex := $0A;
              MainForm.MDVDT.Items[r].Add(t);
            end;
            if CheckMenu(MainForm.MDVDT.Items[r].Items[0], k) < 0 then begin
              if i = TID then
                SubMenu_Add(MainForm.MDVDT.Items[r].Items[0], k, CID, MainForm.MDVDCClick)
              else
                SubMenu_Add(MainForm.MDVDT.Items[r].Items[0], k, 0, MainForm.MDVDCClick);
            end;
          end;
        end;
        Result := true;
      end;
    end;
  end;

  function CheckBRA: boolean;
  var k: integer;
  begin
    Result := false;
    if (len > 16) and (Copy(Line, 1, 16) = 'ID_BLURAY_TITLE_') then begin
      s := Copy(Line, 17, MaxInt);
      p := Pos('_ANGLE=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        Val(Copy(s, p + 7, MaxInt), j, r);
        if (r = 0) and (j > 0) and (j < 8191) then begin
          for k := 1 to j do begin
            r := CheckMenu(MainForm.MBRT, i);
            if r < 0 then r := SubMenu_Add(MainForm.MBRT, i, TID, nil);
            if CheckMenu(MainForm.MBRT.Items[r], 1) < 0 then begin
              t := TTntMenuItem.Create(MainForm.MBRT.Items[r]);
              t.Caption := Acap; t.Tag := 1; t.GroupIndex := $0A;
              MainForm.MBRT.Items[r].Add(t);
            end;
            if CheckMenu(MainForm.MBRT.Items[r].Items[1], k) < 0 then begin
              if i = TID then
                SubMenu_Add(MainForm.MBRT.Items[r].Items[1], k, AID, MainForm.MDVDAClick)
              else
                SubMenu_Add(MainForm.MBRT.Items[r].Items[1], k, 0, MainForm.MDVDAClick);
            end;
          end;
        end;
        Result := true;
      end;
    end;
  end;

  function CheckDVDA: boolean;
  var k: integer;
  begin
    Result := false;
    if (len > 13) and (Copy(Line, 1, 13) = 'ID_DVD_TITLE_') then begin
      s := Copy(Line, 14, MaxInt);
      p := Pos('_ANGLES=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        Val(Copy(s, p + 8, MaxInt), j, r);
        if (r = 0) and (j > 0) and (j < 8191) then begin
          for k := 1 to j do begin
            r := CheckMenu(MainForm.MDVDT, i);
            if r < 0 then r := SubMenu_Add(MainForm.MDVDT, i, TID, nil);
            if CheckMenu(MainForm.MDVDT.Items[r], 1) < 0 then begin
              t := TTntMenuItem.Create(MainForm.MDVDT.Items[r]);
              t.Caption := Acap; t.Tag := 1; t.GroupIndex := $0A;
              MainForm.MDVDT.Items[r].Add(t);
            end;
            if CheckMenu(MainForm.MDVDT.Items[r].Items[1], k) < 0 then begin
              if i = TID then
                SubMenu_Add(MainForm.MDVDT.Items[r].Items[1], k, AID, MainForm.MDVDAClick)
              else
                SubMenu_Add(MainForm.MDVDT.Items[r].Items[1], k, 0, MainForm.MDVDAClick);
            end;
          end;
        end;
        Result := true;
      end;
    end;
  end;

  function CheckBRTL: boolean;
  begin
    Result := false;
    if (len > 16) and (Copy(Line, 1, 16) = 'ID_BLURAY_TITLE_') then begin
      s := Copy(Line, 17, MaxInt);
      p := Pos('_LENGTH=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        Val(Copy(s, p + 8, MaxInt), f, r);
        if (r = 0) and (f > 0) then begin
          r := CheckMenu(MainForm.MBRT, i);
          if r < 0 then r := SubMenu_Add(MainForm.MBRT, i, TID, nil);
          MainForm.MBRT.Items[r].Caption := MainForm.MBRT.Items[r].Caption + ' (' + SecondsToTime(round(f)) + ')';
        end;
        Result := true;
      end;
    end;
  end;

  function CheckDVDTL: boolean;
  begin
    Result := false;
    if (len > 13) and (Copy(Line, 1, 13) = 'ID_DVD_TITLE_') then begin
      s := Copy(Line, 14, MaxInt);
      p := Pos('_LENGTH=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        Val(Copy(s, p + 8, MaxInt), f, r);
        if (r = 0) and (f > 0) then begin
          r := CheckMenu(MainForm.MDVDT, i);
          if r < 0 then r := SubMenu_Add(MainForm.MDVDT, i, TID, nil);
          MainForm.MDVDT.Items[r].Caption := MainForm.MDVDT.Items[r].Caption + ' (' + SecondsToTime(round(f)) + ')';
        end;
        Result := true;
      end;
    end;
  end;

  function CheckChapterLen: boolean;
  var e: boolean; ds, ts: string;
  begin
    Result := false; j := -1;
    if Dnav then begin
      i := Pos(', CHAPTERS: ', Line);
      e := (len > 26) and (Copy(Line, 1, 6) = 'TITLE ') and (i > 0);
      if e then begin
        s := Copy(Line, i + 12, MaxInt);
        p:=StrToInt(Copy(Line,7,i-7));
      end;
    end
    else begin
      e := (len > 10) and (Copy(Line, 1, 10) = 'CHAPTERS: ');
      s := Copy(Line, 11, MaxInt);
      p := TID;
    end;
    if e then begin
      i := pos(',', s); ts := '00:00:00';
      while (i > 0) do begin
        inc(j); ds := copy(s, 1, i - 1);
        r := CheckMenu(MainForm.MDVDT, p);
        if r < 0 then r := SubMenu_Add(MainForm.MDVDT, p, TID, nil);
        if CheckMenu(MainForm.MDVDT.Items[r], 0) < 0 then begin
          t := TTntMenuItem.Create(MainForm.MDVDT.Items[r]);
          t.Caption := Ccap; t.Tag := 0; t.GroupIndex := $0A;
          MainForm.MDVDT.Items[r].Add(t);
        end;
        if CheckMenu(MainForm.MDVDT.Items[r].Items[0], j + 1) < 0 then
          SubMenu_Add(MainForm.MDVDT.Items[r].Items[0], j + 1, CID, MainForm.MDVDCClick);

        if Dnav then
          MainForm.MDVDT.Items[r].Items[0].Items[j].Caption := IntToStr(MainForm.MDVDT.Items[r].Items[0].Items[j].Tag) + ' (' + ts + ')'
        else
          MainForm.MDVDT.Items[r].Items[0].Items[j].Caption := IntToStr(MainForm.MDVDT.Items[r].Items[0].Items[j].Tag) + ' (' + ds + ')';
        //MainForm.MDVDT.Items[r].Items[0].Items[j].Caption := IntToStr(MainForm.MDVDT.Items[r].Items[0].Items[j].Tag)+' ('+copy(s,1,i-1)+')';
        ts := ds; s := copy(s, i + 1, MaxInt); i := pos(',', s);
      end;
      Result := true; HaveChapters := true;
    end;
  end;

  {function CheckDVDNavTL: boolean;
  var Entry: TPlaylistEntry;
  begin
    Result := false;
    if Dnav and (len > 27) and (Copy(Line, 1, 27) = 'DVDNAV, switched to title: ') then begin
      Val(Copy(Line, 28, MaxInt), i, r);
      if r = 0 then begin
        if i <> TID then tmpTID := i;
        Sendcommand('get_property chapter');
        SendCommand('get_time_length');
      end;
      Result := true; exit;
    end;

    if Dnav and (len > 17) and (Copy(Line, 1, 17) = 'DVDNAV_TITLE_IS_M') then begin
      s := Copy(Line, 18, MaxInt);
      if s = 'ENU' then IsDMenu := true
      else if s = 'OVIE' then IsDMenu := false;
      if (not IsDMenu) and (SecondPos = 0) and (tmpTID <> TID) then begin
        s := 'DVD-' + IntToStr(tmpTID) + Copy(DisplayURL, Pos(' <-- ', DisplayURL), MaxInt);
        i := playlist.FindItem('', s);
        j := CID; MainForm.UpdateParams; SMenu := false;
        if i < 0 then begin
          Entry.State := psNotPlayed; Entry.FullURL := MediaURL;
          Entry.DisplayURL := s;
          playlist.Add(Entry);
          i := playlist.FindItem('', s);
        end;
        Playlist.SetState(CurPlay, psPlayed);
        CurPlay := i;
        CID := j; TID := tmpTID;
        Playlist.NowPlaying(i);
        MainForm.DoOpen(Playlist[i].FullURL, Playlist[i].DisplayURL);
      end;
      Result := true;
    end;
  end;}

  function CheckDVDNavTL: boolean;
  begin
    Result := false;
    if Dnav and (len > 27) and (Copy(Line, 1, 27) = 'DVDNAV, switched to title: ') then begin
      Val(Copy(Line, 28, MaxInt), i, r);
      if r = 0 then tmpTID := i;
      Result := true; exit;
    end;

    if Dnav and (len > 17) and (Copy(Line, 1, 17) = 'DVDNAV_TITLE_IS_M') then begin
      s := Copy(Line, 18, MaxInt);
      if s = 'ENU' then IsDMenu := true
      else if s = 'OVIE' then begin
        IsDMenu := false; TID:=tmpTID;
        Sendcommand('get_property chapter');
        SendCommand('get_time_length');
      end;
      Result := true;
    end;
  end;

  function CheckCDCT: boolean;
  begin
    Result := false;
    if (len > 14) and (Copy(Line, 1, 14) = 'ID_CDDA_TRACK=') then begin
      Val(Copy(Line, 15, MaxInt), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        j:= CheckMenu(MainForm.MCDT, i);
        if j < 0 then
          SubMenu_Add(MainForm.MCDT, i, i, MainForm.MVCDTClick)
        else MainForm.MCDT.Items[j].Checked:=true;
        CDID:=i;
      end;
      Result := true;
    end;
  end;

  function CheckCDTL: boolean;
  begin
    Result := false;
    if (len > 14) and (Copy(Line, 1, 14) = 'ID_CDDA_TRACK_') then begin
      s := Copy(Line, 15, MaxInt);
      p := Pos('_MSF=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        if CheckMenu(MainForm.MCDT, i) < 0 then
          SubMenu_Add(MainForm.MCDT, i, CDID, MainForm.MVCDTClick);
        SubMenu_SetNameLang(MainForm.MCDT, i, copy(s, p + 5, MaxInt));
      end;
      Result := true;
    end;
  end;

  function CheckCDT: boolean;
  var k: integer;
  begin
    Result := false;
    if (len > 15) and (Copy(Line, 1, 15) = 'ID_CDDA_TRACKS=') then begin
      Val(Copy(Line, 16, Maxint), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) then begin
        for k := 1 to i do begin
          if CheckMenu(MainForm.MCDT, k) < 0 then
            SubMenu_Add(MainForm.MCDT, k, CDID, MainForm.MVCDTClick);
        end;
      end;
      Result := true; exit;
    end;
  end;

  function CheckVCDTL: boolean;
  begin
    Result := false;
    if (len > 13) and (Copy(Line, 1, 13) = 'ID_VCD_TRACK_') then begin
      s := Copy(Line, 14, MaxInt);
      p := Pos('_MSF=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i > 0) and (i < 8191) then begin
        if CheckMenu(MainForm.MVCDT, i) < 0 then
          SubMenu_Add(MainForm.MVCDT, i, CDID, MainForm.MVCDTClick);
        SubMenu_SetNameLang(MainForm.MVCDT, i, copy(s, p + 5, MaxInt));
      end;
      Result := true;
    end;
  end;

  function CheckVCDT: boolean;
  var k: integer;
  begin
    Result := false;
    if (len > 19) and (Copy(Line, 1, 19) = 'ID_VCD_START_TRACK=') then begin
      Val(Copy(Line, 20, MaxInt), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) then VCDST := i;
      Result := true; exit;
    end;

    if (len > 17) and (Copy(Line, 1, 17) = 'ID_VCD_END_TRACK=') then begin
      Val(Copy(Line, 18, MaxInt), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) then begin
        for k := VCDST to i do begin
          if CheckMenu(MainForm.MVCDT, k) < 0 then
            SubMenu_Add(MainForm.MVCDT, k, CDID, MainForm.MVCDTClick);
        end;
      end;
      Result := true;
    end;
  end;

  function CheckVideoID: boolean;
  begin
    Result := false;
    if (len > 12) and (Copy(Line, 1, 12) = 'ID_VIDEO_ID=') then begin
      Val(Copy(Line, 13, MaxInt), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) and (CheckMenu(MainForm.MVideo, i) < 0) then
        SubMenu_Add(MainForm.MVideo, i, VideoID, MainForm.MVideoClick);
      Result := true;
    end;
  end;

  function CheckVideoName: boolean;
  begin
    Result := false;
    if (len > 7) and (Copy(Line, 1, 7) = 'ID_VID_') then begin
      s := Copy(Line, 8, MaxInt);
      p := Pos('_NAME=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) then begin
        if CheckMenu(MainForm.MVideo, i) < 0 then
          SubMenu_Add(MainForm.MVideo, i, VideoID, MainForm.MVideoClick);
        SubMenu_SetNameLang(MainForm.MVideo, i, copy(s, p + 6, MaxInt));
      end;
      Result := true;
    end;
  end;

  function CheckAudioID: boolean;
  begin
    Result := false;
    if (len > 12) and (Copy(Line, 1, 12) = 'ID_AUDIO_ID=') then begin
      Val(Copy(Line, 13, MaxInt), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) and (CheckMenu(MainForm.MAudio, i) < 0) then
        SubMenu_Add(MainForm.MAudio, i, AudioID, MainForm.MAudioClick);
      Result := true;
    end;
  end;

  function CheckAudioNameLang: boolean;
  begin
    Result := false;
    if (len > 7) and (Copy(Line, 1, 7) = 'ID_AID_') then begin
      s := Copy(Line, 8, MaxInt);
      p := Pos('_NAME=', s);
      if p <= 0 then p := Pos('_LANG=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) then begin
        if CheckMenu(MainForm.MAudio, i) < 0 then
          SubMenu_Add(MainForm.MAudio, i, AudioID, MainForm.MAudioClick);
        SubMenu_SetNameLang(MainForm.MAudio, i, copy(s, p + 6, MaxInt));
      end;
      Result := true;
    end;
  end;

  function CheckSubID: boolean;
  begin
    Result := false;
    if (len > 15) and (Copy(Line, 1, 15) = 'ID_SUBTITLE_ID=') then begin
      Val(Copy(Line, 16, MaxInt), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) then begin
        if CheckMenu(MainForm.MSubtitle, VobsubCount + i) < 0 then begin
          SubMenu_Add(MainForm.MSubtitle, VobsubCount + i, SubID, MainForm.MSubtitleClick);
          inc(IntersubCount); CurrentSubCount := IntersubCount + VobsubCount;
        end;
      end;
      Result := true;
    end;
  end;

  function CheckSubNameLang: boolean;
  begin
    Result := false;
    if (len > 7) and (Copy(Line, 1, 7) = 'ID_SID_') then begin
      s := Copy(Line, 8, MaxInt);
      p := Pos('_NAME=', s);
      if p <= 0 then p := Pos('_LANG=', s);
      if p <= 0 then exit;
      Val(Copy(s, 1, p - 1), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) then begin
        if CheckMenu(MainForm.MSubtitle, VobsubCount + i) < 0 then begin
          SubMenu_Add(MainForm.MSubtitle, VobsubCount + i, SubID, MainForm.MSubtitleClick);
          inc(IntersubCount); CurrentSubCount := IntersubCount + VobsubCount;
        end;
        SubMenu_SetNameLang(MainForm.MSubtitle, VobsubCount + i, copy(s, p + 6, MaxInt));
      end;
      Result := true;
    end;
  end;

  function CheckFilesubID: boolean;
  var w:string;
  begin
    Result := false;
    if (len > 15) and (Copy(Line, 1, 15) = 'ID_FILE_SUB_ID=') then begin
      Val(Copy(Line, 16, MaxInt), i, r);
      if (r = 0) and (i >= 0) and (i < 8191) then begin
        VobAndInterSubCount := IntersubCount + VobsubCount;
        if Loadsub = 1 then begin
          SubID := i + VobAndInterSubCount;
          MainForm.MShowSub.Checked := true;
          SendCommand('sub_select ' + IntToStr(SubID));
        end
        else
          CurrentSubCount := VobAndInterSubCount + i + 1;
        SubMenu_Add(MainForm.MSubtitle, i + VobAndInterSubCount, SubID, MainForm.MSubtitleClick);
      end;
      Result := true; exit;
    end;

    if (len > 21) and (Copy(Line, 1, 21) = 'ID_FILE_SUB_FILENAME=') then begin
      s := copy(Line, 22, MaxInt);
      SubMenu_SetNameLang(MainForm.MSubtitle, MainForm.MSubtitle.Count - 1, s);
      case Loadsub of
        1: begin
             inc(subcount);
             if subcount>1 then
               substring:=substring+','+EscapeParam(s)
             else
               substring:=EscapeParam(s);
             Loadsrt := 1;
           end;
        2: begin
             if IsWideStringMappableToAnsi(MediaURL) then w:=GetFileName(MediaURL)
             else w:=GetFileName(WideExtractShortPathName(MediaURL));
             if w<>GetFileName(s) then begin
               inc(subcount);
               if subcount>1 then
                 substring:=substring+','+EscapeParam(s)
               else
                 substring:=EscapeParam(s);
               Lastsubcount := subcount;
             end;
           end;
      end;
      Result := true;
    end;
  end;

  function UpdateLen: integer;
  var k: string; a: integer;
  begin
    Result := TotalTime; r:=0;
    if bluray then m:= MainForm.MBRT
    else if dvd then m:= MainForm.MDVDT
    else if cd then m:= MainForm.MCDT
    else m:= MainForm.MVCDT;
    if dvd or bluray then begin
      if TID=0 then p:=1
      else p:=TID;
      r := CheckMenu(m, p);
      if r < 0 then r := SubMenu_Add(m, p, TID, nil);
      if CheckMenu(m.Items[r], 0) < 0 then begin
        t := TTntMenuItem.Create(m.Items[r]);
        t.Caption := Ccap; t.Tag := 0; t.GroupIndex := $0A;
        m.Items[r].Add(t);
      end;
      a := CheckMenu(m.Items[r].Items[0], CID);
      if a < 0 then
        a := SubMenu_Add(m.Items[r].Items[0], CID, CID, MainForm.MDVDCClick);

      s := m.Items[r].Items[0].Items[a].Caption;
      i := pos('(', s);
      {if Dnav then begin //caption=endTime
        if a=0 then r:=TimeToSeconds(copy(s,i+1,8))
        else begin
          k:=m.Items[r].Items[0].Items[a-1].Caption;
          j:=pos('(',k); r:=TimeToSeconds(copy(s,i+1,8))-TimeToSeconds(copy(k,j+1,8));
        end;
      end
      else begin }//caption=startTime
      if a = m.Items[r].Items[0].Count - 1 then begin
        if TTime > 0 then begin
          r := TTime - TimeToSeconds(copy(s, i + 1, 8));
          ChaptersLen:=TTime;
        end;
      end
      else begin
        k := m.Items[r].Items[0].Items[a + 1].Caption;
        j := pos('(', k);
        ChaptersLen:= TimeToSeconds(copy(k, j + 1, 8));
        r := ChaptersLen - TimeToSeconds(copy(s, i + 1, 8));
      end;
      //end;
    end
    else if cd or vcd then begin
      r:=CheckMenu(m,CDID);
      if r>-1 then begin
        s:=m.Items[r].Caption;
        i:=pos('(',s);
        if i>0 then begin
          s:='00:'+copy(copy(s,i+1,MaxInt),1,5);
          r:= TimeToSeconds(s);
        end;
      end;
    end;
    if r > 0 then Result := r;
  end;

  function CheckLength: boolean;
  begin
    Result := (len > 10) and (Copy(Line, 1, 10) = 'ID_LENGTH=');
    if Result then begin
      Val(Copy(Line, 11, MaxInt), f, r);
      if r = 0 then begin
        if IsMediaInfoLoaded = 0 then MediaInfoDLL_Load;
        if IsMediaInfoLoaded <> 0 then begin
          h := MediaInfo_New();
          MediaInfo_Open(h,PWideChar(EscapeParam(WideExtractShortPathName(MediaURL))));
          MediaInfo_Option (0, 'Inform', 'General;%Duration/String3%');
          s := MediaInfo_Inform(h, 0);
          MediaInfo_Close(h);
        end;
        if (IsMediaInfoLoaded <> 0) and (s<>'') then TTime:=TimeToSeconds(s)
        else TTime := abs(round(f)); TotalTime:= TTime;
      end;
      if HaveChapters then begin
        ChapterLen:=UpdateLen;
        if not UDVDTtime then TotalTime:= ChapterLen;
      end;
      Duration := SecondsToTime(TotalTime);
      StreamInfo.PlaybackTime := Duration;
      InfoForm.UpdateInfo(false);
    end;
  end;

  function CheckFileFormat: boolean;
  begin
  //Enlish version
    p := len - 21;
    Result := (p > 0) and (Copy(Line, p, 22) = ' file format detected.');
    if Result then begin
      StreamInfo.FileFormat := Widestring(Copy(Line, 1, p - 1));
      exit;
    end;
  //Chinese version
    p := len - 9;
    Result := (p > 0) and (Copy(Line, p, 10) = '文件格式。') and (Copy(Line, 1, 6) = '检测到');
    if Result then StreamInfo.FileFormat := Widestring(Copy(Line, 7, p - 7));
  end;

  function CheckDecoder: boolean;
  begin
  //Enlish version
    Result := (len > 24) and (Copy(Line, 1, 8) = 'Opening ') and (Copy(Line, 13, 12) = 'o decoder: [');
    if Result then begin
      p := Pos('] ', Line);
      Result := (p > 24);
      if Result then begin
        if Copy(Line, 9, 4) = 'vide' then
          StreamInfo.Video.Decoder := Widestring(Copy(Line, p + 2, MaxInt))
        else if Copy(Line, 9, 4) = 'audi' then
          StreamInfo.Audio.Decoder := Widestring(Copy(Line, p + 2, MaxInt))
        else Result := false;
      end;
      exit;
    end;
  //Chinese version
    Result := (len > 17) and (Copy(Line, 1, 4) = '打开') and (Copy(Line, 7, 11) = '频解码器: [');
    if Result then begin
      p := Pos('] ', Line);
      Result := (p > 17);
      if Result then begin
        if Copy(Line, 5, 2) = '视' then
          StreamInfo.Video.Decoder := Widestring(Copy(Line, p + 2, MaxInt))
        else if Copy(Line, 5, 2) = '音' then
          StreamInfo.Audio.Decoder := Widestring(Copy(Line, p + 2, MaxInt))
        else Result := false;
      end;
    end;
  end;

  function CheckCodec: boolean;
  begin
  //Enlish version
    Result := (len > 23) and (Copy(Line, 1, 9) = 'Selected ') and (Copy(Line, 14, 10) = 'o codec: [');
    if Result then begin
      p := Pos(' (', Line);
      Result := (p > 23);
      if Result then begin
        if Copy(Line, 10, 4) = 'vide' then
          StreamInfo.Video.Codec := Widestring(Copy(Line, p + 2, length(Line) - p - 2))
        else if Copy(Line, 10, 4) = 'audi' then
          StreamInfo.Audio.Codec := Widestring(Copy(Line, p + 2, length(Line) - p - 2))
        else Result := false;
      end;
      exit;
    end;
  //Chinese version
    Result := (len > 19) and (Copy(Line, 1, 4) = '选定') and (Copy(Line, 7, 13) = '频编解码器: [');
    if Result then begin
      p := Pos(' (', Line);
      Result := (p > 19);
      if Result then begin
        if Copy(Line, 5, 2) = '视' then
          StreamInfo.Video.Codec := Widestring(Copy(Line, p + 2, length(Line) - p - 2))
        else if Copy(Line, 5, 2) = '音' then
          StreamInfo.Audio.Codec := Widestring(Copy(Line, p + 2, length(Line) - p - 2))
        else Result := false;
      end;
    end;
  end;

  function CheckTVScan: boolean;
  begin
    Result:=false;
    if (len > 12) and (Copy(Line, 1, 8) = 'Trying: ') then begin
      i:= pos('(',Line);
      with OpenDevicesForm.HK.Items.Add do begin
        Caption:=Copy(Line, 9, i-10);
        SubItems.add(Copy(Line, i+1,pos(').',Line)-i-2));
      end;
      Result:=true;
    end;
  end;
  
  function CheckICYInfo: boolean;
  begin
    Result := False;
    if (len < 10) or (Copy(Line, 1, 10) <> 'ICY Info: ') then exit
    else Result := true;
    P := Pos('StreamTitle=''', Line); if P < 10 then exit;
    Delete(Line, 1, P + 12);
    P := Pos(''';', Line); if P < 1 then exit;
    SetLength(Line, P - 1);
    if length(Line) = 0 then exit;
    P := 0; while (P < 9)
    and (length(StreamInfo.ClipInfo[P].Key) > 0)
      and (StreamInfo.ClipInfo[P].Key <> 'Title')
      do inc(P);
    StreamInfo.ClipInfo[P].Key := 'Title';
    if StreamInfo.ClipInfo[P].Value <> Widestring(Line) then begin
      StreamInfo.ClipInfo[P].Value := Widestring(Line);
      InfoForm.UpdateInfo(true);
    end;
  end;

  procedure CheckNoAudio;
  begin
    if ChkAudio and (StreamInfo.Audio.Codec = '') then begin
      HaveAudio := false; MainForm.MAudios.Visible := false;
      MainForm.BMute.Enabled := false; ChkAudio := false;
    end;
  end;

  function CheckAudio: boolean;
  begin
    Result := false;
    if (len < 5) or (Copy(Line, 1, 5) <> 'AO: [') then exit;
    if (Copy(Line, 6, 5) = 'win32') or (Copy(Line, 6, 6) = 'dsound') then begin
      HaveAudio := true; MainForm.MAudios.Visible := true;
      MainForm.BMute.Enabled := true; ChkAudio := false;
      SendCommand('set_property balance ' + FloatToStr(balance));
      Result := true;
    end
  end;

  procedure CheckNoVideo;
  begin
    with MainForm do begin
      if ChkVideo and (StreamInfo.Video.Codec = '') then begin
        HaveVideo := false; ChkVideo := false;
        if LastHaveVideo then begin
          LastHaveVideo := false; MFunc := 0;
          MWheelControl.Items[0].Checked := true;
          MPWheelControl.Items[0].Checked := true;
          if not ds then OPanel.Visible := false;
          if not (OptionsForm.Visible or EqualizerForm.Visible) then Enabled := true;
          if MFullscreen.Checked then SetFullscreen(false);
          if MCompact.Checked or MMaxW.Checked then SetCompact(false);
          Mctrl.Checked := false; Hide_menu.Checked := false; MPCtrl.Checked := true;
          CPanel.Visible := true; MenuBar.Visible := true;
          UpdateMenuEV(false);
          if not ds then begin
            SetWindowLong(Handle, GWL_STYLE, DWORD(GetWindowLong(Handle, GWL_STYLE)) and (not WS_SIZEBOX) and (not WS_MAXIMIZEBOX) and (not WS_MAXIMIZE));
           // mainform.WindowState:= wsNormal;
          end;
          r := Left + ((Width - Constraints.MinWidth) div 2);
          if ds then begin
            i := Top + ((Height - defaultHeight) div 2);
            SetBounds(r, i, Constraints.MinWidth, defaultHeight);
          end
          else begin
            i := Top + ((Height - Constraints.MinHeight) div 2);
            SetBounds(r, i, Constraints.MinWidth, Constraints.MinHeight);
          end;
        end;
        if FirstOpen and (HaveLyric = 0) then Lyric.DownloadLyric;
      end;
    end;
  end;

  procedure CheckStartPlayback;
  begin
    if ChkStartPlay then begin
      ChkStartPlay := false;
      if not (HaveVideo) then MainForm.SetupPlay;
    end;
  end;

  function CheckNativeResolutionLine: boolean;
  begin
    Result := false;
    if (len < 5) or (Copy(Line, 1, 5) <> 'VO: [') then exit; s := Line;
    p := Pos(' => ', Line); if p = 0 then exit; Delete(Line, 1, p + 3);
    p := Pos(#32, Line); if p = 0 then exit; SetLength(Line, p - 1);
    p := Pos('x', Line); if p = 0 then exit;
    Val(Copy(Line, 1, p - 1), i, r); if (r <> 0) or (i < 16) or (i >= 4096) then exit;
    Val(Copy(Line, p + 1, 5), j, r); if (r <> 0) or (j < 16) or (j >= 4096) then exit;
    ChkVideo := false; if copy(s, 6, 7) = 'directx' then IsDx := true;
    with MainForm do begin
      if not Win32PlatformIsUnicode then begin
        HaveVideo := false; LastHaveVideo := false;
        MVideos.Visible := true; MSub.Visible := true;
        SetupPlay;
        Result := true;
        exit;
      end;
      NativeWidth := i; NativeHeight := j;
      StreamInfo.Video.Width := i; StreamInfo.Video.Height := j;
      if j <> 0 then StreamInfo.Video.Aspect := i / j;
      if NativeWidth < (Constraints.MinWidth + OPanel.Width - Width) then begin
        NativeWidth := Constraints.MinWidth + OPanel.Width - Width;
        if i <> 0 then NativeHeight := NativeWidth * j div i;
      end;
      case CBHSA of
        3: begin
            VideoSizeChanged;
            InfoForm.UpdateInfo(false);
            Result := true;
            exit;
          end;
        4: begin
            if (Eq2 = LastEq2) and (Dda = LastDda) then begin
              if (contr <> 101) and (contr <> contrD) then
                SendCommand('set_property contrast ' + IntToStr(contr));
              if (bri <> 101) and (bri <> briD) then
                SendCommand('set_property brightness ' + IntToStr(bri));
              if (hu <> 101) and (hu <> huD) then
                SendCommand('set_property hue ' + IntToStr(hu));
              if (sat <> 101) and (sat <> satD) then
                SendCommand('set_property saturation ' + IntToStr(sat));
              if Eq2 and (not Dda) and (gam <> 101) and (gam <> gamD) then
                SendCommand('set_property gamma ' + IntToStr(gam));
            end;
            if (Eq2 <> LastEq2) or (Dda <> LastDda) then begin
              bri := 101; contr := 101; hu := 101; sat := 101; CBHSA := 0;
              SendCommand('get_property contrast'); SendCommand('get_property saturation');
              SendCommand('get_property brightness'); SendCommand('get_property hue');
              if Eq2 and (not Dda) then begin
                gam := 101; SendCommand('get_property gamma');
              end;
            end;
          end;
      end;

      if FirstOpen then begin
        if (Eq2 <> LastEq2) or (Dda <> LastDda) then begin
          bri := 101; contr := 101; hu := 101; sat := 101;
          if Eq2 and (not Dda) then gam := 101;
        end;
        SendCommand('get_property contrast'); SendCommand('get_property brightness');
        SendCommand('get_property hue'); SendCommand('get_property saturation');
        if Eq2 and (not Dda) then SendCommand('get_property gamma');
      end;

      if Wid then begin
        if not LastHaveVideo then begin
          OPanel.Visible := true; LastHaveVideo := true;
          SetWindowLong(Handle, GWL_STYLE, DWORD(GetWindowLong(Handle, GWL_STYLE)) or WS_SIZEBOX or WS_MAXIMIZEBOX);
          if (not ds) or (Height = Constraints.MinHeight) then begin
            if RS and (EW <> 0) and (EH <> 0) then begin
              j := Width - OPanel.Width + EW; p := MWC + MenuBar.Height + CPanel.Height + Width - OPanel.Width + EH;
            end
            else begin
              j := Width - OPanel.Width + NativeWidth;
              p := MWC + MenuBar.Height + CPanel.Height + Width - OPanel.Width + NativeHeight;
            end;
            r := Left - ((j - Constraints.MinWidth) div 2);
            i := Top - ((p - Constraints.MinHeight) div 2);
            if RS and (EW <> 0) and (EH <> 0) then begin
              if r < CurMonitor.Left then r := CurMonitor.Left ; if i < CurMonitor.Top then i := CurMonitor.Top;
              if j > CurMonitor.Width then begin
                j := CurMonitor.Width; end;
              if p > CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top then begin
                p := CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top; end;
              if (r + j) > (CurMonitor.Left + CurMonitor.Width) then r := CurMonitor.Left + CurMonitor.Width - j;
              if (i + p) > (CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top) then
                i := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - p;
              SetBounds(r, i, j, p);
            end
            else begin
              SetBounds(r, i, j, p);
              MSize100.Checked := true;
            end;
          end;
        end;
      end
      else begin
        if LastHaveVideo then begin
          OPanel.Visible := false; LastHaveVideo := false;
          if not (OptionsForm.Visible or EqualizerForm.Visible) then Enabled := true;
          if MFullscreen.Checked then SetFullscreen(false);
          if MCompact.Checked or MMaxW.Checked then SetCompact(false);
          Mctrl.Checked := false; Hide_menu.Checked := false; MPCtrl.Checked := true;
          CPanel.Visible := true; MenuBar.Visible := true;
          SetWindowLong(Handle, GWL_STYLE, DWORD(GetWindowLong(Handle, GWL_STYLE)) and (not WS_SIZEBOX) and (not WS_MAXIMIZEBOX) and (not WS_MAXIMIZE));
          r := Left + ((Width - Constraints.MinWidth) div 2);
          i := CurMonitor.Top + CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top - Constraints.MinHeight;
          SetBounds(r, i, Constraints.MinWidth, Constraints.MinHeight);
          PlaylistForm.Left := Left - PlaylistForm.Width;
          PlaylistForm.Top := Top + Height - PlaylistForm.Height;
          MFunc := 0;
          MWheelControl.Items[0].Checked := true;
          MPWheelControl.Items[0].Checked := true;
        end;
      end;
      UpdateMenuEV(true);
      MRmMenu.Visible := Dnav; MRnMenu.Visible := Dnav;
      MDeinterlace.Enabled := not Dda; MSEqualizer.Enabled := not Dda;
      if MSubtitle.Count > 0 then begin
        if SubID < 0 then SubID := 0;
        SendCommand('set_property sub ' + IntToStr(SubID));
        if not MShowSub.Checked then SendCommand('set_property sub_visibility 0');
      end
      else if FirstOpen and AutoDs then begin
        a := TDownLoadLyric.Create(true);
        a.title:= GetFileName(WideExtractFileName(MediaURL));
        a.FN:=WideIncludeTrailingPathDelimiter(LyricDir) + a.title + '.zip';
        a.FreeOnTerminate := true; a.mode:=4; a.Lang:=DLyricForm.CLang.ItemIndex;
        a.Resume;
        LoadSLibrary;
        if IsSLoaded <> 0 then
          DownloaderSubtitleW(PWChar(MediaURL), True, DownSubtitle_CallBackW, DownSubtitle_CallBackFinish);
      end;

      LastEq2 := Eq2; LastDda := Dda; HaveVideo := true;
      VideoSizeChanged; SetupPlay;
      Result := true;
    end;
  end;

begin
  Line := Trim(Line); len := length(Line);
  if len < 1 then exit;
  // Time position indicators are "first-class citizens", because they
  // make up for 99.999% of all traffic. So we have to handle them *FAST*!
  if len > 2 then begin
    if Line[1] = ^J then j := 4 else j := 3;
    if ((Line[j - 2] = 'A') or (Line[j - 2] = 'V')) and (Line[j - 1] = ':') then begin
      i := Pos('.', Line);
      if i <= j then exit;
      Val(Copy(Line, j, i - j), p, r);
      if (r <> 0) or (p < 0) then exit;
      CheckNOAudio; CheckNOVideo; CheckStartPlayback;
      if IsPause then IsPause := false else MainForm.Unpaused;

      if HaveLyric <> 0 then begin
        i := p * 10 + ord(Line[i + 1]) - 48;
        if MSecPos <> i then begin
          MSecPos := i;
          Lyric.GetCurrentLyric;
        end;
      end;

      if p <> SecondPos then begin
        if p = 0 then begin
          if HaveChapters then Sendcommand('get_property chapter');
          SendCommand('get_time_length');
        end;
        if HaveChapters then begin
          if CID = 1 then UDVDTtime:=false
          else UDVDTtime:= p>=(ChaptersLen - ChapterLen);
          if UDVDTtime then TotalTime:=Ttime
          else TotalTime:=ChapterLen;
          s:= SecondsToTime(TotalTime);
          if Duration<>s then begin
            Duration := s;
            StreamInfo.PlaybackTime := Duration;
            InfoForm.UpdateInfo(false);
          end;
        end;
        if HaveChapters and UDVDTtime then begin
          if ((p<=(ChaptersLen - ChapterLen)) or (p>=ChaptersLen)) and (not IsDMenu) then begin
            Sendcommand('get_property chapter');
            SendCommand('get_time_length');
          end;
        end;
        if IsDMenu then SecondPos := 0
        else SecondPos := p;
        MainForm.UpdateTime; if SecondPos < EP then skip := true;
        if HaveChapters then begin
          if UDVDTtime then b:= SecondPos = (ChaptersLen - 1)
          else b:= SecondPos = (ChapterLen - 1);
          if b then begin
            if bluray then m:= MainForm.MBRT
            else m:= MainForm.MDVDT;
            if TID=0 then i:=1
            else i:=TID;
            i := CheckMenu(m, i);
            r := CheckMenu(m.Items[i].Items[0], CID);
            if r < m.Items[i].Items[0].Count - 1 then begin
              m.Items[i].Items[0].Items[r + 1].Checked := true;
              inc(CID);   //针对不带chapter属性的mplayer
              ChapterLen:=UpdateLen;
              {if not UDVDTtime then begin
                TotalTime:= ChapterLen;
                Duration := SecondsToTime(TotalTime);
                StreamInfo.PlaybackTime := Duration;
                InfoForm.UpdateInfo(false);
              end;}
            end;
          end;
        end;

       { if MainForm.MSIE.Checked and (EP>0) and (SecondPos>=Ep) then begin
          MainForm.UpdateParams; MainForm.NextFile(1,psPlayed);
        end; }
        if Mainform.MSIE.Checked then begin
          if (p = 0) and (Bp > p) and (Bp < TotalTime) then begin
            if Status = sPaused then SendCommand('seek ' + IntToStr(Bp))
            else begin
              SendCommand('set_property mute 1');
              SendCommand('seek ' + IntToStr(Bp));
              SendCommand('set_property mute 0');
            end;
          end;
          if (EP > 0) and (SecondPos = Ep) and skip then begin
            skip := false;
            if HaveChapters and (not UDVDTtime) then begin
              key := VK_HOME;
              MainForm.FormKeyDown(nil, key, []);
            end
            else begin
              MainForm.UpdateParams; MainForm.NextFile(1, psPlayed);
            end
          end;
        end;
      end;
      exit;
    end;
  end;

  //check for "PAUSED"
  if Line = 'ID_PAUSED' then begin
    IsPause := true;
    if Status = sPlaying then begin
      Status := sPaused; MainForm.BPause.Down := true;
      MainForm.BPlay.Down := false; MainForm.UpdateStatus;
      SendCommand('set_property mute 1');
    end;
    exit;
  end;
  for i := 0 to 1 do if Pos(PauseInfo[i], Line) <> 0 then exit;

  // normal line handling: check for "cache fill"
  for i := 0 to 4 do begin
    r := length(CacheFill[i]);
    if len < (r + 7) then continue;
    p := pos(CacheFill[i], Line);
    if (p = 1) and (Line[r + 7] = '%') then begin
      MainForm.LStatus.Caption := Line;
      Sleep(0); // "yield"
      exit;
    end;
  end;

  // check "Generating Index"  正在生成索引:  14 %  Generating Index:  99 %
  for i := 0 to 2 do begin
    r := length(GenIndex[i]);
    if len < (r + 6) then continue;
    p := pos(GenIndex[i], Line);
    if (p = 1) and (Line[r + 6] = '%') then begin
      MainForm.LStatus.Caption := Line;
      Sleep(0); // "yield"
      exit;
    end;
  end;

  // check contrast (hidden from log)
  if (len > 13) and (Copy(Line, 1, 13) = 'ANS_contrast=') then begin
    Val(Copy(Line, 14, MaxInt), i, r);
    if (r = 0) and (i >= -100) and (i <= 100) then begin
      case CBHSA of
        0: begin
            contrD := i;
            if contr = 101 then contr := i
            else begin
              if contr <> contrD then
                SendCommand('set_property contrast ' + IntToStr(contr));
            end;
          end;
        1, 5: contr := i;
      end;
      EqualizerForm.SCon.Enabled := true; EqualizerForm.TCon.Enabled := true;
      EqualizerForm.TCon.Position := i;
    end;
    exit;
  end;
  // check brightness (hidden from log)
  if (len > 15) and (Copy(Line, 1, 15) = 'ANS_brightness=') then begin
    Val(Copy(Line, 16, MaxInt), i, r);
    if (r = 0) and (i >= -100) and (i <= 100) then begin
      case CBHSA of
        0: begin
            briD := i;
            if bri = 101 then bri := i
            else begin
              if bri <> briD then
                SendCommand('set_property brightness ' + IntToStr(bri));
            end;
          end;
        1, 5: bri := i;
      end;
      EqualizerForm.Sbri.Enabled := true; EqualizerForm.TBri.Enabled := true;
      EqualizerForm.TBri.Position := i;
    end;
    exit;
  end;
  // check hue (hidden from log)
  if (len > 8) and (Copy(Line, 1, 8) = 'ANS_hue=') then begin
    Val(Copy(Line, 9, MaxInt), i, r);
    if (r = 0) and (i >= -100) and (i <= 100) then begin
      case CBHSA of
        0: begin
            huD := i;
            if hu = 101 then hu := i
            else begin
              if hu <> huD then
                SendCommand('set_property hue ' + IntToStr(hu));
            end;
          end;
        1, 5: hu := i;
      end;
      EqualizerForm.Shue.Enabled := true; EqualizerForm.Thue.Enabled := true;
      EqualizerForm.THue.Position := i;
    end;
    exit;
  end;
  // check saturation (hidden from log)
  if (len > 15) and (Copy(Line, 1, 15) = 'ANS_saturation=') then begin
    Val(Copy(Line, 16, MaxInt), i, r);
    if (r = 0) and (i >= -100) and (i <= 100) then begin
      case CBHSA of
        0: begin
            satD := i;
            if sat = 101 then sat := i
            else begin
              if sat <> satD then
                SendCommand('set_property saturation ' + IntToStr(sat));
            end;
          end;
        1, 5: sat := i;
      end;
      EqualizerForm.SSat.Enabled := true; EqualizerForm.TSat.Enabled := true;
      EqualizerForm.TSat.Position := i;
    end;
    exit;
  end;
  // check gamma (hidden from log)
  if (len > 10) and (Copy(Line, 1, 10) = 'ANS_gamma=') then begin
    Val(Copy(Line, 11, MaxInt), i, r);
    if (r = 0) and (i >= -100) and (i <= 100) then begin
      case CBHSA of
        0: begin
            gamD := i;
            if gam = 101 then gam := i
            else begin
              if gam <> gamD then
                SendCommand('set_property gamma ' + IntToStr(gam));
            end;
          end;
        1, 5: gam := i;
      end;
      EqualizerForm.SGam.Enabled := true; EqualizerForm.TGam.Enabled := true;
      EqualizerForm.TGam.Position := i;
    end;
    exit;
  end;
  // check Failed to set property (hidden from log)
  if (len > 22) and (Copy(Line, 1, 22) = 'Failed to set property') then exit;
  // check Failed to get value of property (hidden from log)
  if (len > 31) and (Copy(Line, 1, 31) = 'Failed to get value of property') then begin
    if Copy(Line, 34, 8) = 'contrast' then begin
      EqualizerForm.SCon.Enabled := false; EqualizerForm.TCon.Enabled := false;
      exit;
    end;
    if Copy(Line, 34, 10) = 'brightness' then begin
      EqualizerForm.Sbri.Enabled := false; EqualizerForm.TBri.Enabled := false;
      exit;
    end;
    if Copy(Line, 34, 3) = 'hue' then begin
      EqualizerForm.Shue.Enabled := false; EqualizerForm.Thue.Enabled := false;
      exit;
    end;
    if Copy(Line, 34, 10) = 'saturation' then begin
      EqualizerForm.SSat.Enabled := false; EqualizerForm.TSat.Enabled := false;
      exit;
    end;
    if Copy(Line, 34, 5) = 'gamma' then begin
      EqualizerForm.SGam.Enabled := false; EqualizerForm.TGam.Enabled := false;
      exit;
    end;
    exit;
  end;

  //check ScreenshotName
  if (len > 15) and (Copy(Line, 1, 15) = '*** screenshot ') then begin
    if not Isub then SendCommand('osd_show_text "' + OSD_ScreenShot_Prompt + Copy(Line, 17, length(Line) - 25) + '"');
    exit;
  end;
  // check Chapter ID
  if (len > 12) and (Copy(Line, 1, 12) = 'ANS_chapter=') then begin
    Val(Copy(Line, 13, MaxInt), i, r);
    if (r = 0) and (i >= 0) then begin
      if bluray then m:= MainForm.MBRT
      else m:= MainForm.MDVDT;
      if TID=0 then p:=1
      else p:=TID;
      CID := i + 1;
      r := CheckMenu(m, p);
      if r < 0 then r := SubMenu_Add(m, p, TID, nil);
      if CheckMenu(m.Items[r], 0) < 0 then begin
        t := TTntMenuItem.Create(m.Items[r]);
        t.Caption := Ccap; t.Tag := 0; t.GroupIndex := $0A;
        m.Items[r].Add(t);
      end;
      i := CheckMenu(m.Items[r].Items[0], CID);
      if i < 0 then
        SubMenu_Add(m.Items[r].Items[0], CID, CID, MainForm.MDVDCClick)
      else m.Items[r].Items[0].Items[i].Checked := true;
      m.Items[r].Checked:=true;
    end;
    exit;
  end;
  //check time length
  if (len > 11) and (Copy(Line, 1, 11) = 'ANS_LENGTH=') then begin
    Val(Copy(Line, 12, MaxInt), f, r);
    if r = 0 then begin
      if IsMediaInfoLoaded = 0 then MediaInfoDLL_Load;
      if IsMediaInfoLoaded <> 0 then begin
        h := MediaInfo_New();
        MediaInfo_Open(h,PWideChar(EscapeParam(WideExtractShortPathName(MediaURL))));
        MediaInfo_Option (0, 'Inform', 'General;%Duration/String3%');
        s := MediaInfo_Inform(h, 0);
        MediaInfo_Close(h);
      end;
      if (IsMediaInfoLoaded <> 0) and (s<>'') then TTime:=TimeToSeconds(s)
      else TTime := abs(round(f)); TotalTime:= TTime;
    end;
    if HaveChapters then begin
      ChapterLen:=UpdateLen;
      if not UDVDTtime then TotalTime:= ChapterLen;
    end;
    Duration := SecondsToTime(TotalTime);
    StreamInfo.PlaybackTime := Duration;
    InfoForm.UpdateInfo(false);
    if CID + AID > 2 then begin
      MainForm.LTime.Font.Size := 12; MainForm.LTime.Top := 0; end;
    exit;
  end;
  //check balance
  if (len > 12) and (Copy(Line, 1, 12) = 'ANS_balance=') then begin
    Val(Copy(Line, 13, MaxInt), f, r);
    if r = 0 then begin
      balance := f;
      if f = -1 then MainForm.MLchannels.Checked := true
      else if f = 1 then MainForm.MRchannels.Checked := true
      else MainForm.MStereo.Checked := true;
    end;
    exit;
  end;

  //suppress repetitive lines
  if (len > 0) and (Line = LastLine) then begin
    inc(LineRepeatCount);
    {if LineRepeatCount=20 then begin
      OptionsForm.AddLine('(last message repeated '+IntToStr(LineRepeatCount)+' times)');
      ExplicitStop:=0; Status:=sOpening; LineRepeatCount:=0;
      if FirstChance then begin
        SendCommand('quit'); FirstChance:=false;
        if WaitForSingleObject(ClientProcess,stopTimeout)=WAIT_TIMEOUT then TerminateMP;
      end;
    end;}
    exit;
  end;
  if LineRepeatCount > 0 then
    OptionsForm.AddLine('(last message repeated ' + IntToStr(LineRepeatCount) + ' times)');
  LastLine := Line; LineRepeatCount := 0;

  // add line to log and check for special patterns
  if UseUni then OptionsForm.AddLine(UTF8Decode(Line))
  else OptionsForm.AddLine(Line);

  if not CheckVobsubID then
    if not CheckVobsubLang then
      if not CheckDVDT then
      if not CheckBRT then
        if not CheckDVDC then
        if not CheckBRC then
          if not CheckDVDA then
          if not CheckBRA then
            if not CheckDVDTL then
            if not CheckBRTL then
              if not CheckVCDTL then
              if not CheckVCDT then
              if not CheckCDTL then
              if not CheckCDT then
              if not CheckCDCT then
                if not CheckChapterLen then
                  if not CheckVideoID then
                    if not CheckVideoName then
                      if not CheckAudioID then
                        if not CheckAudioNameLang then
                          if not CheckSubID then
                            if not CheckSubNameLang then
                              if not CheckFilesubID then
                                if not CheckLength then
                                  if not CheckFileFormat then
                                    if not CheckDecoder then
                                      if not CheckCodec then
                                        if not CheckICYInfo then
                                          if not CheckAudio then
                                            if not CheckNativeResolutionLine then // modifies Line, should be last
                                              if not CheckDVDNavTL then
                                              if not CheckTVScan then
                                                ;
  // check for generic ID_ pattern
  if (len > 3) and (Copy(Line, 1, 3) = 'ID_') then begin
    p := Pos('=', Line);
    HandleIDLine(Copy(Line, 4, p - 4), WideString(Trim(Copy(Line, p + 1, MaxInt))));
  end;

end;


////////////////////////////////////////////////////////////////////////////////

procedure HandleIDLine(ID: string; Content: WideString);
var AsInt, r: integer; AsFloat: real;
begin
  with StreamInfo do begin
  // convert to int and float
    val(Content, AsInt, r);
    if r <> 0 then begin
      val(Content, AsFloat, r);
      if r <> 0 then begin
        AsInt := 0; AsFloat := 0;
      end
      else AsInt := trunc(AsFloat);
    end
    else AsFloat := AsInt;

    // handle some common ID fields
    if ID = 'VIDEO_BITRATE' then Video.Bitrate := AsInt
    //else if ID='VIDEO_WIDTH'   then Video.Width:=AsInt
    //else if ID='VIDEO_HEIGHT'  then Video.Height:=AsInt
    else if ID = 'VIDEO_FPS' then Video.FPS := AsFloat
    //else if ID='VIDEO_ASPECT'  then Video.Aspect:=AsFloat
    else if ID = 'AUDIO_BITRATE' then Audio.Bitrate := AsInt
    else if ID = 'AUDIO_RATE' then Audio.Rate := AsInt
    else if ID = 'AUDIO_NCH' then Audio.Channels := AsInt
    else if (ID = 'DEMUXER') then begin
      DemuxerName := Content;
      if (length(FileFormat) = 0) then FileFormat := Content;
    end
    else if (ID = 'VIDEO_FORMAT') and (length(Video.Decoder) = 0) then Video.Decoder := Content
    else if (ID = 'VIDEO_CODEC') and (length(Video.Codec) = 0) then Video.Codec := Content
    else if (ID = 'AUDIO_FORMAT') and (length(Audio.Decoder) = 0) then Audio.Decoder := Content
    else if (ID = 'AUDIO_CODEC') and (length(Audio.Codec) = 0) then Audio.Codec := Content
    {else if (ID='LENGTH') AND (AsFloat>0.001) then begin
      AsFloat:=Frac(AsFloat);
      if (AsFloat>0.0009) then begin
        str(AsFloat:0:3, PlaybackTime);
        PlaybackTime:=WideString(SecondsToTime(AsInt)) + Copy(PlaybackTime,2,20);
      end
      else PlaybackTime:=WideString(SecondsToTime(AsInt));
    end}
    else if (Copy(ID, 1, 14) = 'CLIP_INFO_NAME') and (length(ID) = 15) then begin
      r := Ord(ID[15]) - Ord('0');
      if (r >= 0) and (r <= 9) then begin
        if length(Content) > 0 then Content[1] := WChar(Tnt_CharUpperW(PWChar(Content[1])));
        ClipInfo[r].Key := Content;
      end;
    end
    else if (Copy(ID, 1, 15) = 'CLIP_INFO_VALUE') and (length(ID) = 16) then begin
      r := Ord(ID[16]) - Ord('0');
      if (r >= 0) and (r <= 9) then ClipInfo[r].Value := Content;
    end;
  end;
end;

procedure ResetStreamInfo;
var i: integer;
begin
  with StreamInfo do begin
    FileName := '';
    FileFormat := '';
    PlaybackTime := '';
    with Video do begin
      Decoder := ''; Codec := '';
      Bitrate := 0; Width := 0; Height := 0; FPS := 0.0; Aspect := 0.0;
    end;
    with Audio do begin
      Decoder := ''; Codec := '';
      Bitrate := 0; Rate := 0; Channels := 0;
    end;
    for i := 0 to 9 do
      with ClipInfo[i] do begin
        Key := ''; Value := '';
      end;
  end;
end;

begin
  DecimalSeparator := '.'; Wadsp := false; GUI := false; HaveMsg := false; Uni := false;
  MFunc := 0; ETime := false; InSubDir := true; ML := false; Pri := true; HaveLyric := 0;
  DefaultOSDLevel := 1; OSDLevel := 1; Ch := 0; Fd := false; oneM := true; Wid := true;
  Deinterlace := 0; Aspect := 0; Postproc := 0; UpdatePW := false; IsDx:=false;
  AudioOut := 2; AudioDev := 0; Expand := 0; SPDIF := false; nmsg := true; Subcode := '';
  ReIndex := false; SoftVol := false; RFScr := false; ni := false; Dnav := true; Fol := 2;
  dbbuf := true; Dr := false; Volnorm := false; nfc := true; InterW := 4; InterH := 3;
  Params := ''; OnTop := 0; UpdateSkipBar := false; Async := false; AsyncV := '100';
  Status := sNone; Shuffle := false; Loop := false; OneLoop := false; VideoOut := 'Auto';
  Volume := 100; Mute := False; Duration := ''; MouseMode := 0; SubPos := Dsubpos; FSize := 4.5;
  Flip := false; Mirror := false; Yuy2 := false; Eq2 := false; LastEq2 := false; Rot := 0;
  Bp := 0; Ep := 0; FB := 2; MAspect := 'Default'; lavf := false; vsync := false;
  Cache := false; CacheV := '2048'; bri := 101; contr := 101; hu := 101; sat := 101; CP := 0;
  gam := 101; briD := 101; contrD := 101; huD := 101; satD := 101; gamD := 101; uof := false;
  Dda := false; LastDda := false; Utf := false; TextColor := $00FFFF; OutColor := 0;
  Ass := false; Efont := true; ISub := false; speed := 1; LastScale := 100; Scale := 100;
  LastHaveVideo := false; AutoNext := true; FilterDrop := false; dlod := true; ArcMovie:='';
  nobps := false; Ccap := 'Chapter'; Acap := 'Angle'; Tcap := 'Track'; CurPlay := -1; Status := sNone;
  LTextColor := clWindowText; LBGColor := clWindow; LHGColor := $93; ClientProcess := 0;
  ReadPipe := 0; WritePipe := 0; ExitCode := 0; UseUni := false; HaveVideo := false;
  NW := 0; NH := 0; SP := true; CT := true; fass := DefaultFass; HKS := DefaultHKS; seekLen := 10;
  lastP1 := ''; lastFN := ''; balance := 0; sconfig := false; Addsfiles := true; ADls:=true;
  dsEnd:=false; avThread:='1'; uav:=false; AutoDs:=True; LyricS := 10;
  bluray:=false; dvd:=false; vcd:=false; cd:=false; ResetStreamInfo;
end.

