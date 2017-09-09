unit TCPConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask;

type
  TTCPConfigF = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    Tabsheet2: TTabSheet;
    Label5: TLabel;
    PortEdit: TEdit;
    TabSheet1: TTabSheet;
    SharedMMNameEdit: TEdit;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPConfigF: TTCPConfigF;

implementation

{$R *.dfm}

end.
