unit UnitScheManageDM;

interface

uses
  System.SysUtils, System.Classes, Dialogs, System.StrUtils, DateUtils,
  System.Types,
  mORMot, SynCommons, ScheduleSampleDataModel, HoliDayCollect, UnitTreeGridGanttRecord,
  ProjectBaseClass,
  Data.DB, MemDS, DBAccess, Ora, OraCall, OraTransaction;

const
  CHANGED_ROW_TAG = 'Changed Row';
  CHANGED_ALL_TAG = 'Changed All';

type
  TDM1 = class(TDataModule)
    OraTransaction1: TOraTransaction;
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraQuery2: TOraQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure InitProcess1List(AProcessList: TStringList);
    procedure FinalizeProcess1List(AProcessList: TStringList);
    procedure InitExcludeProcesssList(AExProcessList: TStringList);

    procedure ClearProjList;
  public
    FProjList,
    FExcludeProcesssList: TStringList;
    FDynHimsenJobRelation: R_BaseInfos;
    //일자 순으로 sort되어 저장 되어야 함
    FHoliDayList: THoliDayList;

    //Use mORMot
    function GetProjNoListFrommORMot(AClient: TSQLRest;
      AProjNoList: TStrings): Boolean;
    function GetShipNoListFrommORMot(AClient: TSQLRest;
      AShipNoList: TStrings): Boolean;
    function GetRecordJsonFromProjNoFrommORMot(AClient: TSQLRest; AProjNo: string): string;
    function GetRecordJsonFrommORMot(AClient: TSQLRest; AProjNo: string; ASearchMode: integer;
      ASchAdapt: integer; AIsExcludeProcess: Boolean;var ABeginDate, AEndDate: TDateTime): string;
    function GetBaseInfoFrommORMot(AClient: TSQLRest; var ADynArray:R_BaseInfos; AEngType: string = ''): Boolean;
    function GetHolidayFrommORMot(AClient: TSQLRest): Boolean;

    //Use ODAC
    function GetProjNoListFromODAC(AProjNoList: TStrings): Boolean;
    function GetShipNoListFromODAC(AShipNoList: TStrings): Boolean;
    function GetRecordJsonFromProjNoFromODAC(AProjNo: string): string;
    function GetRecordJsonFromODAC(AProjNo: string; ASearchMode: integer;
      ASchAdapt: integer; AIsExcludeProcess: Boolean;var ABeginDate, AEndDate: TDateTime): string;
    function GetBaseInfoFromODAC(var ADynArray:R_BaseInfos; AEngType: string = ''): Boolean;
    procedure GetProjInfoFromODAC(AProjNo: String; AProjectInfo: TProjectInfo);

    function GetPartNoDescFromODAC(APartNo, AJobCode: string): string;
    function GetPartNoDesc(APartNo: string): string;
    procedure GetNextProcess(AEngineType, AJobCode: RawUtf8; out ANext, ARelType: string);
    procedure AddRecordHoliday2Collect(ARecord: TSQLHolidayRecord; ACollect: THoliDayList);
    //From~To 기간에 휴무일을 반환함 (GanttExclude 포맷)
    function GetGanttExclude(ABeginDate, AEndDate: TDateTime): string;
    function GetProjInfo(AProjNo: string): TProjectInfo;
    procedure SetProjInfo2Class(AQry: TOraQuery; AProjectInfo: TProjectInfo);
    function GetFactoryName(ACode: string): string;
    function GetDeptName(ACode: string): string;
  end;
var
  DM1: TDM1;

implementation

uses UnitStringUtil;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

procedure TDM1.AddRecordHoliday2Collect(ARecord: TSQLHolidayRecord;
  ACollect: THoliDayList);
var
  LItem: THoliDayItem;
begin
  LItem := ACollect.HoliDayCollect.Add;

  LItem.FromDate := ARecord.HolidayDate;
  LItem.Description := ARecord.Description;
  LItem.ToDate := ARecord.UpdateDate;
  LItem.HolidayGubun := ARecord.HolidayGubun;
end;

procedure TDM1.ClearProjList;
var
  i: integer;
begin
  for i := FProjList.Count - 1 downto 0 do
  begin
    FinalizeProcess1List(TProjectInfo(FProjList.Objects[i]).FProcessList);
    TProjectInfo(FProjList.Objects[i]).Free;
  end;

  FProjList.Clear;
end;

procedure TDM1.DataModuleCreate(Sender: TObject);
begin
  FProjList := TStringList.Create;
  FExcludeProcesssList := TStringList.Create;
  FHoliDayList := THoliDayList.Create(nil);
  InitExcludeProcesssList(FExcludeProcesssList);
end;

procedure TDM1.DataModuleDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := FProjList.Count - 1 downto 0 do
  begin
    FinalizeProcess1List(TProjectInfo(FProjList.Objects[i]).FProcessList);
    TProjectInfo(FProjList.Objects[i]).Free;
  end;

  FProjList.Free;
  FExcludeProcesssList.Free;
  FDynHimsenJobRelation := nil;

  FHoliDayList.Free;
end;

procedure TDM1.FinalizeProcess1List(AProcessList: TStringList);
var
  i: integer;
begin
  for i := 0 to AProcessList.Count - 1 do
    AProcessList.Objects[i].Free;

//  AProcessList.Free;
end;

function TDM1.GetBaseInfoFrommORMot(AClient: TSQLRest; var ADynArray:R_BaseInfos;
  AEngType: string): Boolean;
var
  LRecord: TSQLHimsenJobRelation;
  LRec: R_BaseInfo;
  i, DynCount: integer;
  LDynHimsenJobRelationArr: TDynArray;
begin
  if AEngType <> '' then
    LRecord := TSQLHimsenJobRelation.CreateAndFillPrepare(AClient,
      'EngineType = ?', [AEngType])
  else
    LRecord := TSQLHimsenJobRelation.CreateAndFillPrepare(AClient,
      '', []);

  try
    LDynHimsenJobRelationArr.Init(TypeInfo(R_BaseInfos), ADynArray, @DynCount);
    LDynHimsenJobRelationArr.Capacity := 400;

    i := 0;
    while LRecord.FillOne do
    begin
      LRec := GetBaseInfoFrom(LRecord);
      i := LDynHimsenJobRelationArr.Add(LRec);
//      FDynHimsenJobRelationArr.FindAndAddIfNotExisting(LRec);
    end;

//      ShowMessage(IntToStr(LDynHimsenJobRelationArr.Count));
  finally
    LRecord.Free;
  end;
end;

function TDM1.GetBaseInfoFromODAC(var ADynArray: R_BaseInfos;
  AEngType: string): Boolean;
var
  LRec: R_BaseInfo;
  i, DynCount: integer;
  LDynHimsenJobRelationArr: TDynArray;
begin
  if AEngType <> '' then
  begin
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT distinct(PROJNO) p, SUBPROJNO FROM KH15.KTPD212');
      Open;

      if RecordCount > 0 then
      begin
        LDynHimsenJobRelationArr.Init(TypeInfo(R_BaseInfos), ADynArray, @DynCount);
        LDynHimsenJobRelationArr.Capacity := 400;
        i := 0;

        while not eof do
        begin
//          LRec := GetBaseInfoFrom(LRecord);
//          i := LDynHimsenJobRelationArr.Add(LRec);

          Next;
        end;
      end;
    end;
  end;
end;

function TDM1.GetDeptName(ACode: string): string;
begin
  with OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT RPAD(A.DEPT,4,''0'') AS COLM1' +// --부서코드
            '        ,A.DEPTNM AS COLM2 ' +// --부서명
            '        ,A.DEPTNM1 AS COLM3 '+// --부서명 약어
            'FROM    KH15.KTPK051 A ' +
            'WHERE   A.DEPT = :dept');
    ParamByName('dept').AsString := ACode;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('COLM2').AsString;
    end;
  end;
end;

function TDM1.GetFactoryName(ACode: string): string;
begin
  with OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT CODENM FROM KH15.KTPK050 WHERE ORGFLD = ''ASHOPDIV'' AND ORGCD = :c');
    ParamByName('c').AsString := ACode;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('CODENM').AsString;
    end;
  end;

end;

function TDM1.GetGanttExclude(ABeginDate, AEndDate: TDateTime): string;
var
  i: integer;
  LDate, LPrev: TDate;
  LFrom, LTo: TValueRelationship;
