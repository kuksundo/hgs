unit ScheduleClass;

interface

uses classes, SysUtils, ExtCtrls, Vcl.Graphics, , Generics.Legacy, BaseConfigCollect;

type
  TpjhDay = (Mon=1, Tue, Wed, Thu, Fri, Sat, Sun);
  TpjhWeekDays = Mon..Fri;
  TpjhWeekend  = Sat..Sun;
  TpjhNotifyDays = set of TpjhDay;

  TNotifyTerminal = (ntNone, ntDesktop, ntMobile);
  TNotifyTerminals = set of TNotifyTerminal;

  TScheduleRunType = (srtRunOnce, srtMiliSecondly, srtSecondly, srtMinutely,
    srtHourly, srtDaily, srtWeekly, srtMonthly, strYearly);

  TRunOnDays = set of (roSunday, roMonday, roTuesday, roWednesday, roThursday,
    roFriday, roSaturday);

  TScheduleItem = class;
  TScheduleCollect<T: TScheduleItem> = class(Generics.Legacy.TCollection<T>)
  end;

  TScheduleList = class(TpjhBase)
  private
    FScheduleCollect: TScheduleCollect<TScheduleItem>;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    function CheckDayOfMonth(var ADay: integer): Boolean;
    function CheckDayOfWeek(ADay: TRunOnDays): Boolean;
  published
    property ScheduleCollect: TScheduleCollect<TScheduleItem> read FScheduleCollect write FScheduleCollect;
  end;

  PScheduleItem = ^TScheduleItem;
  TScheduleItem = class(TCollectionItem)
  private
    FRunOnDays: TRunOnDays; //FScheduleType = srtWeekly 일경우 실행할 요일 집합
    FRunOnWeeks: integer;  //FScheduleType = srtMonthly 일경우 실행할 주 : (1-5)
                           //FScheduleType = strYearly 일경우 실행할 주 : (1-53)
    FScheduleType: TScheduleRunType;
    FLastRunDate: TDateTime;  //Date the schedule was last run
    FMinDayOfMonth,           //Don't run before this day of month(1-31)
    FMaxDayOfMonth: integer;  //Don't run after this day of month(1-31)

    FIsPrivate,         //비공개
    FIsEveryWeek,       //매주
    FIsEveryMonth,      //매월
    FIsAllDay: Boolean; //하루종일

    FNotifyDays: TpjhNotifyDays;
    FDuration: word; //지속시간(mSec)
    FBeginTime, FEndTime: TDateTime;

  public
    FIsRunNow: Boolean;

    procedure Assign(Source: TPersistent); override;
  published
    property RunOnDays: TRunOnDays read FRunOnDays write FRunOnDays;
    property ScheduleType: TScheduleRunType read FScheduleType write FScheduleType;
    property LastRunDate: TDateTime read FLastRunDate write FLastRunDate;
    property MinDayOfMonth: integer read FMinDayOfMonth write FMinDayOfMonth;
    property MaxDayOfMonth: integer read FMaxDayOfMonth write FMaxDayOfMonth;
    property RunOnWeeks: integer read FRunOnWeeks write FRunOnWeeks;

    property IsPrivate: Boolean read FIsPrivate write FIsPrivate;
    property IsEveryWeek: Boolean read FIsEveryWeek write FIsEveryWeek;
    property IsEveryMonth: Boolean read FIsEveryMonth write FIsEveryMonth;
    property IsAllDay: Boolean read FIsAllDay write FIsAllDay;
    property BeginTime: TDateTime read FBeginTime write FBeginTime;
    property EndTime: TDateTime read FEndTime write FEndTime;
    property Duration: word read FDuration write FDuration;
    property NotifyDays: TpjhNotifyDays read FNotifyDays write FNotifyDays;
  end;

implementation

function NotifyDaySetToInteger(ss : TpjhNotifyDays) : integer;
var intset : TIntegerSet;
    s : TpjhDay;
begin
  intSet := [];
  for s in ss do
    include(intSet, ord(s));
  result := integer(intSet);
end;

function IntegerToNotifyDaySet(mask : integer) : TpjhNotifyDays;
var intSet : TIntegerSet;
    b : byte;
begin
  intSet := TIntegerSet(mask);
  result := [];
  for b in intSet do
    include(result, TpjhDay(b));
end;

function TScheduleList.CheckDayOfMonth(var ADay: integer): Boolean;
var
  LDay, LMonth, LYear: word;
begin
  DecodeDate(Date, LYear, LMonth, LDay);

  if ADay < 1 then
    ADay := 1;

  if ADay > 31 then
    ADay := 31;

  Result := True;
end;

function TScheduleList.CheckDayOfWeek(ADay: TRunOnDays): Boolean;
var
  LDay: integer;
begin
  Result := False;
  LDay := DayOfWeek(Date);

  case LDay of
    1: Result := roSunday in ADay;
    2: Result := roMonday in ADay;
    3: Result := roTuesday in ADay;
    4: Result := roWednesday in ADay;
    5: Result := roThursday in ADay;
    6: Result := roFriday in ADay;
    7: Result := roSaturday in ADay;
  end;
end;

constructor TScheduleList.Create(AOwner: TComponent);
begin
  FScheduleCollect := TScheduleCollect<TScheduleItem>.Create;
end;

destructor TScheduleList.Destroy;
begin
  inherited Destroy;
  FScheduleCollect.Free;
end;

{ TScheduleItem }

procedure TScheduleItem.Assign(Source: TPersistent);
begin
  if Source is TScheduleItem then
  begin
{    AppTitle := TScheduleItem(Source).AppTitle;
    AppPath := TScheduleItem(Source).AppPath;
    AppDesc := TScheduleItem(Source).AppDesc;
    AppImage := TScheduleItem(Source).AppImage;
    AppDisableImage := TScheduleItem(Source).AppDisableImage;
    RunParameter := TScheduleItem(Source).RunParameter;
    IsSchedule := TScheduleItem(Source).IsSchedule;
    IsRelativePath := TScheduleItem(Source).IsRelativePath;
    AppHandle := TScheduleItem(Source).AppHandle;
    DisableTimerHandle := TScheduleItem(Source).DisableTimerHandle;
    TileIndex := TScheduleItem(Source).TileIndex;
}
  end
  else
    inherited;
end;

end.
