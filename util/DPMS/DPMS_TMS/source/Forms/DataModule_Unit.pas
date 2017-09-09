unit DataModule_Unit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Ora, MemDS, OraTransaction,
  OraSmart, DateUtils, HoliDayCollect, Generics.Collections, OraCall, System.StrUtils,
  HiTEMS_TMS_CONST, TodoList;

type
  TUserInfo = Record
    UserID,
    UserName,
    TeamNo,
    TeamName,
    Dept_Cd,
    DeptName,
    Grade,
    JobPosition,
    Manager : String;
    AliasCode_Dept,
    AliasCode_Team: integer;
  public
    function CurrentUsers : String;
    function CurrentUsersDept : String;
    function CurrentUsersTeam : String;
    function CurrentUsersManager : String;
    function CurrentJobPosition: string;
    function CurrentDeptName: string;
    function CurrentDeptAlias: integer;
  End;

  TDeptClass = Class
  public
    FCode: string;
    FName: string;
    FAlias: integer;
  End;

  TDM1 = class(TDataModule)
    OraQuery1: TOraQuery;
    OraTransaction1: TOraTransaction;
    OraDataSource1: TOraDataSource;
    OraQuery2: TOraQuery;
    OraSession1: TOraSession;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure GetHolidayFromDB;
    procedure SaveToDoList2DB;
  public
    FHoliDayList: THoliDayList;
    FOffReasonList: TDictionary<string,integer>;
    FUserInfo : TUserInfo;
    FTeamList: TStringList;
    FDeptList: TStringList;

    FdeptDic : TDictionary<String,TDeptClass>;
    FTeamDic : TDictionary<String,TDeptClass>;
//    FToDoCollect: TpjhToDoItemCollection;
    FToDoCollect4Alarm: TpjhToDoItemCollection;

    function GetWeekOverTimeMH(APerformDate: TDate; AUserId: string): double;
    function GetMHBefore(AStartDate, AEndDate: TDate; AUserId: string): double;
    function GetDefaultOverTime(AFromDate,AToDate: TDate; AUserId: string): integer;
    function GetOffDay(AFromDate,AToDate: TDate; AUserId: string): integer;
    function IsOver4Grade(AUserId: string): Boolean;

    function Get_TASK_RESULT(AFromDate, AToDate: TDate; ATeamCode, AKeyWord, AUserIdList: string) : TOraQuery;
    procedure GetTeamList(ADept: string; AList: TStrings = nil);
    procedure GetDeptList(AList: TStrings = nil);
    procedure SetListFromDic(AList: TStrings; ADic: TDictionary<String,TDeptClass>);
    function GetAliasCode(ADeptCode: string): integer;
    function GetVisibleTypeToStr(ACode: string; ACodeType: integer): string;
    function GetVisibleTypeFromGrp(ACode: string; ACodeType: integer;  out ACodeName: string; out AAlias_Code: integer): integer;
    function GetVisibleTypeFromCat(ACatNo: string; AAliasCode: integer): integer;

    function Get_User_Info(aUserId: String): TUserInfo;
    procedure DicClear(ADic: TDictionary<String,TDeptClass>);

    procedure GetToDoListFromDB(APlanNo: string; ApjhToDoItemCollection:TpjhToDoItemCollection);
    procedure GetToDoListFromDB2(ApjhToDoItemCollection:TpjhToDoItemCollection);
    procedure InsertOrUpdateToDoList2DB(AIndex: integer; AIsAdd: Boolean);
    procedure UpdateAlarmFlag2DB(AIndex: integer);
    procedure DeleteToDoList2DB(AIndex: integer);
    procedure CalcAlarmTime;
    procedure UpdateAlarmFlag;
  end;

var
  DM1: TDM1;

implementation

uses CommonUtil_Unit;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDM1 }

//AlarmTime을 계산함(실제 Alarm이 발생할 시각을 미리 계산 함)
procedure TDM1.CalcAlarmTime;
var
  i: integer;
  myHour, myMin, mySec, myMilli : Word;
  myYear, myMonth, myDay : Word;
  Ldt: TDateTime;
begin
  for i := 0 to FToDoCollect4Alarm.Count - 1 do
  begin
    if FToDoCollect4Alarm.Items[i].AlarmType = 2 then //미리알람 모드인 경우(분단위)
    begin
      DecodeDateTime(FToDoCollect4Alarm.Items[i].CreationDate, myYear, myMonth, myDay, myHour, myMin, mySec, myMilli);
      Ldt := EncodeDateTime(myYear, myMonth, myDay, myHour, myMin, mySec, myMilli);
      Ldt := DateTimeMinusInteger(Ldt, FToDoCollect4Alarm.Items[i].AlarmTime2, 2, '-');
      FToDoCollect4Alarm.Items[i].AlarmTime := Ldt;
    end
    else
      FToDoCollect4Alarm.Items[i].AlarmTime := FToDoCollect4Alarm.Items[i].AlarmTime1;
  end;
