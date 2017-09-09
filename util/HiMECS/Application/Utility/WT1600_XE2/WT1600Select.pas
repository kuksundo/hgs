unit WT1600Select;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TWT1600SelectF = class(TForm)
    RadioGroup1: TRadioGroup;
    BitBtn1: TBitBtn;
    IPAddrEdit: TEdit;
    UseIPCB: TCheckBox;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WT1600SelectF: TWT1600SelectF;

implementation

{$R *.dfm}

procedure TWT1600SelectF.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.
