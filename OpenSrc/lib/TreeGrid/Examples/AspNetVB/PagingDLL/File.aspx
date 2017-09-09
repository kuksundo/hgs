<%@ Page Debug="true" %>
<%@ Import Namespace="System.Runtime.InteropServices"%>
<script runat="server" language="vb">
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
         Dim F As String : F = Request.Params("Function")
         If F = "LoadBody" Then
            Response.Write(FuncLoadBody(Request.Params("File"), Request.Params("Def"), Request.Params("Data"), Request.Params("Bonus")))
         ElseIf F = "LoadPage" Then
            Response.Write(FuncLoadPage(Request.Params("File"), Request.Params("Def"), Request.Params("Data"), Request.Params("Bonus")))
         ElseIf F = "Save" Then
            Response.Write(FuncSave(Request.Params("File"), Request.Params("Def"), Request.Params("Data"), Request.Params("Bonus")))
         ElseIf F = "Export" Then
            Response.Write(FuncExport(Request.Params("File"), Request.Params("Def"), Request.Params("Data"), Request.Params("Bonus")))
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
      Dim Err As String : Err = Nothing
      If num <> 0 And Loaded Then Err = LastError()
      If Err <> Nothing Then mess = mess + "\n\n" + Err
      If mess <> "" Then mess = mess.Replace("&", "&amp;").Replace("<", "&lt;").Replace("""", "&quot;").Replace("\n", "&#x0A;")
      Return "<Grid><IO Result='" + num.ToString() + "' Message=""" + mess + """/></Grid>"
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns Grids index for given file or <0 for error
   Private Function GetIndex(ByVal File As String, ByVal Def As String, ByVal Cfg As String, ByVal Bonus As String) As Integer
      If File = "" Then Return -1
      Dim Index As Integer : Index = FindGrid(Cfg)
      If Index >= 0 Then Return Index
      Dim F As String : F = Path + "tmp\\" + GetSession(Cfg) + ".xml"
      If Not System.IO.File.Exists(F) Then F = Path + File
      Return CreateGrid(F, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", Bonus, Nothing)
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns grid data, for Paging==3 returns only empty pages with information about their content
   ' Data contains XML with grid settings - sorting and filters
   Private Function FuncLoadBody(ByVal File As String, ByVal Def As String, ByVal Data As String, ByVal Bonus As String) As String
      Dim Index As Integer : Index = GetIndex(File, Def, Data, Bonus)
      If Index < 0 Then Return GetError(-1, "Server DLL Error: TreeGrid data not found or server has not permission to read them\nData are located at " + Path + File)
      Dim Ret As String : Ret = GetBody(Index, Data)
      If Ret = Nothing Then Return GetError(-4, "Server DLL Error: TreeGrid data cannot be loaded")
      SaveToFile(Index, Path + "tmp\\" + GetGridSession(Index) + ".xml", 28)
      Return Ret
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns children of one page or one row
   ' Data contains XML with page index or row id and grid settings - sorting and filters
   Private Function FuncLoadPage(ByVal File As String, ByVal Def As String, ByVal Data As String, ByVal Bonus As String) As String
      Dim Index As Integer : Index = GetIndex(File, Def, Data, Bonus)
      If Index < 0 Then Return GetError(-1, "Server DLL Error: TreeGrid data not found")
      Dim Ret As String : Ret = GetPage(Index, Data)
      If Ret = Nothing Then Return GetError(-3, "Server DLL Error: Configuration changed, you need to reload grid!")
      Return Ret
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Saves changed data to XML file
   ' Data contains XML with changed rows
   Private Function FuncSave(ByVal File As String, ByVal Def As String, ByVal Data As String, ByVal Bonus As String) As String
      Dim Index As Integer : Index = GetIndex(File, Def, Data, Bonus)
      If Index < 0 Then Return GetError(-1, "Server DLL Error: TreeGrid data not found")
      Dim Ret As Integer : Ret = Save(Index, Data)
      If Ret < 0 Then Return GetError(Ret, "Server DLL Error: Changes were not saved")
      SaveToFile(Index, Path + "tmp\\" + GetGridSession(Index) + ".xml", 28)
      If Ret > 0 Then Return GetError(0, "Warning: Not all data were successfully saved !")
      Return GetError(0, "")
      ' In this example are data saved only temporary and not to original file
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns the whole grid in XLS/HTML
   Private Function FuncExport(ByVal File As String, ByVal Def As String, ByVal Data As String, ByVal Bonus As String) As String
      Dim Index As Integer : Index = GetIndex(File, Def, Data, Bonus)
      If Index < 0 Then Return "Server DLL Error: TreeGrid data not found"
      Dim Ret As String : Ret = GetExport(Index, Data)
      If Ret = Nothing Then Return "Server DLL Error: Configuration changed, you need to reload grid!"
      Response.AppendHeader("Content-Disposition", "attachment; filename=""Grid.xls""")
      Response.ContentType = "application/vnd.ms-excel"
      Return Ret
   End Function
   ' ----------------------------------------------------------------------------------------------------
</script>


