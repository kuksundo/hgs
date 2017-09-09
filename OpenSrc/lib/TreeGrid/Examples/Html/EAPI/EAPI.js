// --------------------------------------------------------------------------------------------------------------------------
// Support script for Extended API demonstration
// --------------------------------------------------------------------------------------------------------------------------

// --------------------------------------------------------------------------------------------------------------------------
var IDisable, IStyle, IFunc, DLog; // Pointers to html controls
var FRow;                   // Actual focused row for update
var Path = GetElem("MenuAll") ? "../" : "../../../";  // Path to root folder, it is different when shown on TreeGrid homepage

// --------------------------------------------------------------------------------------------------------------------------



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                                  Main and starting functions
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// --------------------------------------------------------------------------------------------------------------------------
// Creates grid from JavaScript
function SpecStart(){

// --- Prepares and clears controls on pages ---
DLog = GetElem("LOG");
IStyle = GetElem("IStyle");
IDisable = GetElem("IDisable");
DLog.value = "";
IDisable.checked = false;
IStyle.checked = false;
GetElem("IColor").value = "hdd";
GetElem("SData").selectedIndex = 0;
if(!window.IFunc) IFunc = GetElem("IFunc");
if(!window.IStyle) IStyle = GetElem("IStyle");
if(!window.IDisable) IDisable = GetElem("IFunc");

// --- creates grid ---
var D = new TDataIO();   // new object for communication
D.Layout.Url = Path+"Examples/Html/BasicAjax/FirstDef.xml";  // Initialization with these data
D.Data.Url = Path+"Examples/Html/BasicAjax/FirstData.xml"; 
D.Defaults.Bonus="<Grid><Cfg MinTagHeight='410'/><LeftCols><C Name='id' CanEdit='0'/></LeftCols><Header id='id'/></Grid>"; // To every example adds column with row ids
D.Upload.Url = "dummy";
D.Debug = "check";

if(location.protocol=="http:"){ // Exports only when run on server, uses ASP.NET
   D.Export.Url = Path+"Examples/AspNetCS/Framework/Export.aspx";
   D.Export.Data = "TGData";
   }
SpecResize();                // User function to resize main tag to resize it to whole window
Log("Loading First example",1,"blue");
TreeGrid(D,"GRID");      // Creates new grid, this grid will now be accessed from Grids[0] property 
}
// --------------------------------------------------------------------------------------------------------------------------
// Loads data chosen from the first combo
function LoadData(){
var idx = GetElem("SData").selectedIndex; // The first combo, contains selected data
var Def = [   // Def contain layout definitions, for examples only, for tutorials is used only data file
   "FirstDef.xml","AjaxDef.xml","TableDef.xml","BooksDef.xml","LargeDef.xml",
   "GanttDef.xml","GanttBigDef.xml","GanttTreeDef.xml","../Run/RunDef.xml",
   "UnknownDef.xml"
   ];
var Data = [ // Data contain data xml, for examples there are also used layouts from Def, for tutorials this is the only data
   "FirstData.xml","AjaxData.xml","TableData.xml","BooksData.xml","LargeData.xml",
   "GanttData.xml","GanttBigData.xml","GanttTreeData.xml","../Run/RunData.xml",
   "UnknownData.xml"
   ];
   
var G = Grids[0];
var D = G.Data;
if(idx>=5&&idx<=8){ // Gantt
   D.Layout.Url = Path+"ExamplesGantt/Html/Gantt/"+Def[idx];
   D.Data.Url = Path+"ExamplesGantt/Html/Gantt/"+Data[idx];
   }
else { // Examples
   D.Layout.Url = Path+"Examples/Html/BasicAjax/"+Def[idx];
   D.Data.Url = Path+"Examples/Html/BasicAjax/"+Data[idx];
   }   

if(location.protocol=="http:"){ // Export only on server, uses ASP.NET
   D.Export.Url = Path+"Examples/AspNetCS/Framework/Export.aspx";
   D.Export.Data = "TGData";
   }

D.Data.Bonus="<Grid><Cfg MaxWidth='0' MaxHeight='0'/></Grid>";  // Suppresses MaxHeigth and MaxWidth for any data that has them set, because main tag is positioned in <TABLE> and sets selected style

G.Reload(null,"");  // Reloads new data to grid 
FRow = null; // Nulls FRow - no focused row in grid
}
// --------------------------------------------------------------------------------------------------------------------------
// Called when window is resized to set extents of the grid to maximize its area
function SpecResize(){
var D = GetElem("GRID");
var R = GetElem("RIGHT");
var B = GetElem("Body"); // Just from TreeGrid homepage
var S = B?[B.offsetWidth,B.offsetHeight]:GetWindowSize();
if(S[0]<800){ S[0] = 800; document.body.style.width = "800px"; }
D.style.width = (S[0] - 250)+"px";
var h = S[1] - 270 - D.parentNode.offsetTop;
if(h<R.offsetHeight) h = R.offsetHeight;
if(h<400) h = 400;
D.style.height = h+"px";
}
// --------------------------------------------------------------------------------------------------------------------------
// Helper function, logs string to LOG DIV
function Log(str,ln,color,size){
if(IDisable.checked) return;
var D = document.createElement(ln?"DIV":"SPAN");
D.innerHTML = str+(ln?"":"; ");
if(color) D.style.color = color;
if(size) D.style.fontSize = size;
DLog.appendChild(D);
DLog.scrollTop = 10000;
}
// --------------------------------------------------------------------------------------------------------------------------
// Helper function, escapes the string for using in XML/HTML (to display in log)
function Esc(str){
if(typeof(str)!="string") return str+"";
if(str.length>150) str = str.slice(0,150)+" ... ";
return str.replace(/&/g,"&amp;").replace(/</g,"&lt;");
}
// --------------------------------------------------------------------------------------------------------------------------














// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                                  Event handlers
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// --------------------------------------------------------------------------------------------------------------------------
//                                               Style event handlers
// --------------------------------------------------------------------------------------------------------------------------

