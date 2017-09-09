unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, Vcl.ExtCtrls;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    AdvSG1: TAdvStringGrid;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button2Click(Sender: TObject);
begin
  AdvSG1.ColCount := 4;
  AdvSG1.RowCount := 5;

  AdvSG1.Cells[0,0] := 'Engine Type';
  AdvSG1.Cells[1,0] := '금주 실적' + #13#10 + '(1.12 ~ 1.16)';
  AdvSG1.Cells[2,0] := '차주 계획' + #13#10 + '(1.19 ~ 1.23)';
  AdvSG1.Cells[3,0] := '비 고';


end;

end.
