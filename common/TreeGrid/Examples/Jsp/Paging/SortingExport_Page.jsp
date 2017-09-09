<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run SortingExport.html instead !
  This file is used as Page_Url
  Generates data for one TreeGrid page from database, according to sorting information
  This is only simple example with not ideal database access (for every page gets all data)
  Uses TreeGridFramework.jsp
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

// --- Parses sorting settings ---
org.w3c.dom.Document XML = parseXML(request.getParameter("TGData"));
String[] SC = getSortCols(XML);
int[] ST = getSortTypes(XML);
String S = "";
if (SC!=null) {
   for (int i = 0; i < SC.length; i++) {
      if (S.length()>0) S += ", ";
      S += SC[i];
      if (ST[i] >= 1) S += " DESC";
      }
   if (S.length()>0) S = " ORDER BY " + S;
   }

// --- Gets information about page number ---
int pos = getPagePos(XML);
int start = pos*21;      // 21 = PageLength

// --- Reads data from database ---
java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM TableData" + S);

// --- Throws away data in front of requested page ---
for(int i=0;i<start && R.next();i++);

// --- Writes data for requested page ---
out.print("<Grid><Body><B Pos=" + toXML(pos) + ">");
String[] Names = {"id","Project","Resource","Week","Hours"};
for(int i=0;i<21 && R.next();i++) out.print(getRowXML(R,Names));
out.print("</B></Body></Grid>");
//------------------------------------------------------------------------------------------------------------------
%>
