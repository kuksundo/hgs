<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Grid.html instead !
  This file is used as Upload_Url for TreeGrid
  It stores changed from TreeGrid to database
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

// --- Save data to database ---
org.w3c.dom.Element[] Ch = getChanges(request.getParameter("TGData"));
if(Ch!=null) {
   java.util.ArrayList Last = new java.util.ArrayList();
   
   for(int i=0;i<Ch.length;i++){
      org.w3c.dom.Element I = Ch[i];
      String[] id = getIds(I);
      
      // --- Project row ---
      if(id.length==1) {  
         String prj = toSQL(id[0]);
         String where = " WHERE Project=" + prj + " ";
         if(isDeleted(I)) { 
            Cmd.executeUpdate("DELETE FROM TableData" + where);  
            }
         else if(isAdded(I) || isChanged(I)) {
            if(I.hasAttribute("Project")) Last.add("UPDATE TableData SET Project=" + toSQL(I,"Project") + where);
            }            
         }   
      
      // --- Resource row ---
      else {
         String prj = toSQL(id[0]);
         String res = toSQL(id[1]);
         String where = " WHERE Project=" + prj + " AND Resource=" + res + " ";
         if(isDeleted(I)) {
            Cmd.executeUpdate("DELETE FROM TableData" + where);  
            }
         else if(isAdded(I) || isChanged(I)) {
            org.w3c.dom.NamedNodeMap A = I.getAttributes();
            for(int a=0;a<A.getLength();a++){
               org.w3c.dom.Node N = A.item(a);
               String name = N.getNodeName();
               if(name.charAt(0)=='W'){   // Hours number
                  String val = N.getNodeValue();
                  String week = name.substring(1);
                  java.sql.ResultSet R = Cmd.executeQuery("SELECT ID FROM TableData" + where + " AND Week=" + week);
                  if(!R.next()) {                // New item
                     R.close();
                     R = Cmd.executeQuery("SELECT MAX(ID) FROM TableData"); // Creates new id, but better is to define Id in database as incremental
                     R.next();
                     int w = R.getInt(1);
                     R.close();
                     Cmd.executeUpdate("INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES (" + String.valueOf(w+1) + "," + prj + "," + res + "," + week + "," + val + ")");
                     }
                  else {                 // Existing item
                     R.close();
                     Cmd.executeUpdate("UPDATE TableData SET Hours=" + val + where + " AND Week=" + week);
                     }
                  }
               }
            }
         if(I.hasAttribute("Project")) {   // Changed resource name
            Cmd.executeUpdate("UPDATE TableData SET Resource=" + toSQL(I,"Project") + where);
            }
         else if(isMoved(I)) {
            Cmd.executeUpdate("UPDATE TableData SET Project=" + toSQL(I,"Parent") + where);
            }
         }            
      }   
   
   // --- Delayed changing project names ---'
   // It must be done after changing all resources for the project
   for(int j=0;j<Last.size();j++) {
      Cmd.executeUpdate(Last.get(j).toString());
      }
   }

// --------------------------------------------------------------------------
%><?xml version="1.0"?>
<Grid>
   <IO Result='0'/>
</Grid>