unit ExceptionDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TExceptionDlg = class(TForm)
    lblError: TLabel;
    btnSend: TButton;
    btnOK: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    class function ShowDialog(Title,ErrorMessage : String) : Boolean;
  end;

var
  ExceptionDlg: TExceptionDlg;

implementation

{$R *.dfm}

{ TfrmExceptionDlg }

class function TExceptionDlg.ShowDialog(Title,
  ErrorMessage: String): Boolean;
var
  f : TExceptionDlg;
begin
  f := TExceptionDlg.Create(application);
  try
    f.Caption := Title;
    f.lblError.Caption := ErrorMessage;
    f.Width := f.lblError.Width + 20;
    result := f.ShowModal = mrYes; //Send = mrYes
  finally
    f.Free;
  end;
end;

end.
