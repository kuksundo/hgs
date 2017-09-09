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

/**********************************************************************
							Global vars 
***********************************************************************/

$g_txtdbapi_errors=array();

/**********************************************************************
							Util Functions
***********************************************************************/

/***********************************
	 	Version Functions
************************************/
function txtdbapi_version() {
	return TXTDBAPI_VERSION;
}



/***********************************
	 	Debug Functions
************************************/
function debug_printb($str) {
	if(TXTDBAPI_DEBUG) {
		echo "<b>" . $str . "</b>";
	}
}

function debug_print($str) {
	if(TXTDBAPI_DEBUG) {
		echo $str;
	}
}

function verbose_debug_print($str) {
	if(TXTDBAPI_VERBOSE_DEBUG) {
		echo $str;
	}
}


/***********************************
	 	Char Functions
************************************/
function last_char($string) {
	$len = strlen($string);
	if($len < 1) {
		return '';
	}
	return $string{strlen($string)-1};
}

function remove_last_char(&$string) {
	$string=substr($string,0,strlen($string)-1);
}


/***********************************
	 	String Functions
************************************/
// returns $length chars from the right side of $string
function substr_right($string,$length) {
	return substr($string, strlen($string)-$length);
}



/***********************************
	 	Array Functions
************************************/
function array_walk_trim(&$value, &$key) {
	$value=trim($value);
}

function create_array_fill($size, $value) {
	$arr=array();
	for($i=0;$i<$size;++$i)
		$arr[]=$value;
	return $arr;
}

// searches the first n chars of $string in $array
// where n is the length of reach $array element
// returns the value of $array if found or false
function array_search_str_start($string, $array) {
	for($i=0;$i<count($array);++$i) {
		//debug_print("Searching " . $array[$i] . " in " . $string . "<br>");
		if(strncmp($array[$i],$string, strlen($array[$i]))==0)
			return $array[$i];
	}
	return false;
}

// as above but case insenitive
function array_search_stri_start($string, $array) {
    for($i=0;$i<count($array);++$i) {
		//debug_print("Searching " . $array[$i] . " in " . $string . "<br>");
		if(strncmp(strtoupper($array[$i]),strtoupper($string), strlen($array[$i]))==0)
			return $array[$i];
	}
	return false;
}

/***********************************
	 	Type Functions
************************************/
function dump_retval_type($var) {
  if(is_bool($var) && !$var) 
    echo "The value is FALSE<br>"; 
  if(is_int($var) && !$var) 
    echo "The value is 0<br>"; 
  if(!isset($var)) 
    echo "The value is NULL<br>"; 
  if(is_string($var) && $var=="") 
    echo "The value is \"\"<br>"; 
  if(is_string($var) && $var=="0") 
    echo "The value is \"0\"<br>"; 
  if($var)
  	echo "The value is a TRUE or something other then 0 or FALSE<br>"; 
} 

function is_false($var) {
	return (is_bool($var) && !$var);
}
function is_0($var) {
	return (is_int($var) && !$var);
}
// _ at the front, cause is_null exists
function _is_null($var) {
	return (!isset($var)) ;
}
function is_empty_str($var) {
	return (is_string($var) && $var=="");
}

/***********************************
	 	SQL Util Functions
************************************/
// compares 2 values by $operator, and returns true or false
function compare($value1,$value2,$operator) {
	
	if($operator=="=")
		return ($value1 == $value2);

	if($operator==">")
		return ($value1 > $value2);
		
	if($operator=="<")
		return ($value1 < $value2);
		
	if($operator=="<>" || $operator=="!=")
		return ($value1 != $value2);
		
	if($operator==">=")
		return ($value1 >= $value2);
		
	if($operator=="<=")
		return ($value1 <= $value2);
		
	if($operator=="LIKE") {
		return compare_like($value1,$value2);
	}
	if($operator=="NOT LIKE") { 
		return !compare_like($value1,$value2); 
	} 
	if($operator=="IN") {
		$list = preg_split ("/[(,) ]+/",$value2,-1,PREG_SPLIT_NO_EMPTY);
		foreach($list as $listVal) {
			if(!is_numeric($listVal)) {
				if(has_quotes($listVal)) {
					remove_quotes($listVal);
				}
				if("$listVal" == "$value1") {
					return 1;
				}
			} else if($listVal == $value1) {
				return 1;
			}
		}
		return 0;
	}
	if($operator=="NOT IN") {
		$list = preg_split ("/[(,) ]+/",$value2,-1,PREG_SPLIT_NO_EMPTY);
		foreach($list as $listVal) {
			if(!is_numeric($listVal)) {
				if(has_quotes($listVal)) {
					remove_quotes($listVal);
				}
				if("$listVal" == "$value1") {
					return 0;
				}
			} else if($listVal == $value1) {
				return 0;
			}
		}
		return 1;
	}
		
	return false;
}


