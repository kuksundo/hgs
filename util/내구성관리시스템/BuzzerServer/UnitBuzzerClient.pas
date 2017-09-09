unit UnitBuzzerClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynCommons, mORMot, mORMotHttpClient,
  UnitBuzzerInterface, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  AdvScrollBox, UnitAlarmCollect;

type
  TForm3 = class(TForm)
    AdvScrollBox1: TAdvScrollBox;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel2: TPanel;
    Panel9: TPanel;
    Panel4: TPanel;
    Panel3: TPanel;
    Panel10: TPanel;
    Panel6: TPanel;
    Panel5: TPanel;
    Panel11: TPanel;
    Panel7: TPanel;
    Panel1: TPanel;
    Image1: TImage;
    Panel8: TPanel;
    Image2: TImage;
    Panel12: TPanel;
    Image3: TImage;
    Panel13: TPanel;
    Image4: TImage;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel20: TPanel;
    Button5: TButton;
    Panel21: TPanel;
    Button4: TButton;
    Panel22: TPanel;
    Button6: TButton;
    Panel23: TPanel;
    Button3: TButton;
    edit1: TEdit;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel28: TPanel;
    Label2: TLabel;
    AlarmServerIPEdit: TEdit;

    procedure Button5Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel9Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel10Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel11Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    procedure MakeAlarmListFile;
  public
    FAlarmClient: TSQLRestClientURI;
    FAlarmModel: TSQLModel;
    FAlarmList: TAlarmList;

    procedure CreateAlarmClient(AServerIP: string);
    procedure _SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType: integer);
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

{ TForm3 }

//방화벽->Inbound 규칙 생성하여 TCP Port 800번 허용 후 서버 연결 가능함
procedure TForm3.Button3Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,0);
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
  MakeAlarmListFile;
end;

procedure TForm3.Button5Click(Sender: TObject);
var
  Lip: string;
begin
  if AlarmServerIPEdit.Text <> '' then
    Lip := AlarmServerIPEdit.Text
  else
    Lip := 'localhost';

  CreateAlarmClient(Lip);
end;

procedure TForm3.Button6Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3.CreateAlarmClient(AServerIP: string);
begin
  if FAlarmClient = nil then
  begin
    if FAlarmModel = nil then
      FAlarmModel := TSQLModel.Create([],ALARM_ROOT_NAME);

    FAlarmClient := TSQLHttpClient.Create(AServerIP,ALARM_PORT,FAlarmModel);

    if not FAlarmClient.ServerTimeStampSynchronize then
    begin
      ShowMessage(UTF8ToString(FAlarmClient.LastErrorMessage));
      exit;
    end;

    //TSQLRestServerAuthenticationNone.ClientSetUser(Client,'User','');
    FAlarmClient.SetUser('User','synopse');
    FAlarmClient.ServiceRegister([TypeInfo(IBuzzerServer)],sicShared);
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  FAlarmList := TAlarmList.Create(nil);
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FAlarmList.Free;
end;

procedure TForm3.Image1Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,1);
end;

procedure TForm3.Image2Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,2);
end;

procedure TForm3.Image3Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,3);
end;

procedure TForm3.Image4Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,4);
end;

procedure TForm3.MakeAlarmListFile;
begin
  with FAlarmList.AlarmCollect.Add do
  begin
    AlarmName := 'VCB_G2_GEN_RUN';
    AlarmIndex := 37;
    BitIndex := 6;
    AlarmDesc := 'VCB_G2_GEN_RUN';
    AlarmType := '';
    AlarmValue := '';
    MinAlarmEnable := False;
    MaxAlarmEnable := False;
    MinFaultEnable := False;
    MaxFaultEnable := False;
    MinAlarmValue := 0.0;
    MinFaultValue := 0.0;
    MaxAlarmValue := 0.0;
    MaxFaultValue := 0.0;
    LampColor := lcGreen;
    LampType := ltBlink;
    SoundType := siPiPi;
    Duration := 3;
    UnitID := '';
  end;

  FAlarmList.SaveToJSONFile('E:\pjh\project\util\내구성관리시스템\bin\AlarmList.list');
end;

procedure TForm3.Panel10Click(Sender: TObject);
begin
  _SetLamp(0,2,0,0,0);
end;

procedure TForm3.Panel11Click(Sender: TObject);
begin
  _SetLamp(0,0,2,0,0);
end;

procedure TForm3.Panel2Click(Sender: TObject);
begin
  _SetLamp(1,0,0,0,0);
end;

procedure TForm3.Panel3Click(Sender: TObject);
begin
  _SetLamp(0,1,0,0,0);
end;

procedure TForm3.Panel4Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,0);
end;

procedure TForm3.Panel5Click(Sender: TObject);
begin
  _SetLamp(0,0,1,0,0);
end;

procedure TForm3.Panel6Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,0);
end;

procedure TForm3.Panel7Click(Sender: TObject);
begin
  _SetLamp(0,0,0,0,0);
end;

procedure TForm3.Panel9Click(Sender: TObject);
begin
  _SetLamp(2,0,0,0,0);
end;

procedure TForm3._SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont,
  ASoundType: integer);
var
  I: IBuzzerServer;
begin
  I := FAlarmClient.Service<IBuzzerServer>;

  if I <> nil then
    I.SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType);
end;

end.
