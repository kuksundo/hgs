<?php
/**********************************************************************
						 Php Textfile DB API
						Copyright 2005 by c-worker.ch
						  http://www.c-worker.ch
***********************************************************************/
/**********************************************************************
Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:
Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution. 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
THE POSSIBILITY OF SUCH DAMAGE. 
***********************************************************************/

include_once(API_HOME_DIR . "const.php");
include_once(API_HOME_DIR . "util.php");
include_once(API_HOME_DIR . "stringparser.php");


/**********************************************************************
								Row
***********************************************************************/

class Row {
	var $id;   			 // unique id for the row
	var $fields=array(); // fields of the row
}

/**********************************************************************
							ResultSet
***********************************************************************/

// Represents a Table
class ResultSet {
	
	/***********************************
		 	Mebmer Variables
	************************************/
	// columns
	var $colNames=array();
	var $colAliases=array();
	var $colTables=array();
	var $colTableAliases=array();
	var $colTypes=array();
	var $colDefaultValues=array();
	var $colFuncs=array();
	var $colFuncsExecuted=array();
	
	// rows 
	var $rows=array();  // to use as array of type Row (see above)
	
	// position in the ResultSet
	var $pos=-1;
		
	// informations how this resultSet is ordered 
	// at the momemt only used by cmpRows()
	var $orderColNrs=array(); // Column Nr
	var $orderTypes=array();  // ORDER_ASC or ORDER_DESC
	
	
	
	/***********************************
		 	row id functions 
	************************************/
	function setRowId($rowNr, $id) {
		$this->rows[$rowNr]->id=$id;
	}
	function getRowId($rowNr) {
		return $this->rows[$rowNr]->id;
	}
	function setCurrentRowId($id) {
		$this->rows[$this->pos]->id=$id;
	}
	function getCurrentRowId() {
		return $this->rows[$this->pos]->id;
	}
	function searchRowById($id) {
		for($i=0;$i<count($this->rows);++$i) {
			if(isset($this->rows[$i]->id) && $this->rows[$i]->id==$id)
				return $i;
		}
		return NOT_FOUND;
	}
	
	function generateRowIds() {
		$this->reset();
		$rId=-1;
		while((++$this->pos)<count($this->rows)) {
            $this->rows[$this->pos]->id=++$rId;
		}
        --$this->pos;
	}
	
	function setAllRowIds($val) {
		$this->reset();
		while((++$this->pos)<count($this->rows)) {
            $this->rows[$this->pos]->id=$val;
		}
        --$this->pos;
	}	
   
	
	/***********************************
		 	Navigate Functions
	************************************/
	function getPos() {
		return $this->pos;
	}
	function setPos($pos) {
		$this->pos=$pos;
	}
	function reset() {
		$this->pos=-1;
	}
	// Moves to the next row and returns true if there was a next row
	// or false if there was no next row
	function next() {
		if(!isset($this->rows))
			return false;
		if(++$this->pos<count($this->rows)) 
			return true;
		else {
			$this->pos--;
			return false;
		}
	}
	
 	function prev() {
		if(--$this->pos<count($this->rows) && $this->pos>-1)
			return true;
 		else
			return false;
	}
 	function end() {
		$this->pos= count($this->rows)-1;
 	}
 	function start() {
 		$this->reset();
 	}
 	
 	// Appends a row to the ResultSet
 	function append($setDefaultValues=true) {
 		$this->pos=count($this->rows)-1;
 		if(++$this->pos!= count($this->rows)) {
 			print_error_msg("append() failed, not at the end of the ResultSet");
 			$pos--;
 			return false;
 		}
 		$this->rows[$this->pos] = new Row;
 		if(!$setDefaultValues)
 			return;
 			
 		// Set initial values
 		for($i=0;$i<count($this->colTypes);++$i) {
 			// inc
 			if($this->colTypes[$i]==COL_TYPE_INC) {
 				if($this->pos==0) {
 					$this->rows[$this->pos]->fields[$i]=1;
 				} else {
 					$this->rows[$this->pos]->fields[$i]=$this->rows[$this->pos-1]->fields[$i]+1;
 				}
 			// int
 			} else if($this->colTypes[$i]==COL_TYPE_INT) {			
 				// make sure the default value is a number
 				$this->rows[$this->pos]->fields[$i]=intval($this->colDefaultValues[$i]);
 			// str
 			} else {
 				$this->rows[$this->pos]->fields[$i]=$this->colDefaultValues[$i];;
 			}
 		}
	}
  
  

  	/***********************************
		 	Column Functions (find)
	************************************/
	
	// Find a column by its full name, which is in the format
	// FUNC(table.column). 'FUNC' and 'table.' are voluntary. 
	// Returns the column number or NOT_FOUND if the column was not found
	function findColNrByFullName($fullColName) {
		$colName="";
		$colTable="";
		$colFunc="";	
		split_full_colname($fullColName,$colName,$colTable,$colFunc);
		return $this->findColNrByAttrs($colName,$colTable,$colFunc);
	}
	
	// Find a the number of a column with a SqlQuery object and an index into it
	// Returns the column number or NOT_FOUND if the column was not found
	function findColNrBySqlQuery(&$sqlQuery,$index) {
		$colName=($sqlQuery->colAliases[$index]?$sqlQuery->colAliases[$index]:$sqlQuery->colNames[$index]);
		return $this->findColNrByAttrs($colName,$sqlQuery->colTables[$index],$sqlQuery->colFuncs[$index]);
	}
		
	// Find a column by its attributes (name, table, function)
	// Returns the column number or NOT_FOUND if the column was not found
	function findColNrByAttrs($colName, $colTable, $colFunc) {
		$colFunc=strtoupper($colFunc);
		debug_print("Searching for Column: $colName, $colTable, $colFunc...&nbsp;&nbsp;&nbsp;&nbsp;");
		
		// search for colName in the alias first
		if($colName) {
			for($i=0;$i<count($this->colAliases);++$i) {
				// a column can be matched per alias, but only is the $colFunc param is ""
				// or the column functions are the same
				if($colName==$this->colAliases[$i] && 
				  (!$colFunc || $colFunc==$this->colFuncs[$i])) {
					debug_print("found at pos $i<br>");
					return $i;
				}
			}
		}
		
		// colName and colTable params are set
		if($colName && $colTable) {
			for($i=0;$i<count($this->colNames);++$i) {
				if($colName==$this->colNames[$i] && 
				  ($colTable==$this->colTables[$i] || $colTable==$this->colTableAliases[$i]) && 
				  $colFunc==$this->colFuncs[$i]) {
				  	debug_print("found at pos $i<br>");
					return $i;
				}
			}
			debug_print("NOT found!<br>");
			return NOT_FOUND;
		}
		
		// only with colName param is set
		if($colName) {
			for($i=0;$i<count($this->colNames);++$i) {
				if($colName==$this->colNames[$i] &&  $colFunc==$this->colFuncs[$i]) {
					debug_print("found at pos $i<br>");
					return $i;
				}
			}
			debug_print("NOT found!<br>");
			return NOT_FOUND;
		}
		
		// only colFunc param is set
		if($colFunc) {
			for($i=0;$i<count($this->colFuncs);++$i) {
				if($colFunc==$this->colFuncs[$i] && (!$this->colNames[$i]) && (!$this->colAliases[$i])) {
					debug_print("found at pos $i<br>");
					return $i;
				}
			}
			debug_print("NOT found!<br>");
			return NOT_FOUND;
		}
		debug_print("NOT found!<br>");
		return NOT_FOUND;
	}
	

	
	
	/***********************************
		 Column Functions (set/get)
	************************************/
	
	// names
	function getColumnNames() {
		return $this->colNames;
	}
	function setColumnNames($colNames) {
		$this->colNames=$colNames;
	}
	
	// aliases
	function getColumnAliases() {
		return $this->colAliases;
	}
	function setColumnAliases($colAliases) {
		$this->colAliases=$colAliases;
	}
	function setColumnAlias($colNr, $colAlias) {
		$this->colAliases[$colNr]=$colAlias;
	}
	