Grids.OnGetHtmlValue = function(G,row,col,val){ if(IStyle.checked) Log("OnGetHtmlValue("+row.id+","+col+",...)",0,"#AAC"); }
Grids.OnGetColor = function(G,row,col,r,g,b,type){ 
   if(IStyle.checked) Log("OnGetColor("+row.id+","+col+","+r+","+g+","+b+","+type+")",0,"#CAC");
   if(row[col+"Marked"] && !type) return "rgb("+r+","+(g-64)+","+b+")"; // Checks custom attribute set by function Color
   if(G.id=="Books" && !Get(row,"Spanned")) return "rgb("+r+","+g+","+(b-20)+")";// Support function for particular example
}
Grids.OnGetDefaultColor = function(G,row,col,rgb){ if(IStyle.checked) Log("OnGetDefaultColor("+row.id+","+col+","+rgb+")",0,"#CAC"); }
Grids.OnGetClass = function(G,row,col,cls){ if(IStyle.checked) Log("OnGetClass("+row.id+","+col+","+cls+")",0,"#ACC"); return cls; }
Grids.OnGetType = function(G,row,col,type){ if(IStyle.checked) Log("OnGetType("+row.id+","+col+","+type+")",0,"#CCA"); return type; }
Grids.OnGetFormat = function(G,row,col,format,edit){ if(IStyle.checked) Log("OnGetFormat("+row.id+","+col+","+format+","+edit+")",0,"#CAA"); return format; }
Grids.OnGetEnum = function(G,row,col,enuma){ if(IStyle.checked) Log("OnGetEnum("+row.id+","+col+","+enuma+")",0,"#ACA"); return enuma; }
Grids.OnGetEnumKeys = function(G,row,col,enuma){ if(IStyle.checked) Log("OnGetEnumKeys("+row.id+","+col+","+enuma+")",0,"#ACA"); return enuma; }
Grids.OnGetEditEnum = function(G,row,col,enuma){ Log("OnGetEditEnum("+row.id+","+col+","+enuma+")",1,"#AAA"); return enuma; }
Grids.OnGetEnumMenu = function(G,row,col,enuma){ Log("OnGetEnumMenu("+row.id+","+col+","+enuma+")",1,"#AAA"); return enuma; }

Grids.OnCanEdit = function(G,row,col,can){ 
   if(IStyle.checked) Log("OnCanEdit("+row.id+","+col+","+can+")",0,"#AAC");
   if(G.id=="Books" && row.id=='B' && col=='B') return 1;// Support function for particular example
   return can;
}
Grids.OnCanEditDate = function(G,row,col,date){ if(IStyle.checked) Log("OnCanEditDate("+row.id+","+col+","+date+")",0,"#AAC"); return true; }
Grids.OnGetDefaults  = function(G,row,col,defaults){ Log("OnGetDefaults("+row.id+","+col+","+defaults+")",0,"#AAA"); return defaults; }

Grids.OnGetSuggest = function(G,row,col,suggest){ Log("OnGetSuggest("+row.id+","+col+","+suggest+")",0); return suggest; }
Grids.OnSuggest = function(G,row,col,val,suggest){ Log("OnSuggest("+row.id+","+col+","+val+")",0); }

// --------------------------------------------------------------------------------------------------------------------------
//                                                 State event handlers
// --------------------------------------------------------------------------------------------------------------------------

Grids.OnValueChanged = function(G,row,col,val){
   Log("OnValueChanged: User <b>set value</b> in cell ["+row.id+","+col+"], from value '"+Esc(G.GetString(row,col))+"' to '"+Esc(val)+"'.",1);
   if(G.id=="Books" && row.id=='B' && col=='B') EditChange(val);// Support function for particular example
   return val;
}
Grids.OnAfterValueChanged = function(G,row,col){ Log("OnAfterValueChanged: User <b>CHANGED value</b> in cell ["+row.id+","+col+"] to '"+G.GetString(row,col)+"'.",1); }
Grids.OnResultMask = function(G,row,col,val){ Log("OnResultMask: Value '"+Esc(val)+"' tried to save to cell ["+row.id+","+col+"] collides with mask.",1,"red"); return 0; }
Grids.OnRowMoveToGrid = function(G,row,togrid,torow,copy){ /* not used in this example */ }
Grids.OnRowMove = function(G,row,oldparent,oldnext){
   var log = "OnRowMove: User <b>MOVED row</b> '"+row.id+"' ";
   if(oldparent==row.parentNode) log+="inside "+(oldparent.tagName=='I'?"parent row '"+oldparent.id+"'":"root");
   else log+="from "+(oldparent.tagName=='I'?"parent row '"+oldparent.id+"'":"root")+" to "+(row.parentNode.tagName=='I'?"parent row '"+row.parentNode.id+"'":"root");
   log+=" "+(row.nextSibling?"before row '"+row.nextSibling.id+"'":"as the last row");
   Log(log,1);
}
Grids.OnStartDrag = function(G,row,col,more){ Log("OnStartDrag: User <b>begins dragging</b> in cell ["+row.id+","+col+"]",1); }
Grids.OnCanDrop = function(G,row,togrid,torow,type){ /* log is not used due too many statements */ return type; }
Grids.OnEndDrag = function(G,row,togrid,torow,type,x,y){ if(!type) Log("OnEndDrag: User <b>cancelled dragging</b>",1); else Log("OnEndDrag: User <b>dropped row</b> "+["","above","into children of","below"][type]+" row "+torow.id,1); }
Grids.OnRowDelete = function(G,row,type){ Log("OnRowDelete: User <b>DELETED row</b> '"+row.id+"'.",1); }
Grids.OnCanRowDelete = function(G,row,type){ Log("OnCanRowDelete: User tries to <b>"+(type!=3?"DELETE":"UNDELETE")+" row</b> '"+row.id+"'.",1); return type; }
Grids.OnCanRowAdd = function(G,parent,next){
   Log("OnCanRowAdd: Test if is possible add row to "+(parent&&parent.tagName=='I'?"parent row '"+parent.id+"'":"root") + " " + (next?"before row '"+next.id+"'":"as the last row"),1);
   return true;
}
Grids.OnRowAdd = function(G,row){
   Log("OnRowAdd: User <b>ADDED new row</b> '"+row.id+"' to "+(row.parentNode.tagName=='I'?"parent row '"+row.parentNode.id+"'":"root") + " " + (row.nextSibling?"before row '"+row.nextSibling.id+"'":"as the last row"),1);
   FillIds();
}
Grids.OnRowAdded = function(G,row){ Log("OnRowAdded: Row '"+row.id+"' was sucessfully added",1); }
Grids.OnRowCopyId = function(G,row,rsource){
   Log("OnRowCopyId: Row "+rsource.id+" copied",1);
}
Grids.OnRowCopy = function(G,row,rsource,empty){
   Log("OnRowCopy: User <b>COPIED row</b> '"+rsource.id+"' as row '"+row.id+"' to "+(row.parentNode.tagName=='I'?"parent row '"+row.parentNode.id+"'":"root") + " " + (row.nextSibling?"before row '"+row.nextSibling.id+"'":"as the last row"),1);
}
Grids.OnExpand = function(G,row){ Log("OnExpand: User <b>"+(row.Expanded?"COLLAPSES":"EXPANDS")+" row</b> '"+row.id+"'",1); }
Grids.OnSetRowId = function(G,row,newid){ Log("OnSetRowId: The id attribute of the row '"+row.id+"' was set to '"+newid+"'",1); return newid; }
Grids.OnGenerateId = function(G,row,newid){
   Log("OnGenerateId: The identity attribute ("+G.IdNames[G.IdNames.length-1]+") of the row '"+row.id+"' was set to '"+newid+"'",1);
   return newid;
}
Grids.OnSectionResize = function(G,sec){ Log("OnSectionResize: Section '"+sec+"' was resized to size "+G.ColNames[sec].Width,1); }
Grids.OnAfterSectionResize = function(G,sec){ Log("OnAfterSectionResize: Section '"+sec+"' was finally resized to size "+G.ColNames[sec].Width,1); }

