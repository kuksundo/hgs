{사용법:
  1. Config Form의 Control.hint = SectionName;KeyName 으로 저장 함
    1) Ini 값을 Config Form(AForm)에 Load시 호출:
      FSettings.LoadConfig2Form(AForm, FSettings);
    2) Config Form의 내용을 Ini에 Save 시 호출:
      FSettings.LoadConfigForm2Object(AForm, FSettings);
  2. TIniPersist를 수정하여 Create시에 Component Name을 입력 받아서 동일 기능 구현 할 것
}
unit UnitConfigIniClass;

interface

uses SysUtils, Vcl.Controls, Forms, Rtti, TypInfo, IniPersist;

type
  TINIConfigBase = class (TObject)
  private
    FIniFileName: string;
  public
    constructor create(AFileName: string);

    property IniFileName : String read FIniFileName write FIniFileName;

    procedure Save(AFileName: string = '');
    procedure Load(AFileName: string = '');

    procedure LoadConfig2Form(AForm: TForm; ASettings: TObject);
    procedure LoadConfigForm2Object(AForm: TForm; ASettings: TObject);
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

{ TINIConfigBase }

constructor TINIConfigBase.create(AFileName: string);
begin
  FIniFileName := AFileName;
end;

procedure TINIConfigBase.Load(AFileName: string);
begin
  if AFileName = '' then
    AFileName := FIniFileName;

  TIniPersist.Load(AFileName, Self);
end;

//Component의 Hint에 SectionName;KeyName 으로 저장되어 있어야 함
procedure TINIConfigBase.LoadConfig2Form(AForm: TForm; ASettings: TObject);
var
  ctx, ctx2 : TRttiContext;
  objType, objType2 : TRttiType;
  Field : TRttiField;
  Prop, Prop2  : TRttiProperty;
  Value : TValue;
  IniValue : IniValueAttribute;
  Data : String;
  LControl: TControl;

  i: integer;
  LStr, LSection, LKeyName: string;
begin
  ctx := TRttiContext.Create;
  ctx2 := TRttiContext.Create;
  try
    objType2 := ctx2.GetType(ASettings.ClassInfo);

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);
      objType := ctx.GetType(LControl.ClassInfo);

      Prop := nil;
      Prop := objType.GetProperty('Caption');

      if not Assigned(Prop) then
        Prop := objType.GetProperty('Text');    //For TEdit

      if not Assigned(Prop) then
        Prop := objType.GetProperty('Value');

      if Assigned(Prop) then
      begin
        LStr := LControl.Hint;

        if LStr = '' then
          Continue;

        LSection := strToken(LStr, ';');
        LKeyName := strToken(LStr, ';');

        for Prop2 in objType2.GetProperties do
        begin
          IniValue := TIniPersist.GetIniAttribute(Prop2);

          if Assigned(IniValue) then
          begin
            if SameText(IniValue.Section, LSection) and SameText(IniValue.Name, LKeyName) then
            begin
              Value := Prop2.GetValue(ASettings);
              Data := TIniPersist.GetValue(Value);
              Prop.SetValue(LControl, Data);
              break;
            end;
          end;
        end;
      end;
    end;
 finally
   ctx.Free;
   ctx2.Free;
 end;
end;

procedure TINIConfigBase.LoadConfigForm2Object(AForm: TForm; ASettings: TObject);
var
  ctx, ctx2 : TRttiContext;
  objType, objType2 : TRttiType;
  Field : TRttiField;
  Prop, Prop2  : TRttiProperty;
  Value : TValue;
  IniValue : IniValueAttribute;
  Data : String;
  LControl: TControl;

  i: integer;
  LStr, LSection, LKeyName: string;
begin
  ctx := TRttiContext.Create;
  ctx2 := TRttiContext.Create;
  try
    objType2 := ctx2.GetType(ASettings.ClassInfo);

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      LControl := TControl(AForm.Components[i]);
      objType := ctx.GetType(LControl.ClassInfo);

      Prop := nil;
      Prop := objType.GetProperty('Caption');

      if not Assigned(Prop) then
        Prop := objType.GetProperty('Text');

      if not Assigned(Prop) then
        Prop := objType.GetProperty('Value');

      if Assigned(Prop) then
      begin
        LStr := LControl.Hint;
        LSection := strToken(LStr, ';');
        LKeyName := strToken(LStr, ';');

        for Prop2 in objType2.GetProperties do
        begin
          IniValue := TIniPersist.GetIniAttribute(Prop2);

          if Assigned(IniValue) then
          begin
            if SameText(IniValue.Section, LSection) and SameText(IniValue.Name, LKeyName) then
            begin
              Value := Prop.GetValue(LControl);
              Data := TIniPersist.GetValue(Value);
              TIniPersist.SetValue(Data, Value, Prop2.PropertyType.TypeKind);
              Prop2.SetValue(ASettings, Value);
              break;
            end;
          end;
        end;
      end;
    end;
  finally
   ctx.Free;
   ctx2.Free;
  end;
end;

procedure TINIConfigBase.Save(AFileName: string);
begin
  if AFileName = '' then
    AFileName := FIniFileName;

  // This saves the properties to the INI
  TIniPersist.Save(AFileName ,Self);
end;

end.
