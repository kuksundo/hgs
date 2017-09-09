{ sdDwgProperties

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdDwgProperties;

interface

uses
  sdDwgFormat, sdDwgBitReader, sdDwgTypesAndConsts;

type

  TDwgIntProp = class(TDwgProperty)
  private
    FValue: integer;
  protected
    function GetAsInteger: integer; override;
    procedure SetAsInteger(const Value: integer); override;
    function Load(R: TDwgBitReader; Method: TDwgStorageMethod): boolean; override;
  end;

  TDwgFloatProp = class(TDwgProperty)
  private
    FValue: double;
  protected
    function GetAsFloat: double; override;
    procedure SetAsFloat(const Value: double); override;
    function Load(R: TDwgBitReader; Method: TDwgStorageMethod): boolean; override;
  end;

  TDwgHandleProp = class(TDwgProperty)
  private
    FValue: TDwgHandle;
  protected
    function GetAsHandle: TDwgHandle; override;
    procedure SetAsHandle(const Value: TDwgHandle); override;
    function Load(R: TDwgBitReader; Method: TDwgStorageMethod): boolean; override;
  end;

  TDwgPropertyGroup = record
    GroupId: integer;              // DXF group Id
    ClassType: TDwgPropertyClass;  // Property class
  end;

const

  // List of constants describing property groups
  cPropType         =   0;
  cPropHandle       =   5;
  cPropLType        =   6;
  cPropLayer        =   8;
  cPropLTypeScale   =  48;
  cPropInvisibility =  60;
  cPropColor        =  62;
  cPropLineWeight   = 370;

  // List of default property groups
  cPropertyGroupCount = 8;
  cPropertyGroups: array[0..cPropertyGroupCount - 1] of TDwgPropertyGroup =
   ( (GroupId: cPropType;          ClassType: TDwgIntProp),
     (GroupId: cPropHandle;        ClassType: TDwgHandleProp),
     (GroupId: cPropLType;         ClassType: TDwgHandleProp),
     (GroupId: cPropLayer;         ClassType: TDwgHandleProp),
     (GroupId: cPropLTypeScale;    ClassType: TDwgFloatProp),
     (GroupId: cPropInvisibility;  ClassType: TDwgIntProp),
     (GroupId: cPropColor;         ClassType: TDwgIntProp),
     (GroupId: cPropLineWeight;    ClassType: TDwgIntProp)
   );

implementation

{ TDwgIntProp }

function TDwgIntProp.GetAsInteger: integer;
begin
  Result := FValue;
end;

function TDwgIntProp.Load(R: TDwgBitReader; Method: TDwgStorageMethod): boolean;
begin
  Result := True;
  case Method of
  smBS: FValue := R.BS;
  smRC: FValue := R.RC;
  else
    Result := False;
  end;
end;

procedure TDwgIntProp.SetAsInteger(const Value: integer);
begin
  FValue := Value;
end;

{ TDwgFloatProp }

function TDwgFloatProp.GetAsFloat: double;
begin
  Result := FValue;
end;

function TDwgFloatProp.Load(R: TDwgBitReader; Method: TDwgStorageMethod): boolean;
begin
  Result := True;
  case Method of
  smBD: FValue := R.BD;
  else
    Result := False;
  end;
end;

procedure TDwgFloatProp.SetAsFloat(const Value: double);
begin
  FValue := Value;
end;

{ TDwgHandleProp }

function TDwgHandleProp.GetAsHandle: TDwgHandle;
begin
  Result := FValue;
end;

function TDwgHandleProp.Load(R: TDwgBitReader; Method: TDwgStorageMethod): boolean;
begin
  Result := True;
  case Method of
  smH: FValue := R.H;
  else
    Result := False;
  end;
end;

procedure TDwgHandleProp.SetAsHandle(const Value: TDwgHandle);
begin
  FValue := Value;
end;

end.
