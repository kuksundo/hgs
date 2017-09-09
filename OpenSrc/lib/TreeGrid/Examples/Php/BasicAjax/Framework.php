<?php
// ! Support file only, run Framework.html instead !
// This file is used as both Data_Url and Upload_Url
// Generates data for TreeGrid when no data received or saves received changes to database
// Uses routines in TreeGridFramework.php to load and save data 

define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/TreeGridFramework.php");  
header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");
// --------------------------------------------------------------------------
// Creates object to use functions from TreeGridFramework.php
$TreeGrid = new TreeGrid(
   dirname(__FILE__) . "/../Database",    // Database is folder with txt database files
   "TableData",         //Table name in database
   "ID",                //Column name in database table where are stored unique row ids
   "",                  //Prefix added in front of id, used if ids are number type
   "",                  //Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
   ""                   //Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree
   );

// --------------------------------------------------------------------------
// Saves and loads data using functions in TreeGridFramework.asp
$XML = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
if ($XML){                                              // Saves changes
   $TreeGrid->SaveXMLToDB($XML);                        
   echo "<Grid><IO Result='0'/></Grid>";
   }
else echo $TreeGrid->LoadXMLFromDB();                          // Loads data
// --------------------------------------------------------------------------
?>