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
$rows = $db->Query("SELECT * FROM GanttTree"); $rows = $rows->GetRows();
echo "<Grid><Body><B>";
if($rows) foreach($rows as $row){
   echo "<I id='" . $row["id"] . "'" 
         . " T='" . htmlspecialchars($row["T"],ENT_QUOTES) . "'"
         . " S='" . $row["S"] . "'"
         . " E='" . $row["E"] . "'"
         . " C='" . $row["C"] . "'"
         . " D='" . $row["D"] . "'"
         . " L='" . $row["L"] . "'"
         . "/>\n";
   }
echo "</B></Body></Grid>";

// --------------------------------------------------------------------------
?>