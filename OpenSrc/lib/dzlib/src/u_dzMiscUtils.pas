{.GXFormatter.config=twm}
///<summary>
/// Implements commonly used functions.
/// This unit implements some commonly used functions.
///<br/>
/// There is also a NotImplemend procedure which should be called
/// whereever some features are left out to be implemented "later"
/// This procedure will not be available when we compile the
/// shipping code (no DEBUG symbol), so the compiler should
/// complain if it is still used by then.
/// <br>
/// Note: String functions have been moved to dzStringUtils
/// Note: Variant functions have been moved to dzVariantUtils
/// @author twm
///</summary>

unit u_dzMiscUtils;

{$I jedi.inc}

{$WARN SYMBOL_PLATFORM off}
{$WARN UNIT_PLATFORM off}

interface

uses
  SysUtils,
  Windows,
  Registry,
  u_dzTranslator;

type
  ///<summary> raised by Max([array of const]) and Min([array of const]) if the passed
  ///   paramter is empty </summary>
  EEmptyArray = class(Exception);

  EPathTooLong = class(Exception);

{$IFDEF debug}
  // do not remove the ifdef!!!
  ENotImplemented = class(exception);
{$ENDIF}

type
  TBooleanNames = array[boolean] of string;
const
  BOOLEAN_NAMES: TBooleanNames = ('false', 'true'); // do not translate

///<summary> Emulates this infamous Visual Basic function of which nobody actually knows
///          what it does. </summary>
function TwipsPerPixelX(_Handle: hdc): Extended;

///<summary> Emulates this infamous Visual Basic function of which nobody actually knows
///          what it does. </summary>
function TwipsPerPixelY(_Handle: hdc): Extended;

///<summary> Returns the name for the HKey constant. </summary>
function HKeyToString(_HKey: HKey): string;

///<summary> Returns the name for the TRegDataType Value. </summary>
function RegDataTypeToString(_DataType: TRegDataType): string;

///<summary> returns a hex dump of the buffer (no spaces added)
///          @param Buffer is the memory block to dump
///          @param Len is the length of the block
///          @returns a string containing the hex dump of the buffer </summary>
function HexDump(const _Buffer; _Len: integer): string;

///<summary> hex dumps a double value </summary>
function HexDumpDouble(const _dbl: Double): string;

///<summary> hex dumps an extended value </summary>
function HexDumpExtended(const _ext: Extended): string;

///<summary> returns a hex dump of the string s </summary>
function HexDumpString(const _s: ansistring): string;

///<summary> converts a hexdump of a double back to a double value </summary>
procedure HexDumpToDbl(const _s: string; var _Value: double);

///<summary> converts a hexdump of an extended back to an extended value </summary>
procedure HexDumpToExtended(const _s: string; var _Value: Extended);

///<summary> converts an integer to a 8 digit hex string </summary>
function IntToHex(_Value: integer): string; overload;

///<summary> converts an In64 to a 16 digit hex string </summary>
function IntToHex(_Value: Int64): string; overload;

///<summary> Converts an integer to a boolean.
///          @param Int is the integer to convert
///          @returns false, if the integer is 0, true otherwise </summary>
function IntToBool(_Int: integer): boolean;

///<summary> Converts a boolean to an integer.
///          @param B is the boolean to convert
///          @returns 0 if the boolean is false, 1 if it is true </summary>
function BoolToInt(_B: boolean): integer;

///<summary> Uses GetLastError to get the last WinAPI error code, then
///          calls SysErrorMessage to get the corresponding error string,
///          optionally takes a format string.
///          @param Error is the error string, only valid if error code <> 0
///          @param Format The Format string to use. It must have %d and %s in it, to
///                        change the order, use %0:d and %1:s, e.g. 'Error %1:s (%0:d)'
///                        %d is replaced by the error code and %s is replaced by the
///                        error message string.
///                        If no format string is given Error will just contain the
///                        Windows error message.
///                        NOTE: Do not pass a resource string or a string translated
///                              using DxGetText to this function since this
///                              would clear the GetLastError result. Use the
///                              overloaded version that takes the ErrCode
///                              parameter instead.
///          @returns the error code /</summary>
function GetLastOsError(out _Error: string; const _Format: string = ''): DWORD; overload;
function GetLastOsError(_ErrCode: integer; out _Error: string; const _Format: string = ''): DWORD; overload;

