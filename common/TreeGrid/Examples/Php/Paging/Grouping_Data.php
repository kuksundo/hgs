<?php
//! Support file only, run Grouping.html instead !
// This file is used as Data_Url
// Generates data for TreeGrid body
// This is simple example, always reads and groups all rows to get their count
// Single file, without using TreeGridFramework.aspx
// -------------------------------------------------------------------------------------------------------------------------------

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

//require_once("../Framework/IncDbOdbc.php"); // Routines to connect to database via ODBC
//$db = new Database("DRIVER={Microsoft Access Driver (*.mdb)}; DBQ=".dirname(__FILE__)."/../Database.mdb");  // MS Access database file name

header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------
// --- Gets cfg ---
$XML = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
if(get_magic_quotes_gpc()) $XML = stripslashes($XML);
if(!$XML) $XML = "<Grid><Cfg GroupCols='Resource'/></Grid>";   // Just for examples if called directly

// --- simple xml or php xml --- 
$SXML = is_callable("simplexml_load_string");
if(!$SXML) require_once("../Framework/Xml.php"); 
if($SXML){ 
   $Xml = simplexml_load_string(html_entity_decode($XML));
   $Cfg = $Xml->Cfg[0];
   }
else { 
   $Xml = CreateXmlFromString(html_entity_decode($XML));
   $Cfg = $Xml->getElementsByTagName($Xml->documentElement,"Cfg"); $Cfg = $Cfg[0];
   } 
$Cfg = $SXML ? $Cfg->attributes() : $Xml->attributes[$Cfg];
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
   
// --- Generating data for body ---
if($GC[0] == ""){ 
  $rs = $db->Query("SELECT COUNT(*) FROM TableData");
  $cnt = $rs->Get(0);
  }
else {
  $rs = $db->Query("SELECT COUNT(*) FROM TableData GROUP BY " . $GC[0]);
  $cnt = $rs->GetRowCount();
  }
echo "<Grid><Cfg RootCount='" . $cnt . "'/><Body>";
$cnt = floor(($cnt+20) / 21);
for($i=0;$i<$cnt;$i++) echo("<B/>");
echo "</Body></Grid>";
// --------------------------------------------------------------------------
?>