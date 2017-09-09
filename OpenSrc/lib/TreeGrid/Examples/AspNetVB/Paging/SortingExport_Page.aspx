<%@ Page language="vb" Debug="true"%>
<%
   '! Support file only, run SortingExport.html instead !
   ' This file is used as Page_Url
   ' Generates data for one TreeGrid page from database, according to sorting information
   ' This is only simple example with not ideal database access (for every page gets all data)
   ' Single file, without using TreeGridFramework.aspx

   ' By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
   ' The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
   ' The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
   Dim UseMDB As Boolean = False

   ' --- Database initialization ---
   Dim Path As String = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)
   Dim Conn As System.Data.IDbConnection = Nothing
      
   If UseMDB Then ' For MS Acess database
      Conn = New System.Data.OleDb.OleDbConnection("Data Source=""" + Path + "\\..\\Database.mdb"";Provider=""Microsoft.Jet.OLEDB.4.0"";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1")
   Else ' For SQLite database
      Dim SQLite As System.Reflection.Assembly = Nothing ' Required only for SQLite database
      Dim bits As String = "32" : If IntPtr.Size <> 4 Then bits = "64"
      SQLite = System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + bits + "\\System.Data.SQLite.DLL")
      Conn = Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db")
   End If
   Conn.Open()
   Dim Cmd As System.Data.IDbCommand = Conn.CreateCommand()
   
   ' --- Response initialization ---
   Response.ContentType = "text/xml"
   Response.Charset = "utf-8"
   Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
   System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US")
   
   ' --- Request read --- 
   Dim XML As String = Request("TGData")
   If XML = Nothing Then XML = "<Grid><Cfg SortCols='Week,Hours' SortTypes='1,0'/><Body><B Pos='3'/></Body></Grid>" ' Just for examples if called directly

   Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()
   X.LoadXml(HttpUtility.HtmlDecode(XML))
   
   ' --- Parses sorting settings ---
   Dim Cfg As System.Xml.XmlElement = CType(X.GetElementsByTagName("Cfg")(0), System.Xml.XmlElement)
   Dim SC() As String = Cfg.GetAttribute("SortCols").Split(",".ToCharArray())
   Dim ST() As String = Cfg.GetAttribute("SortTypes").Split(",".ToCharArray())
   Dim S As String = ""
   Dim i As Integer
   If SC(0) <> "" Then
      For i = 0 To SC.Length - 1
         If S <> "" Then S += ", "
         S = S + SC(i)
         If Int32.Parse(ST(i)) >= 1 Then S = S + " DESC"
      Next i
      If S <> "" Then S = " ORDER BY " + S
   End If

   ' --- Gets information about page number ---
   Dim pos As Integer = Int32.Parse(CType(X.GetElementsByTagName("B")(0), System.Xml.XmlElement).GetAttribute("Pos"))
   Dim start As Integer = pos * 21      ' 21 = PageLength

   ' --- Reads data from database ---
   Cmd.CommandText = "SELECT * FROM TableData" + S
  
   Dim R As System.Data.IDataReader = Cmd.ExecuteReader()
   
   ' --- Throws away data in front of requested page ---
   i = 0
   Do While i < start And R.Read()
      i = i + 1
   Loop
   
   ' --- Writes data for requested page ---
   Response.Write("<Grid><Body><B Pos='" + pos.ToString() + "'>")
   Do While i < start + 21 And R.Read()
      Response.Write("<I id='" + R(0).ToString() + "'" _
         + " Project='" + R(1).ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'" _
         + " Resource='" + R(2).ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'" _
         + " Week='" + R(3).ToString() + "'" _
         + " Hours='" + R(4).ToString() + "'" _
         + "/>")
      i = i + 1
   Loop
   Response.Write("</B></Body></Grid>")
   R.Close()
   Conn.Close()

%>