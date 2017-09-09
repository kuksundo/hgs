unit uUtils;

interface

uses
  WinInet, SysUtils, Windows, messages, Dialogs, ShellAPI, Forms, Registry,
  Classes, constUpdate, idHTTP, Controls, uHTTPs;

function DeleteDirFile(const DirName : string) : Boolean;
function fGetLocation(const Value : Integer) : String;
function fGetLocName(const Value : Integer) : String;
function CreateConfig : TRegIniFile;
function CloseMainWindow: Boolean;
function fDownloadFileHTTP(RemoteFileName, LocalFileName: string): Boolean;

implementation

uses uUpdate;

function CreateConfig: TRegIniFile;
begin
  Result := TRegIniFile.Create;
  Result.OpenKey( 'Software\KoTu3\', True );
end;

function fGetLocName(const Value : Integer) : String;
begin
end;

function fGetLocation(const Value : Integer) : String;
begin
end;

function DeleteDirFile(const DirName : string) : Boolean;
var SHFileOpStruct: TSHFileOpStruct;
    DirBuf: array [0..255] of char;
    Directory: string;
begin
  try
    Directory := ExcludeTrailingPathDelimiter(DirName);
    Fillchar(SHFileOpStruct, sizeof(SHFileOpStruct), 0);
    FillChar(DirBuf, sizeof(DirBuf), 0);
    StrPCopy(DirBuf, Directory);
    with SHFileOpStruct do
    begin
      Wnd := 0;
      pFrom := @DirBuf;
      wFunc := FO_DELETE;
//            fFlags := fFlags or FOF_ALLOWUNDO; // 휴지통에 담기
      fFlags := fFlags or FOF_NOCONFIRMATION;
      fFlags := fFlags or FOF_SILENT;
    end;

    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := False;
  end;
end;

//Update 하기 전에 메인프로그램 종료하는 함수
function CloseMainWindow: Boolean;
var
  dwResult : DWord;
  MainWnd: THandle;
  MainProcessID: LongWord;
  MainProcess: THandle;
begin
  Result := True;

  try
    MainWnd := StrToInt(ParamStr(1));
    if isWindow(MainWnd) then
    begin
      SendMessageTimeout(MainWnd, WM_CLOSE, 0, 0, SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, dwResult);
      GetWindowThreadProcessId(MainWnd, @MainProcessID);
      if MainProcessID <> 0 then
      begin
        MainProcess := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION, False, MainProcessID);
        if MainProcess <> 0 then
        begin
        { Terminate the process }
          TerminateProcess(MainProcess, 0);    // <----- 여기
          CloseHandle(MainProcess);
          Result := True;
        end;
      end;
    end
    else
      Result := False;

  except
    showMessage('정상적인 접근이 아닙니다.');
  end;
end;

function fDownloadFileHTTP(RemoteFileName, LocalFileName: string): Boolean;
const
  BLOCK_SIZE = 8192;
var
  hInet : HINTERNET;
  hURL : HINTERNET;
  Res : Boolean;
  pBuffer : Pointer;
  BytesRead : DWord;
  BytesWritten : LongInt;
  TotalBytesRead : DWord;
  FileSize : DWord;
  LocalFile : file;
  IdHTTP : TIdHTTP;
begin
  Screen.Cursor := crHourglass;

  Result := True;
  TotalBytesRead := 0;
  IdHTTP := TIdHTTP.Create(nil);

  GetMem(pBuffer, BLOCK_SIZE);

  if not DirectoryExists(ExtractFileDir(LocalFileName)) then
  begin
    ForceDirectories(ExtractFileDir(LocalFileName));
  end;

  AssignFile(LocalFile, LocalFileName);
  ReWrite(LocalFile, 1);

  hInet := InternetOpen(nil, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if (hInet <> nil) then
  begin
    hURL := InternetOpenUrl(hInet, PChar(RemoteFileName), nil, 0, INTERNET_FLAG_RELOAD, 0);
    IdHTTP.Head(RemoteFileName);
    FileSize := IdHTTP.Response.ContentLength;
    if (hURL <> nil) then
    begin
      repeat
        begin
          Res := InternetReadFile(hURL, pBuffer, BLOCK_SIZE, BytesRead);
          BlockWrite(LocalFile, pBuffer^, BytesRead, BytesWritten);
          TotalBytesRead := TotalBytesRead + BytesRead;
          BytesReadUntilNow := BytesReadUntilNow + BytesRead;
          pDownloadStatus(TotalBytesRead, BytesReadUntilNow, FileSize, TotalFileSize);
          Application.ProcessMessages;
        end;
      until (BytesRead = 0) and (Res);
      InternetCloseHandle(hURL);
      CloseFile(LocalFile);
    end
    else
    begin
      ShowMessage('Failure during InternetOpenUrl ' + pchar(hInet));
      Result := False;
    end;
    InternetCloseHandle(hInet);

  end
  else
  begin
    ShowMessage('Failure during InternetOpen');

    Result := False;
  end;

  FreeMem(pBuffer);
  IdHTTP.Free;
  Screen.Cursor := crDefault;
end;

end.
