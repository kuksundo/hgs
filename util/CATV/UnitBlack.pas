unit UnitBlack;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TBlackF = class(TForm)
    Panel1: TPanel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  BlackF: TBlackF;

implementation

{$R *.dfm}

procedure TBlackF.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.Style := Params.Style or WS_BORDER;// or WS_THICKFRAME;
end;

procedure TBlackF.FormHide(Sender: TObject);
begin
  ShowCursor(True);
end;

procedure TBlackF.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = vk_Escape  then
    BlackF.Hide;
end;

procedure TBlackF.FormShow(Sender: TObject);
begin
  ShowCursor(False);
end;

end.
