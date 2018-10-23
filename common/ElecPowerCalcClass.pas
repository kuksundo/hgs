unit ElecPowerCalcClass;

interface

uses classes, SysUtils, Menus, Vcl.ComCtrls, DateUtils,
  HiMECSConst, BaseConfigCollect, CircularArray;

type
  TVCBNumber = (vnVCBG2, vnVCBG4, vnVCBG5, vnVCBG6, vnVCBG7, vnVCBF1, vnVCBF2,
    vnVCBF3, vnInCome1, vnInCome2, vnInCome3);

  //저압(220V/380V),고압A(3,300V ~6,600V),고압B(154,000V),고압C(345,000V)
  TVoltageType = (vtLow, vtHigh_A, vtHigh_B, vtHigh_C);
  TLoadType = (ltLightLoad=1, ltMiddleLoad=2, ltHeavyLoad=3); //경부하, 중간부하, 최대부하
  //선택(I)요금 = 설비가동 월 200시간 이하(기본요금 싸고 전력량 요금 비쌈)
  //선택(II)요금 = 설비가동 월 200 ~ 500 시간
  //선택(III)요금 = 설비가동 월 500시간 이상(기본요금 비싸고 전력량 요금 쌈)
  TPriceSelect = (psSel_I=1, psSel_II=2, psSel_III=3);
  TSeason = (sSpring=1,sSummer=2,sFall=3,sWinter=4);

  //내구시험장 적산전력계 레코드
  TPPPkWhRecord = record
    FYear,
    FMonth,
    FDay: word;
    FVCBG2kWh,
    FACBG4kWh,
    FVCBF1kWh,
    FVCBG5kWh,
    FVCBG6kWh,
    FVCBF2kWh,
    FVCBG7AkWh,
    FVCBF3kWh,
    FInCome1kWh,
    FInCome2kWh,
    FInCome3kWh : double; //실시간 적산 전력 값이 저장 됨 kWh/3600초
  end;
const
  PMS_ENGDIV_PWR_COLL = 'PMS_ENGDIV_PWR_COLL';
  PMS_ENGDIV_KWH_COLL = 'PMS_ENGDIV_KWH_COLL';
  PMS_DB_IP_ADDRESS = '10.100.23.63';
  PMS_DB_PORT = 27017;
  PMS_DB = 'PMS_DB';

  VOLTYPECOUNT = integer(High(TVoltageType))+1;
  R_VoltageType : array[0..VOLTYPECOUNT-1] of record
    Description : string;
    Value       : TVoltageType;
  end = ((Description : '저압';       Value : vtLow),
         (Description : '고압 A';     Value : vtHigh_A),
         (Description : '고압 B';     Value : vtHigh_B),
         (Description : '고압 C';     Value : vtHigh_C));

  LOADTYPECOUNT = integer(High(TLoadType));
  R_LoadType : array[0..LOADTYPECOUNT-1] of record
    Description : string;
    Value       : TLoadType;
  end = ((Description : '경부하';       Value : ltLightLoad),
         (Description : '중간부하';     Value : ltMiddleLoad),
         (Description : '최대부하';     Value : ltHeavyLoad));

  PRICESELCOUNT = integer(High(TPriceSelect));
  R_PriceSelect : array[0..PRICESELCOUNT-1] of record
    Description : string;
    Value       : TPriceSelect;
  end = ((Description : '선택(I) 요금';      Value : psSel_I),
         (Description : '선택(II) 요금';     Value : psSel_II),
         (Description : '선택(III) 요금';    Value : psSel_III));

  SEASONCOUNT = integer(High(TSeason));
  R_Season : array[0..SEASONCOUNT-1] of record
    Description : string;
    Value       : TSeason;
  end = ((Description : '봄';       Value : sSpring),
         (Description : '여름';     Value : sSummer),
         (Description : '가을';     Value : sFall),
         (Description : '겨울';     Value : sWinter));

  function VoltageType2String(AVoltageType:TVoltageType) : string;
  function String2VoltageType(AVoltageType:string): TVoltageType;
  function LoadType2String(ALoadType:TLoadType) : string;
  function String2LoadType(ALoadType:string): TLoadType;
  function PriceSelect2String(APriceSelect:TPriceSelect) : string;
  function String2PriceSelect(APriceSelect:string): TPriceSelect;
  function Season2String(ASeason:TSeason) : string;
  function String2Season(ASeason:string): TSeason;

