unit Config_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, Vcl.CheckLst, Vcl.Samples.Spin, Vcl.ComCtrls;

type
  TConfigF = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ampm_combo: TComboBox;
    Hour_SpinEdit: TSpinEdit;
    Minute_SpinEdit: TSpinEdit;
    UseDate_ChkBox: TCheckBox;
    Month_SpinEdit: TSpinEdit;
    Date_SpinEdit: TSpinEdit;
    Repeat_ChkBox: TCheckBox;
    TabSheet5: TTabSheet;
    GroupBox1: TGroupBox;
    ParamSourceCLB: TCheckListBox;
    Panel2: TPanel;
    Label19: TLabel;
    TabSheet4: TTabSheet;
    Label14: TLabel;
    Label16: TLabel;
    Label11: TLabel;
    MapFilenameEdit: TJvFilenameEdit;
    ParaFilenameEdit: TJvFilenameEdit;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    AppendStrEdit: TEdit;
    TabSheet3: TTabSheet;
    Label9: TLabel;
    SaveDB_ChkBox: TCheckBox;
    SaveFile_ChkBox: TCheckBox;
    FNameType_RG: TRadioGroup;
    DB_Type_RG: TRadioGroup;
    OracleTS: TTabSheet;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    ServerEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    TableNameCombo: TComboBox;
    ReConnectIntervalEdit: TSpinEdit;
    MongoDBTS: TTabSheet;
    Label18: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    MongoServerEdit: TEdit;
    MongoUserEdit: TEdit;
    MongoPasswdEdit: TEdit;
    MongoDBNameCombo: TComboBox;
    MongoReConnectEdit: TSpinEdit;
    MongoCollNameCombo: TComboBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigF: TConfigF;

implementation

{$R *.dfm}

end.
