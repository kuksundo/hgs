unit UnitDataView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tmsAdvGridExcel, AdvGridWorkbook,
  Vcl.ExtCtrls, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, Vcl.StdCtrls, Vcl.Buttons;

type
  TDataViewF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    AdvGridWorkbook1: TAdvGridWorkbook;
    AdvGridExcelIO1: TAdvGridExcelIO;
    BitBtn1: TBitBtn;
    DataViewGrid: TAdvStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataViewF: TDataViewF;

implementation

{$R *.dfm}

procedure TDataViewF.FormCreate(Sender: TObject);
begin
  AdvGridWorkbook1.Grid.ColCount := 0;
  AdvGridWorkbook1.Grid.RowCount := 0;
//  AdvGridWorkbook1.Grid.FixedCols := 0;
//  AdvGridWorkbook1.Grid.FixedRows := 0;
end;

end.
