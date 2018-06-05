unit FrmInqManageConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvComCtrls,
  AdvGroupBox, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, AdvOfficeButtons, AdvGlowButton,
  AdvOfficeSelectors;

type
  TConfigF = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    MQServerTS: TTabSheet;
    Label11: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    Label17: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Label18: TLabel;
    MQBindComboBox: TComboBox;
    MQPortEdit: TEdit;
    MQUserEdit: TEdit;
    MQPasswdEdit: TEdit;
    MQTopicEdit: TEdit;
    FileTS: TTabSheet;
    Label6: TLabel;
    ParaFilenameEdit: TJvFilenameEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    MQIPAddress: TJvIPAddress;
    EmailTS: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    TabSheet2: TTabSheet;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label8: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Label15: TLabel;
    Edit11: TEdit;
    Label16: TLabel;
    Edit12: TEdit;
    Label19: TLabel;
    Edit13: TEdit;
    TabSheet3: TTabSheet;
    WSSocketEnableCB: TAdvGroupBox;
    Label20: TLabel;
    WSPortEdit: TEdit;
    RemoteAuthEnableCB: TCheckBox;
    TabSheet4: TTabSheet;
    LowAlarmGroup: TAdvGroupBox;
    Label22: TLabel;
    Label24: TLabel;
    Label31: TLabel;
    Label37: TLabel;
    AdvGroupBox5: TAdvGroupBox;
    MinAlarmSoundEdit: TJvFilenameEdit;
    MinAlarmEdit: TEdit;
    MinAlarmColorSelector: TAdvOfficeColorSelector;
    MinAlarmSoundCB: TCheckBox;
    MinAlarmDeadBandEdit: TEdit;
    MinAlarmDelayEdit: TEdit;
    MinAlarmBlinkCB: TAdvOfficeCheckBox;
    MinAlarmNeedAckCB: TAdvOfficeCheckBox;
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
