unit UnitAutoUpdateSelComp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst;

type
  Tselcomp = class(TForm)
    checklist: TCheckListBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  selcomp: Tselcomp;

implementation

{$R *.DFM}

end.
