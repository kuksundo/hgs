unit HiTEMS_TMS_COMMON;

interface

uses
  Ora, DB, System.SysUtils, NxGrid, Vcl.Dialogs, System.Classes, StrUtils;

  function Check_User_position(aUserId: String): Integer; //return PRIV
  procedure Set_User_Info(aUserId: String);
  procedure Get_Attfiles(aGrid:TNextGrid;aOwner:String);
  procedure Delete_Attfile(aRegNo : String); //파일 하나씩 개별삭제
  procedure Delete_Attfiles(aOwner: String); //오너 삭제시 모두 삭제
  procedure Delete_Work_Orders(aOwner: String);
  procedure Delete_Test_Info(aPlanNo: String);
  procedure Insert_Attfiles(aOwner,aRegNo,aFileName,aFileSize,aFilePath:String);
  procedure Insert_Change_Log_(aType,aFunc,aDesc,aUser:String);

  function Get_UserName(aUserID:String) : String;
  function Get_UserPosition(aUserID:String) : String;
  function Get_UserNameAndPosition(aUserId:String):String;
  function Get_StandardHours(aUserID:String) : Integer;
  function Get_DeptName(aDeptNo:String) : String;
  function Get_DeptNo(aDeptName:String) : String;

  //Delete
  function Check_Authority_of_addTask(aTaskNo,aTeamNo:String) : Boolean;
  function Get_taskName(aTask_No: String): String;
  function Get_Task_LV(aTask_No:String) : Integer;
  function Get_makeKeyValue:String;
  function Get_Plan_InCharge(aPlan_NO,aPlanRevNo,aPlan_ROLE:String) : String;
  function Get_planName(aPlan_No:String;aRevNo:Integer) : String;
  function Get_AttfilesCount(aOwner:String):Integer;
  procedure Del_Attfiles(aOwner:String);
  function Get_Hitems_Code_Name(aCode:String):String;
  procedure GetPlanInfo(AReqNo: string; var ATaskNo, APlanNo, ATeamCode: string; var AStartDate, AEndDate: TDateTime; var APlanRevNo: integer);

  procedure Send_SMS_Note(AMsg,AReqID,Ahead,Atitle,Acontent,AFlag : AnsiString);
  procedure Send_Message_Main_CODE(FFlag,FSendID,FRecID,FHead,FTitle,FContent:String); // 메세지 메인 함수

implementation

uses
  HHI_WebService,
  UnitHHIMessage,
  CommonUtil_Unit,
  DataModule_Unit;

function Check_User_position(aUserId: String): Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*, B.PRIV from DPMS_DEPT A, DPMS_USER B ' +
            'where A.MANAGER = :param1 ' +
            'and A.MANAGER = B.USERID ');
    ParamByName('param1').AsString := aUserId;
    Open;

    if not(RecordCount = 0) then
      Result := FieldByName('PRIV').AsInteger
    else
      Result := 1;

  end;
end;

procedure Set_User_Info(aUserId: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*,B.MANAGER, DEPT_NAME, C.DESCR  FROM DPMS_USER A, DPMS_DEPT B, DPMS_USER_GRADE C ' +
            'where A.UserID = :param1 and A.DEPT_CD = B.DEPT_CD AND A.GRADE = C.GRADE');
    ParamByName('param1').AsString := aUserId;
    Open;

    if RecordCount > 0 then
    begin
      with DM1.FUserInfo do
      begin
        UserID := FieldByName('USERID').AsString;
        UserName := FieldByName('NAME_KOR').AsString;
        Dept_Cd := LEFTSTR(FieldByName('DEPT_CD').AsString,3);
        TeamName := FieldByName('DEPT_NAME').AsString;
        TEAMNO := FieldByName('DEPT_CD').AsString;
        JobPosition := FieldByName('POSITION').AsString;
        Manager := FieldByName('MANAGER').AsString;
        Grade := FieldByName('DESCR').AsString;

        DM1.GetTeamList(Dept_Cd);
        AliasCode_Dept := DM1.GetAliasCode(Dept_cd);
        AliasCode_Team := DM1.GetAliasCode(TEAMNO);
        DeptName := Get_DeptName(Dept_Cd);
      end;

    end;
  end;

  DM1.GetDeptList;
end;

