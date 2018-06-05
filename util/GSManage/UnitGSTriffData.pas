unit UnitGSTriffData;

interface

uses System.Classes, System.SysUtils, System.StrUtils, Vcl.StdCtrls;

type
  TGSEngineerType = (gsetNull, gsetTechnician, gsetServiceEngineer, gsetSE_Elec,
    gsetSE_AMS_PMS, gsetSuperintendent, gsetFinal);
  TGSWorkDayType = (gswdtNull, gswdtNormalDay, gswdtHoliDay, gswdtFinal);
  TGSWorkHourType = (gswhtNull, gswhtFullDay, gswhtHalfDay, gswhtOverTime, gswhtFinal);
  TGSWorkType = (gswtNull, gswtWorking, gswtTravelAndWait, gswtFinal);

const
  R_GSEngineerType : array[gsetNull..gsetFinal] of record
    Description : string;
    Value       : TGSEngineerType;
  end = ((Description : '';                         Value : gsetNull),
         (Description : 'Technician';               Value : gsetTechnician),
         (Description : 'Service Engineer';         Value : gsetServiceEngineer),
         (Description : 'Service Engineer(Elec.)';  Value : gsetSE_Elec),
         (Description : 'Service Engineer(AMS,PMS)';Value : gsetSE_AMS_PMS),
         (Description : 'Superintendent';   Value : gsetSuperintendent),
         (Description : '';                         Value : gsetFinal)
         );

  R_GSWorkDayType : array[gswdtNull..gswdtFinal] of record
    Description : string;
    Value       : TGSWorkDayType;
  end = ((Description : '';                         Value : gswdtNull),
         (Description : 'Normal Day';               Value : gswdtNormalDay),
         (Description : 'Holiday';                  Value : gswdtHoliDay),
         (Description : '';                         Value : gswdtFinal)
         );

  R_GSWorkHourType : array[gswhtNull..gswhtFinal] of record
    Description : string;
    Value       : TGSWorkHourType;
  end = ((Description : '';                   Value : gswhtNull),
         (Description : 'Full Day(4~8 hrs)';  Value : gswhtFullDay),
         (Description : 'Half Day(0~4 hrs)';  Value : gswhtHalfDay),
         (Description : 'Over Time(Hourly)';  Value : gswhtOverTime),
         (Description : '';                   Value : gswhtFinal)
         );

  R_GSWorkType : array[gswtNull..gswtFinal] of record
    Description : string;
    Value       : TGSWorkType;
  end = ((Description : '';                      Value : gswtNull),
         (Description : 'Working';               Value : gswtWorking),
         (Description : 'Travelling and Waiting';Value : gswtTravelAndWait),
         (Description : '';                      Value : gswtFinal)
         );

  GSTariff_DailyAllowance = 70;
  GSTariff_CancellationCharge = 800;
  GSTariff_ExpeditingCharge = 1.3;

function GSEngineerType2String(AGSEngineerType:TGSEngineerType) : string;
function String2GSEngineerType(AGSEngineerType:string): TGSEngineerType;
procedure GSEngineerType2Combo(AComboBox:TComboBox);

function GSWorkDayType2String(AGSWorkDayType:TGSWorkDayType) : string;
function String2GSWorkDayType(AGSWorkDayType:string): TGSWorkDayType;
procedure GSWorkDayType2Combo(AComboBox:TComboBox);

function GSWorkHourType2String(AGSWorkHourType:TGSWorkHourType) : string;
function String2GSWorkHourType(AGSWorkHourType:string): TGSWorkHourType;
procedure GSWorkHourType2Combo(AComboBox:TComboBox);

function GSWorkType2String(AGSWorkType:TGSWorkType) : string;
function String2GSWorkType(AGSWorkType:string): TGSWorkType;
procedure GSWorkType2Combo(AComboBox:TComboBox);

implementation

function GSEngineerType2String(AGSEngineerType:TGSEngineerType) : string;
begin
  if AGSEngineerType <= High(TGSEngineerType) then
    Result := R_GSEngineerType[AGSEngineerType].Description;
end;

function String2GSEngineerType(AGSEngineerType:string): TGSEngineerType;
var Li: TGSEngineerType;
begin
  for Li := gsetNull to gsetFinal do
  begin
    if R_GSEngineerType[Li].Description = AGSEngineerType then
    begin
      Result := R_GSEngineerType[Li].Value;
      exit;
    end;
  end;
end;

procedure GSEngineerType2Combo(AComboBox:TComboBox);
var Li: TGSEngineerType;
begin
  AComboBox.Clear;

  for Li := gsetNull to Pred(gsetFinal) do
  begin
    AComboBox.Items.Add(R_GSEngineerType[Li].Description);
  end;
end;

function GSWorkDayType2String(AGSWorkDayType:TGSWorkDayType) : string;
begin
  if AGSWorkDayType <= High(TGSWorkDayType) then
    Result := R_GSWorkDayType[AGSWorkDayType].Description;
end;

function String2GSWorkDayType(AGSWorkDayType:string): TGSWorkDayType;
var Li: TGSWorkDayType;
begin
  for Li := gswdtNull to gswdtFinal do
  begin
    if R_GSWorkDayType[Li].Description = AGSWorkDayType then
    begin
      Result := R_GSWorkDayType[Li].Value;
      exit;
    end;
  end;
end;

procedure GSWorkDayType2Combo(AComboBox:TComboBox);
var Li: TGSWorkDayType;
begin
  AComboBox.Clear;

  for Li := gswdtNull to Pred(gswdtFinal) do
  begin
    AComboBox.Items.Add(R_GSWorkDayType[Li].Description);
  end;
end;

function GSWorkHourType2String(AGSWorkHourType:TGSWorkHourType) : string;
begin
  if AGSWorkHourType <= High(TGSWorkHourType) then
    Result := R_GSWorkHourType[AGSWorkHourType].Description;
end;

function String2GSWorkHourType(AGSWorkHourType:string): TGSWorkHourType;
var Li: TGSWorkHourType;
begin
  for Li := gswhtNull to gswhtFinal do
  begin
    if R_GSWorkHourType[Li].Description = AGSWorkHourType then
    begin
      Result := R_GSWorkHourType[Li].Value;
      exit;
    end;
  end;
end;

procedure GSWorkHourType2Combo(AComboBox:TComboBox);
var Li: TGSWorkHourType;
begin
  AComboBox.Clear;

  for Li := gswhtNull to Pred(gswhtFinal) do
  begin
    AComboBox.Items.Add(R_GSWorkHourType[Li].Description);
  end;
end;

function GSWorkType2String(AGSWorkType:TGSWorkType) : string;
begin
  if AGSWorkType <= High(TGSWorkType) then
    Result := R_GSWorkType[AGSWorkType].Description;
end;

function String2GSWorkType(AGSWorkType:string): TGSWorkType;
var Li: TGSWorkType;
begin
  for Li := gswtNull to gswtFinal do
  begin
    if R_GSWorkType[Li].Description = AGSWorkType then
    begin
      Result := R_GSWorkType[Li].Value;
      exit;
    end;
  end;
end;

procedure GSWorkType2Combo(AComboBox:TComboBox);
var Li: TGSWorkType;
begin
  AComboBox.Clear;

  for Li := gswtNull to Pred(gswtFinal) do
  begin
    AComboBox.Items.Add(R_GSWorkType[Li].Description);
  end;
end;

end.
