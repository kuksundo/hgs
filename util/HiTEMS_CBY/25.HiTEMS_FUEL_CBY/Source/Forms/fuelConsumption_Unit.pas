unit fuelConsumption_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel, Vcl.ImgList,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, DateUtils, StrUtils, Ora, TaskDialog, AdvFindDialogForm,
  ComObj, OleCtrls, AdvMetroFindDialog, DBAccess, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart;

type
  TfuelConsumption_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    JvLabel22: TJvLabel;
    Label19: TLabel;
    Label20: TLabel;
    btn_Close: TAeroButton;
    dt_from: TDateTimePicker;
    dt_to: TDateTimePicker;
    btn_report: TAeroButton;
    btn_search: TAeroButton;
    Label1: TLabel;
    cb_EngType: TComboBox;
    JvLabel8: TJvLabel;
    grid_Fuel: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxNumberColumn;
    NxTextColumn8: TNxNumberColumn;
    NxListColumn1: TNxListColumn;
    NxTextColumn9: TNxNumberColumn;
    chk_low: TCheckBox;
    panel1: TPanel;
    NxTextColumn2: TNxNumberColumn;
    NxTextColumn4: TNxNumberColumn;
    JvLabel1: TJvLabel;
    Chart1: TChart;
    Series1: TBarSeries;
    Series2: TBarSeries;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button1: TButton;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cb_EngTypeDropDown(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btn_searchClick(Sender: TObject);
    procedure btn_reportClick(Sender: TObject);
    procedure grid_FuelAfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FPriceQuery : TOraQuery;
  public
    { Public declarations }
    procedure Get_FuelSubCode;
    procedure MessageReceiver(var msg : TWMCopyData); message WM_USER+7979;

    procedure Get_Fuel_Consumption;
    procedure Get_Fuel_Consumption_time;
    procedure Set_Chart_of_Annual_Consumption;

    function Calc_Elec_Base_Price : Double;
    function Calc_Elec_PF_Price : Double;
    function Calc_Elec_Used_Kw_Price : Double;
    function Get_Price_per_hour(AKW:Double;AMonth, ATime: string) : Double;
    procedure Get_Price_Table;

  end;

var
  fuelConsumption_Frm: TfuelConsumption_Frm;

implementation
uses
  progressDialog_Unit,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure TfuelConsumption_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfuelConsumption_Frm.btn_reportClick(Sender: TObject);
begin
  //   참조항목
  //    XL.workbooks.Add('C:\test.xls');    //특정 이름의 화일 열기
  //    XL.workbooks.Open('C:\'+sFileName); //특정 이름의 화일 열기
  //    XL.ActiveWorkbook.saveas('C:\123.xls'); //활성화된 엑셀 다른 이름으로 저장
  //    XL.ActiveCell.FormulaR1C1 := '=3*3';    //값입력
  //    XL.ActiveCell.Font.Bold := True      //글자 환경 변경
  //    XL.ActiveCell.CurrentRegion.Select;   //활성화 된 셀의 영역을 선택
  //    XL.selection.style:='Currency';       //선택영역 통화 형태로
  TThread.Queue(nil,
  procedure
  const
    ldec = 65;//Ascii Code Dec = A
  var
    XL, oWB, oSheet, oRng : variant;
    xlRowCount, xlColCount,
    i,j,s : Integer;
    lColumn, range : string;
  begin
    if btn_report.Caption <> '엑셀출력' then
      Exit;

    btn_report.Caption := '처리중';

    XL := CreateOleObject('Excel.Application');
    XL.DisplayAlerts := False;
    XL.visible := False;
    try
      oWB := XL.WorkBooks.Add;
      oSheet := oWB.ActiveSheet;

      with grid_Fuel do
      begin
        BeginUpdate;
        try
          s := -1;
          for i := 0 to Columns.Count-1 do
          begin
            if Columns[i].Visible then
            begin
              Inc(s);
              lColumn := Chr(ldec+s);
              range := lColumn + '1';

              XL.Range[range].Select;
              XL.ActiveCell.FormulaR1C1 := Columns.Item[i].Header.Caption;

              for j := 0 to RowCount-1 do
              begin
                range := lColumn + IntToStr(j+2);
                XL.Range[range].Select;

                if Columns[i] is TNxListColumn then
                  XL.ActiveCell.FormulaR1C1 := NxListColumn1.Items.Strings[Cell[i,j].AsInteger]
                else
                  XL.ActiveCell.FormulaR1C1 := Cells[i,j];//''''+Cells[i,j];
              end;
            end;
          end;

          xlRowCount := oSheet.UsedRange.Rows.Count;
          xlColCount := oSheet.UsedRange.Columns.Count;
          //Header Range 설정
          range := Chr(ldec)+'1:';
          range := range + chr(ldec+xlColCount-1)+'1';
          oRng := oSheet.Range[range];
          //Font bold
          oRng.font.bold := true;
          //Header AutoFit
          oRng.EntireColumn.AutoFit;
          //Header fill Color
          oRng.Interior.ColorIndex := 36;

          //전체 Range 설정
          range := Chr(ldec)+'1:';
          range := range + chr(ldec+xlColCount-1)+IntToStr(xlRowCount);
          oRng := oSheet.Range[range];

          oRng.Borders.LineStyle := 1;
        finally
          XL.Visible := True;
          EndUpdate;
          btn_report.Caption := '엑셀출력';
        end;
      end;
    except
      MessageDlg('Excel이 설치되어 있지 않습니다.'+#13+
        '이 기능을 이용하시려면 반드시 MS오피스 엑셀이 설치되어 있어야 합니다.- ' ,
        MtWarning, [mbok], 0);
      XL.quit;
      XL := Unassigned;
    end;
  end);
end;

procedure TfuelConsumption_Frm.btn_searchClick(Sender: TObject);
var
  i : Integer;
begin
  if RadioButton1.Checked then
    Get_Fuel_Consumption
  else
    Get_Fuel_Consumption_time;

end;

procedure TfuelConsumption_Frm.Button1Click(Sender: TObject);
begin
  Button1.Enabled := False;
  try
    Calc_Elec_Used_Kw_Price;  
  finally
    Button1.Enabled := True;

  end;

end;

function TfuelConsumption_Frm.Calc_Elec_Base_Price: Double;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ELEC_BASE_PRICE_TABLE ' +
              'WHERE ROWNUM = (SELECT MAX(ROWNUM) FROM ELEC_BASE_PRICE_TABLE) ');
      Open;

      if RecordCount <> 0 then
      begin
        Result := FieldByName('CONTACT_KW').AsFloat * FieldByName('PRICE').AsFloat;

      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TfuelConsumption_Frm.Calc_Elec_PF_Price: Double;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ELEC_BASE_PRICE_TABLE ' +
              'WHERE ROWNUM = (SELECT MAX(ROWNUM) FROM ELEC_BASE_PRICE_TABLE) ');
      Open;

      if RecordCount <> 0 then
      begin
        Result := (0.9+0.95)*FieldByName('PRICE').AsFloat;

      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TfuelConsumption_Frm.Calc_Elec_Used_Kw_Price: Double;
