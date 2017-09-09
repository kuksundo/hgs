//Written with Delphi XE3 Pro
//Created Nov 24, 2012 by Darian Miller
unit DelphiVault.Windows.Menus;

interface
uses
  Vcl.Menus;

  procedure PopMenuAtCursor(const pMenu:TPopupMenu);

implementation
uses
  WinApi.Windows;


//Based on answer by Andreas Rejbrand on Oct 21, 2010 to question:
//http://stackoverflow.com/questions/3986999/how-to-show-a-tpopupmenu-when-you-click-a-tbutton
procedure PopMenuAtCursor(const pMenu:TPopupMenu);
var
  pt:TPoint;
begin
  if GetCursorPos(pt) then
  begin
    pMenu.Popup(pt.x, pt.y);
  end;
end;

end.
