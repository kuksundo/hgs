unit DisplayU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons,
  DSPack, CommonU, StdCtrls;

type
  TDisplayF = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    Panel2: TPanel;
    Label1: TLabel;
    imgDisplay: TImage;
    lbServerSt: TLabel;
    Label2: TLabel;
    lbClientSt: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  DisplayF: TDisplayF;

implementation

uses
  dmMainU, SettingsU;

{$R *.dfm}

procedure TDisplayF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with dmMain.fgMain do
    if Active then begin
      Stop;
      Active := false;
    end;
end;

procedure TDisplayF.FormCreate(Sender: TObject);
begin
  Left := 0;
  Top := 0;
end;

procedure TDisplayF.SpeedButton1Click(Sender: TObject);
begin
  SettingsF.Show;
end;

procedure TDisplayF.FormActivate(Sender: TObject);
begin
  if SettingsF = nil then
    SettingsF := TSettingsF.Create(Application);
end;

end.
