unit UnitAlarmList_old;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvOfficeStatusBar, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxColumnClasses, NxColumns, NxGrid, ExtCtrls, sql3_defs, DB,
  UnitAlarmConfigClass, UnitAlarmConfig, Menus, DeCAL, UnitAlarmConst, DragDrop,
  DropTarget, DragDropText, ComCtrls, UnitFrameIPCMonitorAll, HiMECSConst,
  AdvListV, JvExComCtrls, JvListView;

const
  DefaultPassPhrase = 'DefaultPassPhrase';
  DefaultConfigFileName = 'DefaultAlarm.config';
  DefaultEncryption = False;

type
  TFormAlarmList = class(TForm)
    PageControl1: TPageControl;
    TFrameIPCMonitorAll1: TFrameIPCMonitorAll;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    Sivak3Database1: TSivak3Database;
    Sivak3Query1: TSivak3Query;
    Sivak3Exec1: TSivak3Exec;
    MainMenu1: TMainMenu;
    Sivak3SimpleTable1: TSivak3SimpleTable;
    AlarmListGrid: TNextGrid;
    AlarmListPopup: TPopupMenu;
    Config2: TMenuItem;
    est1: TMenuItem;
    N2: TMenuItem;
    DeleteItem2: TMenuItem;
    DropTextTarget1: TDropTextTarget;
    AdvListView1: TAdvListView;
    TabSheet3: TTabSheet;
    ListView1: TListView;
    JvListView1: TJvListView;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Config1Click(Sender: TObject);
    procedure est1Click(Sender: TObject);
    procedure ListView1DrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
  private
    //=====
    FAlarmConfig : TAlarmConfig;
    FDataBase: TSivak3Database;
    FQuery: TSivak3Query;
    FExec: TSivak3Exec;
    FApplicationPath: string;

    FAlarmListMap: DMap;
    FAlarmListRecord: TAlarmListRecord;

    procedure InitAlarmList;
    procedure AddAlarm2List(AParameterIndex: integer);
    function AddData2AlarmListMap(AParameterIndex: integer; AValue: string;
                                    AAlarmDesc: string): Boolean;
    function DeleteDataFromAlarmListMap(AParameterIndex: integer): Boolean;

    procedure CheckMinFault(APIndex: integer; ATime: TDateTime);
    procedure CheckMaxFault(APIndex: integer; ATime: TDateTime);
    procedure CheckMinWarn(APIndex: integer; ATime: TDateTime);
    procedure CheckMaxWarn(APIndex: integer; ATime: TDateTime);

    procedure LoadConfigAlarmListFromFile(AFileName: string; AIsEncrypt: Boolean);

    procedure LoadConfigCollect2Form(AForm: TAlarmConfigF);
    procedure LoadConfigForm2Collect(AForm: TAlarmConfigF);
    procedure LoadConfigCollectFromFile(AFileName: string; AIsEncrypt: Boolean);
    procedure SetConfigAlarmList(Sender: TObject);

    function CheckDBFile(AFileName: string): Boolean;
    procedure GetFields2Grid(ADb: TSivak3Database; ATableName: String; AGrid: TNextGrid);

    procedure DB_Create_Table;
    function DB_Alarm_insert(AEPIndex: integer; AAlarmDesc: string): integer;//ALevel: integer; ATime: TDateTime; ATagname, AAlarmDesc : string): integer;
    procedure DB_Alarm_Update(ASeqNo: integer; ATime: TDateTime; ATagname, AAlarmDesc : string);
    procedure DB_Alarm_Select(ASeqNo: integer; ATagname, AAlarmDesc : string);
  public
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer);
  end;

var
  FormAlarmList: TFormAlarmList;

implementation

{$R *.dfm}

{ TFormAlarmList }

procedure TFormAlarmList.AddAlarm2List(AParameterIndex: integer);
//var
//  i: integer;
begin
  //for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  //begin
    CheckMinFault(AParameterIndex,now);
    CheckMaxFault(AParameterIndex,now);
    CheckMinWarn(AParameterIndex,now);
    CheckMaxWarn(AParameterIndex,now);
  //end;//for
end;

function TFormAlarmList.AddData2AlarmListMap(AParameterIndex: integer; AValue,
  AAlarmDesc: string): Boolean;
var
  it: Diterator;
  LStr: string;
  LAlarmListRecord: TAlarmListRecord;
