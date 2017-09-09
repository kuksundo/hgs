unit UnitTestReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NxEdit, ExtCtrls, AdvOfficeStatusBar, Grids, AdvObj,
  BaseGrid, AdvGrid, Excel2000, ImgList, Menus, Vcl.Mask, JvExMask, JvToolEdit,
  WatchSaveConst;

type
  TFormTestReport = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Button1: TButton;
    FileNameEdt: TNxEdit;
    Panel6: TPanel;
    StatusBar1: TAdvOfficeStatusBar;
    Panel7: TPanel;
    Button2: TButton;
    Panel8: TPanel;
    DataGrid: TAdvStringGrid;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel5: TPanel;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    DeleteSelectedRow1: TMenuItem;
    Button4: TButton;
    ReportFilenameEdit: TJvFilenameEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DataGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DeleteSelectedRow1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FReadytoPrint : Boolean;
  public
    FReportTitle : String; //보고서 제목
    FPersonInCharge : String; //담당자
    FTestStartNum : integer;//테스트번호
    FTestDateTime : TDateTime;
    FRow: Integer;
    FExcelInfo: TExcelInfoCollect<TExcelInfoItem>;

    procedure LoadFromFile2Grid(AFileName: string);
    procedure Create_Report(AIsOnlySelectedRow: Boolean);
    procedure Create_Report_By_Based_on_CSV_File(AFileName: string;
                                                  AIsOnlySelectedRow: Boolean);
    procedure fill_out_of_WholeSpec(AIsOnlySelectedRow: Boolean);
    procedure fill_out_of_DataSheet(AIsOnlySelectedRow: Boolean);
    procedure fill_out_of_Local(AIsOnlySelectedRow: Boolean);

    function Get_SheetInfo(FInfo:String):String;
    function Get_CellColumn(S:String):String;
    function Get_CellRow(S:String):String;
  end;

var
  FormTestReport: TFormTestReport;
//  Excel: Variant;
//  WorkBook: Variant;//ExcelWorkbook;
//  Fworksheet: OleVariant;

implementation

uses ExcelUtil, RpInfo_Unit;

{$R *.dfm}

procedure TFormTestReport.Button1Click(Sender: TObject);
var
  LFileName : String;
  LFileExt : String;
begin
  FReadyToPrint := False;
  OpenDialog1.Filter := 'CSV files (*.csv)|*.CSV';

  if OpenDialog1.Execute then
  begin
    LFileName := ExtractFileName(OpenDialog1.FileName);
    LFileExt := ExtractFileExt(LFileName);

    FileNameEdt.Text := LFileName;
    //OtherNameEdt.Text := FormatDateTime('YYMMDDHHmm_',Now) + LFileName;
    LoadFromFile2Grid(OpenDialog1.FileName);
  end;
end;

procedure TFormTestReport.Button2Click(Sender: TObject);
begin
  Create_Report(False);
end;

procedure TFormTestReport.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TFormTestReport.Button4Click(Sender: TObject);
begin
  Create_Report(True);
end;

procedure TFormTestReport.Create_Report(AIsOnlySelectedRow: Boolean);
var
  LRef : String;
  LNewRef : String;
  Lpath: string;
