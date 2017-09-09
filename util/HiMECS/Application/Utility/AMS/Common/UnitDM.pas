unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, System.StrUtils, Vcl.StdCtrls, Data.DB, MemDS,
  DBAccess, Ora, OraCall, OraTransaction, IdHTTP, syncommons, UnitAlarmConfigClass, mORMot,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  pjhComboBox, EngineParameterClass, UnitAlarmConst, IPC_EngineParam_Const, HiMECSConst;

type
  TDM1 = class(TDataModule)
    OraTransaction1: TOraTransaction;
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraTransaction2: TOraTransaction;
    OraSession2: TOraSession;
    OraQuery2: TOraQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function GetEngineParameterSetValue(AProjNo, AEngNo, ATagName: string;
      ASetType: TAlarmSetType; AEP: TEngineParameterCollect): string;
  public
    FAlarmConfigCollect: TAlarmConfigCollect;
    FAlarmConfigEPCollect: TAlarmConfigEPCollect;
    FIsClientMode: Boolean;//AMSReporter에서 이 Unit를 사용하면  True
    FUserInfo: TUserInfo;
    FServerInfo: TServerInfo;
    FFieldNameList: TStringList;
    FFieldTypeList: TStringList;
    FEventData_EngineParam: TEventData_EngineParam;

    //ComboBox.Hint에 부서코드를 저장함 (A;K61;...)
    procedure FillInDeptCombo(ACombo: TComboBoxInc);
    procedure FillInPartCombo(ADeptCode: string; ACombo: TComboBoxInc);
    procedure FillInUserCombo(ADeptCode, APartCode: string; ACombo: TComboBoxInc);
    procedure FillInUserGrid(ADeptCode, APartCode: string; AGrid: TNextGrid);
    procedure FillInCategoryCombo(AUserId, AProjno, AEngNo: string; ACombo: TComboBox);
    function GetDeptNTeamCodeFromUserId(AUserid: string): string;
    procedure GetServerInfo;

    function getContent(url: String): String;
//============================================================================//
    //공장 리스트 반환
    function GetPlantList: TRawUTF8DynArray;
    //공장 내에 있는 엔진 리스트 반환
    procedure GetEngineListFromPlant(APlantName: string; out AEngList: TAlarmConfigCollect);
    //엔진의 센서(태그)리스트 반환
    procedure GetTagListFromEngine(AProjNo, AEngNo: string; out ATagList: TAlarmConfigEPCollect);
    //엔진에 설정된 알람 설정 리스트를 DB로 부터 조회하여 반환
    procedure GetAlarmConfigList(AUserId, ACatCode, AProjNo, AEquipNo: string;
      out ATagNames: TAlarmConfigCollect);
    //ATagName내용을 DB에 저장함
    function SaveAlarmConfigList2DB(ATagNames: TAlarmConfigCollect):TStringList; overload;
    //Result: userid;projno;engno 반환
    //NotifyCallBack에 사용됨
    function SaveAlarmConfigList2DB(ATagNames: string):TStringList;overload;
    procedure UpdateEngParamFile2DB(AProjNo, AEngNo, AFileName: string);
    procedure SelectEngParamFileFromDB(AProjNo, AEngNo: string; out AEP: TEngineParameterCollect);
    //User가 설정한 Config로 부터 Engine List를 가져옴
    procedure GetEngineMonListFromUser(AUserId: string; out AEngList: TStringList);
    procedure GetAlarmConfigFromDBPerEngine(AQuery: TOraQuery; AUniqueEngine: string);
    procedure GetAlarmConfigFromDBPerUser(AQuery: TOraQuery; AUserId, ACat: string);
    procedure GetAlarmConfigFromDBPerEngineNAssign2Collect(AUniqueEngine: string;
      AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict; AEP: TEngineParameterCollect);
    procedure GetAlarmConfigFromDBPerUserNAssign2Collect(AUserId, ACat: string;
      AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict; AEP: TEngineParameterCollect);
    procedure AssignAlarmConfig2Collect(AQuery: TOraQuery; AAlarmConfig: TAlarmConfig;
      AAlarmConfigDict: TAlarmConfigDict; AEP: TEngineParameterCollect; AIsPerEngine: Boolean);
    //AUniqueName = userid;catno;projno;engno
    procedure DeleteAlarmConfigFromUniqueName(AUniqueName: string;
      AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict);
    //AUniqueEngine = Projno;engno
    procedure DeleteAlarmConfigFromUniqueEngine(AUniqueEngine: string;
      AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict);
    //AUserId = 사번, ACat = 카테고리 명(Default)
    procedure DeleteAlarmConfigFromUser(AUserId, ACat: string;
      AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict);
    procedure SetDefaultConfigValue(var AAlarmConfigItem: TAlarmConfigItem);

    function ExecuteDBActionAll(ATagNames: TAlarmConfigCollect): boolean;
    function ExecuteDBActionAllInsert(ATagNames: TAlarmConfigCollect): boolean;
    function ExecuteDBActionAllDelete(ATagNames: TAlarmConfigCollect): boolean;
    function ExecuteDBActionAllUpdate(ATagNames: TAlarmConfigCollect): boolean;
    function ExecuteDBActionEach(ATagNames: TAlarmConfigCollect): boolean;
    //한개의 Item에 대해 Insert 수행, 성공하면  True 반환
    function ExecuteDBActionEachInsert(AAlarmConfigItem: TAlarmConfigItem): boolean;
    //한개의 Item에 대해 Delete 수행, 성공하면  True 반환
    function ExecuteDBActionEachDelete(AAlarmConfigItem: TAlarmConfigItem; AUseTransaction: Boolean = True): boolean;
    function ExecuteDBActionEachUpdate(AAlarmConfigItem: TAlarmConfigItem): boolean;

    procedure DeleteAlarmHistory(AAlarmConfigItem: TAlarmConfigItem);
    //Alarm History를 DB에 저장함
    procedure SaveAlarm2HistoryDB(ATableName: string; const ARecord: TAlarmListRecord);
    procedure UpdateAlarmAckTime2HistoryDB(const AAlarmConfigItem: TAlarmConfigItem);
    procedure UpdateAlarmOutTime2HistoryDB(const AAlarmConfigItem: TAlarmConfigItem);
    procedure GetAlarmHistoryFromDB4NonReleased(ATableName: string; AAlarmConfigCollect: TAlarmConfigCollect);

    //Monitoring Data를 조회
    procedure GetEngParamDataFromDB(ATableName: string; AEP: TEngineParameterCollect);
    function GetEngineRPM(ATableName,ARpmField: string): integer;
    procedure GetFieldNameListFromDB(ATableName: string);

    procedure AlarmListRecord2AlarmConfigItem(AlarmListRecord: TAlarmListRecord;
      var AAlarmConfigItem: TAlarmConfigItem);

    procedure ShowMsg(AMsg: string);
    procedure InitUserInfo(aUserId: String);
    function Get_User_Info(aUserId: String): TUserInfo;
    function GetUniqueTagName(AAlarmConfigItem: TAlarmConfigItem; AIsPerUser: Boolean = True): string;
    function GetRecipients(AUniqueTagName: string): string;
  end;

var
  DM1: TDM1;

implementation

uses System.Rtti, System.Generics.Collections, CommonUtil, Dialogs, TypInfo,
  System.DateUtils;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM1 }

procedure TDM1.AlarmListRecord2AlarmConfigItem(
  AlarmListRecord: TAlarmListRecord; var AAlarmConfigItem: TAlarmConfigItem);
begin
  AAlarmConfigItem.UserID := AlarmListRecord.FUserID;
  AAlarmConfigItem.Category := AlarmListRecord.FCategory;
  AAlarmConfigItem.ProjNo := AlarmListRecord.FProjNo;
  AAlarmConfigItem.EngNo := AlarmListRecord.FEngNo;
  AAlarmConfigItem.TagName := AlarmListRecord.FTagName;
  AAlarmConfigItem.AlarmSetType := AlarmListRecord.FAlarmSetType;
  AAlarmConfigItem.IssueDateTime := AlarmListRecord.FIssueDateTime;
  AAlarmConfigItem.ReleaseDateTime := AlarmListRecord.FReleaseDateTime;
  AAlarmConfigItem.AcknowledgedTime := AlarmListRecord.FAcknowledgedTime;
  AAlarmConfigItem.SuppressedTime := AlarmListRecord.FSuppressedTime;
  AAlarmConfigItem.IsOutLamp := AlarmListRecord.FIsOutLamp;
  AAlarmConfigItem.IsOnlyRun := AlarmListRecord.FIsOnlyRun;
  AAlarmConfigItem.AlarmPriority := AlarmListRecord.FAlarmPriority;
  AAlarmConfigItem.NeedAck := AlarmListRecord.FNeedAck;
  AAlarmConfigItem.SetValue := AlarmListRecord.FSetValue;
  AAlarmConfigItem.SensorValue := AlarmListRecord.FSensorValue;
  AAlarmConfigItem.AlarmMessage := AlarmListRecord.FAlarmMessage;
  AAlarmConfigItem.Delay := AlarmListRecord.FDelay;
  AAlarmConfigItem.DeadBand := AlarmListRecord.FDeadBand;
  AAlarmConfigItem.NotifyApps := AlarmListRecord.FNotifyApps;
end;

procedure TDM1.AssignAlarmConfig2Collect(AQuery: TOraQuery; AAlarmConfig: TAlarmConfig;
  AAlarmConfigDict: TAlarmConfigDict; AEP: TEngineParameterCollect; AIsPerEngine: Boolean);
var
  LAlarmConfigItem: TAlarmConfigItem;
  LList: TList<TAlarmConfigItem>;
  LStr, LUserId, LCat, LProj, LEng: string;
