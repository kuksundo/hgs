unit STATISTICS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, ComCtrls, Grids, BaseGrid, AdvGrid, Main_UNIT, jpeg,
  Buttons, StrUtils, ComObj, ADVOBJ, NxPageControl, NxCollection,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxEdit,
  VCLTee.Series, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart, Menus, AdvOfficeStatusBar,
  NxColumnClasses, NxColumns, AdvGroupBox, AdvOfficeButtons, VclTee.TeeGDIPlus;

type
  TRP_Agg = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    NxPageControl1: TNxPageControl;
    NxTabSheet1: TNxTabSheet;
    NxSplitter1: TNxSplitter;
    NxTabSheet2: TNxTabSheet;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    NxHeaderPanel3: TNxHeaderPanel;
    Chart2: TChart;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    NxPanel1: TNxPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    SearchED1: TNxComboBox;
    Panel30: TPanel;
    SearchED2: TNxComboBox;
    Panel31: TPanel;
    Panel32: TPanel;
    ACount: TNxEdit;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    QED: TNxEdit;
    Panel36: TPanel;
    EED: TNxEdit;
    Panel37: TPanel;
    AED: TNxEdit;
    Panel38: TPanel;
    CED: TNxEdit;
    Panel39: TPanel;
    XED: TNxEdit;
    Panel41: TPanel;
    NxHeaderPanel2: TNxHeaderPanel;
    NextGrid1: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxHeaderPanel4: TNxHeaderPanel;
    Chart1: TChart;
    Series1: TPieSeries;
    DeptCB: TNxComboBox;
    Series2: TBarSeries;
    NxHeaderPanel5: TNxHeaderPanel;
    RP_Type: TAdvOfficeCheckGroup;
    EngType: TNxComboBox;
    NxButton3: TNxButton;
    NxLabel2: TNxLabel;
    NxButton4: TNxButton;
    NxButton5: TNxButton;
    NxButton1: TNxButton;
    NxButton2: TNxButton;
    NxLabel1: TNxLabel;
    AlignRP: TAdvOfficeRadioGroup;
    NxLabel3: TNxLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    NxPageControl2: TNxPageControl;
    NxTabSheet3: TNxTabSheet;
    SMainTable: TAdvStringGrid;
    NxTabSheet4: TNxTabSheet;
    DescGrid: TAdvStringGrid;
    Panel26: TPanel;
    SpeedButton1: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure SMainTableClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure SMainTableGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SearchED2ButtonDown(Sender: TObject);
    procedure NxButton1Click(Sender: TObject);
    procedure RP_TypeClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure EngTypeButtonDown(Sender: TObject);
    procedure NxButton4Click(Sender: TObject);
    procedure NxButton5Click(Sender: TObject);
    procedure NxButton3Click(Sender: TObject);
    procedure SMainTableGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure SMainTableCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure DescGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
  private

  public
    FOwner : TMain_Frm;
    Ffirst : Boolean;
    FSUserID : String;

    procedure SMainTable_Initialize;// 메인테이블 초기화

    //상세조건 아이템 추가...
    procedure case_of_Search_Report(FCase:integer);

    //조건별 조회................
    procedure Search_Terms;
    procedure Terms_Data_2_Graph;

    //보고서 출력부....
    procedure Align_of_ReportType;
    procedure Align_of_Indate;
    procedure Summary_For_Report(FRecordCount:integer);


    // 보고서 조회 후 상세보기
    procedure Trouble_Desc_Table_Header_Setting;
    procedure Trouble_Desc_Cell_Setting(FListCount:Integer);
    procedure Trouble_Desc_Data_Mapping(FCODEID:String;FStartRow,FCount:integer);

  end;

var
  RP_Agg : TRP_Agg;
  Excel: Variant;
  WorkBook: Variant;//ExcelWorkbook;
  Fworksheet: OleVariant;
  ALoadCount : integer; //Load Counter;
  ATestBedNo : integer; //Test Bed No;

implementation
uses
  Excel2000, ExcelUtil, DataModule_Unit, CommonUtil_Unit;

{$R *.dfm}

procedure TRP_Agg.FormCreate(Sender: TObject);
var
  li : integer;

begin
  Ffirst := True;
//  RP_G_Date.Date := Now;
  SMainTable_Initialize;
  NxPageControl1.ActivePageIndex := 0;

end;



