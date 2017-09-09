{ Project: Pyro

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 SimDesign BV
}
unit pgViewerUsingPyro;

interface

uses
  pgViewerUsingScene, pgRenderUsingCore, pgRender;

type

  TpgPyroViewer = class(TpgSceneViewer)
  protected
    class function GetRendererClass: TpgRendererClass; override;
  end;

implementation

{ TpgPyroViewer }

class function TpgPyroViewer.GetRendererClass: TpgRendererClass;
begin
  Result := TpgRenderer;
end;

end.