begin
  with AQuery do
  begin
    First;

    while not eof do
    begin
      LUserId := FieldByName('USER_ID').AsString;
      LCat := FieldByName('CAT_CODE').AsString;
      LProj := FieldByName('PROJ_NO').AsString;
      LEng := FieldByName('EQUIP_NO').AsString;

      if AIsPerEngine then
      begin

      end
      else//Per User
      begin

      end;

      LAlarmConfigItem := AAlarmConfig.AlarmConfigCollect.Add;

      with LAlarmConfigItem do
      begin
        UserID := LUserId;
        Category := LCat;
        ProjNo := LProj;
        EngNo := LEng;
        TagName := FieldByName('TAG_NAME').AsString;
        AlarmSetType := TAlarmSetType(FieldByName('SET_TYPE').AsInteger);
        SetValue := FieldByName('SET_VALUE').AsString;

        //-1이면 Engine Paramter 기본값 사용
        if SetValue = '-1' then
          SetValue := GetEngineParameterSetValue(ProjNo,EngNo,TagName,AlarmSetType, AEP);

        AlarmPriority := TAlarmPriority(FieldByName('PRIORITY').AsInteger);
        NotifyTerminals := FieldByName('NOTIFY_TERMINAL').AsInteger;
        NotifyApps := FieldByName('NOTIFY_APP').AsInteger;
        NeedAck := Boolean(FieldByName('IS_NEED_ACK').AsInteger);
        Delay := FieldByName('ALARM_DELAY').AsInteger;
        DeadBand := FieldByName('DEADBAND').AsInteger;
        IsAnalog := Boolean(FieldByName('IS_VALUE_ANALOG').AsInteger);
        IsOutLamp := Boolean(FieldByName('IS_OUTLAMP').AsInteger);
        IsOnlyRun := Boolean(FieldByName('IS_ONLY_RUN').AsInteger);
        DueDay := FieldByName('DUE_DAY').AsInteger;
        RegDate := FieldByName('REG_DATE').AsDateTime;
        AlarmMessage := FieldByName('ALARM_MESSAGE').AsString;
        EngType := FieldByName('ENG_TYPE').AsString;
        MonTableName := FieldByName('TABLE_NAME').AsString;
        AlarmHistoryTableName := StringReplace(MonTableName,'MEASURE_DATA','ALARM_HISTORY',[rfReplaceAll]);
        Recipients := GetRecipients(GetUniqueTagName(LAlarmConfigItem));

        Next;
      end;//with

      LStr := GetUniqueTagName(LAlarmconfigItem, False);//ProjNo_EngNo_TagName_AlarmType

      MonitorEnter(AAlarmConfigDict);
      try
        //다른 사용자가 동일한 Alarm을 설정할 수 있으므로 Dict에 충돌 방지하기 위해 검사함
        if AAlarmConfigDict.ContainsKey(LStr) then
        begin
          //이미 존재하면 TList<TAlarmConfigItem>에 LAlarmConfigItem append
          //동일한 조건(ProjNo_EngNo_TagName_SetType)이 복수개 존재 가능함(유져별 카테고리별로)
          AAlarmConfigDict[LStr].Add(LAlarmConfigItem);
        end
        else
        begin//없으면 추가
          LList := TList<TAlarmConfigItem>.Create;
          LList.Add(LAlarmConfigItem);
          AAlarmConfigDict.Add(LStr, LList);
        end;
      finally
        MonitorExit(AAlarmConfigDict);
      end;
    end;
  end;
end;

procedure TDM1.DataModuleCreate(Sender: TObject);
begin
  FAlarmConfigCollect := TAlarmConfigCollect.Create(TAlarmConfigItem);
  FAlarmConfigEPCollect := TAlarmConfigEPCollect.Create(TAlarmConfigEPItem);
  FFieldNameList := TStringList.Create;
  FFieldTypeList := TStringList.Create;
end;

procedure TDM1.DataModuleDestroy(Sender: TObject);
begin
  FFieldNameList.Free;
  FFieldTypeList.Free;
  FAlarmConfigCollect.Free;
  FAlarmConfigEPCollect.Free;
end;

procedure TDM1.DeleteAlarmConfigFromUniqueEngine(AUniqueEngine: string;
  AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict);
var
  i: integer;
  LProjNo, LEngNo, LUniqueTagName: string;
begin
  LProjNo := strToken(AUniqueEngine, ';');
  LEngNo := strToken(AUniqueEngine, ';');

  for i := AAlarmConfig.AlarmConfigCollect.Count - 1 downto 0 do
  begin
    if (LProjNo = AAlarmConfig.AlarmConfigCollect.Items[i].ProjNo) and
      (LEngNo = AAlarmConfig.AlarmConfigCollect.Items[i].EngNo) then
    begin
      LUniqueTagName := GetUniqueTagName(AAlarmConfig.AlarmConfigCollect.Items[i], False);
      if AAlarmConfigDict.ContainsKey(LUniqueTagName) then
      begin
        AAlarmConfigDict[LUniqueTagName].Free;
        AAlarmConfigDict.Remove(LUniqueTagName);
      end;
      AAlarmConfig.AlarmConfigCollect.Delete(i);
    end;
  end;
end;

procedure TDM1.DeleteAlarmConfigFromUniqueName(AUniqueName: string;
  AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict);
var
  i: integer;
  LUserId, LCat, LProjNo, LEngNo: string;
begin
  LUserId := strToken(AUniqueName, ';');
  LCat := strToken(AUniqueName, ';');
  LProjNo := strToken(AUniqueName, ';');
  LEngNo := strToken(AUniqueName, ';');

  for i := AAlarmConfig.AlarmConfigCollect.Count - 1 downto 0 do
  begin
    if (LUserId = AAlarmConfig.AlarmConfigCollect.Items[i].UserID) and
      (LCat = AAlarmConfig.AlarmConfigCollect.Items[i].Category) and
      (LProjNo = AAlarmConfig.AlarmConfigCollect.Items[i].ProjNo) and
      (LEngNo = AAlarmConfig.AlarmConfigCollect.Items[i].EngNo) then
    begin
      if AAlarmConfigDict.ContainsKey(AUniqueName) then
      begin
        AAlarmConfigDict[AUniqueName].Free;
        AAlarmConfigDict.Remove(AUniqueName);
      end;
      AAlarmConfig.AlarmConfigCollect.Delete(i);
    end;
  end;
end;

procedure TDM1.DeleteAlarmConfigFromUser(AUserId, ACat: string;
  AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict);
var
  i: integer;
  LAlarmConfigItem: TAlarmConfigItem;
  LUniqueTagName: string;
begin
  for i := AAlarmConfig.AlarmConfigCollect.Count - 1 downto 0 do
  begin
    LAlarmConfigItem := AAlarmConfig.AlarmConfigCollect.Items[i];

    if (AUserId = LAlarmConfigItem.UserID) and (ACat = LAlarmConfigItem.Category) then
    begin
      LUniqueTagName := GetUniqueTagName(LAlarmConfigItem, False);

      if AAlarmConfigDict.ContainsKey(LUniqueTagName) then
      begin
        AAlarmConfigDict[LUniqueTagName].Free;
        AAlarmConfigDict.Remove(LUniqueTagName);
      end;

      AAlarmConfig.AlarmConfigCollect.Delete(i);
    end;
  end;
end;

procedure TDM1.DeleteAlarmHistory(AAlarmConfigItem: TAlarmConfigItem);
var
  LOraQuery: TOraQuery;
  LStr: string;
begin
  LOraQuery := TOraQuery.Create(nil);
  LOraQuery.Session := OraSession1;
  try
    with LOraQuery do
    begin
      LStr := 'delete from ' + AAlarmConfigItem.AlarmHistoryTableName +
              ' where USER_ID = :userid and CAT_CODE = :catcode ' +
              '      and PROJ_NO = :projno and EQUIP_NO = :equipno ' +
              '      and TAG_NAME = :tagname and SET_TYPE = :settype ' +
              '      and ALARM_TIME_IN = :ALARM_TIME_IN ';
      Close;
      SQL.Clear;
      SQL.Add(LStr);

      with AAlarmConfigItem do
      begin
        ParamByName('userid').AsString := UserID;
        ParamByName('catcode').AsString := Category;
        ParamByName('projno').AsString := ProjNo;
        ParamByName('equipno').AsString := EngNo;
        ParamByName('tagname').AsString := TagName;
        ParamByName('settype').AsInteger := Ord(AlarmSetType);
        ParamByName('ALARM_TIME_IN').AsDateTime := IssueDateTime;

        OraSession1.Connected := True;
        OraTransaction1.StartTransaction;
        try
          ExecSQL;
        finally
          OraTransaction1.Commit;
        end;
      end;

    end;
  finally
    LOraQuery.Free;
  end;
end;

function TDM1.ExecuteDBActionAll(ATagNames: TAlarmConfigCollect): boolean;
var
  LAlarmConfigItem: TAlarmConfigItem;
  i, LSaveCnt, LNoneCnt: integer;
begin
  Result := False;

//  with OraQuery1 do
//  begin
//    OraSession1.Connected := True;
//    OraTransaction1.StartTransaction;
    try
//      for i := 0 to ATagNames.Count - 1 do
//      begin
//        LAlarmConfigItem := ATagNames.Items[i];

        if ExecuteDBActionAllDelete(ATagNames) then
          Result :=  ExecuteDBActionAllInsert(ATagNames);
//          Result := ExecuteDBActionEachInsert(LAlarmConfigItem);
//      end;

//      OraTransaction1.Commit;
      ShowMsg('ALL(Delete and Insert): ' + IntToStr(ATagNames.Count) + ' Config Item(s) Inserted');
    except
//      OraTransaction1.Rollback;

      ShowMsg('ALL(Delete and Insert): Config Item(s) Inserting is failed');
    end;
//  end;
end;