Grids.OnColResize = function(G,col){ Log("OnColResize: Column '"+col+"' was resized to size "+G.Cols[col].Width,1); }
Grids.OnAfterColResize = function(G,col){ Log("OnAfterColResize: Column '"+col+"' was finally resized to size "+G.Cols[col].Width,1); }
Grids.OnColMove = function(G,col){ var pcol = G.GetPrevCol(col); Log("OnColMove: Column '"+col+"' was moved "+(pcol?"next to '"+pcol+"'":"as first column"),1); }
Grids.OnResizeMain = function(G){ Log("OnResizeMain: The main grid tag was resized, new width is "+G.MainTag.offsetWidth+", new height is "+G.MainTag.offsetHeight,1); }
Grids.OnDisplaceRow = function(G,row,col){ if(IFunc.checked) Log("OnDisplaceRow("+row.id+","+col+")",0,"#CCC"); }
Grids.OnDisplayRow = function(G,row){ if(IFunc.checked) Log("OnDisplayRow("+row.id+")",0,"#CCC"); }
Grids.OnRenderRow = function(G,row){ if(IFunc.checked) Log("OnRenderRow("+row.id+")",0,"#CCC"); }

Grids.OnScroll = function(G,hpos,vpos,oldhpos,oldvpos){ Log("OnScroll: Grid was scrolled from position ["+oldhpos+","+oldvpos+"] to new position ["+hpos+","+vpos+"]",0,"#CCC"); }
Grids.OnScrollRow = function(G,row){ if(IFunc.checked) Log("OnScrollRow: Row "+row.id+" become visible",0,"#CAA"); }
Grids.OnScrollCol = function(G,col){ if(IFunc.checked) Log("OnScrollCol: Column "+col+" become visible",0,"#CAA"); }
Grids.OnDisable = function(G){ Log("OnDisable: Grid was DISABLED and cannot be accessed",1); }
Grids.OnEnable = function(G){ Log("OnEnable: Grid was ENABLED and can be accessed now",1); }
Grids.OnShowMessage = function(G,tag){ Log("OnShowMessage: Grid showed modal message",1,"#AAA"); }
Grids.OnShowDialog = function(G,row,col,Tag){ Log("OnShowDialog: A dialog / menu for cell ["+(row?row.id:"null")+","+col+"] was shown",1); }
Grids.OnCreateCfg = function(G){ Log("OnCreateCfg: Grid configuration dialog will be shown",1); }
Grids.OnShowCfg = function(G,Tag){ Log("OnShowCfg: Grid configuration dialog was shown",1); }
Grids.OnCfgChanged = function(G){ Log("OnCfgChanged: Configuration was changed by user",1); }
Grids.OnShowColumns = function(G,Tag){ Log("OnShowColumns: Grid column visibility dialog was shown",1); }
Grids.OnColumnsChanged = function(G,cols,count){
Log("OnColumnsChanged: Column visibility was changed",1);
for(var c in cols) Log("Column '"+c+"' is now "+(cols[c]?"visible":"hidden"),1);
}
Grids.OnAfterColumnsChanged = function(G){ Log("OnAfterColumnsChanged: Column visibility changing was finished",1); }

// --------------------------------------------------------------------------------------------------------------------------
//                                           Function event handlers
// --------------------------------------------------------------------------------------------------------------------------

Grids.OnFilter = function(G,start){
   var F = G.GetRowById("Filter"), cls="";
   if(F){
      for(var c=G.GetFirstCol();c;c=G.GetNextCol(c)) if(Get(F,c+"Filter")) cls+=(cls?",":"")+c;
      if(start){
         if(cls) Log("OnFilter: TreeGrid is <b>filtered</b> according to columns "+cls,1,"#aaa");
         else Log("OnFilter: TreeGrid is <b>not filtered</b>",1,"#aaa");
         }
      else {
         if(cls) Log("OnFilter: User <b>FILTERS</b> grid according to columns "+cls,1);
         else Log("OnFilter: User <b>CLEARS FILTERS</b> in grid",1);
         }
      }
   else Log("OnFilter: TreeGrid has no filter",1,"#aaa");
}
Grids.OnFilterFinish = function(G,start){ Log("OnFilterFinish: TreeGrid finished filtering",1); }
Grids.OnRowFilter = function(G,row,show){ if(IFunc.checked) Log("OnRowFilter: row '"+row.id+"' is "+(show?"VISIBLE":"HIDDEN"),0,"#CCC"); return show; }
Grids.OnGetFilterValue = function(G,row,col,val){ if(IFunc.checked) Log("OnGetFilterValue("+row.id+","+col+","+val+")",0,"#CAC"); return val; }

Grids.OnSearch = function(G,action,show){
   if(show) Log("OnSearch: User <b>SEARCHES</b> in grid, action used: <b>"+action+"</b>",1);
   else Log("OnSearch: TreeGrid is <b>searched</b> by action: <b>"+action+"</b>",1,"#aaa");
}
Grids.OnSearchFinish = function(G,action,show){ Log("OnSearchFinish: TreeGrid finished searching by action: <b>"+action+"</b>",1,show?"":"#aaa"); }
Grids.OnRowSearch = function(G,row,col,found,F,user){
   if(IFunc.checked) Log("OnRowSearch: in row '"+row.id+"'"+(col?",column:'"+col+"'":"")+" was "+(found?"FOUND":"not found"),0,"#CCC");
   if(G.id=="First") return FirstRowSearch(G,row,col,found,F,user);   // Support function for particular example
   return found;
}

Grids.OnSort = function(G,col){ Log("OnSort: User <b>SORTS</b> grid according to column '"+col+"'",1); }
Grids.OnSortFinish = function(G){ Log("OnSortFinish: TreeGrid finished sorting",1); }
Grids.OnGetSortValue = function(G,row,col,val,desc){ 
   if(IFunc.checked) Log("OnGetSortValue("+row.id+","+col+","+val+","+desc+")",0,"#CAC");
   return val;
}

