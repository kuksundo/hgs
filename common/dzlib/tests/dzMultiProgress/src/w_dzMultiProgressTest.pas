unit w_dzMultiProgressTest;

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
  w_dzMultiProgress;

type
  Tf_dzProgressTest = class(TForm)
    b_Start: TButton;
    ed_Count: TEdit;
    l_Count: TLabel;
    procedure b_StartClick(Sender: TObject);
  private
    FProgressForm: Tf_dzMultiProgress;
    procedure doWork(_Sender: TObject);
  end;

var
  f_dzProgressTest: Tf_dzProgressTest;

implementation

{$R *.dfm}

procedure Tf_dzProgressTest.doWork(_Sender: TObject);
var
  i, j, k: Integer;
begin
  i := 0;
  while (i < 100) do begin
    Inc(i, 5);
    FProgressForm.Progress(0, i, 'Action ' + IntToStr(i));
    j := 0;
    while (j < 500) do begin
      Inc(j, 50);
      FProgressForm.Progress(1, j, 'Action ' + IntToStr(i) + '.' + IntToStr(j));
      k := 0;
      while (k < 500) do begin
        Sleep(50);
        Inc(k, 20);
        FProgressForm.Progress(2, k, 'Action ' + IntToStr(i) + '.' + IntToStr(j) + '.' + IntToStr(k));
      end;
    end;
  end;
end;

procedure Tf_dzProgressTest.b_StartClick(Sender: TObject);
var
  cnt: Integer;
  i: Integer;
begin
  FProgressForm := Tf_dzMultiProgress.Create(Self);
  try
    cnt := StrToInt(ed_Count.Text);
    FProgressForm.Init('A Progress Form - %d of %d', cnt);
    for i := 1 to cnt - 1 do
      FProgressForm.ProgressMax[i] := 500;
    FProgressForm.ShowProgressModal(doWork);
  finally
    FProgressForm.Free;
  end;
end;

end.
