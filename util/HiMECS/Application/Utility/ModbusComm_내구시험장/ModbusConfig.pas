unit ModbusConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask,
  JvExControls, JvComCtrls, ModbusComConst_endurance, JvExMask, JvToolEdit,
  AdvGroupBox, AdvOfficeButtons;

type
  TModbusConfigF = class(TForm)
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    ModbusModeRG: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    QueryIntervalEdit: TEdit;
    ResponseWaitTimeOutEdit: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TabSheet1: TTabSheet;
    Label5: TLabel;
    BaseAddrEdit: TEdit;
    Label8: TLabel;
    SlaveNoEdit: TEdit;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Label12: TLabel;
    Label13: TLabel;
    TabSheet4: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    PortNumEdit: TEdit;
    JvIPAddress1: TJvIPAddress;
    FilenameEdit: TJvFilenameEdit;
    FilenameEdit2: TJvFilenameEdit;
    Label16: TLabel;
    SharedNameEdit: TComboBox;
    Label6: TLabel;
    ParaFilenameEdit: TJvFilenameEdit;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    Label7: TLabel;
    BindIPCB: TComboBox;
    TabSheet5: TTabSheet;
    MQServerEnable: TAdvGroupBox;
    Label11: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    Label17: TLabel;
    MQIPAddress: TJvIPAddress;
    MQBindComboBox: TComboBox;
    MQPortEdit: TEdit;
    MQUserEdit: TEdit;
    Label21: TLabel;
    Label23: TLabel;
    MQPasswdEdit: TEdit;
    Label18: TLabel;
    MQTopicEdit: TEdit;
    RelativeCB: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure ModbusModeRGClick(Sender: TObject);
    procedure BindIPCBDropDown(Sender: TObject);
    procedure ParaFilenameEditAfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModbusConfigF: TModbusConfigF;

implementation

uses ModbusCom_main, getIp, USock, UnitStringUtil;

{$R *.dfm}

procedure TModbusConfigF.BindIPCBDropDown(Sender: TObject);
var
  LStrList: TStringList;
begin
//  BindIPCB.Items.Assign(GetLocalIPList);
  LStrList := TStringList.Create;
  try
    RetrieveLocalAdapterInformation(LStrList);
  finally
    LStrList.Free;
  end;
end;

procedure TModbusConfigF.Button1Click(Sender: TObject);
begin
  ModbusComF.SetConfigComm;
end;

procedure TModbusConfigF.ModbusModeRGClick(Sender: TObject);
begin
  TabSheet4.Enabled := ((ModbusModeRG.ItemIndex = ord(TCP_WAGO_MODE)) or
                            (ModbusModeRG.ItemIndex = ord(MODBUSTCP_MODE)) or
                            (ModbusModeRG.ItemIndex = ord(MODBUSSERIAL_TCP_MODE)));
  TabSheet3.Enabled := not TabSheet4.Enabled;
end;

procedure TModbusConfigF.ParaFilenameEditAfterDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  if RelativeCB.Checked then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));
    AName := ExtractRelativePathBaseApplication(GetCurrentDir, AName);
  end;
end;

end.
