unit NewDept_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, NxCollection,
  CurvyControls, Vcl.Imaging.pngimage;

type
  TEng_6H_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel32: TPanel;
    CurvyPanel2: TCurvyPanel;
    Panel30: TPanel;
    ENGTYPE: TPanel;
    NxImage1: TNxImage;
    Panel3: TPanel;
    PROJNO: TPanel;
    Panel4: TPanel;
    PROJNAME: TPanel;
    Panel5: TPanel;
    ENGINEIN: TPanel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FOwner : TMain_Frm;
  end;

var
  Eng_6H_Frm: TEng_6H_Frm;

implementation
USES
DataModule_unit;
{$R *.dfm}

procedure TEng_6H_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TEng_6H_Frm.FormCreate(Sender: TObject);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_INFO ' +
            'WHERE ENGTYPE = '''+'6H17/28U'+''' ');
    Open;

    ENGTYPE.Caption := FieldByname('ENGTYPE').AsString;
    PROJNO.Caption := FieldByname('PROJNO').AsString;
    PROJNAME.Caption := FieldByname('PROJNAME').AsString;
    ENGINEIN.Caption := FieldByname('ENGIN').AsString;

    ExecSQL;
  end;
end;

end.
