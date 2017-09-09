Readme belonging to the DtpEditor demo
======================================

INSTALLATION

This demo does not compile right "out of the box". If you want to
compile this demo, take the following steps:

1) Install DtpDocuments on the component palette. This will also
   install the required TColorPickerButton and RsRuler components.

   You can opt to do this automatically at installation, or see
   the readme file on how to do it manually.

2) Add the path to the source files to the project. Normally this
   is <installdir>\Source.

   If you choose to update the library path at installation, this
   step is also not necessary.

3) Hit compile, it should usually compile fine. 

Trial Users:
You will get a nag message now and then to remind you this is a trial
version. If you purchase the component, this nag message will not be
present.
  
The source for the demo main unit and frames is available even in the
trial. All other source for the demo is only availabe if you purchase.

INSTALLATION OF RASTER FORMATS

If you have not installed any of the raster format extensions, then
scroll down in the "NativeDtp.inc" file, and outcomment these
sections:

// These additional defines determine which formats will be supported
{$define supportJpg} // Define this symbol to link in JPG support
{$define supportPng} // Define this symbol to link in PNG support
{.$define supportGif}
{.$define supportJ2k}
{.$define supportTif}

HELP FILE

There is an extensive help file coming with the demo, check out the
dtpEditor.chm file, or Help > Contents in the demo.

MORE INFORMATION

Please visit http://www.simdesign.nl for more information.