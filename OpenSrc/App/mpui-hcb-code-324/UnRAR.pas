{  MPUI-hcb, an MPlayer frontend for Windows
   Copyright (C) 2006-2013 Huang Chen Bin <hcb428@foxmail.com>
   based on TDFUnRAR by <dfrischalowski@del-net.com>
   
   see UNRARDLL.TXT for Informations about UnRar.dll - Functions and structures
}
// 动态载入UnRAR.dll
unit UnRar;

interface

uses
  Windows, SysUtils, TntSysUtils, TntWindows, Classes, TntDialogs, ComObj,ActiveX;

const
  // Constants from UnRar.h
  RAR_OM_LIST          = 0;
  RAR_OM_EXTRACT       = 1;
  RAR_SKIP             = 0;
  RAR_EXTRACT          = 2;
  RAR_VOL_ASK          = 0;
  UCM_CHANGEVOLUME     = 0;

type
  TUnrarCallback = function(Msg: UINT; UserData, P1, P2: LPARAM): Integer; stdcall;

  // Header for every file in an archive
  TRARHeaderData = record
    ArcName      : array[0..1023] of char;
    ArcNameW     : array[0..1023] of WideChar;
    FileName     : array[0..1023] of char;
    FileNameW    : array[0..1023] of WideChar;
    Flags        : cardinal;
    PackSize     : cardinal;
    PackSizeHigh : cardinal;
    UnpSize      : cardinal;
    UnpSizeHigh  : cardinal;
    HostOS       : cardinal;
    FileCRC      : cardinal;
    FileTime     : cardinal;
    UnpVer       : cardinal;
    Method       : cardinal;
    FileAttr     : cardinal;
    CmtBuf       : PChar;
    CmtBufSize   : cardinal;
    CmtSize      : cardinal;
    CmtState     : cardinal;
    Reserved     : array[0..1023] of cardinal;
  end;

  // Archive-Data for opening rar-archive
  TRAROpenArchiveData = record
    ArcName    : PChar;
    ArcNameW   : PWideChar;
    OpenMode   : cardinal;
    OpenResult : cardinal;
    CmtBuf     : PChar;
    CmtBufSize : cardinal;
    CmtSize    : cardinal;
    CmtState   : cardinal;
    Flags      : cardinal;
    //Callback: TUnrarCallback;
    //UserData: LPARAM;
    //Reserved: array[0..27] of cardinal;
    Reserved   : array[0..31] of cardinal;
  end;

  TUnRARThread = class(TThread)
                  private
                  protected
                    procedure Execute; override;
                end;

var
  IsRarLoaded:THandle=0; IsShell32Loaded:THandle = 0;
  RAROpenArchive        : function(var ArchiveData: TRAROpenArchiveData): THandle; stdcall;
  RARCloseArchive       : function(hArcData: THandle): integer; stdcall;
  RARReadHeader         : function(hArcData: THandle; var HeaderData: TRARHeaderData): Integer; stdcall;
  RARProcessFile        : function(hArcData: THandle; Operation: Integer; DestPath, DestName: PwideChar): Integer; stdcall;
  RARSetPassword        : procedure(hArcData: THandle; Password: PChar); stdcall;
  RARSetCallback        : procedure(hArcData: THandle; UnrarCallback: TUnrarCallback; UserData: LPARAM); stdcall;
  SHGetKnownFolderPath  : function(rfid:PGUID; dwFlags:DWord; hToken:THandle; out ppszPath:PPWideChar):HRESULT; stdcall;
  IsUserAnAdmin         : function : BOOL; stdcall;

procedure LoadRarLibrary;
procedure UnLoadRarLibrary;
procedure LoadShell32Library;
procedure UnLoadShell32Library;
procedure ClearTmpFiles(Directory:WideString);
function AddRarMovies(ArcName,PW:widestring; Add,msg:boolean):integer;
procedure ExtractRarMovie(ArcName,PW:widestring);
procedure ExtractRarLyric(ArcName,PW:WideString);
function ExtractRarSub(ArcName,PW:WideString):WideString;
function GetShellPath(rfid:TGUID):WideString;
function IsAdmin:boolean;

implementation
uses Core,plist,locale;

procedure TUnRARThread.Execute;
begin
  ExtractMovie(TmpURL,ArcPW);
  tEnd:=true;
  Restart;
end;

