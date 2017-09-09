unit RwSend;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TSendDialog = class(TForm)
    btnSend: TButton;
    btnClose: TButton;
    edtIpAddress: TEdit;
    edtMacAddress: TEdit;
    lblIpAddress: TLabel;
    lblMacAddress: TLabel;
    StaticText: TStaticText;
    procedure btnSendClick(Sender: TObject);
  private
    { Private declarations }
    FIpPort: Word;
  public
    { Public declarations }
  end;

procedure ShowSendDialog(AOwner: TComponent; const AMacAddress,
  AIpAddress: string; AIpPort: Word);
  
var
  SendDialog: TSendDialog;

implementation

uses NetConst, NetUtils;

{$R *.dfm}

procedure ShowSendDialog(AOwner: TComponent; const AMacAddress,
  AIpAddress: string; AIpPort: Word);
begin
  with TSendDialog.Create(AOwner) do
  try
    edtMacAddress.Text := AMacAddress;
    edtIpAddress.Text := AIpAddress;
    FIpPort := AIpPort;
    ShowModal;
  finally
    Free;
  end;
end;
  
procedure TSendDialog.btnSendClick(Sender: TObject);
begin
  if not CheckIpAddress(edtIpAddress.Text) then
  begin
    with Application do
      MessageBox(PChar(SInvalidIpAddress), PChar(Title), MB_OK or MB_ICONERROR);
    edtIpAddress.SetFocus;
    Exit;
  end;
  if not CheckMacAddress(edtMacAddress.Text) then
  begin
    with Application do
      MessageBox(PChar(SInvalidMacAddress), PChar(Title), MB_OK or MB_ICONERROR);
    edtMacAddress.SetFocus;
    Exit;
  end;
  StaticText.Caption := Format(SSendTo, [edtIpAddress.Text]);
  SendMagicPacket(edtMacAddress.Text, edtIpAddress.Text, FIpPort);
  Sleep(1000);
  StaticText.Caption := '';
end;

end.