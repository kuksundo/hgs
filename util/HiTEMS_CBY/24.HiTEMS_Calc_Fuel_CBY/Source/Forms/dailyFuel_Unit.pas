unit dailyFuel_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons, JvExControls,
  JvLabel, Vcl.ImgList, Vcl.Imaging.jpeg, Vcl.ExtCtrls, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Ora, NxColumnClasses, NxColumns,
  DateUtils, AdvCircularProgress, JvBaseDlg, JvProgressDialog, Vcl.ComCtrls;

type
  TCalcuratorThread = class(TThread)
  private
    iCnt : Integer;
    FProgressBar : TProgressBar;
    FLb_EngType,
    FLb_Day   : TLabel;
    FgridFuel : TNextGrid;
    FstartDay : TDateTime;
    FCurrentDay : String;
    FEngineType : String;
    OraQuery : TOraQuery;
    procedure SetProgressBar(const aProgressBar: TProgressBar);
    procedure SetLbEngType(const aLabel: TLabel);
    procedure SetLbDay(const aLabel: TLabel);
    procedure SetGridFuel(const Value: TNextGrid);
    procedure SetStartDay(const Day:TDateTime);
    procedure SetCurrentDay(const aCurrentDay:String);
    procedure SetEngineType(const aEngineType:String);
    procedure Del_Fuel_Day_Consumption(aDay:TDateTime;aEngType:String);
  protected
    procedure Display;
    procedure Get_Fuel_Consumption(aTable,aPower,aRpm,aTime,aEngModel:String;aMCR:Integer);
    procedure Execute;override;
  public
    constructor Create;
    destructor Destroy;override;

    property ProgBar : TProgressBar read FProgressBar write SetProgressBar;
    property LbEngType:TLabel read FLb_EngType write SetLbEngType;
    property LbDays:TLabel read FLb_Day write SetLbDay;
    property GridFuel:TNextGrid read FgridFuel write SetGridFuel;
    property StartDay:TDateTime read FstartDay write SetStartDay;
    property EngineType:String read FEngineType write SetEngineType;
    property CurrentDay:String read FCurrentDay write SetCurrentDay;


    procedure Insert_Fuel_Day_Consumption(aDay:TDateTime;aEngine:
      String;aLoad:Integer;aRunTime_S, aRunTime_H, aSTD, aResult, aKwh:Double);

  end;

