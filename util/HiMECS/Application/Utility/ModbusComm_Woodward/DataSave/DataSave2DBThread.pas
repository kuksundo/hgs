unit DataSave2DBThread;

interface

uses
  Windows, Classes, SysUtils, Forms, DB, MyKernelObject, CommonUtil, Dialogs,
  DataSaveConst, DataSaveConfig, Ora;

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
    FStrData_Value2: double;

    FLoadCellID: string;
    LastLogTime: TDateTime;
    NextLogTime: TDateTime;

    FDataSaveEvent: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    OraSession1 : TOraSession;
    OraQuery1 : TOraQuery;

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

uses ECS_DataSave_Main;

{ TDataSaveThread }

constructor TDataSave2DBThread.Create(AOwner: TForm);
begin
  inherited Create(True);
  FOwner := AOwner;
  FDataSaveEvent := TEvent.Create('ECSDataSaveEvent'+IntToStr(GetCurrentThreadID),False);
  OraSession1 := TOraSession.Create(nil);
  with OraSession1 do
  begin
    UserName     := 'TBACS';
    Password := 'TBACS';
    Server   := '10.100.23.114:1521:TBACS';
    LoginPrompt := False;
    Options.Direct := True;
    Options.Charset := 'KO16KSC5601';
    Connected := True;
  end;

  OraQuery1 := TOraQuery.Create(nil);
  with OraQuery1 do
  begin
    Connection := OraSession1;
  end;

  FStarted := False;
  FSaving := False;
  LastLogTime := now();
end;

destructor TDataSave2DBThread.Destroy;
begin
  DisConnectDB;
  FDataSaveEvent.Free;
  OraSession1.Free;
  inherited;
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
  OraQuery1.Close;
  OraSession1.Disconnect;
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

          //인터벌로 데이터를 저장할 경우 해당 시간동안 쓰레드를 sleep 시킴
          if DataSaveMain.RB_byinterval.Checked then
          begin
            sleep(StrToInt(DataSaveMain.Ed_interval.Text));
          end;

        finally
          FSaving := False;
        end;//try
      end;//if
    end;//if
  end;//while

  FStarted := False;
end;

procedure TDataSave2DBThread.InsertDBData;
var
  LStr: string;
  Li: integer;
  LDataList : TStringList;
  LDouble : Double;
begin
  if OraSession1.Connected then
  with Oraquery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into HIMECS_AI_DATA_C');
    SQL.Add('values(:ENGINEPROJ, :ENGINETYPE, :DATASAVEDTIME, :AI_ENGINERPM, :AI_TCARPM,');
    SQL.Add('       :AI_TCBRPM, :AI_HTINTEMP, :AI_LOINTEMP, :AI_FOINTEMP, :AI_HTOUTTEMP,');
    SQL.Add('       :AI_LTOUTTEMP, :AI_LTINTEMP, :AI_CATEMP , :AI_LOTCATEMP, :AI_HTAINPRESS,');
    SQL.Add('       :AI_LOFOUTPRESS, :AI_FOFOUTPRESS, :AI_STARTAIRPRESS, :AI_LTINPRESS, :AI_LOINFPRESS,');
    SQL.Add('       :AI_LOTCAPRESS, :AI_CAPRESS, :AI_FOFINPRESS, :AI_SLOWTURNAIRPRESS, :AI_FOCOOLPRESS,');
    SQL.Add('       :AI_NCOPRESS, :AI_TCBLOPRESS, :AI_LOTC_B_TEMP, :AI_HTBINPRESS, :AI_HTBINTEMP,');
    SQL.Add('       :AI_EXHA1, :AI_EXHA2, :AI_EXHA3, :AI_EXHA4, :AI_EXHA5,');
    SQL.Add('       :AI_EXHA6, :AI_EXHA7, :AI_EXHA8, :AI_EXHA9, :AI_EXHA10,');
    SQL.Add('       :AI_EXHATCINA, :AI_EXHATCINB, :AI_EXHATCOUT, :AI_EXHB1, :AI_EXHB2,');
    SQL.Add('       :AI_EXHB3, :AI_EXHB4, :AI_EXHB5, :AI_EXHB6, :AI_EXHB7,');
    SQL.Add('       :AI_EXHB8, :AI_EXHB9, :AI_EXHB10, :AI_EXHBTCINA, :AI_EXHBTCINB,');
    SQL.Add('       :AI_EXHBTCOUT, :AI_MBTEMP1, :AI_MBTEMP2, :AI_MBTEMP3, :AI_MBTEMP4,');
    SQL.Add('       :AI_MBTEMP5, :AI_MBTEMP6, :AI_MBTEMP7, :AI_MBTEMP8, :AI_MBTEMP9,');
    SQL.Add('       :AI_MBTEMP10, :AI_MBTEMP11, :AI_MBTEMP12, :AI_MBTEMP13, :AI_WINDUTEMP,');
    SQL.Add('       :AI_WINDVTEMP, :AI_WINDWTEMP, :AI_GENBERGTEMPF, :AI_GENBERGTEMPE, :AI_GENCATEMP,');
    SQL.Add('       :AI_GENLOINTEMP, :AI_GENLOOUTTEMP, :AI_GENCWINTEMP, :AI_GENCWOUTTEMP)');

    Try
      parambyname('ENGINEPROJ').AsString := 'YE0589';
      parambyname('ENGINETYPE').AsString := '18H46/60V';
      parambyname('DATASAVEDTIME').AsDateTime := NOW;

      LDataList := TStringList.Create;
      LDataList.Delimiter := ',';
      LDataList.DelimitedText := FStrData;

      for li := 0 to LDataList.Count-1 do
        if POS('.',LDataList.Strings[li]) = 0 then
          Params[3+li].AsInteger := StrToInt(LDataList.Strings[li])
        else
          Params[3+li].AsFloat   := StrToFloat(LDataList.Strings[li]);

      Execsql;
    Finally
      LDataList.Free;
    End;
  end;
  DataSaveMain.DisplayMessage (TimeToStr(Time)+' Processing DataSave to DB', dtSendMemo);
  LastLogTime := Now();
end;

end.
