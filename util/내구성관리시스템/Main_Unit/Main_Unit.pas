unit Main_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, HotSpotImage,
  NxCollection, AdvOfficeStatusBar, Vcl.ImgList, AdvOfficeHint, AdvToolBar,
  AdvToolBarStylers, AdvOfficeStatusBarStylers, AdvSmoothPopup,
  Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.ComCtrls;

type
  TMain_Frm = class(TForm)
    Panel1: TPanel;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel2: TPanel;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvOfficeHint1: TAdvOfficeHint;
    ImageList1: TImageList;
    HotSpotImage1: THotSpotImage;
    TreeView1: TTreeView;
    procedure HotSpotImage1HotSpotClick(Sender: TObject; HotSpot: THotSpot);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Main_Frm: TMain_Frm;

implementation
uses
  engView_Unit,
  Network_Unit,
  ControlPanel_Unit,
  Network_Sub2_Unit;

{$R *.dfm}

procedure TMain_Frm.HotSpotImage1HotSpotClick(Sender: TObject;
  HotSpot: THotSpot);
var
  lName : String;
begin
  if Pos('(Engine)', HotSpot.Name) > 0  then
  begin
    lName := 'EG';
    Create_engView_Frm(HotSpot.Name, lname);
  end
  else
  if Pos('(Control Box)', HotSpot.Name) > 0  then
  begin
    lName := 'CB';
    Create_ControlPanel_Frm(HotSpot.Name, lname);
  end
  else
  if Pos('(Equipment)', HotSpot.Name) > 0  then
  begin
   lName := 'EQ';
   Create_NetWork_Sub2_Frm(HotSpot.Name, lname);
  end
end;

end.