begin
  if FReadyToPrint then
  begin
    if AIsOnlySelectedRow then
    begin
      if DataGrid.RowSelectCount = 0 then
      begin
        ShowMessage('선택된 열이 없습니다.' + #13#10 + '1개 이상의 열(Row)를 선택하세요.!');
        Exit;
      end;
    end;

    // 양식 가져오기!!
    //LRef := ExcludeTrailingBackslash(ExtractFilePath(ExcludeTrailingBackslash(
    //        ExtractFilePath(Application.ExeName))))+
    //        '\resource\reportform\H35G_report_form.xls';
    //Lpath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)); //맨끝에 '\' 포함됨
    //LRef := Lpath + 'H35G_report_form.xls';
    LRef := ReportFilenameEdit.FileName;

    if not FileExists(LRef) then
    begin
      ShowMessage('양식 파일을 찾을 수 없습니다.'+#13+'파일을 확인하여 주십시오!!');
      Exit;
    end
    else
    begin
      //보고서 생성
      SaveDialog1.Filter := 'XLS files (*.xls)|*.xls';
      SaveDialog1.FileName := FormatDateTime('YYYYMMDDHHNNSS_',Now)+ExtractFileName(LRef);
      if SaveDialog1.Execute then
      begin
        LNewRef := SaveDialog1.FileName;

        //상대 경로는 안됨
        Windows.CopyFile(pChar(LRef),pChar(LNewRef),false);
        Create_Report_By_Based_on_CSV_File(LNewRef, AIsOnlySelectedRow);
      end;
    end;
  end
  else
  begin
    ShowMessage('데이터가 없거나, 예상밖의 문제로 보고서 생성 준비를 완료하지 못했습니다.');
    Exit;
  end;

end;

procedure TFormTestReport.Create_Report_By_Based_on_CSV_File(AFileName: string;
  AIsOnlySelectedRow: Boolean);
var
  LForm : TRpInfo_Frm;
  LBoolean : Boolean;
  li, j: integer;
begin
//  Excel := GetActiveExcelOleObject(False);
//  WorkBook := Excel.Workbooks.Open(AFileName);

  LForm := TRpInfo_Frm.Create(nil);
  try
    FReportTitle    := '';
    FPersonInCharge := '';
    FTestStartNum   := 0;
    LBoolean := False;
    FTestDateTime := now;

    with LForm do
    begin
      FOwner := Self;
      if AIsOnlySelectedRow then
        testcnt.Text := IntToStr(DataGrid.SelectedRowCount)
      else
        testcnt.Text := IntToStr(DataGrid.RowCount-1);

      if ShowModal = mrOK then
      begin
        FPersonInCharge := Testm.Text;
        FReportTitle    := TestNm.Text;
        FTestStartNum   := StrToIntDef(StartNum.Text,0);

        for li := 1 to DataGrid.RowCount-1 do
        begin
          if AIsOnlySelectedRow then
            if not DataGrid.RowSelect[li] then
              Continue;

          for j := 0 to FExcelInfo.Count - 1 do
            FExcelInfo.Items[j].ItemAvgValue := DataGrid.Cells[j+1,li]; //Engine Output

          FExcelInfo.MakeExcelReport(AFileName);
        end;//for
//        fill_out_of_WholeSpec(AIsOnlySelectedRow);
//        fill_out_of_DataSheet(AIsOnlySelectedRow);
//        fill_out_of_Local(AIsOnlySelectedRow);
//        EXcel.Visible := True;
      end
      else
      begin
//        WorkBook.Close;
//        Excel.Quit;
      end;
    end;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure TFormTestReport.DataGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  FRow := ARow;
end;

procedure TFormTestReport.DeleteSelectedRow1Click(Sender: TObject);
begin
  if MessageDlg('Selected Item is deleted.'+#13#10+'Are you sure?',
                              mtConfirmation, [mbYes, mbNo], 0)= mrYes then
  begin
    DataGrid.RemoveRows(FRow,1);
  end;
end;

procedure TFormTestReport.fill_out_of_DataSheet(AIsOnlySelectedRow: Boolean);
var
  WSName : String;
  LRange : OleVariant;
  LFirstCell : String;
  LfCell : integer;
  LCell : String;
  li,lc,li2 : integer;
  LtmpStr : String;
  LtmpList : TStringList;
  LSheetNm : String;
  LRowPos : String;
  LStr : String;
  LTestTime : TDateTime;
begin
  with DataGrid do
  begin
    LtmpStr := Get_SheetInfo(Cells[1,0]);
    Ltmplist := TStringList.Create;
    ExtractStrings(['!'], [], PChar(LtmpStr),Ltmplist);
    LSheetNm := LtmpList.Strings[0];
    LFirstCell := Get_CellColumn(LtmpList.Strings[1]);
    LfCell := (StrToInt(LFirstCell)-1);
    Ltmplist.Free;

    WSName := LSheetNm;
    FWorkbook.Sheets[WSname].Activate;
    fworksheet := FExcel.ActiveSheet;

    // 시험 타이틀
    //LCell := 'R3';
    //LRange := fworksheet.range[LCell];
    //LRange.FormulaR1C1 := FPersonInCharge;

    // 시험 담당자
    LCell := 'R3';
    LRange := fworksheet.range[LCell];
    LRange.FormulaR1C1 := FPersonInCharge;

    li := 0;
    for li2 := 1 to RowCount-1 do //Row
    begin
      if AIsOnlySelectedRow then
        if not RowSelect[li2] then
          Continue;

      inc(li);
      // Test No
      LCell := Char(LfCell+li)+'6';
      LRange := fworksheet.range[LCell];
      LStr := FormatDateTime('YYMMDD',FTestDateTime)+'-'+IntToStr(FTestStartNum);
      LRange.FormulaR1C1 := LStr;

      // Test Time
      LCell := Char(LfCell+li)+'7';
      LRange := fworksheet.range[LCell];
      LTestTime := StrToDateTime(Cells[0,li]);
      LRange.FormulaR1C1 := FormatDateTime('HH:mm',LTestTime);
      for lc := 1 to Colcount-1 do
      begin
        try
          LtmpStr := Get_SheetInfo(Cells[lc,0]);
          Ltmplist := TStringList.Create;
          ExtractStrings(['!'], [], PChar(LtmpStr),Ltmplist);
          if LtmpList.Count > 1 then
          begin
            LRowPos := Get_CellRow(LtmpList.Strings[1]);

            LCell := Char(LfCell+li)+LRowPos;
            LRange := fworksheet.range[LCell];
            LRange.FormulaR1C1 := Cells[lc,li];
          end;
        finally
          Ltmplist.Free;
        end;
      end;
      Inc(FTestStartNum);
    end;
  end;//with DataGrid
end;

procedure TFormTestReport.fill_out_of_Local(AIsOnlySelectedRow: Boolean);
var
  WSName : String;
  LRange : OleVariant;
  li,ld : integer;
  LCell : String;
begin
  WSName := 'Local';
  FWorkbook.Sheets[WSname].Activate;
  fworksheet := FExcel.ActiveSheet;

  with DataGrid do
  begin
    ld := 0;
    for li := 1 to DataGrid.RowCount-1 do
    begin
      if AIsOnlySelectedRow then
        if not RowSelect[li] then
          Continue;

      if not(li = 1) then
        ld := ld + 2;

      LCell := Char(69+ld)+'4'; //74+1 = K
      LRange := fworksheet.range[LCell];
      LRange.FormulaR1C1 := FormatDateTime('HH:mm',StrToDateTime(Cells[0,li])); //Test Time

      LCell := Char(69+ld)+'9';
      LRange := fworksheet.range[LCell];
      LRange.FormulaR1C1 := Cells[2,li]; //Engine Output

      LCell := Char(69+ld)+'10';
      LRange := fworksheet.range[LCell];
      LRange.FormulaR1C1 := Cells[3,li]; //Generator Output
    end;//for
  end;//with DataGrid
end;

procedure TFormTestReport.fill_out_of_WholeSpec(AIsOnlySelectedRow: Boolean);
var
  WSName : String;
  LRange : OleVariant;
  li : integer;
  lvalue : double;
  LCell : String;
begin
  WSName := 'WholeSpec';
  FWorkbook.Sheets[WSname].Activate;
  fworksheet := FExcel.ActiveSheet;

  LCell := 'G5';
  LRange := fworksheet.range[LCell];
  LRange.FormulaR1C1 := FReportTitle;//보고서 제목

  LCell := 'V5';
  LRange := fworksheet.range[LCell];
  LRange.FormulaR1C1 := FormatDatetime('YYYY-MM-DD',FTestDateTime);

  with DataGrid do
  begin
    // Low Caloric Value
    lvalue := 0;
    for li := 1 to Rowcount-1 do
    begin
      if AIsOnlySelectedRow then
      begin
        if RowSelect[li] then
          lvalue := lvalue + StrToFloat(Cells[10,li]);
      end
      else
        lvalue := lvalue + StrToFloat(Cells[10,li]);
    end;
    lvalue := Round(lvalue / Rowcount-1);

    LCell := 'W23';
    LRange := fworksheet.range[LCell];
    LRange.FormulaR1C1 := FloatToStr(lvalue);

    //Density (0°C,1atm) [kg/m3]
    lvalue := 0;
    for li := 1 to Rowcount-1 do
    begin
      if AIsOnlySelectedRow then
      begin
        if RowSelect[li] then
          lvalue := lvalue + StrToFloat(Cells[9,li]);
      end
      else
        lvalue := lvalue + StrToFloat(Cells[9,li]);
    end;

    lvalue := Round(lvalue / Rowcount-1);

    LCell := 'W24';
    LRange := fworksheet.range[LCell];
    LRange.FormulaR1C1 := FloatToStr(lvalue);
  end;
end;

procedure TFormTestReport.FormCreate(Sender: TObject);
begin
  FReadyToPrint := False;
  FExcelInfo := TExcelInfoCollect<TExcelInfoItem>.Create;
end;

procedure TFormTestReport.FormDestroy(Sender: TObject);
begin
  FExcelInfo.Free;
end;

function TFormTestReport.Get_CellColumn(S: String): String;
var
  li : integer;
  LStr : String;
  LChar : Char;
  LStr1 : String;
begin
  LStr := '';
  LStr1 := '';

  for li := 1 to Length(S) do
    if(StrToIntDef(S[Li],-1) = -1)then
      LStr := LStr + S[Li];

  LChar := LStr[1];
  Result := IntToStr(Ord(LChar));
end;

function TFormTestReport.Get_CellRow(S: String): String;
var
  li : integer;
begin
  Result := S;
  for li := 0 to Length(S) do
    if(StrToIntDef(S[Li],-1) = -1)then
      Delete(Result,Pos(S[li],Result),1);
end;

function TFormTestReport.Get_SheetInfo(FInfo: String): String;
var
  tmpStr : String;
  lstmp : TStringList;
begin
  Result := '';
  tmpStr := FInfo;
  lstmp := TStringList.Create;
  try
    ExtractStrings(['(',')'], [], PChar(tmpStr),lstmp);
    Result := lstmp.Strings[lstmp.Count-1];
  finally
    FreeAndNil(lstmp);
  end;
end;

procedure TFormTestReport.LoadFromFile2Grid(AFileName: string);
begin
  with DataGrid do
  begin
    try
      Clear;
      LoadFromCSV(AFileName);
      FReadyToPrint := True;
    except
      FReadyToPrint := False;
      ShowMessage('예상밖의 문제로 보고서 생성 준비를 완료하지 못하였습니다.');
      Exit;
    end;
  end;
end;

end.
