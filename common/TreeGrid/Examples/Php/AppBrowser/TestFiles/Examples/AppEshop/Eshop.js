// ---------------------------------------------------------------------------------------------------------------
// Script for Eshop.html example
// ---------------------------------------------------------------------------------------------------------------
var LCnt, LPrice;         // Defines arrays needed only for real e-shop
Grids.CookieExpires = 1;  // Sets TreeGrid cookies to expire after this session

// ---------------------------------------------------------------------------------------------------------------
// TreeGrid event handler
// Called after every cell change
// Sets the cell is marked as changed only if contains not null value
// Also re-generates the report 
Grids.OnAfterValueChanged = function(G,row,col) {
var P = ["B","P","S","G"];
var val = row[col];
if(val<0) val = 0;
if(row.id=='ES' || row.id=='ESA' || row.id=='UPG'){
   var ci2 = col=='I2';
   if(val && !ci2 && row.id=='UPG' || !val && ci2){
      for(var i=0;i<P.length;i++){
         row[P[i]+"Visible"]=0; 
         row[P[i]+"CanEdit"]=0;
         if(ci2) { row[P[i]+"Span"]=0; row[P[i]+"PSpan"]=0; }
         }
      if(!ci2){ row[col+"Visible"]=1; row[col+"CanEdit"]=1; }
      else { row.BPSpan = 8; row.BPVisible="0"; }
      }
   else {
      for(var i=0;i<P.length;i++){
         row[P[i]+"Visible"]=1; 
         row[P[i]+"CanEdit"]=1;
         if(ci2){ row[P[i]]=0; row[P[i]+"Span"]=1; row[P[i]+"PSpan"]=1; }
         }
      row.BPVisible="1";   
      }
   if(ci2 && val){
      var A = row.I2Names;
      A = A.split(A.charAt(0));
      var r = G.GetRowById(A[val+1]);
      var mul = 10;
      if(row.id=='ES') mul=1;
      if(row.id=='ESA') mul=5;
      for(var i=0;i<P.length;i++) row[P[i]+"P"] = r[P[i]+"P"]/10*mul;
      }
   G.RefreshRow(row);
   }
if(row.id=="CW" && val>1000) val = 1000;
if(val!=row[col]) G.SetValue(row,col,val);
var nl = 1;
if(row.id=='SCE'||row.id=='CW') nl = !row.SP;
else if(row.id=='ES' || row.id=='ESA' || row.id=='UPG') nl = !row.B && !row.P && !row.S && !row.G || !row.I2;
else nl = !row.B && !row.P && !row.S && !row.G;
if(nl) row.Changed = 0; 
G.ColorRow(row);
G.Recalculate(row,col,1);
UpdateOrder();
G.SaveCfg();
}

// ---------------------------------------------------------------------------------------------------------------
// TreeGrid event handler
// Called after grid finished rendering
// Re-generates report for the first time - if grid loaded its state and values from cookies
Grids.OnRenderFinish = function(G){
UpdateOrder();
}

