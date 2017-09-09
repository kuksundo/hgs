unit formRahgeEdit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin;

type

  { TfrmRangeEdit }

  TfrmRangeEdit = class(TForm)
    btOk        : TButton;
    brCancel    : TButton;
    lbRegStop   : TLabel;
    lbRegStart  : TLabel;
    speRegStart : TSpinEdit;
    speRegStop  : TSpinEdit;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmRangeEdit : TfrmRangeEdit;

implementation

{$R *.lfm}

end.