end;

procedure TDM1.DataModuleCreate(Sender: TObject);
begin
  FHoliDayList:= THoliDayList.Create(Self);
  FTeamList := TStringList.Create;
  FDeptList := TStringList.Create;

  FdeptDic := TDictionary<String,TDeptClass>.Create;
  FTeamDic := TDictionary<String,TDeptClass>.Create;

//  FToDoCollect := TpjhToDoItemCollection.Create(TpjhTodoItem);
  FToDoCollect4Alarm := TpjhToDoItemCollection.Create(TpjhTodoItem);

  GetHolidayFromDB;
end;

procedure TDM1.DataModuleDestroy(Sender: TObject);
begin
//  FToDoCollect.Clear;
//  FreeAndNil(FToDoCollect);
  FToDoCollect4Alarm.Clear;
  FreeAndNil(FToDoCollect4Alarm);
  FreeAndNil(FHoliDayList);
  FreeAndNil(FOffReasonList);
  FreeAndNil(FTeamList);
  FreeAndNil(FDeptList);

  DicClear(FdeptDic);
  FreeAndNil(FdeptDic);

  DicClear(FTeamDic);
  FreeAndNil(FTeamDic);
end;

procedure TDM1.DeleteToDoList2DB(AIndex: integer);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('DELETE FROM DPMS_TODO_LIST ' +
            'WHERE TODO_CODE = :TODO_CODE ');
    ParamByName('TODO_CODE').AsString := FToDoCollect4Alarm.Items[AIndex].TodoCode;

    ExecSQL;
  end;
end;

procedure TDM1.DicClear(ADic: TDictionary<String, TDeptClass>);
var
  Key: string;
begin
  for Key in ADic.Keys do
    TDeptClass(ADic.Items[Key]).Free;
end;

procedure TDM1.GetHolidayFromDB;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_HOLIDAY ' +
            'WHERE TO_CHAR(FROMDATE,''YYYY'') = :param1 ORDER BY FROMDATE');
    ParamByName('param1').AsString := IntToStr(CurrentYear-1);

    Open;

    if RecordCount > 0 then
    begin
      while not eof do
      begin
        with FHoliDayList.HoliDayCollect.add do
        begin
          FromDate := FieldByName('FROMDATE').AsDateTime;
          ToDate := FieldByName('TODATE').AsDateTime;
          Description := FieldByName('Description').AsString;
        end;

        Next;
      end;
    end;
  end;
end;

//AUserId가 기간 동안 실적 입력한 연장 근무 시간을 반환
function TDM1.GetMHBefore(AStartDate, AEndDate: TDate; AUserId: string): double;
var
  LMHSum: double;
begin
  Result := 0.0;

  with DM1.OraQuery1 do
  begin

    Close;
    SQL.Clear;
    SQL.Add('SELECT SUM(A.RST_MH) MH FROM ' +
           '  (SELECT * FROM DPMS_TMS_RESULT_MH ' +
           '          WHERE RST_BY = :UserID AND (RST_TIME_TYPE > 0 AND RST_TIME_TYPE <> 2 AND RST_TIME_TYPE <> 3)) A JOIN ' +  //주말근무, 야간근무 각각 8시간은 제외함
           '  (SELECT * FROM DPMS_TMS_RESULT '+
           '          WHERE RST_PERFORM >= :STARTDATE AND RST_PERFORM <= :ENDDATE '+
           '          ORDER BY RST_PERFORM) B '+
           ' ON A.RST_NO = B.RST_NO');

    ParamByName('UserID').AsString := AUserId;
    ParamByName('STARTDATE').AsDate := AStartDate;
    ParamByName('ENDDATE').AsDate := AEndDate;

    Open;

    if RecordCount > 0 then
    begin
      LMHSum := FieldByName('MH').AsFloat;
      //ShowMessage('Total MH = ' + LMHSum);
      Result := LMHSum;
    end;
  end;
end;

//휴가로 인해 고정연장 1시간이 없는 일 수 반환
function TDM1.GetOffDay(AFromDate, AToDate: TDate; AUserId: string): integer;
var
  LBeginDate,
  LEndDate,
  LRestType: string;
  i, LCount, LIncCount: integer;
  LBeginDate2,
  LEndDate2,
  LTempDate: TDate;
