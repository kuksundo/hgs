unit EngineConst;

interface

uses Windows, Classes, StdCtrls, System.SysUtils,
  NxPropertyItemClasses, System.TypInfo, System.Rtti;

type
  TCylinderConfiguration = (ccInline, ccVtype);
  TEngineUsage = (euMainEngine, euAuxEngine, euGenSet, euPropulse);
  TFuelType = (ftOil, ftGas, ftDF, ftCR);
  EEngineBasePersist = class(Exception);

const
  PiOn4 = 0.78539816339744830961566084581988; // PI / 4
  K_AirFlow = 0.49224;//Air Flow Nozzle Dia(380) Constant

  no2wet = 0; //NO2 Concentration (WET) (ppm)
  cwet = 0; //Soot in wet Exhaust (㎎/㎥)

  //-------------- Default Variables Exhaust Air Flow Calc -------------------

  //Standard air composition, volume basis
  n2air  = 78.09; //Standard Air Composition N2  (%, v/v)
  o2air  = 20.95; //Standard Air Composition O2  (%, v/v)
  co2air =  0.03; //Standard Air Composition CO2 (%, v/v)
  arair  =  0.93; //Standard Air Composition Ar  (%, v/v)

  //Physical constants
  awh  =  1.00794; //Atomic weight of H
  awc  = 12.011; //Atomic weight of C
  aws  = 32.060; //Atomic weight of S
  awn  = 14.007; //Atomic weight of N
  awo  = 15.999; //Atomic weight of O
  awar = 39.948; //Atomic weight of Ar

  awch4 = 16.04276;//Weight of CH4(1*awc + 4*awh)
  awc2h6 = 30.06964;//Weight of C2H6(2*awc + 6*awh)
  awc3h8 = 44.09652;//Weight of C3H8(3*awc + 8*awh)
  awc4h10 = 58.1234;//Weight of C4H10(4*awc + 10*awh)
  awc5h12 = 72.15028;//Weight of C5H12(5*awc + 12*awh)


  mvh2o = 21.100; //Molecular Volume of H2O (l/mol)
  mvco2 = 22.261; //Molecular Volume of CO2 (l/mol)
  mvco  = 22.400; //Molecular Volume of CO  (l/mol)
  mvso2 = 21.856; //Molecular Volume of SO2 (l/mol)
  mvo2  = 22.392; //Molecular Volume of O2  (l/mol)
  mvhc  = 20.906; //Molecular Volume of HC  (l/mol)
  mvno  = 22.390; //Molecular Volume of NO  (l/mol)
  mvno2 = 22.141; //Molecular Volume of NO2 (l/mol)
  mvn2  = 22.403; //Molecular Volume of N2  (l/mol)
  mvar  = 22.400; //Molecular Volume of Ar  (l/mol)
  mvair = 22.400; //Molecular Volume of AIR (l/mol)
  mvch4 = 22.400; //Molecular Volume of CH4 (l/mol)

  mwh2o = 18.015;    //Molecular Weight of H2O (g/mol)
  mwco2 = 44.010;    //Molecular Weight of CO2 (g/mol)
  mwco  = awc + awo; //Molecular Weight of CO  (g/mol)
  mwso2 = 64.059;    //Molecular Weight of SO2 (g/mol)
  mwno  = awn + awo; //Molecular Weight of NO  (g/mol)
  mwno2 = 48.006;    //Molecular Weight of NO2 (g/mol)
  mwo2  = 31.999;    //Molecular Weight of O2  (g/mol)
  mwn2  = 28.013;    //Molecular Weight of N2  (g/mol)
  mwar  = awar;      //Molecular Weight of Ar  (g/mol)
  mwair = 28.963;    //Molecular Weight of Air (g/mol)

  CylinderConfigurationCOUNT = integer(High(TCylinderConfiguration))+1;
  R_CylinderConfiguration : array[0..CylinderConfigurationCOUNT-1] of record
    Description : string;
    Value       : TCylinderConfiguration;
    DispName: string;
  end = ((Description : 'Inline'; Value : ccInline; DispName: ''),
         (Description : 'V-Type'; Value : ccVtype; DispName: 'V'));

  FuelTypeCOUNT = integer(High(TFuelType))+1;
  R_FuelType : array[0..FuelTypeCOUNT-1] of record
    Description : string;
    Value       : TFuelType;
    DispName: string;
  end = ((Description : 'Oil'; Value : ftOil; DispName: ''),
         (Description : 'Gas'; Value : ftGas; DispName: 'G'),
         (Description : 'Duel Fuel'; Value : ftDF; DispName: 'DF'),
         (Description : 'Common Rail'; Value : ftCR; DispName: 'CR'));

  function CylinderConfiguration2DispName(ACylinderConfiguration:TCylinderConfiguration) : string;
  function CylinderConfiguration2String(ACylinderConfiguration:TCylinderConfiguration) : string;
  function DispName2CylinderConfiguration(ACylinderConfiguration:string): TCylinderConfiguration;
  function String2CylinderConfiguration(ACylinderConfiguration:string): TCylinderConfiguration;
  procedure FillCylinderConfiguration2NxCombo(ACombo: TNxComboBoxItem);

  function FuelType2DispName(AFuelType:TFuelType) : string;
  function FuelType2String(AFuelType:TFuelType) : string;
  function DispName2FuelType(AFuelType:string): TFuelType;
  function String2FuelType(AFuelType:string): TFuelType;
  procedure FillFuelType2NxCombo(ACombo: TNxComboBoxItem);

  function GetPropertyNameValueList(AObj: TObject): TStringList;
  procedure RttiSetValue(aData : String;var aValue : TValue; aTypeKind: TTypeKind = TTypeKind(0));

