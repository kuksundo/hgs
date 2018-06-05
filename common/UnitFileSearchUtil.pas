unit UnitFileSearchUtil;

interface

uses Winapi.Windows, classes, SysUtils, Forms, SynCommons, mORMot;

function GetFindFileList(filemask: string; showFiles, showFolders, fullPath: boolean): TStringList;
function WindowsFindFileList(filemask: string; showFiles, showFolders, fullPath: boolean): TStringList;
function GetFileSize(szFile: PChar): Int64;
function FindAllFiles(RootFolder: string; Mask: string = '*.*';
  Recurse: Boolean = True): TStringList;
function GetFirstFileNameIfExist(foldername, filemask: string): string;

implementation

//filemask: 'c:\*.txt'
function GetFindFileList(filemask: string; showFiles, showFolders, fullPath: boolean): TStringList;
var
  sr: TSearchRec;
  ec: integer;
begin
  Result := TStringList.Create;
  ec := FindFirst(filemask,faAnyFile,sr);

  while ec=0 do
  begin

     FindNext(sr);
  end;
  FindClose(sr);
end;

function WindowsFindFileList(filemask: string; showFiles, showFolders, fullPath: boolean): TStringList;
var
  h: THandle;
  wfa: WIN32_FIND_DATA;
  show: boolean;
 begin
  Result := TStringList.Create;
  h := Winapi.Windows.FindFirstFile(PChar(filemask),wfa);

  if h<>INVALID_HANDLE_VALUE then begin
    repeat
      show := true;
      if ((wfa.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)>0) and (not showfolders) then show := false;
      if ((wfa.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)=0) and (not showfiles) then show := false;
      if show then
      begin
        case fullPath of
            false: Result.Add(wfa.cFileName);
            true: Result.Add(ExtractFilePath(filemask)+wfa.cFileName);
        end;
      end;
    until not Winapi.Windows.FindNextFile(h,wfa);
  end;
  Winapi.Windows.FindClose(h);
end;

function GetFileSize(szFile: PChar): Int64;
var
  fFile        : THandle;
  wfd          : TWIN32FINDDATA;
begin
  result := 0;
  if not FileExists(szFile) then
    exit;
  fFile := FindFirstfile(pchar(szFile), wfd);
  if fFile = INVALID_HANDLE_VALUE then
    exit;
  result := (wfd.nFileSizeHigh * (Int64(MAXDWORD) + 1)) + wfd.nFileSizeLow;
  Winapi.windows.FindClose(fFile);
end;

//Result: filename = filesize
function FindAllFiles(RootFolder: string; Mask: string = '*.*';
  Recurse: Boolean = True): TStringList;
var
  SR   : TSearchRec;
  LStr : string;
begin
  Result := TStringList.Create;

  if RootFolder = '' then
    Exit;
//  if AnsiLastChar(RootFolder)^ <> '\' then
//    RootFolder := RootFolder + '\';
  RootFolder := IncludeTrailingPathDelimiter(RootFolder);

  if Recurse then
    if FindFirst(RootFolder + '*.*', faAnyFile, SR) = 0 then
    try
      repeat
        if SR.Attr and faDirectory = faDirectory then
          if (SR.Name <> '.') and (SR.Name <> '..') then
            FindAllFiles(RootFolder + SR.Name, Mask, Recurse);
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;

  if FindFirst(RootFolder + Mask, faAnyFile, SR) = 0 then
  try
    repeat
      if SR.Attr and faDirectory <> faDirectory then
      begin
        LStr := SR.Name + '=';
        LStr := LStr + IntToStr(GetFileSize(PChar(RootFolder + SR.Name)));
        Result.Add(LStr);
      end;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

function GetFirstFileNameIfExist(foldername, filemask: string): string;
var
  LStrList: TStringList;
begin
  Result := '';
  LStrList := FindAllFiles(foldername, filemask);

  if LStrList.Count > 0 then
    Result := LStrList.Names[0];
end;

end.