	// tables
	function getColumnTables() {
		return $this->colTables;
	}
	function setColumnTables($colTables) {
		$this->colTables=$colTables;
	}
	function setColumnTableForAll($colTable) {
		$this->colTables=create_array_fill(count($this->colNames),$colTable);
	}
	
	// table aliases
	function getColumnTableAliases() {
		return $this->colTableAliases;
	}
	function setColumnTableAliases($colTableAliases) {
		$this->colTableAliases=$colTableAliases;
	}
	function setColumnTableAliasForAll($colTableAlias) {
		$this->colTableAliases=create_array_fill(count($this->colNames),$colTableAlias);
	}
	
	// types	
	function getColumnTypes() {
		return $this->colTypes;
	}
	function setColumnTypes($colTypes) {
		$this->colTypes=$colTypes;
	}
	
	// default values
	function getColumnDefaultValues() {
		return $this->colDefaultValues;
	}
	function setColumnDefaultValues($colDefaultValues) {
		$this->colDefaultValues=$colDefaultValues;
	}
	
	// functions
	function getColumnFunctions() {
		return $this->colFuncs;
	}
	function setColumnFunctions($colFuncs) {
		$this->colFuncs=$colFuncs;
	}
	function setColumnFunction($colNr, $colFunc) {
		$this->colFuncs[$colNr]=$colFunc;
	}

	
	
	/***********************************
		 Column Functions (other)
	************************************/
	
	// copies all column data from another ResultSet
	function copyColumData($otherResultSet) {
		$this->setColumnNames($otherResultSet->getColumnNames());
		$this->setColumnAliases($otherResultSet->getColumnAliases());
		$this->setColumnTables($otherResultSet->getColumnTables());
		$this->setColumnTableAliases($otherResultSet->getColumnTableAliases());
		$this->setColumnTypes($otherResultSet->getColumnTypes());
		$this->setColumnDefaultValues($otherResultSet->getColumnDefaultValues());
		$this->setColumnFunctions($otherResultSet->getColumnFunctions());
		$this->colFuncsExecuted=$otherResultSet->colFuncsExecuted;
	}
	
	
	// Adds a Column to the ResultSet 
	function addColumn($colName, $colAlias, $colTable, $colTableAlias, $colType, $colDefaultValue, $colFunc, $value, $setValues=true) {
		
		$this->colNames[]=$colName;
		$colNr=count($this->colNames)-1;
		
		$this->colAliases[$colNr]=$colAlias;
		$this->colTables[$colNr]=$colTable;
		$this->colTableAliases[$colNr]=$colTableAlias;
		$this->colTypes[$colNr]=$colType;
		$this->colDefaultValues[$colNr]=$colDefaultValue;
		$this->colFuncs[$colNr]=$colFunc;
		$this->colFuncsExecuted[$colNr]=false;
	
		if($setValues) {
			$rowCount=count($this->rows);
			for($i=0;$i<$rowCount;++$i) {
				$this->rows[$i]->fields[$colNr]=$value;
			}
		} else {
			// set values to an empty string or we will mess up the ResultSet
			$rowCount=count($this->rows);
			for($i=0;$i<$rowCount;++$i) {
				$this->rows[$i]->fields[$colNr]="";
			}		
		}
	}
	
	// Duplicates the column $colNr (column attributes and values are duplicated)
	// not used at the moment
	function duplicateColumn($colNr){
		
		$this->colNames[]=$this->colNames[$colNr];
		$this->colAliases[]=$this->colAliases[$colNr];
		$this->colTables[]=$this->colTables[$colNr];
		$this->colTableAliases[]=$this->colTableAliases[$colNr];
		$this->colTypes[]=$this->colTypes[$colNr];
		$this->colDefaultValues[]=$this->colDefaultValues[$colNr];
		$this->colFuncs[]=$this->colFuncs[$colNr];
		$this->colFuncsExecuted[]=$this->colFuncsExecuted[$colNr];
		
		$newColNr=count($this->colNames)-1;
	
		$rowCount=count($this->rows);
		for($i=0;$i<$rowCount;++$i) {
			$this->rows[$i]->fields[$newColNr]=$this->rows[$i]->fields[$colNr];
		}
	}
	
	// Copies the column header-data and column-values from $srcColNr to $destColNr
	// not used at the moment
	function copyColumn($srcColNr, $destColNr){
		
		$this->colNames[$destColNr]=$this->colNames[$srcColNr];
		$this->colAliases[$destColNr]=$this->colAliases[$srcColNr];
		$this->colTables[$destColNr]=$this->colTables[$srcColNr];
		$this->colTableAliases[$destColNr]=$this->colTableAliases[$srcColNr];
		$this->colTypes[$destColNr]=$this->colTypes[$srcColNr];
		$this->colDefaultValues[$destColNr]=$this->colDefaultValues[$srcColNr];
		$this->colFuncs[$destColNr]=$this->colFuncs[$srcColNr];
		$this->colFuncsExecuted[$destColNr]=$this->colFuncsExecuted[$srcColNr];
	
		$rowCount=count($this->rows);
		for($i=0;$i<$rowCount;++$i) {
			$this->rows[$i]->fields[$destColNr]=$this->rows[$i]->fields[$srcColNr];
		}
	}

	
	// Removes a Column from the ResultSet.
	// After removeColumn is called, the colNr's of the other Columns change !
	function removeColumn($colNr) {
		
		// save Pos
		$tmpPos=$this->pos;
		
		$this->reset();
		while($this->next()) {
			array_splice ($this->rows[$this->pos]->fields, $colNr,1);
		}
		
		// restore Pos
		$this->pos=$tmpPos;
		
		debug_print ("Removing colum nr $colNr <br>");		

		// remove in Column Data
		array_splice($this->colNames,$colNr,1);
		array_splice($this->colAliases,$colNr,1);
		array_splice($this->colTables,$colNr,1);
		array_splice($this->colTableAliases,$colNr,1);
		array_splice($this->colTypes,$colNr,1);
		array_splice($this->colDefaultValues,$colNr,1);
		array_splice($this->colFuncs,$colNr,1);
		array_splice($this->colFuncsExecuted,$colNr,1);
		
	}
	

	

