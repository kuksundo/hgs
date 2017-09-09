unit UnitAlarmCollect;

interface

uses System.Classes, mORMot, SynCommons, BaseConfigCollect;

type
  TLampColor = (lcRed, lcYellow, lcGreen);
  TLampType = (LtOff, ltOn, ltBlink);
  TSoundType = (siNone, siFire, siEmergency, siAmbulance, siPiPi);

  TAlarmCollect = class;
  TAlarmItem = class;

  TAlarmList = class(TpjhBase)
  private
    FAlarmCollect: TAlarmCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property AlarmCollect: TAlarmCollect read FAlarmCollect write FAlarmCollect;
  end;

  TAlarmItem = class(TCollectionItem)
  private
    FAlarmName: RawUTF8;  //TagName
    FAlarmIndex: integer; //TagIndex(NextGrid Row Index와 동일함)
    FBitIndex: integer; //Value의 n번째 값이 해당 Alarm일 경우(-1: 쓰이지 않을 경우)
    FAlarmDesc: RawUTF8;
    FAlarmType: RawUTF8;
    FAlarmValue: RawUTF8;
    FMinAlarmEnable: Boolean; //아래 변수들 사용 여부
    FMaxAlarmEnable: Boolean; //
    FMinFaultEnable: Boolean;
    FMaxFaultEnable: Boolean;
    FMinAlarmValue: double; //Fault보다 낮은 레벨
    FMaxAlarmValue: double; //
    FMinFaultValue: double;
    FMaxFaultValue: double;
    FLampColor: TLampColor;
    FLampType: TLampType;
    FSoundType: TSoundType;
    FDuration: integer;
    FUnitID: RawUTF8;
  published
    property AlarmName: RawUTF8 read FAlarmName write FAlarmName;
    property AlarmIndex: integer read FAlarmIndex write FAlarmIndex;
    property BitIndex: integer read FBitIndex write FBitIndex;
    property AlarmDesc: RawUTF8 read FAlarmDesc write FAlarmDesc;
    property AlarmType: RawUTF8 read FAlarmType write FAlarmType;
    property AlarmValue: RawUTF8 read FAlarmValue write FAlarmValue;
    property MinAlarmEnable: Boolean read FMinAlarmEnable write FMinAlarmEnable default false;
    property MaxAlarmEnable: Boolean read FMaxAlarmEnable write FMaxAlarmEnable default false;
    property MinFaultEnable: Boolean read FMinFaultEnable write FMinFaultEnable default false;
    property MaxFaultEnable: Boolean read FMaxFaultEnable write FMaxFaultEnable default false;
    property MinAlarmValue: double read FMinAlarmValue write FMinAlarmValue;
    property MinFaultValue: double read FMinFaultValue write FMinFaultValue;
    property MaxAlarmValue: double read FMaxAlarmValue write FMaxAlarmValue;
    property MaxFaultValue: double read FMaxFaultValue write FMaxFaultValue;
    property LampColor: TLampColor read FLampColor write FLampColor;
    property LampType: TLampType read FLampType write FLampType;
    property SoundType: TSoundType read FSoundType write FSoundType;
    property Duration: integer read FDuration write FDuration;
    property UnitID: RawUTF8 read FUnitID write FUnitID;
  end;

  TAlarmCollect = class(TInterfacedCollection)
  private
    function GetCollItem(aIndex: Integer): TAlarmItem;
  protected
    class function GetClass: TCollectionItemClass; override;
  public
    function Add: TAlarmItem;
    property Item[Index: Integer]: TAlarmItem read GetCollItem; default;
  end;

implementation

{ TAlarmItems }

function TAlarmCollect.Add: TAlarmItem;
begin
  result := TAlarmItem(inherited Add);
end;

class function TAlarmCollect.GetClass: TCollectionItemClass;
begin
  result := TAlarmItem;
end;

function TAlarmCollect.GetCollItem(aIndex: Integer): TAlarmItem;
begin
  result := TAlarmItem(GetItem(aIndex));
end;

{ TAlarmList }

constructor TAlarmList.Create(AOwner: TComponent);
begin
  FAlarmCollect := TAlarmCollect.Create();
end;

destructor TAlarmList.Destroy;
begin
  inherited Destroy;

  FAlarmCollect.Free;
end;

end.
