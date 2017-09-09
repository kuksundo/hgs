{  MPUI-hcb, an MPlayer frontend for Windows
   Copyright (C) 2006-2013 Huang Chen Bin <hcb428@foxmail.com>
   based on Delphi interface to 7-zip32.dll written by Dominic Dum閑 (dominic@psas.co.za)
// Purpose: to create and extract files in the 7-zip format (www.7-zip.org)

// 7-zip32.dll written by Akky. Download it here:
// http://akky.cjb.net/download/7-zip32.html

// NB: I don't understand Japanese (no english docs are available for the dll)
// so I don't understand the purpose of all of the functions available,
// such as Set/GetCursorInterval, Cursormode etc...

// If anyone out there can provide more info on all the functions in the dll
// please let me know... :)

//-----------------------------------------------------------------------------
// HOW TO USE IT:
// Your program first needs to call LoadSevenZipDLL before any of the functions
// will work. Call UnloadSevenZipDLL when your program terminates...
// Obviously 7-zip32.dll file must be available to program (such as in the
// app's exe folder).

// Use SevenZipCreateArchive, SevenZipExtractArchive function to easily create
// and extract 7z files (with optional callback function)

// If you know what you're doing use SevenZipCommand function (works just like
// command line version of 7-zip). See 7-zip docs for command syntax.

// To get contents of archive file use SevenZipOpenArchive, SevenZipFindFirst,
// SevenZipFindNext and SevenZipCloseArchive (works like FindFirst, FindNext) 

//-----------------------------------------------------------------------------
// Revision history:
// v1.00 17 June 2005 - First release
// If you find any bugs or add any features please let me know

// v1.01 1 September 2005
// new feature:
//  --> Add parameter Password in SevenZipCreateArchive and SevenZipExtractArchive function
//      by Jeter Rabelo Ferreira (jeter.rabelo@jerasoft.com.br)

// --> Added BaseDirectory parameter to SevenZipCreateArchive for easier handling of
//     relative paths (note that absolute paths ARE NOT supported by the DLL) [Dominic Dum閑]
}
unit SevenZip;

interface
uses Tntclasses, sysutils, TntSysUtils,  windows, TntWindows, TntDialogs, SevenZipVCL;

const
  // codes returned by SevenZipCreateArchive and SevenZipExtractArchive
  SZ_OK = 0;
  SZ_ERROR = 1;
  SZ_CANCELLED = 2;
  SZ_DLLERROR = 3;
  FNAME_MAX32	= 512;
  FA_DIREC		 = $10;
  FA_ENCRYPTED = $40;