type
  TdailyFuel_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList32x32: TImageList;
    pn_Main: TPanel;
    JvLabel22: TJvLabel;
    btn_Close: TAeroButton;
    ImageList16x16: TImageList;
    ImageList24x24: TImageList;
    Timer1: TTimer;
    JvLabel1: TJvLabel;
    grid_Fuel: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxNumberColumn;
    btn_StartStop: TAeroButton;
    NxDateColumn1: TNxDateColumn;
    AdvCircularProgress1: TAdvCircularProgress;
    lb_Day: TLabel;
    lb_EngType: TLabel;
    NxNumberColumn1: TNxNumberColumn;
    Label1: TLabel;
    pb_Progress: TProgressBar;
    Label2: TLabel;
    dt_Start: TDateTimePicker;
    Timer2: TTimer;
    procedure btn_StartStopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dt_StartChange(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    FDay : TDateTime;
    FCalcuratorThread : TCalcuratorThread;
  public
    { Public declarations }

    procedure verified_Data;

  end;

  function Calc_Fuel_Consumption(aP:Pointer):LongInt;StdCall;
var
  dailyFuel_Frm: TdailyFuel_Frm;

implementation
uses
  DataModule_Unit;


{$R *.dfm}

function Calc_Fuel_Consumption(aP:Pointer):LongInt;StdCall;
var
  OraQuery : TOraQuery;
begin


end;

{ TdailyFuel_Frm }

procedure TdailyFuel_Frm.btn_CloseClick(Sender: TObject);
begin
  if Assigned(FCalcuratorThread) then
  begin
    if FCalcuratorThread.Suspended then
      FCalcuratorThread.Resume;
    FCalcuratorThread.Terminate;
    FCalcuratorThread.WaitFor;
    FCalcuratorThread.Free;
  end;
  Close;
end;

procedure TdailyFuel_Frm.btn_StartStopClick(Sender: TObject);
var
  LDay : TDateTime;
begin
  if btn_StartStop.Caption = '시작' then
  begin
    btn_StartStop.Caption := '중지';
    AdvCircularProgress1.Visible := True;
    FCalcuratorThread := TCalcuratorThread.Create;
    with FCalcuratorThread do
    begin
      ProgBar   := Self.pb_Progress;
      LbEngType := Self.lb_EngType;
      LbDays    := Self.lb_Day;
      GridFuel := Self.grid_Fuel;
      StartDay := StrToDateTime(FormatDateTime('yyyy-MM-dd',dt_Start.Date)+' 00:00');
      Resume;

      Timer2.Enabled := True;
    end;
  end
  else
  begin
    btn_StartStop.Caption := '시작';
    AdvCircularProgress1.Visible := False;

    if FCalcuratorThread.Suspended then
      FCalcuratorThread.Resume;
    FCalcuratorThread.Terminate;
    FCalcuratorThread.WaitFor;
    FCalcuratorThread.Free;
  end;
end;


procedure TdailyFuel_Frm.dt_StartChange(Sender: TObject);
begin
  dt_Start.Time := StrToDateTime('00:00');
end;

procedure TdailyFuel_Frm.FormCreate(Sender: TObject);
var
  LParam : String;
begin
  dt_Start.date := today;
  btn_StartStop.Visible := False;
  btn_StartStop.Visible := False;
  LParam := ParamStr(1);
  if UpperCase(LParam) = '/A' then
  begin
    Timer1.Enabled := True;
  end else
  begin
    btn_StartStop.Visible := True;
    btn_StartStop.Visible := True;
  end;
end;

procedure TdailyFuel_Frm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  AdvCircularProgress1.Visible := True;
  FCalcuratorThread := TCalcuratorThread.Create;
  with FCalcuratorThread do
  begin
    ProgBar   := Self.pb_Progress;
    LbEngType := Self.lb_EngType;
    LbDays    := Self.lb_Day;
    GridFuel := Self.grid_Fuel;
    StartDay := IncDay(Today,-1);//자동 실행은 하루전 데이터 취급
    Resume;
    Timer2.Enabled := True;
  end;

//  Label1.Caption := '현재시간 : '+FormatDateTime('YYYY-MM-DD HH:mm:ss',Now);
//  if Today >= FDay then
//  if Today > FDay then
//  begin
//    Timer1.Enabled := False;
//    try
//      Caption := FormatDateTime('YYYY-MM-DD', FDay);
//      Calculate_Fuel_Consumption(FDay);
//      Application.ProcessMessages;
//      FDay := IncDay(FDay);
//    finally
//      if btn_StartStop.Caption = '중지' then
//        Timer1.Enabled := True;
//    end;
//  end;
end;

procedure TdailyFuel_Frm.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := False;
  while not FCalcuratorThread.Terminated do
  begin
    Application.ProcessMessages;
  end;
  Close;
end;

procedure TdailyFuel_Frm.verified_Data;
var
  i,j,
  LMCR,
  LRow : Integer;
  LHeader : Boolean;
  LDay,
  LEngine,
  LRpm,
  LPower,
  LTable : String;
  OraQuery : TOraQuery;
begin
  LPower  := 'DATA249';
  LTable  := 'TBACS.YE0594_18H2533V_MEASURE_DATA';
  LEngine := 'YE0594_18H25/33V';
  LDay    := '20131107';
  LRpm    := 'Data27';
  LMcr    := 6120;

  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    OraQuery.FetchAll := True;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COUNT(*) COUNT FROM '+LTable +' ' +
              'WHERE SUBSTR(DATASAVEDTIME,1,8) LIKE :day ');
      ParamByName('day').AsString   := LDay;
      Open;

      if FieldByName('COUNT').AsInteger > 0 then
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ' +
                ' SEC, ' +
                ' HR, ' +
                ' LOAD, ' +
                ' ROUND((KW / SEC),0) KWH, ' +
                ' STD, ' +
                ' RESULT ' +
                'FROM ' +
                '( ' +
                '   SELECT  ' +
                '     SUM(CNT) SEC, ' +
                '     ROUND(SUM(CNT) / 3600,1) HR, ' +
                '     A.LOAD, ' +
                '     SUM(A.KW) KW, '+
                '     B.CONSUMPTION STD, ' +
                '     ROUND((((:MCR / A.LOAD) * B.CONSUMPTION) * (SUM(CNT) / 3600)) / 1000) RESULT ' +
                '   FROM ' +
                '   ( ' +
                '       SELECT ' +
                '         CNT,  ' +
                '         KW, ' +
                '         CASE  ' +
                '           WHEN LOAD = 0  THEN 10  ' +
                '           WHEN LOAD > 0  AND LOAD < 11 THEN 10  ' +
                '           WHEN LOAD > 10 AND LOAD < 26 THEN 25 ' +
                '           WHEN LOAD > 25 AND LOAD < 51 THEN 50 ' +
                '           WHEN LOAD > 50 AND LOAD < 76 THEN 75 ' +
                '           WHEN LOAD > 75 AND LOAD < 101 THEN 100 ' +
                '           WHEN LOAD > 100 THEN 110 ' +
                '         END AS LOAD ' +
                '       FROM ' +
                '       ( ' +
                '           SELECT COUNT(*) CNT, LOAD, SUM(KW) KW FROM ' +
                '           ( ' +
                '               SELECT ' +
                '                 DISTINCT(SUBSTR(DATASAVEDTIME,1,14)) DATASAVEDTIME, ' +
                '               '+LPower+' KW, '+
                '                 ROUND(((NVL('+LPower+',0)/1000) / :MCR)*100) LOAD ' +
                '               FROM '+LTable +
                '               WHERE SUBSTR(DATASAVEDTIME,1,8) LIKE :day ' +
                '               AND '+LRpm+' > 0 ' +
                '           ) GROUP BY LOAD, KW ' +
                '       ) ' +
                '   ) A LEFT OUTER JOIN FUEL_CONSUMPTION B ' +
                '   ON A.LOAD = B.LOAD ' +
                '   GROUP BY A.LOAD, CONSUMPTION, UNIT ' +
                '   ORDER BY A.LOAD ' +
                ') ');

        ParamByName('mcr').AsInteger  := LMcr;
        ParamByName('day').AsString   := LDay;
        Open;

        with grid_Fuel do
        begin
          BeginUpdate;
          try
            LHeader := False;
            for i := 0 to RecordCount-1 do
            begin
