<?php
//! Support file only, run Grouping.html instead !
// This file is used as Page_Url
// Generates data for one TreeGrid page or parent row from database, according to grouping information
//! Demonstrates Server paging with server child paging
// This is only simple example with not ideal database access (for every page gets all data)
// Single file, without using TreeGridFramework.php


// ------------------------------------------------------------------------------------------------------------------------------- 
// Writes one level of grouped children
// Uses recursion to write next levels
// Level is actual level to write
// Where is WHERE clause for SQL, for every level there is added one condition
// GroupCols, Cmd, Levels are static paramterers
// Start is used only for level 0 to specify how much rows to ignore before the page
function WriteLevel($Level, $Where, $GroupCols, $db, $Levels, $Start) {
$name = "";
if ($Level == $Levels) $rs = $db->Query("SELECT * FROM TableData" . $Where);
else {
   $name = $GroupCols[$Level];
   $rs = $db->Query("SELECT DISTINCT " . $name . " FROM TableData" . $Where);
   }
$rows = $rs->GetRows();
$cnt = count($rows);
if($Level==0 && $Start+21<$cnt) $cnt = $Start + 21; // 21 rows per page on level 0
for($i = $Level==0?$Start:0; $i<$cnt;$i++){
   $row = $rows[$i];
   if ($Level == $Levels) {    // Final, writing data row
      echo "<I id='" . $row["ID"] . "'";
      echo " Project='" . htmlspecialchars($row["Project"],ENT_QUOTES) . "'";
      echo " Resource='" . htmlspecialchars($row["Resource"],ENT_QUOTES) . "'";
      echo " Week='" . $row["Week"] . "'";
      echo " Hours='" . $row["Hours"] . "'";
      echo "/>";
      }
   else {                    // Next grouping row     
      echo "<I Def='Group' Project='" . htmlspecialchars($row[$name],ENT_QUOTES) . "'"; // writes the grouping row
      $Where2 = ($Level == 0 ? " WHERE " : " AND ") . $name . "=";
      if ($name == "Week" || $name == "Hours") $Where2 .= $row[$name];
      else $Where2 .= "'" . str_replace("'","''",$row[$name]) . "'";
      $Rows = ($Level + 1) . $Where . $Where2; // Builds new attribute Rows for identification
      echo " Rows='" . htmlspecialchars($Rows,ENT_QUOTES) . "' Count='1'></I>"; // Sets Count to 1 instead of searching exact count of children to speed up the process
      }
   }
}
// -------------------------------------------------------------------------------------------------------------------------------

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
if(!$XML) $XML = "<Grid><Cfg GroupCols='Resource'/><Body><B Pos='2'/></Body></Grid>"; // Just for examples if called directly
      
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

// --- Parses Grouping settings ---
$cnt = 0; $GC[0] = "";
if(!empty($Cfg["GroupCols"])){
   $x = strtok($Cfg["GroupCols"],",");
   while($x!==false){
      $GC[$cnt++] = $x;
      $x = strtok(",");
      }
   }

// --- Writes data for requested page ---   
echo "<Grid><Body>"; // XML Header
$Rows = $B["Rows"];
if ($Rows != "") {
   echo "<B Rows='" . htmlspecialchars($Rows,ENT_QUOTES) . "'>"; // XML Header
   $Level = substr($Rows[0],0,1);
   $Rows = substr($Rows[0],1); 
   WriteLevel($Level, $Rows, $GC, $db, $cnt, 0);
   }
else {
   echo "<B Pos='" . $B["Pos"] . "'>"; // XML Header
   WriteLevel(0, "", $GC, $db, $cnt, $B["Pos"]*21); // 21 = PageLength
   }
echo "</B></Body></Grid>"; // XML Footer
   
// -------------------------------------------------------------------------------------------------------------------------------
?>