	// Orders the columns (themself e.g. [Nr] [Name] [UserId] -> [Name] [Nr] [UserId])
	// by the order the columns have in the SqlQuery object
	function orderColumnsBySqlQuery(&$sqlQuery) {
		
		$newColNames=array();
		$newColAliases=array();
		$newColTables=array();
		$newColTableAliases=array();
		$newColTypes=array();
		$newColDefaultValues=array();
		$newColFuncs=array();
		$newColFuncsExecuted=array();

		
		$colPos=-1;
		$currentColumn=-1; 
		$oldRows=$this->rows;
				
		$oldColUsed=create_array_fill(count($this->colNames),false);
	
			
		if(count($sqlQuery->colNames)==1 && $sqlQuery->colNames[0]=="*" && (!$sqlQuery->colTables[0])) {
			return true;
		}
		unset($this->rows); 
		
		for($i=0;$i<count($sqlQuery->colNames);++$i) {
			++$currentColumn;
			
			// Handling for table.*
			if($sqlQuery->colNames[$i]=="*" && $sqlQuery->colTables[$i]) {
			    for($j=0;$j<count($this->colTables);++$j) {
					if(	$sqlQuery->colTables[$i] && 
					   ($sqlQuery->colTables[$i]==$this->colTables[$j] || 				   
					   $sqlQuery->colTables[$i]==$this->colTableAliases[$j])) {
						
						debug_print("transfering col " . $i . " to " . $currentColumn . "<br>");
						
						$newColNames[$currentColumn]=$this->colNames[$j];
						$newColAliases[$currentColumn]=$this->colAliases[$j];
						$newColTables[$currentColumn]=$this->colTables[$j];
						$newColTableAliases[$currentColumn]=$this->colTableAliases[$j];
						$newColTypes[$currentColumn]=$this->colTypes[$j];
						$newColDefaultValues[$currentColumn]=$this->colDefaultValues[$j];
						$newColFuncs[$currentColumn]=$this->colFuncs[$j];
						$newColFuncsExecuted[$currentColumn]=$this->colFuncsExecuted[$j];
						
						$oldColUsed[$j]=true;	
						for($k=0;$k<count($oldRows);$k++) {
							if(!isset($this->rows[$k])) { 
								$this->rows[$k] = new Row; 
							} 
							$this->rows[$k]->id=$oldRows[$k]->id;
							$this->rows[$k]->fields[$currentColumn]=$oldRows[$k]->fields[$j];
						}			
						$currentColumn++;
					}					
				}
				$currentColumn--;
				continue;	
			}
			
			
			if( ($colPos=$this->findColNrBySqlQuery($sqlQuery,$i))==-1) {
				print_error_msg("Column '" . $sqlQuery->colNames[$i] . "' not found!! (" 
				            . $sqlQuery->colFuncs[$i] . "," .$sqlQuery->colTables[$i].",".$sqlQuery->colAliases[$i] . ")");
				return false;
			}
			debug_print("transfering col " . $colPos . " to " . $currentColumn . "<br>");
			$newColNames[$currentColumn]=$this->colNames[$colPos];
			$newColAliases[$currentColumn]=$this->colAliases[$colPos];
			$newColTables[$currentColumn]=$this->colTables[$colPos];
			$newColTableAliases[$currentColumn]=$this->colTableAliases[$colPos];
			$newColTypes[$currentColumn]=$this->colTypes[$colPos];
			$newColDefaultValues[$currentColumn]=$this->colDefaultValues[$colPos];
			$newColFuncs[$currentColumn]=$this->colFuncs[$colPos];
			$newColFuncsExecuted[$currentColumn]=$this->colFuncsExecuted[$colPos];
			
			$oldColUsed[$colPos]=true;
			
			for($j=0;$j<count($oldRows);++$j) {
				if(!isset($this->rows[$j])) { 
					$this->rows[$j] = new Row; 
				}
				$this->rows[$j]->id=$oldRows[$j]->id;
				$this->rows[$j]->fields[$currentColumn]=$oldRows[$j]->fields[$colPos];
			}			
		}
		
		// add the remaining columns to the end 
		for($i=0;$i<count($oldColUsed);++$i) {
			if(!$oldColUsed[$i]) {
				$addColPos=count($newColNames);
				
				debug_print("transfering col " . $i . " to " . $addColPos . "<br>");
				$newColNames[$addColPos]=$this->colNames[$i];
				$newColAliases[$addColPos]=$this->colAliases[$i];
				$newColTables[$addColPos]=$this->colTables[$i];
				$newColTableAliases[$addColPos]=$this->colTableAliases[$i];
				$newColTypes[$addColPos]=$this->colTypes[$i];
				$newColDefaultValues[$addColPos]=$this->colDefaultValues[$i];
				$newColFuncs[$addColPos]=$this->colFuncs[$i];
				$newColFuncsExecuted[$addColPos]=$this->colFuncsExecuted[$i];
				
				for($j=0;$j<count($oldRows);++$j) {
					if(!isset($this->rows[$j])) { 
						$this->rows[$j] = new Row; 
					}
					$this->rows[$j]->id=$oldRows[$j]->id;
					$this->rows[$j]->fields[$addColPos]=$oldRows[$j]->fields[$i];
				}	
				
			}
		}

		$this->colNames=$newColNames;
		$this->colAliases=$newColAliases;
		$this->colTables=$newColTables;
		$this->colTableAliases=$newColTableAliases;
		$this->colTypes=$newColTypes;
		$this->colDefaultValues=$newColDefaultValues;
		$this->colFuncs=$newColFuncs;
		$this->colFuncsExecuted=$newColFuncsExecuted;
		
		return true;		
	}
	
	
	// In the WHERE expression might be FUNC(col), FUNC() 
	// variants which aren't listed after SELECT.
	// This function scans a WHERE-Expression and adds the columns
	// it finds.
	// Returns true if all went ok, or false on errors
	function generateAdditionalColumnsFromWhereExpr($where_expr) {
		
		global $g_sqlSingleRecFuncs;
		
		$parser=new SqlParser($where_expr);
		$elem="";
		$colFuncs=array();
		$colNames=array();
		$colTables=array();
		$index=-1;
		
		while(!is_empty_str($elem=$parser->parseNextElementRaw())) {
		
			// function  ?
			if(in_array(strtoupper($elem),$g_sqlSingleRecFuncs)) {
				
				++$index;
				$colNames[$index]="";
				$colTables[$index]="";
				$colFuncs[$index]=strtoupper($elem);

				$elem=$parser->parseNextElementRaw();
				if($elem!="(") {
					print_error_msg("( expected after $elem");
					return false;
				}
		
				while(!is_empty_str($elem=$parser->parseNextElementRaw()) && $elem!=")") {
					if($elem==".") {
						$colTables[$index]=$colNames[$index];
						$colNames[$index]=$parser->parseNextElementRaw();
					} else {
						$colNames[$index] = $elem;
					}
				}
			}
		}
		return $this->generateAdditionalColumnsFromArrays($colNames,$colTables,$colFuncs);
	}
	
	
	// This function scans an array of full column names
	// for additional FUNC() or FUNC(col) variants
	// and adds the columns it finds.
	// Returns true if all went ok, or false on errors
	function generateAdditionalColumnsFromArray($arrFullColNames) {
		$colNames=array();
		$colTables=array();
		$colFuncs=array();
		for($i=0;$i<count($arrFullColNames);++$i) {
			$colNames[$i]="";
			$colTables[$i]="";
			$colFuncs[$i]="";
			split_full_colname($arrFullColNames[$i],$colNames[$i],$colTables[$i],$colFuncs[$i]);
		}
		return $this->generateAdditionalColumnsFromArrays($colNames, $colTables, $colFuncs);
	}

	
	// This function scans arrays of column names, tables and functions 
	// for additional FUNC() or FUNC(col) variants
	// and adds the columns it finds.
	// Returns true if all went ok, or false on errors
	function generateAdditionalColumnsFromArrays($colNames, $colTables, $colFuncs) {
		if(TXTDBAPI_DEBUG) {
			debug_print("[generateAdditionalColumnsFromArrays] Trying to add the following columns:<br>");
			print_r($colNames); echo "<br>";
			print_r($colTables); echo "<br>";
			print_r($colFuncs); echo "<br>";
		}
				
		for($i=0;$i<count($colNames);++$i) {

			// EVAL
			if($colFuncs[$i]=="EVAL") {
				debug_print("Column <b>" . $colNames[$i] . ", " . $colTables[$i]. ", " . $colFuncs[$i] . "</b> : creating EVAL column!<br>");
				$this->addColumn($colNames[$i],"","","","str","",$colFuncs[$i],"",false);
				continue;
			}

			// does this column allready exist ?
			$colNr=$this->findColNrByAttrs($colNames[$i],$colTables[$i],$colFuncs[$i]);
			if($colNr!=NOT_FOUND) {
				debug_print("Column <b>" . $colNames[$i] . ", " . $colTables[$i]. ", " . $colFuncs[$i] . "</b> : allready exists!<br>");
				continue;
			}
					
			// create additional columns for non-param function
			if($colFuncs[$i] && (!$colNames[$i])) {
				debug_print("Column <b>" . $colNames[$i] . ", " . $colTables[$i]. ", " . $colFuncs[$i] . "</b> : creating additional Non-param-func column!<br>");
				
				$this->addColumn("","","","","str","",$colFuncs[$i],"",false);
			
			
			// create additional column for non-column-param function
			} else if($colFuncs[$i] && $colNames[$i] && ( is_numeric($colNames[$i]) || has_quotes($colNames[$i]))) {
				debug_print("Column <b>" . $colNames[$i] . ", " . $colTables[$i]. ", " . $colFuncs[$i] . "</b> : creating additional Non-column-param-func column!<br>");
				$this->addColumn($colNames[$i],"","","","str","",$colFuncs[$i],"",false);
			} else if($colFuncs[$i] && $colNames[$i]) {
				
				debug_print("Column <b>" . $colNames[$i] . ", " . $colTables[$i]. ", " . $colFuncs[$i] . "</b> : creating additional Param-func column!<br>");

				// search column (without function)
				$colNr=$this->findColNrByAttrs($colNames[$i],$colTables[$i],"");
				if($colNr==NOT_FOUND) {
					debug_print("Original NOT found!<br>");
					print_error_msg("Column '".$colNames[$i]."' not found");
					return NOT_FOUND;
				}
				debug_print("Original found at $colNr<br>");
				
				// add column
				$this->addColumn($this->colNames[$colNr],$this->colAliases[$colNr],$this->colTables[$colNr],$this->colTableAliases[$colNr],"str","",$colFuncs[$i],"",false);
				$newCol=count($this->colNames)-1;
				// set function for new column
				$this->colFuncs[$newCol]=$colFuncs[$i];
				
			
			// add direct values ( no function)
			} else if( !$colFuncs[$i] && $colNames[$i] && ( is_numeric($colNames[$i]) || has_quotes($colNames[$i]))) {
				debug_print("Column <b>" . $colNames[$i] . ", " . $colTables[$i]. ", " . $colFuncs[$i] . "</b> : creating direct value column!<br>");
			   	$value=$colNames[$i];
			   	if(has_quotes($value)) {
			   		remove_quotes($value);
			   	}
			   	$this->addColumn($colNames[$i],"","","","str","","",$value,true);
				
			}
		}
	}
	
	
  	/***********************************
	Row Size Functions (Field Count per Row)
	************************************/
	function getRowSize() {
		if(count($this->colNames)>0)
			return count($this->colNames);
		else
			return 0;
	}
	
