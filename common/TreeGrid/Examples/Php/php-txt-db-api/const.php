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

/***********************************
		 	User Settings
************************************/

$DEBUG=0;				    // 0=Debug disabled, 1=Debug enabled
$LIKE_CASE_SENSITIVE=0;     // 0=LIKE is case insensitive, 1=LIKE is case sensitive
$ORDER_CASE_SENSITIVE=0;	// 0=ORDER BY is case insensitive, 1=ORDER BY is case sensitive
$ASSUMED_RECORD_SIZE=30;    // Set this to the average size of one record, if in doubt 
                            // leave the default value. DON'T set it to <1! int's only!
$PRINT_ERRORS=1;			// 0 = Errors are NOT displayed, 1 = Errors are displayed
$PRINT_WARNINGS=0;			// 0 = Warnings are NOT displayed, 1 = Warnings are displayed



/***********************************
		 	Constants 
************************************/
// Don't change them, expect you know
// what you do!

// Define User Settings
define("LIKE_CASE_SENSITIVE",$LIKE_CASE_SENSITIVE);
define("ORDER_CASE_SENSITIVE",$ORDER_CASE_SENSITIVE);
define("TXTDBAPI_DEBUG",$DEBUG);

// Even more Debug Infos ?
define("TXTDBAPI_VERBOSE_DEBUG",0);

// This constant doesn't limit the max size of a record it's only the assmued size 
// of a record when a table is read for appending. If not a whole record is
// contained in ASSUMED_RECORD_SIZE bytes, the the number of bytes read 
// is increased until a whole record was read. Choosing this value wisely may
// result in a better INSERT performance
define("ASSUMED_RECORD_SIZE",$ASSUMED_RECORD_SIZE);

define("PRINT_ERRORS",$PRINT_ERRORS);
define("PRINT_WARNINGS",$PRINT_WARNINGS);

// Version
define("TXTDBAPI_VERSION","0.3.1-Beta-01");

// General
define("NOT_FOUND",-1);

// File parsing
define("COLUMN_SEPARATOR_CHAR",'#');	// Char which seperates the columns in the table file
										// This MUST be a sigle character and NOR a string
define("TABLE_FILE_ESCAPE_CHAR",'%'); 	// Char to Escape COLUMN_SEPARATOR_CHAR in the Table Files
define("TABLE_FILE_OPEN_MODE",'b'); 	// "b" or ""

// Timeouts
define("OPEN_TIMEOUT",10); 		// Timeout in seconds to try opening a still locked Table
define("LOCK_TIMEOUT",10); 		// Timeout in seconds to try locking a still locked Table
define("LOCKFILE_TIMEOUT",30); 	// Timeout for the maximum time a lockfile can exist

// Predefined Databases
define("ROOT_DATABASE","");

// Order Types
define("ORDER_ASC",1);
define("ORDER_DESC",2);

// Join Types
define("JOIN_INNER",1);
define("JOIN_LEFT",2);
define("JOIN_RIGHT",3);

// Row Flags
define("FLAG_KEEP",0x1);

// Column Types
define("COL_TYPE_INC","inc");
define("COL_TYPE_INT","int");
define("COL_TYPE_STRING","str");

// Column Function Types
define("COL_FUNC_TYPE_SINGLEREC",1);
define("COL_FUNC_TYPE_GROUPING",2);

// File Extensions
define("TABLE_FILE_EXT",".txt");
define("LOCK_FILE_EXT",".lock");


?>
