{ sdAbcVars

  This unit hosts all global variables of the AbcView app

  author: Nils Haeck M.Sc.
  date: 27mar2011
  copyright (c) 2011 SimDesign (www.simdesign.nl)
}
unit sdAbcVars;

interface

uses
  Graphics, GraphicEx, Classes, Controls, kbShellNotify, SysUtils, sdAbcTypes;

var

  // Sorting
  FSortTypeWithExt: boolean = True; // When sorting on type, use extension

  // Backgrounds
  FMainBgrColor: TColor = $00C5B9AF;
  FMainBgrFile: Utf8String = '';
  FMainBgrFont: TFont = nil;

  FShowBgrColor: TColor = $00C5B9AF;
  FShowBgrFile: Utf8String = '';
  FShowBgrFont: TFont = nil;

  FOverrideListviewBgr: boolean = False;

  // Add Folders
  FFolderOptions: TFolderOptions =
    ( AddHidden: false;
      AddSystem: false;
      GraphicsOnly: false;
      InclSubDirs: true;
      DeleteProtected: false );

  FAddDialogFolder: Utf8String = ''; // Initial Add Dialog folder

  // Application
  FStartCount: integer;          // Number of starts

  // Browser
  FThumbnailCache: integer = 20; // Thumbnail Cache size in Mb
  FGraphicsCache:  integer = 10; // Graphics Cache size in Mb
  // Number of simultaneous decode threads. The default is 1 but on multiprocessor
  // machines the user can set this to 2 or more.
  FDecodeThreads:  integer = 1;
  FDecodePriority: TThreadPriority = tpNormal; // priority of decode threads

  FAutoVerify: boolean = True;  // Verify file existance automatically
  FAutoThumb: boolean  = False; // Read ahead while thumbnailing
  FAutoCRC: boolean    = False; // CRC each file automatically
  FAutoSCRC: boolean   = False; // Calculate small CRC for each file automatically
  FAutoPixRef: boolean = False; // Create a pixel ref of each filea automatically

  glAutoFlush: boolean  = True;  // Automatically flush items in the batchlist

  FUpdateFromBgr: boolean = False; // Background process causes updates

  FShowInfotip: boolean = True; // Show infotip in listviews

  // Thumbnails
  FThumbWidth:  integer = 104;
  FThumbHeight: integer = 78;

  FStoreThumbs: boolean = True;
  FThumbCompress: word = cThumbCompressNone;
  FStoreThumbJPGQual: integer = 80;
  FThumbHQ: boolean = True;

  FViewListW: integer = 16;
  FViewListH: integer = 16;
  FViewListShowIcons: boolean = True;

  FViewSmallW: integer = 16;
  FViewSmallH: integer = 16;
  FViewSmallShowIcons: boolean = True;

  FViewLargeW: integer = 32;
  FViewLargeH: integer = 32;
  FViewLargeShowIcons: boolean = True;

  FViewDetailW: integer = 16;
  FViewDetailH: integer = 16;
  FViewDetailShowIcons: boolean = True;

  // Pixel reference
  FGranularity: integer = cmg4x4pixels;
  FMatchMethod: integer = cmmColors;
  FMatchTolerance: integer = 4;
  FMatchFuzzy: boolean = False;
  FSimilaritySortMethod: integer = cssmAutoMethod;
  FSimAutoLimit: integer = 5000;

  // Show Form
  FWinShowToolbars: boolean = True;
  FFullShowToolbars: boolean = False;
  FWinShrinkFit: boolean = True;
  FWinGrowFit: boolean = False;
  FFullShrinkFit: boolean = False;
  FFullGrowFit: boolean = False;

  FAdvanceMouseWheel: boolean = True;
  FAdvanceMouseClick: boolean = False;

  // Ini file storage
  FIniFile: TFileName;

  FSettingsChanged: boolean = False; // The option dialog settings have changed

  // Folders
  FAppFolder: Utf8String = '';          // Application's root folder
  FTempFolder: Utf8String = '';         // Folder containing temporary files
  FTempFileNum: integer = 1;        // First tempfile number (eg '00000001.tmp')
  FLoadFileName: Utf8String = '';       // Name of file to load
  FLoadSaveFolder: Utf8String = '';     // Initial directory

  // Windowing
  FSingleMode: boolean = false;      // Single/Dual mode

  // Recycling files
  FProtectWarn: boolean = true;     // Warn when user tries to delete files from protected folder
  FDeleteConfirm: TDeleteConfirm = dcDialog;
  FSingleFileNoWarn: boolean = false;  // Do not warn when deleting single file
  FUseRecycleBin: boolean  = true;  // Use the recycle bin when deleting

  FArchiveFolder: Utf8String = '';      // Archive folder name
  FZipFileName: Utf8String = 'deleted.zip'; // Default ZIP archive filename

  // Scanning
  FRescanAfterLoad: boolean = true; // Rescan the folders after opening catalog
  FScanPriority: TThreadPriority = tpLower;

  // Monitoring
  FShellNotify: boolean = true;    // Shell notification
  FShellNotifyRef: integer = 0;     // Reference count, only if 0 the shell notify is active
  FFocusNew: boolean = false;          // Focus on the updated file

  // Slideshow
  FSlideShow: boolean = false;     // Slideshow is running
  FSlideShowDelay: integer = 2500; // Slide show delay in msec
  FSlideShowDir: TSlideShowDir = sdForward;
  FWrapAround: boolean = True;
  FHideMouse: boolean = True;
  FResampleWhenSlide: boolean = False;

  FDebugThreadException: boolean = false;

  // General control settings
  FItemHistoryCount: integer = 8;

  // Set VerboseStatus to True to avoid statusline being overwritten by
  // selection status.
  FVerboseStatus: boolean = False;

  // Smart Select
  FSmartSelectMaskCount: integer = 3; // Number of mask characters for file name numbers
  FSmartSelectFileCount: integer = 100; // Maximum number of files allowed before decreasing mask no
  FSmartSelectFolderEqual: boolean = True; // Must be equal folder?

  // Color Grouping
  FColorGrouping: integer = cColorGroupingPastel; // Use the color bands in the listview
  FGroupingInUse: boolean = False;   // Flag indicates if color grouping is in use

  // Tip of day
  FTipOfDay: boolean = True;    // Show the tip of the day
  FTipOfDayNumber: integer = 0; // The current Tip of Day number

  // Dupe Filter
  FDupeFilterNotify: boolean = True;            // Notify user when filter finished
  FDupeFilterSortOnDupes: boolean = True;       // Sort on dupe group when finished
  FDupeFilterDisplayDialog: boolean = True;     // Display dialog on startup

  // Plugins
  FPluginIndexFiles: boolean = False; // Do an automatic custom indexing of plugins
  FPluginAddFilter: boolean = False; // Add a filter to the list for plugins

  FHasDXFPlugin: boolean = False; // 3rd party plugin to read DXF
  FHasDWGPlugin: boolean = False; // 3rd party plugin to read DWG
  FHasAVIPlugin: boolean = False; // plugin to read AVI
  FHasTTFPlugin: boolean = False; // plugin to read TTF
  FHasJP2Plugin: boolean = False; // plugin to read JPeg2000
  FHasSvgPlugin: boolean = False; // plugin to read SVG (simdesign)
  // Use these plugins yes/no
  FUseDXFPlugin: boolean = True;
  FUseDWGPlugin: boolean = True;
  FUseAVIPlugin: boolean = True;
  FUseTTFPlugin: boolean = True;
  FUseJP2Plugin: boolean = True;
  FUseSvgPlugin: boolean = True;

  // Graphic resampling
  FResamplingOnTheFly: boolean = True;
  FResamplingFilter: TResamplingFilter = sfLanczos3;
  FResamplingDelay: integer = 300;

  FSmallIcons,
  FLargeIcons: TImageList; // System image lists used by listviews

  // Windows version
  FWindowsVer: TkbWindowsVersion;


  FFileTypeNames: TStringList;
  FKnownExt:      TStringList;

implementation

end.
