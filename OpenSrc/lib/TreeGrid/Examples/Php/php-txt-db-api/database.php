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
include_once(API_HOME_DIR . "resultset.php");
include_once(API_HOME_DIR . "sql.php");
include_once(API_HOME_DIR . "expression.php");

/**********************************************************************
							Database
***********************************************************************/

// Represents a Database and has functions to execute Sql-Queries on it
class TxtDatabase  {
    var $dbFolder;
    var $lastInsertId=0;
    
    var $lastErrorMsgs=array();
       
   	/***********************************
		 		Constructor
	************************************/
	
    function TxtDatabase($dbFolder="defaultDb/") {    	    	
    	$this->dbFolder= DB_DIR . $dbFolder;
    	if(last_char($this->dbFolder) != "/")
    		$this->dbFolder .= "/";
    }
    
   
    /***********************************
		 	Insert Id Functions
	************************************/
	function updateLastInsertId($resultSet) { 
		$resultSet->end();
		for($i=0;$i<count($resultSet->colTypes);++$i) { 
			if($resultSet->colTypes[$i]==COL_TYPE_INC) { 
				$this->lastInsertId=$resultSet->getCurrentValueByNr($i); 
				debug_print("Setting lastInsertId to " . $this->lastInsertId );
				return; 
			} 
		} 
       // if no inc column exists set lastInsertId to 0 
       $this->lastInsertId=0; 
       debug_print("Setting lastInsertId to " . $this->lastInsertId );
    } 
    
	function getLastInsertId() {
		return $this->lastInsertId;
	}	
	
	/***********************************
		 Table open/close Functions
	************************************/
	
	// Does open a Table for writing
	function openTableWrite($tableName) {
		debug_print("openTableWrite<br>");
		$filename=$this->dbFolder . $tableName . TABLE_FILE_EXT;
		
		$fp=fopen ($filename, "r+".TABLE_FILE_OPEN_MODE);
		if (!$fp) return 0;
		
		while(!flock($fp, LOCK_EX)) {
			usleep(50);
		}

		return $fp;
	}
	
	// same rules as for openTableWrite()
	// does open a table for appending
	function openTableAppend($tableName) {
		debug_print("openTableAppend<br>");
		$filename=$this->dbFolder . $tableName . TABLE_FILE_EXT;

		$fp=fopen ($filename, "a".TABLE_FILE_OPEN_MODE);
		if (!$fp) return 0;
		
		while(!flock($fp, LOCK_EX)) {
			usleep(50);
		}

		return $fp;
	}
		
	// Opens a Table for reading
	// This function is used by SELECT
	// returns a FilePointer or false
	function openTableRead($tableName) {
		debug_print("openTableRead<br>");
		$filename=$this->dbFolder . $tableName . TABLE_FILE_EXT;
    	debug_print("Table $tableName opened (READ)<br>");

		if(!file_exists($filename)) return 0;

		$fp=fopen ($filename, "r".TABLE_FILE_OPEN_MODE);
		if (!$fp) return 0;
		
		while(!flock($fp, LOCK_SH)) {
			usleep(50);
		}

		return $fp;
	}
	
	// Closes a Table 
	function closeTable($fp) {
		debug_print("Table $fp closed<br>");
		while(!flock($fp, LOCK_UN)) {
			usleep(50);
		}
		return fclose($fp);		
	}
	
	
	/***********************************
		 Table read/write Functions
	************************************/
	
	// Reads a Table into a ResultSet
	// Returns a ResultSet or null (the function opens an closes the file itself)
    function readTable($tableName) {
    	debug_print("readTable<br>");
      	$parser= new ResultSetParser();
      	if(!($fd=$this->openTableRead($tableName))) {
      		print_error_msg("readTable(): Cannot open Table $tableName");
      		return null;
    	}
    	$rs=$parser->parseResultSetFromFile($fd);
    	$this->closeTable($fd);
    	return $rs;
    }
        
    // Reads a Table into a ResultSet
    // But only the column names and types + the last record
    // thats usefull for appending record
    function readTableForAppend($tableName) {
    	debug_print("readTableForAppend<br>");
      	$parser= new ResultSetParser();
      	if(!($fd=$this->openTableRead($tableName))) {
      		print_error_msg("readTableForAppend(): Cannot open Table $tableName");
      		return null;
    	}
    	$rs=$parser->parseResultSetFromFileForAppend($fd);
    	$this->closeTable($fd);
    	return $rs;
    }


    // writes the table by using the FilePointer $fd 
    // $fd has to be opened an closed by the caller
    function writeTable($fd, $resultSet) {
    	debug_print("writeTable<br>");
    	$parser= new ResultSetParser();
    	return $parser->parseResultSetIntoFile($fd, $resultSet);
    }
    
