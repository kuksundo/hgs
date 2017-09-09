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

include_once(API_HOME_DIR . "util.php");
include_once(API_HOME_DIR . "const.php");
include_once(API_HOME_DIR . "stringparser.php");


/**********************************************************************
							Global vars 
***********************************************************************/

// Special Strings in SQL Queries
// Insert Strings before Single Chars !! (e.g. >= before >)
$g_sqlComparisonOperators=array("<>","!=",">=","<=","=","<",">"," LIKE ", " NOT LIKE ", " IN ", " NOT IN ");
$g_sqlQuerySpecialStrings = array_merge($g_sqlComparisonOperators, array("(",")",";",",","."));
$g_sqlQuerySpecialStringsMaxLen =6;

// Functions for SQL Queries
// SingleRec functions need no grouped ResultSet
$g_sqlSingleRecFuncs=array("UNIX_TIMESTAMP","MD5","NOW","ABS","LCASE","UCASE","LOWER","UPPER", "INC", "DEC", "EVAL");
$g_sqlGroupingFuncs=array("MAX","MIN","COUNT","SUM", "AVG");

// Math Operators
$g_sqlMathOps=array("+","-","*","/","(",")");



/**********************************************************************
							SqlParser
***********************************************************************/
// Used to parse an SQL-Query (as String) into an SqlObject
class SqlParser extends StringParser {
	

	/***********************************
		 		Constructor
	************************************/
	function SqlParser($sql_query_str) {
	    
		debug_print ("New SqlParser instance: $sql_query_str<br>");
		global $g_sqlQuerySpecialStrings;

	    $this->quoteChars=array("'","\"");
	    $this->escapeChar="\\";         
	    $this->whitespaceChars=array(" ","\n","\r","\t");   
	    $this->specialElements=$g_sqlQuerySpecialStrings;
	    $this->removeQuotes=false;
        $this->removeEscapeChars=true;
        $this->setString($sql_query_str);
	}
	
	/***********************************
		 	Parse Dispatcher
	************************************/
	// Returns a SqlQuery Object or null if an error accoured
	function parseSqlQuery() {
		$type="";
		if(!$type=$this->parseNextElement()) 
			return null;
		$type=strtoupper($type);
		switch($type) {
			case "SELECT":
				return $this->parseSelectQuery();
			case "INSERT":
				return $this->parseInsertQuery();
			case "DELETE":
				return $this->parseDeleteQuery();
			case "UPDATE":
				return $this->parseUpdateQuery();
			case "CREATE":
				if(strtoupper($this->peekNextElement())=="TABLE") {
					$this->skipNextElement();
					return $this->parseCreateTableQuery();
				}	
				if(strtoupper($this->peekNextElement())=="DATABASE") {
					$this->skipNextElement();
					return $this->parseCreateDatabaseQuery();
				}	
				$type .= " " . $this->peekNextElement();
				break;
			case "DROP":
				if(strtoupper($this->peekNextElement())=="TABLE") {
					$this->skipNextElement();
					return $this->parseDropTableQuery();
				}	
				if(strtoupper($this->peekNextElement())=="DATABASE") {
					$this->skipNextElement();
					return $this->parseDropDatabaseQuery();
				}	
				$type .= " " . $this->peekNextElement();
				break;
			case "LIST":
				if(strtoupper($this->peekNextElement())=="TABLES") {
					$this->skipNextElement();
					return $this->parseListTablesQuery();
				}	
				$type .= " " . $this->peekNextElement();
				break;
		}
		print_error_msg("SQL Type $type not supported");
		return null;
	}
	
	
	/***********************************
		 Select Query Parse Function
	************************************/
	
