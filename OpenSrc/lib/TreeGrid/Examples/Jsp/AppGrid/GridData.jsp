<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Grid.html instead !
  This file is used as Data_Url for TreeGrid
  It generates source data for TreeGrid from database
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

// --- Generating data ---
java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM TableData WHERE Week>0 AND Week<53 ORDER BY Project,Resource");
String Prj = null, Res = null, S = "";
while(R.next()) {
   String p = R.getString(2);  // Project
   String r = R.getString(3);  // Resource
   
   if (!p.equals(Prj)) {                // New project row
      if(Prj!=null) S += "/></I>";      // Ends previous project and resource rows
      Prj = p; Res = null;
      S += "<I Def='Node' Project=" + toXML(Prj) + ">";
      }
   
   if(!r.equals(Res)) {                 // New resource row
      if (Res!=null) S += "/>";         // Ends previous resource row
      Res = r;
      S += "<I Project=" + toXML(Res) + " ";
   }
   
   S = S + "W" + String.valueOf(R.getInt(4)) + "='" + R.getString(5) + "' "; // Week = Hours (like W42='17')
   }

if(Prj!=null) S += "/></I>";                         // Ends previous project and resource rows

// --------------------------------------------------------------------------
%><?xml version="1.0" ?>
<Grid>
   <Body>
      <B>
         <%=S%>
      </B>
   </Body>
</Grid>