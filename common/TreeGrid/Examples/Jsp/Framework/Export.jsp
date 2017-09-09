<%@page contentType="application/vnd.ms-excel"%><%@page pageEncoding="UTF-8"%><%
request.setCharacterEncoding("utf-8");
String file = request.getParameter("File"); 
if(file==null || file.equals("")) file="Export.xls";
response.addHeader("Content-Disposition","attachment; filename=\""+file+"\"");
response.addHeader("Cache-Control","max-age=1, must-revalidate");
String XML = request.getParameter("TGData"); if(XML==null) XML="";
if(XML.charAt(0)=='&'){
	XML = XML.replaceAll("&lt;","<").replaceAll("&gt;",">").replaceAll("&amp;","&").replaceAll("&quot;","\"").replaceAll("&apos;","'");
   }
out.print(XML);
%>