	// SELECT must be removed here (do not call this Function directly !!!)
	// returns a SqlQuery Object
	function parseSelectQuery() {
				
		$colNames=array();
		$colTables=array();
		$colAliases=array();
		$colFuncs=array();
		$fieldValues=array();
		$tables=array();
		$tableAliases=array();
		$groupColumns=array();
		$orderColumns=array();
		$orderTypes=array();
		$where_expr="";
		$distinct=0;
		$joins=array();
		
		
		// parse Distinct
		if(strtoupper($this->peekNextElement())=="DISTINCT") {
			$distinct=1;
			$this->skipNextElement();
		}
	
		
		// parse Columns
		$arrElements=array();
		$colIndex=-1;
		
		while($this->parseNextElements(",",array("FROM"),$arrElements)) {
			
			++$colIndex;
			$colNames[$colIndex]="";
			$colTables[$colIndex]="";
			$colAliases[$colIndex]="";
			$colFuncs[$colIndex]="";
			
			// FUNC() | FUNC(col) | FUNC(table.col) | FUNC(col) AS alias | FUNC(table.col) AS alias | FUNC() AS alias
			// function ?
			if(count($arrElements)>=3 && $arrElements[1]=="(") {
				$colFuncs[$colIndex]=strtoupper($arrElements[0]);
				
				// remove function from $arrElements
				array_splice($arrElements,0,2);
				$pos=array_search (")",$arrElements);
				if(!is_false($pos) && !_is_null($pos)) {
					array_splice($arrElements,$pos,1);
				}	
			}
			
			// *empty array* | col | table.col | col AS alias | table.col AS alias | AS alias
			// table ?
			if(count($arrElements)>=3 && $arrElements[1]==".") {
				$colTables[$colIndex]=$arrElements[0];
				array_splice($arrElements,0,2);
			}

			// *empty array* | col | col AS alias | AS alias
			// alias ?
			if(count($arrElements)>=3 && strtoupper($arrElements[1])=="AS") {
				$colAliases[$colIndex]=$arrElements[2];
				array_splice($arrElements,1,2);
			}

			// *empty array* | col | AS alias
			// alias on function without column
			if(count($arrElements)>=2 && strtoupper($arrElements[0])=="AS") {
				$colAliases[$colIndex]=$arrElements[1];
				array_splice($arrElements,0,2);
			}
			
			// *empty array* | col 
			// column name ? 
			if(count($arrElements)>=1) {
				$colNames[$colIndex]=$arrElements[0];
				array_splice($arrElements,0,1);
			}
			
			if(count($arrElements)>0) {
				$errStr="Unexpected Element(s): ";
				for($i=0;$i<count($arrElements);++$i) {
					$errStr.= $arrElements[$i] . " ";
				}
				print_error_msg($errStr);
				return null;
			}
		}
		
		// skip FROM
		$this->skipNextElement();
			
		// parse Tables
		$arrElements=array();
		$tableIndex=0;
		$joinIndex=0;
		while($elem=$this->peekNextElement()) {
			$elemUpper=strtoupper($elem);
			if(in_array($elemUpper,array("GROUP","WHERE","ORDER","LIMIT",";"))) {
				break;
			}
			if($elemUpper=="AS") {
				$this->skipNextElement();
				$tableAliases[$tableIndex]=$this->parseNextElement();
				continue;
			}
			if($elemUpper=="LEFT") {
				if(!isset($joins[$joinIndex])) $joins[$joinIndex]=new Join();
				$joins[$joinIndex]->type=JOIN_LEFT;
				$this->skipNextElement();
				continue;
			}
			if($elemUpper=="RIGHT") {
				if(!isset($joins[$joinIndex])) $joins[$joinIndex]=new Join();
				$joins[$joinIndex]->type=JOIN_RIGHT;
				$this->skipNextElement();
				continue;				
			}
			if($elemUpper=="INNER") {
				if(!isset($joins[$joinIndex])) $joins[$joinIndex]=new Join();
				$joins[$joinIndex]->type=JOIN_INNER;
				$this->skipNextElement();
				continue;				
			}
			if($elemUpper=="JOIN") {
				if(!isset($joins[$joinIndex])) $joins[$joinIndex]=new Join();
				$joins[$joinIndex]->leftTableIndex=$tableIndex;
				$this->skipNextElement();
				$tables[++$tableIndex]=$this->parseNextElement();
				$tableAliases[$tableIndex]="";
				$joins[$joinIndex]->rightTableIndex=$tableIndex;				
				continue;
			}
			if($elemUpper=="OUTER") {
				$this->skipNextElement();
				// ignore
				continue;
			}
			if($elemUpper==",") {
				++$tableIndex;
				$this->skipNextElement();
				continue;
			}
			if($elemUpper=="ON") {
				$exprElements=array();
				$this->skipNextElement();
				$this->parseNextElements("",array(",", "GROUP","WHERE","ORDER","LIMIT",";", "LEFT", "RIGHT", "INNER", "OUTER", "JOIN"), $exprElements);
				foreach($exprElements as $exprElem) {
					// no spaces on .'s
					if($exprElem==".") {
						remove_last_char($joins[$joinIndex]->expr);
						$joins[$joinIndex]->expr .= $exprElem;
					} else {
						$joins[$joinIndex]->expr .= ($exprElem . " ");
					}
				}
				$joinIndex++;
				continue;
			}
			
			// if table is allready set its an alias without AS, else its the table name
			if(isset($tables[$tableIndex])) {
				$tableAliases[$tableIndex]=$elem;
				$this->skipNextElement();
			} else {
				$tables[$tableIndex]=$elem;
				$tableAliases[$tableIndex]="";
				$this->skipNextElement();
			}

		}
		
		
				
		// parse Where statement (Raw, because the escape-chars are needend in the ExpressionParser)
		if(strtoupper($this->peekNextElement()) == "WHERE") {
			$this->skipNextElement();
			while(!is_empty_str($elem=$this->peekNextElementRaw())) {
				if(strtoupper($elem)=="GROUP" || strtoupper($elem)=="ORDER" || $elem==";" || strtoupper($elem)=="LIMIT" )
					break;
					
				$this->skipNextElement();
		
				// no " " on points
				if($elem==".") {
					remove_last_char($where_expr);
					$where_expr .= $elem;
				} else {
					$where_expr .= $elem . " ";
				}
			}
		}
		debug_print( "WHERE EXPR: $where_expr<br>");
		
		// parse GROUP BY
		$groupColumnIndex=0;
		if(strtoupper($this->peekNextElement()) == "GROUP") {
			$this->skipNextElement();
			if(strtoupper($this->parseNextElement())!="BY") {
				print_error_msg("BY expected");
				return null;
			}
			
			while(!is_empty_str($elem=$this->peekNextElement())) {
				if($elem==";" || strtoupper($elem)=="LIMIT" || strtoupper($elem)=="ORDER")
					break;
				$this->skipNextElement();
				if($elem==",") {
					$groupColumnIndex++;
				}
				else {
					if(!isset($groupColumns[$groupColumnIndex])) 
						$groupColumns[$groupColumnIndex]=$elem;
					else
						$groupColumns[$groupColumnIndex].=$elem;
				}	
			}
		}
		
		// parse ORDER BY
		$orderColumnIndex=0;
		if(strtoupper($this->peekNextElement()) == "ORDER") {
			$this->skipNextElement();
			if(strtoupper($this->parseNextElement())!="BY") {
				print_error_msg("BY expected");
				return null;
			}
			
			while(!is_empty_str($elem=$this->peekNextElement())) {
				if($elem==";" || strtoupper($elem)=="LIMIT")
					break;
				$this->skipNextElement();
				if($elem==",") {
					$orderColumnIndex++;
				}
				else if(strtoupper($elem)=="ASC") 
					$orderTypes[$orderColumnIndex]=ORDER_ASC;
				else if(strtoupper($elem)=="DESC")
					$orderTypes[$orderColumnIndex]=ORDER_DESC;
				else {
					if(!isset($orderColumns[$orderColumnIndex])) 
						$orderColumns[$orderColumnIndex]=$elem;
					else
						$orderColumns[$orderColumnIndex].=$elem;
					$orderTypes[$orderColumnIndex]=ORDER_ASC;
				}	
			}
		}
		// parse LIMIT
		$limit = array();
		if(strtoupper($this->peekNextElement()) == "LIMIT") {
			$this->skipNextElement();
			while(!is_empty_str($elem=$this->peekNextElement())) {
				if($elem==";")
					break;
				$this->skipNextElement();
				if($elem!=",") {
					$limit[] = $elem;
				}
			}
		}

		$sqlObj = new SqlQuery("SELECT", $colNames, $tables, $colAliases, $colTables, $where_expr, $groupColumns, $orderColumns, $orderTypes, $limit);
		$sqlObj->tableAliases=$tableAliases;
		$sqlObj->colFuncs=$colFuncs;
		$sqlObj->distinct=$distinct;
		$sqlObj->joins=$joins;
		
		return $sqlObj;

	}