begin
  Result := False;
  LStr := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].TagName;
  it := FAlarmListMap.locate( [LStr] );

  if not atEnd(it) then  //Data가 Map에 존재하면
  begin
    //LAlarmListRecord := GetObject(it) as TAlarmListRecord;
    //LAlarmListRecord.FValue := FloatToStr(AValue);
  end
  else
  begin
    LAlarmListRecord:= TAlarmListRecord.Create;
    LAlarmListRecord.FTagName := LStr;
    LAlarmListRecord.FValue := AValue;
    LAlarmListRecord.FAlarmDesc := AAlarmDesc;

    LAlarmListRecord.FDBRowIndex := DB_Alarm_insert(AParameterIndex,'');

    FAlarmListMap.putPair([LStr,LAlarmListRecord]);
    Result := True;
  end;
end;

function TFormAlarmList.CheckDBFile(AFileName: string): Boolean;
begin
  if FileExists(AFileName) then
  begin
    Result := True;
  end
  else
    Result := False;
end;

procedure TFormAlarmList.CheckMaxFault(APIndex: integer; ATime: TDateTime);
var
  j, LRow: integer;
  LSuccess: Boolean;
begin
  with TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if MaxFaultEnable then
    begin //Fault 발생
      if StrToFloatDef(Value, 0.0) > MaxFaultValue then
      begin
        LSuccess := AddData2AlarmListMap(APIndex,
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Value,
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + 'Low Alarm');

        if LSuccess then
        begin
          AlarmListGrid.InsertRow(0);
          AlarmListGrid.Cells[2,0] := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', ATime);
          AlarmListGrid.Cells[4,0] := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].TagName;
        end;
      end
      else
      begin //Alarm 해제
        LSuccess := DeleteDataFromAlarmListMap(APIndex);

        if LSuccess then
        begin
          for j := 0 to AlarmListGrid.Columns.Count - 1 do
            AlarmListGrid.Cell[j, LRow].Color := clRed;
        end;
      end;
    end;
  end;//with
end;

procedure TFormAlarmList.CheckMaxWarn(APIndex: integer; ATime: TDateTime);
var
  j, LRow: integer;
  LSuccess: Boolean;
begin
  with TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if MaxAlarmEnable then
    begin //Alarm 발생
      if StrToFloatDef(Value, 0.0) > MaxAlarmValue then
      begin
        LSuccess := AddData2AlarmListMap(APIndex,
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Value,
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + 'Low Alarm');

        if LSuccess then
        begin
          AlarmListGrid.InsertRow(0);
          AlarmListGrid.Cells[2,0] := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', ATime);
          AlarmListGrid.Cells[4,0] := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].TagName;
        end;
      end
      else
      begin //Alarm 해제
        LSuccess := DeleteDataFromAlarmListMap(APIndex);

        if LSuccess then
        begin
          for j := 0 to AlarmListGrid.Columns.Count - 1 do
            AlarmListGrid.Cell[j, LRow].Color := clRed;
        end;
      end;
    end;
  end;//with
end;

procedure TFormAlarmList.CheckMinFault(APIndex: integer; ATime: TDateTime);
var
  j, LRow: integer;
  LSuccess: Boolean;
begin
  with TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if MinFaultEnable then
    begin //Fault 발생
      if StrToFloatDef(Value, 0.0) < MinFaultValue then
      begin
        LSuccess := AddData2AlarmListMap(APIndex,
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Value,
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + 'Low Alarm');

        if LSuccess then
        begin
          AlarmListGrid.InsertRow(0);
          AlarmListGrid.Cells[2,0] := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', ATime);
          AlarmListGrid.Cells[4,0] := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].TagName;
        end;
      end
      else
      begin //Alarm 해제
        LSuccess := DeleteDataFromAlarmListMap(APIndex);

        if LSuccess then
        begin
          for j := 0 to AlarmListGrid.Columns.Count - 1 do
            AlarmListGrid.Cell[j, LRow].Color := clRed;
        end;
      end;
    end;
  end;//with
end;

procedure TFormAlarmList.CheckMinWarn(APIndex: integer; ATime: TDateTime);
var
  j, LRow: integer;
  LSuccess: Boolean;
begin
  with TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex] do
  begin
    if MinAlarmEnable then
    begin //Alarm 발생
      if StrToFloatDef(Value, 0.0) < MinAlarmValue then
      begin
        LSuccess := AddData2AlarmListMap(APIndex,
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Value,
          TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].Description + 'Low Alarm');

        if LSuccess then
        begin
          AlarmListGrid.InsertRow(0);
          AlarmListGrid.Cells[2,0] := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', ATime);
          AlarmListGrid.Cells[4,0] := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[APIndex].TagName;
        end;
      end
      else
      begin //Alarm 해제
        LSuccess := DeleteDataFromAlarmListMap(APIndex);

        if LSuccess then
        begin
          for j := 0 to AlarmListGrid.Columns.Count - 1 do
            AlarmListGrid.Cell[j, LRow].Color := clRed;
        end;
      end;
    end;
  end;//with