function TDM1.ExecuteDBActionAllDelete(ATagNames: TAlarmConfigCollect): boolean;
var
  LAlarmConfigItem: TAlarmConfigItem;
  i, LSaveCnt, LNoneCnt: integer;
  LStr, LUniqueName: string;
begin
  Result := False;

  with OraQuery1 do
  begin
    OraSession1.Connected := True;
    OraTransaction1.StartTransaction;
    LAlarmConfigItem := nil;
    try
      for i := 0 to ATagNames.Count - 1 do
      begin
        LAlarmConfigItem := ATagNames.Items[i];
//        Result := ExecuteDBActionEachDelete(LAlarmConfigItem);

        LStr := 'delete from HITEMS_ALARM_CONFIG ' +
                'where USER_ID = :userid and CAT_CODE = :catcode ' +
                '      and PROJ_NO = :projno and EQUIP_NO = :equipno ';

        Close;
        SQL.Clear;
        SQL.Add(LStr);

        with LAlarmConfigItem do
        begin
          ParamByName('userid').AsString := UserID;
          ParamByName('catcode').AsString := Category;
          ParamByName('projno').AsString := ProjNo;
          ParamByName('equipno').AsString := EngNo;
        end;

        ExecSQL;

        LUniqueName := GetUniqueTagName(LAlarmConfigItem);
        LStr := 'delete from HITEMS_ALARM_RECEIP_CONFIG ' +
                'where UNIQUE_TAG_NAME = :UNIQUE_TAG_NAME';
        Close;
        SQL.Clear;
        SQL.Add(LStr);
        ParamByName('UNIQUE_TAG_NAME').AsString := LUniqueName;

        ExecSQL;
      end;

      OraTransaction1.Commit;

      if Assigned(LAlarmConfigItem) then
        Result := UpperCase(LAlarmConfigItem.DBAction) <> 'DELETE ALL'
      else
        Result := True;
//      Result := True;
//      ShowMsg('ALL(Delete): ' + IntToStr(ATagNames.Count) + ' Config Item(s) Deleted');
      Close;
    except
      OraTransaction1.Rollback;
      Close;
      ShowMsg('ALL(Delete): Config Item(s) Deleting is failed');
    end;
  end;
end;

function TDM1.ExecuteDBActionAllInsert(ATagNames: TAlarmConfigCollect): boolean;
var
  LAlarmConfigItem: TAlarmConfigItem;
  i, LSaveCnt, LNoneCnt: integer;
begin
  Result := False;

//  with OraQuery1 do
//  begin
//    OraTransaction1.StartTransaction;
    try
      for i := 0 to ATagNames.Count - 1 do
      begin
        LAlarmConfigItem := ATagNames.Items[i];
        Result := ExecuteDBActionEachInsert(LAlarmConfigItem);
      end;

//      OraTransaction1.Commit;
      ShowMsg('ALL(Insert): ' + IntToStr(ATagNames.Count) + ' Config Item(s) Inserted');
    except
//      OraTransaction1.Rollback;
      ShowMsg('ALL(Insert): Config Item(s) Inserting is failed');
    end;
//  end;
end;

function TDM1.ExecuteDBActionAllUpdate(ATagNames: TAlarmConfigCollect): boolean;
var
  LAlarmConfigItem: TAlarmConfigItem;
  i, LSaveCnt, LNoneCnt: integer;
begin
  Result := False;

  with OraQuery1 do
  begin
    OraSession1.Connected := True;
    OraTransaction1.StartTransaction;
    try
      for i := 0 to ATagNames.Count - 1 do
      begin
        LAlarmConfigItem := ATagNames.Items[i];
        Result := ExecuteDBActionEachUpdate(LAlarmConfigItem);
      end;

      OraTransaction1.Commit;
      ShowMsg('ALL(Update): ' + IntToStr(ATagNames.Count) + ' Config Item(s) Updated');
    except
      OraTransaction1.Rollback;
      ShowMsg('ALL(Update): Config Item(s) Updating is failed');
    end;
  end;
end;

function TDM1.ExecuteDBActionEach(ATagNames: TAlarmConfigCollect): boolean;
var
  LAlarmConfigItem: TAlarmConfigItem;
  i, LSaveCnt, LNoneCnt: integer;
  LAction: string;
begin
  Result := False;

  with OraQuery1 do
  begin
    OraSession1.Connected := True;
    OraTransaction1.StartTransaction;
    try
      for i := 0 to ATagNames.Count - 1 do
      begin
        LAlarmConfigItem := ATagNames.Items[i];
        LAction := System.SysUtils.UpperCase(LAlarmConfigItem.DBAction);
        if LAction = 'I' then
        begin
          Result := ExecuteDBActionEachInsert(LAlarmConfigItem);
        end
        else
        if LAction = 'U' then
        begin
          Result := ExecuteDBActionEachUpdate(LAlarmConfigItem);
        end
        else
        if LAction = 'D' then
        begin
          Result := ExecuteDBActionEachDelete(LAlarmConfigItem);
        end;
      end;

      OraTransaction1.Commit;
    except
      OraTransaction1.Rollback;
      Result := False;
    end;
  end;
end;

function TDM1.ExecuteDBActionEachDelete(
  AAlarmConfigItem: TAlarmConfigItem; AUseTransaction: Boolean): boolean;
var
  LStr, LUniqueName: string;
  i: integer;
begin
  Result := False;

  with OraQuery1 do
  begin
    LStr := 'delete from HITEMS_ALARM_CONFIG ' +
            'where USER_ID = :userid and CAT_CODE = :catcode ' +
            '      and PROJ_NO = :projno and EQUIP_NO = :equipno ' +
            '      and TAG_NAME = :tagname and SET_TYPE = :settype';
    Close;
    SQL.Clear;
    SQL.Add(LStr);

    try
      with AAlarmConfigItem do
      begin
        ParamByName('userid').AsString := UserID;
        ParamByName('catcode').AsString := Category;
        ParamByName('projno').AsString := ProjNo;
        ParamByName('equipno').AsString := EngNo;
        ParamByName('tagname').AsString := TagName;
        ParamByName('settype').AsInteger := Ord(AlarmSetType);

        OraSession1.Connected := True;

        if AUseTransaction then
          OraTransaction1.StartTransaction;
        ExecSQL;

        LUniqueName := GetUniqueTagName(AAlarmConfigItem);
        LStr := 'delete from HITEMS_ALARM_RECEIP_CONFIG ' +
                'where UNIQUE_TAG_NAME = :UNIQUE_TAG_NAME';
        Close;
        SQL.Clear;
        SQL.Add(LStr);
        ParamByName('UNIQUE_TAG_NAME').AsString := LUniqueName;

        ExecSQL;

        if AUseTransaction then
          OraTransaction1.Commit;
        Close;
        Result := True;
      end;//with
    except
      if AUseTransaction then
        OraTransaction1.Rollback;
      Close;
      Result := False;
    end;
  end;
end;

function TDM1.ExecuteDBActionEachInsert(AAlarmConfigItem: TAlarmConfigItem): boolean;
var
  LStr, LUniqueName, LUserId, LReceip: string;
  i,j: integer;
begin
  Result := False;

  with OraQuery1 do
  begin
    LStr := 'Insert into HITEMS_ALARM_CONFIG ' +
            'VALUES(:USER_ID, :CAT_CODE, :PROJ_NO, :EQUIP_NO, ' +
            '       :TAG_NAME, :SET_TYPE, :SET_VALUE, :PRIORITY, '+
            '       :NOTIFY_TERMINAL, :NOTIFY_APP, :IS_NEED_ACK, :ALARM_DELAY, ' +
            '       :IS_VALUE_ANALOG, :IS_OUTLAMP, :DUE_DAY, :REG_DATE, :ALARM_MESSAGE, ' +
            '       :IS_ONLY_RUN, :DEADBAND)';
    Close;
    SQL.Clear;
    SQL.Add(LStr);

    if AAlarmConfigItem.AlarmSetType <> astNone then
    begin
      with AAlarmConfigItem do
      begin
        ParamByName('USER_ID').AsString  := UserID;
        ParamByName('CAT_CODE').AsString  := Category;
        ParamByName('PROJ_NO').AsString  := ProjNo;
        ParamByName('EQUIP_NO').AsString  := EngNo;
        ParamByName('TAG_NAME').AsString  := TagName;
        ParamByName('SET_TYPE').AsInteger  := Ord(AlarmSetType);

        if AlarmSetType = astDigital then
          ParamByName('SET_VALUE').AsInteger  := BoolToInt(StrToBool(SetValue))
        else
          ParamByName('SET_VALUE').AsFloat  := StrToFloat(SetValue);

        ParamByName('PRIORITY').AsInteger  := Ord(AlarmPriority);
        ParamByName('NOTIFY_TERMINAL').AsInteger  := NotifyTerminals;
        ParamByName('NOTIFY_APP').AsInteger  := NotifyApps;
        ParamByName('IS_NEED_ACK').AsInteger  := BoolToInt(NeedAck);
        ParamByName('ALARM_DELAY').AsInteger  := Delay;
        ParamByName('DEADBAND').AsInteger  := DeadBand;
        ParamByName('IS_VALUE_ANALOG').AsInteger  := BoolToInt(IsAnalog);
        ParamByName('IS_OUTLAMP').AsInteger  := BoolToInt(IsOutLamp);
        ParamByName('IS_ONLY_RUN').AsInteger  := BoolToInt(IsOnlyRun);
        ParamByName('DUE_DAY').AsInteger  := DueDay;
        ParamByName('REG_DATE').AsDateTime  := RegDate;
        ParamByName('ALARM_MESSAGE').AsString  := AlarmMessage;
      end;//with

      OraSession1.Connected := True;
      OraTransaction1.StartTransaction;
      try
        ExecSQL;

        LStr := 'Insert into HITEMS_ALARM_RECEIP_CONFIG ' +
                'VALUES(:UNIQUE_TAG_NAME, :RECEIP_ID)';
        Close;
        SQL.Clear;
        SQL.Add(LStr);
        LUniqueName := GetUniqueTagName(AAlarmConfigItem);
        LReceip := AAlarmConfigItem.Recipients;

        while LReceip <> '' do
        begin
          LUserId := strToken(LReceip,';');
          ParamByName('UNIQUE_TAG_NAME').AsString  := LUniqueName;
          ParamByName('RECEIP_ID').AsString  := LUserId;
          ExecSQL;
        end;

        OraTransaction1.Commit;
        Close;
        Result := True;
      except
        OraTransaction1.Rollback;
        Close;
        Result := False;
      end;
    end;
  end;//with query1
