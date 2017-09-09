unit ParamSaveUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, JvExMask, JvToolEdit;

type
  TParamSaveF = class(TForm)
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
  ParamSaveF: TParamSaveF;

implementation

{$R *.dfm}

end.
