unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, tmsAdvGridExcel, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit,
  ExtCtrls, Grids, AdvObj, BaseGrid, AdvGrid, AdvGridWorkbook, Clipbrd;

type
  TForm1 = class(TForm)
    Panel7: TPanel;
    AdvFileNameEdit1: TAdvFileNameEdit;
    Button3: TButton;
    Panel8: TPanel;
    AdvGridWorkbook1: TAdvGridWorkbook;
    hi: TAdvStringGrid;
    AdvGridExcelIO1: TAdvGridExcelIO;
    Button1: TButton;
    procedure Button3Click(Sender: TObject);
    procedure hiSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure hiKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FCellPos : String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if not(AdvFileNameEdit1.FileName = '') then
    AdvGridExcelIO1.XLSImport(AdvFileNameEdit1.FileName);
end;

procedure TForm1.hiKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  LSheetNm : String;
  LCellPos : String;
begin
  if (Shift = [ssCtrl]) and (Key = 67) or (key = 99) then
  begin
    LSheetNm := AdvGridWorkbook1.Sheets.Items[AdvGridWorkbook1.ActiveSheet].Name;
    LCellPos := FCellPos;

    Clipboard.AsText := '('+LSheetNm+'!'+LCellPos+')';

  end;
end;

procedure TForm1.hiSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  Li : integer;
  Lr : integer;
  LCell : String;
  LCount : integer;
  LStr : String;
  LSheetNm : String;
  LCellPos : String;
begin
  Li := ACol;
  LCount := 0;
  LCell := '';

  if not(Li = 0) then
  begin
    while Li > 26 do
    begin
      Li := Li - 26;
      Inc(LCount);
    end;

    if (LCount > 0) and (LCount < 26) then
    begin
      LCell := Char(LCount+64);
      LCell := LCell + Char(Li+64);
    end
    else
    begin
      LCell := Char(li+64);
    end;
  end;

  FCellPos := LCell + IntToStr(ARow);

  LSheetNm := AdvGridWorkbook1.Sheets.Items[AdvGridWorkbook1.ActiveSheet].Name;
  LCellPos := FCellPos;

  Clipboard.AsText := '('+LSheetNm+'!'+LCellPos+')';
end;

end.
