<%@ Page language="vb"%>
<!--#include file="../Framework/TreeGridFramework.aspx"-->
<script language="vb" runat="server">
   '! Support file only, run Framework.html instead !
   ' Uses new ASP.NET style scripting with event Page_Load, uses TreeGrid framework
   ' -------------------------------------------------------------------------------------------------------------------------------
   Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
      Dim bits As String = "32" : If IntPtr.Size <> 4 Then bits = "64" ' Only for SQLite
      Dim SQLiteDLL As String = GetPath() + "\\..\\..\\..\\Server\\SQLite" + bits + "\\System.Data.SQLite.DLL" ' Only for SQLite
      Dim Source As String
      'Source = "Data Source=""" + GetPath() + "\\..\\Database.mdb"";Provider=""Microsoft.Jet.OLEDB.4.0"";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1" ' MS Access MDB database
      Source = "Data Source=" + GetPath() + "\\..\\Database.db" ' SQLite database
      
      Dim Grid As TreeGrid = New TreeGrid(Source, "SELECT * FROM TableData", "ID", "", "", "", SQLiteDLL)
      '1 - Connection string
      '2 - SQL Selection command to select all rows from database, used also for saving data back
      '3 - Column name in database table where are stored unique row ids
      '4 - Prefix added in front of id, used if ids are number type
      '5 - Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
      '6 - Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree _
      Dim XML As String = Request("TGData")
      Dim UserParam As String = Request("Userparam")  ' User parameter has value = "UserValue" set in HTML
      Response.ContentType = "text/xml"
      Response.Charset = "utf-8"
      Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
      If XML <> "" And XML <> Nothing Then
         Grid.SaveXMLToDB(XML)            ' Saves data to database
         Response.Write("<Grid><IO Result='0'/></Grid>")
      Else
         Response.Write(Grid.LoadXMLFromDB())  ' Loads data from database  
      End If
   End Sub
   ' -------------------------------------------------------------------------------------------------------------------------------
</script>
