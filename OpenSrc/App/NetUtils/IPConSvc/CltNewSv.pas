unit CltNewSv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TNewServerDialog = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lblIpAddress: TLabel;
    lblPort: TLabel;
    edtIpAddress: TEdit;
    edtPort: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewServerDialog: TNewServerDialog;

implementation

uses NetConst, NetUtils;

{$R *.dfm}

procedure TNewServerDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    if not CheckIpAddress(edtIpAddress.Text) then
    begin
      with Application do
        MessageBox(PChar(SInvalidIpAddress), PChar(Title), MB_OK or MB_ICONERROR);
      edtIpAddress.SetFocus;
      Action := caNone;
      Exit;
    end;
    if not CheckPort(edtPort.Text) then
    begin
      with Application do
        MessageBox(PChar(SInvalidPort), PChar(Title), MB_OK or MB_ICONERROR);
      edtPort.SetFocus;
      Action := caNone;
    end;
  end;
end;

end.