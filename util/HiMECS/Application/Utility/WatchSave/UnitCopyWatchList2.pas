unit UnitCopyWatchList2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, ExtCtrls, StdCtrls, Buttons, ImgList, NxCollection,
  AdvToolBtn, Vcl.Menus;

type
  TCopyWatchListF = class(TForm)
    SelectGrid: TNextGrid;
    ItemName: TNxTextColumn;
    Value: TNxTextColumn;
    FUnit: TNxTextColumn;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ImageList1: TImageList;
    FormulaPanel: TPanel;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn1: TNxTextColumn;
    NxButtonColumn1: TNxButtonColumn;
    Label2: TLabel;
    ExprEdt: TEdit;
    Button1: TButton;
    AdvToolButton2: TAdvToolButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    rigonometric1: TMenuItem;
    sin1: TMenuItem;
    cos1: TMenuItem;
    tan1: TMenuItem;
    ctan1: TMenuItem;
    arcsin1: TMenuItem;
    arccos1: TMenuItem;
    arctan1: TMenuItem;
    sinh1: TMenuItem;
    cosh1: TMenuItem;
    tanh1: TMenuItem;
    coth1: TMenuItem;
    Etc1: TMenuItem;
    Abs1: TMenuItem;
    Sqrt1: TMenuItem;
    Ln1: TMenuItem;
    Exp1: TMenuItem;
    Power1: TMenuItem;
    heaviside1: TMenuItem;
    procedure SelectGridDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure sin1Click(Sender: TObject);
    procedure cos1Click(Sender: TObject);
    procedure tan1Click(Sender: TObject);
    procedure ctan1Click(Sender: TObject);
    procedure arcsin1Click(Sender: TObject);
    procedure arccos1Click(Sender: TObject);
    procedure arctan1Click(Sender: TObject);
    procedure sinh1Click(Sender: TObject);
    procedure cosh1Click(Sender: TObject);
    procedure tanh1Click(Sender: TObject);
    procedure coth1Click(Sender: TObject);
    procedure Abs1Click(Sender: TObject);
    procedure Sqrt1Click(Sender: TObject);
    procedure Ln1Click(Sender: TObject);
    procedure Exp1Click(Sender: TObject);
    procedure Power1Click(Sender: TObject);
    procedure heaviside1Click(Sender: TObject);
  private
    procedure InsertFunction2Edit(AMenuItem: TMenuItem);
  public
    FTagName: string;

    procedure CopyFromMS(AStream: TStream);
    procedure CopyFromFile(AFileName:string);
  end;

var
  CopyWatchListF: TCopyWatchListF;

implementation

uses UtilUnit;

{$R *.dfm}

{ TForm2 }

procedure TCopyWatchListF.Abs1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.arccos1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.arcsin1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.arctan1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.Button1Click(Sender: TObject);
begin
  SelectGridDblClick(nil);
end;

procedure TCopyWatchListF.CopyFromFile(AFileName: string);
begin
  SelectGrid.LoadFromTextFile(AFileName);
end;

procedure TCopyWatchListF.CopyFromMS(AStream: TStream);
begin
  SelectGrid.LoadFromStream(AStream);
end;

procedure TCopyWatchListF.cos1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.cosh1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.coth1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.ctan1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.Exp1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.heaviside1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.InsertFunction2Edit(AMenuItem: TMenuItem);
var
  LPos: integer;
begin
  if FormulaPanel.Visible then
  begin
    LPos := ExprEdt.SelStart;
    ExprEdt.Text := InsertStringAtCursor(ExprEdt.Text,AMenuItem.Caption, ExprEdt.SelStart);
    ExprEdt.SelStart := LPos + Length(AMenuItem.Caption);
  end;
end;

procedure TCopyWatchListF.Ln1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.N2Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.N3Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.N4Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.N6Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.Power1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.SelectGridDblClick(Sender: TObject);
var
  i: integer;
begin
  if FormulaPanel.Visible then
  begin
    if SelectGrid.SelectedRow > -1 then
      ExprEdt.Text := InsertStringAtCursor(ExprEdt.Text,
        SelectGrid.CellByName['Value', SelectGrid.SelectedRow].AsString,
        ExprEdt.SelStart );
  end;
end;

procedure TCopyWatchListF.sin1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.sinh1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.Sqrt1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.tan1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

procedure TCopyWatchListF.tanh1Click(Sender: TObject);
begin
  InsertFunction2Edit(TMenuItem(Sender));
end;

end.
