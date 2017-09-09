unit DataSave2DBThread;

interface

uses
  Windows, Classes, SysUtils, Forms, DB, MyKernelObject, CommonUtil, Dialogs,
  DataSaveAll_Const, Ora, Data.SqlExpr;

type
  TDataSave2DBThread = class(TThread)
  private
    FOwner: TForm;
  protected
    procedure Execute; override;
  public
    //FDataBase: TZMySqlDatabase;
    //FTransact: TZMySqlTransact;
    //FQuery: TZMySqlQuery;
    FDataTypeList : TStringList;
    //FHostName: string;//DB Host Name(IP address)
    //FDBName: string;  //DB Name(Mysql의 DB Name)
    //FLoginID: string; //Login Name
    //FPasswd: string;  //Password

    FStrData: string;
    FStrData_Value2: double;

    FInsertSQL : String;
    FInsertDataType : String;
    FTableName: string;

    FLoadCellID: string;
    LastLogTime: TDateTime;
    NextLogTime: TDateTime;

    FDataSaveEvent: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    FOraSession1 : TOraSession;
    FOraQuery1 : TOraQuery;

    FStarted: Boolean;//Execute를 한번이상 실행 했으면 True
    FSaving: Boolean; //데이타 저장중이면 True
    FUseInterval: Boolean;
    FInterval: integer;
    FDestroying: Boolean;

    constructor Create(AOwner: TForm);
    destructor Destroy; override;

    function ConnectDB: Boolean;
    procedure DisConnectDB;
    procedure CreateDBParam(SqlFileName,Tablename: string);
    procedure InsertDBData;
    Function Create_InsertSQL(ATableName: string) : String;
  end;

implementation

uses DataSaveAll_FrameUnit;

{ TDataSaveThread }

constructor TDataSave2DBThread.Create(AOwner: TForm);
begin
  inherited Create(True);
  FOwner := AOwner;
  FreeOnTerminate := True;
  FDataSaveEvent := TEvent.Create('ECSDataSaveEvent'+IntToStr(GetCurrentThreadID),False);

  DataSaveAllF.DSA.FConnectedOracleDB := connectDB;

  FStarted := False;
  FSaving := False;
  LastLogTime := now();
end;

destructor TDataSave2DBThread.Destroy;
begin
  DisConnectDB;
  FDataSaveEvent.Free;
  FreeAndNil(FOraQuery1);
  FreeAndNil(FOraSession1);
  FDataTypeList.Free;
  inherited;
end;

function TDataSave2DBThread.ConnectDB: Boolean;
begin
  Result := False;

  if not Assigned(FOraSession1) then
    FOraSession1 := TOraSession.Create(nil);

  with FOraSession1 do
  begin
    UserName := DataSaveAllF.DSA.FLoginID;// 'TBACS';
    Password := DataSaveAllF.DSA.FPasswd; //'TBACS';
    Server   := DataSaveAllF.DSA.FHostName; //'10.100.23.114:1521:TBACS';
    LoginPrompt := False;
    Options.Direct := True;
    Options.Charset := 'KO16KSC5601';
    Connect;

    if Connected then
      Result := True;
  end;

  if not Assigned(FOraQuery1) then
    FOraQuery1 := TOraQuery.Create(nil);

  with FOraQuery1 do
  begin
    AutoCommit := False;
    Connection := FOraSession1;
  end;

end;

procedure TDataSave2DBThread.DisConnectDB;
begin
  FOraQuery1.Close;
  FOraSession1.Disconnect;
end;

procedure TDataSave2DBThread.CreateDBParam(SqlFileName,Tablename: string);
var
  i, pcount: integer;
  tmpft: TFieldType;
//  tmpstr: string;
//  tmpQuery: TZMySqlQuery;
begin
{  tmpQuery := TZMySqlQuery.Create(nil);
  try
    tmpQuery.Database := FDataBase;
    tmpQuery.Transaction := FTransact;

    with tmpQuery do
    begin
      Close;
      Sql.Clear;
      Sql.LoadFromFile(SqlFileName);//INSERT_FILE_NAME);
      pcount := ParamCount;
      Sql.Clear;
      Sql.Add('desc '+ Tablename);
      Open;

      //DB에서 필드 속성을 가져와서 Type별로 Parameter를 생성함
      for i := 0 to pcount - 1 do
      begin
        tmpstr := Fields.Fields[1].AsString;
        if Pos('date', tmpstr) <> 0 then
          tmpft := ftDate
        else if Pos('time', tmpstr) <> 0 then
          tmpft := ftTime
        //else if (Pos('tinyint', tmpstr) <> 0) or (Pos('integer', tmpstr) <> 0) then
        else if (Pos('int', tmpstr) <> 0) then
          tmpft := ftInteger
        else if Pos('float', tmpstr) <> 0 then
          tmpft := ftFloat
        else
          tmpft := ftUnknown;

        FQuery.Params.CreateParam(tmpft, Fields.Fields[0].AsString, ptInput);
        Next;
      end;//for

    end;//with
  finally
    tmpQuery.Free;
    tmpQuery := nil;
  end;//try

  with FQuery do
  begin
    Close;
    Sql.Clear;
    Sql.LoadFromFile(SqlFileName);//INSERT_FILE_NAME);
  end;//with
}
end;

