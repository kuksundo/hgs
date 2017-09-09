unit DataSave2MongoDBThread;

interface

uses
  Windows, Classes, SysUtils, Forms, DB, MyKernelObject, CommonUtil, Dialogs,
  System.UITypes, System.Variants, DateUtils,
  DataSaveAll_Const, Data.SqlExpr, mORMot, mORMotUI, SynCommons, SynMongoDB,
  CopyData;

type
  TDataSave2MongoDBThread = class(TThread)
  private
    FOwner: TForm;
  protected
    procedure Execute; override;
  public
    //OnCreate시에 아래 변수를 반드시 할당 할 것
    FFrameDataSaveAll: TFrame;
    FDataTypeList : TStringList;

    FMongoAnalogData: string;
    FMongoDigitalData,
    FMongoDigitalData2,
    FMongoAnalogBackup,
    FMongoDigitalBackup,
    FMongoDigitalBackup2: string;
    FStrData: string;
    FMongoCollectName,
    FMongoCollectName2,
    FMongoCollectName3: string;//FMongoAnalogData가 Insert 될 Collect Name

    FStrData_Value2: double;

    FInsertSQL : String;
    FInsertDataType : String;
    FTableName: string;

    FLoadCellID: string;
    LastLogTime: TDateTime;
    NextLogTime: TDateTime;

    FDataSaveEvent: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    FClient : TMongoClient;
    FDB : TMongoDatabase;
    FRecCount,
    FRecCount2,
    FRecCount3: integer;

    FStarted: Boolean;//Execute를 한번 이상 실행 했으면 True
    FSaving: Boolean; //데이타 저장 중이면 True
    FUseInterval: Boolean;
    FInterval: integer;
    FDestroying: Boolean;

    constructor Create(AOwner: TForm);
    destructor Destroy; override;

    procedure InitParam;
    function ConnectDB: Boolean;
    procedure DisConnectDB;
    procedure CreateDBParam(SqlFileName,Tablename: string);
    procedure SetRecordCount(ARecCount: integer);
    procedure SetRecordCount2(ARecCount: integer);
    procedure SetRecordCount3(ARecCount: integer);
    function InsertDBData: Boolean;
    function InsertMetaData(ARecCount: integer): Boolean;
    function InsertMetaData2(ARecCount: integer): Boolean;
    function InsertDBBulkData: Boolean;
    function InsertDBBulkData2(ARecCount: integer): Boolean;
    //Embeded Document 구조 저장함, Update가 어려워서 사용 안함
    procedure InsertInitEngDivkWhData(AYear: word);
    //InsertInitEngDivkWhData함수를 수정함, Update를 위해 구조를 간소화 함
    procedure InsertInitEngDivkWhData2(AYear, AMonth, ADay: word);
    procedure InsertOrUpdateEngDivkWh2DB(AYear, AMonth, ADay: word;
      AInCome1, AInCome2, AInCome3, AVCBF1, AVCBF2, AVCBG7A: double);
    function InsertEngDivkWh2DB(AYear, AMonth, ADay: word;
      AInCome1, AInCome2, AInCome3, AVCBF1, AVCBF2, AVCBG7A: double;
      AMongoCollection: TMongoCollection = nil): Boolean;
    function UpdateEngDivkWh2DB(AYear, AMonth, ADay, AkWh: word; AItemName: string): Boolean;
    function UpdateEngDivkWh2DB2(AYear, AMonth, ADay: word;
      AInCome1, AInCome2, AInCome3, AVCBF1, AVCBF2, AVCBG7A: double;
      AMongoCollection: TMongoCollection = nil): Boolean;
    function SelectDBData(AIndex: integer): Variant;
    function SelectAllDBData(var ADocs: TVariantDynArray; ACollName: string = ''): Boolean;
    function SelectAllDBData2String: RawUTF8;
    function UpdateDBData(ABSON: string): Boolean;
    function DeleteDBData(AId: string): Boolean;
    Function Create_InsertSQL(ATableName: string) : String;
    function CheckExistkWh(AYear, AMonth, ADay: word): Boolean;
    function GetkWhFromDB(AYear, AMonth, ADay: word): variant;
  end;

implementation

uses UnitFrameDataSaveAll;

{ TDataSaveThread }

constructor TDataSave2MongoDBThread.Create(AOwner: TForm);
begin
  inherited Create(True);

  FOwner := AOwner;
  FDataSaveEvent := TEvent.Create('ECSDataSaveEvent'+IntToStr(GetCurrentThreadID),False);
  FreeOnTerminate := True;

