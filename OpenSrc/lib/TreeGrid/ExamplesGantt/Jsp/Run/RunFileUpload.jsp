<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%
//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

String XML = request.getParameter("Data"); if(XML==null) XML="";
if(!XML.equals("")){
   try {
       if(XML.charAt(0)=='&'){
         XML = XML.replaceAll("&lt;","<").replaceAll("&gt;",">").replaceAll("&amp;","&").replaceAll("&quot;","\"").replaceAll("&apos;","'");
         }
      String Path = application.getRealPath(request.getServletPath().replaceAll("[^\\/\\\\]*$","")); 
      java.io.FileWriter F = new java.io.FileWriter(Path + "/RunData.xml");
      F.write(XML);
      F.close();
      out.print("<Grid><IO Result='0'/></Grid>");
      }
   catch(Exception ex){
      out.print("Error in saving data !<br>");
      out.print(ex.getMessage());
      }
   }  
//------------------------------------------------------------------------------------------------------------------
%>