// ---------------------------------------------------------------------------------------------------------------
// Main function to generate report
function UpdateOrder(){
var G = Grids[0];
var F = G.GetRowById("Results"); // Gets the row to display there the report

var A = new Array(),a=0;
var D = [["B","BASIC"],["P","PERSONAL"],["S","STANDARD"],["G","GRAND"]];

// --- Iterates all variable rows and checks if the appropriate cells contain value
for(var r=G.GetFirst();r;r=G.GetNext(r)){
   if(r.id=='UPG') continue; // upgrades
   if(r.id=='SCE'){ // Source code escrow
      var x = new Object();
      x.Count = r.SP;
      x.Price = 250*x.Count;
      x.Name = r.I + " " + G.GetString(r,"S").replace(/DIV/g,"I");
      x.Id = r.id;
      if(x.Count) A[a++] = x;
      }
   else if(r.id=="CW"){ // custom work
      var x = new Object();
      x.Count = r.SP;
      x.Price = 55*x.Count;
      x.Name = "custom work";
      x.Id = r.id;
      if(x.Count) A[a++] = x;
      }
   else for(var i=0;i<4;i++){ // normal license or support
      var o = D[i][0], p = o+"P";
      if(r[o]){
         var x = new Object();
         A[a++] = x;
         var id = r.id.split("_");
         if(r.id=='ES' || r.id=='ESA'){ 
            x.Id = id[0];
            x.Name = (r.id=='ES' ? "Extended support for " : "Extended support for whole lifetime of ") + G.GetString(r,"I2")+" <B>"+D[i][1]+"</B>";
				}
         else {
            x.Id = o+id[0];
            x.Name = r.I+" <B>"+D[i][1]+"</B>";
            }
         x.Count = r[o];
         x.Col = o;
         x.Row = r;
         
         if(id[1]){ // extended support
            var y = new Object();
            A[a++] = y;
            y.Count = x.Count;
            if(id[1]==1){ // one year
               y.Id = "ES";
               y.Name = "Extended support for "+x.Name;
               y.Price = r[p]*x.Count/11;
               x.Price = r[p]*x.Count/11*10;
               }
            else { // whole lifetime
               y.Id = "ESA";
               y.Name = "Extended support for whole lifetime of "+x.Name;
               y.Price = r[p]*x.Count/15*5;
               x.Price = r[p]*x.Count/15*10;
               }
            }
         else x.Price = r[p]*x.Count;	
         }
      }
   } 

// --- Creates the report text ---
F.BP = "";

// --- Upgrade ---
var U = G.GetRowById('UPG'), c = null;
G.SetValue(U,"O",0,1);
if(U.I2){
   for(var i=0;i<4;i++)	if(U[D[i][0]]){ c = D[i][0]; break; }
   if(c){
      var Upg = [["PGS","PGE","TGS","TGE","TGC"],["PTS","PTE","TGS","TGE","TGC"]];
      F.BP += "<BR><I>You declare you have already purchased these components:</I><BR>";
      F.BP += "&nbsp;&nbsp;&nbsp;<SPAN style='color:red;'><B>1</B>x "+G.GetString(U,"I2")+" "+D[i][1]+"</SPAN><BR>";
      }
   }

if(a){
   LCnt = new Object(); LPrice = new Object();
   F.BP+=F.BP ? "<HR>" : "<BR>";
   F.BP += "<B>Your order:</B><BR>";
   for(var i=0;i<A.length;i++){
      if(A[i]){ 
         var mult = "x";
         if(A[i].Id=="ES" || A[i].Id=="SCE") mult = A[i].Count==1 ? " year of" : " years of";
         else if(A[i].Id=="ESA"); // nothing
         else if(A[i].Id=="CW") mult = A[i].Count==1 ? " hour of" : " hours of";
         else if(c){ // upgrade
            if(A[i].Count>1){ // More counts for one upgrade, divides it
               var P = new Object();
               for(var x in A[i]) P[x] = A[i][x];
               A[i].Price = A[i].Price / A[i].Count;
               A[A.length] = P;
               P.Count = A[i].Count-1;
               P.Price = A[i].Price*P.Count;
               A[i].Count = 1;
               }
            var pric = 0;
            var r = G.GetRowById(A[i].Id.slice(1));
            if(U.I2<=7){ // Upgrade from previous
               pric+=U[c+"P"]*0.4;
               }
            var dp = r[c+"P"] - U[c+"P"];
            if(dp<0){ // ### error
               F.BP += "&nbsp;&nbsp;&nbsp;<SPAN style='color:red;'>Cannot upgrade to selected product!</SPAN><BR>";
               }
            else {
               pric+=dp*1.25;
               var dp = r[A[i].Col+"P"] - r[c+"P"];
               if(dp<0 || dp==0 && A[i].Col!=c || A[i].Col=='P' && c=='S'){ // ### error
                  F.BP += "&nbsp;&nbsp;&nbsp;<SPAN style='color:red;'>Cannot upgrade to selected license type!</SPAN><BR>";
                  }
               else {
                  pric+=dp*1.25;
                  if(A[i].Price<=pric || pric<=0){ // ### useless
                     F.BP += "&nbsp;&nbsp;&nbsp;<SPAN style='color:red;'>Upgrading would be inconvenient!</SPAN><BR>";	
                     }
                  else { 
                     G.SetValue(U,"O",pric - A[i].Price,1);
                     A[i].Price = pric;
                     c="";
                     }
                  }
               }
            }
         F.BP += "&nbsp;&nbsp;&nbsp;<SPAN style='color:blue;'><B>"+A[i].Count + "</B>"+mult+" "+A[i].Name+"</SPAN><BR>";
         if(!LCnt[A[i].Id]) LCnt[A[i].Id] = A[i].Count;
         else LCnt[A[i].Id] += A[i].Count;
         if(!LPrice[A[i].Id]) LPrice[A[i].Id] = A[i].Price;
         else LPrice[A[i].Id] += A[i].Price;
         }
      }
   F.BP += "<HR>";
   F.BP += "Total order price is <B>"+F.O+"</B> USD&nbsp;&nbsp;&nbsp;<BUTTON onclick='Submit();'><B style='color:\"green\"'>Purchase this order</B></BUTTON><BR>";
   F.BP += "<BR>"; 
   }
else F.BP = "<I>No order yet</I>"

G.RefreshRow(F);   // refreshes the row 
G.SetScrollBars(); // updates the grid size when report changed
}

// ---------------------------------------------------------------------------------------------------------------
// Function called when calculating from formula in XML data
function AddYear(y){
var d=new Date(); 
d.setFullYear(d.getFullYear()+y); 
return d.getTime();
}
// ---------------------------------------------------------------------------------------------------------------
function Submit(){
alert("This is example of eshop only.\nNow in real application will be the page redirected to purchase page.\nIf you want to purchase TreeGrid, select Purchase online from left menu at www.treegrid.com.");
}
// ---------------------------------------------------------------------------------------------------------------
// Creates the grid synchronously
TreeGrid('<bdo Sync="1" Layout_Url="EshopDef.xml" Data_Url="EshopData.xml" DebugCheckIgnore="I2Names"></bdo>',"Eshop");
