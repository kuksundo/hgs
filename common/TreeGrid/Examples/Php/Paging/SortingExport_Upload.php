<?php
// ! Support file only, run SortingExport.html instead !
// This file is used as both Data_Url and Upload_Url
// Generates data for TreeGrid when no data received or saves received changes to database
// This is simple example, it simply reloads all body when rows are added or deleted instead of handling changes in pages
// Single file, without using TreeGridFramework.php

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

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
         $db->Exec("DELETE FROM TableData WHERE ID='".$A["id"]."'");
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
         $S .= " WHERE ID='".$A["id"]."'";
         $db->Exec($S);
         }
      }
   }
echo "<Grid><IO Result='0'/></Grid>";  
// --------------------------------------------------------------------------
?>