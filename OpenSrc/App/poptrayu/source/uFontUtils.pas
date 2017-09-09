{-------------------------------------------------------------------------------
File System Utilities Class
Copyright © 2012 Jessica Brown
All Rights Reserved.

 * This file is dual licensed; you can use it under the terms of
 * either the GPL, or the BSD license, at your option.
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

unit uFontUtils;

interface
  uses Graphics;

  function StringToFont( sFont : String ) : TFont; overload;
  function StringToFont( persistedFont : String; const backupFont : String ) : TFont; overload;
  function FontToString( Font : TFont ) : String;

implementation
  uses Dialogs, Windows, SysUtils, Forms, System.UITypes;

const
  STR_BOLD    = '|Bold';
  STR_ITALIC  = '|Italic';
  STR_ULINE   = '|Underline';
  STR_STIRKE  = '|Strikeout';


{------------------------------------------------------------------------------}
{ Helper function to convert a serialized representation of a font back into   }
{ a font object.                                                               }
{ Caller is responsible for freeing memory of Return value!                    }
{------------------------------------------------------------------------------}
{ Input String Example: "Arial", 9, [Bold|Italic], [clBlack]                   }
{------------------------------------------------------------------------------}
function StringToFont( sFont : String ) : TFont;
var
  p : integer;
  fontStyle : String;
begin
    Result := TFont.Create();

    // font name
    p    := Pos( ',', sFont );
    Result.Name := Copy( sFont, 1, p-1 );
    Delete( sFont, 1, p );

    // font size
    p    := Pos( ',', sFont );
    Result.Size := StrToInt( Copy( sFont, 2, p-2 ) );
    Delete( sFont, 1, p );

    // font style
    p      := Pos( ',', sFont );
    fontStyle := '|' + Copy( sFont, 3, p-4 );
    Delete( sFont, 1, p );

    // font color
    Result.Color := StringToColor( Copy( sFont, 3, Length( sFont ) - 3 ) );

    // convert string to font style
    Result.Style := [];
    if( Pos(STR_BOLD, fontStyle) > 0 ) then
      Result.Style := Result.Style + [ fsBold ];
    if( Pos(STR_ITALIC, fontStyle) > 0 ) then
      Result.Style := Result.Style + [ fsItalic ];
    if( Pos(STR_ULINE, fontStyle) > 0 ) then
      Result.Style := Result.Style + [ fsUnderline ];
    if( Pos(STR_STIRKE, fontStyle) > 0 ) then
      Result.Style := Result.Style + [ fsStrikeout ];

end;

{------------------------------------------------------------------------------}
{ Helper function to convert a serialized representation of a font back into   }
{ a font object.                                                               }
{------------------------------------------------------------------------------}
{ Input String Example: "Arial", 9, [Bold|Italic], [clBlack]                   }
{------------------------------------------------------------------------------}
function StringToFont( persistedFont : String; const backupFont : String ) : TFont;
begin
  if (persistedFont = '') then
    Result := StringToFont(backupFont)
  else
    Result := StringToFont(persistedFont);
end;


{------------------------------------------------------------------------------}
{ Helper function to convert TFont objects to a string representation for      }
{ serialization via settings ini file.                                         }
{------------------------------------------------------------------------------}
{ Return Value Example: "Arial", 9, [Bold|Italic], [clBlack]                   }
{------------------------------------------------------------------------------}
function FontToString( Font : TFont ) : String;
var
  fontStyle : String;
begin
  // If font is not assigned, return an empty string and quit.
  if Font = nil then begin Result := ''; Exit; end;

  fontStyle := '';
  if (fsBold in Font.Style) then fontStyle := fontStyle + STR_BOLD;
  if (fsItalic in Font.Style) then fontStyle := fontStyle + STR_ITALIC;
  if (fsUnderline in Font.Style) then fontStyle := fontStyle + STR_ULINE;
  if (fsStrikeout in Font.Style) then fontStyle := fontStyle + STR_STIRKE;

  // if string starts with vbar "|" then strip the first character
  if( ( Length( fontStyle ) > 0 ) and ( '|' = fontStyle[1] ) )then
  begin
    fontStyle := Copy( fontStyle, 2, Length( fontStyle ) - 1 );
  end;

  Result := Format( '%s, %d, [%s], [%s]',
    [ Font.Name, Font.Size, fontStyle, ColorToString( Font.Color ) ] );
end;




end.
