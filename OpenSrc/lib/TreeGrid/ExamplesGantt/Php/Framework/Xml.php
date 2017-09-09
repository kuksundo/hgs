<?
// -----------------------------------------------------------------------------------------------------------
// Independent file with functions for simulation XML by PHP object
// -----------------------------------------------------------------------------------------------------------

// -----------------------------------------------------------------------------------------------------------
function UnEsc($str){
   if(strpos($str,"&")===false) return $str;
   return str_replace("&#x0A;","\n",str_replace("&apos;","'",str_replace("&quot;","\"",str_replace("&gt;",">",str_replace("&lt;","<",str_replace("&amp;","&",$str))))));
   }
// -----------------------------------------------------------------------------------------------------------
function &CreateXmlFromString($str){
$iter=2;

$pred = "/(\\w*)\\s*"; $po = "(\\/)?\\>(.*)/";
$S = "(?:(\\w*)\\s*\\=\\s*\\'([^\\']*)\\'\\s*)?(?:(\\w*)\\s*\\=\\s*\\\"([^\\\"]*)\\\"\\s*)?";
$II = Array(0,1,2,4,8,16,32,64,128,256);
$R = Array(); $I = Array();
$R[0] = $pred.$po; $I[0] = 0; $I[1] = 1; 
for($i=1;$i<8;$i++){ // max 128 atributu (PHP ma max 99)
   $R[$i] = $pred.$S.$po;
   $S.=$S; 
   for($j=$II[$i]+1;$j<=$II[$i+1];$j++) $I[$j] = $i+1;
   } 
$S = null;
   
if(preg_match("/^\\s*\\&lt\\;/",$str)) $str = UnEsc($str); // pokud je retezec kodovan

$Doc = new TXmlDocument(); $P = 0;

$A = explode("<",$str); $alen = count($A);

for($i=0;$i<$alen;$i++){ // jednotlive tagy, vcetne atributu a textu
   if(!$A[$i]) continue;
   $c = $A[$i]{0};
   if($c=='/'){ $P = $Doc->parentNode[$P]; if($P==null) break; } // ukoncovaci tag
   else if($c=='?' || $c=='!') continue; // ridici tag
   else {  // pocatecni tag
      $M = explode("=",$A[$i]);
      $len = $M ? count($M):0; if($len>128) $len=128;
      $ff = ($II[$I[$len]]*4);
      if($iter==3) $ff = $ff*3/2+2;
      else $ff+=2;
      if(!preg_match($R[$I[$len]],$A[$i],$T)) return null;
      $D = $Doc->createElement($T[1]);
      $Doc->appendChild($P,$D);
      for($t=$iter;($T[$t]||$T[$t+$iter]) && $t<$ff;$t+=$iter) if($T[$t]) $Doc->setAttribute($D,$T[$t],UnEsc($T[$t+1]));           // Atributy
      if($T[$ff+1]) $Doc->appendChild($D,$Doc->createTextNode(UnEsc($T[$ff+1]))); // Text
      if(!$T[$ff]) $P = $D; // chybi ukonceni '/' => vnoreni o 1 uroven dolu
      }
   }
if($P) return null; // chybi nejaky ukoncovaci tag
$Doc->documentElement = 1;
return $Doc;
}
// -----------------------------------------------------------------------------------------------------------



// -----------------------------------------------------------------------------------------------------------
//                                                 TXmlDocument
// -----------------------------------------------------------------------------------------------------------

