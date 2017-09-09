unit uHtmlDecoder;

{-------------------------------------------------------------------------------
HTML Decoder Class
Copyright ?2012-2013 Jessica Brown
All Rights Reserved.

 * Source code in this *file* is dual licensed; you can use it under the terms
 * of either the GPL, or the BSD license, at your option.
 *
 * I. GPL:
 *
 * This file is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * The GNU GPL can be found at:
 *   http://www.gnu.org/copyleft/gpl.html
 *
 * Alternatively,
 *
 * II. BSD license:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
-------------------------------------------------------------------------------}

interface
  uses Classes;


  function RemoveAllTags(source : string) : string;
  function RemoveImageTags(source : string) : string;
  procedure WriteStringToStream(stream: TStream; const appendText: string);
  procedure SantitizeHtml(source: string; outStream: TStream);
  function ConvertHtmlToPlaintext(S : string) : string;
  function FilterCSS(const input : String) : String;


implementation
  uses SysUtils, StrUtils, System.RegularExpressions,
  HtmlParser, DomCore, Formatter;

function RemoveAllTagsBasic(source: string): string;
var
  TagBegin, TagEnd, TagLength: integer;
begin
  TagBegin := Pos( '<', source);      // search position of first <

  while (TagBegin > 0) do begin  // while there is a < in S
    TagEnd := Pos('>', source);              // find the matching >
    TagLength := TagEnd - TagBegin + 1;
    Delete(source, TagBegin, TagLength);     // delete the tag
    TagBegin:= Pos( '<', source);            // search for next <
  end;

  Result := source;                   // give the result
end;

// Converts a HTML formatted message to Plain-text.
function RemoveAllTags(source: string): string;
const
  STYLE_TAG_START : string = '<style';
  STYLE_TAG_END : string = '</style';
  HEAD_TAG_START : string = '<head';
  HEAD_TAG_END : string = '</head';
  PARA_TAG_START : string = '<p';
  BR_TAG_START : string = '<br';
var
  TagBegin, TagEnd, TagLength, MatchTagStart: integer;
  tagStart : string;
