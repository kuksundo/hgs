unit UnitSimulatedValueInput;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TSimulatedValueInputF = class(TForm)
    Label1: TLabel;
    SimValueEdit: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SimulatedValueInputF: TSimulatedValueInputF;

implementation

{$R *.dfm}

end.
