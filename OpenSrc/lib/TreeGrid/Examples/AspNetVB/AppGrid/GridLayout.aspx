<%@ Page language="vb" Debug="true"%>
<%
   ' -------------------------------------------------------------------------- 
   '! Support file only, run Grid.html instead !
   ' This file is used as Layout_Url for TreeGrid
   ' It generates layout structure for TreeGrid from database
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

   ' --- Generating layout ---
   Cmd.CommandText = "SELECT MIN(Week),MAX(Week) FROM TableData WHERE Week>0 AND Week<53"
   Dim R As System.Data.IDataReader = Cmd.ExecuteReader()
   R.Read()
   Dim i, Min, Max As Integer
   Min = CInt(CDbl(R(0)))
   Max = CInt(CDbl(R(1)))
   Dim Cols, CSum, DRes, DDef As String
   Cols = "" : CSum = "" : DRes = "" : DDef = ""
   For i = Min To Max
      Dim Week As String : Week = "W" + i.ToString()
      Cols = Cols + "<C Name='" + Week + "' Type='Float'/>" ' Column definitions
      If CSum <> "" Then CSum = CSum + "+"
      CSum = CSum + Week                                   ' Right fixed result column formula
      DRes = DRes + Week + "Formula='sum()' "              ' Tree result row formulas
      DDef = DDef + Week + "='0' "                         ' Default values for data rows
   Next i
   R.Close()
   Conn.Close()

   ' --------------------------------------------------------------------------
%><?xml version="1.0"?>
<Grid>
   <Cfg id='ResourceGrid' MainCol='Project' MaxHeight='1' ShowDeleted="0" DateStrings='1' 
      IdNames='Project' AppendId='1' FullId='1' IdChars='0123456789' NumberId='1' LastId='1'/>
   <LeftCols>
      <C Name='id' CanEdit='0'/>
      <C Name='Project' Width='250' Type='Text'/>
   </LeftCols>
   <Cols><%=Cols%>
   </Cols>
   <RightCols>
      <C Name='Sum' Width='50' Type='Float' Formula='<%=CSum%>' Format='0.##'/>
   </RightCols>
   <Def>
      <D Name='R' Project='New resource' CDef='' AcceptDef='' <%=DDef%>/>
      <D Name='Node' Project='New project' CDef='R' AcceptDef='R' Calculated='1' SumFormula='sum()' <%=DRes%> ProjectHtmlPrefix='&lt;B>' ProjectHtmlPostfix='&lt;/B>'/>
   </Def>
   <Root CDef='Node' AcceptDef='Node' />
   <Header id='id (debug)' Project='Project / resource'/>
   <Foot>
      <I Kind='Space' RelHeight='100'/>
      <I Def='Node' Project='Total results' ProjectCanEdit='0'/>
   </Foot>
</Grid>