unit FrmFileSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  JvExMask, JvToolEdit;

type
  TFileSelectF = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    JvFilenameEdit1: TJvFilenameEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure ComboBox1DropDown(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FileSelectF: TFileSelectF;

implementation

uses CommonData;

{$R *.dfm}

procedure TFileSelectF.ComboBox1DropDown(Sender: TObject);
begin
  GSDocType2Combo(ComboBox1);
end;

end.
