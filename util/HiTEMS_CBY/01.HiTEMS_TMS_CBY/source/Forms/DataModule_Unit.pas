unit DataModule_Unit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Ora, MemDS, OraTransaction,
  OraSmart, DateUtils, HoliDayCollect, Generics.Collections, OraCall, System.StrUtils;

type
  TUserInfo = Record
    UserID,
    UserName,
    TeamNo,
    Dept_Cd,
    DeptName,
    JobPosition,
    Manager : String;
  public
    function CurrentUsers : String;
    function CurrentUsersDept : String;
    function CurrentUsersTeam : String;
    function CurrentUsersManager : String;
    function CurrentJobPosition: string;
    function CurrentDeptName: string;
  End;

  TDM1 = class(TDataModule)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraTransaction1: TOraTransaction;
    OraDataSource1: TOraDataSource;
    OraQuery2: TOraQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure GetHolidayFromDB;
  public
    FHoliDayList: THoliDayList;
    FOffReasonList: TDictionary<string,integer>;
    FUserInfo : TUserInfo;
    FTeamList: TStringList;
    FdeptDic : TDictionary<String,String>;

    function GetWeekOverTimeMH(APerformDate: TDate; AUserId: string): double;
    function GetMHBefore(AStartDate, AEndDate: TDate; AUserId: string): double;
    function GetDefaultOverTime(AFromDate,AToDate: TDate; AUserId: string): integer;
    function GetOffDay(AFromDate,AToDate: TDate; AUserId: string): integer;
    function IsOver4Grade(AUserId: string): Boolean;

    function Get_TASK_RESULT(AFromDate, AToDate: TDate; ATeamCode, AKeyWord, AUserIdList: string) : TOraQuery;
    procedure GetTeamList(ADept: string; AList: TStrings = nil);
    procedure SetTeamList(AList: TStrings);
  end;

var
  DM1: TDM1;

implementation

uses CommonUtil_Unit;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDM1 }

procedure TDM1.DataModuleCreate(Sender: TObject);
begin
  FHoliDayList:= THoliDayList.Create(Self);
  FTeamList := TStringList.Create;
  FdeptDic := TDictionary<String,String>.Create;

  GetHolidayFromDB;
end;

procedure TDM1.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FHoliDayList);
  FreeAndNil(FOffReasonList);
  FreeAndNil(FTeamList);
  FreeAndNil(FdeptDic);
end;

procedure TDM1.GetHolidayFromDB;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HiTEMS_HOLIDAY ' +
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
           '  (SELECT * FROM TMS_RESULT_MH ' +
           '          WHERE RST_BY = :UserID AND (RST_TIME_TYPE > 0 AND RST_TIME_TYPE <> 2 AND RST_TIME_TYPE <> 3)) A JOIN ' +  //주말근무, 야간근무 각각 8시간은 제외함
           '  (SELECT * FROM TMS_RESULT '+
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
    SQL.Add('SELECT USERID, RESTTYPE, RESTFROM, RESTTO FROM HiTEMS_USER_REST' +
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
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT DEPT_CD, DEPT_NAME FROM HITEMS_DEPT ' +
            'WHERE PARENT_CD = :deptcd ORDER BY DEPT_CD');

    ParamByName('deptcd').Text := ADept;
    Open;

    if Assigned(AList) then
      AList.Clear
    else
    begin
      FTeamList.Clear;
      FdeptDic.Clear;
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
          FTeamList.Add(LStr);
          FdeptDic.Add(LStr, FieldByName('DEPT_NAME').AsString);
        end;
      end;

      next;
    end;
  end;
end;

function TDM1.GetDefaultOverTime(AFromDate, AToDate: TDate; AUserId: string): integer;
begin
  if IsOver4Grade(AUserId) then//4급 이상이면 기본1시간 연장근무함.
    Result := FHoliDayList.GetWorkDay(AFromDate, AToDate)
  else
    Result := 0;
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
            '   FROM TMS_RESULT A, TMS_RESULT_MH B ' +
            '   WHERE A.RST_NO = B.RST_NO ' +
            ') A, ' +
            '( ' +
            '   SELECT USERID, DEPT_CD, NAME_KOR, DESCR ' +
            '   FROM HITEMS_USER A, HITEMS_USER_GRADE B ' +
            '   WHERE A.GRADE = B.GRADE ' +
            ') B ' +
            'WHERE A.RST_BY = B.USERID ' +
            'AND RST_PERFORM BETWEEN :param1 AND :param2 ' +
            'AND (DEPT_CD LIKE :teamCode) ' +
            'AND UPPER(RST_TITLE) LIKE UPPER(:rstTitle) ');


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
    SQL.Add('SELECT USERID, GRADE FROM HiTEMS_USER' +
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

procedure TDM1.SetTeamList(AList: TStrings);
var
  i: integer;
  key: string;
begin
  if not Assigned(AList) then
    exit;

  AList.Clear;

  for Key in FdeptDic.Keys do
  begin
    AList.Add(FDeptDic.Items[Key]);
  end;
end;

{ TUserInfo }

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