procedure TRP_Agg.SMainTableCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  if ACol = 1 then
    CanEdit := True;

end;

procedure TRP_Agg.SMainTableClickCell(Sender: TObject; ARow,
  ACol: Integer);
var
  Stat : Boolean;
begin
  if ACol = 0 then
  begin
    if SMainTable.GetCheckBoxState(0,ARow,Stat) then
    begin
      if Stat = True then
        SMainTable.SetCheckBoxState(0,ARow,False)
      else
        SMainTable.SetCheckBoxState(0,Arow,True);
    end;//if
  end;//if
end;

procedure TRP_Agg.SMainTableGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin

  case ARow  of
    0 ..2 : VAlign := TVAlignment.vtaCenter;
  end;

  case ACol of
    0..6 : HAlign := taCenter;
    9..11 : HAlign := taCenter;
  end;
  {
  Case ACol of
    0..6  :
    7..8  : HAlign := taLeftJustify;
    9..10 : HAlign := taCenter;
  end;
  }
end;

procedure TRP_Agg.SMainTableGetEditorType(Sender: TObject; ACol, ARow: Integer;
  var AEditor: TEditorType);
begin
  if ACol = 1 then
  begin

    AEditor := edCheckBox;
  end;
end;

procedure TRP_Agg.SMainTable_Initialize;
begin
  SMainTable.Clear;
  SMainTable.RowCount := 4;

  with SMainTable do
  begin
    MergeCells(0,0,1,3);
    MergeCells(1,0,1,3);
    MergeCells(2,0,1,3);

    MergeCells(3,0,4,1);
    MergeCells(7,0,5,1);

    MergeCells(7,1,1,2);
    MergeCells(8,1,1,2);
    MergeCells(9,1,1,2);
    MergeCells(10,1,1,2);
    MergeCells(11,1,1,2);

    Cells[0,1] := #13#10+'No';
    Cells[1,1] := #13#10+'선택';
    Cells[2,1] := #13#10+'발생일';

    Cells[3,0] := '초도품 조립문제';
    Cells[3,1] := '설계';
    Cells[4,1] := '제작';
    Cells[5,1] := 'VOC';
    Cells[6,1] := '기타';

    Cells[3,2] := '[A]';
    Cells[4,2] := '[B]';
    Cells[5,2] := '[C]';
    Cells[6,2] := '[D]';

    Cells[7,0] := '문제점 조치사항';
    Cells[7,1] := #13#10+'품 명';
    Cells[8,1] := #13#10+'조 치 사 항';
    Cells[9,1] := #13#10+'조치일';
    Cells[10,1] := #13#10+'설계변경';
    Cells[11,1] := #13#10+'문제유형';

    Alignments[7,0] := taCenter;
    Alignments[7,1] := taCenter;
    Alignments[8,1] := taCenter;
  end;

  Trouble_Desc_Table_Header_Setting;
end;

procedure TRP_Agg.SpeedButton1Click(Sender: TObject);
var
  LFileName : String;
  Li : integer;
begin
  LFileName := FormatDateTime('YYMMDD',Now)+'_'+LeftStr(EngType.Text,6)+'_'+'Trouble_Report.xls';
  SaveDialog1.FileName := LFileName;
  if SaveDialog1.Execute then
  begin
    for li := 0 to 1 do
    begin
      with DM1.AdvGridExcelIO1 do
      begin
        DateFormat := 'YYYY-MM-DD';
        case li of
          0 : begin
                AdvStringGrid := SMainTable;
                XLSExport(SaveDialog1.FileName,'Sheet1');
              end;
          1 : begin
                AdvStringGrid := DescGrid;
                XLSExport(SaveDialog1.FileName,'Sheet2');
              end;
        end;//case
      end;
    end;
    ShowMessage('목록 출력이 완료 되었습니다.');
  end;
end;

procedure TRP_Agg.Summary_For_Report(FRecordCount:integer);
var
  LSRow, LERow : integer;
  LSum : integer;
  li,lc : integer;
  LDouble : Double;