begin
  Result := 0;

  if AUserId = '' then
    exit;

  LBeginDate := FormatDateTime('yyyy-MM-dd',AFromDate);
  LEndDate := FormatDateTime('yyyy-MM-dd',AToDate);

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT USERID, RESTTYPE, RESTFROM, RESTTO FROM DPMS_USER_REST' +
           '  WHERE USERID = :USERID ');// +
           //'  RESTTYPE IN (''교육'',''훈련(예비군)'',''년/월차'',''년/월차(오후)'',''휴가'') ');
    SQL.Add(' AND (TO_CHAR(RESTFROM, ''yyyy-mm-dd'') <= :beginDate ' +
              'AND TO_CHAR(RESTTO, ''yyyy-mm-dd'') >= :beginDate ' +
              'AND TO_CHAR(RESTFROM, ''yyyy-mm-dd'') <= :endDate ' +
              'AND TO_CHAR(RESTTO, ''yyyy-mm-dd'') <= :endDate ' +
              'OR TO_CHAR(RESTFROM, ''yyyy-mm-dd'') >= :beginDate ' +
              'AND TO_CHAR(RESTTO, ''yyyy-mm-dd'') >= :beginDate ' +
              'AND TO_CHAR(RESTFROM, ''yyyy-mm-dd'') <= :endDate ' +
              'AND TO_CHAR(RESTTO, ''yyyy-mm-dd'') <= :endDate ' +
              'OR TO_CHAR(RESTFROM, ''yyyy-mm-dd'') >= :beginDate ' +
              'AND TO_CHAR(RESTTO, ''yyyy-mm-dd'') >= :beginDate ' +
              'AND TO_CHAR(RESTFROM, ''yyyy-mm-dd'') <= :endDate ' +
              'AND TO_CHAR(RESTTO, ''yyyy-mm-dd'') >= :endDate ' +
              'OR TO_CHAR(RESTFROM, ''yyyy-mm-dd'') <= :beginDate ' +
              'AND TO_CHAR(RESTTO, ''yyyy-mm-dd'') >= :beginDate ' +
              'AND TO_CHAR(RESTFROM, ''yyyy-mm-dd'') <= :endDate ' +
              'AND TO_CHAR(RESTTO, ''yyyy-mm-dd'') >= :endDate) ');

    ParamByName('UserID').AsString := AUserId;
    ParamByName('beginDate').AsString := LBeginDate;
    ParamByName('endDate').AsString   := LEndDate;

    Open;

    if RecordCount > 0 then
    begin
      if not Assigned(FOffReasonList) then
        FOffReasonList := TDictionary<string,integer>.Create
      else
        FOffReasonList.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        LTempDate := FieldByName('RESTFROM').AsDateTime;
        LBeginDate2 := StrToDate(LBeginDate);

        if LBeginDate2 < LTempDate then
          LBeginDate2 := LTempDate;

        LTempDate := FieldByName('RESTTO').AsDateTime;
        LEndDate2 := StrToDate(LEndDate);

        if LEndDate2 > LTempDate then
          LEndDate2 := LTempDate;

        LIncCount := DateUtils.DaysBetween(LBeginDate2, LEndDate2) + 1;

        LRestType := FieldByName('RESTTYPE').AsString;
        //if FOffReasonList.ContainsKey[LRestType] then
        if FOffReasonList.TryGetValue(LRestType, LCount) then
          Inc(LCount, LIncCount)
        else
          LCount := LIncCount;

        FOffReasonList.AddOrSetValue(LRestType, LCount);
        Result := Result + LIncCount;
        Next;
      end;
    end;
  end;
end;

procedure TDM1.GetTeamList(ADept: string; AList: TStrings);
var
  i: integer;
  LStr: string;
  LDeptClass: TDeptClass;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT DEPT_CD, DEPT_NAME FROM DPMS_DEPT ' +
            'WHERE PARENT_CD = :deptcd ORDER BY DEPT_CD');

    ParamByName('deptcd').Text := ADept;
    Open;

    if Assigned(AList) then
      AList.Clear
    else
    begin
      FTeamList.Clear;
      DicClear(FTeamDic);
    end;

    for i := 0 to RecordCount - 1 do
    begin
      LStr := FieldByName('DEPT_CD').AsString;

      if Copy(LStr, Length(LStr), 1) <> '0' then
      begin
        if Assigned(AList) then
          AList.Add(FieldByName('DEPT_NAME').AsString)
        else
        begin
          LDeptClass := TDeptClass.Create;
          LDeptClass.FName := FieldByName('DEPT_NAME').AsString;
          FTeamList.Add(LStr);
          FTeamDic.Add(LStr, LDeptClass);
        end;
      end;

      next;
    end;
  end;
