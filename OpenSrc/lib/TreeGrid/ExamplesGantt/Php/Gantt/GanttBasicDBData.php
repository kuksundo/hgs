<?php
// ! Support file only, run GanttBasic.html instead !
// This file is used as Data_Url
// Generates data for TreeGrid from database
// Single file, without using TreeGridFramework.php

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

// --- response initialization ---
header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------
$rows = $db->Query("SELECT * FROM GanttBasic"); $rows = $rows->GetRows();
echo "<Grid><Body><B>";
foreach($rows as $row){
   echo "<I id='" . $row["id"] . "'" 
         . " T='" . htmlspecialchars($row["T"],ENT_QUOTES) . "'"
         . " S='" . $row["S"] . "'"
         . " E='" . $row["E"] . "'"
         . " C='" . $row["C"] . "'"
         . " D='" . $row["D"] . "'"
         . "/>\n";
   }
echo "</B></Body></Grid>";

// --------------------------------------------------------------------------
?>