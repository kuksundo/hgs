<%@ Page language="vb" Debug="true"%>
<%
   '! Support file only, run Grid.html instead !
   ' This file is used as Data_Url for TreeGrid
   ' It generates source data for TreeGrid from database
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
   
   ' --- Generating data ---
   Cmd.CommandText = "SELECT * FROM TableData WHERE Week>0 AND Week<53 ORDER BY Project,Resource"
   Dim X As System.Data.IDataReader = Cmd.ExecuteReader()
   Dim Prj, Res, S, P, R As String
   Prj = Nothing : Res = Nothing : S = ""

   Do While X.Read()

      P = X(1).ToString()  ' Project
      R = X(2).ToString()  ' Resource
      
      If P <> Prj Then                ' New project row
         If Prj <> Nothing Then S = S + "/></I>"  ' Ends previous project and resource rows
         Prj = P: Res = Nothing
         S = S + "<I Def='Node' Project='" + Prj.Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'>"
      End If
   
      If R <> Res Then                ' New resource row
         If Res <> Nothing Then S = S + "/>"      ' Ends previous resource row         
         Res = R
         S = S + "<I Project='" + Res.Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "' "
      End If
   
      S = S + "W" + X(3).ToString() + "='" + X(4).ToString() + "' " ' Week = Hours (like W42='17')
   Loop

   If Prj <> Nothing Then S = S + "/></I>" ' Ends previous project and resource rows
   X.Close()
   Conn.Close()

   ' --------------------------------------------------------------------------
%><?xml version="1.0" ?>
<Grid>
   <Body>
      <B>
         <%=S%>
      </B>
   </Body>
</Grid>