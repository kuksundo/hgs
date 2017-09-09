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
    FMongoDBServerIP,
    FMongoDBServerPort,
    FMongoDBServerUserId,
    FMongoDBServerPasswd,
    FMongoDBServerDBName,
    FMongoDBServerCollectName,
    FParamFileName: string;
  public
    //Section Name, Key Name, Default Key Value  (Control.hint = SectionName;KeyName 으로 저장 함)
//    [IniValue('MQ Server','MQ Server Enable', 'False')]
//    property MQServerEnable : string read FMQServerEnable write FMQServerEnable;
    [IniValue('MQ Server','MQ Server IP','10.14.21.117',1)]
    property MQServerIP : string read FMQServerIP write FMQServerIP;
    [IniValue('MQ Server','MQ Server Port','61613',2)]
    property MQServerPort : string read FMQServerPort write FMQServerPort;
    [IniValue('MQ Server','MQ Server UserId','pjh',3)]
    property MQServerUserId : string read FMQServerUserId write FMQServerUserId;
    [IniValue('MQ Server','MQ Server Passwd','pjh',4)]
    property MQServerPasswd : string read FMQServerPasswd write FMQServerPasswd;
    [IniValue('MQ Server','MQ Server Topic','',5)]
    property MQServerTopic : string read FMQServerTopic write FMQServerTopic;
    [IniValue('MongoDB Server','MongoDB Server IP','10.100.23.63',6)]
    property MongoDBServerIP : string read FMongoDBServerIP write FMongoDBServerIP;
    [IniValue('MongoDB Server','MongoDB Server Port','27017',7)]
    property MongoDBServerPort : string read FMongoDBServerPort write FMongoDBServerPort;
    [IniValue('MongoDB Server','MongoDB Server UserId','pjh',8)]
    property MongoDBServerUserId : string read FMongoDBServerUserId write FMongoDBServerUserId;
    [IniValue('MongoDB Server','MongoDB Server Passwd','pjh',9)]
    property MongoDBServerPasswd : string read FMongoDBServerPasswd write FMongoDBServerPasswd;
    [IniValue('MongoDB Server','MongoDB Server DB Name','',10)]
    property MongoDBServerDBName : string read FMongoDBServerDBName write FMongoDBServerDBName;
    [IniValue('MongoDB Server','MongoDB Server Collect Name','',11)]
    property MongoDBServerCollectName : string read FMongoDBServerCollectName write FMongoDBServerCollectName;
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
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label32: TLabel;
    MongoServerEdit: TEdit;
    MongoUserEdit: TEdit;
    MongoPasswdEdit: TEdit;
    MongoDBNameCombo: TComboBox;
    MongoCollNameCombo: TComboBox;
    Label2: TLabel;
    Edit1: TEdit;
  private
    { Private declarations }
  public
    procedure FillCollectName2Combo(ACombo: TComboBox);
  end;

var
  ConfigF: TConfigF;

implementation

{$R *.dfm}

{ TConfigF }

procedure TConfigF.FillCollectName2Combo(ACombo: TComboBox);
begin

end;

end.
