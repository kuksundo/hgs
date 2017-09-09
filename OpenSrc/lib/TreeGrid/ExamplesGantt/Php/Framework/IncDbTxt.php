<?php
// -----------------------------------------------------------------------------
// Two objects to access database via txt-db-api
// Works under any system (Windows, Linux, ...) and PHP
// Uses text files in /Data dir
// To use files from another location, you must change paths in txt-db-api/txt-db-api.php file !
// -----------------------------------------------------------------------------
require_once("../php-txt-db-api/txt-db-api.php");
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
   $this->RowCount = $this->rs->getRowCount();
   $this->ColCount = $this->rs->getRowSize();
   $this->ColumnNames = $this->rs->getColumnNames();
   foreach($this->ColumnNames as $i => $name) $this->ColumnIndexes[$name] = $i;
   if($this->RowCount>0){ 
      $this->rs->next();
      $this->ARow = 1;
      }
   else $this->ARow = 0; 
   } 
function __destruct(){ }

function GetRowCount(){ return $this->RowCount; } // Returns number of records, can return -1 if cannot be determined
function GetColCount(){ return $this->ColCount; } // Returns number columns
function Next(){   // Moves to next record, returns true on success, false on EOF 
   if(!$this->rs->next()) return false;
   $this->ARow++; return true; 
   } 
function Prev(){ // Moves to previous record, returns true on success, false on BOF
   if($this->ARow<=1) return false;
   if(!$this->rs->prev()) return false;
   $this->ARow--; return true;
   }     
function Last(){ // Moves to last record, returns true on success, false on EOF
   if(!$this->RowCount) return NULL;
   $this->rs->setPos($this->RowCount-1);
   $this->ARow = $this->RowCount; return true;
   } 
function First(){  // Moves to first record, returns true on success, false on BOF
   if(!$this->RowCount) return NULL;
   $this->rs->setPos(0);
   $this->ARow = 1; return true; 
   }
  
// Returns value of the column value in actual row, column can be column name or index
// If column does not exist, returns NULL
function Get($Column){
   if(is_int($Column)) $val = $this->rs->getCurrentValueByNr($Column);
   else return $val = $this->rs->getCurrentValueByName($Column);
   if(strtolower($val)=="null") return null;
   return $val;
   }
  
// Returns array of actual row's values 
function GetRow(){
   $A = $this->rs->getCurrentValues();
   foreach($this->ColumnNames as $idx => $name) $arr[$name] = strtolower($A[$idx])=="null" ? null : $A[$idx];
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
   $this->conn = new TxtDatabase($Name);
   //if(!$this->conn) throw new Exception("Cannot open ODBC database $Name");
   }
function __destruct(){
   //odbc_close($this->conn);
   }

// Executes any SQL command other then SELECT
// Returns number of rows affected
function Exec($Command){
   return $this->conn->executeQuery($Command); 
   }

// Executes SELECT command and returns opened recordset or NULL for other commands
function Query($Command){
   $rs = $this->conn->executeQuery($Command);
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