begin
  LSRow := 3;
  LERow := SMainTable.RowCount-1;

  with SMainTable do
  begin
    AddRow;
    MergeCells(0,RowCount-1,3,1);
    Cells[0,RowCount-1] := '합 계';
    RowColor[RowCount-1] := clBtnFace;

    AddRow;
    MergeCells(0,RowCount-1,3,1);
    Cells[0,RowCount-1] := '비 율';
    RowColor[RowCount-1] := clBtnFace;

    for li := 0 to 3 do
    begin
      LSum := 0;
      for lc := LSRow to LERow do
        if not(Cells[3+li,lc] = '') then
          LSum := LSum + StrToInt(Cells[3+li,lc]);

      if Lsum > 0 then
      begin
        Cells[3+li,RowCount-2] := intToStr(LSum);
        LDouble := (LSum / FRecordCount)*100;
        Cells[3+li,RowCount-1] := FormatFloat('###',LDouble)+'%';
//        Cells[3+li,RowCount-1] := FloatToStr(LDouble)+'%';
      end;
    end;
  end;
end;

procedure TRP_Agg.DescGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if (Arow <= 1) then
  begin
    HAlign := taCenter;
    VAlign := TVAlignment.vtaCenter;
  end;

  if (ARow > 1) then
  begin
    case ACol of
      4..7 : begin
               HAlign := taCenter;
               VAlign := TVAlignment.vtaCenter;
             end;
    end;
  end;
end;


procedure TRP_Agg.FormActivate(Sender: TObject);
var
  li : integer;
  LStr : String;

begin
  if Ffirst = True then
  begin
    Trouble_Desc_Table_Header_Setting;

    Chart1.Series[0].Clear;
    for li := 0 to 4 do
    begin
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from Trouble_Data');
        SQL.Add('where Dept = :param1 And DTeam = :param2');
        case DeptCB.ItemIndex of
          0 : paramByname('param1').AsString := 'K2B0';
        end;//case
        paramByname('param2').AsString := IntToStr(li+1);
        Open;

        if not (RecordCount = 0) then
        begin
          case li of
            0 : LStr := '시험기획과';
            1 : LStr := '성능기술과';
            2 : LStr := 'FIE기술과';
            3 : LStr := '제어기술과';
            4 : LStr := '시험기술과';
          end;//case

          Chart1.Series[0].AddY(RecordCount,LStr);
        end;
      end;//with
    end;//for
    Ffirst := False;
  end;
end;

procedure TRP_Agg.SearchED2ButtonDown(Sender: TObject);
begin
  SearchED2.Items.Clear;

  if SearchEd1.ItemIndex > -1 then
    case_of_Search_Report(SearchEd1.ItemIndex);
end;

procedure TRP_Agg.NxButton1Click(Sender: TObject);
begin
  if not(SearchED2.Text = '') then
  begin
    ACount.Clear;
    QED.Clear;
    EED.Clear;
    AED.Clear;
    CED.Clear;
    XED.Clear;

    Search_Terms;

    ACount.Text := IntToStr(StrToInt(QED.Text)+StrToInt(EED.Text)+StrToInt(AED.Text)+
                   StrToInt(CED.Text)+StrToInt(XED.Text));

    Terms_Data_2_Graph;
  end;
end;



procedure TRP_Agg.Search_Terms;
var
  li : integer;
  lc : integer;
  lmc : integer;
  LDate : TDateTime;
begin
  NextGrid1.ClearRows;
  for li := 0 to 4 do
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from Trouble_Data');
      case SearchED1.ItemIndex of
        1 : SQL.Add('where InEmpno = :param1 And RpType = :param2 order by Indate Desc');
        2 : SQL.Add('where Projno = :param1 And RpType = :param2 order by Indate Desc');
        3 : SQL.Add('where DTeam = :param1 And RpType = :param2 order by Indate Desc');
      end;

      case SearchEd1.ItemIndex of
        1 : parambyname('param1').AsString := LeftStr(SearchED2.Text,7);
        2 : parambyname('param1').AsString := LeftStr(SearchED2.Text,6);
        3 : begin
              case SearchED2.ItemIndex of
                0 : parambyname('param1').AsString := '1';
                1 : parambyname('param1').AsString := '2';
                2 : parambyname('param1').AsString := '3';
                3 : parambyname('param1').AsString := '4';
                4 : parambyname('param1').AsString := '5';
              end;//case
            end;

      end;//else

      case li of
        0 : parambyname('param2').AsString := '0';
        1 : parambyname('param2').AsString := '1';
        2 : parambyname('param2').AsString := '2';
        3 : parambyname('param2').AsString := '3';
        4 : parambyname('param2').AsString := '4';
      end;//case
      Open;

      case li of
        0 : QED.Text := IntToStr(RecordCount);
        1 : EED.Text := IntToStr(RecordCount);
        2 : AED.Text := IntToStr(RecordCount);
        3 : CED.Text := IntToStr(RecordCount);
        4 : XED.Text := IntToStr(RecordCount);
      end;//case

      // 리스트 출력부......................
      while not eof do
      begin
        with NextGrid1 do
        begin
          AddRow(1);
          Cells[1,RowCount-1] := FieldByName('CODEID').AsString;
          case li of
            0 : Cells[2,RowCount-1] := '품질문제';
            1 : Cells[2,RowCount-1] := '설비문제';
            2 : Cells[2,RowCount-1] := '조립문제';
            3 : Cells[2,RowCount-1] := '시운전문제';
            4 : Cells[2,RowCount-1] := '문제예상';
          end;//case
          Cells[3,RowCount-1] := FieldByName('StatusTitle').AsString;//문제점 내용
          Next;
        end;//with
      end;//while
    end;//with
  end;//for
