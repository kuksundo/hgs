unit UnitAutoUpdateConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, JvExMask, JvToolEdit;

type
  TAutoUpdateConfigF = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    UpdateTypeCombo: TComboBox;
    URLEdit: TEdit;
    JvFilenameEdit1: TJvFilenameEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure UpdateTypeComboSelect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AutoUpdateConfigF: TAutoUpdateConfigF;

implementation

{$R *.dfm}

procedure TAutoUpdateConfigF.UpdateTypeComboSelect(Sender: TObject);
begin
  if UpdateTypeCombo.Text = 'ftpUpdate' then
    URLEdit.Text := 'ftp://'
  else if UpdateTypeCombo.Text = 'httpUpdate' then
    URLEdit.Text := 'http://'
  else if UpdateTypeCombo.Text = 'fileUpdate' then
    URLEdit.Text := 'file://'
end;

end.
