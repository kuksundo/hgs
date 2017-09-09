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
unit Plist;

interface
{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, TntWindows, Messages, SysUtils, TntSysUtils, Variants, Graphics, TntGraphics,
  Forms, TntForms, StdCtrls, TntStdCtrls, Controls, ShellAPI, Math,
  Dialogs, TntDialogs, Buttons, TntButtons, Menus, TntMenus,
  ComCtrls, TntComCtrls, Classes, TntClasses, TntSystem, ExtCtrls,
  TntExtCtrls, TntFileCtrl;

const
  chsdetDll='uchardet.dll';

type
  TOpenDir = class(TThread)
    private
      Directory: Widestring; msg:boolean;
    protected
      procedure Execute; override;
  end;
  TPFF = class(TThread)
    protected
      procedure Execute; override;
  end;
type
  TPlaybackState = (psNotPlayed, psPlaying, psPlayed, psSkipped);
  TPlaylistEntry = record
    State: TPlaybackState;
    Selected: boolean;
    FullURL: widestring;
    DisplayURL: widestring;
  end;
  TLyricTimeCodeEntry = record
    timecode, LyricEntry: integer;
  end;

type TPlaylist = class
  private
    Data: array of TPlaylistEntry;
    function GetCount: integer;
    function GetItem(Index: integer): TPlaylistEntry;
    function GetSelected(Index: integer): boolean;
    procedure SetSelected(Index: integer; Value: boolean);
  public
    procedure Clear;
    procedure Add(const Entry: TPlaylistEntry);
    procedure AddFiles(const URL: widestring; msg:boolean);
    function AddM3U(const FileName: WideString; FileExtIndex: integer; msg:boolean): boolean;
    procedure AddDir(Directory: WideString; msg:boolean);
    procedure AddDirectory(Directory: WideString; msg:boolean);
    property Count: integer read GetCount;
    property Items[Index: integer]: TPlaylistEntry read GetItem; default;
    property Selected[Index: integer]: boolean read GetSelected write SetSelected;
    function GetNext(ExitState: TPlaybackState; Direction: integer): integer;
    procedure NowPlaying(Index: integer);
    procedure Changed;
    procedure MoveSelectedUp;
    procedure MoveSelectedDown;
    function FindItem(CheckStr, MovieName: widestring): integer;
    function FindPW(FileURL: widestring): string;
    procedure SetState(Index: integer; Value: TPlaybackState);
    procedure play;
  end;

type TLyric = class
  private
    IsParsed: boolean;
    LyricStringsA: TStringList; LyricStringsW: TTntStringList;
    procedure ParseLyricA(const FileName: WideString);
    procedure ParseLyricW(const FileName: WideString; mode: TTntStreamCharSet);
    procedure SortLyric;
    procedure Draw;
  public
    LyricTime: array of TLyricTimeCodeEntry;
    BitMap: TBitmap;
    ItemHeight, TY, dt:Integer;
    procedure ParseLyric(FileName: WideString);
    procedure GetCurrentLyric;
    procedure ClearLyric;
    procedure DownloadLyric;
    function GetLyricString(i:Integer):WideString;
    function GetMaxLyricString(i:Integer):WideString;
    constructor Create; overload;
    destructor Destroy; override;
  end;

type
  TWStringList = class;
  TMySortCompare = function(List: TWStringList; Index1, Index2: Integer): Int64;
  TWStringList = class(TTntStringList)
  public
    procedure SortStr(c:TMySortCompare);
    procedure LoadFile(const FileName: WideString; CharSet: TTntStreamCharSet);
  end;

type
  TPlaylistForm = class(TTntForm)
    PlaylistBox: TTntListBox;
    BPlay: TBitBtn;
    BAdd: TTntBitBtn;
    BMoveUp: TTntBitBtn;
    BMoveDown: TTntBitBtn;
    BDelete: TTntBitBtn;
    BSave: TTntBitBtn;
    SaveDialog: TTntSaveDialog;
    BAddDir: TTntBitBtn;
    CShuffle: TTntSpeedButton;
    CLoop: TTntSpeedButton;
    COneLoop: TTntSpeedButton;
    BClear: TTntBitBtn;
    TntPageControl1: TTntPageControl;
    TntTabSheet1: TTntTabSheet;
    TntTabSheet2: TTntTabSheet;
    TntCP: TTntPopupMenu;
    CP0: TTntMenuItem;
    CPO: TTntMenuItem;
    SC: TTntMenuItem;
    TC: TTntMenuItem;
    AR: TTntMenuItem;
    TU: TTntMenuItem;
    HE: TTntMenuItem;
    JA: TTntMenuItem;
    KO: TTntMenuItem;
    TH: TTntMenuItem;
    FR: TTntMenuItem;
    IC: TTntMenuItem;
    PO: TTntMenuItem;
    KO2: TTntMenuItem;
    GR0: TTntMenuItem;
    TU2: TTntMenuItem;
    GR1: TTntMenuItem;
    BA: TTntMenuItem;
    CY: TTntMenuItem;
    Ar0: TTntMenuItem;
    Ar1: TTntMenuItem;
    Ar2: TTntMenuItem;
    Ar3: TTntMenuItem;
    Ar4: TTntMenuItem;
    Ar5: TTntMenuItem;
    Ar6: TTntMenuItem;
    Ba0: TTntMenuItem;
    Ba1: TTntMenuItem;
    Ba2: TTntMenuItem;
    CE: TTntMenuItem;
    Ce0: TTntMenuItem;
    Ce1: TTntMenuItem;
    Ce2: TTntMenuItem;
    Ce3: TTntMenuItem;
    sc0: TTntMenuItem;
    sc1: TTntMenuItem;
    sc2: TTntMenuItem;
    sc3: TTntMenuItem;
    sc4: TTntMenuItem;
    tc0: TTntMenuItem;
    tc1: TTntMenuItem;
    sc5: TTntMenuItem;
    tc2: TTntMenuItem;
    tc3: TTntMenuItem;
    tc4: TTntMenuItem;
    tc5: TTntMenuItem;
    tc6: TTntMenuItem;
    CA1: TTntMenuItem;
    tc8: TTntMenuItem;
    cy0: TTntMenuItem;
    cy1: TTntMenuItem;
    cy2: TTntMenuItem;
    cy3: TTntMenuItem;
    cy4: TTntMenuItem;
    cy5: TTntMenuItem;
    cy6: TTntMenuItem;
    cy7: TTntMenuItem;
    Gr: TTntMenuItem;
    gr2: TTntMenuItem;
    gr3: TTntMenuItem;
    gr4: TTntMenuItem;
    he0: TTntMenuItem;
    he1: TTntMenuItem;
    he2: TTntMenuItem;
    he4: TTntMenuItem;
    he3: TTntMenuItem;
    he5: TTntMenuItem;
    jp0: TTntMenuItem;
    jp1: TTntMenuItem;
    jp2: TTntMenuItem;
    jp3: TTntMenuItem;
    jp4: TTntMenuItem;
    jp5: TTntMenuItem;
    jp6: TTntMenuItem;
    jp7: TTntMenuItem;
    ko0: TTntMenuItem;
    ko1: TTntMenuItem;
    ko3: TTntMenuItem;
    ko4: TTntMenuItem;
    ko5: TTntMenuItem;
    ko6: TTntMenuItem;
    lt0: TTntMenuItem;
    th0: TTntMenuItem;
    th1: TTntMenuItem;
    th2: TTntMenuItem;
    tu0: TTntMenuItem;
    tu1: TTntMenuItem;
    tu3: TTntMenuItem;
    tu4: TTntMenuItem;
    vi: TTntMenuItem;
    we: TTntMenuItem;
    fr0: TTntMenuItem;
    fr1: TTntMenuItem;
    fr2: TTntMenuItem;
    ic0: TTntMenuItem;
    ic1: TTntMenuItem;
    ic2: TTntMenuItem;
    gr5: TTntMenuItem;
    jp8: TTntMenuItem;
    iso0: TTntMenuItem;
    iso9: TTntMenuItem;
    iso15: TTntMenuItem;
    gr6: TTntMenuItem;
    he6: TTntMenuItem;
    RO: TTntMenuItem;
    RM: TTntMenuItem;
    CO: TTntMenuItem;
    I18: TTntMenuItem;
    DV: TTntMenuItem;
    BE: TTntMenuItem;
    TA: TTntMenuItem;
    TE: TTntMenuItem;
    AM: TTntMenuItem;
    OY: TTntMenuItem;
    KA: TTntMenuItem;
    MA: TTntMenuItem;
    ISCII1: TTntMenuItem;
    GU: TTntMenuItem;
    PG: TTntMenuItem;
    ND: TTntMenuItem;
    CLyricF: TComboBox;
    CLyricS: TComboBox;
    PLTC: TTntPanel;
    PLHC: TTntPanel;
    PLBC: TTntPanel;
    MGB: TTntMenuItem;
    MG2B: TTntMenuItem;
    MB2G: TTntMenuItem;
    N1: TTntMenuItem;
    BG: TTntMenuItem;
    N2: TTntMenuItem;
    MLoadLyric: TTntMenuItem;
    MDownloadLyric: TTntMenuItem;
    TMLyric: TPaintBox;
    CPA: TTntMenuItem;
    dLyric: TTntBitBtn;
    dlyric1: TTntBitBtn;
    procedure BAddDirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure PlaylistBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure BPlayClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BMoveClick(Sender: TObject);
    procedure CShuffleClick(Sender: TObject);
    procedure CLoopClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure COneLoopClick(Sender: TObject);
    procedure BClearClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure TntCPClick(Sender: TObject);
    procedure CLyricFChange(Sender: TObject);
    procedure CLyricSChange(Sender: TObject);
    procedure PLTCClick(Sender: TObject);
    procedure PLHCClick(Sender: TObject);
    procedure PLBCClick(Sender: TObject);
    procedure MDownloadLyricClick(Sender: TObject);
    procedure MLoadLyricClick(Sender: TObject);
    procedure TMLyricPaint(Sender: TObject);
    
