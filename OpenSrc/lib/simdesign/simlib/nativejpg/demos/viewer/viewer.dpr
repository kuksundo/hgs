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
program viewer;

{ enable this to use the LittleCMS library to apply ICC colour profiles to
  your bitmaps. Please note the license details. The LittleCMS API is located
  in the extlib/color/lcms subfolder. For an example on use, see procedure JpegApplyICC.
  More info on LittleCMS: http://www.littlecms.com
  When using LittleCMS, make sure that a copy of lcms.dll is located
  in your application's exe path or in another accessible global location.}
{.$define useLittleCMS}

// enable this if you want to use picture preview in open dialogs
{$define usePicturePreview}

// enable this to view details in sdJpegCoder and sdJpegHuffman
{$define DETAILS}



uses
  Forms,
  viewerMain in 'viewerMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
