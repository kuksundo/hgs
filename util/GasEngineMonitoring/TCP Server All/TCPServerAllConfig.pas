unit TCPServerAllConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask, JvExMask, JvToolEdit;

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
    Label1: TLabel;
    HostIpCB: TComboBox;
    Label3: TLabel;
    SendIntervalEdit: TEdit;
    Label2: TLabel;
    JvFilenameEdit1: TJvFilenameEdit;
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
