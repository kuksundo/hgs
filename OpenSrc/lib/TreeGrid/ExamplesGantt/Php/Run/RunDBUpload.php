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
$XML = array_key_exists("Data",$_REQUEST) ? $_REQUEST["Data"] : "";
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
         $db->Exec("DELETE FROM Run WHERE id=".$A["id"]);
         }
      else if(!empty($A["Added"])){
         $db->Exec("INSERT INTO Run(id,T,S,R) VALUES("
               . $A["id"] . "," 
               . "'" . str_replace("'","''",$A["T"]) . "',"
               . "'" . $A["S"] . "',"
               . "'" . str_replace("'","''",$A["T"]) . "')");
         }
      else if(!empty($A["Changed"])){
         $S = "UPDATE Run SET ";
         foreach($A as $name => $value){
            if($name=="T" || $name=="R") $S .= "$name = '" . str_replace("'","''",$value) . "',";
            else if($name=="S") $S .= "$name = '$value',";
            }
         $S = substr($S,0,strlen($S)-1);
         $S .= " WHERE id=".$A["id"];
         $db->Exec($S);
         }
      }
   echo "<Grid><IO Result='0'/></Grid>";
   }
// --------------------------------------------------------------------------
?>