procedure Get_Attfiles(aGrid:TNextGrid;aOwner:String);
begin
  with aGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT FILENAME, FILESIZE, REGNO, OWNER from DPMS_TMS_ATTFILES ' +
                'WHERE OWNER = :param1 ');
        ParamByName('param1').AsString := aOwner;
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('FILENAME').AsString;
          Cells[2,RowCount-1] := FieldByName('FILESIZE').AsString;
          Cells[4,RowCount-1] := FieldByName('REGNO').AsString;
          Cells[5,RowCount-1] := FieldByName('OWNER').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure Delete_Attfile(aRegNo : String);
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM DPMS_TMS_ATTFILES ' +
              'where RegNo = :param1 ');
      ParamByName('param1').AsString := aRegNo;
      ExecSQL;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure Delete_Attfiles(aOwner: String); //오너 삭제시 모두 삭제
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM DPMS_TMS_ATTFILES ' +
              'WHERE OWNER IN ' +
              '( ' +
              '   SELECT OWNER FROM ' +
              '   ( ' +
              '     SELECT TASK_NO OWNER, TASK_PRT FROM DPMS_TMS_TASK UNION ALL ' +
              '     SELECT PLAN_NO, TASK_NO FROM DPMS_TMS_PLAN UNION ALL ' +
              '     SELECT RST_NO, PLAN_NO FROM DPMS_TMS_RESULT ' +
              '   ) ' +
              '   START WITH OWNER = :param1 ' +
              '   CONNECT BY PRIOR OWNER = TASK_PRT ' +
              ') ');

      ParamByName('param1').AsString := aOwner;
      ExecSQL;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure Delete_Work_Orders(aOwner: String);
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM DPMS_TMS_WORK_ORDERS ' +
              'WHERE PLAN_NO LIKE :param1 ');

      ParamByName('param1').AsString := aOwner;
      ExecSQL;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;


procedure Delete_Test_Info(aPlanNo: String);
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM DPMS_TMS_ATTFILES  ' +
              'WHERE OWNER IN ( ' +
              '                   SELECT TEST_NO FROM DPMS_TMS_TEST_INFO ' +
              '                   WHERE PLAN_NO LIKE :param1 ' +
              '                   GROUP BY TEST_NO) ');
      ParamByName('param1').AsString := aPlanNo;
      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM DPMS_TMS_TEST_INFO ' +
              'WHERE PLAN_NO LIKE :param1 ');

      ParamByName('param1').AsString := aPlanNo;
      ExecSQL;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure Insert_Attfiles(aOwner,aRegNo,aFileName,aFileSize,aFilePath:String);
var
  lms : TMemoryStream;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert Into DPMS_TMS_ATTFILES ' +
            'Values(:OWNER,:REGNO,:FILENAME,:FILESIZE,:FILES)');

    ParamByName('OWNER').AsString      := aOwner;
    ParamByName('REGNO').AsString      := aRegNo;
    ParamByName('FILENAME').AsString   := aFileName;
    ParamByName('FILESIZE').AsFloat    := StrToFloat(aFileSize);

    lms := TMemoryStream.Create;
    try
      lms.Position := 0;
      lms.LoadFromFile(aFilePath);

      if lms <> nil then
      begin
        ParamByName('FILES').ParamType := ptInput;
        ParamByName('FILES').AsOraBlob.LoadFromStream(lms);
      end;
      try
        ExecSQL;
      except
        on e:exception do
        begin
          ShowMessage(e.Message);
          Raise;
        end;
      end;
    finally
      FreeAndNil(lms);
    end;
  end;
end;

procedure Insert_Change_Log_(aType,aFunc,aDesc,aUser:String);
var
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO DPMS_TMS_CHANGE_LOG ' +
              'VALUES( ' +
              ':LOGNO, :TYPE_, :FUNCTION_, :DESCRIPTION, :USERID )');
      ParamByName('LOGNO').AsString       := Get_makeKeyValue;
      ParamByName('TYPE_').AsString       := aType;
      ParamByName('FUNCTION_').AsString   := aFunc;
      ParamByName('DESCRIPTION').AsString := aDesc;
      ParamByName('USERID').AsString      := aUser;
      ExecSQL;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Get_UserName(aUserID:String) : String;
var
  OraQuery1 : TOraQuery;

begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from DPMS_USER ' +
              'where USERID = :param1 ');
      ParamByName('param1').AsString := aUserID;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('NAME_KOR').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Get_UserPosition(aUserID:String) : String;
var
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.*, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B ' +
              'WHERE USERID = :param1 ' +
              'AND A.GRADE = B.GRADE ');
      ParamByName('param1').AsString := aUserID;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('DESCR').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Get_UserNameAndPosition(aUserId:String):String;
var
  OraQuery : TOraQuery;
  lResult : String;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := Dm1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT A.*, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B ' +
              'WHERE USERID = :param1  ' +
              'AND A.GRADE = B.GRADE ');
      ParamByName('param1').AsString := aUserId;
      Open;

      if not RecordCount <> 0 then
      begin
        lResult := FieldByName('NAME_KOR').AsString +' / '+
                   FieldByName('DESCR').AsString;
      end;

      if lResult <> '' then
        Result := lResult
      else
        Result := '';

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function Get_StandardHours(aUserID:String) : Integer;
var
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT STDTIME FROM DPMS_USER A, DPMS_USER_GRADE B ' +
              'where A.USERID = :param1  ' +
              'AND A.GRADE = B.GRADE ');

      ParamByName('param1').AsString := aUserID;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('STDTIME').AsInteger
      else
        Result := 0;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Get_DeptName(aDeptNo:String) : String;
