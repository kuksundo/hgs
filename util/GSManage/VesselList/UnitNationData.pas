unit UnitNationData;

interface

uses System.Classes, System.SysUtils, System.StrUtils, Vcl.StdCtrls;

type
  T7Continent = (c7Null, c7Asia, c7Africa, c7NorthAmerica, c7SouthAmerica,
    c7Antarctica, c7Europe, c7Australia, c7Final);

const
  R_7Continent : array[c7Null..c7Final] of record
    Description : string;
    Value       : T7Continent;
  end = ((Description : '';             Value : c7Null),
         (Description : 'ASIA';         Value : c7Asia),
         (Description : 'AFRICA';       Value : c7Africa),
         (Description : 'North America';Value : c7NorthAmerica),
         (Description : 'South America';Value : c7SouthAmerica),
         (Description : 'Antarctica';   Value : c7Antarctica),
         (Description : 'Europe';       Value : c7Europe),
         (Description : 'Australia';    Value : c7Australia),
         (Description : '';             Value : c7Final)
         );

function ContinentType2String(A7Continent:T7Continent) : string;
function String2ContinentType(A7Continent:string): T7Continent;
procedure ContinentType2Combo(AComboBox:TComboBox);

implementation

function ContinentType2String(A7Continent:T7Continent) : string;
begin
  if A7Continent <= High(T7Continent) then
    Result := R_7Continent[A7Continent].Description;
end;

function String2ContinentType(A7Continent:string): T7Continent;
var Li: T7Continent;
begin
  for Li := c7Null to c7Final do
  begin
    if R_7Continent[Li].Description = A7Continent then
    begin
      Result := R_7Continent[Li].Value;
      exit;
    end;
  end;
end;

procedure ContinentType2Combo(AComboBox:TComboBox);
var Li: T7Continent;
begin
  AComboBox.Clear;

  for Li := c7Null to Pred(c7Final) do
  begin
    AComboBox.Items.Add(R_7Continent[Li].Description);
  end;
end;

end.