procedure LoadRarLibrary;
begin
  if IsRarLoaded <> 0 then exit;
  IsRarLoaded := Tnt_LoadLibraryW('unrar.dll');
  if IsRarLoaded <> 0 then begin
    @RAROpenArchive        := GetProcAddress(IsRarLoaded, 'RAROpenArchiveEx');
    @RARCloseArchive       := GetProcAddress(IsRarLoaded, 'RARCloseArchive');
    @RARReadHeader         := GetProcAddress(IsRarLoaded, 'RARReadHeaderEx');
    @RARProcessFile        := GetProcAddress(IsRarLoaded, 'RARProcessFileW');
    @RARSetPassword        := GetProcAddress(IsRarLoaded, 'RARSetPassword');
    @RARSetCallback        := GetProcAddress(IsRarLoaded, 'RARSetCallback');
  end;
end;

procedure UnLoadRarLibrary;
begin
  if IsRarLoaded <> 0 then begin
    FreeLibrary(IsRarLoaded);
    IsRarLoaded := 0;
    RAROpenArchive        := nil;
    RARCloseArchive       := nil;
    RARReadHeader         := nil;
    RARProcessFile        := nil;
    RARSetPassword        := nil;
    RARSetCallback        := nil;
  end;
end;

procedure LoadShell32Library;
begin
  if IsShell32Loaded <> 0 then exit;
  IsShell32Loaded := Tnt_LoadLibraryW('shell32.dll'); 
  if IsShell32Loaded <> 0 then begin
    @SHGetKnownFolderPath:= GetProcAddress(IsShell32Loaded, 'SHGetKnownFolderPath');
    @IsUserAnAdmin:= GetProcAddress(IsShell32Loaded, 'IsUserAnAdmin');
  end;
end;

procedure UnLoadShell32Library;
begin
  if IsShell32Loaded <> 0 then begin
    FreeLibrary(IsShell32Loaded);
    IsShell32Loaded := 0;
    SHGetKnownFolderPath:= nil;
    IsUserAnAdmin:= nil;
  end;
end;

function GetShellPath(rfid:TGUID):WideString;
var PathBuf:PPWideChar; APIResult:HRESULT;
begin //http://msdn.microsoft.com/en-us/library/bb762188(VS.85).aspx
  Result:='';
  LoadShell32Library;
  if IsShell32Loaded=0 then exit;
  APIResult:=SHGetKnownFolderPath(@rfid,0,0,PathBuf);
  OleCheck(APIResult);
  Result:=PWideChar(PathBuf);
  CoTaskMemFree(PathBuf);
end;

function IsAdmin():boolean;
begin
  Result:=false;
  LoadShell32Library;
  if IsShell32Loaded<>0 then Result:=IsUserAnAdmin();
end;

procedure ClearTmpFiles(Directory:WideString);
var SR:TSearchRecW;
begin  
  if not WideDirectoryExists(Directory) then exit;
  Directory:=WideIncludeTrailingPathDelimiter(Directory);
  if WideFindFirst(Directory+'*.*',faAnyFile,SR)=0 then begin
    repeat
      if SR.Name[1]<>'.' then begin   // exclude . or .. Directory
        if (SR.Attr AND faDirectory)<>0 then
          ClearTmpFiles(Directory+SR.Name)
        else WideDeleteFile(Directory+SR.Name);
      end;
    until WideFindNext(SR)<>0;
    WideFindClose(SR);
  end;
  WideRemoveDir(Directory); 
end;

function UnRARCallback(msg:UINT; UserData,P1,P2:LPARAM):integer; stdcall;
var FileName:WideString; s:String;
begin
  if procArc then Result:=1
  else begin Result:=-1; exit; end;
  
  if msg=UCM_CHANGEVOLUME then begin
    if P2=RAR_VOL_ASK then begin
      s:=LowerCase(PChar(P1));
      if lastP1=s then begin
        StrPCopy(PChar(P1), lastFN);
        exit;
      end;
      lastP1:=s;
      s:=copy(s,Pos('.part',s)+1,MaxInt);
      FileName := Tnt_WideLowerCase(PWChar(UserData));
      FileName := copy(FileName, 1, Pos('.part', FileName));
      FileName := FileName + s;
      if WidePromptForFileName(FileName, 'RAR file(*.rar)|*.rar|Any file(*.*)|*.*', '', LOCstr_VolAsk_Caption) then begin
        lastFN := Tnt_WideLowerCase((FileName));
        StrPCopy(PChar(P1), lastFN);
      end
      else Result:=-1;
    end;
  end;
end;

function AddRarMovies(ArcName,PW:widestring; Add,msg:boolean):integer;
var hArcData:THandle; HeaderData:TRARHeaderData;
    OpenArchiveData:TRAROpenArchiveData;
    Entry:TPlaylistEntry; i,k:widestring;
    First:boolean; FList:TWStringList; a:integer;
