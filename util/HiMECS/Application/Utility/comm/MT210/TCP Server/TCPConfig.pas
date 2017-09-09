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
    Label1: TLabel;
    HostIPEdit: TEdit;
    TabSheet3: TTabSheet;
    UseTimerCB: TCheckBox;
    Label3: TLabel;
    IntervalEdit: TEdit;
    Label4: TLabel;
    procedure UseTimerCBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPConfigF: TTCPConfigF;

implementation

{$R *.dfm}

procedure TTCPConfigF.UseTimerCBClick(Sender: TObject);
begin
  Label3.Enabled := UseTimerCB.Checked;
  IntervalEdit.Enabled := UseTimerCB.Checked;
  Label4.Enabled := UseTimerCB.Checked;
end;

end.