type

  HARC = integer;

  TZipEXTRACTINGINFO = record
    dwFileSize          : DWORD;
    dwWriteSize         : DWORD;
    szSourceFileName    : array[ 0..FNAME_MAX32 ] of char;
    dummy1              : array[ 0..2 ] of char;
    szDestFileName      : array[ 0..FNAME_MAX32 ] of char;
    dummy               : array[ 0..2 ] of char;
  end;

  TZipEXTRACTINGINFOEX = record
    exinfo           : TZipEXTRACTINGINFO;
    dwCompressedSize : DWORD;
    dwCRC            : DWORD;
    uOSType          : UINT;
    wRatio           : WORD;
    wDate            : WORD;
    wTime            : WORD;
    szAttribute      : array[ 0..7 ] of char;
    szMode           : array[ 0..7 ] of char;
  end;

  TZipINDIVIDUALINFO = record
    dwOriginalSize   : DWORD;
	  dwCompressedSize : DWORD;
	  dwCRC            : DWORD;
    uFlag            : UINT;
		uOSType          : UINT;
    wRatio           : WORD;
    wDate            : WORD;
    wTime            : WORD;
    szFilename       : array[ 0..FNAME_MAX32 ] of char;
    dummy1           : array[ 0..2 ] of char;
    szAttribute      : array[ 0..7 ] of char;
    szMode           : array[ 0..7 ] of char;
  end;

  TZipCommand                = function (const hWnd: HWND; szCmdLine: PChar; szOutput: PChar; dwSize: DWORD): Integer; stdcall;
	TZipGetRunning             = function : BOOL; stdcall;
	TZipOpenArchive            = function( hwnd : HWND; szFileName : PChar; dwMode : DWORD ) : HARC; stdcall;
	TZipCloseArchive           = function( harc : HARC ) : integer; stdcall;
	TZipFindFirst              = function( harc : HARC; szFilename : PChar; var lpSubInfo : TZipINDIVIDUALINFO ) : integer; stdcall;
	TZipFindNext               = function( harc : HARC; var lpSubInfo : TZipINDIVIDUALINFO ) : integer; stdcall;
  TZipGetAttribute           = function( harc : HARC ) : integer; stdcall;
  // Callback func should return FALSE to cancel the archiving process, else TRUE
  TZipCallbackProc           = function( hWnd : HWND; uMsg, nState : UINT; var ExInfo : TZipEXTRACTINGINFOEX ) : BOOL; stdcall;
  TZipSetOwnerWindowEx       = function( hwnd : HWND; CallbackProc : TZipCallbackProc ) : BOOL; stdcall;
	TZipSetUnicodeMode         = function( bUnicode : BOOL ) : BOOL; stdcall;

procedure LoadZipLibrary;
procedure UnLoadZipLibrary;
procedure Load7zLibrary;
procedure UnLoad7zLibrary;
procedure Extract7zLyric(ArcName,PW:WideString);
procedure ExtractZipLyric(ArcName,PW:WideString);
function Extract7zSub(ArcName,PW:WideString):WideString;
function ExtractZipSub(ArcName,PW:WideString):WideString;
function Add7zMovies(ArcName,PW:WideString; Add,msg:boolean):integer;
function AddZipMovies(ArcName,PW:WideString; Add,msg:boolean):integer;
procedure Extract7zMovie(ArcName,PW:WideString);
procedure ExtractZipMovie(ArcName,PW:WideString);

// NB: add '-hide' to command line switches if you want the CallBack function to be called
// (set up via SevenZipSetOwnerWindowEx).
// otherwise the DLL uses it's own internal progress dialog
function ZipCommand( hWnd : HWND;                     // parent window
                     CommandLine : string;            // 7zip command line (see 7zip docs)
                     var CommandOutput : string;      // returns 7zip output
                     MaxCommandOutputLen : integer = 32768 ) : integer;

// simplified func to extract archive
function ZipExtractArchive( hWnd : HWND; // parent window handle
                            ArchiveFilename : string;
                            FileList : string; // comma separated files to be extracted (wildcards ok)
                            RecurseFolders : Boolean;
                            Password: String; // '' Nothing happens
                            ExtractFullPaths : Boolean;
                            ExtractBaseDir : string;
                            ShowProgress   : Boolean;     // if true uses dll's internal progress indicator (callback func ignored)
                            Callback       : TZipCallbackProc = nil ) // optional callback (ShowProgress must be false)
                            : integer; // 0 = success

var
  IsZipLoaded: THandle =0; F7zaLibh: THandle = 0;
  Is7zLoaded: integer =0;
  _ZipCommand              : TZipCommand              = nil;
  ZipGetRunning            : TZipGetRunning           = nil;
  ZipOpenArchive           : TZipOpenArchive          = nil;
  ZipCloseArchive          : TZipCloseArchive         = nil;
  ZipFindFirst             : TZipFindFirst            = nil;
  ZipFindNext              : TZipFindNext             = nil;
  ZipGetAttribute          : TZipGetAttribute         = nil;
  ZipSetOwnerWindowEx      : TZipSetOwnerWindowEx     = nil;
  ZipSetUnicodeMode        : TZipSetUnicodeMode       = nil;

implementation
uses core, plist, locale;

