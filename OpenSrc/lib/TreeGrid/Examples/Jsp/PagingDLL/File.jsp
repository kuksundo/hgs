<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%
// ----------------------------------------------------------------------------------------------------
// Sample web page to generate and update TreeGrid data, using TreeGrid.dll or TreeGrid.so
// TreeGrid.dll must be placed in the ../../../Server/ directory, or the path must be changed in Sample() function
// Shows server paging with all TreeGrid features
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
private String FuncLoadBody(String File, String Def, String Data, String Bonus) {
int Index = GetIndex(File, Def, Data, Bonus);
if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found or server has not permission to read them&#x0A;Data are located at " + Path + File);
String Ret = T.GetBody(Index, Data);
if (Ret == null) return Error(-4, "Server DLL Error: TreeGrid data cannot be loaded");
T.SaveToFile(Index, Path + "tmp\\" + T.GetGridSession(Index) + ".xml", 28);
return Ret;
}
// ----------------------------------------------------------------------------------------------------
// Returns children of one page or one row
// Data contains XML with page index or row id and grid settings - sorting and filters
private String FuncLoadPage(String File, String Def, String Data, String Bonus) {
int Index = GetIndex(File, Def, Data, Bonus);
if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found");
String Ret = T.GetPage(Index, Data);
if (Ret == null) return Error(-3, "Server DLL Error: Configuration changed, you need to reload grid!");
return Ret;   
}
// ----------------------------------------------------------------------------------------------------
// Saves changed data to XML file
// Data contains XML with changed rows
private String FuncSave(String File, String Def, String Data, String Bonus) {
int Index = GetIndex(File, Def, Data, Bonus);
if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found");
int Ret = T.Save(Index, Data);
if (Ret < 0) return Error(Ret, "Server DLL Error: Changes were not saved");
T.SaveToFile(Index, Path + "tmp\\" + T.GetGridSession(Index) + ".xml", 28);
if (Ret > 0) return Error(0, "Warning: Not all data were successfully saved !");
return Error(0, "");
// In this example are data saved only temporary and not to original file
}
// ----------------------------------------------------------------------------------------------------
// Returns the whole grid in XLS/HTML
String FuncExport(String File, String Def, String Data, String Bonus) {
int Index = GetIndex(File, Def, Data, Bonus);
if (Index < 0) return "Server DLL Error: TreeGrid data not found";
String Ret = T.GetExport(Index, Data);
if (Ret == null) return "Server DLL Error: Configuration changed, you need to reload grid!";
response.addHeader("Content-Disposition", "attachment; filename=\"Grid.xls\"");
response.setContentType("application/vnd.ms-excel");
return Ret;
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
   if(F.equalsIgnoreCase("LoadBody")) out.print(S.FuncLoadBody(request.getParameter("File"), request.getParameter("Def"), request.getParameter("Data"), request.getParameter("Bonus"))); 
   else if(F.equalsIgnoreCase("LoadPage")) out.print(S.FuncLoadPage(request.getParameter("File"), request.getParameter("Def"), request.getParameter("Data"), request.getParameter("Bonus"))); 
   else if(F.equalsIgnoreCase("Save")) out.print(S.FuncSave(request.getParameter("File"), request.getParameter("Def"), request.getParameter("Data"), request.getParameter("Bonus"))); 
   else if(F.equalsIgnoreCase("Export")) out.print(S.FuncExport(request.getParameter("File"), request.getParameter("Def"), request.getParameter("Data"), request.getParameter("Bonus"))); 
   else out.print(S.Error(-3, "Wrong function requested"));
   }
catch(Exception ex){
   out.print(S.Error(-3, ex.getMessage()));
   }
%>