begin
  Result := '';
  LDate := 0;

  for i := 0 to FHolidayList.HoliDayCollect.Count - 1 do
  begin
    if FHolidayList.HoliDayCollect.Items[i].Description = '' then
      Continue;//휴무일인 경우에만 아래로

    LFrom := CompareDate(ABeginDate, FHolidayList.HoliDayCollect.Items[i].FromDate);
    LTo := CompareDate(AEndDate, FHolidayList.HoliDayCollect.Items[i].FromDate);

    if ((LFrom = LessThanValue) or (LFrom = EqualsValue)) and
      ((LTo = GreaterThanValue) or (LTo = EqualsValue)) then
    begin
      if (i+1) < FHolidayList.HoliDayCollect.Count then
      begin
        if LDate = 0 then
        begin
          LDate := FHolidayList.HoliDayCollect.Items[i].FromDate;
          Result := Result + 'y#' + FormatDateTime('mm/dd/yyyy', LDate);
        end;

        LPrev := FHolidayList.HoliDayCollect.Items[i].FromDate;

        if FHolidayList.HoliDayCollect.Items[i+1].Description <> '' then
          if DaysBetween(LPrev, FHolidayList.HoliDayCollect.Items[i+1].FromDate) = 1 then
            continue;
      end
      else
      begin
        if LDate = 0 then
        begin
          LDate := FHolidayList.HoliDayCollect.Items[i].FromDate;
          Result := Result + 'y#' + FormatDateTime('mm/dd/yyyy', LDate);
        end;
      end;

      Result := Result + '~' + FormatDateTime('mm/dd/yyyy', IncDay(FHolidayList.HoliDayCollect.Items[i].FromDate)) + '#1;';
      LDate := 0;
    end;
  end;

//  Result := Result.TrimRight([';']);
end;

function TDM1.GetHolidayFrommORMot(AClient: TSQLRest): Boolean;
var
  LRecord: TSQLHolidayRecord;
begin
  FHolidayList.HoliDayCollect.Clear;
  LRecord := TSQLHolidayRecord.CreateAndFillPrepare(AClient, '', []);
  try
    while LRecord.FillOne do
    begin
      AddRecordHoliday2Collect(LRecord, FHolidayList);
    end;
  finally
    LRecord.Free;
  end;
end;

procedure TDM1.GetNextProcess(AEngineType, AJobCode: RawUtf8; out ANext, ARelType: string);
var
  i: integer;
  LRec: R_BaseInfo;
  LUtf8: RawUtf8;
  LDynHimsenJobRelationArr: TDynArray;
begin
  LDynHimsenJobRelationArr.Init(TypeInfo(R_BaseInfos), FDynHimsenJobRelation);

  for i := 0 to LDynHimsenJobRelationArr.Count - 1 do
  begin
    LRec := R_BaseInfo(LDynHimsenJobRelationArr.ElemPtr(i)^);

    if (LRec.FEngineType = AEngineType) then
    begin
      LUtf8 := LRec.FPPartNo + '-' + LRec.FPJobCode;

      if LUtf8 = AJobCode then
      begin
        ANext := UTF8ToString(LRec.FAPartNo + '-' + LRec.FAJobCode);
        ARelType := UTF8ToString(LRec.FRelType);
      end;
    end;
  end;
end;

function TDM1.GetPartNoDesc(APartNo: string): string;
begin
  Result := LeftStr(APartNo,3);

  if Result = 'AP0' then
    Result := '선조립'
  else if Result = 'JP0' then
    Result := '종조립'
  else if Result = 'TR0' then
    Result := '출고준비'
  else
    Result := '시운전';
end;

function TDM1.GetPartNoDescFromODAC(APartNo, AJobCode: string): string;
begin
  with OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT Max(JBCODENM) j FROM KH15.KTPK300 WHERE PROJGB = "B" and ');
    SQL.Add('       PARTNO = :p and JBCODE = :c ');
    ParamByName('p').AsString := APartNo;
    ParamByName('c').AsString := APartNo;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('j').AsString;
  end;
end;

function TDM1.GetProjInfo(AProjNo: string): TProjectInfo;
var
  i: integer;
begin
  for i := 0 to FProjList.Count - 1 do
  begin
    if AProjNo = FProjList.Strings[i] then
    begin
      Result := FProjList.Objects[i] as TProjectInfo;
      Break;
    end;
  end;

  if Assigned(Result) then
  begin
    if not Result.GetDataCompleted then
      GetProjInfoFromODAC(AProjNo, Result);
  end;
end;

procedure TDM1.GetProjInfoFromODAC(AProjNo: String; AProjectInfo: TProjectInfo);
var
  LProjNo: string;
begin
  LProjNo := AProjNo;

  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT  ' +
            '     Z.PROJNO, Z.SUBPROJNO, Z.AFACTORY, Z.TFACTORY, Z.SJDEPT, Z.SWDEPT, Z.JJDEPT, Z.JPTYPE , Z.QTY ' +
            '     ,Z.SHIPNO, Z.OOWNERNM ,Z.SCLASS ' + //Z.MPCODE ,
            '     ,TO_CHAR(Z.ASSYST,''YYYYMMDD'') AS ASSYST ' +
            '     ,TO_CHAR(Z.TESTST,''YYYYMMDD'') AS TESTST ' +
            '     ,Z.DELDATE ' +
            '     ,TO_CHAR(Z.GLFDATE,''YYYYMMDD'') AS GLFDATE ' +
            '     ,Z.BIGO ,KH15.SFN_EMPNM(Z.EMPNO) AS EMPNO ' +
            '     ,TO_CHAR(Z.REDATE,''YYYYMMDD'')  AS REDATE ' +
            '     ,Z.MODULE1,Z.MODULE2,Z.MODULE3,Z.MODULE4 ' +
            'FROM ' +
            '( ' +
            '    SELECT ' +
            '         A.PROJNO ' +
            '         ,A.SUBPROJNO ' +
            '         ,( ' +
            '           SELECT SHOPDIV FROM KH15.KTPD001A ' +
            '           WHERE PROJNO = A.PROJNO ' +
            '              AND SUBPROJNO = A.SUBPROJNO ' +
            '              AND PARTNO = ( SELECT CDNM1 FROM KH15.KTPK050 ' +
            '                             WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                   AND ORGCD = ''CODE4'' ' +
            '                            ) ' +
            '                            AND PROCNO = ( SELECT CDNM2 FROM KH15.KTPK050 ' +
            '                                           WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                                 AND ORGCD = ''CODE4'' ' +
            '                                         ) ' +
            '           )  AS AFACTORY ' + //  --조립 공장 중일정 참조
            '           , ( ' +
            '              SELECT SHOPDIV FROM KH15.KTPD001A ' +
            '              WHERE PROJNO = A.PROJNO ' +
            '                    AND SUBPROJNO = A.SUBPROJNO ' +
            '                    AND PARTNO = ( SELECT CDNM1 FROM KH15.KTPK050 ' +
            '                                   WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                         AND ORGCD = ''CODE5'' ' +
            '                                 ) ' +
            '                    AND PROCNO = ( SELECT CDNM2 FROM KH15.KTPK050 ' +
            '                                   WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                         AND ORGCD = ''CODE5'' ' +
            '                                 ) ' +
            '              )  AS TFACTORY ' +  //--시운전 공장 중일정 참조
            '            , ( ' +
            '               SELECT JBDEPT FROM KH15.KTPD001A ' +
            '               WHERE PROJNO = A.PROJNO ' +
            '                     AND SUBPROJNO = A.SUBPROJNO ' +
            '                     AND PARTNO = ( SELECT CDNM1 FROM KH15.KTPK050 ' +
            '                                    WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                          AND ORGCD = ''CODE1'' ' +
            '                                  ) ' +
            '                     AND PROCNO = ( SELECT CDNM2 FROM KH15.KTPK050 ' +
            '                                    WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                          AND ORGCD = ''CODE1'' ' +
            '                                  ) ' +
            '              ) AS SJDEPT ' + // --선조립 부서 중일정 참조
            '            , ( ' +
            '               SELECT JBDEPT FROM KH15.KTPD001A ' +
            '               WHERE PROJNO = A.PROJNO ' +
            '                     AND SUBPROJNO = A.SUBPROJNO ' +
            '                     AND PARTNO = ( SELECT CDNM1 FROM KH15.KTPK050 ' +
            '                                    WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                          AND ORGCD = ''CODE2'' ' +
            '                                  ) ' +
            '                     AND PROCNO = ( SELECT CDNM2 FROM KH15.KTPK050 ' +
            '                                    WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                          AND ORGCD = ''CODE2'' ' +
            '                                  ) ' +
            '               ) AS SWDEPT ' + // --수압 부서 중일정 참조
            '             ,NVL(E.JJDEPT,( ' +
            '                            SELECT JBDEPT FROM KH15.KTPD001A ' +
            '                            WHERE PROJNO = A.PROJNO ' +
            '                                  AND SUBPROJNO = A.SUBPROJNO ' +
            '                                  AND PARTNO = ( SELECT CDNM1 FROM KH15.KTPK050 ' +
            '                                                 WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                                       AND ORGCD = ''CODE3'' ' +
            '                                               ) ' +
            '                                  AND PROCNO = ( SELECT CDNM2 FROM KH15.KTPK050 ' +
            '                                                 WHERE ORGFLD = ''BAACTSCH'' ' +
            '                                                       AND ORGCD = ''CODE3'' ' +
            '                                               ) ' +
            '                           ) ' +
            '                   ) AS JJDEPT ' + // --종조립 부서 중일정 참조
            '              ,A.JPTYPE ' + // -- 엔진타입
            '              , A.QTY ' + // -- 대수
            '              ,B.SHIPNO ' + // -- 호선
            '              ,B.OOWNERNM ' + // -- 선주
            '              , (B.GDSC1 || '' '' || B.GDSC2) AS SCLASS ' + // -- 선급
            '              ,B.DELDATE ' + // -- 납기
            '              ,C.ASSYST ' + // -- 착수일
            '              ,C.TESTST ' + //  -- 공시일
