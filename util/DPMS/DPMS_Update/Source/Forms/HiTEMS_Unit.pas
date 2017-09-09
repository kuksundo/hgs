unit HiTEMS_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBaseDlg, JvProgressDialog, Ora, DB;

type
  TStreamProgressEvent = procedure(Sender:TObject; Percentage:Single) of Object;
  TProgressFileStream = class(TFileStream)
  private
    FOnProgress:TStreamProgressEvent;
    FProcessed : Int64;
    FSize : Int64;
  public
    procedure InitProgressCounter(aSize:Int64);
    function Read(var Buffer; Count:Integer):Integer;override;
    function Write(const Buffer; Count:Integer):Integer;override;
    property OnProgress:TStreamProgressEvent read FOnProgress write FOnProgress;

  end;

type
  THiTEMS_Frm = class(TForm)
    JvProgressDialog1: TJvProgressDialog;
  private
    { Private declarations }
    procedure StreamProgress(Sender:TObject; Percentage:Single);
  public
    { Public declarations }
    procedure Check_for_Update;
  end;

var
  HiTEMS_Frm: THiTEMS_Frm;
  procedure Open_HiTEMS;

implementation
uses
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure Open_HiTEMS;
var
  aHwnd : HWND;
begin
  HiTEMS_Frm := THiTEMS_Frm.Create(Application);
  try
    with HiTEMS_Frm do
    begin
      aHwnd := FindWindow(nil,'HiTEMS [HiMSEN Test Evaluation & Management System]');
      if aHwnd > 0then
      begin
        SetForegroundWindow(aHwnd);
        SendMessage(aHwnd,WM_SETFOCUS,0,0);
        Close;
      end else
        Check_for_Update;

    end;
  finally
    FreeAndNil(HiTEMS_Frm);
  end;

end;
{ TProgressFileStream }

procedure TProgressFileStream.InitProgressCounter(aSize: Int64);
begin
  FProcessed := 0;
  if aSize <= 0 then
    FSize := 1
  else
    FSize := aSize;

  if Assigned(FOnProgress) then
    FOnProgress(Self,0);
end;

function TProgressFileStream.Read(var Buffer; Count: Integer): Integer;
begin
  Result := inherited Read(Buffer, Count);
  Inc(FProcessed, Result);
  if Assigned(FOnProgress) then
    FOnProgress(Self, FProcessed / FSize);
end;

function TProgressFileStream.Write(const Buffer; Count: Integer): Integer;
begin
  Result := inherited Write(Buffer, Count);
  Inc(FProcessed, Result);
  if Assigned(FOnProgress) then
    FOnProgress(Self, FProcessed / FSize);
end;

{ THiTEMS_Frm }

procedure THiTEMS_Frm.Check_for_Update;
begin
  TThread.Queue(nil,
  procedure
  const
    defaultPath = 'C:\Temp\HiTEMS\';
  var
    OraQuery : TOraQuery;
    Stream : TProgressFileStream;
    appCode,
    appName,
    lFileName: String;
    lastWriteTime : TDateTime;

    function Download_Application(aAppCode,aAppName,aFileName:string):Boolean;
    begin
      Result := False;
      Stream := TProgressFileStream.Create(aFileName, fmCreate);
      try
        JvProgressDialog1.Caption := aAppName;
        JvProgressDialog1.Show;
        try
          OraQuery := TOraQuery.Create(nil);
          try
            OraQuery.Session := DM1.OraSession1;
            OraQuery.Options.TemporaryLobUpdate := True;
            JvProgressDialog1.Text := '업데이트 파일 오픈   ';
            with OraQuery do
            begin
              Close;
              SQL.Clear;
              SQL.Add('SELECT * FROM APP_VERSION  ' +
                      'WHERE VERNO = ( ' +
                      '                 SELECT MAX(VERNO) FROM APP_VERSION ' +
                      '                 WHERE APPCODE = :param1 ' +
                      '              ) ');

              ParamByName('param1').AsString := appCode;
              Open;

              JvProgressDialog1.Text := '다운로드 시작   ';

              Stream.OnProgress := StreamProgress;
              Stream.InitProgressCounter(TBlobField(FieldByName('FILES')).BlobSize);
              TBlobField(FieldByName('FILES')).SaveToStream(Stream);

              JvProgressDialog1.Text := '다운로드 완료   ';
              JvProgressDialog1.Text := '실행   ';
              Result := True;
            end;
          finally
            FreeAndNil(OraQuery);
          end;
        finally
          JvProgressDialog1.Hide;
        end;
      finally
        FreeAndNil(stream);
      end;
    end;
  begin
    appName := 'HiTEMS';
    appCode := '20131119111223777';
    if appCode <> '' then
    begin
      if not DirectoryExists(defaultPath) then
        CreateDir(defaultPath);

      lFileName := defaultPath+appCode+'.exe';
      if FileExists(lFileName) then
      begin
        lastWriteTime := GetFileLastWriteTime(lFileName);
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT APPCODE, LASTWRITETIME FROM APP_VERSION ' +
                  'WHERE APPCODE = :param1 ' +
                  'AND TO_DATE(LASTWRITETIME,''YYYY-MM-DD HH24:MI:SS'') > :param2 ');
          ParamByName('param1').AsString := appCode;
          ParamByName('param2').AsDateTime := lastWriteTime;
          Open;

          if RecordCount <> 0 then
          begin
            DeleteFile(lFileName);//기존 파일삭제
            if Download_Application(appCode,appName,lFileName) then
              ExecNewProcess2(lFileName,'');
          end
          else
          begin
            ExecNewProcess2(lFileName,'');
          end;
        end;
      end else
        if Download_Application(appCode,appName,lFileName) then
          ExecNewProcess2(lFileName,'');
    end;
  end);
end;

procedure THiTEMS_Frm.StreamProgress(Sender: TObject; Percentage: Single);
begin
  JvProgressDialog1.Position := Round(Percentage * JvProgressDialog1.Max);
  Application.ProcessMessages;
  Sleep(5);
end;

end.
