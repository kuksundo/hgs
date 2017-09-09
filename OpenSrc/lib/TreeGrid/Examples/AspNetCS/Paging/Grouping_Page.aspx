<%@ Page language="c#" Debug="true"%>
<%
///! Support file only, run Grouping.html instead !
/// This file is used as Page_Url
/// Generates data for one TreeGrid page from database, according to grouping information
///! Demonstrates Server paging but client child paging - all children are sent to server at once
/// This is only simple example with not ideal database access (for every page gets all data)
/// Single file, without using TreeGridFramework.aspx
%>

<script runat="server">
// -------------------------------------------------------------------------------------------------------------------------------
// Helper function, converts object to XML string, escapes entities
string ToXmlString(object O)
{
   return "'" + O.ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'";
}
// -------------------------------------------------------------------------------------------------------------------------------
// Helper function, converts object to SQL string, escapes apostrophes
string ToSqlString(string name, object O)
{
   if (name == "Week" || name == "Hours") return O.ToString();
   else return "'" + O.ToString().Replace("'", "''") + "'";
}
// ------------------------------------------------------------------------------------------------------------------------------- 
// Writes one level of grouped children
// Uses recursion to write next levels
// Level is actual level to write
// Where is WHERE clause for SQL, for every level there is added one condition
// GroupCols, Cmd, Levels are static paramterers
// Start is used only for level 0 to specify how much rows to ignore before the page
void WriteLevel(int Level, string Where, string[] GroupCols, System.Data.IDbCommand[] Cmd, int Levels, int Start)
{
   if (Level == Levels) Cmd[Level].CommandText = "SELECT * FROM TableData" + Where;
   else Cmd[Level].CommandText = "SELECT DISTINCT " + GroupCols[Level] + " FROM TableData" + Where;
   System.Data.IDataReader R = Cmd[Level].ExecuteReader();
   if (Level == 0) for (int i = 0; i < Start && R.Read(); i++) ; // On level 0 throws away data in front of requested page
   int Max = 20; // 21 rows per page on level 0
   while(R.Read())
   {
      if (Level == Levels)    // Final, writing data row
      {
         Response.Write("<I id='" + R[0].ToString() + "'"
               + " Project=" + ToXmlString(R[1])
               + " Resource=" + ToXmlString(R[2])
               + " Week='" + R[3].ToString() + "'"
               + " Hours='" + R[4].ToString() + "'"
               + "/>");
      }
      else                    // Next grouping row
      {
         Response.Write("<I Def='Group' Project=" + ToXmlString(R[0]) + ">"); // writes the grouping row
         string Where2 = (Level == 0 ? " WHERE " : " AND ") + GroupCols[Level] + "=" + ToSqlString(GroupCols[Level], R[0]);
         WriteLevel(Level + 1, Where + Where2, GroupCols, Cmd, Levels, 0);
         Response.Write("</I>");
      }
      if(Level==0 && --Max<0) break; // On level 0 maximally 21 rows per page
   }
   R.Close();
}
// -------------------------------------------------------------------------------------------------------------------------------
</script>

<%
// -------------------------------------------------------------------------------------------------------------------------------

// By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
// The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
// The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
bool UseMDB = false;

// --- Response initialization ---
Response.ContentType = "text/xml";
Response.Charset = "utf-8";
Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");

// --- Parse XML request ---
string XML = Request["TGData"];
if (XML == null) XML = "<Grid><Cfg GroupCols='Resource,Week'/><Body><B Pos='2'/></Body></Grid>"; // Just for examples if called directly
System.Xml.XmlDocument X = new System.Xml.XmlDocument();
X.LoadXml(HttpUtility.HtmlDecode(XML));

// --- Parses Grouping settings ---
System.Xml.XmlElement Cfg = (System.Xml.XmlElement)X.GetElementsByTagName("Cfg")[0];
string[] GroupCols = Cfg.GetAttribute("GroupCols").Split(",".ToCharArray());
int Levels = GroupCols[0] == "" ? 0 : GroupCols.Length; // Depth of grouping, 0 - no grouping
   
// --- Gets information about page number ---
int pos = Int32.Parse(((System.Xml.XmlElement)(X.GetElementsByTagName("B")[0])).GetAttribute("Pos"));
int start = pos*21;      // 21 = PageLength

// --- Database initialization ---
string Path = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath);
System.Reflection.Assembly SQLite = UseMDB ? null : System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + (IntPtr.Size == 4 ? "32" : "64") + "\\System.Data.SQLite.DLL");
System.Data.IDbConnection[] Conn = new System.Data.IDbConnection[Levels+1];
// In old ASP.NET (1.x) is needed to have only one data reader per connection
// In newer ASP.NET (2.x+) is needed to have one data reader per command
System.Data.IDbCommand[] Cmd = new System.Data.IDbCommand[Levels+1];
for (int i = 0; i <= Levels; i++){
	if(UseMDB) Conn[i] = new System.Data.OleDb.OleDbConnection("Data Source=\"" + Path + "\\..\\Database.mdb\";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Provider=\"Microsoft.Jet.OLEDB.4.0\";Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1");
   else Conn[i] = (System.Data.IDbConnection)Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db");
	Conn[i].Open();
	Cmd[i] = Conn[i].CreateCommand();
	}

// --- Writes data for requested page ---   
Response.Write("<Grid><Body><B Pos='" + pos.ToString() + "'>"); // XML Header
WriteLevel(0, "", GroupCols, Cmd, Levels, start);
Response.Write ("</B></Body></Grid>"); // XML Footer
for (int i = 0; i <= Levels; i++) Conn[i].Close();
// -------------------------------------------------------------------------------------------------------------------------------
%>