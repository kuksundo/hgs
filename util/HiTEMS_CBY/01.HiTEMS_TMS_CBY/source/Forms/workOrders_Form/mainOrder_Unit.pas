unit mainOrder_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ImgList, Vcl.ComCtrls, JvExControls, JvLabel, AeroButtons,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Vcl.Imaging.pngimage, AdvOfficeStatusBar;

type
  TmainOrder_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList24x24: TImageList;
    AeroButton2: TAeroButton;
    AeroButton1: TAeroButton;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    Image2: TImage;
    Label1: TLabel;
    procedure AeroButton1Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainOrder_Frm: TmainOrder_Frm;

implementation
uses
  workOrder_Unit,
  makeOrder_Unit;

{$R *.dfm}

procedure TmainOrder_Frm.AeroButton1Click(Sender: TObject);
var
  LForm : TmakeOrder_Frm;
begin
  LForm := TmakeOrder_Frm.Create(Application);
  try
    with LForm do
    begin
      ShowModal;
    end;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure TmainOrder_Frm.AeroButton2Click(Sender: TObject);
var
  LForm : TworkOrder_Frm;
begin
  LForm := TworkOrder_Frm.Create(Self);
  try
    with LForm do
    begin
      ShowModal;
    end;
  finally
    FreeAndNil(LForm);
  end;
end;

end.
