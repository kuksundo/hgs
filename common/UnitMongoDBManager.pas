unit UnitMongoDBManager;

interface

uses
  Windows, Classes, SysUtils, Forms, DB, MyKernelObject, CommonUtil, Dialogs,
  System.UITypes, Data.SqlExpr, System.Variants,
  mORMot, mORMotUI, SynCommons, SynMongoDB,
  mORMotSQLite3,
  mORMotMongoDB,
  EngineParameterClass;

type
  TMongoDBManager = class(TObject)
  public
    FClient : TMongoClient;
    FDB : TMongoDatabase;
    FModel: TSQLModel;
    FSQLClient: TSQLRestClientDB;
    FRecCount: integer;
    FMongoHostName,
    FMongoDBName,
    FMongoCollectionName: string;
    FPortNo: integer;

    FDBConnected: Boolean;

    constructor Create(AMongoHost, AMongoDB, AMongoColl: string; APortNo:integer);
    destructor Destroy; override;

    procedure InitParam;
    function ConnectDB(AReConnect: Boolean=False): Boolean;
    procedure DisConnectDB;
    procedure CreateDBParam(SqlFileName,Tablename: string);
    procedure SetRecordCount(ARecCount: integer);
    procedure SetRecordCountFromDB;
    function InsertDBData: Boolean;
    function InsertMetaData(ARecCount: integer; AEngParam: TEngineParameter): string;
    function InsertDBBulkData(ARecCount: integer; AEngParam: TEngineParameter): string;
    function InsertDBBulkData2(ARecCount: integer; AEngParam: TEngineParameter): string;
    function SelectDBData(AIndex: integer): Variant;
    function SelectDBDataLatest(var ADocs: Variant): variant;
    function FindDocsFromQry(var ADocs: TVariantDynArray; AQry: string; AParam: array of const): Boolean;
    function AggreateDocFromQry(var ADocs: TVariantDynArray; AQry: string; AParam: array of const): TVariantDynArray;
    function SelectDBDataLatest2: RawUTF8;
    function SelectAllDBData(var ADocs: TVariantDynArray; ACollName: string = ''): Boolean;
    function SelectAllDBData2String: RawUTF8;
    function UpdateDBData(ABSON: string): Boolean;
    function DeleteDBData(AId: string): Boolean;
    Function Create_InsertSQL(ATableName: string) : String;
  end;

implementation

{ TMongoDBManager }

function TMongoDBManager.ConnectDB(AReConnect: Boolean): Boolean;
begin
  if AReConnect then
  begin
    if FDBConnected then
      DisConnectDB;
  end
  else
  if FDBConnected then
  begin
    Result := True;
    exit;
  end;

  Result := False;

  FClient := nil;

  FClient := TMongoClient.Create(FMongoHostName,FPortNo);

  if Assigned(FClient) then
  begin
    FDB := nil;
    FDB := FClient.Database[FMongoDBName];

    if Assigned(FDB) then
    begin
      Result := True;
      FDBConnected := True;
    end;
  end;
end;

constructor TMongoDBManager.Create(AMongoHost, AMongoDB, AMongoColl: string; APortNo:integer);
begin
  FMongoHostName := AMongoHost;
  FMongoDBName := AMongoDB;
  FMongoCollectionName := AMongoColl;
  FPortNo := APortNo;//27017;
end;

procedure TMongoDBManager.CreateDBParam(SqlFileName, Tablename: string);
begin

end;

function TMongoDBManager.Create_InsertSQL(ATableName: string): String;
begin

end;

function TMongoDBManager.DeleteDBData(AId: string): Boolean;
var
  LColl: TMongoCollection;
  LDoc: variant;
begin
  Result := False;
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
  LColl.RemoveOne(ObjectId(AId));
end;

destructor TMongoDBManager.Destroy;
begin
  DisConnectDB;

  inherited;
end;

procedure TMongoDBManager.DisConnectDB;
begin
//  FDB.Free;
  FClient.Free;
  FDBConnected := False;
end;

function TMongoDBManager.FindDocsFromQry(var ADocs: TVariantDynArray;
  AQry : string; AParam: array of const): Boolean;
var
  LColl: TMongoCollection;
  LDocsCount: integer;
  LQry: PUTF8Char;
begin
  if AQry = '' then
    exit;

  LQry := PUTF8Char(StringToUTF8(AQry));

  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
  LDocsCount := LColl.Count;

  if LDocsCount > 0 then
  begin
    SetLength(ADocs, LDocsCount);
    LColl.FindDocs(LQry, AParam, ADocs, Null);