end;

procedure TDM1.GetToDoListFromDB(APlanNo: string;
  ApjhToDoItemCollection: TpjhToDoItemCollection);
var
  i: integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_TODO_LIST ' +
            'WHERE PLAN_CODE = :PLANNO AND MODID = :MODID AND ALARMFLAG <> 1 ');
    ParamByName('PLANNO').AsString := APlanNo;
    ParamByName('MODID').AsString := DM1.FUserInfo.UserID;
    Open;

    if RecordCount > 0 then
      ApjhToDoItemCollection.Clear;

    for i := 0 to RecordCount - 1 do
    begin
      with ApjhToDoItemCollection.Add do
      begin
        Subject := FieldByName('SUBJECT').AsString;
        Notes.Text := FieldByName('NOTES').AsString;

        CreationDate := FieldByName('CREATIONDATE').AsDateTime;
        DueDate := FieldByName('DUEDATE').AsDateTime;
        CompletionDate := FieldByName('COMPLETIONDATE').AsDateTime;

        Complete := Boolean(FieldByName('COMPLETE').AsInteger);
        Completion := TCompletion(FieldByName('COMPLETION').AsInteger);
        Status := TTodoStatus(FieldByName('STATUS').AsInteger);
        Priority := TTodoPriority(FieldByName('PRIORITY').AsInteger);
        TotalTime := FieldByName('TOTALTIME').AsInteger;

        AlarmType := FieldByName('ALARMTYPE').AsInteger;
        AlarmTime1 := FieldByName('ALARMTIME1').AsDateTime;
        AlarmTime2 := FieldByName('ALARMTIME2').AsInteger;
        AlarmFlag := FieldByName('ALARMFLAG').AsInteger;
        Alarm2Msg := FieldByName('ALARM2MSG').AsInteger;
        Alarm2Note := FieldByName('ALARM2NOTE').AsInteger;
        Alarm2Email := FieldByName('ALARM2EMAIL').AsInteger;
        ModDate := FieldByName('MODDATE').AsDateTime;
      end;

      Next;
    end;
  end;
end;

procedure TDM1.GetToDoListFromDB2(
  ApjhToDoItemCollection: TpjhToDoItemCollection);
var
  i: integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_TODO_LIST ' +
            'WHERE MODID = :MODID AND ALARMFLAG <> 1 ORDER BY CREATIONDATE');
    ParamByName('MODID').AsString := FUserInfo.UserID;
    Open;

    if RecordCount > 0 then
      ApjhToDoItemCollection.Clear;

    for i := 0 to RecordCount - 1 do
    begin
      with ApjhToDoItemCollection.Add do
      begin
        Subject := FieldByName('SUBJECT').AsString;
        Notes.Text := FieldByName('NOTES').AsString;

        CreationDate := FieldByName('CREATIONDATE').AsDateTime;
        DueDate := FieldByName('DUEDATE').AsDateTime;
        CompletionDate := FieldByName('COMPLETIONDATE').AsDateTime;

        Complete := Boolean(FieldByName('COMPLETE').AsInteger);
        Completion := TCompletion(FieldByName('COMPLETION').AsInteger);
        Status := TTodoStatus(FieldByName('STATUS').AsInteger);
        Priority := TTodoPriority(FieldByName('PRIORITY').AsInteger);
        TotalTime := FieldByName('TOTALTIME').AsInteger;
        Resource := FieldByname('TODO_RESOURCE').AsString;
        Category := FieldByname('CATEGORY').AsString;

        ToDoCode := FieldByname('TODO_CODE').AsString;
        PlanCode := FieldByname('PLAN_CODE').AsString;
        TaskCode := FieldByname('TASK_CODE').AsString;

        AlarmType := FieldByName('ALARMTYPE').AsInteger;
        AlarmTime1 := FieldByName('ALARMTIME1').AsDateTime;
        AlarmTime2 := FieldByName('ALARMTIME2').AsInteger;
        AlarmFlag := FieldByName('ALARMFLAG').AsInteger;
        Alarm2Msg := FieldByName('ALARM2MSG').AsInteger;
        Alarm2Note := FieldByName('ALARM2NOTE').AsInteger;
        Alarm2Email := FieldByName('ALARM2EMAIL').AsInteger;
        ModId := FieldByname('MODID').AsString;
        ModDate := FieldByName('MODDATE').AsDateTime;
      end;

      Next;
    end;
  end;

  CalcAlarmTime;
  ApjhToDoItemCollection.Sort;
