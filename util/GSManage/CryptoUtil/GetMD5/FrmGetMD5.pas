unit FrmGetMD5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UnitCryptUtil;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  Edit2.Text := GetMD5HashStringFromIndy(Edit1.Text);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  if CheckMD5HashStringFromIndy(Edit1.Text,Edit2.Text) then
    ShowMessage('Matched')
  else
    ShowMessage('Not Matched');
end;

end.
