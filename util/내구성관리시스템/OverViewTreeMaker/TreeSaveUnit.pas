unit TreeSaveUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, JvExMask, JvToolEdit;

type
  TMenuSaveF = class(TForm)
    JvFilenameEdit1: TJvFilenameEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MenuSaveF: TMenuSaveF;

implementation

{$R *.dfm}

end.
