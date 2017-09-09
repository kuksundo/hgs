{.GXFormatter.config=twm}
/// <summary>
/// Implements functions which work on classes but are not methods.
/// @autor(twm)
/// </summary>
unit u_dzClassUtils;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Contnrs,
  IniFiles,
  Registry,
  u_dzTranslator;

// NOTE: The naming convention is <extended-class>_<Methodname>

type
  /// <summary>
  /// raised by StringByObj if no matching entry was found
  /// </summary>
  EObjectNotFound = class(Exception);

///<summary>
/// Creates a TStringList from the given array of string. In addition it returns a
/// Guard-Interface that automatically frees the TStringList when it goes out of scope. </summary>
function StringListOf(const _sa: array of string; out _Guard: IInterface): TStringList;

/// <summary>
/// Removes trailing spaces from all lines in Strings as well as empty lines
/// from the end of Strings, returns true if at least one string was shortened
/// or an empty string was removed.
/// @param Strings is the TStrings class to work on.
/// @returns true, if something was changed, false otherwise </summary>
function TStrings_RemoveTrailingSpaces(_Strings: TStrings): Boolean;

///<summary>
/// Removes all strings that start with the given CommentPrefix.
/// Comparison with the CommentPrefix is case insensitive, leading spaces are ignored. </summary>
procedure TStrings_RemoveComments(_Strings: TStrings; const _CommentPrefix: string = '//');

/// <summary>
/// Free a TStrings object including all it's Object[n]s </summary>
procedure TStrings_FreeWithObjects(_Strings: TStrings);
/// <summary>
/// Free a TStrings object including all it's Object[n]s and sets it to NIL </summary>
procedure TStrings_FreeAndNilWithObjects(var _Strings);

/// <summary>
/// Frees all objects stored in the TStrings intance and returns the instance,
/// meant to be called like
/// @code( TStrings_FreeAllObjects(sl).Free; ) or
/// @code( TStrings_FreeAllObjects(sl).Clear; ) </summary>
function TStrings_FreeAllObjects(_Strings: TStrings): TStrings;

///<summary>
/// searches the TStrings for the given string and deletes it if it can find it
/// @returns true, if it was found and deleted, false if not </summary>
function TStrings_DeleteString(_Strings: TStrings; const _s: string): Boolean;

///<summary>
/// Deletes all strings in toDelete from Strings, if they exist.
/// @returns the number of strings that were deleted </summary>
function TStrings_DeleteStrings(_Strings: TStrings; _toDelete: TStrings): Integer;

/// <summary>
/// frees the object and delets the entry from the list
/// </summary>
procedure TStrings_DeleteAndFreeObject(_Strings: TStrings; _Idx: Integer);

///<summary>
/// searches the given Obj in _Strings.Objects (does a linear search)
/// @param Obj is the object to search for
/// @param Idx will contain the index of the item, if found. Only valid if result is true
/// @returns true, if found, false otherwise
function TStrings_GetObjectIndex(_Strings: TStrings; _Obj: Pointer; out _Idx: Integer): Boolean;

///<summary>
/// Compares to TStrings and returns true, if they are identical, false if not.
///</summary>
function TStrings_Same(_sl1, _sl2: TStrings): Boolean;

///<summary>
/// Compares to TStrings ignoring case and returns true, if they are identical, false if not.
///</summary>
function TStrings_SameText(_sl1, _sl2: TStrings): Boolean;

///<summary>
/// Writes the TStrings to the given registry branch under HKCU (or the HKEY given),
/// using Item0...Item<count-1> and Count keys.
/// @param sl is the TStrings object to save
/// @param Path is the path in the registry to write to, it is created if it does not exist. It
///             must be an absolute path (that is: start with a backslash)
/// @param HKey is the registry branch to use, defaults to HKEY_CURRENT_USER
///</summary>
procedure TStrings_SaveToRegistry(_sl: TStrings; const _Path: string; _HKEY: HKEY = HKEY_CURRENT_USER);
///<summary>
/// Reads the TStrings to the given registry branch under HKCU (or the HKEY given),
/// using Item0...Item<count-1> and Count keys, as written by TStrings_SaveToRegistry.
/// @param sl is the TStrings object to save
/// @param Path is the path in the registry to write to, it is created if it does not exist. It
///             must be an absolute path (that is: start with a backslash)
/// @param HKey is the registry branch to use, defaults to HKEY_CURRENT_USER
///</summary>
function TStrings_LoadFromRegistry(_sl: TStrings; const _Path: string; _HKEY: HKEY = HKEY_CURRENT_USER): Boolean;

///<summary>
/// Convenience function that calls Strings.BeginUpdate and returns an interface which calls
/// Strings.EndUpdate when it is freed. </summary>
function TStrings_BeginUpdate(_Strings: TStrings): IInterface;

///<summary>
/// Assumes that st contains <name>=<value> pairs and returns the index of the first line
/// that has the given value. Note that this simply does a linear search.
/// @param st is the TStrings to search in
/// @param Value is a string to search for
/// @returns the index of the first matching line or -1 if no match is found </summary>
function TStrings_IndexOfValue(_st: TStrings; const _Value: string): Integer;

/// <summary>
/// Free a TList object an all TObjects it contains
/// NOTE: this function is obsolete, use contnrs.TObjectList instead!
/// </summary>
procedure TList_FreeWithItems(var _List: TList); deprecated; // use contnrs.TObjectList

/// <summary>
/// Extracts the Idx'th item from the list without freeing it.
/// </summary>
function TObjectList_Extract(_lst: TObjectList; _Idx: Integer): TObject;

/// <summary>
/// Write a string to the stream
/// @param Stream is the TStream to write to.
/// @param s is the string to write
/// @returns the number of bytes written.
/// </summary>
function TStream_WriteString(_Stream: TStream; const _s: string): Integer;

/// <summary>
/// Write a ShortString to the stream as binary, that is the length byte followed by len content bytes
/// @param Stream is the TStream to write to.
/// @param s is the string to write
/// @returns the number of bytes written.
/// </summary>
function TStream_WriteShortStringBinary(_Stream: TStream; const _s: ShortString): Integer;

/// <summary>
/// Reads a ShortString as written by TStream_WriteShortStringBinary
/// @param Stream is the TStream to write to.
/// @returns the string read
/// </summary>
function TStream_ReadShortStringBinary(_Stream: TStream): ShortString;

