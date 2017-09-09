<?php
// ! Support file only, run AjaxGrid.html instead !
// This file is used as Layout_Url for TreeGrid
// It generates layout structure for TreeGrid from database
// Single file, without using TreeGridFramework.php
// --------------------------------------------------------------------------


// --- Database switching ---
define("API_HOME_DIR" ,"../php-txt-db-api/"); // Sets path to PHP TXT DB database script 
require_once("../Framework/IncDbTxt.php");    // Routines to connect to database via text file database
$db = new Database("../Database");            // Database in folder "Database"

//require_once("../Framework/IncDbOdbc.php"); // Routines to connect to database via ODBC
//$db = new Database("DRIVER={Microsoft Access Driver (*.mdb)}; DBQ=".dirname(__FILE__)."/../Database.mdb");  // MS Access database file name

header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --- Generating layout ---
$rs = $db->Query("SELECT MIN(Week),MAX(Week) FROM TableData WHERE Week>0 AND Week<53");
$min = floor($rs->Get(0));
$max = floor($rs->Get(1));
$Cols=""; $CSum=""; $DRes=""; $DDef="";

for($i=$min;$i<=$max;$i++){
   $Week = "W" . $i;
   $Cols = $Cols . "<C Name='" . $Week . "' Type='Float'/>";   // Column definitions
   if($CSum!="") $CSum .= "+";
   $CSum = $CSum . $Week;                               // Right fixed result column formula
   $DRes = $DRes . $Week . "Formula='sum()' ";          // Tree result row formulas
   $DDef = $DDef . $Week . "='0' ";                     // Default values for data rows
   }         
// --------------------------------------------------------------------------
?>
<Grid>
   <Cfg id='ResourceGrid' MainCol='Project' MaxHeight='1' ShowDeleted="0" DateStrings='1' 
      IdNames='Project' AppendId='1' FullId='1' IdChars='0123456789' NumberId='1' LastId='1' CaseSensitiveId='1'/>
   <LeftCols>
      <C Name='id' CanEdit='0'/>
      <C Name='Project' Width='250' Type='Text'/>
   </LeftCols>
   <Cols><?php echo $Cols;?>
   </Cols>
   <RightCols>
      <C Name='Sum' Width='50' Type='Float' Formula='<?php echo $CSum;?>' Format='0.##'/>
   </RightCols>
   <Def>
      <D Name='R' Project='New resource' CDef='' AcceptDef='' <?php echo $DDef;?>/>
      <D Name='Node' Project='New project' CDef='R' AcceptDef='R' Calculated='1' SumFormula='sum()' <?php echo $DRes;?> ProjectHtmlPrefix='&lt;B>' ProjectHtmlPostfix='&lt;/B>'/>
   </Def>
   <Root CDef='Node' AcceptDef='Node'/>
   <Header id='id (debug)' Project='Project / resource'/>
   <Foot>
      <I Kind='Space' RelHeight='100'/>
      <I Def='Node' Project='Total results' ProjectCanEdit='0'/>
   </Foot>
</Grid>