//            '              ,'' '' AS MPCODE ' + //    -- 용도 ( 아직 미구현 )
            '              ,D.MODULE1,D.MODULE2,D.MODULE3,D.MODULE4 ' + //   -- MODULE 정보
            '              ,E.GLFDATE ' + // -- 발전기소요일
            '              ,E.BIGO ' + //  -- 비고(특기사항)
            '              ,E.EMPNO,E.REDATE ' + //  -- 수정사번 , 수정일자
            '    FROM KH15.KTPD211 A, KH15.KTPA001 B, KH15.KTPB001 C, KH15.KTPD215 D, KH15.KTPD216 E  ' +
            '    WHERE A.PROJNO IS NOT NULL ' +
            '          AND A.PROJNO = B.PROJNO ' +
            '          AND A.PROJNO = C.PROJNO ' +
            '          AND A.SUBPROJNO = C.SUBPROJNO ' +
            '          AND A.PROJNO = D.PROJNO(+) ' +
            '          AND A.PROJNO = E.PROJNO(+) ' +
            '          AND A.SUBPROJNO = E.SUBPROJNO(+) ' +
//            '          AND (  ( NVL( :ACC_SHIPNO,''ALL'') = ''ALL'' OR :ACC_SHIPNO = ''ALL'' ) OR ( :ACC_SHIPNO > '' '' AND B.SHIPNO = :ACC_SHIPNO )  ) ' +
//            '          AND DECODE(:ACC_GUBUN,''A'',C.TESTST,''B'',C.TESTST,C.ASSYST) BETWEEN TO_DATE(:ACC_SDATE,''YYYYMMDD'') AND  TO_DATE(:ACC_FDATE,''YYYYMMDD'') ' +
            ') Z ' +
            'WHERE Z.PROJNO IS NOT NULL ' +
            '      AND Z.PROJNO = :ppp AND Z.SUBPROJNO = :sss ' +
            '      AND (  ( NVL( :ACC_AFACTORY,''ALL'') = ''ALL'' OR :ACC_AFACTORY = ''ALL'' ) ' +
            '               OR ( :ACC_AFACTORY > '' '' AND Z.AFACTORY = :ACC_AFACTORY ) ' + // -- 조립공장
            '          ) ' +
            '      AND (  ( NVL( :ACC_TFACTORY,''ALL'') = ''ALL'' OR :ACC_TFACTORY = ''ALL'' ) ' +
            '               OR ( :ACC_TFACTORY > '' '' AND Z.TFACTORY = :ACC_TFACTORY ) ' +// -- 시운전공장
            '          ) ' +
            '      AND (  ( NVL( :ACC_SJDEPT,''ALL'') = ''ALL'' OR :ACC_SJDEPT = ''ALL'' ) ' +
            '               OR ( :ACC_SJDEPT > '' '' AND Z.SJDEPT = :ACC_SJDEPT ) ' +// -- 선조립담당
            '          ) ' +
            '      AND (  ( NVL( :ACC_SWDEPT,''ALL'') = ''ALL'' OR :ACC_SWDEPT = ''ALL'' ) ' +
            '               OR ( :ACC_SWDEPT > '' '' AND Z.SWDEPT = :ACC_SWDEPT ) ' +// -- 수압담당
            '          ) ' +
            '      AND (  ( NVL( :ACC_JJDEPT,''ALL'') = ''ALL'' OR :ACC_JJDEPT = ''ALL'' ) ' +
            '               OR ( :ACC_JJDEPT > '' '' AND Z.JJDEPT = :ACC_JJDEPT ) ' +// -- 종조립담당
            '          ) ' +
            'ORDER BY DECODE(:ACC_GUBUN,''A'',Z.TESTST,''B'',Z.TESTST, Z.ASSYST) , Z.SHIPNO, Z.PROJNO, Z.SUBPROJNO ASC ,LENGTH(Z.JPTYPE) DESC'
            );

    ParamByName('ppp').AsString := strToken(LProjNo, '-');
    ParamByName('sss').AsString := LProjNo;
//    ParamByName('ACC_SHIPNO').AsString := '';
//    ParamByName('ACC_GUBUN').AsString := '';
//    ParamByName('ACC_SDATE').AsString := '';
//    ParamByName('ACC_FDATE').AsString := '';
    ParamByName('ACC_AFACTORY').AsString := '';
    ParamByName('ACC_TFACTORY').AsString := '';
    ParamByName('ACC_SJDEPT').AsString := '';
    ParamByName('ACC_SWDEPT').AsString := '';
    ParamByName('ACC_JJDEPT').AsString := '';

    Open;

    if RecordCount > 0 then
      SetProjInfo2Class(OraQuery1, AProjectInfo);
  end;
end;

function TDM1.GetProjNoListFrommORMot(AClient: TSQLRest;
  AProjNoList: TStrings): Boolean;
var
  LRecord: TSQLScheduleSampleRecord;
begin
  LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
    '', []);
  try
    AProjNoList.Clear;
    AProjNoList.Add('');
    while LRecord.FillOne do
    begin
      if AProjNoList.IndexOf(LRecord.ProjNo) = -1 then
        AProjNoList.Add(LRecord.ProjNo);
    end;
  finally
    LRecord.Free;
  end;
end;

function TDM1.GetProjNoListFromODAC(AProjNoList: TStrings): Boolean;
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT distinct(PROJNO) p, SUBPROJNO FROM KH15.KTPD212');
    Open;

    if RecordCount > 0 then
    begin
      AProjNoList.Clear;
      AProjNoList.Add('');

      while not eof do
      begin
        AProjNoList.Add(FieldByName('p').AsString + '-' + FieldByName('SUBPROJNO').AsString);

        Next;
      end;
    end;
  end;
end;

function TDM1.GetRecordJsonFromProjNoFrommORMot(AClient: TSQLRest;
  AProjNo: string): string;
var
  LRecord: TSQLScheduleSampleRecord;
  LV: Variant;
  LUtf8: RawUTF8;
  LOptions: TDocVariantOptions;
  i: integer;
  LStr: string;
  LOnce: Boolean;
begin
  LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
    'ProjNo = ?', [AProjNo]);
  try
    TDocVariant.New(LV, [dvoSerializeAsExtendedJson]);
    LUtf8 := '';
    i := 0;
    while LRecord.FillOne do
    begin
//      if not LOnce then
//      begin
//        LOnce := True;
//        i := i + 1;
//        LV.No := IntToStr(i);
//        LV.T := LRecord.ProjNo;
//        FormatSettings.DateSeparator := '/';
//        LV.S := FormatDateTime('dd/mm/yyyy',LRecord.StartDateActual);
//        LV.E := FormatDateTime('dd/mm/yyyy',LRecord.EndDateActual);
//        LV.C := '100';
//        LV.D := '';
//        LV.L := LRecord.ProjNo;
//        LUtf8 := LUtf8 + VariantSaveJson(LV) + ',';
//      end;

      LStr := FormatDateTime('yyyy',LRecord.StartDateActual);
      if LStr = '1899' then
        Continue;

      LStr := FormatDateTime('yyyy',LRecord.EndDateActual);
      if LStr = '1899' then
        Continue;

      i := i + 1;
      LV.Id := IntToStr(i);
      LV.T := LRecord.Description;
      FormatSettings.DateSeparator := '/';
      LV.S := FormatDateTime('mm/dd/yyyy',LRecord.StartDateActual);
      LV.E := FormatDateTime('mm/dd/yyyy',LRecord.EndDateActual);
      LV.C := '100';
      LV.D := '';

      LStr := LeftStr(LRecord.ActCode,3);

      if LStr = 'AP0' then
        LStr := '선조립'
      else if LStr = 'JP0' then
        LStr := '종조립'
      else
        LStr := '시운전';

      LV.L := LRecord.ProjNo + '/' + LStr;
//      LUtf8 := VariantSaveJson(LV);
      LUtf8 := LUtf8 + VariantSaveJson(LV) + ',';
