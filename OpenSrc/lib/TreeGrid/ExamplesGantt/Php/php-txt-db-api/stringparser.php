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

/**********************************************************************
							StringParser
***********************************************************************/
// The StringParser can be used to split up a string into it's elements.
// The StringParser uses an array of whitespace chars ($whitespaceChars)
// to split up the string. Escape chars, quotes and special elements 
// (elements which aren't separeted trought whitespaces) are handled.
// For more infos see the comments of the Member Variables and functions.

// HOWTO use the StringParser (Step 2 is optional, you may also use the default parsing-config):
// 1. Get an instance: $sp=new StringParser();
// 2. Set the parsing-config: $sp->setConfig(array("'","\"") ,"\\", array(" ") ,array(),false,true);
// 3. Set the string: $sp->setString("parse me");
// 4. Parse the string with one of the functions, for example parseNextElement()
// NOTE: always call setString() or restart after setConfig, or the new specialElements wont be used!
// The other vars of the parsing-config can be changed on the fly.
// NOTE: the special elements are always case insensitive, and made to UPPERCASE before compared

class StringParser {

    /***********************************
		 	Mebmer Variables
	************************************/
	
	// Parsing Config
	var $quoteChars=array();        // array of 1 char strings with quote chars
	var $escapeChar="";             // 1 char string whith the escape char
	var $whitespaceChars=array();   // array of 1 char strings with whitespace chars
	                                // whitespaces do split up a String into single Elements.
	
	var $specialElements=array();   // array of strings with elements which have to be parsed but are
	                                // not in all cases separated trough whitespaces. for example . or > in SQL.
	                                // The order of the elements is critical, for example add <= before <, 
	                                // because else if a <= is in a string, it will be matched as <
	                                // ONLY set specialElements if you use the functions parse/peek/skipNextElement() !!
	                                
    var $removeQuotes=false;
    var $removeEscapeChars=true;
    
    
    // parseNextChar() state vars
    var $currentPos=-1;             // current parsing position (index into workingStr)
    var $currentChar="";            // current char
    var $inQuotes=array();          // in which Quotes are we ?
    var $lastWasEscape=false;       // the last parsed char was an escape char
    var $currentIsEscape=false;     // the current char is an escape char
    var $currentElement="";         // the current element
    var $elementFinished=false;     // contains currentElement a finished element ?
    
    
    // Internal Vars                        
    var $originalStr;
    var $workingStr;
    var $specialElementsMaxLen=0;
    var $peekCache="";
    
    /***********************************
		 	General functions
	************************************/ 
	
	// Constructor
	function StringParser() {
	    // default config
	    $this->quoteChars=array("'","\"");
	    $this->escapeChar="\\";
	    $this->whitespaceChars=array(" ","\n","\r","\t"); 
	    $this->specialElements=array();
	    $this->peekCache="";
	}
	
	// Set's the current parsing configuration
    // ATTENTION: always call setConfig() before setString() !!!
    function setConfig( $arrQuoteChars=array("'","\"") , $escapeChar="\\", 
                        $arrWhiteSpaceChars=array(" ") , $arrSpecialElements=array(),
                        $removeQuotes=false, $removeEscapeChars=true) {
        $this->quoteChars=$arrQuoteChars;
        $this->escapeChar=$escapeChar;
        $this->whitespaceChars=$arrWhiteSpaceChars;
        $this->specialElements=$arrSpecialElements;
        $this->removeQuotes=$removeQuotes;
        $this->removeEscapeChars=$removeEscapeChars;

    }
	
	// Set's the String which has to be parsed
	// If you want another parsing-config then the default config, call
	// setConfig() before setString(), or the specialElements won't be 
	// correctly handled
    function setString($str) {
        $this->originalStr=$str;
        $this->restart();
    }
    
       
    // (Re)starts parsing, $workingStr is replaced with $originalStr	
    // calculates specialElementsMaxLen and reset's the parseNextChar()
    // state vars
    function restart() {
        $this->workingStr=$this->originalStr; 
        
        //calc specialElementsMaxLen
        $this->specialElementsMaxLen=0;
        for($i=0;$i<count($this->specialElements);++$i) {
            $len=strlen($this->specialElements[$i]);
            if($len>$this->specialElementsMaxLen) {
                $this->specialElementsMaxLen=$len;
            }
        }
        verbose_debug_print("specialElementsMaxLen: " . $this->specialElementsMaxLen . "<br>");
        
        // reset parseNextChar() state vars
        $this->currentPos=-1;
        $this->currentChar="";
        $this->inQuotes=create_array_fill(count($this->quoteChars), 0);
        $this->lastWasEscape=false;
        $this->currentIsEscape=false;
        $this->currentElement="";
        $this->elementFinished=false;
        
        $this->peekCache="";
    }
    
    
	/***********************************
		 	Parsing functions
	************************************/
	
