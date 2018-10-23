unit UnitRedemptionUtil;

interface

uses ComObj, Variants;

function GetActiveRedemptionSession(AVisible: boolean) : Variant;

implementation

function GetActiveRedemptionSession(AVisible: boolean) : Variant;
begin
  try
    Result := GetActiveOleObject('Redemption.RDOSession');
  except
    Result := CreateOleObject('Redemption.RDOSession');
    if VarIsNull(Result) = false then
    begin
      Result.Visible := AVisible;
    end;
  end;
end;

end.
