// --------------------------------------------------------------------------------------------------------
// Support script for Browser application
// It uses externaly defined variable FilePath as path for the files to show
// --------------------------------------------------------------------------------------------------------

// --------------------------------------------------------------------------------------------------------
var EditFilePath = ""; // File actually shown in the Edit textarea
var EditChanged = 0;   // If the text in the textarea was modified
var EditOrigText = ""; // Original text to compare changes
// --------------------------------------------------------------------------------------------------------
// Returns panel buttons according to extension and grid editing
function GetRowPanel(G,row,col){
var ext = {'htm':3,'html':3,'xml':3,'gif':1,'jpg':1,'png':1,'txt':3,'js':2,'css':2}[(Get(row,"E")+'').toLowerCase()]; // 1 view, 2 edit, 3 view+edit
if(row.Added||row.Moved||row.Changed||row.Deleted) ext = 0;
if(!G.Editing) return ext&1 ? "Show":"";
return "Select,Delete,Copy" + (ext&2?",Edit":",Empty") + (ext&1?",Show":",Empty");
}
// --------------------------------------------------------------------------------------------------------
// Recalculates all panels after save changes
Grids.OnAfterSave = function(G){
G.Calculate(1);
}
// --------------------------------------------------------------------------------------------------------
// Cannot input empty filename or directory
Grids.OnEndEdit = function(G,row,col,save,val){
if(save && !val && col=="N") return -1;
}
// --------------------------------------------------------------------------------------------------------
// Parses file name if it containts path separators '/' creates appropriate directories for it
Grids.OnValueChanged = function(G,row,col,val){
if(col!="N" || !G.Group || val.indexOf('/')<0) return val;
val = val.split('/');
G.StartUpdate();
for(var i=0,par=row.parentNode;i<val.length-1;i++){
   for(var r=par.firstChild;r;r=r.nextSibling) if(Get(r,col)==val[i]) break;
   if(r) par = r;
   else { par = G.AddRow(par,null,1,null,"Dir"); G.SetAttribute(par,null,"GroupCol","P",0,1); G.SetValue(par,col,val[i],1); }
   }
G.MoveRow(row,par,null,1);
G.EndUpdate();
return val[val.length-1];
}
// --------------------------------------------------------------------------------------------------------
// Parses merged input value to the Path,Name and Ext 
Grids.OnMergeChanged = function(G,row,col,val,res){
var p = 0;
if(!G.Group) {
   var idx = val.lastIndexOf("/");
   if(idx>=0){ res[p++] = val.slice(0,idx); val = val.slice(idx+1); }
   else res[p++] = "";
   }
var idx = val.lastIndexOf(".");
if(idx>=0) { res[p++] = val.slice(0,idx); res[p++] = val.slice(idx+1); }
else { res[p++] = val; res[p++] = ""; }
}
// --------------------------------------------------------------------------------------------------------
// Returns value for sorting and grouping
Grids.OnGetSortValue = function(G,row,col,val,dir,group){
val = row.Def.Group?"!":""; // Sorts first the groups (=directories)
val += (Get(row,col)+"").toLocaleLowerCase().replace(/^\s+/g,""); // It is used just because of HTML code in Path value Format that contains also the '/' separator (in </span>)
return val;
}
// --------------------------------------------------------------------------------------------------------
// Automatically focuses the column when new row is added
Grids.OnRowAdd = function(G,row){
G.FCol = G.Group ? "N" : "P";
}
// --------------------------------------------------------------------------------------------------------
Grids.OnLoaded = function(G){
if(Grids.Tablet) { G.Cols.Panel.Width = 150; GetElem("Browser").style.width = "400px"; GetElem("Browser").parentNode.style.width = "400px"; }
}
// --------------------------------------------------------------------------------------------------------
// Called on start, after all rows are prepared, but before calc/sort/group/filter
Grids.OnUpdated = function(G){
Group(G.Group?1:0,1);
Merge(Get(G.GetRowById("Controls"),"M")?1:0,1);
}
// --------------------------------------------------------------------------------------------------------
// Called when creating group, updates its Path to have correct ids in the grid
Grids.OnCreateGroup = function(G,row,col,val){
var par = row.parentNode;
row["P"] = par.Def ? Get(par,"P")+(Get(par,"P")?"/":"")+Get(par,"N") : "";
}
// --------------------------------------------------------------------------------------------------------
// Called when copying directory and files to create correct path
Grids.OnRowCopyId = function(G,row,src){
if(!G.Group) return;
var par = row.parentNode;
row["P"] = par.Def ? Get(par,"P")+(Get(par,"P")?"/":"")+Get(par,"N") : "";
}
// --------------------------------------------------------------------------------------------------------
// Groups or ungroups grid, updates merge, called after click to checkbox
// !!! The Spanned and Span attributes must be set directly for all rows, not only for default row and the Span must be set for all cells
function Group(val,noshow){
var G = Grids.Files, R = G.Def.R;
if(val){ R.PSpan = 1; R.NSpan = 2; }
else { R.PSpan = 3; R.NSpan = 0; }
R.ESpan = 0; R.PanelSpan = 1; 
for(var r=G.GetFirst();r;r=G.GetNext(r)) if(r.Def==R) { r.PSpan = R.PSpan; r.NSpan = R.NSpan; r.ESpan = 0; r.PanelSpan = 1; }
G.ActionClearUndo(); // Clears undo queue, because grouping changes grid structure and row count
if(!noshow) { G.DoGrouping(val?"P":""); G.SaveCfg(); }
}
// --------------------------------------------------------------------------------------------------------
// Turns on/off merge (all in one cell), called after click to checkbox
// !!! The Spanned and Span attributes must be set directly for all rows, not only for default row
function Merge(val,noshow){
var G = Grids.Files, R = G.Def.R;
R.Spanned = val;
for(var r=G.GetFirst();r;r=G.GetNext(r)) if(r.Def==R) r.Spanned = val;
if(!noshow) { G.RenderBody(); G.SaveCfg(); }
}
// --------------------------------------------------------------------------------------------------------
// Sets the whole grid read only (val=1) or editable (val=0)
function SetReadOnly(val,noshow){
var G = Grids.Files;
G.Editing = !val;
G.Adding = !val;
G.Copying = !val;
G.Deleting = !val;
G.Dragging = !val;
G.Selecting = !val;
G.Undo = !val;
G.Cols.Panel.Width = val?20:86;
G.Cols.E.Width += val?66:-66; // Resizes Name column for the width changed the Panel to have still the same width of grid
G.Calculate(); // Recalculates Panel buttons
G.Render();
}
// --------------------------------------------------------------------------------------------------------
// Shows the file in IFRAME
function ShowFile(row){
var G = Grids.Files;
var path = location.href.replace(/\/[^\/]*$/,"/")+FilePath;
var file = (Get(row,"P")?Get(row,"P")+"/":"")+(Get(row,"N")?Get(row,"N"):"")+(Get(row,"E")?"."+Get(row,"E"):"");
if(EditChanged && !confirm("It will discard the changes!\nDo you want to proceed?")) return;
EditChanged = 0;
var fr = document.getElementById("View"), fw = fr.contentWindow, ta = document.getElementById("Edit");
ta.style.display = "none"; ta.value = ""; fr.style.display = "";
EditUrl = "";
fr.src = path+file;
}
// --------------------------------------------------------------------------------------------------------
// Shows and edits the content in textarea
function EditFile(row){
var G = Grids.Files;
var path = location.href.replace(/\/[^\/]*$/,"/")+FilePath;
var file = (Get(row,"P")?Get(row,"P")+"/":"")+(Get(row,"N")?Get(row,"N"):"")+(Get(row,"E")?"."+Get(row,"E"):"");
if(EditChanged && !confirm("It will discard the changes!\nDo you want to proceed?")) return;
EditChanged = 0;       // Global property
EditFilePath = file;   // Global property
var fr = document.getElementById("View"), fw = fr.contentWindow, ta = document.getElementById("Edit");
fr.style.display = "none"; fr.src = ""; ta.style.display = "";
var src = AjaxCall(path+file); 
if(typeof(src)=="number" && src==-5) src = ""; // Ok, empty response
ta.value = src;
EditOrigText = ta.value;
setTimeout(function(){ // Runs in timeout to not be affected by the TreeGrid event postprocessing code
   Grids.Files.Focus(); Grids.Focused = null; // Blurs the grid
   ta.focus(); SetSelection(ta,0,0); // sets carret to beginning of the textarea
   },10);
}
// --------------------------------------------------------------------------------------------------------
// Called from textarea when it is changed
function OnEditChanged(ev){
if(EditChanged) return;
if(EditOrigText==document.getElementById("Edit").value) return;
EditChanged = 1; // Global property
document.getElementById("Save").style.display = "";
}
// --------------------------------------------------------------------------------------------------------
// Saves changes in the edit textarea to server
function SaveEdit(){
if(!EditChanged) return;
var ta = document.getElementById("Edit");
if(FileSave){ 
   var G = Grids.Files;
   var ret = AjaxCall({ Url:location.href.replace(/\/[^\/]*$/,"/")+FileSave, Data:"Data", Param: { File:EditFilePath }, Grid:G }, ta.value); // Grid is set just for debugging IO errors
   if(ret!="OK"){ alert(ret); return; } // Error in save
   G.Debug(3,"Changes were successfuly saved to "+FileSave);
   }
else alert("This online example does not support saving changes");   
document.getElementById("Save").style.display = "none";
ta.focus();
EditChanged = 0;
EditOrigText = ta.value;
return;
}
// --------------------------------------------------------------------------------------------------------
// Called to show popup menu with actions like delete or copy
function ShowRightMenu(G,row){
if(!G.Editing) return;
var I = [], p = 0, S = G.GetSelRows();
if(S.length){ // Selected files & directories
   if(row.Selected) I[p++] = { Name:row.Deleted ? "Undelete selected files" : "Delete selected files",OnClick:function(){ row.Deleted?G.ActionUndeleteSelected(1):G.ActionDeleteSelected(1); } }
   I[p++] = { Name:"Copy selected files",OnClick:function(){ G.ActionCopySelected(1); } }
   if(row.Def.Group) I[p++] = { Name:"Copy selected files into the directory",OnClick:function(){ G.ActionCopySelectedChild(1); } }
   I[p++] = "-";
   }
if(row.Def.Group){ // Directory
   I[p++] = { Name:row.Deleted ? "Undelete all files in the directory" : "Delete all files in the directory",OnClick:function(){ G.DeleteRow(row); } }
   if(!row.Deleted) I[p++] = { Name:"Copy all files in the directory",OnClick:function(){ G.CopyRows([row],null,row,0,1); } }
   I[p++] = "-";
   I[p++] = { Name:"Insert new file into the directory",OnClick:function(){ G.AddRow(row,row.firstChild,1); } }
   I[p++] = { Name:"Insert new directory into the directory",OnClick:function(){ var r = G.AddRow(row,row.firstChild,1,null,"Dir"); G.SetAttribute(r,null,"GroupCol","P",0,1); G.SetValue(r,"N","New directory",1); } }
   }
else { // File
   I[p++] = { Name:row.Deleted ? "Undelete the file" : "Delete the file",OnClick:function(){ G.DeleteRow(row); } }
   if(!row.Deleted) I[p++] = { Name:"Copy the file",OnClick:function(){ G.CopyRows([row],null,row); } }
   if(row.Panel.indexOf("Edit")>=0) I[p++] = { Name:"Edit the file",OnClick:function(){ EditFile(row); } }
   if(row.Panel.indexOf("Show")>=0) I[p++] = { Name:"View the file",OnClick:function(){ ShowFile(row); } }
   }
I[p++] = "-";
I[p++] = { Name:"Insert new file",OnClick:function(){ G.AddRow(null,row,1); } }
if(G.Group) I[p++] = { Name:"Insert new directory",OnClick:function(){ var r = G.AddRow(null,row,1,null,"Dir"); G.SetAttribute(r,null,"GroupCol","P",0,1); G.SetValue(r,"N","New directory",1); } }
G.ShowPopup({Items:I});
}
// --------------------------------------------------------------------------------------------------------
// Synchronizes height of the grid with the right side iframe / textarea
var BInterval = null;
BInterval = setInterval(function(){ 
   if(!GetElem("Browser")) { clearInterval(BInterval); return; }
   var h = GetElem("Browser").offsetHeight; 
   if(GetElem("View").height!=h-4) GetElem("View").height = h-4; 
   if(parseInt(GetElem("Edit").style.height)!=h) GetElem("Edit").style.height = h+"px"; 
   },500);
// --------------------------------------------------------------------------------------------------------
