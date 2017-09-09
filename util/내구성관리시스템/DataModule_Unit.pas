unit DataModule_Unit;

interface

uses
  SysUtils, Classes, DB, MemDS, DBAccess, Ora, ImgList, Controls, Dialogs,
  Vcl.Graphics, System.Types, WinApi.Windows, DateUtils,
  JvBaseDlg, JvImageDlg, OraTransaction, OraCall, ElecPowerCalcClass,
  UnitGridView, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  NxColumnClasses, NxColumns, HoliDayCollect;

type
  TPlannerDateHelper = class(TObject)
    class procedure PlannerCalendarCellDraw(Sender: TObject; Canvas: TCanvas;
                Day: TDate; Selected, Marked, InMonth: Boolean; Rect: TRect);
    class procedure SetPlannerCalDellDraw(AComponent: TComponent);
    class procedure SetPlannerCalEvent(AComponent: TComponent);
  end;

  TDM1 = class(TDataModule)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    ImageList1: TImageList;
    OraQuery3: TOraQuery;
    OraTransaction1: TOraTransaction;
    OraSession2: TOraSession;
    OraQuery2: TOraQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure SetPriceTableGridColumn(AGrid: TNextGrid);
    procedure SetPriceTableGrid(AGrid: TNextGrid);
  public
    FElecPowerCalcBase: TElecPowerCalcBase;
    FHoliDayList : THoliDayList;

    procedure GetElecPowerPriceTable;
    procedure ShowElecPowerPriceTable;
    procedure GetHolidayFromOracleDB;
  end;

var
  DM1: TDM1;

implementation

uses pjhPlannerDatePicker;

{$R *.dfm}

procedure TDM1.DataModuleCreate(Sender: TObject);
begin
  FElecPowerCalcBase := TElecPowerCalcBase.Create(self);
  FHoliDayList := THoliDayList.Create(Self);

  GetHolidayFromOracleDB;
end;

procedure TDM1.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FHoliDayList);
  FElecPowerCalcBase.Free;
end;

procedure TDM1.GetElecPowerPriceTable;
var
  i: integer;
begin
  with OraQuery2 do
  begin
    Close;
    SQL.Clear;

    SQL.Add('SELECT * FROM ELEC_BASE_PRICE_TABLE ');
    SQL.Add('WHERE REG_DATE = (SELECT MAX(REG_DATE) FROM ELEC_BASE_PRICE_TABLE)');
    Open;

    if RecordCount > 0 then
    begin
      FElecPowerCalcBase.BaseRegDate := FieldByName('REG_DATE').AsDateTime;
      FElecPowerCalcBase.BasePrice := FieldByName('PRICE').AsFloat;
      FElecPowerCalcBase.BasekW := FieldByName('CONTACT_KW').AsInteger;
    end;

    Close;
    SQL.Clear;

    SQL.Add('SELECT * FROM ELEC_POWER_PRICE_TABLE ');
    SQL.Add('WHERE REG_DATE = (SELECT MAX(REG_DATE) FROM ELEC_POWER_PRICE_TABLE)');
    Open;

    for i := 0 to RecordCount - 1 do
    begin
      with FElecPowerCalcBase.ElecPowerCalcCollect.Add do
      begin
        RegDate := FieldByName('REG_DATE').AsDateTime;
        Season := TSeason(FieldByName('SEASON').AsInteger);
        LoadType := TLoadType(FieldByName('LOAD_TYPE').AsInteger);
        FFMonth := FieldByName('MONTH').AsInteger;
        BeginTime_S := FieldByName('BEGIN_TIME').AsString;
        EndTime_S := FieldByName('END_TIME').AsString;
        Price := FieldByName('PRICE').AsFloat;
      end;

      Next;
    end;
  end;//with
end;

procedure TDM1.GetHolidayFromOracleDB;
begin
  with OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HiTEMS_HOLIDAY ' +
            ' WHERE TO_CHAR(FROMDATE, ''YYYY'') = :param1 ORDER BY FROMDATE');
    ParamByName('param1').AsString := IntToStr(CurrentYear);
    Open;

    if RecordCount > 0 then
    begin
      while not Eof do
      begin
        with FHoliDayList.HoliDayCollect.Add do
        begin
          FromDate := FieldByName('FROMDATE').AsDateTime;
          ToDate := FieldByName('TODATE').AsDateTime;
          Description := FieldByName('Description').AsString;
        end;//with

        Next;
      end;//while
    end;
  end;//with
end;

procedure TDM1.SetPriceTableGrid(AGrid: TNextGrid);
var
  i: integer;
