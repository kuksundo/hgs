<% 
' --- Response initialization ---
Session.Codepage=65001
Response.ContentType = "application/vnd.ms-excel"
Response.Charset= "utf-8"
Response.AddHeader "Cache-Control","max-age=1, must-revalidate"

' --- Send back the report ---
Dim file : file = Request.Form("File")
If file = "" Then file = "Export.xls"
Response.AddHeader "Content-Disposition", "attachment; filename=""" + file + """"
Response.Write Replace(Replace(Replace(Request.Form("TGData"),"&lt;","<"),"&gt;",">"),"&amp;","&")
%>