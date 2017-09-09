unit UnitSetMatrixConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvOfficeButtons, Vcl.StdCtrls,
  AdvGlowButton, AdvOfficeSelectors, AdvGroupBox;

type
  TSetMatrixConfigF = class(TForm)
    AdvGroupBox1: TAdvGroupBox;
    LowAlarmGroup: TAdvGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ColorResolutionEdit: TEdit;
    FromColorSelector: TAdvOfficeColorSelector;
    MinAlarmBlinkCB: TCheckBox;
    Label3: TLabel;
    ToColorSelector: TAdvOfficeColorSelector;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetMatrixConfigF: TSetMatrixConfigF;

implementation

{$R *.dfm}

end.
