<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run TreeFramework.html instead !
  This file is used as both Data_Url and Upload_Url
  Generates data for TreeGrid when no data received or saves received changes to database
  Uses routines in TreeGridFramework.jsp to load and save data
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

// --- Save data to database ---
if(saveTree(request.getParameter("TGData"),Cmd,"TreeData","ID","Parent","#Body")) out.print("<Grid><IO Result='0'/></Grid>");

// --- Load data from database ---
else {
   String[] Names = {"A","C","D","E","G","H","I","id","Parent","Pos","Def"};
   out.print(getTreeXML(Cmd,"TreeData",Names,"#Body","#Head","#Foot",true));
   }
//------------------------------------------------------------------------------------------------------------------
%>