/// <summary>
/// Write a string to the stream appending CRLF
/// @param Stream is the TStream to write to.
/// @param s is the string to write
/// @returns the number of bytes written.
/// </summary>
function TStream_WriteStringLn(_Stream: TStream; const _s: string): Integer;

/// <summary>
/// Read a line from a stream, that is, a string ending in CRLF
/// @param Stream is the TStream to read from.
/// @param s returns the read string, without the CRLF
/// @returns the number of bytes read, excluding the CRLF
/// </summary>
function TStream_ReadStringLn(_Stream: TStream; out _s: string): Integer;

/// <summary>
/// Write formatted data to the stream appending CRLF
/// @param Stream is the TStream to write to.
/// @param Format is a format string as used in sysutils.format
/// @param Args is an array of const as used in sysutils.format
/// @returns the number of bytes written.
/// </summary>
function TStream_WriteFmtLn(_Stream: TStream; const _Format: string; _Args: array of const): Integer;

/// <summary>
/// returns the string which has the given value as Object
/// @param Strings is the TStrings to search
/// @param Obj is a pointer to match
/// @param RaiseException is a boolean that controls whether an exception should
///           be raised (if true) if the Obj cannot be found or an empty strin should
///           be returned (if false), Default = true
/// @returns the string whose object matches Obj or an empty string, if none
///          was found and RaiseExeption was false
/// @raises EObjectNotFound if a matching object was not found and RaiseException
///         is true.
/// </summary>
function TStrings_StringByObj(_Strings: TStrings; _Obj: Pointer; _RaiseException: Boolean = True): string;

/// <summary>
/// determines the string which has the given value as Object
/// @param Strings is the TStrings to search
/// @param Obj is a pointer to match
/// @param Value is the string whose object matches Obj, only valid if result is true
/// @returns true, if a matching object was found, false otherwise
/// </summary>
function TStrings_TryStringByObj(_Strings: TStrings; _Obj: Pointer; out _Value: string): Boolean;

/// <summary>
/// reads a char from an ini file, if the value is longer than one char, it returns
/// the first char, if it is empty, it returns the default
/// </summary>
function TIniFile_ReadChar(_Ini: TCustomIniFile; const _Section, _Ident: string; _Default: Char): Char;

///<summary> Like TIniFile.ReadString but allows to specify whether to use the Default if the read string
///          is empty. </summary>
function TIniFile_ReadString(_Ini: TCustomIniFile; const _Section, _Ident: string; const _Default: string; _DefaultIfEmtpy: Boolean = False): string; overload;
///<summary> Like TIniFile.ReadString but allows to specify whether to use the Default if the read string
///          is empty. </summary>
function TIniFile_ReadString(const _Filename: string; const _Section, _Ident: string; const _Default: string; _DefaultIfEmtpy: Boolean = False): string; overload;
///<summary>
/// Reads a string from the ini-file, raises an exception if the value is empty </summary>
function TIniFile_ReadString(_Ini: TCustomIniFile; const _Section, _Ident: string): string; overload;

///<summary>
/// reads a string list from an ini file section of the form
/// [section]
/// count=2
/// Item0=blab
/// Item1=blub
/// @returns the number of strings read
/// </summary>
function TIniFile_ReadStrings(_Ini: TCustomIniFile; const _Section: string; _st: TStrings): Integer;
procedure TIniFile_WriteStrings(_Ini: TCustomIniFile; const _Section: string; _st: TStrings);

///<summary>
/// Tries to read a floating point value from the ini-file, always using '.' as decimal separator.
/// @raises EStringConvertError if a string could be read but was not a valid float value
/// @returns true, if a value could be read and converted
///          false, if the value does not exist or is empty
///</summary>
function TIniFile_TryReadFloat(_Ini: TCustomIniFile; const _Section, _Ident: string; out _Value: Extended): Boolean; overload;
function TIniFile_ReadFloat(_Ini: TCustomIniFile; const _Section, _Ident: string; out _Value: Extended): Boolean; overload deprecated; // use TryReadFloat instead
function TIniFile_ReadFloat(_Ini: TCustomIniFile; const _Section, _Ident: string): Extended; overload;

///<summary>
/// Writes a floating point value to the ini-file, always using '.' as decimal separator.
///</summary>
procedure TIniFile_WriteFloat(_Ini: TCustomIniFile; const _Section, _Ident: string; _Value: Extended);

///<summary>
/// Tries to read an integer value from the ini-file.
/// @raises EStringConvertError if a string could be read but was not a valid integer value
/// @returns true, if a value could be read and converted
///          false, if the value does not exist or is empty
///</summary>
function TIniFile_TryReadInt(const _Filename: string; const _Section, _Ident: string; out _Value: Integer): Boolean; overload;
function TIniFile_TryReadInt(_Ini: TCustomIniFile; const _Section, _Ident: string; out _Value: Integer): Boolean; overload;

///<summary>
/// Reads an integer from the ini-file, raises an exception if the value is not an integer </summary>
function TIniFile_ReadInt(const _Filename: string; const _Section, _Ident: string): Integer; overload;
function TIniFile_ReadInt(_Ini: TCustomIniFile; const _Section, _Ident: string): Integer; overload;

///<summary>
/// Reads an integer from the ini-file, raises an exception if the value is not an integer or empty string.
/// For empty strings, it returns the default. </summary>
function TIniFile_ReadInt(const _Filename: string; const _Section, _Ident: string; _Default: Integer): Integer; overload;
function TIniFile_ReadInt(_Ini: TCustomIniFile; const _Section, _Ident: string; _Default: Integer): Integer; overload;

///<summary>
/// Reads a date in ISO format from the ini-file, raises an exception if the value is not a valid date </summary>
function TIniFile_ReadDate(_Ini: TCustomIniFile; const _Section, _Ident: string): TDateTime;
///<summary>
/// Tries to read a date in ISO format from the ini-file
/// @raises EStringConvertError if a string could be read but was not a valid date
/// @returns true, if the date could be read and converted </summary>
function TIniFile_TryReadDate(_Ini: TCustomIniFile; const _Section, _Ident: string; out _Value: TDateTime): Boolean;

///<summary>
/// Writes a date in ISO format to the ini file </summary>
procedure TIniFile_WriteDate(_Ini: TCustomIniFile; const _Section, _Ident: string; const _Value: TDateTime);

///<summary>
/// Checks whether the section exists in the given ini file
/// @returns true, if it exists, false, if not
function TIniFile_SectionExists(const _Filename: string; const _Section: string): Boolean;

