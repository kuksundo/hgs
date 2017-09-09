<%
   '! Support file only, run AjaxTablePaging.html instead !
   ' This file is used as Export_Url
   ' Generates data to export to Excel
   ' Single file, without using TreeGridFramework.asp

' --- Response initialization ---
Session.Codepage=65001
Response.Charset= "utf-8"
Response.ContentType = "application/vnd.ms-excel"
SetLocale "en-us"
Dim file : file = Request("File") : If file = "" Then file = "Export.xls"
Response.AddHeader "Content-Disposition", "attachment; filename=""" + file + """"
Response.AddHeader "Cache-Control","max-age=1, must-revalidate"

' --- Databaze initialization ---
Dim Path
Path = Request.ServerVariables("PATH_TRANSLATED")
Path = Left(Path,InStrRev(Path,"\"))
Dim DB
Set DB = Server.CreateObject("ADODB.Connection")
DB.Open "DRIVER={Microsoft Access Driver (*.mdb)};DBQ="&Path&"Database.mdb"    'Database file has relative path to this page
Dim RS
Set RS = Server.CreateObject("ADODB.Recordset")

' --- Helper function parses string Str to array Arr, items in string are delimited by Del ---
Function ParseString(byval Str,byval Del, byref Arr)
if IsNull(Str) then exit function
dim start,pos,cnt
start=1 : cnt=0
pos = InStr(start,Str,Del)
do while pos>0
   Arr(cnt) = Mid(Str,start,pos-start)
   cnt = cnt+1
   start = pos+1
   pos = InStr(start,Str,Del)
loop
Arr(cnt) = Mid(Str,start,Len(Str)-start+1)
if Arr(cnt)<>"" then cnt = cnt+1
ParseString = cnt
End Function

' --- Parses TreeGrid configuration ---
Dim XML,X,E,S,cnt,pos,start,idx,SC(3),ST(3)
XML = Request.Form("TGData")
XML = Replace(Replace(Replace(XML,"&lt;","<"),"&gt;",">"),"&amp;","&")
If XML = "" Then XML = "<Grid><Cfg SortCols='Week,Hours' SortTypes='1,0'/><Cols><C Name='Project' Visible='1' Width='200'/><C Name='Resource' Visible='1' Width='150'/><C Name='Week' Visible='1' Width='60'/><C Name='Hours' Visible='1' Width='60'/></Cols></Grid>" ' Just for examples if called directly

set X = Server.CreateObject("Microsoft.XMLDOM")
X.LoadXml XML 

' --- Parses sorting settings ---
set E = X.getElementsByTagName("Cfg")
cnt = ParseString(E(0).GetAttribute("SortCols"),",",SC)
ParseString E(0).GetAttribute("SortTypes"),",",ST
S = ""
for i=0 to cnt-1
   if S<>"" then S = S & ", "
   S = S & SC(i)
   if CInt(ST(i)) >= 1  then S = S & " DESC"
next
if cnt then S = " ORDER BY " & S
  
' --- Parses Column position, visibility and width ---
set E = X.getElementsByTagName("C")  
Dim N(4), W(4), p : p = 0
   
For Each C In E
   If C.GetAttribute("Visible") <> "0" Then
      N(p) = C.GetAttribute("Name")
      W(p) = C.GetAttribute("Width")
      p = p + 1
   End If
Next

' --- Reads data from database ---
RS.Open "SELECT * FROM TableData" & S, DB, 1, 3, 1

' --- Writes Excel settings ---
Response.Write("<html xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:x=""urn:schemas-microsoft-com:office:excel"" xmlns=""http://www.w3.org/TR/REC-html40"">")
Response.Write("<head><meta http-equiv=Content-Type content=""text/html; charset=utf-8""></head><body>")
Response.Write("<style>td {white-space:nowrap}</style>")
Response.Write("<table border=1 bordercolor=silver style='table-layout:fixed;border-collapse:collapse;border:1px solid black'>")
   
' --- Writes columns' widths ---
For i = 0 To p - 1
   Response.Write("<col width='" + w(i) + "'>")
Next

' --- Writes captions ---
Response.Write("<tr>")
For i = 0 To p - 1
   Response.Write("<td style='border-bottom:1px solid black;background:yellow;font-weight:bold;'>" + N(i) + "</td>")
Next
Response.Write("</tr>")
   
' --- Writes data ---
Do While RS.EOF <> True
   Response.Write("<tr>")
   For i = 0 To p - 1
      If N(i) = "Resource" Or N(i) = "Project" Then ' string
         Response.Write("<td>" + Replace(Replace(Replace(CStr(RS.Fields(N(i)).Value),"&","&amp;"),"'","&apos;"),"<","&lt;") + "</td>")
      Else
         Response.Write("<td x:num='" + CStr(RS.Fields(N(i))) + "'>" + CStr(RS.Fields(N(i))) + "</td>")
      End If
   Next
   Response.Write("</tr>")
   RS.MoveNext
Loop

' ---
Response.Write("</table></body></html>")
' --------------------------------------------------------------------------
%>