//      LUtf8 := LRecord.GetJSONValues(True,False,soSelect);
    end;

//    LOptions := [dvoSerializeAsExtendedJson];
//    LV := LRecord.GetSimpleFieldsAsDocVariant(False, @LOptions);
//    LUtf8 := LRecord.GetSQLValues;
//    LRecord.GetAsDocVariant(False,ALL_FIELDS,LV,@LOptions);
    Result := 'Body: [[' +  Utf8ToString(LUtf8) + ']]';
  finally
    LRecord.Free;
  end;
end;

function TDM1.GetRecordJsonFromProjNoFromODAC(AProjNo: string): string;
var
  LRecord: TSQLScheduleSampleRecord;
  LV: Variant;
  LUtf8: RawUTF8;
  LOptions: TDocVariantOptions;
  i: integer;
  LStr: string;
  LOnce: Boolean;
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM KH15.KTPD212 WHERE ProjNo = :p ');
    ParamByName('p').AsString := AProjNo;
    Open;

    if RecordCount > 0 then
    begin
      TDocVariant.New(LV, [dvoSerializeAsExtendedJson]);
      LUtf8 := '';
      i := 0;

      while not eof do
      begin
        LStr := FormatDateTime('yyyy',FieldByName('SREVSDATE').AsDateTime);
        if LStr = '1899' then
          Continue;

        LStr := FormatDateTime('yyyy',FieldByName('SREVFDATE').AsDateTime);
        if LStr = '1899' then
          Continue;

        i := i + 1;
        LV.Id := IntToStr(i);
        LV.T := FieldByName('Description').AsString;
        FormatSettings.DateSeparator := '/';
        LV.S := FormatDateTime('mm/dd/yyyy',FieldByName('SREVSDATE').AsDateTime);
        LV.E := FormatDateTime('mm/dd/yyyy',FieldByName('SREVFDATE').AsDateTime);
        LV.C := '100';
        LV.D := '';

        LStr := GetPartNoDesc(FieldByName('PARTNO').AsString);

        LV.L := LRecord.ProjNo + '/' + LStr;
        LUtf8 := LUtf8 + VariantSaveJson(LV) + ',';

        Next;
      end;

      Result := 'Body: [[' +  Utf8ToString(LUtf8) + ']]';
    end;
  end;
end;

function TDM1.GetRecordJsonFrommORMot(AClient: TSQLRest;
  AProjNo: string; ASearchMode: integer; ASchAdapt: integer;
  AIsExcludeProcess: Boolean; var ABeginDate,AEndDate: TDateTime): string;
var
  LRecord: TSQLScheduleSampleRecord;
  LV: Variant;
  LUtf8, LWhere: RawUTF8;
  LOptions: TDocVariantOptions;
  i, j, k, LIdx: integer;
  LStr, LData, LNext, LRelType: string;
  LNoData, LNoData2: Boolean;
  LStrList: TStringList;
  LStart, LEnd: TDateTime;
begin
  LWhere := '';
  LUtf8 := '';

  case ASearchMode of
    0: //납기
    begin
      LWhere := ' DeliveryDate >= ? AND DeliveryDate <= ?';
    end;
    1: //계획 착수일
    begin
      LWhere := ' StartDatePlan >= ? AND StartDatePlan <= ?';
    end;
    2: //계획 완료일
    begin
      LWhere := ' EndDatePlan >= ? AND EndDatePlan <= ?';
    end;
  end;

  if AProjNo <> '' then
  begin
    LUtf8 := 'ProjNo = ? ';

    if LWhere <> '' then
      LUtf8 := LUtf8 + ' AND ';
  end;

  LUtf8 := LUtf8 + LWhere + ' order by StartDatePlan ' ;

  if (AProjNo <> '') and (ASearchMode >= 0) then
    LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
      LUtf8, [AProjNo, DateToSQL(ABeginDate), DateToSQL(AEndDate)])
  else
  if ASearchMode >= 0 then
    LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
      LUtf8, [DateToSQL(ABeginDate), DateToSQL(AEndDate)])
  else
  if AProjNO <> '' then
    LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
      'ProjNo = ?', [AProjNo]);

  try
    TDocVariant.New(LV, [dvoSerializeAsExtendedJson]);
    LUtf8 := '';
    i := 0;
    Result := 'Body: [[';
    ABeginDate := now;
    AEndDate := 0;
    FProjList.Clear;

    while LRecord.FillOne do
    begin
      LV.Clear;

      if AIsExcludeProcess then
        if FExcludeProcesssList.IndexOf(LRecord.ActCode) <> -1 then
          continue;

      case TAdaptSchedule(ASchAdapt) of
        asPlan: begin
          LStart := LRecord.StartDatePlan;
          LEnd := LRecord.EndDatePlan;
        end;

        asPredict: begin
          LStart := LRecord.StartDatePredict;
          LEnd := LRecord.EndDatePredict;
        end;

        asActual: begin
          LStart := LRecord.StartDateActual;
          LEnd := LRecord.EndDateActual;
        end;
      end;

      LStr := FormatDateTime('yyyy',LStart);
      LNoData := LStr = '1899';

      LStr := FormatDateTime('yyyy',LEnd);
      LNoData2 := LStr = '1899';

      if not LNoData then
        if LStart < ABeginDate then
          ABeginDate := LStart;

      if not LNoData2 then
        if LEnd > AEndDate then
          AEndDate := LEnd;

      LStr := Utf8ToString(LRecord.ProjNo);
      LIdx := FProjList.IndexOf(LStr);

      if LIdx = -1 then
      begin
        LIdx := FProjList.Add(LStr);
        LStrList := TStringList.Create; //공정 리스트(ProcessList)
        FProjList.Objects[LIdx] := LStrList;
        InitProcess1List(LStrList);
        i := i + 1;
      end;

      LV.id := IntToStr(i) + '_' + LRecord.ActCode;
      LV.Process := LRecord.Description;
      LV.GANTTGanttHtmlRight := LRecord.Description;
      FormatSettings.DateSeparator := '/';

      if FormatDateTime('yyyy',LRecord.StartDatePlan) <> '1899' then
        LV.START := FormatDateTime('mm/dd/yyyy',LRecord.StartDatePlan);

      if FormatDateTime('yyyy',LRecord.EndDatePlan) <> '1899' then
        LV.ENDDATE := FormatDateTime('mm/dd/yyyy',LRecord.EndDatePlan);

      if FormatDateTime('yyyy',LRecord.StartDatePredict) <> '1899' then
        LV.START1 := FormatDateTime('mm/dd/yyyy',LRecord.StartDatePredict);

      if FormatDateTime('yyyy',LRecord.EndDatePredict) <> '1899' then
        LV.ENDDATE1 := FormatDateTime('mm/dd/yyyy',LRecord.EndDatePredict);

      if FormatDateTime('yyyy',LRecord.StartDateActual) <> '1899' then
        LV.START2 := FormatDateTime('mm/dd/yyyy',LRecord.StartDateActual);

      if FormatDateTime('yyyy',LRecord.EndDateActual) <> '1899' then
        LV.ENDDATE2 := FormatDateTime('mm/dd/yyyy',LRecord.EndDateActual);

      LV.COMPLETE := '100';
//      LV.FLAGS := LV.ENDDATE;
      LNext := '';
      LRelType := '';
      GetNextProcess(LRecord.EngineType, LRecord.ActCode, LNext, LRelType);

      if (LNext <> '') and (LRelType <> '') then
      begin
        if LRelType = 'FS' then
          LV.DEC := IntToStr(i) + '_' + LNext
        else if LRelType = 'SS' then
          LV.ANC := IntToStr(i) + '_' + LNext;
      end;

      LData := Utf8ToString(VariantSaveJson(LV));

      if i > 1 then
        LV.ANC := IntToStr(i-1);

      LStr := GetPartNoDesc(LRecord.ActCode);

      j := TStringList(FProjList.Objects[LIdx]).IndexOf(LStr);

      if j <> -1 then
      begin    //세부공정
        TStringList(TStringList(FProjList.Objects[LIdx]).Objects[j]).Add(LRecord.ActCode + '=' + LData);
      end;
    end;

//    for k := 0 to 0 do
    for k := 0 to FProjList.Count - 1 do
    begin
      Result := Result + '{Def:' + QuotedStr('SUM','"') + ', Process:"'+
        FProjList.Strings[k] + '", Items:[';

      for i := 0 to TStringList(FProjList.Objects[k]).Count - 1 do
      begin
        Result := Result + '{Def:' + QuotedStr('SUMEDIT','"') + ', Process:"' +
          TStringList(FProjList.Objects[k]).Strings[i] + '", Items:[';

        for j := 0 to TStringList(TStringList(FProjList.Objects[k]).Objects[i]).Count - 1 do
        begin
          Result := Result + TStringList(TStringList(FProjList.Objects[k]).Objects[i]).ValueFromIndex[j] + ',';
        end;

        Result := Result.TrimRight([',']);
        Result := Result + ']},';
      end;

      Result := Result.TrimRight([',']) + ']},';
    end;
    Result := Result.TrimRight([',']);
    Result := Result + ']]';
  finally
    LRecord.Free;
  end;
