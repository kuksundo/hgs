Imports System
Imports System.Data
Imports System.Configuration
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls

Public Class TreeGrid : Inherits System.Web.UI.Page
    Protected TGData As HtmlInputHidden

   Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
      ' By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
      ' The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
      ' The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
      Dim UseMDB As Boolean = False

      ' --- Response initialization ---
      Response.ContentType = "text/html"
      Response.Charset = "utf-8"
      Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
      System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US")

      ' --- Database initialization ---
      Dim Path As String = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)
      Dim Conn As System.Data.IDbConnection = Nothing
      Dim Sql As System.Data.Common.DbDataAdapter = Nothing
      Dim SqlStr As String = "SELECT * FROM TableData"
      Dim SQLite As System.Reflection.Assembly = Nothing ' Required only for SQLite database

      If UseMDB Then ' For MS Acess database
         Conn = New System.Data.OleDb.OleDbConnection("Data Source=""" + Path + "\\..\\Database.mdb"";Provider=""Microsoft.Jet.OLEDB.4.0"";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1")
         Sql = New System.Data.OleDb.OleDbDataAdapter("SELECT * FROM TableData", CType(Conn, System.Data.OleDb.OleDbConnection))
      Else ' For SQLite database
         Dim bits As String = "32" : If IntPtr.Size <> 4 Then bits = "64"
         SQLite = System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + bits + "\\System.Data.SQLite.DLL")
         Conn = Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db")
         Sql = Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteDataAdapter"), SqlStr, Conn)
      End If

      Dim D As System.Data.DataTable = New System.Data.DataTable()
      Sql.Fill(D)

      Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()

      ' --- Save data to database ---
      Dim XML As String = TGData.Value
      If XML <> "" And XML <> Nothing Then
         X.LoadXml(HttpUtility.HtmlDecode(XML))
         Dim Ch As System.Xml.XmlNodeList = X.GetElementsByTagName("Changes")
         If Ch.Count > 0 Then
            For Each I As System.Xml.XmlElement In Ch(0)
               Dim id As String : id = I.GetAttribute("id")
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
            Next I
         End If
         If UseMDB Then
            Dim Bld As System.Data.OleDb.OleDbCommandBuilder = New System.Data.OleDb.OleDbCommandBuilder(Sql) ' For MS Acess database
         Else
            Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteCommandBuilder"), Sql) ' For SQLite database
         End If
         Sql.Update(D)                    ' Updates changed to database
         D.AcceptChanges()
         X.RemoveAll()
      End If

      ' --- Load data from database ---
      Dim G, BB, B, F As System.Xml.XmlElement
      G = X.CreateElement("Grid") : X.AppendChild(G)
      BB = X.CreateElement("Body") : G.AppendChild(BB)
      B = X.CreateElement("B") : BB.AppendChild(B)
      For Each R As System.Data.DataRow In D.Rows
         F = X.CreateElement("I")
         B.AppendChild(F)
         F.SetAttribute("id", R(0).ToString())
         F.SetAttribute("Project", R(1).ToString())
         F.SetAttribute("Resource", R(2).ToString())
         F.SetAttribute("Week", R(3).ToString())
         F.SetAttribute("Hours", R(4).ToString())
      Next R
      TGData.Value = X.InnerXml
   End Sub
End Class
