unit ModbusConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask,
  JvExControls, JvComCtrls, ModbusComConst, JvExMask, JvToolEdit;

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
    Label6: TLabel;
    SlaveNoEdit: TEdit;
    Label7: TLabel;
    FuncCodeEdit: TEdit;
    Label5: TLabel;
    BaseAddrEdit: TEdit;
    Label8: TLabel;
    SlaveNoEdit2: TEdit;
    FuncCodeEdit2: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    BaseAddrEdit2: TEdit;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    TabSheet4: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    PortNumEdit: TEdit;
    JvIPAddress1: TJvIPAddress;
    FilenameEdit: TJvFilenameEdit;
    FilenameEdit2: TJvFilenameEdit;
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

uses ModbusCom_multidrop;

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
