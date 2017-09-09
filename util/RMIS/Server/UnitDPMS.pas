unit UnitDPMS;

interface

uses System.SysUtils, System.StrUtils, SynCommons, UnitDPMSInfoClass,
  UnitRMISSessionClass;

type
  TDPMS = class
    FDPMSInfo: TDPMSInfo;
    FRMISUserInfo: TRMISSessionInfo;

    constructor Create;
    destructor Destroy;

    function GetDPMSInfo(AFrom, ATo: string): RawUTF8;
    function GetRMISUserList(AIsMobile: Boolean): RawUTF8;
    function IsRMISUser(AID: string): Boolean;
  end;

implementation

uses UnitDM;

{ TDPMS }

constructor TDPMS.Create;
begin
  FDPMSInfo := TDPMSInfo.Create(nil);
  FRMISUserInfo := TRMISSessionInfo.Create(nil);
  GetRMISUserList(True);
end;

destructor TDPMS.Destroy;
begin
  FRMISUserInfo.Free;
  FDPMSInfo.Free;
end;

function TDPMS.GetDPMSInfo(AFrom, ATo: string): RawUTF8;
var
  LSql: string;
  i: integer;
begin
  // 날짜별 사용실적
  LSql := ' select stday,sum(cnt) ccc ' +
          ' from ( ' +
          '   SELECT empno,substr(stdate,1,8) stday,count(*) cnt ' +
          '   FROM KX01.GTAA003 ' +
          '   WHERE SYSID = ''A13'' ' +
          '        and stdate >= :F ' +
          '        and stdate <= :T ' +
          '   group by empno,substr(stdate,1,8) ' +
          ' ) a, KX01.GTAA004 b ' +
          ' where a.empno = b.empno ' +
          '       and b.dept != ''KX60'' ' +
          ' group by stday';

  with DM1.DPMSQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(LSql);
    ParamByName('F').AsString := AFrom;
    ParamByName('T').AsString := ATo;
    Open;

    if RecordCount > 0 then
    begin
      FDPMSInfo.DPMSUsagePerDateCollect.Clear;
//      FDPMSInfo.DPMSUsagePerDeptCollect.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        with FDPMSInfo.DPMSUsagePerDateCollect.Add do
        begin
          FFDate := FieldByName('stday').AsString;
          UsageCount := FieldByName('ccc').AsInteger;
        end;

        Next;
      end;
    end;

    LSql := ' select a.dept,a.deptnm,d.cnt dept_emp_cnt, ' +
            ' e.cnt, count(a.prjt_id) prjt_cnt,sum(b.cnt) task_cnt ' +
            ' from dpms_prjt a, ' +
            '     (select prjt_id,count(*) cnt ' +
            '      from dpms_prjt_task2 ' +
            '      group by prjt_id) b, KX01.GTAA004 c, ' +
            '               (SELECT dept,count(*) cnt FROM KX01.GTAA004 ' +
            '                where dept = ''AK00'' or division = ''K'' and statcd = 1 ' +
            '                group by dept) d, ' +
            '     (select dept,count(empno) cnt ' +
            '      from (select distinct b.dept,a.empno from KX01.GTAA003 a, ' +
            '           kx01.gtaa004 b where a.empno = b.empno and ' +
            '           a. SYSID = ''A13'') ' +
            '      group by dept) e ' +
            ' where a.prjt_id = b.prjt_id ' +
            '   and a.reger = c.empno ' +
            '   and a.dept = d.dept ' +
            '   and a.dept = e.dept ' +
            '   and a.dept != ''KX60'' ' +
            ' group by a.dept,a.deptnm,d.cnt,e.cnt ';

    Close;
    SQL.Clear;
    SQL.Add(LSql);
    Open;

    if RecordCount > 0 then
    begin
      FDPMSInfo.DPMSUsagePerDeptCollect.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        with FDPMSInfo.DPMSUsagePerDeptCollect.Add do
        begin
          if FieldByName('DEPT').AsString = 'AK00' then
            Dept := '임원'
          else
            Dept := FieldByName('DEPTNM').AsString;

          UserCount := FieldByName('CNT').AsInteger;
          ProjCount := FieldByName('PRJT_CNT').AsInteger;
          TaskCount := FieldByName('TASK_CNT').AsInteger;
          TotalUserCount := FieldByName('dept_emp_cnt').AsInteger;
          Usage := UserCount / TotalUserCount * 100;
        end;

        Next;
      end;
    end;
  end;

  Result := ObjectToJson(FDPMSInfo);
