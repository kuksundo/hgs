unit HiTEMS_TRC_COMMON;

interface

uses
  Ora, DB, System.SysUtils, NxGrid, Vcl.Dialogs, System.Classes, HiTEMS_TRC_CONST;


  function Check_User_position(aUserId: String): Integer; //return PRIV
  procedure Set_User_Info(aUserId: String);

  function Return_UserName(aUserID:String) : String;
  function Return_trCodeName(aCode:String) : String;
  function Return_DeptName(aDeptNo:String) : String;
  function Return_DeptNo(aDeptName:String) : String;
  function Return_Manager(aDeptNo:String) : String;
  function Return_teamName(aTeamCode:String) : String;
  function Return_teamEngine(aTeamCode:String) : String;
  function Return_EngineType(aProjNo:String) : String;

var
  FUserInfo : TUserInfo;
  function CurrentUsers : String;
  function CurrentUserName: string;
  function CurrentUsersDept : String;
  function CurrentUsersTeam : String;
  function CurrentUsersManager : String;
  function CurrentUserPosition: string;
  function Return_reportStatusNm(aStatusNo : Double) : String;
  function Get_makeKey(aDateTime:TDateTime) : String;
  function Get_UserName(aUserId:String):String;
  function Get_trCodeName(aCode:String):String;
  function Get_Replace_Date_Format(aKey:String):String;

  function Delete_HiTEMS_TRC_ATTFILES(aOwner,aFlag,aLcFileName:String):Boolean;
  function Insert_Into_HiTEMS_TRC_ATTFILES(aOwner,aFlag,aDBfileName,aLcFileName,
                                           aFileExt,aFileSize,aPath : String): Boolean;

  function Get_AttFileCount(aOwner:String) : Integer;

implementation
uses
  CommonUtil_Unit,
  DataModule_Unit;

function CurrentUsers : String;
begin
  Result := FUserInfo.UserID;
end;

function CurrentUserName: string;
begin
  Result := FUserInfo.UserName;
end;

function CurrentUsersDept : String;
begin
  Result := FUserInfo.DeptNo;
end;

function CurrentUsersTeam : String;
begin
  Result := FUserInfo.TeamNo;
end;

function CurrentUsersManager : String;
begin
  Result := FUserInfo.Manager;
end;

function CurrentUserPosition: string;
begin
  Result := FUserInfo.Position;
end;

function Return_reportStatusNm(aStatusNo : Double) : String;
var
  li : Integer;
begin
  Result := '';
  for li := 0 to length(freportStatus)-1 do
  begin
    if aStatusNo = freportStatus[li] then
    begin
      Result := freportStatusNm[li];
      Break;

    end;
  end;
end;