var
  OraQuery1 : TOraQuery;
  lappType : Double;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DEPT_NAME from DPMS_DEPT where DEPT_CD = :param1 ');
      ParamByName('param1').AsString := aDeptNo;
      Open;

      Result := FieldByName('DEPT_NAME').AsString;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Get_DeptNo(aDeptName:String) : String;
var
  OraQuery1 : TOraQuery;
  lappType : Double;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from DPMS_DEPT where DEPT_NAME = :param1 ');
      ParamByName('param1').AsString := aDeptName;
      Open;

      if not(RecordCount = 0) then
      begin
        Result := FieldByName('DEPT_CD').AsString;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Check_Authority_of_addTask(aTaskNo,aTeamNo:String) : Boolean;
begin
  if aTaskNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_TMS_TASK_SHARE ' +
              'WHERE TASK_NO = :param1 ' +
              'AND TASK_TEAM = :param2 ');
      ParamByName('param1').AsString := aTaskNo;
      ParamByName('param2').AsString := aTeamNo;
      Open;

      if RecordCount > 0 then
      begin
        if FieldByName('TASK_AUTHORITY').AsInteger > 0 then
          Result := True
        else
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM DPMS_TMS_AUTHORITY ' +
                  'WHERE USERID = :param1 ');
          ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsers;
          Open;

          if RecordCount <> 0 then
          begin
            if FieldByName('TASK_NEW').AsInteger > 0 then
              Result := True;
          end
          else
            Result := False;

        end;
      end else
        Result := False;
    end;
  end
  else
  begin
    Result := True;
  end;
end;

function Get_taskName(aTask_No: String): String;
var
  OraQuery : TOraQuery;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := Dm1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select TASK_NAME from DPMS_TMS_TASK ' +
              'where TASK_NO = :param1 ');
      ParamByName('param1').AsString := aTask_No;
      Open;

      if RecordCount <> 0 then
        Result := FieldByName('TASK_NAME').AsString
      else
        Result := '';

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function Get_Task_LV(aTask_No: String): Integer;
var
  OraQuery : TOraQuery;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := Dm1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select TASK_LV from DPMS_TMS_TASK ' +
              'where TASK_NO = :param1 ');
      ParamByName('param1').AsString := aTask_No;
      Open;

      if RecordCount <> 0 then
        Result := FieldByName('TASK_LV').AsInteger
      else
        Result := 0;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function Get_makeKeyValue:String;
begin
  Result := FormatDateTime('YYYYMMDDHHmmsszzz',Now);
end;

function Get_Plan_InCharge(aPlan_NO,aPlanRevNo,aPlan_ROLE:String) : String;
var
  OraQuery : TOraQuery;
  lname : String;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.PLAN_EMPNO, B.USERID, B.NAME_KOR ' +
              'From DPMS_TMS_PLAN_INCHARGE A, DPMS_USER B ' +
              'WHERE A.PLAN_NO = :param1 ' +
              'AND A.PLAN_REV_NO = :param2 ' +
              'AND A.PLAN_EMPNO = B.USERID ');
      ParamByName('param1').AsString := aPlan_NO;
      ParamByName('param2').AsInteger := StrToInt(aPlanRevNo);

      if aPlan_ROLE <> '' then
      begin
        SQL.Add('AND A.PLAN_ROLE = :param2 ');
        ParamByName('param2').AsString := aPlan_ROLE;
      end;

      SQL.Add('ORDER BY PLAN_SEQ ');

      Open;

      if RecordCount <> 0 then
      begin
        while not eof do
        begin
          lname := lname + FieldByName('NAME_KOR').AsString +',';
          Next;
        end;
        Result := Copy(lname,0,length(lname)-1);
      end else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function Get_planName(aPlan_No:String;aRevNo:Integer) : String;
var
  OraQuery : TOraQuery;
  lname : String;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_TMS_PLAN ' +
              'WHERE PLAN_NO = :param1 ' +
              'AND PLAN_REV_NO = :param2 ');
      ParamByName('param1').AsString := aPlan_No;
      ParamByName('param2').AsInteger := aRevNo;
      Open;

      if RecordCount <> 0 then
        Result := FieldByName('ENG_TYPE').AsString + FieldByName('PLAN_NAME').AsString
      else
        Result := '';

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function Get_AttfilesCount(aOwner:String):Integer;
var
  OraQuery : TOraQuery;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := Dm1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COUNT(*) COUNT from DPMS_TMS_ATTFILES ' +
              'WHERE OWNER = :param1 ');
      ParamByName('param1').AsString := aOwner;
      Open;

      Result := FieldByName('COUNT').AsInteger;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure Del_Attfiles(aOwner:String);
