unit RwNewHst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TNewHostDialog = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lblHostName: TLabel;
    lblMacAddress: TLabel;
    edtHostName: TEdit;
    edtMacAddress: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewHostDialog: TNewHostDialog;

implementation

uses NetConst, NetUtils;

{$R *.dfm}

procedure TNewHostDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    if Trim(edtHostName.Text) = '' then
    begin
      with Application do
        MessageBox(PChar(SInvalidHost), PChar(Title), MB_OK or MB_ICONERROR);
      edtHostName.SetFocus;
      Action := caNone;
      Exit;
    end;
    if not CheckMacAddress(edtMacAddress.Text) then
    begin
      with Application do
        MessageBox(PChar(SInvalidMacAddress), PChar(Title), MB_OK or MB_ICONERROR);
      edtMacAddress.SetFocus;
      Action := caNone;
    end;
  end;
end;

end.