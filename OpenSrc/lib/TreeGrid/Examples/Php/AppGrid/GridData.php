<?php
//! Support file only, run AjaxGrid.html instead !
// This file is used as Data_Url for TreeGrid
// It generates source data for TreeGrid from database
// --------------------------------------------------------------------------

// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

//require_once("../Framework/IncDbOdbc.php"); // Routines to connect to database via ODBC
//$db = new Database("DRIVER={Microsoft Access Driver (*.mdb)}; DBQ=".dirname(__FILE__)."/../Database.mdb");  // MS Access database file name

header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --- Generating data ---
$rows = $db->Query("SELECT * FROM TableData WHERE Week>0 AND Week<53 ORDER BY Project,Resource"); $rows = $rows->GetRows();
$Prj = null; $Res = null; $S = "";
foreach($rows as $row){
   $P = $row["Project"]; 
   $R = $row["Resource"];
   
   if($P != $Prj){               // New project row
      if($Prj !== null) $S .= "/></I>"; // Ends previous project and resource rows
      $Prj = $P; $Res = null;
      $S .= "<I Def='Node' Project='" . htmlspecialchars($Prj,ENT_QUOTES) . "'>";
      }
   if($R != $Res){              // New resource row
      if($Res !== null) $S .= "/>";     // Ends previous resource row
      $Res = $R;
      $S .= "<I Project='" . htmlspecialchars($Res,ENT_QUOTES) . "' ";
      }
   $H = $row["Hours"]; if($H==floor($H)) $H = floor($H);  // !!! TreeGrid cannot accept float value ending with .0, like 40.0
   $S .= "W" . floor($row["Week"]) . "='" . $H . "' ";      //Week = Hours (like W42='17')
   }
if($Prj !== null) $S .= "/></I>"   // Ends previous project and resource rows
// --------------------------------------------------------------------------
?>
<Grid>
   <Body>
      <B>
         <?php echo $S;?>
      </B>
   </Body>
</Grid>