end;

function TDPMS.GetRMISUserList(AIsMobile: Boolean): RawUTF8;
var
  LSql, LAppCode, LAppName: string;
  i: integer;
begin
  LAppCode := '';

  // RMIS App Code 가져 옴
  LSql := 'SELECT APPCODE FROM DPMS_APP_CODE ' +
          'WHERE APPNAME_E = :param1' ;

  if AIsMobile then
    LAppName := 'M-RMIS'
  else
    LAppName := 'RMIS';

  with DM1.DPMSAppQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(LSql);
    ParamByName('param1').AsString := LAppName;
    Open;

    if RecordCount > 0 then
      LAppCode := FieldByName('APPCODE').AsString;

    if LAppCode <> '' then
    begin

      // RMIS 사용자 리스트 가져 옴
      LSql := 'SELECT A.*, B.APPNAME_K FROM DPMS_USER_APPLICATION A, DPMS_APP_CODE B ' +
              'WHERE A.APPCODE = B.APPCODE ' +
              'AND A.APPCODE = :param1 ' +
              'ORDER BY A.APPCODE' ;

      Close;
      SQL.Clear;
      SQL.Add(LSql);
      ParamByName('param1').AsString := LAppCode;
      Open;

      if RecordCount > 0 then
        FRMISUserInfo.RMISUserCollect.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        with FRMISUserInfo.RMISUserCollect.Add do
        begin
          UserId := FieldByName('USERID').AsString;
        end;

        Next;
      end;
    end;
  end;

  Result := ObjectToJson(FRMISUserInfo);
end;

function TDPMS.IsRMISUser(AID: string): Boolean;
var
  i: integer;
begin
  Result := False;

  for i := 0 to FRMISUserInfo.RMISUserCollect.Count - 1 do
  begin
    if FRMISUserInfo.RMISUserCollect.Items[i].UserId = AID then
    begin
      Result := True;
      exit;
    end;
  end;
end;

end.
=======
unit UnitDPMS;

interface

uses System.SysUtils, System.StrUtils, SynCommons, UnitDPMSInfoClass,
  UnitRMISSessionClass;

type
  TDPMS = class
    FDPMSInfo: TDPMSInfo;
    FRMISUserInfo: TRMISSessionInfo;

    constructor Create;
    destructor Destroy;

    function GetDPMSInfo(AFrom, ATo: string): RawUTF8;
    function GetRMISUserList(AIsMobile: Boolean): RawUTF8;
  end;

implementation

uses UnitDM;

{ TDPMS }

constructor TDPMS.Create;
begin
  FDPMSInfo := TDPMSInfo.Create(nil);
  FRMISUserInfo := TRMISSessionInfo.Create(nil);
end;

destructor TDPMS.Destroy;
begin
  FRMISUserInfo.Free;
  FDPMSInfo.Free;
end;

function TDPMS.GetDPMSInfo(AFrom, ATo: string): RawUTF8;
var
  LSql: string;
  i: integer;
begin
  // 날짜별 사용실적
  LSql := ' select stday,sum(cnt) ccc ' +
          ' from ( ' +
          '   SELECT empno,substr(stdate,1,8) stday,count(*) cnt ' +
          '   FROM KX01.GTAA003 ' +
          '   WHERE SYSID = ''A13'' ' +
          '        and stdate >= :F ' +
          '        and stdate <= :T ' +
          '   group by empno,substr(stdate,1,8) ' +
          ' ) a, KX01.GTAA004 b ' +
          ' where a.empno = b.empno ' +
          '       and b.dept != ''KX60'' ' +
          ' group by stday';

  with DM1.DPMSQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(LSql);
    ParamByName('F').AsString := AFrom;
    ParamByName('T').AsString := ATo;
    Open;

    if RecordCount > 0 then
    begin
      FDPMSInfo.DPMSUsagePerDateCollect.Clear;
