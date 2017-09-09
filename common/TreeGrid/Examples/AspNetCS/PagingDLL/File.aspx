<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Runtime.InteropServices" %>
<script runat="server" language="c#">
   // --------------------------------------------------------------------------------
   void Page_Init(object sender, System.EventArgs e)
   {
      Init();
   }
   // ----------------------------------------------------------------------------------------------------
   void Page_Load(object sender, System.EventArgs e)
   {
      try
      {
         // --- Response initialization ---
         Response.ContentType = "text/xml";
         Response.Charset = "utf-8";
         Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate");
         if (!Loaded) { Response.Write(Error(-5, "TreeGrid.dll not found or cannot be loaded")); return; }

         // --- Function switch ---
         string F = Request.Params["Function"];
         if (F == "LoadBody") Response.Write(FuncLoadBody(Request.Params["File"], Request.Params["Def"], Request.Params["Data"], Request.Params["Bonus"]));
         else if (F == "LoadPage") Response.Write(FuncLoadPage(Request.Params["File"], Request.Params["Def"], Request.Params["Data"], Request.Params["Bonus"]));
         else if (F == "Save") Response.Write(FuncSave(Request.Params["File"], Request.Params["Def"], Request.Params["Data"], Request.Params["Bonus"]));
         else if (F == "Export") Response.Write(FuncExport(Request.Params["File"], Request.Params["Def"], Request.Params["Data"], Request.Params["Bonus"]));
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
   // Returns Grids index for given file or <0 for error
   private int GetIndex(string File, string Def, string Cfg, string Bonus)
   {
      if (File == "") return -1;
      int Index = FindGrid(Cfg);
      if (Index >= 0) return Index;
      string file = Path + "tmp\\" + GetSession(Cfg) + ".xml";
      if (!System.IO.File.Exists(file)) file = Path + File;
      return CreateGrid(file, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", Bonus, null);
   }
   // ----------------------------------------------------------------------------------------------------
   // Returns grid data, for Paging==3 returns only empty pages with information about their content
   // Data contains XML with grid settings - sorting and filters
   private string FuncLoadBody(string File, string Def, string Data, string Bonus)
   {
      int Index = GetIndex(File, Def, Data, Bonus);
      if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found or server has not permission to read them&#x0A;Data are located at " + Path + File);
      string Ret = GetBody(Index, Data);
      if (Ret == null) return Error(-4, "Server DLL Error: TreeGrid data cannot be loaded");
      SaveToFile(Index, Path + "tmp\\" + GetGridSession(Index) + ".xml", 28);
      return Ret;
   }
   // ----------------------------------------------------------------------------------------------------
   // Returns children of one page or one row
   // Data contains XML with page index or row id and grid settings - sorting and filters
   private string FuncLoadPage(string File, string Def, string Data, string Bonus)
   {
      int Index = GetIndex(File, Def, Data, Bonus);
      if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found");
      string Ret = GetPage(Index, Data);
      if (Ret == null) return Error(-3, "Server DLL Error: Configuration changed, you need to reload grid!");
      return Ret;
   }
   // ----------------------------------------------------------------------------------------------------
   // Saves changed data to XML file
   // Data contains XML with changed rows
   private string FuncSave(string File, string Def, string Data, string Bonus)
   {
      int Index = GetIndex(File, Def, Data, Bonus);
      if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found");
      int Ret = Save(Index, Data);
      if (Ret < 0) return Error(Ret, "Server DLL Error: Changes were not saved");
      SaveToFile(Index, Path + "tmp\\" + GetGridSession(Index) + ".xml", 28);
      if (Ret > 0) return Error(0, "Warning: Not all data were successfully saved !");
      return Error(0, "");
      // In this example are data saved only temporary and not to original file
   }
   // ----------------------------------------------------------------------------------------------------
   // Returns the whole grid in XLS/HTML
   private string FuncExport(string File, string Def, string Data, string Bonus)
   {
      int Index = GetIndex(File, Def, Data, Bonus);
      if (Index < 0) return "Server DLL Error: TreeGrid data not found";
      string Ret = GetExport(Index, Data);
      if (Ret == null) return "Server DLL Error: Configuration changed, you need to reload grid!";
      Response.AppendHeader("Content-Disposition", "attachment; filename=\"Grid.xls\"");
      Response.ContentType = "application/vnd.ms-excel";
      return Ret;
   }
   // ----------------------------------------------------------------------------------------------------
</script>


