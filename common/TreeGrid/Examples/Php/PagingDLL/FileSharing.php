<?php
$Path = dirname(__FILE__);
header("Cache-Control: max-age=1; must-revalidate");

// --- Commandline parameters reading ---
$Function = array_key_exists("Function",$_REQUEST) ? $_REQUEST["Function"] : "";
$File = array_key_exists("File",$_REQUEST) ? $_REQUEST["File"] : "";
$Def = array_key_exists("Def",$_REQUEST) ? $_REQUEST["Def"] : "";
$Data = array_key_exists("Data",$_REQUEST) ? $_REQUEST["Data"] : ""; if(get_magic_quotes_gpc()) $Data = stripslashes($Data);
$Bonus = array_key_exists("Bonus",$_REQUEST) ? $_REQUEST["Bonus"] : ""; if(get_magic_quotes_gpc()) $Bonus = stripslashes($Bonus);

// --- calling main function ---
switch($Function){
   case "LoadBody" : echo FuncLoadBody($File,$Def,$Data); break;
   case "LoadPage" : echo FuncLoadPage($Data); break;
   case "Save" : echo FuncSave($File,$Data); break;
   case "CheckUpdates" : echo FuncCheckUpdates($File,$Data); break;
   default: Error(-3,"Error: Unknown function");
   }

// -----------------------------------------------------------------------------
function Error($num, $mess){
$Err = $num!=0 ? TGLastError() : null;
echo '<Grid><IO Result="'.$num.'" Message="'.$mess.($Err!=null?"&#x0A;&#x0A;".htmlentities($Err):"").'"/></Grid>';
exit();
}

// ----------------------------------------------------------------------------------------------------
// Returns grid data, for Paging==3 returns only empty pages with information about their content
// Cfg contains XML with grid settings - sorting and filters
function FuncLoadBody($File,$Def,$Cfg){
global $Path;
header("Content-Type: text/xml; charset=utf-8"); 
TGEnterWrite();          // Enter critical section, because searching grid and creating new instance should not be interrupted by other request
$Index = TGFindGrid($Cfg); // Searches for grid according to Session attribute - if this grid exists already
if ($Index < 0) { // No instance of the grid exists
    $Ident = "<Grid><Cfg Ident='$File'/></Grid>"; // Group identification for save, uses custom TreeGrid attribute
    $Grids = TGFindGridsStr(1, $Ident, 0, 0);
    $CfgPaging = "<Grid><Cfg Paging='3' ChildPaging='3'/></Grid>";
    $F = "$Path/tmp/Shared$File";
    if(!file_exists($F)) $F = "$Path/$File";
    if ($Grids == null) { // The first instance for saving of the grid does not exist, it will be created
        TGCreateGrid($F,"$Path/$Def","$Path/../../../Grid/Defaults.xml","$Path/../../../Grid/Text.xml",$CfgPaging,$Ident);
        }
    $Index = TGCreateGrid($F,"$Path/$Def","$Path/../../../Grid/Defaults.xml","$Path/../../../Grid/Text.xml",$CfgPaging,$Ident);
    }

TGLeaveWrite();
if($Index<0) Error(-1,"Server DLL Error: TreeGrid data not found or server has not permission to read them!");
$Ret = TGGetBody($Index,$Cfg);
if($Ret==null) Error(-4,"Server DLL Error: TreeGrid data cannot be loaded");
return $Ret;
}
// -----------------------------------------------------------------------------
// Returns children of one page or one row
// Cfg contains XML with page index or row id and grid settings - sorting and filters
function FuncLoadPage($Cfg){
global $Path;
header("Content-Type: text/xml; charset=utf-8"); 
$Index = TGFindGrid($Cfg);
if($Index<0) Error(-3, "Server DLL Error: Your temporary data have been deleted already, please reload grid!&#x0A;&#x0A;Or you are running PHP as CGI and not ISAPI.");
$Ret = TGGetPage($Index,$Cfg);
if($Ret==null) Error(-3,"Server DLL Error: Configuration changed, you need to reload grid!");  // Unexepected error
return $Ret;
}
// -----------------------------------------------------------------------------
// Saves changed data to XML file and also to all references of this file in memory
// Changes contains XML with changed rows
// File is data file to save data to
function FuncSave($File,$Changes){
global $Path;
header("Content-Type: text/xml; charset=utf-8"); 
$Ident = "<Grid><Cfg Ident='$File'/></Grid>"; // Group identification for save, uses custom TreeGrid attribute
$Grids = TGFindGridsStr(100, $Ident, 0, 0); // Looks for all instances of the File in memory, the first instance will be saved to file, other will be updated only
if($Grids==null) Error(-3, "Server DLL Error: Your temporary data have been deleted already, you cannot save your changes any more, please reload grid!");
$Grids = explode(',', $Grids);
$cnt = count($Grids);
$Ret = TGSave($Grids[0], $Changes);
if($Ret<0) Error($Ret, "Server DLL Error: Changes were not saved");
$SRet = TGSaveToFile($Grids[0], "$Path/tmp/Shared$File", 24); // Saves to Tmp directory instead to original file
if($SRet<0) Error($Ret, "Server DLL Error: Cannot save data to disk");

$Idx = TGFindGrid($Changes);
for($i=1;$i<$cnt;$i++) TGSaveEx($Grids[$i], $Changes, $i == $Idx ? 2 : 1); // Updates all other instances in memory
if ($Ret > 0) Error(0, "Warning: Not all data were successfully saved !");
$Chg = TGGetChanges($Idx, 1); // Returns changes done by another user or if generated id collide with ids on server
if($Chg==null) $Chg = "";
return "<Grid><IO Result='0'/><Cfg LastId='" . TGGetLastId($Idx) . "'/>" . $Chg . "</Grid>";
}
// ----------------------------------------------------------------------------------------------------
// Returns all updates done by other clients
// Cfg contains XML session, here is ignored
// File is data file to identify updates
function FuncCheckUpdates($File, $Cfg) {
$Index = TGFindGrid($Cfg);
if($Index<0) Error(0, ""); // The grid was deleted already, this is error
$Chg = TGGetChanges($Index,1);
if($Chg!=null) {
    return "<Grid><IO Result='0' UpdateMessage='The data on server have been modified by another user, do you want to update your data?'/>"
        . "<Cfg LastId='" . TGGetLastId($Index) . "'/>"
        . $Chg . "</Grid>";
    }
Error(0, "");
}
// ----------------------------------------------------------------------------------------------------
?>