//      FDPMSInfo.DPMSUsagePerDeptCollect.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        with FDPMSInfo.DPMSUsagePerDateCollect.Add do
        begin
          FFDate := FieldByName('stday').AsString;
          UsageCount := FieldByName('ccc').AsInteger;
        end;

        Next;
      end;
    end;

    LSql := ' select a.dept,a.deptnm,d.cnt dept_emp_cnt, ' +
            ' e.cnt, count(a.prjt_id) prjt_cnt,sum(b.cnt) task_cnt ' +
            ' from dpms_prjt a, ' +
            '     (select prjt_id,count(*) cnt ' +
            '      from dpms_prjt_task2 ' +
            '      group by prjt_id) b, KX01.GTAA004 c, ' +
            '               (SELECT dept,count(*) cnt FROM KX01.GTAA004 ' +
            '                where dept = ''AK00'' or division = ''K'' and statcd = 1 ' +
            '                group by dept) d, ' +
            '     (select dept,count(empno) cnt ' +
            '      from (select distinct b.dept,a.empno from KX01.GTAA003 a, ' +
            '           kx01.gtaa004 b where a.empno = b.empno and ' +
            '           a. SYSID = ''A13'') ' +
            '      group by dept) e ' +
            ' where a.prjt_id = b.prjt_id ' +
            '   and a.reger = c.empno ' +
            '   and a.dept = d.dept ' +
            '   and a.dept = e.dept ' +
            '   and a.dept != ''KX60'' ' +
            ' group by a.dept,a.deptnm,d.cnt,e.cnt ';

    Close;
    SQL.Clear;
    SQL.Add(LSql);
    Open;

    if RecordCount > 0 then
    begin
      FDPMSInfo.DPMSUsagePerDeptCollect.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        with FDPMSInfo.DPMSUsagePerDeptCollect.Add do
        begin
          if FieldByName('DEPT').AsString = 'AK00' then
            Dept := '임원'
          else
            Dept := FieldByName('DEPTNM').AsString;

          UserCount := FieldByName('CNT').AsInteger;
          ProjCount := FieldByName('PRJT_CNT').AsInteger;
          TaskCount := FieldByName('TASK_CNT').AsInteger;
          TotalUserCount := FieldByName('dept_emp_cnt').AsInteger;
          Usage := UserCount / TotalUserCount * 100;
        end;

        Next;
      end;
    end;
  end;

  Result := ObjectToJson(FDPMSInfo);
end;

function TDPMS.GetRMISUserList(AIsMobile: Boolean): RawUTF8;
var
  LSql, LAppCode, LAppName: string;
  i: integer;
begin
  LAppCode := '';

  // RMIS App Code 가져 옴
  LSql := 'SELECT APPCODE FROM DPMS_APP_CODE ' +
          'WHERE APPNAME_E = :param1' ;

  if AIsMobile then
    LAppName := 'M-RMIS'
  else
    LAppName := 'RMIS';

  with DM1.DPMSAppQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(LSql);
    ParamByName('param1').AsString := LAppName;
    Open;

    if RecordCount > 0 then
      LAppCode := FieldByName('APPCODE').AsString;

    if LAppCode <> '' then
    begin

      // RMIS 사용자 리스트 가져 옴
      LSql := 'SELECT A.*, B.APPNAME_K FROM DPMS_USER_APPLICATION A, DPMS_APP_CODE B ' +
              'WHERE A.APPCODE = B.APPCODE ' +
              'AND A.APPCODE = :param1 ' +
              'ORDER BY A.APPCODE' ;

      Close;
      SQL.Clear;
      SQL.Add(LSql);
      ParamByName('param1').AsString := LAppCode;
      Open;

      if RecordCount > 0 then
        FRMISUserInfo.RMISUserCollect.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        with FRMISUserInfo.RMISUserCollect.Add do
        begin
          UserId := FieldByName('USERID').AsString;
        end;

        Next;
      end;
    end;
  end;

  Result := ObjectToJson(FRMISUserInfo);
end;

end.
>>>>>>> .r1752