var
  OraQuery : TOraQuery;
  LMonth,
  LTime : String;

  str,
  XL, oWB, oSheet, oRng : variant;
  xlRowCount, xlColCount,
  i,j,s : Integer;
  lColumn, range : string;

begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT  ' +
              '   DATASAVEDTIME, AVG(KW) KW ' +
              'FROM ' +
              '( ' +
              '   SELECT ' +
              '     DISTINCT(SUBSTR(DATASAVEDTIME,1,10)) DATASAVEDTIME, ' +
              '     DATA199 KW ' +
              '   FROM TBACS.YE0539_6H1728U_MEASURE_DATA ' +
              '   WHERE ROWID IN ' +
              '   ( ' +
              '     SELECT MAX(ROWID) FROM ' +
              '     ( ' +
              '       SELECT ' +
              '         ROWID, ' +
              '         SUBSTR(DATASAVEDTIME,1,14) DATASAVEDTIME ' +
              '       FROM TBACS.YE0539_6H1728U_MEASURE_DATA ' +
              '       WHERE DATASAVEDTIME LIKE :YEARMONTH  ' +
              '     ) GROUP BY DATASAVEDTIME ' +
              '   ) AND DATA199 > 5 ' +
              ') ' +
              'GROUP BY DATASAVEDTIME ' +
              'ORDER BY DATASAVEDTIME ');
      ParamByName('YEARMONTH').AsString := '201402%';
      Open;

      if RecordCount <> 0 then
      begin
        XL := CreateOleObject('Excel.Application');
        XL.DisplayAlerts := False;
        XL.visible := True;
        try
          oWB := XL.WorkBooks.Add;
          oSheet := oWB.ActiveSheet;

          XL.Range['A1'].Select;
          XL.ActiveCell.FormulaR1C1 := '년월일시';

          XL.Range['B1'].Select;
          XL.ActiveCell.FormulaR1C1 := 'KWH';

          XL.Range['C1'].Select;
          XL.ActiveCell.FormulaR1C1 := '금액';

          i := 2;
          while not eof do
          begin
            range := 'A'+IntToStr(i);
            XL.Range[range].Select;
            str := Copy(FieldByName('DATASAVEDTIME').AsString,1,4)+'-'+
                   Copy(FieldByName('DATASAVEDTIME').AsString,5,2)+'-'+
                   Copy(FieldByName('DATASAVEDTIME').AsString,7,2)+' '+
                   Copy(FieldByName('DATASAVEDTIME').AsString,9,2)+'시';

            XL.ActiveCell.FormulaR1C1 := str;

            range := 'B'+IntToStr(i);            
            XL.Range[range].Select;
            XL.ActiveCell.FormulaR1C1 := FieldByName('KW').AsString;

            range := 'C'+IntToStr(i);            
            XL.Range[range].Select;
            XL.ActiveCell.FormulaR1C1 := Get_Price_Per_Hour(FieldByName('KW').AsFloat,
                                                            Copy(FieldByName('DATASAVEDTIME').AsString,5,2),
                                                            Copy(FieldByName('DATASAVEDTIME').AsString,9,2));

            Inc(i);
            Next;
          end;
        except
          MessageDlg('Excel이 설치되어 있지 않습니다.'+#13+
            '이 기능을 이용하시려면 반드시 MS오피스 엑셀이 설치되어 있어야 합니다.- ' ,
            MtWarning, [mbok], 0);
          XL.quit;
          XL := Unassigned;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TfuelConsumption_Frm.cb_EngTypeDropDown(Sender: TObject);
