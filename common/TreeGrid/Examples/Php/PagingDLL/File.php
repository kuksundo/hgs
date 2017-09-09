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
   case "LoadBody" : echo FuncLoadBody($File,$Def,$Data,$Bonus); break;
   case "LoadPage" : echo FuncLoadPage($File,$Def,$Data,$Bonus); break;
   case "Save" : echo FuncSave($File,$Def,$Data,$Bonus); break;
   case "Export" : echo FuncExport($File,$Def,$Data,$Bonus); break;
   default: Error(-3,"Error: Unknown function");
   }

// -----------------------------------------------------------------------------
function Error($num, $mess){
$Err = TGLastError();
echo '<Grid><IO Result="'.$num.'" Message="'.$mess.($Err!=null?"&#x0A;&#x0A;".htmlentities($Err):"").'"/></Grid>';
exit();
}
// -----------------------------------------------------------------------------
// Creates and returns index of the new grid
function GetIndex($File,$Def,$Cfg,$Bonus){
global $Path;
if($File=="") return -1;
$Index = TGFindGrid($Cfg);
if ($Index >= 0) return $Index;
$F = TGGetSession($Cfg);
if($F!=null && file_exists("$Path/tmp/$F.xml")) {
   $Index = TGCreateGrid("$Path/tmp/$F.xml","$Path/$Def","$Path/../../../Grid/Defaults.xml","$Path/../../../Grid/Text.xml",$Bonus,null);
   }
else {
   $Index = TGCreateGrid("$Path/$File","$Path/$Def","$Path/../../../Grid/Defaults.xml","$Path/../../../Grid/Text.xml",$Bonus,null);
   }
return $Index;
}
// -----------------------------------------------------------------------------
// Returns grid's body
function FuncLoadBody($File,$Def,$Data,$Bonus){
global $Path;
header("Content-Type: text/xml; charset=utf-8"); 
$Index = GetIndex($File,$Def,$Data,$Bonus);
if($Index<0) Error(-1,"Server DLL Error: TreeGrid data not found or server has not permission to read them!");
$Ret = TGGetBody($Index,$Data);
if($Ret==null) Error(-4,"Server DLL Error: TreeGrid data cannot be loaded");
if(TGSaveToFile($Index,"$Path/tmp/".TGGetGridSession($Index).".xml",28)<0){ // Cannot save to tmp/
    $Ret =  str_replace("<IO ", "<IO Message='Server problem: Saving temporary data to tmp/ folder failed !' ",$Ret);
    }
return $Ret;
}
// -----------------------------------------------------------------------------
// Returns one grid's page
function FuncLoadPage($File,$Def,$Data,$Bonus){
global $Path;
header("Content-Type: text/xml; charset=utf-8"); 
$Index = GetIndex($File,$Def,$Data,$Bonus);
if($Index<0) Error(-1,"Server DLL Error: TreeGrid data not found");
$Ret = TGGetPage($Index,$Data);
if($Ret==null) Error(-3,"Server DLL Error: Configuration changed, you need to reload grid!");
return $Ret;
}
// -----------------------------------------------------------------------------
// Saves data to grid
function FuncSave($File,$Def,$Data,$Bonus){
global $Path;
header("Content-Type: text/xml; charset=utf-8"); 
$Index = GetIndex($File,$Def,$Data,$Bonus);
if($Index<0) Error(-1,"Server DLL Error: TreeGrid data not found");
$Ret = TGSave($Index,$Data);
if($Ret<0) Error($Ret,"Server DLL Error: Changes were not saved");
TGSaveToFile($Index,"$Path/tmp/".TGGetGridSession($Index).".xml",28);
if($Ret>0) Error(0,"Server DLL Warning: Not all data were successfully saved !");
Error(0,"");
}
// -----------------------------------------------------------------------------
// Returns all grid data exported to XLS / HTML 
function FuncExport($File,$Def,$Data,$Bonus){
global $Path;
$Index = GetIndex($File,$Def,$Data,$Bonus);
if($Index<0) return "Server DLL Error: TreeGrid data not found";
$Ret = TGGetExport($Index,$Data);
if($Ret==null) return "Server DLL Error: Configuration changed, you need to reload grid!";
header("Content-Type: application/vnd.ms-excel; charset=utf-8");
header("Content-Disposition: attachment; filename=\"Grid.xls\"");
header("Cache-Control: max-age=1; must-revalidate");
return $Ret;
}
// ----------------------------------------------------------------------------------------------------
</script>