Grids.OnGroup = function(G,cols){
   if(cols) Log("OnGroup: User <b>GROUPS</b> rows in grid by columns "+cols+" into column "+G.MainCol,1);
   else Log("OnGroup: User <b>REMOVES GROUPS</b> from grid",1);
}
Grids.OnGroupFinish = function(G){ Log("OnGroupFinish: TreeGrid finished grouping",1); }
Grids.OnGetGroupDef = function(G,col,def){ Log("OnGetGroupGroupDef: for grouping by column "+col+" is used default row '"+def+"'",1,"#aaa"); return def; } 
Grids.OnCreateGroup = function(G,row,col,val){ if(IFunc.checked) Log("OnCreateGroup("+row.id+","+col+","+val+")",0,"#CCA"); }
Grids.OnRemoveGroup = function(G,row,ungroup){ if(IFunc.checked) Log("OnRemoveGroup("+row.id+","+ungroup+")",0,"#CCA"); }
Grids.OnGetCopyValue = function(G,row,col,val){ if(IFunc.checked) Log("OnGetCopyValue("+row.id+","+col+","+val+")",0,"#CAC"); return val; }
Grids.OnGetExportValue = function(G,row,col,str){ if(IFunc.checked) Log("OnGetExportValue("+row.id+","+col+","+str+")",0,"#CAC"); return null; }
Grids.OnCalculate = function(G,show,row,col){
   if(row && col) Log("OnCalculate: TreeGrid is recalculated after cell ["+row.id+","+col+"] has been changed",1,"#aaa");
   else if(row) Log("OnCalculate: row '"+row.id+"' children are calculated",1,"#aaa");
   else Log("OnCalculate: TreeGrid is calculated",1,"aaa");
}

Grids.OnCalculateCell = function(G,row,col,val,show){ if(IFunc.checked) Log("OnCalculateCell: TreeGrid calculates cell ["+row.id+","+col+"]",0,"#AAA"); }

Grids.OnPaste = function(G,cols,text){ Log("OnPaste: User pasted text: "+text.join(" "),1); }
Grids.OnPasteFinish = function(G){ Log("OnPasteFinish: Finished pasting",1); }
Grids.OnPasteRow = function(G,row,cols,values,added){ Log("OnPasteRow: Pasting text to row "+row.id+", cols:["+cols.join(",")+"], values: ["+values.join(",")+"]",1,"#AAA"); }
Grids.OnPasteRowFinish = function(G,row,cols,values,added){ Log("OnPasteRowFinish: Pasted text to row "+row.id+", cols:["+cols.join(",")+"], values: ["+values.join(",")+"]",1,"#AAA"); }

Grids.OnPrintStart = function(G){ Log("OnPrintStart: TreeGrid will be printed",1); }
Grids.OnPrint = function(G,window,report){ Log("OnPrint: TreeGrid is printed",1); }
Grids.OnPrintFinish = function(G,window){ Log("OnPrintFinish: TreeGrid printing finished",1); }

Grids.OnExportStart = function(G, pdf){ Log("OnExportStart: Report to Excel will be generated",1); }
Grids.OnExport = function(G, data, pdf){ Log("OnExport: Report to Excel was generated and will be sent to server",1); }

Grids.OnSetPageName = function(G,page){ Log("OnSetPageName: Name of page "+page.Pos+" was set to '"+page.Name+"'",0,"#aaa"); }
Grids.OnGetPageNameValue = function(G,row,col,val) { if(IStyle.checked) Log("OnGetPageNameValue("+row.id+","+col+","+val+")",0,"#ccc"); return val; }
Grids.OnGetPageNumber = function(G,number){ /* Not used in this example */ }

Grids.OnAutoFill = function(G,r1,c1,r2,c2,rdir,cdir) { Log("OnAutoFill: User wants to automatically fill the selected range:["+r1.id+","+c1+";"+r2.id+","+c2+"]",1); }
Grids.OnAutoFillValue = function(G,row,col,orow,ocol,val,prevval,rowpos,colpos){ return val; }

Grids.OnHint = function(G,row,col,hint){ Log("OnHint: Hint for cell ["+row.id+","+col+"]: "+hint,1,"#AAA"); return hint; }
Grids.OnTip = function(G,row,col,tip,clientx,clienty,x,y){ if(IFunc.checked) Log("OnTip: Tip for cell ["+row.id+","+col+"]: "+tip,1,"#AAA"); return tip; }


// --------------------------------------------------------------------------------------------------------------------------
//                                            Click and key event handlers
// --------------------------------------------------------------------------------------------------------------------------

Grids.OnButtonClick = function(G,row,col){
   Log("OnButtonClick: User <b>clicked right button</b> in cell ["+row.id+","+col+"]",1);
   G.ShowDialog(row,col,"<DIV style='background:#ffffaa;border:2px inset #ddaadd; padding:10px;'> User dialog on<br>row '"
      + Esc(G.GetString(row,"A"))+"'<br>column '"+Esc(G.GetCaption(col))+"'<br>"
      +"<BR><DIV align=center><BUTTON style='width:60;' onclick='Grids[0].CloseDialog();'>OK</BUTTON></DIV></DIV>");
}
Grids.OnIconClick = function(G,row,col){ Log("OnIconClick: User <b>clicked left icon</b> in cell ["+row.id+","+col+"]",1); }

Grids.OnButtonListClick = function(G,row,col,item,index) { }
Grids.OnLinkClick = function(G,row,col,url,target){
   Log("OnLinkClick: User <b>clicked link</b> at cell ["+row.id+","+col+"]. Url is '"+Esc(url)+"', target is "+target+".",1);
}

Grids.OnClick = function(G,row,col,x,y,Event){
   Log("OnClick: User <b>clicked</b> cell ["+row.id+","+col+"] at ["+x+","+y+"]."+(col!="Panel"&&row!=G.Header?" Cell value is '"+Esc(G.GetString(row,col))+"'.":""),1);
}
Grids.OnDblClick = function(G,row,col,x,y,Event){
   Log("OnDblClick: User <b>double clicked</b> cell ["+row.id+","+col+"] at ["+x+","+y+"]."+(col!="Panel"&&row!=G.Header?" Cell value is '"+(col?Esc(G.GetString(row,col)):"???")+"'.":""),1);
}
Grids.OnRightClick = function(G,row,col,x,y,Event){
   Log("OnRightClick: User <b>right clicked</b> cell ["+row.id+","+col+"] at ["+x+","+y+"]."+(col!="Panel"&&row!=G.Header?" Cell value is '"+(col?Esc(G.GetString(row,col)):"???")+"'.":""),1);
}
Grids.OnMouseDown = function(G,row,col,x,y,Event){ Log("OnMouseDown: Cell ["+(row?row.id:null)+","+col+"] at ["+x+","+y+"].",1); }
Grids.OnMouseUp = function(G,row,col,x,y,Event){ Log("OnMouseUp: Cell ["+(row?row.id:null)+","+col+"] at ["+x+","+y+"].",1); }

