<?php
header("Content-Type: text/xml; charset=utf-8"); 
header("Cache-Control: max-age=1; must-revalidate");

// --------------------------------------------------------------------------  
// Adds files from the Path directory
// Calls AddDir for all subdirectories
function AddDir($Base,$Path){
$dir = scandir("$Base$Path");
foreach($dir as $file){
    if($file=="." || $file=="..") continue;
    if(is_dir("$Base$Path/$file")) AddDir("$Base","$Path/$file");
    else{
        $path = pathinfo("$Base$Path/$file");
        echo("<I P=\"" . substr($path["dirname"],strlen($Base)+1) . "\" N=\"" .$path["filename"]. "\" E=\"" . $path["extension"] . "\" />");
        }
    }

}
// -------------------------------------------------------------------------- 
$Base = dirname(__FILE__) . "/TestFiles";  

// --- Generating data ---
echo("<Grid><Body><B>");
AddDir($Base,"");
echo("</B></Body></Grid>");
// --------------------------------------------------------------------------
?>