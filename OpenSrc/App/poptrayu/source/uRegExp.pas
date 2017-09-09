unit uRegExp;

{-------------------------------------------------------------------------------
POPTRAYU
Copyright (C) 2014 Jessica Brown
Copyright (C) 2001-2005  Renier Crause
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
interface

//uses
  //Classes, SysUtils, Graphics;


  //--------------------------------------------------------------- RegExp --
  procedure SyntaxCheckRegExpr(text : string);
  function CheckRegExpr(area : string; text : string) : boolean;
  //procedure CreateRegExpr; //should be private

implementation

uses
  RegExpr, uTranslate, Dialogs, uRCUtils;

var
  // RegExp
  FRegExpr : TRegExpr;



procedure CreateRegExpr;
begin
  if not Assigned(FRegExpr) then
  begin
    FRegExpr := TRegExpr.Create;
    FRegExpr.ModifierS := False;
    FRegExpr.ModifierM := True;
    FRegExpr.ModifierI := True;
  end;
end;

function CheckRegExpr(area : string; text : string) : boolean;
begin
  CreateRegExpr;
  try
    FRegExpr.Expression := text;
    Result := FRegExpr.Exec(area);
  except
    on E : ERegExpr do
      // ignore error
      Result := False;
    else
      raise;
  end;
end;

procedure SyntaxCheckRegExpr(text : string);
begin
  CreateRegExpr;
  try
    FRegExpr.Expression := text;
    FRegExpr.Compile;
    ShowTranslatedDlg('Regular Expression Syntax OK',mtInformation,[mbOK],0);
  except
    on E : ERegExpr do
      ShowTranslatedDlg(StrAfter(E.Message,': '),mtError,[mbOK],0);
    else
      raise;
  end;
end;

initialization

finalization
  if Assigned(FRegExpr) then FRegExpr.Free;


end.
