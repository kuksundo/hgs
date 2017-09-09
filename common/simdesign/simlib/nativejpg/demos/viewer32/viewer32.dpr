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
program viewer32;

{ enable this to use the LittleCMS library to apply ICC colour profiles to
  your bitmaps. Please note the license details. The LittleCMS API is located
  in the extlib/color/lcms subfolder. For an example on use, see procedure JpegApplyICC.
  More info on LittleCMS: http://www.littlecms.com
  When using LittleCMS, make sure that a copy of lcms.dll is located
  in your application's exe path or in another accessible global location.}
{.$define useLittleCMS}

// enable this if you want to use picture preview in open dialogs
{.$define usePicturePreview}

// enable this to view details in sdJpegCoder and sdJpegHuffman
{.$define DETAILS}



uses
  Forms,
  viewer32Main in 'viewer32Main.pas' {frmMain},
  sdMapIterator in '..\..\..\bitmap\sdMapIterator.pas',
  sdBitmapResize in '..\..\..\bitmap\sdBitmapResize.pas',
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
  sdMetadata in '..\..\..\general\sdMetadata.pas',
  sdMetadataExif in '..\..\..\general\sdMetadataExif.pas',
  sdMetadataIptc in '..\..\..\general\sdMetadataIptc.pas',
  sdMetadataJpg in '..\..\..\general\sdMetadataJpg.pas',
  sdMetadataCiff in '..\..\..\general\sdMetadataCiff.pas',
  sdJpegCoder in '..\..\sdJpegCoder.pas',
  NativeXml in '..\..\..\nativexml\NativeXml.pas',
  sdStreams in '..\..\..\general\sdStreams.pas',
  sdStringTable in '..\..\..\general\sdStringTable.pas',
  sdMetadataTiff in '..\..\..\general\sdMetadataTiff.pas',
  NativeJpg32 in 'NativeJpg32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
