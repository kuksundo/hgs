unit FrmIntInputEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TIntInputF = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function CreateIntInputEditForm: integer;
var
  IntInputF: TIntInputF;

implementation

{$R *.dfm}

function CreateIntInputEditForm: integer;
begin
  with TIntInputF.Create(nil)do
  begin
    if ShowModal = mrOK then
      Result := StrToIntDef(Edit1.Text, 0)
    else
      Result := -1;
    Free;
  end;
end;

end.
