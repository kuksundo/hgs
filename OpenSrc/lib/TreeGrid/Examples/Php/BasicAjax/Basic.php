<?php
// ! Support file only, run Basic.html instead !
// This file is used as both Data_Url and Upload_Url
// Generates data for TreeGrid when no data received or saves received changes to database
// Single file, without using TreeGridFramework.php

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

// --- response initialization ---
header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------
// --- Saves changes ---
$XML = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
if ($XML) { 
   if(get_magic_quotes_gpc()) $XML = stripslashes($XML);
      
   // --- simple xml or php xml --- 
   $SXML = is_callable("simplexml_load_string");
   if(!$SXML) require_once("../Framework/Xml.php");
   if($SXML){ 
      $Xml = simplexml_load_string(html_entity_decode($XML));
      $AI = $Xml->Changes->I;
      }
   else { 
      $Xml = CreateXmlFromString(html_entity_decode($XML));
      $AI = $Xml->getElementsByTagName($Xml->documentElement,"I");
      }
   foreach($AI as $I){
      $A = $SXML ? $I->attributes() : $Xml->attributes[$I];
      // --- end of simple xml or php xml --- 

      if(!empty($A["Deleted"])){
         $db->Exec("DELETE FROM TableData WHERE ID=".$A["id"]);
         }
      else if(!empty($A["Added"])){
         $db->Exec("INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES("
               . $A["id"] . "," 
               . "'" . str_replace("'","''",$A["Project"]) . "',"
               . "'" . str_replace("'","''",$A["Resource"]) . "',"
               . $A["Week"] . ","
               . $A["Hours"] .")");
         }
      else if(!empty($A["Changed"])){
         $S = "UPDATE TableData SET ";
         foreach($A as $name => $value){
            if($name=="Project" || $name=="Resource") $S .= "$name = '" . str_replace("'","''",$value) . "',";
            else if($name=="Week" || $name=="Hours") $S .= "$name = " . $value . ",";
            }
         $S = substr($S,0,strlen($S)-1);
         $S .= " WHERE ID=".$A["id"];
         $db->Exec($S);
         }
      }
   echo "<Grid><IO Result='0'/></Grid>";
   }

// --- Loads data ---   
else {   
   $rows = $db->Query("SELECT * FROM TableData"); $rows = $rows->GetRows();
   echo "<Grid><Body><B>";
   foreach($rows as $row){
      $H = $row["Hours"]; if($H==floor($H)) $H = floor($H);  // !!! TreeGrid cannot accept float value ending with .0, like 40.0
      echo "<I id='" . $row["ID"] . "'" 
            . " Project='" . htmlspecialchars($row["Project"],ENT_QUOTES) . "'"
            . " Resource='" . htmlspecialchars($row["Resource"],ENT_QUOTES) . "'"
            . " Week='" . floor($row["Week"]) . "'"
            . " Hours='"  . $H . "'"
            . "/>\n";
      }
   echo "</B></Body></Grid>";
   }
// --------------------------------------------------------------------------
?>