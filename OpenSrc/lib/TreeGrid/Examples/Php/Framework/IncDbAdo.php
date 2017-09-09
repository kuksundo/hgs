<?php
// -----------------------------------------------------------------------------
// Two objects to access database via Microsoft ADO.
// Works under Windows only. The ADO (MDAC) must be installed (on Windows XP is by default)
// -----------------------------------------------------------------------------
// Recordset created by Database::Execute SQL SELECT command
// Used to read-only access to returned table 
class Recordset {
var $rs;
function Recordset($Param) {
  $this->__construct($Param);
  register_shutdown_function(array($this,"__destruct"));
 }

function __construct($Param){ $this->rs = $Param; } // Do not call constructor directly
function __destruct(){ if($this->rs && $this->rs->State>0) $this->rs->Close(); }

function GetRowCount(){ return $this->rs->EOF && $this->rs->BOF ? 0 : $this->rs->RecordCount; } // Returns number of records, can return -1 if cannot be determined
function GetColCount(){ return $this->rs->Fields->Count; } // Returns number columns
function Next(){ $this->rs->MoveNext(); return !$this->rs->EOF; }     // Moves to next record, returns true on success, false on EOF
function Prev(){ $this->rs->MovePrevious(); return !$this->rs->BOF; } // Moves to previous record, returns true on success, false on BOF
function Last(){ $this->rs->MoveLast(); return !$this->rs->EOF; }     // Moves to last record, returns true on success, false on EOF
function First(){$this->rs->MoveFirst(); return !$this->rs->BOF; }    // Moves to first record, returns true on success, false on BOF
  
// Returns value of the column value in actual row, column can be column name or index
// If column does not exist, returns NULL
function Get($Column){
   // try / catch
   return $this->rs->Fields[$Column]->Value;
   }
  
// Returns array of actual row's values 
function GetRow(){
   $cnt = $this->rs->Fields->Count;
   for($i=0;$i<$cnt;$i++){
      $f = $this->rs->Fields[$i];
      $arr[$f->Name] = $f->Value;
      }
   return $arr;
   }
   
// return array of rows
function GetRows(){
   if($this->rs->EOF && $this->rs->BOF) return NULL;
   $this->rs->MoveFirst();
   for($k = 0;!$this->rs->EOF;$k++){ 
      $arr[$k] = $this->GetRow();
      $this->rs->MoveNext();
      }
   return $arr;
   }

// Returns all rows in one array, uses only indexes, first row are column names, second is NULL (will be types)
function GetTable(){
   $cnt = $this->rs->Fields->Count;
  
   for($i=0;$i<$cnt;$i++) $arr[0][i] = $this->rs->Fields[$i]->Name;
   if($this->rs->EOF && $this->rs->BOF) return $arr;
   $this->rs->MoveFirst();
   $k = 2;
   do {
      for($i=0;$i<$cnt;$i++) $arr[k][i] = $this->rs->Fields[$i]->Value;
      $this->rs->MoveNext();
      $k++;
      } while(!$this->rs->EOF);
   return $arr; 
   }

}

// -----------------------------------------------------------------------------
// Main object to connect to database
// Accepts connection string as constructor parameter, connection specifies all connection's parameters
class Database {
var $conn;

function Database($ConnectionString) {
  $this->__construct($ConnectionString);
  register_shutdown_function(array($this,"__destruct"));
  }


// Creates new database connection from connection string
function __construct($ConnectionString){
   $this->conn = new COM("ADODB.Connection");
   if(!$this->conn) return; //throw new Exception("Microsoft ADO is not supported");
   $this->conn->Open($ConnectionString);
   }
  
function __destruct(){ if($this->conn) $this->conn->Close(); }

// Executes any SQL command other then SELECT
// Returns number of rows affected
function Exec($Command){
   $rows = 0;
   $rs = $this->conn->Execute($Command,$rows);
   return $rows;
   }

// Executes SELECT command and returns opened recordset or NULL for other commands
function Query($Command){
   $rs = $this->conn->Execute($Command);
   if($rs->State==0) return NULL;
   return new Recordset($rs);
   }
}
// -----------------------------------------------------------------------------
?>