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



StringBuffer S = new StringBuffer();
java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM GanttTree");
S.append("<Grid><Body><B>");
while(R.next()){
   S.append("<I id='" + R.getString(6) + "'"
         + " T='" + R.getString(1).replaceAll("&", "&amp;").replaceAll("'", "&apos;").replaceAll("<", "&lt;") + "'"
         + " S='" + R.getString(2) + "'"
         + " E='" + R.getString(3) + "'"
         + " C='" + R.getString(4) + "'"
         + " D='" + R.getString(5) + "'"
         + " L='" + R.getString(7) + "'"
         + "/>");
   }
S.append("</B></Body></Grid>");
out.print(S.toString());
R.close();

//------------------------------------------------------------------------------------------------------------------
%>
