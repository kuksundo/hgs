{ sdDXFToScene3D

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdDXFToScene3D;

interface

uses
  Classes, SysUtils, Graphics, sdScene3DBuilder, sdDxfFormat, sdPoints3D,
  sdScene3D, sdScene3DPointList;

type

  TDxfImportItem = class(TsdImportItem)
  protected
    function GetName: string; override;
  end;

  TDxfSceneBuilder = class(TsdAbstractSceneBuilder)
  private
    FDxf: TDxfFormat;
    FPoly: TsdPolygon3D;
  protected
    function ItemClass: TsdImportItemClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BuildScene; override;
    procedure UpdateVisibility; override;
    property Dxf: TDxfFormat read FDxf write FDxf;
  end;

const
  cEps = 1E-12;

implementation

{ TDxfImportItem }

function TDxfImportItem.GetName: string;
var
  E: TDxfEntity;
  L: TDxfLayer;
begin
  case Builder.SelectBy of
  sbEntity:
    begin
      E := TDxfEntity(Ref);
      Result := Format('%s (%s)', [E.TypeName, E.LayerName]);
    end;
  sbLayer:
    begin
      L := TDxfLayer(Ref);
      Result := L.Name;
    end;
  end;
end;

{ TDxfSceneBuilder }

procedure TDxfSceneBuilder.BuildScene;
var
  i: integer;
  E: TDxfEntity;
  L: TDxfLayer;
  PL: TsdScene3DPolyLine;
begin
  Clear;
  for i := 0 to FDxf.Entities.Count - 1 do
  begin
    E := FDxf.Entities[i];
    FPoly.Clear;
    E.ToPolygon(FPoly, 0{BreakupLength});
    if FPoly.Count = 0 then continue;

    PL := TsdScene3DPolyLine.Create(Scene, nil);
    // Is this a closed polygon?
    PL.IsClosed := SquaredDist3D(FPoly.First^, FPoly.Last^) < sqr(cEps);
    FPoly.DeleteDuplicates(cEps);
    PL.AddPoints(FPoly.First, FPoly.Count);
    // Use the color defined for the curve's root
    PL.GDIColor := clBlue;
    // Add to our list of imported entities
    case SelectBy of
    sbEntity: NewItem(PL, E);
    sbLayer:
      begin
        L := E.Layer;
        if assigned(L) then
          NewItem(PL, L);
      end;
    end;
  end;

  inherited;
end;

constructor TDxfSceneBuilder.Create(AOwner: TComponent);
begin
  inherited;
  FPoly := TsdPolygon3D.Create;
end;

destructor TDxfSceneBuilder.Destroy;
begin
  FreeAndNil(FPoly);
  inherited;
end;

function TDxfSceneBuilder.ItemClass: TsdImportItemClass;
begin
  Result := TDxfImportItem;
end;

procedure TDxfSceneBuilder.UpdateVisibility;
var
  i: integer;
  SceneItem: TsdScene3DItem;
  ImportItem: TsdImportItem;
begin
  for i := 0 to Scene.Items.Count - 1 do
  begin
    SceneItem := Scene.Items[i];
    ImportItem := TsdImportItem(SceneItem.Tag);
    SceneItem.Visible := ImportItem.Selected or ImportItem.Highlighted;
    if ImportItem.Highlighted then
      SceneItem.GDIColor := clRed
    else
      SceneItem.GDIColor := clLime;
  end;
  inherited;
end;

end.
