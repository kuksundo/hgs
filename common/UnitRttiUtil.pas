unit UnitRttiUtil;

interface

uses SysUtils,Classes, Rtti, TypInfo,
  SynCommons;

function GetValue(var aValue : TValue) : String;
procedure SetValue(aData : String; var aValue : TValue; aTypeKind: TTypeKind = TTypeKind(0));
procedure LoadRecordPropertyFromVariant(ASQLRecord: TObject; const ADoc: Variant);
procedure LoadRecordPropertyToVariant(const ASQLRecord: TObject; var ADoc: Variant);

implementation

function GetValue(var aValue : TValue) : String;
var
 I : Integer;
begin
   if aValue.Kind in [tkWChar, tkLString, tkWString, tkString, tkChar,
                    tkUString, tkInteger, tkInt64, tkFloat, tkEnumeration,
                    tkSet]  then
   result := aValue.ToString
   else raise Exception.Create('Type not Supported');
end;

procedure SetValue(aData: String; var aValue : TValue; aTypeKind: TTypeKind = TTypeKind(0));
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
   tkInt64  : aValue := StrToIntDef(aData,0);
   tkFloat  : aValue := StrToFloatDef(aData,0);
   tkEnumeration:  aValue := TValue.FromOrdinal(aValue.TypeInfo,GetEnumValue(aValue.TypeInfo,aData));
   tkSet: begin
             i :=  StringToSet(aValue.TypeInfo,aData);
             TValue.Make(@i, aValue.TypeInfo, aValue);
          end;
   else raise Exception.Create('Type not Supported');
  end;
end;

procedure LoadRecordPropertyFromVariant(ASQLRecord: TObject; const ADoc: Variant);
var
 ctx : TRttiContext;
 objType : TRttiType;
 Field : TRttiField;
 Prop  : TRttiProperty;
 Value : TValue;
 Data, LPropName : String;
// LVar: variant;
begin
  ctx := TRttiContext.Create;
  try
    objType := ctx.GetType(ASQLRecord.ClassInfo);

    for Prop in objType.GetProperties do
    begin
      if not Prop.IsWritable then
        continue;

      LPropName := Prop.Name;

      if (LPropName = 'IDValue') or (LPropName = 'InternalState') then
        continue;

//      LVar := TDocVariantData(ADoc).GetValueOrNull(Prop.Name);
      Data := TDocVariantData(ADoc).GetValueOrEmpty(LPropName);
      Value := Prop.GetValue(ASQLRecord);
      SetValue(Data, Value);
      Prop.SetValue(ASQLRecord,Value);
    end;

//    for Field in objType.GetFields do
//    begin
//      Value := Field.GetValue(ASQLRecord);
//      SetValue(Data,Value);
//      Field.SetValue(ASQLRecord,Value);
//    end;
  finally
    ctx.Free;
  end;
end;

procedure LoadRecordPropertyToVariant(const ASQLRecord: TObject; var ADoc: Variant);
var
 ctx : TRttiContext;
 objType : TRttiType;
 Field : TRttiField;
 Prop  : TRttiProperty;
 Value : TValue;
 LPropName : String;
begin
  ctx := TRttiContext.Create;
  try
    objType := ctx.GetType(ASQLRecord.ClassInfo);

    for Prop in objType.GetProperties do
    begin
      if not Prop.IsWritable then
        continue;

      LPropName := Prop.Name;

      if (LPropName = 'IDValue') or (LPropName = 'InternalState') then
        continue;

      Value := Prop.GetValue(ASQLRecord);
      TDocVariantData(ADoc).Value[LPropName] := Value.AsVariant;
    end;
  finally
    ctx.Free;
  end;
end;

end.