end;


procedure TRP_Agg.Terms_Data_2_Graph;
var
  li : integer;
  lmc : integer;
  LStr : String;
  LDate : String;
begin
  chart2.Series[0].Clear;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_Data');
    case SearchED1.ItemIndex of
      1 : SQL.Add('where InEmpno = :param1 order by Indate');
      2 : SQL.Add('where Projno = :param1 order by Indate');
      3 : SQL.Add('where DTeam = :param1 order by Indate');
    end;

    Case SearchED1.ItemIndex of
      1 : parambyname('param1').AsString := LeftStr(SearchED2.Text,7);
      2 : parambyname('param1').AsString := LeftStr(SearchED2.Text,6);
      3 : begin
            case SearchED2.ItemIndex of
              0 : parambyname('param1').AsString := '1';
              1 : parambyname('param1').AsString := '2';
              2 : parambyname('param1').AsString := '3';
              3 : parambyname('param1').AsString := '4';
              4 : parambyname('param1').AsString := '5';
            end;//case
          end;

    end;

    Open;

    if RecordCount = 0 then Exit;

    LDate := FormatDateTime('YYYY-MM',FieldByName('Indate').AsDateTime);

    lmc := 0;
    for li := 0 to RecordCount-1 do
    begin
      LStr := FormatDateTime('YYYY-MM',FieldByName('Indate').AsDateTime);
      if not(LDate <> LStr) then
      begin
        Inc(lmc);
        if li >= RecordCount-1 then
          Chart2.Series[0].AddY(Lmc,LStr);
      end
      else
      begin
        Chart2.Series[0].AddY(Lmc,LDate);
        LDate := FormatDateTime('YYYY-MM',FieldByName('Indate').AsDateTime);
        lmc := 1;
      end;
      Next;
    end;//for
  end;//with
end;

procedure TRP_Agg.Trouble_Desc_Cell_Setting(FListCount:Integer);
var
  LDescRow : integer;
  LStartRow : integer;
  li,lc : integer;
begin
  LDescRow := (FListCount * 4)+2;
  LStartRow := 2;

  with DescGrid do
  begin
    RowCount := LDescRow;
    for li := 0 to FListCount-1 do
    begin
      for lc := 0 to 8 do
      begin
        if not(LC = 2) then
          with DescGrid do
            MergeCells(LC,LStartRow,1,4);

      end;
      Cells[0,LStartRow] := IntToStr(li+1);
      LStartRow := LStartRow + 4;
    end;
  end;
end;

procedure TRP_Agg.Trouble_Desc_Data_Mapping(FCODEID: String; FStartRow,FCount: integer);
var
  li : integer;
  LStr : String;
  LEXT : String;
  LTS : TStream;
  LPic : TPicture;
  LBmp : TBitmap;
  LJpg : TJpegImage;
  LDate : TDateTime;

