unit Dump_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, shellapi, AdvCombo,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TDump_Frm = class(TForm)
    Panel2: TPanel;
    Button1: TButton;
    tablelist: TAdvComboBox;
    DateTimePicker2: TDateTimePicker;
    DateTimePicker1: TDateTimePicker;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tablelistSelect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    tableValue : String;
  end;

var
  Dump_Frm: TDump_Frm;

implementation
uses
DataModule_Unit;
{$R *.dfm}

procedure TDump_Frm.Button1Click(Sender: TObject);
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  ExecuteFile, ParamString, StartInString: string;

begin

end;

procedure TDump_Frm.FormCreate(Sender: TObject);
var
li : integer;
Value : String;
begin

end;

procedure TDump_Frm.tablelistSelect(Sender: TObject);
begin
  tableValue := tablelist.Text;
end;

end.
