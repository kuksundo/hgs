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
					Master Include File (Users)
***********************************************************************/

/**********************************************************************
	Essential Properties (MUST BE SET BEFORE THE API CAN BE USED)
***********************************************************************/

// Directory where the API is located (Server Path, no URL)

$API_HOME_DIR="php-txt-db-api/";	



// Directory where the Database Directories are located
// THIS IS NOT THE FULL PATH TO A DATABASE, ITS THE PATH
// TO A DIRECTORY CONTAINING 1 OR MORE DATABASE DIRECTORIES
// e.g. if you have a Database in Directory /home/website/test/TestDB
// you must set this property to /home/website/test/ 		

$DB_DIR="";			




// ----------- IGNORE FROM HERE (Users) --------------
if(!defined("API_HOME_DIR")) 			define("API_HOME_DIR" ,$API_HOME_DIR);
if(!defined("DB_DIR")) 					define("DB_DIR" ,$DB_DIR);

/**********************************************************************
								Includes
***********************************************************************/

include_once(API_HOME_DIR . "resultset.php");
include_once(API_HOME_DIR . "database.php");


?>