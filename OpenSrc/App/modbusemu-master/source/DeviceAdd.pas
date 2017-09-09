unit DeviceAdd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls;

type

  { TfrmAddDevice }

  TfrmAddDevice = class(TForm)
    btOk               : TButton;
    btCancel           : TButton;
    cbDiscretDefValue  : TComboBox;
    cgFunctions        : TCheckGroup;
    cbCoilsDefValue    : TComboBox;
    gbDefVlaues        : TGroupBox;
    lbInput            : TLabel;
    lbHolding          : TLabel;
    lbDiscret          : TLabel;
    lbCoils            : TLabel;
    lbDevNumber        : TLabel;
    speDevNumber       : TSpinEdit;
    speHoldingDefValue : TSpinEdit;
    speInputDefValue   : TSpinEdit;
   private
   public
  end;

var frmAddDevice : TfrmAddDevice;

implementation

{$R *.lfm}

end.