end;

procedure TFormAlarmList.Config1Click(Sender: TObject);
begin
  SetConfigAlarmList(nil);
end;

function TFormAlarmList.DB_Alarm_insert(AEPIndex: integer; AAlarmDesc: string): integer;// ATime: TDateTime; ATagname, AAlarmDesc : string): integer;
var
  //LIssueDate: TDateTime;
  LSQL: string;
begin
  Result := -1;
  FQuery.Close;
  FQuery.SQL.Clear;
  //FExec.CommandText.Clear;
  //LSQL := 'INSERT INTO "AlarmList" ("AlarmLevel", "IssueDateTime", "TagName", "TagDesc", "ReleaseDateTime", "AlarmDesc")';
  LSQL := 'INSERT INTO ';
  LSQL := LSQL + CheckQuotation('AlarmList') + ' ('#13#10;
  LSQL := LSQL + CheckQuotation('AlarmLevel') + ',';
  LSQL := LSQL + CheckQuotation('IssueDateTime') + ',';
  LSQL := LSQL + CheckQuotation('ReleaseDateTime') + ',';
  LSQL := LSQL + CheckQuotation('TagName') + ',';
  LSQL := LSQL + CheckQuotation('TagDesc') + ',';
  LSQL := LSQL + CheckQuotation('AlarmDesc') + ')';
  LSQL := LSQL + ' VALUES ('#13#10;
  LSQL := LSQL + ':AlarmLevel,:IssueDateTime,:ReleaseDateTime,:TagName,:TagDesc,:AlarmDesc' + ')';
  FQuery.SQL.Add(LSQL);
  FQuery.Prepare;
  //FExec.CommandText.Add(LSQL);
  if FQuery.Params.Count > 0 then
  begin
    with TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex] do
    begin
      FQuery.ParamByName('AlarmLevel').AsInteger := AlarmLevel;
      //FQuery.Params.Items[0].AsInteger := ALevel;
      FQuery.ParamByName('IssueDateTime').AsFloat := now;
      FQuery.ParamByName('ReleaseDateTime').AsFloat := 0.0;
      FQuery.ParamByName('TagName').AsString := TagName;
      FQuery.ParamByName('TagDesc').AsString := Description;
      FQuery.ParamByName('AlarmDesc').AsString := AAlarmDesc;
    end;

    FQuery.ExecSQL;

    FQuery.SQL.Clear;
    LSQL := 'select max(SeqNo) from alarmlist';
    FQuery.SQL.Add(LSQL);
    FQuery.Prepare;
    FQuery.Open;

    if FQuery.Active then
    begin
      Result := FQuery.Fields[0].AsInteger;
    end;
  end;
end;

procedure TFormAlarmList.DB_Alarm_Select(ASeqNo: integer; ATagname,
  AAlarmDesc: string);
begin

end;

procedure TFormAlarmList.DB_Alarm_Update(ASeqNo: integer; ATime: TDateTime;
  ATagname, AAlarmDesc: string);
var
  LIssueDate: TDateTime;
  LSQL: string;
begin
  FQuery.Close;
  FQuery.SQL.Clear;
  LSQL := 'UPDATE ALARMLIST SET ';
  LSQL := LSQL + CheckQuotation('ReleaseDateTime') + '= :ReleaseDateTime';
  LSQL := LSQL + ' WHERE ';
  LSQL := LSQL + CheckQuotation('SeqNo') + '= :SeqNo and ';
  LSQL := LSQL + CheckQuotation('ReleaseDateTime') + '= 0';
  FQuery.SQL.Add(LSQL);
  FQuery.Prepare;

  if FQuery.Params.Count > 0 then
  begin
    FQuery.ParamByName('ReleaseDateTime').AsFloat := ATime;
    FQuery.ParamByName('SeqNo').AsInteger := ASeqNo;
    FQuery.ExecSQL;
  end;
end;

procedure TFormAlarmList.DB_Create_Table;
var
  LStr: string;
