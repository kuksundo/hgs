///<summary> Some utility functions for reading and writing XML files </summary>
unit u_dzXmlUtils;

interface

///<summary> escapes some special characters to xml entities (like &, <, > etc.)
///          @param s is the string to escape
///          @returns the content of s with the entities escaped </summary>
function XmlStringEscape(const _S: string): string;

///<summary> un-escapes some xml entities (like &amp;, &lt;, &gt; etc.) to their characters
///          @param s is the string containing the escaped entities
///          @returns the content of s with the entities un-escaped </summary>
function XmlStringUnEscape(const _S: string): string;

implementation

uses
  Sysutils;

const
  ESCAPECHARCOUNT = 5;
  ForbiddenChars: array[0..ESCAPECHARCOUNT - 1] of string = (
    // '&' MUST be the first
    '&',
    '<',
    '>',
    '''',
    '"'
    );
  ResolvedChars: array[0..ESCAPECHARCOUNT - 1] of string = (
    '&amp;',
    '&lt;',
    '&gt;',
    '&apos;',
    '&quot;'
    );

function XmlStringEscape(const _S: string): string;
var
  i: integer;
begin
  Result := _S;
  for i := 0 to ESCAPECHARCOUNT - 1 do
    Result := StringReplace(Result, ForbiddenChars[i], ResolvedChars[i], [rfReplaceAll]);
end;

function XmlStringUnEscape(const _S: string): string;
var
  i: integer;
begin
  Result := _S;
  for i := 0 to ESCAPECHARCOUNT - 1 do
    Result := StringReplace(Result, ResolvedChars[i], ForbiddenChars[i], [rfReplaceAll]);
end;



end.

