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
T = new TreeGrid.Server(Path+"../../../Server/"+(System.getProperty("sun.arch.data.model").equals("64")?"DLL64/":"")+"TreeGrid");
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

// ----------------------------------------------------------------------------------------------------
// Returns prepared SQL statament
private java.sql.Statement InitDB() throws Exception {
java.sql.Connection Conn = null;
java.sql.Statement Cmd = null;
try {
   Class.forName("org.hsqldb.jdbcDriver").newInstance();
   Conn = java.sql.DriverManager.getConnection("jdbc:hsqldb:file:"+Path+"../Database", "sa", "");
   Cmd = Conn.createStatement();
   } catch (Exception e) {
   throw new Exception("! Failed to load HSQLDB JDBC driver.\nYou need to copy \"hsqldb.jar\" file to your shared lib directory and RESTART your http server.");
   }
return Cmd;
}

// ----------------------------------------------------------------------------------------------------
// Returns Grids index for given file or <0 for error
private int GetIndex(String Table, String Def, String Cfg, String Bonus){
if(Table==null || Table.equals("")) return -1;
int Index = T.FindGrid(Cfg);
if (Index >= 0) return Index;
String file = Path + "tmp\\" + T.GetSession(Cfg) + ".xml";
java.io.File F = new java.io.File(file);
if(F.exists()) return T.CreateGrid(file, Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", Bonus, null);

// --- Load data from database ---
StringBuffer S = new StringBuffer();
try{
    java.sql.Statement Cmd = InitDB();
    java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM "+Table);
    S.append("<Grid><Body><B>");
    while(R.next()){
        S.append("<I id='" + R.getString(1) + "'"
             + " Project='" + R.getString(2).replaceAll("&", "&amp;").replaceAll("'", "&apos;").replaceAll("<", "&lt;") + "'"
             + " Resource='" + R.getString(3).replaceAll("&", "&amp;").replaceAll("'", "&apos;").replaceAll("<", "&lt;") + "'"
            + " Week='" + R.getString(4) + "'"
            + " Hours='" + R.getString(5) + "'"
            + "/>");
        }
    S.append("</B></Body></Grid>");
    }
catch(Exception ex){ return -1; }

// --- Creates grid from data ---
return T.CreateGrid(S.toString(), Path + Def, Path + "..\\..\\..\\Grid\\Defaults.xml", Path + "..\\..\\..\\Grid\\Text.xml", Bonus, null);
}
// ----------------------------------------------------------------------------------------------------
// Returns grid data, for Paging==3 returns only empty pages with information about their content
// Data contains XML with grid settings - sorting and filters
private String FuncLoadBody(String Table, String Def, String Data, String Bonus) {
int Index = GetIndex(Table, Def, Data, Bonus);
if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found or server has not permission to read them");
String Ret = T.GetBody(Index, Data);
if (Ret == null) return Error(-4, "Server DLL Error: TreeGrid data cannot be loaded");
T.SaveToFile(Index, Path + "tmp\\" + T.GetGridSession(Index) + ".xml", 28);
return Ret;
}
// ----------------------------------------------------------------------------------------------------
// Returns children of one page or one row
// Data contains XML with page index or row id and grid settings - sorting and filters
private String FuncLoadPage(String Table, String Def, String Data, String Bonus) {
int Index = GetIndex(Table, Def, Data, Bonus);
if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found");
String Ret = T.GetPage(Index, Data);
if (Ret == null) return Error(-3, "Server DLL Error: Configuration changed, you need to reload grid!");
return Ret;   
}
// ----------------------------------------------------------------------------------------------------
// Saves changed data to XML file
// Data contains XML with changed rows
private String FuncSave(String Table, String Def, String Data, String Bonus) {
int Index = GetIndex(Table, Def, Data, Bonus);
if (Index < 0) return Error(-1, "Server DLL Error: TreeGrid data not found");
int Ret = T.Save(Index, Data);
if (Ret < 0) return Error(Ret, "Server DLL Error: Changes were not saved");
T.SaveToFile(Index, Path + "tmp\\" + T.GetGridSession(Index) + ".xml", 28);

// --- Save changes to database ---
try {
    if(Data.charAt(0)=='&'){
        Data = Data.replaceAll("&lt;","<").replaceAll("&gt;",">").replaceAll("&amp;","&").replaceAll("&quot;","\"").replaceAll("&apos;","'");
        }
    org.w3c.dom.Document X = javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new org.xml.sax.InputSource(new java.io.StringReader(Data)));
    org.w3c.dom.NodeList Ch = X.getElementsByTagName("Changes");
    if(Ch.getLength()>0) Ch = Ch.item(0).getChildNodes();
    java.sql.Statement Cmd = InitDB();
    for(int i=0;i<Ch.getLength();i++){
        org.w3c.dom.Element I = (org.w3c.dom.Element) Ch.item(i);
        String id = I.getAttribute("id"); if(id.equals("")) continue; // Error
        if(I.getAttribute("Deleted").equals("1")){ // Deleting
	         Cmd.executeUpdate("DELETE FROM " + Table + " WHERE ID="+id);  
            }
        else if(I.getAttribute("Added").equals("1")){ // Adding
            Cmd.executeUpdate("INSERT INTO " + Table + "(ID,Project,Resource,Week,Hours) VALUES("
               + id + ","
               + "'" + I.getAttribute("Project").replaceAll("'","''") + "'," 
               + "'" + I.getAttribute("Resource").replaceAll("'","''") + "'," 
               + I.getAttribute("Week") + "," 
               + I.getAttribute("Hours") + ")");
            }
        else if(I.getAttribute("Changed").equals("1")){ // Updating
            StringBuffer SQL = new StringBuffer();
			 	org.w3c.dom.Node N;
				SQL.append("UPDATE " + Table + " SET ");
				N = I.getAttributeNode("Project"); if(N!=null) SQL.append("Project='"+N.getNodeValue().replaceAll("'","''")+"',");
				N = I.getAttributeNode("Resource"); if(N!=null) SQL.append("Resource='"+N.getNodeValue().replaceAll("'","''")+"',");
				N = I.getAttributeNode("Week"); if(N!=null) SQL.append("Week="+N.getNodeValue()+",");
				N = I.getAttributeNode("Hours"); if(N!=null) SQL.append("Hours="+N.getNodeValue()+",");
            SQL.setLength(SQL.length()-1);  // Last comma away
            SQL.append(" WHERE ID="+id);
	         Cmd.executeUpdate(SQL.toString());
            }
        }
    }
catch(Exception ex){
    return Error(-1, "Server DLL Error: Changes were not saved to database");
    }

if (Ret > 0) return Error(0, "Warning: Not all data were successfully saved !");
return Error(0, "");
}
// ----------------------------------------------------------------------------------------------------
// Returns the whole grid in XLS/HTML
String FuncExport(String Table, String Def, String Data, String Bonus) {
int Index = GetIndex(Table, Def, Data, Bonus);
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
   if(F.equalsIgnoreCase("LoadBody")) out.print(S.FuncLoadBody(request.getParameter("Table"), request.getParameter("Def"), request.getParameter("Data"), request.getParameter("Bonus"))); 
   else if(F.equalsIgnoreCase("LoadPage")) out.print(S.FuncLoadPage(request.getParameter("Table"), request.getParameter("Def"), request.getParameter("Data"), request.getParameter("Bonus"))); 
   else if(F.equalsIgnoreCase("Save")) out.print(S.FuncSave(request.getParameter("Table"), request.getParameter("Def"), request.getParameter("Data"), request.getParameter("Bonus"))); 
   else if(F.equalsIgnoreCase("Export")) out.print(S.FuncExport(request.getParameter("Table"), request.getParameter("Def"), request.getParameter("Data"), request.getParameter("Bonus"))); 
   else out.print(S.Error(-3, "Wrong function requested"));
   }
catch(Exception ex){
   out.print(S.Error(-3, ex.getMessage()));
   }
%>
