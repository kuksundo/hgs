unit UnitAlarmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, JvExControls, JvComCtrls, JvToolEdit,
  Mask, JvExMask, ComCtrls, IniPersist, Vcl.Samples.Spin, UnitConfigIniClass;

type
  TConfigSettings = class (TINIConfigBase)
  private
    FSharedName: String;
    FServerIP: string;
    FServerPort: string;
    FUserId: string;
    FUserPasswd: string;
  public
    // Use the IniValue attribute on any property or field
    // you want to show up in the INI File.
    //Section Name, Key Name, Default Key Value
    [IniValue('Comm Server','Shared Name','')]
    property SharedName : String read FSharedName write FSharedName;
    [IniValue('Comm Server','Server IP','')]
    property ServerIP : String read FServerIP write FServerIP;
    [IniValue('Comm Server','Server Port','')]
    property ServerPort : String read FServerPort write FServerPort;
    [IniValue('Comm Server','User ID','')]
    property UserId : String read FUserId write FUserId;
    [IniValue('Comm Server','PassWord','')]
    property UserPasswd : String read FUserPasswd write FUserPasswd;
  end;

  TAlarmConfigF = class(TForm)
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    AlarmDBFilenameEdit: TJvFilenameEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBDriverEdit: TJvFilenameEdit;
    GroupBox1: TGroupBox;
    RB_bydate: TRadioButton;
    RB_byfilename: TRadioButton;
    RadioButton1: TRadioButton;
    ED_csv: TEdit;
    Label2: TLabel;
    AlarmItemFileEdit: TJvFilenameEdit;
    RelPathCB: TCheckBox;
    TabSheet1: TTabSheet;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label9: TLabel;
    Label23: TLabel;
    ServerIPEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    ReConnectIntervalEdit: TSpinEdit;
    ServerPortEdit: TEdit;
    SharedNameEdit: TEdit;
    TabSheet3: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ServerEdit: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    TableNameCombo: TComboBox;
    SpinEdit1: TSpinEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlarmConfigF: TAlarmConfigF;

implementation

{$R *.dfm}

end.
