unit DataSave2DBThread;

interface

uses
  Windows, Classes, SysUtils, Forms, DB, MyKernelObject, CommonUtil, Dialogs,
  DataSaveConst, ZConnection, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  DataSaveConfig;

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

    FHostName: string;//DB Host Name(IP address)
    FDBName: string;  //DB Name(Mysql의 DB Name)
    FLoginID: string; //Login Name
    FPasswd: string;  //Password
    FStrData: string;
    FLoadCellID: string;
    LastLogTime: TDateTime;
    NextLogTime: TDateTime;

    FDataSaveEvent: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;

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

uses DataSave;

{ TDataSaveThread }

constructor TDataSave2DBThread.Create(AOwner: TForm);
begin
  inherited Create(True);
  FOwner := AOwner;
  FDataSaveEvent := TEvent.Create('DataSaveEvent'+IntToStr(GetCurrentThreadID),False);
  ZConnection1 := TZConnection.Create(nil);
  with ZConnection1 do
  begin
    Database := 'TBACS';
    Password := 'TBACS';
    Port     := 1521;
    Protocol := 'oracle';
    User     := 'TBACS';
    Connected := True;
  end;
  ZQuery1 := TZQuery.Create(nil);
  with ZQuery1 do
  begin
    Connection := ZConnection1;
  end;
  {  FDataBase := TZMySqlDatabase.Create(nil);
  FTransact := TZMySqlTransact.Create(nil);
  FQuery := TZMySqlQuery.Create(nil);

  FTransact.Database := FDataBase;
  FQuery.Database := FDataBase;
  FQuery.Transaction := FTransact;
}
  FStarted := False;
  FSaving := False;
  LastLogTime := now();
end;

destructor TDataSave2DBThread.Destroy;
begin
  DisConnectDB;
  FDataSaveEvent.Free;
  ZConnection1.Free;
{  FQuery.Free;
  FTransact.Free;
  FDataBase.Free;
}  inherited;
end;

function TDataSave2DBThread.ConnectDB: Boolean;
begin
{  Result := False;
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
}
end;

procedure TDataSave2DBThread.DisConnectDB;
begin
//  FQuery.Close;
//  FTransact.Disconnect;
//  FDataBase.Disconnect;
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

  while not terminated do
  begin
    if FDataSaveEvent.Wait(INFINITE) then
    begin
      if not terminated then
      begin
        try
          FSaving := True;
          InsertDBData;
          sleep(StrToInt(Form1.ed_InterMin.text)*60000+StrToInt(Form1.ed_InterSec.text)*1000);
        finally
          FSaving := False;
        end;//try
      end;//if
    end;//if
  end;//while

  FStarted := False;
end;

procedure TDataSave2DBThread.InsertDBData;
begin
  if ZConnection1.Connected then
  with Zquery1 do
  begin
    SQL.Clear;
    SQL.Add('insert into loadcell_log');
    SQL.Add('(loadcell_id,tdate,value)');
    SQL.Add(' values (:loadcell_id, :date ,:value)');

    ParamByName('loadcell_id').Asstring := FLoadCellID;
    ParamByName('date').AsDateTime := Now();
    ParamByName('value').Asstring := FStrData;

    if (FStrData <> '') then
      Execsql;
  end;
  LastLogTime := Now();
end;
end.