begin
  if not (FCODEID = '') then
  begin
    with DM1.TQuery2 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from Trouble_Data where CODEID = :param1');
      parambyname('param1').AsString := FCODEID;
      Open;
      with DescGrid do
      begin
        Cells[0,FStartRow] := intToStr(FCount);
        Cells[1,FStartRow] := Fieldbyname('ItemName').AsString;

        for li := 0 to 3 do
        begin
          case li of
            0 : Cells[2,FStartRow+li] := Fieldbyname('StatusTitle').AsString;
            1 : Cells[2,FStartRow+li] := Fieldbyname('ReasonTitle').AsString;
            2 : Cells[2,FStartRow+li] := Fieldbyname('Plantitle').AsString;
            3 : Cells[2,FStartRow+li] := Fieldbyname('Reason1Title').AsString;
          end;
        end;
        Cells[3,FStartRow] := Fieldbyname('Result').AsString;

        li := Fieldbyname('FResult').AsInteger;
        case li of
          0 : Cells[4,FStartRow] := '미조치';
          1 : Cells[4,FStartRow] := '조치입력';
          2 : Cells[4,FStartRow] := '조치완료';
        end;

        if not(Fieldbyname('SDate').AsString = '') then
          Cells[5,FStartRow] := FormatDateTime('YY.MM.DD',Fieldbyname('SDate').AsDateTime)
        else
          Cells[5,FStartRow] := '';

        if not(Fieldbyname('EDate').AsString = '') then
          Cells[6,FStartRow] := FormatDateTime('YY.MM.DD',Fieldbyname('EDate').AsDateTime)
        else
          Cells[6,FStartRow] := '';


        case Fieldbyname('DesignApp').AsInteger of
          0 : Cells[7,FStartRow] := '미반영';
          1 : Cells[7,FStartRow] := '반영';
        end;

        DescGrid.FontSizes[5,FStartRow] := 7;
        DescGrid.FontSizes[6,FStartRow] := 7;
        DescGrid.FontSizes[7,FStartRow] := 7;


      end;
    end;
    with DM1.TQuery2 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from Trouble_Attfiles');
      SQL.Add('where CODEID = :param1 and AttFlag = :param2');
      parambyname('param1').AsString := FCODEID;
      parambyname('param2').AsString := 'I';
      Open;

      if not(REcordCount =0) then
      begin
        try
          LEXT := Fieldbyname('FileEXT').AsString;
          LTS := TStream.Create;
          LTS := createblobstream(fieldbyname('Files'), bmread);

          if (LEXT = 'JPG') or (LEXT = 'JPEG') then
          begin
            LJpg := TJpegImage.Create;
            LPic := TPicture.Create;
            LJpg.LoadFromStream(LTS);
            LPic.Assign(LJpg);
          end;

          if (LEXT = 'BMP') then
          begin
            LBMP := TBitmap.Create;
            LPic := TPicture.Create;
            LBMP.LoadFromStream(LTS);
            LPic.Assign(LBMP);
          end;

          if Not(LPic.Graphic = nil) then
//            DescGrid.AddPicture(8,FStartRow,LPic,false,nostretch,0,haleft,vatop);
            DescGrid.CreatePicture(8,FStartRow,True,Stretch,0,haleft,vatop).Assign(LPic);


        finally
          LTS.Free;
          LJpg.Free;
          LPic.Free;
          LBMP.Free;
        end;
      end;
    end;
  end
  else
    Exit;
end;

procedure TRP_Agg.Trouble_Desc_Table_Header_Setting;
var
  li,lc : integer;
begin
  with DescGrid do
  begin
    Clear;
    RowCount := 3;
    MultiLineCells := True;

    MergeCells(0,0,1,2);
    MergeCells(1,0,1,2);
    MergeCells(2,0,1,2);
    MergeCells(3,0,1,2);
    MergeCells(4,0,1,2);

    MergeCells(5,0,2,1);

    MergeCells(7,0,1,2);
    MergeCells(8,0,1,2);


    Cells[0,0] := #13#10+'No';
    Cells[1,0] := #13#10+'품명';

    DescGrid.FontSizes[2,0] := 7;
    Cells[2,0] := #13#10+'1)현상 /2)추정원인 /3) 대책방안 /4)발생원인';
    Cells[3,0] := #13#10+'조치내용';
    Cells[4,0] := #13#10+'조치상태';

    Cells[5,0] := '일자';
    Cells[5,1] := '발견';
    Cells[6,1] := '조치';
    Cells[7,0] := #13#10+'설계'+#13#10+'반영';
    Cells[8,0] := #13#10+'사진';

  end;
end;

procedure TRP_Agg.RP_TypeClick(Sender: TObject);
begin
  SMainTable_Initialize;
end;

procedure TRP_Agg.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TRP_Agg.EngTypeButtonDown(Sender: TObject);
var
  li : integer;
  LStr : String;
