<%@page contentType="text/html"%><%@page pageEncoding="UTF-8"%><%
// --------------------------------------------------------------------------
  
// --- Response initialization ---
String Base = application.getRealPath(request.getServletPath().replaceAll("[^\\/\\\\]*$","")) + "\\TestFiles\\";
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Save data to disk ---
String File = request.getParameter("File");
String Data = request.getParameter("Data");
try {
   java.io.FileWriter W = new java.io.FileWriter(Base+File);
   W.write(Data.replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&"));
   W.close();
   out.print("OK");
   }
catch (Exception Ex) { out.print(Ex.getMessage()); }

// --------------------------------------------------------------------------
%>