//  FrmDataSaveAll.FConnectedDB := connectDB;

  FStarted := False;
  FSaving := False;
  LastLogTime := now();
  FMongoAnalogData := '';
  FMongoAnalogBackup := '';
  FMongoDigitalData := '';
  FMongoDigitalBackup := '';
end;

function TDataSave2MongoDBThread.DeleteDBData(AId: string): Boolean;
var
  LColl: TMongoCollection;
  LDoc: variant;
begin
  Result := False;
  LColl := FDB.CollectionOrCreate[FMongoCollectName];
  LColl.RemoveOne(ObjectId(AId));
end;

destructor TDataSave2MongoDBThread.Destroy;
begin
  DisConnectDB;
  FDataSaveEvent.Free;
  FDataTypeList.Free;
  inherited;
end;

function TDataSave2MongoDBThread.CheckExistkWh(AYear, AMonth,
  ADay: word): Boolean;
var
  LColl: TMongoCollection;
  LDoc: Variant;
begin
  Result := False;
  LColl := nil;
  LColl := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];

  if Assigned(LColl) then
  begin
    Ldoc := LColl.FindDoc('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay]);

    Result := LDoc <> null;
  end;
end;

function TDataSave2MongoDBThread.ConnectDB: Boolean;
begin
  Result := False;

  FClient := nil;

  FClient := TMongoClient.Create(TFrameDataSaveAll(FFrameDataSaveAll).FMongoHostName,27017);

  if Assigned(FClient) then
  begin
    FClient.WriteConcern := wcUnacknowledged;
    FDB := nil;
    FDB := FClient.Database[TFrameDataSaveAll(FFrameDataSaveAll).FMongoDBName];
    if Assigned(FDB) then
      Result := True;
  end;

//  WriteLog('Connecting to ' + FDB.Name);

//  errmsg := FDB.RunCommand('hostInfo',res); // run a command
//
//  if errmsg<>'' then
//    exit; // quit on any error
//  serverTime := res.system.currentTime; // direct conversion to TDateTime
//  writeln('Server time is ',DateTimeToStr(serverTime));
end;

procedure TDataSave2MongoDBThread.DisConnectDB;
begin
//  if Assigned(FDB) then
//    FDB.Free;

  if Assigned(FClient) then
    FClient.Free;
end;

procedure TDataSave2MongoDBThread.CreateDBParam(SqlFileName,Tablename: string);
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

procedure TDataSave2MongoDBThread.Execute;
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
//          InsertDBData;
          InsertDBBulkData;
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

function TDataSave2MongoDBThread.GetkWhFromDB(AYear, AMonth, ADay: word): variant;
var
  LColl: TMongoCollection;
begin
  Result := null;
  LColl := nil;
  LColl := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];

  if Assigned(LColl) then
  begin
    Result := LColl.FindDoc('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay]);
  end;
end;

function TDataSave2MongoDBThread.Create_InsertSQL(ATableName: string) : String;
begin

end;

procedure TDataSave2MongoDBThread.InitParam;
begin
end;

function TDataSave2MongoDBThread.InsertDBBulkData: Boolean;
var
  i: integer;
  LColl,
  LColl2,
  LColl3: TMongoCollection;
  LDoc,
  LDoc2,
  LDoc3: variant;
  LStr, LStr2: RawUTF8;
  V: variant;
begin

//  for i := 0 to ARecCount-1 do
//  begin
////    LStr := LStr + '"V' + IntToStr(i+1) + '": "' + FrmDataSaveAll.TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value + '", ';
//    LStr := LStr + '"' + FrmDataSaveAll.TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName + '": "' +
//      FrmDataSaveAll.TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value + '", ';
//  end;
//
//  i := PosRev(',', LStr);
//
//  if i = Length(LStr) - 1 then
//    System.Delete(LStr,i,1);
//
//  LStr := '{ "SavedTime": new Date(), ' + LStr + '}';

  if (FMongoCollectName <> '') and (FMongoAnalogData <> '') then
  begin
    if FMongoAnalogBackup <> FMongoAnalogData then
    begin
      LColl := FDB.CollectionOrCreate[FMongoCollectName];

      try
        LDoc := TDocVariant.NewJSON(StringToUTF8(FMongoAnalogData));
        LColl.Insert(LDoc); // insert all values at once
        FMongoAnalogBackup := FMongoAnalogData;
        SendCopyData2(FOwner.Handle, DateTimeToStr(now)+' => '+FMongoCollectName+' Inserted(Bulk: ' + IntToStr(FRecCount) + ' Docs)', Ord(dtSendMemo));
      except

      end;
    end;
  end;

  if (FMongoCollectName2 <> '') and (FMongoDigitalData <> '') then
  begin
    if FMongoDigitalBackup <> FMongoDigitalData then
    begin
      LColl2 := FDB.CollectionOrCreate[FMongoCollectName2];

      try
        LDoc2 := TDocVariant.NewJSON(FMongoDigitalData);
        LColl2.Insert(LDoc2); // insert all values at once
        FMongoDigitalBackup := FMongoDigitalData;
        SendCopyData2(FOwner.Handle, DateTimeToStr(now)+' => '+FMongoCollectName2+' Inserted(Bulk: ' + IntToStr(FRecCount2) + ' Docs)', Ord(dtSendMemo));
      except

      end;
    end;
  end;

  if (FMongoCollectName3 <> '') and (FMongoDigitalData2 <> '') then
  begin
    if FMongoDigitalBackup2 <> FMongoDigitalData2 then
    begin
      LColl3 := FDB.CollectionOrCreate[FMongoCollectName3];

      try
        LDoc3 := TDocVariant.NewJSON(FMongoDigitalData2);
        LColl3.Insert(LDoc3); // insert all values at once
        FMongoDigitalBackup2 := FMongoDigitalData2;
        SendCopyData2(FOwner.Handle, DateTimeToStr(now)+' => '+FMongoCollectName3+' Inserted(Bulk: ' + IntToStr(FRecCount3) + ' Docs)', Ord(dtSendMemo));
      except

      end;
    end;
  end;
//  FrmDataSaveAll.DisplayMessage (TimeToStr(Time)+' => '+FMongoCollectName+' Inserted(Bulk: ' + IntToStr(ARecCount) + ' Docs)', dtSendMemo);
end;

function TDataSave2MongoDBThread.InsertDBBulkData2(ARecCount: integer): Boolean;
var
  i: integer;
  LColl: TMongoCollection;
  LDocs: TVariantDynArray;
begin
  SetLength(LDocs,ARecCount);
  LColl := FDB.CollectionOrCreate[FMongoCollectName];

  for i := 0 to ARecCount-1 do
  begin
    TDocVariant.New(LDocs[i]);
//    LDocs[i]._id := ObjectID; // compute new ObjectID on the client side
    LDocs[i].Name := 'Name '+IntToStr(i+1);
    LDocs[i].Value := TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].Value;
  end;

  LColl.Insert(LDocs); // insert all values at once
  TFrameDataSaveAll(FFrameDataSaveAll).DisplayMessage (DateTimeToStr(now)+' => '+FMongoCollectName+' Inserted(Bulk: ' + IntToStr(ARecCount) + ' Docs)', 0);
