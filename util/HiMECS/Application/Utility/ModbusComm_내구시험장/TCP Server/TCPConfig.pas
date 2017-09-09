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
    HostIpCB: TComboBox;
    procedure HostIpCBDropDown(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPConfigF: TTCPConfigF;

implementation

uses ECS_Kumo_TCPUtil;

{$R *.dfm}

procedure TTCPConfigF.HostIpCBDropDown(Sender: TObject);
begin
  HostIpCB.Items.Assign(GetLocalIPs);
end;

end.