procedure TDataSave2DBThread.Execute;
begin
  FStarted := True;
  FDataTypeList := TStringList.Create;
  ExtractStrings([','],[' '],PWideChar(FInsertDataType),FDataTypeList);

  while not terminated do
  begin
    if FDestroying then
      exit;

    if FDataSaveEvent.Wait(INFINITE) then
    begin
      if FDestroying then
        exit;

      if not terminated then
      begin
        try
          FSaving := True;
          InsertDBData;

          //인터벌로 데이터를 저장할 경우 해당 시간동안 쓰레드를 sleep 시킴
          //if DataSaveMain.RB_byinterval.Checked then
          if FUseInterval then
          begin
            //sleep(StrToInt(DataSaveMain.Ed_interval.Text));
            sleep(FInterval);
          end;

        finally
          FSaving := False;
        end;//try
      end;//if
    end;//if
  end;//while

  FStarted := False;
end;

function TDataSave2DBThread.Create_InsertSQL(ATableName: string) : String;
var
  OraSession1 : TOraSession;
  OraQuery1 : TOraQuery;
  lsql : String;
begin
{  OraSession1 := TOraSession.Create(nil);
  OraQuery1 := TOraQuery.Create(nil);
  try
    with OraSession1 do
    begin
      UserName     := 'TBACS';
      Password := 'TBACS';
      Server   := '10.100.23.114:1521:TBACS';
      LoginPrompt := False;
      Options.Direct := True;
      Options.Charset := 'KO16KSC5601';
      Connected := True;
      OraQuery1.AutoCommit := False;
      OraQuery1.Connection := OraSession1;
    end;
 }
  if FOraSession1.Connected then
  begin
    {if ATableName = '' then
    begin
      with FOraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from Himsen_SS_Table_Info');

        Open;
        if not(RecordCount = 0) then
          lTable := FieldByName('TABLENAME').AsString
        else
          raise Exception.Create('테이블이 존재하지 않습니다.'+#10#13+
                                 'Insert SQL 생성에 실패하였습니다.');
      end;
    end
    else
      lTable := ATableName;
    }
    FTableName := ATableName;

    if not(FTableName = '') then
    begin
      with FOraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select column_name, Data_Type, column_id from all_tab_columns ' +
                'where owner = ''TBACS'' AND table_name = '''+FTableName+''' ' +
                'order by column_id');
        Open;

        if not(RecordCount = 0) then
        begin
          FInsertDataType := '';
          lsql := 'insert into '+FTableName;
          lsql := lsql + ' Values(';
          while not eof do
          begin
            lsql := lsql+':'+FieldByName('column_name').AsString+',';
            FInsertDataType := FInsertDataType + FieldByName('Data_Type').AsString+',';
            Next;
          end;
          lsql := Copy(lsql,0,Length(lsql)-1);
          lsql := lsql + ')';
          FInsertDataType := Copy(FInsertDataType,0,Length(FInsertDataType)-1);
          Result := lsql;
          FInsertSQL := lsql;
        end;
      end;
    end;
  end;
//  finally
//    FreeAndNil(OraSession1);
//    FreeAndNil(OraQuery1);
//  end;
end;

procedure TDataSave2DBThread.InsertDBData;
var
  Li,LCount: integer;
  LDataList : TStringList;
  lstr : String;

begin
  if FOraSession1.Connected then
  begin
    FOraSession1.StartTransaction;
    try
      with FOraquery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add(FInsertSQL);

        LDataList := TStringList.Create;
        Try
          ExtractStrings([','],[' '],PWideChar(FStrData),LDataList);

          //param 내용과 DB Column 불일치시에 Index error 방지하기 위함
          //DB에는 Power Column만 있고 Param에는 Current, Voltage까지 존재함
          LCount := FDataTypeList.Count;
          if LCount > LDataList.Count then
            LCount := LDataList.Count;

          for li := 0 to LCount - 1 do
          begin
            if UpperCase(FDataTypeList.Strings[li]) = 'DATE' then
              Params[li].AsDateTime := StrToFloat(LDataList.Strings[li])
            else if UpperCase(FDataTypeList.Strings[li]) = 'NUMBER' then
              Params[li].AsFloat := StrToFloat(LDataList.Strings[li])
            else if UpperCase(FDataTypeList.Strings[li]) = 'VARCHAR2' then
              Params[li].AsString := LDataList.Strings[li];
          end;

          ExecSql;
          FOraSession1.Commit;
          DataSaveAllF.DSA.DisplayMessage (TimeToStr(Time)+' => '+FTableName+' Inserted', 0);
        Finally
          LDataList.Free;
        End;
      end;
      LastLogTime := Now();
    except
      on E : Exception do
      begin
        FOraSession1.Rollback;
        WriteLog('TDataSave2DBThread.InsertDBData -' + E.Message + '; TableName:' + FTableName + '; Key Name: ' + LDataList.Strings[0]);
        FOraSession1.Disconnect;
        DataSaveAllF.DSA.FConnectedOracleDB := False;
      end;
    end;
  end
  else
  begin//retry connect DB
    SendMessage(DataSaveAllF.DSA.Handle, WM_DB_DISCONNECTED, 0, 0);
  end;
end;

end.
