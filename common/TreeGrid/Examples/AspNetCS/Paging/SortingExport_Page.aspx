<%@ Page language="c#" Debug="true"%>
<%
///! Support file only, run SortingExport.html instead !
/// This file is used as Page_Url
/// Generates data for one TreeGrid page from database, according to sorting information
/// This is only simple example with not ideal database access (for every page gets all data)
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

// --- Parses request XML ---
string XML = Request["TGData"];
if(XML==null) XML = "<Grid><Cfg SortCols='Week,Hours' SortTypes='1,0'/><Body><B Pos='3'/></Body></Grid>"; // Just for examples if called directly
System.Xml.XmlDocument X = new System.Xml.XmlDocument();
X.LoadXml(HttpUtility.HtmlDecode(XML));
   
// --- Parses sorting settings ---
System.Xml.XmlElement Cfg = (System.Xml.XmlElement) X.GetElementsByTagName("Cfg")[0];
string[] SC = Cfg.GetAttribute("SortCols").Split(",".ToCharArray());
string[] ST = Cfg.GetAttribute("SortTypes").Split(",".ToCharArray());
string S = "";
if (SC[0] != "")
{
   for (int i = 0; i < SC.Length; i++)
   {
      if (S != "") S += ", ";
      S += SC[i];
      if (Int32.Parse(ST[i]) >= 1) S += " DESC";
   }
   if (S!="") S = " ORDER BY " + S;
}

// --- Gets information about page number ---
int pos = Int32.Parse(((System.Xml.XmlElement)(X.GetElementsByTagName("B")[0])).GetAttribute("Pos"));
int start = pos*21;      // 21 = PageLength

// --- Reads data from database ---
Cmd.CommandText = "SELECT * FROM TableData" + S; 
System.Data.IDataReader R = Cmd.ExecuteReader();
   
// --- Throws away data in front of requested page ---
for(int i=0;i<start && R.Read();i++);

// --- Writes data for requested page ---
Response.Write ("<Grid><Body><B Pos='" + pos.ToString() + "'>");
for(int i=0;i<21 && R.Read();i++)
{
   Response.Write("<I id='" + R[0].ToString() + "'"
            + " Project='" + R[1].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'"
            + " Resource='" + R[2].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'"
            + " Week='" + R[3].ToString() + "'"
            + " Hours='" + R[4].ToString() + "'"
            + "/>"); 
}
Response.Write ("</B></Body></Grid>");
R.Close();
Conn.Close();
%>