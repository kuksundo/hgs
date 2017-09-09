unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitOutLookUtil, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    dt_From: TDateTimePicker;
    dt_To: TDateTimePicker;
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
var
  LStr: string;
begin
  LStr := CreateNewAppointment('약속', '바디임', '위치', now, now+0.05, 1);
//  ShowMessage(LStr);
  CreateOrUpdateAppointment(LStr, '약속', '바디임', '위치', now, now+0.05, 1);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  dt_From.Time := 0;
  dt_To.Time := StrToTime('23:59:59');
  GetApplintmentBetweenDate(dt_From.Date, dt_To.Date);
end;

end.