end;

function TDataSave2MongoDBThread.InsertDBData: Boolean;
var
  i: integer;
  LColl: TMongoCollection;
  LDoc: variant;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectName];
  TDocVariant.New(LDoc);

  for i := 1 to 10 do
  begin
    LDoc.Clear;
    LDoc._id := ObjectID;
    LDoc.Name := 'Data'+IntToStr(i);
    LDoc.Value := i;

//    if (MessageDlg('Save this record?', mtWarning, [mbYes, mbNo], 0) = mrYes) then
      LColl.Insert(LDoc);
//    LColl.Save(LDoc);
//    writeln('Inserted with _id=',doc._id);
  end;
end;

function TDataSave2MongoDBThread.InsertEngDivkWh2DB(AYear, AMonth, ADay: word;
  AInCome1, AInCome2, AInCome3, AVCBF1, AVCBF2, AVCBG7A: double;
  AMongoCollection: TMongoCollection): Boolean;
var
  LDoc,
  LkWhData: variant;
begin
  if not Assigned(AMongoCollection) then
    AMongoCollection := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];

  TDocVariant.New(LDoc);
  TDocVariant.New(LkWhData);

  LDoc.Title := 'Engine Division Electric Energy (kWh) on ' + IntToStr(AYear);
  LDoc.Year := AYear;
  LDoc.Month := AMonth;
  LDoc.Day := ADay;

  LkWhData.InCome1 := AInCome1;
  LkWhData.InCome2 := AInCome2;
  LkWhData.InCome3 := AInCome3;
  LkWhData.VCBF1 := AVCBF1;
  LkWhData.VCBF2 := AVCBF2;
  LkWhData.VCBG7A := AVCBG7A;

  LDoc.kWh := _JSON(LkWhData);
  AMongoCollection.Insert(LDoc);
