<%@ Page language="c#" Debug="true"%>
<%
//! Support file only, run Schools.html instead !
// This file is used as Page_Url
// Loads and returns reviews for given record
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
System.Data.IDataReader R;

// --- Response initialization ---
Response.ContentType = "text/xml";
Response.Charset = "utf-8";
Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");

// --- Returns ratings for the row as server child page --- 
string XML = Request["TGData"];
if (XML == null) XML = "<Grid><Body><B id='jan$Main$1'/></Body></Grid>";  // Just for examples if called directly
System.Xml.XmlDocument X = new System.Xml.XmlDocument();
X.LoadXml(HttpUtility.HtmlDecode(XML));
System.Xml.XmlNodeList Ch = X.GetElementsByTagName("B");
Response.Write ("<Grid><Body>");

int Pos = 1;
foreach (System.Xml.XmlElement I in Ch)
{
   string[] id = I.GetAttribute("id").Split("$".ToCharArray());  // User$Def$Ident
   Response.Write ("<B id='"+I.GetAttribute("id")+"'>");
   Cmd.CommandText = "SELECT * FROM Schools_Ratings WHERE Owner='" + id[0].Replace("'","''") + "' AND Id=" + id[2];
   R = Cmd.ExecuteReader();
   while(R.Read())
   {
      Response.Write ("<I Def='Review' CName='" + R["ADate"].ToString() 
         + "' CCountry='" + R["Review"].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;")
         + "' Ident='"+I.GetAttribute("id")+"_"+(Pos++).ToString()+"' CRating='" +R["Stars"].ToString() + "'/>");
   }
   Response.Write("</B>");
   R.Close();
}
Response.Write ("</Body></Grid>");
Conn.Close();
// --------------------------------------------------------------------------
%>