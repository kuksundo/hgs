unit UnitAdvComponentUtil;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  CommonData, AdvGroupBox, AdvOfficeButtons;


function GetBusinessAreasFromGrpComponent(ABusinessAreaGrp: TAdvOfficeCheckGroup): TBusinessAreas;
procedure SetBusinessAreasGrpFromTBusinessAreas(ABusinessAreaGrp: TAdvOfficeCheckGroup; ABusinessAreas: TBusinessAreas);

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

end.