//    LColl.FindDocs('{SavedTime:{$gt:?}}', [DateTimeToIso8601(Now-1, True)], ADocs, Null);
//    LColl.FindDocs(LQry, [DateTimeToIso8601(Now-1, True), DateTimeToIso8601(Now, True)], ADocs, Null);
//    LColl.FindDocs('{V1:{$gt:?}}', ['6670'], ADocs, Null);
//    LColl.FindDocs('{V1:?}', ['6600'], ADocs, Null);
//     LColl.FindCount('{V1:6600}');
  end;

  Result := True;
end;

procedure TMongoDBManager.InitParam;
begin

end;

function TMongoDBManager.InsertDBBulkData(ARecCount: integer; AEngParam: TEngineParameter): string;
var
  i: integer;
  LColl: TMongoCollection;
  LDoc: variant;
  LStr, LStr2: RawUTF8;
  V: variant;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];

  for i := 0 to ARecCount-1 do
  begin
    LStr := LStr + '"V' + IntToStr(i+1) + '": "' + AEngParam.EngineParameterCollect.Items[i].Value + '", ';
//    LStr2 := LStr2 + FrmDataSaveAll.TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value + ',';
  end;

  i := PosRev(',', LStr);

  if i = Length(LStr) - 1 then
    System.Delete(LStr,i,1);

  LStr := '{ "SavedTime": new Date(), ' + LStr + '}';
  LDoc := TDocVariant.NewJSON(LStr);
  LColl.Insert(LDoc); // insert all values at once
  Result := TimeToStr(Time)+' => '+ FMongoCollectionName+' Inserted(Bulk: ' + IntToStr(ARecCount) + ' Docs)';
end;

function TMongoDBManager.InsertDBBulkData2(ARecCount: integer; AEngParam: TEngineParameter): string;
var
  i: integer;
  LColl: TMongoCollection;
  LDocs: TVariantDynArray;
begin
  SetLength(LDocs,ARecCount);
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];

  for i := 0 to ARecCount-1 do
  begin
    TDocVariant.New(LDocs[i]);
//    LDocs[i]._id := ObjectID; // compute new ObjectID on the client side
    LDocs[i].Name := 'Name '+IntToStr(i+1);
    LDocs[i].Value := AEngParam.EngineParameterCollect.Items[i].Value;
  end;

  LColl.Insert(LDocs); // insert all values at once
  Result := TimeToStr(Time)+' => '+ FMongoCollectionName+' Inserted(Bulk: ' + IntToStr(ARecCount) + ' Docs)';
end;

function TMongoDBManager.InsertDBData: Boolean;
var
  i: integer;
  LColl: TMongoCollection;
  LDoc: variant;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
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

function TMongoDBManager.InsertMetaData(ARecCount: integer; AEngParam: TEngineParameter): string;
var
  i: integer;
  LColl: TMongoCollection;
  LDocs: TVariantDynArray;
begin
  SetLength(LDocs,ARecCount);
  LColl := FDB.CollectionOrCreate[FMongoCollectionName + '_META'];

  for i := 0 to ARecCount-1 do
  begin
    TDocVariant.New(LDocs[i]);
//    LDocs[i]._id := ObjectID; // compute new ObjectID on the client side
    LDocs[i].Name := 'Name '+IntToStr(i+1);
    LDocs[i].TagName := AEngParam.EngineParameterCollect.Items[i].TagName;
    LDocs[i].Desc := AEngParam.EngineParameterCollect.Items[i].Description;
    LDocs[i].TagIndex := i;
  end;

  LColl.Insert(LDocs); // insert all values at once
  Result := TimeToStr(Time)+' => ' + FMongoCollectionName + '_META' + ' Inserted(' + IntToStr(ARecCount) + ' Docs)';
end;

function TMongoDBManager.SelectAllDBData(var ADocs: TVariantDynArray;
  ACollName: string): Boolean;
var
  LColl: TMongoCollection;
  LDocsCount: integer;
begin
  Result := True;

  if ACollName = '' then
    ACollName := FMongoCollectionName;

  LColl := FDB.CollectionOrCreate[ACollName];
  LDocsCount := LColl.Count;

  if LDocsCount > 0 then
  begin
    SetLength(ADocs, LDocsCount);
    LColl.FindDocs(ADocs, Null);
    Result := True;
  end;
