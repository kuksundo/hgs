unit NsOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TOptionsDialog = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    GroupBox: TGroupBox;
    lblInterval: TLabel;
    edtInterval: TEdit;
    udInterval: TUpDown;
    chkAppendStatistics: TCheckBox;
    chkAutoSave: TCheckBox;
    chkCloseToTray: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptionsDialog: TOptionsDialog;

implementation

{$R *.dfm}

end.