	/***********************************
		 Insert Query Parse Function
	************************************/
	
	// INSERT must be removed here (do not call this Function directly !!!)
	// returns a SqlQuery Object
	function parseInsertQuery() {
		
		$colNames=array();
		$colTables=array();
		$colAliases=array();
		$fieldValues=array();
		$tables=array();
		$insertType="";
		
		
		// remove INTO
		if(strtoupper($this->peekNextElement())=="INTO") 
			$this->skipNextElement();
				
		// Read Table				
		$tables[0]=$this->parseNextElement();
		
		
		// Read Column Names between ()'s
		$colIndex=0;
		if($this->peekNextElement()=="(") {
			$this->skipNextElement();
			while(($elem=$this->parseNextElement())!=")") {
				if($elem==",")
					$colIndex++;
				else 
					$colNames[$colIndex]=$elem;
			}
		}
		
		
		
		// read Insert Type
		$insertType=$this->parseNextElement();
		
		switch(strtoupper($insertType)) {
			case "SET":
				// Read Columns and Values
				$colIndex=0;
				$writeToValue=false;
				while( !is_empty_str(($elem=$this->parseNextElement())) && ($elem != ";")) {
					if($elem==",") {
						$colIndex++;
						$writeToValue=false;
					} else if($elem=="=") {
						$writeToValue=true;
					} else {
						if($writeToValue) {
							if(!isset($fieldValues[$colIndex])) {
								$fieldValues[$colIndex]="";
							}
							$fieldValues[$colIndex].=$elem;
						} else {
							if(!isset($fieldValues[$colIndex])) {
								$colNames[$colIndex]="";
							}
							$colNames[$colIndex].=$elem;
						}
						
					}
				}
				break;
				
			case "VALUES":
				if($this->parseNextElement()!="(") {
					print_error_msg("VALUES in the INSERT Statement must be in Braces \"(,)\"");
					return null;
				}
				$openBraces=1;
				$fieldValuesIndex=0;
				while( !is_empty_str(($elem=$this->parseNextElement())) && ($elem != ";")) {
										
					if($elem=="(") {
						$openBraces++;
						$fieldValues[$fieldValuesIndex].=$elem;
					} else if($elem==")") {
						$openBraces--;
						if($openBraces<1) {
							break;
						}
						$fieldValues[$fieldValuesIndex].=$elem;
					} else if($elem==",") {
						$fieldValuesIndex++;
					} else {
						if(!isset($fieldValues[$fieldValuesIndex])) {
							$fieldValues[$fieldValuesIndex]="";
						}
						$fieldValues[$fieldValuesIndex].=$elem;
					}
				}
				break;
			default:
				print_error_msg("Insert Type " . $insertType . " not supported");
				return null;
		}
		$sqlObj = new SqlQuery();
		$sqlObj->type = "INSERT";
		$sqlObj->colNames=$colNames;
		$sqlObj->colAlias=$colAliases;
		$sqlObj->colTables=$colTables;
		$sqlObj->fieldValues=$fieldValues;
		$sqlObj->insertType=$insertType;
		$sqlObj->tables=$tables;
		
		return $sqlObj;
	}
	
	
	/***********************************
		 Delete Query Parse Function
	************************************/
	