end;

function TDM1.ExecuteDBActionEachUpdate(
  AAlarmConfigItem: TAlarmConfigItem): boolean;
var
  LStr: string;
  i: integer;
begin
  Result := False;

  with OraQuery1 do
  begin
    //Key 값은 Update 제외
    LStr := 'Update HITEMS_ALARM_CONFIG ' +
            'SET TAG_NAME = :TAG_NAME, SET_TYPE = :SET_TYPE, SET_VALUE = :SET_VALUE, ' +
            '    PRIORITY = :PRIORITY, NOTIFY_TERMINAL = :NOTIFY_TERMINAL, ' +
            '    NOTIFY_APP = :NOTIFY_APP, IS_NEED_ACK = :IS_NEED_ACK, ALARM_DELAY = :ALARM_DELAY, ' +
            '    IS_VALUE_ANALOG = :IS_VALUE_ANALOG, IS_OUTLAMP = :IS_OUTLAMP, ' +
            '    DUE_DAY = :DUE_DAY, REG_DATE = :REG_DATE, ALARM_MESSAGE = :ALARM_MESSAGE, ' +
            '    IS_ONLY_RUN = :IS_ONLY_RUN, DEADBAND = :DEADBAND ' +
            'WHERE USER_ID = :USER_ID and CAT_CODE = :CAT_CODE and PROJ_NO = :PROJ_NO '+
            '       and EQUIP_NO = :EQUIP_NO ';
    Close;
    SQL.Clear;
    SQL.Add(LStr);

    if AAlarmConfigItem.AlarmSetType <> astNone then
    begin
      with AAlarmConfigItem do
      begin
        ParamByName('USER_ID').AsString  := UserID;
        ParamByName('CAT_CODE').AsString  := Category;
        ParamByName('PROJ_NO').AsString  := ProjNo;
        ParamByName('EQUIP_NO').AsString  := EngNo;
        ParamByName('TAG_NAME').AsString  := TagName;
        ParamByName('SET_TYPE').AsInteger  := Ord(AlarmSetType);

        if AlarmSetType = astDigital then
          ParamByName('SET_VALUE').AsInteger  := BoolToInt(StrToBool(SetValue))
        else
          ParamByName('SET_VALUE').AsFloat  := StrToFloat(SetValue);

        ParamByName('PRIORITY').AsInteger  := Ord(AlarmPriority);
        ParamByName('NOTIFY_TERMINAL').AsInteger  := NotifyTerminals;
        ParamByName('NOTIFY_APP').AsInteger  := NotifyApps;
        ParamByName('IS_NEED_ACK').AsInteger  := BoolToInt(NeedAck);
        ParamByName('ALARM_DELAY').AsInteger  := Delay;
        ParamByName('DEADBAND').AsInteger  := DeadBand;
        ParamByName('IS_VALUE_ANALOG').AsInteger  := BoolToInt(IsAnalog);
        ParamByName('IS_OUTLAMP').AsInteger  := BoolToInt(IsOutLamp);
        ParamByName('IS_ONLY_RUN').AsInteger  := BoolToInt(IsOnlyRun);
        ParamByName('DUE_DAY').AsInteger  := DueDay;
        ParamByName('REG_DATE').AsDateTime  := RegDate;
        ParamByName('ALARM_MESSAGE').AsString  := AlarmMessage;
      end;//with

      OraSession1.Connected := True;
      OraTransaction1.StartTransaction;
      try
        ExecSQL;
        OraTransaction1.Commit;
        Close;
        Result := True;
      except
        OraTransaction1.Rollback;
        Close;
        Result := False;
      end;
    end;
  end;//with query1
end;

procedure TDM1.FillInCategoryCombo(AUserId, AProjno, AEngNo: string; ACombo: TComboBox);
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select CAT_CODE from HITEMS_ALARM_CONFIG ' +
            'where USER_ID = :userid and PROJ_NO = :projno and EQUIP_NO = :equipno');

    if (AProjno <> '') and (AEngNo <> '') then
    begin
      ParamByName('projno').AsString := AProjno;
      ParamByName('equipno').AsString := AEngNo;
    end
    else
      SQL.Text := StringReplace(SQL.Text,'and PROJ_NO = :projno and EQUIP_NO = :equipno','',[rfReplaceAll]);

    Open;

    if RecordCount > 0 then
    begin
      ACombo.Items.Clear;
      ACombo.Items.Add('');

      while not eof do
      begin
        ACombo.Items.Add(FieldByName('CAT_CODE').AsString);

        Next;
      end;
    end;
  end;
end;

procedure TDM1.FillInDeptCombo(ACombo: TComboBoxInc);
var
  LIdx: integer;
begin
  with OraQuery2 do
  begin
    Close;
    SQL.Clear;  //wrkcd <> ''11'': 협력사 제외
    SQL.Add('select DEPT, DEPTNM from kx01.gtaa004 ' +
            'where DEPTNM IS NOT NULL AND wrkcd <> ''11'' and DEPT like ''K%'' ' +
            'GROUP BY DEPT, DEPTNM order by dept ');
    Open;

    if RecordCount > 0 then
    begin
      ACombo.Items.BeginUpdate;

      try
        ACombo.Items.Clear;

        ACombo.Items.Add('');
        LIdx := ACombo.Items.Add('임원');
        ACombo.Hint := ACombo.Hint + 'A;';

        while not eof do
        begin
          ACombo.Items.Add(FieldByName('DEPTNM').AsString);
          ACombo.Hint := ACombo.Hint + (FieldByName('DEPT').AsString) + ';';
          Next;
        end;
      finally
        ACombo.Items.EndUpdate;
      end;
    end;
  end;
end;

procedure TDM1.FillInPartCombo(ADeptCode: string; ACombo: TComboBoxInc);
var
  i,j: integer;
begin
  with OraQuery2 do
  begin
    Close;
    SQL.Clear;
    if ADeptCode = 'A' then
      SQL.Add('select RESNM from kx01.gtaa004 ' +
              'where DEPT like :param1 ' +
              'GROUP BY RESNM ')
    else
      SQL.Add('select PARTNM, PARTCD from kx01.gtaa004 ' +
              'where DEPTNM IS NOT NULL AND DEPT = :param1 ' +
              'GROUP BY PARTNM, PARTCD ');

    if ADeptCode <> '' then
    begin
      ParamByName('param1').AsString := ADeptCode;

      if ADeptCode = 'A' then
        ParamByName('param1').AsString := ADeptCode + 'K%';
    end
    else
      SQL.Text := StringReplace(SQL.Text,'AND DEPT = :param1','',[rfReplaceAll]);

    Open;

    if RecordCount > 0 then
    begin
      ACombo.Items.Clear;
      ACombo.Items.Add('');
      ACombo.Hint := '';

      while not eof do
      begin
        if ADeptCode = 'A' then
        begin
          if FieldByName('RESNM').AsString <> '' then
          begin
            ACombo.Items.Add(FieldByName('RESNM').AsString);
          end;
        end
        else
        begin
//        if FieldByName('PARTNM').AsString <> cb_dept.Text then
          if FieldByName('PARTNM').AsString <> '' then
          begin
            ACombo.Items.Add(FieldByName('PARTNM').AsString);
            ACombo.Hint := ACombo.Hint + FieldByName('PARTCD').AsString + ';';
          end;
        end;

        Next;
      end;//while

//      ACombo.Items.Sort;
//      j := 1;
//
//      for i := 0 to ACombo.Items.Count - 1 do
//      begin
//        if ACombo.Items.Strings[i] <> '' then
//        begin
//          FPartCodeList.Add(IntToStr(j));
//          Inc(j);
//        end
//        else
//          FPartCodeList.Add(IntToStr(-1));
//      end;
    end;
  end;
end;

procedure TDM1.FillInUserCombo(ADeptCode, APartCode: string; ACombo: TComboBoxInc);
begin
  try
    with OraQuery2 do
    begin
      Close;
      SQL.Clear;
      if ADeptCode = 'A' then
        SQL.Add('SELECT EMPNO, EMPNM FROM kx01.gtaa004 ' +
              'WHERE DEPT LIKE :param1 AND STATNM = ''재직''' //''K%''  AND EMPNO = ''A379042''
        )
      else
        SQL.Add('select EMPNO, EMPNM from kx01.gtaa004 ' +
              'where DEPTNM IS NOT NULL AND DEPT = :param1 AND PARTCD = :param2 ' + //''K%''  AND EMPNO = ''A379042''
              'AND STATNM = ''재직'' order by EMPNO'
        );

      if ADeptCode <> '' then
      begin
        ParamByName('param1').AsString := ADeptCode;

        if ADeptCode = 'A' then
          ParamByName('param1').AsString := ADeptCode + 'K%';
      end
      else
        SQL.Text := StringReplace(SQL.Text,'AND DEPT = :param1','',[rfReplaceAll]);

      if APartCode <> '' then
      begin
        ParamByName('param2').AsString := APartCode;
      end
      else
        SQL.Text := StringReplace(SQL.Text,'AND PARTCD = :param2','',[rfReplaceAll]);

      Open;

      if RecordCount > 0 then
      begin
        ACombo.Items.Clear;
        ACombo.Items.Add('');
        ACombo.Hint := '';

        while not eof do
        begin
          ACombo.Items.Add(FieldByName('EMPNM').AsString);
          ACombo.Hint := ACombo.Hint + FieldByName('EMPNO').AsString + ';';
          Next;
        end;
      end;//if
    end;
  finally
  end;