end;

function TDM1.GetRecordJsonFromODAC(AProjNo: string; ASearchMode,
  ASchAdapt: integer; AIsExcludeProcess: Boolean; var ABeginDate,
  AEndDate: TDateTime): string;
var
  LUtf8, LWhere: RawUTF8;
  LV: Variant;
  i, j, k, LIdx: integer;
  LData, LNext, LRelType, LActCode, LProjNo, LSubProjNo, LStr: string;
  LPartNo, LJobCode: string;
  LStart, LEnd: TDateTime;
  LNoData, LNoData2: Boolean;
  LProjectInfo: TProjectInfo;
begin
  LWhere := '';
  LUtf8 := '';

  LProjNo := strToken(AProjNo, '-');
  LSubProjNo := AProjNo;

  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT subtbl.*, b.JPTYPE ' +
            'FROM KH15.KTPD211 b, ' +
            '           ( ' +
            '           SELECT a.*, c.JBCODENM FROM KH15.KTPD212 a, KH15.KTPK300 c ' +
            '           WHERE a.PARTNO = c.PARTNO and a.JBCODE = c.JBCODE and c.PROJGB = ''B'' ' +
            '           order by ZREVSDATE, a.projno, a.subprojno) subtbl ' +
            'WHERE subtbl.ProjNo = :p and subtbl.SUBPROJNO = :s and ' +
            '     subtbl.ProjNo = b.ProjNo and subtbl.SUBPROJNO = b.SUBPROJNO '
    );

    if LProjNo <> '' then
    begin
      ParamByName('p').AsString := LProjNo;
      ParamByName('s').AsString := LSubProjNo;
    end
    else
      SQL.Text := ReplaceStr(SQL.Text, 'subtbl.ProjNo = :p and subtbl.SUBPROJNO = :s and', '');

    case ASearchMode of
      1: //공시일
      begin
        SQL.Add(' AND b.TESTST >= :beginDate AND b.TESTST <= :endDate ');
//        SQL.Add(' and ( ZREVSDATE <= :beginDate  ' +
//                ' AND ZREVFDATE >= :beginDate   ' +
//                ' AND ZREVSDATE <= :endDate  ' +
//                ' AND ZREVFDATE <= :endDate  ' +
//                ' OR ZREVSDATE >= :beginDate   ' +
//                ' AND ZREVFDATE >= :beginDate  '  +
//                ' AND ZREVSDATE <= :endDate  '  +
//                ' AND ZREVFDATE <= :endDate  ' +
//                ' OR ZREVSDATE >= :beginDate  ' +
//                ' AND ZREVFDATE >= :beginDate  ' +
//                ' AND ZREVSDATE <= :endDate  ' +
//                ' AND ZREVFDATE >= :endDate  ' +
//                ' OR ZREVSDATE <= :beginDate  ' +
//                ' AND ZREVFDATE >= :beginDate  ' +
//                ' AND ZREVSDATE <= :endDate  ' +
//                ' AND ZREVFDATE >= :endDate ) ');
      end;
      2: //착수일
      begin
        SQL.Add(' AND b.ASSYST >= :beginDate AND b.ASSYST <= :endDate ');
//        SQL.Add(' and ZREVSDATE >= :d1 AND ZREVSDATE <= :d2 ');
      end;
//      2: //계획 완료일
//      begin
//        SQL.Add(' and ZREVFDATE >= :d1 AND ZREVFDATE <= :d2 ');
//      end;
      else
      begin

      end;
    end;

    SQL.Add(' ORDER BY subtbl.ProjNo ');

    if ASearchMode > 0 then
    begin
      ParamByName('beginDate').AsDateTime := ABeginDate;
      ParamByName('endDate').AsDateTime := AEndDate;
    end;

    Open;

    if RecordCount > 0 then
    begin

      TDocVariant.New(LV, [dvoSerializeAsExtendedJson]);
      LUtf8 := '';
      i := 0;
      Result := 'Body: [[';
      ABeginDate := now;
      AEndDate := 0;
      ClearProjList;

      while not eof do
      begin
        LV.Clear;

        LPartNo := FieldByName('PARTNO').AsString;
        LJobCode := FieldByName('JBCODE').AsString;
        LActCode := LPartNo + '-' + LJobCode;

        if AIsExcludeProcess then
        begin
          if FExcludeProcesssList.IndexOf(LActCode) <> -1 then
          begin
            Next;
            continue;
          end;
        end;

        case TAdaptSchedule(ASchAdapt) of
          asPlan: begin
            LStart := FieldByName('ZREVSDATE').AsDateTime;
            LEnd := FieldByName('ZREVFDATE').AsDateTime;
          end;

          asPredict: begin
            LStart := FieldByName('YREVSDATE').AsDateTime;
            LEnd := FieldByName('YREVFDATE').AsDateTime;
          end;

          asActual: begin
            LStart := FieldByName('SREVSDATE').AsDateTime;
            LEnd := FieldByName('SREVFDATE').AsDateTime;
          end;
        end;

        LStr := FormatDateTime('yyyy',LStart);
        LNoData := LStr = '1899';

        LStr := FormatDateTime('yyyy',LEnd);
        LNoData2 := LStr = '1899';

        if not LNoData then
          if LStart < ABeginDate then
            ABeginDate := LStart;

        if not LNoData2 then
          if LEnd > AEndDate then
            AEndDate := LEnd;

        LProjNo := Utf8ToString(FieldByName('PROJNO').AsString + '-' + FieldByName('SUBPROJNO').AsString);
        LIdx := FProjList.IndexOf(LProjNo);

        if LIdx = -1 then
        begin
          LIdx := FProjList.Add(LProjNo);
//          LStrList := TStringList.Create; //공정 리스트(ProcessList)
          LProjectInfo := TProjectInfo.Create(nil);
          FProjList.Objects[LIdx] := LProjectInfo;
          InitProcess1List(LProjectInfo.FProcessList);
          i := i + 1;
        end;

        LV.id := IntToStr(i) + '_' + LActCode;
        LV.Process := FieldByName('JBCODENM').AsString;//GetPartNoDescFromODAC(LPartNo, LJobCode);
        LV.GANTTGanttHtmlRight := LV.Process;
        FormatSettings.DateSeparator := '/';

        if FormatDateTime('yyyy',FieldByName('ZREVSDATE').AsDateTime) <> '1899' then
          LV.START := FormatDateTime('mm/dd/yyyy',FieldByName('ZREVSDATE').AsDateTime);

        if FormatDateTime('yyyy',FieldByName('ZREVFDATE').AsDateTime) <> '1899' then
          LV.ENDDATE := FormatDateTime('mm/dd/yyyy',FieldByName('ZREVFDATE').AsDateTime);

        if FormatDateTime('yyyy',FieldByName('REVSDATE').AsDateTime) <> '1899' then
          LV.START1 := FormatDateTime('mm/dd/yyyy',FieldByName('REVSDATE').AsDateTime);

        if FormatDateTime('yyyy',FieldByName('REVFDATE').AsDateTime) <> '1899' then
          LV.ENDDATE1 := FormatDateTime('mm/dd/yyyy',FieldByName('REVFDATE').AsDateTime);

        if FormatDateTime('yyyy',FieldByName('SREVSDATE').AsDateTime) <> '1899' then
          LV.START2 := FormatDateTime('mm/dd/yyyy',FieldByName('SREVSDATE').AsDateTime);

        if FormatDateTime('yyyy',FieldByName('SREVFDATE').AsDateTime) <> '1899' then
          LV.ENDDATE2 := FormatDateTime('mm/dd/yyyy',FieldByName('SREVFDATE').AsDateTime);

        LV.COMPLETE := '100';
  //      LV.FLAGS := LV.ENDDATE;
        LNext := '';
        LRelType := '';

//        GetNextProcess(FieldByName('etype').AsString, LActCode, LNext, LRelType);
//        if (LNext <> '') and (LRelType <> '') then
//        begin
//          if LRelType = 'FS' then
//            LV.DEC := IntToStr(i) + '_' + LNext
//          else if LRelType = 'SS' then
//            LV.ANC := IntToStr(i) + '_' + LNext;
//        end;

        LV.DEC := IntToStr(i) + '_' + FieldByName('MPARTNO').AsString + '-' + FieldByName('MJBCODE').AsString;
        LData := Utf8ToString(VariantSaveJson(LV));

        if i > 1 then
          LV.ANC := IntToStr(i-1);

        LStr := GetPartNoDesc(FieldByName('PARTNO').AsString);
        j := TProjectInfo(FProjList.Objects[LIdx]).FProcessList.IndexOf(LStr);

        if j <> -1 then
        begin    //세부공정
          TStringList(TProjectInfo(FProjList.Objects[LIdx]).FProcessList.Objects[j]).Add(LActCode + '=' + LData);
        end;

        Next;
      end;//while