procedure Load7zLibrary;
var i:integer;
begin
  if F7zaLibh<>0 then exit;
  for i:=szdllCount downto 0 do begin
    F7zaLibh := Tnt_LoadLibraryW(PWChar(szdll[i]) );
    if F7zaLibh <> 0 then begin
      Is7zLoaded:=i+1;
      break;
    end;
  end;
end;

procedure UnLoad7zLibrary;
begin
  if F7zaLibh <> 0 then begin
    FreeLibrary( F7zaLibh );
    Is7zLoaded:=0;
  end;
end;

procedure LoadZipLibrary;
begin
  if IsZipLoaded<>0 then exit;
  IsZipLoaded:=Tnt_LoadLibraryW('7-zip32.dll');
  if IsZipLoaded<>0 then begin
    _ZipCommand             := GetProcAddress( IsZipLoaded, 'SevenZip' );
    ZipGetRunning           := GetProcAddress( IsZipLoaded, 'SevenZipGetRunning' );
    ZipOpenArchive          := GetProcAddress( IsZipLoaded, 'SevenZipOpenArchive' );
    ZipCloseArchive         := GetProcAddress( IsZipLoaded, 'SevenZipCloseArchive' );
    ZipFindFirst            := GetProcAddress( IsZipLoaded, 'SevenZipFindFirst' );
    ZipFindNext             := GetProcAddress( IsZipLoaded, 'SevenZipFindNext' );
    ZipGetAttribute         := GetProcAddress( IsZipLoaded, 'SevenZipGetAttribute' );
    ZipSetOwnerWindowEx     := GetProcAddress( IsZipLoaded, 'SevenZipSetOwnerWindowEx' );
    ZipSetUnicodeMode       := GetProcAddress( IsZipLoaded, 'SevenZipSetUnicodeMode' );
  end;
end;

procedure UnLoadZipLibrary;
begin
  if IsZipLoaded<>0 then begin
    FreeLibrary(IsZipLoaded);
    IsZipLoaded:=0;
  end;
end;

function UnZIPCallback(hWnd:HWND; uMsg,nState:UINT; var ExInfo:TZipEXTRACTINGINFOEX):BOOL; stdcall;
begin
  Result:=procArc;
end;

function ZipCommand(hWnd:HWND; CommandLine:string; var CommandOutput:string; MaxCommandOutputLen:integer=32768):integer;
begin
  SetLength(CommandOutput,MaxCommandOutputLen);
  Result:=_ZipCommand(hWnd,PChar(CommandLine),PChar(CommandOutput),MaxCommandOutputLen);
  CommandOutput:=PChar(CommandOutput);
end;

function ZipExtractArchive( hWnd : HWND; // parent window handle
                            ArchiveFilename : string;
                            FileList : string; // comma separated files to be extracted (wildcards ok)
                            RecurseFolders : Boolean;
                            Password: String; // '' Nothing happens
                            ExtractFullPaths : Boolean;
                            ExtractBaseDir : string;
                            ShowProgress   : Boolean;     // if true uses dll's internal progress indicator (callback func ignored)
                            Callback       : TZipCallbackProc = nil ) // optional callback (ShowProgress must be false)
                            : integer; // 0 = success

var S7ResultOutput,s7cmd,s:string;
begin
  if @Callback<>nil then ShowProgress:=false;
  if FileList='' then FileList:='*.*';

  try
    if ExtractFullPaths then s7cmd := 'x' else s7cmd := 'e';
    s7cmd:=s7cmd+' "'+ArchiveFilename+'" -o"'+ExtractBaseDir+'" "'+FileList+'"';
    if RecurseFolders then s7cmd:=s7cmd+' -r';
    if Password<>'' then s7Cmd:=s7Cmd+' -p'+Password;
    if not ShowProgress then s7cmd := s7cmd + ' -hide';
    s7cmd:=s7cmd+' -y'; // yes on all queries (will overwrite)

    try
      ZipSetOwnerWindowEx(hwnd,Callback );
      ZipCommand(hWnd,s7cmd,s7ResultOutput );
      ZipSetOwnerWindowEx(hwnd,nil);
      S7ResultOutput:=PChar(S7ResultOutput);
      s:= Lowercase(S7ResultOutput);
      if Pos('operation aborted',s)>0 then
        Result:=SZ_CANCELLED
      else if Pos('error:',s)>0 then
        Result:=SZ_ERROR
      else
        Result:=SZ_OK;
    except on e:exception do
        Result:=SZ_DLLERROR;
    end;
    finally
    end;
