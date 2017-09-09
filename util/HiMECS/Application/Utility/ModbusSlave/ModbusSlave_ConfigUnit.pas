unit ModbusSlave_ConfigUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.ComCtrls, Vcl.Buttons, Vcl.CheckLst;

type
  TFrmModbusSlaveConfig = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet5: TTabSheet;
    TabSheet4: TTabSheet;
    Label16: TLabel;
    ParaFilenameEdit: TJvFilenameEdit;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    Label14: TLabel;
    MapFilenameEdit: TJvFilenameEdit;
    Panel2: TPanel;
    Label19: TLabel;
    GroupBox1: TGroupBox;
    ParamSourceCLB: TCheckListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmModbusSlaveConfig: TFrmModbusSlaveConfig;

implementation

{$R *.dfm}

end.
