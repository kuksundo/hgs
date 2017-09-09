unit UnitkWReportDM;

interface

uses
  System.SysUtils, System.Classes, Ora,
  ElecPowerCalcClass, HoliDayCollect, UnitPlannerDateHelper, Data.DB, MemDS,
  DBAccess, OraCall, OraTransaction, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  NxColumnClasses, NxColumns, UnitGridView;

type
  TDataModule4 = class(TDataModule)
    OraQuery1: TOraQuery;
    OraSession1: TOraSession;
    OraTransaction1: TOraTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure SetPriceTableGridColumn(AGrid: TNextGrid);
    procedure SetPriceTableGrid(AGrid: TNextGrid);
  public
    FElecPowerCalcBase: TElecPowerCalcBase;
    FPDHelper: TPlannerDateHelper;

    procedure GetHolidayFromOracleDB;
    procedure GetElecPowerPriceTable;
    procedure ShowElecPowerPriceTable;
  end;

var
  DM4: TDataModule4;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule4.DataModuleCreate(Sender: TObject);
begin
  FElecPowerCalcBase := TElecPowerCalcBase.Create(Self);
  FPDHelper := TPlannerDateHelper.Create(Self);
  GetHolidayFromOracleDB;
  GetElecPowerPriceTable;
end;

procedure TDataModule4.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FPDHelper);
  FreeAndNil(FElecPowerCalcBase);
end;

//한글 깨지는 문제 해결
//OraSession.option.UnicodeEnvironment := true
//OraSession.option.UseUnicode := true
procedure TDataModule4.GetElecPowerPriceTable;
var
  i: integer;
begin
  with OraQuery1 do
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

procedure TDataModule4.GetHolidayFromOracleDB;
begin
  with OraQuery1 do
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
        with FPDHelper.FHoliDayList.HoliDayCollect.Add do
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

procedure TDataModule4.SetPriceTableGrid(AGrid: TNextGrid);
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

procedure TDataModule4.SetPriceTableGridColumn(AGrid: TNextGrid);
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

procedure TDataModule4.ShowElecPowerPriceTable;
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

end.
