<%@page contentType="text/html"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
Example of TreeGrid using synchronous (submit, non AJAX) communication with server
Example of tree table
Uses HSQLDB database Database (.properties and .script) as data and XML file TreeDef.xml as TreeGrid layout
Uses routines in TreeGridFramework.jsp to load and save data
! Check if JAVA application has write access to ../Database.properties and ../Database.script files
! Don't forget to copy hsqldb.jar file to JAVA shared lib directory
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","",true);

// --- Save data to database ---
saveTree(request.getParameter("TGOutput"),Cmd,"TreeData","ID","Parent","#Body");

// --- Load data from database ---
String[] Names = {"A","C","D","E","G","H","I","id","Parent","Pos","Def"};
String Str = toHTMLString(getTreeXML(Cmd,"TreeData",Names,"#Body","#Head","#Foot",true));
//------------------------------------------------------------------------------------------------------------------
%><html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <script src="../../../Grid/GridE.js"> </script>
      <link href="../../../Styles/Examples.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <h2>Tree in database</h2>
      <div style="WIDTH:100%;HEIGHT:90%">
         <bdo 
				Layout_Url="TreeDef.xml" 
				Data_Tag="TGInput" 
				Upload_Tag="TGOutput" Upload_Format="Internal"
				Export_Url="../Framework/Export.jsp" Export_Data="TGData" Export_Param_File="Tree.xls"
				></bdo>
      </div>
      <form acceptcharset="UTF-8" method="post">
         <input name="TGInput" type="hidden" value="<%=Str%>">
         <input name="TGOutput" type="hidden">
         <input type="submit" value="Submit changes to server"/>
      </form>
   </body>
</html>