	/***********************************
			Row Count Functions
	************************************/
  	function getRowCount() {
  		return (isset($this->rows) ? count($this->rows) : 0);
 	}
 	
 	
 	/***********************************
			Field Access Functions
	************************************/

 	// Get Value by Name
 	function getCurrentValueByName($colName) {
 		if(($colNr=$this->findColNrByFullName($colName))==-1)	
 			return;
 		else 			
 			return $this->rows[$this->pos]->fields[$colNr];
 	}
 	function getValueByName($rowNr,$colName) {
 		 if(($colNr=$this->findColNrByFullName($colName))==-1)	
 			return;
 		else
 			return $this->rows[$rowNr]->fields[$colNr];
 	}
 	
 	// Get Value by Nr
 	function getCurrentValueByNr($colNr) {
 		return $this->rows[$this->pos]->fields[$colNr];
 	}
 	function getValueByNr($rowNr, $colNr) {
 		return $this->rows[$rowNr]->fields[$colNr];
 	}
 	
 	// Set Value by Name 
 	function setCurrentValueByName($colName, $value) {
 		if(($colNr=$this->findColNrByFullName($colName))==NOT_FOUND){
 			print_error_msg("Column '$colName' not found!");
 			return false;
 		} else {
 			$this->rows[$this->pos]->fields[$colNr] = $value;
 			return true;
 		}
 	}
 	function setValueByName($rowNr,$colName,$value) {
 		if(($colNr=$this->findColNrByFullName($colName))==NOT_FOUND) {
 			print_error_msg("Column '$colName' not found!");
 			return false;
 		} else {
 			$this->rows[$rowNr]->fields[$colNr]= $value;
 			return true;
 		}
 	}
 	
 	// Set Value by Nr 
 	function setCurrentValueByNr($colNr, $value) {
 		$this->rows[$this->pos]->fields[$colNr] = $value;
 	}
 	function setValueByNr($rowNr, $colNr, $value) {
 		$this->rows[$rowNr]->fields[$colNr] = $value;
 	}
 	
 	// Get whole row
	function getCurrentValues() {
		return $this->rows[$this->pos]->fields;
	}
	function getValues($rowNr) {
		return $this->rows[$rowNr]->fields;
	}
	
	// Get whole row as hash
	function getCurrentValuesAsHash()  {
		foreach ($this->rows[$this->pos]->fields as $key => $value) {
			if ($this->colAliases[$key]) {
				$newhash[$this->colAliases[$key]]=$value; 
			} else {
				$newhash[$this->colNames[$key]]=$value; 
			}
		}
		return $newhash; 
	} 


	
	// Set whole row
	function setCurrentValues($values) {
		$this->rows[$this->pos]->fields = $values;
	}
	function setValues($rowNr,$values) {
		$this->rows[$rowNr]=$values;
	}

	// Appends a row by using an array of values
	// Here inc values wont be set, caller must supply all values !
	function appendRow($values, $id=-1) {
		
		if(count($values)==count($this->getColumnNames()))
			$setDefaults = false;
		else                                                                      
			$setDefaults = true;



		// if id is -1 do a simple append
		if($id==-1) {
			$this->append($setDefaults);
			if($setDefaults) {
				array_splice($this->rows[$this->pos]->fields,0,count($values),$values);
			} else {
				$this->rows[$this->pos]->fields=$values;
			}
			$this->rows[$this->pos]->id=$id;
		// else, if the id exists let the ResultSet untouched..
		} else if($this->searchRowById($id)==-1) {
			$this->append($setDefaults);
			if($setDefaults) {
				array_splice($this->rows[$this->pos]->fields,0,count($values),$values);
			} else {
				$this->rows[$this->pos]->fields=$values;
			}
			$this->rows[$this->pos]->id=$id;
		} 
	}
	
		
	/***********************************
			Row Delete Functions
	************************************/
	function deleteRow($rowNr) {
		array_splice ($this->rows, $rowNr,1);
	}
	function deleteCurrentRow() {
		$this->deleteRow($this->pos);
	}
	function deleteAllRows() {
		$this->rows=array();
	}
	

	/***********************************
		 	Limit Functions
	************************************/
	
	// Limit's the ResultSet
	function limitResultSet($ar_limit) {
		if(!isset($ar_limit[0]) && !isset($ar_limit[1])) return $this;
		if(count($ar_limit) == 1) {
			$ar_limit[1] = $ar_limit[0];   // because LIMIT 30 is equal to
			$ar_limit[0] = 0;              // LIMIT 0,30
		}
		
		$rowCount = $this->getRowCount();
		if ($ar_limit[0]+$ar_limit[1] > $rowCount)
			$ar_limit[1] = $rowCount - $ar_limit[0];

		$rs=new ResultSet();
		$rs->copyColumData($this);
		
		$this->pos = $ar_limit[0];         // we begin at the offset

		for($i=0; $i<$ar_limit[1]; ++$i) {
			$rs->append(0);
			
			$rs->rows[$rs->pos]->fields=$this->rows[$this->pos]->fields;
			$rs->rows[$rs->pos]->id=$this->rows[$this->pos]->id;
			
			$this->next();
		}
		return $rs;
	}

	
	/***********************************
			Group Functions
	************************************/
	
