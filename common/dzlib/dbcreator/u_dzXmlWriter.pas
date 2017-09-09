{.GXFormatter.config=twm}
///<summary> defines a simple object to write XML files (no headers) </summary>
unit u_dzXmlWriter;

interface

uses
  Sysutils,
  Classes,
  TypInfo,
  u_dzMiscUtils,
  u_dzStringUtils,
  u_dzClassUtils,
  u_dzXmlWriterInterface,
  u_dzNameValueList;

type
  EXmlWriter = class(Exception);
  EInvalidEncoding = class(EXmlWriter);
  ECDataError = class(EXmlWriter);

type
  TXmlEncoding = (xeUtf8, xeWindows);

type
  ///<summary> simple object to write XML files
  ///          Note that these files do not have a header and therefore are not really
  ///          valid XML. </summary>
  TdzXmlWriter = class(TInterfacedObject, IdzXmlWriter)
  protected
    ///<summary> stores the amount of spaces for each indention level</summary>
    FDelta: integer;
    ///<summary> stores the stream to write to </summary>
    FStream: TStream;
    ///<summary> stores the indentation level </summary>
    FIndent: integer;
    ///<summary> true, if this object owns the stream an should free it</summary>
    FOwnsStream: boolean;
    ///<summary> whether to use utf8 or Windows character set </summary>
    FXmlEncoding: TXmlEncoding;
    ///<summary> true, if we are in a cdata segment. </summary> 
    FInCdata: boolean;
    ///<summary> stores the indentation, while in a cdata segment </summary>
    FIndentBackup: integer;
    ///<summary> adds an attribute to the end of an attributes string </summary>
    procedure AddAttribute(var _Attributes: string; const _Name, _Value: string);
    ///<summary> Creates a string containing 'name="value"' for each pairs of strings in
    ///          Args. </summary>
    function CreateAttribString(const _Attribs: array of string): string; overload;
    function CreateAttribString(_Attribs: TStrings): string; overload;
    ///<summary> @italic(Note: With this function, the attributes will always be sorted) </summary>
    function CreateAttribString(_Attribs: TNameValueList): string; overload;
    ///<summary> same as CreateAttribString, but excpects the attributes to be stored as name=value pairs in the stringlist
    ///          @italic(Note: If you add a name with an empty value to a stringlist, the class will
    ///          ignore this entry or remove an existing entry, e.g.:
    ///          sl.Values['aname'] := '' will result in a list without
    ///          aname in it, NOT in a list with an 'aname=' line.
    ///          So be carefull when using this method for required attributes!) </summary>
    function CreateAttribString2(_Attribs: TStrings): string;
  public
    ///<summary> Creates a TdzXmlWriter object
    ///          @param Stream is a TStream to write to. Note that this stream is not
    ///                 freed, when the TdzXmlWriter is destroyed unless
    ///                 OwnsStream is false.
    ///          @param Delta is an integer specifying the number of spaces to use for
    ///                 indentation
    ///          @param OwnsStream is a boolean specifying whether the sream passed in the
    ///                 Stream parameter is owned by this object and therefore
    ///                 should be freed in the destructor. </summary>
    constructor Create(_Stream: TStream; _Delta: integer = 2;
      _OwnsStream: boolean = true; _Encoding: TXmlEncoding = xeUtf8);
    ///<summary> Release the attached stream (if OwnsStream = true in Constructor).</summary>
    destructor Destroy; override;
    ///<summary> Does a WriteLn to the stream </summary>
    procedure WriteLine(const _Line: string);
    ///<summary> combines WriteLn and Format </summary>
    procedure WriteLineFmt(const _Format: string; _Args: array of const);
    ///<summary> starts a XML Entity by writing '<name attribname="attribvalue"... >'
    ///          to the stream
    ///          @param Name is a string specifying the name of the entity
    ///          @param Attribs is an array of string specifying alternatingly the
    ///                 name and the value of attributes like this:
    ///                 ['name1', 'value1', 'name2', 'value2'] </summary>
    procedure StartEntity(const _Name: string; const _Attribs: array of string); overload;
    ///<summary> @italic(Note: With this function, the attributes will always be sorted) </summary>
    procedure StartEntity(const _Name: string; _Attribs: TNameValueList); overload;
    ///<summary> Same as StartEntity but excpects the attributes to be stored as name=value pairs in the stringlist
    ///          @italic(Note: If you add a name with an empty value to a stringlist, the class will
    ///          ignore this entry or remove an existing entry, e.g.:
    ///          sl.Values['aname'] := '' will result in a list without
    ///          aname in it, NOT in a list with an 'aname=' line.
    ///          So be carefull when using this method for required attributes!) </summary>
    procedure StartEntity2(const _Name: string; _Attribs: TStrings);
    ///<summary> ends a XML Entity by writing '</name>' to the stream
    ///          @param Name is a string specifying the name of the entity. Note that
    ///          the object does not verify that there is an opening tag
    ///          for this entity. </summary>
    procedure EndEntity(const _Name: string);
    ///<summary> writes a XML Entity in the form '<name attribname="attribvalue"... />'
    ///          to the stream
    ///          @param Name is a string specifying the name of the entity
    ///          @param Attribs is an array of string specifying alternatingly the
    ///                 name and the value of attributes like this:
    ///                 ['name1', 'value1', 'name2', 'value2'] </summary>
    procedure WriteEntity(const _Name: string; const _Attribs: array of string); overload;
    procedure WriteEntity(const _Name: string; _Attribs: TNameValueList); overload;
    ///<summary> Same as WriteEntity but excpects the attributes to be stored as name=value pairs in the stringlist
    ///          @italic(Note: If you add a name with an empty value to a stringlist, the class will
    ///          ignore this entry or remove an existing entry, e.g.:
    ///          sl.Values['aname'] := '' will result in a list without
    ///          aname in it, NOT in a list with an 'aname=' line.
    ///          So be carefull when using this method for required attributes!) </summary>
    procedure WriteEntity2(const _Name: string; _Attribs: TStrings); overload;
    ///<summary> writes a standard XML header <?xml ... </summary>
    procedure WriteHeader;
    ///<summary> starts a CDATA section within the xml file for storing verbatim text </summary>
    procedure StartCdata;
    ///<summary> ends a CDATA section started with StartCdata </summary>
    procedure EndCdata;
    ///<summary> calls StartCdata, writes the line and calls EndCdata </summary>
    procedure WriteCdataLine(const _Line: string);
    class function CharToXML(const _s: string): string;
    class function XmlToChar(const _s: string): string;
  end;