//              if FieldByName('HR').AsInteger <> 0 then
//              begin
                if RowCount > 300 then
                  ClearRows;

                InsertRow(0);
                if not LHeader then
                begin
                  LHeader := True;
                  Cells[1,0] := LDay;
                  Cells[2,0] := LEngine;
                end;

                Cell[3,0].AsFloat   := FieldByName('SEC').AsFloat;
                Cell[4,0].AsInteger := FieldByName('LOAD').AsInteger;
                Cell[5,0].AsFloat   := FieldByName('HR').AsFloat;
                Cell[6,0].AsInteger := FieldByName('STD').AsInteger;
                Cell[7,0].AsFloat   := FieldByName('RESULT').AsFloat;

                if (RowCount mod 2 = 0) then
                begin
                  for j := 0 to Columns.Count-1 do
                    Cell[j,0].Color := $00DFDFDF;
                end;

                CalculateFooter(true);
//              end;
              Next;
            end;
          finally
            EndUpdate;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

{ TCalcuratorThread }

constructor TCalcuratorThread.Create;
begin
  iCnt := 0;
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  OraQuery.FetchAll := True;

  FreeOnTerminate := False;
  inherited Create( true );
end;

procedure TCalcuratorThread.Del_Fuel_Day_Consumption(aDay:TDateTime;aEngType:String);
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
      SQL.Add('DELETE FROM FUEL_CONSUMPTION ' +
              'WHERE DAY = :param1 ' +
              'AND ENGINE LIKE :param2 ');
      ParamByName('param1').AsDate   := aDay;
      ParamByName('param2').AsString := aEngType;
      ExecSQL;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

