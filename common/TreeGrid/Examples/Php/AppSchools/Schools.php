<?php
//------------------------------------------------------------------------------------------------------------------
// Main file for Schools example
// Used as Data_Url and Upload_Url in <treegrid>
// a) Generates XML data from database
// b) Updates changes sent in XML to database
// c) Verifies user and also adds new user to database
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
$User = array_key_exists("User",$_REQUEST) ? $_REQUEST["User"] : "";
$Pass = array_key_exists("Pass",$_REQUEST) ? $_REQUEST["Pass"] : "";
$New = array_key_exists("New",$_REQUEST) ? $_REQUEST["New"] : "";
$User = strtolower($User);
echo "<Grid>";

// --- Adding new user ---
if($New){
   $rs = $db->Query("SELECT Pass FROM Schools_Users WHERE Name='" . str_replace("'","''",$User) ."'");
   $rows = $rs->GetRows();
   if($rows==NULL){     // Ok, possible
      $db->Exec("INSERT INTO Schools_Users(Name,Pass) VALUES ('" . str_replace("'","''",$User) ."','" . str_replace("'","''",$Pass) . "')");      
      echo "<IO Message='User ". htmlspecialchars($User,ENT_QUOTES) ." has been added successfuly'/>";
      }
   else {
      echo '<IO Result="-1" Message="User name already exists !"/><Lang><Text StartErr="User name already exists !"/></Lang></Grid>';
      exit();
      }
   }

// --- Password verification ---
if($User!=""){
   $rs = $db->Query("SELECT Pass FROM Schools_Users WHERE Name='" . str_replace("'","''",$User) ."'");
   $rows = $rs->GetRows();
   if($rows==NULL || $rows[0]["Pass"]!=$Pass){
      echo '<IO Result="-1" Message="Wrong user name or password !"/><Lang><Text StartErr="Wrong user name or password !"/></Lang></Grid>';
      exit();
      }
   }
$Admin = $User=="admin"; // @@@ Or change this code to another admin

//------------------------------------------------------------------------------------------------------------------
// --- Write submited data ---
//try {
   $Changes = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
   if($Changes){
      if($User==""){ // Attack or bug
         echo "<IO Result='-1' Message='The user have not permission to save data !'/></Grid>";
         exit();
         }
      if(get_magic_quotes_gpc()) $Changes = stripslashes($Changes);
      
      // --- simple xml or php xml --- 
      $SXML = is_callable("simplexml_load_string");
      if(!$SXML) require_once("../Framework/Xml.php");
      if($SXML){ 
         $Xml = simplexml_load_string(html_entity_decode($Changes));
         $AI = $Xml->Changes->I;
         }
      else { 
         $Xml = CreateXmlFromString(html_entity_decode($Changes));
         $AI = $Xml->getElementsByTagName($Xml->documentElement,"I");
         }
      foreach($AI as $I){
         $A = $SXML ? $I->attributes() : $Xml->attributes[$I];
         // --- end of simple xml or php xml ---
                  
         $id = '' . $A["id"]; // Nutny soucet jinak to asi neni retezec ???
         $Owner = str_replace("'","''",strtok($id, '$'));
         $Def = strtok('$');
         $Ident = strtok('$');
         
         $id = " Owner='" . $Owner . "' AND Id=" . $Ident;

         if($Def!='Main'){  // Child row (Address, Phone, Link, Map)
            if($A["Added"] || $A["Changed"]){
               $db->Exec("UPDATE Schools_Schools SET " . $Def . " = '" . str_replace("'","''",$A["CCountry"]) . "' WHERE".$id);
               }
            }
         else if(!empty($A["Deleted"])){
            $db->Exec("DELETE FROM Schools_Schools WHERE".$id);
            $db->Exec("DELETE FROM Schools_Ratings WHERE".$id);
            }
         else if(!empty($A["Added"])){
            $Str = "'" . str_replace("'","''",$A["CUser"]) . "','" . $Ident . "','" . str_replace("'","''",$A["CName"]) . "',"
               . $A["CCountry"] . "," . $A["CState"] . "," . $A["CCounty"] . ","
               . "'" . str_replace("'","''",$A["CTown"]) . "',"
               . $A["CLevel"] . "," . $A["CType"] . ","
               . $A["CGrade1"] . "," . $A["CGrade2"] . "," . $A["CEnrollment"] . "," . $A["CStudents"];
            $db->Exec("INSERT INTO Schools_Schools(Owner,Id,Name,Country,State,County,Town,SLevel,Type,FromGrade,ToGrade,Enrollment,Students) VALUES (" . $Str . ")");
            }
         else if(!empty($A["Changed"])){
            $Str = "";      
            if($A["CName"]!=null) $Str .= "Name='" . str_replace("'","''",$A["CName"]) . "',";
            if($A["CCountry"]!=null) $Str .= "Country=" . $A["CCountry"] .",";
            if($A["CState"]!=null) $Str .= "State=" . $A["CState"] .",";
            if($A["CCounty"]!=null) $Str .= "County=" . $A["CCounty"] .",";
            if($A["CTown"]!=null) $Str .= "Town='" . str_replace("'","''",$A["CTown"]) . "',";
            if($A["CLevel"]!=null) $Str .= "SLevel=" . $A["CLevel"] .",";
            if($A["CType"]!=null) $Str .= "Type=" . $A["CType"] .",";
            if($A["CGrade1"]!=null) $Str .= "FromGrade=" . $A["CGrade1"] .",";
            if($A["CGrade2"]!=null) $Str .= "ToGrade=" . $A["CGrade2"] .",";
            if($A["CEnrollment"]!=null) $Str .= "Enrollment=" . $A["CEnrollment"] .",";
            if($A["CStudents"]!=null) $Str .= "Students=" . $A["CStudents"] .",";
            $Str2 = "";
            if($Admin && $A["CUser"]!=null) $Str2 .= "Owner='" . str_replace("'","''",$A["CUser"]) ."',";
            if($Admin && $A["Ident"]!=null) $Str2 .= "Id='" . $A["Ident"] ."',";
            $Str = $Str . $Str2;
            if(strlen($Str)){
               $db->Exec("UPDATE Schools_Schools SET " . substr($Str,0,strlen($Str)-1) . " WHERE " . $id);
               }
            if(strlen($Str2)){ // Updates changes in user/id in Ratings
               $db->Exec("UPDATE Schools_Ratings SET " . substr($Str2,0,strlen($Str2)-1) . " WHERE " . $id);
               }
            }
         }
      echo "<IO Result='0'/></Grid>";
      exit();
      }
   /*}
catch(Exception $E){
   echo "Error in saving data !<br>";
   echo $E;
   exit();
   } */