    // appends to the table by using the FilePointer $fd 
    // $fd has to be opened an closed by the caller
    function appendToTable($fd, $resultSet,$recordCount) {
    	debug_print("appendToTable<br>");
    	$parser= new ResultSetParser();
    	while($resultSet->getRowCount()>$recordCount) {
    		$resultSet->reset();
    		$resultSet->next();
    		$resultSet->deleteCurrentRow();
    	}
    	return $parser->parseResultSetIntoFileAppend($fd, $resultSet);
    }
    
    
    
	
	/***********************************
		 	Query dispatcher
	************************************/
	
	// $sql_query_str is an unparsed SQL Query String
	// Return Values:
	// SELECT Queries: Returns a ResultSet Object or false
	// CREATE TABLE: Returns true or false
	// All other types: Returns the number of rows affected
	function executeQuery($sql_query_str) {
		set_error_handler("txtdbapi_error_handler");
		txtdbapi_clear_errors();
		
		debug_printb("[executeQuery] Query: $sql_query_str<br>");
		
		// Parse Query
		$start=getmicrotime();
		$sqlParser=new SqlParser($sql_query_str);
	   	$sqlQuery=$sqlParser->parseSqlQuery();
	   	debug_print("parseSqlQuery: " . (getmicrotime() - $start) . " seconds elapsed<br>");



	   	// free $sqlParser
	   	unset($sqlParser);
	   	$sqlParser="";
	   	
	   	// Test Query
	   	if((!$sqlQuery) || (!$sqlQuery->test())) {
	   	    restore_error_handler();
			return false;
		}
		
		$start=getmicrotime();
	
		debug_printb("[executeQuery] Parsed Query:<br>");
		if(TXTDBAPI_DEBUG) {
			$sqlQuery->dump();
		}


		// Dispatch
		switch($sqlQuery->type) {
			case "SELECT":
				$rc=$this->executeSelectQuery($sqlQuery);
				break;
			case "INSERT":
				$rc=$this->executeInsertQuery($sqlQuery);
				break;
			case "DELETE":
				$rc=$this->executeDeleteQuery($sqlQuery);
				break;
			case "UPDATE":
				$rc=$this->executeUpdateQuery($sqlQuery);
				break;
			case "CREATE TABLE":
				$rc=$this->executeCreateTableQuery($sqlQuery);
				break;
			case "DROP TABLE":
				$rc=$this->executeDropTableQuery($sqlQuery);
				break;
			case "CREATE DATABASE":
				$rc=$this->executeCreateDatabaseQuery($sqlQuery);
				break;
			case "DROP DATABASE":
				$rc=$this->executeDropDatabaseQuery($sqlQuery);
				break;
			case "LIST TABLES":
				$rc=$this->executeListTablesQuery($sqlQuery);
				break;
			default:
				print_error_msg("Invalid or unsupported Query Type: " . $sqlQuery->type);
				restore_error_handler();
				return false;
		}
		
		if(is_false($rc)) {
			print_error_msg("Query '" . $sql_query_str . "' failed");
		}
		
		debug_printb("[executeQuery] Query execution done: " . (getmicrotime() - $start) . " seconds elapsed<br>");
        restore_error_handler();		
        return $rc;
	}
	
	
	/***********************************
		 	Delete Query
	************************************/
	