begin
  EngType.Items.Clear;

  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Distinct ProjNo, EngType from Trouble_Data order by ProjNo');
    Open;

    while not eof do
    begin
      EngType.Items.Add(FieldByName('ProjNo').AsString+'-'+FieldByName('EngType').AsString );
      Next;
    end;//while
  end;//with
end;

procedure TRP_Agg.Align_of_ReportType;
var
  lc, li, lr : integer;
  LsRow : integer;
  LCount : integer;
  LRCount : integer;
begin
  LCount := 0;
  LsRow := 2;
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_Data');
    SQL.Add('where ProjNo = :param1 order by Sdate');

    ParamByName('Param1').AsString := LeftStr(EngType.Text,6);
    Open;
    Trouble_Desc_Cell_Setting(RecordCount);
  end;

  for lc := 0 to Rp_Type.Items.Count-1 do
  begin
    if Rp_Type.Checked[lc] = True then
    begin
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from Trouble_Data');
        SQL.Add('where RPType = :param1 And ProjNo = :param2 order by Sdate');
        ParamByName('param1').AsString := IntToStr(LC);
        ParamByName('Param2').AsString := LeftStr(EngType.Text,6);
        Open;

        if not(RecordCount = 0) then
        begin
          LRCount := RecordCount;
          for li := 0 to RecordCount-1 do
          begin
            with SMainTable do
            begin
              lr := SMainTable.RowCount-1;

              Cells[0,lr] := intToStr(SMainTable.RowCount-3); // 순서

              AddCheckBox(1,lr,True,false); // Check Box 넣기~

              Cells[2,lr]  := FieldByName('SDate').AsString;

              if FieldByName('TRType1').AsString = 'T' then
                Cells[3,lr]  := '1';
              if FieldByName('TRType2').AsString = 'T' then
                Cells[4,lr]  := '1';
              if FieldByName('TRType3').AsString = 'T' then
                Cells[5,lr]  := '1';
              if FieldByName('TRType4').AsString = 'T' then
                Cells[5,lr]  := '1';

              Cells[7,lr]  := FieldByName('ItemName').AsString;
              Cells[8,lr]  := FieldByName('ResultTitle').AsString;
              Cells[9,lr]  := FieldByName('EDate').AsString;
              if FieldByName('DesignAPP').AsString = 'T' then
                Cells[10,lr] := '○'
              else
                Cells[10,lr] := 'X';

              case lc of
                0 : Cells[11,lr] := '품질';
                1 : Cells[11,lr] := '설비';
                2 : Cells[11,lr] := '조립';
                3 : Cells[11,lr] := '시운전';
                4 : Cells[11,lr] := '예상';
              end;
              Cells[12,lr] := FieldByName('CODEID').AsString;
              SMainTable.AddRow;
              Inc(LCount);
              Trouble_Desc_Data_Mapping(FieldByName('CODEID').AsString,LsRow,LCount);
              LsRow := LsRow+4;
            end;//with
            Next;
          end;//for
        end;
      end;//with ZQ1
    end;//if
  end;//for
  SMainTable.RemoveRows(SMainTable.RowCount,1);
  Summary_For_Report(SMainTable.RowCount-3);
end;

procedure TRP_Agg.case_of_Search_Report(FCase: integer);
var
  LSQL : String;
  li : integer;
begin
  case FCase of
    1 : LSQL := 'select Distinct A.InEMPNO, B.Name_Kor from Trouble_Data A, User_Info B where A.InempNo = B.UserID order by Name_kor';
    2 : LSQL := 'select Distinct ProjNo, EngType from Trouble_Data order by ProjNo';
    3 : begin
          for li := 0 to 4 do
          begin
            case li of
              0 : SearchED2.Items.Add('시험기획과');
              1 : SearchED2.Items.Add('성능기술과');
              2 : SearchED2.Items.Add('FIE기술과');
              3 : SearchED2.Items.Add('제어기술과');
              4 : SearchED2.Items.Add('시험기술과');
            end;
          end;//case          for li := 0 to 4 do
        end;
  end;

  if not(LSQL = '') then
  begin
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(LSQL);
      Open;

      SearchED2.Items.Clear;

      while not eof do
      begin
        case FCase of
          1 : SearchED2.Items.Add(fieldbyname('InEmpno').AsString+'-'+fieldbyname('Name_Kor').AsString);
          2 : SearchED2.Items.Add(fieldbyname('ProjNo').AsString+'-'+fieldbyname('Engtype').AsString);
        end;
        Next;
      end;
    end;
  end;
