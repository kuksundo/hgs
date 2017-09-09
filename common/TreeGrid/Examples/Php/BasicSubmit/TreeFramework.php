<?php
// Example of TreeGrid using synchronous (submit, non AJAX) communication with server
// Example of tree table
// Uses PHP-TXT-DB database ../Database/TreeData.txt as data and XML file TreeDef.xml as TreeGrid layout
// Uses routines in TreeGridFramework.php to load and save data
// ! Check if PHP application has write access to Database folder 

define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/TreeGridFramework.php");  
header("Content-Type: text/html; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------
// Creates object to use functions from TreeGridFramework.php
$TreeGrid = new TreeGrid(
   dirname(__FILE__) . "/../Database",    // Database is folder with txt database files
   "TreeData",          //Table name in database
   "id",                //Column name in database table where are stored unique row ids
   "",                  //Prefix added in front of id, used if ids are number type
   "Parent",            //Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
   "Def"                //Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree
   );

// --------------------------------------------------------------------------
// Saves and loads data using functions in TreeGridFramework.asp
$XML = array_key_exists("TGData",$_REQUEST) ? $_REQUEST["TGData"] : "";
if ($XML) $TreeGrid->SaveXMLToDB($XML);                                      // Saves changes
$XML = htmlspecialchars($TreeGrid->LoadXMLFromDB(),ENT_COMPAT);             // Loads data

// --------------------------------------------------------------------------
?>
<html>
   <head>
      <script src="../../../Grid/GridE.js"> </script>
      <link href="../../../Styles/Examples.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <h2>Tree in database</h2>
      <div style="WIDTH:100%;HEIGHT:98%">
         <bdo 
            Layout_Url='TreeDef.xml' 
            Data_Tag='TGData' 
            Upload_Tag='TGData' Upload_Format='Internal'
            Export_Url="../Framework/Export.php" Export_Data="TGData" Export_Param_File="Tree.xls"
            ></bdo>
      </div>
      <form>
         <input id="TGData" name="TGData" type="hidden" value="<?php echo $XML?>">
         <input type="submit" value="Submit changes to server"/>
      </form>
   </body>
</html>