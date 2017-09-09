unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CopyData, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  SendHandleCopyData(StrToInt(Edit1.Text), WM_COPYDATA, 0);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  SendMessage(StrToInt(Edit1.Text), WM_CLOSE, 0, 0);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Edit1.Text := IntToStr(SendCopyData('aaa','Modbus Communication', 'aaa', 0));
end;

end.
