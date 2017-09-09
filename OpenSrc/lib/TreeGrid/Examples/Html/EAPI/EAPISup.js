// --------------------------------------------------------------------------------------------------------------------------
// Supported functions for particular examples
// These scripts are used to run particular examples properly and are not intended to demonstrate using Extended API
// --------------------------------------------------------------------------------------------------------------------------

// -----------------------------------------------------------------------------------------
// Custom calculation function for First.xml
TCalc.prototype.customcount = function(all){
var cnt = 0;
function count(row){
   if(row.Def.Name=="Node"){ if(!row.Deleted && (Get(row,"X") && row.Visible || all)) cnt++; }
   else for(var r=row.firstChild;r;r=r.nextSibling) count(r);
   }
if(all) for(var r = this.Grid.Body.firstChild.firstChild;r;r=r.nextSibling) count(r);
else { var ch=this.GetChildren(); for(var i=0;i<ch.length;i++) count(ch[i]); }
return cnt;
}
// -----------------------------------------------------------------------------------------
// Custom event OnRowSearch for searching in First.xml
// Searches in orders with specified items
function FirstRowSearch(G,row,col,found,F,type){
if(type || G.SearchDefs!="") return found; // Only for "in orders with items" and default call
if(row.Def.Name=="Data") return -1;        // Only for orders
for(var r=row.firstChild;r;r=r.nextSibling) { 
   var found = F(r,col,1);                 // calls F(r,col,type=1)
   if(!(found<=0)) return found; 
   }
return 0;
}
// --------------------------------------------------------------------------------------------------------------------------
// Called on start in First.xml
function FirstUpdated(G){ G.FilterDateRange('I','1/1/2005~12/31/2005','Year',0); }
// --------------------------------------------------------------------------------------------------------------------------
// Helper function for example Books.xml, changes edit mode
function EditChange(edit){
Grids["Books"].Editing = edit ? 1 : 2;
}
// --------------------------------------------------------------------------------------------------------------------------