function compare_like($value1,$value2) { 
	static $patterns = array(); 

	// Lookup precomputed pattern 
	if(isset($patterns[$value2])) { 
		$pat = $patterns[$value2]; 
	} else { 
		// Calculate pattern 
		$rc=0; 
		$mod = ""; 
		$prefix = "/^"; 
		$suffix = "$/"; 
       
		// quote regular expression characters 
		$str=preg_quote($value2,"/"); 
       
		// unquote \ 
		$str=str_replace ("\\\\", "\\",$str); 
       
		// Optimize leading/trailing wildcards 
		if(substr($str, 0, 1) == '%') { 
			$str = substr($str, 1); 
			$prefix = "/"; 
		} 
		if(substr($str, -1) == '%' && substr($str, -2, 1) != '\\') { 
			$str = substr($str, 0, -1); 
			$suffix = "/"; 
		} 
       
		// case sensitive ? 
		if(!LIKE_CASE_SENSITIVE) 
			$mod="i"; 
          
		// setup a StringParser and replace unescaped '%' with '.*' 
		$sp=new StringParser(); 
		$sp->setConfig(array() ,"\\",array()); 
		$sp->setString($str); 
		$str=$sp->replaceCharWithStr("%",".*"); 
		// replace unescaped '_' with '.' 
		$sp->setString($str); 
		$str=$sp->replaceCharWithStr("_","."); 
		$pat = $prefix . $str . $suffix . $mod; 

		// Stash precomputed value 
		$patterns[$value2] = $pat; 
	} 
       
	return preg_match ($pat, $value1); 
}

// splits a full column name into its subparts (name, table, function)
// return true or false on error
function split_full_colname($fullColName,&$colName,&$colTable,&$colFunc) {
	
	$colName="";
	$colTable="";
	$colFunc="";
	
	// direct value ?
	if(is_numeric($fullColName) || has_quotes($fullColName)) {
		$colName=trim($fullColName);
		return true;
	}
	
	if(!is_false ($pos=strpos($fullColName,"(")) ) {
		$colFunc=strtoupper(trim(substr($fullColName,0,$pos)));
		$fullColName=substr($fullColName,$pos+1);
	}

	if(!is_false ($pos=strpos($fullColName,".")) && $colFunc!="EVAL") {
		$colTable=substr($fullColName,0,$pos);
		$colName=substr($fullColName,$pos+1);
	}  else {
		$colName=$fullColName;
	}

	$colName=trim($colName);
	if($colFunc) {
		if(last_char($colName)==")") {
			remove_last_char($colName);
		} else {
			print_error_msg(") expected after $colName!");
			return false;
		}
	}
	$colName=trim($colName);
	$colTable=trim($colTable);
	return true;
}


function execFunc($func, $param) {
	switch($func) {
		case "MD5":
			return doFuncMD5($param);
		case "NOW":
			return doFuncNOW();
		case "UNIX_TIMESTAMP":
			return doFuncUNIX_TIMESTAMP();
		case "ABS":
			return doFuncABS($param);
		case "LCASE":
		case "LOWER":
			return doFuncLCASE($param);
		case "UCASE":
		case "UPPER":
			return doFuncUCASE($param);
		case "INC":
			return $param+1;
		case "DEC":
			return $param-1;
		case "EVAL":
			if(is_empty_str($param))
				return 0;
			return eval("return ($param);");
		default:
			print_error_msg("function '$func' not supported!");
			return $param;
	}
	return $col;
}

function doFuncMD5($param) {
	return md5($param) ;
}

function doFuncNOW() {
	return date("Y-m-d H:i:s",get_static_timestamp());
}

function doFuncUNIX_TIMESTAMP() {
	return get_static_timestamp();
}