end;

procedure TDM1.FillInUserGrid(ADeptCode, APartCode: string; AGrid: TNextGrid);
var
  r:integer;
begin
  try
    with OraQuery2 do
    begin
      Close;
      SQL.Clear;
      if ADeptCode = 'A' then
        SQL.Add('SELECT EMPNO, EMPNM, GRDNM FROM kx01.gtaa004 ' +
              'WHERE DEPT LIKE :param1 AND STATNM = ''재직''' //''K%''  AND EMPNO = ''A379042''
        )
      else
        SQL.Add('select EMPNO, EMPNM, GRDNM from kx01.gtaa004 ' +
              'where DEPTNM IS NOT NULL AND DEPT = :param1 AND PARTCD = :param2 ' + //''K%''  AND EMPNO = ''A379042''
              'AND STATNM = ''재직'' order by EMPNO'
        );

      if ADeptCode <> '' then
      begin
        ParamByName('param1').AsString := ADeptCode;

        if ADeptCode = 'A' then
          ParamByName('param1').AsString := ADeptCode + 'K%';
      end
      else
        SQL.Text := StringReplace(SQL.Text,'AND DEPT = :param1','',[rfReplaceAll]);

      if APartCode <> '' then
      begin
        ParamByName('param2').AsString := APartCode;
      end
      else
        SQL.Text := StringReplace(SQL.Text,'AND PARTCD = :param2','',[rfReplaceAll]);

      Open;

      if RecordCount > 0 then
      begin
        AGrid.ClearRows;

        while not eof do
        begin
          r := AGrid.AddRow;
          AGrid.CellByName['UserId',r].AsString := FieldByName('EMPNO').AsString;
          AGrid.CellByName['UserName',r].AsString := FieldByName('EMPNM').AsString;
          AGrid.CellByName['UserGrade',r].AsString := FieldByName('GRDNM').AsString;
          Next;
        end;
      end;//if
    end;
  finally
  end;
end;

procedure TDM1.GetAlarmConfigFromDBPerEngine(AQuery: TOraQuery;
  AUniqueEngine: string);
begin
  with AQuery do
  begin
    Close;
    SQL.Clear;  //DUE_DAY = -1 이면 설정 사용 안함(알람 모니터링에서 제외)
    SQL.Add('SELECT a.*, b.table_name, b.ENG_TYPE FROM HITEMS_ALARM_CONFIG a, MON_TABLES b ' +
            'WHERE PROJ_NO = :projno and EQUIP_NO = :engno and DUE_DAY <> -1 ' +
            '       and a.proj_no = b.eng_projno and a.equip_no = b.eng_no ' +
            'ORDER BY a.proj_no, a.equip_no, a.tag_name' );
    ParamByName('projno').AsString := GetProjNo(AUniqueEngine);
    ParamByName('engno').AsString := GetEngNo(AUniqueEngine);

    Open;
  end;
end;

procedure TDM1.GetAlarmConfigFromDBPerEngineNAssign2Collect(AUniqueEngine: string;
  AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict; AEP: TEngineParameterCollect);
var
  LOraQuery: TOraQuery;
  LStr: string;
begin
  LOraQuery := TOraQuery.Create(nil);
  LOraQuery.Session := OraSession1;
  try
    //엔진 조회(projno;engno)
    GetAlarmConfigFromDBPerEngine(LOraQuery, AUniqueEngine);
    //조회한 엔진을 FAlarmConfign 및 FAlarmConfigDict에 저장
    AssignAlarmConfig2Collect(LOraQuery, AAlarmConfig, AAlarmConfigDict, AEP, True);
  finally
    LOraQuery.Free;
  end;
end;

procedure TDM1.GetAlarmConfigFromDBPerUser(AQuery: TOraQuery; AUserId, ACat: string);
begin
  with AQuery do
  begin
    Close;
    SQL.Clear;  //DUE_DAY = -1 이면 설정 사용 안함(알람 모니터링에서 제외)
    SQL.Add('SELECT a.*, b.table_name, b.ENG_TYPE FROM HITEMS_ALARM_CONFIG a, MON_TABLES b ' +
            'WHERE USER_ID = :userid and CAT_CODE = :cat and DUE_DAY <> -1 ' +
            '       and a.proj_no = b.eng_projno and a.equip_no = b.eng_no ' +
            'ORDER BY a.proj_no, a.equip_no, a.tag_name' );
    ParamByName('userid').AsString := AUserId;
    ParamByName('cat').AsString := ACat;

    Open;
  end;
end;

procedure TDM1.GetAlarmConfigFromDBPerUserNAssign2Collect(AUserId, ACat: string;
  AAlarmConfig: TAlarmConfig; AAlarmConfigDict: TAlarmConfigDict;
  AEP: TEngineParameterCollect);
var
  LOraQuery: TOraQuery;
  LStr: string;
begin
  LOraQuery := TOraQuery.Create(nil);
  LOraQuery.Session := OraSession1;
  try
    //User별 알람 설정 조회
    GetAlarmConfigFromDBPerUser(LOraQuery, AUserId, ACat);
    //조회한 엔진을 FAlarmConfign 및 FAlarmConfigDict에 저장
    AssignAlarmConfig2Collect(LOraQuery, AAlarmConfig, AAlarmConfigDict, AEP, True);
  finally
    LOraQuery.Free;
  end;
end;

procedure TDM1.GetAlarmConfigList(AUserId, ACatCode, AProjNo, AEquipNo: string;
  out ATagNames: TAlarmConfigCollect);
var
  LAlarmConfigItem: TAlarmConfigItem;
  LStr: string;
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    LStr := 'select * from HITEMS_ALARM_CONFIG ' +
            'where USER_ID = :userid and CAT_CODE = :catcode ' +
            '      and PROJ_NO = :projno and EQUIP_NO = :equipno ' +
            'ORDER BY proj_no, equip_no, tag_name';
    SQL.Add(LStr);
    ParamByName('userid').AsString := UpperCase(AUserId);

    if ACatCode <> '' then
      ParamByName('catcode').AsString := ACatCode
    else
      SQL.Text := StringReplace(SQL.Text,'and CAT_CODE = :catcode','',[rfReplaceAll]);

    if AProjNo <> '' then
    begin
      ParamByName('projno').AsString := AProjNo;
      ParamByName('equipno').AsString := AEquipNo;
    end
    else
    begin
      SQL.Text := StringReplace(SQL.Text,'and PROJ_NO = :projno and EQUIP_NO = :equipno','',[rfReplaceAll]);
    end;

    Open;

//    if RecordCount > 0 then
      ATagNames.Clear;

    while not eof do
    begin
      LAlarmConfigItem := ATagNames.Add;
      LAlarmConfigItem.UserID := FieldByName('USER_ID').AsString;
      LAlarmConfigItem.Category := FieldByName('CAT_CODE').AsString;
      LAlarmConfigItem.ProjNo := FieldByName('PROJ_NO').AsString;
      LAlarmConfigItem.EngNo := FieldByName('EQUIP_NO').AsString;
      LAlarmConfigItem.TagName := FieldByName('TAG_NAME').AsString;
      LAlarmConfigItem.AlarmSetType := tAlarmSetType(FieldByName('SET_TYPE').AsInteger);

      if LAlarmConfigItem.AlarmSetType = astDigital then
        LAlarmConfigItem.SetValue := IntToStr(FieldByName('SET_VALUE').AsInteger)
      else
        LAlarmConfigItem.SetValue := FloatToStr(FieldByName('SET_VALUE').AsFloat);

      LAlarmConfigItem.AlarmPriority := TAlarmPriority(FieldByName('PRIORITY').AsInteger);
      LAlarmConfigItem.NotifyTerminals := FieldByName('NOTIFY_TERMINAL').AsInteger;
      LAlarmConfigItem.NotifyApps := FieldByName('NOTIFY_APP').AsInteger;
      LAlarmConfigItem.NeedAck := Boolean(FieldByName('IS_NEED_ACK').AsInteger);
      LAlarmConfigItem.Delay := FieldByName('ALARM_DELAY').AsInteger;
      LAlarmConfigItem.DeadBand := FieldByName('DEADBAND').AsInteger;
      LAlarmConfigItem.IsAnalog := Boolean(FieldByName('IS_VALUE_ANALOG').AsInteger);
      LAlarmConfigItem.IsOutLamp := Boolean(FieldByName('IS_OUTLAMP').AsInteger);
      LAlarmConfigItem.IsOnlyRun := Boolean(FieldByName('IS_ONLY_RUN').AsInteger);
      LAlarmConfigItem.DueDay := FieldByName('DUE_DAY').AsInteger;
      LAlarmConfigItem.RegDate := FieldByName('REG_DATE').AsDateTime;
      LAlarmConfigItem.AlarmMessage := FieldByName('ALARM_MESSAGE').AsString;
      LAlarmConfigItem.Recipients := GetRecipients(GetUniqueTagName(LAlarmConfigItem));

      Next;
    end;
  end;
end;

procedure TDM1.GetAlarmHistoryFromDB4NonReleased(ATableName: string;
  AAlarmConfigCollect: TAlarmConfigCollect);
var
  LStr: string;
  LAlarmListRecord: TAlarmListRecord;
  LAlarmConfigItem: TAlarmConfigItem;
