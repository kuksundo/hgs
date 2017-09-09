unit UnitAMSServerConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, Vcl.Samples.Spin, Vcl.ComCtrls,
  IniPersist, UnitConfigIniClass, JvExControls, JvComCtrls;

type
  TBWQryFetchType = (ftCyclic, ftScheduledTime );//주기적으로 가져오기, 정해진 시간에 가져오기

  TConfigSettings = class (TINIConfigBase)
  private
    FServerIP,
    FServerPort,
    FServerUserId,
    FServerPasswd,
    FServerRootName,
    FMQServerIP,
    FMQServerPort,
    FMQServerUserId,
    FMQServerPasswd,
    FMQServerTopic,
    FTimeDuringAlarmLamp,
    FNoAlarmLamp: string;
  public
    //Section Name, Key Name, Default Key Value  (Control.hint = SectionName;KeyName 으로 저장 함)
    [IniValue('Comm Server','My IP','')]
    property ServerIP : string read FServerIP write FServerIP;
    [IniValue('Comm Server','My Port','')]
    property ServerPort : string read FServerPort write FServerPort;
    [IniValue('Comm Server','User ID','')]
    property ServerUserId : string read FServerUserId write FServerUserId;
    [IniValue('Comm Server','Password','')]
    property ServerPasswd : string read FServerPasswd write FServerPasswd;
    [IniValue('Comm Server','Root Name','')]
    property ServerRootName : string read FServerRootName write FServerRootName;
    [IniValue('File','Time during Alarm Lamp','')]
    property TimeDuringAlarmLamp : string read FTimeDuringAlarmLamp write FTimeDuringAlarmLamp;
    [IniValue('File','No Alarm Lamp','')]
    property NoAlarmLamp : string read FNoAlarmLamp write FNoAlarmLamp;
    [IniValue('MQ Server','MQ Server IP','10.14.21.117')]
    property MQServerIP : string read FMQServerIP write FMQServerIP;
    [IniValue('MQ Server','MQ Server Port','61613')]
    property MQServerPort : string read FMQServerPort write FMQServerPort;
    [IniValue('MQ Server','MQ Server UserId','pjh')]
    property MQServerUserId : string read FMQServerUserId write FMQServerUserId;
    [IniValue('MQ Server','MQ Server Passwd','pjh')]
    property MQServerPasswd : string read FMQServerPasswd write FMQServerPasswd;
    [IniValue('MQ Server','MQ Server Topic','')]
    property MQServerTopic : string read FMQServerTopic write FMQServerTopic;
  end;

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
    TabSheet4: TTabSheet;
    CommServerTab: TTabSheet;
    Label25: TLabel;
    Label26: TLabel;
    ReConnectIntervalEdit: TSpinEdit;
    DBServarTab: TTabSheet;
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
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label20: TLabel;
    Label21: TLabel;
    Label9: TLabel;
    Label14: TLabel;
    Label23: TLabel;
    ServerIPEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    ServerPortEdit: TEdit;
    RootNameEdit: TEdit;
    Bevel1: TBevel;
    Label15: TLabel;
    Label16: TLabel;
    AlarmLampTimeEdit: TEdit;
    mSeclbl: TLabel;
    NoAlarmLampCB: TCheckBox;
    NoAlarmLampEdit: TEdit;
    TabSheet2: TTabSheet;
    Label11: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    MQIPAddress: TJvIPAddress;
    MQPortEdit: TEdit;
    MQUserEdit: TEdit;
    MQPasswdEdit: TEdit;
    MQTopicEdit: TEdit;
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
