unit WT1600Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Vcl.Mask, JvExMask, JvToolEdit,
  Vcl.Buttons;

type
  TWT1600ConfigF = class(TForm)
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ModbusModeRG: TRadioGroup;
    QueryIntervalEdit: TEdit;
    ResponseWaitTimeOutEdit: TEdit;
    TabSheet1: TTabSheet;
    Label16: TLabel;
    Label6: TLabel;
    SharedNameEdit: TComboBox;
    ParaFilenameEdit: TJvFilenameEdit;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ModelSelectRG: TRadioGroup;
    Label5: TLabel;
    MaxPingFailEdit: TEdit;
    Label7: TLabel;
    DisplayEdit: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WT1600ConfigF: TWT1600ConfigF;

implementation

{$R *.dfm}

end.
