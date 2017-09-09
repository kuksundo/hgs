unit ModbusConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask,
  JvExControls, JvComCtrls, ModbusComConst_HIC, JvExMask, JvToolEdit;

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
    procedure Button1Click(Sender: TObject);
    procedure ModbusModeRGClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModbusConfigF: TModbusConfigF;

implementation

uses ModbusCom_main;

{$R *.dfm}

procedure TModbusConfigF.Button1Click(Sender: TObject);
begin
  ModbusComF.SetConfigComm;
end;

procedure TModbusConfigF.ModbusModeRGClick(Sender: TObject);
begin
  TabSheet3.Enabled := not ((ModbusModeRG.ItemIndex = ord(TCP_WAGO_MODE)) or
                            (ModbusModeRG.ItemIndex = ord(MODBUSTCP_MODE)));
  TabSheet4.Enabled := (ModbusModeRG.ItemIndex = ord(TCP_WAGO_MODE)) or
                            (ModbusModeRG.ItemIndex = ord(MODBUSTCP_MODE));
end;

end.
