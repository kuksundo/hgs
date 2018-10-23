unit UnitPlannerDateHelper;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, System.Types,
      WinApi.Windows, DateUtils, HoliDayCollect;

type
  TPlannerDateHelper = class(TObject)
    procedure PlannerCalendarCellDraw(Sender: TObject; Canvas: TCanvas;
                Day: TDate; Selected, Marked, InMonth: Boolean; Rect: TRect);
    procedure SetPlannerCalDellDraw(AComponent: TComponent);
    procedure SetPlannerCalEvent(AComponent: TComponent);

  public
    FHoliDayList : THoliDayList;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  end;

implementation

uses pjhPlannerDatePicker;

{ TPlannerDateHelper }

constructor TPlannerDateHelper.Create(AOwner: TComponent);
begin
  FHoliDayList := THoliDayList.Create(nil);
end;

destructor TPlannerDateHelper.Destroy;
begin
  FreeAndNil(FHoliDayList);

  inherited;
end;

procedure TPlannerDateHelper.PlannerCalendarCellDraw(Sender: TObject;
  Canvas: TCanvas; Day: TDate; Selected, Marked, InMonth: Boolean; Rect: TRect);
var
  da,mo,ye: word;
  s: string;
begin
  DecodeDate(day, ye, mo, da);
  s := inttostr(da);

  if FHoliDayList.IsHoliday(Day) then
  begin
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Color := clRed;
  end;

  inflateRect(rect,-1,-1);
  DrawText(Canvas.Handle, pchar(s), length(s), rect, DT_CENTER or DT_VCENTER);
end;

procedure TPlannerDateHelper.SetPlannerCalDellDraw(
  AComponent: TComponent);
var
  i: integer;
begin
  for i := 0 to AComponent.ComponentCount - 1 do
  begin
    if AComponent.Components[i] is TpjhPlannerDatePicker then
    begin
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.OnCellDraw := PlannerCalendarCellDraw;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Browsers.PrevYear := False;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Browsers.NextYear := False;
    end;
  end;
end;

procedure TPlannerDateHelper.SetPlannerCalEvent(AComponent: TComponent);
var
  i,j,k: integer;
  LFromDate, LToDate: TDate;
begin
  for i := 0 to AComponent.ComponentCount - 1 do
  begin
    if AComponent.Components[i] is TpjhPlannerDatePicker then
    begin
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.EventDayColor := clRed;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.EventHints := True;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.ShowHint := True;

      for j := 0 to FHoliDayList.HoliDayCollect.Count - 1 do
      begin
        LFromDate := FHoliDayList.HoliDayCollect.Items[j].FromDate;
        LToDate := FHoliDayList.HoliDayCollect.Items[j].ToDate;

        while LFromDate <= LToDate do
        begin
          k := DayOfWeek(LFromDate);

          if (k <> 1) and (k <> 7) then//일요일,토요일이 아닌 경우
          begin
            with TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Events.Add do
            begin
              date := LFromDate;
              hint := FHoliDayList.HoliDayCollect.Items[j].Description;
  //            shape := evsCircle;
              color := clRed;
            end;
          end;

          LFromDate := IncDay(LFromDate);
        end;

      end;

      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Browsers.PrevYear := False;
      TpjhPlannerDatePicker(AComponent.Components[i]).Calendar.Browsers.NextYear := False;
    end;
  end;
end;

end.
