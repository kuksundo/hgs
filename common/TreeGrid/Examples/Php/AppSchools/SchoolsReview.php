<?php      
//------------------------------------------------------------------------------------------------------------------
// Helper file for Schools example
// Saves visitor review to database
// Used as url for custom AJAX call 
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
$id = array_key_exists("id",$_REQUEST) ? $_REQUEST["id"] : "";
$Text = array_key_exists("Text",$_REQUEST) ? $_REQUEST["Text"] : "";
$Stars = array_key_exists("Stars",$_REQUEST) ? $_REQUEST["Stars"] : "";

if(get_magic_quotes_gpc()) {
   $Text = stripslashes($Text);
   $id = stripslashes($id);
   }

$User = str_replace("'","''",strtok($id, '$'));
$Def = strtok('$');
$Ident = strtok('$');

if($User<>""){ 
   $db->Exec("INSERT INTO Schools_Ratings(Owner,Id,Stars,Review,ADate) VALUES ('".$User."',".$Ident.",".$Stars.",'".str_replace("'","''",$Text)."','".date("m/d/Y")."')");
   $rows = $db->Query("SELECT RatingSum,RatingCnt FROM Schools_Schools WHERE Owner='".$User."' AND Id=".$Ident); $rows = $rows->GetRows();
   if($rows!=NULL) $db->Exec("UPDATE Schools_Schools SET RatingSum=".($rows[0]["RatingSum"] + $Stars) .", RatingCnt=".($rows[0]["RatingCnt"]+1)." WHERE Owner='".$User."' AND Id=".$Ident);
   }
echo "<Grid><IO Result='0' Message='Your review was successfully added'/></Grid>";
//------------------------------------------------------------------------------------------------------------------     
?>
