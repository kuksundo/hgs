unit UnitSetValue;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, AdvEdit;

type
  TSetCalarValueF = class(TForm)
    XCurValueEdit: TAdvEdit;
    XLabel: TLabel;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetCalarValueF: TSetCalarValueF;

implementation

{$R *.dfm}

end.