	function executeDeleteQuery(&$sqlQuery) {
		
		// Read Table
		$rs=$this->readTable($sqlQuery->tables[0]);
		if(!$rs) {
			print_error_msg("Reading the Table " . $sqlQuery->tables[0] . " failed");
			return false;
		}
		
		$rowsAffected=0;
		
		if(!$sqlQuery->where_expr || $sqlQuery->where_expr=="") {
			$rowsAffected=$rs->getRowCount();
			$rs->deleteAllRows();
		} else {
			// set row ids
			$rId=-1;
			$rs->reset();
			while($rs->next()) 
				$rs->setCurrentRowId(++$rId);
			$rs->reset();
			
			// calc current column count
			$colCount=count($rs->colNames);
			
			// generate additional columns from the WHERE-expression
			$rs->generateAdditionalColumnsFromWhereExpr($sqlQuery->where_expr);
		
			// execute the new single-rec functions
			$rs->executeSingleRecFuncs();
			
			// apply WHERE Expression
			$ep=new ExpressionParser();
			$et=$ep->getExpressionTree($sqlQuery->where_expr);
			$rsFiltered=$et->getFilteredResultSet($rs);
			
			if(!$rsFiltered)
				return 0;			
			
			// Delete rows..
			$rsFiltered->reset();
			while($rsFiltered->next()) {
				$rowId=$rsFiltered->getCurrentRowId();
				$rs->deleteRow($rs->searchRowById($rowId));
			}
			
			$rowsAffected=$rsFiltered->getRowCount();
			
			// Remove columns added from WHERE Expression
			while(count($rs->colNames)>$colCount) {
				$rs->removeColumn(count($rs->colNames)-1);
			}
		} 	
		
		// Open Table
		$fp=$this->openTableWrite($sqlQuery->tables[0]);
		if(!$fp) {
			print_error_msg("Open the Table " . $sqlQuery->tables[0] . " (for WRITE) failed");
			return false;
		}
		
		// Write Table
		$this->writeTable($fp,$rs);
		$this->closeTable($fp);
		return $rowsAffected;
	}


	
	/***********************************
		 	Insert Query
	************************************/
	// returns the affected Row count or false
	function executeInsertQuery(&$sqlQuery) {
		
		// Read Table
		$rs=$this->readTableForAppend($sqlQuery->tables[0]);
		
		if(TXTDBAPI_VERBOSE_DEBUG) {
		    echo "executeInsertQuery(): Last Record read for appending:<br>";
		    $rs->dump();
		    echo "<br>";
		}
		
		if(!$rs) {
			print_error_msg("Reading the Table " . $sqlQuery->tables[0] . " failed");
			return false;
		}
		
		// Open Table
		$fp=$this->openTableAppend($sqlQuery->tables[0]);
		if(!$fp) {
			print_error_msg("Open the Table " . $sqlQuery->tables[0] . " (for APPEND) failed");
			return false;
		}
		
		// a INSERT INTO table () VALUES () query: just write the default values
		if(count($sqlQuery->colNames)==0 && count($sqlQuery->fieldValues)==0) {
				$rs->append();
				$this->updateLastInsertId($rs);
				$this->appendToTable($fp,$rs,1);
				$this->closeTable($fp);
				return 1; // Error Handling ??
		}
				
		// execute functions on the values
		$colName="";
		$colTable="";
		$colFunc="";
		
		for($i=0;$i<count($sqlQuery->fieldValues);++$i) {
			split_full_colname($sqlQuery->fieldValues[$i],$colName,$colTable,$colFunc);
			if($colFunc) {
				if($colName && has_quotes($colName))  {
					remove_quotes($colName);
				}
				$sqlQuery->fieldValues[$i]=execFunc($colFunc, $colName);
			} else {
			    if(has_quotes($sqlQuery->fieldValues[$i])) {
			        remove_quotes($sqlQuery->fieldValues[$i]);
			    }
			}
		}
				
		$rc=true;
		switch(count($sqlQuery->colNames)) {
			case 0:
				$rs->appendRow($sqlQuery->fieldValues);
				$this->updateLastInsertId($rs);
				$this->appendToTable($fp,$rs,1);
				$this->closeTable($fp);
				return $rc;
				break;
			default:
				$rs->append();
				for($i=0;$i<count($sqlQuery->colNames);++$i) {
					if(!$rs->setCurrentValueByName($sqlQuery->colNames[$i],$sqlQuery->fieldValues[$i])) {
						$rc=false;
						break;
					}
				}
				if($rc) {
					$this->updateLastInsertId($rs);
					$this->appendToTable($fp,$rs,1);
				}
				$this->closeTable($fp);
				return $rc;
				break;
		}
	}
	
	
	/***********************************
		 	Update Query
	************************************/
	
