unit Speed_Unit;

interface

uses
  LocalData_Unit, Value_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, AdvGlowButton,
  Vcl.StdCtrls;

type
  TSpeed_Frm = class(TForm)
    Panel1: TPanel;
    AdvGlowButton3: TAdvGlowButton;
    Panel2: TPanel;
    AdvGlowButton1: TAdvGlowButton;
    DATA_1: TEdit;
    DATA_2: TEdit;
    DATA_3: TEdit;
    indate: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    FOwner : TLocalData_Frm;
    { Public declarations }
  end;

var
  Speed_Frm: TSpeed_Frm;

implementation
uses
DataModule_Unit;

{$R *.dfm}

procedure TSpeed_Frm.FormCreate(Sender: TObject);
var
  indatestr : string;
begin
  indatestr := indate.Text;

  

end;

end.
