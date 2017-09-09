unit SeOpts;

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
    udTimeOut: TUpDown;
    udRetries: TUpDown;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowOptionsDialog(AOwner: TComponent; var ATimeOut,
  ARetries: Integer);

var
  OptionsDialog: TOptionsDialog;

implementation

{$R *.dfm}

procedure ShowOptionsDialog(AOwner: TComponent; var ATimeOut,
  ARetries: Integer);
begin
  with TOptionsDialog.Create(AOwner) do
  try
    udTimeOut.Position := ATimeOut;
    udRetries.Position := ARetries;
    ShowModal;
    if ModalResult = mrOk then
    begin
      ATimeout := udTimeOut.Position;
      ARetries := udRetries.Position;
    end;
  finally
    Free;
  end;
end;

end.