//      GetProjInfoFromODAC(FProjList);

      for k := 0 to FProjList.Count - 1 do
      begin
        Result := Result + '{Def:' + QuotedStr('SUM','"') + ', Process:"'+
          FProjList.Strings[k] + '", Items:[';

        for i := 0 to TProjectInfo(FProjList.Objects[k]).FProcessList.Count - 1 do
        begin
          Result := Result + '{Def:' + QuotedStr('SUMEDIT','"') + ', Process:"' +
            TProjectInfo(FProjList.Objects[k]).FProcessList.Strings[i] + '", Items:[';

          for j := 0 to TStringList(TProjectInfo(FProjList.Objects[k]).FProcessList.Objects[i]).Count - 1 do
          begin
            Result := Result + TStringList(TProjectInfo(FProjList.Objects[k]).FProcessList.Objects[i]).ValueFromIndex[j] + ',';
          end;

          Result := Result.TrimRight([',']);
          Result := Result + ']},';
        end;

        Result := Result.TrimRight([',']) + ']},';
      end;

      Result := Result.TrimRight([',']);
      Result := Result + ']]';
    end;
  end;
end;

function TDM1.GetShipNoListFrommORMot(AClient: TSQLRest;
  AShipNoList: TStrings): Boolean;
var
  LRecord: TSQLScheduleSampleRecord;
begin
  LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
    '', []);
  try
    AShipNoList.Clear;
    AShipNoList.Add('');
    while LRecord.FillOne do
    begin
      if AShipNoList.IndexOf(LRecord.ShipNo) = -1 then
        AShipNoList.Add(LRecord.ShipNo);
    end;
  finally
    LRecord.Free;
  end;
end;

function TDM1.GetShipNoListFromODAC(AShipNoList: TStrings): Boolean;
begin
//  with OraQuery1 do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('SELECT distinct(PROJNO) p, SUBPROJNO FROM KH15.KTPD212');
//    Open;
//
//    if RecordCount > 0 then
//    begin
//      AProjNoList.Clear;
//      AProjNoList.Add('');
//
//      while not eof do
//      begin
//        AProjNoList.Add(FieldByName('p').AsString + '-' + FieldByName('SUBPROJNO').AsString);
//
//        Next;
//      end;
//    end;
//  end;
//
//  LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
//    '', []);
//  try
//    AShipNoList.Clear;
//    AShipNoList.Add('');
//    while LRecord.FillOne do
//    begin
//      if AShipNoList.IndexOf(LRecord.ShipNo) = -1 then
//        AShipNoList.Add(LRecord.ShipNo);
//    end;
//  finally
//    LRecord.Free;
//  end;
end;

procedure TDM1.InitExcludeProcesssList(AExProcessList: TStringList);
begin
  AExProcessList.Clear;
  AExProcessList.Add('AP0000-A0600'); //Big End 조립
  AExProcessList.Add('JP0001-G0100'); //소구경 PIPE 작업
  AExProcessList.Add('JP0001-S0100'); //소구경 PIPE FINAL 작업
  AExProcessList.Add('JP0001-L0600'); //대구경 PIPE FINAL 작업
  AExProcessList.Add('JP0001-W0700'); //전장작업
  AExProcessList.Add('TR0001-K0300'); //중형엔진포장(제작)
  AExProcessList.Add('TG0001-T0300'); //시운전설비 해체
  AExProcessList.Add('QQ0000-T0200'); //COMMISSION
end;

procedure TDM1.InitProcess1List(AProcessList: TStringList);
var
  i: integer;
begin
  AProcessList.Clear;

  i := AProcessList.Add('선조립');
  AProcessList.Objects[i] := TStringList.Create;
  i := AProcessList.Add('종조립');
  AProcessList.Objects[i] := TStringList.Create;
  i := AProcessList.Add('시운전');
  AProcessList.Objects[i] := TStringList.Create;
  i := AProcessList.Add('출고준비');
  AProcessList.Objects[i] := TStringList.Create;
end;

procedure TDM1.SetProjInfo2Class(AQry: TOraQuery; AProjectInfo: TProjectInfo);
var
  LProjectInfoItem: TProjectInfoItem;
  LFmt: TFormatSettings;
  LStr: string;
begin
  LFmt.ShortDateFormat := 'yyyy-mm-dd';
  LFmt.DateSeparator := '-';

  with Aqry, AProjectInfo do
  begin
    while not eof do
    begin
      ProjectNo := FieldByName('PROJNO').AsString + '-' + FieldByName('SUBPROJNO').AsString;
      AssyFactory := GetFactoryName(FieldByName('AFACTORY').AsString);
      TestFactory := GetFactoryName(FieldByName('TFACTORY').AsString);
      SJDept := GetDeptName(FieldByName('SJDept').AsString);
      SWDept := GetDeptName(FieldByName('SWDept').AsString);
      JJDept := GetDeptName(FieldByName('JJDept').AsString);
      EngineCount := FieldByName('QTY').AsString;
      ShipNo := FieldByName('SHIPNO').AsString;
      ShipOwner := FieldByName('OOWNERNM').AsString;
      ClassSociety := FieldByName('SCLASS').AsString;
      LStr := FieldByName('DELDATE').AsString;
      LStr.Insert(6,'-');
      LStr.Insert(4,'-');
      DeliveryDate := StrToDateTime(LStr, LFmt);
      LStr := FieldByName('ASSYST').AsString;
      LStr.Insert(6,'-');
      LStr.Insert(4,'-');
      AssyStartDate := StrToDateTime(LStr, LFmt);
      Module1 := FieldByName('Module1').AsString;
      Module2 := FieldByName('Module2').AsString;
      Module3 := FieldByName('Module3').AsString;
      Module4 := FieldByName('Module4').AsString;

      LProjectInfoItem := ProjectInfoCollect.Add;
      LProjectInfoItem.EngNo := '1';
      LProjectInfoItem.EngType := FieldByName('JPTYPE').AsString;

      Next;
    end;

    GetDataCompleted := True;
  end;
end;

end.
||||||| .r0
=======
unit UnitScheManageDM;

interface

uses
  System.SysUtils, System.Classes, Dialogs, System.StrUtils, DateUtils,
  System.Types,
  mORMot, SynCommons, ScheduleSampleDataModel, HoliDayCollect, UnitTreeGridGanttRecord;

type
  TDM1 = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FProjList,
    FExcludeProcesssList: TStringList;

    procedure InitProcess1List(AProcessList: TStringList);
    procedure FinalizeProcess1List(AProcessList: TStringList);
    procedure InitExcludeProcesssList(AExProcessList: TStringList);
  public
    FDynHimsenJobRelation: R_BaseInfos;
    FDynBodyData: R_Data_Arr;
    //일자 순으로 sort되어 저장 되어야 함
    FHoliDayList: THoliDayList;

    function GetProjNoList(AClient: TSQLRest;
      AProjNoList: TStrings): Boolean;
    function GetShipNoList(AClient: TSQLRest;
      AShipNoList: TStrings): Boolean;
    function GetRecordJsonFromProjNo(AClient: TSQLRest; AProjNo: string): string;
    function GetRecordJsonFromDB(AClient: TSQLRest; AProjNo: string; ASearchMode: integer;
      ASchAdapt: integer; AIsExcludeProcess: Boolean;var ABeginDate, AEndDate: TDateTime): string;
    function GetBaseInfoFromDB(AClient: TSQLRest; var ADynArray:R_BaseInfos; AEngType: string = ''): Boolean;
    function GetHolidayFromDB(AClient: TSQLRest): Boolean;
    procedure GetNextProcess(AEngineType, AJobCode: RawUtf8; out ANext, ARelType: string);
    procedure AddRecordHoliday2Collect(ARecord: TSQLHolidayRecord; ACollect: THoliDayList);
    //From~To 기간에 휴무일을 반환함 (GanttExclude 포맷)
    function GetGanttExclude(ABeginDate, AEndDate: TDateTime): string;
  end;
var
  DM1: TDM1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

procedure TDM1.AddRecordHoliday2Collect(ARecord: TSQLHolidayRecord;
  ACollect: THoliDayList);
var
  LItem: THoliDayItem;
begin
  LItem := ACollect.HoliDayCollect.Add;

  LItem.FromDate := ARecord.HolidayDate;
  LItem.Description := ARecord.Description;
  LItem.ToDate := ARecord.UpdateDate;
  LItem.HolidayGubun := ARecord.HolidayGubun;
end;

