unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  WT1600Connection, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FWT1600Connection: TWT1600Connection;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FWT1600Connection := TWT1600Connection.Create(0,'');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FWT1600Connection.Finish;
  FWT1600Connection.Free;
end;

end.