destructor TCalcuratorThread.Destroy;
begin
  if Assigned(OraQuery) then
    FreeAndNil(OraQuery);


  inherited;
end;

procedure TCalcuratorThread.Display;
var
  LHeader : Boolean;
  i : Integer;
begin
  LbEngType.Caption := '엔진타입 : '+EngineType;
  LbDays.Caption    := '계산일자 : '+CurrentDay;
  ProgBar.Position  := iCnt;
  with GridFuel do
  begin
    BeginUpdate;
    try
      with OraQuery do
      begin
        First;
        LHeader := False;

        for i := 0 to RecordCount-1 do
        begin
          if FieldByName('RESULT').AsFloat > 0 then
          begin
            if RowCount > 300 then
              ClearRows;

            InsertRow(0);
            if not LHeader then
            begin
              LHeader := True;
              Cell[1,0].AsDateTime := StrToDate(FormatDateTime('yyyy-MM-dd',StrToDateTime(CurrentDay)));
            end;
            Cell[2,0].AsInteger  := StrToInt(FormatDateTime('HH',StrToDateTime(CurrentDay)));
            Cells[3,0] := EngineType;
            Cells[4,0] := FieldByName('SEC').AsString;
            Cells[5,0] := FieldByName('LOAD').AsString;
            Cells[6,0] := FieldByName('HR').AsString;
            Cells[7,0] := FieldByName('STD').AsString;
            Cells[8,0] := FieldByName('RESULT').AsString;

            CalculateFooter(true);

            Insert_FUEL_DAY_CONSUMPTION(StrToDateTime(CurrentDay),
                                        EngineType,
                                        FieldByName('LOAD').AsInteger,
                                        FieldByName('SEC').AsFloat,
                                        FieldByName('HR').AsFloat,
                                        FieldByName('STD').AsFloat,
                                        FieldByName('RESULT').AsFloat,
                                        FieldByName('KWH').AsFloat);
          end;
          Next;
        end;
      end;
    finally
      Invalidate;
      EndUpdate;
    end;
  end;
end;

procedure TCalcuratorThread.Execute;
var
  i: Integer;
  LEngType,
  LEngModel,
  LTable,
  LPower,
  LRpm : String;
  LDay,
  LTime : TDateTime;
  LMCR : Integer;