end;

function TDM1.GetVisibleTypeFromCat(ACatNo: string; AAliasCode: integer): integer;
begin
  Result := -1;

  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;

    SQL.Add('SELECT ALIAS_CODE_TYPE FROM DPMS_CODE_VISIBLE ' +
            'WHERE CODE_ID = :CODE_ID AND CODE_TYPE = :CODE_TYPE AND ALIAS_CODE = :ALIAS_CODE ');

    ParamByName('CODE_ID').AsString := ACatNo;
    ParamByName('CODE_TYPE').AsInteger := ord(ctCategory);
    ParamByName('ALIAS_CODE').AsInteger := AAliasCode;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('ALIAS_CODE_TYPE').AsInteger;
  end;
end;

function TDM1.GetVisibleTypeFromGrp(ACode: string; ACodeType: integer; out ACodeName: string; out AAlias_Code: integer): integer;
var
  i, j: integer;
  LStr: string;
begin
  Result := -1;

  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;

    if ACodeType = ord(ctGroup) then
    begin
//      SQL.Add('SELECT CODE_NAME, ALIAS_CODE, ALIAS_CODE_TYPE FROM DPMS_CODE_GROUP A, DPMS_CODE_VISIBLE B ' +
//            'WHERE GRP_NO = :GRP_NO AND ((A.CAT_NO = B.CODE_ID) OR (A.CODE = B.CODE_ID))');
      SQL.Add('SELECT * FROM ( ' +
              ' SELECT * FROM DPMS_CODE_GROUP WHERE GRP_NO = :GRP_NO) A ' +
              ' LEFT OUTER JOIN DPMS_CODE_VISIBLE B ' +
              ' ON ((A.CAT_NO = B.CODE_ID) OR (A.CODE = B.CODE_ID))');
      ParamByName('GRP_NO').AsString := ACode;
      Open;

      Result := 0;

      for i := 0 to RecordCount - 1 do
      begin
        j := FieldByName('ALIAS_CODE_TYPE').AsInteger;
        AAlias_Code := FieldByName('ALIAS_CODE').AsInteger;
        ACodeName := FieldByName('CODE_NAME').AsString;

        if Result < j then
        begin
          Result := j;
          exit;
        end;

        Next;
      end;
    end
    else
    begin
      SQL.Add('SELECT ALIAS_CODE_TYPE FROM DPMS_CODE_VISIBLE ' +
              'WHERE CODE_ID = :CODE_ID AND CODE_TYPE = :CODE_TYPE');

      ParamByName('CODE_ID').AsString := ACode;
      ParamByName('CODE_TYPE').AsInteger := ACodeType;
      Open;

      if RecordCount > 0 then
        Result := FieldByName('ALIAS_CODE_TYPE').AsInteger;
    end;
  end;
end;

function TDM1.GetVisibleTypeToStr(ACode: string; ACodeType: integer): string;
var
  i,j: integer;
  LCodeName: string;
begin
  i := GetVisibleTypeFromGrp(ACode, ACodeType, LCodeName, j);

  case i of
    1: Result := '부서';
    2: Result := '팀';
    3: Result := '개인';
    else
      Result := '부서';
  end;
end;

function TDM1.GetAliasCode(ADeptCode: string): integer;
begin
  Result := -1;

  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ALIAS_CODE FROM DPMS_DEPT_ALIAS ' +
            'WHERE DEPT_CODE = :deptcd ORDER BY ALIAS_CODE');

    ParamByName('deptcd').Text := ADeptCode;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('ALIAS_CODE').AsInteger;
  end;
end;

function TDM1.GetDefaultOverTime(AFromDate, AToDate: TDate; AUserId: string): integer;
begin
  if IsOver4Grade(AUserId) then//4급 이상이면 기본1시간 연장근무함.
    Result := FHoliDayList.GetWorkDay(AFromDate, AToDate)
  else
    Result := 0;
end;

