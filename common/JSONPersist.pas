unit JSONPersist;
// MIT License
//
// Copyright (c) 2015 -
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//
interface

uses SysUtils, Classes, Rtti, TypInfo, BaseConfigCollect;

type
  JSON2ComponentAttribute = class(TCustomAttribute)
  private
    FComponentName: string;
    FComponentTagNo: integer;
  published
     constructor Create(const AComponentName : String; const AComponentTagNo: integer);
     property ComponentName : string read FComponentName write FComponentName;
     property ComponentTagNo : integer read FComponentTagNo write FComponentTagNo;
  end;

  EJSON2Component = class(Exception);

  TJSONPersist = class (TpjhBase)
  private
    class procedure SetValue(aData : String;var aValue : TValue);
    class function GetValue(var aValue : TValue) : String;
  public
    class function GetJSONAttribute(Obj : TRttiObject) : JSON2ComponentAttribute;
    class procedure Load(FileName : String; obj : TObject);
    class procedure Save(FileName : String; obj : TObject);
  end;

implementation

{ TIniValue }

constructor JSON2ComponentAttribute.Create(const AComponentName: String;
  const AComponentTagNo: integer);
begin
  FComponentName := AComponentName;
  FComponentTagNo := AComponentTagNo;
end;

{ TIniPersist }

class function TJSONPersist.GetJSONAttribute(Obj: TRttiObject): JSON2ComponentAttribute;
var
 Attr: TCustomAttribute;
begin
 for Attr in Obj.GetAttributes do
 begin
    if Attr is JSON2ComponentAttribute then
    begin
      exit(JSON2ComponentAttribute(Attr));
    end;
 end;
 result := nil;
end;

class procedure TJSONPersist.Save(FileName: String; obj: TObject);
begin

end;

class procedure TJSONPersist.SetValue(aData: String;var aValue: TValue);
var
 I : Integer;
begin
 case aValue.Kind of
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
   else raise EJSON2Component.Create('Type not Supported');
 end;
end;

class function TJSONPersist.GetValue(var aValue: TValue) : string;
var
 I : Integer;
begin
   if aValue.Kind in [tkWChar, tkLString, tkWString, tkString, tkChar,
                    tkUString, tkInteger, tkInt64, tkFloat, tkEnumeration,
                    tkSet]  then
   result := aValue.ToString
   else raise EJSON2Component.Create('Type not Supported');
end;

class procedure TJSONPersist.Load(FileName: String; obj: TObject);
var
 ctx : TRttiContext;
 objType : TRttiType;
 Field : TRttiField;
 Prop  : TRttiProperty;
 Value : TValue;
 AttributeValue : JSON2ComponentAttribute;
 Data : String;
begin
  ctx := TRttiContext.Create;
  try
   Ini := TIniFile.Create(FileName);
   try
     objType := ctx.GetType(Obj.ClassInfo);
     for Prop in objType.GetProperties do
     begin
       IniValue := GetIniAttribute(Prop);
       if Assigned(IniValue) then
       begin
          Data := Ini.ReadString(IniValue.Section,IniValue.Name,IniValue.DefaultValue);
          Value := Prop.GetValue(Obj);
          SetValue(Data,Value);
          Prop.SetValue(Obj,Value);
       end;
     end;
     for Field in objType.GetFields do
     begin
       IniValue := GetIniAttribute(Field);
       if Assigned(IniValue) then
       begin
          Data := Ini.ReadString(IniValue.Section,IniValue.Name,IniValue.DefaultValue);
          Value := Field.GetValue(Obj);
          SetValue(Data,Value);
          Field.SetValue(Obj,Value);
       end;
     end;
   finally
     Ini.Free;
   end;
  finally
   ctx.Free;
  end;
end;

end.
