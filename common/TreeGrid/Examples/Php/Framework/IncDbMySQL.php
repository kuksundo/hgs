<?php
// -----------------------------------------------------------------------------
// Two objects to access database via MySQL
// Works under any system (Windows, Linux, ...)
// You must create MySQL data source to the database first to use its name as parameter in Database constructor  
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
		$this->RowCount = mysql_num_rows($this->rs);
		$this->ColCount = mysql_num_fields($this->rs);
		
		for($i=0;$i<$this->ColCount;$i++){
			$name = mysql_field_name($this->rs,$i);
			$this->ColumnNames[$i] = $name;
			$this->ColumnIndexes[$name] = $i;
		}
		
		if($this->RowCount>0) $this->ARow = 0; //current row is 0 since MySQL rows go from 0 to num_rows-1
		else $this->ARow = -1; //means no rows found
	} 
	
	function __destruct(){ }

	function GetRowCount(){ return $this->RowCount; } // Returns number of records, can return -1 if no rows found
	function GetColCount(){ return $this->ColCount; } // Returns number columns
	
	function Next(){   // Moves to next record, returns true on success, false on EOF
		if($this->ARow<0 || $this->ARow>=($this->RowCount-1) || !mysql_data_seek($this->rs,$this->ARow+1)) return false;
		$this->ARow++;
		return true; 
	}
	
	function Prev(){ // Moves to previous record, returns true on success, false on BOF
		if($this->ARow<=0 || !mysql_data_seek($this->rs,$this->ARow-1)) return false;
		else $this->ARow--;
		return true;
	}
	
	function Last(){ // Moves to last record, returns true on success, false on EOF
		if($this->ARow<0 || !mysql_data_seek($this->rs,$this->RowCount-1)) return false;
		else $this->ARow = $this->RowCount;
		return true;
	}
	
	function First(){  // Moves to first record, returns true on success, false on BOF
		if($this->ARow<0 || !mysql_data_seek($this->rs,0)) return false;
		else $this->ARow = 0;
		return true; 
	}
	  
	// Returns value of the column value in actual row, column can be column name or index
	// If column does not exist, returns NULL
	function Get($Column){
		$arr = array();
		if($this->ARow<0 || !in_array($Column,$this->ColumnNames)) return NULL;
		else for($i=0;$i<$this->RowCount;$i++) $arr[] = mysql_result($this->rs,$i,$Column);
		return $arr; 
	}
	  
	// Returns array of actual row's values 
	function GetRow(){
		$arr = array();
		if($this->ARow<0) return NULL;
		else foreach($this->ColumnNames as $idx => $name) $arr[$name] = mysql_result($this->rs,$this->ARow,$idx);
		return $arr;
	}
	   
	// return array of rows
	function GetRows(){
		if(!$this->First()) return NULL;
		$k = 0;
		$arr = array();
		do {
			$arr[$k++] = $this->GetRow();   
		} while($this->Next());
		return $arr;
	}

	// Returns all rows in one array, uses only indexes, first row are column names, second is NULL (will be types)
	function GetTable(){
		$vals = $this->GetRows();
		if($vals) array_unshift($vals,$this->ColumnNames,NULL); //check if $vals is not NULL to avoid warnings
		return $vals;     
	}
}

	 
// -----------------------------------------------------------------------------
// Main object to connect to database
// Accepts database connection string as constructor parameter
class Database {
	var $conn;

	function Database($ConnectionString) {
		$ConnectionString = explode("|",$ConnectionString); //ConnectionString is in the form "DBname|[User]|[Password]|[Server[:port]]"
		$this->__construct($ConnectionString[0],$ConnectionString[1],$ConnectionString[2],$ConnectionString[3]);
		register_shutdown_function(array($this,"__destruct"));
	}

	function __construct($Name,$User="",$Password="",$Server="localhost:3306"){
		$this->conn = mysql_connect($Server,$User,$Password) or die("Error while connecting to MySQL server $Server: ".mysql_errno()." - ".mysql_error());
		mysql_query("SET NAMES 'utf8'",$this->conn);
		mysql_select_db($Name) or die("Error while selecting database $Name: ".mysql_errno()." - ".mysql_error());
	}
	
	function __destruct(){
		mysql_close($this->conn);
	}

	// Executes any SQL command other then SELECT
	// Returns number of rows affected
	function Exec($Command){
		mysql_query($Command,$this->conn);
		return mysql_affected_rows($this->conn); 
	}

	// Executes SELECT command and returns opened recordset or NULL for other commands
	function Query($Command){
		$rs = mysql_query($Command,$this->conn);
		if(!$rs) return NULL;
		else return new Recordset($rs);
	}
}
// -----------------------------------------------------------------------------