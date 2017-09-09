unit MathClass;

interface
type
  // In this example, Note the Value property and parameters of
  // many of the methods are value, which could lead to bugs (as desired)
  // as this is a unit testing example
  TMath = class(TObject)
  private
    FValue: Double;
    procedure SetValue(const Value: Double);
  public
    procedure Add(Value : Double);
    procedure Divide(Value : Double);
    procedure Multiply(Value : Double);
    procedure Subtract(Value : Double);
    procedure DoubleIt;
    procedure Truncate;
  published
    property Value : Double read FValue write SetValue;
  end;

implementation

{ TMath }

procedure TMath.Add(Value: Double);
begin
  FValue := FValue + Value;
end;

procedure TMath.Divide(Value: Double);
begin
  FValue := FValue / Value;
end;

procedure TMath.DoubleIt;
begin
  FValue := FValue * 2;
end;

procedure TMath.Multiply(Value: Double);
begin
  FValue := FValue * Value;
end;

procedure TMath.SetValue(const Value: Double);
begin
  FValue := Value;
end;

procedure TMath.Subtract(Value: Double);
begin
  FValue := FValue - Value;
end;

procedure TMath.Truncate;
begin
 FValue := Trunc(FValue);
end;

end.
