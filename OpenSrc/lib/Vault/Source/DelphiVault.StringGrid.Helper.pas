//Written with Delphi XE3 Pro
//Created Nov 24, 2012 by Darian Miller
unit DelphiVault.StringGrid.Helper;

interface
uses
  Vcl.Grids;

type
  TStringGridHelper = class helper for TStringGrid
  public
    procedure ClearValues();
  end;


implementation


//Based on answer by TLama on Nov 11, 2011 to question:
//http://stackoverflow.com/questions/8095931/emptying-string-grid-in-delphi
procedure TStringGridHelper.ClearValues();
var
  i:Integer;
begin
  for i := 0 to ColCount - 1 do
  begin
    Cols[i].Clear;
  end;
end;


end.
