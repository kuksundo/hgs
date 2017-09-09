<%@ Page language="c#"%>
<!--#include file="../Framework/TreeGridFramework.aspx"-->
<script language="c#" runat="server">
///! Support file only, run Framework.html instead !
/// Uses new ASP.NET style scripting with event Page_Load, uses TreeGrid framework
// -------------------------------------------------------------------------------------------------------------------------------
void Page_Load(object sender, System.EventArgs e) 
{
try
{
	Response.ContentType = "text/xml";
   Response.Charset = "utf-8";
   Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
   
   TreeGrid Grid = new TreeGrid(
      //"Data Source=\"" + GetPath() + "\\..\\Database.mdb\";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Provider=\"Microsoft.Jet.OLEDB.4.0\";Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1", // MDB database
      "Data Source=" + GetPath() + "\\..\\Database.db", // SQLite database
      "SELECT * FROM TableData",    // SQL Selection command to select all rows from database, used also for saving data back
      "ID",                         //Column name in database table where are stored unique row ids  
      "",                           //Prefix added in front of id, used if ids are number type
      "",                           //Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
      "",                          //Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree
      GetPath() + "\\..\\..\\..\\Server\\SQLite" + (IntPtr.Size == 4 ? "32" : "64") + "\\System.Data.SQLite.DLL"); // Path to SQLite.DLL, for MDB can be null
   string XML = Request["TGData"];
   string UserParam = Request["Userparam"];  // User parameter has value = "UserValue" set in HTML
   if (XML != "" && XML != null) {
      Grid.SaveXMLToDB(XML);             // Saves data to database
      Response.Write("<Grid><IO Result='0'/></Grid>");
      }
   else Response.Write(Grid.LoadXMLFromDB());  // Loads data from database  
} catch(Exception E)
{
   Response.Write("<Grid><IO Result=\"-1\" Message=\"Error in TreeGrid example:&#x0a;&#x0a;"+E.Message.Replace("&","&amp;").Replace("<","&lt;").Replace("\"","&quot;")+"\"/></Grid>");
}
}
// -------------------------------------------------------------------------------------------------------------------------------
</script>
