unit progressDialog_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AdvCircularProgress;

type
  TprogressDialog_Frm = class(TForm)
    AdvCircularProgress1: TAdvCircularProgress;
    Label1: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FCnt : Integer;
  public
    { Public declarations }
  end;

var
  progressDialog_Frm: TprogressDialog_Frm;

implementation
uses
  CommonUtil_Unit;

{$R *.dfm}

procedure TprogressDialog_Frm.FormCreate(Sender: TObject);
begin
  FCnt := 0;
  Timer1.Enabled := True;
end;

procedure TprogressDialog_Frm.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TprogressDialog_Frm.Timer1Timer(Sender: TObject);
begin
  Inc(FCnt);
  Label1.Caption := 'elapsed : '+IntToStr(FCnt)+' sec';
end;

end.