end;

function AddZipMovies(ArcName,PW:widestring; Add,msg:boolean):integer;
var hArc:integer; fileInfo:TZipINDIVIDUALINFO; k,i:widestring;
    Entry:TPlaylistEntry; FList:TWStringList; a:integer;
begin
  Result:=0; if not Add then TmpPW:=PW;
  if ZipGetRunning then begin
    Result:=-1; exit;
  end
  else begin
    ZipSetUnicodeMode(true);
    hArc:=ZipOpenArchive(0,PChar(UTF8Encode(ArcName)),0);
    if hArc=0 then begin Result:=-1; exit; end;
    k:=WideExtractFileName(ArcName);
    //fileinfo.szAttribute[4]='G' 而不是'-'或#0时，文件是加密的
    if ((ZipGetAttribute(hArc) and FA_ENCRYPTED)=FA_ENCRYPTED) and (PW='') then
      WideInputQuery(LOCstr_SetPW_Caption,k,PW);
    if not Add then TmpPW:=PW;
    FList:=TWStringList.Create;
    if ZipFindFirst(hArc,'*',fileInfo)=0 then begin
      repeat  //fileinfo.szAttribute[0]='-' 是目录
        if msg then PlayMsgAt := GetTickCount() + 500;
        if ((ZipGetAttribute(hArc) and FA_DIREC)<>FA_DIREC) then begin
          i:= UTF8Decode(fileInfo.szFilename);
          if CheckInfo(MediaType,Tnt_WideLowerCase(WideExtractFileExt(i)))>ZipTypeCount then begin
            inc(Result);
            if Add then begin
              i:= i +' <-- '+k;
              if playlist.FindItem('',i)<0 then begin
                if PW='' then FList.Add(i) else FList.Add(i+':'+PW);
              end;
            end
            else Break;
          end;
        end;
      until ZipFindNext(hArc,fileInfo)<>0;
    end;
    ZipCloseArchive(hArc);
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
end;

function Add7zMovies(ArcName,PW:widestring; Add,msg:boolean):integer;
var k,i:widestring; Entry:TPlaylistEntry; x,z:integer; sz:TSevenZip;
begin
  Result:=0; sz:=TSevenZip.Create(nil,Tnt_WideLowerCase(WideExtractFileExt(ArcName)));
  sz.Password:=PW; sz.SZFileName:=ArcName;
  x:=sz.List(false); if not Add then TmpPW:=sz.Password;
  if x=-1 then begin Result:=-1; sz.Free; exit; end;
  k:=WideExtractFileName(ArcName);
  sz.Files.SortStr(mysort);
  for z:=0 to sz.Files.Count-1 do begin
    if msg then PlayMsgAt := GetTickCount() + 500;
    if CheckInfo(MediaType,Tnt_WideLowerCase(WideExtractFileExt(sz.Files[z])))>ZipTypeCount then begin
      inc(Result);
      if Add then begin
        i:=sz.Files[z]+' <-- '+k;
        if playlist.FindItem('',i)<0 then begin
          with Entry do begin
            State:=psNotPlayed;
            FullURL:=ArcName;
            if sz.Password='' then DisplayURL:=i else DisplayURL:=i+':'+sz.Password;
          end;
          playlist.Add(Entry);
        end;
      end
      else Break;
    end;
  end;
  sz.Free;
