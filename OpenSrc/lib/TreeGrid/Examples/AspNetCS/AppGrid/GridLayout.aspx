<%@ Page language="c#" Debug="true"%><%
// -------------------------------------------------------------------------- 
///! Support file only, run Grid.html instead !
/// This file is used as Layout_Url for TreeGrid
/// It generates layout structure for TreeGrid from database
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

// --- Generating layout ---
Cmd.CommandText = "SELECT MIN(Week),MAX(Week) FROM TableData WHERE Week>0 AND Week<53";
System.Data.IDataReader R = Cmd.ExecuteReader();
R.Read();
   
int Min = (int)R.GetDouble(0);
int Max = (int)R.GetDouble(1);
string Cols="", CSum="", DRes="", DDef="";
for(int i=Min;i<=Max;i++)
{
   string Week = "W" + i.ToString();
   Cols += "<C Name='" + Week + "' Type='Float'/>"; // Column definitions
   if (CSum!="") CSum += "+";
   CSum += Week;                                   // Right fixed result column formula
   DRes += Week + "Formula='sum()' ";              // Tree result row formulas
   DDef += Week + "='0' ";                         // Default values for data rows
}

R.Close();
Conn.Close();
// --------------------------------------------------------------------------
%><?xml version="1.0"?>
<Grid>
   <Cfg id='ResourceGrid' MainCol='Project' MaxHeight='1' ShowDeleted="0" DateStrings='1' 
      IdNames='Project' AppendId='1' FullId='1' IdChars='0123456789' NumberId='1' LastId='1'/>
   <LeftCols>
      <C Name='id' CanEdit='0'/>
      <C Name='Project' Width='250' Type='Text'/>
   </LeftCols>
   <Cols><%=Cols%>
   </Cols>
   <RightCols>
      <C Name='Sum' Width='50' Type='Float' Formula='<%=CSum%>' Format='0.##'/>
   </RightCols>
   <Def>
      <D Name='R' Project='New resource' CDef='' AcceptDef='' <%=DDef%>/>
      <D Name='Node' Project='New project' CDef='R' AcceptDef='R' Calculated='1' SumFormula='sum()' <%=DRes%> ProjectHtmlPrefix='&lt;B>' ProjectHtmlPostfix='&lt;/B>'/>
   </Def>
   <Root CDef='Node' AcceptDef='Node' />
   <Header id='id (debug)' Project='Project / resource'/>
   <Foot>
      <I Kind='Space' RelHeight='100'/>
      <I Def='Node' Project='Total results' ProjectCanEdit='0'/>
   </Foot>
</Grid>