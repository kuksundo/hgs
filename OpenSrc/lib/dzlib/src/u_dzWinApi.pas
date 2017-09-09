unit u_dzWinApi;

{$I 'jedi.inc'}

interface

uses
  Windows,
  SysUtils,
  u_dzTranslator;

{$IFNDEF RTL230_UP}
type
  NativeUInt = DWORD;
  SIZE_T = LongWord;
{$ENDIF}

type
  TWinApi = class
  private
    class procedure RaiseLastError(const _ApiFunction: string);
  public
    ///<summary> Calls Windows API CreateFile
    ///          @raises EOSError, if it returns INVALID_FILE_HANDLE </summary>
    class function CreateFile(const _FileName: string; _DesiredAccess, _ShareMode: DWORD;
      _SecurityAttributes: PSecurityAttributes; _CreationDisposition, _FlagsAndAttributes: DWORD;
      _TemplateFile: THandle): THandle;
    ///<summary> Calls Windows API GetProcessAffinityMask
    ///          @raises EOSError, if it returns false </summary>
    class procedure GetProcessAffinityMask(var _ProcessAffinityMask, _SystemAffinityMask: NativeUInt); overload;
    ///<summary> Calls Windows API SetProcessAffinityMask
    ///          @raises EOSError, if it returns false </summary>
    class procedure SetProcessAffinityMask(_ProcessAffinityMask: DWORD_PTR); overload;
    class function CreateFileMapping(_File: THandle; _FileMappingAttributes: PSecurityAttributes;
      _Protect, _MaximumSizeHigh, _MaximumSizeLow: DWORD; const _Name: string = ''): THandle;
    ///<summary> Calls Windows API GetFileSizeEx
    ///          @param Filename is optional, if given, the exception text will contain the filename
    ///          @raises EOsError, if it returns false </summary>
    class function GetFileSizeEx(hFile: THandle; const _Filename: string = ''): Int64;
    class function MapViewOfFile(_FileMappingObject: THandle; _DesiredAccess,
      _FileOffsetHigh, _FileOffsetLow: DWORD; _NumberOfBytesToMap: SIZE_T): Pointer;
  end;

implementation

uses
  u_dzMiscUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

function Kernel32_GetFileSizeEx(hFile: THandle; lpFileSize: PInt64): BOOL; stdcall; external kernel32 name 'GetFileSizeEx';

{ TWinApi }

class procedure TWinApi.RaiseLastError(const _ApiFunction: string);
var
  err: Cardinal;
begin
  err := GetLastError;
  RaiseLastOsErrorEx(Err, Format(_('Error %%1:s (%%0:d) calling %s Windows API'), [_ApiFunction]));
end;

class function TWinApi.CreateFile(const _FileName: string; _DesiredAccess, _ShareMode: DWORD;
  _SecurityAttributes: PSecurityAttributes; _CreationDisposition, _FlagsAndAttributes: DWORD;
  _TemplateFile: THandle): THandle;
var
  Err: Cardinal;
begin
  Result := Windows.CreateFile(PChar(_Filename), _DesiredAccess, _ShareMode, _SecurityAttributes,
    _CreationDisposition, _FlagsAndAttributes, _TemplateFile);
  if Result = INVALID_HANDLE_VALUE then begin
    Err := GetLastError;
    RaiseLastOsErrorEx(Err, Format(_('Error %%1:s (%%0:d) calling CreateFile("%s") Windows API'), [_Filename]));
  end;
end;

class function TWinApi.CreateFileMapping(_File: THandle; _FileMappingAttributes: PSecurityAttributes;
  _Protect, _MaximumSizeHigh, _MaximumSizeLow: DWORD; const _Name: string = ''): THandle;
var
  Err: Cardinal;
  lpName: PChar;
begin
  if _Name = '' then
    lpName := nil
  else
    lpName := PChar(_Name);
  Result := Windows.CreateFileMapping(_File, _FileMappingAttributes, _Protect, _MaximumSizeHigh, _MaximumSizeLow, lpName);
  if Result = 0 then begin
    Err := GetLastError;
    RaiseLastOsErrorEx(Err, Format(_('Error %%1:s (%%0:d) calling CreateFileMapping("%s")'), [_Name]));
  end;
end;

class function TWinApi.GetFileSizeEx(hFile: THandle; const _Filename: string = ''): Int64;
var
  Err: Cardinal;
begin
  if not Kernel32_GetFileSizeEx(hFile, @Result) then begin
    if _Filename <> '' then begin
      Err := GetLastError;
      RaiseLastOsErrorEx(Err, Format(_('Error %%1:s (%%0:d) calling GetFileSizeEx("%s") Windows API'), [_Filename]));
    end else
      RaiseLastError('GetFileSizeEx');
  end;
end;

class procedure TWinApi.GetProcessAffinityMask(var _ProcessAffinityMask, _SystemAffinityMask: NativeUInt);
begin
  if not Windows.GetProcessAffinityMask(GetCurrentProcess, _ProcessAffinityMask, _SystemAffinityMask) then
    RaiseLastError('GetProcessAffinityMask');
end;

class function TWinApi.MapViewOfFile(_FileMappingObject: THandle; _DesiredAccess, _FileOffsetHigh,
  _FileOffsetLow: DWORD; _NumberOfBytesToMap: SIZE_T): Pointer;
begin
  Result := Windows.MapViewOfFile(_FileMappingObject, _DesiredAccess, _FileOffsetHigh, _FileOffsetLow, _NumberOfBytesToMap);
  if Result = nil then
    RaiseLastError('MapViewOfFile');
end;

class procedure TWinApi.SetProcessAffinityMask(_ProcessAffinityMask: DWORD_PTR);
begin
  if not Windows.SetProcessAffinityMask(GetCurrentProcess, _ProcessAffinityMask) then
    RaiseLastError('SetProcessAffinityMask');
end;

end.

