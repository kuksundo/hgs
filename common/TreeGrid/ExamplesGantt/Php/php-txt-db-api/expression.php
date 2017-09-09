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

/**********************************************************************
							ExpressionParser
***********************************************************************/

// Used to filter a ResultSet ($masterResultSet) 
// by the Where-Expression in the SqlQuery Object ($sqlQuery)
class ExpressionParser {

	// A tree of Expression Objects is built, and then they
	// are filtered recursive
	// Returns a ResultSet filtered by the Where-Expression in $sqlQuery
	// $masterResultSet is left unchanged (I'm not sure about this)
	
	function getExpressionTree($expr) {
		
		global $g_sqlSingleRecFuncs;

		$parser=new SqlParser($expr);
		$king_expr=new Expression();
		$current_expr=&$king_expr;
		
		while(!is_empty_str($elem=$parser->parseNextElementRaw())) {
			
			// function or IN / NOT IN?
			if(in_array(strtoupper($elem),$g_sqlSingleRecFuncs) || strtoupper($elem) == "IN" || strtoupper($elem) == "NOT IN") {
				$current_expr->expr_str .= ($elem . " ");
				$elem=$parser->parseNextElementRaw();
				if($elem!="(") {
					print_error_msg("( expected after " . $current_expr->expr_str);
					return null;
				}
				$current_expr->expr_str .= $elem;
				
				while(!is_empty_str($elem=$parser->parseNextElementRaw()) && $elem!=")") {
					$current_expr->expr_str .= $elem;
				}
				$current_expr->expr_str .= $elem . " ";
				
				continue;
				
			}
			
			if($elem=="(") {
				$current_expr->expr_str .= " % ";
				unset($new_expr);
				$new_expr=new Expression("");
				$current_expr->addChild($new_expr);
				$new_expr->setParent($current_expr); 
				unset($current_expr);
				$current_expr=&$new_expr;
			
			} else if($elem==")") {
				
				unset($tmp);
				$tmp=&$current_expr->getParent();
				unset($current_expr);
				$current_expr=&$tmp;				
			} else {
				// no spaces on .'s
				if($elem==".") {
					remove_last_char($current_expr->expr_str);
					$current_expr->expr_str .= $elem;
				} else {
					$current_expr->expr_str .= ($elem . " ");
				}
			}
		}
		return $king_expr;
	}
}

/**********************************************************************
							Expression
***********************************************************************/

class Expression {
	
	/***********************************
		 	Member Vars
	************************************/
	
	var $expr_str;
	var $childs=array();
	var $parent;
	var $resultSetsFromChilds=array();
	var $childResultSetPos=0;
		
	/***********************************
		 		Constructor
	************************************/
	
	function Expression($expr_str="") {
		$this->expr_str=$expr_str;
	}
	
	/***********************************
		 		get/set Functions
	************************************/
	
	function setParent(&$parent_ref) {
		$this->parent=&$parent_ref;
	}
	
	function &getParent() {
		return $this->parent;
	}
	
	function setExprStr($expr_str) {
		$this->expr_str=$expr_str;
	}
	
	function getExprStr() {
		return $this->expr_str;
	}
	
	function getChildCount() {
		return count($this->childs);
	}
	
	function addChild(&$child_ref)  {
		debug_print("addChild called<br>");
		debug_print($this->expr_str . " has new Child: " . $child_ref->getExprStr() . "<br>"); 
		$this->childs[]=&$child_ref;
	}
	
	/***********************************
		 	Recursive Filter 
	************************************/
	
	function getFilteredResultSet(&$resultSet) {	
		
		global $g_sqlComparisonOperators;
		
		for($i=0;$i<$this->getChildCount();++$i) {
			$child=$this->childs[$i];
			$this->resultSetsFromChilds[]=$child->getFilteredResultSet($resultSet);
		}
		
		$sp=new StringParser();
		
		//$or_expr=explode_resp_quotes(" OR ",$this->expr_str);
		$sp->setConfig(array("'","\""), "\\", array() , array(" OR "),false,false);
		$sp->setString($this->expr_str);
        $or_expr=$sp->splitWithSpecialElements();     
				
		$andResultSets=array();
		
		for($i=0;$i<count($or_expr);++$i) {
			$fieldValuePair=array();
			$fields=array();
			$values=array();
			$operators=array();
			$childsToInclude=0;
						
			//$and_expr=explode_resp_quotes(" AND ",$or_expr[$i]);
			$sp->setConfig(array("'","\""), "\\", array() , array(" AND "),false,false);
			$sp->setString($or_expr[$i]);
            $and_expr=$sp->splitWithSpecialElements();     
			
			
			array_walk($and_expr,"array_walk_trim");
			for($j=0;$j<count($and_expr);++$j) {
				if($and_expr[$j]=="%")
					$childsToInclude++;
				else {
					
					//$operators[]=explode_resp_quotes_multisep($g_sqlComparisonOperators,$and_expr[$j],$fieldValuePair);
					$usedOps=array();
					$sp->setConfig(array("'","\""), "\\", array() , $g_sqlComparisonOperators,false,false);
					
					
			        $sp->setString($and_expr[$j]);
			        $fieldValuePair=$sp->splitWithSpecialElementsRetUsed($usedOps);  
			        $operators[]=trim($usedOps[0]);
			        
				
					
					// Remove escape chars (because parseNextElementRaw() was used
					// to parse Where Statements)
					list($field,$value)=$fieldValuePair;
					$fields[] = stripslashes(trim($field));
					// like bugfix: don't remove escape chars on the LIKE value
					if(strtoupper(trim($operators[count($operators)-1]))=="LIKE") {
					    $values[] = trim($value);   
					} else {
					    $values[] = stripslashes(trim($value));
					}
				}
			}
			if(TXTDBAPI_DEBUG) {
				echo "<br>fields and values to use for AND filter:<br>";
				print_r($fields);
				echo "<br>";
				print_r($values);
				echo "<br>";
				print_r($operators);
				echo "<br>";
				echo "childsToInclude:  ". $childsToInclude . "<br>";
			}
			$andResultSets[]=$resultSet->filterRowsByAndConditions($fields,$values,$operators);
			debug_print("filterRowsByAndConditions done<br>");
			for($j=0;$j<$childsToInclude;++$j) {
				$andResultSets[$i]->filterResultSetAndWithAnother($this->resultSetsFromChilds[$this->childResultSetPos++]);
			}
			
			if(TXTDBAPI_DEBUG) {
				echo "Filtered ResultSet:<br>";
				$andResultSets[$i]->dump();
			}
			
		}
		$finalResultSet=$andResultSets[0];
		for($i=1;$i<count($andResultSets);++$i) {
			$andResultSets[$i]->reset();
			while($andResultSets[$i]->next()) 
				$finalResultSet->appendRow($andResultSets[$i]->getCurrentValues(),$andResultSets[$i]->getCurrentRowId());
		}
		if(TXTDBAPI_DEBUG) {
			echo "<br><br>FINAL RESULT SET:<br>";
			$finalResultSet->dump();
		}
		return $finalResultSet;
	}
	
	
	
	
	
}
		
		
?>