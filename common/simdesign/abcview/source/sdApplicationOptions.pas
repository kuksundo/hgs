{ Unit GlobalVars

  This unit contains global variables and types.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit sdApplicationOptions;

interface

uses

  Graphics, Classes, Controls, sdRoots, GraphicEx, Filters, SysUtils,
  SyncObjs, guiFolderOptions, Windows, sdOptionRefs, kbShellNotify, guiProcess,
  sdAbcTypes, sdAbcVars, sdAbcFunctions;



var

  SaveOpt: TOptionsManager; // Options that the user must explicitly save in "options"
  AutoOpt: TOptionsManager; // Options that are automatically saved

procedure CreateOptions;
procedure DestroyOptions;

implementation

uses
  {Utils,} guiMain, sdItems, guiPlugins;

procedure CreateOptions;
begin
  SaveOpt := TOptionsManager.Create(nil);
  AutoOpt := TOptionsManager.Create(nil);

  // All the stored options are listed here

  // Sorting
  SaveOpt.Add(FSortTypeWithExt, '', 'SortTypeWithExt');

  // Backgrounds
  SaveOpt.Add(FMainBgrColor, '', 'MainBgrColor');
  SaveOpt.Add(FMainBgrFile, '', 'MainBgrFile');

  SaveOpt.Add(FShowBgrColor, '', 'ShowBgrColor');
  SaveOpt.Add(FShowBgrFile, '', 'ShowBgrFile');
  SaveOpt.Add(FOverrideListviewBgr, '', 'OverrideListviewBgr');

  // Add default folder options
  SaveOpt.Add(FFolderOptions.AddHidden, 'Folder', 'AddHidden');
  SaveOpt.Add(FFolderOptions.AddSystem, 'Folder', 'AddSystem');
  SaveOpt.Add(FFolderOptions.GraphicsOnly, 'Folder', 'GraphicsOnly');
  SaveOpt.Add(FFolderOptions.InclSubdirs, 'Folder', 'InclSubdirs');
  SaveOpt.Add(FFolderOptions.DeleteProtected, 'Folder', 'DeleteProtected');

  // Application
  AutoOpt.Add(FStartCount, 'Application', 'StartCount'); // Number of starts

  // Browser
  SaveOpt.Add(FThumbnailCache, 'Memory', 'ThumbnailCache'); // Thumbnail Cache size in Mb
  SaveOpt.Add(FGraphicsCache, 'Memory', 'GraphicsCache'); // Graphics Cache size in Mb
  SaveOpt.Add(FDecodeThreads, 'Memory', 'DecodeThreads');  // Number of simultaneous decode threads
  SaveOpt.Add(byte(FDecodePriority), 'Memory', 'DecodePriority'); // priority of decode threads

  SaveOpt.Add(FAutoVerify, 'Background', 'AutoVerify');  // Verify file existance automatically
  SaveOpt.Add(FAutoThumb, 'Background', 'AutoThumb');  // Read ahead while thumbnailing
  SaveOpt.Add(FAutoCRC, 'Background', 'AutoCRC'); // CRC each file automatically
  SaveOpt.Add(FAutoSCRC, 'Background', 'AutoSCRC');
  SaveOpt.Add(FAutoPixRef, 'Background', 'AutoPixRef'); // Create a pixel ref of each filea automatically
  SaveOpt.Add(glAutoFlush, 'Background', 'AutoFlush');  // Automatically flush items in the batchlist

  SaveOpt.Add(FUpdateFromBgr, 'Background', 'UpdateFromBgr'); // Background process causes updates

  SaveOpt.Add(FShowInfotip, 'Browser', 'ShowInfoTip'); // Show infotip in listviews
  SaveOpt.Add(FColorGrouping, 'Browser', 'ColorGrouping');

  // Thumbnails
  SaveOpt.Add(FThumbWidth, 'Thumbnails', 'ThumbWidth');
  SaveOpt.Add(FThumbHeight, 'Thumbnails', 'ThumbHeight');

  SaveOpt.Add(FStoreThumbs, 'Thumbnails', 'StoreThumbs');
  SaveOpt.Add(FThumbCompress, 'Thumbnails', 'ThumbCompress');
  SaveOpt.Add(FStoreThumbJPGQual, 'Thumbnails', 'StoreThumbJPGQual');
  SaveOpt.Add(FThumbHQ, 'Thumbnails', 'ThumbHQ');

  SaveOpt.Add(FViewListW, 'Thumbnails', 'ViewListW');
  SaveOpt.Add(FViewListH, 'Thumbnails', 'ViewListH');
  SaveOpt.Add(FViewListShowIcons, 'Thumbnails', 'ViewListShowIcons');

  SaveOpt.Add(FViewSmallW, 'Thumbnails', 'ViewSmallW');
  SaveOpt.Add(FViewSmallH, 'Thumbnails', 'ViewSmallH');
  SaveOpt.Add(FViewSmallShowIcons, 'Thumbnails', 'ViewSmallShowIcons');

  SaveOpt.Add(FViewLargeW, 'Thumbnails', 'ViewLargeW');
  SaveOpt.Add(FViewLargeH, 'Thumbnails', 'ViewLargeH');
  SaveOpt.Add(FViewLargeShowIcons, 'Thumbnails', 'ViewLargeShowIcons');

  SaveOpt.Add(FViewDetailW, 'Thumbnails', 'ViewDetailW');
  SaveOpt.Add(FViewDetailH, 'Thumbnails', 'ViewDetailH');
  SaveOpt.Add(FViewDetailShowIcons, 'Thumbnails', 'ViewDetailShowIcons');

  // PixRef
  SaveOpt.Add(FGranularity, 'Similarity', 'Granularity');
  SaveOpt.Add(FMatchMethod, 'Similarity', 'MatchMethod');
  SaveOpt.Add(FMatchTolerance, 'Similarity', 'MatchTolerance');
  SaveOpt.Add(FMatchFuzzy, 'Similarity', 'MatchFuzzy');
  SaveOpt.Add(FSimilaritySortMethod, 'Similarity', 'SortMethod');
  SaveOpt.Add(FSimAutoLimit, 'Similarity', 'SimAutoLimit');

  // Show Form
  SaveOpt.Add(FWinShowToolbars, 'Form', 'WinShowToolbars');
  SaveOpt.Add(FFullShowToolbars, 'Form', 'FullShowToolbars');
  SaveOpt.Add(FWinShrinkFit, 'Form', 'WinShrinkFit');
  SaveOpt.Add(FWinGrowFit, 'Form', 'WinGrowFit');
  SaveOpt.Add(FFullShrinkFit, 'Form', 'FullShrinkFit');
  SaveOpt.Add(FFullGrowFit, 'Form', 'FullGrowFit');
  // Windowing
  SaveOpt.Add(FSingleMode, 'Form', 'SingleMode');      // Single/Dual mode

  SaveOpt.Add(FAdvanceMouseWheel, 'Form', 'AdvanceMouseWheel');
  SaveOpt.Add(FAdvanceMouseClick, 'Form', 'AdvanceMouseClick');

  // Plugins
  SaveOpt.Add(FUseDXFPlugin, 'Plugins', 'UseDXFPlugin');
  SaveOpt.Add(FUseAVIPlugin, 'Plugins', 'UseAVIPlugin');
  SaveOpt.Add(FUseTTFPlugin, 'Plugins', 'UseTTFPlugin');
  SaveOpt.Add(FUseJP2Plugin, 'Plugins', 'UseJP2Plugin');

  // Folders
  AutoOpt.Add(FTempFolder, 'Folders', 'TempFolder');         // Folder containing temporary files
  AutoOpt.Add(FLoadFileName, 'Folders', 'LoadfileName');     // Name of file to load
  AutoOpt.Add(FLoadSaveFolder, 'Folders', 'LoadSaveFolder'); // Initial directory
  AutoOpt.Add(FAddDialogFolder, 'Folders', 'AddDialogFolder'); // Default folder in "Add Folder" Dialog

  // Recycling files
  SaveOpt.Add(FProtectWarn, 'User', 'ProtectWarn');     // Warn when user tries to delete files from protected folder
  SaveOpt.Add(byte(FDeleteConfirm), 'User', 'DeleteConfirm');
  SaveOpt.Add(FSingleFileNoWarn, 'User', 'SingleFileNoWarn');  // Do not warn when deleting single file
  SaveOpt.Add(FUseRecycleBin, 'User', 'UseRecycleBin');  // Use the recycle bin when deleting

  AutoOpt.Add(FArchiveFolder, 'File', 'ArchiveFolder');      // Archive folder name
  AutoOpt.Add(FZipFileName, 'File', 'ZipFileName'); // Default ZIP archive filename

  // Scanning
  SaveOpt.Add(FRescanAfterLoad, 'Monitor', 'RescanAfterLoad'); // Rescan the folders after opening catalog
  SaveOpt.Add(byte(FScanPriority), 'Monitor', 'ScanPriority');

  // Monitoring
  SaveOpt.Add(FShellNotify, 'Monitor', 'ShellNotify');    // Show all newly appearing files
  SaveOpt.Add(FFocusNew, 'Monitor', 'FocusNew');          // Focus on the updated file

  // Slideshow
  SaveOpt.Add(FSlideShowDelay, 'Slideshow', 'SlideshowDelay'); // Slide show delay in msec
  SaveOpt.Add(byte(FSlideShowDir), 'Slideshow', 'SlideshowDir');
  SaveOpt.Add(FWrapAround, 'Slideshow', 'WrapAround');
  SaveOpt.Add(FHideMouse, 'Slideshow', 'HideMouse');
  SaveOpt.Add(FResampleWhenSlide, 'Slideshow', 'ResampleWhenSlide');

  // Graphic resampling
  SaveOpt.Add(FResamplingOnTheFly, 'Graphic', 'ResamplingOnTheFly');
  SaveOpt.Add(byte(FResamplingFilter), 'Graphic', 'ResamplingFilter');
  SaveOpt.Add(FResamplingDelay, 'Graphic', 'ResamplingDelay');

  // General control settings
  SaveOpt.Add(FItemHistoryCount, 'General', 'ItemHistoryCount');

  // Smart Select
  SaveOpt.Add(FSmartSelectMaskCount, 'SmartSelect', 'MaskCount');
  SaveOpt.Add(FSmartSelectFileCount, 'SmartSelect', 'FileCount');
  SaveOpt.Add(FSmartSelectFolderEqual, 'SmartSelect', 'FolderEqual');

  // Tip of day
  AutoOpt.Add(FTipOfDay, 'General', 'TipOfDay');
  AutoOpt.Add(FTipOfDayNumber, 'General', 'TipOfDayNumber');

end;

procedure DestroyOptions;
begin
  AutoOpt.SaveToIni(FIniFile);
  FreeAndNil(SaveOpt);
  FreeAndNil(AutoOpt);
end;

// This procedure is run only once during initialization of the unit;
// so only once even if you have multiple instances
procedure DoInitialization;
begin
  // Get the system icons
  CreateSystemImages(FSmallIcons, FLargeIcons);

  // Windows version
  FWindowsVer := GetWindowsVersion;

  FFileTypeNames := TStringList.Create;
  FKnownExt := TStringList.Create;
  FKnownExt.Sorted := true;

  // Create plugins
  glPlugins := TPluginList.Create;
  PluginGlobalVars;

  // 3rd party plugins
  Load3rdPartyPlugins;
end;

procedure DoFinalization;
var
  i: integer;
begin
  FreeAndNil(FMainBgrFont);
  // Free extension list
  for i := 0 to FKnownExt.Count - 1 do
    FKnownExt.Objects[i].Free;
  FreeAndNil(FKnownExt);
  FreeAndNil(FSmallIcons);
  FreeAndNil(FLargeIcons);
  FreeAndNil(glPlugins);
  Unload3rdPartyPlugins;
end;

initialization;

  DoInitialization;

finalization;

  DoFinalization;

end.
