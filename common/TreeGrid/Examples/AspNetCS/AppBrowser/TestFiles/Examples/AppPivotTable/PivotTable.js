// ----------------------------------------------------------------------------------------------------------
// Support script generating Pivot table for PivotTable.html example
// ------------------------------------------------------------------------------------------------------
// Custom calculation function to calculate individual cells in pivot table
TCalc.prototype.GSum = function(R,RV,C,CV,D){
var G = Grids[0], sum = 0;
for(var r=G.GetFirst();r;r=G.GetNext(r)) {
   if(!r.Deleted && r[R]==RV && r[C]==CV) sum+=r[D];
   }

return sum;
}
// ------------------------------------------------------------------------------------------------------
// Main function to create pivot table
function CreatePivotTable(){
var G = Grids[0];
var R = G.GetRowById("Rows").Cols.split(","); // Rows
var C = G.GetRowById("Cols").Cols.split(","); // Columns
var D = G.GetRowById("Data").Cols.split(","); // Data

if(!R[0] || !C[0] || !D[0]) return; // Error - incomplete setting

// --- init ---
var L = "<Grid><Cfg id='Pivot' SuppressCfg='1' SuppressMessage='1' Editing='0' Deleting='0' Selecting='0' Adding='0' Dragging='0'/>";
L+="<Def><D Name='R' Calculated='1'/></Def>";

// --- Cols ---
var A = {}, C0 = [];
for(var r=G.GetFirst();r;r=G.GetNext(r)) if(!r.Deleted) A[G.GetValue(r,C[0])]=1; // finds all different values
for(var a in A) C0[C0.length] = a; // puts all values to array
if(!C0.length) return // Error - no values 
C0.sort(); // sorts the array

L += "<LeftCols><C Name='N1' Type='Text'/></LeftCols>";
L += "<Cols>";
for(var i=0;i<C0.length;i++) L += "<C Name='C"+i+"' Type='Float'/>";
L += "</Cols>";
L += "<RightCols><C Name='T' Type='Float'/></RightCols>";

L += "<Header N1='"+G.GetCaption(R[0])+"' T='Total'";
for(var i=0;i<C0.length;i++) L += " C"+i+"='"+C0[i]+"'";
L += "/>";

L += "<Foot><I Calculated='1' N1='Total' TFormula='sum()'";
for(var i=0;i<C0.length;i++) L += " C"+i+"Formula='sum()'";
L += "/></Foot>";

// --- Rows ---
var A = {}, R0 = [];
for(var r=G.GetFirst();r;r=G.GetNext(r)) if(!r.Deleted) A[G.GetValue(r,R[0])]=1; // finds all different values
for(var a in A) R0[R0.length] = a; // puts all values to array
R0.sort(); // sorts the array

var TF = " TFormula='"
for(var i=0;i<C0.length;i++) TF += (i?"+":"") + "C"+i;
TF+="'";

L += "<Body><B>";   
for(var j=0;j<R0.length;j++){
   L += "<I N1='"+R0[j]+"'";
   for(var i=0;i<C0.length;i++){
      L += " C"+i+"Formula='GSum(\""+R[0]+"\",\""+R0[j]+"\",\""+C[0]+"\",\""+C0[i]+"\",\""+D[0]+"\")'";
      }
   L += TF+"/>";
   }

L += "</B></Body></Grid>";

var T = Grids["Pivot"];
if(T){
   T.Source.Data.Data = L;
   T.Reload();   
   }
else T = TreeGrid({ Sync:1, SuppressMessage:1, Data:{ Data:L } },"Grid2");
}
// ------------------------------------------------------------------------------------------------------
// Creates pivot table after the source is displayed
Grids.OnRenderFinish = function(G){
if(G.id=="PivotSource") CreatePivotTable();
}
// ------------------------------------------------------------------------------------------------------
// Called after a user changed some value in Pivot source
Grids.OnAfterValueChanged = function(G,row,col){
var G = Grids["Pivot"];
if(!G || G.Loading || G.Rendering) return;

// --- changed pivot => recreate ---
if(row.Space!=null || col=="A" || col=="B" || col=="C") CreatePivotTable();

// --- updates only calculation ---   
else G.Calculate(1);   
}
// ------------------------------------------------------------------------------------------------------
function Recreate(){ 
var G = Grids["Pivot"];
if(!G || G.Loading || G.Rendering) return;
CreatePivotTable(); 
}
Grids.OnRowAdd = Recreate;
Grids.OnRowDelete = Recreate;
Grids.OnRowUndelete = Recreate;

// ------------------------------------------------------------------------------------------------------
// Creates the first grid synchronously
TreeGrid('<bdo Sync="1" SuppressMessage="1" Layout_Url="PivotTableDef.xml" Data_Url="PivotTableData.xml"></bdo>',"Grid1");
