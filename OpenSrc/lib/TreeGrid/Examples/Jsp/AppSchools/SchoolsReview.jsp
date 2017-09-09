<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Schools.html instead !
  This file is used as target of custom AJAX call in Schools.html
  Saves Review to database
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

String idx = getParameter(request,"id");
if (idx.length()>0) {
   
   // --- Reads input parameters ---
   String[] id = idx.split("\\$"); // User$Def$Ident
   String Text = request.getParameter("Text");
   String Stars = request.getParameter("Stars");

   // --- Saves Review to database ---
   Cmd.executeUpdate("INSERT INTO Schools_Ratings(Owner,Id,Stars,Review,ADate) VALUES (" + toSQL(id[0]) + "," + id[2] + "," +Stars + "," + toSQL(Text) + ",'" + (new java.sql.Date((new java.util.Date()).getTime())).toString() + "')");
   Cmd.executeUpdate("UPDATE Schools_Schools SET RatingSum=RatingSum+"+Stars+", RatingCnt=RatingCnt+1 WHERE Owner=" + toSQL(id[0]) + " AND Id=" + id[2]);
	}
out.print ("<Grid><IO Result='0' Message='Your review was successfully added'/></Grid>");

// --------------------------------------------------------------------------
%>
