<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Framework.html instead !
  This file is used as both Data_Url and Upload_Url
  Generates data for TreeGrid when no data received or saves received changes to database
  Uses routines in TreeGridFramework.jsp to load and save data
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

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
      out.print("<Grid><IO Result='0'/></Grid>");
      }
   catch(Exception ex){
      out.print("Error in saving data !<br>");
      out.print(ex.getMessage());
      }
   }

// --- Load data from database ---
else {
   java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM TableData");
   String[] Names = {"id","Project","Resource","Week","Hours"};
   out.print(getTableXML(R,Names));
   R.close();
   }
//------------------------------------------------------------------------------------------------------------------
%>
