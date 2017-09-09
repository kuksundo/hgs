{ sdAbcTypes

  This unit hosts all non-class types and constants, only standard Delphi units are used.

  author: Nils Haeck M.Sc.
  date: 27mar2011
  copyright (c) 2011 SimDesign (www.simdesign.nl)
}
unit sdAbcTypes;

interface

uses
  Windows, Classes;

const

  cVersionName = '2.00';

  cMailtoInfo      = 'mailto:support@abc-view.com';
  cWebAddress      = 'http://www.abc-view.com/abcview.html';
  cBuyLink         = 'http://www.abc-view.com/abcbuy.html';
  cWebTellFriend   = 'http://www.abc-view.com/abctell.html';
  cWebForum        = 'http://www.simdesign.nl/forum/viewforum.php?f=32';
  cDownloadPlugins = 'http://www.abc-view.com/abcplugins.html';

  cUnregVersion: Utf8String = 'This shareware version is unregistered';
  cRegVersion:   Utf8String = 'This software is registered - thank you!';

type

  TSlideShowDir = (
    sdForward,
    sdBackward
  );

  TDeleteConfirm = (
    dcNever,
    dcMessage,
    dcDialog
  );

const

  cThumbCompressNone   = 0;
  cThumbCompressLZW    = 1;
  cThumbCompressJPG    = 2;

  cColorGroupingNone   = 0;
  cColorGroupingPastel = 1;
  cColorGroupingGloom  = 2;

  // Level of detail for pixref
  cmg4x4pixels   = 0; // Low
  cmg8x8pixels   = 1; // Medium
  cmg12x12pixels = 2; // High
  cmg16x16pixels = 3; // Super High

  // Color/Intensity model for pixref
  cmmIntensity   = 0;
  cmmColors      = 1;

  // Similarity sort method
  cssmAutoMethod = 0;
  cssmSlowMethod = 1;
  cssmFastMethod = 2;

const

  ciNoBand     =   -1;   // No Band
  ciNoIcon     =   -1;   // No Icon

  // Status updates
  suPanel0     =  0;     // Update Panel 0, 'AMessage' will be displayed
  suPanel1     =  1;     // Update Panel 1, 'AMessage' will be displayed
  suPanel2     =  2;     // Update Panel 2, 'AMessage' will be displayed

  cMaxIconsStored  = 4000;  //Max number of icons+filetype descriptions to store

  cSlideShowRunning = 32;
  cSlideShowStopped = 24;

  cThumbSmall: TPoint = (X: 104; Y: 78);
  cThumbMedium: TPoint = (X: 160; Y: 120);
  cThumbLarge: TPoint = (X: 240; Y: 180);

  // Graphics file extensions recognised by the library
  cGraphicsExt: Utf8String =
    '.bmp;.ico;.dib;.rle;.gif;.iff;.lbm;.ilbm;.jpg;.jpeg;.jpe;' +
    '.jif;.jfif;.pcd;.pcx;.dcx;.pic;.png;.psd;.tga;.tif;.tiff;' +
    '.wmf;.fax;.bw;.rgb;.rgba;.sgi;.cel;.vst;.icb;.vda;.win;' +
    '.scr;.ppm;.pgm;.pbm;.cut;.pal;.rla;.rpf;.pdd;.psp;.png;' +
    '.crw;.thm;.svg;';

  // File extensions that can have individual icons
  cApplicExt: Utf8String =
    '.exe;.com;.pif;.ico;.lnk;.cur;.doc;';

  // AVI video extension
  cAviVideoExt: Utf8String =
    '.avi;';

  // Time interval between OnProgress Events (msec)
  cProgressInterval = 300;

  cAllowDlgSaveBeforeClose = False;

type

  TSortMethodType = (smNoSort, smByID, smByName, smByNameNum, smBySize, smByType, smByDate,
    smByFolder, smByFolderID, smBySeries, smByRating, smByStatus, smByGroupCount,
    smByCRC, smRandom, smByDupeGroup, smByDescription, smByDimensions,
    smByNumItems, smByAttributes, smByFilter, smByProtection, smByVolumeLabel,
    smByShortName, smByCompression, smByOrigName, smByBand, smBySimilarity);

const

  cSortMethodName: array[TSortMethodType] of Utf8String =
    ('native order', 'ID', 'name', 'name (numeric)', 'size', 'type', 'date', 'folder', 'folder', 'series',
     'rating', 'status', 'group count', 'CRC', 'random', 'duplicate group',
     'description', 'dimensions', 'number of items', 'attributes',
     'filter', 'protection', 'volumelabel', 'folder name', 'compression',
     'original name', 'band', 'similarity');

type

  TSortDirectionType = (sdAscending, sdDescending);

type

  TFolderOptions = record
    AddHidden: boolean;    // Add hidden files
    AddSystem: boolean;    // Add system files
    GraphicsOnly: boolean; // Add graphics files only
    InclSubDirs: boolean;       // Add subdirectories too
    DeleteProtected: boolean;   // Cannot delete files from this folder
  end;

  // Save versions < 12 format.. Compatibility can be removed in one of the future
  // because it will be possible to convert with folder save version 12 (1.3x)
  TOldFolderOptions = record
    LiveUpdate: boolean;
    AddHidden: boolean;
    AddSystem: boolean;
    GraphicsOnly: boolean;
    InclSubDirs: boolean;
    DeleteProtected: boolean;
  end;
  
const

  cPrioText: array[TThreadPriority] of string =
    ('idle','lowest','lower','normal','higher','highest','crit');

type

  TListSortCustomCompare = function(Object1, Object2: TObject; Info: pointer): integer;

  // The TSimpleProgressEvent is used to exchange progress messages. APercent is a value
  // between 0 and 100 indicating the progress.
  TSimpleProgressEvent = procedure(Sender: TObject; APercent: double) of object;

  TExtData = class(TObject)
    FTypeName: string;
    FIconIndex: longint;
  end;

const
  // This maximum is used for incompatible items in ArrangeItems
  cMaxArrangeDiff = 1 shl 30;

  // plugin constants:
  // Capability Flags
  cpcMustAuthorise = $0001; // Authorisation required
  cpcIndexFiles    = $0002; // This plugin indexes files
  cpcStoreIndices  = $0004; // This plugin requires storage of indices with ABC collection
  cpcAddFilter     = $0008; // This plugin requires addition of a filter to the filter set

  // Plugin modes
  cpcModeNotLoaded  = $0000;
  cpcModeNotConnect = $0001;
  cpcModeNotAuth    = $0002;
  cpcModeEval       = $0003;
  cpcModeOK         = $0004;

  // Filter types
  cpcFilterNormal   = 0;
  cpcFilterThreaded = 1;
  cpcFilterFuzzy    = 2;

implementation

end.
