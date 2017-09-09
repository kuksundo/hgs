{ unit UserActivities

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit UserActivities;

interface

uses
  Classes, Dialogs, SysUtils, Controls;

// Warn the user before removing any items. If this function returns True the
// items should be removed. If no changes were made and Count < 1000 then
// no warning is issued, and the result is True.
function RemoveDespiteWarn(AList: TList): boolean;


// This routine counts user activity in given AList.
// Count returns the number of items, Desc returns the number of descriptions,
// Rate returns the number of ratings, Groups returns the number of added groups,
// Series returns the number of added series
procedure CountUserActivity(AList: TList; var Count, Desc, Rate, Groups, Series: integer);

implementation

uses
  sdItems, sdProperties;

function RemoveDespiteWarn(AList: TList): boolean;
var
  Count, Desc, Rate, Groups, Series: integer;
  AMessage: string;
begin
  // Return "No Remove" per default
  Result := False;

  // Check the selection for user updates
  CountUserActivity(AList, Count, Desc, Rate, Groups, Series);

  // In this case we don't warn
  if (Count < 10000) and (Desc = 0) and (Rate = 0) and (Groups = 0) and (Series = 0) then begin
    Result := True;
    exit;
  end;

  // Warning
  AMessage := 'You''re about to clear from your collection:'#13;
  AMessage := AMessage + Format('- %d item references'#13, [Count]);
  if Desc > 0 then
    AMessage := AMessage + Format('- %d descriptions'#13, [Desc]);
  if Rate > 0 then
    AMessage := AMessage + Format('- %d ratings'#13, [Rate]);
  AMessage := AMessage + #13'Are you sure you want to continue?';

  if MessageDlg(AMessage, mtWarning, [mbOK, mbCancel, mbHelp], 0) = mrOK then
    Result := True;

end;

procedure CountUserActivity(AList: TList; var Count, Desc, Rate, Groups, Series: integer);
var
  i: integer;
begin
  Count := AList.Count;
  Desc := 0;
  Rate := 0;
  Groups := 0;
  Series := 0;
  for i := 0 to AList.Count - 1 do begin
    if assigned(AList[i]) then with TsdItem(AList[i]) do begin
      // Count descriptions
      if HasProperty(prDescription) then inc(Desc);
      // Count ratings
      if Rating <> cDefaultRating then inc(Rate);
      // To do: groups and series!
    end;
  end;
end;


end.