	// returns the affected Row count or false
    function executeUpdateQuery(&$sqlQuery) {

		
		// Read Table
		$rs=$this->readTable($sqlQuery->tables[0]);
		if(!$rs) {
			print_error_msg("Reading the Table " . $sqlQuery->tables[0] . " failed");
			return false;
		}
		
		// calc original column count
		$colCount=count($rs->colNames);

		$rs->generateAdditionalColumnsFromArray($sqlQuery->fieldValues);

		if(txtdbapi_error_occurred())
			return false;

		$rs->executeSingleRecFuncs();

		// check if there are wrong functions
		for($i=0;$i<count($rs->colFuncs);++$i) {
			if($rs->colFuncs[$i] && !$rs->colFuncsExecuted[$i]) {
				print_error_msg("Function '" . $rs->colFuncs[$i]  . "' not supported in UPDATE statements");
				return false;
			}
		}
		
		
		if(TXTDBAPI_DEBUG) {
			debug_printb("[executeUpdateQuery] ResultSet dump after generating columns:<br>");
			$rs->dump();
		}
		
		// No where_expr ? update all
		if( (!isset($sqlQuery->where_expr)) || (!$sqlQuery->where_expr) ) {
			// update 
			$rs->reset();
			while($rs->next()) {
				for($i=0;$i<count($sqlQuery->colNames);++$i) {
					$rc=$rs->setCurrentValueByName($sqlQuery->colNames[$i],
						$rs->getCurrentValueByName($sqlQuery->fieldValues[$i]));
					if(!$rc)  {
						return false;
					}
				}
			}
			
			// Remove columns added from WHERE Expression
			while(count($rs->colNames)>$colCount) {
				$rs->removeColumn(count($rs->colNames)-1);
			}
			
			// Open Table
			$fp=$this->openTableWrite($sqlQuery->tables[0]);
			if(!$fp) {
				print_error_msg("Open the Table " . $sqlQuery->tables[0] . " (for WRITE) failed");
				return false;
			}
			// Write Table
			$this->writeTable($fp,$rs);
			$this->closeTable($fp);
			return $rs->getRowCount();

		} else {
			// set row id's
			$rs->reset();
			$rId=-1;
			while($rs->next())
				$rs->setCurrentRowId(++$rId);
			
			
			
			// generate additional columns from the WHERE-expression
			$rs->generateAdditionalColumnsFromWhereExpr($sqlQuery->where_expr);
		
			// execute the new single-rec functions
			$rs->executeSingleRecFuncs();
			
			// create a copy 
			$rsFiltered=$rs;

			// filter by where expression
			$ep=new ExpressionParser();
			$et=$ep->getExpressionTree($sqlQuery->where_expr);
			$rsFiltered=$et->getFilteredResultSet($rsFiltered);
			
			if($rsFiltered->getRowCount()<1)
				return 0;
				
			// update 
			$rsFiltered->reset();
			while($rsFiltered->next()) {
				for($i=0;$i<count($sqlQuery->colNames);++$i) {
					$rc=$rsFiltered->setCurrentValueByName($sqlQuery->colNames[$i],
						$rsFiltered->getCurrentValueByName($sqlQuery->fieldValues[$i]));
					if(!$rc)  {
						return false;
					}
					
				}
			}
						
			// put filtered part back in the original ResultSet
			$rowNr=0;
			$putBack=0;
			$rs->reset();
			$rsFiltered->reset();
			while($rs->next()) {
				if(($rowNr=$rsFiltered->searchRowById($rs->getCurrentRowId())) !=NOT_FOUND) {
					$rs->setCurrentValues($rsFiltered->getValues($rowNr));
					$putBack++;
				}
			}
			if($putBack<$rsFiltered->getRowCount()) {
				print_error_msg("UPDATE: Could not put Back all filtered Values");
				return false;
			}
			
			
			// Remove columns added from WHERE Expression
			while(count($rs->colNames)>$colCount) {
				$rs->removeColumn(count($rs->colNames)-1);
			}
			
			// Open Table
			$fp=$this->openTableWrite($sqlQuery->tables[0]);
			if(!$fp) {
				print_error_msg("Open the Table " . $sqlQuery->tables[0] . " (for WRITE) failed");
				return false;
			}
			$this->writeTable($fp,$rs);
			$this->closeTable($fp);
			return $rsFiltered->getRowCount();
		}
	}
	
	
	/***********************************
		 	Create Table Query
	************************************/
	
	// executes a SQL CREATE TABLE Statement
	// param: SqlQuery Object
	// returns True or False
	function executeCreateTableQuery(&$sqlQuery) {
		clearstatcache();
		$filename=$this->dbFolder . $sqlQuery->tables[0] . TABLE_FILE_EXT;
		
		// checks
		if(!$sqlQuery->tables[0]) {
			print_error_msg("Invalid Table " . $sqlQuery->tables[0]);
			return false;
		}
		if(file_exists($filename)) {
			print_error_msg("Table " . $sqlQuery->tables[0] . " allready exists");
			return false;
		}
		if(count($sqlQuery->colNames)!=count($sqlQuery->colTypes)) {
			print_error_msg("There's not a type defined for each column");
			return false;
		}
		for($i=0;$i<count($sqlQuery->colTypes);++$i) {
			$tmp= ($sqlQuery->colTypes[$i]=strtolower($sqlQuery->colTypes[$i]));
			if( !($tmp == COL_TYPE_INT || $tmp == COL_TYPE_STRING || $tmp==COL_TYPE_INC)) {
				print_error_msg("Column Type " . $tmp . " not supported");
				return false;
			}
		}
			
		
		// write file	
		$fp=fopen ($filename, "w".TABLE_FILE_OPEN_MODE);
		
		$rsParser=new ResultSetParser();
		
		fwrite($fp, $rsParser->parseLineFromRow($sqlQuery->colNames));
		fwrite($fp, "\n");
		fwrite($fp, $rsParser->parseLineFromRow($sqlQuery->colTypes));
		fwrite($fp, "\n");
		fwrite($fp, $rsParser->parseLineFromRow($sqlQuery->fieldValues));
				
		fclose($fp);
		chmod($filename,0777);
		return true;	
	}
	
