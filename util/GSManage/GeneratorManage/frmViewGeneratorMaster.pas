unit frmViewGeneratorMaster;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ImgList, Vcl.ComCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.StdCtrls, AdvGroupBox, AdvOfficeButtons,
  CurvyControls, AeroButtons, JvExControls, JvLabel, Vcl.ExtCtrls;

type
  TViewGenMasterF = class(TForm)
    Panel1: TPanel;
    JvLabel2: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel6: TJvLabel;
    btn_Close: TAeroButton;
    PeriodPanel: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    ComboBox1: TComboBox;
    HullNoEdit: TEdit;
    btn_Search: TAeroButton;
    AeroButton1: TAeroButton;
    ProjectNoEdit: TEdit;
    ProductModelEdit: TEdit;
    ProjectNameEdit: TEdit;
    Class1Edit: TEdit;
    ProductTypeCB: TComboBox;
    EngineMasterGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    HullNo: TNxTextColumn;
    ProjectName: TNxTextColumn;
    ProductModel: TNxTextColumn;
    ProductType: TNxTextColumn;
    InstalledCount: TNxTextColumn;
    ProductDeliveryDate: TNxTextColumn;
    ShipDeliveryDate: TNxTextColumn;
    WarrantyDueDate: TNxTextColumn;
    Class1: TNxTextColumn;
    Class2: TNxTextColumn;
    ProjectNo: TNxTextColumn;
    StatusBar1: TStatusBar;
    ImageList32x32: TImageList;
    FlagImageList: TImageList;
    PopupMenu1: TPopupMenu;
    Quotation1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewGenMasterF: TViewGenMasterF;

implementation

{$R *.dfm}

end.
