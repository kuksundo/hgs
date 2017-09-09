unit UnitMainDataSave2MongoDBFromMQTT;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UnitFrameMQTTClient, UnitSaveData2MongoDB.Events;

type
  TMQTTClientF = class(TForm)
    FrameMQTTClient: TFrameMQTTClient;
    procedure FrameMQTTClientServerPingBtnClick(Sender: TObject);
    procedure FrameMQTTClientPublishBtnClick(Sender: TObject);
    procedure FrameMQTTClientSubscribeBtnClick(Sender: TObject);
    procedure FrameMQTTClientServerConnectBtnClick(Sender: TObject);
    procedure FrameMQTTClientServerDisconnectBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure InitVar;
  public
    { Public declarations }
  end;

var
  MQTTClientF: TMQTTClientF;

implementation

{$R *.dfm}

procedure TMQTTClientF.FormCreate(Sender: TObject);
begin
  Caption := 'Save Data To MongoDB';
end;

procedure TMQTTClientF.FrameMQTTClientPublishBtnClick(Sender: TObject);
begin
  FrameMQTTClient.PublishBtnClick(Sender);
end;

procedure TMQTTClientF.FrameMQTTClientServerConnectBtnClick(Sender: TObject);
begin
  FrameMQTTClient.ServerConnectBtnClick(Sender);
end;

procedure TMQTTClientF.FrameMQTTClientServerDisconnectBtnClick(Sender: TObject);
begin
  FrameMQTTClient.ServerDisconnectBtnClick(Sender);
end;

procedure TMQTTClientF.FrameMQTTClientServerPingBtnClick(Sender: TObject);
begin
  FrameMQTTClient.ServerPingBtnClick(Sender);
end;

procedure TMQTTClientF.FrameMQTTClientSubscribeBtnClick(Sender: TObject);
begin
  FrameMQTTClient.SubscribeBtnClick(Sender);
end;

procedure TMQTTClientF.InitVar;
begin

end;

end.
