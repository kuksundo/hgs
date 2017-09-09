unit CustomDateTimeUtils;

{$mode objfpc}{$H+}

interface

uses SysUtils;

function DateTimeToUnixMSecs(const AValue: TDateTime; const ToUTC: Boolean): Int64;
function UnixMSecsToDateTime(const AValue: Int64): TDateTime;
function TimeZoneBiasMSecs: Integer;
function GetTimeZoneStr: String;

implementation

uses  dateutils
{$IFDEF MSWINDOWS}, windows {$ENDIF}
{$IFDEF UNIX},Unix, BaseUnix, unixutil {$ENDIF};

function DateTimeToUnixMSecs(const AValue: TDateTime; const ToUTC: Boolean): Int64;
begin
  Result := Round((AValue - UnixDateDelta) * MSecsPerDay);
  if ToUTC then
  begin
   Result := Result + TimeZoneBiasMSecs;
  end;
end;

function TimeZoneBiasMSecs: Integer;
{$IFDEF MSWINDOWS}
var TZ: TTimeZoneInformation;
{$ENDIF}
{$IFDEF UNIX}
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
   GetTimeZoneInformation(TZ);
   Result := TZ.Bias * SecsPerMin * MSecsPerSec;
  {$ENDIF}
  {$IFDEF UNIX}
   ReadTimezoneFile(GetTimezoneFile);
   GetLocalTimezone(fptime);
   Result := (Tzseconds * MSecsPerSec);
  {$ENDIF}
end;

function GetTimeZoneStr: String;
{$IFDEF MSWINDOWS}
var TZ: TTimeZoneInformation;
    TempPlus : string;
{$ENDIF}
{$IFDEF UNIX}
var  TempPlus : string;
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
   GetTimeZoneInformation(TZ);
   if TZ.Bias > 0 then TempPlus := '+'
    else TempPlus := '-';
   Result := Format('UTC%s%d',[TempPlus,TZ.Bias div 60]) ;
  {$ENDIF}
  {$IFDEF UNIX}
  if Tzseconds = 0 then
   begin
    ReadTimezoneFile(GetTimezoneFile);
    GetLocalTimezone(fptime);
   end;
  if Tzseconds > 0 then TempPlus := '+'
   else TempPlus := '-';
   Result :=  Format('UTC%s%d',[TempPlus,Tzseconds div 3600]);
  {$ENDIF}
end;

function UnixMSecsToDateTime(const AValue: Int64): TDateTime;
begin
  Result := AValue / SecsPerDay + UnixDateDelta;
end;

end.