type
  TElecPowerCalcCollect = class;
  TElecPowerCalcItem = class;

  TElecPowerCalcBase = class(TpjhBase)
  private
    FElecPowerCalcCollect: TElecPowerCalcCollect;
    FBaseRegDate: TDate;
    FBasePrice: double;   //기본요금
    FBasekW: integer; //계약 전력 300kW 이상

    FArray_VCBG2kW,
    FArray_VCBG4kW,
    FArray_VCBF1kW,
    FArray_VCBG5kW,
    FArray_VCBG6kW,
    FArray_VCBF2kW,
    FArray_VCBG7AkW,
    FArray_VCBF3kW,
    FArray_InCome1kW,
    FArray_InCome2kW,
    FArray_InCome3kW : TCircularArray; //순시 kW 값이 배열에 저장됨(15분 = 900초)

    procedure _GetHourMinute(ATime: string; var AHour, AMin: word);//"08:10" 을 입력 받아서 AHour = 8, AMin = 10 에 넣어줌
  public
    FkWhRecord: TPPPkWhRecord;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure GetHourMinute;
    function GetUsedkWh(AVCB: TVCBNumber): double; //전력사용량을 반환함
    function GetBasePrice4UsedkWh(ADateTime: TDateTime): double; //계절별 시간대별 전력량 요금 반환
    function GetPrice4UsedkWhAtTime(ADateTime: TDateTime; AUsedkWh: double): longint;//전력사용량 요금을 계산하여 반환(원 이하 절사)

    procedure ResetkWhAll(AYear, AMonth, ADay: word);
    procedure ResetkWh(var AkWhVar: double; AValue: double = 0.0);
    procedure AddkW2Var(ATagName, AValue: string);
    procedure SetkWhFromDoc(ADoc: Variant);

    procedure SetVCBG2kW(AValue: double);
    procedure SetACBG4kW(AValue: double);
    procedure SetVCBF1kW(AValue: double);
    procedure SetVCBG5kW(AValue: double);
    procedure SetVCBG6kW(AValue: double);
    procedure SetVCBF2kW(AValue: double);
    procedure SetVCBG7AkW(AValue: double);
    procedure SetVCBF3kW(AValue: double);
    procedure SetInCome1kW(AValue: double);
    procedure SetInCome2kW(AValue: double);
    procedure SetInCome3kW(AValue: double);

    procedure SetVCBG2kWh(AValue: double);
    procedure SetACBG4kWh(AValue: double);
    procedure SetVCBF1kWh(AValue: double);
    procedure SetVCBG5kWh(AValue: double);
    procedure SetVCBG6kWh(AValue: double);
    procedure SetVCBF2kWh(AValue: double);
    procedure SetVCBG7AkWh(AValue: double);
    procedure SetVCBF3kWh(AValue: double);
    procedure SetInCome1kWh(AValue: double);
    procedure SetInCome2kWh(AValue: double);
    procedure SetInCome3kWh(AValue: double);
  published
    property ElecPowerCalcCollect: TElecPowerCalcCollect read FElecPowerCalcCollect write FElecPowerCalcCollect;
    property BaseRegDate: TDate read FBaseRegDate write FBaseRegDate;
    property BasePrice: double read FBasePrice write FBasePrice;
    property BasekW: integer read FBasekW write FBasekW;

    property VCBG2kWh: double read FkWhRecord.FVCBG2kWh;
    property ACBG4kWh: double read FkWhRecord.FACBG4kWh;
    property VCBF1kWh: double read FkWhRecord.FVCBF1kWh;
    property VCBG5kWh: double read FkWhRecord.FVCBG5kWh;
    property VCBG6kWh: double read FkWhRecord.FVCBG6kWh;
    property VCBF2kWh: double read FkWhRecord.FVCBF2kWh;
    property VCBG7AkWh: double read FkWhRecord.FVCBG7AkWh;
    property VCBF3kWh: double read FkWhRecord.FVCBF3kWh;
    property InCome1kWh: double read FkWhRecord.FInCome1kWh;
    property InCome2kWh: double read FkWhRecord.FInCome2kWh;
    property InCome3kWh: double read FkWhRecord.FInCome3kWh;
  end;

  TElecPowerCalcItem = class(TCollectionItem)
  private
    FRegDate: TDate;
    FSeason: TSeason;
    FLoadType: TLoadType;
    FMonth: integer;
    FBeginTime_S: string;
    FEndTime_S: string;
    FPrice: double; //요금액수

    FBeginHour,
    FBeginMinute,
    FEndHour,
    FEndMinute: word;
  public
    FBeginTime: TTime;
    FEndTime: TTime;
  published
    property RegDate: TDate read FRegDate write FRegDate;
    property Season: TSeason read FSeason write FSeason;
    property LoadType: TLoadType read FLoadType write FLoadType;
    property FFMonth: integer read FMonth write FMonth;
    property BeginTime_S: string read FBeginTime_S write FBeginTime_S;
    property EndTime_S: string read FEndTime_S write FEndTime_S;
    property Price: double read FPrice write FPrice;
  end;

  TElecPowerCalcCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TElecPowerCalcItem;
    procedure SetItem(Index: Integer; const Value: TElecPowerCalcItem);
  public
    function  Add: TElecPowerCalcItem;
    function Insert(Index: Integer): TElecPowerCalcItem;
    property Items[Index: Integer]: TElecPowerCalcItem read GetItem  write SetItem; default;
  end;

