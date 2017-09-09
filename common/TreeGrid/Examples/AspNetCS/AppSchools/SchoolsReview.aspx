<%@ Page language="c#" Debug="true"%>
<%
//! Support file only, run Schools.html instead !
// This file is used as target of custom AJAX call in Schools.html
// Saves Review to database
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

if (Request["id"] != null)
{
   // --- Reads input parameters ---
   string[] id = Request["id"].Split("$".ToCharArray()); // User$Def$Ident
   string Text = Request["Text"];
   string Stars = Request["Stars"];

   // --- Saves Review to database ---
   Cmd.CommandText = "INSERT INTO Schools_Ratings(Owner,Id,Stars,Review,ADate) VALUES ('" + id[0].Replace("'","''") + "'," + id[2] + "," +Stars + ",'" + Text.Replace("'","''") + "','" + DateTime.Now.ToString("M/d/yyyy") + "')";
   Cmd.ExecuteNonQuery();
   Cmd.CommandText = "UPDATE Schools_Schools SET RatingSum=RatingSum+"+Stars+", RatingCnt=RatingCnt+1 WHERE Owner='" + id[0].Replace("'","''") + "' AND Id=" + id[2];
   Cmd.ExecuteNonQuery();  
}
Response.Write("<Grid><IO Result='0' Message='Your review was successfully added'/></Grid>");
// --------------------------------------------------------------------------
%>