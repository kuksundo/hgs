unit UnitFormUtil;

interface

uses Forms, SysUtils, Windows, Classes, Controls, TypInfo, Vcl.Graphics, Vcl.StdCtrls;

procedure ScreenActiveControlChange(Sender: TObject; activeControl: TWinControl;
  prevInactiveColor: TColor);

implementation

procedure ScreenActiveControlChange(Sender: TObject; activeControl: TWinControl;
  prevInactiveColor: TColor);
var
  noEnter, noExit : boolean;
  prevActiveControl : TWinControl;

  procedure ColorEnter(Sender : TObject);
  begin
    if Assigned(Sender) AND IsPublishedProp(Sender,'Color') then
    begin
      prevInactiveColor := GetOrdProp(Sender, 'Color');
      SetOrdProp(Sender, 'Color', clSkyBlue); //change clSkyBlue to something else or read from some application configuration <img class="emoji" draggable="false" alt="??" src="https://s.w.org/images/core/emoji/11/svg/1f642.svg">
    end;
  end; (*ColorEnter*)

  procedure ColorExit(Sender : TObject);
  begin
    if Assigned(Sender) AND IsPublishedProp(Sender,'Color') then
      SetOrdProp(Sender, 'Color', prevInactiveColor);
  end; (*ColorExit*)
begin
  if Screen.ActiveControl = nil then
  begin
    activeControl := nil;
    Exit;
  end;

  noExit := false;

  noEnter := NOT Screen.ActiveControl.Enabled;
  noEnter := noEnter OR (Screen.ActiveControl is TForm); //disabling active control focuses the form
  noEnter := noEnter OR (Screen.ActiveControl is TCheckBox); // skip checkboxes

  prevActiveControl := activeControl;

  if prevActiveControl <> nil then
  begin
    noExit := prevActiveControl is TForm;
    noExit := noExit OR (prevActiveControl is TCheckBox);
  end;

  activeControl := Screen.ActiveControl;

  if NOT noExit then ColorExit(prevActiveControl);
  if NOT noEnter then ColorEnter(activeControl);
end;

end.
