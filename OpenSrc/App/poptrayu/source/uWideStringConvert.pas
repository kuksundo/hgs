{-------------------------------------------------------------------------------
Wide String Conversion Utility Class
Copyright © 2012 Jessica Brown
All Rights Reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

The GNU GPL can be found at:
  http://www.gnu.org/copyleft/gpl.html
-------------------------------------------------------------------------------}

unit uWideStringConvert;

{ AnsiStringToWideString is a wrapper for the Windows library function
  MultiByteToWideChar, which converts ansi strings from an arbitrary code page
  to a WideString encoding.

  Information about how MultiByteToWideChar works, and what code pages are
  supported can be found on MSDN.                                              }
interface

uses
  Windows;

  function AnsiStringToWideString(const s: AnsiString; codePage: word): WideString;

implementation



{:Converts Ansi string to Unicode string using specified code page.
  @param   s        Ansi string.
  @param   codePage Code page to be used in conversion.
  @returns Converted wide string.
}
function AnsiStringToWideString(const s: AnsiString; codePage: word): WideString;
var
  l: integer;
begin
  if s = '' then
    Result := ''
  else begin
    l := MultiByteToWideChar(codePage, MB_PRECOMPOSED, PChar(@s[1]), -1, nil, 0);
    SetLength(Result, l-1);
    if l > 1 then
      MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PChar(@s[1]), -1, PWideChar(@Result[1]), l-1);
  end;
end; { StringToWideString }

end.
 