function doFuncABS($param) {
	return abs($param);
}

function doFuncLCASE($param) {
	return strtolower($param);
}

function doFuncUCASE($param) {
	return strtoupper($param);
}

function execGroupFunc($func, $params) {
	
	switch($func) {
		//case "":
		//	return $params[0];
		case "MAX":
			return doFuncMAX($params);
		case "MIN":
			return doFuncMIN($params);
		case "COUNT":
			return doFuncCOUNT($params);
		case "SUM":
			return doFuncSUM($params);
		case "AVG":
			return doFuncAVG($params);
			
		default:
			print_error_msg("Function '$func' not supported!!!");
	}
	return $col;
}

function doFuncMAX($params) {
	$maxVal=$params[0];
	for($i=1;$i<count($params);++$i) {
		$maxVal=max($maxVal,$params[$i]);
	}
	return $maxVal;
}

function doFuncMIN($params) {
	$minVal=$params[0];
	for($i=1;$i<count($params);++$i) {
		$minVal=min($minVal,$params[$i]);
	}
	return $minVal;
}

function doFuncCOUNT($params) {
	return count($params);
}

function doFuncSUM($params) {
	$sum=0;
	for($i=0;$i<count($params);++$i) {
		$sum+=$params[$i];
	}
	return $sum;
}

function doFuncAVG($params) {
	$sum=doFuncSUM($params);
	return $sum / count($params);
}

/***********************************
	 	Error Functions
************************************/
function print_error_msg($text, $nr=-1) {
	global $g_txtdbapi_errors;
	
	$g_txtdbapi_errors[]=$text;
	if(!PRINT_ERRORS)
		return;

	if($nr==-1)
		echo "<br><b>Php-Txt-Db-Access Error:</b><br>";
	else
		echo "<br> Php-Txt-Db-Access Error Nr $nr:<br>";
	echo $text . "<br>";	
}

function print_warning_msg($text, $nr=-1) {
	if(!PRINT_WARNINGS)
		return;
		
	if($nr==-1)
		echo "<br><b>Php-Txt-Db-Access Warning:</b><br>";
	else
		echo "<br> Php-Txt-Db-Access Warning Nr $nr:<br>";
	echo $text . "<br>";	
}

// returns true if errors occurred
function txtdbapi_error_occurred() {
	global $g_txtdbapi_errors;
	return (count($g_txtdbapi_errors)>0);
}

function txtdbapi_get_last_error() {
	global $g_txtdbapi_errors;
	if(!txtdbapi_error_occurred())
	    return "";
	return array_pop($g_txtdbapi_errors);
}

function txtdbapi_get_errors() {
	global $g_txtdbapi_errors;
	
	if(!txtdbapi_error_occurred())
	    return array();
	$arr=$g_txtdbapi_errors;
	$g_txtdbapi_errors=array();
	return $arr;
}

function txtdbapi_clear_errors() {
	global $g_txtdbapi_errors;
	$g_txtdbapi_errors=array();
}

// error handler function
function txtdbapi_error_handler ($errno, $errstr, $errfile, $errline) {
	$prefix="PHP Error: ";
	switch ($errno) {
  		case E_USER_ERROR:
    		print_error_msg($prefix . "FATAL [$errno] $errstr [Line: ".$errline."] [File: ". $errfile . "]");
    		break;
  		default:
    		print_error_msg($prefix . "[$errno] $errstr [Line: ".$errline."] [File: ". $errfile . "]");
    		break;
	}
}



/***********************************
	 	Quote Functions
************************************/
function has_quotes($str) {
	if(is_empty_str($str))
		return false;
	return ($str[0]=="'" || $str[0]=="\"") && (last_char($str)=="'" || last_char($str)=="\"");
}

function remove_quotes(&$str) {
	$str=substr($str,1);
	remove_last_char($str);
}

function array_walk_remove_quotes(&$value, &$key) {
	if(has_quotes($value))
		remove_quotes($value);
}


/***********************************
	 	Time Functions
************************************/
function getmicrotime(){ 
    list($usec, $sec) = explode(" ",microtime()); 
    return ((float)$usec + (float)$sec); 
} 

// ensures that all timestamp requests of one execution have the same time
function get_static_timestamp() {
	static $t = 0;
	if($t==0)
		$t=time();
	return $t;
}

?>
