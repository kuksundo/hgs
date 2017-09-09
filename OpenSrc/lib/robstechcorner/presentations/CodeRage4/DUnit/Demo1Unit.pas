unit Demo1Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm8 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Add(Value1,Value2 : String) : String;
  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}

{ TForm8 }

function TForm8.Add(Value1, Value2: String): String;
begin
  result := Value1 + Value2;
end;

procedure TForm8.Button1Click(Sender: TObject);
begin
  Label1.Caption := Add(Edit1.Text,Edit2.Text);
end;

end.
