<%@ Page Language="c#" ContentType="application/vnd.ms-excel"%>
<%
///! Support file only, run SortingExport.html instead !
/// This file is used as Export_Url
/// Generates data to export to Excel
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
Response.Charset = "utf-8";
Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");
string file = Request["File"]; if (file == null) file = "Export.xls";
Response.AppendHeader("Content-Disposition", "attachment; filename=\"" + file + "\"");

// --- Request read ---   
string XML = Request["TGData"];
if (XML == null) XML = "<Grid><Cfg SortCols='Week,Hours' SortTypes='1,0'/><Cols><C Name='Project' Visible='1' Width='200'/><C Name='Resource' Visible='1' Width='150'/><C Name='Week' Visible='1' Width='60'/><C Name='Hours' Visible='1' Width='60'/></Cols></Grid>"; // Just for examples if called directly
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
   
// --- Parses column position, visibility and width ---
System.Xml.XmlNodeList Cols = X.GetElementsByTagName("C");
string[] N = new string[4]; int p=0;
string[] W = new string[4];
foreach (System.Xml.XmlElement C in Cols){
   if (C.GetAttribute("Visible") != "0")
   {
      N[p] = C.GetAttribute("Name");
      W[p] = C.GetAttribute("Width");
      p++;
   }
}

// --- Reads data from database ---
Cmd.CommandText = "SELECT * FROM TableData" + S;
System.Data.IDataReader R = Cmd.ExecuteReader();
   
// --- Writes Excel settings ---
Response.Write ("<html xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns=\"http://www.w3.org/TR/REC-html40\">");
Response.Write ("<head><meta http-equiv=Content-Type content=\"text/html; charset=utf-8\"></head><body>");
Response.Write ("<style>td {white-space:nowrap}</style>");
Response.Write ("<table border=1 bordercolor=silver style='table-layout:fixed;border-collapse:collapse;border:1px solid black'>");
   
// --- Writes columns' widths ---
for (int i=0;i<p;i++) Response.Write ("<col width='" + W[i] + "'>");

// --- Writes captions ---
Response.Write ("<tr>");   
for(int i=0;i<p;i++) Response.Write ("<td style='border-bottom:1px solid black;background:yellow;font-weight:bold;'>"+N[i]+"</td>");
Response.Write ("</tr>");

// --- Writes data ---
while(R.Read()){
   Response.Write("<tr>");
   for (int i = 0; i < p;i++){
      if(N[i]=="Resource" || N[i]=="Project") // string
      {
         Response.Write("<td>" + R[N[i]].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "</td>");
      }
      else
      {
         Response.Write("<td x:num='" + R[N[i]].ToString() + "'>" + R[N[i]].ToString() + "</td>");  
      }
   }
   Response.Write("</tr>");
}
// ---
Response.Write ("</table></body></html>");
R.Close();
Conn.Close();
// --------------------------------------------------------------------------
%>