unit ServerMethods_TRC_Unit;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth, Forms,
  Data.DBXJSON, Data.DBXJSONCommon, Ora, Data.DB, DateUtils, System.IOUtils,
  System.strUtils, Graphics, GraphUtil, PngImage, GIFImg, Jpeg;

type
{$METHODINFO ON}
  TServerMethods_TRC = class(TComponent)
  private
    { Private declarations }
    FID : string;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    function Return_Values(aTJSONPair:TJSONPair) : String;
    // 문제점 보고서 관련
    function Insert_Report(trData:TJSONObject; out ReturnMessage: string): Boolean;
    function Insert_Trouble_Image(CODEID, FileNm: String;
    out ReturnMessage: string): Boolean;

    function Get_TroubleImages(aCodeId:String;aTabIdx:Integer):TJSONArray;

    function LoginUser(UserName,UserPw,UserMobileSer: string; out ReturnMessage: string): Boolean;
    function Get_Himsen_Info: TJSONArray;

    function Summit_Report(RPTYPE, TITLE, ITEMNAME, ENGTYPE, STATUS, INFORMER : String; out ReturnMessage: string): Boolean;
    function Select_Manager(userid: string): String;

    function DateTimeToMilliseconds(DateTime: TDateTime): Int64;
    function Trouble_Detail_View(FCodeId : String; FSIdx : integer) : TJSONArray;

    function Get_User_Telno(DEPTNO : String) : TJSONArray;

    function Get_Category: TJSONArray;

    function Insert_Image_Info(EQUIPNO, EQTYPE, EQNO, EQMAKER, EQNAME, EQSTD, EQLOCATION1, EQLOCATION2, FileNm : String;
  out ReturnMessage: string): Boolean;
    function Get_Position: TJSONArray;
    function Get_EQUIP_NO(EQTYPE : String): TJSONArray;
    function Get_Equip_List(): TJSONArray;
    function Get_trc_issue_list(aInformer, aKeyValue, aTypeCode:String;aInterval,aTabIndex:Integer): TJSONArray;


    function Get_trc_root : TJSONArray;
    function Get_Based_ApproveLines(aEmpno:String) : TJSONArray;
    function Trouble_Temp_CODE_Generator(aInformer:String):String; // 임시 코드 번호 생성...

    function Check_for_Mobile_Equimpment(aMSer:String) : Boolean;
    function Input_of_the_Log_Data_to_DB(aInOut,aUserID,aMSer:String) : Boolean;
    function Get_userNameAndPosition(aUserId:String):String;
    function Get_Deptname: TJSONArray;
    function Get_DeptNo(aUserId:String) : String;
    function Get_TeamNo(aUSerId:String) : String;
    function Get_EmpList(aUserId:String) : TJSONArray;
  end;
{$METHODINFO OFF}

implementation

uses
  IdCoderMIME,
  GUID_Utils_Unit,
  DataModule_Unit;

function TServerMethods_TRC.Get_trc_issue_list(
aInformer, aKeyValue, aTypeCode:String;aInterval,aTabIndex:Integer): TJSONArray;
var
  OraQuery1 : TOraQuery;
  tobj : TJSONObject;
  li : integer;
  ls,ld : TDateTime;
  lsql : String;
  i_descr, i_name_kor, i_informer, i_indate, i_status, i_typename, i_pcause, i_itemname, i_typecode, i_trouble_no : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      if aTabIndex <> 0 then
      begin
        Close;
        sql.Clear;
        SQL.Add('SELECT A.*, B.USERID, B.NAME_KOR, B.CLASS_, C.CLASS_, C.DESCR ' +
                'FROM HITEMS_TRC_ISSUE A, HITEMS_EMPLOYEE B, ' +
                'HITEMS_EMPLOYEE_CLASS C ' +
                'WHERE A.INFORMER = B.USERID ' +
                'AND B.CLASS_ = C.CLASS_ ');

        if aTypeCode <> '' then
          SQL.Add('AND A.TYPECODE like '''+aTypeCode+'%''');

        if aKeyValue <> '' then
          SQL.Add('AND UPPER(A.ITEMNAME) LIKE ''%'+aKeyValue+'%''');

      end else
      begin
        Close;
        sql.Clear;
        SQL.Add('SELECT A.*, B.USERID, B.NAME_KOR, B.CLASS_, C.CLASS_, C.DESCR ' +
                'FROM TROUBLE_DATA A, HITEMS_EMPLOYEE B, ' +
                'HITEMS_EMPLOYEE_CLASS C ' +
                'WHERE A.INEMPNO = B.USERID ' +
                'AND B.CLASS_ = C.CLASS_ ');

        if aKeyValue <> '' then
          SQL.Add('AND UPPER(A.TITLE) LIKE ''%'+aKeyValue+'%''');

      end;

      case aInterval of
        0 :
        begin
          SQL.Add('AND A.INDATE = :ls ');
          ParamByName('ls').AsDate := Today;
        end;

        1 :
        begin
          SQL.Add('AND A.INDATE >= :ls AND A.INDATE <= :ld');
          ParamByName('ls').AsDate := StartOfTheWeek(Today);
          ParamByName('ld').AsDate := EndOfTheWeek(Today);
        end;

        2 :
        begin
          SQL.Add('AND A.INDATE >= :ls AND A.INDATE <= :ld');
          ParamByName('ls').AsDate := StartOfTheMonth(Today);
          ParamByName('ld').AsDate := EndOfTheMonth(Today);
        end;
      end;


      Open;

      if RecordCount <> 0 then
      begin

        Result := TJSONArray.Create;
        while not eof do
        begin
          tobj := TJSONObject.Create;

          if aTabIndex <> 0 then
          begin
            i_trouble_no := FieldByName('TROUBLE_NO').AsString;
            i_itemname := FieldByName('ITEMNAME').AsString;
            i_informer := FieldByName('INFORMER').AsString;
            i_indate := FieldByName('INDATE').AsString;
            i_status := FieldByName('STATUS').AsString;
            i_typename := FieldByName('TYPENAME').AsString;
            i_pcause := FieldByName('PCAUSE').AsString;
            i_typecode := FieldByName('TYPECODE').AsString;
            i_name_kor := FieldByName('NAME_KOR').AsString;
            i_descr := FieldByName('DESCR').AsString;
          end else
          begin
            i_trouble_no := FieldByName('CODEID').AsString;
            i_itemname := FieldByName('ITEMNAME').AsString;
            i_informer := FieldByName('INEMPNO').AsString;
            i_indate := FieldByName('INDATE').AsString;
            i_status := FieldByName('STATUS').AsString;
            i_typename := FieldByName('ENGTYPE').AsString;
            i_pcause := FieldByName('STATUSTITLE').AsString;
            i_typecode := FieldByName('PROJNO').AsString;
            i_name_kor := FieldByName('NAME_KOR').AsString;
            i_descr := FieldByName('DESCR').AsString;
          end;


          if not(i_informer = '') then
          begin
            Result.Add(tobj.addPair('DESCR',i_descr)
                           .AddPair('TROUBLE_NO',i_trouble_no)
                           .AddPair('ITEMNAME',i_itemname)
                           .AddPair('INFORMER',i_informer)
                           .AddPair('INDATE',i_indate)
                           .AddPair('STATUS',i_status)
                           .AddPair('TYPENAME',i_typename)
                           .AddPair('PCAUSE',i_pcause)
                           .AddPair('TYPECODE',i_typecode)
                           .AddPair('NAME_KOR',i_name_kor));

            Next;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function TServerMethods_TRC.Get_trc_root: TJSONArray;
