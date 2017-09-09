unit UnitTileConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TTileConfigF = class(TForm)
    Label1: TLabel;
    RowNumEdit: TEdit;
    Label2: TLabel;
    ColNumEdit: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TileConfigF: TTileConfigF;

implementation

{$R *.dfm}

end.