	// parses the next char and appends it to $this->currentElement and updates the 
	// parseNextChar() state vars
	// returns false if the end of the string is reached, if all went ok true is returned
	// this function is a helper for all other parsing functions.
	// use it directly ONLY if you have NO specialElements defined!
	function parseNextChar() {
	   
        if(! (++$this->currentPos<strlen($this->workingStr)))
	        return false;
	        
        $this->currentChar=$this->workingStr{$this->currentPos};
        $c=$this->currentChar;
        verbose_debug_print("<hr>");
		verbose_debug_print("StringParser:: current char: '" . $c . "' <br>");
		
		// update escape char tracking vars
		if($this->currentIsEscape) {
		    $this->lastWasEscape=true;
		    $this->currentIsEscape=false;
		} else {
		    $this->lastWasEscape=false;
		    $this->currentIsEscape=false;
		}
		
		// escape char:
		if($c==$this->escapeChar) {
		    verbose_debug_print("StringParser:: escape char matched: " . $c . "<br>");
		    // last was escape: 2 escape chars => the char is used, and the escapement meaning is lost
		    if($this->lastWasEscape) {
		        $this->currentIsEscape=false;
		        $this->lastWasEscape=false;
		        $this->currentElement.=$c;
		    // last was not escape, so the current has escape meaning
		    }  else {
		        $this->currentIsEscape=true;
		        // add only if we don't remove escape chars
		        if(!$this->removeEscapeChars) {
			        $this->currentElement.=$c;
		        }
            }
		    return true;
		}
		
		
		// handle quote chars (only if the last was no escape char)
		if(!$this->lastWasEscape) {
		    for($j=0;$j<count($this->quoteChars);++$j) {
			    if($c==$this->quoteChars[$j]) {
			        
		            // are we in this quotes OR not in other quotes => swap quote var
		            if($this->inQuotes[$j] || is_false(in_array(1,$this->inQuotes))) {
		                $this->inQuotes[$j]= !$this->inQuotes[$j];
		                // add only if $this->removeQuotes isn't set
		                if(!$this->removeQuotes) {
		                    $this->currentElement.=$c;
		                }
		            // else ignore the quotes meaning, but add it anyway
		            } else {
		                $this->currentElement.=$c;
		            }
		            return true; 			   
		        }
            }
        }
        
        // handle whitespace chars (if we are not in quotes)
        if(is_false(in_array(1,$this->inQuotes))) {
            for($j=0;$j<count($this->whitespaceChars);++$j) {
                if($c==$this->whitespaceChars[$j]) {
                    verbose_debug_print("StringParser:: whitespace matched: '" . $c . "' nr: " . $j . "<br>");
                    // whitespace found, return element if the strlen() is > 0
                    if(strlen($this->currentElement)>0) {
                       //++$this->currentPos; // skip the whitespace
                       // break all for's an return $element:
                       //break 2;
                       $this->elementFinished=true;
                       return true;
                    }
                    // ignore the whitespace => continue
                    return true;
                }
            }
        } 
        
        // search for specialElements, but only if we are not in quotes
        if(is_false(in_array(1,$this->inQuotes))) {
            $testStr=substr($this->workingStr,$this->currentPos,$this->specialElementsMaxLen);
            verbose_debug_print("StringParser:: testStr is " . $testStr . "<br>");
            if(!is_false($specialElem=array_search_stri_start($testStr,$this->specialElements))) {
                verbose_debug_print("special Element found: " . $specialElem . "<br>");
                // specialElement found!
                // strlen(element)>0 ? return current element 
                if(strlen($this->currentElement)>0) {
                    verbose_debug_print("returning last Element !<br>");
                    $this->elementFinished=true;
                    --$this->currentPos;
                    return true;
				    
				// make the specialElement the current element and return it
			    } else {
			        verbose_debug_print("returning specialElement !<br>");
					$this->currentElement=$specialElem;
					$this->currentPos+=strlen($specialElem);
					--$this->currentPos;
				    $this->elementFinished=true;
				    return true;
			    }
            }
        }
            
        // none of the previous tests matches, add the current char to the element
        verbose_debug_print("StringParser:: normal char...<br>");
        $this->currentElement.=$c;
        return true;
               
    } // function
			

	
	
	
    // returns the next Element and remove's it
    function parseNextElement() {   
                
        if(!is_empty_str($this->peekCache)) {
        	verbose_debug_print("<font color='green'>StringParser:: cache hit for " .  $this->peekCache . "</font><br>");
        	$tmp=$this->peekCache;
        	$this->peekCache="";
        	return $tmp;
        }
        
        $this->currentElement="";
        while($this->parseNextChar() && !$this->elementFinished) {        
            
        }
           
        verbose_debug_print( "StringParser:: workingStr before: '" . $this->workingStr . "'<br>");
        
        
      
        // remove
		$this->workingStr=substr($this->workingStr,$this->currentPos);
		
		verbose_debug_print( "StringParser:: workingStr after: '" . $this->workingStr . "'<br>");
		verbose_debug_print( "StringParser:: returning Element: '<b><k><font color='red'>" . $this->currentElement . "</font></b></k>'<br>");
		$this->currentPos=0;
		$this->elementFinished=false;
		return $this->currentElement;
        
    } // function
    
    
    // returns the next Element but doesn't remove it
    function peekNextElement() {
    	if(!is_empty_str($this->peekCache)) {
    		verbose_debug_print("<font color='green'>StringParser:: cache hit for " .  $this->peekCache . "</font><br>");
    		return $this->peekCache;
    	}
    	$this->peekCache=$this->parseNextElement();
        return $this->peekCache;
    }
    
