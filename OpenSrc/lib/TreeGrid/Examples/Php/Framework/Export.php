<?php 
$file = array_key_exists("File",$_REQUEST) ? $_REQUEST["File"] : ""; 
if($file=="") $file="Export.xls";
header("Content-Type: application/vnd.ms-excel; charset=utf-8");
header("Content-Disposition: attachment; filename=\"" . $file . "\"");
header("Cache-Control: max-age=1; must-revalidate");
$XML = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
if(get_magic_quotes_gpc()) $XML = stripslashes($XML);
echo html_entity_decode($XML);
?>