//  betweenTagsStr : string;
//  nextTagStart : integer;
begin
  TagBegin := Pos( '<', source);      // search position of first <

  while (TagBegin > 0) do
  begin  // while there is a < in S
    TagEnd := PosEx('>', source, TagBegin);              // find the matching >
    TagLength := TagEnd - TagBegin + 1;
    tagStart := AnsiMidStr(source, TagBegin, Length(STYLE_TAG_START));


    if AnsiCompareText(tagStart, STYLE_TAG_START) = 0 then
    begin
      MatchTagStart := PosEx(STYLE_TAG_END, source, TagBegin);
      if (MatchTagStart > 0) then
      begin
        TagEnd := PosEx('>', source, MatchTagStart); // Move tag end to matched close tag
        TagLength := TagEnd - TagBegin + 1;
      end;
    end else if AnsiCompareText( AnsiLeftStr(tagStart, Length(HEAD_TAG_START)),
      HEAD_TAG_START ) = 0 then
    begin
      MatchTagStart := PosEx(HEAD_TAG_END, source, TagBegin);
      if (MatchTagStart > 0) then begin
        TagEnd := PosEx('>', source, MatchTagStart); // Move tag end to matched close tag
        TagLength := TagEnd - TagBegin + 1;
      end;
    end else if
      (AnsiCompareText( AnsiLeftStr(tagStart, Length(PARA_TAG_START)), PARA_TAG_START ) = 0) OR
      (AnsiCompareText( AnsiLeftStr(tagStart, Length(BR_TAG_START)), BR_TAG_START ) = 0)
      then begin
        Insert(''+#13+'N'+#10, source, TagBegin); //Extra N inserted so this won't get eaten by the regex below
        Inc(TagBegin);
        Inc(TagBegin);
        Inc(TagBegin);//for the N
      //end;
    end;

    Delete(source, TagBegin, TagLength);     // delete the tag
    //nextTagStart := Pos('<', source);
    //betweenTagsStr := AnsiMidStr(source, TagBegin, nextTagStart);
    //if Trim(betweenTagsStr) = '' then
    //Delete(source, TagBegin, nextTagStart);     // delete the empty stuff

    TagBegin:= Pos( '<', source);            // search for next <

  end;


  //Remove excess whitespace
  source := TRegEx.Replace(source, '('+#13#10+'[ \t]*){2,}',#13#10);

  source := StringReplace(source, #13+'N'+#10, #13#10, [rfReplaceAll]); //return the real paragraph marks

  source := StringReplace(source, '&nbsp;', ' ', [rfReplaceAll]);
  source := StringReplace(source, '&copy;', '?', [rfReplaceAll]);

  Result := source;                   // give the result
end;

// Input example: '<img src="img1.gif">' OR '</span>'
// less efficient but more easy to understand implementation.
function RemoveImageTags(source: string): string;
var
  TagBegin, TagEnd: integer;
begin
  // find position of first tag start
  TagBegin := Pos( '<', source);

  // no tags in entire string, return original string
  if (TagBegin = 0) then begin
    Result := source;
    Exit;
  end else begin
    Result := Copy(source, 1, TagBegin-1);
  end;

  // loop through file while there are more tags
  while (TagBegin > 0) do begin

    // find matching close tag
    TagEnd := PosEx('>', source, TagBegin);
    //TagLength := TagEnd - TagBegin + 1;

    if PosEx('img', source, TagBegin) = TagBegin + 1 then begin
      // replace image start tag with placeholder/alt text
      Result := Result + ' [image] ';
    end else if PosEx('/img', source, TagBegin) = TagBegin + 1 then begin
      //discard end image tag
    end else begin
      Result := Result + Copy(source, TagBegin, TagEnd-TagBegin+1);
    end;

    TagBegin:= PosEx( '<', source, TagEnd+1);


    Result := Result + Copy(source, TagEnd+1, TagBegin-(TagEnd+1));


  end;
end;

procedure WriteStringToStream(stream: TStream; const appendText: string);
begin
  stream.WriteBuffer(Pointer(appendText)^, Length(appendText)*SizeOf(Char));
end;


// Cleans up HTML to filter out spamy content items:
// Removes the following tags: img, link, script
procedure SantitizeHtml(source: string; outStream: TStream);
var
  TagBegin, TagEnd, TagLength, CloseTagBegin: integer;
  tagHandled : boolean;
  filteredCode : string;
begin
  // find position of first tag start
  TagBegin := Pos( '<', source);

  // no tags in entire string, return original string
  if (TagBegin = 0) then begin
    WriteStringToStream(outStream, source);
    Exit;
  end else begin
    WriteStringToStream(outStream, Copy(source, 1, TagBegin-1));
  end;

  // loop through file while there are more tags
  while (TagBegin > 0) do begin
    // find matching close tag
    TagEnd := PosEx('>', source, TagBegin);
    TagLength := TagEnd - TagBegin + 1;

    tagHandled := false;
    case (source[TagBegin+1]) of
      'i','I':
          if TagLength >= 4 then
          case source[TagBegin+2] of 'm','M':
            case source[TagBegin+3] of 'g', 'G':
              begin
                WriteStringToStream(outStream, ' [img] ');
                tagHandled := true;
              end;
            end;
          end;
      'l','L':
        if TagLength >= 5 then
        case source[TagBegin+2] of 'i','I':
          case source[TagBegin+3] of 'n','N':
            case source[TagBegin+4] of 'k','K':
              tagHandled := true;
            end;
          end;
        end;
      'o','O':
        if TagLength >= 7 then
        case source[TagBegin+2] of 'b','B':
          case source[TagBegin+3] of 'j','J':
            case source[TagBegin+4] of 'e','E':
              case source[TagBegin+5] of 'c','C':
                case source[TagBegin+6] of 't','T':
                  tagHandled := true;
                end;
              end;
            end;
          end;
        end;
      's','S':
        if TagLength >= 7 then
            case source[TagBegin+2] of 't','T':
              case source[TagBegin+3] of 'y', 'Y':
                case source[TagBegin+4] of 'l', 'L':
                  case source[TagBegin+5] of 'e', 'E':
                    begin
                      CloseTagBegin := PosEx('</style', source, TagBegin);
                      TagEnd := PosEx('>', source, CloseTagBegin);
                      filteredCode := FilterCSS(Copy(source, TagBegin, TagEnd-TagBegin+1));
                      WriteStringToStream(outStream, filteredCode);
                      tagHandled := true;
                    end;
                  end;
                end;
              end;
        end;
      '/':
        begin
          if TagLength >= 4 then
          case source[TagBegin+2] of
          'i','I':
            case source[TagBegin+3] of 'm','M':
              case source[TagBegin+4] of 'g', 'G':
                tagHandled := true;
              end;
            end;
          'l','L':
                if TagLength >= 6 then
                case source[TagBegin+3] of 'i','I':
                  case source[TagBegin+4] of 'n','N':
                    case source[TagBegin+5] of 'k','K':
                      tagHandled := true;
                    end;
                  end;
                end;
          'o','O':
                if TagLength >= 8 then
                case source[TagBegin+3] of 'b','B':
                  case source[TagBegin+4] of 'j','J':
                    case source[TagBegin+5] of 'e','E':
                      case source[TagBegin+6] of 'c','C':
                        case source[TagBegin+7] of 't','T':
                          tagHandled := true;
                        end;
                      end;
                    end;
                  end;
                end;
          end;
        end;
      '>': tagHandled := true;
    end;

    if (NOT tagHandled) then begin
      WriteStringToStream(outStream, Copy(source, TagBegin, TagEnd-TagBegin+1));
    end;

    {
    if PosEx('img', source, TagBegin) = TagBegin + 1 then begin
      // replace image start tag with placeholder/alt text
      WriteStringToStream(outStream, ' [img] ');
    end else if PosEx('/img', source, TagBegin) = TagBegin + 1 then begin
      //discard tag
    end else if PosEx('link', source, TagBegin) = TagBegin + 1 then begin
      //discard tag & close tag
    end else if PosEx('/link', source, TagBegin) = TagBegin + 1 then begin
      //discard tag
    end else if PosEx('script', source, TagBegin) = TagBegin + 1 then begin
      //discard tag
    end else if PosEx('/script', source, TagBegin) = TagBegin + 1 then begin
      //discard tag
    end else if PosEx('object', source, TagBegin) = TagBegin + 1 then begin
      //discard tag
    end else if PosEx('/script', source, TagBegin) = TagBegin + 1 then begin
      //discard tag
    end else begin
      //allowed tag
      WriteStringToStream(outStream, Copy(source, TagBegin, TagEnd-TagBegin+1));
    end;
    }
    TagBegin:= PosEx( '<', source, TagEnd+1);
    WriteStringToStream(outStream, Copy(source, TagEnd+1, TagBegin-(TagEnd+1)));
  end;
end;

function FilterCSS(const input : String) : String;
var
  urlBegin, TagBegin, TagEnd, TagLength: integer;
begin
  Result := input;
  urlBegin := Pos( 'url', Result);      // search position of first <
  TagBegin := PosEx ( '(', Result, urlBegin );

  while (TagBegin > 0) do begin  // while there is a < in S
    TagEnd := PosEx(')', Result, TagBegin);
    TagLength := TagEnd - TagBegin + 1;
    //todo: taglength = 0
    Delete(Result, TagBegin+1, TagLength-2); //leave 2 chars: ( and )
    TagBegin:= PosEx( 'url', Result, TagBegin);
  end;

end;


function ConvertHtmlToPlaintext(S : string) : string;
var
  HtmlDoc: TDocument;
  Formatter: TBaseFormatter;
  HtmlParser: THtmlParser;
begin
  HtmlParser := THtmlParser.Create;
  try
    HtmlDoc := HtmlParser.parseString(S)
  finally
    HtmlParser.Free
  end;

  Formatter := TTextFormatter.Create;
  try
    Result := Formatter.getText(HtmlDoc)
  finally
    Formatter.Free
  end;

  HtmlDoc.Free;
end;



end.


