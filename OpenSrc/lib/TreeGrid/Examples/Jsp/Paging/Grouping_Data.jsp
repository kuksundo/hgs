<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Grouping.html instead !
  This file is used as Data_Url
  Generates data for TreeGrid body
  This is simple example, always reads and groups all rows to get their count
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

// --- Parses XML request ---
String XML = request.getParameter("TGData"); // was set <bdo ... Data_Data="TGData" ...>
if (XML==null) XML = "<Grid><Cfg GroupCols='Resource'/></Grid>"; // Just for examples if called directly
org.w3c.dom.Document X = parseXML(XML);

// --- Parses grouping settings ---
String[] GroupCols = getGroupCols(X);

// --- Generating data for body ---
java.sql.ResultSet R;
if(GroupCols==null) R = Cmd.executeQuery("SELECT COUNT(*) FROM TableData");
else R =Cmd.executeQuery("SELECT COUNT(*) FROM (SELECT COUNT(*) FROM TableData GROUP BY " + GroupCols[0] + ")");
R.next();
int cnt = R.getInt(1); 
out.print("<Grid><Cfg RootCount=" + toXML(cnt) + "/><Body>");
cnt = (cnt + 20) / 21;
for (int i = 0; i < cnt; i++) out.print("<B/>");
out.print("</Body></Grid>");
//------------------------------------------------------------------------------------------------------------------
%>