end;

procedure ExtractZipMovie(ArcName,PW:widestring);
var UArcName:UTF8String; hArc:integer;
begin
  if ZipGetRunning then exit
  else begin
    ZipSetUnicodeMode(true);
    UArcName:=UTF8Encode(ArcName);
    if PW='' then begin
      hArc:=ZipOpenArchive(0,PChar(UArcName),0);
      if hArc=0 then exit;
      //fileinfo.szAttribute[4]='G' 而不是'-'或#0时，文件是加密的
      if (ZipGetAttribute(hArc) and FA_ENCRYPTED)=FA_ENCRYPTED then
        WideInputQuery(LOCstr_SetPW_Caption,WideExtractFileName(ArcName),PW);
      ZipCloseArchive(hArc);
    end;
    ZipExtractArchive(0,UArcName,UTF8Encode(ArcMovie),false,UTF8Encode(PW),true,TempDir,false,UnZIPCallback);
  end;
end;

procedure Extract7zMovie(ArcName,PW:widestring);
var sz:TSevenZip;
begin
  sz:=TSevenZip.Create(nil,Tnt_WideLowerCase(WideExtractFileExt(ArcName)));
  sz.SZFileName:=ArcName; sz.Password:=PW;
  if PW='' then sz.List(true);
  sz.ExtrBaseDir:=TempDir;
  sz.Files.Clear;
  sz.Files.Add(ArcMovie);
  sz.ExtractOptions:=sz.ExtractOptions - [ExtractNoPath];
  sz.Extract;
  sz.Free;
end;

procedure ExtractZipLyric(ArcName,PW:widestring);
var hArc:integer; FName:WideString; fileInfo:TZipINDIVIDUALINFO;
    UArcName:UTF8String;
begin
  TmpPW:=PW;
  if ZipGetRunning then exit
  else begin
    ZipSetUnicodeMode(true);
    UArcName:=UTF8Encode(ArcName);
    hArc:=ZipOpenArchive(0,PChar(UArcName),0);
    if hArc=0 then exit;
    //fileinfo.szAttribute[4]='G' 而不是'-'或#0时，文件是加密的
    if ((ZipGetAttribute(hArc) and FA_ENCRYPTED)=FA_ENCRYPTED) and (PW='') then
      WideInputQuery(LOCstr_SetPW_Caption,WideExtractFileName(ArcName),TmpPW);
    PW:=TmpPW;
    if ZipFindFirst(hArc,'*',fileInfo)=0 then begin
      FName:=Tnt_WideLowerCase(getFileName(WideExtractFileName(ArcMovie)))+'.lrc';
      repeat
        if FName=Tnt_WideLowerCase(WideExtractFileName(UTF8Decode(fileInfo.szFilename))) then begin
          if ZipExtractArchive(0,UArcName,fileInfo.szFilename,false,UTF8Encode(PW),true,TempDir,false,UnZIPCallback)<>0 then
            Break
          else begin
            Lyric.ParseLyric(TempDir+UTF8Decode(fileInfo.szFilename));
            if HaveLyric<>0 then Break; 
          end;
        end;
      until ZipFindNext(hArc,fileInfo)<>0;
      ZipCloseArchive(hArc);
    end;
  end;
end;

procedure Extract7zLyric(ArcName,PW:widestring);
var FName:WideString; x,z:integer; sz:TSevenZip; Flist:TTntStringList;
begin
  sz:=TSevenZip.Create(nil,Tnt_WideLowerCase(WideExtractFileExt(ArcName)));
  sz.Password:=PW; sz.SZFileName:=ArcName;
  sz.ExtrBaseDir:=TempDir;
  sz.ExtractOptions:=sz.ExtractOptions - [ExtractNoPath];
  x:=sz.List(false);
  TmpPW:=sz.Password;
  if x<1 then begin sz.Free; exit; end;
  Flist:=TTntStringList.Create;
  Flist.AddStrings(sz.Files);
  FName:=Tnt_WideLowerCase(getFileName(WideExtractFileName(ArcMovie)))+'.lrc';
  for z:=0 to Flist.Count -1 do begin
    if Tnt_WideLowerCase(WideExtractFileName(Flist[z]))=FName then begin
      sz.Files.Clear;
      sz.Files.Add(Flist[z]);
      if sz.Extract<>0 then Break
      else begin
        Lyric.ParseLyric(TempDir+Flist[z]);
        if HaveLyric<>0 then break;
      end;
    end;
  end;
  sz.Free;
  Flist.Free;
