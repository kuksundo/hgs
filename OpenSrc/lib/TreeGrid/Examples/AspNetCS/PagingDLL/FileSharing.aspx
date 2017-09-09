<%@ Import Namespace="System.Runtime.InteropServices" %>
<script language="c#" runat="server">
   /// --------------------------------------------------------------------------------
   /// Sample web page to generate and update TreeGrid data, using TreeGrid.dll
   /// This script can control more grids in more XML files at once
   /// Saves all changes in all instances of one file to this file and does not care about file sharing
   /// For saving it creates one virtual instance in memory and when saving, updates it and saves it to disk
   /// When saving, also updates all instances of specified XML file in memory
   /// It does not use Cache and also does not delete unused instances
   /// For real application you should implement deleting unused instances and may be saving their data to temporary file
   /// TreeGrid.dll must be placed in the ../../../server/ directory, or the path must be changed in Init() function
   /// --------------------------------------------------------------------------------
   void Page_Init(object sender, System.EventArgs e)
   {
      Init();
   }
   // ----------------------------------------------------------------------------------------------------
   void Page_Load(object sender, System.EventArgs e)
   {
      // --- Response initialization ---
      Response.ContentType = "text/xml";
      Response.Charset = "utf-8";
      Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate");
      if (!Loaded) { Response.Write(Error(-5, "TreeGrid.dll not found or cannot be loaded")); return; }
      try
      {
         string F = Request.Params["Function"];
         if (F == "LoadBody") Response.Write(FuncLoadBody(Request.Params["File"], Request.Params["Def"], Request.Params["Cfg"]));
         else if (F == "LoadPage") Response.Write(FuncLoadPage(Request.Params["Cfg"]));
         else if (F == "Save") Response.Write(FuncSave(Request.Params["File"], Request.Params["Changes"]));
         else if (F == "CheckUpdates") Response.Write(FuncCheckUpdates(Request.Params["File"], Request.Params["Cfg"]));
         else Response.Write(Error(-3, "Wrong function requested"));
      }
      catch (Exception ex)
      {
         Response.Write(Error(-3, ex.Message));
      }
   }
   // ----------------------------------------------------------------------------------------------------


   // ----------------------------------------------------------------------------------------------------
   // Inicialization and TreeGrid.dll loading
   void Init()
   {
      Path = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath) + "\\";
      Loaded = LoadLibrary(Path + "..\\..\\..\\Server\\" + (IntPtr.Size == 4 ? "" : "DLL64\\") + "TreeGrid.dll") != IntPtr.Zero;
   }
   // ----------------------------------------------------------------------------------------------------
   string Path; // Path to data directory
   bool Loaded; // If DLL successfuly loaded
   // ----------------------------------------------------------------------------------------------------
   // TreeGrid.dll import
   [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
   static extern IntPtr LoadLibrary(string lpFileName);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int CreateGrid(string Data, string Layout, string Defaults, string Text, string Bonus, string Bonus2);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int UpdateGrid(int Index, string Bonus);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int FindGrid(string Cfg);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int FindGrids(IntPtr Indexes, int Max, string Cfg, int Seconds, int Type);
   public static int FindGrids(ref int[] Indexes, int Max, string Cfg, int Seconds, int Type)
   {
      return FindGrids(GCHandle.Alloc(Indexes, GCHandleType.Pinned).AddrOfPinnedObject(), Max, Cfg, Seconds, Type);
   }
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern string GetSession(string Cfg);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern string GetGridSession(int Index);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int DeleteGrid(int Index);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern void Clear();
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern string GetBody(int Index, string Cfg);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern string GetPage(int Index, string Cfg);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern string GetExport(int Index, string Cfg);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int Save(int Index, string Input);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int SaveEx(int Index, string Input, int Type);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int SaveToFile(int Index, string FileName, int Type);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern string GetData(int Index);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern string GetLastId(int Index);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern string GetChanges(int Index, int Type);
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern void EnterWrite();
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern void LeaveWrite();
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern void EnterRead();
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern void LeaveRead();
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int SetLocale(int Index, string Locale);

   // --- Debug version only ---   
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern string LastError();
   [DllImport("TreeGrid.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
   public static extern int SetDebug(int Debug, string File);

   // ----------------------------------------------------------------------------------------------------
   // Returns Xml with given error message
   private string Error(int num, string mess)
   {
      string Err = num != 0 && Loaded ? LastError() : null;
      if (Err != null) mess = mess + "&#x0A;&#x0A;" + Err.Replace("&", "&amp;").Replace("<", "&lt;").Replace("\"", "&quot;");
      return "<Grid><IO Result='" + num + "' Message=\"" + mess + "\"/></Grid>";
   }
   // ----------------------------------------------------------------------------------------------------
   // Returns grid data, for Paging==3 returns only empty pages with information about their content
   // Cfg contains XML with grid settings - sorting and filters
   private string FuncLoadBody(string File, string Def, string Cfg)
   {
      EnterWrite(); // Enter critical section, because searching grid and creating new instance should not be interrupted by other request
      int Index = FindGrid(Cfg); // Searches for grid according to Session attribute - if this grid exists already
      if (Index < 0)
      { // No instance of the grid exists
         string Ident = "<Grid><Cfg Ident='" + File + "'/></Grid>"; // Group identification for save, uses custom TreeGrid attribute
         int[] Tmp = null;
         int IdentCount = FindGrids(ref Tmp, 1, Ident, 0, 0);
         string CfgPaging = "<Grid><Cfg Paging='3' ChildPaging='3'/></Grid>";
         string F = Path + "tmp\\Shared" + File;
         if (!System.IO.File.Exists(F)) F = Path + File;
         if (IdentCount == 0)
         { // The first instance for saving of the grid does not exist, it will be created
            CreateGrid(F, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", CfgPaging, Ident);
         }
         Index = CreateGrid(F, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", CfgPaging, Ident);
      }
      LeaveWrite();
      if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found or server has not permission to read them");
      string Ret = GetBody(Index, Cfg);
      if (Ret == null) return Error(-4, "Server DLL Error: TreeGrid data cannot be loaded");
      return Ret;
   }
   // ----------------------------------------------------------------------------------------------------
   // Returns children of one page or one row
   // Cfg contains XML with page index or row id and grid settings - sorting and filters
   private string FuncLoadPage(string Cfg)
   {
      int Index = FindGrid(Cfg);
      if (Index < 0) return Error(-3, "Server DLL Error: Your temporary data have been deleted already, please reload grid!");
      string Ret = GetPage(Index, Cfg);
      if (Ret == null) return Error(-3, "Server DLL Error: Configuration changed, you need to reload grid!"); // Unexepected error
      return Ret;
   }
   // ----------------------------------------------------------------------------------------------------
   // Saves changed data to XML file and also to all references of this file in memory
   // Changes contains XML with changed rows
   // File is data file to save data to
   private string FuncSave(string File, string Changes)
   {
      int[] Indexes = new int[100]; // Maximally 100 references of grid in memory, it should be enough for now
      string Ident = "<Grid><Cfg Ident='" + File + "'/></Grid>"; // Group identification for save, uses custom TreeGrid attribute
      int Count = FindGrids(ref Indexes, 100, Ident, 0, 0); // Looks for all instances of the File in memory, the first instance will be saved to file, other will be updated only
      if (Count == 0) return Error(-3, "Server DLL Error: Your temporary data have been deleted already, you cannot save your changes any more, please reload grid!");
      int Ret = Save(Indexes[0], Changes);
      if (Ret < 0) return Error(Ret, "Server DLL Error: Changes were not saved");
      int SRet = SaveToFile(Indexes[0], Path + "tmp\\Shared" + File, 24); // Saves to Tmp directory instead to original file
      if (SRet < 0) return Error(Ret, "Server DLL Error: Cannot save data to disk");
      int Idx = FindGrid(Changes);
      for (int i = 1; i < Count; i++) SaveEx(Indexes[i], Changes, i == Idx ? 2 : 1); // Updates all other instances in memory
      if (Ret > 0) return Error(0, "Warning: Not all data were successfully saved !");
      string Chg = GetChanges(Idx, 1); // Returns changes done by another user or if generated id collide with ids on server
      if (Chg == null) Chg = "";
      return "<Grid><IO Result='0'/><Cfg LastId='" + GetLastId(Idx) + "'/>" + Chg + "</Grid>";
   }
   // ----------------------------------------------------------------------------------------------------
   // Returns all updates done by other clients
   // Cfg contains XML session, here is ignored
   // File is data file to identify updates
   private string FuncCheckUpdates(string File, string Cfg)
   {
      int Index = FindGrid(Cfg);
      if (Index < 0) return Error(0, ""); // The grid was deleted already, this is error
      string Chg = GetChanges(Index, 1);
      if (Chg != null)
      {
         return "<Grid><IO UpdateMessage='The data on server have been modified by another user, do you want to update your data?'/>"
            + "<Cfg LastId='" + GetLastId(Index) + "'/>"
            + Chg + "</Grid>";
      }
      return Error(0, "");
   }
   // ----------------------------------------------------------------------------------------------------
</script>