begin
  if FAlarmConfig.AlarmDBDriver = '' then
  begin
    ShowMessage('AlarmDBDriver empty!');
    exit;
  end;

  if FAlarmConfig.AlarmDBFileName = '' then
  begin
    ShowMessage('AlarmDBFileName empty!');
    exit;
  end;

  FDataBase.CreateDatabase(deUTF_8, True,
        FAlarmConfig.AlarmDBFileName, 'Alarm List DataBase');
  LStr := 'CREATE TABLE AlarmList(';
  LStr := LStr + ' SeqNo INTEGER PRIMARY KEY,';
  LStr := LStr + ' AlarmLevel INTEGER,';
  LStr := LStr + ' IssueDateTime REAL,';
  LStr := LStr + ' TagName TEXT,';
  LStr := LStr + ' TagDesc TEXT,';
  LStr := LStr + ' ReleaseDateTime REAL,';
  LStr := LStr + ' SensorCode TEXT,';
  LStr := LStr + ' AlarmDesc TEXT)';

  FQuery.SQL.Add(LStr);
  FQuery.Prepare;
  FQuery.ExecSQL;
end;

function TFormAlarmList.DeleteDataFromAlarmListMap(
  AParameterIndex: integer): Boolean;
var
  it: Diterator;
  LStr: string;
  LAlarmListRecord: TAlarmListRecord;
begin
  Result := False;
  LStr := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AParameterIndex].TagName;
  it := FAlarmListMap.locate( [LStr] );

  if not atEnd(it) then  //Data가 Map에 존재하면
  begin
    LAlarmListRecord := GetObject(it) as TAlarmListRecord;
    FreeAndNil(LAlarmListRecord);
    FAlarmListMap.removeAt(it);
    Result := True;
  end;
end;

procedure TFormAlarmList.est1Click(Sender: TObject);
var
  i: integer;
begin
  //i := DB_Alarm_insert(1,now,'TESt tag','Alarm Desc');
  //if i > 0 then
  //begin
    DB_Alarm_Update(i,now,'TESt tag','Alarm Desc');
  //end;
end;

procedure TFormAlarmList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FAlarmConfig.Free;
  FQuery.Close;
  FQuery.Free;
  FDataBase.Close;
  FDataBase.Free;

  ObjFree(FAlarmListMap);
  FAlarmListMap.free;

end;

procedure TFormAlarmList.FormCreate(Sender: TObject);
var
  LStr: string;
begin
  FApplicationPath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  SetCurrentDir(FApplicationPath);

  InitAlarmList;
end;

procedure TFormAlarmList.GetFields2Grid(ADb: TSivak3Database; ATableName: String;
  AGrid: TNextGrid);
var
  LnxTextColumn: TnxTextColumn;
  LStrList: TStringList;
  Li: integer;
