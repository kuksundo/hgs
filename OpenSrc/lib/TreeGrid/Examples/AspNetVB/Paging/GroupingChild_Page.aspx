<%@ Page language="vb" Debug="true"%>
<%
   '! Support file only, run Grouping.html instead !
   ' This file is used as Page_Url
   ' Generates data for one TreeGrid page or parent row from database, according to grouping information
   '! Demonstrates Server paging with Server child paging
   ' This is only simple example with not ideal database access (for every page gets all data)
   ' Single file, without using TreeGridFramework.aspx
%>

<script runat=server>
   ' -------------------------------------------------------------------------------------------------------------------------------
   ' Helper function, converts object to XML string, escapes entities
   Function ToXmlString(ByVal O As Object) As String
      Return "'" + O.ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'"
   End Function
   
   ' -------------------------------------------------------------------------------------------------------------------------------
   ' Helper function, converts object to SQL string, escapes apostrophes
   Function ToSqlString(ByVal name As String, ByVal O As Object) As String
      If name = "Week" Or name = "Hours" Then
         Return O.ToString()
      Else
         Return "'" + O.ToString().Replace("'", "''") + "'"
      End If
   End Function
   ' ------------------------------------------------------------------------------------------------------------------------------- 
   ' Writes one level of grouped children
   ' Uses recursion to write next levels
   ' Level is actual level to write
   ' Where is WHERE clause for SQL, for every level there is added one condition
   ' GroupCols, Cmd, Levels are static paramterers
   ' Start is used only for level 0 to specify how much rows to ignore before the page
   Sub WriteLevel(ByVal Level As Integer, ByVal Where As String, ByVal GroupCols() As String, ByVal Cmd As System.Data.IDbCommand, ByVal Levels As Integer, ByVal Start As Integer)

      If Level = Levels Then
         Cmd.CommandText = "SELECT * FROM TableData" + Where
      Else
         Cmd.CommandText = "SELECT DISTINCT " + GroupCols(Level) + " FROM TableData" + Where
      End If
      Dim R As System.Data.IDataReader = Cmd.ExecuteReader()
      If Level = 0 Then ' On level 0 throws away data in front of requested page         
         Dim i As Integer
         For i = 0 To Start - 1
            If Not R.Read() Then Exit For
         Next
      End If
         
      Dim Max As Integer : Max = 20 ' 21 rows per page on level 0
      While (R.Read())
   
         If Level = Levels Then    ' Final, writing data row
      
            Response.Write("<I id='" + R(0).ToString() + "'" _
                  + " Project=" + ToXmlString(R(1)) _
                  + " Resource=" + ToXmlString(R(2)) _
                  + " Week='" + R(3).ToString() + "'" _
                  + " Hours='" + R(4).ToString() + "'" _
                  + "/>")
      
         Else                      ' Next grouping row
      
            Response.Write("<I Def='Group' Project=" + ToXmlString(R(0))) ' writes the grouping row
            Dim Where2 As String
            If Level = 0 Then
               Where2 = " WHERE "
            Else
               Where2 = " AND "
            End If
            Where2 = Where2 + GroupCols(Level) + "=" + ToSqlString(GroupCols(Level), R(0))
            
            Dim Rows As String : Rows = (Level + 1).ToString() + Where + Where2 ' Builds new attribute Rows for identification
            Response.Write(" Rows=" + ToXmlString(Rows) + " Count='1'></I>") ' Sets Count to 1 instead of searching exact count of children to speed up the process
         End If
         Max = Max - 1
         If Level = 0 And Max < 0 Then Exit While ' On level 0 maximally 21 rows per page
      End While
      R.Close()
   End Sub
   ' -------------------------------------------------------------------------------------------------------------------------------
</script>

<%
   ' -------------------------------------------------------------------------------------------------------------------------------

   ' By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
   ' The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
   ' The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
   Dim UseMDB As Boolean = False

   ' --- Response initialization ---
   Response.ContentType = "text/xml"
   Response.Charset = "utf-8"
   Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
   System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US")

   ' --- Parse XML request ---
   Dim XML As String : XML = Request("TGData")
   If XML = Nothing Then XML = "<Grid><Cfg GroupCols='Resource,Week'/><Body><B Pos='2'/></Body></Grid>" ' Just for examples if called directly
   Dim X As System.Xml.XmlDocument : X = New System.Xml.XmlDocument()
   X.LoadXml(HttpUtility.HtmlDecode(XML))

   ' --- Parses Grouping settings ---
   Dim Cfg As System.Xml.XmlElement : Cfg = CType(X.GetElementsByTagName("Cfg")(0), System.Xml.XmlElement)
   Dim GroupCols() As String : GroupCols = Cfg.GetAttribute("GroupCols").Split(",".ToCharArray())
   Dim Levels As Integer
   If GroupCols(0) = "" Then ' Depth of grouping, 0 - no grouping
      Levels = 0
   Else
      Levels = GroupCols.Length
   End If
   
   ' --- Database initialization ---
   Dim Path As String = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)
   Dim Conn As System.Data.Common.DbConnection = Nothing
      
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

   ' --- Writes data for requested page ---   
   Response.Write("<Grid><Body>") ' XML Header
   Dim Rows As String = (CType(X.GetElementsByTagName("B")(0), System.Xml.XmlElement)).GetAttribute("Rows")
   If Rows <> "" Then
      Response.Write("<B Rows=" + ToXmlString(Rows) + ">") ' XML Header
      Dim Level As Integer = Int32.Parse(Rows.Substring(0, 1)) ' First character is the level
      Rows = Rows.Substring(1) ' Next string is Where
      WriteLevel(Level, Rows, GroupCols, Cmd, Levels, 0)
   Else

      Dim pos As Integer = Int32.Parse((CType(X.GetElementsByTagName("B")(0), System.Xml.XmlElement)).GetAttribute("Pos"))
      Dim start As Integer = pos * 21      ' 21 = PageLength
      Response.Write("<B Pos='" + pos.ToString() + "'>") ' XML Header
      WriteLevel(0, "", GroupCols, Cmd, Levels, start)
   End If
   Response.Write("</B></Body></Grid>") ' XML Footer
   Conn.Close()
   ' -------------------------------------------------------------------------------------------------------------------------------
%>