  private
    { Private declarations }
    BMPpsPlaying, BMPpsPlayed, BMPpsSkipped: TBitmap;
    procedure FormDropFiles(var msg: TMessage); message WM_DROPFILES;
    procedure FormMove(var msg: TMessage); message WM_MOVE;
  public
    { Public declarations }
    ControlledMove: boolean;
  end;

var
  PlaylistForm: TPlaylistForm;
  Playlist: TPlaylist;
  Lyric: TLyric;
  LDocked, RDocked, TDocked, BDocked: boolean;
  LL, TT: integer;
  IsCLoaded:THandle = 0;
  GuessStrChardet  : function(str,nameBuf:PChar):PChar; stdcall;

procedure addEpisode(s: widestring);
function mysort(s: TWStringList; P1, P2: Integer): Int64;
procedure LoadCLibrary;
procedure UnLoadCLibrary;
function isNum(n: WChar): boolean; 
function Big52Gb(str: string): string;
function Gb2Big5(str: string): string;

implementation

uses Main, Core, Locale, Options,
     DLyric, GDILyrics, LyricShow;

{$R *.dfm}
{$R plist_img.res}

procedure LoadCLibrary;
begin
  if IsCLoaded <> 0 then exit;
  IsCLoaded := Tnt_LoadLibraryW(chsdetDll);
  if IsCLoaded <> 0 then begin
    @GuessStrChardet  := GetProcAddress(IsCLoaded, 'GuessStrChardet');
  end;
end;

procedure UnLoadCLibrary;
begin
  if IsCLoaded <> 0 then begin
    FreeLibrary(IsCLoaded);
    IsCLoaded := 0;
    GuessStrChardet  :=nil;
  end;
end;

procedure TWStringList.SortStr(c:TMySortCompare);
var i, j: integer;
begin
  for i := 0 to Count - 2 do begin
    for j := 1 to Count - i -1 do begin
      if c(self,j,j-1)<0 then
        Exchange(j - 1,j);
    end;
  end;
end;

procedure TWStringList.LoadFile(const FileName: WideString; CharSet: TTntStreamCharSet);
var Stream: TStream; DataLeft: Integer; SW: WideString; SA: AnsiString;
begin
  Stream := TTntFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Stream.Position := 0;
    BeginUpdate;
    try
      DataLeft := Stream.Size - Stream.Position;
      if (CharSet in [csUnicode, csUnicodeSwapped]) then begin
        if DataLeft < SizeOf(WideChar) then SW := ''
        else begin
          SetLength(SW, DataLeft div SizeOf(WideChar));
          Stream.Read(PWideChar(SW)^, DataLeft);
          if CharSet = csUnicodeSwapped then
            StrSwapByteOrder(PWideChar(SW));
          SetTextStr(SW);
        end;
      end
      else begin
        SetLength(SA, DataLeft div SizeOf(AnsiChar));
        Stream.Read(PAnsiChar(SA)^, DataLeft);
        if CharSet = csUtf8 then SetTextStr(UTF8Decode(SA))
        else SetTextStr(SA);
      end;
    finally
      EndUpdate;
    end;
  finally
    Stream.Free;
  end;
end;

function LoadBitmapResource(const ResName: string; Transparent: boolean): TBitmap;
begin
  Result := TBitmap.Create;
  Result.LoadFromResourceName(HInstance, ResName);
  if Transparent then begin
    Result.Transparent := true;
    Result.TransparentMode := tmAuto;
  end;
end;

procedure TPlaylist.Clear;
begin
  SetLength(Data, 0); CurPlay := -1; 
end;

procedure TLyric.ClearLyric;
begin
  if length(LyricTime) > 0 then begin
    SetLength(LyricTime, 0);
    if Assigned(LyricShowForm) then GDILyric.DisplayLyricD('','');
    case HaveLyric of
      1: if LyricStringsW <> nil then LyricStringsW.Free;
      2: if LyricStringsA <> nil then LyricStringsA.Free;
    end;
  end;
  HaveLyric := 0; PlaylistForm.CPA.Tag:=0;
  PlaylistForm.TMLyricPaint(nil);
  if dlod then LyricShowForm.Hide;
end;


procedure TPlaylist.Play;
begin
  MainForm.UpdateParams;
  Playlist.NowPlaying(0); CurPlay := 0;
  MainForm.DoOpen(Playlist[0].FullURL, Playlist[0].DisplayURL);
end;

procedure TPFF.Execute;
begin
  Synchronize(Playlist.play)
end;

procedure TPlaylist.Add(const Entry: TPlaylistEntry);
var len: integer; t:TPFF;
begin
  if PClear then Clear;
  len := length(Data);
  SetLength(Data, len + 1);
  Data[len] := Entry;
  if PlaylistForm.Visible then begin
    PlaylistForm.PlaylistBox.Count := Count;
    PlaylistForm.PlaylistBox.Repaint;
  end;
  if PClear then begin
    PClear := false;
    if GetCurrentThreadId = MainThreadId then play
    else begin
      t:=TPFF.Create(True);
      t.FreeOnTerminate:=True;
      t.Priority := tpTimeCritical;
      t.Resume;
      SwitchToThread;;
    end;
  end;
end;

procedure TPlaylist.AddFiles(const URL: widestring; msg:boolean);
var PlistEntry: TPlaylistEntry; j: WideString; i,a: integer;
begin
  // check for .m3u .pls .asx .wpl .xspf playlist file
  j := Tnt_WideLowerCase(WideExtractFileExt(URL));
  i := CheckInfo(PlaylistType, j);
  if (i > -1) and AddM3U(URL, i, msg) then exit;
  // no playlist -> check for Arc file
  a:= CheckInfo(MediaType, j);
  if (a > -1) and (a <= ZipTypeCount) then begin
    if IsLoaded(j) then AddMovies(URL, FindPW(URL), true, msg);
    exit;
  end;
  // no playlist and Arc file-> enter directly
  if (Pos('://', URL) > 1) or WideFileExists(URL) then begin
    with PlistEntry do begin
      State := psNotPlayed;
      FullURL := URL;
      if Pos('://', URL) > 1 then // why this? well, the above two lines read like the regexp
        DisplayURL := URL // /.{1,5}p:/,which matches http:, ftp:, rtp: and so on ...
      else
        DisplayURL := WideExtractFileName(URL);
    end;
    Add(PlistEntry);
    if msg then PlayMsgAt := GetTickCount() + 500;
  end;
end;

procedure TOpenDir.Execute;
begin
  EndOpenDir:=false;
  Playlist.AddDir(Directory,msg);
  Synchronize(Playlist.Changed);
end;

procedure TPlaylist.AddDirectory(Directory: Widestring; msg:boolean);
var t:TOpenDir;
begin
  t:=TOpenDir.Create(True);
  t.FreeOnTerminate:=True;
  t.Directory:=Directory; t.msg:=msg;
  t.Priority := tpTimeCritical;
  t.Resume;
  SwitchToThread;
  
   // main thread
  //EndOpenDir:=false;
  //AddDir(Directory,msg);
end;

procedure TPlaylist.AddDir(Directory: Widestring; msg:boolean);
var SR: TSearchRecW; Entry: TPlaylistEntry; a,s,d:WideString;
    FList:TWStringList; i:integer;
begin
  Directory := WideIncludeTrailingPathDelimiter(WideExpandUNCFileName(Directory));