///<summary>
/// Clears all entries in the given section but does not delete the section header.
///</summary>
procedure TIniFile_ClearSection(_Ini: TCustomIniFile; const _Section: string);

///<summary>
/// Clears all entries in the given section and writes the values from the TStrings to it
/// </summary>
procedure TIniFile_WriteSectionValues(_Ini: TCustomIniFile; const _Section: string; _sl: TStrings);

/// <summary>
/// Reads the given section from the given .INI file and returns all its keys as a TStrings
/// (This is short for opening the file, calling Ini.ReadSection and closing it.)
/// @raises Exception if the section does not exist. </summary>
procedure TIniFile_ReadSectionKeys(const _Filename, _Section: string; _sl: TStrings); inline;

///<summary>
/// Reads the given section from the given .INI file and returns it as Name=Value pairs.
/// (This is short for opening the file, calling Ini.ReadSectionValues and closing it.)
/// @raises Exception if the section does not exist. </summary>
procedure TIniFile_ReadSectionValues(const _Filename, _Section: string; _sl: TStrings); inline;

///<summary>
/// @param HKEY is the HKEY value to evaluate
/// @param Short determines whether to return the short (HKCU) or the long name (HKEY_CURRENT_USER)
///              there are only short values for HKCU, HKLM and HKCR.
/// @returns the string representation of the known HKEY values
/// @raises Exception if  HKEY is not one of the known values </summary>
function TRegistry_Hkey2String(_HKEY: HKEY; _Short: Boolean = False): string;

type
  IRegistryGuard = interface ['{73A2F402-E0AA-4C70-A17B-65B75EABDE0A}']
    function IsValid: Boolean;
    function TryReadString(const _Item: string; out _Value: string): Boolean;
    function ReadStringDef(const _Item: string; const _Default: string = ''): string;
    procedure WriteString(const _Item: string; const _Value: string);
    function TryReadStringList(const _SubPath: string; const _sl: TStrings;
      const _ClearFirst: Boolean = True; const _ItemName: string = 'Item'): Boolean;
    procedure WriteStringList(const _SubPath: string; const _sl: TStrings;
      const _ItemName: string = 'Item');
    function TryReadInteger(const _Item: string; out _Value: Integer): Boolean;
    function ReadIntegerDef(const _Item: string; const _Default: Integer): Integer;
    procedure WriteInteger(const _Item: string; _Value: Integer);
    function Reg: TRegistry;
  end;

///<summary>
/// Opens a registry key for reading
/// @param Key is the registry key to open
/// @param HKEY is the root key to use, defaults to HKEY_CURRENT_USER
/// @returns a IRegistryGuard interface which closes and frees the TRegistry object automatically
///          when it goes out of scope. </summary>
function TRegistry_OpenKeyReadonly(const _Key: string; _HKEY: HKEY = HKEY_CURRENT_USER): IRegistryGuard;

function TRegistry_TryOpenKeyReadonly(const _Key: string; _HKEY: HKEY = HKEY_CURRENT_USER): IRegistryGuard;

///<summary>
/// Opens a registry key for writing
/// @param Key is the registry key to open
/// @param HKEY is the root key to use, defaults to HKEY_CURRENT_USER
/// @returns a IRegistryGuard interface which closes and frees the TRegistry object automatically
///          when it goes out of scope. </summary>
function TRegistry_OpenKey(const _Key: string; _HKEY: HKEY = HKEY_CURRENT_USER): IRegistryGuard;

