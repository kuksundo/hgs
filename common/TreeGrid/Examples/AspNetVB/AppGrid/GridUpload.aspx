<%@ Page language="vb" Debug="true"%>
<%
   '! Support file only, run Grid.html instead !
   ' This file is used as Upload_Url for TreeGrid
   ' It stores changed from TreeGrid to database
   ' --------------------------------------------------------------------------

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
   Dim XML As String : XML = Request("TGData")
   If XML <> "" And XML <> Nothing Then

      Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()
      X.LoadXml(HttpUtility.HtmlDecode(XML))
      Dim Ch As System.Xml.XmlNodeList = X.GetElementsByTagName("Changes")
      Dim Last As System.Collections.Specialized.StringCollection = New System.Collections.Specialized.StringCollection()
      Dim prj, res, where As String
      If Ch.Count > 0 Then
         For Each I As System.Xml.XmlElement In Ch(0)
            Dim id() As String = I.GetAttribute("id").Split("$".ToCharArray())
            
            ' --- Project row ---
            If id.Length = 1 Then
               prj = "'" + id(0).Replace("'", "''") + "'"
               where = " WHERE Project=" + prj + " "
               If I.GetAttribute("Deleted") = "1" Then
                  Cmd.CommandText = "DELETE FROM TableData" + where
                  Cmd.ExecuteNonQuery()
               ElseIf I.GetAttribute("Added") = "1" Or I.GetAttribute("Changed") = "1" Then
                  If I.HasAttribute("Project") Then Last.Add("UPDATE TableData SET Project='" + I.GetAttribute("Project").Replace("'", "''") + "'" + where)
               End If
               
               ' --- Resource row ---      
            Else
               prj = "'" + id(0).Replace("'", "''") + "'"
               res = "'" + id(1).Replace("'", "''") + "'"
               where = " WHERE Project=" + prj + " AND Resource=" + res + " "
               If I.GetAttribute("Deleted") = "1" Then
                  Cmd.CommandText = "DELETE FROM TableData" + where
                  Cmd.ExecuteNonQuery()
               ElseIf I.GetAttribute("Added") = "1" Or I.GetAttribute("Changed") = "1" Then
                  For Each A As System.Xml.XmlAttribute In I.Attributes
                     Dim name, val, week As String, w As Integer
                     name = A.Name
                     If name.Chars(0) = "W" Then   ' Hours number
                        val = A.Value.ToString()
                        week = name.Substring(1)
                        Cmd.CommandText = "SELECT ID FROM TableData" + where + " AND Week=" + week
                        Dim R As System.Data.IDataReader = Cmd.ExecuteReader()
                        If Not R.Read() Then      ' New item
                           R.Close()
                           Cmd.CommandText = "SELECT MAX(ID) FROM TableData"
                           R = Cmd.ExecuteReader() 'Creates new id, but better is to define Id in database as incremental
                           R.Read()
                           w = CInt(R(0))
                           R.Close()
                           Cmd.CommandText = "INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES (" + (w + 1).ToString() + "," + prj + "," + res + "," + week + "," + val + ")"
                           Cmd.ExecuteNonQuery()
                        Else                      ' Existing item
                           R.Close()
                           Cmd.CommandText = "UPDATE TableData SET Hours=" + val + where + " AND Week=" + week
                           Cmd.ExecuteNonQuery()
                        End If
                     End If
                  Next A
                  If I.HasAttribute("Project") Then    ' Changed resource name
                     Cmd.CommandText = "UPDATE TableData SET Resource=" + "'" + I.GetAttribute("Project").Replace("'", "''") + "'" + where
                     Cmd.ExecuteNonQuery()
                  End If
                  
               ElseIf I.GetAttribute("Moved") = "2" Then
                  Cmd.CommandText = "UPDATE TableData SET Project='" + I.GetAttribute("Parent").Replace("'", "''") + "'" + where
                  Cmd.ExecuteNonQuery()
               End If
            End If
         Next I
      End If
   
      ' --- Delayed changing project names ---'
      ' It must be done after changing all resources for the project
      For Each str As String In Last
         Cmd.CommandText = str
         Cmd.ExecuteNonQuery()
      Next str
   End If
   Conn.Close()
   ' --------------------------------------------------------------------------
%><?xml version="1.0"?>
<Grid>
   <IO Result='0'/>
</Grid>