begin
  with cb_EngType.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('전체');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM MON_TABLES ' +
                'WHERE USE_YN = :param1 ' +
                'ORDER BY SEQ_NO ');
        ParamByName('param1').AsInteger := 0;
        Open;

        while not eof do
        begin
          Add(FieldByName('ENG_PROJNO').AsString+'-'+FieldByName('ENG_TYPE').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfuelConsumption_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FPriceQuery) then
    FPriceQuery.Free;

end;

procedure TfuelConsumption_Frm.FormCreate(Sender: TObject);
begin
  dt_from.Date := StartOfTheMonth(today);
  dt_to.Date   := EndOfTheMonth(today);
  Get_FuelSubCode;
  Set_Chart_of_Annual_Consumption;

  Get_Price_Table;
end;


procedure TfuelConsumption_Frm.Get_FuelSubCode;
begin
  with NxListColumn1.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT SUBCODE FROM FUEL_PRICE ' +
                'GROUP BY SUBCODE ' +
                'ORDER BY SUBCODE ');
        Open;

        while not eof do
        begin
          Add(FieldByName('SUBCODE').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfuelConsumption_Frm.Get_Fuel_Consumption;
var
  i : Integer;
  LRow : Integer;
  LEngine : String;

  LSumPower,
  LSumHr,
  LSumCs : Double;
begin
  with grid_Fuel do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ' +
                ' ENGINE, ' +
                ' LOAD, ' +
                ' SUM(KWH) KWH, ' +
                ' SUM(RUNTIME_H) HR, ' +
                ' STD_CONSUMPTION STD, ' +
                ' SUM(DAY_RESULT) RESULT ' +
                'FROM ' +
                '( ' +
                '   SELECT * FROM FUEL_CONSUMPTION ' +
                '   WHERE ((DAY >= :begin) and (DAY <= :end)) ' +
                '   AND ENGINE LIKE :ENGINE ' +
                ') GROUP BY ENGINE, LOAD, STD_CONSUMPTION ' +
                'ORDER BY ENGINE, LOAD ');

        ParamByName('begin').AsDate := dt_from.Date;
        ParamByName('end').AsDate   := dt_to.Date;

        if cb_EngType.ItemIndex <> 0 then
          ParamByName('ENGINE').AsString := cb_EngType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND ENGINE LIKE :ENGINE','');

        Open;

        if RecordCount <> 0 then
        begin
          LEngine := '';
          LSumPower := 0;
          LSumHR := 0;
          LSumCs := 0;
          while not eof do
          begin