procedure TDM1.DataModuleCreate(Sender: TObject);
begin
  FProjList := TStringList.Create;
  FExcludeProcesssList := TStringList.Create;
  FHoliDayList := THoliDayList.Create(nil);
  InitExcludeProcesssList(FExcludeProcesssList);
end;

procedure TDM1.DataModuleDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FProjList.Count - 1 do
    FinalizeProcess1List(TStringList(FProjList.Objects[i]));

  FProjList.Free;
  FExcludeProcesssList.Free;
  FDynHimsenJobRelation := nil;

  FHoliDayList.Free;
end;

procedure TDM1.FinalizeProcess1List(AProcessList: TStringList);
var
  i: integer;
begin
  for i := 0 to AProcessList.Count - 1 do
    AProcessList.Objects[i].Free;

  AProcessList.Free;
end;

function TDM1.GetBaseInfoFromDB(AClient: TSQLRest; var ADynArray:R_BaseInfos;
  AEngType: string): Boolean;
var
  LRecord: TSQLHimsenJobRelation;
  LRec: R_BaseInfo;
  i, DynCount: integer;
  LDynHimsenJobRelationArr: TDynArray;
begin
  if AEngType <> '' then
    LRecord := TSQLHimsenJobRelation.CreateAndFillPrepare(AClient,
      'EngineType = ?', [AEngType])
  else
    LRecord := TSQLHimsenJobRelation.CreateAndFillPrepare(AClient,
      '', []);

  try
    LDynHimsenJobRelationArr.Init(TypeInfo(R_BaseInfos), ADynArray, @DynCount);
    LDynHimsenJobRelationArr.Capacity := 400;

    i := 0;
    while LRecord.FillOne do
    begin
      LRec := GetBaseInfoFrom(LRecord);
      i := LDynHimsenJobRelationArr.Add(LRec);
//      FDynHimsenJobRelationArr.FindAndAddIfNotExisting(LRec);
    end;

//      ShowMessage(IntToStr(LDynHimsenJobRelationArr.Count));
  finally
    LRecord.Free;
  end;
end;

function TDM1.GetGanttExclude(ABeginDate, AEndDate: TDateTime): string;
var
  i: integer;
  LDate, LPrev: TDate;
  LFrom, LTo: TValueRelationship;
begin
  Result := '';
  LDate := 0;

  for i := 0 to FHolidayList.HoliDayCollect.Count - 1 do
  begin
    if FHolidayList.HoliDayCollect.Items[i].Description = '' then
      Continue;//휴무일인 경우에만 아래로

    LFrom := CompareDate(ABeginDate, FHolidayList.HoliDayCollect.Items[i].FromDate);
    LTo := CompareDate(AEndDate, FHolidayList.HoliDayCollect.Items[i].FromDate);

    if ((LFrom = LessThanValue) or (LFrom = EqualsValue)) and
      ((LTo = GreaterThanValue) or (LTo = EqualsValue)) then
    begin
      if (i+1) < FHolidayList.HoliDayCollect.Count then
      begin
        if LDate = 0 then
        begin
          LDate := FHolidayList.HoliDayCollect.Items[i].FromDate;
          Result := Result + 'y#' + FormatDateTime('mm/dd/yyyy', LDate);
        end;

        LPrev := FHolidayList.HoliDayCollect.Items[i].FromDate;

        if FHolidayList.HoliDayCollect.Items[i+1].Description <> '' then
          if DaysBetween(LPrev, FHolidayList.HoliDayCollect.Items[i+1].FromDate) = 1 then
            continue;
      end
      else
      begin
        if LDate = 0 then
        begin
          LDate := FHolidayList.HoliDayCollect.Items[i].FromDate;
          Result := Result + 'y#' + FormatDateTime('mm/dd/yyyy', LDate);
        end;
      end;

      Result := Result + '~' + FormatDateTime('mm/dd/yyyy', IncDay(FHolidayList.HoliDayCollect.Items[i].FromDate)) + '#1;';
      LDate := 0;
    end;
  end;

//  Result := Result.TrimRight([';']);
end;

function TDM1.GetHolidayFromDB(AClient: TSQLRest): Boolean;
var
  LRecord: TSQLHolidayRecord;
begin
  FHolidayList.HoliDayCollect.Clear;
  LRecord := TSQLHolidayRecord.CreateAndFillPrepare(AClient, '', []);
  try
    while LRecord.FillOne do
    begin
      AddRecordHoliday2Collect(LRecord, FHolidayList);
    end;
  finally
    LRecord.Free;
  end;
end;

procedure TDM1.GetNextProcess(AEngineType, AJobCode: RawUtf8; out ANext, ARelType: string);
var
  i: integer;
  LRec: R_BaseInfo;
  LUtf8: RawUtf8;
  LDynHimsenJobRelationArr: TDynArray;
begin
  LDynHimsenJobRelationArr.Init(TypeInfo(R_BaseInfos), FDynHimsenJobRelation);

  for i := 0 to LDynHimsenJobRelationArr.Count - 1 do
  begin
    LRec := R_BaseInfo(LDynHimsenJobRelationArr.ElemPtr(i)^);

    if (LRec.FEngineType = AEngineType) then
    begin
      LUtf8 := LRec.FPPartNo + '-' + LRec.FPJobCode;

      if LUtf8 = AJobCode then
      begin
        ANext := UTF8ToString(LRec.FAPartNo + '-' + LRec.FAJobCode);
        ARelType := UTF8ToString(LRec.FRelType);
      end;
    end;
  end;
end;

function TDM1.GetProjNoList(AClient: TSQLRest;
  AProjNoList: TStrings): Boolean;
var
  LRecord: TSQLScheduleSampleRecord;
begin
  LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
    '', []);
  try
    AProjNoList.Clear;
    AProjNoList.Add('');
    while LRecord.FillOne do
    begin
      if AProjNoList.IndexOf(LRecord.ProjNo) = -1 then
        AProjNoList.Add(LRecord.ProjNo);
    end;
  finally
    LRecord.Free;
  end;
end;

function TDM1.GetRecordJsonFromProjNo(AClient: TSQLRest;
  AProjNo: string): string;
var
  LRecord: TSQLScheduleSampleRecord;
  LV: Variant;
  LUtf8: RawUTF8;
  LOptions: TDocVariantOptions;
  i: integer;
  LStr: string;
  LOnce: Boolean;
begin
  LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
    'ProjNo = ?', [AProjNo]);
  try
    TDocVariant.New(LV, [dvoSerializeAsExtendedJson]);
    LUtf8 := '';
    i := 0;
    while LRecord.FillOne do
    begin
//      if not LOnce then
//      begin
//        LOnce := True;
//        i := i + 1;
//        LV.No := IntToStr(i);
//        LV.T := LRecord.ProjNo;
//        FormatSettings.DateSeparator := '/';
//        LV.S := FormatDateTime('dd/mm/yyyy',LRecord.StartDateActual);
//        LV.E := FormatDateTime('dd/mm/yyyy',LRecord.EndDateActual);
//        LV.C := '100';
//        LV.D := '';
//        LV.L := LRecord.ProjNo;
//        LUtf8 := LUtf8 + VariantSaveJson(LV) + ',';
//      end;

      LStr := FormatDateTime('yyyy',LRecord.StartDateActual);
      if LStr = '1899' then
        Continue;

      LStr := FormatDateTime('yyyy',LRecord.EndDateActual);
      if LStr = '1899' then
        Continue;

      i := i + 1;
      LV.Id := IntToStr(i);
      LV.T := LRecord.Description;
      FormatSettings.DateSeparator := '/';
      LV.S := FormatDateTime('mm/dd/yyyy',LRecord.StartDateActual);
      LV.E := FormatDateTime('mm/dd/yyyy',LRecord.EndDateActual);
      LV.C := '100';
      LV.D := '';

      LStr := LeftStr(LRecord.ActCode,3);

      if LStr = 'AP0' then
        LStr := '선조립'
      else if LStr = 'JP0' then
        LStr := '종조립'
      else
        LStr := '시운전';

      LV.L := LRecord.ProjNo + '/' + LStr;
//      LUtf8 := VariantSaveJson(LV);
      LUtf8 := LUtf8 + VariantSaveJson(LV) + ',';
//      LUtf8 := LRecord.GetJSONValues(True,False,soSelect);
    end;

//    LOptions := [dvoSerializeAsExtendedJson];
//    LV := LRecord.GetSimpleFieldsAsDocVariant(False, @LOptions);
//    LUtf8 := LRecord.GetSQLValues;
//    LRecord.GetAsDocVariant(False,ALL_FIELDS,LV,@LOptions);
    Result := 'Body: [[' +  Utf8ToString(LUtf8) + ']]';
  finally
    LRecord.Free;
  end;
end;

