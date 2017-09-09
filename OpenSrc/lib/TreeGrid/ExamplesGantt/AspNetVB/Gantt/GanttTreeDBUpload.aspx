<%@ Page language="vb" Debug="true"%>
<script language="vb" runat="server">
   ' Uses new ASP.NET style scripting with event Page_Load, uses OleDbDataReader and OleDbCommand to access database
   ' -------------------------------------------------------------------------------------------------------------------------------
   Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

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
      
      ' --- Save data to database ---
      Dim XML As String = Request("Data")
      If XML <> "" And XML <> Nothing Then
   
         Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()
         X.LoadXml(HttpUtility.HtmlDecode(XML))
         Dim Ch As System.Xml.XmlNodeList = X.GetElementsByTagName("Changes")
         If (Ch.Count > 0) Then
            For Each I As System.Xml.XmlElement In Ch(0)
               Dim SQL As String = ""
               Dim id As String = I.GetAttribute("id")
         
               If I.GetAttribute("Deleted") = "1" Or I.GetAttribute("ToDelete") = "1" Then
                  SQL = "DELETE FROM GanttTree WHERE ID=" + id
               ElseIf I.GetAttribute("Added") = "1" Then
                  Dim C As String
                  If I.GetAttribute("C") = "" Then C = "0" Else C = I.GetAttribute("C")
                  SQL = "INSERT INTO GanttTree(id,T,S,E,C,D,L) VALUES(" _
                      + id + "," _
                      + "'" + I.GetAttribute("T").Replace("'", "''") + "'," _
                      + "'" + I.GetAttribute("S") + "'," _
                      + "'" + I.GetAttribute("E") + "'," _
                      + C + "," _
                      + "'" + I.GetAttribute("D") + "'," _
                      + "'" + I.GetAttribute("L") + "')"
         
               ElseIf I.GetAttribute("Changed") = "1" Or I.GetAttribute("Moved") = "2" Then
                  SQL = "UPDATE GanttTree SET "
                  For Each A As System.Xml.XmlAttribute In I.Attributes
                     If A.Name = "T" Then
                        SQL += A.Name + " = '" + A.Value.Replace("'", "''") + "',"
                     ElseIf A.Name = "C" Then
                        SQL += A.Name + " = " + A.Value + ","
                     ElseIf A.Name = "S" Or A.Name = "E" Or A.Name = "D" Or A.Name = "L" Then
                        SQL += A.Name + " = '" + A.Value + "',"
                     End If
                  Next A
                  SQL = SQL.TrimEnd(",".ToCharArray()) 'Last comma away
                  SQL = SQL + " WHERE ID=" + id
               End If
               If SQL <> "" Then
                  Cmd.CommandText = SQL
                  Response.Write(SQL+Chr(10)+Chr(13)) ' Just to see the SQL in debug, but it breaks down the XML, so in real application must be removed
                  Cmd.ExecuteNonQuery()
               End If
            Next
         End If
         
      End If
      Response.Write("<Grid><IO Result='0'/></Grid>")
      Conn.Close()
   End Sub
   ' -------------------------------------------------------------------------------------------------------------------------------
</script>
