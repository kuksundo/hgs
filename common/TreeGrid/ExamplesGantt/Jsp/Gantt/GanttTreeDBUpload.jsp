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
String XML = request.getParameter("Data"); if(XML==null) XML="";
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
         String SQL = "";
         if(I.getAttribute("Deleted").equals("1") || I.getAttribute("ToDelete").equals("1")){ // Deleting
            SQL = "DELETE FROM GanttTree WHERE ID="+id;
            }
         else if(I.getAttribute("Added").equals("1")){ // Adding
            SQL = "INSERT INTO GanttTree(ID,T,S,E,C,D,L) VALUES("
                + "'" + id + "',"
                + "'" + I.getAttribute("T").replaceAll("'","''") + "'," 
                + "'" + I.getAttribute("S") + "'," 
                + "'" + I.getAttribute("E") + "'," 
                + "'" + I.getAttribute("C") + "'," 
                + "'" + I.getAttribute("D") + "'," 
                + "'" + I.getAttribute("L") + "')";
            }
         else if(I.getAttribute("Changed").equals("1")){ // Updating
				StringBuffer SQLB = new StringBuffer();
			 	org.w3c.dom.Node N;
				SQLB.append("UPDATE GanttTree SET ");
				N = I.getAttributeNode("T"); if(N!=null) SQLB.append("T='"+N.getNodeValue().replaceAll("'","''")+"',");
				N = I.getAttributeNode("S"); if(N!=null) SQLB.append("S='"+N.getNodeValue()+"',");
            N = I.getAttributeNode("E"); if(N!=null) SQLB.append("E='"+N.getNodeValue()+"',");
            N = I.getAttributeNode("C"); if(N!=null) SQLB.append("C="+N.getNodeValue()+",");
            N = I.getAttributeNode("D"); if(N!=null) SQLB.append("D='"+N.getNodeValue()+"',");
            N = I.getAttributeNode("L"); if(N!=null) SQLB.append("L='"+N.getNodeValue()+"',");
            SQLB.setLength(SQLB.length()-1);  // Last comma away
            SQLB.append(" WHERE ID="+id);
            SQL = SQLB.toString();
            }
         out.print(SQL+"\r\n"); // Just to see the SQL in debug, but it breaks down the XML, so in real application must be removed
         Cmd.executeUpdate(SQL);
         }
      out.print("<Grid><IO Result='0'/></Grid>");
      }
   catch(Exception ex){
      out.print("Error in saving data !<br>");
      out.print(ex.getMessage());
      }
   }  

//------------------------------------------------------------------------------------------------------------------
%>
