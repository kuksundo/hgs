<?php
//------------------------------------------------------------------------------------------------------------------
// Helper file for Schools example
// Generates XML data for Ratings
// Used as Page_Url for Server ChildPaging in <treegrid>
//------------------------------------------------------------------------------------------------------------------

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

//require_once("../Framework/IncDbOdbc.php"); // Routines to connect to database via ODBC
//$db = new Database("DRIVER={Microsoft Access Driver (*.mdb)}; DBQ=".dirname(__FILE__)."/../Database.mdb");  // MS Access database file name


// --- Initialization ---
header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --- Returns ratings for the row as server child page ---
$Request = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
if(get_magic_quotes_gpc()) $Request = stripslashes($Request);
if(!$Request) $Request = "<Grid><Body><B id='jan\$Main\$1'/></Body></Grid>";  // Just for examples if called directly

// --- simple xml or php xml ---
$SXML = is_callable("simplexml_load_string");
if(!$SXML) require_once("../Framework/Xml.php");
if($SXML){ 
   $Xml = simplexml_load_string(html_entity_decode($Request));
   $Nodes = $Xml->Body->B;
   }
else { 
   $Xml = CreateXmlFromString(html_entity_decode($Request));
   $Nodes = $Xml->getElementsByTagName(null,"B");
   }
echo "<Grid><Body>";
$Pos = 1;
if($Nodes) foreach($Nodes as $B){
   $A = $SXML ? $B->attributes() : $Xml->attributes[$B];
   // --- end of simple xml or php xml ---
   $id = '' . $A["id"]; // Nutny soucet jinak to asi neni retezec ???   
   echo "<B id='".$id."'>";  
    
   $User = strtok($id, '$');
   $Def = strtok('$');
   $Ident = strtok('$');
     
   $rs = $db->Query("SELECT * FROM Schools_Ratings WHERE Owner='".str_replace("'","''",$User)."' AND Id=".$Ident);
   $rows = $rs->GetRows();
   if($rows!=NULL) {
      foreach($rows as $row){
         echo "<I Def='Review' CName='".$row["ADate"]."' CCountry='".htmlspecialchars($row["Review"],ENT_QUOTES)."' Ident='".$A["id"]."_".($Pos++)."' CRating='".$row["Stars"]."'/>";
         }
      }
   echo "</B>";
   }
echo "</Body></Grid>";
//------------------------------------------------------------------------------------------------------------------     
?>
