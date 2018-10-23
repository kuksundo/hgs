unit FrameVesselList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBaseDlg,
  JvSelectDirectory, Vcl.ExtCtrls, AdvSmoothSplashScreen, Vcl.Menus,
  Vcl.ImgList, NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, SBPro, AdvOfficeTabSet, pjhComboBox, Vcl.StdCtrls,
  AeroButtons, Vcl.ComCtrls, AdvGroupBox, AdvOfficeButtons, JvExControls,
  JvLabel, CurvyControls;

type
  TFrame2 = class(TFrame)
    Splitter1: TSplitter;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel9: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel13: TJvLabel;
    JvLabel12: TJvLabel;
    PeriodPanel: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    ComboBox1: TComboBox;
    OwnerEdit: TEdit;
    HullNoEdit: TEdit;
    ShipNameEdit: TEdit;
    Panel1: TPanel;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    AeroButton1: TAeroButton;
    ImoNoEdit: TEdit;
    TechManagerEdit: TEdit;
    OperatorEdit: TEdit;
    VesselStatusCB: TComboBox;
    TechManagerCountryCB: TComboBoxInc;
    AeroButton2: TAeroButton;
    ShipBuilderNameEdit: TEdit;
    ClassEdit: TEdit;
    ShipTypeCB: TComboBoxInc;
    ShipStatusEdit: TEdit;
    TaskTab: TAdvOfficeTabSet;
    StatusBarPro1: TStatusBarPro;
    VesselListGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    MERate: TNxRateColumn;
    GERate: TNxRateColumn;
    GeneratorRate: TNxRateColumn;
    SWBDRate: TNxRateColumn;
    HullNo: TNxTextColumn;
    ShipName: TNxTextColumn;
    ImoNo: TNxTextColumn;
    DeliveryDate: TNxTextColumn;
    SpecialSurveyDueDate: TNxTextColumn;
    DockingSurveyDueDate: TNxTextColumn;
    LastDryDockDate: TNxTextColumn;
    ShipType: TNxTextColumn;
    OwnerName: TNxTextColumn;
    TechManagerName: TNxTextColumn;
    TechManagerCountry: TNxTextColumn;
    ShipTypeDesc: TNxTextColumn;
    SClass1: TNxTextColumn;
    ShipBuilderName: TNxTextColumn;
    VesselStatus: TNxTextColumn;
    UpdatedDate: TNxTextColumn;
    SClass2: TNxTextColumn;
    OwnerID: TNxTextColumn;
    TechManagerID: TNxTextColumn;
    OperatorID: TNxTextColumn;
    BuyingCompanyCountry: TNxTextColumn;
    BuyingCompanyID: TNxTextColumn;
    SCRRate: TNxRateColumn;
    BWTSRate: TNxRateColumn;
    FGSSRate: TNxRateColumn;
    COPTRate: TNxRateColumn;
    PROPRate: TNxRateColumn;
    EGRRate: TNxRateColumn;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    ImportFromFile1: TMenuItem;
    ImportVesselDeliveryDateFromXlsFile1: TMenuItem;
    ImportVesselGPandDeliveryFromXlsFile1: TMenuItem;
    ImportVesselDeliveryFromXlsFile1: TMenuItem;
    ImportAnsiDeviceFromXlsFile1: TMenuItem;
    AddNationListFromXls1: TMenuItem;
    ImportNationNameENFromXls1: TMenuItem;
    ImportNationFlagFromFolder1: TMenuItem;
    ImportNationFlagImageFromFolder1: TMenuItem;
    ImportEngineMasterFromXls1: TMenuItem;
    ImportGeneratorMasterFromXlsFile1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    View1: TMenuItem;
    ShowAnsiDeviceNoList1: TMenuItem;
    GetVesselInfoFromWeb1: TMenuItem;
    GetVesselInfoFromText1: TMenuItem;
    ShowNationCode1: TMenuItem;
    InstalledProduct2: TMenuItem;
    Engine3: TMenuItem;
    Electric3: TMenuItem;
    DataBase1: TMenuItem;
    UpdateDockSurveyDateFrom1: TMenuItem;
    AddVesselInfoFromSeaWebDB1: TMenuItem;
    UpdateInstalledProductInVesselMasterFromEngineMaster1: TMenuItem;
    RemoveGEFromInstalledProductInVesselMaster1: TMenuItem;
    ools1: TMenuItem;
    QuotationManager1: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Electric1: TMenuItem;
    HiMAP1: TMenuItem;
    SWBD1: TMenuItem;
    VCBACB1: TMenuItem;
    ransformer1: TMenuItem;
    Motor1: TMenuItem;
    Generator1: TMenuItem;
    Engine1: TMenuItem;
    N2Stroke1: TMenuItem;
    N4Stroke1: TMenuItem;
    InstalledProduct1: TMenuItem;
    Engine2: TMenuItem;
    Electric2: TMenuItem;
    ImageList32x32: TImageList;
    SplashScreen1: TAdvSmoothSplashScreen;
    Timer1: TTimer;
    JvSelectDirectory1: TJvSelectDirectory;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