	// Groups the ResultSet by using the groupColumns in $sqlQuery
	// and $this->colFuncs.
	// If $useLimit is true $sqlQuery->limit is used to stop grouping
	// after the result contains enough rows 
	function groupRows(&$sqlQuery,$useLimit=false) {
		
		debug_printb("[groupRows] Grouping rows...<br>");
		global $g_sqlGroupingFuncs;
		$ar_limit=$sqlQuery->limit;
		$groupColumns=$sqlQuery->groupColumns;
		$groupColNrs=array();
		
		// use column numbers (faster)
		for($i=0;$i<count($groupColumns);++$i) {
			$groupColNrs[$i]=$this->findColNrByFullName($groupColumns[$i]);
			if($groupColNrs[$i]==NOT_FOUND) {
				print_error_msg("Column '" . $groupColumns[$i] . "' not found!");
				return false;
			}
			
		}
		
		// calc limit
		if(!$useLimit) {
			$limit = -1;
		} else {
			if(!isset($ar_limit[0]) && !isset($ar_limit[1])) {
				$limit = -1;
			} else if(count($ar_limit) > 1) {
				$limit = $ar_limit[0]+$ar_limit[1];	
			} else {
				$limit = $ar_limit[0];
			}
		}
			
		
		$rs=new ResultSet();
		$rs->copyColumData($this);
		$groupedRows=array(); 
		$groupedValues=array();
		
		$colNamesCount=count($this->colNames);
		
		$this->reset();
		while((++$this->pos)<count($this->rows)) {
			
			// generate key
			$currentValues=array();
			foreach($groupColNrs as $groupColNr) {
				array_push($currentValues, md5($this->rows[$this->pos]->fields[$groupColNr]));
			}
			$groupedRecsKey=join("-",$currentValues);
			
			for($i=0;$i<$colNamesCount;++$i) {
				$groupedValues[$groupedRecsKey][$i][]=$this->rows[$this->pos]->fields[$i];
			}
			
			// key doesn't exist ? add record an set key into array
			if(!array_key_exists($groupedRecsKey, $groupedRows)) {
				$groupedRows[$groupedRecsKey] = 1;
				$rs->append(false);			
				$rs->rows[$rs->pos]->fields=$this->rows[$this->pos]->fields;
				$rs->rows[$rs->pos]->id=$this->rows[$this->pos]->id;
			}

			
			if($limit != -1)
				if(count($rs->rows) >= $limit)
					break;
		}
		--$this->pos;
		
		if(TXTDBAPI_VERBOSE_DEBUG) {
			echo "<b>RS dump in groupRows():<br></b>";
			$rs->dump();
		}
		
	
		$groupFuncSrcColNr = -1; // the source column for the column with grouping functions
		
		// calculate the result of the functions
		for($i=0;$i<count($rs->colFuncs);++$i) {
			if(in_array($rs->colFuncs[$i],$g_sqlGroupingFuncs)) {

				if(TXTDBAPI_DEBUG) {		
					debug_print("Searching source for grouping function " . $rs->colFuncs[$i] . "(");
					if($rs->colTables[$i])
						debug_print($rs->colTables[$i] . ".");
					debug_print($rs->colNames[$i] . "): ");
				}
				
				if($rs->colFuncs[$i]=="COUNT" && $rs->colNames[$i]=="*")  {
					$groupFuncSrcColNr=0;
				} else {
					$groupFuncSrcColNr=$this->findColNrByAttrs($rs->colNames[$i],$rs->colTables[$i],"");
				}
				
				if($groupFuncSrcColNr==NOT_FOUND) {
					print_error_msg("Column " . $rs->colNames[$i] . ", " . $rs->colTables[$i] . " not found!");
					return null;
				}
				
				foreach($groupedValues as $key => $value) {
					$groupedValues[$key][$i][0]=execGroupFunc($rs->colFuncs[$i], $groupedValues[$key][$groupFuncSrcColNr]);
				}
			}
		}
		
		// put the results back
		$rs->reset();
		foreach($groupedValues as $key => $value) {
			$rs->next();
			for($i=0;$i<$colNamesCount;++$i) {
				$rs->rows[$rs->pos]->fields[$i]=$groupedValues[$key][$i][0];
			}
		}
		return $rs;
	}
	
	
	// Make's the ResultSet containg only unique values
	function makeDistinct($ar_limit) {
		
		$colNames = $this->getColumnNames();
		
		// calc limit
		if(!isset($ar_limit[0]) && !isset($ar_limit[1]))
			$limit = -1;
		else if(count($ar_limit) > 1) 
			$limit = $ar_limit[0]+$ar_limit[1];	
		else 
			$limit = $ar_limit[0];

		$rs=new ResultSet();
		$rs->copyColumData($this);

		$distinctRows=array();
		$this->reset();
		while((++$this->pos)<count($this->rows)) {
			$currentValues=array();
			foreach($colNames as $col)
				array_push($currentValues, md5($this->getCurrentValueByName($col)));
			$joinedValues=join("-",$currentValues);
			if(!array_key_exists($joinedValues, $distinctRows)) {
				$distinctRows[$joinedValues] = 1;
				$rs->append(false);
				
				$rs->rows[$rs->pos]->fields=$this->rows[$this->pos]->fields;
				$rs->rows[$rs->pos]->id=$this->rows[$this->pos]->id;
				
			}
			if($limit != -1)
				if($rs->getRowCount() >= $limit)
					break;
		}
		--$this->pos;
		return $rs;
	}


	
	/***********************************
			Filter Functions
	************************************/

	// Removes all columns which are not found in the SqlQuery object
	function filterByColumnNamesInSqlQuery(&$sqlQuery) {
		$colNrsToKeep=array();
		
		if(count($sqlQuery->colNames)==1 && $sqlQuery->colNames[0]=="*" && (!$sqlQuery->colTables[0]) && (!$sqlQuery->colFuncs[0]))
			return true;
		
		for($i=0;$i<count($sqlQuery->colNames);++$i) {
			
			// keep all of a table ?
			if($sqlQuery->colNames[$i]=="*" && $sqlQuery->colTables[$i] && (!$sqlQuery->colFuncs[$i])) {
			  	$keepAllOfTable=$sqlQuery->colTables[$i];
			  	for($j=0;$j<count($this->colTables);++$j) {
					if($this->colTables[$j]==$keepAllOfTable || $this->colTableAliases[$j]==$keepAllOfTable) {
						$colNrsToKeep[]=$j;
					}
				}  	
			} else {

				$colNr=$this->findColNrBySqlQuery($sqlQuery,$i);
				if($colNr==NOT_FOUND) {
					print_error_msg("filterByColumnNames(): Column '" . $sqlQuery->colNames[$i] . "' not found");
					return null;
				} else {
					$colNrsToKeep[]=$colNr;
				}
			}
		}
		
		// remove from last element to first (because colNr's change afer a removeColumn() call
		for($i=count($this->colNames)-1;$i>=0;$i--) 
			if(!in_array($i,$colNrsToKeep))
				$this->removeColumn($i);
	}
	
	
	

	// Filters the rows by 1-n AND Conditions
	// parameters: 
	// 2 parameter arrays and 1 operator array
	// the entry in the parameter arrays can be columns or 
	// values (numbers: 1234 or strings: 'bla')
	// Return value: ResultSet with filtered Records (copy) ($this is left unchanged)
	function filterRowsByAndConditions($params1, $params2, $operators) {
		$rs=new ResultSet();
		$rs->copyColumData($this);
		
		$this->reset();
		
		$colNrs1=array();
		$colNrs2=array();
		
		// find column nr's for params1 -1=no column, its a direct value
		for($i=0;$i<count($params1);++$i) {
			if(($colNrs1[$i]=$this->findColNrByFullName($params1[$i]))==NOT_FOUND) {
				if(has_quotes($params1[$i]) || is_numeric($params1[$i])) {
					$colNrs1[$i]=-1;
					if(has_quotes($params1[$i])) {
						remove_quotes($params1[$i]);
					}
				} else {
					print_error_msg("Column '" . $params1[$i] . "' not found");
					return null;
				}
			}
		}
		
		// find column nr's for params2 -1=no column, its a direct value
		for($i=0;$i<count($params2);++$i) {
			if($operators[$i] == "IN" || $operators[$i] == "NOT IN") {
				$colNrs2[$i]=-1;
				continue;			
			}
			if(($colNrs2[$i]=$this->findColNrByFullName($params2[$i]))==NOT_FOUND) {
				if(has_quotes($params2[$i]) || is_numeric($params2[$i])) {
					$colNrs2[$i]=-1;
					if(has_quotes($params2[$i])) {
						remove_quotes($params2[$i]);
					}
				} else {
					print_error_msg("Column '" . $params2[$i] . "' not found");
					return null;
				}
			}
		}
		
		$val1="";
		$val2="";			
		$this->reset();
		while((++$this->pos)<count($this->rows)) {
			$recMetsConds=true;
			for($i=0;$i<count($params1);++$i) {
				
				if($colNrs1[$i]==-1) {
					$val1=$params1[$i];
				} else {
					$val1=$this->rows[$this->pos]->fields[$colNrs1[$i]];
				}
				
				if($colNrs2[$i]==-1) {
					$val2=$params2[$i];
				} else {
					$val2=$this->rows[$this->pos]->fields[$colNrs2[$i]];
				}
				
				if(!compare($val1,$val2,$operators[$i])) {
					$recMetsConds=false;
					break;
				}
			}
			
			if($recMetsConds) {
				$rs->append(false);
				
				$rs->rows[$rs->pos]->fields=$this->rows[$this->pos]->fields;
				$rs->rows[$rs->pos]->id=$this->rows[$this->pos]->id;
			}
		}
		// reset ResultSet's
		$this->reset();
		$rs->reset();
		return $rs;
	}

	
	// Removes all rows from $this, which are not contained
	// in $otherResultSet. 
	// The $rows->id var is used to check if 2 Rows match.
	// parameter: $otherResultSet with !! row->id's set !!
	function filterResultSetAndWithAnother(&$otherResultSet) {	
		$this->reset();
		while($this->next()) {
			if($otherResultSet->searchRowById($this->getCurrentRowId())==NOT_FOUND) {
				$this->deleteCurrentRow();
				$this->prev(); // Because the current Row was deleted, check again at this position
			}
		}		
	}
	
	
	



