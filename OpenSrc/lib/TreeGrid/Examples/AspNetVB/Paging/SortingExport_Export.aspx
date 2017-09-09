<%@ Page Language="vb" Debug="true" ContentType="application/vnd.ms-excel"%>
<%
   '! Support file only, run SortingExport.html instead !
   ' This file is used as Export_Url
   ' Generates data to export to Excel
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
   Response.Charset = "utf-8"
   Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
   System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US")
   Dim file As String = Request("File") : If file = Nothing Then file = "Export.xls"
   Response.AppendHeader("Content-Disposition", "attachment; filename=""" + file + """")

   ' --- Request read ---   
   Dim XML As String = Request("TGData")
   If XML = Nothing Then XML = "<Grid><Cfg SortCols='Week,Hours' SortTypes='1,0'/><Cols><C Name='Project' Visible='1' Width='200'/><C Name='Resource' Visible='1' Width='150'/><C Name='Week' Visible='1' Width='60'/><C Name='Hours' Visible='1' Width='60'/></Cols></Grid>" ' Just for examples if called directly

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
   
   ' --- Parses Column position, visibility and width ---
   Dim Cols As System.Xml.XmlNodeList = X.GetElementsByTagName("C")
   Dim N(4) As String
   Dim p As Integer = 0
   Dim W(4) As String
   For Each C As System.Xml.XmlElement In Cols
      If C.GetAttribute("Visible") <> "0" Then
         N(p) = C.GetAttribute("Name")
         w(p) = C.GetAttribute("Width")
         p = p + 1
      End If
   Next C


   ' --- Reads data from database ---
   Cmd.CommandText = "SELECT * FROM TableData" + S
   Dim R As System.Data.IDataReader = Cmd.ExecuteReader()
   
   ' --- Writes Excel settings ---
   Response.Write("<html xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:x=""urn:schemas-microsoft-com:office:excel"" xmlns=""http://www.w3.org/TR/REC-html40"">")
   Response.Write("<head><meta http-equiv=Content-Type content=""text/html; charset=utf-8""></head><body>")
   Response.Write("<style>td {white-space:nowrap}</style>")
   Response.Write("<table border=1 bordercolor=silver style='table-layout:fixed;border-collapse:collapse;border:1px solid black'>")
   
   ' --- Writes columns' widths ---
   For i = 0 To p - 1
      Response.Write("<col width='" + w(i) + "'>")
   Next i

   ' --- Writes captions ---
   Response.Write("<tr>")
   For i = 0 To p - 1
      Response.Write("<td style='border-bottom:1px solid black;background:yellow;font-weight:bold;'>" + N(i) + "</td>")
   Next i
   Response.Write("</tr>")
   
   ' --- Writes data ---
   While (R.Read())
      Response.Write("<tr>")
      For i = 0 To p - 1
         If N(i) = "Resource" Or N(i) = "Project" Then ' string
            Response.Write("<td>" + R(N(i)).ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "</td>")
         Else
            Response.Write("<td x:num='" + R(N(i)).ToString() + "'>" + R(N(i)).ToString() + "</td>")
         End If
      Next i
      Response.Write("</tr>")
   End While

   ' ---
   Response.Write("</table></body></html>")
   R.Close()
   Conn.Close()
   ' --------------------------------------------------------------------------
%>