end;

function ExtractZipSub(ArcName,PW:widestring):WideString;
var i,j,HaveIdx,HaveSub,DirHIdx,DirHSub:integer; FExt,FName,g:widestring;
    hArc:integer; UArcName:UTF8String;
    fileInfo:TZipINDIVIDUALINFO;
begin
  g:=GetFileName(ArcName); TmpPW:=PW;
  DirHIdx:=integer(WideFileExists(g+'.idx'));
  DirHSub:=integer(WideFileExists(g+'.sub'));
  if (DirHIdx+DirHSub)=2 then begin result:=g; exit; end;
  
  Result:=''; HaveIdx:=0; HaveSub:=0;
  ZipSetUnicodeMode(true);
  UArcName:=UTF8Encode(ArcName);

  if (DirHIdx+DirHSub)=1 then begin
    if ZipGetRunning then exit
    else begin
      hArc:=ZipOpenArchive(0,PChar(UArcName),0);
      if hArc=0 then exit;
      if ZipFindFirst(hArc,'*',fileInfo)=0 then begin
        repeat
          FExt:=Tnt_WideLowerCase(WideExtractFileExt(UTF8Decode(fileInfo.szFilename)));
          if FExt='.idx' then HaveIdx:=1;
          if FExt='.sub' then HaveSub:=1;
          if HaveIdx+HaveSub=2 then Break;
        until ZipFindNext(hArc,fileInfo)<>0;
      end;
      if ZipCloseArchive(hArc)<>0 then exit;
      if HaveIdx+HaveSub=0 then exit;
    end;
  end;
  //开始解压RAR文档
  if ZipGetRunning then exit
  else begin
    hArc:=ZipOpenArchive(0,PChar(UArcName),0);
    if hArc=0 then exit;  j:=0;
    if ((ZipGetAttribute(hArc) and FA_ENCRYPTED)=FA_ENCRYPTED) and (PW='') then
      WideInputQuery(LOCstr_SetPW_Caption,WideExtractFileName(ArcName),TmpPW);
    PW:=TmpPW;
    if ZipFindFirst(hArc,'*',fileInfo)=0 then begin
      repeat
        FExt:=Tnt_WideLowerCase(WideExtractFileExt(UTF8Decode(fileInfo.szFilename)));
        i:=CheckInfo(SubType,FExt);
        if i>0 then begin
          if i<SubTypeCount-1 then begin
            FName:=TempDir+UTF8Decode(fileInfo.szFilename);
            if ZipExtractArchive(0,UArcName,fileInfo.szFilename,false,UTF8Encode(PW),true,TempDir,false,UnZIPCallback)<>0 then
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
              FName:=TempDir+'hcb428';
              if ZipExtractArchive(0,UArcName,fileInfo.szFilename,false,UTF8Encode(PW),true,TempDir,false,UnZIPCallback)<>0 then
                Break
              else begin
                if WideCopyFile(TempDir+UTF8Decode(fileInfo.szFilename),FName+FExt,false) then
                  Result:=FName
                else Result:=TempDir+GetFileName(UTF8Decode(fileInfo.szFilename));
              end;
            end
            else begin
              if ((HaveIdx+DirHSub=2) and (FExt='.idx')) OR
                 ((DirHIdx+HaveSub=2) and (FExt='.sub')) then begin
                if ZipExtractArchive(0,UArcName,fileInfo.szFilename,false,UTF8Encode(PW),true,TempDir,false,UnZIPCallback)<>0 then
                  Break
                else begin
                  if WideCopyFile(TempDir+UTF8Decode(fileInfo.szFilename),g+FExt,false) then
                    Result:=g
                  else Result:=TempDir+GetFileName(UTF8Decode(fileInfo.szFilename));
                end;
              end;
            end;
          end;
        end;
      until ZipFindNext(hArc,fileInfo)<>0;
    end;
    ZipCloseArchive(hArc);
    if (not Win32PlatformIsUnicode) and (j>0) then Restart;
  end;