end;

function TMongoDBManager.SelectAllDBData2String: RawUTF8;
var
  LColl: TMongoCollection;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
  Result := LColl.FindJSON(varNull,varNull);
end;

function TMongoDBManager.SelectDBData(AIndex: integer): Variant;
var
//  i: integer;
  LColl: TMongoCollection;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
  Result := LColl.FindOne(AIndex);
end;

function TMongoDBManager.AggreateDocFromQry(var ADocs: TVariantDynArray;
  AQry: string; AParam: array of const): TVariantDynArray;
var
  LColl: TMongoCollection;
//  LDocsCount: integer;
  LQry: PUTF8Char;
  LDoc, LValue, LValue2: variant;
  i, LSum: integer;
  LStr: string;
  LUtf8: RawUTF8;
begin
  if AQry = '' then
    exit;

  LQry := PUTF8Char(StringToUTF8(AQry));

  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
//  LDocsCount := LColl.Count;
//  SetLength(ADocs, LDocsCount);
//  str1 := LColl.AggregateDoc('{$group:{_id:null,max:{$max:"$_id"}}}',[]).max;
//  ADocs := LColl.FindDoc('{_id:?}',['53d75bd3acd063fd19ea3250']);
//  ADocs := LColl.AggregateDoc('{$sort:{$natural:-1}},{$limit:1}',[]);
  LDoc := LColl.AggregateDoc(LQry,AParam);
  LUtf8 := LDoc;
  ADocs := JSONToVariantDynArray(LUtf8);
//  AQry := '{ aggregate: "PMS_OPC_ANALOG",   pipeline: [{$sort:{_id:-1}},{$limit:1}], allowDiskUse: true}';
//  FDB.RunCommand(BSONVariant(AQry), LDoc);
//  LValue := PVariant(TVarData(LDoc).VPointer)^;

//  if LDoc._kind = ord(dvArray) then
  for i := 0 to TDocVariantData(LDoc).Count - 1 do
  begin
    LValue2 := TDocVariantData(LDoc).Values[i];
    LStr := UTF8ToString(LValue2.V861);
    LSum := LSum + StrToIntDef(LStr,0);
//    showmessage(Utf8ToString(VariantToUtf8(LDoc.SavedTime)));
//    showmessage(Utf8ToString(VariantToUtf8(LDoc._(0))));
  end;
  Result := ADocs;
end;

function TMongoDBManager.SelectDBDataLatest(var ADocs: Variant): variant;
var
  LColl: TMongoCollection;
//  str1: String;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
//  str1 := LColl.AggregateDoc('{$group:{_id:null,max:{$max:"$_id"}}}',[]).max;
//  ADocs := LColl.FindDoc('{_id:?}',['53d75bd3acd063fd19ea3250']);
//  ADocs := LColl.AggregateDoc('{$sort:{$natural:-1}},{$limit:1}',[]);
  ADocs := LColl.AggregateDoc('{$sort:{_id:-1}},{$limit:1}',[]);
//  if ADocs = Null then
//    Result := -1
//  else
  Result := ADocs;
end;

function TMongoDBManager.SelectDBDataLatest2: RawUTF8;
var
  LColl: TMongoCollection;
  LArr: TVariantDynArray;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
  Result := LColl.AggregateJSON('{$sort:{_id:-1}},{$limit:1}',[]);
//  Result := LColl.AggregateJSON('{$project:{V1:1,_id:0}},{$sort:{_id:-1}},{$limit:1}',[]);
end;

procedure TMongoDBManager.SetRecordCount(ARecCount: integer);
begin
  FRecCount := ARecCount;
end;

procedure TMongoDBManager.SetRecordCountFromDB;
var
  LColl: TMongoCollection;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
  FRecCount := LColl.Count;
end;

function TMongoDBManager.UpdateDBData(ABSON: string): Boolean;
var
  LColl: TMongoCollection;
  LDoc: variant;
begin
  LColl := FDB.CollectionOrCreate[FMongoCollectionName];
  LDoc := LColl.FindOne(5);
  LDoc.Name := 'New!';
  LColl.Update(BSONVariant(['_id',5]),LDoc);
//  LColl.Update('{_id:?}',[3],'{Name:?}',['New Name!']); => 다른 Field 삭제되고 Name Field만 존재함
//  LColl.Update('{_id:?}',[4],'{$set:{Name:?}}',['New Name!']); => Name Field만 수정함.

  Result := True;
end;

end.
