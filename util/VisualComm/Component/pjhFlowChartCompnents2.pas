unit pjhFlowChartCompnents2;

interface

uses
  Windows, Messages, SysUtils, Classes,
  pjhClasses, CustomLogic, CustomLogicType;

type
  TpjhDelay2 = class(TpjhProcess)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  function GetPaletteList: TStringList;

implementation

{ TpjhDelay }

constructor TpjhDelay2.Create(AOwner: TComponent);
begin
  inherited;

  DiagramType := dtDelay;
end;

function GetPaletteList: TStringList;
var
  LStr: string;
begin
  Result := TStringList.Create;
  LStr := 'FlowChart=';
  LStr := LStr + 'TpjhDelay2;';
  Result.Add(LStr);
end;

exports
  GetPaletteList;

initialization
  RegisterClasses([TpjhDelay2]);

finalization
  UnRegisterClasses([TpjhDelay2]);

end.
