unit WatchSaveConst;

interface

uses Messages, System.Classes, Generics.Legacy, Excel2000, mORMot;

type
  TExcelInfoItem = class(TCollectionItem)
  private
    FItemName,
    FItemValue,
    FItemAvgValue,
    FSheetName,
    FCellRange: string;
  published
    property ItemName: string read FItemName write FItemName;
    property ItemValue: string read FItemValue write FItemValue;
    property ItemAvgValue: string read FItemAvgValue write FItemAvgValue;
    property SheetName: string read FSheetName write FSheetName;
    property CellRange: string read FCellRange write FCellRange;
  end;

  TExcelInfoCollect<T: TExcelInfoItem> = class(Generics.Legacy.TCollection<T>)
  public
    procedure MakeExcelReport(AFileName: string; ASheetCount: integer = 1);
    procedure AssignTo(Dest: TExcelInfoCollect<TExcelInfoItem>);
  end;

Const
{  WM_EVENT_DATA = WM_USER + 100;
  WM_WATCHFORM_CLOSE = WM_USER + 101;
  WM_EVENT_WT1600 = WM_USER + 102;
  WM_EVENT_MEXA7000 = WM_USER + 103;
  WM_EVENT_MT210 = WM_USER + 104;
  WM_EVENT_ECS_KUMO = WM_USER + 105;
  WM_EVENT_LBX = WM_USER + 106;
  WM_EVENT_DYNAMO = WM_USER + 107;
  WM_EVENT_ECS_AVAT = WM_USER + 108;
  WM_EVENT_GASCALC  = WM_USER + 110;
}//UnitFrameIPCConst.pas¿¡ ¼±¾ðµÊ
  SB_MESSAGE_IDX = 5;
  MAXCHANNELCOUNT = 8;

  CONFIG_FILE_EXT = '.config';

var
  FExcel: OleVariant;
  FWorkBook: OleVariant;
  Fworksheet: OleVariant;

implementation

uses ExcelUtil;

{ TExcelInfoCollect<T> }

procedure TExcelInfoCollect<T>.AssignTo(
  Dest: TExcelInfoCollect<TExcelInfoItem>);
begin
  CopyObject(Self, Dest);
end;

procedure TExcelInfoCollect<T>.MakeExcelReport(AFileName: string; ASheetCount: integer);
var
  LRange : OleVariant;
  i, LSheetCount: integer;
begin
  FExcel := GetActiveExcelOleObject(False);
  FWorkBook := FExcel.Workbooks.Open(AFileName);

  if ASheetCount = 1 then
  begin
    for i := 0 to Self.Count - 1 do
    begin
      if Self.Items[i].CellRange <> '' then
      begin
        FWorkbook.Sheets[Self.Items[i].SheetName].Activate;
        FWorksheet := FExcel.ActiveSheet;
        LRange := FWorksheet.range[Self.Items[i].CellRange];
        LRange.FormulaR1C1 := Self.Items[i].ItemAvgValue;
      end;
    end;
  end
  else
  begin
    LSheetCount := ASheetCount - FWorkBook.Sheets.Count;

    for i := 1 to LSheetCount do
      FWorkBook.Sheets.Add('_' + FWorkBook.Sheets(FWorkBook.Sheets.Count));

    for LSheetCount := 1 to FWorkBook.Sheets.Count do
    begin
      FWorkSheet := FWorkBook.Sheets[LSheetCount].Select;

      for i := 0 to Self.Count - 1 do
      begin
        if Self.Items[i].CellRange <> '' then
        begin
          LRange := FWorksheet.range[Self.Items[i].CellRange];
          LRange.FormulaR1C1 := Self.Items[i].ItemAvgValue;
        end;
      end;
    end;
  end;

  FExcel.Visible := True;
end;

end.
