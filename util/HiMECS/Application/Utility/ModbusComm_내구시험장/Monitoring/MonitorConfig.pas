unit MonitorConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask,
  JvExControls, JvComCtrls, JvExMask, JvToolEdit;

type
  TModbusConfigF = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label8: TLabel;
    MapFilenameEdit: TJvFilenameEdit;
    Label10: TLabel;
    AvgEdit: TEdit;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    RunRPMEdit: TEdit;
    Label2: TLabel;
    NotRunRPMEdit: TEdit;
    UseECUSignalCB: TCheckBox;
    Label3: TLabel;
    RunHourEdit: TEdit;
    Label4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModbusConfigF: TModbusConfigF;

implementation

{$R *.dfm}

end.
