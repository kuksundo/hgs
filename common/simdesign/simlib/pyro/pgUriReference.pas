{ Project: Pyro
  Module: Pyro Formats

  Description:
  Parsing and loading of URI reference. See RFC2396

  From appendix A:

      URI-reference = [ absoluteURI | relativeURI ] [ "#" fragment ]
      absoluteURI   = scheme ":" ( hier_part | opaque_part )
      relativeURI   = ( net_path | abs_path | rel_path ) [ "?" query ]

      hier_part     = ( net_path | abs_path ) [ "?" query ]
      opaque_part   = uric_no_slash *uric

      uric_no_slash = unreserved | escaped | ";" | "?" | ":" | "@" |
                      "&" | "=" | "+" | "$" | ","

      net_path      = "//" authority [ abs_path ]
      abs_path      = "/"  path_segments
      rel_path      = rel_segment [ abs_path ]

      rel_segment   = 1*( unreserved | escaped |
                          ";" | "@" | "&" | "=" | "+" | "$" | "," )

      scheme        = alpha *( alpha | digit | "+" | "-" | "." )

      authority     = server | reg_name

      reg_name      = 1*( unreserved | escaped | "$" | "," |
                          ";" | ":" | "@" | "&" | "=" | "+" )

      server        = [ [ userinfo "@" ] hostport ]
      userinfo      = *( unreserved | escaped |
                         ";" | ":" | "&" | "=" | "+" | "$" | "," )

      hostport      = host [ ":" port ]
      host          = hostname | IPv4address
      hostname      = *( domainlabel "." ) toplabel [ "." ]
      domainlabel   = alphanum | alphanum *( alphanum | "-" ) alphanum
      toplabel      = alpha | alpha *( alphanum | "-" ) alphanum
      IPv4address   = 1*digit "." 1*digit "." 1*digit "." 1*digit
      port          = *digit

      path          = [ abs_path | opaque_part ]
      path_segments = segment *( "/" segment )
      segment       = *pchar *( ";" param )
      param         = *pchar
      pchar         = unreserved | escaped |
                      ":" | "@" | "&" | "=" | "+" | "$" | ","

      query         = *uric

      fragment      = *uric

      uric          = reserved | unreserved | escaped
      reserved      = ";" | "/" | "?" | ":" | "@" | "&" | "=" | "+" |
                      "$" | ","
      unreserved    = alphanum | mark
      mark          = "-" | "_" | "." | "!" | "~" | "*" | "'" |
                      "(" | ")"

      escaped       = "%" hex hex
      hex           = digit | "A" | "B" | "C" | "D" | "E" | "F" |
                              "a" | "b" | "c" | "d" | "e" | "f"

      alphanum      = alpha | digit
      alpha         = lowalpha | upalpha

      lowalpha = "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" |
                 "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" |
                 "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
      upalpha  = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" |
                 "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" |
                 "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"
      digit    = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" |
                 "8" | "9"

  Creation Date:
  16oct2005

  Modified:
  19may2011: string > Utf8String

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2005 - 2011 SimDesign BV
}
unit pgUriReference;

interface

uses
  Classes, SysUtils,
  // simdesign
  NativeXml,
  // pyro
  pgDocument, pgParser;

type

  TpgSchemeType = (
    stUnknown,
    stFile,
    stData,
    stHttp,
    stFtp
  );

const

  cpgSchemeTypeNames: array[TpgSchemeType] of Utf8String =
    ('unknown', 'file', 'data', 'http', 'ftp');

type

  // URI reference parser and loader
  TpgUriReference = class(TPersistent)
  private
    FScheme: Utf8String;
    FAuthority: Utf8String;
    FPath: Utf8String;
    FFragment: Utf8String;
    FQuery: Utf8String;
    FIsAbsolute: boolean;
  protected
    procedure DecomposeUri(AUri: Utf8String; var Scheme, Authority, Path, Fragment, Query: Utf8String; var IsAbsolute: boolean);
    function SchemeTypeFromScheme(const AScheme: Utf8String): TpgSchemeType;
    procedure TranslateContent(const Data: Utf8String; S: TStream; var MimeType: Utf8String);
  public
    class function ExtensionToMimeType(AExt: Utf8String): Utf8String;
    procedure Parse(const ARef, ABase: Utf8String);
    procedure LoadResource(S: TStream; var MimeType: Utf8String);
    function AbsoluteReference: Utf8String;
    function RelativeReference(const ABase: Utf8String): Utf8String;
    property Scheme: Utf8String read FScheme;
    property Authority: Utf8String read FAuthority;
    property Path: Utf8String read FPath;
    property Query: Utf8String read FQuery;
    property Fragment: Utf8String read FFragment;
  end;

