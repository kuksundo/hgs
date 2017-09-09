<%@page contentType="text/html"%><%@page pageEncoding="UTF-8"%><%
/*-----------------------------------------------------------------------------------------------------------------
Example of TreeGrid using synchronous (submit, non AJAX) communication with server
Example of simple table without tree
Uses HSQLDB database Database (.properties and .script) as data and XML file DBDef.xml as TreeGrid layout
Single file, without using TreeGridFramework.jsp
! Check if JAVA application has write access to ../Database.properties and ../Database.script files
! Don't forget to copy hsqldb.jar file to JAVA shared lib directory
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
String Path = request.getServletPath().replaceAll("[^\\/\\\\]*$",""); // Relative path to script directory ending with "/"
java.sql.Connection Conn = null;
java.sql.Statement Cmd = null;
try {
	Class.forName("org.hsqldb.jdbcDriver").newInstance();
	Conn = java.sql.DriverManager.getConnection("jdbc:hsqldb:file:"+application.getRealPath(Path+"../Database"), "sa", "");
	Cmd = Conn.createStatement();
   } catch (Exception e) {
   out.print("<font color=red>! Failed to load HSQLDB JDBC driver.<br>You need to copy <b>hsqldb.jar</b> file to your shared lib directory and <b>restart</b> your http server.</font>");
   out.close();
   throw new Exception("");
   }

// --- Save data to database ---
try {
   String XML = request.getParameter("TGData"); if(XML==null) XML="";
   if(!XML.equals("")){
      if(XML.charAt(0)=='&'){
         XML = XML.replaceAll("&lt;","<").replaceAll("&gt;",">").replaceAll("&amp;","&").replaceAll("&quot;","\"").replaceAll("&apos;","'");
         }
      org.w3c.dom.Document X = javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new org.xml.sax.InputSource(new java.io.StringReader(XML)));
      org.w3c.dom.NodeList Ch = X.getElementsByTagName("Changes");
      if(Ch.getLength()>0) Ch = Ch.item(0).getChildNodes();
      for(int i=0;i<Ch.getLength();i++){
         org.w3c.dom.Element I = (org.w3c.dom.Element) Ch.item(i);
         String id = I.getAttribute("id"); if(id.equals("")) continue; // Error
         if(I.getAttribute("Deleted").equals("1")){ // Deleting
	         Cmd.executeUpdate("DELETE FROM TableData WHERE ID="+id);  
            }
         else if(I.getAttribute("Added").equals("1")){ // Adding
            Cmd.executeUpdate("INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES("
               + id + ","
               + "'" + I.getAttribute("Project").replaceAll("'","''") + "'," 
               + "'" + I.getAttribute("Resource").replaceAll("'","''") + "'," 
               + I.getAttribute("Week") + "," 
               + I.getAttribute("Hours") + ")");
            }
         else if(I.getAttribute("Changed").equals("1")){ // Updating
				StringBuffer SQL = new StringBuffer();
			 	org.w3c.dom.Node N;
				SQL.append("UPDATE TableData SET ");
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
   }
catch(Exception ex){
   out.print("Error in saving data !<br>");
   out.print(ex.getMessage());
   }



// --- Load data from database ---
StringBuffer S = new StringBuffer();
java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM TableData");
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
R.close();
String Str = S.toString().replaceAll("\\&","&amp;").replaceAll("\\\"","&quot;");
//------------------------------------------------------------------------------------------------------------------
%><html>
   <head>
      <script src="../../../Grid/GridE.js"> </script>
      <link href="../../../Styles/Examples.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <h2>Basic Submit</h2>
      <div style="WIDTH:100%;HEIGHT:90%">
         <bdo 
				Layout_Url="DBDef.xml" 
				Data_Tag="TGData" 
				Upload_Tag="TGData" Upload_Format="Internal"
				Export_Url="../Framework/Export.jsp" Export_Data="TGData" Export_Param_File="Table.xls"
				></bdo>
      </div>
      <form method="post">
         <input name="TGData" type="hidden" value="<%=Str%>">
         <input type="submit" value="Submit changes to server"/>
      </form>
   </body>
</html>