	// DELETE must be removed here (do not call this Function directly !!!)
	// returns a SqlQuery Object
	function parseDeleteQuery() {
		
		$tables=array();
		$where_expr="";
		
		if(strtoupper($this->parseNextElement())!="FROM") {
			print_error_msg("FROM expected");
			return null;
		}
		$tables[0]=$this->parseNextElement();
		
		// Because the Where Statement is not parsed with 
		// the parseXX Functions, this equals a Raw-Parse,
		// as needed for the ExpressionParser
		if(strtoupper($this->parseNextElement())=="WHERE") {
			$where_expr=rtrim($this->workingStr);
			debug_print("where_expr: $where_expr<br>");
			if(last_char($where_expr)==";")
				remove_last_char($where_expr);
		} else if ($elem=$this->parseNextElement()) {
			print_error_msg("Nothing more expected: $elem");
			return null;
		}
		
		$sqlObj = new SqlQuery();
		$sqlObj->type = "DELETE";
		$sqlObj->tables=$tables;
		$sqlObj->where_expr=$where_expr;
		
		return $sqlObj;
	}
	
	
	/***********************************
		 Update Query Parse Function
	************************************/
	
	// UPDATE must be removed here (do not call this Function directly !!!)
	// returns a SqlQuery Object
	function parseUpdateQuery() {
		
		$colNames=array();
		$fieldValues=array();
		$tables=array();
		$where_expr="";
		
		// Read Table				
		$tables[0]=$this->parseNextElement();
		
		// Remove SET
		if(strtoupper($this->parseNextElement())!="SET") {
			print_error_msg("SET expected");
			return null;
		}
		
		// Read Columns and Values
		$colIndex=0;
		$writeToValue=false;
		while( !is_empty_str(($elem=$this->parseNextElement())) && ($elem != ";") && strtoupper($elem)!="WHERE") {
			if($elem==",") {
				$colIndex++;
				$writeToValue=false;
			} else if($elem=="=") {
				$writeToValue=true;
			} else {
				if($writeToValue) {
					if(!isset($fieldValues[$colIndex])) {
						$fieldValues[$colIndex]="";
					}
					$fieldValues[$colIndex].=$elem;
				} else {
					if(!isset($colNames[$colIndex])) {
						$colNames[$colIndex]="";
					}
					$colNames[$colIndex].=$elem;
				}
			}
		}
		
		// Raw-Parse Where Statement
		if(strtoupper($elem)=="WHERE") {
			$where_expr=rtrim($this->workingStr);
			debug_print("where_expr: $where_expr<br>");
			
			if(last_char($where_expr)==";")
				remove_last_char($where_expr);
		}


		$sqlObj = new SqlQuery();
		$sqlObj->type = "UPDATE";
		$sqlObj->colNames=$colNames;
		$sqlObj->fieldValues=$fieldValues;
		$sqlObj->tables=$tables;
		$sqlObj->where_expr=$where_expr;
		
		return $sqlObj;
	}
	
	
	/***********************************
	  Create Table Query Parse Function
	************************************/
	
