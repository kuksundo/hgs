unit UnitAxisSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, ExtCtrls, StdCtrls, Buttons;

type
  TAxisSelectF = class(TForm)
    Panel1: TPanel;
    XYSelectGrid: TNextGrid;
    ItemName: TNxTextColumn;
    NxComboBoxColumn1: TNxComboBoxColumn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AxisSelectF: TAxisSelectF;

implementation

{$R *.dfm}

end.