implementation

function VoltageType2String(AVoltageType:TVoltageType) : string;
begin
  Result := R_VoltageType[ord(AVoltageType)].Description;
end;

function String2VoltageType(AVoltageType:string): TVoltageType;
var Li: integer;
begin
  for Li := 0 to VOLTYPECOUNT - 1 do
  begin
    if R_VoltageType[Li].Description = AVoltageType then
    begin
      Result := R_VoltageType[Li].Value;
      exit;
    end;
  end;
end;

function LoadType2String(ALoadType:TLoadType) : string;
begin
  Result := R_LoadType[ord(ALoadType)-1].Description;
end;

function String2LoadType(ALoadType:string): TLoadType;
var Li: integer;
begin
  for Li := 0 to LOADTYPECOUNT - 1 do
  begin
    if R_LoadType[Li].Description = ALoadType then
    begin
      Result := R_LoadType[Li].Value;
      exit;
    end;
  end;
end;

function PriceSelect2String(APriceSelect:TPriceSelect) : string;
begin
  Result := R_PriceSelect[ord(APriceSelect)-1].Description;
end;

function String2PriceSelect(APriceSelect:string): TPriceSelect;
var Li: integer;
begin
  for Li := 0 to PRICESELCOUNT - 1 do
  begin
    if R_PriceSelect[Li].Description = APriceSelect then
    begin
      Result := R_PriceSelect[Li].Value;
      exit;
    end;
  end;
end;

function Season2String(ASeason:TSeason) : string;
begin
  Result := R_Season[ord(ASeason)-1].Description;
end;

function String2Season(ASeason:string): TSeason;
var Li: integer;
begin
  for Li := 0 to SEASONCOUNT - 1 do
  begin
    if R_Season[Li].Description = ASeason then
    begin
      Result := R_Season[Li].Value;
      exit;
    end;
  end;