begin
  LDay := StartDay;
  while not Terminated do
  begin
    if LDay <= Today then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT * FROM ' +
                '   ( ' +
                '       SELECT A.*, B.MCR, B.ENGMODEL FROM MON_TABLES A, HIMSEN_INFO B ' +
                '       WHERE A.ENG_PROJNO LIKE B.PROJNO ' +
                '   ) A ' +
                '   LEFT OUTER JOIN ' +
                '   ( ' +
                '       SELECT DATA_ENGPROJNO PE, DATA_COLUMN POWER ' +
                '       FROM MON_MAP WHERE KEY LIKE :power ' +
                '   ) B ' +
                '   ON ENG_PROJNO LIKE B.PE ' +
                ') A ' +
                'LEFT OUTER JOIN ' +
                '( ' +
                '   SELECT DATA_ENGPROJNO PR, DATA_COLUMN RPM ' +
                '   FROM MON_MAP WHERE KEY LIKE :rpm ' +
                ') B ' +
                'ON ENG_PROJNO LIKE B.PR ' +
                'ORDER BY SEQ_NO ');
        ParamByName('power').AsString := 'POWER';
        ParamByName('rpm').AsString   := 'DATA51';
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            SetEngineType(FieldByName('ENG_PROJNO').AsString+'-'+FieldByName('ENG_TYPE').AsString);
            LEngModel:= FieldByName('ENGMODEL').AsString;
            LTable   := FieldByName('OWNER').AsString+'.'+FieldByName('TABLE_NAME').AsString;
            LPOWER   := FieldByName('POWER').AsString; //Field Name

            if LPower = '' then
              LPower := '0';

            LRpm     := FieldByName('RPM').AsString;  //Field Name
            LMCR     := FieldByName('MCR').AsInteger;

            LTime := StrToDateTime(FormatDateTime('yyyy-MM-dd 00:00',LDay));
            Del_Fuel_Day_Consumption(LDay,EngineType);
            for i := 0 to 23 do
            begin
              iCnt := i+1;
              if i <> 0 then
                LTime := IncHour(LTime,1);

              SetCurrentDay(FormatDateTime('yyyy-MM-dd HH:mm',LTime));

              Get_Fuel_Consumption(LTable,
                                   LPower,
                                   LRpm,
                                   CurrentDay,
                                   LEngModel,
                                   LMcr);

              Synchronize( Display );

              Application.ProcessMessages;

            end;
            Next;
          end;
        end;
      end;
      LDay := IncDay(LDay,1);
    end else
      Terminate;
  end;
end;

procedure TCalcuratorThread.Get_Fuel_Consumption(aTable,aPower,aRpm,aTime,aEngModel:String;aMCR:Integer);
var
  i,j,
  LRow : Integer;
  LStr : String;
begin
  with OraQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COUNT(*) RESULT FROM '+aTable+' '+
            'WHERE DATASAVEDTIME LIKE :param1 ');
    ParamByName('param1').AsString := FormatDateTime('yyyyMMddHH',StrToDateTime(aTime))+'%';
    Open;

    if FieldByName('RESULT').AsInteger > 0 then
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT ' +
              ' SEC, ' +
              ' HR, ' +
              ' LOAD, ' +
              ' ROUND((KW / SEC),0) KWH, ' +
              ' STD, ' +
              ' RESULT ' +
              'FROM     ' +
              '(     ' +
              '   SELECT  ' +
              '     SUM(CNT) SEC,  ' +
              '     ROUND(SUM(CNT) / 3600,1) HR, ' +
              '     A.LOAD, ' +
              '     SUM(A.KW) KW, ' +
              '     B.CONSUMPTION STD, ' +
              '     ROUND(((((:MCR * A.LOAD) / 100) * B.CONSUMPTION) * (SUM(CNT) / 3600)) / 1000) RESULT ' +
              '   FROM ' +
              '   ( ' +
              '       SELECT  ' +
              '         CNT,   ' +
              '         KW, ' +
              '         CASE ' +
              '           WHEN LOAD = 0 THEN 10   ' +
              '           WHEN LOAD > 0  AND LOAD < 11 THEN 10   ' +
              '           WHEN LOAD > 10 AND LOAD < 26 THEN 25  ' +
              '           WHEN LOAD > 25 AND LOAD < 51 THEN 50  ' +
              '           WHEN LOAD > 50 AND LOAD < 76 THEN 75  ' +
              '           WHEN LOAD > 75 AND LOAD < 101 THEN 100  ' +
              '           WHEN LOAD > 100 THEN 110  ' +
              '         END AS LOAD  ' +
              '       FROM  ' +
              '       ( ' +
              '           SELECT COUNT(*) CNT, LOAD, SUM(KW) KW FROM ' +
              '           ( ' +
              '               SELECT  ' +
              '                 DISTINCT(SUBSTR(DATASAVEDTIME,1,14)) DATASAVEDTIME, ' +
              '                 '+aPower+' KW,  ' +
              '                 ROUND((NVL('+aPower+',0) / :mcr)*100) LOAD ' +
              '               FROM '+aTable+
              '               WHERE ROWID IN ' +
              '               ( ' +
              '                   SELECT MAX(ROWID) FROM ' +
              '                   ( ' +
              '                       SELECT ' +
              '                         ROWID, ' +
              '                         SUBSTR(DATASAVEDTIME,1,14) DATASAVEDTIME ' +
              '                       FROM '+aTable+
              '                       WHERE SUBSTR(DATASAVEDTIME,1,14) LIKE :day ' +
              '                   ) GROUP BY DATASAVEDTIME ' +
              '               ) AND '+aRpm+' > 0 ' +
              '           ) GROUP BY LOAD, KW ' +
              '       )         ' +
              '   ) A LEFT OUTER JOIN FUEL_STD_CONSUMPTION B ' +
              '   ON A.LOAD = B.LOAD ' +
              '   AND B.ENG_MODEL LIKE :engModel ' +
              '   GROUP BY A.LOAD, CONSUMPTION, UNIT ' +
              ') ORDER BY LOAD ');


      ParamByName('engModel').AsString := aEngModel;
      ParamByName('mcr').AsInteger  := aMCR;
      LStr := FormatDateTime('yyyyMMddHH',StrToDateTime(aTime));
      ParamByName('day').AsString   := LStr+'%';
      Open;

    end;
  end;
