unit UnitMQConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvComCtrls,
  AdvGroupBox, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls, IniPersist, UnitConfigIniClass2,
  Vcl.Mask, JvExMask, JvToolEdit;

type
  TConfigSettings = class (TINIConfigBase)
  private
//    FMQServerEnable,
    FMQServerIP,
    FMQServerPort,
    FMQServerUserId,
    FMQServerPasswd,
    FMQServerTopic,
    FParamFileName: string;
  public
    //Section Name, Key Name, Default Key Value  (Control.hint = SectionName;KeyName 으로 저장 함)
//    [IniValue('MQ Server','MQ Server Enable', 'False')]
//    property MQServerEnable : string read FMQServerEnable write FMQServerEnable;
    [IniValue('MQ Server','MQ Server IP','10.14.21.117')]
    property MQServerIP : string read FMQServerIP write FMQServerIP;
    [IniValue('MQ Server','MQ Server Port','61613')]
    property MQServerPort : string read FMQServerPort write FMQServerPort;
    [IniValue('MQ Server','MQ Server UserId','pjh')] //UserId = 'pjh'
    property MQServerUserId : string read FMQServerUserId write FMQServerUserId;
    [IniValue('MQ Server','MQ Server Passwd','pjh')] //Passwd = 'pjh'
    property MQServerPasswd : string read FMQServerPasswd write FMQServerPasswd;
    [IniValue('MQ Server','MQ Server Topic','')]
    property MQServerTopic : string read FMQServerTopic write FMQServerTopic;
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