///<summary> Similar to SysUtils.Win32Check, but does not raise an exception. Instead
///          it returns the error message. The function optionally takes a format string.
///          @param RetVal is the return value of a WinAPI function
///          @param ErrorCode is the error code returned by GetLastError
///          @param Error is the error message corresponding to the error code (only valid if result <> 0)
///          @param Format The Format string to use. It must have %d and %s in it, to
///                        change the order, use %0:d and %1:s, e.g. 'Error %1:s (%0:d)'
///                        %d is replaced by the error code and %s is replaced by the
///                        error message string.
///                        If no format string is given Error will just contain the
///                        Windows error message.
///                        NOTE: Do not pass a resource string or a string translated
///                              using DxGetText to this function since this
///                              would clear the GetLastError result.
///          @Returns the error code </summary>
function Win32CheckEx(_RetVal: BOOL; out _ErrorCode: DWORD; out _Error: string; const _Format: string = ''): BOOL;

///<summary> Same as VCL RaiseLastWin32Error but can specify a format.
///          This procedure does the same as the VCL RaiseLastWin32Error but you can
///          specify a format string to use. With this string you can provide some
///          additional information about where the error occured.
///          It calls GetLastError to get the result code of the last Win32 api function.
///          If it returns non 0 the function uses SysErrorMessage to retrieve an error
///          message for the error code and raises raises an EWin32Error exception
///          (to be compatible with the VCL function) with the Error message.
///          NOTE: Do not pass a resource string as format parameter, since loading this
///                string will reset the error code returned by GetLastError, so
///                you always get 0. Use the overloaded Version that takes the error code
///                as parameter and get it before using the resource string if you want that.
///          @param Format The Format string to use. It must have %d and %s in it, to
///                        change the order, use %0:d and %1:s, e.g. 'Error %1:s (%0:d)'
///                        %d is replaced by the error code and %s is replaced by the
///                        error message string. </summary>
procedure RaiseLastOsErrorEx(const _Format: string); overload;

///<summary> Same as VCL RaiseLastWin32Error but can specify a format.
///          This procedure does the same as the VCL RaiseLastWin32Error but you can
///          specify a format string to use. With this string you can provide some
///          additional information about where the error occured.
///          If ErrorCode <> 0 the function uses SysErrorMessage to retrieve an error
///          message for the error code and raises raises an EWin32Error exception
///          (to be compatible with the VCL function) with the Error message.
///          NOTE: If you pass a resource string as format parameter make sure you
///          call GetLastError before referencing the resource string, otherwise
///          loading the string will reset the error code returned by GetLastError, so
///          you always get 0.
///          @param ErrorCode is an error code returned from GetLastWin32Error
///          @param Format The Format string to use. It must have %d and %s in it, to
///                        change the order, use %0:d and %1:s, e.g. 'Error %1:s (%0:d)'
///                        %d is replaced by the error code and %s is replaced by the
///                        error message string. </summary>
procedure RaiseLastOsErrorEx(_ErrorCode: integer; const _Format: string); overload;

///<summary> Combines WriteLn with Format
///          @param FormatStr string describing the format
///          @param Args constant array with the arguments </summary>
procedure WriteFmtLn(const _FormatStr: string; _Args: array of const);

///<summary> splits a wildcard into its components: The path and the filemask
///          @param Wildcard is a string specifying the wildcard
///          @param Path is a string returning the path part of the wildcard
///          @param Mask is a string returning the Mask part of the wildcard
///          @returns true, if the Path exists, false otherwise </summary>
function SplitWildcard(const _Wildcard: string; out _Path, _Mask: string): boolean;

{: returns the string's reference counter, pass a string by typecasting it
   to a pointer to avoid an additional increment of the reference counter }
function GetStringRefCount(_s: pointer): integer;

{$IFDEF debug}
// do NOT remove, this is a sanity check so we don't ship anything where there are
// missing features.
procedure NotImplemented;
{$ENDIF debug}

implementation

uses
{$IFDEF debug}
{$IFNDEF console}
  Controls,
  Dialogs,
  FileCtrl,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
{$ENDIF}
{$ENDIF}
  StrUtils,
  u_dzFileUtils,
  u_dzStringUtils,
  u_dzConvertUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

{$IFDEF debug}

procedure NotImplemented;
begin
{$IFNDEF console}
  if mrAbort = MessageDlg('Function not implemented!', mtWarning, [mbAbort, mbIgnore], 0) then
{$ENDIF}
    raise ENotImplemented.Create('Function not implemented');