var
  OraQuery : TOraQuery;
  lObj : TJSONObject;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT A.ROOTNAME PARENT, B.* ' +
              'FROM HITEMS_TRC_ROOT A, HITEMS_TRC_ROOT B ' +
              'WHERE A.ROOTNO > 0 ' +
              'AND A.ROOTNO = B.PRTROOTNO ' +
              'ORDER BY B.ROOTNO, B.SORTNO ');
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONArray.Create;
        while not eof do
        begin
          lObj := TJSONObject.Create;
          lObj.AddPair('PARENT',FieldByName('PARENT').AsString)
              .AddPair('ROOTNO',FieldByName('ROOTNO').AsString)
              .AddPair('PRTROOTNO',FieldByName('PRTROOTNO').AsString)
              .AddPair('ROOTNAME',FieldByName('ROOTNAME').AsString)
              .AddPair('ROOTLV',FieldByName('ROOTLV').AsString)
              .AddPair('SORTNO',FieldByName('SORTNO').AsString);

          Result.Add(lObj);

          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_TRC.Get_TroubleImages(aCodeId: String;
  aTabIdx: Integer): TJSONArray;
var
  Jobj : TJSONObject;

  TS : TStream;
  MS : TMemoryStream;
  FileName : String;
  fullpath : String;
  OraQuery : TOraQuery;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    Result := TJSONArray.Create;
    with OraQuery do
    begin
      case aTabIdx of
        0 : //TROUBLE_ATTFILES
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from Trouble_Attfiles where CODEID = :param1');
          SQL.Add('and ATTFLAG = ''I'' order by Indate DESC');
          parambyname('param1').AsString := aCodeId;
          Open;
        end;

        1 : //HITEMS_TRC_ISSUE
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from HITEMS_TRC_ATTFILES where OWNER = :param1');
          SQL.Add('and FLAG = ''I'' order by INDATE DESC');
          parambyname('param1').AsString := aCodeId;
          Open;
        end;
      end;


      if RecordCount <> 0 then
      begin
        while not eof do
        begin
          JObj := TJSONObject.Create;

          if not(Fieldbyname('DBFileName').AsString = '') then
          begin
            FileName := Fieldbyname('DBFileName').AsString;
            Result.Add(JObj.AddPair('FileName',FileName));

            fullpath := ExtractFilePath(Application.ExeName);
            fullpath := fullpath + '/Trouble_Img/'+FileName;
            if FileExists(fullpath) = false then
            begin
              try
                TS := TStream.Create;
                MS := TMemoryStream.Create;
                TS := CreateBlobStream(fieldbyname('Files'), bmread) ;
                MS.LoadFromStream(TS);
                Ms.SaveToFile(fullpath);
              finally
                TS.Free;
                MS.Free;
              end;
            end;
          end;
          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;


