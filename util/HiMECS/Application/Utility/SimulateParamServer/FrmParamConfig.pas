unit FrmParamConfig;

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
    FSTOMPServerIP,
    FSTOMPServerPort,
    FSTOMPServerUserId,
    FSTOMPServerPasswd,
    FSTOMPServerTopic,
    FParamFileName: string;

    FUseSharedMM,
    FUseSTOMP: Boolean;
  public
    //Control.hint = 값이 저장되는 필드명 (예: Caption, Text, Value)
    //Section Name, Key Name, Default Key Value, Component Tag No
//    [IniValue('MQTT Server','MQTT Server Enable', 'False')]
//    property MQTTServerEnable : string read FMQTTServerEnable write FMQTTServerEnable;
    [IniValue('STOMP Server','STOMP Server IP','10.14.21.117',6)]
    property STOMPServerIP : string read FSTOMPServerIP write FSTOMPServerIP;
    [IniValue('STOMP Server','STOMP Server Port','61613',7)]
    property STOMPServerPort : string read FSTOMPServerPort write FSTOMPServerPort;
    [IniValue('STOMP Server','STOMP Server UserId','pjh',8)]
    property STOMPServerUserId : string read FSTOMPServerUserId write FSTOMPServerUserId;
    [IniValue('STOMP Server','STOMP Server Passwd','pjh',9)]
    property STOMPServerPasswd : string read FSTOMPServerPasswd write FSTOMPServerPasswd;
    [IniValue('STOMP Server','STOMP Server Topic','',10)]
    property STOMPServerTopic : string read FSTOMPServerTopic write FSTOMPServerTopic;
    [IniValue('File','Use Shared MM','False',11)]
    property UseSharedMM : Boolean read FUseSharedMM write FUseSharedMM;
    [IniValue('File','Use STOMP','False',12)]
    property UseSTOMP : Boolean read FUseSTOMP write FUseSTOMP;
    [IniValue('File','Param File Name','')]
    property ParamFileName : string read FParamFileName write FParamFileName;
  end;

  TConfigF = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    FileTS: TTabSheet;
    ParaFilenameEdit: TJvFilenameEdit;
    Label6: TLabel;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    JvIPAddress1: TJvIPAddress;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
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
