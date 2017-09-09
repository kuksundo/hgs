unit MF_EMPL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExcelUtil, StrUtils, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, StdCtrls, NxEdit, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection, NxCollection,
  AdvOfficeStatusBar, Menus;


type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    NextGrid1: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    Button1: TButton;
    NxTextColumn3: TNxTextColumn;
    NxEdit1: TNxEdit;
    Button2: TButton;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    NextGrid2: TNextGrid;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    NxTextColumn18: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    NxTextColumn21: TNxTextColumn;
    NxTextColumn22: TNxTextColumn;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    NxPanel1: TNxPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    xlRows : integer;// ¿¢¼¿ÆÄÀÏ ÀüÃ¼ Row

    procedure DataBase_Connect;

    procedure GetCodeFromExcel;
    procedure CODE2DATABASE;
    procedure DATA2DATABASE;
    procedure DATA2Table;
  end;

var
  Form1: TForm1;
  Excel: Variant;
  WorkBook: Variant;//ExcelWorkbook;
  Fworksheet: OleVariant;

implementation
uses
  String_Func;



{$R *.dfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  GetCodeFromExcel;
  DATA2Table;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  CODE2DATABASE;
  DATA2DATABASE;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  with ZQuery1 do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('select * from Materialscode');
    Active := True;

    ShowMessage(IntToStr(RecordCount));


  end;
end;

procedure TForm1.CODE2DATABASE;
var
  li : integer;
begin
  with ZQuery1 do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('insert into MATERIALSCODE');
    SQL.Add('Values(:No, :MCODE, :DESC)');

    with NextGrid1 do
    begin
      for li := 0 to RowCount-1 do
      begin
        paramByname('MCODE').AsString := Cells[2,li];
        paramByname('DESC').AsString := Cells[3,li];
        ExecSQL;
      end;
    end;
  end;
end;

procedure TForm1.DATA2DATABASE;
var
  LRange: OleVariant;
  LStr : String;
  Li : integer;
  Lc : integer;

begin
  with ZQuery1 do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('insert into MATERIALSPL');
    SQL.Add('Values(:SCODE, :LEV, :POSNO, :EXIT, :INFONO, :DWGNO, :REV, :DESC,');
    SQL.Add(':MATERIAL, :UNIT, :QTYCYL1, :QTYCYL2, :QTYCYL3, :QTYCYL4, :QTYCYL5,');
    SQL.Add(':WEIGHT, :PRDSEC, :SHIPNO, :REMARK)');

    with NextGrid2 do
    begin
      for li := 0 to RowCount-1 do
      begin
        Form1.Caption := IntToStr(li+1);

        paramByname('SCode').AsString    := Cells[0,li];
        paramByname('LEV').AsString      := Cells[1,li];
        paramByname('POSNO').AsString    := Cells[2,li];
        paramByname('EXIT').AsString     := Cells[3,li];
        paramByname('INFONO').AsString   := Cells[4,li];

        paramByname('DWGNO').AsString    := Cells[5,li];
        paramByname('REV').AsString      := Cells[6,li];
        paramByname('DESC').AsString     := Cells[7,li];
        paramByname('MATERIAL').AsString := Cells[8,li];
        paramByname('UNIT').AsString     := Cells[9,li];

        paramByname('QTYCYL1').AsString  := Cells[10,li];
        paramByname('QTYCYL2').AsString  := Cells[11,li];
        paramByname('QTYCYL3').AsString  := Cells[12,li];
        paramByname('QTYCYL4').AsString  := Cells[13,li];
        paramByname('QTYCYL5').AsString  := Cells[14,li];

        paramByname('WEIGHT').AsString   := Cells[15,li];
        paramByname('PRDSEC').AsString   := Cells[16,li];
        paramByname('SHIPNO').AsString   := Cells[17,li];
        paramByname('REMARK').AsString   := Cells[18,li];

        ExecSQL;
      end;//for
    end;//with NextGrid2
  end;//with
end;

procedure TForm1.DATA2Table;
var
  LRange: OleVariant;
  LStr : String;
  Li : integer;
  Lc : integer;

begin

  LStr := Excel.ActiveSheet.Name;
  Workbook.Sheets[LStr].Activate;
  fworksheet := Excel.ActiveSheet;

  for li := 0 to NextGrid1.RowCount-1 do
  begin
    Form1.Caption := IntToStr(li+1);
    with NextGrid1 do
    begin
      if not(li = RowCount-1) then
      begin
        for lc := (StrToInt(Cells[1,li])+2) to (StrToInt(Cells[1,li+1])-1) do
        begin
          with NextGrid2 do
          begin
            LStr := 'G'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            if LStr = '' then
              Break
            else
              addRow(1);

            Cells[7,RowCount-1] := LStr; //Description

            Cells[0,RowCount-1] := NextGrid1.Cells[2,li];//SCode

            LStr := 'A'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[1,RowCount-1] := LStr;//SCode

            LStr := 'B'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[2,RowCount-1] := LStr;

            LStr := 'C'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[3,RowCount-1] := LStr;

            LStr := 'D'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[4,RowCount-1] := LStr;

            LStr := 'E'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[5,RowCount-1] := LStr;

            LStr := 'F'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[6,RowCount-1] := LStr;

            LStr := 'H'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[8,RowCount-1] := LStr;

            LStr := 'I'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[9,RowCount-1] := LStr;

            LStr := 'J'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[10,RowCount-1] := LStr;

            LStr := 'K'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[11,RowCount-1] := LStr;

            LStr := 'L'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[12,RowCount-1] := LStr;

            LStr := 'M'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[13,RowCount-1] := LStr;

            LStr := 'N'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[14,RowCount-1] := LStr;

            LStr := 'O'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[15,RowCount-1] := LStr;

            LStr := 'P'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[16,RowCount-1] := LStr;

            LStr := 'Q'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[17,RowCount-1] := LStr;

            LStr := 'V'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[18,RowCount-1] := LStr;
          end;
        end;
      end
      else
      begin
        for lc := (StrToInt(Cells[1,RowCount-1])+2) to xlRows do
        begin
          with NextGrid2 do
          begin
            LStr := 'G'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            if LStr = '' then
              Break
            else
              addRow(1);

            Cells[7,RowCount-1] := LStr; //Description

            Cells[0,RowCount-1] := NextGrid1.Cells[2,li];//SCode

            LStr := 'A'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[1,RowCount-1] := LStr;//SCode

            LStr := 'B'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[2,RowCount-1] := LStr;

            LStr := 'C'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[3,RowCount-1] := LStr;

            LStr := 'D'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[4,RowCount-1] := LStr;

            LStr := 'E'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[5,RowCount-1] := LStr;

            LStr := 'F'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[6,RowCount-1] := LStr;

            LStr := 'H'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[8,RowCount-1] := LStr;

            LStr := 'I'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[9,RowCount-1] := LStr;

            LStr := 'J'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[10,RowCount-1] := LStr;

            LStr := 'K'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[11,RowCount-1] := LStr;

            LStr := 'L'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[12,RowCount-1] := LStr;

            LStr := 'M'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[13,RowCount-1] := LStr;

            LStr := 'N'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[14,RowCount-1] := LStr;

            LStr := 'O'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[15,RowCount-1] := LStr;

            LStr := 'P'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[16,RowCount-1] := LStr;

            LStr := 'Q'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[17,RowCount-1] := LStr;

            LStr := 'V'+IntToStr(lc);
            LRange := fworksheet.range[LStr];
            LStr := LRange.FormulaR1C1;
            Cells[18,RowCount-1] := LStr;
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm1.DataBase_Connect;
begin
  //D:\sh2keke\0.Project\EMPL_\DB\EMPLSQ3DB.s3db
  if not(ZConnection1.Connected) then
  begin
    with ZConnection1 do
    begin
      Database := ExtractFilePath(Application.exename) + 'DB\EMPLSQ3DB.s3db';
      protocol := 'sqlite-3';
      Connected := True;
    end;//with
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ZConnection1.Connected then
      ZConnection1.Connected := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DataBase_Connect;
end;

procedure TForm1.GetCodeFromExcel;
var
  LRange: OleVariant;
  LStr : String;
  li,lc : integer;
  LCode : String;

begin
  if OpenDialog1.Execute then
  begin
    NxEdit1.Text := ExTractFileName(OpenDialog1.FileName);
    Excel := GetActiveExcelOleObject(True);
    WorkBook := Excel.Workbooks.Open(OpenDialog1.FileName);
    Excel.Visible := True;
    Excel.ActiveWindow.Zoom := 70;
    xlRows := Excel.ActiveSheet.UsedRange.Rows.Count;
//    xlCols := Excel.ActiveSheet.UsedRange.Columns.Count;

    LStr := Excel.ActiveSheet.Name;
    Workbook.Sheets[LStr].Activate;
    fworksheet := Excel.ActiveSheet;

    NextGrid1.ClearRows;
    for li := 0 to xlRows - 1 do
    begin
      LStr := 'E'+IntToStr(li+1);
      LRange := fworksheet.range[LStr];
      LCode := LRange.FormulaR1C1;

      if leftStr(LCode,5) = 'Group' then
      begin
        with NextGrid1 do
        begin
          AddRow(1);


          Cells[1,RowCount-1] := IntToStr(li+1); // Code Row;

          LStr := GetToKen(LCode,':');
          Cells[2,RowCount-1] := LCode;

          LStr := 'G'+IntToStr(li+1);
          LRange := fworksheet.range[LStr];
          Cells[3,RowCount-1] := LRange.FormulaR1C1;
        end;
      end;//if
    end;//for
    NextGrid1.Refresh;
  end;//if
end;

end.
