unit w_SelectDirectoryFixTest;

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
  StdCtrls;

type
  TForm1 = class(TForm)
    b_Test: TButton;
    procedure b_TestClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  FileCtrl,
  u_dzSelectDirectoryFix;

procedure TForm1.b_TestClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := 'C:\Windows\System32';
  SelectDirectory('caption', '', Dir, [sdNewFolder, sdShowEdit, sdNewUI], Self);
end;

end.
