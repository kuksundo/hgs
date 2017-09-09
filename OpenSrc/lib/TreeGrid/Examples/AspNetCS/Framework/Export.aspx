<%@ Page Language="C#" ContentType="application/vnd.ms-excel" %>
<% 
   string file = Request["File"]; if (file == null) file = "Export.xls"; 
   Response.AppendHeader("Content-Disposition","attachment; filename=\""+file+"\"");
   Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
   Response.Write(HttpUtility.HtmlDecode(Request["TGData"]));
%>