//            LRow := AddRow;
            if LEngine <> FieldByName('ENGINE').AsString then
            begin
              if LEngine <> '' then
              begin
                LRow := AddRow;
                Cell[1,LRow].AsString := '합계';
                Cell[2,LRow].AsFloat := LSumPower;
                Cell[4,LRow].AsFloat := LSumHr;
                Cell[6,LRow].AsFloat := LSumCs;

                Cell[2,LRow].FontStyle := Cell[2,LRow].FontStyle + [fsBold];
                Cell[4,LRow].FontStyle := Cell[4,LRow].FontStyle + [fsBold];
                Cell[6,LRow].FontStyle := Cell[6,LRow].FontStyle + [fsBold];

                for i := 0 to Columns.Count-1 do
                  Cell[i,LRow].Color := clMoneyGreen;
              end;


              LSumPower := 0;
              LSumHR := 0;
              LSumCs := 0;

              LRow := AddRow;
              LEngine := FieldByName('ENGINE').AsString;
              Cells[1,LRow] := LEngine;
            end else
              LRow := AddRow;

            Cells[2,LRow] := FieldByName('KWH').AsString;
            Cells[3,LRow] := FieldByName('LOAD').AsString;
            Cells[4,LRow] := FieldByName('HR').AsString;
            Cells[5,LRow] := FieldByName('STD').AsString;
            Cells[6,LRow] := FieldByName('RESULT').AsString;

            LSumPower := LSumPower + FieldByName('KWH').AsFloat;
            LSumHr := LSumHr + FieldByName('HR').AsFloat;
            LSumCs := LSumCs + FieldByName('RESULT').AsFloat;

            if (RowCount mod 2) = 0 then
              for i := 0 to Columns.Count-1 do
                Cell[i,LRow].Color := $00DFDFDF;

            Next;
          end;

          if Eof then
          begin
            LRow := AddRow;
            Cell[1,LRow].AsString := '합계';
            Cell[2,LRow].AsFloat := LSumPower;
            Cell[4,LRow].AsFloat := LSumHr;
            Cell[6,LRow].AsFloat := LSumCs;

            Cell[2,LRow].FontStyle := Cell[2,LRow].FontStyle + [fsBold];
            Cell[4,LRow].FontStyle := Cell[4,LRow].FontStyle + [fsBold];
            Cell[6,LRow].FontStyle := Cell[6,LRow].FontStyle + [fsBold];

            for i := 0 to Columns.Count-1 do
              Cell[i,LRow].Color := clMoneyGreen;
          end;
        end;

        LSumPower := 0;
        LSumHR := 0;
        LSumCs := 0;
        for i := 0 to RowCount-1 do
        begin
          if Cell[2,i].Color = clMoneyGreen then
          begin
            LSumPower := LSumPower + Cell[2,i].AsFloat;
            LSumHr  := LSumHr  + Cell[4,i].AsFloat;
            LSumCs  := LSumCs  + Cell[6,i].AsFloat;
          end;
        end;

        LRow := AddRow;
        Cell[1,LRow].AsString := '총 합계';
        Cell[2,LRow].AsFloat := LSumPower;
        Cell[4,LRow].AsFloat := LSumHr;
        Cell[6,LRow].AsFloat := LSumCs;

        Cell[2,LRow].FontStyle := Cell[2,LRow].FontStyle + [fsBold];
        Cell[4,LRow].FontStyle := Cell[4,LRow].FontStyle + [fsBold];
        Cell[6,LRow].FontStyle := Cell[6,LRow].FontStyle + [fsBold];

        for i := 0 to Columns.Count-1 do
          Cell[i,LRow].Color := clSkyBlue;
      end;
    finally
//      CalculateFooter(True);
      EndUpdate;
    end;
  end;
end;

