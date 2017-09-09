<%@ Page language="vb" Debug="true"%>
<%
   '! Support file only, run Schools.html instead !
   ' This file is used as Page_Url
   ' Loads and returns reviews for given record

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
   Dim R As System.Data.IDataReader
   
   ' --- Response initialization ---
   Response.ContentType = "text/xml"
   Response.Charset = "utf-8"
   Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
   System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US")

   ' --- Returns ratings for the row as server child page --- 
   Dim XML As String = Request("TGData")
   If XML = Nothing Then XML = "<Grid><Body><B id='jan$Main$1'/></Body></Grid>" ' Just for examples if called directly
   Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()
   X.LoadXml(HttpUtility.HtmlDecode(XML))
   Dim Ch As System.Xml.XmlNodeList = X.GetElementsByTagName("B")
   Response.Write("<Grid><Body>")
   Dim Pos As Integer = 1
   For Each I As System.Xml.XmlElement In Ch
      Dim id() As String : id = I.GetAttribute("id").Split("$".ToCharArray())  ' User$Def$Ident
      Response.Write("<B id='" + I.GetAttribute("id") + "'>")
      Cmd.CommandText = "SELECT * FROM Schools_Ratings WHERE Owner='" + id(0).Replace("'", "''") + "' AND Id=" + id(2)
      R = Cmd.ExecuteReader()
      Do While (R.Read())
         Response.Write("<I Def='Review' CName='" + R("ADate").ToString() _
            + "' CCountry='" + R("Review").ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") _
            + "' Ident='" + I.GetAttribute("id") + "_" + Pos.ToString() + "' CRating='" + R("Stars").ToString() + "'/>")
         Pos = Pos + 1
      Loop
      R.Close()
      Response.Write("</B>")
   Next I
   Response.Write("</Body></Grid>")
   Conn.Close()
   ' --------------------------------------------------------------------------
%>