<?php
// Example of TreeGrid using synchronous (submit, non AJAX) communication with server
// Example of simple table
// Uses PHP-TXT-DB database ../Database/TableData.txt as data and XML file DBDef.xml as TreeGrid layout
// Single file, without using TreeGridFramework.php
// ! Check if PHP application has write access to ../Database folder 

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

// --- response initialization ---
header("Content-Type: text/html; charset=utf-8");
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------
// --- Saves changes ---
$XML = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
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
         $db->Exec("DELETE FROM TableData WHERE ID=".$A["id"]);
         }
      else if(!empty($A["Added"])){
         $db->Exec("INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES("
               . $A["id"] . "," 
               . "'" . str_replace("'","''",$A["Project"]) . "',"
               . "'" . str_replace("'","''",$A["Resource"]) . "',"
               . $A["Week"] . ","
               . $A["Hours"] .")");
         }
      else if(!empty($A["Changed"])){
         $S = "UPDATE TableData SET ";
         foreach($A as $name => $value){
            if($name=="Project" || $name=="Resource") $S .= "$name = '" . str_replace("'","''",$value) . "',";
            else if($name=="Week" || $name=="Hours") $S .= "$name = " . $value . ",";
            }
         $S = substr($S,0,strlen($S)-1);
         $S .= " WHERE ID=".$A["id"];
         $db->Exec($S);
         }
      }
   }
   
// --- Loads data ---
$rows = $db->Query("SELECT * FROM TableData"); $rows = $rows->GetRows();
$XML = "<Grid><Body><B>";
foreach($rows as $row){
   $XML .= "<I id='" . $row["ID"] . "'" 
         . " Project='" . htmlspecialchars($row["Project"],ENT_QUOTES) . "'"
         . " Resource='" . htmlspecialchars($row["Resource"],ENT_QUOTES) . "'"
         . " Week='" . $row["Week"] . "'"
         . " Hours='"  . $row["Hours"] . "'"
         . "/>";
   }
$XML .= "</B></Body></Grid>";
$XML = htmlspecialchars($XML,ENT_COMPAT);
// --------------------------------------------------------------------------
?>
<html>
   <head>
      <script src="../../../Grid/GridE.js"> </script>
      <link href="../../../Styles/Examples.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <h2>Basic Submit</h2>
      <div style="WIDTH:100%;HEIGHT:98%">
         <bdo 
            Layout_Url='DBDef.xml' 
            Data_Tag='TGData' 
            Upload_Tag='TGData' Upload_Format='Internal'
            Export_Url="../Framework/Export.php" Export_Data="TGData" Export_Param_File="Table.xls"
            ></bdo>
      </div>
      <form>
         <input id="TGData" name="TGData" type="hidden" value="<?php echo $XML?>">
         <input type="submit" value="Submit changes to server"/>
      </form>
   </body>
</html>