	/***********************************
		 	Drop Table Query
	************************************/
	
	// executes a SQL DROP TABLE Statement 
	// param: SqlQuery Object
	// returns True or False
	function executeDropTableQuery(&$sqlQuery) {
		clearstatcache();
		if(!isset($sqlQuery->colNames[0]))
			return false;
		
		for($i=0;$i<count($sqlQuery->colNames);++$i) {
			$rc=unlink($this->dbFolder. $sqlQuery->colNames[$i]  . TABLE_FILE_EXT);
			if(!$rc) {
				print_error_msg("DROP TABLE " . $sqlQuery->colNames[$i] . " failed");
				return false;
			}
		}
		return true;	
	}
	
	
	/***********************************
		 	List Tables Query
	************************************/
	
	// executes a LIST TABLES Statement 
	// param: SqlQuery Object
	// returns: A ResultSet Object with a single column "table"
	function executeListTablesQuery(&$sqlQuery) {
		$rs=new ResultSet();
		$rs->colNames=array("table");
		$rs->colAliases=array("");
		$rs->colTables=array("");
		$rs->colTableAliases=array("");
		$rs->colTypes=array(COL_TYPE_STRING);
		$rs->colDefaultValues=array("");
		$rs->colFuncs=array("");
		$rs->colFuncsExecuted=array(false);
		
		
		$handle=opendir ($this->dbFolder);
		
		
		$rs->reset();
		while ($file = readdir ($handle)) { 
    		if ($file != "." && $file != ".." && is_file($this->dbFolder . $file)) { 
        		$rs->appendRow(array(substr($file,0,strlen($file)-strlen(TABLE_FILE_EXT))));
    		} 
		}
		
		// apply WHERE Statement
		if($sqlQuery->where_expr) {
			$ep=new ExpressionParser();
			$et=$ep->getExpressionTree($sqlQuery->where_expr);
			$rs=$et->getFilteredResultSet($rs);
		} 
			
		// Order ResultSet
		if(count($sqlQuery->orderColumns)>0) {
			$rs->orderRows($sqlQuery->orderColumns,$sqlQuery->orderTypes);
		}

		// Group ResultSet (process GROUP BY)
		if(count($sqlQuery->groupColumns)>0) {
			$rs = $rs->groupRows($sqlQuery->groupColumns, $sqlQuery->limit);
		}

		// Apply Limit		
		$rs->reset();
		$rs = $rs->limitResultSet($sqlQuery->limit);
		
		
		closedir($handle); 
		$rs->reset();
		return $rs;
	}
	
	
	/***********************************
		 	Create Database Query
	************************************/
	
	// executes a SQL CREATE DATABASE Statement 
	// param: SqlQuery Object
	// returns True or False
	function executeCreateDatabaseQuery(&$sqlQuery) {
		clearstatcache();
		if($this->dbFolder!=DB_DIR .ROOT_DATABASE && $this->dbFolder!=DB_DIR .ROOT_DATABASE . "/") {
			print_error_msg("Databases can only be created with a ROOT_DATABASE instance!");
			return false;
		}
		if(!isset($sqlQuery->colNames[0]))
			return false;
			
		$directory=$this->dbFolder . $sqlQuery->colNames[0];
		$rc=mkdir ($directory , 0777);
		if(!$rc) {
			print_error_msg("Cannot create Database " . $sqlQuery->colNames[0]);
			return false;
		}
		return true;
	}
	
	/***********************************
		 	Drop Database Query
	************************************/
	
	// executes a SQL DROP DATABASE Statement 
	// param: SqlQuery Object
	// returns True or False
	function executeDropDatabaseQuery(&$sqlQuery) {
		clearstatcache();
		if($this->dbFolder!=DB_DIR .ROOT_DATABASE && $this->dbFolder!=DB_DIR .ROOT_DATABASE . "/") {
			print_error_msg("Databases can only be deleted with a ROOT_DATABASE instance!");
			return false;
		}
		if(!isset($sqlQuery->colNames[0]))
			return false;
		$directory=$this->dbFolder . $sqlQuery->colNames[0];
		
		// delete all tables
		$dirHandle=opendir($directory); 
			while ($file = readdir ($dirHandle)) { 
    			if ($file != "." && $file != ".." && is_file($directory . "/" . $file)) { 
        		if(!($rc=unlink($directory . "/" . $file))) {
					print_error_msg("Cannot drop Database: Deleting the table $file failed");
        		}
        		debug_print($file . "<br>");
    		} 
		}
		closedir($dirHandle); 

		
		$rc=rmdir ($directory);
		if(!$rc) {
			print_error_msg("Cannot drop Database " . $sqlQuery->colNames[0]);
			return false;
		}
		return true;	
	}
	
	
	/***********************************
		 	Select Query
	************************************/
	
