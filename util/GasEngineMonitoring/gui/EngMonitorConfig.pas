unit EngMonitorConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Spin, Buttons, Mask, JvExMask,
  JvToolEdit
;

type
  TEngMonitorConfigF = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet3: TTabSheet;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    FilenameEdit: TJvFilenameEdit;
    GenOutputRG: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EngMonitorConfigF: TEngMonitorConfigF;

implementation

{$R *.dfm}

end.
