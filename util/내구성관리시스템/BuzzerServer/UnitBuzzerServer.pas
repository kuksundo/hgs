unit UnitBuzzerServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynCommons, mORMot,
  mORMotHttpServer, QLite, UnitBuzzerInterface, Vcl.Menus, UnitFrameCommServer;

type
  TServiceBuzzer = class(TInterfacedObject, IBuzzerServer)
  public
    function SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType: integer): string;
    function SetRedLampRetainPrev(ARedLamp: integer): string;
    function SetYellowLampRetainPrev(AYellowLamp: integer): string;
    function SetGreenLampRetainPrev(AGreenLamp: integer): string;
    function SetSoundRetainLamp(ASoundIndex: integer): string;
  end;

  TBuzzerServerF = class(TForm)
    MainMenu1: TMainMenu;
    Etc1: TMenuItem;
    LampTest1: TMenuItem;
    TFrameCommServer1: TFrameCommServer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LampTest1Click(Sender: TObject);
    procedure TFrameCommServer1StartMonitor1Click(Sender: TObject);
  private
    FServiceBuzzer: TServiceBuzzer;

    procedure TestLamp;
  public
    FRedLamp,
    FYellowLamp,
    FGreenLamp,
    FSoundIndex: integer;
  end;

var
  BuzzerServerF: TBuzzerServerF;

implementation

uses UnitLampTest, GetIp;

{$R *.dfm}

{ TForm3 }

procedure TBuzzerServerF.FormCreate(Sender: TObject);
begin
  FServiceBuzzer := TServiceBuzzer.Create;
//  TFrameCommServer1.FStartServerProc := CreateHttpServer;
  TFrameCommServer1.LblIP.Caption := GetLocalIP(0);
  TFrameCommServer1.CreateHttpServer(ALARM_ROOT_NAME, 'alarmtest.json', ALARM_PORT,
    TServiceBuzzer,[TypeInfo(IBuzzerServer)],sicShared);
end;

procedure TBuzzerServerF.FormDestroy(Sender: TObject);
begin
//  if Assigned(FHTTPServer) then
//    FHTTPServer.Free;
//
//  if Assigned(FRestServer) then
//    FRestServer.Free;
//
//  if Assigned(FModel) then
//    FModel.Free;
//
  if Assigned(FServiceBuzzer) then
    FServiceBuzzer.Free;
end;

procedure TBuzzerServerF.LampTest1Click(Sender: TObject);
begin
  TestLamp;
end;

procedure TBuzzerServerF.TestLamp;
var
  LampTestF: TLampTestF;
begin
  LampTestF := TLampTestF.Create(Self);

  try
    with LampTestF do
    begin
      ShowModal;
    end;
  finally
    LampTestF.Free;
  end;
end;

procedure TBuzzerServerF.TFrameCommServer1StartMonitor1Click(Sender: TObject);
begin

end;

{ TServiceBuzzer }
function TServiceBuzzer.SetGreenLampRetainPrev(AGreenLamp: integer): string;
begin
  with BuzzerServerF do
    Result := _SetLamp(FRedLamp, FYellowLamp, AGreenLamp, 0, FSoundIndex);
end;

function TServiceBuzzer.SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont,
  ASoundType: integer): string;
begin
  with BuzzerServerF do
  begin
    FRedLamp := ARedLamp;
    FYellowLamp := AYellowLamp;
    FGreenLamp := AYellowLamp;
    FSoundIndex := ASoundType;
  end;

  Result := _SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType);
end;

function TServiceBuzzer.SetRedLampRetainPrev(ARedLamp: integer): string;
begin
  with BuzzerServerF do
    Result := _SetLamp(ARedLamp, FYellowLamp, FGreenLamp, 0, FSoundIndex);
end;

function TServiceBuzzer.SetSoundRetainLamp(ASoundIndex: integer): string;
begin
  with BuzzerServerF do
    Result := _SetLamp(FRedLamp, FYellowLamp, FGreenLamp, 0, ASoundIndex);
end;

function TServiceBuzzer.SetYellowLampRetainPrev(AYellowLamp: integer): string;
begin
  with BuzzerServerF do
    Result := _SetLamp(FRedLamp, AYellowLamp, FGreenLamp, 0, FSoundIndex);
end;

end.
