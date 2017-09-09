<%@ Import Namespace="System.Runtime.InteropServices"%>
<script language="vb" runat="server">
   ' By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
   ' The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
   ' The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
   Dim UseMDB As Boolean = False

   ' --------------------------------------------------------------------------------
   Private Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs)
      RunInit()
   End Sub
   
   ' ----------------------------------------------------------------------------------------------------
   Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
      Try
         ' --- Response initialization ---
         Response.ContentType = "text/xml"
         Response.Charset = "utf-8"
         Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
         If Not Loaded Then Response.Write(GetError(-5, "TreeGrid.dll not found or cannot be loaded")) : Return

         ' --- Function switch ---
         Dim F As String = Request.Params("Function")
         If F = "LoadBody" Then
            Response.Write(FuncLoadBody(Request.Params("Table"), Request.Params("Def"), Request.Params("Data"), Request.Params("Bonus")))
         ElseIf F = "LoadPage" Then
            Response.Write(FuncLoadPage(Request.Params("Table"), Request.Params("Def"), Request.Params("Data"), Request.Params("Bonus")))
         ElseIf F = "Save" Then
            Response.Write(FuncSave(Request.Params("Table"), Request.Params("Def"), Request.Params("Data"), Request.Params("Bonus")))
         ElseIf F = "Export" Then
            Response.Write(FuncExport(Request.Params("Table"), Request.Params("Def"), Request.Params("Data"), Request.Params("Bonus")))
         Else
            Response.Write(GetError(-3, "Wrong function requested"))
         End If
      Catch ex As Exception
         Response.Write(GetError(-3, ex.Message))
      End Try
   End Sub
   ' ----------------------------------------------------------------------------------------------------

   
   ' ----------------------------------------------------------------------------------------------------
   ' Inicialization and TreeGrid.dll loading
   Private Sub RunInit()
      Path = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath) + "\\"
      Dim DLL As String = "TreeGrid.dll" : If IntPtr.Size = 8 Then DLL = "DLL64\\" + DLL
      Loaded = Not LoadLibrary(Path + "..\\..\\..\\Server\\" + DLL).Equals(IntPtr.Zero)
   End Sub
   
   ' ----------------------------------------------------------------------------------------------------
   Private Path As String     ' Path to data directory
   Private Loaded As Boolean  ' If DLL successfuly loaded
   
   ' ----------------------------------------------------------------------------------------------------
   ' TreeGrid.dll import
   Declare Auto Function LoadLibrary Lib "kernel32.dll" (ByVal lpFileName As String) As IntPtr
   Declare Unicode Function CreateGrid Lib "TreeGrid.dll" (ByVal Data As String, ByVal Layout As String, ByVal Defaults As String, ByVal Text As String, _
   ByVal Bonus As String, ByVal Bonus2 As String) As Integer
   Declare Unicode Function UpdateGrid Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal Bonus As String) As Integer
   Declare Unicode Function FindGrid Lib "TreeGrid.dll" (ByVal Cfg As String) As Integer
   Declare Unicode Function FindGrids Lib "TreeGrid.dll" (ByVal Indexes As IntPtr, ByVal Max As Integer, ByVal Cfg As String, ByVal Seconds As Integer, _
   ByVal Type As Integer) As Integer
   Public Function FindGrids(ByVal Indexes() As Integer, ByVal Max As Integer, ByVal Cfg As String, ByVal Seconds As Integer, ByVal Type As Integer) As Integer
      Return FindGrids(GCHandle.Alloc(Indexes, GCHandleType.Pinned).AddrOfPinnedObject(), Max, Cfg, Seconds, Type)
   End Function
   Declare Unicode Function GetSession Lib "TreeGrid.dll" (ByVal Cfg As String) As String
   Declare Unicode Function GetGridSession Lib "TreeGrid.dll" (ByVal Index As Integer) As String
   Declare Unicode Function DeleteGrid Lib "TreeGrid.dll" (ByVal Index As Integer) As Integer
   Declare Unicode Sub Clear Lib "TreeGrid.dll" ()
   Declare Unicode Function GetBody Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal Cfg As String) As String
   Declare Unicode Function GetPage Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal Cfg As String) As String
   Declare Unicode Function GetExport Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal Cfg As String) As String
   Declare Unicode Function Save Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal Input As String) As Integer
   Declare Unicode Function SaveEx Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal Input As String, ByVal Type As Integer) As Integer
   Declare Unicode Function SaveToFile Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal FileName As String, ByVal Type As Integer) As Integer
   Declare Unicode Function GetData Lib "TreeGrid.dll" (ByVal Index As Integer) As String
   Declare Unicode Function GetLastId Lib "TreeGrid.dll" (ByVal Index As Integer) As String
   Declare Unicode Function GetChanges Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal Type As Integer) As String
   Declare Unicode Function SetGridLocale Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal Locale As String) As Integer
   Declare Unicode Sub EnterRead Lib "TreeGrid.dll" ()
   Declare Unicode Sub LeaveRead Lib "TreeGrid.dll" ()
   Declare Unicode Sub EnterWrite Lib "TreeGrid.dll" ()
   Declare Unicode Sub LeaveWrite Lib "TreeGrid.dll" ()

   ' --- Debug version ---
   Declare Unicode Function LastError Lib "TreeGrid.dll" () As String
   Declare Unicode Function SetDebug Lib "TreeGrid.dll" (ByVal Index As Integer, ByVal FileName As String) As Integer

   ' ----------------------------------------------------------------------------------------------------
   ' Returns Xml with given error message
   Private Function GetError(ByVal num As Integer, ByVal mess As String) As String
      Dim Err As String = Nothing
      If num <> 0 And Loaded Then Err = LastError()
      If Err <> Nothing Then mess = mess + "\n\n" + Err
      If mess <> "" Then mess = mess.Replace("&", "&amp;").Replace("<", "&lt;").Replace("""", "&quot;").Replace("\n", "&#x0A;")
      Return "<Grid><IO Result='" + num.ToString() + "' Message=""" + mess + """/></Grid>"
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns filled data table
   Private Function InitDB() As System.Data.IDbCommand
      Dim Conn As System.Data.IDbConnection = Nothing
      If UseMDB Then ' For MS Acess database
         'Conn = New System.Data.OleDb.OleDbConnection("Data Source=""" + Path + "\\..\\Database.mdb"";Provider=""Microsoft.Jet.OLEDB.4.0"";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1")
      Else ' For SQLite database
         Dim SQLite As System.Reflection.Assembly = Nothing ' Required only for SQLite database
         Dim bits As String = "32" : If IntPtr.Size <> 4 Then bits = "64"
         SQLite = System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + bits + "\\System.Data.SQLite.DLL")
         Conn = Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db")
      End If
      Conn.Open()
      Return Conn.CreateCommand()
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns Grids index for given file or <0 for error
   Private Function GetIndex(ByVal Table As String, ByVal Def As String, ByVal Cfg As String, ByVal Bonus As String) As Integer
      If Table = "" Then Return -1
      Dim Index As Integer = FindGrid(Cfg)
      If Index >= 0 Then Return Index
      Dim F As String = Path + "tmp\\" + GetSession(Cfg) + ".xml"
      If System.IO.File.Exists(F) Then Return CreateGrid(F, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", Bonus, Nothing)
   
      ' --- Loading data from database ---
      Dim Cmd As System.Data.IDbCommand = InitDB()
      Cmd.CommandText = "SELECT * FROM " + Table
      Dim R As System.Data.IDataReader = Cmd.ExecuteReader()
      Dim S As StringBuilder = New StringBuilder()
      S.Append("<Grid><Body><B>")
      Do While R.Read()
         S.Append("<I id='" + R(0).ToString() + "'" _
            + " Project='" + R(1).ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'" _
            + " Resource='" + R(2).ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'" _
            + " Week='" + R(3).ToString() + "'" _
            + " Hours='" + R(4).ToString() + "'" _
            + "/>")
      Loop
      S.Append("</B></Body></Grid>")

      ' --- Creates grid from data ---
      Return CreateGrid(S.ToString(), Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", Bonus, Nothing)
   End Function
   ' ----------------------------------------------------------------------------------------------------
   ' Returns grid data, for Paging==3 returns only empty pages with information about their content
   ' Data contains XML with grid settings - sorting and filters
   Private Function FuncLoadBody(ByVal File As String, ByVal Def As String, ByVal Data As String, ByVal Bonus As String) As String
      Dim Index As Integer = GetIndex(File, Def, Data, Bonus)
      If Index < 0 Then Return GetError(-1, "Server DLL Error: TreeGrid data not found or server has not permission to read them\nData are located at " + Path + File)
      Dim Ret As String = GetBody(Index, Data)
      If Ret = Nothing Then Return GetError(-4, "Server DLL Error: TreeGrid data cannot be loaded")
      SaveToFile(Index, Path + "tmp\\" + GetGridSession(Index) + ".xml", 28)
      Return Ret
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns children of one page or one row
   ' Data contains XML with page index or row id and grid settings - sorting and filters
   Private Function FuncLoadPage(ByVal File As String, ByVal Def As String, ByVal Data As String, ByVal Bonus As String) As String
      Dim Index As Integer = GetIndex(File, Def, Data, Bonus)
      If Index < 0 Then Return GetError(-1, "Server DLL Error: TreeGrid data not found")
      Dim Ret As String = GetPage(Index, Data)
      If Ret = Nothing Then Return GetError(-3, "Server DLL Error: Configuration changed, you need to reload grid!")
      Return Ret
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Saves changed data to XML file
   ' Data contains XML with changed rows
   Private Function FuncSave(ByVal File As String, ByVal Def As String, ByVal Data As String, ByVal Bonus As String) As String
      ' --- Save changes to DLL ---
      Dim Index As Integer = GetIndex(File, Def, Data, Bonus)
      If Index < 0 Then Return GetError(-1, "Server DLL Error: TreeGrid data not found")
      Dim Ret As Integer = Save(Index, Data)
      If Ret < 0 Then Return GetError(Ret, "Server DLL Error: Changes were not saved")
      SaveToFile(Index, Path + "tmp\\" + GetGridSession(Index) + ".xml", 28)

      ' --- Save changes to database ---
      Dim Cmd As System.Data.IDbCommand = InitDB()
      Dim X As System.Xml.XmlDocument : X = New System.Xml.XmlDocument()
      X.LoadXml(HttpUtility.HtmlDecode(Data))
      Dim Ch As System.Xml.XmlNodeList = X.GetElementsByTagName("Changes")
      If (Ch.Count > 0) Then
         For Each I As System.Xml.XmlElement In Ch(0)
            Dim SQL As String = ""
            Dim id As String = I.GetAttribute("id")
         
            If I.GetAttribute("Deleted") = "1" Then
               SQL = "DELETE FROM TableData WHERE ID=" + id

            ElseIf I.GetAttribute("Added") = "1" Then
               SQL = "INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES(" _
                  + id + "," _
                  + "'" + I.GetAttribute("Project").Replace("'", "''") + "'," _
                  + "'" + I.GetAttribute("Resource").Replace("'", "''") + "'," _
                  + I.GetAttribute("Week") + "," _
                  + I.GetAttribute("Hours") + ")"
               
            ElseIf I.GetAttribute("Changed") = "1" Then
               SQL = "UPDATE TableData SET "
               For Each A As System.Xml.XmlAttribute In I.Attributes
                  If A.Name = "Project" Or A.Name = "Resource" Then
                     SQL += A.Name + " = '" + A.Value.Replace("'", "''") + "',"
                  ElseIf A.Name = "Week" Or A.Name = "Hours" Then
                     SQL += A.Name + " = " + A.Value + ","
                  End If
               Next A
               SQL = SQL.TrimEnd(",".ToCharArray()) 'Last comma away
               SQL = SQL + " WHERE ID=" + id
            End If
               
            Cmd.CommandText = SQL
            Cmd.ExecuteNonQuery()
         Next I
      End If
                           
      If Ret > 0 Then Return GetError(0, "Warning: Not all data were successfully saved !")
      Return GetError(0, "")
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns the whole grid in XLS/HTML
   Private Function FuncExport(ByVal File As String, ByVal Def As String, ByVal Data As String, ByVal Bonus As String) As String
      Dim Index As Integer = GetIndex(File, Def, Data, Bonus)
      If Index < 0 Then Return "Server DLL Error: TreeGrid data not found"
      Dim Ret As String = GetExport(Index, Data)
      If Ret = Nothing Then Return "Server DLL Error: Configuration changed, you need to reload grid!"
      Response.AppendHeader("Content-Disposition", "attachment; filename=""Grid.xls""")
      Response.ContentType = "application/vnd.ms-excel"
      Return Ret
   End Function
   ' ----------------------------------------------------------------------------------------------------
</script>
