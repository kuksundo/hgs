unit w_dzProgressTest;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  w_dzProgress;

type
  Tf_dzProgressTest = class(TForm)
    b_Start: TButton;
    procedure b_StartClick(Sender: TObject);
  private
  public
  end;

var
  f_dzProgressTest: Tf_dzProgressTest;

implementation

{$R *.dfm}

procedure Tf_dzProgressTest.b_StartClick(Sender: TObject);
var
  i: integer;
  frm: Tf_dzProgress;
  Aborted: Boolean;
begin
  frm := Tf_dzProgress.Create(Self);
  try
    frm.FormCaption := 'A Progress Form - %d of %d';
    frm.ProgressMax := 100;
    frm.Action := 'Action1';
    frm.Show;
    Aborted := false;
    i := 0;
    while not Aborted and (i <= 100) do begin
      sleep(100);
      inc(i, 5);
      frm.Progress(i, 'Action' + IntToStr(i), Aborted);
    end;
  finally
    frm.Free;
  end;
end;

end.