function GetUriFragment(ARef: Utf8String): Utf8String;

function UriEncode(const AValue: Utf8String): Utf8String;

function UriDecode(const AValue: Utf8String): Utf8String;

resourcestring

  sUnsupportedUriScheme     = 'Unsupported URI scheme "%s"';
  sUnsupportedEncodingInUri = 'Unsupported encoding "%s" in URI';

const
  cUriUnreserved =
    ['a'..'z', 'A'..'Z', '0'..'9',
     '-', '_', '.', '!', '~', '*', '''', '(', ')'];

implementation

function GetUriFragment(ARef: Utf8String): Utf8String;
begin
  Result := '';
  if length(ARef) = 0 then
    exit;
  if ARef[1] = '#' then
    Result := copy(ARef, 2, length(ARef));
end;

function UriEncode(const AValue: Utf8String): Utf8String;
// any non-allowed characters are encoded with %XX
var
  i: integer;
begin
  Result := '';
  for i := 1 to length(AValue) do
  begin
    if AValue[i] in cUriUnreserved then
      Result := Result + AValue[i]
    else
      Result := Result + '%' + IntToHex(ord(AValue[i]), 2);
  end;
end;

function UriDecode(const AValue: Utf8String): Utf8String;
var
  i: integer;
begin
  Result := '';
  i := 1;
  while i <= length(AValue) do
  begin
    if AValue[i] = '%' then
    begin
      Result := Result + chr(StrToInt('$' + copy(AValue, i + 1, 2)));
      inc(i, 2);
    end else
      Result := Result + AValue[i];
    inc(i);
  end;
end;

{ TpgUriReference }

function TpgUriReference.AbsoluteReference: Utf8String;
begin
  Result := '';
  if FIsAbsolute then
  begin
    if length(FScheme) > 0 then
      Result := FScheme + ':';
    if length(FAuthority) > 0 then
    begin
      Result := Result + '//' + FAuthority;
      if (length(FPath) = 0) or (FPath[1] <> '/') then
        Result := Result + '/';
    end;
  end;
  Result := Result + FPath;
  if length(FFragment) > 0 then
    Result := Result + '#' + FFragment;
end;

procedure TpgUriReference.DecomposeUri(AUri: Utf8String; var Scheme, Authority,
  Path, Fragment, Query: Utf8String; var IsAbsolute: boolean);
var
  S: Utf8String;
begin
  Scheme := '';
  Authority := '';
  Path := '';
  Query := '';
  IsAbsolute := False;

  // Separate base string and fragment
  S := BreakString(AUri, '#', Fragment, False, False);

  // Base string can be absolute or relative reference
  if pos(':', S) > 0 then
  begin

    // absolute uri
    IsAbsolute := True;
    Scheme := lowercase(BreakString(S, ':', S, False, True));
    // hierarchical or opaque
    if (length(S) > 0) and (S[1] = '/') then
    begin
      // hierarchical
      S := BreakString(S, '?', Query, False, False);
      // net path?
      if copy(S, 1, 2) = '//' then
      begin
        S := copy(S, 3, length(S));
        // Authority
        FAuthority := BreakString(S, '/', S, False, True);
      end else
        S := copy(S, 2, length(S));
      // abs path
      Path := S;
    end else
      Path := S;

  end else
  begin

    // Separate query
    S := BreakString(S, '?', Query, False, False);
    // net, abs or rel
    if (length(S) > 0) and (S[1] = '/') then
    begin
      // net path?
      if copy(S, 1, 2) = '//' then
      begin
        S := copy(S, 3, length(S));
        // Authority
        Authority := BreakString(S, '/', S, False, True);
      end else
        S := copy(S, 2, length(S));
      // abs path
      Path := S;
      IsAbsolute := True;
    end else
      Path := S;

  end;
end;

class function TpgUriReference.ExtensionToMimeType(AExt: Utf8String): Utf8String;
begin
  // Remove dot
  if Pos('.', AExt) > 0 then
    AExt := lowercase(copy(AExt, 2, length(AExt)));
  if (AExt = 'jpg') or (AExt = 'jpeg')  or (AExt = 'png') or (AExt = 'bmp') or
     (AExt = 'tga') or (AExt = 'gif')  then
    Result := 'image/' + AExt
  else
    Result := 'unknown/' + AExt;
end;

procedure TpgUriReference.LoadResource(S: TStream; var MimeType: Utf8String);
var
  AType: TpgSchemeType;
  AName: Utf8String;
  FS: TFileStream;
begin
  AType := SchemeTypeFromScheme(FScheme);
  case AType of

  stUnknown, stFile:
    begin
      AName := AbsoluteReference;
      //strip off "file:"
      if pos('file:', AName) = 1 then
        AName := UriDecode(copy(AName, 6, length(AName)));
      FS := TFileStream.Create(AName, fmOpenRead or fmShareDenyNone);
      try
        S.Size := FS.Size;
        S.CopyFrom(FS, FS.Size);
      finally
        FS.Free;
      end;
      MimeType := ExtensionToMimeType(ExtractFileExt(Path));
    end;

  stData:
    // The 'data:' isn't specified in RFC2396 but seems to be present in SVG
    // quite often. 'data:' is followed by a content type, then a semicolon and
    // then an encoding type.
    begin
      // Data directly encapsulated, usually as Base64
      TranslateContent(FPath, S, MimeType);
    end;

  //stHttp:;// to do: load from URL
  else
    raise Exception.CreateFmt(sUnsupportedUriScheme, [FScheme]);
  end;
  // rewind resulting stream
  S.Position := 0;
end;

procedure TpgUriReference.Parse(const ARef, ABase: Utf8String);
var
  BS, BA, BP, BF, BQ: Utf8String;
  BAbs: boolean;
begin
  DecomposeUri(ARef, FScheme, FAuthority, FPath, FFragment, FQuery, FIsAbsolute);
  if length(ABase) > 0 then
  begin
    DecomposeUri(ABase, BS, BA, BP, BF, BQ, BAbs);
    if not BAbs then
      exit;

    FScheme := BS;
    FAuthority := BA;
    FIsAbsolute := True;

    // combine the paths
    if (length(BP) > 0) and (BP[length(BP)] <> '/') then
      BP := BP + '/';

    // to do: handle '../'
    FPath := BP + FPath;
  end;
end;

function TpgUriReference.RelativeReference(const ABase: Utf8String): Utf8String;
begin
// to do
end;

function TpgUriReference.SchemeTypeFromScheme(const AScheme: Utf8String): TpgSchemeType;
var
  i: TpgSchemeType;
begin
  Result := stUnknown;
  if AScheme = '' then exit;
  for i := low(TpgSchemeType) to high(TpgSchemeType) do
    if cpgSchemeTypeNames[i] = AScheme then
    begin
      Result := i;
      exit;
    end;
end;

procedure TpgUriReference.TranslateContent(const Data: Utf8String; S: TStream;
  var MimeType: Utf8String);
// Here we translate content into a binary stream and an extension.. e.g.
// "image/jpg;base64,/9j/4AAQ..." into
// Ext: jpg
// S contains the base64 decoded stream
var
  Info, Bulk, DecodedData: Utf8String;
  Encoding, Content: Utf8String;
begin
  MimeType := '';
  Info := BreakString(Data, ',', Bulk, False, True);
  // We can't do anything if no content type is specified
  if length(Info) = 0 then
    exit;

  // Basic content type
  Content := BreakString(Info, ';', Encoding, True, True);
  if length(Content) > 0 then
    MimeType := lowercase(Content);

  // What kind of encoding?
  if lowercase(Encoding) = 'base64' then
  begin
    // Base64
    // To decode, we use the BASE64 decoder in pgBase64Decode
    DecodedData := DecodeBase64(Bulk);
    S.Size := length(DecodedData);
    if length(DecodedData) > 0 then
      S.Write(DecodedData[1], length(DecodedData));
  end else
    raise Exception.CreateFmt(sUnsupportedEncodingInUri, [Encoding]);
end;

end.
