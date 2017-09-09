// Include this file instead of GridE.js if you want to download the script only on demand
// When you will want to create and show TreeGrids on your page, load GridE.js by calling the LoadGridE() function
// The path is url of GridE.js file like "../Grid/GridE.js".
// The path can be relative to the main page url as usual or can be absolute
// For empty path is used the path to the GridEOnDemand.js if exists
// Check the script path carefully, the most errors are caused because of wrong path
// The LoadGridE is asynchronous function, set func to be called after the script is loaded

function LoadGridE(path, func){
if(LoadGridE.Loaded!=null) return;
if(!path) { 
   var S = document.getElementsByTagName("script");
   for(var i=0;i<S.length;i++){
      if(S[i].src && S[i].src.indexOf("GridEOnDemand.js")>=0){
         path = S[i].src.replace("GridEOnDemand.js","GridE.js"); break;
         }
      }
   if(!path){ alert("Cannot download TreeGrid script!\r\n\r\nThe script path is empty"); return; }
   }
try {
   var script = document.createElement("script");
   script.type = "text/javascript";
   script.src = path;
   document.documentElement.getElementsByTagName("head")[0].appendChild(script);
   LoadGridE.Loaded = false;
   function Finish(){
      if(window.StartTreeGrid) { StartTreeGrid(); if(func) func(); }
      else setTimeout(Finish,100);
      }
   Finish();   
   }
catch(e){
   alert("Cannot download TreeGrid script!\r\n\r\nError message:\r\n"+(e.message ? e.message:e));
   }
}


if(!window.Grids){ 
   var Grids = new Array();
   Grids.OnDemand = true;
   }
if(!window.TCalc) { 
   var TCalc = function(){ };
   TCalc.OnDemand = true;
   }
