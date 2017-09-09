unit ModbusConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask, ToolEdit;

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
    FilenameEdit: TFilenameEdit;
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
    FilenameEdit2: TFilenameEdit;
    Label13: TLabel;
    procedure Button1Click(Sender: TObject);
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

end.