	/***********************************
			ResultSet join Functions
	************************************/

	// Returns a ResultSet which contains the columns and rows
	// of $this and $otherResultSet (a new ResultSet is returned).
	// The ResultSet itself ($this) is left unchanged.
	// For each row in $this each row in $otherResultSet will be duplicated
	// Example:
	// 1	Test	Hello
	// 2 	Test2	Hello2 
	//  joined with
	// 10	Blabla
	// 11 	Foo_Bar
	// 13   Bar_foo
	//  results in
	// 1	Test	Hello	10	Blabla
	// 1	Test	Hello	11	Foo_Bar
	// 1	Test	Hello	13	Bar_foo
	// 2 	Test2	Hello2 	10	Blabla
	// 2 	Test2	Hello2 	11	Foo_Bar
	// 2 	Test2	Hello2 	13	Bar_foo
	//
	// useRowIdsOf: 0=this, 1=other
	function joinWithResultSet(&$otherResultSet, $useRowIdsOf=0) {

		if($this->getRowCount()<1) {
			debug_print("Joining emtpy ResultSet (results in empty ResultSet)");
		}
			
		$newResultSet=new ResultSet();
		// columns
		$newResultSet->setColumnNames(array_merge ($this->getColumnNames(), $otherResultSet->getColumnNames()));
		$newResultSet->setColumnAliases(array_merge ($this->getColumnAliases(), $otherResultSet->getColumnAliases()));
		$newResultSet->setColumnTables(array_merge ($this->getColumnTables(), $otherResultSet->getColumnTables()));
		$newResultSet->setColumnTableAliases(array_merge ($this->getColumnTableAliases(), $otherResultSet->getColumnTableAliases()));
		$newResultSet->setColumnTypes(array_merge ($this->getColumnTypes(), $otherResultSet->getColumnTypes()));
		$newResultSet->setColumnDefaultValues(array_merge ($this->getColumnDefaultValues(), $otherResultSet->getColumnDefaultValues()));
		$newResultSet->setColumnFunctions(array_merge ($this->getColumnFunctions(), $otherResultSet->getColumnFunctions()));
		$newResultSet->colFuncsExecuted=(array_merge ($this->colFuncsExecuted, $otherResultSet->colFuncsExecuted));
		

		$otherResultSet->reset();
		$this->reset();
		$newResultSet->reset();
		
		while($this->next()) {
			$otherResultSet->reset();
			while($otherResultSet->next()) {
				$row=array_merge($this->getCurrentValues(),$otherResultSet->getCurrentValues());
				if($useRowIdsOf==1) {
					
					$newResultSet->append(false);
					$newResultSet->rows[$newResultSet->pos]->fields=$row;
					$newResultSet->rows[$newResultSet->pos]->id=$otherResultSet->rows[$otherResultSet->pos]->id;		
					
				} else {
					
					$newResultSet->append(false);
					$newResultSet->rows[$newResultSet->pos]->fields=$row;
					$newResultSet->rows[$newResultSet->pos]->id=$this->rows[$this->pos]->id;
				} 
			}
		}
		
		return $newResultSet;
		
	}	
	
	
	
	
	function copy() {

		$newResultSet=new ResultSet();
		$newResultSet->copyColumData($this);
		$this->reset();
		$newResultSet->reset();
		
		while($this->next()) {
			$newResultSet->appendRow($this->rows[$this->pos]->fields, $this->rows[$this->pos]->id);
		}
		
		return $newResultSet;
	}	
	
	function addMissingRows(&$otherResultSet) {
		$otherResultSet->reset();
		$colCount = count($this->colNames);
		
		while($otherResultSet->next()) {
			$id=$otherResultSet->rows[$otherResultSet->pos]->id;
			$this->reset();
			while($this->next()) {
				if($this->rows[$this->pos]->id == $id) {
					continue 2;
				}
			}
			$this->append(false);
			$this->rows[$this->pos]->fields=create_array_fill($colCount,"");
			for($i=0;$i<count($otherResultSet->colNames);$i++) {
				$this->setCurrentValueByName($otherResultSet->colTables[$i] . "." . $otherResultSet->colNames[$i], $otherResultSet->getCurrentValueByNr($i));
			}
		}
	}
	
	/***********************************
			Row Order Functions
	************************************/
	// Order the rows in the ResultSet 
	// Parameters:
	// $orderCols an array of full column names to order
	// $orderTypes type of order for the column (ORDER_ASC or ORDER_DESC)
	// returns false on errors
	function orderRows($orderCols,$orderTypes) {
		
		// return if the ResultSet size is 0
		if(count($this->rows)<1)
			return;
		
		$colNrs=array();
		for($i=0;$i<count($orderCols);++$i) {
			if(($colNrs[$i]=$this->findColNrByFullName($orderCols[$i]))==NOT_FOUND) {
				print_error_msg("orderRows(): Column '" . $orderCols[$i] . "' not found");
				return false;
			}
		}
		
		$evalString="";
		$sortArray=array();
		for($i=0;$i<count($colNrs);++$i) {
			$currentCol=$colNrs[$i];
			foreach ($this->rows as $val) {
				if(ORDER_CASE_SENSITIVE)
					$sortArray[$i][] = $val->fields[$currentCol];
				else
					$sortArray[$i][] = strtolower($val->fields[$currentCol]);
			}
			if($orderTypes[$i] == ORDER_ASC)
				$evalString .= "\$sortArray[".$i."], SORT_ASC, ";
			else
				$evalString .= "\$sortArray[".$i."], SORT_DESC, ";
		}
		
		$evalString = "array_multisort(".$evalString."\$this->rows);";
		eval($evalString);
		return true;
	}



	/***********************************
		  'SQL Functions' Functions
	************************************/
	