end;

{ TElecPowerCalcCollect }

function TElecPowerCalcCollect.Add: TElecPowerCalcItem;
begin
  Result := TElecPowerCalcItem(inherited Add);
end;

function TElecPowerCalcCollect.GetItem(Index: Integer): TElecPowerCalcItem;
begin
  Result := TElecPowerCalcItem(inherited Items[Index]);
end;

function TElecPowerCalcCollect.Insert(Index: Integer): TElecPowerCalcItem;
begin
  Result := TElecPowerCalcItem(inherited Insert(Index));
end;

procedure TElecPowerCalcCollect.SetItem(Index: Integer; const Value: TElecPowerCalcItem);
begin
  Items[Index].Assign(Value);
end;

{ TElecPowerCalcBase }

procedure TElecPowerCalcBase.AddkW2Var(ATagName, AValue: string);
var
  j: integer;
begin
  j := Round(StrToFloatDef(AValue,0.0));

  if ATagName = 'V520' then //InCome1
    SetInCome1kW(j)
  else if ATagName = 'V1068' then //InCome2
    SetInCome2kW(j)
  else if ATagName = 'V1087' then //InCome3
    SetInCome3kW(j)
  else if ATagName = 'V543' then //VCBF1
    SetVCBF1kW(j)
  else if ATagName = 'V566' then //VCBF2
    SetVCBF2kW(j)
  else if ATagName = 'V1292' then //VCBG7A
    SetVCBG7AkW(j);
end;

constructor TElecPowerCalcBase.Create(AOwner: TComponent);
begin
  FElecPowerCalcCollect := TElecPowerCalcCollect.Create(TElecPowerCalcItem);
  FArray_VCBG2kW := TCircularArray.Create(900);
  FArray_VCBG4kW := TCircularArray.Create(900);
  FArray_VCBF1kW := TCircularArray.Create(900);
  FArray_VCBG5kW := TCircularArray.Create(900);
  FArray_VCBG6kW := TCircularArray.Create(900);
  FArray_VCBF2kW := TCircularArray.Create(900);
  FArray_VCBG7AkW := TCircularArray.Create(900);
  FArray_VCBF3kW := TCircularArray.Create(900);
  FArray_InCome1kW := TCircularArray.Create(900);
  FArray_InCome2kW := TCircularArray.Create(900);
  FArray_InCome3kW := TCircularArray.Create(900);
end;

destructor TElecPowerCalcBase.Destroy;
begin
  FArray_VCBG2kW.Free;
  FArray_VCBG4kW.Free;
  FArray_VCBF1kW.Free;
  FArray_VCBG5kW.Free;
  FArray_VCBG6kW.Free;
  FArray_VCBF2kW.Free;
  FArray_VCBG7AkW.Free;
  FArray_VCBF3kW.Free;
  FArray_InCome1kW.Free;
  FArray_InCome2kW.Free;
  FArray_InCome3kW.Free;

  FElecPowerCalcCollect.Free;

  inherited Destroy;
end;

function TElecPowerCalcBase.GetBasePrice4UsedkWh(ADateTime: TDateTime): double;
var
  i: integer;
  LMonth : Word;
  LBeginTime, LEndTime: TTime;
  LStr: string;
begin
  Result := 0.0;

  LMonth := MonthOf(ADateTime);

  for i := 0 to FElecPowerCalcCollect.Count - 1 do
  begin
    //계절(월)이 같고
    if FElecPowerCalcCollect.Items[i].FFMonth = LMonth then
    begin
      LStr := FElecPowerCalcCollect.Items[i].BeginTime_S;

      if LStr = '24:00' then
        LStr := '23:59';

      LBeginTime := StrToTime(LStr);

      LStr := FElecPowerCalcCollect.Items[i].EndTime_S;

      if LStr = '24:00' then
        LStr := '23:59';

      LEndTime := StrToTime(LStr);
      //시간대가 같으면
      if TimeInRange(ADateTime, LBeginTime, LEndTime) then
      begin
        Result := FElecPowerCalcCollect.Items[i].Price;
        exit;
      end;
    end;
  end;
