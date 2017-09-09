program VrmlViewer;

uses
  Forms,
  VrmlMain in 'VrmlMain.pas' {frmMain},
  sdVrmlFormat in '..\sdVrmlFormat.pas',
  sdVrmlToScene3D in '..\sdVrmlToScene3D.pas',
  sdVrmlNodeTypes in '..\sdVrmlNodeTypes.pas',
  fraViewer in '..\..\fraViewer.pas' {frViewer: TFrame},
  sdScene3D in '..\..\sdScene3D.pas',
  sdPoints3D in '..\..\..\geometry\sdPoints3D.pas',
  sdSpaceballInput in '..\..\..\hardware\sdSpaceballInput.pas',
  sdSpaceballInput_TLB in '..\..\..\hardware\sdSpaceballInput_TLB.pas',
  sdScene3DBuilder in '..\..\sdScene3DBuilder.pas',
  sdScene3DMesh in '..\..\sdScene3DMesh.pas',
  sdMesh in '..\..\..\geometry\sdMesh.pas',
  sdMatrices in '..\..\..\geometry\sdMatrices.pas',
  sdTesselation in '..\..\..\geometry\sdTesselation.pas',
  sdScene3DShapes in '..\..\sdScene3DShapes.pas',
  fraSpaceball in '..\..\fraSpaceball.pas' {frSpaceball: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
