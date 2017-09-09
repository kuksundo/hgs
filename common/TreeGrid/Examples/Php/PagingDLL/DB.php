<?php
$Path = dirname(__FILE__);
header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");


// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/");
require_once("../Framework/IncDbTxt.php");                 // Routines to connect to database via text file database

// --- Commandline parameters reading ---
$Function = array_key_exists("Function",$_REQUEST) ? $_REQUEST["Function"] : "";
$Table = array_key_exists("Table",$_REQUEST) ? $_REQUEST["Table"] : "";
$Def = array_key_exists("Def",$_REQUEST) ? $_REQUEST["Def"] : "";
$Data = array_key_exists("Data",$_REQUEST) ? $_REQUEST["Data"] : ""; if(get_magic_quotes_gpc()) $Data = stripslashes($Data);
$Bonus = array_key_exists("Bonus",$_REQUEST) ? $_REQUEST["Bonus"] : ""; if(get_magic_quotes_gpc()) $Bonus = stripslashes($Bonus);

// --- calling main function ---
switch($Function){
   case "LoadBody" : echo FuncLoadBody($Table,$Def,$Data,$Bonus); break;
   case "LoadPage" : echo FuncLoadPage($Table,$Def,$Data,$Bonus); break;
   case "Save" : echo FuncSave($Table,$Def,$Data,$Bonus); break;
   case "Export" : echo FuncExport($Table,$Def,$Data,$Bonus); break;
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
   return TGCreateGrid("$Path/tmp/$F.xml","$Path/$Def","$Path/../../../Grid/Defaults.xml","$Path/../../../Grid/Text.xml",$Bonus,null);
   }
   
// --- Loading data from database ---
$db = new Database("../Database");               // Database in folder "Database"
$rows = $db->Query("SELECT * FROM " . $File)->GetRows();
$S = "<Grid><Body><B>";
foreach($rows as $row){
   $H = $row["Hours"]; if($H==floor($H)) $H = floor($H);  // !!! TreeGrid cannot accept float value ending with .0, like 40.0
   $S .= "<I id='" . $row["ID"] . "'" 
      . " Project='" . htmlspecialchars($row["Project"],ENT_QUOTES) . "'"
      . " Resource='" . htmlspecialchars($row["Resource"],ENT_QUOTES) . "'"
      . " Week='" . floor($row["Week"]) . "'"
      . " Hours='"  . $H . "'"
      . "/>\n";
      }
$S .= "</B></Body></Grid>";

// --- Creating grid from data ---   
return TGCreateGrid($S,"$Path/$Def","$Path/../../../Grid/Defaults.xml","$Path/../../../Grid/Text.xml",$Bonus,null);
}
// -----------------------------------------------------------------------------
// Returns grid's body
function FuncLoadBody($File,$Def,$Data,$Bonus){
global $Path;
header("Content-Type: text/xml; charset=utf-8");
$Index = GetIndex($File,$Def,$Data,$Bonus);
if($Index<0) Error(-1,"Server DLL Error: TreeGrid data not found or server has not permission to read them!");
$Ret = TGGetBody($Index,$Data);
if($Ret==null) return Error(-4,"Server DLL Error: TreeGrid data cannot be loaded");
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

// --- Save changes to DLL ---
$Index = GetIndex($File,$Def,$Data,$Bonus);
if($Index<0) Error(-1,"Server DLL Error: TreeGrid data not found");
$Ret = TGSave($Index,$Data);
if($Ret<0) Error($Ret,"Server DLL Error: Changes were not saved");
TGSaveToFile($Index,"$Path/tmp/".TGGetGridSession($Index).".xml",28);

// --- Save changes to database ---
$db = new Database("../Database");               // Database in folder "Database"
$XML = $Data;
if(get_magic_quotes_gpc()) $XML = stripslashes($XML);
      
// --- simple xml or php xml --- 
$SXML = is_callable("simplexml_load_string");
if(!$SXML) require_once("../Framework/Xml.php");
if($SXML){ 
   $Xml = simplexml_load_string(html_entity_decode($XML));
   $Xml = $Xml->Changes->I;
   }
else { 
   $Xml = CreateXmlFromString(html_entity_decode($XML));
   $Xml = $Xml->getElementsByTagName("I");
   }
foreach($Xml as $I){
   $A = $SXML ? $I->attributes() : $I->attributes;
   // --- end of simple xml or php xml --- 
       
   if($A["Deleted"]){
      $db->Exec("DELETE FROM $File WHERE ID='".$A["id"]."'");
      }
   else if($A["Added"]){
      $db->Exec("INSERT INTO $File(ID,Project,Resource,Week,Hours) VALUES("
            . $A["id"] . "," 
            . "'" . str_replace("'","''",$A["Project"]) . "',"
            . "'" . str_replace("'","''",$A["Resource"]) . "',"
            . $A["Week"] . ","
            . $A["Hours"] .")");
      }
   else if($A["Changed"]){
      $S = "UPDATE $File SET ";
      foreach($A as $name => $value){
         if($name=="Project" || $name=="Resource") $S .= "$name = '" . str_replace("'","''",$value) . "',";
         else if($name=="Week" || $name=="Hours") $S .= "$name = " . $value . ",";
         }
      $S = substr($S,0,strlen($S)-1);
      $S .= " WHERE ID='".$A["id"]."'";
      $db->Exec($S);
      }
   }
   
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
