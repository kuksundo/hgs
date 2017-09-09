unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UnitAlarmReportInterface,
  mORMot, mORMotHttpClient;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    FHTTPClient: TSQLRestClientURI;//TmORMotHTTPClient;
    FModel: TSQLModel;

    procedure StartHttp;
    procedure StopHttp;
    procedure Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser, AFlag: string);
  end;

var
  Form4: TForm4;

implementation

uses HHI_WebService, UnitHHIMessage;

{$R *.dfm}

{ TForm4 }

procedure TForm4.Button1Click(Sender: TObject);
var
  I: IAlarmReport;
begin
  StartHttp;
  try
    I := FHTTPClient.Service<IAlarmReport>;
  finally
    StopHttp;
  end;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  Send_Message('Head','Title','Content','A502166','A502166','B');
end;

procedure TForm4.Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser,
  AFlag: string);
var
  lstr,
  lcontent : String;
begin
//  헤더의 길이가 21byte를 넘지 않아야 함.
//  lhead := 'HiTEMS-문제점보고서';
//  ltitle   := '업무변경건';
  lcontent := AContent;

  if Aflag = 'B' then
  begin
    while True do
    begin
      if lcontent = '' then
        Break;

      if Length(lcontent) > 90 then
      begin
        lstr := Copy(lcontent,1,90);
        lcontent := Copy(lcontent,91,Length(lcontent)-90);
      end else
      begin
        lstr := Copy(lcontent,1,Length(lcontent));
        lcontent := '';
      end;

      //문자 메세지는 title(lstr)만 보낸다.
      Send_Message_Main_CODE(AFlag,ASendUser,ARecvUser,AHead,lstr,ATitle);
    end;
  end
  else
  begin
    lstr := lcontent;
    Send_Message_Main_CODE(AFlag,ASendUser,ARecvUser,AHead,lstr,ATitle);
  end;
end;

procedure TForm4.StartHttp;
begin
  if FModel = nil then
    FModel := TSQLModel.Create([],'root');

  FHTTPClient := TSQLHttpClient.Create('10.14.21.117','705',FModel);

  if not FHTTPClient.ServerTimeStampSynchronize then
    ShowMessage('Error');

  FHTTPClient.ServiceRegister([TypeInfo(IAlarmReport)], sicClientDriven);
end;

procedure TForm4.StopHttp;
begin
  FHTTPClient.Free;
  FModel.Free;
end;

end.
