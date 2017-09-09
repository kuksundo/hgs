program simple;

uses
  Forms,
  simplemain in 'simplemain.pas' {frmMain},
  sdJpegImage in '..\..\sdJpegImage.pas',
  sdJpegCoder in '..\..\sdJpegCoder.pas',
  sdJpegTypes in '..\..\sdJpegTypes.pas',
  sdJpegBitstream in '..\..\sdJpegBitstream.pas',
  sdJpegHuffman in '..\..\sdJpegHuffman.pas',
  sdColorTransforms in '..\..\..\color\sdColorTransforms.pas',
  sdJpegMarkers in '..\..\sdJpegMarkers.pas',
  sdJpegLossless in '..\..\sdJpegLossless.pas',
  sdJpegDCT in '..\..\sdJpegDCT.pas',
  NativeJpg in '..\..\NativeJpg.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