begin
  AGrid.ClearRows;

  for i := 0 to FElecPowerCalcBase.ElecPowerCalcCollect.Count - 1 do
  begin
    AGrid.AddRow;
    AGrid.CellByName['RegDate',i].AsString := FormatDateTime('yyyy-mm-dd',FElecPowerCalcBase.ElecPowerCalcCollect.Items[i].RegDate);
    AGrid.CellByName['Season',i].AsString := Season2String(FElecPowerCalcBase.ElecPowerCalcCollect.Items[i].Season);
    AGrid.CellByName['LoadType',i].AsString := LoadType2String(FElecPowerCalcBase.ElecPowerCalcCollect.Items[i].LoadType);
    AGrid.CellByName['Month',i].AsString := IntToStr(FElecPowerCalcBase.ElecPowerCalcCollect.Items[i].FFMonth);
    AGrid.CellByName['BeginTime',i].AsString := FElecPowerCalcBase.ElecPowerCalcCollect.Items[i].BeginTime_S;
    AGrid.CellByName['EndTime',i].AsString := FElecPowerCalcBase.ElecPowerCalcCollect.Items[i].EndTime_S;
    AGrid.CellByName['Price',i].AsString := FloatToStr(FElecPowerCalcBase.ElecPowerCalcCollect.Items[i].Price);
  end;
end;

procedure TDM1.SetPriceTableGridColumn(AGrid: TNextGrid);
var
  LnxTextColumn: TnxTextColumn;
  LNxComboBoxColumn: TNxComboBoxColumn;
begin
  with AGrid do
  begin
    ClearRows;
    Columns.Clear;

    Columns.Add(TnxIncrementColumn,'No.');

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Register Date)'));
    LnxTextColumn.Name := 'RegDate';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Season'));
    LnxTextColumn.Name := 'Season';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Load Type'));
    LnxTextColumn.Name := 'LoadType';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Month'));
    LnxTextColumn.Name := 'Month';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Begin Time'));
    LnxTextColumn.Name := 'BeginTime';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'End Time'));
    LnxTextColumn.Name := 'EndTime';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

    LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'Price'));
    LnxTextColumn.Name := 'Price';
    LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
  end;
end;

procedure TDM1.ShowElecPowerPriceTable;
var
  LGridViewF: TGridViewF;
begin
  LGridViewF := TGridViewF.Create(Self);
  try
    with LGridViewF do
    begin
      SetPriceTableGridColumn(TFrame11.NextGrid1);
      SetPriceTableGrid(TFrame11.NextGrid1);
      ShowModal;
    end;
  finally
    FreeAndNil(LGridViewF);
  end;

end;

{ TPlannerDateHelper }

class procedure TPlannerDateHelper.PlannerCalendarCellDraw(Sender: TObject;
  Canvas: TCanvas; Day: TDate; Selected, Marked, InMonth: Boolean; Rect: TRect);
var
  da,mo,ye: word;
  s: string;
begin
  DecodeDate(day, ye, mo, da);
  s := inttostr(da);

  if DM1.FHoliDayList.IsHoliday(Day) then
  begin
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Color := clRed;
  end;

  inflateRect(rect,-1,-1);
  DrawText(Canvas.Handle, pchar(s), length(s), rect, DT_CENTER or DT_VCENTER);
end;

class procedure TPlannerDateHelper.SetPlannerCalDellDraw(AComponent: TComponent);
var
  i: integer;
begin
  for i := 0 to AComponent.ComponentCount - 1 do
  begin
    if AComponent.Components[i] is TpjhPlannerDatePicker then
    begin
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.OnCellDraw := PlannerCalendarCellDraw;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Browsers.PrevYear := False;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Browsers.NextYear := False;
    end;
  end;
end;

class procedure TPlannerDateHelper.SetPlannerCalEvent(AComponent: TComponent);
var
  i,j,k: integer;
  LFromDate, LToDate: TDate;
begin
  for i := 0 to AComponent.ComponentCount - 1 do
  begin
    if AComponent.Components[i] is TpjhPlannerDatePicker then
    begin
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.EventDayColor := clRed;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.EventHints := True;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.ShowHint := True;

      for j := 0 to DM1.FHoliDayList.HoliDayCollect.Count - 1 do
      begin
        LFromDate := DM1.FHoliDayList.HoliDayCollect.Items[j].FromDate;
        LToDate := DM1.FHoliDayList.HoliDayCollect.Items[j].ToDate;

        while LFromDate <= LToDate do
        begin
          k := DayOfWeek(LFromDate);

          if (k <> 1) and (k <> 7) then//일요일,토요일이 아닌 경우
          begin
            with TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Events.Add do
            begin
              date := LFromDate;
              hint := DM1.FHoliDayList.HoliDayCollect.Items[j].Description;
  //            shape := evsCircle;
              color := clRed;
            end;
          end;

          LFromDate := IncDay(LFromDate);
        end;

      end;

      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Browsers.PrevYear := False;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Browsers.NextYear := False;
    end;
  end;
end;

end.