end;

procedure TDataSave2MongoDBThread.InsertInitEngDivkWhData(AYear: word);
var
  i, j, k: integer;
  LColl: TMongoCollection;
  LDoc,
  LMonthData,
  LDayData: variant;
  LMonth, LDay: string;
begin
  LColl := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];
  TDocVariant.New(LDoc);
  TDocVariant.New(LMonthData);
  TDocVariant.New(LDayData);

  LMonth := '';
  LDay := '';

  LDoc.Clear;
  LDoc.Year := AYear;//FormatDateTime('YYYY', now);
  LDoc.Title := 'Engine Division Electric Energy (kWh) on ' + LDoc.Year;

  for i := 1 to 12 do
  begin
    LMonthData.Clear;
    LDayData.Clear;
    LDay := '';

    LMonthData.Month := i;
    k := DaysInAMonth(AYear, i);

    for j := 1 to k do
    begin
      LDayData.Day := j;
      LDayData.InCome1 := 0;
      LDayData.InCome2 := 0;
      LDayData.InCome3 := 0;
      LDayData.VCBF1 := 0;
      LDayData.VCBF2 := 0;
      LDayData.VCBG7A := 0;

      LDay := LDay + VariantSaveJson(LDayData) + ',' + #13#10;
    end;

    LDay := '[' + Copy(LDay, 1, Length(Lday) - 3) + ']';
    LMonthData.Data := _JSON(LDay);
    LMonth := LMonth + VariantSaveJson(LMonthData) + ',' + #13#10;
  end;

  LMonth := '[' + Copy(LMonth, 1, Length(LMonth) - 3) + ']';
  LDoc.Data := _JSON(LMonth);
  LColl.Insert(LDoc);
end;

procedure TDataSave2MongoDBThread.InsertInitEngDivkWhData2(AYear, AMonth,
  ADay: word);
var
  LColl: TMongoCollection;
  LDoc,
  LkWhData: variant;
begin
  LColl := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];
  TDocVariant.New(LDoc);
  TDocVariant.New(LkWhData);

  LDoc.Title := 'Engine Division Electric Energy (kWh) on ' + IntToStr(AYear);
  LDoc.Year := AYear;
  LDoc.Month := AMonth;
  LDoc.Day := ADay;

  LkWhData.InCome1 := 0;
  LkWhData.InCome2 := 0;
  LkWhData.InCome3 := 0;
  LkWhData.VCBF1 := 0;
  LkWhData.VCBF2 := 0;
  LkWhData.VCBG7A := 0;

  LDoc.kWh := _JSON(LkWhData);
  LColl.Insert(LDoc);
end;

function TDataSave2MongoDBThread.InsertMetaData(ARecCount: integer): Boolean;
var
  i: integer;
  LColl: TMongoCollection;
  LDocs: TVariantDynArray;
begin
  SetLength(LDocs,ARecCount);
  LColl := FDB.CollectionOrCreate[FMongoCollectName + '_META'];

  for i := 0 to ARecCount-1 do
  begin
    TDocVariant.New(LDocs[i]);
//    LDocs[i]._id := ObjectID; // compute new ObjectID on the client side
    LDocs[i].Name := 'Name '+IntToStr(i+1);
    LDocs[i].TagName := TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].TagName;
    LDocs[i].Desc := TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].Description;
    LDocs[i].TagIndex := i;
  end;

  LColl.Insert(LDocs); // insert all values at once
  TFrameDataSaveAll(FFrameDataSaveAll).DisplayMessage (DateTimeToStr(now)+' => '+FMongoCollectName + '_META' + ' Inserted(' + IntToStr(ARecCount) + ' Docs)', 0);
end;

function TDataSave2MongoDBThread.InsertMetaData2(ARecCount: integer): Boolean;
var
  i,j,k,m: integer;
  LColl: TMongoCollection;
  LDocs: TVariantDynArray;
  LDocs2: TVariantDynArray;
  LDocs3: TVariantDynArray;