function TServerMethods_TRC.Get_userNameAndPosition(aUserId: String): String;
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
      SQL.Add('select * from HiTEMS_EMPLOYEE_V ' +
              'where USERID = '''+aUserId+''' ');
      Open;

      if not RecordCount <> 0 then
      begin
        lResult := FieldByName('NAME_KOR').AsString + '/'+
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

function TServerMethods_TRC.Get_EmpList(aUserId: String): TJSONArray;
var
  OraQuery : TOraQuery;
  lJsonObj : TJSONObject;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT USERID, NAME_KOR, DESCR FROM HITEMS_EMPLOYEE_V ' +
              'WHERE DEPTNO = :param1 ' +
              'AND GUNMU = ''I'' ' +
              'ORDER BY PRIV DESC, CLASS_, USERID ');
      ParamByName('param1').AsString := Get_DeptNo(aUserId);
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONArray.Create;
        while not eof do
        begin
          lJsonObj := TJSONObject.Create;

          lJsonObj.AddPair('USERID',FieldByName('USERID').AsString)
                  .AddPair('NAME',FieldByName('NAME_KOR').AsString)
                  .AddPair('DESCR',FieldByName('DESCR').AsString);

          Result.Add(lJsonObj);
          Next;

        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_TRC.Get_Equip_List(): TJSONArray;
var
  OraQuery1 : TOraQuery;
  tarr : TJSONArray;
  tobj : TJSONObject;
  li : integer;
  EQNO, EQMAKER, EQNAME : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  with OraQuery1 do
  begin
    Close;
    sql.Clear;
    sql.Add('select * from HITEMS_EQUIP_LIST ');
    Open;

    tarr := TJSONArray.Create;
    while not eof do
    begin
      tobj := TJSONObject.Create;

      EQNO := FieldByName('EQUIPNO').AsString;
      EQMAKER := FieldByName('EQMAKER').AsString;
      EQNAME := FieldByName('EQNAME').AsString;


      if not(EQNO = '') then
      begin
        tarr.Add(tobj.AddPair('EQNO',EQNO).AddPair('EQMAKER',EQMAKER).AddPair('EQNAME',EQNAME));

        Next;
      end;
    end;

    Result := tarr;
  end;

  FreeAndNil(OraQuery1);
end;




function TServerMethods_TRC.Get_EQUIP_NO(EQTYPE : String): TJSONArray;
var
  OraQuery1 : TOraQuery;
  tarr : TJSONArray;
  tobj : TJSONObject;
  li : integer;
  EQNO : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  with OraQuery1 do
  begin
    Close;
    sql.Clear;
    sql.Add('select * from HITEMS_EQUIP_LIST where EQTYPE = '''+EQTYPE+''' order by EQNO');
    Open;

    tarr := TJSONArray.Create;
    while not eof do
    begin
      tobj := TJSONObject.Create;

      EQNO := FieldByName('EQNO').AsString;


      if not(EQNO = '') then
      begin
        tarr.Add(tobj.AddPair('EQNO',EQNO));

        Next;
      end;
    end;

    Result := tarr;
  end;

  FreeAndNil(OraQuery1);
end;

function TServerMethods_TRC.Get_Position: TJSONArray;
var
  OraQuery1 : TOraQuery;
  tarr : TJSONArray;
  tobj : TJSONObject;
  LOC_CODE, LOC_NAME : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  with OraQuery1 do
  begin
    Close;
    sql.Clear;
    sql.Add('select * from HITEMS_LOC_CODE ');
    Open;

    tarr := TJSONArray.Create;
    while not eof do
    begin
      tobj := TJSONObject.Create;

      LOC_CODE := FieldByName('LOC_CODE').AsString;
      LOC_NAME := FieldByName('LOC_NAME').AsString;

      if not(LOC_CODE = '') then
      begin
        tarr.Add(tobj.AddPair('LOC_CODE',LOC_CODE).AddPair('LOC_NAME',LOC_NAME));

        Next;
      end;
    end;

    Result := tarr;
  end;

  FreeAndNil(OraQuery1);
end;

function TServerMethods_TRC.Get_TeamNo(aUSerId: String): String;
var
  OraQuery : TOraQuery;
  lapproval,
  lchecker : String;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT TEAMNO FROM HITEMS_EMPLOYEE ' +
              'WHERE USERID = :param1 ');

      ParamByName('param1').AsString := aUserId;
      Open;

      if RecordCount <> 0 then
        Result := FieldByName('TEAMNO').AsString
      else
        Result := '';

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_TRC.Input_of_the_Log_Data_to_DB(aInOut, aUserID,
  aMSer: String): Boolean;
var
  li : integer;
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    try
      with OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Insert Into HiTEMS_LOG_INFO ');
        SQL.Add('Values(:SYSCODE, :IOCODE, :IOTIME, :USERID, :IPNO, :MOBILESERIAL)');
        ParamByName('SYSCODE').AsString      := 'M0101';
        ParamByName('IOCODE').AsString       := aInOut;
        ParamByName('IOTIME').AsDateTime     := Now;
        ParamByName('USERID').AsString       := aUserID;
    //    ParamByName('IPNO').AsString         := aip;
        ParamByName('MOBILESERIAL').AsString := aMSer;
        ExecSQL;

        Result := True;
      end;
    except
      Result := False;

    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function TServerMethods_TRC.Insert_Image_Info(EQUIPNO, EQTYPE, EQNO, EQMAKER, EQNAME, EQSTD, EQLOCATION1, EQLOCATION2, FileNm : String;
  out ReturnMessage: string): Boolean;
var
  Lint : Int64;
  LDate : TDateTime;
  LStr, LStr1 : String;
  Flag, Fext : String;
  LMS : TMemoryStream;
  OraQuery1 : TOraQuery;
  FilePath : String;
begin
  Flag := 'I';
  Fext := ExtractFileExt(FileNm);
  Fext := UpperCase(Fext);
  Delete(Fext,1,1);


  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  OraQuery1.Options.TemporaryLobUpdate := True;


  LDate := Now;
  Lint := DateTimeToMilliseconds(LDate);

  try
    with OraQuery1 do
    begin
      Close;
      Sql.clear;
      sql.add('Insert into HITEMS_EQUIP_LIST Values(:EQUIPNO,:EQTYPE,:EQNO,:EQMAKER, ' +
              ':EQNAME,:EQSTD,:EQLOCATION1,:EQLOCATION2,:EQIMG ) ');

      //ParamByName('EQUIPNO').AsString := IntToStr(Lint)+'.'+UpperCase(Fext);
      ParamByName('EQUIPNO').AsString := EQUIPNO;
      ParamByName('EQTYPE').AsString := EQTYPE;
      ParamByName('EQNO').AsString := EQNO;
      ParamByName('EQMAKER').AsString := EQMAKER;
      ParamByName('EQNAME').AsString := EQNAME;
      ParamByName('EQSTD').AsString := EQSTD;
      ParamByName('EQLOCATION1').AsString := EQLOCATION1;
      ParamByName('EQLOCATION2').AsString := EQLOCATION2;

      if Flag = 'I' then
      begin
        try
          LMS := TMemoryStream.Create;
          LMS.Position := 0;
          //LMS.LoadFromFile('/mnt/sdcard/DCIM/Camera/'+FileNm);
          LMS.LoadFromFile('D:\HiTEMS\service\upload\'+FileNm);

          parambyname('EQIMG').ParamType := ptInput;
          parambyname('EQIMG').AsOraBlob.LoadFromStream(LMS);

          Execute;
        finally
          LMS.Free;
        end;
      end;
    end;
      Result := True;
      ReturnMessage := '이미지 등록 성공!!';
      DeleteFile('D:\HiTEMS\service\upload\'+FileNm);

  except
    Result := False;
    ReturnMessage := '이미지 등록 실패!!';
    DeleteFile('D:\HiTEMS\service\upload\'+FileNm);
  end;

  FreeAndNil(OraQuery1);
end;

function TServerMethods_TRC.Insert_Report(trData: TJSONObject;
  out ReturnMessage: string): Boolean;
var
  OraQuery1 : TOraQuery;
  lstr,
  TROUBLE_NO,
  INFORMER : String;


begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  Result := false;
  try
    if trData.Size > 0 then
    begin
      INFORMER := Return_Values(trData.Get('INFORMER'));

      with DM1.OraTransaction1 do
      begin
        DM1.OraTransaction1.DefaultSession := DM1.OraSession1;
        StartTransaction;
        try
          TROUBLE_NO := Trouble_Temp_CODE_Generator(INFORMER);
          if TROUBLE_NO <> '' then
          begin
            with OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO TROUBLE_DATATEMP ' +
                      '(CODEID, RPTYPE, TITLE, REGTYPE, PROJNO, ENGTYPE,  ' +
                      ' TRTYPE1, TRTYPE2, TRTYPE3, TRTYPE4, TROUBLETYPE1, ' +
                      ' SDATE, PROCESS, PDATE, STATUS, REASON, PLAN, ' +
                      ' INEMPNO, APPROVED1, APPROVED2, APPROVED3, FRESULT,  ' +
                      ' INDATE, ITEMNAME ) '+
                      'VALUES( ' +
                      ' :CODEID, :RPTYPE, :TITLE, :REGTYPE, :PROJNO, :ENGTYPE,  ' +
                      ' :TRTYPE1, :TRTYPE2, :TRTYPE3, :TRTYPE4, :TROUBLETYPE1, ' +
                      ' :SDATE, :PROCESS, :PDATE, :STATUS, :REASON, :PLAN, ' +
                      ' :INEMPNO, :APPROVED1, :APPROVED2, :APPROVED3, :FRESULT, ' +
                      ' :INDATE, :ITEMNAME )');

              ParamByName('CODEID').AsString       := TROUBLE_NO;
              ParamByName('RPTYPE').AsString       := Return_Values(trData.Get('RPTYPE'));
              ParamByName('TITLE').AsString        := Return_Values(trData.Get('STATUS'));
              ParamByName('REGTYPE').AsString      := '0';
              ParamByName('PROJNO').AsString       := Return_Values(trData.Get('TYPECODE'));
              ParamByName('ENGTYPE').AsString      := Return_Values(trData.Get('TYPENAME'));

              ParamByName('TRTYPE1').AsString      := Return_Values(trData.Get('TRQUALITY'));
              ParamByName('TRTYPE2').AsString      := Return_Values(trData.Get('TRWORK'));
              ParamByName('TRTYPE3').AsString      := Return_Values(trData.Get('TRDRAW'));
              ParamByName('TRTYPE4').AsString      := Return_Values(trData.Get('TRETC'));
              ParamByName('TROUBLETYPE1').AsString := Return_Values(trData.Get('TRCODE'));

              ParamByName('SDATE').AsDateTime      := StrToDateTime(Return_Values(trData.Get('OCCURENCE')));
              ParamByName('PROCESS').AsString      := Return_Values(trData.Get('PLANNAME'));
              ParamByName('PDATE').AsDateTime      := StrToDateTime(Return_Values(trData.Get('PLANEND')));
              ParamByName('STATUS').AsString       := Return_Values(trData.Get('STATUS'));
              ParamByName('REASON').AsString       := Return_Values(trData.Get('PCAUSE'));
              ParamByName('PLAN').AsString         := Return_Values(trData.Get('COUNTMEASURE'));

              ParamByName('INEMPNO').AsString      := Return_Values(trData.Get('INFORMER'));

              lstr := Get_userNameAndPosition(Return_Values(trData.Get('APPROVE1')));
              ParamByName('APPROVED1').AsString    := lstr;
              lstr := Get_userNameAndPosition(Return_Values(trData.Get('APPROVE2')));
              ParamByName('APPROVED2').AsString    := lstr;
              lstr := Get_userNameAndPosition(Return_Values(trData.Get('APPROVE3')));
              ParamByName('APPROVED3').AsString    := lstr;
              ParamByName('FRESULT').AsInteger     := 0;

              ParamByName('INDATE').AsDateTime     := Now;
              ParamByName('ITEMNAME').AsString     := Return_Values(trData.Get('ITEMNAME'));
              ExecSQL;

              //결재자 정보 저장
              Close;
              SQL.Clear;
              SQL.Add('Insert Into ZHITEMS_APPROVER ' +
                      ' (CODEID, FLAG, ACount, APPROVAL1, APPROVAL2, APPROVAL3) ' +
                      'Values( ' +
                      ' :CODEID, :FLAG, :ACount, :APPROVAL1, :APPROVAL2, :APPROVAL3)');

              Parambyname('CODEID').AsString    := TROUBLE_NO;
              Parambyname('FLAG').AsString      := 'P01TR';
              Parambyname('ACount').AsInteger   := 3;
              Parambyname('APPROVAL1').AsString := Return_Values(trData.Get('APPROVE1')); //담당자
              Parambyname('APPROVAL2').AsString := Return_Values(trData.Get('APPROVE2')); // 결재1
              Parambyname('APPROVAL3').AsString := Return_Values(trData.Get('APPROVE3')); // 결재2
              ExecSQL;

              //결재 상태 저장
              Close;
              SQL.Clear;
              SQL.Add('Insert Into ZHITEMS_APPROVEP ' +
                      ' (CODEID, Pending, APPROVAL1, APPROVAL2, APPROVAL3, STATUS) ' +
                      'Values( ' +
                      ' :CODEID, :Pending, :APPROVAL1, :APPROVAL2, :APPROVAL3, :STATUS)');

              Parambyname('CODEID').AsString     := TROUBLE_NO;
              Parambyname('Pending').AsInteger   := 1; //1 = 담당자 결재상신한 상태
              Parambyname('APPROVAL1').AsInteger := 1; //담당자
              Parambyname('APPROVAL2').AsInteger := 0; // 결재1
              Parambyname('APPROVAL3').AsInteger := 0; // 결재2
              Parambyname('STATUS').AsInteger    := 1; // 0: 작성중, 1:결재진행중, 2:반려, 3 결재완료
              ExecSQL;

              //결재일 저장
              Close;
              SQL.Clear;
              SQL.Add('Insert Into ZHITEMS_APPROVED ' +
                      ' (CODEID, Pending, APPROVAL1) ' +
                      'Values( ' +
                      ' :CODEID, :Pending, :APPROVAL1)');

              Parambyname('CODEID').AsString       := TROUBLE_NO;
              Parambyname('Pending').AsInteger     := 1; //1 = 담당자 결재상신한 상태
              Parambyname('APPROVAL1').AsDateTime  := Now;

              ExecSQL;

            end;
            Commit;
            ReturnMessage := TROUBLE_NO;
            Result := True;
          end else
          begin
            ReturnMessage := '문서번호 생성을 실패하였습니다.';
            Result := False;
            Rollback;
          end;
        except
          on E: Exception do
          begin
            Result := False;
            Rollback;
            ReturnMessage := E.Message;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function TServerMethods_TRC.Get_Based_ApproveLines(
  aEmpno: String): TJSONArray;
var
  OraQuery : TOraQuery;
  lapproval,
  lchecker : String;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT MANAGER FROM HITEMS_DEPTNO WHERE DEPTNO = ( ' +
              'SELECT TEAMNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1)');
      ParamByName('param1').AsString := aEmpno;
      Open;

      lChecker := FieldByName('MANAGER').AsString;





    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_TRC.Get_Category: TJSONArray;
var
  OraQuery1 : TOraQuery;
  tarr : TJSONArray;
  tobj : TJSONObject;
  TYPENAME, TYPECODE : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  with OraQuery1 do
  begin
    Close;
    sql.Clear;
    sql.Add('select * from HITEMS_EQUIP_TYPE ');
    Open;

    tarr := TJSONArray.Create;
    while not eof do
    begin
      tobj := TJSONObject.Create;

      TYPENAME := FieldByName('TYPENAME').AsString;
      TYPECODE := FieldByName('TYPECODE').AsString;

      if not(TYPENAME = '') then
      begin
        tarr.Add(tobj.AddPair('TYPENAME',TYPENAME).AddPair('TYPECODE',TYPECODE));

        Next;
      end;
    end;

    Result := tarr;
  end;

  FreeAndNil(OraQuery1);
end;

function TServerMethods_TRC.Get_Deptname: TJSONArray;
var
  OraQuery1 : TOraQuery;
  tarr : TJSONArray;
  tobj : TJSONObject;
  DeptName, DeptNo : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  with OraQuery1 do
  begin
    Close;
    sql.Clear;
    sql.Add('Select * ');
    sql.Add('From HITEMS_DEPTNO WHERE LV = ''0'' order by DEPTNAME ');
    Open;

    tarr := TJSONArray.Create;
    while not eof do
    begin
      tobj := TJSONObject.Create;
      DeptName := FieldByName('DEPTNAME').AsString;
      DeptNo := FieldByName('DEPTNO').AsString;

      if not(DeptName = '') then
        tarr.Add(tobj.AddPair('DEPTNAME', DeptName).AddPair('DEPTNO', DeptNo));
      Next;
    end;
    Result := tarr;
  end;
  FreeAndNil(OraQuery1);
end;

function TServerMethods_TRC.Get_DeptNo(aUserId: String): String;
var
  OraQuery : TOraQuery;
  lapproval,
  lchecker : String;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DEPTNO FROM HITEMS_EMPLOYEE ' +
              'WHERE USERID = :param1 ');

      ParamByName('param1').AsString := aUserId;
      Open;

      if RecordCount <> 0 then
        Result := FieldByName('DEPTNO').AsString
      else
        Result := '';

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;


function TServerMethods_TRC.Get_User_Telno(DEPTNO : String) : TJSONArray;
var
  OraQuery1 : TOraQuery;
  tarr : TJSONArray;
  tobj : TJSONObject;
  UserName, telno : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;


  with OraQuery1 do
  begin
    Close;
    sql.Clear;
    sql.Add('Select * ');
    sql.Add('From HITEMS_EMPLOYEE WHERE DEPTNO = '''+DEPTNO+'''Order by NAME_KOR ');
    Open;

    tarr := TJSONArray.Create;
    while not eof do
    begin
      tobj := TJSONObject.Create;
      UserName := FieldByName('NAME_KOR').AsString;
      telno := FieldByName('HPNO').AsString;

      if(telno = '') then
      begin
        telno := '-';
      end;

      if not(UserName = '') then
        tarr.Add(tobj.AddPair('USERNAME', UserName).AddPair('HPNO', telno));
      Next;
    end;
    Result := tarr;
  end;

  FreeAndNil(OraQuery1);
end;


function TServerMethods_TRC.Trouble_Detail_View(FCodeId : String; FSIdx : integer) : TJSONArray;
var
  Jobj : TJSONObject;
  li : integer;
  lstr : String;
  gf : TStringList;
  RPTYPE, TITLE, PROJNO, ITEMNAME, ENGTYPE, STATUSTITLE, REASONTITLE,
  PLANTITLE, REASON1TITLE, RESULTTITLE, EMPNO, INEMPNO, INFORMER, INDATE, STEP  : String;
  LSQL : String;
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      case FSIdx of
        0 : // TROUBLE_DATA
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM TROUBLE_DATA WHERE CODEID = :param1');
          ParamByName('param1').AsString := FCodeId;
          Open;
          if RecordCount <> 0 then
          begin
            Result := TJSONArray.Create;

            case Fieldbyname('RPTYPE').AsInteger of
              0 : lstr := '품질문제';
              1 : lstr := '설비문제';
              2 : lstr := '문제예상';
            end;

            if not(lstr = '') then
              RPTYPE := lstr
            else
              RPTYPE := 'Null';

            if FieldByName('PROJNO').IsNull then
              PROJNO := 'Null'
            else
              PROJNO := FieldByName('PROJNO').AsString;

            if not(Fieldbyname('ENGTYPE').AsString = '') then
              ENGTYPE := Fieldbyname('ENGTYPE').AsString
            else
              ENGTYPE := 'Null';

            if not(Fieldbyname('TITLE').AsString = '') then
              TITLE := Fieldbyname('TITLE').AsString
            else
              TITLE := 'Null';

            if not(Fieldbyname('ITEMNAME').AsString = '') then
              ITEMNAME := Fieldbyname('ITEMNAME').AsString
            else
              ITEMNAME := 'Null';

            INEMPNO := Get_userNameAndPosition(Fieldbyname('INEMPNO').AsString); //작성자
            EMPNO := Get_userNameAndPosition(Fieldbyname('EMPNO').AsString); //설계담당

            if not(Fieldbyname('INDATE').AsString = '') then
              INDATE := FormatDateTIme('YYYY-MM-DD', Fieldbyname('INDATE').AsDateTime)
            else
              INDATE := 'Null';

            if FieldByName('STATUSTITLE').IsNull then
              if FieldByName('STATUS').IsNull then
                STATUSTITLE := 'Null'
              else
                STATUSTITLE := FieldByName('STATUS').AsString
            else
              STATUSTITLE := FieldByName('STATUSTITLE').AsString;

            if FieldByName('REASONTITLE').IsNull then
              if FieldByName('REASON').IsNull then
                REASONTITLE := 'Null'
              else
                REASONTITLE := FieldByName('REASON').AsString
            else
              REASONTITLE := FieldByName('REASONTITLE').AsString;

            if FieldByName('PLANTITLE').IsNull then
              if FieldByName('PLAN').IsNull then
                PLANTITLE := 'Null'
              else
                PLANTITLE := FieldByName('PLAN').AsString
            else
              PLANTITLE := FieldByName('PLANTITLE').AsString;

            if FieldByName('REASON1TITLE').IsNull then
              if FieldByName('REASON1').IsNull then
                REASON1TITLE := 'Null'
              else
                REASON1TITLE := FieldByName('REASON1').AsString
            else
              REASON1TITLE := FieldByName('REASON1TITLE').AsString;

            if FieldByName('RESULTTITLE').IsNull then
              if FieldByName('RESULT').IsNull then
                RESULTTITLE := 'Null'
              else
                RESULTTITLE := FieldByName('RESULT').AsString
            else
              RESULTTITLE := FieldByName('RESULTTITLE').AsString;

            INFORMER := Get_userNameAndPosition(FieldByName('INEMPNO').AsString);

            STEP := 'Null';
          end;
        end;

        1 : // HiTEMS_TRC_ISSUE
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM HiTEMS_TRC_ISSUE WHERE TROUBLE_NO = :param1');
          ParamByName('param1').AsString := FCodeId;
          Open;
          if RecordCount <> 0 then
          begin
            Result := TJSONArray.Create;

            case Fieldbyname('RPTYPE').AsInteger of
              0 : lstr := '품질문제';
              1 : lstr := '설비문제';
              2 : lstr := '문제예상';
            end;

            if not(lstr = '') then
              RPTYPE := lstr
            else
              RPTYPE := 'Null';

            if FieldByName('TYPECODE').IsNull then
              PROJNO := 'Null'
            else
              PROJNO := FieldByName('TYPECODE').AsString;

            if not(Fieldbyname('TYPENAME').AsString = '') then
              ENGTYPE := Fieldbyname('TYPENAME').AsString
            else
              ENGTYPE := 'Null';

            if not(Fieldbyname('STATUS').AsString = '') then
              TITLE := Fieldbyname('STATUS').AsString
            else
              TITLE := 'Null';

            if not(Fieldbyname('ITEMNAME').AsString = '') then
              ITEMNAME := Fieldbyname('ITEMNAME').AsString
            else
              ITEMNAME := 'Null';

            INEMPNO := Get_userNameAndPosition(Fieldbyname('INFORMER').AsString); //작성자
            EMPNO := 'Null';

            if not(Fieldbyname('INDATE').AsString = '') then
              INDATE := FormatDateTIme('YYYY-MM-DD', Fieldbyname('INDATE').AsDateTime)
            else
              INDATE := 'Null';

            if FieldByName('STATUS').IsNull then
              STATUSTITLE := 'Null'
            else
              STATUSTITLE := FieldByName('STATUS').AsString;

            if FieldByName('PCAUSE').IsNull then
              REASONTITLE := 'Null'
            else
              REASONTITLE := FieldByName('PCAUSE').AsString;

            if FieldByName('COUNTMEASURE').IsNull then
              PLANTITLE := 'Null'
            else
              PLANTITLE := FieldByName('COUNTMEASURE').AsString;

            REASON1TITLE := 'Null';
            RESULTTITLE  := 'Null';

            INFORMER := Get_userNameAndPosition(FieldByName('INFORMER').AsString);

            STEP := 'Null';
          end;
        end;
      end;//case

      if RecordCount <> 0 then
      begin
        JObj := TJSONObject.Create;
        Result.Add(JObj.AddPair('RPTYPE',RPTYPE)
                       .AddPair('ENGTYPE',ENGTYPE)
                       .AddPair('PROJNO',PROJNO)
                       .AddPair('TITLE',TITLE)
                       .AddPair('ITEMNAME',ITEMNAME)
                       .AddPair('STATUSTITLE',STATUSTITLE)
                       .AddPair('REASONTITLE',REASONTITLE)
                       .AddPair('PLANTITLE',PLANTITLE)
                       .AddPair('REASON1TITLE',REASON1TITLE)
                       .AddPair('RESULTTITLE',RESULTTITLE)
                       .AddPair('INEMPNO',INEMPNO)
                       .AddPair('EMPNO',EMPNO)
                       .AddPair('INDATE',INDATE)
                       .AddPair('INFORMER',INFORMER)
                       .AddPair('STEP',STEP));

      end;
    end;//with
  finally
    FreeAndNil(OraQuery1);
  end;
end;


function TServerMethods_TRC.Trouble_Temp_CODE_Generator(aInformer:String):String; // 임시 코드 번호 생성...
var
  OraQuery : TOraQuery;
  LCount : integer;
  LDouble : Double;
  LUpDate, LInsert : Boolean;
  ldeptNo, lteamNo : String;
  LYear, LMonth, LSeqNo : String;
  LStr : String;
  LP1,LP2,LP3,LP4 : String; // Update 변수

begin
  Result := '';

  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    lteamNo := Get_TeamNo(aInformer);
    ldeptNo := Get_DeptNo(aInformer);
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT SEQNO FROM TROUBLE_TEMPNO  ' +
              'WHERE DEPT = (SELECT DEPTNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1) ' +
              'And DTeam = (SELECT SUBSTR(TEAMNO,4,1) TEAMNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1) ' +
              'And Year = (SELECT TO_CHAR(SYSDATE,''yyyy'') FROM DUAL) ' +
              'AND Month = (SELECT TO_CHAR(SYSDATE,''mm'') FROM DUAL) ');

      ParamByName('Param1').AsString := aInformer;
      Open;

      if RecordCount = 0 then
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO TROUBLE_TEMPNO ' +
                '(SELECT DEPTNO, SUBSTR(TEAMNO,4,1) TEAMNO, ' +
                'TO_CHAR(SYSDATE,''YYYY'') YEAR, TO_CHAR(SYSDATE,''MM'') MONTH,' +
                '(1) SEQNO FROM HITEMS_EMPLOYEE ' +
                'WHERE DEPTNO = (SELECT DEPTNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1 )' +
                'AND TEAMNO = (SELECT TEAMNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1 )' +
                'AND ROWNUM = 1 ');
        ParamByName('Param1').AsString := aInformer;

        ExecSQL;
      end
      else
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE TROUBLE_TEMPNO SET ' +
                'SEQNO = (SELECT (SEQNO+1) SEQNO FROM TROUBLE_TEMPNO  ' +
                'WHERE DEPT = (SELECT DEPTNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1 ) ' +
                'And DTeam = (SELECT SUBSTR(TEAMNO,4,1) TEAMNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1 ) ' +
                'And Year = TO_CHAR(SYSDATE,''YYYY'') ' +
                'AND MONTH = TO_CHAR(SYSDATE,''MM'')) ' +
                'WHERE DEPT = (SELECT DEPTNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1 ) ' +
                'And DTeam = (SELECT SUBSTR(TEAMNO,4,1) TEAMNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1 ) ' +
                'And Year = TO_CHAR(SYSDATE,''YYYY'') ' +
                'AND MONTH = TO_CHAR(SYSDATE,''MM'') ');
        ParamByName('Param1').AsString := aInformer;
        ExecSQL;
      end;//else

      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TROUBLE_TEMPNO ' +
              'WHERE DEPT = (SELECT DEPTNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1 ) ' +
              'And DTeam = (SELECT SUBSTR(TEAMNO,4,1) TEAMNO FROM HITEMS_EMPLOYEE WHERE USERID = :param1 ) ' +
              'And Year = TO_CHAR(SYSDATE,''YYYY'') ' +
              'AND MONTH = TO_CHAR(SYSDATE,''MM'') ');
      ParamByName('Param1').AsString := aInformer;
      Open;

      LYear   := FieldByName('Year').AsString;
      LMonth  := FieldByName('Month').AsString;
      LDouble := StrToint(FieldByName('SeqNo').AsString);
      LSeqNo  := formatFloat('000',LDouble);
      LStr    := FieldByName('DEPT').AsString+FieldByName('DTEAM').AsString;

      Result := 'TT_'+LSTR+'_'+ LYear +'_'+ LMonth +'_'+ LSeqNo; //관리번호 완성~~
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_TRC.Summit_Report(RPTYPE, TITLE, ITEMNAME, ENGTYPE,
  STATUS, INFORMER : String; out ReturnMessage: string): Boolean;
var
  LSQL : String;
  LCODEID : String;
  OraQuery1 : TOraQuery;
  FINFORMER : String;
  FManager : String;
  FItemNm : String;
  FEngType : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  Result := false;
  try
    if not(RPTYPE = '') and not(TITLE = '') and not(ITEMNAME = '') and not(ENGTYPE = '') then
    begin

      with OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into TROUBLE_MOBILE');
        SQL.Add('(TCODEID, MCODEID, STATUS, ITEMNAME, REASON,');
        SQL.Add(' ENGTYPE, RPTYPE, INFORMER, MANAGER, INDATE, EMPNO, INEMPNO, STEP, PROJNO)');
        SQL.Add('Values(:TCODEID, :MCODEID, :STATUS, :ITEMNAME, :REASON,');
        SQL.Add('       :ENGTYPE, :RPTYPE, :INFORMER, :MANAGER, :INDATE, :EMPNO, :INEMPNO, :STEP , :PROJNO)');

        LCODEID := 'TM_'+ FormatDateTime('YYYYMMDDHHmmss',Now);

        ParamByName('TCODEID').AsString   := '';
        ParamByName('MCODEID').AsString   := LCODEID;
        ParamByName('STATUS').AsString    := TITLE;//문제현상(제목)

        FItemNm := ITEMNAME;
        ParamByName('ITEMNAME').AsString  := FITEMNM;
        ParamByName('REASON').AsString    := STATUS;//추정원인

        FEngType := ENGTYPE;
        ParamByName('ENGTYPE').AsString   := FENGTYPE;
        ParamByName('RPTYPE').AsString    := RPTYPE;

        FINFORMER := INFORMER;
        ParamByName('INFORMER').AsString  := INFORMER;

        FManager := Select_Manager(INFORMER);
        ParamByName('MANAGER').AsString   := INFORMER;

        ParamByName('INDATE').AsDateTime  := Now;
        ParamByName('EMPNO').AsString     := '';
        ParamByName('INEMPNO').AsString   := '';
        ParamByName('STEP').AsInteger     := 0;
        ParamByName('PROJNO').AsString    := LeftStr(ENGTYPE, 6);



        ExecSQL;

        ReturnMessage := LCODEID;
        Result := True;
      end;
    end;
  except
    on E: Exception do
    begin
      ReturnMessage := E.Message;
    end;
  end;

  FreeAndNil(OraQuery1);
end;

function TServerMethods_TRC.Select_Manager(userid: string): String;
var
  OraQuery1 : TOraQuery;

begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from User_Info');
    SQL.Add('where Priv = 2 and TEAM = (select TEAM from User_Info where USERID = :param1)');
    parambyname('param1').AsString := userid;
    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('USERID').AsString
    else
      Result := '';
  end;

  FreeAndNil(OraQuery1);
end;

function TServerMethods_TRC.Get_Himsen_Info: TJSONArray;
var
  Jobj : TJSONObject;
  List : TJSONArray;
  li : integer;
  ENGTYPE, PROJNO, TYPES : String;
  LSQL : String;
  OraQuery1 : TOraQuery;

begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  LSQL := 'select DISTINCT(A.PROJNO), B.EngType, B.cylnum, B.engmodel ' +
          'from Trouble_Data A, HiMSENINFO B where A.PROJNO = B.PROJNO ' +
          'order by engmodel, cylnum';

  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(LSQL);
    Open;

    list := TJSONArray.Create;
    while not eof do
    begin
      Jobj := TJSONObject.Create;

      EngTYPE := FieldByName('PROJNO').AsString+'-'+FieldByName('EngType').AsString;
      PROJNO := FieldByName('PROJNO').AsString;
      TYPES := FieldByName('EngType').AsString;

      if not(EngType = '') then
        list.Add(JObj.AddPair('ENGTYPE',EngTYPE).AddPair('PROJNO',PROJNO).AddPair('TYPES',TYPES));

      Next;
    end;
    Result := List;
  end;

  FreeAndNil(OraQuery1);
end;


function TServerMethods_TRC.Check_for_Mobile_Equimpment(aMSer: String): Boolean;
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
      SQL.Add('select * from HITEMS_MOBILE_EQUIP_INFO ' +
              'where SVCNO = '''+aMSer+'''');

      Open;

      if not(RecordCount = 0) then
        Result := True
      else
        Result := False;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

constructor TServerMethods_TRC.Create(AOwner: TComponent);
begin
  inherited;
  FID := GetNewGUID;

end;

destructor TServerMethods_TRC.Destroy;
begin
  inherited;

end;

function TServerMethods_TRC.LoginUser(UserName, UserPw,
  UserMobileSer: string; out ReturnMessage: string): Boolean;
var
  LConfirmID : String;
  LCnt : integer;
  LMser : String;
  OraQuery1 : TOraQuery;
begin
  Result := false;
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    try
      if not(UserName = '') and not(UserPw = '') then
      begin
        with OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from HiTEMS_EMPLOYEE_V where UserID = :param1');
          ParamByName('param1').AsString := UserName;
          Open;

          LConfirmID := FieldByName('UserID').AsString;

          if LConfirmID = UserName then
          begin
            if Fieldbyname('PASSWD').AsString = UserPw then
            begin
  //            TDS_Manager.Instance.LoginUser(UserName);
  //            TDSSessionManager.GetThreadSession.PutData('username', UserName);
              ReturnMessage := Fieldbyname('Name_Kor').AsString +' 님 방문을 환영합니다.';

              LMSer := '0'+UserMobileSer;
              if Check_for_Mobile_Equimpment(LMSer) = True  then
                Result := Input_of_the_Log_Data_to_DB('In',UserName,LMSer)
              else
              begin
                Result := False;
                ReturnMessage := '엔진시험기술부 등록 장비가 아닙니다.';
              end;
            end
            else
            begin
              ReturnMessage := '비밀번호가 일치하지 않습니다.';
              Result := False;
            end;
          end
          else
          begin
            ReturnMessage := '등록된 ID가 없습니다.';
            Result := False;
          end;
        end;
      end
      else
      begin
        ReturnMessage := 'ID 또는 PW를 확인하여 주십시오.';
        Result := False;
      end;
    except
      on E: Exception do
      begin
        ReturnMessage := E.Message;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function TServerMethods_TRC.Return_Values(aTJSONPair: TJSONPair): String;
var
  lstr : String;
  ljsonValue : TJSONValue;
begin
  ljsonValue := aTJSONPair.JsonValue;
  Result := ljsonValue.Value;
end;

function TServerMethods_TRC.DateTimeToMilliseconds(DateTime: TDateTime): Int64;
{ Converts a TDateTime variable to Int64 milliseconds from 0001-01-01.}
var ts: System.SysUtils.TTimeStamp;
begin
{ Call DateTimeToTimeStamp to convert DateTime to TimeStamp: }
  ts  := System.SysUtils.DateTimeToTimeStamp(DateTime);
{ Multiply and add to complete the conversion: }
  Result  := Int64(ts.Date)*MSecsPerDay + ts.Time;
end;

function TServerMethods_TRC.Insert_Trouble_Image(CODEID, FileNm: String;
  out ReturnMessage: string): Boolean;
var
  Lint : Int64;
  LDate : TDateTime;
  LStr, LStr1 : String;
  Flag, Fext : String;
  LMS : TMemoryStream;
  OraQuery1 : TOraQuery;
  FilePath : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  OraQuery1.Options.TemporaryLobUpdate := True;

  Flag := 'I';
  Fext := ExtractFileExt(FileNm); // 파일 확장자만 가져오기
  Fext := UpperCase(Fext);  // 대문자로 . ex) .txt -> .TXT
  Delete(Fext,1,1);

  LDate := Now;
  Lint := DateTimeToMilliseconds(LDate);

  try
    with OraQuery1 do
    begin
      Close;
      Sql.clear;
      sql.add('Insert into TROUBLE_ATTFILES Values(:CODEID,:ATTFLAG,:DBFILENAME,:LCFILENAME, ' +
              ':FILEEXT,:FILESIZE,:FILES,:INDATE ) ');

      ParamByName('CODEID').AsString := CODEID;
      ParamByName('ATTFLAG').AsString := Flag;
      ParamByName('DBFILENAME').AsString := IntToStr(Lint)+'.'+UpperCase(Fext);
      ParamByName('LCFILENAME').AsString := FileNm;
      ParamByName('FILEEXT').AsString := Fext;


      if Flag = 'I' then
      begin
        try
          LMS := TMemoryStream.Create;
          LMS.Position := 0;
          //LMS.LoadFromFile('/mnt/sdcard/DCIM/Camera/'+FileNm);
          LMS.LoadFromFile('D:\HiTEMS\TDS_REST_SERVER\upload\'+FileNm);

          parambyname('FILESIZE').AsString   := IntToStr(LMS.Size);
          parambyname('FILES').ParamType := ptInput;
          parambyname('FILES').AsOraBlob.LoadFromStream(LMS);
          parambyname('INDATE').AsDateTime := LDate;

          Execute;
        finally
          LMS.Free;
        end;
      end;
    end;
      Result := True;
      ReturnMessage := '이미지 등록 성공!!';
      DeleteFile('D:\HiTEMS\service\upload\'+FileNm);

  except
    Result := False;
    ReturnMessage := '이미지 등록 실패!!';
    DeleteFile('D:\HiTEMS\service\upload\'+FileNm);
  end;

  FreeAndNil(OraQuery1);
end;

end.
