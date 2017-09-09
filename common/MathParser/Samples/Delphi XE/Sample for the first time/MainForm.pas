unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TMain = class(TForm)
    bCalculate: TButton;
    leOutput: TLabeledEdit;
    leInput: TLabeledEdit;
    procedure bCalculateClick(Sender: TObject);
  end;

var
  Main: TMain;

implementation

uses
  CalcUtils;

{$R *.dfm}

procedure TMain.bCalculateClick(Sender: TObject);
begin
  leOutput.Text := AsString( leInput.Text );
end;

end.
