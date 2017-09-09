unit uHTTPs;

interface

uses WinInet, SysUtils, Windows, ShellAPI, Classes, IdHTTP, Forms, Dialogs;

function pCheckINIFile(AiniFilename, AUpdateFileName : AnsiString; var AVersion: string) : Boolean;
function fDownloadFileHTTP(RemoteFileName, LocalFileName : string) : Boolean;
function UpdateThroughHttp(AMainForm: TForm): string;

implementation

uses constUpdate;

//Server의 Update.exe version 과 Local의 Update.exe version이 다르면 Local의
//Update.exe file을 지움
//반환값: Server에 update할 파일이 있으면 True, Update할 파일이 Update.exe파일 뿐일경우 False
function pCheckINIFile(AiniFilename, AUpdateFileName: AnsiString; var AVersion: string) : Boolean;
type
  TFileVersion = Record
    FileName : String;
    FileVersion : String;
  end;
var
  slServerFileName, slLocalFileName : TStringList;
  i, j, nFileCount, nLocalArrayLength, nServerArrayLength : Integer;
  sFileDir : String;
  bLocalIniFileExist, bServerIniFileExist : Boolean;
  aServerFileVersion, aLocalFileVersion : Array of TFileVersion;
  IdHTTP : TIdHTTP;

begin
  Result := False;
  
  bLocalIniFileExist := True;
  bServerIniFileExist := True;
  IdHTTP := TIdHTTP.Create(nil);

  nLocalArrayLength := 0;
  nServerArrayLength := 0;

  sFileDir := ExtractFileDir(Application.ExeName) + '\';

  if FileExists(sFileDir + AiniFilename) then begin
    slLocalFileName := TStringList.Create;
    try
      slLocalFileName.LoadFromFile(sFileDir + AiniFilename);
      setLength(aLocalFileVersion, slLocalFileName.Count - 1);

      nFileCount := 0;

      if Length(aLocalFileVersion) > 1 then begin
        for i := 1 to slLocalFileName.Count - 1 do begin
          aLocalFileVersion[nFileCount].FileName := Copy(slLocalFileName[i], 0, Pos('=', slLocalFileName[i]) - 1);
          aLocalFileVersion[nFileCount].FileVersion := Copy(slLocalFileName[i], Pos('=', slLocalFileName[i]) + 1, Length(slLocalFileName[i]));
          inc(nFileCount);
        end;
      end
      else begin
        bLocalIniFileExist := False;
      end;
    except
      bLocalIniFileExist := False;
    end;

    nLocalArrayLength := Length(aLocalFileVersion) - 1;
    //slLocalFileName.Free;
  end
  else
    bLocalIniFileExist := False;

  if bLocalIniFileExist then begin
    slServerFileName := TStringList.Create;
    try
      slServerFileName.Text := IdHTTP.Get(SERVER_PATH + AiniFilename);

      setLength(aServerFileVersion, slServerFileName.Count - 1);

      nFileCount := 0;

      for i := 1 to slServerFileName.Count - 1 do begin
        aServerFileVersion[nFileCount].FileName := Copy(slServerFileName[i], 0, Pos('=', slServerFileName[i]) - 1);
        aServerFileVersion[nFileCount].FileVersion := Copy(slServerFileName[i], Pos('=', slServerFileName[i]) + 1, Length(slServerFileName[i]));
        inc(nFileCount);
      end;
    except
      bServerIniFileExist := False;
    end;

    nServerArrayLength := Length(aServerFileVersion) - 1;
    IdHTTP.Free;
    slServerFileName.Free;
  end;

  if bLocalIniFileExist and bServerIniFileExist then
  begin
    for i := 0 to nServerArrayLength do
    begin
      for j := 0 to nLocalArrayLength do
      begin
        if (aServerFileVersion[i].FileName = aLocalFileVersion[j].FileName) and
           (aServerFileVersion[i].FileVersion <> aLocalFileVersion[j].FileVersion) then
        begin
          if aServerFileVersion[i].FileName = AUpdateFileName then
          begin
            slLocalFileName.Delete(j+1);
            slLocalFileName.Add(AUpdateFileName + '=' + aServerFileVersion[i].FileVersion);
            slLocalFileName.SaveToFile(sFileDir + AiniFilename);
            
            if FileExists(sFileDir + AUpdateFileName) then
              DeleteFile(PWideChar(sFileDir + AUpdateFileName));
          end
          else
            Result := True;
        end;

        if aServerFileVersion[i].FileName = PROGRAM_FILE_NAME then
          AVersion := aServerFileVersion[i].FileVersion;
      end;
    end;
  end;

  if Assigned(slLocalFileName) then
    slLocalFileName.Free;
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
  LocalFile : file;
begin
  Result := True;

  GetMem(pBuffer, BLOCK_SIZE);

  if not DirectoryExists(ExtractFileDir(LocalFileName)) then begin
    ForceDirectories(ExtractFileDir(LocalFileName));
  end;

  AssignFile(LocalFile, LocalFileName);
  ReWrite(LocalFile, 1);

  hInet := InternetOpen(nil, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if (hInet <> nil) then begin
    hURL := InternetOpenUrl(hInet, PChar(RemoteFileName), nil, 0, INTERNET_FLAG_RELOAD, 0);
    if (hURL <> nil) then begin
      repeat
        begin
          Res := InternetReadFile(hURL, pBuffer, BLOCK_SIZE, BytesRead);
          BlockWrite(LocalFile, pBuffer^, BytesRead, BytesWritten);
        end;
      until (BytesRead = 0) and (Res);
      InternetCloseHandle(hURL);
      CloseFile(LocalFile);
    end
    else begin
      Result := False;
    end;

    InternetCloseHandle(hInet);
  end
  else begin
    Result := False;
  end;

  FreeMem(pBuffer);
end;

//메인 프로그램을 업데이트 함(Http를 이용)
//Update.exe파일을 서버로 부터 최신으로 update함.
//반환값: Version 정보가 반환됨
function UpdateThroughHttp(AMainForm: TForm): string;
var
  bStart : Boolean;
  LUpdateFilePath, LVersion : String;
begin
  LUpdateFilePath := ExtractFileDir(Application.ExeName) + '\' + UPDATE_FILE_NAME;
  bStart := pCheckINIFile(INI_FILE, UPDATE_FILE_NAME, LVersion);

  if not FileExists(LUpdateFilePath) then begin
    fDownloadFileHTTP(SERVER_PATH + UPDATE_FILE_NAME, LUpdateFilePath);
  end;

  if bStart then begin
    WinExec(PAnsiChar(UPDATE_FILE_NAME + ' ' + IntToStr(AMainForm.Handle)), SW_SHOW);
  end
  else
    ShowMessage('지금 실행중인 파일이 최신 버젼입니다.(Version:'+ LVersion+')');;
end;

end.