Grids.OnMouseOver = function(G,row,col,orow,ocol,Event){ /* Not shown due too many events */ }
Grids.OnMouseMove = function(G,row,col,x,y,Event){ /* Not shown due too many events */ }

Grids.OnContextMenu = function(G,row,col,index,item){
   // Not used in this example, this examples uses its own menu displayed from OnRightClick
   //Log("OnClick: User chose menu item ["+index+"]"+item+" in context menu in cell ["+row.id+","+col+"] ",1);
}

Grids.OnKeyDown = function(G,key){ Log("Keydown: "+key,0,"#CAC"); }
Grids.OnKeyPress = function(G,key){ Log("Keypress: "+key,0,"#CCA"); }
Grids.OnKeyUp = function(G,key){ Log("Keyup: "+key,0,"#ACC"); }

Grids.OnTabOutside = function(G,move){
   if(move>0){
      Log("User pressed tab key on the last cell and focus is moved to next control");
      GetElem("SData").focus();
      return true;
      }
   else {
      Log("User pressed tab key on the first cell and focus is moved to previous control");
      GetElem("IStyle").focus();
      return true;
      }   
}

Grids.OnCopy = function(G,text){ Log("OnCopy: Copying to clipboard: "+text,1); }
Grids.OnCopyStart = function(G){ Log("OnCopyStart: Copying to clipboard started",1); }
Grids.OnGetRowText = function(G,row,cols,text,sel){ Log("OnGetRowText: Copying row "+row.id+" text to clipboard: "+text,1,"#AAA"); return text; }

Grids.OnFocus = function(G,row,col,orow,ocol,fpagepos){
   if(fpagepos!=null) var S = "OnFocus: User <b>focused</b> cell on page ["+(row.id?row.id:G.GetPageNum(row))+","+col+"] on position "+fpagepos+".";
   else var S = "OnFocus: User <b>focused</b> cell ["+row.id+","+col+"]"+(col?", with value '"+Esc(G.GetString(row,col))+"'":"")+".";
   
   Log(S+" Original focused cell was ["+(orow?orow.id:"none")+","+(ocol?ocol:"none")+"].",1);
   FRow = row;
   if(fpagepos==null) SetDRow(G,row); // Sets row values in DRow tag's inputs
}
Grids.OnSelect = function(G,row,type){ var t = ["selected","unselected","changed selection of"]; Log("OnSelect: User <b>"+t[type-0]+"</b> row "+row.id+".",1); }
Grids.OnSelectAll = function(G){ Log("OnSelectAll: User selected or unselected all rows",1); }
Grids.OnDeleteAll = function(G){ Log("OnDeleteAll: User deleted all selected rows",1); }

Grids.OnStartEdit = function(G,row,col){ Log("OnStartEdit: User <b>STARTED editation</b> in cell ["+row.id+","+col+"], with value '"+Esc(G.GetString(row,col))+"'.",1); }
Grids.OnEndEdit = function(G,row,col,save){ Log("OnEndEdit: User <b>"+(save?"FINISHED":"CANCELED")+" editation</b> in cell ["+row.id+","+col+"], with original value '"+Esc(G.GetString(row,col))+"'.",1); }
Grids.OnCustomStartEdit = function(G,row,col,val,cell,width){ Log("OnCustomStartEdit: Offer to start custom editing in cell ["+row.id+","+col+"], with value '"+val+"'.",1); }
Grids.OnCustomEndEdit = function(G,row,col,save,custom){ /* Used only if OnCustomStartEdit started custom editing and return an object */ }
Grids.OnGetInputValue = function(G,row,col,val){ Log("OnGetInputValue("+row.id+","+col+","+val+")",1,"#AAA"); return val; }
Grids.OnSetInputValue = function(G,row,col,val){ Log("OnSetInputValue("+row.id+","+col+","+val+")",1,"#AAA"); return val; }  
Grids.OnMergeChanged = function(G,row,col,val,result){ /* Not used in this example */ }

Grids.OnShowDetail = function(GMaster,GDetail,row){ Log("OnShowDetail: Showing detail from master grid "+GMaster+" for row "+(row?row.id:"null")+" in detail grid "+GDetail,1); }
Grids.OnShowDetailFinish = function(GMaster,GDetail,row){ Log("OnShowDetailFinish: Was shown detail from master grid "+GMaster+" for row "+(row?row.id:"null")+" in detail grid "+GDetail,1); }

Grids.OnGoToPage = function(G,page,pagepos) { Log("OnGoToPage: User <b>MOVED</b> to page "+pagepos,1); }

Grids.OnUndo = function(G,action,a,b,c,d,e) { if(action=="Start") Log("OnUndo: Undo started",1); else if(action=="End") Log("OnUndo: Undo finished",1); else Log("OnUndo: User has undone action "+action,1); }
Grids.OnRedo = function(G,action,a,b,c,d,e) { if(action=="Start") Log("OnRedo: Redo started",1); else if(action=="End") Log("OnRedo: Redo finished",1); else Log("OnRedo: User has redone action "+action,1); }

// --------------------------------------------------------------------------------------------------------------------------
//                                                 Data event handlers
// --------------------------------------------------------------------------------------------------------------------------

Grids.OnDataSend = function(G,D,Data,Func){ 
if(!Data) Data="";
if(Data.length>50) Data = Data.slice(0,50)+" ...";
Log("OnDataSend: TreeGrid sends data '"+Esc(Data)+"' to '"+D.Url+"'",1,"#CCC"); 
if(D.Url=="dummy") { G.ShowMessageTime("Simulated save OK",700); Func(0); return true; }
}		
Grids.OnDataError = function(G,source,code,mess,data){ Log("OnDataError: TreeGrid failed in data communication with code ["+code+"] and message '"+mess+"'. Url was "+source.Url+".",1,"red"); }
Grids.OnDataGet = function(G,source,Data,io){ 
   if(Data.length>150) Data = Data.slice(0,150)+" ...";
   Log("OnDataGet: TreeGrid receives data from Url "+source.Url+": "+Esc(Data),1,"#CCC"); 
   }