	// CREATE TABLE must be removed here (do not call this Function directly !!!)
	// returns a SqlQuery Object
	function parseCreateTableQuery() {
		$colNames=array();
		$colTypes=array();
		$colDefaultValues=array();
		$tables=array();
	
		$tables[0]=$this->parseNextElement();	
		
		if($this->parseNextElement()!="(") {
			print_error_msg("( expected");
			return null;
		}

		$index=0;
		
		$arrElements=array();
		while($this->parseNextElements(",",array(";"),$arrElements)) {
			$colNames[]=$arrElements[0];
			$colTypes[]=$arrElements[1];
			if(count($arrElements)>3 && strtoupper($arrElements[2])=="DEFAULT") {
				if(has_quotes($arrElements[3]))
					remove_quotes($arrElements[3]);
				$colDefaultValues[]=$arrElements[3];
			} else {
				$colDefaultValues[]="";
			}
		}
		
	
		
		
		$sqlObj = new SqlQuery();
		$sqlObj->type = "CREATE TABLE";
		$sqlObj->colNames=$colNames;
		$sqlObj->colTypes=$colTypes;
		$sqlObj->fieldValues=$colDefaultValues;
		$sqlObj->tables=$tables;
	
		return $sqlObj;		
	}
	
	/***********************************
	  Create Database Query Parse Function
	************************************/
	
	// CREATE DATABASE must be removed here (do not call this Function directly !!!)
	// returns a SqlQuery Object
	function parseCreateDatabaseQuery() {
	
		$dbName=$this->parseNextElement();	
		
		$sqlObj = new SqlQuery();
		$sqlObj->type = "CREATE DATABASE";
		$sqlObj->colNames=array($dbName);
		return $sqlObj;		
	}
	
	/***********************************
	  Drop Database Query Parse Function
	************************************/
	
	// DROP DATABASE must be removed here (do not call this Function directly !!!)
	// returns a SqlQuery Object
	function parseDropDatabaseQuery() {
	
		$dbName=$this->parseNextElement();	
		
		$sqlObj = new SqlQuery();
		$sqlObj->type = "DROP DATABASE";
		$sqlObj->colNames=array($dbName);
		return $sqlObj;		
	}
	
	/***********************************
	  Drop Table Query Parse Function
	************************************/
	
	// DROP TABLE must be removed here (do not call this Function directly !!!)
	// returns a SqlQuery Object
	function parseDropTableQuery() {
	
		$tables=array();
		$i=0;
		

		while($this->peekNextElement() != ";" && !is_empty_str($elem=$this->parseNextElement())) {
			if($elem==",")
				++$i;
			else
				$tables[$i]=$elem;
		}
		
		$sqlObj = new SqlQuery();
		$sqlObj->type = "DROP TABLE";
		$sqlObj->colNames=$tables;
		return $sqlObj;		
	}
	
	/***********************************
	  List Tables Query Parse Function
	************************************/
	