    // skips the next Element
    function skipNextElement() {
    	if(!is_empty_str($this->peekCache)) {
    		verbose_debug_print("<font color='green'>StringParser:: nothing to skip, erasing cache...</font><br>");
    		$this->peekCache="";
    		return;
    	}
        $this->parseNextElement();
    }
    
    // parses the next Elements until $separatorElement or one of the $finishElements
    // it found.
    // The parsed values are returned in the array $arrParsedElements
    // Returns true if elements were parsed, else false is returned
    function parseNextElements($separatorElement,$finishElements, &$arrParsedElements) {
    	$arrParsedElements=array();
    	while(!is_empty_str($elem=$this->peekNextElement())) {
    		
    		if(strtoupper($elem)==strtoupper($separatorElement)) {
    			$this->skipNextElement();
    			break;
    		}
    		for($i=0;$i<count($finishElements);++$i) {
    			if(strtoupper($elem)==strtoupper($finishElements[$i])) {
    				break 2;
    			}
    		}
    		$arrParsedElements[]=$elem;
    		$this->skipNextElement();
    	}
    	if(count($arrParsedElements)>0)
    		return true;
    	return false;
    }




    /***********************************
		 	Replace functions
	************************************/
	
    // returns a String where $searchChar is replaced with replaceStr,
    // expect places where $searchChar is escaped
    // make sure that NO specialElements are set, else this function will not work correctly.
    function replaceCharWithStr($searchChar,$replaceStr) {
        $this->restart();
        $resStr="";
        while($this->parseNextChar()) {
            $c=$this->currentChar;
            if($searchChar==$c && !$this->lastWasEscape) {
                $resStr.= $replaceStr;
            } else {
                $resStr .= $c;
            }  
        }
        return $resStr;     
    }
    
    
    /***********************************
		 	Split functions
	************************************/
	
	// returns an array with the splitted strings.
    // The specialElements are used to split the string up.
    // You may also define quoteChars and escapeChar so no specielElements 
    // in Quotes are used. But do NOT set any whitespaceChars!
    function splitWithSpecialElements() {
        $arr=array();
        $arrPos=0;
 
        while($elem=$this->parseNextElement()) {
            $isSpecial=false;
            verbose_debug_print("splitWithSpecialElements elem: " . $elem . "<br>");
            for($i=0;$i<count($this->specialElements);++$i) {
                if(strtoupper($elem)==strtoupper($this->specialElements[$i])) {
                    $isSpecial=true;
                    break;    
                }
            }
            if($isSpecial) {
                $arr[++$arrPos]="";      
            } else {
            	if(!isset($arr[$arrPos])) // pos 0 bugfix...
            		$arr[$arrPos]="";
            		
                $arr[$arrPos].=$elem;  
            }
        }        
        return $arr;
    }
    
    
    // same as splitWithSpecialElements, but you have to pass an array
    // as parameter, which is filled with the specialElements which
    // where found in the string and used to split (all are in UPPERCASES).
    function splitWithSpecialElementsRetUsed(&$arrUsedSpecElements) {
        $arr=array();
        $arrPos=0;
 
        while($elem=$this->parseNextElement()) {
            $isSpecial=false;
            verbose_debug_print("splitWithSpecialElementsRetUsed elem: " . $elem . "<br>");
            for($i=0;$i<count($this->specialElements);++$i) {
                if(strtoupper($elem)==strtoupper($this->specialElements[$i])) {
                    $isSpecial=true;
                    if(!in_array(strtoupper($this->specialElements[$i]),$arrUsedSpecElements)) {
                        $arrUsedSpecElements[]=strtoupper($this->specialElements[$i]);
                    }
                    
                    break;    
                }
            }
            if($isSpecial) {
                $arr[++$arrPos]="";      
            } else {
            	if(!isset($arr[$arrPos])) // pos 0 bugfix...
            		$arr[$arrPos]="";
                $arr[$arrPos].=$elem;  
            }
        }        
        return $arr;
    }
    
}   

		
?>