function Check_User_position(aUserId: String): Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select A.*, B.PRIV from HITEMS_DEPTNO A, HITEMS_EMPLOYEE B ' +
            'where A.MANAGER = ''' +aUserId + ''' ' +
            'and A.MANAGER = B.USERID ');
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
//    SQL.Add('select A.*,B.manager from HITEMS_EMPLOYEE A, HITEMS_DEPTNO B ' +
//      'where A.UserID = ''' + aUserId + ''' ' + 'and A.TEAMNO = B.DEPTNO ');
    SQL.Add('Select A.USERID, A.NAME_KOR, A.DEPT_CD, A.GRADE, B.DESCR From HITEMS.HITEMS_USER A, HITEMS.HITEMS_USER_GRADE B ');
    SQL.Add('WHERE USERID = :param1 and A.GRADE = B.GRADE ');
    parambyname('param1').AsString := aUserId;
    Open;

    if not(RecordCount = 0) then
    begin
      with FUserInfo do
      begin
        UserID := FieldByName('USERID').AsString;
        UserName := FieldByName('NAME_KOR').AsString;
        DeptNo := Copy(FieldByName('DEPT_CD').AsString, 1, 3);
        TEAMNO := FieldByName('DEPT_CD').AsString;
        Position := FieldByName('DESCR').AsString;
        Manager := '';//FieldByName('MANAGER').AsString;
      end;
    end;
  end;
end;

procedure Get_Attfiles(aGrid:TNextGrid;aOwner:Double);
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
        SQL.Add('select * from HITEMS_TMS_ATTFILES ' +
                'where OWNER = '+FloatToStr(aOwner)+
                ' order by REGNO');
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('FILENAME').AsString;
          Cells[2,RowCount-1] := FieldByName('FILESIZE').AsString;
          Cells[4,RowCount-1] := FieldByName('REGNO').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function Return_UserName(aUserID:String) : String;
var
  OraQuery1 : TOraQuery;

begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HITEMS_EMPLOYEE ' +
              'where USERID = '''+aUserId+''' ');
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

function Return_trCodeName(aCode:String) : String;
var
  OraQuery1 : TOraQuery;
  lPrtCode : String;
  lCode : String;

begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HITEMS_TROUBLE_ROOT ' +
              'where ROOTNO = '''+aCode+''' ');
      Open;

      if RecordCount <> 0 then
      begin
        lCode := FieldByName('ROOTNAME').AsString;
        lPrtCode := FieldByName('PRTROOTNO').AsString;

        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_TROUBLE_ROOT ' +
                'where ROOTNO = '''+lPrtCode+''' ');
        Open;

        if RecordCount <> 0 then
          lPrtCode := FieldByName('ROOTNAME').AsString
        else
          lPrtCode := '';

        Result := lPrtCode+'/'+lCode;
      end
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Return_DeptName(aDeptNo:String) : String;
var
  OraQuery1 : TOraQuery;
  lappType : Double;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HITEMS_DEPTNO where DEPTNO = '''+aDeptNo+''' ');
      Open;

      if not(RecordCount = 0) then
      begin
        Result := FieldByName('DEPTNAME').AsString;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Return_DeptNo(aDeptName:String) : String;
var
  OraQuery1 : TOraQuery;
  lappType : Double;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HITEMS_DEPTNO where DEPTNAME = '''+aDeptName+''' ');
      Open;

      if not(RecordCount = 0) then
      begin
        Result := FieldByName('DEPTNO').AsString;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Return_Manager(aDeptNo:String) : String;
var
  OraQuery1 : TOraQuery;
  lappType : Double;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.MANAGER, B.NAME_KOR, C.DESCR  ' +
              'FROM HITEMS_DEPTNO A, HITEMS_EMPLOYEE B, HITEMS_EMPLOYEE_CLASS C ' +
              'WHERE A.MANAGER = B.USERID ' +
              'AND B.CLASS_ = C.CLASS_ ' +
              'AND A.DEPTNO = '''+aDeptNo+''' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('DESCR').AsString +'/'+FieldByName('NAME_KOR').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Return_teamName(aTeamCode:String) : String;
var
  OraQuery1 : TOraQuery;
  lappType : Double;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HITEMS_DEPTNO ' +
              'where DEPTNO = '''+aTeamCode+''' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('DEPTNAME').AsString;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;


function Return_teamEngine(aTeamCode:String) : String;
var
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSENINFO ' +
              'where TEAM = '''+aTeamCode+''' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('DEPTNAME').AsString;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Return_EngineType(aProjNo:String) : String;
var
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSENINFO ' +
              'where PROJNO = '''+aProjNo+''' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('ENGTYPE').AsString;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Get_makeKey(aDateTime:TDateTime) : String;
begin
  Result := FormatDateTime('YYYYMMDDHHmmsszzz',aDateTime);

end;

function Get_UserName(aUserId:String):String;
var
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HITEMS_EMPLOYEE_V ' +
              'WHERE USERID = :param1 ');
      ParamByName('param1').AsString := aUserId;
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

function Get_trCodeName(aCode:String):String;
var
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HITEMS_TRC_ROOT ' +
              'WHERE ROOTNO = :param1 ');
      ParamByName('param1').AsString := aCode;
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('ROOTNAME').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function Get_Replace_Date_Format(aKey:String):String;
var
  s : String;
begin
  if Length(aKey) = 17 then
  begin
    try
      s := Copy(aKey,1,4) + FormatSettings.DateSeparator +
           Copy(aKey,5,2) + FormatSettings.DateSeparator +
           Copy(aKey,7,2) + ' ' +
           Copy(aKey,9,2) + FormatSettings.TimeSeparator +
           Copy(aKey,11,2) + FormatSettings.TimeSeparator +
           Copy(aKey,13,2) + '.' +
           Copy(aKey,15,3);

      Result := s;

    except
      Result := '';
    end;
  end
  else
    Result := '';

end;

function Delete_HiTEMS_TRC_ATTFILES(aOwner,aFlag,aLcFileName:String):Boolean;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := Dm1.TSession1;

    with DM1.OraQuery1 do
    begin
      try
        Close;
        SQL.Clear;
        SQL.Add('Delete From HiTEMS_TRC_ATTFILES ' +
                'where OWNER = '+aOwner+
                'and FLAG = '''+aFlag+''' ' +
                'and LCFILENAME = '''+aLcFileName+''' ');

        ExecSQL;
      except
        on e:exception do
        begin
          ShowMessage(e.Message);
          Raise;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function Insert_Into_HiTEMS_TRC_ATTFILES(aOwner,aFlag,aDBfileName,aLcFileName,
aFileExt,aFileSize,aPath : String): Boolean;
var
  li : Integer;
  lms : TMemoryStream;
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.TSession1;
    OraQuery.Options.TemporaryLobUpdate := True;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into HiTEMS_TRC_ATTFILES ' +
              'Values(:OWNER, :FLAG, :DBFILENAME, :LCFILENAME, :FILEEXT, ' +
              ':FILESIZE, :FILES, :INDATE) ');

      lms := TMemoryStream.Create;
      try
        try
          ParamByName('OWNER').AsString      := aOwner;
          ParamByName('FLAG').AsString       := aFlag;
          ParamByName('DBFILENAME').AsString := aDBfileName;
          ParamByName('LCFILENAME').AsString := aLcfileName;
          ParamByName('FILEEXT').AsString    := aFileExt;
          ParamByName('FILESIZE').AsString   := aFileSize;
          ParamByName('INDATE').AsDateTime   := Now;

          lms.Clear;
          lms.Position := 0;

          lms.LoadFromFile(aPath);

          if lms <> nil then
          begin
            ParamByName('FILES').ParamType := ptInput;
            ParamByName('FILES').AsOraBlob.LoadFromStream(lms);
            ExecSQL;
          end;
        except
          on e : exception do
          begin
            ShowMessage(e.Message);
            raise;
          end;
        end;
      finally
        FreeAndNil(lms);
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function Get_AttFileCount(aOwner:String) : Integer;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.TSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DBFILENAME FROM HITEMS_TRC_ATTFILES ' +
              'WHERE OWNER = :param1 ');
      ParamByName('param1').AsString := aOwner;
      Open;

      if RecordCount > 0 then
        Result := RecordCount
      else
        Result := 0;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

end.


