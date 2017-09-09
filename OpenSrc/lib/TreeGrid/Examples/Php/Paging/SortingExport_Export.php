<?php
//! Support file only, run AjaxTablePaging.html instead !
// This file is used as Export_Url
// Generates data to export to Excel
// Single file, without using TreeGridFramework.php

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

// --- Response initialization ---
$file = array_key_exists("File",$_REQUEST) ? $_REQUEST["File"] : ""; 
if($file=="") $file="Export.xls";
header("Content-Type: application/vnd.ms-excel; charset=utf-8");
header("Content-Disposition: attachment; filename=\"" . $file . "\"");
header("Cache-Control: max-age=1; must-revalidate");

// --- Gets cfg ---
$XML = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
if(get_magic_quotes_gpc()) $XML = stripslashes($XML);
if(!$XML) $XML = "<Grid><Cfg SortCols='Week,Hours' SortTypes='1,0'/><Cols><C Name='Project' Visible='1' Width='200'/><C Name='Resource' Visible='1' Width='150'/><C Name='Week' Visible='1' Width='60'/><C Name='Hours' Visible='1' Width='60'/></Cols></Grid>"; // Just for examples if called directly

// --- simple xml or php xml --- 
$SXML = is_callable("simplexml_load_string");
if(!$SXML) require_once("../Framework/Xml.php");
if($SXML){ 
   $Xml = simplexml_load_string(html_entity_decode($XML));
   $Cfg = $Xml->Cfg[0];
   $Cols = $Xml->Cols->C;
   }
else { 
   $Xml = CreateXmlFromString(html_entity_decode($XML));
   $Cfg = $Xml->getElementsByTagName($Xml->documentElement,"Cfg"); $Cfg = $Cfg[0];
   $Cols = $Xml->getElementsByTagName($Xml->documentElement,"C");
   } 
$Cfg = $SXML ? $Cfg->attributes() : $Xml->attributes[$Cfg];
for($i=0;$i<4;$i++) $C[$i] = $SXML ? $Cols[$i]->attributes() : $Xml->attributes[$Cols[$i]];
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

// --- Parses Column position, visibility and width ---
$p = 0;
for($i=0;$i<4;$i++){
   if ($C[$i]["Visible"] != "0"){
      $N[$p] = $C[$i]["Name"];
      $W[$p] = $C[$i]["Width"];
      $p++;
      }
   }

// --- Reads data from database ---
$rows = $db->Query("SELECT * FROM TableData" . $S); $rows = $rows->GetRows();

// --- Writes Excel settings ---
echo "<html xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns=\"http://www.w3.org/TR/REC-html40\">";
echo "<head><meta http-equiv=Content-Type content=\"text/html; charset=utf-8\"></head><body>";
echo "<style>td {white-space:nowrap}</style>";
echo "<table border=1 bordercolor=silver style='table-layout:fixed;border-collapse:collapse;border:1px solid black'>";
   
// --- Writes columns' widths ---
for ($i=0;$i<$p;$i++) echo "<col width='" . $W[$i] . "'>";

// --- Writes captions ---
echo "\n<tr>";
for($i=0;$i<$p;$i++) echo "<td style='border-bottom:1px solid black;background:yellow;font-weight:bold;'>" . $N[$i] . "</td>";
echo "</tr>";

// --- Writes data ---
$cnt = count($rows);
for($r=0;$r<$cnt;$r++){
   $row = $rows[$r];
   echo "\n<tr>";
   for ($i=0;$i<$p;$i++) {
      $name = $N[$i] . "";
      if($name=="Resource" || $name=="Project") echo "<td>" . htmlspecialchars($row[$name],ENT_QUOTES) . "</td>"; // string
      else echo "<td x:num='" . $row[$name] . "'>" . $row[$name] . "</td>";  // number
      }
   echo "</tr>";
   }
// ---
echo "</table></body></html>";
// --------------------------------------------------------------------------
?>