//------------------------------------------------------------------------------------------------------------------
// --- Read data ---
$Str = "";
if($User==""){
   $Str .= "<Cfg Adding='0' Deleting='0' Editing='0'/><Toolbar Save='0'/>";
   }
else {
   $Str .= "<Def><D Name='R' CUser='".htmlspecialchars($User,ENT_QUOTES)."'/></Def>";
   $Str .= "<Cols><C Name='CRating' Button='None'/></Cols>";
   }
if(!$Admin) {
   $Str .= "<RightCols><C Name='CUser' Visible='0' CanHide='0' CanPrint='0' CanExport='0'/></RightCols>";
   }  
$Str .= "<Body><B>";
$rs = $db->Query("SELECT * FROM Schools_Schools" . ($User!="" && !$Admin?" WHERE Owner='".str_replace("'","''",$User)."'":""));
$rows = $rs->GetRows();
if($rows!=NULL) {
   foreach($rows as $row){
      $id = " Ident='" . $row["Id"] . "' CUser='".htmlspecialchars($row["Owner"],ENT_QUOTES) ."'";     
      $Str .= "<I Def='Main' ".$id;
      $Str .= " CName='" . htmlspecialchars($row["Name"],ENT_QUOTES) . "'";
      $Str .= " CCountry='" . $row["Country"] . "'";
      $Str .= " CState='" . $row["State"] . "'";
      $Str .= " CCounty='" . $row["County"] . "'";
      $Str .= " CTown='" . htmlspecialchars($row["Town"],ENT_QUOTES) . "'";
      $Str .= " CLevel='" . $row["SLevel"] . "'";
      $Str .= " CType='" . $row["Type"] . "'";
      $Str .= " CGrade1='" . $row["FromGrade"] . "'";
      $Str .= " CGrade2='" . $row["ToGrade"] . "'";
      $Str .= " CEnrollment='" . $row["Enrollment"] . "'";
      $Str .= " CStudents='" . $row["Students"] . "'";
      $Str .= ">";
      $Str .= "<I Def='Address' " . $id. " CCountry='" . htmlspecialchars($row["Address"],ENT_QUOTES) . "'/>";
      $Str .= "<I Def='Phone' " . $id. " CCountry='" . htmlspecialchars($row["Phone"],ENT_QUOTES) . "'/>";
      $Str .= "<I Def='Link' " . $id. " CCountry='" . htmlspecialchars($row["Link"],ENT_QUOTES) . "'/>";
      $Str .= "<I Def='Map' " . $id. " CCountry='" . htmlspecialchars($row["Map"],ENT_QUOTES) . "'/>";
      $Str .= "<I Def='Reviews' " . $id. " Count='".$row["RatingCnt"]."'  CRatingsum='".$row["RatingSum"]."'>";
      $Str .= "</I>";
      $Str .= "</I>";
      }
   }
$Str .="</B></Body></Grid>";
echo $Str;
exit();
//------------------------------------------------------------------------------------------------------------------
?>