implementation

uses
  StrUtils,
  u_dzXmlUtils;

{ TdzXmlWriter }

constructor TdzXmlWriter.Create(_Stream: TStream; _Delta: integer = 2;
  _OwnsStream: boolean = true; _Encoding: TXmlEncoding = xeUtf8);
begin
  inherited Create;
  FDelta := _Delta;
  if FDelta < 0 then
    FDelta := 0;
  FStream := _Stream;
  FOwnsStream := _OwnsStream;
  FXmlEncoding := _Encoding;
  FInCdata := false;
end;

procedure TdzXmlWriter.WriteLine(const _Line: string);
var
  utf8: string;
begin
  if FXmlEncoding = xeWindows then
    TStream_WriteStringLn(FStream, DupeString(' ', FIndent) + _Line)
  else begin
    utf8 := AnsiToUtf8(DupeString(' ', FIndent) + _Line);
    TStream_WriteStringLn(FStream, utf8);
  end;
end;

procedure TdzXmlWriter.WriteLineFmt(const _Format: string; _Args: array of const);
begin
  WriteLine(Format(_Format, _Args));
end;

procedure TdzXmlWriter.AddAttribute(var _Attributes: string; const _Name, _Value: string);
begin
  if _Attributes <> '' then
    _Attributes := _Attributes + ' ';
  _Attributes := _Attributes + Format('%s="%s"', [_Name, XmlStringEscape(_Value)]);
end;

function TdzXmlWriter.CreateAttribString(const _Attribs: array of string): string;
var
  i: integer;
  Name, Value: string;
begin
  Result := '';
  if Length(_Attribs) > 1 then begin
    for i := 0 to High(_Attribs) div 2 do begin
      Name := _Attribs[i * 2];
      Value := _Attribs[i * 2 + 1];
      AddAttribute(Result, Name, Value);
    end;
  end;
end;

function TdzXmlWriter.CreateAttribString(_Attribs: TStrings): string;
var
  i: integer;
  Name, Value: string;