	// executes a SQL SELECT STATEMENT and returns a ResultSet 
	// param: SqlQuery Object
	function executeSelectQuery(&$sqlQuery) {

		global $g_sqlGroupingFuncs;
		global $g_sqlSingleRecFuncs;



		$resultSets=array();		
		
		// create a copy
		$aliases=$sqlQuery->colAliases;
		$funcs=$sqlQuery->colFuncs;
			
			
		// Read all Tables
		for($i=0;$i<count($sqlQuery->tables);++$i) {
			debug_printb ("<br>[executeSelectQuery] Reading table " . $sqlQuery->tables[$i] ."<br>"); 
			if(!($resultSets[$i]=$this->readTable($sqlQuery->tables[$i]))) {
				print_error_msg("Reading Table " . $sqlQuery->tables[$i]. " failed");
				return false;
			}
			$resultSets[$i]->setColumnTableForAll($sqlQuery->tables[$i]);
			$resultSets[$i]->setColumnTableAliasForAll($sqlQuery->tableAliases[$i]);
			
			// set all functions to the ResultSet of the current table
			// if table and column name matches
			debug_printb("[executeSelectQuery] Setting functions for the current table:<br>");
			for($j=0;$j<count($funcs);++$j) {
				if(!$funcs[$j] || !$sqlQuery->colNames[$j])
					continue;
								
				if($sqlQuery->colTables[$j]==$sqlQuery->tables[$i] ||
				   (strlen($sqlQuery->tableAliases[$i]) > 0 && ($sqlQuery->colTables[$j]==$sqlQuery->tableAliases[$i]))) {
					$colNr=$resultSets[$i]->findColNrByAttrs($sqlQuery->colNames[$j],$sqlQuery->colTables[$j],"");
					
					if($colNr==NOT_FOUND) {
						continue;
					}					
					
					// create a new column for each function
					$resultSets[$i]->addColumn($sqlQuery->colNames[$j],$sqlQuery->colAliases[$j],$sqlQuery->colTables[$j],"","str","",$funcs[$j],"",true);
					$funcs[$j]="";
				}
				
			}
			
			// set all aliases where table, column name and function matches
			debug_printb("[executeSelectQuery] Setting aliases for the current table:<br>");
			for($j=0;$j<count($aliases);++$j) {
				if(!$aliases[$j])
					continue;
				
				if($sqlQuery->colTables[$j]==$sqlQuery->tables[$i] ||
				   $sqlQuery->colTables[$j]==$sqlQuery->tableAliases[$i]) {	
					if(($colNr=$resultSets[$i]->findColNrByAttrs($sqlQuery->colNames[$j],$sqlQuery->colTables[$j],$sqlQuery->colFuncs[$j])) != NOT_FOUND) {
						$resultSets[$i]->setColumnAlias($colNr,$aliases[$j]);
						$aliases[$j]="";				
					}
				}
			}
			
			if(TXTDBAPI_DEBUG) {
				debug_printb("<br>[executeSelectQuery] Dump of Table $i (" . $sqlQuery->tables[$i] . "):<br>");
				$resultSets[$i]->dump();
			}
		}
		

		
		
		// set remaining functions to the ResultSet where column name matches
		debug_printb("[executeSelectQuery] Setting remaining functions where column name matches:<br>");
		for($i=0;$i<count($resultSets);++$i) {
			for($j=0;$j<count($funcs);++$j) {
				if(!$funcs[$j] || !$sqlQuery->colNames[$j])
					continue;
								
				$colNr=$resultSets[$i]->findColNrByAttrs($sqlQuery->colNames[$j],"","");
				if($colNr==NOT_FOUND) {
					// 'text' or 123 ? => add column
					if(! (is_numeric($sqlQuery->colNames[$j]) || has_quotes($sqlQuery->colNames[$j]))) {
						continue;
					}
					debug_print("Adding function with quoted string or number paremeter!<br>");
				}
					
				// create a new column for each function
				$resultSets[$i]->addColumn($sqlQuery->colNames[$j],$sqlQuery->colAliases[$j],$sqlQuery->colTables[$j],"","str","",$funcs[$j],"",true);
				$funcs[$j]="";

			}
		}
		
		// set remaining aliases where column name and function matches
		debug_printb("[executeSelectQuery] Setting remaining aliases where column name and function matches:<br>");
		for($i=0;$i<count($resultSets);++$i) {
			for($j=0;$j<count($aliases);++$j) {
				if(!$aliases[$j])
					continue;
				if(($colNr=$resultSets[$i]->findColNrByAttrs($sqlQuery->colNames[$j],"",$sqlQuery->colFuncs[$j])) !=NOT_FOUND) {
					$resultSets[$i]->setColumnAlias($colNr,$aliases[$j]);
					$aliases[$j]="";
				}
			}
		}


		debug_printb("[executeSelectQuery] Executing single-rec functions (on the separate ResultSet's):<br>");
		// execute single-rec functions (on the separate ResultSet's)
		for($i=0;$i<count($resultSets);++$i) {
			$resultSets[$i]->executeSingleRecFuncs();
		}
		
		
		// A query without tables ? => make a dummy ResultSet
		$dummyResultSet=false;
		if(count($sqlQuery->tables)==0) {
			$dummyResultSet=true;
			$rsMaster=new ResultSet();	
			$rsMaster->addColumn("(dummy)", "(dummy)", "(dummy)", "(dummy)", "str", "(dummy)", "", "", true);
			$rsMaster->append();
		
		// else: real ResultSet
		} else {
			$dummyResultSet=false;
			
			
			
			/////
			// Perform JOIN's
			foreach($sqlQuery->joins as $join) {
				if(!isset($rsMaster)) {
					$rsMaster=$resultSets[$join->leftTableIndex];
					$resultSets[$join->leftTableIndex]=0;
				}
				
				// INNER => Nothing special
				if($join->type == JOIN_INNER) {
					$rsMaster=$rsMaster->joinWithResultSet($resultSets[$join->rightTableIndex]);
					$ep=new ExpressionParser();
					$et=$ep->getExpressionTree($join->expr);
					$rsMaster=$et->getFilteredResultSet($rsMaster);
					$resultSets[$join->rightTableIndex]=0;
					
				// LEFT OUTER JOIN => keep all of the left
				} else if($join->type == JOIN_LEFT) {
					// generate new row id's for the left
					$rsMaster->generateRowIds();
					// copy the left
					$copy=$rsMaster->copy();
					$rsMaster=$rsMaster->joinWithResultSet($resultSets[$join->rightTableIndex],0);
					$ep=new ExpressionParser();
					$et=$ep->getExpressionTree($join->expr);
					$rsMaster=$et->getFilteredResultSet($rsMaster);
					$resultSets[$join->rightTableIndex]=0;
					// add back missing
					$rsMaster->addMissingRows($copy);
					
					
				// RIGHT OUTER JOIN => keep all of the right
				} else if($join->type == JOIN_RIGHT) {
					// generate new row id's for the right
					$resultSets[$join->rightTableIndex]->generateRowIds();
					// copy the right
					$copy=$resultSets[$join->rightTableIndex]->copy();
					$rsMaster=$rsMaster->joinWithResultSet($resultSets[$join->rightTableIndex],1);
					$ep=new ExpressionParser();
					$et=$ep->getExpressionTree($join->expr);
					$rsMaster=$et->getFilteredResultSet($rsMaster);
					$resultSets[$join->rightTableIndex]=0;				
					// add back missing
					$rsMaster->addMissingRows($copy);
				}
			}
				

			
		
			// join the remaining ResultSet's
			if(!isset($rsMaster)) {
				$rsMaster=$resultSets[0];
				$i=1;
			} else {
				$i=0;
			}
			for(;$i<count($resultSets);++$i) {
				if($resultSets[$i] != 0) {
					$rsMaster=$rsMaster->joinWithResultSet($resultSets[$i]);
				}
			}
		}
		
		
		
		
		// from here we only work with $rsMaster and can free the other ResultSet's
		unset($resultSets);
		$resultSets="";
		
		
		// generate additional columns for COUNT(*) functions
		debug_printb("[executeSelectQuery] Adding COUNT(*) functions<br>");
		for($i=0;$i<count($funcs);++$i) {
			if($funcs[$i] && $sqlQuery->colNames[$i]=="*") {
				$rsMaster->addColumn($sqlQuery->colNames[$i],$sqlQuery->colAliases[$i],$sqlQuery->colTables[$i],"","int","",$funcs[$i],"","");
				$funcs[$i]="";
			}
		}
		
		
		// generate additional columns for the remaining functions (functions without params)
		for($i=0;$i<count($funcs);++$i) {
			if($funcs[$i]) {
				$rsMaster->addColumn($sqlQuery->colNames[$i],$sqlQuery->colAliases[$i],"","","str","",$funcs[$i],execFunc($funcs[$i],""));
			}
		}


		// generate additional columns from the WHERE-expression
		$rsMaster->generateAdditionalColumnsFromWhereExpr($sqlQuery->where_expr);
		
		// generate additional columns from ORDER BY
		$rsMaster->generateAdditionalColumnsFromArray($sqlQuery->orderColumns);
		
		// generate additional columns from GROUP BY
		$rsMaster->generateAdditionalColumnsFromArray($sqlQuery->groupColumns);
		
		// execute the new single-rec functions (on the Master ResultSet)
		$rsMaster->executeSingleRecFuncs();
		
		
		// generate new row id's 
		$rsMaster->generateRowIds();
		
		
		
        
			
		debug_printb("<br>[executeSelectQuery] Master ResultSet:</b><br>");
		if(TXTDBAPI_DEBUG) $rsMaster->dump();
		
		
		// apply WHERE expression
		if($sqlQuery->where_expr) {
			$ep=new ExpressionParser();
			$et=$ep->getExpressionTree($sqlQuery->where_expr);
			$rsMaster=$et->getFilteredResultSet($rsMaster);
		} 
		// free $ep
		unset($ep);
		$ep="";
		
		// stop if the WHERE expression failed
		if(txtdbapi_error_occurred()) {
			return false;
		}
		

		// check if we can use some optimization 
		// (use the limit in group by, but only if there are no grouping function
		// in the groupRows. To be able to do this we must order before grouping)
		$optimizedPath=true;
		if(!$sqlQuery->limit || !$sqlQuery->orderColumns) {
			$optimizedPath=false;
		} else {
			for($i=0;$i<count($sqlQuery->colFuncs);++$i) {
				if(in_array($sqlQuery->colFuncs[$i],$g_sqlGroupingFuncs)) {
					$optimizedPath=false;
					break;
				}
			}				
		}
		if($optimizedPath) {
			debug_printb("[executeSelectQuery] Using optimized path!<br>");
		} else {
			debug_printb("[executeSelectQuery] Using normal path!<br>");
		}
		
		// Order ResultSet (if optimizedPath)
		if($optimizedPath) {	
			debug_printb("[executeSelectQuery] Calling orderRows() (optimized path)..<br>");
			if(count($sqlQuery->orderColumns)>0) {
				$rsMaster->orderRows($sqlQuery->orderColumns,$sqlQuery->orderTypes);
			}
		}

		
		// Group ResultSet (process GROUP BY)
		$numGroupingFuncs=0;
		for($i=0;$i<count($sqlQuery->colFuncs);++$i) {
			if($sqlQuery->colFuncs[$i] && in_array($sqlQuery->colFuncs[$i],$g_sqlGroupingFuncs)) {
				++$numGroupingFuncs;
				break;
			}
		}
		if($numGroupingFuncs>0 || count($sqlQuery->groupColumns)>0) {
			debug_printb("[executeSelectQuery] Calling groupRows()..<br>");
			$rsMaster = $rsMaster->groupRows($sqlQuery,$optimizedPath);
		}
		
		// Order ResultSet (if NOT optimizedPath)
		if(!$optimizedPath) {	
			debug_printb("[executeSelectQuery] Calling orderRows() (normal path)..<br>");
			if(count($sqlQuery->orderColumns)>0) {
				$rsMaster->orderRows($sqlQuery->orderColumns,$sqlQuery->orderTypes);
			}
		}

		// add direct value columns
		debug_printb("[executeSelectQuery] Adding direct value columns..<br>");
		for($i=0;$i<count($sqlQuery->colNames);++$i) {
			if($sqlQuery->colNames[$i] && (is_numeric($sqlQuery->colNames[$i]) || has_quotes($sqlQuery->colNames[$i])) &&
			   !$sqlQuery->colTables[$i] && !$sqlQuery->colFuncs[$i] &&
			   $rsMaster->findColNrByAttrs($sqlQuery->colNames[$i],"","")==NOT_FOUND) {
			   	$value=$sqlQuery->colNames[$i];
			   	if(has_quotes($value)) {
			   		remove_quotes($value);
			   	}
			   	$rsMaster->addColumn($sqlQuery->colNames[$i],$sqlQuery->colAliases[$i],"","","str","","",$value,true);
			}
		}
		
		// return only the requested columns
		debug_printb("[executeSelectQuery] Removing unwanted columns...<br>");
		$rsMaster->filterByColumnNamesInSqlQuery($sqlQuery);
		
		
		// order columns (not their data)
		debug_printb("[executeSelectQuery] Ordering columns (amog themself)...<br>");
		if(!$rsMaster->orderColumnsBySqlQuery($sqlQuery)) {
			print_error_msg("Ordering the Columns (themself) failed");
			return false;
		}	
		
		// process DISTINCT
		if($sqlQuery->distinct == 1) {
			$rsMaster = $rsMaster->makeDistinct($sqlQuery->limit);
		}
		
		// Apply Limit		
		$rsMaster->reset();
		$rsMaster = $rsMaster->limitResultSet($sqlQuery->limit);
		verbose_debug_print ("<br>Limited ResultSet:<br>");
		if(TXTDBAPI_VERBOSE_DEBUG) $rsMaster->dump();

		
		$rsMaster->reset();
		return $rsMaster;
	}
    

}
?>
