<?php
// -------------------------------------------------------------------------------------------
// TreeGrid Framework for accessing database
// It contains two basic functions:
//    String LoadXMLFromDB()  Returns data in XML, from database for TreeGrid 
//    SaveXMLToDB(String XML) Saves changes in XML from TreeGrid to database
// TreeGrid can be created by 
//    new TreeGrid(ConnectionString, DBTable, DBIdCol, IdPrefix, DBParentCol, DBDefCol)
//       ConnectionString = "" // Required - Connection string for accessing database, that can be used global variable Path as path to actual script
//       DBTable = ""          // Required - Table name in database
//       DBIdCol = "ID"        // Column name in database table where are stored unique row ids
//       IdPrefix = ""         // Prefix added in front of id, used if ids are number type, the same prefix must be in Layout <Cfg IdPrefix=''/>
//       DBParentCol = ""      // Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
//       DBDefCol = ""         // Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree)

// -------------------------------------------------------------------------------------------

// --- Database switching ---
require_once("IncDbTxt.php");                 // Routines to connect to database via text file database

class TreeGrid {
var $DBTable,$DBIdCol,$IdPrefix,$DBParentCol,$DBDefCol,$db;

function TreeGrid($connectionString, $dbTable, $dbIdCol,$idPrefix,$dbParentCol,$dbDefCol) {
  $this->__construct($connectionString, $dbTable, $dbIdCol,$idPrefix,$dbParentCol,$dbDefCol);
  register_shutdown_function(array($this,"__destruct"));
  }

function __construct($ConnectionString, $DBTable, $DBIdCol,$IdPrefix,$DBParentCol,$DBDefCol){
   $this->db = new Database($ConnectionString);
   $this->DBTable = $DBTable;
   $this->DBIdCol = $DBIdCol ? $DBIdCol : "id";
   $this->IdPrefix = $IdPrefix ? $IdPrefix : "";
   $this->DBParentCol = $DBParentCol;
   $this->DBDefCol = $DBDefCol;
   } 
function __destruct(){ }

// -------------------------------------------------------------------------------------------
// Helper function for LoadXMLFromDB to read data from database table and convert them to TreeGrid XML
// Returns XML string width all children with Parent
// If Parent is null returns all rows (for non tree tables)
function GetChildrenXML($Parent){
$Parent = $Parent ? " WHERE " . $this->DBParentCol . "='" .$Parent . "'" : "";
$rs = $this->db->Query("SELECT * FROM " . $this->DBTable . $Parent);
$rows = $rs->GetRows();
$Str = "";
if($rows==NULL) return "";
foreach($rows as $row){
   $Str .= "<I";
   foreach($row as $col => $val){
      if($val!=NULL){
         if($val==floor($val)."") $val = floor($val);  // !!! TreeGrid cannot accept float value ending with .0, like 40.0
         if($col==$this->DBIdCol) $Str .= " id='" . $this->IdPrefix . $val . "' ";
         else if($col!=$this->DBParentCol) $Str .= " $col='". htmlspecialchars($val,ENT_QUOTES). "'";
         }
      }
   echo "\n";
   $Str .= ">";
   if ($Parent!="") $Str .= $this->GetChildrenXML($row[$this->DBIdCol]);
   $Str .= "</I>\n";
   }
return $Str;
}

// -------------------------------------------------------------------------------------------
// Loads data from database table and returns them as XML string
function LoadXMLFromDB(){
$XML = "<Grid>";
if($this->DBParentCol != ""){
   $XML .= "<Head>" . $this->GetChildrenXML("#Head") . "</Head>";
   $XML .= "<Foot>" . $this->GetChildrenXML("#Foot") . "</Foot>";
   $XML .= "<Body><B>" . $this->GetChildrenXML("#Body") . "</B></Body>";
   }
else $XML .= "<Body><B>" . $this->GetChildrenXML(NULL) . "</B></Body>";
return $XML . "</Grid>";
}

// -------------------------------------------------------------------------------------------
function SaveXMLToDB($XML) {
if(get_magic_quotes_gpc()) $XML = stripslashes($XML);

// --- simple xml or php xml --- 
$SXML = is_callable("simplexml_load_string");
if(!$SXML) require_once("Xml.php");
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
      $this->db->Exec("DELETE FROM " . $this->DBTable . " WHERE " . $this->DBIdCol . "='".$A["id"]."'");
      }
   else if(!empty($A["Added"])){
      $Cols = "INSERT INTO " . $this->DBTable . "(";
      $Vals = ") VALUES (";
      foreach($A as $name => $value){
         if($name!="Added" && $name!="Changed" && $name!="Moved" && $name!="Next" && $name!="Prev" && $name!="Parent"){
            if($name=="id"){ $name = $this->DBIdCol; $val = $A["id"]; }
            if($name=="Def") $name = $this->DBDefCol;
            if($name!=""){
               $Cols .= "$name,";
               $Vals .= "'" . str_replace("'","''",$value) . "',";
               }
            }
         }
      if($this->DBParentCol!=""){
         $Cols .= $this->DBParentCol;
         $Vals .= "'" . ($A["Parent"]!="" ? $A["Parent"] : "#Body") . "'";
         }
      else {
         $Cols = substr($Cols,0,strlen($Cols)-1);
         $Vals = substr($Vals,0,strlen($Vals)-1);
         }
      $this->db->Exec($Cols . $Vals . ")");
      }
   else if(!empty($A["Changed"]) || !empty($A["Moved"])){
      $S = "UPDATE " . $this->DBTable . " SET ";
      foreach($A as $name => $value){
         if($name!="Added" && $name!="Changed" && $name!="Moved" && $name!="Next" && $name!="Prev" && $name!="id") {
            if($name=="Parent"){
               if($this->DBParentCol!="") $S .= $this->DBParentCol." = '".str_replace("'","''",$value)."',";
               }
            else $S .= "$name = '".str_replace("'","''",$value)."',";
            }
         }
      $S = substr($S,0,strlen($S)-1);
      $S .= " WHERE " . $this->DBIdCol . "='".$A["id"]."'";
      $this->db->Exec($S);
      }
   }
}
// -------------------------------------------------------------------------------------------
}
?>