begin
  Result:=0; if not Add then TmpPW:=PW;
  FillChar(OpenArchiveData ,sizeof(OpenArchiveData),0);
  OpenArchiveData.ArcNameW := PWideChar(ArcName);
  OpenArchiveData.OpenMode := RAR_OM_LIST;
  hArcData := RAROpenArchive(OpenArchiveData);
  if (hArcData = 0) OR (OpenArchiveData.OpenResult <> 0) then begin
    RARCloseArchive(hArcData);
    Result:=-1; exit;
  end;
  FList:=TWStringList.Create; First:=true; k:=WideExtractFileName(ArcName);
  if (OpenArchiveData.Flags and $00000080) = $00000080 then begin
    First:=false;
    if PW='' then WideInputQuery(LOCstr_SetPW_Caption,k,PW);
    if PW<>'' then RARSetPassword(hArcData,PAnsiChar(AnsiString(PW)));
    if not Add then TmpPW:=PW;
  end;
  FillChar(HeaderData ,sizeof(HeaderData),0);
  repeat
    if msg then PlayMsgAt := GetTickCount() + 500;
    if RARReadHeader(hArcData, HeaderData) <> 0 then Break;
    if ((HeaderData.Flags and $00000070) <> $00000070) and
       (CheckInfo(MediaType,Tnt_WideLowerCase(WideExtractFileExt(HeaderData.FileNameW)))>ZipTypeCount) then begin
      if First then begin
        First:=false;
        if ((HeaderData.Flags and $00000004) = $00000004) and (PW='') then
          WideInputQuery(LOCstr_SetPW_Caption,k,PW);
        if PW<>'' then RARSetPassword(hArcData,PAnsiChar(AnsiString(PW)));
        if not Add then TmpPW:=PW;
      end;
      inc(Result);
      if Add then begin
        i:=HeaderData.FileNameW+' <-- '+k;
        if playlist.FindItem('.part',i)<0 then begin
            if PW='' then FList.Add(i) else FList.Add(i+':'+PW);
        end;
      end
      else Break;
    end;
    if RARProcessFile(hArcData, RAR_SKIP, nil, nil)<>0 then break;
  until False;
  RARCloseArchive(hArcData);
  Flist.SortStr(mysort);
  for a:=0 to Flist.Count-1 do begin
    with Entry do begin
      State:=psNotPlayed;
      FullURL:=ArcName;
      DisplayURL:=Flist[a];
    end;
    playlist.Add(Entry);
  end;
  Flist.Free;
end;

procedure ExtractRarMovie(ArcName,PW:widestring);
var hArcData:THandle; First:boolean; k:widestring;
    HeaderData:TRARHeaderData; OpenArchiveData:TRAROpenArchiveData;
begin
  FillChar(OpenArchiveData ,sizeof(OpenArchiveData),0);
  OpenArchiveData.ArcNameW := PWideChar(ArcName);
  OpenArchiveData.OpenMode := RAR_OM_EXTRACT;
  //OpenArchiveData.UserData := LPARAM(OpenArchiveData.ArcNameW);
  //OpenArchiveData.Callback := UnRARCallback;
  hArcData := RAROpenArchive(OpenArchiveData);
  if (hArcData = 0) OR (OpenArchiveData.OpenResult <> 0) then begin
    RARCloseArchive(hArcData); exit;
  end;
  First:=true; k:=WideExtractFileName(ArcName);
  // Obsolete, use TRAROpenArchiveData's callback and UserData fields above.
  RARSetCallback(hArcData,UnRARCallback,LPARAM(OpenArchiveData.ArcNameW));
  if (OpenArchiveData.Flags and $00000080) = $00000080 then begin
    First:=false; if PW='' then WideInputQuery(LOCstr_SetPW_Caption,k,PW);
    if PW<>'' then RARSetPassword(hArcData,PAnsiChar(AnsiString(PW)));
  end;
  FillChar(HeaderData ,sizeof(HeaderData),0);
  repeat
    if RARReadHeader(hArcData,HeaderData) <> 0 then Break;
    if ((HeaderData.Flags and $00000070) <> $00000070) and
       (HeaderData.FileNameW=ArcMovie) then begin
      if First then begin
        if ((HeaderData.Flags and $00000004) = $00000004) and (PW='') then
          WideInputQuery(LOCstr_SetPW_Caption,k,PW);
        if PW<>'' then RARSetPassword(hArcData,PAnsiChar(AnsiString(PW)));
      end;
      RARProcessFile(hArcData, RAR_EXTRACT, nil, PWideChar(TempDir+ArcMovie));
      Break;
    end
    else if RARProcessFile(hArcData, RAR_SKIP, nil, nil)<>0 then break;
  until False;
