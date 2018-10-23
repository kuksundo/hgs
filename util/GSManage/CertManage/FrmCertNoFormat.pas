unit FrmCertNoFormat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TCertNoFormatF = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure CreateCertNoFormat;

var
  CertNoFormatF: TCertNoFormatF;

implementation

{$R *.dfm}

procedure CreateCertNoFormat;
var
  LCertNoFormatF: TCertNoFormatF;
begin
  LCertNoFormatF := TCertNoFormatF.Create(nil);
  try
    LCertNoFormatF.ShowModal;
  finally
    LCertNoFormatF.Free;
  end;
end;

end.