procedure TfuelConsumption_Frm.Get_Fuel_Consumption_time;
var
  i : Integer;
  LRow : Integer;
  LEngine : String;

  LSumPower,
  LSumHr,
  LSumCs : Double;
begin
  with grid_Fuel do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ' +
                '   ENGINE, DAY, HOUR, SUM(KWH) KWH, SUM(HR) HR, ' +
                '   0 STD, SUM(RESULT) RESULT ' +
                'FROM ' +
                '( ' +
                '   SELECT ' +
                '     ENGINE, DAY, HOUR, SUM(KWH) KWH, SUM(RUNTIME_H) HR, ' +
                '     0 STD, SUM(DAY_RESULT) RESULT ' +
                '   FROM ' +
                '   ( ' +
                '       SELECT * FROM FUEL_CONSUMPTION ' +
                '       WHERE ((DAY >= :begin) and (DAY <= :end)) ' +
                '       AND ENGINE LIKE :ENGINE ' +
                '   ) ' +
                '   GROUP BY ENGINE, DAY, HOUR, STD_CONSUMPTION ' +
                ') ' +
                'GROUP BY ENGINE, DAY, HOUR, STD ' +
                'ORDER BY ENGINE, DAY, HOUR ');

        ParamByName('begin').AsDate := dt_from.Date;
        ParamByName('end').AsDate   := dt_to.Date;

        if cb_EngType.ItemIndex <> 0 then
          ParamByName('ENGINE').AsString := cb_EngType.Text
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND ENGINE LIKE :ENGINE','');

        Open;

        if RecordCount <> 0 then
        begin
          LEngine := '';
          LSumPower := 0;
          LSumHR := 0;
          LSumCs := 0;
          while not eof do
          begin
//            LRow := AddRow;
            if LEngine <> FieldByName('ENGINE').AsString then
            begin
              if LEngine <> '' then
              begin
                LRow := AddRow;
                Cell[1,LRow].AsString := '합계';
                Cell[2,LRow].AsFloat := LSumPower;
                Cell[4,LRow].AsFloat := LSumHr;
                Cell[6,LRow].AsFloat := LSumCs;

                Cell[2,LRow].FontStyle := Cell[2,LRow].FontStyle + [fsBold];
                Cell[4,LRow].FontStyle := Cell[4,LRow].FontStyle + [fsBold];
                Cell[6,LRow].FontStyle := Cell[6,LRow].FontStyle + [fsBold];

                for i := 0 to Columns.Count-1 do
                  Cell[i,LRow].Color := clMoneyGreen;
              end;


              LSumPower := 0;
              LSumHR := 0;
              LSumCs := 0;

              LRow := AddRow;
              LEngine := FieldByName('ENGINE').AsString;
              Cells[1,LRow] := LEngine;
            end else
              LRow := AddRow;

            Cells[2,LRow] := FieldByName('KWH').AsString;
            Cells[3,LRow] := FormatDateTime('yyyy-MM-dd일 ',FieldByName('Day').AsDateTime)+' '+FieldByName('HOUR').AsString +' 시';
            Cells[4,LRow] := FieldByName('HR').AsString;
            Cells[5,LRow] := FieldByName('STD').AsString;
            Cells[6,LRow] := FieldByName('RESULT').AsString;

            LSumPower := LSumPower + FieldByName('KWH').AsFloat;
            LSumHr := LSumHr + FieldByName('HR').AsFloat;
            LSumCs := LSumCs + FieldByName('RESULT').AsFloat;

            if (RowCount mod 2) = 0 then
              for i := 0 to Columns.Count-1 do
                Cell[i,LRow].Color := $00DFDFDF;

            Next;
          end;

          if Eof then
          begin
            LRow := AddRow;
            Cell[1,LRow].AsString := '합계';
            Cell[2,LRow].AsFloat := LSumPower;
            Cell[4,LRow].AsFloat := LSumHr;
            Cell[6,LRow].AsFloat := LSumCs;

            Cell[2,LRow].FontStyle := Cell[2,LRow].FontStyle + [fsBold];
            Cell[4,LRow].FontStyle := Cell[4,LRow].FontStyle + [fsBold];
            Cell[6,LRow].FontStyle := Cell[6,LRow].FontStyle + [fsBold];

            for i := 0 to Columns.Count-1 do
              Cell[i,LRow].Color := clMoneyGreen;
          end;
        end;

        LSumPower := 0;
        LSumHR := 0;
        LSumCs := 0;
        for i := 0 to RowCount-1 do
        begin
          if Cell[2,i].Color = clMoneyGreen then
          begin
            LSumPower := LSumPower + Cell[2,i].AsFloat;
            LSumHr  := LSumHr  + Cell[4,i].AsFloat;
            LSumCs  := LSumCs  + Cell[6,i].AsFloat;
          end;
        end;

        LRow := AddRow;
        Cell[1,LRow].AsString := '총 합계';
        Cell[2,LRow].AsFloat := LSumPower;
        Cell[4,LRow].AsFloat := LSumHr;
        Cell[6,LRow].AsFloat := LSumCs;

        Cell[2,LRow].FontStyle := Cell[2,LRow].FontStyle + [fsBold];
        Cell[4,LRow].FontStyle := Cell[4,LRow].FontStyle + [fsBold];
        Cell[6,LRow].FontStyle := Cell[6,LRow].FontStyle + [fsBold];

        for i := 0 to Columns.Count-1 do
          Cell[i,LRow].Color := clSkyBlue;
      end;
    finally