end;

procedure TElecPowerCalcBase.GetHourMinute;
var
  i: integer;
begin
  for i := 0 to FElecPowerCalcCollect.Count - 1 do
  begin
    _GetHourMinute(FElecPowerCalcCollect.Items[i].FBeginTime_S,
                  FElecPowerCalcCollect.Items[i].FBeginHour,
                  FElecPowerCalcCollect.Items[i].FBeginMinute);

    _GetHourMinute(FElecPowerCalcCollect.Items[i].FEndTime_S,
                  FElecPowerCalcCollect.Items[i].FEndHour,
                  FElecPowerCalcCollect.Items[i].FEndMinute);
  end;
end;

function TElecPowerCalcBase.GetPrice4UsedkWhAtTime(ADateTime: TDateTime;
  AUsedkWh: double): longint;
var
//  LUsedkWh: double;
  LBasePriceUsedkW: double;
begin
//  LusedkWh := GetUsedkWh(ADateTime);
  LBasePriceUsedkW := GetBasePrice4UsedkWh(ADateTime);

  Result := Round(AUsedkWh * LBasePriceUsedkW);
end;

function TElecPowerCalcBase.GetUsedkWh(AVCB: TVCBNumber): double;
begin
  case AVCB of
    vnVCBG2: Result := FArray_VCBG2kW.Average;
    vnVCBG4: Result := FArray_VCBG4kW.Average;
    vnVCBG5: Result := FArray_VCBF1kW.Average;
    vnVCBG6: Result := FArray_VCBG5kW.Average;
    vnVCBG7: Result := FArray_VCBG6kW.Average;
    vnVCBF1: Result := FArray_VCBF2kW.Average;
    vnVCBF2: Result := FArray_VCBG7AkW.Average;
    vnVCBF3: Result := FArray_VCBF3kW.Average;
    vnInCome1: Result := FArray_InCome1kW.Average;
    vnInCome2: Result := FArray_InCome2kW.Average;
    vnInCome3: Result := FArray_InCome3kW.Average;
  end;
end;

procedure TElecPowerCalcBase.ResetkWh(var AkWhVar: double; AValue: double);
begin
  AkWhVar := AValue;
end;

procedure TElecPowerCalcBase.ResetkWhAll(AYear, AMonth, ADay: word);
begin
  FkWhRecord.FYear := AYear;
  FkWhRecord.FMonth := AMonth;
  FkWhRecord.FDay := ADay;

  ResetkWh(FkWhRecord.FVCBG2kWh);
  ResetkWh(FkWhRecord.FACBG4kWh);
  ResetkWh(FkWhRecord.FVCBF1kWh);
  ResetkWh(FkWhRecord.FVCBG5kWh);
  ResetkWh(FkWhRecord.FVCBG6kWh);
  ResetkWh(FkWhRecord.FVCBF2kWh);
  ResetkWh(FkWhRecord.FVCBG7AkWh);
  ResetkWh(FkWhRecord.FVCBF3kWh);
  ResetkWh(FkWhRecord.FInCome1kWh);
  ResetkWh(FkWhRecord.FInCome2kWh);
  ResetkWh(FkWhRecord.FInCome3kWh);
end;

procedure TElecPowerCalcBase.SetVCBF1kW(AValue: double);
begin
  FArray_VCBF1kW.Put(AValue);
  SetVCBF1kWh(AValue);
end;

//AValue: 현재 kW 값
procedure TElecPowerCalcBase.SetVCBF1kWh(AValue: double);
begin
  FkWhRecord.FVCBF1kWh := FkWhRecord.FVCBF1kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetVCBF2kW(AValue: double);