begin
  with OraQuery1 do
  begin
    LStr := 'Select a.*, b.ENG_TYPE from TBACS.' + ATableName + ' a, MON_TABLES b ' +
            ' Where ALARM_TIME_OUT = :ALARM_TIME_OUT ' +
            ' and a.proj_no = b.eng_projno and a.equip_no = b.eng_no';
    Close;
    SQL.Clear;
    SQL.Add(LStr);
    ParamByName('ALARM_TIME_OUT').AsDateTime  := 0;
    Open;

    while not eof do
    begin
      with LAlarmListRecord do
      begin
        FUserID :=           FieldByName('USER_ID').AsString;
        FCategory :=         FieldByName('CAT_CODE').AsString;
        FProjNo :=           FieldByName('PROJ_NO').AsString;
        FEngNo :=            FieldByName('EQUIP_NO').AsString;
        FTagName :=          FieldByName('TAG_NAME').AsString;
        FAlarmSetType :=     TAlarmSetType(FieldByName('SET_TYPE').AsInteger);
        FIssueDateTime :=    FieldByName('ALARM_TIME_IN').AsDateTime;
        FReleaseDateTime :=  FieldByName('ALARM_TIME_OUT').AsDateTime;
        FAcknowledgedTime := FieldByName('ALARM_TIME_ACK').AsDateTime;
        FSuppressedTime :=   FieldByName('ALARM_TIME_SUP').AsDateTime;
        FIsOutLamp :=        IntToBool(FieldByName('IS_OUTLAMP').AsInteger);
        FIsOnlyRun :=        IntToBool(FieldByName('IS_ONLY_RUN').AsInteger);
        FAlarmPriority :=    TAlarmPriority(FieldByName('PRIORITY').AsInteger);
        FNeedAck :=          IntToBool(FieldByName('NEED_ACK').AsInteger);

        if FAlarmSetType = astDigital then
          FSetValue :=         FieldByName('SET_VALUE').AsString
        else
          FSetValue :=         FloatToStr(FieldByName('SET_VALUE').AsFloat);

        FSensorValue :=      FloatToStr(FieldByName('REAL_VALUE').AsFloat);
        FAlarmMessage :=     FieldByName('ALARM_MSG').AsString;
        FDelay :=            FieldByName('ALARM_DELAY').AsInteger;
        FDeadBand :=         FieldByName('DEADBAND').AsInteger;
        FNotifyApps :=       FieldByName('NOTIFY_APP').AsInteger;

        LAlarmConfigItem := AAlarmConfigCollect.Add;
        LAlarmConfigItem.EngType := FieldByName('ENG_TYPE').AsString;
        LAlarmConfigItem.AlarmHistoryTableName := ATableName;
        AlarmListRecord2AlarmConfigItem(LAlarmListRecord, LAlarmConfigItem);
      end;

      Next;
    end;
  end;
end;

function TDM1.getContent(url: String): String;
var
  LIdHTTP: TIdHTTP;
begin
  LIdHTTP := TIdHTTP.Create(nil);
  LIdHTTP.HandleRedirects := True;
  try
    try
//      Result := LIdHTTP.Get(url);
      LIdHTTP.Get(url);
    except

    end;
  finally
    LIdHTTP.Free;
  end;
end;

function TDM1.GetDeptNTeamCodeFromUserId(AUserid: string): string;
var
  LOraQuery: TOraQuery;
begin
  Result := '';
  LOraQuery := TOraQuery.Create(nil);
  LOraQuery.Session := OraSession2;
  try
    with LOraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select DEPTNM, DEPT, PARTNM, PARTCD from kx01.gtaa004 ' +
              'where EMPNO = :EMPNO');
      ParamByName('EMPNO').AsString := AUserid;
      Open;

      if RecordCount > 0 then
      begin
        Result := FieldByName('DEPTNM').AsString + ';' + FieldByName('DEPT').AsString + ';' +
          FieldByName('PARTNM').AsString + ';' + FieldByName('PARTCD').AsString;
      end;
    end;
  finally
    LOraQuery.Free;
  end;
end;

procedure TDM1.GetEngineListFromPlant(APlantName: string; out AEngList: TAlarmConfigCollect);
var
  LAlarmConfigItem: TAlarmConfigItem;
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from mon_tables where loc_code = (select loc_code from TBACS.HITEMS_LOC_CODE where loc_name = :Plant)');

    if APlantName = '' then
      SQL.Text := StringReplace(SQL.Text,'where loc_code = (select loc_code from TBACS.HITEMS_LOC_CODE where loc_name = :Plant)','',[rfReplaceAll])
    else
      ParamByName('Plant').AsString := APlantName;
    Open;

    if RecordCount > 0 then
      AEngList.Clear;

    while not eof do
    begin
      LAlarmConfigItem := AEngList.Add;
      LAlarmConfigItem.ProjNo := FieldByName('ENG_PROJNO').AsString;
      LAlarmConfigItem.EngNo := FieldByName('ENG_NO').AsString;
      LAlarmConfigItem.EngType := FieldByName('ENG_TYPE').AsString;

      //Default Config Value
      SetDefaultConfigValue(LAlarmConfigItem);

      Next;
    end;
  end;
end;

procedure TDM1.GetEngineMonListFromUser(AUserId: string;
  out AEngList: TStringList);
var
  LUniqueEng: string;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;  //DUE_DAY = -1 이면 설정 사용 안함(알람 모니터링에서 제외)
    SQL.Add('SELECT a.*, b.table_name, b.ENG_TYPE FROM HITEMS_ALARM_CONFIG a, MON_TABLES b ' +
            'WHERE USER_ID = :userid and DUE_DAY <> -1 ' +
            '       and a.proj_no = b.eng_projno and a.equip_no = b.eng_no' );
    ParamByName('userid').AsString := AUserId;

    Open;

    while not eof do
    begin
      LUniqueEng := GetUniqueEngName(FieldByName('PROJ_NO').AsString, FieldByName('EQUIP_NO').AsString);

      if AEngList.IndexOf(LUniqueEng) = -1 then
        AEngList.Add(LUniqueEng);

      Next;
    end;
  end;
end;

function TDM1.GetEngineParameterSetValue(AProjNo, AEngNo, ATagName: string;
  ASetType: TAlarmSetType; AEP: TEngineParameterCollect): string;
var
  i: integer;
begin
  for i := 0 to AEP.Count - 1 do
  begin
    if (AEP.Items[i].ProjNo = AProjNo) and
      (AEP.Items[i].EngNo = AEngNo) and
      (AEP.Items[i].TagName = ATagName) then
    begin
      case ASetType of
        astLoLo: Result := FloatToStr(AEP.Items[i].MinFaultValue);
        astLo: Result := FloatToStr(AEP.Items[i].MinAlarmValue);
        astHiHi: Result := FloatToStr(AEP.Items[i].MaxFaultValue);
        astHi: Result := FloatToStr(AEP.Items[i].MaxAlarmValue);
      end;
    end;
  end;
end;

function TDM1.GetEngineRPM(ATableName, ARpmField: string): integer;
var
  LOraQuery: TOraQuery;
  LRpm: integer;
begin
  LOraQuery := TOraQuery.Create(nil);
  LOraQuery.Session := OraSession1;
  try
    with LOraQuery do
    begin
      SQL.add('SELECT DATASAVEDTIME, ' + ARpmField + ' FROM TBACS.' + ATablename +
              ' WHERE datasavedtime = ( select max(datasavedtime) from TBACS.' + ATablename + ' ) ');
      Open;

      if RecordCount > 0 then
      begin
        LRpm := FieldByName(ARpmField).Asinteger;

        if (LRpm > 0) and (LRpm < 3000) then
          Result := LRpm;
      end;
    end;
  finally
    LOraQuery.Free;
  end;
end;

procedure TDM1.GetEngParamDataFromDB(ATableName: string; AEP: TEngineParameterCollect);
var
  LOraQuery: TOraQuery;
  LRpm: integer;
  LProjNo, LEngNo, LTablename, LSavedTime: string;
  i, LIdx: integer;
begin
  LOraQuery := TOraQuery.Create(nil);
  LOraQuery.Session := OraSession1;
  try
    with LOraQuery do
    begin
      LProjNo := strToken(ATableName, ';');
      LEngNo := strToken(ATableName, ';');
      LTablename := strToken(ATablename, ';');
      LIdx := -1;

      for i := 0 to AEP.Count - 1 do
      begin
        if (AEP.Items[i].ProjNo = LProjNo) and (AEP.Items[i].EngNo = LEngNo) then
        begin
          LIdx := i;
          break;
        end;
      end;

      if (LIdx > -1) and (LTablename <> '') then
      begin
        LTableName := StringReplace(LTableName,'MEASURE_DATA','RECENT_DATA',[rfReplaceAll]);
        SQL.add('SELECT * FROM TBACS.' + LTablename);// +
//                ' WHERE datasavedtime = ( select max(datasavedtime) from TBACS.' + LTablename + ' ) ');
        Open;

        if RecordCount > 0 then
        begin
//          LSavedTime := LeftStr(FieldByName('DATASAVEDTIME').AsString, 14);//YYYYMMDDHHMMSS
//          LTablename := FormatDateTime('yyyymmddhhmmss', IncSecond(now, -5));
//          if LSavedTime > LTablename then
//          begin
            for i := 1 to Fields.Count - 1 do
            begin
              AEP.Items[Lidx].Value := Fields.Fields[i].AsString;
              Inc(LIdx);
            end;
//          end;
        end;
      end;
    end;
  finally
    LOraQuery.Free;
  end;
end;

