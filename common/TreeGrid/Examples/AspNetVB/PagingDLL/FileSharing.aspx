<%@ Import Namespace="System.Runtime.InteropServices" %>
<script language="vb" runat="server">
   ' --------------------------------------------------------------------------------
   ' Sample web page to generate and update TreeGrid data, using TreeGrid.dll
   ' This script can control more grids in more XML files at once
   ' Saves all changes in all instances of one file to this file and does not care about file sharing
   ' For saving it creates one virtual instance in memory and when saving, updates it and saves it to disk
   ' When saving, also updates all instances of specified XML file in memory
   ' It does not use Cache and also does not delete unused instances
   ' For real application you should implement deleting unused instances and may be saving their data to temporary file
   ' TreeGrid.dll must be placed in the ../../../server/ directory, or the path must be changed in Init() function
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
            Response.Write(FuncLoadBody(Request.Params("File"), Request.Params("Def"), Request.Params("Cfg")))
         ElseIf F = "LoadPage" Then
            Response.Write(FuncLoadPage(Request.Params("Cfg")))
         ElseIf F = "Save" Then
            Response.Write(FuncSave(Request.Params("File"), Request.Params("Changes")))
         ElseIf F = "CheckUpdates" Then
            Response.Write(FuncCheckUpdates(Request.Params("File"), Request.Params("Cfg")))
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
   ' Returns grid data, for Paging==3 returns only empty pages with information about their content
   ' Cfg contains XML with grid settings - sorting and filters
   Private Function FuncLoadBody(ByVal File As String, ByVal Def As String, ByVal Cfg As String) As String
      EnterWrite() ' Enter critical section, because searching grid and creating new instance should not be interrupted by other request
      Dim Index As Integer : Index = FindGrid(Cfg) ' Searches for grid according to Session attribute - if this grid exists already
      If Index < 0 Then ' No instance of the grid exists
         Dim Ident As String : Ident = "<Grid><Cfg Ident='" + File + "'/></Grid>" ' Group identification for save, uses custom TreeGrid attribute
         Dim Tmp() As Integer : Tmp = Nothing
         Dim IdentCount As Integer : IdentCount = FindGrids(Tmp, 1, Ident, 0, 0)
         Dim CfgPaging As String : CfgPaging = "<Grid><Cfg Paging='3' ChildPaging='3'/></Grid>"
         Dim F As String : F = Path + "tmp\\Shared" + File
         If Not System.IO.File.Exists(F) Then F = Path + File
         If IdentCount = 0 Then ' The first instance for saving of the grid does not exist, it will be created
            CreateGrid(F, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", CfgPaging, Ident)
         End If
         Index = CreateGrid(F, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", CfgPaging, Ident)
      End If
      LeaveWrite()
      If Index < 0 Then Return GetError(-1, "Server DLL Error: TreeGrid data not found or server has not permission to read them")
      Dim Ret As String : Ret = GetBody(Index, Cfg)
      If Ret = Nothing Then Return GetError(-4, "Server DLL Error: TreeGrid data cannot be loaded")
      Return Ret
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns children of one page or one row
   ' Cfg contains XML with page index or row id and grid settings - sorting and filters
   Private Function FuncLoadPage(ByVal Cfg As String) As String
      Dim Index As Integer : Index = FindGrid(Cfg)
      If Index < 0 Then Return GetError(-3, "Server DLL Error: Your temporary data have been deleted already, please reload grid!")
      Dim Ret As String : Ret = GetPage(Index, Cfg)
      If Ret = Nothing Then Return GetError(-3, "Server DLL Error: Configuration changed, you need to reload grid!") ' Unexepected error
      Return Ret
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Saves changed data to XML file and also to all references of this file in memory
   ' Changes contains XML with changed rows
   ' File is data file to save data to
   Private Function FuncSave(ByVal File As String, ByVal Changes As String) As String
      Dim Indexes(100) As Integer ' Maximally 100 references of grid in memory, it should be enough for now
      Dim Ident As String : Ident = "<Grid><Cfg Ident='" + File + "'/></Grid>" ' Group identification for save, uses custom TreeGrid attribute
      Dim Count As Integer : Count = FindGrids(Indexes, 100, Ident, 0, 0) ' Looks for all instances of the File in memory, the first instance will be saved to file, other will be updated only
      If Count = 0 Then Return GetError(-3, "Server DLL Error: Your temporary data have been deleted already, you cannot save your changes any more, please reload grid!")
      Dim Ret As Integer : Ret = Save(Indexes(0), Changes)
      If Ret < 0 Then Return GetError(Ret, "Server DLL Error: Changes were not saved")
      Dim SRet As Integer : SRet = SaveToFile(Indexes(0), Path + "tmp\\Shared" + File, 24) ' Saves to Tmp directory instead to original file
      If SRet < 0 Then Return GetError(Ret, "Server DLL Error: Cannot save data to disk")
      Dim Idx As Integer : Idx = FindGrid(Changes)
      Dim i As Integer
      For i = 1 To Count - 1
         Dim type As Integer : If i = Idx Then : type = 2 : Else : type = 1 : End If
         SaveEx(Indexes(i), Changes, type) ' Updates all other instances in memory   
      Next
      If Ret > 0 Then Return GetError(0, "Warning: Not all data were successfully saved !")
      Dim Chg As String : Chg = GetChanges(Idx, 1) ' Returns changes done by another user or if generated id collide with ids on server
      If Chg = Nothing Then Chg = ""
      Return "<Grid><IO Result='0'/><Cfg LastId='" + GetLastId(Idx) + "'/>" + Chg + "</Grid>"
   End Function
   
   ' ----------------------------------------------------------------------------------------------------
   ' Returns all updates done by other clients
   ' Cfg contains XML session, here is ignored
   ' File is data file to identify updates
   Private Function FuncCheckUpdates(ByVal File As String, ByVal Cfg As String) As String
      Dim Index As Integer : Index = FindGrid(Cfg)
      If Index < 0 Then Return GetError(0, "") ' The grid was deleted already, this is error
      Dim Chg As String : Chg = GetChanges(Index, 1)
      If Chg <> Nothing Then
         Return "<Grid><IO UpdateMessage='The data on server have been modified by another user, do you want to update your data?'/>" _
            + "<Cfg LastId='" + GetLastId(Index) + "'/>" _
            + Chg + "</Grid>"
      End If
      Return GetError(0, "")
   End Function
   ' ----------------------------------------------------------------------------------------------------
</script>