begin
  FArray_VCBF2kW.Put(AValue);
  SetVCBF2kWh(AValue);
end;

procedure TElecPowerCalcBase.SetVCBF2kWh(AValue: double);
begin
  FkWhRecord.FVCBF2kWh := FkWhRecord.FVCBF2kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetVCBF3kW(AValue: double);
begin
  FArray_VCBF3kW.Put(AValue);
  SetVCBF3kWh(AValue);
end;

procedure TElecPowerCalcBase.SetVCBF3kWh(AValue: double);
begin
  FkWhRecord.FVCBF3kWh := FkWhRecord.FVCBF3kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetVCBG2kW(AValue: double);
begin
  FArray_VCBG2kW.Put(AValue);
  SetVCBG2kWh(AValue);
end;

procedure TElecPowerCalcBase.SetVCBG2kWh(AValue: double);
begin
  FkWhRecord.FVCBG2kWh := FkWhRecord.FVCBG2kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetACBG4kW(AValue: double);
begin
  FArray_VCBG4kW.Put(AValue);
  SetACBG4kWh(AValue);
end;

procedure TElecPowerCalcBase.SetACBG4kWh(AValue: double);
begin
  FkWhRecord.FACBG4kWh := FkWhRecord.FACBG4kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetInCome1kW(AValue: double);
begin
  FArray_InCome1kW.Put(AValue);
  SetInCome1kWh(AValue);
end;

procedure TElecPowerCalcBase.SetInCome1kWh(AValue: double);
begin
  FkWhRecord.FInCome1kWh := FkWhRecord.FInCome1kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetInCome2kW(AValue: double);
begin
  FArray_InCome2kW.Put(AValue);
  SetInCome2kWh(AValue);
end;

procedure TElecPowerCalcBase.SetInCome2kWh(AValue: double);
begin
  FkWhRecord.FInCome2kWh := FkWhRecord.FInCome2kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetInCome3kW(AValue: double);
begin
  FArray_InCome3kW.Put(AValue);
  SetInCome3kWh(AValue);
end;

procedure TElecPowerCalcBase.SetInCome3kWh(AValue: double);
begin
  FkWhRecord.FInCome3kWh := FkWhRecord.FInCome3kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetkWhFromDoc(ADoc: Variant);
begin
//  ADoc.
end;

procedure TElecPowerCalcBase.SetVCBG5kW(AValue: double);
begin
  FArray_VCBG5kW.Put(AValue);
  SetVCBG5kWh(AValue);
end;

procedure TElecPowerCalcBase.SetVCBG5kWh(AValue: double);
begin
  FkWhRecord.FVCBG5kWh := FkWhRecord.FVCBG5kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetVCBG6kW(AValue: double);
begin
  FArray_VCBG6kW.Put(AValue);
  SetVCBG6kWh(AValue);
end;

procedure TElecPowerCalcBase.SetVCBG6kWh(AValue: double);
begin
  FkWhRecord.FVCBG6kWh := FkWhRecord.FVCBG6kWh + AValue/3600;
end;

procedure TElecPowerCalcBase.SetVCBG7AkW(AValue: double);
begin
  FArray_VCBG7AkW.Put(AValue);
  SetVCBG7AkWh(AValue);
end;

procedure TElecPowerCalcBase.SetVCBG7AkWh(AValue: double);
begin
  FkWhRecord.FVCBG7AkWh := FkWhRecord.FVCBG7AkWh + AValue/3600;
end;

procedure TElecPowerCalcBase._GetHourMinute(ATime: string; var AHour,
  AMin: word);
var
  LDateTime: TDateTime;
  LSec, LMSec: word;
begin
  LDateTime := StrToTime(ATime);
  DecodeTime(LDateTime, AHour, AMin, LSec, LMSec);
end;

end.