procedure TDM1.GetFieldNameListFromDB(ATableName: string);
begin
  FFieldNameList.Clear;
  FFieldTypeList.Clear;

  if ATableName <> '' then
  begin
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select column_name, Data_Type, column_id from all_tab_columns ' +
              'where owner = ''TBACS'' AND table_name = '''+ATableName+''' ' +
              'order by column_id');
      Open;

      if RecordCount > 0 then
      begin
        while not eof do
        begin
          FFieldNameList.Add(FieldByName('column_name').AsString);
          FFieldTypeList.Add(FieldByName('Data_Type').AsString);
          Next;
        end;
      end;
    end;
  end;

end;

function TDM1.GetPlantList: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select distinct(loc_name) from TBACS.HITEMS_LOC_CODE where loc_grp is null and loc_lv = 0');
//    ParamByName('CODE_TYPE').AsString := aCodeType;
    Open;

    while not eof do
    begin
      LValue := StringToUTF8(FieldByName('LOC_NAME').AsString);
      LDynArr.Add(LValue);

      Next;
    end;
  end;
end;

function TDM1.GetRecipients(AUniqueTagName: string): string;
var
  LStr: string;
  LOraQuery: TOraQuery;
begin
  LOraQuery := TOraQuery.Create(nil);
  LOraQuery.Session := OraSession1;
  try
    with LOraQuery do
    begin
      LStr := 'Select * from HITEMS_ALARM_RECEIP_CONFIG ' +
              ' Where UNIQUE_TAG_NAME = :UNIQUE_TAG_NAME ';
      Close;
      SQL.Clear;
      SQL.Add(LStr);
      ParamByName('UNIQUE_TAG_NAME').AsString := AUniqueTagName;
      Open;

      Result := '';
      while not eof do
      begin
        Result := Result + FieldByName('RECEIP_ID').AsString + ';';
        Next;
      end;
    end;
  finally
    LOraQuery.Free;
  end;
end;

procedure TDM1.GetServerInfo;
var
  LOraQuery: TOraQuery;
  LStr: string;
begin
  LOraQuery := TOraQuery.Create(nil);
  LOraQuery.Session := OraSession1;
  try
    with LOraQuery do
    begin
      LStr := 'select * from HITEMS_SERVER_INFO '+
              ' where APP_CODE = :APP_CODE';
      Close;
      SQL.Clear;
      SQL.Add(LStr);

      ParamByName('APP_CODE').AsString := 'AMSSERVER';
      Open;

      if RecordCount > 0 then
      begin
        FServerInfo.AppCode := FieldByName('APP_CODE').AsString;
        FServerInfo.AppName := FieldByName('APP_NAME').AsString;
        FServerInfo.IpAddr := FieldByName('IPADDR').AsString;
        FServerInfo.PortNo := FieldByName('PORTNO').AsString;
      end;
    end;
  finally
    LOraQuery.Free;
  end;
end;

procedure TDM1.GetTagListFromEngine(AProjNo, AEngNo: string;
  out ATagList: TAlarmConfigEPCollect);
var
  LEP: TEngineParameterCollect;
  LEPConfigItem: TAlarmConfigEPItem;
  i: integer;
begin
  LEP := TEngineParameterCollect.Create(TEngineParameterItem);
  try
    SelectEngParamFileFromDB(AProjNo, AEngNo, LEP);
    ATagList.Clear;

    for i := 0 to LEP.Count - 1 do
    begin
      LEPConfigItem := ATagList.Add;

      LEPConfigItem.ProjNo := LEP.EngProjNo;
      LEPConfigItem.EngNo := LEP.EngNo;
      LEPConfigItem.TagName := LEP.Items[i].TagName;
      LEPConfigItem.Description := LEP.Items[i].Description;
      LEPConfigItem.FFUnit := LEP.Items[i].FFUnit;
      LEPConfigItem.IsAnalog := LEP.Items[i].Alarm;
      LEPConfigItem.SensorType := LEP.Items[i].SensorType;
    end;
  finally
    LEP.Free;
  end;
end;

function TDM1.GetUniqueTagName(AAlarmConfigItem: TAlarmConfigItem;
  AIsPerUser: Boolean): string;
var
  LTagName: string;
begin
  //TagName에 ProjNo가 존재하면
  if Pos(AAlarmConfigItem.ProjNo, AAlarmConfigItem.TagName) > 0 then
    LTagName := AAlarmConfigItem.TagName
  else
    LTagName := AAlarmConfigItem.ProjNo + '_' +
            AAlarmConfigItem.EngNo + '_' + AAlarmConfigItem.TagName;

  if AIsPerUser then
    Result := AAlarmConfigItem.UserID + '_' +
            AAlarmConfigItem.Category + '_' +
            LTagName + '_' +  FAlarmSetTypeNames[AAlarmConfigItem.AlarmSetType]
//            TRttiEnumerationType.GetName<TAlarmSetType>(AAlarmConfigItem.AlarmSetType)
  else
  begin
    Result := LTagName + '_' + FAlarmSetTypeNames[AAlarmConfigItem.AlarmSetType]
//            TRttiEnumerationType.GetName<TAlarmSetType>(AAlarmConfigItem.AlarmSetType)
  end;
end;

function TDM1.Get_User_Info(aUserId: String): TUserInfo;
begin
  try
    FillChar(Result, SizeOf(Result), 0);

    with OraQuery2 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM kx01.gtaa004 ' +
              'WHERE EMPNO = :param1 AND STATNM = ''재직'''); //''K%''  AND EMPNO = ''A379042''
      ParamByName('param1').AsString := aUserId;
      Open;

      if RecordCount > 0 then
      begin
        with Result do
        begin
          UserID := FieldByName('EMPNO').AsString;
          UserName := FieldByName('EMPNM').AsString;
          Dept_Cd := FieldByName('DEPT').AsString;
          DeptName := FieldByName('DEPTNM').AsString;
          TeamNo := FieldByName('PARTCD').AsString;
          TeamName := FieldByName('PARTNM').AsString;
          Grade := FieldByName('GRDNM').AsString;
          JobPosition := FieldByName('RESNM').AsString;
        end;
      end;//if
    end;
  finally
  end;
end;

procedure TDM1.InitUserInfo(aUserId: String);
begin
  FUserInfo := Get_User_Info(aUserId);
end;

procedure TDM1.SaveAlarm2HistoryDB(ATableName: string; const ARecord: TAlarmListRecord);
var
  i, LSaveCnt: integer;
  LStr: string;
begin
  LSaveCnt := 0;

  with OraQuery1 do
  begin    //History DB에는 DeadBand가 저장 안됨
    LStr := 'Insert into TBACS.' + ATableName +
            ' VALUES(:USER_ID, :CAT_CODE, :PROJ_NO, :EQUIP_NO, ' +
            '       :TAG_NAME, :SET_TYPE, :ALARM_TIME_IN, :ALARM_TIME_OUT, ' +
            '       :ALARM_TIME_ACK, :ALARM_TIME_SUP, :IS_OUTLAMP,  :PRIORITY, :IS_NEED_ACK, ' +
            '       :SET_VALUE, :REAL_VALUE, :ALARM_MESSAGE, :ALARM_DELAY, :NOTIFY_APP, ' +
            '       :IS_ONLY_RUN)';
    Close;
    SQL.Clear;
    SQL.Add(LStr);

    if ATableName <> '' then
    begin
      with TAlarmListRecord(ARecord) do
      begin
        ParamByName('USER_ID').AsString  := FUserID;
        ParamByName('CAT_CODE').AsString  := FCategory;
        ParamByName('PROJ_NO').AsString  := FProjNo;
        ParamByName('EQUIP_NO').AsString  := FEngNo;
        ParamByName('TAG_NAME').AsString  := FTagName;
        ParamByName('SET_TYPE').AsInteger  := Ord(FAlarmSetType);
        ParamByName('ALARM_TIME_IN').AsDateTime  := FIssueDateTime;
        ParamByName('ALARM_TIME_OUT').AsDateTime  := FReleaseDateTime;
        ParamByName('ALARM_TIME_ACK').AsDateTime  := FAcknowledgedTime;
        ParamByName('ALARM_TIME_SUP').AsDateTime  := FSuppressedTime;
        ParamByName('IS_OUTLAMP').AsInteger  := BoolToInt(FIsOutLamp);
        ParamByName('IS_ONLY_RUN').AsInteger  := BoolToInt(FIsOnlyRun);
        ParamByName('PRIORITY').AsInteger  := Ord(FAlarmPriority);
        ParamByName('IS_NEED_ACK').AsInteger  := BoolToInt(FNeedAck);

        if FAlarmSetType = astDigital then
          ParamByName('SET_VALUE').AsInteger  := BoolToInt(StrToBool(FSetValue))
        else
          ParamByName('SET_VALUE').AsFloat  := StrToFloat(FSetValue);

        ParamByName('REAL_VALUE').AsFloat  := StrToFloat(FSensorValue);
        ParamByName('ALARM_MESSAGE').AsString  := FAlarmMessage;
        ParamByName('ALARM_DELAY').AsInteger  := FDelay;
        ParamByName('NOTIFY_APP').AsInteger  := FNotifyApps;
      end;//with

      OraTransaction1.StartTransaction;
      try
        ExecSQL;
        inc(LSaveCnt);
        OraTransaction1.Commit;
//        ShowMsg(IntToStr(LSaveCnt) + '건의 Item을 DB에 저장 하였습니다');
      except
        OraTransaction1.Rollback;
      end;
    end;//if
  end;// with
end;

function TDM1.SaveAlarmConfigList2DB(ATagNames: string):TStringList;
var
  LAlarmConfigCollect: TAlarmConfigCollect;
  LAlarmConfigItem: TAlarmConfigItem;
  LStr, LToken: string;
  i,j: integer;
  V1: variant;
  LRawUTF8: RawUTF8;
  LRawUTF8DynArray: TAlarmListRecords;
  LDynArr: TVariantDynArray;
begin
  Result := TStringList.Create;
  LAlarmConfigCollect := TAlarmConfigCollect.Create(TAlarmConfigItem);
  LAlarmConfigCollect.DBAction := 'all';
  Result := TStringList.Create;
  try
    LRawUTF8 := StringToUTF8(ATagNames);
    LDynArr := JSONToVariantDynArray(LRawUTF8);
