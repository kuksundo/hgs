unit UnitkwhReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DateUtils,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, NxCollection, AdvGroupBox, AdvOfficeButtons, AeroButtons,
  Vcl.ImgList, Vcl.StdCtrls, AdvEdit, AdvEdBtn, PlannerDatePicker,
  pjhPlannerDatePicker, JvExControls, JvLabel, CurvyControls, Vcl.ComCtrls,
  UnitMongoDBManager, SynCommons, UnitkWReportDM, Vcl.Mask, AdvDropDown,
  AdvTimePickerDropDown, NxEdit;

type
  Tkwh_reportF = class(TForm)
    NextGrid1: TNextGrid;
    StatusBar1: TStatusBar;
    CurvyPanel1: TCurvyPanel;
    JvLabel2: TJvLabel;
    CurvyPanel2: TCurvyPanel;
    rg_period: TAdvOfficeRadioGroup;
    AeroButton2: TAeroButton;
    AeroButton3: TAeroButton;
    btn_Request: TAeroButton;
    ImageList32x32: TImageList;
    dt_begin: TpjhPlannerDatePicker;
    Label4: TLabel;
    dt_end: TpjhPlannerDatePicker;
    ImageList1: TImageList;
    tm_begin: TNxTimePicker;
    tm_end: TNxTimePicker;
    AeroButton1: TAeroButton;
    ImageList2: TImageList;
    procedure AeroButton2Click(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_RequestClick(Sender: TObject);
    procedure dt_beginDaySelect(Sender: TObject; SelDate: TDateTime);
    procedure dt_endDaySelect(Sender: TObject; SelDate: TDateTime);
  private
    FMongoDBManager: TMongoDBManager;

    function GetFromTime: TDateTime;
    function GetToTime: TDateTime;
  public
    procedure CalcDailykwh(AMongoCollectName: string; var ADocs: TVariantDynArray; AFromTm, AToTm: TDateTime);
    procedure ShowGridView(ADocs: TVariantDynArray);
    function GetUsedPowerPrice(AColumn: integer; ADefaultPrice: double = 125.7): integer;
  end;

var
  kwh_reportF: Tkwh_reportF;

implementation

{$R *.dfm}

procedure Tkwh_reportF.AeroButton2Click(Sender: TObject);
begin
  Close;
end;

procedure Tkwh_reportF.btn_RequestClick(Sender: TObject);
var
  LFrom, LTo: TDateTime;
  LDocs: TVariantDynArray;
begin
  LFrom := GetFromTime;
  LTo := GetToTime;

  CalcDailykwh('PMS_OPC_ANALOG', LDocs, LFrom, LTo);
end;

procedure Tkwh_reportF.CalcDailykwh(AMongoCollectName: string;
  var ADocs: TVariantDynArray; AFromTm, AToTm: TDateTime);
var
  LQry: string;
begin
  if FMongoDBManager.ConnectDB then
  begin
    FMongoDBManager.FMongoCollectionName := AMongoCollectName;
    //V9: VCB_G2_kW, V266: AVB_G4_kW, V609: VCB_G5_kW, V861: ACB_G6_kW
    //18H25V, 6H17U, 20H17V, 12H17V
    LQry := '{$project:{"SavedTime":1,"V9":1,"V266":1,"V609":1,"V861":1,"_id":0}},{$match:{SavedTime:{$gt:?, $lt:?}}}';

    FMongoDBManager.AggreateDocFromQry(ADocs, LQry, [DateTimeToIso8601(AFromTm, True), DateTimeToIso8601(AToTm, True)]);
    ShowGridView(ADocs);
  end;
end;

procedure Tkwh_reportF.dt_beginDaySelect(Sender: TObject; SelDate: TDateTime);
begin
  dt_begin.Text := FormatDateTime('yyyy-mm-dd',dt_begin.Date);
end;

procedure Tkwh_reportF.dt_endDaySelect(Sender: TObject; SelDate: TDateTime);
begin
  dt_end.Text := FormatDateTime('yyyy-mm-dd',dt_end.Date);
end;

procedure Tkwh_reportF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMongoDBManager.Free;
end;

procedure Tkwh_reportF.FormCreate(Sender: TObject);
begin
  FMongoDBManager := TMongoDBManager.Create('10.14.21.117', 'PMS_DB', 'PMS_COLL', 27017);
  DM4.FPDHelper.SetPlannerCalEvent(Self);
  dt_begin.Date := StartOfTheWeek(today);
  dt_end.Date := EndOfTheWeek(today);
  dt_beginDaySelect(dt_begin, dt_begin.Date);
  dt_endDaySelect(dt_end, dt_end.Date);

  tm_begin.Time := StrToTime('00:00:00');
  tm_end.Time := StrToTime('23:59:59');
end;

function Tkwh_reportF.GetFromTime: TDateTime;
var
  LYear, LMonth, LDay: word;
  LHour, LMin, LSec, LMSec: word;
begin
  DecodeDate(dt_begin.Date, LYear, LMonth, LDay);
  DecodeTime(tm_begin.Time, LHour, LMin, LSec, LMSec);
  Result := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
  Result := TTimeZone.Local.ToUniversalTime(Result);
end;

function Tkwh_reportF.GetToTime: TDateTime;
var
  LYear, LMonth, LDay: word;
  LHour, LMin, LSec, LMSec: word;
begin
  DecodeDate(dt_end.Date, LYear, LMonth, LDay);
  DecodeTime(tm_end.Time, LHour, LMin, LSec, LMSec);
  Result := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
  Result := TTimeZone.Local.ToUniversalTime(Result);
end;

//ADefaultPrice = 0 이면 계절별 금액으로 계산함.
function Tkwh_reportF.GetUsedPowerPrice(AColumn: integer;
  ADefaultPrice: double): integer;
var
  LBasePrice: double;
  LUsedKw: integer;
  LDateTime: TDateTime;
  i: integer;
  LYear, LMonth, LDay: word;
  LHour, LMin, LSec, LMSec: word;
  LSumPrice: longint;
begin
  Result := 0;
  LSumPrice := 0;
  LBasePrice := ADefaultPrice;

  if LBasePrice = 0.0 then
  begin
    for i := 0 to NextGrid1.RowCount - 3 do
    begin
      LUsedKw := StrToIntDef(NextGrid1.Cells[AColumn, i],0);
      LDateTime := NextGrid1.CellByName['RegDate',i].AsDateTime;
      DecodeDate(LDateTime, LYear, LMonth, LDay);
      LHour := NextGrid1.CellByName['Hour',i].AsInteger;
      LMin := 0;
      LSec := 0;
      LMSec := 0;
      LDateTime := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
      LSumPrice := LSumPrice + DM4.FElecPowerCalcBase.GetPrice4UsedkWhAtTime(LDateTime, LUsedKw);
    end;

    Result := LSumPrice;
  end
  else
    Result := Round(StrToIntDef(NextGrid1.Cells[AColumn,NextGrid1.RowCount - 2],0) * ADefaultPrice);
end;

procedure Tkwh_reportF.rg_periodClick(Sender: TObject);
begin
  dt_begin.Enabled := False;
  dt_end.Enabled   := False;

  case rg_period.ItemIndex of
    0 :
    begin
      dt_begin.Date := Now;
      dt_end.Date   := Now;
    end;
    1 :
    begin
      dt_begin.Date := StartOfTheWeek(Now);
      dt_end.Date   := EndOfTheWeek(Now);
    end;
    2 :
    begin
      dt_begin.Date := StartOfTheMonth(Now);
      dt_end.Date   := EndOfTheMonth(Now);
    end;
    3 :
    begin
      dt_begin.Enabled := True;
      dt_end.Enabled   := True;
    end;
  end;

  dt_beginDaySelect(dt_begin, dt_begin.Date);
  dt_endDaySelect(dt_end, dt_end.Date);

end;

procedure Tkwh_reportF.ShowGridView(ADocs: TVariantDynArray);
var
  LnxTextColumn: TnxTextColumn;
  LNxComboBoxColumn: TNxComboBoxColumn;
  i, j: integer;
  LDateTime, LTmpDateTime: TDateTime;
  LYear, LMonth, LDay: word;
  LHour, LMin, LSec, LMSec: word;
  LTmpHour: word;
  LSum_18H25V,
  LSum_6H17U,
  LSum_20H17V,
  LSum_12H17V: integer;
  LTotal_18H25V,
  LTotal_6H17U,
  LTotal_20H17V,
  LTotal_12H17V: integer;
  LCnt: integer;
  LAvg: double;
  LStr: string;
  LIsFirst: boolean;

  procedure SetData2Grid(AGrid: TNextGrid);
  begin
    with AGrid do
    begin
      j := AddRow;
      CellByName['RegDate',j].AsDateTime := LTmpDateTime;//FormatDateTime('yyyy-mm-dd',LTmpDateTime);
      CellByName['Hour',j].AsString := IntToStr(LTmpHour);

      LAvg := LSum_18H25V/LCnt;
      CellByName['Value_18H25V',j].AsString := IntToStr(Round(LAvg));
      LTotal_18H25V := LTotal_18H25V + Round(LAvg);

      LAvg := LSum_6H17U/LCnt;
      CellByName['Value_6H17U',j].AsString := IntToStr(Round(LAvg));
      LTotal_6H17U := LTotal_6H17U + Round(LAvg);

      LAvg := LSum_20H17V/LCnt;
      CellByName['Value_20H17V',j].AsString := IntToStr(Round(LAvg));
      LTotal_20H17V := LTotal_20H17V + Round(LAvg);

      LAvg := LSum_12H17V/LCnt;
      CellByName['Value_12H17V',j].AsString := IntToStr(Round(LAvg));
      LTotal_12H17V := LTotal_12H17V + Round(LAvg);

      LSum_18H25V := 0;
      LSum_6H17U := 0;
      LSum_20H17V := 0;
      LSum_12H17V := 0;
      LCnt := 0;
      LTmpHour := LHour;
      LTmpDateTime := LDateTime;
    end;
  end;

begin
  with NextGrid1 do
  begin
    ClearRows;
    Columns.Clear;

    Columns.Add(TnxIncrementColumn,'No.');

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Date'));
    LnxTextColumn.Name := 'RegDate';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Hour'));
    LnxTextColumn.Name := 'Hour';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'18H25V'));
    LnxTextColumn.Name := 'Value_18H25V';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'6H17U'));
    LnxTextColumn.Name := 'Value_6H17U';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'20H17V'));
    LnxTextColumn.Name := 'Value_20H17V';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'12H17V'));
    LnxTextColumn.Name := 'Value_12H17V';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    ClearRows;

    BeginUpdate;

    try
      LSum_18H25V := 0;
      LSum_6H17U := 0;
      LSum_20H17V := 0;
      LSum_12H17V := 0;
      LIsFirst := True;

      for i := 0 to High(ADocs) do
      begin
        LDateTime := TTimeZone.Local.ToLocalTime(Iso8601ToDateTime(ADocs[i].SavedTime));
        DecodeDateTime(LDateTime, LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);

        if LIsFirst then
        begin
          LTmpDateTime := LDateTime;
          LTmpHour := LHour;
          LIsFirst := False;
        end;

        if LTmpHour <> LHour then
        begin
          SetData2Grid(NextGrid1);
        end;

        LStr := ADocs[i].V9;
        LSum_18H25V := LSum_18H25V + StrToIntDef(LStr,0);
        LStr := ADocs[i].V266;
        LSum_6H17U := LSum_6H17U + StrToIntDef(LStr,0);
        LStr := ADocs[i].V609;
        LSum_20H17V := LSum_20H17V + StrToIntDef(LStr,0);
        LStr := ADocs[i].V861;
        LSum_12H17V := LSum_12H17V + StrToIntDef(LStr,0);
        inc(LCnt);
      end;

      SetData2Grid(NextGrid1);

      j := AddRow;
      CellByName['RegDate',j].AsString := '총 kWh';
      CellByName['Value_18H25V',j].AsString := IntToStr(LTotal_18H25V);
      CellByName['Value_6H17U',j].AsString := IntToStr(LTotal_6H17U);
      CellByName['Value_20H17V',j].AsString := IntToStr(LTotal_20H17V);
      CellByName['Value_12H17V',j].AsString := IntToStr(LTotal_12H17V);
      j := AddRow;
      CellByName['RegDate',j].AsString := '금액';
      CellByName['Value_18H25V',j].AsInteger := GetUsedPowerPrice(CellByName['Value_18H25V',j].ColumnIndex,0.0);
      CellByName['Value_6H17U',j].AsInteger := GetUsedPowerPrice(CellByName['Value_6H17U',j].ColumnIndex,0.0);
      CellByName['Value_20H17V',j].AsInteger := GetUsedPowerPrice(CellByName['Value_20H17V',j].ColumnIndex,0.0);
      CellByName['Value_12H17V',j].AsInteger := GetUsedPowerPrice(CellByName['Value_12H17V',j].ColumnIndex,0.0);
    finally
      EndUpdate;
    end;
  end;//with

//  ShowModal;
end;

end.
