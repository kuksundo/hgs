<?php
// ! Support file only, run SortingExport.html instead !
// This file is used as Data_Url
// Generates data for TreeGrid body - page count
// This is simple example, it simply reloads all body when rows are added or deleted instead of handling changes in pages
// Single file, without using TreeGridFramework.php

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------
$rs = $db->Query("SELECT COUNT(*),MAX(ID) FROM TableData");
$cnt = $rs->Get(0);
echo "<Grid><Cfg LastId='" . $rs->Get(1) . "' RootCount='" . $cnt . "'/><Body>";
$cnt = floor(($cnt+20) / 21);
for($i=0;$i<$cnt;$i++) echo("<B/>");
echo "</Body></Grid>";
// --------------------------------------------------------------------------
?>