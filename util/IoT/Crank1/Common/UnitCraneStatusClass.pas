unit UnitCraneStatusClass;

interface

uses Classes, System.SysUtils, Generics.Legacy, BaseConfigCollect,
  SynCommons;//OtlTaskControl

const
  CraneNameAry : array [0..4] of string = ( //크랑크 1공장 크레인 리스트
    '801','802','804','225','300'
    );

const
  __TCraneRunStatusRecord_DynArr =
  'Xpos_DynArr array of string Ypos_DynArr array of string Weight_DynArr array of string LastUpdated_DynArr array of TDateTime';

type
  TCraneRunStatusRecord = packed record
    Xpos_DynArr: array of string;
    Ypos_DynArr: array of string;
    Weight_DynArr: array of string;
    LastUpdated_DynArr: array of TDateTime;
  end;

  TCraneStatusItem = class(TCollectionItem)
  private
    FCraneName,
    FCraneDesc,
    FXPos,
    FYPos,
    FWeight: string;
    FCommComponent,
    FCraneNoComponent: TComponent;
    FLastUpdatedDate: TDateTime;
    FCommConnected: Boolean;
  public
//    property OnUpdateCommStatus: TVpTimerTriggerEvent read FOnUpdateCommStatus write FOnUpdateCommStatus;
    procedure AssignTo(Dest: TPersistent); override;
    function SetCommConnected(AExpiredSec: integer): Boolean;
  published
    property CraneName: string read FCraneName write FCraneName;
    property CraneDesc: string read FCraneDesc write FCraneDesc;
    //'0' : stop, '1': run
    property XPos: string read FXPos write FXPos;
    property YPos: string read FYPos write FYPos;
    property Weight: string read FWeight write FWeight;
    property CommComponent: TComponent read FCommComponent write FCommComponent;
    property CraneNoComponent: TComponent read FCraneNoComponent write FCraneNoComponent;
    property CommConnected: Boolean read FCommConnected write FCommConnected;
    property LastUpdatedDate: TDateTime read FLastUpdatedDate write FLastUpdatedDate;
  end;

  TCraneStatusCollect<T: TCraneStatusItem> = class(Generics.Legacy.TCollection<T>)
  public
    procedure GetCommStatusCraneList(ACollect: TCraneStatusCollect<TCraneStatusItem>;
      ACommConnected: Boolean);
    procedure UpdateCommConnected(AExpiredSec: integer);
    function GetDisconnectedCraneCount: integer;
  end;

  TCraneStatusInfo = class(TpjhBase)
  private
    FCraneStatusCollect: TCraneStatusCollect<TCraneStatusItem>;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
    procedure InitCraneStatusInfo;
  published
    function GetCollectIndex(ACraneName: string): integer;
    procedure SetCraneStatus2Collect(ACraneName, AStatus: string);
    procedure SetCollectFromRecord(ARecord: TCraneRunStatusRecord);

    property CraneStatusCollect: TCraneStatusCollect<TCraneStatusItem> read FCraneStatusCollect write FCraneStatusCollect;
  end;

implementation

uses System.DateUtils, mORMot;

procedure TCraneStatusInfo.Clear;
begin

end;

constructor TCraneStatusInfo.Create(AOwner: TComponent);
begin
  FCraneStatusCollect := TCraneStatusCollect<TCraneStatusItem>.Create;
end;

destructor TCraneStatusInfo.Destroy;
begin
  FCraneStatusCollect.Free;

  inherited;
end;

function TCraneStatusInfo.GetCollectIndex(ACraneName: string): integer;
var
  i: integer;
  LESItem: TCraneStatusItem;
begin
  Result := -1;

  for i := 0 to CraneStatusCollect.Count - 1 do
  begin
    LESItem := CraneStatusCollect.Items[i];
    if LESItem.CraneName = ACraneName then
    begin
      Result := i;
      break;
    end;
  end;
end;

procedure TCraneStatusInfo.InitCraneStatusInfo;
var
  LCSItem: TCraneStatusItem;
  i: integer;
begin
  CraneStatusCollect.Clear;

  for i := Low(CraneNameAry) to High(CraneNameAry) do
  begin
    LCSItem := CraneStatusCollect.Add;
    LCSItem.CraneName := CraneNameAry[i];
  end;
end;

procedure TCraneStatusInfo.SetCollectFromRecord(ARecord: TCraneRunStatusRecord);
var
  i: integer;
  LCSItem: TCraneStatusItem;
