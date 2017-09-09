<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Basic.html instead !
  This file is used as both Data_Url and Upload_Url
  Generates data for TreeGrid when no data received or saves received changes to database
  Single file, without using TreeGridFramework.jsp
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
   out.print("<Grid><IO Result='-1' Message='! Failed to load HSQLDB JDBC driver.\nYou need to copy \"hsqldb.jar\" file to your shared lib directory and RESTART your http server.'/></Grid>");
   out.close();
   throw new Exception("");
   }

// --- Save data to database ---
String XML = request.getParameter("TGData"); if(XML==null) XML="";
if(!XML.equals("")){
   try {
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
      out.print("<Grid><IO Result='0'/></Grid>");
      }
   catch(Exception ex){
      out.print("Error in saving data !<br>");
      out.print(ex.getMessage());
      }
   }  


// --- Load data from database ---
else {
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
   out.print(S.toString());
   R.close();
   }
//------------------------------------------------------------------------------------------------------------------
%>