try
  RARCloseArchive(hArcData);
except
end;
end;

procedure ExtractRarLyric(ArcName,PW:widestring);
var hArcData:THandle; First:boolean; FName,t,k:widestring;
    HeaderData:TRARHeaderData; OpenArchiveData:TRAROpenArchiveData;
begin
  TmpPW:=PW;
  FillChar(OpenArchiveData ,sizeof(OpenArchiveData),0);
  OpenArchiveData.ArcNameW := PWideChar(ArcName);
  OpenArchiveData.OpenMode := RAR_OM_EXTRACT;
  //OpenArchiveData.UserData := LPARAM(OpenArchiveData.ArcNameW);
  //OpenArchiveData.Callback := UnRARCallback;
  hArcData := RAROpenArchive(OpenArchiveData);
  if (hArcData = 0) OR (OpenArchiveData.OpenResult <> 0) then begin
    RARCloseArchive(hArcData); exit;
  end;
  First:=true; k:=WideExtractFileName(ArcName);
  // Obsolete, use TRAROpenArchiveData's callback and UserData fields above.
  RARSetCallback(hArcData,UnRARCallback,LPARAM(OpenArchiveData.ArcNameW));
  if (OpenArchiveData.Flags and $00000080) = $00000080 then begin
    First:=false;
    if PW='' then WideInputQuery(LOCstr_SetPW_Caption,k,TmpPW);
    if TmpPW<>'' then RARSetPassword(hArcData,PAnsiChar(AnsiString(TmpPW)));
  end;
  FillChar(HeaderData ,sizeof(HeaderData),0);
  FName:=Tnt_WideLowerCase(getFileName(WideExtractFileName(ArcMovie)))+'.lrc';

  repeat
    if RARReadHeader(hArcData,HeaderData) <> 0 then Break;
    if ((HeaderData.Flags and $00000070) <> $00000070) and
       (FName=Tnt_WideLowerCase(WideExtractFileName(HeaderData.FileNameW))) then begin
      if First then begin
        First:=false;
        if ((HeaderData.Flags and $00000004) = $00000004) and (PW='') then
          WideInputQuery(LOCstr_SetPW_Caption,k,TmpPW);
        if TmpPW<>'' then RARSetPassword(hArcData,PAnsiChar(AnsiString(TmpPW)));
      end;
      t:= TempDir+HeaderData.FileNameW;
      if RARProcessFile(hArcData, RAR_EXTRACT, nil, PWideChar(t))<>0 then
        Break
      else begin
        Lyric.ParseLyric(t);
        if HaveLyric<>0 then Break;
      end;
    end
    else if RARProcessFile(hArcData, RAR_SKIP, nil, nil)<>0 then break;
  until False;
  try
    RARCloseArchive(hArcData);
  EXCEPT
  end;
end;

function ExtractRarSub(ArcName,PW:widestring):widestring;
var i,j,HaveIdx,HaveSub,DirHIdx,DirHSub:integer; FName,FExt,g,t,k:widestring;
    First:boolean; hArcData:THandle; HeaderData:TRARHeaderData;
    OpenArchiveData:TRAROpenArchiveData;