	// Executes all functions in the ResultSet which have no grouping behavior.
	// Only function for columns where colFuncsExecuted is false are executed.
	function executeSingleRecFuncs() {
		global $g_sqlSingleRecFuncs;
		global $g_sqlMathOps;

		debug_printb("[executeSingleRecFuncs] executing singlerec functions...<br>");
		for($i=0;$i<count($this->colFuncs);++$i) {
			
			if(!$this->colFuncs[$i] || $this->colFuncsExecuted[$i])
				continue;
			
			if(!in_array($this->colFuncs[$i],$g_sqlSingleRecFuncs))
				continue;
					
			debug_print($this->colFuncs[$i] . "(" . $this->colNames[$i] . "): ");
			

			// EVAL
			if($this->colFuncs[$i]=="EVAL") {

				$eval_str=$this->colNames[$i];
				$out_str="";
				if(has_quotes($eval_str)) {
					remove_quotes($eval_str);
				}
				debug_print("EVAL function, eval String is $eval_str!<br>");
				$sp=new StringParser();
				$sp->specialElements=$g_sqlMathOps;
				$sp->setString($eval_str);
				while(!is_empty_str($elem=$sp->parseNextElement())) {
					debug_print("ELEM: $elem\n");
					if(is_numeric($elem) || in_array($elem,$g_sqlMathOps)) {
						$out_str.= ($elem. " ");
					} else {
						$origColNr=$this->findColNrByAttrs($elem, "", "");
						if($origColNr==NOT_FOUND) {
							print_error_msg("EVAL: Column '" . $elem . "' not found!");
							return false;
						}
						$out_str.="%$origColNr%";
					}
				}
				debug_print("New Eval String: $out_str\n");
				$val_str="";
				// apply function (use values from the original column as input)
				$rowCount=count($this->rows);
				$colCount=count($this->colNames);
				for($j=0;$j<$rowCount;++$j) {
					$val_str=$out_str;
					for($k=0;$k<$colCount;++$k) {
						if(!is_false(strpos($val_str,"%$k%"))) {
							$val_str=str_replace("%$k%",$this->rows[$j]->fields[$k],$val_str);
						}
					}
					debug_print("VAL_STR=$val_str\n");
					$this->rows[$j]->fields[$i]=execFunc($this->colFuncs[$i], $val_str);
				}
				$this->colFuncsExecuted[$i]=true;



			// function with paramater, but the parameter is not a column
			} else if($this->colNames[$i] && !is_empty_str($this->colNames[$i]) && (is_numeric($this->colNames[$i]) || has_quotes($this->colNames[$i]))) {
				$param=$this->colNames[$i];
				if(has_quotes($param))
					remove_quotes($param);
				$result=execFunc($this->colFuncs[$i],$param);
				$rowCount=count($this->rows);

				debug_print("a function with a non-column parameter! (result=$result)<br>");
				for($j=0;$j<$rowCount;++$j) {
					$this->rows[$j]->fields[$i]=$result;
				}
				$this->colFuncsExecuted[$i]=true;
			
			
			// function with parameter? =>execute function with the values form the original column
			} else if($this->colNames[$i]) {

				debug_print("a function with a column parameter!<br>");

				// find original column (without function)
				$origColNr=$this->findColNrByAttrs($this->colNames[$i], $this->colTables[$i], "");
				if($origColNr==NOT_FOUND) {
					print_error_msg("Column '" . $this->colNames[$i] . "' not found!");
					return false;
				}
				
				// copy some column header data from the original
				$this->colTables[$i]=$this->colTables[$origColNr];
				$this->colTableAliases[$i]=$this->colTableAliases[$origColNr];

				// apply function (use values from the original column as input)					 
				$rowCount=count($this->rows);
				for($j=0;$j<$rowCount;++$j) {
					$this->rows[$j]->fields[$i]=execFunc($this->colFuncs[$i], $this->rows[$j]->fields[$origColNr]);
				}
				$this->colFuncsExecuted[$i]=true;

			// function without parameter: just execute!
			} else {
				debug_print("a function with no parameters!<br>");
				$result=execFunc($this->colFuncs[$i],"");
				$rowCount=count($this->rows);
				for($j=0;$j<$rowCount;++$j) {
					$this->rows[$j]->fields[$i]=$result;
				}
				$this->colFuncsExecuted[$i]=true;
			}
		}
	}
	
	
	

	/***********************************
			Debug Functions
	************************************/

	// Dump's the ResultSet
	function dump() {
		$size=35;
		$format="%-" . $size . "s";
		$id_size=5;
		$id_format="%-" . $id_size ."s";
		
		
		echo "<pre><b><i>ResultSet dump (Row Count: " . $this->getRowCount() . ")</b></i><br>";
		echo "<br><b>";

		printf($id_format,"ID");		
		// Column Names
		reset($this->colNames);
		while (list ($key, $val) = each ($this->colNames))
			printf($format, "$val");			
		echo "</b><br>";
		
		printf($id_format,"");
		reset($this->colNames);
		while (list ($key, $val) = each ($this->colNames))  {
			printf($format, "(al=" .$this->colAliases[$key] . ", tbl=". $this->colTables[$key] . ", tba=" .$this->colTableAliases[$key] . ")");			
		}
		echo "<br>";
		
		printf($id_format,"");
		reset($this->colNames);
		while (list ($key, $val) = each ($this->colNames))  {
			printf($format, "(ty=". $this->colTypes[$key]  .", def=". $this->colDefaultValues[$key] .", fnc=". $this->colFuncs[$key] .", ex=". $this->colFuncsExecuted[$key] . ")");			
		}
		echo "<br>";

		printf("%'-" . $id_size . "s","|");
		
		for($i=0;$i<count($this->colNames);++$i)
			printf("%'-" . $size . "s","|");
		echo "<br><br>";
		
		$this->reset();
		
		if(!isset($this->rows))
			return;
		
		while($this->next()) {
			reset($this->rows[$this->pos]->fields);
			if(isset($this->rows[$this->pos]->id))
				printf($id_format,$this->rows[$this->pos]->id . ": ");
			while (list ($key, $val) = each ($this->rows[$this->pos]->fields)) 
				printf($format, "$val");			
			
			echo "<br>";
		}
		echo "</pre>";
		$this->reset();
	}
}


/**********************************************************************
							ResultSetParser
***********************************************************************/

// Used to parse a ResultSet object from and into text-files
class ResultSetParser {
	
	var $escapeCodeWrite;
	var $replaceWithWrite;
	
	var $escapeCodeRead;
	var $replaceWithRead; 
	
	
	/***********************************
			Line Parse Functions
	************************************/
	
	function ResultSetParser() {
		$this->escapeCodeRead=array(TABLE_FILE_ESCAPE_CHAR."h", 
									TABLE_FILE_ESCAPE_CHAR."n",
									TABLE_FILE_ESCAPE_CHAR."r", 
									TABLE_FILE_ESCAPE_CHAR."p");
		
		$this->replaceWithRead=array(COLUMN_SEPARATOR_CHAR, "\n", "\r", TABLE_FILE_ESCAPE_CHAR);
		
		$this->escapeCodeWrite=array_reverse($this->escapeCodeRead);
		$this->replaceWithWrite=array_reverse($this->replaceWithRead);

		
	}

	/***********************************
			Line Parse Functions
	************************************/
	
	function parseRowFromLine($line) {
		if(strlen(trim($line))==0)
			return false;
		
		// handle Windows \x0D\x0A (\r\n) newlines
		$line=rtrim($line);
		$row=explode(COLUMN_SEPARATOR_CHAR, $line);
				
		$row=str_replace($this->escapeCodeRead, $this->replaceWithRead, $row);
		
		return $row;
	}
	

	function parseLineFromRow($row) {
				
		$row=str_replace($this->replaceWithWrite, $this->escapeCodeWrite, $row);
		return implode(COLUMN_SEPARATOR_CHAR, $row);
			
	}



	/***********************************
			File Parse Functions
	************************************/
	
