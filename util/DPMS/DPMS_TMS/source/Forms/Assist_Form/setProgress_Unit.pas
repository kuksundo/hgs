unit setProgress_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NxEdit,
  AdvSmoothProgressBar;

type
  TsetProgress_Frm = class(TForm)
    AdvSmoothProgressBar1: TAdvSmoothProgressBar;
    Label1: TLabel;
    values: TNxNumberEdit;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure valuesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  setProgress_Frm: TsetProgress_Frm;
  function Create_setProgress(aProgress,aX,aY:Integer) : Integer;

implementation
uses
  taskMain_Unit;

{$R *.dfm}

function Create_setProgress(aProgress,aX,aY:Integer) : Integer;
begin
  setProgress_Frm := TsetProgress_Frm.Create(nil);
  try
    with setProgress_Frm do
    begin
      Left := aX;
      Top := aY;

      AdvSmoothProgressBar1.Position := aProgress;
      values.Value := aProgress;
      ShowModal;
      Result := values.AsInteger;
    end;
  finally
    FreeAndNil(setProgress_Frm);
  end;
end;

procedure TsetProgress_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TsetProgress_Frm.valuesChange(Sender: TObject);
begin
  AdvSmoothProgressBar1.Position := values.AsInteger;
end;

end.