///<summary>
/// Tries to read a string from the registry
/// @param Path is the full path, including the value name of the string
/// @param Value contains the string that was read, only valid if Result = true
/// @param HKEY is the root key to use, defaults to HKEY_CURRENT_USER
/// @returns true, if the value specified did exist, falso if it did not exist
/// @raises any exception that TRegistry raises if something goes wrong reading the value,
///         e.g. the value exists, but is not a string </summary>
function TRegistry_TryReadString(const _Path: string; out _Value: string;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean; overload; deprecated; // use the overloaded version instead

///<summary>
/// Tries to read a string from the registry
/// @param Key is the Key in which to read
/// @param Entry is the name of the entry to read
/// @param Value contains the string that was read, only valid if Result = true
/// @param HKEY is the root key to use, defaults to HKEY_CURRENT_USER
/// @returns true, if the value specified did exist, falso if it did not exist
/// @raises any exception that TRegistry raises if something goes wrong reading the value,
///         e.g. the value exists, but is not a string </summary>
function TRegistry_TryReadString(const _Key: string; const _Entry: string; out _Value: string;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean; overload;

///<summary>
/// Reads a string from the registry
/// @param Path is the full path, including the value name of the string
/// @param Default is the value to return if the value does not exist in the registry
/// @param HKEY is the root key to use, defaults to HKEY_CURRENT_USER
/// @returns the string that was read, the default if the value did not exist
/// @raises any exception that TRegistry raises if something goes wrong reading the value,
///         e.g. the value exists, but is not a string </summary>
function TRegistry_ReadString(const _Path: string; const _Default: string = '';
  _HKEY: HKEY = HKEY_CURRENT_USER): string; overload; deprecated; // use the overloaded version

///<summary>
/// Reads a string from the registry
/// @param Key is the Key in which to read
/// @param Entry is the name of the entry to read
/// @param Default is the value to return if the value does not exist in the registry
/// @param HKEY is the root key to use, defaults to HKEY_CURRENT_USER
/// @returns the string that was read, the default if the value did not exist
/// @raises any exception that TRegistry raises if something goes wrong reading the value,
///         e.g. the value exists, but is not a string </summary>
function TRegistry_ReadString(const _Key: string; const _Entry: string; const _Default: string = '';
  _HKEY: HKEY = HKEY_CURRENT_USER): string; overload;

///<summary>
/// Writes a string to the registry
/// @param Path is the full path, including the value name of the string
/// @param Value contains the string to write
/// @param HKEY is the root key to use, defaults to HKEY_CURRENT_USER
/// @raises any exception that TRegistry raises if something goes wrong writing the value,
///         e.g. the cannot be opened or the value exists, but is not a string </summary>
procedure TRegistry_WriteString(const _Path: string; const _Value: string;
  _HKEY: HKEY = HKEY_CURRENT_USER); overload;

procedure TRegistry_WriteString(const _Key: string; const _Item: string; const _Value: string;
  _HKEY: HKEY = HKEY_CURRENT_USER); overload;

function TRegistry_TryReadStringValues(const _Path: string; _Entries: TStringList;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean;

///<summary>
/// Deletes the value given by the Item from the given registry key.
/// @param Key is the registry key (path) from which to delete
/// @param Item is the name of the value to be deleted
/// @param HKEY is the root key to use, defaults to HKEY_CURRENT_USER
/// @raises any exception that TRegistry raises if something goes wrong writing the value,
///         e.g. the cannot be opened or the value does not exist </summary>
procedure TRegistry_DeleteValue(const _Key: string; const _Item: string; _HKEY: HKEY = HKEY_CURRENT_USER);

implementation

uses
  StrUtils,
  u_dzConvertUtils,
  u_dzMiscUtils,
  u_dzStringUtils,
  u_dzDateUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

procedure TList_FreeWithItems(var _List: TList);
var
  i: Integer;
begin
  if Assigned(_List) then begin
    for i := 0 to _List.Count - 1 do
      TObject(_List[i]).Free;
    _List.Free;
    _List := nil;
  end;
end;

function TObjectList_Extract(_lst: TObjectList; _Idx: Integer): TObject;
var
  b: Boolean;
begin
  b := _lst.OwnsObjects;
  _lst.OwnsObjects := False;
  try
    Result := _lst[_Idx];
    _lst.Delete(_Idx);
  finally
    _lst.OwnsObjects := b;
  end;
end;

function TStrings_RemoveTrailingSpaces(_Strings: TStrings): Boolean;
var
  i: Integer;
  s: string;
  Trailing: Boolean;
  p: Integer;
  Len: Integer;
begin
  Result := False;
  Trailing := True;
  for i := _Strings.Count - 1 downto 0 do begin
    s := _Strings[i];
    Len := Length(s);
    p := Len;
    while (p > 0) and (s[p] = ' ') do
      Dec(p);
    if Len <> p then begin
      Result := True;
      s := LeftStr(s, p);
    end;
    if Trailing and (s = '') then begin
      Result := True;
      _Strings.Delete(i);
    end else begin
      Trailing := False;
      _Strings[i] := s;
    end;
  end;
end;

procedure TStrings_RemoveComments(_Strings: TStrings; const _CommentPrefix: string = '//');
var
  i: Integer;
  s: string;
begin
  for i := _Strings.Count - 1 downto 0 do begin
    s := TrimLeft(_Strings[i]);
    if UStartsWith(_CommentPrefix, s) then
      _Strings.Delete(i);
  end;
end;

function TStrings_FreeAllObjects(_Strings: TStrings): TStrings;
var
  i: Integer;
begin
  for i := 0 to _Strings.Count - 1 do begin
    _Strings.Objects[i].Free;
    _Strings.Objects[i] := nil;
  end;
  Result := _Strings;
end;

procedure TStrings_FreeWithObjects(_Strings: TStrings);
begin
  TStrings_FreeAllObjects(_Strings).Free;
end;

procedure TStrings_FreeAndNilWithObjects(var _Strings);
var
  Temp: TStrings;
begin
  Temp := TStrings(_Strings);
  Pointer(_Strings) := nil;
  TStrings_FreeWithObjects(Temp);
end;

function TStrings_DeleteString(_Strings: TStrings; const _s: string): Boolean;
var
  Idx: Integer;
begin
  Idx := _Strings.IndexOf(_s);
  Result := (Idx <> -1);
  if Result then
    _Strings.Delete(Idx);
end;

function TStrings_DeleteStrings(_Strings: TStrings; _toDelete: TStrings): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to _toDelete.Count - 1 do
    if TStrings_DeleteString(_Strings, _toDelete[i]) then
      Inc(Result);
end;

procedure TStrings_DeleteAndFreeObject(_Strings: TStrings; _Idx: Integer);
begin
  _Strings.Objects[_Idx].Free;
  _Strings.Delete(_Idx);
end;

function TStrings_GetObjectIndex(_Strings: TStrings; _Obj: Pointer; out _Idx: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to _Strings.Count - 1 do begin
    Result := (_Strings.Objects[i] = _Obj);
    if Result then begin
      _Idx := i;
      Exit;
    end;
  end;
end;

function TStrings_Same(_sl1, _sl2: TStrings): Boolean;
var
  i: Integer;
begin
  Assert(Assigned(_sl1), 'sl1 not assigned');
  Assert(Assigned(_sl2), 'sl2 not assigned');

  Result := _sl1.Count = _sl2.Count;
  if Result then
    for i := 0 to _sl1.Count - 1 do begin
      Result := SameStr(_sl1[i], _sl2[i]);
      if not Result then
        Exit;
    end;
end;

procedure TStrings_SaveToRegistry(_sl: TStrings; const _Path: string; _HKEY: HKEY = HKEY_CURRENT_USER);
var
  Reg: TRegistry;
  i: Integer;
begin
  Reg := TRegistry.Create;
  try
    Reg.LazyWrite := False;
    Reg.RootKey := _HKEY;
    Reg.OpenKey(_Path, True);
    try
      Reg.WriteInteger('Count', _sl.Count);
      for i := 0 to _sl.Count - 1 do begin
        Reg.WriteString('Item' + IntToStr(i), _sl[i]);
      end;
    finally
      Reg.CloseKey;
    end;
  finally
    FreeAndNil(Reg);
  end;
end;

function TStrings_LoadFromRegistry(_sl: TStrings; const _Path: string; _HKEY: HKEY = HKEY_CURRENT_USER): Boolean;
var
  Reg: TRegistry;
  i: Integer;
  cnt: Integer;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := _HKEY;
    _sl.Clear;
    Result := Reg.OpenKeyReadOnly(_Path);
    if Result then begin
      try
        cnt := Reg.ReadInteger('Count');
        for i := 0 to cnt - 1 do begin
          _sl.Add(Reg.ReadString('Item' + IntToStr(i)));
        end;
      finally
        Reg.CloseKey;
      end;
    end;
  finally
    FreeAndNil(Reg);
  end;
end;

function TStrings_SameText(_sl1, _sl2: TStrings): Boolean;
var
  i: Integer;
begin
  Assert(Assigned(_sl1), 'sl1 not assigned');
  Assert(Assigned(_sl2), 'sl2 not assigned');

  Result := _sl1.Count = _sl2.Count;
  if Result then
    for i := 0 to _sl1.Count - 1 do begin
      Result := SameText(_sl1[i], _sl2[i]);
      if not Result then
        Exit;
    end;
end;

type
  TStringsUpdateInt = class(TInterfacedObject, IInterface)
  private
    FStrings: TStrings;
  public
    constructor Create(_Strings: TStrings);
    destructor Destroy; override;
  end;

function TStrings_BeginUpdate(_Strings: TStrings): IInterface;
begin
  Result := TStringsUpdateInt.Create(_Strings);
end;

function TStrings_IndexOfValue(_st: TStrings; const _Value: string): Integer;
var
  s: string;
begin
  Result := 0;
  while Result < _st.Count do begin
    s := _st.Names[Result];
    if _st.Values[s] = _Value then
      Exit; //==>
    Inc(Result);
  end;
  Result := -1;
end;

function TStream_WriteString(_Stream: TStream; const _s: string): Integer;
var
  Len: Integer;
  ErrCode: DWORD;
  s: AnsiString;
begin
  s := AnsiString(_s);
  Len := Length(s);
  Result := _Stream.Write(PAnsiChar(s)^, Len);
  if Result <> Len then begin
    ErrCode := GetLastError;
    RaiseLastOSErrorEx(ErrCode,
      Format(_('Error writing string of length %d to stream, wrote only %d bytes: %%1:s (%%0:d)'),
      [Len, Result]));
  end;
end;

function TStream_WriteShortStringBinary(_Stream: TStream; const _s: ShortString): Integer;
var
  Len: Byte;
begin
  Len := Ord(_s[0]);
  Result := _Stream.Write(Len, SizeOf(Len));
  if Len > 0 then
    Result := Result + _Stream.Write(_s[1], Len);
end;

function TStream_ReadShortStringBinary(_Stream: TStream): ShortString;
var
  Len: Byte;
begin
  _Stream.Read(Len, SizeOf(Len));
  Result[0] := AnsiChar(chr(Len));
  if Len > 0 then
    _Stream.Read(Result[1], Len);
end;

function TStream_WriteStringLn(_Stream: TStream; const _s: string): Integer;
begin
  Result := TStream_WriteString(_Stream, _s);
  Result := Result + TStream_WriteString(_Stream, #13#10);
end;

function TStream_WriteFmtLn(_Stream: TStream; const _Format: string; _Args: array of const): Integer;
begin
  Result := TStream_WriteStringLn(_Stream, Format(_Format, _Args));
end;

function TStream_ReadStringLn(_Stream: TStream; out _s: string): Integer;
var
  OldPos: Int64;
  EndString: Int64;
  NewPos: Int64;
  c: AnsiChar;
  s: AnsiString;
begin
  // twm: this is not really efficient, because it reads single bytes, if it becomes a problem, optimize it ;-)
  OldPos := _Stream.Position;
  EndString := OldPos;
  NewPos := OldPos;
  while True do begin
    if _Stream.Read(c, 1) = 0 then begin // end of file
      EndString := _Stream.Position;
      NewPos := EndString;
      Break;
    end else if (c = #13) or (c = #10) then begin
      EndString := _Stream.Position - 1;
      if _Stream.Read(c, 1) = 0 then
        NewPos := _Stream.Position
      else if c = #10 then
        NewPos := _Stream.Position
      else
        NewPos := _Stream.Position - 1;
      Break;
    end;
  end;
  Result := EndString - OldPos;
  SetLength(s, Result);
  if Result <> 0 then begin
    _Stream.Position := OldPos;
    _Stream.Read(s[1], Length(s));
    _s := string(s);
  end;
  _Stream.Position := NewPos;
end;

function TStrings_TryStringByObj(_Strings: TStrings; _Obj: Pointer; out _Value: string): Boolean;
var
  i: Integer;
begin
  for i := 0 to _Strings.Count - 1 do
    if _Strings.Objects[i] = _Obj then begin
      _Value := _Strings[i];
      Result := True;
      Exit;
    end;
  Result := False;
end;

function TStrings_StringByObj(_Strings: TStrings; _Obj: Pointer; _RaiseException: Boolean = True): string;
begin
  if not TStrings_TryStringByObj(_Strings, _Obj, Result) then begin
    if _RaiseException then
      raise EObjectNotFound.Create(_('no matching object found'));
    Result := '';
  end;
end;

function TIniFile_ReadChar(_Ini: TCustomIniFile; const _Section, _Ident: string; _Default: Char): Char;
var
  s: string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  s := _Ini.ReadString(_Section, _Ident, _Default);
  if s = '' then
    s := _Default;
  Result := s[1];
end;

function TIniFile_ReadString(_Ini: TCustomIniFile; const _Section, _Ident: string; const _Default: string; _DefaultIfEmtpy: Boolean = False): string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  Result := _Ini.ReadString(_Section, _Ident, _Default);
  if (Result = '') and _DefaultIfEmtpy then
    Result := _Default;
end;

function TIniFile_ReadString(const _Filename: string; const _Section, _Ident: string; const _Default: string; _DefaultIfEmtpy: Boolean = False): string; overload;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(_Filename);
  try
    Result := TIniFile_ReadString(Ini, _Section, _Ident, _Default, _DefaultIfEmtpy);
  finally
    FreeAndNil(Ini);
  end;
end;

function TIniFile_ReadString(_Ini: TCustomIniFile; const _Section, _Ident: string): string;
var
  ErrStr: string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  Result := _Ini.ReadString(_Section, _Ident, '');
  if Result = '' then begin
    ErrStr := Format(_('String value for [%s]%s must not be empty in ini file'), [_Section, _Ident])
      + ' ' + _Ini.Filename;
    raise Exception.Create(ErrStr);
  end;
end;

function TIniFile_ReadStrings(_Ini: TCustomIniFile; const _Section: string; _st: TStrings): Integer;
var
  i: Integer;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');
  Assert(Assigned(_st), 'Parameter "st" not assigned');

  Result := _Ini.ReadInteger(_Section, 'Count', 0);
  for i := 0 to Result - 1 do
    _st.Add(_Ini.ReadString(_Section, 'Item' + IntToStr(i), ''));
end;

procedure TIniFile_WriteStrings(_Ini: TCustomIniFile; const _Section: string; _st: TStrings);
var
  i: Integer;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');
  Assert(Assigned(_st), 'Parameter "st" not assigned');

  _Ini.WriteInteger(_Section, 'Count', _st.Count);
  for i := 0 to _st.Count - 1 do
    _Ini.WriteString(_Section, 'Item' + IntToStr(i), _st[i]);
end;

function TIniFile_TryReadFloat(_Ini: TCustomIniFile; const _Section, _Ident: string; out _Value: Extended): Boolean;
var
  s: string;
  ErrStr: string;
begin
  s := _Ini.ReadString(_Section, _Ident, '');
  Result := (s <> '');
  if Result then begin
    if not TryStr2Float(s, _Value) then begin
      ErrStr := Format(_('Invalid floating point value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
        + ' ' + _Ini.Filename;
      raise EStringConvertError.Create(ErrStr);
    end;
  end;
end;

function TIniFile_ReadFloat(_Ini: TCustomIniFile; const _Section, _Ident: string; out _Value: Extended): Boolean;
begin
  // deprecated, use TIniFile_TryReadFloat instead
  Result := TIniFile_TryReadFloat(_Ini, _Section, _Ident, _Value);
end;

function TIniFile_ReadFloat(_Ini: TCustomIniFile; const _Section, _Ident: string): Extended;
var
  s: string;
  ErrStr: string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  s := _Ini.ReadString(_Section, _Ident, '');
  if not TryStr2Float(s, Result) then begin
    ErrStr := Format(_('Invalid floating point value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
      + ' ' + _Ini.Filename;
    raise EStringConvertError.Create(ErrStr);
  end;
end;

procedure TIniFile_WriteFloat(_Ini: TCustomIniFile; const _Section, _Ident: string; _Value: Extended);
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  _Ini.WriteString(_Section, _Ident, Float2Str(_Value));
end;

function TIniFile_TryReadDate(_Ini: TCustomIniFile; const _Section, _Ident: string; out _Value: TDateTime): Boolean;
var
  s: string;
  ErrStr: string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  s := _Ini.ReadString(_Section, _Ident, '');
  Result := (s <> '');
  if Result then begin
    if not TryIso2Date(s, _Value) then begin
      ErrStr := Format(_('Invalid date value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
        + ' ' + _Ini.Filename;
      raise EStringConvertError.Create(ErrStr);
    end;
  end;
end;

function TIniFile_ReadDate(_Ini: TCustomIniFile; const _Section, _Ident: string): TDateTime;
var
  s: string;
  ErrStr: string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  s := _Ini.ReadString(_Section, _Ident, '');
  if not TryIso2Date(s, Result) then begin
    ErrStr := Format(_('Invalid date value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
      + ' ' + _Ini.Filename;
    raise EStringConvertError.Create(ErrStr);
  end;
end;

procedure TIniFile_WriteDate(_Ini: TCustomIniFile; const _Section, _Ident: string; const _Value: TDateTime);
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  _Ini.WriteString(_Section, _Ident, DateTime2Iso(_Value));
end;

function TIniFile_TryReadInt(const _Filename: string; const _Section, _Ident: string; out _Value: Integer): Boolean;
var
  s: string;
  ErrStr: string;
begin
  s := TIniFile_ReadString(_Filename, _Section, _Ident, '');
  Result := (s <> '');
  if Result then begin
    if not TryStrToInt(s, _Value) then begin
      ErrStr := Format(_('Invalid integer value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
        + ' ' + _Filename;
      raise EStringConvertError.Create(ErrStr);
    end;
  end;
end;

function TIniFile_TryReadInt(_Ini: TCustomIniFile; const _Section, _Ident: string; out _Value: Integer): Boolean;
var
  s: string;
  ErrStr: string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  s := _Ini.ReadString(_Section, _Ident, '');
  Result := (s <> '');
  if Result then begin
    if not TryStrToInt(s, _Value) then begin
      ErrStr := Format(_('Invalid integer value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
        + ' ' + _Ini.FileName;
      raise EStringConvertError.Create(ErrStr);
    end;
  end;
end;

function TIniFile_ReadInt(const _Filename: string; const _Section, _Ident: string): Integer;
var
  s: string;
  ErrStr: string;
begin
  s := TIniFile_ReadString(_Filename, _Section, _Ident, '');
  if not TryStrToInt(s, Result) then begin
    ErrStr := Format(_('Invalid integer value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
      + ' ' + _Filename;
    raise EStringConvertError.Create(ErrStr);
  end;
end;

function TIniFile_ReadInt(_Ini: TCustomIniFile; const _Section, _Ident: string): Integer;
var
  s: string;
  ErrStr: string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  s := _Ini.ReadString(_Section, _Ident, '');
  if not TryStrToInt(s, Result) then begin
    ErrStr := Format(_('Invalid integer value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
      + ' ' + _Ini.Filename;
    raise EStringConvertError.Create(ErrStr);
  end;
end;

function TIniFile_ReadInt(const _Filename: string; const _Section, _Ident: string; _Default: Integer): Integer;
var
  s: string;
  ErrStr: string;
begin
  s := TIniFile_ReadString(_Filename, _Section, _Ident, '');
  if s = '' then
    Result := _Default
  else if not TryStrToInt(s, Result) then
    ErrStr := Format(_('Invalid integer value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
      + ' ' + _Filename;
  raise EStringConvertError.Create(ErrStr);
end;

function TIniFile_ReadInt(_Ini: TCustomIniFile; const _Section, _Ident: string; _Default: Integer): Integer;
var
  s: string;
  ErrStr: string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  s := _Ini.ReadString(_Section, _Ident, '');
  if s = '' then
    Result := _Default
  else if not TryStrToInt(s, Result) then begin
    ErrStr := Format(_('Invalid integer value "%s" for [%s]\%s in ini file'), [s, _Section, _Ident])
      + ' ' + _Ini.Filename;
    raise EStringConvertError.Create(ErrStr);
  end;
end;

function TIniFile_SectionExists(const _Filename: string; const _Section: string): Boolean;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(_Filename);
  try
    Result := Ini.SectionExists(_Section);
  finally
    FreeAndNil(Ini);
  end;
end;

procedure TIniFile_ClearSection(_Ini: TCustomIniFile; const _Section: string);
var
  sl: TStringList;
  i: Integer;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  sl := TStringList.Create;
  try
    _Ini.ReadSection(_Section, sl);
    for i := 0 to sl.Count - 1 do
      _Ini.DeleteKey(_Section, sl[i]);
  finally
    FreeAndNil(sl);
  end;
end;

procedure TIniFile_WriteSectionValues(_Ini: TCustomIniFile; const _Section: string; _sl: TStrings);
var
  i: Integer;
  Key: string;
begin
  Assert(Assigned(_Ini), 'Parameter "INI" not assigned');

  TIniFile_ClearSection(_Ini, _Section);
  for i := 0 to _sl.Count - 1 do begin
    Key := _sl.Names[i];
    _Ini.WriteString(_Section, Key, _sl.Values[Key]);
  end;
end;

procedure TIniFile_ReadSectionKeys(const _Filename, _Section: string; _sl: TStrings);
var
  Ini: TMemIniFile;
  ErrStr: string;
begin
  Ini := TMemIniFile.Create(_Filename);
  try
    if not Ini.SectionExists(_Section) then begin
      ErrStr := Format(_('Section "%s" does not exist in ini file'), [_Section])
        + ' ' + _Filename;
      raise Exception.Create(ErrStr);
    end;
    Ini.ReadSection(_Section, _sl);
  finally
    FreeAndNil(Ini);
  end;
end;

procedure TIniFile_ReadSectionValues(const _Filename, _Section: string; _sl: TStrings); inline;
var
  Ini: TMemIniFile;
  ErrStr: string;
begin
  Ini := TMemIniFile.Create(_Filename);
  try
    if not Ini.SectionExists(_Section) then begin
      ErrStr := Format(_('Section "%s" does not exist in ini file'), [_Section])
        + ' ' + _Filename;
      raise Exception.Create(ErrStr);
    end;
    Ini.ReadSectionValues(_Section, _sl);
  finally
    FreeAndNil(Ini);
  end;
end;

{ TStringsUpdateInt }

constructor TStringsUpdateInt.Create(_Strings: TStrings);
begin
  inherited Create;
  FStrings := _Strings;
  FStrings.BeginUpdate;
end;

destructor TStringsUpdateInt.Destroy;
begin
  if Assigned(FStrings) then
    FStrings.EndUpdate;
  inherited;
end;

{ TRegistry_Xxxx functions }

function TRegistry_Hkey2String(_HKEY: HKEY; _Short: Boolean = False): string;
begin
  if _HKEY = HKEY_CLASSES_ROOT then begin
    Result := 'HKEY_CLASSES_ROOT';
  end else if _HKEY = HKEY_CURRENT_USER then begin
    if _Short then
      Result := 'HKCU'
    else
      Result := 'HKEY_CURRENT_USER';
  end else if _HKEY = HKEY_LOCAL_MACHINE then begin
    if _Short then
      Result := 'HKLM'
    else
      Result := 'HKEY_LOCAL_MACHINE';
  end else if _HKEY = HKEY_USERS then begin
    Result := 'HKEY_USERS'
  end else if _HKEY = HKEY_PERFORMANCE_DATA then begin
    Result := 'HKEY_PERFORMANCE_DATA';
  end else if _HKEY = HKEY_CURRENT_CONFIG then begin
    Result := 'HKEY_CURRENT_CONFIG';
  end else if _HKEY = HKEY_DYN_DATA then begin
    Result := 'HKEY_DYN_DATA';
  end else
    raise Exception.CreateFmt(_('Unknown HKEY value $%.8x'), [_HKEY]);
end;

type
  TRegistryGuard = class(TInterfacedObject, IRegistryGuard)
  private
    FReg: TRegistry;
  private // IRegistryGuard
    function IsValid: Boolean;
    function Reg: TRegistry;
    function TryReadString(const _Item: string; out _Value: string): Boolean;
    function ReadStringDef(const _Item: string; const _Default: string): string;
    procedure WriteString(const _Item: string; const _Value: string);
    function TryReadStringList(const _SubPath: string; const _sl: TStrings;
      const _ClearFirst: Boolean; const _ItemName: string): Boolean;
    procedure WriteStringList(const _SubPath: string; const _sl: TStrings;
      const _ItemName: string = 'Item');
    function TryReadInteger(const _Item: string; out _Value: Integer): Boolean;
    function ReadIntegerDef(const _Item: string; const _Default: Integer): Integer;
    procedure WriteInteger(const _Item: string; _Value: Integer);
  public
    constructor Create(_Reg: TRegistry);
    destructor Destroy; override;
  end;

constructor TRegistryGuard.Create(_Reg: TRegistry);
begin
  inherited Create;
  FReg := _Reg;
end;

destructor TRegistryGuard.Destroy;
begin
  if Assigned(FReg) then
    FReg.CloseKey;
  FreeAndNil(FReg);

  inherited Destroy;
end;

function TRegistryGuard.IsValid: Boolean;
begin
  Result := Assigned(FReg);
end;

function TRegistryGuard.Reg: TRegistry;
begin
  Result := FReg;
end;

function TRegistryGuard.ReadIntegerDef(const _Item: string; const _Default: Integer): Integer;
begin
  if not TryReadInteger(_Item, Result) then
    Result := _Default;
end;

function TRegistryGuard.ReadStringDef(const _Item, _Default: string): string;
begin
  if not IsValid or not TryReadString(_Item, Result) then
    Result := _Default;
end;

function TRegistryGuard.TryReadStringList(const _SubPath: string; const _sl: TStrings;
  const _ClearFirst: Boolean; const _ItemName: string): Boolean;
var
  SubReg: TRegistry;
  Path: string;
  cnt: Integer;
  i: Integer;
  ItemName: string;
begin
  _sl.BeginUpdate;
  try
    if _ClearFirst then
      _sl.Clear;

    Result := IsValid and Reg.KeyExists(_SubPath);
    if not Result then
      Exit; // -->

    Path := Reg.CurrentPath + '\' + _SubPath;
    SubReg := TRegistry.Create;
    try
      SubReg.RootKey := Reg.RootKey;
      Result := SubReg.OpenKeyReadOnly(Path);
      if not Result then
        Exit; // -->
      try
        Result := SubReg.ValueExists('Count');
        if not Result then
          Exit; // -->

        cnt := SubReg.ReadInteger('Count');
        if cnt = 0 then begin
        // The list exists but is empty, so we return true, but an empty/unchanged list
          Exit; // -->
        end;
        for i := 0 to cnt - 1 do begin
          ItemName := _ItemName + IntToStr(i);
          if SubReg.ValueExists(ItemName) then
            _sl.Add(SubReg.ReadString(ItemName))
          else
            _sl.Add('');
        end;
      finally
        SubReg.CloseKey;
      end;
    finally
      FreeAndNil(SubReg);
    end;
  finally
    _sl.EndUpdate;
  end;
end;

procedure TRegistryGuard.WriteStringList(const _SubPath: string; const _sl: TStrings;
  const _ItemName: string);
var
  SubReg: TRegistry;
  Path: string;
  i: Integer;
  ItemName: string;
begin
  if not IsValid then
    Exit; // -->

  Path := Reg.CurrentPath + '\' + _SubPath;
  SubReg := TRegistry.Create;
  try
    SubReg.RootKey := Reg.RootKey;
    if not SubReg.OpenKey(Path, True) then
      Exit; // -->
    try
      SubReg.WriteInteger('Count', _sl.Count);
      for i := 0 to _sl.Count - 1 do begin
        ItemName := _ItemName + IntToStr(i);
        SubReg.WriteString(ItemName, _sl[i]);
      end;
    finally
      SubReg.CloseKey;
    end;
  finally
    FreeAndNil(SubReg);
  end;
end;

function TRegistryGuard.TryReadInteger(const _Item: string; out _Value: Integer): Boolean;
begin
  Result := FReg.ValueExists(_Item);
  if Result then
    _Value := FReg.ReadInteger(_Item)
end;

function TRegistryGuard.TryReadString(const _Item: string; out _Value: string): Boolean;
begin
  Result := IsValid and FReg.ValueExists(_Item);
  if Result then
    _Value := FReg.ReadString(_Item)
end;

procedure TRegistryGuard.WriteInteger(const _Item: string; _Value: Integer);
begin
  FReg.WriteInteger(_Item, _Value);
end;

procedure TRegistryGuard.WriteString(const _Item, _Value: string);
begin
  if IsValid then
    FReg.WriteString(_Item, _Value);
end;

function TRegistry_TryOpenKeyReadonly(const _Key: string; _HKEY: HKEY = HKEY_CURRENT_USER): IRegistryGuard;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := _HKEY;
  if not Reg.OpenKeyReadOnly(_Key) then
    FreeAndNil(Reg);
  Result := TRegistryGuard.Create(Reg);
end;

function TRegistry_OpenKeyReadonly(const _Key: string; _HKEY: HKEY = HKEY_CURRENT_USER): IRegistryGuard;
begin
  Result := TRegistry_TryOpenKeyReadonly(_Key, _HKEY);

  if not Result.IsValid then
    raise Exception.CreateFmt(_('Could not open registry key "%s\%s"'),
      [TRegistry_Hkey2String(_HKEY), _Key]);
end;

function TRegistry_OpenKey(const _Key: string; _HKEY: HKEY = HKEY_CURRENT_USER): IRegistryGuard;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := _HKEY;
  if not Reg.OpenKey(_Key, True) then begin
    FreeAndNil(Reg);
    raise Exception.CreateFmt(_('Could not open registry key "%s\%s"'),
      [TRegistry_Hkey2String(_HKEY), _Key]);
  end;
  Result := TRegistryGuard.Create(Reg);
end;

function TRegistry_TryReadString(const _Path: string; out _Value: string;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean;
var
  Key: string;
  Item: string;
begin
  Key := ExtractFileDir(_Path);
  Item := ExtractFileName(_Path);
  Result := TRegistry_TryReadString(Key, Item, _Value, _HKEY);
end;

function TRegistry_TryReadString(const _Key: string; const _Entry: string; out _Value: string;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean;
var
  Guard: IRegistryGuard;
begin
  Guard := TRegistry_TryOpenKeyReadonly(_Key, _HKEY);
  Result := Guard.IsValid and Guard.Reg.ValueExists(_Entry);
  if not Result then
    Exit;
  _Value := Guard.Reg.ReadString(_Entry)
end;

function TRegistry_ReadString(const _Path: string; const _Default: string = '';
  _HKEY: HKEY = HKEY_CURRENT_USER): string;
var
  Key: string;
  Item: string;
begin
  Key := ExtractFileDir(_Path);
  Item := ExtractFileName(_Path);
  if not TRegistry_TryReadString(Key, Item, Result, _HKEY) then
    Result := _Default;
end;

function TRegistry_ReadString(const _Key: string; const _Entry: string; const _Default: string = '';
  _HKEY: HKEY = HKEY_CURRENT_USER): string; overload;
begin
  if not TRegistry_TryReadString(_Key, _Entry, Result, _HKEY) then
    Result := _Default;
end;

function TRegistry_TryReadStringValues(const _Path: string; _Entries: TStringList;
  _HKEY: HKEY = HKEY_CURRENT_USER): Boolean;
var
  Item: string;
  Guard: IRegistryGuard;
  ValueNames: TStringList;
  i: Integer;
  Value: string;
begin
  Result := False;
  Guard := TRegistry_TryOpenKeyReadonly(_Path, _HKEY);
  if not Guard.IsValid then
    Exit; // -->
  ValueNames := TStringList.Create;
  try
    Guard.Reg.GetValueNames(ValueNames);
    for i := 0 to ValueNames.Count - 1 do begin
      Item := ValueNames[i];
      Value := Guard.Reg.ReadString(Item);
      _Entries.Values[Item] := Value;
    end;
    Result := True;
  finally
    FreeAndNil(ValueNames);
  end;
end;

procedure TRegistry_WriteString(const _Key: string; const _Item: string; const _Value: string;
  _HKEY: HKEY = HKEY_CURRENT_USER);
var
  Guard: IRegistryGuard;
begin
  Guard := TRegistry_OpenKey(_Key, _HKEY);
  Guard.Reg.WriteString(_Item, _Value);
end;

procedure TRegistry_WriteString(const _Path: string; const _Value: string;
  _HKEY: HKEY = HKEY_CURRENT_USER);
var
  Key: string;
  Item: string;
begin
  Key := ExtractFileDir(_Path);
  Item := ExtractFileName(_Path);
  TRegistry_WriteString(Key, Item, _Value, _HKEY);
end;

procedure TRegistry_DeleteValue(const _Key: string; const _Item: string; _HKEY: HKEY = HKEY_CURRENT_USER);
var
  Guard: IRegistryGuard;
begin
  Guard := TRegistry_OpenKey(_Key, _HKEY);
  Guard.Reg.DeleteValue(_Item);
end;

type
  TObjectGuard = class(TInterfacedObject, IInterface)
  private
    FObject: TObject;
  public
    constructor Create(_Obj: TObject);
    destructor Destroy; override;
  end;

function StringListOf(const _sa: array of string; out _Guard: IInterface): TStringList;
var
  s: string;
begin
  Result := TStringList.Create;
  _Guard := TObjectGuard.Create(Result);
  for s in _sa do
    Result.Add(s);
end;

{ TObjectGuard }

constructor TObjectGuard.Create(_Obj: TObject);
begin
  inherited Create;
  FObject := _Obj;
end;

destructor TObjectGuard.Destroy;
begin
  FreeAndNil(FObject);
  inherited;
end;

end.