procedure TDM1.GetDeptList(AList: TStrings);
var
  i: integer;
  LStr: string;
  LDeptClass: TDeptClass;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT DEPT_CD, DEPT_NAME FROM DPMS_DEPT ' +
            'WHERE DEPT_LV = 1 ORDER BY DEPT_CD');
    Open;

    if Assigned(AList) then
      AList.Clear
    else
    begin
      FDeptList.Clear;
      DicClear(FDeptDic);
    end;

    for i := 0 to RecordCount - 1 do
    begin
      LStr := FieldByName('DEPT_CD').AsString;

      if Copy(LStr, Length(LStr), 1) <> '0' then
      begin
        if Assigned(AList) then
          AList.Add(FieldByName('DEPT_NAME').AsString)
        else
        begin
          LDeptClass := TDeptClass.Create;
          LDeptClass.FName := FieldByName('DEPT_NAME').AsString;

          FDeptList.Add(LStr);
          FDeptDic.Add(LStr, LDeptClass);
        end;
      end;

      next;
    end;
  end;
end;

function TDM1.GetWeekOverTimeMH(APerformDate: TDate; AUserId: string): double;
var
  LMH: double;
  LDefaultOverTime: integer;
  LStartDate,
  LEndDate: TDateTime;
  LWeekNo: integer;
  LOffDay: integer;
begin
  LWeekNo := DateUtils.WeekOfTheYear(APerformDate);
  LStartDate := Week2FirstDate(LWeekNo,APerformDate);//월요일
  LEndDate := Week2LastDate(LWeekNo,APerformDate);   //토요일

  LMH := GetMHBefore(LStartDate, LEndDate, AUserId);

  if IsOver4Grade(AUserId) then//사무직이거나 생산직 4급 이상이면 기본1시간 연장근무함.
  begin
    LDefaultOverTime := FHoliDayList.GetWorkDay(LStartDate, LEndDate);
    LOffDay := DM1.GetOffDay(LStartDate, LEndDate-1, AUserId); //월~금

    LDefaultOverTime := LDefaultOverTime - LOffDay;
  end
  else
  begin
    LDefaultOverTime := 0;
  end;

  Result := LMH + LDefaultOverTime;
end;

function TDM1.Get_TASK_RESULT(AFromDate, AToDate: TDate; ATeamCode, AKeyWord,
  AUserIdList: string): TOraQuery;
var
  luserId : String;
  li : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM ' +
            '( ' +
            '   SELECT A.PLAN_NO, A.RST_NO, RST_CODE, RST_TYPE, RST_PERFORM, ' +
            '   RST_TITLE, RST_NOTE, RST_PROGRESS, RST_NEXT_TASK, ' +
            '   PLAN_REV_NO, RST_SORT, RST_BY, RST_MH, RST_TIME_TYPE ' +
            '   FROM DPMS_TMS_RESULT A, DPMS_TMS_RESULT_MH B ' +
            '   WHERE A.RST_NO = B.RST_NO ' +
            ') A, ' +
            '( ' +
            '   SELECT USERID, DEPT_CD, NAME_KOR, DESCR ' +
            '   FROM DPMS_USER A, DPMS_USER_GRADE B ' +
            '   WHERE A.GRADE = B.GRADE ' +
            ') B ' +
            'WHERE A.RST_BY = B.USERID ' +
            ' AND RST_PERFORM BETWEEN :param1 AND :param2 ' +
            ' AND (DEPT_CD LIKE :teamCode) ' +
            ' AND UPPER(RST_TITLE) LIKE UPPER(:rstTitle) ');


    if ATeamCode <> '' then
      ParamByName('teamCode').Text := '%' + ATeamCode +'%'
    else
      SQL.Text := ReplaceStr(SQL.Text, 'AND (DEPT_CD LIKE :teamCode) ','');

    ParamByName('param1').AsDate := AFromDate;
    ParamByName('param2').AsDate := AToDate;

    if AKeyWord <> '' then
      ParamByName('rstTitle').AsString := '%' + AKeyWord + '%'
    else
      SQL.Text := ReplaceStr(SQL.Text, 'AND UPPER(RST_TITLE) LIKE UPPER(:rstTitle) ', '');

    if Length(lUserId) > 0 then
      SQL.Add('AND USERID In ('+lUserId+')');

    SQL.Add('order by RST_PERFORM ');

    Open;

    Result := DM1.OraQuery1;
  end;
end;

function TDM1.Get_User_Info(aUserId: String): TUserInfo;
begin
  FillChar(Result, SizeOf(Result), 0);

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*,B.MANAGER, DEPT_NAME FROM DPMS_USER A, DPMS_DEPT B ' +
            'where A.UserID = :param1 and A.DEPT_CD = B.DEPT_CD ');
    ParamByName('param1').AsString := aUserId;
    Open;

    if RecordCount > 0 then
    begin
      with Result do
      begin
        UserID := FieldByName('USERID').AsString;
        UserName := FieldByName('NAME_KOR').AsString;
        Dept_Cd := LEFTSTR(FieldByName('DEPT_CD').AsString,3);
        DeptName := FieldByName('DEPT_NAME').AsString;
        TEAMNO := FieldByName('DEPT_CD').AsString;
        JobPosition := FieldByName('POSITION').AsString;
        Manager := FieldByName('MANAGER').AsString;