	// $fd must be a file descriptor (returned by fopen)
	function parseResultSetFromFile($fd) {
		
		$start=getmicrotime();
		
		$rs = new ResultSet();

		// read in the whole file
		fseek($fd,0,SEEK_END);
		$size=ftell($fd);
		fseek($fd,0,SEEK_SET);
		$wholeFile=fread($fd,$size);
				
		$lines=explode("\n",$wholeFile);
		unset($wholeFile); 
		$wholeFile="";
		
		$rec=$this->parseRowFromLine($lines[0]);
   		$rs->setColumnNames($rec);
   		
   		$rec=$this->parseRowFromLine($lines[1]);
   		$rs->setColumnTypes($rec);
   		
   		$rec=$this->parseRowFromLine($lines[2]);
   		$rs->setColumnDefaultValues($rec);
   		
   		$rs->reset();
   		
		$lineCount=count($lines);
  		for($i=3;$i<$lineCount;++$i) {
  			
  			//$rec=$this->parseRowFromLine($lines[$i]);		
  			//inlining function parseRowFromLine() for better performance
  			$line = $lines[$i];
            if(strlen(trim($line))==0)
                continue;
                    
            // handle Windows \x0D\x0A (\r\n) newlines
            $line=rtrim($line);
            $rec=explode(COLUMN_SEPARATOR_CHAR, $line);
            
            $rec=str_replace($this->escapeCodeRead, $this->replaceWithRead, $rec);
    
    		
			if(count($rec)==count($rs->colNames))
                $setDefaults = false;
            else                                                                      
                $setDefaults = true;  
        
        	if($rec) {
            	$rs->append($setDefaults);
            	$rs->rows[$rs->pos]->fields=$rec;
            	$rs->rows[$rs->pos]->id=-1;
  			}

  		}
  		debug_print("<i>II: parseResultSetFromFile: " . (getmicrotime() - $start) . " seconds elapsed</i><br>");

  		$rs->setColumnAliases(create_array_fill(count($rs->colNames),""));
  		$rs->setColumnTables(create_array_fill(count($rs->colNames),""));
  		$rs->setColumnTableAliases(create_array_fill(count($rs->colNames),""));
  		$rs->setColumnFunctions(create_array_fill(count($rs->colNames),""));
  		$rs->colFuncsExecuted=create_array_fill(count($rs->colNames),false);
	
		return $rs;	
	}
	
	
	
	// $fd must be a file descriptor (returned by fopen)
	function parseResultSetIntoFile($fd, &$resultSet) {
    
    	debug_print( "parseResultSetIntoFileFD<br>");

		// now set file pointer at the beginning
		fseek($fd,0,SEEK_SET);

		$fwriteFails = 0;
		if(!fwrite($fd, $this->parseLineFromRow($resultSet->getColumnNames())."\n"))
			$fwriteFails = 1;
		
		if(!fwrite($fd, $this->parseLineFromRow($resultSet->getColumnTypes())."\n"))
			$fwriteFails = 1;
		
		if(!fwrite($fd, $this->parseLineFromRow($resultSet->getColumnDefaultValues())."\n"))
			$fwriteFails = 1;
		
		$resultSet->reset();
		while($resultSet->next()) {
			if(!fwrite($fd, $this->parseLineFromRow($resultSet->getCurrentValues())))
				$fwriteFails = 1;
			
			if($resultSet->getPos()<$resultSet->getRowCount()-1)
				if(!fwrite($fd, "\n"))
					$fwriteFails = 1;
		}
		
		if (!$fwriteFails)
			ftruncate($fd, ftell($fd));
	}
	
	
	// $fd must be a file descriptor (returned by fopen)
	// Parses only the column names, data types, default values and
	// some of the last rows so the ResultSet can be used to append records.
	function parseResultSetFromFileForAppend($fd) {
		
		$start=getmicrotime();
		$rs=new ResultSet();
		
		
		// COLUMN NAMES
		
		// read with a maximum of 1000 bytes, until there is a newline included (or eof)
		$buf="";
		while(is_false(strstr($buf,"\n"))) {
		    $buf.=fgets($fd,1000);
		    if(feof($fd)) {
		        print_error_msg("Invalid Table File!<br>");
		        return null;
		    }
		}
		// remove newline
		remove_last_char($buf);
		
		$rec=$this->parseRowFromLine($buf);
   		$rs->setColumnNames($rec);
   		
   		
   		
   		// COLUMN TYPES
   		
   		// read with a maximum of 1000 bytes, until there is a newline included (or eof)
   		$buf="";
		while(is_false(strstr($buf,"\n"))) {
		    $buf.=fgets($fd,1000);
		    if(feof($fd)) {
				print_error_msg("Invalid Table File!<br>");
		        return null;
		    }
		}
		
		// remove newline
		remove_last_char($buf);
			
		$rec=$this->parseRowFromLine($buf);
   		$rs->setColumnTypes($rec);
   		
   		
   		// COLUMN DEFAULT VALUES
   		
   		// read with a maximum of 1000 bytes, until there is a newline included (or eof)
   		$buf="";
		while(is_false(strstr($buf,"\n"))) {
		    $buf.=fgets($fd,1000);
		    if(feof($fd)) {
		        break; // there's no newline after the colum types => empty table
		    }
		}
		
		// remove newline
		if(last_char($buf)=="\n")
			remove_last_char($buf);
			
			
		$rec=$this->parseRowFromLine($buf);
   		$rs->setColumnDefaultValues($rec);
   		
   		
   		// get file size		
		fseek($fd,0,SEEK_END);
		$size=ftell($fd);
		$lastRecSize=min($size,ASSUMED_RECORD_SIZE);
		
		$lastRecPos=false;
		while(is_false($lastRecPos)) {
		    fseek($fd,-$lastRecSize,SEEK_END);
		    $buf=fread($fd,$lastRecSize);
		    $lastRecSize=$lastRecSize*2;
		    $lastRecSize=min($size,$lastRecSize);
			if($lastRecSize<1) {
				print_error_message("lastRecSize should not be 0! Contact developer please!");
			}
		    $lastRecPos=$this->getLastRecordPosInString($buf);
		    if(TXTDBAPI_VERBOSE_DEBUG) {
		        echo "<hr>pass! <br>";
		        echo "lastRecPos: " . $lastRecPos . "<br>";
		        echo "buf: " . $buf . "<br>";
            }
		    
		    
		}		
		
		$buf=trim(substr($buf,$lastRecPos));
		
		verbose_debug_print("buf after substr() and trim(): " . $buf . "<br>");
		   		
   		$rs->reset();
   		$row=$this->parseRowFromLine($buf);
   		
   		if(TXTDBAPI_VERBOSE_DEBUG) {
   		    echo "parseResultSetFromFileForAppend(): last Row:<br>";
   		    print_r($row);
   		    echo "<br>";
        }
        
   		
   		$rs->appendRow($row);	
   		
   		$rs->setColumnAliases(create_array_fill(count($rs->colNames),""));
  		$rs->setColumnTables(create_array_fill(count($rs->colNames),""));
  		$rs->setColumnTableAliases(create_array_fill(count($rs->colNames),""));
  		$rs->setColumnFunctions(create_array_fill(count($rs->colNames),""));
  		$rs->colFuncsExecuted=create_array_fill(count($rs->colNames),false);
   	
   		debug_print("<i>III: parseResultSetFromFileForAppend: " . (getmicrotime() - $start) . " seconds elapsed</i><br>");
   		
  		return $rs;	
	}
	
	
	// $fd must be a file descriptor (returned by fopen)
	function parseResultSetIntoFileAppend($fd, &$resultSet) {

    	fwrite($fd, "\n");
		$resultSet->reset();
		while($resultSet->next()) {
			fwrite($fd, $this->parseLineFromRow($resultSet->getCurrentValues()));
			
			if($resultSet->getPos()<$resultSet->getRowCount()-1)
				fwrite($fd, "\n");
		}		
	}
	
	// Returns an offset into $str where the last record begins.
	// If $str doesn't contain one valid record false is returned.
	// (Attention: may also return 0, which has not the same meaning as
	// false)
	function getLastRecordPosInString($str) {
	   
	    // contains other chars then whitespaces ?
	    if(strlen(trim($str))==0)
            return false;
        
        $pos=strlen($str)-1;
        
        while($str{$pos}=="\n" || $str{$pos}=="\r" || $str{$pos}=="\t" || $str{$pos}==" ") {
        	--$pos;
        	if($pos==-1)
        		return false;
        }
        while($str{$pos}!="\n" && $str{$pos}!="\r") {
        	--$pos;
        	if($pos==-1)
        		return false;
        }
        return $pos+1;
    }
	
}	

	
?>
