<?php
// ! Support file only, run AjaxGrid.html instead !
// This file is used as Upload_Url for TreeGrid
// It stores changed from TreeGrid to database
// --------------------------------------------------------------------------

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

//require_once("../Framework/IncDbOdbc.php"); // Routines to connect to database via ODBC
//$db = new Database("DRIVER={Microsoft Access Driver (*.mdb)}; DBQ=".dirname(__FILE__)."/../Database.mdb");  // MS Access database file name

header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------
// --- Saves changes ---
$XML = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
if ($XML) { 
   if(get_magic_quotes_gpc()) $XML = stripslashes($XML);
   $LastCount = 0;
      
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
      
      $id = $A["id"];
      $prj = strtok($id,"\$");
      $res = strtok("\$");
      
      // --- Project row ---
      if(!$res){
         $prj = "'" . str_replace("'","''",$prj) . "'";
         $where = " WHERE Project=" . $prj . " ";
         if(!empty($A["Deleted"])){
            $db->Exec("DELETE FROM TableData" . $where);
            }
         else if(!empty($A["Added"]) || !empty($A["Changed"])){
            $res = $A["Project"];                  // Changed resource name
            if($res!=NULL) {
               $res = "'" . str_replace("'","''",$res) . "'";
               $Last[$LastCount++] = "UPDATE TableData SET Project=" . $res . $where;
               }
            }
         }
      
      // --- Resource row ---
      else {
         $prj = "'" . str_replace("'","''",$prj) . "'";
         $res = "'" . str_replace("'","''",$res) . "'";
         $where = " WHERE Project=" . $prj . " AND Resource=" . $res . " ";
         if(!empty($A["Deleted"])){
            $db->Exec("DELETE FROM TableData" . $where);
            }
         else if(!empty($A["Added"]) || !empty($A["Changed"])){
            foreach($A as $name => $value){
               if($name[0]=="W"){                      // Hours number
                  $week = substr($name,1);
                  $rs = $db->Query("SELECT ID FROM TableData" . $where . " AND Week=" . $week);
                  if(!$rs->GetRowCount()){        // New item
                     $rs = $db->Query("SELECT MAX(ID) FROM TableData");          //Creates new id, but better is to define Id in database as incremental
                     $db->Exec("INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES (" . ($rs->Get(0)+1) . "," . $prj . "," . $res . "," . $week . "," . $value . ")");
                     }     
                  else {                        // Existing item
                     $db->Exec("UPDATE TableData SET Hours=" . $value . $where . " AND Week=" . $week);
                     }
                  }
               }               
            $res = $A["Project"];                         // Changed resource name
            if($res!=NULL) {
               $res = "'" . str_replace(",","''",$res) . "'";
               $db->Exec("UPDATE TableData SET Resource=" . $res . $where);
               }
            }
         else if(!empty($A["Moved"]) && $A["Moved"]==2){
            $db->Exec ("UPDATE TableData SET Project='" . str_replace("'","''",$A["Parent"]) . "'" . $where);
            }
         }         
      }
   // --- Delayed changing project names ---'
   // It must be done after changing all resources for the project
   for($i=0;$i<$LastCount;$i++) $db->Exec($Last[$i]);
   }
echo "<Grid><IO Result='0'/></Grid>";

// --------------------------------------------------------------------------
?>