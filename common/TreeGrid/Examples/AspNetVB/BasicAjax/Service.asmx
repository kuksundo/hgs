<%@ WebService Language="vb" Class="Service" %>
'! Support file only, run Service.html instead !
' Uses ASP.NET service as TreeGrid data source
' -------------------------------------------------------------------------------------------------------------------------------
Imports System
Imports System.Web
Imports System.Web.Services
' -------------------------------------------------------------------------------------------------------------------------------
<WebService(Namespace:="TreeGrid")> _
Public Class Service : Inherits System.Web.Services.WebService
   
   ' By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
   ' The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
   ' The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
   Dim UseMDB As Boolean = False
   
   Dim SQLite As System.Reflection.Assembly = Nothing 'Required only for SQLite database
   
   ' ----------------------------------------------------------------------------------
   Sub New()
      
   End Sub

   ' ----------------------------------------------------------------------------------
   ' Initializization for both web methods
   Function Init() As System.Data.Common.DbDataAdapter
      
      ' --- Response initialization ---
      Context.Response.ContentType = "text/xml"
      Context.Response.Charset = "utf-8"
      Context.Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
      System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US")

      ' --- Database initialization ---
      Dim Path As String = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)
      Dim Conn As System.Data.IDbConnection
      Dim SqlStr As String = "SELECT * FROM TableData"
      If UseMDB Then ' For MS Acess database
         Conn = New System.Data.OleDb.OleDbConnection("Data Source=""" + Path + "\\..\\Database.mdb"";Provider=""Microsoft.Jet.OLEDB.4.0"";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1")
         Return New System.Data.OleDb.OleDbDataAdapter(SqlStr, CType(Conn, System.Data.OleDb.OleDbConnection))
      Else ' For SQLite database
         Dim bits As String = "32" : If IntPtr.Size <> 4 Then bits = "64"
         SQLite = System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + bits + "\\System.Data.SQLite.DLL")
         Conn = Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db")
         Return Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteDataAdapter"), SqlStr, Conn)
      End If
      
   End Function
      
   ' ----------------------------------------------------------------------------------
   <WebMethod()> _
   Public Function GetData(ByVal UserParam As String) As String
      
      Try
         ' --- initialization ---
         Dim Sql As System.Data.Common.DbDataAdapter = Init()
         Dim D As System.Data.DataTable = New System.Data.DataTable()
         Sql.Fill(D)
         
         ' --- generating data ---
         Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()
         Dim G, BB, B, I As System.Xml.XmlElement
         G = X.CreateElement("Grid") : X.AppendChild(G)
         BB = X.CreateElement("Body") : G.AppendChild(BB)
         B = X.CreateElement("B") : BB.AppendChild(B)
         For Each R As System.Data.DataRow In D.Rows
            I = X.CreateElement("I")
            B.AppendChild(I)
            I.SetAttribute("id", R(0).ToString())
            I.SetAttribute("Project", R(1).ToString())
            I.SetAttribute("Resource", R(2).ToString())
            I.SetAttribute("Week", R(3).ToString())
            I.SetAttribute("Hours", R(4).ToString())
         Next
         Return X.InnerXml
      Catch E As Exception
         Return "<Grid><IO Result=""-1"" Message=""Error in TreeGrid example:&#x0a;&#x0a;" + E.Message.Replace("&", "&amp;").Replace("<", "&lt;").Replace("""", "&quot;") + """/></Grid>"
      End Try
   End Function

   ' ----------------------------------------------------------------------------------
   ' Web method saves changes to database
   <WebMethod()> _
   Public Function SaveData(ByVal TGData As String, ByVal UserParam As String) As String
      
      Try
      
         ' --- initialization ---
         Dim Sql As System.Data.Common.DbDataAdapter = Init()
         Dim D As System.Data.DataTable : D = New System.Data.DataTable()
         Sql.Fill(D)
         
         ' --- Save data to database ---
         If TGData <> "" And TGData <> Nothing Then
         
            Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()
            X.LoadXml(HttpUtility.HtmlDecode(TGData))
            Dim Ch As System.Xml.XmlNodeList = X.GetElementsByTagName("Changes")
            If Ch.Count > 0 Then
               For Each I As System.Xml.XmlElement In Ch(0)
                  Dim id As String = I.GetAttribute("id")
                  Dim R As System.Data.DataRow
                  If I.GetAttribute("Added") = "1" Then
                     R = D.NewRow()
                     R("ID") = id
                     D.Rows.Add(R)
                  Else
                     R = D.Select("[ID]='" + id + "'")(0)
                  End If
         
                  If I.GetAttribute("Deleted") = "1" Then
                     R.Delete()
                  ElseIf I.GetAttribute("Added") = "1" Or I.GetAttribute("Changed") = "1" Then
                     If I.HasAttribute("Project") Then R("Project") = I.GetAttribute("Project")
                     If I.HasAttribute("Resource") Then R("Resource") = I.GetAttribute("Resource")
                     If I.HasAttribute("Week") Then R("Week") = System.Double.Parse(I.GetAttribute("Week"))
                     If I.HasAttribute("Hours") Then R("Hours") = System.Double.Parse(I.GetAttribute("Hours"))
                  End If
               Next
            End If
            If UseMDB Then
               Dim Bld As System.Data.OleDb.OleDbCommandBuilder = New System.Data.OleDb.OleDbCommandBuilder(Sql)  ' For MS Acess database
            Else
               Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteCommandBuilder"), Sql) ' For SQLite database
            End If
            Sql.Update(D)                     ' Updates changed to database
         End If
         Return "<Grid><IO Result='0'/></Grid>"
         
      Catch E As Exception
         Return "<Grid><IO Result=""-1"" Message=""Error in TreeGrid example:&#x0a;&#x0a;" + E.Message.Replace("&", "&amp;").Replace("<", "&lt;").Replace("""", "&quot;") + """/></Grid>"
      End Try
   End Function
   ' ----------------------------------------------------------------------------------
End Class
' -------------------------------------------------------------------------------------------------------------------------------