Grids.OnDataReceive = function(G,source){ Log("OnDataReceive: TreeGrid received data from Url "+source.Url,1,"#CCC"); }
Grids.OnDownloadPage = function(G,row,func){ 
   Log("OnDownloadPage: TreeGrid requests data for page "+(row.id?row.id:G.GetPageNum(row)),1); 
   if(G.id=="AddPage" && G.XB.lastChild == row && row.Pos<9) G.AddPage(); // Specific code for AddPage example
   }
Grids.OnReadData = function(G,D){ Log("OnReadData: TreeGrid reads data from '"+(D.Url?D.Url:D.Tag)+"'",1,"#AAA"); }		
Grids.OnSave = function (G,row,autoupdate){ Log("OnSave: TreeGrid saves changes"+(row?" in row "+row.id:"")+" to server."+(autoupdate?" Event was fired from auto update.":""),1); }
Grids.OnAfterSave = function (G,row,autoupdate){ Log("OnAfterSave: TreeGrid saving was finished."+(autoupdate?" Event was fired from auto update.":""),1); }
Grids.OnUpload = function (G,xml,row,autoupdate){ Log("OnUpload: TreeGrid changes will be uploaded to server",1); }
Grids.OnReload = function(G){ Log("OnReload: TreeGrid starts reloading",1,"blue"); }		
Grids.OnCanReload = function(G){ Log("OnCanReload: TreeGrid asks to reload its data",1,"#AAA"); return true; }
Grids.OnLoaded = function(G){ 
   Log("OnLoaded: TreeGrid loaded its data",1,"#CCC"); 
   for(var c in G.Cols){ 
      if(!G.Cols[c].SearchNames) G.Cols[c].SearchNames = G.Header[c]+","+c;       // Original names for search 
      G.Header[c] = c+(G.Header[c]&&G.Header[c]!=c?". "+G.Header[c]:""); // Adds before every caption the column name
      }
   }		
Grids.OnLoadError = function(G) { Log("OnLoadError: TreeGrid failed to load",1,"red"); }		
Grids.OnUpdated = function(G) { 
   Log("OnUpdated: TreeGrid data prepared correctly",1); 
   if(G.id=="First") FirstUpdated(G);
   }		
Grids.OnReady = function(G) { Log("OnReady: TreeGrid is ready to render",1); }
Grids.OnRenderStart = function(G){ Log("OnRenderStart: TreeGrid started rendering",1,"#CCC"); }		
Grids.OnRenderFinish = function(G){ 
   FillIds(); 
   Log("OnRenderFinish: TreeGrid finished rendering",1,"blue"); 
   Log("&nbsp;",1); Log("&nbsp;",1); Log("&nbsp;",1);
   if(!Grids.Already){
      Log("--------------------------",1);
      Log("<b>TreeGrid Extended API example</b>",1,"red","16px");
      Log("<i>In </i><b>this window</b><i> are displayed all events fired by TreeGrid and logged from user event handlers by </i><b>Log</b><i> function. You can </i><b>clear</b><i>, </i><b>disable</b><i> event log or </i><b>enable style events</b><i>.</i>",1,"#0AA","14px");
      Log("<i>In the </i><b>right window</b><i> you can run functions to demonstrate TreeGrid Extended API. In the first combo you can select data example to load in grid. "
      +"In second combo you can change TreeGrid's style. In next controls you can focus any cell. Color/Select/Filter any cell that contains given value. And also change any value of focused row.</i>",1,"#0AA","14px");
      Log("<i>By </i><b>right click</b><i> on any cell you can display </i><b>pop-up menu</b><i> and select presented options. For various cells and rows are different menu options, for </i><b>header</b><i> is there also another set of options.</i>",1,"#0AA","14px");
      Log("<i>Remember, some functions can be very slow, especially with logging enabled and large data. Also remember, this example is universal and some functions can be unsuitable for some data examples.</i>",1,"#066","14px");
      Log("--------------------------",1);
      Grids.Already = 1;
      }
   }		
Grids.OnRenderPageStart = function(G,row){ Log("OnRenderPageStart: TreeGrid started rendering "+(row.id?"row '"+row.id+"' children":"page "+G.GetPageNum(row)),1,"#CCC"); }		
Grids.OnRenderPageFinish = function(G,row){ Log("OnRenderPageFinish: TreeGrid finished rendering page "+(row.id?"row '"+row.id+"' children":"page "+G.GetPageNum(row)),1,"#CCC"); }		
Grids.OnRenderChildPartStart = function(G,row,index){ Log("OnRenderChildPartStart: TreeGrid started rendering row '"+row.id+"' child parts "+index,1,"#CCC"); }		
Grids.OnRenderChildPartFinish = function(G,row,index){ Log("OnRenderChildPartFinish: TreeGrid finished rendering row '"+row.id+"' child parts "+index,1,"#CCC"); }
Grids.OnRenderColPageStart = function(G,sec){ Log("OnRenderColPageStart: TreeGrid started rendering column page "+sec,1,"#CCC"); }		
Grids.OnRenderColPageFinish = function(G,sec){ Log("OnRenderColPageFinish: TreeGrid finished rendering column page "+sec,1,"#CCC"); }

Grids.OnLoadCfg = function(G){ Log("OnLoadCfg: TreeGrid loads configuration from cookies",1,"#CCC"); }		
Grids.OnCfgLoaded = function(G){ Log("OnCfgLoaded: TreeGrid loaded configuration from cookies",1,"#CCC"); }		
Grids.OnSaveCfg = function(G){ Log("OnSaveCfg: TreeGrid saves configuration to cookies",1,"#CCC"); }		
Grids.OnValidate = function (G,row,col,err){ /* Not used in the example */ }
Grids.OnValidateError = function (G,rows,cols){ 
   Log("OnValidateError: TreeGrid tries to save changes, but the data contains errors",1); 
   return 1;
   }
Grids.OnSetStyle = function(G,style,css){ Log("OnSetStyle: Grid style is changing to '"+style+"', in CSS file '"+css+"'",1); }
Grids.OnAfterSetStyle = function(G,style,css){ Log("OnAfterSetStyle: Grid style was changed to '"+style+"', in CSS file '"+css+"'",1); }

Grids.OnUpdateRow = function(G,row,src){ /* Not used in the example */ }

// --------------------------------------------------------------------------------------------------------------------------
//                                           Gantt event handlers
// --------------------------------------------------------------------------------------------------------------------------

