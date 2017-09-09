unit MySqlDBThread;

interface

uses
  Windows, Classes, SysUtils, Forms, DB, MyKernelObject, CommonUtil, Dialogs,
  ZQuery, ZMySqlQuery, ZTransact, ZMySqlTr, ZConnect, ZMySqlCon, janSQL;

type
  TData2MySQLDBThread = class(TThread)
  private
    FOwner: TForm;
  protected                                                
    procedure Execute; override;
  public
    FDataBase: TZMySqlDatabase;
    FTransact: TZMySqlTransact;
    FQuery: TZMySqlQuery;
    FjanRecord: TjanRecord; //한 레코드를 입력받기 위한 변수

    FHostName: string;//DB Host Name(IP address)
    FDBName: string;  //DB Name(Mysql의 DB Name)
    FLoginID: string; //Login Name
    FPasswd: string;  //Password
    
    FDataSaveEvent: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    FDataSaveEvent2: TEvent;//TDataFile2DBThread에 DB 저장 완료를 알리는 Event Handle
    FStarted: Boolean;//Execute를 한번이상 실행 했으면 True
    FSaving: Boolean; //데이타 저장중이면 True

    constructor Create(AOwner: TForm);
    destructor Destroy; override;

    function ConnectDB: Boolean;
    procedure DisConnectDB;
    procedure CreateDBParam(SqlFileName,Tablename: string);
    procedure InsertDBData;
  end;

implementation

{ TDataSaveThread }

constructor TData2MySQLDBThread.Create(AOwner: TForm);
begin
  inherited Create(True);
  FOwner := AOwner;
  FDataSaveEvent := TEvent.Create('Data2MYSQLEvent'+IntToStr(GetCurrentThreadID),False);
  FDataBase := TZMySqlDatabase.Create(nil);
  FTransact := TZMySqlTransact.Create(nil);
  FQuery := TZMySqlQuery.Create(nil);

  FTransact.Database := FDataBase;
  FQuery.Database := FDataBase;
  FQuery.Transaction := FTransact;

  FStarted := False;
  FSaving := False;
end;

destructor TData2MySQLDBThread.Destroy;
begin
  DisConnectDB;
  FDataSaveEvent.Free;
  FQuery.Free;
  FTransact.Free;
  FDataBase.Free;
  inherited;
end;

function TData2MySQLDBThread.ConnectDB: Boolean;
begin
  Result := False;

  with FDataBase do
  begin
    Host := FHostName;
    Database := FDBName;
    Login := FLoginID;
    Password := FPasswd;

    try
      Connect;

      if connected then
        Result := True;
    except
    end;//try
  end;//with

end;

procedure TData2MySQLDBThread.DisConnectDB;
begin
  FQuery.Close;
  FTransact.Disconnect;
  FDataBase.Disconnect;
end;

procedure TData2MySQLDBThread.CreateDBParam(SqlFileName,Tablename: string);
var
  i, pcount: integer;
  tmpft: TFieldType;
  tmpstr: string;
  tmpQuery: TZMySqlQuery;
begin
  tmpQuery := TZMySqlQuery.Create(nil);
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
      //0번째 Date는 무시함(csv 파일에 date+time이 함께 있기 때문)
      for i := 1 to pcount - 1 do
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
end;

procedure TData2MySQLDBThread.Execute;
begin
  FStarted := True;

  while not terminated do
  begin
    if FDataSaveEvent.Wait(INFINITE) then
    begin
      if not terminated then
      begin
        try
          FSaving := True;

          InsertDBData;

        finally
          FDataSaveEvent2.Signal;
          FSaving := False;
        end;//try
      end;//if
    end;//if
  end;//while

  FStarted := False;
end;

procedure TData2MySQLDBThread.InsertDBData;
var i: integer;
begin
  with FjanRecord do
  begin
    FQuery.Params[0].AsDate := StrToDateTime(Fields[0].Value);
    FQuery.Params[1].AsTime := StrToDateTime(Fields[0].Value);

    for i := 2 to FQuery.ParamCount - 1 do
    begin
      case FQuery.Params.Items[i].DataType of
        //ftDate: FQuery.Params[i].AsDate := Fields[i].Value;
        //ftTime: FQuery.Params[i].AsTime := Fields[i].Value;
        ftInteger: FQuery.Params[i].AsInteger := Fields[i-1].Value;
        ftFloat: FQuery.Params[i].AsFloat := Fields[i-1].Value;
      end;//case
    end;//for
  end;//with

  FQuery.ExecSql;
end;

end.