var
  OraQuery : TOraQuery;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := Dm1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_TMS_TASK ' +
              'START WITH TASK_NO = :param1 ' +
              'CONNECT BY PRIOR TASK_NO = TASK_PRT ');
      ParamByName('param1').AsString := aOwner;
      Open;
      while not eof do
      begin

        Next;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function Get_Hitems_Code_Name(aCode:String):String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := Dm1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT CODE_NAME FROM DPMS_CODE_GROUP ' +
              'WHERE GRP_NO = :param1 ');
      ParamByName('param1').AsString := aCode;
      Open;

      Result := FieldByName('CODE_NAME').AsString;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure GetPlanInfo(AReqNo: string; var ATaskNo, APlanNo, ATeamCode: string; var AStartDate, AEndDate: TDateTime; var APlanRevNo: integer);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*,B.* ' +
            ' FROM DPMS_TMS_PLAN A ' +
            '                INNER JOIN   (  ' +
            '                SELECT GRP_NO, CODE_NAME FROM DPMS_CODE_GROUP   ) B  ' +
            '                ON A.PLAN_CODE = B.GRP_NO ' +
            ' WHERE PLAN_NO = (SELECT PLAN_NO FROM DPMS_TMS_TEST_RECEIVE_INFO  WHERE REQ_NO = :REQ_NO) AND' +
            '       PLAN_REV_NO = (SELECT MAX(PLAN_REV_NO) PRN FROM DPMS_TMS_PLAN WHERE PLAN_NO =  ' +
            '           (SELECT PLAN_NO FROM DPMS_TMS_TEST_RECEIVE_INFO  WHERE REQ_NO = :REQ_NO) GROUP BY PLAN_NO)');
    ParamByName('REQ_NO').AsString := AReqNo;

    Open;

    if RecordCount > 0 then
    begin
      ATaskNo := FieldByName('TASK_NO').AsString;
      APlanNo := FieldByName('PLAN_NO').AsString;
      //ATeamCode :=
      AStartDate := FieldByName('PLAN_START').AsDateTime;
      AEndDate := FieldByName('PLAN_END').AsDateTime;
      APlanRevNo := FieldByName('PLAN_REV_NO').AsInteger;
    end;//if
  end;//with
end;


procedure Send_Message_Main_CODE(FFlag, FSendID, FRecID, FHead,
  FTitle, FContent: String);
var
  LTXK0SMS2 : TXK0SMS2;
begin

  LTXK0SMS2 := TXK0SMS2.Create;
  try
    LTXK0SMS2.SEND_SABUN := FSendID;
    LTXK0SMS2.RCV_SABUN := FRecID;
    LTXK0SMS2.SYS_TYPE := '112';
    LTXK0SMS2.NOTICE_GUBUN := FFlag;

    LTXK0SMS2.TITLE := FTitle;
    //LTXK0SMS2.SEND_HPNO := '010-4190-6742';
    //LTXK0SMS2.RCV_HPNO := '010-3351-7553';
    LTXK0SMS2.CONTENT := FContent;
    LTXK0SMS2.ALIM_HEAD := FHead;

    SendHHIMessage(LTXK0SMS2);
  finally
    LTXK0SMS2.Free;
  end;
end;

//  헤더의 길이가 21byte를 넘지 않아야 함.
//  lhead := 'HiTEMS-문제점보고서';
//  lhead := '123456780123456789012';
procedure Send_SMS_Note(AMsg,AReqID,Ahead,Atitle,Acontent,AFlag : AnsiString);
var
  le: integer;
  lstr,
  lflag: Ansistring;
begin
  Acontent := StringReplace(Acontent, #$D#$A,'',[rfReplaceAll]);


  for le := 0 to 1 do
  begin
    case le of
      0 : lflag := 'A'; //쪽지
      1 : lflag := 'B'; //SMS
    end;

    if lflag = 'B' then
    begin
      while True do
      begin
        if Acontent = '' then
          Break;

        if Length(AnsiString(Acontent)) > 80 then
        begin
          lstr := Copy(Acontent,1,80);
          Acontent := Copy(Acontent,81,Length(Acontent)-80);
        end else
        begin
          lstr := Copy(Acontent,1,Length(Acontent));
          Acontent := '';
        end;
        //문자 메세지는 title(lstr)만 보낸다.
        Send_Message_Main_CODE(lflag,DM1.FUserInfo.CurrentUsers,AReqID,AHead,lstr,ATitle);
      end;
    end
    else
    begin
      lstr := Acontent;
      Send_Message_Main_CODE(lflag,DM1.FUserInfo.CurrentUsers,AReqID,AHead,ATitle,lstr);
    end;
  end;

end;

end.

