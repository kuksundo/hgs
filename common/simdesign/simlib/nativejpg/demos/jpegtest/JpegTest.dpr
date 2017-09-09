{ Copyright (c) 2007 - 2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

  Note:
  NativeJpg.pas needs to be placed in this project file in order to use
  NativeJpg for the "open image" dialog box and when accepting dragged files.
  
  See "TPicture.RegisterFileFormat('jpg', 'Jpeg file', TsdJpegGraphic);" in
  NativeJpg.pas "initialization" section.

}
{$define DETAILS}

program JpegTest;

uses
  Forms,
  JpegTestMain in 'JpegTestMain.pas' {frmMain},
  sdBitmapConversionWin in '..\..\..\bitmap\sdBitmapConversionWin.pas',
  sdMapIterator in '..\..\..\bitmap\sdMapIterator.pas',
  sdColorTransforms in '..\..\..\color\sdColorTransforms.pas',
  sdFileList in '..\..\..\disk\sdFileList.pas',
  sdSortedLists in '..\..\..\general\sdSortedLists.pas',
  sdJpegImage in '..\..\sdJpegImage.pas',
  sdDebug in '..\..\..\general\sdDebug.pas',
  sdJpegMarkers in '..\..\sdJpegMarkers.pas',
  sdJpegTypes in '..\..\sdJpegTypes.pas',
  sdJpegBitstream in '..\..\sdJpegBitstream.pas',
  sdJpegLossless in '..\..\sdJpegLossless.pas',
  sdJpegHuffman in '..\..\sdJpegHuffman.pas',
  sdJpegDCT in '..\..\sdJpegDCT.pas',
  sdJpegCoder in '..\..\sdJpegCoder.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