begin
  j := 0;
  k := 0;

  for i := 0 to ARecCount-1 do
  begin
    //Analog Data Meta 저장(PMS_OPC_ANALOG_META)
    case TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].BlockNo of
      1: inc(j);
      2: inc(k);
      3: inc(m);
    end;
  end;

  SetLength(LDocs,j);
  LColl := FDB.CollectionOrCreate[FMongoCollectName + '_META'];
  j := 0;

  for i := 0 to ARecCount-1 do
  begin
    //Analog Data Meta 저장(PMS_OPC_ANALOG_META)
    if TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].BlockNo = 1 then
    begin
      TDocVariant.New(LDocs[j]);
  //    LDocs[i]._id := ObjectID; // compute new ObjectID on the client side
      LDocs[j].Name := 'Name '+IntToStr(j+1);
      LDocs[j].TagName := TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].TagName;
      LDocs[j].Desc := TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].Description;
      LDocs[j].TagIndex := j;
      Inc(j);
    end;
  end;

  LColl.Insert(LDocs); // insert all values at once
//  FrmDataSaveAll.DisplayMessage (TimeToStr(Time)+' => '+FMongoCollectName + '_META' + ' Inserted(' + IntToStr(ARecCount) + ' Docs)', dtSendMemo);
  SendCopyData2(FOwner.Handle, DateTimeToStr(now)+' => '+FMongoCollectName + '_META' + ' Inserted(' + IntToStr(j) + ' Docs)', ord(dtSendMemo));

  if FMongoCollectName2 <> '' then
  begin
    SetLength(LDocs2,k);
    LColl := FDB.CollectionOrCreate[FMongoCollectName2 + '_META'];
    k := 0;

    for i := 0 to ARecCount-1 do
    begin
      //Digital Data Meta 저장(PMS_OPC_DIGITAL_META)
      if TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].BlockNo = 2 then
      begin
        TDocVariant.New(LDocs2[k]);
    //    LDocs[i]._id := ObjectID; // compute new ObjectID on the client side
        LDocs2[k].Name := 'Name '+IntToStr(k+1);
        LDocs2[k].TagName := TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].TagName;
        LDocs2[k].Desc := TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].Description;
        LDocs2[k].TagIndex := k;
        Inc(k);
      end;
    end;

    LColl.Insert(LDocs2); // insert all values at once
  //  FrmDataSaveAll.DisplayMessage (TimeToStr(Time)+' => '+FMongoCollectName + '_META' + ' Inserted(' + IntToStr(ARecCount) + ' Docs)', dtSendMemo);
    SendCopyData2(FOwner.Handle, DateTimeToStr(now)+' => '+FMongoCollectName2 + '_META' + ' Inserted(' + IntToStr(k) + ' Docs)', Ord(dtSendMemo));
  end;

  if FMongoCollectName3 <> '' then
  begin
    SetLength(LDocs3,m);
    LColl := FDB.CollectionOrCreate[FMongoCollectName3 + '_META'];
    m := 0;

    for i := 0 to ARecCount-1 do
    begin
      //Digital Data Meta 저장(PMS_OPC_DIGITAL_META)
      if TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].BlockNo = 3 then
      begin
        TDocVariant.New(LDocs3[m]);
    //    LDocs[i]._id := ObjectID; // compute new ObjectID on the client side
        LDocs3[m].Name := 'Name '+IntToStr(m+1);
        LDocs3[m].TagName := TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].TagName;
        LDocs3[m].Desc := TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].Description;
        LDocs3[m].TagIndex := m;
        Inc(m);
      end;
    end;

    LColl.Insert(LDocs3); // insert all values at once
  //  FrmDataSaveAll.DisplayMessage (TimeToStr(Time)+' => '+FMongoCollectName + '_META' + ' Inserted(' + IntToStr(ARecCount) + ' Docs)', dtSendMemo);
    SendCopyData2(FOwner.Handle, DateTimeToStr(now)+' => '+FMongoCollectName3 + '_META' + ' Inserted(' + IntToStr(m) + ' Docs)', Ord(dtSendMemo));
  end;
end;

procedure TDataSave2MongoDBThread.InsertOrUpdateEngDivkWh2DB(AYear, AMonth, ADay: word;
  AInCome1, AInCome2, AInCome3, AVCBF1, AVCBF2, AVCBG7A: double);
var
  LColl: TMongoCollection;
  LDoc: Variant;
