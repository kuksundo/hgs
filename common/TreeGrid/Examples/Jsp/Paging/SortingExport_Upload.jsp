<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run SortingExport.html instead !
  This file is used as Upload_Url
  Saves received changes to database
  This is simple example, it simply reloads all body when rows are added or deleted instead of handling changes in pages
  Uses TreeGridFramework.jsp
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

// --- Save data to database ---
org.w3c.dom.Element[] Ch = getChanges(request.getParameter("TGData"));
if(Ch!=null){
   try {
      boolean reload = false;
      for(int i=0;i<Ch.length;i++){
         org.w3c.dom.Element I = Ch[i];
         String id = getId(I); if(id.equals("")) continue; // Error
         if(isDeleted(I)){ // Deleting
	         Cmd.executeUpdate("DELETE FROM TableData WHERE ID="+id);  
            reload = true;
            }
         else if(isAdded(I)){ // Adding
            String[] Names = {"id","Project","Resource","Week","Hours"};
            boolean[] IsString = {false,true,true,false,false};
            Cmd.executeUpdate("INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES(" + toSQLInsert(I,Names,IsString) + ")");
            reload = true;
            }
         else if(isChanged(I)){ // Updating
            String[] Names = {"Project","Resource","Week","Hours"};
            boolean[] IsString = {true,true,false,false};
            Cmd.executeUpdate("UPDATE TableData SET " + toSQLUpdate(I,Names,Names,IsString) + " WHERE ID=" + id);
            }
         }
      out.print("<Grid><IO Result='0' Reload='" + (reload?"1":"0") + "'/></Grid>");
      }
   catch(Exception ex){
      out.print("Error in saving data !<br>");
      out.print(ex.getMessage());
      }
   }
else out.print("<Grid><IO Result='0'/></Grid>");
//------------------------------------------------------------------------------------------------------------------
%>
