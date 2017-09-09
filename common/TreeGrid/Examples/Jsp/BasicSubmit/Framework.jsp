<%@page contentType="text/html"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
Example of TreeGrid using synchronous (submit, non AJAX) communication with server
Example of simple table without tree
Uses HSQLDB database Database (.properties and .script) as data and XML file DBDef.xml as TreeGrid layout
Uses routines in TreeGridFramework.jsp to load and save data
! Check if JAVA application has write access to ../Database.properties and ../Database.script files
! Don't forget to copy hsqldb.jar file to JAVA shared lib directory
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","",true);

// --- Save data to database ---
org.w3c.dom.Element[] Ch = getChanges(request.getParameter("TGData"));
if(Ch!=null){
   try {
      for(int i=0;i<Ch.length;i++){
         org.w3c.dom.Element I = Ch[i];
         String id = getId(I); if(id.equals("")) continue; // Error
         if(isDeleted(I)){ // Deleting
	         Cmd.executeUpdate("DELETE FROM TableData WHERE ID="+id);  
            }
         else if(isAdded(I)){ // Adding
            String[] Names = {"id","Project","Resource","Week","Hours"};
            boolean[] IsString = {false,true,true,false,false};
            Cmd.executeUpdate("INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES(" + toSQLInsert(I,Names,IsString) + ")");
            }
         else if(isChanged(I)){ // Updating
            String[] Names = {"Project","Resource","Week","Hours"};
            boolean[] IsString = {true,true,false,false};
            Cmd.executeUpdate("UPDATE TableData SET " + toSQLUpdate(I,Names,Names,IsString) + " WHERE ID=" + id);
            }
         }
      }
   catch(Exception ex){
      out.print("Error in saving data !<br>");
      out.print(ex.getMessage());
      }
   }

// --- Load data from database ---
java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM TableData");
String[] Names = {"id","Project","Resource","Week","Hours"};
String Str = toHTMLString(getTableXML(R,Names));
R.close();
//------------------------------------------------------------------------------------------------------------------
%><html>
   <head>
      <script src="../../../Grid/GridE.js"> </script>
      <link href="../../../Styles/Examples.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <h2>Using TreeGrid JSP framework</h2>
      <div style="WIDTH:100%;HEIGHT:90%">
         <bdo 
				Layout_Url="DBDef.xml" 
				Data_Tag="TGData" 
				Upload_Tag="TGData" Upload_Format="Internal"
				Export_Url="../Framework/Export.jsp" Export_Data="TGData" Export_Param_File="Table.xls"
				></bdo>
      </div>
      <form method="post">
         <input name="TGData" type="hidden" value="<%=Str%>">
         <input type="submit" value="Submit changes to server"/>
      </form>
   </body>
</html>

