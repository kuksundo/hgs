<%@ Page language="c#" Debug="true"%>
<%
///! Support file only, run Grouping.html instead !
/// This file is used as Data_Url
/// Generates data for TreeGrid body
/// This is simple example, always reads and groups all rows to get their count
/// Single file, without using TreeGridFramework.aspx
// -------------------------------------------------------------------------------------------------------------------------------

// By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
// The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
// The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
bool UseMDB = false;
                                        
// --- Database initialization ---
string Path = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath);
System.Data.IDbConnection Conn = null;
if (UseMDB) // For MS Acess database
{
   Conn = new System.Data.OleDb.OleDbConnection("Data Source=\"" + Path + "\\..\\Database.mdb\";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Provider=\"Microsoft.Jet.OLEDB.4.0\";Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1");
}
else // For SQLite database
{
   System.Reflection.Assembly SQLite = System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + (IntPtr.Size == 4 ? "32" : "64") + "\\System.Data.SQLite.DLL");
   Conn = (System.Data.IDbConnection)Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db");
}
Conn.Open();
System.Data.IDbCommand Cmd = Conn.CreateCommand();

// --- Response initialization ---
Response.ContentType = "text/xml";
Response.Charset = "utf-8";
Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");

// --- Parse XML request ---
string XML = Request["TGData"]; // was set <bdo ... Data_Data="TGData" ...>
if (XML == null) XML = "<Grid><Cfg GroupCols='Resource'/></Grid>"; // Just for examples if called directly
System.Xml.XmlDocument X = new System.Xml.XmlDocument();
X.LoadXml(HttpUtility.HtmlDecode(XML));

// --- Parses Grouping settings ---
System.Xml.XmlElement Cfg = (System.Xml.XmlElement)X.GetElementsByTagName("Cfg")[0];
string[] GroupCols = Cfg.GetAttribute("GroupCols").Split(",".ToCharArray());
   
// --- Generating data for body ---
if(GroupCols[0] == "") Cmd.CommandText = "SELECT COUNT(*) FROM TableData";
else Cmd.CommandText = "SELECT COUNT(*) FROM (SELECT COUNT(*) FROM TableData GROUP BY " + GroupCols[0] + ")";
System.Data.IDataReader R = Cmd.ExecuteReader();
R.Read();
int cnt = R.GetInt32(0);
Response.Write("<Grid><Cfg RootCount='" + cnt.ToString() + "'/><Body>");
cnt = (cnt + 20) / 21;
for (int i = 0; i < cnt; i++) Response.Write("<B/>");
Response.Write("</Body></Grid>");
R.Close();
Conn.Close();
// --------------------------------------------------------------------------
%>