//      CalculateFooter(True);
      EndUpdate;
    end;
  end;
end;

function TfuelConsumption_Frm.Get_Price_per_hour(AKW:Double;AMonth, ATime: string) : Double;
var
  LBTime,LETime : String;
begin
  with FPriceQuery do
  begin
    First;
    while not eof do
    begin
      if FieldByName('MONTH').AsInteger = StrToInt(AMonth) then
      begin
        LBTime := Copy(FieldByName('BEGIN_TIME').AsString,1,2);
        LETime := Copy(FieldByName('END_TIME').AsString,1,2);

        if (ATime >= LBTime) AND (ATime < LETime) then
        begin
          Result := AKW * FieldByName('PRICE').AsFloat;
          Exit;
        end;
      end;
      Next;
    end;
  end;
end;

procedure TfuelConsumption_Frm.Get_Price_Table;
begin
  if not Assigned(FPriceQuery) then
    FPriceQuery := TOraQuery.Create(nil);

  FPriceQuery.Session := DM1.OraSession1;
  with FPriceQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM ELEC_POWER_PRICE_TABLE ' +
            'WHERE REG_DATE = ( ' +
            ' SELECT MAX(REG_DATE) FROM ELEC_POWER_PRICE_TABLE)');
    Open;
  end;
end;

procedure TfuelConsumption_Frm.grid_FuelAfterEdit(Sender: TObject; ACol,
  ARow: Integer; Value: WideString);
var
  LRow,
  i : Integer;
  LCost : Double;
  fuel : string;

begin
  with grid_Fuel do
  begin
    BeginUpdate;
    try
      if (Cell[1,ARow].Color = clMoneyGreen) or (Cell[1,ARow].Color = clSkyBlue) then
        Exit;

      case ACol of
        7 :
        begin
          i := Cell[ACol,ARow].AsInteger;
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM FUEL_PRICE ' +
                    'WHERE FUELINNO LIKE (SELECT MAX(FUELINNO) FNO FROM FUEL_PRICE WHERE SUBCODE LIKE :param1)' );

            fuel := NxListColumn1.Items.Strings[i];
            ParamByName('param1').AsString   := fuel;
            Open;

            if RecordCount <> 0 then
            begin
              if chk_low.Checked then
              begin
                for i := ARow to RowCount-1 do
                begin
                  if (Cell[1,i].Color = clMoneyGreen) or (Cell[1,i].Color = clSkyBlue) then
                    Continue;


                  Cell[7,i].AsInteger := NxListColumn1.Items.IndexOf(fuel);
                  LCost := FieldByName('PRICE').AsInteger;
                  Cell[8,i].AsInteger := FieldByName('PRICE').AsInteger;

                  LCost := Cell[6,i].AsFloat;
                  LCost := Round(LCost * Cell[8,i].AsFloat);
                  Cell[9,i].AsFloat := LCost;
                end;
              end else
              begin
                LCost := FieldByName('PRICE').AsInteger;
                Cell[8,ARow].AsInteger := FieldByName('PRICE').AsInteger;

                LCost := Cell[6,ARow].AsFloat;
                LCost := Round(LCost * Cell[8,ARow].AsFloat);
                Cell[9,ARow].AsFloat := LCost;
              end;

              LCost := 0;
              for i := 0 to RowCount-1 do
              begin
                if not (Cell[0,i].Color = clMoneyGreen) and not (Cell[0,i].Color = clSkyBlue) then
                  LCost := LCost + Cell[9,i].AsFloat
                else begin
                  if Cell[0,i].Color = clMoneyGreen then
                    Cell[9,i].AsFloat := LCost;

                end;
              end;

              LCost := 0;
              for i := 0 to RowCount-1 do
              begin
                if Cell[0,i].Color = clMoneyGreen then
                  LCost := LCost + Cell[9,i].AsFloat;
              end;
              Cell[9,LastAddedRow].AsFloat := LCost;
            end;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfuelConsumption_Frm.MessageReceiver(var msg: TWMCopyData);