end;

procedure TCalcuratorThread.Insert_Fuel_Day_Consumption(aDay: TDateTime;
  aEngine: String; aLoad: Integer; aRunTime_S, aRunTime_H, aSTD,
  aResult, aKwh: Double);
begin
  TThread.Queue(nil,
  procedure
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
        SQL.Add('INSERT INTO FUEL_CONSUMPTION ' +
                '( ' +
                '   DAY, HOUR, ENGINE, LOAD, RUNTIME_S, RUNTIME_H, STD_CONSUMPTION, DAY_RESULT, KWH  ' +
                ') VALUES ' +
                '( ' +
                '   :DAY, :HOUR, :ENGINE, :LOAD, :RUNTIME_S, :RUNTIME_H, :STD_CONSUMPTION, :DAY_RESULT, :KWH  ' +
                ') ');

        ParamByName('DAY').AsDate              := aDay;
        ParamByName('HOUR').AsInteger          := StrToInt(FormatDateTime('HH',aDay));
        ParamByName('ENGINE').AsString         := aEngine;
        ParamByName('LOAD').AsInteger          := aLoad;
        ParamByName('RUNTIME_S').AsFloat       := aRunTime_S;
        ParamByName('RUNTIME_H').AsFloat       := aRunTime_H;
        ParamByName('STD_CONSUMPTION').AsFloat := aSTD;
        ParamByName('DAY_RESULT').AsFloat      := aResult;
        ParamByName('KWH').AsFloat             := aKwh;
        ExecSQL;

      end;
    finally
      FreeAndNil(OraQuery);
    end;
  end);
end;

procedure TCalcuratorThread.SetCurrentDay(const aCurrentDay: String);
begin
  FCurrentDay := aCurrentDay;
end;

procedure TCalcuratorThread.SetEngineType(const aEngineType: String);
begin
  FEngineType := aEngineType;

end;

procedure TCalcuratorThread.SetGridFuel(const Value: TNextGrid);
begin
  FgridFuel := Value;
end;

procedure TCalcuratorThread.SetLbDay(const aLabel: TLabel);
begin
  FLb_Day := aLabel;
end;

procedure TCalcuratorThread.SetLbEngType(const aLabel: TLabel);
begin
  FLb_EngType := aLabel;
end;

procedure TCalcuratorThread.SetProgressBar(const aProgressBar: TProgressBar);
begin
  FProgressBar := aProgressBar;
end;

procedure TCalcuratorThread.SetStartDay(const Day: TDateTime);
begin
  FstartDay := Day;
end;

end.