//    DynArrayLoadJSON(LRawUTF8DynArray, @LRawUTF8[1],TypeInfo(TAlarmListRecords));
    for i := Low(LDynArr) to High(LDynArr) do
    begin
      v1 := _JSON(LDynArr[i]);
      LAlarmConfigItem := LAlarmConfigCollect.Add;
      LAlarmConfigItem.UserID := V1.UserID;
      LAlarmConfigItem.Category := V1.Category;
      LAlarmConfigItem.ProjNo := V1.ProjNo;
      LAlarmConfigItem.EngNo := V1.EngNo;
      LAlarmConfigItem.TagName := V1.TagName;
      LAlarmConfigItem.AlarmSetType := V1.AlarmSetType;
      LAlarmConfigItem.SetValue := V1.SetValue;
      LAlarmConfigItem.AlarmPriority := apWarning;//V1.AlarmPriority;
      LAlarmConfigItem.NotifyTerminals := V1.NotifyTerminals;
      LAlarmConfigItem.NotifyApps := V1.NotifyApps;
      LAlarmConfigItem.NeedAck := V1.NeedAck;
      LAlarmConfigItem.Delay := V1.Delay;
      LAlarmConfigItem.DeadBand := V1.DeadBand;
      LAlarmConfigItem.IsAnalog := V1.IsAnalog;
      LAlarmConfigItem.IsOutLamp := V1.IsOutLamp;
      LAlarmConfigItem.IsOnlyRun := V1.IsOnlyRun;
      LAlarmConfigItem.DueDay := V1.DueDay;
      LAlarmConfigItem.RegDate := now;//V1.RegDate;
      LAlarmConfigItem.AlarmMessage := V1.AlarmMessage;
      LAlarmConfigItem.EngType := V1.EngType;
      LAlarmConfigItem.DBAction := V1.DBAction;
      LAlarmConfigItem.Recipients := V1.Recipients;

      LToken := V1.UserID + ';' + V1.Category + ';' + V1.ProjNo + ';' + V1.EngNo;

      if Result.IndexOf(LToken) = -1 then
        Result.Add(LToken);
    end;

    SaveAlarmConfigList2DB(LAlarmConfigCollect);
  finally
    LAlarmConfigCollect.Free;
  end;
end;

procedure TDM1.SelectEngParamFileFromDB(AProjNo, AEngNo: string; out AEP: TEngineParameterCollect);
var
  lms: TStringStream;
  LEP: TEngineParameter;
  LStr: RawUTF8;
  LSuccessed: Boolean;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM MON_TABLES ' +
            'WHERE ENG_PROJNO = :projno and ENG_NO = :engno ');
    ParamByName('projno').AsString     := AProjNo;
    ParamByName('engno').AsString      := AEngNo;
    Open;

    if RecordCount > 0 then
    begin
      lms := TStringStream.Create;
      LEP := TEngineParameter.Create(nil);
      try
        (FieldByName('ENG_PARAMETER') as TBlobField).SaveToStream(lms);

        if lms.Size > 0 then
        begin
          LStr := StringToUTF8(lms.DataString);
          JSONToObject(LEP, PUTF8Char(LStr), LSuccessed);

          if LSuccessed then
            CopyObject(LEP.EngineParameterCollect, AEP);
        end;
      finally
        FreeAndNil(lms);
        FreeAndNil(LEP);
      end;
    end;
  end;
end;

function TDM1.SaveAlarmConfigList2DB(ATagNames: TAlarmConfigCollect):TStringList;
var
  LAlarmConfigItem: TAlarmConfigItem;
  LStr, LAction: string;
  i, LSaveCnt, LNoneCnt: integer;
begin
  LAction := System.SysUtils.UpperCase(ATagNames.DBAction);

  if LAction = 'ALL' then  //Delete & Insert
  begin
    ExecuteDBActionAll(ATagNames);
  end
  else
  if LAction = 'INSERT' then
  begin
    ExecuteDBActionAllInsert(ATagNames);
  end
  else
  if LAction = 'UPDATE' then
  begin
    ExecuteDBActionAllUpdate(ATagNames);
  end
  else
  if LAction = 'DELETE' then
  begin
    ExecuteDBActionAllDelete(ATagNames);
  end
  else
  if LAction = 'EACH' then
  begin
    ExecuteDBActionEach(ATagNames);
  end;
end;

procedure TDM1.SetDefaultConfigValue(var AAlarmConfigItem: TAlarmConfigItem);
begin
  AAlarmConfigItem.AlarmPriority := apWarning;
  AAlarmConfigItem.NotifyTerminals := NotifyTerminalSetToInteger([ntDesktop, ntMobile]);
  AAlarmConfigItem.NotifyApps := NotifyAppSetToInteger([naSMS, naNote]);
  AAlarmConfigItem.NeedAck := False;
  AAlarmConfigItem.Delay := -1;
  AAlarmConfigItem.DeadBand := 0;
  AAlarmConfigItem.IsAnalog := True;
  AAlarmConfigItem.IsOutLamp := False;
  AAlarmConfigItem.IsOnlyRun := True;
  AAlarmConfigItem.DueDay := 0;
  AAlarmConfigItem.RegDate := now;
  AAlarmConfigItem.AlarmMessage := '';
end;

procedure TDM1.ShowMsg(AMsg: string);
begin
  if FIsClientMode then
    ShowMessage(AMsg);
end;

procedure TDM1.UpdateAlarmAckTime2HistoryDB(const AAlarmConfigItem: TAlarmConfigItem);
var
  i, LSaveCnt: integer;
  LStr: string;
begin
  LSaveCnt := 0;

  with OraQuery1 do
  begin
    LStr := 'Update TBACS.' + AAlarmConfigItem.AlarmHistoryTableName +
            ' Set ALARM_TIME_ACK = :ALARM_TIME_ACK  ' +
            ' Where USER_ID = :USER_ID and CAT_CODE = :CAT_CODE and ' +
            '       PROJ_NO = :PROJ_NO and EQUIP_NO = :EQUIP_NO and ' +
            '       TAG_NAME = :TAG_NAME and SET_TYPE = :SET_TYPE';
    Close;
    SQL.Clear;
    SQL.Add(LStr);

    if AAlarmConfigItem.AlarmHistoryTableName <> '' then
    begin
      with AAlarmConfigItem do
      begin
        ParamByName('USER_ID').AsString  := UserID;
        ParamByName('CAT_CODE').AsString  := Category;
        ParamByName('PROJ_NO').AsString  := ProjNo;
        ParamByName('EQUIP_NO').AsString  := EngNo;
        ParamByName('TAG_NAME').AsString  := TagName;
        ParamByName('SET_TYPE').AsInteger  := Ord(AlarmSetType);
        ParamByName('ALARM_TIME_ACK').AsDateTime  := AcknowledgedTime;
      end;//with

      OraTransaction1.StartTransaction;
      try
        ExecSQL;
        inc(LSaveCnt);
        OraTransaction1.Commit;
//        ShowMsg(IntToStr(LSaveCnt) + '건의 Item을 DB에 저장 하였습니다');
      except
        OraTransaction1.Rollback;
      end;
    end;//if
  end;// with
end;

procedure TDM1.UpdateAlarmOutTime2HistoryDB(const AAlarmConfigItem: TAlarmConfigItem);
var
  i, LSaveCnt: integer;
  LStr: string;
begin
  LSaveCnt := 0;

  with OraQuery1 do
  begin
    LStr := 'Update TBACS.' + AAlarmConfigItem.AlarmHistoryTableName +
            ' Set ALARM_TIME_OUT = :ALARM_TIME_OUT  ' +
            ' Where USER_ID = :USER_ID and CAT_CODE = :CAT_CODE and ' +
            '       PROJ_NO = :PROJ_NO and EQUIP_NO = :EQUIP_NO and ' +
            '       TAG_NAME = :TAG_NAME and SET_TYPE = :SET_TYPE';
    Close;
    SQL.Clear;
    SQL.Add(LStr);

    if AAlarmConfigItem.AlarmHistoryTableName <> '' then
    begin
      with AAlarmConfigItem do
      begin
        ParamByName('USER_ID').AsString  := UserID;
        ParamByName('CAT_CODE').AsString  := Category;
        ParamByName('PROJ_NO').AsString  := ProjNo;
        ParamByName('EQUIP_NO').AsString  := EngNo;
        ParamByName('TAG_NAME').AsString  := TagName;
        ParamByName('SET_TYPE').AsInteger  := Ord(AlarmSetType);
        ParamByName('ALARM_TIME_OUT').AsDateTime  := ReleaseDateTime;
      end;//with

      OraTransaction1.StartTransaction;
      try
        ExecSQL;
        inc(LSaveCnt);
        OraTransaction1.Commit;
//        ShowMsg(IntToStr(LSaveCnt) + '건의 Item을 DB에 저장 하였습니다');
      except
        OraTransaction1.Rollback;
      end;
    end;//if
  end;// with
end;

procedure TDM1.UpdateEngParamFile2DB(AProjNo, AEngNo, AFileName: string);
var
  lms : TMemoryStream;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update MON_TABLES ' +
            'SET ENG_PARAMETER = :paramfile where ENG_PROJNO = :projno and ENG_NO = :engno');

    ParamByName('projno').AsString     := AProjNo;
    ParamByName('engno').AsString      := AEngNo;

    lms := TMemoryStream.Create;
    try
      lms.Position := 0;
      lms.LoadFromFile(AFileName);

      if lms <> nil then
      begin
        ParamByName('paramfile').ParamType := ptInput;
        ParamByName('paramfile').AsOraBlob.LoadFromStream(lms);
      end;

      try
        ExecSQL;
      except
        on e:exception do
        begin
//          ShowMsg(e.Message);
          Raise;
        end;
      end;

      ShowMsg(AProjNo + '(' + AEngNo + ') Parameter File:' + AFileName + '을 DB에 등록 성공!');
    finally
      FreeAndNil(lms);
    end;
  end;
end;

end.
