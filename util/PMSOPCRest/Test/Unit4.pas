unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, mORMot, mORMotUI, SynCommons, SynMongoDB,
  Vcl.StdCtrls, DateUtils;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FClient : TMongoClient;
    FDB : TMongoDatabase;
  public
    procedure InsertOrUpdateEngDivkWh2DB;
    function InsertEngDivkWh2DB: Boolean;
    function UpdateEngDivkWh2DB: Boolean;
    procedure InsertInitEngDivkWh2DB;
    procedure GetEngDivkWhFromDB;
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
  FClient := TMongoClient.Create('10.100.23.63',27017);

  if Assigned(FClient) then
  begin
    FClient.WriteConcern := wcUnacknowledged;
    FDB := nil;
    FDB := FClient.Database['PMS_DB'];
  end;

//  InsertOrUpdateEngDivkWh2DB;

end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  FClient.Free;
end;

procedure TForm4.Button3Click(Sender: TObject);
var
  LColl: TMongoCollection;
  LDoc: Variant;
  DOCA, DOCB, DOCC: PDocVariantData;
  LDocs: TVariantDynArray;
  LMonth, LDay: string;
  json: RawUTF8;
  i,j: integer;
  AYear: string;
  AMonth, ADay: word;
begin
//  AYear := '2016';
//  AMonth := 1;
//  ADay := 14;
//  LColl := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];
//  Ldoc := LColl.FindDoc('{Year:?}',[AYear]);
//  DOCA := DocVariantData(Ldoc);//JSON Array·Î Àü´Þ µÊ
//  if DOCA<>nil then
//  begin
//    DOCB := DocVariantData(DOCA.Values[DOCA.Count-1].Data);
//    if DOCB<>nil then
//    begin
//      for i := 0 to DOCB.Count - 1 do
//      begin
//        if DOCB.Values[i].Month = AMonth then
//        begin
//          DOCC := DocVariantData(DOCB.Values[i].Data);
//          if DOCC<>nil then
//          begin
//            for j := 0 to DOCC.Count - 1 do
//            begin
//              if DOCC.Values[j].Day = ADay then
//              begin
//                Break;
//              end;
//            end;
//          end;
//
//          Break;
//        end;
//      end;
//    end;
//    Memo1.Lines.Add(DOCC.Values[j].Day);
//  end;

//  LDoc := LColl.FindDoc('{_id:?}',['5697358f166ea59eba4b4686']);
//  Memo1.Lines.Add(LDoc);
//  LColl.FindDocs(Ldocs, null);
//  Memo1.Lines.Add(LDocs[0]);
//  json := LColl.FindJSON(null, null);
//  Memo1.Lines.Add(json);

  InsertOrUpdateEngDivkWh2DB;
end;

procedure TForm4.Button4Click(Sender: TObject);
begin
  GetEngDivkWhFromDB;
end;

procedure TForm4.GetEngDivkWhFromDB;
var
  AYear, AMonth, ADay: word;
  LColl: TMongoCollection;
  LDoc: Variant;
  DOCA: PDocVariantData;
  Ld: double;
begin
//  DOCA := nil;
  AYear := 2016;
  AMonth := 1;
  ADay := 15;

  LColl := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];
  Ldoc := LColl.FindDoc('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay]);

  if LDoc <> null then
    DOCA := DocVariantData(Ldoc);//JSON Array·Î Àü´Þ µÊ

  if DOCA <> nil then
  begin
    Ld := DOCA.Values[0].kWh.InCome1;
    Memo1.Lines.Add(FloatToStr(Ld));
  end;
end;

function TForm4.InsertEngDivkWh2DB: Boolean;
var
  i, j, k, LYear: integer;
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

  LDoc.Title := ObjectID;
  LDoc.Year := FormatDateTime('YYYY', now);
  LYear := StrToInt(LDoc.Year);

  LMonth := '';
  LDay := '';

  LDoc.Clear;
  LDoc.Year := FormatDateTime('YYYY', now);
  LDoc.Title := 'Engine Division Electric Energy (kWh) on ' + LDoc.Year;

  for i := 1 to 12 do
  begin
    LMonthData.Clear;
    LDayData.Clear;
    LDay := '';

    LMonthData.Month := i;
    k := DaysInAMonth(LYear, i);

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
  Memo1.Lines.Add(LDoc);
  LColl.Insert(LDoc);
end;

procedure TForm4.InsertInitEngDivkWh2DB;
var
  i, j, k, AYear, AMonth, ADay: integer;
  LColl: TMongoCollection;
  LDoc,
  LkWhData: variant;
  LStr: string;
begin
  AYear := StrToInt(FormatDateTime('YYYY', now));
  AMonth := 1;
  ADay := 14;

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

  Memo1.Lines.Add(LDoc);
  LColl.Insert(LDoc);
end;

procedure TForm4.InsertOrUpdateEngDivkWh2DB;
begin
//  InsertEngDivkWh2DB;
//  InsertInitEngDivkWh2DB;
  UpdateEngDivkWh2DB;
end;

function TForm4.UpdateEngDivkWh2DB: Boolean;
var
  LColl: TMongoCollection;
  LDoc: Variant;
  DOCA, DOCB, DOCC: PDocVariantData;
  LDocs: TVariantDynArray;
  LMonth, LDay, LItemName: string;
  json: RawUTF8;
  i,j: double;
  AYear, AMonth, ADay: word;
begin
  AYear := 2016;
  AMonth := 1;
  ADay := 14;
  i := 1000.1;
  j := 888.8;
  LItemName := '{$set:{kWh.InCome1:?, kWh.InCome2:?, kWh.InCome3:?, kWh.VCBF1:?, kWh.VCBF2:?, kWh.VCBG7A:?}}';
  LColl := FDB.CollectionOrCreate['PMS_ENGDIV_KWH_COLL'];
  Ldoc := LColl.FindDoc('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay]);
//  Memo1.Lines.Add(Ldoc);
  DOCA := DocVariantData(Ldoc);//JSON Array·Î Àü´Þ µÊ

  if DOCA<>nil then
  begin
    Memo1.Lines.Add(DOCA.Values[0].Day);
    LColl.Update('{Year:?, Month:?, Day:?}',[AYear, AMonth, ADay],
      LItemName,[i,j,j,j,j,j]);
  end;
end;

end.