implementation

function CylinderConfiguration2DispName(ACylinderConfiguration:TCylinderConfiguration) : string;
begin
  Result := R_CylinderConfiguration[ord(ACylinderConfiguration)].DispName;
end;

function CylinderConfiguration2String(ACylinderConfiguration:TCylinderConfiguration) : string;
begin
  Result := R_CylinderConfiguration[ord(ACylinderConfiguration)].Description;
end;

function DispName2CylinderConfiguration(ACylinderConfiguration:string): TCylinderConfiguration;
var Li: integer;
begin
  for Li := 0 to CylinderConfigurationCOUNT - 1 do
  begin
    if R_CylinderConfiguration[Li].DispName = ACylinderConfiguration then
    begin
      Result := R_CylinderConfiguration[Li].Value;
      exit;
    end;
  end;
end;

function String2CylinderConfiguration(ACylinderConfiguration:string): TCylinderConfiguration;
var Li: integer;
begin
  for Li := 0 to CylinderConfigurationCOUNT - 1 do
  begin
    if R_CylinderConfiguration[Li].Description = ACylinderConfiguration then
    begin
      Result := R_CylinderConfiguration[Li].Value;
      exit;
    end;
  end;
end;

procedure FillCylinderConfiguration2NxCombo(ACombo: TNxComboBoxItem);
var Li: integer;
begin
  for Li := 0 to CylinderConfigurationCOUNT - 1 do
    ACombo.Lines.Add(R_CylinderConfiguration[Li].Description);
end;

function FuelType2DispName(AFuelType:TFuelType) : string;
begin
  Result := R_FuelType[ord(AFuelType)].DispName;
end;

function FuelType2String(AFuelType:TFuelType) : string;
begin
  Result := R_FuelType[ord(AFuelType)].Description;
end;

function DispName2FuelType(AFuelType:string): TFuelType;
var Li: integer;
begin
  for Li := 0 to FuelTypeCOUNT - 1 do
  begin
    if R_FuelType[Li].DispName = AFuelType then
    begin
      Result := R_FuelType[Li].Value;
      exit;
    end;
  end;
end;

function String2FuelType(AFuelType:string): TFuelType;
var Li: integer;
begin
  for Li := 0 to FuelTypeCOUNT - 1 do
  begin
    if R_FuelType[Li].Description = AFuelType then
    begin
      Result := R_FuelType[Li].Value;
      exit;
    end;
  end;
end;

procedure FillFuelType2NxCombo(ACombo: TNxComboBoxItem);
var Li: integer;
begin
  for Li := 0 to FuelTypeCOUNT - 1 do
    ACombo.Lines.Add(R_FuelType[Li].Description);
end;

function GetPropertyNameValueList(AObj: TObject): TStringList;
var //Name=Value로 반환함
  ctx: TRttiContext;
  rt: TRttiType;
  Prop: TRttiProperty;
//  Value: TValue;
begin
  Result := TStringList.Create;
  ctx := TRttiContext.Create;
  try
    rt := ctx.GetType(AObj.ClassType);

    for prop in rt.GetProperties do
    begin
      Result.Add(prop.Name + '=' + prop.GetValue(AObj).ToString);
    end;
  finally
    ctx.Free;
  end;
end;

procedure RttiSetValue(aData: String; var aValue: TValue; aTypeKind: TTypeKind = TTypeKind(0));
var
 I : Integer;
 LKind: TTypeKind;
begin
  if aTypeKind <> TTypeKind(0) then
    LKind := aTypeKind
  else
    LKind := aValue.Kind;

  case LKind of
   tkWChar,
   tkLString,
   tkWString,
   tkString,
   tkChar,
   tkUString : aValue := aData;
   tkInteger,
   tkInt64  : aValue := StrToInt(aData);
   tkFloat  : aValue := StrToFloat(aData);
   tkEnumeration:  aValue := TValue.FromOrdinal(aValue.TypeInfo,GetEnumValue(aValue.TypeInfo,aData));
   tkSet: begin
             i :=  StringToSet(aValue.TypeInfo,aData);
             TValue.Make(@i, aValue.TypeInfo, aValue);
          end;
   else raise EEngineBasePersist.Create('Type not Supported');
  end;
end;

end.
