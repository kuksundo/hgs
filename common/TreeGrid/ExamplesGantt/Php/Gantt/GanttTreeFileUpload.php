<?php

// --- response initialization ---
header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------
// --- Saves changes ---
$XML = array_key_exists("Data",$_REQUEST) ? $_REQUEST["Data"] : "";
if ($XML) { 
   if(get_magic_quotes_gpc()) $XML = stripslashes($XML);
   $F = fopen(dirname(__FILE__) . "/GanttTreeData.xml","w");
   fwrite($F,html_entity_decode($XML));
   echo "<Grid><IO Result='0'/></Grid>";
   }
// --------------------------------------------------------------------------
?>