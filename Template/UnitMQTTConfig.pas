unit UnitMQTTConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvComCtrls,
  AdvGroupBox, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls, IniPersist, UnitConfigIniClass2,
  Vcl.Mask, JvExMask, JvToolEdit;

type
  TConfigSettings = class (TINIConfigBase)
  private
    //변수 Type은 값을 받는 컴포넌트 속성 Type과 같아야 함
    //(예: Text면 String, Checked면 Bool, Value면 Integer)
//    FMQServerEnable,
    FMQTTServerIP,
    FMQTTServerPort,
    FMQTTServerUserId,
    FMQTTServerPasswd,
    FMQTTServerTopic,
    FParamFileName: string;
  public
    //Control.hint = 값이 저장되는 필드명 (예: Caption, Text, Value)
    //Section Name, Key Name, Default Key Value, Component Tag No
//    [IniValue('MQTT Server','MQTT Server Enable', 'False')]
//    property MQTTServerEnable : string read FMQTTServerEnable write FMQTTServerEnable;
    [IniValue('MQTT Server','MQTT Server IP','10.14.21.117',1)]
    property MQTTServerIP : string read FMQTTServerIP write FMQTTServerIP;
    [IniValue('MQTT Server','MQTT Server Port','1883',2)]
    property MQTTServerPort : string read FMQTTServerPort write FMQTTServerPort;
    [IniValue('MQTT Server','MQTT Server UserId','',3)]
    property MQTTServerUserId : string read FMQTTServerUserId write FMQTTServerUserId;
    [IniValue('MQTT Server','MQTT Server Passwd','',4)]
    property MQTTServerPasswd : string read FMQTTServerPasswd write FMQTTServerPasswd;
    [IniValue('MQTT Server','MQTT Server Topic','',5)]
    property MQTTServerTopic : string read FMQTTServerTopic write FMQTTServerTopic;
    [IniValue('File','Param File Name','')]
    property ParamFileName : string read FParamFileName write FParamFileName;
  end;

  TConfigF = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    MQServerTS: TTabSheet;
    FileTS: TTabSheet;
    ParaFilenameEdit: TJvFilenameEdit;
    Label6: TLabel;
    Label11: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    Label17: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Label18: TLabel;
    MQIPAddress: TJvIPAddress;
    MQBindComboBox: TComboBox;
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
