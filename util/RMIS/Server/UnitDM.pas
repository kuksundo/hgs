unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, System.Variants, DBAccess, OraTransaction,
  Data.DB, MemDS, Ora, OraCall, mORMot, SynCommons, SynMongoDB, VarRecUtils,
  ElecPowerCalcClass;

type
  TDM1 = class(TDataModule)
    DPMSSession: TOraSession;
    DPMSQuery1: TOraQuery;
    DPMSTransaction: TOraTransaction;
    DPMSQuery2: TOraQuery;
    ProductSession: TOraSession;
    ProductQuery1: TOraQuery;
    ProductTransaction: TOraTransaction;
    ProductQuery2: TOraQuery;
    ExtraMHTransaction: TOraTransaction;
    ExtraMHSession: TOraSession;
    ExtraMHQuery: TOraQuery;
    DPMSAppTransaction: TOraTransaction;
    DPMSAppSession: TOraSession;
    DPMSAppQuery: TOraQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FClient : TMongoClient;
    FDB : TMongoDatabase;
  public
    function ConnectDB: Boolean;
    procedure DisConnectDB;
    function GetEngDiv_kWh(AYear, AMonth, ADay: integer): RawUTF8;
  end;

var
  DM1: TDM1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM1 }

function TDM1.ConnectDB: Boolean;
begin
  Result := False;

  if not Assigned(FClient) then
    FClient := TMongoClient.Create(PMS_DB_IP_ADDRESS, PMS_DB_PORT);

  if Assigned(FClient) then
  begin
    FClient.WriteConcern := wcUnacknowledged;
    FDB := nil;
    FDB := FClient.Database[PMS_DB];

    if Assigned(FDB) then
      Result := True;
  end;
end;

procedure TDM1.DataModuleCreate(Sender: TObject);
begin
  ConnectDB;
end;

procedure TDM1.DataModuleDestroy(Sender: TObject);
begin
  DisConnectDB;
end;

procedure TDM1.DisConnectDB;
begin
  if Assigned(FClient) then
    FClient.Free;
end;

function TDM1.GetEngDiv_kWh(AYear, AMonth, ADay: integer): RawUTF8;
type TVarRecArr = array of TVarRec;
var
  LColl: TMongoCollection;
  LDoc: Variant;
  LQry: PUTF8Char;
  LUtf8: UTF8String;
  LStr: Ansistring;
  LProjection: TConstArray;
  i: integer;
begin
  Result := '';
  LColl := nil;
  LColl := FDB.CollectionOrCreate[PMS_ENGDIV_KWH_COLL];

  if Assigned(LColl) then
  begin
    LStr := 'Year:?';

    if AMonth <> 0 then
    begin
      LStr := LStr + ', Month:?';

      if ADay <> 0 then
      begin
        LStr := LStr + ', Day:?';
      end;
    end;

    LStr := '{' + LStr + '}';
    LUtf8 := StringToUtf8(LStr);
    LQry := @LUtf8[1];

    if Pos('Day', LStr) > 0 then
      LProjection := CreateConstArray([AYear, AMonth, ADay])
    else
    if Pos('Month', LStr) > 0 then
      LProjection := CreateConstArray([AYear, AMonth])
    else
    if Pos('Year', LStr) > 0 then
      LProjection := CreateConstArray([AYear]);

    try
      Ldoc := LColl.FindDoc(LQry, LProjection); //'{Year:?, Month:?, Day:?}' [AYear, AMonth, ADay]
//      Ldoc := LColl.FindDoc('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay]);
//    Ldoc := LColl.FindDoc(LQry, [AYear, AMonth, ADay]);

      if LDoc <> null then
        Result := VariantSaveJson(LDoc);
    finally
      FinalizeConstArray(LProjection);
    end;
  end;
end;

end.