Grids.OnCheckDependencies = function(G,row,col,newval){ Log("OnCheckDependencies: Testing circular dependencies in cell ["+row.id+","+col+"] and dependency "+newval,1); }
Grids.OnCorrectDependencies = function(G,A,R,error){ Log("OnCorrectDependencies: Correcting dependencies in chart",1); }
Grids.OnGanttChanged = function(G,row,col,item,new1,new2,old1,old2,action){ Log("OnGanttChanged: Changed Gantt cell ["+row.id+","+col+"], item '"+item+"' with action '"+action+"'",1); }
Grids.OnGanttMenu = function(G,row,col,menu,GanttXY){ Log("OnGanttMenu: Gantt menu for cell ["+row.id+","+col+"], will be shown",1); }
Grids.OnGanttRunBoxChanged = function(G,box,old){ /* not used in the examples */ }
Grids.OnGanttRunBoxNew = function(G,box,copy){ Log("OnGanttRunBoxNew: Created new run box"); }
Grids.OnGanttRunDrop = function(G,row,col,drop,src,index,keyprefix,x,y,togrid,torow,tocol,cellx){ Log("OnGanttRunDrop: "+(drop?"Box dropped":"Checking drop possibility"),drop?1:0,drop?null:"#AAA"); }
Grids.OnGanttStart = function(G){ Log("OnGanttStart: Creating Gantt chart",1); }
Grids.OnGanttTip = function(G,row,col,tip,GanttXY,name){ Log("OnGanttTip: Displaying Gantt tip for cell ["+row.id+","+col+"] ",1); return tip; }
Grids.OnGetGanttHeader = function(G,val,date,nextdate,units,width,partial,col){ Log("OnGetGanttHeader("+val+",...)",0,"#AAA"); return val; }

// --------------------------------------------------------------------------------------------------------------------------










// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                                  Controlling functions
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// --------------------------------------------------------------------------------------------------------------------------
// Function called after click on any item of user right click menu
// Runs appropriate command
Grids.OnContextMenu = function(G,row,col,item){
Log("User menu item '<b>"+item+"</b>' selected.",1,"red");
switch(item){
   case 'Unselect': 
   case 'Select' :
      G.SelectRow(row); break;          // Changes selection of the row
   case 'Select all':
   case 'Unselect all':
      G.SelectAllRows(); break;         // Changes selection of all rows
   case 'Delete' :
      G.DeleteRow(row,2); break;        // Deletes the row
   case 'Undelete' :
      G.DeleteRow(row,3); break;        // Undeletes the row
   case 'Delete selected':
   case 'Undelete selected':
      G.DeleteSelectedRows();           // Deletes or undeletes all selected rows
      break;
   case 'Collapse' :
      G.Collapse(row); break;           // Collapses the row
   case 'Expand' :
      G.Expand(row); break;             // Expands the row
   case 'Change value' :
      var val = G.Prompt('Change cell value',G.GetString(row,col),function(val){ // Lets user to change the value as string
         if(val!=null) {
            if(G.EditMode) G.EndEdit(G.FRow,G.FCol);
            G.SetString(row,col,val);     // Sets the changed value and recalculates the grid
            G.RefreshCell(row,col);       // Refreshes the cell to display new value
            G.ColorRow(row);              // Colors the row to change color according to changes
            }
         });
      break;
   case 'Add child' :
      var r = G.AddRow(row,null,true); // Adds new row to the children of the row, to the end
      G.ScrollIntoView(r);             // Scrolls grid to display new row
      break;
   case 'Add next' :
      var r = G.AddRow(row.parentNode,G.GetNext(row),true); // Adds new row after the row, to the same parent
      G.ScrollIntoView(r);             // Scrolls grid to display new row
      break;
   case 'Sort descending':
      G.SortClick(col,0);              // Sorts grid descending according to the col
      break;
   case 'Sort ascending':
      G.SortClick(col,1);              // Sorts grid ascending according to the col
      break;
   case 'Hide column':
      G.HideCol(col);                  // Hides the column (column can be displayed from menu columns, it can be run from toolbar)
      G.SaveCfg();                     // Updates configuration in cookies
      break;
   }
}
// --------------------------------------------------------------------------------------------------------------------------
// Function returns popup menu for cell
Grids.OnGetMenu = function(G,row,col,menu){
Log("User displayed popup menu",1);
var Items = [], p = 0;
if(row==G.Header){                   // row is header row
   var R = G.GetSelRows();            // returns all selected rows as array
   if(R.length){                      // If there is at least one selected row
      Items[p++] = "Unselect all";
      for(var i=0,del=0;i<R.length;i++) if(Is(R[i],"Deleted")) { del=1; break; }
      if(del) Items[p++] = "Undelete selected";  // If there is at least one delete row in grid
      else Items[p++] = "Delete selected";       // No deleted row in grid
      }
   else Items[p++] = "Select all";   // No selected row in grid
   if(col!="Panel"){                 // Column is not left panel
      Items[p++] = "Sort descending";
      Items[p++] = "Sort ascending";
      Items[p++] = "Hide column";
      }
   }
else {                                 // row is not header row
   Items[p++] = Is(row,"Selected") ? "Unselect" : "Select";
   Items[p++] = Is(row,"Deleted") ? "Undelete" : "Delete";
   if(G.HasChildren(row)){            // If row has at least one visible child
      if(Is(row,"Expanded")) Items[p++] = "Collapse"; // For expanded row
      else Items[p++] = "Expand";                     // For collapsed row
      }
   if(G.CanEdit(row,col)) Items[p++] = "Change value";// If value can be edited by user
   if(!row.Fixed && Get(row,"CDef")) Items[p++] = "Add child"; // If this is body row (no foot or head) and has set CDef attribute
   if(!row.Fixed) Items[p++] = "Add next";           // If this is body row (no foot or head)
   }
return "|"+Items.join("|");
}
// --------------------------------------------------------------------------------------------------------------------------
// Function called from button Focus to focus chosen row
// Also called when SIds or SCols combo changed
function Focus(e){

// --- gets row and col from combos ---
var S = GetElem('SIds');
var id = S.options[S.selectedIndex].value;
var G = Grids[0];
var row = G.GetRowById(id);
var S = GetElem('SCols');
var col = S.options[S.selectedIndex].value;
Log("User run command <b>Focus</b> for cell ["+id+","+col+"].",1,"red");

if(!row){ // Row with given id is not present in the grid
   alert("Unknown id");
   return;
   }
if(!Is(row,"Visible")){  // Row is not visible (is hidden by filter or is deleted
   alert("Selected row is hidden and cannot be focused");
   return;
   }
setTimeout(function(){ // Delays the code, otherwise the grid will loose focus to the select box
   G.Focus(row,col,null,true);   // Focuses the row and also expands row's parent if it is collapsed (set by last parameter)
   },10);
}
// --------------------------------------------------------------------------------------------------------------------------
// Called to prepare controls for new data
// Called from OnRenderFinish and OnRowAdd event handlers
// Fills all ids of rows to SIds select box
// Fills all column names to SCols select box
// Generates inputs in DRow tag for every column, to let user to change values
function FillIds(){
var G = Grids[0]; // There is only one grid on page

// --- fills all rows' ids ---
var S = GetElem("SIds");
S.options.length = 0;
var A = new Array(), id=1;

// Variable rows
for(var r=G.GetFirst();r;r=G.GetNext(r)) { // Base cycle for iteration through all variable rows
   if(!r.id) r.id = "R"+(id<10?'0':"")+(id++); // Generate id, if row has not any
   A[A.length] = r.id;
   }
A.sort();                                  // sorts ids to better display in combo

// Fixed rows
var F = G.GetFixedRows(); id=1;
for(var i=0;i<F.length;i++){               
   if(!F[i].id) F[i].id = "F"+(id<10?'0':"")+(id++);
   A[A.length] = F[i].id;
   }
   
for(var i=0;i<A.length;i++){ // generates new options in select box
   S.options[S.options.length] = new Option(A[i],A[i]);
   }

// --- fills all columns' names ---
var S = GetElem("SCols");
S.options.length = 0;
var A = new Array();
//for(var c=G.GetFirstCol();c;c=G.GetNextCol(c)) A[A.length] = c; // Base cycle for iteration through all visible columns according to their position
for(var c in G.Cols) if(c!='Panel' && G.Cols[c].Type!="Gantt" && c!="_ConstWidth") A[A.length] = c; // Base cycle for iteration throught all columns
A.sort();                    // sorts column names to better display in combo
for(var i=0;i<A.length;i++){ // generates new options in select box
   S.options[S.options.length] = new Option(A[i],A[i]);
   }
   
// --- creates inputs for every column ---
var D = GetElem("DRow"), A = new Array(), p=0;
A[p++] = "<div id=ID_ID>Row</div>";
for(var c in G.Cols) if(c!='Panel' && G.Cols[c].Type!="Gantt" && c!="_ConstWidth"){ // Base cycle for iteration throught all columns
   A[p++] = G.GetCaption(c).replace("<br>","&nbsp")+"&nbsp";
   A[p++] = "<input id=ID"+c+" type=text style='width:80px;font-size:10px;' onkeydown='if(event.keyCode==13 || event.charCode==13) Update(this);'><br>";
   }
D.innerHTML = A.join("");

var I = D.getElementsByTagName("input");
for(var i=0;i<I.length;i++){               // Sets with of all inputs to maximize it
   I[i].style.width = (D.offsetWidth-I[i].offsetLeft-15)+"px";
   }
SpecResize(); // Height of the tag was changed
}
// --------------------------------------------------------------------------------------------------------------------------
// Function for coloring/filtering/selecting found rows/cells
// Fro button=0 restores all rows
// For button=1 sets user attribute col+"Marked" if cell contains the searched value
// For button=2 hides row if any cell contains the searched value
// For button=3 selects rows if any cell contains the searched value
// Called when user presses the button or presses enter in input tag
function Color(button){
var G = Grids[0];
var V = GetElem("IColor").value;
Log("User run command <b>Color ("+button+")</b> with value '"+Esc(V)+"'.",1,"red");

// --- main function to change row's state or color ---
function color(r){
   var found = false;
   for(var c in G.Cols){
      if(c=="Panel") continue;
      var t = G.GetType(r,c), M = 0;
      if(t=="Int" || t=="Float") { // Number types compares as number
         M = V-0==G.GetValue(r,c);
         }
      else {                       
         var S = G.GetString(r,c);
         if(!S) M = !V;
         else M = V?S.toLowerCase().search(V.toLowerCase())>=0:0; // Other then number types searches for appearance
         }
      if(M) found = true;
      if(button!=1) M = 0; // only button 'Color' colors the rows
      r[c+"Marked"] = M; // Color, sets custom attribute, this attribute will be used in event OnGetColor
      }
   if(button==2 && !found) G.HideRow(r); // Filter
   else G.ShowRow(r);
   if(!Is(r,"Selected") && button==3 && found || Is(r,"Selected") && (button!=3 || !found)) G.SelectRow(r); // Select
   if(found && button) G.ExpandParents(r); // Expands all parents of the row to make the row visible
   G.ColorRow(r);                          // Updates color of the row
   }
   
// --- iteration of all rows ---
G.Focus();
G.StartUpdate();   // Suppresses updating grid layout after every change, speeds up the action. It is good especially for Filter (button==2), because it shows/hides rows
//for(var r=G.GetFirstVisible();r;r=G.GetNextVisible(r)) color(r); // Base cycle for iteration through all visible variable rows
for(var r=G.GetFirst();r;r=G.GetNext(r)) if(!Is(r,"Deleted")) color(r);  // Base cycle for iteration through all non deleted rows
var F = G.GetFixedRows(); for(var i=0;i<F.length;i++) color(F[i]); // Base cycle for iteration through fixed rows
G.EndUpdate();  // Restores original state
}
// --------------------------------------------------------------------------------------------------------------------------
// Sets focused row values in DRow tag's inputs
// Called from OnFocus event handler
function SetDRow(G,row){

// --- sets the first row - id, parents, page ---
var I = document.getElementById("ID_ID");
var S = "", r = row.parentNode;
while(r.tagName=="I"){ S += (S?",":"")+(r.id?r.id:"???"); r=r.parentNode; } // fills parents from tree
S = "Id="+(row.id?row.id:"???")+(S?"; parents="+S:"")+"; page="+(r.id?r.id:G.GetPageNum(r));
I.innerHTML = S;

// --- sets values ---
for(var col in G.Cols) if(col!='Panel'){ // Base cycle for iteration throught all columns
   var I = document.getElementById("ID"+col);
   if(I){
      I.value =  G.GetString(row,col);   // Gets string
      I.disabled = !G.CanEdit(row,col);  // Disables input if value cannot be edited
      }
   }
}
// --------------------------------------------------------------------------------------------------------------------------
// Updates inputs value after change
// Called when user presses enter in any input tag in DRow tag
// I is the tag input
function Update(I){
var G = Grids[0], row = FRow; // FRow is backup of focused row in the grid, because if grid user clicks on any control on page, the grid looses focus and clears Grids[0].FRow property
if(!FRow){ // (new) data was loaded and user did not clicked on any row yet
   alert("No row focused yet");
   return;
   }
var col = I.id.slice(2); // input's id is "ID"+column_name
G.SetString(row,col,I.value,1); // sets the value and recalculates grid
}
// --------------------------------------------------------------------------------------------------------------------------