begin
  LStrList := TStringList.Create;
  try
    ADb.GetFieldNames(LStrList, ATableName);

    if LStrList.Count > 0 then
    begin
      with AGrid do
      begin
        ClearRows;
        Columns.Clear;
        //Columns.Add(TnxIncrementColumn,'No.');
      end;
    end;

    for Li := 0 to LStrList.Count - 1 do
    begin
      with AGrid do
      begin
        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn, LStrList[Li]));
        LnxTextColumn.Name := LStrList[Li];
        LnxTextColumn.Header.Alignment := taCenter;
        LnxTextColumn.Options := [coCanClick,coCanInput,coCanSort,coEditing,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
      end;
    end;
  finally
    LStrList.Free;
  end;

end;

procedure TFormAlarmList.InitAlarmList;
var
  LStr: string;
begin
  FAlarmConfig := TAlarmConfig.Create(Self);
  LoadConfigAlarmListFromFile(FApplicationPath+DefaultAlarmListConfigFileName,
    DefaultEncryption);
  FDataBase := TSivak3Database.Create(Self);
  FDataBase.Driver := FAlarmConfig.AlarmDBDriver;
  FQuery := TSivak3Query.Create(Self);
  FQuery.Database := FDataBase;
  FExec := TSivak3Exec.Create(Self);
  FExec.Database := FDataBase;

  if not CheckDBFile(FAlarmConfig.AlarmDBFileName) then
    DB_Create_Table;

  FDataBase.DatabaseFile := FAlarmConfig.AlarmDBFileName;
  LStr := ExtractFileName(FAlarmConfig.AlarmDBFileName);
  LStr := Copy(LStr, 0, Pos(ExtractFileExt(LStr), LStr) - 1);
  GetFields2Grid(FDataBase, LStr, AlarmListGrid);

  FAlarmListMap := DMap.Create;
  TFrameIPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;
end;

procedure TFormAlarmList.ListView1DrawItem(Sender: TCustomListView;
  Item: TListItem; Rect: TRect; State: TOwnerDrawState);
var
  i: Integer;
  x1, x2: integer;
  r: TRect;
  S: string;
const
  DT_ALIGN: array[TAlignment] of integer = (DT_LEFT, DT_RIGHT, DT_CENTER);
begin
{  if SameText(Item.SubItems[1], 'done') then
  begin
    Sender.Canvas.Font.Color := clWhite;
    Sender.Canvas.Brush.Color := clGreen;
  end
  else
    if Odd(Item.Index) then
    begin
      Sender.Canvas.Font.Color := clBlack;
      Sender.Canvas.Brush.Color := $F6F6F6;
    end
    else
    begin
      Sender.Canvas.Font.Color := clBlack;
      Sender.Canvas.Brush.Color := clWhite;
    end;
  if odSelected in State then                                                    // NEW!
  begin                                                                          // NEW!
    Sender.Canvas.Font.Color := clWhite;                                         // NEW!
    Sender.Canvas.Brush.Color := clNavy;                                         // NEW!
  end;
                                                                            // NEW!
  Sender.Canvas.Brush.Style := bsSolid;
  Sender.Canvas.FillRect(Rect);
  x1 := 0;
  x2 := 0;
  r := Rect;
  Sender.Canvas.Brush.Style := bsClear;
  Sender.Canvas.Draw(3, r.Top + (r.Bottom - r.Top - bm.Height) div 2, bm);

  for i := 0 to ListView1.Columns.Count - 1 do
  begin
    inc(x2, ListView1.Columns[i].Width);
    r.Left := x1;
    r.Right := x2;
    if i = 0 then
    begin
      S := Item.Caption;
      r.Left := bm.Width + 6;
    end
    else
      S := Item.SubItems[i - 1];

    DrawText(Sender.Canvas.Handle,
      S,
      length(S),
      r,
      DT_SINGLELINE or DT_ALIGN[ListView1.Columns[i].Alignment] or
        DT_VCENTER or DT_END_ELLIPSIS);
    x1 := x2;
  end;
}
  if odFocused in State then                                                     // NEW!
    DrawFocusRect(Sender.Canvas.Handle, Rect);                                   // NEW!
end;

procedure TFormAlarmList.LoadConfigAlarmListFromFile(AFileName: string;
  AIsEncrypt: Boolean);
begin
  if AFileName <> '' then
  begin
    if not FileExists(AFileName) then
    begin
      ShowMessage('Config File name ('+AFileName+') is not exist!');
      exit;
    end;

    FAlarmConfig.Clear;
    FAlarmConfig.LoadFromFile(AFileName,DefaultPassPhrase,AIsEncrypt);

    if FAlarmConfig.AlarmDBDriver = '' then
      FAlarmConfig.AlarmDBDriver := '.\sqlite3.dll';
  end
  else
    ShowMessage('Config File name is empty!');
end;

procedure TFormAlarmList.LoadConfigCollect2Form(AForm: TAlarmConfigF);
begin
  AForm.DBDriverEdit.FileName := FAlarmConfig.AlarmDBDriver;
  AForm.AlarmDBFilenameEdit.FileName := FAlarmConfig.AlarmDBFileName;
end;


procedure TFormAlarmList.LoadConfigCollectFromFile(AFileName: string;
  AIsEncrypt: Boolean);
begin
  if AFileName <> '' then
  begin
    if not FileExists(AFileName) then
    begin
      ShowMessage('Config File name ('+AFileName+') is not exist!');
      exit;
    end;

    FAlarmConfig.Clear;
    FAlarmConfig.LoadFromFile(AFileName,DefaultPassPhrase,AIsEncrypt);

    if FAlarmConfig.AlarmDBDriver = '' then
      FAlarmConfig.AlarmDBDriver := '.\sqlite3.dll';
  end
  else
    ShowMessage('Config File name is empty!');
end;

procedure TFormAlarmList.LoadConfigForm2Collect(AForm: TAlarmConfigF);
begin
  FAlarmConfig.AlarmDBDriver := AForm.DBDriverEdit.FileName;//IncludeTrailingPathDelimiter(AForm.DBDriverEdit.FileName);
  FAlarmConfig.AlarmDBFileName := AForm.AlarmDBFilenameEdit.FileName;
end;

procedure TFormAlarmList.SetConfigAlarmList(Sender: TObject);
var
  ConfigData: TAlarmConfigF;
begin
  ConfigData := nil;
  ConfigData := TAlarmConfigF.Create(Self);
  try
    with ConfigData do
    begin
      LoadConfigCollect2Form(ConfigData);

      if ShowModal = mrOK then
      begin
        SetCurrentDir(FApplicationPath);
        LoadConfigForm2Collect(ConfigData);
        FAlarmConfig.SaveToFile(FApplicationPath + DefaultConfigFileName);
      end;
    end;//with
  finally
    FreeAndNil(ConfigData);
  end;//try
end;

procedure TFormAlarmList.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer);
begin
  AddAlarm2List(AEPIndex);
end;

end.