end;
{$ENDIF debug}

function TwipsPerPixelX(_Handle: hdc): Extended;
var
  Pixels: integer;
begin
  Pixels := GetDeviceCaps(_Handle, LOGPIXELSX);
  if Pixels = 0 then
    Result := 0
  else
    result := 1440 / Pixels;
end;

function TwipsPerPixelY(_Handle: hdc): Extended;
var
  Pixels: integer;
begin
  Pixels := GetDeviceCaps(_Handle, LOGPIXELSY);
  if Pixels = 0 then
    Result := 0
  else
    result := 1440 / Pixels;
end;

function HKeyToString(_HKey: HKey): string;
begin
  case _HKey of
    HKEY_CLASSES_ROOT: result := 'HKEY_CLASSES_ROOT'; // do not translate
    HKEY_CURRENT_USER: result := 'HKEY_CURRENT_USER'; // do not translate
    HKEY_LOCAL_MACHINE: result := 'HKEY_LOCAL_MACHINE'; // do not translate
    HKEY_USERS: result := 'HKEY_USERS'; // do not translate
    HKEY_PERFORMANCE_DATA: result := 'HKEY_PERFORMANCE_DATA'; // do not translate
    HKEY_CURRENT_CONFIG: result := 'HKEY_CURRENT_CONFIG'; // do not translate
    HKEY_DYN_DATA: result := 'HKEY_DYN_DATA'; // do not translate
  else
    Result := Format(_('unknown Registry Root Key %x'), [_HKey]);
  end;
end;

function RegDataTypeToString(_DataType: TRegDataType): string;
begin
  case _DataType of
    rdUnknown: Result := 'Unknown'; // do not translate
    rdString: Result := 'String'; // do not translate
    rdExpandString: Result := 'ExpandString'; // do not translate
    rdInteger: Result := 'Integer'; // do not translate
    rdBinary: Result := 'Binary'; // do not translate
  else
    Result := _('unknown RegDataType');
  end;
end;

function IntToBool(_Int: integer): boolean;
begin
  Result := (_Int <> 0);
end;

function BoolToInt(_B: boolean): integer;
begin
  if _B then
    Result := 1
  else
    Result := 0;
end;

procedure RaiseLastOsErrorEx(const _Format: string);
begin
  RaiseLastOsErrorEx(GetLastError, _Format);
end;

procedure RaiseLastOsErrorEx(_ErrorCode: integer; const _Format: string); overload;
var
  Error: EOSError;
begin
  if _ErrorCode <> ERROR_SUCCESS then
    Error := EOSError.CreateFmt(_Format, [_ErrorCode, SysErrorMessage(_ErrorCode)])
  else
    Error := EOsError.CreateFmt(_Format, [_ErrorCode, _('unknown OS error')]);
  Error.ErrorCode := _ErrorCode;
  raise Error;
end;

function GetLastOsError(out _Error: string; const _Format: string = ''): DWORD;
begin
  Result := GetLastOsError(GetLastError, _Error, _Format);
end;

function GetLastOsError(_ErrCode: integer; out _Error: string; const _Format: string = ''): DWORD;
var
  s: string;
begin
  Result := _ErrCode;
  if Result <> ERROR_SUCCESS then
    s := SysErrorMessage(Result)
  else
    s := _('unknown OS error');
  if _Format <> '' then
    try
      _Error := Format(_Format, [Result, s])
    except
      _Error := s;
    end else
    _Error := s;
end;

function Win32CheckEx(_RetVal: BOOL; out _ErrorCode: DWORD; out _Error: string;
  const _Format: string = ''): BOOL;
begin
  Result := _RetVal;
  if not Result then
    _ErrorCode := GetLastOsError(_Error, _Format);
end;

procedure WriteFmtLn(const _FormatStr: string; _Args: array of const);
begin
  WriteLn(Format(_FormatStr, _Args));
end;

function SplitWildcard(const _Wildcard: string; out _Path, _Mask: string): boolean;
var
  i: integer;
  MaskFound: boolean;