class TXmlDocument {

var $Idx; // Volny index
   
var $documentElement; // Document element

var $nodeName;
var $tagName;
var $nodeType;
var $nodeValue;

var $attributes;

var $firstChild;
var $lastChild;
var $nextSibling;
var $previousSibling;
var $parentNode;
 
function TXmlDocument() {
  $this->__construct();
  }
// -----------------------------------------------------------------------------------------------------------
function __construct(){
$this->Idx = 1;
$firstChild[0] = null;
$lastChild[0] = null;
$nextSibling[0] = null;
$previousSibling[0] = null;
$parentNode[0] = null;
}
// -----------------------------------------------------------------------------------------------------------
function createElement($name){ 
$this->nodeType[$this->Idx] = 1;
$this->nodeName[$this->Idx] = $name;
$this->tagName[$this->Idx] = $name;
$this->Idx+=1;
return $this->Idx-1;
}
// -----------------------------------------------------------------------------------------------------------
function createTextNode($text){
$this->nodeType[$this->Idx] = 3;
$this->nodeName[$this->Idx] = "#text";
$this->tagName[$this->Idx] = "#text";
$this->nodeValue[$this->Idx] = $text;
$this->Idx+=1;
return $this->Idx-1;
} 
// -----------------------------------------------------------------------------------------------------------
function getAttribute($I,$name){ 
return $this->attributes[$I][$name];
}
// -----------------------------------------------------------------------------------------------------------
function setAttribute($I,$name,$val){ 
$this->attributes[$I][$name] = $val;
}
// -----------------------------------------------------------------------------------------------------------
function removeAttribute($I,$name){ 
$this->attributes[$I][$name] = null;
}
// -----------------------------------------------------------------------------------------------------------
function hasAttribute($I,$name){ 
return $this->attributes[$I][$name] != null;
}
// -----------------------------------------------------------------------------------------------------------
function removeChild ($N){ 
if(!$N || $N<0 || $N>=$this->Idx) return null;
$T = $this->parentNode[$N]; if(!$T) return null;

if(empty($this->previousSibling[$N])) $this->firstChild[$T] = $this->nextSibling[$N];
else $this->nextSibling[$this->previousSibling[$N]] = $this->nextSibling[$N];

if(empty($this->nextSibling[$N])) $this->lastChild[$T] = $this->previousSibling[$N];
else $this->previousSibling[$this->nextSibling[$N]] = $this->previousSibling[$N];

$this->previousSibling[$N] = null;
$this->nextSibling[$N] = null;
$this->parentNode[$N] = null;

return $N;
} 
// -----------------------------------------------------------------------------------------------------------
function appendChild($T,$N){ 
if(!$N || $N<0 || $N>=$this->Idx || $T<0 || $T>=$this->Idx) return null;
if(!empty($this->parentNode[$N])) $this->removeChild($N);
    
if(!empty($this->lastChild[$T])){
   $this->nextSibling[$this->lastChild[$T]] = $N;
   $this->previousSibling[$N] = $this->lastChild[$T];
   }
else { 
   $this->firstChild[$T] = $N; 
   $this->previousSibling[$N] = null; 
   }
$this->lastChild[$T] = &$N;
$this->nextSibling[$N] = null;
$this->parentNode[$N] = $T;
return $N;
}

// -----------------------------------------------------------------------------------------------------------
function insertBefore($N,$B){ 
if(!$N || $N<0 || $N>=$this->Idx || !$B || $B<0 || $B>=$this->Idx) return null;
$T = $this->parentNode[$B]; if(!$T) return null;
if(!empty($this->parentNode[$N])) $this->removeChild($N);

if(!empty($this->previousSibling[$B])){ 
   $this->nextSibling[$this->previousSibling[$B]] = $N;
   $this->previousSibling[$N] = $this->previousSibling[$B];
   }
else{ 
   $this->firstChild[$T] = $N;
   $this->previousSibling[$N] = null;
   }
$this->previousSibling[$B] = $N;
$this->nextSibling[$N] = $B;
$this->parentNode[$N] = $T;
return $N;
}
// -----------------------------------------------------------------------------------------------------------
function &getElementsByTagName($N,$name){ 
if(!$N){ 
   $N = $this->documentElement;
   if(!$N) return null;
   }
//$A = Array();
if(!empty($this->firstChild[$N])) for($r=$this->firstChild[$N];$r;$r=$this->nextSibling[$r]){
   if($this->nodeName[$r]==$name || $name=='*') $A[] = $r;
   if(!empty($this->firstChild[$r])){
      $B = &$this->getElementsByTagName($r,$name);
      $len = count($B);
      for($i=0;$i<$len;$i++) $A[] = $B[$i];
      }
   }
return $A;
}

// -----------------------------------------------------------------------------------------------------------
function getXml($N){ 
if(!$N){ 
   $N = $this->documentElement;
   if(!$N) return "";
   }
if($this->nodeType[$N]==3) return str_replace("<","&lt;",str_replace("&","&amp;",$this->nodeValue[$N]));
$S = "";
$S .= "<".$this->nodeName[$N];
if(!empty($this->attributes[$N])) foreach($this->attributes[$N] as $n => $v){
   $S .= " " . $n . "=\"" . str_replace("\n","&#x0A;",str_replace("\"","&quot;",str_replace("<","&lt;",str_replace("&","&amp;",$v)))) . "\"";
   }   
if(!empty($this->firstChild[$N])){
   $S .= ">";
   for($r=$this->firstChild[$N];$r;$r=$this->nextSibling[$r]) $S .= $this->getXml($r);
   $S .= "</".$this->nodeName[$N].">";
   }
else $S .= "/>";
return $S;
} 
// -----------------------------------------------------------------------------------------------------------
}
?>