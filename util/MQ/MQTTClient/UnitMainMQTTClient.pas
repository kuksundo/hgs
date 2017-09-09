unit UnitMainMQTTClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitFrameMQTTClient;

type
  TMQTTClientF = class(TForm)
    FrameMQTTClient: TFrameMQTTClient;
    procedure FrameMQTTClientServerPingBtnClick(Sender: TObject);
    procedure FrameMQTTClientPublishBtnClick(Sender: TObject);
    procedure FrameMQTTClientSubscribeBtnClick(Sender: TObject);
    procedure FrameMQTTClientServerConnectBtnClick(Sender: TObject);
    procedure FrameMQTTClientServerDisconnectBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MQTTClientF: TMQTTClientF;

implementation

{$R *.dfm}

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

end.