end;

function Extract7zSub(ArcName,PW:widestring):WideString;
var i,j,z,x,HaveIdx,HaveSub,DirHIdx,DirHSub:integer; FExt,FName,g,t:WideString;
    sz:TsevenZip; Flist:TTntStringList;
begin
  g:=GetFileName(ArcName); t:= TempDir+'hcb428'; TmpPW:=PW;
  DirHIdx:=integer(WideFileExists(g+'.idx'));
  DirHSub:=integer(WideFileExists(g+'.sub'));
  if (DirHIdx+DirHSub)=2 then begin result:=g; exit; end;
  
  Result:=''; HaveIdx:=0; HaveSub:=0;
  sz:=TSevenZip.Create(nil,Tnt_WideLowerCase(WideExtractFileExt(ArcName)));
  sz.Password:=PW; sz.SZFileName:=ArcName;
  sz.ExtrBaseDir:=TempDir;
  x:=sz.List(false);
  TmpPW:=sz.Password;
  if x<1 then begin sz.Free; exit; end;

  if (DirHIdx+DirHSub)=1 then begin
    for z:=0 to sz.Files.Count-1 do begin
      FExt:=Tnt_WideLowerCase(WideExtractFileExt(sz.Files[z]));
      if FExt='.idx' then HaveIdx:=1;
      if FExt='.sub' then HaveSub:=1;
      if HaveIdx+HaveSub=2 then Break;
    end;
    if HaveIdx+HaveSub=0 then begin
      sz.Free; exit;
    end;
  end;
  //开始解压RAR文档
  Flist:=TTntStringList.Create;
  Flist.AddStrings(sz.Files);
  j:=0;
  for z:=0 to Flist.Count-1 do begin
    FExt:=Tnt_WideLowerCase(WideExtractFileExt(Flist.Strings[z]));
    i:=CheckInfo(SubType,FExt);
    if i>0 then begin
      if i<SubTypeCount-1 then begin
        sz.Files.Clear;
        sz.Files.Add(Flist[z]);
        sz.ExtractOptions:=sz.ExtractOptions-[ExtractNoPath];
        FName:=TempDir+Flist[z];
        if sz.Extract<>0 then Break
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
          sz.Files.Clear;
          sz.Files.Add(Flist[z]);
          sz.ExtractOptions:=sz.ExtractOptions+[ExtractNoPath];
          sz.ExtrOutName:='hcb428' + FExt;
          if sz.Extract<>0 then Break
          else Result:=t;
        end
        else begin
          if ((HaveIdx+DirHSub=2) and (FExt='.idx')) OR
             ((DirHIdx+HaveSub=2) and (FExt='.sub')) then begin
            sz.Files.Clear;
            sz.Files.Add(Flist[z]);
            sz.ExtractOptions:=sz.ExtractOptions+[ExtractNoPath];
            sz.ExtrOutName:='hcb428' + FExt;
            if sz.Extract<>0 then Break
            else begin
              if WideCopyFile(t+FExt,g+FExt,false) then
                Result:=g
              else Result:=t;
            end;
          end;
        end;
      end;
    end;
  end;
  sz.Free;
  Flist.Free;
  if (not Win32PlatformIsUnicode) and (j>0) then Restart;
end; 

end.
