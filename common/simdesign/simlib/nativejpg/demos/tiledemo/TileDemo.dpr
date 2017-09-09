program TileDemo;

uses
  Forms,
  TileDemoMain in 'TileDemoMain.pas' {frmTileDemo},
  sdColorTransforms in '..\..\..\color\sdColorTransforms.pas',
  sdVirtualScrollbox in '..\..\..\virtualscrollbox\sdVirtualScrollbox.pas',
  sdDebug in '..\..\..\general\sdDebug.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTileDemo, frmTileDemo);
  Application.Run;
end.
