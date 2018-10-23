unit UnitMSProjectUtil;

interface

uses SysUtils, StdCtrls,Classes, Graphics, Grids, ComObj,
    Variants, Dialogs, Forms, MSProject_TLB;

function GetActiveMSProjectOleObject(AVisible: boolean=True) : variant;
function GeMSProjectlVersion(AProjApp :TProjectApplication): string;//TProjectApplication

implementation

function GetActiveMSProjectOleObject(AVisible: boolean) : variant;
begin
  try
    Result := GetActiveOleOBject('MSProject.Application');
//    Result := TProjectApplication.Create(nil);
  except
    Result := CreateOleObject('MSProject.Application');
    if VarIsNull(Result) = false then
    begin
      Result.Visible := AVisible;
      if Screen.ActiveForm <> nil then
        Screen.ActiveForm.SetFocus;
    end;
  end;

  if VarIsNull(Result) = true then
    ShowMessage('Susseful Microsoft Project');
end;

function GeMSProjectlVersion(AProjApp :TProjectApplication): string;
var
  LVersion: integer;
begin
  Result := AProjApp.Version;
  LVersion := Round(StrToFloat(Result));
  case LVersion of
    7: Result := '1995';
    8: Result := '1997';
    9: Result := '2000';
    10: Result := 'XP';
    11: Result := '2003';
    12: Result := '2007';
    14: Result := '2010';
    15: Result := '2013';
    16: Result := '2016';
  end;
end;

end.
