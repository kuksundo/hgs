unit checkPart_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothListBox, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, Vcl.StdCtrls, AeroButtons,
  JvExControls, JvLabel, Vcl.ImgList;

type
  TcheckPart_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    Panel1: TPanel;
    JvLabel1: TJvLabel;
    btn_Close: TAeroButton;
    AdvStringGrid1: TAdvStringGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  checkPart_Frm: TcheckPart_Frm;

implementation

{$R *.dfm}

end.
