unit UnitSQLPMSOPC;

interface

uses
  SysUtils,
  Variants,
  SynCommons,
  SynMongoDB,
  mORMot,
//  SynSQLite3Static,
  mORMotSQLite3,
  mORMotMongoDB;

type
  TSQLPMSOPC = class(TSQLRecord)
  private
    fName: RawUTF8;
    fProductDate: TDateTime;
    fDailykWHour: variant;
    fDailykWPrice: variant;
    fInts: TIntegerDynArray;
    fCreateTime: TCreateTime;
    fData: TSQLRawBlob;
  published
    property Name: RawUTF8 read fName write fName stored AS_UNIQUE;
    property ProductDate: TDateTime read fProductDate write fProductDate;
    property DailykWHour: variant read fDailykWHour write fDailykWHour;
    property DailykWPrice: variant read fDailykWPrice write fDailykWPrice;
//    property Ints: TIntegerDynArray index 1 read fInts write fInts;
//    property Data: TSQLRawBlob read fData write fData;
//    property CreateTime: TCreateTime read fCreateTime write fCreateTime;
  end;

implementation

end.
