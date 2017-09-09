<?php
// ! Support file only, run AjaxTablePaging.html instead !
// This file is used as Page_Url
// Generates data for one TreeGrid page from database, according to sorting information
// This is only simple example with not ideal database access (for every page gets all data)
// Single file, without using TreeGridFramework.asp

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------
// --- Gets cfg ---
$XML = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
if(get_magic_quotes_gpc()) $XML = stripslashes($XML);
if(!$XML) $XML = "<Grid><Cfg SortCols='' SortTypes=''/><Body><B Pos='2'/></Body></Grid>";   // Just for examples if called directly    

// --- simple xml or php xml --- 
$SXML = is_callable("simplexml_load_string");
if(!$SXML) require_once("../Framework/Xml.php"); 
if($SXML){ 
   $Xml = simplexml_load_string(html_entity_decode($XML));
   $Cfg = $Xml->Cfg[0];
   $B = $Xml->Body->B[0];
   }
else { 
   $Xml = CreateXmlFromString(html_entity_decode($XML));
   $Cfg = $Xml->getElementsByTagName($Xml->documentElement,"Cfg"); $Cfg = $Cfg[0];
   $B = $Xml->getElementsByTagName($Xml->documentElement,"B"); $B = $B[0];
   } 
$Cfg = $SXML ? $Cfg->attributes() : $Xml->attributes[$Cfg];
$B = $SXML ? $B->attributes() : $Xml->attributes[$B];
// --- end of simple xml or php xml ---     


// --- Parses sorting settings ---
$x = strtok($Cfg["SortCols"],",");
$cnt = 0;
while($x!==false){
   $SC[$cnt++] = $x;
   $x = strtok(",");
   }

$x = strtok($Cfg["SortTypes"],",");
$i = 0;
while($x!==false){
   $ST[$i++] = $x;
   $x = strtok(",");
   }

$S = "";
for($i=0;$i<$cnt;$i++){
   if($S!="") $S .= ", ";
   $S = $S . $SC[$i];
   if($ST[$i] >= 1) $S .= " DESC";
   }
if($cnt) $S = " ORDER BY " . $S;

// --- Gets information about page number ---
$start = $B["Pos"]*21;   // PageLength


// --- Reads data from database ---
$rows = $db->Query("SELECT * FROM TableData" . $S); $rows = $rows->GetRows();

// --- Writes data for requested page ---
echo "<Grid><Body><B Pos='" . $B["Pos"] . "'>";
$cnt = count($rows);
if($cnt>$start+21) $cnt = $start+21;
for($i=$start;$i<$cnt;$i++){
   $row = $rows[$i];
   echo "<I id='" . $row["ID"] . "'" 
         . " Project='" . htmlspecialchars($row["Project"],ENT_QUOTES) . "'"
         . " Resource='" . htmlspecialchars($row["Resource"],ENT_QUOTES) . "'"
         . " Week='" . $row["Week"] . "'"
         . " Hours='"  . $row["Hours"] . "'"
         . "/>";
   }         
echo "</B></Body></Grid>";
// --------------------------------------------------------------------------
?>