var
  sMsg : string;
begin
  btn_search.Caption := '조회하기';

  sMsg := PChar(Msg.CopyDataStruct.lpData);

  if Assigned(progressDialog_Frm) then
    FreeAndNil(progressDialog_Frm);

end;


procedure TfuelConsumption_Frm.RadioButton1Click(Sender: TObject);
begin
  grid_Fuel.Columns[3].Header.Caption := 'Load(%)';
end;

procedure TfuelConsumption_Frm.RadioButton2Click(Sender: TObject);
begin
  grid_Fuel.Columns[3].Header.Caption := 'Hour';


end;

procedure TfuelConsumption_Frm.Set_Chart_of_Annual_Consumption;
var
  i : Integer;
  str : String;
begin
  with Chart1 do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT YEAR, MONTH, SUM(QTY) QTY FROM ' +
              '( ' +
              '   SELECT ' +
              '     SUBSTR(TO_CHAR(INDATE,''YYYYMMDD''),1,4) YEAR, ' +
              '     SUBSTR(TO_CHAR(INDATE,''YYYYMMDD''),5,2) MONTH, ' +
              '     QTY ' +
              '   FROM FUEL_IN ' +
              '   WHERE REASON LIKE ''%내구성%'' ' +
              ') ' +
              'WHERE YEAR LIKE :param1 ' +
              'GROUP BY YEAR, MONTH ' +
              'ORDER BY MONTH ');
      ParamByName('param1').AsString := FormatDateTime('YYYY',Today);
      Open;

      with Series1 do
      begin
        BeginUpdate;
        try
          Clear;
          for i := 0 to RecordCount-1 do
          begin

            AddXY(FieldByName('MONTH').AsInteger,
                  FieldByName('QTY').AsFloat);
            XLabel[i] := FieldByName('MONTH').AsString+'월';
            Next;
          end;
        finally
          str := FloatToStr(YValues.Total / 1000);
          LegendTitle := '입고량('+NumberFormat(str)+')';
          EndUpdate;
        end;
      end;

      Close;
      SQL.Clear;
      SQL.Add('SELECT YEAR, MONTH, SUM(DAY_RESULT) DAY_RESULT FROM ' +
              '( ' +
              '   SELECT ' +
              '     SUBSTR(TO_CHAR(DAY,''YYYYMMDD''),1,4) YEAR, ' +
              '     SUBSTR(TO_CHAR(DAY,''YYYYMMDD''),5,2) MONTH, ' +
              '     DAY_RESULT ' +
              '   FROM FUEL_CONSUMPTION ' +
              ') ' +
              'WHERE YEAR LIKE :param1 ' +
              'GROUP BY YEAR, MONTH ' +
              'ORDER BY MONTH ');
      ParamByName('param1').AsString := FormatDateTime('YYYY',Today);
      Open;

      with Series2 do
      begin
        BeginUpdate;
        try
          Clear;
          for i := 0 to RecordCount-1 do
          begin
            AddXY(FieldByName('MONTH').AsInteger,
                  FieldByName('DAY_RESULT').AsFloat);
            XLabel[i] := FieldByName('MONTH').AsString+'월';
            Next;
          end;
        finally
          str := FloatToStr(YValues.Total / 1000);
          LegendTitle := '사용량('+NumberFormat(str)+')';
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TfuelConsumption_Frm.Timer1Timer(Sender: TObject);
begin
  Application.ProcessMessages;
end;

end.