begin
  LColl := nil;
  LColl := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];

  if Assigned(LColl) then
  begin
    Ldoc := LColl.FindDoc('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay]);

    if LDoc = null then
      InsertEngDivkWh2DB(AYear, AMonth, ADay, AInCome1, AInCome2, AInCome3,
        AVCBF1, AVCBF2, AVCBG7A, LColl)
    else
      UpdateEngDivkWh2DB2(AYear, AMonth, ADay, AInCome1, AInCome2, AInCome3,
        AVCBF1, AVCBF2, AVCBG7A, LColl);
  end;
end;

function TDataSave2MongoDBThread.SelectAllDBData(var ADocs: TVariantDynArray;
  ACollName: string): Boolean;
var
  LColl: TMongoCollection;
  LDocsCount: integer;
begin
  Result := True;

  if ACollName = '' then
    ACollName := FMongoCollectName;

  LColl := FDB.CollectionOrCreate[ACollName];
  LDocsCount := LColl.Count;

  if LDocsCount > 0 then
  begin
    SetLength(ADocs, LDocsCount);
    LColl.FindDocs(ADocs, Null);
    Result := True;
  end;
end;

function TDataSave2MongoDBThread.SelectAllDBData2String: RawUTF8;
var
  LColl: TMongoCollection;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectName];
  Result := LColl.FindJSON(varNull,varNull);
end;

function TDataSave2MongoDBThread.SelectDBData(AIndex: integer): Variant;
var
//  i: integer;
  LColl: TMongoCollection;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectName];
  Result := LColl.FindOne(AIndex);
end;

procedure TDataSave2MongoDBThread.SetRecordCount(ARecCount: integer);
begin
  FRecCount := ARecCount;
end;

procedure TDataSave2MongoDBThread.SetRecordCount2(ARecCount: integer);
begin
  FRecCount2 := ARecCount;
end;

procedure TDataSave2MongoDBThread.SetRecordCount3(ARecCount: integer);
begin
  FRecCount3 := ARecCount;
end;

function TDataSave2MongoDBThread.UpdateDBData(ABSON: string): Boolean;
var
  LColl: TMongoCollection;
  LDoc: variant;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectName];
  LDoc := LColl.FindOne(5);
  LDoc.Name := 'New!';
  LColl.Update(BSONVariant(['_id',5]),LDoc);
//  LColl.Update('{_id:?}',[3],'{Name:?}',['New Name!']); => 다른 Field 삭제되고 Name Field만 존재함
//  LColl.Update('{_id:?}',[4],'{$set:{Name:?}}',['New Name!']); => Name Field만 수정함.

  Result := True;
end;

//AItemName = kWh.InCome1
function TDataSave2MongoDBThread.UpdateEngDivkWh2DB(AYear, AMonth, ADay,
  AkWh: word; AItemName: string): Boolean;
var
  LColl: TMongoCollection;
  LDoc: Variant;
  DOCA, DOCB, DOCC: PDocVariantData;
begin
  Result := False;
  LColl := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];
  Ldoc := LColl.FindDoc('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay]);
  DOCA := DocVariantData(Ldoc);//JSON Array로 전달 됨

  if DOCA <> nil then
  begin
//    Memo1.Lines.Add(DOCA.Values[0].Day);
    AItemName := '{$set:{' + AItemName + ':?}}';//kWh.InCome1
    LColl.Update('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay],
      AItemName ,[AkWh]);
    Result := True;
  end;
end;

function TDataSave2MongoDBThread.UpdateEngDivkWh2DB2(AYear, AMonth, ADay: word;
  AInCome1, AInCome2, AInCome3, AVCBF1, AVCBF2, AVCBG7A: double;
  AMongoCollection: TMongoCollection): Boolean;
var
  LDoc: Variant;
  DOCA, DOCB, DOCC: PDocVariantData;
begin
  Result := False;
  if not Assigned(AMongoCollection) then
    AMongoCollection := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];
  Ldoc := AMongoCollection.FindDoc('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay]);
  DOCA := DocVariantData(Ldoc);//JSON Array로 전달 됨

  if DOCA <> nil then
  begin
    AMongoCollection.Update('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay],
      '{$set:{kWh.InCome1:?, kWh.InCome2:?, kWh.InCome3:?, kWh.VCBF1:?, kWh.VCBF2:?, kWh.VCBG7A:?}}',
      [AInCome1, AInCome2, AInCome3, AVCBF1, AVCBF2, AVCBG7A]);
    Result := True;
  end;
end;

end.