function TDM1.GetRecordJsonFromDB(AClient: TSQLRest;
  AProjNo: string; ASearchMode: integer; ASchAdapt: integer;
  AIsExcludeProcess: Boolean; var ABeginDate,AEndDate: TDateTime): string;
var
  LRecord: TSQLScheduleSampleRecord;
  LV: Variant;
  LR_Data: PR_Data;
  LUtf8, LWhere: RawUTF8;
  LOptions: TDocVariantOptions;
  i, j, k, LIdx: integer;
  LStr, LData, LNext, LRelType: string;
  LNoData, LNoData2: Boolean;
  LStrList: TStringList;
  LStart, LEnd: TDateTime;
  LPointer: Pointer;
begin
  LWhere := '';
  LUtf8 := '';

  case ASearchMode of
    0: //납기
    begin
      LWhere := ' DeliveryDate >= ? AND DeliveryDate <= ?';
    end;
    1: //착수일
    begin
      LWhere := ' StartDatePlan >= ? AND StartDatePlan <= ?';
    end;
    2: //완료일
    begin
      LWhere := ' EndDatePlan >= ? AND EndDatePlan <= ?';
    end;
  end;

  if AProjNo <> '' then
  begin
    LUtf8 := 'ProjNo = ? ';

    if LWhere <> '' then
      LUtf8 := LUtf8 + ' AND ';
  end;

  LUtf8 := LUtf8 + LWhere + ' order by ProjNo ' ;

  if (AProjNo <> '') and (ASearchMode >= 0) then
    LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
      LUtf8, [AProjNo, DateToSQL(ABeginDate), DateToSQL(AEndDate)])
  else
  if ASearchMode >= 0 then
    LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
      LUtf8, [DateToSQL(ABeginDate), DateToSQL(AEndDate)])
  else
  if AProjNO <> '' then
    LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
      'ProjNo = ?', [AProjNo]);

  try
    TDocVariant.New(LV, [dvoSerializeAsExtendedJson]);
    LUtf8 := '';
    i := 0;
    Result := 'Body: [[';
    ABeginDate := now;
    AEndDate := 0;
    FProjList.Clear;
    SetLength(FDynBodyData,0);

    while LRecord.FillOne do
    begin
      LV.Clear;

      if AIsExcludeProcess then
        if FExcludeProcesssList.IndexOf(LRecord.ActCode) <> -1 then
          continue;

      case TAdaptSchedule(ASchAdapt) of
        asPlan: begin
          LStart := LRecord.StartDatePlan;
          LEnd := LRecord.EndDatePlan;
        end;

        asPredict: begin
          LStart := LRecord.StartDatePredict;
          LEnd := LRecord.EndDatePredict;
        end;

        asActual: begin
          LStart := LRecord.StartDateActual;
          LEnd := LRecord.EndDateActual;
        end;
      end;

      LStr := FormatDateTime('yyyy',LStart);
      LNoData := LStr = '1899';

      LStr := FormatDateTime('yyyy',LEnd);
      LNoData2 := LStr = '1899';

      if not LNoData then
        if LStart < ABeginDate then
          ABeginDate := LStart;

      if not LNoData2 then
        if LEnd > AEndDate then
          AEndDate := LEnd;

      LStr := Utf8ToString(LRecord.ProjNo);
      LIdx := FProjList.IndexOf(LStr);

      if LIdx = -1 then
      begin
        LIdx := FProjList.Add(LStr);
        LStrList := TStringList.Create; //공정 리스트(ProcessList)
        FProjList.Objects[LIdx] := LStrList;
        InitProcess1List(LStrList);
        i := i + 1;
      end;

      LV.id := IntToStr(i) + '_' + LRecord.ActCode;
      LV.Process := LRecord.Description;
      LV.GANTTGanttHtmlRight := LRecord.Description;
      FormatSettings.DateSeparator := '/';

      if FormatDateTime('yyyy',LStart) <> '1899' then
        LV.START := FormatDateTime('mm/dd/yyyy',LStart);

      if FormatDateTime('yyyy',LEnd) <> '1899' then
        LV.ENDDATE := FormatDateTime('mm/dd/yyyy',LEnd);

      LV.COMPLETE := '100';
//      LV.FLAGS := LV.ENDDATE;
      LNext := '';
      LRelType := '';
      GetNextProcess(LRecord.EngineType, LRecord.ActCode, LNext, LRelType);

      if (LNext <> '') and (LRelType <> '') then
      begin
        if LRelType = 'FS' then
          LV.DEC := IntToStr(i) + '_' + LNext
        else if LRelType = 'SS' then
          LV.ANC := IntToStr(i) + '_' + LNext;
      end;

      LData := Utf8ToString(VariantSaveJson(LV));

      if i > 1 then
        LV.ANC := IntToStr(i-1);
      LStr := LeftStr(LRecord.ActCode,3);

      if LStr = 'AP0' then
        LStr := '선조립'
      else if LStr = 'JP0' then
        LStr := '종조립'
      else if LStr = 'TR0' then
        LStr := '출고준비'
      else
        LStr := '시운전';

      j := TStringList(FProjList.Objects[LIdx]).IndexOf(LStr);

      if j <> -1 then
      begin    //세부공정
        SetLength(FDynBodyData, Length(FDynBodyData) + 1);
        LR_Data := @(FDynBodyData[High(FDynBodyData)]);
        RecordLoadJson(LR_Data^, LData, TypeInfo(R_Data));
        TStringList(TStringList(FProjList.Objects[LIdx]).Objects[j]).AddObject(LV.id, Pointer(LR_Data));
//        TStringList(TStringList(FProjList.Objects[LIdx]).Objects[j]).Add(LData);
      end;
    end;

//    for k := 0 to 0 do
    for k := 0 to FProjList.Count - 1 do
    begin
      Result := Result + '{Def:' + QuotedStr('SUM','"') + ', Process:"'+
        FProjList.Strings[k] + '", Items:[';

      for i := 0 to TStringList(FProjList.Objects[k]).Count - 1 do
      begin
        Result := Result + '{Def:' + QuotedStr('SUMEDIT','"') + ', Process:"' +
          TStringList(FProjList.Objects[k]).Strings[i] + '", Items:[';

        for j := 0 to TStringList(TStringList(FProjList.Objects[k]).Objects[i]).Count - 1 do
        begin
          LPointer := TStringList(TStringList(FProjList.Objects[k]).Objects[i]).Objects[j];
          LR_Data := LPointer;
          LStr := RecordSaveJson(LR_Data^, TypeInfo(R_Data));
          Result := Result + LStr;
//          Result := Result + TStringList(TStringList(FProjList.Objects[k]).Objects[i]).Strings[j] + ',';
        end;

        Result := Result.TrimRight([',']);
        Result := Result + ']},';
      end;

      Result := Result.TrimRight([',']) + ']},';
    end;
    Result := Result.TrimRight([',']);
    Result := Result + ']]';
  finally
    LRecord.Free;
  end;
end;

function TDM1.GetShipNoList(AClient: TSQLRest;
  AShipNoList: TStrings): Boolean;
var
  LRecord: TSQLScheduleSampleRecord;
begin
  LRecord := TSQLScheduleSampleRecord.CreateAndFillPrepare(AClient,
    '', []);
  try
    AShipNoList.Clear;
    AShipNoList.Add('');
    while LRecord.FillOne do
    begin
      if AShipNoList.IndexOf(LRecord.ShipNo) = -1 then
        AShipNoList.Add(LRecord.ShipNo);
    end;
  finally
    LRecord.Free;
  end;
end;

procedure TDM1.InitExcludeProcesssList(AExProcessList: TStringList);
begin
  AExProcessList.Clear;
  AExProcessList.Add('AP0000-A0600'); //Big End 조립
  AExProcessList.Add('JP0001-G0100'); //소구경 PIPE 작업
  AExProcessList.Add('JP0001-S0100'); //소구경 PIPE FINAL 작업
  AExProcessList.Add('JP0001-L0600'); //대구경 PIPE FINAL 작업
  AExProcessList.Add('JP0001-W0700'); //전장작업
  AExProcessList.Add('TR0001-K0300'); //중형엔진포장(제작)
  AExProcessList.Add('TG0001-T0300'); //시운전설비 해체
  AExProcessList.Add('QQ0000-T0200'); //COMMISSION
end;

procedure TDM1.InitProcess1List(AProcessList: TStringList);
var
  i: integer;
begin
  AProcessList.Clear;

  i := AProcessList.Add('선조립');
  AProcessList.Objects[i] := TStringList.Create;
  i := AProcessList.Add('종조립');
  AProcessList.Objects[i] := TStringList.Create;
  i := AProcessList.Add('시운전');
  AProcessList.Objects[i] := TStringList.Create;
  i := AProcessList.Add('출고준비');
  AProcessList.Objects[i] := TStringList.Create;
end;

end.
