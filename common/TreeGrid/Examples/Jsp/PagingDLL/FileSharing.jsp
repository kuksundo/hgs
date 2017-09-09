<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%
// ----------------------------------------------------------------------------------------------------
// Sample web page to generate and update TreeGrid data, using TreeGrid.dll or TreeGrid.so
// TreeGrid.dll must be placed in the ../../../Server/ directory, or the path must be changed in Sample() function
// Shows sharing and synchronization with server
// ! Don't forget to copy TreeGrid.jar file to JAVA shared lib directory
// ----------------------------------------------------------------------------------------------------
class Sample {
TreeGrid.Server T;
String Path;
HttpServletRequest request;
HttpServletResponse response;

// ----------------------------------------------------------------------------------------------------
Sample(String path, HttpServletRequest req, HttpServletResponse res) {
Path = path; request = req; response = res;
T = new TreeGrid.Server(Path+"../../../Server/TreeGrid");
}

// ----------------------------------------------------------------------------------------------------
// Returns Xml with given error message
private String Error(int num, String mess){
if(T.Loaded){
   String Err = num!=0 ? T.LastError() : null;
   if(Err!=null) mess = mess+"&#x0A;&#x0A;"+Err.replaceAll("\\&","&amp;").replaceAll("\\<","&lt;").replaceAll("\\\"","&quot;");
   }
return "<Grid><IO Result=\""+num+"\" Message=\""+mess+"\"/></Grid>";
}
// ----------------------------------------------------------------------------------------------------
// Returns Grids index for given file or <0 for error
private int GetIndex(String File, String Def, String Cfg, String Bonus){
if(File==null || File.equals("")) return -1;
int Index = T.FindGrid(Cfg);
if (Index >= 0) return Index;
String file = Path + "tmp\\" + T.GetSession(Cfg) + ".xml";
java.io.File F = new java.io.File(file);
if(!F.exists()) file = Path + File;
return T.CreateGrid(file, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", Bonus, null);
}
// ----------------------------------------------------------------------------------------------------
// Returns grid data, for Paging==3 returns only empty pages with information about their content
// Data contains XML with grid settings - sorting and filters
private String FuncLoadBody(String File, String Def, String Cfg) {
T.EnterWrite(); // Enter critical section, because searching grid and creating new instance should not be interrupted by other request
int Index = T.FindGrid(Cfg); // Searches for grid according to Session attribute - if this grid exists already
if (Index < 0) { // No instance of the grid exists
    String Ident = "<Grid><Cfg Ident='" + File + "'/></Grid>"; // Group identification for save, uses custom TreeGrid attribute
    int[] Tmp = null;
    int IdentCount = T.FindGrids(Tmp, 1, Ident, 0, 0);
    String CfgPaging = "<Grid><Cfg Paging='3' ChildPaging='3'/></Grid>";
    String F = Path + "tmp\\Shared" + File;
    java.io.File FF = new java.io.File(F);
    if(!FF.exists()) F = Path + File;
    if (IdentCount == 0) { // The first instance for saving of the grid does not exist, it will be created
        T.CreateGrid(F, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", CfgPaging, Ident);
        }
    Index = T.CreateGrid(F, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", CfgPaging, Ident);
    }
T.LeaveWrite();
if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found or server has not permission to read them");
String Ret = T.GetBody(Index, Cfg);
if (Ret == null) return Error(-4, "Server DLL Error: TreeGrid data cannot be loaded");
return Ret;
}
// ----------------------------------------------------------------------------------------------------
// Returns children of one page or one row
// Data contains XML with page index or row id and grid settings - sorting and filters
private String FuncLoadPage(String Cfg) {
int Index = T.FindGrid(Cfg);
if (Index < 0) return Error(-3, "Server DLL Error: Your temporary data have been deleted already, please reload grid!");
String Ret = T.GetPage(Index, Cfg);
if (Ret == null) return Error(-3, "Server DLL Error: Configuration changed, you need to reload grid!"); // Unexepected error
return Ret;
}
// ----------------------------------------------------------------------------------------------------
// Saves changed data to XML file
// Data contains XML with changed rows
private String FuncSave(String File, String Changes) {
int[] Indexes = new int[100]; // Maximally 100 references of grid in memory, it should be enough for now
String Ident = "<Grid><Cfg Ident='" + File + "'/></Grid>"; // Group identification for save, uses custom TreeGrid attribute
int Count = T.FindGrids(Indexes, 100, Ident, 0, 0); // Looks for all instances of the File in memory, the first instance will be saved to file, other will be updated only
if (Count == 0) return Error(-3, "Server DLL Error: Your temporary data have been deleted already, you cannot save your changes any more, please reload grid!");
int Ret = T.Save(Indexes[0], Changes);
if (Ret < 0) return Error(Ret, "Server DLL Error: Changes were not saved");
int SRet = T.SaveToFile(Indexes[0], Path + "tmp\\Shared" + File, 24); // Saves to Tmp directory instead to original file
if (SRet < 0) return Error(Ret, "Server DLL Error: Cannot save data to disk");
int Idx = T.FindGrid(Changes);
for (int i = 1; i < Count; i++) T.SaveEx(Indexes[i], Changes, i == Idx ? 2 : 1); // Updates all other instances in memory
if (Ret > 0) return Error(0, "Warning: Not all data were successfully saved !");
String Chg = T.GetChanges(Idx, 1); // Returns changes done by another user or if generated id collide with ids on server
if (Chg == null) Chg = "";
return "<Grid><IO Result='0'/><Cfg LastId='" + T.GetLastId(Idx) + "'/>" + Chg + "</Grid>";
}
// ----------------------------------------------------------------------------------------------------
// Returns all updates done by other clients
// Cfg contains XML session, here is ignored
// File is data file to identify updates
String FuncCheckUpdates(String File, String Cfg) {
int Index = T.FindGrid(Cfg);
if (Index < 0) return Error(0, ""); // The grid was deleted already, this is error
String Chg = T.GetChanges(Index, 1);
if (Chg != null) {
    return "<Grid><IO UpdateMessage='The data on server have been modified by another user, do you want to update your data?'/>"
            + "<Cfg LastId='" + T.GetLastId(Index) + "'/>"
            + Chg + "</Grid>";
    }
return Error(0, "");
}
// ----------------------------------------------------------------------------------------------------
}; // end of class Sample
// ----------------------------------------------------------------------------------------------------
//Sample S = new Sample(application.getRealPath(request.getServletPath().replaceAll("[^\\/\\\\]*[\\/][^\\/\\\\]*$","")+"ServerDLL")+"/",request,response);
String Path = request.getServletPath().replaceAll("[^\\/\\\\]*$",""); // Relative path to script directory ending with "/"
Sample S = new Sample(application.getRealPath(Path)+"/",request,response);
response.addHeader("Cache-Control","max-age=1, must-revalidate");
if(!TreeGrid.Server.Loaded) out.print(S.Error(-5, TreeGrid.Server.DllError));
else try {
   String F = request.getParameter("Function"); if(F==null) F="";
   if(F.equalsIgnoreCase("LoadBody")) out.print(S.FuncLoadBody(request.getParameter("File"), request.getParameter("Def"), request.getParameter("Cfg"))); 
   else if(F.equalsIgnoreCase("LoadPage")) out.print(S.FuncLoadPage(request.getParameter("Cfg"))); 
   else if(F.equalsIgnoreCase("Save")) out.print(S.FuncSave(request.getParameter("File"),request.getParameter("Changes"))); 
   else if(F.equalsIgnoreCase("CheckUpdates")) out.print(S.FuncCheckUpdates(request.getParameter("File"), request.getParameter("Cfg"))); 
   else out.print(S.Error(-3, "Wrong function requested"));
   }
catch(Exception ex){
   out.print(S.Error(-3, ex.getMessage()));
   }
%>
