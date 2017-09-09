unit w_GoogleTranslateTest;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  idHttp;

type
  TForm1 = class(TForm)
    b_Translate: TButton;
    ed_English: TEdit;
    ed_German: TEdit;
    ed_French: TEdit;
    b_Close: TButton;
    procedure b_TranslateClick(Sender: TObject);
    procedure b_CloseClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

uses
  u_dzGoogleTranslate;

{$R *.dfm}

procedure TForm1.b_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.b_TranslateClick(Sender: TObject);
var
  translator: TGoogleTranslate;
begin
  translator := TGoogleTranslate.Create('en', 'fr');
  try
    ed_French.Text := translator.Translate(ed_English.Text);
  finally
    FreeAndNil(translator);
  end;
  translator := TGoogleTranslate.Create('en', 'de');
  try
    ed_German.Text := translator.Translate(ed_English.Text);
  finally
    FreeAndNil(translator);
  end;
end;

end.

