unit UnitAlarmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, JvExControls, JvComCtrls, JvToolEdit,
  Mask, JvExMask, ComCtrls;

type
  TAlarmConfigF = class(TForm)
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    AlarmDBFilenameEdit: TJvFilenameEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBDriverEdit: TJvFilenameEdit;
    GroupBox1: TGroupBox;
    RB_bydate: TRadioButton;
    RB_byfilename: TRadioButton;
    RadioButton1: TRadioButton;
    ED_csv: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlarmConfigF: TAlarmConfigF;

implementation

{$R *.dfm}

end.
