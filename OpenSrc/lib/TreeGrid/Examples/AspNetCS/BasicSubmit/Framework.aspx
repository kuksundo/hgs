<%@ Page language="c#"%>
<!-----------------------------------------------------------------------------------------------------------------
Example of TreeGrid using synchronous (submit, non AJAX) communication with server
Example of simple table without tree
Uses DataTable for database communication
Uses new ASP.NET style scripting with event Page_Load
Uses MS Access database Database.mdb and table "TableData" as data and XML file DBDef.xml as TreeGrid layout
Uses TreeGridFramework.aspx as support script
! Check if ASP.NET application has write access to Database.mdb file
------------------------------------------------------------------------------------------------------------------>

<!--#include file="../Framework/TreeGridFramework.aspx"-->

<html>
   <head>
      <script src="../../../Grid/GridE.js"> </script>
      <link href="../../../Styles/Examples.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <h2>Using TreeGrid ASP.NET framework</h2>
      <div style="WIDTH:100%;HEIGHT:90%">
         <bdo 
            Layout_Url="DBDef.xml" 
            Data_Tag="TGData" 
            Upload_Tag="TGData" Upload_Format="Internal"
            Export_Url="../Framework/Export.aspx" Export_Data="TGData" Export_Param_File="Table.xls"
            ></bdo>
      </div>
      <form method="post" runat="server">
         <input id="TGData" type="hidden" runat="server"/>
         <input type="submit" value="Submit changes to server"/>
      </form>
   </body>
</html>
<script language="c#" runat="server">
// -------------------------------------------------------------------------------------------------------------------------------
// Main event handler, called before rendering, uses TreeGrid class from Main.aspx file
void Page_Load(object sender, System.EventArgs e) {
   TreeGrid Grid = new TreeGrid(
      //"Data Source=\"" + GetPath() + "\\..\\Database.mdb\";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Provider=\"Microsoft.Jet.OLEDB.4.0\";Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1",
      "Data Source=" + GetPath() + "\\..\\Database.db", // SQLite database
      "SELECT * FROM TableData",    // SQL Selection command to select all rows from database, used also for saving data back
      "ID",                         //Column name in database table where are stored unique row ids  
      "",                           //Prefix added in front of id, used if ids are number type
      "",                           //Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
      "",                           //Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree
      GetPath() + "\\..\\..\\..\\Server\\SQLite" + (IntPtr.Size == 4 ? "32" : "64") + "\\System.Data.SQLite.DLL"); // Path to SQLite.DLL, for MDB can be null
   if (IsPostBack) Grid.SaveXMLToDB(TGData.Value);  // Saves data to database
   TGData.Value = Grid.LoadXMLFromDB();             // Loads data from database  
}
// -------------------------------------------------------------------------------------------------------------------------------
</script>