//        DM1.GetTeamList(Dept_Cd);
        AliasCode_Dept := DM1.GetAliasCode(Dept_cd);
        AliasCode_Team := DM1.GetAliasCode(TEAMNO);
      end;
    end;
  end;
end;

procedure TDM1.InsertOrUpdateToDoList2DB(AIndex: integer; AIsAdd: Boolean);
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DPMS_TODO_LIST ' +
            'WHERE TODO_CODE = :TODO_CODE ');
    ParamByName('TODO_CODE').AsString := FToDoCollect4Alarm.Items[AIndex].TodoCode;
    Open;

    if RecordCount > 0 then
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE DPMS_TODO_LIST ' +
              'SET TODO_CODE = :TODO_CODE, TASK_CODE = :TASK_CODE, PLAN_CODE = :PLAN_CODE, ' +
              '   SUBJECT = :SUBJECT, NOTES = :NOTES, CREATIONDATE = :CREATIONDATE, ' +
              '   DUEDATE = :DUEDATE, COMPLETIONDATE = :COMPLETIONDATE, ' +
              '   COMPLETION = :COMPLETION, COMPLETE = :COMPLETE, TODO_RESOURCE = :TODO_RESOURCE, ' +
              '   STATUS = :STATUS, PRIORITY = :PRIORITY, TOTALTIME = :TOTALTIME, ' +
              '   MODID = :MODID, MODDATE = :MODDATE, ALARMTYPE = :ALARMTYPE, ' +
              '   ALARMTIME1 = :ALARMTIME1, ALARMTIME2 = :ALARMTIME2, ' +
              '   ALARMFLAG = :ALARMFLAG, ALARM2MSG = :ALARM2MSG, ALARM2NOTE = :ALARM2NOTE, ' +
              '   ALARM2EMAIL = :ALARM2EMAIL, CATEGORY = :CATEGORY ' +
              'WHERE TODO_CODE = :TODO_CODE ');
    end
    else
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO DPMS_TODO_LIST ' +
              'VALUES ( ' +
              ':TODO_CODE, :TASK_CODE, :PLAN_CODE, :SUBJECT, :NOTES, :CREATIONDATE, ' +
              ':DUEDATE, :COMPLETIONDATE, :COMPLETION, :COMPLETE, :TODO_RESOURCE, ' +
              ':STATUS, :PRIORITY, :TOTALTIME, :MODID, :MODDATE, :ALARMTYPE, ' +
              ':ALARMTIME1, :ALARMTIME2, :ALARMFLAG, :ALARM2MSG, :ALARM2NOTE, ' +
              ':CATEGORY )');
    end;

    ParamByName('TODO_CODE').AsString := FToDoCollect4Alarm.Items[AIndex].TodoCode;
    ParamByName('TASK_CODE').AsString := FToDoCollect4Alarm.Items[AIndex].TaskCode;
    ParamByName('PLAN_CODE').AsString := FToDoCollect4Alarm.Items[AIndex].PlanCode;
    ParamByName('SUBJECT').AsString := FToDoCollect4Alarm.Items[AIndex].Subject;
    ParamByName('NOTES').AsString := FToDoCollect4Alarm.Items[AIndex].Notes.Text;
    ParamByName('CREATIONDATE').AsDateTime := FToDoCollect4Alarm.Items[AIndex].CreationDate;
    ParamByName('DUEDATE').AsDateTime := FToDoCollect4Alarm.Items[AIndex].DueDate;
    ParamByName('COMPLETIONDATE').AsDateTime := FToDoCollect4Alarm.Items[AIndex].CompletionDate;
    ParamByName('COMPLETION').AsInteger := FToDoCollect4Alarm.Items[AIndex].Completion;
    ParamByName('COMPLETE').AsInteger := Integer(FToDoCollect4Alarm.Items[AIndex].Complete);
    ParamByName('TODO_RESOURCE').AsString := FToDoCollect4Alarm.Items[AIndex].Resource;
    ParamByName('CATEGORY').AsString := FToDoCollect4Alarm.Items[AIndex].Category;
    ParamByName('STATUS').AsInteger := ord(FToDoCollect4Alarm.Items[AIndex].Status);
    ParamByName('PRIORITY').AsInteger := Ord(FToDoCollect4Alarm.Items[AIndex].Priority);
    ParamByName('TOTALTIME').AsInteger := Trunc(FToDoCollect4Alarm.Items[AIndex].TotalTime);
    ParamByName('MODID').AsString := FToDoCollect4Alarm.Items[AIndex].ModId;
    ParamByName('MODDATE').AsDateTime := FToDoCollect4Alarm.Items[AIndex].ModDate;
    ParamByName('ALARMTYPE').AsInteger := FToDoCollect4Alarm.Items[AIndex].AlarmType;
    ParamByName('ALARMTIME1').AsDateTime := FToDoCollect4Alarm.Items[AIndex].AlarmTime1;
    ParamByName('ALARMTIME2').AsInteger := FToDoCollect4Alarm.Items[AIndex].AlarmTime2;
    ParamByName('ALARMFLAG').AsInteger := FToDoCollect4Alarm.Items[AIndex].AlarmFlag;
    ParamByName('ALARM2MSG').AsInteger := FToDoCollect4Alarm.Items[AIndex].Alarm2Msg;
    ParamByName('ALARM2NOTE').AsInteger := FToDoCollect4Alarm.Items[AIndex].Alarm2Note;
    ParamByName('ALARM2EMAIL').AsInteger := FToDoCollect4Alarm.Items[AIndex].Alarm2Email;

    ExecSQL;
  end;
