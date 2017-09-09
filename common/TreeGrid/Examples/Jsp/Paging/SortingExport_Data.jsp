<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run SortingExport.html instead !
  This file is used as Data_Url
  Generates data for TreeGrid
  This is simple example, it simply reloads all body when rows are added or deleted instead of handling changes in pages
  Uses TreeGridFramework.jsp
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");


// --- Load data from database ---
java.sql.ResultSet R = Cmd.executeQuery("SELECT COUNT(*),MAX(ID) FROM TableData");
R.next();
int cnt = R.getInt(1);
   
out.print("<Grid><Cfg LastId='" + R.getString(2) + "' RootCount=" + toXML(cnt) + "/><Body>");
cnt = (cnt + 20) / 21;
for (int i = 0; i < cnt; i++) out.print("<B/>");
out.print("</Body></Grid>");
//------------------------------------------------------------------------------------------------------------------
%>
