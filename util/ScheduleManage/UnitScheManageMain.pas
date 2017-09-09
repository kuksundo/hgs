unit UnitScheManageMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, Vcl.ExtCtrls, AdvNavBar,
  NxCollection;

type
  TForm1 = class(TForm)
    ImageList32x32: TImageList;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    AdvNavBar1: TAdvNavBar;
    AdvNavBarPanel1: TAdvNavBarPanel;
    NxSplitter1: TNxSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
