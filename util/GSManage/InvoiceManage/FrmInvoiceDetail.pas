unit FrmInvoiceDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  AdvSprd, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TInvoiceDetailF = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    AdvStringGrid1: TAdvStringGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InvoiceDetailF: TInvoiceDetailF;

implementation

{$R *.dfm}

end.
