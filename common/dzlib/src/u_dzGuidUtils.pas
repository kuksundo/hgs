unit u_dzGuidUtils;

interface

uses
  SysUtils,
  u_dzTranslator,
  u_dzNullableTypesUtils;

type
  TNullableGuid = record
  private
    FValue: TGuid;
    FIsValid: IInterface;
    procedure DeclareValid; inline;
  public
    ///<summary> Generates a new GUID using WinAPI calls </summary>
    procedure GenerateNew;
    ///<summary> convert to a variant for using for database fields / parameters) </summary>
    function ToVariant: Variant;
    ///<summary> convert from a variant for assigning a database field </summary>
    function AssignVariant(_v: Variant): boolean;
    ///<summary> explicit cast to string "string(GUID)" converts to standard string form </summary>
    class operator Explicit(_a: TNullableGuid): string;
    ///<summary> explicit cast converts from standard string form </summary>
    class operator Explicit(const _a: string): TNullableGuid;
    ///<summary> compares two NullableGuids, returns true, if the are equal, raises exception if one
    ///          is not valid </summary>
    class operator Equal(_a, _b: TNullableGuid): boolean;
    ///<summary> compares two NullableGuids, returns truw if they are different or at least one is invalid </summary>
    class operator NotEqual(_a, _b: TNullableGuid): boolean;
    ///<summary> implicit conversion from TGUID </summary>
    class operator Implicit(_a: TGUID): TNullableGuid;
    ///<summary> returns the GUID, if valid, raises an exception otherwise </summary>
    function Value: TGuid;
    ///<summary> returns true, if valid, false otherwise </summary>
    function IsValid: boolean;
    ///<summary> invalidates the GUID </summary>
    procedure Invalidate;
    ///<summary> returns a new, valid GUID </summary>
    class function Invalid: TNullableGuid; static;
    class function Generate: TNullableGuid; static;
    class function FromVariant(_v: Variant): TNullableGuid; static;
    class function FromString(const _s: string): TNullableGuid; static;
  end;

///<summary> Tries to convert a string to a GUID, returns true if successfull </summary>
function TryStr2GUID(const _s: string; out _GUID: TGUID): boolean;
///<summary> Tries to convert a variant to a GUID, returns true if successfull </summary>
function TryVar2GUID(const _v: variant; out _GUID: TGUID): boolean;

implementation

uses
  u_dzVariantUtils,
  ActiveX;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

function TryStr2GUID(const _s: string; out _GUID: TGUID): boolean;
begin
  Result := Succeeded(CLSIDFromString(PWideChar(WideString(_s)), _GUID));
end;

function TryVar2GUID(const _v: variant; out _GUID: TGUID): boolean;
var
  s: string;
begin
  Result := TryVar2Str(_v, s);
  if Result then
    Result := TryStr2GUID(s, _GUID);
end;

{ TNullableGuid }

function TNullableGuid.AssignVariant(_v: Variant): boolean;
begin
  Result := TryVar2GUID(_v, FValue);
  if Result then
    DeclareValid
  else
    Invalidate;
end;

function TNullableGuid.ToVariant: Variant;
begin
  Result := string(Self);
end;

function TNullableGuid.Value: TGuid;
begin
  if not IsValid then
    raise Exception.Create('TNullableGuid is not valid');
  Result := FValue;
end;

class function TNullableGuid.Invalid: TNullableGuid;
begin
  Result.Invalidate;
end;

procedure TNullableGuid.Invalidate;
begin
  FIsValid := nil;
end;

procedure TNullableGuid.DeclareValid;
begin
  FIsValid := GetNullableTypesFlagInterface;
end;

class operator TNullableGuid.Equal(_a, _b: TNullableGuid): boolean;
begin
  Result := IsEqualGUID(_a.Value, _b.Value);
end;

class operator TNullableGuid.NotEqual(_a, _b: TNullableGuid): boolean;
begin
  if _a.IsValid and _b.IsValid then
    Result := not IsEqualGUID(_a.Value, _b.Value)
  else
    Result := _a.IsValid or _b.IsValid;
end;

class operator TNullableGuid.Explicit(const _a: string): TNullableGuid;
begin
  if _a = '' then
    Result.Invalidate
  else
    Result := StringToGUID(_a);
end;

class function TNullableGuid.FromString(const _s: string): TNullableGuid;
var
  gd: TGUID;
begin
  if not TryStr2GUID(_s, gd) then
    if not TryStr2GUID('{' + _s + '}', gd) then
      raise Exception.CreateFmt('NullableGuid.FromString: ' + _('"%s" is no valid GUID'), [_s]);
  Result := gd;
end;

class function TNullableGuid.FromVariant(_v: Variant): TNullableGuid;
begin
  Result.AssignVariant(_V);
end;

class operator TNullableGuid.Explicit(_a: TNullableGuid): string;
begin
  if _a.IsValid then
    Result := GUIDToString(_a.FValue)
  else
    Result := '';
end;

class function TNullableGuid.Generate: TNullableGuid;
begin
  Result.GenerateNew;
end;

procedure TNullableGuid.GenerateNew;
begin
  if Succeeded(CreateGUID(FValue)) then
    DeclareValid
  else
    Invalidate;
end;

class operator TNullableGuid.Implicit(_a: TGUID): TNullableGuid;
begin
  Result.FValue := _a;
  Result.DeclareValid;
end;

function TNullableGuid.IsValid: boolean;
begin
  Result := Assigned(FIsValid);
end;

end.