begin
  g:=GetFileName(ArcName); t:= TempDir+'hcb428'; TmpPW:=PW;
  DirHIdx:=integer(WideFileExists(g+'.idx'));
  DirHSub:=integer(WideFileExists(g+'.sub'));
  if (DirHIdx+DirHSub)=2 then begin result:=g; exit; end;

  Result:=''; j:=0; First:=true; k:=WideExtractFileName(ArcName);
  HaveIdx:=0; HaveSub:=0;
  FillChar(OpenArchiveData ,sizeof(OpenArchiveData),0);
  OpenArchiveData.ArcNameW := PWideChar(ArcName);
  //OpenArchiveData.UserData := LPARAM(OpenArchiveData.ArcNameW);
  //OpenArchiveData.Callback := UnRARCallback;
  if (DirHIdx+DirHSub)=1 then begin
    OpenArchiveData.OpenMode := RAR_OM_LIST;
    hArcData := RAROpenArchive(OpenArchiveData);
    if (hArcData = 0) OR (OpenArchiveData.OpenResult <> 0) then begin
      RARCloseArchive(hArcData); exit;
    end;
    // Obsolete, use TRAROpenArchiveData's callback and UserData fields above.
    RARSetCallback(hArcData,UnRARCallback,LPARAM(OpenArchiveData.ArcNameW));
    if (OpenArchiveData.Flags and $00000080) = $00000080 then begin
      First:=false;
      if PW='' then WideInputQuery(LOCstr_SetPW_Caption,k,TmpPW);
      if TmpPW<>'' then RARSetPassword(hArcData,PChar(String(TmpPW)));
    end;
    FillChar(HeaderData ,sizeof(HeaderData),0);
    repeat
      if RARReadHeader(hArcData, HeaderData) <> 0 then Break;
      if (HeaderData.Flags and $00000070) <> $00000070 then begin
        FExt:=Tnt_WideLowerCase(WideExtractFileExt(HeaderData.FileNameW));
        if FExt='.idx' then HaveIdx:=1;
        if FExt='.sub' then HaveSub:=1;
        if HaveIdx+HaveSub=2 then Break;
      end;
      if RARProcessFile(hArcData, RAR_SKIP, nil, nil)<>0 then break;
    until False;
    if RARCloseArchive(hArcData)<>0 then exit;
    if HaveIdx+HaveSub=0 then exit;
  end;
  //开始解压RAR文档
  OpenArchiveData.OpenMode := RAR_OM_EXTRACT;
  hArcData := RAROpenArchive(OpenArchiveData);
  if (hArcData = 0) OR (OpenArchiveData.OpenResult <> 0) then begin
    RARCloseArchive(hArcData); exit;
  end;
  // Obsolete, use TRAROpenArchiveData's callback and UserData fields above.
  RARSetCallback(hArcData,UnRARCallback,LPARAM(OpenArchiveData.ArcNameW));
  if First then begin
    if (OpenArchiveData.Flags and $00000080) = $00000080 then begin
      First:=false;
      if PW='' then WideInputQuery(LOCstr_SetPW_Caption,k,TmpPW);
      if TmpPW<>'' then RARSetPassword(hArcData,PAnsiChar(AnsiString(TmpPW)));
    end;
  end;
  FillChar(HeaderData ,sizeof(HeaderData),0);
  repeat
    if RARReadHeader(hArcData, HeaderData) <> 0 then Break;
    if (HeaderData.Flags and $00000070) <> $00000070 then begin
      if First then begin
        First:=false;
        if ((HeaderData.Flags and $00000004) = $00000004) and (PW='') then
          WideInputQuery(LOCstr_SetPW_Caption,k,TmpPW);
        if TmpPW<>'' then RARSetPassword(hArcData,PAnsiChar(AnsiString(TmpPW)));
      end;
      FExt:=Tnt_WideLowerCase(WideExtractFileExt(HeaderData.FileNameW));
      i:=CheckInfo(SubType,FExt);
      if i<1 then begin
        if RARProcessFile(hArcData, RAR_SKIP, nil, nil)<>0 then break;
      end
      else begin
        if i<SubTypeCount-1 then begin
          FName:=TempDir+HeaderData.FileNameW;
          if RARProcessFile(hArcData, RAR_EXTRACT, nil, PWideChar(FName))<>0 then
            Break
          else begin
            if (not IsWideStringMappableToAnsi(FName)) or (pos(',',FName)>0) then FName:=WideExtractShortPathName(FName);
            if pos(FName,substring)=0 then begin
              if Firstrun or (not Win32PlatformIsUnicode) then begin
                Loadsub:=2; Loadsrt:=2;
                AddChain(j,substring,EscapeParam(FName));
              end
              else
                SendCommand('sub_load ' + Tnt_WideStringReplace(EscapeParam(FName), '\', '/', [rfReplaceAll]));
            end;
          end;
        end
        else begin
          if (DirHIdx+DirHSub=0) OR (HaveIdx+HaveSub=2) then begin
            if RARProcessFile(hArcData, RAR_EXTRACT, nil, PWideChar(t+FExt))<>0 then
              Break
            else
              Result:=t;
          end
          else begin
            if ((HaveIdx+DirHSub=2) and (FExt='.idx')) OR
               ((DirHIdx+HaveSub=2) and (FExt='.sub')) then begin
              if RARProcessFile(hArcData, RAR_EXTRACT, nil, PWideChar(t+FExt))<>0 then
                Break
              else begin
                if WideCopyFile(t+FExt,g+FExt,false) then
                  Result:=g
                else Result:=t;
              end;
            end
            else if RARProcessFile(hArcData, RAR_SKIP, nil, nil)<>0 then break;
          end;
        end;
      end;
    end
    else if RARProcessFile(hArcData, RAR_SKIP, nil, nil)<>0 then break;
  until False;
  RARCloseArchive(hArcData);
  if (not Win32PlatformIsUnicode) and (j>0) then Restart;
end;

end.
