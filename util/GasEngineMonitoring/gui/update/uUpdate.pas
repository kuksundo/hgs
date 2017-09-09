unit uUpdate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls;

type
  TfmUpdate = class(TForm)
    Panel1: TPanel;
    MSG_1: TLabel;
    pb1: TProgressBar;
    pb2: TProgressBar;
    Bevel1: TBevel;
    Info: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TFileVersion = Record
    FileName : String;
    FileVersion : String;
    ToDownload : Boolean;
  end;

procedure pDownloadStatus(position : DWord; TotalPosition : DWord; Max : DWord; TotalMax : DWord);

var
  fmUpdate: TfmUpdate;
  aServerFileVersion, aLocalFileVersion : Array of TFileVersion;
  TotalFileSize : DWord;

implementation

uses
  UrlMon, WinInet, IdHTTP, uUtils, constUpdate;

{$R *.DFM}

function fGetTotalDownloadFileSize(sURL : AnsiString) : DWord;
var
  i : Integer;
  dwTotalDownFileSize : DWord;
  IdHTTP : TIdHTTP;
begin
  dwTotalDownFileSize := 0;
  IdHTTP := TIdHTTP.Create(nil);

  for i := 0 to Length(aServerFileVersion) - 1 do
  begin
    if aServerFileVersion[i].ToDownload then
    begin
      IdHTTP.Head(Trim(sURL + aServerFileVersion[i].FileName));
      dwTotalDownFileSize := dwTotalDownFileSize + IdHTTP.Response.ContentLength
    end;
  end;

  IdHTTP.Free;
  Result := dwTotalDownFileSize;
end;

procedure pDownloadStatus(position : DWord; TotalPosition : DWord; Max : DWord; TotalMax : DWord);
begin
  fmUpdate.pb1.Max := Max;
  fmUpdate.pb2.Max := TotalMax;
  fmUpdate.pb1.Position := Position;
  fmUpdate.pb2.Position := TotalPosition;
end;

procedure pLoadIniFile(sURL : AnsiString);
var
  slServerFileName, slLocalFileName : TStringList;
  i, j, nFileCount, nServerArrayLength, nLocalArrayLength, nPicDirValue : Integer;
  sFileDir : String;
  bDownloadFileExist, bLocalIniFileExist, bIniFileExist : Boolean;
  IdHTTP : TIdHTTP;
begin
  bDownloadFileExist := False;
  bLocalIniFileExist := True;
  bIniFileExist := False;

  IdHTTP := TIdHTTP.Create(nil);

  sFileDir := ExtractFileDir(Application.ExeName) + '\';

  if FileExists(sFileDir + INI_FILE) then
  begin
    try
      slLocalFileName := TStringList.Create;

      slLocalFileName.LoadFromFile(sFileDir + INI_FILE);
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
  end
  else
    bLocalIniFileExist := False;

  nLocalArrayLength := Length(aLocalFileVersion) - 1;

  try
    slServerFileName := TStringList.Create;
    slServerFileName.Text := IdHTTP.Get(sURL + INI_FILE);

    setLength(aServerFileVersion, slServerFileName.Count - 1);

    nFileCount := 0;

    for i := 1 to slServerFileName.Count - 1 do begin
      aServerFileVersion[nFileCount].FileName := Copy(slServerFileName[i], 0, Pos('=', slServerFileName[i]) - 1);
      aServerFileVersion[nFileCount].FileVersion := Copy(slServerFileName[i], Pos('=', slServerFileName[i]) + 1, Length(slServerFileName[i]));
      inc(nFileCount);
    end;
  except
//    showMessage('서버의 Ini File을 열수 없습니다.');

    slLocalFileName.Free;
    slServerFileName.Free;
    IdHTTP.Free;

    Application.Terminate;
    WinExec(PChar(PROGRAM_FILE_NAME + ' ' + UPDATE_STAMP), SW_SHOW);
  end;

  nServerArrayLength := Length(aServerFileVersion) - 1;

  for i := 0 to nServerArrayLength do begin
    aServerFileVersion[i].ToDownload := False;
  end;

  if bLocalIniFileExist then begin
    for i := 0 to nServerArrayLength do
    begin
      bIniFileExist := False;

      for j := 0 to nLocalArrayLength do
      begin
        if FileExists(sFileDir + aServerFileVersion[i].FileName) then
        begin
          if (aServerFileVersion[i].FileName = aLocalFileVersion[j].FileName) then
          begin
            if (aServerFileVersion[i].FileVersion <> aLocalFileVersion[j].FileVersion) then
              if aServerFileVersion[i].FileName <> UPDATE_FILE_NAME then
                aServerFileVersion[i].ToDownload := True;

            bIniFileExist := True;
          end;
        end
        else
        begin
          aServerFileVersion[i].ToDownLoad := True;
          Break;
        end;
      end;//for

      if not bIniFileExist then
        aServerFileVersion[i].ToDownLoad := True;
    end;//for
  end
  else begin
    for i := 0 to nServerArrayLength do begin
      aServerFileVersion[i].ToDownload := True;
    end;
  end;

  bDownloadFileExist := False;

  for i := 0 to nServerArrayLength do begin
    if aServerFileVersion[i].ToDownload then begin
      bDownloadFileExist := True;
      break;
    end;
  end;

  if bDownloadFileExist then begin
//    fmUpdate.Visible := True;

    fmUpdate.Left := (Screen.Width - fmUpdate.Width) div 2;
    fmUpdate.Top := (Screen.Height - fmUpdate.Height) div 2;
    fmUpdate.Show;

    for i := 0 to nServerArrayLength do begin
      if (aServerFileVersion[i].FileName = INI_FILE) then begin
        aServerFileVersion[i].ToDownload := True;
        Break;
      end;
    end;

    fmUpdate.MSG_1.Caption := '';
    fmUpdate.Info.Caption := '파일을 업데이트 합니다.' + #13#10 + '잠시만 기다려 주세요.';
    TotalFileSize := fGetTotalDownloadFileSize(sURL);

//    fmUpdate.Show;

    for i := 0 to nServerArrayLength do begin
      if aServerFileVersion[i].ToDownload then begin
        fmUpdate.MSG_1.Caption := aServerFileVersion[i].FileName;
        fDownloadFileHTTP(PChar(sURL + aServerFileVersion[i].FileName), PChar(sFileDir + aServerFileVersion[i].FileName));
      end;
    end;

    slServerFileName.SaveToFile(sFileDir + INI_FILE);

  end;

  slLocalFileName.Free;
  slServerFileName.Free;
  IdHTTP.Free;

  Application.Terminate;
  WinExec(PChar(PROGRAM_FILE_NAME + ' ' + UPDATE_STAMP), SW_SHOW);
end;

procedure TfmUpdate.FormCreate(Sender: TObject);
begin
  TotalFileSize := 0;
  BytesReadUntilNow := 0;

  fmUpdate.Left := -500;
  fmUpdate.Top := -500;

  try
    pLoadIniFile(SERVER_PATH);
  except
    showMessage('업데이트에 실패하였습니다.');
    Application.Terminate;
    WinExec(PChar(PROGRAM_FILE_NAME + ' ' + UPDATE_STAMP), SW_SHOW);
  end;
end;

end.