  // check for DVD directory
  if WideDirectoryExists(Directory + 'VIDEO_TS') then begin
   // Directory:=WideExcludeTrailingPathDelimiter(Directory);
    with Entry do begin
      State := psNotPlayed; 
     	s:=' -dvd-device '; a:='DVD-1 <-- '; d:=' dvd';
      if (Pos(#32, Directory) > 0) or (not IsWideStringMappableToAnsi(Directory)) then
        FullURL := s + WideExtractShortPathName(Directory) + d
      else
        FullURL := s + Directory + d;
      DisplayURL := a + Directory;
    end;
    if not EndOpenDir then begin
      Add(Entry);
      if msg then PlayMsgAt := GetTickCount() + 500;
    end;
    exit;
  end;
  // check for BlueRay directory
  if WideDirectoryExists(Directory + 'BDMV') then begin
    //Directory:=WideExcludeTrailingPathDelimiter(Directory);
    with Entry do begin
      State := psNotPlayed;
     	s:=' -bluray-device '; a:='BlueRay-1 <-- '; d:=' br';
      if (Pos(#32, Directory) > 0) or (not IsWideStringMappableToAnsi(Directory)) then
        FullURL := s + WideExtractShortPathName(Directory) + d
      else
        FullURL := s + Directory + d;
      DisplayURL := a + Directory;
    end;
    if not EndOpenDir then begin
      Add(Entry);
      if msg then PlayMsgAt := GetTickCount() + 500;
    end;
    exit;
  end;
  // check for CD directory
  if WideFileExists(Directory + 'Track01.cda') then begin
    Directory:=WideExcludeTrailingPathDelimiter(Directory);
    with Entry do begin
      State := psNotPlayed;
     	s:=' -cdrom-device '; a:='CD <-- '; d:=' cdda://';
      if (Pos(#32, Directory) > 0) or (not IsWideStringMappableToAnsi(Directory)) then
        FullURL := s + WideExtractShortPathName(Directory) + d
      else
        FullURL := s + Directory + d;
      DisplayURL := a + Directory;
    end;
    if not EndOpenDir then begin
      Add(Entry);
      if msg then PlayMsgAt := GetTickCount() + 500;
    end;
    exit;
  end;

{  if WideDirectoryExists(Directory + 'MPEGAV') or WideDirectoryExists(Directory + 'MPEG2') then begin
    Directory:=WideExcludeTrailingPathDelimiter(Directory);
    with Entry do begin
      State := psNotPlayed;
      if IsWideStringMappableToAnsi(Directory) then
        FullURL := ' -cdrom-device ' + EscapeParam(Directory) + ' vcd://'
      else
        FullURL := ' -cdrom-device ' + EscapeParam(WideExtractShortPathName(Directory)) + ' vcd://';
      DisplayURL := 'VCD <-- ' + Directory;
    end;
    if not EndOpenDir then Add(Entry);
    exit;
  end;}

  // no CD ->is it a (S)VCD directory?
  if WideDirectoryExists(Directory + 'MPEGAV') then Directory := Directory + 'MPEGAV\'
  else if WideDirectoryExists(Directory + 'MPEG2') then Directory := Directory + 'MPEG2\';

  // no (S)VCD -> search the directory recursively
  if WideFindFirst(Directory + '*.*', faAnyFile, SR) = 0 then begin
    FList:=TWStringList.Create;
    repeat
      if SR.Name[1] <> '.' then begin // exclude . or .. Directory
        if (not EndOpenDir) and ((SR.Attr and faDirectory) <> 0) then AddDir(Directory + SR.Name,msg)
        else if (not EndOpenDir) and (CheckInfo(MediaType, Tnt_WideLowerCase(WideExtractFileExt(SR.Name))) > -1) then
          FList.Add(SR.Name);
      end;
    until  EndOpenDir or (WideFindNext(SR) <> 0);
    WideFindClose(SR);
    FList.SortStr(mysort);
    for i:=0 to FList.Count-1 do begin
      if not EndOpenDir then AddFiles(Directory + FList[i],msg);
    end;
    FList.Free;
    exit;
  end;

  // directory is empty, or no filesystem -> try use TrackMode to access directory
  Directory:=WideExcludeTrailingPathDelimiter(Directory);
  with Entry do begin
    State := psNotPlayed;
    s:=' -cdrom-device '; a:='VCD <-- '; d:=' vcd://';
    if (Pos(#32, Directory) > 0) or (not IsWideStringMappableToAnsi(Directory)) then
      FullURL := s + WideExtractShortPathName(Directory) + d
    else
      FullURL := s + Directory + d;
    DisplayURL := a + Directory;
  end;
  if not EndOpenDir then begin
    Add(Entry);
    if msg then PlayMsgAt := GetTickCount() + 500;
  end;
end;

function TPlaylist.GetCount: integer;
begin
  Result := length(Data);
end;

function TPlaylist.GetItem(Index: integer): TPlaylistEntry;
begin
  if (Index < Low(Data)) or (Index > High(Data))
    then raise ERangeError.Create('invalid playlist item')
  else Result := Data[Index];
end;

procedure TPlaylist.SetState(Index: integer; Value: TPlaybackState);
begin
  if (Index < Low(Data)) or (Index > High(Data))
    then exit
  else Data[Index].State := Value;
end;

function TPlaylist.GetSelected(Index: integer): boolean;
begin
  if (Index < Low(Data)) or (Index > High(Data))
    then raise ERangeError.Create('invalid playlist item')
  else Result := Data[Index].Selected;
end;

procedure TPlaylist.SetSelected(Index: integer; Value: boolean);
begin
  if (Index < Low(Data)) or (Index > High(Data))
    then raise ERangeError.Create('invalid playlist item')
  else Data[Index].Selected := Value;
end;

function TPlaylist.FindItem(CheckStr, MovieName: widestring): integer;
var i, j,a: integer; k: widestring;
begin
  Result := -1;
  if Count < 1 then exit;
  i := Pos(CheckStr, MovieName);
  if i > 0 then MovieName := copy(MovieName, 1, i - 1);
  for j := High(Data) downto Low(Data) do begin
    k := Data[j].DisplayURL;
    if i>0 then begin
      a := Pos(CheckStr, Data[j].DisplayURL);
      if a > 0 then k := copy(k, 1, a - 1)
      else continue;
    end;
    if MovieName = k then begin
      Result := j;
      exit;
    end;
  end;
end;

function TPlaylist.FindPW(FileURL: widestring): string;
var a,i,h,c: integer; s,w: WideString;
begin
  Result := '';
  if Count < 1 then exit;
  FileURL := Tnt_WideLowerCase(FileURL);
  a := Pos('.part', FileURL);
  if a > 0 then begin w := copy(FileURL, 1, a - 1); c:=1; end
  else begin
    a := Pos('.zip.', FileURL);
    if a > 0 then begin w := copy(FileURL, 1, a - 1); c:=2; end
    else begin
      a := Pos('.7z.', FileURL);
      if a > 0 then begin w := copy(FileURL, 1, a - 1); c:=3; end
      else begin w:= FileURL; c:=0; end;
    end;
  end;

  for i := High(Data) downto Low(Data) do begin
    h := Pos(':', Data[i].DisplayURL);
    if h > 0 then begin
      s := Tnt_WideLowerCase(Data[i].FullURL);
      case c of
        1: begin
             a := Pos('.part', s);
             if a > 0 then s := copy(s, 1, a - 1)
             else continue;
           end;
        2: begin
             a := Pos('.zip.', s);
             if a > 0 then s := copy(s, 1, a - 1)
             else continue;
           end;
        3: begin
             a := Pos('.7z', s);
             if a > 0 then s := copy(s, 1, a - 1)
             else continue;
           end;
      end;
      if s = w then begin
        Result := copy(Data[i].DisplayURL, h + 1, MaxInt);
        exit;
      end;
    end;
  end;
end;

function TPlaylist.GetNext(ExitState: TPlaybackState; Direction: integer): integer;
var i, UPCount: integer;
begin
  if Count = 0 then begin Result := -1; CurPlay := -1; exit; end
  else Result := CurPlay;

  if Result < 0 then Result := 0
  else if Result < Count then Data[Result].State := ExitState; // mark State of current track
  if (OneLoop and AutoNext) or (Direction=0) then exit;
  AutoNext := true;
  if Shuffle and (not OneLoop) then begin // ***** SHUFFLE MODE *****
    // unplayed tracks left?
    UPCount := 0;
    for i := 0 to Count - 1 do
      if Data[i].State = psNotPlayed then inc(UPCount);

    if UPCount = 0 then begin
      if Count > 1 then begin
        repeat Result := Random(Count);
        until Result <> CurPlay;
      end
      else if not Loop then Result := -1;
    end
    else begin
      repeat Result := Random(Count);
      until Data[Result].State = psNotPlayed;
    end;
  end
  else begin // ***** NORMAL MODE *****
    inc(Result, Direction);
    if (Result < 0) or (Result > Count - 1) then begin
      if Loop and (not OneLoop) then Result := (Result + Count) mod Count
      else Result := -1;
    end;
  end;
  if PlaylistForm.Visible then PlaylistForm.PlaylistBox.Invalidate;

  MainForm.BPrev.Enabled := (Result > 0);
  if Result < 0 then MainForm.BNext.Enabled := (1 < Playlist.Count)
  else MainForm.BNext.Enabled := (Result + 1 < Playlist.Count);
  CurPlay := Result;
end;

procedure TPlaylist.NowPlaying(Index: integer);
begin
  if (Index < Low(Data)) or (Index > High(Data)) then exit;
  Data[Index].State := psPlaying;
  if PlaylistForm.Visible then PlaylistForm.PlaylistBox.Invalidate;
  PlaylistForm.PlaylistBox.ItemIndex := Index;
end;

procedure TPlaylist.Changed;
begin
  if PlaylistForm.Visible then begin
    PlaylistForm.PlaylistBox.Count := Count;
    PlaylistForm.PlaylistBox.Repaint;
  end;
  if (Count = 0) and (not Running) then MainForm.BPlay.Enabled := false;
  //if CurPlay<0 then CurPlay:=0;
  MainForm.BPrev.Enabled := (CurPlay > 0);
  if CurPlay < 0 then MainForm.BNext.Enabled := (1 < Playlist.Count)
  else MainForm.BNext.Enabled := (CurPlay + 1 < Playlist.Count);
end;

procedure TPlaylist.MoveSelectedUp;
var i: integer; temp: TPlaylistEntry;
begin
  for i := 1 to High(Data) do
    if Data[i].Selected and not (Data[i - 1].Selected) then begin
      if Data[i].State = psPlaying then dec(CurPlay);
      temp := Data[i];
      Data[i] := Data[i - 1];
      Data[i - 1] := temp;
    end;
  Changed;
end;

procedure TPlaylist.MoveSelectedDown;
var i: integer; temp: TPlaylistEntry;
begin
  for i := (High(Data) - 1) downto 0 do
    if Data[i].Selected and not (Data[i + 1].Selected) then begin
      if Data[i].State = psPlaying then inc(CurPlay);
      temp := Data[i];
      Data[i] := Data[i + 1];
      Data[i + 1] := temp;
    end;
  Changed;
end;

function TPlaylist.AddM3U(const FileName: WideString; FileExtIndex: integer; msg:boolean): boolean;
var BasePath, s: WideString;
  procedure AddToPls(str: WideString);
  begin
    if WideDirectoryExists(str) then AddDirectory(str,msg)
    else begin
      str := ExpandName(BasePath, str);
      if (Pos('://', str) > 1) or WideFileExists(str) then AddFiles(str,msg)
      else exit;
    end;
    Result := true;
  end;
  procedure HandleStr(const b, e: WideString);
  var r: integer;
  begin
    r := pos(b, s);
    while r > 0 do begin
      s := copy(s, r + length(b), MaxInt);
      r := pos(b, s);
      if e <> '' then AddToPls(copy(s, 1, pos(e, s) - 1))
      else begin
        if r > 0 then AddToPls(copy(s, 1, r - 1))
        else AddToPls(s);
      end;
    end;
  end;
  procedure parseFile(mode: TTntStreamCharSet);
  var FileNameList: TWStringList; i: integer;
  begin
    if Result then exit;
    FileNameList := TWStringList.Create;
    FileNameList.LoadFile(FileName, mode);
    if FileNameList.Count > 0 then begin
      for i := 0 to FileNameList.Count - 1 do begin
        s := Trim(FileNameList[i]);
        if length(s) < 1 then continue;
        case FileExtIndex of
      {m3u} 0: if s[1] <> '#' then AddToPls(s);
      {asx} 1: HandleStr('<Param Name = "SourceURL" Value = "', '"');
      {wpl} 2: HandleStr('<media src="', '"');
      {pls} 3: if s[1] = 'F' then AddToPls(copy(s, pos('=', s) + 1, MaxInt));
     {ttpl} 4: HandleStr('<item file="', '"');
      {rmp} 5: HandleStr('<FILENAME>', '</FILENAME>');
     {xspf} 6: HandleStr('<location>', '</location>');
     {smpl} 7: HandleStr('path="', '"/>');
     {m3u8} 8: if s[1] <> '#' then AddToPls(s);
    {mpcpl} 9: HandleStr('filename,', '');
        end;
      end;
    end;
    FileNameList.Free;
  end;
begin
  Result := false;
  BasePath := WideIncludeTrailingPathDelimiter(WideExtractFilePath(FileName));
  parseFile(csUtf8);
  parseFile(csUnicode);
  parseFile(csUnicodeSwapped);
  parseFile(csAnsi);
end;

procedure TLyric.ParseLyric(FileName: WideString);
begin
  if not IsWideStringMappableToAnsi(FileName) then
    FileName:=WideExtractShortPathName(FileName);
  Isparsed := false;
  ParseLyricW(FileName, csUtf8);
  ParseLyricW(FileName, csUnicode);
  ParseLyricW(FileName, csUnicodeSwapped);
  ParseLyricA(FileName);
end;

procedure TLyric.ParseLyricA(const FileName: WideString);
var s: string; TimeEntry: TLyricTimeCodeEntry;
  lc, rc, lo, ro, offset, mins, secs, ms, len, Lyricindex, sMaxLen, i, j: integer;
  First: boolean; a: TStringList; NoTag: boolean;
begin
  if IsParsed then exit;
  a := TStringList.Create;
  a.LoadFromFile(FileName);
  if a.Count < 1 then begin a.Free; exit; end;
  Lyricindex := 0; offset := 0; len := -1; sMaxLen := 0; First := true;
  for j := 0 to a.Count - 1 do begin
    s := Trim(a[j]);
    if length(s) < 6 then continue;
    NoTag := true;
    repeat
      lc := pos('[', s); rc := pos(']', s);
      if (lc < 1) or (rc < lc + 2) then break;
      lo := pos(':', s);
      if (lo>0) and (lo<lc) then break;
      if lo>rc then lo:=0;
      if Lyricindex = 0 then begin
        ro := pos('offset', LowerCase(s));
        if ro > lc then begin
          if lo > ro then offset := StrToIntDef(StringReplace(copy(s, lo + 1, rc - lo - 1), #32, '', [rfReplaceAll]), 0);
          break;
        end;
      end;
      ro := pos('.', s);
      if (ro > lc) and (ro < lo) then break;
      if ro>rc then ro:=0;
      if lo>0 then mins := StrToIntDef(StringReplace(copy(s, lc + 1, lo - lc - 1), #32, '', [rfReplaceAll]), -1)
      else mins:=0;
      if (mins < 0) or (mins > 59) then break;
      ms := offset;
      if ro > lc then begin
        if lo>lc then secs := StrToIntDef(StringReplace(copy(s, lo + 1, ro - lo - 1), #32, '', [rfReplaceAll]), -1)
        else secs := StrToIntDef(StringReplace(copy(s, lc + 1, ro - lc - 1), #32, '', [rfReplaceAll]), -1);
        ms := ms + StrToIntDef(StringReplace(copy(s, ro + 1, rc -ro -1), #32, '', [rfReplaceAll]), 0) * 10;
      end
      else begin
        if lo>lc then  secs := StrToIntDef(StringReplace(copy(s, lo + 1, rc - lo - 1), #32, '', [rfReplaceAll]), -1)
        else secs := StrToIntDef(StringReplace(copy(s, lc + 1, rc - lc - 1), #32, '', [rfReplaceAll]), -1);
      end;
      if (secs < 0) or (secs > 59) then break;
      ms := ms + (mins * 60 + secs) * 1000;
      if ms < 0 then break;
      if First then begin
        First := false; ClearLyric;
        LyricStringsA := TStringList.Create;
      end;
      NoTag := false;
      TimeEntry.timecode := ms div 100;
      TimeEntry.LyricEntry := Lyricindex;
      len := length(LyricTime);
      SetLength(LyricTime, len + 1);
      LyricTime[len] := TimeEntry;
      s := copy(s, rc + 1, length(s));
    until false;
    if NoTag or (LyricStringsA = nil) then continue;
    s := Trim(s);
    LyricStringsA.Add(s);
    i := WideCanvasTextWidth(BitMap.Canvas, s);
    if i > sMaxLen then begin
      sMaxLen := i; MaxLenLyric := Lyricindex;
    end;
    inc(Lyricindex);
  end;
  a.Free;
  if len = -1 then exit;
  LyricCount := len;
  SortLyric; TY:=0;
  
  if PlaylistForm.CPA.Visible then begin
    LoadCLibrary;
    if IsCLoaded <> 0 then begin
      setLength(s,129);
      GuessStrChardet(LyricStringsA.GetText,PChar(s));
      i:= Pos(' ',s);
      if i<>0 then begin
        CP:=StrToIntDef(Copy(s,i,MaxInt),CP); PlaylistForm.CPA.Tag:=CP;
        s:=Copy(s,0,i-1);
        i:= Pos('(', PlaylistForm.CPA.Caption);
        if i>1 then
          PlaylistForm.CPA.Caption := Copy(PlaylistForm.CPA.Caption, 1, i-2) + ' ('+ s +')'
        else PlaylistForm.CPA.Caption :=PlaylistForm.CPA.Caption + ' ('+ s +')';
        PlaylistForm.TntCPClick(PlaylistForm.CPA);
      end;
    end;
  end;

  HaveLyric := 2; LyricURL := FileName; IsParsed := true;
  if dlod then begin
    GDILyric.SetFont(BitMap.Canvas.Font.Name);
    LyricShowForm.Show;
  end;
  with PlaylistForm do begin
    UpdatePW := True;
    if Visible then TMLyricPaint(nil)
    else if not dlod then begin
      TntPageControl1.TabIndex := 1;
      Show;
    end;
  end;
end;

procedure TLyric.ParseLyricW(const FileName: WideString; mode: TTntStreamCharSet);
var s: WideString; TimeEntry: TLyricTimeCodeEntry;
  lc, rc, lo, ro, offset, mins, secs, ms, len, Lyricindex, sMaxLen, i, j: integer;
  First: boolean; a: TWStringList; NoTag: boolean;
begin
  if IsParsed then Exit;
  a := TWStringList.Create;
  a.LoadFile(FileName, mode);
  if a.Count < 1 then begin a.Free; exit; end;
  Lyricindex := 0; offset := 0; len := -1; sMaxLen := 0; First := true;
  for j := 0 to a.Count - 1 do begin
    s := Trim(a[j]);
    if length(s) < 6 then continue;
    NoTag := true;
    repeat
      lc := pos('[', s); rc := pos(']', s);
      if (lc < 1) or (rc < lc + 2) then break;
      lo := pos(':', s);
      if (lo>0) and (lo<lc) then break;
      if lo>rc then lo:=0;
      if Lyricindex = 0 then begin
        ro := pos('offset', LowerCase(s));
        if ro > lc then begin
          if lo > ro then offset := StrToIntDef(StringReplace(copy(s, lo + 1, rc - lo - 1), #32, '', [rfReplaceAll]), 0);
          break;
        end;
      end;
      ro := pos('.', s);
      if (ro > lc) and (ro < lo) then break;
      if ro>rc then ro:=0;
      if lo>0 then mins := StrToIntDef(StringReplace(copy(s, lc + 1, lo - lc - 1), #32, '', [rfReplaceAll]), -1)
      else mins:=0;
      if (mins < 0) or (mins > 59) then break;
      ms := offset;
      if ro > lc then begin
        if lo>lc then secs := StrToIntDef(StringReplace(copy(s, lo + 1, ro - lo - 1), #32, '', [rfReplaceAll]), -1)
        else secs := StrToIntDef(StringReplace(copy(s, lc + 1, ro - lc - 1), #32, '', [rfReplaceAll]), -1);
        ms := ms + StrToIntDef(StringReplace(copy(s, ro + 1, rc -ro -1), #32, '', [rfReplaceAll]), 0) * 10;
      end
      else begin
        if lo>lc then  secs := StrToIntDef(StringReplace(copy(s, lo + 1, rc - lo - 1), #32, '', [rfReplaceAll]), -1)
        else secs := StrToIntDef(StringReplace(copy(s, lc + 1, rc - lc - 1), #32, '', [rfReplaceAll]), -1);
      end;
      if (secs < 0) or (secs > 59) then break;
      ms := ms + (mins * 60 + secs) * 1000;
      if ms < 0 then break;
      if First then begin
        First := false; ClearLyric;
        LyricStringsW := TTntStringList.Create;
      end;
      NoTag := false;
      TimeEntry.timecode := ms div 100;
      TimeEntry.LyricEntry := Lyricindex;
      len := length(LyricTime);
      SetLength(LyricTime, len + 1);
      LyricTime[len] := TimeEntry;
      s := copy(s, rc + 1, length(s));
    until false;
    if NoTag or (LyricStringsW = nil) then continue;
    s := Trim(s);
    LyricStringsW.Add(s);
    i := WideCanvasTextWidth(BitMap.Canvas, s);
    if i > sMaxLen then begin
      sMaxLen := i; MaxLenLyric := Lyricindex;
    end;
    inc(Lyricindex);
  end;
  a.Free;
  if len = -1 then exit;
  LyricCount := len;
  SortLyric; TY:=0;
  if PlaylistForm.CPA.Visible then begin
      case mode of
        csUtf8: s:='UTF-8 65001';
        csUnicode: s:='UTF-16LE 1200';
        csUnicodeSwapped: s:='UTF-16BE 1201';
      end;
      i:= Pos(' ',s);
      if i<>0 then begin
        CP:=StrToIntDef(Copy(s,i,MaxInt),CP); PlaylistForm.CPA.Tag:=CP;
        s:=Copy(s,0,i-1);
        i:= Pos('(', PlaylistForm.CPA.Caption);
        if i>1 then
          PlaylistForm.CPA.Caption := Copy(PlaylistForm.CPA.Caption, 1, i-2) + ' ('+ s +')'
        else PlaylistForm.CPA.Caption :=PlaylistForm.CPA.Caption + ' ('+ s +')';
        PlaylistForm.TntCPClick(PlaylistForm.CPA);
      end;
    end;

  HaveLyric := 1; LyricURL := FileName; IsParsed := true;
  if dlod then begin
    GDILyric.SetFont(BitMap.Canvas.Font.Name);
    LyricShowForm.Show;
  end;
  with PlaylistForm do begin
    UpdatePW := True;
    if Visible then PlaylistForm.TMLyricPaint(nil)
    else if not dlod then begin
      TntPageControl1.TabIndex := 1;
      Show;
    end;
  end;
end;

procedure TLyric.SortLyric;
var i, j: integer; TmpEntry: TLyricTimeCodeEntry;
begin
  for i := 0 to LyricCount - 1 do begin
    for j := 1 to LyricCount - i do begin
      if LyricTime[j].timecode < LyricTime[j - 1].timecode then begin
        TmpEntry := LyricTime[j - 1]; LyricTime[j - 1] := LyricTime[j];
        LyricTime[j] := TmpEntry;
      end;
    end;
  end;
end;

procedure TLyric.GetCurrentLyric;
var l,h, m, mv,d: integer;
begin
  if MSecPos < LyricTime[0].timecode then begin
    if CurLyric <> 0 then begin
      CurLyric := 0; NextLyric := 0;
      TY := 0; dt:=0;
      if dlod then begin
        if LyricCount=0 then GDILyric.DisplayLyricD(GetLyricString(0),'')
        else GDILyric.DisplayLyricD(GetLyricString(0),GetLyricString(1));
      end;
    end;
    exit;
  end;
  if MSecPos > LyricTime[LyricCount].timecode then begin
    if CurLyric <> LyricCount then begin
      CurLyric := LyricCount; NextLyric := LyricCount;
      TY:=-CurLyric*ItemHeight;  dt:=0;

      if dlod then begin
        if CurLyric mod 2 = 0 then GDILyric.DisplayLyricD(GetLyricString(CurLyric),'')
        else GDILyric.DisplayLyricD(GetLyricString(CurLyric-1),GetLyricString(CurLyric));
      end;
    end;
    exit;
  end;

  if dt> 0 then begin
    d:=  MSecPos - Lyric.LyricTime[CurLyric].timecode;
    l := d * ItemHeight div dt;
    if dlod then begin
      if CurLyric mod 2 = 0 then GDILyric.SetPositionAndFlags(d * GDILyric.FirstStrWidth / dt, 0)
      else GDILyric.SetPositionAndFlags(d * GDILyric.NextStrWidth / dt, 1);
    end;
  end
  else l:= 0;
  TY := -l - CurLyric * ItemHeight;
  PlaylistForm.TMLyricPaint(nil);

  if (MSecPos > LyricTime[CurLyric].timecode) and (MSecPos < LyricTime[NextLyric].timecode) then exit;
  l := 0; h := LyricCount; m := 0;
  while (l <=h) do begin
    m := (l + h) div 2; mv := LyricTime[m].timecode;
    if mv < MSecPos then begin
      l := m + 1;
      if LyricTime[l].timecode> MSecPos then break;
    end
    else if mv > MSecPos then begin
      h := m - 1;
      if LyricTime[h].timecode< MSecPos then begin
        m:=h;
        break;
      end;
    end
    else break;
  end;
  CurLyric := m; NextLyric := m + 1;
  if NextLyric > LyricCount then NextLyric := LyricCount;
  if CurLyric <> NextLyric then
    dt := LyricTime[NextLyric].timecode - LyricTime[CurLyric].timecode;
  if dlod then begin
    if CurLyric mod 2 = 0 then begin
      if CurLyric = LyricCount then GDILyric.DisplayLyricD(GetLyricString(CurLyric),'')
      else GDILyric.DisplayLyricD(GetLyricString(CurLyric),GetLyricString(NextLyric));
    end
    else begin
      if CurLyric = LyricCount then GDILyric.DisplayLyricD(GetLyricString(CurLyric-1),GetLyricString(CurLyric))
      else GDILyric.DisplayLyricD(GetLyricString(NextLyric),GetLyricString(CurLyric));
    end;
  end;
end;

procedure TLyric.DownloadLyric;
var i:Integer; t:TDownLoadLyric;
begin
  if HaveLyric = 0 then begin
    t := TDownLoadLyric.Create(true);
    t.FN:= GetFileName(WideExtractFileName(MediaURL));
    i:= Pos('-',t.FN);
    if (i>0) and (i<Length(t.FN)) then begin
      t.artist:=Trim(Copy(t.FN,1,i-1));
      t.title:= Trim(Copy(t.FN,i+1,MaxInt));
    end
    else begin
      t.artist:='';
      t.title:= t.FN;
    end;

    t.FN:=WideIncludeTrailingPathDelimiter(LyricDir) + t.FN + '.lrc';
    t.FreeOnTerminate := true; t.mode:=3;
    t.Resume;
  end;
end;

procedure TPlaylistForm.FormCreate(Sender: TObject);
begin
  BMPpsPlaying := LoadBitmapResource('PS_PLAYING', true);
  BMPpsPlayed := LoadBitmapResource('PS_PLAYED', true);
  BMPpsSkipped := LoadBitmapResource('PS_SKIPPED', true);
  ControlledMove := true; TDocked := true;
  if (not Wid) or (not Win32PlatformIsUnicode) then begin
    Left := MainForm.Left + MainForm.Width;
    Top := MainForm.Top + MainForm.Height - Height;
  end;
  MGB.Visible := Win32PlatformIsUnicode; N1.Visible := MGB.Visible;
  TntPageControl1.TabIndex := 0; CLyricF.Items := Screen.Fonts;
  CLyricF.Text:=LyricF; CLyricS.Text:=IntToStr(LyricS);
  Lyric.BitMap.Canvas.Brush.Color := LbgColor; Lyric.BitMap.Canvas.Font.Color := LTextColor;
  Lyric.BitMap.Canvas.Font.Name := LyricF; Lyric.BitMap.Canvas.Font.Size := LyricS;
  Lyric.ItemHeight := WideCanvasTextHeight(Lyric.BitMap.Canvas,'S') + 4;
  CPA.Visible:= WideFileExists(homedir+chsdetDll);

  CShuffle.Enabled := not OneLoop; CLoop.Enabled := not OneLoop;
  MainForm.MShuffle.Enabled := not OneLoop; MainForm.MLoopAll.Enabled := not OneLoop;
  COneLoop.Down := OneLoop; MainForm.MOneLoop.Checked := COneLoop.Down;
  CLoop.Down := Loop;
  MainForm.MLoopAll.Checked := CLoop.Down;
  CShuffle.Down := Shuffle;
  MainForm.MShuffle.Checked := CShuffle.Down;

end;

procedure TPlaylistForm.FormShow(Sender: TObject);
begin
  PLTC.Color := LTextColor; PLBC.Color := LbgColor;
  PLHC.Color := LhgColor;
  PlaylistBox.Count := Playlist.Count;
  DragAcceptFiles(Handle, true);
  MainForm.MShowPlaylist.Checked := true;
  MainForm.BPlaylist.Down := true;
  if (MainForm.Width >= CurMonitor.Width) or (MainForm.Height >= (CurMonitor.WorkareaRect.Bottom - CurMonitor.WorkareaRect.Top)) then MainForm.Enabled := false;
  if (OnTop > 0) or MainForm.MFullScreen.Checked then SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TPlaylistForm.FormHide(Sender: TObject);
begin
  DragAcceptFiles(Handle, false);
  MainForm.MShowPlaylist.Checked := false;
  MainForm.BPlaylist.Down := false;
  MainForm.Enabled := true;
  if (OnTop = 1) or ((OnTop = 2) and (Status = sPlaying)) or MainForm.MFullScreen.Checked then
    SetWindowPos(MainForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TPlaylistForm.PlaylistBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var i:integer;
begin
  with PlaylistBox.Canvas do begin
    FillRect(Rect);
    if (Index < 0) or (Index >= Playlist.Count) then exit;
    with Playlist[Index] do begin
      case State of
        psPlaying: Draw(Rect.Left + 3, Rect.Top + 1, BMPpsPlaying);
        psPlayed: Draw(Rect.Left + 3, Rect.Top + 1, BMPpsPlayed);
        psSkipped: Draw(Rect.Left + 3, Rect.Top + 1, BMPpsSkipped);
      end;
      WideCanvasTextOut(PlaylistBox.Canvas, Rect.Left + 16, Rect.Top + 1, DisplayURL);
      i:=WideCanvasTextWidth(playlistForm.PlaylistBox.Canvas,DisplayURL)+100;
      if i>playlistForm.PlaylistBox.ScrollWidth then playlistForm.PlaylistBox.ScrollWidth:=i;
    end;
  end;
end;

procedure TPlaylistForm.BPlayClick(Sender: TObject);
var Index: integer;
begin
  if Playlist.Count > 0 then begin
    if PlaylistBox.SelCount > 0 then begin
      Index := PlaylistBox.ItemIndex - (PlaylistBox.SelCount - 1);
      if (Index < 0) or (not PlaylistBox.Selected[Index]) then Index := PlaylistBox.ItemIndex;
    end
    else Index := 0;
  end
  else exit;
  //ForceStop;
  MainForm.UpdateParams;
  if (CurPlay > -1) and (CurPlay < Playlist.Count) then Playlist.Data[CurPlay].State := psSkipped;
  MainForm.BPrev.Enabled := (Index > 0);
  MainForm.BNext.Enabled := (Index + 1 < Playlist.Count);
  Playlist.NowPlaying(Index); CurPlay := Index;
  MainForm.DoOpen(Playlist[Index].FullURL, Playlist[Index].DisplayURL);
end;

procedure TPlaylistForm.BDeleteClick(Sender: TObject);
var iOld, iNew: integer;
begin
  with Playlist do begin
    iNew := 0;
    for iOld := 0 to High(Data) do begin
      if not PlaylistBox.Selected[iOld] then begin
        if iNew < iOld then Data[iNew] := Data[iOld];
        inc(iNew);
      end
      else begin
        if data[iOld].State = psPlaying then begin
          dec(CurPlay);
          //CurPlay := -1; Firstrun := true;
        end;
      end;
    end;
    SetLength(Data, iNew);
    Changed;
  end;
end;

{function GBKtoNum(s:WideString):integer;
var t: array of integer; i,a:integer;
label Lab0,Lab1,Lab2,Lab3,Lab4,Lab5;
function okStr(str:WideString):boolean;
begin
  SetLength(t, 12);
  for i:=0 to 11 do t[i]:=0;
  a:=1;
  Lab0:
    if s[a]='零' then goto Lab4
    else if s[a]='一' then begin i:=1; goto Lab1; end
    else if s[a]='二' then begin i:=2; goto Lab1; end
    else if s[a]='三' then begin i:=3; goto Lab1; end
    else if s[a]='四' then begin i:=4; goto Lab1; end
    else if s[a]='五' then begin i:=5; goto Lab1; end
    else if s[a]='六' then begin i:=6; goto Lab1; end
    else if s[a]='七' then begin i:=7; goto Lab1; end
    else if s[a]='八' then begin i:=8; goto Lab1; end
    else if s[a]='九' then begin i:=9; goto Lab1; end;
    goto Lab2;
  Lab1:
    inc(a);
    goto Lab3;
  Lab2:
    i:=0;
    goto Lab3;
  Lab3:
    if s[a]='十' then begin
      if i>0 then t[1]:=i else t[i]:=1;//十
    end
    else if s[a]='百' then begin
       if i>0 then t[2]:=i else t[2]:=1;//百
    end
    else if s[a]='千' then begin
      if i>0 then t[3]:=i else t[3]:=1;//千
    end
    else if s[a]='万' then begin //万
      t[0]:=i;
      t[4]:=t[0]; t[0]:=0;
      t[5]:=t[1]; t[1]:=0;
      t[6]:=t[2]; t[2]:=0;
      t[7]:=t[3]; t[3]:=0;
    end
    else if s[a]='亿' then begin//亿
      t[0]:=i;
      t[8]:=t[0]; t[0]:=0;
      t[9]:=t[1]; t[1]:=0;
      t[10]:=t[2]; t[2]:=0;
      t[11]:=t[3]; t[3]:=0;
    end
    else begin
      t[0]:=i;
      goto Lab5;
    end;
  Lab4:
    inc(a);
    goto Lab0;
  Lab5:
    result:=0;
    for i:=11 downto 0 do
      result:=result*10+t[i];
end;}

function isNum(n: WChar): boolean;
begin
  result := (n>='0') and (n<='9');
end;

function trimpzero(s: widestring):WideString;
var z: integer;
begin
  for z := 1 to length(s) do
    if s[z] <> '0' then break;
  delete(s, 1, z - 1);
  Result:=s;
end;

{function sti(S:wideString):int64;
var i:integer;
begin
  result:=0;
  for i:=1 to length(s) do
      result:=result*10+Ord(s[i])-Ord('0');
end; }

function mysort(s: TWStringList; P1, P2: Integer): Int64;
var s1, s2: WideString; ef, k, j, g, ce, ne: integer;
begin
  s1 := Tnt_WideLowerCase(s[p1]);
  s2 := Tnt_WideLowerCase(s[p2]);
  ce := length(s1); ne := length(s2);
  ef := min(ce, ne);
  for k := 1 to ef do begin
    if s1[k] <> s2[k] then begin
      j := 0; g := 0;
      while ((k + j) <= ce) and isnum(s1[k + j]) do inc(j);           //000s
      while ((k + g) <= ne) and isnum(s2[k + g]) do inc(g);           //a
      if (j <> 0) and ((k + j) <= ce) and (g = 0) and (trimpzero(copy(s1, k, j)) = '') then
        result := ord(s1[k + j]) - ord(s2[k])
      else if (g <> 0) and ((k + g) <= ne) and (j = 0) and (trimpzero(copy(s2, k, g)) = '') then
        result := ord(s1[k]) - ord(s2[k + g])
      else if j * g > 0 then result := StrToInt64Def(copy(s1, k, j),ord(s1[k])) - StrToInt64Def(copy(s2, k, g),ord(s2[k]))
      else result := ord(s1[k]) - ord(s2[k]);
      exit;
    end
    else if isnum(s1[k]) and isnum(s2[k]) then begin
      j := 1; g := 1;
      while ((k + j) <= ce) and isnum(s1[k + j]) do inc(j);
      while ((k + g) <= ne) and isnum(s2[k + g]) do inc(g);
      result := StrToInt64Def(copy(s1, k, j),ord(s1[k])) - StrToInt64Def(copy(s2, k, g),ord(s2[k]));
      if result<>0 then exit;
    end;
  end;
  result := ce - ne;
end;

procedure addEpisode(s: widestring);
var index, a: integer; s1, s2, path: WideString;
  efiles: TWStringList; SR: TSearchRecW;
  function compare(c, n: widestring): integer;
  var l, bl, br, ed, cc, nc, ce, ne: integer; cd, nd: widestring;
  begin
    result := 0;
    bl := 0;
    br := 0;                                                   //213
    cc := length(c); nc := length(n);                          //2113
    ed := min(cc, nc);                                        // 121212
    for l := 1 to ed do begin                                  //12121212
      if (bl = 0) and (c[l] <> n[l]) then bl := l;
      if (br = 0) and (c[cc - l + 1] <> n[nc - l + 1]) then br := l;
      if bl * br > 0 then break;     //tq12et      tq1et      tqet       1a
    end;
    if bl=0 then bl:=cc+1;           // tq1212et     tq11et    tq1212et  11a
    if br=0 then br:=cc+1;
    if bl>(cc-br+1) then begin
       if (bl-1>0) and isNum(c[bl-1]) then dec(bl);
       br:=cc-bl+1;
    end;
    cd := copy(c, bl, cc - br - bl + 2); nd := copy(n, bl, nc - br - bl + 2);
    Val(cd, cc, ce); Val(nd, nc, ne);
    if (ce = 0) and (ne = 0) and (nc >= cc) then begin
      result := 1; exit;
    end;
    cd:= trimpzero(cd); nd:= trimpzero(nd);
    if length(cd) <> length(nd) then exit
    else if length(cd) = 1 then begin
      if (cd[1] >= 'a') and (cd[1] <= 'z') and (nd[1] >= 'a') and (nd[1] <= 'z') then begin
        result := 1; exit;
      end;
    end;
  end;
begin
  if not WideFileExists(s) then exit;
  path := WideIncludeTrailingPathDelimiter(WideExtractFilePath(s));
  efiles := TWSTringList.Create;
  if WideFindFirst(path + '*' + WideExtractFileExt(s), faAnyFile, SR) = 0 then begin
    repeat
      if (SR.Name[1] <> '.') and ((SR.Attr and faDirectory) = 0) then efiles.Add(SR.Name);
    until WideFindNext(SR) <> 0;
    WideFindClose(SR); efiles.SortStr(mysort);
  end;
  s := WideExtractFileName(s);
  index := efiles.IndexOf(s);
  if index > efiles.Count - 2 then exit;
  s1 := GetFileName(Tnt_Widelowercase(s));
  for a := index + 1 to efiles.Count - 1 do begin
    s2 := GetFileName(Tnt_Widelowercase(efiles[a]));
    if compare(s1, s2) <> 0 then
      Playlist.AddFiles(path + efiles[a],false)
    else break;
  end;
end;

procedure TPlaylistForm.BAddClick(Sender: TObject);
var i: integer; sfiles: TWStringList;
begin
  with MainForm.OpenDialog do begin
    Title := MainForm.MOpenFile.Caption;
    Options := Options + [ofAllowMultiSelect] - [ofoldstyledialog];
    filter := MediaFilter + '|*.rar;*.zip;*.7z;*.001;*.ttpl;*.alac;*.av*;*.mp*;'
      + '*.vo*;*.dat;*.bin;*.qt;'
      + '*.divx;*.og*;*.mk*;*.wm*;*.as*;*.m*v;*.dv;*.26*;*.wav;*.wpl;'
      + '*.ac*;*.m4*;*.rm*;*.vivo;*.3g*;*.iso;*.img;*.grf;*.realpix;'
      + '*.m3u*;*.vp*;*.ts;*.vqf;*.nrg;*.a52;*.aac;*.dts*;'
      + '*.pls;*.ns*;*.s3*;*.fl*;*.xm*;*.aif*;*.ds*;*.m*a;*.st*;'
      + '*.am*;*.mid*;*.smi*;*.pva;*.tp*;*.cda;*.au;*.jsv;*.pmp*;*.m2p;'
      + '*.ap*;*.drc;*.d2v;*.ivf;*.rt;*.rp*;*.roq;*.smk;*.swf;*.vg2;'
      + '*.bik;*.mod;*.mdz;*.ult;*.669;*.far;*.okt;*.ptm;*.kar;*.vid;'
      + '*.miz;*.rv;*.mac;*.mjf;*.cmf;*.cmn;*.mtm;*.rnx;*.voc;*.ratdvd;'
      +'*.arj;*.bz2;*.z;*.lzh;*.cab;*.lzma;*.xar;*.hfs;*.dmg;*.wim;*.split;*.rpm;*.deb;*.cpio;*.tar;*.gz;'
      + '*.snd;*.pss;*.tta;*.umx;*.ram;*.ra;*.it*;*.xspf;*.smpl|'
      + AnyFilter + '(*.*)|*.*';

    if Execute then begin
      PClear := (Sender <> BAdd); EndOpenDir:=PClear;
      sfiles := TWSTringList.Create;
      sfiles.AddStrings(files);
      sfiles.SortStr(mysort);
      for i := 0 to Files.Count - 1 do begin
        if Addsfiles then begin
          if playlist.FindItem('', WideExtractFileName(sfiles[i])) < 0 then begin
            Playlist.AddFiles(sfiles[i],false);
            addEpisode(sfiles[i]);
          end;
        end
        else Playlist.AddFiles(sfiles[i],false);
      end;
      Playlist.Changed; 
      sfiles.Free;
    end;
  end;
end;

procedure TPlaylistForm.FormDropFiles(var msg: TMessage);
var hDrop: THandle; fnbuf, j, t: widestring; k: boolean;
  i, DropCount, s,a: integer; FList:TWStringList;
  tw: array[0..1024] of wideChar; ta: array[0..1024] of Char;
begin
  hDrop := msg.wParam;
  if Win32PlatformIsUnicode then DropCount := DragQueryFileW(hDrop, cardinal(-1), nil, 0)
  else DropCount := DragQueryFile(hDrop, cardinal(-1), nil, 0);
  VobFileCount := 0; s := 0; FList:= TWStringList.Create;
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
    fnbuf:=FList[i];
    if WideDirectoryExists(fnbuf) then Playlist.AddDirectory(fnbuf,false)
    else begin
      j := Tnt_WideLowerCase(WideExtractFileExt(fnbuf));
      a:= CheckInfo(MediaType, j);
      if FilterDrop then k := a> ZipTypeCount
      else k := (CheckInfo(SubType, j) = -1) and ((a = -1) or (a > ZipTypeCount));
      if k then Playlist.AddFiles(fnbuf,false)
      else begin
        if j = '.idx' then begin
          if Running and HaveVideo then begin
            j:= GetFileName(fnbuf); Loadsub := 1;
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
              TmpPW:= playlist.FindPW(fnbuf);
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
              AddMovies(fnbuf, TmpPW, true,false);  //add=true时，不更新TmpPW，要放在ExtractSub或ExtractLyric后
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
              if pos(t,substring)=0 then begin
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
  FList.Free; Playlist.Changed;
  if (not Win32PlatformIsUnicode) and (s > 0) then Restart;
  msg.Result := 0;
end;

procedure TPlaylistForm.BMoveClick(Sender: TObject);
var i: integer;
begin
  for i := 0 to (Playlist.Count - 1) do
    Playlist.Selected[i] := PlaylistBox.Selected[i];
  if (Sender as TComponent).Tag = 1
    then Playlist.MoveSelectedUp
  else Playlist.MoveSelectedDown;
  for i := 0 to (Playlist.Count - 1) do
    PlaylistBox.Selected[i] := Playlist.Selected[i];
  PlaylistBox.Invalidate;
end;

procedure TPlaylistForm.FormMove(var msg: TMessage);
const m = 20;
begin
  msg.Result := 0;
  if not ControlledMove then begin ControlledMove := true; exit; end;

  if (left >= (MainForm.Left + MainForm.Width - m)) and (left <= (MainForm.Left + MainForm.Width + m)) and
    (top > (MainForm.top - Height)) and (top < (MainForm.top + MainForm.Height)) then begin
    if not LDocked then TT := MainForm.Top - top;
    Left := MainForm.Left + MainForm.Width;
    LDocked := true;
    if ControlledMove and (TT <> (MainForm.Top - top)) then TT := MainForm.Top - top;
    ControlledMove := true;
  end
  else LDocked := False;

  if (left >= (MainForm.Left - Width - m)) and (left <= (MainForm.Left - Width + m)) and
    (top > (MainForm.top - Height)) and (top < (MainForm.top + MainForm.Height)) then begin
    if not RDocked then TT := MainForm.Top - top;
    Left := MainForm.Left - Width;
    RDocked := true;
    if ControlledMove and (TT <> (MainForm.Top - top)) then TT := MainForm.Top - top;
    ControlledMove := true;
  end
  else RDocked := False;

  if ((top >= (MainForm.top + MainForm.Height)) and (top <= (MainForm.top + MainForm.Height + m)) and
    (left >= (MainForm.left - Width)) and (left <= (MainForm.left + MainForm.Width))) or
    ((top >= (MainForm.top + MainForm.Height - m)) and (top < (MainForm.top + MainForm.Height)) and
    (left > (MainForm.left - Width + m)) and (left < (MainForm.left + MainForm.Width - m))) then begin
    if not TDocked then LL := MainForm.Left - left;
    Top := MainForm.Top + MainForm.Height;
    TDocked := true;
    if ControlledMove and (LL <> (MainForm.Left - left)) then LL := MainForm.Left - left;
    ControlledMove := true;
  end
  else TDocked := False;

  if ((top >= (MainForm.top - Height - m)) and (top <= (MainForm.top - Height)) and
    (left >= (MainForm.left - Width)) and (left <= (MainForm.left + MainForm.Width))) or
    ((top > (MainForm.top - Height)) and (top <= (MainForm.top - Height + m)) and
    (left > (MainForm.left - Width + m)) and (left < (MainForm.left + MainForm.Width - m))) then begin
    if not BDocked then LL := MainForm.Left - left;
    Top := MainForm.Top - Height;
    BDocked := true;
    if ControlledMove and (LL <> (MainForm.Left - left)) then LL := MainForm.Left - left;
    ControlledMove := true;
  end
  else BDocked := False;

end;

procedure TPlaylistForm.CShuffleClick(Sender: TObject);
begin
  CShuffle.Down := not Shuffle;
  MainForm.MShuffle.Checked := CShuffle.Down;
  Shuffle := CShuffle.Down;
end;

procedure TPlaylistForm.CLoopClick(Sender: TObject);
begin
  CLoop.Down := not Loop;
  MainForm.MLoopAll.Checked := CLoop.Down;
  Loop := CLoop.Down;
end;

procedure TPlaylistForm.BSaveClick(Sender: TObject);
var FList: TStringList; i, h: integer; FN: WideString;
begin
  with SaveDialog do begin
    Title := BSave.Hint;
    Filter:='M3U8 Playlist [UTF-8] (*.m3u8)|*.m3u8|M3U Playlist [ANSI] (*.m3u)|*.m3u';
    if Execute then begin
      FList := TStringList.Create;
      if Tnt_WideLowerCase(WideExtractFileExt(FileName)) = '.m3u8' then
        for i := 0 to Playlist.Count - 1 do FList.Add(UTF8Encode(Playlist[i].FullURL))
      else for i := 0 to Playlist.Count - 1 do FList.Add(Playlist[i].FullURL);
      if not WideFileExists(FileName) then begin
        h := WideFileCreate(FileName);
        if GetLastError = 0 then FN := WideExtractShortPathName(FileName);
        if h < 0 then
          FN := WideExtractShortPathName(WideIncludeTrailingPathDelimiter(WideExtractFilePath(FileName))) + WideExtractFileName(FileName)
        else CloseHandle(h);
      end
      else begin
        if WideFileIsReadOnly(FileName) then WideFileSetReadOnly(FileName, false);
        FN := WideExtractShortPathName(FileName);
      end;
      FList.SaveToFile(FN);
      FList.Free;
    end;
  end;
end;

procedure TPlaylistForm.BAddDirClick(Sender: TObject);
var s: widestring;
begin
  if WideSelectDirectory(AddDirCp, '', s) then begin
    PClear := false;
    Playlist.AddDirectory(s,false);
    //Playlist.Changed;
  end;
end;

procedure TPlaylistForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F9 then Hide;
end;

procedure TPlaylistForm.COneLoopClick(Sender: TObject);
begin
  CShuffle.Enabled := OneLoop; CLoop.Enabled := OneLoop;
  MainForm.MShuffle.Enabled := OneLoop; MainForm.MLoopAll.Enabled := OneLoop;
  COneLoop.Down := not OneLoop; MainForm.MOneLoop.Checked := COneLoop.Down;
  OneLoop := COneLoop.Down;
end;

procedure TPlaylistForm.BClearClick(Sender: TObject);
begin
  EndOpenDir:=true;
  Playlist.Clear;
  Playlist.Changed;
  playlistForm.PlaylistBox.ScrollWidth:=0;
end;

procedure TPlaylistForm.FormDblClick(Sender: TObject);
begin
  TDocked := True; MainForm.UpdateDockedWindows;
end;

procedure TPlaylistForm.TntCPClick(Sender: TObject);
var i, j, k: integer;
begin
  if (Sender as TTntMenuItem).Checked then exit;
  CP := (Sender as TTntMenuItem).Tag;
  for i := 0 to TntCP.Items.Count - 1 do begin
    TntCP.Items[i].Checked := false;
    for j := 0 to TntCP.Items[i].Count - 1 do begin
      TntCP.Items[i].Items[j].Checked := false;
      for k := 0 to TntCP.Items[i].Items[j].Count - 1 do
        TntCP.Items[i].Items[j].Items[k].Checked := false;
    end;
  end;
  (Sender as TTntMenuItem).Checked := true;
  UpdatePW := True;
  TMLyricPaint(nil);
  if dlod then begin
    GDILyric.FontName := LyricF;
    if HaveLyric = 0 then exit;
    GDILyric.GetFontHeight;
    if MSecPos < Lyric.LyricTime[0].timecode then begin
      if LyricCount=0 then GDILyric.DisplayLyricD(Lyric.GetLyricString(0),'')
      else GDILyric.DisplayLyricD(Lyric.GetLyricString(0),Lyric.GetLyricString(1));
    end;
    if MSecPos > Lyric.LyricTime[LyricCount].timecode then begin
      if CurLyric mod 2 = 0 then GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric),'')
      else GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric-1),Lyric.GetLyricString(CurLyric));
    end;
    if (MSecPos >= Lyric.LyricTime[CurLyric].timecode) and (MSecPos <= Lyric.LyricTime[NextLyric].timecode) then begin
      if CurLyric mod 2 = 0 then begin
        if CurLyric = LyricCount then GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric),'')
        else GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric),Lyric.GetLyricString(NextLyric));
      end
      else begin
        if CurLyric = LyricCount then GDILyric.DisplayLyricD(Lyric.GetLyricString(CurLyric-1),Lyric.GetLyricString(CurLyric))
        else GDILyric.DisplayLyricD(Lyric.GetLyricString(NextLyric),Lyric.GetLyricString(CurLyric));
      end;
    end;
  end;
end;

procedure TPlaylistForm.CLyricFChange(Sender: TObject);
begin
  if CLyricF.ItemIndex > -1 then begin
    if Assigned(LyricShowForm) then GDILyric.SetFont(CLyricF.Text);
    Lyric.BitMap.Canvas.Font.Name := CLyricF.Text; UpdatePW := True;
    Lyric.ItemHeight:= WideCanvasTextHeight(Lyric.BitMap.Canvas,'S') + 4;
    LyricF:= CLyricF.Text;
    TMLyricPaint(nil);
  end;
end;

procedure TPlaylistForm.CLyricSChange(Sender: TObject);
var i, e: integer;
begin
  Val(CLyricS.Text, i, e);
  if (e = 0) and (i > 0) then begin
    Lyric.BitMap.Canvas.Font.Size := i; LyricS:=i;
    Lyric.ItemHeight:= WideCanvasTextHeight(Lyric.BitMap.Canvas,'S') + 4;
    UpdatePW := True;
    TMLyricPaint(nil);
  end;
end;

procedure TPlaylistForm.PLTCClick(Sender: TObject);
begin
  OptionsForm.ColorDialog1.Color := PLTC.Color;
  if OptionsForm.ColorDialog1.Execute then
    PLTC.Color := OptionsForm.ColorDialog1.Color;
  LTextColor := ColorToRGB(PLTC.Color);
  Lyric.BitMap.Canvas.Font.Color := LTextColor;
  TMLyricPaint(nil);
end;

procedure TPlaylistForm.PLHCClick(Sender: TObject);
begin
  OptionsForm.ColorDialog1.Color := PLHC.Color;
  if OptionsForm.ColorDialog1.Execute then
    PLHC.Color := OptionsForm.ColorDialog1.Color;
  LhgColor := ColorToRGB(PLHC.Color);
  Lyric.BitMap.Canvas.Brush.Color := LhgColor;
  TMLyricPaint(nil);
end;

procedure TPlaylistForm.PLBCClick(Sender: TObject);
begin
  OptionsForm.ColorDialog1.Color := PLBC.Color;
  if OptionsForm.ColorDialog1.Execute then
    PLBC.Color := OptionsForm.ColorDialog1.Color;
  LbgColor := ColorToRGB(PLBC.Color);
  Lyric.BitMap.Canvas.Font.Color := LbgColor;
  TMLyricPaint(nil);
end;

procedure TPlaylistForm.MDownloadLyricClick(Sender: TObject);
begin
  DLyricForm.Show; DLyricForm.PLS.ActivePageIndex:=0;
  DLyricForm.PLSChange(nil);
end;

procedure TPlaylistForm.MLoadLyricClick(Sender: TObject);
begin
  MainForm.MLoadlyricClick(nil);
end;

function Gb2Big5(str: string): string;
begin
  setLength(result, length(str));
  LCMapString(GetUserDefaultLCID, LCMAP_TRADITIONAL_CHINESE, PChar(str), length(str), PChar(result), length(result));
  result := WideStringToStringEx(StringToWideStringEx(result, 936), 950);
end;

function Big52Gb(str: string): string;
begin
  str := WideStringToStringEx(StringToWideStringEx(str, 950), 936);
  setlength(result, length(str));
  LCMapString(GetUserDefaultLCID, LCMAP_SIMPLIFIED_CHINESE, PChar(str), length(str), PChar(result), length(result));
end;

constructor TLyric.Create;
begin
  BitMap := TBitmap.Create;
  BitMap.Canvas.Font.size := 8;
  BitMap.Canvas.Font.name := 'Tahoma';
  ItemHeight:= WideCanvasTextHeight(BitMap.Canvas,'S') + 4;
end;

destructor TLyric.Destroy;
begin
  BitMap.Free;
end;

function TLyric.GetLyricString(i:Integer):WideString;
var f:WideString; k: string;
begin
  Result:='';
  if HaveLyric = 1 then begin
    if LyricStringsW = nil then exit;
    Result := LyricStringsW[LyricTime[i].LyricEntry];
    if PlaylistForm.MG2B.Checked then begin
      f := Result;
      LCMapStringW(GetUserDefaultLCID, LCMAP_TRADITIONAL_CHINESE, PWChar(f), length(f), PWChar(Result), length(Result));
    end;
    if PlaylistForm.MB2G.Checked then begin
      f := Result;
      LCMapStringW(GetUserDefaultLCID, LCMAP_SIMPLIFIED_CHINESE, PWChar(f), length(f), PWChar(Result), length(Result));
    end;
  end
  else begin
    if LyricStringsA = nil then exit;
    k := LyricStringsA[LyricTime[i].LyricEntry];
    if PlaylistForm.MG2B.Checked then k := Gb2Big5(k);
    if PlaylistForm.MB2G.Checked then k := Big52Gb(k);
    Result := StringToWideStringEx(k, CP);
  end;
end;

function TLyric.GetMaxLyricString(i:Integer):WideString;
var f:WideString; k: string;
begin
  Result:='';
  if HaveLyric = 1 then begin
    if LyricStringsW = nil then exit;
    Result := LyricStringsW[i];
    if PlaylistForm.MG2B.Checked then begin
      f := Result;
      LCMapStringW(GetUserDefaultLCID, LCMAP_TRADITIONAL_CHINESE, PWChar(f), length(f), PWChar(Result), length(Result));
    end;
    if PlaylistForm.MB2G.Checked then begin
      f := Result;
      LCMapStringW(GetUserDefaultLCID, LCMAP_SIMPLIFIED_CHINESE, PWChar(f), length(f), PWChar(Result), length(Result));
    end;
  end
  else begin
    if LyricStringsA = nil then exit;
    k := LyricStringsA[i];
    if PlaylistForm.MG2B.Checked then k := Gb2Big5(k);
    if PlaylistForm.MB2G.Checked then k := Big52Gb(k);
    Result := StringToWideStringEx(k, CP);
  end;
end;

procedure TLyric.Draw;
var s: WideString; L, T, j, i, d: integer;
begin
  BitMap.Canvas.Lock;
  BitMap.Width := PlaylistForm.TMLyric.Width;
  BitMap.Height := PlaylistForm.TMLyric.Height + 2*ItemHeight;
  BitMap.Canvas.Brush.Color := LbgColor;
  BitMap.Canvas.FillRect(BitMap.Canvas.ClipRect);

  if HaveLyric=0 then begin
    BitMap.Canvas.Unlock;
    Exit;
  end;

  //Lyric.GetCurrentLyric;
  T := (BitMap.Height - WideCanvasTextHeight(BitMap.Canvas, 'S')) div 2;
  
  for i := 0 to LyricCount do begin
    j:= TY + i*ItemHeight + T;
    if (j <0 ) or (j>BitMap.Height) then Continue;
    
    BitMap.Canvas.Font.Color := LTextColor;
    if i = CurLyric then BitMap.Canvas.Font.Color := LhgColor;
      
    s:= GetLyricString(i);
    L := (BitMap.Width - WideCanvasTextWidth(BitMap.Canvas, s)) div 2;
    //T := (BitMap.Height - WideCanvasTextHeight(BitMap.Canvas, s)) div 2;
    WideCanvasTextOut(BitMap.Canvas, L,  j, s);
    if UpdatePW then begin
      UpdatePW := false;
      s:= GetMaxLyricString(MaxLenLyric);
      j := 10 + WideCanvasTextWidth(BitMap.Canvas, s) + PlaylistForm.width - PlaylistForm.TMLyric.Width;
      if j > CurMonitor.Width then j := CurMonitor.Width;
      if j < PlaylistForm.Constraints.MinWidth then j := PlaylistForm.Constraints.MinWidth;
      d := (j - PlaylistForm.Width) div 2;
      if (PlaylistForm.left + PlaylistForm.width) <= MainForm.Left then PlaylistForm.left := PlaylistForm.left + PlaylistForm.Width - j
      else if PlaylistForm.left > (MainForm.Left + MainForm.Width) then
      else if (PlaylistForm.Left - d) < (MainForm.Left + MainForm.Width) then PlaylistForm.Left := PlaylistForm.Left - d;
      PlaylistForm.Width := j;
    end;
  end;
  BitMap.Canvas.Unlock;
end;

procedure TPlaylistForm.TMLyricPaint(Sender: TObject);
begin
  if TntPageControl1.TabIndex <> 1 then exit;
  Lyric.Draw;
  TMLyric.Canvas.Lock;
  TMLyric.Canvas.Draw(0, -Lyric.ItemHeight, Lyric.BitMap);
  //BitBlt(TMLyric.Canvas.Handle, 0, 0, Lyric.BitMap.Width, Lyric.BitMap.Height, Lyric.BitMap.Canvas.Handle, 0, Lyric.ItemHeight, SRCCOPY);
  TMLyric.Canvas.Unlock;
end;

initialization
  Playlist := TPlaylist.Create;
  Lyric := TLyric.Create;
finalization
  Playlist.Free;
  Lyric.Free;
end.