begin
  Result := '';
  if _Attribs.Count > 1 then begin
    for i := 0 to _Attribs.Count div 2 - 1 do begin
      Name := _Attribs[i * 2];
      Value := _Attribs[i * 2 + 1];
      AddAttribute(Result, Name, Value);
    end;
  end;
end;

function TdzXmlWriter.CreateAttribString(_Attribs: TNameValueList): string;
var
  i: integer;
  Name, Value: string;
begin
  Result := '';
  for i := 0 to _Attribs.Count - 1 do begin
    Name := _Attribs[i].Name;
    Value := _Attribs[i].Value;
    AddAttribute(Result, Name, Value);
  end;
end;

function TdzXmlWriter.CreateAttribString2(_Attribs: TStrings): string;
var
  i: integer;
  Name, Value: string;
begin
  Result := '';
  for i := 0 to _Attribs.Count - 1 do begin
    Name := _Attribs.Names[i];
    Value := _Attribs.Values[Name];
    AddAttribute(Result, Name, Value);
  end;
end;

procedure TdzXmlWriter.StartEntity(const _Name: string; const _Attribs: array of string);
begin
  WriteLineFmt('<%s %s>', [_Name, CreateAttribString(_Attribs)]);
  Inc(FIndent, FDelta);
end;

procedure TdzXmlWriter.StartEntity(const _Name: string; _Attribs: TNameValueList);
begin
  WriteLineFmt('<%s %s>', [_Name, CreateAttribString(_Attribs)]);
  Inc(FIndent, FDelta);
end;

procedure TdzXmlWriter.StartEntity2(const _Name: string; _Attribs: TStrings);
begin
  WriteLineFmt('<%s %s>', [_Name, CreateAttribString2(_Attribs)]);
  Inc(FIndent, FDelta);
end;

procedure TdzXmlWriter.EndEntity(const _Name: string);
begin
  Dec(FIndent, FDelta);
  WriteLine(Format('</%s>', [_Name]));
end;

procedure TdzXmlWriter.WriteEntity(const _Name: string; const _Attribs: array of string);
begin
  WriteLineFmt('<%s %s/>', [_Name, CreateAttribString(_Attribs)]);
end;

procedure TdzXmlWriter.WriteEntity(const _Name: string; _Attribs: TNameValueList);
begin
  WriteLineFmt('<%s %s/>', [_Name, CreateAttribString(_Attribs)]);
end;

procedure TdzXmlWriter.WriteEntity2(const _Name: string; _Attribs: TStrings);
begin
  WriteLineFmt('<%s %s/>', [_Name, CreateAttribString2(_Attribs)]);
end;

procedure TdzXmlWriter.WriteHeader;
begin
  case FXmlEncoding of
    xeUtf8: WriteLine('<?xml version="1.0" encoding="UTF-8"?>');
    xeWindows: WriteLine('<?xml version="1.0" encoding="WINDOWS-1252"?>');
  else
    raise EInvalidEncoding.CreateFmt('Invalid encoding %s', [GetEnumName(TypeInfo(TXmlEncoding), Ord(FXmlEncoding))]);
  end;
end;

class function TdzXmlWriter.CharToXML(const _s: string): string;
begin
  Result := XmlStringEscape(_s);
end;

class function TdzXmlWriter.XmlToChar(const _s: string): string;
begin
  Result := XmlStringUnEscape(_s);
end;

destructor TdzXmlWriter.Destroy;
begin
  if FOwnsStream then
    FStream.Free;
  inherited;
end;

procedure TdzXmlWriter.EndCdata;
begin
  if not FInCdata then
    raise ECDataError.Create('Not in a CData segment');

  WriteLine(']]>');
  FInCdata := false;
  FIndent := FIndentBackup;
end;

procedure TdzXmlWriter.StartCdata;
begin
  if FInCdata then
    raise ECDataError.Create('Already in a CData segment');

  FIndentBackup := FIndent;
  FIndent := 0;

  WriteLine('<![CDATA[');
  FInCdata := true;
end;

procedure TdzXmlWriter.WriteCdataLine(const _Line: string);
begin
  if FInCdata then
    WriteLine(_Line)
  else
    raise ECDataError.CreateFmt('Not in CData segment, could not write: %s', [_Line]);
end;

end.