end;

procedure TRP_Agg.NxButton4Click(Sender: TObject);
var
  li : integer;
begin
  for li := 0 to RP_Type.Items.Count-1 do
    Rp_Type.Checked[li] := True;

end;

procedure TRP_Agg.NxButton5Click(Sender: TObject);
var
  li : integer;
begin
  for li := 0 to RP_Type.Items.Count-1 do
    Rp_Type.Checked[li] := False;

end;
procedure TRP_Agg.Align_of_Indate;
var
  lc, li, lr : integer;
  LType : Integer;
  LsRow : integer;//Start Row
  LCount : integer;
  LRCount : integer;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Trouble_Data');
    SQL.Add('where ProjNo = :param1 order by Sdate');

    ParamByName('Param1').AsString := LeftStr(EngType.Text,6);
    Open;

    LsRow := 2;
    if not(RecordCount = 0) then
    begin
      Trouble_Desc_Cell_Setting(RecordCount);
      LCount := 0;
      LRCount := RecordCount;
      for li := 0 to RecordCount-1 do
      begin
        LType := StrToInt(FieldBYName('RPType').AsString);

        if Rp_Type.Checked[LType] then
        begin
          with SMainTable do
          begin
            lr := SMainTable.RowCount-1;

            Cells[0,lr] := intToStr(SMainTable.RowCount-3); // 순서
            AddCheckBox(1,lr,True,false); // Check Box 넣기~
            Cells[2,lr]  := FormatDateTime('yyyy-mm-dd', FieldByName('SDate').AsDateTime);

            if FieldByName('TRType1').AsString = 'T' then
              Cells[3,lr]  := '1';
            if FieldByName('TRType2').AsString = 'T' then
              Cells[4,lr]  := '1';
            if FieldByName('TRType3').AsString = 'T' then
              Cells[5,lr]  := '1';
            if FieldByName('TRType4').AsString = 'T' then
              Cells[5,lr]  := '1';

            Cells[7,lr]  := FieldByName('ItemName').AsString;
            Cells[8,lr]  := FieldByName('ResultTitle').AsString;
            Cells[9,lr]  := FieldByName('EDate').AsString;
            if FieldByName('DesignAPP').AsString = 'T' then
              Cells[10,lr] := '○'
            else
              Cells[10,lr] := 'X';

            case LType of
              0 : Cells[11,lr] := '품질';
              1 : Cells[11,lr] := '설비';
              2 : Cells[11,lr] := '조립';
              3 : Cells[11,lr] := '시운전';
              4 : Cells[11,lr] := '예상';
            end;
            Cells[12,lr] := FieldByName('CODEID').AsString;
            SMainTable.AddRow;
            Inc(LCount);
            Trouble_Desc_Data_Mapping(FieldByName('CODEID').AsString,LsRow,LCount);
            LsRow := LsRow+4;
          end;//with
        end;//if
        Next;
      end;//for
    end;
  SMainTable.RemoveRows(SMainTable.RowCount,1);
  Summary_For_Report(LRCount);
  end;//with
end;


procedure TRP_Agg.NxButton3Click(Sender: TObject);
var
  li : integer;
  Lapp : Boolean;
  LStr : String;
begin
  Lapp := False;

  for li := 0 to Rp_Type.Items.Count-1 do
    if Rp_Type.Checked[li] then
      Lapp := True;

  if Lapp = false then
  begin
    ShowMessage('보고서 종류를 선택하여 주십시오.');
    Exit;
  end;

  NxPageControl2.ActivePageIndex := 0;
  SMainTable_Initialize;
  if not(AlignRp.ItemIndex = -1)then
  begin
    Try
      DM1.Splash1.BeginUpdate;
      LStr := 'CODEID : TBACS 데이터베이스에서 조회된 문서를 호출 중입니다.';
      DM1.Splash1.TopLayerItems.Items[0].HTMLText.Text := LStr;
      DM1.Splash1.EndUpdate;
      DM1.Splash1.Show;

      Case AlignRP.ItemIndex of
        0 : Align_of_ReportType;
        1 : Align_of_Indate;
      end;
    Finally
      DM1.Splash1.Hide;
    End;
  end
  else
  begin
    ShowMessage('보고서 정렬 방식을 선택하여 주십시오.');
    Exit;
  end;
  DM1.Splash1.Hide;
end;

end.

