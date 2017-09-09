<?php
// -----------------------------------------------------------------------------
// Two objects to access database via ODBC
// Works under any system (Windows, Linux, ...)
// You must create ODBC data source to the database first to use its name as parameter in Database constructor  
// -----------------------------------------------------------------------------
// Recordset created by Database::Execute SQL SELECT command
// Used to read-only access to returned table
class Recordset {
var $rs;
var $ColumnNames;
var $ColumnIndexes;
var $ColCount;
var $RowCount;
var $ARow;

function Recordset($Param) {
  $this->__construct($Param);
  register_shutdown_function(array($this,"__destruct"));
  }

function __construct($Param){  // Do not call constructor directly 
   $this->rs = $Param;
   $this->RowCount = odbc_num_rows ($this->rs);
   $this->ColCount = odbc_num_fields($this->rs);
   for($i=1;$i<=$this->ColCount;$i++){
      $name = odbc_field_name($this->rs,$i);
      $this->ColumnNames[$i] = $name;
      $this->ColumnIndexes[$name] = $i;
      }
   if($this->RowCount>0){ 
      odbc_fetch_row($this->rs,1);
      $this->ARow = 1;
      }
   else $this->ARow = 0; 
   } 
function __destruct(){ }

function GetRowCount(){ return $this->RowCount; } // Returns number of records, can return -1 if cannot be determined
function GetColCount(){ return $this->ColCount; } // Returns number columns
function Next(){   // Moves to next record, returns true on success, false on EOF 
   if(!odbc_fetch_row($this->rs)) return false;
   $this->ARow++; return true; 
   } 
function Prev(){ // Moves to previous record, returns true on success, false on BOF
   if($this->ARow<=1) return false;
   if(!odbc_fetch_row($this->rs,$this->ARow-1)) return false;
   $this->ARow--; return true;
   }     
function Last(){ // Moves to last record, returns true on success, false on EOF
   if(!odbc_fetch_row($this->rs,$this->RowCount)) return false;
   $this->ARow = $this->RowCount; return true;
   } 
function First(){  // Moves to first record, returns true on success, false on BOF
   if(!odbc_fetch_row($this->rs,1)) return false;
   $this->ARow = 1; return true; 
   }
  
// Returns value of the column value in actual row, column can be column name or index
// If column does not exist, returns NULL
function Get($Column){
   return odbc_result($this->rs,$Column); 
   }
  
// Returns array of actual row's values 
function GetRow(){
   foreach($this->ColumnNames as $idx => $name) $arr[$name] = odbc_result($this->rs,$idx);
   return $arr;
   }
   
// return array of rows
function GetRows(){
   if(!$this->First()) return NULL;
   $k = 0;
   do {
      $arr[$k++] = $this->GetRow();   
      } while($this->Next());
   return $arr;
   }

// Returns all rows in one array, uses only indexes, first row are column names, second is NULL (will be types)
function GetTable(){
   $vals = $this->GetRows();
   array_unshift($vals,$this->ColumnNames,NULL);
   return $vals;     
   }
}

 
// -----------------------------------------------------------------------------
// Main object to connect to database
// Accepts database file name as constructor parameter
class Database {
var $conn;

function Database($ConnectionString) {
  $this->__construct($ConnectionString);
  register_shutdown_function(array($this,"__destruct"));
  }

function __construct($Name,$User="",$Password=""){
   $this->conn = odbc_connect($Name,$User,$Password);
   //if(!$this->conn) throw new Exception("Cannot open ODBC database $Name");
   }
function __destruct(){
   odbc_close($this->conn);
   }

// Executes any SQL command other then SELECT
// Returns number of rows affected
function Exec($Command){
   return odbc_exec($this->conn,$Command); 
   }

// Executes SELECT command and returns opened recordset or NULL for other commands
function Query($Command){
   $rs = odbc_exec($this->conn,$Command);
   if(!$rs) return NULL;
   return new Recordset($rs);
   }

// Inserts row to the table, table $name must exist and have appropriate column structure
// row contains named values for column's in one row
// Returns empty string or error message
/*public function InsertRow($name,$row){
   $Cols = "INSERT INTO $name(";
   $Vals = ") VALUES (";
   foreach($row as $col => $val ){
      $Cols .= "[$col],";
      $Vals .= "'" . str_replace("'","''",$val) . "',";
      }
   $Cols = substr($Cols,0,strlen($Cols)-1);
   $Vals = substr($Vals,0,strlen($Vals)-1);
   $Error = "";
   if(!sqlite_exec ($this->conn, $Cols . $Vals . ")",$Error)) return $Error;
   return "";
   }
// Inserts more rows to table
public function InsertRows($name,$rows){
   foreach($rows as $row) $this->InsertRow($name,$row);
   }*/
}
// -----------------------------------------------------------------------------