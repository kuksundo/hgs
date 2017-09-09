{ Copyright (c) 2007 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
}
program SvgTest;

uses
  Forms,
  SvgTestMain in 'SvgTestMain.pas' {frmMain},
  NativeSvg in '..\..\NativeSvg.pas',
  //sdFileList in '..\..\..\disk\sdFileList.pas',
  pgDocument in '..\..\..\pyro\source\pgDocument.pas',
  sdColorTransforms in '..\..\..\color\sdColorTransforms.pas',
  pgScene in '..\..\..\pyro\source\pgScene.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
