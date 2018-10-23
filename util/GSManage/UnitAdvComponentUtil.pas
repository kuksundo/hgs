unit UnitAdvComponentUtil;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  CommonData, AdvGroupBox, AdvOfficeButtons;


function GetBusinessAreasFromGrpComponent(ABusinessAreaGrp: TAdvOfficeCheckGroup): TBusinessAreas;
procedure SetBusinessAreasGrpFromTBusinessAreas(ABusinessAreaGrp: TAdvOfficeCheckGroup; ABusinessAreas: TBusinessAreas);
function GetCompanyTypesFromGrpComponent(ACompanyTypeGrp: TAdvOfficeCheckGroup): TCompanyTypes;
procedure SetCompanyTypesGrpFromTCompanyTypes(ACompanyTypeGrp: TAdvOfficeCheckGroup; ACompanyTypes: TCompanyTypes);

implementation

function GetBusinessAreasFromGrpComponent(ABusinessAreaGrp: TAdvOfficeCheckGroup): TBusinessAreas;
begin
  Result := [];

  if ABusinessAreaGrp.Checked[0] then
    Result := Result + [baShip];

  if ABusinessAreaGrp.Checked[1] then
    Result := Result + [baEngine];

  if ABusinessAreaGrp.Checked[2] then
    Result := Result + [baElectric];
end;

procedure SetBusinessAreasGrpFromTBusinessAreas(ABusinessAreaGrp: TAdvOfficeCheckGroup; ABusinessAreas: TBusinessAreas);
begin
  ABusinessAreaGrp.Checked[0] := baShip in ABusinessAreas;
  ABusinessAreaGrp.Checked[1] := baEngine in ABusinessAreas;
  ABusinessAreaGrp.Checked[2] := baElectric in ABusinessAreas;
end;

function GetCompanyTypesFromGrpComponent(ACompanyTypeGrp: TAdvOfficeCheckGroup): TCompanyTypes;
begin
  Result := [];

  if ACompanyTypeGrp.Checked[0] then
    Result := Result + [ctNewCompany];

  if ACompanyTypeGrp.Checked[1] then
    Result := Result + [ctMaker];

  if ACompanyTypeGrp.Checked[2] then
    Result := Result + [ctOwner];

  if ACompanyTypeGrp.Checked[3] then
    Result := Result + [ctAgent];

  if ACompanyTypeGrp.Checked[4] then
    Result := Result + [ctCorporation];

  if ACompanyTypeGrp.Checked[5] then
    Result := Result + [ctSubContractor];
end;

procedure SetCompanyTypesGrpFromTCompanyTypes(ACompanyTypeGrp: TAdvOfficeCheckGroup; ACompanyTypes: TCompanyTypes);
begin
  ACompanyTypeGrp.Checked[0] := ctNewCompany in ACompanyTypes;
  ACompanyTypeGrp.Checked[1] := ctMaker in ACompanyTypes;
  ACompanyTypeGrp.Checked[2] := ctOwner in ACompanyTypes;
  ACompanyTypeGrp.Checked[3] := ctAgent in ACompanyTypes;
  ACompanyTypeGrp.Checked[4] := ctCorporation in ACompanyTypes;
  ACompanyTypeGrp.Checked[5] := ctSubContractor in ACompanyTypes;
end;

end.
