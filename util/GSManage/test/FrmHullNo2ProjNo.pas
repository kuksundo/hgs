unit FrmHullNo2ProjNo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask,
  JvToolEdit;

type
  TForm3 = class(TForm)
    JvFilenameEdit1: TJvFilenameEdit;
    Label2: TLabel;
    Label1: TLabel;
    JvFilenameEdit2: TJvFilenameEdit;
    Label3: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses UnitExcelUtil;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  LExcel: OleVariant;
  LWorkBook: OleVariant;
  LRange: OleVariant;
  LWorksheet: OleVariant;

  LExcel2: OleVariant;
  LWorkBook2: OleVariant;
  LRange2, LRange3, LRange4: OleVariant;
  LWorksheet2: OleVariant;

  LStr, LHullNo, LProjNo: string;
  LIdx, LLastRow: integer;
  AFileName, BFileName: string;
begin
  AFileName := JvFilenameEdit1.FileName;
  BFileName := JvFilenameEdit2.FileName;

  LExcel := GetActiveExcelOleObject(True);
  LWorkBook := LExcel.Workbooks.Open(AFileName);
  LWorksheet := LExcel.ActiveSheet;

  LExcel2 := GetActiveExcelOleObject(True);
  LWorkBook2 := LExcel2.Workbooks.Open(BFileName);
  LWorksheet2 := LExcel2.ActiveSheet;
  LLastRow := GetLastRowNumFromExcel(LWorkSheet2);

  LStr := 'A';
  LIdx := 2;
  LRange := LWorksheet.range[LStr+IntToStr(LIdx)];

  while Lidx <= LLastRow do
  begin
    if LRange.FormulaR1C1 <> '' then
    begin
      LHullNo := LRange.FormulaR1C1;
      LRange := LWorksheet.range['D'+IntToStr(LIdx)];
      LProjNo := LRange.FormulaR1C1;

      LRange2 := LWorkSheet2.Range['N6:N'+IntToStr(LLastRow)];
      LRange3 := Null;
      LRange3 := LRange2.Find(LProjNo);

  //    if not VarIsNull(LRange3) then
      if not VarIsClear(LRange3) then
      begin
        LRange3 := LWorkSheet2.Range['O'+IntToStr(LRange3.Row)];
        LRange3.FormulaR1C1 := LHullNo;
//        ShowMessage(IntToStr(LRange3.Column));
//        ShowMessage(IntToStr(LRange3.Row));
      end;
  //    LRange4 := LWorkSheet2.Range[];
    end;

    Inc(LIdx);
    LRange := LWorksheet.range[LStr+IntToStr(LIdx)];
  end;

  LWorkBook.Close;
  LExcel.Quit;
end;

end.
