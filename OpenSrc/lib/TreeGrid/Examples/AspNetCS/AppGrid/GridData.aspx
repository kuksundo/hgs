<%@ Page language="c#" Debug="true"%><%
///! Support file only, run Grid.html instead !
/// This file is used as Data_Url for TreeGrid
/// It generates source data for TreeGrid from database
// --------------------------------------------------------------------------
   
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

// --- Generating data ---
Cmd.CommandText = "SELECT * FROM TableData WHERE Week>0 AND Week<53 ORDER BY Project,Resource";
System.Data.IDataReader R = Cmd.ExecuteReader();

string Prj = null, Res = null, S = "";

while(R.Read())
{
   string p = R[1].ToString();  // Project
   string r = R[2].ToString();  // Resource

   if (p != Prj)                // New project row
   {
      if(Prj != null) S += "/></I>";    // Ends previous project and resource rows
      Prj = p; Res = null;
      S += "<I Def='Node' Project='" + Prj.Replace("&","&amp;").Replace("'","&apos;").Replace("<","&lt;") + "'>";
   }
   
   if(r != Res)                  // New resource row
   {
      if (Res != null) S += "/>";     // Ends previous resource row
      Res = r;
      S += "<I Project='" + Res.Replace("&","&amp;").Replace("'","&apos;").Replace("<","&lt;") + "' ";
   }
   
   S = S + "W" + R[3].ToString() + "='" + R[4].ToString() + "' "; // Week = Hours (like W42='17')
}

if(Prj != null) S += "/></I>";   // Ends previous project and resource rows
R.Close();
Conn.Close();
                                        
// --------------------------------------------------------------------------
%><?xml version="1.0" ?>
<Grid>
   <Body>
      <B>
         <%=S%>
      </B>
   </Body>
</Grid>