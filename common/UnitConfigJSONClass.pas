{사용법:
  1. Config Form의 Control.hint = 값이 저장 되는 필드명(예: Caption 또는 Value 또는 Text)을 저장 함
    1) Ini 값을 Config Form(AForm)에 Load시 호출:
      FSettings.LoadConfig2Form(AForm, FSettings);
    2) Config Form의 내용을 Ini에 Save 시 호출:
      FSettings.LoadConfigForm2Object(AForm, FSettings);
}
unit UnitConfigJSONClass;

interface

uses SysUtils, Vcl.Controls, Classes, Forms, Rtti, TypInfo, JSONPersist;

type
  TJSONConfigBase = class (TJSONPersist)
  private
    FJSONFileName: string;
  public
    constructor create(AFileName: string);

    property JSONFileName : String read FJSONFileName write FJSONFileName;

    procedure LoadConfig2Form(AForm: TForm; ASettings: TObject; AItemIndex: integer = -1);
    procedure LoadConfigForm2Object(AForm: TForm; ASettings: TObject; AItemIndex: integer = -1);
  end;

implementation

function strToken(var S: String; Seperator: Char): String;
var
  I: Word;
begin
  I:=Pos(Seperator,S);
  if I<>0 then
  begin
    Result:=System.Copy(S,1,I-1);
    System.Delete(S,1,I);
  end else
  begin
    Result:=S;
    S:='';
  end;
end;

{ TJSONConfigBase }

constructor TJSONConfigBase.create(AFileName: string);
begin
  FJSONFileName := AFileName;
end;

//Property Attribute에 component name이 기록 됨
//AForm: 환경설정 폼
//ASettings: 환경설정 Class 변수(TCollection이 주로 사용 됨)
procedure TJSONConfigBase.LoadConfig2Form(AForm: TForm; ASettings: TObject;
  AItemIndex: integer);
var
  ctx, ctx2 : TRttiContext;
  LComponentType, LConfigClassType : TRttiType;
  ComponentProp, ConfigProp  : TRttiProperty;
  Value : TValue;
  AttrValue : JSON2ComponentAttribute;
  LControl: TControl;

  i, j, LTagNo: integer;
  LStrList: TStringList;

  function SetValueFromConfigToComponent(AConfigClass: Pointer): boolean;
  begin
    Result := False;
    LConfigClassType := ctx2.GetType(AConfigClass); //환경 변수 Class

    for ConfigProp in LConfigClassType.GetProperties do
    begin
      AttrValue := GetJSONAttribute(ConfigProp);

      if Assigned(AttrValue) then
      begin
        if AttrValue.ComponentTagNo = LTagNo then
        begin
          Value := ConfigProp.GetValue(ASettings);
          ComponentProp.SetValue(LControl, Value);
          Result := True;
          break;
        end;
      end;
    end;
  end;
begin
  ctx := TRttiContext.Create;
  ctx2 := TRttiContext.Create;
  LStrList := TStringList.Create;//Nested Class일 경우 세미콜론(;)으로 구분됨
  LStrList.Delimiter := ';';
  LStrList.StrictDelimiter := True;
  try
    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);
      LTagNo := LControl.Tag;
      LComponentType := ctx.GetType(LControl.ClassInfo); //환경설정 컴포넌트
      LStrList.Clear;
      LStrList.DelimitedText := LControl.Hint; //Nested Class명 + ;' + Caption 또는 Text 또는 Value

      for j := 0 to LStrList.Count - 1 do
      begin
        ComponentProp := nil;
        ComponentProp := LComponentType.GetProperty(LStrList.Strings[j]);

        if ctx.GetType(ComponentProp.PropertyType.Handle).TypeKind is tkClass then //Nested Class인 경우
          LComponentType := ctx.GetType(ComponentProp.PropertyType.Handle)
        else
          break;
      end; //for j

      if Assigned(ComponentProp) then
      begin
        if ASettings.InheritsFrom(TCollection) then
        begin
//          for k := 0 to TCollection(ASettings).Count - 1 do
//          begin
          if AItemIndex <> -1 then
            if SetValueFromConfigToComponent(TCollection(ASettings).Items[AItemIndex].ClassInfo) then
              break;
//          end;
        end
        else
        if ASettings.InheritsFrom(TCollectionItem) then
        begin
          if SetValueFromConfigToComponent(ASettings.ClassInfo) then
            break;
        end;
      end;
    end; //for i
 finally
   ctx.Free;
   ctx2.Free;
   LStrList.Free;
 end;
end;

procedure TJSONConfigBase.LoadConfigForm2Object(AForm: TForm; ASettings: TObject;
  AItemIndex: integer);
var
  ctx, ctx2 : TRttiContext;
  LComponentType, LConfigClassType : TRttiType;
  ComponentProp, ConfigProp  : TRttiProperty;
  Value : TValue;
  AttrValue : JSON2ComponentAttribute;
  LControl: TControl;

  i, j, LTagNo: integer;
  LStrList: TStringList;

  function SetValueFromComponentToConfig(AConfigClass: Pointer): boolean;
  begin
    Result := False;
    LConfigClassType := ctx2.GetType(AConfigClass); //환경 변수 Class

    for ConfigProp in LConfigClassType.GetProperties do
    begin
      AttrValue := GetJSONAttribute(ConfigProp);

      if Assigned(AttrValue) then
      begin
        if AttrValue.ComponentTagNo = LTagNo then
        begin
          Value := ComponentProp.GetValue(LControl);
          ConfigProp.SetValue(ASettings, Value);
          Result := True;
          break;
        end;
      end;
    end;
  end;
begin
  ctx := TRttiContext.Create;
  ctx2 := TRttiContext.Create;
  LStrList := TStringList.Create;//Nested Class일 경우 세미콜론(;)으로 구분됨
  LStrList.Delimiter := ';';
  LStrList.StrictDelimiter := True;
  try
    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);
      LTagNo := LControl.Tag;
      LComponentType := ctx.GetType(LControl.ClassInfo); //환경설정 폼의 컴포넌트
      LStrList.Clear;
      LStrList.DelimitedText := LControl.Hint; //Nested Class명 + ;' + Caption 또는 Text 또는 Value

      for j := 0 to LStrList.Count - 1 do
      begin
        ComponentProp := nil;
        ComponentProp := LComponentType.GetProperty(LStrList.Strings[j]);

        if ctx.GetType(ComponentProp.PropertyType.Handle).TypeKind is tkClass then //Nested Class인 경우
          LComponentType := ctx.GetType(ComponentProp.PropertyType.Handle)
        else
          break;
      end; //for j

      if Assigned(ComponentProp) then //hint에 기록된 Value가 저장된 필드 속성을 찾았으면 (Text or Caption...)
      begin
        if ASettings.InheritsFrom(TCollection) then
        begin
          if AItemIndex <> -1 then
            if SetValueFromComponentToConfig(TCollection(ASettings).Items[AItemIndex].ClassInfo) then
              break;
        end
        else
        if ASettings.InheritsFrom(TCollectionItem) then
        begin
          if SetValueFromComponentToConfig(ASettings.ClassInfo) then
            break;
        end;
      end;
    end; //for i
  finally
     ctx.Free;
    ctx2.Free;
    LStrList.Free;
  end;
end;

end.
