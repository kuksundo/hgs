unit UnitEnumHelper;

interface

uses System.SysUtils, System.TypInfo, System.Rtti, System.Classes, Vcl.StdCtrls,
  UnitSimpleGenericEnum;

Type
//  IEnumerator<T> = interface
//    function GetCurrent: T;
//    function MoveNext: Boolean;
//    property Current: T read GetCurrent;
//  end;
//
//  IEnumerable<T> = interface
//    function GetEnumerator: IEnumerator<T>;
//  end;

//  TLabelledEnumerator<T> = class(TInterfacedObject, IEnumerator<T>)
//  private
//    FIndex: integer;
//    FString: string;
//    function GetCurrent: T;
//  public
//    constructor Create(aString: string);
//    function MoveNext: Boolean;
//    property Current: T read GetCurrent;
//  end;
//
//  TLabelledEnumFactory<T> = class(TInterfacedObject, IEnumerable<T>)
//  private
//    FIndex: integer;
//    FString: string;
//    function GetCurrent: T;
//  public
//    constructor Create(aString: string);
//    function GetEnumerator: IEnumerator<T>;
//  end;

  TEnumRecord<T> = record
    Description : string;
    Value       : T;
  end;

  TLabelledEnum<T> = Record
  private
    R_ : array of TEnumRecord<T>;
  public
    procedure CreateArrayRecord(ALength: integer);
    procedure InitArrayRecord(AStringArr: array of string);

    function ToString(AType: T): string; overload;
    function ToString(AType: integer): string; overload;
    function ToType(AType: string): T; overload;
    function ToType(AType: integer): T; overload;
    function ToOrdinal(AType: T): integer; overload;
    function ToOrdinal(AType: string): integer; overload;
    Function GetTypeLabels(ASkipNull: Boolean = False): TStrings;
    procedure SetType2Combo(ACombo: TComboBox);
    procedure SetType2List(AList: TStringList);
  End;

function SetToInt(const ASet; const ASize: integer): integer;
procedure IntToSet(const AValue: integer; var ASet; const ASize: integer);

implementation

function SetToInt(const ASet; const ASize: integer): integer;
begin
  Move(ASet, Result, ASize);
end;

procedure IntToSet(const AValue: integer; var ASet; const ASize: integer);
begin
  Move(AValue, ASet, ASize);
end;

{ TLabelledEnum<T, R> }

procedure TLabelledEnum<T>.CreateArrayRecord(ALength: integer);
begin
  SetLength(R_, ALength);
end;

function TLabelledEnum<T>.GetTypeLabels(ASkipNull: Boolean): TStrings;
var
  i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := TStringList.Create;

  for i := 0 to LEnumGeneric.Count - 2 do
  begin
    if (ASkipNull) and (i = 0) then
      continue;
    Result.Add(R_[i].Description);
  end;
end;

procedure TLabelledEnum<T>.InitArrayRecord(AStringArr: array of string);
var
  LLength, i: integer;
  LEnumGeneric: TEnumGeneric<T>;
begin
  LLength := Length(AStringArr);
  SetLength(R_, LLength);

  for i := 0 to LLength - 1 do
  begin
    R_[i].Value := LEnumGeneric.Cast(i);
    R_[i].Description := AStringArr[i];
  end;
end;

procedure TLabelledEnum<T>.SetType2Combo(ACombo: TComboBox);
var
  LStrList: TStrings;
begin
  LStrList := GetTypeLabels;
  try
    ACombo.Clear;
    ACombo.Items := LStrList;
  finally
    LStrList.Free;
  end;
end;

procedure TLabelledEnum<T>.SetType2List(AList: TStringList);
var
  LStrList: TStrings;
begin
  LStrList := GetTypeLabels;
  try
    AList.Clear;
    AList.AddStrings(LStrList);
  finally
    LStrList.Free;
  end;
end;

function TLabelledEnum<T>.ToOrdinal(AType: T): integer;
var
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := LEnumGeneric.Ord(AType);
end;

function TLabelledEnum<T>.ToOrdinal(AType: string): integer;
var
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := ToOrdinal(ToType(AType));
end;

function TLabelledEnum<T>.ToString(AType: integer): string;
begin
  Result := R_[AType].Description;
end;

function TLabelledEnum<T>.ToString(AType: T): string;
var
  LEnumGeneric: TEnumGeneric<T>;
  i: integer;
begin
  i := LEnumGeneric.Ord(AType);
  Result := R_[i].Description;
end;

function TLabelledEnum<T>.ToType(AType: integer): T;
var
  LEnumGeneric: TEnumGeneric<T>;
begin
  Result := LEnumGeneric.Cast(AType);
end;

function TLabelledEnum<T>.ToType(AType: string): T;
var
  LLength, i: integer;
begin
  LLength := Length(R_);

  for i := 0 to LLength - 1 do
  begin
    if SameText(R_[i].Description, AType) then
    begin
      Result := R_[i].Value;
      Break;
    end;
  end;

end;

end.
