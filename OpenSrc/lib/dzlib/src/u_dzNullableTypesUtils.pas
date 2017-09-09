unit u_dzNullableTypesUtils;

interface

uses
  SysUtils;

type
  EInvalidValue = class(Exception);

type
  PFormatSettings = ^TFormatSettings;

///<summary>
/// This returns the user's default format settings, which are initialized by a call to
/// GetUserDefaultLocaleSettings on startup. </summary>
function UserLocaleFormatSettings: PFormatSettings;

procedure StrToNumber(const _s: string; out _Value: Integer); overload;
procedure StrToNumber(const _s: string; out _Value: Single); overload;
procedure StrToNumber(const _s: string; out _Value: Double); overload;
procedure StrToNumber(const _s: string; out _Value: Extended); overload;

function TryStrToNumber(const _s: string; out _Value: Integer; const _FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToNumber(const _s: string; out _Value: Int64; const _FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToNumber(const _s: string; out _Value: Single; const _FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToNumber(const _s: string; out _Value: Double; const _FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToNumber(const _s: string; out _Value: Extended; const _FormatSettings: TFormatSettings): Boolean; overload;

function NumberToStr(_Value: Integer): string; overload;
function NumberToStr(_Value: Single): string; overload;
function NumberToStr(_Value: Double): string; overload;
function NumberToStr(_Value: Extended): string; overload;

function TryVar2Number(const _v: Variant; out _Value: Integer): Boolean; overload;
function TryVar2Number(const _v: Variant; out _Value: Int64): Boolean; overload;
function TryVar2Number(const _v: Variant; out _Value: Single): Boolean; overload;
function TryVar2Number(const _v: Variant; out _Value: Double): Boolean; overload;
function TryVar2Number(const _v: Variant; out _Value: Extended): Boolean; overload;

function GetNullableTypesFlagInterface: IInterface;

procedure DivideNumbers(_a, _b: Integer; out _Value: Integer); overload;
procedure DivideNumbers(_a, _b: Int64; out _Value: Int64); overload;
procedure DivideNumbers(_a, _b: Single; out _Value: Single); overload;
procedure DivideNumbers(_a, _b: Double; out _Value: Double); overload;
procedure DivideNumbers(_a, _b: Extended; out _Value: Extended); overload;

implementation

uses
  u_dzVariantUtils,
  u_dzStringUtils;

// this is a fake interfaced object that only exists as the VMT
// It can still be used to trick the compiler into believing an interface pointer is assigned

function NopAddref(inst: Pointer): Integer; stdcall;
begin
  Result := -1;
end;

function NopRelease(inst: Pointer): Integer; stdcall;
begin
  Result := -1;
end;

function NopQueryInterface(inst: Pointer; const IID: TGUID; out Obj): HResult; stdcall;
begin
  Result := E_NOINTERFACE;
end;

const
  FlagInterfaceVTable: array[0..2] of Pointer =
    (
    @NopQueryInterface,
    @NopAddref,
    @NopRelease
    );
const
  FlagInterfaceInstance: Pointer = @FlagInterfaceVTable;

function GetNullableTypesFlagInterface: IInterface;
begin
  Result := IInterface(@FlagInterfaceInstance);
end;

var
  gblUserLocaleFormatSettings: TFormatSettings;

function UserLocaleFormatSettings: PFormatSettings;
begin
  Result := @gblUserLocaleFormatSettings;
end;

// StrToNumber

procedure StrToNumber(const _s: string; out _Value: Integer);
begin
  _Value := StrToInt(_s);
end;

procedure StrToNumber(const _s: string; out _Value: Single);
begin
  _Value := StrToFloat(_s);
end;

procedure StrToNumber(const _s: string; out _Value: Double);
begin
  _Value := StrToFloat(_s);
end;

procedure StrToNumber(const _s: string; out _Value: Extended);
begin
  _Value := StrToFloat(_s);
end;

// TryStrToNumber

function TryStrToNumber(const _s: string; out _Value: Integer; const _FormatSettings: TFormatSettings): Boolean;
begin
  Result := TryStrToInt(_s, _Value);
end;

function TryStrToNumber(const _s: string; out _Value: Int64; const _FormatSettings: TFormatSettings): Boolean;
begin
  Result := TryStrToInt64(_s, _Value);
end;

function TryStrToNumber(const _s: string; out _Value: Single; const _FormatSettings: TFormatSettings): Boolean;
begin
  Result := TryStrToFloat(_s, _Value, _FormatSettings);
end;

function TryStrToNumber(const _s: string; out _Value: Double; const _FormatSettings: TFormatSettings): Boolean;
begin
  Result := TryStrToFloat(_s, _Value, _FormatSettings);
end;

function TryStrToNumber(const _s: string; out _Value: Extended; const _FormatSettings: TFormatSettings): Boolean;
begin
  Result := TryStrToFloat(_s, _Value, _FormatSettings);
end;

// NumberToStr

function NumberToStr(_Value: Integer): string;
begin
  Result := IntToStr(_Value);
end;

function NumberToStr(_Value: Single): string;
begin
  Result := FloatToStr(_Value);
end;

function NumberToStr(_Value: Double): string;
begin
  Result := FloatToStr(_Value);
end;

function NumberToStr(_Value: Extended): string;
begin
  Result := FloatToStr(_Value);
end;

// TryVar2Number

function TryVar2Number(const _v: Variant; out _Value: Integer): Boolean;
begin
  Result := TryVar2Int(_v, _Value);
end;

function TryVar2Number(const _v: Variant; out _Value: Int64): Boolean;
begin
  Result := TryVar2Int64(_v, _Value);
end;

function TryVar2Number(const _v: Variant; out _Value: Single): Boolean;
begin
  Result := TryVar2Single(_v, _Value);
end;

function TryVar2Number(const _v: Variant; out _Value: Double): Boolean;
begin
  Result := TryVar2Dbl(_v, _Value);
end;

function TryVar2Number(const _v: Variant; out _Value: Extended): Boolean;
begin
  Result := TryVar2Ext(_v, _Value);
end;

procedure DivideNumbers(_a, _b: Integer; out _Value: Integer);
begin
  _Value := _a div _b;
end;

procedure DivideNumbers(_a, _b: Int64; out _Value: Int64);
begin
  _Value := _a div _b;
end;

procedure DivideNumbers(_a, _b: Single; out _Value: Single);
begin
  _Value := _a / _b;
end;

procedure DivideNumbers(_a, _b: Double; out _Value: Double);
begin
  _Value := _a / _b;
end;

procedure DivideNumbers(_a, _b: Extended; out _Value: Extended);
begin
  _Value := _a / _b;
end;

initialization
  gblUserLocaleFormatSettings := GetUserDefaultLocaleSettings;
end.

