<%@ Page Language="vb" ContentType="application/vnd.ms-excel" %>
<% 
   Dim file As String
   file = Request("File")
   If file = Nothing Then file = "Export.xls"
   Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
   Response.AppendHeader("Content-Disposition", "attachment; filename=""" + file + """")
   Response.Write(HttpUtility.HtmlDecode(Request("TGData")))
%>