	// LIST TABLES must be removed here (do not call this Function directly !!!)
	// returns a SqlQuery Object
	function parseListTablesQuery() {
		$sqlObj = new SqlQuery();
		$sqlObj->type = "LIST TABLES";
		
		$colNames=array();
		$colTables=array();
		$colAliases=array();
		$fieldValues=array();
		$tables=array();
		$groupColumns=array();
		$orderColumns=array();
		$orderTypes=array();
		$where_expr="";
		$distinct=0;
		
		
		// parse Where statement (Raw, because the escape-chars are needend in the ExpressionParser)
		if(strtoupper($this->peekNextElement()) == "WHERE") {
			$this->skipNextElement();
			while(!is_empty_str($elem=$this->peekNextElementRaw())) {
				if(strtoupper($elem)=="ORDER" || $elem==";" || strtoupper($elem)=="LIMIT" )
					break;
				$this->skipNextElement();
				
				// no " " on points
				if($elem==".") {
					remove_last_char($where_expr);
					$where_expr .= $elem;
				} else {
					$where_expr .= $elem . " ";
				}
			}
		}
		
		// parse ORDER BY
		$orderColumnIndex=0;
		if(strtoupper($this->peekNextElement()) == "ORDER") {
			$this->skipNextElement();
			if(strtoupper($this->parseNextElement())!="BY") {
				print_error_msg("BY expected");
				return null;
			}
			
			while(!is_empty_str($elem=$this->peekNextElement())) {
				if($elem==";" || strtoupper($elem)=="LIMIT")
					break;
				$this->skipNextElement();
				if($elem==",") {
					$orderColumnIndex++;
				}
				else if(strtoupper($elem)=="ASC") 
					$orderTypes[$orderColumnIndex]=ORDER_ASC;
				else if(strtoupper($elem)=="DESC")
					$orderTypes[$orderColumnIndex]=ORDER_DESC;
				else {
					if(!isset($orderColumns[$orderColumnIndex])) 
						$orderColumns[$orderColumnIndex]=$elem;
					else
						$orderColumns[$orderColumnIndex].=$elem;
					$orderTypes[$orderColumnIndex]=ORDER_ASC;
				}	
			}
		}
		// parse LIMIT
		$limit = array();
		if(strtoupper($this->peekNextElement()) == "LIMIT") {
			$this->skipNextElement();
			while(!is_empty_str($elem=$this->peekNextElement())) {
				if($elem==";")
					break;
				$this->skipNextElement();
				if($elem!=",") {
					$limit[] = $elem;
				}
			}
		}
		
		
		$sqlObj = new SqlQuery("LIST TABLES", $colNames, $tables, $colAliases, $colTables, $where_expr, $groupColumns, $orderColumns, $orderTypes, $limit);
		return $sqlObj;		
	}

	
	/***********************************
		 	Parse Helper Functions
	************************************/
		
	// does not remove Escape Chars
	function parseNextElementRaw() {
	    $this->removeEscapeChars=false;
		$ret= $this->parseNextElement();
		$this->removeEscapeChars=true;
		return $ret;
	}
	
	// does not remove Escape Chars
	function peekNextElementRaw() {
		$this->removeEscapeChars=false;
		$ret= $this->peekNextElement();
		$this->removeEscapeChars=true;
		return $ret;
	}
	
}


/**********************************************************************
								Join
***********************************************************************/

class Join {
	var $type = JOIN_INNER;
	var $leftTableIndex;
	var $rightTableIndex;
	var $expr;
}

/**********************************************************************
								SqlQuery
***********************************************************************/
// Represents an SQL Query 
// Fields should be accessed directly here -> faster 

class SqlQuery {
	
	
	/***********************************
			Member variables
	************************************/

	var $type;
	
	var $colNames=array();
	var $colAliases=array();
	var $colTables=array();
	
	var $colTypes=array();		// At the Moment only used in CREATE TABLE (int, string OR inc)
								// may also used in other Queries 
	var $colFuncs=array();
	
	var $fieldValues=array(); 	// Used in: INSERT, UPDATE, CREATE TABLE (as default values)
	
	var $insertType=""; 		// Used in: INSERT ("VALUES", "SET" or "SELECT")
	
	var $groupColumns=array();	// Used by: GROUP BY
	var $distinct=0;			// will be set if SELECT query contains a DISTINCT
	
	var $orderColumns=array(); 	// Used by: ORDER BY
	var $orderTypes=array();	// Used by: ORDER BY
	