begin
  if _Wildcard = '' then begin
    _Path := '.';
    _Mask := '';
    Result := true;
    exit;
  end;
  MaskFound := false;
  i := Length(_Wildcard);
  while i > 0 do begin
    if CharInSet(_Wildcard[i], ['*', '?']) then
      MaskFound := true;
    if _Wildcard[i] = '\' then begin
      if MaskFound or not TFileSystem.DirExists(_Wildcard) then begin
        // if we had a mask, this is easy, just split the wildcard at position i
        // if there was no mask, and the whole thing is not a directory,
        // split at position i
        _Mask := TailStr(_Wildcard, i + 1);
        _Path := LeftStr(_Wildcard, i - 1);
        Result := TFileSystem.DirExists(_Path);
      end else begin
        // there was no mask and the whole thing is a directory
        Result := true;
        _Path := _Wildcard;
        _Mask := '';
      end;
      exit;
    end;
    Dec(i);
  end;

  // we found no backslash in the whole thing, so this could either
  // be a file or a subdirectory in the current directory.

  // if there was a mask, or the thing is not a directory, it is a file in
  // the current directory
  if MaskFound or not TFileSystem.DirExists(_Wildcard) then begin
    _Path := '.';
    _Mask := _Wildcard;
    Result := true;
  end else begin
    // otherwise it is a subdirectory
    _Path := _Wildcard;
    _Mask := '';
    Result := true;
  end;
end;

function iif(_Cond: boolean; _IfTrue: integer; _IfFalse: integer): integer; overload;
begin
  if _Cond then
    Result := _IfTrue
  else
    Result := _IfFalse;
end;

function iif(_Cond: boolean; const _IfTrue: string; const _IfFalse: string): string; overload;
begin
  if _Cond then
    Result := _IfTrue
  else
    Result := _IfFalse;
end;

function iif(_Cond: boolean; const _IfTrue: double; const _IfFalse: double): double; overload;
begin
  if _Cond then
    Result := _IfTrue
  else
    Result := _IfFalse;
end;

function iif(_Cond: boolean; const _IfTrue: char; const _IfFalse: char): char; overload;
begin
  if _Cond then
    Result := _IfTrue
  else
    Result := _IfFalse;
end;

function HexDumpString(const _s: ansistring): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(_s) do begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + Long2Hex2(Ord(_s[i]));
  end;
end;

function HexDump(const _Buffer; _Len: integer): string;
type
  PByte = ^Byte;
var
  i: integer;
  p: PByte;
begin
  p := @_Buffer;
  Result := '';
  for i := 0 to _Len - 1 do begin //FI:W528 - variable is only used for counting
    Result := Result + Long2Hex2(p^);
    Inc(p);
  end;
end;

function HexDumpDouble(const _dbl: Double): string;
begin
  Result := HexDump(_dbl, SizeOf(Double));
end;

function HexDumpExtended(const _ext: Extended): string;
begin
  Result := HexDump(_Ext, SizeOf(Extended));
end;

procedure HexDumpToDbl(const _s: string; var _Value: double);
type
  TBuffer = array[0..SizeOf(_Value)] of byte;
var
  i: integer;
  dec: LongWord;
  p: ^TBuffer;
begin
  Assert(Length(_s) = SizeOf(_Value) * 2);
  p := @_Value;
  for i := 0 to SizeOf(_Value) - 1 do begin
    Dec := Hex2Long(Copy(_s, i * 2 + 1, 2));
    p^[i] := Dec;
  end;
end;

procedure HexDumpToExtended(const _s: string; var _Value: Extended);
type
  TBuffer = array[0..SizeOf(_Value)] of byte;
var
  i: integer;
  dec: LongWord;
  p: ^TBuffer;
begin
  Assert(Length(_s) = SizeOf(_Value) * 2);
  p := @_Value;
  for i := 0 to SizeOf(_Value) - 1 do begin
    Dec := Hex2Long(Copy(_s, i * 2 + 1, 2));
    p^[i] := Dec;
  end;
end;

function IntToHex(_Value: integer): string;
begin
  Result := IntToHex(_Value, SizeOf(_Value) * 2);
end;

function IntToHex(_Value: Int64): string;
begin
  Result := IntToHex(_Value, SizeOf(_Value) * 2);
end;

type
  PStringDescriptor = ^TStringDescriptor;
  TStringDescriptor = record
    RefCount: integer;
    Size: integer;
  end;

function GetStringRefCount(_s: pointer): integer;
var
  desc: PStringDescriptor;
begin
  if _s <> nil then begin
    desc := pointer(integer(_s) - 8);
    Result := desc.RefCount;
  end else
    Result := 0;
end;

end.

