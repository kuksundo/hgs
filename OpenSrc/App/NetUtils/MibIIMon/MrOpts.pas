unit MrOpts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TOptionsDialog = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    GroupBox: TGroupBox;
    lblTimeOut: TLabel;
    lblRetries: TLabel;
    edtTimeOut: TEdit;
    edtRetries: TEdit;
    lblCommunity: TLabel;
    edtCommunity: TEdit;
    udTimeOut: TUpDown;
    udRetries: TUpDown;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowOptionsDialog(AOwner: TComponent; var ACommunity: string;
  var ATimeOut, ARetries: Integer);

var
  OptionsDialog: TOptionsDialog;

implementation

{$R *.dfm}

procedure ShowOptionsDialog(AOwner: TComponent; var ACommunity: string;
  var ATimeOut, ARetries: Integer);
begin
  with TOptionsDialog.Create(AOwner) do
  try
    edtCommunity.Text := ACommunity;
    udTimeOut.Position := ATimeOut;
    udRetries.Position := ARetries;
    ShowModal;
    if ModalResult = mrOk then
    begin
      ACommunity := Trim(edtCommunity.Text);
      ATimeOut := udTimeOut.Position;
      ARetries := udRetries.Position;
    end;
  finally
    Free;
  end;
end;

end.