	var $tables=array();
	var $joins=array();
	var $tableAliases=array();
	var $where_expr;
	
	var $limit=array();

	
	
	
	/***********************************
				Constructor
	************************************/
	
	function SqlQuery($type="SELECT", $colNames=array(), $tables=array(), $colAliases=array(), $colTables=array(), $where_expr="", $groupColumns=array(), $orderColumns=array(),$orderTypes=array(),$limit=array()) {
	
		$this->type=$type;
		$this->colNames=$colNames;
		$this->tables=$tables;
		
		$this->where_expr=$where_expr;
		$this->colAliases=$colAliases;
		$this->colTables=$colTables;
		$this->groupColumns=$groupColumns;
		$this->orderColumns=$orderColumns;
		$this->orderTypes=$orderTypes; 
		$this->limit=$limit;
		
	}
	
	function getSize() {
		return count($this->colNames);
	}
	
	
	/***********************************
				Test
	************************************/
	// NOT Up to Date
	// Test's if the SqlQuery is valid
	// TRUE if ok, FALSE if not ok
	function test() {
				
		return true; // return true, function is outdated TODO: update
		
		reset($this->colNames);
		for($i=0;$i<count($this->colNames);++$i) {
			if($this->colNames[$i]=="*")
			{
				if($this->colAliases[$i]) {
					print_error_msg("Cannot define Alias by a *");
					return FALSE;
				}
				continue;
			}
			if($key=array_search  ($this->colNames[$i], $this->colNames)) {
				if($i==$key)
					continue;
				if($this->colAliases[$i] == $this->colAliases[$key] && $this->colFuncs[$i]==$this->colFuncs[$key]) {
					print_error_msg("Two Columns with the same name use no or the same alias ('" . $this->colNames[$i] . "', '" . $this->colNames[$key] . "')");
					return FALSE;
				}
				if(!$this->colTables[$i]) {
					print_error_msg("Column " . $this->colNames[$i] . " could belong to multiple Tables");
					return FALSE;
				}
			}
		}
		reset($this->colAliases);
		for($i=0;$i<count($this->colAliases);++$i) {
			if($key=array_search  ($this->colAliases[$i], $this->colAliases)) {
				if($i==$key || $this->colAliases[$i]=="")
					continue;
				print_error_msg("Two Columns (" . $this->colNames[$i] . ", " . $this->colNames[$key] . ") use the same alias");
				return FALSE;
			}
		}
		
		reset($this->colNames);
		// TODO: error ..?!?  SELECT nr, tabelle1.nr As nr FROM ....
		// produces no Error !
		for($i=0;$i<count($this->colAliases);++$i) {
			if(($key=array_search($this->colAliases[$i], $this->colNames))) {
				if($i==$key) {
					continue;
				}
				if($this->colAliases[$i]=="")
					continue;
					
				print_error_msg("Alias is the name from another column (" . $this->colAliases[$i] . ")");
				return FALSE;
			}
		}
		return TRUE;
		
	}
	
	function dump() {
		echo "<pre>";
		echo "SqlQuery dump:<br>";
		echo "type:  $this->type<br>";	
		echo "<br>colNames:<br>"; 
		print_r($this->colNames);
		echo "<br>colAliases:<br>"; 
		print_r($this->colAliases);
		echo "<br>colTables:<br>"; 
		print_r($this->colTables);
		echo "<br>colTypes:<br>"; 
		print_r($this->colTypes);
		echo "<br>colFuncs:<br>"; 
		print_r($this->colFuncs);
		echo "<br>fieldValues:<br>"; 
		print_r($this->fieldValues);
		echo "<br>insertType: " . $this->insertType . "<br>"; 
		echo "<br>groupColumns:<br>"; 
		print_r($this->groupColumns);
		echo "<br>distinct: " . $this->distinct . "<br>"; 
		echo "<br>orderColumns:<br>"; 
		print_r($this->orderColumns);
		echo "<br>orderTypes:<br>"; 
		print_r($this->orderTypes);
		echo "<br>tables:<br>"; 
		print_r($this->tables);
		echo "<br>tableAliases:<br>"; 
		print_r($this->tableAliases);
		echo "<br>limit:<br>"; 
		print_r($this->limit);
		echo "<br>where_expr: " . $this->where_expr ."<br>"; 
		echo "</pre>";
	}

}

?>
