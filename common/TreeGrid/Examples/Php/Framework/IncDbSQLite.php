<?php
// -----------------------------------------------------------------------------
// Two objects to access PHP SQLite database
// Works under any system (Windows, Linux, ...)
// You must enable SQLite extension to use it under PHP  
// -----------------------------------------------------------------------------
// Recordset created by Database::Execute SQL SELECT command
// Used to read-only access to returned table
class Recordset {
private $rs;
public function __construct($Param){ $this->rs = $Param; } // Do not call constructor directly
public function __destruct(){ }

public function GetRowCount(){ return sqlite_num_rows ($this->rs); } // Returns number of records, can return -1 if cannot be determined
public function GetColCount(){ return sqlite_num_fields($this->rs); } // Returns number columns
public function Next(){ return sql_next($this->rs); }     // Moves to next record, returns true on success, false on EOF
public function Prev(){ return sql_prev($this->rs); }     // Moves to previous record, returns true on success, false on BOF
public function Last(){ return sql_seek($this->rs,sqlite_num_rows($this->rs)-1); } // Moves to last record, returns true on success, false on EOF
public function First(){return sql_rewind($this->rs); }   // Moves to first record, returns true on success, false on BOF
  
// Returns value of the column value in actual row, column can be column name or index
// If column does not exist, returns NULL
public function Get($Column){
   return sqlite_column($this->rs,$Column);
   }
  
// Returns array of actual row's values 
public function GetRow(){
   return sqlite_current($this->rs,SQLITE_ASSOC);  
   }
   
// return array of rows
public function GetRows(){
   return sqlite_fetch_all($this->rs,SQLITE_ASSOC);
   }

// Returns all rows in one array, uses only indexes, first row are column names, second is NULL (will be types)
public function GetTable(){
   $names = sqlite_current($this->rs,SQLITE_ASSOC);
   $k = 0;
   foreach($names as $name=>$none) $cols[$k++] = $name;
   $vals = sqlite_fetch_all($this->rs,SQLITE_NUM);
   array_unshift($vals,$cols,NULL);
   return $vals;     
   }
}

 
// -----------------------------------------------------------------------------
// Main object to connect to database
// Accepts database file name as constructor parameter
class Database {
private $File;
private $conn;
public function __construct($File){
   $this->File = $File;
   $this->conn = sqlite_open($File);
   if(!$this->conn) throw new Exception("Cannot open SQLite database $File");
   }
public function __destruct(){
   sqlite_close($this->conn);
   }

// Executes any SQL command other then SELECT
// Returns number of rows affected
public function Exec($Command){
   if(version_compare(PHP_VERSION,"5.1.0")){
      if(!sqlite_exec($this->conn,$Command)) throw new Exception("SQL command failed: $Command");
      }
   else { 
      $Error = null;
      if(!sqlite_exec($this->conn,$Command,$Error)) throw new Exception($Error);
      }
   return sqlite_changes($this->conn);
   }

// Executes SELECT command and returns opened recordset or NULL for other commands
public function Query($Command){
   if(version_compare(PHP_VERSION,"5.1.0")){
      $rs = sqlite_query($this->conn,$Command,SQLITE_BOTH);
      if(!$rs) throw new Exception("SQL command failed: $Command");
      }
   else {
      $Error = null;
      $rs = sqlite_query($this->conn,$Command,SQLITE_BOTH,$Error);
      if(!$rs) throw new Exception($Error);
      }
   return new Recordset($rs);
   }

// Inserts row to the table, table $name must exist and have appropriate column structure
// row contains named values for column's in one row
// Returns empty string or error message
public function InsertRow($name,$row){
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
   }
}
// -----------------------------------------------------------------------------