begin
  for i := Low(ARecord.XPos_DynArr) to High(ARecord.XPos_DynArr) do
  begin
    LCSItem := CraneStatusCollect.Items[i];

    if ARecord.LastUpdated_DynArr[i] > IncYear(now, -100) then
    begin
      LCSItem.LastUpdatedDate := ARecord.LastUpdated_DynArr[i];
    end;

    //통신 연결이 되어 있을 경우에만 내용을 갱신함
    //3분간(150초) 데이터가 없으면 통신 두절로 간주함
    if LCSItem.SetCommConnected(150) then
    begin
      LCSItem.XPos := ARecord.XPos_DynArr[i];
      LCSItem.YPos := ARecord.YPos_DynArr[i];
      LCSItem.Weight := ARecord.Weight_DynArr[i];
    end;
  end;

  //3분간(150초) 데이터가 없으면 통신 두절로 간주함
//  CraneStatusCollect.UpdateCommConnected(150);
end;

procedure TCraneStatusInfo.SetCraneStatus2Collect(ACraneName, AStatus: string);
var
  i: integer;
  LCSItem: TCraneStatusItem;
  LStrList: TStringList;
  LStr: string;
begin
  i := GetCollectIndex(ACraneName);

  if i <> -1 then
  begin
    LStrList := TStringList.Create;
    try
      //AStatus  : Y=22.42&X=5.45&W=3.60 형태로 들어옴
      ExtractStrings(['&'], [], PChar(AStatus), LStrList);

      if LStrList.Count > 2 then
      begin
        LCSItem := CraneStatusCollect.Items[i];
        LStr := LStrList.Strings[0]; //Y=22.42
        LCSItem.YPos := StringReplace(LStr, 'Y=', '', [rfReplaceAll]);
        LStr := LStrList.Strings[1]; //X=5.45
        LCSItem.XPos := StringReplace(LStr, 'X=', '', [rfReplaceAll]);
        LStr := LStrList.Strings[2]; //W=3.60
        LCSItem.Weight := StringReplace(LStr, 'W=', '', [rfReplaceAll]);
        LCSItem.LastUpdatedDate := now;
      end;
    finally
    LStrList.Free;
    end;
  end;
end;

{ TTimerTask }

//procedure TTimerTask.OnTimer;
//begin
//
//end;

{ TCraneStatusCollect<T> }

procedure TCraneStatusCollect<T>.GetCommStatusCraneList(
  ACollect: TCraneStatusCollect<TCraneStatusItem>; ACommConnected: Boolean);
//ACommConnected = True 이면 통신 연결된 장비 리스트 반납
//ACommConnected = False 이면 통신 끊긴 장비 리스트 반납
var
  i: integer;
  LESItem: TCraneStatusItem;
begin
  for i := 0 to Count - 1 do
  begin
    if TCraneStatusItem(Items[i]).CommConnected = ACommConnected then
    begin
      LESItem := ACollect.Add;
      TCraneStatusItem(Items[i]).AssignTo(LESItem);
    end;
  end;
end;

function TCraneStatusCollect<T>.GetDisconnectedCraneCount: integer;
var
  i: integer;
begin
  Result := 0;

  for i := 0 to Count - 1 do
    if not TCraneStatusItem(Items[i]).CommConnected then
      Inc(Result);
end;

procedure TCraneStatusCollect<T>.UpdateCommConnected(AExpiredSec: integer);
//AExpiredSec(초) 이전에 LastUpdatedDate 되었으면 통신 두절로 간주
var
  i: integer;
  LESItem: TCraneStatusItem;
begin
  for i := 0 to Count - 1 do
  begin
    TCraneStatusItem(Items[i]).CommConnected :=
      IncSecond(now, -AExpiredSec) < TCraneStatusItem(Items[i]).LastUpdatedDate;
  end;
end;

{ TCraneStatusItem }

procedure TCraneStatusItem.AssignTo(Dest: TPersistent);
begin
  inherited;

  CopyObject(Self, Dest);
end;

function TCraneStatusItem.SetCommConnected(AExpiredSec: integer): boolean;
begin
  FCommConnected := IncSecond(now, -AExpiredSec) < LastUpdatedDate;
  Result := FCommConnected;
end;

initialization
  TTextWriter.RegisterCustomJSONSerializerFromText(
    TypeInfo(TCraneRunStatusRecord), __TCraneRunStatusRecord_DynArr);

end.