end;

function TDM1.IsOver4Grade(AUserId: string): Boolean;
var
  LUserId,
  LGrade: string;
begin
  Result := False;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT USERID, GRADE FROM DPMS_USER' +
           '  WHERE USERID = :USERID');

    LUserId := AUserId;
    ParamByName('UserID').AsString := LUserId;

    Open;

    if RecordCount > 0 then
    begin
      LGrade := FieldByName('GRADE').AsString;
      //A 사번이 아닌 경우
      if UpperCase(Copy(LUserId, 1,1)) <> 'A' then
      begin
        if LGrade <= 'EF0' then//4급기사 이상 이면
        begin
          Result := True;
          exit;
        end;
      end
      else
        Result := True;
    end;
  end;
end;

procedure TDM1.SaveToDoList2DB;
begin
  with OraQuery1 do
  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('SELECT * FROM DPMS_TODO_LIST ' +
//            'WHERE PLAN_CODE = :PLANNO ');
//    ParamByName('param1').AsString := APlanNo;
//    Open;
//
//    if RecordCount > 0 then

  end;
end;

procedure TDM1.SetListFromDic(AList: TStrings; ADic: TDictionary<String,TDeptClass>);
var
  i: integer;
  key: string;
begin
  if not Assigned(AList) then
    exit;

  AList.Clear;

  for Key in ADic.Keys do
  begin
    AList.Add(TDeptClass(ADic.Items[Key]).FName);
  end;
end;

procedure TDM1.UpdateAlarmFlag;
begin
  FToDoCollect4Alarm.Items[FToDoCollect4Alarm.FCurrentAlarmIndex].AlarmFlag := 1;
  UpdateAlarmFlag2DB(FToDoCollect4Alarm.FCurrentAlarmIndex);
end;

procedure TDM1.UpdateAlarmFlag2DB(AIndex: integer);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE DPMS_TODO_LIST ' +
            'SET ALARMFLAG = :ALARMFLAG ' +
            'WHERE TODO_CODE = :TODO_CODE ');
    ParamByName('ALARMFLAG').AsInteger := FToDoCollect4Alarm.Items[AIndex].AlarmFlag;
    ParamByName('TODO_CODE').AsString := FToDoCollect4Alarm.Items[AIndex].TodoCode;

    ExecSQL;
  end;
end;

{ TUserInfo }

function TUserInfo.CurrentDeptAlias: integer;
begin
  Result := AliasCode_Dept;
end;

function TUserInfo.CurrentDeptName: string;
begin
  Result := DeptName;
end;

function TUserInfo.CurrentJobPosition: string;
begin
  Result := JobPosition;
end;

function TUserInfo.CurrentUsers: String;
begin
  Result := UserID;
end;

function TUserInfo.CurrentUsersDept: String;
begin
  Result := Dept_Cd;
end;

function TUserInfo.CurrentUsersManager: String;
begin
  Result := Manager;
end;

function TUserInfo.CurrentUsersTeam: String;
begin
  Result := TeamNo;
end;

end.
